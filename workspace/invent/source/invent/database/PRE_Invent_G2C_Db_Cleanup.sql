-------------------------------------------------------------------------------------------------
--  Module  : INVENT
--
--  Purpose : This file is intended to execute at the begining of the upgrade, if upgrading from a GET version
--            Cleans up the DB Objects exclusive to GET versions
--
--  File    : PRE_Invent_G2C_Db_Cleanup.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------------------------
--  210217  cecobr  FISPRING20-9195, Commit PRE Scripts and Drop Scripts for Obsolete components
-------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C_Db_Cleanup.sql','Timestamp_1');
PROMPT Starting PRE_Invent_G2C_Db_Cleanup.sql

-------------------------------------------------------------------------------------------------
-- Removing Packages
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C_Db_Cleanup.sql','Timestamp_2');
PROMPT Removing Packages
BEGIN
   Database_SYS.Remove_Package('CUSTOMS_DECLARATION_NO_WDR_API', TRUE);
   Database_SYS.Remove_Package('CUSTOMS_DECL_NO_LEVEL_API', TRUE);
   Database_SYS.Remove_Package('DELIVERY_REASON_API', TRUE);
   Database_SYS.Remove_Package('INTRASTAT_COUNTRY_TRANS_API', TRUE);
   Database_SYS.Remove_Package('INVENTORY_PART_TYPE_TRANS_API', TRUE);
   Database_SYS.Remove_Package('INV_TRANS_DATE_APPLIED_API', TRUE);
   Database_SYS.Remove_Package('JPK_INT_TRAN_ORDER_API', TRUE);
   Database_SYS.Remove_Package('OH_PERIOD_PROC_VS_PROD_API', TRUE);
   Database_SYS.Remove_Package('OH_PERIOD_PROC_VS_PROD_CNF_API', TRUE);
   Database_SYS.Remove_Package('OH_PERIOD_PROC_VS_PROD_PRT_API', TRUE);
   Database_SYS.Remove_Package('PERIOD_PROC_VS_PROD_API', TRUE);
   Database_SYS.Remove_Package('PERIOD_PROC_VS_PROD_CONF_API', TRUE);
   Database_SYS.Remove_Package('PERIOD_PROC_VS_PROD_HEADER_API', TRUE);
   Database_SYS.Remove_Package('PERIOD_PROC_VS_PROD_HIST_API', TRUE);
   Database_SYS.Remove_Package('PERIOD_PROC_VS_PROD_PART_API', TRUE);
   Database_SYS.Remove_Package('PT_PRODUCT_CATEGORY_API', TRUE);
   Database_SYS.Remove_Package('RU_INVENTORY_SCRAP_RPI', TRUE);
   Database_SYS.Remove_Package('RU_INVENT_INCOMING_TRANS_RPI', TRUE);
   Database_SYS.Remove_Package('RU_REQUIREMENT_ORDER_RPI', TRUE);
   Database_SYS.Remove_Package('RU_TRANS_OF_FINISHED_GOODS_RPI', TRUE);
   Database_SYS.Remove_Package('SERVICE_PAYMENT_WAY_API', TRUE);
   Database_SYS.Remove_Package('SERVICE_WAY_API', TRUE);
   Database_SYS.Remove_Package('TRANSPORT_DELIVERY_NOTE_API', TRUE);
   Database_SYS.Remove_Package('TRANSPORT_DELIVERY_NOTE_RPI', TRUE);
   Database_SYS.Remove_Package('TRANSPORT_DELIV_NOTE_LINE_API', TRUE);
   Database_SYS.Remove_Package('TRANSPORT_TRANSACTION_TYPE_API', TRUE);
   Database_SYS.Remove_Package('USER_INVENTORY_API', TRUE);
   Database_SYS.Remove_Package('WAREHOUSE_JOURNAL_API', TRUE);
END;
/

-------------------------------------------------------------------------------------------------
-- Removing Views
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C_Db_Cleanup.sql','Timestamp_3');
PROMPT Removing Views
BEGIN
   Database_SYS.Remove_View('CUSTOMS_DECLARATION_NO_WDR', TRUE);
   Database_SYS.Remove_View('DELIVERY_REASON', TRUE);
   Database_SYS.Remove_View('INTRASTAT_COUNTRY_TRANS', TRUE);
   Database_SYS.Remove_View('INVENTORY_LOCATION2_LOV', TRUE);
   Database_SYS.Remove_View('INVENTORY_LOCATION_LOV', TRUE);
   Database_SYS.Remove_View('INVENT_TRANS_REP_SERIES_VIEW2', TRUE);
   Database_SYS.Remove_View('INV_TRANS_OPERATION_HISTORY', TRUE);
   Database_SYS.Remove_View('JPK_INT_TRAN_ORDER', TRUE);
   Database_SYS.Remove_View('OH_PERIOD_PROC_VS_PROD', TRUE);
   Database_SYS.Remove_View('OH_PERIOD_PROC_VS_PROD_CNF', TRUE);
   Database_SYS.Remove_View('OH_PERIOD_PROC_VS_PROD_PRT', TRUE);
   Database_SYS.Remove_View('PERIOD_PROC_VS_PROD', TRUE);
   Database_SYS.Remove_View('PERIOD_PROC_VS_PROD_COMP', TRUE);
   Database_SYS.Remove_View('PERIOD_PROC_VS_PROD_CONF', TRUE);
   Database_SYS.Remove_View('PERIOD_PROC_VS_PROD_HEADER', TRUE);
   Database_SYS.Remove_View('PERIOD_PROC_VS_PROD_HIST', TRUE);
   Database_SYS.Remove_View('PERIOD_PROC_VS_PROD_PART', TRUE);
   Database_SYS.Remove_View('PERIOD_PROC_VS_PROD_PART_COMP', TRUE);
   Database_SYS.Remove_View('PT_PRODUCT_CATEGORY', TRUE);
   Database_SYS.Remove_View('RU_INVENTORY_SCRAP_REP', TRUE);
   Database_SYS.Remove_View('RU_INVENT_INCOMING_TRANS_REP', TRUE);
   Database_SYS.Remove_View('RU_REQUIREMENT_ORDER_REP', TRUE);
   Database_SYS.Remove_View('RU_TRANS_OF_FINISHED_GOODS_REP', TRUE);
   Database_SYS.Remove_View('TRANSPORT_DELIVERY_NOTE', TRUE);
   Database_SYS.Remove_View('TRANSPORT_DELIVERY_NOTE_REP', TRUE);
   Database_SYS.Remove_View('TRANSPORT_DELIV_NOTE_LINE', TRUE);
   Database_SYS.Remove_View('USER_INVENTORY', TRUE);
   Database_SYS.Remove_View('WAREHOUSE_JOURNAL', TRUE);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C_Db_Cleanup.sql','Done');
PROMPT Finished with PRE_Invent_G2C_Db_Cleanup.sql
