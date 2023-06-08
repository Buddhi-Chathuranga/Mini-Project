-----------------------------------------------------------------------------
--
--  Logical unit: PeriodTemplateDetail
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171220  MAJOSE   STRMF-16652, Improved performance of Calc_Length_In_Workdays__ by sending in more parameters
--  170809  MAJOSE   STRMF-13746, minor performance work and beautfied code here and there.
--  110920  MalLlk   EASTTWO-14017, Changed the error message text from Contract to Site in Get_Period().
--  110818  RoJalk   Added the method Check_Valid_Period_Exist to check for a record with the
--  110818           contract, template_id, period_begin_counter, period_end_counter combination.
--  110718  NiBalk   Added User Allowed Site filter to PERIOD_TEMPLATE_DETAIL. 
--  100429  Ajpelk   Merge rose method documentation
--  091005  ChFolk   Removed unused cursor get_prev_period_end_counter from Unpack_Check_Insert___ and
--  091005           Unpack_Check_Update___. Removed unused variables.
--  ------------------------------ 14.0.0 -----------------------------------
--  081016  SudJlk   Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  060714  ChBalk   Removed usage of public cursor get_prev_period_end_counter.
--                   Instead, used Get_Period_End_Counter public method. 
--  ------------------------ 13.4.0 -----------------------------------------
--  060228  Samnlk   Modified PROCEDURE New,make a call to the procedure New__, insted of Insert___. 
--  060125  JaJalk   Added Assert safe annotation.
--  060117  SeNslk   Modified the PROCEDURE Insert___ according to the template.
--  050919  NaLrlk   Removed unused variables.
--  050210  SaJjlk   Moved the LU from MFGSTD to MPCCOM.
--  --------------------------- 13.3.0 --------------------------------------
--  040226  RASELK   Unicode:removed substrb & replaced with substr where necessary.
--  010613  BEHA     Bug 15677, Call to General_SYS.Init_Method.
--  010412  ERHO     Bug 21337: Added NOCOPY to IN OUT and Out arguments.
--  000525  MAKU     Fix in Create_Template1_Details for error deleting default
--                   period template 1.
--  000306  BEHA     Performance Fixes on Modify_First_Period,Modify__, and New.
--                   Note for Modify_First_Period still kept the call to UnpackCheckUpdate
--                   since there validation neccessary for other non-updated record.
--  991125  SOPR     IID 2113 - Made begin_counter and end_counter as public attributes.
--  991018  KEVS     Call 23785 - Removed the colon directly after the quote in
--                   error message (TEMPID1DETMODERR).
--  990803  KEVS     Yoshimura performance tuning.
--  990617  KEVS     Made Template change in Get_Object_By_Id___.
--  990604  BEHA     Remove commas from NOPREVPERIOD and PERIODXCDSCAL.
--  990602  MAKU     Al Call Id 19640 - Replaced get_client_value with get_db_value
--                   in Calc_Length_In_Workdays.
--  990601  MAKU     Al Call Id 19297 - Replaced client with db value for plan_period_unit_
--                   in call to Calc_Length_In_Workdays.
--  990528  MUUC     #18605 Removed commas from messages NOPREVPERIOD and PERIODXCDSCAL to enable translations.
--  990506  ANTA     Changed calls from WorkTimeCounter.GetCounter to WorkTimeCalendar.GetWorkDayCounter.
--  990426  MAKU     Yoshimura template changes.
--  990319  SOPR     AL Bug 13572 : Replaced uses of ManufCalendarId with CalendarId
--                   in Period_Template.
--  990304  WIGR     AL Bug 11123 - Changed Check_Exist_Any_Period to return NUMBER
--  990227  SOPR     Period template clean up : Closed all cursors before raise an error
--                   in Unpack_Check_Insert___
--  990217  WIGR     AL Bug 9400 - Moved Check_Exist_Any_Period___ and
--                   Insert_Period_Zero___to public methods; renamed
--                   Create_Template_1_Details to Create_Template1_Details
--  990209  WIGR     Monty IID 820 - Rewrote cursor in Check_Delete__
--  990209  WIGR     Monty IID 820 - Rewrote Modify and Unpack_Check_Update__
--                   to allow recalculation of template details for Period Template 1
--  990128  WIGR     Monty IID 820 - added code to prevent deletion of periods if
--                   any other templates for that Site still exist
--  990128  ANTA     Renamed to mixed case naming standard.
--  990116  WIGR     Monty IID 820 - added procedure Create_Template_1_Details
--  990108  MULO     Replaced all usages of SYSDATE with Site_API.Get_Site_Date in:
--                   - Get_Period_Begin_Date, Get_Period_Dates and Get_Perod_Counters to get begin_date_,
--                   - Modify_First_Period to calculate the length_in_work_days based on
--                     number of workdays from current site's date to Sunday.
--  981215  WIGR     Monty IID 820 - added an exception in Calc_Length_In_Workdays
--                   to cover the case where the default manuf calendar has run out
--                   of work days; improved the exception handling
--  981208  WIGR     Monty IID 820 - undid changes to calls to Plan_Period_Unit_API
--                   after re-adding the Past client value
--  981201  WIGR     Monty IID 1035 - changes for new calendar methods and simplified
--                   exception handling
--  981112  WIGR     Monty IID 820 - changes to calls to Plan_Period_Unit_API
--                   after removing the Past client value
--  981109  WIGR     Monty IID 820 - fixed iniital paren on IID in view Designer
--                   bug after synching with model
--  981104  WIGR     Monty IID 820 - added public methods Check_Exist, New and Remove
--  981103  WIGR     Monty IID 820 - modified error message for no_previous_period
--                   exception to tell user that periods cannot be commited out of
--                   order (i.e., 1,2,4,3,5...); removed ; from end of DEFINEs
--  981020  WIGR     Monty IID 820 - created from dyperdef.apy and modified for
--                   new LU structur
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Data_Rec IS RECORD
   (template_id          PERIOD_TEMPLATE_DETAIL_TAB.template_id%TYPE,
    contract             PERIOD_TEMPLATE_DETAIL_TAB.contract%TYPE,
    period_no            PERIOD_TEMPLATE_DETAIL_TAB.period_no%TYPE,
    period_length        PERIOD_TEMPLATE_DETAIL_TAB.period_length%TYPE,
    length_in_work_days  PERIOD_TEMPLATE_DETAIL_TAB.length_in_work_days%TYPE,
    previous_length      PERIOD_TEMPLATE_DETAIL_TAB.previous_length%TYPE,
    period_begin_counter PERIOD_TEMPLATE_DETAIL_TAB.period_begin_counter%TYPE,
    period_end_counter   PERIOD_TEMPLATE_DETAIL_TAB.period_end_counter%TYPE,
    plan_period_unit     PERIOD_TEMPLATE_DETAIL_TAB.plan_period_unit%TYPE);

TYPE Data_Rec_Table IS TABLE OF Data_Rec INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE )
IS
   dummy_ NUMBER := 0;

   CURSOR get_number_of_templates IS
      SELECT count(*)
      FROM PERIOD_TEMPLATE_TAB
      WHERE contract = remrec_.contract
      AND   template_id > 1;
BEGIN
   -- details for the default template may not be deleted if other templates for
   -- the Site exist.
   IF (remrec_.template_id = 1) THEN
      OPEN get_number_of_templates;
      FETCH get_number_of_templates INTO dummy_;
      CLOSE get_number_of_templates;
      IF (dummy_ > 0) THEN
         Error_SYS.Record_General(lu_name_,
            'DELDETAILTEMP1: Periods for default Template (Template ID 1) for a Site may not be deleted while other templates exist for that Site.');
      END IF;
   END IF;
   -- only the last period no can be deleted.
   IF (Get_Max_Period_No(remrec_.contract, remrec_.template_id) !=
       remrec_.period_no) THEN
      Error_SYS.Record_General(lu_name_,
         'PERIODDELETE: Only the last period can be deleted.');
   END IF;

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT period_template_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(4000);
   calendar_id_            VARCHAR2(10);
   recalculation_date_     DATE;
   prev_end_counter_       NUMBER;
   begin_date_             DATE;
   dummy_day_              DATE;
   no_previous_period      EXCEPTION;
   begin_exceeds_calendar  EXCEPTION;
   end_exceeds_calendar    EXCEPTION;

BEGIN
   calendar_id_ := Period_Template_API.Get_Calendar_Id (newrec_.contract, newrec_.template_id);
   recalculation_date_ := TRUNC(Period_Template_API.Get_Recalculation_Date(newrec_.contract, newrec_.template_id));
   
   -- is the user allowed access to the site? if not, exit.
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);
   -- get the previous_length.
   newrec_.previous_length := Get_Prev_Length_Work (
                                 newrec_.contract,
                                 newrec_.template_id,
                                 newrec_.period_no);
   -- if this is the first period created, create a period zero.
   IF (newrec_.period_no = 1) THEN
      IF (Check_Exist_Any_Period(newrec_.contract, newrec_.template_id) = 0) THEN
         Insert_Period_Zero(newrec_.contract, newrec_.template_id);
      END IF;
   END IF;
   -- period units cannot decrease as period no increases
   IF (newrec_.plan_period_unit <
         Get_Plan_Period_Unit_Db(
            newrec_.contract,
            newrec_.template_id,
            newrec_.period_no - 1))
   THEN
      Error_SYS.Record_General(lu_name_,
         'WRONGUNITORDER: The period unit cannot be less than the period unit for the previous period.');
   END IF;
   -- calculate the length in workdays.
   Calc_Length_In_Workdays__ (
      newrec_.length_in_work_days,
      newrec_.contract,
      newrec_.template_id,
      newrec_.period_no,
      newrec_.plan_period_unit,
      newrec_.period_length,
      calendar_id_,
      recalculation_date_);
   -- set the begin and end counters; if the Recalculation_Date is not a workday
   -- then get the next workday to use as the period start.
   IF (newrec_.period_no = 1) THEN
      -- first period is a special case calculated off last Recalculation Date;
      -- if the Recalculation_Date is not a workday then get the next workday
      -- to use as the period start
      begin_date_ := recalculation_date_;
      
      IF Work_Time_Calendar_API.Is_Working_Day(calendar_id_, begin_date_) = 0 THEN
         begin_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, begin_date_);
      END IF;
      newrec_.period_begin_counter := Work_Time_Calendar_API.Get_Work_Day_Counter(
                                         calendar_id_,
                                         begin_date_);
      newrec_.period_end_counter := (newrec_.period_begin_counter +
                                     newrec_.length_in_work_days) - 1;
   ELSE
      -- for all periods other than period 1, begin counter will be the end
      -- counter of the last period; end counter will be the the (begin counter
      -- + length in work days) - 1
      prev_end_counter_ := Get_Period_End_Counter(newrec_.contract, newrec_.template_id, newrec_.period_no - 1);
      IF (prev_end_counter_ IS NOT NULL) THEN
         newrec_.period_begin_counter := prev_end_counter_ + 1;
         -- check whether we have gone beyond the end of the calendar for the site
         dummy_day_ := Work_Time_Calendar_API.Get_Work_Day(calendar_id_, newrec_.period_begin_counter);
         IF dummy_day_ IS NULL THEN
            RAISE begin_exceeds_calendar;
         END IF;
         newrec_.period_end_counter := (newrec_.period_begin_counter +
                                        newrec_.length_in_work_days) - 1;
         -- check whether we have gone beyond the end of the calendar for the site
         dummy_day_ := Work_Time_Calendar_API.Get_Work_Day(calendar_id_, newrec_.period_end_counter);
         IF dummy_day_ IS NULL THEN
            RAISE end_exceeds_calendar;
         END IF;
      ELSE
         RAISE no_previous_period;
      END IF;
   END IF;
   --
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
   WHEN no_previous_period THEN
      Error_SYS.Appl_General(lu_name_,
         'NOPREVPERIOD1: For Site :P1 Template ID :P2 beginning with Period No :P3 the periods have been entered in the Client out of sequence. Periods must be entered consecutively.',
         newrec_.contract, newrec_.template_id, newrec_.period_no);
   WHEN begin_exceeds_calendar THEN
      Error_SYS.Appl_General(lu_name_,
         'PERIODXCDSCAL1: For Site :P1 Template ID :P2 the beginning period counter for Period No :P3 falls outside the manufacturing calendar for the site.',
         newrec_.contract, newrec_.template_id, newrec_.period_no);
   WHEN end_exceeds_calendar THEN
      Error_SYS.Appl_General(lu_name_,
         'PERIODXCDSCAL2: For Site :P1 Template ID :P2 the ending period counter for Period No :P3 falls outside the manufacturing calendar for the site.',
         newrec_.contract, newrec_.template_id, newrec_.period_no);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     period_template_detail_tab%ROWTYPE,
   newrec_ IN OUT period_template_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(2000);
   begin_date_            DATE;
   calendar_id_           VARCHAR2(10);
   recalculation_date_    DATE;
   prev_end_counter_      NUMBER;
   mod_period_length_     BOOLEAN := FALSE;
   mod_plan_period_unit_  BOOLEAN := FALSE;
   no_previous_period     EXCEPTION;

BEGIN
   IF (indrec_.period_length) THEN
      mod_period_length_ := TRUE;
   END IF;
   
   -- is the user allowed access to the site for the record being updated?
   -- if not, exit
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   -- if the Template Id is 1, then make sure that the neither period_length
   -- nor plan_period_unit are being modified; raise an error if they are.
   IF (newrec_.template_id = 1 AND (mod_plan_period_unit_ OR mod_period_length_)) THEN
      ERROR_SYS.Appl_General(lu_name_,
         'NOMODTEMP1DET: Neither the period length nor the plan period unit for '||
            'the default template (Template ID 1) can be modified.');
   END IF;
   -- check that the period unit is not modified so that it is less than the period
   -- unit for the previous period.
   IF (newrec_.plan_period_unit < Get_Plan_Period_Unit_Db(
                                       newrec_.contract,
                                       newrec_.template_id,
                                       newrec_.period_no - 1))
   THEN
      Error_SYS.Record_General(lu_name_,
         'WRONGUNITORDER: The period unit cannot be less than the period unit for the previous period.');
   END IF;

   -- if this is Period Template 1, only certain attributes can be modified.
   IF (newrec_.template_id = 1 AND (mod_period_length_ OR mod_plan_period_unit_)) THEN
      ERROR_SYS.Record_General(lu_name_,
         'TEMPID1DETMODERR: Period length and plan period unit for a Site Default Template (Template ID 1) cannot be modified.');
   END IF;
   -- since either the number of periods or the period unit or both has changed
   -- for this record or an earlier period, recalculate the length in workdays.
   calendar_id_ := Period_Template_API.Get_Calendar_Id(newrec_.contract, newrec_.template_id);
   recalculation_date_ := TRUNC(Period_Template_API.Get_Recalculation_Date(newrec_.contract, newrec_.template_id));
   
   Calc_Length_In_Workdays__ (
      newrec_.length_in_work_days,
      newrec_.contract,
      newrec_.template_id,
      newrec_.period_no,
      newrec_.plan_period_unit,
      newrec_.period_length,
      calendar_id_,
      recalculation_date_);

   -- reset the begin and end counters;
   IF (newrec_.period_no = 1) THEN
      -- first period is a special case calculated off last recalculation date;
      -- if the recalculation date is not a workday then get the next workday
      -- to use as the period start
      begin_date_ := recalculation_date_;
      
      IF Work_Time_Calendar_API.Is_Working_Day(calendar_id_, begin_date_) = 0 THEN
         begin_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, begin_date_);
      END IF;

      newrec_.period_begin_counter := Work_Time_Calendar_API.Get_Work_Day_Counter(
                                         calendar_id_,
                                         begin_date_);

      newrec_.period_end_counter := (newrec_.period_begin_counter +
                                     newrec_.length_in_work_days) - 1;
   ELSE
      -- for all periods other than period 1, begin counter will be the end
      -- counter of the last period; end counter will be the (begin counter +
      -- length in work days) - 1
      prev_end_counter_ := Get_Period_End_Counter(newrec_.contract, newrec_.template_id, newrec_.period_no - 1);
      IF (prev_end_counter_ IS NOT NULL) THEN
         newrec_.period_begin_counter := prev_end_counter_ + 1;
         newrec_.period_end_counter := (newrec_.period_begin_counter + newrec_.length_in_work_days) - 1;
      ELSE
         RAISE no_previous_period;
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
   WHEN no_previous_period THEN
      Error_SYS.Appl_General(lu_name_,
         'NOPREVPERIOD1: For Site :P1 Template ID :P2 beginning with Period No :P3 the periods have been entered in the Client out of sequence. Periods must be entered consecutively.',
         newrec_.contract, newrec_.template_id, newrec_.period_no);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_            PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
   previous_length_   PERIOD_TEMPLATE_DETAIL_TAB.previous_length%TYPE;
   contract_          PERIOD_TEMPLATE_DETAIL_TAB.contract%TYPE;
   template_id_       PERIOD_TEMPLATE_DETAIL_TAB.template_id%TYPE;
   period_no_         PERIOD_TEMPLATE_DETAIL_TAB.period_no%TYPE;

   CURSOR   get_periods IS
   SELECT   period_no,
            length_in_work_days
   FROM     PERIOD_TEMPLATE_DETAIL_TAB
   WHERE    contract    = contract_
   AND      template_id = template_id_
   AND      period_no   > period_no_
   ORDER BY contract,
            template_id,
            period_no;

BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN 
      newrec_ := Lock_By_Id___(objid_, objversion_);
      -- Since only the period_unit or period_length can be modified,
      -- previous_length, length_in_workdays and the begin and end counters for
      -- all subsequent periods must be recalculated; the previous_length is
      -- calculated here and passed in, the other attributes are done in
      -- unpack_check_update___.
      contract_    := newrec_.contract;
      template_id_ := newrec_.template_id;
      period_no_   := newrec_.period_no;

      FOR per_rec IN get_periods LOOP
         previous_length_ := Get_Prev_Length_Work (
                                contract_,
                                template_id_,
                                per_rec.period_no);

         -- per MAJO, Lock___ is commented because it gave a record modified
         -- by another use error.
         -- Lock___(per_rec.objid, per_rec.objversion);
         UPDATE period_template_detail_tab
            SET   previous_length = previous_length_,
                  rowversion = SYSDATE
            WHERE contract = contract_
            AND   template_id = template_id_
            AND   period_no = per_rec.period_no;
      END LOOP;
   END IF;
END Modify__;


@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   loc_objid_            VARCHAR2(2000);
   loc_objversion_       VARCHAR2(2000);
   remrec_               PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
   remrec0_              PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO')THEN
      remrec_ := Lock_By_Id___(objid_, objversion_); 
   END IF;
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO')THEN
      IF remrec_.period_no = 1 THEN
         -- if we are removing period 1, need to also delete period 0 which
         -- is not visible in the client...
        remrec0_ := Lock_By_Keys___ (remrec_.contract,
                                     remrec_.template_id,
                                     remrec_.period_no - 1);
                                     
        Get_Id_Version_By_Keys___ (loc_objid_,
                                   loc_objversion_,
                                   remrec0_.contract,
                                   remrec0_.template_id,
                                   remrec0_.period_no);

        Check_Delete___(remrec0_);
        Delete___(loc_objid_, remrec0_);
      END IF;
   END IF;
END Remove__;

-- Calc_Length_In_Workdays
--   Calculates the length in work days depending on the PlanPeriodUnit.
--   If PlanPeriodUnit = DAY then PeriodLength is returned otherwise
--   the shop calender is used to calculate the length.
PROCEDURE Calc_Length_In_Workdays__ (
   length_in_work_days_ IN OUT NOCOPY NUMBER,
   contract_            IN     VARCHAR2,
   template_id_         IN     NUMBER,
   period_no_           IN     NUMBER,
   plan_period_unit_    IN     VARCHAR2,
   period_length_       IN     NUMBER,
   calendar_id_         IN     VARCHAR2,
   recalculation_date_  IN     DATE )
IS
   offset_                PLS_INTEGER;
   begin_date_            DATE;
   end_date_              DATE;
   prev_period_end_date_  DATE;
   work_day_              DATE;
   --
   extend_calendar_error_ EXCEPTION;

BEGIN
   -- determine the plan_period_unit
   IF (plan_period_unit_ = '1') THEN -- 'Day' Plan_Period_Unit_API
      -- plan_period_unit is Days
      length_in_work_days_ := period_length_;
   ELSE
      -- plan_period_unit is Weeks, Months, or Quarters
      prev_period_end_date_ := Get_Period_End_Date(
                                  contract_,
                                  template_id_,
                                  (period_no_ - 1),
                                  recalculation_date_);
                                  
      work_day_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, prev_period_end_date_);
      --
      IF work_day_ IS NULL THEN
         RAISE extend_calendar_error_;
      END IF;
      --
      Plan_Period_Unit_Def_API.Get_End_Date (
         begin_date_,
         end_date_,
         work_day_,
         plan_period_unit_,
         period_length_);
      --
      length_in_work_days_ := 0;
      offset_ := 1;
      WHILE ((prev_period_end_date_ + offset_) <= end_date_) LOOP
         IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, (prev_period_end_date_ + offset_ )) = 1) THEN
            length_in_work_days_ := length_in_work_days_ + 1;
         END IF;
         offset_ := offset_ + 1;
      END LOOP;
   END IF;
EXCEPTION
   WHEN extend_calendar_error_ THEN
      ERROR_SYS.Appl_General(lu_name_,
         'PERTEMDETEXTCAL: The default Manufacturing Calendar :P1 for Site :P2 needs to be extended. There are not enough work days to cover the Period Template being defined.',
         calendar_id_, contract_);
END Calc_Length_In_Workdays__;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist_Any_Period
--   Returns TRUE if any period exist for the specified site
@UncheckedAccess
FUNCTION Check_Exist_Any_Period (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ VARCHAR2(1);

   CURSOR check_period IS
   SELECT 'x'
   FROM PERIOD_TEMPLATE_DETAIL_TAB
   WHERE contract    = contract_
   AND   template_id = template_id_;

BEGIN
   OPEN check_period;
   FETCH check_period INTO dummy_;
   IF (check_period%FOUND) THEN
      CLOSE check_period;
      RETURN 1;
   ELSE
      CLOSE check_period;
      RETURN 0;
   END IF;
END Check_Exist_Any_Period;


-- Create_Template1_Details
--   Creates detail records for period template.
PROCEDURE Create_Template1_Details (
   contract_   IN VARCHAR2,
   start_date_ IN DATE )
IS
   CURSOR get_max_end_counter IS
      SELECT MAX(period_end_counter)
      FROM PERIOD_TEMPLATE_DETAIL_TAB
      WHERE contract    = contract_
      AND   template_id = 1;

   manuf_calendar_id_    VARCHAR2(10);
   period_no_            NUMBER := 1;
   begin_date_           DATE;
   temp_start_date_      DATE;
   dummy_day_            DATE;
   previous_length_      NUMBER;
   prev_end_counter_     NUMBER;
   period_begin_counter_ NUMBER;
   period_end_counter_   NUMBER;
   no_previous_period    EXCEPTION;

BEGIN
   temp_start_date_   := start_date_;
   manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id(contract_, 1);
   -- starting with start_date_, create a detail record for each work day for
   -- the next two years into the future or until the end of the manuf calendar,
   -- whichever comes first.
   WHILE (temp_start_date_ <= ADD_MONTHS(start_date_, 24)) LOOP
      -- calculate the previous length.
      previous_length_ := Period_Template_Detail_API.Get_Prev_Length_Work(contract_, 1, period_no_);
      -- calculate the begin and end counters.
      IF (period_no_ = 1) THEN
         -- first period is a special case calculated off passed in start_date_;
         -- if the start_date_ not a workday then get the next workday to use
         -- as the period start.
         begin_date_ := temp_start_date_;
         IF Work_Time_Calendar_API.Is_Working_Day(manuf_calendar_id_, begin_date_) = 0 THEN
            begin_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(
                              manuf_calendar_id_,
                              begin_date_);
         END IF;
         dummy_day_ := begin_date_;
         period_begin_counter_ := Work_Time_Calendar_API.Get_Work_Day_Counter(
                                     manuf_calendar_id_,
                                     begin_date_);
         -- since all the plan period unit is day and the period length is 1,
         -- the period_begin_counter_ and period_end_counter_ are the same.
         period_end_counter_ := period_begin_counter_;

         -- if this is the first period created, create a period zero.
         IF (Period_Template_Detail_API.Check_Exist_Any_Period (contract_, 1) = 0) THEN
            Period_Template_Detail_API.Insert_Period_Zero(contract_, 1);
         END IF;

      ELSE
         -- for all periods other than period 1, begin counter will be the end
         -- counter of the last period; end counter will be the ( begin counter
         -- + length in work days ) - 1.
         OPEN get_max_end_counter;
         FETCH get_max_end_counter INTO prev_end_counter_;
         IF (get_max_end_counter%FOUND) THEN
            period_begin_counter_ := prev_end_counter_ + 1;
            -- check whether we have gone beyond the end of the calendar for the site.
            dummy_day_ := Work_Time_Calendar_API.Get_Work_Day(manuf_calendar_id_, period_begin_counter_);
            IF dummy_day_ IS NULL THEN
               exit;
            END IF;
            period_end_counter_ := period_begin_counter_;
            CLOSE get_max_end_counter;
         ELSE
            CLOSE get_max_end_counter;
            RAISE no_previous_period;
         END IF;
      END IF;
      -- insert a new period.
      IF (dummy_day_ IS NOT NULL) THEN
         Period_Template_Detail_API.New(
            contract_,
            1,
            period_no_,
            1,
            1,
            previous_length_,
            period_begin_counter_,
            period_end_counter_,
            Plan_Period_Unit_API.Decode('1'));
      END IF;
      -- increment the period_no_.
      period_no_ := period_no_ + 1;
      -- set start_date_ to next work day.
      temp_start_date_ := Work_Time_Calendar_API.Get_Next_Work_Day (manuf_calendar_id_, temp_start_date_ );
   END LOOP;
EXCEPTION
   WHEN no_previous_period THEN
      Error_SYS.Appl_General(lu_name_,
         'NOPREVPERIOD2: For Site :P1 Template ID 1 beginning with Period No :P2 the periods have been entered in the Client out of sequence. Periods must be entered consecutively.',
         contract_, period_no_);
END Create_Template1_Details;


-- Get_Period
--   Try to find a period between ReferenceDate and CurrentDate
PROCEDURE Get_Period (
   period_exists_  OUT NOCOPY    NUMBER,
   period_no_      IN OUT NOCOPY NUMBER,
   current_length_ IN OUT NOCOPY NUMBER,
   contract_       IN     VARCHAR2,
   template_id_    IN     NUMBER,
   reference_date_ IN     DATE,
   current_date_   IN     DATE )
IS
   begin_date_      DATE;
   end_date_        DATE;
   begin_counter_   NUMBER;
   end_counter_     NUMBER;
   no_period        EXCEPTION;
   --
BEGIN

   period_no_:=0;
   period_exists_ := 1;
   IF (reference_date_ < current_date_) THEN
      LOOP
         Get_Period_Dates (
            period_exists_,
            current_length_,
            begin_date_,
            end_date_,
            begin_counter_,
            end_counter_,
            contract_,
            template_id_,
            period_no_,
            reference_date_ );
         EXIT WHEN current_date_ BETWEEN begin_date_ and end_date_;
         EXIT WHEN period_no_ > 1000;
         period_no_:= period_no_ +1;
      END LOOP;
   END IF;

   IF (period_no_ > 1000) THEN
      -- assume that if we did't find any periods in 1000 iterations, there aren't
      -- any periods to find.
      RAISE no_period;
   END IF;
EXCEPTION
   WHEN no_period THEN
      -- WSG: the set of period_exists_ is unnecessary as we are raising...
      period_exists_ := 0;
      Error_Sys.Record_General(lu_name_,
         'NOPERIODDEF: Period definition does not exist for Site/Date = :P1/:P2.',
         contract_, TO_CHAR(current_date_, 'YYYY-MM-DD'));
   WHEN OTHERS THEN
      IF Error_SYS.Is_Foundation_Error(sqlcode) THEN
         RAISE;
      END IF;
      Error_SYS.Record_General(lu_name_,
         'GETPERGENERR: Oracle error :P1 occurred in PERIOD_TEMPLATE_DETAIL_API.Get_Period while processing Site :P2 Template ID :P3.',
         sqlerrm, contract_, template_id_);
END Get_Period;


-- Get_Period_Begin_Date
--   Get the beginning date of the period.
@UncheckedAccess
FUNCTION Get_Period_Begin_Date (
   contract_            IN VARCHAR2,
   template_id_         IN NUMBER,
   period_no_           IN NUMBER,
   reference_date_      IN DATE,
   length_in_work_days_ IN NUMBER ) RETURN DATE
IS
   begin_date_        DATE;
   end_date_          DATE;
   begin_counter_     NUMBER;
   manuf_calendar_id_ VARCHAR2(10);
   site_date_         DATE;

BEGIN
   site_date_ := Site_API.Get_Site_Date(contract_);
   manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id(contract_, template_id_);
   end_date_ := Get_Period_End_Date(
                   contract_,
                   template_id_,
                   period_no_,
                   reference_date_);
   begin_counter_ :=  Work_Time_Calendar_API.Get_Work_Day_Counter (manuf_calendar_id_, end_date_) - length_in_work_days_ + 1;
   begin_date_    := Work_Time_Calendar_API.Get_Work_Day (manuf_calendar_id_, begin_counter_);
   IF (begin_date_ < site_date_) THEN
      begin_date_ := site_date_;
   END IF;

   RETURN begin_date_;
END Get_Period_Begin_Date;


-- Get_Period_Dates
--   Gets the start and end dates for the period and
--   the coresponding counter values from shop calender.
PROCEDURE Get_Period_Dates (
   period_exists_  OUT NOCOPY    NUMBER,
   current_length_ IN OUT NOCOPY NUMBER,
   begin_date_     IN OUT NOCOPY DATE,
   end_date_       IN OUT NOCOPY DATE,
   begin_counter_  IN OUT NOCOPY NUMBER,
   end_counter_    IN OUT NOCOPY NUMBER,
   contract_       IN     VARCHAR2,
   template_id_    IN     NUMBER,
   period_no_      IN     NUMBER,
   reference_date_ IN     DATE )
IS
   manuf_calendar_id_   VARCHAR2(10);
   found_               BOOLEAN := FALSE;

   no_period            EXCEPTION;

   CURSOR get_period_def IS
   SELECT   period_no,
            length_in_work_days
   FROM     PERIOD_TEMPLATE_DETAIL_TAB
   WHERE    contract    = contract_
   AND      template_id = template_id_
   ORDER BY contract,
            period_no;

BEGIN
   period_exists_ := 1;
   begin_counter_ := 0;
   end_counter_   := 0;
   manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id (
                            contract_,
                            template_id_);
   IF (reference_date_ IS NULL) THEN
      begin_date_        := TRUNC(Site_API.Get_Site_Date(contract_));
      begin_date_        := Work_Time_Calendar_API.Get_Closest_Work_Day (
                               manuf_calendar_id_,
                               begin_date_);

   ELSE
      begin_date_ := TRUNC(reference_date_);
   END IF;
   --
   begin_counter_ := Work_Time_Calendar_API.Get_Work_Day_Counter (
                        manuf_calendar_id_,
                        begin_date_);
   FOR period_rec IN get_period_def LOOP
      found_          := TRUE;
      end_counter_    := (begin_counter_ + period_rec.length_in_work_days) - 1;
      current_length_ := period_rec.length_in_work_days;
      EXIT WHEN period_rec.period_no = period_no_;
      begin_counter_  := end_counter_ + 1;
   END LOOP;
   --
   IF (NOT found_) THEN
      period_exists_ := 0;
      RAISE no_period;
   END IF;
   --
   begin_date_ := Work_Time_Calendar_API.Get_Work_Day (
                     manuf_calendar_id_,
                     begin_counter_);
   end_date_   := Work_Time_Calendar_API.Get_Work_Day (
                     manuf_calendar_id_,
                     end_counter_);
EXCEPTION
    WHEN no_period THEN
       NULL;
    WHEN OTHERS THEN
       IF Error_SYS.Is_Foundation_Error(sqlcode) THEN
          RAISE;
       END IF;
       Error_SYS.Record_General(lu_name_,
          'GETPERDATGENERR: Oracle error :P1 occurred in PERIOD_TEMPLATE_DETAIL_API.Get_Period_Dates while processing Site :P2 Template ID :P3.',
          sqlerrm, contract_, template_id_);
END Get_Period_Dates;


-- Get_Period_End_Date
--   Returns the end date for the work period
@UncheckedAccess
FUNCTION Get_Period_End_Date (
   contract_       IN VARCHAR2,
   template_id_    IN NUMBER,
   period_no_      IN NUMBER,
   reference_date_ IN DATE ) RETURN DATE
IS
   begin_counter_       NUMBER;
   end_counter_         NUMBER;
   manuf_calendar_id_   VARCHAR2(10);

   CURSOR get_period_def IS
   SELECT period_no, length_in_work_days
   FROM     PERIOD_TEMPLATE_DETAIL_TAB
   WHERE    contract    = contract_
   AND      template_id = template_id_
   ORDER BY period_no;
BEGIN
   -- starting from the reference date (i.e., last recalculation date), get the
   -- counters for the periods.
   begin_counter_     := 0;
   end_counter_       := 0;
   manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id (contract_, template_id_);

   IF (reference_date_ IS NULL) THEN
      begin_counter_ := Work_Time_Calendar_API.Get_Work_Day_Counter (
                           manuf_calendar_id_,
                           Period_Template_API.Get_Recalculation_Date (
                              contract_,
                              template_id_));
   ELSE
      begin_counter_ := Work_Time_Calendar_API.Get_Work_Day_Counter(manuf_calendar_id_, reference_date_);
   END IF;

   FOR period_rec IN get_period_def LOOP
      end_counter_ := (begin_counter_ + period_rec.length_in_work_days) - 1;
      EXIT WHEN period_rec.period_no = period_no_;
      begin_counter_ := end_counter_ + 1;
   END LOOP;

   RETURN Work_Time_Calendar_API.Get_Work_Day(manuf_calendar_id_, end_counter_);
END Get_Period_End_Date;


-- Get_Max_Period
--   Gets the largest PeriodNo for the given site where
--   WorkCounter >= PrevLength + OffsetCounter.
@UncheckedAccess
FUNCTION Get_Max_Period (
   contract_       IN VARCHAR2,
   template_id_    IN NUMBER,
   work_counter_   IN NUMBER,
   offset_counter_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_m_period IS
   SELECT NVL(MAX(period_no),0)
   FROM  PERIOD_TEMPLATE_DETAIL_TAB
   WHERE contract      =  contract_
   AND   template_id   =  template_id_
   AND   work_counter_ >= previous_length + offset_counter_;

   period_no_ PERIOD_TEMPLATE_DETAIL_TAB.period_no%TYPE;
BEGIN

   -- Parameters : work_counter_ - the counter value for the due date.
   --              offset_counter_ - normally the counter for sysdate.

   OPEN get_m_period;
   FETCH get_m_period INTO period_no_;
   CLOSE get_m_period;
   RETURN period_no_;
END Get_Max_Period;


-- Get_Max_Period_No
--   Gets the largest PeriodNo for the given site.
@UncheckedAccess
FUNCTION Get_Max_Period_No (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_max_period_no IS
   SELECT MAX(period_no)
   FROM  PERIOD_TEMPLATE_DETAIL_TAB
   WHERE contract    = contract_
   AND   template_id = template_id_;

   period_no_ PERIOD_TEMPLATE_DETAIL_TAB.period_no%TYPE;

BEGIN
   OPEN  get_max_period_no;
   FETCH get_max_period_no INTO period_no_;
   CLOSE get_max_period_no;
   RETURN NVL(period_no_,0);
END Get_Max_Period_No;


-- Get_Number_Of_Periods
--   Returns the number of periods for the given site.
FUNCTION Get_Number_Of_Periods (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR number_of_periods IS
   SELECT count(*)
   FROM PERIOD_TEMPLATE_DETAIL_TAB
   WHERE contract    = contract_
   AND   template_id = template_id_
   AND   period_no > 0;

   number_of_records_ NUMBER;
BEGIN
   OPEN number_of_periods;
   FETCH number_of_periods INTO number_of_records_;
   CLOSE number_of_periods;
   RETURN number_of_records_;
END Get_Number_Of_Periods;


-- Get_Period_Counters
--   Gets the begin and end counter values for the period from shop calender.
PROCEDURE Get_Period_Counters (
   current_length_ IN OUT NOCOPY NUMBER,
   begin_counter_  IN OUT NOCOPY NUMBER,
   end_counter_    IN OUT NOCOPY NUMBER,
   contract_       IN     VARCHAR2,
   template_id_    IN     NUMBER,
   period_no_      IN     NUMBER,
   reference_date_ IN     DATE )
IS
   begin_date_          DATE;
   manuf_calendar_id_   VARCHAR2(10);
   found_               BOOLEAN:=FALSE;

   no_period            EXCEPTION;

   CURSOR get_period_def IS
      SELECT   period_no,
               length_in_work_days
      FROM     PERIOD_TEMPLATE_DETAIL_TAB
      WHERE    contract    = contract_
      AND      template_id = template_id_
      ORDER BY contract,
               template_id,
               period_no;
BEGIN
   -- for an inserted record, this method will return the begin_period_counter
   -- and end_period_counter for that record
   begin_counter_     := 0;
   end_counter_       := 0;
   manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id (
                            contract_,
                            template_id_);

   IF (reference_date_ IS NULL) THEN
      begin_date_:= TRUNC(Site_API.Get_Site_Date(contract_));
      begin_date_ := Work_Time_Calendar_API.Get_Closest_Work_Day(manuf_calendar_id_, begin_date_);
   ELSE
      begin_date_:=trunc(reference_date_);
   END IF;
   begin_counter_ := Work_Time_Calendar_API.Get_Work_Day_Counter (
                        manuf_calendar_id_,
                        begin_date_);
   FOR period_rec IN get_period_def LOOP
      found_          := TRUE;
      end_counter_    := (begin_counter_ + period_rec.length_in_work_days) - 1;
      current_length_ := period_rec.length_in_work_days;
      EXIT WHEN period_rec.period_no = period_no_;
      begin_counter_  := end_counter_ + 1;
   END LOOP;

   IF (NOT found_) THEN
      RAISE no_period;
   END IF;
EXCEPTION
   WHEN no_period THEN
      Error_SYS.Record_General(lu_name_, 'NOPERIOD: No period was found.');
END Get_Period_Counters;


-- Get_Prev_Length_Work
--   Gets the total length in work days for an instance.
FUNCTION Get_Prev_Length_Work (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER,
   period_no_   IN NUMBER ) RETURN NUMBER
IS
   prev_length_  PERIOD_TEMPLATE_DETAIL_TAB.previous_length%TYPE;

   CURSOR length IS
   SELECT NVL(SUM(NVL(length_in_work_days,0)),0)
   FROM   PERIOD_TEMPLATE_DETAIL_TAB
   WHERE  contract    = contract_
   AND    template_id = template_id_
   AND    period_no   < period_no_;

BEGIN
   OPEN length;
   FETCH length INTO prev_length_;
   CLOSE length;
   RETURN prev_length_;
END Get_Prev_Length_Work;


-- Insert_Period_Zero
--   Inserts a default period for the specified site.
--   Period=0, PeriodLength=0, LengthInWorkDays=0, PrevLength=-1,
PROCEDURE Insert_Period_Zero (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER )
IS
   attr_         VARCHAR2(200);
   objid_        VARCHAR2(200);
   objversion_   VARCHAR2(2000);
   newrec_       PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
BEGIN
   newrec_.contract             := contract_;
   newrec_.template_id          := template_id_;
   newrec_.period_no            := 0;
   newrec_.period_length        := 0;
   newrec_.length_in_work_days  := 0;
   newrec_.previous_length      := -1;
   newrec_.plan_period_unit     := '0'; -- 'Past' Plan_Period_Unit_API
   newrec_.period_begin_counter := -1;
   newrec_.period_end_counter   := -1;

   Insert___(objid_, objversion_, newrec_, attr_);
END Insert_Period_Zero;


-- Instance_Exist
--   Returns 1 if the period exist otherwise 0
@UncheckedAccess
FUNCTION Instance_Exist (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER,
   period_no_   IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (NOT Check_Exist___(contract_, template_id_, period_no_)) THEN
      RETURN 0;
   ELSE
      RETURN 1;
   END IF;
END Instance_Exist;


-- Modify
--   Public Modify method.
PROCEDURE Modify (
   contract_              IN VARCHAR2,
   template_id_           IN NUMBER,
   period_no_             IN NUMBER,
   period_length_         IN NUMBER,
   length_in_work_days_   IN NUMBER,
   previous_length_       IN NUMBER,
   period_begin_counter_  IN NUMBER,
   period_end_counter_    IN NUMBER,
   plan_period_unit_      IN VARCHAR2 )
IS
   attr_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   newrec_       PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
   mod_period_1_ EXCEPTION;

   CURSOR get_object IS
      SELECT *
      FROM  PERIOD_TEMPLATE_DETAIL_TAB
      WHERE contract     = contract_
      AND   template_id  = template_id_
      AND   period_no    = period_no_
      FOR UPDATE;

BEGIN
   objid_ := NULL;
   FOR oldrec_ IN get_object LOOP
      attr_ := NULL;
      newrec_ := oldrec_;
      
      IF (period_length_ IS NOT NULL) THEN
         -- can't update period_length for Template Id 1
         IF (template_id_ = 1) THEN
            RAISE mod_period_1_;
         ELSE
            newrec_.period_length := period_length_;
         END IF;
      END IF;
      IF (length_in_work_days_ IS NOT NULL) THEN
         newrec_.length_in_work_days := length_in_work_days_;
      END IF;
      IF (previous_length_ IS NOT NULL) THEN
         newrec_.previous_length := previous_length_;
      END IF;
      IF (period_begin_counter_ IS NOT NULL) THEN
         newrec_.period_begin_counter := period_begin_counter_;
      END IF;
      IF (period_end_counter_ IS NOT NULL) THEN
         newrec_.period_end_counter := period_end_counter_;
      END IF;
      IF (plan_period_unit_ IS NOT NULL) THEN
         -- can't update plan_period_unit for Template Id 1
         IF (template_id_ = 1) THEN
            RAISE mod_period_1_;
         ELSE
            newrec_.plan_period_unit := plan_period_unit_;
         END IF;
      END IF;
      Update___(objid_, oldrec_, newrec_, objversion_, attr_, TRUE);
   END LOOP;
EXCEPTION
   WHEN mod_period_1_ THEN
      ERROR_SYS.Record_General(lu_name_,
         'MODUPDTEMPID1: Period length and plan period unit for a Site default Template (Template ID 1) cannot be modified.');
   WHEN others THEN
      IF Error_SYS.Is_Foundation_Error(sqlcode) THEN
         RAISE;
      END IF;
      Error_Sys.Appl_General(lu_name_,
         'MODGENERR: Oracle error :P1 occurred in PERIOD_TEMPLATE_DETAIL_API.Modify while processing Site :P2 Template ID :P3.',
         sqlerrm, contract_, template_id_);
END Modify;


-- Modify_First_Period
--   Modifies LengthInWorkDays and/or PrevLength
PROCEDURE Modify_First_Period (
   contract_           IN VARCHAR2,
   template_id_        IN NUMBER,
   work_days_per_week_ IN NUMBER )
IS
   stmt_              VARCHAR2(100);
   length_            NUMBER;
   previous_length_   NUMBER;
   i_                 NUMBER;
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   attr_              VARCHAR2(2000);
   oldrec_            PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
   newrec_            PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
   manuf_calendar_id_ VARCHAR2(10);
   site_date_         DATE;
   indrec_            Indicator_Rec;

   CURSOR get_periods IS
   SELECT contract, template_id, period_no
   FROM     PERIOD_TEMPLATE_DETAIL_TAB
   WHERE    contract LIKE contract_
   AND      template_id = template_id_
   AND      period_no   > 0
   ORDER BY contract, template_id, period_no;
BEGIN
   manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id(contract_, template_id_);

   -- regardless of what Nls setting the user has, set to American to standardize
   -- the calculations
   stmt_ := 'ALTER SESSION SET Nls_Date_Language=American';
      @ApproveDynamicStatement(2006-01-25,JaJalk)
      EXECUTE IMMEDIATE stmt_;

   FOR c_rec IN get_periods LOOP
      site_date_ := Site_API.Get_Site_Date(contract_);
      IF c_rec.period_no = 1 THEN
         i_ := 0;
         length_ := 0;
         LOOP
            IF (work_days_per_week_ = 7) THEN -- 7 X 8 0r 7 X 24 shop

               -- calculate the length_in_work_days for the first period based on
               -- number of workdays from SYSDATE to Sunday, including Saturday and Sunday.
               IF (Work_Time_Calendar_API.Is_Working_Day (manuf_calendar_id_, TRUNC(site_date_) + i_) = 1) THEN
                  length_ := length_ + 1;

                  -- the FMDAY mask (fixed mode day) yields the day char string
                  -- with no preceeding or trailing spaces.
                  IF (TO_CHAR(TRUNC(site_date_) + i_, 'FMDAY') IN ('SUNDAY')) THEN

                     Client_SYS.Clear_Attr(attr_);
                     Client_SYS.Add_To_Attr('LENGTH_IN_WORK_DAYS', length_, attr_);
                     Client_SYS.Add_To_Attr('PREVIOUS_LENGTH', 0, attr_);

                     oldrec_ := Lock_By_Keys___ (
                                   c_rec.contract,
                                   c_rec.template_id,
                                   c_rec.period_no);
                     newrec_ := oldrec_;
                     Unpack___(newrec_, indrec_, attr_);
                     Check_Update___(oldrec_, newrec_, indrec_, attr_);
                     Update___(objid_, oldrec_, newrec_, objversion_, attr_, TRUE);

                     EXIT WHEN (TO_CHAR(TRUNC(site_date_) + i_, 'FMDAY') IN ('SUNDAY'));
                  END IF;
               END IF;
               i_ := i_ + 1;
            ELSE -- 5 X 8 or 5 X 24 shop

            -- calculate the length_in_work_days for the first period based on
            -- number of workdays from SYSDATE to Sunday, excluding Saturday and Sunday.
               IF (Work_Time_Calendar_API.Is_Working_Day(manuf_calendar_id_, TRUNC(site_date_) + i_) = 1) THEN
                  length_ := length_ + 1;
               ELSIF ((TO_CHAR(TRUNC(site_date_) + i_, 'FMDAY') IN ('SUNDAY')) AND
                      length_ > 0) THEN

                  Client_SYS.Clear_Attr(attr_);
                  Client_SYS.Add_To_Attr('LENGTH_IN_WORK_DAYS', length_, attr_);

                  oldrec_ := Lock_By_Keys___ (
                                c_rec.contract,
                                c_rec.template_id,
                                c_rec.period_no);
                  newrec_ := oldrec_;
                  Unpack___(newrec_, indrec_, attr_);
                  Check_Update___(oldrec_, newrec_, indrec_, attr_);
                  Update___(objid_, oldrec_, newrec_, objversion_, attr_, TRUE);

                  EXIT WHEN ((TO_CHAR(TRUNC(site_date_) + i_, 'FMDAY') IN ('SUNDAY')) AND
                             length_ > 0);
               END IF;
               i_ := i_+1;
            END IF;
         END LOOP;
      ELSE
         previous_length_ := Get_Prev_Length_Work (
                                c_rec.contract,
                                c_rec.template_id,
                                c_rec.period_no);
         UPDATE period_template_detail_tab
            SET previous_length = previous_length_,
                rowversion = SYSDATE
            WHERE contract = c_rec.contract
            AND   template_id = c_rec.template_id
            AND   period_no = c_rec.period_no;
      END IF;
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      IF Error_SYS.Is_Foundation_Error(sqlcode) THEN
         RAISE;
      END IF;
      Error_Sys.Appl_General(lu_name_,
         'MODFIRPERGENERR: Oracle error :P1 occurred in PERIOD_TEMPLATE_DETAIL_API.Modify_First_Period while processing Site :P2 Template ID :P3.',
         sqlerrm, contract_, template_id_);
END Modify_First_Period;


-- Modify_Periods
--   Modifies LengthInWorkDays and PrevLength according to the shop calendar
PROCEDURE Modify_Periods (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER,
   work_day_    IN DATE )
IS
   length_in_work_days_  PERIOD_TEMPLATE_DETAIL_TAB.length_in_work_days%TYPE;
   period_length_        PERIOD_TEMPLATE_DETAIL_TAB.period_length%TYPE;
   plan_period_unit_     PERIOD_TEMPLATE_DETAIL_TAB.plan_period_unit%TYPE;
   previous_length_      PERIOD_TEMPLATE_DETAIL_TAB.previous_length%TYPE;
   work_counter_         NUMBER;
   offset_               NUMBER;
   work_date_            DATE;
   begin_date_           DATE;
   end_date_             DATE;
   objid_                PERIOD_TEMPLATE_DETAIL.objid%TYPE;
   objversion_           VARCHAR2(2000);
   attr_                 VARCHAR2(2000);
   oldrec_               PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
   newrec_               PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
   manuf_calendar_id_    VARCHAR2(10);
   indrec_               Indicator_Rec;

   CURSOR get_periods IS
   SELECT   contract,
            template_id,
            period_no
   FROM     PERIOD_TEMPLATE_DETAIL_TAB
   WHERE    contract LIKE contract_
   AND      template_id = template_id_
   AND      period_no   > 0
   ORDER BY contract,
            template_id,
            period_no;

BEGIN
   manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id(contract_, template_id_);
   work_date_ := work_day_;
   work_counter_ := Work_Time_Calendar_API.Get_Work_Day_Counter(manuf_calendar_id_, work_date_);

   FOR c_rec IN get_periods LOOP
      -- What am I?
      plan_period_unit_ := Get_Plan_Period_Unit_Db (
                              c_rec.contract,
                              c_rec.template_id,
                              c_rec.period_no );
      period_length_ := Get_Period_Length (
                           c_rec.contract,
                           c_rec.template_id,
                           c_rec.period_no );
      -- Days ?
      IF (plan_period_unit_ = '1') THEN
         length_in_work_days_ := Get_Length_In_Work_Days (
                                    c_rec.contract,
                                    c_rec.template_id,
                                    c_rec.period_no ) ;

         work_counter_ := work_counter_ + length_in_work_days_;
         work_date_    := Work_Time_Calendar_API.Get_Work_Day(manuf_calendar_id_, work_counter_);

      ELSE -- Weeks, Months, Quarter

         Plan_Period_Unit_Def_API.Get_End_Date (
            begin_date_,
            end_date_,
            work_date_,
            plan_period_unit_,
            period_length_);

         -- Where am I?
         length_in_work_days_ := 0;
         offset_ := 0;
         WHILE ((work_date_ + offset_) <= end_date_) LOOP
            IF (Work_Time_Calendar_API.Is_Working_Day (manuf_calendar_id_, work_date_ + offset_) = 1) THEN
               length_in_work_days_ := length_in_work_days_ + 1;
            END IF;
            offset_ := offset_ + 1;
         END LOOP;
         work_counter_ := work_counter_ + length_in_work_days_;
         work_date_    := Work_Time_Calendar_API.Get_Work_Day (manuf_calendar_id_, work_counter_);

      END IF;
      previous_length_ := Get_Prev_Length_Work (
                             c_rec.contract,
                             c_rec.template_id,
                             c_rec.period_no );
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LENGTH_IN_WORK_DAYS', length_in_work_days_, attr_);
      Client_SYS.Add_To_Attr('PREV_LENGTH', previous_length_, attr_);
      oldrec_ := Lock_By_Keys___ (
                    c_rec.contract,
                    c_rec.template_id,
                    c_rec.period_no);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, objversion_, attr_, TRUE);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      IF Error_SYS.Is_Foundation_Error(sqlcode) THEN
         RAISE;
      END IF;
      Error_Sys.Appl_General(lu_name_,
         'MODPERGENERR: Oracle error :P1 occurred in PERIOD_TEMPLATE_DETAIL_API.Modify_Periods while processing Site :P2 Template ID :P3.',
         sqlerrm, contract_, template_id_);
END Modify_Periods;


-- New
--   Public New method.
PROCEDURE New (
   contract_             IN VARCHAR2,
   template_id_          IN NUMBER,
   period_no_            IN NUMBER,
   period_length_        IN NUMBER,
   length_in_work_days_  IN NUMBER,
   previous_length_      IN NUMBER,
   period_begin_counter_ IN NUMBER,
   period_end_counter_   IN NUMBER,
   plan_period_unit_     IN VARCHAR2 )
IS
   newrec_  period_template_detail_tab%ROWTYPE;
BEGIN
   newrec_.contract              := contract_;
   newrec_.template_id           := template_id_;
   newrec_.period_no             := period_no_;
   newrec_.period_length         := period_length_;
   newrec_.length_in_work_days   := length_in_work_days_;
   newrec_.previous_length       := previous_length_;
   newrec_.period_begin_counter  := period_begin_counter_;
   newrec_.period_end_counter    := period_end_counter_;
   newrec_.plan_period_unit      := Plan_Period_Unit_API.Encode(plan_period_unit_);
   
   New___(newrec_);
 END New;


-- Remove
--   Public Remove method.
PROCEDURE Remove (
   contract_     IN VARCHAR2,
   template_id_  IN NUMBER,
   period_no_    IN NUMBER )
IS
   lu_rec_       PERIOD_TEMPLATE_DETAIL_TAB%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(contract_, template_id_, period_no_);
   Remove___(lu_rec_);
   IF (period_no_ = 1) THEN
      -- for the first period_no, we need to clean up period zero as well as
      -- this is not shown in the view to be deleted...
      lu_rec_ := Get_Object_By_Keys___(contract_, template_id_, period_no_-1);
      Remove___(lu_rec_);
   END IF;
END Remove;


@UncheckedAccess
FUNCTION Check_Valid_Period_Exist (
   contract_             IN VARCHAR2,
   template_id_          IN NUMBER,
   period_begin_counter_ IN NUMBER,
   period_end_counter_   IN NUMBER ) RETURN BOOLEAN
IS
   dummy_   NUMBER;

   CURSOR check_period IS
      SELECT 1
        FROM PERIOD_TEMPLATE_DETAIL_TAB
       WHERE contract    = contract_
         AND template_id = template_id_
         AND period_no > 0
         AND period_begin_counter = period_begin_counter_
         AND period_end_counter   = period_end_counter_;
BEGIN
   OPEN check_period;
   FETCH check_period INTO dummy_;
   IF (check_period%FOUND) THEN
      CLOSE check_period;
      RETURN TRUE;
   END IF;
   CLOSE check_period;
   RETURN FALSE;
END Check_Valid_Period_Exist;



