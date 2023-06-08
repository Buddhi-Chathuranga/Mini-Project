-----------------------------------------------------------------------------
--  Module : APPSRV
--
--  File   : POST_Appsrv_UpdateTechnicalObjectRefForEnterp.cdb
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  170206   AJPELK  STRFI-3751, LCS merge bug 131485.   
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateTechnicalObjectRefForEnterp.sql','Timestamp_1');
PROMPT enabling TechnicalObjectReference service FOR SupplierInfoGeneral IF it IS already enabled FOR SupplierInfo

BEGIN
   --Check whether TechnicalObjectReference service is enabled for SupplierInfo lu and if so enable it for SupplierInfoGeneral as well
   IF(Object_Connection_Sys.Is_Connection_Aware('SupplierInfo','TechnicalObjectReference')) THEN
      Object_Connection_SYS.Enable_Logical_Unit('SupplierInfoGeneral', 'TechnicalObjectReference^', 'SUPPLIER_INFO_GENERAL', 'SUPPLIER_INFO_GENERAL_API', 'GET_NAME');
      COMMIT;
   END IF;
END;
/
EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateTechnicalObjectRefForEnterp.sql','Timestamp_2');
PROMPT Updating COLUMN lu_name IN TECHNICAL_OBJECT_REFERENCE_TAB FOR LU SupplierInfo

BEGIN   
   IF (Database_SYS.Table_Exist('Technical_Object_Reference_tab')) THEN
      DECLARE
         old_lu_name_ VARCHAR2(50) := 'SupplierInfo';
         new_lu_name_ VARCHAR2(50) := 'SupplierInfoGeneral';
      BEGIN
         --Since SupplierInfoGeneral LU is new it is guranteed that no duplicate record exist hence we can directly update the LU name
         UPDATE TECHNICAL_OBJECT_REFERENCE_TAB
         SET LU_NAME=new_lu_name_
         WHERE LU_NAME=old_lu_name_;  
      END;
      COMMIT;
   END IF;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateTechnicalObjectRefForEnterp.sql','Done');
PROMPT Finished with POST_Appsrv_UpdateTechnicalObjectRefForEnterp.sql 


