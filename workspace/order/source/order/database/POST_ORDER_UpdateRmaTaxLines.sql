--
--  Module          : ORDER
--
--  File            : POST_ORDER_UpdateRmaTaxLines.sql
--
--  Purpose         : Moved this code segment into this file from 1400.upg in order to avoid erros that occur due to some APIs getting invalidated.
--                    The purpose of this code segment is to update RMA tax lines based on the considered logic.
--
--
--
--  Date    Sign     History
--  ------  ------   --------------------------------------------------------
--  160309  MAHPLK   FINHR-1487, Re-written to execute dynamically.
--  140930  MeAblk   Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateRmaTaxLines.sql','Timestamp_1');
PROMPT Starting POST_ORDER_UpdateRmaTaxLines.sql

SET SERVEROUTPUT ON

DECLARE
   stmt_     VARCHAR2(32767);
BEGIN
   IF Database_SYS.Table_Exist('CUST_ORDER_LINE_TAX_LINES_TAB') AND
      Database_SYS.Table_Exist('RMA_LINE_TAX_LINES_TAB')THEN
      stmt_ := 'DECLARE '||
               '   rounding_         NUMBER; '||
               '   tax_percentage_   NUMBER; '||
               '   tax_amount_       NUMBER; '||
               '   tax_id_           NUMBER; '||
               '   rowversion_       DATE; '||
               '   parent_fee_code_  VARCHAR2(20); '||

               '   CURSOR get_no_inv_tax_rma_lines IS '||
               '      SELECT rltl.company, rltl.rma_no, rltl.rma_line_no, rltl.tax_id, rltl.fee_code, rml.qty_to_return, '||
               '             rml.price_conv_factor, rml.base_sale_unit_price '||
               '      FROM rma_line_tax_lines_tab rltl, return_material_line_tab rml '||
               '      WHERE rml.rma_no = rltl.rma_no '||
               '      AND rml.rma_line_no = rltl.rma_line_no '||
               '      AND rltl.tax_amount IS NULL '||
               '      AND rltl.tax_percentage IS NULL '||
               '      AND ((rml.order_no IS NULL AND rml.debit_invoice_no IS NULL) OR '||
               '          ((rml.order_no IS NOT NULL OR rml.debit_invoice_no IS NOT NULL) AND rml.credit_invoice_no IS NOT NULL)) '||
               '      AND Return_Material_Line_API.Get_Tax_Liability_Type_Db(rltl.rma_no, rltl.rma_line_no) != ''EXM''; '||

               '   CURSOR get_no_tax_rma_lines IS '||
               '      SELECT rml.company, rml.rma_no, rml.rma_line_no, rml.fee_code, rml.qty_to_return, '||
               '             rml.price_conv_factor, rml.base_sale_unit_price '||
               '      FROM return_material_line_tab rml '||
               '      WHERE (rml.order_no IS NULL '||
               '            OR rml.debit_invoice_no IS NULL) '||
               '      AND Return_Material_Line_API.Get_Tax_Liability_Type_Db(rml.rma_no, rml.rma_line_no) != ''EXM'' '||
               '      AND STATUTORY_FEE_API.Get_Fee_Rate(rml.company, rml.fee_code) != 0 '||
               '      AND NOT EXISTS (SELECT 1 '||
               '                      FROM rma_line_tax_lines_tab rltl '||
               '                      WHERE rltl.rma_no = rml.rma_no '||
               '                      AND rltl.rma_line_no = rml.rma_line_no); '||

               '   CURSOR get_no_tax_ord_rma_lines IS '||
               '      SELECT * '||
               '      FROM return_material_line_tab rml '||
               '      WHERE (rml.order_no IS NOT NULL '||
               '            OR rml.debit_invoice_no IS NOT NULL) '||
               '      AND Return_Material_Line_API.Get_Tax_Liability_Type_Db(rml.rma_no, rml.rma_line_no) != ''EXM'' '||
               '      AND STATUTORY_FEE_API.Get_Fee_Rate(rml.company, rml.fee_code) != 0 '||
               '      AND NOT EXISTS (SELECT 1 '||
               '                      FROM rma_line_tax_lines_tab rltl '||
               '                      WHERE rltl.rma_no = rml.rma_no '||
               '                      AND rltl.rma_line_no = rml.rma_line_no) '||
               '      AND EXISTS (SELECT 1 '||
               '      FROM cust_order_line_tax_lines_tab co '||
               '      WHERE co.order_no = rml.order_no '||
               '      AND co.line_no = rml.line_no '||
               '      AND co.rel_no = rml.rel_no); '||

               'BEGIN '||
               '    FOR inv_rec_ IN get_no_inv_tax_rma_lines LOOP '||
               '      rounding_       := Currency_Code_API.Get_Currency_Rounding(inv_rec_.company, Return_Material_API.Get_Currency_Code(inv_rec_.rma_no)); '||
               '      tax_percentage_ := Statutory_Fee_API.Get_Percentage(inv_rec_.company, inv_rec_.fee_code); '||

               '         UPDATE rma_line_tax_lines_tab '||
               '           SET tax_percentage = tax_percentage_, '||
               '               tax_amount = ROUND(tax_percentage_ / 100 * ROUND(inv_rec_.qty_to_return * inv_rec_.price_conv_factor * inv_rec_.base_sale_unit_price, rounding_), rounding_) '||
               '           WHERE rma_no = inv_rec_.rma_no '||
               '           AND rma_line_no = inv_rec_.rma_line_no '||
               '           AND tax_id = inv_rec_.tax_id; '||
               '    END LOOP; '||

               '    parent_fee_code_ := ''''; '||
               '    tax_id_ := 1; '||
               '    rowversion_ := SYSDATE; '||

               '    FOR rec_ IN get_no_tax_rma_lines LOOP '||
               '       rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, Return_Material_API.Get_Currency_Code(rec_.rma_no)); '||
               '       tax_percentage_ := Statutory_Fee_API.Get_Percentage(rec_.company, rec_.fee_code); '||
               '       tax_amount_ := ROUND(tax_percentage_ / 100 * ROUND(rec_.qty_to_return * rec_.price_conv_factor * rec_.base_sale_unit_price, rounding_), rounding_); '||

               '       INSERT INTO rma_line_tax_lines_tab ( '||
               '          rma_no, '||
               '          rma_line_no, '||
               '          tax_id, '||
               '          fee_code, '||
               '          company, '||
               '          parent_fee_code, '||
               '          tax_percentage, '||
               '          tax_amount, '||
               '          rowversion) '||
               '       VALUES ( '||
               '          rec_.rma_no, '||
               '          rec_.rma_line_no, '||
               '          tax_id_, '||
               '          rec_.fee_code, '||
               '          rec_.company, '||
               '          parent_fee_code_, '||
               '          tax_percentage_, '||
               '          tax_amount_, '||
               '          rowversion_); '||

               '      tax_id_ := tax_id_ + 1; '||

               '    END LOOP; '||
               '    tax_id_ := 1; '||

               '    FOR ord_rec_ IN get_no_tax_ord_rma_lines LOOP '||
               '       rounding_ := Currency_Code_API.Get_Currency_Rounding(ord_rec_.company, Return_Material_API.Get_Currency_Code(ord_rec_.rma_no)); '||
               '       tax_percentage_ := Statutory_Fee_API.Get_Percentage(ord_rec_.company, ord_rec_.fee_code); '||
               '       tax_amount_ := ROUND(tax_percentage_ / 100 * ROUND(ord_rec_.qty_to_return * ord_rec_.price_conv_factor * ord_rec_.base_sale_unit_price, rounding_), rounding_); '||

               '       INSERT INTO rma_line_tax_lines_tab ( '||
               '          rma_no, '||
               '          rma_line_no, '||
               '          tax_id, '||
               '          fee_code, '||
               '          company, '||
               '          parent_fee_code, '||
               '          tax_percentage, '||
               '          tax_amount, '||
               '          rowversion) '||
               '       VALUES ( '||
               '          ord_rec_.rma_no, '||
               '          ord_rec_.rma_line_no, '||
               '          tax_id_, '||
               '          ord_rec_.fee_code, '||
               '          ord_rec_.company, '||
               '          parent_fee_code_, '||
               '          tax_percentage_, '||
               '          tax_amount_,  '||
               '          rowversion_);'||
               '      tax_id_ := tax_id_ + 1; '||

               '    END LOOP; '||
               '    COMMIT; '||
               'END;';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateRmaTaxLines.sql','Done');
PROMPT Finished with POST_ORDER_UpdateRmaTaxLines.sql
