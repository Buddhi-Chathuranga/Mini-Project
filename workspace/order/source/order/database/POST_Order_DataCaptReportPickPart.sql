--------------------------------------------------------------------------------
--
--  Filename      : POST_Order_DataCaptReportPickPart.sql
--
--  Module        : ORDER
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process REPORT_PICKING_PART.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  201016  Dazase  Bug 155633 (SCZ-11511), Added PICK_BY_CHOICE_DETAILS as a new process detail flag.
--  180719  BudKlk  Bug 142134, Added a new feedback item 'RECEIVER_ADDRESS_NAME'.
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  180215  DaZase  STRSC-16914, Removed connection between CATCH_QTY_PICKED and LOCATION_NO_DESC.
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  171207  MaAuse  STRSC-15088, Added MAX_WEIGHT_VOLUME_ERROR as a new detail item.
--  170915  DaZase  STRSC-11606, Added GS1_BARCODE1, GS1_BARCODE2 and GS1_BARCODE3 as a new data items.
--  170904  SURBLK  STRSC-11287, Added GTIN, INPUT_UOM and INPUT_QUANTITY data items and INPUT_CONV_FACTOR as feedback item and GTIN_IS_MANDATORY as detail item.
--  170506  RuLiLk  Bug 131948, Set config_use_automatic_value_db_ 'OFF' in UNIQUE_LINE_ID to fetch values using only LOV AUTO_PICK to avoid duplicate record set error.
--  170411  KhVese  LIM-11386, Changed the order of data item renaming and instalation to prevent data items get same order numbers in upgrade.
--  170330  DaZase  LIM-10352, Renamed file from POST_ORDER_DataCaptPickCustOrder.sql to POST_Order_DataCaptReportPickPart.sql.
--  170330          Renamed process from PICK_CUST_ORDER to REPORT_PICKING_PART
--  160913  DaZase  Removed unnecessary feedback ORDER_NO since it already exist as data item.
--  160909  DaZase  LIM-8336, Renamed process description/menu label and renamed some of the items and added a couple of new items.
--  160219  SWiclk  Bug 127172, Added new process detail BARCODE_ID_IS_MANDATORY.
--  151124  SWiclk  STRSC-306, Added feedback item SHIP_LOCATION_NO_DESC.
--  151027  Erlise  LIM-3779, Added a rename section. Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID.
--  150917  DaZase  AFT-5484, Added data_type to all new feedback items.
--  150519  RILASE  COB-28, Added data items for handling units: HANDLING_UNIT_ID, SSCC, ALT_TRANSPORT_LABEL_ID and RELEASE_RESERVATIONS.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150227  RILASE  Added when applicable support for SHIPMENT_ID.
--  150730  RuLiLk  Bug 121975, Data type is sent when installing feedback items.
--  150215  AyAmlk  Bug 120309, Handled non-ASCII characters.
--  150115  DaZase  PRSC-5056, Replaced Install_Process_And_Config-call with Install_Process_And_All_Config and replaced all
--  150115          Install_Proc_Config_Data_Item-calls with Install_Data_Item_All_Configs and replaced
--  150115          Install_Process_Config_Detail-call with Install_Detail_All_Configs.
--  141209  DaZase  PRSC-4245, Changed LAST_LINE_ON_PICK_LIST to become a feedback item.
--  141205  DaZase  PRSC-4409, Added LAST_LINE_ON_PICK_LIST as control item, added calls to Install_Subseq_Config/Install_Subseq_Conf_Data_Item.
--  141105  ChBnlk  Bug 119558, Added new feedback items CONDITION_CODE and CONDITION_CODE_DESCRIPTION.
--  141009  DaZase  PRSC-63, Added config_list_of_values_db_ => 'ON' and process_list_of_val_supported_ => 'TRUE' to BARCODE_ID.
--  141001  RiLase  PRSC-2782, Added process component.
--  140926  JeLise  PRSC-2366, Added LAST_LINE_ON_PICK_LIST as new data item
--  140917  DaZase  PRSC-2781, Added enumeration_package to following feedback items: PART_TYPE,
--  140917          SERIAL_TRACKING_RECEIPT_ISSUE, SERIAL_TRACKING_DELIVERY, SERIAL_TRACKING_INVENTORY,
--  140917          STOP_ARRIVAL_ISSUED_SERIAL, STOP_NEW_SERIAL_IN_RMA, SERIAL_RULE, LOT_BATCH_TRACKING,
--  140917          LOT_QUANTITY_RULE, SUB_LOT_RULE, COMPONENT_LOT_RULE, GTIN_IDENTIFICATION, RECEIPTS_BLOCKED,
--  140917          MIX_OF_PART_NUMBER_BLOCKED, MIX_OF_CONDITION_CODES_BLOCKED, MIX_OF_LOT_BATCH_NO_BLOCKED,
--  140917          LOCATION_TYPE.
--  140904  JeLise  PRSC-2366, Added WAREHOUSE_TASK_ID as a new data item to work with Warehouse Task.
--  140814  DaZase  PRSC-1611, Changed description of ENG_CHG_LEVEL from EC to Revision No.
--  140805  DaZase  PRSC-1431, Added string_length_ to all STRING calls to Install_Proc_Config_Data_Item.
--  140805          Changed data_type_ to data_type_db_ on all calls to Install_Proc_Config_Data_Item. Changed REL_NO to a STRING type.
--  140319  DaZase  Added SHIPMENT_ID as a new data item to the process so process will work with T&L extension.
--  131106  RuLiLk  Bug 113200, Update the script to add detail items and added new detail item ALLOW_OVERPICK_LINES to REPORT_PICKING_PART.
--  121024  DaZase  Changed file from ins to post script.
--  121004  JeLise  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_1');
PROMPT Starting POST_Order_DataCaptReportPickPart.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_2');
PROMPT Inserting REPORT_PICKING_PART process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'REPORT_PICKING_PART',
                                                               description_        => 'Report Picking of Parts',
                                                               process_package_    => 'DATA_CAPT_REPORT_PICK_PART_API',
                                                               process_component_  => 'ORDER',
                                                               config_menu_label_  => 'Report Picking of Parts');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_3');
PROMPT Renaming data items
-- Rename Configuration Data Items
BEGIN
   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'REPORT_PICKING_PART',
                                                            old_data_item_id_                => 'ALT_TRANSPORT_LABEL_ID',
                                                            new_data_item_id_                => 'ALT_HANDLING_UNIT_LABEL_ID',
                                                            new_data_item_desc_              => 'Alt Handling Unit Label ID');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'REPORT_PICKING_PART',
                                                            old_data_item_id_                => 'ALT_HANDLING_UNIT_LABEL_ID',
                                                            new_data_item_id_                => 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                            new_data_item_desc_              => 'Shipment Alt Handling Unit Label ID');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'REPORT_PICKING_PART',
                                                            old_data_item_id_                => 'HANDLING_UNIT_ID',
                                                            new_data_item_id_                => 'SHP_HANDLING_UNIT_ID',
                                                            new_data_item_desc_              => 'Shipment Handling Unit ID');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'REPORT_PICKING_PART',
                                                            old_data_item_id_                => 'SSCC',
                                                            new_data_item_id_                => 'SHP_SSCC',
                                                            new_data_item_desc_              => 'Shipment SSCC');


END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_4');
PROMPT Inserting REPORT_PICKING_PART process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'WAREHOUSE_TASK_ID',
                                                              description_                   => 'Warehouse Task ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              config_subseq_data_item_id_    => 'WAREHOUSE_TASK_ID',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'PICK_LIST_NO',
                                                              description_                   => 'Pick List No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_subseq_data_item_id_    => 'PICK_LIST_NO',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'UNIQUE_LINE_ID',
                                                              description_                   => 'Unique Line ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'SHIPMENT_ID',
                                                              description_                   => 'Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_fixed_value_            => '0',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_default_fixed_value_   => '0',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'ORDER_NO',
                                                              description_                   => 'Order No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 12,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'LINE_NO',
                                                              description_                   => 'Line No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 4,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'REL_NO',
                                                              description_                   => 'Del No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 4,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'LINE_ITEM_NO',
                                                              description_                   => 'Line Item No',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'PART_NO',
                                                              description_                   => 'Part No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'LOT_BATCH_NO',
                                                              description_                   => 'Lot/Batch No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 20,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_fixed_value_            => '*',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'SERIAL_NO',
                                                              description_                   => 'Serial No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_fixed_value_            => '*',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'CONFIGURATION_ID',
                                                              description_                   => 'Configuration ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_fixed_value_            => '*',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_default_fixed_value_   => '*',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'ENG_CHG_LEVEL',
                                                              description_                   => 'Revision No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 6,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'WAIV_DEV_REJ_NO',
                                                              description_                   => 'W/D/R No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'ACTIVITY_SEQ',
                                                              description_                   => 'Activity Sequence',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'RES_HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'RES_SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'RES_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'QTY_PICKED',
                                                              description_                   => 'Qty Picked',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_fixed_value_            => 1,
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              process_default_fixed_value_   => '1',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'CATCH_QTY_PICKED',
                                                              description_                   => 'Catch Qty Picked',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'SHP_HANDLING_UNIT_ID',
                                                              description_                   => 'Shipment Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'SHP_SSCC',
                                                              description_                   => 'Shipment SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Shipment Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'SHIP_LOCATION_NO',
                                                              description_                   => 'Shipment Location No',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 35,
                                                              process_key_db_                => 'FALSE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_data_item_order_        => config_data_item_order_ );

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'RELEASE_RESERVATION',
                                                              description_                   => 'Release Reservation',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 3,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'DEFAULT',
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'BARCODE_ID',
                                                              description_                   => 'Barcode ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICKING_PART',
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

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_5');
PROMPT Inserting REPORT_PICKING_PART process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                            feedback_item_id_     => 'QTY_TO_PICK',
                                                            description_          => 'Qty To Pick',
                                                            data_type_            => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'UNIT_MEAS',
                                                              description_        => 'UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                                feedback_item_id_ => 'UNIT_MEAS_DESCRIPTION',
                                                                description_      => 'UoM Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS',
                                                              description_        => 'Catch UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS_DESCRIPTION',
                                                              description_        => 'Catch UoM Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'NET_WEIGHT',
                                                              description_        => 'Net Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'NET_VOLUME',
                                                              description_        => 'Net Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'OWNER',
                                                              description_        => 'Owner',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PROGRAM_ID',
                                                              description_        => 'Program ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PROGRAM_DESCRIPTION',
                                                              description_        => 'Program Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PROJECT_ID',
                                                              description_        => 'Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PROJECT_NAME',
                                                              description_        => 'Project Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SUB_PROJECT_ID',
                                                              description_        => 'Sub Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SUB_PROJECT_DESCRIPTION',
                                                              description_        => 'Sub Project Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ACTIVITY_ID',
                                                              description_        => 'Activity ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ACTIVITY_DESCRIPTION',
                                                              description_        => 'Activity Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CUSTOMER_NO',
                                                              description_        => 'Customer',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CUSTOMER_NAME',
                                                              description_        => 'Customer Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'PART_TYPE',
                                                              description_         => 'Part Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'INVENTORY_PART_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PRIME_COMMODITY',
                                                              description_        => 'Comm Group 1',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PRIME_COMMODITY_DESCRIPTION',
                                                              description_        => 'Comm Group 1 Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SECOND_COMMODITY',
                                                              description_        => 'Comm Group 2',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SECOND_COMMODITY_DESCRIPTION',
                                                              description_        => 'Comm Group 2 Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ASSET_CLASS',
                                                              description_        => 'Asset Class',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ASSET_CLASS_DESCRIPTION',
                                                              description_        => 'Asset Class Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PART_STATUS',
                                                              description_        => 'Part Status',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PART_STATUS_DESCRIPTION',
                                                              description_        => 'Part Status Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ABC_CLASS',
                                                              description_        => 'ABC Class',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ABC_CLASS_PERCENT',
                                                              description_        => 'ABC Class Percent',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SAFETY_CODE',
                                                              description_        => 'Safety Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SAFETY_CODE_DESCRIPTION',
                                                              description_        => 'Safety Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ACCOUNTING_GROUP',
                                                              description_        => 'Accounting Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ACCOUNTING_GROUP_DESCRIPTION',
                                                              description_        => 'Accounting Group Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PRODUCT_CODE',
                                                              description_        => 'Product Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PRODUCT_CODE_DESCRIPTION',
                                                              description_        => 'Product Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PRODUCT_FAMILY',
                                                              description_        => 'Product Family',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'PRODUCT_FAMILY_DESCRIPTION',
                                                              description_        => 'Product Family Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                                              description_         => 'Serial Tracking at Receipt and Issue',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_DELIVERY',
                                                              description_         => 'Serial Tracking After Delivery',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SERIAL_TRACKING_INVENTORY',
                                                              description_         => 'Serial Tracking in Inventory',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'STOP_ARRIVAL_ISSUED_SERIAL',
                                                              description_         => 'Stop PO Arrivals of Issued Serials',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'STOP_NEW_SERIAL_IN_RMA',
                                                              description_         => 'Stop Creation of New Serials in RMA',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SERIAL_RULE',
                                                              description_         => 'Serial Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_SERIAL_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'LOT_BATCH_TRACKING',
                                                              description_         => 'Lot/Batch Tracking',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_LOT_TRACKING_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'LOT_QUANTITY_RULE',
                                                              description_         => 'Lot Quantity Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'LOT_QUANTITY_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SUB_LOT_RULE',
                                                              description_         => 'Sub Lot Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'SUB_LOT_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'COMPONENT_LOT_RULE',
                                                              description_         => 'Component Lot Rule',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'COMPONENT_LOT_RULE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'GTIN_DEFAULT',
                                                              description_        => 'Default GTIN',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'GTIN_IDENTIFICATION',
                                                              description_         => 'GTIN Used for Identification',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'WANTED_DELIVERY_DATE',
                                                              description_        => 'Wanted Delivery Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ORDER_TYPE',
                                                              description_        => 'Type',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ORDER_TYPE_DESCRIPTION',
                                                              description_        => 'Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ORDER_STATUS',
                                                              description_        => 'Status',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ORDER_COORDINATOR',
                                                              description_        => 'Coordinator',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ORDER_PRIORITY',
                                                              description_        => 'Priority',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ORDER_REFERENCE',
                                                              description_        => 'Reference',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'ORDER_REFERENCE_NAME',
                                                              description_        => 'Reference Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CUSTOMER_PO_NO',
                                                              description_        => Database_SYS.Unistr('Customer\0027s PO No'),
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_SALES_PART',
                                                              description_        => 'Sales Part',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_SALES_PART_DESCRIPTION',
                                                              description_        => 'Sales Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_WANTED_DELIVERY_DATE',
                                                              description_        => 'Wanted Delivery Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_TARGET_DATE',
                                                              description_        => 'Target Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_PLANNED_DELIVERY_DATE',
                                                              description_        => 'Planned Delivery Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_PROMISED_DELIVERY_DATE',
                                                              description_        => 'Promised delivery Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_PLANNED_SHIP_DATE',
                                                              description_        => 'Planned Ship Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_PLANNED_DUE_DATE',
                                                              description_        => 'Planned Due Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LINE_CREATED',
                                                              description_        => 'Created',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'RECEIPTS_BLOCKED',
                                                              description_         => 'Receipts Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'MIX_OF_PART_NUMBER_BLOCKED',
                                                              description_         => 'Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'MIX_OF_CONDITION_CODES_BLOCKED',
                                                              description_         => 'Mix of Condition Codes Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'MIX_OF_LOT_BATCH_NO_BLOCKED',
                                                              description_         => 'Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LOCATION_GROUP',
                                                              description_        => 'Location Group',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'LOCATION_TYPE',
                                                              description_         => 'Location Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'LOCATION_NO_DESC',
                                                              description_        => 'Location No Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CONDITION_CODE',
                                                              description_        => 'Condition Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CONDITION_CODE_DESCRIPTION',
                                                              description_        => 'Condition Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICKING_PART',
                                                              feedback_item_id_         => 'LAST_LINE_ON_PICK_LIST',
                                                              description_              => 'Last Line on Pick List',
                                                              data_type_                => 'STRING',
                                                              enumeration_package_      => 'GEN_YES_NO_API',
                                                              feedback_item_value_view_ => 'GEN_YES_NO',
                                                              feedback_item_value_pkg_  => 'GEN_YES_NO_API');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RECEIVER_ADDRESS_NAME',
                                                              description_        => 'Receiver Address Name',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Shipment Handling unit related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_DESC',
                                                              description_        => 'Parent Handling Unit Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_VOLUME',
                                                              description_        => 'Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                              description_        => 'UoM Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_        => 'Manual Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_        => 'Manual Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                              description_        => 'UoM Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_UOM_LENGTH',
                                                              description_        => 'UoM Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICKING_PART',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS',
                                                              description_        => 'No of Handling Unit Labels',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RECEIVER_ID',
                                                              description_        => 'Receiver ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'FORWARD_AGENT_ID',
                                                              description_        => 'Forwarder',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHIP_VIA_CODE',
                                                              description_        => 'Ship Via Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHIPMENT_TYPE',
                                                              description_        => 'Shipment Type',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'CUSTOMER_ADDRESS_ID',
                                                              description_        => 'Customer Address ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'SHIP_LOCATION_NO_DESC',
                                                              description_        => 'Shipment Location No Description',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Reserv/Inventory Handling unit related feedback items ---------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_SSCC',
                                                              description_        => 'Top Parent SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Top Parent Alt Label ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Top Parent Type Desc',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'RES_LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');
   
   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICKING_PART',
                                                              feedback_item_id_   => 'INPUT_CONV_FACTOR',
                                                              description_        => 'Input Conversion Factor',
                                                              data_type_          => 'NUMBER');
   --- GTIN related ---
   
   END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_6');
PROMPT Renaming feedback items
-- Rename Configuration Feedback Items
BEGIN

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'DELIVER_TO_CUSTOMER_NO',
                                                               new_feedback_item_id_   => 'RECEIVER_ID',
                                                               new_data_item_desc_     => 'Receiver ID');


   -- Feedback items that have not change description, only the id since we need to indicate more clearly if they come from Shipment HU or Inventory/Reservation HU
   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'PARENT_HANDLING_UNIT_ID',
                                                               new_feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'PARENT_HANDLING_UNIT_DESC',
                                                               new_feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_DESC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_DESC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_DESC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_WIDTH',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_WIDTH');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_HEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_HEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_DEPTH',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_DEPTH');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_TARE_WEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'MANUAL_GROSS_WEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'MANUAL_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_UOM_LENGTH',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_LENGTH');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_STACKABLE');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_GEN_SSCC',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_PRINT_LBL',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REPORT_PICKING_PART',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_NO_OF_LBLS',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_7');
PROMPT Removing feedback items
-- Removing Configuration Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Uninstall_Feedback_All_Config(capture_process_id_  =>  'REPORT_PICKING_PART',
                                                              feedback_item_id_    =>  'ORDER_NO');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_8');
PROMPT ADD CONFIG CTRL ITEM TO REPORT_PICKING_PART process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_           => 'REPORT_PICKING_PART',
                                                         config_ctrl_feedback_item_id_ => 'LAST_LINE_ON_PICK_LIST');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_9');
PROMPT Inserting REPORT_PICKING_PART process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REPORT_PICKING_PART',
                                                           capture_process_detail_id_ => 'ALLOW_OVERPICK_LINES',
                                                           description_               => 'Allow Overpicked Order Lines',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REPORT_PICKING_PART',
                                                           capture_process_detail_id_ => 'BARCODE_ID_IS_MANDATORY',
                                                           description_               => 'Barcode ID is mandatory',
                                                           enabled_db_                => 'FALSE');
   
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REPORT_PICKING_PART',
                                                           capture_process_detail_id_ => 'GTIN_IS_MANDATORY',
                                                           description_               => 'GTIN is mandatory',
                                                           enabled_db_                => 'FALSE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REPORT_PICKING_PART',
                                                           capture_process_detail_id_ => 'MAX_WEIGHT_VOLUME_ERROR',
                                                           description_               => 'Error when Max Weight/Volume is exceeded.',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REPORT_PICKING_PART',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REPORT_PICKING_PART',
                                                           capture_process_detail_id_ => 'PICK_BY_CHOICE_DETAILS',
                                                           description_               => 'Refined fetching of details for performance improvement when using pick by choice.',
                                                           enabled_db_                => 'FALSE'); 
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_10');
PROMPT Connecting feedback items to base (config_id = 1) process
-- Connect feedback items to data items
BEGIN
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_    => 'REPORT_PICKING_PART',
                                                              data_item_id_        => 'LINE_ITEM_NO',
                                                              data_item_detail_id_ => 'PART_DESCRIPTION',
                                                              item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_    => 'REPORT_PICKING_PART',
                                                              data_item_id_        => 'LINE_ITEM_NO',
                                                              data_item_detail_id_ => 'LOCATION_NO_DESC',
                                                              item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_    => 'REPORT_PICKING_PART',
                                                              data_item_id_        => 'ACTIVITY_SEQ',
                                                              data_item_detail_id_ => 'QTY_TO_PICK',
                                                              item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_    => 'REPORT_PICKING_PART',
                                                              data_item_id_        => 'BARCODE_ID',
                                                              data_item_detail_id_ => 'LAST_LINE_ON_PICK_LIST',
                                                              item_type_db_        => 'FEEDBACK');
      
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_11');
PROMPT Disconnecting feedback items from connected data items in all configurations
-- Disconnect feedback items to data items
BEGIN
   -- This connection was added in Apps9, but were obsolete in Apps9 Update1 when LOCATION_NO_DESC was added to LINE_ITEM_NO
   Data_Capture_Common_Util_API.Disconn_Detail_Data_All_Config(capture_process_id_  => 'REPORT_PICKING_PART',
                                                               data_item_id_        => 'CATCH_QTY_PICKED',
                                                               data_item_detail_id_ => 'LOCATION_NO_DESC');
   
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Timestamp_12');
PROMPT Inserting REPORT_PICKING_PART to SUBSEQ_DATA_CAPTURE_CONFIG_TAB
BEGIN

   -- Add START_WAREHOUSE_TASK as subsequent configuration item for process REPORT_PICKING_PART (LAST_LINE_ON_PICK_LIST feedback item is the Subsequent Control Feedback Item in this case on REPORT_PICKING_PART)
   Data_Capture_Common_Util_API.Install_Subseq_Config(capture_process_id_            => 'REPORT_PICKING_PART',
                                                      control_item_value_            => 'Y',
                                                      subsequent_capture_process_id_ => 'START_WAREHOUSE_TASK');
END;
/


COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptReportPickPart.sql','Done');
PROMPT Finished with POST_Order_DataCaptReportPickPart.sql
