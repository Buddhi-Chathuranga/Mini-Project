
-------------------------------------------------------------------------------
--
--  Filename      : POST_Shpmnt_DataCaptModifyHndlUnit.sql
--
--  Module        : SHPMNT
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process MODIFY_HANDLING_UNIT.
--                  NOTE: The main part this process is inserted from
--                  POST_Invent_DataCaptModifyHndlUnit script.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Basic Data Translations: Note if you add or change any item here, in the current solution
--                  the basic data translation changes will end upp in INVENT since this process
--                  belongs to that component, so you have to generate an updated lng file from INVENT
--                  for these items.
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180125  DaZase  STRSC-15903, Changed config_data_item_order_ from 18 to 21 for the last 2 data items since new ones 
--  180125          have been added by POST_Invent_DataCaptModifyHndlUnit script.
--  171213  SWiclk  STRSC-15143, Set on-screen keyboard to ON for qty related data items and note/message data items.
--  161102  DaZase  LIM-7326, Added data items PRINT_SHIPMENT_LABEL and NO_OF_SHIPMENT_LABELS.
--  151216  DaZase  LIM-4571 Created/Copied from POST_ORDER_DataCaptModifyHandlingUnit.sql.
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptModifyHndlUnit.sql','Timestamp_1');
PROMPT Starting POST_Shpmnt_DataCaptModifyHndlUnit.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------


exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptModifyHndlUnit.sql','Timestamp_2');
PROMPT Inserting MODIFY_HANDLING_UNIT process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MODIFY_HANDLING_UNIT',
                                                              data_item_id_                  => 'SHIPMENT_ID',
                                                              description_                   => 'Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MODIFY_HANDLING_UNIT',
                                                              data_item_id_                  => 'PARENT_CONSOL_SHIPMENT_ID',
                                                              description_                   => 'Consolidated Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_use_fixed_value_db_     => 'WHEN_APPLICABLE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              process_fix_val_applic_supp_   => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   config_data_item_order_ := 21; -- NOTE: we want these 2 items in the end of the configuration, this value might have to be changed if more invent data items are added in the future

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MODIFY_HANDLING_UNIT',
                                                              data_item_id_                  => 'PRINT_SHIPMENT_LABEL',
                                                              description_                   => 'Print Shipment Handling Unit Label',
                                                              data_type_db_                  => 'STRING',
                                                              string_length_                 => 20,
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              config_use_automatic_value_db_ => 'DEFAULT',
                                                              enumeration_package_           => 'GEN_YES_NO_API',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'MODIFY_HANDLING_UNIT',
                                                              data_item_id_                  => 'NO_OF_SHIPMENT_LABELS',
                                                              description_                   => 'No of Shipment Handling Unit Labels',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_use_automatic_value_db_ => 'DEFAULT',
                                                              onscreen_keyboard_enabled_db_  => 'ON',
                                                              config_data_item_order_        => config_data_item_order_);


END;
/

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptModifyHndlUnit.sql','Timestamp_3');
PROMPT Inserting MODIFY_HANDLING_UNIT process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN

   ------------------------------------------------------------------------------------------------------------------
   -- Shipment related feedback items --------------------------------------------------------------------------
   ------------------------------------------------------------------------------------------------------------------

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'CREATED_DATE',
                                                              description_        => 'Date Created',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'RECEIVER_ADDRESS_ID',
                                                              description_        => 'Receiver Address ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'RECEIVER_COUNTRY',
                                                              description_        => 'Receiver Country',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'RECEIVER_REFERENCE',
                                                              description_        => 'Receiver Reference',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'DELIVERY_TERMS',
                                                              description_        => 'Delivery Terms',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'RECEIVER_DESCRIPTION',
                                                              description_        => 'Receiver Description',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'RECEIVER_ID',
                                                              description_        => 'Receiver ID',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'FORWARD_AGENT_ID',
                                                              description_        => 'Forwarder',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'LOAD_SEQUENCE_NO',
                                                              description_        => 'Load Sequence No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'ROUTE_ID',
                                                              description_        => 'Route Identity',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SENDER_REFERENCE',
                                                              description_        => 'Sender Reference',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SHIPMENT_TYPE',
                                                              description_        => 'Shipment Type',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SHIP_DATE',
                                                              description_        => 'Planned Ship Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SHIP_INVENTORY_LOCATION_NO',
                                                              description_        => 'Shipment Location No',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SHIP_VIA_CODE',
                                                              description_        => 'Ship Via Code',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SHIPMENT_STATUS',
                                                              description_        => 'Shipment Status',
                                                              data_type_          => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'MODIFY_HANDLING_UNIT',
                                                              feedback_item_id_   => 'SHIP_VIA_DESC',
                                                              description_        => 'Ship Via Description',
                                                              data_type_          => 'STRING');

END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('SHPMNT','POST_Shpmnt_DataCaptModifyHndlUnit.sql','Done');
PROMPT Finished with POST_Shpmnt_DataCaptModifyHndlUnit.sql
