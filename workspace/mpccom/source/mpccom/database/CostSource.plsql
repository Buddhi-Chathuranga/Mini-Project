-----------------------------------------------------------------------------
--
--  Logical unit: CostSource
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181022  NaLrlk  SCUXXW4-7767, Added Overhead_Rate_Exist().
--  050829  JoAnSe  Added Get_Control_Type_Value_Desc
--  050511  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cost_source_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.cost_source_id = '*') THEN
         Error_SYS.Record_General(lu_name_, 'ILLEGAL_VALUE: :P1 is not an allowed identifier value for Cost Source Id', newrec_.cost_source_id);
   END IF;

   IF (upper(newrec_.cost_source_id) != newrec_.cost_source_id) THEN
      Error_SYS.Record_General(lu_name_,'UPPERCASE: The Cost Source Id must be entered in upper-case.');
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Support method used by posting control logic
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(company_, value_);
END Get_Control_Type_Value_Desc;

@UncheckedAccess
FUNCTION Overhead_Rate_Exist (
   company_        IN VARCHAR2,
   cost_source_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR check_exist IS
      SELECT 1
      FROM   cost_source_overhead_rate_tab
      WHERE  company = company_
      AND    cost_source_id = cost_source_id_;
   temp_          NUMBER;
   rate_exist_    VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF check_exist%FOUND THEN
      rate_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exist;
   RETURN rate_exist_;
END Overhead_Rate_Exist;
