-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptRecFromTransit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: RECEIVE_INV_PART_FROM_TRANSIT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200826  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available/Is_Proj_Entity_Act_Available in Is_Process_Available to support new projection security concept.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  181019  BudKlk  Bug 143097, Modified the method Add_Details_For_Latest_Item to add a new feedback item CONDITION_CODE.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171030  DaZase  STRSC-13049, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171030          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  171002  SWiclk  STRSC-11283, Implemented GTIN support, hence handled GTIN, INPUT_UOM and INPUT_QUANTITY data items and INPUT_CONV_FACTOR as feedback item 
--  171002          and GTIN_IS_MANDATORY as detail item. Added Get_Input_Uom_Sql_Whr_Exprs___() and added GTIN to Get_Filter_Keys___().
--  170418  DaZase  LIM-10662, Changes in Get_Filter_Keys___ on how Bug 132004 was solved, now we check if inventory barcode is enabled correctly. 
--  170302  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170113  DaZase  LIM-8660, Added a catch quantity validation in Validate_Data_Item.  
--  161108  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161010  SWiclk  Bug 132004, Modified Get_Filter_Keys___() and Validate_Data_Item() in order to check whether  
--  161010          Barcode Id is mandatory or not before trying to fetch a unique value.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  151201  KhVese  LIM-2917, Modified Execute_Process() to call public method Receive_Part_From_Transit instead of private method Receive_Part_From_Transit__.
--  151016  JeLise  LIM-3893, Removed location_type 'DELIVERY' from Get_Sql_Where_Expression___.
--  150803  SWiclk  Bug 121254, Modified Get_Unique_Data_Item_Value___(), Validate_Data_Item() and Create_List_Of_Values() by changing the parameter list 
--  150803          of methods which are from Inventory_Part_Barcode_API since the contract has been changed as a parentkey.
--  150617  DaZase  COB-475, Interface change to calls to Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique.
--  150402  DaZase  Added method Get_Sql_Where_Expression___ and added usage of this 
--  150402          method before calls to unique methods in Inventory_Part_In_Stock_API.
--  150413  Chfose  LIM-978, Fixed calls to Inventory_Part_In_Stock_API by including handling_unit_id where applicable.
--  141125  DaZase  Some refactoring in some methods.
--  140710  ChBnlk  Bug 117727, Created. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   wanted_data_item_id_        IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   dummy_                 BOOLEAN;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (wanted_data_item_id_ = 'BARCODE_ID' OR (barcode_id_ IS NOT NULL AND  
          wanted_data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ'))) THEN
         unique_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(barcode_id_       => barcode_id_,
                                                                                contract_         => contract_,
                                                                                part_no_          => part_no_,
                                                                                configuration_id_ => configuration_id_,
                                                                                lot_batch_no_     => lot_batch_no_,
                                                                                serial_no_        => serial_no_,
                                                                                eng_chg_level_    => eng_chg_level_,
                                                                                waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                activity_seq_     => activity_seq_,
                                                                                column_name_      => wanted_data_item_id_);
      ELSE
         unique_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                 contract_                   => contract_,
                                                                                 part_no_                    => part_no_,
                                                                                 configuration_id_           => configuration_id_,
                                                                                 location_no_                => location_no_,
                                                                                 lot_batch_no_               => lot_batch_no_,
                                                                                 serial_no_                  => serial_no_,
                                                                                 eng_chg_level_              => eng_chg_level_,
                                                                                 waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                 activity_seq_               => activity_seq_,
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
   
PROCEDURE Get_Filter_Keys___ (
   contract_                   OUT VARCHAR2,
   part_no_                    OUT VARCHAR2,
   location_no_                OUT VARCHAR2,
   configuration_id_           OUT VARCHAR2,
   lot_batch_no_               OUT VARCHAR2,
   serial_no_                  OUT VARCHAR2,
   eng_chg_level_              OUT VARCHAR2,
   waiv_dev_rej_no_            OUT VARCHAR2,
   activity_seq_               OUT NUMBER,
   barcode_id_                 OUT NUMBER,
   handling_unit_id_           OUT NUMBER,
   sscc_                       OUT VARCHAR2,     -- not used for filtering in unique handling
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
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_        := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      part_no_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      configuration_id_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_                  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      activity_seq_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
      location_no_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      handling_unit_id_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      sscc_                       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SSCC', session_rec_ , process_package_, use_applicable_);
      alt_handling_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      gtin_no_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);
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
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ACTIVITY_SEQ');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'LOCATION_NO');
         END IF;
         IF (handling_unit_id_ IS NULL) THEN
            handling_unit_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'HANDLING_UNIT_ID');
         END IF;
         IF (alt_handling_unit_label_id_ IS NULL) THEN
            alt_handling_unit_label_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'ALT_HANDLING_UNIT_LABEL_ID');
         END IF;
         IF (barcode_id_ IS NULL AND Data_Capture_Invent_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'BARCODE_ID');
         END IF;
         -- SSCC not included in the unique fetch.
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
   configuration_id_           IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
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


-- Method sets extra where expression for used in calls to InventoryPartInStock "Unique" methods
FUNCTION Get_Sql_Where_Expression___ RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(2000);
BEGIN
   sql_where_expression_  := ' AND freeze_flag_db = ''N''
                               AND qty_in_transit > 0
                               AND location_type_db IN (''PICKING'',''F'',''MANUFACTURING'') ';
   RETURN sql_where_expression_;
END Get_Sql_Where_Expression___;

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
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2, 
   data_item_value_     IN VARCHAR2 )       
IS
   contract_                   VARCHAR2(5);   
   part_no_                    VARCHAR2(25);
   location_no_                VARCHAR2(35);   
   serial_no_                  VARCHAR2(50);
   configuration_id_           VARCHAR2(50);
   lot_batch_no_               VARCHAR2(20);
   eng_chg_level_              VARCHAR2(6);
   waiv_dev_rej_no_            VARCHAR2(15);
   activity_seq_               NUMBER;   
   qty_in_transit_             NUMBER;
   data_item_description_      VARCHAR2(200);
   barcode_id_                 NUMBER;
   dummy_                      BOOLEAN;
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   column_value_nullable_      BOOLEAN := FALSE;
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   process_package_            VARCHAR2(30);
   catch_quantity_             NUMBER;
   input_unit_meas_group_id_   VARCHAR2(30);
   gtin_no_                    VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN      
      IF (data_item_id_ IN ('WAIV_DEV_REJ_NO')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, FALSE);
      END IF;
      IF (data_item_id_ NOT IN ('WAIV_DEV_REJ_NO')) THEN
         Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                         data_item_id_,
                                                         data_item_value_);
      END IF;

      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- Note: No need to get values for process keys when barcode_id is null because probably it would not be used in this process.
         IF (data_item_value_ IS NOT NULL) THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, 
                               data_item_id_, data_item_value_, use_unique_values_ => TRUE);
         END IF;                      
      ELSE
         Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_,  
                            waiv_dev_rej_no_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, 
                            data_item_id_, data_item_value_);
      END IF;


      IF (data_item_id_ IN ('PART_NO','CATCH_QUANTITY')) THEN
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
         catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QUANTITY', session_rec_ , process_package_);
         Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                      current_data_item_id_      => data_item_id_,
                                                      part_no_data_item_id_      => 'PART_NO',
                                                      part_no_data_item_value_   => part_no_,
                                                      catch_qty_data_item_id_    => 'CATCH_QUANTITY',
                                                      catch_qty_data_item_value_ => catch_quantity_,
                                                      positive_catch_qty_        => TRUE);  -- Since this process dont allow normal quantity to be zero or lower it shouldnt allow it for catch quantity either
      END IF;

      data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);   
      
      IF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN         
         IF (data_item_id_ IN ('SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
            column_value_nullable_ := TRUE;
         ELSIF (data_item_id_ = 'HANDLING_UNIT_ID' AND data_item_value_ > 0) THEN
            Handling_Unit_API.Exist(data_item_value_);
         END IF;
         Inventory_Part_In_Stock_API.Record_With_Column_Value_Exist(contract_                   => contract_,
                                                                    part_no_                    => part_no_,
                                                                    configuration_id_           => configuration_id_,
                                                                    location_no_                => location_no_,
                                                                    lot_batch_no_               => lot_batch_no_,
                                                                    serial_no_                  => serial_no_,
                                                                    eng_chg_level_              => eng_chg_level_,
                                                                    waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                    activity_seq_               => activity_seq_,
                                                                    handling_unit_id_           => handling_unit_id_,
                                                                    alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                    column_name_                => data_item_id_,
                                                                    column_value_               => data_item_value_,
                                                                    column_description_         => data_item_description_,
                                                                    sql_where_expression_       => Get_Sql_Where_Expression___,
                                                                    column_value_nullable_      => column_value_nullable_);
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
         END IF;
      ELSIF (data_item_id_ = 'QUANTITY') THEN
         IF (data_item_value_ <= 0) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDQUANTITY: The quantity to be received must be greater than zero.');
         END IF; 
         qty_in_transit_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                   contract_                   => contract_,
                                                                                   part_no_                    => part_no_,
                                                                                   configuration_id_           => configuration_id_,
                                                                                   location_no_                => location_no_,
                                                                                   lot_batch_no_               => lot_batch_no_,
                                                                                   serial_no_                  => serial_no_,
                                                                                   eng_chg_level_              => eng_chg_level_,
                                                                                   waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                   activity_seq_               => activity_seq_,
                                                                                   handling_unit_id_           => handling_unit_id_,
                                                                                   alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                   column_name_                => 'QTY_IN_TRANSIT',
                                                                                   sql_where_expression_       => Get_Sql_Where_Expression___);          
         IF (data_item_value_ > qty_in_transit_) THEN
            Error_SYS.Record_General(lu_name_, 'QTYTRANSLESS: The quantity to be received may not be greater than the quantity in-transit.');
         END IF;
      ELSIF (data_item_id_ IN ('INPUT_QUANTITY')) THEN
         IF (data_item_value_ <= 0) THEN
            Error_SYS.Record_General(lu_name_, 'NEGATIVEORZEROQTY: Zero or Negative Quantity is not allowed.');
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
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
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
   input_uom_group_id_         VARCHAR2(30);
   gtin_no_                    VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'BARCODE_ID') THEN
         -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
         Get_Filter_Keys___(dummy_contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                            waiv_dev_rej_no_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_,
                            data_item_value_ => NULL, use_unique_values_ => TRUE);
      ELSE
         Get_Filter_Keys___(dummy_contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                            waiv_dev_rej_no_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_);
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
   
   
      ELSIF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ',
                               'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
         Inventory_Part_In_Stock_API.Create_Data_Capture_Lov(contract_                   => contract_,
                                                             part_no_                    => part_no_,
                                                             configuration_id_           => configuration_id_,
                                                             location_no_                => location_no_,
                                                             lot_batch_no_               => lot_batch_no_,
                                                             serial_no_                  => serial_no_,
                                                             eng_chg_level_              => eng_chg_level_,
                                                             waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                             activity_seq_               => activity_seq_,
                                                             handling_unit_id_           => handling_unit_id_,
                                                             alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                             capture_session_id_         => capture_session_id_,
                                                             column_name_                => data_item_id_,
                                                             lov_type_db_                => lov_type_db_,
                                                             sql_where_expression_       => Get_Sql_Where_Expression___);

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
   message_               VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ :=  Language_SYS.Translate_Constant(lu_name_, 'RECIEVEOK: The stock has been successfully received.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RECIEVESOK: :P1 stocks have been successfully received.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
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
   dummy_                      BOOLEAN;
   gtin_no_                    VARCHAR2(14);
   input_uom_                  VARCHAR2(30);
   input_uom_group_id_         VARCHAR2(30);
   input_qty_                  NUMBER;
   input_conv_factor_          NUMBER;
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

         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_,
                               data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_);
         END IF;
   
         IF (data_item_id_ = 'BARCODE_ID') THEN
            automatic_value_ := barcode_id_;
         ELSIF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 
                                  'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
   
            IF (barcode_id_ IS NOT NULL AND  
                data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ')) THEN
               automatic_value_ := Inventory_Part_Barcode_API.Get_Column_Value_If_Unique(barcode_id_       => barcode_id_,
                                                                                         contract_         => contract_,
                                                                                         part_no_          => part_no_,
                                                                                         configuration_id_ => configuration_id_,
                                                                                         lot_batch_no_     => lot_batch_no_,
                                                                                         serial_no_        => serial_no_,
                                                                                         eng_chg_level_    => eng_chg_level_,
                                                                                         waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                         activity_seq_     => activity_seq_,
                                                                                         column_name_      => data_item_id_);
            ELSE
               automatic_value_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
                                                                                          contract_                   => contract_,
                                                                                          part_no_                    => part_no_,
                                                                                          configuration_id_           => configuration_id_,
                                                                                          location_no_                => location_no_,
                                                                                          lot_batch_no_               => lot_batch_no_,
                                                                                          serial_no_                  => serial_no_,
                                                                                          eng_chg_level_              => eng_chg_level_,
                                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                          activity_seq_               => activity_seq_,
                                                                                          handling_unit_id_           => handling_unit_id_,
                                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                          column_name_                => data_item_id_,
                                                                                          sql_where_expression_       => Get_Sql_Where_Expression___);
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
         ELSIF (data_item_id_ = 'QUANTITY') THEN
            automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, session_rec_.session_contract, part_no_);         
            IF (automatic_value_ IS NULL) THEN                         
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
               END IF; 
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


@UncheckedAccess
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   contract_                   VARCHAR2(5);
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
   gtin_no_                    VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- fetch all necessary keys for all possible detail items below
      session_rec_          := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_,  
                         handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);
      
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
                                                                    'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN

                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;  -- % if it is not scanned yet
                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
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
                                                                    'LOCATION_NO_DESC')) THEN
                                                                 
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);
                     
               ELSIF(conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 
                                                                     'UNIT_MEAS_DESCRIPTION', 'NET_WEIGHT', 'NET_VOLUME', 'PART_TYPE', 'PRIME_COMMODITY', 
                                                                     'PRIME_COMMODITY_DESCRIPTION', 'SECOND_COMMODITY', 'SECOND_COMMODITY_DESCRIPTION', 
                                                                     'ASSET_CLASS', 'ASSET_CLASS_DESCRIPTION', 'PART_STATUS', 'PART_STATUS_DESCRIPTION', 
                                                                     'ABC_CLASS', 'ABC_CLASS_PERCENT', 'SAFETY_CODE', 'SAFETY_CODE_DESCRIPTION', 'ACCOUNTING_GROUP', 
                                                                     'ACCOUNTING_GROUP_DESCRIPTION', 'PRODUCT_CODE', 'PRODUCT_CODE_DESCRIPTION', 'PRODUCT_FAMILY', 
                                                                     'PRODUCT_FAMILY_DESCRIPTION', 'TYPE_DESIGNATION', 'DIMENSION_QUALITY', 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                                                     'SERIAL_TRACKING_INVENTORY', 'SERIAL_RULE', 'LOT_BATCH_TRACKING', 'LOT_QUANTITY_RULE', 
                                                                     'SUB_LOT_RULE', 'GTIN_IDENTIFICATION', 'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN
                                                                     
                  Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_   => capture_session_id_,
                                                                     owning_data_item_id_  => latest_data_item_id_,
                                                                     data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                     contract_             => contract_,
                                                                     part_no_              => part_no_);
                     
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY_ONHAND', 'CATCH_QUANTITY_ONHAND', 'AVAILABILITY_CONTROL_ID', 'AVAILABILITY_CONTROL_DESCRIPTION',
                                                                       'QUANTITY_IN_TRANSIT', 'CATCH_QUANTITY_IN_TRANSIT', 'EXPIRATION_DATE')) THEN
                                                                       
                  Data_Capture_Invent_Util_API.Add_Details_For_Inv_Stock_Rec(capture_session_id_  => capture_session_id_,
                                                                             owning_data_item_id_ => latest_data_item_id_,
                                                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                             contract_            => contract_,
                                                                             part_no_             => part_no_,
                                                                             configuration_id_    => configuration_id_,
                                                                             location_no_         => location_no_,
                                                                             lot_batch_no_        => lot_batch_no_,                                                                             serial_no_           => serial_no_,
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
               
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE', 'CONDITION_CODE_DESCRIPTION')) THEN

                  condition_code_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'CONDITION_CODE');                   
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
   ptr_                NUMBER;
   name_               VARCHAR2(50);
   value_              VARCHAR2(4000);
   location_no_        VARCHAR2(35);
   part_no_            VARCHAR2(25);
   quantity_           NUMBER;
   serial_no_          VARCHAR2(50) := '*';
   configuration_id_   VARCHAR2(50) := '*';
   lot_batch_no_       VARCHAR2(20) := '*';
   eng_chg_level_      VARCHAR2(6) := '1';
   waiv_dev_rej_no_    VARCHAR2(15) := '*';
   activity_seq_       NUMBER := 0;   
   catch_quantity_     NUMBER;   
   dummy_varchar_      VARCHAR2(2000);
   handling_unit_id_     NUMBER;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LOCATION_NO') THEN
         location_no_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'QUANTITY') THEN
         quantity_ := value_;
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
      ELSIF (name_ = 'CATCH_QUANTITY') THEN
         catch_quantity_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP; 
      
   Inventory_Part_In_Stock_API.Receive_Part_From_Transit(unattached_from_handling_unit_ => dummy_varchar_,
                                                         info_             => dummy_varchar_,
                                                         contract_         => contract_,
                                                         part_no_          => part_no_,
                                                         configuration_id_ => configuration_id_,
                                                         location_no_      => location_no_,
                                                         lot_batch_no_     => lot_batch_no_,
                                                         serial_no_        => serial_no_,
                                                         eng_chg_level_    => eng_chg_level_,
                                                         waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                         activity_seq_     => activity_seq_,
                                                         handling_unit_id_ => handling_unit_id_,
                                                         quantity_         => quantity_,
                                                         catch_quantity_   => catch_quantity_);
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Inventory_Part_In_Stock_API.Receive_Part_From_Transit is granted thru following projections/actions/entity actions
   IF (Security_SYS.Is_Proj_Entity_Act_Available('ReceiveFromTransit', 'InventoryPartInStock', 'ReceivePartFromTransitUpdate') OR      
       Security_SYS.Is_Proj_Action_Available('MroTechnicianTaskExecutionHandling', 'ReceiveQtyInTransit') OR
       Security_SYS.Is_Proj_Action_Available('TechPortalStockHandling', 'ReceiveQtyInTransit') OR
       Security_SYS.Is_Proj_Action_Available('TechPortalTaskExecution', 'ReceiveQtyInTransit')) THEN              
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
   gtin_no_                    VARCHAR2(14);

BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
      -- if predicted part_no_ is null then try fetch it with unique handling
      IF (part_no_ IS NULL) THEN
         Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, 
                            barcode_id_,  handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);
         part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
      END IF; 
      IF (serial_no_ IS NULL) AND (data_item_id_ = 'QUANTITY') THEN
         serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
      END IF; 
   $END

   RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, data_item_id_, part_no_, serial_no_);
END Fixed_Value_Is_Applicable;
   
