-----------------------------------------------------------------------------
--
--  Logical unit: AbcClass
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090311  ChFolk  Bug 80297, Modified Get_Accum_Abc_Percent() by adding abc_class_ as a IN parameter.
--  060222  UsRalk  Modified Procedure Insert___ to return the ABC_CLASS back to client.
--  060202  ChBalk  Bug 55829, Added Function Get_Accum_Abc_Percent and Procedure Check_Accum_Abc_Percent__.
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  051018  SaLalk  Bug 53732, Added Get_Max_Abc_Class() function. Prevented
--  051018          of deletion 'A', 'B' and 'C' classes. Also allow to delete
--  051018          maximum ABC class having 0% and restrict to insert classes after 'Z'.
--  040127  NaWalk  Reversed the unicode modification.
--  040120  NaWalk  Replaced chr() with unistr() and ascii() with asciistr() for Unicode modification.
--  000925  JOHESE  Added undefines.
--  000414  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  990419  ANHO    General performance improvements.
--  990408  ANHO    Upgraded to performance optimized template.
--  971120  gope    Upgrade to fnd 2.0
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970402  GOPE    Added check that given percent is greater than zero
--  970313  CHAN    Change table name: mpc_abc_classes is replaced by
--                  abc_class_tab
--  970219  JOKE    Uses column rowversion as objversion (timestamp).
--  961212  LEPE    Modified for new template standard.
--  961101  MAOR    Added rtrim, rpad round objversion.
--  961024  MAOR    Modified file to Rational Rose Model-standard.
--  960830  MAOR    Added procedure Get_Next_Abc_Class.
--  960725  JOKE    Added PROCEDURE Get_Abc_Percent.
--  960625  LEPE    Corrected one error message that caused an error in localize.
--  960307  JICE    Renamed from InvAbcClasses
--  951011  SHR     Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     abc_class_tab%ROWTYPE,
   newrec_ IN OUT abc_class_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF newrec_.abc_percent < 0 THEN
      Error_SYS.Record_General(lu_name_, 'NEGPERCENT: The percent may not be negative.');
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Accum_Abc_Percent__
--   This procedure checks the accumulated abc percentage is 100.
PROCEDURE Check_Accum_Abc_Percent__
IS
   sum_     NUMBER;
BEGIN
   sum_ := Get_Accum_Abc_Percent();
   IF (sum_ != 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGABCSUM: The sum of the percentages must be 100.');
   END IF;
END Check_Accum_Abc_Percent__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   description_ := Get_Abc_Percent(value_);
END Get_Control_Type_Value_Desc;


PROCEDURE Get_Next_Abc_Class (
   curr_abc_class_   OUT VARCHAR2,
   curr_abc_percent_ OUT NUMBER,
   abc_class_        IN  VARCHAR2 )
IS
   --
   CURSOR next_abc IS
      SELECT abc_class, abc_percent
      FROM   ABC_CLASS_TAB
      WHERE  UPPER(abc_class) > UPPER(abc_class_)
      ORDER BY abc_class;
   --
BEGIN
   --
   curr_abc_class_   := NULL;
   curr_abc_percent_ := NULL;
   --
   OPEN next_abc;
   FETCH next_abc INTO curr_abc_class_,
   curr_abc_percent_;
   CLOSE next_abc;
   --
END Get_Next_Abc_Class;


-- Get_Max_Abc_Class
--   This function will return maximum ABC class that exist.
@UncheckedAccess
FUNCTION Get_Max_Abc_Class RETURN VARCHAR2
IS
   max_abc_class_ ABC_CLASS_TAB.abc_class%TYPE;

   CURSOR get_max_abc_class IS
      SELECT MAX(abc_class)
      FROM   ABC_CLASS_TAB;
BEGIN
   OPEN   get_max_abc_class;
   FETCH  get_max_abc_class INTO max_abc_class_;
   CLOSE  get_max_abc_class;
   RETURN max_abc_class_;
END Get_Max_Abc_Class;


-- Get_Accum_Abc_Percent
--   This function returns accumulated ABC percentage.
@UncheckedAccess
FUNCTION Get_Accum_Abc_Percent (
   abc_class_ IN VARCHAR2 DEFAULT 'Z' ) RETURN NUMBER
IS
   sum_        NUMBER;
   CURSOR get_sum IS
      SELECT SUM(abc_percent)
      FROM ABC_CLASS_TAB
      WHERE abc_class <= abc_class_;
BEGIN
   OPEN  get_sum;
   FETCH get_sum INTO sum_;
   CLOSE get_sum;
   RETURN NVL(sum_, 0);
END Get_Accum_Abc_Percent;



