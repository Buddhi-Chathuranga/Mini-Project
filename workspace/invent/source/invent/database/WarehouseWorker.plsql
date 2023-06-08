-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseWorker
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200311  DaZase   SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  150729  BudKlk   Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729           method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase   COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150123  JeLise   PRSC-5484, Added method Create_Data_Capture_Lov.
--  141022  MeAblk   Added new method Check_Worker_Exist.
--  130715  ErFelk   Bug 111147, Added ignore return annotation to method Get_Working_Time(). 
--  111001  NaLrlk   Modified Unpack_Check_Update___ to validate start date.
--  110822  Asawlk   Bug 98402, Modified Unpack_Check_Insert___() and Unpack_Check_Update___() to check whether end_date is less 
--  110822           than start_date, if so raised an error.
--  110713  MaEelk   Added user allowed site filter to WAREHOUSE_WORKER_LOV1.
--  110301  ChJalk   Used warehouse_worker_tab instead of the corresponding base view in CURSORS.
--  110204  KiSalk   Moved 'User Allowed Site' Default Where condition from client to base view.
--  100505  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090105  KiSalk   Added methods Validate_Worker and Copy_Worker__, derived attribute server_data_change and modified the relative methods.
--  081231  KiSalk   Called Warehouse_Worker_Task_Type_API.Create_Task_Types_For_Worker in Insert___. Added LOV_VIEW1. 
--  060810  ChJalk   Modified hard_coded dates to be able to use any calendar.
--  060725  ThGulk   Added &OBJID instead of rowid in Procedure Insert___
--  060523  KanGlk   Modified WAREHOUSE_WORKER_LOV view - instead of warehouse_worker_task_type, warehouse_worker_task_type_tab had benn used.  
--  ---------------- 13.4.0 --------------------------------------------------
--  060118  NiDalk   Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  040302  GeKalk   Replaced substrb with substr of view for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  001030  PERK  Changed substr to substrb in WAREHOUSE_WORKER_LOV
--  000925  JOHESE  Added undefines.
--  000217  JOHW  Changed to new User_Allowed_Site functionality.
--  990521  DAZA  Added an exception handling in Get_Working_Time so we can give a 
--                better error message then value error when calendar_id is NotGenerated.
--  990419  JOHW  General performance improvements.
--  990407  JOHW  Upgraded to performance optimized template.
--  990204  JOHW  Added function Get_Working_Time.
--  990129  JOHW  Connected Worker to PersonalInfo.
--  990127  JOHW  Removed methods not in use.
--  990126  JOHW  Added method Check_Worker.
--  990125  DAZA  Added LOV WAREHOUSE_WORKER_LOV.
--  990105  JOHW  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WAREHOUSE_WORKER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   -- Copy/create Warehouse Worker Task Types (SERVER_DATA_CHANGE has value when being called from Copy_Worker__)
   IF NOT(Client_SYS.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      Warehouse_Worker_Task_Type_API.Create_Task_Types_For_Worker(newrec_.contract, newrec_.worker_id);
      Warehouse_Worker_Loc_Group_API.Create_Loc_Groups_For_Worker(newrec_.contract, newrec_.worker_id);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT warehouse_worker_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF newrec_.end_date IS NOT NULL THEN
      IF (newrec_.start_date > newrec_.end_date) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDDATE: Valid to date should be greater than valid from date.');
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     warehouse_worker_tab%ROWTYPE,
   newrec_ IN OUT warehouse_worker_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_           VARCHAR2(30);
   value_          VARCHAR2(4000);   
   min_valid_date_ DATE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (oldrec_.start_date != newrec_.start_date) OR 
      (NVL(oldrec_.end_date, Database_SYS.last_calendar_date_) != NVL(newrec_.end_date, Database_SYS.last_calendar_date_)) THEN
      IF (newrec_.end_date IS NOT NULL) THEN
         IF (newrec_.start_date > newrec_.end_date) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDDATE: Valid to date should be greater than valid from date.');
         END IF;
      END IF;
      IF (oldrec_.start_date != newrec_.start_date) THEN
         min_valid_date_ := Warehouse_Task_API.Get_Min_Latest_Start_Date(newrec_.worker_id);
         IF ((min_valid_date_ IS NOT NULL) AND (TRUNC(newrec_.start_date) >= TRUNC(min_valid_date_))) THEN
            Error_SYS.Record_General(lu_name_, 'INVALSTARTDATE: Valid-from date is not a valid date as an assigned task with the latest start date :P1 exists.', min_valid_date_);
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy_Worker__
--   Copies an Existing warehouse worker to a new one.
PROCEDURE Copy_Worker__ (
   contract_        IN VARCHAR2,
   worker_id_       IN VARCHAR2,
   to_worker_id_    IN VARCHAR2,
   to_contract_     IN VARCHAR2,
   to_start_date_   IN DATE,
   to_worker_group_ IN VARCHAR2,
   to_calendar_id_  IN VARCHAR2 )
IS
   attr_       VARCHAR2(20000);
   copyrec_    WAREHOUSE_WORKER_TAB%ROWTYPE;
   newrec_     WAREHOUSE_WORKER_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_attr IS
      SELECT *
      FROM WAREHOUSE_WORKER_TAB
      WHERE worker_id = worker_id_
      AND   contract  = contract_;
BEGIN
   -- Check if from Warehouse worker exist
   IF (NOT Check_Exist___(contract_, worker_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'NO_WORKER_EXIST: Warehouse worker :P1 does not exist.', worker_id_);
   END IF;
   -- Check if copy to User_Allowed_Site
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, to_contract_);

   -- From Warehouse worker details
   OPEN get_attr;
   FETCH get_attr INTO copyrec_;
   CLOSE get_attr;

   Prepare_Insert___(attr_);

   -- Check if to Warehouse worker already exists
   IF (Check_Exist___(to_contract_, to_worker_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'WORKER_EXIST: Warehouse worker :P1 already exists in site :P2.', to_worker_id_, to_contract_);
   END IF;

   Client_SYS.Set_Item_Value('WORKER_ID', to_worker_id_, attr_);
   Client_SYS.Set_Item_Value('CONTRACT', to_contract_, attr_);
   Client_SYS.Set_Item_Value('START_DATE', NVL(to_start_date_, copyrec_.start_date), attr_);
   Client_SYS.Set_Item_Value('WORKER_GROUP', NVL(to_worker_group_, copyrec_.worker_group), attr_);
   Client_SYS.Set_Item_Value('CALENDAR_ID', NVL(to_calendar_id_, copyrec_.calendar_id), attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   
   Client_SYS.Set_Item_Value('SERVER_DATA_CHANGE', 1, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   -- Create rows on Warehouse Worker Loc Group and Warehouse Worker Task Type.
   Warehouse_Worker_Loc_Group_API.Copy_Location_Groups__(contract_, worker_id_, to_contract_, to_worker_id_);
   Warehouse_Worker_Task_Type_API.Copy_Task_Types__(contract_, worker_id_, to_contract_, to_worker_id_);
END Copy_Worker__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Working_Time
--   Returns working time.
@UncheckedAccess
FUNCTION Get_Working_Time (
   contract_                IN VARCHAR2,
   task_type_               IN VARCHAR2,
   location_group_          IN VARCHAR2,
   requested_date_finished_ IN DATE ) RETURN NUMBER
IS
   now_         DATE;
   grand_total_ NUMBER := 0;
   total_       NUMBER :=0;
   calendar_id_ WAREHOUSE_WORKER_TAB.calendar_id%TYPE;
   error_text_  VARCHAR2(2000);

   CURSOR get_time IS
      SELECT worker_id, calendar_id, calc_time
      FROM WAREHOUSE_WORKER_LOV
      WHERE contract       = contract_
      AND   task_type      = task_type_
      AND   location_group = location_group_;

BEGIN
   now_ := Site_API.Get_Site_Date(contract_);
   FOR rec_ IN get_time LOOP
      calendar_id_ := rec_.calendar_id; 
      total_       := Work_Time_Calendar_API.Get_Work_Minutes_Between(rec_.calendar_id, now_, requested_date_finished_) * rec_.calc_time;
      grand_total_ := grand_total_ + total_;
   END LOOP;
   
   RETURN grand_total_;
EXCEPTION   
   WHEN value_error THEN
      error_text_ := Language_SYS.Translate_Constant(lu_name_, 'CALID_NOT_GEN: The calendar :P1 has not been generated yet', NULL, calendar_id_);
      raise_application_error(-20110, lu_name_ || '.CALID_NOT_GEN: ' || error_text_);
END Get_Working_Time;


-- Validate_Worker
--   Check if start date end end date are within the site date.
PROCEDURE Validate_Worker (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 )
IS
   site_date_ DATE;
   temp_      Public_Rec;
BEGIN
   site_date_ := Site_API.Get_Site_Date(contract_);
   temp_      := Get(contract_, worker_id_);
   IF (trunc(site_date_) < temp_.start_date) THEN
      Error_SYS.Record_General(lu_name_, 'WORKERBEFORE: Warehouse worker :P1 in site :P2 is not valid yet.', worker_id_, contract_);
   ELSIF (trunc(site_date_) > NVL(temp_.end_date, Database_Sys.Get_last_calendar_date())) THEN
      Error_SYS.Record_General(lu_name_, 'WORKEREXPIRE: The warehouse worker record :P1 in site :P2 is no longer valid.', worker_id_, contract_);
   END IF;
END Validate_Worker;


PROCEDURE Check_Worker_Exist (
   worker_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER := 0;
   CURSOR check_worker IS
      SELECT 1
      FROM warehouse_worker_tab
      WHERE worker_id = worker_id_;
BEGIN
   OPEN check_worker;
   FETCH check_worker INTO dummy_;
   CLOSE check_worker;

   IF (dummy_ != 1) THEN
      Error_SYS.Record_General(lu_name_, 'WORKERNOTEXIST: The Warehouse Worker does not exist.');
   END IF;   
END Check_Worker_Exist;    


-- This method is used by DataCaptStartWhseTask
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   capture_session_id_ IN NUMBER,
   contract_           IN VARCHAR2 )
IS
   name_                VARCHAR2(100);
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_  NUMBER;
   exit_lov_            BOOLEAN := FALSE;

   CURSOR get_worker IS
      SELECT worker_id
      FROM warehouse_worker_tab
      WHERE contract = contract_
      ORDER BY Utility_SYS.String_To_Number(worker_id) ASC, worker_id ASC;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      FOR rec_ IN get_worker LOOP
         name_ := Person_Info_API.Get_Name(rec_.worker_id);

         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => rec_.worker_id,
                                          lov_item_description_  => name_,
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
         EXIT WHEN exit_lov_;
      END LOOP;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


