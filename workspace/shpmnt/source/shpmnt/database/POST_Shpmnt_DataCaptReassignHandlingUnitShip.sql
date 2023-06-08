-------------------------------------------------------------------------------
--
--  Filename      : POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql
--
--  Module        : SHPMNT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process REASSIGN_HANDLING_UNIT_SHIP.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220701  BWITLK  SC2020R1-11173, Added RECEIVER_TYPE, RECEIVER_ID as new data items.
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171026  DaZase  STRSC-13041, Added GS1_BARCODE1, GS1_BARCODE2 as new data items.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160901  DaZase  LIM-8335, Moved process to SHPMNT component and renamed some feedback items and added a new feedback item and removed a duplicate item.
--  160209  DaZase  LIM-6226, Renamed feedback item SHIP_ADDR_NO to RECEIVER_ADDRESS_ID.
--  151028  Erlise  LIM-3777, Added a rename section. Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID.
--  150917  DaZase  AFT-5484, Added data_type to all feedback items.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150316  RILSAE  Created.
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_2');
PROMPT Inserting REASSIGN_HANDLING_UNIT_SHIP process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                               description_        => 'Reassign Handling Unit on Shipment',
                                                               process_package_    => 'DATA_CAPT_REASS_HU_SHIP_API',
                                                               process_component_  => 'SHPMNT',
                                                               config_menu_label_  => 'Reassign Handling Unit on Shipment');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_3');
PROMPT Inserting REASSIGN_HANDLING_UNIT_SHIP process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'RECEIVER_ID',
                                                              description_                   => 'Receiver ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 20,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'RECEIVER_TYPE',
                                                              description_                   => 'Receiver Type',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'SENDER_RECEIVER_TYPE_API',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);


   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'FROM_SHIPMENT_ID',
                                                              description_                   => 'From Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'PARENT_CONSOL_SHIPMENT_ID',
                                                              description_                   => 'Consolidated Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'TO_SHIPMENT_ID',
                                                              description_                   => 'To Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'TO_NEW_SHIPMENT_ID',
                                                              description_                   => 'To New Shipment ID',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 3,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'RELEASE_RESERVATIONS',
                                                              description_                   => 'Release Reservations',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 3,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'DEFAULT',
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REASSIGN_HANDLING_UNIT_SHIP',
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

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_4');
PROMPT Renaming data items
-- Rename Configuration Data Items
BEGIN
   -- This item was added in Apps9 and renamed in Apps10
   Data_Capture_Common_Util_API.Rename_Data_Item_All_Config(capture_process_id_              => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                            old_data_item_id_                => 'ALT_TRANSPORT_LABEL_ID',
                                                            new_data_item_id_                => 'ALT_HANDLING_UNIT_LABEL_ID',
                                                            new_data_item_desc_              => 'Alt Handling Unit Label ID');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_5');
PROMPT Inserting REASSIGN_HANDLING_UNIT_SHIP process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'PARENT_HANDLING_UNIT_DESC',
                                                              description_        => 'Parent Handling Unit Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_VOLUME',
                                                              description_        => 'Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                              description_        => 'UoM Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'MANUAL_GROSS_WEIGHT',
                                                              description_        => 'Manual Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'MANUAL_VOLUME',
                                                              description_        => 'Manual Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                              description_        => 'UoM Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_UOM_LENGTH',
                                                              description_        => 'UoM Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_        => 'Stackable',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_GEN_SSCC',
                                                              description_        => 'Generate SSCC',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_PRINT_LBL',
                                                              description_        => 'Print Handling Unit Label',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TYPE_NO_OF_LBLS',
                                                              description_        => 'No of Handling Unit Labels',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_DESCRIPTION',
                                                              description_        => 'Receiver Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'CREATED_DATE',
                                                              description_        => 'Date Created',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'DELIVERY_TERMS',
                                                              description_        => 'Delivery Terms',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SENDER_REFERENCE',
                                                              description_        => 'Sender Reference',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIP_INVENTORY_LOCATION_NO',
                                                              description_        => 'Shipment Location No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_COUNTRY',
                                                              description_        => 'Receiver Country',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIP_DATE',
                                                              description_        => 'Planned Ship Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_REFERENCE',
                                                              description_        => 'Receiver Reference',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'ROUTE_ID',
                                                              description_        => 'Route Identity',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'LOAD_SEQUENCE_NO',
                                                              description_        => 'Load Sequence No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'RECEIVER_ADDRESS_ID',
                                                              description_        => 'Receiver Address ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'FORWARD_AGENT_ID',
                                                              description_        => 'Forwarder',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIP_VIA_CODE',
                                                              description_        => 'Ship Via Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_   => 'SHIPMENT_TYPE',
                                                              description_        => 'Shipment Type',
                                                              data_type_          => 'STRING');


END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_6');
PROMPT Renaming data items
-- Rename Configuration Feedback Items
BEGIN
   -- These 5 feedbacks were added in Apps9 and renamed in Apps10
   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'SHIP_ADDR_NO',
                                                               new_feedback_item_id_   => 'RECEIVER_ADDRESS_ID',
                                                               new_data_item_desc_     => 'Receiver Address ID');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'CUSTOMER_COUNTRY',
                                                               new_feedback_item_id_   => 'RECEIVER_COUNTRY',
                                                               new_data_item_desc_     => 'Receiver Country');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'CUSTOMER_REFERENCE',
                                                               new_feedback_item_id_   => 'RECEIVER_REFERENCE',
                                                               new_data_item_desc_     => 'Receiver Reference');

   Data_Capture_Common_Util_API.Rename_Feedbac_Item_All_Config(capture_process_id_     => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                               old_feedback_item_id_   => 'DELIVER_TO_CUSTOMER_NAME',
                                                               new_feedback_item_id_   => 'RECEIVER_DESCRIPTION',
                                                               new_data_item_desc_     => 'Receiver Description');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_7');
PROMPT Removing feedback items
-- Removing Configuration Feedback Items
BEGIN
   -- This feedback was added in Apps9 and removed in Apps10
   Data_Capture_Common_Util_API.Uninstall_Feedback_All_Config(capture_process_id_  =>  'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    =>  'CUSTOMER_ADDRESS_ID');
   
   Data_Capture_Common_Util_API.Uninstall_Feedback_All_Config(capture_process_id_  =>  'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    =>  'RECEIVER_ID');
   
   Data_Capture_Common_Util_API.Uninstall_Feedback_All_Config(capture_process_id_  =>  'REASSIGN_HANDLING_UNIT_SHIP',
                                                              feedback_item_id_    =>  'RECEIVER_TYPE');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Timestamp_8');
PROMPT Inserting REASSIGN_HANDLING_UNIT_SHIP process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REASSIGN_HANDLING_UNIT_SHIP',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCaptReassignHandlingUnitShip.sql
