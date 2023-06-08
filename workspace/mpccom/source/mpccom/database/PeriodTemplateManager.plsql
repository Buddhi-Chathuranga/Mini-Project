-----------------------------------------------------------------------------
--
--  Logical unit: PeriodTemplateManager
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  171220  MAJOSE   STRMF-16652, Modified call to Period_Template_Detail_API.Calc_Length_In_Workdays__
--  140505  ChJalk   PBSC-8615, Modified the method Copy_Template to call Period_Template_Detail_API.Remove only if the period_no is not equal to 0.
--  100429  Ajpelk   Merge rose method documentation
--  091022  KAYOLK   Added Transaction_Statement_Approved Tag for COMMIT statements.
---------------------------- 14.0.0 ------------------------------------------
--  081016  SudJlk   Bug 77768, Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  060714  ChBalk   Removed obsolete public cursor get_prev_period_end_counter implementation and its usage.
--                   Instead, used Period_Template_Detail_API.Get_Period_End_Counter public method. 
---------------------------- 13.4.0 -----------------------------------------
--  051109  UsRalk   Modified Copy_Template to insert the period zero also.
--  050628  UsRalk   Removed unused variable create_previous_period_ from Copy_Template.
--  050311  UsRalk   Added new public methods Get_Period_Data_From and Get_Begin_Period_No.
--  050210  SaJjlk   Moved the LU from MFGSTD to MPCCOM.
-----------------------------------------------------------------------------
--  010613  BEHA     Bug 15677, Call to General_SYS.Init_Method.
--  000302  ROAL     Hammerhead 2001 fix - Recalculate_Template now checks whether template
--                   exists for the contract by using Exist.
--  991220  MAKU     Hammerhead fix - Changed client to db value in call to
--                   Period_Template_Detail_API.Calc_Length_In_Workdays in
--                   Recalculate_Site_Templates.
--  990803  KEVS     Yoshimura performance tuning.
--  990606  MAKU     AL Call Id 19836 - Cliend/Db value fix in Recalculate_Template.
--  990604  BEHA     Removed commas from NOPREVPERIOD.
--  990603  MAKU     AL Call Id 19640 - Fix for db/client value in method
--                   Create_Periods.
--  990528  MUUC     #18606 Removed commas from message NOPREVPERIOD to enable translations
--  990506  ANTA     Changed calls from WorkTimeCounter.GetCounter to WorkTimeCalendar.GetWorkDayCounter.
--  990426  MAKU     Yoshimura template changes.
--  990319  SOPR     AL Bug 13572 - Modified Recalculate_Template, Recalculate_Site_Templates
--                   and Copy_Template : Using Calendar_Id in Period_Template.
--  990304  WIGR     AL Bug 11123 - Changed call to Check_Exist_Any_Period to
--                   return NUMBER
--  990218  WIGR     AL Bug 9400 - added code in Create_Periods to create a period
--                   zero if one does not exist
--  990210  WIGR     Monty IID 820 - added Delete_Periods procedure
--  990128  WIGR     Removed dbms_output debug messages
--  990128  ANTA     Renamed to mixed case naming standard.
--  990123  ANTA     Changed parameter from VARCHAR to VARCHAR2 to match model.
--  981201  WIGR     Monty IID 1035 - changes for new calendar methods
--  981111  WIGR     Monty IID 820 - added new param, target_recalculation_date_,
--                   to Copy_Template
--  981107  WIGR     Monty IID 820 - added public method Create_Periods
--  981104  WIGR     Monty IID 820 - changed name of LU to PeriodTemplateManager;
--                   added Copy_Template method
--  981020  WIGR     Monty IID 820 - create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy_Template
--   Copies template to another template.
PROCEDURE Copy_Template (
   source_contract_             IN VARCHAR2,
   source_template_id_          IN NUMBER,
   target_contract_             IN VARCHAR2,
   target_template_id_          IN NUMBER,
   target_template_desc_        IN VARCHAR2,
   target_recalculation_date_   IN DATE )
IS
   target_calendar_id_         VARCHAR2(10);
   --
   CURSOR get_details (contract_ VARCHAR, template_id_ NUMBER) IS
      SELECT *
      FROM PERIOD_TEMPLATE_DETAIL_TAB
      WHERE contract    = contract_
      AND   template_id = template_id_;
BEGIN
   target_calendar_id_ := Period_Template_API.Get_Calendar_Id (source_contract_,  source_template_id_);
   -- if there is a period template with the same keys as the target template
   -- already, and if that template is not in use, first delete the details for
   -- that template and then modify the recalculation_date for the existing
   -- template.
   IF (Period_Template_API.Check_Exist(target_contract_, target_template_id_) = 1) THEN
      -- usage check goes here...

      -- delete all the period details for the template
      FOR detail_rec IN get_details(target_contract_, target_template_id_) LOOP
         IF (detail_rec.period_no != 0) THEN 
            Period_Template_Detail_API.Remove(
               target_contract_,
               target_template_id_,
               detail_rec.period_no);
         END IF;
      END LOOP;
      -- modify the recalculation_date for existing target template header.
      Period_Template_API.Modify(
         contract_              => target_contract_,
         template_id_           => target_template_id_,
         template_description_  => TO_CHAR(NULL),
         recalculation_date_    => target_recalculation_date_,
         calendar_id_           => target_calendar_id_);
   ELSE
      -- no details to delete or header to modify, so insert the target
      --template header.
      Period_Template_API.New(
         target_contract_,
         target_template_id_,
         target_template_desc_,
         target_recalculation_date_,
         target_calendar_id_);
   END IF;
   -- in a loop, select the period template details from the source template
   -- and insert them into the target.
   FOR detail_rec IN get_details(source_contract_, source_template_id_) LOOP
      IF (detail_rec.period_no = 0) THEN
         Period_Template_Detail_API.Insert_Period_Zero(target_contract_, target_template_id_);
      ELSE
         Period_Template_Detail_API.New(
            target_contract_,
            target_template_id_,
            detail_rec.period_no,
            detail_rec.period_length,
            detail_rec.length_in_work_days,
            detail_rec.previous_length,
            detail_rec.period_begin_counter,
            detail_rec.period_end_counter,
            Plan_Period_Unit_API.Decode(detail_rec.plan_period_unit));
      END IF;
   END LOOP;
END Copy_Template;


-- Create_Periods
--   Creates template periods.
PROCEDURE Create_Periods (
   contract_           IN VARCHAR2,
   template_id_        IN NUMBER,
   plan_period_unit_   IN VARCHAR2,
   cur_max_period_no_  IN NUMBER,
   number_of_periods_  IN NUMBER,
   period_length_      IN NUMBER )
IS
   begin_date_                DATE;
   manuf_calendar_id_         VARCHAR2(10);
   recalculation_date_        PERIOD_TEMPLATE_TAB.recalculation_date%TYPE;
   new_length_in_work_days_   PERIOD_TEMPLATE_DETAIL_TAB.length_in_work_days%TYPE;
   new_period_no_             PERIOD_TEMPLATE_DETAIL_TAB.period_no%TYPE;
   new_previous_length_       PERIOD_TEMPLATE_DETAIL_TAB.previous_length%TYPE;
   new_period_begin_counter_  PERIOD_TEMPLATE_DETAIL_TAB.period_begin_counter%TYPE;
   new_period_end_counter_    PERIOD_TEMPLATE_DETAIL_TAB.period_end_counter%TYPE;
   prev_end_counter_          PERIOD_TEMPLATE_DETAIL_TAB.period_end_counter%TYPE;

   no_previous_period         EXCEPTION;

BEGIN
   -- does the user have access to the site? if not, raise and exit.
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   -- get the recalculation date of the template header.
   recalculation_date_ := TRUNC(Period_Template_API.Get_Recalculation_Date(contract_, template_id_));
   manuf_calendar_id_ := Site_API.Get_Manuf_Calendar_Id(contract_);
   -- if this is the first period created, create a period zero.
   IF (cur_max_period_no_ = 0) THEN
      IF (Period_Template_Detail_API.Check_Exist_Any_Period(contract_, template_id_) = 0) THEN
         Period_Template_Detail_API.Insert_Period_Zero(contract_, template_id_);
      END IF;
   END IF;
   -- ensure that period units are not decreasing as period no increases.
   IF (Plan_Period_Unit_API.Encode(plan_period_unit_) <
         Period_Template_Detail_API.Get_Plan_Period_Unit_Db(
                                        contract_,
                                        template_id_,
                                        cur_max_period_no_)) THEN
      Error_SYS.Record_General(lu_name_,
         'WRONGUNITORDER: The period unit cannot be less than the period unit for the previous period.');
   END IF;
   -- for number of periods to be created loop
   FOR i IN 1..number_of_periods_ LOOP
      new_period_no_ := cur_max_period_no_ + i;
      -- calculate the previous length.
      new_previous_length_ := Period_Template_Detail_API.Get_Prev_Length_Work (
                                 contract_,
                                 template_id_,
                                 new_period_no_);

      -- calculate the length in work days.
      Period_Template_Detail_API.Calc_Length_In_Workdays__ (
         new_length_in_work_days_,
         contract_,
         template_id_,
         new_period_no_,
         Plan_Period_Unit_API.Encode(plan_period_unit_),
         period_length_,
         manuf_calendar_id_,
         recalculation_date_);
      -- calculate the begin and end counters.
      IF (new_period_no_ = 0) THEN
         -- no need to modify the begin and end counters...
         NULL;
      ELSIF (new_period_no_ = 1) THEN
         -- first period is a special case calculated off passed in
         -- Recalculation Date; if the Recalculation_Date is not a workday
         -- then get the next workday to use as the period start.
         begin_date_ := recalculation_date_;
         IF Work_Time_Calendar_API.Is_Working_Day(manuf_calendar_id_, begin_date_) = 0 THEN
            begin_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(manuf_calendar_id_, begin_date_);
         END IF;
         new_period_begin_counter_ := Work_Time_Calendar_API.Get_Work_Day_Counter (manuf_calendar_id_, begin_date_);

         new_period_end_counter_ := new_period_begin_counter_ + new_length_in_work_days_ - 1;
      ELSE
         -- for all periods other than period 1, begin counter will be the end
         -- counter of the last period; end counter will be the ( begin counter
         -- + length in work days ) - 1.
         prev_end_counter_ := Period_Template_Detail_API.Get_Period_End_Counter(contract_, template_id_, new_period_no_ - 1);
         IF (prev_end_counter_ IS NOT NULL) THEN
            new_period_begin_counter_ := prev_end_counter_ + 1;
            new_period_end_counter_ := (new_period_begin_counter_
                                      + new_length_in_work_days_) - 1;
         ELSE
            RAISE no_previous_period;
         END IF;
      END IF;
      -- insert a new period.
      IF (new_period_no_ > 0) THEN
         Period_Template_Detail_API.New(
            contract_,
            template_id_,
            new_period_no_,
            period_length_,
            new_length_in_work_days_,
            new_previous_length_,
            new_period_begin_counter_,
            new_period_end_counter_,
            plan_period_unit_);

      END IF;
   END LOOP;
EXCEPTION
   WHEN no_previous_period THEN
      Error_SYS.Appl_General(lu_name_,
         'NOPREVPERIOD: For Site :P1 Template ID :P2 there are no periods prior to period :P3.',
         contract_, template_id_, new_period_no_);
END Create_Periods;


-- Delete_Periods
--   Recalculate a specific template.
PROCEDURE Delete_Periods (
   contract_               IN VARCHAR2,
   template_id_            IN NUMBER,
   delete_from_period_no_  IN NUMBER,
   delete_to_period_no_    IN NUMBER )
IS
   dummy_ NUMBER := 0;

   CURSOR get_number_of_templates IS
      SELECT count(*)
      FROM PERIOD_TEMPLATE_TAB
      WHERE contract = contract_
      AND   template_id > 1;
BEGIN
   -- does the user have access to the site? if not, raise and exit
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   -- details for the default template may not be deleted if other templates for
   -- the Site exist.
   IF template_id_ = 1 THEN
      OPEN get_number_of_templates;
      FETCH get_number_of_templates INTO dummy_;
      IF (dummy_ > 0) THEN
         CLOSE get_number_of_templates;
         ERROR_SYS.Record_General(
            lu_name_,
            'DELDETAILTEMP1: Periods for default Template (Template Id 1) for a Site may not be deleted while other templates exist for that Site.');
      END IF;
      CLOSE get_number_of_templates;
   END IF;
   -- for number of periods to be deleted loop in reverse
   FOR current_period_no_ IN REVERSE delete_to_period_no_..delete_from_period_no_ LOOP
      IF current_period_no_ >= 1 THEN
         -- we call delete for any period no >= 1; the Remove for period no 1 will remove period 0...
         Period_Template_Detail_API.Remove(contract_, template_id_, current_period_no_);
      END IF;
   END LOOP;
END Delete_Periods;


-- Recalculate_Site_Templates
--   Recalculate all templates for the given site.
PROCEDURE Recalculate_Site_Templates (
   contract_           IN VARCHAR2,
   recalculation_date_ IN DATE )
IS
   begin_date_          DATE;
   error_template_id_   NUMBER;
   error_period_no_     NUMBER;
   prev_end_counter_    NUMBER;
   manuf_calendar_id_   VARCHAR2(10);
   no_previous_period   EXCEPTION;
   --
   CURSOR get_templates(contract_ VARCHAR2) IS
      SELECT template_id
      FROM PERIOD_TEMPLATE_TAB
      WHERE  contract = contract_;
   --
   CURSOR get_periods(contract_ VARCHAR2, template_id_ NUMBER) IS
      SELECT period_no,
             period_length,
             length_in_work_days,
             previous_length,
             period_begin_counter,
             period_end_counter,
             plan_period_unit
      FROM PERIOD_TEMPLATE_DETAIL_TAB
      WHERE contract    = contract_
      AND   template_id = template_id_
      AND   period_no   > 0
      ORDER BY period_no;
BEGIN
   
   -- is the user allowed access to the site? if not, exit.
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   --
   FOR template_rec IN get_templates(contract_) LOOP
      manuf_calendar_id_ := Period_Template_API.Get_Calendar_Id(contract_, template_rec.template_id);
      error_template_id_ := template_rec.template_id;
      --
      -- update the recalculation date in the header; need to check that recalculation_date_
      -- is a work day...
      begin_date_ := Work_Time_Calendar_API.Get_Closest_Work_Day(manuf_calendar_id_, recalculation_date_);
      
      Period_Template_API.Modify(
         contract_              => contract_,
         template_id_           => template_rec.template_id,
         template_description_  => TO_CHAR(NULL),
         recalculation_date_    => begin_date_,
         calendar_id_           => manuf_calendar_id_);
      -- The recalculation_date_ is updated even though 
      -- errors are raised when processing template periods.
      @ApproveTransactionStatement(2009-10-22,kayolk)
      COMMIT;
      --
      FOR period_rec IN get_periods(contract_, template_rec.template_id) LOOP
         error_period_no_ := period_rec.period_no;
         -- get the previous_length.
         period_rec.previous_length := Period_Template_Detail_API.Get_Prev_Length_Work (
                                          contract_,
                                          template_rec.template_id,
                                          period_rec.period_no);
         -- calculate the length in workdays.
         Period_Template_Detail_API.Calc_Length_In_Workdays__ (
            period_rec.length_in_work_days,
            contract_,
            template_rec.template_id,
            period_rec.period_no,
            period_rec.plan_period_unit,
            period_rec.period_length,
            manuf_calendar_id_,
            begin_date_);
         -- set the begin and end counters.
         IF (period_rec.period_no = 0) THEN
            -- no need to modify the begin and end counters...
            NULL;
         ELSIF (period_rec.period_no = 1) THEN
            -- first period is a special case calculated off passed in
            -- Recalculation Date; since Recalculation_Date may not be a workday,
            -- use begin_date_ which is a workday to get counters.
            period_rec.period_begin_counter := Work_Time_Calendar_API.Get_Work_Day_Counter(
                                                  manuf_calendar_id_,
                                                  begin_date_);
            period_rec.period_end_counter := (period_rec.period_begin_counter +
                                              period_rec.length_in_work_days) - 1;
         ELSE
           -- for all periods other than period 1, begin counter will be the end
           -- counter of the last period; end counter will be the ( begin counter
           -- + length in work days ) - 1.
           prev_end_counter_ := Period_Template_Detail_API.Get_Period_End_Counter(contract_, template_rec.template_id, period_rec.period_no - 1);
           IF (prev_end_counter_ IS NOT NULL) THEN
              period_rec.period_begin_counter := prev_end_counter_ + 1;
              period_rec.period_end_counter := (period_rec.period_begin_counter +
                 period_rec.length_in_work_days) - 1;
           ELSE
              RAISE no_previous_period;
           END IF;
        END IF;
        Period_Template_Detail_API.Modify(
           contract_              => contract_,
           template_id_           => template_rec.template_id,
           period_no_             => period_rec.period_no,
           period_length_         => NULL,
           length_in_work_days_   => period_rec.length_in_work_days,
           previous_length_       => period_rec.previous_length,
           period_begin_counter_  => period_rec.period_begin_counter,
           period_end_counter_    => period_rec.period_end_counter,
           plan_period_unit_      => NULL);
     END LOOP;
  END LOOP;
EXCEPTION
   WHEN no_previous_period THEN
      Error_SYS.Appl_General(lu_name_,
         'NOPREVPERIOD: For Site :P1 Template ID :P2 there are no periods prior to period :P3.',
         contract_, error_template_id_, error_period_no_);
END Recalculate_Site_Templates;


-- Recalculate_Template
--   Recalculate a specific template.
PROCEDURE Recalculate_Template (
   contract_           IN VARCHAR2,
   template_id_        IN NUMBER,
   recalculation_date_ IN DATE,
   calendar_id_        IN VARCHAR2 )
IS
   begin_date_        DATE;
   error_period_no_   NUMBER;
   prev_end_counter_  NUMBER;
   no_previous_period EXCEPTION;
   --
   CURSOR get_periods(contract_ VARCHAR2, template_id_ NUMBER) IS
      SELECT period_no,
             period_length,
             length_in_work_days,
             previous_length,
             period_begin_counter,
             period_end_counter,
             plan_period_unit
      FROM PERIOD_TEMPLATE_DETAIL_TAB
      WHERE contract    = contract_
      AND   template_id = template_id_
      AND   period_no   > 0
      ORDER BY period_no;
BEGIN
   Period_Template_API.Exist(contract_, template_id_);
   Work_Time_calendar_API.Exist(calendar_id_);
   -- is the user allowed access to the site? if not, exit.
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   -- update the recalculation date in the header; need to check that recalculation_date_
   -- is a work day...
   begin_date_ := Work_Time_Calendar_API.Get_Closest_Work_Day(calendar_id_, recalculation_date_);
   
   Period_Template_API.Modify (
      contract_              => contract_,
      template_id_           => template_id_,
      template_description_  => to_char(NULL),
      recalculation_date_    => begin_date_,
      calendar_id_           => calendar_id_);
   -- The recalculation_date_ is updated even though 
   -- errors are raised when processing template periods.
   @ApproveTransactionStatement(2009-10-22,kayolk)
   COMMIT;
   --
   FOR period_rec IN get_periods(contract_, template_id_) LOOP
      error_period_no_ := period_rec.period_no;
      -- get the previous_length.
      period_rec.previous_length := Period_Template_Detail_API.Get_Prev_Length_Work (
                                       contract_,
                                       template_id_,
                                       period_rec.period_no);
      -- calculate the length in workdays.
      Period_Template_Detail_API.Calc_Length_In_Workdays__ (
         period_rec.length_in_work_days,
         contract_,
         template_id_,
         period_rec.period_no,
         period_rec.plan_period_unit,
         period_rec.period_length,
         calendar_id_,
         begin_date_);
      -- set the begin and end counters.
      IF (period_rec.period_no = 1) THEN
         -- first period is a special case calculated off passed in
         -- Recalculation Date; since Recalculation_Date may not be a workday,
         -- use begin_date_ which is a workday to get counters.
         period_rec.period_begin_counter := Work_Time_Calendar_API.Get_Work_Day_Counter(
                                               calendar_id_,
                                               begin_date_);
         period_rec.period_end_counter := period_rec.period_begin_counter + period_rec.length_in_work_days - 1;
      ELSE
         -- for all periods other than period 1, begin counter will be the end
         -- counter of the last period; end counter will be the ( begin counter + length in work days ) - 1.
         prev_end_counter_ := Period_Template_Detail_API.Get_Period_End_Counter(contract_, template_id_, period_rec.period_no - 1);
         IF (prev_end_counter_ IS NOT NULL) THEN
            period_rec.period_begin_counter := prev_end_counter_ + 1;
            period_rec.period_end_counter := period_rec.period_begin_counter + period_rec.length_in_work_days - 1;
         ELSE
            RAISE no_previous_period;
         END IF;
      END IF;
      --
      Period_Template_Detail_API.Modify (
         contract_              => contract_,
         template_id_           => template_id_,
         period_no_             => period_rec.period_no,
         period_length_         => NULL,
         length_in_work_days_   => period_rec.length_in_work_days,
         previous_length_       => period_rec.previous_length,
         period_begin_counter_  => period_rec.period_begin_counter,
         period_end_counter_    => period_rec.period_end_counter,
         plan_period_unit_      => NULL);
      -- The recalculation_date_ is updated even though 
      -- errors are raised when processing template periods.
      @ApproveTransactionStatement(2009-10-22,kayolk)
      COMMIT;
   END LOOP;
EXCEPTION
   WHEN no_previous_period THEN
      Error_SYS.Appl_General( lu_name_,
         'NOPREVPERIOD: For Site :P1 Template ID :P2 there are no periods prior to period :P3.',
         contract_, template_id_, error_period_no_);
END Recalculate_Template;


-- Get_Period_Data_From
--   Return the PeriodTemplateDetailTable containing data starting from the
--   given period number.
@UncheckedAccess
FUNCTION Get_Period_Data_From (
   contract_        IN VARCHAR2,
   template_id_     IN NUMBER,
   start_period_no_ IN NUMBER ) RETURN Period_Template_Detail_API.Data_Rec_Table
IS
   data_  Period_Template_Detail_API.Data_Rec_Table;
   CURSOR get_period_attr IS
      SELECT template_id,contract,period_no,period_length,length_in_work_days,previous_length,period_begin_counter,period_end_counter,plan_period_unit
      FROM period_template_detail_tab
      WHERE contract  = contract_
      AND template_id = template_id_
      AND period_no  >= start_period_no_;
BEGIN
   OPEN  get_period_attr;
   FETCH get_period_attr BULK COLLECT INTO data_;
   CLOSE get_period_attr;
   RETURN data_;
END Get_Period_Data_From;



-- Get_Begin_Period_No
--   Return the starting period number for the given date.
@UncheckedAccess
FUNCTION Get_Begin_Period_No (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER,
   date_        IN DATE ) RETURN NUMBER
IS
   counter_        NUMBER;
   period_no_      NUMBER;
   calendar_id_    VARCHAR2(10);

   CURSOR get_begin_period IS
      SELECT period_no
      FROM period_template_detail_tab
      WHERE contract  = contract_
      AND template_id = template_id_
      AND (counter_ BETWEEN  period_begin_counter AND period_end_counter);
BEGIN
   calendar_id_ := Period_Template_API.Get_Calendar_Id(contract_, template_id_);
   counter_     := Work_Time_Calendar_API.Get_Work_Day_Counter(calendar_id_, date_);

   OPEN  get_begin_period;
   FETCH get_begin_period INTO period_no_;
   CLOSE get_begin_period;

   RETURN period_no_;
END Get_Begin_Period_No;




