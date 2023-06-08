-------------------------------------------------------------------------------------------------
--  Module  : ENTERP
--
--  Purpose : This file is intended to execute at the begining of the upgrade, if upgrading from a GET version
--            Cleans up the DB Objects exclusive to GET versions
--
--  File    : PRE_Enterp_G2C_Db_Cleanup.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------------------------
--  210217  cecobr  FISPRING20-9195, Commit PRE Scripts and Drop Scripts for Obsolete components
-------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C_Db_Cleanup.sql','Timestamp_1');
PROMPT Starting PRE_Enterp_G2C_Db_Cleanup.sql

-------------------------------------------------------------------------------------------------
-- Removing Packages
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C_Db_Cleanup.sql','Timestamp_2');
PROMPT Removing Packages
BEGIN
   Database_SYS.Remove_Package('COMPANY_BUSINESS_TYPE_API', TRUE);
   Database_SYS.Remove_Package('COMPANY_LOCALIZATION_API', TRUE);
   Database_SYS.Remove_Package('DIGITAL_KEY_IDENTIFIER_API', TRUE);
   Database_SYS.Remove_Package('DIGITAL_KEY_STORE_INFO_API', TRUE);
   Database_SYS.Remove_Package('DIGITAL_SIGNER_UTIL_API', TRUE);
   Database_SYS.Remove_Package('LOCALIZATION_COUNTRY_PARAM_API', TRUE);
   Database_SYS.Remove_Package('LOCALIZATION_PARAMETER_API', TRUE);
   Database_SYS.Remove_Package('LOCALIZATION_PARAM_YES_NO_API', TRUE);
   Database_SYS.Remove_Package('LOCAL_COUNTRY_CODE_API', TRUE);
   Database_SYS.Remove_Package('LOCAL_UOM_CODE_API', TRUE);
   Database_SYS.Remove_Package('OPERATION_DIRECTION_API', TRUE);
   Database_SYS.Remove_Package('PLSQLAP_SERVER_GELR_API', TRUE);
   Database_SYS.Remove_Package('QR_CODE_UTIL_API', TRUE);
   Database_SYS.Remove_Package('TAX_LIABILITY_CODE_API', TRUE);
   Database_SYS.Remove_Package('TAX_TYPE_CATEGORY_INFO_API', TRUE);
END;
/

-------------------------------------------------------------------------------------------------
-- Removing Views
-------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C_Db_Cleanup.sql','Timestamp_3');
PROMPT Removing Views
BEGIN
   Database_SYS.Remove_View('COMPANY_LOCALIZATION', TRUE);
   Database_SYS.Remove_View('DIGITAL_KEYSTORE_INFO_LOV', TRUE);
   Database_SYS.Remove_View('DIGITAL_KEY_STORE_INFO', TRUE);
   Database_SYS.Remove_View('LOCALIZATION_COUNTRY_PARAM', TRUE);
   Database_SYS.Remove_View('LOCALIZATION_PARAMETER', TRUE);
   Database_SYS.Remove_View('LOCAL_COUNTRY_CODE', TRUE);
   Database_SYS.Remove_View('LOCAL_UOM_CODE', TRUE);
   Database_SYS.Remove_View('SUPPLIER_INFO_ADDRESS_LOV', TRUE);
   Database_SYS.Remove_View('TAX_LIABILITY_CODE', TRUE);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','PRE_Enterp_G2C_Db_Cleanup.sql','Done');
PROMPT Finished with PRE_Enterp_G2C_Db_Cleanup.sql
