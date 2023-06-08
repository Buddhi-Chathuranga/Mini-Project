-----------------------------------------------------------------------------
--  IFS Developer Studio Template Version 2.6
--  
--  Module        : SHPMNT
--
--  File          : POST_Shpmnt_DataCaptStartPick.sql
--
--  Module        : SHPMNT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process START_PICK.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.  
--  
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220513   Moinlk  SCDEV-7787, Rename the process menu label and description.
--  200910   dijwlk  Created for SC2020R1-1104
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCaptStartPick.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_2');
PROMPT Inserting START_PICK process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_          => 'START_PICK',
                                                               description_                 => 'Start Pick for Shipment',
                                                               process_package_             => 'DATA_CAPT_START_PICK_API',
                                                               process_component_           => 'SHPMNT',
                                                               config_menu_label_           => 'Start Pick for Shipment',
                                                               config_confirm_execution_db_ => 'FALSE');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_3');
PROMPT Inserting START_PICK process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   
--   Temporary commented since starting a Shipment Picking process through a Warehouse task is not yet implemented
--   Blocked By SC2020R1-1365
--   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICK',
--                                                              data_item_id_                  => 'WAREHOUSE_TASK_ID',
--                                                              description_                   => 'Warehouse Task ID',
--                                                              data_type_db_                  => 'NUMBER',
--                                                              process_key_db_                => 'FALSE',
--                                                              config_list_of_values_db_      => 'OFF',
--                                                              config_use_fixed_value_db_     => 'ALWAYS',
--                                                              config_hide_line_db_           => 'ALWAYS',
--                                                              config_use_subseq_value_db_    => 'FIXED',
--                                                              config_subseq_data_item_id_    => 'TASK_ID',
--                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICK',
                                                              data_item_id_                  => 'PICK_LIST_NO',
                                                              description_                   => 'Pick List No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
      
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICK',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
      
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICK',
                                                              data_item_id_                  => 'PICK_LIST_NO_LEVEL',
                                                              description_                   => 'Pick List No Level',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'PART_OR_HANDL_UNIT_LEVEL_API',
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              data_item_value_view_          => 'PART_OR_HANDL_UNIT_LEVEL',
                                                              data_item_value_pkg_           => 'PART_OR_HANDL_UNIT_LEVEL_API',
                                                              config_data_item_order_        => config_data_item_order_);
      
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICK',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICK',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_4');
PROMPT Inserting START_PICK process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICK',
                                                              feedback_item_id_   => 'LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'START_PICK',
                                                              feedback_item_id_    => 'LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICK',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICK',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICK',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICK',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICK',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_5');
PROMPT ADD CONFIG CTRL ITEM TO START_PICK process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_       => 'START_PICK',
                                                         config_ctrl_data_item_id_ => 'PICK_LIST_NO_LEVEL');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_6');
PROMPT Inserting START_PICK to SUBSEQ_DATA_CAPTURE_CONFIG_TAB
BEGIN
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_PICK',
                                                      control_item_value_            => 'PART',
                                                      subsequent_capture_process_id_ => 'PICK_PART');
      
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_PICK',
                                                      control_item_value_            => 'HANDLING_UNIT',
                                                      subsequent_capture_process_id_ => 'PICK_HU');
   
--   Blocked By SC2020R1-1365
--   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_WAREHOUSE_TASK',
--                                                      control_item_value_            => 'SHIPMENT ORDER PICK LIST',
--                                                      subsequent_capture_process_id_ => 'START_PICK');

-------- Including the subsequent configuration item for process PICK_PART and PICK_HU in this POST scrip to avoid inslattaion errors---------------

   -- Add START_PICK as subsequent configuration item for process PICK_PART (LAST_LINE_ON_PICK_LIST feedback item is the Subsequent Control Feedback Item in this case on PICK_PART)
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PICK_PART',
                                                      control_item_value_            => 'Y',
                                                      subsequent_capture_process_id_ => 'START_PICK');
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PICK_PART',
                                                      control_item_value_            => 'N',
                                                      subsequent_capture_process_id_ => 'START_PICK');
   
--   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PICK_PART',
--                                                      control_item_value_            => 'Y',
--                                                      subsequent_capture_process_id_ => 'START_WAREHOUSE_TASK');
   
   -- Add START_PICK as subsequent configuration item for process PICK_HU (LAST_LINE_ON_PICK_LIST feedback item is the Subsequent Control Feedback Item in this case on PICK_HU)
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PICK_HU',
                                                      control_item_value_            => 'Y',
                                                      subsequent_capture_process_id_ => 'START_PICK');
   
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PICK_HU',
                                                      control_item_value_            => 'N',
                                                      subsequent_capture_process_id_ => 'START_PICK');

--   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PICK_HU',
--                                                      control_item_value_            => 'Y',
--                                                      subsequent_capture_process_id_ => 'START_WAREHOUSE_TASK');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_7');
PROMPT Inserting PICK_LIST_NO/WAREHOUSE_TASK_ID/TASK_ID to SUBSEQ_CONFIG_DATA_ITEM_TAB FOR both sub processes
BEGIN
   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICK',
                                                              control_item_value_      => 'PART',
                                                              data_item_id_            => 'PICK_LIST_NO',
                                                              subsequent_data_item_id_ => 'PICK_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');
   
--   Blocked By SC2020R1-1365
--   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICK',
--                                                              control_item_value_      => 'PART',
--                                                              data_item_id_            => 'WAREHOUSE_TASK_ID',
--                                                              subsequent_data_item_id_ => 'WAREHOUSE_TASK_ID',
--                                                              use_subsequent_value_db_ => 'FIXED');

   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICK',
                                                              control_item_value_      => 'HANDLING_UNIT',
                                                              data_item_id_            => 'PICK_LIST_NO',
                                                              subsequent_data_item_id_ => 'PICK_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');
                                                              
--   Blocked By SC2020R1-1365
--   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICK',
--                                                              control_item_value_      => 'HANDLING_UNIT',
--                                                              data_item_id_            => 'WAREHOUSE_TASK_ID',
--                                                              subsequent_data_item_id_ => 'WAREHOUSE_TASK_ID',
--                                                              use_subsequent_value_db_ => 'FIXED');
   
--   Blocked By SC2020R1-1365
--   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_WAREHOUSE_TASK',
--                                                              control_item_value_      => 'SHIPMENT ORDER PICK LIST',
--                                                              data_item_id_            => 'TASK_ID',
--                                                              subsequent_data_item_id_ => 'WAREHOUSE_TASK_ID',
--                                                              use_subsequent_value_db_ => 'FIXED');

-------- Including the subsequent configuration data items for process PICK_PART and PICK_HU in this POST scrip to avoid inslattaion errors---------------
   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'PICK_PART',
                                                              control_item_value_      => 'N',
                                                              data_item_id_            => 'PICK_LIST_NO',
                                                              subsequent_data_item_id_ => 'PICK_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');

   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'PICK_HU',
                                                              control_item_value_      => 'N',
                                                              data_item_id_            => 'PICK_LIST_NO',
                                                              subsequent_data_item_id_ => 'PICK_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_8');
PROMPT Inserting this process as default subsequent process for both sub processes and itself as default for START_PICK
BEGIN
   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'PICK_PART',
                                                               subsequent_capture_process_id_ => 'START_PICK');
   
   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'PICK_HU',
                                                               subsequent_capture_process_id_ => 'START_PICK');

   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'START_PICK',
                                                               subsequent_capture_process_id_ => 'START_PICK');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Timestamp_9');
PROMPT Inserting START_PICK process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'START_PICK',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

END;
/

COMMIT;
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptStartPick.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCaptStartPick.sql
