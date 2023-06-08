--------------------------------------------------------------------------
--  File:      POST_Order_UpdateQuotationLinePickingLeadtime.sql
--
--  Module:    ORDER
--
--  Function:  The purpose of this script is to update the order quotation lines with the correct picking lead time
--             for order_supply_type is 'Int Purch Trans' and 'Int Purch Dir'.
--             (picking_leadtime has already upgraded to -1 for order_supply_type in 'IPD', 'PD' by cdb/upg script)
--
--  Date    Sign     History
--  ------  -----    --------------------------------------------------------------------------------------------
--  201009  HaPulk   SC2020R1-10456, No need to check Table_Exist since all components are installed.
--  131004  MAHPLK   Created.
--  -------------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateQuotationLinePickingLeadtime.sql','Timestamp_1');
PROMPT Starting POST_Order_UpdateQuotationLinePickingLeadtime.sql

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateQuotationLinePickingLeadtime.sql','Timestamp_2');
PROMPT Updating column PICKING_LEADTIME in ORDER_QUOTATION_LINE_TAB FOR order_supply_type in IPD and PD.
DECLARE
   stmt_ VARCHAR2(32000);
BEGIN
   --IF (Database_SYS.Table_Exist('supplier_tab')) THEN
      stmt_ := 'UPDATE order_quotation_line_tab oql
                   SET picking_leadtime = NVL((SELECT picking_leadtime
                                                 FROM site_invent_info_tab
                                                WHERE contract IN (SELECT acquisition_site
                                                                     FROM supplier_tab
                                                                    WHERE vendor_no = oql.vendor_no)), 0)
                WHERE oql.picking_leadtime = -1 ';
      -- ifs_assert_safe MAHPLK 20131004
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   --END IF;
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_UpdateQuotationLinePickingLeadtime.sql','Done');
PROMPT Finished with POST_Order_UpdateQuotationLinePickingLeadtime.sql
