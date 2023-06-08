---------------------------------------------------------------------------------------------------
--  Filename      : POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql
-- 
--  Module        : APPSRV 4.1.0
--
--  Purpose       : To update data that have SupplierInfo as the lu_name with SupplierInfoGeneral in MEDIA_LIBRARY_TAB. SupplierInfo and SupplierInfoGeneral belongs to Enterp component
-- 
--  Date      Sign      History
--  ------   ------    ----------------------------------------------------------------------------
--  150909   Hairlk    AFT-4920, Added code to conditionally enable MediaLibrary service for SupplierInfoGeneral lu and added code to 
--                     modify object connection transformations added for SupplierInfo. For more info Refer the bug
--  150709   Hairlk    Created for tasks ORA-920
---------------------------------------------------------------------------------------------------

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql','Timestamp_1');
PROMPT Starting POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql

SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql','Timestamp_2');
PROMPT Updating COLUMN lu_name IN MEDIA_LIBRARY_TAB FOR LU SupplierInfo

BEGIN   
      DECLARE
         old_lu_name_ VARCHAR2(50) := 'SupplierInfo';
         new_lu_name_ VARCHAR2(50) := 'SupplierInfoGeneral';
      BEGIN
         --Since SupplierInfoGeneral LU is new it is guranteed that no duplicate record exist hence we can directly update the LU name
         UPDATE MEDIA_LIBRARY_TAB
         SET LU_NAME=new_lu_name_
         WHERE LU_NAME=old_lu_name_;
         
      END;
END;
/
COMMIT;

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql','Timestamp_3');
PROMPT enabling MediaLibrary service FOR SupplierInfoGeneral IF it IS already enabled FOR SupplierInfo

DECLARE

BEGIN
   --Check whether MediaLibrary service is enabled for SupplierInfo lu and if so enable it for SupplierInfoGeneral as well
   IF(Object_Connection_Sys.Is_Connection_Aware('SupplierInfo','MediaLibrary')) THEN
      Object_Connection_SYS.Enable_Logical_Unit('SupplierInfoGeneral', 'MediaLibrary^', 'SUPPLIER_INFO_GENERAL', 'SUPPLIER_INFO_GENERAL_API', 'GET_NAME');
   END IF;
END;
/
COMMIT;

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql','Timestamp_4');
PROMPT Adding OBJECT Connection transformations TO SupplierInfoGeneral IF ANY has been added FOR SupplierInfo

DECLARE
   lu_SupplierInfo_           VARCHAR2(50) := 'SupplierInfo';
   lu_SupplierInfo_General_   VARCHAR2(50) := 'SupplierInfoGeneral';
   editable_source_           VARCHAR2(10) := 'SOURCE';
   service_name_              VARCHAR2(20) := 'MediaLibrary';
   system_defined_            VARCHAR2(10) := 'FALSE';
   
   --Get records where SupplierInfo is set as source lu and editable is set to source for MediaLibrary service
   CURSOR get_supplierInfo_as_source IS
      SELECT t.source_lu_name,t.target_lu_name,t.service_name,t.transformation_method 
      FROM   obj_connect_lu_transform t
      WHERE  t.source_lu_name = lu_SupplierInfo_ 
      AND    t.editable_db = editable_source_
      AND    t.service_name = service_name_;

BEGIN   
   FOR rec_ IN get_supplierInfo_as_source LOOP
      --For records where SupplierInfo is set as source(with editable=source) unregister the service from SupplierInfo and re-register it to SupplierInfoGeneral(with editable=source)
      Obj_Connect_Lu_Transform_API.Unregister(rec_.target_lu_name,rec_.source_lu_name,rec_.service_name);
      Obj_Connect_Lu_Transform_API.Register(rec_.target_lu_name,lu_SupplierInfo_General_,rec_.service_name,editable_source_,rec_.transformation_method,system_defined_);
   END LOOP;
END;
/
COMMIT;

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql','Done');
PROMPT Finished with POST_Appsrv_UpdateMediaLibraryForSupplierInfo.sql 
