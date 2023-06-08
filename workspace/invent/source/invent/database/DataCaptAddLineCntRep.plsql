-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptAddLineCntRep
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: ADD_LINE_TO_COUNT_REPORT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220104  DaZase  SC21R2-2952, Created
----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_                    CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   condition_code_             IN VARCHAR2,
   activity_seq_               IN NUMBER,
   barcode_id_                 IN NUMBER,
   wanted_data_item_id_        IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   sql_where_expression_  VARCHAR2(2000) DEFAULT NULL;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF condition_code_ IS NOT NULL AND condition_code_ != 'NULL' THEN 
         sql_where_expression_ := ' NVL(Condition_Code_Manager_API.Get_Condition_Code(part_no,serial_no,lot_batch_no ) , ''' || string_null_ || ''')=''' || condition_code_ || '''';
      END IF;
      
      IF (wanted_data_item_id_ = 'BARCODE_ID' OR (barcode_id_ IS NOT NULL AND barcode_id_ != '0' AND 
          wanted_data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ'))) THEN
         unique_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_             => contract_,
                                                                                barcode_id_           => barcode_id_,
                                                                                part_no_              => part_no_,
                                                                                configuration_id_     => configuration_id_,
                                                                                lot_batch_no_         => lot_batch_no_,
                                                                                serial_no_            => serial_no_,
                                                                                eng_chg_level_        => eng_chg_level_,
                                                                                waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                                activity_seq_         => activity_seq_,
                                                                                column_name_          => wanted_data_item_id_,
                                                                                sql_where_expression_ => sql_where_expression_);

      END IF;
      IF (unique_value_ = 'NULL') THEN
         unique_value_ := NULL;
      END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   contract_                   OUT VARCHAR2,
   inv_list_no_                OUT VARCHAR2,
   part_no_                    OUT VARCHAR2,
   location_no_                OUT VARCHAR2,
   serial_no_                  OUT VARCHAR2,
   lot_batch_no_               OUT VARCHAR2,
   waiv_dev_rej_no_            OUT VARCHAR2,
   eng_chg_level_              OUT VARCHAR2,
   configuration_id_           OUT VARCHAR2,
   activity_seq_               OUT NUMBER,
   barcode_id_                 OUT NUMBER,
   handling_unit_id_           OUT NUMBER,
   sscc_                       OUT VARCHAR2,  
   alt_handling_unit_label_id_ OUT VARCHAR2, 
   --gtin_no_                    OUT VARCHAR2,
   capture_session_id_         IN  NUMBER,
   data_item_id_               IN  VARCHAR2,
   data_item_value_            IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_          IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_             IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   process_package_       VARCHAR2(30);
   condition_code_        VARCHAR2(10);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_         := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      part_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      configuration_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      activity_seq_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
      location_no_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      inv_list_no_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'INV_LIST_NO', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_             := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      --gtin_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);
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
      IF (sscc_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
         sscc_ := '%';
      END IF;

      --IF (gtin_no_ IS NULL AND Data_Capture_Invent_Util_API.Gtin_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
      --   gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      --END IF;
      
      --IF ((part_no_ IS NULL) AND (gtin_no_ IS NOT NULL)) THEN
      --   part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_); 
      --END IF;

      IF use_unique_values_ THEN
         condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                              data_item_id_a_      => 'CONDITION_CODE',
                                                                              data_item_id_b_      => data_item_id_);
      
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, barcode_id_, 'PART_NO');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_,condition_code_,  activity_seq_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, barcode_id_, 'ACTIVITY_SEQ');
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, barcode_id_, 'BARCODE_ID');
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
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER )
IS
   detail_value_             VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      CASE (data_item_detail_id_)
         WHEN ('INV_LIST_NO') THEN
            detail_value_ := inv_list_no_;
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
         WHEN ('ACTIVITY_SEQ') THEN
            detail_value_ := activity_seq_;
         WHEN ('HANDLING_UNIT_ID') THEN
            detail_value_ := handling_unit_id_;
         WHEN ('SSCC') THEN
            detail_value_ := sscc_;
         WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := alt_handling_unit_label_id_;
         WHEN ('BARCODE_ID') THEN
            detail_value_ := barcode_id_;
--         WHEN ('GTIN') THEN
---            detail_value_ := gtin_no_;
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


FUNCTION Get_Hu_Sql_Where_Expression___ (
   contract_     IN VARCHAR2,
   location_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(2000);
BEGIN
   -- this one is on the lov view that is used from the client for hu LOV, while sscc and alt label i client uses lov9 view, that dont have user allowed check, but I guess its ok to have it for all hu LOV values in this case
   sql_where_expression_  := ' AND contract IS NULL OR EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE contract = site) ';
   IF (location_no_ IS NOT NULL) THEN
      -- borrowed this one from the client SetLovWhereForHandlingUnit function
      sql_where_expression_  := sql_where_expression_ || ' AND (LOCATION_NO IS NULL OR (LOCATION_NO = '''||location_no_||''' AND CONTRACT = '''||contract_||''')) AND SHIPMENT_ID IS NULL ';
   ELSE
      sql_where_expression_  := sql_where_expression_ || ' AND SHIPMENT_ID IS NULL ';
   END IF;
   RETURN sql_where_expression_;
END Get_Hu_Sql_Where_Expression___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   inv_list_no_                VARCHAR2(15);
   part_no_                    VARCHAR2(25);
   contract_                   VARCHAR2(5);
   location_no_                VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   configuration_id_           VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   eng_chg_level_              VARCHAR2(6);
   waiv_dev_rej_no_            VARCHAR2(15);
   activity_seq_               NUMBER;
   data_item_description_      VARCHAR2(200);
   barcode_id_                 NUMBER;
   --gtin_no_                    VARCHAR2(14);
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   process_package_            VARCHAR2(30);
   part_catalog_rec_           Part_Catalog_API.Public_Rec;
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('LOT_BATCH_NO', 'SERIAL_NO')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
      END IF;


      -- PART_NO, CONDITION_CODE, CONFIGURATION_ID, LOCATION_NO, BARCODE_ID is validated by below Data_Capture_Invent_Util_API.Validate_Data_Item call
      IF (data_item_id_ NOT IN ('LOT_BATCH_NO', 'SERIAL_NO')) THEN   -- no lot_batch_no nor serial_no validation since it could be a new lot_batch_no or serial_no here
         Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                         data_item_id_,
                                                         data_item_value_);
      -- maybe a need a more proper LOCATION_NO validation to only allow the ones for the LOV location group? check with janath maybe
      END IF;

      -- Revision check
      IF (data_item_id_ IN ('PART_NO','ENG_CHG_LEVEL')) THEN
         Get_Filter_Keys___(contract_, inv_list_no_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            capture_session_id_, data_item_id_, data_item_value_);
         IF (part_no_ IS NOT NULL AND eng_chg_level_ IS NOT NULL)  THEN
            Inventory_Part_Revision_API.Exist(contract_, part_no_, eng_chg_level_);
         END IF;
      END IF;
      IF (data_item_id_ = 'ACTIVITY_SEQ' AND data_item_value_ IS NOT NULL AND data_item_value_ != 0) THEN 
         $IF Component_Proj_SYS.INSTALLED $THEN
            Activity_API.Exist(data_item_value_);
         $ELSE
            NULL;
         $END
      END IF;
      IF (data_item_id_ = 'INV_LIST_NO') THEN         
         Counting_Report_API.Exist(data_item_value_);
      END IF;

      IF (data_item_id_ = 'BARCODE_ID') THEN         
         IF (data_item_value_ IS NOT NULL) THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, inv_list_no_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                               eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                               capture_session_id_, data_item_id_, data_item_value_);
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_           => contract_,
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
         END IF;
      END IF;    

      IF (data_item_id_ IN ('LOT_BATCH_NO', 'SERIAL_NO')) THEN
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
         part_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_);
         part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
         IF (data_item_id_  = 'LOT_BATCH_NO' AND part_catalog_rec_.lot_tracking_code != Part_Lot_Tracking_API.db_not_lot_tracking AND data_item_value_ = '*') THEN
            Error_SYS.Record_General(lu_name_, 'LOTTRACKEDMUSTNOTBESTAR: This Part is using Lot Tracking so Lot Batch No cannot be :P1.', data_item_value_);
         ELSIF (data_item_id_  = 'LOT_BATCH_NO' AND part_catalog_rec_.lot_tracking_code = Part_Lot_Tracking_API.db_not_lot_tracking AND data_item_value_ != '*') THEN
            Error_SYS.Record_General(lu_name_, 'NOTLOTTRACKEDMUSTBESTAR: This Part is not using Lot Tracking so Lot Batch No must be :P1.', '*');
         ELSIF (data_item_id_  = 'SERIAL_NO' AND part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_serial_tracking AND data_item_value_ = '*') THEN
            Error_SYS.Record_General(lu_name_, 'SERIALTRACKEDMUSTNOTBESTAR: This Part is Serial Tracked so Serial No cannot be :P1.', data_item_value_);
         ELSIF (data_item_id_  = 'SERIAL_NO' AND Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_) AND data_item_value_ != '*') THEN
            Error_SYS.Record_General(lu_name_, 'SERIALTRACKEDRAIMUSTBESTAR: This Part is Serial Tracked at receipt and issue only so Serial No must be :P1.', '*');
         ELSIF (data_item_id_  = 'SERIAL_NO' AND part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_FALSE AND data_item_value_ != '*') THEN
            Error_SYS.Record_General(lu_name_, 'SERIALTRACKEDMUSTBESTAR: This Part is not Serial Tracked so Serial No must be :P1.', '*');
         END IF;

      END IF;

      IF (data_item_id_ IN ('HANDLING_UNIT_ID','SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         Get_Filter_Keys___(contract_, inv_list_no_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            capture_session_id_, data_item_id_, data_item_value_);
         alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
         sscc_ := CASE sscc_ WHEN '%' THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
         IF (handling_unit_id_ IS NOT NULL AND handling_unit_id_ != 0) THEN
            Handling_Unit_API.Exist(handling_unit_id_);
         END IF;
         IF (data_item_id_ = 'SSCC' AND data_item_value_ IS NOT NULL)  THEN
            Handling_Unit_API.Validate_Sscc(sscc_ => data_item_value_, check_sscc_exist_ => FALSE);
         END IF;
         IF (data_item_id_ = 'HANDLING_UNIT_ID' AND 
             Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
            IF (NVL(sscc_, string_null_) != NVL(Handling_Unit_API.Get_Sscc(data_item_value_), string_null_)) THEN
               Error_SYS.Record_General(lu_name_, 'HUDONTMATCHSSCC: The Handling Unit ID :P1 does not match previously entered SSCC :P2.', data_item_value_, sscc_);
            END IF;
         ELSIF (data_item_id_ = 'SSCC'  AND 
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) THEN
             IF (data_item_value_ IS NOT NULL)  THEN
                IF (handling_unit_id_ != NVL(Handling_Unit_API.Get_Handling_Unit_From_Sscc(data_item_value_),0)) THEN
                   Error_SYS.Record_General(lu_name_, 'SSCCDONTMATCHHU: The SSCC :P1 does not match previously entered Handling Unit ID :P2', data_item_value_, handling_unit_id_);
                END IF;
             ELSE -- SSCC scanned/entered as NULL
                IF (Handling_Unit_API.Get_Sscc(handling_unit_id_) IS NOT NULL) THEN
                   Error_SYS.Record_General(lu_name_, 'EMPTYSSCCDONTMATCHHU: The SSCC for previously entered Handling Unit ID :P1 must be :P2', handling_unit_id_, Handling_Unit_API.Get_Sscc(handling_unit_id_));
                END IF;
             END IF;
         ELSIF (data_item_id_ = 'HANDLING_UNIT_ID' AND 
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
            IF (NVL(alt_handling_unit_label_id_, string_null_) != NVL(Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(data_item_value_), string_null_)) THEN
               Error_SYS.Record_General(lu_name_, 'HUDONTMATCHALTHU: The Handling Unit ID :P1 does not match previously entered Alt Handling Unit Label ID :P2', data_item_value_, alt_handling_unit_label_id_);
            END IF;
         ELSIF (data_item_id_ = 'ALT_HANDLING_UNIT_LABEL_ID' AND 
             Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_)) THEN
            -- If previously entered handling unit id's alt_handling_unit_label_id_ dont match entered alt_handling_unit_label_id_ give error,
            -- this is not exactly the same check as the similar SSCC check since a alt_handling_unit_label_id_ actually can be connected to several handling units 
            IF (NVL(Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(handling_unit_id_), string_null_) != NVL(data_item_value_, string_null_)) THEN
               Error_SYS.Record_General(lu_name_, 'ALTHUDONTMATCHHU: The Alt Handling Unit Label ID :P1 does not match previously entered Handling Unit ID :P2', data_item_value_, handling_unit_id_);
            END IF;
         ELSIF (data_item_id_ = 'ALT_HANDLING_UNIT_LABEL_ID' AND 
             Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SSCC', data_item_id_)) THEN
             IF (NVL(data_item_value_, string_null_) != NVL(Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_)), string_null_)) THEN
                Error_SYS.Record_General(lu_name_, 'EMPTYSSCCDONTMATCHALTHU: The Alt Handling Unit Label ID for previously entered SSCC :P1 must be :P2', sscc_, Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_)));
             END IF;         
         END IF;
      END IF;

      IF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
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
   inv_list_no_                VARCHAR2(15);
   part_no_                    VARCHAR2(25);
   location_no_                VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   configuration_id_           VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   eng_chg_level_              VARCHAR2(6);
   waiv_dev_rej_no_            VARCHAR2(15);
   activity_seq_               NUMBER;
   barcode_id_                 NUMBER;
   dummy_contract_             VARCHAR2(5);
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   lov_type_db_                VARCHAR2(20);
   dummy_exit_lov_             BOOLEAN;
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
         Get_Filter_Keys___(dummy_contract_, inv_list_no_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
      ELSE
         Get_Filter_Keys___(dummy_contract_, inv_list_no_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            capture_session_id_, data_item_id_);
      END IF;

      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

      IF ((data_item_id_ = 'BARCODE_ID') OR 
         (barcode_id_ IS NOT NULL AND data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ'))) THEN
         Inventory_Part_Barcode_API.Create_Data_Capture_Lov(contract_           => contract_,
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
   
   
      ELSIF (data_item_id_ IN ('PART_NO', 'CONDITION_CODE')) THEN 
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, contract_);
      ELSIF (data_item_id_ = 'LOCATION_NO') THEN
         Inventory_Location_API.Create_Data_Capture_Lov(contract_, capture_session_id_, lov_id_ => 7); -- this is the lov count inventory part client is using, while process is using lov1
      ELSIF (data_item_id_ = 'CONFIGURATION_ID') THEN
         Inventory_Part_Config_API.Create_Data_Capture_Lov(contract_           => contract_,
                                                           part_no_            => part_no_,
                                                           configuration_id_   => configuration_id_,
                                                           capture_session_id_ => capture_session_id_,
                                                           column_name_        => data_item_id_,
                                                           lov_type_db_        => lov_type_db_);
      ELSIF (data_item_id_ = 'ENG_CHG_LEVEL') THEN
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            Part_Revision_API.Create_Data_Capture_Lov(contract_             => contract_,
                                                      part_no_              => part_no_,
                                                      capture_session_id_   => capture_session_id_);
         $ELSE
            NULL; 
         $END
      ELSIF (data_item_id_ IN ('HANDLING_UNIT_ID','SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
         IF (data_item_id_ = 'HANDLING_UNIT_ID') THEN  -- Add 0 as the first line to support non handling unit records
            session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            Data_Capture_Session_Lov_API.New(exit_lov_              => dummy_exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => 0,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => Data_Capture_Config_API.Get_Lov_Row_Limitation(capture_process_id_, capture_config_id_),    
                                             session_rec_           => session_rec_);
         END IF;
         Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_             => handling_unit_id_,
                                                   sscc_                         => sscc_,
                                                   alt_handling_unit_label_id_   => alt_handling_unit_label_id_,
                                                   capture_session_id_           => capture_session_id_,
                                                   column_name_                  => data_item_id_,
                                                   lov_type_db_                  => lov_type_db_,    
                                                   sql_where_expression_         => Get_Hu_Sql_Where_Expression___(contract_, location_no_));
      ELSIF (data_item_id_ = 'INV_LIST_NO') THEN
         Counting_Report_API.Create_Data_Capture_Lov(contract_           => contract_,
                                                     capture_session_id_ => capture_session_id_,
                                                     lov_id_             => 2);
      -- Left or not handled  'LOT_BATCH_NO', 'SERIAL_NO' 'ACTIVITY_SEQ'
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
   message_               VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'LINEADDED: The counting report line was saved.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'LINESADDED: :P1 counting report lines were saved.', NULL, no_of_records_handled_);
   END IF;
   
   RETURN message_;
END Get_Process_Execution_Message;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   inv_list_no_                VARCHAR2(15);
   part_no_                    VARCHAR2(25);
   barcode_id_                 NUMBER;
   contract_                   VARCHAR2(5);
   location_no_                VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   configuration_id_           VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   eng_chg_level_              VARCHAR2(6);
   waiv_dev_rej_no_            VARCHAR2(15);
   activity_seq_               NUMBER;
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   automatic_value_            VARCHAR2(200);
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
         Get_Filter_Keys___(contract_, inv_list_no_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            capture_session_id_, data_item_id_);
         IF (data_item_id_ = 'BARCODE_ID') THEN
            automatic_value_ := barcode_id_;
         ELSIF (barcode_id_ IS NOT NULL AND  
                data_item_id_ IN('PART_NO','CONFIGURATION_ID','LOT_BATCH_NO','SERIAL_NO','ENG_CHG_LEVEL','WAIV_DEV_REJ_NO','ACTIVITY_SEQ')) THEN
               automatic_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => contract_,
                                                                                         barcode_id_       => barcode_id_,
                                                                                         part_no_          => part_no_,
                                                                                         configuration_id_ => configuration_id_,
                                                                                         lot_batch_no_     => lot_batch_no_,
                                                                                         serial_no_        => serial_no_,
                                                                                         eng_chg_level_    => eng_chg_level_,
                                                                                         waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                         activity_seq_     => activity_seq_,
                                                                                         column_name_      => data_item_id_);
            
         ELSIF (data_item_id_ = 'CONDITION_CODE') THEN
            IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_) = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE) THEN
               automatic_value_ := Condition_Code_API.Get_Default_Condition_Code;
            ELSE
               automatic_value_ := 'NULL';
            END IF;                                 
         ELSIF (data_item_id_ = 'HANDLING_UNIT_ID') THEN
            automatic_value_ := handling_unit_id_;
         ELSIF (data_item_id_ = 'SSCC') THEN
            sscc_ := CASE sscc_ WHEN '%' THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
            sscc_ := CASE handling_unit_id_ WHEN 0 THEN 'NULL' ELSE sscc_ END;  -- return string NULL if not using handling unit
            IF (sscc_ IS NULL AND (handling_unit_id_ IS NOT NULL AND handling_unit_id_ != 0) AND 
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', 'SSCC')) THEN
               sscc_ := 'NULL';  -- handling unit id exist before and there is no sscc_ fetched in Get_Filter_Keys___ then we can return string NULL 
            END IF;
            automatic_value_ := sscc_;
         ELSIF (data_item_id_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
            alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
            alt_handling_unit_label_id_ := CASE handling_unit_id_ WHEN 0 THEN 'NULL' ELSE alt_handling_unit_label_id_ END;  -- return string NULL if not using handling unit
            IF (alt_handling_unit_label_id_ IS NULL AND (handling_unit_id_ IS NOT NULL AND handling_unit_id_ != 0) AND 
                Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
               alt_handling_unit_label_id_ := 'NULL';  -- handling unit id exist before and there is no alt_handling_unit_label_id_ fetched in Get_Filter_Keys___ then we can return string NULL 
            END IF;
            automatic_value_ := alt_handling_unit_label_id_;
         ELSIF (data_item_id_ = 'INV_LIST_NO') THEN
            automatic_value_ := Counting_Report_API.Get_Inv_List_No_If_Unique(contract_);

         ELSE -- the following items are handled from Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value: SERIAL_NO, LOT_BATCH_NO, ENG_CHG_LEVEL, ACTIVITY_SEQ
            automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, session_rec_.session_contract, part_no_);
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
   capture_session_id_      IN NUMBER,
   latest_data_item_id_     IN VARCHAR2,
   latest_data_item_value_  IN VARCHAR2 )
IS
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   contract_                   VARCHAR2(5);
   inv_list_no_                VARCHAR2(15);
   part_no_                    VARCHAR2(25);
   location_no_                VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   configuration_id_           VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   eng_chg_level_              VARCHAR2(6);
   waiv_dev_rej_no_            VARCHAR2(15);
   activity_seq_               NUMBER;
   condition_code_             VARCHAR2(10);
   conf_item_detail_tab_       Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   barcode_id_                 NUMBER;
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   --gtin_no_                    VARCHAR2(14);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, inv_list_no_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, 
                         configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                         capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );

      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP

            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('LOCATION_NO', 'PART_NO', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 
                                                                    'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'BARCODE_ID', 
                                                                    'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN

                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  sscc_ := CASE sscc_ WHEN '%' THEN NULL ELSE sscc_ END;      -- % if it is not scanned yet
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           inv_list_no_                => inv_list_no_,
                                           part_no_                    => part_no_,
                                           location_no_                => location_no_,
                                           configuration_id_           => configuration_id_,
                                           lot_batch_no_               => lot_batch_no_,
                                           serial_no_                  => serial_no_,
                                           eng_chg_level_              => eng_chg_level_,
                                           waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                           activity_seq_               => activity_seq_,
                                           handling_unit_id_           => handling_unit_id_,
                                           sscc_                       => sscc_,  
                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                           barcode_id_                 => barcode_id_);
                                           --gtin_no_                    => gtin_no_);
               END IF;
            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID', 'RECEIPTS_BLOCKED',
                                                                    'MIX_OF_PART_NUMBER_BLOCKED', 'MIX_OF_CONDITION_CODES_BLOCKED',
                                                                    'MIX_OF_LOT_BATCH_NO_BLOCKED', 'LOCATION_GROUP', 'LOCATION_TYPE', 'LOCATION_NO_DESC')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 
                                                                       'UNIT_MEAS_DESCRIPTION', 'NET_WEIGHT', 'NET_VOLUME', 'PART_TYPE', 'PRIME_COMMODITY', 
                                                                       'PRIME_COMMODITY_DESCRIPTION', 'SECOND_COMMODITY', 'SECOND_COMMODITY_DESCRIPTION', 
                                                                       'ASSET_CLASS', 'ASSET_CLASS_DESCRIPTION', 'PART_STATUS', 'PART_STATUS_DESCRIPTION', 
                                                                       'ABC_CLASS', 'ABC_CLASS_PERCENT', 'SAFETY_CODE', 'SAFETY_CODE_DESCRIPTION', 'ACCOUNTING_GROUP', 
                                                                       'ACCOUNTING_GROUP_DESCRIPTION', 'PRODUCT_CODE', 'PRODUCT_CODE_DESCRIPTION', 'PRODUCT_FAMILY', 
                                                                       'PRODUCT_FAMILY_DESCRIPTION', 'TYPE_DESIGNATION', 'DIMENSION_QUALITY', 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                                                       'SERIAL_TRACKING_INVENTORY', 'SERIAL_TRACKING_DELIVERY', 'STOP_ARRIVAL_ISSUED_SERIAL', 
                                                                       'STOP_NEW_SERIAL_IN_RMA', 'SERIAL_RULE', 'LOT_BATCH_TRACKING', 'LOT_QUANTITY_RULE', 
                                                                       'SUB_LOT_RULE', 'COMPONENT_LOT_RULE', 'GTIN_IDENTIFICATION', 'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN
                                                                          
                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       contract_             => contract_,
                                                                       part_no_              => part_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY_ONHAND', 'CATCH_QUANTITY_ONHAND')) THEN
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
                                                                             activity_seq_        => activity_seq_,
                                                                             handling_unit_id_    => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROGRAM_ID', 'PROGRAM_DESCRIPTION', 'PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID',
                                                                       'SUB_PROJECT_DESCRIPTION', 'ACTIVITY_ID', 'ACTIVITY_DESCRIPTION')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Activity_Seq(capture_session_id_   => capture_session_id_,
                                                                            owning_data_item_id_  => latest_data_item_id_,
                                                                            data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                            activity_seq_         => activity_seq_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'CONDITION_CODE_DESCRIPTION') THEN
                  IF (latest_data_item_id_ = 'CONDITION_CODE') THEN 
                     condition_code_ := latest_data_item_value_;  
                  ELSE
                     condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                                          data_item_id_a_      => 'CONDITION_CODE',
                                                                                          data_item_id_b_      => latest_data_item_id_); 
                  END IF;
                  Data_Capture_Invent_Util_API.Add_Condition_Code_Desc(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       condition_code_       => condition_code_);
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
               END IF;
            END IF;

         END LOOP;
      END IF;
   $ELSE
       NULL; 
   $END
END Add_Details_For_Latest_Item;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
   ptr_                    NUMBER;
   name_                   VARCHAR2(50);
   value_                  VARCHAR2(4000);
   inv_list_no_            VARCHAR2(15);
   seq_                    NUMBER;
   location_no_            VARCHAR2(35);
   part_no_                VARCHAR2(25);
   serial_no_              VARCHAR2(50) := '*';
   configuration_id_       VARCHAR2(50) := '*';
   lot_batch_no_           VARCHAR2(20) := '*';
   eng_chg_level_          VARCHAR2(6) := '1';
   waiv_dev_rej_no_        VARCHAR2(15) := '*';
   activity_seq_           NUMBER := 0;
   condition_code_         VARCHAR2(10);
   qty_onhand_             NUMBER;
   catch_qty_onhand_       NUMBER;
   handling_unit_id_       NUMBER;
   warehouse_route_order_  VARCHAR2(15);
   bay_route_order_        VARCHAR2(5);  
   row_route_order_        VARCHAR2(5);  
   tier_route_order_       VARCHAR2(5);  
   bin_route_order_        VARCHAR2(5);
   
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INV_LIST_NO') THEN
         inv_list_no_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN
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
      ELSIF (name_ = 'ACTIVITY_SEQ') THEN
         activity_seq_ := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         serial_no_ := value_;
      ELSIF (name_ = 'CONDITION_CODE') THEN
         condition_code_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;


   seq_ := Counting_Report_Line_API.Get_Max_Sequence_No(inv_list_no_, contract_) + 1;
   
   qty_onhand_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                                                             serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
   catch_qty_onhand_ := Inventory_Part_In_Stock_API.Get_Catch_Qty_Onhand(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                                                                         serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);

   Warehouse_Bay_Bin_API.Get_Route_Order_Strings(warehouse_route_order_, bay_route_order_, row_route_order_, tier_route_order_, bin_route_order_, contract_, location_no_);
 
   Counting_Report_Line_API.New_List_Detail(inv_list_no_         => inv_list_no_,
                                            seq_                   => seq_,
                                            contract_              => contract_,
                                            part_no_               => part_no_,
                                            configuration_id_      => configuration_id_,
                                            location_no_           => location_no_,
                                            lot_batch_no_          => lot_batch_no_,
                                            serial_no_             => serial_no_,
                                            eng_chg_level_         => eng_chg_level_,
                                            waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                            activity_seq_          => activity_seq_,
                                            handling_unit_id_      => handling_unit_id_,
                                            cost_                  => 0,
                                            qty_onhand_            => NVL(qty_onhand_,0),
                                            catch_qty_onhand_      => catch_qty_onhand_,
                                            userid_                => Fnd_Session_API.Get_Fnd_User,
                                            warehouse_route_order_ => warehouse_route_order_,
                                            bay_route_order_       => bay_route_order_,
                                            row_route_order_       => row_route_order_,
                                            tier_route_order_      => tier_route_order_,
                                            bin_route_order_       => bin_route_order_); 

END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Counting_Result_API.New_Result is granted thru following projection/action
   IF (Security_SYS.Is_Proj_Entity_Act_Available('CountPerCountReport', 'CountReportHeaderVirtual', 'CreateCountReportLines') ) THEN
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
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   process_package_            VARCHAR2(30);
   part_no_                    VARCHAR2(25);

BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
   $END

   RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, data_item_id_, part_no_, serial_no_ => NULL);
END Fixed_Value_Is_Applicable;
