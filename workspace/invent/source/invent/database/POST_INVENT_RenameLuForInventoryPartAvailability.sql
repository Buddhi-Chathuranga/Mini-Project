-----------------------------------------------------------------------------
--  Module : INVENT
--
--  File   : POST_INVENT_RenameLuForInventoryPartAvailability.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  210514   SBalLK  Bug 159340(SCZ-14868), Created to handle LU changes from "OrderSupplyDemand" to "InvPartConfigProject"
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RenameLuForInventoryPartAvailability.sql','Timestamp_1');
PROMPT Starting with POST_INVENT_RenameLuForInventoryPartAvailability.sql
PROMPT Handle LU changes from "OrderSupplyDemand" to "InvPartConfigProject" in IPAP to migrate custom information.

DECLARE
BEGIN
   Database_SYS.Handle_Lu_Modification(module_name_    => 'INVENT',
                                       old_lu_name_    => 'OrderSupplyDemand',
                                       in_new_lu_name_ => 'InvPartConfigProject');
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_RenameLuForInventoryPartAvailability.sql','Done');
PROMPT Finished with POST_INVENT_RenameLuForInventoryPartAvailability.sql
