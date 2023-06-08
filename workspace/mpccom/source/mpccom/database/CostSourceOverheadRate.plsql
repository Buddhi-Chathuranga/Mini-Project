-----------------------------------------------------------------------------
--
--  Logical unit: CostSourceOverheadRate
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  051216  JoEd     Added restriction to only allow positive overhead rates.
--  051013  JoEd     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cost_source_overhead_rate_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.overhead_rate < 0) THEN
      Error_SYS.Item_General(lu_name_, 'OVERHEAD_RATE', 'LESSZERO: [:NAME] may not be less than 0.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cost_source_overhead_rate_tab%ROWTYPE,
   newrec_ IN OUT cost_source_overhead_rate_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.overhead_rate < 0) THEN
      Error_SYS.Item_General(lu_name_, 'OVERHEAD_RATE', 'LESSZERO: [:NAME] may not be less than 0.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Overhead_Rate (
   company_ IN VARCHAR2,
   cost_source_id_ IN VARCHAR2,
   valid_from_date_ IN DATE ) RETURN NUMBER
IS
   temp_ COST_SOURCE_OVERHEAD_RATE_TAB.overhead_rate%TYPE;
   CURSOR get_attr IS
      SELECT overhead_rate
      FROM   COST_SOURCE_OVERHEAD_RATE_TAB
      WHERE  company = company_
      AND   cost_source_id = cost_source_id_
      AND   valid_from_date <= valid_from_date_
      ORDER BY valid_from_date DESC;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Overhead_Rate;


@UncheckedAccess
FUNCTION Get_Current_Overhead_Rate (
   company_        IN VARCHAR2,
   cost_source_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Overhead_Rate(company_, cost_source_id_, SYSDATE);
END Get_Current_Overhead_Rate;



