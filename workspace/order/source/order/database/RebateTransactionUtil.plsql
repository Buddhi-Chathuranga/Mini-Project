-----------------------------------------------------------------------------
--
--  Logical unit: RebateTransactionUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201108  RasDlk   SCZ-11661, Modified Create_Rebate_Transactions___() by removing rebate_criteria from a condition so that invoiced_qty_, net_weight_ and net_volume_ wil be zero for any criteria.
--  201108           Modified Set_Incl_In_Period_Settlement() and Set_Incl_In_Final_Settlement)() by checking part_no is NULL when agreement_type_ is DB_ALL.
--  201015  ErRalk   Bug 155361(SCZ-11071), Modified Set_Incl_In_Period_Settlement() and Set_Incl_In_Final_Settlement)() to handle agreement type DB_ALL. 
--  200324  ErFelk   Bug 152189(SCZ-8768), Modified Create_Rebate_Transactions___() by making invoiced_qty_, net_weight_ and net_volume_ negative if it is coming from RMA.   
--  200224  ErFelk   Bug 152189(SCZ-8768), Modified Create_Rebate_Transactions___() by making invoiced_qty_, net_weight_ and net_volume_ to zero if it is a price_adjustment.   
--  200211  KiSalk   Bug 150067(SCZ-7093), Added out parameter transactions_created_ to method Create_Rebate_Transactions to indicate whether Transactions were created or not.
--  200211           Added parameter overloaded Create_Rebate_Transactions for reverse compatibility.
--  191128  ErFelk   Bug 150868(SCZ-7740), Modified Create_Rebate_Transactions___() so that transaction is created if there is a value to total_rebate_amount.  
--  190905  ErRalk   Bug 149832(SCZ-6596), Modified Create_Rebate_Transactions___, Create_Sales_Part_Trans___, Create_All_Parts_Trans___, Create_Rebate_Group_Trans___, Create_Assortment_Trans___,
--  190905           and Create_Rebate_Transactions methods by changing co_line_adj_weight_net_ into co_line_total_weight_ and co_line_adjusted_volume_ into co_line_total_volume_ 
--  190905           to calculate rebate transaction based on net weight, net volume of a  part.
--  190524  ChBnlk   Bug 147788 (SCZ-4335), Modified Create_Rebate_Transactions(), Create_Rebate_Group_Trans___() and Create_Assortment_Trans___() in order to consider the invoice date instead of
--  190524           sysdate to create the proper rebate transactions.
--  181020  ChBnlk   Bug 144041, Modified Create_Rebate_Transactions() and Get_Customer_Rebate_Info() in order to use invoice date instead of the sysdate when fetching the active agreement 
--  181020           so the rebate transactions will be created properly. 
--  170512  AmPalk   STRMF-11637, Valid_To_Date introduced in to Rebate Agreement deals level.
--  170322  ThImlk   STRMF-10448, Modified Create_Rebate_Transactions___() to consider invoiced_qty, net_weight and net_volume when generating rebate transactions, for parts which are not defined in agreement .    
--  170307  AmPalk   STRMF-6615, In order to reflect the changes in Rebate_Agreement_Receiver_API.Get_Active_Agreement with multiple active agreement handling,
--  170307           Changed Create_Sales_Part_Trans___, Create_All_Parts_Trans___, Create_Rebate_Group_Trans___, Create_Assortment_Trans___, Create_Rebate_Transactions, Get_Customer_Rebate_Info.
--  170303  ThImlk   STRMF-9388, Modified Create_Sales_Part_Trans___() and Create_All_Parts_Trans___() to create dummy rebate transactions.
--  170217  NiNilk   Bug 132647, Modified Create_Assortment_Trans___() to create dummy rebate transactions.
--  170215  ThImlk   STRMF-9738, Modified Create_Rebate_Group_Trans___() to correctly create dummy transactions, when using hierarchy customers.
--  170209  NiNilk   Bug 132647, Modified method Create_Rebate_Group_Trans___ to create dummy rebate transactions.
--  170208  AmPalk   STRMF-6864, Passed in line number, release number and line item number to the Rebate_Transaction_API.NEW method calls. 
--  170131  ThImlk   STRMF-9389, Modified methods Create_Rebate_Transactions___, Create_Sales_Part_Trans___, Create_All_Parts_Trans___, Create_Rebate_Group_Trans___, Create_Assortment_Trans___
--  170131           and Add_Final_Rebate() to handle when multiple currencies used in company, customer order and rebate agreement. 
--  170119  NiDalk   STRSC-3939, Removed use price including vat from rebate functionality.
--  170110  ThImlk   STRMF-8404, Modified Add_Final_Rebate() to consider rebate criteria when generating the final settlement.
--  170109  ThImlk   STRMF-8964, Modified Create_Rebate_Transactions___() to consider invoiced_qty, net_weight and net_volume when generating rebate transactions.
--  170104  ThImlk   STRMF-8398, Modified Create_Rebate_Transactions___() to consider rebate criteria when generating rebate transactions.
--  161117  ThImlk   STRMF-7700, Modified Set_Incl_In_Period_Settlement() to add part_no_ and sales_unit_meas_ parameters. 
--  161110  RaKalk   STRMF-7697, Added methods Create_Sales_Part_Trans___, Create_All_Parts_Trans___, made Create_Rebate_Group_Trans and Create_Assortment_Trans implementation methods.
--  160826  NiDalk   Bug 131026, Modified Add_Final_Rebate, Create_Rebate_Group_Trans and Create_Assortment_Trans to calculate rebate amounts based on net amount. As tax is not a cost
--  160826           it is not necessary to change the calculation when using price including tax.
--  150722  ChJalk   Bug 123268, Added method Get_Customer_Rebate_Info and modified the method Create_Rebate_Transactions to correctly create the rebate transactions 
--  150722           for the invoice types 'CUSTCOLDEB' and 'CUSTCOLCRE'.
--  130212  ShKolk   Modified methods Set_Incl_In_Period_Settlement, Set_Incl_In_Final_Settlement, Add_Final_Rebate to consider use_price_incl_tax.
--  130211  ShKolk   Modified Create_Rebate_Transactions() to calculate gross amount from net_dom_amount and vat_dom_amount.
--  130211           Modified rebate_amount and cost calculations in Create_Rebate_Group_Trans() and Create_Assortment_Trans() to consider use_price_incl_tax.
--  121212  AyAmlk   Bug 107264, Modified Create_Rebate_Transactions() to get the Tax Free Tax Code as the value for Tax Code when creating Rebate
--  121212           Credit Invoice in a Mixed Tax Regime.
--  110208  MaMalk   Replaced some of the method calls to Customer_Info_Vat_API with Customer_Tax_Info_API.
--  100617  ChFolk   Modified Create_Rebate_Transactions to fetch vat_code for rebate transaction when tax regime is MIX or Vat with Surcharge. 
--  100423  ChFolk   Modified Set_Incl_In_Period_Settlement, Set_Incl_In_Final_Settlement and Add_Final_Rebate to support
--  100423           the records with null tax codes. Modified Create_Rebate_Transactions to avoid inserting Sales Tax into Rebate Transaction.
--  100308  JeLise   Bug 88924, Modified methods Create_Rebate_Group_Trans and Create_Assortment_Trans by introducing 
--  100308           rebate_type to filter records when creating rebate_transactions. 
--  100308  JeLise   Bug 88924, Modified methods Create_Rebate_Group_Trans and Create_Assortment_Trans by introducing  
--  100308           rebate_type to filter records when creating rebate_transactions. 
--  091228  AmPalk   Bug 85942, Valid From became a key on agreement lines.  Modified filtering logic in Create_Rebate_Group_Trans and in Create_Assortment_Trans accordingly.
--  091123  NWeelk   Bug 87135, Modified methods Create_Rebate_Group_Trans to create rebate transactions correctly.
--  091030  NWeelk   Bug 86134, Modified methods Create_Rebate_Group_Trans and Create_Assortment_Trans to enable creating rebate  
--  091030           transactions for the parent customer, when there are no agreement lines for the lower level customer and
--  091030           changed the logic for creating '*' transactions.
--  091125  MAHPLK   Modified Create_Rebate_Transactions to check the rc_hierarchy_id_ is not null before create transactions for additional rebate customer.
--  090824  HimRlk   Added a check on charge_seq_no_ to avoid charge lines in Create_Rebate_Transactions().
--  090731  HimRlk   Merged Bug 81245, Modified the methods Set_Incl_In_Period_Settlement and Set_Incl_In_Final_Settlement to use the same update 
--  090731           statement for the transactions with both Assortment and sales part rebate group.
--  081022  JeLise   Added another check on agreement_id_ in Create_Rebate_Transactions. Also added check on 
--  081022           rebate_builder_db_ in Create_Rebate_Transactions.
--  081021  JeLise   Added creation of transactions even if no agreement line exist for a specific sales_part_rebate_group
--  081021           or assortment_id in Create_Rebate_Group_Trans resp. Create_Assortment_Trans. Also made changes in 
--  081021           Set_Incl_In_Period_Settlement and Set_Incl_In_Final_Settlement to get these lines included too.
--  081015  JeLise   Added check on aggregation_no in Set_Incl_In_Period_Settlement and Set_Incl_In_Final_Settlement.
--  081014  JeLise   Added invoice_id and item_id as in parameters in Add_Final_Rebate.
--  080926  JeLise   Removed check on rebate_builder in Create_Rebate_Transactions. Also removed some checks in
--  080926           Create_Assortment_Trans.
--  080915  JeLise   Made changes in Create_Rebate_Transactions, Create_Assortment_Trans and Create_Rebate_Group_Trans.
--  080820  JeLise   Added EXIT WHEN in search for agreement_id_ in Create_Rebate_Transactions.
--  080818  JeLise   Changed the declaration of assortment_node_ from varchar to varchar2 in Create_Assortment_Trans.
--  080625  JeLise   Added loop to find parents agreement_id_ in Create_Rebate_Transactions.
--  080623  JeLise   Made smaller changes for RMA in Create_Rebate_Transactions and Create_Rebate_Group_Trans.
--  080617  JeLise   Added rma_no_ in Create_Rebate_Transactions, Create_Rebate_Group_Trans and Create_Assortment_Trans.
--  080617           Added call to Return_Material_Line_API.Get_Rebate_Builder in Create_Rebate_Transactions.
--  080616  JeLise   Made changes in Create_Rebate_Transactions to handle rebate_customer_.
--  080613  JeLise   Added fetch of customer_level_ for rebate_customer_ in Create_Rebate_Transactions.
--  080611  JeLise   Added methods Create_Rebate_Group_Trans and Create_Assortment_Trans and calls to them in
--  080611           Create_Rebate_Transactions. Added code to handle creation of transactions for additional rebate customer.
--  080610  JeLise   Added check on assortment_node_id in Create_Rebate_Transactions.
--  080609  JeLise   Changed from INSERT INTO to calling Rebate_Transaction_API.New in Create_Rebate_Transactions.
--  080605  AmPalk   Added Get_Total_Reb_Amt_For_Inv_Line, Get_Assort_Id_For_Inv_Line, Get_Assort_Node_For_Inv_Line and Get_Rebate_Grp_For_Inv_Line.
--  080513  JeLise   Added invoice_id when inserting into rebate_transaction_tab in Create_Rebate_Transactions.
--  080430  JeLise   Added customer_parent_ in Create_Rebate_Transactions to make sure that only transactions for the
--  080430           correct level are created.
--  080429  JeLise   Changed check on agreement_id_ in Create_Rebate_Transactions.
--  080429  MaJalk   Modified Create_Rebate_Transactions to prevent creation of
--  080429           rebate transactions if rebate builder in CO line is FALSE.
--  080425  JeLise   Adjusted check on agreement_id in Create_Rebate_Transactions.
--  080424  JeLise   Changed Set_Incl_In_Period_Settlement and Set_Incl_In_Final_Settlement to store the aggregation_no instead.
--  080424           Added part_no to be inserted in Create_Rebate_Transactions.
--  080424  JeLise   Added check on agreement_id_ in Create_Rebate_Transactions.
--  080415  JeLise   Added check on rebate_rate_ in Add_Final_Rebate.
--  080414  JeLise   Updated Add_Final_Rebate.
--  080411  JeLise   Added method Add_Final_Rebate.
--  080411  JeLise   Changed from invoice_id to invoice_no in insert statement in Create_Rebate_Transactions.
--  080409  JeLise   Added method Set_Incl_In_Final_Settlement.
--  080407  JeLise   Removed header_customer_level_ in Create_Rebate_Transactions.
--  080404  JeLise   Added fetch of active agreement for the parent customer in Create_Rebate_Transactions.
--  080403  MiKulk   Added code to handle hierarchy_id_ = '*' in Create_Rebate_Transactions.
--  080401  JeLise   Changed sequence to rebate_transaction_id_seq in insert in Create_Rebate_Transactions.
--  080331  JeLise   Removed method Get_Last_Run_Date.
--  080326  JeLise   Added call to Customer_Order_Inv_Head_API.Get_Invoice_No_By_Id in Create_Rebate_Transactions.
--  080318  JeLise   Added trunc when saving transaction_date.
--  080317  JeLise   Changed from customer_no_ to customer_id_ in call to Cust_Hierarchy_Struct_API.Get_Parent_Cust.
--  080312  JeLise   Changed view in cursor get_agreement_lines in Create_Rebate_Transactions.
--  080303  JeLise   Added new methods Get_Last_Run_Date and Set_Incl_In_Period_Settlement.
--  080225  JeLise   Changed name from Create_Rebate_Transaction to Create_Rebate_Transactions and
--  080225           added check on if sales_part_rebate_group_ is not null.
--  080222  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


TYPE Agreement_Line_Rec IS RECORD (
   rebate_rate             NUMBER,
   rebate_cost             NUMBER,
   periodic_rebate_amount  NUMBER,
   rebate_cost_amount      NUMBER);
TYPE Agreement_Line_Table IS TABLE OF Agreement_Line_Rec  INDEX BY PLS_INTEGER;   

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_Rebate_Transactions___ (
   company_                      IN VARCHAR2,
   invoice_no_                   IN VARCHAR2,
   item_id_                      IN NUMBER,
   customer_no_                  IN VARCHAR2,
   hierarchy_id_                 IN VARCHAR2,
   customer_level_               IN NUMBER,
   assortment_id_                IN VARCHAR2,
   assortment_node_id_           IN VARCHAR2,
   agreement_id_                 IN VARCHAR2,
   agreement_type_db_            IN VARCHAR2,
   sales_part_rebate_group_      IN VARCHAR2,
   rebate_type_                  IN VARCHAR2,
   inv_line_sales_amount_        IN NUMBER,
   inv_line_sales_gross_amount_  IN NUMBER,
   inv_line_sales_cur_amt_       IN NUMBER,
   inv_line_sales_gross_cur_amt_ IN NUMBER,
   tax_code_                     IN VARCHAR2,
   pos_                          IN NUMBER,
   contract_                     IN VARCHAR2,
   order_no_                     IN VARCHAR2,
   line_no_                     IN VARCHAR2, 
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                      IN VARCHAR2,
   sales_unit_meas_              IN VARCHAR2,
   invoice_id_                   IN NUMBER,
   rma_no_                       IN NUMBER,
   agreement_lines_tab_          IN Agreement_Line_Table,
   inv_line_invoiced_qty_        IN NUMBER,
   co_line_revised_qty_due_      IN NUMBER,
   co_line_total_weight_         IN NUMBER,
   co_line_total_volume_         IN NUMBER)
IS
   total_rebate_amount_                NUMBER;
   total_rebate_cost_amount_           NUMBER;
   transaction_date_                   DATE := TRUNC(SYSDATE);
   rebate_criteria_db_                 rebate_agreement_tab.rebate_criteria%TYPE;
   agreement_uom_                      rebate_agreement_tab.unit_of_measure%TYPE;
   inv_part_uom_for_weight_            VARCHAR2(30);
   inv_part_uom_for_volume_            VARCHAR2(30);
   net_weight_                         NUMBER := 0;
   net_volume_                         NUMBER := 0;
   calc_inv_line_sales_amount_         NUMBER;
   calc_inv_line_sales_gro_amt_        NUMBER;
   cur_inv_line_sales_amount_          NUMBER;
   cur_inv_line_sales_gro_amt_         NUMBER;
   currency_rate_                      NUMBER;
   agreement_currency_code_            VARCHAR2(3);
   company_currency_code_              VARCHAR2(3);
   cust_ord_currency_code_             VARCHAR2(3);
   currency_rounding_                  NUMBER;
   periodic_rebate_amount_             NUMBER := NULL;
   rebate_cost_amount_                 NUMBER := NULL;
   co_inv_head_rec_                    Customer_Order_Inv_Head_API.Public_Rec;
   invoiced_qty_                       NUMBER;
BEGIN
   agreement_currency_code_  := Rebate_Agreement_API.Get_Currency_Code(agreement_id_);
   rebate_criteria_db_       := Rebate_Agreement_API.Get_Rebate_Criteria_Db(agreement_id_);
   company_currency_code_    := Company_Finance_API.Get_Currency_Code(company_);
   cust_ord_currency_code_   := Customer_Order_API.Get_Currency_Code(order_no_);
   currency_rounding_        := Currency_Code_API.Get_Currency_Rounding(company_, agreement_currency_code_);
   co_inv_head_rec_          := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);
   
   IF((agreement_currency_code_ = cust_ord_currency_code_) AND (agreement_currency_code_ != company_currency_code_)) THEN
      calc_inv_line_sales_amount_         := inv_line_sales_cur_amt_;
      calc_inv_line_sales_gro_amt_        := inv_line_sales_gross_cur_amt_; 
   ELSIF(((agreement_currency_code_ != cust_ord_currency_code_) AND (agreement_currency_code_ != company_currency_code_) AND (cust_ord_currency_code_ != company_currency_code_))
      OR ((company_currency_code_ = cust_ord_currency_code_) AND (agreement_currency_code_ != company_currency_code_)))THEN
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(cur_inv_line_sales_amount_, currency_rate_, customer_no_, contract_,
                                                            agreement_currency_code_, inv_line_sales_amount_);
      Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(cur_inv_line_sales_gro_amt_, currency_rate_, customer_no_, contract_,
                                                            agreement_currency_code_, inv_line_sales_gross_amount_);    
      
      calc_inv_line_sales_amount_         := cur_inv_line_sales_amount_;
      calc_inv_line_sales_gro_amt_        := cur_inv_line_sales_gro_amt_;       
   ELSE
      calc_inv_line_sales_amount_         := inv_line_sales_amount_;
      calc_inv_line_sales_gro_amt_        := inv_line_sales_gross_amount_; 
   END IF;
   
   net_weight_          := (co_line_total_weight_ * (inv_line_invoiced_qty_ /co_line_revised_qty_due_));
   net_volume_          := (co_line_total_volume_ * (inv_line_invoiced_qty_/co_line_revised_qty_due_));
   
   invoiced_qty_ := inv_line_invoiced_qty_;
   IF (co_inv_head_rec_.price_adjustment = 'TRUE') THEN
      invoiced_qty_  := 0;
      net_weight_    := 0;
      net_volume_    := 0;           
   END IF;
   IF (rma_no_ IS NOT NULL) THEN            
      IF (Invoice_API.Is_Correction_Invoice(company_, invoice_id_) = 'FALSE') THEN                
         invoiced_qty_ := invoiced_qty_ * -1;
         net_weight_   := net_weight_ * -1;
         net_volume_   := net_volume_ * -1;
      END IF;            
   END IF; 
   
   IF agreement_lines_tab_.COUNT > 0 THEN
      -- Get rebate_rate for all agreement lines for sales part rebate group
      FOR i_ IN agreement_lines_tab_.FIRST .. agreement_lines_tab_.LAST LOOP
         
         periodic_rebate_amount_ := agreement_lines_tab_(i_).periodic_rebate_amount;
         rebate_cost_amount_     := agreement_lines_tab_(i_).rebate_cost_amount; 
                
         CASE rebate_criteria_db_
            WHEN 'PERCENTAGE' THEN
               -- Rebate Amount/Base = Invoce line Net Amount/Base * Rebate Rate (%)
               total_rebate_amount_       := calc_inv_line_sales_amount_ * (agreement_lines_tab_(i_).rebate_rate/100);
               total_rebate_cost_amount_  := calc_inv_line_sales_amount_ * (agreement_lines_tab_(i_).rebate_cost/100); 
            WHEN 'AMOUNT_PER_INVOICED_QTY' THEN
               total_rebate_amount_       := invoiced_qty_ * periodic_rebate_amount_;
               total_rebate_cost_amount_  := invoiced_qty_ * rebate_cost_amount_;
            WHEN 'AMOUNT_PER_NET_WEIGHT' THEN
               agreement_uom_           := Rebate_Agreement_API.Get_Unit_Of_Measure(agreement_id_);
               inv_part_uom_for_weight_ := Company_Invent_Info_API.Get_Uom_For_Weight(company_);

               IF(agreement_uom_ != inv_part_uom_for_weight_) THEN
                  net_weight_ := Iso_Unit_API.Get_Unit_Converted_Quantity(net_weight_, inv_part_uom_for_weight_, agreement_uom_);
               END IF;     
               total_rebate_amount_       := net_weight_ * periodic_rebate_amount_;
               total_rebate_cost_amount_  := net_weight_ * rebate_cost_amount_;   
            WHEN 'AMOUNT_PER_NET_VOLUME' THEN
               agreement_uom_ := Rebate_Agreement_API.Get_Unit_Of_Measure(agreement_id_);
               inv_part_uom_for_volume_ := Company_Invent_Info_API.Get_Uom_For_Volume(company_);

               IF(agreement_uom_ != inv_part_uom_for_volume_) THEN
                  net_volume_ := Iso_Unit_API.Get_Unit_Converted_Quantity(net_volume_, inv_part_uom_for_volume_, agreement_uom_);
               END IF;     
               total_rebate_amount_       := net_volume_ * periodic_rebate_amount_;
               total_rebate_cost_amount_  := net_volume_ * rebate_cost_amount_;      
         END CASE;  

         total_rebate_amount_       := ROUND(total_rebate_amount_, currency_rounding_);
         total_rebate_cost_amount_  := ROUND(total_rebate_cost_amount_, currency_rounding_); 
         
         IF (total_rebate_amount_ IS NOT NULL) THEN
            -- Create Rebate Transactions
            Rebate_Transaction_API.NEW(company_,
                                       invoice_no_,
                                       item_id_,
                                       customer_no_,
                                       hierarchy_id_,
                                       customer_level_,
                                       assortment_id_,
                                       assortment_node_id_,
                                       agreement_id_,
                                       agreement_type_db_,
                                       sales_part_rebate_group_,
                                       rebate_type_,
                                       agreement_lines_tab_(i_).rebate_rate,
                                       total_rebate_amount_,
                                       agreement_lines_tab_(i_).rebate_cost,
                                       total_rebate_cost_amount_,
                                       inv_line_sales_amount_,
                                       inv_line_sales_gross_amount_,
                                       calc_inv_line_sales_amount_,
                                       calc_inv_line_sales_gro_amt_,
                                       tax_code_,
                                       transaction_date_,
                                       pos_,
                                       contract_,
                                       order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       part_no_,
                                       sales_unit_meas_,                               -- sales_uom
                                       invoice_id_,
                                       rma_no_,
                                       agreement_lines_tab_(i_).periodic_rebate_amount,
                                       agreement_lines_tab_(i_).rebate_cost_amount,
                                       nvl(invoiced_qty_,0),
                                       nvl(net_weight_,0),
                                       nvl(net_volume_,0));
         END IF;                              
      END LOOP;
   ELSE
      -- Create a transaction even if there is no agreement lines
      -- (used when calculating Final Rebate Rate) 
      
      -- Create Rebate Transactions
      Rebate_Transaction_API.NEW(company_,
                                 invoice_no_,
                                 item_id_,
                                 customer_no_,
                                 hierarchy_id_,
                                 customer_level_,
                                 assortment_id_,
                                 assortment_node_id_,
                                 agreement_id_,
                                 agreement_type_db_,
                                 sales_part_rebate_group_,
                                 '*',                                -- rebate_type
                                 0,                                  -- rebate_rate
                                 0,                                  -- total_rebate_amount
                                 0,                                  -- rebate_cost
                                 0,                                  -- total_rebate_cost_amount
                                 inv_line_sales_amount_,
                                 inv_line_sales_gross_amount_,
                                 calc_inv_line_sales_amount_,
                                 calc_inv_line_sales_gro_amt_,
                                 tax_code_,
                                 transaction_date_,
                                 pos_,
                                 contract_,
                                 order_no_,
                                 line_no_,
                                 rel_no_,
                                 line_item_no_,
                                 part_no_,
                                 sales_unit_meas_,                               -- sales_uom
                                 invoice_id_,
                                 rma_no_,
                                 0,
                                 0,
                                 nvl(invoiced_qty_,0),
                                 nvl(net_weight_,0),
                                 nvl(net_volume_,0));
   END IF;
END Create_Rebate_Transactions___;

PROCEDURE Create_Sales_Part_Trans___ (
   company_                     IN VARCHAR2,
   invoice_no_                  IN VARCHAR2,
   item_id_                     IN NUMBER,
   customer_no_                 IN VARCHAR2,
   hierarchy_id_                IN VARCHAR2,
   customer_level_              IN NUMBER,
   agreement_id_                IN VARCHAR2,
   inv_line_sales_amount_       IN NUMBER,
   inv_line_sales_gross_amount_ IN NUMBER,
   inv_line_sales_cur_amt_       IN NUMBER,
   inv_line_sales_gross_cur_amt_ IN NUMBER,
   tax_code_                    IN VARCHAR2,
   pos_                         IN NUMBER,
   contract_                    IN VARCHAR2,
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2, 
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                     IN VARCHAR2,
   rma_no_                      IN NUMBER,
   invoice_id_                  IN NUMBER,
   parent_customer_no_          IN VARCHAR2,
   rebate_customer_             IN VARCHAR2,
   sales_part_rebate_group_     IN VARCHAR2,
   inv_line_invoiced_qty_       IN NUMBER,
   co_line_buy_qty_due_         IN NUMBER,
   co_line_total_weight_        IN NUMBER,
   co_line_total_volume_        IN NUMBER)
IS
   parent_agremeent_list_     Rebate_Agreement_API.Agreement_Info_List;
   parent_cust_level_         NUMBER;
   parent_customer_           Rebate_Transaction_Tab.customer_no%TYPE;
   sales_unit_meas_           rebate_agr_sales_part_deal_tab.sales_unit_meas%TYPE := sales_Part_API.Get_Sales_Unit_Meas(contract_, part_no_);
   rebate_types_              rebate_agr_sales_part_deal_tab.rebate_type%TYPE;
   
   -- Get distinct rebate_types per sales_part_rebate_group. 
   CURSOR get_rebate_type IS
      SELECT DISTINCT (rebate_type)
      FROM rebate_agr_sales_part_deal_tab
      WHERE agreement_id = agreement_id_
      AND   catalog_no = part_no_
      AND   sales_unit_meas = sales_unit_meas_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));  
   
   -- Cursor to retrive the rebate agreement lines when the hierarchy is not defined in the header.
   CURSOR get_agreement_lines (rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agr_sales_part_deal_tab
      WHERE agreement_id = agreement_id_
      AND   catalog_no = part_no_
      AND   sales_unit_meas = sales_unit_meas_
      AND   rebate_type = rebate_type_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agr_sales_part_deal_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.catalog_no = part_no_
                              AND t2.sales_unit_meas = sales_unit_meas_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(SYSDATE) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));

   -- Get distinct rebate_types per sales_part_rebate_group when a hierarchy is defined. 
   CURSOR get_rebate_type_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2,
                                     customer_level_ IN NUMBER) IS
      SELECT DISTINCT (rebate_type)
      FROM rebate_agr_sales_part_deal_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   catalog_no = part_no_
      AND   sales_unit_meas = sales_unit_meas_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));
   
   -- Cursor to retrieve the rebate agreement lines when hierarchy is defined.
   CURSOR get_agreement_lines_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2,
                                         customer_level_ IN NUMBER, rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agr_sales_part_deal_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   catalog_no = part_no_
      AND   sales_unit_meas = sales_unit_meas_
      AND   rebate_type = rebate_type_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agr_sales_part_deal_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.hierarchy_id = hierarchy_id_
                              AND t2.catalog_no = part_no_
                              AND t2.sales_unit_meas = sales_unit_meas_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(SYSDATE) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));
                              
   agreement_lines_tab_ Agreement_Line_Table;
BEGIN
   -- parent_agreement_, parent_cust_level_ and parent_customer_ are used and updated when
   -- creating transactions with customer levels
   parent_agremeent_list_(1).agreement_id := agreement_id_;
   parent_customer_  := parent_customer_no_;
   IF rebate_customer_ = 'FALSE' THEN
      parent_cust_level_ := customer_level_;
   ELSE
      -- Must be 1 to create a line
      parent_cust_level_ := 1;
   END IF;

   -- If the rebate agreement doesn't have a hierarchy in the header
   IF hierarchy_id_ = '*' THEN
      OPEN get_rebate_type;
      FETCH get_rebate_type INTO rebate_types_;
      IF get_rebate_type%FOUND THEN
         CLOSE get_rebate_type;
         FOR rebate_type_ IN get_rebate_type LOOP
            agreement_lines_tab_.DELETE;
            OPEN get_agreement_lines (rebate_type_.rebate_type);
            FETCH get_agreement_lines BULK COLLECT INTO agreement_lines_tab_;
            CLOSE get_agreement_lines;

            Create_Rebate_Transactions___ (company_,
                                           invoice_no_,
                                           item_id_,
                                           customer_no_,
                                           '*',                                -- hierarchy_id
                                           0,                                  -- customer_level
                                           NULL,                               -- assortment_id
                                           NULL,                               -- assortment_node_id
                                           agreement_id_,
                                           Rebate_Agreement_Type_API.DB_SALES_PART,
                                           sales_part_rebate_group_,
                                           rebate_type_.rebate_type,
                                           inv_line_sales_amount_,
                                           inv_line_sales_gross_amount_,  
                                           inv_line_sales_cur_amt_,
                                           inv_line_sales_gross_cur_amt_,
                                           tax_code_,
                                           pos_,
                                           contract_,
                                           order_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           part_no_,
                                           sales_unit_meas_,
                                           invoice_id_,
                                           rma_no_,
                                           agreement_lines_tab_,
                                           inv_line_invoiced_qty_,
                                           co_line_buy_qty_due_,
                                           co_line_total_weight_,
                                           co_line_total_volume_);
         END LOOP;
      ELSE
         CLOSE get_rebate_type;
         Create_Rebate_Transactions___ (company_,
                                        invoice_no_,
                                        item_id_,
                                        customer_no_,
                                        '*',                                -- hierarchy_id
                                        0,                                  -- customer_level
                                        NULL,                               -- assortment_id
                                        NULL,                               -- assortment_node_id
                                        agreement_id_,
                                        Rebate_Agreement_Type_API.DB_SALES_PART,
                                        sales_part_rebate_group_,
                                        '*',
                                        inv_line_sales_amount_,
                                        inv_line_sales_gross_amount_,  
                                        inv_line_sales_cur_amt_,
                                        inv_line_sales_gross_cur_amt_,
                                        tax_code_,
                                        pos_,
                                        contract_,
                                        order_no_,
                                        line_no_,
                                        rel_no_,
                                        line_item_no_,
                                        part_no_,
                                        sales_unit_meas_,
                                        invoice_id_,
                                        rma_no_,
                                        agreement_lines_tab_,
                                        inv_line_invoiced_qty_,
                                        co_line_buy_qty_due_,
                                        co_line_total_weight_,
                                        co_line_total_volume_);
      END IF;   
   ELSE
      -- Retrieve the rebates from the hierarchy levels
      WHILE parent_cust_level_ > 0 LOOP
         IF (parent_agremeent_list_.COUNT > 0 ) THEN
            FOR i_ IN 1 .. parent_agremeent_list_.COUNT LOOP 
               OPEN get_rebate_type_for_level(parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_);
               FETCH get_rebate_type_for_level INTO rebate_types_;
               IF get_rebate_type_for_level%FOUND THEN
                  CLOSE get_rebate_type_for_level;
                  FOR rebate_type_ IN get_rebate_type_for_level (parent_agremeent_list_(i_).agreement_id
                                                                  , hierarchy_id_
                                                                  , customer_level_) LOOP

                     agreement_lines_tab_.DELETE;
                     OPEN get_agreement_lines_for_level(parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_, 
                                                        rebate_type_.rebate_type);
                     FETCH get_agreement_lines_for_level BULK COLLECT INTO agreement_lines_tab_;
                     CLOSE get_agreement_lines_for_level;

                     Create_Rebate_Transactions___ (company_,
                                                    invoice_no_,
                                                    item_id_,
                                                    parent_customer_,
                                                    hierarchy_id_,
                                                    customer_level_,
                                                    NULL,                               -- assortment_id
                                                    NULL,                               -- assortment_node_id
                                                    parent_agremeent_list_(i_).agreement_id,
                                                    Rebate_Agreement_Type_API.DB_SALES_PART,
                                                    sales_part_rebate_group_,
                                                    rebate_type_.rebate_type,
                                                    inv_line_sales_amount_,
                                                    inv_line_sales_gross_amount_,
                                                    inv_line_sales_cur_amt_,
                                                    inv_line_sales_gross_cur_amt_,
                                                    tax_code_,
                                                    pos_,
                                                    contract_,
                                                    order_no_,
                                                    line_no_,
                                                    rel_no_,
                                                    line_item_no_,
                                                    part_no_,
                                                    sales_unit_meas_,
                                                    invoice_id_,
                                                    rma_no_,
                                                    agreement_lines_tab_,
                                                    inv_line_invoiced_qty_,
                                                    co_line_buy_qty_due_,
                                                    co_line_total_weight_,
                                                    co_line_total_volume_);
                  END LOOP;
               ELSE
                  CLOSE get_rebate_type_for_level;
                  Create_Rebate_Transactions___ (company_,
                                                    invoice_no_,
                                                    item_id_,
                                                    parent_customer_,
                                                    hierarchy_id_,
                                                    customer_level_,
                                                    NULL,                               -- assortment_id
                                                    NULL,                               -- assortment_node_id
                                                    parent_agremeent_list_(i_).agreement_id,
                                                    Rebate_Agreement_Type_API.DB_SALES_PART,
                                                    sales_part_rebate_group_,
                                                    '*',
                                                    inv_line_sales_amount_,
                                                    inv_line_sales_gross_amount_,
                                                    inv_line_sales_cur_amt_,
                                                    inv_line_sales_gross_cur_amt_,
                                                    tax_code_,
                                                    pos_,
                                                    contract_,
                                                    order_no_,
                                                    line_no_,
                                                    rel_no_,
                                                    line_item_no_,
                                                    part_no_,
                                                    sales_unit_meas_,
                                                    invoice_id_,
                                                    rma_no_,
                                                    agreement_lines_tab_,
                                                    inv_line_invoiced_qty_,
                                                    co_line_buy_qty_due_,
                                                    co_line_total_weight_,
                                                    co_line_total_volume_);

               END IF;
            END LOOP;
         END IF;

         -- If rebate customer don't check for parent customer
         IF rebate_customer_ = 'TRUE' THEN
            parent_cust_level_ := 0;
         -- If customer level is not 1 then get the parent customer
         ELSIF parent_cust_level_ != 1 THEN
            -- Get the parent customer and the active agreement for the parent
            parent_customer_     := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, parent_customer_);
            parent_agremeent_list_.DELETE;
            Rebate_Agreement_Receiver_API.Get_Active_Agreement(parent_agremeent_list_, parent_customer_, company_, SYSDATE);
            parent_cust_level_   := parent_cust_level_ -1;
         ELSE
            parent_cust_level_ := 0;
         END IF;
         
      END LOOP;
   END IF;
END Create_Sales_Part_Trans___;

PROCEDURE Create_All_Parts_Trans___ (
   company_                      IN VARCHAR2,
   invoice_no_                   IN VARCHAR2,
   item_id_                      IN NUMBER,
   customer_no_                  IN VARCHAR2,
   hierarchy_id_                 IN VARCHAR2,
   customer_level_               IN NUMBER,
   agreement_id_                 IN VARCHAR2,
   inv_line_sales_amount_        IN NUMBER,
   inv_line_sales_gross_amount_  IN NUMBER,
   inv_line_sales_cur_amt_       IN NUMBER,
   inv_line_sales_gross_cur_amt_ IN NUMBER,
   tax_code_                     IN VARCHAR2,
   pos_                          IN NUMBER,
   contract_                     IN VARCHAR2,
   order_no_                     IN VARCHAR2,
   line_no_                     IN VARCHAR2, 
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                      IN VARCHAR2,
   rma_no_                       IN NUMBER,
   invoice_id_                   IN NUMBER,
   parent_customer_no_           IN VARCHAR2,
   rebate_customer_              IN VARCHAR2,
   sales_part_rebate_group_      IN VARCHAR2,
   inv_line_invoiced_qty_        IN NUMBER,
   co_line_buy_qty_due_          IN NUMBER,
   co_line_total_weight_         IN NUMBER,
   co_line_total_volume_         IN NUMBER)
IS
   parent_agremeent_list_          Rebate_Agreement_API.Agreement_Info_List;
   parent_cust_level_         NUMBER;
   parent_customer_           Rebate_Transaction_Tab.customer_no%TYPE;
   rebate_types_              rebate_agr_all_deal_tab.rebate_type%TYPE;
      
   -- Get distinct rebate_types per sales_part_rebate_group. 
   CURSOR get_rebate_type IS
      SELECT DISTINCT (rebate_type)
      FROM rebate_agr_all_deal_tab
      WHERE agreement_id = agreement_id_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));  
   
   -- Cursor to retrive the rebate agreement lines when the hierarchy is not defined in the header.
   CURSOR get_agreement_lines (rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agr_all_deal_tab
      WHERE agreement_id = agreement_id_
      AND   rebate_type = rebate_type_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agr_all_deal_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(SYSDATE) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));

   -- Get distinct rebate_types per sales_part_rebate_group when a hierarchy is defined. 
   CURSOR get_rebate_type_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2,
                                     customer_level_ IN NUMBER) IS
      SELECT DISTINCT (rebate_type)
      FROM rebate_agr_all_deal_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));
   
   -- Cursor to retrieve the rebate agreement lines when hierarchy is defined.
   CURSOR get_agreement_lines_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2,
                                         customer_level_ IN NUMBER, rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agr_all_deal_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   rebate_type = rebate_type_
      AND   TRUNC(SYSDATE) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agr_all_deal_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.hierarchy_id = hierarchy_id_
                              AND t2.customer_level = customer_level_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(SYSDATE) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));
                              
   agreement_lines_tab_ Agreement_Line_Table;   
BEGIN
   -- parent_agreement_, parent_cust_level_ and parent_customer_ are used and updated when
   -- creating transactions with customer levels
   parent_agremeent_list_(1).agreement_id := agreement_id_;
   parent_customer_  := parent_customer_no_;
   IF rebate_customer_ = 'FALSE' THEN
      parent_cust_level_ := customer_level_;
   ELSE
      -- Must be 1 to create a line
      parent_cust_level_ := 1;
   END IF;

   -- If the rebate agreement doesn't have a hierarchy in the header
   IF hierarchy_id_ = '*' THEN
      OPEN get_rebate_type;
      FETCH get_rebate_type INTO rebate_types_;
      IF get_rebate_type%FOUND THEN
         CLOSE get_rebate_type;
         
         FOR rebate_type_ IN get_rebate_type LOOP
            agreement_lines_tab_.DELETE;
            OPEN get_agreement_lines (rebate_type_.rebate_type);
            FETCH get_agreement_lines BULK COLLECT INTO agreement_lines_tab_;
            CLOSE get_agreement_lines;

            Create_Rebate_Transactions___ (company_,
                                           invoice_no_,
                                           item_id_,
                                           customer_no_,
                                           '*',                                -- hierarchy_id
                                           0,                                  -- customer_level
                                           NULL,                               -- assortment_id
                                           NULL,                               -- assortment_node_id
                                           agreement_id_,
                                           Rebate_Agreement_Type_API.DB_ALL,
                                           sales_part_rebate_group_,
                                           rebate_type_.rebate_type,
                                           inv_line_sales_amount_,
                                           inv_line_sales_gross_amount_,
                                           inv_line_sales_cur_amt_,
                                           inv_line_sales_gross_cur_amt_,
                                           tax_code_,
                                           pos_,
                                           contract_,
                                           order_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           part_no_,
                                           NULL,
                                           invoice_id_,
                                           rma_no_,
                                           agreement_lines_tab_,
                                           inv_line_invoiced_qty_,
                                           co_line_buy_qty_due_,
                                           co_line_total_weight_,
                                           co_line_total_volume_);
         END LOOP;
      ELSE
         CLOSE get_rebate_type;
         Create_Rebate_Transactions___ (company_,
                               invoice_no_,
                               item_id_,
                               customer_no_,
                               '*',                                -- hierarchy_id
                               0,                                  -- customer_level
                               NULL,                               -- assortment_id
                               NULL,                               -- assortment_node_id
                               agreement_id_,
                               Rebate_Agreement_Type_API.DB_ALL,
                               sales_part_rebate_group_,
                               '*',
                               inv_line_sales_amount_,
                               inv_line_sales_gross_amount_,
                               inv_line_sales_cur_amt_,
                               inv_line_sales_gross_cur_amt_,
                               tax_code_,
                               pos_,
                               contract_,
                               order_no_,
                               line_no_,
                               rel_no_,
                               line_item_no_,
                               part_no_,
                               NULL,
                               invoice_id_,
                               rma_no_,
                               agreement_lines_tab_,
                               inv_line_invoiced_qty_,
                               co_line_buy_qty_due_,
                               co_line_total_weight_,
                               co_line_total_volume_);
      END IF;   
   ELSE
      -- Retrieve the rebates from the hierarchy levels
      WHILE parent_cust_level_ > 0 LOOP
         IF (parent_agremeent_list_.COUNT > 0 ) THEN
            FOR i_ IN 1 .. parent_agremeent_list_.COUNT LOOP 
               OPEN get_rebate_type_for_level (parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_);
               FETCH get_rebate_type_for_level INTO rebate_types_;

               IF get_rebate_type_for_level%FOUND THEN
                  CLOSE get_rebate_type_for_level;
                  FOR rebate_type_ IN get_rebate_type_for_level (parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_) LOOP

                     agreement_lines_tab_.DELETE;
                     OPEN get_agreement_lines_for_level(parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_,rebate_type_.rebate_type);
                     FETCH get_agreement_lines_for_level BULK COLLECT INTO agreement_lines_tab_;
                     CLOSE get_agreement_lines_for_level;

                     Create_Rebate_Transactions___ (company_,
                                                    invoice_no_,
                                                    item_id_,
                                                    parent_customer_,
                                                    hierarchy_id_,
                                                    customer_level_,
                                                    NULL,                               -- assortment_id
                                                    NULL,                               -- assortment_node_id
                                                    parent_agremeent_list_(i_).agreement_id,
                                                    Rebate_Agreement_Type_API.DB_ALL,
                                                    sales_part_rebate_group_,
                                                    rebate_type_.rebate_type,
                                                    inv_line_sales_amount_,
                                                    inv_line_sales_gross_amount_,
                                                    inv_line_sales_cur_amt_,
                                                    inv_line_sales_gross_cur_amt_,
                                                    tax_code_,
                                                    pos_,
                                                    contract_,
                                                    order_no_,
                                                    line_no_,
                                                    rel_no_,
                                                    line_item_no_,
                                                    part_no_,
                                                    NULL,
                                                    invoice_id_,
                                                    rma_no_,
                                                    agreement_lines_tab_,
                                                    inv_line_invoiced_qty_,
                                                    co_line_buy_qty_due_,
                                                    co_line_total_weight_,
                                                    co_line_total_volume_);

                  END LOOP;
               ELSE
                  CLOSE get_rebate_type_for_level;
                  Create_Rebate_Transactions___ (company_,
                                  invoice_no_,
                                  item_id_,
                                  parent_customer_,
                                  hierarchy_id_,
                                  customer_level_,
                                  NULL,                               -- assortment_id
                                  NULL,                               -- assortment_node_id
                                  parent_agremeent_list_(i_).agreement_id,
                                  Rebate_Agreement_Type_API.DB_ALL,
                                  sales_part_rebate_group_,
                                  '*',
                                  inv_line_sales_amount_,
                                  inv_line_sales_gross_amount_,
                                  inv_line_sales_cur_amt_,
                                  inv_line_sales_gross_cur_amt_,
                                  tax_code_,
                                  pos_,
                                  contract_,
                                  order_no_,
                                  line_no_,
                                  rel_no_,
                                  line_item_no_,
                                  part_no_,
                                  NULL,
                                  invoice_id_,
                                  rma_no_,
                                  agreement_lines_tab_,
                                  inv_line_invoiced_qty_,
                                  co_line_buy_qty_due_,
                                  co_line_total_weight_,
                                  co_line_total_volume_);
               END IF;
            END LOOP;
         END IF;

         -- If rebate customer don't check for parent customer
         IF rebate_customer_ = 'TRUE' THEN
            parent_cust_level_ := 0;
         -- If customer level is not 1 then get the parent customer
         ELSIF parent_cust_level_ != 1 THEN
            -- Get the parent customer and the active agreement for the parent
            parent_customer_     := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, parent_customer_);
            parent_agremeent_list_.DELETE;
            Rebate_Agreement_Receiver_API.Get_Active_Agreement(parent_agremeent_list_, parent_customer_, company_, SYSDATE);
            parent_cust_level_   := parent_cust_level_ -1;
         ELSE
            parent_cust_level_ := 0;
         END IF;
      END LOOP;
   END IF;
END Create_All_Parts_Trans___;

PROCEDURE Create_Rebate_Group_Trans___ (
   company_                      IN VARCHAR2,
   invoice_no_                   IN VARCHAR2,
   item_id_                      IN NUMBER,
   customer_no_                  IN VARCHAR2,
   hierarchy_id_                 IN VARCHAR2,
   customer_level_               IN NUMBER,
   agreement_id_                 IN VARCHAR2,
   sales_part_rebate_group_      IN VARCHAR2,
   inv_line_sales_amount_        IN NUMBER,
   inv_line_sales_gross_amount_  IN NUMBER,
   inv_line_sales_cur_amt_       IN NUMBER,
   inv_line_sales_gross_cur_amt_ IN NUMBER,
   tax_code_                     IN VARCHAR2,
   pos_                          IN NUMBER,
   contract_                     IN VARCHAR2,
   order_no_                     IN VARCHAR2,
   line_no_                     IN VARCHAR2, 
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                      IN VARCHAR2,
   rma_no_                       IN NUMBER,
   invoice_id_                   IN NUMBER,
   parent_customer_no_           IN VARCHAR2,
   rebate_customer_              IN VARCHAR2,
   inv_line_invoiced_qty_        IN NUMBER,
   co_line_buy_qty_due_          IN NUMBER,
   co_line_total_weight_         IN NUMBER,
   co_line_total_volume_         IN NUMBER,
   invoice_date_                 IN DATE DEFAULT NULL)
IS
   parent_agremeent_list_          Rebate_Agreement_API.Agreement_Info_List;
   parent_cust_level_         NUMBER;
   parent_customer_           Rebate_Transaction_Tab.customer_no%TYPE;
   dummy_                     NUMBER; 
   
   -- Get distinct rebate_types per sales_part_rebate_group. 
   CURSOR get_rebate_type (agreement_id_ IN VARCHAR2, sales_part_rebate_group_ IN VARCHAR2) IS
      SELECT DISTINCT (rebate_type)
      FROM rebate_agreement_grp_deal_tab
      WHERE agreement_id = agreement_id_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));  
   
   -- Cursor to retrive the rebate agreement lines when the hierarchy is not defined in the header.
   CURSOR get_agreement_lines (agreement_id_ IN VARCHAR2, sales_part_rebate_group_ IN VARCHAR2, 
                               rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agreement_grp_deal_tab
      WHERE agreement_id = agreement_id_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   rebate_type = rebate_type_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agreement_grp_deal_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.sales_part_rebate_group = sales_part_rebate_group_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));

   -- Get distinct rebate_types per sales_part_rebate_group when a hierarchy is defined. 
   CURSOR get_rebate_type_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2,
                                     customer_level_ IN NUMBER, sales_part_rebate_group_ IN VARCHAR2) IS
      SELECT DISTINCT (rebate_type)
      FROM rebate_agreement_grp_deal_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));
   
   -- Cursor to retrieve the rebate agreement lines when hierarchy is defined.
   CURSOR get_agreement_lines_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2,
                                         customer_level_ IN NUMBER, sales_part_rebate_group_ IN VARCHAR2,
                                         rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agreement_grp_deal_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   rebate_type = rebate_type_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agreement_grp_deal_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.hierarchy_id = hierarchy_id_
                              AND t2.customer_level = customer_level_
                              AND t2.sales_part_rebate_group = sales_part_rebate_group_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));
                              
   agreement_lines_tab_ Agreement_Line_Table;
   
   CURSOR get_rebate_group (agreement_id_ IN VARCHAR2, sales_part_rebate_group_ IN VARCHAR2) IS
      SELECT  1
      FROM rebate_agreement_grp_deal_tab t
      WHERE t.agreement_id = agreement_id_
      AND   t.sales_part_rebate_group = sales_part_rebate_group_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));  
   
   CURSOR get_rebate_group_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2, customer_level_ IN NUMBER, sales_part_rebate_group_ IN VARCHAR2) IS
         SELECT 1
         FROM rebate_agreement_grp_deal_tab
         WHERE agreement_id = agreement_id_
         AND   hierarchy_id = hierarchy_id_
         AND   customer_level = customer_level_
         AND   sales_part_rebate_group = sales_part_rebate_group_
         AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));   
BEGIN
   -- parent_agreement_, parent_cust_level_ and parent_customer_ are used and updated when
   -- creating transactions with customer levels
   parent_agremeent_list_(1).agreement_id := agreement_id_;
   parent_customer_  := parent_customer_no_;
   IF rebate_customer_ = 'FALSE' THEN
      parent_cust_level_ := customer_level_;
   ELSE
      -- Must be 1 to create a line
      parent_cust_level_ := 1;
   END IF;

   -- If the rebate agreement doesn't have a hierarchy in the header
   IF hierarchy_id_ = '*' THEN
      OPEN get_rebate_group (agreement_id_, sales_part_rebate_group_);
      FETCH get_rebate_group INTO dummy_;
      
      IF get_rebate_group%FOUND THEN
         CLOSE get_rebate_group;
         FOR rebate_type_ IN get_rebate_type (agreement_id_, sales_part_rebate_group_) LOOP
         
            agreement_lines_tab_.DELETE;
            OPEN get_agreement_lines (agreement_id_, sales_part_rebate_group_, rebate_type_.rebate_type);
            FETCH get_agreement_lines BULK COLLECT INTO agreement_lines_tab_;
            CLOSE get_agreement_lines;

            Create_Rebate_Transactions___ (company_,
                                           invoice_no_,
                                           item_id_,
                                           customer_no_,
                                           '*',                                -- hierarchy_id
                                           0,                                  -- customer_level
                                           NULL,                               -- assortment_id
                                           NULL,                               -- assortment_node_id
                                           agreement_id_,
                                           Rebate_Agreement_Type_API.DB_REBATE_GROUP,
                                           sales_part_rebate_group_,
                                           rebate_type_.rebate_type,
                                           inv_line_sales_amount_,
                                           inv_line_sales_gross_amount_,
                                           inv_line_sales_cur_amt_,
                                           inv_line_sales_gross_cur_amt_,                                       
                                           tax_code_,
                                           pos_,
                                           contract_,
                                           order_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           part_no_,
                                           NULL,
                                           invoice_id_,
                                           rma_no_,
                                           agreement_lines_tab_,
                                           inv_line_invoiced_qty_,
                                           co_line_buy_qty_due_,
                                           co_line_total_weight_,
                                           co_line_total_volume_);
         END LOOP;
      ELSE
         CLOSE get_rebate_group;
         Create_Rebate_Transactions___ (company_,
                                       invoice_no_,
                                       item_id_,
                                       customer_no_,
                                       '*',                                -- hierarchy_id
                                       0,                                  -- customer_level
                                       NULL,                               -- assortment_id
                                       NULL,                               -- assortment_node_id
                                       agreement_id_,
                                       Rebate_Agreement_Type_API.DB_REBATE_GROUP,
                                       sales_part_rebate_group_,
                                       '*',
                                       inv_line_sales_amount_,
                                       inv_line_sales_gross_amount_,
                                       inv_line_sales_cur_amt_,
                                       inv_line_sales_gross_cur_amt_,                                       
                                       tax_code_,
                                       pos_,
                                       contract_,
                                       order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       part_no_,
                                       NULL,
                                       invoice_id_,
                                       rma_no_,
                                       agreement_lines_tab_,
                                       inv_line_invoiced_qty_,
                                       co_line_buy_qty_due_,
                                       co_line_total_weight_,
                                       co_line_total_volume_);
      END IF;
   ELSE
      -- Retrieve the rebates from the hierarchy levels
      WHILE parent_cust_level_ > 0 LOOP
         IF (parent_agremeent_list_.COUNT > 0 ) THEN
            FOR i_ IN 1 .. parent_agremeent_list_.COUNT LOOP
               OPEN get_rebate_group_for_level (parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_, sales_part_rebate_group_);
               FETCH get_rebate_group_for_level INTO dummy_;
               IF get_rebate_group_for_level%FOUND THEN
                  CLOSE get_rebate_group_for_level;
                  FOR rebate_type_ IN get_rebate_type_for_level (parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_, 
                                                                 sales_part_rebate_group_) LOOP
                     agreement_lines_tab_.DELETE;
                     OPEN get_agreement_lines_for_level(parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_, 
                                                        sales_part_rebate_group_, rebate_type_.rebate_type);
                     FETCH get_agreement_lines_for_level BULK COLLECT INTO agreement_lines_tab_;
                     CLOSE get_agreement_lines_for_level;

                     Create_Rebate_Transactions___ (company_,
                                                    invoice_no_,
                                                    item_id_,
                                                    parent_customer_,
                                                    hierarchy_id_,
                                                    customer_level_,
                                                    NULL,                               -- assortment_id
                                                    NULL,                               -- assortment_node_id
                                                    parent_agremeent_list_(i_).agreement_id,
                                                    Rebate_Agreement_Type_API.DB_REBATE_GROUP,
                                                    sales_part_rebate_group_,
                                                    rebate_type_.rebate_type,
                                                    inv_line_sales_amount_,
                                                    inv_line_sales_gross_amount_,
                                                    inv_line_sales_cur_amt_,
                                                    inv_line_sales_gross_cur_amt_,                                              
                                                    tax_code_,
                                                    pos_,
                                                    contract_,
                                                    order_no_,
                                                    line_no_,
                                                    rel_no_,
                                                    line_item_no_,
                                                    part_no_,
                                                    NULL,
                                                    invoice_id_,
                                                    rma_no_,
                                                    agreement_lines_tab_,
                                                    inv_line_invoiced_qty_,
                                                    co_line_buy_qty_due_,
                                                    co_line_total_weight_,
                                                    co_line_total_volume_);

                  END LOOP;
               ELSE
                  CLOSE get_rebate_group_for_level;
                  Create_Rebate_Transactions___ (company_,
                                                 invoice_no_,
                                                 item_id_,
                                                 parent_customer_,
                                                 hierarchy_id_,
                                                 customer_level_,
                                                 NULL,                               -- assortment_id
                                                 NULL,                               -- assortment_node_id
                                                 parent_agremeent_list_(i_).agreement_id,
                                                 Rebate_Agreement_Type_API.DB_REBATE_GROUP,
                                                 sales_part_rebate_group_,
                                                 '*',
                                                 inv_line_sales_amount_,
                                                 inv_line_sales_gross_amount_,
                                                 inv_line_sales_cur_amt_,
                                                 inv_line_sales_gross_cur_amt_,                                              
                                                 tax_code_,
                                                 pos_,
                                                 contract_,
                                                 order_no_,
                                                 line_no_,
                                                 rel_no_,
                                                 line_item_no_,
                                                 part_no_,
                                                 NULL,
                                                 invoice_id_,
                                                 rma_no_,
                                                 agreement_lines_tab_,
                                                 inv_line_invoiced_qty_,
                                                 co_line_buy_qty_due_,
                                                 co_line_total_weight_,
                                                 co_line_total_volume_);

               END IF;
            END LOOP;
         END IF;   
         -- If rebate customer don't check for parent customer
         IF rebate_customer_ = 'TRUE' THEN
            parent_cust_level_ := 0;
         -- If customer level is not 1 then get the parent customer
         ELSIF parent_cust_level_ != 1 THEN
            -- Get the parent customer and the active agreement for the parent
            parent_customer_     := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, parent_customer_);
            parent_agremeent_list_.DELETE;
            Rebate_Agreement_Receiver_API.Get_Active_Agreement(parent_agremeent_list_, parent_customer_, company_, SYSDATE);
            parent_cust_level_   := parent_cust_level_ - 1;
         ELSE
            parent_cust_level_ := 0;
         END IF;
      END LOOP;
   END IF;
END Create_Rebate_Group_Trans___;

PROCEDURE Create_Assortment_Trans___ (
   company_                      IN VARCHAR2,
   invoice_no_                   IN VARCHAR2,
   item_id_                      IN NUMBER,
   customer_no_                  IN VARCHAR2,
   hierarchy_id_                 IN VARCHAR2,
   customer_level_               IN NUMBER,
   agreement_id_                 IN VARCHAR2,
   assortment_id_                IN VARCHAR2,
   assortment_node_id_           IN VARCHAR2,
   inv_line_sales_amount_        IN NUMBER,
   inv_line_sales_gross_amount_  IN NUMBER,
   inv_line_sales_cur_amt_       IN NUMBER,
   inv_line_sales_gross_cur_amt_ IN NUMBER,
   tax_code_                     IN VARCHAR2,
   pos_                          IN NUMBER,
   contract_                     IN VARCHAR2,
   order_no_                     IN VARCHAR2,
   line_no_                     IN VARCHAR2, 
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                      IN VARCHAR2,
   rma_no_                       IN NUMBER,
   invoice_id_                   IN NUMBER,
   parent_customer_no_           IN VARCHAR2,
   rebate_customer_              IN VARCHAR2,
   sales_part_rebate_group_      IN VARCHAR2,
   inv_line_invoiced_qty_        IN NUMBER,
   co_line_buy_qty_due_          IN NUMBER,
   co_line_total_weight_         IN NUMBER,
   co_line_total_volume_         IN NUMBER,
   invoice_date_                IN DATE DEFAULT NULL)
IS
   parent_agremeent_list_          Rebate_Agreement_API.Agreement_Info_List;
   parent_cust_level_         NUMBER;
   parent_customer_           Rebate_Transaction_Tab.customer_no%TYPE;
   rebate_typ_                Rebate_Agreement_Assort_Tab.rebate_type%TYPE;

   -- Get distinct rebate_types per assortment_node_id. 
   CURSOR get_rebate_type (agreement_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2) IS
      SELECT DISTINCT (rebate_type)
      FROM rebate_agreement_assort_tab
      WHERE agreement_id = agreement_id_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));
   
   -- Cursor to retrive the rebate agreement assortment lines when the hierarchy is not defined in the header.
   CURSOR get_agreement_assort_lines (agreement_id_ IN VARCHAR2, assortment_id_ IN VARCHAR2, 
                                      assortment_node_id_ IN VARCHAR2, rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agreement_assort_tab
      WHERE agreement_id = agreement_id_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   rebate_type = rebate_type_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agreement_assort_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.assortment_id = assortment_id_
                              AND t2.assortment_node_id = assortment_node_id_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));

   -- Get distinct rebate_types per assortment_node_id when a hierarchy is defined.
   CURSOR get_rebate_type_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2, customer_level_ IN NUMBER,
                                     assortment_id_ IN VARCHAR2, assortment_node_id_ IN VARCHAR2) IS
      SELECT DISTINCT(rebate_type)
      FROM rebate_agreement_assort_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_));
   
   -- Cursor to retrieve the rebate agreement assortment lines when hierarchy is defined.
   CURSOR get_agreement_assort_for_level (agreement_id_ IN VARCHAR2, hierarchy_id_ IN VARCHAR2, 
                                          customer_level_ IN NUMBER, assortment_id_ IN VARCHAR2, 
                                          assortment_node_id_ IN VARCHAR2, rebate_type_ IN VARCHAR2) IS
      SELECT rebate_rate, rebate_cost, periodic_rebate_amount, rebate_cost_amount
      FROM rebate_agreement_assort_tab
      WHERE agreement_id = agreement_id_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   assortment_id = assortment_id_
      AND   assortment_node_id = assortment_node_id_
      AND   rebate_type = rebate_type_
      AND   TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(valid_from) AND TRUNC(NVL(valid_to_date,Database_Sys.last_calendar_date_))
      AND   valid_from = ( SELECT MAX(t2.valid_from)
                             FROM rebate_agreement_assort_tab t2
                            WHERE t2.agreement_id = agreement_id_
                              AND t2.hierarchy_id = hierarchy_id_
                              AND t2.customer_level = customer_level_
                              AND t2.assortment_id = assortment_id_
                              AND t2.assortment_node_id = assortment_node_id_
                              AND t2.rebate_type = rebate_type_
                              AND TRUNC(NVL(invoice_date_, SYSDATE)) BETWEEN TRUNC(t2.valid_from) AND TRUNC(NVL(t2.valid_to_date,Database_Sys.last_calendar_date_)));

   agreement_lines_tab_ Agreement_Line_Table;
BEGIN
   -- parent_agreement_, parent_cust_level_ and parent_customer_ are used and updated when
   -- creating transactions with customer levels
   parent_agremeent_list_(1).agreement_id := agreement_id_;
   parent_customer_     := parent_customer_no_;
   IF rebate_customer_ = 'FALSE' THEN
      parent_cust_level_ := customer_level_;
   ELSE
      -- Must be 1 to create a line
      parent_cust_level_ := 1;
   END IF;

   -- If the rebate agreement doesn't have a hierarchy in the header
   IF hierarchy_id_ = '*' THEN
      OPEN get_rebate_type (agreement_id_, assortment_id_, assortment_node_id_);
      FETCH get_rebate_type INTO rebate_typ_;
         
      IF get_rebate_type%FOUND THEN
         CLOSE get_rebate_type;
         
         FOR rebate_type_ IN get_rebate_type (agreement_id_, assortment_id_, assortment_node_id_) LOOP
            agreement_lines_tab_.DELETE;
            OPEN get_agreement_assort_lines (agreement_id_, assortment_id_, assortment_node_id_, rebate_type_.rebate_type);
            FETCH get_agreement_assort_lines BULK COLLECT INTO agreement_lines_tab_;
            CLOSE get_agreement_assort_lines;

            Create_Rebate_Transactions___ (company_,
                                           invoice_no_,
                                           item_id_,
                                           customer_no_,
                                           '*',                                -- hierarchy_id
                                           0,                                  -- customer_level
                                           assortment_id_,
                                           assortment_node_id_,
                                           agreement_id_,
                                           Rebate_Agreement_Type_API.DB_ASSORTMENT,
                                           sales_part_rebate_group_,
                                           rebate_type_.rebate_type,
                                           inv_line_sales_amount_,
                                           inv_line_sales_gross_amount_,
                                           inv_line_sales_cur_amt_,
                                           inv_line_sales_gross_cur_amt_,
                                           tax_code_,
                                           pos_,
                                           contract_,
                                           order_no_,
                                           line_no_,
                                           rel_no_,
                                           line_item_no_,
                                           part_no_,
                                           NULL,
                                           invoice_id_,
                                           rma_no_,
                                           agreement_lines_tab_,
                                           inv_line_invoiced_qty_,
                                           co_line_buy_qty_due_,
                                           co_line_total_weight_,
                                           co_line_total_volume_);

         END LOOP;
      ELSE
         CLOSE get_rebate_type;
         Create_Rebate_Transactions___ (company_,
                                       invoice_no_,
                                       item_id_,
                                       customer_no_,
                                       '*',                                -- hierarchy_id
                                       0,                                  -- customer_level
                                       assortment_id_,
                                       assortment_node_id_,
                                       agreement_id_,
                                       Rebate_Agreement_Type_API.DB_ASSORTMENT,
                                       sales_part_rebate_group_,
                                       '*',
                                       inv_line_sales_amount_,
                                       inv_line_sales_gross_amount_,
                                       inv_line_sales_cur_amt_,
                                       inv_line_sales_gross_cur_amt_,
                                       tax_code_,
                                       pos_,
                                       contract_,
                                       order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       part_no_,
                                       NULL,
                                       invoice_id_,
                                       rma_no_,
                                       agreement_lines_tab_,
                                       inv_line_invoiced_qty_,
                                       co_line_buy_qty_due_,
                                       co_line_total_weight_,
                                       co_line_total_volume_);
      END IF;                                     
   ELSE
      -- Retrieve the rebates from the hierarchy levels
      WHILE parent_cust_level_ > 0 LOOP
         IF (parent_agremeent_list_.COUNT > 0 ) THEN
            FOR i_ IN 1 .. parent_agremeent_list_.COUNT LOOP
               OPEN get_rebate_type_for_level (parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_, assortment_id_, assortment_node_id_);
               FETCH get_rebate_type_for_level INTO rebate_typ_;

               IF get_rebate_type_for_level%FOUND THEN
                  CLOSE get_rebate_type_for_level;
                  FOR rebate_type_ IN get_rebate_type_for_level (parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_, 
                                                                 assortment_id_, assortment_node_id_) LOOP

                     agreement_lines_tab_.DELETE;
                     OPEN get_agreement_assort_for_level(parent_agremeent_list_(i_).agreement_id, hierarchy_id_, customer_level_, assortment_id_, 
                                                         assortment_node_id_, rebate_type_.rebate_type);
                     FETCH get_agreement_assort_for_level BULK COLLECT INTO agreement_lines_tab_;
                     CLOSE get_agreement_assort_for_level; 

                     Create_Rebate_Transactions___ (company_,
                                                    invoice_no_,
                                                    item_id_,
                                                    parent_customer_,
                                                    hierarchy_id_,
                                                    customer_level_,
                                                    assortment_id_,
                                                    assortment_node_id_,
                                                    parent_agremeent_list_(i_).agreement_id,
                                                    Rebate_Agreement_Type_API.DB_ASSORTMENT,
                                                    sales_part_rebate_group_,
                                                    rebate_type_.rebate_type,
                                                    inv_line_sales_amount_,
                                                    inv_line_sales_gross_amount_,
                                                    inv_line_sales_cur_amt_,
                                                    inv_line_sales_gross_cur_amt_,
                                                    tax_code_,
                                                    pos_,
                                                    contract_,
                                                    order_no_,
                                                    line_no_,
                                                    rel_no_,
                                                    line_item_no_,
                                                    part_no_,
                                                    NULL,
                                                    invoice_id_,
                                                    rma_no_,
                                                    agreement_lines_tab_,
                                                    inv_line_invoiced_qty_,
                                                    co_line_buy_qty_due_,
                                                    co_line_total_weight_,
                                                    co_line_total_volume_);
                  END LOOP;
               ELSE
                  CLOSE get_rebate_type_for_level;
                  Create_Rebate_Transactions___ (company_,
                                                invoice_no_,
                                                item_id_,
                                                parent_customer_,
                                                hierarchy_id_,
                                                customer_level_,
                                                assortment_id_,
                                                assortment_node_id_,
                                                parent_agremeent_list_(i_).agreement_id,
                                                Rebate_Agreement_Type_API.DB_ASSORTMENT,
                                                sales_part_rebate_group_,
                                                '*',
                                                inv_line_sales_amount_,
                                                inv_line_sales_gross_amount_,
                                                inv_line_sales_cur_amt_,
                                                inv_line_sales_gross_cur_amt_,
                                                tax_code_,
                                                pos_,
                                                contract_,
                                                order_no_,
                                                line_no_,
                                                rel_no_,
                                                line_item_no_,
                                                part_no_,
                                                NULL,
                                                invoice_id_,
                                                rma_no_,
                                                agreement_lines_tab_,
                                                inv_line_invoiced_qty_,
                                                co_line_buy_qty_due_,
                                                co_line_total_weight_,
                                                co_line_total_volume_);
               END IF;
            END LOOP;
         END IF;  
         
         -- If rebate customer don't check for parent customer
         IF rebate_customer_ = 'TRUE' THEN
            parent_cust_level_ := 0;
         -- If customer level is not 1 then get the parent customer
         ELSIF parent_cust_level_ != 1 THEN
            -- Get the parent customer and the active agreement for the parent
            parent_customer_     := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, parent_customer_);
            parent_agremeent_list_.DELETE;
            Rebate_Agreement_Receiver_API.Get_Active_Agreement(parent_agremeent_list_, parent_customer_, company_, SYSDATE);
            parent_cust_level_   := parent_cust_level_ -1;
         ELSE
            parent_cust_level_ := 0;
         END IF;
      END LOOP;
   END IF;
END Create_Assortment_Trans___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Incl_In_Period_Settlement (
   agreement_id_            IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   hierarchy_id_            IN VARCHAR2,
   customer_level_          IN NUMBER,
   sales_part_rebate_group_ IN VARCHAR2,
   assortment_id_           IN VARCHAR2,
   assortment_node_id_      IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   sales_unit_meas_         IN VARCHAR2,   
   rebate_type_             IN VARCHAR2,
   tax_code_                IN VARCHAR2,
   start_date_              IN DATE,
   end_date_                IN DATE,
   aggregation_no_          IN NUMBER,
   aggr_line_no_            IN NUMBER)
IS
   agreement_type_          rebate_transaction_tab.agreement_type%TYPE;
BEGIN
   agreement_type_ := Rebate_Agreement_API.Get_Agreement_Type_Db(agreement_id_);
   
   -- Since the agreement_id is used in the WHERE condition we can use the same update statement for both 
   -- assortment and sales part rebate group.
   UPDATE rebate_transaction_tab
      SET period_aggregation_no = aggregation_no_,
          period_aggr_line_no = aggr_line_no_
      WHERE agreement_id = agreement_id_
      AND   customer_no = customer_no_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_REBATE_GROUP) OR (sales_part_rebate_group = sales_part_rebate_group_))
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_ASSORTMENT) OR ((assortment_id = assortment_id_  AND assortment_node_id = assortment_node_id_)))
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_SALES_PART) OR ((part_no = part_no_  AND sales_unit_meas = sales_unit_meas_)))      
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_ALL) OR (part_no_ IS NULL OR part_no = part_no_)) 
      AND   rebate_type = rebate_type_
      AND   (tax_code IS NULL OR tax_code = tax_code_)
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   period_aggregation_no IS NULL
      AND   final_aggregation_no IS NULL;
      
END Set_Incl_In_Period_Settlement;

PROCEDURE Set_Incl_In_Final_Settlement (
   agreement_id_            IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   hierarchy_id_            IN VARCHAR2,
   customer_level_          IN NUMBER,
   sales_part_rebate_group_ IN VARCHAR2,
   assortment_id_           IN VARCHAR2,
   assortment_node_id_      IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   sales_unit_meas_         IN VARCHAR2,   
   rebate_type_             IN VARCHAR2,
   tax_code_                IN VARCHAR2,
   start_date_              IN DATE,
   end_date_                IN DATE,
   aggregation_no_          IN NUMBER,
   aggr_line_no_            IN NUMBER)
   
IS
   agreement_type_          rebate_transaction_tab.agreement_type%TYPE;
 BEGIN

   agreement_type_ := Rebate_Agreement_API.Get_Agreement_Type_Db(agreement_id_);

   -- Since the agreement_id is used in the WHERE condition we can use the same update statement for both 
   -- assortment and sales part rebate group.
   UPDATE rebate_transaction_tab
      SET final_aggregation_no = aggregation_no_,
          final_aggr_line_no = aggr_line_no_
      WHERE agreement_id = agreement_id_
      AND   customer_no = customer_no_
      AND   hierarchy_id = hierarchy_id_
      AND   customer_level = customer_level_
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_REBATE_GROUP) OR (sales_part_rebate_group = sales_part_rebate_group_))
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_ASSORTMENT) OR ((assortment_id = assortment_id_  AND assortment_node_id = assortment_node_id_)))
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_SALES_PART) OR ((part_no = part_no_  AND sales_unit_meas = sales_unit_meas_)))      
      AND   ((agreement_type_ != Rebate_Agreement_type_API.DB_ALL) OR (part_no_ IS NULL OR part_no = part_no_))
      AND   rebate_type = rebate_type_
      AND   (tax_code IS NULL OR tax_code = tax_code_)
      AND   transaction_date BETWEEN start_date_ AND end_date_
      AND   final_aggregation_no IS NULL;
  
 END Set_Incl_In_Final_Settlement;

PROCEDURE Create_Rebate_Transactions (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   customer_no_ IN VARCHAR2 )
IS
   transactions_created_    NUMBER;
BEGIN
   Create_Rebate_Transactions (transactions_created_,
                               company_,
                               invoice_id_,
                               customer_no_);
END  Create_Rebate_Transactions;
PROCEDURE Create_Rebate_Transactions (
   transactions_created_ OUT VARCHAR2,
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   customer_no_ IN VARCHAR2 )
IS
   agreement_id_              VARCHAR2(10);
   hierarchy_id_              VARCHAR2(10);
   customer_parent_           Rebate_Transaction_Tab.customer_no%TYPE;
   customer_level_            NUMBER;
   invoice_no_                VARCHAR2(50);
   order_no_                  VARCHAR2(100);
   rebate_customer_           Rebate_Transaction_Tab.customer_no%TYPE;
   rebate_builder_db_         VARCHAR2(20) := 'TRUE';
   rc_agreement_id_           VARCHAR2(10);
   rc_hierarchy_id_           VARCHAR2(10);
   rc_customer_level_         NUMBER;
   delivery_addr_id_          VARCHAR2(50);
   invoice_type_              CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   rebate_trans_customer_     Rebate_Transaction_Tab.customer_no%TYPE;
   rebate_agreement_type_db_  Rebate_Agreement_Tab.agreement_type%TYPE;
   co_line_buy_qty_due_       customer_order_line_tab.buy_qty_due%TYPE;
   co_line_total_weight_      customer_order_line_tab.line_total_weight%TYPE; 
   co_line_total_volume_      customer_order_line_tab.line_total_qty%TYPE;  
   active_agreement_list_     Rebate_Agreement_API.Agreement_Info_List;
   active_rc_agreement_list_  Rebate_Agreement_API.Agreement_Info_List;
   invoice_date_              DATE;
   
   CURSOR get_header_info (company_ IN VARCHAR2, invoice_id_ IN NUMBER) IS
      SELECT creators_reference, delivery_address_id, invoice_type, invoice_date
      FROM customer_order_inv_head
      WHERE company = company_
      AND   invoice_id = invoice_id_;

   CURSOR get_invoice_lines (company_ IN VARCHAR2, invoice_id_ IN NUMBER) IS
      SELECT item_id, contract, catalog_no, net_dom_amount, vat_dom_amount, net_curr_amount, vat_curr_amount, vat_code, pos, sales_part_rebate_group, assortment_id, 
      assortment_node_id, order_no, line_no, release_no, line_item_no, rma_no, rma_line_no, charge_seq_no, delivery_customer, invoiced_qty
      FROM customer_order_inv_item
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   catalog_no IS NOT NULL;
      
   CURSOR get_cust_ord_line_info (order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2, line_item_no_ IN NUMBER) IS
      SELECT buy_qty_due, line_total_weight, line_total_qty
      FROM customer_order_line_tab
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   --             getting the invoice type before all the other actions to be done.      
   OPEN get_header_info(company_, invoice_id_);
   FETCH get_header_info INTO order_no_, delivery_addr_id_, invoice_type_, invoice_date_;
   CLOSE get_header_info;
   IF (invoice_type_ NOT IN ('CUSTCOLDEB', 'CUSTCOLCRE')) THEN
      rebate_trans_customer_ := customer_no_;
      -- Get active agreement for the customer 
      Get_Customer_Rebate_Info(active_agreement_list_, company_, customer_no_, invoice_date_);
      IF order_no_ IS NOT NULL THEN
         rebate_customer_ := Customer_Order_API.Get_Rebate_Customer(order_no_);
         IF rebate_customer_ IS NOT NULL THEN
            Rebate_Agreement_Receiver_API.Get_Active_Agreement(active_rc_agreement_list_, rebate_customer_, company_, trunc(SYSDATE));
         END IF;
      END IF;
   END IF;
   -- Get the invoice no
   invoice_no_ := Customer_Order_Inv_Head_API.Get_Invoice_No_By_Id(invoice_id_);        
   transactions_created_ := 0;
   -- Get invoice lines
   FOR line_ IN get_invoice_lines (company_, invoice_id_) LOOP
      IF (invoice_type_ IN ('CUSTCOLDEB', 'CUSTCOLCRE')) THEN
         rebate_trans_customer_ := line_.delivery_customer;
         Get_Customer_Rebate_Info(active_agreement_list_, company_, line_.delivery_customer, invoice_date_);
         rebate_customer_ := Customer_Order_API.Get_Rebate_Customer(line_.order_no);         
         IF rebate_customer_ IS NOT NULL THEN
           Rebate_Agreement_Receiver_API.Get_Active_Agreement(active_rc_agreement_list_, rebate_customer_, company_, trunc(SYSDATE));
         END IF;
      END IF;
      
      IF line_.rma_no IS NOT NULL THEN
         rebate_builder_db_ := Fnd_Boolean_API.Encode(Return_Material_Line_API.Get_Rebate_Builder(line_.rma_no, 
                                                                                                  line_.rma_line_no));
      ELSIF line_.order_no IS NOT NULL THEN
         rebate_builder_db_ := Customer_Order_Line_API.Get_Rebate_Builder_Db(line_.order_no, line_.line_no,
                                                                             line_.release_no, line_.line_item_no);
      END IF;
      
      OPEN get_cust_ord_line_info(line_.order_no, line_.line_no, line_.release_no, line_.line_item_no);
      FETCH get_cust_ord_line_info INTO co_line_buy_qty_due_, co_line_total_weight_, co_line_total_volume_;
      CLOSE get_cust_ord_line_info;
      
      IF (active_agreement_list_.COUNT > 0) AND (rebate_builder_db_ = 'TRUE') THEN
      
         FOR i_ IN 1 .. active_agreement_list_.COUNT LOOP  
         
            agreement_id_ := active_agreement_list_(i_).agreement_id;
            customer_level_ := active_agreement_list_(i_).customer_level;
            hierarchy_id_  := active_agreement_list_(i_).hierarchy_id;
            customer_parent_ := active_agreement_list_(i_).customer_parent;
                      
            rebate_agreement_type_db_ := Rebate_Agreement_API.Get_Agreement_Type_Db(agreement_id_);
            
            -- Create transactions for sales part rebate group lines
            IF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_REBATE_GROUP) AND (line_.charge_seq_no IS NULL ) THEN
               Create_Rebate_Group_Trans___(company_,
                                         invoice_no_,
                                         line_.item_id,
                                         rebate_trans_customer_,
                                         hierarchy_id_,
                                         customer_level_,
                                         agreement_id_,
                                         line_.sales_part_rebate_group,
                                         line_.net_dom_amount,            -- inv_line_sales_amount
                                         line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                         line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                         line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                         line_.vat_code,                       -- tax_code
                                         line_.pos,
                                         line_.contract,
                                         line_.order_no,
                                         line_.line_no,
                                         line_.release_no, 
                                         line_.line_item_no,
                                         line_.catalog_no,
                                         line_.rma_no,
                                         invoice_id_,
                                         customer_parent_,
                                         'FALSE',
                                         line_.invoiced_qty,
                                         co_line_buy_qty_due_,
                                         co_line_total_weight_,
                                         co_line_total_volume_,
                                         invoice_date_);
               transactions_created_ := 1;
            -- Create transactions for assortment lines
            ELSIF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_ASSORTMENT) AND (line_.charge_seq_no IS NULL ) THEN
               Create_Assortment_Trans___(company_,
                                       invoice_no_,
                                       line_.item_id,
                                       rebate_trans_customer_,
                                       hierarchy_id_,
                                       customer_level_,
                                       agreement_id_,
                                       line_.assortment_id,
                                       line_.assortment_node_id,
                                       line_.net_dom_amount,            -- inv_line_sales_amount
                                       line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                       line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                       line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                       line_.vat_code,                          -- tax_code
                                       line_.pos, 
                                       line_.contract,
                                       line_.order_no,
                                       line_.line_no,
                                       line_.release_no, 
                                       line_.line_item_no,
                                       line_.catalog_no,
                                       line_.rma_no,
                                       invoice_id_,
                                       customer_parent_,
                                       'FALSE',
                                       line_.sales_part_rebate_group,
                                       line_.invoiced_qty,
                                       co_line_buy_qty_due_,
                                       co_line_total_weight_,
                                       co_line_total_volume_,
                                       invoice_date_);
               transactions_created_ := 1;
            ELSIF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_SALES_PART) AND (line_.charge_seq_no IS NULL ) THEN            
               Create_Sales_Part_Trans___(company_,
                                       invoice_no_,
                                       line_.item_id,
                                       rebate_trans_customer_,
                                       hierarchy_id_,
                                       customer_level_,
                                       agreement_id_,                                                                                                                                                
                                       line_.net_dom_amount,            -- inv_line_sales_amount
                                       line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                       line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                       line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                       line_.vat_code,                          -- tax_code
                                       line_.pos, 
                                       line_.contract,
                                       line_.order_no,
                                       line_.line_no,
                                       line_.release_no, 
                                       line_.line_item_no,
                                       line_.catalog_no,
                                       line_.rma_no,
                                       invoice_id_,
                                       customer_parent_,
                                       'FALSE',
                                       line_.sales_part_rebate_group,
                                       line_.invoiced_qty,
                                       co_line_buy_qty_due_,
                                       co_line_total_weight_,
                                       co_line_total_volume_);
               transactions_created_ := 1;
            ELSIF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_ALL) AND (line_.charge_seq_no IS NULL ) THEN            
               Create_ALL_Parts_Trans___(company_,
                                       invoice_no_,
                                       line_.item_id,
                                       rebate_trans_customer_,
                                       hierarchy_id_,
                                       customer_level_,
                                       agreement_id_,                                                                                                                                                
                                       line_.net_dom_amount,            -- inv_line_sales_amount
                                       line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                       line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                       line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                       line_.vat_code,                          -- tax_code
                                       line_.pos, 
                                       line_.contract,
                                       line_.order_no,
                                       line_.line_no,
                                       line_.release_no, 
                                       line_.line_item_no,
                                       line_.catalog_no,
                                       line_.rma_no,
                                       invoice_id_,
                                       customer_parent_,
                                       'FALSE',
                                       line_.sales_part_rebate_group,
                                       line_.invoiced_qty,
                                       co_line_buy_qty_due_,
                                       co_line_total_weight_,
                                       co_line_total_volume_);
               transactions_created_ := 1;
            -- Create transactions for invoice lines without sales part rebate group or assortment lines
            ELSIF (line_.charge_seq_no IS NULL ) THEN
               Create_Rebate_Group_Trans___(company_,
                                         invoice_no_,
                                         line_.item_id,
                                         rebate_trans_customer_,
                                         hierarchy_id_,
                                         customer_level_,
                                         agreement_id_,
                                         NULL,
                                         line_.net_dom_amount,            -- inv_line_sales_amount
                                         line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                         line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                         line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                         line_.vat_code,                           -- tax_code
                                         line_.pos,
                                         line_.contract,
                                         line_.order_no,
                                         line_.line_no,
                                         line_.release_no, 
                                         line_.line_item_no,
                                         line_.catalog_no,
                                         line_.rma_no,
                                         invoice_id_,
                                         customer_parent_,
                                         'FALSE',
                                         line_.invoiced_qty,
                                         co_line_buy_qty_due_,
                                         co_line_total_weight_,
                                         co_line_total_volume_);
               transactions_created_ := 1;
            END IF;
         END LOOP;
      END IF;
      
      IF (active_rc_agreement_list_.COUNT > 0) AND (rebate_builder_db_ = 'TRUE') THEN
         FOR i_ IN 1 .. active_rc_agreement_list_.COUNT LOOP
            
            rc_agreement_id_ := active_rc_agreement_list_(i_).agreement_id;
            rc_hierarchy_id_     := Rebate_Agreement_API.Get_Hierarchy_Id(rc_agreement_id_);
            rc_customer_level_   := Cust_Hierarchy_Struct_API.Get_Level_No(rc_hierarchy_id_, rebate_customer_);
            -- customer_parent_ :=  active_rc_agreement_list_(i_).customer_parent; -- not used
            
            rebate_agreement_type_db_ := Rebate_Agreement_API.Get_Agreement_Type_Db(rc_agreement_id_);
            
            -- Create transactions for additional rebate customer too
            IF (rebate_customer_ IS NOT NULL) AND (rc_hierarchy_id_ IS NOT NULL) THEN
               -- Create transactions for sales part rebate group lines
               IF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_REBATE_GROUP) THEN
                  Create_Rebate_Group_Trans___(company_,
                                            invoice_no_,
                                            line_.item_id,
                                            rebate_customer_,
                                            rc_hierarchy_id_,
                                            rc_customer_level_,
                                            rc_agreement_id_,
                                            line_.sales_part_rebate_group,
                                            line_.net_dom_amount,            -- inv_line_sales_amount
                                            line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                            line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                            line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                            line_.vat_code,                           -- tax_code
                                            line_.pos,
                                            line_.contract,
                                            line_.order_no,
                                            line_.line_no,
                                            line_.release_no, 
                                            line_.line_item_no,
                                            line_.catalog_no,
                                            line_.rma_no,
                                            invoice_id_,
                                            rebate_customer_,                -- parent_customer_no
                                            'TRUE',
                                            line_.invoiced_qty,
                                            co_line_buy_qty_due_,
                                            co_line_total_weight_,
                                            co_line_total_volume_);
                  transactions_created_ := 1;
               -- Create transactions for assortment lines
               ELSIF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_ASSORTMENT) THEN
                  Create_Assortment_Trans___(company_,
                                          invoice_no_,
                                          line_.item_id,
                                          rebate_customer_,
                                          rc_hierarchy_id_,
                                          rc_customer_level_,
                                          rc_agreement_id_,
                                          line_.assortment_id,
                                          line_.assortment_node_id,
                                          line_.net_dom_amount,            -- inv_line_sales_amount
                                          line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                          line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                          line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                          line_.vat_code,                          -- tax_code
                                          line_.pos,
                                          line_.contract,
                                          line_.order_no,
                                          line_.line_no,
                                          line_.release_no, 
                                          line_.line_item_no,
                                          line_.catalog_no,
                                          line_.rma_no,
                                          invoice_id_,
                                          rebate_customer_,                -- parent_customer_no
                                          'TRUE',
                                          line_.sales_part_rebate_group,
                                          line_.invoiced_qty,
                                          co_line_buy_qty_due_,
                                          co_line_total_weight_,
                                          co_line_total_volume_);
                  transactions_created_ := 1;
               ELSIF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_SALES_PART) THEN
                  Create_Sales_Part_Trans___(company_,
                                          invoice_no_,
                                          line_.item_id,
                                          rebate_customer_,
                                          rc_hierarchy_id_,
                                          rc_customer_level_,
                                          rc_agreement_id_,
                                          line_.net_dom_amount,            -- inv_line_sales_amount
                                          line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                          line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                          line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                          line_.vat_code,                          -- tax_code
                                          line_.pos,
                                          line_.contract,
                                          line_.order_no,
                                          line_.line_no,
                                          line_.release_no, 
                                          line_.line_item_no,
                                          line_.catalog_no,
                                          line_.rma_no,
                                          invoice_id_,
                                          rebate_customer_,                -- parent_customer_no
                                          'TRUE',
                                          line_.sales_part_rebate_group,
                                          line_.invoiced_qty,
                                          co_line_buy_qty_due_,
                                          co_line_total_weight_,
                                          co_line_total_volume_);
                  transactions_created_ := 1;
               ELSIF (rebate_agreement_type_db_ = Rebate_Agreement_Type_API.DB_ALL) THEN
                  Create_All_Parts_Trans___(company_,
                                          invoice_no_,
                                          line_.item_id,
                                          rebate_customer_,
                                          rc_hierarchy_id_,
                                          rc_customer_level_,
                                          rc_agreement_id_,
                                          line_.net_dom_amount,            -- inv_line_sales_amount
                                          line_.net_dom_amount + line_.vat_dom_amount, -- inv_line_sales_gross_amount
                                          line_.net_curr_amount,            -- inv_line_sales_amount in customer order currency
                                          line_.net_curr_amount + line_.vat_curr_amount, -- inv_line_sales_gross_amount in customer order currency
                                          line_.vat_code,                          -- tax_code
                                          line_.pos,
                                          line_.contract,
                                          line_.order_no,
                                          line_.line_no,
                                          line_.release_no, 
                                          line_.line_item_no,
                                          line_.catalog_no,
                                          line_.rma_no,
                                          invoice_id_,
                                          rebate_customer_,                -- parent_customer_no
                                          'TRUE',
                                          line_.sales_part_rebate_group,
                                          line_.invoiced_qty,
                                          co_line_buy_qty_due_,
                                          co_line_total_weight_,
                                          co_line_total_volume_);
                  transactions_created_ := 1;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END LOOP;
END Create_Rebate_Transactions;


PROCEDURE Add_Final_Rebate (
   agreement_id_            IN VARCHAR2,
   company_                 IN VARCHAR2,
   customer_no_             IN VARCHAR2,
   hierarchy_id_            IN VARCHAR2,
   customer_level_          IN NUMBER,
   sales_part_rebate_group_ IN VARCHAR2,
   assortment_id_           IN VARCHAR2,
   assortment_node_id_      IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   sales_unit_meas_         IN VARCHAR2,
   rebate_type_             IN VARCHAR2,
   tax_code_                IN VARCHAR2,
   rebate_rate_             IN NUMBER,
   invoice_id_              IN NUMBER,
   item_id_                 IN NUMBER )
IS
   rebate_amount_                      NUMBER;
   rebate_                             NUMBER;
   agreement_type_                     Rebate_Agreement_TAB.agreement_type%TYPE;
   rebate_criteria_db_                 Rebate_Agreement_TAB.rebate_criteria%TYPE;
   agreement_currency_code_            VARCHAR2(3);
   company_currency_code_              VARCHAR2(3);
   agreement_rec_                      Rebate_Agreement_API.Public_Rec;
   
   CURSOR get_invoice_amount IS
      SELECT inv_line_sales_amount, inv_line_sales_gross_amount, rebate_rate, total_rebate_amount, 
      invoiced_quantity, net_weight, net_volume, inv_line_sales_curr_amount
      FROM rebate_transaction_tab
      WHERE agreement_id            = agreement_id_
      AND   customer_no             = customer_no_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   sales_part_rebate_group = sales_part_rebate_group_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_REBATE_GROUP
      AND   rebate_type             = rebate_type_
      AND   (tax_code IS NULL OR tax_code = tax_code_)
      AND   invoice_id              = invoice_id_
      AND   item_id                 = item_id_;

   CURSOR get_invoice_amount_assort IS
      SELECT inv_line_sales_amount, inv_line_sales_gross_amount, rebate_rate, total_rebate_amount, 
      invoiced_quantity, net_weight, net_volume, inv_line_sales_curr_amount
      FROM rebate_transaction_tab
      WHERE agreement_id            = agreement_id_
      AND   customer_no             = customer_no_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   assortment_id           = assortment_id_
      AND   assortment_node_id      = assortment_node_id_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_ASSORTMENT
      AND   rebate_type             = rebate_type_
      AND   (tax_code IS NULL OR tax_code = tax_code_)
      AND   invoice_id              = invoice_id_
      AND   item_id                 = item_id_;
      
   CURSOR get_invoice_amount_part IS
      SELECT inv_line_sales_amount, inv_line_sales_gross_amount, rebate_rate, total_rebate_amount,
      invoiced_quantity, net_weight, net_volume, inv_line_sales_curr_amount
      FROM rebate_transaction_tab
      WHERE agreement_id            = agreement_id_
      AND   customer_no             = customer_no_
      AND   hierarchy_id            = hierarchy_id_
      AND   customer_level          = customer_level_
      AND   part_no                 = part_no_
      AND   sales_unit_meas         = sales_unit_meas_
      AND   agreement_type          = Rebate_Agreement_Type_API.DB_SALES_PART
      AND   rebate_type             = rebate_type_
      AND   (tax_code IS NULL OR tax_code = tax_code_)
      AND   invoice_id              = invoice_id_
      AND   item_id                 = item_id_;  
      
   CURSOR get_invoice_amount_all_parts IS
      SELECT inv_line_sales_amount, inv_line_sales_gross_amount, rebate_rate, total_rebate_amount,
      invoiced_quantity, net_weight, net_volume, inv_line_sales_curr_amount
      FROM rebate_transaction_tab
      WHERE agreement_id               = agreement_id_
      AND   customer_no                = customer_no_
      AND   hierarchy_id               = hierarchy_id_
      AND   customer_level             = customer_level_      
      AND   agreement_type             = Rebate_Agreement_Type_API.DB_ALL
      AND   rebate_type                = rebate_type_
      AND   (tax_code IS NULL OR tax_code = tax_code_)
      AND   invoice_id                 = invoice_id_
      AND   item_id                    = item_id_;      

BEGIN
   agreement_rec_             := Rebate_Agreement_API.Get(agreement_id_);
   agreement_type_            := agreement_rec_.agreement_type;
   rebate_criteria_db_        := agreement_rec_.rebate_criteria;
   agreement_currency_code_   := agreement_rec_.currency_code;
   company_currency_code_     := Company_Finance_API.Get_Currency_Code(company_);

   CASE agreement_type_
      WHEN'REBATE_GROUP' THEN
         FOR update_rec_ IN get_invoice_amount LOOP
            IF rebate_rate_ IS NOT NULL THEN
               -- Calculate final rebate amount
               CASE rebate_criteria_db_
                  WHEN 'PERCENTAGE' THEN
                     IF (agreement_currency_code_ = company_currency_code_) THEN
                        rebate_amount_ := update_rec_.inv_line_sales_amount * (rebate_rate_/100);
                     ELSE
                        rebate_amount_ := update_rec_.inv_line_sales_curr_amount * (rebate_rate_/100);
                     END IF;   
                  WHEN 'AMOUNT_PER_INVOICED_QTY' THEN
                     rebate_amount_ := update_rec_.invoiced_quantity * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_WEIGHT' THEN
                     rebate_amount_ := update_rec_.net_weight * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_VOLUME' THEN  
                     rebate_amount_ := update_rec_.net_volume * rebate_rate_;
               END CASE;
               rebate_        := rebate_rate_;
            ELSE
               -- If no minimum value is added on the Deal per Rebate Group tab
               -- then use the rebate_rate and rebate_amount
               rebate_amount_ := update_rec_.total_rebate_amount;
               rebate_        := update_rec_.rebate_rate;
            END IF;

            -- Update rebate_transaction_tab with final_rebate_rate and final_rebate_amount
            UPDATE rebate_transaction_tab
               SET final_rebate_rate = rebate_,
                   final_rebate_amount = rebate_amount_
               WHERE agreement_id            = agreement_id_
               AND   customer_no             = customer_no_
               AND   hierarchy_id            = hierarchy_id_
               AND   customer_level          = customer_level_
               AND   sales_part_rebate_group = sales_part_rebate_group_
               AND   agreement_type          = Rebate_Agreement_Type_API.DB_REBATE_GROUP
               AND   rebate_type             = rebate_type_
               AND   (tax_code IS NULL OR tax_code = tax_code_)
               AND   invoice_id              = invoice_id_
               AND   item_id                 = item_id_;

         END LOOP;
      WHEN 'ASSORTMENT' THEN
         FOR update_rec_ IN get_invoice_amount_assort LOOP
            IF rebate_rate_ IS NOT NULL THEN
               -- Calculate final rebate amount
               CASE rebate_criteria_db_
                  WHEN 'PERCENTAGE' THEN
                     IF (agreement_currency_code_ = company_currency_code_) THEN
                        rebate_amount_ := update_rec_.inv_line_sales_amount * (rebate_rate_/100);
                     ELSE
                        rebate_amount_ := update_rec_.inv_line_sales_curr_amount * (rebate_rate_/100);
                     END IF;   
                  WHEN 'AMOUNT_PER_INVOICED_QTY' THEN
                     rebate_amount_ := update_rec_.invoiced_quantity * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_WEIGHT' THEN
                     rebate_amount_ := update_rec_.net_weight * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_VOLUME' THEN  
                     rebate_amount_ := update_rec_.net_volume * rebate_rate_;
               END CASE;
               rebate_        := rebate_rate_;
            ELSE
               -- If no minimum value is added on the Deal per Assortment tab
               -- then use the rebate_rate and rebate_amount
               rebate_amount_ := update_rec_.total_rebate_amount;
               rebate_        := update_rec_.rebate_rate;
            END IF;

            -- Update rebate_transaction_tab with final_rebate_rate and final_rebate_amount
            UPDATE rebate_transaction_tab
               SET final_rebate_rate   = rebate_,
                   final_rebate_amount = rebate_amount_
               WHERE agreement_id         = agreement_id_
               AND   customer_no          = customer_no_
               AND   hierarchy_id         = hierarchy_id_
               AND   customer_level       = customer_level_
               AND   assortment_id        = assortment_id_
               AND   assortment_node_id   = assortment_node_id_
               AND   agreement_type       = Rebate_Agreement_Type_API.DB_ASSORTMENT
               AND   rebate_type          = rebate_type_
               AND   (tax_code IS NULL OR tax_code = tax_code_)
               AND   invoice_id           = invoice_id_
               AND   item_id              = item_id_;

         END LOOP;
      WHEN 'SALES_PART' THEN   
         FOR update_rec_ IN get_invoice_amount_part LOOP
            IF rebate_rate_ IS NOT NULL THEN
               -- Calculate final rebate amount
               CASE rebate_criteria_db_
                  WHEN 'PERCENTAGE' THEN
                     IF (agreement_currency_code_ = company_currency_code_) THEN
                        rebate_amount_ := update_rec_.inv_line_sales_amount * (rebate_rate_/100);
                     ELSE
                        rebate_amount_ := update_rec_.inv_line_sales_curr_amount * (rebate_rate_/100);
                     END IF;   
                  WHEN 'AMOUNT_PER_INVOICED_QTY' THEN
                     rebate_amount_ := update_rec_.invoiced_quantity * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_WEIGHT' THEN
                     rebate_amount_ := update_rec_.net_weight * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_VOLUME' THEN  
                     rebate_amount_ := update_rec_.net_volume * rebate_rate_;
               END CASE;
               rebate_        := rebate_rate_;
            ELSE
               -- If no minimum value is added on the Deal per Rebate Group tab
               -- then use the rebate_rate and rebate_amount
               rebate_amount_ := update_rec_.total_rebate_amount;
               rebate_        := update_rec_.rebate_rate;
            END IF;

            -- Update rebate_transaction_tab with final_rebate_rate and final_rebate_amount
            UPDATE rebate_transaction_tab
               SET final_rebate_rate   = rebate_,
                   final_rebate_amount = rebate_amount_
               WHERE agreement_id            = agreement_id_
               AND   customer_no             = customer_no_
               AND   hierarchy_id            = hierarchy_id_
               AND   customer_level          = customer_level_
               AND   agreement_type          = Rebate_Agreement_Type_API.DB_SALES_PART
               AND   sales_unit_meas         = sales_unit_meas_
               AND   part_no                 = part_no_
               AND   rebate_type             = rebate_type_
               AND   (tax_code IS NULL OR tax_code = tax_code_)
               AND   invoice_id              = invoice_id_
               AND   item_id                 = item_id_;

         END LOOP;      
      WHEN 'ALL' THEN   
         FOR update_rec_ IN get_invoice_amount_all_parts LOOP
            IF rebate_rate_ IS NOT NULL THEN
               -- Calculate final rebate amount
               CASE rebate_criteria_db_
                  WHEN 'PERCENTAGE' THEN
                     IF (agreement_currency_code_ = company_currency_code_) THEN
                        rebate_amount_ := update_rec_.inv_line_sales_amount * (rebate_rate_/100);
                     ELSE
                        rebate_amount_ := update_rec_.inv_line_sales_curr_amount * (rebate_rate_/100);
                     END IF;   
                  WHEN 'AMOUNT_PER_INVOICED_QTY' THEN
                     rebate_amount_ := update_rec_.invoiced_quantity * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_WEIGHT' THEN
                     rebate_amount_ := update_rec_.net_weight * rebate_rate_;
                  WHEN 'AMOUNT_PER_NET_VOLUME' THEN  
                     rebate_amount_ := update_rec_.net_volume * rebate_rate_;
               END CASE;
               rebate_        := rebate_rate_;
            ELSE
               -- If no minimum value is added on the Deal per Rebate Group tab
               -- then use the rebate_rate and rebate_amount
               rebate_amount_ := update_rec_.total_rebate_amount;
               rebate_        := update_rec_.rebate_rate;
            END IF;

            -- Update rebate_transaction_tab with final_rebate_rate and final_rebate_amount
            UPDATE rebate_transaction_tab
               SET final_rebate_rate   = rebate_,
                   final_rebate_amount = rebate_amount_
               WHERE agreement_id            = agreement_id_
               AND   customer_no             = customer_no_
               AND   hierarchy_id            = hierarchy_id_
               AND   customer_level          = customer_level_
               AND   agreement_type          = Rebate_Agreement_Type_API.DB_ALL
               AND   rebate_type             = rebate_type_
               AND   (tax_code IS NULL OR tax_code = tax_code_)
               AND   invoice_id              = invoice_id_
               AND   item_id                 = item_id_;

         END LOOP;            
   END CASE;
END Add_Final_Rebate;


-- Get_Total_Reb_Amt_For_Inv_Line
--   Returns total rebate amount for a given invoice line.
@UncheckedAccess
FUNCTION Get_Total_Reb_Amt_For_Inv_Line (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   item_id_       IN NUMBER ) RETURN NUMBER
IS
   temp_total_    NUMBER;
   CURSOR get_total_amt IS
      SELECT SUM(total_rebate_amount)
      FROM rebate_transaction_tab
      WHERE company = company_
      AND invoice_id = invoice_id_
      AND item_id = item_id_;
BEGIN
   OPEN get_total_amt;
   FETCH get_total_amt INTO temp_total_;
   CLOSE get_total_amt;
   RETURN temp_total_;
END Get_Total_Reb_Amt_For_Inv_Line;



-- Get_Rebate_Grp_For_Inv_Line
--   Returns sales part rebate group for a given invoice line.
@UncheckedAccess
FUNCTION Get_Rebate_Grp_For_Inv_Line (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN VARCHAR2
IS
   temp_reb_grp_    REBATE_TRANSACTION_TAB.sales_part_rebate_group%TYPE;
   CURSOR get_total_amt IS
      SELECT sales_part_rebate_group
      FROM rebate_transaction_tab
      WHERE company = company_
      AND invoice_id = invoice_id_
      AND item_id = item_id_;
BEGIN
   OPEN get_total_amt;
   FETCH get_total_amt INTO temp_reb_grp_;
   CLOSE get_total_amt;
   RETURN temp_reb_grp_;
END Get_Rebate_Grp_For_Inv_Line;



-- Get_Assort_Id_For_Inv_Line
--   Returns assortment id for a given invoice line.
@UncheckedAccess
FUNCTION Get_Assort_Id_For_Inv_Line (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   item_id_       IN NUMBER,
   customer_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_id_    REBATE_TRANSACTION_TAB.assortment_id%TYPE;
   CURSOR get_total_amt IS
      SELECT assortment_id
      FROM rebate_transaction_tab
      WHERE company = company_
      AND invoice_id = invoice_id_
      AND item_id = item_id_
      AND customer_no = customer_no_;
BEGIN
   OPEN get_total_amt;
   FETCH get_total_amt INTO temp_id_;
   CLOSE get_total_amt;
   RETURN temp_id_;
END Get_Assort_Id_For_Inv_Line;



-- Get_Assort_Node_For_Inv_Line
--   Returns assortment node for a given invoice line.
@UncheckedAccess
FUNCTION Get_Assort_Node_For_Inv_Line (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   item_id_       IN NUMBER,
   customer_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_id_    REBATE_TRANSACTION_TAB.assortment_node_id%TYPE;
   CURSOR get_total_amt IS
      SELECT assortment_node_id
      FROM rebate_transaction_tab
      WHERE company = company_
      AND invoice_id = invoice_id_
      AND item_id = item_id_
      AND customer_no = customer_no_;
BEGIN
   OPEN get_total_amt;
   FETCH get_total_amt INTO temp_id_;
   CLOSE get_total_amt;
   RETURN temp_id_;
END Get_Assort_Node_For_Inv_Line;

PROCEDURE Get_Customer_Rebate_Info (
   active_agreement_list_  OUT Rebate_Agreement_API.Agreement_Info_List,
   company_          IN VARCHAR2,
   customer_no_      IN VARCHAR2, 
   invoice_date_     IN DATE )
IS
   aggr_customer_parent_  VARCHAR2(20);
   customer_parent_       VARCHAR2(20);
   hierarchy_id_          VARCHAR2(10);
BEGIN
   -- Get active agreement list for the customer
   Rebate_Agreement_Receiver_API.Get_Active_Agreement(active_agreement_list_, customer_no_, company_, trunc(invoice_date_));
   customer_parent_      := customer_no_;
   aggr_customer_parent_ := customer_parent_;
   -- If the customer is not connected to an agreement find the customer's parent and the active agreement for that customer
   IF active_agreement_list_.COUNT < 1 THEN
      WHILE active_agreement_list_.COUNT < 1 LOOP
         hierarchy_id_     := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_parent_);
         customer_parent_  := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_parent_);
         aggr_customer_parent_ := customer_parent_;
         -- Get active agreement list for the customer parent
         Rebate_Agreement_Receiver_API.Get_Active_Agreement(active_agreement_list_, customer_parent_, company_, trunc(invoice_date_));
         -- If there is no customer_parent_ the active_agreement_ is also null
         EXIT WHEN customer_parent_ IS NULL;
      END LOOP;
   END IF;
   
   IF (active_agreement_list_.COUNT > 0) THEN
      FOR i_ IN 1 .. active_agreement_list_.COUNT LOOP
         active_agreement_list_(i_).customer_parent := aggr_customer_parent_;
         IF (hierarchy_id_ IS NOT NULL) THEN
            active_agreement_list_(i_).hierarchy_id := hierarchy_id_;
         END IF; 
         IF active_agreement_list_(i_).hierarchy_id != '*' THEN
            -- Get the customer's level
            active_agreement_list_(i_).customer_level := Cust_Hierarchy_Struct_API.Get_Level_No(active_agreement_list_(i_).hierarchy_id, customer_no_);
         ELSE
            active_agreement_list_(i_).customer_level := 0;
         END IF;
      END LOOP; 
   END IF;
   
END Get_Customer_Rebate_Info;

