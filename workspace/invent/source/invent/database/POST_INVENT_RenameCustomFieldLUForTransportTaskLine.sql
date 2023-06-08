-------------------------------------------------------------------------------------------------
--  Module : INVNET
--
--  File   : POST_INVENT_RenameCustomFieldLUForTransportTaskLine.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  ------------------------------------------------------------------------------
--  210427   JaThlk  Bug 158966 (SCZ-14490), Added Custom_Objects_SYS instead of Custom_Obj_SYS to resolve the dynamic dependency issue.
--  201013   BudKLK  Bug 155449(SCZ-11792), Added to support upgrades from APP8 Custom Fields migrate from Logical Units 
--  201013           TransportTaskLineNopall and TranportTaskLinePallet to the new Logical Unit TransportTaskLine.
--  ------   ------  ------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
   
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RenameCustomFieldLUForTransportTaskLine.sql','Timestamp_1');
PROMPT Replaced the logical units to TransportTaskLine avoid in order to support custom fields.

BEGIN
   Custom_Objects_SYS.Handle_Lu_Modification('TransportTaskLineNopall','TransportTaskLine');
   Custom_Objects_SYS.Handle_Lu_Modification('TranportTaskLinePallet','TransportTaskLine');  
   COMMIT;
END;
/

PROMPT Finished with POST_INVENT_RenameCustomFieldLUForTransportTaskLine.SQL
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RenameCustomFieldLUForTransportTaskLine.sql','Done');
