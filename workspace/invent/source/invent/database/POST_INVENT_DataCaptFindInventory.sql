-----------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_DataCaptFindInventory.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process FIND_INVENTORY.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171019  SWiclk  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptFindInventory.sql','Timestamp_1');
PROMPT Starting POST_INVENT_DataCaptFindInventory.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptFindInventory.sql','Timestamp_2');
PROMPT Inserting FIND_INVENTORY process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_      => 'FIND_INVENTORY',
                                                               description_             => 'Find Inventory',
                                                               process_package_         => 'DATA_CAPT_FIND_INVENTORY_API',
                                                               process_component_       => 'INVENT',
                                                               config_menu_label_       => 'Find Inventory',
                                                               sort_list_descending_db_ => 'FALSE');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptFindInventory.sql','Timestamp_3');
PROMPT Inserting FIND_INVENTORY process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1; 
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'FIND_INVENTORY',
                                                              data_item_id_                  => 'GTIN',
                                                              description_                   => 'GTIN',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 14,
                                                              config_list_of_values_db_      => 'OFF',                                                              
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              config_use_fixed_value_db_     => 'ALWAYS',                                                              
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'FALSE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'FIND_INVENTORY',
                                                              data_item_id_                  => 'PART_NO',
                                                              description_                   => 'Part No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'FIND_INVENTORY',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'FIND_INVENTORY', 
                                                              data_item_id_                  => 'GS1_BARCODE1', 
                                                              description_                   => 'GS1 Barcode 1', 
                                                              data_type_db_                  => 'GS1', 
                                                              process_key_db_                => 'FALSE', 
                                                              uppercase_db_                  => 'FALSE', 
                                                              string_length_                 => 4000, 
                                                              config_use_fixed_value_db_     => 'ALWAYS', 
                                                              config_hide_line_db_           => 'ALWAYS', 
                                                              config_data_item_order_        => config_data_item_order_); 

     
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptFindInventory.sql','Timestamp_4');
PROMPT Inserting FIND_INVENTORY process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
     
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'FIND_INVENTORY',
                                                              feedback_item_id_   => 'PART_NO_ON_HAND_QTY_UOM',
                                                              description_        => 'Part No | On Hand Qty | UoM',
                                                              data_type_          => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'FIND_INVENTORY',
                                                              feedback_item_id_   => 'AVAILABLE_QTY_RESERVED_QTY_UOM',
                                                              description_        => 'Available Qty | Reserved Qty | UoM',
                                                              data_type_          => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'FIND_INVENTORY',
                                                              feedback_item_id_   => 'LOCATION_NO_ON_HAND_QTY_UOM',
                                                              description_        => 'Location No | On Hand Qty | UoM',
                                                              data_type_          => 'STRING');  

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'FIND_INVENTORY',
                                                              feedback_item_id_   => 'WAREHOUSE_BAY_ROW_TIER_BIN',
                                                              description_        => 'Warehouse | Bay | Row | Tier | Bin',
                                                              data_type_          => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'FIND_INVENTORY',
                                                              feedback_item_id_   => 'LOCATION_NO_DESC',
                                                              description_        => 'Location No Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'FIND_INVENTORY',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptFindInventory.sql','Timestamp_5');
PROMPT Connecting feedback items to all configurations
-- Connect feedback items to data items
BEGIN
   Data_Capture_Common_Util_API.Conn_Detail_Data_Item_All_Conf(capture_process_id_  => 'FIND_INVENTORY',
                                                               data_item_id_        => 'PART_NO',
                                                               data_item_detail_id_ => 'LOCATION_NO_ON_HAND_QTY_UOM',
                                                               item_type_db_        => 'FEEDBACK');
   
   Data_Capture_Common_Util_API.Conn_Detail_Data_Item_All_Conf(capture_process_id_  => 'FIND_INVENTORY',
                                                               data_item_id_        => 'PART_NO',
                                                               data_item_detail_id_ => 'WAREHOUSE_BAY_ROW_TIER_BIN',
                                                               item_type_db_        => 'FEEDBACK');
   
   Data_Capture_Common_Util_API.Conn_Detail_Data_Item_All_Conf(capture_process_id_  => 'FIND_INVENTORY',
                                                               data_item_id_        => 'PART_NO',
                                                               data_item_detail_id_ => 'AVAILABLE_QTY_RESERVED_QTY_UOM',
                                                               item_type_db_        => 'FEEDBACK');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptFindInventory.sql','Timestamp_6');
PROMPT Inserting FIND_INVENTORY process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'FIND_INVENTORY',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

END;
/



COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptFindInventory.sql','Done');
PROMPT Finished with POST_INVENT_DataCaptFindInventory.sql
