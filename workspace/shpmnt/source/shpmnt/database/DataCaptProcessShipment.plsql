-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptProcessShipment
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: PROCESS_SHIPMENT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220815  BWITLK  SCDEV-13134, Modified Create_List_Of_Values() to change the data source for the SENDER_TYPE dataitem when filtering the values from LOV.
--  220714  BWITLK  SC2020R1-11164, Added SENDER_TYPE as a new filter data item in the process.
--  210301  BudKlk  SC2020R1-10437, Modified Execute_Process() to change Preliminary to Undo Complete.
--  201105  DaZase  Bug 156393 (SCZ-12164), Removed route_id_ from calls to Shipment_Delivery_Utility_API.Create_Data_Capture_Lov and Shipment_Delivery_Utility_API.Record_With_Column_Value_Exist
--  200903  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  191115  MeAblk  SCSPRING20-934, Increased the length of receiver_id upto 50 characters.
--  190927  DaZase  SCSPRING20-165, Added Raise_Act_Not_Allowed_Error___ and Raise_Approval_Needed_Error___ to solve MessageDefinitionValidation issues.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171117  KHVESE  STRSC-14096, Added method Get_Delnote_Sql_Where_Expression___ to be used in delnote_no LOV.
--  171026  DaZase  STRSC-13035, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171026          of anything found later in that method. Added Add_Unique_Data_Item_Detail___.
--  171012  KHVESE  STRSC-12752, Removed data item SOURCE_REF_TYPE from all methods.
--  170926  KHVESE  STRSC-12224, Added implementation for new data items PRO_NO and PARENT_CONSOL_SHIPMENT_ID.
--  170830  KhVese  STRSC-9595, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER := -1;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Filter_Keys___ (
   contract_               OUT VARCHAR2,
   shipment_id_            OUT NUMBER,
   parent_consol_ship_id_  OUT NUMBER,
   shipment_category_      OUT VARCHAR2,
   shipment_type_          OUT VARCHAR2,
   sender_type_            OUT VARCHAR2,
   receiver_type_          OUT VARCHAR2,
   receiver_id_            OUT VARCHAR2,
   receiver_addr_id_       OUT VARCHAR2,  
   pro_no_                 OUT VARCHAR2,
   forward_agent_id_       OUT VARCHAR2,
   route_id_               OUT VARCHAR2,
   ship_via_code_          OUT VARCHAR2,  
   consignment_note_id_    OUT VARCHAR2,  
   delnote_no_             OUT VARCHAR2,  
   status_                 OUT VARCHAR2,  
   to_date_                OUT DATE,  
   from_date_              OUT DATE,  
   action_                 OUT VARCHAR2,
   capture_session_id_     IN  NUMBER,
   data_item_id_           IN  VARCHAR2,
   data_item_value_        IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_      IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_         IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   process_package_        VARCHAR2(30);
   from_date_str_          VARCHAR2(100);
   to_date_str_            VARCHAR2(100);
   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_        := session_rec_.session_contract;
      -- First try and fetch "predicted" filter keys 
      shipment_id_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_); 
      parent_consol_ship_id_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_CONSOL_SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      action_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTION', session_rec_ , process_package_, use_applicable_);
      shipment_category_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_CATEGORY', session_rec_ , process_package_, use_applicable_);
      shipment_type_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_TYPE', session_rec_ , process_package_, use_applicable_);
      sender_type_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SENDER_TYPE', session_rec_ , process_package_, use_applicable_);
      receiver_type_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_TYPE', session_rec_ , process_package_, use_applicable_);
      receiver_id_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_ID', session_rec_ , process_package_, use_applicable_);
      pro_no_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PRO_NO', session_rec_ , process_package_, use_applicable_);
      forward_agent_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FORWARD_AGENT_ID', session_rec_ , process_package_, use_applicable_);
      route_id_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ROUTE_ID', session_rec_ , process_package_, use_applicable_);
      ship_via_code_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIP_VIA_CODE', session_rec_ , process_package_, use_applicable_);
      from_date_str_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_DATE', session_rec_ , process_package_, use_applicable_);
      to_date_str_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_DATE', session_rec_ , process_package_, use_applicable_);
      status_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'STATE', session_rec_ , process_package_, use_applicable_);
      consignment_note_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONSIGNMENT_NOTE_ID', session_rec_ , process_package_, use_applicable_);
      delnote_no_             := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'DELNOTE_NO', session_rec_ , process_package_, use_applicable_);
      receiver_addr_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_ADDR_ID', session_rec_ , process_package_, use_applicable_);

      from_date_  := Client_SYS.Attr_Value_To_Date(from_date_str_);
      to_date_    := Client_SYS.Attr_Value_To_Date(to_date_str_);

      IF (parent_consol_ship_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_CONSOL_SHIPMENT_ID', data_item_id_)) THEN
         parent_consol_ship_id_ := number_all_values_;
      END IF;

      -- if shipment_type_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all shipment_type and null shipment_type in the table
      IF (shipment_type_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_TYPE', data_item_id_)) THEN
         shipment_type_ := string_all_values_;
      END IF;
      
      -- if sender_type_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all sender_type_ and null sender_type_ in the table
      IF (sender_type_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SENDER_TYPE', data_item_id_)) THEN
         sender_type_ := string_all_values_;
      END IF;

      -- if receiver_type_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all receiver_type and null receiver_type in the table
      IF (receiver_type_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_TYPE', data_item_id_)) THEN
         receiver_type_ := string_all_values_;
      END IF;

      -- if receiver_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all receiver_id and null receiver_id in the table
      IF (receiver_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_ID', data_item_id_)) THEN
         receiver_id_ := string_all_values_;
      END IF;

      -- if receiver_addr_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all receiver_addr_id and null receiver_addr_id in the table
      IF (receiver_addr_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_ADDR_ID', data_item_id_)) THEN
         receiver_addr_id_ := string_all_values_;
      END IF;

      IF (pro_no_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PRO_NO', data_item_id_)) THEN
         pro_no_ := string_all_values_;
      END IF;
      
      -- if forward_agent_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all forward_agent_id and null forward_agent_id in the table
      IF (forward_agent_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'FORWARD_AGENT_ID', data_item_id_)) THEN
         forward_agent_id_ := string_all_values_;
      END IF;

      -- if route_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all route_id and null route_id in the table
      IF (route_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ROUTE_ID', data_item_id_)) THEN
         route_id_ := string_all_values_;
      END IF;

      -- if ship_via_code_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all ship_via_code and null ship_via_code in the table
      IF (ship_via_code_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIP_VIA_CODE', data_item_id_)) THEN
         ship_via_code_ := string_all_values_;
      END IF;


      -- if consignment_note_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all consignment_note_id and null consignment_note_id in the table
      IF (consignment_note_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'CONSIGNMENT_NOTE_ID', data_item_id_)) THEN
         consignment_note_id_ := string_all_values_;
      END IF;

     
      IF use_unique_values_ THEN
         -- If some keys still are NULL then try and fetch those with unique handling instead
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_consol_ship_id_, shipment_category_, shipment_type_, sender_type_, receiver_type_, receiver_id_, receiver_addr_id_,   
                                                          pro_no_, forward_agent_id_, route_id_, ship_via_code_, consignment_note_id_, delnote_no_, status_, from_date_, to_date_, action_, 'SHIPMENT_ID');
         END IF;
      END IF;

   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   shipment_id_            IN NUMBER,
   parent_consol_ship_id_  IN NUMBER,
   shipment_category_      IN VARCHAR2,
   shipment_type_          IN VARCHAR2,
   sender_type_            IN VARCHAR2,
   receiver_type_          IN VARCHAR2,
   receiver_id_            IN VARCHAR2,
   receiver_addr_id_       IN VARCHAR2,  
   pro_no_                 IN VARCHAR2,
   forward_agent_id_       IN VARCHAR2,
   route_id_               IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,  
   consignment_note_id_    IN VARCHAR2,  
   delnote_no_             IN VARCHAR2,  
   status_                 IN VARCHAR2,  
   to_date_                IN DATE,  
   from_date_              IN DATE,  
   action_                 IN VARCHAR2)  
IS
   detail_value_             VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('SHIPMENT_ID') THEN
            detail_value_ := shipment_id_;
         WHEN ('SHIPMENT_CATEGORY') THEN
            detail_value_ := shipment_category_;
         WHEN ('ACTION') THEN
            detail_value_ := action_;
         WHEN ('SHIPMENT_TYPE') THEN
            detail_value_ := shipment_type_;
         WHEN ('PARENT_CONSOL_SHIPMENT_ID') THEN
            detail_value_ := parent_consol_ship_id_;
         WHEN ('RECEIVER_ID') THEN
            detail_value_ := receiver_id_;
         WHEN ('SENDER_TYPE') THEN
            detail_value_ := sender_type_;
         WHEN ('RECEIVER_TYPE') THEN
            detail_value_ := receiver_type_;
         WHEN ('RECEIVER_ADDR_ID') THEN
            detail_value_ := receiver_addr_id_;
         WHEN ('PRO_NO') THEN
            detail_value_ := pro_no_;
         WHEN ('FORWARD_AGENT_ID') THEN
            detail_value_ := forward_agent_id_;
         WHEN ('ROUTE_ID') THEN
            detail_value_ := route_id_;
         WHEN ('SHIP_VIA_CODE') THEN
            detail_value_ := ship_via_code_;
         WHEN ('STATE') THEN
            detail_value_ := status_;
         WHEN ('CONSIGNMENT_NOTE_ID') THEN
            detail_value_ := consignment_note_id_;
         WHEN ('DELNOTE_NO') THEN
            detail_value_ := delnote_no_;
         WHEN ('FROM_DATE') THEN
            detail_value_ := to_char(from_date_,Client_SYS.date_format_);
         WHEN ('TO_DATE') THEN
            detail_value_ := to_char(to_date_,Client_SYS.date_format_);
         ELSE
            NULL;
      END CASE;

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Filter_Key_Detail___;


PROCEDURE Add_Unique_Data_Item_Detail___ (
   capture_session_id_         IN NUMBER,
   session_rec_                IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_        IN VARCHAR2,
   owning_data_item_value_     IN VARCHAR2,
   data_item_detail_id_        IN VARCHAR2 )  
IS
   detail_value_    VARCHAR2(4000);
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      -- All non filter key data items, try and fetch their predicted value
      detail_value_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                              current_data_item_id_    => owning_data_item_id_,
                                                                              current_data_item_value_ => owning_data_item_value_,
                                                                              wanted_data_item_id_     => data_item_detail_id_,
                                                                              session_rec_             => session_rec_,
                                                                              process_package_         => process_package_);

      -- Non filter key data items that could be fetched by unique handling
      -- Add any such items here, at the moment none exist so code is commented
      /*IF (detail_value_ IS NULL AND data_item_detail_id_ IN ()) THEN
         detail_value_ := Get_Unique_Data_Item_Value___();
      END IF;*/

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


FUNCTION Get_Unique_Data_Item_Value___ (
   contract_               IN VARCHAR2,
   shipment_id_            IN NUMBER,
   parent_consol_ship_id_  IN NUMBER,
   shipment_category_      IN VARCHAR2,
   shipment_type_          IN VARCHAR2,
   sender_type_            IN VARCHAR2,
   receiver_type_          IN VARCHAR2,
   receiver_id_            IN VARCHAR2,
   receiver_addr_id_       IN VARCHAR2,  
   pro_no_                 IN VARCHAR2,
   forward_agent_id_       IN VARCHAR2,
   route_id_               IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,  
   consignment_note_id_    IN VARCHAR2,  
   delnote_no_             IN VARCHAR2,  
   status_                 IN VARCHAR2,  
   to_date_                IN DATE,  
   from_date_              IN DATE,  
   action_                 IN VARCHAR2,
   wanted_data_item_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   sql_where_expression_  VARCHAR2(2000);
   column_name_           VARCHAR2(200) := wanted_data_item_id_;
   dummy_                 BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   
   IF (wanted_data_item_id_ IN ('ACTION')) THEN
      NULL;
   ELSIF (wanted_data_item_id_ IN ('DELNOTE_NO')) THEN
      NULL;
   ELSIF wanted_data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SHIPMENT_TYPE', 'RECEIVER_ID', 'PRO_NO',
                                  'FORWARD_AGENT_ID', 'ROUTE_ID', 'SHIP_VIA_CODE', 'FROM_DATE', 'TO_DATE', 'STATUS', 'RECEIVER_ADDR_ID') THEN 
   
      -- If shipment_id_ is not null we don't need to add where expression (for delnote_id) since shipment_id_ have already been validated against delnote_id. 
      -- This check is used to increase performance.
      IF shipment_id_ IS NULL OR wanted_data_item_id_ = 'SHIPMENT_ID' THEN 
         sql_where_expression_  := Get_Sql_Where_Expression___(delnote_no_, action_);
      END IF;

      IF wanted_data_item_id_ = 'STATE' THEN 
         column_name_ := 'ROWSTATE';
      ELSIF (wanted_data_item_id_ IN ('FROM_DATE','TO_DATE')) THEN
         column_name_ := 'PLANNED_SHIP_DATE';
      END IF;
      
      unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_ => dummy_,
                                                               contract_              => contract_,
                                                               shipment_id_           => shipment_id_,
                                                               parent_consol_ship_id_ => parent_consol_ship_id_,
                                                               shipment_category_     => shipment_category_,
                                                               shipment_type_         => shipment_type_,
                                                               sender_type_           => sender_type_,
                                                               receiver_type_         => receiver_type_,
                                                               receiver_id_           => receiver_id_,
                                                               receiver_addr_id_      => receiver_addr_id_,
                                                               pro_no_                => pro_no_,
                                                               forward_agent_id_      => forward_agent_id_,
                                                               route_id_              => route_id_,
                                                               ship_via_code_         => ship_via_code_,
                                                               consignment_note_id_   => consignment_note_id_,
                                                               status_                => status_,
                                                               from_date_             => from_date_,
                                                               to_date_               => to_date_,
                                                               column_name_           => column_name_,
                                                               sql_where_expression_  => sql_where_expression_); 
   END IF ;
   
   $END
   IF (unique_value_ = 'NULL') THEN   -- string 'NULL' is only for automatic handling framework, here it should be NULL
      unique_value_ := NULL;
   END IF;
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___; 

PROCEDURE Raise_Act_Not_Allowed_Error___ (
   action_      IN VARCHAR2,
   shipment_id_ IN NUMBER )
IS
BEGIN
   Error_SYS.Record_General(lu_name_,'ACTIONNOTALLOWED: Action :P1 is not allowed for shipment :P2.', Shipment_Flow_Activities_API.Decode(action_), shipment_id_);   
END Raise_Act_Not_Allowed_Error___;   

PROCEDURE Raise_Approval_Needed_Error___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   Error_SYS.Record_General(lu_name_,'APPROVALNEEDED: Approval is needed for shipment :P1 before delivery.', shipment_id_);
END Raise_Approval_Needed_Error___;   

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   shipment_id_            NUMBER;
   parent_consol_ship_id_  NUMBER;
   shipment_category_      VARCHAR2(50);
   shipment_type_          VARCHAR2(3);
   sender_type_            VARCHAR2(200);
   receiver_type_          VARCHAR2(200);
   receiver_id_            VARCHAR2(50);
   receiver_addr_id_       VARCHAR2(50);
   pro_no_                 VARCHAR2(50);
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   ship_via_code_          VARCHAR2(3);
   consignment_note_id_    VARCHAR2(50);
   delnote_no_             VARCHAR2(50);
   from_date_              DATE;
   to_date_                DATE;
   status_                 VARCHAR2(50);
   action_                 VARCHAR2(200);
   contract_               VARCHAR2(5);
   column_name_            VARCHAR2(200) := data_item_id_;
   data_item_description_  VARCHAR2(200); 
   sql_where_expression_   VARCHAR2(3200);
   dummy_                  BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      Get_Filter_Keys___(contract_              => contract_,
                         shipment_id_           => shipment_id_,
                         parent_consol_ship_id_ => parent_consol_ship_id_,
                         shipment_category_     => shipment_category_,
                         shipment_type_         => shipment_type_,
                         sender_type_           => sender_type_,
                         receiver_type_         => receiver_type_,
                         receiver_id_           => receiver_id_,
                         receiver_addr_id_      => receiver_addr_id_,
                         pro_no_                => pro_no_,
                         forward_agent_id_      => forward_agent_id_,
                         route_id_              => route_id_,
                         ship_via_code_         => ship_via_code_,
                         consignment_note_id_   => consignment_note_id_,
                         delnote_no_            => delnote_no_,
                         status_                => status_,
                         from_date_             => from_date_,
                         to_date_               => to_date_,
                         action_                => action_,
                         capture_session_id_    => capture_session_id_, 
                         data_item_id_          => data_item_id_);

      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);

      -- check all data items that shouldnt be null
      IF (data_item_id_ IN ('SHIPMENT_ID','SHIPMENT_CATEGORY', 'ACTION')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_        => capture_session_id_, 
                                                                data_item_id_              => data_item_id_, 
                                                                data_item_value_           => data_item_value_, 
                                                                mandatory_non_process_key_ => TRUE);
      END IF;
      
      IF (data_item_id_ IN ('SHIP_LOCATION_NO')) THEN 
         IF action_ = Shipment_Flow_Activities_API.DB_REPORT_PICKING THEN 
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_        => capture_session_id_, 
                                                                   data_item_id_              => data_item_id_, 
                                                                   data_item_value_           => data_item_value_, 
                                                                   mandatory_non_process_key_ => TRUE);
         END IF;

         IF (data_item_value_ IS NOT NULL) THEN
            Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_ => capture_session_id_,
                                                            data_item_id_       => 'LOCATION_NO', -- Use LOCATION_NO to check if location exists at all.
                                                            data_item_value_    => data_item_value_);
            IF (Inventory_Location_API.Get_Location_Type_Db(contract_, data_item_value_) != Inventory_Location_Type_API.DB_SHIPMENT) THEN
               Error_SYS.Record_General(lu_name_,'INVALIDSHIPLOC: Location :P1 is not a shipment location.', data_item_value_);
            END IF;
         END IF;
      ELSIF (data_item_id_ IN ('ACTION')) THEN 
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_consol_ship_id_, shipment_category_, shipment_type_, sender_type_, receiver_type_, receiver_id_, receiver_addr_id_,   
                                                          pro_no_, forward_agent_id_, route_id_, ship_via_code_, consignment_note_id_, delnote_no_, status_, from_date_, to_date_, action_, 'SHIPMENT_ID');
         END IF;
         
         IF NOT Shipment_Flow_Activities_API.Exists_Db(data_item_value_) THEN 
            Error_SYS.Record_General(lu_name_,'ACTIONNOTEXIST: Action :P1 is not a valid action.', data_item_value_);
         ELSIF shipment_id_ IS NOT NULL THEN
            IF Shipment_Flow_API.Shipment_Operation_Allowed__(shipment_id_, data_item_value_) = 'FALSE' THEN 
               Raise_Act_Not_Allowed_Error___(data_item_value_, shipment_id_);
            ELSIF data_item_value_ = Shipment_Flow_Activities_API.DB_DELIVER AND  
                  Shipment_API.Approve_Shipment_Allowed__(shipment_id_) = 1 THEN
               Raise_Approval_Needed_Error___(shipment_id_);               
            END IF;
         END IF;
      ELSIF (data_item_id_ IN ('FROM_DATE','TO_DATE')) THEN 
         NULL;
      ELSIF (data_item_id_ IN ('DELNOTE_NO')) THEN 

         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_consol_ship_id_, shipment_category_, shipment_type_, sender_type_, receiver_type_, receiver_id_, receiver_addr_id_,   
                                                          pro_no_, forward_agent_id_, route_id_, ship_via_code_, consignment_note_id_, delnote_no_, status_, from_date_, to_date_, action_, 'SHIPMENT_ID');
         END IF;
         
         IF data_item_value_ IS NOT NULL THEN 
            -- Note: route_id_ have been removed as a filter here since route have no value for delivery notes connected to shipment for some strange reason
            Shipment_Delivery_Utility_API.Record_With_Column_Value_Exist(record_exists_         => dummy_,
                                                                         contract_              => contract_,
                                                                         delnote_no_            => delnote_no_,
                                                                         shipment_id_           => shipment_id_,
                                                                         receiver_id_           => receiver_id_,
                                                                         receiver_addr_id_      => receiver_addr_id_,
                                                                         forward_agent_id_      => forward_agent_id_,
                                                                         ship_via_code_         => ship_via_code_,
                                                                         column_name_           => column_name_,
                                                                         column_value_          => data_item_value_,
                                                                         column_description_    => data_item_description_); 
         ELSIF shipment_id_ IS NOT NULL THEN 
            delnote_no_ := Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_);
            IF delnote_no_ IS NOT NULL THEN
               Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 can not be null in the context of the entered data and this process.', data_item_description_);
            END IF;
         END IF;
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      ELSE  
         -- If shipment_id_ is not null we don't need to add where expression (for delnote_id) since shipment_id_ have already been validated. 
         -- This check is used to increase performance.
         IF shipment_id_ IS NULL OR data_item_id_ = 'SHIPMENT_ID' THEN 
            sql_where_expression_  := Get_Sql_Where_Expression___(delnote_no_,action_);
         END IF;

         IF data_item_id_ = 'STATE' THEN 
            column_name_ := 'ROWSTATE';
         END IF;

         Shipment_API.Record_With_Column_Value_Exist(record_exists_         => dummy_,
                                                     contract_              => contract_,
                                                     shipment_id_           => shipment_id_,
                                                     parent_consol_ship_id_ => parent_consol_ship_id_,
                                                     shipment_category_     => shipment_category_,
                                                     shipment_type_         => shipment_type_,
                                                     sender_type_           => sender_type_,
                                                     receiver_type_         => receiver_type_,
                                                     receiver_id_           => receiver_id_,
                                                     receiver_addr_id_      => receiver_addr_id_,
                                                     pro_no_                => pro_no_,
                                                     forward_agent_id_      => forward_agent_id_,
                                                     route_id_              => route_id_,
                                                     ship_via_code_         => ship_via_code_,
                                                     consignment_note_id_   => consignment_note_id_,
                                                     status_                => status_,
                                                     from_date_             => from_date_,
                                                     to_date_               => to_date_,
                                                     column_name_           => column_name_,
                                                     column_value_          => data_item_value_,
                                                     column_description_    => data_item_description_,
                                                     sql_where_expression_  => sql_where_expression_); 

         IF data_item_id_ = 'SHIPMENT_ID' AND action_ IS NOT NULL THEN
            IF Shipment_Flow_API.Shipment_Operation_Allowed__(data_item_value_, action_) = 'FALSE' THEN 
               Raise_Act_Not_Allowed_Error___(action_, to_number(data_item_value_));
            ELSIF NVL(action_,'') = Shipment_Flow_Activities_API.DB_DELIVER AND  
                  Shipment_API.Approve_Shipment_Allowed__(data_item_value_) = 1 THEN
               Raise_Approval_Needed_Error___(shipment_id_);
            END IF;
         END IF;

      END IF;
   $ELSE
      NULL;
   $END 
END Validate_Data_Item;


FUNCTION Get_Delnote_Sql_Where_Expression___ RETURN VARCHAR2
IS
   return_value_  VARCHAR2(2000);
BEGIN
   return_value_ := ' shipment_id IN (SELECT shipment_id
                                      FROM   shipment_tab 
                                      WHERE rowstate NOT IN (''Closed'', ''Cancelled'')) ';
   RETURN return_value_;
END Get_Delnote_Sql_Where_Expression___;


FUNCTION Get_Sql_Where_Expression___ (
   delnote_no_ IN VARCHAR2,
   action_     IN VARCHAR2 )RETURN VARCHAR2
IS
   return_value_  VARCHAR2(2000);
BEGIN
   IF delnote_no_ IS NOT NULL THEN 
      return_value_ := ' shipment_id IN (SELECT shipment_id
                                         FROM   delivery_note_pub 
                                         WHERE  delnote_no    = ' || delnote_no_ || 
                                       ' AND    state         != ''Invalid'')';
   END IF;
   IF action_ IS NOT NULL THEN 
      IF return_value_ IS NOT NULL THEN 
         return_value_ := return_value_ || ' AND ';
      END IF;
      return_value_ := return_value_ || ' Shipment_Flow_API.Shipment_Operation_Allowed__(shipment_id , ''' || action_ || ''') = ''TRUE''';
   END IF;
   RETURN return_value_;
END Get_Sql_Where_Expression___;


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
   shipment_id_            NUMBER;
   parent_consol_ship_id_  NUMBER;
   shipment_category_      VARCHAR2(50);
   shipment_type_          VARCHAR2(3);
   sender_type_            VARCHAR2(200);
   receiver_type_          VARCHAR2(200);
   receiver_id_            VARCHAR2(50);
   receiver_addr_id_       VARCHAR2(50);
   pro_no_                 VARCHAR2(50);
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   ship_via_code_          VARCHAR2(3);
   consignment_note_id_    VARCHAR2(50);
   delnote_no_             VARCHAR2(15);
   from_date_              DATE;
   to_date_                DATE;
   status_                 VARCHAR2(50);
   action_                 VARCHAR2(200);
   lov_type_db_            VARCHAR2(20);
   dummy_contract_         VARCHAR2(5);
   column_name_            VARCHAR2(200) := data_item_id_;
   sql_where_expression_   VARCHAR2(3200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

      Get_Filter_Keys___(contract_              => dummy_contract_,
                         shipment_id_           => shipment_id_,
                         parent_consol_ship_id_ => parent_consol_ship_id_,
                         shipment_category_     => shipment_category_,
                         shipment_type_         => shipment_type_,
                         sender_type_           => sender_type_,
                         receiver_type_         => receiver_type_,
                         receiver_id_           => receiver_id_,
                         receiver_addr_id_      => receiver_addr_id_,
                         pro_no_                => pro_no_,
                         forward_agent_id_      => forward_agent_id_,
                         route_id_              => route_id_,
                         ship_via_code_         => ship_via_code_,
                         consignment_note_id_   => consignment_note_id_,
                         delnote_no_            => delnote_no_,
                         status_                => status_,
                         from_date_             => from_date_,
                         to_date_               => to_date_,
                         action_                => action_,
                         capture_session_id_    => capture_session_id_, 
                         data_item_id_          => data_item_id_);
                         
      IF (data_item_id_ = 'SHIP_LOCATION_NO') THEN
         Inventory_Location_API.Create_Data_Capture_Lov(contract_, capture_session_id_, 4);
      ELSIF (data_item_id_ = 'SHIPMENT_CATEGORY_ID') THEN 
         Shipment_Category_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ IN ('RECEIVER_TYPE')) THEN 
         Sender_Receiver_Type_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ IN ('ACTION')) THEN
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_consol_ship_id_, shipment_category_, shipment_type_, sender_type_, receiver_type_, receiver_id_, receiver_addr_id_,   
                                                          pro_no_, forward_agent_id_, route_id_, ship_via_code_, consignment_note_id_, delnote_no_, status_, from_date_, to_date_, action_, 'SHIPMENT_ID');
         END IF;
         
         IF shipment_id_ IS NOT NULL THEN 
            Shipment_Flow_API.Create_Data_Capture_Lov(shipment_id_         => shipment_id_,
                                                      capture_session_id_  => capture_session_id_);
         ELSE
            Shipment_Flow_Activities_API.Create_Data_Capture_Lov(capture_session_id_);
         END IF;
         
      ELSIF (data_item_id_ IN ('DELNOTE_NO')) THEN
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_consol_ship_id_, shipment_category_, shipment_type_, sender_type_, receiver_type_, receiver_id_, receiver_addr_id_,   
                                                          pro_no_, forward_agent_id_, route_id_, ship_via_code_, consignment_note_id_, delnote_no_, status_, from_date_, to_date_, action_, 'SHIPMENT_ID');
         END IF;
         
         -- Due to performance consideration and in case delivery note data item comes before shipment id and no other data items have been already scanned or the 
         -- already scanned data items don't have same data source as delivery note (and if unique method didnt return unique shipment id), we will fetch all the valid 
         -- delivery notes that have shipment id not null no matter if their shipment id is not valid in the context of this process, Exp. if action is first data 
         -- item and next is delivery note, the delviry note lov would not be filtered based on action.
         -- Note: route_id_ have been removed as a filter here since route have no value for delivery notes connected to shipment for some strange reason
         Shipment_Delivery_Utility_API.Create_Data_Capture_Lov(contract_              => contract_,
                                                               delnote_no_            => delnote_no_,
                                                               shipment_id_           => shipment_id_,
                                                               receiver_id_           => receiver_id_,
                                                               receiver_addr_id_      => receiver_addr_id_,
                                                               forward_agent_id_      => forward_agent_id_,
                                                               ship_via_code_         => ship_via_code_,
                                                               capture_session_id_    => capture_session_id_,
                                                               column_name_           => column_name_,
                                                               lov_type_db_           => lov_type_db_,
                                                               sql_where_expression_  => Get_Delnote_Sql_Where_Expression___); 
      ELSE
         -- If shipment_id_ is not null we don't need to add where expression (for delnote_id) since shipment_id_ have already been validated against delnote_id. 
         -- This check is used to increase performance.
         IF shipment_id_ IS NULL OR data_item_id_ = 'SHIPMENT_ID' THEN 
            sql_where_expression_  := Get_Sql_Where_Expression___(delnote_no_, action_);
         END IF;
   
         IF data_item_id_ = 'STATE' THEN 
            column_name_ := 'ROWSTATE';
         END IF;

         Shipment_API.Create_Data_Capture_Lov(contract_              => contract_,
                                              shipment_id_           => shipment_id_,
                                              parent_consol_ship_id_ => parent_consol_ship_id_,
                                              shipment_category_     => shipment_category_,
                                              shipment_type_         => shipment_type_,
                                              sender_type_           => sender_type_,
                                              receiver_type_         => receiver_type_,
                                              receiver_id_           => receiver_id_,
                                              receiver_addr_id_      => receiver_addr_id_,
                                              pro_no_                => pro_no_,
                                              forward_agent_id_      => forward_agent_id_,
                                              route_id_              => route_id_,
                                              ship_via_code_         => ship_via_code_,
                                              consignment_note_id_   => consignment_note_id_,
                                              status_                => status_,
                                              from_date_             => from_date_,
                                              to_date_               => to_date_,
                                              capture_session_id_    => capture_session_id_,
                                              column_name_           => column_name_,
                                              lov_type_db_           => lov_type_db_,
                                              sql_where_expression_  => sql_where_expression_); 

      END IF;

   $ELSE
      NULL;
   $END
END Create_List_Of_Values;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   automatic_value_        VARCHAR2(200) := NULL;
   contract_               VARCHAR2(5);
   shipment_id_            NUMBER;
   parent_consol_ship_id_  NUMBER;
   shipment_category_      VARCHAR2(50);
   shipment_type_          VARCHAR2(3);
   sender_type_            VARCHAR2(200);
   receiver_type_          VARCHAR2(200);
   receiver_id_            VARCHAR2(50);
   receiver_addr_id_       VARCHAR2(50);
   pro_no_                 VARCHAR2(50);
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   ship_via_code_          VARCHAR2(3);
   consignment_note_id_    VARCHAR2(50);
   delnote_no_             VARCHAR2(15);
   from_date_              DATE;
   to_date_                DATE;
   status_                 VARCHAR2(50);
   action_                 VARCHAR2(200);
   column_name_            VARCHAR2(200) := data_item_id_;
   dummy_                  BOOLEAN;
   sql_where_expression_   VARCHAR2(3200);
   event_tab_              Shipment_Flow_API.Event_Tab;
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN 
      session_rec_              := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));

      IF (automatic_value_ IS NULL) THEN

         Get_Filter_Keys___(contract_              => contract_,
                            shipment_id_           => shipment_id_,
                            parent_consol_ship_id_ => parent_consol_ship_id_,
                            shipment_category_     => shipment_category_,
                            shipment_type_         => shipment_type_,
                            sender_type_           => sender_type_,
                            receiver_type_         => receiver_type_,
                            receiver_id_           => receiver_id_,
                            receiver_addr_id_      => receiver_addr_id_,
                            pro_no_                => pro_no_,
                            forward_agent_id_      => forward_agent_id_,
                            route_id_              => route_id_,
                            ship_via_code_         => ship_via_code_,
                            consignment_note_id_   => consignment_note_id_,
                            delnote_no_            => delnote_no_,
                            status_                => status_,
                            from_date_             => from_date_,
                            to_date_               => to_date_,
                            action_                => action_,
                            capture_session_id_    => capture_session_id_, 
                            data_item_id_          => data_item_id_);
      
         IF (shipment_id_ IS NULL AND data_item_id_ IN ('SHIP_LOCATION_NO','ACTION','DELNOTE_NO')) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_consol_ship_id_, shipment_category_, shipment_type_, sender_type_, receiver_type_, receiver_id_, receiver_addr_id_,   
                                                          pro_no_, forward_agent_id_, route_id_, ship_via_code_, consignment_note_id_, delnote_no_, status_, from_date_, to_date_, action_, 'SHIPMENT_ID');
         END IF;
         
         IF (data_item_id_ = 'SHIP_LOCATION_NO') THEN
            IF action_ != Shipment_Flow_Activities_API.DB_REPORT_PICKING THEN 
               automatic_value_ := 'NULL';
            ELSIF shipment_id_ IS NOT NULL THEN 
               IF shipment_type_ IS NULL THEN
                  shipment_type_ := Shipment_API.Get_Shipment_Type(shipment_id_);
               END IF;
               IF Shipment_Type_API.Get_Confirm_Ship_Loc_No_Db(shipment_type_) = 'FALSE' AND  
                     Pick_Shipment_API.Validate_Shipment_Pick_Lists(shipment_id_) = 'TRUE' THEN 
                  automatic_value_ := Shipment_API.Get_Ship_Inventory_Location_No(shipment_id_);
               END IF;
            END IF;
         ELSIF (data_item_id_ IN ('DELNOTE_NO')) THEN 
            IF (shipment_id_ IS NOT NULL) THEN 
               automatic_value_ := NVL(Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_),'NULL'); 
            END IF;
      
         ELSIF (data_item_id_ IN ('GS1_BARCODE1', 'GS1_BARCODE2')) THEN 
            NULL; -- no automatic handling for these items
         
         ELSIF (data_item_id_ IN ('ACTION')) THEN
            IF shipment_id_ IS NOT NULL THEN 
               event_tab_ := Shipment_Flow_API.Get_Next_Mandatory_Events__(shipment_id_);
               -- event_tab is not contained preliminary action so we need to check if preliminary is another option automatic value should be null.
               IF event_tab_.Count = 1 AND NVL(Shipment_API.Reopen_Shipment_Allowed__(shipment_id_),0) != 1  AND Shipment_API.Undo_Shipment_Allowed(shipment_id_) = FALSE THEN
                  automatic_value_ := Shipment_Flow_Activities_API.Encode(event_tab_(event_tab_.FIRST).description);
               END IF;
            END IF;
         ELSE 
            -- If shipment_id_ is not null we don't need to add where expression (for delnote_id) since shipment_id_ have already been validated against delnote_id. 
            -- This check is used to increase performance.
            IF shipment_id_ IS NULL OR data_item_id_ = 'SHIPMENT_ID' THEN 
               sql_where_expression_  := Get_Sql_Where_Expression___(delnote_no_, action_);
            END IF;
      
            IF data_item_id_ = 'STATE' THEN 
               column_name_ := 'ROWSTATE';
            ELSIF (data_item_id_ IN ('FROM_DATE','TO_DATE')) THEN
               column_name_ := 'PLANNED_SHIP_DATE';
            END IF;
      
            automatic_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_ => dummy_,
                                                                        contract_              => contract_,
                                                                        shipment_id_           => shipment_id_,
                                                                        parent_consol_ship_id_ => parent_consol_ship_id_,
                                                                        shipment_category_     => shipment_category_,
                                                                        shipment_type_         => shipment_type_,
                                                                        sender_type_           => sender_type_,
                                                                        receiver_type_         => receiver_type_,
                                                                        receiver_id_           => receiver_id_,
                                                                        receiver_addr_id_      => receiver_addr_id_,
                                                                        pro_no_                => pro_no_,
                                                                        forward_agent_id_      => forward_agent_id_,
                                                                        route_id_              => route_id_,
                                                                        ship_via_code_         => ship_via_code_,
                                                                        consignment_note_id_   => consignment_note_id_,
                                                                        status_                => status_,
                                                                        from_date_             => from_date_,
                                                                        to_date_               => to_date_,
                                                                        column_name_           => column_name_,
                                                                        sql_where_expression_  => sql_where_expression_); 
                                                                        
            IF (data_item_id_ IN ('FROM_DATE','TO_DATE')) THEN 
               IF (NULLIF(automatic_value_, 'NULL') IS NOT NULL) THEN
                  automatic_value_ := TO_CHAR(to_date(automatic_value_), Client_SYS.date_format_);
               ELSIF (data_item_id_ IN ('FROM_DATE') AND automatic_value_ IS NULL) THEN
                  -- Get_Site_Date return date with time stamp of current time but wadaco date component return date with time stamp of 00:00:00 so to achieve currect date with time stamp 00:00:00
                  -- we convert to char and date and again char.
                  automatic_value_ := TO_CHAR(to_date(TO_CHAR(Site_API.Get_Site_Date(contract_), Client_SYS.trunc_date_format_), Client_SYS.trunc_date_format_), Client_SYS.date_format_);
               END IF; 
            END IF; 
         END IF;
      END IF;
   $END
   RETURN automatic_value_;         
END Get_Automatic_Data_Item_Value;


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN     NUMBER,
   data_item_id_       IN     VARCHAR2) RETURN BOOLEAN
IS
   session_rec_               Data_Capture_Common_Util_API.Session_Rec;
   fixed_value_is_applicable_ BOOLEAN := FALSE;
   process_package_           VARCHAR2(30);
   shipment_category_         VARCHAR2(50);
   data_item_value_           VARCHAR2(100);
   
BEGIN
$IF Component_Wadaco_SYS.INSTALLED $THEN
   session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
   process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

   IF (data_item_id_ = 'PARENT_CONSOL_SHIPMENT_ID') THEN 
      shipment_category_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_CATEGORY', session_rec_ , process_package_, use_applicable_ => TRUE);
      -- When shipment is consolidated shipment, PARENT_CONSOL_SHIPMENT_ID value is lways null
      IF shipment_category_ = Shipment_Category_API.Decode(Shipment_Category_API.DB_CONSOLIDATED) THEN 
         fixed_value_is_applicable_ := TRUE;
      END IF;
   END IF;

$END
                                                                                       
RETURN fixed_value_is_applicable_;
END Fixed_Value_Is_Applicable;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_   Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_               VARCHAR2(5);
   shipment_id_            NUMBER;
   parent_consol_ship_id_  NUMBER;
   shipment_category_      VARCHAR2(50);
   shipment_type_          VARCHAR2(3);
   sender_type_            VARCHAR2(200);
   receiver_type_          VARCHAR2(200);
   receiver_id_            VARCHAR2(50);
   receiver_addr_id_       VARCHAR2(50);
   pro_no_                 VARCHAR2(50);
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   ship_via_code_          VARCHAR2(3);
   consignment_note_id_    VARCHAR2(50);
   delnote_no_             VARCHAR2(15);
   from_date_              DATE;
   to_date_                DATE;
   status_                 VARCHAR2(50);
   action_                 VARCHAR2(200);
BEGIN
      NULL;
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
     
      -- Get any keys that have been saved before in this session (using the filter keys collection only here)
      Get_Filter_Keys___(contract_              => contract_,
                         shipment_id_           => shipment_id_,
                         parent_consol_ship_id_ => parent_consol_ship_id_,
                         shipment_category_     => shipment_category_,
                         shipment_type_         => shipment_type_,
                         sender_type_           => sender_type_,
                         receiver_type_         => receiver_type_,
                         receiver_id_           => receiver_id_,
                         receiver_addr_id_      => receiver_addr_id_,
                         pro_no_                => pro_no_,
                         forward_agent_id_      => forward_agent_id_,
                         route_id_              => route_id_,
                         ship_via_code_         => ship_via_code_,
                         consignment_note_id_   => consignment_note_id_,
                         delnote_no_            => delnote_no_,
                         status_                => status_,
                         from_date_             => from_date_,
                         to_date_               => to_date_,
                         action_                => action_,
                         capture_session_id_    => capture_session_id_, 
                         data_item_id_          => latest_data_item_id_);
 
      
      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            -- DATA ITEMS AS DETAILS
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 

               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_ID','SHIPMENT_CATEGORY','ACTION','SHIPMENT_TYPE','PARENT_CONSOL_SHIPMENT_ID',
                                                                    'RECEIVER_ID','RECEIVER_TYPE','RECEIVER_ADDR_ID','PRO_NO','FORWARD_AGENT_ID','ROUTE_ID',
                                                                    'SHIP_VIA_CODE','STATE','CONSIGNMENT_NOTE_ID','DELNOTE_NO','FROM_DATE','TO_DATE','SENDER_TYPE')) THEN

                  parent_consol_ship_id_  := NULLIF(parent_consol_ship_id_, number_all_values_);
                  shipment_type_          := NULLIF(shipment_type_, string_all_values_);
                  sender_type_            := NULLIF(sender_type_, string_all_values_);
                  receiver_type_          := NULLIF(receiver_type_, string_all_values_);
                  receiver_id_            := NULLIF(receiver_id_, string_all_values_);
                  receiver_addr_id_       := NULLIF(receiver_addr_id_, string_all_values_);
                  pro_no_                 := NULLIF(pro_no_, string_all_values_);
                  forward_agent_id_       := NULLIF(forward_agent_id_, string_all_values_);
                  route_id_               := NULLIF(route_id_, string_all_values_);
                  ship_via_code_          := NULLIF(ship_via_code_, string_all_values_);
                  consignment_note_id_    := NULLIF(consignment_note_id_, string_all_values_);


                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_    => capture_session_id_,
                                           owning_data_item_id_   => latest_data_item_id_,
                                           data_item_detail_id_   => conf_item_detail_tab_(i).data_item_detail_id,
                                           shipment_id_           => shipment_id_,
                                           parent_consol_ship_id_ => parent_consol_ship_id_,
                                           shipment_category_     => shipment_category_,
                                           shipment_type_         => shipment_type_,
                                           sender_type_           => sender_type_,
                                           receiver_type_         => receiver_type_,
                                           receiver_id_           => receiver_id_,
                                           receiver_addr_id_      => receiver_addr_id_,
                                           pro_no_                => pro_no_,
                                           forward_agent_id_      => forward_agent_id_,
                                           route_id_              => route_id_,
                                           ship_via_code_         => ship_via_code_,
                                           consignment_note_id_   => consignment_note_id_,
                                           delnote_no_            => delnote_no_,
                                           status_                => status_,
                                           from_date_             => from_date_,
                                           to_date_               => to_date_,
                                           action_                => action_);

               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_         => capture_session_id_,
                                                 session_rec_                => session_rec_,
                                                 owning_data_item_id_        => latest_data_item_id_,
                                                 owning_data_item_value_     => latest_data_item_value_,
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id);
               END IF;


            -- FEEDBACK ITEMS AS DETAILS
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('FORWARD_AGENT_NAME', 'ROUTE_DESCRIPTION', 'SHIPMENT_TYPE_DESC', 'DELIVERY_TERMS', 
                                                                    'DELIVERY_TERMS_DESC', 'SHIP_VIA_CODE_DESC', 'LOAD_SEQUENCE_NO', 
                                                                    'APPROVED_BY', 'APPROVED_NAME', 'SOURCE_REF1', 'RECEIVER_DESCRIPTION', 'RECEIVER_ADDRESS_NAME', 
                                                                    'RECEIVER_ADDRESS1', 'RECEIVER_ADDRESS2', 'RECEIVER_ADDRESS3', 'RECEIVER_ADDRESS4', 
                                                                    'RECEIVER_ADDRESS5', 'RECEIVER_ADDRESS6', 'RECEIVER_COUNTRY', 'RECEIVER_CITY')) THEN

               IF latest_data_item_id_ = 'SHIPMENT_ID' THEN 
                  shipment_id_ := latest_data_item_value_;
               END IF;
               
               -- Feedback items related to shipment
               Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_        => capture_session_id_,
                                                                     owning_data_item_id_       => latest_data_item_id_,
                                                                     data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                                                     shipment_id_               => shipment_id_);
               
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END 
END Add_Details_For_Latest_Item;


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF (no_of_records_handled_ = 1) THEN
      IF process_message_ = Fnd_Boolean_API.DB_FALSE THEN 
         message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONBJOK: The shipment will be processed by a background job and may take some time.');
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONOK: The shipment was successfully processed.');
      END IF;

   ELSIF (no_of_records_handled_ > 1) THEN 
      IF process_message_ = Fnd_Boolean_API.DB_FALSE THEN 
         message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONSBJOK: :P1 shipments will be processed by a background job and may take some time.', no_of_records_handled_);
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONSOK: :P1 shipments were successfully processed.', no_of_records_handled_);
      END IF;
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY CLOB,
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
   blob_ref_tab_           Data_Capture_Common_Util_API.Blob_Ref_Tab;
   blob_data_item_value_   VARCHAR2(2000);
   lu_objid_               VARCHAR2(2000);
   exec_attr_              VARCHAR2(2000);
   shipment_id_            NUMBER;
   shipment_type_          VARCHAR2(200);
   ship_location_no_       VARCHAR2(35);
   action_                 VARCHAR2(50);
   info_                   VARCHAR2(2000);
   image_seq_              NUMBER := 0;
BEGIN
   shipment_id_      := Client_SYS.Get_Item_Value('SHIPMENT_ID', attr_);
   shipment_type_    := Client_SYS.Get_Item_Value('SHIPMENT_TYPE', attr_);
   ship_location_no_ := Client_SYS.Get_Item_Value('SHIP_LOCATION_NO', attr_);
   action_           := Client_SYS.Get_Item_Value('ACTION', attr_);
   
   Client_SYS.Clear_Attr(exec_attr_);
   CASE action_
   WHEN Shipment_Flow_Activities_API.DB_RESERVE THEN
         Client_SYS.Add_To_Attr('START_EVENT', 10, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Reserve_Shipment__(info_, exec_attr_);
         
      WHEN Shipment_Flow_Activities_API.DB_CREATE_PICK_LIST THEN
         Client_SYS.Add_To_Attr('START_EVENT', 20, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Create_Pick_List__(exec_attr_);

      WHEN Shipment_Flow_Activities_API.DB_PRINT_PICK_LIST THEN
         Client_SYS.Add_To_Attr('START_EVENT', 30, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Print_Pick_List__(exec_attr_);
               
      WHEN Shipment_Flow_Activities_API.DB_REPORT_PICKING THEN
         Client_SYS.Add_To_Attr('START_EVENT', 40, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Pick_Report_Shipment__(exec_attr_);
         
      WHEN Shipment_Flow_Activities_API.DB_COMPLETE THEN
         Client_SYS.Add_To_Attr('START_EVENT', 50, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Complete_Shipment__(exec_attr_);
            
      WHEN Shipment_Flow_Activities_API.DB_DELIVER THEN
         Client_SYS.Add_To_Attr('START_EVENT', 60, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Deliver_Shipment__(exec_attr_);

      WHEN Shipment_Flow_Activities_API.DB_CLOSE THEN
         Client_SYS.Add_To_Attr('START_EVENT', 70, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Close_Shipment__(exec_attr_);
               
      WHEN Shipment_Flow_Activities_API.DB_UNDO_COMPLETE THEN
         Client_SYS.Add_To_Attr('START_EVENT', 1000, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, exec_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, exec_attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', ship_location_no_, exec_attr_);
         Client_SYS.Add_To_Attr('END', '', exec_attr_);
         Shipment_Flow_API.Start_Reopen_Shipment__(exec_attr_);
      WHEN Shipment_Flow_Activities_API.DB_UNDO_DELIVERY THEN
         Shipment_API.Undo_Shipment_Delivery(shipment_id_);
      ELSE
         NULL;
   END CASE;

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Convert blob references from attribute string to collection for easier handling     
      blob_ref_tab_ := Data_Capt_Sess_Line_Blob_API.Get_Blob_Ref_Tab_From_Attr(blob_ref_attr_);
      IF (blob_ref_tab_.COUNT > 0) THEN
         lu_objid_ := Shipment_API.Get(shipment_id_)."rowid";  -- rowid is objid.
         -- Iterate collection of blob references, extract photos, and save/connect each one to the desired object
         FOR i IN blob_ref_tab_.FIRST..blob_ref_tab_.LAST LOOP
            image_seq_ := image_seq_ + 1;
            blob_data_item_value_ := capture_session_id_ || '|' || blob_ref_tab_(i).session_line_no || '|' || blob_ref_tab_(i).blob_id; 
            Data_Capt_Sess_Line_Blob_API.Save_To_Media_Library(blob_data_item_value_ => blob_data_item_value_, 
                                                               lu_                   => 'Shipment', 
                                                               lu_objid_             => lu_objid_,
                                                               name_                 => 'WADACO Process Shipment '|| shipment_id_ || ' ' || image_seq_ ,
                                                               description_          => 'WADACO Process Shipment '|| shipment_id_ || ' ' || image_seq_ );
         END LOOP;
      END IF;         
   $END            
   process_message_ := Shipment_Type_API.Get_Online_Processing_Db(shipment_type_);
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Shipment_Flow_API.Start_Reserve_Shipment__ is granted thru any of following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('ShipmentHandling', 'StartShipmentMain') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentHandling', 'StartShipmentMainSingle') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentsHandling', 'StartShipmentMain') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentsHandling', 'StartShipmentMainSingle') OR
       Security_SYS.Is_Proj_Action_Available('ConsolidatedShipmentHandling', 'StartShipmentMain') OR
       Security_SYS.Is_Proj_Action_Available('ConsolidatedShipmentHandling', 'StartShipmentMainSingle') OR
       Security_SYS.Is_Proj_Action_Available('ConsolidatedShipmentsHandling', 'StartShipmentMain') OR
       Security_SYS.Is_Proj_Action_Available('ConsolidatedShipmentsHandling', 'StartShipmentMainSingle')) THEN 
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;