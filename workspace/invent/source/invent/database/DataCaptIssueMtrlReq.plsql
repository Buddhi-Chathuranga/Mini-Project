-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptIssueMtrlReq
--
--  Purpose: Utility LU for handling Material Requisition Line Process for DataCaptureProcess
--
--  IFS Developer Studio Template Version 2.5
--
--  Supported process: ISSUE_MATERIAL_REQUIS_LINE
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------
--  200818  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171129  CKumlk  STRSC-14828, Modified Add_Filter_Key_Detail___ to handle GTIN.
--  171115  DaZase  STRSC-8865, Added extra Invpart Barcode and GTIN/part validation against the current Material Requisition Line record in Validate_Data_Item. 
--  171023  DaZase  STRSC-13014, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171023          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  171004  CKumlk  STRSC-11277, Implemented GTIN support, hence handled GTIN, INPUT_UOM and INPUT_QUANTITY data items 
--  171004          and INPUT_CONV_FACTOR as feedback item and GTIN_IS_MANDATORY as detail item.
--  170622  RuLiLk  Bug 136509, Modified methods Add_Details_For_Matr_Req___, Validate_Data_Item, Get_Automatic_Data_Item_Value, Execute_Process
--  170622          to pass the client value for Material_Requis_Type_API.DB_INT when necessary.
--  170418  DaZase  LIM-10662, Changes in Get_Filter_Keys___ on how Bug 132004 was solved, now we check if inventory barcode is enabled correctly. 
--  170302  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170125  ChBnlk  Bug 133838, Modified Execute_Process() by Passing client value for the parameter order_class_ of the method call Material_Requis_Reservat_API.Make_Item_Delivery() 
--  170125          instead of the db value to avoid translation issues. 
--  170118  SWiclk   Bug 132477, Modified Add_Details_For_Matr_Req___() by removing the conversion of date to char since it will be handled in data_capture_session_line_apt.
--  170113  DaZase  LIM-8660, Change the catch quantity validation in Validate_Data_Item a bit due to interface changes.  
--  161109  SWiclk  LIM-5313,Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161010  SWiclk  Bug 132004, Modified Get_Filter_Keys___() and Validate_Data_Item() in order to check whether  
--  161010          Barcode Id is mandatory or not before trying to fetch a unique value.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  151104  DaZase  LIM-4281, Added handling for new data items HANDLING_UNIT_ID, SSCC and ALT_HANDLING_UNIT_LABEL_ID. Added calls 
--  151104          to Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type, Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit 
--  151104          in Add_Details_For_Latest_Item due to many new feedback items.
--  150826  RuLiLk  Bug 124207, Modified error message ISSUEMORETHENQTYLEFT, ISSUEMOREQTYLEFTLOC, to display quantity between 0 and 1 with a leading 0.
--  150803  SWiclk  Bug 121254, Modified Get_Unique_Data_Item_Value___(), Validate_Data_Item(), Get_Automatic_Data_Item_Value() and Create_List_Of_Values()  
--  150803          by changing the parameter list of methods which are from Inventory_Part_Barcode_API since the contract has been changed as a parentkey.
--  150421  JeLise  LIM-1233, Added handling_unit_id_.
--  150218  JeLise  PRSC-6086, Modified Create_List_Of_Values for data_item_id_ 'ORDER_NO'.
--  150217  KHVESE  PRSC-6043, Changed Get_Automatic_Data_Item_Value() method to assign value 1 to automatic_value for QTY_TO_ISSUE when issued Rcpt is Serial Tracked.
--  150216  KHVESE  PRSC-6043, Changed the call to Material_Requis_Reservat_API.Get_Qty_Assigned_If_Unique for serial_no_ by sending '*' value if 
--  150216          serial is in stock but not identified and the Serial_no_ value if it is identified.
--  150206  MaEelk  PRSC-5981, Corrected the spelling mistake in the given messages at Get_Process_Execution_Message.
--  150202  DaZase  PRSC-5642, Made some changes so this code match the one from WDC extension better.
--  150129  DaZase  PRSC-5666, Change in Get_Filter_Keys___ for how serial_no_ is handled when serial tracked but not inventory 
--  150129          so in those cases serial_no is handled as NULL when used as a filter key.
--  150128  DaZase  PRSC-5644, Fixes in Get_Automatic_Data_Item_Value so it will always return something.
--  141024  RuLiLk  Bug 113690, Modified method Use_Reservat_As_Data_Source___ by removing a condition to support serial handling parts.
--  141024          Modified method Get_Data_Item_Value___, Validate_Data_Item, Create_List_Of_Values, Execute_Process to handle SERIAL_NO separately.
--  141024          Modified Get_Automatic_Data_Item_Value to handle QTY_TO_ISSUE and SERIAL_NO.                                                                               
--  140108  DaZase  Bug 113690, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


FUNCTION Use_Reservat_As_Data_Source___ (
   issue_unreserved_enabled_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   return_value_ BOOLEAN;
BEGIN
   IF (issue_unreserved_enabled_ = Fnd_Boolean_API.DB_FALSE) THEN
      return_value_ := TRUE;
   ELSE
      return_value_ := FALSE;
   END IF;
   RETURN return_value_;
END Use_Reservat_As_Data_Source___;

   
FUNCTION Get_Unique_Data_Item_Value___ (
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN NUMBER,
   part_no_                    IN VARCHAR2,
   contract_                   IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,
   issue_unreserved_enabled_   IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   wanted_data_item_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_                VARCHAR2(200);
   use_reservat_as_data_source_ BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (wanted_data_item_id_ = 'BARCODE_ID' OR (barcode_id_ IS NOT NULL AND  
          wanted_data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ'))) THEN
         unique_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(contract_         => contract_,
                                                                                barcode_id_       => barcode_id_,
                                                                                part_no_          => part_no_,
                                                                                configuration_id_ => configuration_id_,
                                                                                lot_batch_no_     => lot_batch_no_,
                                                                                serial_no_        => serial_no_,
                                                                                eng_chg_level_    => eng_chg_level_,
                                                                                waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                activity_seq_     => activity_seq_,
                                                                                column_name_      => wanted_data_item_id_);
      ELSIF (wanted_data_item_id_ IN ('ORDER_NO', 'LINE_NO', 'RELEASE_NO', 'LINE_ITEM_NO', 'PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 
                                      'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 
                                      'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
         use_reservat_as_data_source_ := Use_Reservat_As_Data_Source___(issue_unreserved_enabled_);

         IF (use_reservat_as_data_source_) THEN
            -- ISSUE_UNRESERVED_MATERIAL is not enabled or its enabled and there exists reservations
            unique_value_ := Material_Requis_Reservat_API.Get_Column_Value_If_Unique(order_no_                   => order_no_, 
                                                                                     line_no_                    => line_no_,
                                                                                     release_no_                 => release_no_,
                                                                                     line_item_no_               => line_item_no_,
                                                                                     part_no_                    => part_no_,
                                                                                     contract_                   => contract_,
                                                                                     configuration_id_           => configuration_id_,
                                                                                     location_no_                => location_no_,
                                                                                     lot_batch_no_               => lot_batch_no_,
                                                                                     serial_no_                  => serial_no_,
                                                                                     waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                     eng_chg_level_              => eng_chg_level_,
                                                                                     activity_seq_               => activity_seq_,
                                                                                     handling_unit_id_           => handling_unit_id_,
                                                                                     alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                     column_name_                => wanted_data_item_id_);
         ELSE -- ISSUE_UNRESERVED_MATERIAL is enabled, but we cannot identity specific MRL yet or no reservations exist
            unique_value_ := Material_Requis_Line_API.Get_Column_Value_If_Unique(order_no_                   => order_no_,
                                                                                 line_no_                    => line_no_,
                                                                                 release_no_                 => release_no_,
                                                                                 line_item_no_               => line_item_no_,
                                                                                 part_no_                    => part_no_,
                                                                                 contract_                   => contract_,
                                                                                 configuration_id_           => configuration_id_,
                                                                                 location_no_                => location_no_,
                                                                                 lot_batch_no_               => lot_batch_no_,
                                                                                 serial_no_                  => serial_no_,
                                                                                 waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                 eng_chg_level_              => eng_chg_level_,
                                                                                 activity_seq_               => activity_seq_,
                                                                                 handling_unit_id_           => handling_unit_id_,
                                                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                 column_name_                => wanted_data_item_id_);
         END IF;
      ELSIF (wanted_data_item_id_ = 'SERIAL_NO') THEN
         -- NOTE: If the part is receipt and issue tracked, but not tracked in inventory, the serial no should not be used in filter.
         IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
             Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
            unique_value_ := NULL;
         END IF;
      END IF;
     IF (unique_value_ = 'NULL') THEN
         unique_value_ := NULL;
      END IF;
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   order_no_                    OUT VARCHAR2,
   line_no_                     OUT VARCHAR2,
   release_no_                  OUT VARCHAR2,
   line_item_no_                OUT NUMBER,
   part_no_                     OUT VARCHAR2,
   contract_                    OUT VARCHAR2,
   configuration_id_            OUT VARCHAR2,
   location_no_                 OUT VARCHAR2,
   lot_batch_no_                OUT VARCHAR2,
   serial_no_                   OUT VARCHAR2,
   waiv_dev_rej_no_             OUT VARCHAR2,
   eng_chg_level_               OUT VARCHAR2,
   activity_seq_                OUT NUMBER,
   use_reservat_as_data_source_ OUT BOOLEAN,   -- not a filter key, used for controlling which datasource should be used
   barcode_id_                  OUT NUMBER,
   handling_unit_id_            OUT NUMBER,
   sscc_                        OUT VARCHAR2,  -- not used for filtering in unique handling
   alt_handling_unit_label_id_  OUT VARCHAR2,
   gtin_no_                     OUT VARCHAR2,
   issue_unreserved_enabled_    IN  VARCHAR2,
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
      use_reservat_as_data_source_ := Use_Reservat_As_Data_Source___(issue_unreserved_enabled_);

      -- First try and fetch "predicted" filter keys 
      order_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ORDER_NO', session_rec_ , process_package_, use_applicable_);
      line_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LINE_NO', session_rec_ , process_package_, use_applicable_);
      release_no_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RELEASE_NO', session_rec_ , process_package_, use_applicable_);
      line_item_no_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LINE_ITEM_NO', session_rec_ , process_package_, use_applicable_);
      part_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      configuration_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      activity_seq_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
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
         IF (order_no_ IS NULL) THEN
            order_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'ORDER_NO');
         END IF;
         IF (line_no_ IS NULL) THEN
            line_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'LINE_NO');
         END IF;
         IF (release_no_ IS NULL) THEN
            release_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'RELEASE_NO');
         END IF;
         IF (line_item_no_ IS NULL) THEN
            line_item_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'LINE_ITEM_NO');
         END IF;
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'PART_NO');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'ACTIVITY_SEQ');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'LOCATION_NO');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_,  activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'BARCODE_ID');
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
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN NUMBER,
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
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('ORDER_NO') THEN
            detail_value_ := order_no_;
         WHEN ('LINE_NO') THEN
            detail_value_ := line_no_;
         WHEN ('RELEASE_NO') THEN
            detail_value_ := release_no_;
         WHEN ('LINE_ITEM_NO') THEN
            detail_value_ := line_item_no_;
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

      -- Non filter key data items that could be fetched by unique handling
      -- Add any such items here, at the moment none exist so code is commented
      /*IF (detail_value_ IS NULL AND data_item_detail_id_ IN ()) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, seq_, part_no_, location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, data_item_detail_id_);
      END IF;*/

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


PROCEDURE Add_Details_For_Matr_Req___ (
   capture_session_id_  IN NUMBER,        
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   release_no_          IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   matr_req_rec_      Material_Requisition_API.Public_Rec;
   matr_req_line_rec_ Material_Requis_Line_API.Public_Rec;
   data_item_value_   VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_detail_id_ IN ('TOTAL_VALUE','INT_CUSTOMER_NO' ,'INT_CUSTOMER_NAME', 
                                   'DESTINATION_ID', 'INTERNAL_DESTINATION', 'HEAD_STATUS_CODE')) THEN  -- fetch from head
         matr_req_rec_ := Material_Requisition_API.Get(Material_Requis_Type_API.DB_INT, order_no_);
      ELSE -- fetch from line
         matr_req_line_rec_ := Material_Requis_Line_API.Get(Material_Requis_Type_API.DB_INT, order_no_, line_no_, release_no_, line_item_no_);
      END IF;

      CASE (data_item_detail_id_)
         WHEN ('TOTAL_VALUE') THEN
            data_item_value_ := Material_Requisition_API.Get_Total_Value(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, 'TRUE');
         WHEN ('INT_CUSTOMER_NO') THEN
            data_item_value_ := matr_req_rec_.int_customer_no;
         WHEN ('INT_CUSTOMER_NAME') THEN
            data_item_value_ := Internal_Customer_API.Get_Name(matr_req_rec_.int_customer_no);
         WHEN ('DESTINATION_ID') THEN
            data_item_value_ := matr_req_rec_.destination_id;
         WHEN ('INTERNAL_DESTINATION') THEN
            data_item_value_ := matr_req_rec_.internal_destination;                  
         WHEN ('HEAD_STATUS_CODE') THEN
            data_item_value_ := matr_req_rec_.status_code;
         WHEN ('UNIT_MEAS') THEN
            data_item_value_ := matr_req_line_rec_.unit_meas;
         WHEN ('UNIT_MEAS_DESCRIPTION') THEN
            data_item_value_ := Iso_Unit_API.Get_Description(matr_req_line_rec_.unit_meas);
         WHEN ('QTY_DUE') THEN
            data_item_value_ := matr_req_line_rec_.qty_due;
         WHEN ('QTY_ASSIGNED') THEN
            data_item_value_ := matr_req_line_rec_.qty_assigned;
         WHEN ('QTY_SHIPPED') THEN
            data_item_value_ := matr_req_line_rec_.qty_shipped;
         WHEN ('QTY_ON_ORDER') THEN
            data_item_value_ := matr_req_line_rec_.qty_on_order;
         WHEN ('QTY_RETURNED') THEN
            data_item_value_ := matr_req_line_rec_.qty_returned;
         WHEN ('CONDITION_CODE') THEN
            data_item_value_ := matr_req_line_rec_.condition_code;
         WHEN ('CONDITION_CODE_DESCRIPTION') THEN
            data_item_value_ := Condition_Code_API.Get_Description(matr_req_line_rec_.condition_code);
         WHEN ('PLANNED_DELIVERY_DATE') THEN
            data_item_value_ := matr_req_line_rec_.planned_delivery_date;
         WHEN ('DUE_DATE') THEN
            data_item_value_ := matr_req_line_rec_.due_date;
         WHEN ('SUPPLY_CODE') THEN
            data_item_value_ := matr_req_line_rec_.supply_code;
         WHEN ('LINE_STATUS_CODE') THEN
            data_item_value_ := matr_req_line_rec_.status_code;
         ELSE
            NULL;
      END CASE;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => data_item_value_);
   $ELSE
      NULL;
   $END
END Add_Details_For_Matr_Req___;

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
   contract_                    VARCHAR2(5);
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   release_no_                  VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   activity_seq_                NUMBER;
   catch_qty_to_issue_          NUMBER;
   issue_unreserved_enabled_    VARCHAR2(5);
   use_reservat_as_data_source_ BOOLEAN;
   receipt_issue_serial_        PART_CATALOG_TAB.receipt_issue_serial_track%TYPE;
   serial_tracking_             PART_CATALOG_TAB.serial_tracking_code%TYPE;
   qty_reserved_                NUMBER;
   qty_to_issue_                NUMBER;
   qty_left_                    NUMBER;
   data_item_description_       VARCHAR2(200);
   barcode_id_                  NUMBER;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   column_value_nullable_       BOOLEAN := FALSE;
   input_unit_meas_group_id_    VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
   gtin_part_no_                VARCHAR2(25);
   local_part_no_               VARCHAR2(25);
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
      issue_unreserved_enabled_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ISSUE_UNRESERVED_MATERIAL');
      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- Note: No need to get values for process keys when barcode_id is null because probably it would not be used in this process.
         IF (data_item_value_ IS NOT NULL) THEN 
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                               eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                               issue_unreserved_enabled_, capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE);
         END IF;         
      ELSE
         Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                            issue_unreserved_enabled_, capture_session_id_, data_item_id_, data_item_value_);
      END IF;
      receipt_issue_serial_ := Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_);
      serial_tracking_      := Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_);
      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
      
      IF (data_item_id_ IN ('ORDER_NO', 'LINE_NO', 'RELEASE_NO', 'LINE_ITEM_NO', 'PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 
                            'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ',
                            'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID'))
          OR ((data_item_id_ = 'SERIAL_NO') AND (receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE) AND 
              (serial_tracking_ = Part_Serial_Tracking_API.DB_SERIAL_TRACKING)) THEN
   
          IF (barcode_id_ IS NOT NULL AND 
             data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ')) THEN
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
            IF (data_item_id_ IN ('SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ = 'HANDLING_UNIT_ID' AND data_item_value_ > 0) THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
            IF (use_reservat_as_data_source_) THEN
               -- ISSUE_UNRESERVED_MATERIAL is not enabled or its enabled and there exists reservations
               Material_Requis_Reservat_API.Record_With_Column_Value_Exist(order_no_                   => order_no_, 
                                                                           line_no_                    => line_no_,
                                                                           release_no_                 => release_no_,
                                                                           line_item_no_               => line_item_no_,
                                                                           part_no_                    => part_no_,
                                                                           contract_                   => contract_,
                                                                           configuration_id_           => configuration_id_,
                                                                           location_no_                => location_no_,
                                                                           lot_batch_no_               => lot_batch_no_,
                                                                           serial_no_                  => serial_no_,
                                                                           waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                           eng_chg_level_              => eng_chg_level_,
                                                                           activity_seq_               => activity_seq_,
                                                                           handling_unit_id_           => handling_unit_id_,
                                                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                           column_name_                => data_item_id_,
                                                                           column_value_               => data_item_value_,
                                                                           data_item_description_      => data_item_description_,
                                                                           column_value_nullable_      => column_value_nullable_);
            ELSE -- ISSUE_UNRESERVED_MATERIAL is enabled, but we cannot identity specific MRL yet or no reservations exist
               Material_Requis_Line_API.Record_With_Column_Value_Exist(order_no_                   => order_no_,
                                                                       line_no_                    => line_no_,
                                                                       release_no_                 => release_no_,
                                                                       line_item_no_               => line_item_no_,
                                                                       part_no_                    => part_no_,
                                                                       contract_                   => contract_,
                                                                       configuration_id_           => configuration_id_,
                                                                       location_no_                => location_no_,
                                                                       lot_batch_no_               => lot_batch_no_,
                                                                       serial_no_                  => serial_no_,
                                                                       waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                       eng_chg_level_              => eng_chg_level_,
                                                                       activity_seq_               => activity_seq_,
                                                                       handling_unit_id_           => handling_unit_id_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       column_name_                => data_item_id_,
                                                                       column_value_               => data_item_value_,
                                                                       data_item_description_      => data_item_description_,
                                                                       column_value_nullable_      => column_value_nullable_);
            END IF;
         END IF;
      ELSIF (data_item_id_ = 'BARCODE_ID') THEN         
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

            -- Also validate if the barcode values match the current material requisition line record (if such record have been identified already by line keys for example)
            IF (use_reservat_as_data_source_) THEN
               -- ISSUE_UNRESERVED_MATERIAL is not enabled or its enabled and there exists reservations
               Material_Requis_Reservat_API.Record_With_Column_Value_Exist(order_no_                   => order_no_, 
                                                                           line_no_                    => line_no_,
                                                                           release_no_                 => release_no_,
                                                                           line_item_no_               => line_item_no_,
                                                                           part_no_                    => part_no_,
                                                                           contract_                   => contract_,
                                                                           configuration_id_           => configuration_id_,
                                                                           location_no_                => location_no_,
                                                                           lot_batch_no_               => lot_batch_no_,
                                                                           serial_no_                  => serial_no_,
                                                                           waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                           eng_chg_level_              => eng_chg_level_,
                                                                           activity_seq_               => activity_seq_,
                                                                           handling_unit_id_           => handling_unit_id_,
                                                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                           column_name_                => NULL,
                                                                           column_value_               => NULL,
                                                                           data_item_description_      => NULL,
                                                                           column_value_nullable_      => column_value_nullable_,
                                                                           inv_barcode_validation_     => TRUE);
            ELSE -- ISSUE_UNRESERVED_MATERIAL is enabled, but we cannot identity specific MRL yet or no reservations exist
               Material_Requis_Line_API.Record_With_Column_Value_Exist(order_no_                   => order_no_,
                                                                       line_no_                    => line_no_,
                                                                       release_no_                 => release_no_,
                                                                       line_item_no_               => line_item_no_,
                                                                       part_no_                    => part_no_,
                                                                       contract_                   => contract_,
                                                                       configuration_id_           => configuration_id_,
                                                                       location_no_                => location_no_,
                                                                       lot_batch_no_               => lot_batch_no_,
                                                                       serial_no_                  => serial_no_,
                                                                       waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                       eng_chg_level_              => eng_chg_level_,
                                                                       activity_seq_               => activity_seq_,
                                                                       handling_unit_id_           => handling_unit_id_,
                                                                       alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                       column_name_                => NULL,
                                                                       column_value_               => NULL,
                                                                       data_item_description_      => NULL,
                                                                       column_value_nullable_      => column_value_nullable_,
                                                                       inv_barcode_validation_     => TRUE);
            END IF;
         END IF; 

      ELSIF (data_item_id_ = 'GTIN') THEN
         gtin_part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(data_item_value_);
         IF (gtin_part_no_ IS NOT NULL) THEN
            local_part_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                data_item_id_a_     => 'PART_NO',
                                                                                data_item_id_b_     => data_item_id_);
            IF (local_part_no_ IS NULL)  THEN
               -- Sending NULL for part_no and all items that can be applicable handled and are part_no connected
               -- since these could have gotten their values from the gtin in Get_Filter_Keys___ that might not be correct.
               -- The order_no_, line_no_, release_no_ and line_item_no_ are the important filter keys here since they will point out 1 record.
               local_part_no_ := Get_Unique_Data_Item_Value___(order_no_           => order_no_,
                                                               line_no_            => line_no_, 
                                                               release_no_         => release_no_, 
                                                               line_item_no_       => line_item_no_, 
                                                               part_no_            => NULL, 
                                                               contract_           => contract_, 
                                                               configuration_id_   => NULL, 
                                                               location_no_        => location_no_, 
                                                               lot_batch_no_       => NULL, 
                                                               serial_no_          => NULL,  
                                                               waiv_dev_rej_no_    => waiv_dev_rej_no_, 
                                                               eng_chg_level_      => eng_chg_level_,  
                                                               activity_seq_       => activity_seq_, 
                                                               handling_unit_id_   => handling_unit_id_, 
                                                               alt_handling_unit_label_id_ => alt_handling_unit_label_id_, 
                                                               issue_unreserved_enabled_ => issue_unreserved_enabled_, 
                                                               barcode_id_          => barcode_id_, 
                                                               wanted_data_item_id_ => 'PART_NO');
            END IF;
            IF (local_part_no_ IS NOT NULL AND gtin_part_no_ != local_part_no_)  THEN
               -- This error is needed, since the part taken from GTIN dont match the already scanned part or the part that the unique record points to.
               Error_SYS.Record_General(lu_name_, 'GTINDONTMATCH: The GTIN No does not match current Material Requisition Line.');
            END IF;
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
            receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE AND qty_to_issue_ NOT IN (0,1)) THEN
            Error_SYS.Record_General(lu_name_,'SERIALPARTQTYWRONG: A serial handled Part can only have Quantity value of 1 or 0.');
         END IF;

         IF (order_no_ IS NOT NULL AND line_no_ IS NOT NULL AND release_no_ IS NOT NULL AND line_item_no_ IS NOT NULL) THEN
            qty_reserved_ := Material_Requis_Line_API.Get_Qty_Assigned(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_);
            qty_left_     := Material_Requis_Line_API.Get_Qty_Due(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_) -
                             Material_Requis_Line_API.Get_Qty_Shipped(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_) - qty_reserved_;

            -- Quantity to issue is validated against Quantity left to reserve + already reserved quantity.
            IF (qty_to_issue_ > (qty_left_ + qty_reserved_)) THEN
               Error_SYS.Record_General(lu_name_, 'ISSUEMORETHENQTYLEFT: Cannot Issue more than the quantity left on material requisition line which is :P1.', Data_Capture_Common_Util_API.Get_Leading_Zero_For_Decimals(qty_left_ + qty_reserved_));
            END IF;
         END IF;
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
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   release_no_                  VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   configuration_id_            VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   eng_chg_level_               VARCHAR2(6);
   waiv_dev_rej_no_             VARCHAR2(15);
   activity_seq_                NUMBER;
   issue_unreserved_enabled_    VARCHAR2(5);
   use_reservat_as_data_source_ BOOLEAN;
   barcode_id_                  NUMBER;
   dummy_contract_              VARCHAR2(5);
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   lov_type_db_                 VARCHAR2(20);
   input_uom_group_id_          VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_              := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      issue_unreserved_enabled_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ISSUE_UNRESERVED_MATERIAL');

      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
         Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, dummy_contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                            issue_unreserved_enabled_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
      ELSE
         Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, dummy_contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                            issue_unreserved_enabled_, capture_session_id_, data_item_id_);
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
      ELSIF (data_item_id_ IN ('ORDER_NO', 'LINE_NO', 'RELEASE_NO', 'LINE_ITEM_NO', 'PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 
                               'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ',
                               'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
                               
         IF (data_item_id_ = 'ORDER_NO' AND line_no_ IS NULL AND release_no_ IS NULL AND line_item_no_ IS NULL AND part_no_ IS NULL 
             AND location_no_ IS NULL AND serial_no_ IS NULL AND lot_batch_no_ IS NULL) THEN
            -- If using subsequent and the requisition has been completly processed, order_no_ has to be null to show all available requisitions
            order_no_ := NULL;
         END IF;
         
         IF (use_reservat_as_data_source_) THEN
            -- ISSUE_UNRESERVED_MATERIAL is not enabled or its enabled and there exists reservations
            Material_Requis_Reservat_API.Create_Data_Capture_Lov(order_no_                   => order_no_, 
                                                                 line_no_                    => line_no_,
                                                                 release_no_                 => release_no_,
                                                                 line_item_no_               => line_item_no_,
                                                                 part_no_                    => part_no_,
                                                                 contract_                   => contract_,
                                                                 configuration_id_           => configuration_id_,
                                                                 location_no_                => location_no_,
                                                                 lot_batch_no_               => lot_batch_no_,
                                                                 serial_no_                  => serial_no_,
                                                                 waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                 eng_chg_level_              => eng_chg_level_,
                                                                 activity_seq_               => activity_seq_,
                                                                 handling_unit_id_           => handling_unit_id_,
                                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                 capture_session_id_         => capture_session_id_,
                                                                 column_name_                => data_item_id_,
                                                                 lov_type_db_                => lov_type_db_);
         ELSE -- ISSUE_UNRESERVED_MATERIAL is enabled, but we cannot identity specific MRL yet or no reservations exist
            Material_Requis_Line_API.Create_Data_Capture_Lov(order_no_                   => order_no_,
                                                             line_no_                    => line_no_,
                                                             release_no_                 => release_no_,
                                                             line_item_no_               => line_item_no_,
                                                             part_no_                    => part_no_,
                                                             contract_                   => contract_,
                                                             configuration_id_           => configuration_id_,
                                                             location_no_                => location_no_,
                                                             lot_batch_no_               => lot_batch_no_,
                                                             serial_no_                  => serial_no_,
                                                             waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                             eng_chg_level_              => eng_chg_level_,
                                                             activity_seq_               => activity_seq_,
                                                             handling_unit_id_           => handling_unit_id_,
                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                             capture_session_id_         => capture_session_id_,
                                                             column_name_                => data_item_id_,
                                                             lov_type_db_                => lov_type_db_);           
         END IF;  
      ELSIF (data_item_id_ IN ('INPUT_UOM')) THEN              
         input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
         Input_Unit_Meas_API.Create_Data_Capture_Lov(capture_session_id_, input_uom_group_id_, 'UNIT_CODE', lov_type_db_, Get_Input_Uom_Sql_Whr_Exprs___); 
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
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MATRREQUISLINEOK: The Material Requisition Line Issue was performed.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MATRREQUISLINES: The Issue was performed on :P1 Material Requisition Lines.',NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                      VARCHAR2(5);
   order_no_                      VARCHAR2(12);
   line_no_                       VARCHAR2(4);
   release_no_                    VARCHAR2(4);
   line_item_no_                  NUMBER;
   part_no_                       VARCHAR2(25);
   location_no_                   VARCHAR2(35);
   serial_no_                     VARCHAR2(50);
   lot_batch_no_                  VARCHAR2(20);
   waiv_dev_rej_no_               VARCHAR2(15);
   eng_chg_level_                 VARCHAR2(6);
   configuration_id_              VARCHAR2(50);
   activity_seq_                  NUMBER;
   session_rec_                   Data_Capture_Common_Util_API.Session_Rec;
   barcode_id_                    NUMBER;
   automatic_value_               VARCHAR2(200);
   use_reservat_as_data_source_   BOOLEAN;
   issue_unreserved_enabled_      VARCHAR2(5);
   part_catalog_rec_              Part_Catalog_API.Public_Rec;
   qty_left_                      NUMBER;
   qty_reserved_unique_           NUMBER;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   gtin_no_                      VARCHAR2(14);
   input_uom_                    VARCHAR2(30);
   input_uom_group_id_           VARCHAR2(30);
   input_qty_                    NUMBER;
   input_conv_factor_            NUMBER;
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

         issue_unreserved_enabled_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ISSUE_UNRESERVED_MATERIAL');
         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                               eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                               issue_unreserved_enabled_, capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                               eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                               issue_unreserved_enabled_, capture_session_id_, data_item_id_);
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
   
         ELSIF (data_item_id_ IN ('ORDER_NO', 'LINE_NO', 'RELEASE_NO', 'LINE_ITEM_NO', 'PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 
                                  'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'QTY_TO_ISSUE',
                                  'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
            
            IF (use_reservat_as_data_source_) THEN
               -- ISSUE_UNRESERVED_MATERIAL is not enabled or its enabled and there exists reservations
               IF (data_item_id_= 'QTY_TO_ISSUE') THEN
                  IF Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE THEN  
                     automatic_value_ := 1;
                  ELSE
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
                     ELSE                                                    
                        automatic_value_ := Material_Requis_Reservat_API.Get_Qty_Assigned_If_Unique(order_class_db_   => 'INT',
                                                                                                    order_no_         => order_no_,
                                                                                                    line_no_          => line_no_,
                                                                                                    release_no_       => release_no_,
                                                                                                    line_item_no_     => line_item_no_,
                                                                                                    part_no_          => part_no_,
                                                                                                    contract_         => contract_,
                                                                                                    configuration_id_ => configuration_id_,
                                                                                                    location_no_      => location_no_,
                                                                                                    lot_batch_no_     => lot_batch_no_,
                                                                                                    serial_no_        => serial_no_,
                                                                                                    waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                                    eng_chg_level_    => eng_chg_level_,
                                                                                                    activity_seq_     => activity_seq_,
                                                                                                    handling_unit_id_ => handling_unit_id_); 
                     END IF;
                  END IF;  
               ELSE
                  automatic_value_ :=  Material_Requis_Reservat_API.Get_Column_Value_If_Unique(order_no_                   => order_no_, 
                                                                                               line_no_                    => line_no_,
                                                                                               release_no_                 => release_no_,
                                                                                               line_item_no_               => line_item_no_,
                                                                                               part_no_                    => part_no_,
                                                                                               contract_                   => contract_,
                                                                                               configuration_id_           => configuration_id_,
                                                                                               location_no_                => location_no_,
                                                                                               lot_batch_no_               => lot_batch_no_,
                                                                                               serial_no_                  => serial_no_,
                                                                                               waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                               eng_chg_level_              => eng_chg_level_,
                                                                                               activity_seq_               => activity_seq_,
                                                                                               handling_unit_id_           => handling_unit_id_,
                                                                                               alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                               column_name_                => data_item_id_);
               END IF;
            ELSE -- ISSUE_UNRESERVED_MATERIAL is enabled, but we cannot identity specific MRL yet or no reservations exist
               IF (data_item_id_= 'QTY_TO_ISSUE') THEN
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
                  ELSE
                     qty_left_ := Material_Requis_Line_API.Get_Qty_Due(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_) -
                                  Material_Requis_Line_API.Get_Qty_Shipped(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_) -
                                  Material_Requis_Line_API.Get_Qty_Assigned(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_);
   
                     qty_reserved_unique_ := Material_Requis_Reservat_API.Get_Qty_Assigned_If_Unique(order_class_db_   => 'INT',
                                                                                                     order_no_         => order_no_,
                                                                                                     line_no_          => line_no_,
                                                                                                     release_no_       => release_no_,
                                                                                                     line_item_no_     => line_item_no_,
                                                                                                     part_no_          => part_no_,
                                                                                                     contract_         => contract_,
                                                                                                     configuration_id_ => configuration_id_,
                                                                                                     location_no_      => location_no_,
                                                                                                     lot_batch_no_     => lot_batch_no_,
                                                                                                     serial_no_        => serial_no_,
                                                                                                     waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                                     eng_chg_level_    => eng_chg_level_,
                                                                                                     activity_seq_     => activity_seq_,
                                                                                                     handling_unit_id_ => handling_unit_id_); 
                     qty_reserved_unique_ := NVL(qty_reserved_unique_, 0);
                                
                     IF (qty_left_ + qty_reserved_unique_) = 0 THEN
                        automatic_value_ := 0;
                     ELSIF Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE THEN
                        automatic_value_ := 1;
                     ELSE
                        automatic_value_ := qty_left_ + NVL(qty_reserved_unique_, 0);
                     END IF;
                  END IF;
               ELSE
                  automatic_value_ := Material_Requis_Line_API.Get_Column_Value_If_Unique(order_no_                   => order_no_,
                                                                                          line_no_                    => line_no_,
                                                                                          release_no_                 => release_no_,
                                                                                          line_item_no_               => line_item_no_,
                                                                                          part_no_                    => part_no_,
                                                                                          contract_                   => contract_,
                                                                                          configuration_id_           => configuration_id_,
                                                                                          location_no_                => location_no_,
                                                                                          lot_batch_no_               => lot_batch_no_,
                                                                                          serial_no_                  => serial_no_,
                                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                          eng_chg_level_              => eng_chg_level_,
                                                                                          activity_seq_               => activity_seq_,
                                                                                          handling_unit_id_           => handling_unit_id_,
                                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                          column_name_                => data_item_id_);
               END IF;
            END IF;
            IF data_item_id_ = 'SERIAL_NO' AND Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND automatic_value_ = '*' THEN
               automatic_value_ := NULL;
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
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_        Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                    VARCHAR2(5);
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   release_no_                  VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   activity_seq_                NUMBER;
   issue_unreserved_enabled_    VARCHAR2(5);
   use_reservat_as_data_source_ BOOLEAN;
   barcode_id_                  NUMBER;
   handling_unit_id_            NUMBER; 
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   gtin_no_                     VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_              := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      issue_unreserved_enabled_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ISSUE_UNRESERVED_MATERIAL');
      Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                         eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                         issue_unreserved_enabled_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('ORDER_NO', 'LINE_NO', 'RELEASE_NO', 'LINE_ITEM_NO', 'PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 
                                                                    'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'BARCODE_ID',
                                                                    'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN

                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           order_no_                   => order_no_,
                                           line_no_                    => line_no_,
                                           release_no_                 => release_no_,
                                           line_item_no_               => line_item_no_,
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
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID', 'RECEIPTS_BLOCKED',
                                                                    'MIX_OF_PART_NUMBER_BLOCKED', 'MIX_OF_CONDITION_CODES_BLOCKED',
                                                                    'MIX_OF_LOT_BATCH_NO_BLOCKED', 'LOCATION_GROUP', 'LOCATION_TYPE', 'LOCATION_NO_DESC')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 
                                                                       'NET_WEIGHT', 'NET_VOLUME', 'PART_TYPE', 'PRIME_COMMODITY', 
                                                                       'PRIME_COMMODITY_DESCRIPTION', 'SECOND_COMMODITY', 'SECOND_COMMODITY_DESCRIPTION', 
                                                                       'ASSET_CLASS', 'ASSET_CLASS_DESCRIPTION', 'PART_STATUS', 'PART_STATUS_DESCRIPTION', 
                                                                       'ABC_CLASS', 'ABC_CLASS_PERCENT', 'SAFETY_CODE', 'SAFETY_CODE_DESCRIPTION', 
                                                                       'ACCOUNTING_GROUP', 'ACCOUNTING_GROUP_DESCRIPTION', 'PRODUCT_CODE', 'PRODUCT_CODE_DESCRIPTION', 
                                                                       'PRODUCT_FAMILY', 'PRODUCT_FAMILY_DESCRIPTION', 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                                                       'SERIAL_TRACKING_INVENTORY', 'SERIAL_TRACKING_DELIVERY', 'STOP_ARRIVAL_ISSUED_SERIAL', 
                                                                       'STOP_NEW_SERIAL_IN_RMA', 'SERIAL_RULE', 'LOT_BATCH_TRACKING', 'LOT_QUANTITY_RULE', 'SUB_LOT_RULE',
                                                                       'COMPONENT_LOT_RULE', 'GTIN_IDENTIFICATION', 'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                       owning_data_item_id_  => latest_data_item_id_,
                                                                       data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       contract_             => contract_,
                                                                       part_no_              => part_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY_ONHAND', 'CATCH_QUANTITY_ONHAND', 'OWNERSHIP', 'OWNER', 
                                                                       'EXPIRATION_DATE', 'AVAILABILTY_CONTROL_ID')) THEN

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

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TOTAL_VALUE', 'INT_CUSTOMER_NO', 'INT_CUSTOMER_NAME', 'DESTINATION_ID',
                                                                       'INTERNAL_DESTINATION', 'QTY_DUE', 'QTY_ASSIGNED', 'QTY_SHIPPED', 
                                                                       'QTY_ON_ORDER', 'QTY_RETURNED', 'CONDITION_CODE', 'CONDITION_CODE_DESCRIPTION',
                                                                       'PLANNED_DELIVERY_DATE', 'DUE_DATE', 'SUPPLY_CODE', 'HEAD_STATUS_CODE', 
                                                                       'LINE_STATUS_CODE', 'UNIT_MEAS', 'UNIT_MEAS_DESCRIPTION')) THEN

                  Add_Details_For_Matr_Req___(capture_session_id_  => capture_session_id_,
                                              owning_data_item_id_ => latest_data_item_id_,
                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                              order_no_            => order_no_,
                                              line_no_             => line_no_,
                                              release_no_          => release_no_,
                                              line_item_no_        => line_item_no_);

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
   capture_session_id_ IN     NUMBER,
   contract_           IN     VARCHAR2,
   attr_               IN     VARCHAR2,
   blob_ref_attr_      IN     VARCHAR2 )
IS
   session_rec_               Data_Capture_Common_Util_API.Session_Rec;
   ptr_                       NUMBER;
   name_                      VARCHAR2(50);
   value_                     VARCHAR2(4000);
   dummy_info_                VARCHAR2(4000);
   order_no_                  VARCHAR2(12);
   line_no_                   VARCHAR2(4);
   release_no_                VARCHAR2(4);
   line_item_no_              NUMBER;
   part_no_                   VARCHAR2(25);
   location_no_               VARCHAR2(35);
   serial_no_                 VARCHAR2(50);
   configuration_id_          VARCHAR2(50);
   lot_batch_no_              VARCHAR2(20);
   eng_chg_level_             VARCHAR2(6);
   waiv_dev_rej_no_           VARCHAR2(15);
   activity_seq_              NUMBER;
   qty_reserved_              NUMBER;
   qty_to_reserve_            NUMBER := 0;
   qty_to_issue_              NUMBER;
   qty_left_                  NUMBER;
   qty_reserved_unique_       NUMBER;
   catch_qty_to_issue_        NUMBER;
   issue_unreserved_enabled_  VARCHAR2(5);
   receipt_issue_serial_      PART_CATALOG_TAB.receipt_issue_serial_track%TYPE;
   serial_tracking_           PART_CATALOG_TAB.serial_tracking_code%TYPE;
   reservation_exist_         BOOLEAN := FALSE;
   error_no_reservation_      BOOLEAN := FALSE;
   session_id_                NUMBER;
   default_serial_            VARCHAR2(5):= '*';
   handling_unit_id_          NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         order_no_ := value_;
      ELSIF (name_ = 'LINE_NO') THEN
         line_no_ := value_;
      ELSIF (name_ = 'RELEASE_NO') THEN
         release_no_ := value_;
      ELSIF (name_ = 'LINE_ITEM_NO') THEN
         line_item_no_ := value_;
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
      ELSIF (name_ = 'QTY_TO_ISSUE') THEN
         qty_to_issue_ := value_;
      ELSIF (name_ = 'CATCH_QTY_TO_ISSUE') THEN
         catch_qty_to_issue_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_;
      END IF;
   END LOOP;

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_              := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      issue_unreserved_enabled_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ISSUE_UNRESERVED_MATERIAL');
   $END

   qty_reserved_ := Material_Requis_Line_API.Get_Qty_Assigned(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_);
   qty_left_     := Material_Requis_Line_API.Get_Qty_Due(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_) -
                    Material_Requis_Line_API.Get_Qty_Shipped(Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT), order_no_, line_no_, release_no_, line_item_no_) - qty_reserved_;
   
   IF (Inventory_Part_In_Stock_API.Check_Individual_Exist(part_no_, serial_no_) = 0) THEN
      default_serial_ := '*';
   ELSE
      default_serial_ := NULL;
   END IF;
   
   qty_reserved_unique_ := Material_Requis_Reservat_API.Get_Qty_Assigned_If_Unique(order_class_db_   => Material_Requis_Type_API.DB_INT,
                                                                                   order_no_         => order_no_,
                                                                                   line_no_          => line_no_,
                                                                                   release_no_       => release_no_,
                                                                                   line_item_no_     => line_item_no_,
                                                                                   part_no_          => part_no_,
                                                                                   contract_         => contract_,
                                                                                   configuration_id_ => configuration_id_,
                                                                                   location_no_      => location_no_,
                                                                                   lot_batch_no_     => lot_batch_no_,
                                                                                   serial_no_        => NVL(default_serial_, serial_no_),
                                                                                   waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                   eng_chg_level_    => eng_chg_level_,
                                                                                   activity_seq_     => activity_seq_,
                                                                                   handling_unit_id_ => handling_unit_id_); 

   qty_reserved_unique_  := NVL(qty_reserved_unique_, 0);
   default_serial_       := '*';
   receipt_issue_serial_ := Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_);
   serial_tracking_      := Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_);

   IF receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE THEN
      IF (qty_to_issue_ NOT IN (0,1)) THEN
         Error_SYS.Record_General(lu_name_,'SERIALPARTQTYWRONG: A serial handled Part can only have Quantity value of 1 or 0.');
      END IF;
      IF serial_tracking_ = Part_Serial_Tracking_API.DB_SERIAL_TRACKING THEN
         reservation_exist_ := Material_Requis_Reservat_API.Check_Exist(order_class_db_   => Material_Requis_Type_API.DB_INT,
                                                                        order_no_         => order_no_,
                                                                        line_no_          => line_no_,
                                                                        release_no_       => release_no_,
                                                                        line_item_no_     => line_item_no_,
                                                                        part_no_          => part_no_,
                                                                        contract_         => contract_,
                                                                        configuration_id_ => configuration_id_,
                                                                        location_no_      => location_no_,
                                                                        lot_batch_no_     => lot_batch_no_,
                                                                        serial_no_        => serial_no_,
                                                                        waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                        eng_chg_level_    => eng_chg_level_,
                                                                        activity_seq_     => activity_seq_,
                                                                        handling_unit_id_ => handling_unit_id_); 
         IF reservation_exist_ = FALSE THEN 
            IF issue_unreserved_enabled_ = Fnd_Boolean_API.DB_FALSE  THEN
               error_no_reservation_ := TRUE;
            ELSE
               qty_to_reserve_ := qty_to_issue_;
            END IF;            
         END IF;
         default_serial_ := NULL;
      ELSE
         IF (issue_unreserved_enabled_ = Fnd_Boolean_API.DB_FALSE) AND  (qty_reserved_unique_ = 0) THEN
            error_no_reservation_ := TRUE;
         ELSE
            qty_to_reserve_ :=  qty_to_issue_ - qty_reserved_unique_;         
         END IF;
         default_serial_ := '*';
      END IF;
   ELSE
      IF (issue_unreserved_enabled_ = Fnd_Boolean_API.DB_FALSE AND (qty_to_issue_ > qty_reserved_)) THEN
         error_no_reservation_ := TRUE;
      ELSIF (issue_unreserved_enabled_ = Fnd_Boolean_API.DB_TRUE) THEN
         -- Quantity to issue is validated against Quantity left to reserve + already reserved quantity.
         IF (qty_to_issue_ > qty_reserved_unique_) THEN
            qty_to_reserve_ := qty_to_issue_ - qty_reserved_unique_;
         END IF;
      END IF;
   END IF;

   IF error_no_reservation_ THEN
      Error_SYS.Record_General(lu_name_, 'ISSUEMORETHENRESERVE: Quantity to be issued is not allowed to be larger than the quantity reserved when Issue Unreserved Material Requisition Line is not allowed.');
   ELSE
      -- Check if can issue the given quantity from the given location.
      IF qty_to_issue_ > (qty_left_ + qty_reserved_unique_) THEN
         Error_SYS.Record_General(lu_name_, 'ISSUEMOREQTYLEFTLOC: You cannot issue a quantity greater than :P2, which is the quantity left at location :P1.', location_no_, Data_Capture_Common_Util_API.Get_Leading_Zero_For_Decimals(qty_left_ + qty_reserved_unique_));
      END IF;
   END IF;
   
   IF (qty_to_reserve_ > 0) THEN
      Material_Requis_Reservat_API.Make_Part_Reservations(order_class_      => Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT),
                                                          order_no_         => order_no_,
                                                          line_no_          => line_no_,
                                                          release_no_       => release_no_, 
                                                          line_item_no_     => line_item_no_,
                                                          part_no_          => part_no_,
                                                          contract_         => contract_,
                                                          location_no_      => location_no_,
                                                          lot_batch_no_     => lot_batch_no_,
                                                          serial_no_        => NVL(default_serial_, serial_no_),
                                                          waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                          eng_chg_level_    => eng_chg_level_,
                                                          activity_seq_     => activity_seq_,
                                                          handling_unit_id_ => handling_unit_id_, 
                                                          qty_reserve_      => qty_to_reserve_);
   END IF;

   IF receipt_issue_serial_ = Fnd_Boolean_API.DB_TRUE AND  serial_tracking_ = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING THEN
      session_id_ := Temporary_Part_Tracking_API.Get_Next_Session_Id;
      Temporary_Part_Tracking_API.New(session_id_, serial_no_, NULL, contract_, part_no_, NULL);
   END IF;
   
   Material_Requis_Reservat_API.Make_Item_Delivery(order_class_              => Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT),
                                                   order_no_                 => order_no_,
                                                   line_no_                  => line_no_,
                                                   release_no_               => release_no_, 
                                                   line_item_no_             => line_item_no_,
                                                   part_no_                  => part_no_,
                                                   contract_                 => contract_,
                                                   location_no_              => location_no_,
                                                   lot_batch_no_             => lot_batch_no_,
                                                   serial_no_                => serial_no_,
                                                   waiv_dev_rej_no_          => waiv_dev_rej_no_,
                                                   eng_chg_level_            => eng_chg_level_,
                                                   activity_seq_             => activity_seq_,
                                                   handling_unit_id_         => handling_unit_id_, 
                                                   qty_to_ship_              => qty_to_issue_,
                                                   catch_qty_to_ship_        => catch_qty_to_issue_,
                                                   info_                     => dummy_info_,
                                                   part_tracking_session_id_ => session_id_);
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Material_Requis_Reservat_API.Make_Part_Reservations is granted thru following projections/actions
   -- Check to see that API method Material_Requis_Reservat_API.Make_Item_Delivery is granted thru following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('CreateMaterialReq', 'MakePartResIssue') OR
       Security_SYS.Is_Proj_Action_Available('MaterialRequisitionHandling', 'ReserveMaterials') OR
       Security_SYS.Is_Proj_Action_Available('MaterialRequisitionLinesHandling', 'ReserveMaterials') OR
       Security_SYS.Is_Proj_Action_Available('MaterialRequisitionHandling', 'IssueMaterial') OR
       Security_SYS.Is_Proj_Action_Available('MaterialRequisitionLinesHandling', 'IssueMaterial')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;


@UncheckedAccess
FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   contract_                    VARCHAR2(5);
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   release_no_                  VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   activity_seq_                NUMBER;
   barcode_id_                  NUMBER;
   use_reservat_as_data_source_ BOOLEAN;
   issue_unreserved_enabled_    VARCHAR2(5);
   handling_unit_id_            NUMBER;
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   gtin_no_                     VARCHAR2(14);
   temp_data_item_id_           VARCHAR2(50);
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
      -- if predicted part_no_ is null then try fetch it with unique handling
      IF (part_no_ IS NULL) THEN
         issue_unreserved_enabled_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'ISSUE_UNRESERVED_MATERIAL');
         Get_Filter_Keys___(order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, 
                            eng_chg_level_, activity_seq_, use_reservat_as_data_source_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                            issue_unreserved_enabled_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);
         part_no_ := Get_Unique_Data_Item_Value___(order_no_,line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_,  waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, issue_unreserved_enabled_, barcode_id_, 'PART_NO');
      END IF;
      IF (data_item_id_ = 'QTY_TO_ISSUE') THEN 
         temp_data_item_id_ := 'QUANTITY';
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
         END IF;
      ELSE 
         temp_data_item_id_ := data_item_id_;
      END IF; 
   $END
   
   RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, temp_data_item_id_, part_no_, serial_no_);
END Fixed_Value_Is_Applicable;
   
