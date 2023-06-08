-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptCreateHndlUnit
--  Component:    INVENT     
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: CREATE_HANDLING_UNIT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200818  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  200311  DaZase  SCXTEND-3803, Small change in Create_List_Of_Values to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  181114  MeAblk  SCSPRING20-934, Increased the length of the variables which refer to receiver_id upto 50 characters.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  180122  DaZase  STRSC-15853, Renamed Parent_Is_Shipment_Root___ to Parent_Is_Not_Used___ and change the method so it now allow if any parent hu key have a value to fix bug issue.
--  180122          Reworked Validate_Parent___ due to these changes and added new checks to it instead to stop the most common manual errors.
--  171018  DaZase  STRSC-13005, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171018          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170504  KhVese  Modified method Get_Automatic_Data_Item_Value.
--  170217  DaZase  Changes in Get_Sql_Where_Expression___ due to unique Handling_Unit_API
--  170217          methods now uses table instead of extended view for performance reasons, 
--  170217          so a contract/user allowed site check was added since that was on extended view.
--  161102  DaZase  LIM-7326, Added handling of new data items PRINT_SHIPMENT_LABEL and NO_OF_SHIPMENT_LABELS.
--  160519  UdGnlk  LIM-7475, Modified Execute_Process() method call from Print_Transport_Package_Label() to Handling_Unit_API.Print_Shpmnt_Hand_Unit_Label().
--  160209  DaZase  LIM-6226, Renamed ship_addr_no to receiver_addr_id.
--  1512xx  DaZase  LIM-2922, Reworked and renamed DataCapAddHandlingUnit to DataCaptCreateHndlUnit and moved it from ORDER to INVENT. 
--  1512xx          The old ORDER DataCapAddHandlingUnit is now obsolete and replaced with this file. This process now support Creating handling units 
--  1512xx          both in Inventory and in Shipment.
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151028  Erlise  LIM-3774, Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID and 
--  151028          PARENT_ALT_TRANSPORT_LABEL_ID to PARENT_ALT_HANDLING_UNIT_LABEL_ID.
--  151027  DaZase  LIM-4297, Changed call to Add_Details_For_Hand_Unit_Type  
--  151027          so it now call Data_Capture_Invent_Util_API instead of Data_Capture_Order_Util_API.                  
--  150807  DaZase  COB-607, Reworked some of the unique methods so data items that are not using the filter keys 
--  150807          are handled before calling Get_Filter_Keys___, to help performance a bit. 
--  150304  RILASE  Created.
-----------------------------------------------------------------------------

layer Core;

string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER := -1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Data_Source___ (
   shipment_id_               IN NUMBER,
   receiver_id_               IN VARCHAR2,
   shipment_type_             IN VARCHAR2,
   receiver_addr_id_          IN VARCHAR2,
   forward_agent_id_          IN VARCHAR2,
   parent_consol_shipment_id_ IN NUMBER,
   ship_via_code_             IN VARCHAR2,
   session_rec_               IN Data_Capture_Common_Util_API.Session_Rec,
   data_item_id_              IN  VARCHAR2 ) RETURN VARCHAR2
IS
   data_source_               VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN

         IF (shipment_id_ IS NOT NULL OR receiver_id_ IS NOT NULL OR 
             shipment_type_ IS NOT NULL OR receiver_addr_id_ IS NOT NULL OR 
             forward_agent_id_ IS NOT NULL OR parent_consol_shipment_id_ IS NOT NULL OR
             ship_via_code_ IS NOT NULL) THEN
            -- If any of the shipment filter keys are not NULL then we are using SHIPMENT
            data_source_ := 'SHIPMENT';

         ELSE -- All shipment filter keys are at the moment NULL
            -- Check shipment if data item is one of the shipment only data items
            IF (data_item_id_ IN ('SHIPMENT_ID', 'RECEIVER_ID', 'SHIPMENT_TYPE', 'RECEIVER_ADDR_ID',
                                  'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'PARENT_CONSOL_SHIPMENT_ID')) THEN
               -- If any of the shipment only and not nullable items comes before current item
               IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_) OR
                   Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_ID', data_item_id_) OR 
                   Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_TYPE', data_item_id_) OR 
                   Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_ADDR_ID', data_item_id_)) THEN
                  -- then we know that this is INVENT only since at least one of the shipment only and not nullable items ARE NULL 
                  data_source_ := 'INVENT';
               ELSE  -- None of the shipment only and not nullable items comes before current item
                  -- If any of shipment only and not nullable items will be set as NULL by fixed value handling
                  IF (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID') OR
                      Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'RECEIVER_ID') OR
                      Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_TYPE') OR
                      Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'RECEIVER_ADDR_ID')) THEN
                     -- then we know that this is INVENT only since at least one of the shipment only and not nullable items WILL BE NULL
                     data_source_ := 'INVENT';
                  ELSE  -- None of the shipment only and not nullable items will be NULL by fixed value handling
                     IF (data_item_id_ = 'SHIPMENT_ID') THEN
                        -- since shipment_id exist in both data sources and we still dont know which one to use, both are valid
                        data_source_ := 'INVENT_AND_SHIPMENT';  
                     ELSE
                        -- We still don't know if this session will use shipment or not, so both NULL and SHIPMENT is allowed
                        data_source_ := 'NULL_AND_SHIPMENT';
                     END IF;
                  END IF;
               END IF;
            
            ELSE -- data item is one of the items that can be both INVENT and SHIPMENT
               -- If any of the shipment only and not nullable items comes before current item
               IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_) OR
                   Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_ID', data_item_id_) OR 
                   Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_TYPE', data_item_id_) OR 
                   Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_ADDR_ID', data_item_id_)) THEN
                  -- then we know that this is INVENT only since at least one of the shipment only and not nullable items ARE NULL 
                  data_source_ := 'INVENT';
               ELSE  -- None of the shipment only and not nullable items comes before current item
                  -- If any of shipment only and not nullable items will be set as NULL by fixed value handling
                  IF (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID') OR
                      Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'RECEIVER_ID') OR
                      Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_TYPE') OR
                      Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'RECEIVER_ADDR_ID')) THEN
                     -- then we know that this is INVENT only since at least one of the shipment only and not nullable items WILL BE NULL
                     data_source_ := 'INVENT';
                  ELSE  -- None of the shipment only and not nullable items will be NULL by fixed value handling
                     -- We still don't know if this session will use shipment or not, so both INVENT and SHIPMENT is allowed
                     data_source_ := 'INVENT_AND_SHIPMENT';
                  END IF;
               END IF;
            END IF;
         END IF;

      $ELSE  -- SHIPMENT not installed
          data_source_ := 'INVENT';

      $END   -- SHIPMENT CC
   $END   -- WADACO CC
   RETURN data_source_;
END Get_Data_Source___;


PROCEDURE Get_Filter_Keys___ (
   contract_                      OUT VARCHAR2,
   shipment_id_                   OUT NUMBER,
   parent_handling_unit_id_       OUT NUMBER,
   receiver_id_                   OUT VARCHAR2,
   shipment_type_                 OUT VARCHAR2,
   receiver_addr_id_              OUT VARCHAR2,
   forward_agent_id_              OUT VARCHAR2,
   parent_consol_shipment_id_     OUT NUMBER,
   ship_via_code_                 OUT VARCHAR2,
   parent_sscc_                   OUT VARCHAR2,
   parent_alt_hand_unit_label_id_ OUT VARCHAR2,
   data_source_                   OUT VARCHAR2,
   capture_session_id_            IN  NUMBER,
   data_item_id_                  IN  VARCHAR2,
   data_item_value_               IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_             IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_                IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   old_parent_handling_unit_id_ NUMBER;
   old_parent_sscc_             VARCHAR2(18);
   old_parent_alt_hu_label_id_  VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      receiver_id_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_ID', session_rec_ , process_package_, use_applicable_);
      parent_handling_unit_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      shipment_id_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      shipment_type_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_TYPE', session_rec_ , process_package_, use_applicable_);
      receiver_addr_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_ADDR_ID', session_rec_ , process_package_, use_applicable_);
      forward_agent_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FORWARD_AGENT_ID', session_rec_ , process_package_, use_applicable_);
      parent_consol_shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_CONSOL_SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      ship_via_code_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIP_VIA_CODE', session_rec_ , process_package_, use_applicable_);
      parent_sscc_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_SSCC', session_rec_ , process_package_, use_applicable_);
      parent_alt_hand_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
   
      -- Add support for alternative parent handling unit keys
      IF (parent_handling_unit_id_ IS NULL AND parent_sscc_ IS NOT NULL) THEN
         parent_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(parent_sscc_);
      ELSIF (parent_handling_unit_id_ IS NULL AND parent_alt_hand_unit_label_id_ IS NOT NULL) THEN
         parent_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(parent_alt_hand_unit_label_id_);
      END IF;
      IF (parent_sscc_ IS NULL AND parent_handling_unit_id_ IS NOT NULL) THEN
         parent_sscc_ := Handling_Unit_API.Get_Sscc(parent_handling_unit_id_);
      END IF;
      IF (parent_alt_hand_unit_label_id_ IS NULL AND parent_handling_unit_id_ IS NOT NULL) THEN
         parent_alt_hand_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(parent_handling_unit_id_);
      END IF;
      -- Try and fetch shipment_id from parent hu
      IF (shipment_id_ IS NULL AND parent_handling_unit_id_ IS NOT NULL) THEN
         shipment_id_ := Handling_Unit_API.Get_Shipment_Id(parent_handling_unit_id_);
      END IF;


      -- Fetch the data source that should be used
      data_source_ := Get_Data_Source___(shipment_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_, 
                                         parent_consol_shipment_id_, ship_via_code_, session_rec_, data_item_id_);

TRACE_SYS.FIELD('data_item_id_ in Get_Filter_Keys___: ',data_item_id_);
TRACE_SYS.FIELD('data_source_ in Get_Filter_Keys___: ',data_source_);

      
      IF (forward_agent_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'FORWARD_AGENT_ID', data_item_id_)) THEN
         forward_agent_id_ := string_all_values_;
      END IF;
      
      IF (ship_via_code_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIP_VIA_CODE', data_item_id_)) THEN
         ship_via_code_ := string_all_values_;
      END IF;
      
      IF (parent_consol_shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_CONSOL_SHIPMENT_ID', data_item_id_)) THEN
         parent_consol_shipment_id_ := number_all_values_;
      END IF;

      IF (parent_handling_unit_id_ IS NULL) THEN
         parent_handling_unit_id_ := number_all_values_;
      END IF;
      
      IF (parent_sscc_ IS NULL) THEN
         parent_sscc_ := string_all_values_;
      END IF;
      
      IF (parent_alt_hand_unit_label_id_ IS NULL) THEN
         parent_alt_hand_unit_label_id_ := string_all_values_;
      END IF;

      IF (use_unique_values_) THEN
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                          parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'SHIPMENT_ID');
         END IF;
         IF (receiver_id_ IS NULL) THEN
            receiver_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                          parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'RECEIVER_ID');
         END IF;
         IF (shipment_type_ IS NULL) THEN
            shipment_type_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                            parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'SHIPMENT_TYPE');
         END IF;
         IF (receiver_addr_id_ IS NULL) THEN
            receiver_addr_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                               parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'RECEIVER_ADDR_ID');
         END IF;
         IF (forward_agent_id_ IS NULL OR forward_agent_id_ = string_all_values_) THEN
            forward_agent_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                               parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'FORWARD_AGENT_ID');
         END IF;
         IF (parent_consol_shipment_id_ IS NULL OR parent_consol_shipment_id_ = number_all_values_) THEN
            parent_consol_shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                                        parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'PARENT_CONSOL_SHIPMENT_ID');
         END IF;
         IF (parent_handling_unit_id_ IS NULL OR parent_handling_unit_id_ = number_all_values_) THEN
            old_parent_handling_unit_id_ := parent_handling_unit_id_;
            parent_handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                                      parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'PARENT_HANDLING_UNIT_ID');
            IF (parent_handling_unit_id_ IS NULL AND old_parent_handling_unit_id_ = number_all_values_) THEN
               parent_handling_unit_id_ := number_all_values_;
            END IF;
         END IF;
         IF (ship_via_code_ IS NULL OR ship_via_code_ = string_all_values_) THEN
            ship_via_code_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                            parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'SHIP_VIA_CODE');
         END IF;
         IF (parent_sscc_ IS NULL OR parent_sscc_ = string_all_values_) THEN
            old_parent_sscc_ := parent_sscc_;
            parent_sscc_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                          parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'PARENT_SSCC');
            IF (parent_sscc_ IS NULL AND old_parent_sscc_ = string_all_values_) THEN
               parent_sscc_ := string_all_values_;
            END IF;
         END IF;
         IF (parent_alt_hand_unit_label_id_ IS NULL OR parent_alt_hand_unit_label_id_ = string_all_values_) THEN
            old_parent_alt_hu_label_id_ := parent_alt_hand_unit_label_id_;
            parent_alt_hand_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                                            parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'PARENT_ALT_HANDLING_UNIT_LABEL_ID');
            IF (parent_alt_hand_unit_label_id_ IS NULL AND old_parent_alt_hu_label_id_ = string_all_values_) THEN
               parent_alt_hand_unit_label_id_ := string_all_values_;
            END IF;
         END IF;
      END IF;

   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;


FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                      IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   parent_handling_unit_id_       IN NUMBER,
   receiver_id_                   IN VARCHAR2,
   shipment_type_                 IN VARCHAR2,
   receiver_addr_id_              IN VARCHAR2,
   forward_agent_id_              IN VARCHAR2,
   parent_consol_shipment_id_     IN NUMBER,
   ship_via_code_                 IN VARCHAR2,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2,
   data_source_                   IN VARCHAR2,
   wanted_data_item_id_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_                  VARCHAR2(200);
   column_name_                   VARCHAR2(50);
   dummy_                         BOOLEAN;
   local_parent_handling_unit_id_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (wanted_data_item_id_ IN ('RECEIVER_ID', 'SHIPMENT_ID', 'SHIPMENT_TYPE', 'RECEIVER_ADDR_ID',
                                   'FORWARD_AGENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SHIP_VIA_CODE', 'PARENT_HANDLING_UNIT_ID',
                                   'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
         IF (wanted_data_item_id_ = 'PARENT_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (wanted_data_item_id_ = 'PARENT_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (wanted_data_item_id_ = 'PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSE
            column_name_ := wanted_data_item_id_;
         END IF;

         IF (data_source_ = 'SHIPMENT') THEN
            $IF Component_Shpmnt_SYS.INSTALLED $THEN
               unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_         => dummy_,
                                                                        contract_                      => contract_,
                                                                        shipment_id_                   => shipment_id_,
                                                                        handling_unit_id_              => parent_handling_unit_id_,
                                                                        receiver_id_                   => receiver_id_,
                                                                        shipment_type_                 => shipment_type_,
                                                                        receiver_addr_id_              => receiver_addr_id_,
                                                                        forward_agent_id_              => forward_agent_id_,
                                                                        parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                                        ship_via_code_                 => ship_via_code_,
                                                                        sscc_                          => parent_sscc_,
                                                                        alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                                        column_name_                   => column_name_);
            $ELSE
               NULL;
            $END
            
         ELSIF (data_source_ = 'NULL_AND_SHIPMENT') THEN
            -- Since NULL is always a possibility here, there is no point checking shipment since this method 
            -- should not return 'NULL' so in this method you dont see the difference between NULL and unique value NULL, 
            -- so it will always return NULL even if you find a unique shipment value since the "other" NULL is always 
            -- alternative also. This is the difference between this method and Get_Automatic_Data_Item_Value where we 
            -- actually handle and return 'NULL' for unique NULL values.
            unique_value_ := NULL;

         ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN
           unique_value_ := Get_Unique_Inv_Ship_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, 
                                                         receiver_addr_id_, forward_agent_id_, parent_consol_shipment_id_, ship_via_code_, 
                                                         parent_sscc_, parent_alt_hand_unit_label_id_, column_name_);

         ELSIF ((data_source_ = 'INVENT') AND (wanted_data_item_id_ NOT IN ('RECEIVER_ID', 'SHIPMENT_TYPE', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 
                                                                            'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'RECEIVER_ADDR_ID'))) THEN
            -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
            local_parent_handling_unit_id_ := CASE parent_handling_unit_id_ WHEN -1 THEN NULL ELSE parent_handling_unit_id_ END; 
            unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                          handling_unit_id_           => local_parent_handling_unit_id_,
                                                                          sscc_                       => parent_sscc_,
                                                                          alt_handling_unit_label_id_ => parent_alt_hand_unit_label_id_,
                                                                          column_name_                => column_name_,
                                                                          sql_where_expression_       => Get_Sql_Where_Expression___);

         END IF;

      END IF;   
      IF (unique_value_ = 'NULL') THEN
         unique_value_ := NULL;
      END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


FUNCTION Get_Unique_Inv_Ship_Value___ (
   contract_                      IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   parent_handling_unit_id_       IN NUMBER,
   receiver_id_                   IN VARCHAR2,
   shipment_type_                 IN VARCHAR2,
   receiver_addr_id_              IN VARCHAR2,
   forward_agent_id_              IN VARCHAR2,
   parent_consol_shipment_id_     IN NUMBER,
   ship_via_code_                 IN VARCHAR2,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2,
   column_name_                   IN VARCHAR2 ) RETURN VARCHAR2

IS
   unique_value_                  VARCHAR2(200);
   shipment_unique_value_         VARCHAR2(200);
   invent_unique_value_           VARCHAR2(200);
   shpmnt_no_unique_value_found_  BOOLEAN; 
   invent_no_unique_value_found_  BOOLEAN;
   local_parent_handling_unit_id_ NUMBER;
BEGIN

   IF (column_name_ NOT IN ('RECEIVER_ID', 'SHIPMENT_TYPE', 'PARENT_CONSOL_SHIPMENT_ID', 
                            'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'RECEIVER_ADDR_ID')) THEN
      -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
      local_parent_handling_unit_id_ := CASE parent_handling_unit_id_ WHEN -1 THEN NULL ELSE parent_handling_unit_id_ END; 
      invent_unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => invent_no_unique_value_found_,
                                                                           handling_unit_id_           => local_parent_handling_unit_id_,
                                                                           sscc_                       => parent_sscc_,
                                                                           alt_handling_unit_label_id_ => parent_alt_hand_unit_label_id_,
                                                                           column_name_                => column_name_,
                                                                           sql_where_expression_       => Get_Sql_Where_Expression___);
   ELSE
      invent_no_unique_value_found_ := TRUE; 
   END IF;

   $IF Component_Shpmnt_SYS.INSTALLED $THEN
      shipment_unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_         => shpmnt_no_unique_value_found_,
                                                                        contract_                      => contract_,
                                                                        shipment_id_                   => shipment_id_,
                                                                        handling_unit_id_              => parent_handling_unit_id_,
                                                                        receiver_id_                   => receiver_id_,
                                                                        shipment_type_                 => shipment_type_,
                                                                        receiver_addr_id_              => receiver_addr_id_,
                                                                        forward_agent_id_              => forward_agent_id_,
                                                                        parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                                        ship_via_code_                 => ship_via_code_,
                                                                        sscc_                          => parent_sscc_,
                                                                        alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                                        column_name_                   => column_name_);
   $END


   IF (shipment_unique_value_ = invent_unique_value_) THEN
      unique_value_ := shipment_unique_value_;   -- same unique value so 1 unique value was found
   ELSIF (shipment_unique_value_ IS NOT NULL AND invent_unique_value_ IS NULL AND invent_no_unique_value_found_) THEN
      unique_value_ := shipment_unique_value_;   -- shipment unique value was found but none in invent records, use shipment value
   ELSIF (invent_unique_value_ IS NOT NULL AND shipment_unique_value_ IS NULL AND shpmnt_no_unique_value_found_) THEN
      unique_value_ := invent_unique_value_; -- invent unique value was found but none in shipment, use invent value
   ELSE -- not the same unique values from invent and shipment or one of the data sources got more then 1 value so no combined unique value was found
      unique_value_ := NULL;            
   END IF;

   RETURN unique_value_;
END Get_Unique_Inv_Ship_Value___;


PROCEDURE Validate_Sscc_New_Units___(
   capture_session_id_ IN NUMBER,
   sscc_               IN VARCHAR2,
   no_of_new_units_    IN NUMBER)
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (no_of_new_units_ > 1 AND sscc_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'SSCCONLYQTYOE: When a :P1 is specified the :P2 can only be 1.',
                                  Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 'SSCC'),
                                  Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 'NO_OF_NEW_UNITS'));
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Sscc_New_Units___;

   
PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_            IN NUMBER,
   owning_data_item_id_           IN VARCHAR2,
   data_item_detail_id_           IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   parent_handling_unit_id_       IN NUMBER,
   receiver_id_                   IN VARCHAR2,
   shipment_type_                 IN VARCHAR2,
   receiver_addr_id_              IN VARCHAR2,
   forward_agent_id_              IN VARCHAR2,
   parent_consol_shipment_id_     IN NUMBER,
   ship_via_code_                 IN VARCHAR2,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2)  
IS
   detail_value_                 VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('SHIPMENT_ID') THEN
            detail_value_ := shipment_id_;
         WHEN ('PARENT_HANDLING_UNIT_ID') THEN
            IF (parent_handling_unit_id_ != number_all_values_) THEN
               detail_value_ := parent_handling_unit_id_;
            END IF;
         WHEN ('RECEIVER_ID') THEN
            detail_value_ := receiver_id_;
         WHEN ('SHIPMENT_TYPE') THEN
            detail_value_ := shipment_type_;
         WHEN ('RECEIVER_ADDR_ID') THEN
            detail_value_ := receiver_addr_id_;
         WHEN ('FORWARD_AGENT_ID') THEN
            IF (forward_agent_id_ != string_all_values_) THEN
               detail_value_ := forward_agent_id_;
            END IF;
         WHEN ('PARENT_CONSOL_SHIPMENT_ID') THEN
            IF (parent_consol_shipment_id_ != number_all_values_) THEN
               detail_value_ := parent_consol_shipment_id_;
            END IF;
         WHEN ('SHIP_VIA_CODE') THEN
            IF (ship_via_code_ != string_all_values_) THEN
               detail_value_ := ship_via_code_;
            END IF;
         WHEN ('PARENT_SSCC') THEN
            IF (parent_sscc_ != string_all_values_) THEN
               detail_value_ := parent_sscc_;
            END IF;
         WHEN ('PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
            IF (parent_alt_hand_unit_label_id_ != string_all_values_) THEN
               detail_value_ := parent_alt_hand_unit_label_id_;
            END IF;
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
   capture_session_id_     IN NUMBER,
   session_rec_            IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_    IN VARCHAR2,
   owning_data_item_value_ IN VARCHAR2,
   data_item_detail_id_    IN VARCHAR2 )
IS
   detail_value_          VARCHAR2(4000);
   process_package_       VARCHAR2(30);
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

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


FUNCTION Parent_Is_Not_Used___(
   capture_session_id_            IN NUMBER,
   data_item_id_                  IN VARCHAR2,
   parent_handling_unit_id_       IN NUMBER,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2) RETURN BOOLEAN
IS
   parent_is_not_used_            BOOLEAN := FALSE;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF (parent_handling_unit_id_ IS NOT NULL AND parent_handling_unit_id_ != number_all_values_) OR
         (parent_sscc_ IS NOT NULL AND parent_sscc_ != string_all_values_) OR
         (parent_alt_hand_unit_label_id_ IS NOT NULL AND parent_alt_hand_unit_label_id_ != string_all_values_) THEN
         parent_is_not_used_ := FALSE; -- at least one parent handling unit key have a value then we are using parent here (so LOV/automatic value should work as normal)
      ELSIF ((Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_HANDLING_UNIT_ID', data_item_id_) AND (parent_handling_unit_id_ IS NULL OR parent_handling_unit_id_ = number_all_values_)) OR
         (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_SSCC', data_item_id_) AND (parent_sscc_ IS NULL OR parent_sscc_ = string_all_values_)) OR
         (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_) AND (parent_alt_hand_unit_label_id_ IS NULL OR parent_alt_hand_unit_label_id_ = string_all_values_))) THEN
         parent_is_not_used_ := TRUE;
      END IF;
   $END
   RETURN parent_is_not_used_;
END Parent_Is_Not_Used___;

   
PROCEDURE Validate_Parent___(
   capture_session_id_            IN NUMBER,
   data_item_id_                  IN VARCHAR2,
   data_item_value_               IN VARCHAR2,
   parent_handling_unit_id_       IN NUMBER,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2 )
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   --IF (Parent_Is_Shipment_Root___(capture_session_id_, data_item_id_, parent_handling_unit_id_, parent_sscc_, parent_alt_hand_unit_label_id_) AND data_item_value_ IS NOT NULL) THEN
   --   Error_SYS.Record_General(lu_name_, 'PARENTISROOTNOVALUEALLOWED: A parent cannot be specified if the another parent item has been specified as empty and the handling unit shall be added to the shipment root level.');
   --END IF;
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Important to make sure parent handling unit id have value if any of other 2 is used since its parent handling unit id that is sent in execute 
      IF (data_item_id_ = 'PARENT_HANDLING_UNIT_ID' AND data_item_value_ IS NULL AND 
          ((parent_sscc_ IS NOT NULL AND parent_sscc_ != string_all_values_) OR 
           (parent_alt_hand_unit_label_id_ IS NOT NULL AND parent_alt_hand_unit_label_id_ != string_all_values_))) THEN
         Error_SYS.Record_General(lu_name_, 'PARENTIDMISSING1: Parent Handling Unit ID must have value if Parent SSCC or Parent Alt Handling Unit Label ID have value.');
      ELSIF (data_item_id_ = 'PARENT_SSCC' AND data_item_value_ IS NOT NULL AND 
             Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_HANDLING_UNIT_ID', data_item_id_) AND 
             (parent_handling_unit_id_ IS NULL OR parent_handling_unit_id_ = number_all_values_)) THEN
         Error_SYS.Record_General(lu_name_, 'PARENTIDMISSING2: Parent Handling Unit ID must have value if Parent SSCC have value.');
      ELSIF (data_item_id_ = 'PARENT_ALT_HANDLING_UNIT_LABEL_ID' AND data_item_value_ IS NOT NULL AND 
             Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_HANDLING_UNIT_ID', data_item_id_) AND 
             (parent_handling_unit_id_ IS NULL OR parent_handling_unit_id_ = number_all_values_)) THEN
         Error_SYS.Record_General(lu_name_, 'PARENTIDMISSING3: Parent Handling Unit ID must have value if Parent Alt Handling Unit Label ID have value.');
      END IF;
   $ELSE
      NULL;
   $END
   -- NOTE: At the moment we have not added more advanced validations like we have in Count Part process that actually match the different handling unit keys 
   -- so user cannot enter/scan values for different handling units. If similar checks are necessary here maybe we should change the ones in Count Part to be 
   -- more generic and be able to be used/called from many processes.
END Validate_Parent___;


FUNCTION Get_Sql_Where_Expression___ RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(2000);
BEGIN
   sql_where_expression_  := ' AND shipment_id IS NULL AND (contract IS NULL OR EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE contract = site)) ';
   RETURN sql_where_expression_;
END Get_Sql_Where_Expression___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_List_Of_Values (
   capture_session_id_  IN NUMBER,
   capture_process_id_  IN VARCHAR2,
   capture_config_id_   IN NUMBER,
   data_item_id_        IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS
   parent_handling_unit_id_       NUMBER;
   receiver_id_                   VARCHAR2(50);
   shipment_type_                 VARCHAR2(3);
   shipment_id_                   NUMBER;
   receiver_addr_id_              VARCHAR2(50);
   forward_agent_id_              VARCHAR2(20);
   parent_consol_shipment_id_     NUMBER;
   ship_via_code_                 VARCHAR2(3);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   dummy_contract_                VARCHAR2(5);
   column_name_                   VARCHAR2(30);
   list_of_values_available_      BOOLEAN := TRUE;
   dummy_exit_lov_                BOOLEAN;
   data_source_                   VARCHAR2(30);
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   lov_type_db_                   VARCHAR2(20);
   local_parent_handling_unit_id_ NUMBER;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

      IF (data_item_id_ IN ('PRINT_HANDLING_UNIT_LABEL', 'CREATE_SSCC', 'PRINT_SHIPMENT_LABEL')) THEN
         Gen_Yes_No_API.Create_Data_Capture_Lov(capture_session_id_ => capture_session_id_);
      ELSIF (data_item_id_ IN ('HANDLING_UNIT_TYPE_ID')) THEN
         Handling_Unit_Type_API.Create_Data_Capture_Lov(capture_session_id_   => capture_session_id_,
                                                        column_name_          => data_item_id_,
                                                        lov_type_db_          => lov_type_db_);
      ELSE
         Get_Filter_Keys___(dummy_contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_,
                            forward_agent_id_, parent_consol_shipment_id_, ship_via_code_, parent_sscc_,
                            parent_alt_hand_unit_label_id_, data_source_, capture_session_id_, data_item_id_);
   
         IF (data_item_id_ IN ('PARENT_HANDLING_UNIT_ID', 'SHIPMENT_ID', 'RECEIVER_ID', 'SHIPMENT_TYPE', 'RECEIVER_ADDR_ID', 'FORWARD_AGENT_ID',
                               'PARENT_CONSOL_SHIPMENT_ID', 'SHIP_VIA_CODE', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            IF (data_item_id_ IN ('PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
               IF (Parent_Is_Not_Used___(capture_session_id_, data_item_id_, parent_handling_unit_id_, parent_sscc_, parent_alt_hand_unit_label_id_)) THEN
                  list_of_values_available_ := FALSE;         
               END IF;
               IF (data_item_id_ = 'PARENT_HANDLING_UNIT_ID') THEN
                  column_name_ := 'HANDLING_UNIT_ID';
               ELSIF (data_item_id_ = 'PARENT_SSCC') THEN
                  column_name_ := 'SSCC';
               ELSIF (data_item_id_ = 'PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
                  column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               END IF;
            ELSE
               column_name_ := data_item_id_;
            END IF;
            
            IF (list_of_values_available_) THEN
   
               IF (data_source_ = 'NULL_AND_SHIPMENT') THEN
   
                  -- add first a NULL LOV line
                  Data_Capture_Session_Lov_API.New(exit_lov_              => dummy_exit_lov_,
                                                   capture_session_id_    => capture_session_id_,
                                                   lov_item_value_        => NULL,
                                                   lov_item_description_  => NULL,
                                                   lov_row_limitation_    => Data_Capture_Config_API.Get_Lov_Row_Limitation(capture_process_id_, capture_config_id_),    
                                                   session_rec_           => session_rec_);
               END IF;
   
               IF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('RECEIVER_ID', 'SHIPMENT_TYPE', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 
                                                                        'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'RECEIVER_ADDR_ID'))) OR 
                  (data_source_ = 'INVENT_AND_SHIPMENT') THEN
   
                  -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
                  local_parent_handling_unit_id_ := CASE parent_handling_unit_id_ WHEN -1 THEN NULL ELSE parent_handling_unit_id_ END; 
                  -- add first all inventory lines
                  Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_           => local_parent_handling_unit_id_,
                                                            sscc_                       => parent_sscc_,
                                                            alt_handling_unit_label_id_ => parent_alt_hand_unit_label_id_,
                                                            capture_session_id_         => capture_session_id_,
                                                            column_name_                => column_name_,
                                                            lov_type_db_                => lov_type_db_,
                                                            sql_where_expression_       => Get_Sql_Where_Expression___);
               END IF;
   
               IF (data_source_ IN ('SHIPMENT', 'NULL_AND_SHIPMENT', 'INVENT_AND_SHIPMENT')) THEN
                  $IF Component_Shpmnt_SYS.INSTALLED $THEN
   
                     Shipment_API.Create_Data_Capture_Lov(contract_                      => contract_,
                                                          shipment_id_                   => shipment_id_,
                                                          handling_unit_id_              => parent_handling_unit_id_,
                                                          receiver_id_                   => receiver_id_,
                                                          shipment_type_                 => shipment_type_,
                                                          receiver_addr_id_              => receiver_addr_id_,
                                                          forward_agent_id_              => forward_agent_id_,
                                                          parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                          ship_via_code_                 => ship_via_code_,
                                                          sscc_                          => parent_sscc_,
                                                          alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                          capture_session_id_            => capture_session_id_,
                                                          column_name_                   => column_name_,
                                                          lov_type_db_                   => lov_type_db_);
                  $ELSE
                     NULL;
                  $END
               END IF;
            END IF;
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
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF (no_of_records_handled_ = 1 AND process_message_ IS NOT NULL) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'ADDINGOK: The handling unit :P1 was added.', NULL, process_message_);
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'ADDINGSOK: Handling units were added.', NULL, NULL);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2 )
IS
   ptr_                           NUMBER;
   name_                          VARCHAR2(50);
   value_                         VARCHAR2(4000);
   handling_unit_type_id_         VARCHAR2(25);
   parent_handling_unit_id_       NUMBER;
   shipment_id_                   NUMBER;
   no_of_new_units_               NUMBER;
   no_of_handling_unit_labels_    NUMBER;
   no_of_shipment_labels_         NUMBER;
   create_sscc_                   BOOLEAN;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   print_handling_unit_label_     BOOLEAN;
   print_shipment_label_          BOOLEAN;
   new_handling_unit_id_          NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'HANDLING_UNIT_TYPE_ID') THEN
         handling_unit_type_id_ := value_;
      ELSIF (name_ = 'PARENT_HANDLING_UNIT_ID') THEN
         parent_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SHIPMENT_ID') THEN
         shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'NO_OF_NEW_UNITS') THEN
         no_of_new_units_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'CREATE_SSCC') THEN
         create_sscc_ := (value_ = Gen_Yes_No_API.DB_YES);
      ELSIF (name_ = 'SSCC') THEN
         sscc_ := value_;
      ELSIF (name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
         alt_handling_unit_label_id_ := value_;
      ELSIF (name_ = 'PRINT_HANDLING_UNIT_LABEL') THEN
         print_handling_unit_label_ := (value_ = Gen_Yes_No_API.DB_YES);
      ELSIF (name_ = 'NO_OF_HANDLING_UNIT_LABELS') THEN
         no_of_handling_unit_labels_ := NVL(Client_SYS.Attr_Value_To_Number(value_), 1);
      ELSIF (name_ = 'PRINT_SHIPMENT_LABEL') THEN
         print_shipment_label_ := (value_ = Gen_Yes_No_API.DB_YES);
      ELSIF (name_ = 'NO_OF_SHIPMENT_LABELS') THEN
         no_of_shipment_labels_ := NVL(Client_SYS.Attr_Value_To_Number(value_), 1);
      END IF;
   END LOOP;

   IF ((no_of_new_units_ < 0) OR (MOD(no_of_new_units_, 1) != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'NOOFUNITSERROR: No of Units must be an integer greater than zero.');
   END IF;
   
   FOR counter_ IN 1..no_of_new_units_ LOOP
      Handling_Unit_API.New(handling_unit_id_            => new_handling_unit_id_, 
                            handling_unit_type_id_       => handling_unit_type_id_, 
                            parent_handling_unit_id_     => parent_handling_unit_id_, 
                            shipment_id_                 => shipment_id_,
                            alt_handling_unit_label_id_  => alt_handling_unit_label_id_);
         
      IF (create_sscc_) THEN
         Handling_Unit_API.Create_Sscc(new_handling_unit_id_); 
      END IF;
      
      IF (print_handling_unit_label_) THEN 
         Handling_Unit_API.Print_Handling_Unit_Label(handling_unit_id_           => new_handling_unit_id_,
                                                     no_of_handling_unit_labels_ => no_of_handling_unit_labels_);
      END IF;

      IF (print_shipment_label_ AND shipment_id_ IS NOT NULL) THEN 
         Handling_Unit_API.Print_Shpmnt_Hand_Unit_Label(handling_unit_id_           => new_handling_unit_id_,
                                                        shipment_id_                => shipment_id_,
                                                        no_of_handling_unit_labels_ => no_of_shipment_labels_);
      END IF;


   END LOOP;
   IF (no_of_new_units_ = 1) THEN
      process_message_ := new_handling_unit_id_;
   END IF;
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN

   -- Check to see that API method Handling_Unit_API.New is granted thru following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('ShopOrderHandlingUnitStructureHandling', 'ConnectToHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('ShopFloorWorkbenchHandling', 'ConnectToHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentHandlingUnitStructureHandling', 'ConnectToHandlingUnits') OR 
       Security_SYS.Is_Proj_Action_Available('ShipmentHandlingUnitStructureHandling', 'AddToExistingHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitHandling', 'AddToExistingHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseHandling', 'ExecuteAttachToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseTierHandling', 'ExecuteAttachToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseNavigatorHandling', 'ExecuteAttachToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseRowHandling', 'ExecuteAttachToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseLocHandling', 'ExecuteAttachToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseBayHandling', 'ExecuteAttachToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('InventoryPartInStockHandling', 'ExecuteAttachToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('ReceiptHandling', 'ExecuteAttachToHandlingUnit')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   handling_unit_type_id_         VARCHAR2(25);
   parent_handling_unit_id_       NUMBER;
   shipment_id_                   NUMBER;
   contract_                      VARCHAR2(5);
   receiver_id_                   VARCHAR2(50);
   shipment_type_                 VARCHAR2(3);
   receiver_addr_id_              VARCHAR2(50);
   forward_agent_id_              VARCHAR2(20);
   parent_consol_shipment_id_     NUMBER;
   ship_via_code_                 VARCHAR2(3);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   sscc_                          VARCHAR2(18);
   no_of_new_units_               NUMBER;
   create_sscc_                   VARCHAR2(1);
   automatic_value_               VARCHAR2(200);
   column_name_                   VARCHAR2(30);
   data_source_                   VARCHAR2(30);
   dummy_                         BOOLEAN;
   local_parent_handling_unit_id_ NUMBER;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));

      IF (automatic_value_ IS NULL) THEN

         handling_unit_type_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'HANDLING_UNIT_TYPE_ID', data_item_id_);
         IF (data_item_id_ IN ('PRINT_HANDLING_UNIT_LABEL')) THEN
            IF (Fnd_Boolean_API.Is_True_Db(Handling_Unit_Type_API.Get_Print_Label_Db(handling_unit_type_id_))) THEN
               automatic_value_ := Gen_Yes_No_API.DB_YES;
            ELSE
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            END IF;
         ELSIF (data_item_id_ IN ('PRINT_SHIPMENT_LABEL')) THEN
            IF (Fnd_Boolean_API.Is_True_Db(Handling_Unit_Type_API.Get_Print_Shipment_Label_Db(handling_unit_type_id_))) THEN
               automatic_value_ := Gen_Yes_No_API.DB_YES;
            ELSE
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            END IF;
         ELSIF (data_item_id_ = 'NO_OF_HANDLING_UNIT_LABELS') THEN
            automatic_value_ := Handling_Unit_Type_API.Get_No_Of_Handling_Unit_Labels(handling_unit_type_id_);
         ELSIF (data_item_id_ = 'NO_OF_SHIPMENT_LABELS') THEN
            automatic_value_ := Handling_Unit_Type_API.Get_No_Of_Shipment_Labels(handling_unit_type_id_);
         ELSIF (data_item_id_ IN ('CREATE_SSCC')) THEN
            sscc_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SSCC', data_item_id_);
            IF (sscc_ IS NOT NULL) THEN
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            ELSE
               IF (Fnd_Boolean_API.Is_True_Db(Handling_Unit_Type_API.Get_Generate_Sscc_No_Db(handling_unit_type_id_))) THEN
                  automatic_value_ := Gen_Yes_No_API.DB_YES;
               ELSE
                  automatic_value_ := Gen_Yes_No_API.DB_NO;
               END IF;
            END IF;
         ELSIF (data_item_id_ IN ('SSCC')) THEN
            no_of_new_units_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'NO_OF_NEW_UNITS', data_item_id_);
            create_sscc_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'CREATE_SSCC', data_item_id_);
            IF (create_sscc_ = Gen_Yes_No_API.DB_YES OR no_of_new_units_ > 1) THEN
               automatic_value_ := 'NULL';
            END IF;
   
         ELSE
            Get_Filter_Keys___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_,
                               forward_agent_id_, parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, 
                               data_source_, capture_session_id_, data_item_id_);
   
            IF (data_item_id_ IN ('RECEIVER_ID', 'SHIPMENT_ID', 'SHIPMENT_TYPE', 'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'PARENT_CONSOL_SHIPMENT_ID',
                                  'RECEIVER_ADDR_ID', 'PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
               IF (data_item_id_ IN ('PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  IF (Parent_Is_Not_Used___(capture_session_id_, data_item_id_, parent_handling_unit_id_, parent_sscc_, parent_alt_hand_unit_label_id_)) THEN
                     automatic_value_ := 'NULL'; 
                  END IF;
                  IF (data_item_id_ = 'PARENT_HANDLING_UNIT_ID') THEN
                     column_name_ := 'HANDLING_UNIT_ID';
                  ELSIF (data_item_id_ = 'PARENT_SSCC') THEN
                     column_name_ := 'SSCC';
                  ELSIF (data_item_id_ = 'PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
                     column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
                  END IF;
               ELSE
                  IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_) AND
                      shipment_id_ IS NULL) THEN
                     automatic_value_ := 'NULL';
                  END IF;
                  column_name_ := data_item_id_;
               END IF;
               
               IF (automatic_value_ IS NULL) THEN
                  IF (data_source_ IN ('SHIPMENT', 'NULL_AND_SHIPMENT')) THEN
                     $IF Component_Shpmnt_SYS.INSTALLED $THEN
                        automatic_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_         => dummy_,
                                                                                    contract_                      => contract_,
                                                                                    shipment_id_                   => shipment_id_,
                                                                                    handling_unit_id_              => parent_handling_unit_id_,
                                                                                    receiver_id_                   => receiver_id_,
                                                                                    shipment_type_                 => shipment_type_,
                                                                                    receiver_addr_id_              => receiver_addr_id_,
                                                                                    forward_agent_id_              => forward_agent_id_,
                                                                                    parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                                                    ship_via_code_                 => ship_via_code_,
                                                                                    sscc_                          => parent_sscc_,
                                                                                    alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                                                    column_name_                   => column_name_);
                        IF (data_source_ = 'NULL_AND_SHIPMENT' AND automatic_value_ != 'NULL') THEN
                           automatic_value_ := NULL;  
                           -- if we dont find a unique value or if we actually find a unique value that isnt NULL, then user have to enter this data item,
                           -- since we will then for this data source type have 2 different unique values since NULL is always possible also.
                        END IF;
                     $ELSE
                        NULL;
                     $END
   
                  ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN
   
                     automatic_value_ := Get_Unique_Inv_Ship_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, 
                                                                      receiver_addr_id_, forward_agent_id_, parent_consol_shipment_id_, ship_via_code_, 
                                                                      parent_sscc_, parent_alt_hand_unit_label_id_, column_name_);
   
                  ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('RECEIVER_ID', 'SHIPMENT_TYPE', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 
                                                                              'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'RECEIVER_ADDR_ID'))) THEN
   
                     -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
                     local_parent_handling_unit_id_ := CASE parent_handling_unit_id_ WHEN -1 THEN NULL ELSE parent_handling_unit_id_ END; 
                     automatic_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                      handling_unit_id_           => local_parent_handling_unit_id_,
                                                                                      sscc_                       => parent_sscc_,
                                                                                      alt_handling_unit_label_id_ => parent_alt_hand_unit_label_id_,
                                                                                      column_name_                => column_name_,
                                                                                      sql_where_expression_       => Get_Sql_Where_Expression___);
   
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   $END
   RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2,
   data_item_value_     IN VARCHAR2 )
IS
   contract_                      VARCHAR2(5);
   parent_handling_unit_id_       NUMBER;
   shipment_id_                   NUMBER;
   receiver_id_                   VARCHAR2(50);
   shipment_type_                 VARCHAR2(3);
   receiver_addr_id_              VARCHAR2(50);
   forward_agent_id_              VARCHAR2(20);
   parent_consol_shipment_id_     NUMBER;
   ship_via_code_                 VARCHAR2(3);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   sscc_                          VARCHAR2(18);
   no_of_new_units_               NUMBER;
   create_sscc_                   VARCHAR2(1);
   data_item_description_         VARCHAR2(200);
   column_name_                   VARCHAR2(30);
   dummy_                         BOOLEAN;
   exists_in_invent_              BOOLEAN;
   exists_in_shipment_            BOOLEAN;
   data_source_                   VARCHAR2(30);
   local_parent_handling_unit_id_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ IN ('HANDLING_UNIT_TYPE_ID', 'NO_OF_NEW_UNITS')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
      END IF;

      sscc_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SSCC', data_item_id_);

      IF (data_item_id_ IN ('CREATE_SSCC')) THEN
         Gen_Yes_No_API.Exist_Db(data_item_value_);
         IF (sscc_ IS NOT NULL AND data_item_value_ = Gen_Yes_No_API.DB_YES) THEN
            Error_SYS.Record_General(lu_name_, 'CREATESSCCNOTALLOWEDSSCCSPECIFIED: When a SSCC is already specified a new SSCC cannot be created.');
         END IF;
      ELSIF (data_item_id_ = 'NO_OF_NEW_UNITS') THEN
         Validate_Sscc_New_Units___(capture_session_id_ => capture_session_id_,
                                    sscc_               => sscc_,
                                    no_of_new_units_    => data_item_value_);
         IF ((data_item_value_ < 1) OR (MOD(data_item_value_, 1) != 0)) THEN
            Error_SYS.Record_General(lu_name_, 'NOOFUNITSERROR: No of Units must be an integer greater than zero.');
         END IF;
      ELSIF (data_item_id_ = 'HANDLING_UNIT_TYPE_ID') THEN
         Handling_Unit_Type_API.Exist(data_item_value_);
      ELSIF (data_item_id_ IN ('PRINT_HANDLING_UNIT_LABEL','PRINT_SHIPMENT_LABEL')) THEN
         Gen_Yes_No_API.Exist_Db(data_item_value_);
      ELSIF (data_item_id_ IN ('NO_OF_HANDLING_UNIT_LABELS','NO_OF_SHIPMENT_LABELS')) THEN
         IF data_item_value_ <= 0 OR (data_item_value_ != ROUND(data_item_value_)) THEN
            Error_SYS.Record_General(lu_name_,'NUMBERPOSINT: :P1 must be an integer greater than 0.', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
         END IF; 
      ELSIF (data_item_id_ IN ('SSCC')) THEN
         IF (data_item_value_ IS NOT NULL) THEN
            create_sscc_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'CREATE_SSCC', data_item_id_);
            IF (create_sscc_ = Gen_Yes_No_API.DB_YES AND data_item_value_ != 'NULL') THEN
               Error_SYS.Record_General(lu_name_, 'SSCCSPECIFIEDNOTALLOWEDWHENCREATESSCC: A :P1 cannot be specified when :P2 is :P3.',
                                        Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 'SSCC'),
                                        Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 'CREATE_SSCC'),
                                        Gen_Yes_No_API.Decode(create_sscc_));
            END IF;
            no_of_new_units_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'NO_OF_NEW_UNITS', data_item_id_);
            Validate_Sscc_New_Units___(capture_session_id_ => capture_session_id_,
                                       sscc_               => data_item_value_,
                                       no_of_new_units_    => no_of_new_units_);
            Handling_Unit_API.Validate_Sscc(data_item_value_);
         END IF;
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      ELSE

         Get_Filter_Keys___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_,
                            forward_agent_id_, parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, 
                            data_source_, capture_session_id_, data_item_id_, data_item_value_);
         IF (data_item_id_ IN ('PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            Validate_Parent___(capture_session_id_, data_item_id_, data_item_value_, parent_handling_unit_id_, parent_sscc_, parent_alt_hand_unit_label_id_);
         END IF;
         IF (data_item_id_ IN ('RECEIVER_ID', 'SHIPMENT_TYPE', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'RECEIVER_ADDR_ID')
                OR (data_item_id_ IN ('PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID') AND data_item_value_ IS NOT NULL)) THEN
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            IF (data_item_id_ IN ('PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
               IF (data_item_id_ = 'PARENT_HANDLING_UNIT_ID') THEN
                  column_name_ := 'HANDLING_UNIT_ID';
               ELSIF (data_item_id_ = 'PARENT_SSCC') THEN
                  column_name_ := 'SSCC';
               ELSIF (data_item_id_ = 'PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
                  column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               END IF;
            ELSE
               column_name_ := data_item_id_;
            END IF;


            IF (data_source_ = 'SHIPMENT') OR ((data_source_ = 'NULL_AND_SHIPMENT') AND (data_item_value_ IS NOT NULL)) THEN
               IF (data_source_ = 'SHIPMENT' AND data_item_id_ IN ('SHIPMENT_ID', 'RECEIVER_ADDR_ID', 'SHIPMENT_TYPE', 'RECEIVER_ID') AND data_item_value_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'SHIPITEMISNULL: :P1 is mandatory in this context and requires a value.', data_item_description_);
               END IF;
               $IF Component_Shpmnt_SYS.INSTALLED $THEN
                  Shipment_API.Record_With_Column_Value_Exist(record_exists_                 => dummy_,
                                                              contract_                      => contract_,
                                                              shipment_id_                   => shipment_id_,
                                                              handling_unit_id_              => parent_handling_unit_id_,
                                                              receiver_id_                   => receiver_id_,
                                                              shipment_type_                 => shipment_type_,
                                                              receiver_addr_id_              => receiver_addr_id_,
                                                              forward_agent_id_              => forward_agent_id_,
                                                              parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                              ship_via_code_                 => ship_via_code_,
                                                              sscc_                          => parent_sscc_,
                                                              alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                              column_name_                   => column_name_,
                                                              column_value_                  => data_item_value_,
                                                              column_description_            => data_item_description_);
                  $ELSE
                     NULL;
                  $END
            

            ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN

               -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
               local_parent_handling_unit_id_ := CASE parent_handling_unit_id_ WHEN -1 THEN NULL ELSE parent_handling_unit_id_ END; 
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_                 => exists_in_invent_,
                                                                handling_unit_id_              => local_parent_handling_unit_id_,
                                                                sscc_                          => parent_sscc_,
                                                                alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                                column_name_                   => column_name_,
                                                                column_value_                  => data_item_value_,
                                                                column_description_            => data_item_description_,
                                                                sql_where_expression_          => Get_Sql_Where_Expression___,
                                                                raise_error_                   => FALSE);
               $IF Component_Shpmnt_SYS.INSTALLED $THEN
                  Shipment_API.Record_With_Column_Value_Exist(record_exists_                 => exists_in_shipment_,
                                                              contract_                      => contract_,
                                                              shipment_id_                   => shipment_id_,
                                                              handling_unit_id_              => parent_handling_unit_id_,
                                                              receiver_id_                   => receiver_id_,
                                                              shipment_type_                 => shipment_type_,
                                                              receiver_addr_id_              => receiver_addr_id_,
                                                              forward_agent_id_              => forward_agent_id_,
                                                              parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                              ship_via_code_                 => ship_via_code_,
                                                              sscc_                          => parent_sscc_,
                                                              alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                              column_name_                   => column_name_,
                                                              column_value_                  => data_item_value_,
                                                              column_description_            => data_item_description_,
                                                              raise_error_                   => FALSE);
               $END

               IF (NOT exists_in_invent_ AND NOT exists_in_shipment_) THEN
                  Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', data_item_description_, data_item_value_);
               END IF;
            ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('RECEIVER_ID', 'SHIPMENT_TYPE', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 
                                                                        'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'RECEIVER_ADDR_ID'))) THEN

               -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
               local_parent_handling_unit_id_ := CASE parent_handling_unit_id_ WHEN -1 THEN NULL ELSE parent_handling_unit_id_ END; 
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_                 => dummy_,
                                                                handling_unit_id_              => local_parent_handling_unit_id_,
                                                                sscc_                          => parent_sscc_,
                                                                alt_handling_unit_label_id_    => parent_alt_hand_unit_label_id_,
                                                                column_name_                   => column_name_,
                                                                column_value_                  => data_item_value_,
                                                                column_description_            => data_item_description_,
                                                                sql_where_expression_          => Get_Sql_Where_Expression___);
            END IF;

         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item;
   
   
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_          Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                      VARCHAR2(5);
   handling_unit_type_id_         VARCHAR2(25);
   parent_handling_unit_id_       NUMBER;
   receiver_id_                   VARCHAR2(50);
   shipment_type_                 VARCHAR2(3);
   shipment_id_                   NUMBER;
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   receiver_addr_id_              VARCHAR2(50);
   forward_agent_id_              VARCHAR2(20);
   parent_consol_shipment_id_     NUMBER;
   ship_via_code_                 VARCHAR2(3);
   data_source_                   VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      Get_Filter_Keys___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, 
                         shipment_type_, receiver_addr_id_, forward_agent_id_, parent_consol_shipment_id_, ship_via_code_,
                         parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, capture_session_id_,
                         data_item_id_ => latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('RECEIVER_ID', 'SHIPMENT_ID', 'SHIPMENT_TYPE', 'SHIP_VIA_CODE', 'FORWARD_AGENT_ID',
                                                                    'PARENT_CONSOL_SHIPMENT_ID', 'RECEIVER_ADDR_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN

                  -- To avoid some issues when we have shipment connected data items like RECEIVER_ID, SHIP_VIA_CODE, SHIP_ADDR_NO added as details early in the configuration 
                  -- on for example HANDLING_UNIT_TYPE_ID and no shipment connected data item have been scanned yet or if the current data item is the first real shipment data item and its NULL. 
                  -- In those cases Get_Data_Source method can't decide yet which data source to use so it will be INVENT_AND_SHIPMENT when in this case for this details method 
                  -- it should have been NULL_AND_SHIPMENT for these details/filters, so here we risk getting some unique values for them if the shipment data source only have 1 unique record 
                  -- for that data item. 
                  -- Thats reason for this check here, its not perfect solution but its special case only for this method and not for the other unique methods in this process.
                  IF (shipment_id_ IS NULL) AND (data_source_ = 'INVENT_AND_SHIPMENT') AND
                     (conf_item_detail_tab_(i).data_item_detail_id IN ('RECEIVER_ID', 'SHIPMENT_ID', 'SHIPMENT_TYPE', 'SHIP_VIA_CODE', 
                                                                       'FORWARD_AGENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'RECEIVER_ADDR_ID')) AND
                     (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, latest_data_item_id_, 'SHIPMENT_ID', equal_is_before_ => TRUE) AND
                      Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, latest_data_item_id_, 'RECEIVER_ID', equal_is_before_ => TRUE) AND
                      Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, latest_data_item_id_, 'SHIPMENT_TYPE', equal_is_before_ => TRUE) AND
                      Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, latest_data_item_id_, 'RECEIVER_ADDR_ID', equal_is_before_ => TRUE)) THEN
                     IF (latest_data_item_id_ NOT IN ('SHIPMENT_ID', 'RECEIVER_ID', 'SHIPMENT_TYPE', 'RECEIVER_ADDR_ID', 'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'PARENT_CONSOL_SHIPMENT_ID') OR
                         (latest_data_item_id_ IN ('SHIPMENT_ID', 'RECEIVER_ID', 'SHIPMENT_TYPE', 'RECEIVER_ADDR_ID', 'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'PARENT_CONSOL_SHIPMENT_ID') 
                          AND latest_data_item_value_ IS NULL)) THEN
                        -- Clearing the shipment items
                        receiver_id_ := NULL;
                        shipment_type_ := NULL;
                        receiver_addr_id_ := NULL;
                        forward_agent_id_ := NULL;
                        parent_consol_shipment_id_ := NULL;
                        ship_via_code_ := NULL;
                     END IF;
                  END IF;

                  -- FILTER DATA ITEMS AS DETAILS
                  Add_Filter_Key_Detail___(capture_session_id_            => capture_session_id_,
                                           owning_data_item_id_           => latest_data_item_id_,
                                           data_item_detail_id_           => conf_item_detail_tab_(i).data_item_detail_id,
                                           shipment_id_                   => shipment_id_,
                                           parent_handling_unit_id_       => parent_handling_unit_id_,
                                           receiver_id_                   => receiver_id_,
                                           shipment_type_                 => shipment_type_,
                                           receiver_addr_id_              => receiver_addr_id_,
                                           forward_agent_id_              => forward_agent_id_,
                                           parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                           ship_via_code_                 => ship_via_code_,
                                           parent_sscc_                   => parent_sscc_,
                                           parent_alt_hand_unit_label_id_ => parent_alt_hand_unit_label_id_);
               ELSE
                  -- RESIDUAL DATA ITEMS AS DETAILS
                  Add_Unique_Data_Item_Detail___(capture_session_id_     => capture_session_id_,
                                                 session_rec_            => session_rec_,
                                                 owning_data_item_id_    => latest_data_item_id_,
                                                 owning_data_item_value_ => latest_data_item_value_,
                                                 data_item_detail_id_    => conf_item_detail_tab_(i).data_item_detail_id);
               END IF;
            ELSE  
               -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('CREATED_DATE', 'RECEIVER_COUNTRY', 'RECEIVER_REFERENCE',
                                                                    'DELIVERY_TERMS', 'RECEIVER_DESCRIPTION', 'LOAD_SEQUENCE_NO',
                                                                    'ROUTE_ID', 'SENDER_REFERENCE', 'SHIP_DATE',
                                                                    'SHIP_INVENTORY_LOCATION_NO', 'SHIPMENT_STATUS', 
                                                                    'SHIP_VIA_DESC', 'RECEIVER_ADDRESS_NAME')) THEN
                  $IF Component_Shpmnt_SYS.INSTALLED $THEN
                     -- Feedback items related to shipment
                     Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_        => capture_session_id_,
                                                                           owning_data_item_id_       => latest_data_item_id_,
                                                                           data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           shipment_id_               => shipment_id_);
                  $ELSE
                     NULL;
                  $END
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_TYPE_DESC', 'HANDLING_UNIT_TYPE_CATEG_ID', 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                                       'HANDLING_UNIT_TYPE_WIDTH', 'HANDLING_UNIT_TYPE_HEIGHT', 'HANDLING_UNIT_TYPE_DEPTH',
                                                                       'HANDLING_UNIT_TYPE_UOM_LENGTH', 'HANDLING_UNIT_TYPE_VOLUME', 'HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                                       'HANDLING_UNIT_TYPE_TARE_WEIGHT', 'HANDLING_UNIT_TYPE_UOM_WEIGHT', 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                                       'HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'HANDLING_UNIT_TYPE_MAX_WGT_CAP', 'HANDLING_UNIT_TYPE_STACKABLE',
                                                                       'HANDLING_UNIT_TYPE_GEN_SSCC', 'HANDLING_UNIT_TYPE_COST', 'HANDLING_UNIT_TYPE_CURR_CODE')) THEN
                  handling_unit_type_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, latest_data_item_id_, latest_data_item_value_, 'HANDLING_UNIT_TYPE_ID', session_rec_);
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_    => capture_session_id_,
                                                                              owning_data_item_id_   => latest_data_item_id_,
                                                                              data_item_detail_id_   => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_type_id_ => handling_unit_type_id_);
               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;   


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   process_package_               VARCHAR2(30);
   contract_                      VARCHAR2(5);
   parent_handling_unit_id_       NUMBER;
   receiver_id_                   VARCHAR2(50);
   shipment_type_                 VARCHAR2(3);
   shipment_id_                   NUMBER;
   receiver_addr_id_              VARCHAR2(50);
   forward_agent_id_              VARCHAR2(20);
   parent_consol_shipment_id_     NUMBER;
   ship_via_code_                 VARCHAR2(3);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   data_source_                   VARCHAR2(30);
   fixed_value_is_applicable_     BOOLEAN := FALSE;
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_ => FALSE);

      -- if predicted shipment_id_ is null then try fetch it with unique handling
      IF (shipment_id_ IS NULL) THEN
         Get_Filter_Keys___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_,
                            forward_agent_id_, parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, 
                            data_source_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);

         shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, parent_handling_unit_id_, receiver_id_, shipment_type_, receiver_addr_id_, forward_agent_id_,
                                                       parent_consol_shipment_id_, ship_via_code_, parent_sscc_, parent_alt_hand_unit_label_id_, data_source_, 'SHIPMENT_ID');
      END IF;   

      -- if shipment_id_ still is null, check if the value actually will be null due to fixed handling or
      -- if shipment id was before current data item so it actually is set as null in the session already
      -- then set the fixed_value_is_applicable_ flag as TRUE and framework will use the configured fixed value for this data item (in this case probably NULL).
      IF (shipment_id_ IS NULL AND 
          (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID') OR 
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_))) THEN
         fixed_value_is_applicable_ := TRUE;
      END IF;   -- TODO: this part migh need to be moved to a DataCaptShpmntUtil as a new method like similar in invent for example

   $END

   RETURN fixed_value_is_applicable_;

END Fixed_Value_Is_Applicable;


