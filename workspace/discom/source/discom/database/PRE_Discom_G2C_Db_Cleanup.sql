-------------------------------------------------------------------------------------------------
--  Module  : DISCOM
--
--  Purpose : This file is intended to execute at the begining of the upgrade, if upgrading from a GET version
--            Cleans up the DB Objects exclusive to GET versions
--
--  File    : PRE_Discom_G2C_Db_Cleanup.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------------------------
--  210217  cecobr  FISPRING20-9195, Commit PRE Scripts and Drop Scripts for Obsolete components
-------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
PROMPT Starting PRE_Discom_G2C_Db_Cleanup.sql

-------------------------------------------------------------------------------------------------
-- Removing Packages
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','PRE_Discom_G2C_Db_Cleanup.sql','Timestamp_1');
PROMPT Removing Packages
BEGIN
   Database_SYS.Remove_Package('PT_TRANS_DOC_COMM_METHOD_API', TRUE);
   Database_SYS.Remove_Package('TAX_BASIS_SOURCE_API', TRUE);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','PRE_Discom_G2C_Db_Cleanup.sql','Done');
PROMPT Finished with PRE_Discom_G2C_Db_Cleanup.sql
