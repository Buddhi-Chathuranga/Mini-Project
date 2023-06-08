-----------------------------------------------------------------------------
--
--  Logical unit: Customer360
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210708  NiDalk  Bug 159894(SCZ-15211), Modified Get_Outstanding_Ord_Net_Amt, Modified Get_Backorder_Data___ and Get_Outstanding_Order_Data___ to improve performance. Modified cusrsors get_line_data,
--  210708          last_backorder, open_backorder_lines, last_outstanding_order and open_outstanding_order_lines to join with customer_order_tab for better performance
--  200908  MaRalk  SC2020R1-9547, Removed method Get_Support_Issue_Data___ which is in connection with obsolete Scentr functionality and removed usage inside Get_Transaction_Data__.
--  190524  NiDalk  Bug 148377, Modified Get_Order_Quotation_Data___ to improve performace. Removed method calls from cusrsor last_quotation. Also changed sales values to be  
--  190524          fetched from Order_Quotation_Line_API.Get_Sales_Price_Totals.
--  190513  KiSalk  Bug 148058(SCZ-4381), In Get_Return_Material_Data___, excluded objstate Cancelled from cursor open_returns.
--  190311  niedlk  SCUXXW4-9047, Added Get_Outstanding_Ord_Gross_Amt, Get_Open_Quotation_Gross_Amt and Get_Open_Invoice_Gross_Amt to get the details needed for Customer 360 in Aurena.
--  180425  KiSalk  Bug 141542, Modified Get_Order_Quotation_Data___ to fetch data bypassing company check for prospect customers as they do not have identity_invoice_info_tab records.
--  180108  SBalLK  Bug 139510, Modified Get_User_Companies__() method by increase the variable length to accommodate 32000 characters for avoid character buffer too small.
--  170724  ApWilk  Bug 136691, Modified Get_Financial_Data__ to fetch the correct customer credit limit.
--  170711  MaEelk  STRSC-10774, Modified cursors in Get_Backorder_Data___, Get_Order_Invoice_Data___, Get_Order_Quotation_Data___, Get_Outstanding_Order_Data___, 
--  170711          Get_Return_Material_Data___, Get_Support_Issue_Data___, Get_Work_Order_Data___ and Get_Financial_Data__ to avoid compilation errors with ambiguous columns 
--``170315  MeAblk  Bug 134787, Modified Get_Order_Quotation_Data___() to exclude the lines of closed quotattion headers.
--  161108  AyAmlk  APPUXX-5319, Modified Get_Order_Quotation_Data___() to prevent considering OQ created for SC when fetching data for Customer 360 summary.
--  160629  TiRalk  STRSC-2702, Modified Get_Backorder_Data___ by removing CreditBlocked state from some cursors the places where it has been checked the rowstate 
--  160629          from Customer_Order_Line_Tab and it hasn't a stae like that in Customer_Order_Line_Tab.
--  150721  SudJlk  ORA-1020, Modified Get_Transaction_Data__ to pass connection_type as Customer when calling Get_Business_Activity_Data. 
--  141214  SBalLK  Bug 118543, Modified Get_Backorder_Data___(), Get_Order_Invoice_Data___(), Get_Order_Quotation_Data___(), Get_Outstanding_Order_Data___(), Get_Return_Material_Data___() and
--  141214          Get_Transaction_Data__() methods to get last order gross amounts and the all total gross amounts in base currency to display in Customer 360 window.
--  141118  JeLise  PRSC-2547, Replaced customer_order_join with customer_order_line_tab.
--  141028  MaIklk  PRSC-3965, Added Marketing campaign to fetch data.
--  140808  PraWlk  PRSC-2145, Modified Get_Order_Quotation_Data___() by using state 'CO Created' insted of 'Won' in the condition.
--  140509  MaEdlk  Bug 115505, Added read only acess to Get_Transaction_Data__ and Get_Financial_Data__.
--  140324          Removed dynamic calls and added conditional compilation directives in Get_Financial_Data__. 
--  140421  SBalLK  Bug 116331, Modified cursors in Get_Backorder_Data___(), Get_Outstanding_Order_Data___() method to reflect the column name changes in CUSTOMER_ORDER_JOIN view.
--  140314  AwWelk  PBSC-6725, Modified Get_Transaction_Data__() by passing company parameter to Business_Activity_API.Get_Business_Activity_Data().
--  140225  AwWelk  PBSC-6725, Modified Get_Transaction_Data__() to get business opportunity and business activity data.
--  131001  KiSalk  Bug 112756, In Get_Financial_Data__, checked attribute advance_invoice instead of hardcoded invoice_type values to filter out advance invoice.
--  130916  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
--  130719  TiRalk  Bug 109853, Modified views CUSTOMER360_SUMMARY by removing cust_ord_customer to fetch data in  
--  130719          Customer 360 window when Order tab of Customer window has no data.
--  130705  AwWelk  TIBE-989, Removed global variables inst_ActiveWorkOrder_, inst_SupportIssue_, inst_CcCase_ and introduced conditional
--  130705          compilation.
--  130506  SALIDE  EDEL-2162, Added one-time CUSTOMER360
--  130319  SALIDE  EDEL-2020, Added name to CUSTOMER360_SUMMARY
--  130128  SeJalk  Bug 107873, Use Accounting year instead of calender year when calculating value for SALES_1 in Get_Financial_Data__.
--  121119  SBalLK  Bug 106007, Modified not to fetch invoice amount where invoice type is COADVDEB and COADVCRE invoice.
--  120920  GiSalk  Bug 104648, Added dso_customer to out attribute of Get_Financial_Data__.
--  120312  MaMalk  Bug 99430, Modified several places to consider inverted_conv_factor where conv_factor has been considered.
--  110707  SudJlk  Bug 97675, Modified column comments in views CUSTOMER360 and CUSTOMER360_SUMMARY to indicate the key attributes.
--  110707  ChJalk  Used order_quotation_tab and order_quotation_line_tab instead of the respective base view in cursor last_quotation. 
--  110317  AndDse  BP-4453, In Get_Backorder_Data___, considered external transport calendar when adjusting for delivery leadtime.
--  110304  Mushlk  BP-4153, Added method Get_Contact_Address().
--  090930  MaMalk  Modified Get_Case_Data___ to remove unused code.
--  -------------------------------------14.0.0------------------------------
--  091120  ChJalk  Bug 86871, Removed General_SYS.Init_Method from the function Get_User_Companies__.
--  070926  ToBeSe  Code cleanup.
--  070921  MaHplk  Added General_SYS.Init_Method to Get_User_Companies__.
--  070921  AmPalk  In Get_Transaction_Data__, modified Get_Order_Quotation_Data___ to not to consider 'Cancelled' when fetching the latest. Cursor open_quotations changed to fetch sum of quotation_no.
--  070921          Modified Get_Return_Material_Data___ to not to consider 'Denied' when fetching the latest.
--  070905  ToBeSe  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Backorder_Data___ (
   last_id_             OUT VARCHAR2,
   last_date_           OUT VARCHAR2,
   last_amount_         OUT NUMBER,
   last_gross_amount_   OUT NUMBER,
   open_count_          OUT NUMBER,
   open_sum_            OUT NUMBER,
   open_gross_sum_      OUT NUMBER,
   company_             IN  VARCHAR2,
   customer_no_         IN  VARCHAR2 )
IS
   CURSOR last_backorder(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT col.order_no, col.date_entered
      FROM customer_order_line_tab col, customer_order_tab co
      WHERE co.customer_no = customer_no_
      AND   co.rowstate IN ('Planned', 'Released', 'Reserved', 'Picked','PartiallyDelivered','Delivered')
      AND   co.order_no = col.order_no
      AND   col.promised_delivery_date <= 
            (Cust_Ord_Date_Calculation_API.Get_Calendar_Start_Date(col.ext_transport_calendar_id,
             Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(col.ext_transport_calendar_id, SYSDATE, col.delivery_leadtime), 1)) --(SYSDATE + delivery_leadtime - 1)
      AND   col.rowstate IN ('PartiallyDelivered', 'Picked', 'Planned', 'Released', 'Reserved')
      AND   col.line_item_no >= 0
      AND   EXISTS (SELECT 1
                    FROM user_allowed_site_pub uas, company_site
                    WHERE contract = co.contract
                    AND   contract = uas.site
                    AND   company  = company_)
      ORDER BY date_entered DESC;

   -- Company and site conditions already used to find the order.
   CURSOR last_backorder_sum(order_no_ VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM customer_order_line_tab
      WHERE order_no = order_no_
      AND   promised_delivery_date <= 
            (Cust_Ord_Date_Calculation_API.Get_Calendar_Start_Date(ext_transport_calendar_id,
             Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(ext_transport_calendar_id, SYSDATE, delivery_leadtime), 1)) --(SYSDATE + delivery_leadtime - 1)
      AND   rowstate IN ('PartiallyDelivered', 'Picked', 'Planned', 'Released', 'Reserved')
      AND   line_item_no >= 0;

   CURSOR open_backorder_lines(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no
      FROM customer_order_line_tab col, customer_order_tab co
      WHERE co.customer_no = customer_no_
      AND   co.rowstate IN ('Planned', 'Released', 'Reserved', 'Picked','PartiallyDelivered','Delivered')
      AND   co.order_no = col.order_no
      AND   col.promised_delivery_date <= 
            (Cust_Ord_Date_Calculation_API.Get_Calendar_Start_Date(col.ext_transport_calendar_id,
             Cust_Ord_Date_Calculation_API.Get_Calendar_End_Date(col.ext_transport_calendar_id, SYSDATE, col.delivery_leadtime), 1)) --(SYSDATE + delivery_leadtime - 1)
      AND   col.rowstate IN ('PartiallyDelivered', 'Picked', 'Planned', 'Released', 'Reserved')
      AND   col.line_item_no >= 0
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = co.contract
                    AND   contract = uas.site
                    AND   company  = company_);
   net_amount_    NUMBER;
   gross_amount_  NUMBER;
BEGIN
   OPEN last_backorder(company_, customer_no_);
   FETCH last_backorder INTO last_id_, last_date_;
   CLOSE last_backorder;

   FOR rec_ IN last_backorder_sum(last_id_) LOOP
      Customer_order_Line_API.Get_Backord_Value_Base_Curr(net_amount_, gross_amount_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      last_amount_ := NVL(last_amount_, 0) + net_amount_;
      last_gross_amount_ := NVL(last_gross_amount_, 0) + gross_amount_;
   END LOOP;
   
   open_count_ := 0;
   FOR rec_ IN open_backorder_lines(company_, customer_no_) LOOP
      Customer_order_Line_API.Get_Backord_Value_Base_Curr(net_amount_, gross_amount_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      open_sum_ := NVL(open_sum_, 0) + net_amount_;
      open_gross_sum_ := NVL(open_gross_sum_, 0) + gross_amount_;
      open_count_ := open_count_ + 1;
   END LOOP;
END Get_Backorder_Data___;


PROCEDURE Get_Case_Data___ (
   last_id_     OUT VARCHAR2,
   last_date_   OUT VARCHAR2,
   last_amount_ OUT NUMBER,
   open_count_  OUT NUMBER,
   open_sum_    OUT NUMBER,   
   customer_no_ IN  VARCHAR2 )
IS
BEGIN
   $IF (Component_Callc_SYS.INSTALLED) $THEN
      DECLARE 
         CURSOR last_case(customer_no_ VARCHAR2) IS
            SELECT case_local_id, created, 0
            FROM cc_case
            WHERE customer_id = customer_no_
            AND   objstate   != 'Cancelled'
            ORDER BY created DESC; 

         CURSOR open_cases(customer_no_ VARCHAR2) IS
            SELECT count(case_local_id), 0
            FROM cc_case
            WHERE customer_id = customer_no_
            AND   objstate NOT IN ('Cancelled', 'Closed')
            ORDER BY created DESC;
      BEGIN 
         OPEN last_case(customer_no_);
         FETCH last_case INTO last_id_, last_date_, last_amount_;
         CLOSE last_case;

         OPEN open_cases(customer_no_);
         FETCH open_cases INTO open_count_, open_sum_;
         CLOSE open_cases;
      END;
   $ELSE 
      RETURN;
   $END
END Get_Case_Data___;


PROCEDURE Get_Order_Invoice_Data___ (
   last_id_             OUT VARCHAR2,
   last_date_           OUT VARCHAR2,
   last_amount_         OUT NUMBER,
   last_gross_amount_   OUT NUMBER,
   open_count_          OUT NUMBER,
   open_sum_            OUT NUMBER,
   open_gross_sum_   OUT NUMBER,
   company_             IN  VARCHAR2,
   customer_no_         IN  VARCHAR2 )
IS
   CURSOR last_invoice(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT invoice_no, invoice_date, net_dom_amount, (net_dom_amount + vat_dom_amount)
      FROM customer_order_inv_head coi
      WHERE identity = customer_no_
      AND   company = company_
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = coi.contract
                    AND   contract = uas.site
                    AND   company  = company_)
      ORDER BY invoice_date DESC;

   CURSOR open_invoices(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT count(*), SUM(net_dom_amount), SUM (net_dom_amount + vat_dom_amount)
      FROM customer_order_inv_head coi
      WHERE identity = customer_no_
      AND   company = company_
      AND   objstate NOT IN ('PaidPosted')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = coi.contract
                    AND   contract = uas.site
                    AND   company  = company_);
BEGIN
   OPEN last_invoice(company_, customer_no_);
   FETCH last_invoice INTO last_id_, last_date_, last_amount_, last_gross_amount_;
   CLOSE last_invoice;

   OPEN open_invoices(company_, customer_no_);
   FETCH open_invoices INTO open_count_, open_sum_, open_gross_sum_;
   CLOSE open_invoices;
END Get_Order_Invoice_Data___;


PROCEDURE Get_Order_Quotation_Data___ (
   last_id_             OUT VARCHAR2,
   last_date_           OUT VARCHAR2,
   last_amount_         OUT NUMBER,
   last_gross_amount_   OUT NUMBER,
   open_count_          OUT NUMBER,
   open_sum_            OUT NUMBER,
   open_gross_sum_      OUT NUMBER,
   company_             IN  VARCHAR2,
   customer_no_         IN  VARCHAR2 )
IS
   is_prospect_category_   VARCHAR2(5) := 'FALSE';

   currency_code_          VARCHAR2(3);
   rounding_               NUMBER;
   currency_rate_          NUMBER;
   sales_total_            NUMBER := 0;
   sales_incl_tax_total_   NUMBER := 0;

   CURSOR last_quotation(customer_no_ VARCHAR2) IS
      SELECT quotation_no, date_entered
      FROM order_quotation_tab oq
      WHERE customer_no = customer_no_
      AND   rowstate NOT IN ('Cancelled')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = oq.contract
                    AND   contract = uas.site
                    AND   (company  = company_ OR is_prospect_category_ = 'TRUE'))
      AND   b2b_order = 'FALSE'
      ORDER BY date_entered DESC;

   CURSOR open_quotations(customer_no_ VARCHAR2) IS
      SELECT quotation_no, line_no, rel_no, line_item_no, currency_rate, company
      FROM order_quotation_line_tab oql
      WHERE customer_no = customer_no_
      AND   rowstate NOT IN ('Cancelled', 'CO Created', 'Lost')
      AND   quotation_no IN (SELECT quotation_no
                              FROM   order_quotation_tab
                              WHERE  rowstate <> 'Closed'
                              and   b2b_order = 'FALSE')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = oql.contract
                    AND   contract = uas.site
                    AND   (company  = company_ OR is_prospect_category_ = 'TRUE'));
BEGIN
   IF company_ IS NULL THEN
      IF (Customer_Info_API.Get_Customer_Category_Db(customer_no_) = Customer_Category_API.DB_PROSPECT) THEN
         is_prospect_category_ := 'TRUE';
      END IF;
   END IF;

   OPEN last_quotation(customer_no_);
   FETCH last_quotation INTO last_id_, last_date_;
   CLOSE last_quotation;

   last_amount_ := Order_Quotation_API.Get_Total_Base_Price(last_id_);
   last_gross_amount_ := Order_Quotation_API.Get_Total_Base_Price_Incl_Tax(last_id_);
   
   open_count_ := 0;
   open_sum_ := 0;
   open_gross_sum_ := 0;

   FOR rec_ IN open_quotations(customer_no_) LOOP
      currency_code_ := Company_Finance_API.Get_Currency_Code(rec_.company);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_);
      open_count_ := open_count_ + 1;
      Order_Quotation_Line_API.Get_Sales_Price_Totals(sales_total_,  sales_incl_tax_total_, rec_.quotation_no, rec_.line_no, rec_.rel_no, rec_.line_item_no); 
      open_sum_ := open_sum_ + NVL(ROUND(sales_total_ * rec_.currency_rate, rounding_), 0);
      open_gross_sum_ := open_gross_sum_ + NVL(ROUND(sales_incl_tax_total_ * rec_.currency_rate, rounding_), 0);
   END LOOP;
END Get_Order_Quotation_Data___;


PROCEDURE Get_Outstanding_Order_Data___ (
   last_id_             OUT VARCHAR2,
   last_date_           OUT VARCHAR2,
   last_amount_         OUT NUMBER,
   last_gross_amount_   OUT NUMBER,
   open_count_          OUT NUMBER,
   open_sum_            OUT NUMBER,
   open_gross_sum_      OUT NUMBER,
   company_             IN  VARCHAR2,
   customer_no_         IN  VARCHAR2 )
IS
   CURSOR last_outstanding_order(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT l.order_no, l.date_entered
      FROM customer_order_line_tab l, customer_order_tab co
      WHERE co.customer_no = customer_no_
      AND   co.rowstate IN ('Planned', 'Released', 'Reserved', 'Picked','PartiallyDelivered','Delivered')
      AND   co.order_no = l.order_no
      AND   (l.buy_qty_due + (l.qty_shipdiff / l.conv_factor * l.inverted_conv_factor) - l.qty_invoiced) > 0
      AND   l.line_item_no <= 0
      AND   l.rowstate in ('Delivered', 'PartiallyDelivered', 'Picked', 'Released', 'Reserved')
      AND   EXISTS (SELECT 1
                    FROM user_allowed_site_pub uas, company_site
                    WHERE contract = co.contract
                    AND   contract = uas.site
                    AND   company  = company_)
      ORDER BY date_entered DESC;

   -- Company and site conditions already used to find the order.
   CURSOR last_outstanding_order_sum(order_no_ VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no
      FROM customer_order_line_tab l
      WHERE order_no = order_no_
      AND   (l.buy_qty_due + (l.qty_shipdiff / l.conv_factor * l.inverted_conv_factor) - l.qty_invoiced) > 0
      AND   l.line_item_no <= 0
      AND   l.rowstate in ('Delivered', 'PartiallyDelivered', 'Picked', 'Released', 'Reserved');

   CURSOR open_outstanding_order_lines(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT l.order_no, l.line_no, l.rel_no, l.line_item_no
      FROM  customer_order_line_tab l, customer_order_tab co
      WHERE co.customer_no = customer_no_
      AND   co.rowstate IN ('Planned', 'Released', 'Reserved', 'Picked','PartiallyDelivered','Delivered')
      AND   co.order_no = l.order_no
      AND   (l.buy_qty_due + (l.qty_shipdiff / l.conv_factor * l.inverted_conv_factor) - l.qty_invoiced) > 0
      AND   l.line_item_no <= 0
      AND   l.rowstate in ('Delivered', 'PartiallyDelivered', 'Picked', 'Released', 'Reserved')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = co.contract
                    AND   contract = uas.site
                    AND   company  = company_);
   net_amount_    NUMBER;
   gross_amount_  NUMBER;
BEGIN
   OPEN last_outstanding_order(company_, customer_no_);
   FETCH last_outstanding_order INTO last_id_, last_date_;
   CLOSE last_outstanding_order;
   
   FOR rec_ IN last_outstanding_order_sum(last_id_) LOOP
      Customer_Order_Line_API.Get_Backlog_Value_Base_Curr( net_amount_, gross_amount_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      last_amount_ := NVL(last_amount_, 0) + net_amount_;
      last_gross_amount_ := NVL(last_gross_amount_, 0) + gross_amount_;
   END LOOP;

   open_count_ := 0;
   FOR rec_ IN open_outstanding_order_lines(company_, customer_no_) LOOP
      Customer_Order_Line_API.Get_Backlog_Value_Base_Curr( net_amount_, gross_amount_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      open_sum_ := NVL(open_sum_, 0) + net_amount_;
      open_gross_sum_ := NVL(open_gross_sum_, 0) + gross_amount_;
      open_count_ := open_count_ + 1;
   END LOOP;
END Get_Outstanding_Order_Data___;


PROCEDURE Get_Return_Material_Data___ (
   last_id_             OUT VARCHAR2,
   last_date_           OUT VARCHAR2,
   last_amount_         OUT NUMBER,
   last_gross_amount_   OUT NUMBER,
   open_count_          OUT NUMBER,
   open_sum_            OUT NUMBER,
   open_gross_sum_      OUT NUMBER,
   company_             IN  VARCHAR2,
   customer_no_         IN  VARCHAR2 )
IS
   CURSOR last_return(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT rma_no, date_requested
      FROM return_material_join rm
      WHERE customer_no = customer_no_
      AND   objstate NOT IN ('Denied')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = rm.contract
                    AND   contract = uas.site
                    AND   company  = company_)
      ORDER BY date_requested DESC;

   -- Company and site conditions already used to find the rma_no.
   CURSOR last_return_sum(rma_no_ VARCHAR2) IS
      SELECT SUM(Return_Material_Line_API.Get_Line_Total_Base_Price(rma_no, rma_line_no)), SUM(Return_Material_Line_API.Get_Total_Base_Price_Incl_Tax(rma_no, rma_line_no))
      FROM return_material_join rm
      WHERE rma_no = rma_no_
      AND   objstate NOT IN ('Denied');

   CURSOR open_returns(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT count(*), SUM(RETURN_MATERIAL_LINE_API.Get_Line_Total_Base_Price(RMA_NO, RMA_LINE_NO)), SUM(Return_Material_Line_API.Get_Total_Base_Price_Incl_Tax(rma_no, rma_line_no))
      FROM return_material_join rm
      WHERE customer_no = customer_no_
      AND   objstate NOT IN ('Denied', 'ReturnCompleted', 'Cancelled')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = rm.contract
                    AND   contract = uas.site
                    AND   company  = company_);
BEGIN
   OPEN last_return(company_, customer_no_);
   FETCH last_return INTO last_id_, last_date_;
   CLOSE last_return;

   OPEN last_return_sum(last_id_);
   FETCH last_return_sum INTO last_amount_, last_gross_amount_;
   CLOSE last_return_sum;

   OPEN open_returns(company_, customer_no_);
   FETCH open_returns INTO open_count_, open_sum_, open_gross_sum_;
   CLOSE open_returns;
END Get_Return_Material_Data___;


PROCEDURE Get_Work_Order_Data___ (
   last_id_     OUT VARCHAR2,
   last_date_   OUT VARCHAR2,
   last_amount_ OUT NUMBER,
   open_count_  OUT NUMBER,
   open_sum_    OUT NUMBER,
   company_     IN  VARCHAR2,
   customer_no_ IN  VARCHAR2 )
IS
BEGIN
   $IF (Component_Wo_SYS.INSTALLED) $THEN 
      DECLARE 
         CURSOR last_work_order(company_ VARCHAR2, customer_no_ VARCHAR2) IS
            SELECT wo_no, reg_date, 0
            FROM active_separate wo
            WHERE customer_no = customer_no_
            AND   EXISTS (SELECT 1
                          FROM user_allowed_site_pub uas, company_site
                          WHERE contract = wo.contract
                          AND   contract = uas.site
                          AND   company  = company_)
            ORDER BY reg_date DESC; 

         CURSOR open_work_orders(company_ VARCHAR2, customer_no_ VARCHAR2) IS
            SELECT count(wo_no), 0
            FROM active_separate wo
            WHERE customer_no = customer_no_
            AND   EXISTS (SELECT 1
                          FROM  user_allowed_site_pub uas, company_site
                          WHERE contract = wo.contract
                          AND   contract = uas.site
                          AND   company  = company_);
      BEGIN
         OPEN last_work_order(company_, customer_no_);
         FETCH last_work_order INTO last_id_, last_date_, last_amount_;
         CLOSE last_work_order;

         OPEN open_work_orders(company_, customer_no_);
         FETCH open_work_orders INTO open_count_, open_sum_;
         CLOSE open_work_orders;
      END;
   $ELSE 
      RETURN;
   $END 
END Get_Work_Order_Data___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
@UncheckedAccess
PROCEDURE Get_Transaction_Data__ (
   last_id_             OUT VARCHAR2,
   last_date_           OUT VARCHAR2,
   last_amount_         OUT NUMBER,
   last_gross_amount_   OUT NUMBER,
   open_count_          OUT NUMBER,
   open_sum_            OUT NUMBER,
   open_gross_sum_      OUT NUMBER,
   company_             IN  VARCHAR2,
   customer_no_         IN  VARCHAR2,
   transaction_type_    IN  VARCHAR2 )
IS
BEGIN
   CASE transaction_type_
      WHEN 'OQ' THEN
         Get_Order_Quotation_Data___(last_id_, last_date_, last_amount_, last_gross_amount_, open_count_, open_sum_, open_gross_sum_, company_, customer_no_);
      WHEN 'OO' THEN
         Get_Outstanding_Order_Data___(last_id_, last_date_, last_amount_, last_gross_amount_, open_count_, open_sum_, open_gross_sum_, company_, customer_no_);
      WHEN 'RMA' THEN
         Get_Return_Material_Data___(last_id_, last_date_, last_amount_, last_gross_amount_, open_count_, open_sum_, open_gross_sum_, company_, customer_no_);
      WHEN 'BO' THEN
         Get_Backorder_Data___(last_id_, last_date_, last_amount_, last_gross_amount_, open_count_, open_sum_, open_gross_sum_, company_, customer_no_);
      WHEN 'INV' THEN
         Get_Order_Invoice_Data___(last_id_, last_date_, last_amount_, last_gross_amount_, open_count_, open_sum_, open_gross_sum_, company_, customer_no_);
      WHEN 'WO' THEN
         $IF (Component_Wo_SYS.INSTALLED) $THEN 
            Get_Work_Order_Data___(last_id_, last_date_, last_amount_, open_count_, open_sum_, company_, customer_no_);
         $ELSE 
            NULL;
         $END 
      WHEN 'CCC' THEN
         $IF (Component_Callc_SYS.INSTALLED) $THEN 
            Get_Case_Data___(last_id_, last_date_, last_amount_, open_count_, open_sum_, customer_no_);
         $ELSE
            NULL;
         $END 
      WHEN 'BUSINESS_OPPORTUNITY' THEN
         $IF (Component_Crm_SYS.INSTALLED) $THEN
            Business_Opportunity_API.Get_Business_Opportunity_Data(last_id_, last_date_, last_amount_, open_count_, open_sum_, company_, customer_no_);
         $ELSE
            NULL;
         $END 
      WHEN 'MARKETING_CAMPAIGN' THEN
         $IF (Component_Crm_SYS.INSTALLED) $THEN
            Marketing_Campaign_API.Get_Marketing_Campaign_Data(last_id_, last_date_, last_amount_, open_count_, open_sum_, company_, customer_no_);
         $ELSE
            NULL;
         $END 
      WHEN 'BUSINESS_ACTIVITY' THEN
         $IF (Component_Crm_SYS.INSTALLED) $THEN
            Business_Activity_API.Get_Business_Activity_Data(last_id_, last_date_, last_amount_, open_count_, open_sum_, company_ , customer_no_, Business_Object_Type_API.DB_CUSTOMER);
         $ELSE
            NULL;
         $END
   END CASE;

   -- Set zero count to null
   IF open_count_ = 0 THEN
      open_count_ := NULL;
   END IF;
END Get_Transaction_Data__;

@UncheckedAccess
PROCEDURE Get_Financial_Data__ (
   attr_        OUT VARCHAR2,
   company_     IN  VARCHAR2,
   customer_no_ IN  VARCHAR2 )
IS
   year_start_date_ DATE;
   year_end_date_   DATE;
   accounting_year_ NUMBER;

   CURSOR ord_invo_sum1(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT SUM(net_dom_amount)
      FROM customer_order_inv_head coi
      WHERE identity        = customer_no_
      AND   company         = company_
      AND   advance_invoice = 'FALSE'
      AND   (invoice_date BETWEEN year_start_date_ AND  year_end_date_)
      AND   EXISTS (SELECT 1
                    FROM user_allowed_site_pub uas, company_site
                    WHERE contract = coi.contract
                    AND   contract = uas.site
                    AND   company  = company_);

   CURSOR ord_invo_sum2(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT SUM(net_dom_amount)
      FROM customer_order_inv_head coi
      WHERE identity        = customer_no_
      AND   company         = company_
      AND   advance_invoice = 'FALSE'
      AND   to_char(invoice_date, 'YYYY-MM') = to_char(add_months(SYSDATE, -1), 'YYYY-MM')
      AND   EXISTS (SELECT 1
                    FROM user_allowed_site_pub uas, company_site
                    WHERE contract = coi.contract
                    AND   contract = uas.site
                    AND   company  = company_);

   CURSOR ord_invo_sum3(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT SUM(net_dom_amount)
      FROM customer_order_inv_head coi
      WHERE identity = customer_no_
      AND   company = company_
      AND   advance_invoice = 'FALSE'
      AND   to_char(invoice_date, 'YYYY-MM') = to_char(SYSDATE, 'YYYY-MM')
      AND   EXISTS (SELECT 1
                    FROM user_allowed_site_pub uas, company_site
                    WHERE contract = coi.contract
                    AND   contract = uas.site
                    AND   company  = company_);

   credit_limit_     NUMBER;
   credit_block_     VARCHAR2(5);
   next_review_date_ DATE;
   remain_credit1_   NUMBER;
   analysis_date_    DATE;
   dso_company_      NUMBER;
	ar_balance_			NUMBER;
   tmp_sum_          NUMBER;
   pay_term_id_      payment_term.pay_term_id%TYPE;
   dso_customer_     NUMBER;
BEGIN
   $IF Component_Payled_SYS.INSTALLED $THEN
      DECLARE 
         
         CURSOR financial_data(company_ VARCHAR2, customer_no_ VARCHAR2) IS
            SELECT credit_block, next_review_date, remain_credit1, analysis_date, dso_company, dso_customer, ar_balance 
            FROM customer_credit_info cic1 JOIN credit_collection_info USING(company, identity) 
            WHERE company  = company_ 
            AND	identity = customer_no_; 
      BEGIN 
         OPEN  financial_data(company_, customer_no_);
         FETCH financial_data INTO credit_block_, next_review_date_, remain_credit1_, analysis_date_, dso_company_, dso_customer_, ar_balance_;
         IF financial_data %FOUND THEN
            credit_limit_ := Cust_Credit_Info_Util_API.Fetch_Credit_Limit(company_, customer_no_);
         END IF;
         CLOSE financial_data; 
      END;
   $END

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CREDIT_LIMIT', credit_limit_, attr_);
   Client_SYS.Add_To_Attr('CREDIT_BLOCK', credit_block_, attr_);
   Client_SYS.Add_To_Attr('NEXT_REVIEW_DATE', next_review_date_, attr_);
   Client_SYS.Add_To_Attr('REMAIN_CREDIT', remain_credit1_, attr_);
   Client_SYS.Add_To_Attr('ANALYSIS_DATE', analysis_date_, attr_);
   Client_SYS.Add_To_Attr('DSO_COMPANY', dso_company_, attr_);
   Client_SYS.Add_To_Attr('DSO_CUSTOMER', dso_customer_, attr_);
   Client_SYS.Add_To_Attr('AR_BALANCE', ar_balance_, attr_);

   -- Pyment term
   pay_term_id_ := Identity_Invoice_Info_API.Get_Pay_Term_Id(company_,
                                                             customer_no_,
                                                             Party_Type_API.Decode('CUSTOMER'));

   Client_SYS.Add_To_Attr('PAY_TERM_ID', pay_term_id_, attr_);
   Client_SYS.Add_To_Attr('PAY_TERM_DESCRIPTION',
                          Payment_Term_API.Get_Description(company_, pay_term_id_), attr_);

   -- Order invoice sums 
   accounting_year_ := Accounting_Period_API.Get_Accounting_Year (company_, SYSDATE);
   year_start_date_ := Accounting_Period_API.Get_Date_From(company_, accounting_year_, Accounting_Period_API.Get_Min_Period(company_, accounting_year_));
   year_end_date_   := Accounting_Period_API.Get_Date_Until(company_, accounting_year_,  Accounting_Period_API.Get_Max_Period(company_,accounting_year_));

   OPEN ord_invo_sum1(company_, customer_no_);
   FETCH ord_invo_sum1 INTO tmp_sum_;
   CLOSE ord_invo_sum1;
   Client_SYS.Add_To_Attr('SALES_1', tmp_sum_, attr_);

   OPEN ord_invo_sum2(company_, customer_no_);
   FETCH ord_invo_sum2 INTO tmp_sum_;
   CLOSE ord_invo_sum2;
   Client_SYS.Add_To_Attr('SALES_2', tmp_sum_, attr_);

   OPEN ord_invo_sum3(company_, customer_no_);
   FETCH ord_invo_sum3 INTO tmp_sum_;
   CLOSE ord_invo_sum3;
   Client_SYS.Add_To_Attr('SALES_3', tmp_sum_, attr_);
END Get_Financial_Data__;


@UncheckedAccess
FUNCTION Get_User_Companies__ (
   customer_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   comp_attr_ VARCHAR2(32000);
   i_         NUMBER;

   CURSOR user_companies IS
      SELECT company
      FROM user_finance
      WHERE userid = Fnd_Session_API.Get_Fnd_User
      INTERSECT
      SELECT company
      FROM identity_invoice_info
      WHERE identity = customer_no_
      AND   party_type_db = Party_Type_API.DB_CUSTOMER;
BEGIN
   Client_SYS.Clear_Attr(comp_attr_);
   i_ := 1;
   FOR rec_ IN user_companies LOOP
      Client_SYS.Add_To_Attr('C'||i_, rec_.company, comp_attr_);
      i_ := i_ + 1;
   END LOOP;

   RETURN comp_attr_;
END Get_User_Companies__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Contact_Address (
   customer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR contact_address IS
      SELECT contact_address
      FROM CUSTOMER_INFO_CONTACT_TAB
      WHERE customer_primary = 'TRUE'
      AND   customer_id      = customer_id_;

   contact_address_ CUSTOMER_INFO_CONTACT_TAB.CONTACT_ADDRESS%TYPE;
BEGIN
  OPEN contact_address;
  FETCH contact_address INTO contact_address_;
  CLOSE contact_address;

  RETURN contact_address_;
END Get_Contact_Address;

@UncheckedAccess
FUNCTION Get_Outstanding_Ord_Net_Amt (
   customer_no_ IN  VARCHAR2,
   company_     IN  VARCHAR2 ) RETURN NUMBER
IS  
   base_rounding_         NUMBER;
   order_rec_             Customer_Order_API.Public_Rec;
   rounding_              NUMBER;
   rental_chargable_days_ NUMBER;
   line_discount_         NUMBER;
   line_disc_no_tax_      NUMBER;
   total_disc_no_tax_     NUMBER;
   tax_percentage_        NUMBER;
   total_gross_amt_       NUMBER;
   site_company_          VARCHAR2(20);
   net_amount_            NUMBER;
   open_net_sum_          NUMBER;

   CURSOR get_line_data IS
      SELECT (col.buy_qty_due + (col.qty_shipdiff / col.conv_factor * col.inverted_conv_factor) - col.qty_invoiced) quantity,
             col.price_conv_factor, col.currency_rate, col.sale_unit_price, col.unit_price_incl_tax,
             col.order_discount, col.additional_discount, col.rental, col.order_no, col.line_no, col.rel_no, col.line_item_no
      FROM  CUSTOMER_ORDER_LINE_TAB col, customer_order_tab co
      WHERE co.customer_no = customer_no_
      AND   co.rowstate IN ('Planned', 'Released', 'Reserved', 'Picked','PartiallyDelivered','Delivered')
      AND   co.order_no = col.order_no
      AND   (col.buy_qty_due + (col.qty_shipdiff / col.conv_factor * col.inverted_conv_factor) - col.qty_invoiced) > 0
      AND   col.line_item_no <= 0
      AND   col.rowstate IN ('Delivered', 'PartiallyDelivered', 'Picked', 'Released', 'Reserved')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = co.contract
                    AND   contract = uas.site
                    AND   company LIKE NVL(company_, '%'))
      AND   co.order_no IN (SELECT order_no 
                         FROM customer_order_usg);
BEGIN
   FOR line_rec_ IN get_line_data LOOP      
      order_rec_      := Customer_Order_API.Get(line_rec_.order_no);
      site_company_  := Site_API.Get_Company(order_rec_.contract);
      rounding_ := Currency_Code_API.Get_Currency_Rounding(site_company_, order_rec_.currency_code);
      base_rounding_ := Currency_Code_API.Get_Currency_Rounding(site_company_, Company_Finance_API.Get_Currency_Code(site_company_));      
  
      tax_percentage_  := NVL(Source_Tax_Item_API.Get_Total_Tax_Percentage(site_company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                                           line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, TO_CHAR(line_rec_.line_item_no), '*'), 0);
      line_discount_   := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no,
                                                                               line_rec_.quantity, line_rec_.price_conv_factor, rounding_);
   
      rental_chargable_days_ := Customer_Order_Line_API.Get_Rental_Chargeable_Days(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
      IF (order_rec_.use_price_incl_tax  = 'TRUE') THEN
         line_disc_no_tax_   := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no,
                                                                                  line_rec_.quantity, line_rec_.price_conv_factor,  rounding_, tax_percentage_ => NVL(tax_percentage_, 0));
         total_gross_amt_    := line_rec_.quantity * line_rec_.price_conv_factor * line_rec_.unit_price_incl_tax * rental_chargable_days_;
   
         total_disc_no_tax_  := line_disc_no_tax_;
         total_disc_no_tax_  := total_disc_no_tax_ + ROUND (ROUND((total_gross_amt_ - line_discount_) * line_rec_.order_discount, rounding_)/(1+ (tax_percentage_/100)), rounding_); -- Calculating Order discount
         total_disc_no_tax_  := total_disc_no_tax_ + ROUND (ROUND((total_gross_amt_ - line_discount_) * line_rec_.additional_discount, rounding_)/(1+ (tax_percentage_/100)), rounding_); -- Calculating Additional discount
   
         net_amount_ := NVL((ROUND( total_gross_amt_ /(1+ (tax_percentage_/100)), rounding_) - total_disc_no_tax_), 0);
   
      ELSE
         net_amount_ := NVL(ROUND(((line_rec_.quantity * line_rec_.price_conv_factor * line_rec_.sale_unit_price * rental_chargable_days_) - line_discount_)
                                * (1 - (line_rec_.order_discount + line_rec_.additional_discount) / 100), rounding_) ,0);
      END IF;      
      
      net_amount_ := ROUND( net_amount_*line_rec_.currency_rate, base_rounding_);
      open_net_sum_ := NVL(open_net_sum_, 0) + net_amount_;
   END LOOP;
   
   RETURN open_net_sum_;
END Get_Outstanding_Ord_Net_Amt;

@UncheckedAccess
FUNCTION Get_Open_Quotation_Net_Amt (
   customer_no_  IN  VARCHAR2,
   company_      IN  VARCHAR2 ) RETURN NUMBER
IS
   is_prospect_category_ VARCHAR2(5) := 'FALSE';
   open_net_sum_         NUMBER;
   
   CURSOR open_quotations(customer_no_ VARCHAR2) IS
      SELECT SUM(Order_Quotation_Line_API.Get_Base_Sale_Price_Total(quotation_no, line_no, rel_no, line_item_no))
      FROM ORDER_QUOTATION_LINE_TAB oql
      WHERE customer_no = customer_no_
      AND   rowstate NOT IN ('Cancelled', 'CO Created', 'Lost')
      AND   quotation_no IN (SELECT oq.quotation_no 
                              FROM order_quotation_tab oq 
                              WHERE oq.b2b_order = 'FALSE'
                              AND  rowstate != 'Closed')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = oql.contract
                    AND   contract = uas.site
                    AND   (company LIKE NVL(company_, '%') OR is_prospect_category_ = 'TRUE'))
      AND   quotation_no IN (SELECT * 
                             FROM order_quotation_usg);
BEGIN
   IF company_ IS NULL THEN
      IF (Customer_Info_API.Get_Customer_Category_Db(customer_no_) = Customer_Category_API.DB_PROSPECT) THEN
         is_prospect_category_ := 'TRUE';
      END IF;
   END IF;

   OPEN open_quotations(customer_no_);
   FETCH open_quotations INTO open_net_sum_;
   CLOSE open_quotations;
   
   RETURN open_net_sum_;
END Get_Open_Quotation_Net_Amt;

@UncheckedAccess
FUNCTION Get_Open_Invoice_Net_Amt (   
   customer_no_ IN  VARCHAR2,
   company_     IN  VARCHAR2 ) RETURN NUMBER
IS
   open_net_sum_   NUMBER;
   
   CURSOR open_invoices(company_ VARCHAR2, customer_no_ VARCHAR2) IS
      SELECT SUM(net_dom_amount)
      FROM customer_order_inv_head coi
      WHERE identity = customer_no_
      AND   company LIKE NVL(company_, '%')
      AND   objstate NOT IN ('PaidPosted')
      AND   EXISTS (SELECT 1
                    FROM  user_allowed_site_pub uas, company_site
                    WHERE contract = coi.contract
                    AND   contract = uas.site
                    AND   company LIKE NVL(company_, '%'));
BEGIN
   OPEN open_invoices(company_, customer_no_);
   FETCH open_invoices INTO open_net_sum_;
   CLOSE open_invoices;
   
   RETURN open_net_sum_;
END Get_Open_Invoice_Net_Amt;
