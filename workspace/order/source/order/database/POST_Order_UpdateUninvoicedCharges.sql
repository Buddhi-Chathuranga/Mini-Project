--------------------------------------------------------------------------
--  File:      POST_ORDER_UpdateUninvoicedCharges.sql
--
--  Module:    ORDER
--
--  Function:  The purpose of this script is to change the state of the orders which are in state 'Invoiced' and has uninvoiced charges
--             into state 'Delivered'. The script should be executed after the upgrade. And it can be run multiple times.
--
--  Date    Sign     History
--  ------  -----    -----------------------------------------------------
--  160310  MeAblk   Bug 127480, Modified cursor compare absolute values of coc.invoiced_qty and coc.charged_qty to consider negative charged_qty.
--  150429  NWeelk   Bug 122325, Modified cursor get_order_no_rec to retrieve un-invoiced charge lines correctly
--  150429           by selecting records which has invoiced_qty less than charged_qty instead of using not equal sign.
--  141123  SeJalk   Bug 117462, Replaced the method call to New_Charge_Added() from  New_Or_Changed_Charge().
--  040607  MiKalk   Created.
--  ----------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateUninvoicedCharges.sql','Timestamp_1');
PROMPT Starting POST_ORDER_V1330_UpdateUninvoicedCharges.sql
DECLARE
   CURSOR get_order_no_rec IS
      SELECT co.order_no
      FROM   customer_order_tab co, customer_order_charge_tab coc
      WHERE  co.rowstate IN ('Invoiced')
      AND    co.order_no = coc.order_no
      AND    coc.line_no IS NULL
      AND    ABS(coc.invoiced_qty) < ABS(coc.charged_qty)
      AND    coc.collect != 'COLLECT';

BEGIN
   FOR rec IN get_order_no_rec LOOP
      Customer_Order_API.New_Or_Changed_Charge(rec.order_no);
   END LOOP;
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateUninvoicedCharges.sql','Timestamp_2');
PROMPT Finished with POST_ORDER_V1330_UpdateUninvoicedCharges.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateUninvoicedCharges.sql','Done');

