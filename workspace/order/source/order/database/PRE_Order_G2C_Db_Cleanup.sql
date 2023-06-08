-------------------------------------------------------------------------------------------------
--  Module  : ORDER
--
--  Purpose : This file is intended to execute at the begining of the upgrade, if upgrading from a GET version
--            Cleans up the DB Objects exclusive to GET versions
--
--  File    : PRE_Order_G2C_Db_Cleanup.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------------------------
--  210217  cecobr  FISPRING20-9195, Commit PRE Scripts and Drop Scripts for Obsolete components
-------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C_Db_Cleanup.sql','Timestamp_1');
PROMPT Starting PRE_Order_G2C_Db_Cleanup.sql

-------------------------------------------------------------------------------------------------
-- Removing Packages
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C_Db_Cleanup.sql','Timestamp_2');
PROMPT Removing Packages
BEGIN
   Database_SYS.Remove_Package('CREATE_ORDER_DELIVERY_NOTE_API', TRUE);
   Database_SYS.Remove_Package('DELIVERY_NOTE_TYPE_API', TRUE);
   Database_SYS.Remove_Package('MOVEMENT_REQUISITION_RPI', TRUE);
   Database_SYS.Remove_Package('MOVEMENT_TYPE_PER_SITE_API', TRUE);
   Database_SYS.Remove_Package('PREPRINTED_DELNOTE_NO_API', TRUE);
   Database_SYS.Remove_Package('PREPRINTED_DELNOTE_STATUS_API', TRUE);
   Database_SYS.Remove_Package('PT_CONTROL_VALIDATION_API', TRUE);
   Database_SYS.Remove_Package('SALES_PART_TAX_BASIS_API', TRUE);
   Database_SYS.Remove_Package('TRANSPORT_SLIP_RPI', TRUE);
END;
/

-------------------------------------------------------------------------------------------------
-- Removing Views
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C_Db_Cleanup.sql','Timestamp_3');
PROMPT Removing Views
BEGIN
   Database_SYS.Remove_View('COLLECT_DELNOTE_INVOICE', TRUE);
   Database_SYS.Remove_View('MOVEMENT_REQUISITION_REP', TRUE);
   Database_SYS.Remove_View('MOVEMENT_TYPE_PER_SITE', TRUE);
   Database_SYS.Remove_View('PREPRINTED_DELNOTE_NO', TRUE);
   Database_SYS.Remove_View('TRANSPORT_SLIP_REP', TRUE);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','PRE_Order_G2C_Db_Cleanup.sql','Done');
PROMPT Finished with PRE_Order_G2C_Db_Cleanup.sql
