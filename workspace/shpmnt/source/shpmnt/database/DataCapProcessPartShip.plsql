-----------------------------------------------------------------------------
--
--  Logical unit: DataCapProcessPartShip
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process/es: MOVE_PART_BETWEEN_SHIP_INV, RETURN_PARTS_FROM_SHIP_INV, SCRAP_PARTS_IN_SHIP_INV
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220513  Moinlk  SCDEV-7787, Added Get_Sql_Where_Expression method. And filtered data where soure_ref_type_db not set to PURCH_RECEIPT_RETURN.
--  201130  DiJwlk  SC2020R1-10530, Modified Validate_Data_Item() by checking LOCATION_NO for Process SCRAP_PARTS_IN_SHIP_INV instead of FROM_LOCATION_NO
--  200902  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available/Is_Proj_Entity_Act_Available in Is_Process_Available to support new projection security concept.
--  191115  MeAblk  SCSPRING20-934, Increased the length of receiver_id upto 50 characters.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171213  CKumlk  STRSC-15073, Adjusted a data item and some feedback items for SCRAP_PARTS_IN_SHIP_INV.
--  171120  CKumlk  STRSC-13592, Combined Scrap Part in Shipment Inventory.
--  171116  SURBLK  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
string_all_values_ CONSTANT VARCHAR2(1) := '%';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   receiver_id_                IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   shipment_id_                IN NUMBER,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   condition_code_             IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   wanted_data_item_id_        IN VARCHAR2,
   capture_process_id_         IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_ VARCHAR2(200);
   column_name_  VARCHAR2(30);
BEGIN

   IF (wanted_data_item_id_ = 'BARCODE_ID' OR (barcode_id_ IS NOT NULL AND  
       wanted_data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'SERIAL_NO'))) THEN
      unique_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => contract_,
                                                                             barcode_id_       => barcode_id_,
                                                                             part_no_          => part_no_,
                                                                             configuration_id_ => configuration_id_,
                                                                             lot_batch_no_     => lot_batch_no_,
                                                                             serial_no_        => serial_no_,
                                                                             eng_chg_level_    => eng_chg_level_,
                                                                             waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                             activity_seq_     => activity_seq_,
                                                                             column_name_      => wanted_data_item_id_ );
   ELSE
      IF (wanted_data_item_id_ = 'FROM_LOCATION_NO') THEN
         column_name_ := 'LOCATION_NO';
      ELSIF (wanted_data_item_id_ = 'SOURCE_REF_TYPE') THEN
         column_name_ := 'SOURCE_REF_TYPE_DB';
      ELSE
         column_name_ := wanted_data_item_id_;
      END IF;
      unique_value_ := Handle_Ship_Invent_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                 shipment_id_                => shipment_id_,
                                                                                 source_ref1_                => source_ref1_,
                                                                                 source_ref2_                => source_ref2_,
                                                                                 source_ref3_                => source_ref3_,
                                                                                 source_ref4_                => source_ref4_,
                                                                                 source_ref_type_db_         => source_ref_type_db_,
                                                                                 pick_list_no_               => pick_list_no_,
                                                                                 part_no_                    => part_no_,
                                                                                 configuration_id_           => configuration_id_,
                                                                                 location_no_                => from_location_no_,
                                                                                 lot_batch_no_               => lot_batch_no_,
                                                                                 serial_no_                  => serial_no_,
                                                                                 waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                 eng_chg_level_              => eng_chg_level_,
                                                                                 activity_seq_               => activity_seq_,
                                                                                 handling_unit_id_           => handling_unit_id_,
                                                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                 receiver_id_                => receiver_id_,
                                                                                 condition_code_             => condition_code_,
                                                                                 column_name_                => column_name_,
                                                                                 sql_where_expression_       => Get_Sql_Where_Expression(capture_process_id_));
   END IF;
   IF (unique_value_ = 'NULL') THEN
      unique_value_ := NULL;
   END IF;
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   contract_                   OUT VARCHAR2,
   pick_list_no_               OUT VARCHAR2,
   source_ref1_                OUT VARCHAR2,
   source_ref2_                OUT VARCHAR2,
   source_ref3_                OUT VARCHAR2,
   source_ref4_                OUT VARCHAR2,
   source_ref_type_db_         OUT VARCHAR2,
   part_no_                    OUT VARCHAR2,
   serial_no_                  OUT VARCHAR2,
   lot_batch_no_               OUT VARCHAR2,    
   waiv_dev_rej_no_            OUT VARCHAR2,
   eng_chg_level_              OUT VARCHAR2,
   configuration_id_           OUT VARCHAR2,
   activity_seq_               OUT NUMBER,
   shipment_id_                OUT NUMBER,
   from_location_no_           OUT VARCHAR2,
   receiver_id_                OUT VARCHAR2,
   condition_code_             OUT VARCHAR2,
   barcode_id_                 OUT NUMBER,
   handling_unit_id_           OUT NUMBER,
   sscc_                       OUT VARCHAR2,  -- not used for filtering in unique handling
   alt_handling_unit_label_id_ OUT VARCHAR2,
   gtin_no_                    OUT VARCHAR2,
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
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      pick_list_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PICK_LIST_NO', session_rec_ , process_package_, use_applicable_);
      source_ref1_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF1', session_rec_ , process_package_, use_applicable_);
      source_ref2_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF2', session_rec_ , process_package_, use_applicable_);
      source_ref3_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF3', session_rec_ , process_package_, use_applicable_);
      source_ref4_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF4', session_rec_ , process_package_, use_applicable_);
      source_ref_type_db_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF_TYPE', session_rec_ , process_package_, use_applicable_);
      part_no_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      
      IF session_rec_.capture_process_id = 'SCRAP_PARTS_IN_SHIP_INV' THEN
         from_location_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      ELSE
         from_location_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      END IF;
     
      lot_batch_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_                  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      configuration_id_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      activity_seq_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
      shipment_id_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      receiver_id_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RECEIVER_ID', session_rec_ , process_package_, use_applicable_);
      condition_code_             := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONDITION_CODE', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      gtin_no_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);
        
      -- Also fetch predicted barcode_id since this process can use barcodes
      barcode_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'BARCODE_ID', session_rec_ , process_package_, use_applicable_);      
      
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

      IF (gtin_no_ IS NULL AND Data_Capture_Invent_Util_API.Gtin_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
         gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      END IF;
      
      IF ((part_no_ IS NULL) AND (gtin_no_ IS NOT NULL)) THEN
         part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_); 
      END IF;

      -- if alt_handling_unit_label_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
      -- so we need to specifiy that we have to compare to all alternative handling unit label ids in the table
      IF (alt_handling_unit_label_id_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         alt_handling_unit_label_id_ := string_all_values_;
      END IF;

      -- if condition_code_ comes after current data item, we exchange the parameter with % since this column in the table can be NULL 
      -- so we need to specifiy that we have to compare to all condition codes in the table
      IF (condition_code_ IS NULL AND 
          NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'CONDITION_CODE', data_item_id_)) THEN
         condition_code_ := string_all_values_;
      END IF;
      
      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (pick_list_no_ IS NULL) THEN
            pick_list_no_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                           shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                           waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'PICK_LIST_NO', session_rec_.capture_process_id);
         END IF;
         IF (source_ref1_ IS NULL) THEN
            source_ref1_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                          shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                          waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'SOURCE_REF1', session_rec_.capture_process_id);
         END IF;
         IF (source_ref2_ IS NULL) THEN
            source_ref2_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                          shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                          waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'SOURCE_REF2', session_rec_.capture_process_id);
         END IF;
         IF (source_ref3_ IS NULL) THEN
            source_ref3_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                          shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                          waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'SOURCE_REF3', session_rec_.capture_process_id);
         END IF;
         IF (source_ref4_ IS NULL) THEN
            source_ref4_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                          shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                          waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'SOURCE_REF4', session_rec_.capture_process_id);
         END IF;
         IF (source_ref_type_db_ IS NULL) THEN
            source_ref_type_db_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                                 shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                                 waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'SOURCE_REF_TYPE', session_rec_.capture_process_id);
         END IF;
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                      shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                      waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'PART_NO', session_rec_.capture_process_id);
         END IF;
         IF (from_location_no_ IS NULL) THEN
            from_location_no_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                               shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                               waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'FROM_LOCATION_NO', session_rec_.capture_process_id);
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                           shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                           waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'LOT_BATCH_NO', session_rec_.capture_process_id);
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                              shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                              waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'WAIV_DEV_REJ_NO', session_rec_.capture_process_id);
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                            shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                            waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'ENG_CHG_LEVEL', session_rec_.capture_process_id);
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                               shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                               waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'CONFIGURATION_ID', session_rec_.capture_process_id);
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                           shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                           waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'ACTIVITY_SEQ', session_rec_.capture_process_id);
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                        shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                        waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'SERIAL_NO', session_rec_.capture_process_id);
         END IF;
         IF (condition_code_ IS NULL) THEN
            condition_code_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                             shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                             waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'CONDITION_CODE', session_rec_.capture_process_id);
         END IF;
         IF (receiver_id_ IS NULL) THEN
            receiver_id_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                          shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                          waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'RECEIVER_ID', session_rec_.capture_process_id);
         END IF;
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                          shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                          waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'SHIPMENT_ID', session_rec_.capture_process_id);
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                               shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                               waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'HANDLING_UNIT_ID', session_rec_.capture_process_id);
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                                         shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                                         waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_.capture_process_id);
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Shpmnt_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, part_no_,
                                                         shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
                                                         waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'BARCODE_ID', session_rec_.capture_process_id);
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
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   receiver_id_                IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   shipment_id_                IN NUMBER,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   condition_code_             IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   from_location_no_           IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   gtin_no_                    IN VARCHAR2)  
IS
   detail_value_ VARCHAR2(200);
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   local_data_item_detail_id_  VARCHAR2(50);

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('PICK_LIST_NO') THEN
            detail_value_ := pick_list_no_;
         WHEN ('SOURCE_REF1') THEN
            detail_value_ := source_ref1_;
         WHEN ('SOURCE_REF2') THEN
            detail_value_ := source_ref2_;
         WHEN ('SOURCE_REF3') THEN
            detail_value_ := source_ref3_;
         WHEN ('SOURCE_REF4') THEN
            detail_value_ := source_ref4_;
         WHEN ('SOURCE_REF_TYPE') THEN
            detail_value_ := source_ref_type_db_;
         WHEN ('PART_NO') THEN
            detail_value_ := part_no_;
         WHEN ('FROM_LOCATION_NO') THEN
            detail_value_ := from_location_no_;
         WHEN ('SERIAL_NO') THEN
            detail_value_ := serial_no_;
         WHEN ('LOT_BATCH_NO') THEN
            detail_value_ := lot_batch_no_;
         WHEN ('WAIV_DEV_REJ_NO') THEN
            detail_value_ := waiv_dev_rej_no_;
         WHEN ('ENG_CHG_LEVEL') THEN
            detail_value_ := eng_chg_level_;
         WHEN ('CONFIGURATION_ID') THEN
            detail_value_ := configuration_id_;
         WHEN ('ACTIVITY_SEQ') THEN
            detail_value_ := activity_seq_;
         WHEN ('SHIPMENT_ID') THEN
            detail_value_ := shipment_id_;
         WHEN ('RECEIVER_ID') THEN
            detail_value_ := receiver_id_;
         WHEN ('CONDITION_CODE') THEN
            detail_value_ := condition_code_;
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
           
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      IF (data_item_detail_id_ = 'FROM_LOCATION_NO') THEN   
         local_data_item_detail_id_ := 'LOCATION_NO';
      ELSE
         local_data_item_detail_id_ := data_item_detail_id_;
      END IF;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => local_data_item_detail_id_,
                                        data_item_value_     => detail_value_);
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


PROCEDURE Add_Unique_Feedback_Detail___ (
   capture_session_id_           IN NUMBER,
   owning_data_item_id_          IN VARCHAR2,
   data_item_detail_id_          IN VARCHAR2,
   contract_                     IN VARCHAR2,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,
   pick_list_no_                 IN VARCHAR2,
   receiver_id_                  IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   condition_code_               IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,
   alt_handling_unit_label_id_   IN VARCHAR2,
   from_location_no_             IN VARCHAR2)  
IS
   detail_value_    VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      detail_value_ :=  Handle_Ship_Invent_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                  shipment_id_                => shipment_id_,
                                                                                  source_ref1_                => source_ref1_,
                                                                                  source_ref2_                => source_ref2_,
                                                                                  source_ref3_                => source_ref3_,
                                                                                  source_ref4_                => source_ref4_,
                                                                                  source_ref_type_db_         => source_ref_type_db_,
                                                                                  pick_list_no_               => pick_list_no_,
                                                                                  part_no_                    => part_no_,
                                                                                  configuration_id_           => configuration_id_,
                                                                                  location_no_                => from_location_no_,
                                                                                  lot_batch_no_               => lot_batch_no_,
                                                                                  serial_no_                  => serial_no_,
                                                                                  waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                  eng_chg_level_              => eng_chg_level_,
                                                                                  activity_seq_               => activity_seq_,
                                                                                  handling_unit_id_           => handling_unit_id_,
                                                                                  alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                  receiver_id_                => receiver_id_,
                                                                                  condition_code_             => condition_code_,
                                                                                  column_name_                => data_item_detail_id_);
                                                                                  
      IF (detail_value_ = 'NULL') THEN
         detail_value_ := NULL;
      END IF;
      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Feedback_Detail___;


PROCEDURE Add_Package_Component___ (
   capture_session_id_           IN NUMBER,
   owning_data_item_id_          IN VARCHAR2,
   data_item_detail_id_          IN VARCHAR2,
   source_ref4_                  IN VARCHAR2 )  
IS
   detail_value_    VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (source_ref4_ = 0) THEN
      detail_value_ := Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_FALSE);
   ELSE
      detail_value_ := Fnd_Boolean_API.Decode(Fnd_Boolean_API.DB_TRUE);
   END IF;
   Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                     data_item_id_          => owning_data_item_id_,
                                     data_item_detail_id_   => data_item_detail_id_,
                                     data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Package_Component___;


PROCEDURE Validate_Qty___(
   capture_session_id_ IN NUMBER,
   qty_                IN NUMBER,
   data_item_id_       IN VARCHAR2)
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF qty_ <= 0 THEN
         Error_SYS.Record_General(lu_name_,'QTYRETURNEDGREATERTHANZERO: :P1 must be greater than 0.', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Qty___;


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

@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF capture_process_id_ = 'MOVE_PART_BETWEEN_SHIP_INV' THEN
      -- Check to see that API method Handle_Ship_Invent_Utility_API.Move_Between_Ship_Inv__ is granted thru any of following projections/actions/entity actions
      IF (Security_SYS.Is_Proj_Entity_Act_Available('MovePartsBetweenShipmentInventories', 'InventoryPartInStock', 'UpdateMovePartsBetweenShipmentInventory') OR
          Security_SYS.Is_Proj_Action_Available('MovePartsBetweenShipmentInventories', 'CreateMovePartsBetweenShipmentInventory')) THEN
         process_available_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF capture_process_id_ = 'RETURN_PARTS_FROM_SHIP_INV' THEN
      -- Check to see that API method Handle_Ship_Invent_Utility_API.Return_From_Ship_Inv__ is granted thru any of following projections/actions/entity actions
      IF (Security_SYS.Is_Proj_Entity_Act_Available('ReturnPartsFromShipmentInventory', 'InventoryPartInStock', 'ReturnFromShipInv') OR
          Security_SYS.Is_Proj_Action_Available('ReturnPartsFromShipmentInventory', 'ReturnFromShipInvToNewLoc')) THEN
         process_available_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF capture_process_id_ = 'SCRAP_PARTS_IN_SHIP_INV' THEN
      -- Check to see that API method Handle_Ship_Invent_Utility_API.Scrap_Part_In_Ship_Inv__ is granted thru any of following projections/actions
      IF (Security_SYS.Is_Proj_Action_Available('InventoryPartsInShipmentInventoryHandling', 'ScrapPartInShipmentInventory')) THEN
         process_available_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY VARCHAR2,
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2 )
IS
   ptr_                NUMBER;
   name_               VARCHAR2(50);
   value_              VARCHAR2(4000);
   info_               VARCHAR2(2000);
   source_ref1_        VARCHAR2(50);
   source_ref2_        VARCHAR2(50);
   source_ref3_        VARCHAR2(50);
   source_ref4_        VARCHAR2(50);
   source_ref_type_db_ shipment_line_tab.source_ref_type%TYPE;
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
   part_no_            VARCHAR2(25);
   from_location_no_   VARCHAR2(35);
   location_no_        VARCHAR2(35);
   lot_batch_no_       VARCHAR2(20);
   serial_no_          VARCHAR2(50);
   waiv_dev_rej_no_    VARCHAR2(15);
   eng_chg_level_      VARCHAR2(6);
   pick_list_no_       VARCHAR2(15);
   activity_seq_       NUMBER;
   to_location_no_     VARCHAR2(35);
   qty_to_move_        NUMBER;
   catch_qty_to_move_  NUMBER;
   qty_returned_       NUMBER;
   catch_qty_returned_ NUMBER;
   qty_scrapped_       NUMBER;
   catch_qty_scrapped_ NUMBER;
   scrap_cause_        VARCHAR2(20);
   scrap_note_         VARCHAR2(2000);
   shipment_id_        NUMBER;
   handling_unit_id_   NUMBER;
BEGIN
   ptr_ := NULL;
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'SOURCE_REF1') THEN
            source_ref1_ := value_;
         ELSIF (name_ = 'SOURCE_REF2') THEN
            source_ref2_ := value_;
         ELSIF (name_ = 'SOURCE_REF3') THEN
            source_ref3_ := value_;
         ELSIF (name_ = 'SOURCE_REF4') THEN
            source_ref4_ := value_;
         ELSIF (name_ = 'SOURCE_REF_TYPE') THEN
            source_ref_type_db_ := value_;
         ELSIF (name_ = 'PICK_LIST_NO') THEN
            pick_list_no_ := value_;
         ELSIF (name_ = 'PART_NO') THEN
            part_no_ := value_;
         ELSIF (name_ = 'SHIPMENT_ID') THEN
            shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'LOT_BATCH_NO') THEN
            lot_batch_no_ := value_;
         ELSIF (name_ = 'SERIAL_NO') THEN
            serial_no_ := value_;
         ELSIF (name_ = 'ENG_CHG_LEVEL') THEN
            eng_chg_level_ := value_;
         ELSIF (name_ = 'WAIV_DEV_REJ_NO') THEN
            waiv_dev_rej_no_ := value_;
         ELSIF (name_ = 'ACTIVITY_SEQ') THEN
            activity_seq_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'FROM_LOCATION_NO') THEN
            from_location_no_ := value_;
         ELSIF (name_ = 'LOCATION_NO') THEN
            location_no_ := value_;
         ELSIF (name_ = 'TO_LOCATION_NO') THEN
            to_location_no_ := value_;
         ELSIF (name_ = 'QTY_TO_MOVE') THEN
            qty_to_move_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CATCH_QTY_TO_MOVE') THEN
            catch_qty_to_move_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'QTY_RETURNED') THEN
            qty_returned_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CATCH_QTY_RETURNED') THEN
            catch_qty_returned_ := Client_SYS.Attr_Value_To_Number(value_);  
         ELSIF (name_ = 'QTY_SCRAPPED') THEN
            qty_scrapped_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CATCH_QTY_SCRAPPED') THEN
            catch_qty_scrapped_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'SCRAPPING_CAUSE') THEN
            scrap_cause_ := value_;
         ELSIF (name_ = 'NOTE') THEN
            scrap_note_ := value_;
         ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
            handling_unit_id_ := value_;
         END IF;
      END LOOP;

      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      IF session_rec_.capture_process_id= 'MOVE_PART_BETWEEN_SHIP_INV' THEN
         Handle_Ship_Invent_Utility_API.Move_Between_Ship_Inv__(info_,
                                                                source_ref1_        => source_ref1_,
                                                                source_ref2_        => source_ref2_,
                                                                source_ref3_        => source_ref3_,
                                                                source_ref4_        => source_ref4_,
                                                                source_ref_type_db_ => source_ref_type_db_,
                                                                from_contract_      => contract_,
                                                                part_no_            => part_no_,
                                                                from_location_no_   => from_location_no_,
                                                                lot_batch_no_       => lot_batch_no_,
                                                                serial_no_          => serial_no_,
                                                                eng_chg_level_      => eng_chg_level_,
                                                                waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                pick_list_no_       => pick_list_no_,
                                                                activity_seq_       => activity_seq_,
                                                                handling_unit_id_   => handling_unit_id_,
                                                                to_contract_        => contract_,
                                                                to_location_no_     => to_location_no_,
                                                                qty_to_move_        => qty_to_move_,
                                                                catch_qty_to_move_  => catch_qty_to_move_,
                                                                shipment_id_        => shipment_id_);
      ELSIF session_rec_.capture_process_id= 'RETURN_PARTS_FROM_SHIP_INV' THEN                                            
         Handle_Ship_Invent_Utility_API.Return_From_Ship_Inv__(info_               => info_,
                                                               source_ref1_        => source_ref1_,
                                                               source_ref2_        => source_ref2_,
                                                               source_ref3_        => source_ref3_,
                                                               source_ref4_        => source_ref4_,
                                                               source_ref_type_db_ => source_ref_type_db_,
                                                               from_contract_      => contract_,
                                                               part_no_            => part_no_,
                                                               from_location_no_   => from_location_no_,
                                                               lot_batch_no_       => lot_batch_no_,
                                                               serial_no_          => serial_no_,
                                                               eng_chg_level_      => eng_chg_level_,
                                                               waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                               pick_list_no_       => pick_list_no_,
                                                               activity_seq_       => activity_seq_,
                                                               handling_unit_id_   => handling_unit_id_,
                                                               to_contract_        => contract_,
                                                               to_location_no_     => to_location_no_,
                                                               qty_returned_       => qty_returned_,
                                                               catch_qty_returned_ => catch_qty_returned_,
                                                               shipment_id_        => shipment_id_);

      ELSIF session_rec_.capture_process_id= 'SCRAP_PARTS_IN_SHIP_INV' THEN 
         Handle_Ship_Invent_Utility_API.Scrap_Part_In_Ship_Inv__(info_               => info_,
                                                                 source_ref1_        => source_ref1_,
                                                                 source_ref2_        => source_ref2_,
                                                                 source_ref3_        => source_ref3_,
                                                                 source_ref4_        => source_ref4_,
                                                                 source_ref_type_db_ => source_ref_type_db_,
                                                                 contract_           => contract_,
                                                                 part_no_            => part_no_,
                                                                 location_no_        => location_no_,
                                                                 lot_batch_no_       => lot_batch_no_,
                                                                 serial_no_          => serial_no_,
                                                                 eng_chg_level_      => eng_chg_level_,
                                                                 waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                 pick_list_no_       => pick_list_no_,
                                                                 activity_seq_       => activity_seq_,
                                                                 handling_unit_id_   => handling_unit_id_,                                                    
                                                                 qty_to_scrap_       => qty_scrapped_,
                                                                 catch_qty_to_scrap_ => catch_qty_scrapped_,
                                                                 scrap_cause_        => scrap_cause_,
                                                                 scrap_note_         => scrap_note_,
                                                                 shipment_id_        => shipment_id_);
      END IF;
                                                          
   $END
END Execute_Process;

@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_                     VARCHAR2(200);
BEGIN
   IF capture_process_id_ = 'MOVE_PART_BETWEEN_SHIP_INV' THEN
      IF no_of_records_handled_ = 1 THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'MOVESHIPINV: The stock move between shipment locations has been completed.');
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'MOVESSHIPINV: :P1 stock moves between shipment locations have been completed.', NULL, no_of_records_handled_);
      END IF;
   
   ELSIF capture_process_id_ = 'RETURN_PARTS_FROM_SHIP_INV' THEN
      IF no_of_records_handled_ = 1 THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'RETSHIPINV: The part has been returned from shipment inventory.');
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'RETSSHIPINV: :P1 parts have been returned from shipment inventory.', null, no_of_records_handled_);
      END IF; 
   ELSIF capture_process_id_ = 'SCRAP_PARTS_IN_SHIP_INV' THEN
      IF no_of_records_handled_ = 1 THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'SCRAPSHIPINV: The part has been scrapped from shipment inventory.');
      ELSE
         message_ := Language_SYS.Translate_Constant(lu_name_, 'SCRAPSSHIPINV: :P1 parts have been scrapped from shipment inventory.', null, no_of_records_handled_);
      END IF;
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
   dummy_contract_             VARCHAR2(5);
   pick_list_no_               VARCHAR2(15);
   source_ref1_                VARCHAR2(50);
   source_ref2_                VARCHAR2(50);
   source_ref3_                VARCHAR2(50);
   source_ref4_                VARCHAR2(50);
   source_ref_type_db_         shipment_line_tab.source_ref_type%TYPE;
   part_no_                    VARCHAR2(25);
   receiver_id_                VARCHAR2(50);
   condition_code_             VARCHAR2(10);
   from_location_no_           VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   waiv_dev_rej_no_            VARCHAR2(15);
   eng_chg_level_              VARCHAR2(6);
   configuration_id_           VARCHAR2(50);
   activity_seq_               NUMBER;
   shipment_id_                NUMBER;
   barcode_id_                 NUMBER;
   handling_unit_id_           NUMBER; 
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   column_name_                VARCHAR2(30);
   lov_type_db_                VARCHAR2(20);
   input_uom_group_id_         VARCHAR2(30);
   gtin_no_                    VARCHAR2(14);
   lov_id_                     NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
         Get_Filter_Keys___(dummy_contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                            lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                            condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_, 
                            data_item_value_ => NULL, use_unique_values_ => TRUE);
      ELSE
         Get_Filter_Keys___(dummy_contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                            lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                            condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_);
      END IF;

      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

      IF (data_item_id_ IN ('TO_LOCATION_NO')) THEN
         
         IF capture_process_id_ = 'MOVE_PART_BETWEEN_SHIP_INV' THEN
            lov_id_ := 6;
         ELSIF capture_process_id_ = 'RETURN_PARTS_FROM_SHIP_INV' THEN
           lov_id_:= 7;
         END IF;   
         
         Inventory_Location_API.Create_Data_Capture_Lov(contract_            => contract_, 
                                                        capture_session_id_  => capture_session_id_, 
                                                        lov_id_              => lov_id_,
                                                        exclude_location_no_ => from_location_no_);
      ELSIF (data_item_id_ IN ('INPUT_UOM')) THEN                                                                     
         input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
         Input_Unit_Meas_API.Create_Data_Capture_Lov(capture_session_id_, input_uom_group_id_, 'UNIT_CODE', lov_type_db_, Get_Input_Uom_Sql_Whr_Exprs___);  
      ELSIF (data_item_id_ = 'SCRAPPING_CAUSE') THEN
         Scrapping_Cause_API.Create_Data_Capture_Lov(capture_session_id_);     
      ELSE     

         IF (data_item_id_ = 'BARCODE_ID' OR 
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
         ELSE
            IF (data_item_id_ = 'FROM_LOCATION_NO') THEN
               column_name_ := 'LOCATION_NO';
            ELSIF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
               column_name_ := 'SOURCE_REF_TYPE_DB';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            Handle_Ship_Invent_Utility_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                                   shipment_id_                => shipment_id_,
                                                                   source_ref1_                => source_ref1_,
                                                                   source_ref2_                => source_ref2_,
                                                                   source_ref3_                => source_ref3_,
                                                                   source_ref4_                => source_ref4_,
                                                                   source_ref_type_db_         => source_ref_type_db_,
                                                                   pick_list_no_               => pick_list_no_,
                                                                   part_no_                    => part_no_,
                                                                   configuration_id_           => configuration_id_,
                                                                   location_no_                => from_location_no_,
                                                                   lot_batch_no_               => lot_batch_no_,
                                                                   serial_no_                  => serial_no_,
                                                                   waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                   eng_chg_level_              => eng_chg_level_,
                                                                   activity_seq_               => activity_seq_,
                                                                   handling_unit_id_           => handling_unit_id_,
                                                                   alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                   receiver_id_                => receiver_id_,
                                                                   condition_code_             => condition_code_,
                                                                   capture_session_id_         => capture_session_id_,
                                                                   column_name_                => column_name_,
                                                                   lov_type_db_                => lov_type_db_,
                                                                   sql_where_expression_       => Get_Sql_Where_Expression(capture_process_id_));
         END IF;
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
   contract_                   VARCHAR2(5);
   pick_list_no_               VARCHAR2(15);
   source_ref1_                VARCHAR2(50);
   source_ref2_                VARCHAR2(50);
   source_ref3_                VARCHAR2(50);
   source_ref4_                VARCHAR2(50);
   source_ref_type_db_         shipment_line_tab.source_ref_type%TYPE;
   part_no_                    VARCHAR2(25);
   receiver_id_                VARCHAR2(50);
   condition_code_             VARCHAR2(10);
   from_location_no_           VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   waiv_dev_rej_no_            VARCHAR2(15);
   eng_chg_level_              VARCHAR2(6);
   configuration_id_           VARCHAR2(50);
   activity_seq_               NUMBER;
   shipment_id_                NUMBER;
   qty_assigned_               NUMBER;
   data_item_description_      VARCHAR2(200);
   column_name_                VARCHAR2(30);
   mandatory_non_process_key_  BOOLEAN := FALSE;
   barcode_id_                 NUMBER;
   handling_unit_id_           NUMBER; 
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   catch_quantity_              NUMBER;
   input_unit_meas_group_id_    VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);   
BEGIN
$IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (data_item_id_ IN ('QTY_TO_MOVE') OR data_item_id_ IN ('QTY_RETURNED') OR data_item_id_ IN ('QTY_SCRAPPED')) THEN
      mandatory_non_process_key_ := TRUE;
   END IF;

   IF (data_item_id_ NOT IN ('BARCODE_ID')) THEN
      Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_);
   END IF;

   IF (data_item_id_ = 'BARCODE_ID') THEN
      -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
      Get_Filter_Keys___(contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                         lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                         condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_, 
                         data_item_value_, use_unique_values_ => TRUE);
   ELSE
      Get_Filter_Keys___(contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                         lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                         condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_, 
                         data_item_value_);
   END IF;

   IF (data_item_id_ IN ('PART_NO','CATCH_QTY_TO_MOVE', 'CATCH_QTY_RETURNED', 'CATCH_QTY_SCRAPPED')) THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      IF session_rec_.capture_process_id = 'MOVE_PART_BETWEEN_SHIP_INV' THEN
         catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_TO_MOVE', session_rec_ , process_package_);
         Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_     => capture_session_id_,        
                                                   current_data_item_id_      => data_item_id_,
                                                   part_no_data_item_id_      => 'PART_NO',
                                                   part_no_data_item_value_   => part_no_,
                                                   catch_qty_data_item_id_    => 'CATCH_QTY_TO_MOVE',
                                                   catch_qty_data_item_value_ => catch_quantity_,
                                                   positive_catch_qty_        => TRUE);   -- Since this process dont allow normal quantity to be zero or lower it should not allow it for catch quantity either.
      ELSIF session_rec_.capture_process_id = 'RETURN_PARTS_FROM_SHIP_INV' THEN
         catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_RETURNED', session_rec_ , process_package_);
         Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_     => capture_session_id_,        
                                                   current_data_item_id_      => data_item_id_,
                                                   part_no_data_item_id_      => 'PART_NO',
                                                   part_no_data_item_value_   => part_no_,
                                                   catch_qty_data_item_id_    => 'CATCH_QTY_RETURNED',
                                                   catch_qty_data_item_value_ => catch_quantity_,
                                                   positive_catch_qty_        => TRUE);   -- Since this process dont allow normal quantity to be zero or lower it should not allow it for catch quantity either.
      ELSIF session_rec_.capture_process_id = 'SCRAP_PARTS_IN_SHIP_INV' THEN
         catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_SCRAPPED', session_rec_ , process_package_);
         Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_     => capture_session_id_,        
                                                   current_data_item_id_      => data_item_id_,
                                                   part_no_data_item_id_      => 'PART_NO',
                                                   part_no_data_item_value_   => part_no_,
                                                   catch_qty_data_item_id_    => 'CATCH_QTY_SCRAPPED',
                                                   catch_qty_data_item_value_ => catch_quantity_,
                                                   positive_catch_qty_        => TRUE);   -- Since this process dont allow normal quantity to be zero or lower it should not allow it for catch quantity either. 
      END IF;
   END IF;

   data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
   IF (data_item_id_ IN ('TO_LOCATION_NO')) THEN
      
      Inventory_Location_API.Exist(contract_, data_item_value_);
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);   
      
      IF session_rec_.capture_process_id = 'MOVE_PART_BETWEEN_SHIP_INV' THEN
         IF (from_location_no_ IS NOT NULL AND from_location_no_ = data_item_value_) THEN
            Error_SYS.Record_General(lu_name_,'MOVETOSAMELOC: You cannot move the part(s) to the same location :P1, select a different location.', from_location_no_);
         END IF;
         IF (NOT Inventory_Location_API.Is_Shipment_Location(contract_, data_item_value_)) THEN
            Handle_Ship_Invent_Utility_API.Raise_Not_A_Shipment_Location;
         END IF;
      ELSIF session_rec_.capture_process_id = 'RETURN_PARTS_FROM_SHIP_INV' THEN
         IF (Inventory_Location_API.Get_Location_Type_Db(contract_, data_item_value_) NOT IN ('PICKING', 'F', 'MANUFACTURING')) THEN
            Error_SYS.Record_General(lu_name_, 'NOTCORRECTLOC: To location is not a Picking, Production Line or Floor Stock location.');
         END IF;
      END IF;
   ELSIF (data_item_id_ IN ('QTY_TO_MOVE', 'QTY_RETURNED', 'QTY_SCRAPPED')) THEN
      Validate_Qty___(capture_session_id_, data_item_value_, data_item_id_);
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Only do assigned check when this data item comes after all parameter data item since Get_Qty_Reserved returns 0 if not found, this check will also be performed in execute process method we call
      IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF1', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF2', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF3', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF4', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PART_NO', data_item_id_) AND
          ((session_rec_.capture_process_id = 'SCRAP_PARTS_IN_SHIP_INV' AND 
            Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'LOCATION_NO', data_item_id_)) OR
            Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'FROM_LOCATION_NO', data_item_id_)) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'LOT_BATCH_NO', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SERIAL_NO', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ENG_CHG_LEVEL', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'WAIV_DEV_REJ_NO', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ACTIVITY_SEQ', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'CONFIGURATION_ID', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PICK_LIST_NO', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_) AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF_TYPE', data_item_id_)) THEN

         qty_assigned_ :=  Reserve_Shipment_API.Get_Qty_Reserved(source_ref1_, source_ref2_, source_ref3_, source_ref4_, contract_, part_no_, from_location_no_, 
                                                                 lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, 
                                                                 configuration_id_, pick_list_no_, shipment_id_, source_ref_type_db_);       
         IF session_rec_.capture_process_id = 'MOVE_PART_BETWEEN_SHIP_INV' THEN
            Handle_Ship_Invent_Utility_API.Validate_Qty_To_Move(data_item_value_, qty_assigned_);
         ELSIF session_rec_.capture_process_id = 'RETURN_PARTS_FROM_SHIP_INV' THEN
            Handle_Ship_Invent_Utility_API.Validate_Qty_To_Return(data_item_value_, qty_assigned_);
         ELSIF session_rec_.capture_process_id = 'SCRAP_PARTS_IN_SHIP_INV' THEN
            Handle_Ship_Invent_Utility_API.Validate_Qty_To_Scrap(data_item_value_, qty_assigned_);
         END IF;
      END IF;
   ELSIF (data_item_id_ IN ('CATCH_QTY_TO_MOVE', 'CATCH_QTY_RETURNED', 'CATCH_QTY_SCRAPPED','NOTE')) THEN
      NULL; -- only here so we dont do the Handle_Ship_Invent_Utility_API.Record_With_Column_Value_Exist else part later in this code
   ELSIF (data_item_id_ IN ('INPUT_QTY_TO_MOVE','INPUT_QTY_RETURNED', 'INPUT_QTY_SCRAPPED')) THEN
      Validate_Qty___(capture_session_id_, data_item_value_, data_item_id_);
   ELSIF (data_item_id_ IN ('GTIN')) THEN      -- checking GTIN_IS_MANDATORY detail
      Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
   ELSIF (data_item_id_ = 'INPUT_UOM') THEN            
      IF (data_item_value_ IS NOT NULL) THEN      
         input_unit_meas_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
         Input_Unit_Meas_API.Record_With_Column_Value_Exist(input_unit_meas_group_id_ => input_unit_meas_group_id_,
                                                            column_name_              => 'UNIT_CODE',
                                                            column_value_             => data_item_value_,
                                                            column_description_       => data_item_description_,
                                                            sql_where_expression_     => Get_Input_Uom_Sql_Whr_Exprs___);
      END IF;

   ELSIF (data_item_id_ = 'BARCODE_ID') THEN
      Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      IF (data_item_value_ IS NOT NULL) THEN
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
   ELSIF (data_item_id_ IN ('SCRAPPING_CAUSE')) THEN
      Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
          
      Scrapping_Cause_API.Exist(reject_reason_  => data_item_value_, 
                                check_validity_ => TRUE); 
   ELSIF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
   ELSE
      IF (barcode_id_ IS NOT NULL AND 
          data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ')) THEN
         -- BARCODE_ID is used for these items, then validate them against the barcode table
         Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_           => contract_,
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
      ELSE
         IF (data_item_id_ = 'FROM_LOCATION_NO') THEN
            column_name_ := 'LOCATION_NO';
         ELSIF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
            column_name_ := 'SOURCE_REF_TYPE_DB';
         ELSE
            column_name_ := data_item_id_;
         END IF;
         Handle_Ship_Invent_Utility_API.Record_With_Column_Value_Exist(contract_                   => contract_,
                                                                       shipment_id_                => shipment_id_,
                                                                       source_ref1_                => source_ref1_,
                                                                       source_ref2_                => source_ref2_,
                                                                       source_ref3_                => source_ref3_,
                                                                       source_ref4_                => source_ref4_,
                                                                       source_ref_type_db_         => source_ref_type_db_,
                                                                       pick_list_no_               => pick_list_no_,
                                                                       part_no_                    => part_no_,
                                                                       configuration_id_           => configuration_id_,
                                                                       location_no_                => from_location_no_,
                                                                       lot_batch_no_               => lot_batch_no_,
                                                                       serial_no_                  => serial_no_,
                                                                       waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                       eng_chg_level_              => eng_chg_level_,
                                                                       activity_seq_               => activity_seq_,
                                                                       handling_unit_id_           => handling_unit_id_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       receiver_id_                => receiver_id_,
                                                                       condition_code_             => condition_code_,
                                                                       column_name_                => column_name_,
                                                                       column_value_               => data_item_value_,
                                                                       column_description_         => data_item_description_,
                                                                       sql_where_expression_       => Get_Sql_Where_Expression(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_)));
      END IF;
   END IF;
$ELSE
   NULL;       
$END
END Validate_Data_Item;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                   VARCHAR2(5);
   pick_list_no_               VARCHAR2(15);
   source_ref1_                VARCHAR2(50);
   source_ref2_                VARCHAR2(50);
   source_ref3_                VARCHAR2(50);
   source_ref4_                VARCHAR2(50);
   source_ref_type_db_         shipment_line_tab.source_ref_type%TYPE;
   part_no_                    VARCHAR2(25);
   receiver_id_                VARCHAR2(50);
   condition_code_             VARCHAR2(10);
   from_location_no_           VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   waiv_dev_rej_no_            VARCHAR2(15);
   eng_chg_level_              VARCHAR2(6);
   configuration_id_           VARCHAR2(50);
   activity_seq_               NUMBER;
   shipment_id_                NUMBER;
   automatic_value_            VARCHAR2(200);
   column_name_                VARCHAR2(30);
   barcode_id_                 NUMBER;
   handling_unit_id_           NUMBER; 
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   gtin_no_                    VARCHAR2(14);
   input_uom_                  VARCHAR2(30);
   input_uom_group_id_         VARCHAR2(30);
   input_qty_                  NUMBER;
   input_conv_factor_          NUMBER;
   exclude_location_no_        VARCHAR2(35);
   data_item_id_a_             VARCHAR2(20);
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
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



         IF (data_item_id_ IN ('BARCODE_ID')) THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                               lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                               condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, 
                               data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                               lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                               condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, 
                               data_item_id_);
         END IF;
   
   
         IF (data_item_id_ = 'BARCODE_ID') THEN  
            automatic_value_ := barcode_id_;
         ELSIF (barcode_id_ IS NOT NULL AND  
            data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ')) THEN
            automatic_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => contract_,
                                                                                      barcode_id_       => barcode_id_,                                                                                    
                                                                                      part_no_          => part_no_,
                                                                                      configuration_id_ => configuration_id_,
                                                                                      lot_batch_no_     => lot_batch_no_,
                                                                                      serial_no_        => serial_no_,
                                                                                      eng_chg_level_    => eng_chg_level_,
                                                                                      waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                      activity_seq_     => activity_seq_,
                                                                                      column_name_      => data_item_id_ );
         ELSIF (data_item_id_ IN ('CATCH_QTY_TO_MOVE', 'CATCH_QTY_RETURNED', 'CATCH_QTY_SCRAPPED')) THEN
            automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, contract_, part_no_);
         ELSIF (data_item_id_ = 'TO_LOCATION_NO') THEN
            IF session_rec_.capture_process_id = 'MOVE_PART_BETWEEN_SHIP_INV' THEN
               exclude_location_no_ := NULL;
            ELSIF session_rec_.capture_process_id = 'RETURN_PARTS_FROM_SHIP_INV' THEN
               exclude_location_no_ := from_location_no_; 
            END IF;                    
            automatic_value_ := Inventory_Location_API.Get_Location_No_If_Unique(contract_            => contract_, 
                                                                                 lov_id_              => 7, 
                                                                                 exclude_location_no_ => exclude_location_no_);
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
         ELSIF (data_item_id_ IN('INPUT_QTY_TO_MOVE', 'INPUT_QTY_RETURNED', 'INPUT_QTY_SCRAPPED')) THEN
            input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                            data_item_id_a_     => 'INPUT_UOM',
                                                                            data_item_id_b_     => data_item_id_);                                                                         
            IF ((input_uom_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'INPUT_UOM', data_item_id_))
               OR (Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_) IS NULL) THEN            
               automatic_value_ := 'NULL';                     
            END IF; 
         ELSIF (data_item_id_= 'GTIN') THEN       
            automatic_value_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_); 
            IF (part_no_ IS NOT NULL AND automatic_value_ IS NULL) THEN            
               automatic_value_ := 'NULL';                     
            END IF;
   
         ELSIF (data_item_id_ IN ('GS1_BARCODE1','GS1_BARCODE2','GS1_BARCODE3')) THEN
            NULL; -- No extra automatic value for these items to avoid ELSE part later in the code since these are not in the data source
         ELSIF (data_item_id_ IN('QTY_TO_MOVE','QTY_RETURNED', 'QTY_SCRAPPED')) THEN
            input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                            data_item_id_a_     => 'INPUT_UOM',
                                                                            data_item_id_b_     => data_item_id_);
            IF data_item_id_ = 'QTY_TO_MOVE' THEN
               data_item_id_a_ := 'INPUT_QTY_TO_MOVE';
            ELSIF data_item_id_ = 'QTY_RETURNED' THEN
               data_item_id_a_ := 'INPUT_QTY_RETURNED';
            ELSIF data_item_id_ = 'QTY_SCRAPPED' THEN
               data_item_id_a_ := 'INPUT_QTY_SCRAPPED';
            END IF;                                                                
   
            input_qty_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                            data_item_id_a_     => data_item_id_a_,
                                                                            data_item_id_b_     => data_item_id_);
            IF (input_uom_ IS NOT NULL) AND (input_qty_ IS NOT NULL) THEN
               input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
               input_conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_id_, input_uom_);
               automatic_value_ := input_qty_ * input_conv_factor_;
            ELSE
               automatic_value_ := Handle_Ship_Invent_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                             shipment_id_                => shipment_id_,
                                                                                             source_ref1_                => source_ref1_,
                                                                                             source_ref2_                => source_ref2_,
                                                                                             source_ref3_                => source_ref3_,
                                                                                             source_ref4_                => source_ref4_,
                                                                                             source_ref_type_db_         => source_ref_type_db_,
                                                                                             pick_list_no_               => pick_list_no_,
                                                                                             part_no_                    => part_no_,
                                                                                             configuration_id_           => configuration_id_,
                                                                                             location_no_                => from_location_no_,
                                                                                             lot_batch_no_               => lot_batch_no_,
                                                                                             serial_no_                  => serial_no_,
                                                                                             waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                             eng_chg_level_              => eng_chg_level_,
                                                                                             activity_seq_               => activity_seq_,
                                                                                             handling_unit_id_           => handling_unit_id_,
                                                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                             receiver_id_                => receiver_id_,
                                                                                             condition_code_             => condition_code_,
                                                                                             column_name_                => 'QTY_ASSIGNED',
                                                                                             sql_where_expression_       => Get_Sql_Where_Expression(session_rec_.capture_process_id));
            END IF;
         ELSE
            IF (data_item_id_ = 'FROM_LOCATION_NO') THEN
               column_name_ := 'LOCATION_NO';
            ELSIF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
               column_name_ := 'SOURCE_REF_TYPE_DB';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            automatic_value_ := Handle_Ship_Invent_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                          shipment_id_                => shipment_id_,
                                                                                          source_ref1_                => source_ref1_,
                                                                                          source_ref2_                => source_ref2_,
                                                                                          source_ref3_                => source_ref3_,
                                                                                          source_ref4_                => source_ref4_,
                                                                                          source_ref_type_db_         => source_ref_type_db_,
                                                                                          pick_list_no_               => pick_list_no_,
                                                                                          part_no_                    => part_no_,
                                                                                          configuration_id_           => configuration_id_,
                                                                                          location_no_                => from_location_no_,
                                                                                          lot_batch_no_               => lot_batch_no_,
                                                                                          serial_no_                  => serial_no_,
                                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                          eng_chg_level_              => eng_chg_level_,
                                                                                          activity_seq_               => activity_seq_,
                                                                                          handling_unit_id_           => handling_unit_id_,
                                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                          receiver_id_                => receiver_id_,
                                                                                          condition_code_             => condition_code_,
                                                                                          column_name_                => column_name_,
                                                                                          sql_where_expression_       => Get_Sql_Where_Expression(session_rec_.capture_process_id));
   
         END IF;
      END IF;
   $END
   RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   process_package_            VARCHAR2(30);
   contract_                   VARCHAR2(5);
   pick_list_no_               VARCHAR2(15);
   source_ref1_                VARCHAR2(50);
   source_ref2_                VARCHAR2(50);
   source_ref3_                VARCHAR2(50);
   source_ref4_                VARCHAR2(50);
   source_ref_type_db_         shipment_line_tab.source_ref_type%TYPE;
   part_no_                    VARCHAR2(25);
   from_location_no_           VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   waiv_dev_rej_no_            VARCHAR2(15);
   eng_chg_level_              VARCHAR2(6);
   configuration_id_           VARCHAR2(50);
   local_data_item_id_         VARCHAR2(50);
   activity_seq_               NUMBER;
   shipment_id_                NUMBER;
   receiver_id_                VARCHAR2(50);
   condition_code_             VARCHAR2(10);
   fixed_value_is_applicable_  BOOLEAN := FALSE;
   barcode_id_                 NUMBER;
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   gtin_no_                    VARCHAR2(14);
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
      -- If predicted part_no_ is null then try fetch it with unique handling
      IF (part_no_ IS NULL OR data_item_id_ = 'SHIPMENT_ID') THEN
         Get_Filter_Keys___(contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                            lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                            condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, 
                            data_item_id_, use_applicable_ => FALSE);
         part_no_ := Get_Unique_Data_Item_Value___(contract_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, receiver_id_, 
                                                   part_no_, shipment_id_, lot_batch_no_, serial_no_, condition_code_, configuration_id_, eng_chg_level_,
         waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, from_location_no_, barcode_id_, 'PART_NO', Get_Sql_Where_Expression(session_rec_.capture_process_id));
      END IF;
      
      IF (data_item_id_ IN ('QTY_TO_MOVE', 'QTY_RETURNED', 'QTY_SCRAPPED')) THEN
         local_data_item_id_ := 'QUANTITY';
         IF (serial_no_ IS NULL ) THEN
            serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
         END IF; 
      ELSE
         local_data_item_id_ := data_item_id_;
      END IF;   
      IF (local_data_item_id_ = 'SHIPMENT_ID') THEN
         IF (source_ref1_ IS NOT NULL AND source_ref2_ IS NOT NULL AND source_ref3_ IS NOT NULL AND source_ref4_ IS NOT NULL AND source_ref_type_db_ IS NOT NULL) THEN
            fixed_value_is_applicable_ := (Shipment_Source_Utility_API.Is_Shipment_Connected(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_) = Fnd_Boolean_API.DB_FALSE);
         END IF;
      ELSIF (local_data_item_id_ IN('INPUT_QTY_TO_MOVE','INPUT_QTY_RETURNED', 'INPUT_QTY_SCRAPPED')) THEN
        IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'INPUT_UOM', local_data_item_id_) AND
            (Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                               data_item_id_a_     => 'INPUT_UOM',
                                                               data_item_id_b_     => local_data_item_id_) IS NULL)) OR
            (Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(session_rec_.session_contract, part_no_) IS NULL) THEN
            fixed_value_is_applicable_ := TRUE;
        END IF;
      ELSE
         fixed_value_is_applicable_ := Data_Capture_Shpmnt_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, local_data_item_id_, part_no_, serial_no_);
      END IF;

   $END
   RETURN fixed_value_is_applicable_;
   
END Fixed_Value_Is_Applicable;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_       Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                   VARCHAR2(5);
   pick_list_no_               VARCHAR2(15);
   source_ref1_                VARCHAR2(50);
   source_ref2_                VARCHAR2(50);
   source_ref3_                VARCHAR2(50);
   source_ref4_                VARCHAR2(50);
   source_ref_type_db_         shipment_line_tab.source_ref_type%TYPE;
   part_no_                    VARCHAR2(25);
   receiver_id_                VARCHAR2(50);
   condition_code_             VARCHAR2(10);
   from_location_no_           VARCHAR2(35);
   to_location_no_             VARCHAR2(35);
   serial_no_                  VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   waiv_dev_rej_no_            VARCHAR2(15);
   eng_chg_level_              VARCHAR2(6);
   configuration_id_           VARCHAR2(50);
   activity_seq_               NUMBER;
   shipment_id_                NUMBER;
   del_note_no_                VARCHAR2(15);
   barcode_id_                 NUMBER;
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   gtin_no_                    VARCHAR2(14);
   
   data_item_detail_id_ VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, pick_list_no_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, part_no_, serial_no_, 
                         lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, from_location_no_, receiver_id_, 
                         condition_code_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, 
                         data_item_id_ => latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF conf_item_detail_tab_(i).data_item_detail_id = 'LOCATION_NO' THEN
                  data_item_detail_id_ := 'FROM_LOCATION_NO';
               ELSE
                  data_item_detail_id_ := conf_item_detail_tab_(i).data_item_detail_id;
               END IF;
                  
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('PICK_LIST_NO', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 'SOURCE_REF_TYPE', 'PART_NO', 
                                                                    'FROM_LOCATION_NO', 'SERIAL_NO', 'LOT_BATCH_NO', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 
                                                                    'ACTIVITY_SEQ', 'SHIPMENT_ID', 'CONDITION_CODE', 'CONFIGURATION_ID', 'RECEIVER_ID',
                                                                    'BARCODE_ID', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN
                  condition_code_ := CASE condition_code_ WHEN '%' THEN NULL ELSE condition_code_ END;      -- % if it is not scanned yet
                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => data_item_detail_id_,
                                           source_ref1_                => source_ref1_,
                                           source_ref2_                => source_ref2_,
                                           source_ref3_                => source_ref3_,
                                           source_ref4_                => source_ref4_,
                                           source_ref_type_db_         => source_ref_type_db_,
                                           pick_list_no_               => pick_list_no_,
                                           receiver_id_                => receiver_id_,
                                           part_no_                    => part_no_,
                                           shipment_id_                => shipment_id_,
                                           lot_batch_no_               => lot_batch_no_,
                                           serial_no_                  => serial_no_,
                                           condition_code_             => condition_code_,
                                           configuration_id_           => configuration_id_,
                                           eng_chg_level_              => eng_chg_level_,
                                           waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                           activity_seq_               => activity_seq_,
                                           handling_unit_id_           => handling_unit_id_,
                                           sscc_                       => sscc_,  
                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                           from_location_no_           => from_location_no_,
                                           barcode_id_                 => barcode_id_,
                                           gtin_no_                    => gtin_no_);
               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_     => capture_session_id_,
                                                 session_rec_            => session_rec_,
                                                 owning_data_item_id_    => latest_data_item_id_,
                                                 owning_data_item_value_ => latest_data_item_value_,
                                                 data_item_detail_id_    => conf_item_detail_tab_(i).data_item_detail_id );
               END IF;
            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('FROM_WAREHOUSE_ID', 'FROM_BAY_ID', 'FROM_TIER_ID', 'FROM_ROW_ID', 'FROM_BIN_ID', 
                                                                    'TO_WAREHOUSE_ID', 'TO_BAY_ID', 'TO_TIER_ID', 'TO_ROW_ID', 'TO_BIN_ID' ,
                                                                    'WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID', 'BIN_ID', 'LOCATION_NO_DESC', 'LOCATION_TYPE')) THEN
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => from_location_no_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TO_WAREHOUSE_ID', 'TO_BAY_ID', 'TO_TIER_ID', 'TO_ROW_ID', 'TO_BIN_ID' )) THEN
                  to_location_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, latest_data_item_id_, latest_data_item_value_, 'TO_LOCATION_NO', session_rec_);
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => to_location_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'UNIT_MEAS', 'CATCH_UNIT_MEAS',
                                                                       'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_  => capture_session_id_,
                                                                       owning_data_item_id_ => latest_data_item_id_,
                                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       contract_            => contract_,
                                                                       part_no_             => part_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY_ONHAND', 'OWNER', 'OWNERSHIP', 'OWNING_CUSTOMER_NO', 'CATCH_QUANTITY_ONHAND',
                                                                       'AVAILABILTY_CONTROL_ID', 'AVAILABILITY_CONTROL_DESCRIPTION', 'OWNING_CUSTOMER_NAME')) THEN
                  Data_Capture_Invent_Util_API.Add_Details_For_Inv_Stock_Rec(capture_session_id_  => capture_session_id_,
                                                                             owning_data_item_id_ => latest_data_item_id_,
                                                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             contract_            => contract_,
                                                                             part_no_             => part_no_,
                                                                             configuration_id_    => configuration_id_,
                                                                             location_no_         => from_location_no_,
                                                                             lot_batch_no_        => lot_batch_no_,
                                                                             serial_no_           => serial_no_,
                                                                             eng_chg_level_       => eng_chg_level_,
                                                                             waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                                                             activity_seq_        => activity_seq_,
                                                                             handling_unit_id_    => handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROGRAM_ID', 'PROGRAM_DESCRIPTION', 'PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID',
                                                                       'SUB_PROJECT_DESCRIPTION', 'ACTIVITY_ID', 'ACTIVITY_DESCRIPTION')) THEN
                  Data_Capture_Invent_Util_API.Add_Details_For_Activity_Seq(capture_session_id_  => capture_session_id_,
                                                                            owning_data_item_id_ => latest_data_item_id_,
                                                                            data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                            activity_seq_        => activity_seq_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE_DESCRIPTION')) THEN
                  Data_Capture_Invent_Util_API.Add_Condition_Code_Desc(capture_session_id_  => capture_session_id_,
                                                                       owning_data_item_id_ => latest_data_item_id_,
                                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       condition_code_      => condition_code_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('DEL_NOTE_NO', 'DEL_NOTE_STATUS')) THEN

                  del_note_no_ := Handle_Ship_Invent_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                            shipment_id_                => shipment_id_,
                                                                                            source_ref1_                => source_ref1_,
                                                                                            source_ref2_                => source_ref2_,
                                                                                            source_ref3_                => source_ref3_,
                                                                                            source_ref4_                => source_ref4_,
                                                                                            source_ref_type_db_         => source_ref_type_db_,
                                                                                            pick_list_no_               => pick_list_no_,
                                                                                            part_no_                    => part_no_,
                                                                                            configuration_id_           => configuration_id_,
                                                                                            location_no_                => from_location_no_,
                                                                                            lot_batch_no_               => lot_batch_no_,
                                                                                            serial_no_                  => serial_no_,
                                                                                            waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                            eng_chg_level_              => eng_chg_level_,
                                                                                            activity_seq_               => activity_seq_,
                                                                                            handling_unit_id_           => handling_unit_id_,
                                                                                            alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                            receiver_id_                => receiver_id_,
                                                                                            condition_code_             => condition_code_,
                                                                                            column_name_                => 'DELNOTE_NO');

                  del_note_no_ := CASE del_note_no_ WHEN 'NULL' THEN NULL ELSE del_note_no_ END;      -- removing NULL string
                  del_note_no_ := NVL(del_note_no_, Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_)); -- either use delivery note from order reservation or from the shipment
                  Data_Capture_Shpmnt_Util_API.Add_Details_For_Del_Note_No(capture_session_id_  => capture_session_id_,
                                                                           owning_data_item_id_ => latest_data_item_id_,
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           delnote_no_          => del_note_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QTY_PICKED', 'CATCH_QTY', 'QTY_SHIPPED')) THEN
                  Add_Unique_Feedback_Detail___(capture_session_id_         => capture_session_id_,
                                                owning_data_item_id_        => latest_data_item_id_,
                                                data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                                contract_                   => contract_,
                                                source_ref1_                => source_ref1_,
                                                source_ref2_                => source_ref2_,
                                                source_ref3_                => source_ref3_,
                                                source_ref4_                => source_ref4_,
                                                source_ref_type_db_         => source_ref_type_db_,
                                                pick_list_no_               => pick_list_no_,
                                                receiver_id_                => receiver_id_,
                                                part_no_                    => part_no_,
                                                shipment_id_                => shipment_id_,
                                                lot_batch_no_               => lot_batch_no_,
                                                serial_no_                  => serial_no_,
                                                condition_code_             => condition_code_,
                                                configuration_id_           => configuration_id_,
                                                eng_chg_level_              => eng_chg_level_,
                                                waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                activity_seq_               => activity_seq_,
                                                handling_unit_id_           => handling_unit_id_,
                                                alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                from_location_no_           => from_location_no_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('ROUTE_ID', 'ROUTE_DESCRIPTION', 'RECEIVER_DESCRIPTION')) THEN
                  Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_        => capture_session_id_,
                                                                        owning_data_item_id_       => latest_data_item_id_,
                                                                        data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                                                        shipment_id_               => shipment_id_ );
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PACKAGE_COMPONENT')) THEN
                  -- This call/method might need some source_ref_type handling in the future when more sources have been added since this is probably very order specific
                  Add_Package_Component___(capture_session_id_  => capture_session_id_,
                                           owning_data_item_id_ => latest_data_item_id_,
                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                           source_ref4_         => source_ref4_);
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

FUNCTION Get_Sql_Where_Expression(
   capture_process_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   sql_where_expression_ VARCHAR2(400) := ' AND SOURCE_REF_TYPE_DB != ''PURCH_RECEIPT_RETURN'' ';
BEGIN
   IF(capture_process_id_ = 'RETURN_PARTS_FROM_SHIP_INV') THEN
      RETURN NULL;
   ELSE
      RETURN sql_where_expression_;
   END IF;
END Get_Sql_Where_Expression;

-------------------- LU  NEW METHODS -------------------------------------
