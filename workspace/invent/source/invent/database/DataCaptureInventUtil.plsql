-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptureInventUtil
--  Component:    INVENT                                                                                                      
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211222  BWITLK  Bug 161784 (SCZ-17069), Changed the row and tier parameter order in several calls inside Add_Details_For_Location_No.
--  210812  Moinlk  SC21R2-1825, Added SHIP_LOCATION_NO_DESC to Add_Details_For_Location_No method to support feedback items fetching.
--  190103  ChBnlk  Bug 146085 (SCZ-2634), Added new method Add_Default_Move_Location().
--  181021  BudKlk  Bug 144722, Modified the methods Add_Details_For_Part_No() and Add_Stop_New_Serial_RMA___() to change the name of the feedback item STOP_NEW_SERIAL_RMA to STOP_NEW_SERIAL_IN_RMA 
--  181021          and added a condition to pass the value for STOP_NEW_SERIAL_IN_RMA only when the part is serial tracked. 
--  181019  BudKlk  Bug 143097, Added a new method Add_Condition_Code.
--  180221  RuLiLk  STRSC-16860, Added new method Validate_GS1_Data_Item to validate if GS1 barcode items are set as mandatory.
--  180209  SWiclk  STRSC-16915, Modified Add_Details_For_Find_Inventory() in order to filter records with onhand qty > 0.
--  180124  SWiclk  STRSC-16070, Modified Add_Details_For_Find_Inventory() in order pass values for part no and location no from rec_ instead of parameters.
--  171129  RALASE  STRMF-16146, Added TRUNC() for getting correct date format to compare EXPIRATION_DATE to SYSDATE
--  171019  SWiclk  STRSC-13218, Added Add_Details_For_Find_Inventory().
--  170928  ThImlk  STRMF-14895, Added QTY_RECEIVED into the method Add_Details_For_Handling_Unit().
--  170914  JeLise  STRSC-11880, Added HANDLING_UNIT_TYPE_ID in Validate_Data_Item.
--  170908  JeLise  STRSC-11878, Added method Add_Details_For_Pack_Into_Hu and added PACKING_INSTRUCTION_ID in Validate_Data_Item.
--  170908  SWiclk  STRSC-11956, Modified Fixed_Value_Is_Applicable() in order to handle INPUT_UOM and INPUT_QUANTITY.
--  170824  JeLise  STRSC-11423, Added methods Add_Due_For_Transport and Add_Condition_Code_Info.
--  170815  SWICLK  STRSC-9612, Added Gtin_Enabled() and removed Quantity validation because it should be handled in respective process itself. 
--  170707  SWiclk  STRSC-9612, Added Add_Input_Conv_Factor___() in order to get input conversion factor of GTIN.
--  170707          Added Zero/Negative validation for Qty related data items. Added GTIN validation.
--  170517  DaZase  STRSC-8272, Added QUANTITY_AVAILABLE to Add_Details_For_Inv_Stock_Rec.
--  170420  DaZase  LIM-11241, Removed all extra TO_CHAR(x, Client_SYS.date_format_) on date feedback items since that is now performed in the 
--  170420          framework instead, like expiration_date, last_activity_date, last_count_date.
--  170418  DaZase  LIM-10662, Added method Inventory_Barcode_Enabled.
--  170329  Khvese  LIM-11011, Modified method Add_Details_For_Handling_Unit.
--  170308  DaZase  LIM-9901, Added Add_Detail_For_Hand_Unit_Trans.
--  170207  KhVese  LIM-10482, Modified method Check_Catch_Qty to validate CATCH QTY on third data item than PART No and CATCH QTY.
--  170117  DaZase  LIM-10393, Changes in Add_Detail_For_Hand_Unit_Stock to make sure OWNER, OWNER_NAME and AVAILABILITY_CONTROL_DESCRIPTION is handled better.
--  170113  DaZase  LIM-8660, Changed Check_Catch_Qty() removed some parameters and added a new one. Removed the Check_Catch_Qty call from Validate_Data_Item 
--  170113          its better that each process does this call then having it here.
--  161216  SWiclk  LIM-9690, Modified Add_Details_For_Handling_Unit() in order to get LAST_COUNT_DATE.
--  161213  Erlise  LIM-9506, Added validation of EXPIRATION_DATE.
--  161115  SWiclk  LIM-5313, Modified Fixed_Value_Is_Applicable() by adding serial_no as a parameter so that it will be used to decide on quantity when applicable.
--  160608  BudKlk  Bug 122162, Modified Create_List_Of_Values() and Validate_Data_Item() in order to create LOV for CONSUME_CONSIGNMENT and validate. 
--  160420  JanWse  STRSC-1741, Added TRUE to also check for blocked in a call to Part_Availability_Control_API.Exist
--  160208  SWiclk  Bug 127172, Modified Validate_Data_Item() in order to check Barcode_ID is mandatory if configured in process detail.
--  160115  Chfose  LIM-5883, Updated method calls to Handling_Unit_API.Get_Operational... to use new name Handling_Unit_API.Get_Operative...
--  160111  KhVese  LIM-2927, Removed feedback item 'PART_ACQUISITION_VALUE' from method Add_Detail_For_Hand_Unit_Stock().
--  151208  KhVese  LIM-4898, Modified method Add_Detail_For_Hand_Unit_Stock() to handle string 'NULL'
--  151207  KhVese  LIM-4898, Renamed method Add_Detail_For_Handl_Unit_Part() to Add_Detail_For_Hand_Unit_Stock()
--  151123  KhVese  LIM-2924, Modified method Add_Detail_For_Handl_Unit_Part() to consider mixed value.
--  151118  KhVese  LIM-2926, Added method Add_Detail_For_Handl_Unit_Part().
--  151110  DaZase  LIM-4599, Added handling_unit_id_ to several methods.
--  151027  DaZase  LIM-4297, Moved methods Add_Details_For_Hand_Unit_Type/Add_Details_For_Handling_Unit from DataCaptureOrderUtil into 
--  151027          this Utility and added several new feedback items to these 2 methods.
--  150505  RILASE  Added when applicable support for quantity.
--  150427  DaZase  COB-18, Added method Add_Transaction_Qty.
--  150409  DaZase  Removed all Inventory_Part_In_Stock_API calls from Create_List_Of_Values, these should now be called from each processutility instead.
--  150309  DaZase  COB-37, Added 'DIM_QUALITY', 'DIMENSION_QUALITY', TYPE_DESIGNATION to Add_Details_For_Part_No.
--  150730  SWiclk  Bug 121254, Modified Add_Origin_Pack_Size___(), Validate_Data_Item(), Match_Barcode_Keys() and 
--  150730          Get_Value_From_Barcode_Id() in order to pass contract as a key along with barcode_id.
--  150413  JeLise  Added handling_unit_id_ in calls to Inventory_Part_In_Stock_API.
--  150128  DaZase  PRSC-5644, Removed old barcode validation from Validate_Data_Item, its obsolete and performed by calls 
--  150128          to Inventory_Part_Barcode_API.Record_With_Column_Value_Exist in each process validation instead.
--  141119  DaZase  PRSC-3646, Added extra condition code validation Validate_Data_Item to stop parts that are not condition code handled. 
--  141119          Also changed when the condition code LOV will be created or not in Create_List_Of_Values.
--  141030  RiLase  PRSC-3334, Added Add_Tot_Serial_Nos_In_Session.
--  141016  DaZase  PRSC-3321, Added support for 'QTY_ONHAND','CATCH_QTY_ONHAND' in Add_Details_For_Inv_Stock_Rec.
--  140916  BudKlk  Bug 118233, Modified Add_Details_For_Location_No() method my adding SUPPLY_TO_LOCATION_DESC as a data_item_detail_id_.
--  140912  DaZase  PRSC-2781, Changed in Add_Details_For_Location_No, Add_Ownership___ and in several methods called from Add_Details_For_Part_No 
--  140912          to reflect that some of these feedback items are enumerations and should fetch db value instead of client value now.
--  140910  DaZase  PRSC-2781, Changed call in Add_Data_Item_From_Sess_Line to Get_Fixed_Value_Db_If_Used to be sure that a data item enumeration db value is saved as a detail value.
--  140908  RiLase  PRSC-2497, Added Fixed_Value_Is_Applicable().
--  140828  SudJlk  Bug 118229, Added methods Add_Details_For_Barcode_Id and Add_Origin_Pack_Size___ to add ORIGIN_PACK_SIZE as a feedback item.
--  140806  DaZase  PRSC-1431, Changed part_no_ to VARCHAR2(25) and location_no_ to VARCHAR2(35).
--  140728  BudKlk  Bug 117726, Added a new procedure Add_Qty_Onhand_Not_Reserved___() in order to calculate the QTY_ONHAND_NOT_RESERVED and add a new condition for CATCH_QTY_ONHAND_NOT_RESERVED.
--  140728          and modified Create_List_Of_Values() method by adding the data item 'PRINT_SERVICEABILITY_TAG' to get the yes/no lov.
--  140724  ChBnlk   Bug 117727, Added new methods Add_Availability_Ctrl_Desc___(), Add_Quantity_In_Transit___() and Add_Catch_Qty_In_Transit___() and 
--  140724           modified Add_Details_For_Inv_Stock_Rec() to add AVAILABILITY_CONTROL_DESCRIPTION, QUANTITY_IN_TRANSIT and CATCH_QUANTITY_IN_TRANSIT
--  140724           details to the stock.
--  140508  DaZase  PBSC-9104, Removed check in Validate_Data_Item for ORIGIN_PACK_SIZE so it now will be possible to enter decimal values for it.
--  140414  DaZase  Added extra check in Validate_Data_Item to not validate AVAILABILITY_CONTROL_ID if its null.
--  140228  RuLiLk  Bug 114926, Modified method Validate_Data_Item() by Renaming data item SET_WAIV_DEV_REJ_NO as DESTINATION_WAIV_DEV_REJ_NO.
--  131213  SWiclk  Bug 112876, Modified Validate_Data_Item() by adding SET_WAIV_DEV_REJ_NO as a mandatory non-process key.
--  131126  SWiclk  Bug 112876, Modified Validate_Data_Item() and Create_List_Of_Values() to handle part availability control ID.
--  131107  DaZase  Bug 113189, Modified Create_List_Of_Values to handle the new parameter interface for method Inventory_Part_In_Stock_API.Create_Data_Capture_Lov.
--  131023  SWiclk  Bug 112203, Modified Create_List_Of_Values() in order to get the list of values for activity seq no.
--  131021  SWiclk  Bug 112203, Modified Create_List_Of_Values() in order to get the list of values for lot batch no and WDR no.                                                                              
--  131009  RuLiLk  Bug 112813, Modified method Add_Details_For_Location_No().
--  131009          To avoid numeric and value errors, variable defined in type Warehouse_Bay_Bin_API.Putaway_Bin_Rec is used. 
--  131128  AwWelk  PBSC-4130, Replaced the calls to Inventory_Part_In_Stock_API.Get_Catch_Qty_Onhand with 
--  131128          Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand.
--  12xxxx  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Part_No___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2 ) RETURN VARCHAR2   
IS
   part_no_            VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
     part_no_ :=  Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                    data_item_id_a_     => 'PART_NO',
                                                                    data_item_id_b_     => data_item_id_b_);
      IF (part_no_ IS NULL) THEN
         part_no_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                          capture_config_id_  => capture_config_id_,
                                                                          data_item_id_       => 'PART_NO');
      END IF;
   $END
   RETURN part_no_;
END Get_Part_No___;


FUNCTION Get_Location_No___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2 ) RETURN VARCHAR2   
IS
   location_no_        VARCHAR2(35);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      location_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                        data_item_id_a_     => 'LOCATION_NO',
                                                                        data_item_id_b_     => data_item_id_b_);
      IF (location_no_ IS NULL) THEN
         location_no_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                              capture_config_id_  => capture_config_id_,
                                                                              data_item_id_       => 'LOCATION_NO');
      END IF;
   $END
   RETURN location_no_;
END Get_Location_No___;


FUNCTION Get_Serial_No___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2,
   part_catalog_rec_   IN Part_Catalog_API.Public_Rec ) RETURN VARCHAR2   
IS
   serial_no_ VARCHAR2(50);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      serial_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                      data_item_id_a_     => 'SERIAL_NO',
                                                                      data_item_id_b_     => data_item_id_b_);
      IF (serial_no_ IS NULL) THEN
         serial_no_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                            capture_config_id_  => capture_config_id_,
                                                                            data_item_id_       => 'SERIAL_NO');
      END IF;
      IF (serial_no_ IS NULL) THEN
         serial_no_ := Get_Serial_No(part_catalog_rec_);
      END IF;
   $END
   RETURN serial_no_;
END Get_Serial_No___;


FUNCTION Get_Configuration_Id___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2,
   part_catalog_rec_   IN Part_Catalog_API.Public_Rec ) RETURN VARCHAR2   
IS
   configuration_id_ VARCHAR2(50);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      configuration_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                             data_item_id_a_     => 'CONFIGURATION_ID',
                                                                             data_item_id_b_     => data_item_id_b_);
      IF (configuration_id_ IS NULL) THEN
         configuration_id_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                                   capture_config_id_  => capture_config_id_,
                                                                                   data_item_id_       => 'CONFIGURATION_ID');
      END IF;
      IF (configuration_id_ IS NULL) THEN
         configuration_id_ := Get_Configuration_Id(part_catalog_rec_);
      END IF;
   $END
   RETURN configuration_id_;
END Get_Configuration_Id___;


FUNCTION Get_Lot_Batch_No___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2,
   part_catalog_rec_   IN Part_Catalog_API.Public_Rec ) RETURN VARCHAR2   
IS
   lot_batch_no_ VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      lot_batch_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                         data_item_id_a_     => 'LOT_BATCH_NO',
                                                                         data_item_id_b_     => data_item_id_b_);
      IF (lot_batch_no_ IS NULL) THEN
         lot_batch_no_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                               capture_config_id_  => capture_config_id_,
                                                                               data_item_id_       => 'LOT_BATCH_NO');
      END IF;
      IF (lot_batch_no_ IS NULL) THEN
         lot_batch_no_ := Get_Lot_Batch_No(part_catalog_rec_);
      END IF;
   $END
   RETURN lot_batch_no_;
END Get_Lot_Batch_No___;


FUNCTION Get_Eng_Chg_Level___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2 ) RETURN VARCHAR2 
IS
   eng_chg_level_ VARCHAR2(6);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      eng_chg_level_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                          data_item_id_a_     => 'ENG_CHG_LEVEL',
                                                                          data_item_id_b_     => data_item_id_b_);
      IF (eng_chg_level_ IS NULL) THEN
         eng_chg_level_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                               capture_config_id_  => capture_config_id_,
                                                                               data_item_id_       => 'ENG_CHG_LEVEL');
      END IF;
      IF (eng_chg_level_ IS NULL) THEN
         eng_chg_level_ := Get_Eng_Chg_Level(contract_, part_no_);
      END IF;
   $END
   RETURN eng_chg_level_;
END Get_Eng_Chg_Level___;


FUNCTION Get_Activity_Seq___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2,
   contract_           IN VARCHAR2 ) RETURN VARCHAR2   
IS
   activity_seq_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      activity_seq_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                         data_item_id_a_     => 'ACTIVITY_SEQ',
                                                                         data_item_id_b_     => data_item_id_b_);
      IF (activity_seq_ IS NULL) THEN
         activity_seq_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                               capture_config_id_  => capture_config_id_,
                                                                               data_item_id_       => 'ACTIVITY_SEQ');
      END IF;
      IF (activity_seq_ IS NULL ) THEN
         activity_seq_ := Get_Activity_Seq(contract_);
      END IF;
   $END
   RETURN activity_seq_;
END Get_Activity_Seq___;


FUNCTION Get_Waiv_Dev_Rej_No___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2 ) RETURN VARCHAR2   
IS
   waiv_dev_rej_no_ VARCHAR2(15);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      waiv_dev_rej_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                            data_item_id_a_     => 'WAIV_DEV_REJ_NO',
                                                                            data_item_id_b_     => data_item_id_b_);
      IF (waiv_dev_rej_no_ IS NULL) THEN
         waiv_dev_rej_no_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                                  capture_config_id_  => capture_config_id_,
                                                                                  data_item_id_       => 'WAIV_DEV_REJ_NO');
      END IF;
   $END
   RETURN waiv_dev_rej_no_;
END Get_Waiv_Dev_Rej_No___;


FUNCTION Get_Handling_Unit_Id___ (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_b_     IN VARCHAR2 ) RETURN VARCHAR2   
IS
   handling_unit_id_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      handling_unit_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                             data_item_id_a_     => 'HANDLING_UNIT_ID',
                                                                             data_item_id_b_     => data_item_id_b_);
      IF (handling_unit_id_ IS NULL) THEN
         handling_unit_id_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_If_Used(capture_process_id_ => capture_process_id_,
                                                                               capture_config_id_  => capture_config_id_,
                                                                               data_item_id_       => 'HANDLING_UNIT_ID');
      END IF;
   $END
   RETURN handling_unit_id_;
END Get_Handling_Unit_Id___;


FUNCTION Get_Project_Id___ (
   activity_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   project_id_ VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      project_id_ := Activity_API.Get_Project_Id(activity_seq_);
   $END
   RETURN project_id_;
END Get_Project_Id___;


FUNCTION Get_Project_Name___ (
   project_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   project_name_ VARCHAR2(35);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      project_name_ := Project_API.Get_Name(project_id_);
   $END
   RETURN project_name_;
END Get_Project_Name___;


FUNCTION Get_Program_Id___ (
   project_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   program_id_ VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      program_id_ := Project_API.Get_Program_Id(project_id_);
   $END
   RETURN program_id_;
END Get_Program_Id___;


FUNCTION Get_Program_Description___ (
   project_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   program_desc_ VARCHAR2(2000);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      program_desc_ := Project_Program_Global_API.Get_Description(Project_API.Get_Program_Id(project_id_));
   $END
   RETURN program_desc_;
END Get_Program_Description___;


FUNCTION Get_Sub_Project_Id___ (
   activity_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   sub_project_id_ VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      sub_project_id_ := Activity_API.Get_Sub_Project_Id(activity_seq_);
   $END
   RETURN sub_project_id_;
END Get_Sub_Project_Id___;


FUNCTION Get_Sub_Project_Description___ (
   activity_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   sub_project_desc_ VARCHAR2(255);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      sub_project_desc_ := Activity_API.Get_Sub_Project_Description(activity_seq_);
   $END
   RETURN sub_project_desc_;
END Get_Sub_Project_Description___;


FUNCTION Get_Activity_Id___ (
   activity_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   activity_id_ VARCHAR2(10);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      activity_id_ := Activity_API.Get_Activity_No(activity_seq_);
   $END
   RETURN activity_id_;
END Get_Activity_Id___;


FUNCTION Get_Activity_Description___ (
   activity_seq_ IN NUMBER ) RETURN VARCHAR2
IS
   activity_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      activity_desc_ := Activity_API.Get_Description(activity_seq_);
   $END
   RETURN activity_desc_;
END Get_Activity_Description___;


PROCEDURE Get_Stock_Record_Keys___ (
   contract_            OUT VARCHAR2,
   part_no_             OUT VARCHAR2,
   configuration_id_    OUT VARCHAR2,
   location_no_         OUT VARCHAR2,
   lot_batch_no_        OUT VARCHAR2,
   serial_no_           OUT VARCHAR2,
   eng_chg_level_       OUT VARCHAR2,
   waiv_dev_rej_no_     OUT VARCHAR2,
   activity_seq_        OUT NUMBER,
   handling_unit_id_    OUT NUMBER,
   all_found_           OUT BOOLEAN,
   capture_session_id_  IN  NUMBER,
   owning_data_item_id_ IN  VARCHAR2 )   
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   part_catalog_rec_    Part_Catalog_API.Public_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_ := session_rec_.session_contract;
   $END
   IF (contract_ IS NOT NULL) THEN
      part_no_ := Get_Part_No___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_ );
      IF (part_no_ IS NOT NULL) THEN
         part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
         location_no_ := Get_Location_No___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_);
         IF (location_no_ IS NOT NULL) THEN
            serial_no_ := Get_Serial_No___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, part_catalog_rec_);
            IF (serial_no_ IS NOT NULL) THEN
               configuration_id_ := Get_Configuration_Id___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, part_catalog_rec_);
               IF (configuration_id_ IS NOT NULL) THEN
                  lot_batch_no_ :=  Get_Lot_Batch_No___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, part_catalog_rec_);
                  IF (lot_batch_no_ IS NOT NULL) THEN
                     eng_chg_level_ := Get_Eng_Chg_Level___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, contract_, part_no_);
                     IF (eng_chg_level_ IS NOT NULL) THEN
                        activity_seq_ := Get_Activity_Seq___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, contract_);
                        IF (activity_seq_ IS NOT NULL) THEN
                           waiv_dev_rej_no_ := Get_Waiv_Dev_Rej_No___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_);
                           IF (waiv_dev_rej_no_ IS NOT NULL) THEN
                              handling_unit_id_ := Get_Handling_Unit_Id___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_);
                              IF (handling_unit_id_ IS NOT NULL) THEN
                                 all_found_ := TRUE;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
END Get_Stock_Record_Keys___;


PROCEDURE Add_Program_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   project_id_          IN VARCHAR2 )
IS   
   program_id_ VARCHAR2(10);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      program_id_ := Get_Program_Id___(project_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PROGRAM_ID',
                                        data_item_value_     => program_id_);
   $ELSE
      NULL;
   $END
END Add_Program_Id___;


PROCEDURE Add_Program_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   project_id_          IN VARCHAR2 )
IS   
   program_desc_ VARCHAR2(2000);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      program_desc_ := Get_Program_Description___(project_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PROGRAM_DESCRIPTION',
                                        data_item_value_     => program_desc_);
   $ELSE
      NULL;   
   $END
END Add_Program_Desc___;


PROCEDURE Add_Project_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   project_id_          IN VARCHAR2 )
IS   
BEGIN
   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PROJECT_ID',
                                        data_item_value_     => project_id_);
   $ELSE
      NULL; 
   $END
END Add_Project_Id___;


PROCEDURE Add_Project_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   project_id_          IN VARCHAR2 )
IS
   project_name_ VARCHAR2(35);
BEGIN
   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      project_name_ := Get_Project_Name___(project_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PROJECT_NAME',
                                        data_item_value_     => project_name_);
   $ELSE
       NULL;   
   $END
END Add_Project_Name___;


PROCEDURE Add_Sub_Project_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   activity_seq_        IN NUMBER )
IS
   sub_project_id_ VARCHAR2(10);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      sub_project_id_ := Get_Sub_Project_Id___(activity_seq_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SUB_PROJECT_ID',
                                        data_item_value_     => sub_project_id_);
   $ELSE
      NULL;   
   $END
END Add_Sub_Project_Id___;


PROCEDURE Add_Sub_Project_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   activity_seq_        IN NUMBER )
IS
   sub_project_desc_ VARCHAR2(255);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      sub_project_desc_ := Get_Sub_Project_Description___(activity_seq_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SUB_PROJECT_DESCRIPTION',
                                        data_item_value_     => sub_project_desc_);
   $ELSE
      NULL;   
   $END
END Add_Sub_Project_Desc___;


PROCEDURE Add_Activity_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   activity_seq_        IN NUMBER )
IS
   activity_id_ VARCHAR2(10);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      activity_id_ := Get_Activity_Id___(activity_seq_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ACTIVITY_ID',
                                        data_item_value_     => activity_id_);
   $ELSE
      NULL;   
   $END
END Add_Activity_Id___;


PROCEDURE Add_Activity_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   activity_seq_        IN NUMBER )
IS
   activity_desc_ VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      activity_desc_ := Get_Activity_Description___(activity_seq_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ACTIVITY_DESCRIPTION',
                                        data_item_value_     => activity_desc_);
   $ELSE
      NULL;   
   $END
END Add_Activity_Desc___;


PROCEDURE Add_Quantity_Onhand___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   qty_onhand_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      qty_onhand_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_, 
                                                                part_no_, 
                                                                configuration_id_, 
                                                                location_no_, 
                                                                lot_batch_no_,
                                                                serial_no_, 
                                                                eng_chg_level_, 
                                                                waiv_dev_rej_no_, 
                                                                activity_seq_,
                                                                handling_unit_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => qty_onhand_);
   $ELSE
      NULL;   
   $END
END Add_Quantity_Onhand___;


PROCEDURE Add_Qty_Onhand_Not_Reserved___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   stock_rec_ Inventory_Part_In_Stock_API.Public_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      stock_rec_ := Inventory_Part_In_Stock_API.Get(contract_, 
                                                    part_no_, 
                                                    configuration_id_, 
                                                    location_no_, 
                                                    lot_batch_no_,
                                                    serial_no_, 
                                                    eng_chg_level_, 
                                                    waiv_dev_rej_no_, 
                                                    activity_seq_,
                                                    handling_unit_id_); 

      Data_Capture_Session_Line_API.New(capture_session_id_   => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => (stock_rec_.qty_onhand - stock_rec_.qty_reserved));
   $ELSE
      NULL;
   $END
END Add_Qty_Onhand_Not_Reserved___;


PROCEDURE Add_Catch_Quantity_Onhand___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   catch_qty_onhand_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      catch_qty_onhand_ := Inventory_Part_In_Stock_API.Get_Sum_Catch_Qty_Onhand(contract_, 
                                                                                part_no_, 
                                                                                configuration_id_, 
                                                                                location_no_, 
                                                                                lot_batch_no_,
                                                                                serial_no_, 
                                                                                eng_chg_level_, 
                                                                                waiv_dev_rej_no_, 
                                                                                activity_seq_,
                                                                                handling_unit_id_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => catch_qty_onhand_);
   $ELSE
      NULL;   
   $END
END Add_Catch_Quantity_Onhand___;


PROCEDURE Add_Expiration_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   expiration_date_  VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      expiration_date_ := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_, 
                                                                          part_no_, 
                                                                          configuration_id_, 
                                                                          location_no_, 
                                                                          lot_batch_no_, 
                                                                          serial_no_, 
                                                                          eng_chg_level_, 
                                                                          waiv_dev_rej_no_, 
                                                                          activity_seq_,
                                                                          handling_unit_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => expiration_date_);
   $ELSE
      NULL;   
   $END
END Add_Expiration_Date___;


PROCEDURE Add_Availability_Control_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   availability_control_id_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      availability_control_id_ := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_, 
                                                                                          part_no_, 
                                                                                          configuration_id_, 
                                                                                          location_no_, 
                                                                                          lot_batch_no_, 
                                                                                          serial_no_, 
                                                                                          eng_chg_level_, 
                                                                                          waiv_dev_rej_no_, 
                                                                                          activity_seq_,
                                                                                          handling_unit_id_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => availability_control_id_);
   $ELSE
      NULL;   
   $END
END Add_Availability_Control_Id___;


PROCEDURE Add_Ownership___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   part_ownership_   VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      part_ownership_ := Inventory_Part_In_Stock_API.Get_Part_Ownership_Db(contract_, 
                                                                           part_no_, 
                                                                           configuration_id_, 
                                                                           location_no_, 
                                                                           lot_batch_no_, 
                                                                           serial_no_, 
                                                                           eng_chg_level_, 
                                                                           waiv_dev_rej_no_, 
                                                                           activity_seq_,
                                                                           handling_unit_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => part_ownership_);
   $ELSE
      NULL;   
   $END
END Add_Ownership___;


PROCEDURE Add_Owner___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   owner_            VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      owner_ := Inventory_Part_In_Stock_API.Get_Owner(contract_, 
                                                      part_no_, 
                                                      configuration_id_, 
                                                      location_no_, 
                                                      lot_batch_no_, 
                                                      serial_no_, 
                                                      eng_chg_level_, 
                                                      waiv_dev_rej_no_, 
                                                      activity_seq_,
                                                      handling_unit_id_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => owner_);
   $ELSE
      NULL;   
   $END
END Add_Owner___;


PROCEDURE Add_Owning_Customer_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   owning_customer_name_            VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      owning_customer_name_ := Inventory_Part_In_Stock_API.Get_Owning_Customer_No(contract_,
                                                                                  part_no_,
                                                                                  configuration_id_,
                                                                                  location_no_,
                                                                                  lot_batch_no_,
                                                                                  serial_no_,
                                                                                  eng_chg_level_,
                                                                                  waiv_dev_rej_no_,
                                                                                  activity_seq_,
                                                                                  handling_unit_id_); 

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => owning_customer_name_);
   $ELSE
      NULL;   
   $END
END Add_Owning_Customer_Name___;


PROCEDURE Add_Net_Weight___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   net_weight_ NUMBER;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      net_weight_ := NVL(Inventory_Part_API.Get_Weight_Net(contract_, part_no_),0);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'NET_WEIGHT',
                                        data_item_value_     => net_weight_);
   $ELSE
      NULL;   
   $END
END Add_Net_Weight___;


PROCEDURE Add_Net_Volume___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   net_volume_ NUMBER;
BEGIN

   net_volume_ := NVL(Inventory_Part_API.Get_Volume_Net(contract_, part_no_),0);
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'NET_VOLUME',
                                        data_item_value_     => net_volume_);
   $ELSE
      NULL;   
   $END
END Add_Net_Volume___;


PROCEDURE Add_Part_Type___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   part_type_        VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      part_type_ := Inventory_Part_API.Get_Type_Code_Db(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PART_TYPE',
                                        data_item_value_     => part_type_);
   $ELSE
      NULL;   
   $END
END Add_Part_Type___;


PROCEDURE Add_Prime_Commodity___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   prime_commodity_     VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      prime_commodity_ := Inventory_Part_API.Get_Prime_Commodity(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PRIME_COMMODITY',
                                        data_item_value_     => prime_commodity_);
   $ELSE
      NULL;   
   $END
END Add_Prime_Commodity___;


PROCEDURE Add_Prime_Commodity_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   prime_commodity_      VARCHAR2(5);
   prime_commodity_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      prime_commodity_        := Inventory_Part_API.Get_Prime_Commodity(contract_, part_no_);
      prime_commodity_desc_   := Commodity_Group_API.Get_Description(prime_commodity_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PRIME_COMMODITY_DESCRIPTION',
                                        data_item_value_     => prime_commodity_desc_);
   $ELSE
      NULL;   
   $END
END Add_Prime_Commodity_Desc___;


PROCEDURE Add_Second_Commodity___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   second_commodity_     VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      second_commodity_ := Inventory_Part_API.Get_Second_Commodity(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SECOND_COMMODITY',
                                        data_item_value_     => second_commodity_);
   $ELSE
      NULL;   
   $END
END Add_Second_Commodity___;


PROCEDURE Add_Second_Commodity_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   second_commodity_      VARCHAR2(5);
   second_commodity_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      second_commodity_        := Inventory_Part_API.Get_Second_Commodity(contract_, part_no_);
      second_commodity_desc_   := Commodity_Group_API.Get_Description(second_commodity_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SECOND_COMMODITY_DESCRIPTION',
                                        data_item_value_     => second_commodity_desc_);
   $ELSE
      NULL;   
   $END
END Add_Second_Commodity_Desc___;


PROCEDURE Add_Asset_Class___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   asset_class_ VARCHAR2(2);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      asset_class_ := Inventory_Part_API.Get_Asset_Class(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ASSET_CLASS',
                                        data_item_value_     => asset_class_);
   $ELSE
      NULL;   
   $END
END Add_Asset_Class___;


PROCEDURE Add_Asset_Class_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   asset_class_      VARCHAR2(2);
   asset_class_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      asset_class_      := Inventory_Part_API.Get_Asset_Class(contract_, part_no_);
      asset_class_desc_ := Asset_Class_API.Get_Description(asset_class_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ASSET_CLASS_DESCRIPTION',
                                        data_item_value_     => asset_class_desc_);
   $ELSE
      NULL;   
   $END
END Add_Asset_Class_Desc___;


PROCEDURE Add_Part_Status___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   part_status_ VARCHAR2(1);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      part_status_ := Inventory_Part_API.Get_Part_Status(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PART_STATUS',
                                        data_item_value_     => part_status_);
   $ELSE
      NULL;   
   $END
END Add_Part_Status___;


PROCEDURE Add_Part_Status_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   part_status_      VARCHAR2(1);
   part_status_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      part_status_      := Inventory_Part_API.Get_Part_Status(contract_, part_no_);
      part_status_desc_ := Inventory_Part_Status_Par_API.Get_Description(part_status_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PART_STATUS_DESCRIPTION',
                                        data_item_value_     => part_status_desc_);
   $ELSE
      NULL;   
   $END
END Add_Part_Status_Desc___;


PROCEDURE Add_ABC_Class___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   abc_class_ VARCHAR2(1);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      abc_class_ := Inventory_Part_API.Get_Abc_Class(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ABC_CLASS',
                                        data_item_value_     => abc_class_);
   $ELSE
      NULL;   
   $END
END Add_ABC_Class___;


PROCEDURE Add_ABC_Class_Percent___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   abc_class_           VARCHAR2(1);
   abc_class_percent_   NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      abc_class_           := Inventory_Part_API.Get_Abc_Class(contract_, part_no_);
      abc_class_percent_   := Abc_Class_API.Get_Abc_Percent(abc_class_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ABC_CLASS_PERCENT',
                                        data_item_value_     => abc_class_percent_);
   $ELSE
      NULL;   
   $END
END Add_ABC_Class_Percent___;


PROCEDURE Add_Safety_Code___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   safety_code_ VARCHAR2(6);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      safety_code_ := Inventory_Part_API.Get_Hazard_Code(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SAFETY_CODE',
                                        data_item_value_     => safety_code_);
   $ELSE
      NULL;   
   $END
END Add_Safety_Code___;


PROCEDURE Add_Safety_Code_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   safety_code_ VARCHAR2(6);
   safety_code_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      safety_code_      := Inventory_Part_API.Get_Hazard_Code(contract_, part_no_);
      safety_code_desc_ := Safety_Instruction_API.Get_Description(safety_code_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SAFETY_CODE_DESCRIPTION',
                                        data_item_value_     => safety_code_desc_);
   $ELSE
      NULL;   
   $END
END Add_Safety_Code_Desc___;


PROCEDURE Add_Accounting_Group___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   accounting_group_ VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      accounting_group_ := Inventory_Part_API.Get_Accounting_Group(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ACCOUNTING_GROUP',
                                        data_item_value_     => accounting_group_);
   $ELSE
      NULL;   
   $END
END Add_Accounting_Group___;


PROCEDURE Add_Accounting_Group_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   accounting_group_       VARCHAR2(6);
   accounting_group_desc_  VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      accounting_group_      := Inventory_Part_API.Get_Accounting_Group(contract_, part_no_);
      accounting_group_desc_ := Accounting_Group_API.Get_Description(accounting_group_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ACCOUNTING_GROUP_DESCRIPTION',
                                        data_item_value_     => accounting_group_desc_);
   $ELSE
      NULL;   
   $END
END Add_Accounting_Group_Desc___;


PROCEDURE Add_Product_Code___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   product_code_ VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      product_code_ := Inventory_Part_API.Get_Part_Product_Code(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PRODUCT_CODE',
                                        data_item_value_     => product_code_);
   $ELSE
      NULL;   
   $END
END Add_Product_Code___;


PROCEDURE Add_Product_Code_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   product_code_        VARCHAR2(6);
   product_code_desc_   VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      product_code_        := Inventory_Part_API.Get_Part_Product_Code(contract_, part_no_);
      product_code_desc_   := Inventory_Product_Code_API.Get_Description(product_code_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PRODUCT_CODE_DESCRIPTION',
                                        data_item_value_     => product_code_desc_);
   $ELSE
      NULL;   
   $END
END Add_Product_Code_Desc___;


PROCEDURE Add_Product_Family___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   product_family_ VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      product_family_ := Inventory_Part_API.Get_Part_Product_Family(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PRODUCT_FAMILY',
                                        data_item_value_     => product_family_);
   $ELSE
      NULL;   
   $END
END Add_Product_Family___;


PROCEDURE Add_Product_Family_Desc___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   product_family_        VARCHAR2(6);
   product_family_desc_   VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      product_family_      := Inventory_Part_API.Get_Part_Product_Family(contract_, part_no_);
      product_family_desc_ := Inventory_Product_Family_API.Get_Description(product_family_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PRODUCT_FAMILY_DESCRIPTION',
                                        data_item_value_     => product_family_desc_);
   $ELSE
      NULL;   
   $END
END Add_Product_Family_Desc___;


PROCEDURE Add_Type_Designation___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   type_designation_ VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      type_designation_ := Inventory_Part_API.Get_Type_Designation(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'TYPE_DESIGNATION',
                                        data_item_value_     => type_designation_);
   $ELSE
      NULL;   
   $END
END Add_Type_Designation___;


PROCEDURE Add_Dim_Quality___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   dim_quality_ VARCHAR2(6);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      dim_quality_ := Inventory_Part_API.Get_Dim_Quality(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => dim_quality_);
   $ELSE
      NULL;   
   $END
END Add_Dim_Quality___;


PROCEDURE Add_Serial_Trk_Rcpt_Issue___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   option_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      option_ := Part_Catalog_API.Get_Receipt_Issue_Serial_Tr_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SERIAL_TRACKING_RECEIPT_ISSUE',
                                        data_item_value_     => option_);
   $ELSE
      NULL;   
   $END
END Add_Serial_Trk_Rcpt_Issue___;


PROCEDURE Add_Serial_Track_Inventory___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   option_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      option_ := Part_Catalog_API.Get_Serial_Tracking_Code_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SERIAL_TRACKING_INVENTORY',
                                        data_item_value_     => option_);
   $ELSE
      NULL;   
   $END
END Add_Serial_Track_Inventory___;


PROCEDURE Add_Serial_Track_Delivery___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   option_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      option_ := Part_Catalog_API.Get_Eng_Serial_Tracking_Cod_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SERIAL_TRACKING_DELIVERY',
                                        data_item_value_     => option_);
   $ELSE
      NULL;   
   $END
END Add_Serial_Track_Delivery___;


PROCEDURE Add_Stop_Arr_Issued_Serial___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   option_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      option_ := Part_Catalog_API.Get_Stop_Arrival_Issued_Ser_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'STOP_ARRIVAL_ISSUED_SERIAL',
                                        data_item_value_     => option_);
   $ELSE
      NULL;   
   $END
END Add_Stop_Arr_Issued_Serial___;


PROCEDURE Add_Stop_New_Serial_RMA___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   option_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF(Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE) THEN 
         option_ := Part_Catalog_API.Get_Stop_New_Serial_In_Rma_Db(part_no_);
      ELSE
         option_ := 'NULL';
      END IF;
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'STOP_NEW_SERIAL_IN_RMA',
                                        data_item_value_     => option_);
   $ELSE
      NULL;   
   $END
END Add_Stop_New_Serial_RMA___;


PROCEDURE Add_Serial_Rule___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   serial_rule_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      serial_rule_ := Part_Catalog_API.Get_Serial_Rule_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SERIAL_RULE',
                                        data_item_value_     => serial_rule_);
   $ELSE
      NULL;   
   $END
END Add_Serial_Rule___;


PROCEDURE Add_Lot_Batch_Tracking___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   lot_batch_tracking_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      lot_batch_tracking_ := Part_Catalog_API.Get_Lot_Tracking_Code_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'LOT_BATCH_TRACKING',
                                        data_item_value_     => lot_batch_tracking_);
   $ELSE
      NULL;   
   $END
END Add_Lot_Batch_Tracking___;


PROCEDURE Add_Lot_Quantity_Rule___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   lot_quantity_rule_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      lot_quantity_rule_ := Part_Catalog_API.Get_Lot_Quantity_Rule_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'LOT_QUANTITY_RULE',
                                        data_item_value_     => lot_quantity_rule_);
   $ELSE
      NULL;   
   $END
END Add_Lot_Quantity_Rule___;


PROCEDURE Add_Sub_Lot_Rule___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   sub_lot_rule_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      sub_lot_rule_ := Part_Catalog_API.Get_Sub_Lot_Rule_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SUB_LOT_RULE',
                                        data_item_value_     => sub_lot_rule_);
   $ELSE
      NULL;   
   $END
END Add_Sub_Lot_Rule___;


PROCEDURE Add_Component_Lot_Rule___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   component_lot_rule_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      component_lot_rule_ := Part_Catalog_API.Get_Component_Lot_Rule_Db(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'COMPONENT_LOT_RULE',
                                        data_item_value_     => component_lot_rule_);
   $ELSE
      NULL;   
   $END
END Add_Component_Lot_Rule___;


PROCEDURE Add_GTIN_Default___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   gtin_no_ VARCHAR2(14);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'GTIN_DEFAULT',
                                        data_item_value_     => gtin_no_);
   $ELSE
      NULL;   
   $END
END Add_GTIN_Default___;

PROCEDURE Add_Input_Conv_Factor___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   input_uom_group_id_ VARCHAR2(30);
   input_uom_          VARCHAR2(30);
   input_conv_factor_  NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      input_uom_group_id_ := Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(contract_, part_no_);
      input_uom_ := Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'INPUT_UOM');
                                                                      
      input_conv_factor_ := Input_Unit_Meas_API.Get_Conversion_Factor(input_uom_group_id_, input_uom_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'INPUT_CONV_FACTOR',
                                        data_item_value_     => input_conv_factor_);
   $ELSE
      NULL;   
   $END
END Add_Input_Conv_Factor___;


PROCEDURE Add_GTIN_Identification___ (
   capture_session_id_  IN NUMBER,     
   owning_data_item_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   gtin_no_     VARCHAR2(14);
   used_for_id_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      gtin_no_        := Part_Gtin_API.Get_Default_Gtin_No(part_no_);
      used_for_id_ := Part_Gtin_API.Get_Used_For_Identification_Db(part_no_, gtin_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'GTIN_IDENTIFICATION',
                                        data_item_value_     => used_for_id_);
   $ELSE
      NULL;   
   $END
END Add_GTIN_Identification___;


PROCEDURE Add_Catch_Unit_Meas_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   catch_uom_      VARCHAR2(200);
   catch_uom_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (contract_ IS NOT NULL AND part_no_ IS NOT NULL) THEN
         catch_uom_        := Inventory_Part_API.Get_Catch_Unit_Meas(contract_, part_no_);
         catch_uom_desc_   := ISO_UNIT_API.Get_Description(catch_uom_);
      END IF;
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'CATCH_UNIT_MEAS_DESCRIPTION',
                                        data_item_value_     => catch_uom_desc_);
   $ELSE
      NULL;   
   $END
END Add_Catch_Unit_Meas_Desc___;


PROCEDURE Add_Unit_Meas_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   uom_        VARCHAR2(200);        
   uom_desc_   VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      uom_        := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
      uom_desc_   := ISO_UNIT_API.Get_Description(uom_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'UNIT_MEAS_DESCRIPTION',
                                        data_item_value_     => uom_desc_);
   $ELSE
      NULL;   
   $END
END Add_Unit_Meas_Desc___;


PROCEDURE Add_Part_Default_Locations___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   def_loc_long_string_   VARCHAR2(32000);
   def_loc_string_        VARCHAR2(200);

   CURSOR get_all_default_locations_ IS
      SELECT location_no
      FROM inventory_part_def_loc_tab
      WHERE contract = contract_
      AND   part_no =  part_no_;
BEGIN
   FOR loc_rec_ IN get_all_default_locations_ LOOP
      def_loc_long_string_ := def_loc_long_string_ || loc_rec_.location_no || ', ';
   END LOOP;
   IF ( length(def_loc_long_string_) > 2) THEN
      def_loc_long_string_ := SUBSTR(def_loc_long_string_, 1, (length(def_loc_long_string_)-2));   -- remove last ', '
   END IF;
   -- we will not cut a too long string nicely so the user noticed that this is not a good detail to use if to many default locations exist
   def_loc_string_ := SUBSTR(def_loc_long_string_,1,200);   

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PART_DEFAULT_LOCATIONS',
                                        data_item_value_     => def_loc_string_);
   $ELSE
      NULL;   
   $END

END Add_Part_Default_Locations___;


PROCEDURE Add_Part_Def_Locations_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   def_loc_long_string_   VARCHAR2(32000);
   def_loc_string_        VARCHAR2(200);

   CURSOR get_all_default_locations_ IS
      SELECT location_no
      FROM inventory_part_def_loc_tab
      WHERE contract = contract_
      AND   part_no =  part_no_;
BEGIN
   FOR loc_rec_ IN get_all_default_locations_ LOOP
      def_loc_long_string_ := def_loc_long_string_ || Inventory_Location_API.Get_Location_Name(contract_, loc_rec_.location_no) || ', ';
   END LOOP;
   IF ( length(def_loc_long_string_) > 2) THEN
      def_loc_long_string_ := SUBSTR(def_loc_long_string_, 1, (length(def_loc_long_string_)-2));   -- remove last ', '
   END IF;
   -- we will not cut a too long string nicely so the user noticed that this is not a good detail to use if to many default locations exist
   def_loc_string_ := SUBSTR(def_loc_long_string_,1,200);   


   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'PART_DEFAULT_LOCATIONS_DESC',
                                        data_item_value_     => def_loc_string_);
   $ELSE
      NULL;   
   $END

END Add_Part_Def_Locations_Desc___;


PROCEDURE Add_Loc_With_Reserved_Qty___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   loc_long_string_   VARCHAR2(32000);
   loc_string_        VARCHAR2(200);

   CURSOR get_all_loc_with_reserved_qty IS
      SELECT location_no
      FROM inventory_part_in_stock_tab
      WHERE contract = contract_
      AND   part_no  = part_no_
      AND   qty_reserved > 0;
BEGIN
   FOR loc_rec_ IN get_all_loc_with_reserved_qty LOOP
      loc_long_string_ := loc_long_string_ || loc_rec_.location_no || ', ';
   END LOOP;
   IF ( length(loc_long_string_) > 2) THEN
      loc_long_string_ := SUBSTR(loc_long_string_, 1, (length(loc_long_string_)-2));   -- remove last ', '
   END IF;
   -- we will not cut a too long string nicely so the user noticed that this is not a good detail to use if to many locations exist
   loc_string_ := SUBSTR(loc_long_string_,1,200);   


   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'LOCATIONS_WITH_RESERVED_QTY',
                                        data_item_value_     => loc_string_);
   $END

END Add_Loc_With_Reserved_Qty___;


PROCEDURE Add_Loc_With_Available_Qty___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   loc_long_string_   VARCHAR2(32000);
   loc_string_        VARCHAR2(200);

   CURSOR get_all_loc_with_available_qty IS
      SELECT location_no
      FROM inventory_part_in_stock_tab
      WHERE contract = contract_
      AND   part_no  = part_no_
      AND   (qty_onhand - qty_reserved) > 0;
BEGIN
   FOR loc_rec_ IN get_all_loc_with_available_qty LOOP
      loc_long_string_ := loc_long_string_ || loc_rec_.location_no || ', ';
   END LOOP;
   IF ( length(loc_long_string_) > 2) THEN
      loc_long_string_ := SUBSTR(loc_long_string_, 1, (length(loc_long_string_)-2));   -- remove last ', '
   END IF;
   -- we will not cut a too long string nicely so the user noticed that this is not a good detail to use if to many locations exist
   loc_string_ := SUBSTR(loc_long_string_,1,200);   


   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'LOCATIONS_WITH_AVAILABLE_QTY',
                                        data_item_value_     => loc_string_);
   $END

END Add_Loc_With_Available_Qty___;


PROCEDURE Add_Origin_Pack_Size___(
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   barcode_id_          IN NUMBER)
IS
   origin_pack_size_ VARCHAR2(50);
   contract_         VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   contract_ := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_);
   origin_pack_size_ := Get_Value_From_Barcode_Id(contract_, barcode_id_, data_item_detail_id_);
   Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                     data_item_id_        => owning_data_item_id_,
                                     data_item_detail_id_ => data_item_detail_id_,
                                     data_item_value_     => origin_pack_size_);
   $ELSE
      NULL;
   $END
END Add_Origin_Pack_Size___;


PROCEDURE Add_Availability_Ctrl_Desc___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   availability_control_id_   VARCHAR2(25);
   availability_control_desc_ VARCHAR2(200);
BEGIN   
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      availability_control_id_ := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_, 
                                                                                          part_no_, 
                                                                                          configuration_id_, 
                                                                                          location_no_, 
                                                                                          lot_batch_no_, 
                                                                                          serial_no_, 
                                                                                          eng_chg_level_, 
                                                                                          waiv_dev_rej_no_, 
                                                                                          activity_seq_,
                                                                                          handling_unit_id_);
      IF (availability_control_id_ IS NOT NULL) THEN
         availability_control_desc_ := SUBSTR(Part_Availability_Control_API.Get_Description(availability_control_id_), 1, 200);
      END IF; 
   
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                       data_item_id_        => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,
                                       data_item_value_     => availability_control_desc_);
   $ELSE
      NULL;
   $END
END Add_Availability_Ctrl_Desc___;

   
PROCEDURE Add_Quantity_In_Transit___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   qty_in_transit_ VARCHAR2(200);
BEGIN  
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      qty_in_transit_ := Inventory_Part_In_Stock_API.Get_Qty_In_Transit(contract_, 
                                                                        part_no_, 
                                                                        configuration_id_, 
                                                                        location_no_, 
                                                                        lot_batch_no_,
                                                                        serial_no_, 
                                                                        eng_chg_level_, 
                                                                        waiv_dev_rej_no_, 
                                                                        activity_seq_,
                                                                        handling_unit_id_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => qty_in_transit_);
   $ELSE
      NULL;
   $END
END Add_Quantity_In_Transit___;


PROCEDURE Add_Catch_Qty_In_Transit___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   catch_qty_in_transit_ VARCHAR2(200);
BEGIN   

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      catch_qty_in_transit_ := Inventory_Part_In_Stock_API.Get_Catch_Qty_In_Transit(contract_, 
                                                                                    part_no_, 
                                                                                    configuration_id_, 
                                                                                    location_no_, 
                                                                                    lot_batch_no_,
                                                                                    serial_no_, 
                                                                                    eng_chg_level_, 
                                                                                    waiv_dev_rej_no_, 
                                                                                    activity_seq_,
                                                                                    handling_unit_id_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                       data_item_id_        => owning_data_item_id_,
                                       data_item_detail_id_ => data_item_detail_id_,
                                       data_item_value_     => catch_qty_in_transit_);
   $ELSE
      NULL;
   $END
END Add_Catch_Qty_In_Transit___;


PROCEDURE Add_Quantity_Reserved___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   qty_reserved_ VARCHAR2(200);
BEGIN  
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      qty_reserved_ := Inventory_Part_In_Stock_API.Get_Qty_Reserved(contract_, 
                                                                    part_no_, 
                                                                    configuration_id_, 
                                                                    location_no_, 
                                                                    lot_batch_no_,
                                                                    serial_no_, 
                                                                    eng_chg_level_, 
                                                                    waiv_dev_rej_no_, 
                                                                    activity_seq_,
                                                                    handling_unit_id_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => qty_reserved_);
   $ELSE
      NULL;
   $END
END Add_Quantity_Reserved___;


PROCEDURE Add_Freeze_Flag___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   freeze_flag_db_  VARCHAR2(200);
BEGIN  
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      freeze_flag_db_ := Inventory_Part_In_Stock_API.Get_Freeze_Flag_Db(contract_, 
                                                                        part_no_, 
                                                                        configuration_id_, 
                                                                        location_no_, 
                                                                        lot_batch_no_,
                                                                        serial_no_, 
                                                                        eng_chg_level_, 
                                                                        waiv_dev_rej_no_, 
                                                                        activity_seq_,
                                                                        handling_unit_id_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => freeze_flag_db_);
   $ELSE
      NULL;
   $END
END Add_Freeze_Flag___;


PROCEDURE Add_Last_Activity_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   last_activity_date_  VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      last_activity_date_ := Inventory_Part_In_Stock_API.Get_Last_Activity_Date(contract_, 
                                                                                part_no_, 
                                                                                configuration_id_, 
                                                                                location_no_, 
                                                                                lot_batch_no_, 
                                                                                serial_no_, 
                                                                                eng_chg_level_, 
                                                                                waiv_dev_rej_no_, 
                                                                                activity_seq_,
                                                                                handling_unit_id_);

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => last_activity_date_);
   $ELSE
      NULL;   
   $END
END Add_Last_Activity_Date___;


PROCEDURE Add_Last_Count_Date___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   last_count_date_  VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      last_count_date_ := Inventory_Part_In_Stock_API.Get_Last_Count_Date(contract_, 
                                                                          part_no_, 
                                                                          configuration_id_, 
                                                                          location_no_, 
                                                                          lot_batch_no_, 
                                                                          serial_no_, 
                                                                          eng_chg_level_, 
                                                                          waiv_dev_rej_no_, 
                                                                          activity_seq_,
                                                                          handling_unit_id_);

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => last_count_date_);
   $ELSE
      NULL;   
   $END
END Add_Last_Count_Date___;


PROCEDURE Add_Owner_Name___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   owner_name_  VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      owner_name_ := Inventory_Part_In_Stock_API.Get_Owner_Name(contract_, 
                                                                part_no_, 
                                                                configuration_id_, 
                                                                location_no_, 
                                                                lot_batch_no_, 
                                                                serial_no_, 
                                                                eng_chg_level_, 
                                                                waiv_dev_rej_no_, 
                                                                activity_seq_,
                                                                handling_unit_id_);

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => owner_name_);
   $ELSE
      NULL;   
   $END
END Add_Owner_Name___;


PROCEDURE Add_Rotable_Part_Pool_Id___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   rotable_part_pool_id_  VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      rotable_part_pool_id_ := Inventory_Part_In_Stock_API.Get_Rotable_Part_Pool_Id(contract_, 
                                                                                    part_no_, 
                                                                                    configuration_id_, 
                                                                                    location_no_, 
                                                                                    lot_batch_no_, 
                                                                                    serial_no_, 
                                                                                    eng_chg_level_, 
                                                                                    waiv_dev_rej_no_, 
                                                                                    activity_seq_,
                                                                                    handling_unit_id_);

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => rotable_part_pool_id_);
   $ELSE
      NULL;   
   $END
END Add_Rotable_Part_Pool_Id___;   


PROCEDURE Add_Total_Acquisition_Value___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   total_acquisition_value_  VARCHAR2(200);
   owning_customer_no_       VARCHAR2(20);
   qty_onhand_               NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      owning_customer_no_ := Inventory_Part_In_Stock_API.Get_Owning_Customer_No(contract_, 
                                                                                       part_no_, 
                                                                                       configuration_id_, 
                                                                                       location_no_, 
                                                                                       lot_batch_no_, 
                                                                                       serial_no_, 
                                                                                       eng_chg_level_, 
                                                                                       waiv_dev_rej_no_, 
                                                                                       activity_seq_,
                                                                                       handling_unit_id_);
      qty_onhand_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_, 
                                                                part_no_, 
                                                                configuration_id_, 
                                                                location_no_, 
                                                                lot_batch_no_, 
                                                                serial_no_, 
                                                                eng_chg_level_, 
                                                                waiv_dev_rej_no_, 
                                                                activity_seq_,
                                                                handling_unit_id_);


      $IF Component_Order_SYS.INSTALLED $THEN
         total_acquisition_value_ := TO_CHAR(qty_onhand_ * Cust_Part_Acq_Value_API.Get_Acquisition_Value(owning_customer_no_,
                                                                                                         part_no_,
                                                                                                         serial_no_,
                                                                                                         lot_batch_no_));
      $END
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => total_acquisition_value_);
   $ELSE
      NULL;   
   $END
END Add_Total_Acquisition_Value___;


PROCEDURE Add_Total_Inventory_Value___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   total_inventory_value_  VARCHAR2(200);
   company_owned_unit_cost_  NUMBER;
   qty_onhand_               NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      company_owned_unit_cost_ := Inventory_Part_In_Stock_API.Get_Company_Owned_Unit_Cost(contract_, 
                                                                                          part_no_, 
                                                                                          configuration_id_, 
                                                                                          location_no_, 
                                                                                          lot_batch_no_, 
                                                                                          serial_no_, 
                                                                                          eng_chg_level_, 
                                                                                          waiv_dev_rej_no_, 
                                                                                          activity_seq_,
                                                                                          handling_unit_id_);
      qty_onhand_ := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_, 
                                                                part_no_, 
                                                                configuration_id_, 
                                                                location_no_, 
                                                                lot_batch_no_, 
                                                                serial_no_, 
                                                                eng_chg_level_, 
                                                                waiv_dev_rej_no_, 
                                                                activity_seq_,
                                                                handling_unit_id_);
      total_inventory_value_ := TO_CHAR(qty_onhand_ * company_owned_unit_cost_);

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => total_inventory_value_);
   $ELSE
      NULL;   
   $END
END Add_Total_Inventory_Value___;


PROCEDURE Add_Packing_Instr_Desc___(
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   data_item_value_     IN VARCHAR2 )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => Packing_Instruction_API.Get_Description(data_item_value_));
   $ELSE
      NULL;                                        
   $END
END Add_Packing_Instr_Desc___;


PROCEDURE Add_Handling_Unit_Type_Desc___(
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   data_item_value_     IN VARCHAR2 )
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => Handling_Unit_Type_API.Get_Description(data_item_value_));
   $ELSE
      NULL;                                        
   $END
END Add_Handling_Unit_Type_Desc___;


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
   to_location_no_               VARCHAR2(35);
   serial_no_                    VARCHAR2(50);
   configuration_id_             VARCHAR2(50);
   lot_batch_no_                 VARCHAR2(20);
   eng_chg_level_                VARCHAR2(6);
   condition_code_               VARCHAR2(10);
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   get_part_no_                  BOOLEAN := FALSE;
   get_to_contract_              BOOLEAN := FALSE;
   mandatory_non_process_key_    BOOLEAN := FALSE;
   origin_pack_size_             NUMBER;
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   gtin_no_                      VARCHAR2(14);
   gtin_part_no_                 VARCHAR2(25);
   data_item_description_        VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      contract_ := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_);
      
      -- NOTE: Add mandatory, non-process keys, data items to this selection to use generic null check
      IF (data_item_id_ IN ('QUANTITY', 'WAIV_DEV_REJ_NO', 'QTY_COUNT1', 'PRINT_INVENTORY_PART_BARCODE', 'DESTINATION_WAIV_DEV_REJ_NO')) THEN
         mandatory_non_process_key_ := TRUE;
      END IF;      
      IF (data_item_id_ NOT IN ('BARCODE_ID', 'CONDITION_CODE')) THEN  -- Dont run mandatory not null check for these process keys
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, mandatory_non_process_key_);
      END IF;

      CASE (data_item_id_)
         WHEN ('CONFIGURATION_ID') THEN
            configuration_id_ := data_item_value_;
            get_part_no_      := TRUE;
         WHEN ('PART_NO') THEN
            Part_Catalog_API.Exist(data_item_value_);
            Inventory_Part_API.Exist(contract_, data_item_value_);
            part_no_          := data_item_value_;
            configuration_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                   data_item_id_a_     => 'CONFIGURATION_ID',
                                                                                   data_item_id_b_     => data_item_id_);
            serial_no_        := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                   data_item_id_a_     => 'SERIAL_NO',
                                                                                   data_item_id_b_     => data_item_id_);
            lot_batch_no_     := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                   data_item_id_a_     => 'LOT_BATCH_NO',
                                                                                   data_item_id_b_     => data_item_id_);
            eng_chg_level_    := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                   data_item_id_a_     => 'ENG_CHG_LEVEL',
                                                                                   data_item_id_b_     => data_item_id_);
         WHEN ('LOCATION_NO') THEN
            Inventory_Location_API.Exist(contract_, data_item_value_);         
         WHEN ('TO_CONTRACT') THEN
            Site_API.Exist(data_item_value_);
            to_contract_ := data_item_value_;
         WHEN ('TO_LOCATION_NO') THEN
            to_location_no_  := data_item_value_;
            get_to_contract_ := TRUE;
         WHEN ('CONDITION_CODE') THEN
            condition_code_ := data_item_value_;
            get_part_no_    := TRUE;
         WHEN ('SERIAL_NO') THEN
            serial_no_   := data_item_value_;
            get_part_no_ := TRUE;
         WHEN ('LOT_BATCH_NO') THEN
            lot_batch_no_ := data_item_value_;
            get_part_no_  := TRUE;
         WHEN ('BARCODE_ID') THEN
            session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
            IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_ => session_rec_.capture_process_id,
                                                              capture_config_id_  => session_rec_.capture_config_id,
                                                              process_detail_id_  => 'BARCODE_ID_IS_MANDATORY' ) = Fnd_Boolean_API.DB_TRUE) THEN
               Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, 
                                                                      data_item_id_, 
                                                                      data_item_value_, 
                                                                      mandatory_non_process_key_ => TRUE);
            END IF;
         WHEN ('GTIN') THEN
            gtin_no_ := data_item_value_;
            get_part_no_  := TRUE;            
         WHEN ('DESTINATION') THEN
            Inventory_Part_Destination_API.Exist_Db(data_item_value_);
         WHEN ('ORIGIN_PACK_SIZE') THEN
            origin_pack_size_ := data_item_value_;
            IF origin_pack_size_ <= 0 THEN
               Error_SYS.Record_General(lu_name_,'ORIGINPACKSIZE: Origin pack size must be a value greater than 0.');
            END IF;
         WHEN ('PRINT_INVENTORY_PART_BARCODE') THEN
            Gen_Yes_No_API.Exist_Db(data_item_value_);
         WHEN ('AVAILABILITY_CONTROL_ID') THEN
            IF (data_item_value_ IS NOT NULL) THEN
               Part_Availability_Control_API.Exist(data_item_value_, TRUE);
            END IF;
         WHEN ('CONSUME_CONSIGNMENT') THEN
            Gen_Yes_No_API.Exist(data_item_value_);
         WHEN ('EXPIRATION_DATE') THEN
            IF (TRUNC(Client_SYS.Attr_Value_To_Date(data_item_value_)) < TRUNC(SYSDATE + 1)) THEN
               Error_SYS.Record_General(lu_name_, 'EXPIREDATEERR: The expiration date must be a future date.');
            END IF;
         WHEN ('PACKING_INSTRUCTION_ID') THEN
            IF (data_item_value_ IS NOT NULL) THEN
               Packing_Instruction_API.Exist(data_item_value_);
            END IF;
         WHEN ('HANDLING_UNIT_TYPE_ID') THEN
            IF (data_item_value_ IS NOT NULL) THEN
               Handling_Unit_Type_API.Exist(data_item_value_);
            END IF;
         ELSE
            NULL;
      END CASE;
      
      IF (get_to_contract_) THEN
         to_contract_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                           data_item_id_a_     => 'TO_CONTRACT',
                                                                           data_item_id_b_     => data_item_id_);
      END IF;

      IF (get_part_no_) THEN
         part_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                       data_item_id_a_     => 'PART_NO',
                                                                       data_item_id_b_     => data_item_id_);
      END IF;
      IF (to_contract_ IS NOT NULL) THEN
         IF (to_location_no_ IS NOT NULL) THEN
            Inventory_Location_API.Exist(to_contract_, to_location_no_);
         END IF;
      END IF;
      
      IF (data_item_id_ = 'GTIN') THEN
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_ => session_rec_.capture_process_id,
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           process_detail_id_  => 'GTIN_IS_MANDATORY' ) = Fnd_Boolean_API.DB_TRUE) THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, 
                                                                   data_item_id_, 
                                                                   data_item_value_, 
                                                                   mandatory_non_process_key_ => TRUE);
         END IF;
         IF (gtin_no_ IS NOT NULL) THEN   
            gtin_part_no_ := Part_Gtin_API.Get_Part_Via_Identified_Gtin(gtin_no_);
            IF (gtin_part_no_ IS NULL) OR ((part_no_ IS NOT NULL) AND (part_no_ != gtin_part_no_)) THEN
               data_item_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);
               Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', data_item_description_, gtin_no_);
            END IF;
         END IF;
      END IF;     
      
      IF (part_no_ IS NOT NULL) THEN
         part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
         IF (configuration_id_ IS NOT NULL) THEN 
            Inventory_Part_Config_API.Exist(contract_, part_no_, configuration_id_);
         END IF;

         IF (eng_chg_level_ IS NOT NULL) THEN
            Inventory_Part_Revision_API.Exist(contract_, part_no_, eng_chg_level_);
         END IF;

         IF (lot_batch_no_ IS NOT NULL) THEN
            Lot_Batch_Master_API.Check_Valid_Lot_For_Part(part_no_, lot_batch_no_);
         END IF;

         IF (serial_no_ IS NOT NULL) THEN
            Part_Serial_Catalog_API.Check_Valid_Serial_For_Part(part_no_, serial_no_); 
         END IF;

         IF (condition_code_ IS NOT NULL AND part_catalog_rec_.condition_code_usage = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE) THEN
            Condition_Code_API.Exist(condition_code_);
         ELSIF (condition_code_ IS NOT NULL AND part_catalog_rec_.condition_code_usage = Condition_Code_Usage_API.DB_NOT_ALLOW_CONDITION_CODE) THEN
            Error_SYS.Record_General(lu_name_,'CONDCODENOTALLOWED: Condition Code functionality is not enabled for this part.');
         ELSIF (data_item_id_ = 'CONDITION_CODE' AND condition_code_ IS NULL AND part_catalog_rec_.condition_code_usage = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE) THEN
            Error_SYS.Record_General(lu_name_,'CONDCODEMANDATORY: Condition Code functionality is enabled for this part and must have value.');
         END IF;
      END IF;
   $ELSE
      NULL;   
   $END
END Validate_Data_Item; 


PROCEDURE Match_Barcode_Keys (
   capture_session_id_ IN NUMBER,
   barcode_id_         IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   configuration_id_   IN VARCHAR2  )
IS
   inventory_part_barcode_rec_ Inventory_Part_Barcode_API.Public_Rec;
BEGIN

   -- Checking attributes on session and barcode to see if barcode and session match.
   inventory_part_barcode_rec_ := Inventory_Part_Barcode_API.Get(contract_, barcode_id_);
   IF (inventory_part_barcode_rec_.part_no          != NVL(part_no_,          inventory_part_barcode_rec_.part_no)          OR
       inventory_part_barcode_rec_.configuration_id != NVL(configuration_id_, inventory_part_barcode_rec_.configuration_id) OR
       inventory_part_barcode_rec_.lot_batch_no     != NVL(lot_batch_no_,     inventory_part_barcode_rec_.lot_batch_no)     OR
       inventory_part_barcode_rec_.serial_no        != NVL(serial_no_,        inventory_part_barcode_rec_.serial_no)        OR
       inventory_part_barcode_rec_.eng_chg_level    != NVL(eng_chg_level_,    inventory_part_barcode_rec_.eng_chg_level)    OR
       inventory_part_barcode_rec_.waiv_dev_rej_no  != NVL(waiv_dev_rej_no_,  inventory_part_barcode_rec_.waiv_dev_rej_no)  OR
       inventory_part_barcode_rec_.activity_seq     != NVL(activity_seq_,     inventory_part_barcode_rec_.activity_seq)) THEN
      Error_SYS.Record_General('DataCaptureInventUtil','BARCODENOTMATCH: Barcode ID :P1 does not exist in this context.', barcode_id_);
   END IF;
END Match_Barcode_Keys;


PROCEDURE Set_Media_Id_For_Data_Item  (
   capture_session_id_ IN NUMBER,
   line_no_            IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   contract_ VARCHAR2(5);
   media_id_ VARCHAR2(18);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      contract_ := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_);
      CASE (data_item_id_)
         WHEN ('PART_NO') THEN
            media_id_ := Inventory_Part_API.Get_Media_Id(contract_, data_item_value_);
         WHEN ('LOCATION_NO') THEN
            media_id_ := Warehouse_Bay_Bin_API.Get_Media_Id(contract_, data_item_value_);
         WHEN ('FROM_LOCATION_NO') THEN
            media_id_ := Warehouse_Bay_Bin_API.Get_Media_Id(contract_, data_item_value_);
         WHEN ('TO_LOCATION_NO') THEN
            media_id_ := Warehouse_Bay_Bin_API.Get_Media_Id(contract_, data_item_value_);
         ELSE
            NULL;
      END CASE;
      IF (media_id_ IS NOT NULL) THEN
         Data_Capture_Session_Line_API.Set_Media_Id(capture_session_id_, line_no_, data_item_id_, media_id_);
      END IF;
   $ELSE
      NULL;   
   $END
END Set_Media_Id_For_Data_Item ; 


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   data_item_id_                 IN VARCHAR2,
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   print_inventory_part_barcode_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
   automatic_value_  VARCHAR2(200);
BEGIN
   IF (part_no_ IS NOT NULL) THEN
      part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
   END IF;

   IF (data_item_id_ = 'QUANTITY' AND part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_serial_tracking) THEN
       -- if part is serial tracked it will always have quantity 1
       automatic_value_ := 1;
   ELSIF ((data_item_id_ IN ('CATCH_QUANTITY','CATCH_QTY_COUNTED','CATCH_QTY_PICKED','CATCH_QTY_TO_MOVE','CATCH_QTY_RETURNED','CATCH_QTY_SCRAPPED')) AND part_catalog_rec_.catch_unit_enabled = Fnd_Boolean_API.DB_FALSE) THEN
       automatic_value_ := 'NULL';
   ELSIF (data_item_id_ = 'CONFIGURATION_ID' AND part_catalog_rec_.configurable = Part_Configuration_API.db_not_configured) THEN
      -- part is not using configurations, return * for configuration_id
      automatic_value_ := '*';
   ELSIF (data_item_id_ = 'SERIAL_NO' AND part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_not_serial_tracking) THEN
      -- part is not serial tracked, return * for serial_no
      automatic_value_ := '*';
   ELSIF (data_item_id_ = 'CONDITION_CODE' AND part_catalog_rec_.condition_code_usage = Condition_Code_Usage_API.DB_NOT_ALLOW_CONDITION_CODE) THEN
      -- if part is not using condition code, condition_code should be null
      automatic_value_ := 'NULL';
   ELSIF (data_item_id_ = 'LOT_BATCH_NO' AND part_catalog_rec_.lot_tracking_code = Part_Lot_Tracking_API.db_not_lot_tracking) THEN
      -- part is not part lot tracked, return * for lot_batch_no
      automatic_value_ := '*';
   ELSIF (data_item_id_ = 'ENG_CHG_LEVEL' AND Inventory_Part_Revision_API.Get_Latest_Eng_Chg_Level(contract_, part_no_) = 1) THEN
      -- if part is not using eng chg level (level = 1), eng_chg_level should be 1
      automatic_value_ := 1;
   ELSIF (data_item_id_ = 'ACTIVITY_SEQ' AND Order_Supply_Demand_API.Open_Projects_Exist(contract_) = Fnd_Boolean_API.DB_FALSE) THEN
      -- if site dont have an open project, activity_seq should be 0
      automatic_value_ := 0;
   ELSIF (data_item_id_ = 'ORIGIN_PACK_SIZE') THEN
      IF (print_inventory_part_barcode_ = Gen_Yes_No_API.DB_NO) THEN
         automatic_value_ := 'NULL';
      END IF;
   END IF;   
   
   RETURN automatic_value_;
END Get_Automatic_Data_Item_Value;


PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
   session_rec_  Data_Capture_Common_Util_API.Session_Rec;
   part_no_      VARCHAR2(25);
   lov_type_db_  VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF data_item_id_ = 'LOCATION_NO' THEN
         Inventory_Location_API.Create_Data_Capture_Lov(contract_, capture_session_id_);
      ELSIF data_item_id_ = 'PART_NO' THEN
         Inventory_Part_API.Create_Data_Capture_Lov(contract_, capture_session_id_);
      ELSIF data_item_id_ = 'TO_LOCATION_NO' THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
                                                        capture_config_id_  => capture_config_id_,
                                                        data_item_id_a_     => 'TO_CONTRACT',
                                                        data_item_id_b_     => 'TO_LOCATION_NO')) THEN
            Inventory_Location_API.Create_Data_Capture_Lov(contract_           => Data_Capture_Session_Line_API.Get_Latest_Data_Item_Value(capture_session_id_, 'TO_CONTRACT'), 
                                                           capture_session_id_ => capture_session_id_, 
                                                           lov_id_             => 1);
         ELSE
            Inventory_Location_API.Create_Data_Capture_Lov(contract_           => NULL, 
                                                           capture_session_id_ => capture_session_id_, 
                                                           lov_id_             => 2);
         END IF;
      ELSIF data_item_id_ = 'CONDITION_CODE' THEN
         part_no_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                       data_item_id_a_     => 'PART_NO',
                                                                       data_item_id_b_     => data_item_id_);
         -- Only create a LOV if we have the part_no and its condition code handled or 
         -- if we don't know if it is condition code handled since part comes after condition code in the configuration
         IF (part_no_ IS NULL OR Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_) = Condition_Code_Usage_API.DB_ALLOW_CONDITION_CODE) THEN
            lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
            Condition_Code_API.Create_Data_Capture_Lov(capture_session_id_, lov_type_db_);
         END IF;
      ELSIF data_item_id_ = 'DESTINATION' THEN
        Inventory_Part_Destination_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF data_item_id_ = 'TO_CONTRACT' THEN
         IF (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => capture_process_id_,
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
      ELSIF data_item_id_ IN ('PRINT_INVENTORY_PART_BARCODE', 'CONFIRM', 'PRINT_SERVICEABILITY_TAG', 'CONSUME_CONSIGNMENT') THEN
         Gen_Yes_No_API.Create_Data_Capture_Lov(capture_session_id_ => capture_session_id_);
      ELSIF (data_item_id_ = 'AVAILABILITY_CONTROL_ID') THEN
         Part_Availability_Control_API.Create_Data_Capture_Lov(capture_session_id_ => capture_session_id_);
      END IF;
   $ELSE
      NULL;   
   $END
END Create_List_Of_Values;


/* This is used by Find Inventory process only */
PROCEDURE Add_Details_For_Find_Inventory (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_tab_ IN Data_Capture_Common_Util_API.Config_Item_Detail_Tab,
   contract_           IN VARCHAR2,   
   part_no_            IN VARCHAR2,
   location_no_        IN VARCHAR2,
   gtin_no_            IN VARCHAR2,
   gs1_                IN VARCHAR2 )
IS  
   detail_item_value_       VARCHAR2(4000);
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   
   CURSOR get_values IS
      SELECT part_no, location_no, sum(qty_onhand) AS qty_onhand, sum(qty_reserved) AS qty_reserved
      FROM   inventory_part_in_stock_tab
      WHERE  contract    = contract_
      AND    part_no     = NVL(part_no_, part_no)
      AND    location_no = NVL(location_no_, location_no)
      AND    qty_onhand > 0
      GROUP BY part_no, location_no
      ORDER BY Utility_SYS.String_To_Number(location_no) ASC, location_no ASC, Utility_SYS.String_To_Number(part_no) ASC, part_no ASC;   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      
      FOR rec_ IN get_values  LOOP 
         FOR i IN data_item_detail_tab_.FIRST..data_item_detail_tab_.LAST LOOP
            CASE (data_item_detail_tab_(i).data_item_detail_id)
               WHEN ('PART_NO') THEN
                  detail_item_value_ := rec_.part_no;
               WHEN ('LOCATION_NO') THEN
                  detail_item_value_ := rec_.location_no;
               WHEN ('GTIN_NO') THEN
                  detail_item_value_ := gtin_no_;
               WHEN ('GS1') THEN -- not yet implemented
                  NULL;
               WHEN ('LOCATION_NO_DESC') THEN
                  Add_Details_For_Location_No(capture_session_id_, owning_data_item_id_, 'LOCATION_NO_DESC', contract_, rec_.location_no);
                  detail_item_value_ := NULL;
               WHEN ('PART_DESCRIPTION') THEN
                  Add_Details_For_Part_No(capture_session_id_, owning_data_item_id_, 'PART_DESCRIPTION', contract_, rec_.part_no);
                  detail_item_value_ := NULL;   
               WHEN ('PART_NO_ON_HAND_QTY_UOM') THEN
                  detail_item_value_ := rec_.part_no || ' | ' || rec_.qty_onhand || ' | ' || Inventory_Part_API.Get_Unit_Meas(contract_, rec_.part_no);
               WHEN ('AVAILABLE_QTY_RESERVED_QTY_UOM') THEN
                  detail_item_value_ := (rec_.qty_onhand - rec_.qty_reserved) || ' | ' || rec_.qty_reserved || ' | ' || Inventory_Part_API.Get_Unit_Meas(contract_, rec_.part_no); 
               WHEN ('LOCATION_NO_ON_HAND_QTY_UOM') THEN
                  detail_item_value_ := rec_.location_no || ' | ' || rec_.qty_onhand || ' | ' || Inventory_Part_API.Get_Unit_Meas(contract_, rec_.part_no);
               WHEN ('WAREHOUSE_BAY_ROW_TIER_BIN') THEN
                  Add_Details_For_Location_No(capture_session_id_, owning_data_item_id_, 'WAREHOUSE_BAY_ROW_TIER_BIN', contract_, rec_.location_no);
                  detail_item_value_ := NULL;                    
            ELSE 
               NULL;
            END CASE;
            IF (detail_item_value_ IS NOT NULL) THEN
               Data_Capture_Session_Line_API.New(capture_session_id_     => capture_session_id_,
                                                    data_item_id_        => owning_data_item_id_,
                                                    data_item_detail_id_ => data_item_detail_tab_(i).data_item_detail_id,
                                                    data_item_value_     => detail_item_value_);
               
            END IF;
         END LOOP; 
         Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                           data_item_id_        => owning_data_item_id_,
                                           data_item_detail_id_ => 'SEPARATOR',
                                           data_item_value_     => '  ');
      END LOOP;
   $ELSE
      NULL;
   $END
END Add_Details_For_Find_Inventory;


@UncheckedAccess
FUNCTION Get_Serial_No (
   part_catalog_rec_   IN Part_Catalog_API.Public_Rec ) RETURN VARCHAR2   
IS
   serial_no_ VARCHAR2(50);
BEGIN
   IF (part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.db_not_serial_tracking) THEN
      serial_no_ := '*';
   END IF;
   RETURN serial_no_;
END Get_Serial_No;


@UncheckedAccess
FUNCTION Get_Configuration_Id (
   part_catalog_rec_   IN Part_Catalog_API.Public_Rec ) RETURN VARCHAR2   
IS
   configuration_id_ VARCHAR2(50);
BEGIN
   IF (part_catalog_rec_.configurable = Part_Configuration_API.db_not_configured) THEN
      configuration_id_ := '*';
   END IF;
   RETURN configuration_id_;
END Get_Configuration_Id;


@UncheckedAccess
FUNCTION Get_Lot_Batch_No (
   part_catalog_rec_   IN Part_Catalog_API.Public_Rec ) RETURN VARCHAR2   
IS
   lot_batch_no_ VARCHAR2(20);
BEGIN
   IF (part_catalog_rec_.lot_tracking_code = Part_Lot_Tracking_API.db_not_lot_tracking) THEN
      lot_batch_no_ := '*';
   END IF;
   RETURN lot_batch_no_;
END Get_Lot_Batch_No;


@UncheckedAccess
FUNCTION Get_Eng_Chg_Level (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2 ) RETURN VARCHAR2 
IS
   eng_chg_level_ VARCHAR2(6);
BEGIN
   IF (Inventory_Part_Revision_API.Get_Latest_Eng_Chg_Level(contract_, part_no_) = 1) THEN
      eng_chg_level_ := '1';
   END IF;
   RETURN eng_chg_level_;
END Get_Eng_Chg_Level;


@UncheckedAccess
FUNCTION Get_Activity_Seq (
   contract_           IN VARCHAR2 ) RETURN VARCHAR2   
IS
   activity_seq_ NUMBER;
BEGIN
   IF (Order_Supply_Demand_API.Open_Projects_Exist(contract_) = Fnd_Boolean_API.DB_FALSE) THEN
      activity_seq_ := 0;
   END IF;
   RETURN activity_seq_;
END Get_Activity_Seq;


PROCEDURE Add_Unit_Meas (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   unit_meas_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      unit_meas_ := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'UNIT_MEAS',
                                        data_item_value_     => unit_meas_);
   $ELSE
      NULL;   
   $END
END Add_Unit_Meas;


PROCEDURE Add_Catch_Unit_Meas (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   catch_unit_meas_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      catch_unit_meas_ := Inventory_Part_API.Get_Catch_Unit_Meas(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'CATCH_UNIT_MEAS',
                                        data_item_value_     => catch_unit_meas_);
   $ELSE
      NULL;   
   $END
END Add_Catch_Unit_Meas;


PROCEDURE Add_Part_Description (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS
   part_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      part_desc_ := Inventory_Part_API.Get_Description(contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => part_desc_);
   $ELSE
      NULL;   
   $END
END Add_Part_Description;

   
PROCEDURE Add_Tot_Serial_Nos_In_Session (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2)
IS
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   CURSOR serial_numbers_entered IS
      SELECT count(*)
      FROM   data_capture_session_line_pub
      WHERE  capture_session_id = capture_session_id_
      AND    data_item_id       = owning_data_item_id_
      AND    data_item_detail_id IS NULL
      AND    data_item_value    != '*';
   $END
   
   serial_numbers_entered_       NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      OPEN serial_numbers_entered;
      FETCH serial_numbers_entered INTO serial_numbers_entered_;
      CLOSE serial_numbers_entered;
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => serial_numbers_entered_);
   $ELSE
      NULL;   
   $END
END Add_Tot_Serial_Nos_In_Session;


PROCEDURE Add_Details_For_Location_No (
   capture_session_id_   IN NUMBER,        
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   contract_             IN VARCHAR2,
   location_no_          IN VARCHAR2 )
IS
   location_rec_    Inventory_Location_API.Public_Rec;
   data_item_value_ VARCHAR2(200);
   -- Fetch warehouse details to an instance of Putaway_Bin_Rec  
   wherehouse_rec_  Warehouse_Bay_Bin_API.Putaway_Bin_Rec;
   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      location_rec_ := Inventory_Location_API.Get(contract_, location_no_);
      Warehouse_Bay_Bin_API.Get_Location_Strings(wherehouse_rec_.warehouse_id, wherehouse_rec_.bay_id, wherehouse_rec_.tier_id, wherehouse_rec_.row_id, wherehouse_rec_.bin_id, contract_, location_no_);
      
      IF (data_item_detail_id_ IN ('WAREHOUSE_ID','FROM_WAREHOUSE_ID','TO_WAREHOUSE_ID','WAREHOUSE','FROM_WAREHOUSE','TO_WAREHOUSE')) THEN
         data_item_value_ := location_rec_.warehouse;
      ELSIF (data_item_detail_id_ IN ('BAY_ID','FROM_BAY_ID','TO_BAY_ID')) THEN
         data_item_value_ := location_rec_.bay_no;
      ELSIF (data_item_detail_id_ IN ('TIER_ID','FROM_TIER_ID','TO_TIER_ID')) THEN
         data_item_value_ := location_rec_.tier_no;
      ELSIF (data_item_detail_id_ IN ('ROW_ID','FROM_ROW_ID','TO_ROW_ID')) THEN
         data_item_value_ := location_rec_.row_no;
      ELSIF (data_item_detail_id_ IN ('BIN_ID','FROM_BIN_ID','TO_BIN_ID')) THEN
         data_item_value_ := location_rec_.bin_no;
      ELSIF (data_item_detail_id_ IN ('LOCATION_NO_DESC','FROM_LOCATION_NO_DESC','TO_LOCATION_NO_DESC','SUPPLY_TO_LOCATION_DESC', 'SHIP_LOCATION_NO_DESC')) THEN
         data_item_value_ := location_rec_.location_name;      
      ELSIF (data_item_detail_id_ IN ('LOCATION_GROUP','FROM_LOCATION_GROUP','TO_LOCATION_GROUP')) THEN
         data_item_value_ := location_rec_.location_group;
      ELSIF (data_item_detail_id_ IN ('LOCATION_TYPE','FROM_LOCATION_TYPE','TO_LOCATION_TYPE')) THEN
         data_item_value_ := Warehouse_Bay_Bin_API.Get_Location_Type_Db(contract_, location_rec_.warehouse, location_rec_.bay_no, location_rec_.tier_no, location_rec_.row_no, location_rec_.bin_no);
      ELSIF (data_item_detail_id_ IN ('RECEIPTS_BLOCKED','TO_RECEIPTS_BLOCKED','FROM_RECEIPTS_BLOCKED')) THEN
         data_item_value_ := Warehouse_Bay_Bin_API.Get_Receipts_Blocked_Db(contract_, wherehouse_rec_.warehouse_id, wherehouse_rec_.bay_id, wherehouse_rec_.tier_id, wherehouse_rec_.row_id, wherehouse_rec_.bin_id);
      ELSIF (data_item_detail_id_ IN ('MIX_OF_PART_NUMBER_BLOCKED','TO_MIX_OF_PART_NUMBER_BLOCKED','FROM_MIX_OF_PART_NUMBER_BLOCKED')) THEN
         data_item_value_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Parts_Blocked_Db(contract_, wherehouse_rec_.warehouse_id, wherehouse_rec_.bay_id, wherehouse_rec_.tier_id, wherehouse_rec_.row_id, wherehouse_rec_.bin_id);         
      ELSIF (data_item_detail_id_ IN ('MIX_OF_CONDITION_CODES_BLOCKED','TO_MIX_OF_CONDITION_CODES_BLOCKED','FROM_MIX_OF_CONDITION_CODES_BLOCKED')) THEN
         data_item_value_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Cond_Blocked_Db(contract_, wherehouse_rec_.warehouse_id, wherehouse_rec_.bay_id, wherehouse_rec_.tier_id, wherehouse_rec_.row_id, wherehouse_rec_.bin_id);         
      ELSIF (data_item_detail_id_ IN ('MIX_OF_LOT_BATCH_NO_BLOCKED','TO_MIX_OF_LOT_BATCH_NO_BLOCKED','FROM_MIX_OF_LOT_BATCH_NO_BLOCKED')) THEN
         data_item_value_ := Warehouse_Bay_Bin_API.Get_Mix_Of_Lot_Blocked_Db(contract_, wherehouse_rec_.warehouse_id, wherehouse_rec_.bay_id, wherehouse_rec_.tier_id, wherehouse_rec_.row_id, wherehouse_rec_.bin_id);         
      ELSIF (data_item_detail_id_ IN ('WAREHOUSE_BAY_ROW_TIER_BIN')) THEN
         data_item_value_ := wherehouse_rec_.warehouse_id || ' | ' || wherehouse_rec_.bay_id || ' | ' || wherehouse_rec_.row_id || ' | ' || wherehouse_rec_.tier_id || ' | ' || wherehouse_rec_.bin_id; 
      END IF;
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => data_item_value_);
   $ELSE
      NULL;   
   $END
END Add_Details_For_Location_No;


PROCEDURE Add_Details_For_Inv_Stock_Rec (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   all_found_                BOOLEAN;
   local_location_no_        VARCHAR2(35);
   local_contract_           VARCHAR2(5);
   local_part_no_            VARCHAR2(25);
   local_serial_no_          VARCHAR2(50);
   local_configuration_id_   VARCHAR2(50);
   local_lot_batch_no_       VARCHAR2(20);
   local_eng_chg_level_      VARCHAR2(6);
   local_waiv_dev_rej_no_    VARCHAR2(15);
   local_activity_seq_       NUMBER;
   local_handling_unit_id_   NUMBER;
BEGIN

   local_contract_         := contract_;
   local_part_no_          := part_no_;
   local_location_no_      := location_no_;
   local_serial_no_        := serial_no_;
   local_configuration_id_ := configuration_id_;
   local_lot_batch_no_     := lot_batch_no_;
   local_eng_chg_level_    := eng_chg_level_;
   local_waiv_dev_rej_no_  := waiv_dev_rej_no_;
   local_activity_seq_     := activity_seq_;
   local_handling_unit_id_ := handling_unit_id_;

   -- Not a complete set of stock keys have been sent into method so we have to try and fetch them all from session line if they have been saved before 
   -- current data item or has fixed value or due to part_no/contract can have a automatic value due to other rules.
   -- A get unique handled process should send all inventory part in stock keys into this method since we are not using any unique handling to get the keys 
   -- (see above how they will be fetched) and only using standard get Get-methods to fetch the detail values.
   IF (local_contract_ IS NULL OR local_part_no_ IS NULL OR local_configuration_id_ IS NULL OR local_location_no_ IS NULL OR local_lot_batch_no_ IS NULL OR
       local_serial_no_ IS NULL OR local_eng_chg_level_ IS NULL OR local_waiv_dev_rej_no_ IS NULL OR local_activity_seq_ IS NULL OR local_handling_unit_id_ IS NULL) THEN
      Get_Stock_Record_Keys___(local_contract_, local_part_no_, local_configuration_id_, local_location_no_,
                               local_lot_batch_no_, local_serial_no_, local_eng_chg_level_, local_waiv_dev_rej_no_,
                               local_activity_seq_, local_handling_unit_id_, all_found_, capture_session_id_, owning_data_item_id_);
   END IF;
   
   CASE (data_item_detail_id_)
      WHEN ('QUANTITY_ONHAND') THEN
         Add_Quantity_Onhand___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('QTY_ONHAND') THEN
         Add_Quantity_Onhand___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('CATCH_QUANTITY_ONHAND') THEN
         Add_Catch_Quantity_Onhand___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                      local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                      local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('CATCH_QTY_ONHAND') THEN
         Add_Catch_Quantity_Onhand___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                      local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                      local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('EXPIRATION_DATE') THEN
         Add_Expiration_Date___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('AVAILABILTY_CONTROL_ID') THEN
         Add_Availability_Control_Id___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                        local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                        local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('OWNERSHIP') THEN
         Add_Ownership___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                          local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                          local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('OWNER') THEN
         Add_Owner___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                      local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                      local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('OWNER_NAME') THEN
         Add_Owner_Name___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                           local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                           local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);
      
      WHEN ('OWNING_CUSTOMER_NAME') THEN
         Add_Owning_Customer_Name___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                      local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                      local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('QUANTITY_AVAILABLE') THEN
         Add_Qty_Onhand_Not_Reserved___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                        local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                        local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('QTY_ONHAND_NOT_RESERVED') THEN
         Add_Qty_Onhand_Not_Reserved___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                        local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                        local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);
      
      WHEN ('CATCH_QTY_ONHAND_NOT_RESERVED') THEN
         Add_Catch_Quantity_Onhand___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                      local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                      local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);
      
      WHEN ('AVAILABILITY_CONTROL_DESCRIPTION') THEN
         Add_Availability_Ctrl_Desc___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                       local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                       local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);
         
      WHEN ('QUANTITY_IN_TRANSIT') THEN
         Add_Quantity_In_Transit___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                    local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                    local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);  
                                    
      WHEN ('CATCH_QUANTITY_IN_TRANSIT') THEN
         Add_Catch_Qty_In_Transit___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                     local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                     local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('QUANTITY_RESERVED') THEN
         Add_Quantity_Reserved___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                  local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                  local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);  

      WHEN ('FREEZE_FLAG') THEN
         Add_Freeze_Flag___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                            local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                            local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);  

      WHEN ('LAST_ACTIVITY_DATE') THEN
         Add_Last_Activity_Date___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                   local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                   local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('LAST_COUNT_DATE') THEN
         Add_Last_Count_Date___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('ROTABLE_PART_POOL_ID') THEN
         Add_Rotable_Part_Pool_Id___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                     local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                     local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('TOTAL_ACQUISITION_VALUE') THEN
         Add_Total_Acquisition_Value___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                        local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                        local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      WHEN ('TOTAL_INVENTORY_VALUE') THEN
         Add_Total_Inventory_Value___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, local_contract_,
                                      local_part_no_, local_configuration_id_, local_location_no_, local_lot_batch_no_, local_serial_no_,
                                      local_eng_chg_level_, local_waiv_dev_rej_no_, local_activity_seq_, local_handling_unit_id_);

      ELSE
         NULL;
   END CASE;
END Add_Details_For_Inv_Stock_Rec;


PROCEDURE Add_Detail_For_Hand_Unit_Stock (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   contract_             IN  VARCHAR2,
   location_no_          IN  VARCHAR2,
   handling_unit_id_     IN  NUMBER )
IS
   feedback_item_value_          VARCHAR2(200);
   owning_customer_no_           VARCHAR2(20);
   owning_vendor_no_             VARCHAR2(20);
   availability_control_id_      VARCHAR2(25);
   part_no_                      VARCHAR2(25);
   no_unique_value_found_        BOOLEAN; 
   cust_no_unique_value_found_   BOOLEAN;
   vendor_no_unique_value_found_ BOOLEAN;
   mixed_item_value_             VARCHAR2(25) := Language_SYS.Translate_Constant(lu_name_,'MIXEDITEM: Mixed');
   
BEGIN
   IF (data_item_detail_id_ IN ('PART_NO', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'ENG_CHG_LEVEL', 
                                'WAIV_DEV_REJ_NO', 'CONDITION_CODE', 'ACTIVITY_SEQ', 'AVAILABILITY_CONTROL_ID', 
                                'ROTABLE_PART_POOL_ID', 'EXPIRATION_DATE', 'LAST_ACTIVITY_DATE', 
                                'LAST_COUNT_DATE')) THEN
      feedback_item_value_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_, 
                                                                               handling_unit_id_,
                                                                               data_item_detail_id_);
   ELSIF (data_item_detail_id_ IN ('OWNERSHIP')) THEN
      feedback_item_value_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_, 
                                                                               handling_unit_id_,
                                                                               'PART_OWNERSHIP_DB');
   ELSIF (data_item_detail_id_ IN ('FREEZE_FLAG')) THEN
      IF Handling_Unit_API.Has_Stock_Frozen_For_Counting(handling_unit_id_) THEN 
         feedback_item_value_ := Inventory_Part_Freeze_Code_API.DB_FROZEN_FOR_COUNTING;
      ELSE 
         feedback_item_value_ := Inventory_Part_Freeze_Code_API.DB_NOT_FROZEN;
      END IF; 
   ELSIF (data_item_detail_id_ IN ('OWNER')) THEN
      owning_customer_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(cust_no_unique_value_found_, 
                                                                              handling_unit_id_,
                                                                              'OWNING_CUSTOMER_NO');
      owning_vendor_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(vendor_no_unique_value_found_, 
                                                                            handling_unit_id_,
                                                                            'OWNING_VENDOR_NO');

      IF ((owning_customer_no_ IS NULL AND cust_no_unique_value_found_ = FALSE) OR 
          (owning_vendor_no_ IS NULL AND vendor_no_unique_value_found_ = FALSE)) THEN
         -- too many records found in one or both of owning sources then this will be mixed
         feedback_item_value_ := NULL;
         no_unique_value_found_ := FALSE;
      ELSIF (owning_customer_no_ IS NOT NULL) THEN
         feedback_item_value_ := owning_customer_no_;
         no_unique_value_found_ := cust_no_unique_value_found_;
      ELSE
         feedback_item_value_ := owning_vendor_no_;
         no_unique_value_found_ := vendor_no_unique_value_found_;
      END IF;

   ELSIF (data_item_detail_id_ IN ('OWNER_NAME')) THEN
      owning_customer_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(cust_no_unique_value_found_, 
                                                                              handling_unit_id_,
                                                                              'OWNING_CUSTOMER_NO');
      owning_vendor_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(vendor_no_unique_value_found_, 
                                                                            handling_unit_id_,
                                                                            'OWNING_VENDOR_NO');

      IF ((owning_customer_no_ IS NULL AND cust_no_unique_value_found_ = FALSE) OR 
          (owning_vendor_no_ IS NULL AND vendor_no_unique_value_found_ = FALSE)) THEN
         -- too many records found in one or both of owning sources then this will be mixed
         feedback_item_value_ := NULL;
         no_unique_value_found_ := FALSE;
      ELSIF (owning_customer_no_ IS NOT NULL) THEN
         IF (owning_customer_no_ = 'NULL') THEN
            feedback_item_value_ := owning_customer_no_;
         ELSE
            $IF Component_Order_SYS.INSTALLED $THEN      
               feedback_item_value_ := Cust_Ord_Customer_API.Get_Name(owning_customer_no_);
            $ELSE
               NULL;
            $END
         END IF;
         no_unique_value_found_ := cust_no_unique_value_found_;
      ELSE
         IF (owning_vendor_no_ = 'NULL') THEN
            feedback_item_value_ := owning_vendor_no_;
         ELSE
            $IF Component_Purch_SYS.INSTALLED $THEN      
               feedback_item_value_ := Supplier_API.Get_Vendor_Name(owning_vendor_no_);
            $ELSE
               NULL;
            $END
         END IF;
         no_unique_value_found_ := vendor_no_unique_value_found_;
      END IF;

   ELSIF (data_item_detail_id_ IN ('AVAILABILITY_CONTROL_DESCRIPTION')) THEN
      availability_control_id_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_, 
                                                                                   handling_unit_id_,
                                                                                   'AVAILABILITY_CONTROL_ID');
      IF (availability_control_id_ IS NOT NULL AND availability_control_id_ != 'NULL') THEN
         feedback_item_value_ := SUBSTR(Part_Availability_Control_API.Get_Description(availability_control_id_), 1, 200);
      ELSIF (availability_control_id_ = 'NULL') THEN
         feedback_item_value_ := availability_control_id_;
      END IF; 
   ELSIF (data_item_detail_id_ IN ('QTY_ONHAND', 'CATCH_QTY_ONHAND', 'QTY_IN_TRANSIT', 
                                   'CATCH_QTY_IN_TRANSIT', 'QTY_RESERVED')) THEN
      part_no_ := Handling_Unit_API.Get_Stock_Attr_Value_If_Unique(no_unique_value_found_, 
                                                                   handling_unit_id_,
                                                                   'PART_NO');
      part_no_ := CASE part_no_ WHEN 'NULL' THEN NULL ELSE part_no_ END;   
      IF (part_no_ IS NOT NULL) THEN 
         feedback_item_value_ := Handling_Unit_API.Get_Sum_Stock_Column_Value(contract_,
                                                                              part_no_,
                                                                              handling_unit_id_,
                                                                              data_item_detail_id_);
      END IF;
   ELSIF (data_item_detail_id_ IN ('TOTAL_ACQUISITION_VALUE')) THEN
      feedback_item_value_ := Handling_Unit_API.Get_Cust_Own_Stock_Acqui_Value(handling_unit_id_);
   ELSIF (data_item_detail_id_ IN ('TOTAL_INVENTORY_VALUE')) THEN
      feedback_item_value_ := Handling_Unit_API.Get_Total_Part_In_stock_Value(handling_unit_id_);
   END IF ;
   
   -- Too many found      
   IF (no_unique_value_found_ = FALSE AND feedback_item_value_ IS NULL AND 
       data_item_detail_id_ IN ('PART_NO', 'SERIAL_NO', 'LOT_BATCH_NO', 'CONFIGURATION_ID', 'ENG_CHG_LEVEL', 
                                'WAIV_DEV_REJ_NO', 'CONDITION_CODE', 'AVAILABILITY_CONTROL_ID', 'AVAILABILITY_CONTROL_DESCRIPTION',
                                'OWNERSHIP', 'ROTABLE_PART_POOL_ID', 'OWNER_NAME', 'OWNER')) THEN
      feedback_item_value_ := mixed_item_value_;
   END IF ; 
                             
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      feedback_item_value_ := CASE feedback_item_value_ WHEN 'NULL' THEN NULL ELSE feedback_item_value_ END;   
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => feedback_item_value_);
   $ELSE
      NULL;                                     
   $END
END Add_Detail_For_Hand_Unit_Stock;


PROCEDURE Add_Detail_For_Hand_Unit_Trans (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   from_contract_        IN  VARCHAR2,
   handling_unit_id_     IN  NUMBER )
IS
   feedback_item_value_          VARCHAR2(200);
   part_no_                      VARCHAR2(25);
   no_unique_value_found_        BOOLEAN; 
   mixed_item_value_             VARCHAR2(25) := Language_SYS.Translate_Constant(lu_name_,'MIXEDITEM: Mixed');
   
BEGIN
   IF (data_item_detail_id_ IN ('ORDER_TYPE', 'ORDER_REF1', 'ORDER_REF2', 'ORDER_REF3', 'ORDER_REF4', 'CREATE_DATE')) THEN
      feedback_item_value_ := Handling_Unit_API.Get_Trans_Attr_Value_If_Unique(no_unique_value_found_, 
                                                                               handling_unit_id_,
                                                                               data_item_detail_id_);

   ELSIF (data_item_detail_id_ IN ('QUANTITY', 'CATCH_QUANTITY')) THEN
      part_no_ := Handling_Unit_API.Get_Trans_Attr_Value_If_Unique(no_unique_value_found_, 
                                                                   handling_unit_id_,
                                                                   'PART_NO');
      part_no_ := CASE part_no_ WHEN 'NULL' THEN NULL ELSE part_no_ END;   
      IF (part_no_ IS NOT NULL) THEN 
         feedback_item_value_ := Handling_Unit_API.Get_Sum_Trans_Column_Value(from_contract_,
                                                                              part_no_,
                                                                              handling_unit_id_,
                                                                              data_item_detail_id_);
      END IF;
   END IF ;
   
   -- Too many found      
   IF (no_unique_value_found_ = FALSE AND feedback_item_value_ IS NULL AND 
       data_item_detail_id_ IN ('ORDER_TYPE', 'ORDER_REF1', 'ORDER_REF2', 'ORDER_REF3', 'ORDER_REF4')) THEN
      feedback_item_value_ := mixed_item_value_;
   END IF ; 
                             
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      feedback_item_value_ := CASE feedback_item_value_ WHEN 'NULL' THEN NULL ELSE feedback_item_value_ END;   
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => feedback_item_value_);
   $ELSE
      NULL;                                     
   $END
END Add_Detail_For_Hand_Unit_Trans;

            
PROCEDURE Add_Details_For_Part_No (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2)
IS
BEGIN
   
   CASE (data_item_detail_id_)
      WHEN ('PART_DESCRIPTION') THEN
         Add_Part_Description(capture_session_id_  => capture_session_id_, 
                              owning_data_item_id_ => owning_data_item_id_,
                              data_item_detail_id_ => data_item_detail_id_,
                              contract_            => contract_,
                              part_no_             => part_no_);
      WHEN ('PART_NO_DESCRIPTION') THEN
         Add_Part_Description(capture_session_id_  => capture_session_id_, 
                              owning_data_item_id_ => owning_data_item_id_,
                              data_item_detail_id_ => data_item_detail_id_,
                              contract_            => contract_,
                              part_no_             => part_no_);
      WHEN ('COMPONENT_PART_DESCRIPTION') THEN
         Add_Part_Description(capture_session_id_  => capture_session_id_, 
                              owning_data_item_id_ => owning_data_item_id_,
                              data_item_detail_id_ => data_item_detail_id_,
                              contract_            => contract_,
                              part_no_             => part_no_);
      WHEN ('UNIT_MEAS') THEN
         Add_Unit_Meas(capture_session_id_  => capture_session_id_, 
                       owning_data_item_id_ => owning_data_item_id_,
                       contract_            => contract_,
                       part_no_             => part_no_);        
     WHEN ('UNIT_MEAS_DESCRIPTION') THEN
         Add_Unit_Meas_Desc___(capture_session_id_  => capture_session_id_, 
                       owning_data_item_id_ => owning_data_item_id_,
                       contract_            => contract_,
                       part_no_             => part_no_);    
      WHEN ('CATCH_UNIT_MEAS') THEN
         Add_Catch_Unit_Meas(capture_session_id_  => capture_session_id_, 
                             owning_data_item_id_ => owning_data_item_id_,
                             contract_            => contract_,
                             part_no_             => part_no_);
      WHEN ('CATCH_UNIT_MEAS_DESCRIPTION') THEN
         Add_Catch_Unit_Meas_Desc___(capture_session_id_  => capture_session_id_, 
                                     owning_data_item_id_ => owning_data_item_id_,
                                     contract_            => contract_,
                                     part_no_             => part_no_);   
      WHEN ('NET_WEIGHT') THEN
         Add_Net_Weight___(capture_session_id_  => capture_session_id_,
                           owning_data_item_id_ => owning_data_item_id_, 
                           contract_            => contract_, 
                           part_no_             => part_no_);
      WHEN ('NET_VOLUME') THEN
         Add_Net_Volume___(capture_session_id_  => capture_session_id_,
                           owning_data_item_id_ => owning_data_item_id_, 
                           contract_            => contract_, 
                           part_no_             => part_no_);
      WHEN ('PART_TYPE') THEN
         Add_Part_Type___(capture_session_id_  => capture_session_id_,
                          owning_data_item_id_ => owning_data_item_id_, 
                          contract_            => contract_, 
                          part_no_             => part_no_);
      WHEN ('PRIME_COMMODITY') THEN
         Add_Prime_Commodity___(capture_session_id_  => capture_session_id_,
                                owning_data_item_id_ => owning_data_item_id_, 
                                contract_            => contract_, 
                                part_no_             => part_no_);
      WHEN ('PRIME_COMMODITY_DESCRIPTION') THEN
         Add_Prime_Commodity_Desc___(capture_session_id_  => capture_session_id_,
                                     owning_data_item_id_ => owning_data_item_id_, 
                                     contract_            => contract_, 
                                     part_no_             => part_no_);
      WHEN ('SECOND_COMMODITY') THEN
         Add_Second_Commodity___(capture_session_id_  => capture_session_id_,
                                 owning_data_item_id_ => owning_data_item_id_, 
                                 contract_            => contract_, 
                                 part_no_             => part_no_);
      WHEN ('SECOND_COMMODITY_DESCRIPTION') THEN
         Add_Second_Commodity_Desc___(capture_session_id_  => capture_session_id_,
                                      owning_data_item_id_ => owning_data_item_id_, 
                                      contract_            => contract_, 
                                      part_no_             => part_no_);
      WHEN ('ASSET_CLASS') THEN
         Add_Asset_Class___(capture_session_id_  => capture_session_id_,
                            owning_data_item_id_ => owning_data_item_id_, 
                            contract_            => contract_, 
                            part_no_             => part_no_);
      WHEN ('ASSET_CLASS_DESCRIPTION') THEN
         Add_Asset_Class_Desc___(capture_session_id_  => capture_session_id_,
                                 owning_data_item_id_ => owning_data_item_id_, 
                                 contract_            => contract_, 
                                 part_no_             => part_no_);
      WHEN ('PART_STATUS') THEN
         Add_Part_Status___(capture_session_id_  => capture_session_id_,
                            owning_data_item_id_ => owning_data_item_id_, 
                            contract_            => contract_, 
                            part_no_             => part_no_);
      WHEN ('PART_STATUS_DESCRIPTION') THEN
         Add_Part_Status_Desc___(capture_session_id_  => capture_session_id_,
                                 owning_data_item_id_ => owning_data_item_id_, 
                                 contract_            => contract_, 
                                 part_no_             => part_no_);
      WHEN ('ABC_CLASS') THEN
         Add_ABC_Class___(capture_session_id_  => capture_session_id_,
                          owning_data_item_id_ => owning_data_item_id_, 
                          contract_            => contract_, 
                          part_no_             => part_no_);
      WHEN ('ABC_CLASS_PERCENT') THEN
         Add_ABC_Class_Percent___(capture_session_id_  => capture_session_id_,
                                  owning_data_item_id_ => owning_data_item_id_, 
                                  contract_            => contract_, 
                                  part_no_             => part_no_);
      WHEN ('SAFETY_CODE') THEN
         Add_Safety_Code___(capture_session_id_  => capture_session_id_,
                            owning_data_item_id_ => owning_data_item_id_, 
                            contract_            => contract_, 
                            part_no_             => part_no_);
      WHEN ('SAFETY_CODE_DESCRIPTION') THEN
         Add_Safety_Code_Desc___(capture_session_id_  => capture_session_id_,
                                 owning_data_item_id_ => owning_data_item_id_, 
                                 contract_            => contract_, 
                                 part_no_             => part_no_);  
      WHEN ('ACCOUNTING_GROUP') THEN
         Add_Accounting_Group___(capture_session_id_  => capture_session_id_,
                                 owning_data_item_id_ => owning_data_item_id_, 
                                 contract_            => contract_, 
                                 part_no_             => part_no_);
      WHEN ('ACCOUNTING_GROUP_DESCRIPTION') THEN
         Add_Accounting_Group_Desc___(capture_session_id_  => capture_session_id_,
                                      owning_data_item_id_ => owning_data_item_id_, 
                                      contract_            => contract_, 
                                      part_no_             => part_no_);
      WHEN ('PRODUCT_CODE') THEN
         Add_Product_Code___(capture_session_id_  => capture_session_id_,
                             owning_data_item_id_ => owning_data_item_id_, 
                             contract_            => contract_, 
                             part_no_             => part_no_);
      WHEN ('PRODUCT_CODE_DESCRIPTION') THEN
         Add_Product_Code_Desc___(capture_session_id_  => capture_session_id_,
                                  owning_data_item_id_ => owning_data_item_id_, 
                                  contract_            => contract_, 
                                  part_no_             => part_no_); 
      WHEN ('PRODUCT_FAMILY') THEN
         Add_Product_Family___(capture_session_id_  => capture_session_id_,
                               owning_data_item_id_ => owning_data_item_id_, 
                               contract_            => contract_, 
                               part_no_             => part_no_);
      WHEN ('PRODUCT_FAMILY_DESCRIPTION') THEN
         Add_Product_Family_Desc___(capture_session_id_  => capture_session_id_,
                                    owning_data_item_id_ => owning_data_item_id_, 
                                    contract_            => contract_, 
                                    part_no_             => part_no_);
      WHEN ('SERIAL_TRACKING_RECEIPT_ISSUE') THEN
         Add_Serial_Trk_Rcpt_Issue___(capture_session_id_  => capture_session_id_,
                                      owning_data_item_id_ => owning_data_item_id_, 
                                      part_no_             => part_no_);
      WHEN ('SERIAL_TRACKING_INVENTORY') THEN
         Add_Serial_Track_Inventory___(capture_session_id_  => capture_session_id_,
                                       owning_data_item_id_ => owning_data_item_id_, 
                                       part_no_             => part_no_);
      WHEN ('SERIAL_TRACKING_DELIVERY') THEN
         Add_Serial_Track_Delivery___(capture_session_id_  => capture_session_id_,
                                      owning_data_item_id_ => owning_data_item_id_, 
                                      part_no_             => part_no_);
      WHEN ('STOP_ARRIVAL_ISSUED_SERIAL') THEN
         Add_Stop_Arr_Issued_Serial___(capture_session_id_  => capture_session_id_,
                                       owning_data_item_id_ => owning_data_item_id_, 
                                       part_no_             => part_no_);
      WHEN ('STOP_NEW_SERIAL_IN_RMA') THEN
         Add_Stop_New_Serial_RMA___(capture_session_id_  => capture_session_id_,
                                    owning_data_item_id_ => owning_data_item_id_, 
                                    part_no_             => part_no_);
      WHEN ('SERIAL_RULE') THEN
         Add_Serial_Rule___(capture_session_id_  => capture_session_id_,
                            owning_data_item_id_ => owning_data_item_id_, 
                            part_no_             => part_no_); 
      WHEN ('LOT_BATCH_TRACKING') THEN
         Add_Lot_Batch_Tracking___(capture_session_id_  => capture_session_id_,
                                   owning_data_item_id_ => owning_data_item_id_, 
                                   part_no_             => part_no_); 
      WHEN ('LOT_QUANTITY_RULE') THEN
         Add_Lot_Quantity_Rule___(capture_session_id_  => capture_session_id_,
                                  owning_data_item_id_ => owning_data_item_id_, 
                                  part_no_             => part_no_); 
      WHEN ('SUB_LOT_RULE') THEN
         Add_Sub_Lot_Rule___(capture_session_id_  => capture_session_id_,
                             owning_data_item_id_ => owning_data_item_id_, 
                             part_no_             => part_no_); 
      WHEN ('COMPONENT_LOT_RULE') THEN
         Add_Component_lot_Rule___(capture_session_id_  => capture_session_id_,
                                   owning_data_item_id_ => owning_data_item_id_, 
                                   part_no_             => part_no_); 
      WHEN ('GTIN_IDENTIFICATION') THEN
         Add_GTIN_Identification___(capture_session_id_  => capture_session_id_,
                                    owning_data_item_id_ => owning_data_item_id_, 
                                    part_no_             => part_no_);             
      WHEN ('GTIN_DEFAULT') THEN
         Add_GTIN_Default___(capture_session_id_  => capture_session_id_,
                             owning_data_item_id_ => owning_data_item_id_, 
                             part_no_             => part_no_);  
      WHEN ('INPUT_CONV_FACTOR') THEN
         Add_Input_Conv_Factor___(capture_session_id_  => capture_session_id_,
                                  owning_data_item_id_ => owning_data_item_id_,
                                  contract_            => contract_,
                                  part_no_             => part_no_);                       
      WHEN ('PART_DEFAULT_LOCATIONS') THEN
         Add_Part_Default_Locations___(capture_session_id_  => capture_session_id_,
                                       owning_data_item_id_ => owning_data_item_id_,
                                       contract_            => contract_,
                                       part_no_             => part_no_); 
      WHEN ('PART_DEFAULT_LOCATIONS_DESC') THEN
         Add_Part_Def_Locations_Desc___(capture_session_id_  => capture_session_id_,
                                        owning_data_item_id_ => owning_data_item_id_,
                                        contract_            => contract_,
                                        part_no_             => part_no_);
      WHEN ('LOCATIONS_WITH_RESERVED_QTY') THEN
         Add_Loc_With_Reserved_Qty___(capture_session_id_  => capture_session_id_,
                                      owning_data_item_id_ => owning_data_item_id_,
                                      contract_            => contract_,
                                      part_no_             => part_no_); 
      WHEN ('LOCATIONS_WITH_AVAILABLE_QTY') THEN
         Add_Loc_With_Available_Qty___(capture_session_id_  => capture_session_id_,
                                       owning_data_item_id_ => owning_data_item_id_,
                                       contract_            => contract_,
                                       part_no_             => part_no_);
      WHEN ('DIMENSION_QUALITY') THEN
         Add_Dim_Quality___(capture_session_id_  => capture_session_id_,
                            owning_data_item_id_ => owning_data_item_id_,
                            data_item_detail_id_ => data_item_detail_id_,
                            contract_            => contract_,
                            part_no_             => part_no_);
      WHEN ('DIM_QUALITY') THEN
         Add_Dim_Quality___(capture_session_id_  => capture_session_id_,
                            owning_data_item_id_ => owning_data_item_id_,
                            data_item_detail_id_ => data_item_detail_id_,
                            contract_            => contract_,
                            part_no_             => part_no_);
      WHEN ('TYPE_DESIGNATION') THEN
         Add_Type_Designation___(capture_session_id_  => capture_session_id_,
                                 owning_data_item_id_ => owning_data_item_id_,
                                 contract_            => contract_,
                                 part_no_             => part_no_);

      ELSE
         NULL;
   END CASE;
END Add_Details_For_Part_No;


PROCEDURE Add_Details_For_Activity_Seq (
   capture_session_id_   IN NUMBER,
   owning_data_item_id_  IN VARCHAR2,
   data_item_detail_id_  IN VARCHAR2,
   activity_seq_         IN NUMBER )
IS
   project_id_ VARCHAR2(10);
BEGIN

   project_id_ := Get_Project_Id___(activity_seq_);
         
   CASE (data_item_detail_id_)
      WHEN ('PROGRAM_ID') THEN 
         Add_Program_Id___(capture_session_id_  => capture_session_id_,
                           owning_data_item_id_ => owning_data_item_id_,
                           project_id_          => project_id_);
      WHEN ('PROGRAM_DESCRIPTION') THEN 
         Add_Program_Desc___(capture_session_id_  => capture_session_id_,
                             owning_data_item_id_ => owning_data_item_id_,
                             project_id_          => project_id_);
      WHEN ('PROJECT_ID') THEN 
         Add_Project_Id___(capture_session_id_  => capture_session_id_,
                           owning_data_item_id_ => owning_data_item_id_,
                           project_id_          => project_id_);  
      WHEN ('PROJECT_NAME') THEN 
         Add_Project_Name___(capture_session_id_  => capture_session_id_,
                             owning_data_item_id_ => owning_data_item_id_,
                             project_id_          => project_id_);   
      WHEN ('SUB_PROJECT_ID') THEN 
         Add_Sub_Project_Id___(capture_session_id_  => capture_session_id_,
                               owning_data_item_id_ => owning_data_item_id_,
                               activity_seq_        => activity_seq_);
      WHEN ('SUB_PROJECT_DESCRIPTION') THEN 
         Add_Sub_Project_Desc___(capture_session_id_  => capture_session_id_,
                                 owning_data_item_id_ => owning_data_item_id_,
                                 activity_seq_        => activity_seq_);   
      WHEN ('ACTIVITY_ID') THEN
         Add_Activity_Id___(capture_session_id_  => capture_session_id_,
                            owning_data_item_id_ => owning_data_item_id_,
                            activity_seq_        => activity_seq_); 
      WHEN ('ACTIVITY_DESCRIPTION') THEN 
         Add_Activity_Desc___(capture_session_id_  => capture_session_id_,
                              owning_data_item_id_ => owning_data_item_id_,
                              activity_seq_        => activity_seq_);
      ELSE 
         NULL;
   END CASE;

END Add_Details_For_Activity_Seq;


PROCEDURE Add_Details_For_Hand_Unit_Type(
   capture_session_id_    IN     NUMBER,
   owning_data_item_id_   IN     VARCHAR2,
   data_item_detail_id_   IN     VARCHAR2,
   handling_unit_id_      IN     NUMBER    DEFAULT NULL,
   handling_unit_type_id_ IN     VARCHAR2  DEFAULT NULL)
IS
   feedback_item_value_   VARCHAR2(200);
   local_handling_unit_type_id_ VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (handling_unit_type_id_ IS NOT NULL) THEN
         local_handling_unit_type_id_ := handling_unit_type_id_;
      ELSE
         local_handling_unit_type_id_ := Handling_Unit_API.Get_Handling_Unit_Type_Id(handling_unit_id_);
      END IF;

      IF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_ID', 'SHP_HANDLING_UNIT_TYPE_ID', 'RES_HANDLING_UNIT_TYPE_ID')) THEN 
         feedback_item_value_ := local_handling_unit_type_id_;
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_DESC', 'SHP_HANDLING_UNIT_TYPE_DESC', 'RES_HANDLING_UNIT_TYPE_DESC')) THEN 
         feedback_item_value_ := Handling_Unit_Type_API.Get_Description(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_CATEG_ID', 'SHP_HANDLING_UNIT_TYPE_CATEG_ID', 'RES_HANDLING_UNIT_TYPE_CATEG_ID')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Handling_Unit_Category_Id(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_CATEG_DESC', 'SHP_HANDLING_UNIT_TYPE_CATEG_DESC', 'RES_HANDLING_UNIT_TYPE_CATEG_DESC')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Handl_Unit_Category_Desc(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_TYPE_WIDTH') THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Width(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_TYPE_HEIGHT') THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Height(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_TYPE_DEPTH') THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Depth(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_VOLUME', 'SHP_HANDLING_UNIT_TYPE_VOLUME')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Volume(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_UOM_VOLUME', 'SHP_HANDLING_UNIT_TYPE_UOM_VOLUME')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Uom_For_Volume(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_TARE_WEIGHT', 'SHP_HANDLING_UNIT_TYPE_TARE_WEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Tare_Weight(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_UOM_LENGTH', 'SHP_HANDLING_UNIT_TYPE_UOM_LENGTH')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Uom_For_Length(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_UOM_WEIGHT' ,'SHP_HANDLING_UNIT_TYPE_UOM_WEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Uom_For_Weight(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_ADD_VOLUME', 'SHP_HANDLING_UNIT_TYPE_ADD_VOLUME')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Additive_Volume_Db(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_MAX_VOL_CAP', 'SHP_HANDLING_UNIT_TYPE_MAX_VOL_CAP')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Max_Volume_Capacity(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_MAX_WGT_CAP', 'SHP_HANDLING_UNIT_TYPE_MAX_WGT_CAP')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Max_Weight_Capacity(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_STACKABLE', 'SHP_HANDLING_UNIT_TYPE_STACKABLE')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Stackable_Db(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_GEN_SSCC', 'SHP_HANDLING_UNIT_TYPE_GEN_SSCC')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Generate_Sscc_No_Db(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_PRINT_LBL', 'SHP_HANDLING_UNIT_TYPE_PRINT_LBL')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Print_Label_Db(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TYPE_NO_OF_LBLS', 'SHP_HANDLING_UNIT_TYPE_NO_OF_LBLS')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_No_Of_Handling_Unit_Labels(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ IN ('PARENT_HANDLING_UNIT_DESC', 'OLD_PARENT_HANDLING_UNIT_DESC', 'SHP_PARENT_HANDLING_UNIT_DESC')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_)));
      ELSIF (data_item_detail_id_ IN ('TOP_PARENT_HANDLING_UNIT_TYPE_ID', 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_ID')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Handling_Unit_Type_Id(Handling_Unit_API.Get_Top_Parent_Handl_Unit_Id(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('TOP_PARENT_HANDLING_UNIT_TYPE_DESC', 'RES_TOP_PARENT_HANDLING_UNIT_TYPE_DESC')) THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(Handling_Unit_API.Get_Top_Parent_Handl_Unit_Id(handling_unit_id_)));
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_TYPE_COST') THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Cost(local_handling_unit_type_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_TYPE_CURR_CODE') THEN
         feedback_item_value_ := Handling_Unit_Type_API.Get_Currency_Code(local_handling_unit_type_id_);
      END IF;
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => feedback_item_value_);
   $ELSE
      NULL;                                     
   $END
END Add_Details_For_Hand_Unit_Type;
   
   
PROCEDURE Add_Details_For_Handling_Unit(
   capture_session_id_   IN     NUMBER,
   owning_data_item_id_  IN     VARCHAR2,
   data_item_detail_id_  IN     VARCHAR2,
   handling_unit_id_     IN     NUMBER )
IS
   feedback_item_value_   VARCHAR2(200);
   handling_unit_type_id_ VARCHAR2(25);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      handling_unit_type_id_ := Handling_Unit_API.Get_Handling_Unit_Type_Id(handling_unit_id_);
      IF (data_item_detail_id_ IN ('HANDLING_UNIT_WIDTH', 'SHP_HANDLING_UNIT_WIDTH', 'RES_HANDLING_UNIT_WIDTH')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Width(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_HEIGHT', 'SHP_HANDLING_UNIT_HEIGHT', 'RES_HANDLING_UNIT_HEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Height(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_DEPTH', 'SHP_HANDLING_UNIT_DEPTH', 'RES_HANDLING_UNIT_DEPTH')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Depth(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_UOM_LENGTH', 'SHP_HANDLING_UNIT_UOM_LENGTH', 'RES_HANDLING_UNIT_UOM_LENGTH')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Uom_For_Length(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('PARENT_HANDLING_UNIT_ID', 'OLD_PARENT_HANDLING_UNIT_ID', 'SHP_PARENT_HANDLING_UNIT_ID', 'RES_PARENT_HANDLING_UNIT_ID')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('PARENT_SSCC', 'OLD_PARENT_SSCC')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Sscc(Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('PARENT_ALT_HANDLING_UNIT_LABEL_ID', 'OLD_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_));
      -- TODO: check usage of MANUAL_GROSS_WEIGHT and see if we can remove it now
      ELSIF (data_item_detail_id_ IN ('MANUAL_GROSS_WEIGHT', 'HANDLING_UNIT_MANUAL_GROSS_WEIGHT', 'SHP_HANDLING_UNIT_MANUAL_GROSS_WEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Manual_Gross_Weight(handling_unit_id_);
      -- TODO: check usage of MANUAL_VOLUME and see if we can remove it now
      ELSIF (data_item_detail_id_ IN ('MANUAL_VOLUME', 'HANDLING_UNIT_MANUAL_VOLUME', 'SHP_HANDLING_UNIT_MANUAL_VOLUME')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Manual_Volume(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('OPERATIVE_VOLUME', 'HANDLING_UNIT_OPERATIVE_VOLUME', 'RES_HANDLING_UNIT_OPERATIVE_VOLUME')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Operative_Volume(handling_unit_id_, Handling_Unit_Type_API.Get_Uom_For_Volume(handling_unit_type_id_));
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_GEN_SSCC') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Generate_Sscc_No_Db(handling_unit_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_ACCESSORY_EXIST') THEN
         feedback_item_value_ := Accessory_On_Handling_Unit_API.Handling_Unit_Connected_Exist(handling_unit_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_MIX_OF_PART_NO_BLOCKED') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Mix_Of_Part_No_Blocked_Db(handling_unit_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_MIX_OF_CONDITION_CODE_BLOCKED') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Mix_Of_Cond_Code_Blocke_Db(handling_unit_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_MIX_OF_LOT_BATCH_NUMBERS_BLOCKED') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Mix_Of_Lot_Batch_Blocke_Db(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_NET_WEIGHT', 'RES_HANDLING_UNIT_NET_WEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Net_Weight(handling_unit_id_, Handling_Unit_API.Get_Uom_For_Weight(handling_unit_id_), 'FALSE');
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT', 'RES_HANDLING_UNIT_OPERATIVE_GROSS_WEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Operative_Gross_Weight(handling_unit_id_, Handling_Unit_Type_API.Get_Uom_For_Weight(handling_unit_type_id_), 'FALSE');
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_COMPOSITION', 'RES_HANDLING_UNIT_COMPOSITION')) THEN
         -- Need to encode since this method return client value and we need to save db value on session line
         feedback_item_value_ := Handling_Unit_Composition_API.Encode(Handling_Unit_API.Get_Composition(handling_unit_id_));         
      ELSIF (data_item_detail_id_ IN ('TOP_PARENT_HANDLING_UNIT_ID', 'RES_TOP_PARENT_HANDLING_UNIT_ID')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Top_Parent_Handl_Unit_Id(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('TOP_PARENT_SSCC', 'RES_TOP_PARENT_SSCC')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Sscc(Handling_Unit_API.Get_Top_Parent_Handl_Unit_Id(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID', 'RES_TOP_PARENT_ALT_HANDLING_UNIT_LABEL_ID')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(Handling_Unit_API.Get_Top_Parent_Handl_Unit_Id(handling_unit_id_));
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_SHIPMENT_ID') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Shipment_Id(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TARE_WEIGHT', 'RES_HANDLING_UNIT_TARE_WEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Tare_Weight(handling_unit_id_, Handling_Unit_API.Get_Uom_For_Weight(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_UOM_WEIGHT', 'RES_HANDLING_UNIT_UOM_WEIGHT')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Uom_For_Weight(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_UOM_VOLUME', 'RES_HANDLING_UNIT_UOM_VOLUME')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Uom_For_Volume(handling_unit_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_PRINT_LBL') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Print_Label_Db(handling_unit_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_NO_OF_LBLS') THEN
         feedback_item_value_ := Handling_Unit_API.Get_No_Of_Handling_Unit_Labels(handling_unit_id_);
      ELSIF (data_item_detail_id_ = 'HANDLING_UNIT_LOCATION_NO') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Location_No(handling_unit_id_);         
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_LOCATION_NO_DESC', 'RES_HANDLING_UNIT_LOCATION_NO_DESC')) THEN
         feedback_item_value_ := Inventory_Location_API.Get_Location_Name(Handling_Unit_API.Get_Contract(handling_unit_id_), Handling_Unit_API.Get_Location_No(handling_unit_id_));         
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_LOCATION_TYPE', 'RES_HANDLING_UNIT_LOCATION_TYPE')) THEN
         feedback_item_value_ := Inventory_Location_API.Get_Location_Type_Db(Handling_Unit_API.Get_Contract(handling_unit_id_), Handling_Unit_API.Get_Location_No(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_WAREHOUSE_ID', 'RES_HANDLING_UNIT_WAREHOUSE_ID')) THEN
         feedback_item_value_ := Inventory_Location_API.Get_Warehouse(Handling_Unit_API.Get_Contract(handling_unit_id_), Handling_Unit_API.Get_Location_No(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_BAY_ID', 'RES_HANDLING_UNIT_BAY_ID')) THEN
         feedback_item_value_ := Inventory_Location_API.Get_Bay_no(Handling_Unit_API.Get_Contract(handling_unit_id_), Handling_Unit_API.Get_Location_No(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_TIER_ID', 'RES_HANDLING_UNIT_TIER_ID')) THEN
         feedback_item_value_ := Inventory_Location_API.Get_Tier_No(Handling_Unit_API.Get_Contract(handling_unit_id_), Handling_Unit_API.Get_Location_No(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_ROW_ID', 'RES_HANDLING_UNIT_ROW_ID')) THEN
         feedback_item_value_ := Inventory_Location_API.Get_Row_no(Handling_Unit_API.Get_Contract(handling_unit_id_), Handling_Unit_API.Get_Location_No(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_BIN_ID', 'RES_HANDLING_UNIT_BIN_ID')) THEN
         feedback_item_value_ := Inventory_Location_API.Get_Bin_No(Handling_Unit_API.Get_Contract(handling_unit_id_), Handling_Unit_API.Get_Location_No(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('HANDLING_UNIT_STRUCTURE_LEVEL', 'RES_HANDLING_UNIT_STRUCTURE_LEVEL')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Structure_Level(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('LEVEL_2_HANDLING_UNIT_ID', 'RES_LEVEL_2_HANDLING_UNIT_ID')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Second_Level_Parent_Hu_Id(handling_unit_id_);
      ELSIF (data_item_detail_id_ IN ('LEVEL_2_SSCC', 'RES_LEVEL_2_SSCC')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Sscc(Handling_Unit_API.Get_Second_Level_Parent_Hu_Id(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID', 'RES_LEVEL_2_ALT_HANDLING_UNIT_LABEL_ID')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(Handling_Unit_API.Get_Second_Level_Parent_Hu_Id(handling_unit_id_));
      ELSIF (data_item_detail_id_ IN ('LAST_COUNT_DATE')) THEN
         feedback_item_value_ := Handling_Unit_API.Get_Last_Count_Date(handling_unit_id_);
      ELSIF(data_item_detail_id_ = 'QTY_RECEIVED') THEN
         feedback_item_value_ := Handling_Unit_API.Get_Total_Source_Ref_Part_Qty(handling_unit_id_); 
      END IF;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => feedback_item_value_);
   $ELSE
      NULL;                                     
   $END
   
END Add_Details_For_Handling_Unit;


PROCEDURE Add_Contract_Description (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS
   contract_desc_ VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      contract_desc_ := Site_API.Get_Description(contract_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => contract_desc_);
   $ELSE
      NULL;   
   $END
END Add_Contract_Description;


PROCEDURE Add_Config_Id_From_Sess_Line (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   part_catalog_rec_    IN Part_Catalog_API.Public_Rec )
IS   
   configuration_id_  VARCHAR2(50);
   session_rec_       Data_Capture_Common_Util_API.Session_Rec;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      configuration_id_ := Get_Configuration_Id___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, part_catalog_rec_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'CONFIGURATION_ID',
                                        data_item_value_     => configuration_id_);
   $ELSE
      NULL;   
   $END
END Add_Config_Id_From_Sess_Line;


PROCEDURE Add_Serial_No_From_Sess_Line (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   part_catalog_rec_    IN Part_Catalog_API.Public_Rec )
IS   
   serial_no_    VARCHAR2(50);
   session_rec_  Data_Capture_Common_Util_API.Session_Rec;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      serial_no_ := Get_Serial_No___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, part_catalog_rec_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'SERIAL_NO',
                                        data_item_value_     => serial_no_);
   $ELSE
      NULL;   
   $END
END Add_Serial_No_From_Sess_Line;


PROCEDURE Add_Lot_No_From_Sess_Line (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   part_catalog_rec_    IN Part_Catalog_API.Public_Rec )
IS   
   lot_batch_no_ VARCHAR2(20);
   session_rec_  Data_Capture_Common_Util_API.Session_Rec;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      lot_batch_no_ := Get_Lot_Batch_No___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, part_catalog_rec_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'LOT_BATCH_NO',
                                        data_item_value_     => lot_batch_no_);
   $ELSE
      NULL;   
   $END
END Add_Lot_No_From_Sess_Line;


PROCEDURE Add_Eng_Chg_Lev_From_Sess_Line (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2 )
IS   
   eng_chg_level_ VARCHAR2(6);
   session_rec_   Data_Capture_Common_Util_API.Session_Rec;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      eng_chg_level_ := Get_Eng_Chg_Level___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, contract_, part_no_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ENG_CHG_LEVEL',
                                        data_item_value_     => eng_chg_level_);
   $ELSE
      NULL;   
   $END
END Add_Eng_Chg_Lev_From_Sess_Line;


PROCEDURE Add_Activ_Seq_From_Sess_Line (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   contract_            IN VARCHAR2 )
IS   
   activity_seq_  NUMBER := 0;
   session_rec_   Data_Capture_Common_Util_API.Session_Rec;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      activity_seq_ := Get_Activity_Seq___(capture_session_id_, session_rec_.capture_process_id, session_rec_.capture_config_id, owning_data_item_id_, contract_); 
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => 'ACTIVITY_SEQ',
                                        data_item_value_     => activity_seq_);
   $ELSE
      NULL;   
   $END
END Add_Activ_Seq_From_Sess_Line;


PROCEDURE Add_Data_Item_From_Sess_Line (
   capture_session_id_       IN NUMBER,
   owning_data_item_id_      IN VARCHAR2,
   wanted_data_item_id_      IN VARCHAR2 )
IS   
   data_item_value_ VARCHAR2(200);
   session_rec_   Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      data_item_value_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                            data_item_id_a_     => wanted_data_item_id_,
                                                                            data_item_id_b_     => owning_data_item_id_);
      IF (data_item_value_ IS NULL) THEN
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         data_item_value_ := Data_Capt_Conf_Data_Item_API.Get_Fixed_Value_Db_If_Used(capture_process_id_      => session_rec_.capture_process_id,
                                                                                     capture_config_id_       => session_rec_.capture_config_id,
                                                                                     data_item_id_            => wanted_data_item_id_);
      END IF;
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => wanted_data_item_id_,
                                        data_item_value_     => data_item_value_);
   $ELSE
      NULL;   
   $END

END Add_Data_Item_From_Sess_Line;


-- NOTE: This process should be called when then current data item is PART_NO and CATCH_QUANTITY, this method will
-- then use current_data_item_id_, part_no_data_item_id_ and catch_qty_data_item_id_ to decide when to do the catch checks
-- since its only necessary to do this when the last one this 2 data items have been scanned in the configuration. Since you can
-- send in the part_no_data_item_id_ and catch_qty_data_item_id_ your process is using this method is not hard-coded to use
-- PART_NO and CATCH_QUANTITY, so your process can have any name/id you want here.
PROCEDURE Check_Catch_Qty (
   capture_session_id_           IN NUMBER,        
   current_data_item_id_         IN VARCHAR2,
   part_no_data_item_id_         IN VARCHAR2,
   part_no_data_item_value_      IN VARCHAR2,
   catch_qty_data_item_id_       IN VARCHAR2,
   catch_qty_data_item_value_    IN VARCHAR2,
   catch_zero_qty_allowed_       IN BOOLEAN DEFAULT FALSE,              -- TRUE for processes like Counting/Picking where you can 0 count/pick
   positive_catch_qty_           IN BOOLEAN DEFAULT FALSE )             -- TRUE for processes that dont allow catch quantity to be 0 or negative value
IS
   -- NOTE: If a process want to allow NULL catch quantity for a catch enabled part then it shouldnt run this method. 
   --       If a process allow minus catch quantity then just call this method without changing the default parameters.
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
   part_catalog_rec_        Part_Catalog_API.Public_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (part_no_data_item_value_ IS NOT NULL) THEN
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         -- if current item is PART NO or CATCH QTY and the other one was before this item, we can do the catch qty check 
         -- Or if current data item is neither of PART NO or CATCH QTY but both PART NO and CATCH QTY are before current data item, we can do the catch qty check.
         IF ((current_data_item_id_ = part_no_data_item_id_ AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                                                                           data_item_id_a_     => catch_qty_data_item_id_,
                                                                                                           data_item_id_b_     => part_no_data_item_id_)) OR
             (current_data_item_id_ = catch_qty_data_item_id_ AND Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                                                             data_item_id_a_     => part_no_data_item_id_,
                                                                                                             data_item_id_b_     => catch_qty_data_item_id_)) OR
             (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                         capture_config_id_  => session_rec_.capture_config_id,
                                                         data_item_id_a_     => catch_qty_data_item_id_,
                                                         data_item_id_b_     => current_data_item_id_) AND 
              Data_Capt_Conf_Data_Item_API.Is_A_Before_B(capture_process_id_ => session_rec_.capture_process_id,
                                                         capture_config_id_  => session_rec_.capture_config_id,
                                                         data_item_id_a_     => part_no_data_item_id_,
                                                         data_item_id_b_     => current_data_item_id_)))  THEN
            part_catalog_rec_ := Part_Catalog_API.Get(part_no_data_item_value_);

            IF (part_catalog_rec_.catch_unit_enabled = Fnd_Boolean_API.DB_FALSE) THEN   -- not catch unit enabled part
               IF (catch_qty_data_item_value_ IS NOT NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'NOCATCHQTY: This Part is not Catch Unit Enabled so no :P1 should be entered.', 
                                           Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), catch_qty_data_item_id_));
               END IF;
            ELSE -- catch unit enabled part
               IF (catch_zero_qty_allowed_ AND (catch_qty_data_item_value_ IS NULL OR catch_qty_data_item_value_ < 0)) THEN
                  Error_SYS.Record_General(lu_name_, 'CATCHQTY1: This Part is Catch Unit Enabled so :P1 must be entered or be 0. ', 
                                           Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), catch_qty_data_item_id_));
               ELSIF (positive_catch_qty_ AND (catch_qty_data_item_value_ IS NULL OR catch_qty_data_item_value_ <= 0)) THEN
                  Error_SYS.Record_General(lu_name_, 'CATCHQTY2: This Part is Catch Unit Enabled so :P1 must be entered and be greater than 0.', 
                                           Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), catch_qty_data_item_id_));
               ELSIF (catch_qty_data_item_value_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'CATCHQTY3: This Part is Catch Unit Enabled so :P1 must be entered. ', 
                                           Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), catch_qty_data_item_id_));
               END IF;
      
            END IF;
         END IF;
      END IF;
   $ELSE
      NULL;   
   $END

END Check_Catch_Qty;


@UncheckedAccess
FUNCTION Get_Invent_Barcode_Collection (
   contract_data_item_id_         IN VARCHAR2,
   part_no_data_item_id_          IN VARCHAR2,  
   lot_batch_no_data_item_id_     IN VARCHAR2,
   serial_no_data_item_id_        IN VARCHAR2, 
   eng_chg_level_data_item_id_    IN VARCHAR2,
   waiv_dev_rej_no_data_item_id_  IN VARCHAR2,
   configuration_id_data_item_id_ IN VARCHAR2,
   activity_seq_data_item_id_     IN VARCHAR2,
   origin_pack_size_data_item_id_ IN VARCHAR2 ) RETURN Data_Capture_Common_Util_API.Data_Item_Tab
IS
   barcode_items_tab_    Data_Capture_Common_Util_API.Data_Item_Tab;
   counter_              PLS_INTEGER := 0;
BEGIN
   IF contract_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := contract_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF part_no_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := part_no_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF lot_batch_no_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := lot_batch_no_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF serial_no_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := serial_no_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF eng_chg_level_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := eng_chg_level_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF waiv_dev_rej_no_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := waiv_dev_rej_no_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF configuration_id_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := configuration_id_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF activity_seq_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := activity_seq_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   IF origin_pack_size_data_item_id_ IS NOT NULL  THEN
      barcode_items_tab_(counter_).data_item_id := origin_pack_size_data_item_id_;
      counter_ := counter_ + 1;
   END IF;
   RETURN  barcode_items_tab_;

END Get_Invent_Barcode_Collection;


@UncheckedAccess
FUNCTION Get_Value_From_Barcode_Id (
   contract_      IN VARCHAR2,
   barcode_id_    IN NUMBER, 
   data_item_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   barcode_rec_   Inventory_Part_Barcode_API.Public_Rec;
   return_value_  VARCHAR2(50);
BEGIN
   barcode_rec_ := Inventory_Part_Barcode_API.Get(contract_, barcode_id_);
   IF data_item_id_ = 'PART_NO' THEN
      return_value_ := barcode_rec_.part_no;
   ELSIF data_item_id_ = 'LOT_BATCH_NO' THEN
      return_value_ := barcode_rec_.lot_batch_no;
   ELSIF data_item_id_ = 'SERIAL_NO' THEN
      return_value_ := barcode_rec_.serial_no;
   ELSIF data_item_id_ = 'ENG_CHG_LEVEL' THEN               
      return_value_ := barcode_rec_.eng_chg_level;
   ELSIF data_item_id_ = 'WAIV_DEV_REJ_NO' THEN
      return_value_ := barcode_rec_.waiv_dev_rej_no;
   ELSIF data_item_id_ = 'CONFIGURATION_ID' THEN
      return_value_ := barcode_rec_.configuration_id;
   ELSIF data_item_id_ = 'ACTIVITY_SEQ' THEN
      return_value_ := barcode_rec_.activity_seq;
   ELSIF data_item_id_ = 'ORIGIN_PACK_SIZE' THEN
      return_value_ := barcode_rec_.origin_pack_size;
   END IF;

   RETURN return_value_;
END Get_Value_From_Barcode_Id;


PROCEDURE Add_Condition_Code (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,  
   condition_code_      IN VARCHAR2 )
IS

BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => condition_code_);
   $ELSE
      NULL;   
   $END
END Add_Condition_Code;


PROCEDURE Add_Condition_Code_Desc (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,  
   condition_code_      IN VARCHAR2 )
IS
   condition_code_desc_ VARCHAR2(35);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      condition_code_desc_ := Condition_Code_API.Get_Description(condition_code_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => condition_code_desc_);
   $ELSE
      NULL;   
   $END
END Add_Condition_Code_Desc;


PROCEDURE Add_Condition_Code_Info (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   part_no_             IN VARCHAR2, 
   serial_no_           IN VARCHAR2, 
   lot_batch_no_        IN VARCHAR2 )
IS
   condition_code_ VARCHAR2(35);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(part_no_, serial_no_, lot_batch_no_);
      
      CASE (data_item_detail_id_)
         WHEN ('CONDITION_CODE') THEN 
            Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                              data_item_id_        => owning_data_item_id_,
                                              data_item_detail_id_ => data_item_detail_id_,
                                              data_item_value_     => condition_code_);
         WHEN ('CONDITION_CODE_DESC') THEN 
            Add_Condition_Code_Desc(capture_session_id_  => capture_session_id_,
                                    owning_data_item_id_ => owning_data_item_id_,
                                    data_item_detail_id_ => data_item_detail_id_,
                                    condition_code_      => condition_code_);
      END CASE;
   $ELSE
      NULL;   
   $END
END Add_Condition_Code_Info;


FUNCTION Fixed_Value_Is_Applicable (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2,
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN
IS
   fixed_value_is_applicable_ BOOLEAN := FALSE;
   part_rec_                  Part_Catalog_API.Public_Rec;   
   session_rec_               Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (part_no_ IS NOT NULL) THEN
         part_rec_ := Part_Catalog_API.Get(part_no_);
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);                   
         
         fixed_value_is_applicable_ := 
            CASE data_item_id_ 
               WHEN 'SERIAL_NO'        THEN part_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_FALSE
               WHEN 'QUANTITY'         THEN (part_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_TRUE AND 
                                            (part_rec_.serial_tracking_code = Part_Serial_Tracking_API.DB_SERIAL_TRACKING OR NVL(serial_no_,'*') != '*'))
               WHEN 'LOT_BATCH_NO'     THEN part_rec_.lot_tracking_code          = Part_Lot_Tracking_API.DB_NOT_LOT_TRACKING
               WHEN 'CONFIGURATION_ID' THEN part_rec_.configurable               = Part_Configuration_API.DB_NOT_CONFIGURED
               WHEN 'CONDITION_CODE'   THEN part_rec_.condition_code_usage       = Condition_Code_Usage_API.DB_NOT_ALLOW_CONDITION_CODE
               WHEN 'INPUT_UOM'        THEN (Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(session_rec_.session_contract, part_no_) IS NULL)
               WHEN 'INPUT_QUANTITY'   THEN (Data_Capt_Conf_Data_Item_API.Is_A_Before_B(session_rec_.capture_process_id, session_rec_.capture_config_id, 'INPUT_UOM', 'INPUT_QUANTITY')                                            
                                            AND (Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                                                          data_item_id_a_     => 'INPUT_UOM',
                                                                                                                          data_item_id_b_     => data_item_id_) IS NULL))
                                            OR (Inventory_Part_API.Get_Input_Unit_Meas_Group_Id(session_rec_.session_contract, part_no_) IS NULL) 
               ELSE
                  FALSE
               END;
         END IF;
   $END

   RETURN fixed_value_is_applicable_;
END Fixed_Value_Is_Applicable;


PROCEDURE Add_Details_For_Barcode_Id(
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   barcode_id_          IN NUMBER)
IS

BEGIN
   IF (data_item_detail_id_ = 'ORIGIN_PACK_SIZE') THEN
      Add_Origin_Pack_Size___(capture_session_id_,
                              owning_data_item_id_,
                              data_item_detail_id_,
                              barcode_id_);
   END IF;
END Add_Details_For_Barcode_Id;



PROCEDURE Add_Transaction_Qty (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   transaction_id_      IN NUMBER )
IS
   transaction_qty_     NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      transaction_qty_ := Inventory_Transaction_Hist_API.Get_Quantity(transaction_id_) - Inventory_Transaction_Hist_API.Get_Qty_Reversed(transaction_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => transaction_qty_);
   $ELSE
      NULL;   
   $END
END Add_Transaction_Qty;


FUNCTION Inventory_Barcode_Enabled (
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER ) RETURN BOOLEAN
IS
   barcode_enabled_  BOOLEAN := TRUE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- The Inventory Barcode functionality is turned off by having its data item set to Use Fixed Value 'ALWAYS' and the fixed value set to NULL
      IF (Data_Capt_Conf_Data_Item_API.Get_Use_Fixed_Value_Db(capture_process_id_, capture_config_id_, 'BARCODE_ID') = Data_Capt_Use_Fixed_Value_API.DB_ALWAYS) THEN
         IF (Data_Capt_Conf_Data_Item_API.Get_Fixed_Value(capture_process_id_, capture_config_id_, 'BARCODE_ID') IS NULL) THEN
            barcode_enabled_ := FALSE;
         END IF;
      END IF;
   $END
   RETURN barcode_enabled_;
END Inventory_Barcode_Enabled;


FUNCTION Gtin_Enabled (
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER ) RETURN BOOLEAN
IS
   gtin_enabled_  BOOLEAN := TRUE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- The gtin functionality is turned off by having its data item set to Use Fixed Value 'ALWAYS' and the fixed value set to NULL
      IF (Data_Capt_Conf_Data_Item_API.Get_Use_Fixed_Value_Db(capture_process_id_, capture_config_id_, 'GTIN') = Data_Capt_Use_Fixed_Value_API.DB_ALWAYS) THEN
         IF (Data_Capt_Conf_Data_Item_API.Get_Fixed_Value(capture_process_id_, capture_config_id_, 'GTIN') IS NULL) THEN
            gtin_enabled_ := FALSE;
         END IF;
      END IF;
   $END
   RETURN gtin_enabled_;
END Gtin_Enabled;


PROCEDURE Add_Due_For_Transport(
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   receipt_no_          IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
   due_for_transport_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      due_for_transport_ := Transport_Task_API.Get_Qty_Outbound(from_contract_         => contract_, 
                                                                part_no_               => part_no_, 
                                                                configuration_id_      => configuration_id_, 
                                                                from_location_no_      => location_no_, 
                                                                lot_batch_no_          => lot_batch_no_, 
                                                                serial_no_             => serial_no_, 
                                                                eng_chg_level_         => eng_chg_level_, 
                                                                waiv_dev_rej_no_       => waiv_dev_rej_no_, 
                                                                activity_seq_          => activity_seq_, 
                                                                handling_unit_id_      => handling_unit_id_, 
                                                                order_ref1_            => source_ref1_, 
                                                                order_ref2_            => source_ref2_, 
                                                                order_ref3_            => source_ref3_, 
                                                                order_ref4_            => receipt_no_, 
                                                                pick_list_no_          => NULL, 
                                                                shipment_id_           => NULL, 
                                                                order_type_db_         => source_ref_type_db_, 
                                                                reserved_by_source_db_ => NULL);

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => due_for_transport_);
   $ELSE
      NULL;   
   $END
END Add_Due_For_Transport;


PROCEDURE Add_Details_For_Pack_Into_Hu(
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   data_item_value_     IN VARCHAR2 )
IS
BEGIN
   CASE (data_item_detail_id_)
      WHEN ('PACKING_INSTRUCTION_DESC') THEN
         Add_Packing_Instr_Desc___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, data_item_value_);
      WHEN ('HANDLING_UNIT_TYPE_DESC') THEN
         Add_Handling_Unit_Type_Desc___(capture_session_id_, owning_data_item_id_, data_item_detail_id_, data_item_value_);
      ELSE
         NULL;
   END CASE;
END Add_Details_For_Pack_Into_Hu;

PROCEDURE Validate_GS1_Data_Item(
   capture_session_id_  IN NUMBER,
   data_item_id_        IN VARCHAR2,
   data_item_value_     IN VARCHAR2)
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   IF (data_item_value_ IS NULL) THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF(Data_Capt_Proc_Data_Item_API.Get_Data_Type_Db(session_rec_.capture_process_id, data_item_id_) = Data_Capture_Data_Type_API.DB_GS1) THEN
         IF (Data_Capt_Conf_Data_Item_API.Get_Use_Fixed_Value_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_) = Data_Capt_Use_Fixed_Value_API.DB_ALWAYS) THEN
            IF (Data_Capt_Conf_Data_Item_API.Get_Fixed_Value(session_rec_.capture_process_id, session_rec_.capture_config_id, data_item_id_) IS NULL) THEN
               -- When a GS1 barcode data item is set as use fixed value always and value is null, the process is not using the data item.
               -- No futher validations are needed.
               RETURN;
            END IF;
         END IF;
         IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_ => session_rec_.capture_process_id,
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           process_detail_id_  => 'GS1_BARCODE_IS_MANDATORY' ) = Fnd_Boolean_API.DB_TRUE) THEN
            Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, 
                                                                   data_item_id_, 
                                                                   data_item_value_, 
                                                                   mandatory_non_process_key_ => TRUE);
         END IF;
      END IF;
   END IF;
   $ELSE
      NULL;
   $END
END Validate_GS1_Data_Item;

PROCEDURE Add_Default_Move_Location (
   capture_session_id_     IN NUMBER,
   owning_data_item_id_    IN VARCHAR2,
   data_item_detail_id_    IN VARCHAR2,  
   default_move_location_  IN VARCHAR2 )
IS

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => default_move_location_);
   $ELSE
      NULL;   
   $END
END Add_Default_Move_Location;
