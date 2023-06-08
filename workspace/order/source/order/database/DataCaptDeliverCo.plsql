-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptDeliverCo
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: DELIVER_CUSTOMER_ORDER
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201111  LEPESE  SC2020R1-9599, Changed from Client_SYS.date_format to Client_SYS.trunc_date_format for 'WANTED_DELIVERY_DATE' in Get_Automatic_Data_Item_Value.
--  200827  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory.
--  171019  DaZase  STRSC-13011, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171019          of anything found later in that method. Changed size to 4000 on detail_value_ in Add_Unique_Data_Item_Detail___.
--  171019          Also made sure the new GS1 data items are handled in Validate_Data_Item/Get_Automatic_Data_Item_Value.
--  170718  KhVese  STRSC-8846, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Filter_Keys___ (
   contract_               OUT VARCHAR2,
   order_no_               OUT VARCHAR2,
   customer_no_            OUT VARCHAR2,
   priority_               OUT NUMBER,
   forward_agent_id_       OUT VARCHAR2,
   route_id_               OUT VARCHAR2,
   wanted_delivery_date_   OUT DATE,
   order_type_             OUT VARCHAR2,
   coordinator_            OUT VARCHAR2,  
   capture_session_id_     IN  NUMBER,
   data_item_id_           IN  VARCHAR2,
   data_item_value_        IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_      IN  BOOLEAN  DEFAULT FALSE )
IS
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   process_package_       VARCHAR2(30);
   delivery_date_         VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_        := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      order_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ORDER_NO', session_rec_ , process_package_); 
      customer_no_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CUSTOMER_NO', session_rec_ , process_package_);
      priority_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PRIORITY', session_rec_ , process_package_);
      forward_agent_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FORWARD_AGENT_ID', session_rec_ , process_package_);
      route_id_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ROUTE_ID', session_rec_ , process_package_);
      order_type_             := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ORDER_TYPE', session_rec_ , process_package_);
      coordinator_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'COORDINATOR', session_rec_ , process_package_);
      delivery_date_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WANTED_DELIVERY_DATE', session_rec_ , process_package_);
      wanted_delivery_date_   := to_date(delivery_date_,Client_SYS.date_format_);

      -- if forward_agent_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all forward_agent_id and null forward_agent_id in the table
      IF (forward_agent_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'FORWARD_AGENT_ID', data_item_id_)) THEN
         forward_agent_id_ := '%';
      END IF;

      -- if route_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all route_id and null route_id in the table
      IF (route_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ROUTE_ID', data_item_id_)) THEN
         route_id_ := '%';
      END IF;

      -- if priority_ comes after current data item, we exchange the parameter with -1 since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all priority and null prioritys in the table
      IF (priority_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PRIORITY', data_item_id_)) THEN
         priority_ := -1;
      END IF;

      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (order_no_ IS NULL) THEN
            order_no_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'ORDER_NO');
         END IF;
         IF (customer_no_ IS NULL) THEN
            customer_no_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'CUSTOMER_NO');
         END IF;
         IF (priority_ IS NULL) THEN
            priority_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'PRIORITY');
         END IF;
         IF (forward_agent_id_ IS NULL) THEN
            forward_agent_id_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'FORWARD_AGENT_ID');
         END IF;
         IF (route_id_ IS NULL) THEN
            route_id_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'ROUTE_ID');
         END IF;
         IF (wanted_delivery_date_ IS NULL) THEN
            wanted_delivery_date_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'WANTED_DELIVERY_DATE');
         END IF;
         IF (order_type_ IS NULL) THEN
            order_type_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'ORDER_TYPE');
         END IF;
         IF (coordinator_ IS NULL) THEN
            coordinator_ := Get_Unique_Data_Item_Value___(contract_, order_no_, customer_no_, priority_, forward_agent_id_, route_id_, wanted_delivery_date_, order_type_, coordinator_, 'COORDINATOR');
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
   order_no_             IN VARCHAR2,
   customer_no_          IN VARCHAR2,
   priority_             IN NUMBER,
   forward_agent_id_     IN VARCHAR2,
   route_id_             IN VARCHAR2,
   wanted_delivery_date_ IN DATE,
   order_type_           IN VARCHAR2,
   coordinator_          IN VARCHAR2)  
IS
   detail_value_             VARCHAR2(4000);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('ORDER_NO') THEN
            detail_value_ := order_no_;
         WHEN ('CUSTOMER_NO') THEN
            detail_value_ := customer_no_;
         WHEN ('PRIORITY') THEN
            detail_value_ := priority_;
         WHEN ('FORWARD_AGENT_ID') THEN
            detail_value_ := forward_agent_id_;
         WHEN ('ROUTE_ID') THEN
            detail_value_ := route_id_;
         WHEN ('WANTED_DELIVERY_DATE') THEN
            detail_value_ := to_char(wanted_delivery_date_,Client_SYS.date_format_);
         WHEN ('ORDER_TYPE') THEN
            detail_value_ := order_type_;
         WHEN ('COORDINATOR') THEN
            detail_value_ := coordinator_;
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


FUNCTION Get_Sql_Where_Expression___ RETURN VARCHAR2
IS
   return_value_  VARCHAR2(2000);
BEGIN
   return_value_ := ' (Customer_Order_Flow_API.Deliver_Allowed__(order_no) = 1) ';
   RETURN return_value_;
END Get_Sql_Where_Expression___;


FUNCTION Get_Unique_Data_Item_Value___ (
   contract_             IN VARCHAR2,
   order_no_             IN VARCHAR2,
   customer_no_          IN VARCHAR2,
   priority_             IN NUMBER,
   forward_agent_id_     IN VARCHAR2,
   route_id_             IN VARCHAR2,
   wanted_delivery_date_ IN DATE,
   order_type_           IN VARCHAR2,
   coordinator_          IN VARCHAR2,
   wanted_data_item_id_  IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   sql_where_expression_  VARCHAR2(2000);
   column_name_           VARCHAR2(200) := wanted_data_item_id_;
BEGIN
   -- If order no is not null we don't need to add where expression since order no have already been validated. This check used to increase performance.
   IF order_no_ IS NULL OR wanted_data_item_id_ = 'ORDER_NO' THEN  
      sql_where_expression_  := Get_Sql_Where_Expression___();
   END IF;

   IF wanted_data_item_id_ = 'ORDER_TYPE' THEN 
      column_name_ := 'ORDER_ID';
   ELSIF wanted_data_item_id_ = 'COORDINATOR' THEN 
      column_name_ := 'AUTHORIZE_CODE';
   END IF;

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      unique_value_ := Customer_Order_API.Get_Column_Value_If_Unique(contract_               => contract_,
                                                                     order_no_               => order_no_, 
                                                                     customer_no_            => customer_no_,
                                                                     priority_               => priority_,
                                                                     forward_agent_id_       => forward_agent_id_,
                                                                     route_id_               => route_id_,
                                                                     wanted_delivery_date_   => wanted_delivery_date_,
                                                                     order_type_             => order_type_,
                                                                     coordinator_            => coordinator_,
                                                                     column_name_            => column_name_,
                                                                     sql_where_expression_   => sql_where_expression_);
   $END
   IF (unique_value_ = 'NULL') THEN   -- string 'NULL' is only for automatic handling framework, here it should be NULL
      unique_value_ := NULL;
   END IF;
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___; 

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   contract_               VARCHAR2(5);
   order_no_               VARCHAR2(12);
   customer_no_            VARCHAR2(20);
   priority_               NUMBER;
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   wanted_delivery_date_   DATE;
   order_type_             VARCHAR2(3);
   coordinator_            VARCHAR2(20);
   column_name_            VARCHAR2(200) := data_item_id_;
   local_data_item_value_  VARCHAR2(200) := data_item_value_;
   sql_where_expression_   VARCHAR2(3200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      ELSE
         Get_Filter_Keys___(contract_              => contract_,
                            order_no_              => order_no_,
                            customer_no_           => customer_no_,
                            priority_              => priority_,
                            forward_agent_id_      => forward_agent_id_,
                            route_id_              => route_id_,
                            wanted_delivery_date_  => wanted_delivery_date_,
                            order_type_            => order_type_,
                            coordinator_           => coordinator_,
                            capture_session_id_    => capture_session_id_, 
                            data_item_id_          => data_item_id_, 
                            data_item_value_       => data_item_value_);
   
         -- If order no is not null we don't need to add where expression since order no have already been validated. This check used to increase performance.
         IF order_no_ IS NULL OR data_item_id_ = 'ORDER_NO' THEN 
            sql_where_expression_  := Get_Sql_Where_Expression___();
         END IF;
   
         IF data_item_id_ = 'ORDER_TYPE' THEN 
            column_name_ := 'ORDER_ID';
         ELSIF data_item_id_ = 'COORDINATOR' THEN 
            column_name_ := 'AUTHORIZE_CODE';
         END IF;
   
         IF data_item_id_ IN ('ORDER_NO', 'CUSTOMER_NO', 'WANTED_DELIVERY_DATE', 'ORDER_TYPE',  'COORDINATOR') THEN 
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_        => capture_session_id_, 
                                                                   data_item_id_              => data_item_id_, 
                                                                   data_item_value_           => data_item_value_, 
                                                                   mandatory_non_process_key_ => TRUE);
         END IF;
   
         IF (data_item_id_ = 'WANTED_DELIVERY_DATE') THEN
            local_data_item_value_ := TO_CHAR(TO_DATE(data_item_value_, Client_SYS.date_format_),Client_SYS.trunc_date_format_);
         END IF;
   
         Customer_Order_API.Record_With_Column_Value_Exist(contract_               => contract_,
                                                           order_no_               => order_no_, 
                                                           customer_no_            => customer_no_,
                                                           priority_               => priority_,
                                                           forward_agent_id_       => forward_agent_id_,
                                                           route_id_               => route_id_,
                                                           wanted_delivery_date_   => wanted_delivery_date_,
                                                           order_type_             => order_type_,
                                                           coordinator_            => coordinator_,
                                                           column_name_            => column_name_,
                                                           column_value_           => local_data_item_value_,
                                                           column_description_     => data_item_id_,
                                                           date_type_handling_     => data_item_id_ = 'WANTED_DELIVERY_DATE',
                                                           sql_where_expression_   => sql_where_expression_);
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item;


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
   order_no_               VARCHAR2(12);
   customer_no_            VARCHAR2(20);
   priority_               NUMBER;
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   wanted_delivery_date_   DATE;
   order_type_             VARCHAR2(3);
   coordinator_            VARCHAR2(20);
   lov_type_db_            VARCHAR2(20);
   dummy_contract_         VARCHAR2(5);
   column_name_            VARCHAR2(200) := data_item_id_;
   sql_where_expression_   VARCHAR2(3200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
      Get_Filter_Keys___(contract_              => dummy_contract_,
                         order_no_              => order_no_,
                         customer_no_           => customer_no_,
                         priority_              => priority_,
                         forward_agent_id_      => forward_agent_id_,
                         route_id_              => route_id_,
                         wanted_delivery_date_  => wanted_delivery_date_,
                         order_type_            => order_type_,
                         coordinator_           => coordinator_,
                         capture_session_id_    => capture_session_id_, 
                         data_item_id_          => data_item_id_);

      -- If order no is not null we don't need to add where expression since order no have already been validated. 
      -- This extra check is only done to prevent performance degradation.
      IF order_no_ IS NULL OR data_item_id_ = 'ORDER_NO' THEN  
         sql_where_expression_  := Get_Sql_Where_Expression___();
      END IF;
   
      IF data_item_id_ = 'ORDER_TYPE' THEN 
         column_name_ := 'ORDER_ID';
      ELSIF data_item_id_ = 'COORDINATOR' THEN 
         column_name_ := 'AUTHORIZE_CODE';
      END IF;

      Customer_Order_API.Create_Data_Capture_Lov(contract_               => contract_,
                                                 order_no_               => order_no_, 
                                                 customer_no_            => customer_no_,
                                                 priority_               => priority_,
                                                 forward_agent_id_       => forward_agent_id_,
                                                 route_id_               => route_id_,
                                                 wanted_delivery_date_   => wanted_delivery_date_,
                                                 order_type_             => order_type_,
                                                 coordinator_            => coordinator_,
                                                 capture_session_id_     => capture_session_id_,
                                                 column_name_            => column_name_,
                                                 lov_type_db_            => lov_type_db_,
                                                 sql_where_expression_   => sql_where_expression_);
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
   order_no_               VARCHAR2(12);
   customer_no_            VARCHAR2(20);
   priority_               NUMBER;
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   wanted_delivery_date_   DATE;
   order_type_             VARCHAR2(3);
   coordinator_            VARCHAR2(20);
   column_name_            VARCHAR2(200) := data_item_id_;
   sql_where_expression_   VARCHAR2(3200);
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));

      IF (automatic_value_ IS NULL) THEN

         IF (data_item_id_ IN ('GS1_BARCODE1','GS1_BARCODE2')) THEN
            NULL; -- no automatic value for GS1 items
         ELSE
            Get_Filter_Keys___(contract_              => contract_,
                               order_no_              => order_no_,
                               customer_no_           => customer_no_,
                               priority_              => priority_,
                               forward_agent_id_      => forward_agent_id_,
                               route_id_              => route_id_,
                               wanted_delivery_date_  => wanted_delivery_date_,
                               order_type_            => order_type_,
                               coordinator_           => coordinator_,
                               capture_session_id_    => capture_session_id_, 
                               data_item_id_          => data_item_id_);
         
            -- If order no is not null we don't need to add where expression since order no have already been validated. This check used to increase performance.
            IF order_no_ IS NULL OR data_item_id_ = 'ORDER_NO' THEN  
               sql_where_expression_  := Get_Sql_Where_Expression___();
            END IF;
            
            IF data_item_id_ = 'ORDER_TYPE' THEN 
               column_name_ := 'ORDER_ID';
            ELSIF data_item_id_ = 'COORDINATOR' THEN 
               column_name_ := 'AUTHORIZE_CODE';
            END IF;
         
            automatic_value_ := Customer_Order_API.Get_Column_Value_If_Unique(contract_               => contract_,
                                                                              order_no_               => order_no_, 
                                                                              customer_no_            => customer_no_,
                                                                              priority_               => priority_,
                                                                              forward_agent_id_       => forward_agent_id_,
                                                                              route_id_               => route_id_,
                                                                              wanted_delivery_date_   => wanted_delivery_date_,
                                                                              order_type_             => order_type_,
                                                                              coordinator_            => coordinator_,
                                                                              column_name_            => column_name_,
                                                                              sql_where_expression_   => sql_where_expression_);
                                                                              
            IF (data_item_id_ = 'WANTED_DELIVERY_DATE' AND NULLIF(automatic_value_, 'NULL') IS NOT NULL) THEN
               automatic_value_ := TO_CHAR(to_date(automatic_value_), Client_SYS.trunc_date_format_);
            END IF;            
         END IF;
      END IF;
   $END
   RETURN automatic_value_;         
END Get_Automatic_Data_Item_Value;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_   Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_               VARCHAR2(5);
   order_no_               VARCHAR2(12);
   customer_no_            VARCHAR2(20);
   priority_               NUMBER;
   forward_agent_id_       VARCHAR2(20);
   route_id_               VARCHAR2(12);
   wanted_delivery_date_   DATE;
   order_type_             VARCHAR2(3);
   coordinator_            VARCHAR2(20);
   local_data_item_id_     VARCHAR2(50) := latest_data_item_id_;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
     
      -- Get any keys that have been saved before in this session (using the filter keys collection only here)
      Get_Filter_Keys___(contract_              => contract_,
                         order_no_              => order_no_,
                         customer_no_           => customer_no_,
                         priority_              => priority_,
                         forward_agent_id_      => forward_agent_id_,
                         route_id_              => route_id_,
                         wanted_delivery_date_  => wanted_delivery_date_,
                         order_type_            => order_type_,
                         coordinator_           => coordinator_,
                         capture_session_id_    => capture_session_id_, 
                         data_item_id_          => latest_data_item_id_, 
                         data_item_value_       => latest_data_item_value_,
                         use_unique_values_     => TRUE);
 
      forward_agent_id_ := NULLIF(forward_agent_id_, '%');
      route_id_         := NULLIF(route_id_, '%');
      priority_         := NULLIF(priority_, -1);
      
      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
     IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            -- DATA ITEMS AS DETAILS
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               -- Data Items that are part of the filter keys
               Add_Filter_Key_Detail___(capture_session_id_    => capture_session_id_,
                                        owning_data_item_id_   => latest_data_item_id_,
                                        data_item_detail_id_   => conf_item_detail_tab_(i).data_item_detail_id,
                                        order_no_              => order_no_,
                                        customer_no_           => customer_no_,
                                        priority_              => priority_,
                                        forward_agent_id_      => forward_agent_id_,
                                        route_id_              => route_id_,
                                        wanted_delivery_date_  => wanted_delivery_date_,
                                        order_type_            => order_type_,
                                        coordinator_           => coordinator_);
            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('CUSTOMER_NAME', 'ORDER_STATUS', 'FORWARD_AGENT_NAME', 'ROUTE_DESCRIPTION', 'ORDER_TYPE_DESCRIPTION', 
                                                                    'SALESMAN_CODE', 'SALESMAN_NAME', 'DELIVERY_TERMS', 'DELIVERY_TERMS_DESC', 'SHIP_VIA_CODE', 'SHIP_VIA_CODE_DESC',
                                                                    'ORDER_REFERENCE', 'ORDER_REFERENCE_NAME', 'BILL_ADDR_NO', 'BILL_ADDR_NAME', 'SHIP_ADDR_NO', 'SHIP_ADDR_NAME')) THEN

                  IF conf_item_detail_tab_(i).data_item_detail_id = 'FORWARD_AGENT_NAME' AND forward_agent_id_ IS NOT NULL THEN 
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => Forwarder_Info_API.Get_Name(forward_agent_id_));
                  ELSIF conf_item_detail_tab_(i).data_item_detail_id = 'ROUTE_DESCRIPTION' AND route_id_ IS NOT NULL THEN 
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => Delivery_Route_API.Get_Description(route_id_));
                  ELSE 
                     Data_Capture_Order_Util_API.Add_Details_For_Order_No(capture_session_id_   => capture_session_id_,
                                                                          owning_data_item_id_  => local_data_item_id_,
                                                                          data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          order_no_             => order_no_);
                  END IF;
               END IF;
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
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF (no_of_records_handled_ = 1) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONOK: The customer order was successfully delivered.');
   ELSIF (no_of_records_handled_ > 1) THEN 
      message_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFIRMATIONSOK: :P1 customer order were successfully delivered.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
   blob_ref_tab_           Data_Capture_Common_Util_API.Blob_Ref_Tab;
   blob_data_item_value_   VARCHAR2(2000);
   lu_objid_               VARCHAR2(2000);
   del_attr_               VARCHAR2(2000);
   order_no_               VARCHAR2(12);
   image_seq_              NUMBER := 0;
BEGIN
   order_no_ := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   -- Perform delivery confirmation   
   Client_SYS.Clear_Attr(del_attr_);
   Client_SYS.Add_To_Attr('START_EVENT', 90, del_attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, del_attr_);
   Client_SYS.Add_To_Attr('END', '', del_attr_);

   Customer_Order_Flow_API.Start_Deliver__(del_attr_);

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Convert blob references from attribute string to collection for easier handling     
      blob_ref_tab_ := Data_Capt_Sess_Line_Blob_API.Get_Blob_Ref_Tab_From_Attr(blob_ref_attr_);
      IF (blob_ref_tab_.COUNT > 0) THEN
         lu_objid_ := Customer_order_API.Get(order_no_)."rowid";  -- rowid is objid.
         -- Iterate collection of blob references, extract photos, and save/connect each one to the desired object
         FOR i IN blob_ref_tab_.FIRST..blob_ref_tab_.LAST LOOP
            image_seq_ := image_seq_ + 1;
            blob_data_item_value_ := capture_session_id_ || '|' || blob_ref_tab_(i).session_line_no || '|' || blob_ref_tab_(i).blob_id; 
            Data_Capt_Sess_Line_Blob_API.Save_To_Media_Library(blob_data_item_value_ => blob_data_item_value_, 
                                                               lu_                   => 'CustomerOrder', 
                                                               lu_objid_             => lu_objid_,
                                                               name_                 => 'WADACO Deliver Customer Order '|| order_no_ || ' ' || image_seq_ ,
                                                               description_          => 'WADACO Deliver Customer Order '|| order_no_ || ' ' || image_seq_ );
         END LOOP;
      END IF;         
   $END                                                
END Execute_Process;

@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Customer_Order_Flow_API.Start_Deliver__ is granted thru following projection/action
   IF (Security_SYS.Is_Proj_Action_Available('DeliverCustomerOrders', 'StartDeliver')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;