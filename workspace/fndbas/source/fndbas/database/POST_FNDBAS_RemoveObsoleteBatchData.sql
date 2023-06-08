-----------------------------------------------------------------------------
--  Module : FNDBAS
--
--  File   : POST_FNDBAS_RemoveObsoleteBatchData.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  180220   Dobese  Remove Obsolete Batch Schedule Methods
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteBatchData.sql','Timestamp_1');
PROMPT Starting POST_FNDBAS_RemoveObsoleteData
BEGIN
   Batch_SYS.Rem_Cascade_Batch_Schedule_Met('SERVER_LOG_UTILITY_API.TRANSFER_AUDIT_RECORDS_');
END;
/

BEGIN
   Batch_SYS.Rem_Cascade_Batch_Schedule_Met('XLR_MV_UTIL_API.CLEANUP_MV_LOGS');
END;
/

BEGIN
   Batch_SYS.Rem_Cascade_Batch_Schedule_Met('SERVER_LOG_UTILITY_API.ALERT_LOG_ERRORS_');
END;
/
COMMIT;
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteBatchData.sql','Timestamp_2');
PROMPT Finished with POST_FNDBAS_RemoveObsoleteBatchData
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteBatchData.sql','Done');






