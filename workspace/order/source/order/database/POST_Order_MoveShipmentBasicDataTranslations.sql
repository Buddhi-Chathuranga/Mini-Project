-----------------------------------------------------------------------------
--  Module     : ORDER
--
--  File       : POST_Order_MoveShipmentBasicDataTranslations.sql
--
--  Purpose    : Remove basic data translations related to ShipmentType and ShipmentEvent LUs
--             : in ORDER module and reinsert into SHPMNT module.
--
--  Date       Sign    History
--  --------   ------  --------------------------------------------------
--  151130     MaRalk  LIM-4594, Removed basic data translations for the LUs 'ShipmentType'
--  151130             and 'ShipmentEvent' from ORDER module and moved to SHPMNT module.
--  --------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_MoveShipmentBasicDataTranslations.sql','Timestamp_1');
PROMPT POST_Order_MoveShipmentBasicDataTranslations.sql
SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_MoveShipmentBasicDataTranslations.sql','Timestamp_2');
PROMPT Removing basic data translations belonging to the ORDER module for the LUs ShipmentType, ShipmentEvent and reinserting those into SHPMNT module.

DECLARE
   TYPE Language_Sys_Temp_Rec IS RECORD(
      path				         LANGUAGE_SYS_TAB.PATH%TYPE,
      lang_code			      LANGUAGE_SYS_TAB.LANG_CODE%TYPE,
      text				         LANGUAGE_SYS_TAB.TEXT%TYPE);

   TYPE Language_Sys_Temp_Tab IS TABLE OF Language_Sys_Temp_Rec INDEX BY PLS_INTEGER;
   language_sys_tmp_tab_   Language_Sys_Temp_Tab;

   CURSOR get_shipment_type_records IS
      SELECT path, lang_code, text
      FROM language_sys_tab
      WHERE SUBSTR(path, 1, INSTR(path, '_')-1) IN ('ShipmentType', 'ShipmentEvent')
      AND module = 'ORDER'
      AND type = 'Basic Data';

BEGIN
   -- Moving basic data translations of ShipmentType and ShipmentEvent LUs from ORDER to SHPMNT.
   OPEN get_shipment_type_records;
   FETCH get_shipment_type_records BULK COLLECT INTO language_sys_tmp_tab_;
   CLOSE get_shipment_type_records;

   IF (language_sys_tmp_tab_.COUNT>0) THEN
      FOR i IN language_sys_tmp_tab_.FIRST.. language_sys_tmp_tab_.LAST LOOP
         Basic_Data_Translation_API.Remove_Basic_Data_Translation('ORDER',
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, 1, INSTR(language_sys_tmp_tab_(i).path, '_')-1),
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, INSTR(language_sys_tmp_tab_(i).path, '.')+1));

         Basic_Data_Translation_API.Insert_Basic_Data_Translation('SHPMNT',
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, 1, INSTR(language_sys_tmp_tab_(i).path, '_')-1),
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, INSTR(language_sys_tmp_tab_(i).path, '.')+1),
                                                                   language_sys_tmp_tab_(i).lang_code,
                                                                   language_sys_tmp_tab_(i).text);
      END LOOP;
   END IF;

   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_MoveShipmentBasicDataTranslations.sql','Done');
PROMPT Finished with POST_Order_MoveShipmentBasicDataTranslations.sql


