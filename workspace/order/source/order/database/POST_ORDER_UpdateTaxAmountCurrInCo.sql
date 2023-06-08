-----------------------------------------------------------------------------
--
--  Filename      : POST_ORDER_UpdateTaxAmountCurrInCo.sql
--
--  Module        : ORDER
--
--  Purpose       : In customer order, tax details in cust_order_line_tax_lines_tab and cust_ord_charge_tax_lines_tab
--                  are always stored, not only in case of Sales Tax regime but also for VAT regime. Before App 9 tax
--                  amounts had been stored only in accounting currency but we added tax amount in order currency as well.
--                  It means that upgrade is necessary.
--
--                  For both cust_order_line_tax_lines_tab and cust_ord_charge_tax_lines_tab upgrade process
--                  of tax amount in order currency was split into three steps:
--                     1. upgrade of tax lines for orders in accounting currency,
--                     2. upgrade of tax lines not connected to rental lines in currency other than acc currency,
--                     3. upgrade of tax lines connected to rental lines in currency other than acc currency.
--
--                  Step 1. is implemented in a very simple way, as tax amount in order currency is equal
--                  to tax amount in accounting currency.
--
--                  Step 2. is much more complicated as we have to calculate tax_amount in order currency in the
--                  same way as it would be calculated in application. So we have to consider discounts and price
--                  including tax. If we implemented this upgrade as simple calculation of tax amount in order currency
--                  from tax amount in base currency we would get problems with roundings. It's because in case of
--                  customer order lines, according to existing core solution, tax amount in base currency was calculated
--                  as (temporary calculated) tax amount in order currency * currency rate and then rounded. Now we need to
--                  find this temporary calculated tax amount in order currency. So we should not just divide
--                  existing tax amount in base currency by currency rate and then round. In case of customer order
--                  charges another solution is required as tax amounts are calculated in a different way than in customer order lines.
--                  If we want to calculate tax amount, we should first calculate its base in respective currency.
--                  So actually calculated tax amount in base currency should not be a base for calculation of tax amount in order currency.
--
--                  Step 3. is again implemented in a quite simple way as we agreed that in case of rental lines "fully proper"
--                  calculation would be very complicated. So in this case we calculate tax amount in order currency directly from
--                  tax amount in base currency.
--
--
--  Date           Sign    History
--  ------------   ------  --------------------------------------------------
--  140714         SlKaPl  Created.
--  ------------   ------  --------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Timestamp_1');
PROMPT Starting POST_ORDER_UpdateTaxAmountCurrInCo.SQL

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Timestamp_2');
PROMPT Update new column TAX_AMOUNT_CURR in CUST_ORDER_LINE_TAX_LINES_TAB - the first step
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') THEN
      -- The first step - if order currency = accounting currecy then set tax_amount_curr = tax_amount '
      stmt_ := 'BEGIN  '||
               '   UPDATE cust_order_line_tax_lines_tab coltl '||
               '   SET    tax_amount_curr = tax_amount '||
               '   WHERE  tax_amount IS NOT NULL '||
               '   AND    tax_amount_curr IS NULL '||
               '   AND    EXISTS (SELECT 1 '||
               '                   FROM   company_finance_tab cf, '||
               '                         customer_order_tab co '||
               '                   WHERE  coltl.company = cf.company '||
               '                   AND    cf.currency_code = co.currency_code '||
               '                   AND    co.order_no = coltl.order_no '||
               '                 ); '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Timestamp_3');
PROMPT Update new column TAX_AMOUNT_CURR in CUST_ORDER_LINE_TAX_LINES_TAB - the second step
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') THEN
      -- The second step - all customer orders defined for currency different than accounting currency but not rental lines
      stmt_ := 'DECLARE '||
                  'CURSOR get_line IS '||
                     'SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, col.buy_qty_due, col.price_conv_factor, col.sale_unit_price, col.unit_price_incl_tax, '||
                            'col.additional_discount, col.order_discount, '||
                            'co.contract, co.currency_code, co.use_price_incl_tax '||
                     'FROM   customer_order_tab co, '||
                            'customer_order_line_tab col '||
                     'WHERE  co.order_no = col.order_no '||
                     'AND    col.rental = ''FALSE'' '||
                     'AND    EXISTS (SELECT 1 '||
                                    'FROM   cust_order_line_tax_lines_tab coltl '||
                                    'WHERE  col.order_no = coltl.order_no '||
                                    'AND    col.line_no = coltl.line_no '||
                                    'AND    col.rel_no = coltl.rel_no '||
                                    'AND    col.line_item_no = coltl.line_item_no '||
                                    'AND    coltl.tax_amount IS NOT NULL '||
                                    'AND    coltl.tax_amount_curr IS NULL); '||

                  'CURSOR get_currency_rounding (contract_         VARCHAR2, '||
                                                'currency_code_    VARCHAR2) IS '||
                     'SELECT currency_rounding '||
                     'FROM   currency_code_tab cc, '||
                            'site_tab s '||
                     'WHERE  s.contract = contract_ '||
                     'AND    s.company = cc.company '||
                     'AND    cc.currency_code = currency_code_; '||

                  'CURSOR get_total_percentage (order_no_       VARCHAR2,  '||
                                               'line_no_        VARCHAR2, '||
                                               'rel_no_         VARCHAR2, '||
                                               'line_item_no_   VARCHAR2) IS '||
                     'SELECT SUM(NVL(tax_percentage,0)) '||
                     'FROM   cust_order_line_tax_lines_tab '||
                     'WHERE  order_no = order_no_ '||
                     'AND    line_no = line_no_ '||
                     'AND    rel_no = rel_no_ '||
                     'AND    line_item_no = line_item_no_; '||

                  'rec_no_                    NUMBER := 0; '||
                  'prev_rec_                  get_line%ROWTYPE; '||
                  'currency_rounding_         NUMBER; '||
                  'total_amount_              NUMBER; '||
                  'line_discount_amount_      NUMBER; '||
                  'add_discount_amount_       NUMBER; '||
                  'order_discount_amount_     NUMBER; '||
                  'total_net_amount_          NUMBER; '||
                  'total_gross_amount_        NUMBER; '||
                  'total_amount_excl_disc_    NUMBER; '||
                  'total_amount_excl_tax_     NUMBER; '||
                  'total_percentage_          NUMBER; '||
                  'line_disc_amount_excl_tax_ NUMBER; '||
                  'total_tax_amount_          NUMBER; '||

               'BEGIN '||
                  'FOR rec_ IN get_line LOOP '||
                     'rec_no_ := rec_no_ + 1; '||
                     -- set currency rounding, check currency code
                     'IF rec_no_ = 1 OR '||
                        'prev_rec_.contract != rec_.contract OR '||
                        'prev_rec_.currency_code != rec_.currency_code '||
                     'THEN '||
                        'OPEN get_currency_rounding (rec_.contract, '||
                                                    'rec_.currency_code); '||
                        'FETCH get_currency_rounding INTO currency_rounding_; '||
                        'CLOSE get_currency_rounding; '||
                     'END IF; '||
                     'line_discount_amount_ := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(rec_.order_no, '||
                                                                                                   'rec_.line_no, '||
                                                                                                   'rec_.rel_no, '||
                                                                                                   'rec_.line_item_no, '||
                                                                                                   'rec_.buy_qty_due, '||
                                                                                                   'rec_.price_conv_factor, '||
                                                                                                   'currency_rounding_); '||
                     'OPEN get_total_percentage (rec_.order_no, '||
                                                'rec_.line_no, '||
                                                'rec_.rel_no, '||
                                                'rec_.line_item_no); '||
                     'FETCH get_total_percentage INTO total_percentage_; '||
                     'CLOSE get_total_percentage; '||

                     'IF rec_.use_price_incl_tax = ''TRUE'' THEN '||
                        -- calculate total tax amount by substracting net amount (without taxes and discounts) from amount with taxes but without discounts
                        'IF total_percentage_ != 0 THEN '||
                           'line_disc_amount_excl_tax_ := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(rec_.order_no,  '||
                                                                                                              'rec_.line_no, '||
                                                                                                              'rec_.rel_no,  '||
                                                                                                              'rec_.line_item_no, '||
                                                                                                              'rec_.buy_qty_due, '||
                                                                                                              'rec_.price_conv_factor, '||
                                                                                                              'currency_rounding_, '||
                                                                                                              'total_percentage_); '||

                           'total_gross_amount_ := rec_.buy_qty_due * rec_.price_conv_factor * rec_.unit_price_incl_tax * 1;  '||
                           'total_amount_excl_tax_ := ROUND(total_gross_amount_ / ((total_percentage_/100) + 1), currency_rounding_); '||
                           'add_discount_amount_ := ROUND(((total_gross_amount_ - line_discount_amount_) * (rec_.additional_discount / 100)), currency_rounding_); '||
                           'order_discount_amount_ := ROUND(((total_gross_amount_ - line_discount_amount_) * (rec_.order_discount / 100)), currency_rounding_); '||
                           'total_gross_amount_ := ROUND(total_gross_amount_, currency_rounding_); '||
                           'total_amount_excl_disc_ := total_gross_amount_ - line_discount_amount_ - add_discount_amount_ - order_discount_amount_; '||
                           'total_net_amount_ := total_amount_excl_tax_ - line_disc_amount_excl_tax_ - ROUND(add_discount_amount_/((total_percentage_/100)+1), currency_rounding_) - ROUND(order_discount_amount_/((total_percentage_/100)+1), currency_rounding_); '||
                           'total_tax_amount_ := total_amount_excl_disc_ - total_net_amount_; '||

                           'UPDATE cust_order_line_tax_lines_tab coltl '||
                           'SET    tax_amount_curr = ROUND((total_tax_amount_/total_percentage_) * tax_percentage, currency_rounding_) '||
                           'WHERE  tax_amount IS NOT NULL '||
                           'AND    tax_amount_curr IS NULL '||
                           'AND    order_no = rec_.order_no '||
                           'AND    line_no = rec_.line_no '||
                           'AND    rel_no = rec_.rel_no '||
                           'AND    line_item_no = rec_.line_item_no; '||
                        'ELSE '||
                           'UPDATE cust_order_line_tax_lines_tab coltl '||
                           'SET    tax_amount_curr = 0 '||
                           'WHERE  tax_amount IS NOT NULL '||
                           'AND    tax_amount_curr IS NULL '||
                           'AND    order_no = rec_.order_no '||
                           'AND    line_no = rec_.line_no '||
                           'AND    rel_no = rec_.rel_no '||
                           'AND    line_item_no = rec_.line_item_no; '||
                        'END IF; '||
                     'ELSE '||
                        'IF total_percentage_ != 0 THEN '||
                           -- calculate net amount for each order line
                           'total_amount_ := rec_.buy_qty_due * rec_.price_conv_factor * rec_.sale_unit_price * 1; '||

                           'add_discount_amount_ := ROUND(((total_amount_ - line_discount_amount_) * (rec_.additional_discount / 100)), currency_rounding_); '||
                           'order_discount_amount_ := ROUND(((total_amount_ - line_discount_amount_) * (rec_.order_discount / 100)), currency_rounding_); '||
                           'total_amount_ := ROUND(total_amount_, currency_rounding_); '||
                           'total_net_amount_ := total_amount_ - line_discount_amount_ - add_discount_amount_ - order_discount_amount_; '||

                           'UPDATE cust_order_line_tax_lines_tab coltl '||
                           'SET    tax_amount_curr = ROUND(total_net_amount_ * tax_percentage / 100, currency_rounding_) '||
                           'WHERE  tax_amount IS NOT NULL '||
                           'AND    tax_amount_curr IS NULL '||
                           'AND    order_no = rec_.order_no '||
                           'AND    line_no = rec_.line_no '||
                           'AND    rel_no = rec_.rel_no '||
                           'AND    line_item_no = rec_.line_item_no; '||
                        'ELSE '||
                           'UPDATE cust_order_line_tax_lines_tab coltl '||
                           'SET    tax_amount_curr = 0 '||
                           'WHERE  tax_amount IS NOT NULL '||
                           'AND    tax_amount_curr IS NULL '||
                           'AND    order_no = rec_.order_no '||
                           'AND    line_no = rec_.line_no '||
                           'AND    rel_no = rec_.rel_no '||
                           'AND    line_item_no = rec_.line_item_no; '||
                        'END IF; '||
                     'END IF; '||
                     'prev_rec_ := rec_; '||
                  'END LOOP; '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Timestamp_4');
PROMPT Update new column TAX_AMOUNT_CURR in CUST_ORDER_LINE_TAX_LINES_TAB - the third step
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') THEN
      -- The third step - update for order rental lines
      stmt_ := 'BEGIN '||
                  'UPDATE cust_order_line_tax_lines_tab coltl '||
                  'SET  tax_amount_curr = ROUND(tax_amount / (SELECT currency_rate '||
                                                             'FROM   customer_order_line_tab col '||
                                                             'WHERE  coltl.order_no = col.order_no '||
                                                             'AND    coltl.line_no = col.line_no '||
                                                             'AND    coltl.rel_no = col.rel_no '||
                                                             'AND    coltl.line_item_no = col.line_item_no), (SELECT currency_rounding '||
                                                                                                             'FROM   currency_code_tab cc, '||
                                                                                                                    'customer_order co '||
                                                                                                             'WHERE  coltl.company = cc.company '||
                                                                                                             'AND    coltl.order_no = co.order_no '||
                                                                                                             'AND    cc.currency_code = co.currency_code)) '||
                  'WHERE  tax_amount IS NOT NULL '||
                  'AND    tax_amount_curr IS NULL '||
                  'AND    EXISTS (SELECT 1  '||
                                 'FROM   customer_order_line_tab col '||
                                 'WHERE  coltl.order_no = col.order_no '||
                                 'AND    coltl.line_no = col.line_no '||
                                 'AND    coltl.rel_no = col.rel_no '||
                                 'AND    coltl.line_item_no = col.line_item_no '||
                                 'AND    col.rental = ''TRUE''); '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Timestamp_5');
PROMPT Update new column TAX_AMOUNT_CURR in CUST_ORD_CHARGE_TAX_LINES_TAB - the first step
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') THEN
      -- The first step - if order currency = accounting currecy then set tax_amount_curr = tax_amount
      stmt_ := 'BEGIN '||
                  'UPDATE cust_ord_charge_tax_lines_tab coctl  '||
                  'SET    tax_amount_curr = tax_amount  '||
                  'WHERE  tax_amount IS NOT NULL  '||
                  'AND    tax_amount_curr IS NULL  '||
                  'AND    EXISTS (SELECT 1  '||
                                  'FROM   company_finance_tab cf,  '||
                                         'customer_order_tab co  '||
                                  'WHERE  coctl.company = cf.company  '||
                                  'AND    cf.currency_code = co.currency_code  '||
                                  'AND    co.order_no = coctl.order_no  '||
                                ');  '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Timestamp_6');
PROMPT Update new column TAX_AMOUNT_CURR in CUST_ORD_CHARGE_TAX_LINES_TAB - the second step
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') THEN
      -- The second step - all customer orders defined for currency different than accounting currency but not charges connected to rental lines '||
      stmt_ := 'DECLARE '||
                  'CURSOR get_charge IS '||
                     'SELECT coc.order_no, coc.sequence_no, coc.charge_amount, coc.charge_amount_incl_tax, coc.charge, coc.charged_qty, coc.charge_percent_basis, '||
                            'coc.line_no, coc.rel_no, coc.line_item_no, '||
                            'co.contract, co.currency_code, co.use_price_incl_tax  '||
                     'FROM   customer_order_tab co,  '||
                            'customer_order_charge_tab coc '||
                     'WHERE  co.order_no = coc.order_no '||
                     'AND    EXISTS (SELECT 1 '||
                                    'FROM   cust_ord_charge_tax_lines_tab coctl '||
                                    'WHERE  coc.order_no = coctl.order_no '||
                                    'AND    coc.sequence_no = coctl.sequence_no '||
                                    'AND    coctl.tax_amount IS NOT NULL '||
                                    'AND    coctl.tax_amount_curr IS NULL) '||
                     'AND    NOT (    coc.charge_amount IS NULL '||
                                 'AND coc.charge_amount_incl_tax IS NULL '||
                                 'AND coc.charge_percent_basis IS NULL '||
                                 'AND EXISTS (SELECT 1  '||
                                             'FROM   customer_order_line_tab col '||
                                             'WHERE  coc.order_no = col.order_no '||
                                             'AND    nvl(coc.line_no, col.line_no)  = col.line_no '||
                                             'AND    nvl(coc.rel_no, col.rel_no) = col.rel_no '||
                                             'AND    nvl(coc.line_item_no, col.line_item_no) = col.line_item_no '||
                                             'AND    col.rental = ''TRUE'') '||
                                ');  '||

                  'CURSOR get_currency_rounding (contract_         VARCHAR2, '||
                                                'currency_code_    VARCHAR2) IS '||
                     'SELECT currency_rounding '||
                     'FROM   currency_code_tab cc, '||
                            'site_tab s '||
                     'WHERE  s.contract = contract_ '||
                     'AND    s.company = cc.company '||
                     'AND    cc.currency_code = currency_code_; '||

                  'CURSOR get_total_percentage (order_no_    VARCHAR2,  '||
                                               'sequence_no_ NUMBER) IS '||
                     'SELECT SUM(NVL(tax_percentage,0)) '||
                     'FROM   cust_ord_charge_tax_lines_tab '||
                     'WHERE  order_no = order_no_ '||
                     'AND    sequence_no = sequence_no_; '||

                  'rec_no_                    NUMBER := 0; '||
                  'prev_rec_                  get_charge%ROWTYPE; '||
                  'currency_rounding_         NUMBER; '||
                  'total_percentage_          NUMBER; '||
                  'total_charged_amount_      NUMBER; '||
                  'total_chrg_amt_incl_tax_   NUMBER; '||

                  'FUNCTION Get_Line_Total ( '||
                     'order_no_          IN VARCHAR2, '||
                     'line_no_           IN VARCHAR2, '||
                     'rel_no_            IN VARCHAR2, '||
                     'line_item_no_      IN NUMBER, '||
                     'currency_rounding_ IN NUMBER, '||
                     'price_incl_tax_    IN VARCHAR2) RETURN NUMBER '||
                  'IS '||
                     'CURSOR get_total IS '||
                        'SELECT buy_qty_due, price_conv_factor, sale_unit_price, unit_price_incl_tax, '||
                               'discount, order_discount, additional_discount '||
                        'FROM   customer_order_line_tab '||
                        'WHERE  order_no = order_no_ '||
                        'AND    line_no = line_no_ '||
                        'AND    rel_no = rel_no_ '||
                        'AND    line_item_no = line_item_no_; '||

                     'rec_ get_total%ROWTYPE; '||

                     'total_amount_           NUMBER; '||
                     'line_discount_amount_   NUMBER; '||
                     'add_discount_amount_    NUMBER; '||
                     'order_discount_amount_  NUMBER; '||
                     'return_amount_          NUMBER; '||
                  'BEGIN '||
                     -- calculate net amount for order lines without price including tax and gross amount for order lines with price including tax
                     'OPEN get_total; '||
                     'FETCH get_total INTO rec_; '||
                     'CLOSE get_total; '||

                     'line_discount_amount_ := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, '||
                                                                                                   'line_no_, '||
                                                                                                   'rel_no_, '||
                                                                                                   'line_item_no_, '||
                                                                                                   'rec_.buy_qty_due,  '||
                                                                                                   'rec_.price_conv_factor, '||
                                                                                                   'currency_rounding_); '||

                     'IF price_incl_tax_ = ''TRUE'' THEN '||
                        'total_amount_ := rec_.buy_qty_due * rec_.price_conv_factor * rec_.sale_unit_price; '||
                     'ELSE '||
                        'total_amount_ := rec_.buy_qty_due * rec_.price_conv_factor * rec_.unit_price_incl_tax; '||
                     'END IF; '||

                     'add_discount_amount_ := ROUND(((total_amount_ - line_discount_amount_) * (rec_.additional_discount / 100)), currency_rounding_); '||
                     'order_discount_amount_ := ROUND(((total_amount_ - line_discount_amount_) * (rec_.order_discount / 100)), currency_rounding_); '||
                     'total_amount_ := ROUND(total_amount_, currency_rounding_); '||
                     'return_amount_ := total_amount_ - line_discount_amount_ - add_discount_amount_ - order_discount_amount_; '||

                     'RETURN return_amount_; '||
                  'END Get_Line_Total; '||


                  'FUNCTION Get_Sale_Total ( '||
                     'order_no_          IN VARCHAR2, '||
                     'line_no_           IN VARCHAR2, '||
                     'rel_no_            IN VARCHAR2, '||
                     'line_item_no_      IN NUMBER, '||
                     'currency_rounding_ IN NUMBER, '||
                     'price_incl_tax_    IN VARCHAR2) RETURN NUMBER '||
                  'IS '||
                     'CURSOR get_lines IS '||
                        'SELECT line_no, rel_no, line_item_no  '||
                        'FROM   CUSTOMER_ORDER_LINE_TAB '||
                        'WHERE  order_no = order_no_ '||
                        'AND    rowstate != ''Cancelled'' '||
                        'AND    line_item_no <= 0; '||

                     'sale_total_ NUMBER := 0; '||
                  'BEGIN '||
                     'IF line_no_ IS NULL THEN '||
                        'FOR rec_ IN get_lines LOOP '||
                           'sale_total_ := sale_total_ + Get_Line_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, currency_rounding_, price_incl_tax_); '||
                        'END LOOP; '||
                     'ELSE '||
                        'sale_total_ := Get_Line_Total(order_no_, line_no_, rel_no_, line_item_no_, currency_rounding_, price_incl_tax_); '||
                     'END IF; '||

                     'RETURN sale_total_; '||
                  'END Get_Sale_Total; '||

               'BEGIN '||
                  'FOR rec_ IN get_charge LOOP '||
                     'rec_no_ := rec_no_ + 1;  '||

                     -- set currency rounding, check currency code
                     'IF rec_no_ = 1 OR  '||
                        'prev_rec_.contract != rec_.contract OR  '||
                        'prev_rec_.currency_code != rec_.currency_code '||
                     'THEN '||
                        'OPEN get_currency_rounding (rec_.contract, '||
                                                    'rec_.currency_code); '||
                        'FETCH get_currency_rounding INTO currency_rounding_; '||
                        'CLOSE get_currency_rounding; '||
                     'END IF;  '||

                     'OPEN get_total_percentage (rec_.order_no, '||
                                                'rec_.sequence_no); '||
                     'FETCH get_total_percentage INTO total_percentage_; '||
                     'CLOSE get_total_percentage; '||

                     'IF rec_.use_price_incl_tax = ''TRUE'' THEN '||
                        'IF total_percentage_ != 0 THEN '||
                           'IF (rec_.charge_amount_incl_tax IS NULL) THEN '||
                              'IF rec_.charge_percent_basis IS NULL THEN '||
                                 'total_chrg_amt_incl_tax_ := rec_.charge * Get_Sale_Total(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, currency_rounding_, ''TRUE'') / 100; '||
                              'ELSE '||
                                 'total_chrg_amt_incl_tax_ := rec_.charge * rec_.charge_percent_basis * rec_.charged_qty / 100; '||
                              'END IF; '||
                           'ELSE '||
                              'total_chrg_amt_incl_tax_ := rec_.charge_amount_incl_tax * rec_.charged_qty; '||
                           'END IF; '||

                           'total_chrg_amt_incl_tax_ := ROUND(NVL(total_chrg_amt_incl_tax_, 0), currency_rounding_); '||

                           'UPDATE cust_ord_charge_tax_lines_tab coltl '||
                           'SET    tax_amount_curr = total_chrg_amt_incl_tax_ * tax_percentage / (100 +  total_percentage_) '||
                           'WHERE  tax_amount IS NOT NULL '||
                           'AND    tax_amount_curr IS NULL '||
                           'AND    order_no = rec_.order_no '||
                           'AND    sequence_no = rec_.sequence_no; '||

                        'ELSE '||
                           'UPDATE cust_ord_charge_tax_lines_tab coltl '||
                           'SET    tax_amount_curr = 0 '||
                           'WHERE  tax_amount IS NOT NULL '||
                           'AND    tax_amount_curr IS NULL '||
                           'AND    order_no = rec_.order_no '||
                           'AND    sequence_no = rec_.sequence_no; '||
                        'END IF; '||
                     'ELSE '||
                        'IF total_percentage_ != 0 THEN '||
                           'IF (rec_.charge_amount IS NULL) THEN '||
                              'IF rec_.charge_percent_basis IS NULL THEN '||
                                 'total_charged_amount_ := rec_.charge * Get_Sale_Total(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, currency_rounding_, ''FALSE'') / 100; '||
                              'ELSE '||
                                 'total_charged_amount_ := rec_.charge * rec_.charge_percent_basis * rec_.charged_qty / 100; '||
                              'END IF; '||
                           'ELSE '||
                              'total_charged_amount_ := rec_.charge_amount * rec_.charged_qty; '||
                           'END IF; '||

                           'total_charged_amount_ := ROUND(NVL(total_charged_amount_, 0), currency_rounding_);   '||

                           'UPDATE cust_ord_charge_tax_lines_tab coltl '||
                              'SET    tax_amount_curr = total_charged_amount_ * tax_percentage / 100 '||
                              'WHERE  tax_amount IS NOT NULL '||
                              'AND    tax_amount_curr IS NULL '||
                              'AND    order_no = rec_.order_no '||
                              'AND    sequence_no = rec_.sequence_no; '||
                        'ELSE '||
                           'UPDATE cust_ord_charge_tax_lines_tab coltl '||
                           'SET    tax_amount_curr = 0 '||
                           'WHERE  tax_amount IS NOT NULL '||
                           'AND    tax_amount_curr IS NULL '||
                           'AND    order_no = rec_.order_no '||
                           'AND    sequence_no = rec_.sequence_no; '||
                        'END IF; '||
                     'END IF; '||

                     'prev_rec_ := rec_; '||
                  'END LOOP; '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Timestamp_7');
PROMPT Update new column TAX_AMOUNT_CURR in CUST_ORD_CHARGE_TAX_LINES_TAB - the third step
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') THEN
      -- The third step - update for charges connected to orders with order rental lines or to order rental lines
      stmt_ := 'BEGIN '||
                  'UPDATE cust_ord_charge_tax_lines_tab coctl '||
                  'SET  tax_amount_curr = ROUND(tax_amount / (SELECT currency_rate '||
                                                             'FROM   customer_order_charge_tab coc '||
                                                             'WHERE  coctl.order_no = coc.order_no '||
                                                             'AND    coctl.sequence_no = coc.sequence_no), (SELECT currency_rounding '||
                                                                                                           'FROM   currency_code_tab cc, '||
                                                                                                                  'customer_order co '||
                                                                                                           'WHERE  coctl.company = cc.company '||
                                                                                                           'AND    coctl.order_no = co.order_no '||
                                                                                                           'AND    cc.currency_code = co.currency_code)) '||
                  'WHERE  tax_amount IS NOT NULL '||
                  'AND    tax_amount_curr IS NULL '||
                  'AND    EXISTS (SELECT 1  '||
                                 'FROM   customer_order_line_tab col, '||
                                        'customer_order_charge_tab coc '||
                                 'WHERE  coctl.order_no = coc.order_no '||
                                 'AND    coctl.sequence_no = coc.sequence_no '||
                                 'AND    coc.charge_amount IS NULL '||
                                 'AND    coc.charge_amount_incl_tax IS NULL '||
                                 'AND    coc.charge_percent_basis IS NULL '||
                                 'AND    coc.order_no = col.order_no '||
                                 'AND    nvl(coc.line_no, col.line_no)  = col.line_no    '||
                                 'AND    nvl(coc.rel_no, col.rel_no) = col.rel_no '||
                                 'AND    nvl(coc.line_item_no, col.line_item_no) = col.line_item_no '||
                                 'AND    col.rental = ''TRUE''); '||
            'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

PROMPT Finished POST_ORDER_UpdateTaxAmountCurrInCo.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInCo.sql','Done');

