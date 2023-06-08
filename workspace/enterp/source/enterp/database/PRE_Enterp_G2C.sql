-----------------------------------------------------------------------------
--  Module : ENTERP
--
--  File   : PRE_Enterp_G2C.sql
--
--  Function:  This file is intended to Execute at the begining of the upgrade, if upgrading from versions 2.1.0-GET
--             Handles obsolete functionalities and ensures error free execution of core UPG files
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  191001   ShKolk  Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
DEFINE MODULE = 'ENTERP'

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_1');
PROMPT Starting PRE_Enterp_G2C.sql

------------------------------------------------------------------------------------------
-- SECTION 1 : Handling of functionalities moved into core/functionalities obsolete in ext layer
--    Sub Section: Make nullable/rename table columns, drop table columns from temporary tables moved to core
--       Pre Upgrade sections: Todo_Tab
--    Sub Section: Rename tables moved to core
--       Pre Upgrade sections: Todo_Tab
--    Sub Section: Drop packages/views moved to core
--
--    Sub Section: Remove company creation basic data moved to core

-- SECTION 2 : Ensuring error-free execution of core upg files
--    Sub Section: Provide Oracle Default values to columns added to core tables
--        Pre Upgrade sections: Todo_Tab

---------------------------------------------------------------------------------------------
-- SECTION 1 : Handling of functionalities moved into core/functionalities obsolete in ext layer starts here
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Make nullable/rename table columns moved to core-----------------------
---------------------------------------------------------------------------------------------

-- ***** Branch_Tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_2');
PROMPT Renaming address_id column in the table branch_tab
DECLARE
   new_column_name_ VARCHAR2(30);
   old_column_name_ VARCHAR2(30);
   table_name_      VARCHAR2(30) := 'BRANCH_TAB';
BEGIN
   new_column_name_ := 'ADDRESS_ID_210';
   old_column_name_ := 'ADDRESS_ID';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** Branch_Tab End *****

---------------------------------------------------------------------------------------------

-- ***** Customer_Info_Address_Tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_3');
PROMPT Renaming branch_id, branch_desc columns in the table customer_info_address_tab
DECLARE
   new_column_name_ VARCHAR2(30);
   old_column_name_ VARCHAR2(30);
   table_name_      VARCHAR2(30) := 'CUSTOMER_INFO_ADDRESS_TAB';
BEGIN
   new_column_name_ := 'BRANCH_ID_210';
   old_column_name_ := 'BRANCH_ID';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'BRANCH_DESC_210';
   old_column_name_ := 'BRANCH_DESC';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** Customer_Info_Address_Tab End *****

---------------------------------------------------------------------------------------------

-- ***** Supplier_Info_Address_Tab Start *****

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_4');
PROMPT Renaming branch_id, branch_desc columns in table supplier_info_address_tab
DECLARE
   new_column_name_ VARCHAR2(30);
   old_column_name_ VARCHAR2(30);
   table_name_      VARCHAR2(30) := 'SUPPLIER_INFO_ADDRESS_TAB';
BEGIN
   new_column_name_ := 'BRANCH_ID_210';
   old_column_name_ := 'BRANCH_ID';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;

   new_column_name_ := 'BRANCH_DESC_210';
   old_column_name_ := 'BRANCH_DESC';
   IF NOT (Database_SYS.Column_Exist(table_name_, new_column_name_)) AND Database_SYS.Column_Exist(table_name_, old_column_name_) THEN
      Database_SYS.Rename_Column(table_name_, new_column_name_, old_column_name_, TRUE);
   END IF;
END;
/

-- ***** Supplier_Info_Address_Tab End *****

---------------------------------------------------------------------------------------------
--------------------- Rename tables moved to core -------------------------------------------
---------------------------------------------------------------------------------------------

-- ***** address_via_zip_code Start *****
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_5');
PROMPT Renaming table zip_code_range_tab
DECLARE
   new_table_name_ VARCHAR2(30) := 'ZIP_CODE_RANGE_210';
   old_table_name_ VARCHAR2(30) := 'ZIP_CODE_RANGE_TAB';
BEGIN
   IF ( Database_SYS.Table_Exist(old_table_name_) AND NOT (Database_SYS.Table_Exist(new_table_name_))) THEN
      Database_SYS.Rename_Table(old_table_name_, new_table_name_, TRUE, FALSE, TRUE, TRUE);
   END IF;
END;
/
-- ***** address_via_zip_code End *****

---------------------------------------------------------------------------------------------
--------------------- Drop packages/views moved to core -------------------------------------
---------------------------------------------------------------------------------------------

-- ***** address_via_zip_code Start *****
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_6');
PROMPT Removing  zip_code package moved to core
BEGIN
   Database_SYS.Remove_Package('ZIP_CODE_RANGE_API', TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_7');
PROMPT Removing zip_code views moved to core
BEGIN
   Database_SYS.Remove_View('ZIP_CODE_RANGE', TRUE);
   Database_SYS.Remove_View('ZIP_CODE_RANGE_LOV', TRUE);
END;
/
-- ***** address_via_zip_code End *****

---------------------------------------------------------------------------------------------
--------------------- Remove company creation basic data moved to core ----------------------
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
-- SECTION 1 : Handling of functionalities moved into core/functionalities obsolete in ext layer ends here
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
-- SECTION 2 : Ensuring error-free execution of core upg files starts here ------------------
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--------------------- Add Oracle Defaults to NOT NULL Columns added to Core Tables ----------
---------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- SECTION 2 : Ensuring error-free execution of core upg files ends here ----------------
-----------------------------------------------------------------------------------------

UNDEFINE MODULE

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Timestamp_8');
PROMPT Finished with PRE_Invoic_G2C.sql
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C.sql','Done');
