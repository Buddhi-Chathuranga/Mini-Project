-----------------------------------------------------------------------------
--  Module : ORDER
--
--  File   : POST_ORDER_UpdateCustomerOrderCharge.sql
--  
--  Purpose       : Updated columns charge_amount_incl_tax & base_charge_amt_incl_tax in customer_order_charge_tab to
--                  to fetch correct tax percentage from source_tax_item_tab to fix bug 139522.
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  200923   MaRalk  SC2020R1-9694, Removed 'SET SERVEROUTPUT OFF' when preparing the file for 2020R1 Release.
--  180103   IzShlk  STRSC-15424, Updated columns charge_amount_incl_tax & base_charge_amt_incl_tax in customer_order_charge_tab. 
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateCustomerOrderCharge.sql','Timestamp_1');
PROMPT Starting POST_ORDER_UpdateCustomerOrderCharge.SQL

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateCustomerOrderCharge.sql','Timestamp_2');
PROMPT Update columns CHARGE_AMOUNT_INCL_TAX, BASE_CHARGE_AMT_INCL_TAXIN CUSTOMER_ORDER_CHARGE_TAB
BEGIN
   UPDATE customer_order_charge_tab coch
      SET   charge_amount_incl_tax     =  charge_amount * ((NVL(( SELECT SUM(sti.tax_percentage)
                                                                  FROM source_tax_item_tab sti 
                                                                  WHERE sti.source_ref_type = 'CUSTOMER_ORDER_CHARGE'  
                                                                  AND   sti.company     = coch.company
                                                                  AND	sti.source_ref1 = coch.order_no
                                                                  AND   sti.source_ref2 = coch.sequence_no
                                                                  AND   sti.source_ref3 = '*'
                                                                  AND   sti.source_ref4 = '*'
                                                                  AND   sti.source_ref5 = '*'), 0)/100) + 1),
            base_charge_amt_incl_tax   =  base_charge_amount * ((NVL(( SELECT SUM(sti.tax_percentage)
                                                                       FROM source_tax_item_tab sti
                                                                       WHERE sti.source_ref_type = 'CUSTOMER_ORDER_CHARGE'  
                                                                       AND   sti.company     = coch.company 
                                                                       AND	  sti.source_ref1 = coch.order_no
                                                                       AND   sti.source_ref2 = coch.sequence_no
                                                                       AND   sti.source_ref3 = '*'
                                                                       AND   sti.source_ref4 = '*'
                                                                       AND   sti.source_ref5 = '*'), 0)/100) + 1)
      WHERE ((coch.charge_amount IS NOT NULL) OR (coch.base_charge_amount IS NOT NULL))
      AND   EXISTS 
            (
               SELECT *
               FROM  company_tax_control_tab ctc
               WHERE coch.company = ctc.company 
               AND   ctc.external_tax_cal_method != 'NOT_USED'
            );
      COMMIT;
END;
/

PROMPT Finished POST_ORDER_UpdateCustomerOrderCharge.SQL
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_UpdateCustomerOrderCharge.sql','Done');

