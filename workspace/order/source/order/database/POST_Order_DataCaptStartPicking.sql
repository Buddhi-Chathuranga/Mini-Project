-------------------------------------------------------------------------------
--
--  Filename      : POST_Order_DataCaptStartPicking.sql
--
--  Module        : ORDER
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process START_PICKING .
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171102  DaZase  STRSC-13075, Added GS1_BARCODE1, GS1_BARCODE2 as new data items.
--  170227  KhVese  LIM-5836, Removed Subseq_Conf_Data_Item LOCATION_NO for HANDLING_UNIT.
--  170202  DaZase  Created for LIM-9714.
------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_1');
PROMPT Starting POST_Order_DataCaptStartPicking.SQL

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_2');
PROMPT Inserting START_PICKING process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_          => 'START_PICKING',
                                                               description_                 => 'Start Picking',
                                                               process_package_             => 'DATA_CAPT_START_PICKING_API',
                                                               process_component_           => 'ORDER',
                                                               config_menu_label_           => 'Start Picking',
                                                               config_confirm_execution_db_ => 'FALSE');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_3');
PROMPT Inserting START_PICKING process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICKING',
                                                              data_item_id_                  => 'WAREHOUSE_TASK_ID',
                                                              description_                   => 'Warehouse Task ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              config_subseq_data_item_id_    => 'TASK_ID',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICKING',
                                                              data_item_id_                  => 'PICK_LIST_NO',
                                                              description_                   => 'Pick List No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICKING',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICKING',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICKING',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_PICKING',
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


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_4');
PROMPT Inserting START_PICKING process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   ------------------------------------------------------------------------------------------------------------------
   -- Location related feedback items -------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICKING',
                                                              feedback_item_id_   => 'LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'START_PICKING',
                                                              feedback_item_id_    => 'LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICKING',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICKING',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICKING',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICKING',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_PICKING',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_5');
PROMPT ADD CONFIG CTRL ITEM TO START_PICKING process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_       => 'START_PICKING',
                                                         config_ctrl_data_item_id_ => 'PICK_LIST_NO_LEVEL');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_6');
PROMPT Inserting START_PICKING to SUBSEQ_DATA_CAPTURE_CONFIG_TAB
BEGIN
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_PICKING',
                                                      control_item_value_            => 'PART',
                                                      subsequent_capture_process_id_ => 'REPORT_PICKING_PART');

   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_PICKING',
                                                      control_item_value_            => 'HANDLING_UNIT',
                                                      subsequent_capture_process_id_ => 'REPORT_PICKING_HU');

   -- Add START_PICKING as subsequent configuration item for process START_WAREHOUSE_TASK (TASK_TYPE data item is the Subsequent Control Data Item in this case on START_WAREHOUSE_TASK)
   -- Installing this for process START_WAREHOUSE_TASK here, since it cannot be installed from START_WAREHOUSE_TASK because START_PICKING is installed after
   -- START_WAREHOUSE_TASK and ORDER is not mandatory for INVENT, so we dont get problems with exists checks.
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'START_WAREHOUSE_TASK',
                                                      control_item_value_            => 'CUSTOMER ORDER PICK LIST',
                                                      subsequent_capture_process_id_ => 'START_PICKING');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_7');
PROMPT Inserting PICK_LIST_NO/WAREHOUSE_TASK_ID/TASK_ID to SUBSEQ_CONFIG_DATA_ITEM_TAB FOR both sub processes
BEGIN
   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICKING',
                                                              control_item_value_      => 'PART',
                                                              data_item_id_            => 'PICK_LIST_NO',
                                                              subsequent_data_item_id_ => 'PICK_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');

   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICKING',
                                                              control_item_value_      => 'PART',
                                                              data_item_id_            => 'WAREHOUSE_TASK_ID',
                                                              subsequent_data_item_id_ => 'WAREHOUSE_TASK_ID',
                                                              use_subsequent_value_db_ => 'FIXED');

   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICKING',
                                                              control_item_value_      => 'HANDLING_UNIT',
                                                              data_item_id_            => 'PICK_LIST_NO',
                                                              subsequent_data_item_id_ => 'PICK_LIST_NO',
                                                              use_subsequent_value_db_ => 'FIXED');

   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_PICKING',
                                                              control_item_value_      => 'HANDLING_UNIT',
                                                              data_item_id_            => 'WAREHOUSE_TASK_ID',
                                                              subsequent_data_item_id_ => 'WAREHOUSE_TASK_ID',
                                                              use_subsequent_value_db_ => 'FIXED');

   -- Add START_WAREHOUSE_TASK data item TASK_ID as subsequent data item WAREHOUSE_TASK_ID for control item value 'CUSTOMER ORDER PICK LIST'
   -- Installing this for process START_WAREHOUSE_TASK here, since the parent record 'CUSTOMER ORDER PICK LIST' is installed here.
   Data_Capture_Common_Util_API.Install_Subseq_Conf_Data_Item(capture_process_id_      => 'START_WAREHOUSE_TASK',
                                                              control_item_value_      => 'CUSTOMER ORDER PICK LIST',
                                                              data_item_id_            => 'TASK_ID',
                                                              subsequent_data_item_id_ => 'WAREHOUSE_TASK_ID',
                                                              use_subsequent_value_db_ => 'FIXED');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_8');
PROMPT Inserting this process as default subsequent process for both sub processes and itself as default for START_PICKING
BEGIN

   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'REPORT_PICKING_PART',
                                                               subsequent_capture_process_id_ => 'START_PICKING');

   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'REPORT_PICKING_HU',
                                                               subsequent_capture_process_id_ => 'START_PICKING');

   Data_Capture_Common_Util_API.Install_Default_Subseq_Process(capture_process_id_            => 'START_PICKING',
                                                               subsequent_capture_process_id_ => 'START_PICKING');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Timestamp_9');
PROMPT Inserting START_PICKING process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'START_PICKING',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

END;
/

COMMIT;
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptStartPicking.sql','Done');
PROMPT Finished with POST_Order_DataCaptStartPicking.sql

