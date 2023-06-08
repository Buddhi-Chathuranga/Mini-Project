-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseTask
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  --------------------------------------------------------
--  210218  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  200311  DaZase  SCXTEND-3803, Small change in both Create_Data_Capture_Lov to change 1 param in calls to Data_Capture_Session_Lov_API.New.
--  191121  SBalLK  Bug 150436 (SCZ-6914), Removed Check_Insert___() method and added Validate_Worker_Group___(), Validate_Group_In_Loc_Group___() and
--  191121          Validate_Worker_Loc_Group___() methods. Modified Validate_Warehouse_Worker___() and Check_Common___() methods to validate that worker is
--  191121          assigned to defined location group.
--  191112  DaZase  Bug 150923 (SCZ-7748), Corrected issue caused when Bug 125618 was merged into Apps10 but some of the implementation was missed in Create_Data_Capture_Lov.
--  191023  SBalLK  Bug 150436 (SCZ-6914), Added Modify_Location_Group() method.
--  190926  DaZase  SCSPRING20-107, Added Raise_To_Date_Error___ to solve MessageDefinitionValidation issue.
--  190416  DaZase  SCUXXW4-6560, Added Get_Transport_Task_Id to support Aurena client.
--  180125  DaZase  STRSC-16220, Changed Create_Data_Capture_Lov for PARK_WAREHOUSE_TASK process by removing task_type since it was removed from view earlier for performance reasons.
--  170824  RuLiLk  Bug 137210, Modified method Create_Data_Capture_Lov, to fetch task_type client value only when necessary to improve performance of the LOV.
--  171003  DiKuLk  Bug 138039, Modified Check_To_Location_Group___() message constant from INVALIDWAREHOUSEGRPTASK to INVALIDWAREHOUSEWORKER in order to avoid overriding language translations.
--  160108  BudKlk  Bug 125618, Modified the method Create_Data_Capture_Lov() to handle the autopick functionality for the data items TASK_ID and LOCATION_GROUP.
--  151103  JeLise  LIM-4392, Removed all pallet related task types.
--  150904  JeLise  AFT-3304, Rewritten LOV handling for TASK_ID in Create_Data_Capture_Lov (used from PARK_WAREHOUSE_TASK).
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in methods Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150202  MeAblk  PRSC-5506, Added new method Wrkr_Grp_Is_Allowed_For_Wrkrs. Modifed methods Check_To_Location_Group___ and Get_Task_Id_To_Start in order to have to location validation on workers. 
--  150202  Chfose  PRSC-5509, Added Client_SYS.Merge_Info to New in order to keep previous info messages.
--  150131  MeAblk  PRSC-5907, Removed method Check_Before_Update___ and moved its code into Check_Common___. Replaced method called to Check_Before_Update___
--  150131          using Modify___ where applicable. Added newc methods Worker_Is_To_Loc_Group_Active, Workr_Grp_Is_To_Loc_Grp_Active, Workr_Grp_Is_To_Site_Active, Worker_Is_To_Contract_Active. 
--  150128  JeLise  PRSC-5576, Added a second Create_Data_Capture_Lov to be used from the process for PARK_WAREHOUSE_TASK.
--  150127  JeLise  PRSC-5487, Added order by if wanted in Create_Data_Capture_Lov.
--  150122  JeLise  PRSC-5414, Added check on worker_group in Update___ to change state to Release, the same way as for worker_id.
--  150122  JeLise  PRSC-5365, Increased the length of column_value_ and unique_column_value_ to 2000 in Get_Column_Value_If_Unique.
--  150113  JeLise  Rewritten LOV handling for TASK_ID and LOCATION_GROUP in Create_Data_Capture_Lov.
--  141218  MaEelk  PRSC-4693, Modified Get_Task_Id_From_Source to fetch a Task Id which is not in state Closed or Cancelled.
--  141217  DaZase  PRSC-1611, Added extra column check in method Create_Data_Capture_Lov to avoid any risk of getting sql injection problems.
--  141215  UdGnlk  PRSC-4609, Added annotation Approve Dynamic Statement which were missing.
--  141209  JeLise  Replaced method Restart with method Start_Or_Restart_Task.
--  141122  MeAblk  Added new methods Data_Capt_Item_Value_Exist, Get_Data_Capt_Item_Value_Desc.
--  141105  JeLise  Excluded 'CUSTOMER ORDER PALLET PICK LIST' and 'PALLET TRANSPORT TASK' from lov in Create_Data_Capture_Lov.
--  141104  JeLise  Added call to Inventory_Location_API.Get_Location_Name to show the location description instead of the location no in the lov in Create_Data_Capture_Lov
--  141029  MeAblk  Modified method Get_Task_Id_To_Start in order to validate the To Location of transport task when finding a task to start. 
--  141022	JeLise  Added method Started_Task_Exist to be used from Data_Capt_Park_Whse_Task_API.
--  141022  MeAblk  Added new method Check_Status_Exist.
--  141017  MeAblk  Modified Check_Before_Update___ in order to validate the location group with the worker group allowed location groups.
--  141017  JeLise  Changed from WAREHOUSE_TASK_TAB to WAREHOUSE_TASK_TOTAL in Get_Column_Value_If_Unique and Create_Data_Capture_Lov.
--  141014  JeLise  Added another Get_Column_Value_If_Unique to be used from Data_Capt_Park_Whse_Task_API.
--  141014  MeAblk  Modified method Check_Before_Update___ in order to validate To Location of transport tasks when assiging a worker or a worker group.
--  141013  JeLise  Added another call to Validate_Worker_Start_Allow__ (worker_id_ is not null) in Start_Task.
--  141010  JeLise  Added fetch of location_no in Create_Data_Capture_Lov.
--  141009  MeAblk  Added new method Complete_Started_Tasks__ to execute when RMB complete from warehouse task manager window.
--  141006  JeLise  Added in parameter task_type_ to Create_Data_Capture_Lov.
--  140929  MeAblk  Removed method Prioritize_Task___ since there is no usage.
--  140926  Maeelk  Added Park_Task to store the park reason when the task is going to Park State this will be called from client instead of the Standard Method Park__.
--  140926          Removed the park reason if there is, when going back to Started State.
--  140919  MeAblk  Modified Do_Release_From_Started___ in order to avoid setting NULL for assigned_priority when release from start state.
--  140919  JeLise  Added new method Restart to be able to start Parked warehouse tasks from DataCaptStartWhseTask.
--  140912  MeAblk  Modified methods Get_Task_Id_To_Start, Ready_To_Start_Task_Exist in order to correctly retrieve the worker group assigned tasks.
--  140911  MeAblk  Added new method Assign_Tasks_To_Worker_Group__ and modified Validate_Warehouse_Worker___ in order to validate the worker with the worker group.
--  140909  MeAblk  Modified Do_Plan___ in order to avoid setting operative priority into NULL when changing the state from release to plan.
--  140905  JeLise  Added Get_Column_Value_If_Unique and Create_Data_Capture_Lov.
--  140905  MeAblk  Modified Validate_Warehouse_Worker___ by removing the error message validating worker group.
--  140904  MeAblk  Modified Check_Before_Update___ in order to make sure only positive integers are entered for the assigned priority.
--  140904          And removed method Prioritize__ since it's no longer used.
--  130805  UdGnlk  TIBE-917, Removed the dynamic code and modify to conditional compilation.
--  130618  AyAmlk  Bug 110637, Modified Assign_Tasks_To_Worker__() to automate the ability to reassign parked warehouse tasks.
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130228  Asawlk  Bug 108475, Added method Get_State().
--  130114  RiLase  Changed from Transport_Task_API.Execute to Transport_Task_API.Execute_All in method Execute_Started_Task.
--  121011  MaMalk  Bug 102071, Modified methods CALC_ACT_TASK_TYPE_EFF_RATE and CALC_ACT_SETUP_TIME_NEEDED to handle the DB value of parameter task_type.
--  120815  NiDalk  Bug 104534, Added method Check_Start_Warehouse_Task___. Called it in Do_Restart___ and Do_Start___.
--  120320  MaRalk  Modified Validate_Warehouse_Worker___ to validate warehouse worker groups task type when 
--  120320          creating pick list from manual consolidated pick list window.
--  120208  MaEelk  Added Start event to Finite_State_Events__ to correct model errors.
--  120118  LEPESE  Added method Source_Task_Started_Or_Parked.
--  111215  GanNLK  In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  111004  MaEelk  Modified Report_Task to add an error message when trying to report pick in Parked state.
--  111001  NaLrlk  Added method Get_Min_Latest_Start_Date.
--  110913  MaRalk  Modified spelling in the message TASKTYPEEFFRATE within Calc_Act_Task_Type_Eff_Rate method. 
--  110225  ChJalk  Moved 'User Allowed Site' Default Where condition from client to base view and modified WAREHOUSE_TASK_TAB instead of WAREHOUSE_TASK in CURSORS.
--  100505  KRPELK  Merge Rose Method Documentation.
--  091001  ChFolk  Removed unused variables in the package.
--  ------------------------------- 14.0.0 ------------------------------------
--  091020  NaLrlk  Modified the method Execute_Started_Task to remove the customer order pick list task completion.
--  090903  KiSalk  Added State Parked and procedures Do_Park___, Park__, Do_Restart___ and Restart.
--  090903          Modified Check_Before_Update___ to check state.
--  090407  NaLrlk  Modified the method Execute_Started_Task to execute the shop order pick list tasks.
--  090226  NaLrlk  Added method Assign_Tasks_To_Worker__.
--  090224  KiSalk  Added and used method Validate_Warehouse_Worker___.
--  090224  NaLrlk  Added method Get_Next_Assigned_Priority___, Prioritize_Task___ and Prioritize__.
--  090223  NaLrlk  Added private column assigned_priority.
--  090219  NaLrlk  Added method Execute_Started_Task.
--  090217  NaLrlk  Added functions Started_Task_Exist and Ready_To_Start_Task_Exist.
--  090213  MaHplk  Added execution_offset_from_ and execution_offset_to_ parameters to Calc_Act_Loc_Group_Time_Share,
--  090213          Calc_Act_Setup_Time_Needed,Calc_Act_Task_Type_Eff_Rate and Calc_Act_Task_Type_Time_Share.
--  090208  NaLrlk  Added method Modify_Worker and Validate_Worker_Start_Allow__. Modified worker_id_ parameter as default null
--  090208           in Start_Task. Removed method Is_Worker_Ready. Modify method Find_And_Start_Task.
--  090208          Added Check_Before_Update___ and moved logic in unpack_Check_Update___ to this method.
--  090208          Modified methods Do_Cancel___, Do_Plan___, Do_Start___, Do_Release_From_Started___, Do_Close___,
--  090208          Start_Task and Modify_Number_Of_Lines for new method Check_Before_Update___.
--  090206  KiSalk  Added task_id back to attr_ in Insert___ and set it for task_id_ in New.
--  090206          Added parameter worker_id_ in New.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060118  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  050921  NiDalk  Removed unused variables.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  030913  JaBalk  Bug 37936, Changed the length of attr_ to 32000 to include the 2000 length of info_
--  030913          variable passing from Create_Pick_List_API.Consol_Pick_List___ in New procedure.
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in Source_Task_Is_Started.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000302  JOHW    Removed check if task type is active.
--  000204  JOHW    Extended info_temp_ to varchar2(2000).
--  000107  JOHW    Added method Source_Task_Is_Started.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990910  ANHO    Added General_SYS.Init_Method in Find_And_Start_Task.
--  990420  JOHW    General performance improvements.
--  990409  JOHW    Upgraded to performance optimized template.
--  990322  JOHW    Added two methods to handle removal of task source.
--  990316  JOHW    Changed sequence to warehouse_task_id.
--  990305  JOHW    Changed names on procedure according to batches.
--  990208  JOHW    Added functions.
--  990204  JOHW    Added function Check_Planned_And_Released.
--  990127  JOHW    Performence changes.
--  990127  JOHW    Added functions according to fetch data to tbwWorkerOverview.
--  990127  JOHW    Removed method not in use.
--  990126  JOHW    Added private method Calc_Actual_Time_Needed__.
--  990124  JOHW    Added private method Calc_Actual_Time_Share__.
--  990122  JOHW    Changed name to Report_Task.
--  990121  JOHW    Added check when updating number_of_lines.
--  990120  JOHW    Added function Is_Worker_Ready.
--  990120  JOHW    Added Start_Task functionality.
--  990118  JOHW    Added method Find_And_Start_Task.
--  990118  JOHW    Added methods for Batch.
--  990114  JOHW    Added function calls to Check_Worker_Task_Type and
--                  Check_Worker_Loc_Group from Unpack_Check_Update.
--  990113  JOHW    Added new methods according to Modify number of lines and
--                  Find and report task.
--  990112  JOHW    Added method Do_Release_From_Started.
--  981230  JOHW    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_To_Date_Error___ 
IS
BEGIN
   Error_SYS.Record_General('WarehouseTask','TODATE: To Date must be greater than From Date.');
END Raise_To_Date_Error___;   

PROCEDURE Validate_Warehouse_Worker___ (
   newrec_ IN warehouse_task_tab%ROWTYPE )
IS 
   worker_group_ WAREHOUSE_TASK_TAB.worker_group%TYPE;
BEGIN
   Warehouse_Worker_API.Validate_Worker(newrec_.contract, newrec_.worker_id);

   IF NOT (Warehouse_Worker_Task_Type_API.Is_Active_Worker(newrec_.contract, newrec_.worker_id, newrec_.task_type)) THEN
      Error_SYS.Record_General('WarehouseTask','NOTASKTYPE: The Worker is not allowed to perform this Warehouse Task, see Warehouse Worker Task Type.');
   END IF;
   Validate_Worker_Loc_Group___(newrec_.contract, newrec_.worker_id, newrec_.location_group);
   IF (newrec_.task_type = 'CUSTOMER ORDER PICK LIST') THEN
      $IF (Component_Order_SYS.INSTALLED) $THEN
         Customer_Order_Pick_List_API.Modify_Default_Ship_Location(newrec_.source_ref1);
      $ELSE
         NULL;
      $END
   ELSIF (newrec_.task_type = Warehouse_Task_Type_API.DB_TRANSPORT_TASK) THEN
      Check_Transport_To_Contract___(newrec_.source_ref1, newrec_.worker_id, NULL, newrec_.task_type);
      Check_To_Location_Group___(newrec_.source_ref1, newrec_.worker_id, NULL);
   END IF;

   IF (newrec_.worker_group IS NOT NULL) THEN
      worker_group_ := Warehouse_Worker_API.Get_Worker_Group(newrec_.contract, newrec_.worker_id);
      IF (worker_group_ != newrec_.worker_group) THEN
         Error_SYS.Record_General(lu_name_,'INVALIDWORKER: The Worker is not belonging to the Worker Group :P1 defined in the Warehouse Task :P2.', newrec_.worker_group, newrec_.task_id);
      END IF;   
   END IF;   
END Validate_Warehouse_Worker___;


PROCEDURE Validate_Worker_Group___(
   newrec_ IN warehouse_task_tab%ROWTYPE )
IS
BEGIN
   IF (NOT Warehouse_Worker_Grp_Task_API.Is_Active_Worker_Group(newrec_.contract, newrec_.worker_group, newrec_.task_type)) THEN
      Error_SYS.Record_General(lu_name_,'INVALIDWORKERGROUP: Worker Group :P1 is not allowed for the Task Type :P2 on Warehouse Task :P3.', 
                               newrec_.worker_group, Get_Task_Type(newrec_.task_id), newrec_.task_id);
   END IF;
   Validate_Group_In_Loc_Group___(newrec_.contract, newrec_.worker_group, newrec_.location_group);
   
   IF (newrec_.task_type = Warehouse_Task_Type_API.DB_TRANSPORT_TASK) THEN
      Check_Transport_To_Contract___(newrec_.source_ref1, NULL, newrec_.worker_group, newrec_.task_type);
      Check_To_Location_Group___(newrec_.source_ref1, NULL, newrec_.worker_group);
   END IF;
END Validate_Worker_Group___;


PROCEDURE Validate_Worker_Loc_Group___(
   contract_       IN warehouse_task_tab.contract%TYPE,
   worker_id_      IN warehouse_task_tab.worker_id%TYPE,
   location_group_ IN warehouse_task_tab.location_group%TYPE )
IS
BEGIN
   IF NOT (Warehouse_Worker_Loc_Group_API.Is_Active_Worker(contract_, worker_id_, location_group_)) THEN
      Error_SYS.Record_General('WarehouseTask','NOLOCGROUP: The Worker is not allowed to perform this Warehouse Task, see Warehouse Worker Location Group.');
   END IF;
END Validate_Worker_Loc_Group___;


PROCEDURE Validate_Group_In_Loc_Group___(
   contract_       IN warehouse_task_tab.contract%TYPE,
   worker_group_   IN warehouse_task_tab.worker_group%TYPE,
   location_group_ IN warehouse_task_tab.location_group%TYPE )
IS
BEGIN
   IF (NOT Warehouse_Worker_Group_Loc_API.Check_Location_Group_Active(contract_, worker_group_, location_group_)) THEN
      Error_SYS.Record_General(lu_name_,'NOWRKGRPLOCGROUP: Worker Group :P1 is not allowed for Location Group :P2 on site :P3.',
                              worker_group_, location_group_, contract_);
   END IF;
END Validate_Group_In_Loc_Group___;


PROCEDURE Validate_Start_Allow___ (
   rec_  IN OUT NOCOPY warehouse_task_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   dummy_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM warehouse_task_tab
      WHERE contract  = rec_.contract
      AND   rowstate  = 'Started'
      AND   worker_id = rec_.worker_id; 
BEGIN
  OPEN  exist_control;
  FETCH exist_control INTO dummy_;
  IF (exist_control%FOUND) THEN
     CLOSE exist_control;
     Error_SYS.Record_General('WarehouseTask','STARTEDSTARTERR: Warehouse task :P1 has already been started by the user :P2.', rec_.task_id, rec_.worker_id);
  END IF;
  CLOSE exist_control;  
END Validate_Start_Allow___; 

   
FUNCTION Released___ (
   rec_ IN warehouse_task_tab%ROWTYPE ) RETURN BOOLEAN
IS
   start_in_status_    VARCHAR2(50);
   start_in_status_db_ VARCHAR2(50);
BEGIN
   start_in_status_    := Warehouse_Task_Type_Setup_API.Get_Start_In_Status(rec_.contract, Warehouse_Task_Type_API.Decode(rec_.task_type));
   start_in_status_db_ := Task_Setup_Start_Status_API.Encode(start_in_status_);

   IF start_in_status_db_ = 'RELEASED' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Released___;


FUNCTION Assigned_To_Worker___ (
   rec_ IN warehouse_task_tab%ROWTYPE ) RETURN BOOLEAN
IS
   temp_ VARCHAR2(20);
   CURSOR get_worker IS
      SELECT worker_id
      FROM warehouse_task_tab
      WHERE task_id = rec_.task_id;
BEGIN
   OPEN get_worker;
   FETCH get_worker INTO temp_;
   CLOSE get_worker;

   IF temp_ IS NOT NULL THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Assigned_To_Worker___;


PROCEDURE Do_Release___ (
   rec_  IN OUT warehouse_task_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   NULL;
END Do_Release___;


PROCEDURE Do_Park___ (
   rec_  IN OUT NOCOPY warehouse_task_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS   
BEGIN
   NULL;
END Do_Park___;


PROCEDURE Do_Cancel___ (
   rec_  IN OUT warehouse_task_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_ warehouse_task_tab%ROWTYPE;
   newrec_ warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                     := Lock_By_Keys___(rec_.task_id);
   newrec_                     := oldrec_;
   newrec_.worker_id           := NULL;
   newrec_.actual_date_started := NULL;
   newrec_.assigned_priority   := NULL;
   Modify___(newrec_);
   Client_SYS.Add_To_Attr('WORKER_ID', newrec_.worker_id, attr_);
   Client_SYS.Add_To_Attr('ACTUAL_DATE_STARTED', newrec_.actual_date_started, attr_);
   Client_SYS.Add_To_Attr('ASSIGNED_PRIORITY', newrec_.assigned_priority, attr_);
END Do_Cancel___;


PROCEDURE Do_Plan___ (
   rec_  IN OUT warehouse_task_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_     warehouse_task_tab%ROWTYPE;
   newrec_     warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                     := Lock_By_Keys___(rec_.task_id);
   newrec_                     := oldrec_;
   newrec_.worker_id           := NULL;
   newrec_.actual_date_started := NULL;
   Modify___(newrec_);
   Client_SYS.Add_To_Attr('WORKER_ID', newrec_.worker_id, attr_);
   Client_SYS.Add_To_Attr('ACTUAL_DATE_STARTED', newrec_.actual_date_started, attr_);
END Do_Plan___;


PROCEDURE Do_Start___ (
   rec_  IN OUT warehouse_task_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_ warehouse_task_tab%ROWTYPE;
   newrec_ warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                     := Lock_By_Keys___(rec_.task_id);
   newrec_                     := oldrec_;
   newrec_.actual_date_started := Site_API.Get_Site_Date(rec_.contract);
   Check_Start_Warehouse_Task___(newrec_);
   Modify___(newrec_);
   Client_SYS.Add_To_Attr('ACTUAL_DATE_STARTED', newrec_.actual_date_started, attr_);
END Do_Start___;


PROCEDURE Do_Release_From_Started___ (
   rec_  IN OUT warehouse_task_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_ warehouse_task_tab%ROWTYPE;
   newrec_ warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                     := Lock_By_Keys___(rec_.task_id);
   newrec_                     := oldrec_;
   newrec_.worker_id           := NULL;
   newrec_.actual_date_started := NULL;
   Modify___(newrec_);
   Client_SYS.Add_To_Attr('WORKER_ID', newrec_.worker_id, attr_);
   Client_SYS.Add_To_Attr('ACTUAL_DATE_STARTED', newrec_.actual_date_started, attr_);
END Do_Release_From_Started___;


PROCEDURE Do_Close___ (
   rec_  IN OUT warehouse_task_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   oldrec_ warehouse_task_tab%ROWTYPE;
   newrec_ warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                      := Lock_By_Keys___(rec_.task_id);
   newrec_                      := oldrec_;
   newrec_.actual_date_finished := Site_API.Get_Site_Date(rec_.contract);
   Modify___(newrec_);
   Client_SYS.Add_To_Attr('ACTUAL_DATE_FINISHED', newrec_.actual_date_finished, attr_);
END Do_Close___;


FUNCTION Get_Next_Assigned_Priority___ (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_next_seq IS
      SELECT NVL(MAX(assigned_priority),0) + 1
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   worker_id = worker_id_;
   next_seq_ NUMBER;
BEGIN
   OPEN get_next_seq;
   FETCH get_next_seq INTO next_seq_;
   CLOSE get_next_seq;
   RETURN next_seq_;
END Get_Next_Assigned_Priority___;

   
PROCEDURE Do_Restart___ (
   rec_  IN OUT warehouse_task_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Check_Start_Warehouse_Task___(rec_);
END Do_Restart___;


PROCEDURE Check_Start_Warehouse_Task___ (
   rec_ IN warehouse_task_tab%ROWTYPE)
IS   
BEGIN
   IF (rec_.task_type = Warehouse_Task_Type_API.DB_TRANSPORT_TASK) THEN
      Transport_Task_API.Check_Start_Warehouse_Task(rec_.source_ref1);
   ELSIF (rec_.task_type = Warehouse_Task_Type_API.DB_CUSTOMER_ORDER_PICK_LIST) THEN
      $IF Component_Order_SYS.INSTALLED $THEN                   
         Pick_Customer_Order_API.Check_Start_Warehouse_Task(rec_.source_ref1);
      $ELSE
         NULL;
      $END
   ELSIF (rec_.task_type = Warehouse_Task_Type_API.DB_SHOP_ORDER_PICK_LIST) THEN
      $IF Component_Shpord_SYS.INSTALLED $THEN 
         Shop_Material_Pick_Util_API.Check_Start_Warehouse_Task(rec_.source_ref1, rec_.contract);
      $ELSE
         NULL;
      $END
   ELSE
      Error_SYS.Record_General(lu_name_, 'INVALIDTASKTYPE: Warehouse Task Type :P1 is not handled by Check_Start_Warehouse_Task___. Contact system support.', 
                               Warehouse_Task_Type_API.Decode(rec_.task_type));
   END IF;
END Check_Start_Warehouse_Task___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT warehouse_task_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT warehouse_task_id.NEXTVAL INTO newrec_.task_id FROM DUAL;
   Client_SYS.Add_To_Attr('TASK_ID', newrec_.task_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     warehouse_task_tab%ROWTYPE,
   newrec_     IN OUT warehouse_task_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   info_temp_  VARCHAR2(2000);
   objid_temp_ WAREHOUSE_TASK.objid%TYPE;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.rowstate = 'Planned' AND ((newrec_.worker_id IS NOT NULL AND newrec_.worker_id != NVL(oldrec_.worker_id, database_SYS.string_null_)) OR 
       (newrec_.worker_group IS NOT NULL AND newrec_.worker_group != NVL(oldrec_.worker_group, database_SYS.string_null_)))) THEN
      Get_Id_Version_By_Keys___(objid_temp_, objversion_, newrec_.task_id);
      Release__(info_temp_, objid_temp_, objversion_, attr_, 'DO' );
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     warehouse_task_tab%ROWTYPE,
   newrec_ IN OUT warehouse_task_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.rowstate IN ('Closed', 'Cancelled') THEN
      Error_SYS.Record_General('WarehouseTask', 'NOTALLOWUPDATE: A Warehouse task in status Closed or Canceled cannot be updated.');
   END IF;
   IF (newrec_.assigned_priority != ROUND(newrec_.assigned_priority) OR newrec_.assigned_priority <= 0) THEN
      Error_SYS.Record_General(lu_name_,'INAVLIDASSIGNEDPRIORITY: The Operative Priority must be a positive integer.');   
   END IF;
   -- Validating basic validations before proceed for additional validations.
   super(oldrec_, newrec_, indrec_, attr_);
   
   -- If worker is defined
   IF (newrec_.worker_id IS NOT NULL) THEN
      IF (Validate_SYS.Is_Different(oldrec_.worker_id, newrec_.worker_id)) THEN
         Validate_Warehouse_Worker___(newrec_);
      ELSE
         IF (Validate_SYS.Is_Different(oldrec_.location_group, newrec_.location_group)) THEN
            Validate_Worker_Loc_Group___(newrec_.contract, newrec_.worker_id, newrec_.location_group);
         END IF;
      END IF;
   END IF;
      
   -- If Worker Group is defined
   IF (newrec_.worker_group IS NOT NULL) THEN
      IF (Validate_SYS.Is_Different(oldrec_.worker_group, newrec_.worker_group)) THEN
         Validate_Worker_Group___(newrec_);
      ELSE
         IF (Validate_SYS.Is_Different(oldrec_.location_group, newrec_.location_group)) THEN
            Validate_Group_In_Loc_Group___(newrec_.contract, newrec_.worker_id, newrec_.location_group);
         END IF;
      END IF;
   END IF;
END Check_Common___;   

   
PROCEDURE Check_To_Location_Group___ (
   transport_task_id_ IN NUMBER,
   worker_id_         IN VARCHAR2,
   worker_group_      IN VARCHAR2 )
IS
BEGIN
   IF (worker_id_ IS NULL) THEN
      IF (worker_group_ IS NOT NULL) THEN
         IF NOT (Workr_Grp_Is_To_Loc_Grp_Active(transport_task_id_, worker_group_)) THEN
            Error_SYS.Record_General(lu_name_,'INVALIDWAREHOUSEGRPTASK: Warehouse worker group :P1 is not activated for all location groups involved in transport task :P2 on Site :P3.',
                                     worker_group_, transport_task_id_, Transport_Task_API.Get_To_Contract(transport_task_id_));
         END IF;
         IF NOT (Wrkr_Grp_Is_Allowed_For_Wrkrs(transport_task_id_, worker_group_)) THEN
            Error_SYS.Record_General(lu_name_,'INVALIDWAREHOUSEWORKER: No warehouse worker in warehouse worker group :P1 is activated for all location groups involved in transport task :P2 on Site :P3.',
                                     worker_group_, transport_task_id_, Transport_Task_API.Get_To_Contract(transport_task_id_));
         END IF;
      END IF;
   ELSE
      IF NOT (Worker_Is_To_Loc_Group_Active(transport_task_id_, worker_id_)) THEN
         Error_SYS.Record_General(lu_name_,'INVALIDLOCGROUP: Warehouse worker :P1 is not activated for all location groups involved in transport task :P2 on Site :P3.',
                                  worker_id_, transport_task_id_, Transport_Task_API.Get_To_Contract(transport_task_id_));
      END IF;
   END IF;
END Check_To_Location_Group___;


@UncheckedAccess
FUNCTION Transport_Task___ (
   task_type_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   transport_task_ BOOLEAN := FALSE;
BEGIN
   IF (task_type_db_ = Warehouse_Task_Type_API.DB_TRANSPORT_TASK) THEN
      transport_task_ := TRUE;
   END IF;
   RETURN(transport_task_);
END Transport_Task___;


PROCEDURE Check_Transport_To_Contract___ (
   transport_task_id_ IN NUMBER,
   worker_id_         IN VARCHAR2,
   worker_group_      IN VARCHAR2,
   task_type_db_      IN VARCHAR2 )
IS
   to_contract_ transport_task_line_tab.to_contract%TYPE;
BEGIN
   to_contract_ := Transport_Task_API.Get_To_Contract(transport_task_id_);

   IF (worker_id_ IS NOT NULL) THEN
      IF (NOT Worker_Is_To_Contract_Active(transport_task_id_, worker_id_, task_type_db_)) THEN
         Error_SYS.Record_General(lu_name_,'INVALIDTASKTYPE1: Warehouse worker :P1 is not allowed to perform warehouse task type :P2 on site :P3.',
                                  worker_id_, Warehouse_Task_Type_API.Decode(task_type_db_), to_contract_);
      END IF;
   ELSIF (worker_group_ IS NOT NULL) THEN
      IF (NOT Workr_Grp_Is_To_Site_Active(transport_task_id_, worker_group_, task_type_db_)) THEN
         Error_SYS.Record_General(lu_name_,'INVALIDTASKTYPE2: Warehouse worker group :P1 is not allowed to perform warehouse task type :P2 on site :P3.',
                                  worker_group_, Warehouse_Task_Type_API.Decode(task_type_db_), to_contract_);
      END IF;
   END IF;
END Check_Transport_To_Contract___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calc_Act_Task_Type_Eff_Rate__
--   This method executes the Batch.
PROCEDURE Calc_Act_Task_Type_Eff_Rate__ (
   attrib_ IN VARCHAR2 )
IS
   contract_           warehouse_task_tab.contract%TYPE;
   worker_id_          warehouse_task_tab.worker_id%TYPE;
   task_type_db_       VARCHAR2(50);
   from_date_          DATE;
   to_date_            DATE;
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   actual_time_needed_ NUMBER;

   CURSOR Get_Eff_Rate IS
      SELECT worker_id, task_type, SUM(number_of_lines) lines, SUM((actual_date_finished - actual_date_started) * 1440)  work_time
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   rowstate  = 'Closed'
      AND   task_type = NVL(task_type_db_, task_type)
      AND   worker_id = NVL(worker_id_, worker_id)
      AND   TRUNC(actual_date_finished) BETWEEN from_date_ AND to_date_
      GROUP BY worker_id, task_type;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'WORKER_ID') THEN
         worker_id_ := value_;
      ELSIF (name_ = 'TASK_TYPE_DB') THEN
         task_type_db_ := value_;
      ELSIF (name_ = 'FROM_DATE') THEN
         from_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   FOR  rec_ IN Get_Eff_Rate LOOP
      IF Warehouse_Worker_Task_Type_API.Check_Exist(contract_, rec_.worker_id, rec_.task_type) THEN
         actual_time_needed_ := (rec_.work_time/rec_.lines);
         Warehouse_Worker_Task_Type_API.Modify_Actual_Time_Needed(contract_,
                                                                  rec_.worker_id,
                                                                  rec_.task_type,
                                                                  actual_time_needed_);
      END IF;
   END LOOP;
END Calc_Act_Task_Type_Eff_Rate__;


-- Calc_Act_Task_Type_Time_Shar__
--   This method executes the Batch.
PROCEDURE Calc_Act_Task_Type_Time_Shar__ (
   attrib_ IN VARCHAR2 )
IS
   TYPE tmp_columns_ IS RECORD (
      tmp_task_type_db_ warehouse_task_tab.task_type%TYPE,
      tmp_work_time_    NUMBER);

   TYPE tmp_tab IS TABLE OF tmp_columns_
      INDEX BY BINARY_INTEGER;

   tmp_rec_           tmp_tab;
   contract_          warehouse_task_tab.contract%TYPE;
   worker_id_         warehouse_task_tab.worker_id%TYPE;
   from_date_         DATE;
   to_date_           DATE;
   grand_total_time_  NUMBER;
   i_                 NUMBER;
   i_max_             NUMBER;
   current_worker_id_ warehouse_task_tab.worker_id%TYPE;
   first_time_        BOOLEAN;
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);
   
   CURSOR Get_Sum_Time IS
      SELECT worker_id, task_type, SUM((actual_date_finished - actual_date_started) * 1440)  work_time
      FROM warehouse_task_tab
      WHERE contract = contract_
      AND   rowstate = 'Closed'
      AND   worker_id = NVL(worker_id_,worker_id)
      AND   TRUNC(actual_date_finished) BETWEEN from_date_ AND to_date_
      GROUP BY worker_id, task_type;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'WORKER_ID') THEN
         worker_id_ := value_;
      ELSIF (name_ = 'FROM_DATE') THEN
         from_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   first_time_       := TRUE;
   grand_total_time_ := 0;
   i_                := 0;
   FOR  rec_ IN Get_Sum_Time LOOP
      IF (first_time_) THEN
         current_worker_id_ := rec_.worker_id;
         first_time_        := FALSE;
      END IF;
      IF (rec_.worker_id != current_worker_id_) THEN
         i_ := 0;
         LOOP
            IF (i_ = i_max_) THEN
               EXIT;
            END IF;
            Warehouse_Worker_Task_Type_API.Modify_Actual_Time_Share(contract_,
                                                                    current_worker_id_,
                                                                    tmp_rec_(i_).tmp_task_type_db_,
                                                                    tmp_rec_(i_).tmp_work_time_ / grand_total_time_);
            tmp_rec_(i_).tmp_task_type_db_ := NULL;
            tmp_rec_(i_).tmp_work_time_    := NULL;
            i_                             := i_ + 1;
         END LOOP;
         i_                 := 0;
         grand_total_time_  := 0;
         current_worker_id_ := rec_.worker_id;
      END IF;
      IF Warehouse_Worker_Task_Type_API.Check_Exist(contract_,current_worker_id_, rec_.task_type) THEN
         grand_total_time_              := grand_total_time_ + rec_.work_time;
         -- Put the task_type_db_ and the rec_.work_time_ in one row in the internal table.
         tmp_rec_(i_).tmp_task_type_db_ := rec_.task_type;
         tmp_rec_(i_).tmp_work_time_    := rec_.work_time;
         i_                             := i_ + 1;
         i_max_                         := i_;
      END IF;
   END LOOP;
   i_ := 0;
   LOOP
      IF (i_ = i_max_) THEN
        EXIT;
      END IF;
      Warehouse_Worker_Task_Type_API.Modify_Actual_Time_Share(contract_,
                                            current_worker_id_,
                                            tmp_rec_(i_).tmp_task_type_db_,
                                            tmp_rec_(i_).tmp_work_time_ / grand_total_time_);
      i_ := i_ + 1;
   END LOOP;
END Calc_Act_Task_Type_Time_Shar__;


-- Calc_Act_Loc_Ta_Ty_Time_Shar__
--   This method executes the Batch.
PROCEDURE Calc_Act_Loc_Ta_Ty_Time_Shar__ (
   attrib_ IN VARCHAR2 )
IS
   TYPE tmp_columns_ IS RECORD (
      tmp_location_group_ warehouse_task_tab.location_group%TYPE,
      tmp_work_time_      NUMBER);

   TYPE tmp_tab IS TABLE OF tmp_columns_
      INDEX BY BINARY_INTEGER;

   tmp_rec_           tmp_tab;
   contract_          warehouse_task_tab.contract%TYPE;
   worker_id_         warehouse_task_tab.worker_id%TYPE;
   from_date_         DATE;
   to_date_           DATE;
   grand_total_time_  NUMBER;
   i_                 NUMBER;
   i_max_             NUMBER;
   current_worker_id_ warehouse_task_tab.worker_id%TYPE;
   first_time_        BOOLEAN;
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);

   CURSOR Get_Sum_Time IS
      SELECT worker_id, location_group, SUM((actual_date_finished - actual_date_started) * 1440)  work_time
      FROM warehouse_task_tab
      WHERE contract = contract_
      AND rowstate   = 'Closed'
      AND worker_id  = NVL(worker_id_,worker_id)
      AND TRUNC(actual_date_finished) BETWEEN from_date_ AND to_date_
      GROUP BY worker_id, location_group;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'WORKER_ID') THEN
         worker_id_ := value_;
      ELSIF (name_ = 'FROM_DATE') THEN
         from_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   first_time_       := TRUE;
   grand_total_time_ := 0;
   i_                := 0;
   FOR rec_ IN Get_Sum_Time LOOP
      IF (first_time_) THEN
         current_worker_id_ := rec_.worker_id;
         first_time_        := FALSE;
      END IF;
      IF (rec_.worker_id != current_worker_id_) THEN
         i_ := 0;
         LOOP
            IF (i_ = i_max_) THEN
               EXIT;
            END IF;
            Warehouse_Worker_Loc_Group_API.Modify_Actual_Time_Share(contract_,
                                                  current_worker_id_,
                                                  tmp_rec_(i_).tmp_location_group_,
                                                  tmp_rec_(i_).tmp_work_time_ / grand_total_time_);
            tmp_rec_(i_).tmp_location_group_ := NULL;
            tmp_rec_(i_).tmp_work_time_      := NULL;
            i_                               := i_ + 1;
         END LOOP;
         i_                 := 0;
         grand_total_time_  := 0;
         current_worker_id_ := rec_.worker_id;
      END IF;
      IF Warehouse_Worker_Loc_Group_API.Check_Exist(contract_,current_worker_id_, rec_.location_group) THEN
         grand_total_time_                := grand_total_time_ + rec_.work_time;
         tmp_rec_(i_).tmp_location_group_ := rec_.location_group;
         tmp_rec_(i_).tmp_work_time_      := rec_.work_time;
         i_                               := i_ + 1;
         i_max_                           := i_;
      END IF;
   END LOOP;
   i_ := 0;
   LOOP
      IF (i_ = i_max_) THEN
         EXIT;
      END IF;
      Warehouse_Worker_Loc_Group_API.Modify_Actual_Time_Share(contract_,
                                                              current_worker_id_,
                                                              tmp_rec_(i_).tmp_location_group_,
                                                              tmp_rec_(i_).tmp_work_time_ / grand_total_time_);
      i_ := i_ + 1;
   END LOOP;
END Calc_Act_Loc_Ta_Ty_Time_Shar__;


-- Calc_Act_Setup_Time_Needed__
--   This method executes the Batch.
PROCEDURE Calc_Act_Setup_Time_Needed__ (
   attrib_ IN VARCHAR2 )
IS
   contract_           warehouse_task_tab.contract%TYPE;
   task_type_db_       VARCHAR2(50);
   from_date_          DATE;
   to_date_            DATE;
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   actual_time_needed_ NUMBER;

   CURSOR Get_Default_Time_Needed IS
      SELECT task_type, Sum(number_of_lines) lines, Sum((actual_date_finished - actual_date_started) * 1440)  work_time
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   rowstate  = 'Closed'
      AND   task_type = NVL(task_type_db_, task_type)
      AND   TRUNC(actual_date_finished) BETWEEN from_date_ AND to_date_
      GROUP BY task_type;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'TASK_TYPE_DB') THEN
         task_type_db_ := value_;
      ELSIF (name_ = 'FROM_DATE') THEN
         from_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;

   FOR rec_ IN Get_Default_Time_Needed LOOP
      actual_time_needed_ := (rec_.work_time/rec_.lines);
      Warehouse_Task_Type_Setup_API.Modify_Actual_Time_Needed(contract_,
                                                              rec_.task_type,
                                                              actual_time_needed_);
   END LOOP;
END Calc_Act_Setup_Time_Needed__;


PROCEDURE Validate_Worker_Start_Allow__ (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 )
IS
   dummy_ NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   rowstate  = 'Started'
      AND   worker_id = worker_id_;
BEGIN
   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General('WarehouseTask','WORKERSTARTERR: Worker :P1 already has a warehouse task started and is not permitted to start another task.', worker_id_);
   END IF;
   CLOSE exist_control;
END Validate_Worker_Start_Allow__;


PROCEDURE Assign_Tasks_To_Worker__ (
   task_list_ IN VARCHAR2,
   worker_id_ IN VARCHAR2 )
IS
   to_                            NUMBER;
   from_                          NUMBER;
   task_id_tmp_                   NUMBER;

   TYPE Task_Id_Tab IS TABLE OF warehouse_task_tab.task_id%TYPE INDEX BY PLS_INTEGER;

   temporally_parked_task_id_tab_ Task_Id_Tab;
   rec_                           warehouse_task_tab%ROWTYPE;
   started_task_                  warehouse_task_tab.task_id%TYPE;
   info_                          VARCHAR2(2000);
   objid_                         WAREHOUSE_TASK.objid%TYPE;
   objversion_                    WAREHOUSE_TASK.objversion%TYPE;
   attr_                          VARCHAR2(2000);
BEGIN
   from_ := 1;
   to_   := INSTR(task_list_, Client_SYS.field_separator_);
   WHILE (to_ > 0) LOOP
      task_id_tmp_ := Client_SYS.Attr_Value_To_Number(SUBSTR(task_list_, from_, to_ - from_));
      from_        := to_ + 1;
      to_          := INSTR(task_list_, Client_SYS.field_separator_, from_);

      rec_         := Get_Object_By_Keys___(task_id_tmp_);
      IF (rec_.rowstate = 'Parked') THEN
         -- IF there is a started task for the same worker, park it temporally.
         started_task_ := Get_Started_Task_Id(rec_.contract, rec_.worker_id);
         IF (started_task_ IS NOT NULL) THEN
            Get_Id_Version_By_Keys___(objid_, objversion_, started_task_);
            Client_SYS.Clear_Attr(attr_);
            Park__(info_, objid_, objversion_, attr_, 'DO');

            temporally_parked_task_id_tab_(temporally_parked_task_id_tab_.COUNT + 1) := started_task_;
         END IF;

         Get_Id_Version_By_Keys___(objid_, objversion_, task_id_tmp_);
         Client_SYS.Clear_Attr(attr_);
         Restart__(info_, objid_, objversion_, attr_, 'DO');
         Client_SYS.Clear_Attr(attr_);
         Plan__(info_, objid_, objversion_, attr_, 'DO');
      END IF;

      Modify_Worker(task_id_tmp_, worker_id_);
   END LOOP;

   -- Restart the tasks which were temporally parked.
   IF (temporally_parked_task_id_tab_.COUNT > 0) THEN
      FOR i IN temporally_parked_task_id_tab_.FIRST .. temporally_parked_task_id_tab_.LAST LOOP
         Get_Id_Version_By_Keys___(objid_, objversion_, temporally_parked_task_id_tab_(i));
         Client_SYS.Clear_Attr(attr_);
         Restart__(info_, objid_, objversion_, attr_, 'DO');
      END LOOP;
   END IF;
END Assign_Tasks_To_Worker__;


@Override
PROCEDURE Restart__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ warehouse_task_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Id___(objid_);
   Validate_Worker_Start_Allow__(rec_.contract, rec_.worker_id);
   super(info_, objid_, objversion_, attr_, action_); 
   IF (action_ = 'DO') AND (rec_.park_reason_id IS NOT NULL) THEN
      Modify_Park_Reason_Id(rec_.task_id, NULL);
   END IF;
END Restart__;


PROCEDURE Assign_Tasks_To_Worker_Group__ (
   task_list_    IN VARCHAR2,
   worker_group_ IN VARCHAR2 )
IS
   to_          NUMBER;
   from_        NUMBER;
   task_id_tmp_ NUMBER;
   oldrec_      warehouse_task_tab%ROWTYPE;
   newrec_      warehouse_task_tab%ROWTYPE;
BEGIN
   from_ := 1;
   to_   := INSTR(task_list_, Client_SYS.field_separator_);
   WHILE (to_ > 0) LOOP
      task_id_tmp_         := Client_SYS.Attr_Value_To_Number(SUBSTR(task_list_, from_, to_ - from_));
      from_                := to_ + 1;
      to_                  := INSTR(task_list_, Client_SYS.field_separator_, from_);
   
      oldrec_              := Lock_By_Keys___(task_id_tmp_);
      newrec_              := oldrec_;
      newrec_.worker_group := worker_group_;
      Modify___(newrec_);
   END LOOP;   
END Assign_Tasks_To_Worker_Group__;    

   
PROCEDURE Complete_Started_Tasks__ (
   contract_    IN VARCHAR2,
   worker_list_ IN VARCHAR2 )
IS
   to_            NUMBER;
   from_          NUMBER;
   worker_id_tmp_ VARCHAR2(20);

   task_id_       warehouse_task_tab.task_id%TYPE;
   task_type_     warehouse_task_tab.task_type%TYPE;
   source_ref1_   warehouse_task_tab.source_ref1%TYPE;

   CURSOR get_attr IS
      SELECT task_id, task_type, source_ref1
      FROM warehouse_task_tab
      WHERE worker_id = worker_id_tmp_
      AND   contract  = contract_
      AND   rowstate  = 'Started';
BEGIN
   from_ := 1;
   to_   := INSTR(worker_list_, Client_SYS.field_separator_);
   WHILE (to_ > 0) LOOP
      worker_id_tmp_ := SUBSTR(worker_list_, from_, to_ - from_);
      from_          := to_ + 1;
      to_            := INSTR(worker_list_, Client_SYS.field_separator_, from_);
   
      OPEN  get_attr;
      FETCH get_attr INTO task_id_, task_type_, source_ref1_;
      CLOSE get_attr;
      
      IF (task_type_ = 'TRANSPORT TASK') THEN
         -- Execute the transport task.
         Transport_Task_API.Execute_All(source_ref1_);
      ELSIF (task_type_ = 'SHOP ORDER PICK LIST') THEN
         -- Execute the shop order pick list task.
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            Shop_Material_Pick_Util_API.Report_Pick_List(source_ref1_);
         $ELSE
            NULL;
         $END 
      ELSE
          -- Execute the customer order pick list task.
         $IF (Component_Order_SYS.INSTALLED) $THEN
            Pick_Customer_Order_API.Pick_Report_From_Wharehouse(source_ref1_, contract_);
         $ELSE
            NULL;
         $END 
      END IF;  
   END LOOP;    
END Complete_Started_Tasks__;    

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Started_Task_Exist
--   Returns 1 if the worker has a started task,
--   otherwise 0.
@UncheckedAccess
FUNCTION Started_Task_Exist (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ number;

   CURSOR exist_control IS
      SELECT 1
      FROM warehouse_task_tab
      WHERE contract = contract_
      AND   worker_id = worker_id_
      AND   rowstate = 'Started';
BEGIN
   OPEN  exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Started_Task_Exist;


-- Ready_To_Start_Task_Exist
--   Returns 1 if the worker has a tasks which can be started.
--   otherwise 0.
@UncheckedAccess
FUNCTION Ready_To_Start_Task_Exist (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ number;

   CURSOR exist_control IS
      SELECT 1
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   worker_id = worker_id_
      AND   rowstate  = 'Released';

   CURSOR exist_worker_group IS
      SELECT 1
      FROM warehouse_task_tab
      WHERE worker_id IS NULL
      AND   contract = contract_
      AND   rowstate = 'Released'
      AND   worker_group IN (SELECT worker_group
                             FROM WAREHOUSE_WORKER_TAB
                             WHERE worker_id = worker_id_);
BEGIN
   OPEN  exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   
   IF (found_ = 0) THEN
      OPEN  exist_worker_group;
      FETCH exist_worker_group INTO found_;
      IF (exist_worker_group%NOTFOUND) THEN
         found_ := 0;
      END IF;
      CLOSE exist_worker_group;
   END IF;   
   RETURN found_;
END Ready_To_Start_Task_Exist;


-- New
--   Public method that other modules should call when they create new picklists.
PROCEDURE New (
   task_id_                 OUT NUMBER,
   task_type_               IN  VARCHAR2,
   priority_                IN  NUMBER,
   source_ref1_             IN  VARCHAR2,
   source_ref2_             IN  VARCHAR2,
   source_ref3_             IN  VARCHAR2,
   source_ref4_             IN  VARCHAR2,
   number_of_lines_         IN  NUMBER,
   location_group_          IN  VARCHAR2,
   contract_                IN  VARCHAR2,
   requested_date_finished_ IN  DATE,
   info_                    IN  VARCHAR2,
   worker_id_               IN  VARCHAR2 )
IS
   status_                       VARCHAR2(50);
   setup_status_db_              VARCHAR2(50);
   planned_time_needed_          NUMBER;
   now_                          DATE;
   priority_temp_                NUMBER;
   requested_date_finished_temp_ DATE;
   newrec_                       warehouse_task_tab%ROWTYPE;
BEGIN
   Trace_SYS.Message('NEW');
   status_          := Warehouse_Task_Type_Setup_API.Get_Status(contract_, task_type_);
   setup_status_db_ := Task_Setup_Status_API.Encode(status_);
   IF setup_status_db_ = ('ACTIVE') THEN
      IF requested_date_finished_ IS NOT NULL THEN
         requested_date_finished_temp_ := requested_date_finished_;
      ELSE
         now_                          := Site_API.Get_Site_Date(contract_);
         requested_date_finished_temp_ := now_ + (Warehouse_Task_Type_Setup_API.Get_Default_Requested_Leadtime(contract_, task_type_)/1440);
      END IF;

      IF priority_ IS NOT NULL THEN
         priority_temp_ := priority_;
      ELSE
         priority_temp_ := Warehouse_Task_Type_Setup_API.Get_Priority(contract_, task_type_);
      END IF;

      planned_time_needed_ := Warehouse_Task_Type_Setup_API.Get_Default_Time_Needed(contract_, task_type_);

      newrec_.priority                := priority_temp_;
      newrec_.source_ref1             := source_ref1_;
      newrec_.source_ref2             := source_ref2_;
      newrec_.source_ref3             := source_ref3_;
      newrec_.source_ref4             := source_ref4_;
      newrec_.info                    := info_;
      newrec_.number_of_lines         := number_of_lines_;
      newrec_.requested_date_finished := requested_date_finished_temp_;
      newrec_.planned_time_needed     := planned_time_needed_;
      newrec_.contract                := contract_;
      newrec_.task_type               := Warehouse_Task_Type_API.Encode(task_type_);
      newrec_.location_group          := location_group_;
      newrec_.worker_id               := worker_id_;
      New___(newrec_);

      task_id_ := newrec_.task_id;
      Client_SYS.Merge_Info(Client_SYS.Get_All_Info);
   END IF;
END New;


-- Start_Task
--   This method Starts a warehouse task.
PROCEDURE Start_Task (
   task_id_   IN NUMBER,
   worker_id_ IN VARCHAR2 DEFAULT NULL)
IS
   oldrec_ warehouse_task_tab%ROWTYPE;
   newrec_ warehouse_task_tab%ROWTYPE;
   attr_   VARCHAR2(2000);
   rec_    warehouse_task_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(task_id_);

   -- When worker_id is specified, task should be updated with worker_id before start the task.
   -- Otherwise mean worker is already exist and should be validated before start the task.
   IF (worker_id_ IS NOT NULL) THEN
      oldrec_ := Lock_By_Keys___(task_id_);
      newrec_ := oldrec_;
      IF (newrec_.rowstate = 'Released' AND worker_id_ != NVL(newrec_.worker_id, worker_id_)) THEN
         Error_SYS.Record_General('WarehouseTask','WORKERASSIGERR: Warehouse task :P1 has already been assigned to the worker :P2.', task_id_, newrec_.worker_id);
      END IF;
      Validate_Worker_Start_Allow__(newrec_.contract, worker_id_);
      newrec_.worker_id := worker_id_;
      Modify___(newrec_);
   ELSE
      Validate_Worker_Start_Allow__(rec_.contract, rec_.worker_id);
   END IF;

   -- Start the task.
   Finite_State_Machine___(rec_, 'Start', attr_);
   IF (rec_.park_reason_id IS NOT NULL) THEN
      Modify_Park_Reason_Id(rec_.task_id, NULL);
   END IF;
END Start_Task;


-- Park_Task
--   This method Parks a warehouse task.
PROCEDURE Park_Task (
   task_id_        IN NUMBER,
   park_reason_id_ IN VARCHAR2 DEFAULT NULL)
IS
   attr_ VARCHAR2(2000);
   rec_  warehouse_task_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(task_id_);
   -- Park the task.
   Finite_State_Machine___(rec_, 'Park', attr_);

   -- When the park reason is given, task should be updated with park_reason_id .
   IF (park_reason_id_ IS NOT NULL) THEN
      Modify_Park_Reason_Id(task_id_, park_reason_id_);
   END IF;
END Park_Task;

   
PROCEDURE Modify_Worker (
   task_id_   IN NUMBER,
   worker_id_ IN VARCHAR2 )
IS
   oldrec_ warehouse_task_tab%ROWTYPE;
   newrec_ warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_           := Lock_By_Keys___(task_id_);
   newrec_           := oldrec_;
   newrec_.worker_id := worker_id_;
   IF (Validate_SYS.Is_Different(oldrec_.worker_id, newrec_.worker_id)) THEN
      IF (newrec_.rowstate = 'Started' OR newrec_.rowstate = 'Parked') THEN
         Error_SYS.Record_General('WarehouseTask', 'WORKERCHANGEERR: Worker cannot be changed when a warehouse task is in status Started or Parked.');
      END IF;
   END IF;
   Modify___(newrec_);
END Modify_Worker;


-- Modify_Number_Of_Lines_Source
--   This method will be the entry when updating number of lines.
PROCEDURE Modify_Number_Of_Lines_Source (
   contract_        IN VARCHAR2,
   task_type_       IN VARCHAR2,
   source_ref1_     IN VARCHAR2,
   source_ref2_     IN VARCHAR2,
   source_ref3_     IN VARCHAR2,
   source_ref4_     IN VARCHAR2,
   number_of_lines_ IN NUMBER )
IS
   task_id_         NUMBER;
   status_          VARCHAR2(50);
   setup_status_db_ VARCHAR2(50);
BEGIN
   status_          := Warehouse_Task_Type_Setup_API.Get_Status(contract_, task_type_);
   setup_status_db_ := Task_Setup_Status_API.Encode(status_);

   IF setup_status_db_ IN ('ACTIVE') THEN
      task_id_ := Get_Task_Id_From_Source(contract_,
                                          task_type_,
                                          source_ref1_,
                                          source_ref2_,
                                          source_ref3_,
                                          source_ref4_);
      IF (task_id_ IS NOT NULL) THEN
         Modify_Number_Of_Lines(task_id_,
                                number_of_lines_);
      END IF;
   END IF;
END Modify_Number_Of_Lines_Source;

   
PROCEDURE Modify_Park_Reason_Id (
   task_id_        IN NUMBER,
   park_reason_id_ IN VARCHAR2 )
IS
   oldrec_ warehouse_task_tab%ROWTYPE;
   newrec_ warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                := Lock_By_Keys___(task_id_);
   newrec_                := oldrec_;
   newrec_.park_reason_id := park_reason_id_;
   Modify___(newrec_);
END Modify_Park_Reason_Id;

PROCEDURE Modify_Location_Group(
   task_id_ IN NUMBER,
   location_group_   IN VARCHAR2 )
IS
   oldrec_     warehouse_task_tab%ROWTYPE;
   newrec_  warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                := Lock_By_Keys___(task_id_);
   newrec_                := oldrec_;
   newrec_.location_group := location_group_;
   Modify___(newrec_);
END Modify_Location_Group;

-- Find_And_Report_Task_Source
--   This method will be the entry when to find and report warehouse task.
PROCEDURE Find_And_Report_Task_Source (
   contract_    IN VARCHAR2,
   task_type_   IN VARCHAR2,
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2,
   source_ref3_ IN VARCHAR2,
   source_ref4_ IN VARCHAR2 )
IS
   task_id_ NUMBER;
BEGIN
   task_id_ := Get_Task_Id_From_Source(contract_,
                                       task_type_,
                                       source_ref1_,
                                       source_ref2_,
                                       source_ref3_,
                                       source_ref4_);
   IF (task_id_ IS NOT NULL) THEN
      Report_Task(task_id_);
   END IF;
END Find_And_Report_Task_Source;


-- Get_Actual_Time_Needed
--   Fucntion that gets the Actual time needed.
@UncheckedAccess
FUNCTION Get_Actual_Time_Needed (
   task_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_attr IS
      SELECT (actual_date_finished - actual_date_started) * 1440
      FROM warehouse_task_tab
      WHERE task_id = task_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Actual_Time_Needed;


-- Get_Expected_Date_Finished
--   Function that gets the expected date finished for a warehouse task.
@UncheckedAccess
FUNCTION Get_Expected_Date_Finished (
   task_id_ IN NUMBER ) RETURN DATE
IS
   temp_ DATE;
   CURSOR get_attr IS
      SELECT (actual_date_started + (planned_time_needed/1440) * number_of_lines)
      FROM warehouse_task_tab
      WHERE task_id = task_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Expected_Date_Finished;


-- Get_Latest_Date_Started
--   Function that gets the latest date started.
@UncheckedAccess
FUNCTION Get_Latest_Date_Started (
   task_id_ IN NUMBER ) RETURN DATE
IS
   temp_ DATE;
   CURSOR get_attr IS
      SELECT (requested_date_finished - (planned_time_needed/1440) * number_of_lines)
      FROM warehouse_task_tab
      WHERE task_id = task_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Latest_Date_Started;


-- Get_Avg_Task_Line_Time
--   Returns avg task line time.
@UncheckedAccess
FUNCTION Get_Avg_Task_Line_Time (
   contract_  IN VARCHAR2,
   from_date_ IN DATE,
   to_date_   IN DATE,
   task_type_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
  RETURN NULL;
END Get_Avg_Task_Line_Time;


-- Get_Task_Id_To_Start
--   Returns the task id to start.
@UncheckedAccess
FUNCTION Get_Task_Id_To_Start (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   task_id_ warehouse_task_tab.task_id%TYPE;

   CURSOR worker_assigned is
      SELECT task_id, task_type, location_group, source_ref1
      FROM warehouse_task_tab
      WHERE worker_id = worker_id_
      AND   contract  = contract_
      AND   rowstate  = 'Released'
      ORDER BY assigned_priority, priority, (requested_date_finished - (planned_time_needed/1440) * number_of_lines);

   CURSOR no_worker_assigned is
      SELECT task_id, task_type, location_group, source_ref1
      FROM warehouse_task_tab
      WHERE worker_id    is null
      AND   worker_group is null
      AND   contract     = contract_
      AND   rowstate     = 'Released'
      ORDER BY assigned_priority, priority, (requested_date_finished - (planned_time_needed/1440) * number_of_lines);

   CURSOR worker_group_tasks IS
      SELECT task_id, task_type, location_group, worker_group, source_ref1
      FROM warehouse_task_tab
      WHERE worker_id    is null
      AND   worker_group is not null
      AND   contract     = contract_
      AND   rowstate     = 'Released'
      AND   worker_group IN (SELECT worker_group
                             FROM WAREHOUSE_WORKER_TAB
                             WHERE worker_id = worker_id_)
      ORDER BY assigned_priority, priority, (requested_date_finished - (planned_time_needed/1440) * number_of_lines);   
BEGIN
   task_id_ := NULL;
   FOR rec_ IN worker_assigned LOOP
      IF Warehouse_Worker_Task_Type_API.Is_Active_Worker(contract_, worker_id_, rec_.task_type) AND
         Warehouse_Worker_Loc_Group_API.Is_Active_Worker(contract_, worker_id_, rec_.location_group) THEN
         IF (Transport_Task___(rec_.task_type)) THEN
            IF ((Worker_Is_To_Contract_Active(rec_.source_ref1, worker_id_, rec_.task_type) AND Worker_Is_To_Loc_Group_Active(rec_.source_ref1, worker_id_))) THEN
               task_id_ := rec_.task_id;
               EXIT;
            END IF;   
         ELSE
            task_id_ := rec_.task_id;
            EXIT;
         END IF;
      END IF;
   END LOOP;
   IF (task_id_ IS NULL) THEN
      FOR rec_ IN worker_group_tasks LOOP
         IF Warehouse_Worker_Task_Type_API.Is_Active_Worker(contract_, worker_id_, rec_.task_type) AND
            Warehouse_Worker_Loc_Group_API.Is_Active_Worker(contract_, worker_id_, rec_.location_group) THEN
            IF (Transport_Task___(rec_.task_type)) THEN
               IF (Workr_Grp_Is_To_Site_Active(rec_.source_ref1, rec_.worker_group, rec_.task_type) AND Workr_Grp_Is_To_Loc_Grp_Active(rec_.source_ref1, rec_.worker_group) AND
                   Wrkr_Grp_Is_Allowed_For_Wrkrs(rec_.source_ref1,  rec_.worker_group)) THEN
                  task_id_ := rec_.task_id;
                  EXIT;
               END IF;   
            ELSE
               task_id_ := rec_.task_id;
               EXIT;
            END IF;
         END IF;
      END LOOP;
   END IF;   
   IF (task_id_ IS NULL) THEN
      FOR rec_ IN no_worker_assigned LOOP
         IF Warehouse_Worker_Task_Type_API.Is_Active_Worker(contract_, worker_id_, rec_.task_type) AND
            Warehouse_Worker_Loc_Group_API.Is_Active_Worker(contract_, worker_id_, rec_.location_group) THEN
            IF (Transport_Task___(rec_.task_type)) THEN
               IF ((Worker_Is_To_Contract_Active(rec_.source_ref1, worker_id_, rec_.task_type) AND Worker_Is_To_Loc_Group_Active(rec_.source_ref1, worker_id_))) THEN
                  task_id_ := rec_.task_id;
                  EXIT;
               END IF;   
            ELSE
               task_id_ := rec_.task_id;
               EXIT;
            END IF;
         END IF;
      END LOOP;
   END IF;
   RETURN (task_id_);
END Get_Task_Id_To_Start;


-- Get_Task_Id_From_Source
--   This method returns the task id from source.
@UncheckedAccess
FUNCTION Get_Task_Id_From_Source (
   contract_    IN VARCHAR2,
   task_type_   IN VARCHAR2,
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2,
   source_ref3_ IN VARCHAR2,
   source_ref4_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_         NUMBER;
   task_type_db_ VARCHAR2(50);

   -- The NVL check is because Source_Ref2, Source_Ref3, Source_Ref4 can contain NULL.
   CURSOR get_id IS
      SELECT task_id
      FROM warehouse_task_tab
      WHERE NVL(source_ref4,CHR(1)) = NVL(source_ref4_,CHR(1))
      AND   NVL(source_ref3,CHR(1)) = NVL(source_ref3_,CHR(1))
      AND   NVL(source_ref2,CHR(1)) = NVL(source_ref2_,CHR(1))
      AND   contract                = contract_
      AND   task_type               = task_type_db_
      AND   source_ref1             = source_ref1_
      AND   rowstate NOT IN ('Closed', 'Cancelled');
BEGIN
   task_type_db_ := Warehouse_Task_Type_API.Encode(task_type_);

   OPEN get_id;
   FETCH get_id INTO temp_;
   CLOSE get_id;
   RETURN temp_;
END Get_Task_Id_From_Source;


-- Modify_Number_Of_Lines
--   This method will perform the update, number of lines for a warehouse task.
PROCEDURE Modify_Number_Of_Lines (
   task_id_         IN NUMBER,
   number_of_lines_ IN NUMBER )
IS
   oldrec_     warehouse_task_tab%ROWTYPE;
   newrec_     warehouse_task_tab%ROWTYPE;
BEGIN
   oldrec_                 := Lock_By_Keys___(task_id_);
   newrec_                 := oldrec_;
   newrec_.number_of_lines := number_of_lines_;
   Modify___(newrec_);
END Modify_Number_Of_Lines;


-- Report_Task
--   This method will perform the report of a warehouse task.
PROCEDURE Report_Task (
   task_id_ IN NUMBER )
IS
   rec_   warehouse_task_tab%ROWTYPE;
   event_ VARCHAR2(50);
   attr_  VARCHAR2(2000);
BEGIN
   rec_ := Get_Object_By_Keys___(task_id_);

   IF rec_.rowstate = 'Started' THEN
      Finite_State_Machine___(rec_, 'Close', attr_);
   ELSIF rec_.rowstate = 'Cancelled' THEN
      event_ := 'Cancel';
   ELSIF rec_.rowstate = 'Parked' THEN
      Error_SYS.Record_General(lu_name_,'REPNOTALLOW: Report picking of Warehouse Task :P1 is not allowed when it is in state :P2.', task_id_, Finite_State_Decode__(rec_.rowstate));
   ELSE
      Finite_State_Machine___(rec_, 'Cancel', attr_);
   END IF;
END Report_Task;


-- Get_Total_Planned_Time_Needed
--   Returns the total planned time needed.
@UncheckedAccess
FUNCTION Get_Total_Planned_Time_Needed (
   task_id_ IN NUMBER ) RETURN NUMBER
IS
   number_of_lines_     NUMBER;
   planned_time_needed_ NUMBER;
   temp_                NUMBER;
   CURSOR get_time IS
      SELECT number_of_lines, planned_time_needed
      FROM warehouse_task_tab
      WHERE task_id = task_id_;
BEGIN
   OPEN get_time;
   FETCH get_time INTO number_of_lines_, planned_time_needed_;
   CLOSE get_time;

   temp_ := (number_of_lines_ * planned_time_needed_);

   RETURN temp_;
END Get_Total_Planned_Time_Needed;


-- Find_And_Start_Task
--   Finds and starts a warehouse task.
PROCEDURE Find_And_Start_Task (
   task_id_    OUT NUMBER,
   contract_   IN  VARCHAR2,
   worker_id_  IN  VARCHAR2,
   print_task_ IN  NUMBER )
IS
BEGIN
   Validate_Worker_Start_Allow__(contract_, worker_id_);
   task_id_ := Get_Task_Id_To_Start(contract_, worker_id_);

   IF (task_id_ IS NOT NULL) THEN
      Start_Task(task_id_, worker_id_);
   ELSE
      Error_SYS.Record_General('WarehouseTask','NOFIND: There are no available warehouse tasks to start.');
   END IF;
END Find_And_Start_Task;


-- Execute_Started_Task
--   This method execute the started task for specified worker and contract.
PROCEDURE Execute_Started_Task (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 )
IS
   task_id_     warehouse_task_tab.task_id%TYPE;
   task_type_   warehouse_task_tab.task_type%TYPE;
   source_ref1_ warehouse_task_tab.source_ref1%TYPE;
   task_exist_  BOOLEAN := FALSE;   

   CURSOR get_attr IS
      SELECT task_id, task_type, source_ref1
      FROM warehouse_task_tab
      WHERE worker_id = worker_id_
      AND   contract  = contract_
      AND   rowstate  = 'Started';
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO task_id_, task_type_, source_ref1_;
   IF (get_attr%FOUND) THEN
      task_exist_ := TRUE;
   END IF;
   CLOSE get_attr;
   IF (task_exist_) THEN
      IF (task_type_ = 'TRANSPORT TASK') THEN
         -- Execute the transport task.
         Transport_Task_API.Execute_All(source_ref1_);
      ELSIF (task_type_ = 'SHOP ORDER PICK LIST') THEN
         -- Execute the shop order pick list task.
         $IF (Component_Shpord_SYS.INSTALLED) $THEN
            Shop_Material_Pick_Util_API.Report_Pick_List(source_ref1_);
         $ELSE
            NULL;
         $END 
      END IF;
   END IF;
END Execute_Started_Task;


-- Calc_Act_Task_Type_Time_Share
--   This method calcutates the actual time share.
PROCEDURE Calc_Act_Task_Type_Time_Share (
   contract_              IN VARCHAR2,
   worker_id_             IN VARCHAR2,
   from_date_             IN DATE,
   to_date_               IN DATE,
   execution_offset_from_ IN NUMBER,
   execution_offset_to_   IN NUMBER )
IS
   attrib_      VARCHAR2(32000);
   batch_desc_  VARCHAR2(200);
   to_to_date_  DATE;
   f_from_date_ DATE;
BEGIN
   Site_API.Exist(contract_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);

   IF worker_id_ IS NOT NULL THEN
      Warehouse_Worker_API.Exist(contract_, worker_id_);
   END IF;

   IF (execution_offset_from_ IS NOT NULL) AND (from_date_ IS NULL) THEN
      f_from_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_from_;
   ELSIF (execution_offset_from_ IS NULL) AND (from_date_ IS NULL) THEN
      Error_SYS.Record_General('WarehouseTask','FROMDATE2: There must be a value in From Date.');
   ELSE
      f_from_date_ := from_date_;
   END IF;

   IF (execution_offset_to_ IS NOT NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_to_;
   ELSIF (execution_offset_to_ IS NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      to_to_date_ := to_date_;
   END IF;

   IF NOT (Check_Date(f_from_date_, to_to_date_)) THEN
      Raise_To_Date_Error___;
   END IF;

   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
   Client_SYS.Add_To_Attr('WORKER_ID', worker_id_, attrib_);
   Client_SYS.Add_To_Attr('FROM_DATE', f_from_date_, attrib_);
   Client_SYS.Add_To_Attr('TO_DATE', to_to_date_, attrib_);

   Trace_SYS.Message('TRACE => attrib_ = '||attrib_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'TASKTYPETIMESHARE: Calculate Actual Task Type Time Share');
   Transaction_SYS.Deferred_Call('Warehouse_Task_API.Calc_Act_Task_Type_Time_Shar__', attrib_,batch_desc_);
END Calc_Act_Task_Type_Time_Share;


-- Calc_Act_Loc_Group_Time_Share
--   This metod calculates the new actual time share for  location groups.
PROCEDURE Calc_Act_Loc_Group_Time_Share (
   contract_              IN VARCHAR2,
   worker_id_             IN VARCHAR2,
   from_date_             IN DATE,
   to_date_               IN DATE,
   execution_offset_from_ IN NUMBER,
   execution_offset_to_   IN NUMBER )
IS
   attrib_      VARCHAR2(32000);
   batch_desc_  VARCHAR2(200);
   to_to_date_  DATE;
   f_from_date_ DATE;
BEGIN
   Site_API.Exist(contract_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);

   IF worker_id_ IS NOT NULL THEN
      Warehouse_Worker_API.Exist(contract_, worker_id_);
   END IF;

   IF (execution_offset_from_ IS NOT NULL) AND (from_date_ IS NULL) THEN
      f_from_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_from_;
   ELSIF (execution_offset_from_ IS NULL) AND (from_date_ IS NULL) THEN
      Error_SYS.Record_General('WarehouseTask','FROMDATE2: There must be a value in From Date.');
   ELSE
      f_from_date_ := from_date_;
   END IF;

   IF (execution_offset_to_ IS NOT NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_to_;
   ELSIF (execution_offset_to_ IS NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      to_to_date_ := to_date_;
   END IF;

   IF NOT (Check_Date(f_from_date_, to_to_date_)) THEN
      Raise_To_Date_Error___;
   END IF;

   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
   Client_SYS.Add_To_Attr('WORKER_ID', worker_id_, attrib_);
   Client_SYS.Add_To_Attr('FROM_DATE', f_from_date_, attrib_);
   Client_SYS.Add_To_Attr('TO_DATE', to_to_date_, attrib_);

   Trace_SYS.Message('TRACE => attrib_ = '||attrib_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'LOCGROUPTIMESHARE: Calculate Actual Location Group Time Share');
   Transaction_SYS.Deferred_Call('Warehouse_Task_API.Calc_Act_Loc_Ta_Ty_Time_Shar__', attrib_,batch_desc_);
END Calc_Act_Loc_Group_Time_Share;


-- Calc_Act_Task_Type_Eff_Rate
--   This method calculates the Actual Time Needed.
PROCEDURE Calc_Act_Task_Type_Eff_Rate (
   contract_              IN VARCHAR2,
   worker_id_             IN VARCHAR2,
   task_type_             IN VARCHAR2,
   from_date_             IN DATE,
   to_date_               IN DATE,
   execution_offset_from_ IN NUMBER,
   execution_offset_to_   IN NUMBER )
IS
   attrib_      VARCHAR2(32000);
   batch_desc_  VARCHAR2(200);
   to_to_date_  DATE;
   f_from_date_ DATE;
BEGIN
   Site_API.Exist(contract_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);

   IF worker_id_ IS NOT NULL THEN
      Warehouse_Worker_API.Exist(contract_, worker_id_);
   END IF;

   IF (execution_offset_from_ IS NOT NULL) AND (from_date_ IS NULL) THEN
      f_from_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_from_;
   ELSIF (execution_offset_from_ IS NULL) AND (from_date_ IS NULL) THEN
      Error_SYS.Record_General('WarehouseTask','FROMDATE2: There must be a value in From Date.');
   ELSE
      f_from_date_ := from_date_;
   END IF;

   IF (execution_offset_to_ IS NOT NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_to_;
   ELSIF (execution_offset_to_ IS NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      to_to_date_ := to_date_;
   END IF;

   IF NOT (Check_Date(f_from_date_, to_to_date_)) THEN
      Raise_To_Date_Error___;
   END IF;

   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
   Client_SYS.Add_To_Attr('WORKER_ID', worker_id_, attrib_);
   Client_SYS.Add_To_Attr('TASK_TYPE_DB', task_type_, attrib_);
   Client_SYS.Add_To_Attr('FROM_DATE', f_from_date_, attrib_);
   Client_SYS.Add_To_Attr('TO_DATE', to_to_date_, attrib_);

   Trace_SYS.Message('TRACE => attrib_ = '||attrib_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'TASKTYPEEFFRATE: Calculate Actual Task Type Efficiency Rate');
   Transaction_SYS.Deferred_Call('Warehouse_Task_API.Calc_Act_Task_Type_Eff_Rate__', attrib_,batch_desc_);
END Calc_Act_Task_Type_Eff_Rate;


-- Calc_Act_Setup_Time_Needed
--   This method calculates the Actual Time Needed.
PROCEDURE Calc_Act_Setup_Time_Needed (
   contract_              IN VARCHAR2,
   task_type_             IN VARCHAR2,
   from_date_             IN DATE,
   to_date_               IN DATE,
   execution_offset_from_ IN NUMBER,
   execution_offset_to_   IN NUMBER )
IS
   attrib_      VARCHAR2(32000);
   batch_desc_  VARCHAR2(200);
   to_to_date_  DATE;
   f_from_date_ DATE;
BEGIN
   Site_API.Exist(contract_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);

   IF (execution_offset_from_ IS NOT NULL) AND (from_date_ IS NULL) THEN
      f_from_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_from_;
   ELSIF (execution_offset_from_ IS NULL) AND (from_date_ IS NULL) THEN
      Error_SYS.Record_General('WarehouseTask','FROMDATE2: There must be a value in From Date.');
   ELSE
      f_from_date_ := from_date_;
   END IF;

   IF (execution_offset_to_ IS NOT NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := TRUNC(Site_API.Get_Site_Date(contract_)) - execution_offset_to_;
   ELSIF (execution_offset_to_ IS NULL) AND (to_date_ IS NULL) THEN
      to_to_date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      to_to_date_ := to_date_;
   END IF;

   IF NOT (Check_Date(f_from_date_, to_to_date_)) THEN
      Raise_To_Date_Error___;
   END IF;

   Client_SYS.Clear_Attr(attrib_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attrib_);
   Client_SYS.Add_To_Attr('TASK_TYPE_DB', task_type_, attrib_);
   Client_SYS.Add_To_Attr('FROM_DATE', f_from_date_, attrib_);
   Client_SYS.Add_To_Attr('TO_DATE', to_to_date_, attrib_);

   Trace_SYS.Message('TRACE => attrib_ = '||attrib_);
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'SETUPTIMENEEDED: Calculate Actual Setup Time Needed');
   Transaction_SYS.Deferred_Call('Warehouse_Task_API.Calc_Act_Setup_Time_Needed__', attrib_, batch_desc_);
END Calc_Act_Setup_Time_Needed;


-- Check_Date
--   Checks if to date is less than from date.
@UncheckedAccess
FUNCTION Check_Date (
   from_date_ IN DATE,
   to_date_   IN DATE ) RETURN BOOLEAN
IS
BEGIN
   IF (to_date_ < from_date_) THEN
      RETURN (FALSE);
   ELSE
      RETURN (TRUE);
   END IF;
END Check_Date;


-- Check_Planned_And_Released
--   Returns true if there are any planned or released tasks.
@UncheckedAccess
FUNCTION Check_Planned_And_Released (
   contract_  IN VARCHAR2,
   task_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_         NUMBER;
   task_type_db_ warehouse_task_tab.task_type%TYPE;

   CURSOR get_check IS
      SELECT 1
      FROM warehouse_task_tab
      WHERE contract = contract_
      AND   task_type = task_type_db_
      AND   rowstate IN ('Planned','Released');
BEGIN
   task_type_db_ := Warehouse_Task_Type_API.Encode(task_type_);
   OPEN get_check;
   FETCH get_check INTO temp_;
   IF (get_check%FOUND) THEN
      CLOSE get_check;
      RETURN(FALSE);
   END IF;
   CLOSE get_check;
   RETURN(TRUE);
END Check_Planned_And_Released;


-- Get_Finished_Date
--   Returns finished date.
@UncheckedAccess
FUNCTION Get_Finished_Date (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN DATE
IS
   task_id_       NUMBER;
   expected_date_ DATE;
   
   CURSOR get_task_id IS
      SELECT task_id
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   worker_id = worker_id_
      AND   rowstate  = 'Started';
BEGIN
   OPEN get_task_id;
   FETCH get_task_id INTO task_id_;
   CLOSE get_task_id;
   IF (task_id_ IS NOT NULL) THEN
      expected_date_ := Get_Expected_Date_Finished(task_id_);
      RETURN expected_date_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Finished_Date;


-- Get_Started_Task_Id
--   Returns started task id.
@UncheckedAccess
FUNCTION Get_Started_Task_Id (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   task_id_ NUMBER;
   CURSOR get_task_id IS
      SELECT task_id
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   worker_id = worker_id_
      AND   rowstate  = 'Started';
BEGIN
   OPEN get_task_id;
   FETCH get_task_id INTO task_id_;
   CLOSE get_task_id;
   RETURN task_id_;
END Get_Started_Task_Id;


-- Get_Sum_Of_Not_Started_Tasks
--   Returns sum of not started tasks
@UncheckedAccess
FUNCTION Get_Sum_Of_Not_Started_Tasks (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_count IS
      SELECT count(*)
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   worker_id = worker_id_
      AND   rowstate  IN ('Planned', 'Released','Parked');
BEGIN
   OPEN get_count;
   FETCH get_count INTO temp_;
   CLOSE get_count;
   RETURN temp_;
END Get_Sum_Of_Not_Started_Tasks;


-- Get_Sum_Time_Not_Started_Tasks
--   Returns sum time of not started tasks.
@UncheckedAccess
FUNCTION Get_Sum_Time_Not_Started_Tasks (
   contract_  IN VARCHAR2,
   worker_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_sum IS
      SELECT sum(planned_time_needed * number_of_lines)
      FROM warehouse_task_tab
      WHERE contract  = contract_
      AND   worker_id = worker_id_
      AND   rowstate  IN ('Planned','Released','Parked')
      GROUP BY worker_id;
BEGIN
   OPEN get_sum;
   FETCH get_sum INTO temp_;
   CLOSE get_sum;
   RETURN temp_;
END Get_Sum_Time_Not_Started_Tasks;


-- Find_And_Cancel_Task_Source
--   This method will be the entry when to find and cancel a task.
PROCEDURE Find_And_Cancel_Task_Source (
   contract_    IN VARCHAR2,
   task_type_   IN VARCHAR2,
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2,
   source_ref3_ IN VARCHAR2,
   source_ref4_ IN VARCHAR2 )
IS
   task_id_ NUMBER;
BEGIN
   task_id_ := Get_Task_Id_From_Source(contract_,
                                       task_type_,
                                       source_ref1_,
                                       source_ref2_,
                                       source_ref3_,
                                       source_ref4_);
   IF (task_id_ IS NOT NULL) THEN
      Cancel_Task(task_id_);
   END IF;
END Find_And_Cancel_Task_Source;


-- Cancel_Task
--   This method will perform the cancel of a warehouse task.
PROCEDURE Cancel_Task (
   task_id_ IN NUMBER )
IS
   rec_  warehouse_task_tab%ROWTYPE;
   attr_ VARCHAR2(2000);
BEGIN
   rec_ := Get_Object_By_Keys___(task_id_);

   IF rec_.rowstate != 'Cancelled' THEN
      Finite_State_Machine___(rec_, 'Cancel', attr_);
   END IF;
END Cancel_Task;


-- Source_Task_Is_Started
--   This method returns True if the Warehouse Task is started.
FUNCTION Source_Task_Is_Started (
   contract_    IN VARCHAR2,
   task_type_   IN VARCHAR2,
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2,
   source_ref3_ IN VARCHAR2,
   source_ref4_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_         VARCHAR2(20);
   task_type_db_ VARCHAR2(50);

   CURSOR get_state IS
      SELECT rowstate
      FROM warehouse_task_tab
      WHERE NVL(source_ref4,CHR(1)) = NVL(source_ref4_,CHR(1))
      AND   NVL(source_ref3,CHR(1)) = NVL(source_ref3_,CHR(1))
      AND   NVL(source_ref2,CHR(1)) = NVL(source_ref2_,CHR(1))
      AND   contract                = contract_
      AND   task_type               = task_type_db_
      AND   source_ref1             = source_ref1_;
BEGIN
   task_type_db_ := Warehouse_Task_Type_API.Encode(task_type_);

   OPEN get_state;
   FETCH get_state INTO temp_;
   CLOSE get_state;

   IF (temp_ = 'Started') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Source_Task_Is_Started;


-- Source_Task_Started_Or_Parked
--   This method returns True if the Warehouse Task is started or parked.
@UncheckedAccess
FUNCTION Source_Task_Started_Or_Parked (
   contract_    IN VARCHAR2,
   task_type_   IN VARCHAR2,
   source_ref1_ IN VARCHAR2,
   source_ref2_ IN VARCHAR2,
   source_ref3_ IN VARCHAR2,
   source_ref4_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_         VARCHAR2(20);
   task_type_db_ VARCHAR2(50);

   CURSOR get_state IS
      SELECT rowstate
      FROM warehouse_task_tab
      WHERE NVL(source_ref4,CHR(1)) = NVL(source_ref4_,CHR(1))
      AND   NVL(source_ref3,CHR(1)) = NVL(source_ref3_,CHR(1))
      AND   NVL(source_ref2,CHR(1)) = NVL(source_ref2_,CHR(1))
      AND   contract                = contract_
      AND   task_type               = task_type_db_
      AND   source_ref1             = source_ref1_;
BEGIN
   task_type_db_ := Warehouse_Task_Type_API.Encode(task_type_);

   OPEN get_state;
   FETCH get_state INTO temp_;
   CLOSE get_state;

   IF (temp_ IN ('Started', 'Parked')) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Source_Task_Started_Or_Parked;


-- Get_Min_Latest_Start_Date
--   This method returns minimum latest start date
--   from the assigned warehouse tasks.
@UncheckedAccess
FUNCTION Get_Min_Latest_Start_Date (
   worker_id_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ DATE;
   CURSOR get_attr IS
      SELECT MIN((wt.requested_date_finished - (wt.planned_time_needed/1440) * wt.number_of_lines)) 
      FROM warehouse_task_tab wt
      WHERE EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site = contract)
      AND   wt.rowstate IN ('Released', 'Started', 'Parked')
      AND   (wt.location_group IN (SELECT wwlg.location_group
                                   FROM warehouse_worker_loc_group_tab wwlg 
                                   WHERE wwlg.worker_id = worker_id_ 
                                   AND   wwlg.contract  = wt.contract))
      AND   (worker_id = worker_id_  OR (worker_id IS NULL AND wt.task_type IN (SELECT wwtt.task_type 
                                                                                FROM warehouse_worker_task_type_tab wwtt 
                                                                                WHERE wwtt.worker_id = worker_id_
                                                                                AND   wwtt.contract  = wt.contract 
                                                                                AND   wwtt.status    = 'ACTIVE')));
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Min_Latest_Start_Date;


-- This method is used by DataCaptStartWhseTask
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_       IN VARCHAR2,
   task_id_        IN NUMBER,
   worker_id_      IN VARCHAR2,
   location_group_ IN VARCHAR2,
   state_          IN VARCHAR2,
   column_name_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(4000);
   column_value_        VARCHAR2(2000);
   unique_column_value_ VARCHAR2(2000);
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('WAREHOUSE_TASK_TOTAL', column_name_);
   
   stmt_ := ' SELECT ' || column_name_ || '
              FROM WAREHOUSE_TASK_TOTAL  
              WHERE contract           = NVL(:contract_,  contract)
              AND   task_id            = NVL(:task_id_,   task_id)
              AND   objstate           = NVL(:state_,     objstate)
              AND   objstate           IN (''Released'', ''Parked'')
              AND   possible_worker_id = NVL(:worker_id_, possible_worker_id)';
                                                                  
   @ApproveDynamicStatement(2014-12-09,UdGnlk)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           task_id_,
                                           state_,
                                           worker_id_;
   LOOP
      FETCH get_column_values_ INTO column_value_;
      EXIT WHEN get_column_values_%NOTFOUND;

      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := column_value_;
      ELSIF (unique_column_value_ != column_value_) THEN
         unique_column_value_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptParkWhseTask
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_    IN VARCHAR2,
   task_id_     IN NUMBER,
   worker_id_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(4000);
   column_value_        VARCHAR2(2000);
   unique_column_value_ VARCHAR2(2000);
BEGIN
   
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('WAREHOUSE_TASK_TOTAL', column_name_);

   stmt_ := ' SELECT ' || column_name_ || '
              FROM WAREHOUSE_TASK_TOTAL 
              WHERE contract  = NVL(:contract_, contract)
              AND   task_id   = NVL(:task_id_,  task_id)
              AND   objstate  = ''Started''
              AND   worker_id = NVL(:worker_id_, worker_id)'; 
              
   @ApproveDynamicStatement(2014-12-09,UdGnlk)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           task_id_,
                                           worker_id_;
   LOOP
      FETCH get_column_values_ INTO column_value_;
      EXIT WHEN get_column_values_%NOTFOUND;

      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := column_value_;
      ELSIF (unique_column_value_ != column_value_) THEN
         unique_column_value_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptStartWhseTask
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_           IN VARCHAR2,
   task_id_            IN NUMBER,
   location_group_     IN VARCHAR2,
   worker_id_          IN VARCHAR2,
   state_              IN VARCHAR2,
   task_type_          IN VARCHAR2,
   capture_session_id_ IN NUMBER,
   column_name_        IN VARCHAR2,
   lov_type_db_        IN VARCHAR )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_       Get_Lov_Values;
   stmt_                 VARCHAR2(2000);
   TYPE Lov_Value_Tab IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_        Lov_Value_Tab;
   TYPE Lov_Value_2_List IS RECORD (
      task_id         NUMBER,
      location_group  VARCHAR2(5),
      source_ref1     VARCHAR2(30),
      task_type_db    VARCHAR2(50),
      number_of_lines NUMBER); 
   TYPE Lov_Value_2_Tab IS TABLE OF Lov_Value_2_List INDEX BY PLS_INTEGER;
   lov_value_2_tab_      Lov_Value_2_Tab;
   second_column_name_   VARCHAR2(200);
   second_column_value_  VARCHAR2(200);
   lov_item_description_ VARCHAR2(200);
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   location_no_          VARCHAR2(35);
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;
   pre_task_type_db_     VARCHAR2(50);
   task_type_client_     VARCHAR2(200);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('WAREHOUSE_TASK_TOTAL', column_name_);

      stmt_ := ' FROM WAREHOUSE_TASK_TOTAL
                 WHERE task_id            = NVL(:task_id_, task_id)
                 AND   contract           = :contract_
                 AND   location_group     = NVL(:location_group_, location_group)
                 AND   objstate           = NVL(:state_, objstate)
                 AND   objstate           IN (''Released'', ''Parked'') 
                 AND   task_type_db       = NVL(:task_type_, task_type_db)
                 AND   possible_worker_id = NVL(:worker_id_, possible_worker_id)';

      IF (column_name_ = 'TASK_ID') THEN
         IF (Data_Capture_Config_Detail_API.Get_Enabled_Db(capture_process_id_ => session_rec_.capture_process_id, 
                                                           capture_config_id_  => session_rec_.capture_config_id,
                                                           process_detail_id_  => 'SORT_ON_OPERATIONAL_PRIORITY') = Fnd_Boolean_API.DB_TRUE) THEN 
            stmt_ := stmt_ || ' ORDER BY DECODE(assigned_priority, NULL, priority, assigned_priority), worker_id, worker_group, (requested_date_finished - (planned_time_needed/1440) * number_of_lines) ';
         END IF;
      END IF;

      IF (lov_type_db_ = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK and can have the normal order since only 1 value will be picked anyway
         stmt_ := 'SELECT ' || column_name_ || stmt_ ;
      ELSE
         IF (column_name_ IN ('TASK_ID', 'LOCATION_GROUP')) THEN
            stmt_ := 'SELECT task_id, location_group, source_ref1, task_type_db, number_of_lines ' || stmt_;
         ELSE
            stmt_ := 'SELECT DISTINCT ' || column_name_ || stmt_ ;
         END IF;
      END IF;
   
      @ApproveDynamicStatement(2014-12-09,UdGnlk)
      OPEN get_lov_values_ FOR stmt_ USING task_id_,
                                           contract_,
                                           location_group_,
                                           state_,
                                           task_type_,
                                           worker_id_;
                                           
      IF (lov_type_db_ = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         IF (column_name_ IN ('TASK_ID', 'LOCATION_GROUP')) THEN
            FETCH get_lov_values_ BULK COLLECT INTO lov_value_2_tab_;
         ELSE
            FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         END IF;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_2_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('TASK_ID') THEN
               second_column_name_ := 'TASK_INFORMATION';
            WHEN ('LOCATION_GROUP') THEN
               second_column_name_ := 'LOCATION_INFORMATION';
            ELSE
               NULL;
         END CASE;
         
         FOR i IN lov_value_2_tab_.FIRST..lov_value_2_tab_.LAST LOOP
            IF (second_column_name_ IS NOT NULL) THEN
               IF (pre_task_type_db_ IS NULL) OR (pre_task_type_db_ != lov_value_2_tab_(i).task_type_db) THEN
                  pre_task_type_db_ := lov_value_2_tab_(i).task_type_db;
                  task_type_client_ := Warehouse_Task_Type_API.Decode(pre_task_type_db_);
               END IF;
               IF (second_column_name_ = 'TASK_INFORMATION') THEN
                  -- Get the first from_location_no/location_no 
                  IF (lov_value_2_tab_(i).task_type_db = Warehouse_Task_Type_API.DB_TRANSPORT_TASK) THEN
                     location_no_ := Transport_Task_Line_API.Get_First_Location_No(lov_value_2_tab_(i).source_ref1);
                  ELSIF (lov_value_2_tab_(i).task_type_db = Warehouse_Task_Type_API.DB_CUSTOMER_ORDER_PICK_LIST) THEN
                     $IF Component_Order_SYS.INSTALLED $THEN
                        location_no_ := Pick_Customer_Order_API.Get_First_Location_No(lov_value_2_tab_(i).source_ref1);
                     $ELSE
                        NULL;
                     $END
                  ELSIF (lov_value_2_tab_(i).task_type_db = Warehouse_Task_Type_API.DB_SHOP_ORDER_PICK_LIST) THEN
                     $IF Component_Shpord_SYS.INSTALLED $THEN
                        location_no_ := Shop_Material_Pick_Line_API.Get_First_Location_No(lov_value_2_tab_(i).source_ref1);
                     $ELSE
                        NULL;
                     $END
                  END IF;
                  second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, location_no_) || ' | ' || 
                                          lov_value_2_tab_(i).number_of_lines || ' | ' || 
                                          task_type_client_;
               ELSIF (second_column_name_ = 'LOCATION_INFORMATION') THEN
                  second_column_value_ := task_type_client_ || ' | ' || 
                                          lov_value_2_tab_(i).location_group || ' | ' || 
                                          lov_value_2_tab_(i).number_of_lines;
               END IF;
               IF (second_column_value_ IS NOT NULL) THEN
                  lov_item_description_ := second_column_value_;
               ELSE
                  lov_item_description_ := NULL;
               END IF;
            END IF;
          
            IF (column_name_ = 'TASK_ID') THEN
               Data_Capture_Session_Lov_API.New(exit_lov_             => exit_lov_,
                                                capture_session_id_   => capture_session_id_,
                                                lov_item_value_       => lov_value_2_tab_(i).task_id,
                                                lov_item_description_ => lov_item_description_,
                                                lov_row_limitation_   => lov_row_limitation_,    
                                                session_rec_          => session_rec_);
               EXIT WHEN exit_lov_;
            ELSE
               Data_Capture_Session_Lov_API.New(exit_lov_             => exit_lov_,
                                                capture_session_id_   => capture_session_id_,
                                                lov_item_value_       => lov_value_2_tab_(i).location_group,
                                                lov_item_description_ => lov_item_description_,
                                                lov_row_limitation_   => lov_row_limitation_,    
                                                session_rec_          => session_rec_);
               EXIT WHEN exit_lov_;
            END IF;
         END LOOP;
      ELSIF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_             => exit_lov_,
                                             capture_session_id_   => capture_session_id_,
                                             lov_item_value_       => lov_value_tab_(i),
                                             lov_item_description_ => lov_item_description_,
                                             lov_row_limitation_   => lov_row_limitation_,    
                                             session_rec_          => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;
   
   
-- This method is used by DataCaptParkWhseTask
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_           IN VARCHAR2, 
   task_id_            IN NUMBER,
   worker_id_          IN VARCHAR2, 
   capture_session_id_ IN NUMBER,
   column_name_        IN VARCHAR2,
   lov_type_db_        IN VARCHAR2 )
IS
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_       Get_Lov_Values;
   stmt_                 VARCHAR2(2000);
   TYPE Lov_Value_Tab IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_        Lov_Value_Tab;
   TYPE Lov_Value_2_List IS RECORD (
      task_id         NUMBER,
      source_ref1     VARCHAR2(30),
      task_type_db    VARCHAR2(50),
      number_of_lines NUMBER); 
   TYPE Lov_Value_2_Tab IS TABLE OF Lov_Value_2_List INDEX BY PLS_INTEGER;
   lov_value_2_tab_      Lov_Value_2_Tab;
   second_column_name_   VARCHAR2(200);
   second_column_value_  VARCHAR2(200);
   lov_item_description_ VARCHAR2(200);
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;
   location_no_          VARCHAR2(35);
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('WAREHOUSE_TASK_TOTAL', column_name_);

      stmt_ := ' FROM WAREHOUSE_TASK_TOTAL
                 WHERE contract  = :contract_
                 AND   objstate  = ''Started''
                 AND   task_id   = NVL(:task_id_, task_id)
                 AND   worker_id = NVL(:worker_id_, worker_id)';

      IF (column_name_ = 'TASK_ID') THEN
         stmt_ := 'SELECT task_id, source_ref1, task_type_db, number_of_lines ' || stmt_;
      ELSE
         IF (lov_type_db_ = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
            -- Don't use DISTINCT select for AUTO PICK and can have the normal order since only 1 value will be picked anyway
            stmt_ := 'SELECT ' || column_name_ || stmt_ ;
         ELSE
            stmt_ := 'SELECT DISTINCT ' || column_name_ || stmt_ ;
         END IF;
      END IF;
   
      @ApproveDynamicStatement(2015-01-28,JeLise)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           task_id_,
                                           worker_id_;
                                           
      IF (column_name_ = 'TASK_ID') THEN
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_2_tab_;
      ELSE
         IF (lov_type_db_ = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
            -- Only 1 value for AUTO PICK
            FETCH get_lov_values_ INTO lov_value_tab_(1);
         ELSE
            FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         END IF;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_2_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('WORKER_ID') THEN
               second_column_name_ := 'WORKER_NAME';
            WHEN ('TASK_ID') THEN
               second_column_name_ := 'TASK_INFORMATION';
            ELSE
               second_column_value_ := NULL;
         END CASE;
         
         FOR i IN lov_value_2_tab_.FIRST..lov_value_2_tab_.LAST LOOP
            IF (second_column_name_ IS NOT NULL) THEN
               IF (second_column_name_ = 'TASK_INFORMATION') THEN
                  -- Get the first from_location_no/location_no 
                  IF (lov_value_2_tab_(i).task_type_db = Warehouse_Task_Type_API.DB_TRANSPORT_TASK) THEN
                     location_no_ := Transport_Task_Line_API.Get_First_Location_No(lov_value_2_tab_(i).source_ref1);
                  ELSIF (lov_value_2_tab_(i).task_type_db = Warehouse_Task_Type_API.DB_CUSTOMER_ORDER_PICK_LIST) THEN
                     $IF Component_Order_SYS.INSTALLED $THEN
                        location_no_ := Pick_Customer_Order_API.Get_First_Location_No(lov_value_2_tab_(i).source_ref1);
                     $ELSE
                        NULL;
                     $END
                  ELSIF (lov_value_2_tab_(i).task_type_db = Warehouse_Task_Type_API.DB_SHOP_ORDER_PICK_LIST) THEN
                     $IF Component_Shpord_SYS.INSTALLED $THEN
                        location_no_ := Shop_Material_Pick_Line_API.Get_First_Location_No(lov_value_2_tab_(i).source_ref1);
                     $ELSE
                        NULL;
                     $END
                  END IF;
                  second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, location_no_) || ' | ' || 
                                          lov_value_2_tab_(i).number_of_lines || ' | ' || 
                                          Warehouse_Task_Type_API.Decode(lov_value_2_tab_(i).task_type_db);
               END IF;
               IF (second_column_value_ IS NOT NULL) THEN
                  lov_item_description_ := second_column_value_;
               ELSE
                  lov_item_description_ := NULL;
               END IF;
            END IF;
          
            Data_Capture_Session_Lov_API.New(exit_lov_             => exit_lov_,
                                             capture_session_id_   => capture_session_id_,
                                             lov_item_value_       => lov_value_2_tab_(i).task_id,
                                             lov_item_description_ => lov_item_description_,
                                             lov_row_limitation_   => lov_row_limitation_,    
                                             session_rec_          => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ = 'WORKER_NAME') THEN
                  second_column_value_ := Person_Info_API.Get_Name(lov_value_tab_(i));
               END IF;
            END IF;

            Data_Capture_Session_Lov_API.New(exit_lov_             => exit_lov_,
                                             capture_session_id_   => capture_session_id_,
                                             lov_item_value_       => lov_value_tab_(i),
                                             lov_item_description_ => second_column_value_,
                                             lov_row_limitation_   => lov_row_limitation_,    
                                             session_rec_          => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END   
END Create_Data_Capture_Lov;


PROCEDURE State_Exist_Db (
   state_db_ IN VARCHAR2 )
IS
BEGIN
   IF (INSTR('^'||Get_Db_Values___, '^'||state_db_||'^') = 0) THEN
      Error_SYS.Record_General(lu_name_,'STATENOTEXIST: Warehouse task status :P1 does not exist.', state_db_);         
   END IF;
END State_Exist_Db;


PROCEDURE Data_Capt_Item_Value_Exist (
   data_item_value_ IN VARCHAR2 )
IS
BEGIN
   State_Exist_Db(data_item_value_);
END Data_Capt_Item_Value_Exist;    


@UncheckedAccess
FUNCTION Get_Data_Capt_Item_Value_Desc (
   data_item_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Decode__(data_item_value_);
END Get_Data_Capt_Item_Value_Desc;   

   
PROCEDURE Started_Task_Exist (
   task_id_ IN NUMBER )
IS
   state_ warehouse_task_tab.rowstate%TYPE;
   CURSOR get_state IS
      SELECT rowstate
      FROM warehouse_task_tab
      WHERE task_id = task_id_;
BEGIN
   Exist(task_id_);
   OPEN get_state;
   FETCH get_state INTO state_;
   CLOSE get_state;
   
   IF (state_ != 'Started') THEN
      Error_SYS.Record_General(lu_name_, 'NOTASKTOPARK: The Warehouse Task is not in status Started.');
   END IF;
END Started_Task_Exist;


PROCEDURE Start_Or_Restart_Task (
   task_id_   IN NUMBER,
   worker_id_ IN VARCHAR2 )
IS
   state_      VARCHAR2(4000);
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   dummy_info_ VARCHAR2(2000);
   dummy_attr_ VARCHAR2(2000);

   CURSOR get_state IS
      SELECT rowstate
      FROM warehouse_task_tab
      WHERE task_id = task_id_;
BEGIN
   OPEN get_state;
   FETCH get_state INTO state_;
   CLOSE get_state;
   
   IF (state_ = 'Released') THEN
      Start_Task(task_id_   => task_id_,
                 worker_id_ => worker_id_);
   ELSIF (state_ = 'Parked') THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, task_id_);
      Restart__(info_       => dummy_info_,
                objid_      => objid_,
                objversion_ => objversion_,
                attr_       => dummy_attr_,
                action_     => 'DO');
   END IF;
END Start_Or_Restart_Task;


@UncheckedAccess   
FUNCTION Worker_Is_To_Loc_Group_Active (
   transport_task_id_ IN NUMBER,
   worker_id_         IN VARCHAR2 ) RETURN BOOLEAN
IS
   worker_is_active_  BOOLEAN := FALSE;
   to_contract_       warehouse_task_tab.contract%TYPE;
   to_location_group_ warehouse_worker_loc_group_tab.location_group%TYPE;
   to_location_tab_   Warehouse_Bay_Bin_API.Location_No_Tab;
BEGIN
   IF (worker_id_ IS NOT NULL) THEN
      worker_is_active_ := TRUE;
      to_contract_      := Transport_Task_API.Get_To_Contract(transport_task_id_);
      to_location_tab_ := Transport_Task_API.Get_To_Locations(transport_task_id_, only_non_executed_ => TRUE, only_to_inventory_ => TRUE);

      IF (to_location_tab_.COUNT > 0) THEN
         FOR i IN to_location_tab_.FIRST..to_location_tab_.LAST LOOP
            to_location_group_ := Inventory_Location_API.Get_Location_Group(to_contract_, to_location_tab_(i));
            IF NOT (Warehouse_Worker_Loc_Group_API.Is_Active_Worker(to_contract_, worker_id_, to_location_group_)) THEN
               worker_is_active_ := FALSE;
               EXIT;
            END IF;
         END LOOP;
      END IF;
   END IF;

   RETURN (worker_is_active_);
END Worker_Is_To_Loc_Group_Active;


@UncheckedAccess   
FUNCTION Workr_Grp_Is_To_Loc_Grp_Active (
   transport_task_id_ IN NUMBER,
   worker_group_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   worker_group_is_active_ BOOLEAN := FALSE;
   to_contract_            warehouse_task_tab.contract%TYPE;
   to_location_tab_        Warehouse_Bay_Bin_API.Location_No_Tab;
   to_location_group_      warehouse_worker_group_loc_tab.location_group%TYPE;
BEGIN
   IF (worker_group_ IS NOT NULL) THEN
      worker_group_is_active_ := TRUE;
      to_contract_            := Transport_Task_API.Get_To_Contract(transport_task_id_);
      to_location_tab_        := Transport_Task_API.Get_To_Locations(transport_task_id_, only_non_executed_ => TRUE, only_to_inventory_ => TRUE);

      IF (to_location_tab_.COUNT > 0) THEN
         FOR i IN to_location_tab_.FIRST..to_location_tab_.LAST LOOP
            to_location_group_ := Inventory_Location_API.Get_Location_Group(to_contract_, to_location_tab_(i));
            IF NOT (Warehouse_Worker_Group_Loc_API.Check_Location_Group_Active(to_contract_, worker_group_, to_location_group_)) THEN
               worker_group_is_active_ := FALSE;
               EXIT;
            END IF;
         END LOOP;
      END IF;
   END IF;

   RETURN (worker_group_is_active_);
END Workr_Grp_Is_To_Loc_Grp_Active;


@UncheckedAccess  
FUNCTION Workr_Grp_Is_To_Site_Active (
   transport_task_id_ IN NUMBER,
   worker_group_      IN VARCHAR2,
   task_type_db_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   worker_group_is_active_ BOOLEAN := FALSE;
   to_contract_            warehouse_task_tab.contract%TYPE;
BEGIN
   IF (worker_group_ IS NOT NULL) THEN
      worker_group_is_active_ := TRUE;
      to_contract_            := Transport_Task_API.Get_To_Contract(transport_task_id_);     
      IF (NOT (Warehouse_Worker_Grp_Task_API.Is_Active_Worker_Group(to_contract_, worker_group_, task_type_db_))) THEN
         worker_group_is_active_ := FALSE;   
      END IF;   
   END IF; 
   RETURN worker_group_is_active_;
END Workr_Grp_Is_To_Site_Active;   


@UncheckedAccess  
FUNCTION Worker_Is_To_Contract_Active (
   transport_task_id_ IN NUMBER,
   worker_id_         IN VARCHAR2,
   task_type_db_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   worker_is_active_ BOOLEAN := FALSE;
   to_contract_      warehouse_task_tab.contract%TYPE;
BEGIN
   IF (worker_id_ IS NOT NULL) THEN
      worker_is_active_ := TRUE;
      to_contract_      := Transport_Task_API.Get_To_Contract(transport_task_id_);     
      IF (NOT (Warehouse_Worker_Task_Type_API.Is_Active_Worker(to_contract_, worker_id_, task_type_db_))) THEN
         worker_is_active_ := FALSE;   
      END IF;   
   END IF; 
   RETURN worker_is_active_;
END Worker_Is_To_Contract_Active; 


@UncheckedAccess
FUNCTION Wrkr_Grp_Is_Allowed_For_Wrkrs (
   transport_task_id_ IN NUMBER,
   worker_group_      IN VARCHAR2 ) RETURN BOOLEAN
IS
   worker_id_tab_             Warehouse_Worker_Group_API.Worker_Id_Tab;
   worker_in_group_is_active_ BOOLEAN := FALSE;
BEGIN
   worker_id_tab_ := Warehouse_Worker_Group_API.Get_Warehouse_Workers(Transport_Task_API.Get_To_Contract(transport_task_id_), worker_group_);
   IF (worker_id_tab_.COUNT > 0) THEN
      FOR i IN worker_id_tab_.FIRST..worker_id_tab_.LAST LOOP
         IF (Worker_Is_To_Loc_Group_Active(transport_task_id_, worker_id_tab_(i))) THEN
            worker_in_group_is_active_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN worker_in_group_is_active_;
END Wrkr_Grp_Is_Allowed_For_Wrkrs;    


-- Method created for Aurena client since 0Data is not handling data type conversion especially good
FUNCTION Get_Transport_Task_Id (
 source_ref1_  IN VARCHAR2,
 task_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
  IF (Transport_Task___(task_type_db_ )) THEN
     RETURN TO_NUMBER(source_ref1_);
  ELSE
     RETURN NULL;
  END IF;
END Get_Transport_Task_Id;
