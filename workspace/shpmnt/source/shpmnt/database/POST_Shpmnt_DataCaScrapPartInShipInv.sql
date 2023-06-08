-----------------------------------------------------------------------------
--  Module : SHPMNT
--
--  File   : POST_Shpmnt_DataCaScrapPartInShipInv.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process SCRAP_PARTS_IN_SHIP_INV.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220622   MoinLk  SCDEV-11924, Increased the length of Receiver_ID variable to 50.
--  180216   RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  180124   CKumlk  STRSC-16109, Removed data item FROM_LOCATION_NO.
--  171213   SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  171213   CKumlk  STRSC-15073, Renamed FROM_LOCATION_NO to LOCATION_NO, addded feedback items LOCATION_NO_DESC and LOCATION_TYPE and renamed some feedback items.
--  171211   CKumlk  STRSC-14940, Renamed process id from SCRAP_PARTS_FROM_SHIP_INV to SCRAP_PARTS_IN_SHIP_INV and changed description and menu label.
--  171109   CKumlk  Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaScrapPartInShipInv.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCaScrapPartInShipInv.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaScrapPartInShipInv.sql','Timestamp_2');
PROMPT Inserting SCRAP_PARTS_IN_SHIP_INV process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                               description_        => 'Scrap Parts in Shipment Inventory',
                                                               process_package_    => 'DATA_CAP_PROCESS_PART_SHIP_API',
                                                               process_component_  => 'SHPMNT',
                                                               config_menu_label_  => 'Scrap Parts in Ship Inventory');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaScrapPartInShipInv.sql','Timestamp_3');
PROMPT Inserting SCRAP_PARTS_IN_SHIP_INV process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'SOURCE_REF1',
                                                              description_                   => 'Source Ref 1',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'PICK_LIST_NO',
                                                              description_                   => 'Pick List No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'PART_NO',
                                                              description_                   => 'Part No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'SOURCE_REF2',
                                                              description_                   => 'Source Ref 2',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'SOURCE_REF3',
                                                              description_                   => 'Source Ref 3',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'SOURCE_REF4',
                                                              description_                   => 'Source Ref 4',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'SOURCE_REF_TYPE',
                                                              description_                   => 'Source Ref Type',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'LOGISTICS_SOURCE_REF_TYPE_API',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);


   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'RECEIVER_ID',
                                                              description_                   => 'Reciever ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'CONDITION_CODE',
                                                              description_                   => 'Condition Code',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 10,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'ENG_CHG_LEVEL',
                                                              description_                   => 'Revision No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 6,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'WAIV_DEV_REJ_NO',
                                                              description_                   => 'W/D/R No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'ACTIVITY_SEQ',
                                                              description_                   => 'Activity Sequence',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'NEVER',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'INPUT_QTY_SCRAPPED',
                                                              description_                   => 'Input Qty to Scrap',
                                                              data_type_db_                  => 'NUMBER',                                                              
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',                                                              
                                                              config_data_item_order_        => config_data_item_order_);
   --- GTIN related ---

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'QTY_SCRAPPED',
                                                              description_                   => 'Qty to Scrap',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'CATCH_QTY_SCRAPPED',
                                                              description_                   => 'Catch Qty to Scrap',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'SCRAPPING_CAUSE',
                                                              description_                   => 'Scrapping Cause',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 =>  20,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_data_item_order_        => config_data_item_order_);
      
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'NOTE',
                                                              description_                   => 'Note',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 =>  2000,
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'BARCODE_ID',
                                                              description_                   => 'Barcode ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_PARTS_IN_SHIP_INV',
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


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaScrapPartInShipInv.sql','Timestamp_4');
PROMPT Inserting SCRAP_PARTS_IN_SHIP_INV process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'RECEIVER_DESCRIPTION',
                                                              description_        => 'Receiver Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'QTY_PICKED',
                                                              description_        => 'Picked Qty',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'CATCH_QTY',
                                                              description_        => 'Picked Catch Qty',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'PROJECT_ID',
                                                              description_        => 'Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS',
                                                              description_        => 'Catch UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'QUANTITY_ONHAND',
                                                              description_        => 'On Hand Qty',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'CATCH_QUANTITY_ONHAND',
                                                              description_        => 'On Hand Qty Catch Qty',
                                                              data_type_          => 'NUMBER');
          
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'PACKAGE_COMPONENT',
                                                              description_        => 'Package Component',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'QTY_SHIPPED',
                                                              description_        => 'Shipped Qty',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'CONDITION_CODE_DESCRIPTION',
                                                              description_        => 'Condition Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'OWNERSHIP',
                                                              description_        => 'Ownership',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'OWNER',
                                                              description_        => 'Owner',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'OWNING_CUSTOMER_NAME',
                                                              description_        => 'Owning Customer Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'AVAILABILTY_CONTROL_ID',
                                                              description_        => 'Availability Control ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'AVAILABILITY_CONTROL_DESCRIPTION',
                                                              description_        => 'Availability Control Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'ROUTE_ID',
                                                              description_        => 'Route Identity',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'ROUTE_DESCRIPTION',
                                                              description_        => 'Route Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'PROGRAM_ID',
                                                              description_        => 'Program ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'PROGRAM_DESCRIPTION',
                                                              description_        => 'Program Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'PROJECT_NAME',
                                                              description_        => 'Project Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'SUB_PROJECT_ID',
                                                              description_        => 'Sub Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'SUB_PROJECT_DESCRIPTION',
                                                              description_        => 'Sub Project Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'ACTIVITY_ID',
                                                              description_        => 'Activity ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'ACTIVITY_DESCRIPTION',
                                                              description_        => 'Activity Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'DEL_NOTE_NO',
                                                              description_        => 'Delivery Note No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'DEL_NOTE_STATUS',
                                                              description_        => 'Delivery Note Status',
                                                              data_type_          => 'STRING');

   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'GTIN_DEFAULT',
                                                              description_        => 'Default GTIN',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'INPUT_CONV_FACTOR',
                                                              description_        => 'Input Conversion Factor',
                                                              data_type_          => 'NUMBER');
   --- GTIN related ---

   ------------------------------------------------------------------------------------------------------------------
   -- Handling unit related feedback items --------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Handling Unit Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Handling Unit Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_SHIPMENT_ID',
                                                              description_        => 'Shipment ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_ACCESSORY_EXIST',
                                                              description_         => 'Accessory Exist',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'HANDLING_UNIT_COMPOSITION_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_LENGTH',
                                                              description_        => 'Uom For Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_NET_WEIGHT',
                                                              description_        => 'Net Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_        => 'Manual Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_        => 'Operative Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_WEIGHT',
                                                              description_        => 'Uom For Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_        => 'Manual Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_        => 'Operative Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_VOLUME',
                                                              description_        => 'UoM For Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_NO_OF_LBLS',
                                                              description_        => 'No of Handling Unit Labels',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED',
                                                              description_         => 'Mix of Part Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED',
                                                              description_         => 'Mix of Condition Code Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED',
                                                              description_         => 'Mix of Lot Batch Numbers Blocked',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');
        
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_PARTS_IN_SHIP_INV',
                                                              feedback_item_id_    => 'LOCATION_TYPE',
                                                              description_         => 'Location Type',
                                                              data_type_           => 'STRING');


END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaScrapPartInShipInv.sql','Timestamp_5');
PROMPT Inserting SCRAP_PARTS_IN_SHIP_INV process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'SCRAP_PARTS_IN_SHIP_INV',
                                                           capture_process_detail_id_ => 'BARCODE_ID_IS_MANDATORY',
                                                           description_               => 'Barcode ID is mandatory',
                                                           enabled_db_                => 'FALSE');
   
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'SCRAP_PARTS_IN_SHIP_INV',
                                                           capture_process_detail_id_ => 'GTIN_IS_MANDATORY',
                                                           description_               => 'GTIN is mandatory',
                                                           enabled_db_                => 'FALSE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'SCRAP_PARTS_IN_SHIP_INV',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');

END;
/
 
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaScrapPartInShipInv.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCaScrapPartInShipInv.sql
