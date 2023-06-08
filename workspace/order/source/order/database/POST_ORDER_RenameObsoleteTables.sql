--
--  File        : POST_ORDER_RenameObsoleteTables.sql
--
--  Module      : ORDER 14.1.0
--
--  Usage       : Rename obsolete tables after the whole installation because of the references to rest of the components.
--
--  Date    Sign    History
--  ------  -----   --------------------------------------------------------------------------------------------
--  151012  SUSALK  STRSC-79, Modified the suffix to _1410 instead of _1420.
--  150525  CHFOLK  Created.
----------------------------------------------------------------------------------------------------------------

SET SERVEROUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_RenameObsoleteTables.sql','Timestamp_1');
PROMPT Starting POST_ORDER_RenameObsoleteTables.sql

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_RenameObsoleteTables.sql','Timestamp_2');
PROMPT Renaming obsolete tables CUSTOMER_ORDER_ROUTE_TAB, CUST_ORDER_ROUTE_SCHEDULE_TAB and CUST_ORDER_ROUTE_EXCEPTION_TAB.
BEGIN
   Database_SYS.Rename_Table('CUSTOMER_ORDER_ROUTE_TAB','CUSTOMER_ORDER_ROUTE_1410', TRUE);
   Database_SYS.Rename_Table('CUST_ORDER_ROUTE_SCHEDULE_TAB','CUST_ORDER_ROUTE_SCHEDULE_1410', TRUE);
   Database_SYS.Rename_Table('CUST_ORDER_ROUTE_EXCEPTION_TAB','CUST_ORDER_ROUTE_EXCEPTN_1410', TRUE);
END;
/
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_RenameObsoleteTables.sql','Done');
PROMPT Finished with POST_ORDER_RenameObsoleteTables.sql
