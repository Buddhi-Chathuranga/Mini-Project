-------------------------------------------------------------------------------------------------
--  Module  : SHPMNT
--
--  Purpose : This file is intended to execute at the begining of the upgrade, if upgrading from a GET version
--            Cleans up the DB Objects exclusive to GET versions
--
--  File    : PRE_Shpmnt_G2C_Db_Cleanup.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------------------------
--  210217  cecobr  FISPRING20-9195, Commit PRE Scripts and Drop Scripts for Obsolete components
-------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','PRE_Shpmnt_G2C_Db_Cleanup.sql','Timestamp_1');
PROMPT Starting PRE_Shpmnt_G2C_Db_Cleanup.sql

-------------------------------------------------------------------------------------------------
-- Removing Packages
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','PRE_Shpmnt_G2C_Db_Cleanup.sql','Timestamp_2');
PROMPT Removing Packages
BEGIN
   Database_SYS.Remove_Package('AT_RESPONSE_INFO_API', TRUE);
   Database_SYS.Remove_Package('DELIVERY_NOTE_HASH_INFO_API', TRUE);
   Database_SYS.Remove_Package('DELIVERY_NOTE_HASH_UTIL_API', TRUE);
   Database_SYS.Remove_Package('SEND_E_DELIV_NOTE_HEADER_API', TRUE);
   Database_SYS.Remove_Package('SEND_E_DELIV_NOTE_LINE_API', TRUE);
   Database_SYS.Remove_Package('SEND_E_DELIV_NOTE_UTIL_API', TRUE);
END;
/

-------------------------------------------------------------------------------------------------
-- Removing Views
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','PRE_Shpmnt_G2C_Db_Cleanup.sql','Timestamp_3');
PROMPT Removing Views
BEGIN
   Database_SYS.Remove_View('AT_RESPONSE_INFO', TRUE);
   Database_SYS.Remove_View('DELIVERY_NOTE_HASH_INFO', TRUE);
   Database_SYS.Remove_View('SEND_E_DELIV_NOTE_HEADER', TRUE);
   Database_SYS.Remove_View('SEND_E_DELIV_NOTE_LINE', TRUE);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','PRE_Shpmnt_G2C_Db_Cleanup.sql','Done');
PROMPT Finished with PRE_Shpmnt_G2C_Db_Cleanup.sql
