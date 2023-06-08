-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptureShpmntUtil
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220713  BWITLK  SC2020R1-11155, Modified Add_Details_For_Shipment mehtod to support SENDER_TYPE as a feedback item.
--  220614  DaZase  Added Add_Details_For_Ship_Location.
--  220426  Moinlk  SCDEV-7787, Added Get_Unique_Source_Ref_Type_Db as a utility function to get a unique source reference type.
--  170830  KhVese  STRSC-9595, Modified method Add_Details_For_Shipment.
--  170419  DaZase  LIM-10662, Added method Inventory_Barcode_Enabled.
--  161115  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() by adding serial_no as a parameter so that it will be used to decide on quantity when applicable.
--  160923  DaZase  LIM-8337, Moved Add_Del_Note_No/Add_Details_For_Del_Note_No and implementation methods from Data_Capture_Order_Util_API to here. 
--  160923          Moved code in Add_Del_Note_No to Add_Details_For_Del_Note_No and removed Add_Del_Note_No. 
--  160829  DaZase  LIM-8334, Added Fixed_Value_Is_Applicable.  
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160406  MaIklk  LIM-6627, Renamed Get_Name to Get_Receiver_Name of Shipment_Source_Utility_API.
--  160203  MaRalk  LIM-6114, Replaced Shipment_API.Get_Ship_Addr_No usages with Shipment_API.Get_Receiver_Addr_Id
--  160203          in Add_Details_For_Shipment method.
--- 151214  DaZase  LIM-2922, Moved Add_Details_For_Shipment from Data_Capture_Order_Util_API to here.
--  151214  DaZase  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Del_Note_Delivery_Terms___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   delnote_no_          IN VARCHAR2 )
IS
   delivery_terms_ VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      delivery_terms_ := Delivery_Note_API.Get_Delivery_Terms(delnote_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => delivery_terms_);
   $ELSE
      NULL;
   $END
END Add_Del_Note_Delivery_Terms___;

PROCEDURE Add_Del_Note_Create_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   delnote_no_          IN VARCHAR2 )
IS
   create_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      create_date_ := Delivery_Note_API.Get_Create_Date(delnote_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => create_date_);
   $ELSE
      NULL;
   $END
END Add_Del_Note_Create_Date___;


PROCEDURE Add_Del_Note_Ship_Via_Code___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   delnote_no_          IN VARCHAR2 )
IS
   ship_via_code_ VARCHAR2(3);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      ship_via_code_ := Delivery_Note_API.Get_Ship_Via_Code(delnote_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => ship_via_code_);
   $ELSE
      NULL;
   $END
END Add_Del_Note_Ship_Via_Code___;

PROCEDURE Add_Del_Note_Fwd_Agent_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   delnote_no_          IN VARCHAR2 )
IS
   forwarder_id_ VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      forwarder_id_ := Delivery_Note_API.Get_Forward_Agent_Id(delnote_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => forwarder_id_);
   $ELSE
      NULL;
   $END
END Add_Del_Note_Fwd_Agent_Id___;

PROCEDURE Add_Del_Note_Act_Ship_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   delnote_no_          IN VARCHAR2 )
IS
   actual_ship_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      actual_ship_date_ := Delivery_Note_API.Get_Actual_Ship_Date(delnote_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => actual_ship_date_);
   $ELSE
      NULL;
   $END
END Add_Del_Note_Act_Ship_Date___;

PROCEDURE Add_Del_Note_Status___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   delnote_no_          IN VARCHAR2 )
IS
   status_ VARCHAR2(4000);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      status_ := Delivery_Note_API.Get_Status(delnote_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => status_);
   $ELSE
      NULL;
   $END
END Add_Del_Note_Status___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Add_Details_For_Del_Note_No (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   delnote_no_           IN VARCHAR2 )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('DEL_NOTE_ACTUAL_SHIP_DATE') THEN 
            Add_Del_Note_Act_Ship_Date___(capture_session_id_  => capture_session_id_,
                                          owning_data_item_id_ => owning_data_item_id_,
                                          data_item_detail_id_ => data_item_detail_id_,   
                                          delnote_no_          => delnote_no_); 
         WHEN ('DEL_NOTE_CREATE_DATE') THEN 
            Add_Del_Note_Create_Date___(capture_session_id_  => capture_session_id_,
                                        owning_data_item_id_ => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,   
                                        delnote_no_          => delnote_no_);
         WHEN ('DEL_NOTE_DELIVERY_TERMS') THEN 
            Add_Del_Note_Delivery_Terms___(capture_session_id_  => capture_session_id_,
                                           owning_data_item_id_ => owning_data_item_id_,
                                           data_item_detail_id_ => data_item_detail_id_,   
                                           delnote_no_          => delnote_no_);
         WHEN ('DEL_NOTE_FORWARDER_ID') THEN 
            Add_Del_Note_Fwd_Agent_Id___(capture_session_id_  => capture_session_id_,
                                         owning_data_item_id_ => owning_data_item_id_,
                                         data_item_detail_id_ => data_item_detail_id_,   
                                         delnote_no_          => delnote_no_); 
         WHEN ('DEL_NOTE_STATUS') THEN 
            Add_Del_Note_Status___(capture_session_id_  => capture_session_id_,
                                   owning_data_item_id_ => owning_data_item_id_,
                                   data_item_detail_id_ => data_item_detail_id_,   
                                   delnote_no_          => delnote_no_);         
         WHEN ('DEL_NOTE_SHIP_VIA_CODE') THEN 
            Add_Del_Note_Ship_Via_Code___(capture_session_id_  => capture_session_id_, 
                                          owning_data_item_id_ => owning_data_item_id_,
                                          data_item_detail_id_ => data_item_detail_id_,   
                                          delnote_no_          => delnote_no_); 
         WHEN ('DEL_NOTE_NO') THEN
            Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                              data_item_id_        => owning_data_item_id_,
                                              data_item_detail_id_ => data_item_detail_id_,
                                              data_item_value_     => delnote_no_);
         ELSE 
            NULL;
      END CASE;
   $ELSE
      NULL;
   $END
END Add_Details_For_Del_Note_No;



-- TODO: Before end of project go thru all the replaced items and remove them here and replace them in the processes that still uses them
PROCEDURE Add_Details_For_Shipment(
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   shipment_id_          IN NUMBER )
IS
   feedback_item_value_   VARCHAR2(200);
BEGIN
$IF Component_Wadaco_SYS.INSTALLED $THEN
   CASE (data_item_detail_id_)
   WHEN ('DELIVER_TO_CUSTOMER_NO') THEN -- replaced with RECEIVER_ID
      feedback_item_value_ := Shipment_API.Get_Receiver_Id(shipment_id_);
   WHEN ('RECEIVER_ID') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Id(shipment_id_);
   WHEN ('DELIVER_TO_CUSTOMER_NAME') THEN    -- replaced with RECEIVER_DESCRIPTION
      feedback_item_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(Shipment_API.Get_Receiver_Id(shipment_id_), Shipment_API.Get_Receiver_Type_Db(shipment_id_));
   WHEN ('RECEIVER_DESCRIPTION') THEN 
      feedback_item_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(Shipment_API.Get_Receiver_Id(shipment_id_), Shipment_API.Get_Receiver_Type_Db(shipment_id_));
   WHEN ('CREATED_DATE') THEN
      feedback_item_value_ := Shipment_API.Get_Created_Date(shipment_id_);
   WHEN ('DELIVERY_TERMS') THEN
      feedback_item_value_ := Shipment_API.Get_Delivery_Terms(shipment_id_);
   WHEN ('DELIVERY_TERMS_DESC') THEN
      feedback_item_value_ := Order_Delivery_Term_API.Get_Description(Shipment_API.Get_Delivery_Terms(shipment_id_));
   WHEN ('SENDER_REFERENCE') THEN
      feedback_item_value_ := Shipment_API.Get_Sender_Reference(shipment_id_);
   WHEN ('SHIP_INVENTORY_LOCATION_NO') THEN
      feedback_item_value_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);
   WHEN ('CUSTOMER_COUNTRY') THEN  -- replaced with RECEIVER_COUNTRY
      feedback_item_value_ := Shipment_API.Get_Receiver_Country(shipment_id_);
   WHEN ('RECEIVER_COUNTRY') THEN  
      feedback_item_value_ := Shipment_API.Get_Receiver_Country(shipment_id_);
   WHEN ('SHIP_ADDR_NO') THEN  -- replaced with RECEIVER_ADDRESS_ID
      feedback_item_value_ := Shipment_API.Get_Receiver_Addr_Id(shipment_id_);
   WHEN ('RECEIVER_ADDRESS_ID') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Addr_Id(shipment_id_);
   WHEN ('SHIP_DATE') THEN
      feedback_item_value_ := Shipment_API.Get_Planned_Ship_Date(shipment_id_);
   WHEN ('CUSTOMER_REFERENCE') THEN  -- replaced with RECEIVER_REFERENCE
      feedback_item_value_ := Shipment_API.Get_Receiver_Reference(shipment_id_);
   WHEN ('RECEIVER_REFERENCE') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Reference(shipment_id_);
   WHEN ('ROUTE_ID') THEN
      feedback_item_value_ := Shipment_API.Get_Route_Id(shipment_id_);
   WHEN ('ROUTE_DESCRIPTION') THEN
      feedback_item_value_ := Delivery_Route_API.Get_Description(Shipment_API.Get_Route_Id(shipment_id_));
   WHEN ('LOAD_SEQUENCE_NO') THEN
      feedback_item_value_ := Shipment_API.Get_Load_Sequence_No(shipment_id_);
   WHEN ('SHIPMENT_TYPE') THEN
      feedback_item_value_ := Shipment_API.Get_Shipment_Type(shipment_id_);
   WHEN ('SHIPMENT_TYPE_DESC') THEN
      feedback_item_value_ := Shipment_Type_API.Get_Description(Shipment_API.Get_Shipment_Type(shipment_id_));
   WHEN ('CUSTOMER_ADDRESS_ID') THEN  -- replaced with RECEIVER_ADDRESS_ID
      feedback_item_value_ := Shipment_API.Get_Receiver_Addr_Id(shipment_id_);            
   WHEN ('SHIP_VIA_CODE') THEN
      feedback_item_value_ := Shipment_API.Get_Ship_Via_Code(shipment_id_);
   WHEN ('SHIP_VIA_DESC') THEN
      feedback_item_value_ := Mpccom_Ship_Via_API.Get_Description(Shipment_API.Get_Ship_Via_Code(shipment_id_));
   WHEN ('FORWARD_AGENT_ID') THEN
      feedback_item_value_ := Shipment_API.Get_Forward_Agent_Id(shipment_id_);
   WHEN ('FORWARD_AGENT_NAME') THEN
      feedback_item_value_ := Forwarder_Info_API.Get_Name(Shipment_API.Get_Forward_Agent_Id(shipment_id_));
   WHEN ('SHIPMENT_STATUS') THEN
      feedback_item_value_ := Shipment_API.Get_Objstate(shipment_id_);
   WHEN ('RECIEVER_TYPE') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Type_Db(shipment_id_);
   WHEN ('SENDER_TYPE') THEN
      feedback_item_value_ := Shipment_API.Get_Sender_Type_Db(shipment_id_);
   WHEN ('SOURCE_REF1') THEN
      feedback_item_value_ := Shipment_API.Get_Source_Ref1(shipment_id_);
   WHEN ('RECEIVER_ADDRESS_NAME') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Address_Name(shipment_id_);
   WHEN ('RECEIVER_ADDRESS1') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Address1(shipment_id_);
   WHEN ('RECEIVER_ADDRESS2') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Address2(shipment_id_);
   WHEN ('RECEIVER_ADDRESS3') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Address3(shipment_id_);
   WHEN ('RECEIVER_ADDRESS4') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Address4(shipment_id_);
   WHEN ('RECEIVER_ADDRESS5') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Address5(shipment_id_);
   WHEN ('RECEIVER_ADDRESS6') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Address6(shipment_id_);
   WHEN ('RECEIVER_COUNTRY') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_Country(shipment_id_);
   WHEN ('RECEIVER_CITY') THEN
      feedback_item_value_ := Shipment_API.Get_Receiver_City(shipment_id_);

   ELSE
      NULL;
   END CASE;
   Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                     data_item_id_        => owning_data_item_id_,
                                     data_item_detail_id_ => data_item_detail_id_,
                                     data_item_value_     => feedback_item_value_);
$ELSE
   NULL;                                     
$END
   
END Add_Details_For_Shipment;


PROCEDURE Add_Details_For_Ship_Location(
   capture_session_id_   IN   NUMBER,
   owning_data_item_id_  IN   VARCHAR2,
   data_item_detail_id_  IN   VARCHAR2,
   contract_             IN   VARCHAR2,
   shipment_id_          IN   NUMBER,
   ship_location_no_     IN   VARCHAR2)
IS
   feedback_item_value_   VARCHAR2(200);   
BEGIN
$IF Component_Wadaco_SYS.INSTALLED $THEN
   CASE (data_item_detail_id_)   
   WHEN ('SHIP_LOCATION_NO_DESC') THEN                                                                            
      feedback_item_value_ := Inventory_Location_API.Get_Location_Name(contract_,NVL(ship_location_no_, Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_)));   
   ELSE
      NULL;
   END CASE;
   Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                     data_item_id_        => owning_data_item_id_,
                                     data_item_detail_id_ => data_item_detail_id_,
                                     data_item_value_     => feedback_item_value_);
$ELSE
   NULL;                                     
$END   
END Add_Details_For_Ship_Location;



FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2,
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
IS
BEGIN
   RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, data_item_id_, part_no_, serial_no_);
END Fixed_Value_Is_Applicable;


FUNCTION Inventory_Barcode_Enabled (
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(capture_process_id_, capture_config_id_);
END Inventory_Barcode_Enabled;

FUNCTION Get_Unique_Source_Ref_Type_Db (
   shipment_id_ IN NUMBER) RETURN VARCHAR2
IS
   source_ref_types_db_       VARCHAR2(4000);
   source_ref_type_list_      Utility_SYS.STRING_TABLE;
   token_count_               NUMBER;
   return_value_              VARCHAR2(200) := NULL; 
BEGIN
   source_ref_types_db_ := Shipment_API.Get_Source_Ref_Type_Db(shipment_id_);
   Utility_SYS.Tokenize(source_ref_types_db_, '^', source_ref_type_list_, token_count_);
   IF (source_ref_type_list_.count = 1 ) THEN
      return_value_  := source_ref_type_list_(1);   
   END IF;
   -- only return a value when there is only 1 source ref type saved on shipment.
   RETURN return_value_;
END Get_Unique_Source_Ref_Type_Db;
