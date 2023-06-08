-----------------------------------------------------------------------------
--
--  Logical unit: OrdAggStatUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190425  LaThlk   SCUXXW4-19484, Added the function Get_View_From_Lu() to convert the lu name to the view name.
--  180808  WaSalk   Bug 142471, Modified start Batch___ by increasing the length of the local variable str_type_ from 200 to 2000.
--  120731  MalLlk   Bug 102461, Modified Start_Batch___ by increasing the length of the local variable str_type_ in order to avoid the oracle error.  
--  110825  NaLrlk   Modified Do_Aggregate__() by increasing the length of the variables col_type_list_,col_agg_list_,col_issue_list_
--  110602           and col_group_list_ from 1000 to 32000.
--  100519  KRPELK   Merge Rose Method Documentation.
--  100311  MaRalk   Removed language storing code part from the Get_Next_Date___ and used Batch_SYS.Nls_Translate_Day instead. 
--  091218  MaMalk   Removed unused constants defined, replaced ORD_AGG_STAT_TAB with TABLE_AGG and changed the position of the method Do_Aggregate__.
--  091215  MaMalk   Renamed method Scheduled_Aggregation to Do_Aggregate and made the public Do_Aggregate method 
--  091215           private and modified the parameters. 
--  091208  MaMalk   Removed methods Rollback_Last_Process___, Is_Locked___, Check_If_All_Companies__ and Aggregator.
--  091208           Modified methods Start_Batch___, Fetch_Aggregate_Columns___, Do_Aggregate, Validate_Params and Scheduled_Aggregation
--  091208           to support the CO Statistics Aggregation at company level.
--  091109  MaMalk   Modified method Do_Aggregate to remove the status check on cursor get_last_execution_date.
--  ------------------------ 14.0.0 --------------------------------------------
--  080313  ChJalk   Bug 71962, Added Scheduled_Aggregation.
--  070911  KaDilk   Bug 67363, Modified the method Get_Next_Date___ to correctly pass the parameters to dbms_session.set_nls.
--  060320  JaJalk   Moved the Added Assert safe annotation as the log further generate entries.
--  051205  HaPulk   Added Assert safe annotation.
--  051114  PrPrlk   Bug 54514, Declared the cusror types get_sq_no_type and get_start_date_type as REF CURSOR types 
--                   to support installation in Databases having earlier versions of Oracle than Oracle 9i.
--  050920  NaLrlk   Removed unused variables.
--  050425  SeJalk   Bug 49978, Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  050425           Applied validity checks where necessary. 
--  050323  IsWilk   Added PROCEDURE Validate_Params.
--  040817  DhWilk   Modified the General_SYS.Init_Method in Check_If_All_Companies__
--  040419  JaBalk   Changed the implementation method Check_If_All_Companies___ to private.
--  040217  IsWilk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  040203  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  --------------------------13.3.0----------------------------------------------
--  020603  MIGUUS   Bug 30428, date error in Do_Aggregate in PROC Get_Next_Date___.
--  010403  RoAnse   Bug fix 21119, Added assignement of NULL value to the variables col_type_list_,
--                   col_agg_list_, col_group_list_ and col_issue_list_ in procedure Do_Aggregate.
--  001128  FBen     BugFix. Changed error message NOTCONNECTTOALLCOMP.
--  001009  JoEd     Bug fix 17686. Added method Check_If_All_Companies___.
--                   Added in method Aggregator to check that user is
--                   connected to all companies before running aggregation.
--  000913  FBen     Added UNDEFINE.
--  ------------------------------ 12.1 -------------------------------------
--  000620  PaLj     Added Error messages in Do_Aggregate when having no succesful detail statistics
--                   or if there is not enough statistics for the aggregate id
--  000229  JakH     Changed functionality regarding log to use key Process_Id
--                   instead of objid/objversion sice this does not work good
--                   in combination with explicit commits.
--                   (OrdAggStatLog has new methods: New Get_Process_Id and Modify)
--  990602  JakH     Wrong parameter in call to Ord_Agg_Stat_Log_API.remove()
--                   (was aggregate-id should have been/is now process id)
--  990422  JakH     IID's decoded on calls to client-get-methods.
--  990407  JakH     New template. Use new get method from ord_agg_stat.
--  990301  JakH     Call 10504, period ends are cheched against last date of execution.
--  990208  JoEd     Run through Design.
--  980124  KaSu     Renamed endDate as start_date in do_aggregate.
--                   Removed the Get_Last_Transction_Date___().
--                   In the Do_Aggregator modified the WHILE (trunc(nextDate_) <= trunc(SYSDATE))
--                   as WHILE (trunc(nextDate_) <= trunc(lastTranDate_)) LOOP
--  981129  KaSu     Added the field desc_ in the procedure Aggregator.
--  981110  KaSu     Added the function Get_Next_Date___;
--                   Added the define statements for VIEW_VIEW_DIM, VIEW_COL and VIEW_LOG
--  981110  KaSu     Replaced ORD_AGG_STAT_LOG_API.Modify__ with ORD_AGG_STAT_LOG_API.Remove__
--                   in the procedure Do_Aggregate.
--  981109  KaSu     Replaced the '01011985' with &INITIAL_DATE_STR.
--  981030  KaSu     Moved the dbms_sql.open(cl_) and dbms_sql.close(cl_) out of the loop
--  981028  KaSu     Replaced the date string '01011961' with '01011985'.
--                   Replaced the Directly written SELECT statements with CURSORS.
--                   Replaced SELECT's from tab with SELECT's from view.
--                   Replaced all_tab_columns with user_tab_columns.
--                   Replaced (nextDate_ <= SYSDATE) with (trunc(nextDate_) <= trunc(SYSDATE))
--                   Replaced (lastTranDate_ >= nextDate_) with trunc(lastTranDate_) >= trunc(nextDate_)
--  981023  Reza     General_SYS.Init_Method() was included to the necessary Procedures
--  980921  KaSu     Inserted the dbms_sql.close_cursor() statement in the EXCEPTIONS.
--  981231  KiRo     Update the column selection
--                     - Select the dimension columns using the OrdIssueStatColumn LU and
--                       sorted using the dim_row column of OrdAggStatDimension.
--                     - Select the aggregate columns using the  OrdIssueStatColumn so that the
--                       column type is fetched from the  OrdIssueStatColumn LU.
--                   Updated the IID values.
--                   The aggregate and detail issue view names are fetched from the OrdIssueStat LU
--                   The process Log is fetched using the process_id only. Previously used the
--                   aggregate_id too.
--  98xxxx  xxxx     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Start_Batch___
--   The aggregation of detail issues and inserting the totals into
--   the aggregation issue tables
--   The procedure receives the column list aggregation column list
--   detail and aggregate table names column types aggregate view column list
--   date column which to aggregate the detail issues.
--   This contains the core coding for the aggregation operation.
--   Mainly it does does the aggregation operation for one partlicular time block.
--   The DoAggregator method calls this procedure in a loop for all possible time blocks.
PROCEDURE Start_Batch___ (
   issue_               IN VARCHAR2,
   group_               IN VARCHAR2,
   type_                IN VARCHAR2,
   aggregate_           IN VARCHAR2,
   company_             IN VARCHAR2,
   aggregate_id_        IN NUMBER,
   start_date_          IN DATE,
   end_date_            IN DATE,
   issue_view_          IN VARCHAR2,
   agg_view_            IN VARCHAR2,
   date_column_         IN VARCHAR2 )
IS
   sel_stmt_  VARCHAR2(2000);
   ins_stmt_  VARCHAR2(2000);
   date_type_ DATE;
   num_type_  NUMBER;
   str_type_  VARCHAR2(2000);
   col_no_    NUMBER;
   ptr_       NUMBER;
   name_      VARCHAR2(30);
   value_     VARCHAR2(2000);
   selc1_     NUMBER;
   insc1_     NUMBER;
   dummy_     NUMBER;   
   seq_stmt_  VARCHAR2(500);     
   col_name_  VARCHAR2(30);
   TYPE get_sq_no_type IS REF CURSOR;
   get_sq_no_ get_sq_no_type; 

BEGIN
   --- prepare the select statement from the issue file
   sel_stmt_ := 'SELECT ';
   col_no_ := 1;
   ptr_ := NULL;
   Assert_Sys.Assert_Is_View(issue_view_);
   WHILE (Client_SYS.Get_Next_From_Attr(issue_, ptr_, name_, value_)) LOOP
      IF (col_no_ > 1) THEN
         sel_stmt_ := sel_stmt_ || ',';
      END IF;
      IF (substr(value_,0,4) = 'sum(') THEN
         col_name_ := substr( value_, 5,length(substr( value_, 5))-1);
         Assert_Sys.Assert_Is_View_Column(issue_view_, col_name_);
      ELSE
         Assert_Sys.Assert_Is_View_Column(issue_view_, value_);
      END IF;
      sel_stmt_ := rtrim(sel_stmt_) || ' ' || value_;
      col_no_ := col_no_ + 1;
   END LOOP;

   -- prepare the WHERE clause which is for the date field for the detail issue (This is a parameter)
   
   Assert_Sys.Assert_Is_View_Column(issue_view_, date_column_);
   sel_stmt_ := rtrim(sel_stmt_) || ' FROM ' || issue_view_ ||
                ' WHERE company = :company AND TRUNC(' || date_column_ || ') BETWEEN TRUNC(:start_date) AND TRUNC(:end_date)' ||
                ' GROUP BY ';
   col_no_ := 1;
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(group_, ptr_, name_, value_)) LOOP
      IF (col_no_ > 1) THEN
         sel_stmt_ := rtrim(sel_stmt_) || ',';
      END IF;

      IF (substr(value_,0,4) = 'sum(') THEN
         col_name_ := substr( value_, 5,length(substr( value_, 5))-1);
         Assert_Sys.Assert_Is_View_Column(issue_view_, col_name_);
      ELSE
         Assert_Sys.Assert_Is_View_Column(issue_view_, value_);
      END IF;

      sel_stmt_ := rtrim(sel_stmt_) || ' ' || value_;
      col_no_ := col_no_ + 1;
   END LOOP;


   -- prepare the insert statement to the aggregate file

   Assert_Sys.Assert_Is_Table(agg_view_ || '_TAB');
   ins_stmt_ := 'INSERT INTO ' || agg_view_ || '_TAB (ROW_NO, AGGREGATE_ID, START_DATE, END_DATE, ';
   col_no_ := 1;
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(aggregate_, ptr_, name_, value_)) LOOP
      IF (col_no_ > 1) THEN
         ins_stmt_ := ins_stmt_ || ',';
      END IF;
      Assert_Sys.Assert_Is_Table_Column(agg_view_ || '_TAB', value_);
      ins_stmt_ := rtrim(ins_stmt_) || ' ' || value_;
      col_no_ := col_no_ + 1;
   END LOOP;

   ins_stmt_ := ins_stmt_ || ', ROWVERSION) VALUES (:seq_no, :aggregate_id, :fromdate, :todate, ';
   col_no_ := 1;
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(type_, ptr_, name_, value_)) LOOP
      IF (col_no_ > 1) THEN
         ins_stmt_ := ins_stmt_ || ',';
      END IF;
      ins_stmt_ := rtrim(ins_stmt_) || ' :' || 'COL_' || to_char(col_no_);
      col_no_ := col_no_ + 1;
   END LOOP;
   ins_stmt_ := ins_stmt_ || ', SYSDATE)';

   --- open a cursor for the selected records
   selc1_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2009-12-08,MaMalk)
   dbms_sql.parse(selc1_, sel_stmt_, dbms_sql.native);

   col_no_ := 1;
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(type_, ptr_, name_, value_)) LOOP
      IF (value_ LIKE '%STRING%') THEN
         dbms_sql.define_column(selc1_, col_no_, str_type_, 200);
      END IF;
      IF (value_ LIKE '%NUMBER%') THEN
         dbms_sql.define_column(selc1_, col_no_, num_type_);
      END IF;
      IF (value_ LIKE '%DATE%') THEN
         dbms_sql.define_column(selc1_, col_no_, date_type_);
      END IF;
      col_no_ := col_no_ + 1;
   END LOOP;

   --- execute the detail cursor
   dbms_sql.bind_variable(selc1_, 'company', company_);   
   dbms_sql.bind_variable(selc1_, 'start_date',start_date_);
   dbms_sql.bind_variable(selc1_, 'end_date',end_date_);
   dummy_ := dbms_sql.execute(selc1_);

   --- the sequence number field
   Assert_Sys.Assert_Is_Table(agg_view_ || '_TAB');
   seq_stmt_ := 'SELECT (NVL(MAX(row_no), 0) + 1) FROM ' || agg_view_ || '_TAB WHERE company = :company AND aggregate_id = :aggregate_id';

   -- Insert each of the selected totals for the detail issue into the aggregate issue table
   -- The variable type is checked in order to use the appropriate dbms_sql package function
   -- to fetch and bind values.

   WHILE (dbms_sql.fetch_rows(selc1_) > 0) LOOP
      col_no_ := 1;
      ptr_ := NULL;
      insc1_ := dbms_sql.open_cursor;
      @ApproveDynamicStatement(2005-12-05,hapulk)
      dbms_sql.parse(insc1_, ins_stmt_, dbms_sql.native);      
      dbms_sql.bind_variable(insc1_, 'aggregate_id', aggregate_id_);
      dbms_sql.bind_variable(insc1_, 'fromdate', start_date_);
      dbms_sql.bind_variable(insc1_, 'todate', end_date_);

      WHILE (Client_SYS.Get_Next_From_Attr(type_, ptr_, name_, value_)) LOOP
         IF (value_ LIKE '%STRING%') THEN
            dbms_sql.column_value(selc1_, col_no_, str_type_);
            dbms_sql.bind_variable(insc1_, 'COL_' || to_char(col_no_), str_type_);
         END IF;
         IF (value_ LIKE '%NUMBER%') THEN
            dbms_sql.column_value(selc1_, col_no_, num_type_);
            dbms_sql.bind_variable(insc1_, 'COL_' || to_char(col_no_), num_type_);
         END IF;
         IF (value_ LIKE '%DATE%') THEN
            dbms_sql.column_value(selc1_, col_no_, date_type_);
            dbms_sql.bind_variable(insc1_, 'COL_' || to_char(col_no_), date_type_);
         END IF;
         col_no_ := col_no_ + 1;
      END LOOP;
      
      @ApproveDynamicStatement(2009-12-08,MaMalk)
      OPEN get_sq_no_ FOR seq_stmt_ USING company_, aggregate_id_;
      FETCH get_sq_no_ INTO num_type_;
      CLOSE get_sq_no_;    
      dbms_sql.bind_variable(insc1_, 'seq_no', num_type_);
      
      dummy_ := dbms_sql.execute(insc1_);
      dbms_sql.close_cursor(insc1_);          
   END LOOP;
   dbms_sql.close_cursor(selc1_);   
EXCEPTION  
   WHEN others THEN     
      IF (dbms_sql.is_open(selc1_)) THEN
         dbms_sql.close_cursor(selc1_);
      END IF;
      IF (dbms_sql.is_open(insc1_)) THEN
         dbms_sql.close_cursor(insc1_);
      END IF;
      RAISE;
END Start_Batch___;


-- Prep_View_Name___
--   This function will return the view name given it's LU name.
FUNCTION Prep_View_Name___ (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   len_ NUMBER;
   pos_ NUMBER;
   view_name_ VARCHAR2(100);
   char_val_ VARCHAR2(5);
BEGIN
   len_ := length(lu_name_);
   pos_ := 2;
   view_name_ := upper(substr(lu_name_, 1, 1));
   WHILE (pos_ <= len_) LOOP
      char_val_ := substr(lu_name_, pos_, 1);
      IF (char_val_ = upper(char_val_)) THEN
         view_name_ := view_name_ || '_';
      END IF;
      view_name_ := view_name_ || upper(char_val_);
      pos_ := pos_ + 1;
   END LOOP;
   RETURN view_name_;
END Prep_View_Name___;


-- Get_Next_Date___
--   Calculate the next date upto which the aggregation is to be done
--   The processing frequency is selected by the user. The possible vales are
--   MONTHLY, WEEKLY (week day), DAILY or given time block.
FUNCTION Get_Next_Date___ (
   start_date_               IN DATE,
   ord_day_mon_year_stat_db_ IN VARCHAR2,
   ord_week_day_stat_db_     IN VARCHAR2,
   time_block_               IN NUMBER ) RETURN DATE
IS
   next_date_  DATE;
   ord_week_day_stat_date_ VARCHAR2(3);  
  
BEGIN
   IF (ord_day_mon_year_stat_db_ = 'MONTH') THEN
      -- next_date for monthly aggregations really has to point to the last
      -- day of that month.
      --(Get two months ahead, get to the first of that month, back one day)
      next_date_ := trunc (add_months(start_date_,2), 'MON') -1;
   ELSIF (ord_day_mon_year_stat_db_ = 'DAY') THEN
      next_date_ := start_date_ + 1;
   ELSIF (ord_day_mon_year_stat_db_ ='WEEK') THEN
      CASE ord_week_day_stat_db_
         WHEN Ord_Week_Day_Stat_API.DB_MONDAY THEN
            ord_week_day_stat_date_ := 'MON';
         WHEN Ord_Week_Day_Stat_API.DB_TUESDAY THEN
            ord_week_day_stat_date_ := 'TUE';
         WHEN Ord_Week_Day_Stat_API.DB_WEDNESDAY THEN
            ord_week_day_stat_date_ := 'WED';
         WHEN Ord_Week_Day_Stat_API.DB_THURSDAY THEN
            ord_week_day_stat_date_ := 'THU';
         WHEN Ord_Week_Day_Stat_API.DB_FRIDAY THEN
            ord_week_day_stat_date_ := 'FRI';
         WHEN Ord_Week_Day_Stat_API.DB_SATURDAY THEN
            ord_week_day_stat_date_ := 'SAT';
         WHEN Ord_Week_Day_Stat_API.DB_SUNDAY THEN
            ord_week_day_stat_date_ := 'SUN';
      END CASE;
      next_date_ := next_day(start_date_, Batch_SYS.Nls_Translate_Day_ (ord_week_day_stat_date_)); 
   ELSIF (nvl(time_block_, 0) = 0) THEN
      Error_SYS.Appl_General(lu_name_, 'NO_TIMEBLOCK: Time block not specified!');
   ELSE
      next_date_ := start_date_ + time_block_;
   END IF;
   
   RETURN next_date_;
END Get_Next_Date___;


-- Adjust_First_Date___
--   Adjusts start date to be the first day of a period, i.e for a month
--   it's the first day of that month. The day is then set one day earlier
--   to fit later calculations.
PROCEDURE Adjust_First_Date___ (
   start_date_               IN OUT DATE,
   ord_day_mon_year_stat_db_ IN     VARCHAR2 )
IS
BEGIN
   IF (ord_day_mon_year_stat_db_ = 'MONTH') THEN
      start_date_ := trunc ( start_date_ , 'MONTH') ;
      -- this gives the first of this month
   END IF;
   -- start_date is incremented 1 day later, adjust for that.
   start_date_ := start_date_ - 1;
END Adjust_First_Date___;


-- Fetch_Aggregate_Columns___
--   Aggregation column names of the detail issue table and aggregate
--   table column are fetched
--   The columns are selected by the user when the aggregation is created.
PROCEDURE Fetch_Aggregate_Columns___ (
   col_type_list_  IN OUT VARCHAR2,
   col_agg_list_   IN OUT VARCHAR2,
   col_group_list_ IN OUT VARCHAR2,
   col_issue_list_ IN OUT VARCHAR2,
   company_        IN     VARCHAR2,
   aggregate_id_   IN     NUMBER )
IS
   col_no_ NUMBER;

   CURSOR get_dimension IS
      SELECT b.column_name, b.column_type column_type_db, a.dim_row
      FROM   ORD_AGG_STAT_DIMENSION_TAB a, ord_issue_stat_column_tab b, ORD_AGG_STAT_TAB c
      WHERE  c.aggregate_id = aggregate_id_
      AND    c.company = company_
      AND    a.aggregate_id = c.aggregate_id
      AND    a.company = c.company
      AND    b.issue_id = c.issue_id
      AND    b.column_name = a.dimension
      ORDER BY a.dim_row;

   CURSOR get_column IS
      SELECT b.column_name, b.column_type column_type_db
      FROM   ord_issue_stat_column_tab b, ORD_AGG_STAT_TAB c
      WHERE  c.aggregate_id = aggregate_id_
      AND    c.company = company_
      AND    b.issue_id = c.issue_id
      AND    b.column_name IN (SELECT a.column_name
                               FROM   ORD_AGG_STAT_COLUMN_TAB a
                               WHERE  a.aggregate_id  = aggregate_id_
                               AND    a.company = company_);
BEGIN

   Client_SYS.Add_To_Attr(TO_CHAR(1), 'STRING', col_type_list_);
   Client_SYS.Add_To_Attr(TO_CHAR(1), 'COMPANY', col_agg_list_);
   col_group_list_ := col_agg_list_;
   col_issue_list_ := col_agg_list_;

   col_no_:= 2;
   
   FOR dimrec_ IN get_dimension LOOP
      Client_SYS.Add_To_Attr(to_char(col_no_), dimrec_.column_type_db, col_type_list_);
      Client_SYS.Add_To_Attr(to_char(col_no_), dimrec_.column_name, col_agg_list_);
      Client_SYS.Add_To_Attr(to_char(col_no_), dimrec_.column_name, col_group_list_);
      Client_SYS.Add_To_Attr(to_char(col_no_), dimrec_.column_name, col_issue_list_);
      col_no_ := col_no_ + 1;
   END LOOP;
   FOR colrec_ IN get_column LOOP
      Client_SYS.Add_To_Attr(to_char(col_no_), colrec_.column_type_db, col_type_list_);
      Client_SYS.Add_To_Attr(to_char(col_no_), colrec_.column_name, col_agg_list_);
      Client_SYS.Add_To_Attr(to_char(col_no_), 'sum(' || rtrim(colrec_.column_name) || ')', col_issue_list_);
      col_no_ := col_no_ + 1;
   END LOOP;
END Fetch_Aggregate_Columns___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Do_Aggregate__
--   Aggregation procedure which process a given company and aggregate_id
PROCEDURE Do_Aggregate__ (
   attr_   IN VARCHAR2)
IS 
   agg_lu_         VARCHAR2(100);
   issue_lu_       VARCHAR2(100);
   issue_id_       VARCHAR2(200);
   agg_view_       VARCHAR2(100);
   issue_view_     VARCHAR2(100);
   stmt_           VARCHAR2(1000);
   start_date_     DATE;
   next_date_      DATE;
   col_type_list_  VARCHAR2(32000);
   col_agg_list_   VARCHAR2(32000);
   col_issue_list_ VARCHAR2(32000);
   col_group_list_ VARCHAR2(32000);
   last_execution_ DATE;   
   proc_attr_      VARCHAR2(500);
   date_col_       VARCHAR2(30);
   insert_log_     BOOLEAN;
   aggrec_         ORD_AGG_STAT_TAB%ROWTYPE; 
   aggregate_id_   NUMBER;
   company_        VARCHAR2(20);
   TYPE get_start_date_type IS REF CURSOR;
   get_start_date_ get_start_date_type; 
   row_locked      EXCEPTION;  
   PRAGMA EXCEPTION_INIT(row_locked, -00054);
      
   CURSOR get_date_column IS
      SELECT date_column
      FROM   ord_issue_stat_tab
      WHERE  issue_id = aggrec_.issue_id; -- aggrec_ contains db-valeus uonly

   CURSOR get_last_execution_date IS
      SELECT execution_date
      FROM   ord_detail_stat_log_tab
      WHERE  issue_id = aggrec_.issue_id
      AND    company = company_;

   CURSOR log_lock_control IS
      SELECT *
      FROM  ORD_AGG_STAT_TAB
      WHERE company = company_
      AND   aggregate_id = aggregate_id_
      FOR UPDATE NOWAIT;  

BEGIN

   company_ := Client_SYS.Get_Item_Value('COMPANY', attr_);
   aggregate_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('AGGREGATE_ID', attr_));  
  
   
   OPEN log_lock_control;
   FETCH log_lock_control INTO aggrec_;
   CLOSE log_lock_control;   
  
   issue_id_ := Ord_Aggregate_Issue_API.Decode(aggrec_.issue_id);
   --- select the transaction date for the issue
   OPEN get_date_column;
   FETCH get_date_column INTO date_col_;
   CLOSE get_date_column;
   -- create the aggregate LU and detail LU view names
   -- using the LU names in the IssueStat LU
   agg_lu_       := Ord_Issue_Stat_API.Get_Aggregate_Lu(issue_id_);
   issue_lu_     := Ord_Issue_Stat_API.Get_Detail_Lu(issue_id_);
   agg_view_     := Prep_View_Name___(agg_lu_);
   issue_view_   := Prep_View_Name___(issue_lu_);
   -- select the last process date for the aggregate file and
   -- check whether next process date is due
   -- the last process date is not in the aggregate LU then fetch it from the
   -- detail LU.
   Assert_Sys.Assert_Is_View(agg_view_);
   stmt_ := ' SELECT MAX(end_date) FROM ' || agg_view_ ||
            ' WHERE aggregate_id = :agg_id
              AND   company = :company';

   @ApproveDynamicStatement(2009-12-08,MaMalk)
   OPEN get_start_date_ FOR stmt_ USING aggregate_id_, company_;
   FETCH get_start_date_ INTO start_date_;
   CLOSE get_start_date_;

   IF (start_date_ IS NULL) THEN
      -- aggregate has not been run before so get the first date
      -- from the issue as start date
      Assert_Sys.Assert_Is_View(issue_view_);
      Assert_Sys.Assert_Is_View_Column(issue_view_, date_col_);
      stmt_ := ' SELECT MIN(' || date_col_  || ') FROM ' || issue_view_||
               ' WHERE company = :company_';

      @ApproveDynamicStatement(2009-12-08,MaMalk)
      OPEN get_start_date_ FOR stmt_ USING company_;
      FETCH get_start_date_ INTO start_date_;
      CLOSE get_start_date_;
      -- here we have to fix the start date to really include
      -- the first date
      -- we also have to move back to the start of the month
      adjust_first_date___(start_date_, aggrec_.ord_day_mon_year_stat); -- aggrec_ has only db-values
   END IF;

   --- read the aggregtes to process2
   -- if there is still no start date; its an error
   IF (start_date_ IS NOT NULL) THEN

      -- Get the next date (really its the last date in this aggregate)
      next_date_ := Get_Next_Date___(start_date_,
                                     aggrec_.ord_day_mon_year_stat, -- aggrec_ has only db-values
                                     aggrec_.ord_week_day_stat,
                                     aggrec_.time_block);
      -- start date was already included in  the prvious aggregation
      -- so we move start date another day forward.
      start_date_     := start_date_ + 1;
      col_type_list_  := NULL;
      col_agg_list_   := NULL;
      col_group_list_ := NULL;
      col_issue_list_ := NULL;
 
      --- read the aggregates to process4
      Fetch_Aggregate_Columns___(col_type_list_  ,
                                 col_agg_list_   ,
                                 col_group_list_ ,
                                 col_issue_list_ ,
                                 company_,
                                 aggregate_id_);

      --- read the aggregtes to process8
      insert_log_ := NOT(Ord_Agg_Stat_Log_API.Exist(company_, aggregate_id_));
        

      --- read the aggregates to process9
      -- get the aggregate record for the aggId_0
      OPEN get_last_execution_date;
      FETCH get_last_execution_date INTO last_execution_;
      CLOSE get_last_execution_date;
      IF last_execution_ IS NULL THEN
         Error_SYS.Record_General(lu_name_,'NODETSTAT: There is no successful detail statistics for :P1 for company :P2.', issue_id_, company_);
      END IF;
      IF ( trunc(next_date_) > trunc(last_execution_) ) THEN
         Error_SYS.Record_General(lu_name_,'TOSMASTAT: There is not enough detail statistics for company :P1 and aggregation id :P2.', company_, aggregate_id_);
      END IF;

      -- get the aggregate record for the aggId_1
      WHILE (trunc(next_date_) <= trunc(last_execution_)) LOOP
         Client_SYS.Clear_Attr(proc_attr_);
         IF insert_log_ THEN
            Client_SYS.Add_To_Attr('COMPANY',      company_,                   proc_attr_);            
            Client_SYS.Add_To_Attr('AGGREGATE_ID', aggregate_id_,              proc_attr_);            
            Client_SYS.Add_To_Attr('FROM_DATE',    start_date_,                proc_attr_);
            Client_SYS.Add_To_Attr('END_DATE',     next_date_,                 proc_attr_);
            Client_SYS.Add_To_Attr('VIEW_NAME',    rtrim(agg_view_) || '_TAB', proc_attr_);            
            Ord_Agg_Stat_Log_API.New(proc_attr_);

            insert_log_ := FALSE;
         ELSE                        
            Client_SYS.Add_To_Attr('END_DATE', next_date_, proc_attr_);
            Ord_Agg_Stat_Log_API.Modify(proc_attr_, company_, aggregate_id_);
         END IF;         

         Start_Batch___(col_issue_list_,
                        col_group_list_,
                        col_type_list_,
                        col_agg_list_,
                        company_, 
                        aggregate_id_,
                        start_date_,
                        next_date_,
                        issue_view_,
                        agg_view_,
                        date_col_);
            
         -- get the aggregate record for the aggId_3
         start_date_ := next_date_;
         next_date_ := Get_Next_Date___(start_date_, aggrec_.ord_day_mon_year_stat,
                                       aggrec_.ord_week_day_stat, aggrec_.time_block);
         start_date_ := start_date_ + 1;
      END LOOP;         
   END IF;
EXCEPTION
   WHEN row_locked THEN
      IF (log_lock_control%ISOPEN) THEN
         CLOSE log_lock_control;
      END IF;
      Error_SYS.Record_General(lu_name_, 'RUNNING: Customer order statistics data aggregation is already started for company :P1 and aggregation id :P2.', company_, aggregate_id_);   
END Do_Aggregate__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Validate_Params
--   Validates the parameters when running the Schedule for Aggregated
--   Order Statistics.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   aggregate_id_            NUMBER;
   company_                 VARCHAR2(20);
BEGIN
   
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY_') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'AGG_ID_LIST_') THEN
         aggregate_id_ := value_arr_(n_);          
      END IF;
   END LOOP;

   IF (company_ IS NOT NULL) THEN
      Company_API.Exist(company_);
      Company_Finance_API.Exist(company_);
   END IF;

   IF (aggregate_id_ IS NOT NULL) THEN
      Ord_Agg_Stat_API.Exist(company_, aggregate_id_);
   END IF; 
END Validate_Params;


-- Do_Aggregate
--   This function performs the statistical aggregation for the AggregateId.
--   The AggregateId is there in the given AggIdList. This procedure does
--   the actual aggregation by calling the procedure StartBatchJob.
PROCEDURE Do_Aggregate (
    message_ IN VARCHAR2)
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   company_                 VARCHAR2(20);
   aggregate_id_            NUMBER;
   desc_                    VARCHAR2(2000);
   attr_                    VARCHAR2(2000);
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY_') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'AGG_ID_LIST_') THEN
         aggregate_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));          
      END IF;
   END LOOP;
   
   IF (aggregate_id_ IS NOT NULL AND company_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('AGGREGATE_ID', aggregate_id_, attr_);
      
      IF (Transaction_SYS.Is_Session_Deferred()) THEN
          Do_Aggregate__(attr_);
      ELSE
         desc_ := Language_SYS.Translate_Constant(lu_name_, 'ORDAGGSTAT: Customer order statistics aggregation for company :P1 and aggregation_id :P2.', NULL, company_, aggregate_id_);
         Transaction_SYS.Deferred_Call('ORD_AGG_STAT_UTIL_API.Do_Aggregate__', attr_, desc_);   
      END IF;
   END IF;   
END Do_Aggregate;

-- Get_View_From_Lu
--   Convert the LU name to the View name
FUNCTION Get_View_From_Lu (
   lu_name_    IN VARCHAR2) RETURN varchar2
IS
   n_len_   NUMBER;
   s_tab_   VARCHAR2(100);
   n_       NUMBER:= 2;
   s_char_  VARCHAR2(1);
   view_    VARCHAR2(100);
BEGIN
   n_len_ := LENGTH(lu_name_);
   s_tab_ := UPPER(SUBSTR(lu_name_, 0, 1));
   WHILE (n_< n_len_+1)
   LOOP
      s_char_ := SUBSTR(lu_name_, n_, 1);
      IF (s_char_ = UPPER(s_char_)) THEN
         s_tab_ := CONCAT(s_tab_, '_'); 
      END IF;
      s_tab_ := CONCAT(s_tab_, UPPER(s_char_));
      n_ := n_ + 1;
   END LOOP;
   view_ := s_tab_;
   RETURN view_;
END Get_View_From_Lu;

