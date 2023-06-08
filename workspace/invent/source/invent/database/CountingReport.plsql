-----------------------------------------------------------------------------
--
--  Logical unit: CountingReport
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220104  DaZase  SC21R2-2952, Changes in Create_Data_Capture_Lov to support another LOV and added Get_Inv_List_No_If_Unique().
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  180820  BudKLK  Bug 143399, Modified the method Cancel_Counting_Report() and introduced two methods Cancel_Counting_Report__(), Cancel_Counting_Report___() 
--  180820          to handle cancel count report process in background if required.--  180302  MaAuse  STRSC-16691, Modified New_List_Header by adding exclude_supplier_rented_db_ and exclude_company_rental_asset_db_.
--  171017  SBalLK  Bug 138185, Added Exist_Uncount_With_Count_Lines() method to validate count report has Counted and Uncounted lines.
--  170912  ChFolk  STRSC-11923, Removed parameter and added new parameters exclude_attached_to_hu_db_ and exclude_not_attached_to_hu_db_ to the method New_List_Header. 
--  170821  Chfolk  STRSC-11366, Added new parameter include_full_qty_of_hu_db_ to the method New_List_Header.
--  170721  ChFolk  STRSC-11002, Added new parameters handling_unit_selection_db_, handling_unit_type_id_, top_handling_unit_type_id_,
--  170721          handling_category_type_id_ and top_handling_category_type_id_ to New_List_Header.
--  161122  Dazase  LIM-5062, Added method Create_Data_Capture_Lov and Exist_And_Is_Not_Counted.
--  161004  DaZase  LIM-7717, Added methods Set_Detailed_Report_Printed and Set_Aggregated_Report_Printed.
--  141126  MaEelk  PRSC-4372, Rewrote the logic and replaced the call to Unpack___, Check_Insert___ and Insert___ with New___
--  141030  MaEelk  PRSC-3299, Removed FROM_BAY_NO, FROM_PART_NO, FROM_WAREHOUSE, TO_BAY_NO, TO_PART_NO and TO_WAREHOUSE and added 
--  141030          WAREHOUSE_ID, BAY_ID, TIER_ID, ROW_ID, BIN_ID, STORAGE_ZONE_ID, PART_NO, LOCATION_GROUP, ABC_CLASS, FREQUENCY_CLASS and 
--  141030          LIFECYCLE_STAGE. Changed the parameter list of New_List_Header
--  131106  UdGnlk  PBSC-205, Modified base view comments to align with model file errors.
--  131106          Removed cycle_code SUBSTR function to support with model files.  
--  120124  MaEelk  Added DATE/TIME format to CREATE_DATE.
--  110203  KiSalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  080306  NuVelk  Bug 71301, Added view COUNTING_REPORT_REJECT_RESULT.
--  080225  NuVelk  Bug 70819, Changed method New_List_Header to use db_values for
--  080225          cycle_code_, freeze_code_ and include_all_qty_.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060523  KanGlk  Modified CANCEL_COUNTING_REPORT_LOV - instead of counting_report_line, counting_report_line_tab had been used.
--  --------------- 13.4.0 ---------------------------------------------------
--  060306  SaRalk  Removed the SUBSTRB from VIEW.  
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  051109  MaHplk  Changed referecnce site_public to user_allowed_site_pub.
--  050927  HoInlk  Bug 51652, Modified to use new IID CyclicCounting instead of InventoryPartCountType.
--  040716  DiVelk  Added comments in &LOV_VIEW for Project_Id.
--  040714  DiVelk  Added PROJECT_ID,EXCLUDE_STANDARD_INVENTORY and EXCLUDE_PROJECT_INVENTORY.Modified [New_List_Header].
--  040226  GeKalk  Removed substrb from views for UNICODE modifications.
--  --------------- EDGE Package Group 3 Unicode Changes ---------------------
--  030805 DAYJLK Added exclude_rotable_pool_db_ and exclude_fa_rotable_pool_db_ as parameters to procedure New_List_Header.
--  030805        Modified view Counting_Report to display new attributes. Modified Unpack_Check_Insert___ and Unpack_Check_Update___.
--  030728  KiSalk SP4 Merge.
--  030611 DAYJLK Added exclude_customer_owned_db_, exclude_supplier_loaned_db_, exclude_consignment_db_
--  030611        and exclude_company_owned_db_ as parameters to procedure New_List_Header. Modified view
--  030611        Counting_Report to display new attributes. Modified Unpack_Check_Insert___ and Unpack_Check_Update___
--  030306  ANHOSE Bug 36101, added include_all_qty as new column and as inparameter to New_List_Header.
--  010619  SANALK Bug Fix 19100, Reversed the previous correction. Removed the view VIEW_REP_NEW.
--  010308  JABA  Bug Fix 19100, Created new view VIEW_REP_NEW.
--  000925  JOHESE  Added undefines.
--  000505  ANHO  Replaced call to USER_DEFAULT_API.Get_Contract with USER_ALLOWED_SITE_API.Get_Default_Site.
--  000310  ANHO  Corrected error in Cancel_Counting_Report.
--  000218  SHVE  Reorganised Cancel_Counting_Report to handle uncounted lines.
--  990919  ROOD  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990709  MATA  Changed substr to substrb in VIEW definitions
--  990419  ROOD  General performance improvements.
--  990407  ROOD  Upgraded to performance optimized template.
--  990308  JOHW  Corrected the CANCEL_COUNTING_REPORT_LOV.
--  981228  FRDI  Added Site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981126  JOKE  Changed order of define statements.
--  981122  FRDI  Full precision for UOM, change comments on tab.
--  981120  JOHW  Added lov_view for Cancel_Counting_Report.
--  980924  JOHW  Corrected exist control in Cancel_Counting_Report.
--  980918  JOHW  Enabled more LOV columns.
--  980916  JOHW  Added validation in procedure Cancel_Counting_Report.
--  980915  JOHW  Added methods Cancel_Counting_Report, Get_Freeze_Code_Db
--                and Get_Contract.
--  971127  GOPE  Upgrade to fnd 2.0
--  970312  CHAN  Changed table name: inv_list_header replaced by
--                counting_report_tab
--  970219  JOKE  Uses column rowversion as objversion (timestamp).
--  970109  MAOR  Removed call to Commodity_Group_API.Exist and check if
--                create_date is not null in Unpack_Check_Insert___.
--  961212  MAOR  Changed to new template. Removed procedure
--                Create_Inventory_Count_List.
--  961112  MAOR  Changed to new template and workbench.
--  961030  MAOR  Modified file to Rational Rose Model-standard.
--  960902  GOPE  Change the argument freeze code and cycle code to be
--                client values and not numbers
--  960826  GOPE  Changes due to adding of columns in inv_list_header
--  960822  LEPE  Changes in proc Insert___ to avoid problems on Oracle ver.
--                7.1.5 and later.(In-parameter used as assignment target).
--  960624  MAOS  Added 'select inv_list_no.nextval' in proc Insert___.
--  960607  JOBE  Added functionality to CONTRACT.
--  960507  MAOS  Added procedure New_List_Header.
--                Modified Create_Inventory_Count_List (moved all code
--                to a corresponding procedure in LU Inventory_Part_Location).
--  960502  MAOS  Replaced insert statement with procedure New_List_Detail.
--  960307  JICE  Renamed from InvCountInvListHeader
--  951116  xxxx  Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', USER_ALLOWED_SITE_API.Get_Default_Site, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT COUNTING_REPORT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.create_date := Site_API.Get_Site_Date(newrec_.contract);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT counting_report_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     counting_report_tab%ROWTYPE,
   newrec_ IN OUT counting_report_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

-- Cancel_Counting_Report___
-- Implementation method for Cancel Count Report.
PROCEDURE Cancel_Counting_Report___ (
   inv_list_no_        IN VARCHAR2)
IS
   remrec_     COUNTING_REPORT_TAB%ROWTYPE;
   objid_      COUNTING_REPORT.objid%TYPE;
   objversion_ COUNTING_REPORT.objversion%TYPE;
BEGIN
   Exist(inv_list_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, inv_list_no_);
   remrec_ := Get_Object_By_Id___(objid_);

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, remrec_.contract);

   IF Counting_Report_Line_API.Any_Counted_Lines(inv_list_no_) THEN
      -- delete only the uncounted lines
      Counting_Report_Line_API.Remove_Uncounted_Lines(inv_list_no_);
   ELSE
      -- delete uncounted lines and the whole report
      IF remrec_.freeze_code = 'Y' THEN
         Counting_Report_Line_API.Reset_Freeze_Flag(inv_list_no_);
      END IF;
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
END Cancel_Counting_Report___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-- Create_Count_Report__
--   Used to call Cancel_Counting_Report___ impelementation method. 
PROCEDURE Cancel_Counting_Report__ (
   inv_list_no_    IN VARCHAR2)
IS

BEGIN
   Cancel_Counting_Report___(inv_list_no_);
END Cancel_Counting_Report__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_List_Header
--   Creates a new instance of class CountingReport.
PROCEDURE New_List_Header (
   inv_list_no_                     IN VARCHAR2,
   contract_                        IN VARCHAR2,
   cycle_code_db_                   IN VARCHAR2,
   second_commodity_                IN VARCHAR2,
   userid_                          IN VARCHAR2,
   warehouse_id_                    IN VARCHAR2,
   bay_id_                          IN VARCHAR2,
   row_id_                          IN VARCHAR2,
   tier_id_                         IN VARCHAR2,
   bin_id_                          IN VARCHAR2,
   storage_zone_id_                 IN VARCHAR2,
   part_no_                         IN VARCHAR2,
   max_qty_onhand_                  IN NUMBER,
   last_count_date_                 IN DATE,
   freeze_code_db_                  IN VARCHAR2,
   process_count_                   IN NUMBER,
   project_id_                      IN VARCHAR2,
   include_all_qty_db_              IN VARCHAR2,
   exclude_customer_owned_db_       IN VARCHAR2,
   exclude_supplier_loaned_db_      IN VARCHAR2,
   exclude_consignment_db_          IN VARCHAR2,
   exclude_company_owned_db_        IN VARCHAR2,
   exclude_rotable_pool_db_         IN VARCHAR2,
   exclude_fa_rotable_pool_db_      IN VARCHAR2,
   exclude_standard_inventory_db_   IN VARCHAR2,
   exclude_project_inventory_db_    IN VARCHAR2,
   exclude_attached_to_hu_db_       IN VARCHAR2,
   exclude_not_attached_to_hu_db_   IN VARCHAR2,
   exclude_supplier_rented_db_      IN VARCHAR2,
   exclude_company_rental_asset_db_ IN VARCHAR2,
   location_group_                  IN VARCHAR2,
   abc_class_                       IN VARCHAR2,
   frequency_class_db_              IN VARCHAR2,
   lifecycle_stage_db_              IN VARCHAR2,
   include_full_qty_of_hu_db_       IN VARCHAR2,
   handling_unit_type_id_           IN VARCHAR2,
   top_handling_unit_type_id_       IN VARCHAR2,
   handling_category_type_id_       IN VARCHAR2,
   top_handling_category_type_id_   IN VARCHAR2 )
IS
   newrec_     COUNTING_REPORT_TAB%ROWTYPE;
BEGIN
   newrec_.inv_list_no                   := inv_list_no_;
   newrec_.contract                      := contract_;
   newrec_.cycle_code                    := cycle_code_db_;
   newrec_.second_commodity              := second_commodity_;
   newrec_.userid                        := userid_;
   newrec_.warehouse_id                  := warehouse_id_;
   newrec_.bay_id                        := bay_id_;
   newrec_.row_id                        := row_id_;
   newrec_.tier_id                       := tier_id_;
   newrec_.bin_id                        := bin_id_;
   newrec_.storage_zone_id               := storage_zone_id_;
   newrec_.part_no                       := part_no_;
   newrec_.max_qty_onhand                := max_qty_onhand_;
   newrec_.last_count_date               := last_count_date_;
   newrec_.freeze_code                   := freeze_code_db_;
   newrec_.process_count                 := process_count_;
   newrec_.project_id                    := project_id_;
   newrec_.include_all_qty               := include_all_qty_db_;
   newrec_.exclude_customer_owned        := exclude_customer_owned_db_;
   newrec_.exclude_supplier_loaned       := exclude_supplier_loaned_db_;
   newrec_.exclude_consignment           := exclude_consignment_db_;
   newrec_.exclude_company_owned         := exclude_company_owned_db_;
   newrec_.exclude_rotable_pool          := exclude_rotable_pool_db_;
   newrec_.exclude_fa_rotable_pool       := exclude_fa_rotable_pool_db_;
   newrec_.exclude_standard_inventory    := exclude_standard_inventory_db_;
   newrec_.exclude_project_inventory     := exclude_project_inventory_db_;
   newrec_.exclude_attached_to_hu        := exclude_attached_to_hu_db_;
   newrec_.exclude_not_attached_to_hu    := exclude_not_attached_to_hu_db_;
   newrec_.exclude_supplier_rented       := exclude_supplier_rented_db_;
   newrec_.exclude_comp_rental_asset     := exclude_company_rental_asset_db_;
   newrec_.location_group                := location_group_;
   newrec_.abc_class                     := abc_class_;
   newrec_.frequency_class               := frequency_class_db_;
   newrec_.lifecycle_stage               := lifecycle_stage_db_;
   newrec_.detail_report_printed         := Gen_Yes_No_API.DB_NO;
   newrec_.aggregated_report_printed     := Gen_Yes_No_API.DB_NO;
   newrec_.include_full_qty_of_hu        := include_full_qty_of_hu_db_;
   newrec_.handling_unit_type_id         := handling_unit_type_id_;
   newrec_.top_handling_unit_type_id     := top_handling_unit_type_id_;
   newrec_.handling_category_type_id     := handling_category_type_id_;
   newrec_.top_handling_category_type_id := top_handling_category_type_id_;
   New___(newrec_);
END New_List_Header;


-- Cancel_Counting_Report
--   Removes Counting reports if there are no counted lines.
PROCEDURE Cancel_Counting_Report (
   inv_list_no_ IN VARCHAR2 ,
   run_in_background_  IN VARCHAR2 DEFAULT 'FALSE' )
IS
   batch_desc_          VARCHAR2(2000);
BEGIN
   IF (run_in_background_ = 'TRUE')  THEN   
      batch_desc_ := Language_SYS.Translate_Constant(lu_name_, 'CANCELREPORT: Cancel Count Report');
      Transaction_SYS.Deferred_Call('Counting_Report_API.Cancel_Counting_Report__', inv_list_no_, batch_desc_);
   ELSE
      Cancel_Counting_Report___(inv_list_no_);
   END IF; 
END Cancel_Counting_Report;


-- Set_Detailed_Report_Printed
--   Set the detailed report printed flag for the current LU instance.
PROCEDURE Set_Detailed_Report_Printed (
   inv_list_no_ IN VARCHAR2 )
IS
   oldrec_     COUNTING_REPORT_TAB%ROWTYPE;
   newrec_     COUNTING_REPORT_TAB%ROWTYPE;
   objid_      COUNTING_REPORT.objid%TYPE;
   objversion_ COUNTING_REPORT.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(inv_list_no_);
   newrec_ := oldrec_;
   newrec_.detail_report_printed := Gen_Yes_No_API.DB_YES;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Detailed_Report_Printed;


-- Set_Aggregated_Report_Printed
--   Set the aggregated report printed flag for the current LU instance.
PROCEDURE Set_Aggregated_Report_Printed (
   inv_list_no_ IN VARCHAR2 )
IS
   oldrec_     COUNTING_REPORT_TAB%ROWTYPE;
   newrec_     COUNTING_REPORT_TAB%ROWTYPE;
   objid_      COUNTING_REPORT.objid%TYPE;
   objversion_ COUNTING_REPORT.objversion%TYPE;
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(inv_list_no_);
   newrec_ := oldrec_;
   newrec_.aggregated_report_printed := Gen_Yes_No_API.DB_YES;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Aggregated_Report_Printed;



-- This method is used by DataCaptStartCountRep, DataCaptCountHuReport and DataCaptAddLineCntRep
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   lov_id_                     IN NUMBER DEFAULT 1)
IS
   session_rec_                  Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_           NUMBER;
   exit_lov_                     BOOLEAN := FALSE;

   CURSOR get_inv_list_no IS
      SELECT DISTINCT inv_list_no
      FROM  COUNTING_REPORT_TAB
      WHERE contract = contract_
      AND   inv_list_no IN (SELECT inv_list_no FROM COUNTING_REPORT_LINE crl WHERE crl.qty_count1 IS NULL)
      ORDER BY Utility_SYS.String_To_Number(inv_list_no) ASC, inv_list_no ASC;

   CURSOR get_inv_list_no2 IS
      SELECT DISTINCT inv_list_no
      FROM  COUNTING_REPORT_TAB
      WHERE contract = contract_
      AND   inv_list_no IN (SELECT inv_list_no FROM COUNTING_REPORT_LINE crl WHERE crl.confirmed_db = 'FALSE')
      ORDER BY Utility_SYS.String_To_Number(inv_list_no) ASC, inv_list_no ASC;


BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF (lov_id_ = 1) THEN 
         FOR lov_rec_ IN get_inv_list_no LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.inv_list_no,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      ELSIF (lov_id_ = 2) THEN 
         FOR lov_rec_ IN get_inv_list_no2 LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.inv_list_no,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptAddLineCntRep
@UncheckedAccess
FUNCTION Get_Inv_List_No_If_Unique (
   contract_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   column_value_                  VARCHAR2(50);
   unique_column_value_           VARCHAR2(50):= NULL;

   CURSOR get_inv_list_no IS
      SELECT inv_list_no
      FROM  COUNTING_REPORT_TAB
      WHERE contract = contract_;
     
BEGIN
   OPEN get_inv_list_no;
   LOOP
      FETCH get_inv_list_no INTO column_value_;
      EXIT WHEN get_inv_list_no%NOTFOUND;
      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := column_value_;
      ELSIF (unique_column_value_ != column_value_) THEN
         unique_column_value_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_inv_list_no;
   RETURN unique_column_value_;
END Get_Inv_List_No_If_Unique;



--   This Exist_And_Is_Not_Counted method is used from DataCaptCountHuReport
PROCEDURE Exist_And_Is_Not_Counted ( 
   contract_    IN VARCHAR2,
   inv_list_no_ IN VARCHAR2) 
IS
   dummy_  NUMBER;
   exist_  BOOLEAN := FALSE;
   CURSOR check_inv_list_no IS
      SELECT 1
      FROM  COUNTING_REPORT_TAB
      WHERE contract = contract_
      AND   inv_list_no = inv_list_no_
      AND   inv_list_no IN (SELECT inv_list_no FROM COUNTING_REPORT_LINE crl WHERE crl.qty_count1 IS NULL);

BEGIN
   OPEN check_inv_list_no;
   FETCH check_inv_list_no INTO dummy_;
   IF (check_inv_list_no%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE check_inv_list_no;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: Count Report No :P1 does not exist or is already counted.', inv_list_no_);
   END IF;

END Exist_And_Is_Not_Counted; 


-- Exist_Uncount_With_Count_Lines
--   This method validate that count report has uncounted line along with the counted lines.
@UncheckedAccess
FUNCTION Exist_Uncount_With_Count_Lines(
   inv_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR check_mix_lines IS
      SELECT count(*)
      FROM (SELECT 1
            FROM  counting_report_line_tab
            WHERE inv_list_no = inv_list_no_
            GROUP BY CASE
                        WHEN qty_count1 IS NULL THEN 1
                        ELSE 0  END);
   dummy_            NUMBER;
   mix_lines_exists_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   OPEN check_mix_lines;
   FETCH check_mix_lines INTO dummy_;
   CLOSE check_mix_lines;
   
   IF(dummy_ > 1) THEN
      mix_lines_exists_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   RETURN mix_lines_exists_;
END Exist_Uncount_With_Count_Lines;
