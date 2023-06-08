-----------------------------------------------------------------------------
--  Module : DISCOM
--
--  File   : POST_DISCOM_UpdateRemoteWarehouseAddressData.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  210824   SBalLK  SC21R2-2364, Created. When system upgrade from application 9/10 cause not having ADDRESS_TYPE column updated with 
--  210824           relevant information. The reason is that migration of remote warehouse data to WHSE_SHIPMENT_RECEIPT_INFO_TAB
--  210824           from WAREHOUSE_PURCH_INFO_TAB/2110 happens through post sql file POST_DISCOM_InsertRemoteWarehouseAddressData.sql.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------


SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_UpdateRemoteWarehouseAddressData.sql','Timestamp_1');
PROMPT POST_DISCOM_UpdateRemoteWarehouseAddressData.sql

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_UpdateRemoteWarehouseAddressData.sql','Timestamp_2');
PROMPT Updating ADDRESS_TYPE column with default values in WHSE_SHIPMENT_RECEIPT_INFO_TAB
DECLARE
BEGIN
   UPDATE whse_shipment_receipt_info_tab
   SET address_type = ( CASE 
                        WHEN company     IS NOT NULL THEN 'COMPANY'
                        WHEN person_id   IS NOT NULL THEN 'PERSON'
                        WHEN customer_id IS NOT NULL THEN 'CUSTOMER'
                        WHEN supplier_id IS NOT NULL THEN 'SUPPLIER'
                        END )
   WHERE company||person_id||customer_id||supplier_id IS NOT NULL
   AND   address_type IS NULL;
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_UpdateRemoteWarehouseAddressData.sql','Done');
PROMPT Finished with POST_DISCOM_UpdateRemoteWarehouseAddressData.sql
