-----------------------------------------------------------------------------
--  Module : APPSRV
--
--  File   : POST_Appsrv_UpdateRenamedFssToFs.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  211103   deeklk  Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateRenamedFssToFs.sql','Timestamp_1');
PROMPT Updating OBJECT Propety VALUE FOR MediaItem TO FILE_STORAGE which has THE VALUE FSS.

DECLARE
   lu_         VARCHAR2 (30) := 'MediaItem';
   key_        VARCHAR2 (30) := 'ITEM_ID';
   name_       VARCHAR2 (30) := 'REPOSITORY';
   old_value_  VARCHAR2 (30) := 'FSS';
   new_value_  VARCHAR2 (30) := 'FILE_STORAGE';
BEGIN
   IF Object_Property_API.Get_Value(lu_, key_, name_) = old_value_ THEN
      Object_Property_API.Set_Value(lu_, key_, name_, new_value_, 'TRUE', 'Media_Item_Util_API.Validate_Parameter');
   END IF;
   COMMIT;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateRenamedFssToFs.sql','Timestamp_2');
PROMPT Updating MediaItems which has repository AS FILE_STORAGE_SERVICE TO FILE_STORAGE

BEGIN   
   UPDATE media_item_tab
   SET repository = 'FILE_STORAGE'
   WHERE repository = 'FILE_STORAGE_SERVICE';
   COMMIT;
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdateRenamedFssToFs.sql','Done');
PROMPT Finished with POST_Appsrv_UpdateRenamedFssToFs.SQL