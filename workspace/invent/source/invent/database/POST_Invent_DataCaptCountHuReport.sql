
------------------------------------------------------------------------------
--
--  Filename      : POST_Invent_DataCaptCountHuReport.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process COUNT_HANDL_UNIT_COUNT_REPORT.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171017  DaZase  STRSC-13003, Added GS1_BARCODE1, GS1_BARCODE2 as a new data items.
--  170731  SWiclk  STRSC-9013, Enabled camera functionality.
--  161214  DaZase  Added feedback items.
--  161122  DaZase  Created for LIM-5062.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCountHuReport.sql','Timestamp_1');
PROMPT Starting POST_INVENT_DataCaptureCountPerCountReport.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCountHuReport.sql','Timestamp_2');
PROMPT Inserting COUNT_HANDL_UNIT_COUNT_REPORT process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_        => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                               description_               => 'Count Handling Unit per Count Report',
                                                               process_package_           => 'DATA_CAPT_COUNT_HU_REPORT_API',
                                                               process_component_         => 'INVENT',
                                                               config_menu_label_         => 'Count Handling Unit Count Report',
                                                               process_camera_enabled_db_ => Fnd_Boolean_API.DB_TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCountHuReport.sql','Timestamp_3');
PROMPT Inserting COUNT_HANDL_UNIT_COUNT_REPORT process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              data_item_id_                  => 'INV_LIST_NO',
                                                              description_                   => 'Count Report No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_subseq_data_item_id_    => 'INV_LIST_NO',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              data_item_id_                  => 'ACTION',
                                                              description_                   => 'Action',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'COUNT_HANDL_UNIT_ACTION_API',
                                                              config_default_value_          => 'EXIST',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              data_item_id_                  => 'CONFIRM',
                                                              description_                   => 'Confirm',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              config_fixed_value_            => 'Y',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
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


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCountHuReport.sql','Timestamp_4');
PROMPT Inserting COUNT_HANDL_UNIT_COUNT_REPORT process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit Location related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit related feedback items --------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'HANDLING_UNIT_COMPOSITION_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_STRUCTURE_LEVEL',
                                                              description_        => 'Structure Level',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit Type related feedback items ---------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Inventory Part In Stock related feedback items ----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'ACTIVITY_SEQ',
                                                              description_        => 'Activity Sequence',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'AVAILABILITY_CONTROL_ID',
                                                              description_        => 'Availability Control ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'AVAILABILITY_CONTROL_DESCRIPTION',
                                                              description_        => 'Availability Control Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'CONDITION_CODE',
                                                              description_        => 'Condition Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'CONDITION_CODE_DESCRIPTION',
                                                              description_        => 'Condition Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'CONFIGURATION_ID',
                                                              description_        => 'Configuration ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'ENG_CHG_LEVEL',
                                                              description_        => 'Revision No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'LOT_BATCH_NO',
                                                              description_        => 'Lot/Batch No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_    => 'OWNERSHIP',
                                                              description_         => 'Part Ownership',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_OWNERSHIP_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'OWNER',
                                                              description_        => 'Owner',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'OWNER_NAME',
                                                              description_        => 'Owner Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'PART_NO',
                                                              description_        => 'Part No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');


   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'SERIAL_NO',
                                                              description_        => 'Serial No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'WAIV_DEV_REJ_NO',
                                                              description_        => 'W/D/R No',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Project (Activity Seq) related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'PROJECT_ID',
                                                              description_        => 'Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'PROJECT_NAME',
                                                              description_        => 'Project Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'SUB_PROJECT_ID',
                                                              description_        => 'Sub Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'SUB_PROJECT_DESCRIPTION',
                                                              description_        => 'Sub Project Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'ACTIVITY_ID',
                                                              description_        => 'Activity ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                              feedback_item_id_   => 'ACTIVITY_DESCRIPTION',
                                                              description_        => 'Activity Description',
                                                              data_type_          => 'STRING');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCountHuReport.sql','Timestamp_5');
PROMPT Inserting COUNT_HANDL_UNIT_COUNT_REPORT base configuration to DATA_CAPTURE_PROCES_DETAIL and DATA_CAPTURE_CONFIG_DETAIL
-- Add New Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                           capture_process_detail_id_ => 'DISPLAY_HANDLING_UNIT_ID',
                                                           description_               => 'Display Handling Unit ID in the List of Values for Aggregated Line ID description field',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                           capture_process_detail_id_ => 'DISPLAY_SSCC',
                                                           description_               => 'Display SSCC in the List of Values for Aggregated Line ID description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                           capture_process_detail_id_ => 'DISPLAY_ALT_HANDLING_UNIT_LABEL_ID',
                                                           description_               => 'Display Alt Handling Unit Label ID in the List of Values for Aggregated Line ID description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCountHuReport.sql','Timestamp_6');
PROMPT Connecting feedback items to base (config_id =1) COUNT_HANDL_UNIT_COUNT_REPORT process
-- Connect feedback items to data items
BEGIN
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                            data_item_id_        => 'AGGREGATED_LINE_ID',
                                                            data_item_detail_id_ => 'HANDLING_UNIT_LOCATION_NO_DESC',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                            data_item_id_        => 'AGGREGATED_LINE_ID',
                                                            data_item_detail_id_ => 'HANDLING_UNIT_TYPE_ID',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                            data_item_id_        => 'AGGREGATED_LINE_ID',
                                                            data_item_detail_id_ => 'HANDLING_UNIT_ID',
                                                            item_type_db_        => 'DATA');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');

END;
/



COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCountHuReport.sql','Done');
PROMPT Finished with POST_Invent_DataCaptCountHuReport.SQL

