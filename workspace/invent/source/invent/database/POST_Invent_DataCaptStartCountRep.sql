------------------------------------------------------------------------------
--
--  Filename      : POST_Invent_DataCaptStartCountRep.sql
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
--  ------  ------  ----------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171102  DaZase  STRSC-13073, Added GS1_BARCODE1, GS1_BARCODE2 as new data items.
--  161214  DaZase  Added feedback items.
--  161128  DaZase  Created for LIM-9572.
------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_1');
PROMPT Starting POST_Invent_DataCaptStartCountRep.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_2');
PROMPT Inserting START_COUNT_REPORT process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_          => 'START_COUNT_REPORT',
                                                               description_                 => 'Start Count Report',
                                                               process_package_             => 'DATA_CAPT_START_COUNT_REP_API',
                                                               process_component_           => 'INVENT',
                                                               config_menu_label_           => 'Start Count Report',
                                                               config_confirm_execution_db_ => 'FALSE');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_3');
PROMPT Inserting START_COUNT_REPORT process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_COUNT_REPORT',
                                                              data_item_id_                  => 'INV_LIST_NO',
                                                              description_                   => 'Count Report No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_COUNT_REPORT',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_COUNT_REPORT',
                                                              data_item_id_                  => 'COUNT_REPORT_LEVEL',
                                                              description_                   => 'Count Report Level',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_COUNT_REPORT',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_COUNT_REPORT',
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


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_4');
PROMPT Inserting START_COUNT_REPORT process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   ------------------------------------------------------------------------------------------------------------------
   -- Location related feedback items -------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_COUNT_REPORT',
                                                              feedback_item_id_   => 'LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'START_COUNT_REPORT',
                                                              feedback_item_id_    => 'LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_COUNT_REPORT',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_COUNT_REPORT',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_COUNT_REPORT',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_COUNT_REPORT',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_COUNT_REPORT',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_5');
PROMPT ADD CONFIG CTRL ITEM TO START_COUNT_REPORT process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_       => 'START_COUNT_REPORT',
                                                         config_ctrl_data_item_id_ => 'COUNT_REPORT_LEVEL');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_6');
PROMPT Inserting START_COUNT_REPORT to SUBSEQ_DATA_CAPTURE_CONFIG_TAB
BEGIN
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_COUNT_REPORT',
                                                      control_item_value_            => 'PART',
                                                      subsequent_capture_process_id_ => 'COUNT_PART_COUNT_REPORT');

   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_COUNT_REPORT',
                                                      control_item_value_            => 'HANDLING_UNIT',
                                                      subsequent_capture_process_id_ => 'COUNT_HANDL_UNIT_COUNT_REPORT');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_7');
PROMPT Inserting INV_LIST_NO to SUBSEQ_CONFIG_DATA_ITEM_TAB FOR both sub processes
BEGIN
   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_COUNT_REPORT',
                                                              control_item_value_      => 'PART',
                                                              data_item_id_            => 'INV_LIST_NO',
                                                              subsequent_data_item_id_ => 'INV_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');


   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_COUNT_REPORT',
                                                              control_item_value_      => 'HANDLING_UNIT',
                                                              data_item_id_            => 'INV_LIST_NO',
                                                              subsequent_data_item_id_ => 'INV_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');

   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_COUNT_REPORT',
                                                              control_item_value_      => 'HANDLING_UNIT',
                                                              data_item_id_            => 'LOCATION_NO',
                                                              subsequent_data_item_id_ => 'LOCATION_NO',
                                                              use_subsequent_value_db_ => 'FIXED');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_8');
PROMPT Inserting this process as default subsequent process for both sub processes
BEGIN

   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'COUNT_PART_COUNT_REPORT',
                                                               subsequent_capture_process_id_ => 'START_COUNT_REPORT');


   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'COUNT_HANDL_UNIT_COUNT_REPORT',
                                                               subsequent_capture_process_id_ => 'START_COUNT_REPORT');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Timestamp_9');
PROMPT Inserting REASSIGN_HANDLING_UNIT_SHIP process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'START_COUNT_REPORT',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

END;
/


COMMIT;
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptStartCountRep.sql','Done');
PROMPT Finished with POST_Invent_DataCaptStartCountRep.sql

