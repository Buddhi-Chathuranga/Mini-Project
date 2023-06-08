-----------------------------------------------------------------------------
--
--  Logical unit: InternalCustomer
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210831  SBalLK  SC21R2-2442, Replaced Client_SYS.Add_To_Attr by assigning values directly to newrec_ throughout the file.
--  120315  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  080915  NuVelk  Bug 75662, Added Get_Control_Type_Value_Desc to be used from PostingCtrlDetail.
--  060725  ThGulk  Added &OBJID instead of rowid in Procedure Insert___
--  060117  NiDalk  Modified Select &OBJID to RETURNING &OBJID after INSERT INTO in Insert___.
--  000925  JOHESE  Added undefines.
--  000413  NISOSE  Cleaned-up General_SYS.Init_Method.  
--  990422  ANHO    General performance improvements.
--  990408  ANHO    Upgraded to performance optimized template.
--  990305  ANHO    Removed uppercase on name.
--  971127  GOPE    Upgrade to fnd 2.0
--  970912  LEPE    Added public function Check_Exist.
--  970908  LEPE    Added public method New.
--  970312  CHAN    Changed table name: mpc_int_customer is replace by
--                  internal_customer_tab
--  970219  JOKE    Uses column rowversion as objversion (timestamp).
--  961213  LEPE    Modified for new template standard.
--  961104  MAOR    Changed file to new template.
--  961031  MAOR    Modified file to Rational Rose Model-standard.
--  960307  JICE    Renamed from InvInternalCustomer
--  951201  JICE    Duplicate key on insert fixed
--  951101  BJSA    Added Function Get_Customer_Name
--  951003  JICE    Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   For creating new instances of object InternalCustomer.
PROCEDURE New (
   int_customer_no_ IN VARCHAR2,
   name_            IN VARCHAR2,
   extension_       IN VARCHAR2 )
IS
   newrec_     internal_customer_tab%ROWTYPE;
BEGIN
   newrec_.int_customer_no := int_customer_no_;
   newrec_.name            := name_;
   newrec_.extension       := extension_;
   New___(newrec_);
END New;


-- Check_Exist
--   Checks for existence of an  instance of the class. Returns TRUE if
--   instance exists and otherwise returns FALSE.
@UncheckedAccess
FUNCTION Check_Exist (
   int_customer_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Check_Exist___(int_customer_no_));
END Check_Exist;


PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Name(value_);
END Get_Control_Type_Value_Desc;



