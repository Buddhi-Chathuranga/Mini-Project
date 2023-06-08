-------------------------------------------------------------------------------
--  Module : INVENT
--
--  Purpose: Inserting data into DataCaptureProcess and
--           DataCaptureConfig tables for process PROCESS_TRANSPORT_TASK_PART.
--
--  File   : POST_Invent_DataCaptTranspTaskPart.sql
--
--  IFS/Design Template Version 2.3
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  210705  MoiNlk  Bug 159673 (SCZ-14915), Added new data item ORDER_TYPE.
--  181019  BudKlk  Bug 143097, Added new feedback items CONDITION_CODE and CONDITION_CODE_DESCRIPTION.
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  170919  SURBLK  STRSC-12207, Data item INPUT_QUANTITY changed Use Automatic Value as Off.
--  170915  DaZase  STRSC-11606, Added GS1_BARCODE1, GS1_BARCODE2 and GS1_BARCODE3 as a new data items.
--  170714  SURBLK  STRSC-9614, Added GTIN_NO, INPUT_UOM and INPUT_QUANTITY data items and INPUT_CONV_FACTOR as feedback item and 
--  170714          GTIN_NO_IS_MANDATORY as detail item.
--  170328  DaZase  LIM-11233, Renamed file from POST_INVENT_DataCaptProcTransTask.sql to POST_Invent_DataCaptTranspTaskPart.sql.
--  170328          Renamed process from PROCESS_TRANSPORT_TASK to PROCESS_TRANSPORT_TASK_PART.
--  161117  SWiclk  LIM-9745, Added process_default_fixed_value_ 1 for qty.
--  161108  SWiclk  LIM-5313, Supported for Default Qty = 1 for Serial handled parts when applicable.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160219  SWiclk  Bug 127172, Added new process detail BARCODE_ID_IS_MANDATORY.
--  151102  DaZase  LIM-4297, Added new data items HANDLING_UNIT_ID, SSCC and ALT_HANDLING_UNIT_LABEL_ID. Added many new
--  151102          feedback items connected to handling unit.
--  150721  RuLiLk  Bug 121975, Data type is sent when installing feedback items.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150114  DaZase  PRSC-5056, Replaced Install_Process_And_Config-call with Install_Process_And_All_Config and replaced all
--  150114          Install_Proc_Config_Data_Item-calls with Install_Data_Item_All_Configs.
--  141209  DaZase  PRSC-4245, Changed LAST_LINE_ON_TRANSPORT_TASK to become a feedback item.
--  141205  DaZase  PRSC-4409, Added LAST_LINE_ON_TRANSPORT_TASK as control item, added calls to Install_Subseq_Config/Install_Subseq_Conf_Data_Item.
--  141022  JeLise  Added LAST_LINE_ON_TRANSPORT_TASK as new data item to work with Warehouse Task.
--  141008  DaZase  PRSC-63, Added config_list_of_values_db_ => 'ON' and process_list_of_val_supported_ => 'TRUE' to BARCODE_ID.
--  141008  RiLase  PRSC-56, Renamed from POST_INVENT_DataCaptureTransportTaskLine to POST_INVENT_DataCaptProcTransTask.
--  141001  RiLase  PRSC-2782, Added process component attribute.
--  140916  DaZase  PRSC-2781, Added enumeration_package to following data items: TRANSPORT_TASK_STATUS, ACTION, DESTINATION.
--  140916  DaZase  PRSC-2781, Added enumeration_package to following feedback items: FROM_LOCATION_TYPE, TO_LOCATION_TYPE,
--  140916          PART_TYPE, SERIAL_TRACKING_RECEIPT_ISSUE, SERIAL_TRACKING_DELIVERY, SERIAL_TRACKING_INVENTORY,
--  140916          STOP_ARRIVAL_ISSUED_SERIAL, STOP_NEW_SERIAL_IN_RMA, SERIAL_RULE, LOT_BATCH_TRACKING,
--  140916          LOT_QUANTITY_RULE, SUB_LOT_RULE, COMPONENT_LOT_RULE, GTIN_IDENTIFICATION, TO_RECEIPTS_BLOCKED,
--  140916          TO_MIX_OF_PART_NUMBER_BLOCKED, TO_MIX_OF_CONDITION_CODES_BLOCKED, TO_MIX_OF_LOT_BATCH_NO_BLOCKED,
--  140916          FROM_RECEIPTS_BLOCKED, FROM_MIX_OF_PART_NUMBER_BLOCKED, FROM_MIX_OF_CONDITION_CODES_BLOCKED,
--  140916          FROM_MIX_OF_LOT_BATCH_NO_BLOCKED.
--  140905  JeLise  PRSC-2366, Added WAREHOUSE_TASK_ID as a new data item to work with Warehouse Task.
--  140814  DaZase  PRSC-1611, Changed description of ENG_CHG_LEVEL from EC to Revision No.
--  140805  DaZase  PRSC-1431, Added string_length_ to all STRING calls to Install_Proc_Config_Data_Item.
--  140805          Changed data_type_ to data_type_db_ on all calls to Install_Proc_Config_Data_Item.
--  130114  RiLase  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_1');
PROMPT Starting POST_Invent_DataCaptTranspTaskPart.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_2');
PROMPT Inserting PROCESS_TRANSPORT_TASK_PART process to DataCaptureProcess and DataCaptureConfig
-- Add New Process and Configuration
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                               description_        => 'Process Part on Transport Task',
                                                               process_package_    => 'DATA_CAPT_TRANSP_TASK_PART_API',
                                                               process_component_  => 'INVENT',
                                                               config_menu_label_  => 'Process Part on Transport Task');
END;
/
--
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_3');
PROMPT Inserting PROCESS_TRANSPORT_TASK_PART process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'TRANSPORT_TASK_ID',
                                                              description_                   => 'Transport Task ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              config_subseq_data_item_id_    => 'TRANSPORT_TASK_ID',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'LINE_NO',
                                                              description_                   => 'Line No',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'FROM_CONTRACT',
                                                              description_                   => 'From Site',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 5,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'PART_NO',
                                                              description_                   => 'Part No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 25,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'LOT_BATCH_NO',
                                                              description_                   => 'Lot/Batch No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 20,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_fixed_value_            => '*',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'SERIAL_NO',
                                                              description_                   => 'Serial No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 50,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_fixed_value_            => '*',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'WAIV_DEV_REJ_NO',
                                                              description_                   => 'W/D/R No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 15,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'ENG_CHG_LEVEL',
                                                              description_                   => 'Revision No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 6,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'CONFIGURATION_ID',
                                                              description_                   => 'Configuration ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 50,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_fixed_value_            => '*',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'ACTIVITY_SEQ',
                                                              description_                   => 'Activity Sequence',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
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
   
   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'INPUT_UOM',
                                                              description_                   => 'Input Unit of Measure',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 30,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'INPUT_QUANTITY',
                                                              description_                   => 'Input Quantity',
                                                              data_type_db_                  => 'NUMBER',                                                              
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',                                                              
                                                              config_data_item_order_        => config_data_item_order_);
   --- GTIN related ---

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'QUANTITY',
                                                              description_                   => 'Quantity',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
															                 config_fixed_value_            => '1',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
															                 process_default_fixed_value_   => '1',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'CATCH_QUANTITY',
                                                              description_                   => 'Catch Qty',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'ACTION',
                                                              description_                   => 'Action',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_list_of_values_db_      => 'ON',
                                                              enumeration_package_           => 'TRANSPORT_TASK_ACTION_API',
                                                              config_default_value_          => 'EXECUTE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
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
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'TO_CONTRACT',
                                                              description_                   => 'To Site',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 5,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'TO_LOCATION_NO',
                                                              description_                   => 'To Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 35,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'ORDER_TYPE',
                                                              description_                   => 'Order Type',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              string_length_                 => 200,
                                                              config_list_of_values_db_      => 'ON',
                                                              enumeration_package_           => 'ORDER_TYPE_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'BARCODE_ID',
                                                              description_                   => 'Barcode ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                              data_item_id_                  => 'GS1_BARCODE3',
                                                              description_                   => 'GS1 Barcode 3',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);


END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_4');
PROMPT Inserting PROCESS_TRANSPORT_TASK_PART process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'CREATE_DATE',
                                                              description_        => 'Date Created',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'FROM_LOCATION_GROUP',
                                                              description_        => 'From Location Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'FROM_LOCATION_TYPE',
                                                              description_         => 'From Location Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'FROM_WAREHOUSE',
                                                              description_        => 'From Warehouse',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'FROM_BAY_ID',
                                                              description_        => 'From Bay',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'FROM_ROW_ID',
                                                              description_        => 'From Row',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'FROM_TIER_ID',
                                                              description_        => 'From Tier',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'FROM_BIN_ID',
                                                              description_        => 'From Bin',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TO_LOCATION_GROUP',
                                                              description_        => 'To Location Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TO_LOCATION_TYPE',
                                                              description_         => 'To Location Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TO_WAREHOUSE',
                                                              description_        => 'To Warehouse',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TO_BAY_ID',
                                                              description_        => 'To Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TO_ROW_ID',
                                                              description_        => 'To Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TO_TIER_ID',
                                                              description_        => 'To Tier',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TO_BIN_ID',
                                                              description_        => 'To Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PART_NO_DESCRIPTION',
                                                              description_        => 'Part No Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'FROM_LOCATION_NO_DESC',
                                                              description_        => 'From Location No Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TO_LOCATION_NO_DESC',
                                                              description_        => 'To Location No Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'UNIT_MEAS',
                                                              description_        => 'UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'UNIT_MEAS_DESCRIPTION',
                                                              description_        => 'UoM Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS',
                                                              description_        => 'Catch UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS_DESCRIPTION',
                                                              description_        => 'Catch UoM Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'QUANTITY_ONHAND',
                                                              description_        => 'Qty Onhand',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'CATCH_QUANTITY_ONHAND',
                                                              description_        => 'Catch Qty Onhand',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'PART_TYPE',
                                                              description_         => 'Part Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'INVENTORY_PART_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PRIME_COMMODITY',
                                                              description_        => 'Comm Group 1',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PRIME_COMMODITY_DESCRIPTION',
                                                              description_        => 'Comm Group 1 Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'SECOND_COMMODITY',
                                                              description_        => 'Comm Group 2',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'SECOND_COMMODITY_DESCRIPTION',
                                                              description_        => 'Comm Group 2 Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'ASSET_CLASS',
                                                              description_        => 'Asset Class',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'ASSET_CLASS_DESCRIPTION',
                                                              description_        => 'Asset Class Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PART_STATUS',
                                                              description_        => 'Part Status',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PART_STATUS_DESCRIPTION',
                                                              description_        => 'Part Status Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'ABC_CLASS',
                                                              description_        => 'ABC Class',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'ABC_CLASS_PERCENT',
                                                              description_        => 'ABC Class Percent',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'SAFETY_CODE',
                                                              description_        => 'Safety Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'SAFETY_CODE_DESCRIPTION',
                                                              description_        => 'Safety Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'ACCOUNTING_GROUP',
                                                              description_        => 'Accounting Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'ACCOUNTING_GROUP_DESCRIPTION',
                                                              description_        => 'Accounting Group Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PRODUCT_CODE',
                                                              description_        => 'Product Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PRODUCT_CODE_DESCRIPTION',
                                                              description_        => 'Product Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PRODUCT_FAMILY',
                                                              description_        => 'Product Family',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PRODUCT_FAMILY_DESCRIPTION',
                                                              description_        => 'Product Family Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                                              description_         => 'Serial Tracking at Receipt and Issue',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_DELIVERY',
                                                              description_         => 'Serial Tracking After Delivery',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_INVENTORY',
                                                              description_         => 'Serial Tracking in Inventory',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'STOP_ARRIVAL_ISSUED_SERIAL',
                                                              description_         => 'Stop PO Arrivals of Issued Serials',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'STOP_NEW_SERIAL_IN_RMA',
                                                              description_         => 'Stop Creation of New Serials in RMA',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'SERIAL_RULE',
                                                              description_         => 'Serial Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'LOT_BATCH_TRACKING',
                                                              description_         => 'Lot/Batch Tracking',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_LOT_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'LOT_QUANTITY_RULE',
                                                              description_         => 'Lot Quantity Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'LOT_QUANTITY_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'SUB_LOT_RULE',
                                                              description_         => 'Sub Lot Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'SUB_LOT_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'COMPONENT_LOT_RULE',
                                                              description_         => 'Component Lot Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'COMPONENT_LOT_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'GTIN_DEFAULT',
                                                              description_        => 'Default GTIN',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TO_RECEIPTS_BLOCKED',
                                                              description_         => 'To Receipts Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TO_MIX_OF_PART_NUMBER_BLOCKED',
                                                              description_         => 'To Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TO_MIX_OF_CONDITION_CODES_BLOCKED',
                                                              description_         => 'To Mix of Condition Codes Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TO_MIX_OF_LOT_BATCH_NO_BLOCKED',
                                                              description_         => 'To Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'FROM_RECEIPTS_BLOCKED',
                                                              description_         => 'From Receipts Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'FROM_MIX_OF_PART_NUMBER_BLOCKED',
                                                              description_         => 'From Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'FROM_MIX_OF_CONDITION_CODES_BLOCKED',
                                                              description_         => 'From Mix of Condition Codes Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'FROM_MIX_OF_LOT_BATCH_NO_BLOCKED',
                                                              description_         => 'From Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'GTIN_IDENTIFICATION',
                                                              description_         => 'GTIN Used for Identification',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_         => 'LAST_LINE_ON_TRANSPORT_TASK',
                                                              description_              => 'Last Line on Transport Task',
                                                              data_type_                => 'STRING',
                                                              enumeration_package_      => 'GEN_YES_NO_API',
                                                              feedback_item_value_view_ => 'GEN_YES_NO',
                                                              feedback_item_value_pkg_  => 'GEN_YES_NO_API');
   
   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'INPUT_CONV_FACTOR',
                                                              description_        => 'Input Conversion Factor',
                                                              data_type_          => 'NUMBER');
   --- GTIN related ---
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_TRANSPORT_TASK_PART',           
                                                              feedback_item_id_     => 'CONDITION_CODE',
                                                              description_          => 'Condition Code',
                                                              data_type_            => 'STRING'); 
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_TRANSPORT_TASK_PART',           
                                                              feedback_item_id_     => 'CONDITION_CODE_DESCRIPTION',
                                                              description_          => 'Condition Code Description',
                                                              data_type_            => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Handling unit related feedback items --------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Handling Unit Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Handling Unit Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_SHIPMENT_ID',
                                                              description_        => 'Shipment ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_ACCESSORY_EXIST',
                                                              description_         => 'Accessory Exist',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'HANDLING_UNIT_COMPOSITION_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_LENGTH',
                                                              description_        => 'Uom For Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_NET_WEIGHT',
                                                              description_        => 'Net Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_        => 'Manual Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_        => 'Operative Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_WEIGHT',
                                                              description_        => 'Uom For Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_        => 'Manual Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_        => 'Operative Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_VOLUME',
                                                              description_        => 'UoM For Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_NO_OF_LBLS',
                                                              description_        => 'No of Handling Unit Labels',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED',
                                                              description_         => 'Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED',
                                                              description_         => 'Mix of Condition Code Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED',
                                                              description_         => 'Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PROCESS_TRANSPORT_TASK_PART',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');


END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_5');
PROMPT ADD CONFIG CTRL ITEM TO PROCESS_TRANSPORT_TASK_PART process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_           => 'PROCESS_TRANSPORT_TASK_PART',
                                                         config_ctrl_feedback_item_id_ => 'LAST_LINE_ON_TRANSPORT_TASK');
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_6');
PROMPT Connecting feedback items to base (config_id =1) PROCESS_TRANSPORT_TASK_PART process
-- Connect feedback items to data items
BEGIN
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                            data_item_id_        => 'FROM_CONTRACT',
                                                            data_item_detail_id_ => 'FROM_LOCATION_NO_DESC',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                            data_item_id_        => 'FROM_LOCATION_NO',
                                                            data_item_detail_id_ => 'PART_NO_DESCRIPTION',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                            data_item_id_        => 'TO_CONTRACT',
                                                            data_item_detail_id_ => 'TO_LOCATION_NO_DESC',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PROCESS_TRANSPORT_TASK_PART',
                                                            data_item_id_        => 'BARCODE_ID',
                                                            data_item_detail_id_ => 'LAST_LINE_ON_TRANSPORT_TASK',
                                                            item_type_db_        => 'FEEDBACK');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_7');
PROMPT Inserting PROCESS_TRANSPORT_TASK_PART process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_TRANSPORT_TASK_PART',
                                                           capture_process_detail_id_ => 'GTIN_IS_MANDATORY',
                                                           description_               => 'GTIN is mandatory',
                                                           enabled_db_                => 'FALSE'); 

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_TRANSPORT_TASK_PART',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Timestamp_8');
PROMPT Inserting START_WAREHOUSE_TASK to SUBSEQ_DATA_CAPTURE_CONFIG_TAB
BEGIN

   -- Add START_WAREHOUSE_TASK as subsequent configuration item for process PROCESS_TRANSPORT_TASK_PART (LAST_LINE_ON_TRANSPORT_TASK feedback item is
   -- the Subsequent Control Feedback Item in this case on PROCESS_TRANSPORT_TASK_PART).
   -- We can install this here because START_WAREHOUSE_TASK is already installed. While 'N' value is installed in script for START_TRANSPORT_TASK since START_TRANSPORT_TASK is not installed here yet.
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'PROCESS_TRANSPORT_TASK_PART',
                                                      control_item_value_            => 'Y',
                                                      subsequent_capture_process_id_ => 'START_WAREHOUSE_TASK');

END;
/


COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptTranspTaskPart.sql','Done');
PROMPT Finished with POST_Invent_DataCaptTranspTaskPart.sql
