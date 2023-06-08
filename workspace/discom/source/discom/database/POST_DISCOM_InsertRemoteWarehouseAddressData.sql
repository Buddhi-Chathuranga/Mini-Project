-----------------------------------------------------------------------------
--  Module : DISCOM
--
--  File   : POST_DISCOM_InsertRemoteWarehouseAddressData.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Purpose       : Migrate Remote Warehouse Address data from PURCH to DISCOM as it is now common for both PURCH and SHIPOD.
--                  This script should be run before running the clean up script Purchcl.sql
--                  Renaming of the obsolete tables will be done in POST_PURCH_RenameObsoleteRemoteWarehouseAddressTables.sql in PURCH component.
--  
--  Note          : Inserte data from WAREHOUSE_PURCH_INFO_TAB to WHSE_SHIPMENT_RECEIPT_INFO_TAB.
--                  Inserte data from WHSE_RECEIPT_DEFAULT_LOC_TAB to WAREHOUSE_DEFAULT_LOCATION_TAB.  
--  
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  201120   AsZelk  SC2020R1-11427, Changed table name to PURCHASE_REQUISITIONER_2110 from PURCHASE_REQUISITIONER_2010.
--  200728   aszelk  SCSPRING20-1349, Added default value for mandatory columns in WHSE_SHIPMENT_RECEIPT_INFO_TAB.
--  200219   erralk  SCSPRING20-2021,Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRemoteWarehouseAddressData.sql','Timestamp_1');
PROMPT Migrate Remote Warehouse Address data from PURCH to DISCOM

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRemoteWarehouseAddressData.sql','Timestamp_2');
PROMPT Inserting data from WAREHOUSE_PURCH_INFO_TAB to WHSE_SHIPMENT_RECEIPT_INFO_TAB


DECLARE
   stmt_          VARCHAR2(32000);
   table_name_    VARCHAR2(30);
   table_found_   BOOLEAN;
   dummy_number_  NUMBER := 0;
   dummy_text_    VARCHAR2(5) := '''*''';
   dummy_boolean_ VARCHAR2(10) := '''FALSE''';
BEGIN
   
   IF (Database_SYS.Table_Exist('WAREHOUSE_PURCH_INFO_TAB')) THEN
      table_name_ := 'WAREHOUSE_PURCH_INFO_TAB';
      table_found_ := TRUE;
   ELSIF (Database_SYS.Table_Exist('WAREHOUSE_PURCH_INFO_2110')) THEN
      table_name_ := 'WAREHOUSE_PURCH_INFO_2110';
      table_found_ := TRUE;
   END IF;
   
   
    IF (table_found_) THEN
      stmt_ := 'BEGIN
                     INSERT
                      INTO WHSE_SHIPMENT_RECEIPT_INFO_TAB (CONTRACT, WAREHOUSE_ID, RECEIVE_CASE, COMPANY, COMPANY_ADDRESS_ID, 
                           CUSTOMER_ID, CUSTOMER_ADDRESS_ID, PERSON_ID, PERSON_ADDRESS_ID, ROWVERSION, ROWKEY, SUPPLIER_ID, SUPPLIER_ADDRESS_ID,
                           PICKING_LEAD_TIME, EXT_TRANSPORT_LEAD_TIME, TRANSPORT_LEADTIME, INT_TRANSPORT_LEAD_TIME, DELIVERY_TERMS, SHIP_VIA_CODE, SEND_AUTO_DIS_ADV)
                      SELECT CONTRACT, WAREHOUSE_ID, PURCHASE_RECEIVE_CASE, COMPANY, COMPANY_ADDRESS_ID, CUSTOMER_ID, CUSTOMER_ADDRESS_ID,
                             PERSON_ID, PERSON_ADDRESS_ID, ROWVERSION, ROWKEY, SUPPLIER_ID, SUPPLIER_ADDRESS_ID,' || dummy_number_ || ',' || dummy_number_ || ',' 
                             || dummy_number_ || ',' || dummy_number_ || ',' || dummy_text_ || ',' || dummy_text_ || ',' || dummy_boolean_ || '
                      FROM '|| table_name_ || ' wpi
                      WHERE NOT EXISTS (SELECT 1    
                                        FROM   WHSE_SHIPMENT_RECEIPT_INFO_TAB
                                        WHERE  CONTRACT = wpi.CONTRACT
                                        AND    WAREHOUSE_ID= wpi.WAREHOUSE_ID);           
                  COMMIT;
                  END;';      
         EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRemoteWarehouseAddressData.sql','Timestamp_3');
PROMPT Finished with Inserting data from WAREHOUSE_PURCH_INFO_TAB to WHSE_SHIPMENT_RECEIPT_INFO_TAB

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRemoteWarehouseAddressData.sql','Timestamp_4');
PROMPT Inserting data from WHSE_RECEIPT_DEFAULT_LOC_TAB to WAREHOUSE_DEFAULT_LOCATION_TAB

DECLARE
   stmt_        VARCHAR2(32000);
   table_name_  VARCHAR2(30);
   table_found_ BOOLEAN;
BEGIN
   
   IF (Database_SYS.Table_Exist('WHSE_RECEIPT_DEFAULT_LOC_TAB')) THEN
      table_name_ := 'WHSE_RECEIPT_DEFAULT_LOC_TAB';
      table_found_ := TRUE;
   ELSIF (Database_SYS.Table_Exist('WHSE_RECEIPT_DEFAULT_LOC_2010')) THEN
      table_name_ := 'WHSE_RECEIPT_DEFAULT_LOC_2010';
      table_found_ := TRUE;
   END IF;
   
    IF (table_found_) THEN
      stmt_ := 'BEGIN
                     INSERT
                      INTO WAREHOUSE_DEFAULT_LOCATION_TAB (CONTRACT, WAREHOUSE_ID, LOCATION_TYPE, LOCATION_NO, ROWVERSION, ROWKEY)
                      SELECT CONTRACT, WAREHOUSE_ID, LOCATION_TYPE, LOCATION_NO, ROWVERSION, ROWKEY
                      FROM '|| table_name_ || ' wrdl
                      WHERE NOT EXISTS (SELECT 1    
                                        FROM   WAREHOUSE_DEFAULT_LOCATION_TAB
                                        WHERE  CONTRACT = wrdl.CONTRACT
                                        AND    WAREHOUSE_ID  = wrdl.WAREHOUSE_ID
                                        AND    LOCATION_TYPE = wrdl.LOCATION_TYPE);                
                  COMMIT;
                  END;';      
         EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRemoteWarehouseAddressData.sql','Timestamp_5');
PROMPT Finished with Inserting data from Inserting data from WHSE_RECEIPT_DEFAULT_LOC_TAB to WAREHOUSE_DEFAULT_LOCATION_TAB

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRemoteWarehouseAddressData.sql','Timestamp_6');
PROMPT Done with Requisitoiner data from PURCH to DISCOM
exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertRemoteWarehouseAddressData.sql','Done');
