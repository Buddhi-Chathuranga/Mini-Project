-------------------------------------------------------------------------------
--
--  Filename      : POST_Shpmnt_DataCapPackIntoHuShip.sql
--
--  Module        : SHPMNT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process MODIFY_HANDLING_UNIT_ON_SHIPMENT.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------
--  220713  BWITLK  SC2020R1-11155, Added SENDER_TYPE as a feedback item.
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  171206  MaAuse  STRSC-15087, Added MAX_WEIGHT_VOLUME_ERROR as a new detail item.
--  171025  DaZase  STRSC-13032, Added GS1_BARCODE1, GS1_BARCODE2 and GS1_BARCODE3 as new data items.
--  170925  SWiclk  STRSC-11282, Added GTIN, INPUT_UOM and INPUT_QUANTITY data items and INPUT_CONV_FACTOR as feedback item and GTIN_NO_IS_MANDATORY as detail item.
--  170413  KhVese  LIM-11416, Changed data item orders and put part_no as third data item to reduce the number of recursive call to Fixed_Value_Is_Applicable.
--  160829  DaZase  LIM-8334, Moved process to SHPMNT component and renamed some of the items and added a couple of new items and removed a duplicate item.
--  160219  SWiclk  Bug 127172, Added new process detail BARCODE_ID_IS_MANDATORY.
--  160209  DaZase  LIM-6226, Renamed feedback item SHIP_ADDR_NO to RECEIVER_ADDRESS_ID.
--  151028  Erlise  LIM-3778, Added a rename section. Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID.
--  150918  DaZase  AFT-5484, Added data_type to all new feedback items.
--  150907  JeLise  AFT-3702, Changed Sales Part No to Part No for data item PART_NO.
--  150901  DaZase  AFT-2992, Added BARCODE_ID as a new data item.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150413  RILSAE  Created.
------------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCapPackIntoHuShip.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_2');
PROMPT Inserting PACK_INTO_HANDLING_UNIT_SHIP process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               description_        => 'Pack into Handling Unit on Shipment',
                                                               process_package_    => 'DATA_CAP_PACK_INTO_HU_SHIP_API',
                                                               process_component_  => 'SHPMNT',
                                                               config_menu_label_  => 'Pack into Handling Unit on Shipment');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_3');
PROMPT Renaming data items
-- Rename Configuration Data Items, these are placed before install since they will change datatype/length during install and
-- doing a rename afterwards will add the old values back which we dont want for these items.
BEGIN
   -- These 4 items were added in Apps9 and renamed in Apps10
   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'ORDER_NO',
                                                            new_data_item_id_                => 'SOURCE_REF1',
                                                            new_data_item_desc_              => 'Source Ref 1');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'LINE_NO',
                                                            new_data_item_id_                => 'SOURCE_REF2',
                                                            new_data_item_desc_              => 'Source Ref 2');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'REL_NO',
                                                            new_data_item_id_                => 'SOURCE_REF3',
                                                            new_data_item_desc_              => 'Source Ref 3');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'LINE_ITEM_NO',
                                                            new_data_item_id_                => 'SOURCE_REF4',
                                                            new_data_item_desc_              => 'Source Ref 4');
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_4');
PROMPT Inserting PACK_INTO_HANDLING_UNIT_SHIP process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SHIPMENT_ID',
                                                              description_                   => 'Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'PICK_LIST_NO',
                                                              description_                   => 'Pick List No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'PART_NO',
                                                              description_                   => 'Part No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'PARENT_CONSOL_SHIPMENT_ID',
                                                              description_                   => 'Consolidated Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SOURCE_REF1',
                                                              description_                   => 'Source Ref 1',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SOURCE_REF2',
                                                              description_                   => 'Source Ref 2',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SOURCE_REF3',
                                                              description_                   => 'Source Ref 3',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SOURCE_REF4',
                                                              description_                   => 'Source Ref 4',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 50,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'WAIV_DEV_REJ_NO',
                                                              description_                   => 'W/D/R No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'ENG_CHG_LEVEL',
                                                              description_                   => 'Revision No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 6,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'ACTIVITY_SEQ',
                                                              description_                   => 'Activity Sequence',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'RES_HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);


   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'RES_SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'RES_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'INPUT_UOM',
                                                              description_                   => 'Input Unit of Measure',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 30,
                                                              process_key_db_                => 'FALSE',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'INPUT_QUANTITY',
                                                              description_                   => 'Input Quantity',
                                                              data_type_db_                  => 'NUMBER',                                                              
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);
   --- GTIN related ---

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'QTY_TO_ATTACH',
                                                              description_                   => 'Qty to Attach',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              process_default_fixed_value_   => '1',
                                                              config_fixed_value_            => '1',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'CATCH_QTY_TO_ATTACH',
                                                              description_                   => 'Catch Qty to Attach',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SHP_HANDLING_UNIT_ID',
                                                              description_                   => 'Shipment Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SHP_SSCC',
                                                              description_                   => 'Shipment SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Shipment Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'BARCODE_ID',
                                                              description_                   => 'Barcode ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PACK_INTO_HANDLING_UNIT_SHIP',
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

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_5');
PROMPT Renaming data items
-- Rename Configuration Data Items
BEGIN
   -- These 3 items were added in Apps9 and renamed in Apps10
   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'ALT_TRANSPORT_LABEL_ID',
                                                            new_data_item_id_                => 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                            new_data_item_desc_              => 'Shipment Alt Handling Unit Label ID');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'HANDLING_UNIT_ID',
                                                            new_data_item_id_                => 'SHP_HANDLING_UNIT_ID',
                                                            new_data_item_desc_              => 'Shipment Handling Unit ID');

   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'SSCC',
                                                            new_data_item_id_                => 'SHP_SSCC',
                                                            new_data_item_desc_              => 'Shipment SSCC');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_6');
PROMPT Inserting PACK_INTO_HANDLING_UNIT_SHIP process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_DESC',
                                                              description_        => 'Parent Handling Unit Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_VOLUME',
                                                              description_        => 'Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                              description_        => 'UoM Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_        => 'Manual Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_        => 'Manual Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                              description_        => 'UoM Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_LENGTH',
                                                              description_        => 'UoM Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS',
                                                              description_        => 'No of Handling Unit Labels',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_DESCRIPTION',
                                                              description_        => 'Receiver Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'CREATED_DATE',
                                                              description_        => 'Date Created',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'DELIVERY_TERMS',
                                                              description_        => 'Delivery Terms',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SENDER_REFERENCE',
                                                              description_        => 'Sender Reference',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIP_INVENTORY_LOCATION_NO',
                                                              description_        => 'Shipment Location No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_COUNTRY',
                                                              description_        => 'Reciever Country',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIP_DATE',
                                                              description_        => 'Planned Ship Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_REFERENCE',
                                                              description_        => 'Reciever Reference',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'ROUTE_ID',
                                                              description_        => 'Route Identity',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'LOAD_SEQUENCE_NO',
                                                              description_        => 'Load Sequence No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_ADDRESS_ID',
                                                              description_        => 'Receiver Address ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SALES_QUANTITY_TO_ATTACH',
                                                              description_        => 'Sales Quantity to Attach',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'INV_QUANTITY_TO_ATTACH',
                                                              description_        => 'Inv Quantity To Attach',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'INV_QUANTITY_ATTACHED',
                                                              description_        => 'Inv Quantity Attached',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'REMAINING_PARCEL_QTY',
                                                              description_        => 'Remaining Parcel Qty',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'QTY_RESERVED',
                                                              description_        => 'Qty Reserved',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'WAREHOUSE_ID',
                                                              description_        => 'Warehouse',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'BAY_ID',
                                                              description_        => 'Bay',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'ROW_ID',
                                                              description_        => 'Row',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'TIER_ID',
                                                              description_        => 'Tier',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'BIN_ID',
                                                              description_        => 'Bin',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'CATCH_UNIT_MEAS',
                                                              description_        => 'Catch UoM',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_ID',
                                                              description_        => 'Reciever ID',
                                                              data_type_          => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'FORWARD_AGENT_ID',
                                                              description_        => 'Forwarder',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIP_VIA_CODE',
                                                              description_        => 'Ship Via Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIPMENT_TYPE',
                                                              description_        => 'Shipment Type',
                                                              data_type_          => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'SENDER_TYPE',
                                                              description_         => 'Sender Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'SENDER_RECEIVER_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'RECIEVER_TYPE',
                                                              description_         => 'Reciever Type',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'SENDER_RECEIVER_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_SSCC',
                                                              description_        => 'Top Parent SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Top Parent Alt Label ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Top Parent Type Desc',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RES_LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');   
   --- GTIN related ---
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'GTIN_DEFAULT',
                                                              description_        => 'Default GTIN',
                                                              data_type_          => 'STRING');   

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'GTIN_IDENTIFICATION',
                                                              description_         => 'GTIN Used for Identification',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');
     
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'INPUT_CONV_FACTOR',
                                                              description_        => 'Input Conversion Factor',
                                                              data_type_          => 'NUMBER');
   --- GTIN related ---



END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_7');
PROMPT Renaming feedback items
-- Rename Configuration Feedback Items
BEGIN
   -- These 28 feedbacks were added in Apps9 and renamed in Apps10
   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'SHIP_ADDR_NO',
                                                               new_feedback_item_id_   => 'RECEIVER_ADDRESS_ID',
                                                               new_data_item_desc_     => 'Receiver Address ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'CUSTOMER_COUNTRY',
                                                               new_feedback_item_id_   => 'RECEIVER_COUNTRY',
                                                               new_data_item_desc_     => 'Receiver Country');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'CUSTOMER_REFERENCE',
                                                               new_feedback_item_id_   => 'RECEIVER_REFERENCE',
                                                               new_data_item_desc_     => 'Receiver Reference');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'DELIVER_TO_CUSTOMER_NAME',
                                                               new_feedback_item_id_   => 'RECEIVER_DESCRIPTION',
                                                               new_data_item_desc_     => 'Receiver Description');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'DELIVER_TO_CUSTOMER_NO',
                                                               new_feedback_item_id_   => 'RECEIVER_ID',
                                                               new_data_item_desc_     => 'Receiver ID');

   -- Feedback items that have not change description, only the id since we need to indicate more clearly if they come from Shipment HU or Inventory/Reservation HU
   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'PARENT_HANDLING_UNIT_ID',
                                                               new_feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'PARENT_HANDLING_UNIT_DESC',
                                                               new_feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_DESC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_DESC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_DESC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_WIDTH',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_WIDTH');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_HEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_HEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_DEPTH',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_DEPTH');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_TARE_WEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'MANUAL_GROSS_WEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'MANUAL_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_UOM_LENGTH',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_LENGTH');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_STACKABLE');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_GEN_SSCC',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_PRINT_LBL',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'HANDLING_UNIT_TYPE_NO_OF_LBLS',
                                                               new_feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS');




END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_8');
PROMPT Removing feedback items
-- Removing Configuration Feedback Items
BEGIN
   -- This feedback was added in Apps9 and removed in Apps10
   Data_Capture_Common_Util_API.Uninstall_Feedback_All_Config(capture_process_id_  =>  'PACK_INTO_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    =>  'CUSTOMER_ADDRESS_ID');

END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Timestamp_9');
PROMPT Inserting PACK_INTO_HANDLING_UNIT_SHIP process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                           capture_process_detail_id_ => 'BARCODE_ID_IS_MANDATORY',
                                                           description_               => 'Barcode ID is mandatory',
                                                           enabled_db_                => 'FALSE');
   
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                           capture_process_detail_id_ => 'GTIN_IS_MANDATORY',
                                                           description_               => 'GTIN is mandatory',
                                                           enabled_db_                => 'FALSE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                           capture_process_detail_id_ => 'MAX_WEIGHT_VOLUME_ERROR',
                                                           description_               => 'Error when Max Weight/Volume is exceeded.',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PACK_INTO_HANDLING_UNIT_SHIP',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapPackIntoHuShip.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCapPackIntoHuShip.sql
