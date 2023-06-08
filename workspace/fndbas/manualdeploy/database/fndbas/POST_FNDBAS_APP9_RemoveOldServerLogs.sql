
-----------------------------------------------------------------------------------------
--
--  Module:       FNDBAS
--
--  File:         POST_FNDBAS_APP9_RemoveOldServerLogs.sql
--
--  Purpose:      The following Database Alert Log Categories are obsolete with APP9
--					- IFS Sessions
--					- Sessions
--					- Intrusions
--                If there is no need to keep the old records, use this script to delete them.
--
--  Note:		  This may take time if there are a lot of records. 
--------------------------------------------
--  Date    Sign      History
--  ------  ------    -------------------------------------------------------------------
--  150207	ChMuLK    Created.
-----------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP9_RemoveOldServerLogs.sql','Timestamp_1');
PROMPT POST_FNDBAS_APP9_RemoveOldServerLogs.sql

SET SERVEROUTPUT ON

DELETE FROM server_log_tab WHERE category_id = 'IFS Sessions';
COMMIT;
/

DELETE FROM server_log_tab WHERE category_id = 'Sessions';
COMMIT;
/

DELETE FROM server_log_tab WHERE category_id = 'Intrusions';
COMMIT;
/


SET SERVEROUT OFF;

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP9_RemoveOldServerLogs.sql','Timestamp_2');
PROMPT Execution of POST_FNDBAS_APP9_RemoveOldServerLogs.sql is Completed.
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP9_RemoveOldServerLogs.sql','Done');
