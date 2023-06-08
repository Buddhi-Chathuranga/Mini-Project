-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptTranspTaskPart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: PROCESS_TRANSPORT_TASK_PART
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210705  Moinlk  Bug 159673 (SCZ-14915), Added data item id ORDER_TYPE to the process and modified necessary methods to support the change.
--  210323  DaZase  Bug 158553 (SCZ-14065), Added DESTINATION handling in Execute_Process so we can support changing its value on the Transport Task Line.
--  200820  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  190129  ChBnlk  Bug 146164 (SCZ-2948), Modified Execute_Process() by passing value for the parameter 'updated_by_client_' in the method call Transport_Task_Line_API.Modify_Quantity(). 
--  181019  BudKlk  Bug 143097, Modified the method Add_Details_For_Latest_Item to add new feedback items CONDITION_CODE and CONDITION_CODE_DESCRIPTION.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171129  CKumlk  STRSC-14828, Added GTIN to Add_Filter_Key_Detail___.
--  171120  DaZase  STRSC-8865, Removed Check_Task_Line_Stock_Keys___ and replaced the call to in Validate_Data_Item___ with extra call to Transport_Task_Line_API.Record_With_Column_Value_Exist 
--  171120          for BARCODE_ID, Added extra GTIN validation in Validate_Data_Item___ against the current Transport Task Line record. 
--  170918  SURBLK  STRSC-12150, Added Validation for the GTIN data Item in Validate_Data_Item___.
--  170915  DaZase  STRSC-11606, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  170915          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170822  SURBLK  STRSC-9613, Added Get_Input_Uom_Sql_Whr_Exprs___() and added GTIN to Get_Filter_Keys___().
--  170719  SURBLK  STRSC-9614, Implemented GTIN support, Adding GTIN, INPUT_UOM and INPUT_QUANTITY data items 
--  170719          and INPUT_CONV_FACTOR as feedback item and GTIN_IS_MANDATORY as detail item.
--  170512  DaZase  STRSC-7912, Added automatic handling of CATCH_QUANTITY so stock CATCH_QTY_ONHAND will be fetched if reserved quantity is the same as the transport task quantity.
--  170418  DaZase  LIM-10662, Changes in Get_Filter_Keys___ on how Bug 132004 was solved, now we check if inventory barcode is enabled correctly. 
--  170328  DaZase  LIM-11233, Renamed LU from DataCaptProcTransTask to DataCaptTranspTaskPart.
--  170316  Khvese  LIM-11175, Modified method Get_Inventory_Event_Id___() to get Inventory_Event_Id from INVENTORY_EVENT_ID_SEQ when it is null
--  170316          Also modified the method to construct message correctly.  
--  170316  Khvese  LIM-11050, Changed the process_message type from VARCHAR2 to CLOB in all its appearances. 
--  170316          Also added capture_session_id_ and contract_ to the interface of method Post_Process_Action.
--  170302  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170118  SWiclk  Bug 132477, Modified Add_Create_Date___() by removing the conversion of date to char since it will be handled in data_capture_session_line_api.
--  170113  DaZase  LIM-8660, Added a catch quantity validation in Validate_Data_Item___.  
--  161214  RuLiLk  Bug 133126, Modified method Validate_Data_Item to not allow NULL values for TO_LOCATION_NO.
--  161108  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161010  SWiclk  Bug 132004, Modified Get_Filter_Keys___() and Validate_Data_Item() in order to check whether  
--  161010          Barcode Id is mandatory or not before trying to fetch a unique value.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160219  SWiclk  Bug 127172, Modified Validate_Data_Item___() in order to check Barcode_ID is mandatory if configured in process detail.
--  160210  SWiclk  Bug 126749, Added Check_Task_Line_Stock_Keys___() and modified Validate_Data_Item___() in order to compare barcode  
--  160210          values against Transport Task Line data to indentify whether the correct barcode has been used.
--  151124  SWiclk  STRSC-328, Modified Validate_Data_Item() and Validate_Data_Item___() in order to validate quantity when quantity entered 
--  151124          exceeds available qty + transport task line qty (because transport task line qty is already been reserved).
--  151104  DaZase  LIM-4287, Added handling for new data items HANDLING_UNIT_ID, SSCC and ALT_HANDLING_UNIT_LABEL_ID. Added calls 
--  151104          to Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type, Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit 
--  151104          in Add_Details_For_Latest_Item due to many new feedback items.
--  150803  SWiclk  Bug 121254, Modified Get_Unique_Data_Item_Value___(), Validate_Data_Item___() and Create_List_Of_Values() by changing the parameter list 
--  150803          of methods which are from Inventory_Part_Barcode_API since the contract has been changed as a parentkey.
--  150422  MaEelk  LIM-1274, Added handling_unit_id to necessary Transport_Task_Line_API method calls.
--  150217  JeLise  PRSC-6086, Modified Create_List_Of_Values for data_item_id_ 'TRANSPORT_TASK_ID'.
--  150213  JeLise  PRSC-6066, Added check on no_of_unidentified_serials_ in Validate_Data_Item___.
--  141218  Erlise  PRSC-4581, Added Update_Putaway_Event_Id___, Get_Putaway_Event_Id___, Post_Process_Action.
--  141218          Modified the execute action in method Execute_Process to keep execution of selected transport task lines in the same session.
--  141201  DaZase  PRSC-4409, Added Subseq_Session_Start_Allowed.
--  141106  DaZase  PRSC-4009, Changed Fixed_Value_Is_Applicable so it now fetches predicted and unique part_no.
--  141022  JeLise  Added call to Transport_Task_Line_API.Get_Number_Of_Lines to fetch the value for LAST_LINE_ON_TRANSPORT_TASK 
--  141022          in Add_Details_For_Latest_Item.
--  141020  DaZase  PRSC-3324, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___ and Add_Details_For_Latest_Item. 
--  141020          Replaced Get_Data_Item_Value___ with new method Get_Unique_Data_Item_Value___. Replaced Add_Unique_Detail___ with new methods Add_Filter_Key_Detail___/Add_Unique_Data_Item_Detail___. 
--  141008  DaZase  PRSC-63, Changed Get_Automatic_Data_Item_Value, Create_List_Of_Values and Validate_Data_Item to now use methods in Inventory_Part_Barcode_API for BARCODE_ID.
--  141008  RiLase  Renamed from DataCaptTrasTaskLine to DataCaptProcTransTask.
--  140916  DaZase  PRSC-2781, Changes in process to reflect that TRANSPORT_TASK_STATUS/ACTION/DESTINATION data items now have their enumeration db values saved on session line.
--  140908  RiLase  Removed empty methods since the wadaco framework now can handle when methods doesn't exist.
--  140908  RiLase  PRSC-2497, Added Fixed_Value_Is_Applicable().
--  140905  JeLise  PRSC-2366, Added fetch of warehouse_task_id when data_item_id is TRANSPORT_TASK_ID in Get_Automatic_Data_Item_Value.
--  140827  DaZase  PRSC-1655, Added Validate_Config_Data_Item.
--  140815  Dazase  PRSC-1611, Removed Apply_Additional_Line_Content since it is now obsolete and Get_Automatic_Data_Item_Value can be used instead. 
--  140812  DaZase  PRSC-1611, Renamed Add_Lines_For_Latest_Data_Item to Add_Details_For_Latest_Item.
--  140811  DaZase  PRSC-1611, Changed call Transport_Task_Line_API.Check_Valid_Value to Transport_Task_Line_API.Record_With_Column_Value_Exist.
--  140805  DaZase  PRSC-1431, Changed part_no_ to VARCHAR2(25) and eng_chg_level_ to VARCHAR2(6).
--  140620  SWiclk  PRSC-1867, Bug 117179, Modified Get_Process_Execution_Message() and Execute_Process() by adding parameter process_message_
--  140620          and parameters process_message_ and blob_ref_attr_ respectively.
--  140527  SWiclk  Bug 117038, Modified Execute_Process() by increasing the length of action_ to 200 since translated default/fixed values may exceed 7 characters. 
--  140523  SWiclk  Bug 117038, Modified Validate_Data_Item___(), Create_List_Of_Values(), Get_Automatic_Data_Item_Value() and Add_Lines_For_Latest_Data_Item() by
--  140523          increasing the length of variable transport_task_status_ (200) since translated values may exceeed 8 characters and fixed value allow 200 characters.
--  140523          Modified Execute_Process() by introducing an error message to handle null value of action data item.                                                                              
--  131014  RuLiLk  Bug 113060, Modified method Get_Automatic_Data_Item_Value()
--  131014          to fetch quantity automatically from transport task line for non-serial tracking parts
--  130114  RILASE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   transport_task_id_          IN NUMBER,
   line_no_                    IN NUMBER,
   transport_task_status_      IN VARCHAR2,
   order_type_db_              IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   to_location_no_             IN VARCHAR2,
   destination_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   configuration_id_           IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   wanted_data_item_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_         VARCHAR2(200);
   decoded_column_name_  VARCHAR2(30);
   dummy_                BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (wanted_data_item_id_ = 'BARCODE_ID' OR (barcode_id_ IS NOT NULL AND  
          wanted_data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ'))) THEN
         unique_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => from_contract_,
                                                                                barcode_id_       => barcode_id_,
                                                                                part_no_          => part_no_,
                                                                                configuration_id_ => configuration_id_,
                                                                                lot_batch_no_     => lot_batch_no_,
                                                                                serial_no_        => serial_no_,
                                                                                eng_chg_level_    => eng_chg_level_,
                                                                                waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                activity_seq_     => activity_seq_,
                                                                                column_name_      => wanted_data_item_id_);
      ELSE
         IF (wanted_data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
            decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
         ELSIF(wanted_data_item_id_ = 'ORDER_TYPE') THEN
            decoded_column_name_ := 'ORDER_TYPE_DB';
         ELSIF (wanted_data_item_id_ = 'DESTINATION') THEN
            decoded_column_name_ := 'DESTINATION_DB';
         ELSE
            decoded_column_name_ := wanted_data_item_id_;
         END IF;
         unique_value_ := Transport_Task_Line_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                             transport_task_id_          => transport_task_id_, 
                                                                             line_no_                    => line_no_, 
                                                                             transport_task_status_db_   => transport_task_status_,
                                                                             order_type_db_              => order_type_db_,
                                                                             part_no_                    => part_no_, 
                                                                             from_contract_              => from_contract_,
                                                                             from_location_no_           => from_location_no_, 
                                                                             to_contract_                => to_contract_, 
                                                                             destination_db_             => destination_, 
                                                                             serial_no_                  => serial_no_, 
                                                                             lot_batch_no_               => lot_batch_no_, 
                                                                             eng_chg_level_              => eng_chg_level_,
                                                                             waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                                             activity_seq_               => activity_seq_, 
                                                                             handling_unit_id_           => handling_unit_id_,
                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                             configuration_id_           => configuration_id_, 
                                                                             column_name_                => decoded_column_name_);
      END IF;
      IF (unique_value_ = 'NULL') THEN
         unique_value_ := NULL;
      END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;   


PROCEDURE Get_Filter_Keys___ (
   transport_task_id_          OUT NUMBER,
   line_no_                    OUT NUMBER,
   transport_task_status_      OUT VARCHAR2,
   order_type_db_              OUT VARCHAR2,
   part_no_                    OUT VARCHAR2,
   from_contract_              OUT VARCHAR2,
   from_location_no_           OUT VARCHAR2,
   to_contract_                OUT VARCHAR2,
   to_location_no_             OUT VARCHAR2,   -- not used for filtering in unique handling  
   destination_                OUT VARCHAR2,
   serial_no_                  OUT VARCHAR2,
   lot_batch_no_               OUT VARCHAR2,
   eng_chg_level_              OUT VARCHAR2,
   waiv_dev_rej_no_            OUT VARCHAR2,
   activity_seq_               OUT NUMBER,
   configuration_id_           OUT VARCHAR2,
   barcode_id_                 OUT NUMBER,
   gtin_no_                    OUT VARCHAR2,
   handling_unit_id_           OUT NUMBER,
   sscc_                       OUT VARCHAR2,  -- not used for filtering in unique handling
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
      line_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LINE_NO', session_rec_ , process_package_, use_applicable_);
      transport_task_status_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TRANSPORT_TASK_STATUS', session_rec_ , process_package_, use_applicable_);
      order_type_db_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ORDER_TYPE', session_rec_ , process_package_, use_applicable_);
      from_contract_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_CONTRACT', session_rec_ , process_package_, use_applicable_);
      from_location_no_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      to_contract_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_CONTRACT', session_rec_ , process_package_, use_applicable_);
      to_location_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      destination_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'DESTINATION', session_rec_ , process_package_, use_applicable_);
      part_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_             := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      activity_seq_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
      configuration_id_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);

      -- Also fetch predicted barcode_id since this process can use barcodes
      barcode_id_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'BARCODE_ID', session_rec_ , process_package_, use_applicable_);
      gtin_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);           
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

      -- if alt_handling_unit_label_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all alternative handling unit label ids in the table
      IF (alt_handling_unit_label_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := '%';
      END IF;
      -- Since Order Type could be nullable in Transport Task Line Table this code checks whether the end user entered null deliberately for order_type
      -- If not, all order types needs to be considered to filter out data
      IF (order_type_db_ IS NULL AND
         NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ORDER_TYPE', data_item_id_)) THEN
         order_type_db_ := '%';
      END IF;
      
      IF (gtin_no_ IS NULL AND Data_Capture_Invent_Util_API.Gtin_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
         gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      END IF;
      
      IF ((part_no_ IS NULL) AND (gtin_no_ IS NOT NULL)) THEN
         part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_); 
      END IF;

      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (transport_task_id_ IS NULL) THEN
            transport_task_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                                serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'TRANSPORT_TASK_ID');
         END IF;
         IF (line_no_ IS NULL) THEN
            line_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                      serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LINE_NO');
         END IF;
         IF (transport_task_status_ IS NULL) THEN
            transport_task_status_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                                    serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'TRANSPORT_TASK_STATUS');
         END IF;
         IF (order_type_db_ IS NULL OR order_type_db_ = '%') THEN
            order_type_db_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                         serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ORDER_TYPE');
         END IF;
         IF (from_contract_ IS NULL) THEN
            from_contract_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                            serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'FROM_CONTRACT');
         END IF;
         IF (from_location_no_ IS NULL) THEN
            from_location_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                               serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'FROM_LOCATION_NO');
         END IF;
         IF (to_contract_ IS NULL) THEN
            to_contract_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                          serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'TO_CONTRACT');
         END IF;
         IF (to_location_no_ IS NULL) THEN
            to_location_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                             serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'TO_LOCATION_NO');
         END IF;
         IF (destination_ IS NULL) THEN
            destination_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                          serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'DESTINATION');
         END IF;
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                      serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                        serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                           serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                            serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                              serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                           serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ACTIVITY_SEQ');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                               serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                               serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                               serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                         serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'BARCODE_ID');
         END IF;
         -- SSCC not included in the unique fetch 
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
   line_no_                    IN NUMBER,
   transport_task_status_      IN VARCHAR2,
   order_type_db_              IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   to_location_no_             IN VARCHAR2,
   destination_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   configuration_id_           IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   gtin_no_                    IN VARCHAR2 ) 
IS
   detail_value_ VARCHAR2(200);
BEGIN
  $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)

         WHEN ('TRANSPORT_TASK_ID') THEN
            detail_value_ := transport_task_id_;
         WHEN ('LINE_NO') THEN
            detail_value_ := line_no_;
         WHEN ('TRANSPORT_TASK_STATUS') THEN
            detail_value_ := transport_task_status_;
         WHEN('ORDER_TYPE') THEN
            detail_value_ := order_type_db_;
         WHEN ('PART_NO') THEN
            detail_value_ := part_no_;
         WHEN ('FROM_CONTRACT') THEN
            detail_value_ := from_contract_;
         WHEN ('FROM_LOCATION_NO') THEN
            detail_value_ := from_location_no_;
         WHEN ('TO_CONTRACT') THEN
            detail_value_ := to_contract_;
         WHEN ('TO_LOCATION_NO') THEN
            detail_value_ := to_location_no_;
         WHEN ('DESTINATION') THEN
            detail_value_ := destination_;
         WHEN ('SERIAL_NO') THEN
            detail_value_ := serial_no_;
         WHEN ('LOT_BATCH_NO') THEN
            detail_value_ := lot_batch_no_;
         WHEN ('ENG_CHG_LEVEL') THEN
            detail_value_ := eng_chg_level_;
         WHEN ('WAIV_DEV_REJ_NO') THEN
            detail_value_ := waiv_dev_rej_no_;
         WHEN ('ACTIVITY_SEQ') THEN
            detail_value_ := activity_seq_;
         WHEN ('CONFIGURATION_ID') THEN
            detail_value_ := configuration_id_;
         WHEN ('HANDLING_UNIT_ID') THEN
            detail_value_ := handling_unit_id_;
         WHEN ('SSCC') THEN
            detail_value_ := sscc_;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := alt_handling_unit_label_id_;
         WHEN ('BARCODE_ID') THEN
            detail_value_ := barcode_id_;
         WHEN ('GTIN') THEN
            detail_value_ := gtin_no_;
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
   line_no_                    IN NUMBER,
   transport_task_status_      IN VARCHAR2,
   order_type_db_              IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   to_location_no_             IN VARCHAR2,
   destination_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   configuration_id_           IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER )  
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
      IF (detail_value_ IS NULL AND data_item_detail_id_ = 'QUANTITY' AND 
          Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                        serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, data_item_detail_id_);
      END IF;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


PROCEDURE Validate_Data_Item___ (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   transport_task_id_          NUMBER;
   line_no_                    NUMBER;
   transport_task_status_      VARCHAR2(200);
   order_type_db_              VARCHAR2(200);
   part_no_                    VARCHAR2(25);
   from_contract_              VARCHAR2(5);
   from_location_no_           VARCHAR2(35);
   to_contract_                VARCHAR2(5);
   to_location_no_             VARCHAR2(35);
   destination_                VARCHAR2(200);
   serial_no_                  VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   eng_chg_level_              VARCHAR2(6);
   waiv_dev_rej_no_            VARCHAR2(15);
   activity_seq_               NUMBER;
   configuration_id_           VARCHAR2(50);
   barcode_id_                 NUMBER;
   data_item_description_      VARCHAR2(200);
   no_of_unidentified_serials_ NUMBER;
   handling_unit_id_           NUMBER; 
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   decoded_column_name_        VARCHAR2(30);
   column_value_nullable_      BOOLEAN := FALSE;
   qty_available_              NUMBER;
   trans_task_line_qty_        NUMBER;
   qty_onhand_                 NUMBER;
   qty_reserved_               NUMBER;
   dummy_                      BOOLEAN;
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   process_package_            VARCHAR2(30);
   catch_quantity_             NUMBER;
   input_unit_meas_group_id_   VARCHAR2(30);
   gtin_no_                    VARCHAR2(14);
   gtin_part_no_               VARCHAR2(25);
   local_part_no_              VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('DESTINATION')) THEN
         Inventory_Part_Destination_API.Exist_Db(data_item_value_);
      ELSE
         IF (data_item_id_ = 'BARCODE_ID') THEN
            IF (data_item_value_ IS NOT NULL) THEN              
               -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
               Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_,
                                  from_location_no_, to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_,
                                  eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, barcode_id_, gtin_no_,
                                  handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_,
                                  data_item_value_, use_unique_values_ => TRUE);
            END IF;            
         ELSE
            Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_,
                               from_location_no_, to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_,
                               eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, barcode_id_, gtin_no_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_, data_item_value_);
         END IF;

         IF (data_item_id_ IN ('PART_NO','CATCH_QUANTITY')) THEN
            session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
            catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QUANTITY', session_rec_ , process_package_);
            Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                         current_data_item_id_      => data_item_id_,
                                                         part_no_data_item_id_      => 'PART_NO',
                                                         part_no_data_item_value_   => part_no_,
                                                         catch_qty_data_item_id_    => 'CATCH_QUANTITY',
                                                         catch_qty_data_item_value_ => catch_quantity_,
                                                         positive_catch_qty_        => TRUE);

         END IF;
   
         IF (data_item_id_ = 'BARCODE_ID') THEN
            Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
            IF (data_item_value_ IS NOT NULL) THEN
               data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
               Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_           => from_contract_,
                                                                         barcode_id_         => data_item_value_,
                                                                         part_no_            => part_no_,
                                                                         configuration_id_   => configuration_id_,
                                                                         lot_batch_no_       => lot_batch_no_,
                                                                         serial_no_          => serial_no_,
                                                                         eng_chg_level_      => eng_chg_level_,
                                                                         waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                         activity_seq_       => activity_seq_,
                                                                         column_name_        => data_item_id_,
                                                                         column_value_       => data_item_value_,
                                                                         column_description_ => data_item_description_);
            
               Transport_Task_Line_API.Record_With_Column_Value_Exist(transport_task_id_          => transport_task_id_, 
                                                                      line_no_                    => line_no_,
                                                                      transport_task_status_db_   => transport_task_status_,
                                                                      order_type_db_              => order_type_db_,
                                                                      part_no_                    => part_no_,
                                                                      from_contract_              => from_contract_,
                                                                      from_location_no_           => from_location_no_,
                                                                      to_contract_                => to_contract_,
                                                                      serial_no_                  => serial_no_,
                                                                      lot_batch_no_               => lot_batch_no_,
                                                                      eng_chg_level_              => eng_chg_level_,
                                                                      waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                      activity_seq_               => activity_seq_,
                                                                      handling_unit_id_           => handling_unit_id_,
                                                                      alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                      configuration_id_           => configuration_id_,
                                                                      column_name_                => NULL,
                                                                      column_value_               => NULL,
                                                                      data_item_description_      => data_item_description_,
                                                                      inv_barcode_validation_     => TRUE);
            END IF;
         ELSIF (barcode_id_ IS NOT NULL AND data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ')) THEN
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_           => from_contract_,
                                                                      barcode_id_         => barcode_id_,
                                                                      part_no_            => part_no_,
                                                                      configuration_id_   => configuration_id_,
                                                                      lot_batch_no_       => lot_batch_no_,
                                                                      serial_no_          => serial_no_,
                                                                      eng_chg_level_      => eng_chg_level_,
                                                                      waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                      activity_seq_       => activity_seq_,
                                                                      column_name_        => data_item_id_,
                                                                      column_value_       => data_item_value_,
                                                                      column_description_ => data_item_description_);        
         
         ELSIF (data_item_id_ IN ('CATCH_QUANTITY')) THEN
            NULL; -- only here so we dont do the Transport_Task_Line_API.Record_With_Column_Value_Exist else part later in this code
         ELSIF (data_item_id_ = 'QUANTITY') THEN
            qty_onhand_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                  contract_                   => from_contract_,
                                                                                  part_no_                    => part_no_,
                                                                                  configuration_id_           => configuration_id_,
                                                                                  location_no_                => from_location_no_,
                                                                                  lot_batch_no_               => lot_batch_no_,
                                                                                  serial_no_                  => serial_no_,
                                                                                  eng_chg_level_              => eng_chg_level_,
                                                                                  waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                  activity_seq_               => activity_seq_,
                                                                                  handling_unit_id_           => handling_unit_id_,
                                                                                  alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                  column_name_                => 'QTY_ONHAND');
   
   
            qty_reserved_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                    contract_                   => from_contract_,
                                                                                    part_no_                    => part_no_,
                                                                                    configuration_id_           => configuration_id_,
                                                                                    location_no_                => from_location_no_,
                                                                                    lot_batch_no_               => lot_batch_no_,
                                                                                    serial_no_                  => serial_no_,
                                                                                    eng_chg_level_              => eng_chg_level_,
                                                                                    waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                    activity_seq_               => activity_seq_,
                                                                                    handling_unit_id_           => handling_unit_id_,
                                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                    column_name_                => 'QTY_RESERVED');
            
            -- check qty_available
            IF (qty_onhand_ IS NOT NULL AND qty_reserved_ IS NOT NULL ) THEN
               qty_available_ := qty_onhand_ - qty_reserved_;                                                                      
               trans_task_line_qty_ := Transport_Task_Line_API.Get_Column_Value_If_Unique(dummy_,
                                                                                          transport_task_id_, 
                                                                                          line_no_, 
                                                                                          transport_task_status_,
                                                                                          order_type_db_,
                                                                                          part_no_, 
                                                                                          from_contract_,
                                                                                          from_location_no_, 
                                                                                          to_contract_, 
                                                                                          destination_, 
                                                                                          serial_no_, 
                                                                                          lot_batch_no_, 
                                                                                          eng_chg_level_,
                                                                                          waiv_dev_rej_no_, 
                                                                                          activity_seq_,
                                                                                          handling_unit_id_,
                                                                                          alt_handling_unit_label_id_,
                                                                                          configuration_id_, 
                                                                                          'QUANTITY');
                                                                               
               IF (data_item_value_ > (qty_available_ + trans_task_line_qty_)) THEN                  
                  Error_SYS.Record_General(lu_name_, 'NOTENOUGHQTY: The additional quantity available to reserve is  :P1', qty_available_);
               END  IF;
            END IF; 
         ELSIF (data_item_id_ = 'INPUT_UOM') THEN            
            IF (data_item_value_ IS NOT NULL) THEN      
               input_unit_meas_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(from_contract_, part_no_);
               Input_Unit_Meas_API.Record_With_Column_Value_Exist(input_unit_meas_group_id_ => input_unit_meas_group_id_,
                                                                  column_name_              => 'UNIT_CODE',
                                                                  column_value_             => data_item_value_,
                                                                  column_description_       => data_item_description_,
                                                                  sql_where_expression_     => Get_Input_Uom_Sql_Whr_Exprs___); 
            END IF;
         ELSIF (data_item_id_ = 'GTIN') THEN            
               Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                               data_item_id_,
                                                               data_item_value_); 
            -- Extra gtin validation since the one in Data_Capture_Invent_Util_API.Validate_Data_Item is not enough
            gtin_part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(data_item_value_);
            IF (gtin_part_no_ IS NOT NULL) THEN
               local_part_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                   data_item_id_a_     => 'PART_NO',
                                                                                   data_item_id_b_     => data_item_id_);
               IF (local_part_no_ IS NULL)  THEN
                  -- Sending NULL for part_no and all items that can be applicable handled and are part_no connected
                  -- since these could have gotten their values from the gtin in Get_Filter_Keys___ that might not be correct.
                  -- The transport_task_id_ and line_no_ are the important filter keys here since they will point out 1 record.
                  local_part_no_ := Get_Unique_Data_Item_Value___(transport_task_id_     => transport_task_id_, 
                                                                  line_no_               => line_no_, 
                                                                  transport_task_status_ => transport_task_status_,
                                                                  order_type_db_         => order_type_db_,
                                                                  part_no_               => NULL, 
                                                                  from_contract_         => from_contract_, 
                                                                  from_location_no_      => from_location_no_, 
                                                                  to_contract_           => to_contract_, 
                                                                  to_location_no_        => to_location_no_, 
                                                                  destination_           => destination_, 
                                                                  serial_no_             => NULL, 
                                                                  lot_batch_no_          => NULL, 
                                                                  eng_chg_level_         => eng_chg_level_, 
                                                                  waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                                  activity_seq_          => activity_seq_, 
                                                                  configuration_id_      => NULL, 
                                                                  handling_unit_id_      => handling_unit_id_, 
                                                                  alt_handling_unit_label_id_ => alt_handling_unit_label_id_, 
                                                                  barcode_id_            => barcode_id_, 
                                                                  wanted_data_item_id_   => 'PART_NO');

               END IF;
               IF (local_part_no_ IS NOT NULL AND gtin_part_no_ != local_part_no_)  THEN
                  -- This error is needed, since the part taken from GTIN dont match the already scanned part or the part that the unique record points to.
                  Error_SYS.Record_General(lu_name_, 'GTINDONTMATCH: The GTIN No does not match current Report Picking Line.');
               END IF;
            END IF;

         ELSE
            decoded_column_name_ := data_item_id_;
            IF (data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
               decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
            ELSIF (data_item_id_ = 'ORDER_TYPE') THEN
               decoded_column_name_ := 'ORDER_TYPE_DB';
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ = 'DESTINATION') THEN
               decoded_column_name_ := 'DESTINATION_DB';
            ELSIF (data_item_id_ IN ('SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ = 'HANDLING_UNIT_ID' AND data_item_value_ > 0) THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            Transport_Task_Line_API.Record_With_Column_Value_Exist(transport_task_id_          => transport_task_id_, 
                                                                   line_no_                    => line_no_,
                                                                   transport_task_status_db_   => transport_task_status_,
                                                                   order_type_db_              => order_type_db_,
                                                                   part_no_                    => part_no_,
                                                                   from_contract_              => from_contract_,
                                                                   from_location_no_           => from_location_no_,
                                                                   to_contract_                => to_contract_,
                                                                   serial_no_                  => serial_no_,
                                                                   lot_batch_no_               => lot_batch_no_,
                                                                   eng_chg_level_              => eng_chg_level_,
                                                                   waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                   activity_seq_               => activity_seq_,
                                                                   handling_unit_id_           => handling_unit_id_,
                                                                   alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                   configuration_id_           => configuration_id_,
                                                                   column_name_                => decoded_column_name_,
                                                                   column_value_               => data_item_value_,
                                                                   data_item_description_      => data_item_description_,
                                                                   column_value_nullable_      => column_value_nullable_);
            IF (data_item_id_ = 'LINE_NO') THEN
               no_of_unidentified_serials_ := Transport_Task_Line_API.Get_No_Of_Unidentified_Serials(transport_task_id_, line_no_);
               IF (no_of_unidentified_serials_ > 0) THEN
                  Error_SYS.Record_General(lu_name_, 'TASKNOTHANDLED: Transport Task :P1 cannot be executed since it involves :P2 unidentified serials for part :P3.',
                                           transport_task_id_, no_of_unidentified_serials_, Transport_Task_Line_API.Get_Part_No(transport_task_id_, line_no_));
               END IF;
            END IF;
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item___;


PROCEDURE Add_Create_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   transport_task_id_   IN NUMBER,
   line_no_             IN NUMBER)
IS
   create_date_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      create_date_ := Transport_Task_Line_API.Get_Create_Date(transport_task_id_, line_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => 'CREATE_DATE',
                                        data_item_value_       => create_date_,
                                        data_item_data_type_   => 'Date');
   $ELSE
       NULL;
   $END
END Add_Create_Date___;


PROCEDURE Update_Inventory_Event_id___(
   process_message_     IN OUT CLOB,
   inventory_event_id_  NUMBER)
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


FUNCTION Get_Input_Uom_Sql_Whr_Exprs___  RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(32000);
BEGIN   
   sql_where_expression_  := ' AND (purch_usage_allowed = 1 OR cust_usage_allowed = 1 OR manuf_usage_allowed = 1) ';  
   RETURN sql_where_expression_;
END Get_Input_Uom_Sql_Whr_Exprs___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   transport_task_id_ NUMBER;
   line_no_           NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('TRANSPORT_TASK_ID', 'LINE_NO', 'TRANSPORT_TASK_STATUS', 'ORDER_TYPE', 'PART_NO', 'FROM_CONTRACT',
                            'FROM_LOCATION_NO', 'TO_CONTRACT', 'DESTINATION', 'SERIAL_NO', 'LOT_BATCH_NO',
                            'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'CONFIGURATION_ID', 'BARCODE_ID',
                            'INPUT_UOM', 'GTIN', 'QUANTITY', 'CATCH_QUANTITY', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN      
         Validate_Data_Item___(capture_session_id_, data_item_id_, data_item_value_);
      ELSIF (data_item_id_ = 'ACTION') THEN
         Transport_Task_Action_API.Exist_Db(data_item_value_);
         transport_task_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                 data_item_id_a_     => 'TRANSPORT_TASK_ID',
                                                                                 data_item_id_b_     => data_item_id_);
         line_no_           := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                 data_item_id_a_     => 'LINE_NO',
                                                                                 data_item_id_b_     => data_item_id_);
         Transport_Task_Line_API.Check_Action_Allowed(transport_task_id_, line_no_, data_item_value_);
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      ELSE
         IF data_item_id_ = 'TO_LOCATION_NO' THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
         END IF;
         Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
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
   transport_task_id_           NUMBER;
   line_no_                     NUMBER;
   transport_task_status_       VARCHAR2(200);
   order_type_db_               VARCHAR2(200);
   part_no_                     VARCHAR2(25);
   from_contract_               VARCHAR2(5);
   from_location_no_            VARCHAR2(35);
   to_contract_                 VARCHAR2(5);
   to_location_no_              VARCHAR2(35);
   destination_                 VARCHAR2(200);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   eng_chg_level_               VARCHAR2(6);
   waiv_dev_rej_no_             VARCHAR2(15);
   activity_seq_                NUMBER;
   configuration_id_            VARCHAR2(50);
   session_contract_            VARCHAR2(5);
   barcode_id_                  NUMBER;
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   decoded_column_name_         VARCHAR2(30);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   lov_id_                      NUMBER := 1;
   lov_type_db_                 VARCHAR2(20);
   input_uom_group_id_          VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('ACTION')) THEN
         Transport_Task_Action_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ IN ('DESTINATION')) THEN
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, from_contract_);       
      ELSE
         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_,
                               from_location_no_, to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_,
                               eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, barcode_id_, gtin_no_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_,
                               data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_,
                               from_location_no_, to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_,
                               eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, barcode_id_, gtin_no_, 
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
         END IF;

         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
         session_contract_ := contract_;
         
         IF ((data_item_id_ = 'BARCODE_ID') OR 
              barcode_id_ IS NOT NULL AND data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ')) THEN
            Inventory_Part_Barcode_API.Create_Data_Capture_Lov(contract_           => from_contract_,
                                                               barcode_id_         => barcode_id_,
                                                               part_no_            => part_no_,
                                                               configuration_id_   => configuration_id_,
                                                               lot_batch_no_       => lot_batch_no_,
                                                               serial_no_          => serial_no_,
                                                               eng_chg_level_      => eng_chg_level_,
                                                               waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                               activity_seq_       => activity_seq_,
                                                               capture_session_id_ => capture_session_id_, 
                                                               column_name_        => data_item_id_,
                                                               lov_type_db_        => lov_type_db_);
         ELSIF (data_item_id_ IN ('INPUT_UOM')) THEN  
            input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
            Input_Unit_Meas_API.Create_Data_Capture_Lov(capture_session_id_, input_uom_group_id_, 'UNIT_CODE', lov_type_db_, Get_Input_Uom_Sql_Whr_Exprs___);                                                       
         ELSE
            -- If TRANSPORT_TASK_ID and LINE NO is not null a line can be uniquely identified with just those two keys.
            -- This is done so that TO_LOCATION can be changed and still be used as a filter if it comes before TRANSPORT_TASK_ID or LINE_NO in the configuration.
            IF (transport_task_id_ IS NOT NULL AND line_no_ IS NOT NULL) THEN
               to_location_no_ := NULL;
            END IF;

            IF (data_item_id_ = 'TRANSPORT_TASK_ID' AND line_no_ IS NULL AND transport_task_status_ IS NULL AND part_no_ IS NULL AND from_contract_ IS NULL AND from_location_no_ IS NULL
                AND to_contract_ IS NULL AND serial_no_ IS NULL AND lot_batch_no_ IS NULL) THEN
               -- If using subsequent and the transport task has been completly processed, transport_task_id_ has to be null to show all available transport tasks,
               -- this works due to subsequent fetch will end up in a validation error so we end up here, its a framework bug that the validation error is not visible.
               transport_task_id_ := NULL;
            END IF;
            IF (data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
               decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
            ELSIF(data_item_id_ = 'ORDER_TYPE') THEN
               decoded_column_name_ := 'ORDER_TYPE_DB';
            ELSE
               decoded_column_name_ := data_item_id_;
            END IF;

            -- Need to check if this process is run standalone or if its run together with START_TRANSPORT_TASK. If START_TRANSPORT_TASK is 
            -- the previous session this process is run together with START_TRANSPORT_TASK. Then we need to change the lov_id_ so we can 
            -- break the normal sorting and exchange it with route order sorting so location and handling units will be grouped together better.
            session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            IF (Data_Capture_Session_API.Get_Capture_Process_Id(session_rec_.previous_capture_session_id ) = 'START_TRANSPORT_TASK') THEN
               lov_id_ := 2;
            END IF;
            
            -- The reason why this method have session contract as parameter while the other methods don't have it, is that we want the LOV to 
            -- only show data filtered on session contract, but it will still be possible to entered/scan manually other values so thats why 
            -- Get_Column_Value_If_Unique/Record_With_Column_Value_Exist don't have session contract as a filter/parameter. This will also mean 
            -- this LOV will not work properly for any items if user chooses another from contract than session contract, so then user 
            -- should not use LOV for any other item.

            Transport_Task_Line_API.Create_Data_Capture_Lov(contract_                   => session_contract_,
                                                            transport_task_id_          => transport_task_id_, 
                                                            line_no_                    => line_no_,
                                                            transport_task_status_db_   => transport_task_status_,
                                                            order_type_db_              => order_type_db_,
                                                            part_no_                    => part_no_,
                                                            from_contract_              => from_contract_,
                                                            from_location_no_           => from_location_no_,
                                                            to_contract_                => to_contract_,
                                                            to_location_no_             => to_location_no_,
                                                            destination_db_             => destination_,
                                                            serial_no_                  => serial_no_,
                                                            lot_batch_no_               => lot_batch_no_,
                                                            eng_chg_level_              => eng_chg_level_,
                                                            waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                            activity_seq_               => activity_seq_,
                                                            handling_unit_id_           => handling_unit_id_,
                                                            alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                            configuration_id_           => configuration_id_,
                                                            capture_session_id_         => capture_session_id_, 
                                                            column_name_                => decoded_column_name_,
                                                            lov_type_db_                => lov_type_db_,
                                                            lov_id_                     => lov_id_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Create_List_Of_Values;


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'TRANSPORTTASKLINEOK: The Transport Task Line action was performed.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'TRANSPORTTASKLINES: The action was performed on :P1 Transport Task Lines.',NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 )RETURN VARCHAR2
IS
   transport_task_id_            NUMBER;
   line_no_                      NUMBER;
   transport_task_status_        VARCHAR2(200);
   order_type_db_                VARCHAR2(200);
   part_no_                      VARCHAR2(25);
   from_contract_                VARCHAR2(5);
   from_location_no_             VARCHAR2(35);
   to_contract_                  VARCHAR2(5);
   to_location_no_               VARCHAR2(35);
   destination_                  VARCHAR2(200);
   serial_no_                    VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   eng_chg_level_                VARCHAR2(6);
   waiv_dev_rej_no_              VARCHAR2(15);
   activity_seq_                 NUMBER;
   configuration_id_             VARCHAR2(50);
   automatic_value_              VARCHAR2(200);
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   barcode_id_                   NUMBER;
   warehouse_task_id_            NUMBER;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   dummy_                        BOOLEAN;
   decoded_column_name_          VARCHAR2(30);
   quantity_                     NUMBER;
   stock_qty_reserved_           NUMBER;
   gtin_no_                      VARCHAR2(14);
   input_uom_                    VARCHAR2(30);
   input_uom_group_id_           VARCHAR2(30);
   input_qty_                    NUMBER;
   input_conv_factor_            NUMBER;
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

         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_,
                               from_location_no_, to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_,
                               eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, barcode_id_, gtin_no_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_,
                               data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_,
                               from_location_no_, to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_,
                               eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, barcode_id_, gtin_no_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
         END IF;

         IF (data_item_id_ = 'TRANSPORT_TASK_ID') THEN
            warehouse_task_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                    data_item_id_a_     => 'WAREHOUSE_TASK_ID',
                                                                                    data_item_id_b_     => data_item_id_);
            IF (warehouse_task_id_ IS NOT NULL) THEN
               automatic_value_ := Warehouse_Task_API.Get_Source_Ref1(warehouse_task_id_);
            ELSE
               automatic_value_ := Transport_Task_Line_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                      transport_task_id_          => transport_task_id_, 
                                                                                      line_no_                    => line_no_, 
                                                                                      transport_task_status_db_   => transport_task_status_,
                                                                                      order_type_db_              => order_type_db_,
                                                                                      part_no_                    => part_no_, 
                                                                                      from_contract_              => from_contract_,
                                                                                      from_location_no_           => from_location_no_, 
                                                                                      to_contract_                => to_contract_, 
                                                                                      destination_db_             => destination_, 
                                                                                      serial_no_                  => serial_no_, 
                                                                                      lot_batch_no_               => lot_batch_no_, 
                                                                                      eng_chg_level_              => eng_chg_level_,
                                                                                      waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                                                      activity_seq_               => activity_seq_, 
                                                                                      handling_unit_id_           => handling_unit_id_,
                                                                                      alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                      configuration_id_           => configuration_id_, 
                                                                                      column_name_                => data_item_id_);
   
            END IF;
         ELSIF (data_item_id_ = 'BARCODE_ID') THEN
            automatic_value_ := barcode_id_;
   
         ELSIF ((data_item_id_ IN ('LINE_NO', 'TRANSPORT_TASK_STATUS', 'ORDER_TYPE', 'PART_NO', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 'TO_CONTRACT',
                                   'TO_LOCATION_NO', 'DESTINATION', 'SERIAL_NO', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ',
                                   'CONFIGURATION_ID', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID'))
                  OR ((data_item_id_ = 'QUANTITY') AND (Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING))) THEN
   
               IF (barcode_id_ IS NOT NULL AND  
                   data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ')) THEN
                  automatic_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => from_contract_,
                                                                                            barcode_id_       => barcode_id_,
                                                                                            part_no_          => part_no_,
                                                                                            configuration_id_ => configuration_id_,
                                                                                            lot_batch_no_     => lot_batch_no_,
                                                                                            serial_no_        => serial_no_,
                                                                                            eng_chg_level_    => eng_chg_level_,
                                                                                            waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                            activity_seq_     => activity_seq_,
                                                                                            column_name_      => data_item_id_);
               ELSE                
                  IF (data_item_id_ = 'TRANSPORT_TASK_STATUS') THEN
                     decoded_column_name_ := 'TRANSPORT_TASK_STATUS_DB';
                  ELSIF(data_item_id_ = 'ORDER_TYPE') THEN
                     decoded_column_name_ := 'ORDER_TYPE_DB';
                  ELSIF (data_item_id_ = 'DESTINATION') THEN
                     decoded_column_name_ := 'DESTINATION_DB';
                  ELSE
                     decoded_column_name_ := data_item_id_;
                  END IF;
                  
                  IF data_item_id_= 'QUANTITY' THEN
                     input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                  data_item_id_a_     => 'INPUT_UOM',
                                                                                  data_item_id_b_     => data_item_id_);
   
                     input_qty_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                     data_item_id_a_     => 'INPUT_QUANTITY',
                                                                                     data_item_id_b_     => data_item_id_);
                     IF (input_uom_ IS NOT NULL) AND (input_qty_ IS NOT NULL) THEN
                        input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(from_contract_, part_no_);
                        input_conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_id_, input_uom_);
                        automatic_value_ := input_qty_ * input_conv_factor_;
                     END IF;               
                  
                  END IF;
                  
                  IF automatic_value_ IS NULL THEN
                     automatic_value_ := Transport_Task_Line_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                            transport_task_id_          => transport_task_id_, 
                                                                                            line_no_                    => line_no_, 
                                                                                            transport_task_status_db_   => transport_task_status_,
                                                                                            order_type_db_              => order_type_db_,
                                                                                            part_no_                    => part_no_, 
                                                                                            from_contract_              => from_contract_,
                                                                                            from_location_no_           => from_location_no_, 
                                                                                            to_contract_                => to_contract_, 
                                                                                            destination_db_             => destination_, 
                                                                                            serial_no_                  => serial_no_, 
                                                                                            lot_batch_no_               => lot_batch_no_, 
                                                                                            eng_chg_level_              => eng_chg_level_,
                                                                                            waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                                                            activity_seq_               => activity_seq_, 
                                                                                            handling_unit_id_           => handling_unit_id_,
                                                                                            alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                            configuration_id_           => configuration_id_, 
                                                                                            column_name_                => decoded_column_name_);
                  END IF;                                                                          
               END IF;   
         ELSIF (data_item_id_= 'INPUT_UOM') THEN
            input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(from_contract_, part_no_);
            IF (input_uom_group_id_ IS NOT NULL) THEN
               IF (gtin_no_ IS NOT NULL) THEN
                  automatic_value_ := Part_Gtin_Unit_Meas_API.Get_Unit_Code_For_Gtin14(gtin_no_);              
               END IF;
               IF (automatic_value_ IS NULL) THEN               
                  automatic_value_ := Input_Unit_Meas_API.Get_Column_Value_If_Unique(input_unit_meas_group_id_ => input_uom_group_id_,
                                                                                     column_name_              => 'UNIT_CODE',
                                                                                     sql_where_expression_     => Get_Input_Uom_Sql_Whr_Exprs___);
               END IF;
            ELSE
               automatic_value_ := 'NULL';
            END IF;   
         ELSIF (data_item_id_= 'INPUT_QUANTITY') THEN
            session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                            data_item_id_a_     => 'INPUT_UOM',
                                                                            data_item_id_b_     => data_item_id_);
            IF ((input_uom_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'INPUT_UOM', 'INPUT_QUANTITY'))
                OR (Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(from_contract_, part_no_) IS NULL) THEN            
               automatic_value_ := 'NULL';                     
            END IF; 
         ELSIF (data_item_id_= 'GTIN') THEN         
            automatic_value_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
            IF (part_no_ IS NOT NULL AND automatic_value_ IS NULL) THEN            
               automatic_value_ := 'NULL';                     
            END IF;
         ELSIF (data_item_id_ IN ('CATCH_QUANTITY', 'QUANTITY')) THEN
            automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, from_contract_, part_no_);
            IF (data_item_id_ = 'CATCH_QUANTITY' AND automatic_value_ IS NULL AND 
                Fnd_Boolean_API.DB_TRUE = Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_)) THEN
               quantity_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'QUANTITY', 'CATCH_QUANTITY');
               stock_qty_reserved_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                            contract_                   => from_contract_,
                                                                                            part_no_                    => part_no_,
                                                                                            configuration_id_           => configuration_id_,
                                                                                            location_no_                => from_location_no_,                                                                                 
                                                                                            lot_batch_no_               => lot_batch_no_,
                                                                                            serial_no_                  => serial_no_,
                                                                                            eng_chg_level_              => eng_chg_level_,
                                                                                            waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                            activity_seq_               => activity_seq_,
                                                                                            handling_unit_id_           => handling_unit_id_,
                                                                                            alt_handling_unit_label_id_ => alt_handling_unit_label_id_, 
                                                                                            column_name_                => 'QTY_RESERVED');
               -- If transport task quantity = stock reserved quantity then return the whole catch quantity onhand as automatic value for catch quantity
               IF (quantity_ = stock_qty_reserved_) THEN
                  automatic_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                             contract_                   => from_contract_,
                                                                                             part_no_                    => part_no_,
                                                                                             configuration_id_           => configuration_id_,
                                                                                             location_no_                => from_location_no_,                                                                                 
                                                                                             lot_batch_no_               => lot_batch_no_,
                                                                                             serial_no_                  => serial_no_,
                                                                                             eng_chg_level_              => eng_chg_level_,
                                                                                             waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                             activity_seq_               => activity_seq_,
                                                                                             handling_unit_id_           => handling_unit_id_,
                                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_, 
                                                                                             column_name_                => 'CATCH_QTY_ONHAND');
               END IF;
   
            END IF;
   
         END IF;

      END IF;
      
      RETURN automatic_value_;
   $ELSE
      RETURN NULL;
   $END
END Get_Automatic_Data_Item_Value;


PROCEDURE Set_Media_Id_For_Data_Item  (
   capture_session_id_  IN NUMBER,
   line_no_             IN NUMBER,
   data_item_id_        IN VARCHAR2, 
   data_item_value_     IN VARCHAR2 )       
IS
BEGIN
   Data_Capture_Invent_Util_API.Set_Media_Id_For_Data_Item (capture_session_id_, line_no_, data_item_id_, data_item_value_);
END Set_Media_Id_For_Data_Item ;



@UncheckedAccess
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   transport_task_id_            NUMBER;
   line_no_                      NUMBER;
   transport_task_status_        VARCHAR2(200);
   order_type_db_                VARCHAR2(200);
   part_no_                      VARCHAR2(25);
   from_contract_                VARCHAR2(5);
   from_location_no_             VARCHAR2(35);
   to_contract_                  VARCHAR2(5);
   to_location_no_               VARCHAR2(35);
   destination_                  VARCHAR2(200);
   serial_no_                    VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   eng_chg_level_                VARCHAR2(6);
   waiv_dev_rej_no_              VARCHAR2(15);
   activity_seq_                 NUMBER;
   configuration_id_             VARCHAR2(50);
   barcode_id_                   NUMBER;
   gtin_no_                      VARCHAR2(14);
   last_line_on_transport_task_  VARCHAR2(5) := Gen_Yes_No_API.DB_NO;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   condition_code_               VARCHAR2(10);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, 
                         to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, 
                         activity_seq_, configuration_id_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                         capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);   
      session_rec_          := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,                                                                                     
                                                                             data_item_id_       => latest_data_item_id_ );

      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP

            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
            -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('TRANSPORT_TASK_ID', 'LINE_NO', 'TRANSPORT_TASK_STATUS', 'ORDER_TYPE', 'PART_NO', 'FROM_CONTRACT',
                                                                    'FROM_LOCATION_NO', 'TO_CONTRACT', 'TO_LOCATION_NO', 'DESTINATION', 'SERIAL_NO', 
                                                                    'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 
                                                                    'BARCODE_ID', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN

                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  order_type_db_ :=  CASE order_type_db_ WHEN '%' THEN NULL ELSE order_type_db_ END;
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           transport_task_id_          => transport_task_id_,
                                           line_no_                    => line_no_,
                                           transport_task_status_      => transport_task_status_,
                                           order_type_db_              => order_type_db_,
                                           part_no_                    => part_no_,
                                           from_contract_              => from_contract_,
                                           from_location_no_           => from_location_no_,
                                           to_contract_                => to_contract_,
                                           to_location_no_             => to_location_no_,
                                           destination_                => destination_,
                                           serial_no_                  => serial_no_,
                                           lot_batch_no_               => lot_batch_no_,
                                           eng_chg_level_              => eng_chg_level_,
                                           waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                           activity_seq_               => activity_seq_,
                                           configuration_id_           => configuration_id_,
                                           handling_unit_id_           => handling_unit_id_,
                                           sscc_                       => sscc_,  
                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                           barcode_id_                 => barcode_id_,
                                           gtin_no_                    => gtin_no_);
               ELSE
                  -- Data Items that are not part of the filter keys  (like QUANTITY, CATCH_QUANTITY etc)
                  Add_Unique_Data_Item_Detail___(capture_session_id_         => capture_session_id_,
                                                 session_rec_                => session_rec_,
                                                 owning_data_item_id_        => latest_data_item_id_,
                                                 owning_data_item_value_     => latest_data_item_value_,
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                                 transport_task_id_          => transport_task_id_,
                                                 line_no_                    => line_no_,
                                                 transport_task_status_      => transport_task_status_,
                                                 order_type_db_              => order_type_db_,
                                                 part_no_                    => part_no_,
                                                 from_contract_              => from_contract_,
                                                 from_location_no_           => from_location_no_,
                                                 to_contract_                => to_contract_,
                                                 to_location_no_             => to_location_no_,
                                                 destination_                => destination_,
                                                 serial_no_                  => serial_no_,
                                                 lot_batch_no_               => lot_batch_no_,
                                                 eng_chg_level_              => eng_chg_level_,
                                                 waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                 activity_seq_               => activity_seq_,
                                                 configuration_id_           => configuration_id_,
                                                 handling_unit_id_           => handling_unit_id_,
                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                 barcode_id_                 => barcode_id_);                                                
                END IF;
            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id = 'CREATE_DATE') THEN
                  Add_Create_Date___(capture_session_id_        => capture_session_id_, 
                                     owning_data_item_id_       => latest_data_item_id_,
                                     transport_task_id_         => transport_task_id_,
                                     line_no_                   => line_no_);
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN( 'PART_NO_DESCRIPTION', 'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 
                                                                       'UNIT_MEAS_DESCRIPTION', 'PART_TYPE', 'PRIME_COMMODITY', 'PRIME_COMMODITY_DESCRIPTION', 
                                                                       'SECOND_COMMODITY', 'SECOND_COMMODITY_DESCRIPTION', 'ASSET_CLASS', 'ASSET_CLASS_DESCRIPTION', 
                                                                       'PART_STATUS', 'PART_STATUS_DESCRIPTION', 'ABC_CLASS', 'ABC_CLASS_PERCENT', 'SAFETY_CODE', 
                                                                       'SAFETY_CODE_DESCRIPTION', 'ACCOUNTING_GROUP', 'PRODUCT_CODE_DESCRIPTION', 'PRODUCT_FAMILY', 
                                                                       'PRODUCT_FAMILY_DESCRIPTION', 'SERIAL_TRACKING_RECEIPT_ISSUE', 'SERIAL_TRACKING_INVENTORY', 
                                                                       'SERIAL_TRACKING_DELIVERY', 'STOP_ARRIVAL_ISSUED_SERIAL', 'STOP_NEW_SERIAL_IN_RMA', 
                                                                       'SERIAL_RULE', 'LOT_BATCH_TRACKING', 'LOT_QUANTITY_RULE', 'SUB_LOT_RULE',
                                                                       'COMPONENT_LOT_RULE', 'GTIN_IDENTIFICATION', 'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN
   
                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       contract_             => from_contract_,
                                                                       part_no_              => part_no_);
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY_ONHAND', 'CATCH_QUANTITY_ONHAND')) THEN
   
                  Data_Capture_Invent_Util_API.Add_Details_For_Inv_Stock_Rec(capture_session_id_  => capture_session_id_,
                                                                             owning_data_item_id_ => latest_data_item_id_,
                                                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             contract_            => from_contract_,
                                                                             part_no_             => part_no_,
                                                                             configuration_id_    => configuration_id_,
                                                                             location_no_         => from_location_no_,
                                                                             lot_batch_no_        => lot_batch_no_,
                                                                             serial_no_           => serial_no_,
                                                                             eng_chg_level_       => eng_chg_level_,
                                                                             waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                                                             activity_seq_        => activity_seq_,
                                                                             handling_unit_id_    => handling_unit_id_);
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('FROM_LOCATION_NO_DESC', 'FROM_LOCATION_GROUP', 'FROM_LOCATION_TYPE', 
                                                                       'FROM_WAREHOUSE','FROM_BAY_ID','FROM_ROW_ID','FROM_TIER_ID','FROM_BIN_ID',
                                                                       'FROM_RECEIPTS_BLOCKED', 'FROM_MIX_OF_PART_NUMBER_BLOCKED', 'FROM_MIX_OF_CONDITION_CODES_BLOCKED',
                                                                       'FROM_MIX_OF_LOT_BATCH_NO_BLOCKED')) THEN
   
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => from_contract_, 
                                                                           location_no_         => from_location_no_);
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TO_LOCATION_NO_DESC', 'TO_LOCATION_GROUP', 'TO_LOCATION_TYPE', 
                                                                       'TO_WAREHOUSE','TO_BAY_ID','TO_ROW_ID','TO_TIER_ID','TO_BIN_ID', 
                                                                       'TO_RECEIPTS_BLOCKED', 'TO_MIX_OF_PART_NUMBER_BLOCKED', 'TO_MIX_OF_CONDITION_CODES_BLOCKED',
                                                                       'TO_MIX_OF_LOT_BATCH_NO_BLOCKED')) THEN
   
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => to_contract_, 
                                                                           location_no_         => to_location_no_);  
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'LAST_LINE_ON_TRANSPORT_TASK') THEN                   
                  IF (Transport_Task_Line_API.Get_Number_Of_Lines(transport_task_id_) = 1) THEN
                      -- if lines left to pick = 1 then this is the last line to handle on the transport task
                     last_line_on_transport_task_ := Gen_Yes_No_API.DB_YES;
                  END IF;
                  Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                    data_item_id_        => latest_data_item_id_,
                                                    data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,

                                                    data_item_value_     => last_line_on_transport_task_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_DESC', 'HANDLING_UNIT_TYPE_CATEG_ID', 
                                                                       'HANDLING_UNIT_TYPE_CATEG_DESC', 'HANDLING_UNIT_TYPE_ADD_VOLUME', 'HANDLING_UNIT_TYPE_MAX_VOL_CAP',
                                                                       'HANDLING_UNIT_TYPE_MAX_WGT_CAP', 'HANDLING_UNIT_TYPE_STACKABLE',
																	                    'TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARENT_HANDLING_UNIT_ID', 'HANDLING_UNIT_SHIPMENT_ID', 'HANDLING_UNIT_ACCESSORY_EXIST',
                                                                       'HANDLING_UNIT_COMPOSITION', 'HANDLING_UNIT_WIDTH', 'HANDLING_UNIT_HEIGHT',
                                                                       'HANDLING_UNIT_DEPTH', 'HANDLING_UNIT_UOM_LENGTH', 'HANDLING_UNIT_NET_WEIGHT',
                                                                       'HANDLING_UNIT_TARE_WEIGHT', 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT', 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                                       'HANDLING_UNIT_UOM_WEIGHT', 'HANDLING_UNIT_MANUAL_VOLUME', 'HANDLING_UNIT_OPERATIVE_VOLUME',
                                                                       'HANDLING_UNIT_UOM_VOLUME', 'HANDLING_UNIT_GEN_SSCC', 'HANDLING_UNIT_PRINT_LBL', 'HANDLING_UNIT_NO_OF_LBLS',
                                                                       'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED', 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED',
                                                                       'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED', 'TOP_PARENT_HANDLING_UNIT_ID',
                                                                       'TOP_PARENT_SSCC', 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);

               ELSIF(conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE', 'CONDITION_CODE_DESCRIPTION')) THEN
                  condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_, serial_no_, lot_batch_no_); 
                  IF (conf_item_detail_tab_(i).data_item_detail_id = 'CONDITION_CODE') THEN 
                     Data_Capture_Invent_Util_API.Add_Condition_Code(capture_session_id_   => capture_session_id_,
                                                                     owning_data_item_id_  => latest_data_item_id_,
                                                                     data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                     condition_code_       => condition_code_);  
                  ELSE
                     Data_Capture_Invent_Util_API.Add_Condition_Code_Desc(capture_session_id_   => capture_session_id_,
                                                                          owning_data_item_id_  => latest_data_item_id_,
                                                                          data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          condition_code_       => condition_code_);     
                  END IF; 
               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;


PROCEDURE Post_Process_Action(
   process_message_     IN OUT NOCOPY CLOB,
   capture_session_id_  IN NUMBER,
   contract_            IN VARCHAR2 )
IS
   inventory_event_id_ NUMBER;
   number_null_        NUMBER;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      inventory_event_id_ := Message_SYS.Find_Attribute(process_message_, 'INVENTORY_EVENT_ID', number_null_);
   END IF;
   IF (inventory_event_id_ IS NOT NULL) THEN
      Inventory_Event_Manager_API.Finish(inventory_event_id_);
   END IF;
END Post_Process_Action;


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
   line_no_                NUMBER;
   action_                 VARCHAR2(200);
   quantity_               NUMBER;
   catch_quantity_         NUMBER;
   to_location_no_         VARCHAR2(35);
   inventory_event_id_     NUMBER;
   destination_db_         VARCHAR2(200);
   transp_task_line_rec_   Transport_Task_Line_API.Public_Rec;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'TRANSPORT_TASK_ID') THEN
         transport_task_id_ := value_;
      ELSIF (name_ = 'LINE_NO') THEN
         line_no_ := value_;
      ELSIF (name_ = 'ACTION') THEN
         action_ := value_;
         IF (action_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'ACTIONNULL: The default/fixed value ":P1" specified for the Action field must be in the session language.', Transport_Task_Action_API.Decode(action_));
         END IF;
      ELSIF (name_ = 'QUANTITY') THEN
         quantity_ := value_;
      ELSIF (name_ = 'TO_LOCATION_NO') THEN
         to_location_no_ := value_;
      ELSIF (name_ = 'CATCH_QUANTITY') THEN
         catch_quantity_ := value_;
      ELSIF (name_ = 'DESTINATION') THEN
         destination_db_ := value_;
      END IF;
   END LOOP; 
   
   transp_task_line_rec_ := Transport_Task_Line_API.Get(transport_task_id_, line_no_);

   -- Handle change of to location
   IF (to_location_no_ IS NOT NULL AND to_location_no_ != transp_task_line_rec_.to_location_no) THEN
      Transport_Task_Line_API.Modify_To_Location_No(transport_task_id_, line_no_, to_location_no_);
   END IF;

   -- Handle change of destination
   IF (destination_db_ IS NOT NULL AND destination_db_ != transp_task_line_rec_.destination) THEN
      Transport_Task_Line_API.Modify_Destination(transport_task_id_, line_no_, destination_db_);
   END IF;
   
   -- Handle quantity update
   IF (action_ != Transport_Task_Action_API.DB_UNPICK AND quantity_ IS NOT NULL) THEN
      Transport_Task_Line_API.Modify_Quantity(transport_task_id_, line_no_, quantity_, TRUE);
   END IF;
   
   -- Handle catch quantity update
   IF (action_ = Transport_Task_Action_API.DB_EXECUTE AND catch_quantity_ IS NOT NULL) THEN
      Transport_Task_Line_API.Modify_Catch_Quantity(transport_task_id_, line_no_, catch_quantity_);
   END IF;
   
   inventory_event_id_ := Get_inventory_event_id___(process_message_);
   Inventory_Event_Manager_API.Set_Session_Id(inventory_event_id_);
      
   -- Pick action to perform
   IF (action_ = Transport_Task_Action_API.DB_PICK) THEN
      Transport_Task_Line_API.Pick(transport_task_id_ => transport_task_id_,
                                   line_no_           => line_no_);
   ELSIF (action_ = Transport_Task_Action_API.DB_UNPICK) THEN
      Transport_Task_Line_API.Unpick(transport_task_id_ => transport_task_id_,
                                     line_no_           => line_no_);
   ELSIF (action_ = Transport_Task_Action_API.DB_EXECUTE) THEN
      Transport_Task_Line_API.Execute(transport_task_id_      => transport_task_id_,
                                      line_no_                => line_no_);
   END IF;
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN

   -- Check to see that API method Transport_Task_Line_API.Pick is granted thru following projections/actions
   -- Check to see that API method Transport_Task_Line_API.Unpick is granted thru following projections/actions
   -- Check to see that API method Transport_Task_Line_API.Execute is granted thru following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'ExecuteTransportTaskLinesForSerials') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'ExecuteTransportTaskLinesForSerials') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'ExecuteTransportTaskLinesForSerials') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'ExecuteTransportTaskLinesForSerials')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


@UncheckedAccess
FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   transport_task_id_           NUMBER;
   line_no_                     NUMBER;
   transport_task_status_       VARCHAR2(200);
   order_type_db_               VARCHAR2(200);
   part_no_                     VARCHAR2(25);
   from_contract_               VARCHAR2(5);
   from_location_no_            VARCHAR2(35);
   to_contract_                 VARCHAR2(5);
   to_location_no_              VARCHAR2(35);
   destination_                 VARCHAR2(200);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   eng_chg_level_               VARCHAR2(6);
   waiv_dev_rej_no_             VARCHAR2(15);
   activity_seq_                NUMBER;
   configuration_id_            VARCHAR2(50);
   barcode_id_                  NUMBER;
   handling_unit_id_            NUMBER;
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   gtin_no_                    VARCHAR2(14);
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
      -- if predicted part_no_ is null then try fetch it with unique handling
      IF (part_no_ IS NULL) THEN
         Get_Filter_Keys___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_,
                            from_location_no_, to_contract_, to_location_no_, destination_, serial_no_, lot_batch_no_,
                            eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, barcode_id_, gtin_no_, 
                            handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, 
                            data_item_id_, use_applicable_ => FALSE);
         part_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, line_no_, transport_task_status_, order_type_db_, part_no_, from_contract_, from_location_no_, to_contract_, to_location_no_, destination_, 
                                                   serial_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, configuration_id_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
      END IF;
      IF (serial_no_ IS NULL) AND (data_item_id_ = 'QUANTITY') THEN
         serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
      END IF; 

      RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, data_item_id_, part_no_, serial_no_);
   $ELSE
      RETURN NULL;
   $END
END Fixed_Value_Is_Applicable;


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
   
      RETURN subseq_session_start_allowed_;
   $ELSE
      RETURN NULL;
   $END
END Subseq_Session_Start_Allowed;



