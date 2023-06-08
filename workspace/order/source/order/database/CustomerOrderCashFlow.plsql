-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderCashFlow
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  161206  ChJalk  Bug 132185, Modified the methods Cash_Flow_For_Prel_Invoices___ and Cash_Flow_For_Order_Lines___ to assign the correct value for the project code part.
--  160629  TiRalk  STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  160211  IsSalk  FINHR-685, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Charge.
--  151106  AyAmlk  Bug 125571, Modified Create_Cfa_Cash_Flow_Data() in order to prevent creating cash flow data for COs created
--  151106          in the inter-site flow between sites in the same company.
--  150218  PraWlk  PRSC-6210, Modified Handle_Load_Data___() to remove Component_Invoic_SYS.INSTALLED check as INVOIC is static to ORDER.
--  140922  ChFolk  Merged bug fix 112409, as the related code was moved from FINCFA to ORDER.
--  140908  ShVese  Removed unused cursor parameter company in the cursor get_max_planned_del_date.
--  140820  ChFolk  Modified Handle_Load_Data___ to add type_status.
--  140812  SlKapl  FIPR19 Multiple tax handling in CO and PO flows - replaced Customer_Order_Charge_API.Get_Total_Tax_Amount by Customer_Order_Charge_API.Get_Total_Tax_Amount_Curr
--  140707  ChFolk  Modified Handle_Load_Data___ to avoid handling customer order cash flow information in FINCFA instead all were done from here.
--  140623  DipeLk  PRFI-504, Removed the method Cfa_Cash_Flow_Type_API.Get_Cash_Flow_Type_Id
--  130705  MaIklk  TIBE-973, Removed global constant inst_CfaUpdateUtility_ and used conditional compilation instead.
--  120312  MaMalk  Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  120216  Darklk  Bug 100773, Removed the rowstate check from the where clause of the cursor get_order_line_stages to avoid selecting
--  120216          the undefined expected approval date stage billing lines.
--  120213  HaPulk  Write existing Dynamic code to INVOIC (OutInvoiceUtilPub) as Static
--  111107  ErFelk  Bug 99596, Modified where clause of cursor get_order_lines_cfa_dates by removing the rowstate of the 
--  111107          order_line_staged_billing_tab select statement, in Cash_Flow_For_Order_Lines___().
--  110504  JeLise  Removed unused party from cursor get_invoices in Cash_Flow_For_Prel_Invoices___.
--  100909  JuMalk  Bug 92795, Modified the where clause of cursor get_order_charges. Added condition not to retreive collect charge lines. 
--  100906  JuMalk  Bug 92795, Modified the where clause of cursor get_order_charges of Get_Order_Charge_Amt___ to get the connected charge lines as well. 
--  100517  Ajpelk  Merge rose method documentation
--  091222  KAYOLK  Modified the methods Handle_Load_Data___(), Handle_Payment_Terms___(), Handle_Negative_Cash_Flow___(),
--  091222          Cash_Flow_For_Order_Lines___(), and Cash_Flow_For_Prel_Invoices___() for renaming the code part
--  091222          cost_center, object_no, and project_no as codeno_b, codeno_e and codeno_f respectively.
--  090930  MaMalk  Removed unused procedures Cash_Flow_For_Charges___ and Cash_Flow_For_Invoice_Items___. Modified Cash_Flow_For_Order_Lines___ and Cash_Flow_For_Prel_Invoices___
--  090930          to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  090611  SudJlk  Bug 80309, Increased length of party_type_ from 200 to 2000 in Handle_Load_Data___, Cash_Flow_For_Invoice_Items___and Cash_Flow_For_Charges___. 
--  090610  SudJlk  Bug 80309, Modified methods Handle_Load_Data___, Cash_Flow_For_Invoice_Items___and Cash_Flow_For_Charges___
--  090529          to retrieve Cash_Flow_Type_Id and Party_Type to enhance performance in Cash Flow Analysis.
--  070530  ChJalk  Bug 64475, Modified method Handle_Payment_Terms___ in order to reinitialize the value of
--  070530          attr_ before calling method Handle_Load_Data___. Modified method Cash_Flow_For_Order_Lines___
--  070530          in order to split and placed the code in separate implementation methods.
--  070530          Added new methods Handle_Payment_Terms___,Handle_Negative_Cash_Flow___ and Calc_Line_Or_Stage_Totals___.
--  070425  Haunlk   Checked and added assert_safe comments where necessary.
--  070308  MaMalk  Bug 60707, Modified method Cash_Flow_For_Order_Lines___ in order to handle staged billing correctly.
--  070308          Removed the cursor get_order_lines_planned_dates and added cursors get_order_lines_cfa_dates,
--  070308          get_order_line_stages and get_stages_total_percentage in the method Cash_Flow_For_Order_Lines___.
--  070212  Cpeilk  Call 140866, Added method Handle_Prepaym_Invoices___ and modified method Create_Cfa_Cash_Flow_Data.
--  070118  WaJalk  Bug 69758, Modified get_order_lines in Cash_Flow_For_Order_Lines___ to add charged_item and exchange_item in the SELECT clause.
--  070118          Added a condition to check any planed delivery dates avaliable from Co lines and if no planed delivery date avaiable then modifed to
--  070118          consider the wanted delivery date and attached Charge lines with Co header are considered for showing in CFA.
--  070118          Modified Get_Order_Charge_Amt___ to handle null values.
--  070118          Bug 60758, Modified the cursor get_order in Create_Cfa_Cash_Flow_Data to correct the staus list to include "CreditBlocked".
--  070118          Modified the cursor get_order_lines in Cash_Flow_For_Order_Lines___ to add qty_shipdiff in the SELECT clause.
--  070118          Bug 60758, Modified the procedures Create_Cfa_Cash_Flow_Data, Cash_Flow_For_Order_Lines___.
--  070118          Added the procedures Cash_Flow_For_Prel_Invoices___ , Get_Order_Charge_Amt___and Get_Order_Line_Charge_Amt___.
--  070118          Removed the procedures Cash_Flow_For_Charges___, Handle_Charge_Lines___, Cash_Flow_For_Invoice_Items___ and Cash_Flow_For_Charges___.
--  070118          Bug 60758, Modified the procedures Create_Cfa_Cash_Flow_Data, Cash_Flow_For_Order_Lines___, Cash_Flow_For_Invoice_Items___ and Cash_Flow_For_Charges___.
--  070118          Added the procedures Cash_Flow_For_Charges___, Handle_Charge_Lines___, Handle_Adv_Invoices___ and Handle_Load_Data___.
--  060614  PrPrlk  Bug 58710, Made changes to the methods Cash_Flow_For_Order_Lines___, Cash_Flow_For_Charges___ and Cash_Flow_For_Invoice_Items___
--  060614          to prevent the buffer overflow error caused due to the length of the variables.
--  060515  RoJalk  Enlarge Address - Changed variable definitions.
--  060421  JaBalk  Removed unnecessary parameters from Get_Invoice_Date method.
--  060419  IsWilk  Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  060124  NiDalk  Added Assert safe annotation.
--  050901  VeMolk  Bug 53021, Modified Cash_Flow_For_Invoice_Items___ to get value for currency and customer from
--  050901          invoice header instead of CO header. Modified Cash_Flow_For_Charges___  to pass the status of
--  050901          the order line when a charge is connected to a line and the header status for unconnected lines.
--  041217  ChJalk  Bug 47792, Modified the calculation of discount_amount considerring Additional Discount
--  041217          in Cash_Flow_For_Order_Lines___.
--  040429  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040126  GeKalk  Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  ----------------------------------- 13.3.0 ---------------------------------
--  031024  DaZa    Added calls to Payment_Plan_API.Get_Installment_Plan_Data/Payment_Term_API.Get_Installment_Data
--                  and rewrote methods so we now can handle payment terms installments correctly
--  030428  LoKrLK  IID DEFI162N Added parameter value for Payment_Term_Details_API.Get_Days_To_Due_Date call
--  021101  LoKrLK  Changed Payment_Term_API.Get_Days_Cnt call to Payment_Term_Details_API.Get_Days_To_Due_Date
--  010413  JaBa    Bug Fix 20598,Added new global lu constant inst_CfaUpdateUtility_.
--  000615  MaGu    Changed calculation of due_date_ in Cash_Flow_For_Invoice_Items___.
--                  Also changed calculation of delivery_date_ in Cash_Flow_For_Order_Lines___
--                  and renamed variable delivery_date_ to due_date_.
--  000608  MaGu    Bug fix 42194. Added procedure Cash_Flow_For_Charges___.
--                  Also modified fetching of pre_accounting_id_ in Cash_Flow_For_Invoice_Items___
--                  to get correct pre accounting information for charges.
--  000606  MaGu    Modified calculation of vat_curr_amount_ and delivery_date_ in Cash_Flow_For_Order_Lines___.
--  000425  PaLj    Changed check for installed logical units. A check is made when API is instantiatet.
--                  See beginning of api-file.
--  000223  MaGu    Bug fix 13467. Changed method Cash_Flow_For_Order_Lines___ to correct
--                  calculation of vat. Also added calculation of sales tax.
--                  Added calculation of delivery_date_.
--  991111  JoEd    Changed datatype length on company_ variables.
--  991019  JakHse  Bug fix 11465, Changed the calculation of discount_amount_ in
--                  Cash_Flow_For_Order_Lines___.
--  990415  JakH    Y. Modified cursor not to use PL-calls, added use of public-
--                  record from ordhead, additional optimizations to the procedures.
--  990325  RaKu    Replaced Customer_Order_API.Get_Customer_No with direct cursor-fetch.
--  990203  RaKu    Replaced COMPANY in select from CUSTOMER_ORDER_LINE with function.
--  980331  DaZa    SID 3004, changed customer_name length to 100.
--  980211  ToOs    Replaced roundings with get_currency_rounding
--  980205  JoAn    Added NVL for vat_curr_amount.
--                  Retrieving customer_no if customer_no pay is NULL
--                  Package component lines not sent to cash flow analysis.
--  980204  JoAn    Restructured the code.
--                  Added cash flow generation for invoice items.
--  980201  JoAn    Added missing ':' before bind variable
--                  Retrieving objstate instead of state.
--                  Objstate passed to cash flow without decoding the value.
--  980123  JoAn    Added dynamic call to Cfa_Utility_API.
--                  Added call to Init_Method
--  980119  ToOs    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Cash_Flow_For_Order_Lines___
--   Calculate expected cash flows for customer order lines not yet invoiced
--   and pass the result to the Cash Flow Analysis Module for further
PROCEDURE Cash_Flow_For_Order_Lines___ (
   net_amount_to_reduce_ IN OUT NUMBER,
   default_attr_         IN     VARCHAR2,
   order_no_             IN     VARCHAR2,
   contract_             IN     VARCHAR2 )
IS
   company_                VARCHAR2(20);
   order_id_               VARCHAR2(30);
   customer_no_            CUSTOMER_ORDER_LINE_TAB.customer_no%TYPE;
   customer_name_          VARCHAR2(100);
   currency_rounding_      NUMBER;
   account_no_             VARCHAR2(10);
   account_no_desc_        VARCHAR2(100);
   codeno_b_               VARCHAR2(10);
   codeno_b_desc_          VARCHAR2(100);
   codeno_c_               VARCHAR2(10);
   codeno_c_desc_          VARCHAR2(100);
   codeno_d_               VARCHAR2(10);
   codeno_d_desc_          VARCHAR2(100);
   codeno_e_               VARCHAR2(10);
   codeno_e_desc_          VARCHAR2(100);
   codeno_f_               VARCHAR2(10);
   codeno_f_desc_          VARCHAR2(100);
   codeno_g_               VARCHAR2(10);
   codeno_g_desc_          VARCHAR2(100);
   codeno_h_               VARCHAR2(10);
   codeno_h_desc_          VARCHAR2(100);
   codeno_i_               VARCHAR2(10);
   codeno_i_desc_          VARCHAR2(100);
   codeno_j_               VARCHAR2(10);
   codeno_j_desc_          VARCHAR2(100);   
   headrec_                Customer_Order_API.public_rec;
   headerstate_            VARCHAR2(20);
   
   total_sum_amount_             NUMBER := 0;
   total_net_amount_             NUMBER := 0;
   total_vat_amount_             NUMBER := 0;

   total_charge_amount_          NUMBER := 0;
   total_charge_tax_amount_      NUMBER := 0;

   line_charge_amount_           NUMBER := 0;
   line_charge_tax_amount_       NUMBER := 0;
   tot_line_charge_amount_       NUMBER := 0;
   tot_line_charge_tax_amount_   NUMBER := 0;

   header_charge_amount_         NUMBER := 0;
   header_charge_tax_amount_     NUMBER := 0;

   counter_                      NUMBER := 0;
   rec_found_                    BOOLEAN := FALSE;
   include_charges_              BOOLEAN := TRUE;
   project_code_part_            VARCHAR2(1);
   -- Cursor for retrieving amount not invoiced from customer order line
   CURSOR get_order_lines(order_no_ IN VARCHAR2, planned_delivery_date_ IN DATE ) IS
      SELECT order_no,
             line_no,
             rel_no,
             line_item_no,
             sale_unit_price * price_conv_factor * (buy_qty_due + (qty_shipdiff / conv_factor * inverted_conv_factor) - qty_invoiced ) sale_price_ur, --unrounded
             unit_price_incl_tax * price_conv_factor * (buy_qty_due + (qty_shipdiff / conv_factor * inverted_conv_factor) - qty_invoiced ) sale_price_inc_tax_ur, --unrounded
             discount,
             order_discount,
             additional_discount,
             charged_item,
             exchange_item
      FROM   customer_order_line_tab
      WHERE  rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    line_item_no <= 0
      AND    order_no = order_no_
      AND    rental = 'FALSE'
      AND    planned_delivery_date = planned_delivery_date_
      AND    ( staged_billing = 'NOT STAGED BILLING'
                OR ( staged_billing = 'STAGED BILLING'
                   AND ( line_no, rel_no, line_item_no) IN (
                      SELECT line_no, rel_no, line_item_no
                      FROM   order_line_staged_billing_tab
                      WHERE  order_no = order_no_
                      AND    expected_approval_date IS NULL)));

   -- Select planned_delivery_date if CO line is not staged billing or all the staged billing stages do not have
   -- expected approval date. Select expected_approval_date if CO line is staged billing and all the stages have
   -- expected approval date.
   CURSOR get_order_lines_cfa_dates(order_no_ IN VARCHAR2) IS
      SELECT DISTINCT planned_delivery_date cfa_date
      FROM   customer_order_line_tab
      WHERE  rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    line_item_no    <= 0
      AND    order_no         =  order_no_
      AND    ( staged_billing = 'NOT STAGED BILLING'
             OR ( staged_billing = 'STAGED BILLING'
                AND ( line_no, rel_no, line_item_no) IN (
                   SELECT line_no, rel_no, line_item_no
                   FROM   order_line_staged_billing_tab
                   WHERE  order_no = order_no_
                   AND    expected_approval_date IS NULL)))
   UNION
      SELECT DISTINCT expected_approval_date cfa_date
      FROM   order_line_staged_billing_tab
      WHERE  order_no = order_no_
      AND    (line_no, rel_no, line_item_no) NOT IN (
             SELECT line_no, rel_no, line_item_no
             FROM   order_line_staged_billing_tab
             WHERE  order_no = order_no_
             AND    expected_approval_date IS NULL);

   -- Select non invoiced staged billing data, if CO line is staged billing and all the stages have
   -- expected approval date.
   CURSOR get_order_line_stages(order_no_               IN VARCHAR2,
                                expected_approval_date_ IN DATE )    IS
      SELECT ol.order_no,
             ol.line_no,
             ol.rel_no,
             ol.line_item_no,
             sb.total_percentage,
             sale_unit_price * price_conv_factor * (buy_qty_due + (qty_shipdiff / conv_factor * inverted_conv_factor) - qty_invoiced ) sale_price_ur, --unrounded
             unit_price_incl_tax * price_conv_factor * (buy_qty_due + (qty_shipdiff / conv_factor * inverted_conv_factor) - qty_invoiced ) sale_price_inc_tax_ur, --unrounded
             discount,
             order_discount,
             additional_discount,
             charged_item,
             exchange_item
      FROM   customer_order_line_tab ol, order_line_staged_billing_tab sb
      WHERE  ol.order_no     = sb.order_no
      AND    ol.line_no      = sb.line_no
      AND    ol.rel_no       = sb.rel_no
      AND    ol.line_item_no = sb.line_item_no
      AND    sb.order_no     = order_no_
      AND    sb.rowstate IN ('Planned', 'Approved')
      AND    ol.rental = 'FALSE'
      AND    sb.expected_approval_date = expected_approval_date_
      AND    (sb.line_no, sb.rel_no, sb.line_item_no) NOT IN (
             SELECT line_no, rel_no, line_item_no
             FROM   order_line_staged_billing_tab
             WHERE  order_no = order_no_
             AND    expected_approval_date IS NULL);

BEGIN

   company_ := Client_SYS.Get_Item_Value('COMPANY', default_attr_);   
   -- Retrieve order header.
   headrec_ := Customer_Order_API.Get(order_no_);
   headerstate_ := Customer_Order_API.Get_Objstate(order_no_);
   customer_no_     := NVL(headrec_.customer_no_pay, headrec_.customer_no);
   customer_name_   := Cust_Ord_Customer_API.Get_Name(customer_no_);
   order_id_ := order_no_;

   -- Retrieve pre accounting information
   Pre_Accounting_API.Get_Pre_Accounting (account_no_, account_no_desc_, codeno_b_, codeno_b_desc_,
                                          codeno_c_, codeno_c_desc_, codeno_d_, codeno_d_desc_,
                                          codeno_e_, codeno_e_desc_, codeno_f_, codeno_f_desc_,
                                          codeno_g_, codeno_g_desc_, codeno_h_, codeno_h_desc_,
                                          codeno_i_, codeno_i_desc_, codeno_j_, codeno_j_desc_,
                                          headrec_.pre_accounting_id, company_);

   -- For non-invoiced CO lines - priority sequence for fetching the values for project code part will be, 
   --   a) "Project id" of the Customer order header 
   --   b) Relevant column of the pre-posting of the CO header
   project_code_part_     := Accounting_Code_Parts_API.Get_Codepart_Function(company_,'PRACC');

   IF (headrec_.project_id IS NOT NULL) THEN
      CASE project_code_part_
         WHEN 'A' THEN account_no_ := headrec_.project_id;
         WHEN 'B' THEN codeno_b_   := headrec_.project_id;
         WHEN 'C' THEN codeno_c_   := headrec_.project_id;
         WHEN 'D' THEN codeno_d_   := headrec_.project_id;
         WHEN 'E' THEN codeno_e_   := headrec_.project_id;
         WHEN 'F' THEN codeno_f_   := headrec_.project_id;
         WHEN 'G' THEN codeno_g_   := headrec_.project_id;
         WHEN 'H' THEN codeno_h_   := headrec_.project_id;
         WHEN 'I' THEN codeno_i_   := headrec_.project_id;
         WHEN 'J' THEN codeno_j_   := headrec_.project_id;
      END CASE;
   END IF;
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding (company_, headrec_.currency_code);
   -- Used the cursor get_order_lines_cfa_dates to get planned delivery dates and expected approval dates for the customer order.
   -- All the CO lines handling goes here.
   -- Get not invoiced amount from customer order line.
   FOR rec_ IN get_order_lines_cfa_dates(order_no_) LOOP
      -- Have a counter to identify the FIRST cfa date.
      counter_ := counter_ + 1;
      rec_found_ := TRUE;

      total_sum_amount_ := 0;
      total_net_amount_ := 0;
      total_vat_amount_ := 0;

      total_charge_amount_        := 0;
      total_charge_tax_amount_    := 0;

      line_charge_amount_         := 0;
      line_charge_tax_amount_     := 0;
      tot_line_charge_amount_     := 0;
      tot_line_charge_tax_amount_ := 0;

      header_charge_amount_       := 0;
      header_charge_tax_amount_   := 0;

      FOR orderlinerec_ IN get_order_lines(order_no_, rec_.cfa_date) LOOP
         IF NOT((orderlinerec_.charged_item = 'ITEM NOT CHARGED' OR orderlinerec_.exchange_item = 'EXCHANGED ITEM')) THEN
            Calc_Line_Or_Stage_Totals___ ( total_sum_amount_,
                                           total_net_amount_,
                                           total_vat_amount_,
                                           tot_line_charge_amount_,
                                           tot_line_charge_tax_amount_,
                                           company_,
                                           orderlinerec_.order_no, 
                                           orderlinerec_.line_no, 
                                           orderlinerec_.rel_no, 
                                           orderlinerec_.line_item_no,
                                           orderlinerec_.sale_price_ur,
                                           orderlinerec_.sale_price_inc_tax_ur,
                                           currency_rounding_,
                                           orderlinerec_.discount,
                                           orderlinerec_.order_discount,
                                           orderlinerec_.additional_discount,
                                           NULL,
                                           TRUE );
         END IF;
      END LOOP;

      -- Staged Billing CO lines
      FOR sblinerec_ IN get_order_line_stages(order_no_, rec_.cfa_date) LOOP
         IF NOT((sblinerec_.charged_item = 'ITEM NOT CHARGED' OR sblinerec_.exchange_item = 'EXCHANGED ITEM')) THEN
            Calc_Line_Or_Stage_Totals___ ( total_sum_amount_,
                                           total_net_amount_,
                                           total_vat_amount_,
                                           tot_line_charge_amount_,
                                           tot_line_charge_tax_amount_,
                                           company_,
                                           sblinerec_.order_no, 
                                           sblinerec_.line_no, 
                                           sblinerec_.rel_no, 
                                           sblinerec_.line_item_no,
                                           sblinerec_.sale_price_ur,
                                           sblinerec_.sale_price_inc_tax_ur,
                                           currency_rounding_,
                                           sblinerec_.discount,
                                           sblinerec_.order_discount,
                                           sblinerec_.additional_discount,
                                           sblinerec_.total_percentage,
                                           include_charges_ );
            IF (include_charges_) THEN
               include_charges_ := FALSE;
            END IF;
         END IF;
      END LOOP;

      -- Order charges connected CO Header should just be added for the FIRST planned_delivery_date.
      IF (counter_ = 1) THEN
          -- To get the header charge amount and header charge tax amount  from charge lines connected with the Co header in access.
          Get_Order_Charge_Amt___(header_charge_amount_, header_charge_tax_amount_, company_, order_no_);
      ELSE
         -- Order charges and the coreposnding tax should be zero for the planned_delivery_dates other than the first planned_delivery_date.
         header_charge_amount_     := 0;
         header_charge_tax_amount_ := 0;
      END IF;

      -- Sum up all the charge amounts together.
      total_charge_amount_ := header_charge_amount_ + tot_line_charge_amount_;
      -- Sum up all the charge tax amounts together.
      total_charge_tax_amount_ := header_charge_tax_amount_ + tot_line_charge_tax_amount_;

      -- Add charge amount to the total net amount before fetching instalment data
      total_net_amount_ := total_net_amount_ + total_charge_amount_;
      -- Add charge tax amount to the total vat amount before fetching instalment data
      total_vat_amount_ := total_vat_amount_ + total_charge_tax_amount_;

      Handle_Payment_Terms___ ( net_amount_to_reduce_,
                                default_attr_,
                                order_id_,
                                company_,
                                rec_.cfa_date,
                                headrec_.pay_term_id, 
                                headrec_.currency_code,
                                total_net_amount_,
                                total_vat_amount_,
                                customer_no_,
                                customer_name_,
                                headerstate_,
                                account_no_,
                                codeno_b_,
                                codeno_c_,
                                codeno_d_,
                                codeno_e_,
                                codeno_f_,
                                codeno_g_,
                                codeno_h_,
                                codeno_i_,
                                codeno_j_ );

   END LOOP;

   -- If there are no CO lines available.
   IF NOT (rec_found_) THEN
      total_net_amount_         := 0;
      total_vat_amount_         := 0;
      header_charge_amount_     := 0;
      header_charge_tax_amount_ := 0;

      -- To get the header charge amount and header charge tax amount  from charge lines connected with the Co header in access.

      Get_Order_Charge_Amt___(header_charge_amount_, header_charge_tax_amount_, company_, order_no_);

      -- Sum up all the charge amounts together.
      total_net_amount_ := header_charge_amount_;
      -- Sum up all the charge tax amounts together.
      total_vat_amount_ := header_charge_tax_amount_;

      Handle_Payment_Terms___ ( net_amount_to_reduce_,
                                default_attr_,
                                order_id_,
                                company_,
                                headrec_.wanted_delivery_date,
                                headrec_.pay_term_id, 
                                headrec_.currency_code,
                                total_net_amount_,
                                total_vat_amount_,
                                customer_no_,
                                customer_name_,
                                headerstate_,
                                account_no_,
                                codeno_b_,
                                codeno_c_,
                                codeno_d_,
                                codeno_e_,
                                codeno_f_,
                                codeno_g_,
                                codeno_h_,
                                codeno_i_,
                                codeno_j_ );
   END IF;

   -- Check to see if any further reduction needed then create a special CO line with negative cash flow.
   IF (net_amount_to_reduce_ > 0 ) THEN
      Handle_Negative_Cash_Flow___ ( net_amount_to_reduce_,
                                     default_attr_,
                                     order_no_,
                                     company_,
                                     contract_,
                                     headrec_.wanted_delivery_date,
                                     headrec_.currency_code,
                                     customer_no_,
                                     customer_name_,
                                     headerstate_,
                                     account_no_,
                                     codeno_b_,
                                     codeno_c_,
                                     codeno_d_,
                                     codeno_e_,
                                     codeno_f_,
                                     codeno_g_,  
                                     codeno_h_,
                                     codeno_i_,
                                     codeno_j_ );
   END IF;
END Cash_Flow_For_Order_Lines___;


-- Cash_Flow_For_Prel_Invoices___
--   Calculate expected cash flows for invoice items not yet posted
--   and pass the result to the Cash Flow Analysis Module for further
PROCEDURE Cash_Flow_For_Prel_Invoices___ (
   default_attr_ IN VARCHAR2 )
IS
   company_                   VARCHAR2(20);
   order_id_                  VARCHAR2(30);
   customer_name_             VARCHAR2(100);
   invoice_date_              DATE;
   account_no_                VARCHAR2(10);
   account_no_desc_           VARCHAR2(100);
   codeno_b_                  VARCHAR2(10);
   codeno_b_desc_             VARCHAR2(100);
   codeno_c_                  VARCHAR2(10);
   codeno_c_desc_             VARCHAR2(100);
   codeno_d_                  VARCHAR2(10);
   codeno_d_desc_             VARCHAR2(100);
   codeno_e_                  VARCHAR2(10);
   codeno_e_desc_             VARCHAR2(100);
   codeno_f_                  VARCHAR2(10);
   codeno_f_desc_             VARCHAR2(100);
   codeno_g_                  VARCHAR2(10);
   codeno_g_desc_             VARCHAR2(100);
   codeno_h_                  VARCHAR2(10);
   codeno_h_desc_             VARCHAR2(100);
   codeno_i_                  VARCHAR2(10);
   codeno_i_desc_             VARCHAR2(100);
   codeno_j_                  VARCHAR2(10);
   codeno_j_desc_             VARCHAR2(100);
   pre_accounting_id_         NUMBER;
   attr_                      VARCHAR2(2000);   
   installment_attr_          VARCHAR2(2000);
   installment_due_date_      DATE;
   installment_curr_amount_   NUMBER;
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   installment_end_           BOOLEAN;
   invoice_headrec_           Customer_Order_Inv_Head_API.Public_Rec;
   project_code_part_         VARCHAR2(1);
   ord_rec_                   Customer_Order_API.Public_Rec;
   -- Cursor for retrieving amount not posted from customer order inv head
   CURSOR get_invoices(company_ IN VARCHAR2 ) IS
      SELECT invoice_id, party_type, creators_reference, project_id
      FROM   customer_order_inv_head
             --- not changed since the view uses c1...cn, d1..dn, n1..nn columnes
      WHERE  objstate = 'Preliminary'
      AND    company = company_;
BEGIN

   company_ := Client_SYS.Get_Item_Value('COMPANY', default_attr_);
   project_code_part_     := Accounting_Code_Parts_API.Get_Codepart_Function(company_,'PRACC');
   -- Get amount not invoiced from customer order line
   FOR rec_ IN get_invoices(company_) LOOP

      attr_ := default_attr_;

      invoice_headrec_ := Customer_Order_Inv_Head_API.Get(company_, rec_.invoice_id);
      customer_name_   := Cust_Ord_Customer_API.Get_Name(invoice_headrec_.customer_no);
      invoice_date_    := invoice_headrec_.invoice_date;

      order_id_ := rec_.creators_reference;
      ord_rec_ := Customer_Order_API.Get(order_id_);
      
      account_no_ := NULL;
      codeno_b_   := NULL;
      codeno_c_   := NULL;
      codeno_d_   := NULL;
      codeno_e_   := NULL;
      codeno_f_   := NULL;
      codeno_g_   := NULL;
      codeno_h_   := NULL;
      codeno_i_   := NULL;
      codeno_j_   := NULL;
      -- Use preaccounting from order head for charge connected to order
      pre_accounting_id_ := ord_rec_.pre_accounting_id;

      -- Retrieve pre accounting information
      Pre_Accounting_API.Get_Pre_Accounting(account_no_, account_no_desc_, codeno_b_, codeno_b_desc_,
                                             codeno_c_, codeno_c_desc_, codeno_d_, codeno_d_desc_,
                                             codeno_e_, codeno_e_desc_, codeno_f_, codeno_f_desc_,
                                             codeno_g_, codeno_g_desc_, codeno_h_, codeno_h_desc_,
                                             codeno_i_, codeno_i_desc_, codeno_j_, codeno_j_desc_,
                                             pre_accounting_id_, company_);

      -- For invoiced CO lines - priority sequence for fetching the values for project code part will be, 
      -- For normal invoice - priority sequence will be, 
      --    a) "Project id" of the Invoice header 
      --    b) "Project id" of the Customer order header 
      --    c) Relevant column of the pre-posting of the CO header 
      -- For collective invoice - priority sequence will be, 
      --    a) "Project id" of the Invoice header  
      IF (rec_.project_id IS NOT NULL) THEN
         CASE project_code_part_
            WHEN 'A' THEN account_no_ := rec_.project_id;
            WHEN 'B' THEN codeno_b_   := rec_.project_id;
            WHEN 'C' THEN codeno_c_   := rec_.project_id;
            WHEN 'D' THEN codeno_d_   := rec_.project_id;
            WHEN 'E' THEN codeno_e_   := rec_.project_id;
            WHEN 'F' THEN codeno_f_   := rec_.project_id;
            WHEN 'G' THEN codeno_g_   := rec_.project_id;
            WHEN 'H' THEN codeno_h_   := rec_.project_id;
            WHEN 'I' THEN codeno_i_   := rec_.project_id;
            WHEN 'J' THEN codeno_j_   := rec_.project_id;
         END CASE;
      ELSIF (ord_rec_.project_id IS NOT NULL) THEN
         CASE project_code_part_
            WHEN 'A' THEN account_no_ := ord_rec_.project_id;
            WHEN 'B' THEN codeno_b_   := ord_rec_.project_id;
            WHEN 'C' THEN codeno_c_   := ord_rec_.project_id;
            WHEN 'D' THEN codeno_d_   := ord_rec_.project_id;
            WHEN 'E' THEN codeno_e_   := ord_rec_.project_id;
            WHEN 'F' THEN codeno_f_   := ord_rec_.project_id;
            WHEN 'G' THEN codeno_g_   := ord_rec_.project_id;
            WHEN 'H' THEN codeno_h_   := ord_rec_.project_id;
            WHEN 'I' THEN codeno_i_   := ord_rec_.project_id;
            WHEN 'J' THEN codeno_j_   := ord_rec_.project_id;
         END CASE;
      END IF;
      
      Client_SYS.Clear_Attr(installment_attr_);
      ptr_ := NULL;
      -- Fetch in all payment terms installments in an attribute string
      Payment_Plan_API.Get_Installment_Plan_Data(installment_attr_, company_, rec_.invoice_id);

      -- loop thru all payment terms installments
      WHILE (Client_SYS.Get_Next_From_Attr(installment_attr_, ptr_, name_, value_)) LOOP

         -- unpack installment attributes
         IF (name_ = 'INSTALLMENT_ID') THEN
            installment_end_ := FALSE;
         ELSIF (name_ = 'DUE_DATE') THEN
            installment_due_date_ := Client_SYS.Attr_Value_To_Date(value_);
         ELSIF (name_ = 'CURR_AMOUNT') THEN
            installment_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
            installment_end_ := TRUE;
         END IF;

         IF (installment_end_) THEN
            IF (rec_.invoice_id IS NOT NULL) THEN
               Handle_Load_Data___(attr_,
                                   installment_due_date_,
                                   installment_curr_amount_,
                                   invoice_headrec_.currency_code,
                                   'Invoiced',
                                   invoice_headrec_.customer_no,
                                   customer_name_,
                                   order_id_,
                                   account_no_,
                                   codeno_b_,
                                   codeno_c_,
                                   codeno_d_,
                                   codeno_e_,
                                   codeno_f_,
                                   codeno_g_,
                                   codeno_h_,
                                   codeno_i_,
                                   codeno_j_,
                                   rec_.invoice_id,
                                   NULL);
            END IF;
            attr_ := default_attr_;
         END IF;
      END LOOP;
   END LOOP;
END Cash_Flow_For_Prel_Invoices___;


-- Handle_Adv_Invoices___
--   This procedure invokes finance procedure dymanically to get the
--   open amount
PROCEDURE Handle_Adv_Invoices___ (
   curr_amount_  IN OUT NUMBER,
   company_      IN     VARCHAR2,
   order_no_     IN     VARCHAR2 )
IS   
BEGIN
   Out_Invoice_Util_Pub_API.Get_Co_Adv_Inv_Open_Amount(curr_amount_, company_, order_no_);   
END Handle_Adv_Invoices___;


-- Handle_Load_Data___
--   This procedure loads the data to pass it to the cash flow analysis
PROCEDURE Handle_Load_Data___ (
   attr_                    IN OUT VARCHAR2,
   installment_due_date_    IN     DATE,
   installment_curr_amount_ IN     NUMBER,
   currency_code_           IN     VARCHAR2,
   row_state_               IN     VARCHAR2,
   customer_no_             IN     VARCHAR2,
   customer_name_           IN     VARCHAR2,
   order_id_                IN     VARCHAR2,
   account_no_              IN     VARCHAR2,
   codeno_b_                IN     VARCHAR2,
   codeno_c_                IN     VARCHAR2,
   codeno_d_                IN     VARCHAR2,
   codeno_e_                IN     VARCHAR2,
   codeno_f_                IN     VARCHAR2,
   codeno_g_                IN     VARCHAR2,
   codeno_h_                IN     VARCHAR2,
   codeno_i_                IN     VARCHAR2,
   codeno_j_                IN     VARCHAR2,
   invoice_id_              IN     VARCHAR2 DEFAULT NULL,
   exp_delivery_date_       IN     DATE DEFAULT NULL )
IS
   
   party_type_              VARCHAR2(2000); 
   user_def_cfa_status_     NUMBER;
   int_ext_                 VARCHAR2(30);
   in_out_                  VARCHAR2(30);
   include_date_            BOOLEAN;
   company_                 VARCHAR2(20);
   source_id_               VARCHAR2(30);
   cash_flow_type_id_       VARCHAR2(30);
   cash_flow_date_          DATE;
   cash_flow_text_          VARCHAR2(100);
   payment_delay_           NUMBER; 
   $IF (Component_Fincfa_SYS.INSTALLED)$THEN
      cash_flow_rec_  Cfa_Update_Utility_API.LoadCfaDataRec;
   $END
   finlib_number_list_     Finance_Lib_API.finlib_number_list;
   
BEGIN
   $IF (Component_Fincfa_SYS.INSTALLED) $THEN 
      party_type_ := Party_Type_API.Decode('CUSTOMER');
      company_    := Client_Sys.Get_Item_Value('COMPANY', attr_);
      source_id_  := Client_Sys.Get_Item_Value('SOURCE_ID', attr_ );
      cash_flow_type_id_ := Client_Sys.Get_Item_Value('CASH_FLOW_TYPE_ID', attr_);
   
      -- Check source id and initiate several variables
      IF ( source_id_ = 'CUSTOMER ORDER' ) THEN
         IF (order_id_ IS NOT NULL) THEN
            IF (exp_delivery_date_ IS NOT NULL) THEN
               cash_flow_text_ := Language_SYS.Translate_Constant(lu_name_,
                                                                  'CUSTORDNO1: Customer Order No: :P1, expected delivery :P2', 
                                                                  NULL, 
                                                                  order_id_,
                                                                  exp_delivery_date_);
            ELSE
               cash_flow_text_ := Language_SYS.Translate_Constant(lu_name_,
                                                                  'CUSTORDNO2: Customer Order No: :P1', 
                                                                  NULL, 
                                                                  order_id_);
            END IF;
         ELSIF (invoice_id_ IS NOT NULL) THEN
            cash_flow_text_ := Language_SYS.Translate_Constant(lu_name_,
                                                               'CUSTINVNO: Customer Invoice No: :P1', 
                                                               NULL, 
                                                               invoice_id_); 
         END IF;
         
         in_out_ := 'In';
      ELSE
         Error_Sys.Appl_General (lu_name_, 'INVSOURCEID: Order source :P1 is not implemented', source_id_);
      END IF;   

      cash_flow_date_ := installment_due_date_;
      
      IF (source_id_ = 'CUSTOMER ORDER') THEN
         $IF Component_Payled_SYS.INSTALLED $THEN
            payment_delay_ := NVL(Identity_Pay_Info_API.Get_Payment_Delay(company_, customer_no_, party_type_),0);
            
            Trace_SYS.message('Fetched payment_delay : '||payment_delay_);
            IF (NVL(payment_delay_,0) = 0) THEN
               payment_delay_ := 0;
            END IF;
            cash_flow_date_ := cash_flow_date_ + payment_delay_;
            Trace_SYS.message('Added payment_delay : '||to_char(cash_flow_date_,'YYYY-MM-DD'));
         $ELSE
            NULL;
         $END 
      END IF;
   
      IF (cash_flow_date_ < TRUNC(SYSDATE)) THEN
         include_date_ := FALSE;
      ELSE
         include_date_ := TRUE;
      END IF;    
      
      IF (include_date_) THEN
         -- It was decided not to call Cfa_Cash_Flow_Type_Status_API.Get_User_Defined_Status to avoid calling methods in FINCFA during collecting cash flow information. 
         finlib_number_list_ := Finance_Lib_API.Convert_Key_Pair_Msg_To_Array(Client_Sys.Get_Item_Value('TYPE_STATUS_MSG', attr_));
         user_def_cfa_status_ := Finance_Lib_API.Get_Value_From_Array(finlib_number_list_, row_state_);
         -- Determine internal/external
         int_ext_ := Identity_Invoice_Info_API.Get_Identity_Type_Db(company_, customer_no_, party_type_); 
         Trace_SYS.message('Fetched db value for identity type : '||int_ext_);
         IF ( NVL(int_ext_,' ') = ' ' ) THEN
            int_ext_ := 'External';
         ELSIF ( int_ext_ = 'EXTERN' ) THEN
            int_ext_ := 'External';
         ELSIF ( int_ext_ IN ('INTERN', 'INTERN_PARENT', 'INTERN_SISTER', 'INTERN_SUB')) THEN
            int_ext_ := 'Internal';
         END IF; 
         
         -- Put together cash flow text
         IF (source_id_ != 'CUSTOMER ORDER') THEN
            cash_flow_text_ := cash_flow_text_||order_id_;
         END IF;
      
         cash_flow_rec_ := NULL;
         cash_flow_rec_.company := company_;
         cash_flow_rec_.analyse_id := Client_Sys.Get_Item_Value('ANALYSE_ID', attr_);
         cash_flow_rec_.cash_flow_date := cash_flow_date_;
         cash_flow_rec_.cash_flow_amount := installment_curr_amount_;
         cash_flow_rec_.cash_flow_currency := currency_code_;
         cash_flow_rec_.cash_flow_status := user_def_cfa_status_;
         cash_flow_rec_.cash_flow_text := cash_flow_text_;
         cash_flow_rec_.counterpart_id := customer_no_;
         cash_flow_rec_.counterpart_name := customer_name_;
         cash_flow_rec_.account := account_no_;
         cash_flow_rec_.code_b := codeno_b_;
         cash_flow_rec_.code_c := codeno_c_;
         cash_flow_rec_.code_d := codeno_d_;
         cash_flow_rec_.code_e := codeno_e_;
         cash_flow_rec_.code_f := codeno_f_;
         cash_flow_rec_.code_g := codeno_g_;
         cash_flow_rec_.code_h := codeno_h_;
         cash_flow_rec_.code_i := codeno_i_;
         cash_flow_rec_.code_j := codeno_j_;
         cash_flow_rec_.cfa_internal_external := int_ext_;
         cash_flow_rec_.cfa_in_out := in_out_;
         cash_flow_rec_.source_id := source_id_;
         cash_flow_rec_.cash_flow_type_id := cash_flow_type_id_;
         cash_flow_rec_.type_status := row_state_;
           
         Cfa_Update_Utility_API.Load_Cfa_Data(cash_flow_rec_);
      END IF;
    
   $ELSE
      NULL;
   $END
END Handle_Load_Data___;


-- Get_Order_Charge_Amt___
--   To get the total charge amount and charge tax amount attached to the
--   customer [header] order passed.
PROCEDURE Get_Order_Charge_Amt___ (
   total_amount_     OUT NUMBER,
   total_tax_amount_ OUT NUMBER,
   company_          IN  VARCHAR2,
   order_no_         IN  VARCHAR2 )
IS
   -- Added condition not to retreive collect charge lines. 
   CURSOR get_order_charges(company_ IN VARCHAR2 ) IS
     SELECT ch.order_no,
            ch.sequence_no,
            ch.charge_amount * ch.charged_qty    charge_amount_ur, --unrounded
            ch.tax_code            vat_code
     FROM   customer_order_charge_tab ch
     WHERE  ch.invoiced_qty = 0
     AND    ch.company = company_
     AND    ch.order_no = order_no_
     AND    ch.collect = 'INVOICE';

   charge_amount_    NUMBER := 0;
   tax_amount_       NUMBER := 0;
BEGIN
   total_amount_ := 0;
   total_tax_amount_ := 0;
   FOR linerec_ IN get_order_charges(company_) LOOP
       charge_amount_ := linerec_.charge_amount_ur;
       total_amount_ := total_amount_ + NVL(charge_amount_,0);

       tax_amount_ := Customer_Order_Charge_API.Get_Total_Tax_Amount_Curr(linerec_.order_no, linerec_.sequence_no);
       total_tax_amount_ := total_tax_amount_ + NVL(tax_amount_,0);

   END LOOP;
END Get_Order_Charge_Amt___;


-- Get_Order_Line_Charge_Amt___
--   To get the total charge amount and charge tax amount attached to the
--   customer order line passed.
PROCEDURE Get_Order_Line_Charge_Amt___ (
   total_amount_     OUT NUMBER,
   total_tax_amount_ OUT NUMBER,
   rel_no_           IN  VARCHAR2,
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   company_          IN  VARCHAR2,
   line_item_no_     IN  NUMBER )
IS 
   CURSOR get_order_line_charges(company_ IN VARCHAR2 ) IS
     SELECT ch.order_no, ch.line_no, ch.rel_no, ch.line_item_no,
            ch.sequence_no,
            ch.charge_amount * ch.charged_qty    charge_amount_ur, --unrounded
            ch.tax_code            vat_code
     FROM   customer_order_charge_tab ch
     WHERE  ch.invoiced_qty = 0
     AND    ch.company = company_
     AND    ch.order_no = order_no_
     AND    ch.line_no = line_no_
     AND    ch.rel_no = rel_no_
     AND    ch.line_item_no = line_item_no_;

   charge_amount_    NUMBER := 0;
   tax_amount_       NUMBER := 0;
BEGIN
   total_amount_ := 0;
   total_tax_amount_ := 0;
   FOR linerec_ IN get_order_line_charges(company_) LOOP
       charge_amount_ := linerec_.charge_amount_ur;
       total_amount_ := total_amount_ + charge_amount_;

       tax_amount_ := Customer_Order_Charge_API.Get_Total_Tax_Amount_Curr(linerec_.order_no, linerec_.sequence_no);
       total_tax_amount_ := total_tax_amount_ + tax_amount_;

   END LOOP;
END Get_Order_Line_Charge_Amt___;


-- Handle_Prepaym_Invoices___
--   This method is used to get the prepayment invoice open amount.
PROCEDURE Handle_Prepaym_Invoices___ (
   curr_amt_            IN OUT NUMBER,
   company_             IN VARCHAR2,
   order_no_            IN VARCHAR2,
   prepay_deb_inv_type_ IN VARCHAR2,
   prepay_cre_inv_type_ IN VARCHAR2 )
IS   
BEGIN
   Out_Invoice_Util_Pub_API.Get_Co_Prepaym_Inv_Open_Amt(curr_amt_, company_, order_no_, prepay_deb_inv_type_, prepay_cre_inv_type_);   
END Handle_Prepaym_Invoices___;


-- Handle_Payment_Terms___
--   This procedure handles all payment terms installments.
PROCEDURE Handle_Payment_Terms___ (
   net_amount_to_reduce_ IN OUT NUMBER,
   default_attr_         IN     VARCHAR2,
   order_id_             IN     VARCHAR2,
   company_              IN     VARCHAR2,
   cfa_date_             IN     DATE,
   pay_term_id_          IN     VARCHAR2, 
   currency_code_        IN     VARCHAR2,
   total_net_amount_     IN     NUMBER,
   total_vat_amount_     IN     NUMBER,
   customer_no_          IN     VARCHAR2,
   customer_name_        IN     VARCHAR2,
   headerstate_          IN     VARCHAR2,
   account_no_           IN     VARCHAR2,
   codeno_b_             IN     VARCHAR2,
   codeno_c_             IN     VARCHAR2,
   codeno_d_             IN     VARCHAR2,
   codeno_e_             IN     VARCHAR2,
   codeno_f_             IN     VARCHAR2,
   codeno_g_             IN     VARCHAR2,  
   codeno_h_             IN     VARCHAR2,
   codeno_i_             IN     VARCHAR2,
   codeno_j_             IN     VARCHAR2)
IS
   installment_attr_        VARCHAR2(2000);
   attr_                    VARCHAR2(2000);
   name_                    VARCHAR2(30);      
   value_                   VARCHAR2(2000);
   ptr_                     NUMBER := NULL;
   installment_id_          NUMBER := 0;
   installment_curr_amount_ NUMBER;
   installment_due_date_    DATE;
   installment_end_         BOOLEAN;
BEGIN

   Client_SYS.Clear_Attr(installment_attr_);                                       

   -- Fetch in all payment terms installments in an attribute string.
   Payment_Term_API.Get_Installment_Data(installment_attr_, company_, customer_no_, 'CUSTOMER',
                                          pay_term_id_, currency_code_, total_net_amount_, 
                                          total_vat_amount_, cfa_date_);

   -- Loop through all payment terms installments.                                      
   WHILE (Client_SYS.Get_Next_From_Attr(installment_attr_, ptr_, name_, value_)) LOOP
       -- Unpack installment attributes.
       IF (name_ = 'INSTALLMENT_ID') THEN
          installment_id_  := Client_SYS.Attr_Value_To_Number(value_);
          installment_end_ := FALSE;
       ELSIF (name_ = 'DUE_DATE') THEN
          installment_due_date_ := Client_SYS.Attr_Value_To_Date(value_);
       ELSIF (name_ = 'CURR_AMOUNT') THEN
          installment_curr_amount_ := Client_SYS.Attr_Value_To_Number(value_);
          installment_end_         := TRUE;
       END IF;
       -- Load the Co line accessed.
       IF (installment_end_) THEN
          -- Decide the amount to reduce based on the installment percentage.
          IF (net_amount_to_reduce_ > 0) THEN
             IF (net_amount_to_reduce_ >= installment_curr_amount_ ) THEN
                net_amount_to_reduce_    := net_amount_to_reduce_ - installment_curr_amount_;
                installment_curr_amount_ := 0;
             ELSIF(net_amount_to_reduce_ < installment_curr_amount_ )THEN
                installment_curr_amount_ := installment_curr_amount_ - net_amount_to_reduce_;
                net_amount_to_reduce_    := 0;
             END IF;
          END IF;
          -- Dont show the CO line with 0 in the Cash flow data.
          IF (installment_curr_amount_ > 0 ) THEN     
             attr_ := default_attr_;

             Handle_Load_Data___( attr_,
                                  installment_due_date_,
                                  installment_curr_amount_,
                                  currency_code_,
                                  headerstate_,
                                  customer_no_,
                                  customer_name_,
                                  order_id_,
                                  account_no_,
                                  codeno_b_,
                                  codeno_c_,
                                  codeno_d_,
                                  codeno_e_,
                                  codeno_f_,
                                  codeno_g_,
                                  codeno_h_,
                                  codeno_i_,
                                  codeno_j_,
                                  NULL,
                                  cfa_date_ );
          END IF;
       END IF;
    END LOOP;
END Handle_Payment_Terms___;


-- Handle_Negative_Cash_Flow___
--   This procedure handles negative cash flow.
PROCEDURE Handle_Negative_Cash_Flow___ (
   net_amount_to_reduce_ IN OUT NUMBER,
   default_attr_         IN     VARCHAR2,
   order_no_             IN     VARCHAR2,
   company_              IN     VARCHAR2,
   contract_             IN     VARCHAR2,
   wanted_delivery_date_ IN     DATE,
   currency_code_        IN     VARCHAR2,
   customer_no_          IN     VARCHAR2,
   customer_name_        IN     VARCHAR2,
   headerstate_          IN     VARCHAR2,
   account_no_           IN     VARCHAR2,
   codeno_b_             IN     VARCHAR2,
   codeno_c_             IN     VARCHAR2,
   codeno_d_             IN     VARCHAR2,
   codeno_e_             IN     VARCHAR2,
   codeno_f_             IN     VARCHAR2,
   codeno_g_             IN     VARCHAR2,  
   codeno_h_             IN     VARCHAR2,
   codeno_i_             IN     VARCHAR2,
   codeno_j_             IN     VARCHAR2)
IS
   attr_                    VARCHAR2(2000);
   max_planned_del_date_    DATE;
   installment_due_date_    DATE;
   installment_curr_amount_ NUMBER := 0;

   CURSOR get_max_planned_del_date (order_no_ IN VARCHAR2 )IS
      SELECT MAX(planned_delivery_date)
      FROM   customer_order_line_tab
      WHERE  rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    line_item_no <= 0   
      AND    order_no = order_no_
      AND    rental = 'FALSE';
BEGIN

   attr_ := default_attr_;

   OPEN get_max_planned_del_date(order_no_);
   FETCH get_max_planned_del_date INTO max_planned_del_date_;
   CLOSE get_max_planned_del_date;

   IF (max_planned_del_date_ IS NOT NULL) THEN
      -- Assign max planned_delivery_date for the order lines connected to the order.
      installment_due_date_ := max_planned_del_date_;
   ELSE
      -- Assign current date if only charges exist with the order.
      installment_due_date_ := Site_API.Get_Site_Date(contract_);
   END IF;
   
   -- Set to a negative amount.
   installment_curr_amount_ := installment_curr_amount_ - net_amount_to_reduce_;
   
   -- Load the Special Co line.
   Handle_Load_Data___(attr_,
                       installment_due_date_,
                       installment_curr_amount_,
                       currency_code_,
                       headerstate_,
                       customer_no_,
                       customer_name_,
                       order_no_,
                       account_no_,
                       codeno_b_,
                       codeno_c_,
                       codeno_d_,
                       codeno_e_,
                       codeno_f_,
                       codeno_g_,
                       codeno_h_,
                       codeno_i_,
                       codeno_j_,
                       NULL,
                       wanted_delivery_date_ );
   
   net_amount_to_reduce_ := 0;
END Handle_Negative_Cash_Flow___;


-- Calc_Line_Or_Stage_Totals___
--   This procedure calculates total cash flow value for an order line or
--   a stage.
PROCEDURE Calc_Line_Or_Stage_Totals___ (
   total_sum_amount_           IN OUT NUMBER,
   total_net_amount_           IN OUT NUMBER,
   total_vat_amount_           IN OUT NUMBER,
   tot_line_charge_amount_     IN OUT NUMBER,
   tot_line_charge_tax_amount_ IN OUT NUMBER,
   company_                    IN     VARCHAR2,
   order_no_                   IN     VARCHAR2, 
   line_no_                    IN     VARCHAR2, 
   rel_no_                     IN     VARCHAR2, 
   line_item_no_               IN     NUMBER,
   sale_price_ur_              IN     NUMBER,
   sale_price_inc_tax_ur_      IN     NUMBER,   
   currency_rounding_          IN     NUMBER,
   discount_                   IN     NUMBER,
   order_discount_             IN     NUMBER,
   additional_discount_        IN     NUMBER,
   stage_percentage_           IN     NUMBER,
   include_charges_            IN     BOOLEAN )
IS

   sale_price_              NUMBER;
   sale_price_inc_tax_      NUMBER;
   discount_amount_         NUMBER;
   net_curr_amount_         NUMBER;
   vat_curr_amount_         NUMBER;
   sum_curr_amount_         NUMBER;
   line_charge_amount_      NUMBER;
   line_charge_tax_amount_  NUMBER;
   stages_total_percentage_ NUMBER; 
   line_tax_dom_amount_     NUMBER; 
   line_net_dom_amount_     NUMBER; 
   line_gross_dom_amount_   NUMBER;    
   gross_curr_amount_       NUMBER;   
   discount_amount_gross_   NUMBER;    

   -- Select the total percentage of the non invoiced staged billing lines in a CO line.
   CURSOR get_stages_total_percentage(order_no_     IN VARCHAR2,
                                      line_no_      IN VARCHAR2,
                                      rel_no_       IN VARCHAR2,
                                      line_item_no_ IN NUMBER ) IS
      SELECT SUM (total_percentage) stages_total_percentage
      FROM   order_line_staged_billing_tab
      WHERE  rowstate  IN ('Planned', 'Approved')
      AND    order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;

BEGIN

   sale_price_         := ROUND(sale_price_ur_, currency_rounding_ );
   sale_price_inc_tax_ := ROUND(sale_price_inc_tax_ur_, currency_rounding_); 
   discount_amount_    := ROUND((sale_price_ur_ -
                            (sale_price_ur_ *
                            ((100 - discount_)/100) * ((100 - (order_discount_ + additional_discount_))/100))),
                            currency_rounding_ );
   discount_amount_gross_    := ROUND((sale_price_inc_tax_ur_ -
                                    (sale_price_inc_tax_ur_ *
                                    ((100 - discount_)/100) * ((100 - (order_discount_ + additional_discount_))/100))),
                                    currency_rounding_ );                            
   net_curr_amount_     := sale_price_ - discount_amount_; 
   gross_curr_amount_   := sale_price_inc_tax_ - discount_amount_gross_;  
   
   Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                           line_net_dom_amount_, 
                                           line_gross_dom_amount_, 
                                           vat_curr_amount_, 
                                           net_curr_amount_, 
                                           gross_curr_amount_, 
                                           company_, 
                                           Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                           order_no_, 
                                           line_no_, 
                                           rel_no_, 
                                           line_item_no_,
                                           '*');  
   
   IF (stage_percentage_ IS NOT NULL) THEN
      -- Get the not invoiced stages total percentage value.
      OPEN get_stages_total_percentage(order_no_, line_no_, rel_no_, line_item_no_);
      FETCH get_stages_total_percentage INTO stages_total_percentage_;
      CLOSE get_stages_total_percentage;

      -- Get the percentage value of the stage.
      net_curr_amount_  := net_curr_amount_ * stage_percentage_ / NVL(stages_total_percentage_, 100);
      vat_curr_amount_  := vat_curr_amount_ * stage_percentage_ / NVL(stages_total_percentage_, 100);
   END IF;
   sum_curr_amount_  := net_curr_amount_ + vat_curr_amount_;
   
   total_sum_amount_ := total_sum_amount_ + sum_curr_amount_;
   total_net_amount_ := total_net_amount_ + net_curr_amount_;
   total_vat_amount_ := total_vat_amount_ + vat_curr_amount_;

   -- To make sure that charges are only added to the first expected approval date in the staged billing CO line.
   IF (include_charges_) THEN
      -- To get the line charge amount and total charge tax amount from charge lines connected with the CO line in access.
      Get_Order_Line_Charge_Amt___(line_charge_amount_,
                                   line_charge_tax_amount_,
                                   company_,
                                   order_no_,
                                   line_no_,
                                   rel_no_,
                                   line_item_no_ ) ;
   ELSE
      line_charge_amount_     := 0;
      line_charge_tax_amount_ := 0;
   END IF;
   
   tot_line_charge_amount_     := tot_line_charge_amount_ + line_charge_amount_;
   tot_line_charge_tax_amount_ := tot_line_charge_tax_amount_ + line_charge_tax_amount_;
END Calc_Line_Or_Stage_Totals___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Cfa_Cash_Flow_Data
--   Calculate expected cash flows for customer order lines not yet invoiced
--   and invoice items not yet posted.
--   Pass the result to the Cash Flow Analysis Module for further processing.
PROCEDURE Create_Cfa_Cash_Flow_Data (
   default_attr_ IN VARCHAR2 )
IS
   headrec_                    Customer_Order_API.public_rec;
   company_                    VARCHAR2(20);
   curr_amt_                    NUMBER := 0;
   net_amount_to_reduce_       NUMBER := 0;
   adv_meth_                   VARCHAR2(30);
   prepay_cre_inv_type_        VARCHAR2(30);
   prepay_deb_inv_type_        VARCHAR2(30);
   customer_rec_               Cust_Ord_Customer_API.Public_Rec;

   --  Fetch the CO headers with specified stauses.
   CURSOR get_order(company_ IN VARCHAR2 ) IS
      SELECT order_no
      FROM   CUSTOMER_ORDER_TAB
      WHERE  rowstate IN ('Planned','Blocked','Released', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
      AND    Site_API.Get_Company(contract) = company_;
BEGIN

   company_ := Client_SYS.Get_Item_Value('COMPANY', default_attr_);
   adv_meth_ := Company_Order_Info_API.Get_Prepayment_Inv_Method_db(company_);
   IF adv_meth_ = 'PREPAYMENT_BASED_INVOICE' THEN
      prepay_cre_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Cre_Inv_Type (company_);
      prepay_deb_inv_type_ := Company_Def_Invoice_Type_API.Get_Def_Co_Prepay_Deb_Inv_Type(company_);
   END IF;

   -- Load the unposted invoices
   Cash_Flow_For_Prel_Invoices___(default_attr_);
   FOR rec_ IN get_order(company_) LOOP
      headrec_ := Customer_Order_API.get(rec_.order_no);
      customer_rec_ := Cust_Ord_Customer_API.Get(headrec_.customer_no);
      IF NOT((customer_rec_.category = 'I') AND (company_ = Site_API.Get_Company(customer_rec_.acquisition_site))) THEN
         net_amount_to_reduce_ := 0;
         curr_amt_ := 0;

         IF (adv_meth_ = 'ADVANCE_INVOICE') THEN
            -- Get the curr amount from the unposted and posted advance invoices
            Handle_Adv_Invoices___(curr_amt_, company_, rec_.order_no );
         ELSE
            Handle_Prepaym_Invoices___(curr_amt_, company_, rec_.order_no, prepay_deb_inv_type_, prepay_cre_inv_type_ );
         END IF;

         IF (curr_amt_ IS NOT NULL) THEN
            net_amount_to_reduce_ := curr_amt_;
         END IF;
         -- Load the Co lines and Co Charge lines [attached] while reducing their CURR_AMOUNT and attched Co Charge lines.
         Cash_Flow_For_Order_Lines___(net_amount_to_reduce_, default_attr_, rec_.order_no, headrec_.contract);
      END IF;

   END LOOP;
END Create_Cfa_Cash_Flow_Data;



