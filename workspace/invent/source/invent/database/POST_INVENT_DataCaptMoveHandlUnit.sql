-----------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_DataCaptMoveHandlUnit.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process MOVE_HANDLING_UNIT.
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
--  171024  DaZase  STRSC-13026, Added GS1_BARCODE1, GS1_BARCODE2 as new data items.
--  171023  CKumlk  STRSC-13163, Added Perform Putaway as a detail item.
--  170516  Dazase  STRSC-7886, Added data_item_value_view_ and data_item_value_pkg_ for DESTINATION so it can be used as subsequent control value properly.
--  170103  SWiclk  LIM-10094, Added new feedback item RECEIPT_NO.
--  161213  SWiclk  LIM-9978, Added new feedback items SOURCE_REF1, SOURCE_REF2, SOURCE_REF3, SOURCE_REF_TYPE.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160519  KhVese  LIM-6162, Modified  feedback items.
--  151207  KhVese  LIM-5068, Removed some of handling unit type related feedback items.
--  151118  KhVese  LIM-2926, Added Inventory Part in Stock feedback items.
--  151103  KhVese  LIM-2926, Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptMoveHandlUnit.sql','Timestamp_1');
PROMPT Starting POST_INVENT_DataCaptMoveHandlUnit.SQL

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptMoveHandlUnit.sql','Timestamp_2');
PROMPT Inserting MOVE_HANDLING_UNIT process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                               description_        => 'Move Handling Unit',
                                                               process_package_    => 'DATA_CAPT_MOVE_HANDL_UNIT_API',
                                                               process_component_  => 'INVENT',
                                                               config_menu_label_  => 'Move Handling Unit');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptMoveHandlUnit.sql','Timestamp_3');
PROMPT Inserting MOVE_HANDLING_UNIT process DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'From Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'DESTINATION',
                                                              description_                   => 'Destination',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'INVENTORY_PART_DESTINATION_API',
                                                              data_item_value_view_          => 'INVENTORY_PART_DESTINATION',
                                                              data_item_value_pkg_           => 'INVENTORY_PART_DESTINATION_API',
                                                              config_fixed_value_            => 'N',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'NEVER',
                                                              config_list_of_values_db_      => 'FORCED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'TO_CONTRACT',
                                                              description_                   => 'To Site',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 5,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'TO_LOCATION_NO',
                                                              description_                   => 'To Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'MOVE_COMMENT',
                                                              description_                   => 'Move Comment',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 2000,
                                                              process_key_db_                => 'FALSE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MOVE_HANDLING_UNIT',
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

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptMoveHandlUnit.sql','Timestamp_4');
PROMPT Inserting MOVE_HANDLING_UNIT process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_STRUCTURE_LEVEL',
                                                              description_         => 'Structure Level',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_ACCESSORY_EXIST',
                                                              description_         => 'Accessory Exist',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_WIDTH',
                                                              description_         => 'Width',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_HEIGHT',
                                                              description_         => 'Height',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_DEPTH',
                                                              description_         => 'Depth',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_UOM_LENGTH',
                                                              description_         => 'Uom For Length',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_UOM_VOLUME',
                                                              description_         => 'UoM Volume',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_UOM_WEIGHT',
                                                              description_         => 'UoM Weight',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_         => 'Manual Volume',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_         => 'Manual Gross Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_         => 'Operative Volume',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_         => 'Operative Gross Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_NET_WEIGHT',
                                                              description_         => 'Net Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TARE_WEIGHT',
                                                              description_         => 'Tare Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED',
                                                              description_         => 'Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED',
                                                              description_         => 'Mix of Condition Codes Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED',
                                                              description_         => 'Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_NO_OF_LBLS',
                                                              description_         => 'No of Handling Unit Labels',
                                                              data_type_           => 'NUMBER');

   ------------------------------------------------Type Related---------------------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'PARENT_HANDLING_UNIT_DESC',
                                                              description_        => 'Parent Handling Unit Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ID',
                                                              description_         => 'Handling Unit Type ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Handling Unit Type Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_         => 'Category ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_         => 'Category Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   ------------- Parent Handling Unit Desc----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'PARENT_HANDLING_UNIT_ID',
                                                              description_         => 'Parent Handling Unit ID',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'PARENT_SSCC',
                                                              description_         => 'Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Parent Alt Handling Unit Label ID',
                                                              data_type_           => 'STRING');

   ------------- Top Parent Handling Unit Desc----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_         => 'Top Parent Handling Unit ID',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_         => 'Top Parent Type ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   ------------- Level 2 Handling Unit Desc----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');

   ------------- Handling Unit From Location----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

   ------------- Handling Unit To Location----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TO_LOCATION_TYPE',
                                                              description_        => 'To Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TO_LOCATION_NO_DESC',
                                                              description_         => 'To Location No Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TO_WAREHOUSE_ID',
                                                              description_        => 'To Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TO_BAY_ID',
                                                              description_        => 'To Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TO_TIER_ID',
                                                              description_        => 'To Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TO_ROW_ID',
                                                              description_        => 'To Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TO_BIN_ID',
                                                              description_        => 'To Bin ID',
                                                              data_type_          => 'STRING');

   ------------- Handling Unit Attached Parts Information----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'PART_NO',
                                                              description_        => 'Part No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'CONFIGURATION_ID',
                                                              description_        => 'Configuration ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LOT_BATCH_NO',
                                                              description_        => 'Lot/Batch No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SERIAL_NO',
                                                              description_        => 'Serial No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'ENG_CHG_LEVEL',
                                                              description_        => 'Revision No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'WAIV_DEV_REJ_NO',
                                                              description_        => 'W/D/R No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'CONDITION_CODE',
                                                              description_        => 'Condition Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'CONDITION_CODE_DESCRIPTION',
                                                              description_        => 'Condition Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'ACTIVITY_SEQ',
                                                              description_        => 'Activity Sequence',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'AVAILABILITY_CONTROL_ID',
                                                              description_        => 'Availability Control ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'AVAILABILITY_CONTROL_DESCRIPTION',
                                                              description_        => 'Availability Control Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'FREEZE_FLAG',
                                                              description_        => 'Freeze Flag',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'Inventory_Part_Freeze_Code_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'ROTABLE_PART_POOL_ID',
                                                              description_        => 'Rotable Part Pool ID',
                                                              data_type_          => 'STRING');

   ------------- Activity sequence related feedback items----------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'PROJECT_ID',
                                                              description_        => 'Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'PROJECT_NAME',
                                                              description_        => 'Project Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'PROGRAM_ID',
                                                              description_        => 'Program ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'PROGRAM_DESCRIPTION',
                                                              description_        => 'Program Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SUB_PROJECT_ID',
                                                              description_        => 'Sub Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SUB_PROJECT_DESCRIPTION',
                                                              description_        => 'Sub Project Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'ACTIVITY_ID',
                                                              description_        => 'Activity ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'ACTIVITY_DESCRIPTION',
                                                              description_        => 'Activity Description',
                                                              data_type_          => 'STRING');

   -------------------- Part Quantity information ----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'QTY_ONHAND',
                                                              description_        => 'Qty Onhand',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'QTY_RESERVED',
                                                              description_        => 'Qty Reserved',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'CATCH_QTY_ONHAND',
                                                              description_        => 'Catch Qty Onhand',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'QTY_IN_TRANSIT',
                                                              description_        => 'Qty In Transit',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'CATCH_QTY_IN_TRANSIT',
                                                              description_        => 'Catch Qty In Transit',
                                                              data_type_          => 'NUMBER');

   -------------------- Part Unit of Measure information ----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'UNIT_MEAS',
                                                              description_        => 'UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS',
                                                              description_        => 'Catch UoM',
                                                              data_type_          => 'STRING');

   -------------------Ownership info-------------------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'OWNERSHIP',
                                                              description_         => 'Part Ownership',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_OWNERSHIP_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'OWNER',
                                                              description_        => 'Owner',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'OWNER_NAME',
                                                              description_        => 'Owner Name',
                                                              data_type_          => 'STRING');

   -------------------Date info-------------------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'EXPIRATION_DATE',
                                                              description_        => 'Expiration Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LAST_ACTIVITY_DATE',
                                                              description_        => 'Last Activity Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LAST_COUNT_DATE',
                                                              description_        => 'Last Count Date',
                                                              data_type_          => 'DATE');

   ----------------------Values and Costs-------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TOTAL_ACQUISITION_VALUE',
                                                              description_        => 'Total Acquisition Value',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'TOTAL_INVENTORY_VALUE',
                                                              description_        => 'Total Inventory Value',
                                                              data_type_          => 'NUMBER');

   ----------------------Source details----------------------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SOURCE_REF1',
                                                              description_        => 'Source Ref 1',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SOURCE_REF2',
                                                              description_        => 'Source Ref 2',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SOURCE_REF3',
                                                              description_        => 'Source Ref 3',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SOURCE_REF_TYPE',
                                                              description_        => 'Source Ref Type',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MOVE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'RECEIPT_NO',
                                                              description_        => 'Receipt No',
                                                              data_type_          => 'NUMBER');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptMoveHandlUnit.sql','Timestamp_5');
PROMPT Inserting MOVE_HANDLING_UNIT process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'MOVE_HANDLING_UNIT',
                                                           capture_process_detail_id_ => 'USE_FROM_SITE_AS_AUTOMATIC_VALUE',
                                                           description_               => 'Use selected Site as automatic value for To Site',
                                                           enabled_db_                => 'TRUE');
   
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'MOVE_HANDLING_UNIT',
                                                           capture_process_detail_id_ => 'PERFORM_PUTAWAY',
                                                           description_               => 'Instead of to location the process should Perform Putaway');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'MOVE_HANDLING_UNIT',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');
END;
/

COMMIT;


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_INVENT_DataCaptMoveHandlUnit.sql','Done');
PROMPT Finished with POST_INVENT_DataCaptMoveHandlUnit.sql
