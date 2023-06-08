--------------------------------------------------------------------------
--  File:    POST_ORDER_UpdateOutstandingSalesCost.sql
--
--  Module:  ORDER
--
--  Purpose: Update the newly added column COST for the currentlty existing records in OUTSTANDING_SALES_TAB with the corresponding values and restore the qty_shipped column with correct values
--           which are currently having 0 due to a code error.
--
--  Date    Sign     History
--  ------  -----    --------------------------------------------------------------------------------------------
--  200923  MaRalk   SC2020R1-9694, Added 'SET SERVEROUTPUT ON' when preparing the file for 2020R1 Release.
--  171002  NaLrlk   STRSC-11306, Modified script to avoid updating cost and qty_shipped columns in outstanding_sales_tab into NULL.
--  170307  MeAblk   Bug 134044, Added.
--  -------------------------------------------------------------------------------------------------------------

SET SERVEROUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateOutstandingSalesCost.sql','Timestamp_1');
PROMPT Updating COST COLUMN IN outstanding_sales_tab

DECLARE
   TYPE Consignmt_Trans IS REF CURSOR;
   get_consignmt_trans_   Consignmt_Trans;

   TYPE consigmnt_trans_list_tab IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
   trans_list_ consigmnt_trans_list_tab;

   -- Getting the sales records which have consumptions
   CURSOR get_consignment_sales IS
      SELECT *
      FROM  outstanding_sales_tab
      WHERE deliv_no IN (SELECT source_ref5
                         FROM   inventory_transaction_hist_tab
                         WHERE  transaction_code = 'CO-CONSUME')
      ORDER BY outstanding_sales_id;


   i_    NUMBER;
   cost_ NUMBER;
BEGIN
   OPEN get_consignmt_trans_ FOR SELECT transaction_id
                                 FROM   inventory_transaction_hist_tab
                                 WHERE  transaction_code = 'CO-CONSUME'
                                 ORDER  BY source_ref5, transaction_id;


   FETCH get_consignmt_trans_ BULK COLLECT INTO trans_list_;
   CLOSE get_consignmt_trans_;

   i_ := 1;
   FOR outstanding_sales_rec_ IN  get_consignment_sales LOOP
      cost_ := Inventory_Transaction_Hist_API.Get_Cost(trans_list_(i_));

      UPDATE outstanding_sales_tab
      SET cost = cost_
      WHERE outstanding_sales_id = outstanding_sales_rec_.outstanding_sales_id
      AND cost = -99999999.99;
      i_ := i_ + 1;
   END LOOP;

   UPDATE outstanding_sales_tab a
   SET a.cost = (SELECT cost
                 FROM customer_order_delivery_tab b
                 WHERE b.deliv_no = a.deliv_no)
   WHERE a.deliv_no NOT IN (SELECT source_ref5
                            FROM inventory_transaction_hist_tab
                            WHERE transaction_code = 'CO-CONSUME')
   AND a.cost = -99999999.99
   AND EXISTS (SELECT 1 
               FROM customer_order_delivery_tab 
               WHERE deliv_no = a.deliv_no);

   UPDATE outstanding_sales_tab a
   SET a.cost = (SELECT c.cost
                 FROM customer_order_delivery_tab b, customer_order_line_tab c
                 WHERE b.deliv_no     = a.deliv_no
                 AND   b.order_no     = c.order_no
                 AND   b.line_no      = c.line_no
                 AND   b.rel_no       = c.rel_no
                 AND   b.line_item_no = c.line_item_no)
   WHERE a.cost = -99999999.99
   AND EXISTS (SELECT 1 
               FROM customer_order_delivery_tab 
               WHERE deliv_no = a.deliv_no);
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateOutstandingSalesCost.sql','Timestamp_2');
PROMPT restoring VALUES IN qty_shipped COLUMN IN OUTSTANDING_SALES_TAB which are having 0.

BEGIN
   UPDATE outstanding_sales_tab a
   SET a.qty_shipped = (SELECT (a.qty_expected/c.conv_factor * c.inverted_conv_factor)
                        FROM    customer_order_delivery_tab b, customer_order_line_tab c
                        WHERE   b.deliv_no     = a.deliv_no
                        AND     b.order_no     = c.order_no
                        AND     b.line_no      = c.line_no
                        AND     b.rel_no       = c.rel_no
                        AND     b.line_item_no = c.line_item_no)
   WHERE a.qty_shipped = 0 AND a.qty_expected != 0
   AND EXISTS (SELECT 1 
               FROM customer_order_delivery_tab 
               WHERE deliv_no = a.deliv_no);

   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateOutstandingSalesCost.sql','Done');
PROMPT Finished with POST_ORDER_UpdateOutstandingSalesCost.sql





