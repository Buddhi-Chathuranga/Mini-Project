-------------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_DataCaptStartWhseTask.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process START_WAREHOUSE_TASK.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------
--  170531  DaZase  STRSC-8774, Moved STATUS to last position, removed Use Fixed Value Always on it. Removed STATUS as detail on TASK_ID.
--  151126  JeLise  LIM-4077, Changed the name in data_item_value_view_ for data item TASK_TYPE.
--  150721  RuLiLk  Bug 121975, Data type is sent when installing feedback items.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150127  JeLise  PRSC-5487, Added insert of process details.
--  150123  JeLise  PRSC-5484, Added process_list_of_val_supported_ to WORKER_ID.
--  150114  DaZase  PRSC-5056, Replaced Install_Process_And_Config-call with Install_Process_And_All_Config and replaced all
--  150114          Install_Proc_Config_Data_Item-calls with Install_Data_Item_All_Configs.
--  141212  RILASE  PRSC-4649, Connected feedback items to TASK_ID.
--  141205  DaZase  PRSC-4409, Added TASK_TYPE as config control data item.
--  141022  MeAblk  Added data_item_value_view_ and data_item_value_pkg_ as data capt proc items.
--  141015  JeLise  Added PARK_REASON_ID and PARK_REASON_DESCRIPTION as feedback items.
--  141001  RiLase  PRSC-2782, Added process component.
--  140916  DaZase  Added enumeration_package_ => 'WAREHOUSE_TASK_TYPE_API' for TASK_TYPE data item.
--  140902  JeLise  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_1');
PROMPT Starting POST_INVENT_DataCaptStartWhseTask.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_2');
PROMPT Inserting START_WAREHOUSE_TASK process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_       => 'START_WAREHOUSE_TASK',
                                                               description_              => 'Start Warehouse Task',
                                                               process_package_          => 'DATA_CAPT_START_WHSE_TASK_API',
                                                               process_component_        => 'INVENT',
                                                               config_menu_label_        => 'Start Warehouse Task');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_3');
PROMPT Inserting START_WAREHOUSE_TASK process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'WORKER_ID',
                                                              description_                   => 'Worker ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 =>  20,
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'TASK_ID',
                                                              description_                   => 'Task ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'FORCED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'TASK_TYPE',
                                                              description_                   => 'Task Type',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              enumeration_package_           => 'WAREHOUSE_TASK_TYPE_API',
                                                              data_item_value_view_          => 'WAREHOUSE_TASK_TYPE',
                                                              data_item_value_pkg_           => 'WAREHOUSE_TASK_TYPE_API',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'LOCATION_GROUP',
                                                              description_                   => 'Location Group',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 5,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'START_WAREHOUSE_TASK',
                                                              data_item_id_                  => 'STATUS',
                                                              description_                   => 'Status',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_4');
PROMPT ADD CONFIG CTRL ITEM TO START_WAREHOUSE_TASK process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_       => 'START_WAREHOUSE_TASK',
                                                         config_ctrl_data_item_id_ => 'TASK_TYPE');
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_5');
PROMPT Inserting START_WAREHOUSE_TASK process to DATA_CAPT_PROC_FEEDBA_ITEM_TAB
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'PRIORITY',
                                                              description_        => 'Default Priority',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'ASSIGNED_PRIORITY',
                                                              description_        => 'Operative Priority',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'NUMBER_OF_LINES',
                                                              description_        => 'Number of Lines',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'REQUESTED_DATE_FINISHED',
                                                              description_        => 'Requested Finish Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'ACTUAL_DATE_STARTED',
                                                              description_        => 'Actual Start Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'INFO',
                                                              description_        => 'Source Info',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'SOURCE_REF1',
                                                              description_        => 'Source Ref1',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'TOTAL_PLANNED_TIME_NEEDED',
                                                              description_        => 'Total Planned Time Needed',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'LATEST_START_DATE',
                                                              description_        => 'Latest Start Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'EXPECTED_FINISH_DATE',
                                                              description_        => 'Expected Finish Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'PARK_REASON_ID',
                                                              description_        => 'Park Reason ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'START_WAREHOUSE_TASK',
                                                              feedback_item_id_   => 'PARK_REASON_DESCRIPTION',
                                                              description_        => 'Park Reason Description',
                                                              data_type_          => 'STRING');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_6');
PROMPT Disconnecting feedback items from connected data items in all configurations
-- Disconnect feedback items from data items 
BEGIN
   -- This connection was added in Apps9 and removed in Apps10
   Data_Capture_Common_Util_API.Disconn_Detail_Data_All_Config(capture_process_id_  => 'START_WAREHOUSE_TASK',
                                                               data_item_id_        => 'TASK_ID',
                                                               data_item_detail_id_ => 'STATUS');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_7');
PROMPT Connecting feedback items to base (config_id = 1) process
-- Connect feedback items to data items
BEGIN

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'START_WAREHOUSE_TASK',
                                                            data_item_id_        => 'TASK_ID',
                                                            data_item_detail_id_ => 'PARK_REASON_ID',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'START_WAREHOUSE_TASK',
                                                            data_item_id_        => 'TASK_ID',
                                                            data_item_detail_id_ => 'PARK_REASON_DESCRIPTION',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'START_WAREHOUSE_TASK',
                                                            data_item_id_        => 'TASK_ID',
                                                            data_item_detail_id_ => 'INFO',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'START_WAREHOUSE_TASK',
                                                            data_item_id_        => 'TASK_ID',
                                                            data_item_detail_id_ => 'LATEST_START_DATE',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'START_WAREHOUSE_TASK',
                                                            data_item_id_        => 'TASK_ID',
                                                            data_item_detail_id_ => 'REQUESTED_DATE_FINISHED',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'START_WAREHOUSE_TASK',
                                                            data_item_id_        => 'TASK_ID',
                                                            data_item_detail_id_ => 'TOTAL_PLANNED_TIME_NEEDED',
                                                            item_type_db_        => 'FEEDBACK');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Timestamp_8');
PROMPT Inserting START_WAREHOUSE_TASK base configuration to DATA_CAPTURE_PROCES_DETAIL and DATA_CAPTURE_CONFIG_DETAIL
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'START_WAREHOUSE_TASK',
                                                           capture_process_detail_id_ => 'SORT_ON_OPERATIONAL_PRIORITY',
                                                           description_               => 'Sort Warehouse Task Lov by Operational Priority');
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptStartWhseTask.sql','Done');
PROMPT Finished with POST_INVENT_DataCaptStartWhseTask.sql
