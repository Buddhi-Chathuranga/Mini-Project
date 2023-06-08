-----------------------------------------------------------------------------
--
--  Filename      : POST_ORDER_UpdateTaxAmountCurrInRma.sql
--
--  Module        : ORDER
--
--  Purpose       : In RMA tax details are stored in rma_line_tax_lines_tab and rma_charge_tax_lines_tab.
--                  Before App 9 tax amounts had been stored only in accounting currency but we added tax amount
--                  in rma currency as well. It means that upgrade is necessary.
--
--                  We have to calculate tax_amount in rma currency in the same way as it would be calculated in the application.
--                  So we have to consider price including tax as well. If we implemented this upgrade as simple calculation
--                  of tax amount in rma currency from tax amount in base currency we would get problems with roundings.
--                  It's because in case of rma lines, according to existing core solution, tax amount in base currency
--                  is calculated as (temporary calculated) tax amount in rma currency * currency rate and then rounded.
--                  So we need to find this temporary calculated tax amount in rma currency. In case of rma charges
--                  another solution is used. If we want to calculate tax amount, we should first calculate its base
--                  in respective currency. In this case it means we have to do the whole calculation in rma currency
--                  as it will be implemented in core beginning from App9.
--
--
--  Date           Sign    History
--  ------------   ------  --------------------------------------------------
--  1401020        SlKaPl  Created.
--  ------------   ------  --------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInRma.sql','Timestamp_1');
PROMPT Starting POST_ORDER_UpdateTaxAmountCurrInRma.sql

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInRma.sql','Timestamp_2');
PROMPT Update new column TAX_AMOUNT_CURR in RMA_LINE_TAX_LINES_TAB

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('RMA_LINE_TAX_LINES_TAB') THEN
      stmt_ := 'BEGIN '||
                  'UPDATE rma_line_tax_lines_tab rltl '||
                  'SET    tax_amount_curr =   CASE '||
                                             'WHEN (1 = (SELECT 1 '||
                                                        'FROM   company_finance_tab cf, '||
                                                               'return_material_tab rm '||
                                                        'WHERE  rltl.company = cf.company '||
                                                        'AND    cf.currency_code = rm.currency_code '||
                                                        'AND    rm.rma_no = rltl.rma_no)) '||
                                             'THEN '||
                                                'tax_amount '||
                                             'ELSE '||
                                                'CASE '||
                                                   'WHEN (1 = (SELECT 1 '||
                                                              'FROM   return_material_tab rm '||
                                                              'WHERE  rltl.rma_no = rm.rma_no '||
                                                              'AND    rm.use_price_incl_tax = ''FALSE'')) '||
                                                   'THEN '||
                                                      'ROUND(rltl.tax_percentage / 100 * (SELECT rml.qty_to_return * rml.price_conv_factor * rml.sale_unit_price '||
                                                                                         'FROM   return_material_line_tab rml '||
                                                                                         'WHERE  rltl.rma_no = rml.rma_no '||
                                                                                         'AND    rltl.rma_line_no = rml.rma_line_no), '||
                                                            '(SELECT cc.currency_rounding '||
                                                             'FROM   currency_code_tab cc, '||
                                                                    'return_material_tab rm '||
                                                             'WHERE  rltl.company = cc.company '||
                                                             'AND    cc.currency_code = rm.currency_code '||
                                                             'AND    rm.rma_no = rltl.rma_no) '||
                                                           ') '||
                                                   'ELSE '||
                                                      'ROUND(rltl.tax_percentage * (SELECT rml.qty_to_return * rml.price_conv_factor * rml.unit_price_incl_tax '||
                                                                                   'FROM   return_material_line_tab rml '||
                                                                                   'WHERE  rltl.rma_no = rml.rma_no '||
                                                                                   'AND    rltl.rma_line_no = rml.rma_line_no) '||
                                                                                '/ (NVL((SELECT SUM(tax_percentage) '||
                                                                                        'FROM   rma_line_tax_lines_tab rltl1 '||
                                                                                        'WHERE  rltl1.rma_no = rltl.rma_no '||
                                                                                        'AND    rltl1.rma_line_no = rltl.rma_line_no), 0) + 100), '||
                                                            '(SELECT cc.currency_rounding '||
                                                             'FROM   currency_code_tab cc, '||
                                                                    'return_material_tab rm '||
                                                             'WHERE  rltl.company = cc.company '||
                                                             'AND    cc.currency_code = rm.currency_code '||
                                                             'AND    rm.rma_no = rltl.rma_no) '||
                                                           ') '||
                                                   'END '||
                                             'END '||
                  'WHERE  tax_amount IS NOT NULL '||
                  'AND    tax_amount_curr IS NULL; '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInRma.sql','Timestamp_3');
PROMPT Update new column TAX_AMOUNT_CURR in RMA_CHARGE_TAX_LINES_TAB
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('RMA_CHARGE_TAX_LINES_TAB') THEN
      stmt_ := 'BEGIN '||
                  'UPDATE rma_charge_tax_lines_tab rctl '||
                  'SET    tax_amount_curr =   CASE '||
                                                'WHEN (1 = (SELECT 1 '||
                                                           'FROM   company_finance_tab cf, '||
                                                                  'return_material_tab rm '||
                                                           'WHERE  rctl.company = cf.company '||
                                                           'AND    cf.currency_code = rm.currency_code '||
                                                           'AND    rm.rma_no = rctl.rma_no)) '||
                                                'THEN '||
                                                   'tax_amount '||
                                                'ELSE '||
                                                   'CASE '||
                                                      'WHEN (1 = (SELECT 1 '||
                                                                 'FROM   return_material_tab rm '||
                                                                 'WHERE  rctl.rma_no = rm.rma_no '||
                                                                 'AND    rm.use_price_incl_tax = ''FALSE'')) '||
                                                      'THEN '||
                                                         'ROUND(rctl.tax_percentage / 100 * (SELECT CASE  '||
                                                                                                'WHEN (rmc.charge_amount IS NOT NULL) THEN  '||
                                                                                                   'rmc.charge_amount * rmc.charged_qty '||
                                                                                                'ELSE '||
                                                                                                   'rmc.charged_qty * rmc.charge / 100 * '||
                                                                                                   'CASE '||
                                                                                                      'WHEN (rmc.charge_percent_basis IS NOT NULL) THEN '||
                                                                                                         'rmc.charge_percent_basis '||
                                                                                                      'ELSE '||
                                                                                                         'nvl((SELECT SUM(rml.qty_to_return * rml.price_conv_factor * rml.sale_unit_price) '||
                                                                                                                    'FROM   return_material_line_tab rml '||
                                                                                                                    'WHERE  rctl.rma_no = rml.rma_no '||
                                                                                                                    'AND    rml.rowstate != ''Denied''), 0) * '||
                                                                                                         'CASE '||
                                                                                                            'WHEN (rmc.sequence_no IS NOT NULL) THEN '||
                                                                                                               'CASE '||
                                                                                                                  'WHEN (1 = (SELECT 1 '||
                                                                                                                             'FROM   customer_order_charge_tab coc '||
                                                                                                                             'WHERE  coc.order_no = rmc.order_no '||
                                                                                                                             'AND    coc.sequence_no = rmc.sequence_no '||
                                                                                                                             'AND    coc.unit_charge = ''TRUE'')) '||
                                                                                                                  'THEN '||
                                                                                                                     '1/rmc.charged_qty '||
                                                                                                                  'ELSE '||
                                                                                                                     '1 '||
                                                                                                                  'END '||
                                                                                                            'ELSE '||
                                                                                                               '1 '||
                                                                                                            'END '||
                                                                                                      'END '||
                                                                                                'END '||
                                                                                            'FROM   return_material_charge_tab rmc '||
                                                                                            'WHERE  rctl.rma_no = rmc.rma_no '||
                                                                                            'AND    rctl.rma_charge_no = rmc.rma_charge_no), '||
                                                               '(SELECT cc.currency_rounding '||
                                                                'FROM   currency_code_tab cc, '||
                                                                       'return_material_tab rm '||
                                                                'WHERE  rctl.company = cc.company '||
                                                                'AND    cc.currency_code = rm.currency_code '||
                                                                'AND    rm.rma_no = rctl.rma_no) '||
                                                              ') '||
                                                      'ELSE '||
                                                         'ROUND(rctl.tax_percentage * (SELECT CASE  '||
                                                                                                'WHEN (rmc.charge_amount_incl_tax IS NOT NULL) THEN  '||
                                                                                                   'rmc.charge_amount_incl_tax * rmc.charged_qty '||
                                                                                                'ELSE '||
                                                                                                   'rmc.charged_qty * rmc.charge / 100 * '||
                                                                                                   'CASE '||
                                                                                                      'WHEN (rmc.charge_percent_basis IS NOT NULL) THEN '||
                                                                                                         'rmc.charge_percent_basis '||
                                                                                                      'ELSE '||
                                                                                                         'nvl((SELECT SUM(rml.qty_to_return * rml.price_conv_factor * rml.unit_price_incl_tax) '||
                                                                                                                    'FROM   return_material_line_tab rml '||
                                                                                                                    'WHERE  rctl.rma_no = rml.rma_no '||
                                                                                                                    'AND    rml.rowstate != ''Denied''), 0) * '||
                                                                                                         'CASE '||
                                                                                                            'WHEN (rmc.sequence_no IS NOT NULL) THEN '||
                                                                                                               'CASE '||
                                                                                                                  'WHEN (1 = (SELECT 1 '||
                                                                                                                             'FROM   customer_order_charge_tab coc '||
                                                                                                                             'WHERE  coc.order_no = rmc.order_no '||
                                                                                                                             'AND    coc.sequence_no = rmc.sequence_no '||
                                                                                                                             'AND    coc.unit_charge = ''TRUE'')) '||
                                                                                                                  'THEN '||
                                                                                                                     '1/rmc.charged_qty '||
                                                                                                                  'ELSE '||
                                                                                                                     '1 '||
                                                                                                                  'END '||
                                                                                                            'ELSE '||
                                                                                                               '1    '||
                                                                                                            'END '||
                                                                                                      'END '||
                                                                                                'END '||
                                                                                      'FROM   return_material_charge_tab rmc '||
                                                                                      'WHERE  rctl.rma_no = rmc.rma_no '||
                                                                                      'AND    rctl.rma_charge_no = rmc.rma_charge_no) '||
                                                                                   '/ (NVL((SELECT SUM(tax_percentage) '||
                                                                                           'FROM   rma_charge_tax_lines_tab rctl1 '||
                                                                                           'WHERE  rctl1.rma_no = rctl.rma_no '||
                                                                                           'AND    rctl1.rma_charge_no = rctl.rma_charge_no), 0) + 100), '||
                                                               '(SELECT cc.currency_rounding '||
                                                                'FROM   currency_code_tab cc, '||
                                                                       'return_material_tab rm '||
                                                                'WHERE  rctl.company = cc.company '||
                                                                'AND    cc.currency_code = rm.currency_code '||
                                                                'AND    rm.rma_no = rctl.rma_no) '||
                                                              ') '||
                                                      'END '||
                                                'END '||
                  'WHERE  tax_amount IS NOT NULL '||
                  'AND    tax_amount_curr IS NULL; '||
               'END; ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

PROMPT Finished POST_ORDER_UpdateTaxAmountCurrInRma.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateTaxAmountCurrInRma.sql','Done');

