---------------------------------------------------------------------
--
--  File: POST_DISCOM_RenameObsoleteTable.sql
--
--  Module        : DISCOM
--
--  Purpose       : Migrate Delivery route data from ORDER as it is now common for both ORDER and PURCH.
--                  This need to be in post script to avoid deployment errors when ORDER TABLE structure(table columns) is differ with update_from and update_to versions.
--                  As ORDER is dynamic to DISCOM, the data inserting is occured before updating the table structure change in ORDER.
--
--  Note          : Inserte data from CUSTOMER_ORDER_ROUTE_TAB to DELIVERY_ROUTE_TAB.
--                  Inserte data from CUST_ORDER_ROUTE_SCHEDULE_TAB to DELIVERY_ROUTE_SCHEDULE_TAB.
--                  Inserte data from CUST_ORDER_ROUTE_EXCEPTION_TAB to DELIVERY_ROUTE_EXCEPTION_TAB
--
--
--  Date    Sign    History
--  ------  ----    -------------------------------------------------
--  150525  ChFolk  Created.
---------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_1');
PROMPT Migrate Delivery Route data from ORDER to DISCOM

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_2');
PROMPT Inserting data from CUSTOMER_ORDER_ROUTE_TAB to DELIVERY_ROUTE_TAB

DECLARE
   stmt_        VARCHAR2(32000);
BEGIN
   -- Note:  CUSTOMER_ORDER_ROUTE_TAB is renamed to CUSTOMER_ORDER_ROUTE_1420 and this code section is
   --        executed in dynamic code in order to avoid compilation errors when re-deploying.
   IF Database_SYS.Table_Exist('CUSTOMER_ORDER_ROUTE_TAB') THEN
      stmt_ := 'INSERT INTO DELIVERY_ROUTE_TAB (
                   route_id,
                   description,
                   forward_agent_id,
                   check_on_line_level,
                   rowversion,
                   rowkey)
                SELECT
                   route_id,
                   description,
                   forward_agent_id,
                   check_on_line_level,
                   rowversion,
                   rowkey
                FROM CUSTOMER_ORDER_ROUTE_TAB';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_3');
PROMPT Finished with Inserting data from CUSTOMER_ORDER_ROUTE_TAB to DELIVERY_ROUTE_TAB

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_4');
PROMPT Inserting data from CUST_ORDER_ROUTE_SCHEDULE_TAB to DELIVERY_ROUTE_SCHEDULE_TAB

DECLARE
   stmt_        VARCHAR2(32000);
BEGIN
   -- Note:  CUST_ORDER_ROUTE_SCHEDULE_TAB is renamed to CUST_ORDER_ROUTE_SCHEDULE_1420 and this code section is
   --        executed in dynamic code in order to avoid compilation errors when re-deploying.
   IF Database_SYS.Table_Exist('CUST_ORDER_ROUTE_SCHEDULE_TAB') THEN
      stmt_ := 'INSERT INTO DELIVERY_ROUTE_SCHEDULE_TAB (
                   route_id,
                   route_day,
                   ship_time,
                   order_stop_days,
                   order_stop_time,
                   rowversion,
                   rowkey)
                SELECT
                   route_id,
                   route_day,
                   ship_time,
                   order_stop_days,
                   order_stop_time,
                   rowversion,
                   rowkey
                FROM CUST_ORDER_ROUTE_SCHEDULE_TAB';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_5');
PROMPT Finished with Inserting data from CUST_ORDER_ROUTE_SCHEDULE_TAB to DELIVERY_ROUTE_SCHEDULE_TAB

exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_6');
PROMPT Inserting data from CUST_ORDER_ROUTE_EXCEPTION_TAB to DELIVERY_ROUTE_EXCEPTION_TAB

DECLARE
   stmt_        VARCHAR2(32000);
BEGIN
   -- Note:  CUST_ORDER_ROUTE_EXCEPTION_TAB is renamed to CUST_ORDER_ROUTE_EXCEPTION_1420 and this code section is
   --        executed in dynamic code in order to avoid compilation error when re-deploying.
   IF Database_SYS.Table_Exist('CUST_ORDER_ROUTE_EXCEPTION_TAB') THEN
      stmt_ := 'INSERT INTO DELIVERY_ROUTE_EXCEPTION_TAB (
                   route_id,
                   contract,
                   exception_date,
                   ship_time,
                   exception_type,
                   order_stop_days,
                   order_stop_time,
                   rowversion,
                   rowkey)
                SELECT
                   route_id,
                   contract,
                   exception_date,
                   ship_time,
                   exception_type,
                   order_stop_days,
                   order_stop_time,
                   rowversion,
                   rowkey
                FROM CUST_ORDER_ROUTE_EXCEPTION_TAB';
      EXECUTE IMMEDIATE stmt_;
      COMMIT;
   END IF;
END;
/
exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_7');
PROMPT Finished with Inserting data from CUST_ORDER_ROUTE_EXCEPTION_TAB to DELIVERY_ROUTE_EXCEPTION_TAB


exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Timestamp_8');
PROMPT Done with Migrate Delivery Route data from ORDER to DISCOM
--------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('DISCOM','POST_DISCOM_InsertDeliveryRouteInfo.sql','Done');
