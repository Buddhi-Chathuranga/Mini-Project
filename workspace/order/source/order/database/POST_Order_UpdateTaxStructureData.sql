-----------------------------------------------------------------------------
--  Module : ORDER
--
--  File   : POST_Order_UpdateTaxStructureData.sql
--
--  Purpose:  Below updates will be handled in this script.
--            1. Copy tax_calc_structure_id from tax_code_struct_id_1410 in
--                1. CUSTOMER_ORDER_LINE_TAB
--                2. CUSTOMER_ORDER_CHARGE_TAB
--                3. ORDER_QUOTATION_LINE_TAB
--                4. ORDER_QUOTATION_CHARGE_TAB
--                5. RETURN_MATERIAL_LINE_TAB
--                6. RETURN_MATERIAL_CHARGE_TAB
--            2. Move Tax Structure data (tax_code_struct_id, tax_code_struct_item_id and tax_base_amount) from ORDER tax storages to source_tax_item_tab in ACCRUL.
--                ORDER Tax storages were :
--                1. CUST_ORD_LINE_TAX_STRUCT_TAB
--                2. CUST_ORD_CHARGE_TAX_STRUCT_TAB
--                3. QUOTE_LINE_TAX_STRUCT_TAB
--                4. QUOTE_CHARGE_TAX_LINES_TAB
--                5. RMA_LINE_TAX_STRUCT_TAB
--                6. RMA_CHARGE_TAX_STRUCT_TAB
--            3. Copy manual_tax_base_amount from unit_manual_base_amount_1410 in
--                CUSTOMER_ORDER_LINE_TAB
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  180514   NWeelk  Created. gelr: Added to support Global Extension Functionalities.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
DEFINE MODULE = 'ORDER'


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_1');
PROMPT Starting POST_Order_UpdateTaxStructureData.SQL

---------------------------------------------------------------------------------------------

-- ***** CUSTOMER_ORDER_LINE_TAB Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_2');
PROMPT Moving data from tax_code_struct_id_1410 to tax_calc_structure_id.

DECLARE
   table_name_  VARCHAR2(30)  := 'CUSTOMER_ORDER_LINE_TAB';
   column_name_ VARCHAR2(30)  := 'TAX_CODE_STRUCT_ID_1410';
   stmt_        VARCHAR2(2000);
BEGIN   
   IF (Database_SYS.Column_Exist(table_name_, column_name_)) THEN
     stmt_ := 'UPDATE CUSTOMER_ORDER_LINE_TAB '||
              'SET tax_calc_structure_id = tax_code_struct_id_1410 '||
              'WHERE tax_code_struct_id_1410 IS NOT NULL '||
              'AND   tax_calc_structure_id IS NULL';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_3');
PROMPT Moving data from unit_manual_base_amount_1410 to manual_tax_base_amount.

DECLARE
   table_name_  VARCHAR2(30)  := 'CUSTOMER_ORDER_LINE_TAB';
   column_name_ VARCHAR2(30)  := 'UNIT_MANUAL_BASE_AMOUNT_1410';
   stmt_        VARCHAR2(2000);
BEGIN   
   IF (Database_SYS.Column_Exist(table_name_, column_name_)) THEN
     stmt_ := 'UPDATE CUSTOMER_ORDER_LINE_TAB '||
              'SET manual_tax_base_amount = unit_manual_base_amount_1410 '||
              'WHERE unit_manual_base_amount_1410 IS NOT NULL '||
              'AND   manual_tax_base_amount IS NULL';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_4');
PROMPT Moving data from cust_ord_line_tax_struc_1410 to source_tax_item_tab.

DECLARE
   struct_tab_  VARCHAR2(30)  := 'cust_ord_line_tax_struc_1410';
   stmt_        VARCHAR(32000);
BEGIN   
   IF (Database_SYS.Table_Exist(struct_tab_)) THEN
      stmt_ := 'DECLARE
                     CURSOR get_source_info IS
                        SELECT  co.order_no, co.line_no, co.rel_no, co.line_item_no, co.tax_calc_structure_id, co.currency_rate,
                                t.tax_code_struct_item_id, t.tax_base_amount, s.tax_item_id, s.company, s.tax_base_curr_amount
                        FROM customer_order_line_tab co, source_tax_item_tab s, cust_ord_line_tax_struc_1410 t
                           WHERE co.order_no              = s.source_ref1
                           AND   co.line_no               = s.source_ref2
                           AND   co.rel_no                = s.source_ref3
                           AND   TO_CHAR(co.line_item_no) = s.source_ref4
                           AND   co.order_no              = t.order_no
                           AND   co.line_no               = t.line_no
                           AND   co.rel_no                = t.rel_no
                           AND   co.line_item_no          = t.line_item_no
                           AND   s.company                = t.company
                           AND   co.tax_calc_structure_id IS NOT NULL
                           AND   co.tax_calc_structure_id = t.tax_code_struct_id
                           AND   s.tax_code               = t.fee_code
                           AND   s.tax_percentage         = t.tax_percentage
                           AND   s.tax_dom_amount         = t.tax_amount;

                     TYPE tax_str_info_table IS TABLE OF get_source_info%ROWTYPE INDEX BY BINARY_INTEGER;
                     tax_tab_     tax_str_info_table;
                     bulk_limit_  CONSTANT NUMBER := 10000;
                     rounding_    NUMBER;
               BEGIN
                  OPEN get_source_info;
                  LOOP
                     FETCH get_source_info BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
                     IF tax_tab_.COUNT > 0 THEN
                        FOR i_ IN tax_tab_.FIRST..tax_tab_.LAST LOOP
                           rounding_   := Currency_Code_API.Get_Currency_Rounding(tax_tab_(i_).company, Company_Finance_API.Get_Currency_Code(tax_tab_(i_).company));
                           IF tax_tab_(i_).currency_rate = 0 THEN
                              tax_tab_(i_).currency_rate := 1;
                           END IF;
                           tax_tab_(i_).tax_base_curr_amount  :=  ROUND(NVL(tax_tab_(i_).tax_base_amount, 0) / NVL(tax_tab_(i_).currency_rate, 1), rounding_);
                        END LOOP;
                        FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
                           UPDATE source_tax_item_tab
                           SET    tax_calc_structure_id      = tax_tab_(i_).tax_calc_structure_id,
                                  tax_calc_structure_item_id = tax_tab_(i_).tax_code_struct_item_id,
                                  tax_base_curr_amount       = NVL(tax_tab_(i_).tax_base_curr_amount, 0),
                                  tax_base_dom_amount        = NVL(tax_tab_(i_).tax_base_amount, 0)
                           WHERE  company = tax_tab_(i_).company
                           AND    source_ref1 = tax_tab_(i_).order_no
                           AND    source_ref2 = tax_tab_(i_).line_no
                           AND    source_ref3 = tax_tab_(i_).rel_no
                           AND    source_ref4 = tax_tab_(i_).line_item_no
                           AND    source_ref5 = ''*''
                           AND    source_ref_type = ''CUSTOMER_ORDER_LINE''
                           AND    tax_item_id = tax_tab_(i_).tax_item_id;
                     END IF;
                     EXIT WHEN get_source_info%NOTFOUND;
                  END LOOP;
                  CLOSE get_source_info;
                  COMMIT;
               END;
               ';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/
-- ***** CUSTOMER_ORDER_LINE_TAB End *****

-- ***** CUSTOMER_ORDER_CHARGE_TAB Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_5');
PROMPT Moving data from tax_code_struct_id_1410 to tax_calc_structure_id.

DECLARE
   table_name_  VARCHAR2(30)  := 'CUSTOMER_ORDER_CHARGE_TAB';
   column_name_ VARCHAR2(30)  := 'TAX_CODE_STRUCT_ID_1410';
   stmt_        VARCHAR2(2000);
BEGIN   
   IF (Database_SYS.Column_Exist(table_name_, column_name_)) THEN
     stmt_ := 'UPDATE CUSTOMER_ORDER_CHARGE_TAB '||
              'SET tax_calc_structure_id = tax_code_struct_id_1410 '||
              'WHERE tax_code_struct_id_1410 IS NOT NULL '||
              'AND   tax_calc_structure_id IS NULL ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_6');
PROMPT Moving data from cust_ord_charge_tax_struc_1410 to source_tax_item_tab.

DECLARE
   tax_tab_     VARCHAR2(30)  := 'cust_ord_charge_tax_lines_1500';
   struct_tab_  VARCHAR2(30)  := 'cust_ord_charge_tax_struc_1410';
   stmt_        VARCHAR(32000);
BEGIN   
   IF (Database_SYS.Table_Exist(tax_tab_) AND Database_SYS.Table_Exist(struct_tab_)) THEN
      stmt_ := 'DECLARE
                     CURSOR get_source_info IS
                        SELECT  oc.order_no, oc.sequence_no, oc.tax_calc_structure_id, s.fee_code,
                                t.tax_code_struct_item_id, s.tax_id, s.company
                        FROM customer_order_charge_tab oc, cust_ord_charge_tax_lines_1500 s, cust_ord_charge_tax_struc_1410 t
                        WHERE   s.order_no     = oc.order_no
                          AND   s.sequence_no  = oc.sequence_no
                          AND   oc.order_no    = t.order_no
                          AND   oc.sequence_no = t.sequence_no
                          AND   s.company      = t.company
                          AND   oc.tax_calc_structure_id IS NOT NULL
                          AND   oc.tax_calc_structure_id = t.tax_code_struct_id
                          AND   s.fee_code               = t.fee_code
                          AND   s.tax_amount             = t.tax_amount;

                     TYPE tax_str_info_table IS TABLE OF get_source_info%ROWTYPE INDEX BY BINARY_INTEGER;
                     tax_tab_     tax_str_info_table;
                     bulk_limit_  CONSTANT NUMBER := 10000;

               BEGIN
                  OPEN get_source_info;
                  LOOP
                     FETCH get_source_info BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
                     IF tax_tab_.COUNT > 0 THEN
                     FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
                           UPDATE source_tax_item_tab
                           SET    tax_calc_structure_id      = tax_tab_(i_).tax_calc_structure_id,
                                  tax_calc_structure_item_id = tax_tab_(i_).tax_code_struct_item_id
                           WHERE  company = tax_tab_(i_).company
                           AND    source_ref1 = tax_tab_(i_).order_no
                           AND    source_ref2 = tax_tab_(i_).sequence_no
                           AND    source_ref3 = ''*''
                           AND    source_ref4 = ''*''
                           AND    source_ref5 = ''*''
                           AND    source_ref_type = ''CUSTOMER_ORDER_CHARGE''
                           AND    tax_item_id = tax_tab_(i_).tax_id;
                     END IF;
                     EXIT WHEN get_source_info%NOTFOUND;
                  END LOOP;
                  CLOSE get_source_info;
                  COMMIT;
               END;
               ';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/
-- ***** CUSTOMER_ORDER_CHARGE_TAB End *****

-- ***** ORDER_QUOTATION_LINE_TAB Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_7');
PROMPT Moving data from tax_code_struct_id_1410 to tax_calc_structure_id.

DECLARE
   table_name_  VARCHAR2(30)  := 'ORDER_QUOTATION_LINE_TAB';
   column_name_ VARCHAR2(30)  := 'TAX_CODE_STRUCT_ID_1410';
   stmt_        VARCHAR2(2000);
BEGIN   
   IF (Database_SYS.Column_Exist(table_name_, column_name_)) THEN
     stmt_ := 'UPDATE ORDER_QUOTATION_LINE_TAB '||
              'SET tax_calc_structure_id = tax_code_struct_id_1410 '||
              'WHERE tax_code_struct_id_1410 IS NOT NULL '||
              'AND   tax_calc_structure_id IS NULL ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_8');
PROMPT Moving data from quote_line_tax_struct_1410 to source_tax_item_tab.

DECLARE
   struct_tab_  VARCHAR2(30)  := 'quote_line_tax_struct_1410';
   stmt_        VARCHAR(32000);
BEGIN   
   IF (Database_SYS.Table_Exist(struct_tab_)) THEN
      stmt_ := 'DECLARE
                     CURSOR get_source_info IS
                        SELECT  oq.quotation_no, oq.line_no, oq.rel_no, oq.line_item_no, oq.tax_calc_structure_id, oq.currency_rate,
                                t.tax_code_struct_item_id, t.tax_base_amount, s.tax_item_id, s.company, s.tax_base_curr_amount
                        FROM order_quotation_line_tab oq, source_tax_item_tab s, quote_line_tax_struct_1410 t
                           WHERE oq.quotation_no          = s.source_ref1
                           AND   oq.line_no               = s.source_ref2
                           AND   oq.rel_no                = s.source_ref3
                           AND   TO_CHAR(oq.line_item_no) = s.source_ref4
                           AND   oq.quotation_no          = t.quotation_no
                           AND   oq.line_no               = t.line_no
                           AND   oq.rel_no                = t.rel_no
                           AND   oq.line_item_no          = t.line_item_no
                           AND   s.company                = t.company
                           AND   oq.tax_calc_structure_id IS NOT NULL
                           AND   oq.tax_calc_structure_id = t.tax_code_struct_id
                           AND   s.tax_code               = t.fee_code
                           AND   s.tax_percentage         = t.tax_percentage;

                     TYPE tax_str_info_table IS TABLE OF get_source_info%ROWTYPE INDEX BY BINARY_INTEGER;
                     tax_tab_     tax_str_info_table;
                     bulk_limit_  CONSTANT NUMBER := 10000;
                     rounding_    NUMBER;
               BEGIN
                  OPEN get_source_info;
                  LOOP
                     FETCH get_source_info BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
                     IF tax_tab_.COUNT > 0 THEN
                        FOR i_ IN tax_tab_.FIRST..tax_tab_.LAST LOOP
                           rounding_   := Currency_Code_API.Get_Currency_Rounding(tax_tab_(i_).company, Company_Finance_API.Get_Currency_Code(tax_tab_(i_).company));
                           IF tax_tab_(i_).currency_rate = 0 THEN
                              tax_tab_(i_).currency_rate := 1;
                           END IF;
                           tax_tab_(i_).tax_base_curr_amount  :=  ROUND(NVL(tax_tab_(i_).tax_base_amount, 0) / NVL(tax_tab_(i_).currency_rate, 1), rounding_);
                        END LOOP;
                        FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
                           UPDATE source_tax_item_tab
                           SET    tax_calc_structure_id      = tax_tab_(i_).tax_calc_structure_id,
                                  tax_calc_structure_item_id = tax_tab_(i_).tax_code_struct_item_id,
                                  tax_base_curr_amount       = NVL(tax_tab_(i_).tax_base_curr_amount, 0),
                                  tax_base_dom_amount        = NVL(tax_tab_(i_).tax_base_amount, 0)
                           WHERE  company = tax_tab_(i_).company
                           AND    source_ref1 = tax_tab_(i_).quotation_no
                           AND    source_ref2 = tax_tab_(i_).line_no
                           AND    source_ref3 = tax_tab_(i_).rel_no
                           AND    source_ref4 = tax_tab_(i_).line_item_no
                           AND    source_ref5 = ''*''
                           AND    source_ref_type = ''ORDER_QUOTATION_LINE''
                           AND    tax_item_id = tax_tab_(i_).tax_item_id;
                     END IF;
                     EXIT WHEN get_source_info%NOTFOUND;
                  END LOOP;
                  CLOSE get_source_info;
                  COMMIT;
               END;
               ';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/
-- ***** ORDER_QUOTATION_LINE_TAB End *****

-- ***** ORDER_QUOTATION_CHARGE_TAB Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_9');
PROMPT Moving data from tax_code_struct_id_1410 to tax_calc_structure_id.

DECLARE
   table_name_  VARCHAR2(30)  := 'ORDER_QUOTATION_CHARGE_TAB';
   column_name_ VARCHAR2(30)  := 'TAX_CODE_STRUCT_ID_1410';
   stmt_        VARCHAR2(2000);
BEGIN   
   IF (Database_SYS.Column_Exist(table_name_, column_name_)) THEN
     stmt_ := 'UPDATE ORDER_QUOTATION_CHARGE_TAB '||
              'SET tax_calc_structure_id = tax_code_struct_id_1410 '||
              'WHERE tax_code_struct_id_1410 IS NOT NULL '||
              'AND   tax_calc_structure_id IS NULL ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_10');
PROMPT Moving data from quote_charge_tax_struc_1410 to source_tax_item_tab.

DECLARE
   tax_tab_     VARCHAR2(30)  := 'quote_charge_tax_lines_1500';
   struct_tab_  VARCHAR2(30)  := 'quote_charge_tax_struc_1410';
   stmt_        VARCHAR(32000);
BEGIN
   IF (Database_SYS.Table_Exist(tax_tab_) AND Database_SYS.Table_Exist(struct_tab_)) THEN
      stmt_ := 'DECLARE
                     CURSOR get_source_info IS
                        SELECT  oq.quotation_no, oq.quotation_charge_no, oq.tax_calc_structure_id, s.fee_code,
                                t.tax_code_struct_item_id, t.tax_base_amount, s.tax_id, s.company
                        FROM order_quotation_charge_tab oq, quote_charge_tax_lines_1500 s, quote_charge_tax_struc_1410 t
                        WHERE   s.quotation_no         = oq.quotation_no
                          AND   s.quotation_charge_no  = oq.quotation_charge_no
                          AND   oq.quotation_no        = t.quotation_no
                          AND   oq.quotation_charge_no = t.quotation_charge_no
                          AND   s.company              = t.company
                          AND   oq.tax_calc_structure_id IS NOT NULL
                          AND   oq.tax_calc_structure_id = t.tax_code_struct_id
                          AND   s.fee_code               = t.fee_code
                          AND   s.tax_amount_1410        = t.tax_amount;

                     TYPE tax_str_info_table IS TABLE OF get_source_info%ROWTYPE INDEX BY BINARY_INTEGER;
                     tax_tab_     tax_str_info_table;
                     bulk_limit_  CONSTANT NUMBER := 10000;

               BEGIN
                  OPEN get_source_info;
                  LOOP
                     FETCH get_source_info BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
                     IF tax_tab_.COUNT > 0 THEN
                     FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
                           UPDATE source_tax_item_tab
                           SET    tax_calc_structure_id      = tax_tab_(i_).tax_calc_structure_id,
                                  tax_calc_structure_item_id = tax_tab_(i_).tax_code_struct_item_id
                           WHERE  company = tax_tab_(i_).company
                           AND    source_ref1 = tax_tab_(i_).quotation_no
                           AND    source_ref2 = tax_tab_(i_).quotation_charge_no
                           AND    source_ref3 = ''*''
                           AND    source_ref4 = ''*''
                           AND    source_ref5 = ''*''
                           AND    source_ref_type = ''ORDER_QUOTATION_CHARGE''
                           AND    tax_item_id = tax_tab_(i_).tax_id;
                     END IF;
                     EXIT WHEN get_source_info%NOTFOUND;
                  END LOOP;
                  CLOSE get_source_info;
                  COMMIT;
               END;
               ';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/
-- ***** ORDER_QUOTATION_CHARGE_TAB End *****

-- ***** RETURN_MATERIAL_LINE_TAB Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_11');
PROMPT Moving data from tax_code_struct_id_1410 to tax_calc_structure_id.

DECLARE
   table_name_  VARCHAR2(30)  := 'RETURN_MATERIAL_LINE_TAB';
   column_name_ VARCHAR2(30)  := 'TAX_CODE_STRUCT_ID_1410';
   stmt_        VARCHAR2(2000);
BEGIN
   IF (Database_SYS.Column_Exist(table_name_, column_name_)) THEN
     stmt_ := 'UPDATE RETURN_MATERIAL_LINE_TAB '||
              'SET tax_calc_structure_id = tax_code_struct_id_1410 '||
              'WHERE tax_code_struct_id_1410 IS NOT NULL '||
              'AND   tax_calc_structure_id IS NULL ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_12');
PROMPT Moving data from rma_line_tax_struct_1410 to source_tax_item_tab.

DECLARE
   struct_tab_  VARCHAR2(30)  := 'rma_line_tax_struct_1410';
   stmt_        VARCHAR(32000);
BEGIN   
   IF (Database_SYS.Table_Exist(struct_tab_)) THEN
      stmt_ := 'DECLARE
                     CURSOR get_source_info IS
                        SELECT  rma.rma_no, rma.rma_line_no, rma.tax_calc_structure_id, rma.currency_rate,
                                t.tax_code_struct_item_id, t.tax_base_amount, s.tax_item_id, s.company, s.tax_base_curr_amount
                        FROM return_material_line_tab rma, source_tax_item_tab s, rma_line_tax_struct_1410 t
                           WHERE TO_CHAR(rma.rma_no)      = s.source_ref1
                           AND   TO_CHAR(rma.rma_line_no) = s.source_ref2
                           AND   rma.rma_no               = t.rma_no
                           AND   rma.rma_line_no          = t.rma_line_no
                           AND   s.company                = t.company
                           AND   rma.tax_calc_structure_id IS NOT NULL
                           AND   rma.tax_calc_structure_id = t.tax_code_struct_id
                           AND   s.tax_code                = t.fee_code
                           AND   s.tax_percentage          = t.tax_percentage;

                     TYPE tax_str_info_table IS TABLE OF get_source_info%ROWTYPE INDEX BY BINARY_INTEGER;
                     tax_tab_     tax_str_info_table;
                     bulk_limit_  CONSTANT NUMBER := 10000;
                     rounding_    NUMBER;
               BEGIN
                  OPEN get_source_info;
                  LOOP
                     FETCH get_source_info BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
                     IF tax_tab_.COUNT > 0 THEN
                        FOR i_ IN tax_tab_.FIRST..tax_tab_.LAST LOOP
                           rounding_   := Currency_Code_API.Get_Currency_Rounding(tax_tab_(i_).company, Company_Finance_API.Get_Currency_Code(tax_tab_(i_).company));
                           IF tax_tab_(i_).currency_rate = 0 THEN
                              tax_tab_(i_).currency_rate := 1;
                           END IF;
                           tax_tab_(i_).tax_base_curr_amount  :=  ROUND(NVL(tax_tab_(i_).tax_base_amount, 0) / NVL(tax_tab_(i_).currency_rate, 1), rounding_);
                        END LOOP;
                        FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
                           UPDATE source_tax_item_tab
                           SET    tax_calc_structure_id      = tax_tab_(i_).tax_calc_structure_id,
                                  tax_calc_structure_item_id = tax_tab_(i_).tax_code_struct_item_id,
                                  tax_base_curr_amount       = NVL(tax_tab_(i_).tax_base_curr_amount, 0),
                                  tax_base_dom_amount        = NVL(tax_tab_(i_).tax_base_amount, 0)
                           WHERE  company = tax_tab_(i_).company
                           AND    source_ref1 = tax_tab_(i_).rma_no
                           AND    source_ref2 = tax_tab_(i_).rma_line_no
                           AND    source_ref3 = ''*''
                           AND    source_ref4 = ''*''
                           AND    source_ref5 = ''*''
                           AND    source_ref_type = ''RETURN_MATERIAL_LINE''
                           AND    tax_item_id = tax_tab_(i_).tax_item_id;
                     END IF;
                     EXIT WHEN get_source_info%NOTFOUND;
                  END LOOP;
                  CLOSE get_source_info;
                  COMMIT;
               END;
               ';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/
-- ***** RETURN_MATERIAL_LINE_TAB End *****

-- ***** RETURN_MATERIAL_CHARGE_TAB End Start

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_13');
PROMPT Moving data from tax_code_struct_id_1410 to tax_calc_structure_id.

DECLARE
   table_name_  VARCHAR2(30)  := 'RETURN_MATERIAL_CHARGE_TAB';
   column_name_ VARCHAR2(30)  := 'TAX_CODE_STRUCT_ID_1410';
   stmt_        VARCHAR2(2000);
BEGIN   
   IF (Database_SYS.Column_Exist(table_name_, column_name_)) THEN
     stmt_ := 'UPDATE RETURN_MATERIAL_CHARGE_TAB '||
              'SET tax_calc_structure_id = tax_code_struct_id_1410 '||
              'WHERE tax_code_struct_id_1410 IS NOT NULL '||
              'AND   tax_calc_structure_id IS NULL ';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Timestamp_14');
PROMPT Moving data from rma_charge_tax_struct_1410 to source_tax_item_tab.

DECLARE
   tax_tab_     VARCHAR2(30)  := 'rma_charge_tax_lines_1500';
   struct_tab_  VARCHAR2(30)  := 'rma_charge_tax_struct_1410';
   stmt_        VARCHAR(32000);
BEGIN   
   IF (Database_SYS.Table_Exist(tax_tab_) AND Database_SYS.Table_Exist(struct_tab_)) THEN
      stmt_ := 'DECLARE
                     CURSOR get_source_info IS
                        SELECT  rmc.rma_no, rmc.rma_charge_no, rmc.tax_calc_structure_id, s.fee_code,
                                t.tax_code_struct_item_id, t.tax_base_amount, s.tax_id, s.company
                        FROM return_material_charge_tab rmc, rma_charge_tax_lines_1500 s, rma_charge_tax_struct_1410 t
                        WHERE   s.rma_no          = rmc.rma_no
                          AND   s.rma_charge_no   = rmc.rma_charge_no
                          AND   rmc.rma_no        = t.rma_no
                          AND   rmc.rma_charge_no = t.rma_charge_no
                          AND   s.company         = t.company
                          AND   rmc.tax_calc_structure_id IS NOT NULL
                          AND   rmc.tax_calc_structure_id = t.tax_code_struct_id
                          AND   s.fee_code                = t.fee_code
                          AND   s.tax_amount              = t.tax_amount;

                     TYPE tax_str_info_table IS TABLE OF get_source_info%ROWTYPE INDEX BY BINARY_INTEGER;
                     tax_tab_     tax_str_info_table;
                     bulk_limit_  CONSTANT NUMBER := 10000;

               BEGIN
                  OPEN get_source_info;
                  LOOP
                     FETCH get_source_info BULK COLLECT INTO tax_tab_ LIMIT bulk_limit_;
                     IF tax_tab_.COUNT > 0 THEN
                     FORALL i_ IN tax_tab_.FIRST..tax_tab_.LAST
                           UPDATE source_tax_item_tab
                           SET    tax_calc_structure_id      = tax_tab_(i_).tax_calc_structure_id,
                                  tax_calc_structure_item_id = tax_tab_(i_).tax_code_struct_item_id
                           WHERE  company = tax_tab_(i_).company
                           AND    source_ref1 = tax_tab_(i_).rma_no
                           AND    source_ref2 = tax_tab_(i_).rma_charge_no
                           AND    source_ref3 = ''*''
                           AND    source_ref4 = ''*''
                           AND    source_ref5 = ''*''
                           AND    source_ref_type = ''RETURN_MATERIAL_CHARGE''
                           AND    tax_item_id = tax_tab_(i_).tax_id;
                     END IF;
                     EXIT WHEN get_source_info%NOTFOUND;
                  END LOOP;
                  CLOSE get_source_info;
                  COMMIT;
               END;
               ';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/
-- ***** RETURN_MATERIAL_CHARGE_TAB End *****

---------------------------------------------------------------------------------------------
UNDEFINE MODULE

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateTaxStructureData.sql','Done');
PROMPT Finished with POST_Order_UpdateTaxStructureData.SQL
