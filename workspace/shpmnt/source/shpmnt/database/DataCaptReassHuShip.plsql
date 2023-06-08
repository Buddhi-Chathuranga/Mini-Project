-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptReassHuShip
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: REASSIGN_HANDLING_UNIT_SHIP
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------
--  220701  BWITLK  SC2020R1-11173, Added RECEIVER_ID, RECEIVER_TYPE as a new filter data items in the process.
--  200903  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171026  DaZase  STRSC-13041, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171026          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  171016  DiKuLk  Bug 138039, changed the Validate_Data_Item() message constant from MUSTHAVENEWSHIPMENT to MUSTHAVESHIPMENTID in order 
--  171016          to avoid overriding of language translations.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160920  DaZase  LIM-4604, Changed LOV for TO_SHIPMENT_ID to use a new LOV method that is closer to how the IEE LOV for this item works.
--  160919  DaZase  LIM-8639, Added check on Shipment_API.Shipment_Delivered for all unique calls to filter out everything already delivered.
--  160901  DaZase  LIM-8335, Moved this process to SHPMNT, renamed some feedback items.
--  160603  RoJalk  LIM-6813, Renamed Reassign_Shipment_Utility_API.Reassign_Handling_Unit to eassign_Hu_Structure.
--  160427  RoJalk  LIM-6811, Move code related to reassignment to ReassignShipmentUtility.
--  160209  DaZase  LIM-6226, Renamed feedback item SHIP_ADDR_NO to RECEIVER_ADDRESS_ID.
--  151028  Erlise  LIM-3777, Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID.
--  151027  DaZase  LIM-4297, Changed calls to Add_Details_For_Hand_Unit_Type and Add_Details_For_Handling_Unit 
--  151027          so they now call Data_Capture_Invent_Util_API instead of Data_Capture_Order_Util_API.                  
--  150807  DaZase  COB-607, Reworked some of the unique methods so data items that are not using the filter keys 
--  150807          are handled before calling Get_Filter_Keys___, to help performance a bit. 
--  150401  RILASE  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER := -1;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Get_Filter_Keys___ (
   contract_                      OUT VARCHAR2,
   from_shipment_id_              OUT NUMBER,
   parent_consol_shipment_id_     OUT NUMBER,
   handling_unit_id_              OUT NUMBER,
   sscc_                          OUT VARCHAR2,
   receiver_id_                   OUT VARCHAR2,
   receiver_type_db_              OUT VARCHAR2,
   alt_handling_unit_label_id_    OUT VARCHAR2,
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
      from_shipment_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      parent_consol_shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_CONSOL_SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      receiver_id_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_ID', session_rec_ , process_package_, use_applicable_);
      receiver_type_db_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_TYPE', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);

      -- Add support for alternative shipment handling unit keys
      IF (handling_unit_id_ IS NULL) THEN
         handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_);
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(alt_handling_unit_label_id_);
         END IF;
      END IF;
      IF (sscc_ IS NULL) THEN
         sscc_ := Handling_Unit_API.Get_Sscc(handling_unit_id_);
      END IF;
      IF (alt_handling_unit_label_id_ IS NULL) THEN
         alt_handling_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(handling_unit_id_);
      END IF;
      -- Get from shipment id from handling unit id
      IF (from_shipment_id_ IS NULL AND handling_unit_id_ IS NOT NULL) THEN
         from_shipment_id_ := Handling_Unit_API.Get_Shipment_Id(handling_unit_id_);
      END IF;

      IF (from_shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'FROM_SHIPMENT_ID', data_item_id_)) THEN
         from_shipment_id_ := number_all_values_;
      END IF;

      IF (parent_consol_shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_CONSOL_SHIPMENT_ID', data_item_id_)) THEN
         parent_consol_shipment_id_ := number_all_values_;
      END IF;

      IF (handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) THEN
         handling_unit_id_ := number_all_values_;
      END IF;
      
      IF (sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := string_all_values_;
      END IF;
      
      IF (receiver_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_ID', data_item_id_)) THEN
         receiver_id_ := string_all_values_;
      END IF;
      
      IF (receiver_type_db_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RECEIVER_TYPE', data_item_id_)) THEN
         receiver_type_db_ := string_all_values_;
      END IF;

      IF (alt_handling_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := string_all_values_;
      END IF;

      IF (use_unique_values_) THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (from_shipment_id_ IS NULL) THEN
            from_shipment_id_ := Get_Unique_Data_Item_Value___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, 'FROM_SHIPMENT_ID');
         END IF;
         IF (parent_consol_shipment_id_ IS NULL) THEN
            parent_consol_shipment_id_ := Get_Unique_Data_Item_Value___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, 'PARENT_CONSOL_SHIPMENT_ID');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (receiver_id_ IS NULL OR receiver_id_ = '%') THEN
            receiver_id_ := Get_Unique_Data_Item_Value___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, 'RECEIVER_ID');
         END IF;
         IF (receiver_type_db_ IS NULL OR receiver_type_db_ = '%') THEN
            receiver_type_db_ := Get_Unique_Data_Item_Value___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, 'RECEIVER_TYPE');
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                      IN VARCHAR2,
   from_shipment_id_              IN NUMBER,
   parent_consol_shipment_id_     IN NUMBER,
   handling_unit_id_              IN NUMBER,
   sscc_                          IN VARCHAR2,
   receiver_id_                   IN VARCHAR2,
   receiver_type_db_              IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   wanted_data_item_id_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_ VARCHAR2(200);
   column_name_  VARCHAR2(30);
   dummy_        BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (wanted_data_item_id_ IN ('FROM_SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'HANDLING_UNIT_ID', 'RECEIVER_ID', 'RECEIVER_TYPE')) THEN
      IF (wanted_data_item_id_ = 'FROM_SHIPMENT_ID') THEN
         column_name_ := 'SHIPMENT_ID';
      ELSIF (wanted_data_item_id_ = 'RECEIVER_TYPE') THEN
         column_name_ := 'RECEIVER_TYPE_DB';
      ELSE
         column_name_ := wanted_data_item_id_;
      END IF;
      unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                               contract_                   => contract_,
                                                               shipment_id_                => from_shipment_id_,
                                                               handling_unit_id_           => handling_unit_id_,
                                                               parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                               sscc_                       => sscc_,
                                                               receiver_id_                => receiver_id_,
                                                               receiver_type_db_           => receiver_type_db_,
                                                               alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                               column_name_                => column_name_ );
   END IF;
   IF (unique_value_ = 'NULL') THEN
      unique_value_ := NULL;
   END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;
  
   
PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_           IN NUMBER,
   owning_data_item_id_          IN VARCHAR2,
   data_item_detail_id_          IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   parent_consol_shipment_id_    IN NUMBER,
   sscc_                         IN VARCHAR2,
   receiver_id_                  IN VARCHAR2,
   receiver_type_db_             IN VARCHAR2,
   alt_handling_unit_label_id_   IN VARCHAR2,
   handling_unit_id_             IN NUMBER )  
IS
   detail_value_                 VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('FROM_SHIPMENT_ID') THEN
            detail_value_ := shipment_id_;
         WHEN ('PARENT_CONSOL_SHIPMENT_ID') THEN
            IF (parent_consol_shipment_id_ NOT IN (number_all_values_)) THEN
               detail_value_ := parent_consol_shipment_id_;
            END IF;
         WHEN ('HANDLING_UNIT_ID') THEN
            IF (handling_unit_id_ != number_all_values_) THEN
               detail_value_ := handling_unit_id_;
            END IF;
         WHEN ('SSCC') THEN
            IF (handling_unit_id_ != number_all_values_) THEN
               detail_value_ := sscc_;
            END IF;
         WHEN ('RECEIVER_ID') THEN
            detail_value_ := receiver_id_;
         WHEN ('RECEIVER_TYPE') THEN
            detail_value_ := receiver_type_db_;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            IF (handling_unit_id_ != number_all_values_) THEN
               detail_value_ := alt_handling_unit_label_id_;
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


FUNCTION Get_Sql_Where_Expression___ RETURN VARCHAR2
IS
BEGIN
   RETURN ' AND state IN (''Preliminary'', ''Completed'') AND Shipment_API.Shipment_Delivered(shipment_id) = ''FALSE'' ';
END Get_Sql_Where_Expression___;


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
      message_ := Language_SYS.Translate_Constant(lu_name_, 'REASSIGNOK: The handling unit was reassigned to shipment :P1.', NULL, process_message_);
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'REASSIGNSOK: :P1 shipments were reassigned.', NULL, no_of_records_handled_);
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
   ptr_                         NUMBER;
   name_                        VARCHAR2(50);
   value_                       VARCHAR2(4000);
   info_                        VARCHAR2(32000);
   from_shipment_id_            NUMBER;
   handling_unit_id_            NUMBER;
   to_shipment_id_              NUMBER;
   release_reservations_        VARCHAR2(5);
   destination_                 VARCHAR2(21);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'FROM_SHIPMENT_ID') THEN
         from_shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'RELEASE_RESERVATIONS') THEN
         release_reservations_ := CASE value_ WHEN Gen_Yes_No_API.DB_YES THEN Fnd_Boolean_API.DB_TRUE ELSE Fnd_Boolean_API.DB_FALSE END;
      ELSIF (name_ = 'TO_NEW_SHIPMENT_ID') THEN
         destination_ := CASE value_ WHEN Gen_Yes_No_API.DB_YES THEN 'CREATE_NEW_SHIPMENT' ELSE 'ADD_TO_EXIST_SHIPMENT' END;
      ELSIF (name_ = 'TO_SHIPMENT_ID') THEN
         to_shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;

   Reassign_Shipment_Utility_API.Reassign_Hu_Structure(to_shipment_id_, from_shipment_id_, handling_unit_id_, release_reservations_, destination_);
   process_message_ := to_shipment_id_;
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Reassign_Shipment_Utility_API.Reassign_Hu_Structure is granted thru any of following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('ShipmentHandlingUnitStructureHandling', 'StartReassignHandlingUnit')) THEN
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
   from_shipment_id_              NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   receiver_id_                   VARCHAR2(50);
   receiver_type_db_              VARCHAR2(50);
   alt_handling_unit_label_id_    VARCHAR2(25);
   dummy_contract_                VARCHAR2(5);
   column_name_                   VARCHAR2(30);
   sql_where_expression_          VARCHAR2(2000) := Get_Sql_Where_Expression___;
   lov_type_db_                   VARCHAR2(20);
   local_from_shipment_id_        NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('TO_NEW_SHIPMENT_ID', 'RELEASE_RESERVATIONS')) THEN
         Gen_Yes_No_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSE
         Get_Filter_Keys___(dummy_contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
         IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'FROM_SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'RECEIVER_ID', 'RECEIVER_TYPE')) THEN
            IF (data_item_id_ = 'FROM_SHIPMENT_ID') THEN
               column_name_ := 'SHIPMENT_ID';
            ELSIF (data_item_id_ = 'RECEIVER_TYPE') THEN
               column_name_ := 'RECEIVER_TYPE_DB';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
            sql_where_expression_ := sql_where_expression_ || ' AND handling_unit_id IS NOT NULL ';
            Shipment_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                 shipment_id_                => from_shipment_id_,
                                                 handling_unit_id_           => handling_unit_id_,
                                                 parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                 sscc_                       => sscc_,
                                                 receiver_id_                => receiver_id_,
                                                 receiver_type_db_           => receiver_type_db_,
                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                 capture_session_id_         => capture_session_id_,
                                                 column_name_                => column_name_,
                                                 lov_type_db_                => lov_type_db_,
                                                 sql_where_expression_       => sql_where_expression_);
   
         ELSIF (data_item_id_ = 'TO_SHIPMENT_ID') THEN
            IF (from_shipment_id_ = number_all_values_) THEN
               local_from_shipment_id_ := NULL; 
            ELSE
               local_from_shipment_id_ := from_shipment_id_;
            END IF;
            Shipment_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                 from_shipment_id_           => local_from_shipment_id_,
                                                 capture_session_id_         => capture_session_id_);
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
   from_shipment_id_              NUMBER;
   to_shipment_id_                NUMBER;
   contract_                      VARCHAR2(5);
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   receiver_id_                   VARCHAR2(20);
   receiver_type_db_              VARCHAR2(20);
   alt_handling_unit_label_id_    VARCHAR2(25);
   automatic_value_               VARCHAR2(200);
   column_name_                   VARCHAR2(30);
   sql_where_expression_          VARCHAR2(2000) := Get_Sql_Where_Expression___;
   to_new_shipment_id_            VARCHAR2(1);
   dummy_                         BOOLEAN;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
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

         IF (data_item_id_ = 'TO_NEW_SHIPMENT_ID') THEN
            to_shipment_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'TO_SHIPMENT_ID', data_item_id_);
            IF (to_shipment_id_ IS NULL) THEN
               automatic_value_ := Gen_Yes_No_API.DB_YES;
            ELSE
               automatic_value_ := Gen_Yes_No_API.DB_NO;
            END IF;
         ELSIF (data_item_id_ = 'RELEASE_RESERVATIONS') THEN
            automatic_value_ := Gen_Yes_No_API.DB_NO;
         ELSE
   
            Get_Filter_Keys___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
            -- NOTE: No automatic handling for parent items since they can be null when changing parent to root (shipment) level.
            IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'FROM_SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'RECEIVER_ID', 'RECEIVER_TYPE')) THEN
               IF (data_item_id_ = 'FROM_SHIPMENT_ID') THEN
                  column_name_ := 'SHIPMENT_ID';
               ELSIF (data_item_id_ = 'RECEIVER_TYPE') THEN
                  column_name_ :=  'RECEIVER_TYPE_DB';
               ELSE
                  column_name_ := data_item_id_;
               END IF;
               sql_where_expression_ := sql_where_expression_ || ' AND handling_unit_id IS NOT NULL ';
               automatic_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                           contract_                   => contract_,
                                                                           shipment_id_                => from_shipment_id_,
                                                                           handling_unit_id_           => handling_unit_id_,
                                                                           parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                           sscc_                       => sscc_,
                                                                           receiver_id_                => receiver_id_,
                                                                           receiver_type_db_           => receiver_type_db_,
                                                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                           column_name_                => column_name_,
                                                                           sql_where_expression_       => sql_where_expression_);
   
            ELSIF (data_item_id_ = 'TO_SHIPMENT_ID') THEN
               to_new_shipment_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'TO_NEW_SHIPMENT_ID', data_item_id_);
               IF (to_new_shipment_id_ = Gen_Yes_No_API.DB_YES) THEN
                  automatic_value_ := 'NULL';
               END IF;
               column_name_ := 'SHIPMENT_ID';
               IF (from_shipment_id_ IS NOT NULL) THEN
                  sql_where_expression_ := sql_where_expression_ || ' AND shipment_id != ' || from_shipment_id_ || ' ';
               END IF;
               IF (automatic_value_ IS NULL) THEN
                  automatic_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                              contract_                   => contract_,
                                                                              shipment_id_                => number_all_values_,
                                                                              handling_unit_id_           => number_all_values_,
                                                                              parent_consol_shipment_id_  => number_all_values_,
                                                                              sscc_                       => string_all_values_,
                                                                              alt_handling_unit_label_id_ => string_all_values_,
                                                                              receiver_id_                => string_all_values_,
                                                                              receiver_type_db_           => string_all_values_,
                                                                              column_name_                => column_name_,
                                                                              sql_where_expression_       => sql_where_expression_);
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
   handling_unit_id_              NUMBER;
   from_shipment_id_              NUMBER;
   to_shipment_id_                NUMBER;
   parent_consol_shipment_id_     NUMBER;
   data_item_description_         VARCHAR2(200);
   sscc_                          VARCHAR2(18);
   receiver_id_                   VARCHAR2(20);
   receiver_type_db_              VARCHAR2(20);
   alt_handling_unit_label_id_    VARCHAR2(25);
   column_name_                   VARCHAR2(30);
   sql_where_expression_          VARCHAR2(2000) := Get_Sql_Where_Expression___;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   to_shipment_entered_           BOOLEAN;
   to_new_shipment_id_            VARCHAR2(1);
   dummy_                         BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ = 'RELEASE_RESERVATIONS') THEN
         Gen_Yes_No_API.Exist_Db(data_item_value_);
      ELSE

         Get_Filter_Keys___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_, data_item_value_);
         session_rec_           := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
      
         IF (data_item_id_ IN ('FROM_SHIPMENT_ID', 'HANDLING_UNIT_ID')) THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
         END IF;
         
         to_shipment_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_SHIPMENT_ID', session_rec_ , Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id));
         IF (data_item_id_ IN ('FROM_SHIPMENT_ID', 'TO_SHIPMENT_ID')) THEN
            IF (to_shipment_id_ IS NOT NULL AND (from_shipment_id_ IS NOT NULL AND from_shipment_id_ != number_all_values_)) THEN
               Reassign_Shipment_Utility_API.Validate_Reassign_To_Ship(destination_shipment_id_ => to_shipment_id_,
                                                                       source_shipment_id_      => from_shipment_id_);
            END IF;
         END IF;
            
         IF (data_item_id_ IN ('FROM_SHIPMENT_ID', 'HANDLING_UNIT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID','RECEIVER_ID', 'RECEIVER_TYPE')) THEN
            IF (data_item_id_ = 'HANDLING_UNIT_ID') THEN
               Handling_Unit_API.Exist(data_item_value_);
               column_name_ := data_item_id_;
            ELSIF (data_item_id_ = 'FROM_SHIPMENT_ID') THEN
               column_name_ := 'SHIPMENT_ID';
            ELSIF (data_item_id_ = 'RECEIVER_TYPE') THEN
               column_name_ := 'RECEIVER_TYPE_DB';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            sql_where_expression_ := sql_where_expression_ || ' AND handling_unit_id IS NOT NULL ';
            Shipment_API.Record_With_Column_Value_Exist(record_exists_              => dummy_,
                                                        contract_                   => contract_,
                                                        shipment_id_                => from_shipment_id_,
                                                        handling_unit_id_           => handling_unit_id_,
                                                        parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                        sscc_                       => sscc_,
                                                        receiver_id_                => receiver_id_, 
                                                        receiver_type_db_           => receiver_type_db_,
                                                        alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                        column_name_                => column_name_,
                                                        column_value_               => data_item_value_,
                                                        column_description_         => data_item_description_,
                                                        sql_where_expression_       => sql_where_expression_);
         ELSIF (data_item_id_ = 'TO_SHIPMENT_ID') THEN
            to_new_shipment_id_      := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'TO_NEW_SHIPMENT_ID', data_item_id_);
            IF (to_new_shipment_id_ = Gen_Yes_No_API.DB_NO AND data_item_value_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'MUSTHAVENEWSHIPMENTID: :P1 must be specified if :P2 is :P3.',
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, data_item_id_),
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, 'TO_NEW_SHIPMENT_ID'),
               Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_NO));
            ELSIF (to_new_shipment_id_ = Gen_Yes_No_API.DB_YES AND data_item_value_ IS NOT NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NOTOSHIPIFNEWSHIP: :P1 cannot be specified if :P2 is :P3.',
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, data_item_id_),
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, 'TO_NEW_SHIPMENT_ID'),
               Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_YES));
            END IF;
            column_name_ := 'SHIPMENT_ID';
            IF (from_shipment_id_ IS NOT NULL) THEN
               sql_where_expression_ := sql_where_expression_ || ' AND shipment_id != ' || from_shipment_id_ || ' ';
            END IF;
            IF (data_item_value_ IS NOT NULL) THEN
               Shipment_API.Record_With_Column_Value_Exist(record_exists_              => dummy_,
                                                           contract_                   => contract_,
                                                           shipment_id_                => number_all_values_,
                                                           handling_unit_id_           => number_all_values_,
                                                           parent_consol_shipment_id_  => number_all_values_,
                                                           sscc_                       => string_all_values_,
                                                           receiver_id_                => receiver_id_, 
                                                           receiver_type_db_           => receiver_type_db_,
                                                           alt_handling_unit_label_id_ => string_all_values_,
                                                           column_name_                => column_name_,
                                                           column_value_               => data_item_value_,
                                                           column_description_         => data_item_description_,
                                                           sql_where_expression_       => sql_where_expression_);
            END IF;
         ELSIF (data_item_id_ = 'TO_NEW_SHIPMENT_ID') THEN
            Gen_Yes_No_API.Exist_Db(data_item_value_);
            to_shipment_entered_ := Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'TO_SHIPMENT_ID', data_item_id_);
            IF (to_shipment_id_ IS NULL AND to_shipment_entered_ AND data_item_value_ = Gen_Yes_No_API.DB_NO) THEN
               Error_SYS.Record_General(lu_name_, 'MUSTHAVENEWSHIPMENT: :P1 must be :P2 if :P3 is not previously entered.',
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, data_item_id_),
               Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_YES),
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, 'TO_SHIPMENT_ID'));
            ELSIF (to_shipment_id_ IS NOT NULL AND data_item_value_ = Gen_Yes_No_API.DB_YES) THEN
               Error_SYS.Record_General(lu_name_, 'NONEWSHIPIFSHIPGIVEN: :P1 must be :P2 if :P3 is previously entered.',
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, data_item_id_),
               Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_NO),
               Data_Capt_Proc_Data_Item_API.Get_Description(session_rec_.capture_process_id, 'TO_SHIPMENT_ID'));
            END IF;
         ELSIF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
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
   handling_unit_id_              NUMBER;
   from_shipment_id_              NUMBER;
   parent_consol_shipment_id_     NUMBER;
   sscc_                          VARCHAR2(18);
   receiver_id_                   VARCHAR2(20);
   receiver_type_db_              VARCHAR2(20);
   alt_handling_unit_label_id_    VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
   Get_Filter_Keys___(contract_, from_shipment_id_, parent_consol_shipment_id_, handling_unit_id_, sscc_, receiver_id_, receiver_type_db_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_ => latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('FROM_SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'RECEIVER_ID', 'RECEIVER_TYPE')) THEN
                  receiver_id_      := CASE receiver_id_ WHEN '%' THEN NULL ELSE receiver_id_ END;-- % if it is not scanned yet
                  receiver_type_db_ := CASE receiver_type_db_ WHEN '%' THEN NULL ELSE receiver_type_db_ END;-- % if it is not scanned yet
                  -- FILTER DATA ITEMS AS DETAILS
                  Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                           owning_data_item_id_         => latest_data_item_id_,
                                           data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                           shipment_id_                 => from_shipment_id_,
                                           parent_consol_shipment_id_   => parent_consol_shipment_id_,
                                           handling_unit_id_            => handling_unit_id_,
                                           sscc_                        => sscc_,
                                           receiver_id_                 => receiver_id_,
                                           receiver_type_db_            => receiver_type_db_,
                                           alt_handling_unit_label_id_  => alt_handling_unit_label_id_);
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
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_DESC', 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                                    'HANDLING_UNIT_TYPE_CATEG_DESC', 'HANDLING_UNIT_TYPE_VOLUME', 'HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                                    'HANDLING_UNIT_TYPE_TARE_WEIGHT', 'HANDLING_UNIT_TYPE_UOM_WEIGHT', 'HANDLING_UNIT_TYPE_ADD_VOLUME',
                                                                    'HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'HANDLING_UNIT_TYPE_MAX_WGT_CAP', 'HANDLING_UNIT_TYPE_STACKABLE',
                                                                    'HANDLING_UNIT_TYPE_GEN_SSCC', 'HANDLING_UNIT_TYPE_PRINT_LBL', 'HANDLING_UNIT_TYPE_NO_OF_LBLS',
                                                                    'PARENT_HANDLING_UNIT_DESC')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_WIDTH', 'HANDLING_UNIT_HEIGHT', 'HANDLING_UNIT_DEPTH', 'HANDLING_UNIT_UOM_LENGTH',
                                                                       'PARENT_HANDLING_UNIT_ID', 'MANUAL_GROSS_WEIGHT', 'MANUAL_VOLUME',
                                                                       'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('RECEIVER_DESCRIPTION', 'CREATED_DATE', 'DELIVERY_TERMS', 'SENDER_REFERENCE',
                                                                       'SHIP_INVENTORY_LOCATION_NO', 'RECEIVER_COUNTRY', 'RECEIVER_ADDRESS_ID', 'SHIP_DATE', 
                                                                       'RECEIVER_REFERENCE', 'ROUTE_ID', 'LOAD_SEQUENCE_NO', 'SHIPMENT_TYPE',
                                                                       'FORWARD_AGENT_ID', 'SHIP_VIA_CODE')) THEN

                  -- Feedback items related to shipment
                  Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_        => capture_session_id_,
                                                                        owning_data_item_id_       => latest_data_item_id_,
                                                                        data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                                                        shipment_id_               => from_shipment_id_);
               END IF;

            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;   