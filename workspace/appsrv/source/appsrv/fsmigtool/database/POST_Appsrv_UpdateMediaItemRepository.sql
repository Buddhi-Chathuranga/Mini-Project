-----------------------------------------------------------------------------
--  Module : APPSRV
--
--  File   : POST_Appsrv_UpdateMediaItemRepository.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  211103   deeklk  Created.
-----------------------------------------------------------------------------
--  NOTE: This script is only for the use during the post upgrade phase. 
--        This is to update the repository of media items after migrating  
--        media using File Storage Migration Tool.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

DEFINE message1 = 'Updating REPOSITORY attribute to FILE_STORAGE for succesfully migrated Media Items.'

EXEC Installation_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateMediaItemRepository.sql','Timestamp_1');
PROMPT &message1

DECLARE
   CURSOR get_migrated_keyrefs IS
      SELECT key_ref
      FROM fs_mig_status_tab
      WHERE status = 'Done'
      AND lu_name = 'MediaItem';
      
      item_id_ NUMBER;
   
   PROCEDURE Update_Repository___(item_id_ IN NUMBER)
   IS
   BEGIN
      UPDATE media_item_tab
      SET repository = 'FILE_STORAGE'
      WHERE item_id = item_id_;
   END Update_Repository___;
   
BEGIN
   FOR rec_ IN get_migrated_keyrefs LOOP
      item_id_ := to_number(Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'ITEM_ID'));
      Update_Repository___(item_id_);
   END LOOP;
   COMMIT;
END;
/

EXEC Installation_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateMediaItemRepository.sql','Done');

