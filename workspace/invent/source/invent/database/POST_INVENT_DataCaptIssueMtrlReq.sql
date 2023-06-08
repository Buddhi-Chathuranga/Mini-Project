-----------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_DataCaptIssueMtrlReq.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process ISSUE_MATERIAL_REQUIS_LINE.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  171023  DaZase  STRSC-13014, Added GS1_BARCODE1, GS1_BARCODE2 and GS1_BARCODE3 as a new data items.
--  170926  CKumlk  STRSC-11277, Added GTIN, INPUT_UOM and INPUT_QUANTITY data items and INPUT_CONV_FACTOR as feedback item and GTIN_NO_IS_MANDATORY as detail item.
--  161117  SWiclk  LIM-9745, Added process_default_fixed_value_ 1 for qty.
--  161108  SWiclk  LIM-5313, Supported for Default Qty = 1 for Serial handled parts when applicable.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160219  SWiclk  Bug 127172, Added new process detail BARCODE_ID_IS_MANDATORY.
--  151104  DaZase  LIM-4281, Added new data items HANDLING_UNIT_ID, SSCC and ALT_HANDLING_UNIT_LABEL_ID. Added many new
--  151104          feedback items connected to handling unit.
--  150721  RuLiLk  Bug 121975, Data type is sent when installing feedback items.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150114  DaZase  PRSC-5056, Replaced Install_Process_And_Config-call with Install_Process_And_All_Config and replaced all
--  150114          Install_Proc_Config_Data_Item-calls with Install_Data_Item_All_Configs and replaced
--  150114          Install_Process_Config_Detail-call with Install_Detail_All_Configs.
--  141126  DaZase  PRSC-2781, Added enumeration_package to following feedback items: SUPPLY_CODE, HEAD_STATUS_CODE,
--  141126          LINE_STATUS_CODE, SERIAL_TRACKING_RECEIPT_ISSUE, SERIAL_TRACKING_DELIVERY, SERIAL_TRACKING_INVENTORY,
--  141126          STOP_ARRIVAL_ISSUED_SERIAL, STOP_NEW_SERIAL_IN_RMA, SERIAL_RULE, LOT_BATCH_TRACKING, LOT_QUANTITY_RULE,
--  141126          SUB_LOT_RULE, COMPONENT_LOT_RULE, GTIN_IDENTIFICATION, RECEIPTS_BLOCKED, MIX_OF_PART_NUMBER_BLOCKED,
--  141126          MIX_OF_CONDITION_CODES_BLOCKED, MIX_OF_LOT_BATCH_NO_BLOCKED, LOCATION_TYPE, OWNERSHIP
--  140108  DaZase  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptIssueMtrlReq.sql','Timestamp_1');
PROMPT Starting POST_INVENT_DataCaptIssueMtrlReq.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptIssueMtrlReq.sql','Timestamp_2');
PROMPT Inserting ISSUE_MATERIAL_REQUIS_LINE process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                               description_        => 'Issue of Material Requisition Line',
                                                               process_package_    => 'DATA_CAPT_ISSUE_MTRL_REQ_API',
                                                               process_component_  => 'INVENT',
                                                               config_menu_label_  => 'Issue Material Requisition Line');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptIssueMtrlReq.sql','Timestamp_3');
PROMPT Inserting ISSUE_MATERIAL_REQUIS_LINE process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'ORDER_NO',
                                                              description_                   => 'Order No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 12,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
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
         
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'PART_NO',
                                                              description_                   => 'Part No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
       
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'LINE_NO',
                                                              description_                   => 'Line No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 4,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'RELEASE_NO',
                                                              description_                   => 'Release No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 4,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'LINE_ITEM_NO',
                                                              description_                   => 'Line Item No',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'LOT_BATCH_NO',
                                                              description_                   => 'Lot/Batch No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 20,
                                                              config_fixed_value_            => '*',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'SERIAL_NO',
                                                              description_                   => 'Serial No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_fixed_value_            => '*',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'WAIV_DEV_REJ_NO',
                                                              description_                   => 'W/D/R No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'ENG_CHG_LEVEL',
                                                              description_                   => 'Revision No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 6,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'CONFIGURATION_ID',
                                                              description_                   => 'Configuration ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'ACTIVITY_SEQ',
                                                              description_                   => 'Activity Sequence',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
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
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'INPUT_QUANTITY',
                                                              description_                   => 'Input Quantity',
                                                              data_type_db_                  => 'NUMBER',                                                              
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',                                                                                                                            
                                                              config_data_item_order_        => config_data_item_order_);
   
   --- GTIN related ---

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'QTY_TO_ISSUE',
                                                              description_                   => 'Quantity To Issue',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_fixed_value_            => '1',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '1',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'CATCH_QTY_TO_ISSUE',
                                                              description_                   => 'Catch Quantity To Issue',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'BARCODE_ID',
                                                              description_                   => 'Barcode ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'ISSUE_MATERIAL_REQUIS_LINE',
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



exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptIssueMtrlReq.sql','Timestamp_4');
PROMPT Inserting ISSUE_MATERIAL_REQUIS_LINE process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN

   -- New unique feedback items for this process only
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'TOTAL_VALUE',
                                                              description_        => 'Total Value',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'INT_CUSTOMER_NO',
                                                              description_        => 'Internal Customer',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'INT_CUSTOMER_NAME',
                                                              description_        => 'Internal Customer Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'DESTINATION_ID',
                                                              description_        => 'Internal Destination ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'INTERNAL_DESTINATION',
                                                              description_        => 'Internal Destination',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'QTY_DUE',
                                                              description_        => 'Qty Due',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'QTY_ASSIGNED',
                                                              description_        => 'Qty Reserved',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'QTY_SHIPPED',
                                                              description_        => 'Qty Issued',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'QTY_ON_ORDER',
                                                              description_        => 'Qty On Order',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'QTY_RETURNED',
                                                              description_        => 'Qty Returned',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'CONDITION_CODE',
                                                              description_        => 'Condition Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PLANNED_DELIVERY_DATE',
                                                              description_        => 'Delivery Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'DUE_DATE',
                                                              description_        => 'Due Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'SUPPLY_CODE',
                                                              description_         => 'Supply Code',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'MATERIAL_REQUIS_SUPPLY_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HEAD_STATUS_CODE',
                                                              description_         => 'Status',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'MATERIAL_REQUIS_STATUS_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'LINE_STATUS_CODE',
                                                              description_         => 'Line Status',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'MATERIAL_REQUIS_STATUS_API');

   -- Regular feedback items common in several processes

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'UNIT_MEAS',
                                                              description_        => 'UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'UNIT_MEAS_DESCRIPTION',
                                                              description_        => 'UoM Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS',
                                                              description_        => 'Catch UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS_DESCRIPTION',
                                                              description_        => 'Catch UoM Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'QUANTITY_ONHAND',
                                                              description_        => 'Qty Onhand',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'CATCH_QUANTITY_ONHAND',
                                                              description_        => 'Catch Qty Onhand',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'NET_WEIGHT',
                                                              description_        => 'Net Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'NET_VOLUME',
                                                              description_        => 'Net Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PROJECT_ID',
                                                              description_        => 'Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PROJECT_NAME',
                                                              description_        => 'Project Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PROGRAM_ID',
                                                              description_        => 'Program ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PROGRAM_DESCRIPTION',
                                                              description_        => 'Program Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'SUB_PROJECT_ID',
                                                              description_        => 'Sub Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'SUB_PROJECT_DESCRIPTION',
                                                              description_        => 'Sub Project Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ACTIVITY_ID',
                                                              description_        => 'Activity ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ACTIVITY_DESCRIPTION',
                                                              description_        => 'Activity Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'CONDITION_CODE_DESCRIPTION',
                                                              description_        => 'Condition Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'PART_TYPE',
                                                              description_         => 'Part Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'INVENTORY_PART_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PRIME_COMMODITY',
                                                              description_        => 'Comm Group 1',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PRIME_COMMODITY_DESCRIPTION',
                                                              description_        => 'Comm Group 1 Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'SECOND_COMMODITY',
                                                              description_        => 'Comm Group 2',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'SECOND_COMMODITY_DESCRIPTION',
                                                              description_        => 'Comm Group 2 Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ASSET_CLASS',
                                                              description_        => 'Asset Class',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ASSET_CLASS_DESCRIPTION',
                                                              description_        => 'Asset Class Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PART_STATUS',
                                                              description_        => 'Part Status',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PART_STATUS_DESCRIPTION',
                                                              description_        => 'Part Status Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ABC_CLASS',
                                                              description_        => 'ABC Class',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ABC_CLASS_PERCENT',
                                                              description_        => 'ABC Class Percent',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'SAFETY_CODE',
                                                              description_        => 'Safety Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'SAFETY_CODE_DESCRIPTION',
                                                              description_        => 'Safety Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ACCOUNTING_GROUP',
                                                              description_        => 'Accounting Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'ACCOUNTING_GROUP_DESCRIPTION',
                                                              description_        => 'Accounting Group Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PRODUCT_CODE',
                                                              description_        => 'Product Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PRODUCT_CODE_DESCRIPTION',
                                                              description_        => 'Product Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PRODUCT_FAMILY',
                                                              description_        => 'Product Family',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PRODUCT_FAMILY_DESCRIPTION',
                                                              description_        => 'Product Family Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                                              description_         => 'Serial Tracking at Receipt and Issue',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_DELIVERY',
                                                              description_         => 'Serial Tracking After Delivery',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_INVENTORY',
                                                              description_         => 'Serial Tracking in Inventory',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'STOP_ARRIVAL_ISSUED_SERIAL',
                                                              description_         => 'Stop PO Arrivals of Issued Serials',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'STOP_NEW_SERIAL_IN_RMA',
                                                              description_         => 'Stop Creation of New Serials in RMA',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'SERIAL_RULE',
                                                              description_         => 'Serial Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'LOT_BATCH_TRACKING',
                                                              description_         => 'Lot/Batch Tracking',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_LOT_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'LOT_QUANTITY_RULE',
                                                              description_         => 'Lot Quantity Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'LOT_QUANTITY_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'SUB_LOT_RULE',
                                                              description_         => 'Sub Lot Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'SUB_LOT_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'COMPONENT_LOT_RULE',
                                                              description_         => 'Component Lot Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'COMPONENT_LOT_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'GTIN_DEFAULT',
                                                              description_         => 'Default GTIN',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'GTIN_IDENTIFICATION',
                                                              description_         => 'GTIN Used for Identification',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'RECEIPTS_BLOCKED',
                                                              description_         => 'Receipts Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'MIX_OF_PART_NUMBER_BLOCKED',
                                                              description_         => 'Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'MIX_OF_CONDITION_CODES_BLOCKED',
                                                              description_         => 'Mix of Condition Codes Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'MIX_OF_LOT_BATCH_NO_BLOCKED',
                                                              description_         => 'Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'LOCATION_GROUP',
                                                              description_         => 'Location Group',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'LOCATION_TYPE',
                                                              description_         => 'Location Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'OWNERSHIP',
                                                              description_         => 'Ownership',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_OWNERSHIP_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'OWNER',
                                                              description_         => 'Owner',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'EXPIRATION_DATE',
                                                              description_         => 'Expiration Date',
                                                              data_type_           => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'AVAILABILTY_CONTROL_ID',
                                                              description_         => 'Availability Control ID',
                                                              data_type_           => 'STRING');
   
   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'INPUT_CONV_FACTOR',
                                                              description_         => 'Input Conversion Factor',
                                                              data_type_           => 'NUMBER');
   --- GTIN related ---
    
   ------------------------------------------------------------------------------------------------------------------
   -- Handling unit related feedback items --------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Handling Unit Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Handling Unit Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_SHIPMENT_ID',
                                                              description_        => 'Shipment ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_ACCESSORY_EXIST',
                                                              description_         => 'Accessory Exist',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'HANDLING_UNIT_COMPOSITION_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_LENGTH',
                                                              description_        => 'Uom For Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_NET_WEIGHT',
                                                              description_        => 'Net Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_        => 'Manual Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_        => 'Operative Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_WEIGHT',
                                                              description_        => 'Uom For Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_        => 'Manual Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_        => 'Operative Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_VOLUME',
                                                              description_        => 'UoM For Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_NO_OF_LBLS',
                                                              description_        => 'No of Handling Unit Labels',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED',
                                                              description_         => 'Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED',
                                                              description_         => 'Mix of Condition Code Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED',
                                                              description_         => 'Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');



END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptIssueMtrlReq.sql','Timestamp_5');
PROMPT Inserting ISSUE_MATERIAL_REQUIS_LINE process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                           capture_process_detail_id_ => 'ISSUE_UNRESERVED_MATERIAL',
                                                           description_               => 'Allow Issue for Unreserved Material Requisition Line',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                           capture_process_detail_id_ => 'BARCODE_ID_IS_MANDATORY',
                                                           description_               => 'Barcode ID is mandatory',
                                                           enabled_db_                => 'FALSE');
   
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                           capture_process_detail_id_ => 'GTIN_IS_MANDATORY',
                                                           description_               => 'GTIN is mandatory',
                                                           enabled_db_                => 'FALSE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'ISSUE_MATERIAL_REQUIS_LINE',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptIssueMtrlReq.sql','Done');
PROMPT Finished with POST_INVENT_DataCaptIssueMtrlReq.sql
