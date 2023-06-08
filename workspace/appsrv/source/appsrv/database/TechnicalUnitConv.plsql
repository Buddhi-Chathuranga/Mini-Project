-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalUnitConv
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960617  JoRo    Created
--  960826  RoHi    Added Check_Exist_Inverse__
--  960826  RoHi    Modified Insert__. If 'inverse' value is not found,
--                  it is added.
--  960826  RoHi    Modified Update__. If 'inverse' value is found,
--                  it is updated.
--  960904  RoHi    Modified Insert__. If 'inverse' value is found,
--                  nothing is added.
--  970219  frtv    Upgraded.
--  970417  JaPa    Changed to use IsoUnit
--  980402  JaPa    Function Enumerate_Alt_Unit() removed.
--  061026  UtGulk  Added Get_Valid_Conv_Factor().(Bug 61288).
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk  Merge rose method documentation
--  ---------------------------- Best Price --------------------------------
--  100423  JeLise   Added Get_Uom_Conv_Factor and made changes in the view.
--  ---------------------------- APPS 9 -------------------------------------
--  131202  jagrno  Hooks: Refactored and split code. Made all attributes not
--                  insertable/not updateable because New and Modify is not allowed.
--                  Most methods are overtaken intentionally. All operations handled by LU IsoUnit
--  131205  jagrno  Made the entity read-only.
--  131211  jagrno  Made the entity abstract. Removed overtaken methods from read-only LU.
--                  Re-introduced methods Lock__, New__, Modify__, Remove__ and Exist
--                  for backward compatibility.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist___ (
   unit_ IN VARCHAR2,
   alt_unit_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   technical_unit_conv
      WHERE  unit = unit_
      AND    alt_unit = alt_unit_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Lock__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END Lock__;


PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END New__;


PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END Modify__;


PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOTISOUNIT: Action not allowed in this LU');
END Remove__;


-- Check_Exist_Inverse__
--   Checks if inverse value exists and returns True/False
@UncheckedAccess
FUNCTION Check_Exist_Inverse__ (
   unit_     IN VARCHAR2,
   alt_unit_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ VARCHAR2(1);
   CURSOR exist_inv IS
      SELECT 'x'
      FROM TECHNICAL_UNIT_CONV
      WHERE unit = alt_unit_
      AND alt_unit = unit_;
BEGIN
   OPEN exist_inv;
   FETCH exist_inv INTO dummy_;
   IF (exist_inv%FOUND) THEN
      CLOSE exist_inv;
      RETURN 1;
   END IF;
   CLOSE exist_inv;
   RETURN 0;
END Check_Exist_Inverse__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   unit_     IN VARCHAR2,
   alt_unit_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(unit_, alt_unit_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Conv_Factor (
   unit_     IN VARCHAR2,
   alt_unit_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Iso_Unit_API.Get_Factor(unit_)/Iso_Unit_API.Get_Factor(alt_unit_);
END Get_Conv_Factor;


@UncheckedAccess
FUNCTION Get_Valid_Conv_Factor (
   unit_     IN VARCHAR2,
   alt_unit_ IN VARCHAR2 ) RETURN NUMBER
IS
   conv_factor_ NUMBER;
BEGIN
   IF (Iso_Unit_API.Get_Base_Unit(unit_) = Iso_Unit_API.Get_Base_Unit(alt_unit_)) THEN
      conv_factor_ := Get_Conv_Factor(unit_, alt_unit_);
   END IF;
   RETURN conv_factor_;
END Get_Valid_Conv_Factor;


@UncheckedAccess
FUNCTION Get_Uom_Conv_Factor (
   unit_             IN VARCHAR2,
   alt_unit_         IN VARCHAR2,
   uom_constant_     IN NUMBER,
   alt_uom_constant_ IN NUMBER ) RETURN NUMBER
IS
   conv_factor_ NUMBER;
BEGIN
   IF uom_constant_ <> 0 THEN
      conv_factor_ := 0;
   ELSIF alt_uom_constant_ <> 0 THEN
      conv_factor_ := 0;
   ELSE
      conv_factor_ := Get_Conv_Factor(unit_, alt_unit_);
   END IF;
   RETURN conv_factor_;
END Get_Uom_Conv_Factor;
