-----------------------------------------------------------------------------
--  Module : SHPMNT
--
--  File   : POST_Shpmnt_DataCapturePickHu.sql
--
--  IFS Developer Studio Template Version 2.6
--  
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process PICK_HU.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  220614   DaZase  SCDEV-611, Added PICK_BY_CHOICE_DETAILS as a new process detail flag.
--  220513   Moinlk  SCDEV-7787, Rename the process menu label and description.
--  201117   BudKLK  SC2020R1-11342, Changed configuration of the 'SOURCE_REF_TYPE'.
--  200902   BudKLK  SC2020R1-1103, Created 
--  ------   ------  --------------------------------------------------
----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCapturePickHu.SQL


-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Timestamp_2');
PROMPT Inserting PICK_HU process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'PICK_HU',
                                                               description_        => 'Pick Handling Units for Shipment',
                                                               process_package_    => 'DATA_CAPTURE_PICK_HU_API',
                                                               process_component_  => 'SHPMNT',
                                                               config_menu_label_  => 'Pick Handling Units for Shipment');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Timestamp_3');
PROMPT Inserting PICK_HU process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
--   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
--                                                              data_item_id_                  => 'WAREHOUSE_TASK_ID',
--                                                              description_                   => 'Warehouse Task ID',
--                                                              data_type_db_                  => 'NUMBER',
--                                                              process_key_db_                => 'FALSE',
--                                                              config_list_of_values_db_      => 'OFF',
--                                                              config_use_fixed_value_db_     => 'ALWAYS',
--                                                              config_hide_line_db_           => 'ALWAYS',
--                                                              config_use_subseq_value_db_    => 'FIXED',
--                                                              config_subseq_data_item_id_    => 'WAREHOUSE_TASK_ID',
--                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'PICK_LIST_NO',
                                                              description_                   => 'Pick List No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_subseq_data_item_id_    => 'PICK_LIST_NO',
                                                              config_use_subseq_value_db_    => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'AGGREGATED_LINE_ID',
                                                              description_                   => 'Aggregated Line ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              config_hide_line_db_           => 'ALWAYS',                                                              
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_list_of_values_db_      => 'AUTO_PICK',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'SOURCE_REF_TYPE',
                                                              description_                   => 'Source Ref Type',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 =>  200,
                                                              enumeration_package_           => 'LOGISTICS_SOURCE_REF_TYPE_API',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'RES_HANDLING_UNIT_ID',
                                                              description_                   => 'Handling Unit ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'LOCATION_NO',
                                                              description_                   => 'Location No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_use_automatic_value_db_ => 'FIXED',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'ACTION',
                                                              description_                   => 'Action',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 200,
                                                              enumeration_package_           => 'PICK_HANDL_UNIT_ACTION_API',
                                                              config_default_value_          => 'PICK',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'SHIP_LOCATION_NO',
                                                              description_                   => 'Shipment Location No',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 35,
                                                              process_key_db_                => 'FALSE',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'OFF',
                                                              config_hide_line_db_           => 'WHEN_FIXED_VALUE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_data_item_order_        => config_data_item_order_ );

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
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

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
                                                              data_item_id_                  => 'GS1_BARCODE2',
                                                              description_                   => 'GS1 Barcode 2',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'PICK_HU',
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


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Timestamp_4');
PROMPT Inserting PICK_HU process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit Location related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_WAREHOUSE_ID',
                                                              description_        => 'Warehouse ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_BAY_ID',
                                                              description_        => 'Bay ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TIER_ID',
                                                              description_        => 'Tier ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_ROW_ID',
                                                              description_        => 'Row ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_BIN_ID',
                                                              description_        => 'Bin ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_LOCATION_TYPE',
                                                              description_        => 'Location Type',
                                                              data_type_          => 'STRING',
                                                              enumeration_package_=> 'INVENTORY_LOCATION_TYPE_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_HANDLING_UNIT_LOCATION_NO_DESC',
                                                              description_         => 'Location No Description',
                                                              data_type_           => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit related feedback items --------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_HANDLING_UNIT_COMPOSITION',
                                                              description_         => 'Composition',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'HANDLING_UNIT_COMPOSITION_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_STRUCTURE_LEVEL',
                                                              description_        => 'Structure Level',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Top Parent ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_TOP_PARENT_SSCC',
                                                              description_         => 'Top Parent SSCC',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_         => 'Top Parent Alt Label ID',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_LEVEL_2_HANDLING_UNIT_ID',
                                                              description_        => 'Level 2 Handling Unit ID',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_LEVEL_2_SSCC',
                                                              description_        => 'Level 2 SSCC',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID',
                                                              description_        => 'Level 2 Alt Label ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_HANDLING_UNIT_DEPTH',
                                                              description_         => 'Depth',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_NET_WEIGHT',
                                                              description_        => 'Net Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                              description_         => 'Operative Gross Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_OPERATIVE_VOLUME',
                                                              description_        => 'Operative Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_HANDLING_UNIT_TARE_WEIGHT',
                                                              description_         => 'Tare Weight',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_HANDLING_UNIT_UOM_LENGTH',
                                                              description_         => 'Uom For Length',
                                                              data_type_           => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_UOM_WEIGHT',
                                                              description_        => 'Uom For Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_UOM_VOLUME',
                                                              description_        => 'UoM For Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   ------------------------------------------------------------------------------------------------------------------
   -- Handling Unit Type related feedback items ---------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Top Parent Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                              description_         => 'Top Parent Type Desc',
                                                              data_type_           => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'RES_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Shipment Handling unit related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHIP_LOCATION_NO_DESC',
                                                              description_        => 'Shipment Location No Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_ID',
                                                              description_        => 'Parent Handling Unit ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_PARENT_HANDLING_UNIT_DESC',
                                                              description_        => 'Parent Handling Unit Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_DEPTH',
                                                              description_        => 'Depth',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_WIDTH',
                                                              description_        => 'Width',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_HEIGHT',
                                                              description_        => 'Height',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                              description_        => 'Manual Gross Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_MANUAL_VOLUME',
                                                              description_        => 'Manual Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                              description_         => 'Additive Volume',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_UOM_LENGTH',
                                                              description_        => 'UoM Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                              description_        => 'Category ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                              description_        => 'Category Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_ID',
                                                              description_        => 'Handling Unit Type ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_DESC',
                                                              description_        => 'Handling Unit Type Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC',
                                                              description_         => 'Generate SSCC',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                              description_        => 'Max Volume Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                              description_        => 'Max Weight Capacity',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_STACKABLE',
                                                              description_         => 'Stackable',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL',
                                                              description_         => 'Print Handling Unit Label',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'FND_BOOLEAN_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS',
                                                              description_        => 'No of Handling Unit Labels',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_VOLUME',
                                                              description_        => 'Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                              description_        => 'UoM Volume',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT',
                                                              description_        => 'UoM Weight',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_UOM_LENGTH',
                                                              description_        => 'UoM Length',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT',
                                                              description_        => 'Tare Weight',
                                                              data_type_          => 'NUMBER');

   ------------------------------------------------------------------------------------------------------------------
   -- Inventory Part In Stock related feedback items ----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'ACTIVITY_SEQ',
                                                              description_        => 'Activity Sequence',
                                                              data_type_          => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'AVAILABILITY_CONTROL_ID',
                                                              description_        => 'Availability Control ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'AVAILABILITY_CONTROL_DESCRIPTION',
                                                              description_        => 'Availability Control Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'CONDITION_CODE',
                                                              description_        => 'Condition Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'CONDITION_CODE_DESCRIPTION',
                                                              description_        => 'Condition Code Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'CONFIGURATION_ID',
                                                              description_        => 'Configuration ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'ENG_CHG_LEVEL',
                                                              description_        => 'Revision No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'LOT_BATCH_NO',
                                                              description_        => 'Lot/Batch No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_  => 'PICK_HU',
                                                              feedback_item_id_    => 'OWNERSHIP',
                                                              description_         => 'Part Ownership',
                                                              data_type_           => 'STRING',
                                                              enumeration_package_ => 'PART_OWNERSHIP_API');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'OWNER',
                                                              description_        => 'Owner',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'OWNER_NAME',
                                                              description_        => 'Owner Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'PART_NO',
                                                              description_        => 'Part No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'PART_DESCRIPTION',
                                                              description_        => 'Part Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SERIAL_NO',
                                                              description_        => 'Serial No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'WAIV_DEV_REJ_NO',
                                                              description_        => 'W/D/R No',
                                                              data_type_          => 'STRING');

   ------------------------------------------------------------------------------------------------------------------
   -- Project (Activity Seq) related feedback items -----------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'PROJECT_ID',
                                                              description_        => 'Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'PROJECT_NAME',
                                                              description_        => 'Project Name',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SUB_PROJECT_ID',
                                                              description_        => 'Sub Project ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'SUB_PROJECT_DESCRIPTION',
                                                              description_        => 'Sub Project Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'ACTIVITY_ID',
                                                              description_        => 'Activity ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'ACTIVITY_DESCRIPTION',
                                                              description_        => 'Activity Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'PROGRAM_ID',
                                                              description_        => 'Program ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'PICK_HU',
                                                              feedback_item_id_   => 'PROGRAM_DESCRIPTION',
                                                              description_        => 'Program Description',
                                                              data_type_          => 'STRING');


   ------------------------------------------------------------------------------------------------------------------
   -- Various -------------------------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_       => 'PICK_HU',
                                                              feedback_item_id_         => 'LAST_LINE_ON_PICK_LIST',
                                                              description_              => 'Last Line on Pick List',
                                                              data_type_                => 'STRING',
                                                              enumeration_package_      => 'GEN_YES_NO_API',
                                                              feedback_item_value_view_ => 'GEN_YES_NO',
                                                              feedback_item_value_pkg_  => 'GEN_YES_NO_API');


END;
/


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Timestamp_5');
PROMPT ADD CONFIG CTRL ITEM TO PICK_HU process
BEGIN
   Data_Capture_Common_Util_API.Install_Config_Ctrl_Item(capture_process_id_           => 'PICK_HU',
                                                         config_ctrl_feedback_item_id_ => 'LAST_LINE_ON_PICK_LIST');
END;
/



exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Timestamp_6');
PROMPT Inserting PICK_HU base configuration to DATA_CAPTURE_PROCES_DETAIL and DATA_CAPTURE_CONFIG_DETAIL
-- Add New Configuration Details
BEGIN

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PICK_HU',
                                                           capture_process_detail_id_ => 'DISPLAY_HANDLING_UNIT_ID',
                                                           description_               => 'Display Handling Unit ID in the List of Values for Aggregated Line ID description field',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PICK_HU',
                                                           capture_process_detail_id_ => 'DISPLAY_SSCC',
                                                           description_               => 'Display SSCC in the List of Values for Aggregated Line ID description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PICK_HU',
                                                           capture_process_detail_id_ => 'DISPLAY_ALT_HANDLING_UNIT_LABEL_ID',
                                                           description_               => 'Display Alt Handling Unit Label ID in the List of Values for Aggregated Line ID description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PICK_HU',
                                                           capture_process_detail_id_ => 'MAX_WEIGHT_VOLUME_ERROR',
                                                           description_               => 'Error when Max Weight/Volume is exceeded.',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PICK_HU',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'PICK_HU',
                                                           capture_process_detail_id_ => 'PICK_BY_CHOICE_DETAILS',
                                                           description_               => 'Refined fetching of details for performance improvement when using pick by choice.',
                                                           enabled_db_                => 'FALSE'); 
                                                           
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Timestamp_7');
PROMPT Connecting feedback items to base (config_id =1) PICK_HU process
-- Connect feedback items to data items
BEGIN
   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PICK_HU',
                                                            data_item_id_        => 'AGGREGATED_LINE_ID',
                                                            data_item_detail_id_ => 'RES_HANDLING_UNIT_ID',
                                                            item_type_db_        => 'DATA');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PICK_HU',
                                                            data_item_id_        => 'AGGREGATED_LINE_ID',
                                                            data_item_detail_id_ => 'RES_HANDLING_UNIT_LOCATION_NO_DESC',
                                                            item_type_db_        => 'FEEDBACK');

   Data_Capture_Common_Util_API.Connect_Detail_To_Data_Item(capture_process_id_  => 'PICK_HU',
                                                            data_item_id_        => 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                            data_item_detail_id_ => 'LAST_LINE_ON_PICK_LIST',
                                                            item_type_db_        => 'FEEDBACK');
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCapturePickHu.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCapturePickHu.sql


