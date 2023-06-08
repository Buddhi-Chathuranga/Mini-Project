-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptureMovePart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: MOVE_PART
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200811  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  181019  BudKlk  Bug 143097, Modified the method Add_Details_For_Latest_Item to add new feedback items CONDITION_CODE and CONDITION_CODE_DESCRIPTION.
--  180511  BudKlk  Bug 141856, Modified Execute_Process() in order to get value to new data item NOTE. 
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171129  CKumlk  STRSC-14828, Added GTIN to Add_Filter_Key_Detail___.
--  171121  SWiclk  Modified Validate_Data_Item() in order to raise an error when barcode is scaned/entered and there is no available qty to be moved. 
--  170913  DaZase  STRSC-11606, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  170913          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170908  SWiclk  STRSC-11956, Modified Get_Automatic_Data_Item_Value() in order to handle INPUT_UOM  and INPUT_QUANTITY when 
--  170908          inventory part has a value for Input UoM Group.
--  170822  SWiclk  STRSC-11571, Modified Get_Automatic_Data_Item_Value() in order to pass 'NULL' for GTIN when part doesn't have GTIN.
--  170815  SWiclk  STRSC-9612, Added Get_Input_Uom_Sql_Whr_Exprs___() and added GTIN to Get_Filter_Keys___().
--  170630  BudKlk  Bug 136631, Modified the method Get_Automatic_Data_Item_Value() to make sure when the dataitem is AVAILABILITY_CONTROL_ID and if there in no value in the inventory part in stock , 
--  170630          we need to retrive the defalut value form invenotry location.
--  170726  BudKlk  Bug 136550, Modified the method Execute_Process to pass the value of availability control Id into the method call Inventory_Part_In_Stock_API.Move_Part and 
--  170726          remove the method call Inventory_Part_In_Stock_API.Modify_Availability_Control_Id(). 
--  170713  SWiclk  STRSC-9621, Modified Get_Sql_Where_Expression___ in order to allow reserved parts to be moved based on Site configuration.
--  170713          Modified Execute_Process() by calling Invent_Part_Quantity_Util_API.Move_Part() instead of Inventory_Part_In_Stock_API.Move_Part().
--  170707  SWiclk  STRSC-9612, Implemented GTIN support, hence handled GTIN, INPUT_UOM and INPUT_QUANTITY data items 
--  170707          and INPUT_CONV_FACTOR as feedback item and GTIN_IS_MANDATORY as detail item.
--  170418  DaZase  LIM-10662, Changes in Get_Filter_Keys___ on how Bug 132004 was solved, now we check if inventory barcode is enabled correctly. 
--  170316  Khvese  LIM-11175, Modified method Get_Inventory_Event_Id___() to construct message correctly 
--  170316  Khvese  LIM-11050, Changed the process_message type from VARCHAR2 to CLOB in all its appearances. 
--  170316          Also added capture_session_id_ and contract_ to the interface of method Post_Process_Action.
--  170302  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170113  DaZase  LIM-8660, Added a catch quantity validation in Validate_Data_Item.  
--  161108  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161010  SWiclk  Bug 132004, Modified Get_Filter_Keys___() and Validate_Data_Item() in order to check whether  
--  161010          Barcode Id is mandatory or not before trying to fetch a unique value.
--  160920  DaZase  LIM-8318, Added Level 2 feedback items.
--  160608  BudKlk  Bug 122162, Modified Get_Automatic_Data_Item_Value(), Execute_Process() and Create_List_Of_Values() in order to get value to new data item CONSUME_CONSIGNMENT.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160315  BudKlk  Bug 127445, Modified the method Part_Exist_With_Diff_Pac to an implementation method Part_Exist_With_Diff_Pac___(). Also added QTY_ONHAND and QTY_IN_TRANSIT  
--  160315          to make sure that the to_location is not zero and Part availability IDs are different to get a new DESTINATION_WAIV_DEV_REJ_NO.
--  151123  Chfose  LIM-5033, Removed pallet_list-parameter in call to Inventory_Part_In_Stock_API.Move_Part.
--  151102  BudKlk  Bug 125548, Modified the method Add_Details_For_Latest_Item() to add a new feedback item AVAILABILITY_CONTROL_DESCRIPTION.
--  151103  KhVeSe  LIM-4526, Modified Location feedback items in Add_Details_For_Latest_Item() method.
--  151030  DaZase  LIM-4297, Added calls to Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type, 
--  151030  DaZase  Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit in Add_Details_For_Latest_Item.
--  151027  DaZase  LIM-4297, Added handling for new data items HANDLING_UNIT_ID, SSCC and ALT_HANDLING_UNIT_LABEL_ID.
--  150907  DaZase  AFT-3269, Reworked how LOV for TO_CONTRACT and TO_LOCATION_NO works.
--  150826  RuLiLk  Bug 124207, Modified error message TOMUCHQTYMOVE, to display quantity available between 0 and 1 with a leading 0.
--  150807  DaZase  COB-607, Reworked some of the unique methods so data items that are not using the filter keys 
--  150807          are handled before calling Get_Filter_Keys___, to help performance a bit. 
--  150803  SWiclk  Bug 121254, Modified Get_Unique_Data_Item_Value___(), Validate_Data_Item(), Get_Automatic_Data_Item_Value() and Create_List_Of_Values() by changing the parameter list 
--  150803          of methods which are from Inventory_Part_Barcode_API since the contract has been changed as a parentkey.
--  150617  DaZase  COB-475, Interface change to calls to Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique.
--  150526  ChBnlk  Bug 121620, Modified Add_Details_For_Latest_Item() by adding LOCATION_NO_DESC as a detail to location_no_ and 
--  150526          TO_LOCATION_NO_DESC as a detail to to_location_no_. 
--  150413  Chfose  LIM-983, Fixed calls to Inventory_Part_In_Stock_API by including handling_unit_id where applicable.
--  150217  RILASE  PRSC-5354, Added automatic value for catch qty so that the catch qty is fetched when the full qty is move from a location and nothing is reserved.
--  150203  DaZase  PRSC-5324, Change in Validate_Data_Item so if data item QUANTITY we try to fetch all filter keys with unique handling so the qty onhand checks can performed as early as possible.
--  150129  KhVeSe  PRSC-5485, Added Get_Putaway_Event_Id___, Update_Putaway_Event_Id___ and Post_Process_Action to support putaway events 
--  150129          and a call to Get_Putaway_Event_Id___() in Execute_Process().            
--  150122  DaZase  PRSC-5388, Added method Part_Exist_With_Diff_Pac and calls to it in Get_Automatic_Data_Item_Value, Validate_Data_Item and Execute_Process.
--  141110  SWiclk  PRSC-4249, Bug 119584, Modified Get_Automatic_Data_Item_Value() in order to get the available qty automatically.
--  141106  DaZase  PRSC-4009, Changed Fixed_Value_Is_Applicable so it now fetches predicted and unique part_no.
--  141020  DaZase  PRSC-3323, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___ and Add_Details_For_Latest_Item. 
--  141015          Replaced Get_Data_Item_Value___ with new method Get_Unique_Data_Item_Value___. Replaced Add_Unique_Detail___ with new methods Add_Filter_Key_Detail___/Add_Unique_Data_Item_Detail___. 
--  141009  DaZase  PRSC-63, Changed Get_Automatic_Data_Item_Value, Create_List_Of_Values and Validate_Data_Item to now use methods in Inventory_Part_Barcode_API for BARCODE_ID.
--  140916  DaZase  PRSC-2781, Changes in process to reflect that DESTINATION/SET_AVAILABILITY_CONTROL_ID data items now have their enumeration db values saved on session line.
--  140908  RiLase  Removed empty methods since the wadaco framework now can handle when methods doesn't exist.
--  140908  RiLase  PRSC-2497, Added Fixed_Value_Is_Applicable().
--  140827  DaZase  PRSC-1655, Added Validate_Config_Data_Item.
--  140815  Dazase  PRSC-1611, Removed Apply_Additional_Line_Content since it is now obsolete and Get_Automatic_Data_Item_Value can be used instead. 
--  140812  DaZase  PRSC-1611, Renamed Add_Lines_For_Latest_Data_Item to Add_Details_For_Latest_Item.
--  140805  DaZase  PRSC-1431, Changed part_no_ to VARCHAR2(25) and location_no_ to VARCHAR2(35) and destination_ to VARCHAR2(200).
--  140620  SWiclk  PRSC-1867, Bug 117179, Modified Get_Process_Execution_Message() and Execute_Process() by adding parameter process_message_
--  140620          and parameters process_message_ and blob_ref_attr_ respectively.
--  140414  DaZase  Added a exists check for SET_AVAILABILITY_CONTROL_ID in Validate_Data_Item. Change in Get_Automatic_Data_Item_Value for 
--  140414          AVAILABILITY_CONTROL_ID when SET_AVAILABILITY_CONTROL_ID is NEW_AVAILABILITY_CONTROL_ID or NULL so we dont fetch automatic 
--  140414          value for AVAILABILITY_CONTROL_ID. Also added in Get_Automatic_Data_Item_Value so SET_AVAILABILITY_CONTROL_ID is set to SAME_AS_FROM_LOCATION 
--  140014          if both from/to pac id are NULL.
--  140228  RuLiLk  Bug 114926, Modified method Execute_Process() and Apply_Additional_Line_Content() by Renaming data item SET_WAIV_DEV_REJ_NO as DESTINATION_WAIV_DEV_REJ_NO
--  140228          Added method call to modify availability_control_id_ in Execute_Process().
--  140225  DaZase  Moved code for SET_WAIV_DEV_REJ_NO/TO_CONTRACT in Apply_Additional_Line_Content to Get_Automatic_Data_Item_Value. Removed validation 
--  140225          in Validate_Configuration_Detail since its now obsolete with the new process detail for this process. Changes in Add_Lines_For_Latest_Data_Item 
--  140225          and Set_Media_Id_For_Data_Item  due to process detail change where the 2 old ones was replaced with USE_FROM_SITE_AS_AUTOMATIC_VALUE.
--  140107  DaZase  Bug 114021, Added extra control in Get_Automatic_Data_Item_Value for QUANTITY to make sure that we return 1 for all types of serial parts.
--  131220  DaZase  Bug 114021, Did some refactoring in this process to make it more like the other processes with more unique handling.
--  131220          Added all invpartinstock keys as parameters on Get_Data_Item_Value___ and added 
--  131220          Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique call in this method. Added method Add_Unique_Detail___ to 
--  131220          handle data items as details. Replaced Inventory_Part_In_Stock_API.Check_Valid_Value with Data_Capture_Invent_Util_API.Match_Barcode_Keys 
--  131220          for BARCODE_ID in Validate_Data_Item and added get_id_ parameter to calls to Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique.
--  131220          Change in Create_List_Of_Values so all invpartinstock keys uses Inventory_Part_In_Stock_API.Create_Data_Capture_Lov.
--  131220          Change in Get_Automatic_Data_Item_Value so all invpartinstock keys uses Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique 
--  131220          and added extra parameter to that call. Changes in Add_Lines_For_Latest_Data_Item so all data item as details uses Add_Unique_Detail___.
--  131220          Added missing invpartinstock keys to Get_Lov_Enabled
--  131209  SWiclk  Bug 112876, Modified Execute_Process() by Passing destination_wdr_no_ as the to to_waiv_dev_rej_no_ parameter. 
--  131204  SWiclk  Bug 112876, Modified Execute_Process(), Apply_Additional_Line_Content() and Add_Lines_For_Latest_Data_Item()
--  131204          in order to handle new data item 'SET_WAIV_DEV_REJ_NO'.
--  131129  SWiclk  Bug 112876, Modified Add_Lines_For_Latest_Data_Item() by adding 'SET_AVAILABILITY_CONTROL_ID' and 
--  131129          'AVAILABILITY_CONTROL_ID' data ietems as detail items.
--  131121  SWiclk  Bug 112876, Modified Get_Automatic_Data_Item_Value(), Execute_Process(), Get_Lov_Enabled()
--  131121          and Create_List_Of_Values() in order to handle part availability control id.
--  131107  DaZase  Bug 113189, In method Create_List_Of_Values changed value_list_id_ := 2 to value_list_id_ := 1.
--  131023  SWiclk  Bug 112203, Modified Get_Lov_Enabled() to enable lov for 'ACTIVITY_SEQ'.
--  131007  SWiclk  Bug 112203, Modified Get_Lov_Enabled() in order to show LOV for lot batch no and WDR no. Modified
--  131007          Get_Automatic_Data_Item_Value() in order to get the automatic values for 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'LOT_BATCH_NO'. 
--  130819  SWiclk  Bug 111889, Modified Execute_Process() in order to pass the expiration_date_ correctly.                                                                             
--  1209xx  DaZase  Created
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
   wanted_data_item_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   dummy_                 BOOLEAN;
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
   to_contract_                OUT VARCHAR2,  -- not used for filtering in unique handling
   part_no_                    OUT VARCHAR2,
   location_no_                OUT VARCHAR2,  -- not used for filtering in unique handling
   to_location_no_             OUT VARCHAR2,
   configuration_id_           OUT VARCHAR2,
   lot_batch_no_               OUT VARCHAR2,
   serial_no_                  OUT VARCHAR2,
   eng_chg_level_              OUT VARCHAR2,
   waiv_dev_rej_no_            OUT VARCHAR2,
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
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_        := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      part_no_          := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      configuration_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      serial_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      activity_seq_     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
      location_no_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      to_contract_      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_CONTRACT', session_rec_ , process_package_, use_applicable_);
      to_location_no_   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TO_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
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
         -- TO_CONTRACT, TO_LOCATION and SSCC not included in the unique fetch 
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
   to_contract_                IN VARCHAR2,
   to_location_no_             IN VARCHAR2,
   handling_unit_id_           IN NUMBER,
   sscc_                       IN VARCHAR2,  
   alt_handling_unit_label_id_ IN VARCHAR2,
   barcode_id_                 IN NUMBER,
   gtin_no_                    IN VARCHAR2 )  
IS
   detail_value_         VARCHAR2(200);
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
         WHEN ('TO_CONTRACT') THEN
            detail_value_ := to_contract_;
         WHEN ('TO_LOCATION_NO') THEN
            detail_value_ := to_location_no_;
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


PROCEDURE Update_Inventory_Event_Id___(
   process_message_    IN OUT CLOB,
   inventory_event_id_ IN     NUMBER )
IS
BEGIN
   IF (inventory_event_id_ IS NOT NULL) THEN
      Message_SYS.Set_Attribute(process_message_, 'INVENTORY_EVENT_ID', inventory_event_id_);
   END IF;
END Update_Inventory_Event_Id___;


FUNCTION Get_Inventory_Event_Id___(
   process_message_ IN OUT CLOB ) RETURN NUMBER
IS
   inventory_event_id_ NUMBER;
   number_null_        NUMBER;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      inventory_event_id_ := Message_SYS.Find_Attribute(process_message_, 'INVENTORY_EVENT_ID', number_null_);
   END IF;
   
   IF (inventory_event_id_ IS NULL) THEN 
      inventory_event_id_ := Inventory_Event_Manager_API.Get_Next_Inventory_Event_Id;
      process_message_ := Message_SYS.Construct_Clob_Message('IEID');
      Update_inventory_event_Id___(process_message_, inventory_event_id_);
   END IF;
   
   RETURN inventory_event_id_;
END Get_Inventory_Event_Id___;


FUNCTION Get_Sql_Where_Expression___ (
   unique_type_              IN VARCHAR2 DEFAULT 'NORMAL' ) RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(32000);
BEGIN
   -- common where statements for this process
   sql_where_expression_  := ' AND location_type_db IN (''PICKING'',''F'',''SHIPMENT'',''MANUFACTURING'')
                               AND freeze_flag_db = ''N'' ';

   IF (unique_type_ = 'NOT_RESERVED') THEN
      sql_where_expression_  := sql_where_expression_ || ' AND qty_reserved = 0 ';
   ELSE  -- unique_type_ = 'NORMAL'
      -- This will evaluate whether it allows to move reserved parts based on the the site setting  "Move Reserved Stock" in Inventory-General tab.
      sql_where_expression_  := sql_where_expression_ || ' AND Inv_Part_Stock_Reservation_API.Get_Available_Qty_To_Move(contract,
                                                                                                                        part_no,
                                                                                                                        configuration_id,
                                                                                                                        location_no,
                                                                                                                        lot_batch_no,
                                                                                                                        serial_no,
                                                                                                                        eng_chg_level,
                                                                                                                        waiv_dev_rej_no,
                                                                                                                        activity_seq,
                                                                                                                        handling_unit_id,
                                                                                                                        qty_onhand,
                                                                                                                        qty_reserved ) > 0 ';
   END IF;
   RETURN sql_where_expression_;
END Get_Sql_Where_Expression___;

FUNCTION Get_Input_Uom_Sql_Whr_Exprs___  RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(32000);
BEGIN   
   sql_where_expression_  := ' AND (purch_usage_allowed = 1 OR cust_usage_allowed = 1 OR manuf_usage_allowed = 1) ';  
   RETURN sql_where_expression_;
END Get_Input_Uom_Sql_Whr_Exprs___;


-- Part Exist with Different Part Availability Control ID on to location
FUNCTION Part_Exist_With_Diff_Pac___ (
   to_contract_                 IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   to_location_no_              IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   destination_waiv_dev_rej_no_ IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,
   availability_control_id_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   return_value_                 BOOLEAN := FALSE;
   destination_stock_rec_        Inventory_Part_In_Stock_API.Public_Rec;
BEGIN
   -- Only do this check if we values for all the part stock keys, if they havent been scanned yet we cannot do this 
   IF (destination_waiv_dev_rej_no_ IS NOT NULL AND to_contract_ IS NOT NULL AND part_no_ IS NOT NULL AND 
       configuration_id_ IS NOT NULL AND to_location_no_ IS NOT NULL AND lot_batch_no_ IS NOT NULL AND 
       serial_no_ IS NOT NULL AND eng_chg_level_ IS NOT NULL AND activity_seq_ IS NOT NULL AND handling_unit_id_ IS NOT NULL) THEN

      IF Inventory_Part_In_Stock_API.Check_Exist(contract_         => to_contract_,
                                                 part_no_          => part_no_,
                                                 configuration_id_ => configuration_id_,
                                                 location_no_      => to_location_no_,
                                                 lot_batch_no_     => lot_batch_no_,
                                                 serial_no_        => serial_no_,
                                                 eng_chg_level_    => eng_chg_level_,
                                                 waiv_dev_rej_no_  => destination_waiv_dev_rej_no_,
                                                 activity_seq_     => activity_seq_,
                                                 handling_unit_id_ => handling_unit_id_) THEN 
         destination_stock_rec_ := Inventory_Part_In_Stock_API.Get(contract_         => to_contract_,
                                                                   part_no_          => part_no_,
                                                                   configuration_id_ => configuration_id_,
                                                                   location_no_      => to_location_no_,
                                                                   lot_batch_no_     => lot_batch_no_,
                                                                   serial_no_        => serial_no_,
                                                                   eng_chg_level_    => eng_chg_level_,
                                                                   waiv_dev_rej_no_  => destination_waiv_dev_rej_no_,
                                                                   activity_seq_     => activity_seq_,
                                                                   handling_unit_id_ => handling_unit_id_); 

         IF ((destination_stock_rec_.qty_onhand != 0) OR (destination_stock_rec_.qty_in_transit != 0)) THEN
            IF (NVL(availability_control_id_, Database_Sys.string_null_) != NVL(destination_stock_rec_.availability_control_id, Database_Sys.string_null_)) THEN
               return_value_ := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;

   RETURN return_value_;

END Part_Exist_With_Diff_Pac___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2, 
   data_item_value_     IN VARCHAR2 )       
IS
   contract_                     VARCHAR2(5);
   to_contract_                  VARCHAR2(5);
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);
   to_location_no_               VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   configuration_id_             VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   eng_chg_level_                VARCHAR2(6);
   waiv_dev_rej_no_              VARCHAR2(15);
   activity_seq_                 NUMBER;
   qty_to_move_                  NUMBER;
   qty_onhand_                   NUMBER;
   qty_reserved_                 NUMBER;
   qty_available_                NUMBER;
   data_item_description_        VARCHAR2(200);
   location_type_db_             VARCHAR2(20);
   to_location_type_db_          VARCHAR2(20);
   barcode_id_                   NUMBER;
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   process_package_              VARCHAR2(30);
   availability_control_id_      VARCHAR2(25);
   destination_waiv_dev_rej_no_  VARCHAR2(15);
   dummy_                        BOOLEAN;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   column_value_nullable_        BOOLEAN := FALSE;
   catch_quantity_               NUMBER;
   input_unit_meas_group_id_     VARCHAR2(30);
   gtin_no_                      VARCHAR2(14);
   move_reservation_option_db_   VARCHAR2(20);   
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('QUANTITY', 'INPUT_QUANTITY')) THEN
         IF (data_item_value_ <= 0) THEN
            Error_SYS.Record_General(lu_name_, 'NEGATIVEORZEROQTY: Zero or Negative Quantity is not allowed.');
         END IF;
      END IF;
      Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                      data_item_id_,
                                                      data_item_value_);
      IF (data_item_id_ = 'SET_AVAILABILITY_CONTROL_ID') THEN
         Part_Avail_Ctrl_Move_Opt_API.Exist_Db(data_item_value_);
      ELSE
         session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
         IF (data_item_id_ IN ('BARCODE_ID', 'QUANTITY')) THEN
            -- Note: No need to get values for process keys when barcode_id is null because probably it would not be used in this process.
            IF ((data_item_id_ = 'BARCODE_ID' AND data_item_value_ IS NOT NULL) OR (data_item_id_ IN ('QUANTITY'))) THEN
               -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
               Get_Filter_Keys___(contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                                  lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_,
                                  handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                                  capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE);
            END IF;            
         ELSE
            Get_Filter_Keys___(contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                               lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_, data_item_value_);
         END IF;

         IF (data_item_id_ IN ('PART_NO','CATCH_QUANTITY')) THEN
            catch_quantity_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QUANTITY', session_rec_ , process_package_);
            Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                         current_data_item_id_      => data_item_id_,
                                                         part_no_data_item_id_      => 'PART_NO',
                                                         part_no_data_item_value_   => part_no_,
                                                         catch_qty_data_item_id_    => 'CATCH_QUANTITY',
                                                         catch_qty_data_item_value_ => catch_quantity_,
                                                         positive_catch_qty_        => TRUE);  -- Since this process dont allow normal quantity to be zero or lower it shouldnt allow it for catch quantity either
         END IF;

         qty_to_move_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'QUANTITY', session_rec_ , process_package_);
         data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
          
         IF (data_item_id_ IN ('PART_NO', 'LOCATION_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 
                               'ACTIVITY_SEQ', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
   
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
                   
               move_reservation_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(contract_);  
               IF (move_reservation_option_db_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
                  -- We need to check whether there is/are records to be moved when 'Move Reserved Stock' is Not Allowed. But barcode does not fetch handling unit id.  
                  -- Therefore we check for existance of records in inventory_part_in_stock for given key values.               
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
                                                                             column_name_                => 'HANDLING_UNIT_ID',
                                                                             column_value_               => data_item_value_,
                                                                             column_description_         => data_item_description_,
                                                                             sql_where_expression_       => Get_Sql_Where_Expression___,
                                                                             column_value_exist_check_   => FALSE);
               END IF;
                                                                         
            END IF;
         ELSIF (data_item_id_ IN ('QUANTITY' )) THEN            
            qty_onhand_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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
                                                                                  column_name_                => 'QTY_ONHAND',
                                                                                  sql_where_expression_       => Get_Sql_Where_Expression___);
   
            qty_reserved_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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
                                                                                    column_name_                => 'QTY_RESERVED',
                                                                                    sql_where_expression_       => Get_Sql_Where_Expression___);            
            
            qty_available_ := Inv_Part_Stock_Reservation_API.Get_Available_Qty_To_Move(contract_,
                                                                                       part_no_,
                                                                                       configuration_id_,
                                                                                       location_no_,
                                                                                       lot_batch_no_,
                                                                                       serial_no_,
                                                                                       eng_chg_level_,
                                                                                       waiv_dev_rej_no_,
                                                                                       activity_seq_,
                                                                                       handling_unit_id_,
                                                                                       qty_onhand_,
                                                                                       qty_reserved_);
            
            
            IF (qty_available_ <= 0 ) THEN
               Error_SYS.Record_General(lu_name_, 'NOQTYONHAND: There is no quantity available on this location for this part.');
            ELSIF (qty_to_move_ IS NOT NULL AND qty_to_move_ > qty_available_) THEN
               Error_SYS.Record_General(lu_name_, 'TOMUCHQTYMOVE: Available quantity is only :P1.', Data_Capture_Common_Util_API.Get_Leading_Zero_For_Decimals(qty_available_));
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
   
         -- same location check
         IF (data_item_id_ IN ('LOCATION_NO', 'TO_LOCATION_NO', 'TO_CONTRACT') AND 
             location_no_ IS NOT NULL AND to_location_no_ IS NOT NULL AND to_contract_ IS NOT NULL) THEN
            IF (contract_ = to_contract_ AND location_no_ = to_location_no_) THEN
               Error_SYS.Record_General(lu_name_,'MOVETOSAME: You cannot move the part(s) to the same location :P1, select a different location.', to_location_no_);
            END IF;
         END IF;
   
         -- Check location types on from and to location
         IF (data_item_id_ IN ('LOCATION_NO', 'TO_LOCATION_NO', 'TO_CONTRACT') AND 
             location_no_ IS NOT NULL AND to_location_no_ IS NOT NULL AND to_contract_ IS NOT NULL) THEN
            location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
            to_location_type_db_ := Inventory_Location_API.Get_Location_Type_Db(to_contract_, to_location_no_);
            IF (to_location_type_db_ = Inventory_Location_Type_API.DB_ARRIVAL AND 
                location_type_db_ NOT IN (Inventory_Location_Type_API.DB_ARRIVAL, Inventory_Location_Type_API.DB_QUALITY_ASSURANCE)) THEN
               Error_SYS.Record_General(lu_name_, 'TOLOCNOTARRORQA: Parts can only be moved to locations of type Arrival only from locations of types Arrival and Quality Assurance.');
            END IF;
         END IF;
   
         IF (data_item_id_ = 'DESTINATION_WAIV_DEV_REJ_NO') THEN
            availability_control_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'AVAILABILITY_CONTROL_ID', session_rec_ , process_package_);
            destination_waiv_dev_rej_no_ := data_item_value_;
            
            IF Part_Exist_With_Diff_Pac___(to_contract_, part_no_, configuration_id_, to_location_no_, lot_batch_no_, serial_no_, 
                                        eng_chg_level_, destination_waiv_dev_rej_no_, activity_seq_, handling_unit_id_, availability_control_id_) THEN
               Error_SYS.Record_General(lu_name_,'NEEDNEWWDRNO: Must enter a new value for destination W/D/R No. Part already exists in the same location with different Availability Control Id.');
            END IF;
         END IF;
         IF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
         END IF;
      END IF;
   $ELSE
      NULL;   
   $END
END Validate_Data_Item;


PROCEDURE Create_List_Of_Values (
   capture_session_id_  IN NUMBER,
   capture_process_id_  IN VARCHAR2,
   capture_config_id_   IN NUMBER,
   data_item_id_        IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS
   dummy_contract_               VARCHAR2(5);
   to_contract_                  VARCHAR2(5);
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);
   to_location_no_               VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   configuration_id_             VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   eng_chg_level_                VARCHAR2(6);
   waiv_dev_rej_no_              VARCHAR2(15);
   activity_seq_                 NUMBER;
   barcode_id_                   NUMBER;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   lov_type_db_                  VARCHAR2(20);
   input_uom_group_id_           VARCHAR2(30);
   gtin_no_                      VARCHAR2(14);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (data_item_id_ = 'SET_AVAILABILITY_CONTROL_ID') THEN
         Part_Avail_Ctrl_Move_Opt_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ IN ('DESTINATION', 'AVAILABILITY_CONTROL_ID', 'DESTINATION_WAIV_DEV_REJ_NO', 'CONSUME_CONSIGNMENT')) THEN  
         Data_Capture_Invent_Util_API.Create_List_Of_Values(capture_session_id_, capture_process_id_, capture_config_id_, data_item_id_, contract_);
      ELSIF (data_item_id_ = 'TO_CONTRACT') THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                        capture_config_id_  => capture_config_id_,
                                                        data_item_id_a_     => 'TO_LOCATION_NO',
                                                        data_item_id_b_     => 'TO_CONTRACT')) THEN
            to_location_no_ := Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'TO_LOCATION_NO');
            Inventory_Location_API.Create_Data_Capture_Lov(contract_            => NULL, 
                                                           capture_session_id_  => capture_session_id_, 
                                                           include_location_no_ => to_location_no_,
                                                           lov_id_              => 8);
         ELSIF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                        capture_config_id_  => capture_config_id_,
                                                        data_item_id_a_     => 'PART_NO',
                                                        data_item_id_b_     => 'TO_CONTRACT')) THEN
            Inventory_Part_API.Create_Data_Capture_Lov(contract_           => contract_, 
                                                       capture_session_id_ => capture_session_id_,
                                                       part_no_            => Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'PART_NO'), 
                                                       lov_id_             => 2);
         ELSE
            User_Allowed_Site_API.Create_Data_Capture_Lov(capture_session_id_);
         END IF;
      ELSIF (data_item_id_ = 'TO_LOCATION_NO') THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                        capture_config_id_  => capture_config_id_,
                                                        data_item_id_a_     => 'TO_CONTRACT',
                                                        data_item_id_b_     => 'TO_LOCATION_NO')) THEN
            to_contract_ := Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'TO_CONTRACT');
            Inventory_Location_API.Create_Data_Capture_Lov(contract_           => to_contract_, 
                                                           capture_session_id_ => capture_session_id_, 
                                                           lov_id_             => 1);
         ELSIF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_, capture_config_id_, 'USE_FROM_SITE_AS_AUTOMATIC_VALUE') = Fnd_Boolean_API.db_true AND
                Data_Capt_Conf_Data_Item_API.Get_Use_Automatic_Value_Db(capture_process_id_, capture_config_id_, 'TO_CONTRACT') = Data_Capture_Value_Usage_API.DB_FIXED) THEN
            Inventory_Location_API.Create_Data_Capture_Lov(contract_           => contract_,    -- Since detail flag is set we can use from site here even thou to_contract have not been scanned yet
                                                           capture_session_id_ => capture_session_id_, 
                                                           lov_id_             => 1);
         ELSE
            Inventory_Location_API.Create_Data_Capture_Lov(contract_           => NULL, 
                                                           capture_session_id_ => capture_session_id_, 
                                                           lov_id_             => 2);
         END IF;         
      ELSE
         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(dummy_contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                               lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(dummy_contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                               lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_, 
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
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
   
         ELSIF (data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOCATION_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 
                                  'ACTIVITY_SEQ', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN                              
                                    
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
      END IF;

   $ELSE
      NULL;   
   $END
END Create_List_Of_Values;


@UncheckedAccess
FUNCTION Get_Process_Execution_Message (
   capture_process_id_    IN VARCHAR2,
   no_of_records_handled_ IN NUMBER,
   process_message_       IN CLOB ) RETURN VARCHAR2
IS
   message_               VARCHAR2(200);
BEGIN
   IF no_of_records_handled_ = 1 THEN
      message_ :=  Language_SYS.Translate_Constant(lu_name_, 'MOVEOK: The stock move has been completed.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MOVESOK: :P1 stock moves have been completed.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   part_no_                      VARCHAR2(25);
   barcode_id_                   NUMBER;
   contract_                     VARCHAR2(5);
   to_contract_                  VARCHAR2(5);
   location_no_                  VARCHAR2(35);
   to_location_no_               VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   configuration_id_             VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   eng_chg_level_                VARCHAR2(6);
   waiv_dev_rej_no_              VARCHAR2(15);
   activity_seq_                 NUMBER;
   automatic_value_              VARCHAR2(200);
   set_availability_cont_id_     VARCHAR2(100);
   auto_fetch_                   BOOLEAN := TRUE;
   from_pac_id_                  VARCHAR2(25);
   to_pac_id_                    VARCHAR2(25);
   qty_onhand_                   NUMBER;
   qty_reserved_                 NUMBER;
   process_package_              VARCHAR2(30);
   availability_control_id_      VARCHAR2(25);
   destination_waiv_dev_rej_no_  VARCHAR2(15);
   quantity_to_move_             NUMBER;
   dummy_                        BOOLEAN;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   part_ownership_db_            VARCHAR2(20);
   gtin_no_                      VARCHAR2(14);
   input_uom_                    VARCHAR2(30);
   input_uom_group_id_           VARCHAR2(30);
   input_qty_                    NUMBER;
   input_conv_factor_            NUMBER;
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
            Get_Filter_Keys___(contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                               lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_,
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                               lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_, 
                               handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
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
      
      
         ELSIF (data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOCATION_NO', 'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 
                                  'ACTIVITY_SEQ', 'AVAILABILITY_CONTROL_ID', 'HANDLING_UNIT_ID', 'SSCC','ALT_HANDLING_UNIT_LABEL_ID')) THEN
      
            IF (data_item_id_ = 'AVAILABILITY_CONTROL_ID') THEN
               set_availability_cont_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                              data_item_id_a_     => 'SET_AVAILABILITY_CONTROL_ID',
                                                                                              data_item_id_b_     => data_item_id_);
      
               IF (set_availability_cont_id_ = Part_Avail_Ctrl_Move_Opt_API.DB_SAME_AS_FROM_LOCATION) THEN
                  -- Note: Get the availability control id at From Location.
                  location_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                    data_item_id_a_     => 'LOCATION_NO',
                                                                                    data_item_id_b_     => data_item_id_);
      
               ELSIF (set_availability_cont_id_ = Part_Avail_Ctrl_Move_Opt_API.DB_SAME_AS_TO_LOCATION) THEN
                  -- Note: Get the availability control id at To Location.
                  location_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                    data_item_id_a_     => 'TO_LOCATION_NO',
                                                                                    data_item_id_b_     => data_item_id_);
      
               ELSE
                  -- Note: User has selected to enter a new availability control id or the set type havent been enter/scanned yet.
                  automatic_value_ := NULL;
                  auto_fetch_ := FALSE;  -- we leave automatic handling with NULL value so PAC ID must be entered/scanned
               END IF;
            END IF;
            IF (auto_fetch_) THEN   
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
               IF (automatic_value_ IS NULL) AND (data_item_id_ = 'AVAILABILITY_CONTROL_ID') THEN
                              
                  automatic_value_ := Warehouse_Bay_Bin_API.Get_Availability_Control_Id(contract_     => contract_,
                                                                                        location_no_  => location_no_);
                  -- Note: availability control id of the selected location (From/To) is null.
                  IF (automatic_value_ IS NULL) THEN
                     automatic_value_ := 'NULL';
                  END IF;                       
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
         ELSIF (data_item_id_= 'TO_CONTRACT') THEN
            IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, 
                                                              session_rec_.capture_config_id, 
                                                              'USE_FROM_SITE_AS_AUTOMATIC_VALUE') = Fnd_Boolean_API.db_true ) THEN
               automatic_value_ := session_rec_.session_contract;   
            END IF;
      
         ELSIF (data_item_id_ = 'DESTINATION_WAIV_DEV_REJ_NO') THEN
            process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
            availability_control_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'AVAILABILITY_CONTROL_ID', session_rec_ , process_package_);
            destination_waiv_dev_rej_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                              data_item_id_a_     => 'WAIV_DEV_REJ_NO',
                                                                                              data_item_id_b_     => data_item_id_);
            IF Part_Exist_With_Diff_Pac___(to_contract_, part_no_, configuration_id_, to_location_no_, lot_batch_no_, serial_no_, 
                                        eng_chg_level_, destination_waiv_dev_rej_no_, activity_seq_, handling_unit_id_, availability_control_id_) THEN
               -- A new destination waiv dev rej no needs to be entered since Part already exist in the same to location with different PAC
               automatic_value_ := NULL;
            ELSE
               automatic_value_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                     data_item_id_a_     => 'WAIV_DEV_REJ_NO',
                                                                                     data_item_id_b_     => data_item_id_);
            END IF;
         ELSIF (data_item_id_ = 'QUANTITY') THEN
            automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, session_rec_.session_contract, part_no_);
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
               IF (input_uom_ IS NOT NULL) AND (input_qty_ IS NOT NULL) THEN
                  input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
                  input_conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_id_, input_uom_);
                  automatic_value_ := input_qty_ * input_conv_factor_;
               ELSE                                                      
                  qty_onhand_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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
                                                                                        column_name_                => 'QTY_ONHAND',
                                                                                        sql_where_expression_       => Get_Sql_Where_Expression___);
            
                  qty_reserved_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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
                                                                                          column_name_                => 'QTY_RESERVED',
                                                                                          sql_where_expression_       => Get_Sql_Where_Expression___);               
                  
                  automatic_value_ :=  Inv_Part_Stock_Reservation_API.Get_Available_Qty_To_Move(contract_,
                                                                                          part_no_,
                                                                                          configuration_id_,
                                                                                          location_no_,
                                                                                          lot_batch_no_,
                                                                                          serial_no_,
                                                                                          eng_chg_level_,
                                                                                          waiv_dev_rej_no_,
                                                                                          activity_seq_,
                                                                                          handling_unit_id_,
                                                                                          qty_onhand_,
                                                                                          qty_reserved_); 
               END IF;
            END IF;
      
         ELSIF (data_item_id_ = 'SET_AVAILABILITY_CONTROL_ID') THEN
            from_pac_id_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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
                                                                                   column_name_                => 'AVAILABILITY_CONTROL_ID',
                                                                                   sql_where_expression_       => Get_Sql_Where_Expression___);
      
            to_pac_id_   := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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
                                                                                   column_name_                => 'AVAILABILITY_CONTROL_ID',
                                                                                   sql_where_expression_       => Get_Sql_Where_Expression___);
      
            -- Use Same as From Location as value for Set PAC ID if both from and to location have NULL for PAC ID
            IF (location_no_ IS NOT NULL AND to_contract_ IS NOT NULL AND to_location_no_ IS NOT NULL AND
                (from_pac_id_ IS NULL AND to_pac_id_ IS NULL)) THEN
               automatic_value_ := Part_Avail_Ctrl_Move_Opt_API.DB_SAME_AS_FROM_LOCATION;
            ELSE
               automatic_value_ := NULL;
            END IF;
      
         ELSIF ((data_item_id_ = 'CATCH_QUANTITY')) THEN
            IF (part_no_ IS NOT NULL) THEN
               IF (Fnd_Boolean_API.Is_True_Db(Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_))) THEN
                  quantity_to_move_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_  => capture_session_id_,
                                                                                         data_item_id_a_      => 'QUANTITY',
                                                                                         data_item_id_b_      => data_item_id_);
                  -- Get qty onhand for stock records that have nothing reserved.
                  qty_onhand_ := Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_,
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
                                                                                        column_name_                => 'QTY_ONHAND',
                                                                                        sql_where_expression_       => Get_Sql_Where_Expression___('NOT_RESERVED'));
                  IF (quantity_to_move_ = qty_onhand_) THEN
                     automatic_value_ := Inventory_Part_In_Stock_API.Get_Catch_Qty_Onhand(contract_         => contract_, 
                                                                                          part_no_          => part_no_, 
                                                                                          configuration_id_ => configuration_id_, 
                                                                                          location_no_      => location_no_, 
                                                                                          lot_batch_no_     => lot_batch_no_, 
                                                                                          serial_no_        => serial_no_, 
                                                                                          eng_chg_level_    => eng_chg_level_, 
                                                                                          waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                                                          activity_seq_     => activity_seq_,
                                                                                          handling_unit_id_ => handling_unit_id_);
                  END IF;
               ELSE
                  -- if part is not catch unit enabled catch_quantity should be null
                  automatic_value_ := 'NULL';
               END IF;
            END IF;
         ELSIF (data_item_id_ = 'CONSUME_CONSIGNMENT') THEN   
            part_ownership_db_ := Inventory_Part_In_Stock_API.Get_Part_Ownership_Db(contract_, 
                                                                                    part_no_, 
                                                                                    configuration_id_, 
                                                                                    location_no_, 
                                                                                    lot_batch_no_, 
                                                                                    serial_no_, 
                                                                                    eng_chg_level_, 
                                                                                    waiv_dev_rej_no_, 
                                                                                    activity_seq_,
                                                                                    handling_unit_id_);
                                                                                 
                                                                                   
            -- Note: If the part ownership is not consignment then the system should pass No without giving the LOV.
            --       If the part ownership is consignment then the system will always ask whether to consume or not and when moving the goods the system  
            --       will raise an error if there is a miss match of part ownerships of source and destination locations.
            IF (part_ownership_db_ != Part_Ownership_API.DB_CONSIGNMENT) THEN
               automatic_value_ :=  Gen_Yes_No_API.Decode(Gen_Yes_No_API.DB_NO);
            ELSE
               automatic_value_ := NULL;
            END IF;
            RETURN automatic_value_;
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
   session_rec_    Data_Capture_Common_Util_API.Session_Rec;
   to_contract_    VARCHAR2(5);
   media_id_       VARCHAR2(18);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'TO_LOCATION_NO' ) THEN   -- since we are checking process specific flags here this code must be outside the generic Data_Capture_Invent_Util_API
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         to_contract_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                       data_item_id_a_     => 'TO_CONTRACT',
                                                                       data_item_id_b_     => data_item_id_);
         IF (to_contract_ IS NULL) THEN 
             IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'USE_FROM_SITE_AS_AUTOMATIC_VALUE') = Fnd_Boolean_API.db_true AND
                 Data_Capt_Conf_Data_Item_API.Get_Use_Automatic_Value_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'TO_CONTRACT') = Data_Capture_Value_Usage_API.DB_FIXED) THEN
                to_contract_ := session_rec_.session_contract;   
             END IF;
         END IF;
         IF (to_contract_ IS NOT NULL) THEN
            media_id_ := Warehouse_Bay_Bin_API.Get_Media_Id(to_contract_, data_item_value_);   
            IF (media_id_ IS NOT NULL) THEN
               Data_Capture_Session_Line_API.Set_Media_Id(capture_session_id_, line_no_, data_item_id_, media_id_);
            END IF;
         END IF;
      -- end of "override"
      ELSE
          Data_Capture_Invent_Util_API.Set_Media_Id_For_Data_Item (capture_session_id_, line_no_, data_item_id_, data_item_value_);
      END IF;
   $ELSE
      NULL;   
   $END
END Set_Media_Id_For_Data_Item ;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_      IN NUMBER,
   latest_data_item_id_     IN VARCHAR2,
   latest_data_item_value_  IN VARCHAR2 )
IS
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_         Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_                     VARCHAR2(5);
   to_contract_                  VARCHAR2(5);
   part_no_                      VARCHAR2(25);
   location_no_                  VARCHAR2(35);
   to_location_no_               VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   configuration_id_             VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   eng_chg_level_                VARCHAR2(6);
   waiv_dev_rej_no_              VARCHAR2(15);
   activity_seq_                 NUMBER;
   barcode_id_                   NUMBER;
   handling_unit_id_             NUMBER; 
   sscc_                         VARCHAR2(18);
   alt_handling_unit_label_id_   VARCHAR2(25);
   gtin_no_                      VARCHAR2(14);
   condition_code_               VARCHAR2(10);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

     -- fetch all necessary keys for all possible detail items below
      session_rec_          := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                         lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_,
                         handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                         capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);
      IF (to_contract_ IS NULL) THEN 
         IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'USE_FROM_SITE_AS_AUTOMATIC_VALUE') = Fnd_Boolean_API.db_true AND
             Data_Capt_Conf_Data_Item_API.Get_Use_Automatic_Value_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'TO_CONTRACT') = Data_Capture_Value_Usage_API.DB_FIXED) THEN
            to_contract_ := contract_;   
         END IF;
      END IF;

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );

      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP

            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('LOCATION_NO', 'PART_NO', 'WAIV_DEV_REJ_NO', 'CONFIGURATION_ID', 
                                                                    'LOT_BATCH_NO', 'SERIAL_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ', 
                                                                    'BARCODE_ID', 'TO_CONTRACT', 'TO_LOCATION_NO', 'HANDLING_UNIT_ID', 
                                                                    'SSCC','ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN

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
                                           to_contract_                => to_contract_,
                                           to_location_no_             => to_location_no_,
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
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID', 'LOCATION_NO_DESC',
                                                                    'RECEIPTS_BLOCKED', 'MIX_OF_PART_NUMBER_BLOCKED', 'MIX_OF_CONDITION_CODES_BLOCKED', 
                                                                    'MIX_OF_LOT_BATCH_NO_BLOCKED', 'LOCATION_GROUP', 'LOCATION_TYPE')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);
               
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TO_WAREHOUSE_ID', 'TO_BAY_ID', 'TO_TIER_ID', 'TO_ROW_ID','TO_BIN_ID',
                                                                       'TO_RECEIPTS_BLOCKED', 'TO_MIX_OF_PART_NUMBER_BLOCKED', 'TO_MIX_OF_CONDITION_CODES_BLOCKED',
                                                                       'TO_MIX_OF_LOT_BATCH_NO_BLOCKED', 'TO_LOCATION_GROUP', 'TO_LOCATION_TYPE', 'TO_LOCATION_NO_DESC')) THEN

                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => to_contract_, 
                                                                           location_no_         => to_location_no_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 
                                                                       'UNIT_MEAS_DESCRIPTION', 'NET_WEIGHT', 'NET_VOLUME', 'PART_TYPE', 'PRIME_COMMODITY', 
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
                                                                       'EXPIRATION_DATE', 'AVAILABILTY_CONTROL_ID', 'AVAILABILITY_CONTROL_DESCRIPTION')) THEN

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

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CONTRACT_DESCRIPTION')) THEN

                  Data_Capture_Invent_Util_API.Add_Contract_Description(capture_session_id_   => capture_session_id_,
                                                                        owning_data_item_id_  => latest_data_item_id_,
                                                                        data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                        contract_             => contract_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TO_CONTRACT_DESCRIPTION')) THEN

                  Data_Capture_Invent_Util_API.Add_Contract_Description(capture_session_id_   => capture_session_id_,
                                                                        owning_data_item_id_  => latest_data_item_id_,
                                                                        data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                        contract_             => to_contract_);

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
               ELSIF(conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE', 'CONDITION_CODE_DESCRIPTION')) THEN
                  condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_, serial_no_, lot_batch_no_); 
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
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;   
   $END
END Add_Details_For_Latest_Item;


PROCEDURE Post_Process_Action(
   process_message_     IN OUT NOCOPY CLOB,
   capture_session_id_  IN NUMBER,
   contract_            IN VARCHAR2 )
IS
   inventory_event_id_ NUMBER;
   number_null_        NUMBER;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      inventory_event_id_ := Message_SYS.Find_Attribute(process_message_, 'INVENTORY_EVENT_ID', number_null_);
   END IF;
   IF (inventory_event_id_ IS NOT NULL) THEN
      Inventory_Event_Manager_API.Finish(inventory_event_id_);
   END IF;
END Post_Process_Action;


PROCEDURE Execute_Process (
   process_message_    IN OUT NOCOPY CLOB,
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2,
   attr_               IN VARCHAR2,
   blob_ref_attr_      IN VARCHAR2 )
IS
   ptr_                          NUMBER;
   name_                         VARCHAR2(50);
   value_                        VARCHAR2(4000);
   to_contract_                  VARCHAR2(5);
   from_location_no_             VARCHAR2(35);
   to_location_no_               VARCHAR2(35);
   destination_                  VARCHAR2(200);
   part_no_                      VARCHAR2(25);
   quantity_to_move_             NUMBER;
   quantity_reserved_            NUMBER;
   serial_no_                    VARCHAR2(50) := '*';
   configuration_id_             VARCHAR2(50) := '*';
   lot_batch_no_                 VARCHAR2(20) := '*';
   eng_chg_level_                VARCHAR2(6) := '1';
   waiv_dev_rej_no_              VARCHAR2(15) := '*';
   expiration_date_              DATE;
   activity_seq_                 NUMBER := 0;
   catch_quantity_to_move_       NUMBER;
   availability_control_id_      VARCHAR2(25);
   destination_waiv_dev_rej_no_  VARCHAR2(15);
   inventory_event_id_           NUMBER;
   handling_unit_id_             NUMBER; 
   consume_consignment_          VARCHAR2(1);
   unattached_from_handling_unit_ VARCHAR2(5);
   note_                         VARCHAR2(200);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LOCATION_NO') THEN
         from_location_no_ := value_;
      ELSIF (name_ = 'TO_CONTRACT') THEN
         to_contract_ := value_;
      ELSIF (name_ = 'TO_LOCATION_NO') THEN
         to_location_no_ := value_;
      ELSIF (name_ = 'PART_NO') THEN
         part_no_ := value_;
      ELSIF (name_ = 'QUANTITY') THEN
         quantity_to_move_ := value_;
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
         catch_quantity_to_move_ := value_;
      ELSIF (name_ = 'DESTINATION') THEN
         destination_ := value_;
      ELSIF (name_ = 'AVAILABILITY_CONTROL_ID') THEN
         availability_control_id_ := value_;
      ELSIF (name_ = 'DESTINATION_WAIV_DEV_REJ_NO') THEN
         destination_waiv_dev_rej_no_ := value_;
      ELSIF (name_ = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := value_;
      ELSIF (name_ = 'CONSUME_CONSIGNMENT') THEN
         consume_consignment_ := Gen_Yes_No_API.Encode(value_);
      ELSIF (name_ = 'NOTE') THEN
         note_ := value_;
      END IF;
   END LOOP;
   expiration_date_ := Inventory_Part_In_Stock_API.Get_Expiration_Date(to_contract_,
                                                                       part_no_,
                                                                       configuration_id_,
                                                                       to_location_no_,
                                                                       lot_batch_no_,
                                                                       serial_no_,
                                                                       eng_chg_level_,
                                                                       destination_waiv_dev_rej_no_,
                                                                       activity_seq_,
                                                                       handling_unit_id_); 


   TRACE_SYS.Message('*** Inventory_Part_In_Stock_API.Move_Part with following parameters ***');
   TRACE_SYS.Message('=======================================================================');
   TRACE_SYS.Field('from contract_ ', contract_);
   TRACE_SYS.Field('from_location_no_ ', from_location_no_);
   TRACE_SYS.Field('part_no_ ', part_no_);
   TRACE_SYS.Field('configuration_id_ ', configuration_id_);
   TRACE_SYS.Field('destination_ ', destination_);
   TRACE_SYS.Field('to_contract_ ', to_contract_);
   TRACE_SYS.Field('to_location_no_ ', to_location_no_);
   TRACE_SYS.Field('lot_batch_no_ ', lot_batch_no_);
   TRACE_SYS.Field('serial_no_ ', serial_no_);
   TRACE_SYS.Field('eng_chg_level_ ', eng_chg_level_);
   TRACE_SYS.Field('waiv_dev_rej_no_ ', waiv_dev_rej_no_);
   TRACE_SYS.Field('activity_seq_ ', activity_seq_);
   TRACE_SYS.Field('handling_unit_id_ ', handling_unit_id_);
   TRACE_SYS.Field('quantity_to_move_ ', quantity_to_move_);
   TRACE_SYS.Field('catch_quantity_to_move_ ', catch_quantity_to_move_);
   TRACE_SYS.Message('=======================================================================');
   
   IF Part_Exist_With_Diff_Pac___(to_contract_, part_no_, configuration_id_, to_location_no_, lot_batch_no_, serial_no_, 
                               eng_chg_level_, destination_waiv_dev_rej_no_, activity_seq_, handling_unit_id_, availability_control_id_) THEN
      Error_SYS.Record_General(lu_name_,'NEEDNEWWDRNO: Must enter a new value for destination W/D/R No. Part already exists in the same location with different Availability Control Id.');
   END IF;
   
   inventory_event_id_ := Get_inventory_event_Id___(process_message_);
   Inventory_Event_Manager_API.Set_Session_Id(inventory_event_id_);
 
   Invent_Part_Quantity_Util_API.Move_Part(unattached_from_handling_unit_ => unattached_from_handling_unit_,
                                           catch_quantity_                => catch_quantity_to_move_,
                                           contract_                      => contract_,
                                           part_no_                       => part_no_,
                                           configuration_id_              => configuration_id_,
                                           location_no_                   => from_location_no_,
                                           lot_batch_no_                  => lot_batch_no_,
                                           serial_no_                     => serial_no_,
                                           eng_chg_level_                 => eng_chg_level_,
                                           waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                           activity_seq_                  => activity_seq_,
                                           handling_unit_id_              => handling_unit_id_, 
                                           expiration_date_               => expiration_date_,
                                           to_contract_                   => to_contract_,
                                           to_location_no_                => to_location_no_,
                                           to_destination_                => Inventory_Part_Destination_API.Decode(destination_),
                                           quantity_                      => quantity_to_move_,
                                           quantity_reserved_             => quantity_reserved_,
                                           move_comment_                  => note_,
                                           consume_consignment_stock_     => consume_consignment_, 
                                           to_waiv_dev_rej_no_            => destination_waiv_dev_rej_no_,
                                           transport_task_id_             => NULL,
                                           validate_hu_struct_position_   => TRUE,
                                           move_part_shipment_            => FALSE,
                                           reserved_stock_rec_            => NULL,
                                           availability_ctrl_id_          => availability_control_id_); 
     
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Invent_Part_Quantity_Util_API.Move_Part is granted thru following projection/action
   IF (Security_SYS.Is_Proj_Action_Available('MoveInventoryPart', 'CreateInventoryPartInStockDelivery') ) THEN
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
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   process_package_             VARCHAR2(30);
   part_no_                     VARCHAR2(25);
   barcode_id_                  NUMBER;
   contract_                    VARCHAR2(5);
   to_contract_                 VARCHAR2(5);
   location_no_                 VARCHAR2(35);
   to_location_no_              VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   configuration_id_            VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   eng_chg_level_               VARCHAR2(6);
   waiv_dev_rej_no_             VARCHAR2(15);
   activity_seq_                NUMBER;
   handling_unit_id_            NUMBER;
   sscc_                        VARCHAR2(18);
   alt_handling_unit_label_id_  VARCHAR2(25);
   gtin_no_                     VARCHAR2(14);
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
      -- if predicted part_no_ is null then try fetch it with unique handling
      IF (part_no_ IS NULL) THEN
         Get_Filter_Keys___(contract_, to_contract_, part_no_, location_no_, to_location_no_, configuration_id_, 
                            lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, barcode_id_, 
                            handling_unit_id_, sscc_, alt_handling_unit_label_id_, gtin_no_,
                            capture_session_id_, data_item_id_, use_applicable_ => FALSE);
         part_no_ := Get_Unique_Data_Item_Value___(contract_, part_no_, location_no_, configuration_id_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, alt_handling_unit_label_id_, barcode_id_, 'PART_NO');
      END IF; 
      IF (serial_no_ IS NULL) AND (data_item_id_ = 'QUANTITY') THEN
         serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
      END IF;      
   $END

   RETURN Data_Capture_Invent_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, data_item_id_, part_no_, serial_no_);
END Fixed_Value_Is_Applicable;

