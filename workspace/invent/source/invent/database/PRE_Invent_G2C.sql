-----------------------------------------------------------------------------
--  Module : INVENT
--
--  File   : PRE_Invent_G2C.sql
--  
--  Function:  This file is intended to Execute at the begining of the upgrade, if upgrading from versions 14.1.0-GET  
--             Handles obsolete functionalities and ensures error free execution of core UPG files
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  191004   Ashelk  Created Sample. Content will be added later
--  191028   kusplk  Added Section 1 and 2 content.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
DEFINE MODULE = 'INVENT'

------------------------------------------------------------------------------------------ 
-- SECTION 1: HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
--    Sub Section: Make nullable/rename table columns, drop table columns from temporary tables moved to core
--        Pre Upgrade sections: inventory_part_config_tab
--
--    Sub Section: Rename tables moved to core

-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES
--    Sub Section: Provide Oracle Default values to columns added to core tables
--        Pre Upgrade sections: company_invent_info_tab 
--        Pre Upgrade sections: intrastat_line_tab

---------------------------------------------------------------------------------------------
-- SECTION 1 : HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
---------------------------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C.sql','Timestamp_1');
PROMPT Starting PRE_Invent_G2C.sql

---------------------------------------------------------------------------------------------
--------------------- Make nullable/rename table columns moved to core-----------------------
---------------------------------------------------------------------------------------------

-- ***** inventory_part_config_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C.sql','Timestamp_2');
PROMPT rename obsolete Columns - VAPBR - Real Cost - INVENT
DECLARE
   table_name_  VARCHAR2(30) := 'INVENTORY_PART_CONFIG_TAB';
BEGIN
   -- gelr:actual_cost, begin
	IF (Database_SYS.Column_Exist(table_name_, 'ESTIMATED_SCRAP_COST') AND (NOT(Database_SYS.Column_Exist(table_name_, 'ESTIMATED_SCRAP_COST_1500')))) THEN
      Database_SYS.Rename_Column(table_name_, 'ESTIMATED_SCRAP_COST_1500', 'ESTIMATED_SCRAP_COST', TRUE);
	END IF;
	IF (Database_SYS.Column_Exist(table_name_, 'ESTIMATED_SUBPART_COST') AND (NOT(Database_SYS.Column_Exist(table_name_, 'ESTIMATED_SUBPART_COST_1500')))) THEN
      Database_SYS.Rename_Column(table_name_, 'ESTIMATED_SUBPART_COST_1500', 'ESTIMATED_SUBPART_COST', TRUE);
   END IF;
   -- gelr:actual_cost end
END;
/

-- ***** inventory_part_config_tab End *****

---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Rename tables moved to core--------------------------------------------
---------------------------------------------------------------------------------------------


-- END SECTION 1: Handling of Functionalities moved into core/Functionalities obsolete in Ext layer---


---------------------------------------------------------------------------------------------
-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -------------------------------
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Add Oracle Defaults to NOT NULL Columns added to Core Tables ----------
---------------------------------------------------------------------------------------------

-- ***** company_invent_info_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C.sql','Timestamp_3');
PROMPT set column INV_TRANS_DATE_APPLIED in table COMPANY_INVENT_INFO_TAB to nullable
DECLARE
	table_name_ VARCHAR2(30) := 'COMPANY_INVENT_INFO_TAB';
   columns_    Database_SYS.ColumnTabType;
BEGIN
   Database_SYS.Reset_Column_Table(columns_);
   Database_SYS.Set_Table_Column(columns_, 'INV_TRANS_DATE_APPLIED', default_value_ => '''STANDARD''');
   Database_SYS.Alter_Table( table_name_, columns_);
END;
/

-- ***** company_invent_info_tab End *****

-----------------------------------------------------------------------------------------

-- ***** intrastat_line_tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C.sql','Timestamp_4');
PROMPT set column TRANSACTION_TYPE in table INTRASTAT_LINE_TAB to nullable
DECLARE
	table_name_ VARCHAR2(30) := 'INTRASTAT_LINE_TAB';
   columns_    Database_SYS.ColumnTabType;
BEGIN
   Database_SYS.Reset_Column_Table(columns_);
   Database_SYS.Set_Table_Column(columns_, 'TRANSACTION_TYPE', default_value_ => '''FIS AND STAT''');
   Database_SYS.Alter_Table( table_name_, columns_);
END;
/

-- ***** intrastat_line_tab End *****

-----------------------------------------------------------------------------------------

-- END SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -----------------------



UNDEFINE MODULE

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','PRE_Invent_G2C.sql','Done');
PROMPT Finished with PRE_Invent_G2C.sql
