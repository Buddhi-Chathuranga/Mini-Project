-----------------------------------------------------------------------------
--
--  Logical unit: PlanPeriodUnitDef
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171218  Kepese   STRMF-15056, Re-write of Create_New_Period_Units to handle ISO weeks and from-to interval more robustly
--  170814  Ospalk   STRMF-13648, Added a new methods Creat_New_Period_Units() and Remove_Period_Unit() to create and remove period units based on the 
--                   start/end dates and period unit. Modified Create_New_Weeks. Call Creat_New_Period_Units() method inside Create_New_Weeks() method with 
--                   period Unit Week to create Weeks.
--  120507  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. The view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  120202  MaRalk   Correctiong model errors generated from PLSQL implementation test - Removed 
--  120202           ENUMERATION=PlanPeriodUnit from PLAN_PERIOD_UNIT_DEF-PLAN_PERIOD_UNIT_DEF_NO view comments.
--  100430  Ajpelk   Merge rose method documentation
--  ----------------------------Eagle------------------------------------------
--  060111  MiKulk   Modified the PROCEDURE Insert___ according to the new template.
--  050919  NaLrlk   Removed unused variables.
--  050210  SaJjlk   Moved the LU from MFGSTD to MPCCOM.
--  -------------------------------Version 13.3.0-----------------------------
--  031027  ERHOUS   Added a call to General_SYS.Init_Method to Create_Weeks__ and Get_End_Date.
--  030827  Larelk   Bug 37332 Rename Get_Val to Create_New_Weeks and changed it's codes and Get_Max_End.
--  030724  Larelk   Bug 37332 modified Get_Val,Get_Max_End
--  ------  ----  -  ----------------------------------------------------------
--  010412  ERHO     Bug 21337: Added NOCOPY to IN OUT and Out arguments.
--  000306  MAJE     AL 28926 - Replaced call to Get_Db_Value with literal.
--  000225  MGUO     Performance fixes.
--  990803  KEVS     Yoshimura performance tuning.
--  990617  KEVS     Made Template change in Get_Object_By_Id___.
--  990601  MAKU     Al Call Id 19297 - Replaced client with db value for
--                   plan_period_unit_ in Get_End_Date.
--  990427  MAKU     Yoshimura template changes.
--  990128  ANTA     Changed to standard long file name.
--  990123  ANTA     Changed order of methods to match model. Also changed
--                   plan_period_unit to 200 in view comments.
--  990111  MULO     Replaced usage of SYSDATE with Site_API.Get_Site_Date for to_date and from_date in Create_Weeks__.
--  981208  WIGR     Monty IID 820 - changes to calls to Plan_Period_Unit_API
--                   after re-adding the Past client value
--  981112  WIGR     Monty IID 820 - changes to calls to Plan_Period_Unit_API
--                   after removing the Past client value
--  981002  WIGR     Monty IID 820 - Moved to MFGSTD; changed MODULE to MFGSTD
--  980526  JOHW     Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971121  TOOS     Upgrade to F1 2.0
--  971024  LEPE     Redesigned the function Instance_Exist.
--  971022  DAHE     Changed parameter Date to ReferenceDate in InstanceExist
--  971017  DAHE     Added Instance_Exist
--  970725  MAJO     Corrected a bug in create_weeks__. The start year/week was
--                   before 1998/1 if you created the weeks after 19970630.
--  970605  MAJO     Modified create_weeks, made an error message when periods
--                   already exists.
--  970524  MAJO     The field plan_year_no could get wrong value in
--                   create_weeks__.
--  970411  MAJO     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Check_Period_Exist___
--   Returns TRUE if period exists, FALSE otherwise.
FUNCTION Check_Period_Exist___ (
   plan_year_no_        IN NUMBER,
   plan_year_period_no_ IN NUMBER,
   plan_period_unit_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM PLAN_PERIOD_UNIT_DEF_TAB
      WHERE plan_year_no        = plan_year_no_
      AND   plan_year_period_no = plan_year_period_no_
      AND   plan_period_unit    = plan_period_unit_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Period_Exist___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PLAN_PERIOD_UNIT_DEF_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- assign plan_period_unit_def_no
   IF (newrec_.plan_period_unit_def_no IS NULL) THEN
      SELECT Plan_Period_Def_No.NEXTVAL
      INTO   newrec_.plan_period_unit_def_no
      FROM   DUAL;
      --
      Client_SYS.Add_To_Attr( 'PLAN_PERIOD_UNIT_DEF_NO',newrec_.plan_period_unit_def_no , attr_ );
   END IF;
   --
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT plan_period_unit_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   --
   Check_Valid_Date__ (
      newrec_.plan_period_unit,
      newrec_.begin_date,
      newrec_.end_date, '');
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     plan_period_unit_def_tab%ROWTYPE,
   newrec_ IN OUT plan_period_unit_def_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, oldrec_.plan_period_unit_def_no);
   Check_Valid_Date__ (
      newrec_.plan_period_unit,
      newrec_.begin_date,
      newrec_.end_date, objid_);
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Valid_Date__
--   Raise an exeption if the begin date is between the begin and end date.
PROCEDURE Check_Valid_Date__ (
   plan_period_unit_ IN VARCHAR2,
   begin_date_       IN DATE,
   end_date_         IN DATE,
   rowid_            IN VARCHAR2 )
IS
   CURSOR check_date IS
      SELECT 1
      FROM PLAN_PERIOD_UNIT_DEF_TAB
      WHERE (TRUNC(begin_date_) BETWEEN begin_date AND end_date
           OR   TRUNC(end_date_) BETWEEN begin_date AND end_date
           OR   TRUNC(begin_date_) <= begin_date
           AND  TRUNC(end_date_) >= end_date)
      AND  plan_period_unit = plan_period_unit_;

   CURSOR check_date_rowid IS
      SELECT 1
      FROM PLAN_PERIOD_UNIT_DEF_TAB
      WHERE (TRUNC(begin_date_) BETWEEN begin_date AND end_date
           OR   TRUNC(end_date_) BETWEEN begin_date AND end_date
           OR   TRUNC(begin_date_) <= begin_date
           AND  TRUNC(end_date_) >= end_date)
      AND  plan_period_unit = plan_period_unit_
      AND  ROWID != rowid_;
   --
   check_             NUMBER;
   data_found         EXCEPTION;
   invalid_date_found EXCEPTION;

BEGIN
   IF TRUNC(begin_date_) > TRUNC(end_date_) THEN
      RAISE invalid_date_found;
   ELSE
      IF (rowid_ IS NULL) THEN
         OPEN check_date;
         FETCH check_date INTO check_;
         IF check_date%FOUND THEN
            RAISE data_found;
         END IF;
         IF (check_date%ISOPEN) THEN
            CLOSE check_date;
         END IF;
      ELSE
         OPEN check_date_rowid;
         FETCH check_date_rowid INTO check_;
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
      Error_SYS.Record_General('PlanPeriodUnitDef', 'ILLEGAL_DATE: This period overlaps another period.');
   WHEN invalid_date_found THEN
      Error_SYS.Record_General('PlanPeriodUnitDef', 'INVALID_DATE: Invalid date interval.');
END Check_Valid_Date__;


-- Create_Weeks__
--   Creates the weeks for next 4 years
PROCEDURE Create_Weeks__ (
   dummy_ IN NUMBER )
IS
   from_date_        PLAN_PERIOD_UNIT_DEF_TAB.begin_date%TYPE;
   to_date_          PLAN_PERIOD_UNIT_DEF_TAB.begin_date%TYPE;
   week_type_        VARCHAR2(3);
   week_format_      VARCHAR2(10);
   last_week_        VARCHAR2(8);
   week_no_format_   VARCHAR2(3);
   week_start_date_  PLAN_PERIOD_UNIT_DEF_TAB.begin_date%TYPE;
   week_end_date_    PLAN_PERIOD_UNIT_DEF_TAB.begin_date%TYPE;
   week_counter_     NUMBER;
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   attr_             VARCHAR2(2000);
   data_found        EXCEPTION;
   contract_         VARCHAR2(5);
   newrec_           PLAN_PERIOD_UNIT_DEF_TAB%ROWTYPE;
BEGIN
   contract_ := User_Default_API.Get_Contract;
   to_date_:= trunc(last_day(add_months(Site_API.Get_Site_Date(contract_),48)));
   week_type_ := 'ISO';
   from_date_ := trunc(Site_API.Get_Site_Date(contract_),'YYYY');  -- 19970701 => 19970101
   week_counter_  := 0;
   IF (week_type_ = 'ISO') THEN
      week_format_ := 'IYYYIW';
      week_no_format_ := 'IW';
   ELSE
      week_format_ := 'YYYYWW';
      week_no_format_ := 'WW';
   END IF;
   --
   week_start_date_ := trunc(from_date_ - 7);
   last_week_ := to_char(week_start_date_, week_format_);
   WHILE (week_start_date_ <= trunc(to_date_)) LOOP
      IF (last_week_ <> to_char(week_start_date_, week_format_)) THEN
         week_end_date_ := week_start_date_;
         WHILE (to_char(week_end_date_, week_format_) =
                to_char(week_end_date_ + 1, week_format_)) LOOP
            week_end_date_ := week_end_date_ + 1;
         END LOOP;
         --
         week_counter_ := week_counter_ + 1;
         --
         IF (Check_Period_Exist___ (
                to_number(to_char(week_start_date_,'IYYY')),
                to_number(to_char(week_start_date_,week_no_format_),'999'),
                2) ) THEN -- Plan_Period_Unit_API.Get_Db_Value(2)
             RAISE data_found;
         END IF;
         --
         --performance fixes
         --Prepare_Insert___(attr_);
         --Client_SYS.Add_To_Attr('PLAN_YEAR_NO', to_number(to_char(week_start_date_,'IYYY')), attr_);
         --Client_SYS.Add_To_Attr('PLAN_YEAR_PERIOD_NO', to_number(to_char(week_start_date_,week_no_format_),'999'), attr_);
         --Client_SYS.Add_To_Attr('BEGIN_DATE', week_start_date_, attr_);
         --Client_SYS.Add_To_Attr('END_DATE', week_end_date_, attr_);
         --Client_SYS.Add_To_Attr('PLAN_PERIOD_UNIT', Plan_Period_Unit_API.Decode(2), attr_); -- Week
         
         newrec_.plan_year_no := to_number(to_char(week_start_date_,'IYYY'));
         newrec_.plan_year_period_no := to_number(to_char(week_start_date_,week_no_format_),'999');
         newrec_.begin_date := week_start_date_;
         newrec_.end_date := week_end_date_;
         newrec_.plan_period_unit := 2; 
         
         --Unpack_Check_Insert___(attr_, newrec_);
         
         Check_Valid_Date__ (
            newrec_.plan_period_unit,
            newrec_.begin_date,
            newrec_.end_date, '');
         Insert___(objid_, objversion_, newrec_, attr_);
         last_week_ := to_char(week_start_date_, week_format_);
      END IF;
      week_start_date_ := week_start_date_ + 1;
   END LOOP;
EXCEPTION
   WHEN data_found THEN
      Error_SYS.Record_General('PlanPeriodUnitDef',
         'ILLEGAL_WEEK: The year :P1 and week :P2 already exists.',
         to_char(to_number(to_char(week_start_date_,'IYYY'))),
         to_char(to_number(to_char(week_start_date_,week_no_format_),'999')));
END Create_Weeks__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_End_Date
--   Get begin and end date for a specific period unit and for a given
--   period_date. This procedure is used when getting information to
--   dynamic period definition.
PROCEDURE Get_End_Date (
   begin_date_       OUT NOCOPY DATE,
   end_date_         OUT NOCOPY DATE,
   period_date_      IN  DATE,
   plan_period_unit_ IN  VARCHAR2,
   period_length_    IN  NUMBER )
IS
   --
   CURSOR get_dates IS
      SELECT begin_date,
             end_date
      FROM PLAN_PERIOD_UNIT_DEF_TAB
      WHERE plan_period_unit = plan_period_unit_
      AND   begin_date >= (SELECT MAX(begin_date)
                           FROM PLAN_PERIOD_UNIT_DEF_TAB
                           WHERE plan_period_unit = plan_period_unit_
                           AND   begin_date <= period_date_ )
      AND   end_date >= period_date_
      ORDER BY begin_date;
BEGIN
   OPEN get_dates;
   FOR i IN 1..period_length_ LOOP
      FETCH get_dates INTO begin_date_, end_date_;
      IF (get_dates%NOTFOUND) THEN
         Error_SYS.Record_General(lu_name_,
          'EXTENDPLANDEF: The planning period unit definitions must be extended.');
      END IF;
   END LOOP;
   CLOSE get_dates;
END Get_End_Date;


-- Get_Plan_Period
--   Returns the year and PlanPeriodUnit
PROCEDURE Get_Plan_Period (
   plan_year_no_        OUT NOCOPY NUMBER,
   plan_year_period_no_ OUT NOCOPY NUMBER,
   plan_period_unit_    IN  VARCHAR2,
   in_date_             IN  DATE )
IS
   CURSOR get_period IS
   SELECT plan_year_no,
          plan_year_period_no
   FROM PLAN_PERIOD_UNIT_DEF_TAB
   WHERE TRUNC(in_date_) BETWEEN begin_date AND end_date
   AND   plan_period_unit = plan_period_unit_;
BEGIN
   OPEN get_period;
   FETCH get_period INTO plan_year_no_, plan_year_period_no_;
   CLOSE get_period;
END Get_Plan_Period;


-- Instance_Exist
--   Check if a given period unit definition exists.
@UncheckedAccess
FUNCTION Instance_Exist (
   plan_period_unit_  IN VARCHAR2,
   reference_date_    IN DATE ) RETURN NUMBER
IS
   dummy_  VARCHAR2(1);
   CURSOR getrec IS
      SELECT 1
      FROM PLAN_PERIOD_UNIT_DEF_TAB
      WHERE plan_period_unit = plan_period_unit_
      AND   reference_date_ BETWEEN begin_date AND end_date;
BEGIN
   OPEN getrec;
   FETCH getrec INTO dummy_;
   IF (getrec%NOTFOUND) THEN
      CLOSE getrec;
      RETURN 0;
   END IF;
   CLOSE getrec;
   RETURN 1;
END Instance_Exist;


-- Create_New_Weeks
--   Create iso weeks for given date
PROCEDURE Create_New_Weeks (
   to_date_         IN DATE,
   week_start_date_ IN DATE )
IS
BEGIN  
   Create_New_Period_Units(week_start_date_, to_date_, Plan_Period_Unit_API.DB_WEEK);
END Create_New_Weeks;


PROCEDURE Create_New_Period_Units (
   from_date_           IN DATE,
   to_date_             IN DATE,
   plan_period_unit_db_ IN VARCHAR2)
IS
   period_format_    VARCHAR2(10);
   start_date_       PLAN_PERIOD_UNIT_DEF_TAB.begin_date%TYPE;
   end_date_         PLAN_PERIOD_UNIT_DEF_TAB.end_date%TYPE;
   plan_year_format_ VARCHAR2(4);
   attr_             VARCHAR2(2000);
   newrec_           PLAN_PERIOD_UNIT_DEF_TAB%ROWTYPE;

BEGIN   
   IF (plan_period_unit_db_ = Plan_Period_Unit_API.DB_MONTH) THEN
      period_format_  :=  'MM';
      plan_year_format_ := 'YYYY';
   ELSIF (plan_period_unit_db_ = Plan_Period_Unit_API.DB_QUARTER) THEN
      period_format_  :=  'Q';
      plan_year_format_ := 'YYYY';
   ELSIF (plan_period_unit_db_ = Plan_Period_Unit_API.DB_WEEK) THEN
      period_format_ := 'IW';
      plan_year_format_ := 'IYYY';
   END IF;

   -- Position start date so it is the beginning of a period of the desired size
   start_date_ := trunc(from_date_, period_format_); 
   
   end_date_   := from_date_;
   WHILE (end_date_ BETWEEN trunc(from_date_) AND trunc(to_date_)) LOOP 
      -- start date is now at the beginning of a quarter, month or week, 
      -- but we need to set the end date to end of period
      IF (plan_period_unit_db_ = Plan_Period_Unit_API.DB_MONTH) THEN
         end_date_   := trunc(last_day(start_date_));
      ELSIF (plan_period_unit_db_ = Plan_Period_Unit_API.DB_QUARTER) THEN
         end_date_   := trunc(add_months(start_date_, 3), 'Q') - 1;
      ELSIF (plan_period_unit_db_ = Plan_Period_Unit_API.DB_WEEK) THEN
         end_date_   := trunc(start_date_) + 6;  
      END IF;
      
      -- Since we truncated start_date_ before entering the loop, we may be before from_date_ the first time
      -- Likewise, the end_date_ may now be after the to_date_
      IF (start_date_ BETWEEN trunc(from_date_) AND trunc(to_date_)) AND (end_date_ BETWEEN trunc(from_date_) AND trunc(to_date_)) THEN
         -- Check if period already exists
         IF (Check_Period_Exist___ (to_number(to_char(start_date_,plan_year_format_)), to_number(to_char(start_date_,period_format_),'999'), plan_period_unit_db_) ) THEN
            Error_SYS.Record_General('PlanPeriodUnitDef',
            'ILLEGAL_PU: The year :P1 and period unit :P2 already exists.',
            to_char(to_number(to_char(start_date_,plan_year_format_))),
            to_char(to_number(to_char(start_date_,period_format_),'999')));
         END IF;

         -- Create new record
         newrec_.plan_year_no := to_number(to_char(start_date_,plan_year_format_));
         newrec_.plan_year_period_no := to_number(to_char(start_date_,period_format_),'999');
         newrec_.begin_date := start_date_;
         newrec_.end_date := end_date_;
         newrec_.plan_period_unit := plan_period_unit_db_;
         New___(newrec_);

         newrec_.plan_period_unit_def_no := NULL;
         newrec_.plan_year_no            := NULL;
         newrec_.plan_year_period_no     := NULL;
         newrec_.begin_date              := NULL;           
         newrec_.plan_period_unit        := NULL;           
         Client_SYS.Clear_Attr(attr_);         
      END IF;   
      
      -- Move forward to next day after the period we just created (or skipped)
      start_date_ := end_date_ + 1;
    END LOOP;
END Create_New_Period_Units;


PROCEDURE Remove_Period_Units (
   plan_period_unit_ IN VARCHAR2,
   to_date_          IN DATE )
IS
   plan_period_unit_db_ VARCHAR2(20);
   remrec_              plan_period_unit_def_tab%ROWTYPE;
   
   CURSOR get_period IS
      SELECT *
      FROM plan_period_unit_def_tab
      WHERE plan_period_unit = plan_period_unit_db_
      AND   end_date <= TRUNC(to_date_)
      FOR UPDATE;
BEGIN
   plan_period_unit_db_ := Plan_Period_Unit_API.Encode(plan_period_unit_);
   FOR rec_ IN get_period LOOP
      remrec_.plan_period_unit_def_no := rec_.plan_period_unit_def_no;
      Remove___(remrec_);
   END LOOP;
END Remove_Period_Units;


@UncheckedAccess
FUNCTION Get_Max_Cal (
   dummy_ IN NUMBER ) RETURN DATE
IS
   max_date_   DATE;
   temp_       NUMBER:=1;

BEGIN
   max_date_ := Work_Time_Calendar_Desc_API.Max_End_Cal( temp_);
   RETURN max_date_ ;
END Get_Max_Cal;


@UncheckedAccess
FUNCTION Get_Max_End (
   temp_ IN NUMBER ) RETURN DATE
IS
   end_max_   DATE;
   begin_max_ DATE;
      
   CURSOR get_max IS
      SELECT max(end_date),max(begin_date)
      FROM PLAN_PERIOD_UNIT_DEF_TAB
      WHERE plan_period_unit = 2 ;
BEGIN
   OPEN get_max;
   FETCH get_max INTO end_max_,begin_max_;
   IF (get_max%NOTFOUND) THEN
      end_max_  := NULL;
      begin_max_:= NULL; 
   END IF;
   CLOSE get_max;
   
   IF(SUBSTR(TO_CHAR(begin_max_,'MMDDYY'),5) < SUBSTR(TO_CHAR(end_max_,'MMDDYY'),5))THEN
      end_max_:= Work_Time_Counter_API.Get_Next_Date(begin_max_,end_max_);
   ELSE 
      end_max_:= end_max_+365;
   END IF;
     
   end_max_:= Work_Time_Counter_API.Get_Begin_Date(end_max_); 
   RETURN end_max_;
END Get_Max_End;


@UncheckedAccess
FUNCTION Get_Max_End_Date (
   plan_period_unit_    IN VARCHAR2,
   remove_period_unit_  IN VARCHAR2 DEFAULT 'FALSE') RETURN DATE
IS
   end_max_   DATE;
   begin_max_ DATE;
      
   CURSOR get_max IS
      SELECT max(end_date),max(begin_date)
      FROM PLAN_PERIOD_UNIT_DEF_TAB
      WHERE plan_period_unit = plan_period_unit_ ;
BEGIN
   OPEN get_max;
   FETCH get_max INTO end_max_,begin_max_;
   IF (get_max%NOTFOUND) THEN
      end_max_  := NULL;
      begin_max_:= NULL; 
   END IF;
   CLOSE get_max;
   
   IF (remove_period_unit_ = Fnd_Boolean_API.DB_FALSE) THEN
      IF(SUBSTR(TO_CHAR(begin_max_,'MMDDYY'),5) < SUBSTR(TO_CHAR(end_max_,'MMDDYY'),5))THEN
         end_max_:= Work_Time_Counter_API.Get_Next_Date(begin_max_,end_max_);
      ELSE 
         end_max_:= end_max_+365;
      END IF;
   ELSE
      end_max_ := sysdate - 365;
   END IF;
   
   end_max_:= Work_Time_Counter_API.Get_Begin_Date(end_max_); 
   RETURN end_max_;
END Get_Max_End_Date;
