-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptStartTransTask
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: START_TRANSPORT_TASK
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200824  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  180222  RuLiLk  STRSC-16860, Modified method Validate_Data_Item to validate if GS1 barcodes are mandatory. 
--  171102  DaZase  STRSC-13077, Added fetching of current data item from any previously scanned GS1 barcode in Get_Automatic_Data_Item_Value and made sure that value is used instead 
--  171102          of anything found later in that method. Changed size to 4000 on detail_value_ in Add_Unique_Data_Item_Detail___.
--  170323  DaZase  Created for LIM-2928.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   transport_task_id_          IN NUMBER,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   transport_task_level_db_    IN VARCHAR2,
   wanted_data_item_id_        IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_          VARCHAR2(200);
   column_name_           VARCHAR2(30);
BEGIN

   IF (wanted_data_item_id_ = 'TRANSPORT_TASK_LEVEL')  THEN
      column_name_ := 'PART_OR_HANDLING_UNIT';
   ELSE
      column_name_ := wanted_data_item_id_;
   END IF;
   unique_value_ := Transport_Task_Handl_Unit_API.Get_Column_Value_If_Unique(transport_task_id_       => transport_task_id_,
                                                                             from_contract_           => from_contract_,  
                                                                             from_location_no_        => from_location_no_,
                                                                             transport_task_level_db_ => transport_task_level_db_,
                                                                             column_name_             => column_name_);
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___;


PROCEDURE Get_Filter_Keys___ (
   transport_task_id_       OUT NUMBER,
   from_contract_           OUT VARCHAR2,
   from_location_no_        OUT VARCHAR2,
   transport_task_level_db_ OUT VARCHAR2,
   capture_session_id_      IN  NUMBER,
   data_item_id_            IN  VARCHAR2,
   data_item_value_         IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_       IN  BOOLEAN  DEFAULT FALSE,
   use_applicable_          IN  BOOLEAN  DEFAULT TRUE )
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   process_package_     VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      transport_task_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TRANSPORT_TASK_ID', session_rec_ , process_package_, use_applicable_);
      from_contract_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_CONTRACT', session_rec_ , process_package_, use_applicable_);
      from_location_no_        := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'FROM_LOCATION_NO', session_rec_ , process_package_, use_applicable_);
      transport_task_level_db_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TRANSPORT_TASK_LEVEL', session_rec_ , process_package_, use_applicable_);

      IF (use_unique_values_) THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (transport_task_id_ IS NULL) THEN
            transport_task_id_ := Get_Unique_Data_Item_Value___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, 'TRANSPORT_TASK_ID');
         END IF;
         IF (from_contract_ IS NULL) THEN
            from_contract_ := Get_Unique_Data_Item_Value___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, 'FROM_CONTRACT');
         END IF;
         IF (from_location_no_ IS NULL) THEN
            from_location_no_ := Get_Unique_Data_Item_Value___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, 'FROM_LOCATION_NO');
         END IF;
         IF (transport_task_level_db_ IS NULL) THEN
            transport_task_level_db_ := Get_Unique_Data_Item_Value___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, 'TRANSPORT_TASK_LEVEL');
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
   transport_task_id_          IN NUMBER,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   transport_task_level_db_    IN VARCHAR2 )  
IS
   detail_value_             VARCHAR2(200);
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN

      CASE (data_item_detail_id_)
         WHEN ('TRANSPORT_TASK_ID') THEN
            detail_value_ := transport_task_id_;
         WHEN ('FROM_CONTRACT') THEN
            detail_value_ := from_contract_;
         WHEN ('FROM_LOCATION_NO') THEN
            detail_value_ := from_location_no_;
         WHEN ('TRANSPORT_TASK_LEVEL') THEN
            detail_value_ := transport_task_level_db_;
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
   transport_task_id_       NUMBER;
   from_contract_           VARCHAR2(5);
   from_location_no_        VARCHAR2(35);
   transport_task_level_db_ VARCHAR2(20);
   column_name_             VARCHAR2(30);
   lov_type_db_             VARCHAR2(20);
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      Get_Filter_Keys___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, capture_session_id_, data_item_id_);
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF (data_item_id_ IN ('TRANSPORT_TASK_ID', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 'TRANSPORT_TASK_LEVEL')) THEN
         IF (data_item_id_ = 'TRANSPORT_TASK_LEVEL' AND transport_task_id_ IS NULL AND from_contract_ IS NULL AND from_location_no_ IS NULL) THEN
            -- Transport Task Level is for some strange reason first in configuration then use the faster enumeration LOV.
            Part_Or_Handl_Unit_Level_API.Create_Data_Capture_Lov(capture_session_id_);
         ELSE
            IF (data_item_id_ = 'TRANSPORT_TASK_LEVEL')  THEN
               column_name_ := 'PART_OR_HANDLING_UNIT';
            ELSE
               column_name_ := data_item_id_;
            END IF;
            lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
            -- NOTE: If from_contract have not been entered/scannet yet we use session contract. If user want to have another contract
            --       as from_contract they should move from_contract to the beginning of the configuration and then enter it manually instead.
            Transport_Task_Handl_Unit_API.Create_Data_Capture_Lov(transport_task_id_       => transport_task_id_,
                                                                  from_contract_           => NVL(from_contract_, session_rec_.session_contract),   
                                                                  from_location_no_        => from_location_no_,
                                                                  transport_task_level_db_ => transport_task_level_db_,
                                                                  capture_session_id_      => capture_session_id_,
                                                                  column_name_             => column_name_,
                                                                  lov_type_db_             => lov_type_db_);
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
   transport_task_id_       NUMBER;
   from_contract_           VARCHAR2(5);
   from_location_no_        VARCHAR2(35);
   transport_task_level_db_ VARCHAR2(20);
   warehouse_task_id_       NUMBER;
   automatic_value_         VARCHAR2(200);
   column_name_             VARCHAR2(30);
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN 
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      -- Try and get value from any previously scanned GS1 barcode if this data item have AI code connected to them. Also reducing the value to lengths we have on the IFS objects
      automatic_value_ := SUBSTR(Data_Capture_Session_API.Get_Item_Value_From_Gs1_Items(capture_session_id_ => capture_session_id_,
                                                                                        capture_process_id_ => session_rec_.capture_process_id,
                                                                                        capture_config_id_  => session_rec_.capture_config_id,
                                                                                        data_item_id_       => data_item_id_), 1, 
                                 NVL(Data_Capt_Proc_Data_Item_API.Get_String_Length(session_rec_.capture_process_id, data_item_id_), 200));

      IF (automatic_value_ IS NULL) THEN

         Get_Filter_Keys___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, capture_session_id_, data_item_id_);
         -- NOTE: If from_contract have not been entered/scannet yet we use session contract. If user want to have another contract
         --       as from_contract they should move from_contract to the beginning of the configuration and then enter it manually instead.
         
         IF (data_item_id_ = 'TRANSPORT_TASK_ID') THEN
            warehouse_task_id_ := Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_, 
                                                                                    data_item_id_a_     => 'WAREHOUSE_TASK_ID',
                                                                                    data_item_id_b_     => data_item_id_);
            IF (warehouse_task_id_ IS NOT NULL) THEN
               automatic_value_ := Warehouse_Task_API.Get_Source_Ref1(warehouse_task_id_);
            ELSE
               automatic_value_ := Transport_Task_Handl_Unit_API.Get_Column_Value_If_Unique(transport_task_id_       => transport_task_id_,
                                                                                            from_contract_           => NVL(from_contract_, session_rec_.session_contract),  
                                                                                            from_location_no_        => from_location_no_,
                                                                                            transport_task_level_db_ => transport_task_level_db_,
                                                                                            column_name_             => data_item_id_);
            END IF;
         ELSIF (data_item_id_ IN ('TRANSPORT_TASK_ID', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 'TRANSPORT_TASK_LEVEL')) THEN      
            IF (data_item_id_ = 'TRANSPORT_TASK_LEVEL')  THEN
               column_name_ := 'PART_OR_HANDLING_UNIT';
            ELSE
               column_name_ := data_item_id_;
            END IF;
   
            automatic_value_ := Transport_Task_Handl_Unit_API.Get_Column_Value_If_Unique(transport_task_id_       => transport_task_id_,
                                                                                         from_contract_           => NVL(from_contract_, session_rec_.session_contract),  
                                                                                         from_location_no_        => from_location_no_,
                                                                                         transport_task_level_db_ => transport_task_level_db_,
                                                                                         column_name_             => column_name_);
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
   transport_task_id_       NUMBER;
   from_contract_           VARCHAR2(5);
   from_location_no_        VARCHAR2(35);
   transport_task_level_db_ VARCHAR2(20);
   column_name_             VARCHAR2(30);
   column_description_      VARCHAR2(200);
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      Get_Filter_Keys___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, capture_session_id_, data_item_id_, data_item_value_);
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);

      column_description_ := Data_Capt_Proc_Data_Item_API.Get_Description(Data_Capture_Session_API.Get_Capture_Process_Id(capture_session_id_), data_item_id_);

      IF (data_item_id_ IN ('TRANSPORT_TASK_ID', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 'TRANSPORT_TASK_LEVEL')) THEN      
         IF (data_item_id_ = 'TRANSPORT_TASK_LEVEL')  THEN
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
         -- NOTE: If from_contract have not been entered/scannet yet we use session contract. If user want to have another contract
         --       as from_contract they should move from_contract to the beginning of the configuration and then enter it manually instead.
         Transport_Task_Handl_Unit_API.Record_With_Column_Value_Exist(transport_task_id_       => transport_task_id_,
                                                                      from_contract_           => NVL(from_contract_, session_rec_.session_contract),  
                                                                      from_location_no_        => from_location_no_,
                                                                      transport_task_level_db_ => transport_task_level_db_,
                                                                      column_name_             => column_name_,
                                                                      column_value_            => data_item_value_,
                                                                      column_description_      => column_description_);
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
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
   conf_item_detail_tab_    Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
   transport_task_id_       NUMBER;
   from_contract_           VARCHAR2(5);
   from_location_no_        VARCHAR2(35);
   transport_task_level_db_ VARCHAR2(20);

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- Fetch all necessary keys for all possible detail items below
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(transport_task_id_, from_contract_, from_location_no_, transport_task_level_db_, capture_session_id_, 
                         latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );
   
      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
   
            IF (conf_item_detail_tab_(i).item_type = Capture_Session_Item_Type_API.DB_DATA) THEN
               -- DATA ITEMS AS DETAILS
               IF (conf_item_detail_tab_(i).data_item_detail_id IN ('TRANSPORT_TASK_ID', 'FROM_CONTRACT', 'FROM_LOCATION_NO', 'TRANSPORT_TASK_LEVEL')) THEN

                  -- Data Items that are part of the filter keys
                  Add_Filter_Key_Detail___(capture_session_id_         => capture_session_id_,
                                           owning_data_item_id_        => latest_data_item_id_,
                                           data_item_detail_id_        => conf_item_detail_tab_(i).data_item_detail_id,
                                           transport_task_id_          => transport_task_id_,
                                           from_contract_              => from_contract_,
                                           from_location_no_           => from_location_no_,
                                           transport_task_level_db_    => transport_task_level_db_);
               ELSE
                  -- Data Items that are not part of the filter keys (like WAREHOUSE_TASK_ID)
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
                                                                           contract_            => from_contract_, 
                                                                           location_no_         => from_location_no_);
               
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
   -- Checking the security for the sub processes here since this process don't execute any methods itself
   -- Check to see that API method Transport_Task_Line_API.Pick is granted thru following projections/actions
   -- Check to see that API method Transport_Task_Line_API.Unpick is granted thru following projections/actions
   -- Check to see that API method Transport_Task_Line_API.Execute is granted thru following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'PickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'UnpickTransportTaskLine') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'ExecuteTransportTaskLines') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'ExecuteTransportTaskLinesForSerials') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'ExecuteTransportTaskLinesForSerials') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskLinesHandling', 'ExecuteTransportTaskLinesForSerials') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'ExecuteTransportTaskLinesForSerials') OR
       -- Check to see that API method Transport_Task_Handl_Unit_API.Pick_HU_Transport_Task is granted thru following projection/action
       -- Check to see that API method Transport_Task_Handl_Unit_API.Unpick_HU_Transport_Task is granted thru following projection/action
       -- Check to see that API method Transport_Task_Handl_Unit_API.Execute_Transport_Task is granted thru following projection/action
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsOnTransportTasksHandling', 'Pick ') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'PickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'PickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'PickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsOnTransportTasksHandling', 'Unpick') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'UnpickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'UnpickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'UnpickAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('HandlingUnitsOnTransportTasksHandling', 'Execute') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseTaskHandling', 'ExecuteAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'ExecuteAggregatedHandlingUnits') OR
       Security_SYS.Is_Proj_Action_Available('TransportTaskHandling', 'ExecuteAggregatedHandlingUnits')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;

