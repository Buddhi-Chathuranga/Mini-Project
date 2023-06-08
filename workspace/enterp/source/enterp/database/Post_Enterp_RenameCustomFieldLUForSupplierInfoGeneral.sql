-----------------------------------------------------------------------------
--  Module : ENTERP
--
--  File   : Post_Enterp_RenameCustomFieldLUForSupplierInfoGeneral.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  210223   Basblk  FISPRING20-8749, Changed LU name from SupplierInfo to SupplierInfoGeneral
--  210223           to avoid custom fields being missing when upgrading from apps08 to Greenhouse.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RenameCustomFieldLUForSupplierInfoGeneral.sql','Timestamp_1');
PROMPT Renamed the logical units to SupplierInfoGeneral to avoid custom fields not migrating correctly.

BEGIN
     Custom_Objects_SYS.Handle_Lu_Modification('SupplierInfo','SupplierInfoGeneral');
     COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_RenameCustomFieldLUForSupplierInfoGeneral.sql','Done');
PROMPT Finished with Post_Enterp_RenameCustomFieldLUForSupplierInfoGeneral.sql
