-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptChangeParentHu
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: CHANGE_PARENT_HANDLING_UNIT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200817  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  200311  DaZase  SCXTEND-3803, Small change in Create_List_Of_Values to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171207  MaAuse  STRSC-15087, Modified Execute_Process by adding call to Handling_Unit_API.Check_Max_Capacity_Exceeded.
--  171017  DaZase  STRSC-13001, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171017          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170217  DaZase  Changes in Get_Sql_Invent_Where_Expr___ due to unique Handling_Unit_API
--  170217          methods now uses table instead of extended view for performance reasons, 
--  170217          so a contract/user allowed site check was added since that was on extended view.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160203  DaZase  LIM-4572, Reworked and renamed DataCapChgParentHuShp to DataCaptChangeParentHu and moved it from ORDER to INVENT. 
--  160203          The old ORDER DataCapChgParentHuShp is now obsolete and replaced with this file. This process now support Changing parent HU 
--  160203          both in Inventory and in Shipment.
--  151028  Erlise  LIM-3775, Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID and 
--  151028          PARENT_ALT_TRANSPORT_LABEL_ID to PARENT_ALT_HANDLING_UNIT_LABEL_ID.
--  151027  DaZase  LIM-4297, Changed calls to Add_Details_For_Hand_Unit_Type and Add_Details_For_Handling_Unit 
--  151027          so they now call Data_Capture_Invent_Util_API instead of Data_Capture_Order_Util_API.                  
--  151026  DaZase  LIM-4297, Renamed method call Get_Handling_Unit_From_Atl_Id to Get_Handling_Unit_From_Alt_Id.
--  150316  RILASE  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER := -1;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_Data_Source___ (
   shipment_id_               IN NUMBER,
   parent_consol_shipment_id_ IN NUMBER,
   session_rec_               IN Data_Capture_Common_Util_API.Session_Rec,
   data_item_id_              IN  VARCHAR2 ) RETURN VARCHAR2
IS
   data_source_               VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      $IF Component_Shpmnt_SYS.INSTALLED $THEN

         IF (shipment_id_ IS NOT NULL OR parent_consol_shipment_id_ IS NOT NULL) THEN
            -- If any of the shipment filter keys are not NULL then we are using SHIPMENT
            data_source_ := 'SHIPMENT';

         ELSE -- All shipment filter keys are at the moment NULL
            -- Check shipment if data item is one of the shipment only data items
            IF (data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID')) THEN
               -- If any of the shipment only and not nullable items comes before current item
               IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
                  -- then we know that this is INVENT only since at least one of the shipment only and not nullable items ARE NULL 
                  data_source_ := 'INVENT';
               ELSE  -- None of the shipment only and not nullable items comes before current item
                  -- If any of shipment only and not nullable items will be set as NULL by fixed value handling
                  IF (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID')) THEN
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
               IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
                  -- then we know that this is INVENT only since at least one of the shipment only and not nullable items ARE NULL 
                  data_source_ := 'INVENT';
               ELSE  -- None of the shipment only and not nullable items comes before current item
                  -- If any of shipment only and not nullable items will be set as NULL by fixed value handling
                  IF (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID')) THEN
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
   handling_unit_id_              OUT NUMBER,
   parent_handling_unit_id_       OUT NUMBER,
   parent_consol_shipment_id_     OUT NUMBER,
   sscc_                          OUT VARCHAR2,
   parent_sscc_                   OUT VARCHAR2,
   alt_handling_unit_label_id_    OUT VARCHAR2,
   parent_alt_hand_unit_label_id_ OUT VARCHAR2,
   data_source_                   OUT VARCHAR2,
   capture_session_id_            IN  NUMBER,
   data_item_id_                  IN  VARCHAR2,
   data_item_value_               IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_             IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_                IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   process_package_     VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      shipment_id_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      parent_handling_unit_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'NEW_PARENT_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      parent_consol_shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_CONSOL_SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      parent_sscc_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'NEW_PARENT_SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      parent_alt_hand_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);

  
      -- TODO: how could parent_sscc_/parent_alt_hand_unit_label_id_ even have string_all_values_ here since they are actually set to that value afterwards? those controls feels a bit unnecessary
      IF (parent_handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'NEW_PARENT_HANDLING_UNIT_ID', data_item_id_)) THEN
         -- Get parent handling unit id from "alternative keys" parent_sscc_ and parent_alt_hand_unit_label_id_ to be able to validate
         IF (parent_sscc_ IS NOT NULL AND parent_sscc_ != string_all_values_) THEN
            parent_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(parent_sscc_);
         ELSIF (parent_alt_hand_unit_label_id_ IS NOT NULL AND parent_alt_hand_unit_label_id_ != string_all_values_) THEN
            parent_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(parent_alt_hand_unit_label_id_);
            IF (parent_handling_unit_id_ IS NULL) THEN  -- we could still not have found a unique parent handling unit id since several HU's could be connected to 1 Alt Handling Unit Label ID
               parent_handling_unit_id_ := number_all_values_;
            END IF;
         ELSE
            parent_handling_unit_id_ := number_all_values_;
         END IF;
      END IF;
      IF (parent_sscc_ IS NULL AND parent_handling_unit_id_ IS NOT NULL) THEN
         parent_sscc_ := Handling_Unit_API.Get_Sscc(parent_handling_unit_id_);
      END IF;
      IF (parent_alt_hand_unit_label_id_ IS NULL AND parent_handling_unit_id_ IS NOT NULL) THEN
         parent_alt_hand_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(parent_handling_unit_id_);
      END IF;

      IF (handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) THEN
         -- Get handling unit id from "alternative keys" sscc_ and alt_handling_unit_label_id_ to be able to validate
         IF (sscc_ IS NOT NULL AND sscc_ != string_all_values_) THEN
            handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_);
         ELSIF (alt_handling_unit_label_id_ IS NOT NULL AND alt_handling_unit_label_id_ != string_all_values_) THEN
            handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(alt_handling_unit_label_id_);
            IF (handling_unit_id_ IS NULL) THEN  -- we could still not have found a unique handling unit id since several HU's could be connected to 1 Alt Handling Unit Label ID
               handling_unit_id_ := number_all_values_; 
            END IF;
         ELSE
            handling_unit_id_ := number_all_values_;
         END IF;
      END IF;
      IF (sscc_ IS NULL AND handling_unit_id_ IS NOT NULL) THEN
         sscc_ := Handling_Unit_API.Get_Sscc(handling_unit_id_);
      END IF;
      IF (alt_handling_unit_label_id_ IS NULL AND handling_unit_id_ IS NOT NULL) THEN
         alt_handling_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(handling_unit_id_);
      END IF;
      IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'SHIPMENT_ID', equal_is_before_ => TRUE)) THEN
         -- Try and fetch shipment_id from hu
         IF (shipment_id_ IS NULL AND handling_unit_id_ IS NOT NULL AND handling_unit_id_ != number_all_values_) THEN
            shipment_id_ := Handling_Unit_API.Get_Shipment_Id(handling_unit_id_);
         END IF;
         -- Try and fetch shipment_id from parent hu
         IF (shipment_id_ IS NULL AND parent_handling_unit_id_ IS NOT NULL AND parent_handling_unit_id_ != number_all_values_) THEN
            shipment_id_ := Handling_Unit_API.Get_Shipment_Id(parent_handling_unit_id_);
         END IF;
      END IF;

      -- Fetch the data source that should be used
      data_source_ := Get_Data_Source___(shipment_id_, parent_consol_shipment_id_, session_rec_, data_item_id_);

      IF (shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
         shipment_id_ := number_all_values_;
      END IF;

      IF (parent_consol_shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_CONSOL_SHIPMENT_ID', data_item_id_)) THEN
         parent_consol_shipment_id_ := number_all_values_;
      END IF;
      
      IF (sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := string_all_values_;
      END IF;

      IF (parent_sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'NEW_PARENT_SSCC', data_item_id_)) THEN
         parent_sscc_ := string_all_values_;
      END IF;

      IF (alt_handling_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := string_all_values_;
      END IF;

      IF (parent_alt_hand_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         parent_alt_hand_unit_label_id_ := string_all_values_;
      END IF;

      IF (use_unique_values_) THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (shipment_id_ IS NULL OR shipment_id_ = number_all_values_) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, data_source_, 'SHIPMENT_ID');
         END IF;
         IF (parent_consol_shipment_id_ IS NULL OR parent_consol_shipment_id_ = number_all_values_) THEN
            parent_consol_shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, data_source_, 'PARENT_CONSOL_SHIPMENT_ID');
         END IF;
         IF (handling_unit_id_ IS NULL OR handling_unit_id_ = number_all_values_) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, data_source_, 'HANDLING_UNIT_ID');
         END IF;
         IF (sscc_ IS NULL OR sscc_ = string_all_values_) THEN
            sscc_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, data_source_, 'SSCC');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL OR alt_handling_unit_label_id_ = string_all_values_) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, data_source_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
      END IF;

   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                      IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   handling_unit_id_              IN NUMBER,
   parent_consol_shipment_id_     IN NUMBER,
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   parent_handling_unit_id_       IN NUMBER,
   data_source_                   IN VARCHAR2,
   wanted_data_item_id_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_                 VARCHAR2(200);
   dummy_                        BOOLEAN;
   local_handling_unit_id_        NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (wanted_data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN

      IF (data_source_ = 'SHIPMENT') THEN
         $IF Component_Shpmnt_SYS.INSTALLED $THEN
            unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                     contract_                   => contract_,
                                                                     shipment_id_                => shipment_id_,
                                                                     handling_unit_id_           => handling_unit_id_,
                                                                     parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                     sscc_                       => sscc_,
                                                                     alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                     column_name_                => wanted_data_item_id_,
                                                                     sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___(wanted_data_item_id_, handling_unit_id_, parent_handling_unit_id_));
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
        unique_value_ := Get_Unique_Inv_Ship_Value___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, wanted_data_item_id_);

      ELSIF ((data_source_ = 'INVENT') AND (wanted_data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN
         -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
         local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
         unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                       handling_unit_id_           => local_handling_unit_id_,
                                                                       sscc_                       => sscc_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       column_name_                => wanted_data_item_id_,
                                                                       sql_where_expression_       => Get_Sql_Invent_Where_Expr___(wanted_data_item_id_, handling_unit_id_, parent_handling_unit_id_));
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
   parent_consol_shipment_id_     IN NUMBER,
   handling_unit_id_              IN NUMBER,
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   parent_handling_unit_id_       IN NUMBER,
   column_name_                   IN VARCHAR2 ) RETURN VARCHAR2

IS
   unique_value_                  VARCHAR2(200);
   shipment_unique_value_         VARCHAR2(200);
   invent_unique_value_           VARCHAR2(200);
   shpmnt_no_unique_value_found_  BOOLEAN; 
   invent_no_unique_value_found_  BOOLEAN;
   local_handling_unit_id_        NUMBER;
BEGIN
   IF (column_name_ NOT IN ('PARENT_CONSOL_SHIPMENT_ID')) THEN
      -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
      local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
      invent_unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => invent_no_unique_value_found_,
                                                                           handling_unit_id_           => local_handling_unit_id_,
                                                                           sscc_                       => sscc_,
                                                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                           column_name_                => column_name_,
                                                                           sql_where_expression_       => Get_Sql_Invent_Where_Expr___(column_name_, handling_unit_id_, parent_handling_unit_id_));
   ELSE
      invent_no_unique_value_found_ := TRUE; 
   END IF;

   $IF Component_Shpmnt_SYS.INSTALLED $THEN
      shipment_unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => shpmnt_no_unique_value_found_,
                                                                        contract_                   => contract_,
                                                                        shipment_id_                => shipment_id_,
                                                                        handling_unit_id_           => handling_unit_id_,
                                                                        parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                        sscc_                       => sscc_,
                                                                        alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                        column_name_                => column_name_,
                                                                        sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___(column_name_, handling_unit_id_, parent_handling_unit_id_));
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

   
PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_            IN NUMBER,
   owning_data_item_id_           IN VARCHAR2,
   data_item_detail_id_           IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   handling_unit_id_              IN NUMBER,
   parent_handling_unit_id_       IN NUMBER,
   parent_consol_shipment_id_     IN NUMBER,
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2)  
IS
   detail_value_                 VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('SHIPMENT_ID') THEN
            IF (shipment_id_ != number_all_values_) THEN
               detail_value_ := shipment_id_;
            END IF;
         WHEN ('HANDLING_UNIT_ID') THEN
            IF (handling_unit_id_ != number_all_values_) THEN
               detail_value_ := handling_unit_id_;
            END IF;
         WHEN ('NEW_PARENT_HANDLING_UNIT_ID') THEN
            IF (parent_handling_unit_id_ != number_all_values_) THEN
               detail_value_ := parent_handling_unit_id_;
            END IF;
         WHEN ('PARENT_CONSOL_SHIPMENT_ID') THEN
            IF (parent_consol_shipment_id_ != number_all_values_) THEN
               detail_value_ := parent_consol_shipment_id_;
            END IF;
         WHEN ('SSCC') THEN
            IF (sscc_ != string_all_values_) THEN
               detail_value_ := sscc_;
            END IF;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            IF (alt_handling_unit_label_id_ != string_all_values_) THEN
               detail_value_ := alt_handling_unit_label_id_;
            END IF;
         WHEN ('NEW_PARENT_SSCC') THEN
            IF (parent_sscc_ != string_all_values_) THEN
               detail_value_ := parent_sscc_;
            END IF;
         WHEN ('NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
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

-- TODO: This probably wrong and should be removed
FUNCTION Parent_Is_Shipment_Root___(
   capture_session_id_            IN NUMBER,
   data_item_id_                  IN VARCHAR2,
   parent_handling_unit_id_       IN NUMBER,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2) RETURN BOOLEAN
IS
   parent_is_shipment_root_       BOOLEAN := FALSE;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF ((Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'NEW_PARENT_HANDLING_UNIT_ID', data_item_id_) AND parent_handling_unit_id_ IS NULL) OR
          (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'NEW_PARENT_SSCC', data_item_id_) AND parent_sscc_ IS NULL) OR
          (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_) AND parent_alt_hand_unit_label_id_ IS NULL)) THEN
         parent_is_shipment_root_ := TRUE;
      END IF;
      
   $END
   RETURN parent_is_shipment_root_;
END Parent_Is_Shipment_Root___;
      
-- TODO: This probably wrong and should be removed   
PROCEDURE Validate_Parent___(
   capture_session_id_            IN NUMBER,
   data_item_id_                  IN VARCHAR2,
   data_item_value_               IN VARCHAR2,
   parent_handling_unit_id_       IN NUMBER,
   parent_sscc_                   IN VARCHAR2,
   parent_alt_hand_unit_label_id_ IN VARCHAR2 )
IS
BEGIN
   IF (Parent_Is_Shipment_Root___(capture_session_id_, data_item_id_, parent_handling_unit_id_, parent_sscc_, parent_alt_hand_unit_label_id_) AND data_item_value_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PARENTISROOTNOVALUEALLOWED: A parent cannot be specified if the another parent item has been specified as empty and the handling unit shall be added to the shipment root level.');
   END IF;
END Validate_Parent___;   


FUNCTION Get_Sql_Where_Expression___(
   data_item_id_            IN VARCHAR2,
   handling_unit_id_        IN NUMBER, 
   parent_handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   sql_where_expression_ VARCHAR2(2000); 
BEGIN
   IF (data_item_id_ IN ('NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_SSCC', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID') AND 
       handling_unit_id_ IS NOT NULL AND handling_unit_id_ != number_all_values_) THEN
      sql_where_expression_ := ' AND handling_unit_id != ' || handling_unit_id_ || ' ';
   ELSIF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID') AND 
       parent_handling_unit_id_ IS NOT NULL AND parent_handling_unit_id_ != number_all_values_) THEN
      sql_where_expression_ := ' AND handling_unit_id != ' || parent_handling_unit_id_ || ' ';
   END IF;
   RETURN sql_where_expression_;
END Get_Sql_Where_Expression___;


FUNCTION Get_Sql_Shpmnt_Where_Expr___(
   data_item_id_            IN VARCHAR2,
   handling_unit_id_        IN NUMBER, 
   parent_handling_unit_id_ IN NUMBER )  RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Sql_Where_Expression___(data_item_id_, handling_unit_id_, parent_handling_unit_id_) || ' AND handling_unit_id IS NOT NULL AND state = ''Preliminary'' ';
END Get_Sql_Shpmnt_Where_Expr___;


FUNCTION Get_Sql_Invent_Where_Expr___(
   data_item_id_            IN VARCHAR2,
   handling_unit_id_        IN NUMBER, 
   parent_handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Sql_Where_Expression___(data_item_id_, handling_unit_id_, parent_handling_unit_id_) || ' AND shipment_id IS NULL AND (contract IS NULL OR EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE contract = site)) ';
END Get_Sql_Invent_Where_Expr___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'ADDINGOK: The parent handling unit was changed.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'ADDINGSOK: :P1 handling unit parents were changed.', NULL, no_of_records_handled_);
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
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   ptr_                         NUMBER;
   name_                        VARCHAR2(50);
   value_                       VARCHAR2(4000);
   handling_unit_id_            NUMBER;
   parent_handling_unit_id_     NUMBER;
   max_weight_volume_error_     VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'HANDLING_UNIT_ID') THEN
            handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'NEW_PARENT_HANDLING_UNIT_ID') THEN
            parent_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         END IF;
      END LOOP;

      Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_, parent_handling_unit_id_);
      
      max_weight_volume_error_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'MAX_WEIGHT_VOLUME_ERROR');
      IF(max_weight_volume_error_ = Fnd_Boolean_API.DB_TRUE) THEN 
         Handling_Unit_API.Check_Max_Capacity_Exceeded(handling_unit_id_);
      END IF;
   $ELSE
      NULL;
   $END
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Handling_Unit_API.Modify_Parent_Handling_Unit_Id is granted thru any of following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsInReceiptHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseTierHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseNavigatorHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseRowHandling', 'ModifyParentHandlingUnitId') OR 
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseLocHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseBayHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsInStockHandling', 'ModifyParentHandlingUnitId') OR 
       Security_SYS.Is_Proj_Action_Available('HandlingUnitHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitHandling', 'ModifyParentHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentHandlingUnitStructureHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentHandlingUnitStructureHandling', 'ModifyParentHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('ShopFloorWorkbenchHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('ShopOrderHandlingUnitStructureHandling', 'ModifyParentHandlingUnitId') OR
       Security_SYS.Is_Proj_Action_Available('ShopOrderHandlingUnitStructureHandling', 'MoveToRootNode') OR
       Security_SYS.Is_Proj_Action_Available('ShopOrderHandlingUnitStructureHandling', 'ModifyParentHandlingUnit')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;

   
PROCEDURE Create_List_Of_Values (
   capture_session_id_  IN NUMBER,
   capture_process_id_  IN VARCHAR2,
   capture_config_id_   IN NUMBER,
   data_item_id_        IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS
   handling_unit_id_              NUMBER;
   org_handling_unit_id_          NUMBER;
   parent_handling_unit_id_       NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   dummy_contract_                VARCHAR2(5);
   column_name_                   VARCHAR2(30);
   dummy_exit_lov_                BOOLEAN;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   lov_type_db_                   VARCHAR2(20);
   local_handling_unit_id_        NUMBER;
   data_source_                   VARCHAR2(30);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID',
                            'NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_SSCC', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
   
         Get_Filter_Keys___(dummy_contract_, shipment_id_, handling_unit_id_, parent_handling_unit_id_, parent_consol_shipment_id_, sscc_, parent_sscc_,
                            alt_handling_unit_label_id_, parent_alt_hand_unit_label_id_, data_source_, capture_session_id_, data_item_id_);
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
         org_handling_unit_id_ := handling_unit_id_;
   
         IF (data_item_id_ = 'NEW_PARENT_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (data_item_id_ = 'NEW_PARENT_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (data_item_id_ = 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSE
            column_name_ := data_item_id_;
         END IF;
         IF (data_item_id_ IN ('NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_SSCC', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            -- NOTE: LOV for parent will only look at values in the same shipment, not filter on unique records
            handling_unit_id_       := NVL(parent_handling_unit_id_, number_all_values_);
            sscc_                   := NVL(parent_sscc_, string_all_values_);
            alt_handling_unit_label_id_ := NVL(parent_alt_hand_unit_label_id_, string_all_values_);
         END IF;
   
         IF (data_source_ = 'NULL_AND_SHIPMENT') THEN
            -- add first a NULL LOV line
            Data_Capture_Session_Lov_API.New(exit_lov_              => dummy_exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => NULL,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => Data_Capture_Config_API.Get_Lov_Row_Limitation(capture_process_id_, capture_config_id_),    
                                             session_rec_           => session_rec_);
         END IF;
   
         IF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) OR
            (data_source_ = 'INVENT_AND_SHIPMENT') THEN
            -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
            local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END;
   
            Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_           => local_handling_unit_id_,
                                                      sscc_                       => sscc_,
                                                      alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                      capture_session_id_         => capture_session_id_,
                                                      column_name_                => column_name_,
                                                      lov_type_db_                => lov_type_db_,
                                                      sql_where_expression_       => Get_Sql_Invent_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_));
         END IF;
   
         IF (data_source_ IN ('SHIPMENT', 'NULL_AND_SHIPMENT', 'INVENT_AND_SHIPMENT')) THEN
            $IF Component_Shpmnt_SYS.INSTALLED $THEN
               Shipment_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                    shipment_id_                => shipment_id_,
                                                    handling_unit_id_           => handling_unit_id_,
                                                    parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                    sscc_                       => sscc_,
                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                    capture_session_id_         => capture_session_id_,
                                                    column_name_                => column_name_,
                                                    lov_type_db_                => lov_type_db_,
                                                    sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_));
   
            $ELSE
               NULL;
            $END
         END IF;
   
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
   handling_unit_id_              NUMBER;
   org_handling_unit_id_          NUMBER;
   parent_handling_unit_id_       NUMBER;
   shipment_id_                   NUMBER;
   contract_                      VARCHAR2(5);
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   alt_handling_unit_label_id_    VARCHAR2(25);
   automatic_value_               VARCHAR2(200);
   column_name_                   VARCHAR2(30);
   dummy_                         BOOLEAN;
   data_source_                   VARCHAR2(30);
   local_handling_unit_id_        NUMBER;
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));
   $END

   IF (automatic_value_ IS NULL) THEN

      Get_Filter_Keys___(contract_, shipment_id_, handling_unit_id_, parent_handling_unit_id_, parent_consol_shipment_id_, sscc_, parent_sscc_,
                      alt_handling_unit_label_id_, parent_alt_hand_unit_label_id_, data_source_, capture_session_id_, data_item_id_);


      org_handling_unit_id_ := handling_unit_id_;
      IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID',
                            'NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_SSCC', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
         
         IF (data_item_id_ = 'NEW_PARENT_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (data_item_id_ = 'NEW_PARENT_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (data_item_id_ = 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSE
            column_name_ := data_item_id_;
         END IF;
         IF (data_item_id_ IN ('NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_SSCC', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            -- NOTE: Automatic value for parent will fetch values in the same shipment, not filter on unique records
            handling_unit_id_       := NVL(parent_handling_unit_id_, number_all_values_);
            sscc_                   := NVL(parent_sscc_, string_all_values_);
            alt_handling_unit_label_id_ := NVL(parent_alt_hand_unit_label_id_, string_all_values_);
         END IF;
   
         IF (data_source_ IN ('SHIPMENT', 'NULL_AND_SHIPMENT')) THEN
            $IF Component_Shpmnt_SYS.INSTALLED $THEN
               automatic_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                           contract_                   => contract_,
                                                                           shipment_id_                => shipment_id_,
                                                                           handling_unit_id_           => handling_unit_id_,
                                                                           parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                           sscc_                       => sscc_,
                                                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                           column_name_                => column_name_,
                                                                           sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_));
         
               IF (data_source_ = 'NULL_AND_SHIPMENT' AND automatic_value_ != 'NULL') THEN
                  automatic_value_ := NULL;  
                  -- if we dont find a unique value or if we actually find a unique value that isnt NULL, then user have to enter this data item,
                  -- since we will then for this data source type have 2 different unique values since NULL is always possible also.
               END IF;
            $ELSE
               NULL;
            $END
   
   
         ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN
            automatic_value_ := Get_Unique_Inv_Ship_Value___(contract_, shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, column_name_);
   
         ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN
            -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
            local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
            automatic_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                             handling_unit_id_           => local_handling_unit_id_,
                                                                             sscc_                       => sscc_,
                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                             column_name_                => column_name_,
                                                                             sql_where_expression_       => Get_Sql_Invent_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_));
   
         ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN
            automatic_value_ := 'NULL';
         END IF;
      END IF;
   END IF;

   RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2,
   data_item_value_     IN VARCHAR2 )
IS
   contract_                      VARCHAR2(5);
   handling_unit_id_              NUMBER;
   org_handling_unit_id_          NUMBER;
   parent_handling_unit_id_       NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   data_item_description_         VARCHAR2(200);
   sscc_                          VARCHAR2(18);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   alt_handling_unit_label_id_    VARCHAR2(25);
   column_name_                   VARCHAR2(30); 
   dummy_                         BOOLEAN;
   data_source_                   VARCHAR2(30);
   validate_item_                 BOOLEAN := TRUE;
   exists_in_invent_              BOOLEAN;
   exists_in_shipment_            BOOLEAN;
   local_handling_unit_id_        NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(contract_, shipment_id_, handling_unit_id_, parent_handling_unit_id_, parent_consol_shipment_id_, sscc_, parent_sscc_,
                         alt_handling_unit_label_id_, parent_alt_hand_unit_label_id_, data_source_, capture_session_id_, data_item_id_, data_item_value_);
         
      org_handling_unit_id_ := handling_unit_id_;

      IF (handling_unit_id_ IS NOT NULL AND handling_unit_id_ != number_all_values_ AND parent_handling_unit_id_ IS NOT NULL AND parent_handling_unit_id_ != number_all_values_) THEN
         Handling_Unit_API.Check_Structure(handling_unit_id_        => handling_unit_id_,
                                           parent_handling_unit_id_ => parent_handling_unit_id_);
      END IF;
      
      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
      IF (data_item_id_ IN ('SHIPMENT_ID', 'HANDLING_UNIT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID',
                            'NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_SSCC', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
         IF (data_item_id_ IN ('HANDLING_UNIT_ID')) THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
            IF (data_item_id_ = 'HANDLING_UNIT_ID') THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
         END IF;

         IF (data_item_id_ IN ('NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_SSCC', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID') ) THEN
            IF (data_item_value_ IS NOT NULL) THEN
               IF (data_item_id_ = 'NEW_PARENT_HANDLING_UNIT_ID') THEN
                  Handling_Unit_API.Exist(data_item_value_);
                  column_name_ := 'HANDLING_UNIT_ID';
               ELSIF (data_item_id_ = 'NEW_PARENT_SSCC') THEN
                  column_name_ := 'SSCC';
               ELSIF (data_item_id_ = 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID') THEN
                  column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               END IF;
               -- NOTE: Validation for parent will look at values already defined by another parent, or all values.
               handling_unit_id_       := NVL(parent_handling_unit_id_, number_all_values_);
               sscc_                   := NVL(parent_sscc_, string_all_values_);
               alt_handling_unit_label_id_ := NVL(parent_alt_hand_unit_label_id_, string_all_values_);
            ELSE   -- Dont validate parent keys if value is NULL
               validate_item_ := FALSE;
            END IF;
         ELSIF (data_item_id_ = 'SHIPMENT_ID' AND (handling_unit_id_ IS NULL OR handling_unit_id_ = number_all_values_) AND
                (parent_handling_unit_id_ IS NOT NULL AND parent_handling_unit_id_ != number_all_values_)) THEN
            -- if we have a parent hu but not a hu yet, then use parent hu keys for the validation of shipment_id
            handling_unit_id_       := NVL(parent_handling_unit_id_, number_all_values_);
            sscc_                   := NVL(parent_sscc_, string_all_values_);
            alt_handling_unit_label_id_ := NVL(parent_alt_hand_unit_label_id_, string_all_values_);
            column_name_ := data_item_id_;
         ELSE
            column_name_ := data_item_id_;
         END IF;

         IF (validate_item_) THEN

            IF (data_source_ = 'SHIPMENT') OR ((data_source_ = 'NULL_AND_SHIPMENT') AND (data_item_value_ IS NOT NULL)) THEN
               IF (data_source_ = 'SHIPMENT' AND data_item_id_ IN ('SHIPMENT_ID') AND data_item_value_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'SHIPITEMISNULL: :P1 is mandatory in this context and requires a value.', data_item_description_);
               END IF;
               $IF Component_Shpmnt_SYS.INSTALLED $THEN
                  Shipment_API.Record_With_Column_Value_Exist(record_exists_              => dummy_,
                                                              contract_                   => contract_,
                                                              shipment_id_                => shipment_id_,
                                                              handling_unit_id_           => handling_unit_id_,
                                                              parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                              sscc_                       => sscc_,
                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                              column_name_                => column_name_,
                                                              column_value_               => data_item_value_,
                                                              column_description_         => data_item_description_,
                                                              sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_));
               $ELSE
                  NULL;
               $END           

            ELSIF (data_source_ = 'INVENT_AND_SHIPMENT') THEN

               -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
               local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_                 => exists_in_invent_,
                                                                handling_unit_id_              => local_handling_unit_id_,
                                                                sscc_                          => sscc_,
                                                                alt_handling_unit_label_id_    => alt_handling_unit_label_id_,
                                                                column_name_                   => column_name_,
                                                                column_value_                  => data_item_value_,
                                                                column_description_            => data_item_description_,
                                                                sql_where_expression_          => Get_Sql_Invent_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_),
                                                                raise_error_                   => FALSE);

               $IF Component_Shpmnt_SYS.INSTALLED $THEN
                  
                  Shipment_API.Record_With_Column_Value_Exist(record_exists_              => exists_in_shipment_,
                                                              contract_                   => contract_,
                                                              shipment_id_                => shipment_id_,
                                                              handling_unit_id_           => handling_unit_id_,
                                                              parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                              sscc_                       => sscc_,
                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                              column_name_                => column_name_,
                                                              column_value_               => data_item_value_,
                                                              column_description_         => data_item_description_,
                                                              sql_where_expression_       => Get_Sql_Shpmnt_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_),
                                                              raise_error_                => FALSE);

               $END

               IF (NOT exists_in_invent_ AND NOT exists_in_shipment_) THEN
                  Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', data_item_description_, data_item_value_);
               END IF;
            ELSIF ((data_source_ = 'INVENT') AND (data_item_id_ NOT IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID'))) THEN

               -- Change -1 to NULL since NULL is ok for invent data source but not for shipment data source
               local_handling_unit_id_ := CASE handling_unit_id_ WHEN -1 THEN NULL ELSE handling_unit_id_ END; 
               Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_                 => dummy_,
                                                                handling_unit_id_              => local_handling_unit_id_,
                                                                sscc_                          => sscc_,
                                                                alt_handling_unit_label_id_    => alt_handling_unit_label_id_,
                                                                column_name_                   => column_name_,
                                                                column_value_                  => data_item_value_,
                                                                column_description_            => data_item_description_,
                                                                sql_where_expression_          => Get_Sql_Invent_Where_Expr___(data_item_id_, org_handling_unit_id_, parent_handling_unit_id_));
            END IF;
         END IF;
      ELSIF (data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
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
   handling_unit_id_              NUMBER;
   parent_handling_unit_id_       NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   parent_sscc_                   VARCHAR2(18);
   parent_alt_hand_unit_label_id_ VARCHAR2(25);
   alt_handling_unit_label_id_    VARCHAR2(25);
   data_source_                   VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      Get_Filter_Keys___(contract_, shipment_id_, handling_unit_id_, parent_handling_unit_id_, parent_consol_shipment_id_, sscc_, parent_sscc_, alt_handling_unit_label_id_,
                         parent_alt_hand_unit_label_id_, data_source_, capture_session_id_, data_item_id_ => latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'HANDLING_UNIT_ID', 
                                                                    'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'NEW_PARENT_SSCC', 
                                                                    'NEW_PARENT_HANDLING_UNIT_ID', 'NEW_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN  
                  -- FILTER DATA ITEMS AS DETAILS
                  Add_Filter_Key_Detail___(capture_session_id_            => capture_session_id_,
                                           owning_data_item_id_           => latest_data_item_id_,
                                           data_item_detail_id_           => conf_item_detail_tab_(i).data_item_detail_id,
                                           shipment_id_                   => shipment_id_,
                                           handling_unit_id_              => handling_unit_id_,
                                           parent_handling_unit_id_       => parent_handling_unit_id_,
                                           parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                           sscc_                          => sscc_,
                                           alt_handling_unit_label_id_    => alt_handling_unit_label_id_,
                                           parent_sscc_                   => sscc_,
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
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARENT_HANDLING_UNIT_DESC', 'HANDLING_UNIT_TYPE_ADD_VOLUME', 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                                    'HANDLING_UNIT_TYPE_CATEG_DESC', 'HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_MAX_VOL_CAP', 
                                                                    'HANDLING_UNIT_TYPE_MAX_WGT_CAP', 'HANDLING_UNIT_TYPE_STACKABLE', 'OLD_PARENT_HANDLING_UNIT_DESC',
                                                                    'TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'NEW_PARENT_HANDLING_UNIT_DESC') THEN
                  -- feedback related to new parent handling unit id
                  Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                    data_item_id_        => latest_data_item_id_,
                                                    data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                    data_item_value_     => Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(parent_handling_unit_id_)));

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_ACCESSORY_EXIST', 'HANDLING_UNIT_COMPOSITION', 'HANDLING_UNIT_DEPTH',
                                                                       'HANDLING_UNIT_GEN_SSCC', 'HANDLING_UNIT_HEIGHT', 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT',
                                                                       'HANDLING_UNIT_MANUAL_VOLUME', 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED',
                                                                       'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED', 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED',
                                                                       'HANDLING_UNIT_NET_WEIGHT', 'HANDLING_UNIT_NO_OF_LBLS', 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT',
                                                                       'HANDLING_UNIT_OPERATIVE_VOLUME', 'HANDLING_UNIT_PRINT_LBL', 'HANDLING_UNIT_STRUCTURE_LEVEL',
                                                                       'HANDLING_UNIT_TARE_WEIGHT', 'HANDLING_UNIT_UOM_LENGTH', 'HANDLING_UNIT_UOM_WEIGHT',
                                                                       'HANDLING_UNIT_UOM_VOLUME', 'HANDLING_UNIT_WIDTH', 
                                                                       'OLD_PARENT_HANDLING_UNIT_ID', 'OLD_PARENT_SSCC', 'OLD_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'TOP_PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_SSCC', 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'HANDLING_UNIT_LOCATION_NO', 'HANDLING_UNIT_WAREHOUSE_ID', 'HANDLING_UNIT_BAY_ID', 
                                                                       'HANDLING_UNIT_TIER_ID', 'HANDLING_UNIT_ROW_ID', 'HANDLING_UNIT_BIN_ID',
                                                                       'HANDLING_UNIT_LOCATION_TYPE', 'HANDLING_UNIT_LOCATION_NO_DESC',
                                                                       'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CREATED_DATE', 'DELIVERY_TERMS', 'FORWARD_AGENT_ID', 'LOAD_SEQUENCE_NO',
                                                                       'RECEIVER_ADDRESS_ID', 'RECEIVER_COUNTRY', 'RECEIVER_DESCRIPTION', 
                                                                       'RECEIVER_ID', 'RECEIVER_REFERENCE', 'ROUTE_ID', 'SENDER_REFERENCE',
                                                                       'SHIP_DATE', 'SHIP_INVENTORY_LOCATION_NO', 'SHIP_VIA_CODE', 'SHIP_VIA_DESC',
                                                                       'SHIPMENT_STATUS', 'SHIPMENT_TYPE')) THEN
                  $IF Component_Shpmnt_SYS.INSTALLED $THEN
                     -- Feedback items related to shipment
                     Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_        => capture_session_id_,
                                                                           owning_data_item_id_       => latest_data_item_id_,
                                                                           data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           shipment_id_               => shipment_id_);
                  $ELSE
                     NULL;
                  $END

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
   handling_unit_id_              NUMBER;
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   parent_handling_unit_id_       NUMBER;
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
      handling_unit_id_:= Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_ => FALSE);
      shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_ => FALSE);

      -- if predicted shipment_id_ or handling_unit_id_ is null then try fetch it with unique handling
      IF (shipment_id_ IS NULL OR handling_unit_id_ IS NULL) THEN
         Get_Filter_Keys___(contract_, shipment_id_, handling_unit_id_, parent_handling_unit_id_, parent_consol_shipment_id_, sscc_, parent_sscc_,
                            alt_handling_unit_label_id_, parent_alt_hand_unit_label_id_, data_source_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);
         IF (handling_unit_id_ IS NULL OR handling_unit_id_ = number_all_values_) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, data_source_, 'HANDLING_UNIT_ID');
         END IF;   
         IF (shipment_id_ IS NULL OR shipment_id_ = number_all_values_) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, shipment_id_, handling_unit_id_, parent_consol_shipment_id_, sscc_, alt_handling_unit_label_id_, parent_handling_unit_id_, data_source_, 'SHIPMENT_ID');
         END IF;
      END IF;   

      IF data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID') AND 
         ((handling_unit_id_ IS NOT NULL AND shipment_id_ IS NULL AND 
         Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) OR 
        (shipment_id_ IS NULL AND 
          (Data_Capture_Session_API.Is_Data_Item_Fixed_Value_Null(session_rec_, data_item_id_=> 'SHIPMENT_ID') OR 
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)))) THEN
         fixed_value_is_applicable_ := TRUE;
      END IF;   

   $END

   RETURN fixed_value_is_applicable_;

END Fixed_Value_Is_Applicable;