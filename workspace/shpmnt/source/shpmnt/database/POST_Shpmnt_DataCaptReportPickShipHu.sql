-------------------------------------------------------------------------------
--
--  Filename      : POST_Shpmnt_DataCaptReportPickShipHu.sql
--
--  Module        : SHPMNT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process REPORT_PICK_SHIPMENT_HU.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--  
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  210708   moinlk  SC21R2-1825, Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCaptReportPickShipHu.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_2');
PROMPT Inserting REPORT_PICK_SHIPMENT_HU process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                               description_        => 'Report Picking of Shipment Handling Units',
                                                               process_package_    => 'DATA_CAPT_REP_PICK_SHIP_HU_API',
                                                               process_component_  => 'SHPMNT',
                                                               config_menu_label_  => 'Report Picking of Shipment HU');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_3');
PROMPT Inserting REPORT_PICK_SHIPMENT_HU process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'SHIPMENT_ID',
                                                              description_                   => 'Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_hide_line_db_           => 'NEVER',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'PICK_LIST_NO',
                                                              description_                   => 'Pick List No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'NEVER',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'SHP_HANDLING_UNIT_ID',
                                                              description_                   => 'Shipment Handling Unit ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 14,
                                                              config_list_of_values_db_      => 'ON',                                                              
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_use_fixed_value_db_     => 'NEVER',                                                              
                                                              config_hide_line_db_           => 'NEVER',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'SHIP_LOCATION_NO',
                                                              description_                   => 'Shipment Inventory Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'NEVER',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'SHP_SSCC',
                                                              description_                   => 'Shipment SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 25,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
      
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_                   => 'Shipment Alt Handling Unit Label ID',
                                                              data_type_db_                  => 'STRING',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 25,
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'REPORT_PICK_SHIPMENT_HU',
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

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_4');
PROMPT Inserting REPORT_PICK_SHIPMENT_HU process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_      => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_        => 'SHP_HANDLING_UNIT_TYPE_ID',
                                                              description_             => 'Handling Unit Type ID',
                                                              data_type_               => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'SHP_HANDLING_UNIT_TYPE_DESC',
                                                              description_              => 'Handling Unit Type Description',
                                                              data_type_                => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_              => 'Handling Unit Type Category ID',
                                                              data_type_                => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'SHP_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_              => 'Handling Unit Type Category Description',
                                                              data_type_                => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                              description_              => 'Handling Unit Type UoM Volume',
                                                              data_type_                => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                              description_              => 'Handling Unit Type UoM Weight',
                                                              data_type_                => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_              => 'Handling Unit Operative Gross Weight',
                                                              data_type_                => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_              => 'Handling Unit Operative Gross Volume',
                                                              data_type_                => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_         => 'SHIP_LOCATION_NO_DESC',
                                                              description_              => 'Ship Location No Description',
                                                              data_type_                => 'STRING');
   
   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit Location related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_   => 'HANDLING_UNIT_LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_    => 'HANDLING_UNIT_LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_5');
PROMPT Inserting REPORT_PICK_SHIPMENT_HU process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'REPORT_PICK_SHIPMENT_HU',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_6');
PROMPT ADD CONFIG CTRL ITEM TO REPORT_PICKING_HU process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_       => 'REPORT_PICK_SHIPMENT_HU',
                                                         config_ctrl_data_item_id_ => 'SHIPMENT_ID');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_7');
PROMPT Connecting feedback items to base (config_id =1) REPORT_PICK_SHIPMENT_HU process
-- Connect feedback items to data items
BEGIN
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'REPORT_PICK_SHIPMENT_HU',
                                                            data_item_id_        => 'SHP_HANDLING_UNIT_ID',
                                                            data_item_detail_id_ => 'SHP_HANDLING_UNIT_TYPE_DESC',
                                                            item_type_db_        => 'FEEDBACK');
   
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'REPORT_PICK_SHIPMENT_HU',
                                                            data_item_id_        => 'SHP_HANDLING_UNIT_ID',
                                                            data_item_detail_id_ => 'SHP_HANDLING_UNIT_TYPE_ID',
                                                            item_type_db_        => 'FEEDBACK');
   
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'REPORT_PICK_SHIPMENT_HU',
                                                            data_item_id_        => 'SHP_HANDLING_UNIT_ID',
                                                            data_item_detail_id_ => 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                            item_type_db_        => 'FEEDBACK');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Timestamp_8');
PROMPT Connecting feedback items to base (config_id =1) REPORT_PICK_SHIPMENT_HU process
-- Remove feedback item
BEGIN
   Data_Capture_Common_Util_API.Uninstall_Feedback_All_Config(capture_process_id_ => 'REPORT_PICK_SHIPMENT_HU',
                                                              feedback_item_id_   => 'LOCATION_NO_DESC');
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptReportPickShipHu.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCaptReportPickShipHu.sql

