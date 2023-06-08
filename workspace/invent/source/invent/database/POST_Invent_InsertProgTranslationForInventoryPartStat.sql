--------------------------------------------------------------------------------------------------------
--
--  File        : POST_Invent_InsertProgTranslationForInventoryPartStat.sql
--
--  Module      : INVENT
--
--  Purpose     :  This is used to insert the correct TEXT in 'PROG' language.
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------------------------------------
--  160923   ApWilk  Bug 131595, Created.
--------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertProgTranslationForInventoryPartStat.sql','Timestamp_1');
PROMPT Starting POST_Invent_InsertProgTranslationForInventoryPartStat


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertProgTranslationForInventoryPartStat.sql','Timestamp_2');
PROMPT Inserting the prog translation for LU InventoryValueCalc
BEGIN
   Basic_Data_Translation_API.Insert_Prog_Translation('INVENT','InventoryValueCalc','INVENTORY_VALUE_CALC_API.CALCULATE_INVENTORY_VALUE^DESCRIPTION','Aggregate Inventory Transactions per Period');
END;
/

PROMPT Finished with POST_Invent_InsertProgTranslationForInventoryPartStat.sql
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_InsertProgTranslationForInventoryPartStat.sql','Done');


