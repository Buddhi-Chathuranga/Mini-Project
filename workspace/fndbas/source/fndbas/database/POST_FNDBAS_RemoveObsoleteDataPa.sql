--------------------------------------------------------------------------
--  File:      POST_FNDBAS_RemoveObsoleteDataPa.sql
--
--  Module:    FNDBAS
--
--  Purpose:   Remove old data from Print Agent tables.
--
--  Date    Sign   History
--  ------  -----  -------------------------------------------------------
--  171219  CHAALK Created.
--------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteDataPa.sql','Timestamp_1');
PROMPT Starting POST_FNDBAS_RemoveObsoleteDataPa

BEGIN
   DELETE FROM REMOTE_PRINTING_NODE_TAB;
   DELETE FROM REMOTE_PRINTER_MAPPING_TAB;
   COMMIT;
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteDataPa.sql','Timestamp_2');
PROMPT Finished with POST_FNDBAS_RemoveObsoleteDataPa
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteDataPa.sql','Done');
