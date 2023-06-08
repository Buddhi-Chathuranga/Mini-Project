
-----------------------------------------------------------------------------------------
--
--  Module:       FNDBAS
--
--  File:         POST_FNDBAS_Clean_LanguageSysTab.sql
--
--  Purpose:      Clean Language_Sys_Tab by deleting SO & RWC. SO & RWC not required to be in Language_Sys_Tab 
--				  In APP 8. THIS MAY TAKE LONG TIME.
--------------------------------------------
--  Date    Sign      History
--  ------  ------    -------------------------------------------------------------------
--  111102  SRSOLK    Created.
-----------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_Clean_LanguageSysTab.sql','Timestamp_1');
PROMPT POST_FNDBAS_Clean_LanguageSysTab.sql

SET SERVEROUTPUT ON

DELETE FROM language_sys_tab t
WHERE t.main_type ='SO';
 COMMIT;
 
DELETE FROM language_sys_tab t
WHERE t.main_type ='RWC';
 COMMIT;

SET SERVEROUT OFF;

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_Clean_LanguageSysTab.sql','Timestamp_2');
PROMPT Execution of POST_FNDBAS_Clean_LanguageSysTab.sql is Completed.
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_Clean_LanguageSysTab.sql','Done');
