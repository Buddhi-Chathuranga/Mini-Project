------------------------------------------------------------------------------
--
--  Filename      : POST_ORDER_DataCaptDelivConfirmCo.sql
--
--  Module        : ORDER
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process DELIVERY_CONFIRMATION.
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  -----------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171019  DaZase  STRSC-13009, Added GS1_BARCODE1 as a new data item.
--  150519  DaZase  COB-18, Added config_data_item_order_ param to all Install_Data_Item_All_Configs calls.
--  150730  RuLiLk  Bug 121975, Data type is sent when installing feedback items.
--  150115  DaZase  PRSC-5056, Replaced Install_Process_And_Config-call with Install_Process_And_All_Config and replaced all
--  150115          Install_Proc_Config_Data_Item-calls with Install_Data_Item_All_Configs.
--  141001  RiLase  PRSC-2782, Added process component.
--  140805  DaZase  PRSC-1431, Added string_length_ to all STRING calls to Install_Proc_Config_Data_Item.
--  140805          Changed data_type_ to data_type_db_ on all calls to Install_Proc_Config_Data_Item.
--  140315  MatKse  Created.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_DataCaptDelivConfirmCo.sql','Timestamp_1');
PROMPT Starting POST_ORDER_DataCaptDelivConfirmCo.sql

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_DataCaptDelivConfirmCo.sql','Timestamp_2');
PROMPT Inserting DELIVERY_CONFIRMATION process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_ => 'DELIVERY_CONFIRMATION',
                                                               description_        => 'Delivery Confirmation of Customer Order',
                                                               process_package_    => 'DATA_CAPT_DELIV_CONFIRM_CO_API',
                                                               process_component_  => 'ORDER',
                                                               config_menu_label_  => 'Delivery Confirmation');
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_DataCaptDelivConfirmCo.sql','Timestamp_3');
PROMPT Inserting DELIVERY_CONFIRMATION process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVERY_CONFIRMATION',
                                                              data_item_id_                  => 'DELNOTE_NO',
                                                              description_                   => 'Delivery Note No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVERY_CONFIRMATION',
                                                              data_item_id_                  => 'ORDER_NO',
                                                              description_                   => 'Order No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 12,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVERY_CONFIRMATION',
                                                              data_item_id_                  => 'SHIPMENT_ID',
                                                              description_                   => 'Shipment ID',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'TRUE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVERY_CONFIRMATION',
                                                              data_item_id_                  => 'SIGNATURE',
                                                              description_                   => 'Signature',
                                                              data_type_db_                  => 'SIGNATURE',
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'OFF',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVERY_CONFIRMATION',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_DataCaptDelivConfirmCo.sql','Timestamp_4');
PROMPT Inserting DELIVERY_CONFIRMATION process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'CUSTOMER_NO',
                                                              description_          => 'Customer',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'CUSTOMER_NAME',
                                                              description_          => 'Customer Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'WANTED_DELIVERY_DATE',
                                                              description_          => 'Wanted Delivery Date',
                                                              data_type_            => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_COORDINATOR',
                                                              description_          => 'Coordinator',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'SHIP_ADDR_NO',
                                                              description_          => 'Delivery Address',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'SHIP_ADDR_NAME',
                                                              description_          => 'Delivery Address Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'BILL_ADDR_NO',
                                                              description_          => 'Document Address',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                                feedback_item_id_   => 'BILL_ADDR_NAME',
                                                                description_        => 'Document Address Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_DELIVERY_TERMS',
                                                              description_          => 'Order Delivery Terms',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_SHIP_VIA_CODE',
                                                              description_          => 'Order Ship Via Code',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_PRIORITY',
                                                              description_          => 'Priority',
                                                              data_type_            => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_REFERENCE',
                                                              description_          => 'Reference',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_REFERENCE_NAME',
                                                              description_          => 'Reference Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_STATUS',
                                                              description_          => 'Order Status',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_TYPE',
                                                              description_          => 'Type',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'ORDER_TYPE_DESCRIPTION',
                                                              description_          => 'Type Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'DEL_NOTE_STATUS',
                                                              description_          => 'Delivery Note Status',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_ => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_   => 'DEL_NOTE_ACTUAL_SHIP_DATE',
                                                              description_        => 'Delivery Note Actual Ship Date',
                                                              data_type_          => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'DEL_NOTE_CREATE_DATE',
                                                              description_          => 'Delivery Note Create Date',
                                                              data_type_            => 'DATE');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'DEL_NOTE_FORWARDER_ID',
                                                              description_          => 'Delivery Note Forwarder ID',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'DEL_NOTE_DELIVERY_TERMS',
                                                              description_          => 'Delivery Note Delivery Terms',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVERY_CONFIRMATION',
                                                              feedback_item_id_     => 'DEL_NOTE_SHIP_VIA_CODE',
                                                              description_          => 'Delivery Note Ship Via Code',
                                                              data_type_            => 'STRING');

END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_DataCaptDelivConfirmCo.sql','Timestamp_5');
PROMPT Inserting DELIVERY_CONFIRMATION process to DATA_CAPTURE_PROCES_DETAIL
-- Add New Process/Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELIVERY_CONFIRMATION',
                                                           capture_process_detail_id_ => 'CONNECT_MEDIA_LU_CUSTOMER_ORDER',
                                                           description_               => 'Connect media to Customer Order Object in Media Library');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELIVERY_CONFIRMATION',
                                                           capture_process_detail_id_ => 'CONNECT_MEDIA_LU_CUSTOMER_ORDER_DELIV_NOTE',
                                                           description_               => 'Connect media to Customer Order Delivery Note Object in Media Library',
                                                           enabled_db_                => 'TRUE' );

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELIVERY_CONFIRMATION',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE'); 
END;
/
COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_ORDER_DataCaptDelivConfirmCo.sql','Done');
PROMPT Finished with POST_ORDER_DataCaptDelivConfirmCo.sql

