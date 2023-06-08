-----------------------------------------------------------------------------
--  Module     : INVENT
--
--  File       : POST_Invent_MoveBasicDataTransBetweenModules.sql
--
--  Purpose    : Remove basic data translations inserted for the PARTCA component and reinsert them to INVENT component.
--
--  Date           Sign    History
--  ------------   ------  --------------------------------------------------
--  141201         ChBnlk  PRSC-4504, Removed basic data translations for the LUs 'StorageCapability', 'StorageCapacityReqGroup', 'StorageCondReqGroup',
--                         'StorageCapabilReqGroup' from the PARTCA module and moved them to INVENT module.
--  ------------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_MoveBasicDataTransBetweenModules.sql','Timestamp_1');
PROMPT POST_Invent_MoveBasicDataTransBetweenModules.sql
SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_MoveBasicDataTransBetweenModules.sql','Timestamp_2');
PROMPT Removing the basic data translations added to the PARTCA module for the LUs StorageCapability, StorageCapacityReqGroup, StorageCondReqGroup, StorageCapabilReqGroup and reinstalling those using INVENT module.

DECLARE
   TYPE Language_Sys_Temp_Rec IS RECORD(
      path				         LANGUAGE_SYS_TAB.PATH%TYPE,
      lang_code			      LANGUAGE_SYS_TAB.LANG_CODE%TYPE,
      text				         LANGUAGE_SYS_TAB.TEXT%TYPE);

   TYPE Language_Sys_Temp_Tab IS TABLE OF Language_Sys_Temp_Rec INDEX BY PLS_INTEGER;
   language_sys_tmp_tab_   Language_Sys_Temp_Tab;

   CURSOR get_storage_capability_records IS
      SELECT path, lang_code, text
      FROM language_sys_tab
      WHERE SUBSTR(path, 1, INSTR(path, '_')-1) IN ('StorageCapability', 'StorageCapacityReqGroup', 'StorageCondReqGroup', 'StorageCapabilReqGroup')
      AND module = 'PARTCA'
      AND type = 'Basic Data';

BEGIN
   OPEN get_storage_capability_records;
   FETCH get_storage_capability_records BULK COLLECT INTO language_sys_tmp_tab_;
   CLOSE get_storage_capability_records;

   IF (language_sys_tmp_tab_.COUNT>0) THEN
      FOR i IN language_sys_tmp_tab_.FIRST.. language_sys_tmp_tab_.LAST LOOP
         Basic_Data_Translation_API.Remove_Basic_Data_Translation('PARTCA',
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, 1, INSTR(language_sys_tmp_tab_(i).path, '_')-1),
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, INSTR(language_sys_tmp_tab_(i).path, '.')+1));

         Basic_Data_Translation_API.Insert_Basic_Data_Translation('INVENT',
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, 1, INSTR(language_sys_tmp_tab_(i).path, '_')-1),
                                                                   SUBSTR(language_sys_tmp_tab_(i).path, INSTR(language_sys_tmp_tab_(i).path, '.')+1),
                                                                   language_sys_tmp_tab_(i).lang_code,
                                                                   language_sys_tmp_tab_(i).text);
      END LOOP;
   END IF;

   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_MoveBasicDataTransBetweenModules.sql','Done');
PROMPT Finished with POST_Invent_MoveBasicDataTransBetweenModules.sql
