---------------------------------------------------------------------------------------------------
--  Filename      : POST_FNDBAS_RefreshNavigatorTab.sql
-- 
--  Module        : FNDBAS 6.0.0
--
--  Purpose       : Refresh the navigator with new entries
-- 
--  Date      Sign      History
--  ------   ------    ----------------------------------------------------------------------------
--  180920   Maddlk    Created
---------------------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RefreshNavigatorTab.sql','Timestamp_1');
PROMPT Starting POST_FNDBAS_RefreshNavigatorTab.sql

SET SERVEROUTPUT ON

BEGIN
   Navigator_SYS.Insert_Navigator_Entries();
   COMMIT;
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RefreshNavigatorTab.sql','Done');
PROMPT Finished with POST_FNDBAS_RefreshNavigatorTab.sql
