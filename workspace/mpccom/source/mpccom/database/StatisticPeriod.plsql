-----------------------------------------------------------------------------
--
--  Logical unit: StatisticPeriod
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140321  AwWelk   PBSC-7677, Modified Insert_Or_Update__ () to correctly insert basic data translations.
--  130812  MaIklk   TIBE-939, Removed inst_InventValue_ global variable and used conditional compilation instead.
--  120507  JeLise   Replaced call to Module_Translate_Attr_Util_API.Get_Attribute_Translation with call to 
--  120507           Basic_Data_Translation_API.Get_Basic_Data_Translation in views STATISTIC_PERIOD and STATISTIC_PERIOD4.
--  120507           Added calls to Basic_Data_Translation_API in Insert___, Update___ and Delete___ and removed calls to
--  120507           Module_Translate_Attr_Util_API in Delete___, New___, Modify___ and Insert_Or_Update__.
--  120202  ChJalk   Added format DATE to the view comments of the columns begin_date and end_date in the base view.
--  100430  Ajpelk   Merge rose method documentation
--  100120  MaMalk   Used global lu constants to replace the calls to Dictionary_SYS.Logical_Unit_Is_Installed
--  100120           in the business logic.
--  091030   KiSalk   Bug 86768, Merged IPR to APP75 Core.
--  --------------------------- 14.0.0 -----------------------------------------
--  090122  HoInlk   Bug 79846, Removed length restrictions of number variables 
--  090122           average_period_ and periods_per_year_.
--  081224  PraWlk   Bug 78336, Added method Get_Previous_Year.
--  080502  Prawlk   Bug 73471, Deleted the method call General_SYS.Init_Method from PROCEDURE
--  080502           Current_Statistic_Period and PROCEDURE Get_Statistic_Period.
--  071016  MarSlk   Bug 67930, Modified Check_Delete___, to validate the deletion
--  071016           of statistic periods.
--  060123  JaJalk  Added Assert safe annotation.
--  051124  JoEd     Changed stat_year_no column comments for VIEW and VIEW4.
--  050927  HaPulk   Modification in Unpack_Check_Update___ to execute Inventory_Value_API
--                   when Begin and End dates are changed.
--  050607  SaJjlk   Further modifications to view STATISTIC_PERIOD4.
--  050419  SaJjlk   Added view STATISTIC_PERIOD4.
--  041213  HaPulk   Modification in updatable columns in Insert_Or_Update__.
--  041117  AnLaSe   Added methods Get_Begin_Date and Get_End_Date.
--  041026  HaPulk   Moved methods Insert_Lu_Translation from Insert___ to New__ and
--  041026           Modify_Translation from Update___ to Modify__.
--  041013  HaPulk   Added new method Is_Period_Closed___ to check whether period should be closed.
--  040929  HaPulk   Renamed Insert_Lu_Data_Rec__ as Insert_Or_Update__ and changed the logic.
--  040224  SaNalk   Removed SUBSTRB.
--  ----------------------------- 13.3.0 --------------------------------------
--  030930  ThGulk   Changed substr to substrb, instr to instrb, length to lengthb.
--  030922  KiSalk   Applied LCS Bug 38942, Added Functions Get_Stat_Year_No and Get_Stat_Period_No.
--  030910  ThPalk   Bug 38287, Added an additional check to see whether the INVENTORY_VALUE_TAB is empty in Unpack_Check_Update___.
--  020118  DaMase   IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  011001  JeLise   Bug fix 24752, Removed check on newrec_.begin_date in Unpack_Check_Insert___.
--  000925  JOHESE   Added undefines.
--  000616  JOHW     Corrected the check when changing the end date.
--  000615  JOHW     Corrected the check off begin_date in unpack_check_update.
--  000608  JOHW     Added checks on modify off begin_date and insert, deleting
--                   present periods.
--  000531  JOHW     Added trunc on date in Get_Statistic_Period.
--  000512  SHVE     Fixed leap year error in Get_Median_Period.
--  000418  NISOSE   Added General_SYS.Init_Method in Current_Statistic_Period and
--                   made a correction in Get_Desired_Period.
--  991104  ANHO     Bug fix 12288; Corrected Get_Average_Period so it can handle leap years.
--  990506  ROOD     Removed PL-statements from cursor in method Get_Median_Period.
--  990504  SHVE     Removed Check_Stat_Period. Changed parameters to the
--                   function Get_Begin_Dates.
--  990423  DAZA     General performance improvements.
--  990413  JOHW     Upgraded to performance optimized template.
--  990212  JOKE     Added Get_Previous_Period with Stat_year_no and stat_period_no
--                   as inparameters.
--  971121  TOOS     Upgrade to F1 2.0
--  970313  MAGN     Changed tablename mpc_stat_period to statistic_period_tab.
--  970226  MAGN     Uses column rowversion as objversion(timestamp).
--  961217  JOKE     Changed Get_Num_Of_Periods so that it returns number of
--                   periods even if the starting or ending period isn't found in
--                   statistic_period.
--  961211  JOKE     Modified with workbench default template.
--  960919  JICE     Added procedure Current_Statistics_Period.
--  960917  JICE     Added procedure Get_Num_Of_Periods.
--  960830  MAOR     Added handle of exception not found in Get_Desired_Period.
--  960829  MAOR     Added procedure Get_Desired_Period.
--  960821  MAOR     Added procdeure Get_Previous_Period.
--  960726  AnAr     Changed procedure Check_Valid_Date.
--  960701  HARH     Added functions Get_Average_Period,
--                   Get_Periods_Per_Year, Check_Stat_Period and
--                   procedures Get_Begin_Dates, Get_Median_Period
--  960628  AnAr     Added procedure Check_Valid_Date.
--  960517  AnAr     Added purpose comment to file.
--  960307  SHVE     Changed LU Name GenStatPeriod.
--  951011  STOL     Base Table to Logical Unit Generator 1.0
--  951123  STOL     Added view 2 and 3 for special LOV in INVENTORY VALUE
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_Period_Closed___ (
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER ) RETURN BOOLEAN
IS
   CURSOR get_current_period IS
      SELECT TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')), TO_NUMBER(TO_CHAR(SYSDATE, 'MM'))
        FROM DUAL;

   current_year_     NUMBER;
   current_period_   NUMBER;
BEGIN
   OPEN get_current_period;
   FETCH get_current_period INTO current_year_, current_period_;
   CLOSE get_current_period;

   IF stat_year_no_ < current_year_ THEN
      RETURN TRUE;
   ELSIF stat_year_no_ > current_year_ THEN
      RETURN FALSE;
   ELSE
      IF stat_period_no_ >= current_period_ THEN
         RETURN FALSE;
      ELSE
         RETURN TRUE;
      END IF;
   END IF;
END Is_Period_Closed___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT STATISTIC_PERIOD_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF Is_Period_Closed___ (newrec_.stat_year_no, newrec_.stat_period_no) THEN
      newrec_.period_closed := 'Y';
   ELSE
      newrec_.period_closed := 'N';
   END IF;
   Client_SYS.Add_To_Attr('PERIOD_CLOSED', Period_Closed_API.Decode (newrec_.period_closed), attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN STATISTIC_PERIOD_TAB%ROWTYPE )
IS
   record_exist_ NUMBER;
BEGIN
   IF ( trunc(remrec_.begin_date) <= (trunc(sysdate) + 1) ) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         record_exist_ := Inventory_Value_API.Is_Any_Record_Exist();
      $ELSE
         record_exist_ := 0;
      $END

      IF (record_exist_ = 1 )THEN
         Error_SYS.Record_General('StatisticPeriod', 'DELETEPERIOD: Deleting current or present period is not allowed.');
      END IF;
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT statistic_period_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   
   Check_Valid_Date__ (newrec_.begin_date,newrec_.end_date,'');

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     statistic_period_tab%ROWTYPE,
   newrec_ IN OUT statistic_period_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_            VARCHAR2(30);
   value_           VARCHAR2(4000);
   old_begin_date_  DATE;
   old_end_date_    DATE;
   record_exist_    NUMBER;
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
BEGIN
   old_begin_date_ := oldrec_.begin_date;
   old_end_date_   := oldrec_.end_date;

   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PERIOD_CLOSED', newrec_.period_closed);

   IF (trunc(old_begin_date_) != trunc(newrec_.begin_date)) OR
      (trunc(old_end_date_) != trunc(newrec_.end_date)) THEN
      IF (trunc(old_begin_date_) <= (trunc(sysdate) + 1)) OR
         (trunc(old_end_date_) <= (trunc(sysdate) + 1)) THEN
         $IF (Component_Invent_SYS.INSTALLED) $THEN
            record_exist_ := Inventory_Value_API.Is_Any_Record_Exist();            
         $ELSE
            record_exist_ := 0;
         $END
         IF (record_exist_ = 1 )THEN
            Error_SYS.Record_General('StatisticPeriod', 'CURRPERIOD: Begin Date or End Date may not be change for a current or present period.');
         END IF;
      END IF;
   END IF;
   Get_Id_Version_By_Keys___(objid_, objversion_, oldrec_.stat_year_no, oldrec_.stat_period_no);
   Check_Valid_Date__ (newrec_.begin_date,newrec_.end_date,objid_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Valid_Date__
--   Checks whether a specific record may be added or not.
PROCEDURE Check_Valid_Date__ (
   begin_date_  IN DATE,
   end_date_    IN DATE,
   rowid_       IN VARCHAR2 )
IS
   CURSOR check_date IS
      SELECT 1
      FROM  STATISTIC_PERIOD_TAB
      WHERE (trunc(begin_date_) between begin_date and end_date
       OR   trunc(end_date_) between begin_date and end_date
       OR   trunc(begin_date_) <= begin_date
       AND  trunc(end_date_) >= end_date);

   CURSOR check_date_rowid IS
      SELECT 1
      FROM  STATISTIC_PERIOD_TAB
      WHERE (trunc(begin_date_) between begin_date and end_date
       OR   trunc(end_date_) between begin_date and end_date
       OR   trunc(begin_date_) <= begin_date
       AND  trunc(end_date_) >= end_date)
       AND  rowid != rowid_;

   check_             NUMBER;
   data_found         EXCEPTION;
   invalid_date_found EXCEPTION;
BEGIN
   IF trunc(begin_date_) > trunc(end_date_) THEN
      RAISE invalid_date_found;
   ELSE
      IF (rowid_ is null) THEN
         OPEN check_date;
         FETCH check_date into check_;
         IF check_date%FOUND THEN
            RAISE data_found;
         END IF;
         IF (check_date%ISOPEN) THEN
            CLOSE check_date;
         END IF;
      ELSE
         OPEN check_date_rowid;
         FETCH check_date_rowid into check_;
         IF check_date_rowid%FOUND THEN
            RAISE data_found;
         END IF;
         IF (check_date_rowid%ISOPEN) THEN
            CLOSE check_date_rowid;
         END IF;
      END IF;
   END IF;

EXCEPTION
   WHEN data_found THEN
      Error_SYS.Record_General('StatisticPeriod', 'ILLEGAL_DATE: This period overlaps another period.');
   WHEN invalid_date_found THEN
      Error_SYS.Record_General('StatisticPeriod', 'INVALID_DATE: Invalid date interval.');
END Check_Valid_Date__;


-- Insert_Or_Update__
--   Handles component translations
PROCEDURE Insert_Or_Update__ (
   rec_        IN STATISTIC_PERIOD_TAB%ROWTYPE )
IS
   dummy_              VARCHAR2(1);
   period_closed_db_   VARCHAR2(1);
   key_                VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   attr_               VARCHAR2(32000);
   newrec_             STATISTIC_PERIOD_TAB%ROWTYPE;
   oldrec_             STATISTIC_PERIOD_TAB%ROWTYPE;
   indrec_             Indicator_Rec;
   CURSOR Exist IS
      SELECT 'X'
      FROM STATISTIC_PERIOD_TAB
      WHERE stat_year_no = rec_.stat_year_no
      AND stat_period_no = rec_.stat_period_no;
BEGIN
   Client_SYS.Clear_Attr(attr_);

   OPEN Exist;
   FETCH Exist INTO dummy_;
   key_ := rec_.stat_year_no || '^' || rec_.stat_period_no || '^';
   IF (Exist%NOTFOUND) THEN
      Client_SYS.Add_To_Attr('STAT_YEAR_NO', rec_.stat_year_no, attr_);
      Client_SYS.Add_To_Attr('STAT_PERIOD_NO', rec_.stat_period_no, attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
      Client_SYS.Add_To_Attr('BEGIN_DATE', rec_.begin_date, attr_);
      Client_SYS.Add_To_Attr('END_DATE', rec_.end_date, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      
      IF Is_Period_Closed___ (newrec_.stat_year_no, newrec_.stat_period_no) THEN
         newrec_.period_closed := 'Y';
      ELSE
         newrec_.period_closed := 'N';
      END IF;
      newrec_.rowversion := sysdate;
      
      INSERT
         INTO statistic_period_tab
         VALUES newrec_
         RETURNING rowid INTO objid_;
   ELSE
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.stat_year_no, rec_.stat_period_no);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      IF oldrec_.period_closed IS NULL THEN
         IF Is_Period_Closed___ (newrec_.stat_year_no, newrec_.stat_period_no) THEN
            period_closed_db_ := 'Y';
         ELSE
            period_closed_db_ := 'N';
         END IF;
         Client_SYS.Add_To_Attr('PERIOD_CLOSED_DB', period_closed_db_, attr_);
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
            
      newrec_.rowversion := sysdate;   
      
      UPDATE statistic_period_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   
   -- Insert Data into Basic Data Translations tab
   Basic_Data_Translation_API.Insert_Prog_Translation('MPCCOM',
                                                      'StatisticPeriod',
                                                      newrec_.stat_year_no||'^'||newrec_.stat_period_no,
                                                      newrec_.description);
                                                      
   CLOSE Exist;
END Insert_Or_Update__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Statistic_Period
--   Get statistic period for date.
@UncheckedAccess
PROCEDURE Get_Statistic_Period (
   stat_year_no_   OUT NUMBER,
   stat_period_no_ OUT NUMBER,
   date_           IN  DATE )
IS
   CURSOR get_period IS
      SELECT stat_year_no, stat_period_no
      FROM STATISTIC_PERIOD_TAB
      WHERE trunc(date_) BETWEEN begin_date AND end_date;
BEGIN
   OPEN get_period;
   FETCH get_period
   INTO stat_year_no_, stat_period_no_;
   CLOSE get_period;
END Get_Statistic_Period;


@UncheckedAccess
FUNCTION Get_Average_Period RETURN NUMBER
IS
   average_period_         NUMBER := 0;
   CURSOR get_a_period IS
      SELECT   AVG(1 + ABS(end_date - begin_date))
      FROM  STATISTIC_PERIOD_TAB
      WHERE begin_date >= trunc(add_months(sysdate,-12))
      AND   begin_date < trunc(SYSDATE);
BEGIN
   OPEN  get_a_period;
   FETCH get_a_period INTO  average_period_;
   IF get_a_period%NOTFOUND THEN
      CLOSE get_a_period;
      RETURN (0);
   END IF;
   CLOSE get_a_period;
   RETURN average_period_;
END Get_Average_Period;


@UncheckedAccess
FUNCTION Get_Periods_Per_Year RETURN NUMBER
IS
   periods_per_year_     NUMBER := 0;
   CURSOR check_exists IS
      SELECT  COUNT(DISTINCT stat_period_no)
        FROM  STATISTIC_PERIOD_TAB;
BEGIN
   OPEN  check_exists;
   FETCH check_exists
   INTO  periods_per_year_;
   IF check_exists%NOTFOUND THEN
      CLOSE check_exists;
      RETURN (0);
   END IF;
   CLOSE check_exists;
   RETURN periods_per_year_;
END Get_Periods_Per_Year;


-- Get_Begin_Dates
--   Get begin date first and last when periods is known.
PROCEDURE Get_Begin_Dates (
   begin_date_first_ OUT DATE,
   begin_date_last_  OUT DATE,
   periods_          IN  NUMBER )
IS
   begin_date_ DATE;
   CURSOR get_begin_date IS
      SELECT begin_date
      FROM STATISTIC_PERIOD_TAB
      WHERE end_date < SYSDATE
      ORDER BY begin_date DESC;
BEGIN
   begin_date_first_    := null;
   begin_date_last_     := null;
   begin_date_          := null;
   OPEN get_begin_date;
--
-- Fetch loop get_begin_date starts
   FOR date_count_ IN 1..periods_ LOOP
      FETCH get_begin_date
      INTO  begin_date_;
      EXIT WHEN get_begin_date%NOTFOUND;

      begin_date_first_    := begin_date_;
      IF date_count_ = 1 THEN
         begin_date_last_  := begin_date_;
      END IF;
   END LOOP;
   CLOSE get_begin_date;

END Get_Begin_Dates;


-- Get_Median_Period
--   Get Median Period for the part
PROCEDURE Get_Median_Period (
   median_period_     OUT NUMBER,
   average_period_    IN  NUMBER,
   work_days_         IN  NUMBER,
   lead_time_code_db_ IN  VARCHAR2 )
IS
   CURSOR get_m_period IS
       SELECT DECODE(lead_time_code_db_,
                'M',
                  ((1 + (end_date - begin_date)) *
                   work_days_ ) / 7,
                'P',
                  (1 + (end_date - begin_date)) )
       FROM STATISTIC_PERIOD_TAB
       WHERE begin_date >= trunc(add_months(sysdate,-12))
       AND   begin_date < trunc(SYSDATE)
       ORDER BY ABS(1 + (end_date - begin_date) -
                     average_period_);
BEGIN
   median_period_ := 0.0;
   OPEN  get_m_period;
   FETCH get_m_period   INTO  median_period_;
   IF get_m_period%NOTFOUND THEN
      median_period_ := 0.0;
   END IF;
   CLOSE get_m_period;
END Get_Median_Period;


-- Current_Statistic_Period
--   Get current period from statistic_period_tab.
@UncheckedAccess
PROCEDURE Current_Statistic_Period (
   stat_year_no_    OUT NUMBER,
   stat_period_no_  OUT NUMBER )
IS
BEGIN
   Get_Statistic_Period(stat_year_no_, stat_period_no_, SYSDATE);
END Current_Statistic_Period;


-- Get_Previous_Period
--   Get previous period from statistic_period_tab.
--   Get previous period from statistic_period_tab.
PROCEDURE Get_Previous_Period (
   stat_year_no_    OUT NUMBER,
   stat_period_no_  OUT NUMBER,
   end_date_        IN  DATE )
IS
--
   CURSOR Get_Previous_Period IS
      SELECT stat_year_no, stat_period_no
      FROM   STATISTIC_PERIOD_TAB
      WHERE  end_date < trunc(end_date_)
      ORDER BY end_date desc;
--
BEGIN
--
   OPEN Get_Previous_Period;
   FETCH Get_Previous_Period
   INTO stat_year_no_, stat_period_no_;
   CLOSE Get_Previous_Period;
--
END Get_Previous_Period;


-- Get_Previous_Period
--   Get previous period from statistic_period_tab.
--   Get previous period from statistic_period_tab.
PROCEDURE Get_Previous_Period (
   previous_year_no_     OUT NUMBER,
   previuos_period_no_   OUT NUMBER,
   stat_year_no_         IN  NUMBER,
   stat_period_no_       IN  NUMBER )
IS
   CURSOR Get_End_Date IS
      SELECT end_date
        FROM STATISTIC_PERIOD_TAB
       WHERE stat_year_no   = stat_year_no_
         AND stat_period_no = stat_period_no_;

   end_date_   DATE;
BEGIN

   OPEN  Get_End_Date;
   FETCH Get_End_Date INTO end_date_;
   CLOSE Get_End_Date;

   Statistic_Period_API.Get_Previous_Period ( previous_year_no_,
                                              previuos_period_no_,
                                              end_date_ );
END Get_Previous_Period;


-- Get_Next_Period
--   Get next period from statistic_period_tab.
PROCEDURE Get_Next_Period (
   next_year_no_     OUT NUMBER,
   next_period_no_   OUT NUMBER,
   stat_year_no_     IN  NUMBER,
   stat_period_no_   IN  NUMBER )
IS
   end_date_ DATE;

   CURSOR get_next_period IS
      SELECT stat_year_no, stat_period_no
        FROM STATISTIC_PERIOD_TAB
       WHERE end_date > end_date_
      ORDER BY end_date;
BEGIN

   end_date_ := Get_End_Date(stat_year_no_, stat_period_no_);

   OPEN  get_next_period;
   FETCH get_next_period INTO next_year_no_, next_period_no_;
   CLOSE get_next_period;
END Get_Next_Period;


-- Get_Desired_Period
--   Get stat_year_no and stat_perod_no corresponding to desired_periods
--   back in time
PROCEDURE Get_Desired_Period (
   stat_year_no_    OUT NUMBER,
   stat_period_no_  OUT NUMBER,
   date_            IN  DATE,
   desired_periods_ IN  NUMBER )
IS
--
  count_periods_ NUMBER;
--
   CURSOR get_stat_no IS
      SELECT stat_year_no, stat_period_no
      FROM   STATISTIC_PERIOD_TAB
      WHERE  begin_date <= date_
      ORDER BY stat_year_no DESC, stat_period_no DESC;
--
BEGIN
   
   count_periods_ := 0;
   FOR stat_rec IN get_stat_no LOOP
      stat_period_no_ := stat_rec.stat_period_no;
      stat_year_no_   := stat_rec.stat_year_no;
      count_periods_  := count_periods_ + 1;
      
      IF (count_periods_ >= desired_periods_) THEN
        exit;
      END IF;
   END LOOP;
   
   IF (count_periods_ = 0) THEN
       Error_SYS.Record_General('StatisticPeriod', 'NOPERIOD: The periods that was desired was not found back in time');
   END IF;
END Get_Desired_Period;


-- Get_Num_Of_Periods
--   Counts number of periods between.
@UncheckedAccess
FUNCTION Get_Num_Of_Periods (
   stat_year_no_   IN NUMBER,
   stat_period_no_ IN NUMBER,
   end_year_no_    IN NUMBER,
   end_period_no_  IN NUMBER ) RETURN NUMBER
IS
   return_          NUMBER;
   min_begin_date_  DATE;
   max_begin_date_  DATE;

   CURSOR period_num IS
      SELECT count(*)
      FROM STATISTIC_PERIOD_TAB
      WHERE begin_date >= min_begin_date_
      AND begin_date <= max_begin_date_;

   CURSOR get_begin_date (year_no_   NUMBER,
                          period_no_ NUMBER ) IS
      SELECT begin_date 
      FROM STATISTIC_PERIOD_TAB
      WHERE  stat_year_no = year_no_
      AND    stat_period_no = period_no_;

   CURSOR get_min_begin_date IS
      SELECT MIN(begin_date)
      FROM STATISTIC_PERIOD_TAB;

   CURSOR get_max_begin_date IS
      SELECT MAX(begin_date)
      FROM STATISTIC_PERIOD_TAB;
BEGIN
   OPEN  get_begin_date ( stat_year_no_, stat_period_no_ );
   FETCH get_begin_date INTO min_begin_date_;

   IF get_begin_date%NOTFOUND THEN
      OPEN  get_min_begin_date;
      FETCH get_min_begin_date INTO min_begin_date_;
      CLOSE get_min_begin_date;
   END IF;
   CLOSE get_begin_date;
   
   OPEN  get_begin_date ( end_year_no_, end_period_no_ );
   FETCH get_begin_date INTO max_begin_date_;

   IF get_begin_date%NOTFOUND THEN
      OPEN  get_max_begin_date;
      FETCH get_max_begin_date INTO max_begin_date_;
      CLOSE get_max_begin_date;
   END IF;
   CLOSE get_begin_date;

   OPEN period_num;
   FETCH period_num
    INTO return_;

   IF period_num%NOTFOUND THEN
      return_ := 0;
   END IF;
   CLOSE period_num;

   RETURN return_;
END Get_Num_Of_Periods;


-- Get_Stat_Year_No
--   Get stat_year_no for desired date
@UncheckedAccess
FUNCTION Get_Stat_Year_No (
   date_ IN DATE ) RETURN NUMBER
IS
   CURSOR get_year IS
      SELECT stat_year_no
      FROM   STATISTIC_PERIOD_TAB
      WHERE  trunc(date_) BETWEEN begin_date AND end_date;

   stat_year_no_ NUMBER;
BEGIN
   OPEN  get_year;
   FETCH get_year INTO stat_year_no_;
   CLOSE get_year;
   RETURN stat_year_no_;
END Get_Stat_Year_No;


-- Get_Stat_Period_No
--   Get stat_period_no for desired date
@UncheckedAccess
FUNCTION Get_Stat_Period_No (
   date_ IN DATE ) RETURN NUMBER
IS
   CURSOR get_period IS
      SELECT stat_period_no
      FROM   STATISTIC_PERIOD_TAB
      WHERE  trunc(date_) BETWEEN begin_date AND end_date;

   stat_period_no_ NUMBER;
BEGIN
   OPEN  get_period;
   FETCH get_period INTO stat_period_no_;
   CLOSE get_period;
   RETURN stat_period_no_;
END Get_Stat_Period_No;


@UncheckedAccess
FUNCTION Get_Previous_Year (
   stat_year_no_ IN NUMBER ) RETURN NUMBER
IS
   previous_year_ STATISTIC_PERIOD_TAB.stat_year_no%TYPE;

   CURSOR get_previous_year IS
      SELECT stat_year_no
        FROM STATISTIC_PERIOD_TAB
       WHERE stat_year_no != stat_year_no_
         AND end_date < (SELECT MIN(end_date)
                           FROM STATISTIC_PERIOD_TAB
                          WHERE stat_year_no = stat_year_no_)
      ORDER BY end_date DESC;
BEGIN
   OPEN get_previous_year;
   FETCH get_previous_year INTO previous_year_;
   CLOSE get_previous_year;
   RETURN (previous_year_);
END Get_Previous_Year;


-- Get_Number_Of_Days
--   Get Number of Days.
@UncheckedAccess
FUNCTION Get_Number_Of_Days (
   begin_year_no_   IN NUMBER,
   begin_period_no_ IN NUMBER,
   end_year_no_     IN NUMBER,
   end_period_no_   IN NUMBER ) RETURN NUMBER
IS
   number_of_days_ NUMBER;
   begin_date_     DATE;
   end_date_       DATE;
BEGIN
   begin_date_     := Get_Begin_Date(begin_year_no_, begin_period_no_);
   end_date_       := Get_End_Date(end_year_no_, end_period_no_);
   number_of_days_ := (end_date_ - begin_date_) + 1;

   RETURN (number_of_days_);
END Get_Number_Of_Days;



