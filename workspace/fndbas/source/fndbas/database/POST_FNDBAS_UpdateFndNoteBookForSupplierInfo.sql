---------------------------------------------------------------------------------------------------
--  Filename      : POST_FNDBAS_UpdateFndNoteBookForSupplierInfo.sql
-- 
--  Module        : FNDBAS 6.0.0
--
--  Purpose       : To update data that have SupplierInfo as the lu_name with SupplierInfoGeneral in FND_NOTE_BOOK_TAB. SupplierInfo and SupplierInfoGeneral belongs to Enterp component
-- 
--  Date      Sign      History
--  ------   ------    ----------------------------------------------------------------------------
--  150710   Hairlk    Created for task ORA-922
---------------------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_UpdateFndNoteBookForSupplierInfo.sql','Timestamp_1');
PROMPT Starting POST_FNDBAS_UpdateFndNoteBookForSupplierInfo.sql

SET SERVEROUTPUT ON

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_UpdateFndNoteBookForSupplierInfo.sql','Timestamp_2');
PROMPT Updating COLUMN lu_name IN FND_NOTE_BOOK_TAB FOR LU SupplierInfo

BEGIN   
      DECLARE
         old_lu_name_ VARCHAR2(50) := 'SupplierInfo';
         new_lu_name_ VARCHAR2(50) := 'SupplierInfoGeneral';
      BEGIN
         --Since SupplierInfoGeneral LU is new it is guranteed that no duplicate record exist hence we can directly update the LU name
         UPDATE FND_NOTE_BOOK_TAB
         SET LU_NAME=new_lu_name_
         WHERE LU_NAME=old_lu_name_;

         COMMIT;
      END;
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_UpdateFndNoteBookForSupplierInfo.sql','Done');
PROMPT Finished with POST_FNDBAS_UpdateFndNoteBookForSupplierInfo.sql 

