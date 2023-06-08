--
--  Filename      : POST_Order_HandleLuModification.sql
--
--  Module        : ORDER
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
--  180803  KiSalk  Bug 143348, Added code to handle added key SALES_PRICE_TYPE of LU 'SalesPartBasePrice'.
--  180216  NaLrlk  Created.
-----------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_HandleLuModification.sql','Timestamp_1');
PROMPT Starting POST_Order_HandleLuModification.sql

BEGIN
   Database_SYS.Handle_Lu_Modification(module_name_    => 'ORDER',
                                       old_lu_name_    => 'ShipmentOrderLine',
                                       in_new_lu_name_ => 'ShipmentLine', 
                                       key_ref_map_    => 'ORDER_NO=SOURCE_REF1^LINE_NO=SOURCE_REF2^REL_NO=SOURCE_REF3^LINE_ITEM_NO=SOURCE_REF4');

   COMMIT;

   Database_SYS.Handle_Lu_Modification(module_name_    => 'ORDER',
                                       old_lu_name_    => 'CustomerOrderDelivNote',
                                       in_new_lu_name_ => 'DeliveryNote');
   COMMIT;
   
   Database_SYS.Handle_Lu_Modification(module_name_    => 'ORDER',
                                       old_lu_name_    => 'CustomerReceiptLocation');
   COMMIT;

   Database_SYS.Handle_Lu_Modification(module_name_    => 'ORDER',
                                       old_lu_name_    => 'SalesPartBasePrice',
                                       in_regenerate_key_ref_ => TRUE);
   COMMIT;
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_HandleLuModification.sql','Done');
PROMPT Finished with POST_Order_HandleLuModification.sql
