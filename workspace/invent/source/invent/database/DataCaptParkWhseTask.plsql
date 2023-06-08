-----------------------------------------------------------------------------
--
--  Logical unit: DataCaptParkWhseTask
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Supported process: PARK_WAREHOUSE_TASK
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200819  DaZase  SC2020R1-7510, Replaced Is_Method_Available with Is_Proj_Action_Available in Is_Process_Available to support new projection security concept.
--  150128  JeLise  PRSC-5576, Added Lov handling for worker_id and task_id in Create_List_Of_Values and modified Get_Automatic_Data_Item_Value
--  150128          to fetch worker_id in the correct way.
--  141021  DaZase  PRSC-3325, Rewrote how filter keys are handled in process. Changes in Get_Filter_Keys___ and Add_Details_For_Latest_Item. 
--  141021          Replaced Get_Data_Item_Value___ with new method Get_Unique_Data_Item_Value___. Replaced Add_Unique_Detail___ with new methods Add_Filter_Key_Detail___/Add_Unique_Data_Item_Detail___. 
--  141014  JeLise  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Unique_Data_Item_Value___ (
   contract_            IN VARCHAR2,
   task_id_             IN VARCHAR2,
   worker_id_           IN VARCHAR2,
   wanted_data_item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   unique_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      unique_value_ := substr(Warehouse_Task_API.Get_Column_Value_If_Unique(task_id_     => task_id_,
                                                                            contract_    => contract_,
                                                                            worker_id_   => worker_id_,
                                                                            column_name_ => wanted_data_item_id_),1,200);
   $END
   RETURN unique_value_;
END Get_Unique_Data_Item_Value___; 


PROCEDURE Get_Filter_Keys___ (
   contract_           OUT VARCHAR2,
   task_id_            OUT VARCHAR2,
   worker_id_          OUT VARCHAR2,
   capture_session_id_ IN  NUMBER,
   data_item_id_       IN  VARCHAR2,
   data_item_value_    IN  VARCHAR2 DEFAULT NULL,
   use_unique_values_  IN  BOOLEAN  DEFAULT FALSE )
IS
   session_rec_     Data_Capture_Common_Util_API.Session_Rec;
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_     := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      contract_        := session_rec_.session_contract;
      process_package_ := Data_Capture_Process_API.Get_Process_Package(session_rec_.capture_process_id);

      -- First try and fetch "predicted" filter keys 
      task_id_   := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'TASK_ID', session_rec_ , process_package_);
      worker_id_ := Data_Capture_Session_API.Get_Predicted_Data_Item_Value(capture_session_id_, data_item_id_, data_item_value_, 'WORKER_ID', session_rec_ , process_package_);

      IF use_unique_values_ THEN
         -- If some filter keys still are NULL then try and fetch those with unique handling instead
         IF (task_id_ IS NULL) THEN
            task_id_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, 'TASK_ID');
         END IF;   
         IF (worker_id_ IS NULL) THEN
            worker_id_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, 'WORKER_ID');
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
   worker_id_           IN VARCHAR2)  
IS
   detail_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      CASE (data_item_detail_id_)
         WHEN ('TASK_ID') THEN
            detail_value_ := task_id_;
         WHEN ('WORKER_ID') THEN
            detail_value_ := worker_id_;
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
   capture_session_id_     IN NUMBER,
   session_rec_            IN Data_Capture_Common_Util_API.Session_Rec,
   owning_data_item_id_    IN VARCHAR2,
   owning_data_item_value_ IN VARCHAR2,
   data_item_detail_id_    IN VARCHAR2,
   contract_               IN VARCHAR2,
   task_id_                IN VARCHAR2,
   worker_id_              IN VARCHAR2 )  
IS
   detail_value_    VARCHAR2(200);
   process_package_ VARCHAR2(30);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      IF (data_item_detail_id_ IN ('PARK_REASON_ID')) THEN
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
         detail_value_ := Get_Unique_Data_Item_Value___(contract_, task_id_, worker_id_, data_item_detail_id_);
      END IF;

      Data_Capture_Session_Line_API.New(capture_session_id_  => capture_session_id_,
                                        data_item_id_        => owning_data_item_id_,
                                        data_item_detail_id_ => data_item_detail_id_,
                                        data_item_value_     => detail_value_);
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
      IF (data_item_id_ IN ('TASK_ID')) THEN
         Warehouse_Task_API.Started_Task_Exist(data_item_value_);
         Data_Capture_Session_API.Check_Mandatory_Item_Not_Null(capture_session_id_, data_item_id_, data_item_value_, TRUE);
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
   worker_id_      VARCHAR2(20);
   dummy_contract_ VARCHAR2(5);
   task_id_        NUMBER;
   lov_type_db_    VARCHAR2(20);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      lov_type_db_ := Data_Capt_Conf_Data_Item_API.Get_List_Of_Values_Db(capture_process_id_, capture_config_id_, data_item_id_);
   
      IF (data_item_id_ = 'PARK_REASON_ID') THEN
         Warehouse_Task_Park_Reason_API.Create_Data_Capture_Lov(capture_session_id_);
      ELSIF (data_item_id_ = 'WORKER_ID') THEN
         Get_Filter_Keys___(dummy_contract_, task_id_, worker_id_, capture_session_id_, data_item_id_);
         Warehouse_Task_API.Create_Data_Capture_Lov(contract_, task_id_, worker_id_, capture_session_id_, data_item_id_, lov_type_db_);
      ELSIF (data_item_id_ = 'TASK_ID') THEN
         Get_Filter_Keys___(dummy_contract_, task_id_, worker_id_, capture_session_id_, data_item_id_);
         Warehouse_Task_API.Create_Data_Capture_Lov(contract_, task_id_, worker_id_, capture_session_id_, data_item_id_, lov_type_db_);
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
   session_rec_     Data_Capture_Common_Util_API.Session_Rec;
   contract_        VARCHAR2(5);
   task_id_         NUMBER;
   worker_id_       VARCHAR2(20);
   automatic_value_ VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN   
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      IF (data_item_id_ = 'WORKER_ID') THEN
         Get_Filter_Keys___(contract_, task_id_, worker_id_, capture_session_id_, data_item_id_);
         IF ((Data_Capt_Conf_Data_Item_API.Get_Use_Automatic_Value_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'WORKER_ID') = Data_Capture_Value_Usage_API.DB_FIXED) AND 
            (task_id_ IS NULL)) THEN 
            -- Only fetch this if worker_id should be 'Fixed' and is the first data item in the configuration
            automatic_value_ := Person_Info_API.Get_Id_For_User(session_rec_.session_user_id);
            IF (automatic_value_ IS NULL) THEN 
               automatic_value_ := Warehouse_Task_API.Get_Column_Value_If_Unique(contract_    => contract_,
                                                                                 task_id_     => task_id_,
                                                                                 worker_id_   => worker_id_,
                                                                                 column_name_ => data_item_id_);
            END IF;
         ELSE
            automatic_value_ := Warehouse_Task_API.Get_Column_Value_If_Unique(contract_    => contract_,
                                                                              task_id_     => task_id_,
                                                                              worker_id_   => worker_id_,
                                                                              column_name_ => data_item_id_);
         END IF;
      ELSIF (data_item_id_ = 'TASK_ID') THEN
         Get_Filter_Keys___(contract_, task_id_, worker_id_, capture_session_id_, data_item_id_);
         automatic_value_ := Warehouse_Task_API.Get_Column_Value_If_Unique(contract_    => contract_,
                                                                           task_id_     => task_id_,
                                                                           worker_id_   => worker_id_,
                                                                           column_name_ => data_item_id_);
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



@UncheckedAccess
PROCEDURE Add_Details_For_Latest_Item (
   capture_session_id_     IN NUMBER,
   latest_data_item_id_    IN VARCHAR2,
   latest_data_item_value_ IN VARCHAR2 )
IS
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   contract_             VARCHAR2(5);
   worker_id_            VARCHAR2(20);
   task_id_              NUMBER;
   conf_item_detail_tab_ Data_Capture_Common_Util_API.Config_Item_Detail_Tab;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      -- fetch all necessary keys for all possible detail items below
      session_rec_          := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      Get_Filter_Keys___(contract_, task_id_, worker_id_, capture_session_id_, latest_data_item_id_, latest_data_item_value_, use_unique_values_ => TRUE);

      -- fetch the detail items collection
      conf_item_detail_tab_ := Data_Capt_Conf_Item_Detail_API.Get_Collection(capture_process_id_ => session_rec_.capture_process_id,
                                                                             capture_config_id_  => session_rec_.capture_config_id,
                                                                             data_item_id_       => latest_data_item_id_ );

      IF (conf_item_detail_tab_.COUNT > 0) THEN
         FOR i IN conf_item_detail_tab_.FIRST..conf_item_detail_tab_.LAST LOOP
            -- Data Items that are part of the filter keys
            IF (conf_item_detail_tab_(i).data_item_detail_id IN ('TASK_ID', 'WORKER_ID')) THEN
               Add_Filter_Key_Detail___(capture_session_id_   => capture_session_id_,
                                        owning_data_item_id_  => latest_data_item_id_,
                                        data_item_detail_id_  => conf_item_detail_tab_(i).data_item_detail_id,
                                        task_id_              => task_id_,
                                        worker_id_            => worker_id_);
            -- Data Items that are not part of the filter keys and feedback items that will use unique handling
            ELSIF (conf_item_detail_tab_(i).data_item_detail_id IN ('PARK_REASON_ID', 'LOCATION_GROUP', 'TASK_TYPE', 
                                                                    'PRIORITY', 'ASSIGNED_PRIORITY', 'NUMBER_OF_LINES', 'REQUESTED_DATE_FINISHED', 
                                                                    'ACTUAL_DATE_STARTED', 'INFO', 'SOURCE_REF1')) THEN
               Add_Unique_Data_Item_Detail___(capture_session_id_     => capture_session_id_,
                                              session_rec_            => session_rec_,
                                              owning_data_item_id_    => latest_data_item_id_,
                                              owning_data_item_value_ => latest_data_item_value_,
                                              data_item_detail_id_    => conf_item_detail_tab_(i).data_item_detail_id,
                                              contract_               => contract_,
                                              task_id_                => task_id_,
                                              worker_id_              => worker_id_);
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
   ptr_            NUMBER;
   name_           VARCHAR2(50);
   value_          VARCHAR2(2000);
   task_id_        NUMBER;
   park_reason_id_ VARCHAR2(20);
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'TASK_ID') THEN
         task_id_ := value_;
      ELSIF (name_ = 'PARK_REASON_ID') THEN
         park_reason_id_ := value_;
      END IF;
   END LOOP;
   
   Warehouse_Task_API.Park_Task(task_id_        => task_id_,
                                park_reason_id_ => park_reason_id_);
END Execute_Process;


@UncheckedAccess
FUNCTION Is_Process_Available (
   capture_process_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   process_available_ VARCHAR2(5);
BEGIN
   -- Check to see that API method Warehouse_Task_API.Park_Task is granted thru following projections/actions
   IF (Security_SYS.Is_Proj_Action_Available('MyWarehouseTaskHandling', 'ParkTask') OR
       Security_SYS.Is_Proj_Action_Available('WarehouseManagerTaskPlanningHandling', 'ParkTask')) THEN
      process_available_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      process_available_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN process_available_;
END Is_Process_Available;

