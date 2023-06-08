-------------------------------------------------------------------------------
--  Module : INVENT
--
--  Purpose: Inserting data into DataCaptureProcess and
--           DataCaptureConfig tables for process PROCESS_TRANSPORT_TASK_HU.
--
--  File   : POST_Invent_DataCaptTranspTaskHu.sql
--
--  IFS/Design Template Version 2.3
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171026  DaZase  STRSC-13037, Added GS1_BARCODE1, GS1_BARCODE2 as new data items.
--  170314  DaZase  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_1');
PROMPT Starting POST_Invent_DataCaptTranspTaskHu.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_2');
PROMPT Inserting TRANSPORT_TASK_HANDLING_UNIT process to DataCaptureProcess and DataCaptureConfig
-- Add New Process and Configuration
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                               description_        => 'Process Handling Unit on Transport Task',
                                                               process_package_    => 'DATA_CAPT_TRANSP_TASK_HU_API',
                                                               process_component_  => 'INVENT',
                                                               config_menu_label_  => 'Process HU on Transport Task');
END;
/
--
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_3');
PROMPT Inserting TRANSPORT_TASK_HANDLING_UNIT process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'WAREHOUSE_TASK_ID',
                                                              description_                   => 'Warehouse Task ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              config_subseq_data_item_id_    => 'WAREHOUSE_TASK_ID',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'TRANSPORT_TASK_ID',
                                                              description_                   => 'Transport Task ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              config_subseq_data_item_id_    => 'TRANSPORT_TASK_ID',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'AGGREGATED_LINE_ID',
                                                              description_                   => 'Aggregated Line ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'TRANSPORT_TASK_STATUS',
                                                              description_                   => 'Transport Task Status',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_list_of_values_db_      => 'ON',
                                                              enumeration_package_           => 'TRANSPORT_TASK_STATUS_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'FROM_CONTRACT',
                                                              description_                   => 'From Site',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 5,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'FROM_LOCATION_NO',
                                                              description_                   => 'From Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 35,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'ACTION',
                                                              description_                   => 'Action',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_list_of_values_db_      => 'ON',
                                                              enumeration_package_           => 'TRANSPORT_TASK_HU_ACTION_API',
                                                              config_default_value_          => 'EXECUTE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'DESTINATION',
                                                              description_                   => 'Destination',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_fixed_value_            => 'N',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'FORCED',
                                                              enumeration_package_           => 'INVENTORY_PART_DESTINATION_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'TO_CONTRACT',
                                                              description_                   => 'To Site',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 5,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'TO_LOCATION_NO',
                                                              description_                   => 'To Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 35,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
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


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_4');
PROMPT Inserting TRANSPORT_TASK_HANDLING_UNIT process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN

   ------------------------------------------------------------------------------------------------------------------
   -- Location related feedback items -------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TO_WAREHOUSE',
                                                              description_        => 'To Warehouse',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TO_BAY_ID',
                                                              description_        => 'To Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TO_ROW_ID',
                                                              description_        => 'To Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TO_TIER_ID',
                                                              description_        => 'To Tier',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TO_BIN_ID',
                                                              description_        => 'To Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TO_LOCATION_GROUP',
                                                              description_        => 'To Location Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TO_LOCATION_NO_DESC',
                                                              description_        => 'To Location No Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'FROM_WAREHOUSE',
                                                              description_        => 'From Warehouse',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'FROM_BAY_ID',
                                                              description_        => 'From Bay',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'FROM_ROW_ID',
                                                              description_        => 'From Row',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'FROM_TIER_ID',
                                                              description_        => 'From Tier',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'FROM_BIN_ID',
                                                              description_        => 'From Bin',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'FROM_LOCATION_GROUP',
                                                              description_        => 'From Location Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'FROM_LOCATION_NO_DESC',
                                                              description_        => 'From Location No Description',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Handling unit related feedback items --------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'HANDLING_UNIT_LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'HANDLING_UNIT_COMPOSITION_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_         => 'Operative Gross Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_        => 'Operative Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_STRUCTURE_LEVEL',
                                                              description_        => 'Structure Level',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_LENGTH',
                                                              description_        => 'Uom For Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_WEIGHT',
                                                              description_        => 'Uom For Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_VOLUME',
                                                              description_        => 'UoM For Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit Type related feedback items ---------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Handling Unit Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   ------------------------------------------------------------------------------------------------------------------
   -- Inventory Part In Stock related feedback items ----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ACTIVITY_SEQ',
                                                              description_        => 'Activity Sequence',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS',
                                                              description_        => 'Catch UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'CONDITION_CODE',
                                                              description_        => 'Condition Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'CONDITION_CODE_DESCRIPTION',
                                                              description_        => 'Condition Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'CONFIGURATION_ID',
                                                              description_        => 'Configuration ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ENG_CHG_LEVEL',
                                                              description_        => 'Revision No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'LOT_BATCH_NO',
                                                              description_        => 'Lot/Batch No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'OWNERSHIP',
                                                              description_         => 'Part Ownership',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_OWNERSHIP_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'OWNER',
                                                              description_        => 'Owner',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'OWNER_NAME',
                                                              description_        => 'Owner Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'PART_NO',
                                                              description_        => 'Part No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'SERIAL_NO',
                                                              description_        => 'Serial No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'UNIT_MEAS',
                                                              description_        => 'UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'WAIV_DEV_REJ_NO',
                                                              description_        => 'W/D/R No',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Transport Task Line related feedback items --------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'QUANTITY',
                                                              description_        => 'Quantity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'CATCH_QUANTITY',
                                                              description_        => 'Catch Quantity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_    => 'ORDER_TYPE',
                                                              description_         => 'Order Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'ORDER_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ORDER_REF1',
                                                              description_        => 'Order Ref1',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ORDER_REF2',
                                                              description_        => 'Order Ref2',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ORDER_REF3',
                                                              description_        => 'Order Ref3',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ORDER_REF4',
                                                              description_        => 'Order Ref4',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'CREATE_DATE',
                                                              description_        => 'Create Date',
                                                              data_type_          => 'DATETIME');

   ------------------------------------------------------------------------------------------------------------------
   -- Project (Activity Seq) related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'PROJECT_ID',
                                                              description_        => 'Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'PROJECT_NAME',
                                                              description_        => 'Project Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'SUB_PROJECT_ID',
                                                              description_        => 'Sub Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'SUB_PROJECT_DESCRIPTION',
                                                              description_        => 'Sub Project Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ACTIVITY_ID',
                                                              description_        => 'Activity ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'ACTIVITY_DESCRIPTION',
                                                              description_        => 'Activity Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'PROGRAM_ID',
                                                              description_        => 'Program ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_   => 'PROGRAM_DESCRIPTION',
                                                              description_        => 'Program Description',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Various related feedback items --------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'PROCESS_TRANSPORT_TASK_HU',
                                                              feedback_item_id_         => 'LAST_LINE_ON_TRANSPORT_TASK',
                                                              description_              => 'Last Line on Transport Task',
                                                              data_type_                => 'STRING',
                                                              enumeration_package_      => 'GEN_YES_NO_API',
                                                              feedback_item_value_view_ => 'GEN_YES_NO',
                                                              feedback_item_value_pkg_  => 'GEN_YES_NO_API');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_5');
PROMPT Inserting TRANSPORT_TASK_HANDLING_UNIT base configuration to DATA_CAPTURE_PROCES_DETAIL and DATA_CAPTURE_CONFIG_DETAIL
-- Add New Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_TRANSPORT_TASK_HU',
                                                           capture_process_detail_id_ => 'DISPLAY_HANDLING_UNIT_ID',
                                                           description_               => 'Display Handling Unit ID in the List of Values for Aggregated Line ID description field',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_TRANSPORT_TASK_HU',
                                                           capture_process_detail_id_ => 'DISPLAY_SSCC',
                                                           description_               => 'Display SSCC in the List of Values for Aggregated Line ID description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_TRANSPORT_TASK_HU',
                                                           capture_process_detail_id_ => 'DISPLAY_ALT_HANDLING_UNIT_LABEL_ID',
                                                           description_               => 'Display Alt Handling Unit Label ID in the List of Values for Aggregated Line ID description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_TRANSPORT_TASK_HU',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_6');
PROMPT ADD CONFIG CTRL ITEM TO PROCESS_TRANSPORT_TASK process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_           => 'PROCESS_TRANSPORT_TASK_HU',
                                                         config_ctrl_feedback_item_id_ => 'LAST_LINE_ON_TRANSPORT_TASK');
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_7');
PROMPT Connecting feedback items to base (config_id =1) TRANSPORT_TASK_HANDLING_UNIT process
-- Connect feedback items to data items
BEGIN

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                            data_item_id_        => 'FROM_CONTRACT',
                                                            data_item_detail_id_ => 'FROM_LOCATION_NO_DESC',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                            data_item_id_        => 'FROM_CONTRACT',
                                                            data_item_detail_id_ => 'HANDLING_UNIT_ID',
                                                            item_type_db_        => 'DATA');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                            data_item_id_        => 'TO_CONTRACT',
                                                            data_item_detail_id_ => 'TO_LOCATION_NO_DESC',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_HU',
                                                            data_item_id_        => 'TO_LOCATION_NO',
                                                            data_item_detail_id_ => 'LAST_LINE_ON_TRANSPORT_TASK',
                                                            item_type_db_        => 'FEEDBACK');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Timestamp_8');
PROMPT Inserting START_WAREHOUSE_TASK to SUBSEQ_DATA_CAPTURE_CONFIG_TAB
BEGIN

   -- Add START_WAREHOUSE_TASK as subsequent configuration item for process PROCESS_TRANSPORT_TASK_HU (LAST_LINE_ON_TRANSPORT_TASK feedback item is
   -- the Subsequent Control Feedback Item in this case on PROCESS_TRANSPORT_TASK_HU).
   -- We can install this here because START_WAREHOUSE_TASK is already installed. While 'N' value is installed in script for START_TRANSPORT_TASK since START_TRANSPORT_TASK is not installed here yet.
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_HU',
                                                      control_item_value_            => 'Y',
                                                      subsequent_capture_process_id_ => 'START_WAREHOUSE_TASK');

END;
/


COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskHu.sql','Done');
PROMPT Finished with POST_Invent_DataCaptTranspTaskHu.sql

