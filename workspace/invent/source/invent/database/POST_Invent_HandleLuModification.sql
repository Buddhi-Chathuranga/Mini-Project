--
--  Filename      : POST_Invent_HandleLuModification.sql
--
--  Module        : INVENT
--
--  Purpose       : This script will help you to migrate the existing configuration and related data when the existing LUs is remodeled. 
--                  It will support Key changes of existing LUs (adding,Removing ,Renaming Key), Rename of existing LUs, Or both Key change and Rename of existing LUs.
--                  Supported Configurations are Object Connections (Notes, Documents etc...), Custom Objects (only Custom Fields, Custom LU, Information Cards), History Log etc...
--                  
--  Note          : This Script is run automatically during the installation.
--
--
--
--  Date    Sign    History
--  ------  -----   ---------------------------------------------------------------------
--  180219  NaLrlk  Created.
-----------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_HandleLuModification.sql','Timestamp_1');
PROMPT Starting POST_Invent_HandleLuModification.sql

BEGIN
   Database_SYS.Handle_Lu_Modification(module_name_  => 'INVENT',
                                       old_lu_name_  => 'InventoryPartInStock');
   COMMIT;

   Database_SYS.Handle_Lu_Modification(module_name_  => 'INVENT',
                                       old_lu_name_  => 'MaterialRequisReservat');
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_HandleLuModification.sql','Done');
PROMPT Finished with POST_Invent_HandleLuModification.sql
