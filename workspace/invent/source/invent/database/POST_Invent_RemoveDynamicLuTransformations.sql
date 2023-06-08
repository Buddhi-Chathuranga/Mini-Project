---------------------------------------------------------------------
--
--  File: POST_Invent_RemoveDynamicLuTransformations.sql
--
--  Module        : INVENT
--
--  Purpose       : Unregister the ObjectConnections for InventoryPart AND InventoryPartInStock LUs if the related dynamic components are not installed.
--
--
--  Date    Sign    History
--  ------  ----    -------------------------------------------------
--  160129  ChJalk  Bug 125845, Created.
---------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RemoveDynamicLuTransformations.sql','Timestamp_1');
PROMPT Unregistering DocReferenceObjects FOR InventoryPart AND InventoryPartInStock.

BEGIN
   $IF NOT Component_Pdmcon_SYS.INSTALLED $THEN
      Obj_Connect_Lu_Transform_API.Unregister('InventoryPart',        'EngPartRevision', 'DocReferenceObject');
      Obj_Connect_Lu_Transform_API.Unregister('InventoryPartInStock', 'EngPartRevision', 'DocReferenceObject');
   $END
   $IF NOT Component_Mfgstd_SYS.INSTALLED $THEN
      Obj_Connect_Lu_Transform_API.Unregister('InventoryPartInStock', 'PartRevision', 'DocReferenceObject');
   $ELSE
      NULL;
   $END
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RemoveDynamicLuTransformations.sql','Timestamp_2');
PROMPT Done with Unregistering DocReferenceObjects FOR InventoryPart AND InventoryPartInStock.
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RemoveDynamicLuTransformations.sql','Done');
