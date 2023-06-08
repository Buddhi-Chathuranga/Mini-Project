-----------------------------------------------------------------------------
--
--  Logical unit: CountingReportLine
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220127  JaThlk  SC21R2-7284, Modified Check_Insert___ to validate when entering serial_no and lot_batch_no.
--  220114  DaZasee SC21R2-2952, Changed Create_Data_Capture_Lov for lov 1 so for SEQ it will follow views original sorting so any new report lines will be come first.
--  211223  JaThlk  SC21R2-2942, Added Modify_Counted_Qty and Any_Unconfirmed_Line_Exist to support counting serial items without specifying serials.
--  211211  JaThlk  SC21R2-2932, Added Get_Max_Sequence_No function to get maximum sequence number for the count report and modified New_List_Detail
--  211211          to add warehouse_route_order_, bay_route_order_, row_route_order_, tier_route_order_ and bin_route_order_ as parameters. 
--  210118  SBalLK  Issue SC2020R1-11830, Modified New_List_Detail() and Count_Line_Without_Diff () methods by removing attr_ functionality to optimize the performance.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  191212  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191212          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191212          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  190131  LaThlk  Bug 146078(SCZ-2487), Modified Create_Data_Capture_Lov() by dynamically binding the variable last_character_ in order to be accessible when it is executed.
--  181030  DaZase  SCUXXW4-6154, Added Get_No_Counted_Lines.
--  180308  LEPESE  STRSC-17479, Added package constant last_character_ and replaced usage of Database_SYS.Get_Last_Character with this new constant for increased performance.
--  171017  SBalLK  Bug 138185, Modified Remove_Uncounted_Lines() method to raise error message when there is no Uncounted rows in count report while removing uncounted rows.
--  170109  DaZase  LIM-10145, Changed Create_Data_Capture_Lov so it will in some circumstances use view Counting_Report_Part_Process.
--  161219  DaZase  LIM-5062, Added method Handling_Unit_Exist_On_Report.
--  161012  SBalLK  Bug 131433, Modified Check_Update___() method by adding NOTDEFINELOTNO, DEFINELOTNO, NOTDEFINESERIALNO, DEFINESERIALNO error messages to validate lot/serial tracking mechanism changes.
--  160922  TiRalk  Bug 131311, Modified the error message 753 in method Unpack_Check_Update___ by adding additional information.
--  160920  SBalLK  Bug 129839, Added CONFIRMED attribute to Logical Unit to indicate counting report line confirmed or not. Added Set_Confirmed() method.
--  160920          Made changes of method which validate unconfirmed lines against counting_result_tab with newly introduced column.
--  160712  Jhalse  LIM-8010, Added method Do_Remove__ to handle performance issue with cascading delete bypassing the inventory_event_id concept.
--  160629  Jhalse  LIM-7520, Added methods Insert___, Delete___, Add_Reports_To_Hu_Refresh_List
--  160629                    Changed several methods to use server based refresh of the handling unit snapshot.
--  160629                    Added new parameters to several methods to make use of the new Inventory_Event_ID concept.
--  160510	Khvese	LIM-1310, Added methods Get_Location_No().
--  160504	Khvese	LIM-1310, Added methods Count_As_Non_Existing(), Get_Seq_No(), Get_Qty_Counted() and Get_Last_Count_Date().
--  151125  Chfose  LIM-4471, Changed occurrences of Counting_Report_Line_Nopal to properly use its new name Counting_Report_Line_Extended.
--  151016  MaEelk  LIM-3784, Removed pallet_id related logic from Check_Update___, New_List_Detail, Count_All_Lines_Without_Diff,Check_Unconfirmed_Part_Loc,
--  151016          and Get_Count_Report_No, 
--  150529  KhVese  Added sql_where_expression_ as a default parameter to the method signatures of Create_Data_Capture_Lov()
--  150529          and Get_Column_Value_If_Unique() and Record_With_Column_Value_Exist().
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150421  Chfose  LIM-1245, Fixed calls to Inventory_Part_Loc_Pallet_API by including handling_unit_id.
--  150408  Chfose  Added usage of new column handling_unit_id throughout the logic where applicable.
--  141103  ChJalk  PRSC-2216, Added missing assert safe anotation for get_lov_values_, get_column_values_ and exist_control_.
--  140814  DaZase  PRSC-1611, Added extra column checks in methods Get_Column_Value_If_Unique, Create_Data_Capture_Lov and Record_With_Column_Value_Exist to avoid any risk of getting sql injection problems.
--  140811  DaZase  PRSC-1611, Renamed Check_Valid_Value to Record_With_Column_Value_Exist.
--  140619  AyAmlk  Bug 115364, Modified Check_Update___() to rephrase an error message.
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  140516  SWiclk  PBSC-9833, Bug 116877, Modified Create_Data_Capture_Lov() in order to make value_list_ NULL when there is no value to assign.
--  131107  DaZase  Bug 113522, Changes in Create_Data_Capture_Lov removed old filtering of SEQ data item added extra cursor where-statement for SEQ if in a loop to do the filtering instead.
--  131016  DaZase  Bug 112931, removed distinct from the cursor in method Get_Column_Value_If_Unique and renamed some variables. Several performance changes in method Create_Data_Capture_Lov.
--  131106  UdGnlk  PBSC-206, Modified the base view comments to align with model file errors. 
--  130731  MaRalk  TIBE-831, Removed global LU constant inst_Project_ and modified Unpack_Check_Insert___ 
--  130731          using conditional compilation instead.
--  130321  Cpeilk  Bug 108214, Modified Check_Catch_Qty_Counting___() not to raise the null check errors of catch_qty_counted and
--  130321          qty_count1 when both are NULL at the same time.
--  121029  JeLise  Added methods Count_And_Confirm_Line, Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Check_Valid_Value.
--  120131  MaEelk  Corrected Date format of last_count_date in view comments.
--  111027  NISMLK  SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  111024  MaEelk  Added UAS filter to COUNTING_REPORT_LINE, COUNTING_REPORT_LINE_NOPAL and COUNTING_REPORT_LINE_PALL.
--  110224  RaKalk  Added function Tracking_Id_Is_On_Nonconfirmed. Added column Part_tracking_session_id.
--  110203  KiSalk  Moved 'User Allowed Site' Default Where condition from client to VIEW2.
--  101029  PraWlk  Bug 93902, Modified error message NOTALLOWREDUCING by correcting spelling mistakes.
--  101019  DAYJLK  Bug 92986, Modified function Check_Unconfirmed_Lines by removing unnecessary keys and attributes used 
--  101019          for the check in the WHERE clause of cursor check_cur which is now renamed to exist_control.
--  101019          Modified function by replacing multiple RETURN statements with just a single RETURN and renamed the variables.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090730  Asawlk  Bug 84611. Added method Count_Line_Without_Diff__(). Modified method Confirm_All_Counted_Lines() and
--  090730          introduced an error message to pop up when no records are found. 
--  080703  Prawlk  Bug 74974, Added PROCEDURE Confirm_Line to confirm counted line for the count report.
--  071031  RoJalk  Bug 68811, Increased the length to 2000 of note_text in COUNTING_RESULT view. 
--  060220  NuFilk  Added Reference to column Activity_Seq in view to function Check_Remove__ and modified the function.
--  060210  SaRalk  Modified procedure Confirm_All_Counted_Lines. 
--  060120  JaBalk  Modified Count_All_Lines_Without_Diff method to avoid numeric/value error.
--  060120  NiDalk  Added Assert safe annotation. 
--  050929  DaZase  Added configuration_id/activity_seq in calls to Inventory_Part_Loc_Pallet_API methods.
--  050919  NiDalk  Removed unused variables.
--  041020  SaJjlk  Changed method name Handle_Catch_Qty_Counting___ to Check_Catch_Qty_Counting.
--  041004  SaJjlk  Added parameter catch_qty_counted_ to Count_Line_Without_Diff and added method Handle_Catch_Qty_Counting___.
--  040917  SaJjlk  Modified method calls to method Counting_Result_API.New_Result to include parametes catch_qty_onhand_ and catch_qty_counted_.
--  040916  SaJjlk  Added column CATCH_QTY_COUNTED, CATCH_QTY_ONHAND and added parameter catch_qty_onhand to method New_List_Detail.
--  040812  DiVelk  Added parameter 'activity_seq' to [Get_Count_Report_No].
--  040812  DiVelk  Added 'note text' to VIEW4.
--  040809  MaEelk  Removed Reference from Configuration ID. Removed CASCADE from Activity_Seq
--  040802  DiVelk  Modified VIEW2 and VIEW4.
--  040721  DiVelk  Added parameter 'activity_seq' to [Check_Remove__] and [Check_Unconfirmed_Part_Loc].
--  040721  DiVelk  Modified view comments of NOTE_TEXT.
--  040716  DiVelk  Added view comments on Activity_Seq and Project_Id.
--  040716  DiVelk  Added Note_Text to VIEW3.
--  040715  DiVelk  Modified calls to [Counting_Result_API] and [Inventory_Part_In_Stock_API] methods.
--  040714  DiVelk  Added NOTE_TEXT,ACTIVITY_SEQ and PROJECT_ID. Modified [New_List_Detail] and [Unpack_Check_Insert___].
--  040504  DaZaSe  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  -------------------------------- 13.3.0 ----------------------------------
--  040213  RoJalk  Bug 39996, Modified Unpack_Check_Update___.
--  030429  MaGulk  Modified Unpack_Check_Update___ to check with part counting control of part
--  030429          availability control if counted quantity is reduced
--  020523  NASALK  Extended length of Serial no from VARCHAR2(15) to VARCHAR2(50) in view comments
--  010103  JOHESE  Added where condidion on COUNTING_REPORT_LINE2
--  001218  PaLj    CID 58292. Changed View COUNTING_REPORT_LINE2
--  001026  PERK    Removed comment with swedish characters in because of double byte issues
--  000925  JOHESE  Added undefines.
--  000823  PERK    Added configuration_id to views and methods
--  000505  ANHO    Replaced call to USER_DEFAULT_API.Get_Contract with USER_ALLOWED_SITE_API.Get_Default_Site.
--  000414  NISOSE  Added General_SYS.Init_Method in Any_Counted_Lines and Check_Remove__.
--  000413  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000310  ANHO    Added check for moved or deleted pallets in unpack_check_update.
--  000228  ANHO    Added function Get_Count_Report_No.
--  000218  SHVE    Removed Part_Exist, Get_Last_Qty_Count1.
--  000214  ANHO    Added columns in view COUNTING_REPORT_LINE2.
--  000214  SHVE    Added Count_All_Lines_Without_Diff, Count_Line_Without_Diff.
--  000211  SHVE    Removed Pre_Update. Added Check_Unconfirmed_Lines and Confirm_All_Counted_Lines.
--  000201  SHVE    Added Remove_Uncounted_Lines and reorganised Reset_Part_Freeze_Code.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990820  FRDI    Bug 11197, Changed check for reserved qty on pallets in unpack_check_update.
--  990730  FRDI    Bug 11156, Changed check for reserved qty in unpack_check_update.
--  990506  SHVE    Replaced call to Inventory_Part_Cost_API.Get_Cost_Per_Part with
--                  Inventory_Part_API.Get_Inventory_Value_By_Method.
--  990419  ROOD    General performance improvements.
--  990419  ROOD    Removed objid, objversion and qty_count1 from view COUNTING_REPORT_LINE2.
--  990409  ROOD    Upgraded to performance optimized template.
--  990319  JOHW    Added customlist reference check and method Check_Remove__.
--  990203  JOKE    Changed Call from Do_Booking in Pre_Update to Do_Transaction_Booking.
--  981223  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981122  FRDI    Full precision for UOM, change comments on tab.
--  981120  JOHW    Modified cursor in Reset_Part_Freeze_Code.
--  980916  JOHW    Modified Reset_Part_Freeze_Code.
--  980915  JOHW    Added methods Reset_Part_Freeze_Code and Any_Counted_Lines.
--                  Also changed call for modification of freeze_code.
--  980825  SHVE    Removed update flag for columns used in Ref to InventoryPartLocation.
--  980625  FRDI    Reconstruction of inventory location key
--  980625  GOPE    Added handling of Arrival, QA pallet location types
--  980209  JOHO    Format on amount columns. Added Get_currency_Rounding.
--  971127  GOPE    Upgrade to fnd 2.0
--  971006  LEPE    Added NOCHECK option for REF=InventoryPartLocation.
--  970417  MAGN    Modified procedure pre_update.
--  970416  MAGN    Corrected where clause in view3 and view4.
--  970415  MAGN    Added pallet_id in function new_list_detail.
--  970415  MAGN    Added new views for counting on pallet locations and not pallet locations.
--  970403  MAGN    Added column pallet_id.
--  970325  MAGN    Changed from mpccom_company_API.Get_Home_Company to Site_API.Get_Company.
--  970312  CHAN    Changed table name: inv_list_detail is replaced by
--                  counting_report_line_tab
--  970219  JOKE    Uses column rowversion as objversion (timestamp).
--  961220  JOKE    Removed Client_SYS.Get_Item_Value from Unpack_Check_Insert.
--  961214  AnAr    Changed call to USER to Utility_SYS.Get_User.
--  961212  MAOR    Changed to new template.
--  961212  JICE    Modified calls to InventoryPartLocation.
--  961205  MAOR    Changed order of parameters in call to
--                  Inventory_Part_Cost_API.Get_Cost_Per_Part.
--  961128  MAOR    Changed order of parameters in call to
--                  Inventory_Transaction_Hist_API.Do_Booking.
--  961124  MAOR    Changed to new template and workbench.
--  961031  MAOR    Modified file to Rational Rose Model-standard.
--  961008  GOPE    Added check if qty counted < 0
--  960901  PEKR    Replaced calls to Mpc_Inv_Accounting_Pkg.Do_Booking with
--                  Inventory_Transaction_Hist_API.Do_Booking.
--  960709  JOBE    Added column qty_count1 to View2.
--  960708  JOBE    Added View2.
--  960607  JOBE    Added functionality to CONTRACT.
--  960523  SHVE    Replaced call to mpc_part_cost_pkg with call to
--                  Inventory_part_cost_api.
--  960502  MAOS    Replaced update of part_lock with call to Modify_Count_Variance.
--  960502  MAOS    Added procedure New_List_Detail.
--  960326  LEPE    Removed several dependencies to other db_tables.
--  960322  LEPE    Removed several dependencies to other db_tables.
--  960307  JICE    Renamed from InvCountInvListDetail
--  960206  LEPE    Bug 96-0006 Changed parameter-type for parameter "rec_" in
--                  procedures pre_update___ and Update___.
--  951116  JOBJ    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_    CONSTANT VARCHAR2(11) := Database_SYS.string_null_;
last_character_ CONSTANT VARCHAR2(1)  := Database_SYS.Get_Last_Character;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Catch_Qty_Counting___
--   Handles counting of catch unit enabled parts.
PROCEDURE Check_Catch_Qty_Counting___ (
   newrec_ IN OUT counting_report_line_tab%ROWTYPE)
IS
BEGIN
   IF (newrec_.catch_qty_counted IS NULL)  THEN
      IF (newrec_.qty_count1 IS NOT NULL) THEN
         Error_SYS.Record_General('CountingReportLine', 'CATCHNONULL: The catch quantity counted must have a value.');
      END IF;
   ELSE
      IF (newrec_.qty_count1 IS NULL) THEN
         Error_SYS.Record_General('CountingReportLine', 'QTYCOUNTEDNONULL: The quantity counted must have a value.');
      END IF;
   END IF;

   IF (newrec_.catch_qty_counted < 0) THEN
      Error_SYS.Record_General('CountingReportLine', 'CATCHNONEGATIVE: The catch quantity counted must be greater than or equal to zero.');
   END IF;

   IF (newrec_.qty_count1 = 0) THEN
      IF (newrec_.catch_qty_counted != 0) THEN
         Error_SYS.Record_General('CountingReportLine', 'CATCHQTYZERO: The catch quantity counted must be zero when the quantity counted is zero.');
      END IF;
   ELSE
      IF (newrec_.catch_qty_counted = 0) THEN
         Error_SYS.Record_General('CountingReportLine','CATCHQTYNOZERO: The catch quantity counted cannot be zero when the quantity counted is greater than zero.');
      END IF;
   END IF;
END Check_Catch_Qty_Counting___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT',User_Allowed_Site_API.Get_Default_Site,attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     counting_report_line_tab%ROWTYPE,
   newrec_     IN OUT counting_report_line_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF NOT ( oldrec_.confirmed = Fnd_Boolean_API.DB_FALSE AND newrec_.confirmed = Fnd_Boolean_API.DB_TRUE ) THEN
      newrec_.userid := Fnd_Session_API.Get_Fnd_User;
      Client_SYS.Add_To_Attr('USERID', newrec_.userid, attr_);
      newrec_.last_count_date := Site_API.Get_Site_Date(newrec_.contract);
      Client_SYS.Add_To_Attr('LAST_COUNT_DATE', newrec_.last_count_date, attr_);
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (oldrec_.part_tracking_session_id IS NOT NULL) AND
       (newrec_.part_tracking_session_id IS NULL) THEN
      Client_SYS.Add_To_Attr('PART_TRACKING_SESSION_ID', TO_CHAR(NULL), attr_);
      Temporary_Part_Tracking_API.Remove_Session(oldrec_.part_tracking_session_id);
   END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Insert___ (
   objid_               OUT VARCHAR2,
   objversion_          OUT VARCHAR2,
   newrec_              IN OUT NOCOPY counting_report_line_tab%ROWTYPE,
   attr_                IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   newrec_.confirmed := Fnd_Boolean_API.DB_FALSE;
   super(objid_, objversion_, newrec_, attr_);
   Hu_Snapshot_For_Refresh_API.New(source_ref1_         => newrec_.inv_list_no, 
                                   source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT);
END Insert___;

@Override
PROCEDURE Delete___ (
   objid_               IN VARCHAR2,
   remrec_              IN counting_report_line_tab%ROWTYPE)
IS
BEGIN
   super(objid_,remrec_);
   Hu_Snapshot_For_Refresh_API.New(source_ref1_         => remrec_.inv_list_no, 
                                   source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT);
END Delete___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT counting_report_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_               VARCHAR2(30);
   value_              VARCHAR2(4000);
   site_check_         NUMBER;
   part_catalog_rec_   Part_Catalog_API.Public_Rec;
BEGIN
   super(newrec_, indrec_, attr_);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   $IF Component_Proj_SYS.INSTALLED $THEN
      IF (newrec_.activity_seq != 0) THEN
         newrec_.project_id := Activity_API.Get_Project_Id(newrec_.activity_seq);
         site_check_ := Project_Site_API.Project_Site_Exist(newrec_.project_id, newrec_.contract);         
      
         IF site_check_ = 0 THEN
            Error_SYS.Record_General(lu_name_,'NOTPRJSITECOUNTREPLINE: Site :P1 is not a valid project site for project :P2.', newrec_.contract, newrec_.project_id);
         END IF;  
      END IF;      
   $END
   
   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);
  
   IF (newrec_.serial_no != '*' AND part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_false) THEN
      Error_SYS.Record_General(lu_name_, 'SERIALNOTMND: A serial number may not be entered for part :P1.', newrec_.part_no);   
   END IF;
   
   IF (newrec_.serial_no = '*' AND part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.DB_SERIAL_TRACKING) THEN
      Error_SYS.Record_General(lu_name_, 'SERIALREQIRED: A serial number needs to be entered for part :P1.', newrec_.part_no);
   END IF;
   
   IF (part_catalog_rec_.lot_tracking_code = Part_Lot_Tracking_API.DB_NOT_LOT_TRACKING) THEN
      IF (newrec_.lot_batch_no != '*') THEN
         Error_SYS.Record_General(lu_name_, 'LOTBATNOTMND: A lot/batch number may not be entered for part :P1.', newrec_.part_no);
      END IF;   
   ELSE
      IF (newrec_.lot_batch_no = '*') THEN
         Error_SYS.Record_General(lu_name_, 'LOTBATCHREQIRED: A lot/batch needs to be entered for part :P1.', newrec_.part_no);
      END IF;       
   END IF; 

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     counting_report_line_tab%ROWTYPE,
   newrec_ IN OUT counting_report_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);
   part_catalog_rec_  Part_Catalog_API.Public_Rec;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (indrec_.part_tracking_session_id) AND
      (oldrec_.part_tracking_session_id IS NOT NULL) AND (newrec_.part_tracking_session_id IS NOT NULL) THEN
      Error_SYS.Item_Update(lu_name_, 'PART_TRACKING_SESSION_ID');
   END IF;

   IF newrec_.qty_count1 < 0 THEN
      Error_SYS.Record_General('CountingReportLine', 'QTYCOUNTPOSITIVE: The counted quantity for the part :P1 at the location :P2 cannot be negative.', newrec_.part_no, newrec_.location_no);
   END IF;
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   IF (newrec_.serial_no <> '*') AND (newrec_.qty_count1 NOT IN (0, 1)) THEN
      Error_SYS.Record_General('CountingReportLine', '761: The quantity may only be 0 or 1 when serial numbers are being used');
   END IF;

   -- Check with part counting control of part availability control if counted quantity is reduced
   IF (newrec_.qty_count1 < newrec_.qty_onhand) THEN
      IF Part_Availability_Control_API.Check_Counting_Control(
               Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_          => newrec_.contract,
                                                                       part_no_           => newrec_.part_no,
                                                                       configuration_id_  => newrec_.configuration_id,
                                                                       location_no_       => newrec_.location_no,
                                                                       lot_batch_no_      => newrec_.lot_batch_no,
                                                                       serial_no_         => newrec_.serial_no,
                                                                       eng_chg_level_     => newrec_.eng_chg_level,
                                                                       waiv_dev_rej_no_   => newrec_.waiv_dev_rej_no,
                                                                       activity_seq_      => newrec_.activity_seq,
                                                                       handling_unit_id_  => newrec_.handling_unit_id)
                                                               ) = 'NOT ALLOW REDUCING' THEN
         Error_SYS.Record_General('CountingReportLine', 'NOTALLOWREDUCING: Reducing quantity is not allowed by Part Availability Control');
       END IF;
   END IF;

   IF NVL(Inventory_Part_In_Stock_API.Get_Qty_Reserved(contract_          => newrec_.contract,
                                                           part_no_           => newrec_.part_no,
                                                           configuration_id_  => newrec_.configuration_id,
                                                           location_no_       => newrec_.location_no,
                                                           lot_batch_no_      => newrec_.lot_batch_no,
                                                           serial_no_         => newrec_.serial_no,
                                                           eng_chg_level_     => newrec_.eng_chg_level,
                                                           waiv_dev_rej_no_   => newrec_.waiv_dev_rej_no,
                                                           activity_seq_      => newrec_.activity_seq,
                                                           handling_unit_id_  => newrec_.handling_unit_id),0) > newrec_.qty_count1 THEN
      Error_SYS.Record_General('CountingReportLine', '753: Counted on-hand quantity :P1 for part :P2 is less than the allocations at location :P3.', newrec_.qty_count1, newrec_.part_no, newrec_.location_no);
   END IF;

   IF ( Check_Line_Confirmed___(newrec_.inv_list_no, newrec_.seq) ) THEN
      Error_SYS.Record_General('CountingReportLine', 'CONFIRMED: The counting report line has already been confirmed!');
   END IF;

   IF (Mpccom_System_Parameter_API.Get_Parameter_Value1('SHORTAGE_HANDLING') = 'Y') THEN
      IF (Inventory_Part_API.Get_Shortage_Flag_Db(newrec_.contract, newrec_.part_no) = 'Y') THEN
         IF (Shortage_Demand_API.Shortage_Exists(newrec_.contract, newrec_.part_no) != 0 ) THEN
            Client_SYS.Add_Info('CountingReportLine', 'SHORTAGEEXIST: There are shortages for part :P1.', newrec_.part_no );
         END IF;
      END IF;
   END IF;

   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);

   IF (part_catalog_rec_.catch_unit_enabled = 'TRUE') THEN
      Check_Catch_Qty_Counting___(newrec_);
   ELSE
      newrec_.catch_qty_counted := NULL;
   END IF;

   IF ( newrec_.qty_count1 != 0 ) THEN
      IF ( part_catalog_rec_.lot_tracking_code IN (Part_Lot_Tracking_API.DB_LOT_TRACKING , Part_Lot_Tracking_API.DB_ORDER_BASED) ) THEN
         IF(newrec_.lot_batch_no = '*') THEN
            Error_SYS.Record_General('CountingReportLine', 'NOTDEFINELOTNO: A lot/batch number must be entered for Seq No :P1 for lot-tracked part :P2.', newrec_.seq, newrec_.part_no);
         END IF;
      ELSIF ( newrec_.lot_batch_no != '*' ) THEN
         Error_SYS.Record_General('CountingReportLine', 'DEFINELOTNO: A lot/batch number cannot be entered for Seq No :P1 for part :P2.', newrec_.seq, newrec_.part_no);
      END IF;
      
      IF(part_catalog_rec_.serial_tracking_code = Part_Serial_Tracking_API.DB_SERIAL_TRACKING) THEN
         IF(newrec_.serial_no = '*') THEN
            Error_SYS.Record_General('CountingReportLine', 'NOTDEFINESERIALNO: A serial number must be entered for Seq No :P1 for serial-tracked part :P2.', newrec_.seq, newrec_.part_no);
         END IF;
      ELSIF ((newrec_.serial_no != '*') AND (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_FALSE)) THEN
         Error_SYS.Record_General('CountingReportLine', 'DEFINESERIALNO: A serial number cannot bee entered for Seq No :P1 for serial-tracked part :P2.', newrec_.seq, newrec_.part_no);
      END IF;
   END IF;
   
   IF (newrec_.qty_count1 IS NULL) OR
      (newrec_.qty_count1 = newrec_.qty_onhand) THEN
      newrec_.part_tracking_session_id := NULL;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


FUNCTION Check_Line_Confirmed___(
   inv_list_no_ IN VARCHAR2,
   seq_         IN NUMBER ) RETURN BOOLEAN
IS
   confirmed_ BOOLEAN := FALSE;
   dummy_     NUMBER;
   
   CURSOR check_confirmed IS
      SELECT 1
      FROM   counting_report_line_tab
      WHERE  inv_list_no = inv_list_no_
      AND    seq = seq_
      AND    confirmed = Fnd_Boolean_API.DB_TRUE;
BEGIN
   OPEN check_confirmed;
   FETCH check_confirmed INTO dummy_;
   IF check_confirmed%FOUND THEN
      confirmed_ := TRUE;
   ELSE
      confirmed_ := FALSE;
   END IF;
   CLOSE check_confirmed;
   RETURN confirmed_;
END Check_Line_Confirmed___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Remove__
--   Checks if there are any open counting report for this part
PROCEDURE Check_Remove__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER)
IS
   unconf_part_line_exist_ VARCHAR2(5);
   rej_part_line_exist_    VARCHAR2(5);
BEGIN
   Trace_SYS.Message('Inside Check_Remove__');
   unconf_part_line_exist_ := Check_Unconfirmed_Part_Loc(contract_         => contract_,
                                                         part_no_          => part_no_,
                                                         configuration_id_ => configuration_id_,
                                                         location_no_      => location_no_,
                                                         lot_batch_no_     => lot_batch_no_,
                                                         serial_no_        => serial_no_,
                                                         eng_chg_level_    => eng_chg_level_,
                                                         waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                         activity_seq_     => activity_seq_,
                                                         handling_unit_id_ => handling_unit_id_);
   IF unconf_part_line_exist_ = 'TRUE' THEN
      Error_SYS.Record_General(lu_name_, 'NO_DELETE_CONF: This record is found on a counting report line that has not yet been confirmed. Removal is not allowed.');
   ELSE
      rej_part_line_exist_ := Counting_Result_API.Check_Rejected_Part_Location(contract_           => contract_,
                                                                               part_no_            => part_no_,
                                                                               configuration_id_   => configuration_id_,
                                                                               location_no_        => location_no_,
                                                                               lot_batch_no_       => lot_batch_no_,
                                                                               serial_no_          => serial_no_,
                                                                               eng_chg_level_      => eng_chg_level_,
                                                                               waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                                               activity_seq_       => activity_seq_,
                                                                               handling_unit_id_   => handling_unit_id_);
      IF rej_part_line_exist_ = 'TRUE' THEN
         Error_SYS.Record_General(lu_name_, 'NO_DELETE_REJ: This record is found on a rejected counting result. Removal is not allowed.');
      END IF;
   END IF;
END Check_Remove__;

PROCEDURE Do_Remove__ (
   inv_list_no_ IN VARCHAR2)
IS
   objid_      counting_report_line.objid%TYPE;
   objversion_ counting_report_line.objversion%TYPE;
   
   CURSOR get_rec IS
      SELECT *
      FROM Counting_Report_Line_Tab
      WHERE inv_list_no = inv_list_no_;
BEGIN
   Trace_SYS.Message('Inside Do_Remove__');
   Inventory_Event_Manager_API.Start_Session;
   FOR remrec_ IN get_rec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.inv_list_no, remrec_.seq);
      remrec_ := Lock_By_Keys___(remrec_.inv_list_no, remrec_.seq);
      Delete___(objid_, remrec_);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Do_Remove__;

PROCEDURE Count_Line_Without_Diff__ (
   objid_             IN     VARCHAR2,
   objversion_        IN OUT VARCHAR2,
   qty_count1_        IN     NUMBER,
   catch_qty_counted_ IN     NUMBER )
IS
   oldrec_ counting_report_line_tab%ROWTYPE;
BEGIN
   oldrec_:= Lock_By_Id___(objid_, objversion_);
   Count_Line_Without_Diff (oldrec_.inv_list_no, oldrec_.seq, qty_count1_, catch_qty_counted_);
END Count_Line_Without_Diff__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_No_Uncounted_Rows
--   Returns the number of uncounted rows in the counting report.
@UncheckedAccess
FUNCTION Get_No_Uncounted_Rows (
   inv_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR cnt_cur IS
      SELECT COUNT(*)
      FROM   counting_report_line_tab
      WHERE  qty_count1 IS NULL
      AND    inv_list_no = inv_list_no_;
   ret_ NUMBER;
BEGIN
   OPEN   cnt_cur;
   FETCH  cnt_cur INTO ret_;
   CLOSE  cnt_cur;
   RETURN ret_;
END Get_No_Uncounted_Rows;


-- New_List_Detail
--   Creates a new entry with specified part on the counting report.
PROCEDURE New_List_Detail (
   inv_list_no_           IN VARCHAR2,
   seq_                   IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   location_no_           IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,
   cost_                  IN NUMBER,
   qty_onhand_            IN NUMBER,
   catch_qty_onhand_      IN NUMBER,
   userid_                IN VARCHAR2,
   warehouse_route_order_ IN VARCHAR2,
   bay_route_order_       IN VARCHAR2,
   row_route_order_       IN VARCHAR2,
   tier_route_order_      IN VARCHAR2,
   bin_route_order_       IN VARCHAR2)
IS
   newrec_                  counting_report_line_tab%ROWTYPE;
   qty_onhand_temp_         NUMBER:=0;
   catch_qty_onhand_temp_   NUMBER:=0;
BEGIN
   
   IF (Inventory_Part_In_Stock_API.Check_Exist(contract_,
                                               part_no_,
                                               configuration_id_, 
                                               location_no_, 
                                               lot_batch_no_,
                                               serial_no_,
                                               eng_chg_level_,
                                               waiv_dev_rej_no_,
                                               activity_seq_,
                                               handling_unit_id_)= FALSE) THEN
                                              
      Inventory_Part_In_Stock_API.Create_Empty_Stock_Record(contract_, 
                                                            part_no_, 
                                                            location_no_, 
                                                            configuration_id_, 
                                                            lot_batch_no_, 
                                                            serial_no_,
                                                            eng_chg_level_,
                                                            waiv_dev_rej_no_,
                                                            activity_seq_,
                                                            handling_unit_id_); 
                                                            
   ELSE
      qty_onhand_temp_       := qty_onhand_;
      catch_qty_onhand_temp_ := catch_qty_onhand_;
   END IF;                                           
   
   newrec_.inv_list_no           := inv_list_no_;
   newrec_.seq                   := seq_;
   newrec_.contract              := contract_;
   newrec_.part_no               := part_no_;
   newrec_.configuration_id      := configuration_id_;
   newrec_.location_no           := location_no_;
   newrec_.lot_batch_no          := lot_batch_no_;
   newrec_.serial_no             := serial_no_;
   newrec_.eng_chg_level         := eng_chg_level_;
   newrec_.waiv_dev_rej_no       := waiv_dev_rej_no_;
   newrec_.activity_seq          := activity_seq_;
   newrec_.handling_unit_id      := handling_unit_id_;
   newrec_.cost                  := cost_;
   newrec_.qty_onhand            := qty_onhand_temp_;
   newrec_.catch_qty_onhand      := catch_qty_onhand_temp_;
   newrec_.userid                := userid_;
   newrec_.warehouse_route_order := warehouse_route_order_;
   newrec_.bay_route_order       := bay_route_order_;
   newrec_.row_route_order       := row_route_order_;
   newrec_.tier_route_order      := tier_route_order_;
   newrec_.bin_route_order       := bin_route_order_;
   New___(newrec_);
END New_List_Detail;


-- Any_Counted_Lines
--   Check if there are any counted lines for a specific counting report.
FUNCTION Any_Counted_Lines (
   inv_list_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_   NUMBER;

   CURSOR get_qty_count IS
      SELECT 1
      FROM counting_report_line_tab
      WHERE inv_list_no = inv_list_no_
      AND qty_count1 IS NOT NULL;
BEGIN
   OPEN get_qty_count;
   FETCH get_qty_count INTO dummy_;
   IF (get_qty_count%FOUND) THEN
      CLOSE get_qty_count;
      RETURN(TRUE);
   END IF;
   CLOSE get_qty_count;
   RETURN(FALSE);
END Any_Counted_Lines;


FUNCTION Get_No_Counted_Lines (
   inv_list_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR cnt_cur IS
      SELECT COUNT(*)
      FROM   counting_report_line_tab
      WHERE  qty_count1 IS NOT NULL
      AND    inv_list_no = inv_list_no_;
   ret_ NUMBER;      
BEGIN
   OPEN   cnt_cur;
   FETCH  cnt_cur INTO ret_;
   CLOSE  cnt_cur;
   RETURN ret_;
END Get_No_Counted_Lines;


-- Reset_Freeze_Flag
--   Resets the freeze flag if not set for the same part in any other
--   counting report.
PROCEDURE Reset_Freeze_Flag (
   inv_list_no_ IN VARCHAR2 )
IS
   CURSOR get_uncount IS
      SELECT contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, configuration_id
      FROM counting_report_line_tab
      WHERE qty_count1 IS NULL
      AND inv_list_no = inv_list_no_;
BEGIN
   FOR uncount_rec_ IN get_uncount LOOP
     IF (Counting_Result_API.Check_Rejected_Part_Location(contract_           => uncount_rec_.contract,
                                                          part_no_            => uncount_rec_.part_no,
                                                          configuration_id_   => uncount_rec_.configuration_id,
                                                          location_no_        => uncount_rec_.location_no,
                                                          lot_batch_no_       => uncount_rec_.lot_batch_no,
                                                          serial_no_          => uncount_rec_.serial_no,
                                                          eng_chg_level_      => uncount_rec_.eng_chg_level,
                                                          waiv_dev_rej_no_    => uncount_rec_.waiv_dev_rej_no,
                                                          activity_seq_       => uncount_rec_.activity_seq,
                                                          handling_unit_id_   => uncount_rec_.handling_unit_id) = 'FALSE') THEN

         Inventory_Part_In_Stock_API.Reset_Freeze_Flag(contract_           => uncount_rec_.contract,
                                                       part_no_            => uncount_rec_.part_no,
                                                       configuration_id_   => uncount_rec_.configuration_id,
                                                       location_no_        => uncount_rec_.location_no,
                                                       lot_batch_no_       => uncount_rec_.lot_batch_no,
                                                       serial_no_          => uncount_rec_.serial_no,
                                                       eng_chg_level_      => uncount_rec_.eng_chg_level,
                                                       waiv_dev_rej_no_    => uncount_rec_.waiv_dev_rej_no,
                                                       activity_seq_       => uncount_rec_.activity_seq,
                                                       handling_unit_id_   => uncount_rec_.handling_unit_id);
     END IF;
   END LOOP;
END Reset_Freeze_Flag;


-- Remove_Uncounted_Lines
--   Resets the part location freeze code and removes uncounted lines in the report.
PROCEDURE Remove_Uncounted_Lines (
   inv_list_no_         IN VARCHAR2 )
IS
   objid_           counting_report_line.objid%TYPE;
   objversion_      counting_report_line.objversion%TYPE;
   uncount_removed_ BOOLEAN := FALSE;

   CURSOR get_uncount IS
      SELECT *
      FROM counting_report_line_tab
      WHERE qty_count1 IS NULL
      AND inv_list_no = inv_list_no_;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR uncount_rec_ IN get_uncount LOOP
      uncount_removed_ := TRUE;
      IF (Counting_Result_API.Check_Rejected_Part_Location(contract_           => uncount_rec_.contract,
                                                           part_no_            => uncount_rec_.part_no,
                                                           configuration_id_   => uncount_rec_.configuration_id,
                                                           location_no_        => uncount_rec_.location_no,
                                                           lot_batch_no_       => uncount_rec_.lot_batch_no,
                                                           serial_no_          => uncount_rec_.serial_no,
                                                           eng_chg_level_      => uncount_rec_.eng_chg_level,
                                                           waiv_dev_rej_no_    => uncount_rec_.waiv_dev_rej_no,
                                                           activity_seq_       => uncount_rec_.activity_seq,
                                                           handling_unit_id_   => uncount_rec_.handling_unit_id) = 'FALSE') THEN

          Inventory_Part_In_Stock_API.Reset_Freeze_Flag(contract_           => uncount_rec_.contract,
                                                        part_no_            => uncount_rec_.part_no,
                                                        configuration_id_   => uncount_rec_.configuration_id,
                                                        location_no_        => uncount_rec_.location_no,
                                                        lot_batch_no_       => uncount_rec_.lot_batch_no,
                                                        serial_no_          => uncount_rec_.serial_no,
                                                        eng_chg_level_      => uncount_rec_.eng_chg_level,
                                                        waiv_dev_rej_no_    => uncount_rec_.waiv_dev_rej_no,
                                                        activity_seq_       => uncount_rec_.activity_seq,
                                                        handling_unit_id_   => uncount_rec_.handling_unit_id);
      END IF;

      --delete the uncounted lines
      Get_Id_Version_By_Keys___(objid_, objversion_, uncount_rec_.inv_list_no, uncount_rec_.seq);
      Check_Delete___(uncount_rec_);
      Delete___(objid_, uncount_rec_);
   END LOOP;
   
   IF NOT uncount_removed_ THEN
      Error_SYS.Record_General(lu_name_, 'NOUNCOUNTLINES: This count report does not contain uncounted lines for removal.');
   END IF;
  Inventory_Event_Manager_API.Finish_Session;
END Remove_Uncounted_Lines;


-- Check_Unconfirmed_Lines
--   Check if there are any unconfirmed lines for a specific counting report.
@UncheckedAccess
FUNCTION Check_Unconfirmed_Lines (
   inv_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_                   NUMBER;
   unconfirmed_lines_exist_ VARCHAR2(5) := 'FALSE';
   db_false_                VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR exist_control IS
      SELECT 1
        FROM counting_report_line_tab 
       WHERE inv_list_no = inv_list_no_
         AND confirmed   = db_false_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      unconfirmed_lines_exist_ := 'TRUE';
   END IF;
   CLOSE exist_control;

   RETURN (unconfirmed_lines_exist_);
END Check_Unconfirmed_Lines;


-- Confirm_All_Counted_Lines
--   Confirms all the counted lines for the count report.
PROCEDURE Confirm_All_Counted_Lines (
   inv_list_no_ IN VARCHAR2 )
IS
   state_               VARCHAR2(20);
   condition_code_      VARCHAR2(10);
   records_exist_       BOOLEAN := FALSE;
   db_false_            VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR get_counted IS
      SELECT *
      FROM   counting_report_line_tab crl
      WHERE  qty_count1 IS NOT NULL
      AND    crl.inv_list_no = inv_list_no_
      AND    confirmed = db_false_;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR count_rec_ IN get_counted LOOP
        condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(count_rec_.part_no, count_rec_.serial_no, count_rec_.lot_batch_no);
        Counting_Result_API.New_Result(state_                     => state_,
                                       contract_                  => count_rec_.contract,
                                       part_no_                   => count_rec_.part_no,
                                       configuration_id_          => count_rec_.configuration_id,
                                       location_no_               => count_rec_.location_no,
                                       lot_batch_no_              => count_rec_.lot_batch_no,
                                       serial_no_                 => count_rec_.serial_no,
                                       eng_chg_level_             => count_rec_.eng_chg_level,
                                       waiv_dev_rej_no_           => count_rec_.waiv_dev_rej_no,
                                       activity_seq_              => count_rec_.activity_seq,
                                       handling_unit_id_          => count_rec_.handling_unit_id,
                                       count_date_                => count_rec_.last_count_date,
                                       inv_list_no_               => count_rec_.inv_list_no,
                                       seq_                       => count_rec_.seq,
                                       qty_onhand_                => count_rec_.qty_onhand,
                                       qty_counted_               => count_rec_.qty_count1,
                                       catch_qty_onhand_          => count_rec_.catch_qty_onhand,
                                       catch_qty_counted_         => count_rec_.catch_qty_counted,
                                       count_user_id_             => count_rec_.userid,
                                       inventory_value_           => NULL,
                                       condition_code_            => condition_code_,
                                       note_text_                 => count_rec_.note_text,
                                       cost_detail_id_            => NULL,
                                       part_tracking_session_id_  => count_rec_.part_tracking_session_id);
        records_exist_ := TRUE;
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
   IF NOT(records_exist_) THEN
      Error_SYS.Record_General(lu_name_,'NORECORDEXIST: The lines for which counting has been performed have already been confirmed.');      
   END IF;
END Confirm_All_Counted_Lines;


-- Count_All_Lines_Without_Diff
--   Sets the quantity counted to the quantity on hand for all uncounted
--   lines for the count report.
PROCEDURE Count_All_Lines_Without_Diff (
   inv_list_no_ IN VARCHAR2 )
IS
   inv_part_in_stock_rec_  Inventory_Part_In_Stock_API.Public_Rec;

   CURSOR get_uncount IS
      SELECT *
      FROM counting_report_line_tab
      WHERE qty_count1 IS NULL
      AND inv_list_no = inv_list_no_;

BEGIN
   FOR uncount_rec_ IN get_uncount LOOP
      inv_part_in_stock_rec_ := Inventory_Part_In_Stock_API.Get(contract_           => uncount_rec_.contract,
                                                                part_no_            => uncount_rec_.part_no,
                                                                configuration_id_   => uncount_rec_.configuration_id,
                                                                location_no_        => uncount_rec_.location_no,
                                                                lot_batch_no_       => uncount_rec_.lot_batch_no,
                                                                serial_no_          => uncount_rec_.serial_no,
                                                                eng_chg_level_      => uncount_rec_.eng_chg_level,
                                                                waiv_dev_rej_no_    => uncount_rec_.waiv_dev_rej_no,
                                                                activity_seq_       => uncount_rec_.activity_seq,
                                                                handling_unit_id_   => uncount_rec_.handling_unit_id);

      Count_Line_Without_Diff(inv_list_no_, uncount_rec_.seq, inv_part_in_stock_rec_.qty_onhand, inv_part_in_stock_rec_.catch_qty_onhand);
   END LOOP;
END Count_All_Lines_Without_Diff;


PROCEDURE Count_As_Non_Existing (
   inv_list_no_              IN VARCHAR2,
   seq_                      IN NUMBER )
IS
   oldrec_        counting_report_line_tab%ROWTYPE;
   newrec_        counting_report_line_tab%ROWTYPE;
   inv_part_rec_  Inventory_Part_In_Stock_API.Public_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(inv_list_no_,seq_);
   newrec_ := oldrec_;
   inv_part_rec_ := Inventory_Part_In_Stock_API.Get(contract_           => oldrec_.contract,
                                                    part_no_            => oldrec_.part_no,
                                                    configuration_id_   => oldrec_.configuration_id,
                                                    location_no_        => oldrec_.location_no,
                                                    lot_batch_no_       => oldrec_.lot_batch_no,
                                                    serial_no_          => oldrec_.serial_no,
                                                    eng_chg_level_      => oldrec_.eng_chg_level,
                                                    waiv_dev_rej_no_    => oldrec_.waiv_dev_rej_no,
                                                    activity_seq_       => oldrec_.activity_seq,
                                                    handling_unit_id_   => oldrec_.handling_unit_id );
   newrec_.qty_count1 := 0;
   newrec_.qty_onhand := inv_part_rec_.qty_onhand;
   IF (inv_part_rec_.catch_qty_onhand IS NOT NULL) THEN
      newrec_.catch_qty_counted := 0;
      newrec_.catch_qty_onhand := inv_part_rec_.catch_qty_onhand;
   END IF;
   Modify___(newrec_);
END Count_As_Non_Existing;


-- Count_Line_Without_Diff
--   Sets the quantity counted to the quantity on hand for an uncounted
--   line for the count report.
PROCEDURE Count_Line_Without_Diff (
   inv_list_no_       IN VARCHAR2,
   seq_               IN NUMBER,
   qty_count1_        IN NUMBER,
   catch_qty_counted_ IN NUMBER )
IS
   newrec_              counting_report_line_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(inv_list_no_,seq_);
   newrec_.qty_count1        := qty_count1_;
   newrec_.qty_onhand        := qty_count1_;
   newrec_.catch_qty_counted := catch_qty_counted_;
   newrec_.catch_qty_onhand  := catch_qty_counted_;
   Modify___(newrec_);
END Count_Line_Without_Diff;


-- Check_Unconfirmed_Part_Loc
--   Check if there are any unconfirmed lines for a specific part location
--   on any count report.
@UncheckedAccess
FUNCTION Check_Unconfirmed_Part_Loc (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   ret_      VARCHAR2(10);
   db_false_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR check_cur IS
      SELECT 1
      FROM   counting_report_line_tab
      WHERE  contract           = contract_
      AND    part_no            = part_no_
      AND    configuration_id   = configuration_id_
      AND    location_no        = location_no_
      AND    lot_batch_no       = lot_batch_no_
      AND    serial_no          = serial_no_
      AND    eng_chg_level      = eng_chg_level_
      AND    waiv_dev_rej_no    = waiv_dev_rej_no_
      AND    activity_seq       = activity_seq_
      AND    handling_unit_id   = handling_unit_id_
      AND    confirmed          = db_false_;
BEGIN
   OPEN   check_cur;
   FETCH  check_cur INTO ret_;
   IF (check_cur%FOUND) THEN
      CLOSE check_cur;
      RETURN 'TRUE';
   ELSE
      CLOSE check_cur;
      RETURN 'FALSE';
   END IF;
END Check_Unconfirmed_Part_Loc;


-- Get_Count_Report_No
--   Gets the count report number for a part on a specific location.
@UncheckedAccess
FUNCTION Get_Count_Report_No (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   temp_     counting_report_line_tab.inv_list_no%TYPE;
   db_false_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR get_report IS
      SELECT distinct inv_list_no
      FROM   counting_report_line_tab
      WHERE  contract           = contract_
      AND    part_no            = part_no_
      AND    configuration_id   = configuration_id_
      AND    location_no        = location_no_
      AND    lot_batch_no       = lot_batch_no_
      AND    serial_no          = serial_no_
      AND    eng_chg_level      = eng_chg_level_
      AND    waiv_dev_rej_no    = waiv_dev_rej_no_
      AND    activity_seq       = activity_seq_
      AND    handling_unit_id   = handling_unit_id_
      AND    confirmed          = db_false_;
BEGIN
   OPEN get_report;
   FETCH get_report INTO temp_;
   CLOSE get_report;
   RETURN temp_;
END Get_Count_Report_No;


-- Get_Seq_No
--   Gets the Sequence Number.
@UncheckedAccess
FUNCTION Get_Seq_No (
   inv_list_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN NUMBER
IS
   temp_ counting_report_line_tab.seq%TYPE;

   CURSOR get_report IS
      SELECT seq
      FROM   counting_report_line_tab 
      WHERE  inv_list_no        = inv_list_no_
      AND    contract           = contract_
      AND    part_no            = part_no_
      AND    configuration_id   = configuration_id_
      AND    location_no        = location_no_
      AND    lot_batch_no       = lot_batch_no_
      AND    serial_no          = serial_no_
      AND    eng_chg_level      = eng_chg_level_
      AND    waiv_dev_rej_no    = waiv_dev_rej_no_
      AND    activity_seq       = activity_seq_
      AND    handling_unit_id   = handling_unit_id_;
BEGIN
   OPEN get_report;
   FETCH get_report INTO temp_;
   CLOSE get_report;
   RETURN temp_;
END Get_Seq_No;


-- Get_Location_No
--   Gets the current location of handling unit.
@UncheckedAccess
FUNCTION Get_Location_No (
   inv_list_no_      IN VARCHAR2,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   temp_ counting_report_line_tab.location_no%TYPE;

   CURSOR get_report IS
      SELECT DISTINCT location_no
      FROM   counting_report_line_tab 
      WHERE  inv_list_no        = inv_list_no_
      AND    handling_unit_id   = handling_unit_id_;
BEGIN
   OPEN get_report;
   FETCH get_report INTO temp_;
   CLOSE get_report;
   RETURN temp_;
END Get_Location_No;


-- Get_Qty_Counted
--   Gets the quantity counted.
@UncheckedAccess
FUNCTION Get_Qty_Counted (
   inv_list_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN NUMBER
IS
   temp_ counting_report_line_tab.qty_count1%TYPE;

   CURSOR get_report IS
      SELECT qty_count1
      FROM   counting_report_line_tab 
      WHERE  inv_list_no        = inv_list_no_
      AND    contract           = contract_
      AND    part_no            = part_no_
      AND    configuration_id   = configuration_id_
      AND    location_no        = location_no_
      AND    lot_batch_no       = lot_batch_no_
      AND    serial_no          = serial_no_
      AND    eng_chg_level      = eng_chg_level_
      AND    waiv_dev_rej_no    = waiv_dev_rej_no_
      AND    activity_seq       = activity_seq_
      AND    handling_unit_id   = handling_unit_id_;
BEGIN
   OPEN get_report;
   FETCH get_report INTO temp_;
   CLOSE get_report;
   RETURN temp_;
END Get_Qty_Counted;


-- Get_Last_Count_Date
--   Gets the last count date.
@UncheckedAccess
FUNCTION Get_Last_Count_Date (
   inv_list_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN counting_report_line_tab.last_count_date%TYPE
IS
   temp_ counting_report_line_tab.last_count_date%TYPE;

   CURSOR get_report IS
      SELECT last_count_date
      FROM   counting_report_line_tab 
      WHERE  inv_list_no        = inv_list_no_
      AND    contract           = contract_
      AND    part_no            = part_no_
      AND    configuration_id   = configuration_id_
      AND    location_no        = location_no_
      AND    lot_batch_no       = lot_batch_no_
      AND    serial_no          = serial_no_
      AND    eng_chg_level      = eng_chg_level_
      AND    waiv_dev_rej_no    = waiv_dev_rej_no_
      AND    activity_seq       = activity_seq_
      AND    handling_unit_id   = handling_unit_id_;
BEGIN
   OPEN get_report;
   FETCH get_report INTO temp_;
   CLOSE get_report;
   RETURN temp_;
END Get_Last_Count_Date;

PROCEDURE Confirm_Line (
   inv_list_no_         IN VARCHAR2,
   seq_                 IN NUMBER)
IS
   lu_rec_         counting_report_line_tab%ROWTYPE;
   condition_code_ VARCHAR2(10);
   state_          VARCHAR2(20);
 
   CURSOR getrec IS
      SELECT *
      FROM   counting_report_line_tab crl
      WHERE qty_count1 IS NOT NULL
      AND   crl.inv_list_no      = inv_list_no_
      AND   crl.seq              = seq_;

BEGIN
   OPEN getrec;
   FETCH getrec INTO lu_rec_;
   IF (getrec%NOTFOUND) THEN
      CLOSE getrec;
      return;
   END IF;
   CLOSE getrec;
   condition_code_ := Condition_Code_Manager_API.Get_Condition_Code(lu_rec_.part_no, 
                                                                    lu_rec_.serial_no, 
                                                                    lu_rec_.lot_batch_no);
   Counting_Result_API.New_Result(state_                    => state_,
                                  contract_                 => lu_rec_.contract,
                                  part_no_                  => lu_rec_.part_no,
                                  configuration_id_         => lu_rec_.configuration_id,
                                  location_no_              => lu_rec_.location_no,
                                  lot_batch_no_             => lu_rec_.lot_batch_no,
                                  serial_no_                => lu_rec_.serial_no,
                                  eng_chg_level_            => lu_rec_.eng_chg_level,
                                  waiv_dev_rej_no_          => lu_rec_.waiv_dev_rej_no,
                                  activity_seq_             => lu_rec_.activity_seq,
                                  handling_unit_id_         => lu_rec_.handling_unit_id,
                                  count_date_               => lu_rec_.last_count_date,
                                  inv_list_no_              => inv_list_no_,
                                  seq_                      => seq_,
                                  qty_onhand_               => lu_rec_.qty_onhand,
                                  qty_counted_              => lu_rec_.qty_count1,
                                  catch_qty_onhand_         => lu_rec_.catch_qty_onhand,
                                  catch_qty_counted_        => lu_rec_.catch_qty_counted,
                                  count_user_id_            => lu_rec_.userid,
                                  inventory_value_          => NULL,
                                  condition_code_           => condition_code_,
                                  note_text_                => lu_rec_.note_text,
                                  cost_detail_id_           => NULL,
                                  part_tracking_session_id_ => lu_rec_.part_tracking_session_id);
END Confirm_Line;


@UncheckedAccess
FUNCTION Tracking_Id_Is_On_Nonconfirmed (
   part_tracking_session_id_ IN NUMBER ) RETURN BOOLEAN
IS
   track_id_is_on_nonconfirmed_ BOOLEAN := FALSE;

   CURSOR get_counting_report_lines IS
      SELECT contract,
             part_no,
             configuration_id,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             activity_seq,
             handling_unit_id,
             last_count_date
        FROM counting_report_line_tab
       WHERE part_tracking_session_id = part_tracking_session_id_;
BEGIN

   FOR rec_ IN get_counting_report_lines LOOP
      IF (Counting_Result_API.Check_Exist(contract_         => rec_.contract,
                                          part_no_          => rec_.part_no,
                                          configuration_id_ => rec_.configuration_id,
                                          location_no_      => rec_.location_no,
                                          lot_batch_no_     => rec_.lot_batch_no,
                                          serial_no_        => rec_.serial_no,
                                          eng_chg_level_    => rec_.eng_chg_level,
                                          waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,
                                          activity_seq_     => rec_.activity_seq,
                                          handling_unit_id_ => rec_.handling_unit_id,
                                          count_date_       => rec_.last_count_date) != 'TRUE') THEN
            track_id_is_on_nonconfirmed_ := TRUE;
            EXIT;
      END IF;
   END LOOP;

   RETURN track_id_is_on_nonconfirmed_;
END Tracking_Id_Is_On_Nonconfirmed;


--   This Count_And_Confirm_Line method is used from DataCaptureCountReport
PROCEDURE Count_And_Confirm_Line (
   inv_list_no_ IN     VARCHAR2,
   seq_         IN     NUMBER,
   attr_        IN OUT VARCHAR2,
   confirm_     IN     VARCHAR2 )
IS
   oldrec_     counting_report_line_tab%ROWTYPE;
   newrec_     counting_report_line_tab%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      counting_report_line.objid%TYPE;
   objversion_ counting_report_line.objversion%TYPE;
BEGIN

   oldrec_ := Lock_By_Keys___(inv_list_no_, seq_);
   newrec_ := oldrec_;

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

   IF confirm_ = Gen_Yes_No_API.db_yes THEN 
      Confirm_Line(inv_list_no_, seq_);
   END IF;
END Count_And_Confirm_Line;


-- This method is used by DataCaptCountPartRep 
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   seq_                        IN NUMBER,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   configuration_id_           IN VARCHAR2, 
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   lov_id_                     IN NUMBER DEFAULT 1,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL)
IS
   TYPE Get_Lov_Values     IS REF CURSOR;
   get_lov_values_         Get_Lov_Values;
   stmt_                   VARCHAR2(4000);
   TYPE Lov_Value_Tab      IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_          Lov_Value_Tab;
   tmp_seq_                NUMBER;
   tmp_part_no_            VARCHAR2(25);
   tmp_location_no_        VARCHAR2(35);
   lov_item_description_   VARCHAR2(200);
   loc_desc_               VARCHAR2(200);
   part_desc_              VARCHAR2(200);
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   seq_in_a_loop_          BOOLEAN := FALSE;
   lov_row_limitation_     NUMBER;
   exit_lov_               BOOLEAN := FALSE;
   temp_handling_unit_id_  NUMBER;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF lov_id_ = 1 THEN  -- using COUNTING_REPORT_LINE_EXTENDED as data source

         -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
         Assert_SYS.Assert_Is_View_Column('COUNTING_REPORT_LINE_EXTENDED', column_name_);
   
         IF (lov_type_db_ = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
            -- Don't use DISTINCT select for AUTO PICK
            stmt_ := 'SELECT ' || column_name_;
         ELSE
            stmt_ := 'SELECT DISTINCT ' || column_name_;
         END IF;
         stmt_ := stmt_  || ' FROM COUNTING_REPORT_LINE_EXTENDED crl
                              WHERE contract         = :contract_
                              AND   qty_count1       IS NULL';

         IF inv_list_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
         END IF;
         IF seq_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :seq_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND seq = :seq_';
         END IF;
         IF part_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :part_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND part_no = :part_no_';
         END IF;
         IF location_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :location_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND location_no = :location_no_';
         END IF;
         IF serial_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND serial_no = :serial_no_';
         END IF;
         IF lot_batch_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
         END IF;
         IF waiv_dev_rej_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
         END IF;
         IF eng_chg_level_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
         END IF;
         IF configuration_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
         END IF;
         IF activity_seq_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
         END IF;
         IF handling_unit_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
         END IF;
         IF alt_handling_unit_label_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
         ELSIF alt_handling_unit_label_id_ = '%' THEN
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
         END IF;

         IF (sql_where_expression_ IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND ' || sql_where_expression_;
         END IF;
   
         -- Add extra filtering of earlier scanned values of this data item to dynamic cursor if data item is SEQ and is in a loop for this configuration
         IF (column_name_ = 'SEQ') THEN
            IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, column_name_)) THEN
               stmt_ := stmt_  || ' AND NOT EXISTS (SELECT 1 FROM DATA_CAPTURE_SESSION_LINE_PUB WHERE capture_session_id = :capture_session_id_
                                                                                                 AND  data_item_id = ''SEQ''
                                                                                                 AND  data_item_detail_id IS NULL
                                                                                                 AND  data_item_value = TO_CHAR(seq)) ';   
               seq_in_a_loop_ := TRUE;
            END IF;
         END IF;
         IF (column_name_ != 'SEQ') THEN
            -- Breaking the regular wadaco sort order to keep the original sort order from COUNTING_REPORT_LINE_EXTENDED
            -- so it will follow how the regular client now works when adding new report lines, so if the user is using
            -- the similar wadaco process for that they will get the same order as the client and can count the newly added
            -- lines first, before it continues with the rest of the report lines.
            -- For LOV 2 we cannot do the same since we need to keep the aggregated tab sort order when coming from the start count report process
            -- which is not 100% the same as the sort order in the Details tab (it has sorting on part, serial and lotbatch that we dont have here).
            stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
         END IF;
   
         IF (seq_in_a_loop_) THEN
            @ApproveDynamicStatement(2014-11-03,CHJALK)
            OPEN get_lov_values_ FOR stmt_ USING contract_,
                                                 inv_list_no_,
                                                 seq_,
                                                 part_no_,
                                                 location_no_,
                                                 serial_no_,
                                                 lot_batch_no_,
                                                 waiv_dev_rej_no_,
                                                 eng_chg_level_,
                                                 configuration_id_,
                                                 activity_seq_,
                                                 handling_unit_id_,
                                                 alt_handling_unit_label_id_,
                                                 capture_session_id_;
         ELSE
            @ApproveDynamicStatement(2014-11-03,CHJALK)
            OPEN get_lov_values_ FOR stmt_ USING contract_,
                                                 inv_list_no_,
                                                 seq_,
                                                 part_no_,
                                                 location_no_,
                                                 serial_no_,
                                                 lot_batch_no_,
                                                 waiv_dev_rej_no_,
                                                 eng_chg_level_,
                                                 configuration_id_,
                                                 activity_seq_,
                                                 handling_unit_id_,
                                                 alt_handling_unit_label_id_;
         END IF;

      -- If this process is used together with the START_COUNT_REPORT process we need to break (the SEQ) sorting and add route order sorting 
      -- similar to the aggregated tab. This so we can group the lines connected to a specific location and handling unit id together. 
      -- One difference is that handling unit 0 lines will come before handling unit lines on the same location due to how oracle sort 
      -- 0 and NULL differently, while they come after handling units lines in tab (handling unit id for these lines are NULL in 
      -- aggregated tab but 0 here).
      ELSIF lov_id_ = 2 THEN  -- using COUNTING_REPORT_PART_PROCESS as a data source and different sorting
         -- No seq_in_a_loop_ handling in this LOV variant since this variant is more of 1 record at the time and then back to 
         -- Start Process for the next record without Loops inside Part Process

         -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
         Assert_SYS.Assert_Is_View_Column('COUNTING_REPORT_PART_PROCESS', column_name_);

         stmt_ := 'SELECT ' || column_name_;
         stmt_ := stmt_  || ' FROM COUNTING_REPORT_PART_PROCESS 
                              WHERE contract         = :contract
                              AND   qty_count1       IS NULL';
         IF inv_list_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
         END IF;
         IF seq_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :seq_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND seq = :seq_';
         END IF;
         IF part_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :part_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND part_no = :part_no_';
         END IF;
         IF location_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :location_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND location_no = :location_no_';
         END IF;
         IF serial_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND serial_no = :serial_no_';
         END IF;
         IF lot_batch_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
         END IF;
         IF waiv_dev_rej_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
         END IF;
         IF eng_chg_level_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
         END IF;
         IF configuration_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
         END IF;
         IF activity_seq_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
         END IF;
         IF handling_unit_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
         END IF;
         IF alt_handling_unit_label_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
         ELSIF alt_handling_unit_label_id_ = '%' THEN
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
         END IF;

         IF (sql_where_expression_ IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND ' || sql_where_expression_;
         END IF;
   
         --stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
   
         -- Add the general route order sorting 
         -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
         -- since this needs be route order sorted. 
         -- The decode in top_parent_handling_unit_id handling and the NVL on structure_level is so broken handling units 
         -- (hu id != 0 and outmost hu = NULL) will come after non handling units and before complete handlings units per location.
         stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(warehouse_route_order) ASC, 
                                       UPPER(warehouse_route_order) ASC,
                                       Utility_SYS.String_To_Number(bay_route_order) ASC, 
                                       UPPER(decode(bay_route_order, ''  -'', :last_character, bay_route_order)) ASC, 
                                       Utility_SYS.String_To_Number(row_route_order) ASC, 
                                       UPPER(decode(row_route_order, ''  -'', :last_character,row_route_order)) ASC,
                                       Utility_SYS.String_To_Number(tier_route_order) ASC, 
                                       UPPER(decode(tier_route_order, ''  -'', :last_character, tier_route_order)) ASC, 
                                       Utility_SYS.String_To_Number(bin_route_order) ASC, 
                                       UPPER(decode(bin_route_order, ''  -'', :last_character, bin_route_order)) ASC,
                                       location_no,
                                       NVL(top_parent_handling_unit_id, DECODE(outermost_handling_unit_id,NULL,0,handling_unit_id)),
                                       NVL(structure_level,0),
                                       handling_unit_id,
                                       seq ';
   
         @ApproveDynamicStatement(2018-01-31,LATHLK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              inv_list_no_,
                                              seq_,
                                              part_no_,
                                              location_no_,
                                              serial_no_,
                                              lot_batch_no_,
                                              waiv_dev_rej_no_,
                                              eng_chg_level_,
                                              configuration_id_,
                                              activity_seq_,
                                              handling_unit_id_,
                                              alt_handling_unit_label_id_,
                                              last_character_,
                                              last_character_,
                                              last_character_,
                                              last_character_;


      END IF;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         --IF lov_id_ = 2 THEN
         -- Since we are using a more advanced order by now we cannot use DISTINCT in the select 
         -- so we have now to remove all duplicate values from the LOV collection.
--           lov_value_tab_ := Remove_Duplicate_Lov_Values___(lov_value_tab_);
         --END IF;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK 
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (column_name_ IN ('SEQ', 'LOCATION_NO', 'PART_NO')) THEN
                  IF (column_name_ = 'SEQ')THEN
                     tmp_seq_ := lov_value_tab_(i);
                     tmp_location_no_ :=  Counting_Report_Line_API.Get_Column_Value_If_Unique(contract_         => contract_, 
                                                                                              inv_list_no_      => inv_list_no_,
                                                                                              seq_              => tmp_seq_,
                                                                                              part_no_          => part_no_,
                                                                                              location_no_      => location_no_,
                                                                                              serial_no_        => serial_no_,
                                                                                              lot_batch_no_     => lot_batch_no_,
                                                                                              waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                              eng_chg_level_    => eng_chg_level_,
                                                                                              configuration_id_ => configuration_id_, 
                                                                                              activity_seq_     => activity_seq_,
                                                                                              handling_unit_id_ => handling_unit_id_,
                                                                                              alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                              column_name_      => 'LOCATION_NO');
                     tmp_part_no_ :=  Counting_Report_Line_API.Get_Column_Value_If_Unique(contract_         => contract_, 
                                                                                          inv_list_no_      => inv_list_no_,
                                                                                          seq_              => tmp_seq_,
                                                                                          part_no_          => part_no_,
                                                                                          location_no_      => location_no_,
                                                                                          serial_no_        => serial_no_,
                                                                                          lot_batch_no_     => lot_batch_no_,
                                                                                          waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                          eng_chg_level_    => eng_chg_level_,
                                                                                          configuration_id_ => configuration_id_, 
                                                                                          activity_seq_     => activity_seq_,
                                                                                          handling_unit_id_ => handling_unit_id_,
                                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                                          column_name_      => 'PART_NO');
                  ELSIF (column_name_ = 'PART_NO') THEN
                     tmp_part_no_ := lov_value_tab_(i);
                  ELSIF (column_name_ = 'LOCATION_NO') THEN
                     tmp_location_no_ := lov_value_tab_(i);
                  END IF;
                  
                  loc_desc_ := Inventory_Location_API.Get_Location_Name(contract_, tmp_location_no_);
                  part_desc_ := Inventory_Part_API.Get_Description(contract_, tmp_part_no_); 
                  IF ((loc_desc_ IS NOT NULL OR part_desc_ IS NOT NULL) AND column_name_ = 'SEQ') THEN
                     lov_item_description_ := loc_desc_ || ' | ' || part_desc_;
                  ELSIF (part_desc_ IS NOT NULL AND column_name_ = 'PART_NO') THEN
                     lov_item_description_ := part_desc_;
                  ELSIF (loc_desc_ IS NOT NULL AND column_name_ = 'LOCATION_NO') THEN
                     lov_item_description_ := loc_desc_;
                  ELSE
                     lov_item_description_ := NULL;
                  END IF;
               ELSIF (column_name_ IN ('HANDLING_UNIT_ID', 'SSCC', 'ALT_HANDLING_UNIT_LABEL_ID')) THEN
                  IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (column_name_ = 'SSCC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  END IF;
                  lov_item_description_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
               END IF;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptCountPartRep and Create_Data_Capture_Lov  
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   seq_                        IN NUMBER,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN  VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;                 
   get_column_values_    Get_Column_Value;     
   stmt_                 VARCHAR2(2000);
   unique_column_value_  VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab; 
BEGIN

   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('COUNTING_REPORT_LINE_EXTENDED', column_name_);

   stmt_ := 'SELECT DISTINCT ' || column_name_ || ' 
             FROM  COUNTING_REPORT_LINE_EXTENDED crl
             WHERE contract         = :contract
             AND   qty_count1       IS NULL';
   IF inv_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
   END IF;
   IF seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND seq = :seq_';
   END IF;
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
             
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';
             
   @ApproveDynamicStatement(2014-11-03,CHJALK)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           inv_list_no_,
                                           seq_,
                                           part_no_,
                                           location_no_,
                                           serial_no_,
                                           lot_batch_no_,
                                           waiv_dev_rej_no_,
                                           eng_chg_level_,
                                           configuration_id_,
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_;
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF; 
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptCountPartRep 
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                   IN VARCHAR2,
   inv_list_no_                IN VARCHAR2,
   seq_                        IN NUMBER,
   part_no_                    IN VARCHAR2,
   location_no_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL,
   column_value_nullable_      IN BOOLEAN  DEFAULT FALSE,
   inv_barcode_validation_     IN BOOLEAN  DEFAULT FALSE) 
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN

   IF (NOT inv_barcode_validation_) THEN  
      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('COUNTING_REPORT_LINE_EXTENDED', column_name_);
   END IF;

   stmt_ := 'SELECT 1 
             FROM COUNTING_REPORT_LINE_EXTENDED crl
             WHERE contract           = :contract
             AND   qty_count1         IS NULL ';
   IF inv_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :inv_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND inv_list_no = :inv_list_no_';
   END IF;
   IF seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND seq = :seq_';
   END IF;
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   IF (NOT inv_barcode_validation_) THEN  
   -- only validate column if this is not a barcode validation since if its barcode validation we want to validate the whole record and not 1 item
      IF (column_value_nullable_) THEN
         stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
      ELSE -- NOT column_value_nullable_
        stmt_ := stmt_ || ' AND ' || column_name_ ||'  = :column_value_ ';
      END IF;   
   END IF;

   IF (inv_barcode_validation_) THEN
      -- No column value exist check, only check the rest of the keys
      @ApproveDynamicStatement(2014-11-03,CHJALK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          inv_list_no_,
                                          seq_,
                                          part_no_,
                                          location_no_,
                                          serial_no_,
                                          lot_batch_no_,
                                          waiv_dev_rej_no_,
                                          eng_chg_level_,
                                          configuration_id_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_;
   
   ELSIF (column_value_nullable_) THEN
      -- Column value check on a nullable column
      @ApproveDynamicStatement(2014-11-03,CHJALK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          inv_list_no_,
                                          seq_,
                                          part_no_,
                                          location_no_,
                                          serial_no_,
                                          lot_batch_no_,
                                          waiv_dev_rej_no_,
                                          eng_chg_level_,
                                          configuration_id_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          column_value_,
                                          column_value_;

   ELSE
      -- Column value check without any nullable handling
      @ApproveDynamicStatement(2014-11-03,CHJALK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          inv_list_no_,
                                          seq_,
                                          part_no_,
                                          location_no_,
                                          serial_no_,
                                          lot_batch_no_,
                                          waiv_dev_rej_no_,
                                          eng_chg_level_,
                                          configuration_id_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          column_value_;
   END IF;


   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (inv_barcode_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST1: The Barcode record does not match current Count Report record.');
      ELSE
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST2: The value :P1 does not exist on Count Report No :P2.', column_value_, inv_list_no_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;


PROCEDURE Add_Reports_To_Hu_Refresh_List (
   stock_keys_tab_      IN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab,
   inventory_event_id_  IN NUMBER )
IS
   db_false_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR get_inv_list_no(contract_          VARCHAR2,
                          part_no_           VARCHAR2,
                          configuration_id_  VARCHAR2,
                          location_no_       VARCHAR2,
                          lot_batch_no_      VARCHAR2,
                          serial_no_         VARCHAR2,
                          eng_chg_level_     VARCHAR2,
                          waiv_dev_rej_no_   VARCHAR2,
                          activity_seq_      NUMBER,
                          handling_unit_id_  NUMBER) IS
      SELECT DISTINCT inv_list_no
      FROM   counting_report_line_tab
      WHERE  contract          = contract_
      AND    part_no           = part_no_
      AND    configuration_id  = configuration_id_
      AND    location_no       = location_no_
      AND    lot_batch_no      = lot_batch_no_
      AND    serial_no         = serial_no_
      AND    eng_chg_level     = eng_chg_level_
      AND    waiv_dev_rej_no   = waiv_dev_rej_no_
      AND    activity_seq      = activity_seq_
      AND    handling_unit_id  = handling_unit_id_
      AND    confirmed         = db_false_;
BEGIN
   IF (stock_keys_tab_.COUNT > 0) THEN
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         FOR rec_ IN get_inv_list_no (stock_keys_tab_(i).contract,
                                      stock_keys_tab_(i).part_no,
                                      stock_keys_tab_(i).configuration_id,
                                      stock_keys_tab_(i).location_no,
                                      stock_keys_tab_(i).lot_batch_no,
                                      stock_keys_tab_(i).serial_no,
                                      stock_keys_tab_(i).eng_chg_level,
                                      stock_keys_tab_(i).waiv_dev_rej_no,
                                      stock_keys_tab_(i).activity_seq,
                                      stock_keys_tab_(i).handling_unit_id) LOOP
            Hu_Snapshot_For_Refresh_API.New(source_ref1_        => rec_.inv_list_no, 
                                            source_ref_type_db_ => Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT, 
                                            inventory_event_id_ => inventory_event_id_);
         END LOOP;
      END LOOP;
   END IF;
END Add_Reports_To_Hu_Refresh_List;


PROCEDURE Set_Confirmed(
   inv_list_no_ IN VARCHAR2,
   seq_      IN NUMBER )
IS
   newrec_     counting_report_line_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(inv_list_no_, seq_);
   newrec_.confirmed := Fnd_Boolean_API.DB_TRUE;
   Modify___(newrec_);
END Set_Confirmed;


@UncheckedAccess
FUNCTION Handling_Unit_Exist_On_Report (
   inv_list_no_      IN VARCHAR2,
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   hu_exist_  BOOLEAN := FALSE;
   dummy_     NUMBER;
   CURSOR check_if_hu_exist_ IS
      SELECT 1 
      FROM  counting_report_line_tab 
      WHERE inv_list_no = inv_list_no_
      AND   handling_unit_id = handling_unit_id_;
BEGIN
   OPEN check_if_hu_exist_;
   FETCH check_if_hu_exist_ INTO dummy_;
   IF (check_if_hu_exist_%FOUND) THEN
      hu_exist_ := TRUE;
   END IF;
   CLOSE check_if_hu_exist_;
   RETURN hu_exist_;
END Handling_Unit_Exist_On_Report;


@UncheckedAccess
FUNCTION Get_Max_Sequence_No (
   inv_list_no_      IN VARCHAR2,
   contract_         IN VARCHAR2) RETURN NUMBER
IS
   max_seq_   counting_report_line_tab.seq%TYPE;

   CURSOR get_max_sequence IS
      SELECT MAX(seq)
      FROM   counting_report_line_tab 
      WHERE  inv_list_no        = inv_list_no_
      AND    contract           = contract_;
BEGIN
   OPEN get_max_sequence;
   FETCH get_max_sequence INTO max_seq_;
   CLOSE get_max_sequence;
   RETURN max_seq_;
END Get_Max_Sequence_No;   


PROCEDURE Modify_Counted_Qty (
   inv_list_no_   IN VARCHAR2,
   seq_           IN NUMBER,
   counted_qty_   IN NUMBER )
IS
   record_  counting_report_line_tab%ROWTYPE;
BEGIN
   record_ := Lock_By_Keys___(inv_list_no_, seq_);
   record_.qty_count1   := counted_qty_;
   Modify___(record_);
END Modify_Counted_Qty;


@UncheckedAccess
FUNCTION Any_Unconfirmed_Line_Exist (
   inv_list_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR check_unconfirmed_line_exist IS 
      SELECT 1
      FROM  counting_report_line_tab
      WHERE inv_list_no = inv_list_no_
      AND   contract = contract_
      AND   part_no = part_no_
      AND   configuration_id = configuration_id_
      AND   location_no = location_no_
      AND   lot_batch_no = lot_batch_no_
      AND   (serial_no = serial_no_ OR serial_no_ IS NULL)
      AND   eng_chg_level = eng_chg_level_
      AND   waiv_dev_rej_no = waiv_dev_rej_no_
      AND   activity_seq = activity_seq_
      AND   handling_unit_id = handling_unit_id_
      AND   confirmed = Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (inv_list_no_ IS NULL OR contract_ IS NULL OR part_no_ IS NULL OR configuration_id_ IS NULL OR location_no_ IS NULL OR lot_batch_no_ IS NULL OR eng_chg_level_ IS NULL OR waiv_dev_rej_no_ IS NULL OR activity_seq_ IS NULL OR handling_unit_id_ IS NULL) THEN
      RETURN Fnd_Boolean_API.DB_FALSE;
   END IF;
   OPEN check_unconfirmed_line_exist;
   FETCH check_unconfirmed_line_exist INTO dummy_;
   IF (check_unconfirmed_line_exist%FOUND) THEN
      CLOSE check_unconfirmed_line_exist;
      RETURN Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_unconfirmed_line_exist;
   RETURN Fnd_Boolean_API.DB_FALSE;
END Any_Unconfirmed_Line_Exist;