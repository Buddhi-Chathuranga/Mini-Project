-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptScrapHandlUnit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: SCRAP_HANDLING_UNIT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200819  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171101  DaZase  STRSC-13067, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171101          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  171101  CKumlk  STRSC-13711, Changed size of scrap_note_ to 2000 in Execute_Process.
--  170217  DaZase  Changes in Get_Sql_Where_Expression___ due to unique Handling_Unit_API
--  170217          methods now uses table instead of extended view for performance reasons.
--  160929  KHVESE  LIM-7572, Change in Get_Sql_Where_Expression___ to add condition has_stock_reservation_db.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160531  LEPESE  LIM-7581, Change in Get_Sql_Where_Expression___ to use view column location_type_db instead of PL function call.
--  160523  KHVESE  STRSC-2439, Modified  Get_Sql_Where_Expression___() to filter out HUs with Qty reserved.
--  160519  KHVESE  LIM-6162, Modified  Add_Details_For_Latest_Item().
--  160420  JanWse  STRSC-1785, Added TRUE to also check for blocked in a call to Scrapping_Cause_API.Exist
--  151207  KhVese  LIM-5063, LIM-5065, Modified Validate_Data_Item() to filter handling unit based on location.
--  151207          Also added feedback item 'Scrapping Cause Description' to method Add_Details_For_Latest_Item().
--  151103  KhVese  LIM-2924, Created. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_all_values_ CONSTANT VARCHAR2(1) := '%';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Get_Filter_Keys___ (
   contract_                      OUT VARCHAR2,
   handling_unit_id_              OUT NUMBER,
   sscc_                          OUT VARCHAR2,
   alt_handling_unit_label_id_    OUT VARCHAR2,
   location_no_                   OUT VARCHAR2,  -- not used for filtering in unique handling
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
      handling_unit_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      location_no_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
   

      IF (handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) THEN
         -- Get handling unit id from "alternative keys" sscc_ and alt_handling_unit_label_id_ to be able to validate
         IF (sscc_ IS NOT NULL AND sscc_ != string_all_values_) THEN
            handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_);
         ELSIF (alt_handling_unit_label_id_ IS NOT NULL AND alt_handling_unit_label_id_ != string_all_values_) THEN
            handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(alt_handling_unit_label_id_);
         END IF;
      END IF;
      
      -- if sscc_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all sscc in the table
      IF (sscc_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := string_all_values_;
      END IF;

      -- if alt_handling_unit_label_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all alternative handling unit label ids in the table
      IF (alt_handling_unit_label_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := string_all_values_;
      END IF;

      IF (use_unique_values_) THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(capture_session_id_,handling_unit_id_, sscc_, alt_handling_unit_label_id_, location_no_, 'HANDLING_UNIT_ID');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(capture_session_id_,handling_unit_id_, sscc_, alt_handling_unit_label_id_, location_no_, 'LOCATION_NO');
         END IF;
         
      END IF;
   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;

FUNCTION Get_Unique_Data_Item_Value___ (
   capture_session_id_            IN  NUMBER,
   handling_unit_id_              IN NUMBER,
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2,
   location_no_                   IN VARCHAR2, 
   wanted_data_item_id_           IN VARCHAR2 ) RETURN VARCHAR2
IS
   sql_where_expression_         VARCHAR2(2000) := Get_Sql_Where_Expression___(capture_session_id_);
   unique_value_                 VARCHAR2(200);
   dummy_                        BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (wanted_data_item_id_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'LOCATION_NO')) THEN
         IF location_no_ IS NOT NULL THEN 
            sql_where_expression_ := sql_where_expression_ || ' AND location_no = ''' || location_no_ || ''' ';
         END IF ;
         unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_       => dummy_,
                                                                       handling_unit_id_            => handling_unit_id_, 
                                                                       sscc_                        => sscc_,
                                                                       alt_handling_unit_label_id_  => alt_handling_unit_label_id_, 
                                                                       column_name_                 => wanted_data_item_id_,
                                                                       sql_where_expression_        => sql_where_expression_);
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
   handling_unit_id_             IN NUMBER,
   sscc_                         IN VARCHAR2,
   alt_handling_unit_label_id_   IN VARCHAR2,
   location_no_                  IN VARCHAR2 )  
IS
   detail_value_                 VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('HANDLING_UNIT_ID') THEN
            detail_value_ := handling_unit_id_;
         WHEN ('SSCC') THEN
            IF (sscc_ != string_all_values_) THEN
               detail_value_ := sscc_;
            END IF;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            IF (alt_handling_unit_label_id_ != string_all_values_) THEN
               detail_value_ := alt_handling_unit_label_id_;
            END IF;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
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
      message_ := Language_SYS.Translate_Constant(lu_name_, 'SCRAPHANDLINGUNIT: The Handling unit was scrapped.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'SCRAPHANDLINGUNITS: :P1 handling units were scrapped.', NULL, no_of_records_handled_);
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
   handling_unit_id_            number;
   scrapping_cause_             VARCHAR2(20);
   print_serviceability_tag_    VARCHAR2(200);
   scrap_note_                  VARCHAR2(2000);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
      IF (name_ = 'SCRAPPING_CAUSE') THEN
         scrapping_cause_ := value_;
      END IF;
      IF (name_ = 'SCRAP_NOTE') THEN
         scrap_note_ := value_;
      END IF;
      IF (name_ = 'PRINT_SERVICEABILITY_TAG') THEN
         print_serviceability_tag_ := value_;
      END IF;
   END LOOP;
   Handling_Unit_API.Scrap(handling_unit_id_             => handling_unit_id_, 
                           scrap_cause_                  => scrapping_cause_, 
                           scrap_note_                   => scrap_note_, 
                           print_serviceability_tag_db_  => print_serviceability_tag_);

END Execute_Process;


FUNCTION Is_Process_Available (
   capture_process_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Handling_Unit_API.Scrap is granted thru following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsInReceiptHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseTierHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseNavigatorHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseRowHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsInShipmentInventoryHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseLocHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('InventLocationWarehouseBayHandling', 'ScrapHu') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsInStockHandling', 'ScrapHu')) THEN
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
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   location_no_                   VARCHAR2(35); 
   dummy_contract_                VARCHAR2(5);
   sql_where_expression_          VARCHAR2(2000) := Get_Sql_Where_Expression___(capture_session_id_);
   lov_type_db_                   VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(dummy_contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, location_no_, capture_session_id_, data_item_id_); 

      IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'LOCATION_NO')) THEN
         IF (location_no_ IS NOT NULL) AND (data_item_id_ != 'LOCATION_NO') THEN 
            sql_where_expression_ := sql_where_expression_ || ' AND location_no = ''' || location_no_ || ''' ';
         END IF ;
         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
         Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_             => handling_unit_id_, 
                                                   sscc_                         => sscc_,
                                                   alt_handling_unit_label_id_   => alt_handling_unit_label_id_,
                                                   capture_session_id_           => capture_session_id_,
                                                   column_name_                  => data_item_id_,
                                                   lov_type_db_                  => lov_type_db_,
                                                   sql_where_expression_         => sql_where_expression_);

      ELSIF (data_item_id_ = 'SCRAPPING_CAUSE') THEN
         Scrapping_Cause_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ IN ('PRINT_SERVICEABILITY_TAG')) THEN
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_ => capture_session_id_, 
                                                            capture_process_id_ => capture_process_id_, 
                                                            capture_config_id_  => capture_config_id_, 
                                                            data_item_id_       => data_item_id_, 
                                                            contract_           => contract_);   
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
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   handling_unit_id_              NUMBER;
   contract_                      VARCHAR2(5);
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   location_no_                   VARCHAR2(35); 
   automatic_value_               VARCHAR2(200);
   dummy_                         BOOLEAN;
   sql_where_expression_         VARCHAR2(2000) := Get_Sql_Where_Expression___(capture_session_id_);
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

         Get_Filter_Keys___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, location_no_, capture_session_id_, data_item_id_);
         IF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'LOCATION_NO')) THEN
            IF location_no_ IS NOT NULL THEN 
               sql_where_expression_ := sql_where_expression_ || ' AND location_no = ''' || location_no_ || ''' ';
            END IF ;
            automatic_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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

FUNCTION Get_Sql_Where_Expression___ ( 
   capture_session_id_  IN NUMBER ) RETURN VARCHAR2
IS
   session_rec_   Data_Capture_Common_Util_API.Session_Rec;
   return_value_  VARCHAR2(2000);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- NOTE: No point in using user allowed checks here since the session contract have already been checked for that before the process started
      return_value_ := ' AND  Handling_Unit_API.Has_Quantity_In_Stock(handling_unit_id) = ''TRUE''
                         AND  shipment_id IS NULL
                         AND  contract = ''' || session_rec_.session_contract || '''
                         AND  location_type IN (''PICKING'', ''F'', ''MANUFACTURING'')
                         AND  has_stock_reservation = ''FALSE'' 
                         AND  Handling_Unit_API.Is_In_Inventory_Transit(handling_unit_id) = ''FALSE'' ';
   $END
   RETURN return_value_;
END Get_Sql_Where_Expression___;

PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2,
   data_item_value_     IN VARCHAR2 )
IS
   contract_                      VARCHAR2(5);
   handling_unit_id_              NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   location_no_                   VARCHAR2(35); 
   data_item_description_         VARCHAR2(200);
   sql_where_expression_          VARCHAR2(2000) := Get_Sql_Where_Expression___(capture_session_id_);
   dummy_                         BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_  => capture_session_id_,
                                                      data_item_id_        => data_item_id_,
                                                      data_item_value_     => data_item_value_);
   
      Get_Filter_Keys___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, location_no_, capture_session_id_, data_item_id_, data_item_value_);
      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(capture_process_id_ => Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), 
                                                                             data_item_id_ => data_item_id_);
      IF (data_item_id_ IN ('SCRAPPING_CAUSE')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_        => capture_session_id_, 
                                                                data_item_id_              => data_item_id_, 
                                                                data_item_value_           => data_item_value_, 
                                                                mandatory_non_process_key_ => TRUE);
         Scrapping_Cause_API.Exist(data_item_value_, TRUE);
      ELSIF (data_item_id_ = 'PRINT_SERVICEABILITY_TAG') THEN
         IF NOT (Gen_Yes_No_API.Exists_Db(data_item_value_)) THEN  
            Error_SYS.Record_General(lu_name_, 'YESNOERROR: You can enter either :P1 or :P2.', Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_YES),Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_NO));
         END IF;
      ELSIF (data_item_id_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'LOCATION_NO')) THEN
         IF (data_item_id_ = 'HANDLING_UNIT_ID') THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_        => capture_session_id_, 
                                                                   data_item_id_              => data_item_id_, 
                                                                   data_item_value_           => data_item_value_);
            Handling_Unit_API.Exist(data_item_value_); 
         END IF;
         IF location_no_ IS NOT NULL THEN 
            sql_where_expression_ := sql_where_expression_ || ' AND location_no = ''' || location_no_ || ''' ';
         END IF ;
         Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_              => dummy_, 
                                                          handling_unit_id_           => handling_unit_id_, 
                                                          sscc_                       => sscc_, 
                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_, 
                                                          column_name_                => data_item_id_, 
                                                          column_value_               => data_item_value_, 
                                                          column_description_         => data_item_description_, 
                                                          sql_where_expression_       => sql_where_expression_);
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
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
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   location_no_                   VARCHAR2(35); 
   part_no_                       VARCHAR2(25);
   condition_code_                VARCHAR2(10);
   activity_seq_                  NUMBER;
   no_unique_value_found_         BOOLEAN; 
   scrapping_cause_               VARCHAR2(8);
   mixed_item_value_              VARCHAR2(25) := Language_SYS.Translate_Constant(lu_name_,'MIXEDITEM: Mixed');
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      Get_Filter_Keys___(contract_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, location_no_, capture_session_id_, 
                         data_item_id_ => latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE);

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
      
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_ID', 'ALT_HANDLING_UNIT_LABEL_ID', 'SSCC', 'LOCATION_NO')) THEN
                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  sscc_ := CASE sscc_ WHEN '%' THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
                  -- FILTER DATA ITEMS AS DETAILS
                  Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                           owning_data_item_id_         => latest_data_item_id_,
                                           data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                           handling_unit_id_            => handling_unit_id_,
                                           sscc_                        => sscc_,
                                           alt_handling_unit_label_id_  => alt_handling_unit_label_id_,
                                           location_no_                 => location_no_);
                                           
               ELSE
                  -- RESIDUAL DATA ITEMS AS DETAILS
                  Add_Unique_Data_Item_Detail___(capture_session_id_     => capture_session_id_,
                                                 session_rec_            => session_rec_,
                                                 owning_data_item_id_    => latest_data_item_id_,
                                                 owning_data_item_value_ => latest_data_item_value_,
                                                 data_item_detail_id_    => conf_item_detail_tab_(i).data_item_detail_id);
               END IF;
            ELSE  
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SCRAPPING_CAUSE_DESC')) THEN
                     scrapping_cause_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                                                current_data_item_id_    => latest_data_item_id_,
                                                                                                current_data_item_value_ => latest_data_item_value_,
                                                                                                wanted_data_item_id_     => 'SCRAPPING_CAUSE',
                                                                                                session_rec_             => session_rec_,
                                                                                                process_package_         => Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id));
                     Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                       data_item_id_        => latest_data_item_id_,
                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                       data_item_value_     => Scrapping_Cause_API.Get_Reject_Message(scrapping_cause_));

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARENT_HANDLING_UNIT_DESC', 'HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_DESC',
                                                                       'HANDLING_UNIT_TYPE_CATEG_ID', 'HANDLING_UNIT_TYPE_CATEG_DESC', 'HANDLING_UNIT_TYPE_STACKABLE', 
                                                                       'HANDLING_UNIT_TYPE_ADD_VOLUME', 'HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'HANDLING_UNIT_TYPE_MAX_WGT_CAP',
																	   'TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN

                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                             owning_data_item_id_ => latest_data_item_id_,
                                                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_    => handling_unit_id_);
                                                                             
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_COMPOSITION', 'HANDLING_UNIT_ACCESSORY_EXIST', 'HANDLING_UNIT_GEN_SSCC', 
                                                                       'HANDLING_UNIT_WIDTH', 'HANDLING_UNIT_HEIGHT', 'HANDLING_UNIT_DEPTH', 'HANDLING_UNIT_UOM_LENGTH',
                                                                       'HANDLING_UNIT_MANUAL_GROSS_WEIGHT', 'HANDLING_UNIT_MANUAL_VOLUME', 'HANDLING_UNIT_NET_WEIGHT',
                                                                       'HANDLING_UNIT_OPERATIVE_VOLUME', 'HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT', 'HANDLING_UNIT_TARE_WEIGHT', 
                                                                       'HANDLING_UNIT_UOM_WEIGHT', 'HANDLING_UNIT_UOM_VOLUME', 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED', 
                                                                       'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED', 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED', 
                                                                       'HANDLING_UNIT_NO_OF_LBLS', 'HANDLING_UNIT_PRINT_LBL', 'HANDLING_UNIT_STRUCTURE_LEVEL', 
                                                                       'PARENT_HANDLING_UNIT_ID', 'PARENT_SSCC', 'PARENT_ALT_HANDLING_UNIT_LABEL_ID', 
                                                                       'TOP_PARENT_HANDLING_UNIT_ID', 'TOP_PARENT_SSCC', 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID', 
                                                                       'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                            owning_data_item_id_  => latest_data_item_id_,
                                                                            data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                            handling_unit_id_     => handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID', 'LOCATION_TYPE', 'LOCATION_NO_DESC')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_NO', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'ENG_CHG_LEVEL', 
                                                                       'WAIV_DEV_REJ_NO', 'CONDITION_CODE', 'ACTIVITY_SEQ', 'AVAILABILITY_CONTROL_ID', 
                                                                       'AVAILABILITY_CONTROL_DESCRIPTION', 'FREEZE_FLAG', 'ROTABLE_PART_POOL_ID',
                                                                       'EXPIRATION_DATE', 'LAST_ACTIVITY_DATE', 'LAST_COUNT_DATE', 
                                                                       'OWNERSHIP', 'OWNER', 'OWNER_NAME',
                                                                       'QTY_ONHAND', 'CATCH_QTY_ONHAND', 'QTY_IN_TRANSIT', 
                                                                       'CATCH_QTY_IN_TRANSIT', 'QTY_RESERVED','PART_ACQUISITION_VALUE', 
                                                                       'TOTAL_ACQUISITION_VALUE', 'TOTAL_INVENTORY_VALUE')) THEN
                          
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
               
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 
                                                                       'UNIT_MEAS_DESCRIPTION')) THEN

                  part_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_,
                                                                               handling_unit_id_,
                                                                               'PART_NO');
                  -- Too many found
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

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROGRAM_ID', 'PROGRAM_DESCRIPTION', 'PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID',
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
