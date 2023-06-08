------------------------------------------------------------------------------
--
--  Filename      : POST_Shpmnt_DataCaptProcessShipment.sql
--
--  Module        : SHPMNT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process PROCESS_SHIPMENT .
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------
--  220714  BWITLK  SC2020R1-11164, Added SENDER_TYPE as a new filter data item in the process.
--  220622  MoinLk  SCDEV-11924, Increased the length of Receiver_ID variable to 50.
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171026  DaZase  STRSC-13035, Added GS1_BARCODE1, GS1_BARCODE2 as new data items.
--  171012  KHVESE  STRSC-12752, Removed data item SOURCE_REF_TYPE.
--  170926  KHVESE  STRSC-12224, Added Timestamp_5 and also data item PRO_NO.
--  170830  KhVese  STRSC-9595, Created.
------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptProcessShipment.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCaptProcessShipment.SQL

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptProcessShipment.sql','Timestamp_2');
PROMPT Inserting PROCESS_SHIPMENT process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_           => 'PROCESS_SHIPMENT',
                                                               description_                  => 'Process Shipment',
                                                               process_package_              => 'DATA_CAPT_PROCESS_SHIPMENT_API',
                                                               process_component_            => 'SHPMNT',
                                                               config_menu_label_            => 'Process Shipment',
                                                               process_camera_enabled_db_    => Fnd_Boolean_API.DB_TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptProcessShipment.sql','Timestamp_3');
PROMPT Inserting PROCESS_SHIPMENT process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'SHIPMENT_ID',
                                                              description_                   => 'Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'ACTION',
                                                              description_                   => 'Action',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'Shipment_Flow_Activities_API',
                                                              config_hide_line_db_           => 'NEVER',
                                                              config_list_of_values_db_      => 'FORCED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'SHIP_LOCATION_NO',
                                                              description_                   => 'Shipment Location No',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 35,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_ );
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'PARENT_CONSOL_SHIPMENT_ID',
                                                              description_                   => 'Consolidated Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'PRO_NO',
                                                              description_                   => 'PRO No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'SHIPMENT_TYPE',
                                                              description_                   => 'Shipment Type',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 3,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'SENDER_TYPE',
                                                              description_                   => 'Sender Type',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'SENDER_RECEIVER_TYPE_API',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'RECEIVER_ID',
                                                              description_                   => 'Receiver ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 50,
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'RECEIVER_ADDR_ID',
                                                              description_                   => 'Receiver Address ID',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 50,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'FORWARD_AGENT_ID',
                                                              description_                   => 'Forwarder',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 20,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'ROUTE_ID',
                                                              description_                   => 'Route ID',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 20,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'SHIP_VIA_CODE',
                                                              description_                   => 'Ship Via Code',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 3,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'STATE',
                                                              description_                   => 'Status',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'CONSIGNMENT_NOTE_ID',
                                                              description_                   => 'Consignment Note',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'DELNOTE_NO',
                                                              description_                   => 'Delivery Note',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'SHIPMENT_CATEGORY',
                                                              description_                   => 'Shipment Category',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'Shipment_Category_API',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
                                                              
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'FROM_DATE',
                                                              description_                   => 'Planned Ship Date From',
                                                              data_type_db_                  => 'DATE',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'TO_DATE',
                                                              description_                   => 'Planned Ship Date To',
                                                              data_type_db_                  => 'DATE',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PROCESS_SHIPMENT',
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


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptProcessShipment.sql','Timestamp_4');
PROMPT Inserting PROCESS_SHIPMENT process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'FORWARD_AGENT_NAME',
                                                              description_          => 'Forwarder Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'ROUTE_DESCRIPTION',
                                                              description_          => 'Route Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'SHIPMENT_TYPE_DESC',
                                                              description_          => 'Type Description',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'DELIVERY_TERMS',
                                                              description_          => 'Delivery Terms',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'DELIVERY_TERMS_DESC',
                                                              description_          => 'Delivery Terms Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'SHIP_VIA_DESC',
                                                              description_          => 'Ship Via Code Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'LOAD_SEQUENCE_NO',
                                                              description_          => 'Load Sequence No',
                                                              data_type_            => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'SOURCE_REF1',
                                                              description_          => 'Source Ref 1',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_DESCRIPTION',
                                                              description_          => 'Receiver Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_ADDRESS_NAME',
                                                              description_          => 'Receiver Address Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_ADDRESS1',
                                                              description_          => 'Receiver Address 1',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_ADDRESS2',
                                                              description_          => 'Receiver Address 2',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_ADDRESS3',
                                                              description_          => 'Receiver Address 3',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_ADDRESS4',
                                                              description_          => 'Receiver Address 4',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_ADDRESS5',
                                                              description_          => 'Receiver Address 5',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_ADDRESS6',
                                                              description_          => 'Receiver Address 6',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_COUNTRY',
                                                              description_          => 'Receiver Country',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'PROCESS_SHIPMENT',
                                                              feedback_item_id_     => 'RECEIVER_CITY',
                                                              description_          => 'Receiver City',
                                                              data_type_            => 'STRING');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptProcessShipment.sql','Timestamp_5');
PROMPT Inserting PROCESS_SHIPMENT base configuration to DATA_CAPTURE_PROCES_DETAIL and DATA_CAPTURE_CONFIG_DETAIL
-- Add New Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_SHIPMENT',
                                                           capture_process_detail_id_ => 'DISPLAY_RECEIVER_NAME',
                                                           description_               => 'Display Receiver Name in the List of Values for Shipment ID description field',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_SHIPMENT',
                                                           capture_process_detail_id_ => 'DISPLAY_RECEIVER_ADDRESS_NAME',
                                                           description_               => 'Display Receiver Address Name in the List of Values for Shipment ID description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PROCESS_SHIPMENT',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptProcessShipment.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCaptProcessShipment.SQL
