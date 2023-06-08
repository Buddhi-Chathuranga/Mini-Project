-----------------------------------------------------------------------------
--  Module : DISCOM
--
--  File   : PRE_Discom_G2C.sql
--  
--  Function:  This file is intended to Execute at the begining of the upgrade, if upgrading from versions 9.1.0-GET  
--             Handles obsolete functionalities and ensures error free execution of core UPG files
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  191025   Nijilk  Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
DEFINE MODULE = 'DISCOM'

------------------------------------------------------------------------------------------ 
-- SECTION 1: HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER

--    Sub Section: Make nullable/rename table columns, drop table columns from temporary tables moved to core 

--    Sub Section: Rename tables moved to core
--       Pre Upgrade sections:
--    Sub Section: Drop packages/views moved to core       
--       Pre Upgrade sections: 
--  
--    Sub Section: Remove company creation basic data moved to core 

-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES
--    Sub Section: Provide Oracle Default values to columns added to core tables
--        Pre Upgrade sections: currency_type_basic_data_tab
--        Pre Upgrade sections: tax_code_texts_tab

---------------------------------------------------------------------------------------------
-- SECTION 1 : HANDLING OF FUNCTIONALITIES MOVED INTO CORE/FUNCTIONALITIES OBSOLETE IN EXT LAYER
---------------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('DISCOM','PRE_Discom_G2C.sql','Timestamp_1');
PROMPT Starting PRE_Discom_G2C.sql

---------------------------------------------------------------------------------------------
--------------------- Make nullable/rename table columns moved to core-----------------------
---------------------------------------------------------------------------------------------

--*************site_discom_info_tab Start*************

PROMPT set column create_ivc_within_comp in table site_discom_info_tab to nullable
DECLARE  
   columns_      Database_SYS.ColumnTabType;
   table_name_   VARCHAR2(30) := 'SITE_DISCOM_INFO_TAB';
BEGIN 
   IF Database_SYS.Column_Exist(table_name_, 'CREATE_IVC_WITHIN_COMP') THEN
      Database_SYS.Reset_Column_Table(columns_);
      Database_SYS.Set_Table_Column(columns_, 'CREATE_IVC_WITHIN_COMP', 'VARCHAR2(5)', 'Y');
      Database_SYS.Alter_Table( table_name_, columns_);
   END IF;
END;
/

PROMPT rename columns in table branch_tab
DECLARE
   new_column_name_   VARCHAR2(30);
   old_column_name_   VARCHAR2(30);
   table_name_        VARCHAR2(30) := 'SITE_DISCOM_INFO_TAB';
BEGIN
   new_column_name_ := 'CREATE_IVC_WITHIN_COMP_210';
   old_column_name_ := 'CREATE_IVC_WITHIN_COMP';  
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;   
END;
/

--*************site_discom_info_tab End***************

---------------------------------------------------------------------------------------------
--------------------- Drop packages/views moved to core -------------------------------------
---------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------
--------------------- Remove company creation basic data moved to core ----------------------
---------------------------------------------------------------------------------------------



-- END SECTION 1: Handling of Functionalities moved into core/Functionalities obsolete in Ext layer---






---------------------------------------------------------------------------------------------
-- SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -------------------------------
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Add Oracle Defaults to NOT NULL Columns added to Core Tables ----------
---------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------

-- END SECTION 2: ENSURING ERROR-FREE EXECUTION OF CORE UPG FILES -----------------------





UNDEFINE MODULE

exec Installation_SYS.Log_Detail_Time_Stamp('DISCOM','PRE_Discom_G2C.sql','Done');
PROMPT Finished with PRE_Discom_G2C.sql