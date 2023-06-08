-----------------------------------------------------------------------------
--
--  Logical unit: PeriodTemplateInt
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100429  Ajpelk   Merge rose method documentation
------------------------------Eagle------------------------------------------
--  050210  SaJjlk   Moved the LU from MFGSTD to MPCCOM.
-----------------------------------------------------------------------------
--  010613  BEHA     Bug 15677, Call to General_SYS.Init_Method.
--  990803  KEVS     Yoshimura performance tuning.
--  990716  STCH     Added method GetCalendarId to call PeriodTemplate method.
--  990322  SOPR     AL Bug 13572 : Added calendar_id parameter to Recalculate_Template.
--  990206  WIGR     MONTY IID 820 - changed public method Period_Template_Exist
--                   to function and added PRAGMA
--  990128  ANTA     Renamed to mixed case naming standard.
--  990116  WIGR     MONTY IID 820 - added public method Period_Template_Exist
--  990116  WIGR     MONTY IID 820 - added public methods Get_Template_Description
--                   and Get_Recalculation_Date
--  981109  WIGR     Monty IID 820 - replaced the NULL; with method calls
--  981020  WIGR     Monty IID 820 - create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Period
--   Try to find a period between ReferenceDate and CurrentDate
PROCEDURE Get_Period (
   period_exists_  OUT    NUMBER,
   period_no_      IN OUT NUMBER,
   current_length_ IN OUT NUMBER,
   contract_       IN     VARCHAR2,
   template_id_    IN     NUMBER,
   reference_date_ IN     DATE,
   current_date_   IN     DATE )
IS
BEGIN
   Period_Template_Detail_API.Get_Period (
      period_exists_  => period_exists_,
      period_no_      => period_no_,
      current_length_ => current_length_,
      contract_       => contract_,
      template_id_    => template_id_,
      reference_date_ => reference_date_,
      current_date_   => current_date_ );
END Get_Period;


-- Get_Period_Dates
--   Gets the start and end dates for the period and
--   the coresponding counter values from shop calender.
PROCEDURE Get_Period_Dates (
   period_exists_  OUT    NUMBER,
   period_no_      IN OUT NUMBER,
   current_length_ IN OUT NUMBER,
   begin_date_     IN OUT DATE,
   end_date_       IN OUT DATE,
   begin_counter_  IN OUT NUMBER,
   end_counter_    IN OUT NUMBER,
   contract_       IN     VARCHAR2,
   template_id_    IN     NUMBER,
   reference_date_ IN     DATE )
IS
BEGIN
   Period_Template_Detail_API.Get_Period_Dates (
      period_exists_  => period_exists_,
      current_length_ => current_length_,
      begin_date_     => begin_date_,
      end_date_       => end_date_,
      begin_counter_  => begin_counter_,
      end_counter_    => end_counter_,
      contract_       => contract_,
      template_id_    => template_id_,
      period_no_      => period_no_,
      reference_date_ => reference_date_ );
END Get_Period_Dates;


-- Get_Recalculation_Date
--   Retruns recalculation date.
@UncheckedAccess
FUNCTION Get_Recalculation_Date (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER ) RETURN DATE
IS
BEGIN
   RETURN Period_Template_API.Get_Recalculation_Date(contract_, template_id_);
END Get_Recalculation_Date;



-- Get_Template_Description
--   Returns template description.
@UncheckedAccess
FUNCTION Get_Template_Description (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Period_Template_API.Get_Template_Description(contract_, template_id_);
END Get_Template_Description;



-- Modify_Periods
--   Modifies LengthInWorkDays and PrevLength according to the
--   shop calendar
PROCEDURE Modify_Periods (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER,
   work_day_    IN DATE )
IS
BEGIN
   Period_Template_Detail_API.Modify_Periods (
      contract_    => contract_,
      template_id_ => template_id_,
      work_day_    => work_day_ );
END Modify_Periods;


-- Period_Template_Exist
--   Public Period Template Exist method.
@UncheckedAccess
FUNCTION Period_Template_Exist (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Period_Template_API.Check_Exist(contract_, template_id_);
END Period_Template_Exist;



-- Recalculate_Site_Templates
--   Recalculate all templates for the given site.
PROCEDURE Recalculate_Site_Templates (
   contract_           IN VARCHAR2,
   recalculation_date_ IN DATE )
IS
BEGIN
   Period_Template_Manager_API.Recalculate_Site_Templates (
      contract_           => contract_,
      recalculation_date_ => recalculation_date_ );
END Recalculate_Site_Templates;


-- Recalculate_Template
--   Recalculate a specific template.
PROCEDURE Recalculate_Template (
   contract_           IN VARCHAR2,
   template_id_        IN NUMBER,
   recalculation_date_ IN DATE,
   calendar_id_        IN VARCHAR2 )
IS
BEGIN
   Period_Template_Manager_API.Recalculate_Template (
      contract_           => contract_,
      template_id_        => template_id_,
      recalculation_date_ => recalculation_date_,
      calendar_id_        => calendar_id_ );
END Recalculate_Template;


-- Get_Calendar_Id
--   Calls PeriodTemplate.GetCalendarId
@UncheckedAccess
FUNCTION Get_Calendar_Id (
   contract_    IN VARCHAR2,
   template_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Period_Template_API.Get_Calendar_Id (
      contract_,
      template_id_ );
END Get_Calendar_Id;




