-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptureCountPart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: COUNT_PART
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201203  DaZase  Bug 156915 (SCZ-12788), Changed check for INPUT_QUANTITY in Validate_Data_Item to allow zero quantity like the message already says.
--  200811  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  200131  DaZase  SCXTEND-2723, Reverting Bug 138053 change in Get_Automatic_Data_Item_Value. If user wants to count new parts and they dont know the Revision they should turn off 
--  200131          Use Automamtic value and instead use the LOV to choose from all possible Revisions for that Part/Site. The original change in Get_Automatic_Data_Item_Value didnt work 
--  200131          when you had several different revisions for the same part/site and there was already existing records in Inventory Part In Stock.
--  190328  LaThlk  Bug 147190(SCZ-3308), Modified the procedure Execute_Process() to assign the rejected count to the process_message_ in order to identify the rejected count.
--  190328          Modified the function Get_Process_Execution_Message() to get the rejected count from the process_message_ and return the respective information message.
--  181010  BudKlk  Bug 144431, Modified the method Add_Details_For_Latest_Item to retrive value for condition_code_ in order to get CONDITION_CODE_DESCRIPTION.
--  180704  RuLiLk  Bug 142825, Modified method Get_Automatic_Data_Item_Value to fetch automatic value for QUANTITY from Inventory_Part_In_Stock. Qty_Onhand.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory.  
--  180111  BudKlk  Bug 139693, Modified the method Create_List_Of_Values() to add conditional compilation for the method call Part_Revision_API.Create_Data_Capture_Lov to avoid error 
--  180111          and also make sure to handle the correction as it worked before.
--  171129  CKumlk  STRSC-14828, Added GTIN to Add_Filter_Key_Detail___.
--  171102  ChFolk  STRSc-14017, Modified Validate_Data_Item to change the message constant EMPTYSSCCDONTMATCHHU as EMPTYSSCCDONTMATCHALTHU 
--  171102          for data item ALT_HANDLING_UNIT_LABEL_ID as EMPTYSSCCDONTMATCHHU is used for data item SSCC.
--  171101  CKumlk  STRSC-13711, Changed size of note_ to 2000 in Execute_Process.
--  171012  BudKlk  Bug 138053, Modidied the methods Create_List_Of_Values() and Get_Automatic_Data_Item_Value() to allow all the revision_nos to be display in the LOV and 
--  171012          show the latest revison as the defalut value when user configured. 
--  170912  SURBLK  STRSC-9613, Modified Get_Automatic_Data_Item_Value() in order to handle INPUT_UOM  and INPUT_QUANTITY when 
--  170921          inventory part has a value for Input UoM Group.
--  170906  DaZase  STRSC-11610, Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170821  SURBLK  STRSC-9613, Added Get_Input_Uom_Sql_Whr_Exprs___() and added GTIN to Get_Filter_Keys___().
--  170821  DaZase  STRSC-9603, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead of anything found later in that method. 
--  170712  SURBLK  STRSC-9613, Added INPUT_UOM and INPUT_QUANTITY data items and INPUT_CONV_FACTOR as feedback item and GTIN_IS_MANDATORY as detail item
--                  to support for the GTIN implementation.
--  170302  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170213  khvese  LIM-10447, Modified catch quantity validation in Validate_Data_Item to be handled on data items 'PART_NO','CATCH_QUANTITY' and 'QUANTITY'.  
--  170113  DaZase  LIM-8660, Added a catch quantity validation in Validate_Data_Item.  
--  161108  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161010  SWiclk  Bug 132004, Modified Get_Filter_Keys___() in order to check whether Barcode Id is mandatory or not before trying to fetch a unique value.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  151106  Erlise  LIM-4293, Added new feedback items connected to handling unit.
--  151019  MaEelk  LIM-3785, Removed pallet_id from the call to Counting_Result_API.New_Result
--  150807  DaZase  COB-607, Reworked some of the unique methods so data items that are not using the filter keys 
--  150807          are handled before calling Get_Filter_Keys___, to help performance a bit. 
--  150730  SWiclk  Bug 121254, Modified Get_Unique_Data_Item_Value___(), Validate_Data_Item() and Create_List_Of_Values() in order to pass contract and barcode_id in correct order  
--  150730          when calling Get_Column_Value_If_Unique(), Record_With_Column_Value_Exist() and Create_Data_Capture_Lov() of Inventory_Part_Barcode_API since contract is the parentkey.
--  150617  DaZase  COB-475, Interface change to calls to Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique.
--  150427  BudKlk  Bug 121577, Modified methods Execute_Process() by adding a new data item 'NOTE'.
--  150410  DaZase  Added method Get_Sql_Where_Expression___ and added usage of this 
--  150410          method before calls to unique methods in Inventory_Part_In_Stock_API.
--  150408  RILASE  COB-184, Changed validation for receipt and issue serial handled parts to only allow * and to allow any quantity.
--  150413  JeLise  Added handling_unit_id_ in calls to Inventory_Part_In_Stock_API.
--  150130  DaZase  PRSC-5577, Added fetch of default condition code in Get_Automatic_Data_Item_Value if unique methods failed to fetch a condition code for part that have that enabled.
--  150121  DaZase  PRSC-5289, Added extra validations for SERIAL_NO and LOT_BATCH_NO in Validate_Data_Item.
--  141113  DaZase  PRSC-4170, Added a quantity check for serial parts in Validate_Data_Item.
--  141106  DaZase  PRSC-4009, Changed Fixed_Value_Is_Applicable so it now fetches predicted and unique part_no.
--  141015  DaZase  PRSC-3322, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___ and Add_Details_For_Latest_Item. 
--  141015          Replaced Get_Data_Item_Value___ with new method Get_Unique_Data_Item_Value___. Replaced Add_Unique_Detail___ with new methods Add_Filter_Key_Detail___/Add_Unique_Data_Item_Detail___. 
--  141008  DaZase  PRSC-63, Changed Get_Automatic_Data_Item_Value, Create_List_Of_Values and Validate_Data_Item to now use methods in Inventory_Part_Barcode_API for BARCODE_ID.
--  140908  RiLase  Removed empty methods since the wadaco framework now can handle when methods doesn't exist.
--  140903  RiLase  Added framework method Fixed_Value_Is_Applicable.
--  140827  DaZase  PRSC-1655, Added Validate_Config_Data_Item.
--  140815  Dazase  PRSC-1611, Removed Apply_Additional_Line_Content since it is now obsolete and Get_Automatic_Data_Item_Value can be used instead. 
--  140812  DaZase  PRSC-1611, Renamed Add_Lines_For_Latest_Data_Item to Add_Details_For_Latest_Item.
--  140805  DaZase  PRSC-1431, Changed part_no_ to VARCHAR2(25) and location_no_ to VARCHAR2(35).
--  140620  SWiclk  PRSC-1867, Bug 117179, Modified Get_Process_Execution_Message() and Execute_Process() by adding parameter process_message_
--  140620          and parameters process_message_ and blob_ref_attr_ respectively.
--  140509  AwWelk  PBSC-9741, Added conditional compilation to dynamic references for DATA_CAPTURE_SESSION_API in methods Create_List_Of_Values()
--  140509          and Validate_Data_Item().
--  140320  SWiclk  Bug 115789, Modified Validate_Data_Item() and Execute_Process() in order to allow new serial no for counting.                                                                               
--  131220  DaZase  Bug 114022, Did some refactoring in this process to make it more like the other processes with more unique handling.
--  131220          Added all invpartinstock keys as parameters on Get_Data_Item_Value___ and added 
--  131220          Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique call in this method. Added method Add_Unique_Detail___ to 
--  131220          handle data items as details. Added call t Data_Capture_Invent_Util_API.Match_Barcode_Keys 
--  131220          for BARCODE_ID in Validate_Data_Item and added get_id_ parameter to calls to Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique.
--  131220          Change in Create_List_Of_Values so all invpartinstock keys uses Inventory_Part_In_Stock_API.Create_Data_Capture_Lov.
--  131220          Change in Get_Automatic_Data_Item_Value so all invpartinstock keys uses Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique 
--  131220          and added extra parameter to that call. Changes in Add_Lines_For_Latest_Data_Item so all data item as details uses Add_Unique_Detail___.
--  131220          Added missing invpartinstock keys to Get_Lov_Enabled
--  131128  AwWelk  PBSC-4130, Replaced the calls to Inventory_Part_In_Stock_API.Get_Catch_Qty_Onhand with 
--  131128          Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand.
--  12xxxx  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_                    CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

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
          wanted_data_item_id_ IN('PART_NO','CONFIGURATION_ID','LOT_BATCH_NO','SERIAL_NO','ENG_CHG_LEVEL','WAIV_DEV_REJ_NO','ACTIVITY_SEQ'))) THEN
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
   gtin_no_                    OUT VARCHAR2,
   handling_unit_id_           OUT NUMBER,
   sscc_                       OUT VARCHAR2,    -- not used for filtering in unique handling
   alt_handling_unit_label_id_ OUT VARCHAR2,
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

      -- Also fetch predicted barcode_id since this process can use barcodes
      barcode_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'BARCODE_ID', session_rec_ , process_package_, use_applicable_);
      gtin_no_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);      
      -- Add support for alternative handling unit keys
      IF (handling_unit_id_ IS NULL AND sscc_ IS NOT NULL) THEN
         handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(sscc_);
      ELSIF (handling_unit_id_ IS NULL AND alt_handling_unit_label_id_ IS NOT NULL) THEN
         handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(alt_handling_unit_label_id_);
      END IF;
      IF (sscc_ IS NULL AND handling_unit_id_ IS NOT NULL AND
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', 'SSCC')) THEN
         sscc_ := Handling_Unit_API.Get_Sscc(handling_unit_id_);                             
      END IF;
      IF (alt_handling_unit_label_id_ IS NULL AND handling_unit_id_ IS NOT NULL AND 
          Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'HANDLING_UNIT_ID', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
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
   data_item_detail_id_        IN VARCHAR2,
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
   barcode_id_                 IN NUMBER )
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
      IF (detail_value_ IS NULL AND data_item_detail_id_ IN ('CONDITION_CODE')) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, data_item_detail_id_);
      END IF;

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
   sql_where_expression_  := ' AND location_type_db IN (''PICKING'',''F'',''MANUFACTURING'') ';
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
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
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
   gtin_no_                    VARCHAR2(14);
   session_rec_                Data_Capture_Common_Util_API.Session_Rec;
   process_package_            VARCHAR2(30);
   part_catalog_rec_           Part_Catalog_API.Public_Rec;
   handling_unit_id_           NUMBER;
   sscc_                       VARCHAR2(18);
   alt_handling_unit_label_id_ VARCHAR2(25);
   catch_quantity_             NUMBER;
   quantity_                   NUMBER;
   input_unit_meas_group_id_   VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('LOT_BATCH_NO', 'SERIAL_NO')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
      END IF;

      IF (data_item_id_ NOT IN ('LOT_BATCH_NO', 'SERIAL_NO')) THEN   -- no lot_batch_no nor serial_no validation since it could be a new lot_batch_no or serial_no here
         Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                         data_item_id_,
                                                         data_item_value_);
      END IF;
      IF data_item_id_ IN ('INPUT_QUANTITY') THEN
         quantity_ := data_item_value_;
         IF (quantity_ < 0) THEN
            Error_SYS.Record_General(lu_name_,'QUANTITYVALIDATION: Input quantity must be greater than or equal to 0(zero).');
         END IF;  
      END IF;
      
      IF (data_item_id_ = 'BARCODE_ID') THEN         
         IF (data_item_value_ IS NOT NULL) THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_,
                               data_item_id_, data_item_value_, use_unique_values_ => TRUE);
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
      
      IF (data_item_id_ IN ('PART_NO','CATCH_QUANTITY', 'QUANTITY')) THEN
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
         part_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_);
         catch_quantity_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QUANTITY', session_rec_ , process_package_);
         IF (data_item_id_ = 'QUANTITY') THEN
            -- Don't allow serial parts to have a quantity value of anything else then 0 and 1
            quantity_ := data_item_value_;
            IF (part_no_ IS NOT NULL)  THEN
               part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
               serial_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_);
               IF (part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_serial_tracking AND
                  data_item_value_ NOT IN ('0','1')) THEN
                  Error_SYS.Record_General(lu_name_, 'ILLQTYSERIAL: The quantity may only be 0 or 1 when serial numbers are being used.');
               END IF;
            END IF;
         ELSE 
            quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'QUANTITY', session_rec_ , process_package_);
         END IF;
            
         IF quantity_ > 0 THEN 
            Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                         current_data_item_id_      => data_item_id_,
                                                         part_no_data_item_id_      => 'PART_NO',
                                                         part_no_data_item_value_   => part_no_,
                                                         catch_qty_data_item_id_    => 'CATCH_QUANTITY',
                                                         catch_qty_data_item_value_ => catch_quantity_,
                                                         positive_catch_qty_        => TRUE);  
         ELSE
            Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                         current_data_item_id_      => data_item_id_,
                                                         part_no_data_item_id_      => 'PART_NO',
                                                         part_no_data_item_value_   => part_no_,
                                                         catch_qty_data_item_id_    => 'CATCH_QUANTITY',
                                                         catch_qty_data_item_value_ => catch_quantity_,
                                                         catch_zero_qty_allowed_    => TRUE);  -- Since this process allow 0 counting
         END IF;
      END IF;
      
      IF (data_item_id_ IN ('INPUT_UOM') AND data_item_value_ IS NOT NULL) THEN 
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         part_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                       data_item_id_a_     => 'PART_NO',
                                                                       data_item_id_b_     => data_item_id_);
         input_unit_meas_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(session_rec_.session_contract, part_no_);
         Input_Unit_Meas_API.Record_With_Column_Value_Exist(input_unit_meas_group_id_ => input_unit_meas_group_id_,
                                                            column_name_              => 'UNIT_CODE',
                                                            column_value_             => data_item_value_,
                                                            column_description_       => data_item_description_,
                                                            sql_where_expression_     => Get_Input_Uom_Sql_Whr_Exprs___);   
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
         Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                            waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_,
                            data_item_id_, data_item_value_);

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

      IF (data_item_id_ = 'CONDITION_CODE')  THEN
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, contract_);
      ELSE
         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(dummy_contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_,
                               data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(dummy_contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
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
      
      
         ELSIF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN          
            IF (data_item_id_ = 'ENG_CHG_LEVEL' AND part_no_ IS NOT NULL ) THEN
               $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
                  -- This LOV variant is only here to support when user try to count a new part that dont have any records in Inventory Part In Stock yet and they dont know what Revision No to use,
                  -- now they can use this LOV to for example pick the latest one. They should also make sure to turn off Use Automatic value for this data item and only use the LOV. In the 
                  -- automatic handling we still use unique Revision identified from previously scanned data items so we can support counting of existing records also (we previoulsy had another 
                  -- solution in automatic handling that fetched the latest revision but that have been removed).
                  Part_Revision_API.Create_Data_Capture_Lov(contract_             => contract_,
                                                            part_no_              => part_no_,
                                                            capture_session_id_   => capture_session_id_);
               $ELSE
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
                $END
               
            ELSE 
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
            END IF;
         ELSIF (data_item_id_ IN ('INPUT_UOM')) THEN            
            input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
            Input_Unit_Meas_API.Create_Data_Capture_Lov(capture_session_id_, input_uom_group_id_, 'UNIT_CODE', lov_type_db_, Get_Input_Uom_Sql_Whr_Exprs___);   
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
   message_               VARCHAR2(200);
   completed_counter_     NUMBER;
   rejected_counter_      NUMBER;
BEGIN
   rejected_counter_  := NVL(to_number(process_message_), 0);
   completed_counter_ := no_of_records_handled_ - rejected_counter_; 
   
   message_ := Language_SYS.Translate_Constant(lu_name_, 'COUNTSAVE: Counting saved:');
   
   IF completed_counter_ > 0 THEN
      message_ := message_ || ' ' || Language_SYS.Translate_Constant(lu_name_, 'COMPLETE: :P1 completed', NULL, completed_counter_);
   END IF;
   
   IF rejected_counter_ > 0 THEN
      message_ := message_ || ' ' || Language_SYS.Translate_Constant(lu_name_, 'REJECT: :P1 rejected', NULL, rejected_counter_);
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
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_,
                               data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                               waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_);
         END IF;

         IF (data_item_id_ = 'BARCODE_ID') THEN
            automatic_value_ := barcode_id_;
         ELSIF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 
                                  'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'CONDITION_CODE', 'HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
   
            IF (barcode_id_ IS NOT NULL AND  
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
            
            IF (data_item_id_ = 'CONDITION_CODE' AND automatic_value_ IS NULL) THEN
               IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_) = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE) THEN
                  automatic_value_ := Condition_Code_API.Get_Default_Condition_Code;
               ELSE
                  automatic_value_ := 'NULL';
               END IF;                                 
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
   
            serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                            data_item_id_a_     => 'SERIAL_NO',
                                                                            data_item_id_b_     => data_item_id_);
            IF (serial_no_ IS NOT NULL AND serial_no_ != '*') THEN
               automatic_value_ := 1; 
            ELSE
               input_uom_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                               data_item_id_a_     => 'INPUT_UOM',
                                                                               data_item_id_b_     => data_item_id_);
   
               input_qty_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                               data_item_id_a_     => 'INPUT_QUANTITY',
                                                                               data_item_id_b_     => data_item_id_);
            END IF;  
            
            IF (input_uom_ IS NOT NULL) AND (input_qty_ IS NOT NULL) THEN
               input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
               input_conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_id_, input_uom_);
               automatic_value_ := input_qty_ * input_conv_factor_; 
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
   capture_session_id_      IN NUMBER,
   latest_data_item_id_     IN VARCHAR2,
   latest_data_item_value_  IN VARCHAR2 )
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
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                         waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

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

                  alt_handling_unit_label_id_ := CASE alt_handling_unit_label_id_ WHEN '%' THEN NULL ELSE alt_handling_unit_label_id_ END;      -- % if it is not scanned yet
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
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                                 contract_                   => contract_,
                                                 part_no_                    => part_no_,
                                                 location_no_                => location_no_,
                                                 configuration_id_           => configuration_id_,
                                                 lot_batch_no_               => lot_batch_no_,
                                                 serial_no_                  => serial_no_,
                                                 eng_chg_level_              => eng_chg_level_,
                                                 waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                 activity_seq_               => activity_seq_,
                                                 handling_unit_id_           => handling_unit_id_,
                                                 alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                 barcode_id_                 => barcode_id_);
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
   ptr_                  NUMBER;
   name_                 VARCHAR2(50);
   value_                VARCHAR2(4000);
   location_no_          VARCHAR2(35);
   part_no_              VARCHAR2(25);
   quantity_             NUMBER;
   serial_no_            VARCHAR2(50) := '*';
   configuration_id_     VARCHAR2(50) := '*';
   lot_batch_no_         VARCHAR2(20) := '*';
   eng_chg_level_        VARCHAR2(6) := '1';
   waiv_dev_rej_no_      VARCHAR2(15) := '*';
   activity_seq_         NUMBER := 0;
   condition_code_       VARCHAR2(10);
   state_                VARCHAR2(50);
   qty_onhand_           NUMBER;
   catch_quantity_       NUMBER;
   catch_qty_onhand_     NUMBER;
   note_                 VARCHAR2(2000);
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
      ELSIF (name_ = 'CONDITION_CODE') THEN
         condition_code_ := value_;
      ELSIF (name_ = 'CATCH_QUANTITY') THEN
         catch_quantity_ := value_;
      ELSIF (name_ = 'NOTE') THEN
         note_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;

   qty_onhand_ := NVL(Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_         => contract_,
                                                                 part_no_          => part_no_,
                                                                 configuration_id_ => configuration_id_,
                                                                 location_no_      => location_no_,
                                                                 lot_batch_no_     => lot_batch_no_,
                                                                 serial_no_        => serial_no_,
                                                                 eng_chg_level_    => eng_chg_level_,
                                                                 waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                 activity_seq_     => activity_seq_,
                                                                 handling_unit_id_ => handling_unit_id_), 0);
   IF (catch_quantity_ IS NOT NULL) THEN
      catch_qty_onhand_  := Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand(contract_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                                                                                 serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
   END IF;
   Counting_Result_API.New_Result(state_                    => state_,
                                  contract_                 => contract_,
                                  part_no_                  => part_no_,
                                  configuration_id_         => configuration_id_,
                                  location_no_              => location_no_,
                                  lot_batch_no_             => lot_batch_no_,
                                  serial_no_                => serial_no_,
                                  eng_chg_level_            => eng_chg_level_,
                                  waiv_dev_rej_no_          => waiv_dev_rej_no_,
                                  activity_seq_             => activity_seq_,
                                  handling_unit_id_         => handling_unit_id_,
                                  count_date_               => NVL(Site_API.Get_Site_Date(contract_), SYSDATE),
                                  inv_list_no_              => '*',
                                  seq_                      => 0,
                                  qty_onhand_               => qty_onhand_,
                                  qty_counted_              => quantity_,
                                  catch_qty_onhand_         => catch_qty_onhand_,
                                  catch_qty_counted_        => catch_quantity_,
                                  count_user_id_            => Fnd_Session_API.Get_Fnd_User,
                                  inventory_value_          => NULL,
                                  condition_code_           => condition_code_,
                                  note_text_                => note_,
                                  cost_detail_id_           => NULL,
                                  part_tracking_session_id_ => NULL );
   
   IF state_ = 'Rejected' THEN
      process_message_ := TO_CHAR(NVL(to_number(process_message_),0) + 1);
   END IF;
   
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Counting_Result_API.New_Result is granted thru following projection/action
   IF (Security_SYS.Is_Proj_Action_Available('CountPerInventoryPart', 'CreateCountingResult') ) THEN
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
         Get_Filter_Keys___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, 
                            waiv_dev_rej_no_, activity_seq_, barcode_id_, gtin_no_, handling_unit_id_, sscc_, alt_handling_unit_label_id_, capture_session_id_, data_item_id_, use_applicable_ => FALSE);
         part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
      END IF;
      IF (serial_no_ IS NULL) AND (data_item_id_ = 'QUANTITY') THEN
         serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
      END IF;
   $END

   RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, data_item_id_, part_no_, serial_no_);
END Fixed_Value_Is_Applicable;
