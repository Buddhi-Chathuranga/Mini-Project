-------------------------------------------------------------------------------------------------
--  Module  : MPCCOM
--
--  Purpose : This file is intended to execute at the begining of the upgrade, if upgrading from a GET version
--            Cleans up the DB Objects exclusive to GET versions
--
--  File    : PRE_Mpccom_G2C_Db_Cleanup.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------------------------
--  210217  cecobr  FISPRING20-9195, Commit PRE Scripts and Drop Scripts for Obsolete components
-------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','PRE_Mpccom_G2C_Db_Cleanup.sql','Timestamp_1');
PROMPT Starting PRE_Mpccom_G2C_Db_Cleanup.sql

-------------------------------------------------------------------------------------------------
-- Removing Packages
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','PRE_Mpccom_G2C_Db_Cleanup.sql','Timestamp_2');
PROMPT Removing Packages
BEGIN
   Database_SYS.Remove_Package('MOVEMENT_TYPE_API', TRUE);
   Database_SYS.Remove_Package('SERVICE_STATISTICS_NO_API', TRUE);
   Database_SYS.Remove_Package('TRANSACTION_TYPE_INTRA_API', TRUE);
   Database_SYS.Remove_Package('TRANSPORT_DOC_NUM_SERIES_API', TRUE);
   Database_SYS.Remove_Package('TRANSPORT_DOC_SERIES_API', TRUE);
END;
/

-------------------------------------------------------------------------------------------------
-- Removing Views
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','PRE_Mpccom_G2C_Db_Cleanup.sql','Timestamp_3');
PROMPT Removing Views
BEGIN
   Database_SYS.Remove_View('MOVEMENT_TYPE', TRUE);
   Database_SYS.Remove_View('SERVICE_STATISTICS_NO', TRUE);
   Database_SYS.Remove_View('TRANSPORT_DOC_NUM_SERIES', TRUE);
   Database_SYS.Remove_View('TRANSPORT_DOC_SERIES', TRUE);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','PRE_Mpccom_G2C_Db_Cleanup.sql','Done');
PROMPT Finished with PRE_Mpccom_G2C_Db_Cleanup.sql
