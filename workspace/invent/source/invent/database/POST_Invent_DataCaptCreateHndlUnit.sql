
-------------------------------------------------------------------------------
--
--  Filename      : POST_INVENT_DataCaptCreateHndlUnit.sql
--
--  Module        : INVENT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process CREATE_HANDLING_UNIT.
--                  NOTE: Some shipment specific data will also be inserted into this process
--                  from POST_SHPMNT_DataCaptCreateHndlUnit script if shipment is installed.
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
--  171018  DaZase  STRSC-13005, Added GS1_BARCODE1, GS1_BARCODE2 and GS1_BARCODE3 as a new data items.
--  161102  DaZase  LIM-7326, Changed length of CREATE_SSCC/PRINT_HANDLING_UNIT_LABEL to 20 to avoid language issues.
--  151201  DaZase  LIM-2922 Created/Copied from POST_ORDER_DataCapAddHandlingUnit.sql.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCreateHndlUnit.sql','Timestamp_1');
PROMPT Starting POST_INVENT_DataCaptCreateHndlUnit.sql

------------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
------------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCreateHndlUnit.sql','Timestamp_2');
PROMPT Inserting CREATE_HANDLING_UNIT process invent specific data itemsto DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                               description_        => 'Create Handling Unit',
                                                               process_package_    => 'DATA_CAPT_CREATE_HNDL_UNIT_API',
                                                               process_component_  => 'INVENT',
                                                               config_menu_label_  => 'Create Handling Unit');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCreateHndlUnit.sql','Timestamp_3');
PROMPT Inserting CREATE_HANDLING_UNIT process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 10; -- Leaving a space of 9 for shipment data items that might be installed into this process
BEGIN

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'HANDLING_UNIT_TYPE_ID',
                                                              description_                   => 'Handling Unit Type ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'PARENT_HANDLING_UNIT_ID',
                                                              description_                   => 'Parent Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'PARENT_SSCC',
                                                              description_                   => 'Parent SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Parent Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'NO_OF_NEW_UNITS',
                                                              description_                   => 'Number of Units',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_use_automatic_value_db_ => 'OFF',                                                              
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'CREATE_SSCC',
                                                              description_                   => 'Create SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 20,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_fixed_value_            => 'N',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'PRINT_HANDLING_UNIT_LABEL',
                                                              description_                   => 'Print Handling Unit Label',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 20,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_list_of_values_db_      => 'FORCED',
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'NO_OF_HANDLING_UNIT_LABELS',
                                                              description_                   => 'No of Handling Unit Labels',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_fixed_value_            => 1,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'CREATE_HANDLING_UNIT',
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

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCreateHndlUnit.sql','Timestamp_4');
PROMPT Inserting CREATE_HANDLING_UNIT process invent specific feedback items to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Handling Unit Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Handling Unit Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_LENGTH',
                                                              description_        => 'UoM For Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_VOLUME',
                                                              description_        => 'Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                              description_        => 'UoM For Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                              description_        => 'UoM For Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_COST',
                                                              description_        => 'Cost',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'CREATE_HANDLING_UNIT',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CURR_CODE',
                                                              description_        => 'Currency Code',
                                                              data_type_          => 'STRING');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCreateHndlUnit.sql','Timestamp_5');
PROMPT Inserting CREATE_HANDLING_UNIT process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN                                                      
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'CREATE_HANDLING_UNIT',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_DataCaptCreateHndlUnit.sql','Done');
PROMPT Finished with POST_INVENT_DataCaptCreateHndlUnit.sql

