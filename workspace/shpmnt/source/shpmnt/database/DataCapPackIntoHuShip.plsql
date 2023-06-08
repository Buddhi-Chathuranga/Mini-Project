----------------------------------------------------------------------------
--
--  Logical unit: DataCapPackIntoHuShip 
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: PACK_INTO_HANDLING_UNIT_SHIP
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220713  BWITLK  SC2020R1-11155, Added SENDER_TYPE as a feedback item. 
--  201120  LEPESE  SC2020R1-10727, modifications in Get_Filter_Keys___, Add_Filter_Key_Detail___, Execute_Process to support Shipment Order.
--  200902  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available/Is_Proj_Entity_Act_Available in Is_Process_Available to support new projection security concept.
--  200525  RoJalk  SC2020R1-2201, Modified calls to Shipment_Handling_Utility_API.Get_Packing_Qty_Deviation to pass the source ref type as a parameter.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory.
--  171219  SURBLK  STRSC-14943, Added support for Nullable Source Ref4 in Create_List_Of_Values, Get_Unique_Data_Item_Value___, Validate_Data_Item.
--  171206  MaAuse  STRSC-15087, Modified Execute_Process by adding condition for call to Handling_Unit_API.Check_Max_Capacity_Exceeded.
--  171130  CKumlk  STRSC-14828, Added GTIN to Add_Filter_Key_Detail___.
--  171124  MaAuse  STRSC-14357, Modified Execute_Process by adding call to Handling_Unit_API.Check_Max_Capacity_Exceeded.
--  171120  MaAuse  STRSC-14470, Modified Execute_Process by adding parameter error_at_max_hu_capacity_.
--  171025  DaZase  STRSC-13032, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171025          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  171019  SURBLK  STRSC-11723 Moved sh_sql_where_expression_ from ShipmentSourceUtility to DataCapPackIntoHuShip to support for the multiple processes.
--  170925  SWiclk  STRSC-11282, Implemented GTIN support, hence handled GTIN, INPUT_UOM and INPUT_QUANTITY data items and INPUT_CONV_FACTOR as feedback item
--  170925          and GTIN_IS_MANDATORY as detail item. Added Get_Input_Uom_Sql_Whr_Exprs___() and added GTIN to Get_Filter_Keys___().
--  170424  KhVese  LIM-9870, Removed call to Get_Filter_Keys___ and Get_Unique_Data_Item_Value___ in Fixed_Value_Is_Applicable to avoide recursive calls to the method. .
--  170419  DaZase  LIM-10662, Changes in Get_Filter_Keys___ on how Bug 132004 was solved, now we check if inventory barcode is enabled correctly. 
--  170303  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170223  MaIklk  LIM-9422, Fixed to pass source_ref_type as parameter when calling ShipmentReservHandlUnit methods.
--  170217  DaZase  Moved out handling unit check in Get_Handling_Unit_Filters___ and added it only to those places that are not calling Handling_Unit_API methods.
--  170131  SWiclk  Bug 132004, Modified Get_Filter_Keys___() in order to check whether Barcode Id is mandatory or not before trying to fetch a unique value. 
--  170127  MaIklk  LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  170113  DaZase  LIM-8660, Added a catch quantity validation in Validate_Data_Item and removed some of the old checks.  
--  161129  ThEdlk  Bug 132704, Modified Execute_Process() by directly fetching sales quantity from the method shipment_handling_utility_api.Get_Converted_Source_Qty().
--  161128  MaIklk  LIM-9255, Fixed to directly access ShipmentReservHandlUnit since it is moved to SHPMNT.
--  161122  ThEdlk  Bug 132704, Modified Execute_Process() by passsing sales quantity to Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing()
--  161122          in order to save sales quantity in shipment_line_handl_unit_tab. Also modified Get_Automatic_Data_Item_Value() by passing TRUE
--  161122          for use_unique_values_ when data_item_id is not in barcode_id in order to fetch unique_data_item_value when the values are null.
--  161108  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161116  MaIklk  LIM-9232, Used Reserve_Shipment_API.Get_Qty_Reserved instead of calling shipment source utility function. 
--  161108  Erlise  LIM-2933, Modified Create_List_Of_Values(), Get_Automatic_Data_Item_Value(), Validate_Data_Item().
--  161028  RoJalk  LIM-9424, Moved Get_Tot_Packing_Qty_Deviation from Shipment_Handling_Utility_API to Shipment_API.
--  160930  SWiclk  Bug 131288, Modified Get_Unique_Data_Item_Value___(), Create_List_Of_Values(), Get_Automatic_Data_Item_Value() and Validate_Data_Item()
--  160930          in order to handle 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID' separately from Handling_Unit_API.
--  160829  DaZase  LIM-8334, Moved this process from ORDER to SHPMNT, adapted it to all changed and renamed items etc.
--  160725  RoJalk  LIM-8142, Replaced Shipment_Line_API.Connected_Lines_Exist with Shipment_API.Connected_Lines_Exist.
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160427  RoJalk  LIM-7267, Changed the parameter order of Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing.
--  160219  SWiclk  Bug 127172, Modified Validate_Data_Item() in order to check Barcode_ID is mandatory if configured in process detail.
--  160217  JeLise  LIM-6223, Added 0 for handling_unit_id in calls to Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment.
--  160212  RoJalk  LIM-5934, Removed order info parameters from Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing.
--  160209  DaZase  LIM-6226, Renamed feedback item SHIP_ADDR_NO to RECEIVER_ADDRESS_ID.
--  160201  DaZase  LIM-4480, Added more validations on QTY_TO_ATTACH/CATCH_QTY_TO_ATTACH.
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151116  JeLise  LIM-4457, Removed pallet_id in calls to Shipment_Reserv_Handl_Unit_API.
--  151110  SWiclk  STRSC-317, Modified Validate_Data_Item() in order to handle Numeric or value error when validating CATCH_QTY_TO_ATTACH.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151109  MaEelk  LIM-4453, Removed pallet_id from Customer_Order_Reservation_API method calls
--  151028  Erlise  LIM-3778, Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID.
--  151027  DaZase  LIM-4297, Changed calls to Add_Details_For_Hand_Unit_Type and Add_Details_For_Handling_Unit 
--  151027          so they now call Data_Capture_Invent_Util_API instead of Data_Capture_Order_Util_API.                  
--  151006  MaEelk  LIM-3579, Replaced the usage of Handling_Unit_API.Get_Top_Shipment_Id with Handling_Unit_API.Get_Shipment_Id
--  150908  RILASE  AFT-3873, Changed catch qty validation to use get value if unique.
--  150901  DaZase  AFT-2992, Added barcode_id implementation in this process.
--  150413  RILASE  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
string_all_values_ CONSTANT VARCHAR2(1) := '%';
number_all_values_ CONSTANT NUMBER := -1;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
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
   res_handling_unit_id_         OUT NUMBER,
   res_sscc_                     OUT VARCHAR2,
   res_alt_handl_unit_label_id_  OUT VARCHAR2,
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
   res_handling_unit_id_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
   res_sscc_                      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_SSCC', session_rec_ , process_package_, use_applicable_);
   res_alt_handl_unit_label_id_   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
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
      -- Add support for alternative inventory/reservation handling unit keys
   IF (res_handling_unit_id_ IS NULL) THEN
      res_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(res_sscc_);
      IF (res_handling_unit_id_ IS NULL) THEN
         res_handling_unit_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(res_alt_handl_unit_label_id_);
      END IF;
   END IF;
   IF (res_sscc_ IS NULL AND res_handling_unit_id_ IS NOT NULL AND res_handling_unit_id_ != number_all_values_) THEN
      res_sscc_ := Handling_Unit_API.Get_Sscc(res_handling_unit_id_);
   END IF;
   IF (res_alt_handl_unit_label_id_ IS NULL AND res_handling_unit_id_ IS NOT NULL AND res_handling_unit_id_ != number_all_values_) THEN
      res_alt_handl_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(res_handling_unit_id_);
   END IF;

   IF (shipment_id_ IS NULL) THEN
      IF (shp_handling_unit_id_ IS NULL AND res_handling_unit_id_ IS NOT NULL) THEN
         shipment_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SHIPMENT_ID');
      ELSIF (shp_handling_unit_id_ IS NOT NULL AND res_handling_unit_id_ IS NULL) THEN
         shipment_id_ := Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_);
      ELSE
         shipment_id_ := Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_);  -- NOTE: maybe we should investigate which one of the HU that comes first in config and make that one control this else part
      END IF;
   END IF;

   /*IF (res_handling_unit_id_ IS NULL AND 
       NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RES_HANDLING_UNIT_ID', data_item_id_)) THEN
      res_handling_unit_id_ := number_all_values_;
   END IF;*/
   -- if sscc_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
   -- so we need to specifiy that we have to compare to all sscc in the table
   IF (res_sscc_ IS NULL AND 
       NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RES_SSCC', data_item_id_)) THEN
      res_sscc_ := string_all_values_;
   END IF;
   -- if alt_handling_unit_label_id_ comes after current data item, we exchange the parameter with % since this column in the view can be NULL 
   -- so we need to specifiy that we have to compare to all alternative handling unit label ids in the table
   IF (res_alt_handl_unit_label_id_ IS NULL AND 
       NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'RES_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
      res_alt_handl_unit_label_id_ := string_all_values_;
   END IF;

   IF (source_ref3_ IS NULL AND 
       NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF3', data_item_id_)) THEN
      source_ref3_ := string_all_values_;
   END IF;

   IF (source_ref4_ IS NULL AND 
       NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SOURCE_REF4', data_item_id_)) THEN
      source_ref4_ := string_all_values_;
   END IF;
   -- Add support for attributes that can be null
   IF (parent_consol_shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PARENT_CONSOL_SHIPMENT_ID', data_item_id_)) THEN
      parent_consol_shipment_id_ := number_all_values_;
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
         shipment_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SHIPMENT_ID');
      END IF;
      IF (parent_consol_shipment_id_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'PARENT_CONSOL_SHIPMENT_ID') THEN
         parent_consol_shipment_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'PARENT_CONSOL_SHIPMENT_ID');
      END IF;
      IF (source_ref1_ IS NULL) THEN
         source_ref1_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF1');
      END IF;
      IF (source_ref2_ IS NULL) THEN
         source_ref2_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF2');
      END IF;
      IF (source_ref3_ IS NULL) THEN
         source_ref3_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF3');
      END IF;
      IF (source_ref4_ IS NULL) THEN
         source_ref4_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SOURCE_REF4');
      END IF;
      IF (pick_list_no_ IS NULL) THEN
         pick_list_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'PICK_LIST_NO');
      END IF;
      IF (part_no_ IS NULL) THEN
         part_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'PART_NO');
      END IF;
      IF (configuration_id_ IS NULL) THEN
         configuration_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'CONFIGURATION_ID');
      END IF;
      IF (location_no_ IS NULL) THEN
         location_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'LOCATION_NO');
      END IF;
      IF (lot_batch_no_ IS NULL) THEN
         lot_batch_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'LOT_BATCH_NO');
      END IF;
      IF (serial_no_ IS NULL) THEN
         serial_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SERIAL_NO');
      END IF;
      IF (waiv_dev_rej_no_ IS NULL) THEN
         waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'WAIV_DEV_REJ_NO');
      END IF;
      IF (eng_chg_level_ IS NULL) THEN
         eng_chg_level_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'ENG_CHG_LEVEL');
      END IF;
      IF (activity_seq_ IS NULL) THEN
         activity_seq_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'ACTIVITY_SEQ');
      END IF;
      IF (shp_handling_unit_id_ IS NULL) THEN
         shp_handling_unit_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SHP_HANDLING_UNIT_ID');
      END IF;
      IF (shp_sscc_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'SHP_SSCC') THEN
         shp_sscc_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SHP_SSCC');
      END IF;
      IF (shp_alt_handl_unit_label_id_ IS NULL) AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
         shp_alt_handl_unit_label_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID');
      END IF;
      IF (res_handling_unit_id_ IS NULL) THEN
         res_handling_unit_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'RES_HANDLING_UNIT_ID');
      END IF;
      IF (barcode_id_ IS NULL AND Data_Capture_Shpmnt_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
         barcode_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 'BARCODE_ID');
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
   res_handling_unit_id_        IN NUMBER,
   res_sscc_                    IN VARCHAR2,
   res_alt_handl_unit_label_id_ IN VARCHAR2,
   barcode_id_                  IN NUMBER,
   wanted_data_item_id_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_               VARCHAR2(200);
   hu_sql_where_expression_    VARCHAR2(2000);
   local_shipment_id_          NUMBER;
   local_shp_handling_unit_id_ NUMBER;
   local_shp_sscc_             VARCHAR2(18);
   local_alt_hu_label_id_      VARCHAR2(25);
   dummy_                      BOOLEAN;
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


   ELSIF (wanted_data_item_id_ IN ('SHIPMENT_ID', 'PART_NO', 'PICK_LIST_NO', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 'SOURCE_REF_TYPE', 
                                   'SERIAL_NO', 'LOT_BATCH_NO','CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'LOCATION_NO',
                                   'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN
      IF (wanted_data_item_id_ = 'SOURCE_REF_TYPE') THEN
         column_name_ := 'SOURCE_REF_TYPE_DB';
      ELSIF (wanted_data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN        
         column_name_ := 'HANDLING_UNIT_ID';
      ELSIF (wanted_data_item_id_ = 'RES_SSCC') THEN
         column_name_ := 'SSCC';
      ELSIF (wanted_data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
         column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
      ELSE
         column_name_ := wanted_data_item_id_;
      END IF;
      unique_value_ := Shipment_Source_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
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
                                                                              handling_unit_id_           => res_handling_unit_id_,
                                                                              sscc_                       => res_sscc_,
                                                                              alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                              column_name_                => column_name_,
                                                                              sql_where_expression_       => NULL); 
   
   ELSIF (wanted_data_item_id_ IN ('PARENT_CONSOL_SHIPMENT_ID')) THEN
      local_shipment_id_          := shipment_id_;
      local_shp_handling_unit_id_ := shp_handling_unit_id_;
      local_shp_sscc_             := shp_sscc_;
      local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
      Get_Handling_Unit_Filters___(local_shipment_id_,local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, wanted_data_item_id_);      
      hu_sql_where_expression_ := hu_sql_where_expression_ || ' AND handling_unit_id IS NOT NULL ';
      unique_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                               contract_                   => contract_,
                                                               shipment_id_                => shipment_id_,
                                                               handling_unit_id_           => local_shp_handling_unit_id_,
                                                               parent_consol_shipment_id_  => shp_handling_unit_id_,
                                                               sscc_                       => local_shp_sscc_,
                                                               alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                               column_name_                => wanted_data_item_id_,
                                                               sql_where_expression_       => hu_sql_where_expression_,
                                                               cursor_id_                  => 2);
   
   ELSIF (wanted_data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
      local_shipment_id_          := shipment_id_;
      local_shp_handling_unit_id_ := shp_handling_unit_id_;
      local_shp_sscc_             := shp_sscc_;
      local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
      Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, wanted_data_item_id_);
      IF (wanted_data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
         column_name_ := 'HANDLING_UNIT_ID';
      ELSIF (wanted_data_item_id_ = 'SHP_SSCC') THEN
         column_name_ := 'SSCC';
      ELSIF (wanted_data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
         column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';      
      END IF;      
      unique_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,                                                                    
                                                                    handling_unit_id_           => shp_handling_unit_id_,
                                                                    shipment_id_                => local_shipment_id_,
                                                                    sscc_                       => local_shp_sscc_,
                                                                    alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                                    column_name_                => column_name_,
                                                                    source_ref1_                => NULL,
                                                                    source_ref2_                => NULL,
                                                                    source_ref3_                => NULL,
                                                                    source_ref_type_db_         => NULL,
                                                                    sql_where_expression_       => hu_sql_where_expression_);
   END IF;
   IF (unique_value_ = 'NULL') THEN
      unique_value_ := NULL;
   END IF;
$END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


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
   shp_handling_unit_id_ IN NUMBER,
   res_handling_unit_id_ IN NUMBER )
IS
   feedback_item_value_   VARCHAR2(200);
   qty_left_to_assign_    NUMBER;
   shipment_line_no_      NUMBER;
   ship_line_rec_         Shipment_Line_API.Public_Rec;
BEGIN
$IF Component_Wadaco_SYS.INSTALLED $THEN
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   CASE (data_item_detail_id_)
   WHEN ('SALES_QUANTITY_TO_ATTACH') THEN
      feedback_item_value_ := Shipment_Line_Handl_Unit_API.Get_Reserv_Qty_Left_To_Assign(shipment_id_, shipment_line_no_, shp_handling_unit_id_);
   WHEN ('INV_QUANTITY_TO_ATTACH') THEN
      ship_line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
      qty_left_to_assign_   := Shipment_Line_Handl_Unit_API.Get_Reserv_Qty_Left_To_Assign(shipment_id_, shipment_line_no_, shp_handling_unit_id_);
      feedback_item_value_  := qty_left_to_assign_ * ship_line_rec_.conv_factor/ship_line_rec_.inverted_conv_factor;
   WHEN ('INV_QUANTITY_ATTACHED') THEN
      feedback_item_value_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, 
                                                                                     current_data_item_id_ => owning_data_item_id_, 
                                                                                     current_data_item_value_ => NULL, 
                                                                                     wanted_data_item_id_ => 'QUANTITY_TO_ATTACH'); 
   WHEN ('REMAINING_PARCEL_QTY') THEN
      qty_left_to_assign_  := Shipment_Line_Handl_Unit_API.Get_Reserv_Qty_Left_To_Assign(shipment_id_, shipment_line_no_, shp_handling_unit_id_);
      feedback_item_value_ := (qty_left_to_assign_ - NVL(Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(source_ref1_             => source_ref1_,
                                                                                                                 source_ref2_             => NVL(source_ref2_,'*'),
                                                                                                                 source_ref3_             => NVL(source_ref3_,'*'),
                                                                                                                 source_ref4_             => NVL(source_ref4_,'*'),
                                                                                                                 source_ref_type_db_      => source_ref_type_db_,
                                                                                                                 contract_                => contract_,
                                                                                                                 part_no_                 => part_no_,
                                                                                                                 location_no_             => location_no_,
                                                                                                                 lot_batch_no_            => lot_batch_no_,
                                                                                                                 serial_no_               => serial_no_,
                                                                                                                 eng_chg_level_           => eng_chg_level_,
                                                                                                                 waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                                                                                 activity_seq_            => activity_seq_,
                                                                                                                 reserv_handling_unit_id_ => res_handling_unit_id_,
                                                                                                                 configuration_id_        => configuration_id_,
                                                                                                                 pick_list_no_            => pick_list_no_,
                                                                                                                 shipment_id_             => shipment_id_),0));
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
                                                                    handling_unit_id_   => res_handling_unit_id_,
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
   res_handling_unit_id_        IN NUMBER,
   res_sscc_                    IN VARCHAR2,
   res_alt_handl_unit_label_id_ IN VARCHAR2,
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
      IF (shp_handling_unit_id_ != number_all_values_) THEN
         detail_value_ := shp_handling_unit_id_;
      END IF;
   WHEN ('SHP_SSCC') THEN
      IF (shp_sscc_ != string_all_values_) THEN
         detail_value_ := shp_sscc_;
      END IF;
   WHEN ('SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
      IF (shp_alt_handl_unit_label_id_ != string_all_values_) THEN
         detail_value_ := shp_alt_handl_unit_label_id_;
      END IF;
   WHEN ('RES_HANDLING_UNIT_ID') THEN
      IF (res_handling_unit_id_ != number_all_values_) THEN
         detail_value_ := res_handling_unit_id_;
      END IF;
   WHEN ('RES_SSCC') THEN
      IF (res_sscc_ != string_all_values_) THEN
         detail_value_ := res_sscc_;
      END IF;
   WHEN ('RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
      IF (res_alt_handl_unit_label_id_ != string_all_values_) THEN
         detail_value_ := res_alt_handl_unit_label_id_;
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


PROCEDURE Get_Handling_Unit_Filters___(
   shipment_id_                 IN OUT NUMBER,
   shp_handling_unit_id_        IN OUT NUMBER,
   shp_sscc_                    IN OUT VARCHAR2,
   shp_alt_handl_unit_label_id_ IN OUT VARCHAR2,
   sql_where_expression_        IN OUT VARCHAR2,
   capture_session_id_          IN     NUMBER,
   data_item_id_                IN     VARCHAR2 )
IS
   capture_process_id_ VARCHAR2(50);
   capture_config_id_  NUMBER;
   contract_           VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      capture_process_id_ := Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_);
      capture_config_id_  := Data_Capture_Session_API.Get_Capture_Config_Id(capture_session_id_);
      contract_           := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_);

      IF (shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_, capture_config_id_, 'SHIPMENT_ID', data_item_id_)) THEN
         shipment_id_ := number_all_values_;
      END IF;
      IF (shp_handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_, capture_config_id_, 'SHP_HANDLING_UNIT_ID', data_item_id_)) THEN
         shp_handling_unit_id_ := number_all_values_;
      END IF;
      IF (shp_sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_, capture_config_id_, 'SHP_SSCC', data_item_id_)) THEN
         shp_sscc_ := string_all_values_;
      END IF;
      IF (shp_alt_handl_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_, capture_config_id_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         shp_alt_handl_unit_label_id_ := string_all_values_;
      END IF;
   $END

   sql_where_expression_ := ' AND shipment_id      IS NOT NULL
                              AND Shipment_API.Get_Objstate(shipment_id)                        = ''Preliminary'' 
                              AND Shipment_API.Connected_Lines_Exist(shipment_id)               = 1 
                              AND Shipment_API.Get_Tot_Packing_Qty_Deviation(shipment_id) > 0
                              AND Shipment_API.Get_Contract(shipment_id) = ''' || contract_ || ''' ';

END Get_Handling_Unit_Filters___;

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
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PACKOK: The reservation was packed into the Handling Unit.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PACKSOK: :P1 reservations were packed into the Handling Units.', NULL, no_of_records_handled_);
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
   session_rec_               Data_Capture_Common_Util_API.Session_Rec;
   ptr_                       NUMBER;
   name_                      VARCHAR2(50);
   value_                     VARCHAR2(4000);
   shipment_id_               NUMBER;
   shipment_line_no_          NUMBER;
   source_ref1_               VARCHAR2(50);
   source_ref2_               VARCHAR2(50);
   source_ref3_               VARCHAR2(50);
   source_ref4_               VARCHAR2(50);
   source_ref_type_db_        shipment_line_tab.source_ref_type%TYPE;
   shp_handling_unit_id_      NUMBER;
   res_handling_unit_id_      NUMBER;
   quantity_to_be_added_      NUMBER;
   catch_qty_to_reassign_     NUMBER;
   pick_list_no_              VARCHAR2(15);
   part_no_                   VARCHAR2(25);
   configuration_id_          VARCHAR2(50);
   location_no_               VARCHAR2(35);
   lot_batch_no_              VARCHAR2(20);
   serial_no_                 VARCHAR2(50);
   waiv_dev_rej_no_           VARCHAR2(15);
   eng_chg_level_             VARCHAR2(6);
   activity_seq_              NUMBER;
   sales_qty_to_be_added_     NUMBER;
   max_weight_volume_error_   VARCHAR2(5);

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      ptr_ := NULL;
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
         ELSIF (name_ = 'PART_NO') THEN
            part_no_ := value_;
         ELSIF (name_ = 'LOCATION_NO') THEN
            location_no_ := value_;
         ELSIF (name_ = 'LOT_BATCH_NO') THEN
            lot_batch_no_ := value_;
         ELSIF (name_ = 'SERIAL_NO') THEN
            serial_no_ := value_;
         ELSIF (name_ = 'ENG_CHG_LEVEL') THEN
            eng_chg_level_ := value_;
         ELSIF (name_ = 'WAIV_DEV_REJ_NO') THEN
            waiv_dev_rej_no_ := value_;
         ELSIF (name_ = 'ACTIVITY_SEQ') THEN
            activity_seq_ := value_;
         ELSIF (name_ = 'CONFIGURATION_ID') THEN
            configuration_id_ := value_;
         ELSIF (name_ = 'PICK_LIST_NO') THEN
            pick_list_no_ := value_;
         ELSIF (name_ = 'SHIPMENT_ID') THEN
            shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'SHP_HANDLING_UNIT_ID') THEN
            shp_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'RES_HANDLING_UNIT_ID') THEN
            res_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'QTY_TO_ATTACH') THEN
            quantity_to_be_added_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CATCH_QTY_TO_ATTACH') THEN
            catch_qty_to_reassign_ := Client_SYS.Attr_Value_To_Number(value_);
         END IF;
      END LOOP;
      
      shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(
                                                     shipment_id_,
                                                     source_ref1_,
                                                     source_ref2_,
                                                     Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3),
                                                     Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4),
                                                     source_ref_type_db_);
                                                     
      sales_qty_to_be_added_ := shipment_handling_utility_api.Get_Converted_Source_Qty(shipment_id_, shipment_line_no_, quantity_to_be_added_, NULL, NULL);

      Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(shipment_id_              => shipment_id_, 
                                                          shipment_line_no_         => shipment_line_no_,
                                                          handling_unit_id_         => shp_handling_unit_id_,
                                                          quantity_to_be_added_     => sales_qty_to_be_added_ );

      Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing(source_ref1_               => source_ref1_,
                                                            source_ref2_               => NVL(source_ref2_,'*'),
                                                            source_ref3_               => NVL(source_ref3_,'*'),
                                                            source_ref4_               => NVL(source_ref4_,'*'),
                                                            contract_                  => contract_,
                                                            part_no_                   => part_no_,
                                                            location_no_               => location_no_,
                                                            lot_batch_no_              => lot_batch_no_,
                                                            serial_no_                 => serial_no_,
                                                            eng_chg_level_             => eng_chg_level_,
                                                            waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                                            activity_seq_              => activity_seq_,
                                                            reserv_handling_unit_id_   => res_handling_unit_id_,
                                                            configuration_id_          => configuration_id_,
                                                            pick_list_no_              => pick_list_no_,
                                                            shipment_id_               => shipment_id_,
                                                            shipment_line_no_          => shipment_line_no_,
                                                            handling_unit_id_          => shp_handling_unit_id_,
                                                            quantity_to_be_added_      => quantity_to_be_added_,
                                                            catch_qty_to_reassign_     => catch_qty_to_reassign_);

      max_weight_volume_error_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'MAX_WEIGHT_VOLUME_ERROR');
      IF(max_weight_volume_error_ = Fnd_Boolean_API.DB_TRUE) THEN 
         Handling_Unit_API.Check_Max_Capacity_Exceeded(handling_unit_id_ => shp_handling_unit_id_);
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
   -- Check to see that API method Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing and Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing
   -- is granted thru following projections/actions/entity actions. 
   -- Note that some of the actions bound to the Virtuals maybe changed in the future so they are not bound anymore, in that case we need to change them here also.
   IF (Security_SYS.Is_Proj_Entity_Act_Available('ShipmentHandlingUnitStructureHandling', 'ConnectPartsToHandlingUnitVirtual', 'StartAttachPartsToHandlingUnit') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentHandlingUnitStructureHandling', 'MoveShipmentLineNode') OR
       Security_SYS.Is_Proj_Action_Available('ShipmentHandlingUnitStructureHandling', 'RepackShipmentLineQuantity') OR
       Security_SYS.Is_Proj_Entity_Act_Available('ShipmentHandlingUnitStructureHandling', 'ShipmentSourceVirtual', 'StartIdentifyPartsToHandlingUnit')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN     NUMBER,
   capture_process_id_ IN     VARCHAR2,
   capture_config_id_  IN     NUMBER,
   data_item_id_       IN     VARCHAR2,
   contract_           IN     VARCHAR2 )
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
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   pick_list_no_                VARCHAR2(15);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   location_no_                 VARCHAR2(35);
   lot_batch_no_                VARCHAR2(20);
   serial_no_                   VARCHAR2(50);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   activity_seq_                NUMBER;
   hu_sql_where_expression_     VARCHAR2(2000);
   sh_sql_where_expression_     VARCHAR2(2000);
   barcode_id_                  NUMBER;
   column_name_                 VARCHAR2(30);
   local_shipment_id_           NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   lov_type_db_                 VARCHAR2(20);
   input_uom_group_id_          VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
         Get_Filter_Keys___(dummy_contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_,
                            res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, gtin_no_, 
                            capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
      ELSE
         Get_Filter_Keys___(dummy_contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_, 
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, 
                            res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, gtin_no_, 
                            capture_session_id_, data_item_id_);
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

      ELSIF (data_item_id_ IN ('SHIPMENT_ID', 'PART_NO', 'PICK_LIST_NO', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 
                               'SOURCE_REF_TYPE', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 
                               'ACTIVITY_SEQ', 'LOCATION_NO', 'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN

         IF (data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (data_item_id_ = 'RES_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSE
            column_name_ := data_item_id_;
         END IF;

         -- Do not show anything that is already connected and Picked vs Packed Qty. Will also filter make sure that the order/shipment connection exists.
         sh_sql_where_expression_ := '(qty_assigned - NVL(Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(source_ref1,NVL(source_ref2,''*''),NVL(source_ref3,''*''),NVL(source_ref4,''*''),source_ref_type_db,contract,part_no,location_no,lot_batch_no,serial_no,eng_chg_level,waiv_dev_rej_no,activity_seq,handling_unit_id,configuration_id,pick_list_no,shipment_id), 0)) > 0
                                      AND   Shipment_Handling_Utility_API.Get_Packing_Qty_Deviation(source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type_db, shipment_id) > 0';
         Shipment_Source_Utility_API.Create_Data_Capture_Lov(contract_                   => contract_,
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
                                                             handling_unit_id_           => res_handling_unit_id_,
                                                             sscc_                       => res_sscc_,
                                                             alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                             capture_session_id_         => capture_session_id_,
                                                             column_name_                => column_name_,
                                                             lov_type_db_                => lov_type_db_,
                                                             sql_where_expression_       => sh_sql_where_expression_);

      ELSIF (data_item_id_ IN ('PARENT_CONSOL_SHIPMENT_ID')) THEN
         local_shipment_id_          := shipment_id_;
         local_shp_handling_unit_id_ := shp_handling_unit_id_;
         local_shp_sscc_             := shp_sscc_;
         local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
         Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, data_item_id_);         
         hu_sql_where_expression_ := hu_sql_where_expression_ || ' AND handling_unit_id IS NOT NULL ';
         Shipment_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                              shipment_id_                => shipment_id_,
                                              handling_unit_id_           => shp_handling_unit_id_,
                                              parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                              sscc_                       => local_shp_sscc_,
                                              alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                              capture_session_id_         => capture_session_id_,
                                              column_name_                => data_item_id_,
                                              lov_type_db_                => lov_type_db_,
                                              sql_where_expression_       => hu_sql_where_expression_,
                                              lov_id_                     => 2); 

      ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
         local_shipment_id_          := shipment_id_;
         local_shp_handling_unit_id_ := shp_handling_unit_id_;
         local_shp_sscc_             := shp_sscc_;
         local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
         Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, data_item_id_);
         IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (data_item_id_ = 'SHP_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';      
         END IF;
         Handling_Unit_API.Create_Data_Capture_Lov(handling_unit_id_           => shp_handling_unit_id_,
                                                   shipment_id_                => local_shipment_id_, 
                                                   sscc_                       => local_shp_sscc_,
                                                   alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                   capture_session_id_         => capture_session_id_,
                                                   column_name_                => column_name_,
                                                   source_ref1_                => NULL,
                                                   source_ref2_                => NULL,
                                                   source_ref3_                => NULL,
                                                   source_ref_type_db_         => NULL,
                                                   lov_type_db_                => lov_type_db_,
                                                   sql_where_expression_       => hu_sql_where_expression_); 

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
   capture_session_id_ IN     VARCHAR2,
   data_item_id_       IN     VARCHAR2 ) RETURN VARCHAR2
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
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   pick_list_no_                VARCHAR2(15);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   location_no_                 VARCHAR2(35);
   lot_batch_no_                VARCHAR2(20);
   serial_no_                   VARCHAR2(50);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   activity_seq_                NUMBER;
   qty_assigned_                NUMBER;
   automatic_value_             VARCHAR2(200);
   hu_sql_where_expression_     VARCHAR2(2000);
   barcode_id_                  NUMBER;
   dummy_                       BOOLEAN;
   column_name_                 VARCHAR2(30);
   local_shipment_id_           NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
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

         IF (data_item_id_ IN ('BARCODE_ID', 'QTY_TO_ATTACH')) THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_,
                               configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_,
                               shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, gtin_no_, 
                               capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_,
                               configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_,
                               shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, gtin_no_, 
                               capture_session_id_, data_item_id_);
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
   
         ELSIF (data_item_id_ IN ('SHIPMENT_ID', 'PART_NO', 'PICK_LIST_NO', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 
                                  'SOURCE_REF_TYPE', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 
                                  'ACTIVITY_SEQ', 'LOCATION_NO', 'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN
   
            IF (data_item_id_ = 'SOURCE_REF_TYPE') THEN
               column_name_ := 'SOURCE_REF_TYPE_DB';
            ELSIF (data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'RES_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            automatic_value_ := Shipment_Source_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
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
                                                                                       handling_unit_id_           => res_handling_unit_id_, 
                                                                                       sscc_                       => res_sscc_,
                                                                                       alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                                       column_name_                => column_name_,
                                                                                       sql_where_expression_       => NULL);
   
         ELSIF (data_item_id_ IN ('PARENT_CONSOL_SHIPMENT_ID')) THEN
            local_shipment_id_          := shipment_id_;
            local_shp_handling_unit_id_ := shp_handling_unit_id_;
            local_shp_sscc_             := shp_sscc_;
            local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
            Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, data_item_id_);      
            hu_sql_where_expression_ := hu_sql_where_expression_ || ' AND handling_unit_id IS NOT NULL ';
            automatic_value_ := Shipment_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                        contract_                   => contract_,
                                                                        shipment_id_                => shipment_id_,
                                                                        handling_unit_id_           => shp_handling_unit_id_,
                                                                        parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                        sscc_                       => local_shp_sscc_,
                                                                        alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                                        column_name_                => data_item_id_,
                                                                        sql_where_expression_       => hu_sql_where_expression_,
                                                                        cursor_id_                  => 2);
   
         ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            local_shipment_id_          := shipment_id_;
            local_shp_handling_unit_id_ := shp_handling_unit_id_;
            local_shp_sscc_             := shp_sscc_;
            local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
            Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, data_item_id_);
            IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'SHP_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';      
            END IF;
            automatic_value_ := Handling_Unit_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                             handling_unit_id_           => shp_handling_unit_id_,
                                                                             shipment_id_                => local_shipment_id_,
                                                                             sscc_                       => local_shp_sscc_,
                                                                             alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                                             column_name_                => column_name_,
                                                                             source_ref1_                => NULL,
                                                                             source_ref2_                => NULL,
                                                                             source_ref3_                => NULL,
                                                                             source_ref_type_db_         => NULL,
                                                                             sql_where_expression_       => hu_sql_where_expression_);
   
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
         ELSIF (data_item_id_ = 'QTY_TO_ATTACH') THEN
            input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                            data_item_id_a_     => 'INPUT_UOM',
                                                                            data_item_id_b_     => data_item_id_);
   
            input_qty_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                            data_item_id_a_     => 'INPUT_QUANTITY',
                                                                            data_item_id_b_     => data_item_id_);
   
            IF (input_uom_ IS NOT NULL) AND (input_qty_ IS NOT NULL) THEN
               input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
               input_conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_id_, input_uom_);
               automatic_value_ := input_qty_ * input_conv_factor_;    
            ELSE         
               qty_assigned_ := Shipment_Source_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
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
                                                                                       handling_unit_id_           => res_handling_unit_id_,
                                                                                       sscc_                       => res_sscc_,
                                                                                       alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                                       column_name_                => 'QTY_ASSIGNED',
                                                                                       sql_where_expression_       => NULL);
   
               -- Left to pack
               automatic_value_ := qty_assigned_ - nvl(Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(source_ref1_             => source_ref1_,
                                                                                                               source_ref2_             => NVL(source_ref2_,'*'),
                                                                                                               source_ref3_             => NVL(source_ref3_,'*'),
                                                                                                               source_ref4_             => NVL(source_ref4_,'*'),
                                                                                                               source_ref_type_db_      => source_ref_type_db_,
                                                                                                               contract_                => contract_,
                                                                                                               part_no_                 => part_no_,
                                                                                                               location_no_             => location_no_,
                                                                                                               lot_batch_no_            => lot_batch_no_,
                                                                                                               serial_no_               => serial_no_,
                                                                                                               eng_chg_level_           => eng_chg_level_,
                                                                                                               waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                                                                               activity_seq_            => activity_seq_,
                                                                                                               reserv_handling_unit_id_ => res_handling_unit_id_,
                                                                                                               configuration_id_        => configuration_id_,
                                                                                                               pick_list_no_            => pick_list_no_,
                                                                                                               shipment_id_             => shipment_id_), 0); 
            END IF;             
         ELSIF (data_item_id_ = 'CATCH_QTY_TO_ATTACH') THEN
            IF (NOT Fnd_Boolean_API.Is_True_Db(Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_))) THEN
               automatic_value_ := 'NULL';
            END IF;
         END IF;
      END IF;
   $END 
   RETURN automatic_value_;
   
END Get_Automatic_Data_Item_Value;


PROCEDURE Validate_Data_Item (
   capture_session_id_ IN     NUMBER,
   data_item_id_       IN     VARCHAR2,
   data_item_value_    IN     VARCHAR2 )
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
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   pick_list_no_                VARCHAR2(15);
   part_no_                     VARCHAR2(25);
   configuration_id_            VARCHAR2(50);
   location_no_                 VARCHAR2(35);
   lot_batch_no_                VARCHAR2(20);
   serial_no_                   VARCHAR2(50);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   activity_seq_                NUMBER;
   customer_order_catch_qty_    NUMBER;
   qty_assigned_                NUMBER;
   left_to_pack_on_location_    NUMBER;
   data_item_description_       VARCHAR2(200);
   mandatory_non_process_key_   BOOLEAN := FALSE;
   hu_sql_where_expression_     VARCHAR2(2000);
   barcode_id_                  NUMBER;
   unique_value_                VARCHAR2(100);
   dummy_                       BOOLEAN;
   column_name_                 VARCHAR2(30);
   res_shipment_id_             NUMBER;
   local_shipment_id_           NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   catch_quantity_              NUMBER;
   input_unit_meas_group_id_    VARCHAR2(30); 
   gtin_no_                     VARCHAR2(14);
BEGIN
$IF Component_Wadaco_SYS.INSTALLED $THEN

   IF (data_item_id_ = 'BARCODE_ID') THEN
      IF (data_item_value_ IS NOT NULL) THEN          
         -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
         Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_,
                            location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_,
                            res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, gtin_no_, 
                            capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE);
      END IF;      
   ELSE
      Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_, part_no_, configuration_id_,
                         location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_,
                         res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, gtin_no_, 
                         capture_session_id_, data_item_id_, data_item_value_);
   END IF;
   IF (data_item_id_ = 'QTY_TO_ATTACH') THEN
      mandatory_non_process_key_ := TRUE;
   END IF;
   IF (data_item_id_ NOT IN ('BARCODE_ID')) THEN
      Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_);
   END IF;

   IF (data_item_id_ IN ('PART_NO','CATCH_QTY_TO_ATTACH')) THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_TO_ATTACH', session_rec_ , process_package_);
      Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                   current_data_item_id_      => data_item_id_,
                                                   part_no_data_item_id_      => 'PART_NO',
                                                   part_no_data_item_value_   => part_no_,
                                                   catch_qty_data_item_id_    => 'CATCH_QTY_TO_ATTACH',
                                                   catch_qty_data_item_value_ => catch_quantity_,
                                                   positive_catch_qty_        => TRUE);  -- Since this process dont allow normal quantity to be zero or lower it should not allow it for catch quantity either.
   END IF;


   data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
   
   IF (data_item_id_ IN ('SHIPMENT_ID', 'PART_NO', 'PICK_LIST_NO', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 
                         'SOURCE_REF_TYPE', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 
                         'ACTIVITY_SEQ', 'LOCATION_NO', 'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN

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
         ELSIF (data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (data_item_id_ = 'RES_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSE
            column_name_ := data_item_id_;
         END IF;
         Shipment_Source_Utility_API.Record_With_Column_Value_Exist(contract_                   => contract_,
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
                                                                    handling_unit_id_           => res_handling_unit_id_,
                                                                    sscc_                       => res_sscc_,
                                                                    alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                    column_name_                => column_name_,
                                                                    column_value_               => data_item_value_,
                                                                    column_description_         => data_item_description_,
                                                                    sql_where_expression_       => NULL);
      END IF;
   ELSIF (data_item_id_ IN ('PARENT_CONSOL_SHIPMENT_ID')) THEN
      IF (res_handling_unit_id_ IS NOT NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         res_shipment_id_ := Shipment_Source_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                    shipment_id_                => NULL,
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
                                                                                    handling_unit_id_           => res_handling_unit_id_, 
                                                                                    sscc_                       => res_sscc_,
                                                                                    alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                                    column_name_                => 'SHIPMENT_ID',
                                                                                    sql_where_expression_       => NULL);

         IF (Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_) != res_shipment_id_) THEN
            Error_SYS.Record_General(lu_name_,'WRONGSHIPMENT: Handling Unit ID and Shipment Handling Unit ID belongs to different shipments.');
         END IF;
      END IF;
      
      local_shipment_id_          := shipment_id_;
      local_shp_handling_unit_id_ := shp_handling_unit_id_;
      local_shp_sscc_             := shp_sscc_;
      local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
      Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, data_item_id_);     
      hu_sql_where_expression_ := hu_sql_where_expression_ || ' AND handling_unit_id IS NOT NULL ';
      Shipment_API.Record_With_Column_Value_Exist(record_exists_              => dummy_,
                                                  contract_                   => contract_,
                                                  shipment_id_                => shipment_id_,
                                                  handling_unit_id_           => shp_handling_unit_id_,
                                                  parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                  sscc_                       => local_shp_sscc_,
                                                  alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                  column_name_                => data_item_id_,
                                                  column_value_               => data_item_value_,
                                                  column_description_         => data_item_description_,
                                                  sql_where_expression_       => hu_sql_where_expression_,
                                                  cursor_id_                  => 2);
                                                  
   ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
      IF (res_handling_unit_id_ IS NOT NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         res_shipment_id_ := Shipment_Source_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
                                                                                    shipment_id_                => NULL,
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
                                                                                    handling_unit_id_           => res_handling_unit_id_, 
                                                                                    sscc_                       => res_sscc_,
                                                                                    alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                                    column_name_                => 'SHIPMENT_ID',
                                                                                    sql_where_expression_       => NULL);

         IF (Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_) != res_shipment_id_) THEN
            Error_SYS.Record_General(lu_name_,'WRONGSHIPMENT: Handling Unit ID and Shipment Handling Unit ID belongs to different shipments.');
         END IF;
      END IF;
      IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
         Handling_Unit_API.Exist(data_item_value_);
      END IF;
      local_shipment_id_          := shipment_id_;
      local_shp_handling_unit_id_ := shp_handling_unit_id_;
      local_shp_sscc_             := shp_sscc_;
      local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
      Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, data_item_id_);
      IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
         column_name_ := 'HANDLING_UNIT_ID';
      ELSIF (data_item_id_ = 'SHP_SSCC') THEN
         column_name_ := 'SSCC';
      ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
         column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';     
      END IF;
      Handling_Unit_API.Record_With_Column_Value_Exist(record_exists_              => dummy_,
                                                       handling_unit_id_           => shp_handling_unit_id_,
                                                       shipment_id_                => local_shipment_id_,
                                                       sscc_                       => local_shp_sscc_,
                                                       alt_handling_unit_label_id_ => local_alt_hu_label_id_,
                                                       column_name_                => column_name_,
                                                       column_value_               => data_item_value_,
                                                       column_description_         => data_item_description_,
                                                       source_ref1_                => NULL,
                                                       source_ref2_                => NULL,
                                                       source_ref3_                => NULL,
                                                       source_ref_type_db_         => NULL,
                                                       sql_where_expression_       => hu_sql_where_expression_);                                                  
   ELSIF (data_item_id_ = 'QTY_TO_ATTACH') THEN
      IF (data_item_value_ <= 0) THEN
         Error_SYS.Record_General(lu_name_,'QTYTOATTACHPOSITIVE: Qty to Attach must be a number greater than 0.');
      END IF;
      qty_assigned_ := Shipment_Source_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
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
                                                                              handling_unit_id_           => res_handling_unit_id_,
                                                                              sscc_                       => res_sscc_,
                                                                              alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                              column_name_                => 'QTY_ASSIGNED',
                                                                              sql_where_expression_       => NULL);
   
      -- Left to pack on pick list line
      left_to_pack_on_location_ := qty_assigned_ - nvl(Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(source_ref1_             => source_ref1_,
                                                                                                               source_ref2_             => NVL(source_ref2_,'*'),
                                                                                                               source_ref3_             => NVL(source_ref3_,'*'),
                                                                                                               source_ref4_             => NVL(source_ref4_,'*'),   
                                                                                                               source_ref_type_db_      => source_ref_type_db_,
                                                                                                               contract_                => contract_,
                                                                                                               part_no_                 => part_no_,
                                                                                                               location_no_             => location_no_,
                                                                                                               lot_batch_no_            => lot_batch_no_,
                                                                                                               serial_no_               => serial_no_,
                                                                                                               eng_chg_level_           => eng_chg_level_,
                                                                                                               waiv_dev_rej_no_         => waiv_dev_rej_no_,
                                                                                                               activity_seq_            => activity_seq_,
                                                                                                               reserv_handling_unit_id_ => res_handling_unit_id_,
                                                                                                               configuration_id_        => configuration_id_,
                                                                                                               pick_list_no_            => pick_list_no_,
                                                                                                               shipment_id_             => shipment_id_), 0);

      IF (left_to_pack_on_location_ < data_item_value_) THEN
         Error_SYS.Record_General(lu_name_, 'QTYLARGERTHANAVAILABLE: The :P1 (:P2) is bigger than the available picked qty to attach (:P3).', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_), data_item_value_, left_to_pack_on_location_);
      END IF;

   ELSIF (data_item_id_ = 'CATCH_QTY_TO_ATTACH') THEN
      unique_value_ := Shipment_Source_Utility_API.Get_Column_Value_If_Unique(contract_                   => contract_,
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
                                                                              handling_unit_id_           => res_handling_unit_id_,
                                                                              sscc_                       => res_sscc_,
                                                                              alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                              column_name_                => 'CATCH_QTY',
                                                                              sql_where_expression_       => NULL);
                                                                                                   
      IF (unique_value_ != 'NULL') THEN
         customer_order_catch_qty_ := unique_value_;
      END IF;
                                                                                      
      IF (customer_order_catch_qty_ IS NOT NULL) THEN
         Shipment_Reserv_Handl_Unit_API.Validate_Catch_Qty(catch_quantity_to_be_added_  => 0,
                                                           total_catch_qty_to_reassign_ => data_item_value_,
                                                           customer_order_catch_qty_    => customer_order_catch_qty_,
                                                           old_catch_qty_to_reassign_   => 0,
                                                           picked_catch_quantity_       => customer_order_catch_qty_ - 0);
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
   ELSIF (data_item_id_ LIKE 'GS1%') THEN
         Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
   END IF;
$ELSE
   NULL;
$END
END Validate_Data_Item;


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN     NUMBER,
   data_item_id_       IN     VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   fixed_value_is_applicable_   BOOLEAN := FALSE;
   local_data_item_id_          VARCHAR2(50);
   process_package_             VARCHAR2(30);
   part_no_                     VARCHAR2(25);
   serial_no_                   VARCHAR2(50);
--   contract_                    VARCHAR2(5);
--   shipment_id_                 NUMBER;
--   parent_consol_shipment_id_   NUMBER;
--   source_ref1_                 VARCHAR2(50);
--   source_ref2_                 VARCHAR2(50);
--   source_ref3_                 VARCHAR2(50);
--   source_ref4_                 VARCHAR2(50);
--   source_ref_type_db_          shipment_line_tab.source_ref_type%TYPE;
--   shp_handling_unit_id_        NUMBER;
--   pick_list_no_                VARCHAR2(15);
--   shp_sscc_                    VARCHAR2(18);
--   shp_alt_handl_unit_label_id_ VARCHAR2(25);
--   res_handling_unit_id_        NUMBER;
--   res_sscc_                    VARCHAR2(18);
--   res_alt_handl_unit_label_id_ VARCHAR2(25);
--   configuration_id_            VARCHAR2(50);
--   location_no_                 VARCHAR2(35);
--   lot_batch_no_                VARCHAR2(20);
--   waiv_dev_rej_no_             VARCHAR2(15);
--   eng_chg_level_               VARCHAR2(6);
--   activity_seq_                NUMBER;
--   barcode_id_                  NUMBER;
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
$IF Component_Wadaco_SYS.INSTALLED $THEN
   session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
   process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
   part_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);

-- The following code was commented out since it will cause recursive call to Fixed_Value_Is_Applicable and as a result noticeable deterioration in performance.
-- Most likely when a process is configured to have serial no, lot batch or configuration id before part no then it is expected that value needs to be scanned or 
-- entered so check for fixed value seems to be unnecessary in those cases.

--   IF (part_no_ IS NULL) THEN 
--      Get_Filter_Keys___(contract_, shipment_id_, parent_consol_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, pick_list_no_,
--                         part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_,
--                         shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, 
--                         capture_session_id_, data_item_id_, use_applicable_ => FALSE);
--      part_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, shipment_id_, parent_consol_shipment_id_, 
--                                                source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, 
--                                                pick_list_no_, part_no_, configuration_id_, location_no_, lot_batch_no_, 
--                                                serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, shp_handling_unit_id_, 
--                                                shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, 
--                                                res_alt_handl_unit_label_id_, barcode_id_, 'PART_NO');
--   END IF;   

   IF (data_item_id_ = 'QTY_TO_ATTACH') THEN
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


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN     NUMBER,
   latest_data_item_id_    IN     VARCHAR2,
   latest_data_item_value_ IN     VARCHAR2 )
IS
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_          Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                      VARCHAR2(5);
   shipment_id_                   NUMBER;
   parent_consol_shipment_id_     NUMBER;
   shp_sscc_                      VARCHAR2(18);
   shp_alt_handl_unit_label_id_   VARCHAR2(25);
   res_handling_unit_id_          NUMBER;
   res_sscc_                      VARCHAR2(18);
   res_alt_handl_unit_label_id_   VARCHAR2(25);
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
                      res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, barcode_id_, gtin_no_, 
                      capture_session_id_, data_item_id_ => latest_data_item_id_, data_item_value_ => latest_data_item_value_, use_unique_values_ => TRUE);
   
   conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                          capture_config_id_  => session_rec_.capture_config_id,
                                                                          data_item_id_       => latest_data_item_id_ );
   
   IF (conf_item_detail_tab_.COUNT > 0) THEN
      FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
         IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN 
            IF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_ID', 'PARENT_CONSOL_SHIPMENT_ID', 'SOURCE_REF1', 'SOURCE_REF2', 'SOURCE_REF3', 'SOURCE_REF4', 'SOURCE_REF_TYPE', 
                                                                 'PICK_LIST_NO','PART_NO', 'CONFIGURATION_ID', 'LOCATION_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'WAIV_DEV_REJ_NO', 
                                                                 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID', 
                                                                 'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID','BARCODE_ID', 'GTIN')) THEN
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
                                        res_handling_unit_id_        => res_handling_unit_id_,
                                        res_sscc_                    => res_sscc_,
                                        res_alt_handl_unit_label_id_ => res_alt_handl_unit_label_id_,
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

            ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('RES_HANDLING_UNIT_TYPE_CATEG_ID', 'RES_HANDLING_UNIT_TYPE_CATEG_DESC',
                                                                    'RES_HANDLING_UNIT_TYPE_ID', 'RES_HANDLING_UNIT_TYPE_DESC',
                                                                    'RES_TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN
               -- Feedback items related to reserv/inventory handling unit type
               Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                           owning_data_item_id_ => latest_data_item_id_,
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           handling_unit_id_    => res_handling_unit_id_);

            ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHP_HANDLING_UNIT_WIDTH', 'SHP_HANDLING_UNIT_HEIGHT', 'SHP_HANDLING_UNIT_DEPTH', 
                                                                    'SHP_PARENT_HANDLING_UNIT_ID', 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT', 'SHP_HANDLING_UNIT_MANUAL_VOLUME')) THEN
               -- Feedback items related to shipment handling unit
               Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                          owning_data_item_id_  => latest_data_item_id_,
                                                                          data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          handling_unit_id_     => shp_handling_unit_id_);

            ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('RES_TOP_PARENT_HANDLING_UNIT_ID', 'RES_TOP_PARENT_SSCC', 'RES_TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID',
                                                                    'RES_LEVEL_2_HANDLING_UNIT_ID', 'RES_LEVEL_2_SSCC', 'RES_LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
               -- Feedback items related to reserv/inventory handling unit
               Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                          owning_data_item_id_  => latest_data_item_id_,
                                                                          data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          handling_unit_id_     => res_handling_unit_id_);

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
                                    shp_handling_unit_id_      => shp_handling_unit_id_,
                                    res_handling_unit_id_      => res_handling_unit_id_ );

            END IF;
         END IF;
      END LOOP;
   END IF;
$ELSE
   NULL;
$END
END Add_Details_For_Latest_Item;