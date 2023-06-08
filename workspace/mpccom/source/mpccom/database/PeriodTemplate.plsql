-----------------------------------------------------------------------------
--
--  Logical unit: PeriodTemplate
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190927  SURBLK  Added Raise_Default_Site_Modify_Error___ to handle error messages and avoid code duplication.
--  120313  MaRalk   Modified the file by taking lu_name_ one line up in ERROR_SYS.Appl_General and ERROR_SYS.Record_General  
--  120313           method calls to correctly scan by the translation tool. 
--  111005  DeKoLK   EANE-3742, Moved 'User Allowed Site' in Default Where condition from client.
--  100429  Ajpelk   Merge rose method documentation
--  091005  ChFolk   Removed unused parameter attr_ from Insert_Default_Template___.
--  --------------------------------- 14.0.0 --------------------------------
--  081016  SudJlk   Bug 77768, Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  060117  SeNslk   Modified the PROCEDURE Insert___ according to the template.
--  050927  Sujalk   Changed referecnce site_public to user_allowed_site_pub
--  050520  NaWalk   Added a condition to check if data exists in tables before accessing them.
--  050427  UsRalk   Modified the algorithm of method Get_Period_Begin_Dates.
--  050419  UsRalk   Added new method Get_Period_Begin_Dates.
--  050210  SaJjlk   Moved the LU from MFGSTD to MPCCOM.
--  --------------------------- 13.3.0 --------------------------------------
--  010613  BEHA     Bug 15677, Call to General_SYS.Init_Method.
--  010412  ERHO     Bug 21337: Added NOCOPY to IN OUT and Out arguments.
--  010112  ANTA     AL 60100 - Added UserAllowedSite to LOVs.
--  010111  ZEDE     AL 58472 modified Unpack_Check_Insert___, to check for non integer/decimal
--                   Period Template Ids
--  990803  KEVS     Yoshimura performance tuning.
--  990617  KEVS     Made Template change in Get_Object_By_Id___.
--  990603  MAKU     AL Call Id 19640 - Fix in Prepare_Insert___ and UCI for
--                   Period 1 Begin Date to be a work day.
--  990423  MAKU     Yoshimura template changes.
--  990318  SOPR     AL 13572 - Added new column Calendar_Id.
--                   Modified method : Modify, New.
--                   New Method : Get_Calendar_Id.
--  990304  WIGR     AL Bug 11123 - added code to Unpack_Check_Update__ to (re)create
--                   details for Period Template 1 if user attempts to create a
--                   Template for that site after deleting all the details for Template
--                   1 but not the header
--  990218  WIGR     AL Bug 9400 - changed call to
--                   Period_Template_Detail_API.Create_Template_1_Details to
--                   Period_Template_Detail_API.Create_Template1_Details in
--                   Unpack_Check_Insert__
--  990213  WIGR     Monty IID 1082 - Added TRUNC to Site_API.Get_Site_Date
--                   in Prepare_Insert__
--  990213  WIGR     Monty IID 1082 - changed SYSDATE to Site_API.Get_Site_Date
--                   in Prepare_Insert__
--  990209  WIGR     Monty IID 820 - rewrote Modify and Unpack_Check_Update__ to
--                   allow recalculation of default template (Template Id 1)
--  990128  WIGR     Monty IID 820 - added checks to prevent the default template
--                   (Template Id 1) from modification or if other templates for
--                   that Site exist, from deletion; improved exception handling in
--                   Modify
--  990128  ANTA     Renamed to mixed case naming standard.
--  990117  WIGR     Monty IID 820 - added code in Unpack_Check_Insert___ to create
--                   a period template 1 header and details if on does not already exist
--  990106  WIGR     Monty IID 820 - added get methods for Last Recalculation Date
--                   and Template Description; changes to PERIOD_TEMPLATE_LOV and
--                   PERIOD_TEMPLATE_CONTRACT_LOV
--  981218  WIGR     Monty IID 820 - added two new LOV views for use in implementation
--                   of Period Templates in MS and MRP
--  981109  WIGR     Monty IID 820 - removed () after call to Get_Contract in
--                   Prepare_Insert__ as these cause problems in Oracle 7
--  981104  WIGR     Monty IID 820 - added public New, Check_Exist and Modify methods
--  981020  WIGR     Monty IID 820 - create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Template_Date_Rec IS RECORD
   (period_no  NUMBER,
    begin_date DATE);

TYPE Template_Date_Table IS TABLE OF Template_Date_Rec INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Insert_Default_Template___
--   Inserts default period template (number 1)
PROCEDURE Insert_Default_Template___ (
   objid_         OUT NOCOPY    VARCHAR2,
   objversion_    OUT NOCOPY    VARCHAR2,
   newrec_     IN OUT NOCOPY    PERIOD_TEMPLATE_TAB%ROWTYPE )
IS
BEGIN
   INSERT
      INTO period_template_tab (
         contract,
         template_id,
         template_description,
         recalculation_date,
         calendar_id,
         rowversion)
      VALUES (
         newrec_.contract,
         newrec_.template_id,
         newrec_.template_description,
         newrec_.recalculation_date,
         newrec_.calendar_id,
         sysdate);
   Get_Id_Version_By_Keys___(objid_,objversion_,newrec_.contract,newrec_.template_id);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert_Default_Template___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_            VARCHAR2(5)  := User_Default_API.Get_Contract;
   calendar_id_         VARCHAR2(10) := Site_API.Get_Manuf_Calendar_Id(contract_);
   period_1_begin_date_ DATE         := TRUNC(Work_Time_Calendar_API.Get_Closest_Work_Day(
                                           calendar_id_,
                                           Site_API.Get_Site_Date (contract_)));
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('RECALCULATION_DATE', period_1_begin_date_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN PERIOD_TEMPLATE_TAB%ROWTYPE )
IS
   dummy_ NUMBER := 0;

   CURSOR number_of_templates IS
      SELECT count(*)
      FROM PERIOD_TEMPLATE_TAB
      WHERE contract = remrec_.contract
      AND   template_id > 1;
BEGIN
   -- The default template (Template Id 1) may not be deleted if other Templates
   -- for that Site still exist
   IF remrec_.template_id = 1 THEN
      OPEN number_of_templates;
      FETCH number_of_templates INTO dummy_;
      CLOSE number_of_templates;
      IF dummy_ > 0 THEN
         ERROR_SYS.Record_General(lu_name_,
            'DELTEMP1: The default Template (Template Id 1) for a Site may not be deleted if other Templates for that Site exist.');
      END IF;
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT period_template_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_               VARCHAR2(30);
   value_              VARCHAR2(4000);
   recalculation_date_ DATE;
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   temprec_            PERIOD_TEMPLATE_TAB%ROWTYPE;
BEGIN
   super(newrec_, indrec_, attr_);

   -- is the user allowed access to the site? if not, exit.
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   -- check that there is a manuf calendar defined for the site;
   IF Site_API.Get_Manuf_Calendar_Id(newrec_.contract) IS NULL THEN
      ERROR_SYS.Appl_General(lu_name_,
         'NOCALTEMPLATE: No manufacturing calendar has been defined for Site '||newrec_.contract||'. You must create a manufacturing calendar before creating Period Templates.');
   END IF;
   -- period 1 begin date must be a work day.
   IF (Work_Time_Calendar_API.Is_Working_Day (newrec_.calendar_id, TRUNC(newrec_.recalculation_date)) = 0) THEN
      ERROR_SYS.Appl_General(lu_name_, 'PER1BEGDATEERR: Period 1 Begin Date must be a work day.');
   END IF;
   --
   IF (newrec_.template_id = 1) THEN
      ERROR_SYS.Appl_General(lu_name_,
         'TEMPLATEID1: Template Id 1 is generated by the system when the user creates the first template for a site. User defined Template Ids can range from 2 to 99999. Please enter a Template Id in this range.');
   ELSIF (newrec_.template_id < 1 OR newrec_.template_id > 99999) THEN
      ERROR_SYS.Appl_General(lu_name_,
         'TEMPLATEIDSIZE: User defined Template Ids must be between 2 and 99999. Please enter a Template Id in this range.');
   ELSIF(instr(newrec_.template_id,'.') > 0)  THEN
      ERROR_SYS.Appl_General(lu_name_,
         'TEMPLATEIDVAL: User defined Template Ids must not be non integers. Please enter an integer value.');
   ELSE
      -- check that a Template Id 1 exists; if not create it.
      recalculation_date_ := TRUNC(newrec_.recalculation_date);
      IF (Check_Exist(newrec_.contract, 1) = 0) THEN
         -- Create template id 1 header and details based on the calendar
         temprec_.contract             := newrec_.contract;
         temprec_.template_id          := 1;
         temprec_.template_description := substr(Language_SYS.Translate_Constant (lu_name_, 'SYSDEFTEMPLATE: System created template based on manufacturing calendar.'), 1, 50);
         temprec_.recalculation_date   := recalculation_date_;
         temprec_.calendar_id          := newrec_.calendar_id;
         Insert_Default_Template___(objid_      => objid_,
                                    objversion_ => objversion_,
                                    newrec_     => temprec_);
         -- Then create the details for template id 1
         Period_Template_Detail_API.Create_Template1_Details(temprec_.contract, recalculation_date_);
      ELSIF (Period_Template_Detail_API.Check_Exist_Any_Period (newrec_.contract, 1) = 0) THEN
         -- the header for Template Id 1 exists, but there are no details => recreate those.
         Period_Template_Detail_API.Create_Template1_Details(newrec_.contract, recalculation_date_);
         -- now update the Recalculation Date in the Header of Template Id 1.
         Modify(
            contract_             => newrec_.contract,
            template_id_          => 1,
            template_description_ => TO_CHAR(NULL),
            recalculation_date_   => recalculation_date_,
            calendar_id_          => NULL);
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     period_template_tab%ROWTYPE,
   newrec_ IN OUT period_template_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_              VARCHAR2(30);
   value_             VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- check if the user is attempting to modify Template 1; raise an error if
   -- they are.
   IF newrec_.template_id = 1 AND indrec_.template_description THEN
      Raise_Default_Site_Modify_Error___;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

PROCEDURE Raise_Default_Site_Modify_Error___ 
IS
BEGIN
   ERROR_SYS.Record_General(lu_name_,
         'UCUUPDTEMPID1: The description for a Site default Template (Template Id 1) cannot be modified.');
END Raise_Default_Site_Modify_Error___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Returns 1 if record exists, otherwise 0.
@UncheckedAccess
FUNCTION Check_Exist (
   contract_     IN VARCHAR2,
   template_id_  IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF Check_Exist___(contract_, template_id_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Check_Exist;


-- Modify
--   Public Modify method.
PROCEDURE Modify (
   contract_              IN VARCHAR2,
   template_id_           IN NUMBER,
   template_description_  IN VARCHAR2,
   recalculation_date_    IN DATE,
   calendar_id_           IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     PERIOD_TEMPLATE_TAB%ROWTYPE;
   --
   CURSOR get_object IS
      SELECT *
      FROM PERIOD_TEMPLATE_TAB
      WHERE contract     = contract_
      AND   template_id  = template_id_;
BEGIN
   objid_ := NULL;
   FOR get_object_rec IN get_object LOOP
      attr_ := NULL;
      newrec_ := Lock_By_Keys___(
                    get_object_rec.contract,
                    get_object_rec.template_id);
      IF (template_description_ IS NOT NULL) THEN
         -- check if the user is attempting to modify description for Template 1
         -- raise an error if they are
         IF template_id_ = 1 THEN
            Raise_Default_Site_Modify_Error___;
         ELSE
            newrec_.template_description := template_description_;
         END IF;
      END IF;
      IF (recalculation_date_ IS NOT NULL) THEN
         newrec_.recalculation_date := recalculation_date_;
      END IF;
      IF (calendar_id_ IS NOT NULL) THEN
         newrec_.calendar_id := calendar_id_;
      END IF;
      Update___(objid_, get_object_rec, newrec_, objversion_, attr_, TRUE);
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      IF ERROR_SYS.Is_Foundation_Error(SQLCODE) THEN
         RAISE;
      END IF;

      Error_Sys.Appl_General(lu_name_,
         'MODIFYGENERR: Oracle error :P1 occurred in PERIOD_TEMPLATE_API.Modify while processing Site :P2 Template Id :P3.',
         sqlerrm, contract_, template_id_);
END Modify;


-- New
--   Public New method.
PROCEDURE New (
   contract_             IN VARCHAR2,
   template_id_          IN NUMBER,
   template_description_ IN VARCHAR2,
   recalculation_date_   IN DATE,
   calendar_id_          IN VARCHAR2 )
IS
   objid_        PERIOD_TEMPLATE.objid%TYPE;
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);
   indrec_       Indicator_Rec;
   newrec_       PERIOD_TEMPLATE_TAB%ROWTYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('TEMPLATE_ID', template_id_, attr_);
   Client_SYS.Add_To_Attr('TEMPLATE_DESCRIPTION', template_description_, attr_);
   Client_SYS.Add_To_Attr('RECALCULATION_DATE', recalculation_date_, attr_);
   Client_SYS.Add_To_Attr('CALENDAR_ID', calendar_id_, attr_);   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Get_Period_Begin_Dates
--   This method will return a PL/SQL table of begin date and period_no.
PROCEDURE Get_Period_Begin_Dates (
   template_date_tab_ OUT NOCOPY Template_Date_Table,
   contract_          IN         VARCHAR2,
   template_id_       IN         NUMBER )
IS
   CURSOR get_periods IS
      SELECT period_no, period_begin_counter
        FROM period_template_detail_tab
       WHERE contract    = contract_
         AND template_id = template_id_;

   TYPE Periods_Table IS TABLE OF get_periods%ROWTYPE;

   periods_tab_  Periods_Table;
   calendar_id_  VARCHAR2(10);
   begin_date_   DATE;
BEGIN

   OPEN  get_periods;
   FETCH get_periods BULK COLLECT INTO periods_tab_;
   CLOSE get_periods;

   calendar_id_ := Get_Calendar_Id(contract_, template_id_);

   IF (periods_tab_.COUNT > 0) THEN
      FOR i IN periods_tab_.FIRST..periods_tab_.LAST LOOP
         begin_date_ := Work_Time_Calendar_API.Get_Work_Day(calendar_id_, periods_tab_(i).period_begin_counter);
         template_date_tab_(i).period_no  := periods_tab_(i).period_no;
         template_date_tab_(i).begin_date := begin_date_;
      END LOOP;
   END IF;
END Get_Period_Begin_Dates;



