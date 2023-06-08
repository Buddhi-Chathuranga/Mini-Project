-----------------------------------------------------------------------------
--
--  Logical unit: DataCapProcessHuShip
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process/es: MOVE_HU_BETWEEN_SHIP_INV, RETURN_HU_FROM_SHIP_INV, SCRAP_HU_IN_SHIP_INV
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220513  Moinlk  SCDEV-7787, Added Get_Sql_Where_Expression method. And filtered data where soure_ref_type_db not set to PURCH_RECEIPT_RETURN.
--  211217  BWITLK  Bug 161586(SCZ-16866), Modified Add_Filter_Key_Detail___() to change the datatypes of location_no_ and from_location_no_ as VARCHAR2
--  200902  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  191211  DaZase  SCXTEND-1005, Did some cleanup job and removed unnecessary variables/parameters send in to Handle_Ship_Invent_Utility_API.Create_Data_Capture_Lov.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  180202  SWiclk  STRSC-16141, Modifide Add_Details_For_Latest_Item() in order to handle TO_ and FROM_ feedbacks items of WAREHOUSE_ID, BAY_ID, ROW_ID, TIER_ID, BIN_ID. 
--  171212  CKumlk  STRSC-14940, Renamed process IDs MOVE_HU_IN_SHIP_INV to MOVE_HU_BETWEEN_SHIP_INV and RETURN_HU_IN_SHIP_INV to RETURN_HU_FROM_SHIP_INV.
--  171208  CKumlk  STRSC-15074, Renamed FROM_LOCATION_NO to LOCATION_NO, FROM_LOCATION_NO_DESC to LOCATION_NO_DESC and FROM_LOCATION_TYPE to LOCATION_TYPE for SCRAP_HU_IN_SHIP_INV process.
--  171012  SURBLK  STRSC-9595, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
string_all_values_ CONSTANT VARCHAR2(1) := '%';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   wanted_data_item_id_        IN VARCHAR2,
   capture_process_id_         IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_                 VARCHAR2(200);
   column_name_                  VARCHAR2(30);
   no_unique_value_found_        BOOLEAN;
BEGIN
   IF (wanted_data_item_id_ = 'FROM_LOCATION_NO') THEN
      column_name_ := 'LOCATION_NO';
   ELSE
      column_name_ := wanted_data_item_id_;
   END IF;
   unique_value_ := Handle_Ship_Invent_Utility_API.Get_Column_Value_If_Unique(no_unique_value_found_      => no_unique_value_found_,
                                                                              contract_                   => contract_,
                                                                              location_no_                => from_location_no_,
                                                                              handling_unit_id_           => handling_unit_id_,
                                                                              sscc_                       => sscc_,
                                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                              column_name_                => column_name_,
                                                                              sql_where_expression_       => Get_Sql_Where_Expression(capture_process_id_));
   IF (unique_value_ = 'NULL') THEN
      unique_value_ := NULL;
   END IF;
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   contract_                   OUT VARCHAR2,
   handling_unit_id_           OUT NUMBER,
   sscc_                       OUT VARCHAR2,
   alt_handling_unit_label_id_ OUT VARCHAR2,
   from_location_no_           OUT VARCHAR2,
   location_no_                OUT VARCHAR2,
   capture_session_id_         IN  NUMBER,
   data_item_id_               IN  VARCHAR2,
   data_item_value_            IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_          IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_             IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   process_package_     VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_         := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_     := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_            := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      handling_unit_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      from_location_no_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      location_no_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
   
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
         alt_handling_unit_label_id_ := string_all_values_;
      END IF;
      
      IF (sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := string_all_values_;
      END IF;
      
      IF use_unique_values_ THEN
         --If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, 'HANDLING_UNIT_ID', session_rec_.capture_process_id);
         END IF;
         IF (sscc_ IS NULL) THEN
            sscc_ := Get_Unique_Data_Item_Value___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, 'SSCC', session_rec_.capture_process_id);
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_.capture_process_id);
         END IF;
         IF (from_location_no_ IS NULL) THEN
            from_location_no_ := Get_Unique_Data_Item_Value___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, 'FROM_LOCATION_NO', session_rec_.capture_process_id);
         END IF;
         IF (session_rec_.capture_process_id = 'SCRAP_HU_IN_SHIP_INV' AND location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, 'LOCATION_NO', session_rec_.capture_process_id);
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
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   location_no_                IN VARCHAR2 )  
IS
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('HANDLING_UNIT_ID') THEN
            detail_value_ := handling_unit_id_;
         WHEN ('SSCC') THEN
            detail_value_ := sscc_;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := alt_handling_unit_label_id_;
         WHEN ('FROM_LOCATION_NO') THEN
            detail_value_ := from_location_no_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
         ELSE
            NULL;
      END CASE;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Filter_Key_Detail___;


PROCEDURE Add_Unique_Data_Item_Detail___ (
   capture_session_id_         IN NUMBER,
   session_rec_                IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_        IN VARCHAR2,
   owning_data_item_value_     IN VARCHAR2,
   data_item_detail_id_        IN VARCHAR2)
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


      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2, 
   data_item_value_     IN VARCHAR2 )       
IS
   contract_                      VARCHAR2(5);
   handling_unit_id_              NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   from_location_no_              VARCHAR2(35); 
   location_no_                   VARCHAR2(35);
   location_type_db_              VARCHAR2(20);
   data_item_description_         VARCHAR2(200);
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   capture_process_id_            session_rec_.capture_process_id%TYPE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, location_no_, capture_session_id_, data_item_id_);                                                

      IF (data_item_id_ = 'NOTE') THEN 
         NULL;
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);     
      ELSIF (data_item_id_ IN ('TO_LOCATION_NO')) THEN
         IF (from_location_no_ IS NOT NULL AND from_location_no_ = data_item_value_) THEN
            Error_SYS.Record_General(lu_name_,'MOVETOSAMELOC: You cannot move the part(s) to the same location :P1, select a different location.', from_location_no_);
         END IF;
         
         Inventory_Location_API.Exist(contract_, data_item_value_);
         session_rec_         := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         capture_process_id_  := session_rec_.capture_process_id;
         
         location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, data_item_value_);
         
         IF capture_process_id_ = 'MOVE_HU_BETWEEN_SHIP_INV' THEN
            IF location_type_db_ != Inventory_Location_Type_API.DB_SHIPMENT THEN
               Handle_Ship_Invent_Utility_API.Raise_Not_A_Shipment_Location;
            END IF;
         ELSIF capture_process_id_ = 'RETURN_HU_FROM_SHIP_INV' THEN
            IF NOT location_type_db_ IN (Inventory_Location_Type_API.DB_PICKING, Inventory_Location_Type_API.DB_PRODUCTION_LINE, Inventory_Location_Type_API.DB_FLOOR_STOCK) THEN
               Error_SYS.Record_General(lu_name_,'INVALIDSHIPLOC: To location is not a Picking, Production Line or Foor Stock location.', data_item_value_);
            END IF;
         END IF; 
      ELSIF (data_item_id_ IN ('SCRAPPING_CAUSE')) THEN
         Scrapping_Cause_API.Exist(reject_reason_   => data_item_value_, 
                                    check_validity_ => TRUE);
      ELSIF   (data_item_id_ in ('FROM_LOCATION_NO' , 'LOCATION_NO')) THEN
         data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
         
         Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                         'LOCATION_NO',
                                                         data_item_value_);
                                                         
         Handle_Ship_Invent_Utility_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                       location_no_                => data_item_value_, 
                                                                       handling_unit_id_           => handling_unit_id_, 
                                                                       sscc_                       => sscc_, 
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_, 
                                                                       column_name_                => 'LOCATION_NO', 
                                                                       column_value_               => data_item_value_, 
                                                                       column_description_         => data_item_description_,
                                                                       sql_where_expression_       => Get_Sql_Where_Expression(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_)));
         
      ELSE  
         data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
         
         Handle_Ship_Invent_Utility_API.Record_With_Column_Value_Exist( contract_                  => contract_,
                                                                       location_no_                => from_location_no_,
                                                                       handling_unit_id_           => handling_unit_id_,
                                                                       sscc_                       => sscc_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       column_name_                => data_item_id_,
                                                                       column_value_               => data_item_value_,  
                                                                       column_description_         => data_item_description_,
                                                                       sql_where_expression_       => Get_Sql_Where_Expression(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_)));
                                                           
      END IF;                                                   
   $ELSE
      NULL;   
   $END
END Validate_Data_Item;


PROCEDURE Create_List_Of_Values (
   capture_session_id_  IN NUMBER,
   capture_process_id_  IN VARCHAR2,
   capture_config_id_   IN NUMBER,
   data_item_id_        IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS
   from_location_no_             VARCHAR2(35);
   to_location_no_               VARCHAR2(35);
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   lov_type_db_                  VARCHAR2(20);
   dummy_contract_               VARCHAR2(5);
   column_name_                  VARCHAR2(30);
   lov_id_                       VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(dummy_contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, to_location_no_, capture_session_id_, data_item_id_);                                                
      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_); 
      IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'FROM_LOCATION_NO', 'LOCATION_NO')) THEN
         IF (data_item_id_ = 'FROM_LOCATION_NO') THEN
            column_name_ := 'LOCATION_NO';
         ELSE
            column_name_ := data_item_id_;
         END IF;

         Handle_Ship_Invent_Utility_API.Create_Data_Capture_Lov(contract_                => contract_,
                                                             location_no_                => from_location_no_,
                                                             handling_unit_id_           => handling_unit_id_,
                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                             sscc_                       => sscc_,
                                                             capture_session_id_         => capture_session_id_,
                                                             column_name_                => column_name_,
                                                             lov_type_db_                => lov_type_db_,
                                                             sql_where_expression_       => Get_Sql_Where_Expression(capture_process_id_));                                     
      ELSIF (data_item_id_ IN ('TO_LOCATION_NO')) THEN
         IF capture_process_id_ = 'MOVE_HU_BETWEEN_SHIP_INV' THEN
            lov_id_ := 6;
         ELSIF capture_process_id_ = 'RETURN_HU_FROM_SHIP_INV' THEN
            lov_id_ := 1;
         END IF;
            
         Inventory_Location_API.Create_Data_Capture_Lov(contract_            => contract_, 
                                                        capture_session_id_  => capture_session_id_, 
                                                        lov_id_              => lov_id_,
                                                        exclude_location_no_ => from_location_no_);   
      ELSIF(data_item_id_ = 'SCRAPPING_CAUSE') THEN
         Scrapping_Cause_API.Create_Data_Capture_Lov(capture_session_id_);                                                  
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
   message_               VARCHAR2(200);
BEGIN
   IF (capture_process_id_ = 'MOVE_HU_BETWEEN_SHIP_INV') THEN
      IF no_of_records_handled_ = 1 THEN
         message_ :=  Language_SYS.Translate_Constant(lu_name_, 'MOVEOK: The stock move has been completed.');
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'MOVESOK: :P1 stock moves have been completed.', NULL, no_of_records_handled_);
      END IF;
   ELSIF (capture_process_id_ = 'RETURN_HU_FROM_SHIP_INV') THEN
      IF no_of_records_handled_ = 1 THEN
         message_ :=  Language_SYS.Translate_Constant(lu_name_, 'RETURNOK: The stock return has been completed.');
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'RETURNSOK: :P1 stock returns have been completed.', NULL, no_of_records_handled_);
      END IF;
   ELSIF (capture_process_id_ = 'SCRAP_HU_IN_SHIP_INV') THEN
      IF no_of_records_handled_ = 1 THEN
         message_ :=  Language_SYS.Translate_Constant(lu_name_, 'SCRAPOK: The stock scrap has been completed.');
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'SCRAPSOK: :P1 stock scraps have been completed.', NULL, no_of_records_handled_);
      END IF;
   END IF;
   
   RETURN message_;
END Get_Process_Execution_Message;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                     VARCHAR2(5);
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   capture_process_id_           session_rec_.capture_process_id%TYPE;
   from_location_no_             VARCHAR2(35);
   location_no_                  VARCHAR2(35);
   automatic_value_              VARCHAR2(200);
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   column_name_                  VARCHAR2(30);
   lov_id_                       NUMBER;
   no_unique_value_found_        BOOLEAN;
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
         Get_Filter_Keys___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, location_no_, capture_session_id_, data_item_id_);                                                

         IF (data_item_id_ IN ('NOTE', 'GS1_BARCODE1', 'GS1_BARCODE2')) THEN
            automatic_value_ := NULL;
         ELSIF (data_item_id_ = 'TO_LOCATION_NO') THEN
            capture_process_id_  := session_rec_.capture_process_id;

            IF capture_process_id_ = 'MOVE_HU_BETWEEN_SHIP_INV' THEN                                                   
                  lov_id_ := 6;
            ELSIF capture_process_id_ = 'RETURN_HU_FROM_SHIP_INV' THEN
                  lov_id_ := 1;  
            END IF;
            automatic_value_ := Inventory_Location_API.Get_Location_No_If_Unique(contract_ => contract_,
                                                                                 lov_id_   => lov_id_);
         ELSE
            IF (data_item_id_ = 'FROM_LOCATION_NO') THEN
               column_name_ := 'LOCATION_NO';
            ELSIF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
               column_name_ := 'SOURCE_REF_TYPE_DB';   
            ELSE
               column_name_ := data_item_id_;
            END IF;
            
            automatic_value_ := Handle_Ship_Invent_Utility_API.Get_Column_Value_If_Unique(no_unique_value_found_                  => no_unique_value_found_,
                                                                                          contract_                               => contract_,
                                                                                          location_no_                            => from_location_no_,
                                                                                          handling_unit_id_                       => handling_unit_id_,
                                                                                          sscc_                                   => sscc_,
                                                                                          alt_handling_unit_label_id_             => alt_handling_unit_label_id_,
                                                                                          column_name_                            => column_name_,
                                                                                          sql_where_expression_                   => Get_Sql_Where_Expression(session_rec_.capture_process_id));

         END IF;
      END IF;
   $ELSE
      RETURN NULL;
   $END
   
   RETURN automatic_value_;  
END Get_Automatic_Data_Item_Value;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_          Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                      VARCHAR2(5);
   handling_unit_id_              NUMBER;
   from_location_no_              VARCHAR2(35);
   to_location_no_                VARCHAR2(35);
   location_no_                   VARCHAR2(35);
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      Get_Filter_Keys___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, from_location_no_, location_no_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'FROM_LOCATION_NO', 'LOCATION_NO')) THEN
                  -- Data Items that are part of the filter keys
                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN string_all_values_ THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  sscc_ := CASE sscc_ WHEN string_all_values_ THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
                  
                  Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                           owning_data_item_id_         => latest_data_item_id_,
                                           data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                           handling_unit_id_            => handling_unit_id_,
                                           sscc_                        => sscc_,
                                           alt_handling_unit_label_id_  => alt_handling_unit_label_id_,
                                           from_location_no_            => from_location_no_,
                                           location_no_                 => location_no_);
                                           
               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_     => capture_session_id_,
                                                 session_rec_            => session_rec_,
                                                 owning_data_item_id_    => latest_data_item_id_,
                                                 owning_data_item_value_ => latest_data_item_value_,
                                                 data_item_detail_id_    => conf_item_detail_tab_(i).data_item_detail_id);
               END IF;
            ELSE  
               -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_DESC', 'HANDLING_UNIT_TYPE_CATEG_ID',
                                                                    'HANDLING_UNIT_TYPE_CATEG_DESC', 'TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_SSCC', 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'HANDLING_UNIT_COMPOSITION', 'HANDLING_UNIT_STRUCTURE_LEVEL')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);
                                                                             
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'ROW_ID', 'TIER_ID',
                                                                       'BIN_ID', 'LOCATION_NO_DESC', 'LOCATION_TYPE')) THEN
                 
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);
               
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('FROM_WAREHOUSE_ID', 'FROM_BAY_ID', 'FROM_ROW_ID', 'FROM_TIER_ID',
                                                                       'FROM_BIN_ID', 'FROM_LOCATION_NO_DESC', 'FROM_LOCATION_TYPE')) THEN
                                                                       
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => from_location_no_); 
                                                                           
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TO_WAREHOUSE_ID', 'TO_BAY_ID', 'TO_ROW_ID', 'TO_TIER_ID',
                                                                       'TO_BIN_ID', 'TO_LOCATION_NO_DESC', 'TO_LOCATION_TYPE')) THEN
                   
                  to_location_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, latest_data_item_id_, latest_data_item_value_, 'TO_LOCATION_NO', session_rec_); 
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => to_location_no_); 
               
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_ID', 'SERIAL_NO', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'QTY_PICKED', 'ACTIVITY_SEQ', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 'SOURCE_REF_TYPE', 'SHIPMENT_LINE_NO', 'CONDITION_CODE', 'CONFIGURATION_ID', 'PART_NO', 'PART_DESCRIPTION', 'SOURCE_PART_NO')) THEN
                  
                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN string_all_values_ THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  sscc_ := CASE sscc_ WHEN string_all_values_ THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
                  Handle_Ship_Invent_Utility_API.Add_Detail_For_Ship_Inv_Hu( capture_session_id_         => capture_session_id_, 
                                                                           owning_data_item_id_          => latest_data_item_id_, 
                                                                           data_item_detail_id_          => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_                     => contract_, 
                                                                           location_no_                  => from_location_no_,
                                                                           handling_unit_id_             => handling_unit_id_,
                                                                           sscc_                         => sscc_,
                                                                           alt_handling_unit_label_id_   => alt_handling_unit_label_id_); 
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
   ptr_                   NUMBER;
   handling_unit_id_      NUMBER;
   name_                  VARCHAR2(50);
   value_                 VARCHAR2(2000);
   to_location_no_        VARCHAR2(35);
   info_                  VARCHAR2(2000);
   scrap_cause_           VARCHAR2(20);
   note_                  VARCHAR2(4000);
   
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   capture_process_id_    session_rec_.capture_process_id%TYPE;
BEGIN
   ptr_ := NULL;
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'HANDLING_UNIT_ID') THEN
            handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF(name_ = 'TO_LOCATION_NO') THEN
            to_location_no_ := value_;
         ELSIF(name_ = 'NOTE') THEN
            note_  := value_;
         ELSIF (name_ = 'SCRAPPING_CAUSE') THEN
            scrap_cause_ := value_;
         END IF;
      END LOOP;

      capture_process_id_  := session_rec_.capture_process_id;

      IF (capture_process_id_ = 'MOVE_HU_BETWEEN_SHIP_INV') THEN
         Handle_Ship_Invent_Utility_API.Move_HU_Between_Ship_Inv__(info_                  => info_,
                                                                  handling_unit_id_list_  => handling_unit_id_, 
                                                                  to_contract_            => contract_, 
                                                                  to_location_no_         => to_location_no_,  
                                                                  move_comment_           => note_);
      ELSIF (capture_process_id_ = 'RETURN_HU_FROM_SHIP_INV') THEN
         Handle_Ship_Invent_Utility_API.Return_HU_From_Ship_Inv__(info_                   => info_,
                                                                  handling_unit_id_list_  => handling_unit_id_, 
                                                                  to_contract_            => contract_, 
                                                                  to_location_no_         => to_location_no_,  
                                                                  move_comment_           => note_); 
      ELSIF (capture_process_id_ = 'SCRAP_HU_IN_SHIP_INV') THEN                                                            
         Handle_Ship_Invent_Utility_API.Scrap_HU_In_Ship_Inv__(   info_                   => info_,
                                                                  handling_unit_id_list_  => handling_unit_id_, 
                                                                  scrap_cause_            => scrap_cause_,
                                                                  scrap_note_             => note_);                                                         

      END IF;
   $END
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (capture_process_id_ = 'MOVE_HU_BETWEEN_SHIP_INV') THEN
      -- Check to see that API method Handle_Ship_Invent_Utility_API.Move_HU_Between_Ship_Inv__ is granted thru any of following projections/actions
      IF (Security_SYS.Is_Proj_Action_Available('HandlingUnitsInShipmentInventoryHandling', 'MoveShipmentInventory')) THEN 
         process_available_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF (capture_process_id_ = 'RETURN_HU_FROM_SHIP_INV') THEN
      -- Check to see that API method Handle_Ship_Invent_Utility_API.Return_HU_From_Ship_Inv__ is granted thru any of following projections/actions
      IF (Security_SYS.Is_Proj_Action_Available('HandlingUnitsInShipmentInventoryHandling', 'ReturnShipmentInventory')) THEN
         process_available_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF (capture_process_id_ = 'SCRAP_HU_IN_SHIP_INV') THEN
      -- Check to see that API method Handle_Ship_Invent_Utility_API.Scrap_HU_In_Ship_Inv__ is granted thru any of following projections/actions
      IF (Security_SYS.Is_Proj_Action_Available('HandlingUnitsInShipmentInventoryHandling', 'ScrapHandlingUnitInShipmentInventory')) THEN
         process_available_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   END IF;
   RETURN process_available_;
END Is_Process_Available;

FUNCTION Get_Sql_Where_Expression(
   capture_process_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   sql_where_expression_ VARCHAR2(400) := ' AND SOURCE_REF_TYPE_DB != ''PURCH_RECEIPT_RETURN'' ';
BEGIN
   IF(capture_process_id_ = 'RETURN_HU_FROM_SHIP_INV') THEN
      RETURN NULL;
   ELSE
      RETURN sql_where_expression_;
   END IF;
END Get_Sql_Where_Expression;

-------------------- LU  NEW METHODS -------------------------------------
