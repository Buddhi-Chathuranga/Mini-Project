------------------------------------------------------------------------------
--
--  Filename      : POST_Shpmnt_DataCapScrapHuInShipInv.sql
--
--  Module        : SHPMNT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process SCRAP_HU_IN_SHIP_INV .
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  171208  CKumlk  STRSC-14940, Renamed description and menu label.
--  171206  CKumlk  STRSC-15074, Removed feedback items TO_LOCATION_NO_DESC, TO_LOCATION_TYPE and renamed a data item and two feedback items. 
--  171106  SURBLK  STRSC-13905, Created.
------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapScrapHuInShipInv.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCapScrapHuInShipInv.SQL

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapScrapHuInShipInv.sql','Timestamp_2');
PROMPT Inserting SCRAP_HU_IN_SHIP_INV process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'SCRAP_HU_IN_SHIP_INV',
                                                               description_        => 'Scrap Handling Units in Shipment Inventory',
                                                               process_package_    => 'DATA_CAP_PROCESS_HU_SHIP_API',
                                                               process_component_  => 'SHPMNT',
                                                               config_menu_label_  => 'Scrap HU in Ship Inventory');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapScrapHuInShipInv.sql','Timestamp_3');
PROMPT Inserting SCRAP_HU_IN_SHIP_INV process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
                                                              data_item_id_                  => 'HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_); 
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
                                                              data_item_id_                  => 'SSCC',
                                                              description_                   => 'SSCC',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 18,
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
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
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
                                                              data_item_id_                  => 'SCRAPPING_CAUSE',
                                                              description_                   => 'Scrapping Cause',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 20,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_data_item_order_        => config_data_item_order_);
      
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
                                                              data_item_id_                  => 'NOTE',
                                                              description_                   => 'Note',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 2000,
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'SCRAP_HU_IN_SHIP_INV',
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

------------------------------------------------------------------------------------------------------------------
-- Feedback Items -------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapScrapHuInShipInv.sql','Timestamp_4');
PROMPT Inserting MOVE_PART process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items

BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SHIPMENT_ID',
                                                              description_         => 'Shipment ID',
                                                              data_type_           => 'NUMBER');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SOURCE_REF_TYPE',
                                                              description_         => 'Source Ref Type',
                                                              data_type_           => 'STRING');    
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SOURCE_REF1',
                                                              description_         => 'Source Ref 1',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SOURCE_REF2',
                                                              description_         => 'Source Ref 2',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SOURCE_REF3',
                                                              description_         => 'Source Ref 3',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SOURCE_REF4',
                                                              description_         => 'Source Ref 4',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_ID',
                                                              description_         => 'Handling Unit Type ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_TYPE_DESCRIPTION',
                                                              description_         => 'Handling Unit Type Description',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_CATEGORY_ID',
                                                              description_         => 'Handling Unit Category ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_CATEGORY_DESCRIPTION',
                                                              description_         => 'Handling Unit Category Description',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'PARENT_HANDLING_UNIT_ID',
                                                              description_         => 'Parent Handling Unit ID',
                                                              data_type_           => 'NUMBER');
   
    Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_         => 'Top Parent Handling Unit ID',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_         => 'Top Parent Type Description',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Description',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');
    
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_STRUCTURE_LEVEL',
                                                              description_         => 'Structure Level',
                                                              data_type_           => 'NUMBER');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING');
    
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'WAREHOUSE_ID',
                                                              description_         => 'Warehouse ID',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'BAY_ID',
                                                              description_         => 'Bay ID',
                                                              data_type_           => 'STRING');
  
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'ROW_ID',
                                                              description_         => 'Row ID',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'TIER_ID',
                                                              description_         => 'Tier ID',
                                                              data_type_           => 'STRING');
    
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'BIN_ID',
                                                              description_         => 'Bin ID',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'LOCATION_TYPE',
                                                              description_         => 'Location Type',
                                                              data_type_           => 'STRING');
  
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SHIPMENT_LINE_NO',
                                                              description_         => 'Shipment Line No',
                                                              data_type_           => 'NUMBER');   
         
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'PART_NO',
                                                              description_         => 'Part No',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'PART_DESCRIPTION',
                                                              description_         => 'Part Description',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SOURCE_PART_NO',
                                                              description_         => 'Source Part No',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SOURCE_PART_DESCRIPTION',
                                                              description_         => 'Source Part Description',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'SERIAL_NO',
                                                              description_         => 'Serial No',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'LOT_BATCH_NO',
                                                              description_         => 'Lot/Batch No',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'CONFIGURATION_ID',
                                                              description_         => 'Configuration ID',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'ENG_CHG_LEVEL',
                                                              description_         => 'Revision No',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'WAIV_DEV_REJ_NO',
                                                              description_         => 'W/D/R No',
                                                              data_type_           => 'STRING');
     
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'CONDITION_CODE',
                                                              description_         => 'Condition Code',
                                                              data_type_           => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'ACTIVITY_SEQ',
                                                              description_         => 'Activity Sequence',
                                                              data_type_           => 'NUMBER');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'SCRAP_HU_IN_SHIP_INV',
                                                              feedback_item_id_    => 'QTY_PICKED',
                                                              description_         => 'Quantity Picked',
                                                              data_type_           => 'NUMBER');
   
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapScrapHuInShipInv.sql','Timestamp_5');
PROMPT Inserting SCRAP_HU_IN_SHIP_INV process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'SCRAP_HU_IN_SHIP_INV',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

END;
/

COMMIT;
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapScrapHuInShipInv.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCapScrapHuInShipInv.sql
