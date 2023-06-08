
-------------------------------------------------------------------------------
--
--  Filename      : POST_Invent_DataCaptDeleteHndlUnit.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process DELETE_HANDLING_UNIT.
--                  NOTE: Some shipment specific data will also be inserted into this process
--                  from POST_SHPMNT_DataCaptDeleteHndlUnit script if shipment is installed.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  171018  DaZase  STRSC-13007, Added GS1_BARCODE1, GS1_BARCODE2 as a new data items.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160519  KhVese  LIM-6162 Modified  feedback items.
--  160122  KhVese  LIM-6000 Modified DELETE_CONNECTED_HANDLING_UNITS configuration.
--  160120  KhVese  LIM-5985 Removed feedback item HANDLING_UNIT_TYPE_UOM_LENGTH.
--  160114  KhVese  LIM-5315 Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptDeleteHndlUnit.sql','Timestamp_1');
PROMPT Starting POST_Invent_DataCaptDeleteHndlUnit.SQL

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptDeleteHndlUnit.sql','Timestamp_2');
PROMPT Inserting DELETE_HANDLING_UNIT process invent specific data itemsto DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'DELETE_HANDLING_UNIT',
                                                               description_        => 'Delete Handling Unit',
                                                               process_package_    => 'DATA_CAPT_DELETE_HNDL_UNIT_API',
                                                               process_component_  => 'INVENT',
                                                               config_menu_label_  => 'Delete Handling Unit');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptDeleteHndlUnit.sql','Timestamp_3');
PROMPT Inserting DELETE_HANDLING_UNIT process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 3; -- Leaving a space of 2 for shipment data items that might be installed into this process
BEGIN

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELETE_HANDLING_UNIT',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELETE_HANDLING_UNIT',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELETE_HANDLING_UNIT',
                                                              data_item_id_                  => 'ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELETE_HANDLING_UNIT',
                                                              data_item_id_                  => 'DELETE_CONNECTED_HANDLING_UNITS',
                                                              description_                   => 'Delete Connected Handling Units',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 3,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELETE_HANDLING_UNIT',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELETE_HANDLING_UNIT',
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

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptDeleteHndlUnit.sql','Timestamp_4');
PROMPT Inserting DELETE_HANDLING_UNIT process invent specific feedback items to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_STRUCTURE_LEVEL',
                                                              description_         => 'Structure Level',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_ACCESSORY_EXIST',
                                                              description_         => 'Accessory Exist',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'HANDLING_UNIT_COMPOSITION_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_WIDTH',
                                                              description_         => 'Width',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_HEIGHT',
                                                              description_         => 'Height',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_DEPTH',
                                                              description_         => 'Depth',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_UOM_LENGTH',
                                                              description_         => 'Uom For Length',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_UOM_VOLUME',
                                                              description_         => 'UoM Volume',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_UOM_WEIGHT',
                                                              description_         => 'UoM Weight',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_         => 'Manual Volume',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_         => 'Manual Gross Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_         => 'Operative Volume',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_         => 'Operative Gross Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_NET_WEIGHT',
                                                              description_         => 'Net Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TARE_WEIGHT',
                                                              description_         => 'Tare Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED',
                                                              description_         => 'Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED',
                                                              description_         => 'Mix of Condition Codes Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED',
                                                              description_         => 'Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_NO_OF_LBLS',
                                                              description_         => 'No of Handling Unit Labels',
                                                              data_type_           => 'NUMBER');

   ------------- Handling Unit Type Feedback Items----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'PARENT_HANDLING_UNIT_DESC',
                                                              description_         => 'Parent Handling Unit Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ID',
                                                              description_         => 'Handling Unit Type ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Handling Unit Type Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_         => 'Category ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_         => 'Category Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   ------------- Parent Handling Unit Feedback Items----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'PARENT_HANDLING_UNIT_ID',
                                                              description_         => 'Parent Handling Unit ID',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'PARENT_SSCC',
                                                              description_         => 'Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Parent Alt Handling Unit Label ID',
                                                              data_type_           => 'STRING');

   ------------- Top Parent Handling Unit Feedback Items----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_         => 'Top Parent Handling Unit ID',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_         => 'Top Parent Type ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   ------------- Level 2 Handling Unit Feedback items----------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'DELETE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');


END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptDeleteHndlUnit.sql','Timestamp_5');
PROMPT Inserting DELETE_HANDLING_UNIT process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELETE_HANDLING_UNIT',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptDeleteHndlUnit.sql','Done');
PROMPT Finished with POST_Invent_DataCaptDeleteHndlUnit.sql

