-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptCountPartRep
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: COUNT_PART_COUNT_REPORT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200915  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Entity_Cud_Available/Is_Proj_Entity_Act_Available in Is_Process_Available to support new projection security concept.
--  181019  BudKlk  Bug 143097, Modified the method Add_Details_For_Latest_Item to add a new feedback item CONDITION_CODE_DESCRIPTION.
--  180704  RuLiLk  Bug 142825, Modified method Get_Automatic_Data_Item_Value to fetch automatic value for QTY_COUNT1 from Inventory_Part_In_Stock. Qty_Onhand.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171129  CKumlk  STRSC-14828, Modified Add_Filter_Key_Detail___ to handle GTIN.
--  171110  DaZase  STRSC-8865, Added extra Invpart Barcode and GTIN/part validation against the current Count Report record in Validate_Data_Item___. 
--  170925  SURBLK  STRSC-12222, Added sequence number for the captured image.
--  170918  SURBLK  STRSC-12082, Changed the media library access LU from InventoryPartInStock to CountingResult.
--  170914  DaZase  STRSC-11606, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  170914          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170908  SWiclk  STRSC-11956, Modified Get_Automatic_Data_Item_Value() in order to handle INPUT_UOM  and INPUT_QUANTITY when 
--  170908          inventory part has a value for Input UoM Group.
--  170822  SWiclk  STRSC-11571, Modified Get_Automatic_Data_Item_Value() in order to pass 'NULL' for GTIN when part doesn't have GTIN.
--  170815  SWiclk  STRSC-9617, Added Get_Input_Uom_Sql_Whr_Exprs___() and added GTIN to Get_Filter_Keys___().
--  170718  SWiclk  STRSC-9617, Implemented GTIN support, hence handled GTIN, INPUT_UOM and INPUT_QUANTITY data items 
--  170718          and INPUT_CONV_FACTOR as feedback item and GTIN_IS_MANDATORY as detail item.
--  170629  SWiclk  STRSC-9014, Enabled camera functionality and photos will be saved in ReceiptInfo LU.
--  170427  DaZase  LIM-10564, Added extra CountingReportLine validation for BARCODE_ID to make sure barcode values match the counting record.
--  170418  DaZase  LIM-10662, Changes in Get_Filter_Keys___ on how Bug 132004 was solved, now we check if inventory barcode is enabled correctly. 
--  170329  DaZase  LIM-10352, Renamed DataCaptureCountReport to DataCaptCountPartRep.
--  170302  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170213  khvese  LIM-10447, Modified catch quantity validation in Validate_Data_Item___ to be handled on data items 'PART_NO','CATCH_QTY_COUNTED' and 'QTY_COUNT1'.  
--  170113  DaZase  LIM-8660, Adapted catch quantity validation in Validate_Data_Item___ to new interface.  
--  161108  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161010  SWiclk  Bug 132004, Modified Get_Filter_Keys___() and Validate_Data_Item() in order to check whether  
--  161010          Barcode Id is mandatory or not before trying to fetch a unique value.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160219  SWiclk  Bug 127172, Modified Validate_Data_Item() and Validate_Data_Item___() in order to check Barcode_ID is mandatory if configured in process detail.
--  151126  JeLise  LIM-4470, Removed the adding of pallet id to count_attr_ in Execute_Process.
--  151126  RasDlk  Bug 125885, Modified Validate_Data_Item___() by passing sql_where_expression_ to the Inventory_Part_Barcode_API.Record_With_Column_Value_Exist procedure
--  151126          to prevent the error being raised when Barcode ID is entered in the COUNT_PART_COUNT_REPORT.
--  151109  DaZase  LIM-4295, Added handling for new data items HANDLING_UNIT_ID, SSCC and ALT_HANDLING_UNIT_LABEL_ID. Added calls 
--  151109          to Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type, Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit 
--  151109          in Add_Details_For_Latest_Item due to many new feedback items.
--  150807  DaZase  COB-607, Reworked some of the unique methods so data items that are not using the filter keys 
--  150807          are handled before calling Get_Filter_Keys___, to help performance a bit. 
--  150803  SWiclk  Bug 121254, Modified Get_Unique_Data_Item_Value___(), Validate_Data_Item___() and Create_List_Of_Values() by changing the parameter list 
--  150803          of methods which are from Inventory_Part_Barcode_API since the contract has been changed as a parentkey.
--  150529  KhVese  Added filtering on condition_code in unique handeling, validation, and list of values Also added validation and automatic value handeling for condition_code.
--  150309  DaZase  Moved OWNER to stock record part of Add_Details_For_Latest_Item.
--  150413  Chfose  Fixed calls to Inventory_Part_In_Stock_API & Counting_Report_Line_API by including handling_unit_id where applicable.
--  141106  DaZase  PRSC-4009, Changed Fixed_Value_Is_Applicable so it now fetches predicted and unique part_no.
--  141016  DaZase  PRSC-3321, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___. Removed Pack_Filter_Keys___, 
--  141016          Unpack_Filter_Keys___, Get_Fixed_Value___, Get_Filter_Key_Using_Unique___. Added Get_Unique_Data_Item_Value___, Add_Filter_Key_Detail___, Add_Unique_Data_Item_Detail___.
--  141009  DaZase  PRSC-63, Changed Get_Automatic_Data_Item_Value, Create_List_Of_Values and Validate_Data_Item to now use methods in Inventory_Part_Barcode_API for BARCODE_ID.
--  140910  DaZase  PRSC-2781, Changes in process to reflect that PRINT_INVENTORY_PART_BARCODE/CONFIRM data items now have their enumeration db values saved on session line.
--  140908  RiLase  Removed empty methods since the wadaco framework now can handle when methods doesn't exist.
--  140908  RiLase  PRSC-2497, Added Fixed_Value_Is_Applicable().
--  140827  DaZase  PRSC-1655, Added Validate_Config_Data_Item.
--  140815  Dazase  PRSC-1611, Removed Apply_Additional_Line_Content since it is now obsolete and Get_Automatic_Data_Item_Value can be used instead. 
--  140812  DaZase  PRSC-1611, Renamed Add_Lines_For_Latest_Data_Item to Add_Details_For_Latest_Item.
--  140811  DaZase  PRSC-1611, Changed call Counting_Report_Line_API.Check_Valid_Value to Counting_Report_Line_API.Record_With_Column_Value_Exist.
--  140805  DaZase  PRSC-1431, Changed part_no_ to be VARCHAR2(25) in all places.
--  140620  SWiclk  PRSC-1867, Bug 117179, Modified Get_Process_Execution_Message() and Execute_Process() by adding parameter process_message_
--  140620          and parameters process_message_ and blob_ref_attr_ respectively.
--  131203  SWiclk  Bug 114094, Modified Add_Line_Using_Unique___() in order to get the qty_onhand and catch_qty_onhand from Inventory_Part_In_Stock_API.                                                                                         
--  121004  JeLise  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_           CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   seq_                        IN NUMBER,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   condition_code_             IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,
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

      ELSIF (wanted_data_item_id_ IN ('INV_LIST_NO', 'SEQ', 'LOCATION_NO', 'PART_NO', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'LOT_BATCH_NO', 
                                      'SERIAL_NO', 'ENG_CHG_LEVEL', 'CONFIGURATION_ID', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
         unique_value_ := Counting_Report_Line_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                              inv_list_no_                => inv_list_no_, 
                                                                              seq_                        => seq_, 
                                                                              part_no_                    => part_no_, 
                                                                              location_no_                => location_no_, 
                                                                              serial_no_                  => serial_no_, 
                                                                              lot_batch_no_               => lot_batch_no_, 
                                                                              waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                                              eng_chg_level_              => eng_chg_level_, 
                                                                              configuration_id_           => configuration_id_, 
                                                                              activity_seq_               => activity_seq_, 
                                                                              handling_unit_id_           => handling_unit_id_,
                                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                              column_name_                => wanted_data_item_id_,
                                                                              sql_where_expression_       => sql_where_expression_);

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
   seq_                        OUT NUMBER,
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
   sscc_                       OUT VARCHAR2,  -- not used for filtering in unique handling
   alt_handling_unit_label_id_ OUT VARCHAR2, 
   gtin_no_                    OUT VARCHAR2,
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
      seq_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SEQ', session_rec_ , process_package_, use_applicable_);
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

      IF use_unique_values_ THEN
         condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                              data_item_id_a_      => 'CONDITION_CODE',
                                                                              data_item_id_b_      => data_item_id_);
      
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_,condition_code_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ACTIVITY_SEQ');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LOCATION_NO');
         END IF;
         IF (inv_list_no_ IS NULL) THEN
            inv_list_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'INV_LIST_NO');
         END IF;
         IF (seq_ IS NULL) THEN
            seq_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'SEQ');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'BARCODE_ID');
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
   inv_list_no_                IN VARCHAR2,
   seq_                        IN NUMBER,
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
   barcode_id_                 IN NUMBER, 
   gtin_no_                    IN VARCHAR2)  
IS
   detail_value_             VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      CASE (data_item_detail_id_)
         WHEN ('INV_LIST_NO') THEN
            detail_value_ := inv_list_no_;
         WHEN ('SEQ') THEN
            detail_value_ := seq_;
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
      /*IF (detail_value_ IS NULL AND data_item_detail_id_ IN ()) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, data_item_detail_id_);
      END IF;*/

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


PROCEDURE Validate_Data_Item___ (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   contract_                     VARCHAR2(5);
   inv_list_no_                  VARCHAR2(15);
   seq_                          NUMBER;
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   waiv_dev_rej_no_              VARCHAR2(15);
   eng_chg_level_                VARCHAR2(6);
   configuration_id_             VARCHAR2(50);
   condition_code_               VARCHAR2(10);   
   default_condition_code_       VARCHAR2(10);   
   activity_seq_                 NUMBER;
   catch_qty_counted_            NUMBER;
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   capture_process_id_           VARCHAR2(30);
   data_item_description_        VARCHAR2(200);
   barcode_id_                   NUMBER;
   sql_where_expression_         VARCHAR2(2000) DEFAULT NULL;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   column_value_nullable_        BOOLEAN := FALSE;
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   process_package_              VARCHAR2(30);
   qty_count1_                   NUMBER;
   input_unit_meas_group_id_     VARCHAR2(30); 
   gtin_no_                      VARCHAR2(14);
   gtin_part_no_                 VARCHAR2(25);
   local_part_no_                VARCHAR2(25);
   local_condition_code_         VARCHAR2(10);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- Note: No need to get values for process keys when barcode_id is null because probably it would not be used in this process.
         IF (data_item_value_ IS NOT NULL) THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                               eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                               gtin_no_, capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE);
         END IF;         
      ELSE
         Get_Filter_Keys___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            gtin_no_, capture_session_id_, data_item_id_, data_item_value_);
      END IF;

      condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                           data_item_id_a_      => 'CONDITION_CODE',
                                                                           data_item_id_b_      => data_item_id_);

      IF condition_code_ IS NOT NULL AND condition_code_ != 'NULL' THEN 
         sql_where_expression_ := ' NVL(Condition_Code_Manager_API.Get_Condition_Code(part_no,serial_no,lot_batch_no ) , ''' || string_null_ || ''')=''' || condition_code_ || '''';
      END IF;
      
      
      IF (data_item_id_ IN ('INV_LIST_NO','SEQ','LOCATION_NO','PART_NO','LOT_BATCH_NO','SERIAL_NO','CONFIGURATION_ID',
                            'ENG_CHG_LEVEL','WAIV_DEV_REJ_NO','ACTIVITY_SEQ', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN      

         IF (barcode_id_ = '0') THEN
            NULL;   -- Dont do anything if barcode is 0 since, it means here that barcode is missing
         ELSIF ((barcode_id_ IS NOT NULL AND barcode_id_ != '0') AND 
             data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ')) THEN
            -- BARCODE_ID is used for these items, then validate them against the barcode table
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_              => contract_,
                                                                      barcode_id_            => barcode_id_,
                                                                      part_no_               => part_no_,
                                                                      configuration_id_      => configuration_id_,
                                                                      lot_batch_no_          => lot_batch_no_,
                                                                      serial_no_             => serial_no_,
                                                                      eng_chg_level_         => eng_chg_level_,
                                                                      waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                                                      activity_seq_          => activity_seq_,
                                                                      column_name_           => data_item_id_,
                                                                      column_value_          => data_item_value_,
                                                                      column_description_    => data_item_description_,
                                                                      sql_where_expression_  => sql_where_expression_);
         ELSE
            IF (data_item_id_ IN ('SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ = 'HANDLING_UNIT_ID' AND data_item_value_ > 0) THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
            Counting_Report_Line_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                    inv_list_no_                => inv_list_no_,
                                                                    seq_                        => seq_,
                                                                    part_no_                    => part_no_,
                                                                    location_no_                => location_no_,
                                                                    serial_no_                  => serial_no_,
                                                                    lot_batch_no_               => lot_batch_no_,
                                                                    waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                    eng_chg_level_              => eng_chg_level_,
                                                                    configuration_id_           => configuration_id_, 
                                                                    activity_seq_               => activity_seq_,
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    column_name_                => data_item_id_,
                                                                    column_value_               => data_item_value_,
                                                                    sql_where_expression_       => sql_where_expression_,
                                                                    column_value_nullable_      => column_value_nullable_);
         END IF;
      
      ELSIF (data_item_id_ = 'CONDITION_CODE') THEN        
         Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                         data_item_id_,
                                                         data_item_value_);
         IF part_no_ IS NOT NULL AND serial_no_ IS NOT NULL AND lot_batch_no_ IS NOT NULL THEN 
            default_condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_,serial_no_,lot_batch_no_ );
            IF default_condition_code_ != data_item_value_ THEN 
               Error_SYS.Record_General(lu_name_,'CONDCODECANNOTCHANGE: You can not change the condition code ":P1".', default_condition_code_);
            END IF ; 
         END IF ; 
         
      ELSIF (data_item_id_ = 'BARCODE_ID') THEN
         -- no extra validations if barcode_id is NULL since then we are not using it
         -- and no extra validation if barcode_id is 0 since barcode is then missing 
         IF (data_item_value_ IS NOT NULL AND data_item_value_ != '0') THEN
            data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
            Inventory_Part_Barcode_API.Record_With_Column_Value_Exist(contract_              => contract_,
                                                                      barcode_id_            => barcode_id_,
                                                                      part_no_               => part_no_,
                                                                      configuration_id_      => configuration_id_,
                                                                      lot_batch_no_          => lot_batch_no_,
                                                                      serial_no_             => serial_no_,
                                                                      eng_chg_level_         => eng_chg_level_,
                                                                      waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                                                      activity_seq_          => activity_seq_,
                                                                      column_name_           => data_item_id_,
                                                                      column_value_          => data_item_value_,
                                                                      column_description_    => data_item_description_,
                                                                      sql_where_expression_  => sql_where_expression_); 
            -- Also validate if the barcode values match the current count report line record (if such record have been identified already by seq for example)
            Counting_Report_Line_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                    inv_list_no_                => inv_list_no_,
                                                                    seq_                        => seq_,
                                                                    part_no_                    => part_no_,
                                                                    location_no_                => location_no_,
                                                                    serial_no_                  => serial_no_,
                                                                    lot_batch_no_               => lot_batch_no_,
                                                                    waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                    eng_chg_level_              => eng_chg_level_,
                                                                    configuration_id_           => configuration_id_, 
                                                                    activity_seq_               => activity_seq_,
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    column_name_                => NULL,
                                                                    column_value_               => NULL,
                                                                    sql_where_expression_       => sql_where_expression_,
                                                                    inv_barcode_validation_     => TRUE);
   
         END IF;
      ELSIF (data_item_id_ = 'GTIN') THEN
         gtin_part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(data_item_value_);
         IF (gtin_part_no_ IS NOT NULL) THEN
            local_part_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                data_item_id_a_     => 'PART_NO',
                                                                                data_item_id_b_     => data_item_id_);
            IF (local_part_no_ IS NULL)  THEN
               local_condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                          data_item_id_a_     => 'CONDITION_CODE', 
                                                                                          data_item_id_b_     => data_item_id_);
               IF (local_condition_code_ IS NULL AND 
                   NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'CONDITION_CODE', data_item_id_)) THEN
                  local_condition_code_ := '%'; 
               END IF;
               -- Sending NULL for part_no and all items that can be applicable handled and are part_no connected
               -- since these could have gotten their values from the gtin in Get_Filter_Keys___ that might not be correct.
               -- Since condition_code is nullable we need to use '%' if it hasnt been scanned yet since we cant trust 
               -- value from Get_Filter_Keys___ since it could be applicable handled using the wrong part. 
               -- The inv_list_no_ and seq_ are the important filter keys here since they will point out 1 record.
               local_part_no_ := Get_Unique_Data_Item_Value___(contract_            => contract_, 
                                                               inv_list_no_         => inv_list_no_, 
                                                               seq_                 => seq_, 
                                                               part_no_             => NULL, 
                                                               location_no_         => location_no_, 
                                                               serial_no_           => NULL, 
                                                               lot_batch_no_        => NULL, 
                                                               waiv_dev_rej_no_     => waiv_dev_rej_no_, 
                                                               eng_chg_level_       => eng_chg_level_, 
                                                               configuration_id_    => NULL, 
                                                               condition_code_      => local_condition_code_, 
                                                               activity_seq_        => activity_seq_, 
                                                               handling_unit_id_    => handling_unit_id_, 
                                                               alt_handling_unit_label_id_ => alt_handling_unit_label_id_, 
                                                               barcode_id_          => barcode_id_, 
                                                               wanted_data_item_id_ => 'PART_NO');
            END IF;
            IF (local_part_no_ IS NOT NULL AND gtin_part_no_ != local_part_no_)  THEN
               -- This error is needed, since the part taken from GTIN dont match the already scanned part or the part that the unique record points to.
               Error_SYS.Record_General(lu_name_, 'GTINDONTMATCH: The GTIN No does not match current Count Report record.');
            END IF;
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
      END IF;
      IF (data_item_id_ IN ('PART_NO','CATCH_QTY_COUNTED', 'QTY_COUNT1')) THEN
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
         catch_qty_counted_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_COUNTED', session_rec_ , process_package_);
         IF (data_item_id_ = 'QTY_COUNT1' AND part_no_ IS NOT NULL) THEN
            qty_count1_ := data_item_value_;
            part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
            IF (part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_serial_tracking) THEN
               -- if part is serial tracked it can only have qty 1 or 0.
               IF (data_item_value_ NOT IN (1, 0)) THEN
                  capture_process_id_ := Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_);
                  data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(capture_process_id_, data_item_id_);
                  Error_SYS.Record_General(lu_name_, 'QTYCOUNT1NOTVALID: A serial handled part can only have :P1 1 or 0.', data_item_description_);
               END IF;
            END IF;
         ELSE 
            qty_count1_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'QTY_COUNT1', session_rec_ , process_package_);
         END IF;

         IF qty_count1_ > 0 THEN 
            Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                         current_data_item_id_      => data_item_id_,
                                                         part_no_data_item_id_      => 'PART_NO',
                                                         part_no_data_item_value_   => part_no_,
                                                         catch_qty_data_item_id_    => 'CATCH_QTY_COUNTED',
                                                         catch_qty_data_item_value_ => catch_qty_counted_,
                                                         positive_catch_qty_        => TRUE);  
         ELSE
            Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_       => capture_session_id_,        
                                                        current_data_item_id_      => data_item_id_,
                                                        part_no_data_item_id_      => 'PART_NO',
                                                        part_no_data_item_value_   => part_no_,
                                                        catch_qty_data_item_id_    => 'CATCH_QTY_COUNTED',
                                                        catch_qty_data_item_value_ => catch_qty_counted_,
                                                        catch_zero_qty_allowed_    => TRUE);  -- Since this process allow 0 counting
         END IF;
      END IF;

   $ELSE
      NULL;
   $END
END Validate_Data_Item___;

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

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('QTY_COUNT1', 'INPUT_QUANTITY')) THEN
         IF (data_item_value_ < 0) THEN
            Error_SYS.Record_General(lu_name_, 'NEGATIVEORZEROQTY: Negative Quantity is not allowed.');
         END IF;
      END IF;
      -- Do the regular invent exists checks first
      Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                      data_item_id_,
                                                      data_item_value_);
            
      IF (data_item_id_ IN ('INV_LIST_NO','SEQ','LOCATION_NO','PART_NO','LOT_BATCH_NO','SERIAL_NO','CONFIGURATION_ID', 'CONDITION_CODE',
                            'ENG_CHG_LEVEL','WAIV_DEV_REJ_NO','ACTIVITY_SEQ', 'QTY_COUNT1', 'CATCH_QTY_COUNTED', 'BARCODE_ID',
                            'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID', 'INPUT_UOM', 'GTIN')) THEN      
         Validate_Data_Item___(capture_session_id_, data_item_id_, data_item_value_);
      ELSIF (data_item_id_ = 'CONFIRM') THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_ => TRUE);
         Gen_Yes_No_API.Exist_Db(data_item_value_);
      ELSIF (data_item_id_ LIKE 'GS1%') THEN
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
   dummy_                       VARCHAR2(5);
   inv_list_no_                 VARCHAR2(15);
   seq_                         NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   condition_code_              VARCHAR2(10);   
   activity_seq_                NUMBER;
   barcode_id_                  NUMBER;
   sql_where_expression_        VARCHAR2(2000) DEFAULT NULL;
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   lov_id_                      NUMBER := 1;
   lov_type_db_                 VARCHAR2(20);
   input_uom_group_id_          VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
BEGIN
   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('PRINT_INVENTORY_PART_BARCODE', 'CONFIRM')) THEN
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, contract_);
      ELSE
         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(dummy_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                               eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                               gtin_no_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(dummy_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                               eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                               gtin_no_, capture_session_id_, data_item_id_);
         END IF;

         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
         condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                              data_item_id_a_      => 'CONDITION_CODE',
                                                                              data_item_id_b_      => data_item_id_);

         IF condition_code_ IS NOT NULL AND condition_code_ != 'NULL' THEN 
            sql_where_expression_ := ' NVL(Condition_Code_Manager_API.Get_Condition_Code(part_no,serial_no,lot_batch_no ) , ''' || string_null_ || ''')=''' || condition_code_ || '''';
         END IF;
         
         IF ((data_item_id_ = 'BARCODE_ID') OR 
            (barcode_id_ IS NOT NULL AND barcode_id_ != '0' AND data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ'))) THEN
            Inventory_Part_Barcode_API.Create_Data_Capture_Lov(contract_              => contract_,
                                                               barcode_id_            => barcode_id_,
                                                               part_no_               => part_no_,
                                                               configuration_id_      => configuration_id_,
                                                               lot_batch_no_          => lot_batch_no_,
                                                               serial_no_             => serial_no_,
                                                               eng_chg_level_         => eng_chg_level_,
                                                               waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                                               activity_seq_          => activity_seq_,
                                                               capture_session_id_    => capture_session_id_, 
                                                               column_name_           => data_item_id_,
                                                               lov_type_db_           => lov_type_db_,
                                                               sql_where_expression_  => sql_where_expression_);
                                                               
         ELSIF (data_item_id_ = 'CONDITION_CODE') THEN 
            Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, contract_);
         ELSIF (data_item_id_ IN ('INPUT_UOM')) THEN
            input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
            Input_Unit_Meas_API.Create_Data_Capture_Lov(capture_session_id_, input_uom_group_id_, 'UNIT_CODE', lov_type_db_, Get_Input_Uom_Sql_Whr_Exprs___);   
         ELSE
            -- Need to check if this process is run standalone or if its run together with START_COUNT_REPORT. If START_COUNT_REPORT is 
            -- the previous session this process is run together with START_COUNT_REPORT. Then we need to change the lov_id_ so we can 
            -- break the normal sorting and exchange it with route order sorting so location and handling units will be grouped together better.
            session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            IF (Data_Capture_Session_API.Get_Capture_Process_Id(session_rec_.previous_capture_session_id ) = 'START_COUNT_REPORT') THEN
               lov_id_ := 2;
            END IF;
            Counting_Report_Line_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                             inv_list_no_                => inv_list_no_,
                                                             seq_                        => seq_,
                                                             part_no_                    => part_no_,
                                                             location_no_                => location_no_,
                                                             serial_no_                  => serial_no_,
                                                             lot_batch_no_               => lot_batch_no_,
                                                             eng_chg_level_              => eng_chg_level_,
                                                             waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                             activity_seq_               => activity_seq_,
                                                             handling_unit_id_           => handling_unit_id_,
                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                             configuration_id_           => configuration_id_, 
                                                             capture_session_id_         => capture_session_id_, 
                                                             column_name_                => data_item_id_,
                                                             lov_type_db_                => lov_type_db_,
                                                             lov_id_                     => lov_id_,
                                                             sql_where_expression_       => sql_where_expression_);
         END IF;
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
   message_ VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PICKOK: The counting was saved.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PICKSOK: :P1 countings were saved.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;



FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                      VARCHAR2(5);
   inv_list_no_                   VARCHAR2(15);
   seq_                           NUMBER;
   part_no_                       VARCHAR2(25);
   location_no_                   VARCHAR2(35);
   serial_no_                     VARCHAR2(50);
   lot_batch_no_                  VARCHAR2(20);
   waiv_dev_rej_no_               VARCHAR2(15);
   eng_chg_level_                 VARCHAR2(6);
   configuration_id_              VARCHAR2(50);
   condition_code_                VARCHAR2(10);
   activity_seq_                  NUMBER;
   print_barcode_                 VARCHAR2(200);
   barcode_id_                    NUMBER;
   automatic_value_               VARCHAR2(200);
   handling_unit_id_              NUMBER; 
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   sql_where_expression_          VARCHAR2(2000) DEFAULT NULL;
   gtin_no_                       VARCHAR2(14);
   input_uom_                     VARCHAR2(30);
   input_uom_group_id_            VARCHAR2(30);
   input_qty_                     NUMBER;
   input_conv_factor_             NUMBER;
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
         IF (data_item_id_ NOT IN ('PRINT_INVENTORY_PART_BARCODE', 'CONFIRM')) THEN
   
            IF (data_item_id_ = 'BARCODE_ID')  THEN
               -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
               Get_Filter_Keys___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                                  eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                                  gtin_no_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
            ELSE
               Get_Filter_Keys___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                                  eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                                  gtin_no_, capture_session_id_, data_item_id_);
            END IF;
         

            IF (data_item_id_ = 'BARCODE_ID')  THEN
               automatic_value_ := barcode_id_;
            ELSIF (data_item_id_ IN ( 'INV_LIST_NO', 'SEQ', 'LOCATION_NO', 'PART_NO', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'LOT_BATCH_NO', 
                                     'SERIAL_NO', 'ENG_CHG_LEVEL', 'CONFIGURATION_ID', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
      
               condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                                    data_item_id_a_      => 'CONDITION_CODE',
                                                                                    data_item_id_b_      => data_item_id_);
               IF condition_code_ IS NOT NULL AND condition_code_ != 'NULL' THEN 
                  sql_where_expression_ := ' NVL(Condition_Code_Manager_API.Get_Condition_Code(part_no,serial_no,lot_batch_no ) , ''' || string_null_ || ''')=''' || condition_code_ || '''';
               END IF;
         
               IF (barcode_id_ IS NOT NULL AND barcode_id_ != '0' AND 
                   data_item_id_ IN ('PART_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 'ACTIVITY_SEQ')) THEN
                  automatic_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_             => contract_,
                                                                                            barcode_id_           => barcode_id_,
                                                                                            part_no_              => part_no_,
                                                                                            configuration_id_     => configuration_id_,
                                                                                            lot_batch_no_         => lot_batch_no_,
                                                                                            serial_no_            => serial_no_,
                                                                                            eng_chg_level_        => eng_chg_level_,
                                                                                            waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                                                            activity_seq_         => activity_seq_,
                                                                                            column_name_          => data_item_id_,
                                                                                            sql_where_expression_ => sql_where_expression_);
         
               ELSIF (data_item_id_ IN ('INV_LIST_NO', 'SEQ', 'LOCATION_NO', 'PART_NO', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'LOT_BATCH_NO', 
                                        'SERIAL_NO', 'ENG_CHG_LEVEL', 'CONFIGURATION_ID', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
                    
                  automatic_value_ := Counting_Report_Line_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                          inv_list_no_                => inv_list_no_, 
                                                                                          seq_                        => seq_, 
                                                                                          part_no_                    => part_no_, 
                                                                                          location_no_                => location_no_, 
                                                                                          serial_no_                  => serial_no_, 
                                                                                          lot_batch_no_               => lot_batch_no_, 
                                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                                                          eng_chg_level_              => eng_chg_level_, 
                                                                                          configuration_id_           => configuration_id_, 
                                                                                          activity_seq_               => activity_seq_, 
                                                                                          handling_unit_id_           => handling_unit_id_,
                                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                          column_name_                => data_item_id_,
                                                                                          sql_where_expression_       => sql_where_expression_);
                                 
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
            ELSIF (data_item_id_ = 'QTY_COUNT1') THEN
               barcode_id_       := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                      data_item_id_a_     => 'BARCODE_ID',
                                                                                      data_item_id_b_     => data_item_id_);
                                                                                      
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
               -- If barcode id is 0 it indicates that the location is empty and the qty shall be 0.
               ELSIF (barcode_id_ = '0') THEN         
                  automatic_value_ := 0;
               ELSE
                  automatic_value_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_, 
                                                                                 part_no_, 
                                                                                 configuration_id_, 
                                                                                 location_no_, 
                                                                                 lot_batch_no_,
                                                                                 serial_no_, 
                                                                                 eng_chg_level_, 
                                                                                 waiv_dev_rej_no_, 
                                                                                 activity_seq_,
                                                                                 handling_unit_id_);
               END IF;
            ELSIF data_item_id_ = 'CONDITION_CODE' AND part_no_ IS NOT NULL THEN
               IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_) = Condition_Code_Usage_API.DB_NOT_ALLOW_CONDITION_CODE) THEN
                  automatic_value_ := 'NULL';
               ELSE
                  automatic_value_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_,serial_no_,lot_batch_no_);
               END IF;      
            ELSE
               print_barcode_:= Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                  data_item_id_a_     => 'PRINT_INVENTORY_PART_BARCODE',
                                                                                  data_item_id_b_     => data_item_id_); 
               automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, contract_, part_no_, print_barcode_);
            END IF;

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



PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS

   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                     VARCHAR2(5);
   inv_list_no_                  VARCHAR2(15);
   seq_                          NUMBER;
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   waiv_dev_rej_no_              VARCHAR2(15);
   eng_chg_level_                VARCHAR2(6);
   configuration_id_             VARCHAR2(50);
   activity_seq_                 NUMBER;
   barcode_id_                   NUMBER;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   gtin_no_                      VARCHAR2(14);
   condition_code_               VARCHAR2(10);

BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, 
                         configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                         gtin_no_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('INV_LIST_NO', 'SEQ', 'LOCATION_NO', 'PART_NO', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 
                                                                    'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'CONFIGURATION_ID','BARCODE_ID', 
                                                                    'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN

                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           inv_list_no_                => inv_list_no_,
                                           seq_                        => seq_,
                                           part_no_                    => part_no_,
                                           location_no_                => location_no_,
                                           serial_no_                  => serial_no_,
                                           lot_batch_no_               => lot_batch_no_,
                                           waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                           eng_chg_level_              => eng_chg_level_,
                                           configuration_id_           => configuration_id_,
                                           activity_seq_               => activity_seq_,
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

               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('QTY_ONHAND','CATCH_QTY_ONHAND', 'OWNER')) THEN
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
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('LOCATION_NO_DESC','WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID',
                                                                       'RECEIPTS_BLOCKED', 'MIX_OF_PART_NUMBER_BLOCKED', 'MIX_OF_CONDITION_CODES_BLOCKED',
                                                                       'MIX_OF_LOT_BATCH_NO_BLOCKED', 'LOCATION_GROUP', 'LOCATION_TYPE')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);
   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS',
                                                                       'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 'UNIT_MEAS_DESCRIPTION', 'NET_WEIGHT',
                                                                       'NET_VOLUME', 'PART_TYPE', 'PRIME_COMMODITY', 'PRIME_COMMODITY_DESCRIPTION', 
                                                                       'SECOND_COMMODITY', 'SECOND_COMMODITY_DESCRIPTION', 'ASSET_CLASS', 'ASSET_CLASS_DESCRIPTION',
                                                                       'PART_STATUS', 'PART_STATUS_DESCRIPTION', 'ABC_CLASS', 'ABC_CLASS_PERCENT', 'SAFETY_CODE',
                                                                       'SAFETY_CODE_DESCRIPTION', 'ACCOUNTING_GROUP', 'ACCOUNTING_GROUP_DESCRIPTION', 'PRODUCT_CODE',
                                                                       'PRODUCT_CODE_DESCRIPTION', 'PRODUCT_FAMILY', 'PRODUCT_FAMILY_DESCRIPTION',  
                                                                       'SERIAL_TRACKING_RECEIPT_ISSUE', 'SERIAL_TRACKING_INVENTORY', 'SERIAL_TRACKING_DELIVERY', 
                                                                       'STOP_ARRIVAL_ISSUED_SERIAL', 'STOP_NEW_SERIAL_IN_RMA', 'SERIAL_RULE', 'LOT_BATCH_TRACKING', 
                                                                       'LOT_QUANTITY_RULE', 'SUB_LOT_RULE', 'COMPONENT_LOT_RULE', 'GTIN_IDENTIFICATION', 'GTIN_DEFAULT',
                                                                       'INPUT_CONV_FACTOR')) THEN
   
                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       contract_             => contract_,
                                                                       part_no_              => part_no_);

   
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROGRAM_ID', 'PROGRAM_DESCRIPTION', 'PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID',
                                                                       'SUB_PROJECT_DESCRIPTION', 'ACTIVITY_ID', 'ACTIVITY_DESCRIPTION')) THEN
   
                  Data_Capture_Invent_Util_API.Add_Details_For_Activity_Seq(capture_session_id_   => capture_session_id_,
                                                                            owning_data_item_id_  => latest_data_item_id_,
                                                                            data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                            activity_seq_         => activity_seq_);
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

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'CONDITION_CODE_DESCRIPTION') THEN
 
                  condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                              		   data_item_id_a_      => 'CONDITION_CODE',
                                                                                       data_item_id_b_      => latest_data_item_id_); 
                  Data_Capture_Invent_Util_API.Add_Condition_Code_Desc(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       condition_code_       => condition_code_); 
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
   ptr_                          NUMBER;
   name_                         VARCHAR2(50);
   value_                        VARCHAR2(4000);
   inv_list_no_                  VARCHAR2(15);
   seq_                          NUMBER;
   qty_count1_                   NUMBER;
   qty_onhand_                   NUMBER;
   catch_qty_counted_            NUMBER;
   catch_qty_onhand_             NUMBER;
   confirm_                      VARCHAR2(5);
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   waiv_dev_rej_no_              VARCHAR2(15);
   eng_chg_level_                VARCHAR2(6);
   configuration_id_             VARCHAR2(50);
   activity_seq_                 NUMBER;
   count_attr_                   VARCHAR2(32000);
   print_inventory_part_barcode_ VARCHAR2(200) := Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_NO);
   origin_pack_size_             NUMBER := 1;
   handling_unit_id_             NUMBER;
   unique_value_                 VARCHAR2(200);
   rowid_                        VARCHAR2(2000);
   counting_date_                DATE;
   blob_ref_tab_                 Data_Capture_Common_Util_API.Blob_Ref_Tab;
   blob_data_item_value_         VARCHAR2(2000);
   image_seq_                    NUMBER := 0;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INV_LIST_NO') THEN
         inv_list_no_ := value_;
      ELSIF (name_ = 'SEQ') THEN
         seq_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_;
      ELSIF (name_ = 'SERIAL_NO') THEN
         serial_no_ := value_;
      ELSIF (name_ = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_;
      ELSIF (name_ = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_;
      ELSIF (name_ = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_;
      ELSIF (name_ = 'ACTIVITY_SEQ') THEN
         activity_seq_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'QTY_COUNT1') THEN
         qty_count1_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'CATCH_QTY_COUNTED') THEN  
         catch_qty_counted_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'CONFIRM') THEN
         confirm_ := value_;
      ELSIF (name_ = 'PRINT_INVENTORY_PART_BARCODE') THEN
         print_inventory_part_barcode_ := value_;
      ELSIF (name_ = 'ORIGIN_PACK_SIZE') THEN
         origin_pack_size_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_;
      END IF;
   END LOOP; 

   unique_value_ := Counting_Report_Line_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                        inv_list_no_                => inv_list_no_, 
                                                                        seq_                        => seq_, 
                                                                        part_no_                    => part_no_, 
                                                                        location_no_                => location_no_, 
                                                                        serial_no_                  => serial_no_, 
                                                                        lot_batch_no_               => lot_batch_no_, 
                                                                        waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                                        eng_chg_level_              => eng_chg_level_, 
                                                                        configuration_id_           => configuration_id_, 
                                                                        activity_seq_               => activity_seq_,
                                                                        handling_unit_id_           => handling_unit_id_,
                                                                        alt_handling_unit_label_id_ => Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(handling_unit_id_), 
                                                                        column_name_                => 'QTY_ONHAND');  

   IF unique_value_ != 'NULL' THEN
      qty_onhand_ := unique_value_;
   END IF;
   unique_value_ := Counting_Report_Line_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                        inv_list_no_                => inv_list_no_, 
                                                                        seq_                        => seq_, 
                                                                        part_no_                    => part_no_, 
                                                                        location_no_                => location_no_, 
                                                                        serial_no_                  => serial_no_, 
                                                                        lot_batch_no_               => lot_batch_no_, 
                                                                        waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                                        eng_chg_level_              => eng_chg_level_, 
                                                                        configuration_id_           => configuration_id_, 
                                                                        activity_seq_               => activity_seq_,
                                                                        handling_unit_id_           => handling_unit_id_,
                                                                        alt_handling_unit_label_id_ => Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(handling_unit_id_), 
                                                                        column_name_                => 'CATCH_QTY_ONHAND');

   IF unique_value_ != 'NULL' THEN
      catch_qty_onhand_ := unique_value_;
   END IF;
   
   Client_SYS.Clear_Attr(count_attr_);
   Client_SYS.Add_To_Attr('QTY_COUNT1', qty_count1_, count_attr_);
   Client_SYS.Add_To_Attr('QTY_ONHAND', qty_onhand_, count_attr_);
   IF catch_qty_counted_ IS NOT NULL THEN 
      Client_SYS.Add_To_Attr('CATCH_QTY_COUNTED', catch_qty_counted_, count_attr_);
   END IF;
   IF catch_qty_onhand_ IS NOT NULL THEN 
      Client_SYS.Add_To_Attr('CATCH_QTY_ONHAND', catch_qty_onhand_, count_attr_);
   END IF;
   Counting_Report_Line_API.Count_And_Confirm_Line(inv_list_no_ => inv_list_no_,
                                                   seq_         => seq_,
                                                   attr_        => count_attr_,
                                                   confirm_     => confirm_);
                                                   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Convert blob references from attribute string to collection for easier handling     
      blob_ref_tab_ := Data_Capt_Sess_Line_Blob_API.Get_Blob_Ref_Tab_From_Attr(blob_ref_attr_);
      IF (blob_ref_tab_.COUNT > 0) THEN         
         counting_date_ := Counting_Report_Line_API.Get_Last_Count_Date(inv_list_no_, contract_, part_no_, configuration_id_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
                                                                                    
         rowid_ := Counting_result_API.Get_Row_Identity( contract_                   => contract_,                                                   
                                                         part_no_                    => part_no_, 
                                                         location_no_                => location_no_, 
                                                         serial_no_                  => serial_no_, 
                                                         lot_batch_no_               => lot_batch_no_, 
                                                         waiv_dev_rej_no_            => waiv_dev_rej_no_, 
                                                         eng_chg_level_              => eng_chg_level_, 
                                                         configuration_id_           => configuration_id_, 
                                                         activity_seq_               => activity_seq_,
                                                         handling_unit_id_           => handling_unit_id_,
                                                         count_date_                 => counting_date_);
                                                   
            -- Iterate collection of blob references, extract photos, and save/connect each one to the desired object
            FOR i IN blob_ref_tab_.FIRST..blob_ref_tab_.LAST LOOP
               image_seq_ := image_seq_ + 1;
               blob_data_item_value_ := capture_session_id_ || '|' || blob_ref_tab_(i).session_line_no || '|' || blob_ref_tab_(i).blob_id; 
               Data_Capt_Sess_Line_Blob_API.Save_To_Media_Library(blob_data_item_value_ => blob_data_item_value_, 
                                                                  lu_                   => 'CountingResult', 
                                                                  lu_objid_             => rowid_, -- rowid is objid.
                                                                  name_                 => 'WADACO Count Part per Count Report '||image_seq_,
                                                                  description_          => 'WADACO Count Part per Count Report '||image_seq_ );
            END LOOP;
         END IF;         
      
   $END                                                
   
   -- Printing of inventory barcode id.
   IF (print_inventory_part_barcode_ = Gen_Yes_No_API.DB_YES) THEN
      Inventory_Part_Barcode_API.Create_And_Print(contract_         => contract_,
                                                  part_no_          => part_no_,
                                                  configuration_id_ => '*',
                                                  lot_batch_no_     => lot_batch_no_,
                                                  serial_no_        => serial_no_,
                                                  eng_chg_level_    => eng_chg_level_,
                                                  waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                  origin_pack_size_ => origin_pack_size_,
                                                  activity_seq_     => activity_seq_,
                                                  quantity_         => qty_count1_);
   END IF;   
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Counting_Report_Line_API.Count_And_Confirm_Line is granted thru following projection/entity action and entity CRUD
   IF (Security_SYS.Is_Proj_Entity_Cud_Available('CountPerCountReport', 'CountingReportLine') AND 
       Security_SYS.Is_Proj_Entity_Act_Available('CountPerCountReport', 'CountingReportLine', 'ConfirmLine')) THEN
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
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   process_package_               VARCHAR2(30);
   contract_                      VARCHAR2(5);
   inv_list_no_                   VARCHAR2(15);
   seq_                           NUMBER;
   part_no_                       VARCHAR2(25);
   location_no_                   VARCHAR2(35);
   serial_no_                     VARCHAR2(50);
   lot_batch_no_                  VARCHAR2(20);
   waiv_dev_rej_no_               VARCHAR2(15);
   eng_chg_level_                 VARCHAR2(6);
   configuration_id_              VARCHAR2(50);
   condition_code_                VARCHAR2(10);
   activity_seq_                  NUMBER;
   barcode_id_                    NUMBER;
   handling_unit_id_              NUMBER;
   sscc_                          VARCHAR2(18);
   alt_handling_unit_label_id_    VARCHAR2(25);
   temp_data_item_id_             VARCHAR2(50);
   gtin_no_                       VARCHAR2(14);
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
      -- if predicted part_no_ is null then try fetch it with unique handling
      IF (part_no_ IS NULL) THEN
         Get_Filter_Keys___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, configuration_id_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_,
                            gtin_no_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);
         condition_code_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_, 
                                                                              data_item_id_a_      => 'CONDITION_CODE',
                                                                              data_item_id_b_      => data_item_id_);
         part_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, condition_code_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
      END IF;
      IF (data_item_id_ = 'QTY_COUNT1') THEN 
         temp_data_item_id_ := 'QUANTITY';
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
         END IF;
      ELSE 
         temp_data_item_id_ := data_item_id_;
      END IF;
      
      RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, temp_data_item_id_, part_no_, serial_no_);
   $ELSE
      RETURN NULL;
   $END
END Fixed_Value_Is_Applicable;
