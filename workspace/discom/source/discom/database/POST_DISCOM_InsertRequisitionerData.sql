-----------------------------------------------------------------------------
--  Module : DISCOM
--
--  File   : POST_DISCOM_InsertRequisitionerData.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Purpose       : Migrate Requisitioner data from PURCH to DISCOM as it is now common for both PURCH and SHIPOD.
--                  This script should be run before running the clean up script Purchcl.sql
--                  Renaming of the obsolete tables will be done in POST_PURCH_RenameObsoletePurchaseRequisitionerTable.sql in PURCH component.
--  
--  Note          : Inserte data from PURCHASE_REQUISITIONER_TAB to REQUISITIONER_TAB.
--  
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  201120   AsZelk  SC2020R1-11427, Changed table name to PURCHASE_REQUISITIONER_2110 from PURCHASE_REQUISITIONER_2010.
--  200205   erralk  Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRequisitionerData.sql','Timestamp_1');
PROMPT Migrate Requisitoiner data from PURCH to DISCOM

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRequisitionerData.sql','Timestamp_2');
PROMPT Inserting data from PURCHASE_REQUISITIONER_TAB to REQUISITIONER_TAB


DECLARE
   stmt_        VARCHAR2(32000);
   table_name_  VARCHAR2(30);
   table_found_ BOOLEAN;
BEGIN
   
   IF (Database_SYS.Table_Exist('PURCHASE_REQUISITIONER_TAB')) THEN
      table_name_ := 'PURCHASE_REQUISITIONER_TAB';
      table_found_ := TRUE;
   ELSIF (Database_SYS.Table_Exist('PURCHASE_REQUISITIONER_2110')) THEN
      table_name_ := 'PURCHASE_REQUISITIONER_2110';
      table_found_ := TRUE;
   END IF;

   IF (table_found_) THEN
      stmt_ := 'BEGIN
                     INSERT INTO REQUISITIONER_TAB (
                        REQUISITIONER_CODE,
                        REQ_DEPT, 
                        ROWVERSION, 
                        ROWKEY, 
                        SYSTEM_DEFINED, 
                        ROWSTATE)
                     SELECT 
                        REQUISITIONER_CODE, 
                        REQ_DEPT, 
                        ROWVERSION, 
                        ROWKEY, 
                        SYSTEM_DEFINED,
                        ROWSTATE
                        FROM '|| table_name_ || ' rq
                        WHERE NOT EXISTS (SELECT 1    
                                          FROM   REQUISITIONER_TAB
                                          WHERE  REQUISITIONER_CODE = rq.REQUISITIONER_CODE);        
                  COMMIT;
                  END;';      
         EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRequisitionerData.sql','Timestamp_3');
PROMPT Finished with Inserting data from PURCHASE_REQUISITIONER_TAB to REQUISITIONER_TAB

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRequisitionerData.sql','Timestamp_4');
PROMPT Done with Requisitoiner data from PURCH to DISCOM
exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRequisitionerData.sql','Done');
