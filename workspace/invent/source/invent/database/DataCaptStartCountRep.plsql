-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptStartCountRep
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: START_COUNT_REPORT
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200917  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available/Is_Proj_Entity_Cud_Available/Is_Proj_Entity_Act_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171102  DaZase  STRSC-13073, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171102          of anything found later in that method. Changed size to 4000 on detail_value_ in Add_Unique_Data_Item_Detail___.
--  161128  DaZase  Created for LIM-9572.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   location_no_                IN VARCHAR2,
   count_report_level_db_      IN VARCHAR2,
   wanted_data_item_id_        IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   sql_where_expression_  VARCHAR2(2000) DEFAULT NULL;
   column_name_           VARCHAR2(30);
BEGIN

   IF (wanted_data_item_id_ = 'COUNT_REPORT_LEVEL')  THEN
      column_name_ := 'PART_OR_HANDLING_UNIT';
   ELSE
      column_name_ := wanted_data_item_id_;
   END IF;
   unique_value_ := Counting_Report_Handl_Unit_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                              inv_list_no_                => inv_list_no_, 
                                                                              location_no_                => location_no_,
                                                                              count_report_level_db_      => count_report_level_db_,
                                                                              column_name_                => column_name_,
                                                                              sql_where_expression_       => sql_where_expression_);
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;



PROCEDURE Get_Filter_Keys___ (
   contract_                      OUT VARCHAR2,
   inv_list_no_                   OUT VARCHAR2,
   location_no_                   OUT VARCHAR2,
   count_report_level_db_         OUT VARCHAR2,
   capture_session_id_            IN  NUMBER,
   data_item_id_                  IN  VARCHAR2,
   data_item_value_               IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_             IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_                IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   process_package_     VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      inv_list_no_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'INV_LIST_NO', session_rec_ , process_package_, use_applicable_);
      location_no_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      count_report_level_db_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'COUNT_REPORT_LEVEL', session_rec_ , process_package_, use_applicable_);

      IF (use_unique_values_) THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (inv_list_no_ IS NULL) THEN
            inv_list_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, location_no_, count_report_level_db_, 'INV_LIST_NO');
         END IF;
         IF (location_no_ IS NULL) THEN
            location_no_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, location_no_, count_report_level_db_, 'LOCATION_NO');
         END IF;
         IF (count_report_level_db_ IS NULL) THEN
            count_report_level_db_ := Get_Unique_Data_Item_Value___(contract_, inv_list_no_, location_no_, count_report_level_db_, 'COUNT_REPORT_LEVEL');
         END IF;
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
   location_no_                IN VARCHAR2,
   count_report_level_db_      IN VARCHAR2 )  
IS
   detail_value_             VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      CASE (data_item_detail_id_)
         WHEN ('INV_LIST_NO') THEN
            detail_value_ := inv_list_no_;
         WHEN ('LOCATION_NO') THEN
            detail_value_ := location_no_;
         WHEN ('COUNT_REPORT_LEVEL') THEN
            detail_value_ := count_report_level_db_;
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
         detail_value_ := Get_Unique_Data_Item_Value___();
      END IF;*/

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_List_Of_Values (
   capture_session_id_ IN NUMBER,
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER,
   data_item_id_       IN VARCHAR2,
   contract_           IN VARCHAR2 )
IS
   dummy_                       VARCHAR2(5);
   inv_list_no_                 VARCHAR2(15);
   location_no_                 VARCHAR2(35);
   count_report_level_db_       VARCHAR2(20);
   sql_where_expression_        VARCHAR2(2000) DEFAULT NULL;
   column_name_                 VARCHAR2(30);
   lov_type_db_                 VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(dummy_, inv_list_no_, location_no_, count_report_level_db_, capture_session_id_, data_item_id_);
      IF (data_item_id_ IN ('LOCATION_NO', 'COUNT_REPORT_LEVEL')) THEN
         IF (data_item_id_ = 'COUNT_REPORT_LEVEL' AND inv_list_no_ IS NULL AND location_no_ IS NULL) THEN
            -- Count Report Level is for some strange reason first in configuration then use the faster enumeration LOV.
            Part_Or_Handl_Unit_Level_API.Create_Data_Capture_Lov(capture_session_id_);
         ELSE
            IF (data_item_id_ = 'COUNT_REPORT_LEVEL')  THEN
               column_name_ := 'PART_OR_HANDLING_UNIT';
            ELSE
               column_name_ := data_item_id_;
            END IF;

            lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
            Counting_Report_Handl_Unit_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                                   inv_list_no_                => inv_list_no_, 
                                                                   location_no_                => location_no_,
                                                                   count_report_level_db_      => count_report_level_db_,
                                                                   capture_session_id_         => capture_session_id_, 
                                                                   column_name_                => column_name_,
                                                                   lov_type_db_                => lov_type_db_,
                                                                   sql_where_expression_       => sql_where_expression_);
         END IF;
      ELSIF (data_item_id_ = 'INV_LIST_NO') THEN
         -- If INV_LIST_NO is first data item in the configuration use faster INV_LIST_NO-LOV method on Counting Report head (not compairing against the enumeration items)
         IF (location_no_ IS NULL AND count_report_level_db_ IS NULL) THEN
            Counting_Report_API.Create_Data_Capture_Lov(contract_           => contract_,
                                                        capture_session_id_ => capture_session_id_);
         ELSE
            lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
            Counting_Report_Handl_Unit_API.Create_Data_Capture_Lov(contract_                   => contract_, 
                                                                   inv_list_no_                => inv_list_no_, 
                                                                   location_no_                => location_no_,
                                                                   count_report_level_db_      => count_report_level_db_,
                                                                   capture_session_id_         => capture_session_id_, 
                                                                   column_name_                => data_item_id_,
                                                                   lov_type_db_                => lov_type_db_,
                                                                   sql_where_expression_       => sql_where_expression_);
         END IF;
      END IF;
   $ELSE
      NULL;
   $END 
END Create_List_Of_Values;


FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   contract_                VARCHAR2(5);
   inv_list_no_             VARCHAR2(15);
   location_no_             VARCHAR2(35);
   count_report_level_db_   VARCHAR2(20);
   automatic_value_         VARCHAR2(200);
   sql_where_expression_    VARCHAR2(2000) DEFAULT NULL;
   column_name_             VARCHAR2(30);
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
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

         IF (data_item_id_ IN ('INV_LIST_NO','LOCATION_NO', 'COUNT_REPORT_LEVEL')) THEN      
            
            Get_Filter_Keys___(contract_, inv_list_no_, location_no_, count_report_level_db_, capture_session_id_, data_item_id_);
   
            IF (data_item_id_ = 'COUNT_REPORT_LEVEL')  THEN
               column_name_ := 'PART_OR_HANDLING_UNIT';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            automatic_value_ := Counting_Report_Handl_Unit_API.Get_Column_Value_If_Unique(contract_                   => contract_, 
                                                                                          inv_list_no_                => inv_list_no_, 
                                                                                          location_no_                => location_no_,
                                                                                          count_report_level_db_      => count_report_level_db_,
                                                                                          column_name_                => column_name_,
                                                                                          sql_where_expression_       => sql_where_expression_);
   
         END IF;
      END IF;
      RETURN automatic_value_;
   $ELSE
      RETURN NULL;
   $END
END Get_Automatic_Data_Item_Value;


PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   contract_               VARCHAR2(5);
   inv_list_no_            VARCHAR2(15);
   location_no_            VARCHAR2(35);
   count_report_level_db_  VARCHAR2(20);
   sql_where_expression_   VARCHAR2(2000) DEFAULT NULL;
   column_name_            VARCHAR2(30);
   column_description_     VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      Get_Filter_Keys___(contract_, inv_list_no_, location_no_, count_report_level_db_, capture_session_id_, data_item_id_, data_item_value_);

      column_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);

      IF (data_item_id_ IN ('LOCATION_NO', 'COUNT_REPORT_LEVEL')) THEN      
         IF (data_item_id_ = 'COUNT_REPORT_LEVEL')  THEN
            IF NOT Part_Or_Handl_Unit_Level_API.Exists_Db(data_item_value_) THEN
               Error_SYS.Record_General(lu_name_, 'LEVELVALUENOTEXIST: Only :P1 and :P2 values are allowed for :P3.', 
                                        Part_Or_Handl_Unit_Level_API.Get_Client_Value(0),
                                        Part_Or_Handl_Unit_Level_API.Get_Client_Value(1),
                                        column_description_);
            END IF;
            column_name_ := 'PART_OR_HANDLING_UNIT';
         ELSE
            column_name_ := data_item_id_;
         END IF;

         Counting_Report_Handl_Unit_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                       inv_list_no_                => inv_list_no_, 
                                                                       location_no_                => location_no_,
                                                                       count_report_level_db_      => count_report_level_db_,
                                                                       column_name_                => column_name_,
                                                                       column_value_               => data_item_value_,
                                                                       column_description_         => column_description_,
                                                                       sql_where_expression_       => sql_where_expression_);

      ELSIF (data_item_id_  = 'INV_LIST_NO') THEN
         -- If INV_LIST_NO is first data item in the configuration use faster Exist method on Counting Report head 
         IF (location_no_ IS NULL AND count_report_level_db_ IS NULL) THEN
            Counting_Report_API.Exist_And_Is_Not_Counted(contract_, data_item_value_);
         ELSE
            Counting_Report_Handl_Unit_API.Record_With_Column_Value_Exist(contract_                   => contract_, 
                                                                          inv_list_no_                => inv_list_no_, 
                                                                          location_no_                => location_no_,
                                                                          count_report_level_db_      => count_report_level_db_,
                                                                          column_name_                => data_item_id_,
                                                                          column_value_               => data_item_value_,
                                                                          column_description_         => column_description_,
                                                                          sql_where_expression_       => sql_where_expression_);
         END IF;
      ELSIF(data_item_id_ LIKE 'GS1%') THEN
            Data_Capture_Invent_Util_API.Validate_Gs1_Data_Item(capture_session_id_, data_item_id_, data_item_value_);
      END IF;

   $ELSE
      NULL;
   $END 
  
END Validate_Data_Item;


PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_  Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   contract_              VARCHAR2(5);
   inv_list_no_           VARCHAR2(15);
   location_no_           VARCHAR2(35);
   count_report_level_db_ VARCHAR2(20);

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, inv_list_no_, location_no_, count_report_level_db_, capture_session_id_, 
                         latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('INV_LIST_NO','LOCATION_NO', 'COUNT_REPORT_LEVEL')) THEN

                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           inv_list_no_                => inv_list_no_,
                                           location_no_                => location_no_,
                                           count_report_level_db_      => count_report_level_db_);
               ELSE
                  -- Data Items that are not part of the filter keys
                  Add_Unique_Data_Item_Detail___(capture_session_id_         => capture_session_id_,
                                                 session_rec_                => session_rec_,
                                                 owning_data_item_id_        => latest_data_item_id_,
                                                 owning_data_item_value_     => latest_data_item_value_,
                                                 data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id);
               END IF;

            ELSE  -- FEEDBACK ITEMS AS DETAILS

               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('WAREHOUSE_ID', 'BAY_ID', 'TIER_ID', 'ROW_ID','BIN_ID', 
                                                                    'LOCATION_TYPE', 'LOCATION_NO_DESC')) THEN
                  
                  Data_Capture_Invent_Util_API.Add_Details_For_Location_No(capture_session_id_  => capture_session_id_, 
                                                                           owning_data_item_id_ => latest_data_item_id_, 
                                                                           data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,
                                                                           contract_            => contract_, 
                                                                           location_no_         => location_no_);
               
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
BEGIN
   NULL;   -- Doing nothing in execution phase for this process. It will just start another sub processs using framework subsequent handling.
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
    -- Check to see that API method Counting_Report_Line_API.Count_And_Confirm_Line is granted thru following projection/entity action and entity CRUD
    IF (Security_SYS.Is_Proj_Entity_Cud_Available('CountPerCountReport', 'CountingReportLine') AND 
        Security_SYS.Is_Proj_Entity_Act_Available('CountPerCountReport', 'CountingReportLine', 'ConfirmLine') AND
       -- Check to see that API method Counting_Report_Handl_Unit_API.Count_Hu_Without_Diff is granted thru following projection/action
       -- Check to see that API method Counting_Report_Handl_Unit_API.Count_Hu_As_Non_Existing is granted thru following projection/action
       -- Check to see that API method Counting_Report_Handl_Unit_API.Confirm_Handling_Unit is granted thru following projection/action
       Security_SYS.Is_Proj_Action_Available('CountPerCountReport', 'CountWithoutDiff') AND
       Security_SYS.Is_Proj_Action_Available('CountPerCountReport', 'CountAsZero') AND
       Security_SYS.Is_Proj_Action_Available('CountPerCountReport', 'ConfirmAggregated')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;

