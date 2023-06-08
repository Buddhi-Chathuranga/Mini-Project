-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptReportPickPart
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: REPORT_PICKING_PART
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211001  DaZase  Bug 161106 (SCZ-16419), Change in Get_Pick_By_Choice_Whr_Expr___ to also support project connection when its Project Deliverables.
--  210917  DaZase  Bug 160934 (SCZ-16284), Change in Execute_Process() to stop PBC picking from running if it isnt a PBC picking.
--  210908  DaZase  Bug 160848 (SCZ-16179), Change in Get_Pick_By_Choice_Whr_Expr___ to also support project connection when its Purch Order Transit.
--  210630  Moinlk  Bug 159537 (SCZ-14965), Modified Add_Details_For_Latest_Item() to fetch part_no & part_description via reservation record 
--  210630          where PICK_BY_CHOICE_DETAILS is enabled.
--  201016  Dazase  Bug 155633 (SCZ-11511), Changes in Add_Details_For_Latest_Item to use new detail PICK_BY_CHOICE_DETAILS to control when unique filter keys should be fetched.
--  200918  DiJwlk  SC2020R1-10033, Modified Add_Details_For_Latest_Item() to make res_alt_handl_unit_label_id_ and res_sscc_ null if they are not scanned yet, and fetched after.
--  200827  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  200319  BudKlk  Bug 145218(SCZ-2117), Modified the method Create_List_Of_Values() to send the customer_no_ as a parameter to the Temporary_Part_Tracking_API.Create_Data_Capture_Lov() to filer Customer Owned parts from the customer no.
--  200313  DaZase  Bug 152865 (SCZ-9286), Modified Modified Create_List_Of_Values() to make sure that when its pick by choice we still use lov_id 2 when we come from start_picking process.
--  191219  SWiclk  Bug 151218(SCZ-7901), Modified Create_List_Of_Values() in order passed data_item_id_ when calling Inventory_Part_In_Stock_API.Create_Data_Capture_Lov(). 
--  191002  SURBLK  Added Raise_Shipment_Location_Error___ to handle error messages and avoid code duplication.
--  180313  ChBnlk  Bug 147339, Modified Get_Pick_By_Choice_Whr_Expr___() by adding a new parameter to get the wanted_data_item_ and modified the condition added from Bug 144977 
--  180313          to filter from the project_id_ only when the data item is ACTIVITY_SEQ and the supply code is project inventory.
--  181029  ChBnlk  Bug 144977, Modified Get_Pick_By_Choice_Whr_Expr___() by adding a condition to filter from the project id in the where clause.
--  180719  BudKlk  Bug 142134, Modified Add_Details_For_Latest_Item() in order to add a new feedback item  RECEIVER_ADDRESS_NAME.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory.
--  180117  MaAuse  STRSC-15740, Modified Construct_Process_ by moving logic to new method Get_Shipment_Id_Message___. Modified Execute_Process by adding
--  180117          call to Construct_Process_Message___ and Update_Shipment_Id_Message___ and check max weight and volume only if packed. Modified
--  180117          Post_Process_Action to use process_message_.
--  171219  MaAuse  STRSC-15289, Added condition to verify if Pick by Choice is set in Validate_Data_Item. 
--  171218  MaAuse  STRSC-15088, Modified Execute_Process by adding call to Handling_Unit_API.Check_Max_Capacity_Exceeded and adding parameter
--  171218          trigger_shipment_flow_ in call to Pick_Customer_Order_API.Pick_Reservations__ and Inventory_Picking_Manager_API.Pick_By_Choice.
--  171218          Added new methods Construct_Process_Message___ and Post_Process_Action to be able to trigger shipment flow at the end of Execute_Process.
--  171129  CKumlk  STRSC-14828, Added GTIN to Add_Filter_Key_Detail___.
--  171128  RoJalk  STRSC-9103, Added shipment_id_message_ to the method Pick_Customer_Order_API.Pick_Reservations__.
--  171115  DaZase  STRSC-8865, Added extra Invpart Barcode and GTIN/part validation against the current Report Picking Line record in Validate_Data_Item. 
--  171107  JeLise  STRSC-13871, Added checks against reserve_rec_ when pick_by_choice_blocked = 'TRUE' in Validate_Data_Item and added method
--  171107          Raise_Pick_Choice_Not_Allowed___.
--  170915  DaZase  STRSC-11606, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  170915          of anything found later in that method. Changed size to 4000 on value_ in Execute_Process and detail_value_ in Add_Unique_Data_Item_Detail___.
--  170904  SURBLK  STRSC-11287, Implemented GTIN support, hence handled GTIN, INPUT_UOM and INPUT_QUANTITY data items 
--  170904          and INPUT_CONV_FACTOR as feedback item and GTIN_IS_MANDATORY as detail item.
--  170605  KHVESE  LIM-11507, Modified methods Get_Automatic_Data_Item_Value for RELEASE_RESERVATION and Add_Details_For_Latest_Item for LAST_LINE_ON_PICK_LIST.
--  170531  KHVESE  STRSC-8748, Modified method Execute_Process to do extra validation for shp_handling_unit_id_ when the order line has pre-attached reservation in shipment.
--  170531  KHVESE  STRSC-8748, Modified method Validate_Data_Item to do extra validation for shp_handling_unit_id_ and ship_location_no_ which validates ship hu location against shipment location.
--  170531          Modified Get_Filter_Keys___  to fetch res/shp_handling_unit_id_ from res/shp_alt_handl_unit_label_id_ correctly.
--  170530  DaZase  LIM-11320, Simplified ship_location_no checks by only checking the pick list now instead of the order or shipment due to changes in pick list.
--  170526  RoJalk  STRSC-7311, Modified Execute_Process and remove teh code adding ship_location_no_ to pickattr_.
--  170523  KHVESE  STRSC-8590, Modified methods Validate_Data_Item() and Fixed_Value_Is_Applicable() to validate shipment handling unit id, sscc and alt handling unit id when part is component part.
--  170523          Modified method Fixed_Value_Is_Applicable() to increase performance.    
--  170516  RuLiLk  Bug 134821, Modified Execute_Process() by passing sales quantity to Shipment_Line_Handl_Unit_API.Check_Quantity().
--  170510  KhVese  STRSC-8203, Modified method Create_List_Of_Values and Validate_Data_Item to fetch part_no using unique_line_id_ when part no is null and pick by choice is allowed.
--  170418  DaZase  LIM-10662, Changes in Get_Filter_Keys___ on how Bug 132004 was solved, now we check if inventory barcode is enabled correctly. 
--  170331  RuLiLk  Bug 134821, Modified Execute_Process() by passing sales quantity to Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing().
--  170329  DaZase  LIM-10352, Renamed DataCaptPickCustOrder to DataCaptReportPickPart.
--  170329  KhVese  LIM-11321, Modified method Validate_Data_Item to validate serialn_no against Inventory Part In Stock when pick by choice is enabled and barcode is not entered.
--  170323  KhVese  LIM-10485, Modified method Execute_Process to handle pack to shipment.
--  170308  Jhalse  LIM-10113: Removed reference to Shipment_Type_API.Pick_Inventory_Type_Db because Shipment Inventory is now mandatory for Shipment, occurences marked with LIM-10113 
--  170303  SWiclk  Bug 134403, Modified Get_Filter_Keys___() in order to fetch predicted value for barcode_id regardless whether the barcode_id usage is mandatory or not.
--  170213  KhVese  LIM-10625, Modified method Get_Pick_By_Choice_Whr_Expr___ to include initial reservation.
--  170207  KhVese  LIM-10482, Modified method Validate_Data_Item___ to validate catch qty on qty picked data item.
--  170131  KhVese  LIM-9880, Modified methods Execute_Process, Add_Details_For_Latest_Item, Validate_Data_Item___
--  170124  KhVese  LIM-9880, Modified methods Get_Unique_Data_Item_Value___, Get_Filter_Keys___, Validate_Data_Item, Create_List_Of_Values, Get_Automatic_Data_Item_Value,
--  170124          Fixed_Value_Is_Applicable, and added method Get_Pick_By_Choice_Whr_Expr___.
--  170113  DaZase  LIM-8660, Adapted catch quantity validation in Validate_Data_Item___ to new interface.  
--  161128  MaIklk  LIM-9749, Fixed the usages of renaming columns in Shipment_Reserv_Handl_Unit_Tab.
--  161108  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() in order to Default Qty = 1 for Serial handled parts when applicable.
--  161108  Erlise  LIM-2933, Modified Create_List_Of_Values(), Get_Automatic_Data_Item_Value(), Validate_Data_Item().
--  161010  SWiclk  Bug 132004, Modified Get_Filter_Keys___() in order to check whether Barcode Id is mandatory or not before trying to fetch a unique value.
--  160930  SWiclk  Bug 131288, Modified Get_Handling_Unit_Filters___(), Create_List_Of_Values(), Get_Automatic_Data_Item_Value() and Validate_Data_Item()
--  160930          in order to handle 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID' separately from Handling_Unit_API.
--  160914  DaZase  Changes in Fixed_Value_Is_Applicable/Execute_Process/Validate_Data_Item to also call 
--  160914          Customer_Order_Pick_List_API.Uses_Shipment_Inventory to make sure if shipment inventory is used or not for validations on SHIP_LOCATION_NO
--  160909  DaZase  LIM-8336, Adapted process to new and renamed handling unit items, added handling of new feedback items.
--  160725  RoJalk  LIM-8142, Replaced Shipment_Line_API.Connected_Lines_Exist with Shipment_API.Connected_Lines_Exist.
--  160629  SWiclk  Bug 130209, Modified Validate_Data_Item(), Create_List_Of_Values() and Execute_Process() in order to handle 
--  160629          serials which have been already identified for a part which is not serial tracked in inventory.
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160427  RoJalk  LIM-7267, Changed the parameter order of Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing.
--  160219  SWiclk  Bug 127172, Modified Validate_Data_Item() in order to check Barcode_ID is mandatory if configured in process detail.
--  160212  RoJalk  LIM-5934, Removed order info parameters from Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing.
--  151124  SWiclk  STRSC-306, Modified Add_Details_For_Latest_Item() in order to handle SHIP_LOCATION_NO_DESC separately.
--  151106  MaEelk  LIM-4453, Rempved pallet_id from the logic.
--  151027  Erlise  LIM-3779, Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID.
--  151027  DaZase  LIM-4297, Changed calls to Add_Details_For_Hand_Unit_Type and Add_Details_For_Handling_Unit 
--  151027          so they now call Data_Capture_Invent_Util_API instead of Data_Capture_Order_Util_API.                  
--  151026  DaZase  LIM-4297, Renamed method call Get_Handling_Unit_From_Atl_Id to Get_Handling_Unit_From_Alt_Id.
--  151006  MaEelk  LIM-3579, Replaced the usage of Handling_Unit_API.Get_Top_Shipment_Id with Handling_Unit_API.Get_Shipment_Id
--  150908  DaZase  AFT-3835, Changed the ship location no checks in Execute_Process, now shipment and order checks are handled separately.
--  150908  RILASE  AFT-3183, Updated Fixed_Value_Is_Applicable support where shipment connection exist but no handling units has been defined.
--  150803  SWiclk  Bug 121254, Modified Get_Unique_Data_Item_Value___(), Validate_Data_Item() and Create_List_Of_Values() by changing the parameter list 
--  150803          of methods which are from Inventory_Part_Barcode_API since the contract has been changed as a parentkey.
--  150820  RiLase  COB-28, Added Looping_Is_Allowed to prevent looping on serial no when part is not receipt and issue serial tracked
--  150824  DaZase  AFT-1633, Added handling of LAST_LINE_ON_PICK_LIST in Add_Details_For_Latest_Item so it will also check release reservation and if last line was partially picked. 
--  150820          but not tracked in inventory.
--  150807  DaZase  COB-607, Reworked some of the unique methods so data items that are not using the filter keys 
--  150807          are handled before calling Get_Filter_Keys___, to help performance a bit. 
--  150608  RILASE  COB-424, Added Consume_Unique_Line_Id and Get_Qty_Picked_And_Reserv___. Added when applicable functionallity for SHIP_LOCATION_NO.
--  150519  RILASE  COB-28, Added support for pick into handling units.
--  150227  RILASE  Added Fixed_Value_Is_Applicable support for SHIPMENT_ID.
--  150504  JeLise  LIM-1893, Added handling_unit_id_ in LU calls where applicable.
--  150203  JeLise  PRSC-5841, Added call to Customer_Order_Reservation_API.Get_Qty_Left_To_Pick to set the last_line_on_pick_list_ 
--  150203          correctly in Add_Details_For_Latest_Item.
--  141209  DaZase  Moved out ship_location_no code (from Bug 119477) from Get_Automatic_Data_Item_Value to new method Get_Ship_Location_No___ and 
--  141209          used it from Get_Automatic_Data_Item_Value and Add_Unique_Data_Item_Detail___ to reduce the number of unique calls when its a detail to half.
--  141201  DaZase  PRSC-4409, Added Subseq_Session_Start_Allowed.
--  141106  DaZase  PRSC-4009, Changed Fixed_Value_Is_Applicable so it now fetches predicted and unique part_no.
--  141105  ChBnlk  Bug 119558, Modified Add_Lines_For_Latest_Data_Item() by adding CONDITION_CODE and CONDITION_CODE_DESCRIPTION as
--  141105          feedback items.
--  141103  SWiclk  Bug 119477, Modified Get_Automatic_Data_Item_Value() in order to get the shipment_id_ if it is unique when the data item is 'SHIP_LOCATION_NO'.  
--  141031  SWiclk  Bug 119477, Modified Add_Unique_Data_Item_Detail___() in order to add SHIP_LOCATION_NO data item as a feedback item.
--  141023  DaZase  PRSC-3317, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___. Removed Pack_Filter_Keys___, 
--  141023          Unpack_Filter_Keys___, Get_Fixed_Value___, Add_Line_Using_Unique___. Added Get_Unique_Data_Item_Value___, Add_Filter_Key_Detail___, Add_Unique_Data_Item_Detail___.
--  141009  DaZase  PRSC-63, Changed Get_Automatic_Data_Item_Value, Create_List_Of_Values and Validate_Data_Item to now use methods in Inventory_Part_Barcode_API for BARCODE_ID.
--  141003  RiLase  PRSC-2497, Added Fixed_Value_Is_Applicable().
--  140926  JeLise  PRSC-2366, Added call to Customer_Order_Reservation_API.Get_Number_Of_Lines_To_Pick to fetch the value for 
--  140926          LAST_LINE_ON_PICK_LIST in Add_Details_For_Latest_Item.
--  140908  RiLase  Removed empty methods since the wadaco framework now can handle when methods doesn't exist.
--  140905  JeLise  PRSC-2366, Added fetch of warehouse_task_id when data_item_id is PICK_LIST_NO in Get_Automatic_Data_Item_Value.
--  140827  DaZase  PRSC-1655, Added Validate_Config_Data_Item.
--  140815  Dazase  PRSC-1611, Removed Apply_Additional_Line_Content since it is now obsolete and Get_Automatic_Data_Item_Value can be used instead. 
--  140812  DaZase  PRSC-1611, Renamed Add_Lines_For_Latest_Data_Item to Add_Details_For_Latest_Item.
--  140811  DaZase  PRSC-1611, Changed calls Pick_Customer_Order_API.Check_Valid_Value to Pick_Customer_Order_API.Record_With_Column_Value_Exist.
--  140806  DaZase  PRSC-1431, Changed part_no_ to VARCHAR2(25).
--  140620  SWiclk  PRSC-1861, Bug 117179, Modified Get_Process_Execution_Message() and Execute_Process() by adding parameter process_message_
--  140620          and parameters process_message_ and blob_ref_attr_ respectively.
--  140519  DaZase  PBSC-9203, Changed all Create_Pick_List_API-calls to Pick_Customer_Order_API instead since those methods and their datasource have been moved now.
--  140513  DaZase  PBSC-9232, Change in Validate_Data_Item so SHIP_LOCATION_NO is only validated if its not NULL, 
--  140513          since framework is changed so validations always happens also for automatic fetced values.
--  140513  DaZase  PBSC-8663, Changes in Get_Automatic_Data_Item_Value how SHIP_LOCATION_NO gets its automatic values, depending on the 
--  140513          different Pick_Inventory_Type flags and where its fetched from, now either from shipment or a unique shipment location.
--  140320  DaZase  Added SHIPMENT_ID as a new data item/filter key. Also added LAST_LINE in pick attribute string in Execute_Process.
--  140102  SWiclk  Bug 114546, Modified Get_Automatic_Data_Item_Value() by replacing dummy_tab_ with filter_keys_tab_. 
--  140102          Fetched all possible keys in order to fetch qty_picked correctly.
--  131231  SWiclk  Bug 114546, Modified Apply_Additional_Line_Content() by reversing the correction done in bug 113200 in order to stop showing 
--  131231          a value for qty_picked and modified Get_Automatic_Data_Item_Value() in order to fetch qty_picked when use automatic is checked.                                                                                        
--  131120  RuLiLk  Bug 113200, Added method Validate_Data_Item___ to validate overpicking. When Overpicking is not allowed error is raised. 
--  131120          Modified methods Validate_Data_Item and Execute_Process.
--  131120          Modified method Apply_Additional_Line_Content. Reserved quantity is fetched as default value to avoid null quantity pick. 
--  131107  DaZase  Bug 113189, changes in Create_List_Of_Values so call to Temporary_Part_Tracking_API.Create_Data_Capture_Lov 
--  131107          now uses new parameter interface.
--  130923  MaEelk  Passed '*' as source_ref_6_ to the the call Identify_Serial_On_Reservation in Execute_Process to support Billabong changes in shipment_id.
--  130923          If shipment_id is introduced in future, relevant value should be passed instead of '*'. 
--  130124  RiLase  Added UNIQUE_LINE_ID handling and methods Add_Lines_For_Uniq_Line_Id___ and Add_Unique_Line_Id_Detail___.
--  121004  JeLise  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
string_all_values_  CONSTANT VARCHAR2(1) := '%';
string_null_values_ CONSTANT VARCHAR2(4) := 'NULL';
number_all_values_  CONSTANT NUMBER := -1;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Pick_By_Choice_Whr_Expr___ ( 
   capture_session_id_    IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   unique_line_id_        IN VARCHAR2,
   pick_by_choice_option_ IN VARCHAR2,
   wanted_data_item_      IN VARCHAR2) RETURN VARCHAR2
IS
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
   reserve_rec_        Customer_Order_Reservation_API.Public_Rec;
   source_ref_type_db_ VARCHAR2(20) := '1';
   return_value_       VARCHAR2(2000);
   order_key_values_   VARCHAR2(100);
   project_id_         VARCHAR2(10);   
   supply_code_db_     VARCHAR2(3);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- If site setting for pick by choice is not allowed for reserved or pick listed stock record we will call method Pick_By_Choice_Allowed
      -- with pick list line keys to include currect pick list line(s) to the list of value or validate them. Pick_By_Choice_Allowed when site
      -- setting option is allowed or not printed pick list will always return true for current pick list line so no need to send pick list line info.
      IF (pick_by_choice_option_ IN (Reservat_Adjustment_Option_API.DB_NOT_PICK_LISTED, Reservat_Adjustment_Option_API.DB_NOT_RESERVED) AND 
          unique_line_id_ IS NOT NULL) THEN 
         reserve_rec_ := Customer_Order_Reservation_API.Get_Object_By_Id(unique_line_id_);
      END IF;
      project_id_ := Customer_Order_Line_API.Get_Project_Id(order_no_, line_no_, rel_no_, line_item_no_);
      supply_code_db_ := Customer_Order_Line_API.Get_Supply_Code_Db(order_no_, line_no_, rel_no_, line_item_no_);
      -- if pick list number is not null and source ref data are null, all pick list lines in the current pick list will be showen in the list 
      -- of value and will pass validation. 
      return_value_ := ' AND  qty_onhand > 0 
                         AND  location_type_db = ''PICKING''                         
                         AND  (Inventory_Picking_Manager_API.Pick_By_Choice_Allowed( ''' || pick_list_no_ || ''', ';
      
      IF order_no_ IS NOT NULL THEN 
         return_value_ := return_value_ || '''' || order_no_ || ''', ';  
      ELSE 
         return_value_ := return_value_ || 'NULL, ';  
      END IF;

      IF line_no_ IS NOT NULL THEN 
         return_value_ := return_value_ || '''' || line_no_ || ''', ';  
      ELSE 
         return_value_ := return_value_ || 'NULL, ';  
      END IF;

      IF rel_no_ IS NOT NULL THEN 
         return_value_ := return_value_ || '''' || rel_no_ || ''', ';  
      ELSE 
         return_value_ := return_value_ || 'NULL, ';  
      END IF;

      IF line_item_no_ IS NOT NULL THEN 
         return_value_ := return_value_ || '''' || line_item_no_ || ''', ';  
      ELSE 
         return_value_ := return_value_ || 'NULL, ';  
      END IF;

      return_value_ := return_value_ || '''' || source_ref_type_db_ || ''', ';  
      
      IF reserve_rec_.location_no IS NULL THEN 
         Trace_SYS.message('reserve_rec_ reserve_rec_ IS NULL');
         return_value_ := return_value_ || ' NULL, NULL, NULL, NULL, NULL, NULL, NULL, ';
      ELSE
         Trace_SYS.message('reserve_rec_ reserve_rec_ IS not NULL');
         return_value_ := return_value_ || '''' || reserve_rec_.location_no      || ''', ''' ||
                                                   reserve_rec_.lot_batch_no     || ''', ''' ||
                                                   reserve_rec_.serial_no        || ''', ''' ||
                                                   reserve_rec_.eng_chg_level    || ''', ''' ||
                                                   reserve_rec_.waiv_dev_rej_no  || ''', '   ||
                                                   reserve_rec_.activity_seq     || ', '     ||
                                                   reserve_rec_.handling_unit_id || ', ' ;
      END IF;
      return_value_ := return_value_ || ' CONTRACT, PART_NO, CONFIGURATION_ID, LOCATION_NO, LOT_BATCH_NO, SERIAL_NO, ENG_CHG_LEVEL, 
                                          WAIV_DEV_REJ_NO, ACTIVITY_SEQ, HANDLING_UNIT_ID) = ''TRUE'')';
      IF (wanted_data_item_ = 'ACTIVITY_SEQ') THEN
         IF ((project_id_ IS NOT NULL) AND (supply_code_db_ IN ('PI', 'PT', 'PJD')) )THEN
            return_value_ := return_value_ || 'AND PROJECT_ID = ''' || project_id_ || '''';
         ELSE
            return_value_ := return_value_ || 'AND PROJECT_ID IS NULL';
         END IF;
      END IF;
   $END
   RETURN return_value_;
END Get_Pick_By_Choice_Whr_Expr___;


PROCEDURE Validate_Data_Item___ (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2,
   part_no_            IN VARCHAR2 )       
IS
   qty_picked_                NUMBER;
   catch_qty_picked_          NUMBER;
   mandatory_non_process_key_ BOOLEAN := FALSE;
   session_rec_               Data_Capture_Common_Util_API.Session_Rec;
   process_package_           VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- NOTE: Add mandatory, non-process keys, data items to this selection to use generic null check
      IF (data_item_id_ IN ('QTY_PICKED')) THEN
         mandatory_non_process_key_ := TRUE;
      END IF;
      Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_);
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      CASE (data_item_id_)
         WHEN ('PART_NO') THEN
            catch_qty_picked_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_PICKED', session_rec_ , process_package_);
            qty_picked_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'QTY_PICKED', session_rec_ , process_package_);
         WHEN ('QTY_PICKED') THEN
            catch_qty_picked_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CATCH_QTY_PICKED', session_rec_ , process_package_);
            qty_picked_  := data_item_value_;
         WHEN ('CATCH_QTY_PICKED') THEN
            catch_qty_picked_ := data_item_value_;
            qty_picked_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'QTY_PICKED', session_rec_ , process_package_);
         ELSE
            NULL;
      END CASE;

   $END

   IF (data_item_id_ IN ('PART_NO','QTY_PICKED') AND 
       (qty_picked_ IS NOT NULL AND part_no_ IS NOT NULL) AND 
       Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
       qty_picked_ NOT IN (0,1)) THEN
      Error_SYS.Record_General(lu_name_,'SERIALPARTQTYWRONG: A serial handled Part can only have Quantity Picked value of 1 or 0.');
   END IF;

   IF (data_item_id_ IN ('PART_NO','CATCH_QTY_PICKED','QTY_PICKED')) THEN
      IF qty_picked_ > 0 THEN 
         Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                      current_data_item_id_      => data_item_id_,
                                                      part_no_data_item_id_      => 'PART_NO',
                                                      part_no_data_item_value_   => part_no_,
                                                      catch_qty_data_item_id_    => 'CATCH_QTY_PICKED',
                                                      catch_qty_data_item_value_ => catch_qty_picked_,
                                                      positive_catch_qty_        => TRUE);  
      ELSE
         Data_Capture_Invent_Util_API.Check_Catch_Qty(capture_session_id_        => capture_session_id_,        
                                                      current_data_item_id_      => data_item_id_,
                                                      part_no_data_item_id_      => 'PART_NO',
                                                      part_no_data_item_value_   => part_no_,
                                                      catch_qty_data_item_id_    => 'CATCH_QTY_PICKED',
                                                      catch_qty_data_item_value_ => catch_qty_picked_,
                                                      catch_zero_qty_allowed_    => TRUE);  -- Since this process allow 0 picking
      END IF;
   END IF;

END Validate_Data_Item___;


FUNCTION Get_Ship_Location_No___ (
   shipment_id_  IN NUMBER,
   contract_     IN VARCHAR2,
   pick_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   shipment_rec_                Shipment_API.Public_Rec;
   return_value_                VARCHAR2(200);
   uses_shipment_inventory_     NUMBER;
BEGIN
   IF (nvl(shipment_id_,0) != 0) THEN
      shipment_rec_ := Shipment_API.Get(shipment_id_);
   END IF;
   
   IF (pick_list_no_ IS NOT NULL) THEN
      uses_shipment_inventory_ := Handle_Ship_Invent_Utility_API.Uses_Shipment_Inventory(pick_list_no_   => pick_list_no_, 
                                                                                         pick_list_type_ => 'CUST_ORDER_PICK_LIST'); 
   END IF;

   IF (uses_shipment_inventory_ = 0) THEN
      return_value_ := 'NULL';
   ELSIF (uses_shipment_inventory_ = 1) THEN   -- use shipment inventory 
      IF (shipment_rec_.ship_inventory_location_no IS NOT NULL) THEN
         -- use ship_inventory_location_no from shipment
         return_value_ := shipment_rec_.ship_inventory_location_no;
      ELSE
         -- if there is only 1 unique shipment location return it
         return_value_ := Inventory_Location_API.Get_Location_No_If_Unique(contract_ => contract_,
                                                                           lov_id_   => 7);
      END IF;
   END IF;

   RETURN return_value_;
END Get_Ship_Location_No___;


FUNCTION Get_Unique_Data_Item_Value___ (
   capture_session_id_          IN NUMBER,
   contract_                    IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   unique_line_id_              IN VARCHAR2,
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                     IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,    
   waiv_dev_rej_no_             IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   activity_seq_                IN NUMBER,
   res_handling_unit_id_        IN NUMBER,   
   res_sscc_                    IN VARCHAR2,
   res_alt_handl_unit_label_id_ IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   barcode_id_                  IN NUMBER, 
   wanted_data_item_id_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   unique_value_                VARCHAR2(200);
   column_name_                 VARCHAR2(30);
   dummy_                       BOOLEAN;
   pick_by_choice_option_       VARCHAR2(20);
BEGIN
   pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);
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
      ELSE
         IF (wanted_data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN        
            column_name_ := 'HANDLING_UNIT_ID';
         ELSIF (wanted_data_item_id_ = 'RES_SSCC') THEN
            column_name_ := 'SSCC';
         ELSIF (wanted_data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
            column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
         ELSIF (wanted_data_item_id_ = 'UNIQUE_LINE_ID') THEN
            column_name_ := 'CUST_ORD_RESERVATION_OBJID';
         ELSIF (wanted_data_item_id_ = 'QTY_TO_PICK') THEN
            column_name_ := 'QTY_ASSIGNED';
         ELSE
            column_name_ := wanted_data_item_id_;
         END IF;
         
         IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
            unique_value_ := Pick_Customer_Order_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                pick_list_no_               => pick_list_no_,
                                                                                unique_line_id_             => unique_line_id_,
                                                                                order_no_                   => order_no_,
                                                                                line_no_                    => line_no_,
                                                                                rel_no_                     => rel_no_,
                                                                                line_item_no_               => line_item_no_,
                                                                                part_no_                    => part_no_,
                                                                                location_no_                => location_no_,
                                                                                serial_no_                  => serial_no_,
                                                                                lot_batch_no_               => lot_batch_no_,
                                                                                waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                eng_chg_level_              => eng_chg_level_,
                                                                                configuration_id_           => configuration_id_, 
                                                                                activity_seq_               => activity_seq_,
                                                                                handling_unit_id_           => res_handling_unit_id_,
                                                                                sscc_                       => res_sscc_,
                                                                                alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                                shipment_id_                => shipment_id_,
                                                                                column_name_                => column_name_);
         ELSIF (wanted_data_item_id_ IN ('LOCATION_NO', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL',
                                         'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID', 'SERIAL_NO')) THEN
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
                                                                                    handling_unit_id_           => res_handling_unit_id_,
                                                                                    alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                                    column_name_                => column_name_,
                                                                                    sql_where_expression_       => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, pick_list_no_, order_no_, line_no_, rel_no_, line_item_no_, unique_line_id_, pick_by_choice_option_,
                                                                                                                   wanted_data_item_id_)); 
         ELSE
            unique_value_ := Pick_Customer_Order_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                pick_list_no_               => pick_list_no_,
                                                                                unique_line_id_             => unique_line_id_,
                                                                                order_no_                   => order_no_,
                                                                                line_no_                    => line_no_,
                                                                                rel_no_                     => rel_no_,
                                                                                line_item_no_               => line_item_no_,
                                                                                part_no_                    => part_no_,
                                                                                location_no_                => NULL ,
                                                                                serial_no_                  => NULL,
                                                                                lot_batch_no_               => NULL,
                                                                                waiv_dev_rej_no_            => NULL,
                                                                                eng_chg_level_              => NULL,
                                                                                configuration_id_           => configuration_id_, 
                                                                                activity_seq_               => NULL,
                                                                                handling_unit_id_           => NULL,
                                                                                sscc_                       => string_all_values_,
                                                                                alt_handling_unit_label_id_ => string_all_values_,
                                                                                shipment_id_                => shipment_id_,
                                                                                column_name_                => column_name_);
         END IF;
      END IF;

   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   contract_                    OUT VARCHAR2,
   pick_list_no_                OUT VARCHAR2,
   unique_line_id_              OUT VARCHAR2,
   order_no_                    OUT VARCHAR2,
   line_no_                     OUT VARCHAR2,
   rel_no_                      OUT VARCHAR2,
   line_item_no_                OUT NUMBER,
   part_no_                     OUT VARCHAR2,
   location_no_                 OUT VARCHAR2,
   serial_no_                   OUT VARCHAR2,
   lot_batch_no_                OUT VARCHAR2,    
   waiv_dev_rej_no_             OUT VARCHAR2,
   eng_chg_level_               OUT VARCHAR2,
   configuration_id_            OUT VARCHAR2,
   activity_seq_                OUT NUMBER,
   shipment_id_                 OUT NUMBER,
   barcode_id_                  OUT NUMBER,
   shp_handling_unit_id_        OUT NUMBER,
   shp_sscc_                    OUT VARCHAR2,
   shp_alt_handl_unit_label_id_ OUT VARCHAR2,
   res_handling_unit_id_        OUT NUMBER,   
   res_sscc_                    OUT VARCHAR2,
   res_alt_handl_unit_label_id_ OUT VARCHAR2,
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
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      pick_list_no_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PICK_LIST_NO', session_rec_ , process_package_, use_applicable_);
      unique_line_id_              := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'UNIQUE_LINE_ID', session_rec_ , process_package_, use_applicable_);
      order_no_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ORDER_NO', session_rec_ , process_package_, use_applicable_);
      line_no_                     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LINE_NO', session_rec_ , process_package_, use_applicable_);
      rel_no_                      := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'REL_NO', session_rec_ , process_package_, use_applicable_);
      line_item_no_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LINE_ITEM_NO', session_rec_ , process_package_, use_applicable_);
      part_no_                     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'PART_NO', session_rec_ , process_package_, use_applicable_);
      configuration_id_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'CONFIGURATION_ID', session_rec_ , process_package_, use_applicable_);
      shipment_id_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHIPMENT_ID', session_rec_ , process_package_, use_applicable_);
      shp_handling_unit_id_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      shp_sscc_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_SSCC', session_rec_ , process_package_, use_applicable_);
      shp_alt_handl_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      location_no_                 := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      lot_batch_no_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOT_BATCH_NO', session_rec_ , process_package_, use_applicable_);
      waiv_dev_rej_no_             := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WAIV_DEV_REJ_NO', session_rec_ , process_package_, use_applicable_);
      eng_chg_level_               := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ENG_CHG_LEVEL', session_rec_ , process_package_, use_applicable_);
      activity_seq_                := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'ACTIVITY_SEQ', session_rec_ , process_package_, use_applicable_);
      res_handling_unit_id_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_HANDLING_UNIT_ID', session_rec_ , process_package_, use_applicable_);
      res_sscc_                    := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_SSCC', session_rec_ , process_package_, use_applicable_);
      res_alt_handl_unit_label_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'RES_ALT_HANDLING_UNIT_LABEL_ID', session_rec_ , process_package_, use_applicable_);
      gtin_no_                     := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'GTIN', session_rec_ , process_package_, use_applicable_);
      
      -- NOTE: If the part is receipt and issue tracked, but not tracked in inventory, the serial no should not be used in filter.
      IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
          Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
         serial_no_ := NULL;
      ELSE
         serial_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'SERIAL_NO', session_rec_ , process_package_, use_applicable_);
      END IF;

      barcode_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'BARCODE_ID', session_rec_ , process_package_, use_applicable_);

      -- Add support for alternative handling unit keys
      IF (shp_handling_unit_id_ IS NULL AND shp_sscc_ IS NOT NULL) THEN
         shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(shp_sscc_);
      END IF;
      IF (shp_handling_unit_id_ IS NULL AND shp_alt_handl_unit_label_id_ IS NOT NULL) THEN
         shp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(shp_alt_handl_unit_label_id_);
      END IF;
      IF (shp_sscc_ IS NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         shp_sscc_ := Handling_Unit_API.Get_Sscc(shp_handling_unit_id_);
      END IF;
      IF (shp_alt_handl_unit_label_id_ IS NULL AND shp_handling_unit_id_ IS NOT NULL) THEN
         shp_alt_handl_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(shp_handling_unit_id_);
      END IF;
      IF (res_handling_unit_id_ IS NULL AND res_sscc_ IS NOT NULL) THEN
         res_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(res_sscc_);
      END IF;
      IF (res_handling_unit_id_ IS NULL AND res_alt_handl_unit_label_id_ IS NOT NULL) THEN
         res_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(res_alt_handl_unit_label_id_);
      END IF;
      IF (res_sscc_ IS NULL AND res_handling_unit_id_ IS NOT NULL) THEN
         res_sscc_ := Handling_Unit_API.Get_Sscc(res_handling_unit_id_);
      END IF;
      IF (res_alt_handl_unit_label_id_ IS NULL AND res_handling_unit_id_ IS NOT NULL) THEN
         res_alt_handl_unit_label_id_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(res_handling_unit_id_);
      END IF;

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

      -- Use unique handling for shipment id always since this is the connection point between the two data sources.
      IF (shipment_id_ IS NULL) THEN
         shipment_id_ := Handling_Unit_API.Get_Shipment_Id(shp_handling_unit_id_);
         IF (shipment_id_ IS NULL) THEN
            shipment_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                          serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                          res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'SHIPMENT_ID');
         END IF;
      END IF;
      
      IF (gtin_no_ IS NULL AND Data_Capture_Invent_Util_API.Gtin_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
         gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      END IF;
      
      IF ((part_no_ IS NULL) AND (gtin_no_ IS NOT NULL)) THEN
         part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_); 
      END IF;
         
      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (pick_list_no_ IS NULL) THEN
            pick_list_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                           serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                           res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'PICK_LIST_NO');
         END IF;
         IF (unique_line_id_ IS NULL) THEN
            unique_line_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                             serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                             res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'UNIQUE_LINE_ID');
         END IF;
         IF (order_no_ IS NULL) THEN
            order_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                       serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                       res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'ORDER_NO');
         END IF;
         IF (line_no_ IS NULL) THEN
            line_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                      serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                      res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'LINE_NO');
         END IF;
         IF (rel_no_ IS NULL) THEN
            rel_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                     serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                     res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'REL_NO');
         END IF;
         IF (line_item_no_ IS NULL) THEN
            line_item_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                           serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                           res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'LINE_ITEM_NO');
         END IF;
         IF (part_no_ IS NULL) THEN
            part_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                      serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                      res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'PART_NO');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                          serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                          res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'LOCATION_NO');
         END IF;
         IF (lot_batch_no_ IS NULL) THEN
            lot_batch_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                           serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                           res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'LOT_BATCH_NO');
         END IF;
         IF (waiv_dev_rej_no_ IS NULL) THEN
            waiv_dev_rej_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                              serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                              res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'WAIV_DEV_REJ_NO');
         END IF;
         IF (eng_chg_level_ IS NULL) THEN
            eng_chg_level_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                            serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                            res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'ENG_CHG_LEVEL');
         END IF;
         IF (configuration_id_ IS NULL) THEN
            configuration_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                               serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                               res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'CONFIGURATION_ID');
         END IF;
         IF (activity_seq_ IS NULL) THEN
            activity_seq_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                           serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                           res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'ACTIVITY_SEQ');
         END IF;
         IF (serial_no_ IS NULL) THEN
            serial_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                        serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                        res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'SERIAL_NO');
         END IF;
         IF (res_handling_unit_id_ IS NULL) THEN
            res_handling_unit_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                        serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                        res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'RES_HANDLING_UNIT_ID');
         END IF;

         IF (barcode_id_ IS NULL AND Data_Capture_Order_Util_API.Inventory_Barcode_Enabled(session_rec_.capture_process_id, session_rec_.capture_config_id)) THEN
            barcode_id_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                         serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                         res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, 'BARCODE_ID');
         END IF;
      END IF;
   $ELSE
      NULL;                       
   $END
END Get_Filter_Keys___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_          IN NUMBER,
   owning_data_item_id_         IN VARCHAR2,
   data_item_detail_id_         IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   unique_line_id_              IN VARCHAR2,
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                     IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,    
   waiv_dev_rej_no_             IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   activity_seq_                IN NUMBER,
   shp_handling_unit_id_        IN NUMBER,
   shp_sscc_                    IN VARCHAR2,
   shp_alt_handl_unit_label_id_ IN VARCHAR2,
   res_handling_unit_id_        IN NUMBER,
   res_sscc_                    IN VARCHAR2,
   res_alt_handl_unit_label_id_ IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   barcode_id_                  IN NUMBER,
   gtin_no_                     IN VARCHAR2) 
IS
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('PICK_LIST_NO') THEN
            detail_value_ := pick_list_no_;
         WHEN ('UNIQUE_LINE_ID') THEN
            detail_value_ := unique_line_id_;
         WHEN ('ORDER_NO') THEN
            detail_value_ := order_no_;
         WHEN ('LINE_NO') THEN
            detail_value_ := line_no_;
         WHEN ('LINE_ITEM_NO') THEN
            detail_value_ := line_item_no_;
         WHEN ('REL_NO') THEN
            detail_value_ := rel_no_;
         WHEN ('PART_NO') THEN
            detail_value_ := part_no_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
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
         WHEN ('BARCODE_ID') THEN
            detail_value_ := barcode_id_;
         WHEN ('SHP_HANDLING_UNIT_ID') THEN
            detail_value_ := shp_handling_unit_id_;
         WHEN ('SHP_SSCC') THEN
            detail_value_ := shp_sscc_;
         WHEN ('SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := shp_alt_handl_unit_label_id_;
         WHEN ('RES_HANDLING_UNIT_ID') THEN
            detail_value_ := res_handling_unit_id_;
         WHEN ('RES_SSCC') THEN
            detail_value_ := res_sscc_;
         WHEN ('RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
            detail_value_ := res_alt_handl_unit_label_id_;
         WHEN ('GTIN') THEN
            detail_value_ := gtin_no_;
         ELSE
            NULL;
      END CASE;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Filter_Key_Detail___;


PROCEDURE Add_Unique_Data_Item_Detail___ (
   capture_session_id_          IN NUMBER,
   session_rec_                 IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_         IN VARCHAR2,
   owning_data_item_value_      IN VARCHAR2,
   data_item_detail_id_         IN VARCHAR2,
   contract_                    IN VARCHAR2,
   pick_list_no_                IN VARCHAR2,
   unique_line_id_              IN VARCHAR2,
   order_no_                    IN VARCHAR2,
   line_no_                     IN VARCHAR2,
   rel_no_                      IN VARCHAR2,
   line_item_no_                IN NUMBER,
   part_no_                     IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,    
   waiv_dev_rej_no_             IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   activity_seq_                IN NUMBER,
   res_handling_unit_id_        IN NUMBER,
   res_sscc_                    IN VARCHAR2,
   res_alt_handl_unit_label_id_ IN VARCHAR2,
   shipment_id_                 IN NUMBER,
   barcode_id_                  IN NUMBER )  
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

      -- Non filter key data items and/or feedback items that could be fetched by unique handling
      IF (detail_value_ IS NULL AND data_item_detail_id_ IN ('QTY_TO_PICK')) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                        serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, res_handling_unit_id_, 
                                                        res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, data_item_detail_id_);
      ELSIF (detail_value_ IS NULL AND data_item_detail_id_ IN ('SHIP_LOCATION_NO')) THEN
         detail_value_ := Get_Ship_Location_No___(shipment_id_, contract_, pick_list_no_);
         IF (detail_value_ = 'NULL') THEN
            detail_value_ := NULL;
         END IF;
      END IF;
      
      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


PROCEDURE Validate_Overpicking___ (
   capture_session_id_ IN NUMBER,
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   qty_to_pick_        IN NUMBER )
IS
   session_rec_ Data_Capture_Common_Util_API.Session_Rec;
   line_rec_    Customer_Order_Line_API.Public_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_ => session_rec_.capture_process_id,
                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                        process_detail_id_  => 'ALLOW_OVERPICK_LINES' ) = Fnd_Boolean_API.DB_FALSE) THEN
         line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

         IF ((qty_to_pick_ + line_rec_.qty_picked + line_rec_.qty_shipped ) > line_rec_.revised_qty_due) THEN
            Error_SYS.Record_General(lu_name_, 'NOOVERPICK: The picked quantity exceeds the order line quantity. Over-picking is not allowed.');
         END IF;
      END IF;
   $ELSE
      NULL;       
   $END
END Validate_Overpicking___;


PROCEDURE Get_Handling_Unit_Filters___(
   shipment_id_                 IN OUT NUMBER,
   shp_handling_unit_id_        IN OUT NUMBER,
   shp_sscc_                    IN OUT VARCHAR2,
   shp_alt_handl_unit_label_id_ IN OUT VARCHAR2,
   sql_where_expression_        IN OUT VARCHAR2,
   capture_session_id_          IN     NUMBER,
   data_item_id_                IN     VARCHAR2 )
IS
   session_rec_  Data_Capture_Common_Util_API.Session_Rec;
   contract_     VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_    := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_);
      IF (shipment_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHIPMENT_ID', data_item_id_)) THEN
         shipment_id_ := number_all_values_;
         -- To filter out shipments/handling units where the shipment are already fully pick reported, we only do this when shipment_id_ have not been identified yet.
         sql_where_expression_ := ' AND Shipment_API.Not_Pick_Reported_Line_Exist(shipment_id) = 1 ';
      END IF;
      IF (shp_handling_unit_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_HANDLING_UNIT_ID', data_item_id_)) THEN
         shp_handling_unit_id_ := number_all_values_;
      END IF;
      IF (shp_sscc_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_SSCC', data_item_id_)) THEN
         shp_sscc_ := string_all_values_;
      END IF;
      IF (shp_alt_handl_unit_label_id_ IS NULL AND NOT Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'SHP_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_)) THEN
         shp_alt_handl_unit_label_id_ := string_all_values_;
      END IF;
   $END
   
   sql_where_expression_ := sql_where_expression_ || ' AND Shipment_API.Get_Objstate(shipment_id)          = ''Preliminary'' 
                                                       AND Shipment_API.Connected_Lines_Exist(shipment_id) = 1
                                                       AND Shipment_API.Get_Contract(shipment_id) = ''' || contract_ || ''' ';
   
END Get_Handling_Unit_Filters___;


FUNCTION Skip_Handling_Unit___(
   capture_session_id_          IN NUMBER,
   data_item_id_                IN VARCHAR2,
   shp_handling_unit_id_        IN NUMBER,
   shp_sscc_                    IN VARCHAR2,
   shp_alt_handl_unit_label_id_ IN VARCHAR2) RETURN BOOLEAN
IS
   skip_handling_unit_ BOOLEAN := FALSE;
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      skip_handling_unit_ := ((Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_a_ => 'SHP_HANDLING_UNIT_ID', data_item_id_b_ => data_item_id_) AND shp_handling_unit_id_ IS NULL) OR
                              (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_a_ => 'SHP_SSCC', data_item_id_b_ => data_item_id_) AND shp_sscc_ IS NULL) OR
                              (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_a_ => 'SHP_ALT_HANDLING_UNIT_LABEL_ID', data_item_id_b_ => data_item_id_) AND shp_alt_handl_unit_label_id_ IS NULL ));
   $END
   RETURN skip_handling_unit_;
END Skip_Handling_Unit___;


PROCEDURE Get_Qty_Picked_And_Reserv___ (
   total_qty_picked_        OUT NUMBER,
   release_reservation_     OUT BOOLEAN,
   capture_session_id_      IN NUMBER,
   unique_line_id_          IN VARCHAR2 )
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      data_item_attr_tab_   Data_Capture_Session_Line_API.Data_Item_Attr_Tab;
      blob_ref_attr_tab_    Data_Capture_Session_Line_API.Data_Item_Attr_Tab;
   $END
   attr_unique_line_id_     CUSTOMER_ORDER_RESERVATION.objid%TYPE;
   attr_qty_picked_         NUMBER  := 0;
BEGIN
   release_reservation_ := FALSE;
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.Get_Attr_Collection(data_item_attr_tab_, blob_ref_attr_tab_, capture_session_id_);
      IF (data_item_attr_tab_.COUNT > 0) THEN
         FOR i IN data_item_attr_tab_.FIRST..data_item_attr_tab_.LAST LOOP
            attr_unique_line_id_ := Client_SYS.Get_Item_Value('UNIQUE_LINE_ID', data_item_attr_tab_(i).attr);
            IF (Validate_SYS.Is_Equal(attr_unique_line_id_, unique_line_id_)) THEN
               attr_qty_picked_ := Client_SYS.Get_Item_Value('QTY_PICKED', data_item_attr_tab_(i).attr);
               -- Check if the reservation is released in a previous dataset.
               IF (NOT release_reservation_) THEN
                  release_reservation_ := (Client_SYS.Get_Item_Value('RELEASE_RESERVATION', data_item_attr_tab_(i).attr) = Gen_Yes_No_API.DB_YES);
               END IF;
               total_qty_picked_ := NVL(total_qty_picked_,   0) + attr_qty_picked_;
            END IF;
         END LOOP;
      END IF;
   $END
END Get_Qty_Picked_And_Reserv___;


FUNCTION Get_Input_Uom_Sql_Whr_Exprs___  RETURN VARCHAR2
IS
   sql_where_expression_   VARCHAR2(32000);
BEGIN   
   sql_where_expression_  := ' AND (purch_usage_allowed = 1 OR cust_usage_allowed = 1 OR manuf_usage_allowed = 1) ';  
   RETURN sql_where_expression_;
END Get_Input_Uom_Sql_Whr_Exprs___;


PROCEDURE Raise_Pick_Choice_Not_Allowed___ 
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'PICKBYCHOICEBLOCKED: Not allowed to pick another stock record than the one already reserved. The pick list line is blocked for pick by choice.');
END Raise_Pick_Choice_Not_Allowed___;

PROCEDURE Construct_Process_Message___ (
   process_message_ IN OUT CLOB )
IS
BEGIN
   IF (process_message_ IS NULL) THEN
      -- Create the message header
      process_message_ := Message_SYS.Construct_Clob_Message('PROCESS_MESSAGE');
   END IF;
END Construct_Process_Message___;

FUNCTION Get_Shipment_Id_Message___(
   process_message_ IN OUT CLOB ) RETURN CLOB
IS
   local_message_   CLOB;
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      local_message_    := Message_SYS.Find_Clob_Attribute(process_message_, 'SHIPMENTS', '');
   END IF;
   RETURN local_message_;
END Get_Shipment_Id_Message___;

PROCEDURE Update_Shipment_Id_Message___ (
   process_message_ IN OUT CLOB,
   shipment_id_     IN     VARCHAR2 )
IS
  local_message_    CLOB;
  count_            NUMBER;
  name_arr_         Message_SYS.name_table_clob;
  value_arr_        Message_SYS.line_table_clob;
  add_to_list_      BOOLEAN DEFAULT TRUE;
BEGIN
   local_message_    := Get_Shipment_Id_Message___(process_message_);
   IF local_message_ IS NULL THEN 
      -- We need to have a separate sub message for SHIPMENTS so we construct a local_message_ and add or update it in process_message_
      local_message_ := Message_SYS.Construct_Clob_Message('SHIPMENTS');
   ELSE
      Message_SYS.Get_Clob_Attributes(local_message_, count_, name_arr_, value_arr_);
      IF (count_ > 0) THEN
         FOR n_ IN 1..count_ LOOP
            IF (name_arr_(n_) = 'SHIPMENT_ID') THEN
               IF (Client_SYS.Attr_Value_To_Number(value_arr_(n_)) = shipment_id_) THEN
                  add_to_list_ := FALSE;
                  Exit;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;

   IF (add_to_list_) THEN
      Message_SYS.Add_Attribute(local_message_, 'SHIPMENT_ID', shipment_id_);
      Message_SYS.Set_Clob_Attribute(process_message_, 'SHIPMENTS', local_message_);
   END IF;
END Update_Shipment_Id_Message___;


PROCEDURE Raise_Shipment_Location_Error___ (
   shp_handling_unit_id_ IN NUMBER,
   shp_handl_unit_location_no_ IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'SHPHUNOTEXISTONSHPLOC: Shipment Handling Unit :P1 is already on Shipment Location :P2.', shp_handling_unit_id_, shp_handl_unit_location_no_);
END Raise_Shipment_Location_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   contract_                    VARCHAR2(5);
   pick_list_no_                VARCHAR2(15);
   unique_line_id_              CUSTOMER_ORDER_RESERVATION.objid%TYPE;
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   rel_no_                      VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   pick_line_serial_no_         VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   activity_seq_                NUMBER;
   shipment_id_                 NUMBER;
   data_item_description_       VARCHAR2(200);
   barcode_id_                  NUMBER;
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   hu_sql_where_expression_     VARCHAR2(2000);
   dummy_                       BOOLEAN;
   column_name_                 VARCHAR2(30);
   uses_shipment_inventory_     NUMBER;
   ship_location_no_            VARCHAR2(35);
   shp_handl_unit_location_no_  VARCHAR2(35);
   shp_handl_unit_contract_     VARCHAR2(5);
   local_shipment_id_           NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   pick_by_choice_option_       VARCHAR2(20);
   column_value_nullable_       BOOLEAN := FALSE;
   input_unit_meas_group_id_    VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
   reserve_rec_                 Customer_Order_Reservation_API.Public_Rec;
   gtin_part_no_                VARCHAR2(25);
   local_part_no_               VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'RELEASE_RESERVATION') THEN
         Gen_Yes_No_API.Exist_Db(data_item_value_);
      ELSE
         IF (data_item_id_ = 'BARCODE_ID') THEN
            IF (data_item_value_ IS NOT NULL) THEN               
               -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
               Get_Filter_Keys___(contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                  serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                                  shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                                  capture_session_id_, data_item_id_, data_item_value_, use_unique_values_ => TRUE);
            END IF;            
         ELSE
            Get_Filter_Keys___(contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                               serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                               shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_, data_item_value_);
         END IF;
         
         pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);
         IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) AND (unique_line_id_ IS NOT NULL) THEN
            reserve_rec_ := Customer_Order_Reservation_API.Get_Object_By_Id(unique_line_id_);
            part_no_     := NVL(part_no_, reserve_rec_.part_no) ;
         END IF;
         
         IF (data_item_id_ IN ('PICK_LIST_NO', 'UNIQUE_LINE_ID', 'ORDER_NO', 'LINE_NO', 'REL_NO', 'LINE_ITEM_NO', 'PART_NO', 'LOCATION_NO',
                               'LOT_BATCH_NO', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 'CONFIGURATION_ID', 'ACTIVITY_SEQ', 'SHIPMENT_ID')) THEN
            IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED AND reserve_rec_.pick_by_choice_blocked = Fnd_Boolean_API.DB_TRUE) THEN
               IF ((data_item_id_ = 'LOCATION_NO'      AND data_item_value_ != reserve_rec_.location_no) OR 
                   (data_item_id_ = 'LOT_BATCH_NO'     AND data_item_value_ != reserve_rec_.lot_batch_no) OR 
                   (data_item_id_ = 'WAIV_DEV_REJ_NO'  AND data_item_value_ != reserve_rec_.waiv_dev_rej_no) OR 
                   (data_item_id_ = 'ENG_CHG_LEVEL'    AND data_item_value_ != reserve_rec_.eng_chg_level) OR 
                   (data_item_id_ = 'ACTIVITY_SEQ'     AND data_item_value_ != reserve_rec_.activity_seq) OR 
                   (data_item_id_ = 'CONFIGURATION_ID' AND data_item_value_ != reserve_rec_.configuration_id)) THEN
                  Raise_Pick_Choice_Not_Allowed___;
               END IF;
            END IF;
            IF (barcode_id_ IS NOT NULL AND 
                data_item_id_ IN ('PART_NO', 'CONFIGURATION_ID', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ')) THEN
               -- BARCODE_ID is used for these items, then validate them against the barcode table
               data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
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
                                                                         
            ELSIF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN 
               IF (data_item_id_ = 'UNIQUE_LINE_ID') THEN
                  column_name_ := 'CUST_ORD_RESERVATION_OBJID';
               ELSE
                  column_name_ := data_item_id_;
               END IF;
               Pick_Customer_Order_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                      pick_list_no_               => pick_list_no_,
                                                                      unique_line_id_             => unique_line_id_,
                                                                      order_no_                   => order_no_,
                                                                      line_no_                    => line_no_,
                                                                      rel_no_                     => rel_no_,
                                                                      line_item_no_               => line_item_no_,
                                                                      part_no_                    => part_no_,
                                                                      location_no_                => location_no_,
                                                                      serial_no_                  => serial_no_,
                                                                      lot_batch_no_               => lot_batch_no_,
                                                                      waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                      eng_chg_level_              => eng_chg_level_,
                                                                      configuration_id_           => configuration_id_, 
                                                                      activity_seq_               => activity_seq_,
                                                                      handling_unit_id_           => res_handling_unit_id_,
                                                                      sscc_                       => res_sscc_,
                                                                      alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                      shipment_id_                => shipment_id_,
                                                                      column_name_                => column_name_, 
                                                                      column_value_               => data_item_value_);
            ELSIF (data_item_id_ IN ('LOCATION_NO', 'LOT_BATCH_NO', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 'ACTIVITY_SEQ')) THEN
               data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
               Inventory_Part_In_Stock_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                          part_no_                    => part_no_,
                                                                          configuration_id_           => configuration_id_, 
                                                                          location_no_                => location_no_,
                                                                          lot_batch_no_               => lot_batch_no_,
                                                                          serial_no_                  => serial_no_,
                                                                          eng_chg_level_              => eng_chg_level_,
                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                          activity_seq_               => activity_seq_,
                                                                          handling_unit_id_           => res_handling_unit_id_,
                                                                          alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                          column_name_                => data_item_id_, 
                                                                          column_value_               => data_item_value_,
                                                                          column_description_         => data_item_description_,
                                                                          sql_where_expression_       => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, pick_list_no_, order_no_, line_no_, rel_no_, line_item_no_, unique_line_id_, pick_by_choice_option_, data_item_id_));
            ELSE
               IF (data_item_id_ = 'UNIQUE_LINE_ID') THEN
                  column_name_ := 'CUST_ORD_RESERVATION_OBJID';
               ELSE
                  column_name_ := data_item_id_;
               END IF;
               Pick_Customer_Order_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                      pick_list_no_               => pick_list_no_,
                                                                      unique_line_id_             => unique_line_id_,
                                                                      order_no_                   => order_no_,
                                                                      line_no_                    => line_no_,
                                                                      rel_no_                     => rel_no_,
                                                                      line_item_no_               => line_item_no_,
                                                                      part_no_                    => part_no_,
                                                                      location_no_                => NULL,
                                                                      serial_no_                  => NULL,
                                                                      lot_batch_no_               => NULL,
                                                                      waiv_dev_rej_no_            => NULL,
                                                                      eng_chg_level_              => NULL,
                                                                      configuration_id_           => configuration_id_, 
                                                                      activity_seq_               => NULL,
                                                                      handling_unit_id_           => NULL,
                                                                      sscc_                       => string_all_values_,
                                                                      alt_handling_unit_label_id_ => string_all_values_,
                                                                      shipment_id_                => shipment_id_,
                                                                      column_name_                => column_name_, 
                                                                      column_value_               => data_item_value_);
            END IF;
      
            IF (data_item_id_ = 'PART_NO') THEN
               -- For PART_NO we do more validatins, since our have the part_no+catch_qty_picked validation and the invent one has all the regular part validations that needs to be performed
               Validate_Data_Item___(capture_session_id_,
                                     data_item_id_,
                                     data_item_value_,
                                     part_no_);
               Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                               data_item_id_,
                                                               data_item_value_);
            END IF;
         ELSIF (data_item_id_ = 'SERIAL_NO') THEN
            IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED AND reserve_rec_.pick_by_choice_blocked = Fnd_Boolean_API.DB_TRUE) THEN
               IF (data_item_id_ = 'SERIAL_NO' AND data_item_value_ != reserve_rec_.serial_no) THEN
                  Raise_Pick_Choice_Not_Allowed___;
               END IF;
            END IF;
            
            IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE) THEN 
               IF (Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_SERIAL_TRACKING) THEN
                  IF (barcode_id_ IS NULL) THEN
                     IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN 
                        Pick_Customer_Order_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                               pick_list_no_               => pick_list_no_,
                                                                               unique_line_id_             => unique_line_id_,
                                                                               order_no_                   => order_no_,
                                                                               line_no_                    => line_no_,
                                                                               rel_no_                     => rel_no_,
                                                                               line_item_no_               => line_item_no_,
                                                                               part_no_                    => part_no_,
                                                                               location_no_                => location_no_,
                                                                               serial_no_                  => serial_no_,
                                                                               lot_batch_no_               => lot_batch_no_,
                                                                               waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                               eng_chg_level_              => eng_chg_level_,
                                                                               configuration_id_           => configuration_id_, 
                                                                               activity_seq_               => activity_seq_,
                                                                               handling_unit_id_           => res_handling_unit_id_,
                                                                               sscc_                       => res_sscc_,
                                                                               alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                               shipment_id_                => shipment_id_,
                                                                               column_name_                => data_item_id_, 
                                                                               column_value_               => data_item_value_);
                     ELSE  
                        data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
                        Inventory_Part_In_Stock_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                                   part_no_                    => part_no_,
                                                                                   configuration_id_           => configuration_id_, 
                                                                                   location_no_                => location_no_,
                                                                                   lot_batch_no_               => lot_batch_no_,
                                                                                   serial_no_                  => serial_no_,
                                                                                   eng_chg_level_              => eng_chg_level_,
                                                                                   waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                                   activity_seq_               => activity_seq_,
                                                                                   handling_unit_id_           => res_handling_unit_id_,
                                                                                   alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                                   column_name_                => data_item_id_, 
                                                                                   column_value_               => data_item_value_,
                                                                                   column_description_         => data_item_description_,
                                                                                   sql_where_expression_       => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, pick_list_no_, order_no_, line_no_, rel_no_, line_item_no_, unique_line_id_, pick_by_choice_option_, data_item_id_),
                                                                                   column_value_nullable_      => column_value_nullable_);
                     END IF;
                  ELSE  -- BARCODE_ID is used for this item, then validate item against the barcode table
                     data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
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

                  END IF;
               ELSE
                  Part_Serial_Catalog_API.Exist(part_no_, data_item_value_);
                  IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN 
                     pick_line_serial_no_ := Pick_Customer_Order_API.Get_Column_Value_If_Unique(contract_, pick_list_no_, unique_line_id_, order_no_, 
                                                                                                line_no_, rel_no_, line_item_no_, part_no_, NULL, NULL, NULL, NULL, NULL, 
                                                                                                configuration_id_, NULL, NULL, NULL, NULL, shipment_id_, data_item_id_);
                  ELSE 
                     pick_line_serial_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                                           serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, 
                                                                           res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,shipment_id_, barcode_id_, data_item_id_);
                  END IF;

                  -- NOTE: serial_no_ is the value on the picking record. data_item_value_ is the serial entered in the data collection process.
                  IF (Inventory_Part_In_Stock_API.Check_Individual_Exist(part_no_, data_item_value_) = 1 AND pick_line_serial_no_ = '*') THEN
                     Error_SYS.Record_General(lu_name_, 'SPLITSERINV: Serial :P1 for part :P2 already exists on a specific stock or transit record.', data_item_value_, part_no_);
                  ELSIF (pick_line_serial_no_ != '*' and data_item_value_ != pick_line_serial_no_ AND (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED)) then
                     Error_SYS.Record_General(lu_name_, 'SERIALNOTMATCH: Serial :P1 for part :P2 does not exist in this context.', data_item_value_, part_no_);
                  ELSE 
                     Temporary_Part_Tracking_API.Validate_Serial(contract_, part_no_, data_item_value_);
                  END IF;
               END IF;
            ELSE
               Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
            END IF;
         ELSIF (data_item_id_ IN ('SHIP_LOCATION_NO')) THEN 
            IF (data_item_value_ IS NOT NULL) THEN
               Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_ => capture_session_id_,
                                                               data_item_id_       => 'LOCATION_NO', -- Use LOCATION_NO to check if location exists at all.
                                                               data_item_value_    => data_item_value_);
               IF (Inventory_Location_API.Get_Location_Type_Db(contract_, data_item_value_) != Inventory_Location_Type_API.DB_SHIPMENT) THEN
                  Error_SYS.Record_General(lu_name_,'INVALIDSHIPLOC: Location :P1 is not a shipment location.', data_item_value_);
               END IF;
            END IF;
            uses_shipment_inventory_ := Handle_Ship_Invent_Utility_API.Uses_Shipment_Inventory(pick_list_no_   => pick_list_no_, 
                                                                                               pick_list_type_ => 'CUST_ORDER_PICK_LIST'); 
            IF (uses_shipment_inventory_ = 0 AND data_item_value_ IS NOT NULL) THEN
               Error_SYS.Record_General(lu_name_,'SHIPINVNOTUSED: :P1 cannot be specified when shipment inventory is not used.', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
            ELSIF (uses_shipment_inventory_ = 1 AND data_item_value_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_,'SHIPINVUSED: :P1 is mandatory when shipment inventory is used.', Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
            END IF;
            
            IF (data_item_value_ IS NOT NULL AND shp_handling_unit_id_ IS NOT NULL) THEN 
               shp_handl_unit_location_no_ := Handling_Unit_API.Get_Location_No(shp_handling_unit_id_);
               shp_handl_unit_contract_    := Handling_Unit_API.Get_Contract(shp_handling_unit_id_);
               IF ((shp_handl_unit_location_no_ IS NOT NULL AND data_item_value_ != shp_handl_unit_location_no_) OR
                   (shp_handl_unit_contract_ IS NOT NULL AND contract_ != shp_handl_unit_contract_)) THEN
                  Raise_Shipment_Location_Error___(shp_handling_unit_id_, shp_handl_unit_location_no_);
               END IF;
            END IF;
         ELSIF (data_item_id_ = 'QTY_PICKED') THEN
            Validate_Overpicking___(capture_session_id_, order_no_, line_no_, rel_no_, line_item_no_, data_item_value_);
            Validate_Data_Item___(capture_session_id_,
                                  data_item_id_,
                                  data_item_value_,
                                  part_no_);
         ELSIF (data_item_id_ = 'CATCH_QTY_PICKED') THEN
            Validate_Data_Item___(capture_session_id_,
                                  data_item_id_,
                                  data_item_value_,
                                  part_no_);
                                  
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

               -- Also validate if the barcode values match the current report picking line record (if such record have been identified already by line keys for example)
               -- No handling of pick by choice at the moment, it will get very complicated and messy if we add this kind validation also for that option and might be unnecessary
               IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
                  Pick_Customer_Order_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                         pick_list_no_               => pick_list_no_,
                                                                         unique_line_id_             => unique_line_id_,
                                                                         order_no_                   => order_no_,
                                                                         line_no_                    => line_no_,
                                                                         rel_no_                     => rel_no_,
                                                                         line_item_no_               => line_item_no_,
                                                                         part_no_                    => part_no_,
                                                                         location_no_                => location_no_,
                                                                         serial_no_                  => serial_no_,
                                                                         lot_batch_no_               => lot_batch_no_,
                                                                         waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                         eng_chg_level_              => eng_chg_level_,
                                                                         configuration_id_           => configuration_id_, 
                                                                         activity_seq_               => activity_seq_,
                                                                         handling_unit_id_           => res_handling_unit_id_,
                                                                         sscc_                       => res_sscc_,
                                                                         alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                         shipment_id_                => shipment_id_,
                                                                         column_name_                => NULL, 
                                                                         column_value_               => NULL,
                                                                         inv_barcode_validation_     => TRUE);
               END IF;
            END IF;
         ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            IF (data_item_value_ IS NOT NULL) THEN
               IF (line_item_no_ IS NOT NULL AND line_item_no_ > 0) THEN  
                  Error_SYS.Record_General(lu_name_, 'PACKINGNOTALLOWED: :P1 cannot be specified since packing is not allowed for package component part.', 
                                           Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_));
               END IF;
               
               ship_location_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                      data_item_id_a_     => 'SHIP_LOCATION_NO',
                                                                                      data_item_id_b_     => data_item_id_);

               IF (ship_location_no_ IS NOT NULL AND shp_handling_unit_id_ IS NOT NULL) THEN 
                  shp_handl_unit_location_no_ := Handling_Unit_API.Get_Location_No(shp_handling_unit_id_);
                  shp_handl_unit_contract_    := Handling_Unit_API.Get_Contract(shp_handling_unit_id_);
                  IF ((shp_handl_unit_location_no_ IS NOT NULL AND ship_location_no_ != shp_handl_unit_location_no_) OR
                      (shp_handl_unit_contract_ IS NOT NULL AND contract_ != shp_handl_unit_contract_)) THEN
                     Raise_Shipment_Location_Error___(shp_handling_unit_id_, shp_handl_unit_location_no_);
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
               ELSE
                  column_name_ := data_item_id_;
               END IF;
               data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
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
            END IF;
         ELSIF (data_item_id_ IN ('RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED AND reserve_rec_.pick_by_choice_blocked = Fnd_Boolean_API.DB_TRUE) THEN
               IF (data_item_id_ = 'RES_HANDLING_UNIT_ID' AND data_item_value_ != reserve_rec_.handling_unit_id) THEN
                  Raise_Pick_Choice_Not_Allowed___;
               END IF;
            END IF;
            IF (data_item_id_ = 'RES_HANDLING_UNIT_ID' AND data_item_value_ != 0 AND data_item_value_ IS NOT NULL) THEN
               Handling_Unit_API.Exist(data_item_value_);
            END IF;
            IF (data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'RES_SSCC') THEN
               column_name_ := 'SSCC';
               column_value_nullable_ := TRUE;
            ELSIF (data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               column_value_nullable_ := TRUE;
            ELSE
               column_name_ := data_item_id_;
               column_value_nullable_ := TRUE;
            END IF;
            IF (Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_) = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN 
               Pick_Customer_Order_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                      pick_list_no_               => pick_list_no_,
                                                                      unique_line_id_             => unique_line_id_,
                                                                      order_no_                   => order_no_,
                                                                      line_no_                    => line_no_,
                                                                      rel_no_                     => rel_no_,
                                                                      line_item_no_               => line_item_no_,
                                                                      part_no_                    => part_no_,
                                                                      location_no_                => location_no_,
                                                                      serial_no_                  => serial_no_,
                                                                      lot_batch_no_               => lot_batch_no_,
                                                                      waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                      eng_chg_level_              => eng_chg_level_,
                                                                      configuration_id_           => configuration_id_, 
                                                                      activity_seq_               => activity_seq_,
                                                                      handling_unit_id_           => res_handling_unit_id_,
                                                                      sscc_                       => res_sscc_,
                                                                      alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                      shipment_id_                => shipment_id_,
                                                                      column_name_                => column_name_,
                                                                      column_value_               => data_item_value_);
            ELSE
               Inventory_Part_In_Stock_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                          part_no_                    => part_no_,
                                                                          configuration_id_           => configuration_id_, 
                                                                          location_no_                => location_no_,
                                                                          lot_batch_no_               => lot_batch_no_,
                                                                          serial_no_                  => serial_no_,
                                                                          eng_chg_level_              => eng_chg_level_,
                                                                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                          activity_seq_               => activity_seq_,
                                                                          handling_unit_id_           => res_handling_unit_id_,
                                                                          alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                          column_name_                => column_name_, 
                                                                          column_value_               => data_item_value_,
                                                                          column_description_         => data_item_description_,
                                                                          sql_where_expression_       => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, pick_list_no_, order_no_, line_no_, rel_no_, line_item_no_, unique_line_id_, pick_by_choice_option_, data_item_id_),
                                                                          column_value_nullable_      => column_value_nullable_);
            END IF ;
         ELSIF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
         ELSE -- GTIN etc
            Data_Capture_Invent_Util_API.Validate_Data_Item(capture_session_id_,
                                                            data_item_id_,
                                                            data_item_value_);
         END IF;
         -- Extra gtin validation since the one in Data_Capture_Invent_Util_API.Validate_Data_Item is not enough
         IF (data_item_id_ = 'GTIN') THEN
            gtin_part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(data_item_value_);
            IF (gtin_part_no_ IS NOT NULL) THEN
               local_part_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                   data_item_id_a_     => 'PART_NO',
                                                                                   data_item_id_b_     => data_item_id_);
               IF (local_part_no_ IS NULL)  THEN
                  -- This call will handle both pick by choice allowed and not allowed
                  -- Sending NULL for part_no and all items that can be applicable handled and are part_no connected
                  -- since these could have gotten their values from the gtin in Get_Filter_Keys___ that might not be correct.
                  -- The pick_list_no_ and unique_line_id_ are the important filter keys here since they will point out 1 record.
                  local_part_no_ := Get_Unique_Data_Item_Value___(capture_session_id_          => capture_session_id_, 
                                                                  contract_                    => contract_, 
                                                                  pick_list_no_                => pick_list_no_, 
                                                                  unique_line_id_              => unique_line_id_, 
                                                                  order_no_                    => order_no_, 
                                                                  line_no_                     => line_no_, 
                                                                  rel_no_                      => rel_no_, 
                                                                  line_item_no_                => line_item_no_, 
                                                                  part_no_                     => NULL, 
                                                                  location_no_                 => location_no_,
                                                                  serial_no_                   => NULL, 
                                                                  lot_batch_no_                => NULL, 
                                                                  waiv_dev_rej_no_             => waiv_dev_rej_no_, 
                                                                  eng_chg_level_               => eng_chg_level_, 
                                                                  configuration_id_            => NULL, 
                                                                  activity_seq_                => activity_seq_, 
                                                                  res_handling_unit_id_        => res_handling_unit_id_, 
                                                                  res_sscc_                    => res_sscc_, 
                                                                  res_alt_handl_unit_label_id_ => res_alt_handl_unit_label_id_, 
                                                                  shipment_id_                 => shipment_id_, 
                                                                  barcode_id_                  => barcode_id_, 
                                                                  wanted_data_item_id_         => 'PART_NO');

               END IF;
               IF (local_part_no_ IS NOT NULL AND gtin_part_no_ != local_part_no_)  THEN
                  -- This error is needed, since the part taken from GTIN dont match the already scanned part or the part that the unique record points to.
                  Error_SYS.Record_General(lu_name_, 'GTINDONTMATCH: The GTIN No does not match current Report Picking Line.');
               END IF;
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
   dummy_                       VARCHAR2(5);
   pick_list_no_                VARCHAR2(15);
   unique_line_id_              CUSTOMER_ORDER_RESERVATION.objid%TYPE;
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   rel_no_                      VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   activity_seq_                NUMBER;
   shipment_id_                 NUMBER;
   barcode_id_                  NUMBER;
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   hu_sql_where_expression_     VARCHAR2(2000);
   pick_line_serial_no_         VARCHAR2(50);
   column_name_                 VARCHAR2(30);
   local_shipment_id_           NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   pick_by_choice_option_       VARCHAR2(20);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   lov_id_                      NUMBER := 1;
   lov_type_db_                 VARCHAR2(20);
   input_uom_group_id_          VARCHAR2(30);
   gtin_no_                     VARCHAR2(14);
   customer_no_                  VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);
      IF (data_item_id_ = 'SHIP_LOCATION_NO') THEN
         Inventory_Location_API.Create_Data_Capture_Lov(contract_, capture_session_id_, 4);
      ELSIF (data_item_id_ IN ('RELEASE_RESERVATION')) THEN
         Gen_Yes_No_API.Create_Data_Capture_Lov(capture_session_id_ => capture_session_id_);
      ELSE

         IF (data_item_id_ = 'BARCODE_ID') THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(dummy_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                               serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                               shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(dummy_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                               serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                               shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_);
         END IF;

         IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) AND (unique_line_id_ IS NOT NULL) THEN
            part_no_ := NVL(part_no_, Customer_Order_Reservation_API.Get_Object_By_Id(unique_line_id_).part_no) ;
         END IF;
         
         lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);

         IF (data_item_id_ = 'SERIAL_NO') THEN          
            IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN 
               -- If if pick by choice is allowed, we call method Pick_Customer_Order_API.Get_Column_Value_If_Unique directly since Get_Unique_Data_Item_Value___
               -- will retrieve serial_no by call to the method Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique which is not desired here.
               pick_line_serial_no_ := Pick_Customer_Order_API.Get_Column_Value_If_Unique(contract_, pick_list_no_, unique_line_id_, order_no_, 
                                                                                          line_no_, rel_no_, line_item_no_, part_no_, NULL, NULL, NULL, NULL, NULL, 
                                                                                          configuration_id_, NULL, NULL, NULL, NULL, shipment_id_, data_item_id_);
            ELSE 
               pick_line_serial_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                                     serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, 
                                                                     res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,shipment_id_, barcode_id_, data_item_id_);
            END IF;
         END IF;

         IF (data_item_id_ = 'PICK_LIST_NO' AND order_no_ IS NULL AND line_no_ IS NULL AND rel_no_ IS NULL AND line_item_no_ IS NULL AND part_no_ IS NULL
             AND unique_line_id_ IS NULL AND shipment_id_ IS NULL) AND -- if pick by choice functionality is allowed, pick_list_no can not be fetched based on stock keys.
             ((location_no_ IS NULL AND serial_no_ IS NULL AND lot_batch_no_ IS NULL) OR 
              (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED))  THEN  
               Pick_Customer_Order_API.Create_Data_Capture_Lov(contract_           => contract_, 
                                                               capture_session_id_ => capture_session_id_,
                                                               lov_type_db_        => lov_type_db_);
         -- Note: If the pick_list_serial_no_ is not '*', that means serials have been identified.     
         ELSIF (data_item_id_ = 'SERIAL_NO' AND Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND
                Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING AND pick_line_serial_no_ = '*') THEN
            customer_no_ := Customer_Order_Line_API.Get_Owner_For_Part_Ownership(order_no_, line_no_, rel_no_, line_item_no_, Part_Ownership_API.DB_CUSTOMER_OWNED); 
            Temporary_Part_Tracking_API.Create_Data_Capture_Lov(contract_           => contract_, 
                                                                part_no_            => part_no_,
                                                                serial_no_          => NULL,
                                                                lot_batch_no_       => lot_batch_no_, 
                                                                configuration_id_   => configuration_id_, 
                                                                capture_session_id_ => capture_session_id_,
                                                                column_name_        => data_item_id_,
                                                                lov_type_db_        => lov_type_db_,
                                                                customer_no_        => customer_no_);
         ELSIF (data_item_id_ = 'BARCODE_ID' OR 
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
            ELSE
               column_name_ := data_item_id_;
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
         ELSE
            IF (data_item_id_ = 'RES_HANDLING_UNIT_ID') THEN
               column_name_ := 'HANDLING_UNIT_ID';
            ELSIF (data_item_id_ = 'RES_SSCC') THEN
               column_name_ := 'SSCC';
            ELSIF (data_item_id_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
               column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
            ELSIF (data_item_id_ = 'UNIQUE_LINE_ID') THEN
               column_name_ := 'CUST_ORD_RESERVATION_OBJID';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN

               -- Need to check if this process is run standalone or if its run together with START_PICKING. If START_PICKING is 
               -- the previous session this process is run together with START_PICKING. Then we need to change the lov_id_ so we can 
               -- break the normal sorting and exchange it with route order sorting so location and handling units will be grouped together better.
               session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
               IF (Data_Capture_Session_API.Get_Capture_Process_Id(session_rec_.previous_capture_session_id ) = 'START_PICKING') THEN
                  lov_id_ := 2;
               END IF; 
               
               Pick_Customer_Order_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                               pick_list_no_               => pick_list_no_,
                                                               unique_line_id_             => unique_line_id_,
                                                               order_no_                   => order_no_,
                                                               line_no_                    => line_no_,
                                                               rel_no_                     => rel_no_,
                                                               line_item_no_               => line_item_no_,
                                                               part_no_                    => part_no_,
                                                               location_no_                => location_no_,
                                                               serial_no_                  => serial_no_,
                                                               lot_batch_no_               => lot_batch_no_,
                                                               waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                               eng_chg_level_              => eng_chg_level_,
                                                               configuration_id_           => configuration_id_, 
                                                               activity_seq_               => activity_seq_,
                                                               handling_unit_id_           => res_handling_unit_id_,
                                                               sscc_                       => res_sscc_,
                                                               alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                               shipment_id_                => shipment_id_,
                                                               capture_session_id_         => capture_session_id_, 
                                                               column_name_                => column_name_,
                                                               data_item_id_               => data_item_id_,
                                                               lov_type_db_                => lov_type_db_,
                                                               lov_id_                     => lov_id_);

            ELSIF (data_item_id_ IN ('LOCATION_NO', 'WAIV_DEV_REJ_NO', 'ACTIVITY_SEQ', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL',
                                     'SERIAL_NO', 'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN 
               Inventory_Part_In_Stock_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                                   part_no_                    => part_no_,
                                                                   configuration_id_           => configuration_id_, 
                                                                   location_no_                => location_no_,
                                                                   lot_batch_no_               => lot_batch_no_,
                                                                   serial_no_                  => serial_no_,
                                                                   eng_chg_level_              => eng_chg_level_,
                                                                   waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                                   activity_seq_               => activity_seq_,
                                                                   handling_unit_id_           => res_handling_unit_id_,
                                                                   alt_handling_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                                   capture_session_id_         => capture_session_id_, 
                                                                   column_name_                => column_name_,
                                                                   lov_type_db_                => lov_type_db_,
                                                                   sql_where_expression_       => Get_Pick_By_Choice_Whr_Expr___(capture_session_id_, pick_list_no_, order_no_, line_no_, rel_no_, line_item_no_, unique_line_id_, pick_by_choice_option_, data_item_id_),
                                                                   data_item_id_               => data_item_id_); 
            ELSE
               -- Need to check if this process is run standalone or if its run together with START_PICKING. If START_PICKING is 
               -- the previous session this process is run together with START_PICKING. Then we need to change the lov_id_ so we can 
               -- break the normal sorting and exchange it with route order sorting so location and handling units will be grouped together better.
               session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
               IF (Data_Capture_Session_API.Get_Capture_Process_Id(session_rec_.previous_capture_session_id ) = 'START_PICKING') THEN
                  lov_id_ := 2;
               END IF;
               -- Added lov_id_ to parameter list to make sure we use the correct lov with the correct sorting when coming from start picking process
               Pick_Customer_Order_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                               pick_list_no_               => pick_list_no_,
                                                               unique_line_id_             => unique_line_id_,
                                                               order_no_                   => order_no_,
                                                               line_no_                    => line_no_,
                                                               rel_no_                     => rel_no_,
                                                               line_item_no_               => line_item_no_,
                                                               part_no_                    => part_no_,
                                                               location_no_                => NULL,
                                                               serial_no_                  => NULL,
                                                               lot_batch_no_               => NULL,
                                                               waiv_dev_rej_no_            => NULL,
                                                               eng_chg_level_              => NULL,
                                                               configuration_id_           => configuration_id_, 
                                                               activity_seq_               => NULL,
                                                               handling_unit_id_           => NULL,
                                                               sscc_                       => string_all_values_,
                                                               alt_handling_unit_label_id_ => string_all_values_,
                                                               shipment_id_                => shipment_id_,
                                                               capture_session_id_         => capture_session_id_, 
                                                               column_name_                => column_name_,
                                                               data_item_id_               => data_item_id_,
                                                               lov_type_db_                => lov_type_db_,
                                                               lov_id_                     => lov_id_);
            END IF;
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
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PICKOK: The report of picking was saved.');
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'PICKSOK: :P1 reports of picking were saved.', NULL, no_of_records_handled_);
   END IF;
   RETURN message_;
END Get_Process_Execution_Message;


FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                    VARCHAR2(5);
   pick_list_no_                VARCHAR2(15);
   unique_line_id_              CUSTOMER_ORDER_RESERVATION.objid%TYPE;
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   rel_no_                      VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   activity_seq_                NUMBER;
   shipment_id_                 NUMBER;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   barcode_id_                  NUMBER;
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   automatic_value_             VARCHAR2(200);
   warehouse_task_id_           NUMBER;
   qty_left_to_pick_            NUMBER;
   qty_picked_                  NUMBER;
   hu_sql_where_expression_     VARCHAR2(2000);
   zero_pick_serial_            BOOLEAN;
   partial_pick_ship_inv_       BOOLEAN;
   dummy_                       BOOLEAN;
   column_name_                 VARCHAR2(30);
   local_shipment_id_           NUMBER;
   local_shp_handling_unit_id_  NUMBER;
   local_shp_sscc_              VARCHAR2(18);
   local_alt_hu_label_id_       VARCHAR2(25);
   pick_by_choice_option_       VARCHAR2(20);
   uses_shipment_inventory_     NUMBER := 0;
   allow_partial_picking_       BOOLEAN := FALSE;
   gtin_no_                     VARCHAR2(14);
   input_uom_                   VARCHAR2(30);
   input_uom_group_id_          VARCHAR2(30);
   input_qty_                   NUMBER;
   input_conv_factor_           NUMBER; 
   reserve_rec_                 Customer_Order_Reservation_API.Public_Rec;
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

         IF (data_item_id_ IN ('BARCODE_ID', 'SHIP_LOCATION_NO', 'QTY_PICKED')) THEN
            -- We need a complete set of filter keys fetched with unique handling so we can find a possible unique barcode and filter it correctly
            Get_Filter_Keys___(contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                               serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                               shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_, data_item_value_ => NULL, use_unique_values_ => TRUE);
         ELSE
            Get_Filter_Keys___(contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                               serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                               shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                               capture_session_id_, data_item_id_);
         END IF;
         pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_);

         IF (data_item_id_ = 'PICK_LIST_NO') THEN
            warehouse_task_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                    data_item_id_a_     => 'WAREHOUSE_TASK_ID',
                                                                                    data_item_id_b_     => data_item_id_);
            IF (warehouse_task_id_ IS NOT NULL) THEN
               automatic_value_ := Warehouse_Task_API.Get_Source_Ref1(warehouse_task_id_);
            ELSE -- If Pick by choice is allowed the method Get_Unique_Data_Item_Value___ will ignore the stock keys when retrive the unique value
               automatic_value_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                                 serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, 
                                                                 res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_,shipment_id_, barcode_id_, data_item_id_);
            END IF;
         ELSIF (data_item_id_ = 'BARCODE_ID') THEN
            automatic_value_ := barcode_id_;
         ELSIF (data_item_id_ IN ('UNIQUE_LINE_ID', 'ORDER_NO', 'LINE_NO', 'REL_NO', 'LINE_ITEM_NO', 'LOCATION_NO', 'PART_NO', 'WAIV_DEV_REJ_NO', 
                                  'ACTIVITY_SEQ', 'LOT_BATCH_NO', 'ENG_CHG_LEVEL', 'CONFIGURATION_ID', 'SHIPMENT_ID', 'SERIAL_NO',
                                  'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            -- If Pick by choice is allowed the method Get_Unique_Data_Item_Value___ will ignore the stock keys when retrive the none stock keys and 
            -- if data_item_id_ is one of stock keys it will be handled by method Inventory_Part_In_Stock_API.Get_Column_Value_If_Unique
            automatic_value_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                                                              serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, 
                                                              res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, barcode_id_, data_item_id_);
            IF (data_item_id_ = 'SERIAL_NO' AND Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND automatic_value_ = '*') THEN
               automatic_value_ := NULL;
            END IF;
   
         ELSIF data_item_id_ = 'SHIP_LOCATION_NO' THEN
            automatic_value_ := Get_Ship_Location_No___(shipment_id_, contract_, pick_list_no_);
         ELSIF (data_item_id_ = 'QTY_PICKED') THEN
            IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE) THEN
               -- if part is serial tracked (both in inventory and at receipt and issue) it will always have quantity 1
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
                  automatic_value_ := Customer_Order_Reservation_API.Get_Qty_Assigned(order_no_         => order_no_,
                                                                                      line_no_          => line_no_,
                                                                                      rel_no_           => rel_no_,
                                                                                      line_item_no_     => line_item_no_,
                                                                                      contract_         => contract_, 
                                                                                      part_no_          => part_no_, 
                                                                                      location_no_      => location_no_, 
                                                                                      lot_batch_no_     => lot_batch_no_,
                                                                                      serial_no_        => serial_no_, 
                                                                                      eng_chg_level_    => eng_chg_level_, 
                                                                                      waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                                                      activity_seq_     => activity_seq_, 
                                                                                      handling_unit_id_ => res_handling_unit_id_, 
                                                                                      configuration_id_ => configuration_id_,
                                                                                      pick_list_no_     => pick_list_no_, 
                                                                                      shipment_id_      => shipment_id_); 
               END IF;
            END IF; 
         ELSIF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
            local_shipment_id_          := shipment_id_;
            local_shp_handling_unit_id_ := shp_handling_unit_id_;
            local_shp_sscc_             := shp_sscc_;
            local_alt_hu_label_id_      := shp_alt_handl_unit_label_id_;
            Get_Handling_Unit_Filters___(local_shipment_id_, local_shp_handling_unit_id_, local_shp_sscc_, local_alt_hu_label_id_, hu_sql_where_expression_, capture_session_id_, data_item_id_);
            IF (Skip_Handling_Unit___(capture_session_id_, data_item_id_, shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_)) THEN
               automatic_value_ := 'NULL';
            ELSE
               IF (data_item_id_ = 'SHP_HANDLING_UNIT_ID') THEN
                  column_name_ := 'HANDLING_UNIT_ID';
               ELSIF (data_item_id_ = 'SHP_SSCC') THEN
                  column_name_ := 'SSCC';
               ELSIF (data_item_id_ = 'SHP_ALT_HANDLING_UNIT_LABEL_ID') THEN
                  column_name_ := 'ALT_HANDLING_UNIT_LABEL_ID';
               ELSE
                  column_name_ := data_item_id_;
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
            END IF;
         ELSIF (data_item_id_ = 'RELEASE_RESERVATION') THEN
            qty_picked_            := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'QTY_PICKED', session_rec_);
            IF qty_picked_ IS NOT NULL  THEN 
               IF (pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) AND (unique_line_id_ IS NOT NULL) THEN
                  reserve_rec_      := Customer_Order_Reservation_API.Get_Object_By_Id(unique_line_id_);
                  qty_left_to_pick_ := Customer_Order_Reservation_API.Get_Qty_Left_To_Pick(reserve_rec_.order_no, reserve_rec_.line_no, 
                                                                                           reserve_rec_.rel_no, reserve_rec_.line_item_no, 
                                                                                           reserve_rec_.contract, reserve_rec_.part_no, 
                                                                                           reserve_rec_.location_no, reserve_rec_.lot_batch_no, 
                                                                                           reserve_rec_.eng_chg_level, reserve_rec_.waiv_dev_rej_no, 
                                                                                           reserve_rec_.activity_seq, reserve_rec_.handling_unit_id, 
                                                                                           reserve_rec_.configuration_id, reserve_rec_.pick_list_no, 
                                                                                           reserve_rec_.shipment_id); 
                                                                                           
               ELSE 
                  qty_left_to_pick_ := Customer_Order_Reservation_API.Get_Qty_Left_To_Pick(order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, location_no_, lot_batch_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, res_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_); 
               END IF;
               zero_pick_serial_        := (Part_Catalog_API.Serial_Tracked_In_Inventory(part_no_) AND qty_picked_ = 0);
               uses_shipment_inventory_ := Handle_Ship_Invent_Utility_API.Uses_Shipment_Inventory(pick_list_no_   => pick_list_no_, 
                                                                                                  pick_list_type_ => 'CUST_ORDER_PICK_LIST'); 
               partial_pick_ship_inv_   := (uses_shipment_inventory_ = 1) AND (shipment_id_ IS NOT NULL) AND (qty_picked_ < qty_left_to_pick_);
   
               IF uses_shipment_inventory_ = 1 THEN 
                  IF shipment_id_ IS NOT NULL THEN 
                     allow_partial_picking_ := Shipment_Type_API.Get_Allow_Partial_Picking_Db(Shipment_API.Get_Shipment_Type(shipment_id_)) = Fnd_Boolean_API.DB_TRUE;
                  ELSE
                     allow_partial_picking_ := Cust_Order_Type_API.Get_Allow_Partial_Picking_Db(Customer_Order_API.Get_Order_Id(order_no_)) = Fnd_Boolean_API.DB_TRUE;                                                                                                   
                  END IF;
               END IF;
               -- If no partial allowed no matter if we have under picking or we pick whole reservation release would be yes except when 
               -- pick by chioce is allowed.            
               IF (NOT allow_partial_picking_) THEN
                  IF (partial_pick_ship_inv_ AND pick_by_choice_option_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
                     automatic_value_ := Gen_Yes_No_API.DB_NO;
                  ELSIF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN 
                     automatic_value_ := Gen_Yes_No_API.DB_YES;
                  END IF;
               ELSIF (zero_pick_serial_ OR partial_pick_ship_inv_) THEN
                  automatic_value_ := NULL;
               ELSE
                  automatic_value_ := Gen_Yes_No_API.DB_NO;
               END IF;
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
         ELSE
            automatic_value_ := Data_Capture_Invent_Util_API.Get_Automatic_Data_Item_Value(data_item_id_, contract_, part_no_);
         END IF;
      END IF;

      RETURN automatic_value_;
   $ELSE
      RETURN NULL;
   $END
END Get_Automatic_Data_Item_Value;


PROCEDURE Set_Media_Id_For_Data_Item  (
   capture_session_id_ IN NUMBER,
   line_no_            IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
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
   pick_list_no_                VARCHAR2(15);
   unique_line_id_              CUSTOMER_ORDER_RESERVATION.objid%TYPE;
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   rel_no_                      VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   activity_seq_                NUMBER;
   shipment_id_                 NUMBER;
   barcode_id_                  NUMBER;
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   condition_code_              VARCHAR2(10);
   qty_left_to_pick_            NUMBER;
   last_line_on_pick_list_      VARCHAR2(5) := Gen_Yes_No_API.DB_NO;
   release_reservation_         VARCHAR2(5);
   qty_to_pick_                 NUMBER;
   ship_location_no_            VARCHAR2(35);
   pick_by_choice_allowed_      BOOLEAN;
   reserve_rec_                 Customer_Order_Reservation_API.Public_Rec;
   uses_shipment_inventory_     NUMBER := 0;
   allow_partial_picking_       BOOLEAN := FALSE;
   gtin_no_                     VARCHAR2(14); 
   pick_by_choice_details_      VARCHAR2(5); 
   use_unique_values_           BOOLEAN := TRUE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      pick_by_choice_allowed_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(session_rec_.session_contract) != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED;
      pick_by_choice_details_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'PICK_BY_CHOICE_DETAILS');
      IF (pick_by_choice_allowed_ AND pick_by_choice_details_ = Fnd_Boolean_API.DB_TRUE) THEN
         -- Turning off use unique values for performance reasons.
         use_unique_values_ := FALSE;
      END IF;

      Get_Filter_Keys___(contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                         serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                         shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                         capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_);

      IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL THEN
         reserve_rec_ := Customer_Order_Reservation_API.Get_Object_By_Id(unique_line_id_);
      END IF;
      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('PICK_LIST_NO', 'UNIQUE_LINE_ID', 'ORDER_NO', 'LINE_NO', 'LINE_ITEM_NO', 'PART_NO', 
                                                                    'LOCATION_NO', 'SERIAL_NO', 'LOT_BATCH_NO', 'WAIV_DEV_REJ_NO', 'ENG_CHG_LEVEL', 
                                                                    'CONFIGURATION_ID', 'ACTIVITY_SEQ', 'SHIPMENT_ID', 'BARCODE_ID', 
                                                                    'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID',
                                                                    'RES_HANDLING_UNIT_ID', 'RES_SSCC', 'RES_ALT_HANDLING_UNIT_LABEL_ID', 'GTIN')) THEN

                  -- The res_alt_handl_unit_label_id_ and res_sscc_ will be % if not scanned yet
                  res_alt_handl_unit_label_id_ := CASE res_alt_handl_unit_label_id_ WHEN '%' THEN NULL ELSE res_alt_handl_unit_label_id_ END;
                  res_sscc_                    := CASE res_sscc_ WHEN '%' THEN NULL ELSE res_sscc_ END;

                  IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL THEN 
                     -- Data Items that are part of the filter keys
                     Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                              owning_data_item_id_         => latest_data_item_id_,
                                              data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                              pick_list_no_                => pick_list_no_,
                                              unique_line_id_              => unique_line_id_,
                                              order_no_                    => order_no_,
                                              line_no_                     => line_no_,
                                              rel_no_                      => rel_no_,
                                              line_item_no_                => line_item_no_,
                                              part_no_                     => nvl(part_no_, reserve_rec_.part_no),
                                              location_no_                 => nvl(location_no_, reserve_rec_.location_no),
                                              serial_no_                   => nvl(serial_no_,reserve_rec_.serial_no),
                                              lot_batch_no_                => nvl(lot_batch_no_,reserve_rec_.lot_batch_no),    
                                              waiv_dev_rej_no_             => nvl(waiv_dev_rej_no_,reserve_rec_.waiv_dev_rej_no),
                                              eng_chg_level_               => nvl(eng_chg_level_,reserve_rec_.eng_chg_level),
                                              configuration_id_            => configuration_id_,
                                              activity_seq_                => nvl(activity_seq_,reserve_rec_.activity_seq),
                                              shp_handling_unit_id_        => shp_handling_unit_id_,
                                              shp_sscc_                    => shp_sscc_,
                                              shp_alt_handl_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                              res_handling_unit_id_        => nvl(res_handling_unit_id_, reserve_rec_.handling_unit_id),
                                              res_sscc_                    => nvl(res_sscc_, Handling_Unit_API.Get_Sscc(reserve_rec_.handling_unit_id)),
                                              res_alt_handl_unit_label_id_ => nvl(res_alt_handl_unit_label_id_, Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(reserve_rec_.handling_unit_id)),
                                              shipment_id_                 => shipment_id_,
                                              barcode_id_                  => barcode_id_,
                                              gtin_no_                     => gtin_no_);
                  ELSE 
                     -- Data Items that are part of the filter keys
                     Add_Filter_Key_Detail___(capture_session_id_          => capture_session_id_,
                                              owning_data_item_id_         => latest_data_item_id_,
                                              data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                              pick_list_no_                => pick_list_no_,
                                              unique_line_id_              => unique_line_id_,
                                              order_no_                    => order_no_,
                                              line_no_                     => line_no_,
                                              rel_no_                      => rel_no_,
                                              line_item_no_                => line_item_no_,
                                              part_no_                     => part_no_,
                                              location_no_                 => location_no_,
                                              serial_no_                   => serial_no_,
                                              lot_batch_no_                => lot_batch_no_,    
                                              waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                              eng_chg_level_               => eng_chg_level_,
                                              configuration_id_            => configuration_id_,
                                              activity_seq_                => activity_seq_,
                                              shp_handling_unit_id_        => shp_handling_unit_id_,
                                              shp_sscc_                    => shp_sscc_,
                                              shp_alt_handl_unit_label_id_ => shp_alt_handl_unit_label_id_,
                                              res_handling_unit_id_        => res_handling_unit_id_,
                                              res_sscc_                    => res_sscc_,
                                              res_alt_handl_unit_label_id_ => res_alt_handl_unit_label_id_,
                                              shipment_id_                 => shipment_id_,
                                              barcode_id_                  => barcode_id_,
                                              gtin_no_                     => gtin_no_);
                  END IF;
               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_          => capture_session_id_,
                                                 session_rec_                 => session_rec_,
                                                 owning_data_item_id_         => latest_data_item_id_,
                                                 owning_data_item_value_      => latest_data_item_value_,
                                                 data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                                 contract_                    => contract_,
                                                 pick_list_no_                => pick_list_no_,
                                                 unique_line_id_              => unique_line_id_,
                                                 order_no_                    => order_no_,
                                                 line_no_                     => line_no_,
                                                 rel_no_                      => rel_no_,
                                                 line_item_no_                => line_item_no_,
                                                 part_no_                     => part_no_,
                                                 location_no_                 => location_no_,
                                                 serial_no_                   => serial_no_,
                                                 lot_batch_no_                => lot_batch_no_,    
                                                 waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                 eng_chg_level_               => eng_chg_level_,
                                                 configuration_id_            => configuration_id_,
                                                 activity_seq_                => activity_seq_,
                                                 res_handling_unit_id_        => res_handling_unit_id_,
                                                 res_sscc_                    => res_sscc_,
                                                 res_alt_handl_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                 shipment_id_                 => shipment_id_,
                                                 barcode_id_                  => barcode_id_);
               END IF;
            ELSE  -- FEEDBACK ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('QTY_TO_PICK')) THEN
                  Add_Unique_Data_Item_Detail___(capture_session_id_          => capture_session_id_,
                                                 session_rec_                 => session_rec_,
                                                 owning_data_item_id_         => latest_data_item_id_,
                                                 owning_data_item_value_      => latest_data_item_value_,
                                                 data_item_detail_id_         => conf_item_detail_tab_(i).data_item_detail_id,
                                                 contract_                    => contract_,
                                                 pick_list_no_                => pick_list_no_,
                                                 unique_line_id_              => unique_line_id_,
                                                 order_no_                    => order_no_,
                                                 line_no_                     => line_no_,
                                                 rel_no_                      => rel_no_,
                                                 line_item_no_                => line_item_no_,
                                                 part_no_                     => part_no_,
                                                 location_no_                 => location_no_,
                                                 serial_no_                   => serial_no_,
                                                 lot_batch_no_                => lot_batch_no_,    
                                                 waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                 eng_chg_level_               => eng_chg_level_,
                                                 configuration_id_            => configuration_id_,
                                                 activity_seq_                => activity_seq_,
                                                 res_handling_unit_id_        => res_handling_unit_id_,
                                                 res_sscc_                    => res_sscc_,
                                                 res_alt_handl_unit_label_id_ => res_alt_handl_unit_label_id_,
                                                 shipment_id_                 => shipment_id_,
                                                 barcode_id_                  => barcode_id_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID',
                                                                       'RECEIPTS_BLOCKED', 'MIX_OF_PART_NUMBER_BLOCKED', 'MIX_OF_CONDITION_CODES_BLOCKED',
                                                                       'MIX_OF_LOT_BATCH_NO_BLOCKED', 'LOCATION_GROUP', 'LOCATION_NO_DESC', 'LOCATION_TYPE')) THEN
                  IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL AND location_no_ IS NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                              owning_data_item_id_ => latest_data_item_id_, 
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              contract_            => contract_, 
                                                                              location_no_         => reserve_rec_.location_no);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                              owning_data_item_id_ => latest_data_item_id_, 
                                                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                              contract_            => contract_, 
                                                                              location_no_         => location_no_);
                  END IF;

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PART_DESCRIPTION', 'UNIT_MEAS', 'CATCH_UNIT_MEAS', 'NET_WEIGHT', 'NET_VOLUME', 
                                                                       'CATCH_UNIT_MEAS', 'CATCH_UNIT_MEAS_DESCRIPTION', 'UNIT_MEAS', 'UNIT_MEAS_DESCRIPTION', 
                                                                       'PART_TYPE', 'PRIME_COMMODITY', 'PRIME_COMMODITY_DESCRIPTION', 'SECOND_COMMODITY', 
                                                                       'SECOND_COMMODITY_DESCRIPTION', 'ASSET_CLASS', 'ASSET_CLASS_DESCRIPTION', 'PART_STATUS', 
                                                                       'PART_STATUS_DESCRIPTION', 'ABC_CLASS', 'ABC_CLASS_PERCENT', 'SAFETY_CODE', 
                                                                       'SAFETY_CODE_DESCRIPTION', 'ACCOUNTING_GROUP', 'ACCOUNTING_GROUP_DESCRIPTION', 'PRODUCT_CODE',
                                                                       'PRODUCT_CODE_DESCRIPTION', 'PRODUCT_FAMILY', 'PRODUCT_FAMILY_DESCRIPTION', 'OWNER',
                                                                       'SERIAL_TRACKING_RECEIPT_ISSUE','SERIAL_TRACKING_INVENTORY', 'SERIAL_TRACKING_DELIVERY', 
                                                                       'STOP_ARRIVAL_ISSUED_SERIAL', 'STOP_NEW_SERIAL_IN_RMA', 'SERIAL_RULE', 'LOT_BATCH_TRACKING', 
                                                                       'LOT_QUANTITY_RULE', 'SUB_LOT_RULE', 'COMPONENT_LOT_RULE', 'GTIN_IDENTIFICATION', 'GTIN_DEFAULT', 'INPUT_CONV_FACTOR')) THEN
                  
                  IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL AND part_no_ IS NULL THEN                                                      
                     Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_  => capture_session_id_,
                                                                          owning_data_item_id_ => latest_data_item_id_,
                                                                          data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          contract_            => contract_,
                                                                          part_no_             => reserve_rec_.part_no);
                  ELSE
                     Data_Capture_Invent_Util_API.Add_Details_For_Part_No(capture_session_id_  => capture_session_id_,
                                                                          owning_data_item_id_ => latest_data_item_id_,
                                                                          data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          contract_            => contract_,
                                                                          part_no_             => part_no_);
                  END IF;
                                                                       
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('QUANTITY_ONHAND', 'OWNER', 'CATCH_QUANTITY_ONHAND')) THEN
                  IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL AND location_no_ IS NULL AND lot_batch_no_ IS NULL AND 
                     serial_no_ IS NULL AND eng_chg_level_ IS NULL AND waiv_dev_rej_no_ IS NULL AND activity_seq_ IS NULL AND res_handling_unit_id_ IS NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Details_For_Inv_Stock_Rec(capture_session_id_  => capture_session_id_,
                                                                                owning_data_item_id_ => latest_data_item_id_,
                                                                                data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                contract_            => contract_,
                                                                                part_no_             => part_no_,
                                                                                configuration_id_    => configuration_id_,
                                                                                location_no_         => reserve_rec_.location_no,
                                                                                lot_batch_no_        => reserve_rec_.lot_batch_no,
                                                                                serial_no_           => reserve_rec_.serial_no,
                                                                                eng_chg_level_       => reserve_rec_.eng_chg_level,
                                                                                waiv_dev_rej_no_     => reserve_rec_.waiv_dev_rej_no,
                                                                                activity_seq_        => reserve_rec_.activity_seq,
                                                                                handling_unit_id_    => reserve_rec_.handling_unit_id);
                  ELSE 
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
                                                                                handling_unit_id_    => res_handling_unit_id_);
                  END IF;

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PROGRAM_ID', 'PROGRAM_DESCRIPTION', 'PROJECT_ID', 'PROJECT_NAME', 'SUB_PROJECT_ID',
                                                                       'SUB_PROJECT_DESCRIPTION', 'ACTIVITY_ID', 'ACTIVITY_DESCRIPTION')) THEN

                  IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL AND activity_seq_ IS NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Details_For_Activity_Seq(capture_session_id_  => capture_session_id_,
                                                                               owning_data_item_id_ => latest_data_item_id_,
                                                                               data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                               activity_seq_        => reserve_rec_.activity_seq);
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Activity_Seq(capture_session_id_  => capture_session_id_,
                                                                               owning_data_item_id_ => latest_data_item_id_,
                                                                               data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                               activity_seq_        => activity_seq_);
                  END IF ;
                  

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CUSTOMER_NO','CUSTOMER_NAME', 'WANTED_DELIVERY_DATE', 'ORDER_TYPE',
                                                                       'ORDER_TYPE_DESCRIPTION', 'ORDER_STATUS', 'ORDER_COORDINATOR', 'ORDER_PRIORITY',
                                                                       'ORDER_REFERENCE', 'ORDER_REFERENCE_NAME', 'CUSTOMER_PO_NO')) THEN
                  
                  Data_Capture_Order_Util_API.Add_Details_For_Order_No(capture_session_id_  => capture_session_id_,
                                                                       owning_data_item_id_ => latest_data_item_id_,
                                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       order_no_            => order_no_);
                  
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('LINE_SALES_PART', 'LINE_SALES_PART_DESCRIPTION', 'LINE_WANTED_DELIVERY_DATE', 
                                                                       'LINE_TARGET_DATE', 'LINE_PLANNED_DELIVERY_DATE', 'LINE_PROMISED_DELIVERY_DATE', 
                                                                       'LINE_PLANNED_SHIP_DATE', 'LINE_PLANNED_DUE_DATE', 'LINE_CREATED', 'CONDITION_CODE')) THEN
                                                                          
                  Data_Capture_Order_Util_API.Add_Details_For_CO_Line(capture_session_id_  => capture_session_id_,
                                                                      owning_data_item_id_ => latest_data_item_id_,
                                                                      data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                      order_no_            => order_no_,
                                                                      line_no_             => line_no_,
                                                                      rel_no_              => rel_no_,
                                                                      line_item_no_        => line_item_no_);
                                                                      
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('CONDITION_CODE_DESCRIPTION')) THEN
                  
                  condition_code_ := Customer_Order_Line_API.Get_Condition_Code(order_no_, line_no_, rel_no_, line_item_no_);
                  Data_Capture_Invent_Util_API.Add_Condition_Code_Desc(capture_session_id_  => capture_session_id_,
                                                                       owning_data_item_id_ => latest_data_item_id_,
                                                                       data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                       condition_code_      => condition_code_);

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'LAST_LINE_ON_PICK_LIST') THEN                   
                  IF (Customer_Order_Reservation_API.Get_Number_Of_Lines_To_Pick(pick_list_no_) = 1) THEN
                     -- if lines left to pick = 1 then this is the last line to pick on the picklist,
                     -- but if the part is serial tracked at receipt and issue and not serial tracked in inventory
                     -- we need to check how much is left to pick to set last_line_on_pick_list_ correctly
                     IF ((Part_Catalog_API.Get_Receipt_Issue_Serial_Tr_Db(part_no_) = Fnd_Boolean_API.DB_TRUE) AND 
                         (Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING)) THEN 
                        IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL THEN  
                           qty_left_to_pick_ := Customer_Order_Reservation_API.Get_Qty_Left_To_Pick(order_no_         => order_no_,
                                                                                                    line_no_          => line_no_,
                                                                                                    rel_no_           => rel_no_,
                                                                                                    line_item_no_     => line_item_no_,
                                                                                                    contract_         => contract_,
                                                                                                    part_no_          => part_no_,
                                                                                                    location_no_      => reserve_rec_.location_no,
                                                                                                    lot_batch_no_     => reserve_rec_.lot_batch_no,    
                                                                                                    eng_chg_level_    => reserve_rec_.eng_chg_level,
                                                                                                    waiv_dev_rej_no_  => reserve_rec_.waiv_dev_rej_no,
                                                                                                    activity_seq_     => reserve_rec_.activity_seq,
                                                                                                    handling_unit_id_ => reserve_rec_.handling_unit_id, 
                                                                                                    configuration_id_ => configuration_id_,
                                                                                                    pick_list_no_     => pick_list_no_,
                                                                                                    shipment_id_      => shipment_id_);
                        ELSIF NOT pick_by_choice_allowed_ THEN  
                           qty_left_to_pick_ := Customer_Order_Reservation_API.Get_Qty_Left_To_Pick(order_no_         => order_no_,
                                                                                                    line_no_          => line_no_,
                                                                                                    rel_no_           => rel_no_,
                                                                                                    line_item_no_     => line_item_no_,
                                                                                                    contract_         => contract_,
                                                                                                    part_no_          => part_no_,
                                                                                                    location_no_      => location_no_,
                                                                                                    lot_batch_no_     => lot_batch_no_,    
                                                                                                    eng_chg_level_    => eng_chg_level_,
                                                                                                    waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                                    activity_seq_     => activity_seq_,
                                                                                                    handling_unit_id_ => res_handling_unit_id_, 
                                                                                                    configuration_id_ => configuration_id_,
                                                                                                    pick_list_no_     => pick_list_no_,
                                                                                                    shipment_id_      => shipment_id_);
                           
                        END IF ;
                        IF qty_left_to_pick_  IS NULL THEN 
                           last_line_on_pick_list_ := NULL;
                        ELSIF (qty_left_to_pick_ > 1) THEN 
                           last_line_on_pick_list_ := Gen_Yes_No_API.DB_NO;
                        ELSE
                           last_line_on_pick_list_ := Gen_Yes_No_API.DB_YES;
                        END IF;
                     ELSE
                        release_reservation_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                                  data_item_id_a_     => 'RELEASE_RESERVATION',
                                                                                                  data_item_id_b_     => latest_data_item_id_);
                        uses_shipment_inventory_ := Handle_Ship_Invent_Utility_API.Uses_Shipment_Inventory(pick_list_no_   => pick_list_no_, 
                                                                                                           pick_list_type_ => 'CUST_ORDER_PICK_LIST'); 
                        IF shipment_id_ IS NOT NULL THEN 
                           allow_partial_picking_ := Shipment_Type_API.Get_Allow_Partial_Picking_Db(Shipment_API.Get_Shipment_Type(shipment_id_)) = Fnd_Boolean_API.DB_TRUE;                                                                                                   
                        ELSE
                           allow_partial_picking_ := Cust_Order_Type_API.Get_Allow_Partial_Picking_Db(Customer_Order_API.Get_Order_Id(order_no_)) = Fnd_Boolean_API.DB_TRUE;
                        END IF;
                        
                        -- if partial picking is not allowed and pick by choice not allowed then no matter we under picked last line is true
                        IF uses_shipment_inventory_ = 1 AND NOT allow_partial_picking_ AND NOT pick_by_choice_allowed_ THEN 
                           last_line_on_pick_list_ := Gen_Yes_No_API.DB_YES;
                        ELSIF (release_reservation_ = Gen_Yes_No_API.DB_NO OR pick_by_choice_allowed_)  THEN
                           IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL THEN 
                              qty_left_to_pick_ := Customer_Order_Reservation_API.Get_Qty_Left_To_Pick(order_no_         => order_no_,
                                                                                                       line_no_          => line_no_,
                                                                                                       rel_no_           => rel_no_,
                                                                                                       line_item_no_     => line_item_no_,
                                                                                                       contract_         => contract_,
                                                                                                       part_no_          => part_no_,
                                                                                                       location_no_      => reserve_rec_.location_no,
                                                                                                       lot_batch_no_     => reserve_rec_.lot_batch_no,    
                                                                                                       eng_chg_level_    => reserve_rec_.eng_chg_level,
                                                                                                       waiv_dev_rej_no_  => reserve_rec_.waiv_dev_rej_no,
                                                                                                       activity_seq_     => reserve_rec_.activity_seq,
                                                                                                       handling_unit_id_ => reserve_rec_.handling_unit_id, 
                                                                                                       configuration_id_ => configuration_id_,
                                                                                                       pick_list_no_     => pick_list_no_,
                                                                                                       shipment_id_      => shipment_id_);
                           ELSIF NOT pick_by_choice_allowed_ THEN 
                              qty_left_to_pick_ := Customer_Order_Reservation_API.Get_Qty_Left_To_Pick(order_no_         => order_no_,
                                                                                                       line_no_          => line_no_,
                                                                                                       rel_no_           => rel_no_,
                                                                                                       line_item_no_     => line_item_no_,
                                                                                                       contract_         => contract_,
                                                                                                       part_no_          => part_no_,
                                                                                                       location_no_      => location_no_,
                                                                                                       lot_batch_no_     => lot_batch_no_,    
                                                                                                       eng_chg_level_    => eng_chg_level_,
                                                                                                       waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                                       activity_seq_     => activity_seq_,
                                                                                                       handling_unit_id_ => res_handling_unit_id_, 
                                                                                                       configuration_id_ => configuration_id_,
                                                                                                       pick_list_no_     => pick_list_no_,
                                                                                                       shipment_id_      => shipment_id_);

                           END IF ;
                           IF qty_left_to_pick_  IS NULL THEN 
                              last_line_on_pick_list_ := NULL;
                           ELSE 
                              qty_to_pick_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                                data_item_id_a_     => 'QTY_PICKED',
                                                                                                data_item_id_b_     => latest_data_item_id_);

                              IF (qty_to_pick_ < qty_left_to_pick_) THEN  
                                 -- if release_reservation is 'No' and only partially picked the last line then last line should be 'No'
                                 last_line_on_pick_list_ := Gen_Yes_No_API.DB_NO;
                              ELSE
                                 last_line_on_pick_list_ := Gen_Yes_No_API.DB_YES;
                              END IF;
                           END IF;
                        ELSE
                           last_line_on_pick_list_ := Gen_Yes_No_API.DB_YES;
                        END IF;
                     END IF;
                  END IF;
                  Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                                    data_item_id_        => latest_data_item_id_,
                                                    data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                    data_item_value_     => last_line_on_pick_list_);

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
                  IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                                 owning_data_item_id_ => latest_data_item_id_,
                                                                                 data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                 handling_unit_id_     => nvl(res_handling_unit_id_, reserve_rec_.handling_unit_id));
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Hand_Unit_Type(capture_session_id_  => capture_session_id_,
                                                                                 owning_data_item_id_ => latest_data_item_id_,
                                                                                 data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                 handling_unit_id_    => res_handling_unit_id_);
                  END IF;
                  

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
                  IF pick_by_choice_allowed_ AND unique_line_id_ IS NOT NULL THEN 
                     Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                                owning_data_item_id_  => latest_data_item_id_,
                                                                                data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                handling_unit_id_     => nvl(res_handling_unit_id_, reserve_rec_.handling_unit_id));
                  ELSE 
                     Data_Capture_Invent_Util_API.Add_Details_For_Handling_Unit(capture_session_id_   => capture_session_id_,
                                                                                owning_data_item_id_  => latest_data_item_id_,
                                                                                data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                                handling_unit_id_     => res_handling_unit_id_);
                  END IF;

               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIPMENT_TYPE', 'CUSTOMER_ADDRESS_ID', 'FORWARD_AGENT_ID', 'SHIP_VIA_CODE', 'RECEIVER_ID')) THEN
                  IF (NVL(shipment_id_, 0) != 0) THEN
                     Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_  => capture_session_id_,
                                                                           owning_data_item_id_ => latest_data_item_id_,
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           shipment_id_         => shipment_id_);
                  ELSE
                     Data_Capture_Order_Util_API.Add_Details_For_Order_No(capture_session_id_  => capture_session_id_,
                                                                          owning_data_item_id_ => latest_data_item_id_,
                                                                          data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                          order_no_            => order_no_);
                  END IF;
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('SHIP_LOCATION_NO_DESC')) THEN
                  ship_location_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                                              current_data_item_id_    => latest_data_item_id_,
                                                                                              current_data_item_value_ => latest_data_item_value_,
                                                                                              wanted_data_item_id_     => 'SHIP_LOCATION_NO');
                  
                  Data_Capture_Order_Util_API.Add_Details_For_Ship_Location(capture_session_id_   => capture_session_id_,
                                                                            owning_data_item_id_  => latest_data_item_id_,
                                                                            data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                                                            contract_             => contract_,
                                                                            shipment_id_          => shipment_id_,
                                                                            ship_location_no_     => ship_location_no_);
               ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('RECEIVER_ADDRESS_NAME')) THEN
                  IF (NVL(shipment_id_, 0) != 0) THEN
                     Data_Capture_Shpmnt_Util_API.Add_Details_For_Shipment(capture_session_id_  => capture_session_id_,
                                                                           owning_data_item_id_ => latest_data_item_id_,
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           shipment_id_         => shipment_id_);
                  ELSE 
                     Data_Capture_Order_Util_API.Add_Details_For_CO_Line(capture_session_id_  => capture_session_id_,
                                                                         owning_data_item_id_ => latest_data_item_id_,
                                                                         data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                         order_no_            => order_no_,
                                                                         line_no_             => line_no_,
                                                                         rel_no_              => rel_no_,
                                                                         line_item_no_        => line_item_no_);
                  END IF;   
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
   ptr_                         NUMBER;
   name_                        VARCHAR2(50);
   value_                       VARCHAR2(4000);
   pick_list_no_                VARCHAR2(15);
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   rel_no_                      VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   config_id_                   VARCHAR2(50) := '*';
   location_no_                 VARCHAR2(35);
   lot_batch_no_                VARCHAR2(20) := '*';
   serial_no_                   VARCHAR2(50) := '*';
   waiv_dev_rej_no_             VARCHAR2(15) := '*';
   eng_chg_level_               VARCHAR2(6) := '1';
   input_qty_                   NUMBER;
   input_conv_factor_           NUMBER;
   input_unit_meas_             VARCHAR2(30);
   input_variable_values_       VARCHAR2(2000);
   activity_seq_                NUMBER;
   shipment_id_                 NUMBER;
   shipment_line_no_            NUMBER;
   catch_qty_to_pick_           NUMBER;
   ship_location_no_            VARCHAR2(35);
   qty_to_pick_                 NUMBER;
   pickattr_                    VARCHAR2(32000);
   dummy_all_reported_          NUMBER;
   dummy_closed_lines_          NUMBER;
   dummy_overpicked_lines_      VARCHAR2(32000);
   dummy_session_id_            NUMBER;
   shp_handling_unit_id_        NUMBER;
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   release_reservation_         BOOLEAN;
   packing_location_            VARCHAR2(35);
   info_                        VARCHAR2(2000);
   pick_list_serial_no_         VARCHAR2(50);
   uses_shipment_inventory_     NUMBER := 0;
   old_qty_                     NUMBER;
   unique_line_id_              VARCHAR2(2000); 
   pick_clob_attr_              CLOB; 
   reserved_qty_                NUMBER;
   pick_by_choice_allowed_      BOOLEAN;
   add_hu_to_shipment_          BOOLEAN := TRUE;
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   reserve_rec_                 Customer_Order_Reservation_API.Public_Rec;
   order_line_rec_              Customer_Order_Line_API.Public_Rec;
   sales_qty_to_be_added_       NUMBER;
   shipment_id_message_         VARCHAR2(32000);
   max_weight_volume_error_     VARCHAR2(5);
   pbc_picked_reserved_record_  BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_            := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      pick_by_choice_allowed_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(contract_) != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED;
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ = 'PICK_LIST_NO') THEN
            pick_list_no_ := value_;
         ELSIF (name_ = 'ORDER_NO') THEN
            order_no_ := value_;
         ELSIF (name_ = 'LINE_NO') THEN
            line_no_ := value_;
         ELSIF (name_ = 'REL_NO') THEN
            rel_no_ := value_;
         ELSIF (name_ = 'LINE_ITEM_NO') THEN
            line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'PART_NO') THEN
            part_no_ := value_;
         ELSIF (name_ = 'CONFIGURATION_ID') THEN
            config_id_ := value_;
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
            activity_seq_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'CATCH_QTY_PICKED') THEN
            catch_qty_to_pick_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'SHIP_LOCATION_NO') THEN
            ship_location_no_ := value_;
         ELSIF (name_ = 'QTY_PICKED') THEN
            qty_to_pick_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'SHIPMENT_ID') THEN
            shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'SHP_HANDLING_UNIT_ID') THEN
            shp_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'RES_HANDLING_UNIT_ID') THEN
            res_handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'RES_SSCC') THEN
            res_sscc_ := value_;
         ELSIF (name_ = 'RES_ALT_HANDLING_UNIT_LABEL_ID') THEN
            res_alt_handl_unit_label_id_ := value_;
         ELSIF (name_ = 'RELEASE_RESERVATION') THEN
            release_reservation_ := (value_ = Gen_Yes_No_API.DB_YES);
         ELSIF (name_ = 'UNIQUE_LINE_ID') THEN
            unique_line_id_ := value_;
         END IF;
      END LOOP; 

      reserve_rec_ := Customer_Order_Reservation_API.Get_Object_By_Id(unique_line_id_);

      -- Doing some extra checks on ship_location_no
      uses_shipment_inventory_ := Handle_Ship_Invent_Utility_API.Uses_Shipment_Inventory(pick_list_no_   => pick_list_no_, 
                                                                                         pick_list_type_ => 'CUST_ORDER_PICK_LIST'); 
      IF (uses_shipment_inventory_ = 0 AND ship_location_no_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_,'SHIPLOCVALUE: Shipment Location No must be empty since Use Shipment Inventory is not set on the Pick List.');
      END IF;
      IF (uses_shipment_inventory_ = 1 AND ship_location_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'SHIPLOCNOVALUE: Shipment Location No must have value since Use Shipment Inventory is set on the Pick List.');
      END IF;

      -- Extra check on shipment Handling Unit Id check to prevent packing when there is qty pre-attached in shipment reservation for the order line.
      -- If pick by choice is enabled the stock keys might be different from the original reservation so we use reserve_rec_ to get the stock keys.
      IF (shp_handling_unit_id_ IS NOT NULL AND
          Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(order_no_, line_no_, rel_no_, line_item_no_, 'CUSTOMER_ORDER', contract_, part_no_, reserve_rec_.location_no, 
                                                                  reserve_rec_.lot_batch_no, reserve_rec_.serial_no, reserve_rec_.eng_chg_level, 
                                                                  reserve_rec_.waiv_dev_rej_no, reserve_rec_.activity_seq, reserve_rec_.handling_unit_id, 
                                                                  reserve_rec_.configuration_id, pick_list_no_, shipment_id_) > 0) THEN
         Error_SYS.Record_General(lu_name_,'PREATTACHEDEXIST: Shipment Handling Unit ID must be empty since packing is not allowed for order line with pre attached reservation in shipment.');
      END IF;
 
      -- Extra shipment checks to avoid getting popup error messages and handling this in our scanning client instead.
      -- If there is no pre-attached reservation on shipment handling unit, still we have to verify if qty to pick is not more than
      -- remaining qty to attach for shipment line
      IF (shp_handling_unit_id_ IS NOT NULL AND shipment_id_ != 0 AND qty_to_pick_ > 0) THEN
         shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_        => shipment_id_, 
                                                                             source_ref1_        => order_no_, 
                                                                             source_ref2_        => line_no_, 
                                                                             source_ref3_        => rel_no_, 
                                                                             source_ref4_        => line_item_no_, 
                                                                             source_ref_type_db_ => Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
         old_qty_ := NVL(Shipment_Line_Handl_Unit_API.Get_Quantity(shipment_id_, shipment_line_no_, shp_handling_unit_id_),0);
         Shipment_Line_Handl_Unit_API.Check_Quantity(shipment_id_      => shipment_id_,
                                                     shipment_line_no_ => shipment_line_no_,   
                                                     new_quantity_     => ((old_qty_ + qty_to_pick_)* order_line_rec_.inverted_conv_factor/order_line_rec_.conv_factor),
                                                     old_quantity_     => old_qty_);
      END IF;

      reserved_qty_        := reserve_rec_.qty_assigned - reserve_rec_.qty_picked ;
      pick_list_serial_no_ := reserve_rec_.serial_no;

      -- Note: If the pick_list_serial_no_ is not '*', that means serials have been identified.
      -- Split receipt and issue serial tracked part lines into single serial handling
      IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE AND serial_no_ != '*' AND pick_list_serial_no_ = '*' AND
          Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_) = Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
         Temporary_Part_Tracking_API.Identify_Serial_On_Reservation(source_type_db_   => Order_Supply_Demand_Type_API.DB_CUST_ORDER,
                                                                    source_ref_1_     => order_no_,
                                                                    source_ref_2_     => line_no_,
                                                                    source_ref_3_     => rel_no_,
                                                                    source_ref_4_     => line_item_no_,
                                                                    source_ref_5_     => pick_list_no_,
                                                                    source_ref_6_     => shipment_id_,
                                                                    contract_         => contract_,
                                                                    part_no_          => part_no_,
                                                                    configuration_id_ => config_id_,
                                                                    location_no_      => location_no_,
                                                                    serial_no_        => serial_no_,
                                                                    lot_batch_no_     => lot_batch_no_,
                                                                    eng_chg_level_    => eng_chg_level_,
                                                                    waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                    activity_seq_     => activity_seq_,
                                                                    handling_unit_id_ => res_handling_unit_id_,
                                                                    catch_qty_        => catch_qty_to_pick_);
      END IF;

      -- If a shipment and handling unit is specified that implies that the user wants to pack the picked reservation into the specified handling unit on shipment inventory.
      IF (shp_handling_unit_id_ IS NOT NULL AND shipment_id_ != 0 AND qty_to_pick_ > 0) THEN
         -- If user wants to pack the picked reservation into a handling unit in shipment inventory, the part must be unattched from its parrent  
         -- handling unit in order to pach to new strcture. To acheive that we pass parameter add_hu_to_shipment_ as FALSE.
         add_hu_to_shipment_ := FALSE;
      END IF;

      IF (pick_by_choice_allowed_) THEN
         -- Check the reserved record with what was actually picked here and set pbc_picked_reserved_record_ to indicate that the user picked the reserved record 
         -- and not another record, so this is not a real Pick By Choice action and this can be used to NOT run the PBC flow when its not necessary and use
         -- regular picking flow in that case.
         -- Also if pegged reservations is involved, running the PBC flow will give an error (since its not supported) which is another reason why we do this.
         IF (reserve_rec_.pick_list_no     = pick_list_no_     AND
             reserve_rec_.shipment_id      = shipment_id_      AND 
             reserve_rec_.order_no         = order_no_         AND
             reserve_rec_.line_no          = line_no_          AND
             reserve_rec_.rel_no           = rel_no_           AND
             reserve_rec_.line_item_no     = line_item_no_     AND
             reserve_rec_.contract         = contract_         AND
             reserve_rec_.part_no          = part_no_          AND
             reserve_rec_.location_no      = location_no_      AND
             reserve_rec_.lot_batch_no     = lot_batch_no_     AND
             reserve_rec_.serial_no        = serial_no_        AND
             reserve_rec_.eng_chg_level    = eng_chg_level_    AND
             reserve_rec_.waiv_dev_rej_no  = waiv_dev_rej_no_  AND 
             reserve_rec_.activity_seq     = activity_seq_     AND
             reserve_rec_.handling_unit_id = res_handling_unit_id_ AND
             reserve_rec_.configuration_id = config_id_ ) THEN
            pbc_picked_reserved_record_ := TRUE;
         END IF;
      END IF;

      IF pick_by_choice_allowed_ AND NOT pbc_picked_reserved_record_ THEN 
         --Client_SYS.Add_To_Attr('PART_TRACKING_SESSION_ID', NULL, pickattr_);   -- Not a data item
         pick_clob_attr_ := Message_SYS.Construct_Clob_Message('INPUT_DATA');
         IF NOT add_hu_to_shipment_ THEN 
            Message_SYS.Add_Attribute(pick_clob_attr_, 'ADD_HU_TO_SHIPMENT' , 'FALSE'); 
         END IF;
         Message_SYS.Add_Attribute(pick_clob_attr_, 'INPUT_QUANTITY' , input_qty_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'INPUT_CONV_FACTOR' , input_conv_factor_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'INPUT_UNIT_MEAS' , input_unit_meas_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'INPUT_VARIABLE_VALUES' , input_variable_values_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'CATCH_QTY_TO_PICK' , catch_qty_to_pick_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'QTY_TO_PICK' , qty_to_pick_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'LOCATION_NO' , location_no_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'LOT_BATCH_NO' , lot_batch_no_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'SERIAL_NO' , serial_no_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'ENG_CHG_LEVEL' , eng_chg_level_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'WAIV_DEV_REJ_NO' , waiv_dev_rej_no_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'ACTIVITY_SEQ' , activity_seq_); 
         Message_SYS.Add_Attribute(pick_clob_attr_, 'HANDLING_UNIT_ID' , res_handling_unit_id_); 

         Inventory_Picking_Manager_API.Pick_By_Choice(message_               => pick_clob_attr_,
                                                      source_ref1_           => order_no_,
                                                      source_ref2_           => line_no_,
                                                      source_ref3_           => rel_no_,
                                                      source_ref4_           => line_item_no_,
                                                      source_ref_type_db_    => '1',
                                                      contract_              => contract_,
                                                      part_no_               => part_no_,
                                                      configuration_id_      => config_id_,
                                                      location_no_           => reserve_rec_.location_no,
                                                      lot_batch_no_          => reserve_rec_.lot_batch_no,
                                                      serial_no_             => reserve_rec_.serial_no,
                                                      eng_chg_level_         => reserve_rec_.eng_chg_level,
                                                      waiv_dev_rej_no_       => reserve_rec_.waiv_dev_rej_no,
                                                      activity_seq_          => reserve_rec_.activity_seq,
                                                      handling_unit_id_      => reserve_rec_.handling_unit_id,
                                                      pick_list_no_          => pick_list_no_,
                                                      shipment_id_           => shipment_id_,
                                                      ship_location_no_      => ship_location_no_,
                                                      reserved_qty_          => reserved_qty_,
                                                      close_line_            => 'FALSE',
                                                      trigger_shipment_flow_ => 'FALSE');
      ELSE 
         Validate_Overpicking___(capture_session_id_, order_no_, line_no_, rel_no_, line_item_no_, qty_to_pick_);

         Client_SYS.Add_To_Attr('ORDER_NO', order_no_, pickattr_);
         Client_SYS.Add_To_Attr('LINE_NO', line_no_, pickattr_);
         Client_SYS.Add_To_Attr('REL_NO', rel_no_, pickattr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, pickattr_);
         Client_SYS.Add_To_Attr('CONTRACT', contract_, pickattr_);
         Client_SYS.Add_To_Attr('PART_NO', part_no_, pickattr_);
         Client_SYS.Add_To_Attr('CONFIGURATION_ID', config_id_, pickattr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, pickattr_);
         Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, pickattr_);
         Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, pickattr_);
         Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', eng_chg_level_, pickattr_);
         Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', waiv_dev_rej_no_, pickattr_);
         Client_SYS.Add_To_Attr('INPUT_QUANTITY', input_qty_, pickattr_);   -- Not a data item
         Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_, pickattr_);  -- Not a data item
         Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_, pickattr_);  -- Not a data item
         Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, pickattr_);  -- Not a data item
         Client_SYS.Add_To_Attr('ACTIVITY_SEQ', activity_seq_, pickattr_);
         Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', res_handling_unit_id_, pickattr_);
         Client_SYS.Add_To_Attr('CATCH_QTY_TO_PICK', catch_qty_to_pick_, pickattr_);
         --Client_SYS.Add_To_Attr('PART_TRACKING_SESSION_ID', NULL, pickattr_);   -- Not a data item
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, pickattr_);
         Client_SYS.Add_To_Attr('QTY_TO_PICK', qty_to_pick_, pickattr_);
         Client_SYS.Add_To_Attr('LAST_LINE', 'TRUE', pickattr_);

         dummy_session_id_ := NULL;

         Pick_Customer_Order_API.Pick_Reservations__(info_                  => info_,
                                                     all_reported_          => dummy_all_reported_,
                                                     closed_lines_          => dummy_closed_lines_,
                                                     overpicked_lines_      => dummy_overpicked_lines_,
                                                     attr_                  => pickattr_,
                                                     session_id_            => dummy_session_id_,
                                                     shipment_id_message_   => shipment_id_message_,
                                                     pick_list_no_          => pick_list_no_,
                                                     ship_location_no_      => ship_location_no_,
                                                     add_hu_to_shipment_    => add_hu_to_shipment_,
                                                     trigger_shipment_flow_ => 'FALSE');
      END IF;

      -- If a shipment and handling unit is specified that implies that the user wants to pack the picked reservation into the specified handling unit.
      IF (shp_handling_unit_id_ IS NOT NULL AND shipment_id_ != 0 AND qty_to_pick_ > 0) THEN

         packing_location_ := NVL(ship_location_no_, location_no_);

         -- we need to fetch the reservation after picking to get current handling unit id of reservation in case part was unattched from its 
         -- parent handling unit. If Get method doesnt find the record it means part is seperated from HU and is directly on the packing_location_.
         reserve_rec_ := Customer_Order_Reservation_API.Get(order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, packing_location_, 
                                                            lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, 
                                                            res_handling_unit_id_, config_id_, pick_list_no_, shipment_id_);

         order_line_rec_ := Customer_Order_Line_API.Get(order_no_,
                                                        line_no_,
                                                        rel_no_,
                                                        line_item_no_);
         sales_qty_to_be_added_ := (qty_to_pick_ * order_line_rec_.inverted_conv_factor/order_line_rec_.conv_factor);
         Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(shipment_id_          => shipment_id_,
                                                             shipment_line_no_     => shipment_line_no_,
                                                             handling_unit_id_     => shp_handling_unit_id_, 
                                                             quantity_to_be_added_ => sales_qty_to_be_added_);

         Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing(source_ref1_             => order_no_, 
                                                               source_ref2_             => line_no_, 
                                                               source_ref3_             => rel_no_, 
                                                               source_ref4_             => line_item_no_, 
                                                               contract_                => contract_, 
                                                               part_no_                 => part_no_, 
                                                               location_no_             => packing_location_,
                                                               lot_batch_no_            => lot_batch_no_,
                                                               serial_no_               => serial_no_, 
                                                               eng_chg_level_           => eng_chg_level_, 
                                                               waiv_dev_rej_no_         => waiv_dev_rej_no_, 
                                                               activity_seq_            => activity_seq_, 
                                                               reserv_handling_unit_id_ => NVL(reserve_rec_.handling_unit_id, 0), 
                                                               configuration_id_        => config_id_,
                                                               pick_list_no_            => pick_list_no_, 
                                                               shipment_id_             => shipment_id_, 
                                                               shipment_line_no_        => shipment_line_no_, 
                                                               handling_unit_id_        => shp_handling_unit_id_, 
                                                               quantity_to_be_added_    => qty_to_pick_, 
                                                               catch_qty_to_reassign_   => catch_qty_to_pick_);

         max_weight_volume_error_ := Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'MAX_WEIGHT_VOLUME_ERROR');
         IF(max_weight_volume_error_ = Fnd_Boolean_API.DB_TRUE) THEN 
            Handling_Unit_API.Check_Max_Capacity_Exceeded(handling_unit_id_ => shp_handling_unit_id_);
         END IF;

      END IF;

      IF (release_reservation_) THEN
         Pick_Customer_Order_API.Clear_Unpicked_Reservations(order_no_, line_no_, rel_no_, line_item_no_, pick_list_no_, shipment_id_);
      END IF;

      -- Add shipment_id_ to the process_message_.
      IF (shipment_id_ != 0) THEN
         Construct_Process_Message___(process_message_);
         Update_Shipment_Id_Message___(process_message_, shipment_id_);
      END IF;

   $ELSE
      NULL;
   $END
END Execute_Process;

PROCEDURE Post_Process_Action(
   process_message_     IN OUT CLOB,
   capture_session_id_  IN     NUMBER,
   contract_            IN     VARCHAR2 )
IS
BEGIN
   IF (process_message_ IS NOT NULL) THEN
      Shipment_Flow_API.Start_Shipment_Flow(Get_Shipment_Id_Message___(process_message_), 40);
   END IF;
END Post_Process_Action;

@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Pick_Customer_Order_API.Pick_Reservations__ is granted thru following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'PickSelected') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'UnreserveSelected') OR
       Security_SYS.Is_Proj_Action_Available('ReportPickingOfPickListLines', 'PickSelected') OR
       Security_SYS.Is_Proj_Action_Available('ReportPickingOfPickListLines', 'UnreserveSelected') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'PickSelected') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'UnreserveSelected')) THEN
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
   contract_                    VARCHAR2(5);
   pick_list_no_                VARCHAR2(15);
   unique_line_id_              CUSTOMER_ORDER_RESERVATION.objid%TYPE;
   order_no_                    VARCHAR2(12);
   line_no_                     VARCHAR2(4);
   rel_no_                      VARCHAR2(4);
   line_item_no_                NUMBER;
   part_no_                     VARCHAR2(25);
   location_no_                 VARCHAR2(35);
   serial_no_                   VARCHAR2(50);
   lot_batch_no_                VARCHAR2(20);
   waiv_dev_rej_no_             VARCHAR2(15);
   eng_chg_level_               VARCHAR2(6);
   configuration_id_            VARCHAR2(50);
   local_data_item_id_          VARCHAR2(50);
   activity_seq_                NUMBER;
   shipment_id_                 NUMBER;
   unique_shipment_id_          NUMBER;
   barcode_id_                  NUMBER;
   shp_handling_unit_id_        NUMBER;
   shp_sscc_                    VARCHAR2(18);
   shp_alt_handl_unit_label_id_ VARCHAR2(25);
   res_handling_unit_id_        NUMBER;
   res_sscc_                    VARCHAR2(18);
   res_alt_handl_unit_label_id_ VARCHAR2(25);
   fixed_value_is_applicable_   BOOLEAN := FALSE;
   local_barcode_id_            NUMBER;
   local_location_no_           VARCHAR2(35);
   local_serial_no_             VARCHAR2(50);
   local_lot_batch_no_          VARCHAR2(20);
   local_waiv_dev_rej_no_       VARCHAR2(15);
   local_eng_chg_level_         VARCHAR2(6);
   local_activity_seq_          NUMBER;
   local_res_handling_unit_id_  NUMBER;
   local_res_sscc_              VARCHAR2(18) := string_all_values_;
   local_res_alt_hu_label_id_   VARCHAR2(25) := string_all_values_;
   pick_by_choice_option_       VARCHAR2(20);
   gtin_no_                     VARCHAR2(14); 
BEGIN
   -- NOTE: Calling Data_Capture_Session_API.Get_Predicted_Data_Item_Value and Get_Filter_Keys___ with use_applicable = FALSE to avoid 
   --       "maximum number of recursive SQL levels" errors since Data_Capture_Session_API.Get_Predicted_Data_Item_Value could call this method for some data items.
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      part_no_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, NULL, 'PART_NO', session_rec_ , process_package_, use_applicable_ => FALSE);
      IF (part_no_ IS NULL OR data_item_id_ IN ('SHIPMENT_ID', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID', 'SHIP_LOCATION_NO')) THEN
         Get_Filter_Keys___(contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, location_no_,
                            serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_, activity_seq_, shipment_id_, barcode_id_,
                            shp_handling_unit_id_, shp_sscc_, shp_alt_handl_unit_label_id_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, gtin_no_,
                            capture_session_id_, data_item_id_, use_applicable_ => FALSE);
      END IF;

      pick_by_choice_option_ := Site_Invent_Info_API.Get_Pick_By_Choice_Option_Db(session_rec_.session_contract);

      IF (serial_no_ IS NULL) AND (data_item_id_ = 'QTY_PICKED') THEN
         serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_, 'SERIAL_NO', data_item_id_);
      END IF;
      
      IF (pick_by_choice_option_ = Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
         local_barcode_id_            := barcode_id_; 
         local_location_no_           := location_no_; 
         local_serial_no_             := serial_no_; 
         local_lot_batch_no_          := lot_batch_no_; 
         local_waiv_dev_rej_no_       := waiv_dev_rej_no_; 
         local_eng_chg_level_         := eng_chg_level_; 
         local_activity_seq_          := activity_seq_; 
         local_res_handling_unit_id_  := res_handling_unit_id_; 
         local_res_sscc_              := res_sscc_; 
         local_res_alt_hu_label_id_   := res_alt_handl_unit_label_id_;
      END IF;
      
      IF (data_item_id_ = 'QTY_PICKED') THEN
         local_data_item_id_ := 'QUANTITY';      
      ELSE
         local_data_item_id_ := data_item_id_;
      END IF;   

      IF (local_data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID') AND line_item_no_ > 0) THEN 
         fixed_value_is_applicable_ := TRUE;
      ELSIF (local_data_item_id_ IN ('SHIPMENT_ID', 'SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID', 'SHIP_LOCATION_NO')) THEN
         unique_shipment_id_ := Pick_Customer_Order_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                   pick_list_no_               => pick_list_no_,
                                                                                   unique_line_id_             => unique_line_id_,
                                                                                   order_no_                   => order_no_,
                                                                                   line_no_                    => line_no_,
                                                                                   rel_no_                     => rel_no_,
                                                                                   line_item_no_               => line_item_no_,
                                                                                   part_no_                    => part_no_,
                                                                                   location_no_                => local_location_no_,
                                                                                   serial_no_                  => local_serial_no_,
                                                                                   lot_batch_no_               => local_lot_batch_no_,
                                                                                   waiv_dev_rej_no_            => local_waiv_dev_rej_no_,
                                                                                   eng_chg_level_              => local_eng_chg_level_,
                                                                                   configuration_id_           => configuration_id_, 
                                                                                   activity_seq_               => local_activity_seq_,
                                                                                   handling_unit_id_           => local_res_handling_unit_id_,
                                                                                   sscc_                       => local_res_sscc_,
                                                                                   alt_handling_unit_label_id_ => local_res_alt_hu_label_id_,
                                                                                   shipment_id_                => shipment_id_,
                                                                                   column_name_                => 'SHIPMENT_ID');
         IF (data_item_id_ = 'SHIP_LOCATION_NO' AND pick_list_no_ IS NULL) THEN
            pick_list_no_ := Pick_Customer_Order_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                pick_list_no_               => pick_list_no_,
                                                                                unique_line_id_             => unique_line_id_,
                                                                                order_no_                   => order_no_,
                                                                                line_no_                    => line_no_,
                                                                                rel_no_                     => rel_no_,
                                                                                line_item_no_               => line_item_no_,
                                                                                part_no_                    => part_no_,
                                                                                location_no_                => local_location_no_,
                                                                                serial_no_                  => local_serial_no_,
                                                                                lot_batch_no_               => local_lot_batch_no_,
                                                                                waiv_dev_rej_no_            => local_waiv_dev_rej_no_,
                                                                                eng_chg_level_              => local_eng_chg_level_,
                                                                                configuration_id_           => configuration_id_, 
                                                                                activity_seq_               => local_activity_seq_,
                                                                                handling_unit_id_           => local_res_handling_unit_id_,
                                                                                sscc_                       => local_res_sscc_,
                                                                                alt_handling_unit_label_id_ => local_res_alt_hu_label_id_,
                                                                                shipment_id_                => shipment_id_,
                                                                                column_name_                => 'PICK_LIST_NO');
         END IF;

         IF (data_item_id_ = 'SHIP_LOCATION_NO') THEN
            IF (pick_list_no_ IS NOT NULL AND 
                Handle_Ship_Invent_Utility_API.Uses_Shipment_Inventory(pick_list_no_   => pick_list_no_, 
                                                                       pick_list_type_ => 'CUST_ORDER_PICK_LIST') = 0) THEN
               fixed_value_is_applicable_ := TRUE;
            END IF;
         ELSIF (unique_shipment_id_ = 0) THEN
            fixed_value_is_applicable_ := TRUE;
         ELSIF (unique_shipment_id_ IS NOT NULL)  THEN
            IF (data_item_id_ IN ('SHP_HANDLING_UNIT_ID', 'SHP_SSCC', 'SHP_ALT_HANDLING_UNIT_LABEL_ID')) THEN
               IF (NOT Fnd_Boolean_API.Is_True_DB(Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(shipment_id_))) THEN
                  -- There are not any handling units defined on the shipment
                  fixed_value_is_applicable_ := TRUE;
               END IF;
            END IF;
         END IF;
      ELSE
         -- If predicted part_no_ is null then try fetch it with unique handling
         IF part_no_ IS NULL THEN 
            part_no_ := Get_Unique_Data_Item_Value___(capture_session_id_, contract_, pick_list_no_, unique_line_id_, order_no_, line_no_, rel_no_, line_item_no_, part_no_, 
                                                      location_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, eng_chg_level_, configuration_id_,
                                                      activity_seq_, res_handling_unit_id_, res_sscc_, res_alt_handl_unit_label_id_, shipment_id_, local_barcode_id_, 'PART_NO');
         END IF;

         fixed_value_is_applicable_ := Data_Capture_Order_Util_API.Fixed_Value_Is_Applicable(capture_session_id_, local_data_item_id_, part_no_, serial_no_);
      END IF;
   $END
   
   RETURN fixed_value_is_applicable_;
END Fixed_Value_Is_Applicable;


@UncheckedAccess
FUNCTION Subseq_Session_Start_Allowed (
   capture_session_id_            IN NUMBER, 
   subsequent_capture_process_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   subseq_session_start_allowed_ BOOLEAN := TRUE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- This control is only made if next process is Start Warehouse Task
      IF (subsequent_capture_process_id_ = 'START_WAREHOUSE_TASK') THEN
         -- We are only allowed to jump to Start Warehouse Task process if WAREHOUSE_TASK_ID have a value, if it don't have value we return FALSE
         IF (Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'WAREHOUSE_TASK_ID') IS NULL) THEN
            subseq_session_start_allowed_ := FALSE;
         END IF;
      END IF;
   $END
   
   RETURN subseq_session_start_allowed_;
END Subseq_Session_Start_Allowed;


-- Consume_Unique_Line_Id will return TRUE if an item in the list of values shall be consumed.
-- This happens when the full qty on a picking line is picked within the current session or
-- when the reservation has been released in a prevoius loop.
FUNCTION Consume_Unique_Line_Id (
   capture_session_id_     IN NUMBER,
   contract_               IN VARCHAR2,
   pick_list_no_           IN VARCHAR2,
   unique_line_id_         IN VARCHAR2,
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   part_no_                IN VARCHAR2,
   location_no_            IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,    
   waiv_dev_rej_no_        IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN NUMBER,
   shipment_id_            IN NUMBER ) RETURN VARCHAR2
IS
   release_reservation_    BOOLEAN := FALSE;
   consume_unique_line_id_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   qty_left_to_pick_       NUMBER := 0;
   qty_picked_in_session_  NUMBER := 0;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      qty_left_to_pick_ := Customer_Order_Reservation_API.Get_Qty_Left_To_Pick(order_no_,
                                                                               line_no_,
                                                                               rel_no_,
                                                                               line_item_no_,
                                                                               contract_,
                                                                               part_no_,
                                                                               location_no_,
                                                                               lot_batch_no_,
                                                                               eng_chg_level_,
                                                                               waiv_dev_rej_no_,
                                                                               activity_seq_,
                                                                               handling_unit_id_, 
                                                                               configuration_id_,
                                                                               pick_list_no_,
                                                                               shipment_id_);
      Get_Qty_Picked_And_Reserv___(total_qty_picked_    => qty_picked_in_session_,
                                   release_reservation_ => release_reservation_,
                                   capture_session_id_  => capture_session_id_,
                                   unique_line_id_      => unique_line_id_);
   
      -- If al is picked, the reservation has been released or a serial pick line is picked, then consume the line
      IF (qty_left_to_pick_ <= qty_picked_in_session_ OR release_reservation_ OR (Part_Catalog_API.Serial_Tracked_In_Inventory(part_no_) AND qty_picked_in_session_ > 0)) THEN
         consume_unique_line_id_ := Fnd_Boolean_API.DB_TRUE;
      ELSE
         consume_unique_line_id_ := Fnd_Boolean_API.DB_FALSE;
      END IF;
   $END
   RETURN consume_unique_line_id_;
END Consume_Unique_Line_Id;
   
   
FUNCTION Looping_Is_Allowed (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2) RETURN BOOLEAN
IS
   session_rec_        Data_Capture_Common_Util_API.Session_Rec;
   looping_allowed_    BOOLEAN := TRUE;
   part_no_            VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ = 'SERIAL_NO') THEN
         session_rec_  := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         part_no_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                            current_data_item_id_    => data_item_id_,
                                                                            current_data_item_value_ => NULL,
                                                                            wanted_data_item_id_     => 'PART_NO',
                                                                            session_rec_             => session_rec_);
         -- Only receipt and issue serial tracked parts can have serial no loops in this process
         IF (NOT Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_)) THEN
            looping_allowed_ := FALSE;
         ELSE
            looping_allowed_ := TRUE;
         END IF;
      ELSE
         looping_allowed_ := TRUE;
      END IF;
   $END
   RETURN looping_allowed_;
END Looping_Is_Allowed;
