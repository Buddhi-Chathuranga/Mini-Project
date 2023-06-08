-----------------------------------------------------------------------------
--
--  Filename      : POST_ORDER_UpdateSourceTaxItem.sql
--
--  Module        : ORDER
--
--  Purpose       : Move data from ORDER tax storages to source_tax_item_tab in ACCRUL.
--                  ORDER Tax storages were :
--                  1. CUST_ORDER_LINE_TAX_LINES_TAB
--                  2. CUST_ORD_CHARGE_TAX_LINES_TAB
--                  3. QUOTE_LINE_TAX_LINES_TAB
--                  4. QUOTE_CHARGE_TAX_LINES_TAB
--                  5. RMA_LINE_TAX_LINES_TAB
--                  6. RMA_CHARGE_TAX_LINES_TAB
--                  7. SHIPMENT_CHARGE_TAX_LINES_TAB
--
--                  Move to the port script due to the value of 'tax_amount_curr' is updated
--                  by the following post scripts in earlier version.
--                      POST_ORDER_UpdateTaxAmountCurrInCo.sql
--                      POST_ORDER_UpdateTaxAmountCurrInRma.sql.
--
--                  The upgrade would be handled in 3 steps.
--                  1. Update the existing columns of those 7 tables to the source_tax_item_tab
--                  2. Update tax_ curr_amount/tax_ dom_amount in quotation and shipment connected tax tables
--                  3. Update tax_base_curr_amount and tax_base_dom_amount of source_tax_item_tab.

--
--  Date           Sign    History
--  ------------   ------  --------------------------------------------------
--  220127         KiSalk  Bug 162265(SC21R2-7426), Added code to create source_tax_item_tab records for tax-exempted CO lines and charge lines.
--  180209         TiRalk  STRSC-10970, Modified the block, where it updates tax_base_curr_amount and tax_base_dom_amount
--  180209                 to improve performance for the source_ref_type CUSTOMER_ORDER_LINE.
--  160825         MAHPLK  FINHR-2574, Restructured to calculate tax amounts and total amounts.
--  160712         MAHPLK  FINHR-1329, Moved date from SHIPMENT_CHARGE_TAX_LINES_TAB to source_tax_item_tab.
--  160526         IsSalk  FINHR-1792, Renaming obsolete table RMA_CHARGE_TAX_LINES_TAB to RMA_CHARGE_TAX_LINES_1500.
--  160512         SURBLK  FINHR-1772, Renaming obsolete table QUOTE_CHARGE_TAX_LINES_TAB to QUOTE_CHARGE_TAX_LINES_1500.
--  160506         IsSalk  FINHR-1771, Renaming obsolete table RMA_LINE_TAX_LINES_TAB to RMA_LINE_TAX_LINES_1500.
--  160411         IsSaLK  FINHR-1594, Moved date from rma_line_tax_lines_tab to source_tax_item_tab.
--  160325         SURBLK  FINHR-1179, Moved date from quote_charge_tax_lines_tab to source_tax_item_tab.
--  160314         IsSaLK  FINHR-686, Moved date from quote_line_tax_lines_tab to source_tax_item_tab.
--  160309         MAHPLK  Created.
--  ------------   ------  --------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_1');
PROMPT Starting POST_ORDER_UpdateSourceTaxItem.sql

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_2');
PROMPT Moving data from cust_order_line_tax_lines_tab to source_tax_item_tab.
DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- 1. Remove the method calls written to fetch total amounts (which is basis for tax amount),
   --    since source_tax_item_tab not update with tax info when it calls.
   -- 2. tax_base_curr_amount and tax_base_dom_amount updated to -1 and
   --    correct values will be update after upgrading the source_tax_item_tab.
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') THEN
      stmt_ := 'INSERT INTO source_tax_item_tab  (company, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, '||
               '                                  tax_item_id, tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount, '||
               '                                  tax_base_dom_amount, rowversion, rowtype ) '||
               '      (SELECT cotl.company, cotl.order_no, cotl.line_no, cotl.rel_no, TO_CHAR(cotl.line_item_no), ''*'', ''CUSTOMER_ORDER_LINE'', '||
               '              cotl.tax_id, cotl.fee_code, NVL(cotl.tax_percentage, 0), NVL(cotl.tax_amount, 0), NVL(cotl.tax_amount_curr,0), '||
               '               -1, -1, SYSDATE, ''SourceTaxItemOrder'' '||
               '       FROM   cust_order_line_tax_lines_tab cotl) ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
      Database_SYS.Rename_Table('CUST_ORDER_LINE_TAX_LINES_TAB',  'CUST_ORDER_LINE_TAX_LINES_1500',   TRUE);
   END IF;
   

   -- Inserting source_tax_item_tab records for tax-exempted CO lines
   INSERT INTO source_tax_item_tab
      (company, source_ref_type, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, tax_item_id, tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount, tax_base_dom_amount, rowversion, ROWTYPE)
      (SELECT sit.company, 'CUSTOMER_ORDER_LINE', col.order_no, col.line_no, col.rel_no, TO_CHAR(col.line_item_no), '*', 1, col.tax_code, 0, 0, 0, -1, -1, SYSDATE, 'SourceTaxItemOrder'
       FROM   customer_order_line_tab col,
              site_tab                sit
       WHERE  col.tax_liability = 'EXEMPT'
       AND    col.tax_code IS NOT NULL
       AND    col.rowstate IN ('Delivered', 'PartiallyDelivered', 'Picked', 'Released', 'Reserved')
       AND    col.contract = sit.contract
       AND    NOT EXISTS (SELECT 1
               FROM   source_tax_item_tab tax
               WHERE  tax.company = sit.company
               AND    tax.source_ref1 = col.order_no
               AND    tax.source_ref2 = col.line_no
               AND    tax.source_ref3 = col.rel_no
               AND    tax.source_ref4 = TO_CHAR(col.line_item_no)
               AND    tax.source_ref5 = '*'
               AND    tax.source_ref_type = 'CUSTOMER_ORDER_LINE'));
   COMMIT;

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_3');
PROMPT Moving data from cust_ord_charge_tax_lines_tab to source_tax_item_tab.

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- 1. Remove the method calls written to fetch total amounts (which is basis for tax amount),
   --    since source_tax_item_tab not update with tax info when it calls.
   -- 2. tax_base_curr_amount and tax_base_dom_amount updated to -1 and
   --    correct values will be update after upgrading the source_tax_item_tab.
   IF Database_SYS.Table_Exist('CUST_ORD_CHARGE_TAX_LINES_TAB') THEN
      stmt_ := 'INSERT INTO source_tax_item_tab  (company, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, '||
               '                                  tax_item_id, tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount, '||
               '                                  tax_base_dom_amount, rowversion, rowtype ) '||
               '       (SELECT coctl.company, coctl.order_no, TO_CHAR(coctl.sequence_no), ''*'', ''*'', ''*'', ''CUSTOMER_ORDER_CHARGE'', '||
               '               coctl.tax_id, coctl.fee_code, NVL(coctl.tax_percentage, 0), NVL(coctl.tax_amount, 0), NVL(coctl.tax_amount_curr, 0), '||
               '                -1, -1, SYSDATE, ''SourceTaxItemOrder'' '||
               '        FROM   cust_ord_charge_tax_lines_tab coctl)';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
      Database_SYS.Rename_Table('CUST_ORD_CHARGE_TAX_LINES_TAB',  'CUST_ORD_CHARGE_TAX_LINES_1500',   TRUE);
   END IF;

   -- Inserting source_tax_item_tab records for tax-exempted charge lines
   INSERT INTO source_tax_item_tab
      (company, source_ref_type, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, tax_item_id, tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount, tax_base_dom_amount, rowversion, ROWTYPE)
      (SELECT sit.company, 'CUSTOMER_ORDER_CHARGE', cor.order_no, TO_CHAR(cor.sequence_no), '*', '*', '*', 1, cor.tax_code, 0, 0, 0, -1, -1, SYSDATE, 'SourceTaxItemOrder'
       FROM   customer_order_charge_tab cor,
              customer_order_tab        co,
              site_tab                  sit
       WHERE  co.rowstate IN ('Planned', 'Released', 'CreditBlocked', 'Reserved', 'Picked', 'PartiallyDelivered', 'Delivered')
       AND    cor.tax_code IS NOT NULL
       AND    NVL(CASE
                  WHEN cor.line_no IS NULL THEN
                     co.tax_liability
                  ELSE
                     (SELECT col.tax_liability
                      FROM   customer_order_line_tab col
                      WHERE  col.order_no = cor.order_no
                      AND    col.line_no = cor.line_no
                      AND    col.rel_no = cor.rel_no
                      AND    col.line_item_no = cor.line_item_no
                      AND    col.rowstate IN ('Delivered', 'PartiallyDelivered', 'Picked', 'Released', 'Reserved'))
                  END, 'TAX') = 'EXEMPT'
       AND    cor.order_no = co.order_no
       AND    cor.contract = sit.contract
       AND    NOT EXISTS (SELECT 1
               FROM   source_tax_item_tab tax
               WHERE  tax.company = sit.company
               AND    tax.source_ref1 = cor.order_no
               AND    tax.source_ref2 = TO_CHAR(cor.sequence_no)
               AND    tax.source_ref3 = '*'
               AND    tax.source_ref4 = '*'
               AND    tax.source_ref5 = '*'
               AND    tax.source_ref_type = 'CUSTOMER_ORDER_CHARGE'));
   COMMIT;

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_4');
PROMPT Moving data from quote_line_tax_lines_tab to source_tax_item_tab.

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- 1. Remove the method calls written to fetch total amounts (which is basis for tax amount),
   --    since source_tax_item_tab not update with tax info when it calls.
   -- 2. tax_dom_amount, tax_curr_amount, tax_base_curr_amount and tax_base_dom_amount updated to -1 and
   --    correct values will be update after upgrading the source_tax_item_tab.
   IF Database_SYS.Table_Exist('QUOTE_LINE_TAX_LINES_TAB') THEN
      stmt_ := 'INSERT INTO source_tax_item_tab  (company, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, '||
               '                                  tax_item_id, tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount, '||
               '                                  tax_base_dom_amount, rowversion, rowtype ) '||
               '       (SELECT qltl.company, qltl.quotation_no, qltl.line_no, qltl.rel_no, TO_CHAR(qltl.line_item_no), ''*'', ''ORDER_QUOTATION_LINE'', '||
               '               qltl.tax_id, qltl.fee_code, NVL(Statutory_Fee_API.Get_Percentage(qltl.company, qltl.fee_code),0) tax_percentage, '||
               '               -1, -1, -1, -1, SYSDATE, ''SourceTaxItemOrder'' '||
               '        FROM  quote_line_tax_lines_tab qltl)';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
      Database_SYS.Rename_Table('QUOTE_LINE_TAX_LINES_TAB',  'QUOTE_LINE_TAX_LINES_1500',   TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_5');
PROMPT Moving data from quote_charge_tax_lines_tab to source_tax_item_tab.

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- 1. Remove the method calls written to fetch total amounts (which is basis for tax amount),
   --    since source_tax_item_tab not update with tax info when it calls.
   -- 2. tax_dom_amount, tax_curr_amount, tax_base_curr_amount and tax_base_dom_amount updated to -1 and
   --    correct values will be update after upgrading the source_tax_item_tab.
   IF Database_SYS.Table_Exist('QUOTE_CHARGE_TAX_LINES_TAB') THEN
      stmt_ := 'INSERT INTO source_tax_item_tab  (company, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, '||
               '                                  tax_item_id, tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount, '||
               '                                  tax_base_dom_amount, rowversion, rowtype ) '||
               '       (SELECT qctl.company, qctl.quotation_no, TO_CHAR(qctl.quotation_charge_no), ''*'', ''*'', ''*'', ''ORDER_QUOTATION_CHARGE'', '||
               '               qctl.tax_id, qctl.fee_code, NVL(Statutory_Fee_API.Get_Percentage(qctl.company, qctl.fee_code),0) tax_percentage, '||
               '               -1, -1, -1, -1, SYSDATE, ''SourceTaxItemOrder'' '||
               '        FROM   quote_charge_tax_lines_tab qctl)';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
      Database_SYS.Rename_Table('QUOTE_CHARGE_TAX_LINES_TAB',  'QUOTE_CHARGE_TAX_LINES_1500',   TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_6');
PROMPT Moving data from rma_line_tax_lines_tab to source_tax_item_tab.

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- 1. Remove the method calls written to fetch total amounts (which is basis for tax amount),
   --    since source_tax_item_tab not update with tax info when it calls.
   -- 2. tax_base_curr_amount and tax_base_dom_amount updated to -1 and
   --    correct values will be update after upgrading the source_tax_item_tab.
   IF Database_SYS.Table_Exist('RMA_LINE_TAX_LINES_TAB') THEN
      stmt_ := 'INSERT INTO source_tax_item_tab  (company, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, '||
               '                                  tax_item_id, tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount, '||
               '                                  tax_base_dom_amount, rowversion, rowtype ) '||
               '            (SELECT rltl.company, TO_CHAR(rltl.rma_no), TO_CHAR(rltl.rma_line_no), ''*'', ''*'', ''*'', ''RETURN_MATERIAL_LINE'', '||
               '                    rltl.tax_id, rltl.fee_code, NVL(rltl.tax_percentage, 0), NVL(rltl.tax_amount, 0), NVL(rltl.tax_amount_curr, 0), '||
               '                    -1, -1, SYSDATE, ''SourceTaxItemOrder'' '||
               '             FROM   rma_line_tax_lines_tab rltl) ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
      Database_SYS.Rename_Table('RMA_LINE_TAX_LINES_TAB',  'RMA_LINE_TAX_LINES_1500',   TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_7');
PROMPT Moving data from rma_charge_line_tax_lines_tab to source_tax_item_tab.

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- 1. Remove the method calls written to fetch total amounts (which is basis for tax amount),
   --    since source_tax_item_tab not update with tax info when it calls.
   -- 2. tax_base_curr_amount and tax_base_dom_amount updated to -1 and
   --    correct values will be update after upgrading the source_tax_item_tab.
   IF Database_SYS.Table_Exist('RMA_CHARGE_TAX_LINES_TAB') THEN
      stmt_ := 'INSERT INTO source_tax_item_tab  (company, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, tax_item_id,  '||
               '                             tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount,  '||
               '                             tax_base_dom_amount, rowversion, rowtype )  '||
               '      (SELECT rctl.company, TO_CHAR(rctl.rma_no), TO_CHAR(rctl.rma_charge_no), ''*'', ''*'', ''*'', ''RETURN_MATERIAL_CHARGE'', rctl.tax_id, '||
               '              rctl.fee_code, NVL(rctl.tax_percentage, 0), NVL(rctl.tax_amount, 0), NVL(rctl.tax_amount_curr, 0), '||
               '              -1,  -1, SYSDATE, ''SourceTaxItemOrder'' '||
               '       FROM  rma_charge_tax_lines_tab rctl)';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
      Database_SYS.Rename_Table('RMA_CHARGE_TAX_LINES_TAB',  'RMA_CHARGE_TAX_LINES_1500',   TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_8');
PROMPT Moving data from shipment_charge_tax_lines_tab to source_tax_item_tab.

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   -- 1. Remove the method calls written to fetch total amounts (which is basis for tax amount),
   --    since source_tax_item_tab not update with tax info when it calls.
   -- 2. tax_curr_amount, tax_base_curr_amount and tax_base_dom_amount updated to -1 and
   --    correct values will be update after upgrading the source_tax_item_tab.
   IF Database_SYS.Table_Exist('SHIPMENT_CHARGE_TAX_LINES_TAB') THEN
      stmt_ := 'INSERT INTO source_tax_item_tab  (company, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, source_ref_type, tax_item_id,  '||
               '                             tax_code, tax_percentage, tax_dom_amount, tax_curr_amount, tax_base_curr_amount,  '||
               '                             tax_base_dom_amount, rowversion, rowtype )  '||
               '      (SELECT sctl.company, sctl.shipment_id, TO_CHAR(sctl.sequence_no), ''*'', ''*'', ''*'', ''SHIPMENT_FREIGHT_CHARGE'', sctl.tax_id, '||
               '              sctl.fee_code, sctl.tax_percentage, NVL(sctl.tax_amount, 0), -1, '||
               '              -1,  -1, SYSDATE, ''SourceTaxItemOrder'' '||
               '       FROM  shipment_charge_tax_lines_tab sctl)';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
      Database_SYS.Rename_Table('SHIPMENT_CHARGE_TAX_LINES_TAB',  'SHIPMENT_CHARGE_TAX_LINES_1500',   TRUE);
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_9');
PROMPT Update tax_base_curr_amount and tax_base_dom_amount of source_tax_item_tab.
DECLARE
   tax_dom_amount_     NUMBER;
   tax_curr_amount_    NUMBER;
   rounding_           NUMBER;
   currency_code_      VARCHAR2(3);
   currency_rate_      NUMBER;
   total_curr_amount_  NUMBER;

   CURSOR get_tax_lines IS
      SELECT company, source_ref_type, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, tax_item_id, tax_percentage,
             tax_curr_amount, tax_dom_amount
      FROM source_tax_item_tab
      WHERE source_ref_type IN ('ORDER_QUOTATION_LINE','ORDER_QUOTATION_CHARGE','SHIPMENT_FREIGHT_CHARGE')
      AND (tax_dom_amount = -1 OR tax_curr_amount = -1);

   TYPE tax_amount_table IS TABLE OF get_tax_lines%ROWTYPE INDEX BY BINARY_INTEGER;
   tax_tab_ tax_amount_table;
   bulk_limit_  CONSTANT NUMBER := 10000;


   FUNCTION Get_Sale_Price_Total (
      quotation_no_ IN VARCHAR2,
      line_no_      IN VARCHAR2,
      rel_no_       IN VARCHAR2,
      line_item_no_ IN NUMBER,
      rounding_     IN NUMBER ) RETURN NUMBER
   IS
      add_discount_              NUMBER;
      total_net_amount_        NUMBER;
      discount_                  NUMBER;
      quotation_discount_        NUMBER;
      line_discount_amount_      NUMBER;
      add_disc_amt_              NUMBER;
      quotation_discount_amount_ NUMBER;
      net_curr_amount_           NUMBER;
      buy_qty_due_               NUMBER;
      price_conv_factor_         NUMBER;
      rental_chargeable_days_    NUMBER;

      CURSOR get_total IS
         SELECT buy_qty_due * price_conv_factor * sale_unit_price total_net_amount,
                discount, quotation_discount, buy_qty_due, price_conv_factor
         FROM   ORDER_QUOTATION_LINE_TAB
         WHERE  line_item_no = line_item_no_
         AND    rel_no = rel_no_
         AND    line_no = line_no_
         AND    quotation_no = quotation_no_;
   BEGIN
      OPEN get_total;
      FETCH get_total INTO total_net_amount_, discount_, quotation_discount_, buy_qty_due_, price_conv_factor_;
      CLOSE get_total;

      rental_chargeable_days_ := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);
      add_discount_ := Order_Quotation_API.Get_Additional_Discount(quotation_no_);
      line_discount_amount_ := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_, buy_qty_due_, price_conv_factor_, rounding_);

      total_net_amount_          := total_net_amount_ * rental_chargeable_days_;
      add_disc_amt_              := ROUND(((total_net_amount_ - line_discount_amount_) * add_discount_/100 ), rounding_);
      quotation_discount_amount_ := ROUND((total_net_amount_ - line_discount_amount_) * (quotation_discount_ / 100), rounding_);
      total_net_amount_          := ROUND(total_net_amount_, rounding_);
      net_curr_amount_           := total_net_amount_ - line_discount_amount_ - quotation_discount_amount_ - add_disc_amt_;

      RETURN NVL(net_curr_amount_, 0);
   END Get_Sale_Price_Total;


   FUNCTION Get_Sale_Price_Incl_Tax_Total (
      quotation_no_ IN VARCHAR2,
      line_no_      IN VARCHAR2,
      rel_no_       IN VARCHAR2,
      line_item_no_ IN NUMBER,
      rounding_     IN NUMBER      ) RETURN NUMBER
   IS
      add_discount_              NUMBER;
      total_gross_amount_     NUMBER;
      discount_                  NUMBER;
      quotation_discount_        NUMBER;
      line_discount_amount_      NUMBER;
      add_disc_amt_              NUMBER;
      quotation_discount_amount_ NUMBER;
      gross_curr_amount_      NUMBER;
      buy_qty_due_               NUMBER;
      price_conv_factor_         NUMBER;
      rental_chargeable_days_    NUMBER;

      CURSOR get_total IS
         SELECT buy_qty_due * price_conv_factor * unit_price_incl_tax total_gross_amount,
                discount, quotation_discount, buy_qty_due, price_conv_factor
         FROM   ORDER_QUOTATION_LINE_TAB
         WHERE  line_item_no = line_item_no_
         AND    rel_no = rel_no_
         AND    line_no = line_no_
         AND    quotation_no = quotation_no_;
   BEGIN
      OPEN get_total;
      FETCH get_total INTO total_gross_amount_, discount_, quotation_discount_, buy_qty_due_, price_conv_factor_;
      CLOSE get_total;

      rental_chargeable_days_ := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);
      add_discount_           := Order_Quotation_API.Get_Additional_Discount(quotation_no_);
      line_discount_amount_   := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_, buy_qty_due_, price_conv_factor_, rounding_);

      total_gross_amount_     := ROUND((total_gross_amount_ * rental_chargeable_days_), rounding_);
      add_disc_amt_              := ROUND(((total_gross_amount_ - line_discount_amount_) * add_discount_/100 ), rounding_);
      quotation_discount_amount_ := ROUND((total_gross_amount_ - line_discount_amount_) * (quotation_discount_ / 100), rounding_);
      gross_curr_amount_      := total_gross_amount_ - line_discount_amount_ - quotation_discount_amount_ - add_disc_amt_;

      RETURN NVL(gross_curr_amount_, 0);
   END Get_Sale_Price_Incl_Tax_Total;


   -- Calculate tax_curr_amount_ and tax_dom_amount_ of quotation charges according to APP9 PIV calculation.
   -- (We didn't have the tax_percentage and tax_amount in base currency or order currency in APP9)
   PROCEDURE Calc_Quotation_Chg_Tax_Amts (
      tax_curr_amount_ OUT NUMBER,
      tax_dom_amount_  OUT NUMBER,
      company_         IN VARCHAR2,
      quotation_no_     IN VARCHAR2,
      quotation_charge_no_     IN VARCHAR2,
      tax_percentage_  IN NUMBER)
   IS
      rounding_                  NUMBER;
      total_gross_amount_        NUMBER;
      total_net_amount_          NUMBER;
      total_tax_curr_amount_     NUMBER;
      tot_tax_pct_               NUMBER;
      rowstate_                  VARCHAR2(20);
      currency_code_             VARCHAR2(3);
      use_price_incl_tax_        VARCHAR2(20);
      currency_rate_             NUMBER;
      net_chg_percent_basis_     NUMBER;
      gross_chg_percent_basis_   NUMBER;
      line_no_                   VARCHAR2(4);
      rel_no_                    VARCHAR2(4);
      line_item_no_              NUMBER;
      charged_qty_               NUMBER;
      charge_percent_basis_      NUMBER;
      charge_amount_             NUMBER;
      charge_amount_incl_tax_    NUMBER;
      charge_                    NUMBER;

      CURSOR get_total IS
         SELECT oqc.charge, oqc.charge_amount, oqc.charge_amount_incl_tax,
                oqc.charged_qty , oqc.charge_percent_basis,
                oqc.currency_rate, oqc.line_no, oqc.rel_no, oqc.line_item_no, oq.rowstate, oq.currency_code, oq.use_price_incl_tax
         FROM   order_quotation_charge_tab oqc, order_quotation_tab oq
         WHERE  oqc.quotation_no = oq.quotation_no
         AND    oqc.quotation_no = quotation_no_
         AND    oqc.quotation_charge_no = quotation_charge_no_;

      CURSOR get_quotation_lines IS
         SELECT line_no, rel_no, line_item_no
         FROM   order_quotation_line_tab
         WHERE  rowstate != 'Cancelled'
         AND    line_item_no <= 0
         AND    quotation_no = quotation_no_;

   BEGIN
      OPEN get_total;
      FETCH get_total INTO charge_, charge_amount_, charge_amount_incl_tax_, charged_qty_, charge_percent_basis_,
                           currency_rate_, line_no_, rel_no_, line_item_no_, rowstate_, currency_code_, use_price_incl_tax_;
      CLOSE get_total;

      IF (rowstate_ = 'Cancelled' OR tax_percentage_= 0) THEN
         tax_curr_amount_ := 0;
         tax_dom_amount_  := 0;
      ELSE
         rounding_  := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
         IF use_price_incl_tax_ = 'FALSE' THEN
            IF (charge_amount_ IS NULL) THEN
               -- Calculate net_chg_percent_basis_ (Order_Quotation_Charge_API.Get_Net_Charge_Percent_Basis)
               IF (charge_percent_basis_ IS NULL) THEN
                  IF (line_no_ IS NULL) THEN
                     FOR rec_ IN get_quotation_lines LOOP
                        net_chg_percent_basis_ := NVL(net_chg_percent_basis_, 0) + Get_Sale_Price_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rounding_) ;
                     END LOOP;
                  ELSE
                     net_chg_percent_basis_ := Get_Sale_Price_Total(quotation_no_, line_no_, rel_no_, line_item_no_, rounding_);
                  END IF;
                  IF charged_qty_ != 0 THEN
                     net_chg_percent_basis_ := net_chg_percent_basis_ / charged_qty_;
                  END IF;
               ELSE
                  net_chg_percent_basis_ := charge_percent_basis_;
               END IF;

               total_net_amount_ := ROUND(NVL(charge_ * net_chg_percent_basis_ * charged_qty_ / 100, 0), rounding_);
            ELSE
               total_net_amount_ := ROUND(NVL(charge_amount_ * charged_qty_, 0), rounding_);
            END IF;

            -- Tax Amounts
            tax_curr_amount_ :=  NVL(ROUND(total_net_amount_ * tax_percentage_/100, rounding_), 0);
            tax_dom_amount_  :=  NVL(ROUND((total_net_amount_ * tax_percentage_/100) * currency_rate_, rounding_), 0);
         ELSE
            tot_tax_pct_ := Source_Tax_Item_API.Get_Total_Tax_Percentage(company_, Tax_Source_API.DB_ORDER_QUOTATION_CHARGE,
                                                                        quotation_no_, TO_CHAR(quotation_charge_no_), '*', '*', '*');
            IF (tot_tax_pct_ != 0)  THEN
               IF (charge_amount_incl_tax_ IS NULL) THEN
                  -- Calculate gross_chg_percent_basis_ (Order_Quotation_Charge_API.Get_Gross_Charge_Percent_Basis)
                  IF (charge_percent_basis_ IS NULL) THEN
                     IF (line_no_ IS NULL) THEN
                        FOR rec_ IN get_quotation_lines LOOP
                           gross_chg_percent_basis_ := NVL(gross_chg_percent_basis_,0) + Get_Sale_Price_Incl_Tax_Total(quotation_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rounding_) ;
                        END LOOP;
                     ELSE
                        gross_chg_percent_basis_ := Get_Sale_Price_Incl_Tax_Total(quotation_no_, line_no_, rel_no_, line_item_no_, rounding_);
                     END IF;
                     IF charged_qty_ != 0 THEN
                        gross_chg_percent_basis_ := gross_chg_percent_basis_ / charged_qty_;
                     END IF;
                  ELSE
                     gross_chg_percent_basis_ := charge_percent_basis_;
                  END IF;

                  total_gross_amount_ := ROUND(NVL(charge_ * gross_chg_percent_basis_ * charged_qty_ / 100, 0), rounding_);
               ELSE
                  total_gross_amount_ := ROUND(NVL(charge_amount_incl_tax_ * charged_qty_, 0), rounding_);
               END IF;
               total_net_amount_      := ROUND(total_gross_amount_ / (1 + (tot_tax_pct_/100)), rounding_);

               total_tax_curr_amount_  := total_gross_amount_ - total_net_amount_;

               tax_curr_amount_ :=  NVL(ROUND(total_tax_curr_amount_ * tax_percentage_/tot_tax_pct_, rounding_), 0);
               tax_dom_amount_  :=  NVL(ROUND((total_tax_curr_amount_ * tax_percentage_/tot_tax_pct_) * currency_rate_, rounding_), 0);
            ELSE
               tax_curr_amount_ :=  0;
               tax_dom_amount_  :=  0;
            END IF;
         END IF;
      END IF;
   END Calc_Quotation_Chg_Tax_Amts;

   -- Calculate tax_curr_amount_ and tax_dom_amount_ of quotation lines according to APP9 PIV calculation.
   -- (We didn't have the tax_percentage and tax_amount in base currency or order currency in APP9)
   PROCEDURE Calc_Quotation_Line_Tax_Amts (
      tax_curr_amount_  OUT NUMBER,
      tax_dom_amount_   OUT NUMBER,
      company_          IN VARCHAR2,
      quotation_no_     IN VARCHAR2,
      line_no_          IN VARCHAR2,
      rel_no_           IN VARCHAR2,
      line_item_no_     IN NUMBER,
      tax_percentage_   IN NUMBER)
   IS
      rounding_                  NUMBER;
      rental_chargeable_days_    NUMBER;
      total_gross_amount_        NUMBER;
      total_net_amount_          NUMBER;
      line_discount_amount_      NUMBER;
      add_disc_amt_              NUMBER;
      quote_discount_            NUMBER;
      quote_discount_amount_     NUMBER;
      total_discount_amount_     NUMBER;
      total_disc_amount_excl_tax_   NUMBER;
      total_gross_curr_amount_  NUMBER;
      total_net_curr_amount_    NUMBER;
      total_tax_curr_amount_    NUMBER;
      tot_tax_pct_              NUMBER;
      tax_liability_type_       VARCHAR2(20);
      rowstate_                 VARCHAR2(20);
      currency_code_            VARCHAR2(3);
      use_price_incl_tax_       VARCHAR2(20);
      additional_discount_      NUMBER;
      stmt_                     VARCHAR2(32767);
      buy_qty_due_              NUMBER;
      price_conv_factor_        NUMBER;
      currency_rate_            NUMBER;

      CURSOR get_total IS
         SELECT oql.buy_qty_due * oql.price_conv_factor * oql.unit_price_incl_tax total_gross_amount,
                oql.buy_qty_due * oql.price_conv_factor * oql.sale_unit_price total_net_amount,
                oql.quotation_discount, oql.buy_qty_due, oql.price_conv_factor, oql.currency_rate, oql.tax_liability_type,
                oq.rowstate, oq.currency_code, oq.use_price_incl_tax, oq.additional_discount
         FROM   order_quotation_line_tab oql, order_quotation_tab oq
         WHERE  oql.quotation_no = oq.quotation_no
         AND    oql.quotation_no = quotation_no_
         AND    oql.line_no = line_no_
         AND    oql.rel_no = rel_no_
         AND    oql.line_item_no = line_item_no_;

   BEGIN
      OPEN get_total;
      FETCH get_total INTO total_gross_amount_, total_net_amount_, quote_discount_, buy_qty_due_, price_conv_factor_,
                           currency_rate_, tax_liability_type_, rowstate_, currency_code_, use_price_incl_tax_, additional_discount_;
      CLOSE get_total;

      IF (rowstate_ = 'Cancelled' OR tax_percentage_= 0 OR tax_liability_type_ = 'EXM') THEN
         tax_curr_amount_ := 0;
         tax_dom_amount_  := 0;
      ELSE
         rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
         rental_chargeable_days_ := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);
         total_gross_amount_  := ROUND(total_gross_amount_ * rental_chargeable_days_, rounding_);
         total_net_amount_    := ROUND(total_net_amount_ * rental_chargeable_days_, rounding_);

         line_discount_amount_  := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_,
                                                                                         buy_qty_due_, price_conv_factor_, rounding_);
         add_disc_amt_          := ROUND(((total_gross_amount_ - line_discount_amount_) * additional_discount_/100 ), rounding_);
         quote_discount_amount_ := ROUND((total_gross_amount_ - line_discount_amount_) * (quote_discount_/100), rounding_);

         total_discount_amount_ := line_discount_amount_ + add_disc_amt_ +  quote_discount_amount_;

         IF use_price_incl_tax_ = 'TRUE' THEN
            -- total_gross_curr_amount_ => Total gross amount excluding discount.
            total_gross_curr_amount_ := total_gross_amount_ - total_discount_amount_;

            tot_tax_pct_ := Source_Tax_Item_API.Get_Total_Tax_Percentage(company_, Tax_Source_API.DB_ORDER_QUOTATION_LINE,
                                                                        quotation_no_, line_no_, rel_no_, TO_CHAR(line_item_no_), '*');
            IF tot_tax_pct_ != 0 THEN
               total_net_amount_      := ROUND(total_gross_amount_ / (1 + (tot_tax_pct_/100)), rounding_);
               line_discount_amount_  := Order_Quote_Line_Discount_API.Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_,
                                                                                               buy_qty_due_, price_conv_factor_, rounding_, tot_tax_pct_);
               add_disc_amt_          := ROUND(add_disc_amt_ / (1 + (tot_tax_pct_/100)), rounding_);
               quote_discount_amount_ := ROUND(quote_discount_amount_ / (1 + (tot_tax_pct_/100)), rounding_);
               total_disc_amount_excl_tax_ := line_discount_amount_ + add_disc_amt_ + quote_discount_amount_;
               total_net_curr_amount_ := total_net_amount_ - total_disc_amount_excl_tax_;

               total_tax_curr_amount_  := total_gross_curr_amount_ - total_net_curr_amount_;

               tax_curr_amount_ :=  NVL(ROUND(total_tax_curr_amount_ * tax_percentage_/tot_tax_pct_, rounding_), 0);
               tax_dom_amount_  :=  NVL(ROUND((total_tax_curr_amount_ * tax_percentage_/tot_tax_pct_) * currency_rate_, rounding_), 0);
            ELSE
               tax_curr_amount_ :=  0;
               tax_dom_amount_  :=  0;
            END IF;
         ELSE
            total_net_curr_amount_ := total_net_amount_ - total_discount_amount_;
            tax_curr_amount_ :=  NVL(ROUND(total_net_curr_amount_ * tax_percentage_/100, rounding_), 0);
            tax_dom_amount_  :=  NVL(ROUND((total_net_curr_amount_ * tax_percentage_/100) * currency_rate_, rounding_), 0);
         END IF;
      END IF;
   END Calc_Quotation_Line_Tax_Amts;

BEGIN
   -- CURSOR loop cannot be removed since table source_tax_item_tab used to UPDATE records has also been referred inside PL/SQL Functions
   -- (ie: Source_Tax_Item_API.Get_Total_Tax_Percentage).
   -- This is due to the Oracle Restrictions when using PL/SQL methods inside SQL.
   -- (ORA-04091: table source_tax_item_tab is mutating, trigger/function may not see it)

   OPEN get_tax_lines;
   LOOP
      FETCH get_tax_lines BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
      IF tax_tab_.COUNT > 0 THEN
         FOR i_ IN tax_tab_.FIRST..tax_tab_.LAST LOOP
            CASE
               -- For the QUOTE_LINE_TAX_LINES_TAB and QUOTE_CHARGE_TAX_LINES_TAB we only had the tax codes stored in the tables.
               -- We didn't have the tax_percentage and tax_amount in base currency or order currency in APP9
               WHEN tax_tab_(i_).source_ref_type = 'ORDER_QUOTATION_LINE' THEN
                  Calc_Quotation_Line_Tax_Amts (tax_curr_amount_ , tax_dom_amount_ , tax_tab_(i_).company,
                                             tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2,
                                             tax_tab_(i_).source_ref3, tax_tab_(i_).source_ref4,
                                             tax_tab_(i_).tax_percentage);

                  tax_tab_(i_).tax_curr_amount := tax_curr_amount_;
                  tax_tab_(i_).tax_dom_amount := tax_dom_amount_;

               WHEN tax_tab_(i_).source_ref_type = 'ORDER_QUOTATION_CHARGE' THEN
                  Calc_Quotation_Chg_Tax_Amts (tax_curr_amount_ , tax_dom_amount_ , tax_tab_(i_).company,
                                             tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2,
                                             tax_tab_(i_).tax_percentage);

                  tax_tab_(i_).tax_curr_amount := tax_curr_amount_;
                  tax_tab_(i_).tax_dom_amount := tax_dom_amount_;

               -- SHIPMENT_CHARGE_TAX_LINES_TAB we had only tax_amount (not the tax_amount_curr)
               WHEN tax_tab_(i_).source_ref_type = 'SHIPMENT_FREIGHT_CHARGE' THEN
                  currency_code_  := NVL(Shipment_Freight_API.Get_Currency_Code(tax_tab_(i_).source_ref1),
                                                Company_Finance_API.Get_Currency_Code(tax_tab_(i_).company));

                  Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(tax_curr_amount_, currency_rate_,
                                                                         Shipment_API.Get_Receiver_Id(tax_tab_(i_).source_ref1),
                                                                         Shipment_Freight_Charge_API.Get_Contract(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2),
                                                                         currency_code_,
                                                                         tax_tab_(i_).tax_dom_amount);

                  tax_tab_(i_).tax_curr_amount := tax_curr_amount_;

               ELSE
                  NULL;
            END CASE;
         END LOOP;

         FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
            UPDATE source_tax_item_tab
               SET tax_curr_amount = NVL(tax_tab_(i_).tax_curr_amount, 0),
                   tax_dom_amount = NVL(tax_tab_(i_).tax_dom_amount, 0)
               WHERE  company = tax_tab_(i_).company
               AND    source_ref_type = tax_tab_(i_).source_ref_type
               AND    source_ref1 = tax_tab_(i_).source_ref1
               AND    source_ref2 = tax_tab_(i_).source_ref2
               AND    source_ref3 = tax_tab_(i_).source_ref3
               AND    source_ref4 = tax_tab_(i_).source_ref4
               AND    source_ref5 = tax_tab_(i_).source_ref5
               AND    tax_item_id = tax_tab_(i_).tax_item_id;
      END IF;
      EXIT WHEN get_tax_lines%NOTFOUND;
   END LOOP;
   CLOSE get_tax_lines;
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Timestamp_10');
PROMPT Update tax_base_curr_amount and tax_base_dom_amount of source_tax_item_tab.
DECLARE
   CURSOR get_tax_lines IS
      SELECT company, source_ref_type, source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, tax_item_id, tax_base_curr_amount, tax_base_dom_amount
      FROM source_tax_item_tab
      WHERE source_ref_type IN ('CUSTOMER_ORDER_LINE', 'CUSTOMER_ORDER_CHARGE', 'ORDER_QUOTATION_LINE','ORDER_QUOTATION_CHARGE',
                                'RETURN_MATERIAL_LINE', 'RETURN_MATERIAL_CHARGE', 'SHIPMENT_FREIGHT_CHARGE')
      AND (tax_base_curr_amount = -1 OR tax_base_dom_amount = -1);

   TYPE tax_base_amount_table IS TABLE OF get_tax_lines%ROWTYPE INDEX BY BINARY_INTEGER;
   tax_tab_ tax_base_amount_table;
   bulk_limit_  CONSTANT NUMBER := 10000;

BEGIN
   -- In below we cannot remove the cursor loop. In method call again source_tax_item_tab access conditionally when use_price_incl_tax is TRUE.
   -- But as the majority records will be use_price_incl_tax is FALSE, direct update has written to gain performance.
   -- When updating tax_base_dom_amount it calls Customer_Order_Line_API.Get_Base_Sale_Price_Total and inside that method
   -- again Customer_Order_Line_API.Get_Sale_Price_Total has been called to calculate tax_base_curr_amount.
   -- So to avoid redundant calls first updated the tax_base_curr_amount and using tax_base_curr_amount it has calculated the tax_base_dom_amount.
   
   UPDATE source_tax_item_tab sti
   SET    sti.tax_base_curr_amount = NVL(Customer_Order_Line_API.Get_Sale_Price_Total(sti.source_ref1, sti.source_ref2,
                                                                                      sti.source_ref3, sti.source_ref4), 0)
   WHERE  EXISTS (SELECT 1
                  FROM   customer_order_tab co
                  WHERE  co.order_no           = sti.source_ref1
                  AND    co.use_price_incl_tax = 'FALSE')
   AND    sti.tax_base_curr_amount = -1
   AND    sti.source_ref_type = 'CUSTOMER_ORDER_LINE';
   COMMIT;
   
   UPDATE source_tax_item_tab sti
   SET    sti.tax_base_dom_amount  = NVL(Customer_Order_Line_API.Get_Base_Sale_Price_Total(sti.source_ref1, sti.source_ref2,
                                                               sti.source_ref3, sti.source_ref4, sti.tax_base_curr_amount), 0)
   WHERE  EXISTS (SELECT 1
                  FROM   customer_order_tab co
                  WHERE  co.order_no   = sti.source_ref1
                  AND    co.use_price_incl_tax = 'FALSE')
   AND    sti.tax_base_dom_amount = -1
   AND    sti.source_ref_type = 'CUSTOMER_ORDER_LINE';
   COMMIT;
   
   -- CURSOR loop cannot be removed since table source_tax_item_tab used to UPDATE records has also been referred inside PL/SQL Functions
   -- (ie: Customer_Order_Line_API. Get_Sale_Price_Total/ Get_Base_Sale_Price_Total).
   -- This is due to the Oracle Restrictions when using PL/SQL methods inside SQL.
   -- (ORA-04091: table source_tax_item_tab is mutating, trigger/function may not see it)
   OPEN get_tax_lines;
   LOOP
      FETCH get_tax_lines BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
      IF tax_tab_.COUNT > 0 THEN

         FOR i_ IN tax_tab_.FIRST..tax_tab_.LAST LOOP
            CASE
               WHEN tax_tab_(i_).source_ref_type = 'CUSTOMER_ORDER_LINE' THEN
                  tax_tab_(i_).tax_base_curr_amount := Customer_Order_Line_API.Get_Sale_Price_Total(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2,
                                                                                       tax_tab_(i_).source_ref3, tax_tab_(i_).source_ref4);
                  tax_tab_(i_).tax_base_dom_amount  := Customer_Order_Line_API.Get_Base_Sale_Price_Total(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2,
                                                                                       tax_tab_(i_).source_ref3, tax_tab_(i_).source_ref4);

               WHEN tax_tab_(i_).source_ref_type = 'CUSTOMER_ORDER_CHARGE' THEN
                  tax_tab_(i_).tax_base_curr_amount := Customer_Order_Charge_API.Get_Total_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);
                  tax_tab_(i_).tax_base_dom_amount  := Customer_Order_Charge_API.Get_Total_Base_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);

               WHEN tax_tab_(i_).source_ref_type = 'ORDER_QUOTATION_LINE' THEN
                  tax_tab_(i_).tax_base_curr_amount := Order_Quotation_Line_API.Get_Sale_Price_Total(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2,
                                                                                       tax_tab_(i_).source_ref3, tax_tab_(i_).source_ref4);
                  tax_tab_(i_).tax_base_dom_amount := Order_Quotation_Line_API.Get_Base_Sale_Price_Total(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2,
                                                                                       tax_tab_(i_).source_ref3, tax_tab_(i_).source_ref4);

               WHEN tax_tab_(i_).source_ref_type = 'ORDER_QUOTATION_CHARGE' THEN
                  tax_tab_(i_).tax_base_curr_amount := Order_Quotation_Charge_API.Get_Total_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);
                  tax_tab_(i_).tax_base_dom_amount  := Order_Quotation_Charge_API.Get_Total_Base_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);

               WHEN tax_tab_(i_).source_ref_type = 'RETURN_MATERIAL_LINE' THEN
                  tax_tab_(i_).tax_base_curr_amount := Return_Material_Line_API.Get_Line_Total_Price(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);
                  tax_tab_(i_).tax_base_dom_amount  := Return_Material_Line_API.Get_Line_Total_Base_Price(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);

               WHEN tax_tab_(i_).source_ref_type = 'RETURN_MATERIAL_CHARGE' THEN
                  tax_tab_(i_).tax_base_curr_amount := Return_Material_Charge_API.Get_Total_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);
                  tax_tab_(i_).tax_base_dom_amount  := Return_Material_Charge_API.Get_Total_Base_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);

               WHEN tax_tab_(i_).source_ref_type = 'SHIPMENT_FREIGHT_CHARGE' THEN
                  tax_tab_(i_).tax_base_curr_amount := Shipment_Freight_Charge_API.Get_Total_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);
                  tax_tab_(i_).tax_base_dom_amount  := Shipment_Freight_Charge_API.Get_Total_Base_Charged_Amount(tax_tab_(i_).source_ref1, tax_tab_(i_).source_ref2);
               ELSE
                  NULL;
            END CASE;
         END LOOP;

         FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
            UPDATE source_tax_item_tab
            SET tax_base_curr_amount = NVL(tax_tab_(i_).tax_base_curr_amount, 0),
                tax_base_dom_amount = NVL(tax_tab_(i_).tax_base_dom_amount, 0)
            WHERE  company = tax_tab_(i_).company
            AND    source_ref_type = tax_tab_(i_).source_ref_type
            AND    source_ref1 = tax_tab_(i_).source_ref1
            AND    source_ref2 = tax_tab_(i_).source_ref2
            AND    source_ref3 = tax_tab_(i_).source_ref3
            AND    source_ref4 = tax_tab_(i_).source_ref4
            AND    source_ref5 = tax_tab_(i_).source_ref5
            AND    tax_item_id = tax_tab_(i_).tax_item_id;
      END IF;
      EXIT WHEN get_tax_lines%NOTFOUND;
   END LOOP;
   CLOSE get_tax_lines;
   COMMIT;
END;
/
PROMPT Finished POST_ORDER_UpdateSourceTaxItem.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateSourceTaxItem.sql','Done');


