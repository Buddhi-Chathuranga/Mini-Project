-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderCashPlan
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220127  Inaklk  SC21R2-7424, Remove method call from cursor in Load_Cshplan_Customer_Order_Data___
--  220125  Inaklk  SC21R2-7347, Handle unit charges calculation when co lines are partially delivered
--  220124  Inaklk  SC21R2-7330, Wrong value is fetched as contract with customer order transactions, remove contract from paramaters 
--  220104  Inaklk  SC21R2-7011, Modified Generate_Installment_Info___ to store order wanted delivery date if charge exsist, Remove Get_Cash_Plan_Ext_Int___ and modified Load_Cash_Plan_Data___ to set counterpart_type,
--                  handled devision by zero error for customer invoices, restricted 0 value records in cash plan 
--  211217  Inaklk  SC21R2-5934, Added Create_Sales_Amnt_Calc_Tmp___ and modified Get_Sub_Source_Status___ to align with basic data 
--  211216  Inaklk  SC21R2-6385,Renamed Gross to Get_Inv_Gross_Excl_Prepay___ and added inline documentation and added code segments
--  211209  Inaklk  SC21R2-6030,Added stage billing functionality
--  211201  Inaklk  SC21R2-6386,Added documentation
--  211129  Inaklk  SC21R2-6194,Implemented prepayment invoice consumption from final customer debit invoices
--  211125  Inaklk  SC21R2-6185,Implement preliminary prepayment invoice cash plan
--  211122  Inaklk  SC21R2-5931,Implemented project cash planning for non invoiced customers, handled discount, co header and line charges and advance payments
--  211102  Inaklk  SC21R2-5279,Created to handle Cash Plan for customer order and preliminary customer invoices
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Cshplan_Proj_Amnt_Proportion_Rec IS RECORD (
   project_id              VARCHAR2(10),
   net_curr_amount         NUMBER,
   gross_curr_amount       NUMBER,
   net_propotion           NUMBER,
   gross_propotion         NUMBER);

TYPE Cshplan_Proj_Amnt_Proportion_Tab IS TABLE OF Cshplan_Proj_Amnt_Proportion_Rec INDEX BY BINARY_INTEGER;

TYPE Cshplan_Due_Date_Tab IS TABLE OF DATE INDEX BY BINARY_INTEGER; 

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- IMPLEMENTATION METHODS FOR COMMON LOGIC -------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Calc_Net_Gross_Propotion___(
   net_propotion_          OUT      NUMBER,
   gross_propotion_        OUT      NUMBER,
   net_curr_amount_        IN       NUMBER,
   gross_curr_amount_      IN       NUMBER,
   total_gross_amount_     IN       NUMBER)
IS
BEGIN
   net_propotion_    := net_curr_amount_ / total_gross_amount_;
   gross_propotion_  := gross_curr_amount_ / total_gross_amount_;
END Calc_Net_Gross_Propotion___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Calc_Prorata_Net_Gross_Amnts___(
   net_prorata_amount_     OUT      NUMBER,
   gross_prorata_amount_   OUT      NUMBER,
   curr_amount_            IN       NUMBER,
   net_propotion_          IN       NUMBER,
   gross_propotion_        IN       NUMBER)
IS
BEGIN
   net_prorata_amount_     := curr_amount_ * net_propotion_;
   gross_prorata_amount_   := curr_amount_ * gross_propotion_; 
END Calc_Prorata_Net_Gross_Amnts___;

--Uses to minimize the amount of data queried for particular order or invoice, and to improve performance
@IgnoreUnitTest DMLOperation
PROCEDURE Clear_Temp_Calc_Info___(
   source_ref1_      IN    VARCHAR2,
   source_ref2_      IN    VARCHAR2,
   source_ref_type_  IN    VARCHAR2)
IS
BEGIN
   IF (source_ref_type_ = 'CUSTOMER_ORDER') THEN
      DELETE 
      FROM   sales_cash_plan_amnt_calc_tmp
      WHERE  source_ref1      = source_ref1_
      AND    source_ref_type  = source_ref_type_;
   ELSIF (source_ref_type_ = 'CUSTOMER_ORDER_INVOICE') THEN
      DELETE 
      FROM   sales_cash_plan_amnt_calc_tmp
      WHERE  source_ref1      = source_ref1_
      AND    source_ref2      = source_ref2_ 
      AND    source_ref_type  = source_ref_type_;
   END IF;
END Clear_Temp_Calc_Info___;


@IgnoreUnitTest TrivialFunction
FUNCTION Get_Sub_Source_Status___(
   sub_source_id_         IN VARCHAR2,
   rowstate_              IN VARCHAR2)RETURN VARCHAR2
IS
   $IF (Component_Cshpln_SYS.INSTALLED)  $THEN
      sub_source_status_     csh_pln_sub_source_status_tab.sub_source_status%TYPE;
   $END
BEGIN
   $IF (Component_Cshpln_SYS.INSTALLED)  $THEN
      IF (sub_source_id_ = 'CUSTOMER_ORDER') THEN
         IF (rowstate_ = 'Planned') THEN
            sub_source_status_ := 'PLANNED';
         ELSIF (rowstate_ = 'Released') THEN
            sub_source_status_ := 'RELEASED';
         ELSIF (rowstate_ = 'Reserved') THEN
            sub_source_status_ := 'RESERVED';
         ELSIF (rowstate_ = 'Picked') THEN
            sub_source_status_ := 'PICKED'; 
         ELSIF (rowstate_ = 'PartiallyDelivered') THEN
            sub_source_status_ := 'PARTIALLY_DELIVERED';
         ELSIF (rowstate_ = 'Delivered') THEN
            sub_source_status_ := 'DELIVERED';    
         ELSIF (rowstate_ = 'Blocked') THEN
            sub_source_status_ := 'BLOCKED';       
         END IF;
      ELSIF (sub_source_id_ = 'CUSTOMER_ORDER_INVOICE') THEN
         IF (rowstate_ = 'Preliminary') THEN
            sub_source_status_ := 'INVOICED';
         END IF;   
      END IF; 
      RETURN sub_source_status_;
   $ELSE
      RETURN NULL;
   $END
END Get_Sub_Source_Status___;

--Wrapper method for inserting date into sales_cash_plan_amnt_calc_tmp table 
@IgnoreUnitTest DMLOperation
PROCEDURE Create_Sales_Amnt_Calc_Tmp___(
   source_ref1_            IN    VARCHAR2,
   source_ref2_            IN    VARCHAR2,
   source_ref3_            IN    VARCHAR2,
   source_ref4_            IN    VARCHAR2,
   source_ref_type_        IN    VARCHAR2,               
   planned_delivery_date_  IN    DATE,
   project_id_             IN    VARCHAR2,
   open_net_amount_        IN    NUMBER,               
   open_gross_amount_      IN    NUMBER,
   net_amount_             IN    NUMBER,
   gross_amount_           IN    NUMBER)
IS
BEGIN
   IF (gross_amount_ != 0) THEN
      INSERT 
         INTO sales_cash_plan_amnt_calc_tmp(
            source_ref1,
            source_ref2,
            source_ref3,
            source_ref4,
            source_ref_type,               
            planned_delivery_date,
            project_id,
            open_net_amount,               
            open_gross_amount,
            net_amount,
            gross_amount)
         VALUES 
            (source_ref1_,
            source_ref2_,
            source_ref3_,
            source_ref4_,
            source_ref_type_,               
            planned_delivery_date_,
            project_id_,
            NVL(open_net_amount_, 0),               
            NVL(open_gross_amount_, 0),
            NVL(net_amount_, 0),
            NVL(gross_amount_, 0));  
   END IF;         
END Create_Sales_Amnt_Calc_Tmp___;

--Load cash plan data into cash_plan_balance_tab_
@IgnoreUnitTest TrivialFunction
PROCEDURE Load_Cash_Plan_Data___(
   cash_plan_balance_tab_     IN OUT Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab,
   index_                     IN OUT NUMBER,
   cash_parameter_rec_        IN     Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec,
   cash_plan_date_            IN     DATE,
   counterpart_id_            IN     VARCHAR2,
   counter_part_name_         IN     VARCHAR2,
   party_type_db_             IN     VARCHAR2,
   project_id_                IN     VARCHAR2,
   rowstate_                  IN     VARCHAR2,
   installment_net_amount_    IN     NUMBER,
   installment_gross_amount_  IN     NUMBER,
   currency_code_             IN     VARCHAR2,
   reference_text_            IN     VARCHAR2,
   source_ref1_               IN     VARCHAR2,
   source_ref2_               IN     VARCHAR2,
   source_ref3_               IN     VARCHAR2,
   source_ref4_               IN     VARCHAR2)
IS
BEGIN
   $IF (Component_Cshpln_SYS.INSTALLED) $THEN
      cash_plan_balance_tab_(index_).event_date                := cash_plan_date_; 
      cash_plan_balance_tab_(index_).counterpart_id            := counterpart_id_; 
      cash_plan_balance_tab_(index_).counterpart_name          := counter_part_name_;
      cash_plan_balance_tab_(index_).counterpart_type          := party_type_db_;
      cash_plan_balance_tab_(index_).project                   := project_id_;
      cash_plan_balance_tab_(index_).currency_amount           := installment_net_amount_;
      cash_plan_balance_tab_(index_).currency_amount_with_tax  := installment_gross_amount_;
      cash_plan_balance_tab_(index_).currency_code             := currency_code_;                
      cash_plan_balance_tab_(index_).sub_source_status         := Get_Sub_Source_Status___(cash_parameter_rec_.sub_source_id, rowstate_); 
      cash_plan_balance_tab_(index_).reference_text            := reference_text_;
      cash_plan_balance_tab_(index_).source_ref1               := source_ref1_; 
      cash_plan_balance_tab_(index_).source_ref2               := source_ref2_; 
      cash_plan_balance_tab_(index_).source_ref3               := source_ref3_; 
      cash_plan_balance_tab_(index_).source_ref4               := source_ref4_;
      Cash_Plan_Utility_API.Assign_Cash_Plan_Values(cash_plan_balance_tab_, index_, cash_parameter_rec_); 
      index_ := index_ + 1;
   $ELSE
      NULL;
   $END
END Load_Cash_Plan_Data___;


--Load cash plan data for installments
PROCEDURE Load_All_Cash_Plan_Data___(
   cash_plan_balance_tab_      IN OUT NOCOPY  Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab,
   index_                      IN OUT NUMBER,   
   cshplan_proj_prop_rec_      IN     Cshplan_Proj_Amnt_Proportion_Rec,
   cash_parameter_rec_         IN     Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec,
   pay_installment_data_tab_   IN     Payment_Term_API.Pay_Installment_Data_Tab,
   payment_delay_              IN     NUMBER,
   customer_no_                IN     VARCHAR2,
   customer_name_              IN     VARCHAR2,  
   party_type_                 IN     VARCHAR2,
   currency_                   IN     VARCHAR2,
   source_ref1_                IN     VARCHAR2,
   source_ref2_                IN     VARCHAR2,
   source_ref3_                IN     VARCHAR2,
   source_ref4_                IN     VARCHAR2,
   rowstate_                   IN     VARCHAR2,
   reference_text_             IN     VARCHAR2)
IS
   cash_plan_date_            DATE;
   calc_net_prop_amount_      NUMBER := NULL;
   calc_gross_prop_amount_    NUMBER := NULL;
BEGIN
   IF(pay_installment_data_tab_.COUNT > 0) THEN
      FOR i_ IN pay_installment_data_tab_.FIRST..pay_installment_data_tab_.LAST LOOP               
         calc_net_prop_amount_   := NULL;
         calc_gross_prop_amount_ := NULL;
         cash_plan_date_         := pay_installment_data_tab_(i_).due_date;
         cash_plan_date_         := cash_plan_date_ + payment_delay_;

         --Calculate project proptionate for installment amount
         Calc_Prorata_Net_Gross_Amnts___(calc_net_prop_amount_,
                                         calc_gross_prop_amount_,
                                         pay_installment_data_tab_(i_).curr_amount,
                                         cshplan_proj_prop_rec_.net_propotion,
                                         cshplan_proj_prop_rec_.gross_propotion);

         IF(cash_plan_date_ <= cash_parameter_rec_.until_date AND (calc_gross_prop_amount_ != 0 OR calc_net_prop_amount_ != 0))THEN
            Load_Cash_Plan_Data___( cash_plan_balance_tab_,
                                    index_,
                                    cash_parameter_rec_,
                                    cash_plan_date_,
                                    customer_no_,
                                    customer_name_,
                                    party_type_,
                                    cshplan_proj_prop_rec_.project_id,
                                    rowstate_,
                                    calc_net_prop_amount_,
                                    calc_gross_prop_amount_,
                                    currency_,
                                    reference_text_,
                                    source_ref1_, --order_no or invoice_id 
                                    pay_installment_data_tab_(i_).installment_id, --source_ref2 is null for both customer order and customer invoices,so include installement_id
                                    source_ref3_,
                                    source_ref4_);
         END IF;                     
      END LOOP;
   END IF;
END Load_All_Cash_Plan_Data___;

-------------------- IMPLEMENTATION METHODS FOR CUSTOMER ORDER SUB SOURCE -------------------

-- Return TRUE if customer order line has stage billing profile, and all of the lines stages have an expected approval date
FUNCTION Is_Stage_Billing_Exist___(
   order_no_      IN    VARCHAR2,
   line_no_       IN    VARCHAR2,
   rel_no_        IN    VARCHAR2,
   line_item_no_  IN    NUMBER,
   stage_billing_ IN    VARCHAR2) RETURN BOOLEAN
IS
   is_stage_billing_    BOOLEAN := FALSE;
   dummy_               NUMBER  := 0;
   
   CURSOR check_expected_approval_date IS
      SELECT 1
      FROM   order_line_staged_billing_tab
      WHERE  order_no      = order_no_
      AND    line_no       = line_no_
      AND    rel_no        = rel_no_
      AND    line_item_no  = line_item_no_
      AND    expected_approval_date IS NULL;
BEGIN
   IF(stage_billing_ = 'NOT STAGED BILLING') THEN
      is_stage_billing_ := FALSE;
   ELSE
      OPEN check_expected_approval_date;
      FETCH check_expected_approval_date INTO dummy_;
      IF(check_expected_approval_date%FOUND) THEN
         is_stage_billing_ := FALSE;
      ELSE
         is_stage_billing_ := TRUE;
      END IF;
      CLOSE check_expected_approval_date;
   END IF;
   
   RETURN is_stage_billing_;
END Is_Stage_Billing_Exist___;

--Calculate earlierst date out of respective order lines and stage billing lines. If no valid order lines or stage billing lines exist, return order wanted delivery date.
--Consider stage billing profiles only when every stage has an expected approval date. Otherwise take the planned delivery date of the order line
FUNCTION Calc_Earliest_Ord_Del_Date___(
   order_no_   IN    VARCHAR2)RETURN DATE
IS
   wanted_delivery_date_   DATE;
   min_delivery_date_      DATE;
   min_planned_del_date_   DATE;
   min_exp_approve_date_   DATE;
   
   CURSOR get_delivery_date IS 
      SELECT MIN(col.planned_delivery_date)
      FROM   customer_order_line_tab col
      WHERE  col.order_no     = order_no_
      AND    col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    col.line_item_no <= 0
      AND    col.rental       = 'FALSE'      
      AND    (col.staged_billing = 'NOT STAGED BILLING'
      OR     (col.staged_billing = 'STAGED BILLING'
      AND    (col.line_no, col.rel_no, col.line_item_no) IN (SELECT st.line_no, st.rel_no, st.line_item_no
                                                            FROM   order_line_staged_billing_tab st
                                                            WHERE  st.order_no = order_no_
                                                            AND    st.expected_approval_date IS NULL)
             ));
   
   CURSOR get_min_exp_approve IS 
      SELECT MIN(expected_approval_date)
      FROM   order_line_staged_billing_tab
      WHERE  order_no = order_no_
      AND    (line_no, rel_no, line_item_no) NOT IN ( SELECT line_no, rel_no, line_item_no
                                                      FROM   order_line_staged_billing_tab
                                                      WHERE  order_no = order_no_
                                                      AND    expected_approval_date IS NULL);
BEGIN
   OPEN get_delivery_date;
   FETCH get_delivery_date INTO min_planned_del_date_;
   CLOSE get_delivery_date;

   OPEN get_min_exp_approve;
   FETCH get_min_exp_approve INTO min_exp_approve_date_;
   CLOSE get_min_exp_approve;

   -- no customer order lines exist, only header charge exist. Create header charge on order wanted delivery date
   IF(min_planned_del_date_ IS NULL AND min_exp_approve_date_ IS null ) THEN
      wanted_delivery_date_ := Customer_Order_API.Get_Wanted_Delivery_Date(order_no_);
      min_delivery_date_    := wanted_delivery_date_;
   ELSE
      min_planned_del_date_ := NVL(min_planned_del_date_, TO_DATE('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN'));
      min_exp_approve_date_ := NVL(min_exp_approve_date_, TO_DATE('9999-12-31', 'YYYY-MM-DD', 'NLS_CALENDAR=GREGORIAN'));
      min_delivery_date_    := LEAST(min_planned_del_date_, min_exp_approve_date_);
   END IF;
   
   RETURN min_delivery_date_;
END Calc_Earliest_Ord_Del_Date___;

PROCEDURE Calc_Order_Header_Charge_Amount___(
   total_net_charge_amount_   OUT   NUMBER, 
   total_gross_charge_amount_ OUT   NUMBER, 
   order_no_                  IN    VARCHAR2)
IS
   order_net_amount_          NUMBER;
   order_gross_amount_        NUMBER;
   charge_net_amount_         NUMBER;
   charge_gross_amount_       NUMBER;
   tax_amount_                NUMBER;
   use_price_incl_tax_        customer_order_tab.use_price_incl_tax%TYPE := 'TRUE';
   company_                   site_tab.company%TYPE;
   
   CURSOR header_charges IS 
      SELECT c.sequence_no, c.charge, c.charge_amount, c.charge_amount_incl_tax, c.charged_qty
      FROM   customer_order_charge_tab c
      WHERE  c.order_no       = order_no_
      AND    c.line_no  IS NULL
      AND    c.rel_no IS NULL 
      AND    c.invoiced_qty   = 0;
   
   CURSOR order_line_amount IS 
      SELECT SUM((col.sale_unit_price * col.price_conv_factor * col.buy_qty_due) * (100 - col.discount)/100 * (100 - (col.order_discount + col.additional_discount))/100)     net_amount,
             SUM((col.unit_price_incl_tax * col.price_conv_factor * col.buy_qty_due) * (100 - col.discount)/100 * (100 - (col.order_discount + col.additional_discount))/100) gross_amount
      FROM   customer_order_line_tab col
      WHERE  col.order_no     = order_no_
      AND    col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered') 
      AND    col.line_item_no <= 0
      AND    col.rental       = 'FALSE';
BEGIN
   use_price_incl_tax_  := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_);
   company_             := Site_API.Get_Company(Customer_Order_API.Get_Contract(order_no_));
   
   OPEN order_line_amount;
   FETCH order_line_amount INTO order_net_amount_, order_gross_amount_;
   CLOSE order_line_amount;

   total_net_charge_amount_   := 0;
   total_gross_charge_amount_ := 0;
   FOR charge_rec_ IN header_charges LOOP
      charge_net_amount_         := NVL((charge_rec_.charge_amount * charge_rec_.charged_qty),(charge_rec_.charge * order_net_amount_ / 100));
      IF(use_price_incl_tax_ = 'TRUE') THEN
         charge_gross_amount_       := NVL((charge_rec_.charge_amount_incl_tax * charge_rec_.charged_qty),(charge_rec_.charge * order_gross_amount_ / 100));
      ELSE
         tax_amount_ := Source_Tax_Item_API.Get_Total_Tax_Curr_Amount(company_, 
                                                                     Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                                     order_no_,
                                                                     TO_CHAR(charge_rec_.sequence_no),
                                                                     '*',
                                                                     '*',
                                                                     '*');
         charge_gross_amount_ := charge_net_amount_ + tax_amount_;                                                            
      END IF;
      total_net_charge_amount_   := total_net_charge_amount_ + NVL(charge_net_amount_,0);
      total_gross_charge_amount_ := total_gross_charge_amount_ + NVL(charge_gross_amount_,0);
   END LOOP;
END Calc_Order_Header_Charge_Amount___;


PROCEDURE Calc_Order_Line_Charge_Amount___(
   tot_open_net_charge_amount_   OUT   NUMBER,
   tot_open_gross_charge_amount_ OUT   NUMBER,
   total_net_charge_amount_      OUT   NUMBER, 
   total_gross_charge_amount_    OUT   NUMBER, 
   order_no_                     IN    VARCHAR2, 
   line_no_                      IN    VARCHAR2, 
   rel_no_                       IN    VARCHAR2, 
   line_item_no_                 IN    NUMBER)
IS
   line_net_amount_        NUMBER;
   line_gross_amount_      NUMBER;
   charge_net_amount_      NUMBER;
   charge_gross_amount_    NUMBER;
   open_qty_               NUMBER;
   
   CURSOR line_charges IS 
      SELECT c.charge, c.charge_amount, c.charge_amount_incl_tax, c.charged_qty, c.invoiced_qty
      FROM   customer_order_charge_tab c
      WHERE  c.order_no     = order_no_
      AND    c.line_no      = line_no_
      AND    c.rel_no       = rel_no_
      AND    c.line_item_no = line_item_no_
      AND    c.charged_qty > c.invoiced_qty;
      
   CURSOR order_line_amount IS 
      SELECT (col.sale_unit_price * col.price_conv_factor * col.buy_qty_due) * (100 - col.discount)/100 * (100 - (col.order_discount + col.additional_discount))/100       net_amount,
             (col.unit_price_incl_tax * col.price_conv_factor * col.buy_qty_due) * (100 - col.discount)/100 * (100 - (col.order_discount + col.additional_discount))/100   gross_amount
      FROM   customer_order_line_tab col
      WHERE  col.order_no     = order_no_
      AND    col.line_no      = line_no_
      AND    col.rel_no       = rel_no_
      AND    col.line_item_no = line_item_no_;
BEGIN
   OPEN order_line_amount;
   FETCH order_line_amount INTO line_net_amount_, line_gross_amount_;
   CLOSE order_line_amount;
   
   total_net_charge_amount_      := 0;
   total_gross_charge_amount_    := 0;
   tot_open_net_charge_amount_   := 0;
   tot_open_gross_charge_amount_ := 0; 
   
   FOR charge_rec_ IN line_charges LOOP
      open_qty_                     := charge_rec_.charged_qty  - charge_rec_.invoiced_qty;
      charge_net_amount_            := NVL((charge_rec_.charge_amount * open_qty_),(charge_rec_.charge * line_net_amount_/charge_rec_.charged_qty * open_qty_ / 100));
      charge_gross_amount_          := NVL((charge_rec_.charge_amount_incl_tax * open_qty_),(charge_rec_.charge * line_gross_amount_ / charge_rec_.charged_qty * open_qty_ / 100));
      tot_open_net_charge_amount_   := tot_open_net_charge_amount_ + NVL(charge_net_amount_,0);
      tot_open_gross_charge_amount_ := tot_open_gross_charge_amount_ + NVL(charge_gross_amount_,0);
      
      charge_net_amount_         := NVL((charge_rec_.charge_amount * charge_rec_.charged_qty),(charge_rec_.charge * line_net_amount_ / 100));
      charge_gross_amount_       := NVL((charge_rec_.charge_amount_incl_tax * charge_rec_.charged_qty),(charge_rec_.charge * line_gross_amount_ / 100));
      total_net_charge_amount_   := total_net_charge_amount_ + NVL(charge_net_amount_,0);
      total_gross_charge_amount_ := total_gross_charge_amount_ + NVL(charge_gross_amount_,0);
   END LOOP;
END Calc_Order_Line_Charge_Amount___;


--Create temp data for stage billing lines where every stage having expected approval date
PROCEDURE Create_Stage_Billing_Tmp___(
   order_no_                  IN    VARCHAR2,
   line_no_                   IN    VARCHAR2,
   rel_no_                    IN    VARCHAR2,
   line_item_no_              IN    NUMBER,
   project_id_                IN    VARCHAR2,
   line_net_amount_           IN    NUMBER,
   line_gross_amount_         IN    NUMBER,
   line_open_net_amount_      IN    NUMBER,
   line_open_gross_amount_    IN    NUMBER)
IS
   net_charge_amount_               NUMBER; 
   gross_charge_amount_             NUMBER;
   open_net_charge_amount_          NUMBER; 
   open_gross_charge_amount_        NUMBER;
   open_stage_perecentage_total_    NUMBER   := 0;
   invoiced_stage_perecentage_      NUMBER;
   stage_net_amount_                NUMBER;
   stage_gross_amount_              NUMBER;
   stage_tot_net_amount_            NUMBER;
   stage_tot_gross_amount_          NUMBER;
   include_charge_                  BOOLEAN  := TRUE; 
   
   CURSOR get_stage_billing_info IS
      SELECT stage, total_percentage, expected_approval_date 
      FROM  order_line_staged_billing_tab
      WHERE order_no       = order_no_
      AND   line_no        = line_no_
      AND   rel_no         = rel_no_
      AND   line_item_no   = line_item_no_
      AND   rowstate IN ('Planned', 'Approved')
      ORDER BY expected_approval_date;
BEGIN
   invoiced_stage_perecentage_   := Order_Line_Staged_Billing_API.Get_Total_Invoiced_Percentage(order_no_, line_no_, rel_no_, line_item_no_);
   open_stage_perecentage_total_ := 100 - NVL(invoiced_stage_perecentage_, 0);
   
   FOR stage_rec_ IN get_stage_billing_info LOOP
      stage_net_amount_          := line_open_net_amount_ / open_stage_perecentage_total_ * NVL(stage_rec_.total_percentage, 0);
      stage_gross_amount_        := line_open_gross_amount_ / open_stage_perecentage_total_ * NVL(stage_rec_.total_percentage, 0);
      
      stage_tot_net_amount_      := line_net_amount_ / 100 * NVL(stage_rec_.total_percentage, 0); 
      stage_tot_gross_amount_    := line_gross_amount_ / 100 * NVL(stage_rec_.total_percentage, 0);
      
      --include line charges to first approval date
      IF(include_charge_) THEN
         Calc_Order_Line_Charge_Amount___(open_net_charge_amount_,
                                          open_gross_charge_amount_,
                                          net_charge_amount_, 
                                          gross_charge_amount_, 
                                          order_no_, 
                                          line_no_, 
                                          rel_no_, 
                                          line_item_no_);

         stage_net_amount_       := stage_net_amount_ + NVL(open_net_charge_amount_,0);
         stage_gross_amount_     := stage_gross_amount_ + NVL(open_gross_charge_amount_,0); 
         stage_tot_net_amount_   := stage_tot_net_amount_ + NVL(net_charge_amount_,0);
         stage_tot_gross_amount_ := stage_tot_gross_amount_ + NVL(gross_charge_amount_,0); 
               
         include_charge_ := FALSE;
      END IF;
      
      Create_Sales_Amnt_Calc_Tmp___(order_no_,
                                    line_no_, 
                                    rel_no_, 
                                    TO_CHAR(line_item_no_),
                                    'CUSTOMER_ORDER',
                                    stage_rec_.expected_approval_date,
                                    project_id_,
                                    stage_net_amount_,
                                    stage_gross_amount_,
                                    stage_tot_net_amount_,
                                    stage_tot_gross_amount_);
   END LOOP;
END Create_Stage_Billing_Tmp___;

--Insert order lines amounts and order line charges with line plan delivery date. 
@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Cust_Ord_Line_Tmp___(
   order_no_                  IN    VARCHAR2,
   line_no_                   IN    VARCHAR2,
   rel_no_                    IN    VARCHAR2,
   line_item_no_              IN    NUMBER,
   planned_delivery_date_     IN    DATE,
   project_id_                IN    VARCHAR2,
   line_net_amount_           IN    NUMBER,
   line_gross_amount_         IN    NUMBER,
   line_open_net_amount_      IN    NUMBER,
   line_open_gross_amount_    IN    NUMBER,
   include_charges_           IN    BOOLEAN DEFAULT TRUE)
IS
   net_charge_amount_            NUMBER; 
   gross_charge_amount_          NUMBER;
   open_net_charge_amount_       NUMBER; 
   open_gross_charge_amount_     NUMBER;
   net_amnt_                     NUMBER;
   gross_amnt_                   NUMBER;
   open_net_amnt_                NUMBER;
   open_gross_amnt_              NUMBER;
   
BEGIN
   net_amnt_         := line_net_amount_;
   gross_amnt_       := line_gross_amount_; 
   open_net_amnt_    := line_open_net_amount_;
   open_gross_amnt_  := line_open_gross_amount_;
      
   IF (include_charges_) THEN
      Calc_Order_Line_Charge_Amount___(open_net_charge_amount_,
                                       open_gross_charge_amount_,
                                       net_charge_amount_, 
                                       gross_charge_amount_, 
                                       order_no_, 
                                       line_no_, 
                                       rel_no_, 
                                       line_item_no_);

      net_amnt_         := line_net_amount_ + NVL(net_charge_amount_,0);
      gross_amnt_       := line_gross_amount_ + NVL(gross_charge_amount_,0); 
      open_net_amnt_    := line_open_net_amount_ + NVL(open_net_charge_amount_,0);
      open_gross_amnt_  := line_open_gross_amount_ + NVL(open_gross_charge_amount_,0); 
   END IF;
   
   Create_Sales_Amnt_Calc_Tmp___(order_no_, 
                                 line_no_, 
                                 rel_no_, 
                                 TO_CHAR(line_item_no_),
                                 'CUSTOMER_ORDER',
                                 planned_delivery_date_,
                                 project_id_,
                                 open_net_amnt_,
                                 open_gross_amnt_,
                                 net_amnt_,
                                 gross_amnt_);    
END Create_Cust_Ord_Line_Tmp___;


--Insert customer order line and stage billing amounts and customer order charges with delivery date info.
--Used for propotion calculation for advance and prepayment invoices and customer order subsource in cash plan
PROCEDURE Create_Ord_Temp_Calc_Info___( 
   order_no_         IN    VARCHAR2,
   include_charges_  IN    BOOLEAN DEFAULT TRUE)
IS
   max_limit_                    PLS_INTEGER := 2000;
   line_net_amount_              NUMBER;
   line_gross_amount_            NUMBER;
   line_open_net_amount_         NUMBER;
   line_open_gross_amount_       NUMBER;
   net_charge_amount_            NUMBER; 
   gross_charge_amount_          NUMBER;
   planned_delivery_date_        DATE;
   header_project_id_            customer_order_tab.project_id%TYPE;
   stage_billing_exist_          BOOLEAN := FALSE;
   
   CURSOR get_order_totals IS 
      SELECT col.line_no, col.rel_no, col.line_item_no, col.project_id, col.planned_delivery_date,
             col.sale_unit_price * col.price_conv_factor * col.buy_qty_due        line_net_amount,
             col.unit_price_incl_tax * col.price_conv_factor * col.buy_qty_due    line_gross_amount,
             col.sale_unit_price * col.price_conv_factor * (col.buy_qty_due + (col.qty_shipdiff / col.conv_factor * col.inverted_conv_factor) - col.qty_invoiced )        line_open_net_amount,
             col.unit_price_incl_tax * col.price_conv_factor *  (col.buy_qty_due + (col.qty_shipdiff / col.conv_factor * col.inverted_conv_factor) - col.qty_invoiced )   line_open_gross_amount,
             col.discount, col.additional_discount, col.order_discount, col.staged_billing
      FROM   customer_order_line_tab col
      WHERE  col.order_no              = order_no_
      AND    col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    col.line_item_no          <= 0
      AND    col.rental                = 'FALSE'
      AND    col.charged_item          != 'ITEM NOT CHARGED'
      AND    col.exchange_item         != 'EXCHANGED ITEM';
   
   TYPE Co_Line_Info_Tab IS TABLE OF get_order_totals%ROWTYPE  INDEX BY BINARY_INTEGER; 
   co_line_info_tab_             Co_Line_Info_Tab;  
BEGIN
   OPEN get_order_totals;
   LOOP
      FETCH get_order_totals BULK COLLECT INTO co_line_info_tab_ LIMIT max_limit_;  
      IF(co_line_info_tab_.COUNT > 0) THEN
         FOR i_ IN co_line_info_tab_.FIRST..co_line_info_tab_.LAST LOOP
            line_net_amount_           := co_line_info_tab_(i_).line_net_amount * (100 - co_line_info_tab_(i_).discount)/100 * (100 - (co_line_info_tab_(i_).order_discount + co_line_info_tab_(i_).additional_discount))/100;
            line_gross_amount_         := co_line_info_tab_(i_).line_gross_amount * (100 - co_line_info_tab_(i_).discount)/100 * (100 - (co_line_info_tab_(i_).order_discount + co_line_info_tab_(i_).additional_discount))/100;
            line_open_net_amount_      := co_line_info_tab_(i_).line_open_net_amount * (100 - co_line_info_tab_(i_).discount)/100 * (100 - (co_line_info_tab_(i_).order_discount + co_line_info_tab_(i_).additional_discount))/100;
            line_open_gross_amount_    := co_line_info_tab_(i_).line_open_gross_amount * (100 - co_line_info_tab_(i_).discount)/100 * (100 - (co_line_info_tab_(i_).order_discount + co_line_info_tab_(i_).additional_discount))/100;
            net_charge_amount_         := 0;
            gross_charge_amount_       := 0;  
            stage_billing_exist_       := Is_Stage_Billing_Exist___( order_no_, 
                                                                     co_line_info_tab_(i_).line_no, 
                                                                     co_line_info_tab_(i_).rel_no, 
                                                                     co_line_info_tab_(i_).line_item_no, 
                                                                     co_line_info_tab_(i_).staged_billing);
            IF(stage_billing_exist_) THEN 
               Create_Stage_Billing_Tmp___( order_no_, 
                                            co_line_info_tab_(i_).line_no, 
                                            co_line_info_tab_(i_).rel_no, 
                                            co_line_info_tab_(i_).line_item_no,
                                            co_line_info_tab_(i_).project_id,
                                            line_net_amount_,
                                            line_gross_amount_,
                                            line_open_net_amount_,
                                            line_open_gross_amount_);
            ELSE
               Create_Cust_Ord_Line_Tmp___(order_no_, 
                                           co_line_info_tab_(i_).line_no, 
                                           co_line_info_tab_(i_).rel_no, 
                                           co_line_info_tab_(i_).line_item_no,
                                           co_line_info_tab_(i_).planned_delivery_date,
                                           co_line_info_tab_(i_).project_id,
                                           line_net_amount_,
                                           line_gross_amount_,
                                           line_open_net_amount_,
                                           line_open_gross_amount_,
                                           include_charges_);
            END IF;                  
         END LOOP;
      END IF;   
      EXIT WHEN get_order_totals%NOTFOUND;
   END LOOP;
   CLOSE get_order_totals;   
    
   --Customer Order Header connected charges are handled for the earliest planned delivery date of valid oder lines or earliest expected approval date of valid stages
   IF (include_charges_) THEN
      Calc_Order_Header_Charge_Amount___(net_charge_amount_, gross_charge_amount_, order_no_);
   END IF;   
   
   IF (net_charge_amount_ != 0 AND gross_charge_amount_ != 0) THEN 
      header_project_id_      := Customer_Order_API.Get_Project_Id(order_no_);
      planned_delivery_date_  := Calc_Earliest_Ord_Del_Date___(order_no_);
      
      Create_Sales_Amnt_Calc_Tmp___(order_no_,
                                    NULL,
                                    NULL,
                                    NULL,
                                    'CUSTOMER_ORDER',
                                    planned_delivery_date_,
                                    header_project_id_,
                                    NVL(net_charge_amount_,0),
                                    NVL(gross_charge_amount_,0),
                                    NVL(net_charge_amount_,0),
                                    NVL(gross_charge_amount_,0));
   END IF;  
END Create_Ord_Temp_Calc_Info___;

--Insert installment information for the payment along with the base date for installment calculation. 
--Later use to consume Advance or prepayment invoices in preliminary or posted auth according to the earliest installment date.
@IgnoreUnitTest DMLOperation
PROCEDURE Create_Order_Installemnt_Info___(
   company_                         IN     VARCHAR2,
   order_no_                        IN     VARCHAR2,
   customer_no_                     IN     VARCHAR2,
   party_type_db_                   IN     VARCHAR2,
   pay_term_id_                     IN     VARCHAR2, 
   currency_code_                   IN     VARCHAR2,
   total_net_amount_                IN     NUMBER,
   total_tax_amount_                IN     NUMBER,
   installment_base_date_           IN     DATE)
IS
   pay_term_installment_temp_       Payment_Term_API.Pay_Installment_Data_Tab;
BEGIN
   Payment_Term_API.Get_Installment_Data(pay_term_installment_temp_, 
                                         company_,
                                         customer_no_,
                                         party_type_db_,
                                         pay_term_id_, 
                                         currency_code_,
                                         total_net_amount_,
                                         total_tax_amount_,
                                         installment_base_date_ ); 
                                         
   IF(pay_term_installment_temp_.COUNT > 0) THEN   
      FOR i_ IN pay_term_installment_temp_.FIRST..pay_term_installment_temp_.LAST LOOP
         INSERT 
            INTO customer_order_installment_tmp(
               order_no,
               base_date,
               installment_due_date,
               installment_id,
               installment_gross_amount,
               open_gross_amount)
            VALUES 
               (order_no_,
               installment_base_date_,
               pay_term_installment_temp_(i_).due_date,
               pay_term_installment_temp_(i_).installment_id,
               pay_term_installment_temp_(i_).curr_amount,
               pay_term_installment_temp_(i_).curr_amount);
      END LOOP;
   END IF;
END Create_Order_Installemnt_Info___;

--Fetch advance invoice or prepayment invoice open amounts
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Prepay_Open_Ord_Amount___(
   company_       IN    VARCHAR2,
   order_no_      IN    VARCHAR2)RETURN NUMBER
IS
   curr_amount_            NUMBER;
   prepayment_inv_meth_    company_order_info_tab.prepayment_inv_method%TYPE;
   prepay_deb_inv_type_    company_def_invoice_type_tab.def_co_prepay_deb_inv_type%TYPE;
   prepay_cre_inv_type_    company_def_invoice_type_tab.def_co_prepay_cre_inv_type%TYPE;
BEGIN
   prepayment_inv_meth_ := Company_Order_Info_API.Get_Prepayment_Inv_Method_db(company_);
   
   IF(prepayment_inv_meth_  = 'ADVANCE_INVOICE') THEN
      Invoice_API.Get_Co_Adv_Inv_Open_Amount(curr_amount_, company_, order_no_); 
   ELSE
      prepay_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type (company_);
      prepay_deb_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);
      Out_Invoice_Util_Pub_API.Get_Co_Prepay_Open_Amt_No_Sec(curr_amount_, company_, order_no_, prepay_deb_inv_type_, prepay_cre_inv_type_);
   END IF;   
   
   RETURN NVL(curr_amount_,0);
END Get_Prepay_Open_Ord_Amount___;

--consume prepayment or advance amount from installments as per earlierst installment due date, and updated the balance in the temporary table for later calculations
@IgnoreUnitTest DMLOperation
PROCEDURE Calc_Open_Install_Amount___(
   prepayment_amount_      IN    NUMBER,
   order_no_               IN    VARCHAR2)
IS
   open_amount_            NUMBER;
   calc_install_amount_    NUMBER;
   
   CURSOR get_installment_info IS
      SELECT order_no, base_date, installment_due_date, installment_id, installment_gross_amount
      FROM   customer_order_installment_tmp
      WHERE  order_no   = order_no_
      ORDER BY installment_due_date, installment_id;
BEGIN
   open_amount_ := NVL(prepayment_amount_,0);
   IF(open_amount_ = 0) THEN 
      RETURN;
   END IF;
   
   FOR rec_ IN get_installment_info LOOP
      calc_install_amount_ := rec_.installment_gross_amount; 
      IF(open_amount_ > 0) THEN 
         IF(rec_.installment_gross_amount >= open_amount_ )THEN 
            calc_install_amount_ := rec_.installment_gross_amount - open_amount_; 
            open_amount_         := 0;
         ELSE
            open_amount_         := open_amount_ - rec_.installment_gross_amount;
            calc_install_amount_ := 0;
         END IF;
      END IF;
       
      UPDATE customer_order_installment_tmp
      SET    open_gross_amount      = calc_install_amount_
      WHERE  order_no               = rec_.order_no
      AND    base_date              = rec_.base_date
      AND    installment_due_date   = rec_.installment_due_date
      AND    installment_id         = rec_.installment_id;      
   END LOOP;
END Calc_Open_Install_Amount___;

--pack intalmment info into Payment_Term_API.Pay_Installment_Data_Tab. So that it will be used in loading sales data to cash plan 
@IgnoreUnitTest TrivialFunction
PROCEDURE Build_Pay_Installment_Data___(
   pay_installment_data_tab_  OUT   Payment_Term_API.Pay_Installment_Data_Tab,
   order_no_                  IN    VARCHAR2,
   delivery_date_             IN    VARCHAR2 )
IS
   index_       NUMBER := 0;
   
   CURSOR get_installment_info IS 
      SELECT installment_due_date, installment_id, open_gross_amount  
      FROM   customer_order_installment_tmp 
      WHERE  order_no   = order_no_      
      AND    base_date  = delivery_date_; 
BEGIN
   FOR rec_ IN get_installment_info LOOP
      index_   := index_ + 1;
      pay_installment_data_tab_(index_).installment_id   := rec_.installment_id;
      pay_installment_data_tab_(index_).due_date         := rec_.installment_due_date;
      pay_installment_data_tab_(index_).curr_amount      := rec_.open_gross_amount;
      pay_installment_data_tab_(index_).net_curr_amount  := NULL;
   END LOOP;
END Build_Pay_Installment_Data___;


PROCEDURE Calc_Del_Date_Open_Totals___(
   total_net_amount_       OUT   NUMBER,
   total_gross_amount_     OUT   NUMBER,
   total_tax_amount_       OUT   NUMBER,
   order_no_               IN    VARCHAR2,
   planned_delivery_date_  IN    DATE)
IS   
   CURSOR get_open_amount IS
      SELECT SUM(a.open_net_amount)   open_net_amount,
             SUM(a.open_gross_amount) open_gross_amount
      FROM   sales_cash_plan_amnt_calc_tmp a
      WHERE  a.source_ref1           = order_no_
      AND    a.source_ref_type       = 'CUSTOMER_ORDER'
      AND    a.planned_delivery_date = planned_delivery_date_;
BEGIN
   OPEN get_open_amount;
   FETCH get_open_amount INTO total_net_amount_, total_gross_amount_;
   CLOSE get_open_amount;
   
   total_net_amount_    := NVL(total_net_amount_, 0);
   total_gross_amount_  := NVL(total_gross_amount_, 0);
   total_tax_amount_    := total_gross_amount_ - total_net_amount_;
END Calc_Del_Date_Open_Totals___;


PROCEDURE Calc_Delivery_Date_Totals___(
   total_net_amount_       OUT   NUMBER,
   total_gross_amount_     OUT   NUMBER,
   total_tax_amount_       OUT   NUMBER,
   order_no_               IN    VARCHAR2,
   planned_delivery_date_  IN    DATE)
IS   
   CURSOR get_open_amount IS
      SELECT SUM(a.net_amount)   net_amount,
             SUM(a.gross_amount) gross_amount
      FROM   sales_cash_plan_amnt_calc_tmp a
      WHERE  a.source_ref1           = order_no_
      AND    a.source_ref_type       = 'CUSTOMER_ORDER'
      AND    a.planned_delivery_date = planned_delivery_date_;
BEGIN
   OPEN get_open_amount;
   FETCH get_open_amount INTO total_net_amount_, total_gross_amount_;
   CLOSE get_open_amount;
   
   total_net_amount_    := NVL(total_net_amount_, 0);
   total_gross_amount_  := NVL(total_gross_amount_, 0);
   total_tax_amount_    := total_gross_amount_ - total_net_amount_;
END Calc_Delivery_Date_Totals___;

--Calculate all of the installment info for the customer order and calculate balance amount to be paid in that installment considering @Override
--Prepayments are deducted according the earliest installment due date.
PROCEDURE Generate_Installment_Info___(
   cshplan_due_date_tab_   OUT      Cshplan_Due_Date_Tab,
   prepayment_amount_      IN       NUMBER, 
   company_                IN       VARCHAR2, 
   order_no_               IN       VARCHAR2,
   customer_no_            IN       VARCHAR2, 
   pay_term_id_            IN       VARCHAR2, 
   currency_code_          IN       VARCHAR2,
   wanted_delivery_date_   IN       DATE)
IS    
   total_tax_amount_             NUMBER;
   total_net_amount_             NUMBER;
   total_gross_amount_           NUMBER;
   date_counter_                 NUMBER := 0;
   
   CURSOR get_delivery_date IS 
      SELECT DISTINCT col.planned_delivery_date    base_date 
      FROM   customer_order_line_tab col
      WHERE  col.order_no = order_no_
      AND    col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    col.line_item_no <= 0
      AND    col.rental = 'FALSE'
      AND    (col.staged_billing = 'NOT STAGED BILLING'
      OR     (col.staged_billing = 'STAGED BILLING'
      AND    (col.line_no, col.rel_no, col.line_item_no) IN (SELECT line_no, rel_no, line_item_no
                                                             FROM   order_line_staged_billing_tab
                                                             WHERE  order_no = order_no_
                                                             AND    expected_approval_date IS NULL)))
   UNION
      SELECT DISTINCT s.expected_approval_date    base_date
      FROM   order_line_staged_billing_tab s
      WHERE  s.order_no = order_no_
      AND    (s.line_no, s.rel_no, s.line_item_no) NOT IN ( SELECT line_no, rel_no, line_item_no
                                                            FROM   order_line_staged_billing_tab
                                                            WHERE  order_no = order_no_
                                                            AND    expected_approval_date IS NULL)
   ORDER BY base_date ASC;
BEGIN
   FOR del_date_rec_ IN get_delivery_date LOOP         
      total_net_amount_    := 0;
      total_gross_amount_  := 0;
      total_tax_amount_    := 0;     

      Calc_Del_Date_Open_Totals___( total_net_amount_, 
                                    total_gross_amount_,
                                    total_tax_amount_,
                                    order_no_, 
                                    del_date_rec_.base_date);
      
      --Calculate order installments based on planned delivery date
      IF(total_net_amount_ != 0 AND total_tax_amount_ != 0) THEN 
         date_counter_        := date_counter_ + 1;
         --Preserve planned delivery dates for later use to avoid query again
         cshplan_due_date_tab_(date_counter_) := del_date_rec_.base_date; 
         
         Create_Order_Installemnt_Info___(company_, 
                                          order_no_,
                                          customer_no_, 
                                          'CUSTOMER', 
                                          pay_term_id_, 
                                          currency_code_, 
                                          total_net_amount_, 
                                          total_tax_amount_, 
                                          del_date_rec_.base_date);  
      END IF;                                 
   END LOOP;
   
   -- No lines in the customer order. Handle header charges
   IF(date_counter_ = 0) THEN        
      total_net_amount_    := 0;
      total_gross_amount_  := 0;
      total_tax_amount_    := 0;  
      
      Calc_Del_Date_Open_Totals___( total_net_amount_, 
                                    total_gross_amount_,
                                    total_tax_amount_,
                                    order_no_, 
                                    wanted_delivery_date_);
      
      --Calculate order installments based on planned delivery date
      IF(total_net_amount_ != 0 AND total_tax_amount_ != 0) THEN 
         date_counter_         := date_counter_ + 1;
         --Preserve planned delivery dates for later use to avoid query again
         cshplan_due_date_tab_(date_counter_) := wanted_delivery_date_;
         
         Create_Order_Installemnt_Info___(company_, 
                                          order_no_,
                                          customer_no_, 
                                          'CUSTOMER', 
                                          pay_term_id_, 
                                          currency_code_, 
                                          total_net_amount_, 
                                          total_tax_amount_, 
                                          wanted_delivery_date_);  
      END IF;                                 
   END IF;
   
   --Reduce prepayment or advance invoice amount from earlierst installmet date
   --and update temp table with calculated open amount
   IF(date_counter_ > 0) THEN
      Calc_Open_Install_Amount___(prepayment_amount_, order_no_);
   END IF;
END Generate_Installment_Info___;

-- Hadles customer orders not yet invoiced
PROCEDURE Load_CshPlan_Uninv_Orders___(
   cash_plan_balance_tab_      IN OUT   Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab,
   index_                      IN OUT   NUMBER,
   cash_parameter_rec_         IN       Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec,
   order_no_                   IN       VARCHAR2, 
   customer_no_                IN       VARCHAR2,
   customer_name_              IN       VARCHAR2,
   planned_delivery_date_      IN       DATE, 
   currency_code_              IN       VARCHAR2,
   rowstate_                   IN       VARCHAR2,
   gross_amnt_for_prop_        IN       NUMBER,
   payment_delay_              IN       NUMBER,
   pay_installment_data_tab_   IN       Payment_Term_API.Pay_Installment_Data_Tab)
IS
   max_rows_                        PLS_INTEGER:= 2000;
   customer_order_prop_tab_         Cshplan_Proj_Amnt_Proportion_Tab;                
   reference_text_                  VARCHAR2(300);
   
   CURSOR get_co_line_amounts IS 
      SELECT a.project_id,
             SUM(net_amount)     net_curr_amount,
             SUM(gross_amount)   gross_curr_amount,
             NULL                net_propotion,
             NULL                gross_propotion
      FROM   sales_cash_plan_amnt_calc_tmp a
      WHERE  a.source_ref1           = order_no_
      AND    a.source_ref_type       = 'CUSTOMER_ORDER'
      AND    a.planned_delivery_date = planned_delivery_date_
      GROUP BY project_id;
BEGIN
   reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLCO: Customer Order No: :P1, expected delivery :P2', NULL, order_no_, planned_delivery_date_);
   OPEN get_co_line_amounts;
   LOOP            
      FETCH get_co_line_amounts BULK COLLECT INTO customer_order_prop_tab_ LIMIT max_rows_;
      IF(customer_order_prop_tab_.COUNT > 0) THEN               
         FOR i_ IN customer_order_prop_tab_.FIRST..customer_order_prop_tab_.LAST LOOP
            Calc_Net_Gross_Propotion___(customer_order_prop_tab_(i_).net_propotion, 
                                        customer_order_prop_tab_(i_).gross_propotion, 
                                        customer_order_prop_tab_(i_).net_curr_amount, 
                                        customer_order_prop_tab_(i_).gross_curr_amount, 
                                        gross_amnt_for_prop_); 

            Load_All_Cash_Plan_Data___(cash_plan_balance_tab_, 
                                       index_, 
                                       customer_order_prop_tab_(i_), 
                                       cash_parameter_rec_, 
                                       pay_installment_data_tab_, 
                                       payment_delay_, 
                                       customer_no_, 
                                       customer_name_, 
                                       'CUSTOMER', 
                                       currency_code_, 
                                       order_no_, 
                                       NULL, 
                                       NULL, 
                                       NULL, 
                                       rowstate_,
                                       reference_text_);  
         END LOOP;
      END IF; 
      EXIT WHEN get_co_line_amounts%NOTFOUND;             
   END LOOP;
   CLOSE get_co_line_amounts;   
END Load_CshPlan_Uninv_Orders___; 

@IgnoreUnitTest NoOutParams
PROCEDURE Load_Cshplan_Customer_Order_Data___ (
   cash_parameter_rec_ IN Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec)
IS  
   customer_name_                   customer_info_tab.name%TYPE;
   total_tax_amount_                NUMBER;
   total_net_amount_                NUMBER;
   total_gross_amount_              NUMBER;
   payment_delay_                   NUMBER;
   prepayment_amount_               NUMBER;
   index_                           NUMBER := 1;
   cash_plan_balance_tab_           Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab;
   pay_installment_data_tab_        Payment_Term_API.Pay_Installment_Data_Tab;
   cshplan_due_date_tab_            Cshplan_Due_Date_Tab;
   
   CURSOR get_none_invoiced_orders IS
      SELECT o.order_no,  
             NVL(o.customer_no_pay, o.customer_no) customer_no,  
             o.pay_term_id,
             o.currency_code,
             o.rowstate,
             o.wanted_delivery_date
      FROM   customer_order_tab o, site_tab s
      WHERE  o.rowstate IN ('Planned','Blocked','Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    s.contract = o.contract
      AND    s.company  = cash_parameter_rec_.company;
BEGIN 
   FOR order_rec_ IN get_none_invoiced_orders LOOP
      customer_name_       := Customer_Info_API.Get_Name(order_rec_.customer_no);      
      prepayment_amount_   := Get_Prepay_Open_Ord_Amount___(cash_parameter_rec_.company, order_rec_.order_no);
      
      $IF (Component_Payled_SYS.INSTALLED) $THEN
         payment_delay_    := NVL(Identity_Pay_Info_API.Get_Payment_Delay_No_Sec(cash_parameter_rec_.company, order_rec_.customer_no, 'CUSTOMER'),0);
      $ELSE
         payment_delay_    := 0;
      $END
      --Calculate customer order line amounts including charges and store temporary with planned delivery date
      Create_Ord_Temp_Calc_Info___(order_rec_.order_no, TRUE);
      
      --Consumed prepayment or advance invoice amounts from earlierst installment, based on planned delivery date
      --And calculate open installement amount and installment due date 
      Generate_Installment_Info___( cshplan_due_date_tab_,
                                    prepayment_amount_,  
                                    cash_parameter_rec_.company, 
                                    order_rec_.order_no,
                                    order_rec_.customer_no, 
                                    order_rec_.pay_term_id, 
                                    order_rec_.currency_code,
                                    order_rec_.wanted_delivery_date);

      IF(cshplan_due_date_tab_.COUNT > 0 ) THEN 
         --propotionate open installemnt amounts for projects per delivery dates
         FOR count_ IN cshplan_due_date_tab_.FIRST..cshplan_due_date_tab_.LAST LOOP
            Build_Pay_Installment_Data___(pay_installment_data_tab_, order_rec_.order_no, cshplan_due_date_tab_(count_));

            --Calculated total gross amount for a planned delivery date. 
            --This amount is used to calculate project propotions
            Calc_Delivery_Date_Totals___( total_net_amount_, 
                                          total_gross_amount_, 
                                          total_tax_amount_, 
                                          order_rec_.order_no, 
                                          cshplan_due_date_tab_(count_));

            Load_CshPlan_Uninv_Orders___( cash_plan_balance_tab_,
                                          index_,
                                          cash_parameter_rec_,
                                          order_rec_.order_no,
                                          order_rec_.customer_no,
                                          customer_name_,
                                          cshplan_due_date_tab_(count_),
                                          order_rec_.currency_code,
                                          order_rec_.rowstate,
                                          total_gross_amount_, --gross_amout_for_propotion
                                          payment_delay_,
                                          pay_installment_data_tab_);

         END LOOP;
      END IF;
      Clear_Temp_Calc_Info___(order_rec_.order_no, NULL, 'CUSTOMER_ORDER');
    END LOOP;
   
   $IF (Component_Cshpln_SYS.INSTALLED) $THEN
      IF(cash_plan_balance_tab_.COUNT > 0) THEN
         Cash_Plan_Utility_API.Load_Cash_Plan_Balance_Data(cash_plan_balance_tab_, cash_parameter_rec_);
      END IF;
   $END          
END Load_Cshplan_Customer_Order_Data___;
 

-------------------- IMPLEMENTATION METHODS FOR CUSTOMER ORDER INVOICE SUB SOURCE -------------------

-- fetch project id from customer order
-- parameters:
-- source_ref1_ -> order_no
-- source_ref2_ -> line_no,
-- source_ref3_ -> rel_no,
-- source_ref4_ -> line_item_no
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Connected_Project_Id___(
   source_ref1_      IN    VARCHAR2,
   source_ref2_      IN    VARCHAR2,
   source_ref3_      IN    VARCHAR2,
   source_ref4_      IN    VARCHAR2)RETURN VARCHAR2
IS
   project_id_       customer_order_line_tab.project_id%TYPE;
BEGIN
   IF (source_ref1_ IS NULL) THEN
      project_id_ := NULL;
   ELSIF(source_ref2_ IS NULL OR source_ref3_ IS NULL OR source_ref4_ IS NULL) THEN
      --customer order header connected charge
      project_id_ := Customer_Order_API.Get_Project_Id(source_ref1_);
   ELSE
      project_id_ := Customer_Order_Line_API.Get_Project_Id(source_ref1_, source_ref2_, source_ref3_, TO_NUMBER(source_ref4_));
   END IF;
   RETURN project_id_;
END Get_Connected_Project_Id___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Inv_Reference_Text___( 
   company_      IN    VARCHAR2, 
   invoice_id_   IN    NUMBER)RETURN VARCHAR2
IS
   reference_text_   VARCHAR2(300);
   invoice_type_     customer_order_inv_head.invoice_type%TYPE;
BEGIN   
   invoice_type_  := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);

   IF(invoice_type_ = 'CUSTORDDEB') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLDEBINV: Preliminary Customer Debit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);
   ELSIF (invoice_type_ = 'CUSTORDCRE') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLCREINV: Preliminary Customer Credit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSIF (invoice_type_ = 'CUSTORDCOR') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLCORINV: Preliminary Customer Correction Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSIF (invoice_type_ = 'CUSTCOLDEB') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLCOLDEBINV: Preliminary Customer Collective Debit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSIF (invoice_type_ = 'CUSTCOLCRE') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLCOLCREINV: Preliminary Customer Collective Credit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSIF (invoice_type_ = 'CUSTCOLCOR') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLCOLCORINV: Preliminary Customer Collective Correction Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSIF (invoice_type_ = 'COPREPAYDEB') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLPREDEBINV: Preliminary Prepayment Debit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSIF (invoice_type_ = 'COPREPAYCRE') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLPRECREINV: Preliminary Prepayment Credit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSIF (invoice_type_ = 'COADVDEB') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLADVDEBINV: Preliminary Customer Advance Debit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);
   ELSIF (invoice_type_ = 'COADVCRE') THEN
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLADVCREINV: Preliminary Customer Advance Credit Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   ELSE
      reference_text_ := Language_SYS.Translate_Constant(lu_name_, 'CPLPRELINV: Preliminary Customer Invoice No: :P1, Company: :P2', NULL, invoice_id_, company_);   
   END IF;

   RETURN reference_text_; 
END Get_Inv_Reference_Text___;

@IgnoreUnitTest TrivialFunction
FUNCTION Is_Prepayment_Exist___(
   company_          IN VARCHAR2,
   invoice_id_       IN NUMBER)RETURN BOOLEAN 
IS
   dummy_      NUMBER := NULL;
   
   CURSOR prepayment_exist IS 
      SELECT 1 
      FROM   cust_prepaym_consumption_tab
      WHERE  company    = company_
      AND    invoice_id = invoice_id_;
BEGIN
   OPEN prepayment_exist;
   FETCH prepayment_exist INTO dummy_;
   IF (prepayment_exist%FOUND) THEN
      CLOSE prepayment_exist;
      RETURN TRUE;
   ELSE
      CLOSE prepayment_exist;
      RETURN FALSE;
   END IF;
END Is_Prepayment_Exist___;

--fetch invoice amounts
@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Inv_Open_Amounts___(  
   net_sum_    OUT   NUMBER, 
   gross_sum_  OUT   NUMBER,
   company_    IN    VARCHAR2,
   invoice_id_ IN    NUMBER) 
IS   
   CURSOR get_debit_inv_total IS
      SELECT SUM(NVL(net_curr_amount,0)) , SUM(NVL(gross_curr_amount,0))
      FROM   customer_order_inv_item
      WHERE  company    = company_
      AND    invoice_id = invoice_id_;
BEGIN
   OPEN get_debit_inv_total;
   FETCH get_debit_inv_total INTO net_sum_, gross_sum_;
   CLOSE get_debit_inv_total;
END Get_Inv_Open_Amounts___;

--fetch total gross amount from final invoices execuding prepayment lines
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Inv_Gross_Excl_Prepay___ (
   company_    IN    VARCHAR2,
   invoice_id_ IN    NUMBER) RETURN NUMBER 
IS
   prepayment_exist_    BOOLEAN := FALSE;
   gross_sum_           NUMBER;
   
   CURSOR get_debit_inv_total IS
      SELECT SUM(NVL(gross_curr_amount,0))
      FROM   customer_order_inv_item
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    prepay_invoice_no IS NULL;
   
   CURSOR get_invoice_gross IS 
      SELECT gross_amount
      FROM   Customer_Order_Inv_Head
      WHERE  company    = company_
      AND    invoice_id = invoice_id_;
BEGIN
   prepayment_exist_ := Is_Prepayment_Exist___(company_, invoice_id_);
   
   IF(prepayment_exist_) THEN
      OPEN get_debit_inv_total;
      FETCH get_debit_inv_total INTO gross_sum_;
      CLOSE get_debit_inv_total;
   ELSE
      OPEN get_invoice_gross; 
      FETCH get_invoice_gross INTO gross_sum_;
      CLOSE get_invoice_gross;
   END IF; 
   RETURN NVL(gross_sum_, 0);
END Get_Inv_Gross_Excl_Prepay___; 

--Insert customer invoice amounts for project propotion calculation.
@IgnoreUnitTest DMLOperation
PROCEDURE Create_Inv_Temp_Calc_Info___ (
   company_       IN    VARCHAR2,
   invoice_id_    IN    NUMBER)
IS   
   max_rows_                        PLS_INTEGER:= 2000;
   project_id_                      customer_order_line_tab.project_id%TYPE;
   
   CURSOR get_prel_inv_line IS   
      SELECT item_id,
             i.net_curr_amount, 
             i.gross_curr_amount,
             i.order_no, 
             i.line_no, 
             i.release_no, 
             i.line_item_no, 
             i.charge_seq_no
      FROM   customer_order_inv_item i 
      WHERE  i.company     = company_
      AND    i.invoice_id  = invoice_id_
      AND    prepay_invoice_no IS NULL; --use only debit invoice lines for project propotion calculation
   
   TYPE Prel_Inv_Line_Tab IS TABLE OF get_prel_inv_line%ROWTYPE INDEX BY BINARY_INTEGER;
   prel_inv_line_tab_      Prel_Inv_Line_Tab;   
BEGIN  
   OPEN get_prel_inv_line;
   LOOP
      FETCH get_prel_inv_line BULK COLLECT INTO prel_inv_line_tab_ LIMIT max_rows_;
      IF (prel_inv_line_tab_.COUNT > 0) THEN
         FOR i_ IN prel_inv_line_tab_.FIRST..prel_inv_line_tab_.LAST LOOP
            project_id_     := Get_Connected_Project_Id___(prel_inv_line_tab_(i_).order_no,
                                                           prel_inv_line_tab_(i_).line_no,
                                                           prel_inv_line_tab_(i_).release_no,
                                                           prel_inv_line_tab_(i_).line_item_no);
            Create_Sales_Amnt_Calc_Tmp___(company_,
                                          invoice_id_, 
                                          NULL, 
                                          NULL,
                                          'CUSTOMER_ORDER_INVOICE',
                                          NULL,
                                          project_id_,
                                          prel_inv_line_tab_(i_).net_curr_amount,
                                          prel_inv_line_tab_(i_).gross_curr_amount,
                                          prel_inv_line_tab_(i_).net_curr_amount,
                                          prel_inv_line_tab_(i_).gross_curr_amount);   
         END LOOP;
      END IF;
      EXIT WHEN get_prel_inv_line%NOTFOUND;
   END LOOP;
   CLOSE get_prel_inv_line; 
END Create_Inv_Temp_Calc_Info___;

--handle preliminary advance or prepayment invoice. Project propotions are calculated based on customer order information.
PROCEDURE Load_CshPlan_Prepay_Adv_Inv____ (
   cash_plan_balance_tab_      IN OUT   Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab,
   index_                      IN OUT   NUMBER,
   cash_parameter_rec_         IN       Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec,
   invoice_id_                 IN       NUMBER, 
   order_no_                   IN       VARCHAR2,
   customer_no_                IN       VARCHAR2,
   customer_name_              IN       VARCHAR2,    
   party_type_                 IN       VARCHAR2,
   currency_                   IN       VARCHAR2,
   rowstate_                   IN       VARCHAR2,
   gross_amnt_for_prop_        IN       NUMBER,
   payment_delay_              IN       NUMBER,
   pay_installment_data_tab_   IN       Payment_Term_API.Pay_Installment_Data_Tab,
   is_prepayment_invoice_      IN       BOOLEAN  DEFAULT FALSE)
IS  
   max_rows_                        PLS_INTEGER:= 2000;
   cust_ord_with_proportion_tab_    Cshplan_Proj_Amnt_Proportion_Tab; 
   include_charges_                 BOOLEAN := TRUE;
   base_for_adv_inv_                company_order_info_tab.base_for_adv_invoice%TYPE;
   reference_text_                  VARCHAR2(300);
   
   CURSOR get_co_line_amnt IS
      SELECT p.project_id,
             SUM(p.net_amount)     net_curr_amount,
             SUM(p.gross_amount)   gross_curr_amount,
             NULL                  net_propotion,
             NULL                  gross_propotion
      FROM   sales_cash_plan_amnt_calc_tmp p
      WHERE  p.source_ref1     = order_no_
      AND    p.source_ref_type = 'CUSTOMER_ORDER'
      GROUP BY p.project_id;
BEGIN    
   IF(is_prepayment_invoice_) THEN             
      include_charges_    := TRUE;
   ELSE
      base_for_adv_inv_    := Company_Order_Info_API.Get_Base_For_Adv_Invoice_Db(cash_parameter_rec_.company);
      IF (base_for_adv_inv_ = 'NET AMOUNT WITH CHARGES' OR base_for_adv_inv_ = 'GROSS AMOUNT WITH CHARGES') THEN
         include_charges_ := TRUE;
      ELSE
         include_charges_ := FALSE;
      END IF;
   END IF;  
   
   reference_text_   := Get_Inv_Reference_Text___(cash_parameter_rec_.company, invoice_id_);
   --Insert customer order info to temparary table to calculate project propotions 
   Create_Ord_Temp_Calc_Info___(order_no_, include_charges_); 
      
   OPEN get_co_line_amnt;
   LOOP
      FETCH get_co_line_amnt BULK COLLECT INTO cust_ord_with_proportion_tab_ LIMIT max_rows_;
      IF (cust_ord_with_proportion_tab_.COUNT > 0) THEN
         FOR i_ IN cust_ord_with_proportion_tab_.FIRST..cust_ord_with_proportion_tab_.LAST LOOP
            Calc_Net_Gross_Propotion___(cust_ord_with_proportion_tab_(i_).net_propotion, 
                                        cust_ord_with_proportion_tab_(i_).gross_propotion, 
                                        cust_ord_with_proportion_tab_(i_).net_curr_amount, 
                                        cust_ord_with_proportion_tab_(i_).gross_curr_amount, 
                                        gross_amnt_for_prop_ ); 

            Load_All_Cash_Plan_Data___(cash_plan_balance_tab_,
                                       index_,
                                       cust_ord_with_proportion_tab_(i_),                                        
                                       cash_parameter_rec_,
                                       pay_installment_data_tab_,
                                       payment_delay_,
                                       customer_no_,
                                       customer_name_,
                                       party_type_,
                                       currency_,
                                       invoice_id_,
                                       NULL,
                                       NULL,
                                       NULL,
                                       rowstate_,
                                       reference_text_);                            
         END LOOP;
      END IF;
      EXIT WHEN get_co_line_amnt%NOTFOUND;
   END LOOP;
   CLOSE get_co_line_amnt;
   
   Clear_Temp_Calc_Info___(order_no_, NULL, 'CUSTOMER_ORDER');
END Load_CshPlan_Prepay_Adv_Inv____;

--preliminary customer invoices that lines are connected to different projects are handled
PROCEDURE Load_CshPlan_Prel_Invoices____(
   cash_plan_balance_tab_      IN OUT   Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab,
   index_                      IN OUT   NUMBER,
   cash_parameter_rec_         IN       Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec,
   invoice_id_                 IN       NUMBER, 
   customer_no_                IN       VARCHAR2,
   customer_name_              IN       VARCHAR2,    
   party_type_                 IN       VARCHAR2,
   currency_                   IN       VARCHAR2,
   rowstate_                   IN       VARCHAR2,
   gross_amnt_for_prop_        IN       NUMBER,
   payment_delay_              IN       NUMBER,
   pay_installment_data_tab_   IN       Payment_Term_API.Pay_Installment_Data_Tab)
IS
   max_rows_                        PLS_INTEGER:= 2000;
   cshplan_proj_amnt_prop_tab_      Cshplan_Proj_Amnt_Proportion_Tab; 
   reference_text_                  VARCHAR2(300);
   
   CURSOR get_invoice_amnt IS
      SELECT p.project_id,
             SUM(p.net_amount)     net_curr_amount,
             SUM(p.gross_amount)   gross_curr_amount,
             NULL                  net_propotion,
             NULL                  gross_propotion
      FROM   sales_cash_plan_amnt_calc_tmp p
      WHERE  p.source_ref1     = cash_parameter_rec_.company
      AND    p.source_ref2     = invoice_id_
      AND    p.source_ref_type = 'CUSTOMER_ORDER_INVOICE'
      GROUP BY p.project_id;
BEGIN
   Create_Inv_Temp_Calc_Info___(cash_parameter_rec_.company, invoice_id_);
   reference_text_   := Get_Inv_Reference_Text___(cash_parameter_rec_.company, invoice_id_);
   
   OPEN get_invoice_amnt;
   LOOP
      FETCH get_invoice_amnt BULK COLLECT INTO cshplan_proj_amnt_prop_tab_ LIMIT max_rows_;
      IF (cshplan_proj_amnt_prop_tab_.COUNT > 0) THEN
         FOR i_ IN cshplan_proj_amnt_prop_tab_.FIRST..cshplan_proj_amnt_prop_tab_.LAST LOOP
            Calc_Net_Gross_Propotion___(cshplan_proj_amnt_prop_tab_(i_).net_propotion, 
                                        cshplan_proj_amnt_prop_tab_(i_).gross_propotion, 
                                        cshplan_proj_amnt_prop_tab_(i_).net_curr_amount, 
                                        cshplan_proj_amnt_prop_tab_(i_).gross_curr_amount, 
                                        gross_amnt_for_prop_ ); 

            Load_All_Cash_Plan_Data___(cash_plan_balance_tab_,
                                       index_,
                                       cshplan_proj_amnt_prop_tab_(i_),                                        
                                       cash_parameter_rec_,
                                       pay_installment_data_tab_,
                                       payment_delay_,
                                       customer_no_,
                                       customer_name_,
                                       party_type_,
                                       currency_,
                                       invoice_id_,
                                       NULL,
                                       NULL,
                                       NULL,
                                       rowstate_,
                                       reference_text_);                            
         END LOOP;
      END IF;
      EXIT WHEN get_invoice_amnt%NOTFOUND;
   END LOOP;
   CLOSE get_invoice_amnt;           
  
   Clear_Temp_Calc_Info___(cash_parameter_rec_.company, invoice_id_, 'CUSTOMER_ORDER_INVOICE');
END Load_CshPlan_Prel_Invoices____;

-- invoice header is project connected. Therefore project based propotions calculations are not needed.
@IgnoreUnitTest TrivialFunction
PROCEDURE Load_CshPlan_Proj_Conn_Inv___ (
   cash_plan_balance_tab_      IN OUT   Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab,
   index_                      IN OUT   NUMBER,
   cash_parameter_rec_         IN       Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec,
   invoice_id_                 IN       NUMBER, 
   customer_no_                IN       VARCHAR2,
   customer_name_              IN       VARCHAR2,    
   party_type_                 IN       VARCHAR2,
   currency_                   IN       VARCHAR2,
   rowstate_                   IN       VARCHAR2,
   project_id_                 IN       VARCHAR2,
   payment_delay_              IN       NUMBER,
   pay_installment_data_tab_   IN       Payment_Term_API.Pay_Installment_Data_Tab)
IS   
   cshplan_proj_prop_rec_        Cshplan_Proj_Amnt_Proportion_Rec;
   reference_text_               VARCHAR2(300);
BEGIN  
   reference_text_                     := Get_Inv_Reference_Text___(cash_parameter_rec_.company, invoice_id_);
   cshplan_proj_prop_rec_.project_id   := project_id_;
   Get_Inv_Open_Amounts___(cshplan_proj_prop_rec_.net_curr_amount, 
                           cshplan_proj_prop_rec_.gross_curr_amount, 
                           cash_parameter_rec_.company, 
                           invoice_id_);
   
   IF(NVL(cshplan_proj_prop_rec_.gross_curr_amount, 0) != 0) THEN --if gross is 0 no cash plan for preliminary invoices
      -- calculate net propotion based on gross curr amount of customre invoice                        
      Calc_Net_Gross_Propotion___(cshplan_proj_prop_rec_.net_propotion, 
                                  cshplan_proj_prop_rec_.gross_propotion, 
                                  cshplan_proj_prop_rec_.net_curr_amount, 
                                  cshplan_proj_prop_rec_.gross_curr_amount,  
                                  cshplan_proj_prop_rec_.gross_curr_amount);

      Load_All_Cash_Plan_Data___(cash_plan_balance_tab_, 
                                 index_, 
                                 cshplan_proj_prop_rec_, 
                                 cash_parameter_rec_, 
                                 pay_installment_data_tab_, 
                                 payment_delay_, 
                                 customer_no_, 
                                 customer_name_, 
                                 party_type_, 
                                 currency_, 
                                 invoice_id_, 
                                 NULL,
                                 NULL, 
                                 NULL, 
                                 rowstate_,
                                 reference_text_);    
   END IF;   
END Load_CshPlan_Proj_Conn_Inv___;


PROCEDURE Load_Cshplan_Customer_Order_Inv_Data___ (
   cash_parameter_rec_ IN  Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec)
IS    
   gross_amount_for_propotion_      NUMBER;
   payment_delay_                   NUMBER := 0;
   index_                           NUMBER := 1;
   pay_installment_data_tab_        Payment_Term_API.Pay_Installment_Data_Tab;
   prepay_cre_inv_type_             company_def_invoice_type_tab.def_co_prepay_cre_inv_type%TYPE;
   prepay_deb_inv_type_             company_def_invoice_type_tab.def_co_prepay_deb_inv_type%TYPE;  
   cash_plan_balance_tab_           Public_Declarations_API.CSHPLN_Cash_Plan_Balance_Tab;
   base_for_adv_inv_                company_order_info_tab.base_for_adv_invoice%TYPE;
   
   CURSOR get_prel_invoices IS 
      SELECT h.invoice_id,
             h.identity, 
             h.name, 
             h.party_type,
             h.currency,
             h.invoice_type,
             h.creators_reference,
             h.project_id,
             h.objstate,
             h.invoice_date,
             NVL(h.advance_invoice, 'FALSE') advance_invoice
      FROM   customer_order_inv_head h
      WHERE  h.company    = cash_parameter_rec_.company
      AND    h.objstate   = 'Preliminary';
BEGIN 
   prepay_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type (cash_parameter_rec_.company);
   prepay_deb_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(cash_parameter_rec_.company);
   base_for_adv_inv_    := Company_Order_Info_API.Get_Base_For_Adv_Invoice_Db(cash_parameter_rec_.company);
      
   FOR inv_rec_ IN get_prel_invoices LOOP 
      pay_installment_data_tab_.DELETE;
      Payment_Plan_API.Get_Installment_Plan_Data(pay_installment_data_tab_, cash_parameter_rec_.company, inv_rec_.invoice_id, 'FALSE');
      
      $IF (Component_Payled_SYS.INSTALLED) $THEN
         payment_delay_      := NVL(Identity_Pay_Info_API.Get_Payment_Delay_No_Sec(cash_parameter_rec_.company, inv_rec_.identity, inv_rec_.party_type),0);
      $ELSE
         payment_delay_      := 0;
      $END
      
      IF (inv_rec_.project_id IS NOT NULL) THEN
          Load_CshPlan_Proj_Conn_Inv___( cash_plan_balance_tab_,
                                          index_,
                                          cash_parameter_rec_, 
                                          inv_rec_.invoice_id,
                                          inv_rec_.identity,
                                          inv_rec_.name,
                                          inv_rec_.party_type,
                                          inv_rec_.currency,
                                          inv_rec_.objstate,
                                          inv_rec_.project_id,
                                          payment_delay_,
                                          pay_installment_data_tab_);
      ELSIF(inv_rec_.advance_invoice = 'TRUE') THEN
         IF (base_for_adv_inv_ = 'NET AMOUNT WITH CHARGES' OR base_for_adv_inv_ = 'GROSS AMOUNT WITH CHARGES') THEN
            gross_amount_for_propotion_  := Customer_Order_API.Get_Gross_Amt_Incl_Charges(inv_rec_.creators_reference);         
         ELSE
            gross_amount_for_propotion_  := Customer_Order_API.Get_Ord_Gross_Amount(inv_rec_.creators_reference);         
         END IF;
      
         Load_CshPlan_Prepay_Adv_Inv____( cash_plan_balance_tab_,
                                          index_,
                                          cash_parameter_rec_, 
                                          inv_rec_.invoice_id,
                                          inv_rec_.creators_reference,
                                          inv_rec_.identity,
                                          inv_rec_.name,
                                          inv_rec_.party_type,
                                          inv_rec_.currency,
                                          inv_rec_.objstate,
                                          gross_amount_for_propotion_, 
                                          payment_delay_,
                                          pay_installment_data_tab_);
      ELSIF (inv_rec_.invoice_type = prepay_cre_inv_type_ OR inv_rec_.invoice_type = prepay_deb_inv_type_) THEN
         gross_amount_for_propotion_  := Customer_Order_API.Get_Gross_Amt_Incl_Charges(inv_rec_.creators_reference);
         Load_CshPlan_Prepay_Adv_Inv____( cash_plan_balance_tab_,
                                          index_,
                                          cash_parameter_rec_, 
                                          inv_rec_.invoice_id,
                                          inv_rec_.creators_reference,
                                          inv_rec_.identity,
                                          inv_rec_.name,
                                          inv_rec_.party_type,
                                          inv_rec_.currency,
                                          inv_rec_.objstate,
                                          gross_amount_for_propotion_, 
                                          payment_delay_,
                                          pay_installment_data_tab_,
                                          TRUE); -- prepayment invoice
      ELSE
         gross_amount_for_propotion_  := Get_Inv_Gross_Excl_Prepay___(cash_parameter_rec_.company, inv_rec_.invoice_id); 
         IF (gross_amount_for_propotion_ != 0) THEN --exclude cash plans for correction invoice with 0 gross amount
            Load_CshPlan_Prel_Invoices____( cash_plan_balance_tab_,
                                             index_,
                                             cash_parameter_rec_, 
                                             inv_rec_.invoice_id,
                                             inv_rec_.identity,
                                             inv_rec_.name,
                                             inv_rec_.party_type,
                                             inv_rec_.currency,
                                             inv_rec_.objstate,
                                             gross_amount_for_propotion_, 
                                             payment_delay_,
                                             pay_installment_data_tab_);
         END IF;                                    
      END IF;
   END LOOP;
   
   $IF (Component_Cshpln_SYS.INSTALLED) $THEN   
      IF(cash_plan_balance_tab_.COUNT > 0) THEN
         Cash_Plan_Utility_API.Load_Cash_Plan_Balance_Data(cash_plan_balance_tab_, cash_parameter_rec_); 
      END IF;   
   $END
END Load_Cshplan_Customer_Order_Inv_Data___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Cshpln_Cash_Flow_Data (
   cash_parameter_rec_   IN Public_Declarations_API.CSHPLN_Cash_Plan_Parameter_Rec)
IS
BEGIN
   IF (cash_parameter_rec_.sub_source_id = 'CUSTOMER_ORDER') THEN   
      Load_Cshplan_Customer_Order_Data___(cash_parameter_rec_);
   END IF;
   IF (cash_parameter_rec_.sub_source_id = 'CUSTOMER_ORDER_INVOICE') THEN   
      Load_Cshplan_Customer_Order_Inv_Data___(cash_parameter_rec_);
   END IF;
END Create_Cshpln_Cash_Flow_Data;

-------------------- LU  NEW METHODS -------------------------------------
