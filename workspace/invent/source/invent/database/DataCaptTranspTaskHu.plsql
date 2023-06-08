-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptTranspTaskHu
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: PROCESS_TRANSPORT_TASK_HU
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210720  BWITLK  Bug 159950 (SCZ-15210), Modified Get_Filter_Keys___(), Create_List_Of_Values(), Validate_Data_Item(), Get_Automatic_Data_Item_Value(), 
--  210720          Add_Details_For_Latest_Item(), added new filer key to_location_no_
--  200820  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  200616  DaZase  Bug 154379 (SCZ-10396), Changes in Add_Details_For_Latest_Item and Add_Unique_Data_Item_Detail___ to support unique fetch of TO_LOCATION_NO.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  180212  DaZase  STRSC-16924, Changes in Add_Details_For_Latest_Item to support hu structure checks for LAST_LINE_ON_TRANSPORT_TASK.
--  171026  DaZase  STRSC-13037, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171026          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170614  Chfose  STRSC-8192, Modified Execute_Process to use new clob Transport_Task_Handl_Unit_API interfaces of methods 
--  170614          Pick_HU_Transport_Task, Unpick_HU_Transport_Task & Execute_Transport_Task.
--  170531  KHVESE  LIM-10758, Modified method Execute_Process to call to method Modify_Stock_Rec_Destination with check_storage_requirements_ => TRUE.
--  170316  Khvese  LIM-11175, Modified method Get_Inventory_Event_Id___() to get Inventory_Event_Id from INVENTORY_EVENT_ID_SEQ when it is null. Also modified the 
--  170316          method to construct message in it. Removed construct message from method Update_Inventory_Event_id___() and modified Execute_Process() accordingly 
--  170316  Khvese  LIM-11050, Changed the process_message type from VARCHAR2 to CLOB in all its appearances. 
--  170316          Also added capture_session_id_ and contract_ to the interface of method Post_Process_Action.
--  170314  Dazase  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   transport_task_id_          IN NUMBER,
   aggregated_line_id_         IN VARCHAR2,
   transport_task_status_db_   IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2,
   wanted_data_item_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_         VARCHAR2(200);
   decoded_column_name_  VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (wanted_data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
         decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
      ELSIF (wanted_data_item_id_ = 'DESTINATION') THEN
         decoded_column_name_ := 'DESTINATION_DB';
      ELSE
         decoded_column_name_ := wanted_data_item_id_;
      END IF;
      unique_value_ := Transport_Task_Handl_Unit_API.Get_Column_Value_If_Unique(transport_task_id_          => transport_task_id_,
                                                                                aggregated_line_id_         => aggregated_line_id_,
                                                                                transport_task_status_db_   => transport_task_status_db_, 
                                                                                from_contract_              => from_contract_,
                                                                                from_location_no_           => from_location_no_, 
                                                                                to_contract_                => to_contract_, 
                                                                                handling_unit_id_           => handling_unit_id_,
                                                                                sscc_                       => sscc_,
                                                                                alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                column_name_                => decoded_column_name_);
   $END
   IF unique_value_ = 'NULL' THEN
      unique_value_ := NULL;
   END IF;   
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;   


PROCEDURE Get_Filter_Keys___ (
   transport_task_id_          OUT NUMBER,
   aggregated_line_id_         OUT VARCHAR2,
   transport_task_status_db_   OUT VARCHAR2,
   from_contract_              OUT VARCHAR2,
   from_location_no_           OUT VARCHAR2,
   to_contract_                OUT VARCHAR2,
   to_location_no_             OUT VARCHAR2,
   handling_unit_id_           OUT NUMBER,
   sscc_                       OUT VARCHAR2,  
   alt_handling_unit_label_id_ OUT VARCHAR2,  
   capture_session_id_         IN  NUMBER,
   data_item_id_               IN  VARCHAR2,
   data_item_value_            IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_          IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_             IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_     Data_Capture_Common_Util_API.Session_Rec;
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      transport_task_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TRANSPORT_TASK_ID', session_rec_ , process_package_, use_applicable_);
      aggregated_line_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'AGGREGATED_LINE_ID', session_rec_ , process_package_, use_applicable_);
      transport_task_status_db_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TRANSPORT_TASK_STATUS', session_rec_ , process_package_, use_applicable_);
      from_contract_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_CONTRACT', session_rec_ , process_package_, use_applicable_);
      from_location_no_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      to_contract_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_CONTRACT', session_rec_ , process_package_, use_applicable_);
      to_location_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);

      
      -- Add support for alternative handling unit keys
      IF (handling_unit_id_ IS NULL AND sscc_ IS NOT NULL) THEN
         handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_);
      ELSIF (handling_unit_id_ IS NULL AND alt_handling_unit_label_id_ IS NOT NULL) THEN
         handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(alt_handling_unit_label_id_);
      END IF;
      IF (sscc_ IS NULL AND handling_unit_id_ IS NOT NULL) THEN
         sscc_ := Handling_Unit_API.Get_Sscc(handling_unit_id_);
      END IF;
      IF (alt_handling_unit_label_id_ IS NULL AND handling_unit_id_ IS NOT NULL) THEN
         alt_handling_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(handling_unit_id_);
      END IF;

      -- if sscc_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all sscc in the table
      IF (sscc_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := '%';
      END IF;
      -- if alt_handling_unit_label_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all alternative handling unit label ids in the table
      IF (alt_handling_unit_label_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := '%';
      END IF;
      -- if transport_task_status_db_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL (due to its summorized so NULL is mixed values) 
      -- so we need to specifiy that we have to compare to all statuses in the table
      IF (transport_task_status_db_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'TRANSPORT_TASK_STATUS', data_item_id_)) THEN
         transport_task_status_db_ := '%';
      END IF;
      -- if to_contract_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL (due to its summorized so NULL is mixed values)
      -- so we need to specifiy that we have to compare to all to contracts in the table
      IF (to_contract_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'TO_CONTRACT', data_item_id_)) THEN
         to_contract_ := '%';
      END IF;
      
      IF (to_location_no_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'TO_LOCATION_NO', data_item_id_)) THEN
         to_location_no_ := '%';
      END IF;
      
      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (transport_task_id_ IS NULL) THEN
            transport_task_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                                handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'TRANSPORT_TASK_ID');
         END IF;
         IF (aggregated_line_id_ IS NULL) THEN
            aggregated_line_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                                 handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'AGGREGATED_LINE_ID');
         END IF;
         IF (transport_task_status_db_ = '%') THEN
            transport_task_status_db_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                                       handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'TRANSPORT_TASK_STATUS');
         END IF;
         IF (from_contract_ IS NULL) THEN
            from_contract_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                            handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'FROM_CONTRACT');
         END IF;
         IF (from_location_no_ IS NULL) THEN
            from_location_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'FROM_LOCATION_NO');
         END IF;
         IF (to_contract_ = '%') THEN
            to_contract_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                          handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'TO_CONTRACT');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (sscc_ = '%') THEN
            sscc_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                   handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'SSCC');
         END IF;
         IF (alt_handling_unit_label_id_ = '%') THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                                         handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_         IN NUMBER,
   owning_data_item_id_        IN VARCHAR2,
   data_item_detail_id_        IN VARCHAR2,
   transport_task_id_          IN NUMBER,
   aggregated_line_id_         IN VARCHAR2,
   transport_task_status_db_   IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  
   alt_handling_unit_label_id_ IN VARCHAR2 )
IS
   detail_value_ VARCHAR2(200);
BEGIN
  $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('TRANSPORT_TASK_ID') THEN
            detail_value_ := transport_task_id_;
         WHEN ('AGGREGATED_LINE_ID') THEN
            detail_value_ := aggregated_line_id_;
         WHEN ('TRANSPORT_TASK_STATUS') THEN
            detail_value_ := transport_task_status_db_;
         WHEN ('FROM_CONTRACT') THEN
            detail_value_ := from_contract_;
         WHEN ('FROM_LOCATION_NO') THEN
            detail_value_ := from_location_no_;
         WHEN ('TO_CONTRACT') THEN
            detail_value_ := to_contract_;
         WHEN ('HANDLING_UNIT_ID') THEN
            detail_value_ := handling_unit_id_;
         WHEN ('SSCC') THEN
            detail_value_ := sscc_;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := alt_handling_unit_label_id_;
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
   data_item_detail_id_        IN VARCHAR2,
   transport_task_id_          IN NUMBER,
   aggregated_line_id_         IN VARCHAR2,
   transport_task_status_db_   IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  
   alt_handling_unit_label_id_ IN VARCHAR2 )  
IS
   detail_value_       VARCHAR2(4000);
   process_package_    VARCHAR2(30);
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
      IF (detail_value_ IS NULL AND data_item_detail_id_ IN ('TO_LOCATION_NO')) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                        handling_unit_id_, sscc_, alt_handling_unit_label_id_, data_item_detail_id_);
      END IF;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


PROCEDURE Update_Inventory_Event_id___(
   process_message_    IN OUT CLOB,
   inventory_event_id_ IN     NUMBER)
IS
BEGIN
   IF (inventory_event_id_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(process_message_, 'INVENTORY_EVENT_ID', inventory_event_id_);
   END IF;
END Update_Inventory_Event_id___;


FUNCTION Get_Inventory_Event_Id___(
   process_message_ IN OUT CLOB ) RETURN NUMBER
IS
   inventory_event_id_ NUMBER;
   number_null_        NUMBER;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      inventory_event_id_ := Message_SYS.Find_Attribute(process_message_, 'INVENTORY_EVENT_ID', number_null_);
   END IF;
  
   IF (inventory_event_id_ IS NULL) THEN 
      inventory_event_id_ := Inventory_Event_Manager_API.Get_Next_Inventory_Event_Id;
      process_message_ := Message_SYS.Construct_Clob_Message('IEID');
      Update_inventory_event_Id___(process_message_, inventory_event_id_);
   END IF;
   
   RETURN inventory_event_id_;
END Get_Inventory_Event_Id___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
   transport_task_id_           NUMBER;
   aggregated_line_id_          ROWID;
   transport_task_status_db_    VARCHAR2(200);
   from_contract_               VARCHAR2(5);
   from_location_no_            VARCHAR2(35);
   to_contract_                 VARCHAR2(5);
   to_location_no_              VARCHAR2(35);
   --destination_db_              VARCHAR2(200);
   session_contract_            VARCHAR2(5) := contract_;
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   decoded_column_name_         VARCHAR2(30);
   lov_type_db_                 VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('ACTION')) THEN
         Transport_Task_Hu_Action_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ IN ('DESTINATION')) THEN
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, from_contract_);
      ELSIF (data_item_id_ IN ('TRANSPORT_TASK_ID', 'AGGREGATED_LINE_ID', 'TRANSPORT_TASK_STATUS', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 
                               'TO_CONTRACT', 'TO_LOCATION_NO', 'DESTINATION', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN      
         Get_Filter_Keys___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_, to_location_no_,
                            handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);

         IF (data_item_id_ = 'TRANSPORT_TASK_ID' AND aggregated_line_id_ IS NULL AND 
             (transport_task_status_db_ IS NULL OR transport_task_status_db_ = '%') AND 
             from_contract_ IS NULL AND from_location_no_ IS NULL AND 
             (to_contract_ IS NULL OR to_contract_ = '%')) THEN
            -- If using subsequent and the transport task has been completly processed, transport_task_id_ has to be null to show all available transport tasks, 
            -- this works due to subsequent fetch will end up in a validation error so we end up here, its a framework bug that the validation error is not visible.
            transport_task_id_ := NULL;
         END IF;

         IF (data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
            decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
         ELSE
            decoded_column_name_ := data_item_id_;
         END IF;
         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
         -- The reason why this method have session contract as parameter while the other methods don't have it, is that we want the LOV to 
         -- only show data filtered on session contract, but it will still be possible to entered/scan manually other values so thats why 
         -- Get_Column_Value_If_Unique/Record_With_Column_Value_Exist don't have session contract as a filter/parameter. This will also mean 
         -- this LOV will not work properly for any items if user chooses another from contract than session contract, so then user 
         -- should not use LOV for any other item.
         Transport_Task_Handl_Unit_API.Create_Data_Capture_Lov(contract_                   => session_contract_,
                                                               transport_task_id_          => transport_task_id_,
                                                               aggregated_line_id_         => aggregated_line_id_,
                                                               transport_task_status_db_   => transport_task_status_db_,
                                                               from_contract_              => from_contract_,
                                                               from_location_no_           => from_location_no_,
                                                               to_contract_                => to_contract_,
                                                               to_location_no_             => to_location_no_,
                                                               handling_unit_id_           => handling_unit_id_,
                                                               sscc_                       => sscc_,
                                                               alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                               capture_session_id_         => capture_session_id_, 
                                                               column_name_                => decoded_column_name_,
                                                               lov_type_db_                => lov_type_db_);


      END IF;
   $ELSE
      NULL;
   $END
END Create_List_Of_Values;


PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   transport_task_id_          NUMBER;
   aggregated_line_id_         ROWID;
   transport_task_status_db_   VARCHAR2(200);
   from_contract_              VARCHAR2(5);
   from_location_no_           VARCHAR2(35);
   to_contract_                VARCHAR2(5);
   to_location_no_             VARCHAR2(35);
   data_item_description_      VARCHAR2(200);
   handling_unit_id_           NUMBER; 
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   decoded_column_name_        VARCHAR2(30);
   column_value_nullable_      BOOLEAN := FALSE;
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   action_                     VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      action_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'ACTION', data_item_id_);
      -- We dont need to do any validations if action is sub level or parts since then we will not execute anything, just stamp the process control on 
      -- the snapshot table for this record. But we always should validate aggregated_line_id since that is necessary even for these 2 actions. This is to make it
      -- possible to let DESTINATION, TO_CONTRACT and TO_LOCATION_NO to be NULL due to Fixed Applicable functionality due to which action was choosen.
      IF ((action_ IN (Transport_Task_Hu_Action_API.DB_PICK, Transport_Task_Hu_Action_API.DB_UNPICK, Transport_Task_Hu_Action_API.DB_EXECUTE) OR action_ IS NULL) OR 
          data_item_id_ = 'AGGREGATED_LINE_ID') THEN

         IF (data_item_id_ IN ('DESTINATION')) THEN
            Inventory_Part_Destination_API.Exist_Db(data_item_value_);

         ELSIF (data_item_id_ = 'ACTION') THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_ => TRUE);
            Transport_Task_Hu_Action_API.Exist_Db(data_item_value_);
            session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            IF (data_item_value_ IN (Transport_Task_Hu_Action_API.DB_PROCESS_SUB_LEVEL, Transport_Task_Hu_Action_API.DB_PROCESS_PARTS) AND 
               Data_Capt_Conf_Data_Item_API.Loop_Exist(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
                  Error_SYS.Record_General(lu_name_,'ACTIONANDLOOPNOTALLOWED: This action is not supported together with Loop functionality.');
            END IF;
            -- Fetch scanned values for transport_task_id_, handling_unit_id_, from_location_no_ and transport_task_status_db_ and also try unique way of fetching them if not scanned yet
             Get_Filter_Keys___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_, to_location_no_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE);
            IF (transport_task_status_db_ IS NULL AND transport_task_id_ IS NOT NULL AND 
                handling_unit_id_ IS NOT NULL AND from_location_no_ IS NOT NULL) THEN
               -- Fetch unique (compiled) transport task status value, if NULL then we handle this as a MIXED status
               transport_task_status_db_ := NVL(Transport_Task_Line_API.Get_Column_Value_If_Unique(transport_task_id_, handling_unit_id_, from_location_no_, 'TRANSPORT_TASK_STATUS', 'FALSE'),'MIXED');
            END IF;
            IF (transport_task_status_db_ IS NOT NULL) THEN
               IF ((data_item_value_ = Transport_Task_Hu_Action_API.DB_PICK AND transport_task_status_db_ != Transport_Task_Status_API.DB_CREATED) OR
                   (data_item_value_ = Transport_Task_Hu_Action_API.DB_UNPICK AND transport_task_status_db_ != Transport_Task_Status_API.DB_PICKED) OR
                   (data_item_value_ = Transport_Task_Hu_Action_API.DB_EXECUTE AND transport_task_status_db_ NOT IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED))) THEN
                  Error_SYS.Record_General(lu_name_, 'ACTIONNOTALLOWED: Action :P1 is not allowed for a Handling Unit structure in status :P2.', 
                                           Transport_Task_Hu_Action_API.Decode(data_item_value_), 
                                           Transport_Task_Status_API.Decode(transport_task_status_db_));
               END IF;
            END IF;
            IF (data_item_value_ = Transport_Task_Hu_Action_API.DB_PROCESS_SUB_LEVEL) THEN
               -- Check if the current handling unit is bottom in the structure and have part connected then Process Sub Level is not allowed
               IF (handling_unit_id_ IS NOT NULL AND NOT Handling_Unit_API.Has_Children(handling_unit_id_) AND 
                   transport_task_id_ IS NOT NULL AND Transport_Task_Line_API.Handl_Unit_Exist_On_Trans_Task(transport_task_id_,handling_unit_id_)) THEN
                  Error_SYS.Record_General(lu_name_,'BOTTOMPARTSUBNOTALLOWED: Process Sub Level is not allowed when you are in bottom of the handling unit structure then you should use Process Parts instead.');
               END IF;
            END IF;

         ELSIF data_item_id_ = 'TO_LOCATION_NO' THEN
               Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
               Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);

         ELSIF (data_item_id_ IN ('TRANSPORT_TASK_ID', 'AGGREGATED_LINE_ID', 'TRANSPORT_TASK_STATUS', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 
                                  'TO_CONTRACT', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN      
            Get_Filter_Keys___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_, to_location_no_, 
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_, data_item_value_);
            decoded_column_name_ := data_item_id_;
            IF (data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
               decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ IN ('SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'TO_CONTRACT')) THEN
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ = 'HANDLING_UNIT_ID' AND data_item_value_ > 0) THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            Transport_Task_Handl_Unit_API.Record_With_Column_Value_Exist(transport_task_id_          => transport_task_id_, 
                                                                         aggregated_line_id_         => aggregated_line_id_,
                                                                         transport_task_status_db_   => transport_task_status_db_,
                                                                         from_contract_              => from_contract_,
                                                                         from_location_no_           => from_location_no_,
                                                                         to_contract_                => to_contract_,
                                                                         handling_unit_id_           => handling_unit_id_,
                                                                         sscc_                       => sscc_,
                                                                         alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                         column_name_                => decoded_column_name_,
                                                                         column_value_               => data_item_value_,
                                                                         data_item_description_      => data_item_description_,
                                                                         column_value_nullable_      => column_value_nullable_);   -- TODO: we can probably skip column_value_nullable_ handling since the method should work with both now
         ELSIF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
         END IF;
      END IF;

   $ELSE
       NULL; 
   $END
END Validate_Data_Item;


FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 )RETURN VARCHAR2
IS
   transport_task_id_            NUMBER;
   aggregated_line_id_           ROWID;
   transport_task_status_db_     VARCHAR2(200);
   from_contract_                VARCHAR2(5);
   from_location_no_             VARCHAR2(35);
   to_contract_                  VARCHAR2(5);
   to_location_no_               VARCHAR2(35);
   automatic_value_              VARCHAR2(200);
   warehouse_task_id_            NUMBER;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   decoded_column_name_          VARCHAR2(30);
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
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

         Get_Filter_Keys___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_, to_location_no_, 
                            handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
   
         IF (data_item_id_ = 'TRANSPORT_TASK_ID') THEN
            warehouse_task_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                    data_item_id_a_     => 'WAREHOUSE_TASK_ID',
                                                                                    data_item_id_b_     => data_item_id_);
            IF (warehouse_task_id_ IS NOT NULL) THEN
               automatic_value_ := Warehouse_Task_API.Get_Source_Ref1(warehouse_task_id_);
            ELSE
               automatic_value_ := Transport_Task_Handl_Unit_API.Get_Column_Value_If_Unique(transport_task_id_          => transport_task_id_,
                                                                                            aggregated_line_id_         => aggregated_line_id_,
                                                                                            transport_task_status_db_   => transport_task_status_db_, 
                                                                                            from_contract_              => from_contract_,
                                                                                            from_location_no_           => from_location_no_, 
                                                                                            to_contract_                => to_contract_, 
                                                                                            handling_unit_id_           => handling_unit_id_,
                                                                                            sscc_                       => sscc_,
                                                                                            alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                            column_name_                => data_item_id_);
            END IF;
   
         ELSIF (data_item_id_ IN ('TRANSPORT_TASK_STATUS', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 'TO_CONTRACT', 'TO_LOCATION_NO', 
                                  'DESTINATION', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
            IF (data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
               decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
            ELSIF (data_item_id_ = 'DESTINATION') THEN
               decoded_column_name_ := 'DESTINATION_DB';
            ELSE
               decoded_column_name_ := data_item_id_;
            END IF;
            automatic_value_ := Transport_Task_Handl_Unit_API.Get_Column_Value_If_Unique(transport_task_id_          => transport_task_id_,
                                                                                         aggregated_line_id_         => aggregated_line_id_,
                                                                                         transport_task_status_db_   => transport_task_status_db_, 
                                                                                         from_contract_              => from_contract_,
                                                                                         from_location_no_           => from_location_no_, 
                                                                                         to_contract_                => to_contract_, 
                                                                                         handling_unit_id_           => handling_unit_id_,
                                                                                         sscc_                       => sscc_,
                                                                                         alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                         column_name_                => decoded_column_name_);
         END IF;
      END IF;
      RETURN automatic_value_;
   $ELSE
      RETURN NULL;
   $END
END Get_Automatic_Data_Item_Value;


@UncheckedAccess
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   transport_task_id_            NUMBER;
   aggregated_line_id_           ROWID;
   transport_task_status_db_     VARCHAR2(200);
   from_contract_                VARCHAR2(5);
   from_location_no_             VARCHAR2(35);
   to_contract_                  VARCHAR2(5);
   to_location_no_               VARCHAR2(35);
   last_line_on_transport_task_  VARCHAR2(5) := Gen_Yes_No_API.DB_NO;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   process_package_              VARCHAR2(30);
   action_                       VARCHAR2(200);
   condition_code_               VARCHAR2(10);
   part_no_                      VARCHAR2(25);
   activity_seq_                 NUMBER;
   no_unique_value_found_        BOOLEAN; 
   mixed_item_value_             VARCHAR2(25) := Language_SYS.Translate_Constant(lu_name_,'MIXEDITEM: Mixed');
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_, to_location_no_,
                         handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, latest_data_item_id_, 
                         latest_data_item_value_, use_unique_values_ => TRUE);   

      session_rec_          := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,                                                                                     
                                                                             data_item_id_       => latest_data_item_id_ );

      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP

            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
            -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('TRANSPORT_TASK_ID', 'AGGREGATED_LINE_ID', 'TRANSPORT_TASK_STATUS', 
                                                                    'FROM_CONTRACT', 'FROM_LOCATION_NO', 'TO_CONTRACT',  
                                                                    'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN

                  sscc_ := CASE sscc_ WHEN '%' THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  to_contract_ := CASE to_contract_ WHEN '%' THEN NULL ELSE to_contract_ END;      -- % if it is not scanned yet
                  transport_task_status_db_ := CASE transport_task_status_db_ WHEN '%' THEN NULL ELSE transport_task_status_db_ END;      -- % if it is not scanned yet

                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           transport_task_id_          => transport_task_id_,
                                           aggregated_line_id_         => aggregated_line_id_,
                                           transport_task_status_db_   => transport_task_status_db_,
                                           from_contract_              => from_contract_,
                                           from_location_no_           => from_location_no_,
                                           to_contract_                => to_contract_,
                                           handling_unit_id_           => handling_unit_id_,
                                           sscc_                       => sscc_,  
                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_);

               ELSE
                  -- Data Items that are not part of the filter keys  (like TO_LOCATION_NO, DESTINATION, WAREHOUSE_TASK_ID, ACTION)
                  Add_Unique_Data_Item_Detail___(capture_session_id_         => capture_session_id_,
                                                 session_rec_                => session_rec_,
                                                 owning_data_item_id_        => latest_data_item_id_,
                                                 owning_data_item_value_     => latest_data_item_value_,
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                                 transport_task_id_          => transport_task_id_,
                                                 aggregated_line_id_         => aggregated_line_id_,
                                                 transport_task_status_db_   => transport_task_status_db_,
                                                 from_contract_              => from_contract_,
                                                 from_location_no_           => from_location_no_,
                                                 to_contract_                => to_contract_,
                                                 handling_unit_id_           => handling_unit_id_,
                                                 sscc_                       => sscc_,  
                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_); 
                END IF;
            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('FROM_LOCATION_GROUP', 'FROM_WAREHOUSE','FROM_BAY_ID',
                                                                    'FROM_ROW_ID','FROM_TIER_ID','FROM_BIN_ID', 'FROM_LOCATION_NO_DESC')) THEN
   
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => from_contract_, 
                                                                           location_no_         => from_location_no_);
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TO_LOCATION_GROUP', 'TO_WAREHOUSE','TO_BAY_ID',
                                                                       'TO_ROW_ID','TO_TIER_ID','TO_BIN_ID', 'TO_LOCATION_NO_DESC')) THEN

                  process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
                  to_location_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, latest_data_item_id_, latest_data_item_value_, 'TO_LOCATION_NO', session_rec_ , process_package_, TRUE);
                  IF (to_location_no_ IS NULL) THEN
                     to_location_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, aggregated_line_id_, transport_task_status_db_, from_contract_, from_location_no_, to_contract_,
                                                                      handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'TO_LOCATION_NO');
                  END IF;
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => to_contract_, 
                                                                           location_no_         => to_location_no_);  
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'LAST_LINE_ON_TRANSPORT_TASK') THEN                   

                  action_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'ACTION', latest_data_item_id_);
                  IF (Transport_Task_Handl_Unit_API.Lines_Left_To_Execute(transport_task_id_) = 1 AND 
                      (action_ IN (Transport_Task_Hu_Action_API.DB_PROCESS_SUB_LEVEL,Transport_Task_Hu_Action_API.DB_PROCESS_PARTS, 
                                   Transport_Task_Hu_Action_API.DB_PICK, Transport_Task_Hu_Action_API.DB_UNPICK))) THEN
                     last_line_on_transport_task_ := Gen_Yes_No_API.DB_NO; -- These actions means that we are not finished yet so this is not the last line on pick list
                  ELSIF (action_ = Transport_Task_Hu_Action_API.DB_EXECUTE) THEN -- Execute action
                     IF ((Handling_Unit_API.Get_Root_Handling_Unit_Id(handling_unit_id_) = handling_unit_id_)  AND 
                         handling_unit_id_ IS NOT NULL) THEN    -- Checking handling unit structure if current hu is root
                        IF (Transport_Task_Handl_Unit_API.Last_Hndl_Unit_Structure_On_TT(transport_task_id_, handling_unit_id_)) THEN
                           last_line_on_transport_task_ := Gen_Yes_No_API.DB_YES; -- This hu is root hu and all remaing lines belongs to this structure
                        ELSE
                           last_line_on_transport_task_ := Gen_Yes_No_API.DB_NO; -- Part lines still exist not connected to hu or all remaining hu's dont belong to this structure
                        END IF;
                     ELSIF (Transport_Task_Handl_Unit_API.Lines_Left_To_Execute(transport_task_id_) = 1 ) THEN
                        last_line_on_transport_task_ := Gen_Yes_No_API.DB_YES;
                     ELSE
                        last_line_on_transport_task_ := Gen_Yes_No_API.DB_NO;
                     END IF;
                  ELSE
                     last_line_on_transport_task_ := Gen_Yes_No_API.DB_NO;
                  END IF;
                  Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                    data_item_id_        => latest_data_item_id_,
                                                    data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                    data_item_value_     => last_line_on_transport_task_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TOP_PARENT_HANDLING_UNIT_TYPE_ID','TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                                       'HANDLING_UNIT_TYPE_CATEG_DESC', 'HANDLING_UNIT_TYPE_DESC', 'HANDLING_UNIT_TYPE_ID',
                                                                       'HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
                                                                       'HANDLING_UNIT_TYPE_STACKABLE')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_LOCATION_TYPE', 'HANDLING_UNIT_LOCATION_NO_DESC', 'HANDLING_UNIT_COMPOSITION',
                                                                       'HANDLING_UNIT_DEPTH', 'HANDLING_UNIT_HEIGHT', 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                                       'HANDLING_UNIT_OPERATIVE_VOLUME', 'HANDLING_UNIT_STRUCTURE_LEVEL', 'HANDLING_UNIT_UOM_LENGTH',
                                                                       'HANDLING_UNIT_UOM_WEIGHT', 'HANDLING_UNIT_UOM_VOLUME', 'HANDLING_UNIT_WIDTH',
                                                                       'PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_SSCC',
                                                                       'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID', 'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 
                                                                       'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);

               -- ELSIFs below are all summarized/group details for the current handling unit and its structure, so they might not have a unique value if they are different
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('ACTIVITY_SEQ', 'CONDITION_CODE', 'CONFIGURATION_ID',
                                                                       'ENG_CHG_LEVEL', 'LOT_BATCH_NO', 'OWNERSHIP', 'OWNER', 'OWNER_NAME',
                                                                       'PART_NO', 'SERIAL_NO', 'WAIV_DEV_REJ_NO')) THEN
                          
                  Data_Capture_Invent_Util_API.Add_Detail_For_Hand_Unit_Stock(capture_session_id_   => capture_session_id_,
                                                                              owning_data_item_id_  => latest_data_item_id_,
                                                                              data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              contract_             => from_contract_,
                                                                              location_no_          => from_location_no_,
                                                                              handling_unit_id_     => handling_unit_id_);
                                                                       

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE_DESCRIPTION')) THEN
                  condition_code_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                      handling_unit_id_,
                                                                                      'CONDITION_CODE');
                  IF (no_unique_value_found_ = FALSE AND condition_code_ IS NULL) THEN
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => mixed_item_value_);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Condition_Code_Desc(capture_session_id_, latest_data_item_id_, conf_item_detail_tab_(i).data_item_detail_id, condition_code_);
                  END IF ; 

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS', 'UNIT_MEAS')) THEN
                  part_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                               handling_unit_id_,
                                                                               'PART_NO');
                  IF (no_unique_value_found_ = FALSE AND part_no_ IS NULL) THEN
                     
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => mixed_item_value_);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                          owning_data_item_id_  => latest_data_item_id_,
                                                                          data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          contract_             => from_contract_,
                                                                          part_no_              => part_no_);
                  END IF ; 

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY', 'CATCH_QUANTITY', 'ORDER_TYPE', 'ORDER_REF1', 
                                                                       'ORDER_REF2', 'ORDER_REF3', 'ORDER_REF4', 'CREATE_DATE')) THEN
                          
                  Data_Capture_Invent_Util_API.Add_Detail_For_Hand_Unit_Trans(capture_session_id_   => capture_session_id_,
                                                                              owning_data_item_id_  => latest_data_item_id_,
                                                                              data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              from_contract_        => from_contract_,
                                                                              handling_unit_id_     => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID', 'SUB_PROJECT_DESCRIPTION', 
                                                                       'ACTIVITY_ID', 'ACTIVITY_DESCRIPTION', 'PROGRAM_ID', 'PROGRAM_DESCRIPTION')) THEN

                  activity_seq_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                                    handling_unit_id_,
                                                                                    'ACTIVITY_SEQ');

                  IF (no_unique_value_found_ = FALSE AND activity_seq_ IS NULL) THEN
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => mixed_item_value_);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Activity_Seq(capture_session_id_   => capture_session_id_,
                                                                               owning_data_item_id_  => latest_data_item_id_,
                                                                               data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                               activity_seq_         => activity_seq_);
                  END IF ; 

               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;



PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY CLOB,
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2 )
IS
   ptr_                    NUMBER;
   name_                   VARCHAR2(50);
   value_                  VARCHAR2(4000);
   transport_task_id_      NUMBER;
   aggregated_line_id_     ROWID;
   action_                 VARCHAR2(200);
   from_location_no_       VARCHAR2(35);
   to_location_no_         VARCHAR2(35);
   handling_unit_id_       NUMBER;
   inventory_event_id_     NUMBER;
   destination_db_         VARCHAR2(200);
   stock_keys_tab_         Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   hu_message_             CLOB;

BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'TRANSPORT_TASK_ID') THEN
         transport_task_id_ := value_;
      ELSIF (name_ = 'AGGREGATED_LINE_ID') THEN
         aggregated_line_id_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_;
      ELSIF (name_ = 'ACTION') THEN
         action_ := value_;
      ELSIF (name_ = 'FROM_LOCATION_NO') THEN
         from_location_no_ := value_;
      ELSIF (name_ = 'TO_LOCATION_NO') THEN
         to_location_no_ := value_;
      ELSIF (name_ = 'DESTINATION') THEN
         destination_db_ := value_;
      END IF;
   END LOOP;
   
   inventory_event_id_ := Get_inventory_event_id___(process_message_);
   Inventory_Event_Manager_API.Set_Session_Id(inventory_event_id_);
   
   -- Handle change of to location_no or destination (
   IF ((to_location_no_ IS NOT NULL AND to_location_no_ != NVL(Transport_Task_Line_API.Get_Column_Value_If_Unique(transport_task_id_, handling_unit_id_, from_location_no_, 'TO_LOCATION_NO', 'FALSE'), 'MIXED')) OR
      (destination_db_ IS NOT NULL AND destination_db_ != NVL(Transport_Task_Line_API.Get_Column_Value_If_Unique(transport_task_id_, handling_unit_id_, from_location_no_, 'DESTINATION', 'FALSE'), 'MIXED'))) THEN
      -- Fetching stock record collection
      stock_keys_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);
      -- Modifying any affected transport task lines
      IF (stock_keys_tab_.COUNT > 0) THEN
         FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
            Transport_Task_Line_API.Modify_Stock_Rec_Destination(transport_task_id_          => transport_task_id_,
                                                                 from_contract_              => stock_keys_tab_(i).contract,
                                                                 part_no_                    => stock_keys_tab_(i).part_no,
                                                                 configuration_id_           => stock_keys_tab_(i).configuration_id,
                                                                 from_location_no_           => stock_keys_tab_(i).location_no,
                                                                 lot_batch_no_               => stock_keys_tab_(i).lot_batch_no,
                                                                 serial_no_                  => stock_keys_tab_(i).serial_no,
                                                                 eng_chg_level_              => stock_keys_tab_(i).eng_chg_level,
                                                                 waiv_dev_rej_no_            => stock_keys_tab_(i).waiv_dev_rej_no,
                                                                 activity_seq_               => stock_keys_tab_(i).activity_seq,
                                                                 handling_unit_id_           => stock_keys_tab_(i).handling_unit_id,
                                                                 to_contract_                => NULL,  -- Will not be updated if we send in NULL. But if this will be updateable in this process in the future send in data item instead.
                                                                 to_location_no_             => to_location_no_,
                                                                 forward_to_location_no_     => NULL,  -- Will not be updated if we send in NULL.
                                                                 destination_db_             => destination_db_,
                                                                 check_storage_requirements_ => TRUE);
         END LOOP;
      END IF;
   END IF;
   
   hu_message_ := Message_SYS.Construct('');
   Message_SYS.Add_Attribute(hu_message_, 'TRANSPORT_TASK_ID', transport_task_id_);
   Message_SYS.Add_Attribute(hu_message_, 'HANDLING_UNIT_ID', handling_unit_id_);

   IF (action_ = Transport_Task_Hu_Action_API.DB_PICK) THEN
      Transport_Task_Handl_Unit_API.Pick_HU_Transport_Task(message_ => hu_message_);
   ELSIF (action_ = Transport_Task_Hu_Action_API.DB_UNPICK) THEN
      Transport_Task_Handl_Unit_API.Unpick_HU_Transport_Task(message_ => hu_message_);
   ELSIF (action_ = Transport_Task_Hu_Action_API.DB_EXECUTE) THEN
      Transport_Task_Handl_Unit_API.Execute_Transport_Task(message_ => hu_message_);
   ELSIF (action_ = Transport_Task_Hu_Action_API.DB_PROCESS_SUB_LEVEL) THEN
      Handl_Unit_Stock_Snapshot_API.Modify_Process_Control(objid_           => aggregated_line_id_,
                                                           process_control_ => 'PROCESS_SUB_LEVEL');
   ELSIF (action_ = Transport_Task_Hu_Action_API.DB_PROCESS_PARTS) THEN
      Handl_Unit_Stock_Snapshot_API.Modify_Process_Control(objid_           => aggregated_line_id_,
                                                           process_control_ => 'PROCESS_PARTS',
                                                           modify_children_ => TRUE);
   END IF;

END Execute_Process;


PROCEDURE Post_Process_Action(
   process_message_     IN OUT CLOB,
   capture_session_id_  IN NUMBER,
   contract_            IN VARCHAR2 )
IS
   inventory_event_id_ NUMBER;
   number_null_        NUMBER;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      inventory_event_id_ := Message_SYS.Find_Attribute(process_message_, 'INVENTORY_EVENT_ID', number_null_);
      IF (inventory_event_id_ IS NOT NULL) THEN
         Inventory_Event_Manager_API.Finish(inventory_event_id_);
      END IF;
   END IF;
END Post_Process_Action;


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'TRANSPORTTASKHU: The action was performed on the Transport Task Handling Unit.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'TRANSPORTTASKHUS: The action was performed on :P1 Transport Task Handling Units.',NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


PROCEDURE Set_Media_Id_For_Data_Item  (
   capture_session_id_  IN NUMBER,
   line_no_             IN NUMBER,
   data_item_id_        IN VARCHAR2, 
   data_item_value_     IN VARCHAR2 )       
IS
BEGIN
   Data_Capture_Invent_Util_API.Set_Media_Id_For_Data_Item (capture_session_id_, line_no_, data_item_id_, data_item_value_);
END Set_Media_Id_For_Data_Item ;


PROCEDURE Validate_Configuration (
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER ) 
IS
   conf_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Tab;
   invalid_configuration_   BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Find all data item that have feedback item LAST_LINE_ON_PICK_LIST as a detail item
      conf_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_ALL_Collection(capture_process_id_, capture_config_id_, NULL, 'LAST_LINE_ON_TRANSPORT_TASK');
      IF (conf_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_detail_tab_.FIRST..conf_detail_tab_.LAST  LOOP
            -- If any item that have LAST_LINE_ON_TRANSPORT_TASK as detail comes before ACTION data items configuration is invalid, 
            -- because we need to know the action to evaluate and set LAST_LINE_ON_TRANSPORT_TASK correctly. 
            IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_, 
                                                           capture_config_id_  => capture_config_id_, 
                                                           data_item_id_a_     => conf_detail_tab_(i).data_item_id, 
                                                           data_item_id_b_     => 'ACTION')) THEN
               invalid_configuration_ := TRUE;
               EXIT;
            END IF;
         END LOOP;
      END IF;
      IF invalid_configuration_ THEN
         Error_SYS.Record_General(lu_name_,'LASTLINEUSEDBEFOREACTION: The Feedback item :P1 should only be used on or after the data item :P2 in the Configuration.',
                                  Data_Capt_Proc_Feedba_Item_API.Get_Description(capture_process_id_, 'LAST_LINE_ON_TRANSPORT_TASK'),
                                  Data_Capt_Proc_Data_Item_API.Get_Description(capture_process_id_, 'ACTION'));
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Configuration;


@UncheckedAccess
FUNCTION Subseq_Session_Start_Allowed (
   capture_session_id_            IN NUMBER, 
   subsequent_capture_process_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   subseq_session_start_allowed_ BOOLEAN := TRUE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- This control is only made if next process is Start Warehouse Task
      IF (subsequent_capture_process_id_ = 'START_WAREHOUSE_TASK') THEN
         -- We are only allowed to jump to Start Warehouse Task process if WAREHOUSE_TASK_ID have a value, if it don't have value we return FALSE
         IF (Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'WAREHOUSE_TASK_ID') IS NULL) THEN
            subseq_session_start_allowed_ := FALSE;
         END IF;
      END IF;
   $END
   
   RETURN subseq_session_start_allowed_;
END Subseq_Session_Start_Allowed;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Transport_Task_Handl_Unit_API.Pick_HU_Transport_Task is granted thru following projection/action
   -- Check to see that API method Transport_Task_Handl_Unit_API.Unpick_HU_Transport_Task is granted thru following projection/action
   -- Check to see that API method Transport_Task_Handl_Unit_API.Execute_Transport_Task is granted thru following projection/action
   IF (Security_SYS.Is_Proj_Action_Available('HandlingUnitsOnTransportTasksHandling', 'Pick') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'PickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'PickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'PickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsOnTransportTasksHandling', 'Unpick') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'UnpickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'UnpickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'UnpickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsOnTransportTasksHandling', 'Execute') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'ExecuteAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'ExecuteAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'ExecuteAggregatedHandlingUnits')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   action_                      VARCHAR2(200);
   fixed_value_is_applicable_   BOOLEAN := FALSE;
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      action_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'ACTION', session_rec_ , process_package_, use_applicable_ => FALSE);

   $END

   IF (data_item_id_ IN ('TO_CONTRACT','TO_LOCATION_NO','DESTINATION')) THEN            
      IF (action_ IN (Transport_Task_Hu_Action_API.DB_PROCESS_SUB_LEVEL, Transport_Task_Hu_Action_API.DB_PROCESS_PARTS)) THEN
         fixed_value_is_applicable_ := TRUE;  -- to contract/location and destination not necessary when using these 2 actions
      END IF;
   END IF;
   
   RETURN fixed_value_is_applicable_;
END Fixed_Value_Is_Applicable;


 
