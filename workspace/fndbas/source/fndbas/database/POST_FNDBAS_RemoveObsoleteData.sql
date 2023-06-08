--------------------------------------------------------------------------
--  File:      POST_FNDBAS_RemoveObsoleteData.sql
--
--  Module:    FNDBAS
--
--  Purpose:   Remove misc obsolete data.
--
--  Date    Sign   History
--  ------  -----  -------------------------------------------------------
--  140905  MaBose Created.
--------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteData.sql','Timestamp_1');
PROMPT Starting POST_FNDBAS_RemoveObsoleteData
BEGIN
   Batch_SYS.Rem_Cascade_Batch_Schedule_Met('FND_EVENT_MY_MESSAGES_API.CLEANUP__');
END;
/

BEGIN
   Batch_SYS.Rem_Cascade_Batch_Schedule_Met('ROWKEY_PREPARE_API.ROWKEY_UPDATE');
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteData.sql','Timestamp_2');
PROMPT Finished with POST_FNDBAS_RemoveObsoleteData
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteData.sql','Done');
