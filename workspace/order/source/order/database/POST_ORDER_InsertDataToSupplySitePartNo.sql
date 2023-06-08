-----------------------------------------------------------------------------
--  Module : ORDER
--
--  File   : POST_ORDER_InsertDataToSupplySitePartNo.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  201202   PamPlk  Bug 154128(SCZ-12746), Passed the catalog_no instead of part_no to the method call. Restructured the script.
--  200923   MaRalk  SC2020R1-9694, Removed Patch Registration when preparing the file for 2020R1 Release.
--  200303   BudKlk  Bug 151684(SCZ-9277), Insert Data to newely added field SUPPLY_SITE_PART_NO.
--  200303           Column SUPPLY_SITE_PART_NO and the CUSTOMER_ORDER_LINE_IX8 index was inserted using the cdb 200113_151684_Order.cdb. 
--  200303           The patch registration was done using this post script.
--  ------   ------  ----------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_InsertDataToSupplySitePartNo.sql','Timestamp_1');
PROMPT Starting POST_ORDER_InsertDataToSupplySitePartNo.SQL

BEGIN   
   IF Database_SYS.Column_Exist('CUSTOMER_ORDER_LINE_TAB', 'SUPPLY_SITE_PART_NO') THEN
      
      UPDATE customer_order_line_tab
         SET supply_site_part_no = Sales_Part_API.Get_Supply_Site_Part_No__(supply_site, contract, catalog_no, vendor_no)
       WHERE supply_code IN ('IPT', 'IPD')
         AND rowstate NOT IN ('Cancelled', 'Invoiced');
      
      COMMIT;
      -- Column SUPPLY_SITE_PART_NO and the CUSTOMER_ORDER_LINE_IX8 index was inserted using the cdb 200303_151684_Order.cdb.
   END IF;   
END;
/
PROMPT Finished with POST_ORDER_InsertDataToSupplySitePartNo.sql
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_InsertDataToSupplySitePartNo.sql','Done');
