------------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_DataCaptParkWhseTask.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process PARK_WAREHOUSE_TASK.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  150721  RuLiLk  Bug 121975, Data type is sent when installing feedback items.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150128  JeLise  PRSC-5576, Added process_list_of_val_supported_ to WORKER_ID and TASK_ID.
--  150114  DaZase  PRSC-5056, Replaced Install_Process_And_Config-call with Install_Process_And_All_Config and replaced all
--  150114          Install_Proc_Config_Data_Item-calls with Install_Data_Item_All_Configs.
--  141014  JeLise  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptParkWhseTask.sql','Timestamp_1');
PROMPT Starting POST_INVENT_DataCaptParkWhseTask.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptParkWhseTask.sql','Timestamp_2');
PROMPT Inserting PARK_WAREHOUSE_TASK process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_               => 'PARK_WAREHOUSE_TASK',
                                                               description_                      => 'Park Warehouse Task',
                                                               process_package_                  => 'DATA_CAPT_PARK_WHSE_TASK_API',
                                                               process_component_                => 'INVENT',
                                                               config_proc_compl_action_db_      => 'RETURN_TO_MENU',
                                                               config_menu_label_                => 'Park Warehouse Task');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptParkWhseTask.sql','Timestamp_3');
PROMPT Inserting PARK_WAREHOUSE_TASK process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PARK_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'WORKER_ID',
                                                              description_                   => 'Worker ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 20,
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PARK_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'TASK_ID',
                                                              description_                   => 'Task ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PARK_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'PARK_REASON_ID',
                                                              description_                   => 'Park Reason',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 10,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptParkWhseTask.sql','Timestamp_4');
PROMPT Inserting PARK_WAREHOUSE_TASK process to DATA_CAPT_PROC_FEEDBA_ITEM_TAB
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_    => 'TASK_TYPE',
                                                              description_         => 'Task Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'WAREHOUSE_TASK_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'PRIORITY',
                                                              description_        => 'Default Priority',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'ASSIGNED_PRIORITY',
                                                              description_        => 'Operative Priority',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'NUMBER_OF_LINES',
                                                              description_        => 'Number of Lines',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'REQUESTED_DATE_FINISHED',
                                                              description_        => 'Requested Finish Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'ACTUAL_DATE_STARTED',
                                                              description_        => 'Actual Start Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'INFO',
                                                              description_        => 'Source Info',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'SOURCE_REF1',
                                                              description_        => 'Source Ref1',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'TOTAL_PLANNED_TIME_NEEDED',
                                                              description_        => 'Total Planned Time Needed',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'LATEST_START_DATE',
                                                              description_        => 'Latest Start Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PARK_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'EXPECTED_FINISH_DATE',
                                                              description_        => 'Expected Finish Date',
                                                              data_type_          => 'DATE');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptParkWhseTask.sql','Timestamp_5');
PROMPT Connecting feedback items to base (config_id = 1) process
-- Connect feedback items to data items
BEGIN
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_    => 'PARK_WAREHOUSE_TASK',
                                                              data_item_id_        => 'PARK_REASON_ID',
                                                              data_item_detail_id_ => 'INFO',
                                                              item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_    => 'PARK_WAREHOUSE_TASK',
                                                              data_item_id_        => 'PARK_REASON_ID',
                                                              data_item_detail_id_ => 'REQUESTED_DATE_FINISHED',
                                                              item_type_db_        => 'FEEDBACK');
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptParkWhseTask.sql','Done');
PROMPT Finished with POST_INVENT_DataCaptParkWhseTask.sql
