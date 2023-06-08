-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptUnpackHuShip
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: UNPACK_PART_FROM_HU_SHIP
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220713  BWITLK  SC2020R1-11155, Added SENDER_TYPE as a feedback item.
--  201120  LEPESE  SC2020R1-10786, modifications in Add_Filter_Key_Detail___, Get_Filter_Keys___, Validate_Data_Item, Execute_Process for Shipment Order. 
--  200917  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Entity_Cud_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171205  SucPlk  STRSC-14936, Reverted the changes for setting automatic value null for GS1 data items.
--  171205  SucPlk  STRSC-14936, Modified Get_Automatic_Data_Item_Value to set automatic value null for GS1 data items.
--  171130  CKumlk  STRSC-14828, Added GTIN to Add_Filter_Key_Detail___.
--  171127  SucPlk  STRSC-14729, Modified Get_Automatic_Data_Item_Value to fetch the value of QTY_TO_UNATTACH when 
--  171127          Use Automatic Value is set to 'Default' in the configuration. 
--  171024  SucPlk  STRSC-12329, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER      := -1;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Feedback_Item___(
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   contract_             IN VARCHAR2,
   shipment_id_          IN NUMBER,
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref3_          IN VARCHAR2,
   source_ref4_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
   pick_list_no_         IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   location_no_          IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   waiv_dev_rej_no_      IN VARCHAR2,
   eng_chg_level_        IN VARCHAR2,
   activity_seq_         IN NUMBER,
   shp_handling_unit_id_ IN NUMBER)
IS
   feedback_item_value_   VARCHAR2(200);
   shipment_line_no_      NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      CASE (data_item_detail_id_)
         WHEN ('QTY_RESERVED') THEN
            feedback_item_value_ := Reserve_Shipment_API.Get_Qty_Reserved(source_ref1_        => source_ref1_,
                                                                          source_ref2_        => source_ref2_,
                                                                          source_ref3_        => source_ref3_,
                                                                          source_ref4_        => source_ref4_,
                                                                          contract_           => contract_,
                                                                          inventory_part_no_  => part_no_,   
                                                                          location_no_        => location_no_,
                                                                          lot_batch_no_       => lot_batch_no_,
                                                                          serial_no_          => serial_no_,
                                                                          eng_chg_level_      => eng_chg_level_,
                                                                          waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                          activity_seq_       => activity_seq_,
                                                                          handling_unit_id_   => shp_handling_unit_id_,
                                                                          configuration_id_   => configuration_id_,
                                                                          pick_list_no_       => pick_list_no_,
                                                                          shipment_id_        => shipment_id_,
                                                                          source_ref_type_db_ => source_ref_type_db_); 
         WHEN ('CATCH_UNIT_MEAS') THEN
            feedback_item_value_ := Inventory_Part_API.Get_Catch_Unit_Meas(contract_, part_no_);
         ELSE
            NULL;
      END CASE;
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => feedback_item_value_);
   $ELSE
      NULL;                                     
   $END
END Add_Feedback_Item___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_          IN NUMBER,
   owning_data_item_id_         IN VARCHAR2,
   data_item_detail_id_         IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   parent_consol_shipment_id_   IN NUMBER,
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2,
   source_ref3_                 IN VARCHAR2,
   source_ref4_                 IN VARCHAR2,
   source_ref_type_db_          IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   activity_seq_                IN NUMBER,
   shp_handling_unit_id_        IN NUMBER,
   shp_sscc_                    IN VARCHAR2,
   shp_alt_handl_unit_label_id_ IN VARCHAR2,
   barcode_id_                  IN NUMBER,
   gtin_no_                     IN VARCHAR2) 
IS
   detail_value_                 VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('SHIPMENT_ID') THEN
            detail_value_ := shipment_id_;
         WHEN ('PARENT_CONSOL_SHIPMENT_ID') THEN
            IF (parent_consol_shipment_id_ != number_all_values_) THEN
               detail_value_ := parent_consol_shipment_id_;
            END IF;
         WHEN ('SHP_HANDLING_UNIT_ID') THEN
            detail_value_ := shp_handling_unit_id_;
         WHEN ('SHP_SSCC') THEN
            IF (shp_sscc_ != string_all_values_) THEN
               detail_value_ := shp_sscc_;
            END IF;
         WHEN ('SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            IF (shp_alt_handl_unit_label_id_ != string_all_values_) THEN
               detail_value_ := shp_alt_handl_unit_label_id_;
            END IF;
         WHEN ('SOURCE_REF1') THEN
            detail_value_ := source_ref1_;
         WHEN ('SOURCE_REF2') THEN
            detail_value_ := source_ref2_;
         WHEN ('SOURCE_REF3') THEN
            IF (source_ref3_ != string_all_values_) THEN
               detail_value_ := source_ref3_;
            END IF;
         WHEN ('SOURCE_REF4') THEN
            IF (source_ref4_ != string_all_values_) THEN
               detail_value_ := source_ref4_;
            END IF;
         WHEN ('SOURCE_REF_TYPE') THEN
            detail_value_ := source_ref_type_db_;
         WHEN ('PICK_LIST_NO') THEN
            detail_value_ := pick_list_no_;
         WHEN ('PART_NO') THEN
            detail_value_ := part_no_;
         WHEN ('CONFIGURATION_ID') THEN
            detail_value_ := configuration_id_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
         WHEN ('LOT_BATCH_NO') THEN
            detail_value_ := lot_batch_no_;
         WHEN ('SERIAL_NO') THEN
            detail_value_ := serial_no_;
         WHEN ('WAIV_DEV_REJ_NO') THEN
            detail_value_ := waiv_dev_rej_no_;
         WHEN ('ENG_CHG_LEVEL') THEN
            detail_value_ := eng_chg_level_;
         WHEN ('ACTIVITY_SEQ') THEN
            detail_value_ := activity_seq_;
         WHEN ('BARCODE_ID') THEN
            detail_value_ := barcode_id_;
         WHEN ('GTIN') THEN
            detail_value_ := gtin_no_;
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


PROCEDURE Get_Filter_Keys___ (
   contract_                     OUT VARCHAR2,
   shipment_id_                  OUT NUMBER,
   parent_consol_shipment_id_    OUT NUMBER,
   source_ref1_                  OUT VARCHAR2,
   source_ref2_                  OUT VARCHAR2,
   source_ref3_                  OUT VARCHAR2,
   source_ref4_                  OUT VARCHAR2,
   source_ref_type_db_           OUT VARCHAR2,
   pick_list_no_                 OUT VARCHAR2,
   part_no_                      OUT VARCHAR2,
   configuration_id_             OUT VARCHAR2,
   location_no_                  OUT VARCHAR2,
   lot_batch_no_                 OUT VARCHAR2,
   serial_no_                    OUT VARCHAR2,
   waiv_dev_rej_no_              OUT VARCHAR2,
   eng_chg_level_                OUT VARCHAR2,
   activity_seq_                 OUT NUMBER,
   shp_handling_unit_id_         OUT NUMBER,
   shp_sscc_                     OUT VARCHAR2,
   shp_alt_handl_unit_label_id_  OUT VARCHAR2,
   barcode_id_                   OUT NUMBER,
   gtin_no_                      OUT VARCHAR2,
   capture_session_id_           IN  NUMBER,
   data_item_id_                 IN  VARCHAR2,
   data_item_value_              IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_            IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_               IN  BOOLEAN  DEFAULT TRUE )
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
      parent_consol_shipment_id_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PARENT_CONSOL_SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      source_ref1_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF1', session_rec_ , process_package_, use_applicable_);
      source_ref2_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF2', session_rec_ , process_package_, use_applicable_);
      source_ref3_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF3', session_rec_ , process_package_, use_applicable_);
      source_ref4_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF4', session_rec_ , process_package_, use_applicable_);
      source_ref_type_db_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SOURCE_REF_TYPE', session_rec_ , process_package_, use_applicable_);
      pick_list_no_                  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PICK_LIST_NO', session_rec_ , process_package_, use_applicable_);
      part_no_                       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      configuration_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      location_no_                   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_                  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_                     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      activity_seq_                  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
      shp_handling_unit_id_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      shp_sscc_                      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_SSCC', session_rec_ , process_package_, use_applicable_);
      shp_alt_handl_unit_label_id_   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      gtin_no_                       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);
      -- Also fetch predicted barcode_id since this process can use barcodes
      barcode_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'BARCODE_ID', session_rec_ , process_package_, use_applicable_);

      -- Add support for alternative shipment handling unit keys
      IF (shp_handling_unit_id_ IS NULL) THEN
         shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(shp_sscc_);
         IF (shp_handling_unit_id_ IS NULL) THEN
            shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(shp_alt_handl_unit_label_id_);
         END IF;
      END IF;
      IF (shp_sscc_ IS NULL) THEN
         shp_sscc_ := Handling_Unit_API.Get_Sscc(shp_handling_unit_id_);
      END IF;
      IF (shp_alt_handl_unit_label_id_ IS NULL) THEN
         shp_alt_handl_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(shp_handling_unit_id_);
      END IF;

      IF (shipment_id_ IS NULL) THEN
         IF (shp_handling_unit_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SHIPMENT_ID');
         ELSE
            shipment_id_ := Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_);  
         END IF;
      END IF;

      -- Add support for attributes that can be null
      IF (source_ref3_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF3', data_item_id_)) THEN
         source_ref3_ := string_all_values_;
      END IF;
       
      IF (source_ref4_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF4', data_item_id_)) THEN
         source_ref4_ := string_all_values_;
      END IF;
       
      IF (parent_consol_shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_CONSOL_SHIPMENT_ID', data_item_id_)) THEN
         parent_consol_shipment_id_ := number_all_values_;
      END IF;
       
      IF (shp_sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_SSCC', data_item_id_)) THEN
         shp_sscc_ := string_all_values_;
      END IF;
      
      IF (shp_alt_handl_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         shp_alt_handl_unit_label_id_ := string_all_values_;
      END IF;

      IF (gtin_no_ IS NULL AND Data_Capture_Invent_Util_API.Gtin_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
         gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      END IF;

      IF ((part_no_ IS NULL) AND (gtin_no_ IS NOT NULL)) THEN
         part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_); 
      END IF;   

      IF (use_unique_values_) THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SHIPMENT_ID');
         END IF;
         IF (parent_consol_shipment_id_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'PARENT_CONSOL_SHIPMENT_ID') THEN
            parent_consol_shipment_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'PARENT_CONSOL_SHIPMENT_ID');
         END IF;
         IF (source_ref1_ IS NULL) THEN
            source_ref1_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF1');
         END IF;
         IF (source_ref2_ IS NULL) THEN
            source_ref2_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF2');
         END IF;
         IF (source_ref3_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'SOURCE_REF3') THEN
            source_ref3_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF3');
         END IF;
         IF (source_ref4_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'SOURCE_REF4') THEN
            source_ref4_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF4');
         END IF;
         IF (pick_list_no_ IS NULL) THEN
            pick_list_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'PICK_LIST_NO');
         END IF;
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'PART_NO');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'LOCATION_NO');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'ACTIVITY_SEQ');
         END IF;
         IF (shp_handling_unit_id_ IS NULL) THEN
            shp_handling_unit_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SHP_HANDLING_UNIT_ID');
         END IF;
         IF (shp_sscc_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'SHP_SSCC') THEN
            shp_sscc_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SHP_SSCC');
         END IF;
         IF (shp_alt_handl_unit_label_id_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            shp_alt_handl_unit_label_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Shpmnt_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, barcode_id_, 'BARCODE_ID');
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Get_Filter_Keys___;

FUNCTION Get_Unique_Data_Item_Value___ (
   capture_session_id_          IN NUMBER,
   contract_                    IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   parent_consol_shipment_id_   IN NUMBER,
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2,
   source_ref3_                 IN VARCHAR2,
   source_ref4_                 IN VARCHAR2,
   source_ref_type_db_          IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   activity_seq_                IN NUMBER,
   shp_handling_unit_id_        IN NUMBER,
   shp_sscc_                    IN VARCHAR2,
   shp_alt_handl_unit_label_id_ IN VARCHAR2,
   barcode_id_                  IN NUMBER,
   wanted_data_item_id_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_               VARCHAR2(200);
   column_name_                VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
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

      ELSIF(wanted_data_item_id_ IN ('SHIPMENT_ID', 'PART_NO', 'PARENT_CONSOL_SHIPMENT_ID', 'PICK_LIST_NO', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 'SOURCE_REF_TYPE', 
                                   'SERIAL_NO', 'LOT_BATCH_NO','CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'LOCATION_NO')) THEN
         IF (wanted_data_item_id_ = 'SOURCE_REF_TYPE') THEN
            column_name_ := 'SOURCE_REF_TYPE_DB';
         ELSIF (wanted_data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN        
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (wanted_data_item_id_ = 'SHP_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (wanted_data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSE
            column_name_ := wanted_data_item_id_;
         END IF;
         unique_value_ := Shipment_Reserv_Handl_Unit_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                    shipment_id_                => shipment_id_,
                                                                                    parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                                    source_ref1_                => source_ref1_,
                                                                                    source_ref2_                => source_ref2_,
                                                                                    source_ref3_                => source_ref3_,
                                                                                    source_ref4_                => source_ref4_,
                                                                                    source_ref_type_db_         => source_ref_type_db_,
                                                                                    pick_list_no_               => pick_list_no_,
                                                                                    part_no_                    => part_no_,
                                                                                    configuration_id_           => configuration_id_,
                                                                                    location_no_                => location_no_,
                                                                                    lot_batch_no_               => lot_batch_no_,
                                                                                    serial_no_                  => serial_no_,
                                                                                    waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                    eng_chg_level_              => eng_chg_level_,
                                                                                    activity_seq_               => activity_seq_,
                                                                                    handling_unit_id_           => shp_handling_unit_id_,
                                                                                    sscc_                       => shp_sscc_,
                                                                                    alt_handling_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                                                                    column_name_                => column_name_,
                                                                                    sql_where_expression_       => NULL); 
      END IF;

      IF (unique_value_ = 'NULL') THEN
         unique_value_ := NULL;
      END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


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
-----------------------------------------------------------------------------
-- Validate_Data_Item() is called everytime a data item is submited in one of
-- scanning clients or from data items fetched and saved by server code. 
-- All needed data item validations shall be added here. The data items can
-- come in any order possible, so the validation cannot be performed until
-- all necessary data items needed for the specific validation is submited.
-- Validations that can be common for several processes in a component can
-- be collected into a utility LU for each component. Other component utility
-- LU's like DataCaptureInventUtil can be used if validations on INVENT data
-- items is needed.
-- If the data_item is an enumeration and have been installed with an 
-- enumuration_package in the postscript this method will get the db-value 
-- of the data item since we are working with db-values on the session line 
-- internally, so exist checks should be Exist_Db variants.
-----------------------------------------------------------------------------
PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2, 
   data_item_value_     IN VARCHAR2 )       
IS
   contract_                    VARCHAR2(5);
   shipment_id_                 NUMBER;
   shipment_line_no_            NUMBER;
   parent_consol_shipment_id_   NUMBER;
   source_ref1_                 VARCHAR2(50);
   source_ref2_                 VARCHAR2(50);
   source_ref3_                 VARCHAR2(50);
   source_ref4_                 VARCHAR2(50);
   source_ref_type_db_          shipment_line_tab.source_ref_type%TYPE;
   shp_handling_unit_id_        NUMBER;
   res_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   pick_list_no_                VARCHAR2(15);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   location_no_                 VARCHAR2(35);
   lot_batch_no_                VARCHAR2(20);
   serial_no_                   VARCHAR2(50);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   activity_seq_                NUMBER;
   gtin_no_                     VARCHAR2(14);
   barcode_id_                  NUMBER;
   input_unit_meas_group_id_    VARCHAR2(30); 
   data_item_description_       VARCHAR2(200);
   column_name_                 VARCHAR2(30);
   mandatory_non_process_key_   BOOLEAN := FALSE;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   qty_attached_                NUMBER;
   catch_quantity_              NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'BARCODE_ID') THEN
         IF (data_item_value_ IS NOT NULL) THEN          
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                            barcode_id_, gtin_no_, capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE); 
         END IF;      
      ELSE
            Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                            barcode_id_, gtin_no_, capture_session_id_, data_item_id_, data_item_value_); 
      END IF;

      IF (data_item_id_ = 'QTY_TO_UNATTACH') THEN
         mandatory_non_process_key_ := TRUE;
      END IF;
      IF (data_item_id_ NOT IN ('BARCODE_ID', 'SOURCE_REF3', 'SOURCE_REF4')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_);
      END IF;

      IF (data_item_id_ IN ('PART_NO','CATCH_QTY_TO_UNATTACH')) THEN
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
         catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_TO_UNATTACH', session_rec_ , process_package_);
         Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                      current_data_item_id_      => data_item_id_,
                                                      part_no_data_item_id_      => 'PART_NO',
                                                      part_no_data_item_value_   => part_no_,
                                                      catch_qty_data_item_id_    => 'CATCH_QTY_TO_UNATTACH',
                                                      catch_qty_data_item_value_ => catch_quantity_,
                                                      positive_catch_qty_        => TRUE);  -- Since this process dont allow normal quantity to be zero or lower it should not allow it for catch quantity either.
      END IF;

      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);

      IF (data_item_id_ IN ('SHIPMENT_ID', 'PART_NO', 'PICK_LIST_NO', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 
                            'SOURCE_REF_TYPE', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 
                            'ACTIVITY_SEQ', 'LOCATION_NO', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
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
            IF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
               column_name_ := 'SOURCE_REF_TYPE_DB';
            ELSIF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'SHP_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            Shipment_Reserv_Handl_Unit_API.Record_With_Column_Value_Exist(contract_                   => contract_,
                                                                          shipment_id_                => shipment_id_,
                                                                          parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                          source_ref1_                => source_ref1_,
                                                                          source_ref2_                => source_ref2_,
                                                                          source_ref3_                => source_ref3_,
                                                                          source_ref4_                => source_ref4_,
                                                                          source_ref_type_db_         => source_ref_type_db_,
                                                                          pick_list_no_               => pick_list_no_,
                                                                          part_no_                    => part_no_,
                                                                          configuration_id_           => configuration_id_,
                                                                          location_no_                => location_no_,
                                                                          lot_batch_no_               => lot_batch_no_,
                                                                          serial_no_                  => serial_no_,
                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                          eng_chg_level_              => eng_chg_level_,
                                                                          activity_seq_               => activity_seq_,
                                                                          handling_unit_id_           => shp_handling_unit_id_,
                                                                          sscc_                       => shp_sscc_,
                                                                          alt_handling_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                                                          column_name_                => column_name_,
                                                                          column_value_               => data_item_value_,
                                                                          column_description_         => data_item_description_,
                                                                          sql_where_expression_       => NULL);
         END IF;      
      ELSIF (data_item_id_ = 'QTY_TO_UNATTACH') THEN
         IF (data_item_value_ <= 0) THEN
            Error_SYS.Record_General(lu_name_,'QTYTOUNATTACHPOSITIVE: Qty to Unattach must be a number greater than 0.');
         END IF;
         
         res_handling_unit_id_ := Shipment_Reserv_Handl_Unit_API.Get_Column_Value_If_Unique(contract_             => contract_,
                                                                                            shipment_id_                => shipment_id_,
                                                                                            parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                                            source_ref1_                => source_ref1_,
                                                                                            source_ref2_                => source_ref2_,
                                                                                            source_ref3_                => source_ref3_,
                                                                                            source_ref4_                => source_ref4_,
                                                                                            source_ref_type_db_         => source_ref_type_db_,
                                                                                            pick_list_no_               => pick_list_no_,
                                                                                            part_no_                    => part_no_,
                                                                                            configuration_id_           => configuration_id_,
                                                                                            location_no_                => location_no_,
                                                                                            lot_batch_no_               => lot_batch_no_,
                                                                                            serial_no_                  => serial_no_,
                                                                                            waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                            eng_chg_level_              => eng_chg_level_,
                                                                                            activity_seq_               => activity_seq_,
                                                                                            handling_unit_id_           => shp_handling_unit_id_,
                                                                                            sscc_                       => shp_sscc_,
                                                                                            alt_handling_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                                                                            column_name_                => 'RESERV_HANDLING_UNIT_ID',
                                                                                            sql_where_expression_       => NULL); 
                                                                                      
         shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
         --qty_attached_ := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(source_ref1_, source_ref2_, source_ref3_, source_ref4_, shipment_id_, shipment_line_no_ , shp_handling_unit_id_);
         qty_attached_ := Shipment_Reserv_Handl_Unit_API.Get_Quantity(source_ref1_, source_ref2_, source_ref3_, source_ref4_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, res_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_, shipment_line_no_, shp_handling_unit_id_);
         IF (qty_attached_ < data_item_value_) THEN
            Error_SYS.Record_General(lu_name_, 'QTYLARGERTHANATTACHED: The :P1 (:P2) is greater than the attached picked qty (:P3).', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_), data_item_value_, qty_attached_);
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
      ELSIF (data_item_id_ = 'INPUT_UOM') THEN            
         IF (data_item_value_ IS NOT NULL) THEN      
            input_unit_meas_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
            Input_Unit_Meas_API.Record_With_Column_Value_Exist(input_unit_meas_group_id_ => input_unit_meas_group_id_,
                                                               column_name_              => 'UNIT_CODE',
                                                               column_value_             => data_item_value_,
                                                               column_description_       => data_item_description_,
                                                               sql_where_expression_     => Get_Input_Uom_Sql_Whr_Exprs___);
         END IF;
      ELSIF (data_item_id_ = 'GTIN') THEN   
         Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      ELSIF data_item_id_ IN ('INPUT_QUANTITY') THEN         
         IF (data_item_value_ <= 0) THEN
            Error_SYS.Record_General(lu_name_,'QUANTITYVALIDATION: Input quantity must be greater than or equal to 0(zero).');
         END IF; 
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Data_Item;


-----------------------------------------------------------------------------
-- Create_List_Of_Values() is called when list of values is asked for by the
-- client or when the data item is set as autopick in the list of values
-- settings in the configuration. All possible LOVs needed is entered here.
-- Remember that the data items can come in any order possible so some of 
-- the items that might be used as filters/where statements may not have a 
-- value yet so you have to code accordingly so either different LOV's 
-- are used or the LOV will have to be able to handle NULL values for some 
-- of the filters.
-- List of values that can be common for several processes in the same
-- component can be collected into a utility LU for the component. Other
-- components utility LU's like DataCaptureInventUtil can be used if its list
-- of values are usable. The specific LOV "implementation methods" should 
-- reside in the same package as where its datasource is defined in.
-- If the data_item is an enumeration and have been installed with an 
-- enumuration_package in the postscript the LOV-method should return the 
-- client-value of the data item. It will the encoded into db-value by 
-- the framework when the value is saved on the session line.
-----------------------------------------------------------------------------
PROCEDURE Create_List_Of_Values (
   capture_session_id_  IN NUMBER,
   capture_process_id_  IN VARCHAR2,
   capture_config_id_   IN NUMBER,
   data_item_id_        IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS
   dummy_contract_              VARCHAR2(5);
   shipment_id_                 NUMBER;
   parent_consol_shipment_id_   NUMBER;
   source_ref1_                 VARCHAR2(50);
   source_ref2_                 VARCHAR2(50);
   source_ref3_                 VARCHAR2(50);
   source_ref4_                 VARCHAR2(50);
   source_ref_type_db_          shipment_line_tab.source_ref_type%TYPE;
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   pick_list_no_                VARCHAR2(15);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   location_no_                 VARCHAR2(35);
   lot_batch_no_                VARCHAR2(20);
   serial_no_                   VARCHAR2(50);
   barcode_id_                  NUMBER;
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   activity_seq_                NUMBER;
   lov_type_db_                 VARCHAR2(20);
   gtin_no_                     VARCHAR2(14);
   input_uom_group_id_          VARCHAR2(30);
   column_name_                 VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'BARCODE_ID') THEN
         Get_Filter_Keys___(dummy_contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                            barcode_id_, gtin_no_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);  
      ELSE
         Get_Filter_Keys___(dummy_contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                            barcode_id_, gtin_no_, capture_session_id_, data_item_id_);      
      END IF;
      
      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
      
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
                         
      ELSIF (data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 'SOURCE_REF_TYPE', 'PART_NO', 'PICK_LIST_NO',
                            'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'LOCATION_NO', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN                              
            IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'SHP_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSE
               column_name_ := data_item_id_;
            END IF;

         Shipment_Reserv_Handl_Unit_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                                shipment_id_                => shipment_id_,
                                                                parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                source_ref1_                => source_ref1_,
                                                                source_ref2_                => source_ref2_,
                                                                source_ref3_                => source_ref3_,
                                                                source_ref4_                => source_ref4_,
                                                                source_ref_type_db_         => source_ref_type_db_,
                                                                pick_list_no_               => pick_list_no_,
                                                                part_no_                    => part_no_,
                                                                configuration_id_           => configuration_id_,
                                                                location_no_                => location_no_,
                                                                lot_batch_no_               => lot_batch_no_,
                                                                serial_no_                  => serial_no_,
                                                                waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                eng_chg_level_              => eng_chg_level_,
                                                                activity_seq_               => activity_seq_,
                                                                handling_unit_id_           => shp_handling_unit_id_,
                                                                sscc_                       => shp_sscc_,
                                                                alt_handling_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                                                capture_session_id_         => capture_session_id_,
                                                                column_name_                => column_name_,
                                                                lov_type_db_                => lov_type_db_,
                                                                sql_where_expression_       => NULL);                                                              
      ELSIF (data_item_id_ IN ('INPUT_UOM')) THEN
         input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
         Input_Unit_Meas_API.Create_Data_Capture_Lov(capture_session_id_, input_uom_group_id_, 'UNIT_CODE', lov_type_db_, Get_Input_Uom_Sql_Whr_Exprs___);
      END IF;
   $ELSE
      NULL;
   $END
   
END Create_List_Of_Values;


-----------------------------------------------------------------------------
-- Get_Automatic_Data_Item_Value() is called from framework when the next
-- configuration data item is fetched. This makes it possible to implement
-- different checks for a specific data item and return an automatic value for
-- it. For example: for a non serial tracked part you can return '*'
-- for SERIAL_NO data item and for a serial tracked part you can return 1 for
-- the data item QUANTITY so that the user doesn't have to enter that data
-- item since quantity is always 1 when dealing with serial tracked parts.
-- Automatic handling that can be common for several processes in the component 
-- should be collected into a utility LU for the component, you can also call 
-- other component utility LU's like DataCaptureInventUtil if you would like to 
-- use their automatic values if it is possible. Automatic handling that uses 
-- "Get Unique functionality" are more of process specific nature and 
-- should be performed in the process LU and not in the component utility LU.
-- If the data_item is an enumeration and have been installed with an 
-- enumuration_package in the postscript this method should return the db-value 
-- of the data item since we are working with db-values on the session line 
-- internally, they will be decoded to client values in the views etc.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                    VARCHAR2(5);
   shipment_id_                 NUMBER;
   parent_consol_shipment_id_   NUMBER;
   source_ref1_                 VARCHAR2(50);
   source_ref2_                 VARCHAR2(50);
   source_ref3_                 VARCHAR2(50);
   source_ref4_                 VARCHAR2(50);
   source_ref_type_db_          shipment_line_tab.source_ref_type%TYPE;
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   pick_list_no_                VARCHAR2(15);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   location_no_                 VARCHAR2(35);
   lot_batch_no_                VARCHAR2(20);
   serial_no_                   VARCHAR2(50);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   activity_seq_                NUMBER;
   automatic_value_             VARCHAR2(200);
   column_name_                 VARCHAR2(30);
   barcode_id_                  NUMBER;
   gtin_no_                     VARCHAR2(14);
   input_uom_                   VARCHAR2(30);
   input_uom_group_id_          VARCHAR2(30);
   input_qty_                   NUMBER;
   input_conv_factor_           NUMBER;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
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
         IF (data_item_id_ IN ('BARCODE_ID', 'QTY_TO_UNATTACH')) THEN
            Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                            barcode_id_, gtin_no_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE); 
         ELSE  
            Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                            barcode_id_, gtin_no_, capture_session_id_, data_item_id_);  
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

         ELSIF (data_item_id_ IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 
                                  'SOURCE_REF_TYPE', 'PART_NO', 'PICK_LIST_NO', 'LOCATION_NO', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 
                                  'ACTIVITY_SEQ', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID', 'QTY_TO_UNATTACH')) THEN
            IF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
               column_name_ := 'SOURCE_REF_TYPE_DB';
            ELSIF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'SHP_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSIF (data_item_id_ = 'QTY_TO_UNATTACH') THEN
               column_name_ := 'QUANTITY';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            automatic_value_ := Shipment_Reserv_Handl_Unit_API.Get_Column_Value_If_Unique(contract_                  => contract_,
                                                                                          shipment_id_                => shipment_id_,
                                                                                          parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                                          source_ref1_                => source_ref1_,
                                                                                          source_ref2_                => source_ref2_,
                                                                                          source_ref3_                => source_ref3_,
                                                                                          source_ref4_                => source_ref4_,
                                                                                          source_ref_type_db_         => source_ref_type_db_,
                                                                                          pick_list_no_               => pick_list_no_,
                                                                                          part_no_                    => part_no_,
                                                                                          configuration_id_           => configuration_id_,
                                                                                          location_no_                => location_no_,
                                                                                          lot_batch_no_               => lot_batch_no_,
                                                                                          serial_no_                  => serial_no_,
                                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                          eng_chg_level_              => eng_chg_level_,
                                                                                          activity_seq_               => activity_seq_,
                                                                                          handling_unit_id_           => shp_handling_unit_id_, 
                                                                                          sscc_                       => shp_sscc_,
                                                                                          alt_handling_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                                                                          column_name_                => column_name_,
                                                                                          sql_where_expression_       => NULL);  
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
            session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            input_uom_   := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
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
         ELSIF (data_item_id_ = 'QTY_TO_UNATTACH') THEN
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
            END IF;
         ELSIF (data_item_id_ = 'CATCH_QTY_TO_UNATTACH') THEN   
            IF (NOT Fnd_Boolean_API.Is_True_Db(Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_))) THEN
               automatic_value_ := 'NULL';
            END IF;
         END IF;
      END IF;
   $END
   RETURN automatic_value_;
   
END Get_Automatic_Data_Item_Value;

-----------------------------------------------------------------------------
-- Add_Details_For_Latest_Item() is called by the framework if any details
-- exist for the current data item in the configuration. The details can be
-- either feedback items or other data items from the process. Details that
-- can be common for several processes in the component can be collected into
-- a utility LU for the component. Other component utility LU's like
-- DataCaptureInventUtil can be called if you would like to use their details. 
-- A lot of standard details, like descriptions, have already been created in
-- INVENT/PURCH/ORDER/SHPORD that can be used.
-----------------------------------------------------------------------------
@UncheckedAccess
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_      IN NUMBER,
   latest_data_item_id_     IN VARCHAR2,
   latest_data_item_value_  IN VARCHAR2 )
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_          Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                      VARCHAR2(5);
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   shp_sscc_                      VARCHAR2(18);
   shp_alt_handl_unit_label_id_   VARCHAR2(25);
   source_ref1_                   VARCHAR2(50);
   source_ref2_                   VARCHAR2(50);
   source_ref3_                   VARCHAR2(50);
   source_ref4_                   VARCHAR2(50);
   source_ref_type_db_            shipment_line_tab.source_ref_type%TYPE;
   shp_handling_unit_id_          NUMBER;
   pick_list_no_                  VARCHAR2(15);
   part_no_                       VARCHAR2(25);
   configuration_id_              VARCHAR2(50);
   location_no_                   VARCHAR2(35);
   lot_batch_no_                  VARCHAR2(20);
   serial_no_                     VARCHAR2(50);
   waiv_dev_rej_no_               VARCHAR2(15);
   eng_chg_level_                 VARCHAR2(6);
   activity_seq_                  NUMBER;
   barcode_id_                    NUMBER;
   gtin_no_                       VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                         location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                         barcode_id_, gtin_no_, capture_session_id_, data_item_id_ => latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE); 

      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );

      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 'SOURCE_REF_TYPE', 
                                                                    'PICK_LIST_NO','PART_NO', 'CONFIGURATION_ID', 'LOCATION_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'WAIV_DEV_REJ_NO', 
                                                                    'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID', 
                                                                    'BARCODE_ID', 'GTIN')) THEN
                  -- FILTER DATA ITEMS AS DETAILS
                  Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                           owning_data_item_id_         => latest_data_item_id_,
                                           data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                           shipment_id_                 => shipment_id_,
                                           parent_consol_shipment_id_   => parent_consol_shipment_id_,
                                           source_ref1_                 => source_ref1_,
                                           source_ref2_                 => source_ref2_,
                                           source_ref3_                 => source_ref3_,
                                           source_ref4_                 => source_ref4_,
                                           source_ref_type_db_          => source_ref_type_db_,
                                           pick_list_no_                => pick_list_no_,
                                           part_no_                     => part_no_,
                                           configuration_id_            => configuration_id_,
                                           location_no_                 => location_no_, 
                                           lot_batch_no_                => lot_batch_no_,
                                           serial_no_                   => serial_no_,
                                           waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                           eng_chg_level_               => eng_chg_level_,
                                           activity_seq_                => activity_seq_,
                                           shp_handling_unit_id_        => shp_handling_unit_id_,
                                           shp_sscc_                    => shp_sscc_,
                                           shp_alt_handl_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                           barcode_id_                  => barcode_id_,
                                           gtin_no_                     => gtin_no_);
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
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'ROW_ID', 'TIER_ID', 'BIN_ID')) THEN
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_    => capture_session_id_,
                                                                           owning_data_item_id_   => latest_data_item_id_,
                                                                           data_item_detail_id_   => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_              => contract_,
                                                                           location_no_           => location_no_); 
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHP_HANDLING_UNIT_TYPE_ID', 'SHP_HANDLING_UNIT_TYPE_DESC', 'SHP_HANDLING_UNIT_TYPE_CATEG_ID',
                                                                       'SHP_HANDLING_UNIT_TYPE_CATEG_DESC', 'SHP_HANDLING_UNIT_TYPE_VOLUME', 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME',
                                                                       'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT', 'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT', 'SHP_HANDLING_UNIT_TYPE_UOM_LENGTH',
                                                                       'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME', 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP', 
                                                                       'SHP_HANDLING_UNIT_TYPE_STACKABLE', 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC', 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL', 
                                                                       'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS', 'SHP_PARENT_HANDLING_UNIT_DESC')) THEN
                  -- Feedback items related to shipment handling unit type
                  Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                              owning_data_item_id_ => latest_data_item_id_,
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              handling_unit_id_    => shp_handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHP_HANDLING_UNIT_WIDTH', 'SHP_HANDLING_UNIT_HEIGHT', 'SHP_HANDLING_UNIT_DEPTH', 
                                                                       'SHP_PARENT_HANDLING_UNIT_ID', 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT', 'SHP_HANDLING_UNIT_MANUAL_VOLUME')) THEN
                  -- Feedback items related to shipment handling unit
                  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                             owning_data_item_id_  => latest_data_item_id_,
                                                                             data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             handling_unit_id_     => shp_handling_unit_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('RECEIVER_DESCRIPTION', 'CREATED_DATE', 'DELIVERY_TERMS', 'SENDER_REFERENCE',
                                                                       'SHIP_INVENTORY_LOCATION_NO', 'RECEIVER_COUNTRY', 'RECEIVER_ADDRESS_ID', 'SHIP_DATE', 
                                                                       'RECEIVER_REFERENCE', 'ROUTE_ID', 'LOAD_SEQUENCE_NO', 'SHIPMENT_TYPE', 'RECIEVER_TYPE',
                                                                       'FORWARD_AGENT_ID', 'RECEIVER_ID', 'SHIP_VIA_CODE', 'SENDER_TYPE')) THEN
                  -- Feedback items related to shipment
                  Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_        => capture_session_id_,
                                                                        owning_data_item_id_       => latest_data_item_id_,
                                                                        data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                                                        shipment_id_               => shipment_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('GTIN_IDENTIFICATION', 'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN
                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       contract_             => contract_,
                                                                       part_no_              => part_no_);                                                                     
               ELSE
                  Add_Feedback_Item___(capture_session_id_        => capture_session_id_,
                                       owning_data_item_id_       => latest_data_item_id_,
                                       data_item_detail_id_       => conf_item_detail_tab_(i).data_item_detail_id,
                                       contract_                  => contract_,
                                       shipment_id_               => shipment_id_,
                                       source_ref1_               => source_ref1_,
                                       source_ref2_               => source_ref2_,
                                       source_ref3_               => source_ref3_,
                                       source_ref4_               => source_ref4_,
                                       source_ref_type_db_        => source_ref_type_db_,
                                       pick_list_no_              => pick_list_no_,
                                       part_no_                   => part_no_,
                                       configuration_id_          => configuration_id_,
                                       location_no_               => location_no_, 
                                       lot_batch_no_              => lot_batch_no_,
                                       serial_no_                 => serial_no_,
                                       waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                       eng_chg_level_             => eng_chg_level_,
                                       activity_seq_              => activity_seq_,
                                       shp_handling_unit_id_      => shp_handling_unit_id_ );

               END IF;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Add_Details_For_Latest_Item;

-----------------------------------------------------------------------------
-- Execute_Process() is called by the framework when a transaction is
-- finished and the API-method shall be executed with the gathered data.
-- A attribute string with all the entered data for the data items is passed
-- as the in parameter attr_. This must be unpacked and used to call the
-- API. There will be one data Set per call even if loops are used.
-- If the data_item is an enumeration and have been installed with an 
-- enumuration_package in the postscript this method will get the db-value 
-- of the data item in the attribute string since we are working with 
-- db-values on the session line internally. Parameter process_message_ will 
-- be passed to this method from Pre_Process_Action.
-- The type of process_message_ is CLOB in WADACO framework but still it is 
-- possible to define it as "VARCHAR2" here in the process but not recomended.
-----------------------------------------------------------------------------
PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY CLOB,
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
   ptr_                         NUMBER;
   name_                        VARCHAR2(50);
   value_                       VARCHAR2(4000);
   shipment_id_                 NUMBER;
   shipment_line_no_            NUMBER;
   shp_handling_unit_id_        NUMBER;
   parent_consol_shipment_id_   NUMBER;
   source_ref1_                 VARCHAR2(50);
   source_ref2_                 VARCHAR2(50);
   source_ref3_                 VARCHAR2(50);
   source_ref4_                 VARCHAR2(50);
   source_ref_type_db_          shipment_line_tab.source_ref_type%TYPE;
   qty_to_unattach_             NUMBER;
   lot_batch_no_                VARCHAR2(20);
   serial_no_                   VARCHAR2(50);
   activity_seq_                NUMBER;
   waiv_dev_rej_no_             VARCHAR2(15);
   pick_list_no_                VARCHAR2(15);
   location_no_                 VARCHAR2(35);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   eng_chg_level_               VARCHAR2(6);
   res_handling_unit_id_        NUMBER;
   catch_qty_to_reassign_       NUMBER;
   shp_sscc_                    VARCHAR2(50);
   shp_alt_handl_unit_label_id_ VARCHAR2(50);
   qty_attached_                NUMBER;   
   qty_shipment_line_           NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SHIPMENT_ID') THEN
         shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SOURCE_REF1') THEN
         source_ref1_ := value_;
      ELSIF (name_ = 'SOURCE_REF2') THEN
         source_ref2_ := value_;
      ELSIF (name_ = 'SOURCE_REF3') THEN
         source_ref3_ := value_;
      ELSIF (name_ = 'SOURCE_REF4') THEN
         source_ref4_ := value_;
      ELSIF (name_ = 'SOURCE_REF_TYPE') THEN
         source_ref_type_db_ := value_;
      ELSIF (name_ = 'SHP_HANDLING_UNIT_ID') THEN
         shp_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SHP_SSCC') THEN
         shp_sscc_ := value_;
      ELSIF (name_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
         shp_alt_handl_unit_label_id_ := value_;
      ELSIF (name_ = 'PARENT_CONSOL_SHIPMENT_ID') THEN
         parent_consol_shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'PICK_LIST_NO') THEN
         pick_list_no_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_;
      ELSIF (name_ = 'QTY_TO_UNATTACH') THEN
         qty_to_unattach_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SERIAL_NO') THEN
         serial_no_ := value_;
      ELSIF (name_ = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_;
      ELSIF (name_ = 'ACTIVITY_SEQ') THEN
         activity_seq_ := value_;
      ELSIF (name_ = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_;
      ELSIF (name_ = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_;
      END IF;
   END LOOP; 

   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(
                                                     shipment_id_,
                                                     source_ref1_,
                                                     source_ref2_,
                                                     Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3),
                                                     Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4),
                                                     source_ref_type_db_);
   
   res_handling_unit_id_ := Shipment_Reserv_Handl_Unit_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                      shipment_id_                => shipment_id_,
                                                                                      parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                                      source_ref1_                => source_ref1_,
                                                                                      source_ref2_                => source_ref2_,
                                                                                      source_ref3_                => source_ref3_,
                                                                                      source_ref4_                => source_ref4_,
                                                                                      source_ref_type_db_         => source_ref_type_db_,
                                                                                      pick_list_no_               => pick_list_no_,
                                                                                      part_no_                    => part_no_,
                                                                                      configuration_id_           => configuration_id_,
                                                                                      location_no_                => location_no_,
                                                                                      lot_batch_no_               => lot_batch_no_,
                                                                                      serial_no_                  => serial_no_,
                                                                                      waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                      eng_chg_level_              => eng_chg_level_,
                                                                                      activity_seq_               => activity_seq_,
                                                                                      handling_unit_id_           => shp_handling_unit_id_,
                                                                                      sscc_                       => shp_sscc_,
                                                                                      alt_handling_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                                                                      column_name_                => 'RESERV_HANDLING_UNIT_ID',
                                                                                      sql_where_expression_       => NULL); 
                                                                                    
   qty_shipment_line_ := Shipment_Line_Handl_Unit_API.Get_Shipment_Line_Quantity(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   qty_attached_      := Shipment_Reserv_Handl_Unit_API.Get_Quantity(source_ref1_, source_ref2_, source_ref3_, source_ref4_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, res_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_, shipment_line_no_, shp_handling_unit_id_);            
      
   IF(serial_no_ != '*' OR eng_chg_level_ != '1') THEN
      Shipment_Reserv_Handl_Unit_Api.Remove(source_ref1_, source_ref2_, source_ref3_, source_ref4_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, res_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_, shipment_line_no_, shp_handling_unit_id_);            
      Shipment_Line_Handl_Unit_API.Reduce_Quantity(shipment_id_, shipment_line_no_, shp_handling_unit_id_, qty_to_unattach_);
   ELSE
      IF (qty_shipment_line_ != qty_attached_) THEN
         IF (qty_to_unattach_ != qty_attached_) THEN
            Shipment_Reserv_Handl_Unit_API.Reduce_Quantity(source_ref1_, source_ref2_, source_ref3_, source_ref4_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, res_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_, shipment_line_no_, shp_handling_unit_id_, qty_to_unattach_, catch_qty_to_reassign_);
            Shipment_Line_Handl_Unit_API.Reduce_Quantity(shipment_id_, shipment_line_no_, shp_handling_unit_id_, qty_to_unattach_);
         ELSE
            Shipment_Reserv_Handl_Unit_Api.Remove(source_ref1_, source_ref2_, source_ref3_, source_ref4_ , contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, res_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_, shipment_line_no_, shp_handling_unit_id_);
            Shipment_Line_Handl_Unit_API.Reduce_Quantity(shipment_id_, shipment_line_no_, shp_handling_unit_id_, qty_to_unattach_);
         END IF;  
      ELSE   
         IF (qty_to_unattach_ != qty_attached_) THEN
            Shipment_Line_Handl_Unit_API.Reduce_Quantity(shipment_id_, shipment_line_no_, shp_handling_unit_id_, qty_to_unattach_);
         ELSE
            Shipment_Line_Handl_Unit_API.Remove(shipment_id_, shipment_line_no_, shp_handling_unit_id_, FALSE);
         END IF;
      END IF;
   END IF;
   
END Execute_Process;

-----------------------------------------------------------------------------
-- Get_Process_Execution_Message() is called from the framework when a
-- process is about to finish and after the call to Execute_Process. 
-- This method returns the message that is show to the user when a API-call 
-- has succeded without errors. no_of_records_handled_ is used i.e. to 
-- determine if one or multiple records have been saved.
-- This method is receiving the process message parameter that is sent from 
-- Execute_Process this can be used to send extra information from the 
-- Execute Process code, like for example which object id was saved etc.
-- The type of process_message_ is CLOB in WADACO framework but still it is 
-- possible to define it as "VARCHAR2" here in the process but not recomended.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
IS
   message_               VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'UNPACKOK: The reservation was unpacked from the Handling Unit.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'UNPACKSOK: :P1 reservations were unpacked from the Handling Units.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;

-----------------------------------------------------------------------------
-- Is_Process_Available() is called from several places in the framework to
-- makes sure that process is installed correctly and that the final API
-- method is available. The method should check the executing API-method
-- (the same method that is called in Execute_Process())with a call to
-- Security_SYS.Is_Method_Available and return the result as a FndBoolean.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Shipment_Line_Handl_Unit_API.Remove is granted thru following projection/CRUD
   IF (Security_SYS.Is_Proj_Entity_Cud_Available('ShipmentHandlingUnitStructureHandling', 'ShipmentLineHandlUnit')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


-----------------------------------------------------------------------------
-- Fixed_Value_Is_Applicable() is called for data items that has the option
-- "When applicable" is set on Use fixed value in the configuration.
-- Return TRUE for the data items where using a fixed value is applicable.
-- If this method calls Data_Capture_Session_API.Get_Predicted_Data_Item_Value 
-- directly or indirectly make sure that it sends parameter use_applicable_ 
-- as FALSE to avoid recursive loops, since that method will call this method 
-- for some data items if they are set to use fixed value when applicable.
-------------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   fixed_value_is_applicable_   BOOLEAN := FALSE;
   local_data_item_id_          VARCHAR2(50);
   process_package_             VARCHAR2(30);
   part_no_                     VARCHAR2(25);
   serial_no_                   VARCHAR2(50);
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);

      IF (data_item_id_ = 'QTY_TO_UNATTACH') THEN
         local_data_item_id_ := 'QUANTITY';
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
         END IF;
      ELSE
         local_data_item_id_ := data_item_id_;
      END IF;
      fixed_value_is_applicable_ := Data_Capture_Shpmnt_Util_API.Fixed_Value_Is_Applicable(capture_session_id_ => capture_session_id_,
                                                                                           data_item_id_       => local_data_item_id_,
                                                                                           part_no_            => part_no_,
                                                                                           serial_no_          => serial_no_);
   $END
   RETURN fixed_value_is_applicable_;
END Fixed_Value_Is_Applicable;
