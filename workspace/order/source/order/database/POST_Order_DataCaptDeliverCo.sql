------------------------------------------------------------------------------
--
--  Filename      : POST_Order_DataCaptDeliverCo.sql
--
--  Module        : ORDER
--
--  Purpose       : Inserting data into DataCaptureProcess and
--                  DataCaptureConfig tables for process DELIVER_CUSTOMER_ORDER .
--
--  Important Note: This script needs to be added to [PostInstallationData] section
--                  in deploy.ini for this component.
--
--  Localization  : Not needed.
--
--  Date    Sign    History
--  ------  ------  ----------------------------------------------------------
--  180216  RuLiLk  STRSC-16860, Added new detail item GS1_BARCODE_IS_MANDATORY.
--  171019  DaZase  STRSC-13011, Added GS1_BARCODE1, GS1_BARCODE2 as a new data items.
--  170927  KHVESE  STRSC-12224, Added Timestamp_5.
--  170718  KhVese  STRSC-8846, Created.
------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptDeliverCo.sql','Timestamp_1');
PROMPT Starting POST_Order_DataCaptDeliverCo.SQL

-----------------------------------------------------------------------------
--    Add Basic Data for DataCaptureProcess and child tables
-----------------------------------------------------------------------------

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptDeliverCo.sql','Timestamp_2');
PROMPT Inserting DELIVER_CUSTOMER_ORDER process to DataCaptureProcess and DataCaptureConfig
-- Add New Process
BEGIN
   Data_Capture_Common_Util_API.Install_Process_And_All_Config(capture_process_id_           => 'DELIVER_CUSTOMER_ORDER',
                                                               description_                  => 'Deliver Customer Order',
                                                               process_package_              => 'DATA_CAPT_DELIVER_CO_API',
                                                               process_component_            => 'ORDER',
                                                               config_menu_label_            => 'Deliver Customer Order',
                                                               process_camera_enabled_db_    => Fnd_Boolean_API.DB_TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptDeliverCo.sql','Timestamp_3');
PROMPT Inserting DELIVER_CUSTOMER_ORDER process to DATA_CAPT_PROC_DATA_ITEM_TAB and DATA_CAPT_CONF_DATA_ITEM_TAB
-- Add New Process and Configuration Data Items
DECLARE
   config_data_item_order_ NUMBER := 1;
BEGIN
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'ORDER_NO',
                                                              description_                   => 'Order No',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'TRUE',
                                                              string_length_                 => 12,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'CUSTOMER_NO',
                                                              description_                   => 'Customer',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'PRIORITY',
                                                              description_                   => 'Priority',
                                                              data_type_db_                  => 'NUMBER',
                                                              process_key_db_                => 'FALSE',
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'FORWARD_AGENT_ID',
                                                              description_                   => 'Forwarder',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 15,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'ROUTE_ID',
                                                              description_                   => 'Route ID',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'WANTED_DELIVERY_DATE',
                                                              description_                   => 'Wanted Delivery Date',
                                                              data_type_db_                  => 'DATE',
                                                              process_key_db_                => 'FALSE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'ORDER_TYPE',
                                                              description_                   => 'Order Type',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);
   
   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'COORDINATOR',
                                                              description_                   => 'Coordinator',
                                                              data_type_db_                  => 'STRING',
                                                              process_key_db_                => 'FALSE',
                                                              string_length_                 => 35,
                                                              config_list_of_values_db_      => 'ON',
                                                              process_list_of_val_supported_ => 'TRUE',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
                                                              data_item_id_                  => 'GS1_BARCODE1',
                                                              description_                   => 'GS1 Barcode 1',
                                                              data_type_db_                  => 'GS1',
                                                              process_key_db_                => 'FALSE',
                                                              uppercase_db_                  => 'FALSE',
                                                              string_length_                 => 4000,
                                                              config_use_fixed_value_db_     => 'ALWAYS',
                                                              config_hide_line_db_           => 'ALWAYS',
                                                              config_data_item_order_        => config_data_item_order_);

   Data_Capture_Common_Util_API.Install_Data_Item_All_Configs(capture_process_id_            => 'DELIVER_CUSTOMER_ORDER',
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


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptDeliverCo.sql','Timestamp_4');
PROMPT Inserting DELIVER_CUSTOMER_ORDER process to DATA_CAPT_PROC_FEEDBA_ITEM
-- Add New Process Feedback Items
BEGIN
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'CUSTOMER_NAME',
                                                              description_          => 'Customer Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'ORDER_STATUS',
                                                              description_          => 'Status',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'FORWARD_AGENT_NAME',
                                                              description_          => 'Forwarder Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'ROUTE_DESCRIPTION',
                                                              description_          => 'Route Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'ORDER_TYPE_DESCRIPTION',
                                                              description_          => 'Type Description',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'SALESMAN_CODE',
                                                              description_          => 'Salesperson',
                                                              data_type_            => 'NUMBER');
                                                              
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'SALESMAN_NAME',
                                                              description_          => 'Salesperson Name',
                                                              data_type_            => 'NUMBER');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'ERLIEST_PLANNED_SHIP_DATE',
                                                              description_          => 'Erliest Planned Ship Date',
                                                              data_type_            => 'DATE');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'DELIVERY_TERMS',
                                                              description_          => 'Delivery Terms',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'DELIVERY_TERMS_DESC',
                                                              description_          => 'Delivery Terms Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'SHIP_VIA_CODE',
                                                              description_          => 'Ship Via Code',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'SHIP_VIA_CODE_DESC',
                                                              description_          => 'Ship Via Code Description',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'ORDER_REFERENCE',
                                                              description_          => 'Reference',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'ORDER_REFERENCE_NAME',
                                                              description_          => 'Reference Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'SHIP_ADDR_NO',
                                                              description_          => 'Delivery Address',
                                                              data_type_            => 'STRING');
   
   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'SHIP_ADDR_NAME',
                                                              description_          => 'Delivery Address Name',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'BILL_ADDR_NO',
                                                              description_          => 'Document Address',
                                                              data_type_            => 'STRING');

   Data_Capture_Common_Util_API.Install_Process_Feedback_Item(capture_process_id_   => 'DELIVER_CUSTOMER_ORDER',
                                                              feedback_item_id_     => 'BILL_ADDR_NAME',
                                                              description_          => 'Document Address Name',
                                                              data_type_            => 'STRING');
   
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptDeliverCo.sql','Timestamp_5');
PROMPT Inserting DELIVER_CUSTOMER_ORDER base configuration to DATA_CAPTURE_PROCES_DETAIL and DATA_CAPTURE_CONFIG_DETAIL
-- Add New Configuration Details
BEGIN
   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELIVER_CUSTOMER_ORDER',
                                                           capture_process_detail_id_ => 'DISPLAY_CUSTOMER_NAME',
                                                           description_               => 'Display Customer Name in the List of Values for Order No description field',
                                                           enabled_db_                => 'TRUE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELIVER_CUSTOMER_ORDER',
                                                           capture_process_detail_id_ => 'DISPLAY_RECEIVER_ADDRESS_NAME',
                                                           description_               => 'Display Receiver Address Name in the List of Values for Order No description field');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELIVER_CUSTOMER_ORDER',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');

   Data_Capture_Common_Util_API.Install_Detail_All_Configs(capture_process_id_        => 'DELIVER_CUSTOMER_ORDER',
                                                           capture_process_detail_id_ => 'GS1_BARCODE_IS_MANDATORY',
                                                           description_               => 'GS1 barcode is mandatory',
                                                           enabled_db_                => 'FALSE');
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_DataCaptDeliverCo.sql','Done');
PROMPT Finished with POST_Order_DataCaptDeliverCo.sql
