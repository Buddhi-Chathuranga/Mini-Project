-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptStartWhseTask
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: START_WAREHOUSE_TASK
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  200820  DaZase   SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  170531  DaZase   LIM-11472, Added exist validation on TASK_ID.
--  170118  SWiclk   Bug 132477, Modified Add_Requested_Date_Finished___(), Add_Actual_Date_Started___(), Add_Expected_Date_Finished___() 
--  170118           and Add_Latest_Date_Started___() by removing the conversion of date to char since it will be handled in data_capture_session_line_apt.
--  161216  BudKlk   Bug 133086, Modified the method Get_Unique_Data_Item_Value___ to restrict the size of the variable unique_value_ to 
--  160523  DaZase   LIM-6808, Added Validate_Configuration with a loop validation.
--  160201  RuLiLk   Bug 124219, Modified methods Add_Latest_Date_Started___, Add_Expected_Date_Finished___ to format date value
--  160201           to Client_SYS.date_format_ to avoid date format error. Added methods Add_Requested_Date_Finished___, Add_Actual_Date_Started___ 
--  160201           to format Date values to Client_Sys data formating.
--  150127  DaZase   Added validation on TASK_TYPE in Validate_Data_Item.
--  150123  JeLise   PRSC-5484, Added call to Warehouse_Worker_API.Create_Data_Capture_Lov in Create_List_Of_Values.
--  150123  JeLise   PRSC-5389, Added call to Warehouse_Task_API.Validate_Worker_Start_Allow__ in Validate_Data_Item, to check
--  150123           if the worker already has a started task or not.
--  141209  JeLise   Changed Execute_Process to call Start_Or_Restart_Task instead of calling both Start_Task and Restart.
--  141116  MeAblk   Modified Validate_Data_Item in order to validate the WORKER_ID for a valid warehouse worker.
--  141021  DaZase   PRSC-3325, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___ and Add_Details_For_Latest_Item. 
--  141021           Replaced Get_Data_Item_Value___ with new method Get_Unique_Data_Item_Value___. Replaced Add_Unique_Detail___ with new methods 
--  141021           Add_Filter_Key_Detail___/Add_Unique_Data_Item_Detail___. 
--  141015  JeLise   Added PARK_REASON_ID and PARK_REASON_DESCRIPTION as feedback items.
--  141013  JeLise   Added cursor get_state in Execute_Process, to make sure that the Warehouse Task will be Started.
--  140902  JeLise   Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_            IN VARCHAR2,
   task_id_             IN VARCHAR2,
   worker_id_           IN VARCHAR2,
   location_group_      IN VARCHAR2,
   state_               IN VARCHAR2,
   wanted_data_item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_        VARCHAR2(200);
   decoded_column_name_ VARCHAR2(50);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      IF (wanted_data_item_id_ = 'STATUS') THEN
         decoded_column_name_ := 'OBJSTATE';
      ELSIF (wanted_data_item_id_ = 'TASK_TYPE') THEN
         decoded_column_name_ := 'TASK_TYPE_DB';
      ELSE
         decoded_column_name_ := wanted_data_item_id_;
      END IF;

      unique_value_ := substr(Warehouse_Task_API.Get_Column_Value_If_Unique(task_id_        => task_id_,
                                                                            contract_       => contract_,
                                                                            worker_id_      => worker_id_,
                                                                            location_group_ => location_group_,
                                                                            state_          => state_,
                                                                            column_name_    => decoded_column_name_), 1, 200);
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___; 


PROCEDURE Get_Filter_Keys___ (
   contract_           OUT VARCHAR2,
   task_id_            OUT VARCHAR2,
   worker_id_          OUT VARCHAR2,
   location_group_     OUT VARCHAR2,
   state_              OUT VARCHAR2,
   capture_session_id_ IN  NUMBER,
   data_item_id_       IN  VARCHAR2,
   data_item_value_    IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_  IN  BOOLEAN  DEFAULT FALSE )
IS
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   process_package_       VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
      contract_        := session_rec_.session_contract;

      -- First try and fetch "predicted" filter keys 
      task_id_         := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TASK_ID', session_rec_ , process_package_);    
      worker_id_       := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WORKER_ID', session_rec_ , process_package_);
      location_group_  := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'LOCATION_GROUP', session_rec_ , process_package_);
      state_           := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'STATUS', session_rec_ , process_package_);

      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (task_id_ IS NULL) THEN
            task_id_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, location_group_, state_, 'TASK_ID');
         END IF;
         IF (worker_id_ IS NULL) THEN
            worker_id_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, location_group_, state_, 'WORKER_ID');
         END IF;
         IF (location_group_ IS NULL) THEN
            location_group_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, location_group_, state_, 'LOCATION_GROUP');
         END IF;
         IF (state_ IS NULL) THEN
            state_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, location_group_, state_, 'STATUS');
         END IF;
      END IF;
   $ELSE
      NULL;                       
   $END
END Get_Filter_Keys___;


PROCEDURE Add_Filter_Key_Detail___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   task_id_             IN VARCHAR2,
   worker_id_           IN VARCHAR2,
   location_group_      IN VARCHAR2,
   state_               IN VARCHAR2 )  
IS
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('TASK_ID') THEN
            detail_value_ := task_id_;
         WHEN ('WORKER_ID') THEN
            detail_value_ := worker_id_;
         WHEN ('LOCATION_GROUP') THEN
            detail_value_ := location_group_;
         WHEN ('STATUS') THEN
            detail_value_ := state_;
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
   capture_session_id_     IN NUMBER,
   session_rec_            IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_    IN VARCHAR2,
   owning_data_item_value_ IN VARCHAR2,
   data_item_detail_id_    IN VARCHAR2,
   contract_               IN VARCHAR2,
   task_id_                IN VARCHAR2,
   worker_id_              IN VARCHAR2,
   location_group_         IN VARCHAR2,
   state_                  IN VARCHAR2 )  
IS
   detail_value_    VARCHAR2(200);
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_detail_id_ IN ('TASK_TYPE')) THEN
         process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);
         -- All non filter key data items, try and fetch their predicted value
         detail_value_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_      => capture_session_id_,
                                                                                 current_data_item_id_    => owning_data_item_id_,
                                                                                 current_data_item_value_ => owning_data_item_value_,
                                                                                 wanted_data_item_id_     => data_item_detail_id_,
                                                                                 session_rec_             => session_rec_,
                                                                                 process_package_         => process_package_);
      END IF;

      -- Non filter key data items AND feedback items that could be fetched by unique handling
      IF (detail_value_ IS NULL) THEN
         detail_value_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, location_group_, state_, data_item_detail_id_);
      END IF;

      Data_Capture_Session_Line_API.New(capture_session_id_    => capture_session_id_,
                                        data_item_id_          => owning_data_item_id_,
                                        data_item_detail_id_   => data_item_detail_id_,
                                        data_item_value_       => detail_value_);
   $ELSE
      NULL;
   $END
END Add_Unique_Data_Item_Detail___;


PROCEDURE Add_Tot_Planned_Time_Needed___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   task_id_             IN NUMBER )
IS
   total_planned_time_needed_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      total_planned_time_needed_ := Warehouse_Task_API.Get_Total_Planned_Time_Needed(task_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => total_planned_time_needed_);
   $ELSE
      NULL;                                     
   $END
END Add_Tot_Planned_Time_Needed___;


PROCEDURE Add_Latest_Date_Started___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   task_id_             IN NUMBER )
IS
   latest_date_started_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      latest_date_started_ := Warehouse_Task_API.Get_Latest_Date_Started(task_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => latest_date_started_);
   $ELSE
      NULL;                                     
   $END
END Add_Latest_Date_Started___;


PROCEDURE Add_Expected_Date_Finished___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   task_id_             IN NUMBER )
IS
   expected_date_finished_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      expected_date_finished_ := Warehouse_Task_API.Get_Expected_Date_Finished(task_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => expected_date_finished_);
   $ELSE
      NULL;                                     
   $END
END Add_Expected_Date_Finished___;


PROCEDURE Add_Park_Reason_Description___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   task_id_             IN NUMBER )
IS
   park_reason_id_   VARCHAR2(50);
   park_reason_desc_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      park_reason_id_   := Warehouse_Task_API.Get_Park_Reason_Id(task_id_);
      park_reason_desc_ := Warehouse_Task_Park_Reason_API.Get_Description(park_reason_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => park_reason_desc_);
   $ELSE
      NULL;                                     
   $END
END Add_Park_Reason_Description___;

PROCEDURE Add_Actual_Date_Started___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   task_id_             IN NUMBER )
IS
   actual_date_started_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   actual_date_started_ := Warehouse_Task_API.Get_Actual_Date_Started(task_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => actual_date_started_);
   $ELSE
      NULL;                                     
   $END
END Add_Actual_Date_Started___;

PROCEDURE Add_Requested_Date_Finished___ (
   capture_session_id_  IN NUMBER,
   owning_data_item_id_ IN VARCHAR2,
   data_item_detail_id_ IN VARCHAR2,
   task_id_             IN NUMBER )
IS
   requested_date_finished_ DATE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   requested_date_finished_ := Warehouse_Task_API.Get_Requested_Date_Finished(task_id_);
      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => requested_date_finished_);
   $ELSE
      NULL;                                     
   $END
END Add_Requested_Date_Finished___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Data_Item (
   capture_session_id_ IN NUMBER,
   data_item_id_       IN VARCHAR2, 
   data_item_value_    IN VARCHAR2 )       
IS
   session_contract_    VARCHAR2(5);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_id_ IN ('TASK_ID', 'LOCATION_GROUP', 'WORKER_ID')) THEN
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
      END IF;
      
      IF (data_item_id_ = 'WORKER_ID') THEN
         session_contract_ := Data_Capture_Session_API.Get_Session_Contract(capture_session_id_); 
         Warehouse_Worker_API.Validate_Worker(session_contract_, data_item_value_);
         Warehouse_Task_API.Validate_Worker_Start_Allow__(session_contract_, data_item_value_);
      ELSIF (data_item_id_ = 'TASK_TYPE') THEN
         Warehouse_Task_Type_API.Exist_Db(data_item_value_);
      ELSIF (data_item_id_ = 'TASK_ID') THEN
         Warehouse_Task_API.Exist(data_item_value_);
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
   task_id_              NUMBER;
   worker_id_            VARCHAR2(20);
   location_group_       VARCHAR2(5);
   state_                VARCHAR2(4000);
   dummy_contract_       VARCHAR2(5);
   lov_type_db_          VARCHAR2(20);
   decoded_column_name_  VARCHAR2(50);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
      IF (data_item_id_ IN ('TASK_ID', 'LOCATION_GROUP', 'STATUS')) THEN
         Get_Filter_Keys___(dummy_contract_, task_id_, worker_id_, location_group_, state_, capture_session_id_, data_item_id_);
         IF (data_item_id_ = 'STATUS') THEN
            decoded_column_name_ := 'OBJSTATE';
         ELSE
            decoded_column_name_ := data_item_id_;
         END IF;
         Warehouse_Task_API.Create_Data_Capture_Lov(contract_           => contract_,
                                                    task_id_            => task_id_,
                                                    location_group_     => location_group_,
                                                    worker_id_          => worker_id_,
                                                    state_              => state_,
                                                    task_type_          => Data_Capture_Session_API.Get_Latest_A_If_Before_B(capture_session_id_ => capture_session_id_,
                                                                                                                             data_item_id_a_     => 'TASK_TYPE',
                                                                                                                             data_item_id_b_     => data_item_id_),
                                                    capture_session_id_ => capture_session_id_,
                                                    column_name_        => decoded_column_name_,
                                                    lov_type_db_        => lov_type_db_);
    
      ELSIF (data_item_id_ = 'TASK_TYPE') THEN
         Warehouse_Task_Type_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ = 'WORKER_ID') THEN
         Warehouse_Worker_API.Create_Data_Capture_Lov(capture_session_id_, contract_);
      END IF;
   $ELSE
      NULL;
   $END 
END Create_List_Of_Values;


@UncheckedAccess
FUNCTION Get_Automatic_Data_Item_Value (
   capture_session_id_ IN VARCHAR2,
   data_item_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   contract_            VARCHAR2(5);
   task_id_             NUMBER;
   worker_id_           VARCHAR2(20);
   location_group_      VARCHAR2(5);
   automatic_value_     VARCHAR2(200);
   state_               VARCHAR2(4000);
   decoded_column_name_ VARCHAR2(50);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN   
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF (data_item_id_ = 'WORKER_ID') THEN
         automatic_value_ := Person_Info_API.Get_Id_For_User(session_rec_.session_user_id);
         IF (automatic_value_ IS NULL) then
            Get_Filter_Keys___(contract_, task_id_, worker_id_, location_group_, state_, capture_session_id_, data_item_id_);
            automatic_value_ := Warehouse_Task_API.Get_Column_Value_If_Unique(contract_       => contract_,
                                                                              task_id_        => task_id_,
                                                                              worker_id_      => worker_id_,
                                                                              location_group_ => location_group_,
                                                                              state_          => state_,
                                                                              column_name_    => data_item_id_);
         END IF;
         RETURN automatic_value_;
      ELSIF (data_item_id_ IN ('TASK_ID', 'LOCATION_GROUP', 'STATUS', 'TASK_TYPE')) THEN
         Get_Filter_Keys___(contract_, task_id_, worker_id_, location_group_, state_, capture_session_id_, data_item_id_);

         IF (data_item_id_ = 'STATUS') THEN
            decoded_column_name_ := 'OBJSTATE';
         ELSIF (data_item_id_ = 'TASK_TYPE') THEN
            decoded_column_name_ := 'TASK_TYPE_DB';
         ELSE
            decoded_column_name_ := data_item_id_;
         END IF;

         automatic_value_ := Warehouse_Task_API.Get_Column_Value_If_Unique(contract_       => contract_,
                                                                           task_id_        => task_id_,
                                                                           worker_id_      => worker_id_,
                                                                           location_group_ => location_group_,
                                                                           state_          => state_,
                                                                           column_name_    => decoded_column_name_);
         RETURN automatic_value_;
      END IF;
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


@UncheckedAccess
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   contract_             VARCHAR2(5);
   task_id_              NUMBER;
   worker_id_            VARCHAR2(20);
   location_group_       VARCHAR2(5);
   state_                VARCHAR2(4000);
   conf_item_detail_tab_ Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- fetch all necessary keys for all possible detail items below
      session_rec_          := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, task_id_, worker_id_, location_group_, state_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );

      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            -- Data Items that are part of the filter keys
            IF (conf_item_detail_tab_(i).data_item_detail_id IN ('TASK_ID', 'LOCATION_GROUP', 'WORKER_ID', 'STATUS')) THEN
               Add_Filter_Key_Detail___(capture_session_id_   => capture_session_id_,
                                        owning_data_item_id_  => latest_data_item_id_,
                                        data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                        task_id_              => task_id_,
                                        worker_id_            => worker_id_,
                                        location_group_       => location_group_,
                                        state_                => state_);

            -- Data Items that are not part of the filter keys and feedback items that will use unique handling
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('TASK_TYPE', 'PRIORITY', 'ASSIGNED_PRIORITY', 'NUMBER_OF_LINES', 
                                                                    'INFO', 'SOURCE_REF1', 'PARK_REASON_ID')) THEN
               Add_Unique_Data_Item_Detail___(capture_session_id_     => capture_session_id_,
                                              session_rec_            => session_rec_,
                                              owning_data_item_id_    => latest_data_item_id_,
                                              owning_data_item_value_ => latest_data_item_value_,
                                              data_item_detail_id_    => conf_item_detail_tab_(i).data_item_detail_id,
                                              contract_               => contract_,
                                              task_id_                => task_id_,
                                              worker_id_              => worker_id_,
                                              location_group_         => location_group_,
                                              state_                  => state_);

            ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'TOTAL_PLANNED_TIME_NEEDED') THEN
               Add_Tot_Planned_Time_Needed___(capture_session_id_  => capture_session_id_, 
                                              owning_data_item_id_ => latest_data_item_id_,
                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,   
                                              task_id_             => task_id_);
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'LATEST_START_DATE') THEN
               Add_Latest_Date_Started___(capture_session_id_  => capture_session_id_, 
                                          owning_data_item_id_ => latest_data_item_id_,
                                          data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,   
                                          task_id_             => task_id_);
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'EXPECTED_FINISH_DATE') THEN
               Add_Expected_Date_Finished___(capture_session_id_  => capture_session_id_, 
                                             owning_data_item_id_ => latest_data_item_id_,
                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,   
                                             task_id_             => task_id_);
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'ACTUAL_DATE_STARTED') THEN
               Add_Actual_Date_Started___(capture_session_id_  => capture_session_id_, 
                                          owning_data_item_id_ => latest_data_item_id_,
                                          data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,   
                                          task_id_             => task_id_);
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'REQUESTED_DATE_FINISHED') THEN
               Add_Requested_Date_Finished___(capture_session_id_  => capture_session_id_, 
                                             owning_data_item_id_ => latest_data_item_id_,
                                             data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,   
                                             task_id_             => task_id_);                                 
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id = 'PARK_REASON_DESCRIPTION') THEN
               Add_Park_Reason_Description___(capture_session_id_  => capture_session_id_, 
                                              owning_data_item_id_ => latest_data_item_id_,
                                              data_item_detail_id_ => conf_item_detail_tab_(i).data_item_detail_id,   
                                              task_id_             => task_id_);
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
   ptr_       NUMBER;
   name_      VARCHAR2(50);
   value_     VARCHAR2(2000);
   task_id_   NUMBER;
   worker_id_ VARCHAR2(20);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'TASK_ID') THEN
         task_id_ := value_;
      ELSIF (name_ = 'WORKER_ID') THEN
         worker_id_ := value_;
      END IF;
   END LOOP;

   Warehouse_Task_API.Start_Or_Restart_Task(task_id_, worker_id_);
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- This action is not the same as the method we use in execution but it does exact same things so no need to create a dummy action for this check
   IF (Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'StartSelected')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;



PROCEDURE Validate_Configuration (
   capture_process_id_ IN VARCHAR2,
   capture_config_id_  IN NUMBER ) 
IS
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (Data_Capture_Config_API.Is_Config_Using_Loop(capture_process_id_, capture_config_id_)) THEN
         Error_SYS.Record_General(lu_name_,'LOOPSARENOTALLOWEDINTHISPROCESS: Loops are not allowed in this process.');
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Configuration;


