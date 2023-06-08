-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptCountHuReport
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: COUNT_HANDL_UNIT_COUNT_REPORT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200817  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171017  DaZase  STRSC-13003, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171017          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170925  SURBLK  STRSC-12222, Added sequence number for the captured image.
--  170731  SWiclk  STRSC-9013, Enabled camera functionality and photos will be saved in HandlingUnit LU.
--  170316  Khvese  LIM-11175, Modified method Get_Inventory_Event_Id___() to construct message correctly 
--  170316  Khvese  LIM-11050, Changed the process_message type from VARCHAR2 to CLOB in all its appearances. 
--  170316          Also added capture_session_id_ and contract_ to the interface of method Post_Process_Action.
--  161122  DaZase  Created for LIM-5062. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_all_values_ CONSTANT VARCHAR2(1) := '%';
--number_all_values_ CONSTANT NUMBER := -1;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2,
   wanted_data_item_id_        IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   sql_where_expression_  VARCHAR2(2000) DEFAULT NULL;
BEGIN

   unique_value_ := Counting_Report_Handl_Unit_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                              inv_list_no_                => inv_list_no_, 
                                                                              aggregated_line_id_         => aggregated_line_id_, 
                                                                              location_no_                => location_no_, 
                                                                              handling_unit_id_           => handling_unit_id_,
                                                                              sscc_                       => sscc_,
                                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                              column_name_                => wanted_data_item_id_,
                                                                              sql_where_expression_       => sql_where_expression_);
   IF (unique_value_ = 'NULL') THEN
      unique_value_ := NULL;
   END IF;
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   contract_                      OUT VARCHAR2,
   inv_list_no_                   OUT VARCHAR2,
   aggregated_line_id_            OUT VARCHAR2,
   location_no_                   OUT VARCHAR2,
   handling_unit_id_              OUT NUMBER,
   sscc_                          OUT VARCHAR2,
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
      inv_list_no_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'INV_LIST_NO', session_rec_ , process_package_, use_applicable_);
      aggregated_line_id_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'AGGREGATED_LINE_ID', session_rec_ , process_package_, use_applicable_);
      location_no_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);

      -- Add support for alternative handling unit keys
      IF (handling_unit_id_ IS NULL AND sscc_ IS NOT NULL) THEN
         handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_);
      ELSIF (handling_unit_id_ IS NULL AND alt_handling_unit_label_id_ IS NOT NULL) THEN
         handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(alt_handling_unit_label_id_);
      END IF;
      IF (sscc_ IS NULL AND handling_unit_id_ IS NOT NULL AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', 'SSCC')) THEN
         sscc_ := Handling_Unit_API.Get_Sscc(handling_unit_id_);                             
      END IF;
      IF (alt_handling_unit_label_id_ IS NULL AND handling_unit_id_ IS NOT NULL AND 
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
         alt_handling_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(handling_unit_id_);
      END IF;

      IF (sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := string_all_values_;
      END IF;

      IF (alt_handling_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := string_all_values_;
      END IF;

      IF (use_unique_values_) THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (inv_list_no_ IS NULL) THEN
            inv_list_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'INV_LIST_NO');
         END IF;
         IF (aggregated_line_id_ IS NULL) THEN
            aggregated_line_id_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'AGGREGATED_LINE_ID');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'LOCATION_NO');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (sscc_ IS NULL OR sscc_ = string_all_values_) THEN
            sscc_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'SSCC');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL OR alt_handling_unit_label_id_ = string_all_values_) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 'ALT_HANDLING_UNIT_LABEL_ID');
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
   inv_list_no_                IN VARCHAR2,
   aggregated_line_id_         IN VARCHAR2,
   location_no_                IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2 )  
IS
   detail_value_             VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      CASE (data_item_detail_id_)
         WHEN ('INV_LIST_NO') THEN
            detail_value_ := inv_list_no_;
         WHEN ('AGGREGATED_LINE_ID') THEN
            detail_value_ := aggregated_line_id_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
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
   data_item_detail_id_        IN VARCHAR2 )  
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


PROCEDURE Update_Inventory_Event_Id___(
   process_message_    IN OUT CLOB,
   inventory_event_id_ IN     NUMBER )
IS
BEGIN
   IF (inventory_event_id_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(process_message_, 'INVENTORY_EVENT_ID', inventory_event_id_);
   END IF;
END Update_Inventory_Event_Id___;


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
   dummy_                       VARCHAR2(5);
   inv_list_no_                 VARCHAR2(15);
   aggregated_line_id_          COUNTING_REPORT_HANDL_UNIT.objid%TYPE;
   location_no_                 VARCHAR2(35);
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   sql_where_expression_        VARCHAR2(2000) DEFAULT NULL;
   lov_type_db_                 VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ IN ('CONFIRM')) THEN
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, contract_);
      ELSIF (data_item_id_ = 'ACTION') THEN
         Count_Handl_Unit_Action_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSE
         Get_Filter_Keys___(dummy_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, 
                            sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);

         IF (data_item_id_ IN ('AGGREGATED_LINE_ID','LOCATION_NO',
                               'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN      

            lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
            Counting_Report_Handl_Unit_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                                   inv_list_no_                => inv_list_no_, 
                                                                   aggregated_line_id_         => aggregated_line_id_, 
                                                                   location_no_                => location_no_, 
                                                                   handling_unit_id_           => handling_unit_id_,
                                                                   sscc_                       => sscc_,
                                                                   alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                   capture_session_id_         => capture_session_id_, 
                                                                   column_name_                => data_item_id_,
                                                                   lov_type_db_                => lov_type_db_,
                                                                   sql_where_expression_       => sql_where_expression_);

         ELSIF (data_item_id_ = 'INV_LIST_NO') THEN
            -- If INV_LIST_NO is first data item in the configuration use faster INV_LIST_NO-LOV method on Counting Report head (not compairing against the enumeration items)
            IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                           capture_config_id_  => capture_config_id_,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'AGGREGATED_LINE_ID') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                           capture_config_id_  => capture_config_id_,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'LOCATION_NO') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                           capture_config_id_  => capture_config_id_,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'HANDLING_UNIT_ID') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                           capture_config_id_  => capture_config_id_,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'SSCC') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                           capture_config_id_  => capture_config_id_,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'ALT_HANDLING_UNIT_LABEL_ID')) THEN

               Counting_Report_API.Create_Data_Capture_Lov(contract_           => contract_,
                                                           capture_session_id_ => capture_session_id_);

            ELSE
               lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
               Counting_Report_Handl_Unit_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                                      inv_list_no_                => inv_list_no_, 
                                                                      aggregated_line_id_         => aggregated_line_id_, 
                                                                      location_no_                => location_no_, 
                                                                      handling_unit_id_           => handling_unit_id_,
                                                                      sscc_                       => sscc_,
                                                                      alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                      capture_session_id_         => capture_session_id_, 
                                                                      column_name_                => data_item_id_,
                                                                      lov_type_db_                => lov_type_db_,
                                                                      sql_where_expression_       => sql_where_expression_);
            END IF;
         END IF;
      END IF;

   $ELSE
      NULL;
   $END 
END Create_List_Of_Values;


FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                      VARCHAR2(5);
   inv_list_no_                   VARCHAR2(15);
   aggregated_line_id_            COUNTING_REPORT_HANDL_UNIT.objid%TYPE;
   location_no_                   VARCHAR2(35);
   handling_unit_id_              NUMBER; 
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   automatic_value_               VARCHAR2(200);
   sql_where_expression_          VARCHAR2(2000) DEFAULT NULL;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
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
         -- No automatic values for the enumeration data items
         IF (data_item_id_ IN ('INV_LIST_NO','AGGREGATED_LINE_ID','LOCATION_NO',
                               'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN      
            
            Get_Filter_Keys___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, 
                               sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
   
            automatic_value_ := Counting_Report_Handl_Unit_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                          inv_list_no_                => inv_list_no_, 
                                                                                          aggregated_line_id_         => aggregated_line_id_, 
                                                                                          location_no_                => location_no_, 
                                                                                          handling_unit_id_           => handling_unit_id_,
                                                                                          sscc_                       => sscc_,
                                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                          column_name_                => data_item_id_,
                                                                                          sql_where_expression_       => sql_where_expression_);
   
         END IF;
      END IF;
   $END
   RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   contract_                     VARCHAR2(5);
   inv_list_no_                  VARCHAR2(15);
   aggregated_line_id_           COUNTING_REPORT_HANDL_UNIT.objid%TYPE;
   location_no_                  VARCHAR2(35);
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   sql_where_expression_         VARCHAR2(2000) DEFAULT NULL;
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ = 'CONFIRM') THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_ => TRUE);
         Gen_Yes_No_API.Exist_Db(data_item_value_);
      ELSIF (data_item_id_ = 'ACTION') THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_ => TRUE);
         Count_Handl_Unit_Action_API.Exist_Db(data_item_value_); 
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         IF (data_item_value_ IN (Count_Handl_Unit_Action_API.DB_COUNT_SUB_LEVEL, Count_Handl_Unit_Action_API.DB_COUNT_PARTS) AND 
             Data_Capt_Conf_Data_Item_API.Loop_Exist(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            Error_SYS.Record_General(lu_name_,'ACTIONANDLOOPNOTALLOWED: This action is not supported together with Loop functionality.');
         END IF;
         IF (data_item_value_ = Count_Handl_Unit_Action_API.DB_COUNT_SUB_LEVEL) THEN
            Get_Filter_Keys___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, 
                               sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_, data_item_value_);
            -- Check if the current handling unit is bottom in the structure and have part connected then Sub Count Level is not allowed
            IF (handling_unit_id_ IS NOT NULL AND NOT Handling_Unit_API.Has_Children(handling_unit_id_) AND 
                inv_list_no_ IS NOT NULL AND Counting_Report_Line_API.Handling_Unit_Exist_On_Report(inv_list_no_,handling_unit_id_)) THEN
               Error_SYS.Record_General(lu_name_,'BOTTOMPARTCOUNTSUBNOTALLOWED: Count Sub Level is not allowed when you are in bottom of the handling unit structure then you should use Count Parts instead.');
            END IF;
         END IF;

      ELSE
         Get_Filter_Keys___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, 
                            sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_, data_item_value_);

         IF (data_item_id_ IN ('AGGREGATED_LINE_ID','LOCATION_NO', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN      
            Counting_Report_Handl_Unit_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                          inv_list_no_                => inv_list_no_, 
                                                                          aggregated_line_id_         => aggregated_line_id_, 
                                                                          location_no_                => location_no_, 
                                                                          handling_unit_id_           => handling_unit_id_,
                                                                          sscc_                       => sscc_,
                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                          column_name_                => data_item_id_,
                                                                          column_value_               => data_item_value_,
                                                                          sql_where_expression_       => sql_where_expression_);

         ELSIF (data_item_id_  = 'INV_LIST_NO') THEN
            session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            -- If INV_LIST_NO is first data item in the configuration use faster Exist method on Counting Report head (not compairing against the enumeration items)
            IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'AGGREGATED_LINE_ID') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'LOCATION_NO') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'HANDLING_UNIT_ID') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'SSCC') AND
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           data_item_id_a_     => 'INV_LIST_NO',
                                                           data_item_id_b_     => 'ALT_HANDLING_UNIT_LABEL_ID')) THEN

               Counting_Report_API.Exist_And_Is_Not_Counted(contract_, data_item_value_);
            ELSE
               Counting_Report_Handl_Unit_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                             inv_list_no_                => inv_list_no_, 
                                                                             aggregated_line_id_         => aggregated_line_id_, 
                                                                             location_no_                => location_no_, 
                                                                             handling_unit_id_           => handling_unit_id_,
                                                                             sscc_                       => sscc_,
                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                             column_name_                => data_item_id_,
                                                                             column_value_               => data_item_value_,
                                                                             sql_where_expression_       => sql_where_expression_);
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
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                     VARCHAR2(5);
   inv_list_no_                  VARCHAR2(15);
   aggregated_line_id_           COUNTING_REPORT_HANDL_UNIT.objid%TYPE;
   location_no_                  VARCHAR2(35);
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   mixed_item_value_             VARCHAR2(25) := Language_SYS.Translate_Constant(lu_name_,'MIXEDITEM: Mixed');
   part_no_                      VARCHAR2(25);
   condition_code_               VARCHAR2(10);
   activity_seq_                 NUMBER;
   no_unique_value_found_        BOOLEAN; 

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, inv_list_no_, aggregated_line_id_, location_no_, handling_unit_id_, 
                         sscc_, alt_handling_unit_label_id_, capture_session_id_, latest_data_item_id_, 
                         latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('INV_LIST_NO','AGGREGATED_LINE_ID','LOCATION_NO', 'HANDLING_UNIT_ID', 
                                                                    'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN

                  sscc_ := CASE sscc_ WHEN '%' THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           inv_list_no_                => inv_list_no_,
                                           aggregated_line_id_         => aggregated_line_id_,
                                           location_no_                => location_no_,
                                           handling_unit_id_           => handling_unit_id_,
                                           sscc_                       => sscc_,  
                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_);
               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_         => capture_session_id_,
                                                 session_rec_                => session_rec_,
                                                 owning_data_item_id_        => latest_data_item_id_,
                                                 owning_data_item_value_     => latest_data_item_value_,
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id);
               END IF;

            ELSE  -- FEEDBACK ITEMS AS DETAILS

               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC',
                                                                    'HANDLING_UNIT_TYPE_CATEG_ID', 'HANDLING_UNIT_TYPE_CATEG_DESC',
                                                                    'HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_DESC')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_WAREHOUSE_ID', 'HANDLING_UNIT_BAY_ID', 'HANDLING_UNIT_TIER_ID', 
                                                                       'HANDLING_UNIT_ROW_ID', 'HANDLING_UNIT_BIN_ID', 'HANDLING_UNIT_LOCATION_TYPE', 
                                                                       'HANDLING_UNIT_LOCATION_NO_DESC', 'HANDLING_UNIT_COMPOSITION', 'HANDLING_UNIT_STRUCTURE_LEVEL',
                                                                       'TOP_PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_SSCC', 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);

               -- ELSIFs below are all summarized/group details for the current handling unit and its structure, so they might not have a unique value if they are different
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('ACTIVITY_SEQ', 'AVAILABILITY_CONTROL_ID', 'AVAILABILITY_CONTROL_DESCRIPTION',
                                                                       'CONDITION_CODE', 'CONFIGURATION_ID', 'ENG_CHG_LEVEL', 'LOT_BATCH_NO',
                                                                       'OWNERSHIP', 'OWNER', 'OWNER_NAME', 'PART_NO', 'SERIAL_NO', 'WAIV_DEV_REJ_NO')) THEN
                          
                  Data_Capture_Invent_Util_API.Add_Detail_For_Hand_Unit_Stock(capture_session_id_   => capture_session_id_,
                                                                              owning_data_item_id_  => latest_data_item_id_,
                                                                              data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              contract_             => contract_,
                                                                              location_no_          => location_no_,
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


               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION')) THEN

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
                                                                          contract_             => contract_,
                                                                          part_no_              => part_no_);
                  END IF ; 

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID',
                                                                       'SUB_PROJECT_DESCRIPTION', 'ACTIVITY_ID', 'ACTIVITY_DESCRIPTION')) THEN

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
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
   ptr_                          NUMBER;
   name_                         VARCHAR2(50);
   value_                        VARCHAR2(4000);
   inv_list_no_                  VARCHAR2(15);
   aggregated_line_id_           COUNTING_REPORT_HANDL_UNIT.objid%TYPE;
   confirm_                      VARCHAR2(5);
   location_no_                  VARCHAR2(35);
   handling_unit_id_             NUMBER;
   action_                       VARCHAR2(30);
   inventory_event_id_           NUMBER;
   blob_ref_tab_                 Data_Capture_Common_Util_API.Blob_Ref_Tab;
   blob_data_item_value_         VARCHAR2(2000);   
   lu_objid_                     VARCHAR2(2000);
   dummy_string_                 VARCHAR2(2000);  
   image_seq_                    NUMBER := 0;
   site_date_                    DATE;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INV_LIST_NO') THEN
         inv_list_no_ := value_;
      ELSIF (name_ = 'AGGREGATED_LINE_ID') THEN
         aggregated_line_id_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_;
      ELSIF (name_ = 'ACTION') THEN
         action_ := value_;
      ELSIF (name_ = 'CONFIRM') THEN
         confirm_ := value_;
      END IF;
   END LOOP; 
   
   IF (action_ = Count_Handl_Unit_Action_API.DB_EXIST) THEN
      Counting_Report_Handl_Unit_API.Count_Hu_Without_Diff(inv_list_no_      => inv_list_no_,
                                                           handling_unit_id_ => handling_unit_id_,
                                                           contract_         => contract_,
                                                           location_no_      => location_no_);
   ELSIF (action_ = Count_Handl_Unit_Action_API.DB_DOES_NOT_EXIST) THEN
      Counting_Report_Handl_Unit_API.Count_Hu_As_Non_Existing(inv_list_no_      => inv_list_no_,
                                                              handling_unit_id_ => handling_unit_id_,
                                                              contract_         => contract_,
                                                              location_no_      => location_no_);
   ELSIF (action_ = Count_Handl_Unit_Action_API.DB_COUNT_SUB_LEVEL) THEN
      Handl_Unit_Stock_Snapshot_API.Modify_Process_Control(objid_           => aggregated_line_id_,
                                                           process_control_ => 'COUNT_SUB_LEVEL');
   ELSIF (action_ = Count_Handl_Unit_Action_API.DB_COUNT_PARTS) THEN
      Handl_Unit_Stock_Snapshot_API.Modify_Process_Control(objid_           => aggregated_line_id_,
                                                           process_control_ => 'COUNT_PARTS',
                                                           modify_children_ => TRUE);
   END IF;

   IF (confirm_ = Gen_Yes_No_API.DB_YES AND action_ IN (Count_Handl_Unit_Action_API.DB_EXIST, Count_Handl_Unit_Action_API.DB_DOES_NOT_EXIST)) THEN
      inventory_event_id_ := Get_inventory_event_Id___(process_message_);  -- inventory_event_id_ controls when the snapshot should be updated (when everything is finished)
      Inventory_Event_Manager_API.Set_Session_Id(inventory_event_id_);
      Counting_Report_Handl_Unit_API.Confirm_Handling_Unit(inv_list_no_        => inv_list_no_,
                                                           handling_unit_id_   => handling_unit_id_,
                                                           contract_           => contract_,
                                                           location_no_        => location_no_);
   END IF;
   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Start saving potential photos connected to this particular handling unit by fetching objid for the handling_unit_id_.
      Handling_Unit_API.Get_Id_Version_By_Keys(lu_objid_, dummy_string_, handling_unit_id_);
      -- Convert blob references from attribute string to collection for easier handling     
      blob_ref_tab_ := Data_Capt_Sess_Line_Blob_API.Get_Blob_Ref_Tab_From_Attr(blob_ref_attr_);
      site_date_    := Site_API.Get_Site_Date(contract_);
      
      IF (blob_ref_tab_.COUNT > 0) THEN
         -- Iterate collection of blob references, extract photos, and save/connect each one to the desired object
         FOR i IN blob_ref_tab_.FIRST..blob_ref_tab_.LAST LOOP
            image_seq_ := image_seq_ + 1;
            blob_data_item_value_ := capture_session_id_ || '|' || blob_ref_tab_(i).session_line_no || '|' || blob_ref_tab_(i).blob_id; 
            Data_Capt_Sess_Line_Blob_API.Save_To_Media_Library(blob_data_item_value_ => blob_data_item_value_, 
                                                               lu_                   => 'HandlingUnit', 
                                                               lu_objid_             => lu_objid_, 
                                                               name_                 => 'WADACO Count Handling Unit per Count Report '|| inv_list_no_ ||' '||site_date_ ||' '|| image_seq_,
                                                               description_          => 'WADACO Count Handling Unit per Count Report '|| inv_list_no_ ||' '||site_date_ ||' '|| image_seq_ );
         END LOOP;
      END IF; 
   $END      

END Execute_Process;


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


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'COUNTOK: The counting was saved.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'COUNTSOK: :P1 countings were saved.', NULL, no_of_records_handled_);
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


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Counting_Report_Handl_Unit_API.Count_Hu_Without_Diff is granted thru following projection/action
   -- Check to see that API method Counting_Report_Handl_Unit_API.Count_Hu_As_Non_Existing is granted thru following projection/action
   -- Check to see that API method Counting_Report_Handl_Unit_API.Confirm_Handling_Unit is granted thru following projection/action
   IF (Security_SYS.Is_Proj_Action_Available('CountPerCountReport', 'CountWithoutDiff') OR
       Security_SYS.Is_Proj_Action_Available('CountPerCountReport', 'CountAsZero') OR
       Security_SYS.Is_Proj_Action_Available('CountPerCountReport', 'ConfirmAggregated')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;

                             
