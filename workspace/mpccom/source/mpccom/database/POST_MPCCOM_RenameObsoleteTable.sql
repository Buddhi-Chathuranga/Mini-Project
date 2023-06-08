---------------------------------------------------------------------
--
--  File: POST_MPCCOM_RenameObsoleteTable.sql
--
--  Module        : MPCCOM
--
--  Purpose       : Rename the obsolete tables PACKAGE_TYPE_TAB and PACKAGE_TYPE_PRICE_TAB.
--
--
--  Note          : PACKAGE_TYPE_TAB and PACKAGE_TYPE_PRICE_TAB have to be renamed after a INVENT module installation
--                  since the existing data needs to be migrated into HANDLING_UNIT_TYPE_TAB.
--
--
--  Date    Sign    History
--  ------  ----    -------------------------------------------------
--  140313  MaEelk  Created.
---------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_MPCCOM_RenameObsoleteTable.sql','Timestamp_1');
PROMPT Renaming obsolete tables
BEGIN
   Database_SYS.Rename_Table('PACKAGE_TYPE_TAB',        'PACKAGE_TYPE_1410',        TRUE);
   Database_SYS.Rename_Table('PACKAGE_TYPE_PRICE_TAB',  'PACKAGE_TYPE_PRICE_1410',  TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_MPCCOM_RenameObsoleteTable.sql','Timestamp_2');
PROMPT Done with renaming obsolete tables
--------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_MPCCOM_RenameObsoleteTable.sql','Done');
