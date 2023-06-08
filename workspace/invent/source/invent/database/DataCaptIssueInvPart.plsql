-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptIssueInvPart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: ISSUE_INVENTORY_PART
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210205  DaZase  SC2020R1-12397, Added missing QUANTITY_AVAILABLE to Add_Details_For_Latest_Item.
--  200825  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Entity_Act_Available in Is_Process_Available to support new projection security concept.
--  181029  BudKlk  Bug 143097, Modified the method Add_Details_For_Latest_Item to add a new feedback item CONDITION_CODE.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171201  LEPESE  STRSC-10938, Added method Get_Feedback_Item_Description.
--  171129  LEPESE  STRSC-10938, Added method Get_Data_Item_Description and added parameter capture_session_id_
--  171129          in call to Data_Capt_Proc_Data_Item_API.Get_Description from Validate_Data_Item.
--  171122  KhVeSE  STRSC-10938, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

posting_type_              CONSTANT VARCHAR2(4)  := 'M110';
mandatory_control_type_    CONSTANT VARCHAR2(3)  := 'C58';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Method sets extra where expression for used in calls to InventoryPartInStock "Unique" methods
FUNCTION Get_Sql_Where_Expression___ RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(2000);
BEGIN
   sql_where_expression_  := ' AND freeze_flag_db = ''N''
                               AND location_type_db IN (''PICKING'',''F'',''MANUFACTURING'') 
                               AND (qty_onhand > qty_reserved )
                               AND ACTIVITY_SEQ = 0 ' ;     
   RETURN sql_where_expression_;
END Get_Sql_Where_Expression___;


FUNCTION Get_Input_Uom_Sql_Whr_Exprs___  RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(32000);
BEGIN   
   sql_where_expression_  := ' AND (purch_usage_allowed = 1 OR cust_usage_allowed = 1 OR manuf_usage_allowed = 1) ';  
   RETURN sql_where_expression_;
END Get_Input_Uom_Sql_Whr_Exprs___;
 

PROCEDURE Get_Filter_Keys___ (
   contract_                    OUT VARCHAR2,
   part_no_                     OUT VARCHAR2,
   configuration_id_            OUT VARCHAR2,
   location_no_                 OUT VARCHAR2,
   lot_batch_no_                OUT VARCHAR2,
   serial_no_                   OUT VARCHAR2,
   waiv_dev_rej_no_             OUT VARCHAR2,
   eng_chg_level_               OUT VARCHAR2,
   barcode_id_                  OUT NUMBER,
   handling_unit_id_            OUT NUMBER,
   sscc_                        OUT VARCHAR2,  -- not used for filtering in unique handling
   alt_handling_unit_label_id_  OUT VARCHAR2,
   gtin_no_                     OUT VARCHAR2,
   capture_session_id_          IN  NUMBER,
   data_item_id_                IN  VARCHAR2,
   data_item_value_             IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_           IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_              IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_     Data_Capture_Common_Util_API.Session_Rec;
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_                 := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_             := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_                    := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      part_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      configuration_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      location_no_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_             := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      gtin_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);
      -- Also fetch predicted barcode_id since this process can use barcodes
      barcode_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'BARCODE_ID', session_rec_ , process_package_, use_applicable_);
      
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
      
      IF (gtin_no_ IS NULL AND Data_Capture_Invent_Util_API.Gtin_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
         gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      END IF;
      
      IF ((part_no_ IS NULL) AND (gtin_no_ IS NOT NULL)) THEN
         part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_); 
      END IF;
          
      -- NOTE: If the part is receipt and issue tracked, but not tracked in inventory, the serial no should not be used in filter.
      IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
          Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
         serial_no_ := NULL;
      END IF;


      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LOCATION_NO');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'BARCODE_ID');
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
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   gtin_no_                    IN VARCHAR2)  
IS
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('PART_NO') THEN
            detail_value_ := part_no_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
         WHEN ('CONFIGURATION_ID') THEN
            detail_value_ := configuration_id_;
         WHEN ('LOT_BATCH_NO') THEN
            detail_value_ := lot_batch_no_;
         WHEN ('SERIAL_NO') THEN
            detail_value_ := serial_no_;
         WHEN ('ENG_CHG_LEVEL') THEN
            detail_value_ := eng_chg_level_;
         WHEN ('WAIV_DEV_REJ_NO') THEN
            detail_value_ := waiv_dev_rej_no_;
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
      /*IF (detail_value_ IS NULL AND data_item_detail_id_ IN ('CONDITION_CODE')) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, data_item_detail_id_);
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
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   wanted_data_item_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_               VARCHAR2(200);
   dummy_                      BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- NOTE: If the part is receipt and issue tracked, but not tracked in inventory, the serial no should be entered.
      IF (wanted_data_item_id_ = 'SERIAL_NO' AND 
          Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
          Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
            unique_value_ := NULL;
      ELSIF (wanted_data_item_id_ = 'BARCODE_ID' OR (barcode_id_ IS NOT NULL AND  
          wanted_data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO'))) THEN
         unique_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => contract_,
                                                                                barcode_id_       => barcode_id_,
                                                                                part_no_          => part_no_,
                                                                                configuration_id_ => configuration_id_,
                                                                                lot_batch_no_     => lot_batch_no_,
                                                                                serial_no_        => serial_no_,
                                                                                eng_chg_level_    => eng_chg_level_,
                                                                                waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                activity_seq_     => 0, -- Issue inventory part doesn't have support for project
                                                                                column_name_      => wanted_data_item_id_);

      ELSIF (wanted_data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 
                                      'WAIV_DEV_REJ_NO', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
         unique_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                 contract_                   => contract_,
                                                                                 part_no_                    => part_no_,
                                                                                 configuration_id_           => configuration_id_,
                                                                                 location_no_                => location_no_,
                                                                                 lot_batch_no_               => lot_batch_no_,
                                                                                 serial_no_                  => serial_no_,
                                                                                 eng_chg_level_              => eng_chg_level_,
                                                                                 waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                 activity_seq_               => 0,
                                                                                 handling_unit_id_           => handling_unit_id_,
                                                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                 column_name_                => wanted_data_item_id_,
                                                                                 sql_where_expression_       => Get_Sql_Where_Expression___);
      END IF;
     IF (unique_value_ = 'NULL') THEN
         unique_value_ := NULL;
      END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;



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
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   configuration_id_            VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   eng_chg_level_               VARCHAR2(6);
   waiv_dev_rej_no_             VARCHAR2(15);
   barcode_id_                  NUMBER;
   dummy_contract_              VARCHAR2(5);
   company_                     VARCHAR2(20);
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   lov_type_db_                 VARCHAR2(20);
   input_uom_group_id_          VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_              := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
         Get_Filter_Keys___(dummy_contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_,
                            eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            gtin_no_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
      ELSE
         Get_Filter_Keys___(dummy_contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_,
                            eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 
                            gtin_no_, capture_session_id_, data_item_id_);
      END IF;

      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

      IF (data_item_id_ = 'SERIAL_NO' AND Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
          Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
         Temporary_Part_Tracking_API.Create_Data_Capture_Lov(contract_           => contract_, 
                                                             part_no_            => part_no_,
                                                             serial_no_          => NULL,
                                                             lot_batch_no_       => lot_batch_no_, 
                                                             configuration_id_   => configuration_id_, 
                                                             capture_session_id_ => capture_session_id_,
                                                             column_name_        => data_item_id_,
                                                             lov_type_db_        => lov_type_db_);
      ELSIF ((data_item_id_ = 'BARCODE_ID') OR 
          (barcode_id_ IS NOT NULL AND data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO'))) THEN
         Inventory_Part_Barcode_API.Create_Data_Capture_Lov(contract_           => contract_,
                                                            barcode_id_         => barcode_id_,
                                                            part_no_            => part_no_,
                                                            configuration_id_   => configuration_id_,
                                                            lot_batch_no_       => lot_batch_no_,
                                                            serial_no_          => serial_no_,
                                                            eng_chg_level_      => eng_chg_level_,
                                                            waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                            activity_seq_       => 0, -- Issue inventory part doesn't have support for project
                                                            capture_session_id_ => capture_session_id_, 
                                                            column_name_        => data_item_id_,
                                                            lov_type_db_        => lov_type_db_);
      ELSIF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO',
                               'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 
                               'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
         IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
             Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
            serial_no_  := '*';
         END IF;
         Inventory_Part_In_Stock_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                             part_no_                    => part_no_,
                                                             configuration_id_           => configuration_id_,
                                                             location_no_                => location_no_,
                                                             lot_batch_no_               => lot_batch_no_,
                                                             serial_no_                  => serial_no_,
                                                             eng_chg_level_              => eng_chg_level_,
                                                             waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                             activity_seq_               => 0,
                                                             handling_unit_id_           => handling_unit_id_,
                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                             capture_session_id_         => capture_session_id_,
                                                             column_name_                => data_item_id_,
                                                             lov_type_db_                => lov_type_db_,
                                                             sql_where_expression_       => Get_Sql_Where_Expression___);
   
      ELSIF (data_item_id_ IN ('CODE_A', 'CODE_B', 'CODE_C', 'CODE_D',
                               'CODE_E', 'CODE_F', 'CODE_G', 'CODE_H',
                               'CODE_I', 'CODE_J')) THEN
            
            company_ := Site_API.Get_Company(contract_);
            Accounting_Code_Part_Value_API.Create_Data_Capture_Lov(company_                    => company_,
                                                                   code_part_                  => SUBSTR(data_item_id_,6,1),
                                                                   capture_session_id_         => capture_session_id_,
                                                                   column_name_                => 'CODE_PART_VALUE',
                                                                   lov_type_db_                => lov_type_db_);           
                               
      ELSIF (data_item_id_ IN ('INPUT_UOM')) THEN              
         input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
         Input_Unit_Meas_API.Create_Data_Capture_Lov(capture_session_id_, input_uom_group_id_, 'UNIT_CODE', lov_type_db_, Get_Input_Uom_Sql_Whr_Exprs___); 
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
   contract_                     VARCHAR2(5);
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   waiv_dev_rej_no_              VARCHAR2(15);
   eng_chg_level_                VARCHAR2(6);
   configuration_id_             VARCHAR2(50);
   barcode_id_                   NUMBER;
   automatic_value_              VARCHAR2(200);
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   gtin_no_                      VARCHAR2(14);
   input_uom_                    VARCHAR2(30);
   input_uom_group_id_           VARCHAR2(30);
   input_qty_                    NUMBER;
   input_conv_factor_            NUMBER;
   control_type_                 VARCHAR2(10);
   company_                      VARCHAR2(20);
   dummy_                        BOOLEAN;
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
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
         IF (data_item_id_ IN ('CODE_A', 'CODE_B', 'CODE_C', 'CODE_D', 'CODE_E',
                               'CODE_F', 'CODE_G', 'CODE_H', 'CODE_I', 'CODE_J')) THEN

            company_ := Site_API.Get_Company(session_rec_.session_contract);
            control_type_ := Posting_Ctrl_API.Get_Control_Type_For_Date(company_, SUBSTR(data_item_id_,6,1), posting_type_, TRUNC(SYSDATE));

            IF control_type_ IS NULL THEN 
               automatic_value_ := 'NULL';
            ELSIF control_type_ = mandatory_control_type_ THEN 
               --If the code part is not mandatory we dont fetch the unique value.
               automatic_value_ := Accounting_Code_Part_Value_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                             company_                    => company_,
                                                                                             code_part_                  => SUBSTR(data_item_id_,6,1),
                                                                                             capture_session_id_         => capture_session_id_,
                                                                                             column_name_                => 'CODE_PART_VALUE');           
            END IF;
         ELSE 
            IF (data_item_id_ = 'BARCODE_ID') THEN
               -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
               Get_Filter_Keys___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_,  
                                  eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 
                                  gtin_no_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
            ELSE
               Get_Filter_Keys___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_,  
                                  eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 
                                  gtin_no_, capture_session_id_, data_item_id_);
            END IF;

            IF (data_item_id_ = 'BARCODE_ID') THEN
               automatic_value_ := barcode_id_;

            ELSIF (barcode_id_ IS NOT NULL AND  
                data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO')) THEN
               automatic_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => contract_,
                                                                                         barcode_id_       => barcode_id_,
                                                                                         part_no_          => part_no_,
                                                                                         configuration_id_ => configuration_id_,
                                                                                         lot_batch_no_     => lot_batch_no_,
                                                                                         serial_no_        => serial_no_,
                                                                                         eng_chg_level_    => eng_chg_level_,
                                                                                         waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                         activity_seq_     => 0, -- Issue inventory part doesn't have support for project
                                                                                         column_name_      => data_item_id_ );

               IF data_item_id_ = 'SERIAL_NO' AND Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND automatic_value_ = '*' THEN
                  automatic_value_ := NULL;
               END IF;
            ELSIF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO',
                                     'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 
                                     'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
               automatic_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                          contract_                   => contract_,
                                                                                          part_no_                    => part_no_,
                                                                                          configuration_id_           => configuration_id_,
                                                                                          location_no_                => location_no_,
                                                                                          lot_batch_no_               => lot_batch_no_,
                                                                                          serial_no_                  => serial_no_,
                                                                                          eng_chg_level_              => eng_chg_level_,
                                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                          activity_seq_               => 0, -- Issue inventory part doesn't have support for project
                                                                                          handling_unit_id_           => handling_unit_id_,
                                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,      
                                                                                          column_name_                => data_item_id_,
                                                                                          sql_where_expression_       => Get_Sql_Where_Expression___);

               IF automatic_value_ IS NULL AND data_item_id_ = 'LOCATION_NO' AND part_no_ IS NOT NULL THEN
                  automatic_value_ := Inventory_Part_Def_Loc_API.Get_Location_No(contract_, part_no_);
               END IF;


               IF data_item_id_ = 'SERIAL_NO' AND Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND automatic_value_ = '*' THEN
                  automatic_value_ := NULL;
               END IF;

            ELSIF (data_item_id_= 'QTY_TO_ISSUE') THEN
               input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                               data_item_id_a_     => 'INPUT_UOM',
                                                                               data_item_id_b_     => data_item_id_);

               input_qty_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                               data_item_id_a_     => 'INPUT_QUANTITY',
                                                                               data_item_id_b_     => data_item_id_);
               IF (input_uom_ IS NOT NULL) AND (input_qty_ IS NOT NULL) THEN
                  input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
                  input_conv_factor_  := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_id_, input_uom_);
                  automatic_value_    := input_qty_ * input_conv_factor_;
               ELSIF Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_SERIAL_TRACKING THEN
                  automatic_value_ := 1;
               END IF;
            ELSIF (data_item_id_ = 'CATCH_QTY_TO_ISSUE') THEN
               part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
               IF (part_catalog_rec_.catch_unit_enabled = Fnd_Boolean_API.DB_FALSE) THEN
                  automatic_value_ := 'NULL';
               ELSE
                  automatic_value_ := NULL;
               END IF;
            ELSIF (data_item_id_= 'INPUT_UOM') THEN         
               input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
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
                  input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                  data_item_id_a_     => 'INPUT_UOM',
                                                                                  data_item_id_b_     => data_item_id_);                                                                         
                  IF ((input_uom_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'INPUT_UOM', 'INPUT_QUANTITY'))
                     OR (Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_) IS NULL) THEN            
                     automatic_value_ := 'NULL';                     
                  END IF; 
               ELSIF (data_item_id_= 'GTIN') THEN       
                  automatic_value_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_); 
                  IF (part_no_ IS NOT NULL AND automatic_value_ IS NULL) THEN            
                     automatic_value_ := 'NULL';                     
                  END IF;
            ELSE
               automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, session_rec_.session_contract, part_no_);
            END IF;
         END IF;
      END IF;
      RETURN automatic_value_;
   $ELSE
      RETURN NULL;
   $END
  
END Get_Automatic_Data_Item_Value;


@UncheckedAccess
FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   contract_                    VARCHAR2(5);
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   barcode_id_                  NUMBER;
   handling_unit_id_            NUMBER;
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   gtin_no_                     VARCHAR2(14);
   temp_data_item_id_           VARCHAR2(50);
   company_                     VARCHAR2(20);
   control_type_                VARCHAR2(10);
   return_value_                BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
   
      -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
      --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
      IF (data_item_id_ in ('CODE_A', 'CODE_B', 'CODE_C', 'CODE_D', 'CODE_E', 'CODE_F', 'CODE_G', 'CODE_H', 'CODE_I', 'CODE_J')) THEN 
         company_ := Site_API.Get_Company(session_rec_.session_contract);
         control_type_ := Posting_Ctrl_API.Get_Control_Type_For_Date(company_, SUBSTR(data_item_id_,6,1), posting_type_, TRUNC(SYSDATE));
         IF control_type_ IS NULL THEN 
               return_value_ := TRUE;
         END IF;
      ELSE
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

         part_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
         -- if predicted part_no_ is null then try fetch it with unique handling
         IF (part_no_ IS NULL) THEN
            Get_Filter_Keys___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_,  
                               eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 
                               gtin_no_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);
            part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
         END IF;
         IF (data_item_id_ = 'QTY_TO_ISSUE') THEN 
            temp_data_item_id_ := 'QUANTITY';
            IF (serial_no_ IS NULL) THEN
               serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
            END IF;
         ELSE 
            temp_data_item_id_ := data_item_id_;
         END IF; 
         return_value_ := Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, temp_data_item_id_, part_no_, serial_no_);
      END IF;
   $END
      
   RETURN return_value_;
END Fixed_Value_Is_Applicable;


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MATRREQUISLINEOK: The Inventory Part was Issued.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MATRREQUISLINES: :P1 Inventory Parts were Issued.',NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY CLOB,
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2 )
IS
   ptr_                       NUMBER;
   name_                      VARCHAR2(50);
   value_                     VARCHAR2(4000);
   part_no_                   VARCHAR2(25);
   location_no_               VARCHAR2(35);
   serial_no_                 VARCHAR2(50);
   configuration_id_          VARCHAR2(50);
   lot_batch_no_              VARCHAR2(20);
   eng_chg_level_             VARCHAR2(6);
   waiv_dev_rej_no_           VARCHAR2(15);
   code_a_                    VARCHAR2(20);
   code_b_                    VARCHAR2(20);
   code_c_                    VARCHAR2(20);
   code_d_                    VARCHAR2(20);
   code_e_                    VARCHAR2(20);
   code_f_                    VARCHAR2(20);
   code_g_                    VARCHAR2(20);
   code_h_                    VARCHAR2(20);
   code_i_                    VARCHAR2(20);
   code_j_                    VARCHAR2(20);
   note_                     VARCHAR2(4000);
   qty_to_issue_              NUMBER;
   catch_qty_to_issue_        NUMBER;
   handling_unit_id_          NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_;
      ELSIF (name_ = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_;
      ELSIF (name_ = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_;
      ELSIF (name_ = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         serial_no_ := value_;
      ELSIF (name_ = 'QTY_TO_ISSUE') THEN
         qty_to_issue_ := value_;
      ELSIF (name_ = 'CATCH_QTY_TO_ISSUE') THEN
         catch_qty_to_issue_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_;
      ELSIF (name_ = 'NOTE') THEN
         note_ := value_;
      ELSIF (name_ = 'CODE_A') THEN
         code_a_ := value_;
      ELSIF (name_ = 'CODE_B') THEN
         code_b_ := value_;
      ELSIF (name_ = 'CODE_C') THEN
         code_c_ := value_;
      ELSIF (name_ = 'CODE_D') THEN
         code_d_ := value_;
      ELSIF (name_ = 'CODE_E') THEN
         code_e_ := value_;
      ELSIF (name_ = 'CODE_F') THEN
         code_f_ := value_;
      ELSIF (name_ = 'CODE_G') THEN
         code_g_ := value_;
      ELSIF (name_ = 'CODE_H') THEN
         code_h_ := value_;
      ELSIF (name_ = 'CODE_I') THEN
         code_i_ := value_;
      ELSIF (name_ = 'CODE_J') THEN
         code_j_ := value_;
      END IF;
   END LOOP;

   Inventory_Part_In_Stock_API.Issue_Part_With_Posting(contract_                     => contract_,            
                                                       part_no_                      => part_no_,             
                                                       configuration_id_             => configuration_id_,    
                                                       location_no_                  => location_no_,         
                                                       lot_batch_no_                 => lot_batch_no_,        
                                                       serial_no_                    => serial_no_,           
                                                       eng_chg_level_                => eng_chg_level_,       
                                                       waiv_dev_rej_no_              => waiv_dev_rej_no_,     
                                                       activity_seq_                 => 0, -- Issue inventory part doesn't have support for project
                                                       handling_unit_id_             => handling_unit_id_,    
                                                       transaction_                  => 'NISS',
                                                       quantity_                     => qty_to_issue_,
                                                       catch_quantity_               => catch_qty_to_issue_,
                                                       account_no_                   => code_a_,  
                                                       code_b_                       => code_b_,  
                                                       code_c_                       => code_c_,  
                                                       code_d_                       => code_d_,  
                                                       code_e_                       => code_e_,
                                                       code_f_                       => code_f_, 
                                                       code_g_                       => code_g_,  
                                                       code_h_                       => code_h_,  
                                                       code_i_                       => code_i_,  
                                                       code_j_                       => code_j_, 
                                                       source_                       => note_,
                                                       part_tracking_session_id_     => NULL,
                                                       discon_zero_stock_handl_unit_ => FALSE);

END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Inventory_Part_In_Stock_API.Issue_Part_With_Posting is granted thru following projections/entity actions
   IF (Security_SYS.Is_Proj_Entity_Act_Available('IssueInventoryPart', 'InventoryPartInStock', 'IssueInventoryPart')) THEN   
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_        Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                    VARCHAR2(5);
   company_                     VARCHAR2(100);
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   condition_code_              VARCHAR2(10);
   barcode_id_                  NUMBER;
   handling_unit_id_            NUMBER; 
   code_part_value_             VARCHAR2(20);
   code_part_                   VARCHAR2(1);
   code_part_name_              VARCHAR2(6);
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   gtin_no_                     VARCHAR2(14);
   process_package_             VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_      := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                         eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                         capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL',
                                                                    'WAIV_DEV_REJ_NO', 'BARCODE_ID', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN

                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           part_no_                    => part_no_,
                                           location_no_                => location_no_,
                                           serial_no_                  => serial_no_,
                                           lot_batch_no_               => lot_batch_no_,
                                           waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                           eng_chg_level_              => eng_chg_level_,
                                           configuration_id_           => configuration_id_,
                                           handling_unit_id_           => handling_unit_id_,
                                           sscc_                       => sscc_,  
                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                           barcode_id_                 => barcode_id_,
                                           gtin_no_                    => gtin_no_);
               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_         => capture_session_id_,
                                                 session_rec_                => session_rec_,
                                                 owning_data_item_id_        => latest_data_item_id_,
                                                 owning_data_item_value_     => latest_data_item_value_,
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id);
               END IF;
            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID', 
                                                                    'LOCATION_GROUP', 'LOCATION_TYPE', 'LOCATION_NO_DESC')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 
                                                                       'NET_WEIGHT', 'NET_VOLUME', 'PART_TYPE', 'PRIME_COMMODITY', 'UNIT_MEAS_DESCRIPTION',
                                                                       'PRIME_COMMODITY_DESCRIPTION', 'SECOND_COMMODITY', 'SECOND_COMMODITY_DESCRIPTION', 
                                                                       'ASSET_CLASS', 'ASSET_CLASS_DESCRIPTION', 'PART_STATUS', 'PART_STATUS_DESCRIPTION', 
                                                                       'ABC_CLASS', 'ABC_CLASS_PERCENT', 'SAFETY_CODE', 'SAFETY_CODE_DESCRIPTION', 
                                                                       'ACCOUNTING_GROUP', 'ACCOUNTING_GROUP_DESCRIPTION', 'PRODUCT_CODE', 'PRODUCT_CODE_DESCRIPTION', 
                                                                       'PRODUCT_FAMILY', 'PRODUCT_FAMILY_DESCRIPTION', 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                                                       'SERIAL_TRACKING_INVENTORY', 'SERIAL_TRACKING_DELIVERY', 
                                                                       'SERIAL_RULE', 'LOT_BATCH_TRACKING', 'LOT_QUANTITY_RULE', 'SUB_LOT_RULE',
                                                                       'COMPONENT_LOT_RULE', 'GTIN_IDENTIFICATION', 'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       contract_             => contract_,
                                                                       part_no_              => part_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY_ONHAND', 'CATCH_QUANTITY_ONHAND', 'OWNERSHIP', 'OWNER', 
                                                                       'EXPIRATION_DATE', 'AVAILABILTY_CONTROL_ID', 'QUANTITY_AVAILABLE')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Inv_Stock_Rec(capture_session_id_  => capture_session_id_,
                                                                             owning_data_item_id_ => latest_data_item_id_,
                                                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             contract_            => contract_,
                                                                             part_no_             => part_no_,
                                                                             configuration_id_    => configuration_id_,
                                                                             location_no_         => location_no_,
                                                                             lot_batch_no_        => lot_batch_no_,
                                                                             serial_no_           => serial_no_,
                                                                             eng_chg_level_       => eng_chg_level_,
                                                                             waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                                                             activity_seq_        => 0, -- Issue inventory part doesn't have support for project
                                                                             handling_unit_id_    => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE', 'CONDITION_CODE_DESCRIPTION')) THEN
                  IF part_no_ IS NOT NULL THEN 
                     condition_code_ := Condition_code_manager_API.Get_Condition_Code (part_no_,serial_no_,lot_batch_no_);
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
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('HANDLING_UNIT_TYPE_ID', 'HANDLING_UNIT_TYPE_DESC', 'HANDLING_UNIT_TYPE_CATEG_ID', 
                                                                       'HANDLING_UNIT_TYPE_CATEG_DESC', 'TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN
                  -- Feedback items related to handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARENT_HANDLING_UNIT_ID', 'HANDLING_UNIT_COMPOSITION', 'TOP_PARENT_HANDLING_UNIT_ID',
                                                                       'TOP_PARENT_SSCC', 'TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                       'LEVEL_2_HANDLING_UNIT_ID', 'LEVEL_2_SSCC', 'LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  -- Feedback items related to handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => handling_unit_id_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CODE_A_DESC', 'CODE_B_DESC', 'CODE_C_DESC', 'CODE_D_DESC', 'CODE_E_DESC', 'CODE_F_DESC', 
                                                                       'CODE_G_DESC', 'CODE_H_DESC', 'CODE_I_DESC', 'CODE_J_DESC')) THEN
                  process_package_  := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
                  company_          := Site_API.Get_Company(session_rec_.session_contract);                                                                             
                  code_part_        := SUBSTR(conf_item_detail_tab_(i).data_item_detail_id,6,1);
                  code_part_name_   := SUBSTR(conf_item_detail_tab_(i).data_item_detail_id,1,6);
                  code_part_value_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, latest_data_item_id_, latest_data_item_value_, code_part_name_, session_rec_ , process_package_);
                  Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                    data_item_id_        => latest_data_item_id_,
                                                    data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                    data_item_value_     => Accounting_Code_Part_Value_API.Get_Desc_For_Code_Part(company_, code_part_, code_part_value_));
               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END


END Add_Details_For_Latest_Item;


PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   contract_                    VARCHAR2(5);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   local_serial_no_             VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   catch_qty_to_issue_          NUMBER;
   qty_to_issue_                NUMBER;
   barcode_id_                  NUMBER;
   process_package_             VARCHAR2(30);
   data_item_description_       VARCHAR2(200);
   column_value_nullable_       BOOLEAN := FALSE;
   input_unit_meas_group_id_    VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
   control_type_                VARCHAR2(10);
   company_                      VARCHAR2(20);
   receipt_issue_serial_        PART_CATALOG_TAB.receipt_issue_serial_track%TYPE;
   serial_tracking_             PART_CATALOG_TAB.serial_tracking_code%TYPE;
   inv_rec_                     Inventory_Part_In_Stock_API.Public_Rec;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('QTY_TO_ISSUE', 'INPUT_QUANTITY')) THEN
         IF (data_item_value_ <= 0) THEN
            Error_SYS.Record_General(lu_name_, 'NEGATIVEORZEROQTY: Zero or Negative Quantity is not allowed.');
         END IF;
      END IF;
      Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                      data_item_id_,
                                                      data_item_value_);
      session_rec_              := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_          := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- Note: No need to get values for process keys when barcode_id is null because probably it would not be used in this process.
         IF (data_item_value_ IS NOT NULL) THEN 
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_,
                               eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                               gtin_no_, capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE);
         END IF;         
      ELSE
         Get_Filter_Keys___(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_,
                            eng_chg_level_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, 
                            gtin_no_, capture_session_id_, data_item_id_, data_item_value_);
      END IF;
      receipt_issue_serial_ := Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_);
      serial_tracking_      := Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_);
      
      -- If part is serial track in receipt and issue not in inventory and serial no has been scanned already with new serial, it should be changed to its original value *
      local_serial_no_ := serial_no_;
      IF ((receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE) AND 
          (serial_tracking_ = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) AND 
          (local_serial_no_ IS NOT NULL)) THEN
         local_serial_no_ := '*';
      END IF;
      
      IF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 
                            'WAIV_DEV_REJ_NO', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID'))
          OR ((data_item_id_ = 'SERIAL_NO') AND (receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE) AND 
              (serial_tracking_ = Part_Serial_Tracking_API.DB_SERIAL_TRACKING)) THEN
   
         data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
         IF (barcode_id_ IS NOT NULL AND 
             data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ')) THEN
            -- BARCODE_ID is used for these items, then validate them against the barcode table
            
            Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_           => contract_,
                                                                      barcode_id_         => barcode_id_,
                                                                      part_no_            => part_no_,
                                                                      configuration_id_   => configuration_id_,
                                                                      lot_batch_no_       => lot_batch_no_,
                                                                      serial_no_          => local_serial_no_,
                                                                      eng_chg_level_      => eng_chg_level_,
                                                                      waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                      activity_seq_       => 0, -- Issue inventory part doesn't have support for project
                                                                      column_name_        => data_item_id_,
                                                                      column_value_       => data_item_value_,
                                                                      column_description_ => data_item_description_);
         ELSE
            IF (data_item_id_ IN ('SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ = 'HANDLING_UNIT_ID' AND data_item_value_ > 0) THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
          --  Inventory_Part_In_Stock_API.Check_Qty_Onhand_Exist(part_no_, contract_, configuration_id_);
            Inventory_Part_In_Stock_API.Record_With_Column_Value_Exist(contract_                   => contract_,
                                                                       part_no_                    => part_no_,
                                                                       configuration_id_           => configuration_id_, 
                                                                       location_no_                => location_no_,
                                                                       lot_batch_no_               => lot_batch_no_,
                                                                       serial_no_                  => local_serial_no_,
                                                                       eng_chg_level_              => eng_chg_level_,
                                                                       waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                       activity_seq_               => 0, -- Issue inventory part doesn't have support for project
                                                                       handling_unit_id_           => handling_unit_id_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       column_name_                => data_item_id_,
                                                                       column_value_               => data_item_value_,
                                                                       column_description_         => data_item_description_,
                                                                       sql_where_expression_       => Get_Sql_Where_Expression___,
                                                                       column_value_nullable_      => column_value_nullable_);
         END IF;
      ELSIF (data_item_id_ = 'BARCODE_ID') THEN         
         IF (data_item_value_ IS NOT NULL) THEN
            Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_           => contract_,
                                                                      barcode_id_         => data_item_value_,
                                                                      part_no_            => part_no_,
                                                                      configuration_id_   => configuration_id_,
                                                                      lot_batch_no_       => lot_batch_no_,
                                                                      serial_no_          => local_serial_no_,
                                                                      eng_chg_level_      => eng_chg_level_,
                                                                      waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                      activity_seq_       => 0, -- Issue inventory part doesn't have support for project
                                                                      column_name_        => data_item_id_,
                                                                      column_value_       => data_item_value_,
                                                                      column_description_ => data_item_description_);
         END IF;        
      ELSIF (data_item_id_ = 'QTY_TO_ISSUE') THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
         IF (data_item_value_ <= 0) THEN
            Error_SYS.Record_General(lu_name_, 'QTYTOISSUEERROR: Quantity To Issue is not allowed to be zero or negative.');
         END IF;
      ELSIF (data_item_id_ = 'INPUT_UOM') THEN            
         IF (data_item_value_ IS NOT NULL) THEN      
            input_unit_meas_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
            Input_Unit_Meas_API.Record_With_Column_Value_Exist(input_unit_meas_group_id_ => input_unit_meas_group_id_,
                                                               column_name_              => 'UNIT_CODE',
                                                               column_value_             => data_item_value_,
                                                               column_description_       => data_item_description_,
                                                               sql_where_expression_     => Get_Input_Uom_Sql_Whr_Exprs___);
         END IF;
      ELSIF (data_item_id_ = 'SERIAL_NO') THEN
         IF (receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE) THEN 
            IF (serial_tracking_ = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
               Part_Serial_Catalog_API.Exist(part_no_, data_item_value_);
               -- NOTE: serial_no_ is the value on the picking record. data_item_value_ is the serial entered in the data collection process.
               IF (Inventory_Part_In_Stock_API.Check_Individual_Exist(part_no_, data_item_value_) = 1 AND serial_no_ = '*') THEN
                  Error_SYS.Record_General(lu_name_, 'SPLITSERINV: Serial :P1 for part :P2 already exists on a specific stock or transit record.', data_item_value_, part_no_);
               END IF;
            END IF;
         ELSE
            Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
         END IF;
      ELSIF (data_item_id_ IN ('CODE_A', 'CODE_B', 'CODE_C', 'CODE_D', 'CODE_E',
                               'CODE_F', 'CODE_G', 'CODE_H', 'CODE_I', 'CODE_J')) THEN

         company_ := Site_API.Get_Company(session_rec_.session_contract);
         control_type_ := Posting_Ctrl_API.Get_Control_Type_For_Date(company_, SUBSTR(data_item_id_,6,1), posting_type_, TRUNC(SYSDATE));
         data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_, capture_session_id_);
         IF data_item_value_ IS NOT NULL THEN 
            IF control_type_ IS NULL THEN 
               Error_SYS.Record_General(lu_name_, 'CODEPARTNOTEXIST: :P1 should be null.', data_item_description_);
            ELSIF NOT Accounting_Code_Part_Value_API.Validate_Code_Part(company_, SUBSTR(data_item_id_,6,1), data_item_value_, SYSDATE, 'TRUE') THEN 
               Error_SYS.Record_General(lu_name_, 'CODEVALUENOTEXIST: :P1 :P2 does not exist or has an invalid time interval.', data_item_description_, data_item_value_);
            END IF;
         ELSIF control_type_ = mandatory_control_type_ THEN 
            Error_SYS.Record_General(lu_name_, 'CODEPARTNOTNULL: :P1 is mandatory and requires a value.', data_item_description_);
         END IF;
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      END IF;
   
      IF (data_item_id_ IN ('PART_NO','CATCH_QTY_TO_ISSUE')) THEN
            catch_qty_to_issue_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_TO_ISSUE', session_rec_ , process_package_);
            Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                         current_data_item_id_      => data_item_id_,
                                                         part_no_data_item_id_      => 'PART_NO',
                                                         part_no_data_item_value_   => part_no_,
                                                         catch_qty_data_item_id_    => 'CATCH_QTY_TO_ISSUE',
                                                         catch_qty_data_item_value_ => catch_qty_to_issue_,
                                                         positive_catch_qty_        => TRUE);  -- Since this process dont allow normal quantity to be zero or lower it shouldnt allow it for catch quantity either
      END IF;

      IF (data_item_id_ IN ('PART_NO','QTY_TO_ISSUE')) THEN
         IF (data_item_id_ = 'QTY_TO_ISSUE') THEN
            qty_to_issue_ := data_item_value_;
         ELSIF (data_item_id_ = 'PART_NO') THEN
            qty_to_issue_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                               data_item_id_a_     => 'QTY_TO_ISSUE',
                                                                               data_item_id_b_     => data_item_id_);
         END IF;
         IF ((qty_to_issue_ IS NOT NULL AND part_no_ IS NOT NULL) AND 
            receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE AND qty_to_issue_ NOT IN (1)) THEN
            Error_SYS.Record_General(lu_name_,'SERIALPARTQTYWRONG: A serial handled Part can only have Quantity value of 1.');
         END IF;

         IF part_no_ IS NOT NULL AND configuration_id_ IS NOT NULL AND location_no_  IS NOT NULL AND lot_batch_no_  IS NOT NULL AND local_serial_no_  IS NOT NULL AND eng_chg_level_  IS NOT NULL AND waiv_dev_rej_no_  IS NOT NULL AND handling_unit_id_ IS NOT NULL THEN 
            inv_rec_ := Inventory_Part_In_Stock_API.Get(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, local_serial_no_, eng_chg_level_, waiv_dev_rej_no_, 0, handling_unit_id_);
            -- Quantity to issue is validated against Quantity available (qty_onhand - qty_reserved).
            IF (qty_to_issue_ > (inv_rec_.qty_onhand - inv_rec_.qty_reserved)) THEN
               Error_SYS.Record_General(lu_name_, 'ISSUEMORETHENQTYLEFT: Quantity to issue Cannot be more than the quantity available.');
            END IF;
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item;


@UncheckedAccess
FUNCTION Get_Data_Item_Description (
   data_item_id_       IN VARCHAR2,
   capture_session_id_ IN NUMBER ) RETURN VARCHAR2
IS
   description_ VARCHAR2(2000);
   contract_    VARCHAR2(5);
   company_     VARCHAR2(20);
   code_part_   VARCHAR2(1);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF data_item_id_ IN ('CODE_A', 'CODE_B', 'CODE_C', 'CODE_D', 'CODE_E', 'CODE_F', 'CODE_G', 'CODE_H', 'CODE_I', 'CODE_J') THEN
         code_part_   := substr(data_item_id_, 6, 1);
         contract_    := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_);
         company_     := Site_API.Get_Company(contract_);
         description_ := Accounting_Code_Parts_API.Get_Code_Name(company_, code_part_);
      END IF;
   $ELSE
      NULL;
   $END
   RETURN description_;
END Get_Data_Item_Description;


@UncheckedAccess
FUNCTION Get_Feedback_Item_Description (
   feedback_item_id_   IN VARCHAR2,
   capture_session_id_ IN NUMBER ) RETURN VARCHAR2
IS
   description_  VARCHAR2(2000);
   data_item_id_ VARCHAR2(30);   
BEGIN
   IF feedback_item_id_ IN ('CODE_A_DESC', 'CODE_B_DESC', 'CODE_C_DESC', 'CODE_D_DESC', 'CODE_E_DESC', 'CODE_F_DESC', 'CODE_G_DESC', 'CODE_H_DESC', 'CODE_I_DESC', 'CODE_J_DESC') THEN
      data_item_id_ := substr(feedback_item_id_, 1, 6);
      description_  := Get_Data_Item_Description(data_item_id_, capture_session_id_)||' '||Language_SYS.Translate_Constant(lu_name_,'DESCRIPTION: Description');
   END IF; 
   RETURN (description_);
END Get_Feedback_Item_Description;

