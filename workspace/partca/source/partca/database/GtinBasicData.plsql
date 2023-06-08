-----------------------------------------------------------------------------
--
--  Logical unit: GtinBasicData
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201218  SBalLK   Issue SC2020R1-11830, Modified Modify_Next_Value___() method by removing attr_ functionality to optimize the performance.
--  100930  NaLrlk   Added method Modify_Next_Value___.
--  100924  NaLrlk   Removed method Validate_Digit_Lengths___ and modified the method Get_Auto_Created_Gtin_Number.
--  090714  AmPalk   Bug 83121, Made gtin a varchar2, hence changed the returned datatype of the parameter in Get_Auto_Created_Gtin_Number.
--  090714              Made company_prefix a varchar2, hence changed the datatype of the in parameters in methods.
--  080924  MiKulk   Extended the code for GTIN_14
--  080408  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Next_Value___
--   Modify the next value from Gtin basic data record.
PROCEDURE Modify_Next_Value___ (
   company_prefix_ IN VARCHAR2,
   gtin_series_db_ IN VARCHAR2,
   next_value_     IN NUMBER )
IS
   newrec_         GTIN_BASIC_DATA_TAB%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(company_prefix_, gtin_series_db_);
   newrec_.next_value := next_value_;
   Modify___(newrec_);
END Modify_Next_Value___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT gtin_basic_data_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);

   Gtin_Factory_Util_API.Validate_Digits_Length(newrec_.company_prefix,
                                                newrec_.gtin_series,
                                                newrec_.start_value,
                                                newrec_.next_value,
                                                newrec_.end_value);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     gtin_basic_data_tab%ROWTYPE,
   newrec_ IN OUT gtin_basic_data_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Gtin_Factory_Util_API.Validate_Digits_Length(newrec_.company_prefix,
                                                newrec_.gtin_series,
                                                newrec_.start_value,
                                                newrec_.next_value,
                                                newrec_.end_value);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Auto_Created_Gtin_Number
--   Return the next GTIN Number relevant to a given company prefix / gtin series and update the next value.
PROCEDURE Get_Auto_Created_Gtin_Number (
   gtin_no_        OUT VARCHAR2,
   company_prefix_ IN  VARCHAR2,
   gtin_series_    IN  VARCHAR2 )
IS
   newrec_             GTIN_BASIC_DATA_TAB%ROWTYPE;
   gtin_series_db_     VARCHAR2(20);
BEGIN

   IF (company_prefix_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'COMPPREFIXNULL: Company prefix must be entered in company distribution data.');
   END IF;

   gtin_series_db_ := Gtin_Series_API.Encode(gtin_series_);
   IF (NOT Check_Exist___(company_prefix_, gtin_series_db_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOBASICDATA: GTIN series :P1 has not been defined for the company prefix :P2 in GTIN basic data.', gtin_series_, company_prefix_);
   END IF;
   newrec_ := Get_Object_By_Keys___(company_prefix_, gtin_series_db_);

   Gtin_Factory_Util_API.Get_Auto_Created_Gtin(gtin_no_, newrec_.next_value, company_prefix_, gtin_series_db_);

   Modify_Next_Value___(company_prefix_, gtin_series_db_, newrec_.next_value);
END Get_Auto_Created_Gtin_Number;


PROCEDURE Company_Prefix_Exists (
   company_prefix_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   GTIN_BASIC_DATA_TAB
      WHERE company_prefix = company_prefix_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'COMPPREFIXERR: Company Prefix :P1 is not found in GTIN Basic Data.', company_prefix_);
   END IF;
   CLOSE exist_control;
END Company_Prefix_Exists;



