-----------------------------------------------------------------------------
--  Module : SHPMNT
--
--  File   : POST_Shpmnt_CreateHandlUnitHistory.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  200117   ChBnlk  Bug 151920(SCZ-8244), Modified the cursor get_shipment_id in order to consider the delivered shipments.
--  190117   KiSalk  Bug 146355(SCZ-2546), Made code committed in LOOP to improve performance when high volume of data is processed.
--  161122   MaEelk  LIM-9330, Copied HANDLING_UNIT_TAB data which are connected to closed shipments into HANDLING_UNIT_HISTORY_TAB.
--  161122           Made the shipment_id null for those copied data in HANDLING_UNIT_ID_TAB.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_CreateHandlUnitHistory.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_CreateHandlUnitHistory.SQL


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_CreateHandlUnitHistory.sql','Timestamp_2');
PROMPT Starting POST_Shpmnt_CreateHandlUnitHistory.sql

DECLARE
   CURSOR get_shipment_id IS
      SELECT sh.shipment_id
      FROM  shipment_tab sh
      WHERE ((sh.rowstate = 'Closed')
         OR    (sh.rowstate = 'Completed' 
                        AND EXISTS (SELECT 1
                           FROM   shipment_line_tab shl
                           WHERE  shl.shipment_id = sh.shipment_id 
                           AND    shl.qty_shipped > 0)
                           ))
      AND   EXISTS (SELECT 1
                    FROM   handling_unit_tab hu
                    WHERE  hu.shipment_id = sh.shipment_id);

   shipment_id_tab_  Shipment_API.Shipment_Id_Tab;
BEGIN
   OPEN get_shipment_id;
   LOOP
      FETCH get_shipment_id BULK COLLECT INTO shipment_id_tab_ LIMIT 1000;
      EXIT WHEN shipment_id_tab_.COUNT = 0;

      FOR i IN shipment_id_tab_.FIRST..shipment_id_tab_.LAST LOOP
        Handling_Unit_API.Create_Shipment_Hist_Snapshot(shipment_id_tab_(i));
      END LOOP;
      COMMIT;

   END LOOP;
   CLOSE get_shipment_id;

END;
/

PROMPT Finished POST_Shpmnt_CreateHandlUnitHistory.sql

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_CreateHandlUnitHistory.sql','Done');
