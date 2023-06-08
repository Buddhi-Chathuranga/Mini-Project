-----------------------------------------------------------------------------
--
--  Logical unit: AccEventPostingType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170421  Cpeilk  STRSC-6843, Modified Posting_Type_Needs_Trans_Curr to add M265 to the list of posting types that books values in transaction currency.
--  170301  ChFolk  STRSC-6174, Modified Posting_Type_Needs_Trans_Curr to remove M196 from the list of posting types that books values in transaction currency.
--  170106  ChFolk  STRSC-5303, Added new methods Posting_Type_Needs_Trans_Curr and Event_Code_Needs_Trans_Curr which are used in
--  170106          creating inventory transactions to check whether transaction currency calculation is needed.
--  131112  UdGnlk  PBSC-355, Modified base view comments to align with model file errors.
--  100426  Ajpelk  Merge rose method documentation
------------------------------Eagle--------------------------------------------
--  070331  RaKalk  Added view ACC_EVENT_POSTING_TYPE_ALL
--  060111  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111          and added UNDEFINE according to the new template.
--  **************  Touchdown Merge Begin  *********************
--  040127  JoAnSe  Rewrote Get_Pre_Accounting_Flag_Db and Get_Project_Accounting_Flag_Db
--  **************  Touchdown Merge End    *********************
--  040223  SaNalk  Removed SUBSTRB.
--  040113  LaBolk  Removed public cursor get_str_event_acc.
--  -------------------------------------- 13.3.0 -----------------------------
--  000925  JOHESE  Added undefines.
--  000331  SHVE    Added columns to attr_type record(pre_accounting_flag_db,
--                  debit_credit_db, project_accounting_flag_db).
--                  Added Get_project_Accounting_Flag_Db and project_accounting_flag column.
--  990422  JOKE    Added method Get_Pre_Accounting_Flag_Db.
--  990421  SHVE    General performance improvements.
--  990415  SHVE    Upgraded to performance optimized template.
--  971120  JOKE    Converted to Foundation1 2.0.0 (32-bit).
--  970313  CHAN    Changed table name: mpc_str_event_acc is replaced by
--                  acc_event_posting_type_tab
--  970221  JOKE    Uses column rowversion as objversion (timestamp).
--  961209  JOKE    Modified to workbench default template and
--                  added function get_debit_credit.
--  960925  JICE    Added function Get_Booking_Str_Code.
--  960829  PEKR    Add public cursor get_str_event_acc.
--  960517  AnAr    Added Purpose comment to file.
--  960307  SHVE    Changed LU Name GenStrEventAcc.
--  951205  JOBR    Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Str_Code
--   Get str code for specific event and debit/credit flag.
PROCEDURE Get_Str_Code (
    str_code_       OUT VARCHAR2,
    event_code_     IN VARCHAR2,
    debit_credit_   IN VARCHAR2 )
IS
   CURSOR get_str_code IS
      SELECT str_code
      FROM ACC_EVENT_POSTING_TYPE_TAB
      WHERE event_code = event_code_
      AND   debit_credit = debit_credit_;
-- debit_credit_ is the Db-value!
-- A call to Debit_Credit_API.Decode(debit_credit_) was done here before.

BEGIN
   --
   OPEN get_str_code;
   FETCH get_str_code INTO str_code_;
   CLOSE get_str_code;
   --
END Get_Str_Code;


-- Get_Booking_Str_Code
--   Get Str_Code for specific booking.
@UncheckedAccess
FUNCTION Get_Booking_Str_Code (
   event_code_    IN VARCHAR2,
   booking_       IN NUMBER ) RETURN VARCHAR2
IS
   str_code_  ACC_EVENT_POSTING_TYPE_TAB.str_code%TYPE;

   CURSOR get_str_code IS
    SELECT str_code
    FROM ACC_EVENT_POSTING_TYPE_TAB
    WHERE event_code = event_code_
    AND   booking = booking_;

BEGIN
   OPEN get_str_code;
   FETCH get_str_code INTO str_code_;
   IF get_str_code%NOTFOUND THEN
      str_code_ := NULL;
   END IF;

   CLOSE get_str_code;

   RETURN str_code_;

END Get_Booking_Str_Code;


@UncheckedAccess
FUNCTION Get_Pre_Accounting_Flag_Db (
   event_code_      IN VARCHAR2,
   str_code_        IN VARCHAR2,
   debit_credit_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pre_accounting_flag_db_    VARCHAR2(1);
   debit_credit_           VARCHAR2(1);

   CURSOR get_pre_accounting IS
     SELECT pre_accounting_flag
       FROM ACC_EVENT_POSTING_TYPE_TAB
      WHERE event_code   = event_code_
        AND str_code     = str_code_
        AND debit_credit = debit_credit_;
BEGIN

   debit_credit_ := debit_credit_db_;

   -- First check preaccounting
   OPEN  Get_Pre_Accounting;
   FETCH Get_Pre_Accounting INTO pre_accounting_flag_db_;
   CLOSE Get_Pre_Accounting;

   -- IF no value was found then check with reversed debit_credit flag
   -- The reason is to be able to handle reversal transaction where the
   -- debit_credit flag has been swapped.
   IF (pre_accounting_flag_db_ IS NULL) THEN
      IF (debit_credit_ = 'D') THEN
         debit_credit_ := 'C';
      ELSE
         debit_credit_ := 'D';
      END IF;

      OPEN  get_pre_accounting;
      FETCH get_pre_accounting INTO pre_accounting_flag_db_;
      CLOSE get_pre_accounting;
   END IF;

   RETURN ( pre_accounting_flag_db_ );
END Get_Pre_Accounting_Flag_Db;


-- Get_Project_Accounting_Flag_Db
--   Retrieve the value of the project_accounting_flag for the specified event_code
--   and str_code. First try to find a record matching the value of debit_credit_db
--   passed in. If no record was found try with reversed debit_credit flag.
@UncheckedAccess
FUNCTION Get_Project_Accounting_Flag_Db (
   event_code_      IN VARCHAR2,
   str_code_        IN VARCHAR2,
   debit_credit_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   project_accounting_flag_db_    VARCHAR2(200);
   debit_credit_               VARCHAR2(1);

   CURSOR get_project_accounting IS
     SELECT project_accounting_flag
       FROM ACC_EVENT_POSTING_TYPE_TAB
      WHERE event_code   = event_code_
        AND str_code     = str_code_
        AND debit_credit = debit_credit_;
BEGIN

   debit_credit_ := debit_credit_db_;

   OPEN  Get_Project_Accounting;
   FETCH Get_Project_Accounting INTO project_accounting_flag_db_;
   CLOSE Get_Project_Accounting;

   -- IF no value was found then check with reversed debit_credit flag
   -- The reason is to be able to handle reversal transaction where the
   -- debit_credit flag has been swapped.
   IF ( project_accounting_flag_db_ IS NULL) THEN
      IF (debit_credit_ = 'D') THEN
         debit_credit_ := 'C';
      ELSE
         debit_credit_ := 'D';
      END IF;

      OPEN  get_project_accounting;
      FETCH get_project_accounting INTO project_accounting_flag_db_;
      CLOSE get_project_accounting;
   END IF;

   RETURN ( project_accounting_flag_db_ );
END Get_Project_Accounting_Flag_Db;

-- Event_Code_Needs_Trans_Curr
--    This method returns TRUE if the given event_code has defined the given str_codes
--    which needs transaction currency revaluation.
FUNCTION Event_Code_Needs_Trans_Curr (
  event_code_  IN VARCHAR2 ) RETURN BOOLEAN
IS  
   trans_curr_needed_  BOOLEAN := FALSE;
                   
   CURSOR get_posting_types IS
      SELECT str_code
      FROM ACC_EVENT_POSTING_TYPE_TAB
      WHERE event_code = event_code_;
BEGIN  
   FOR rec_ IN get_posting_types LOOP
      IF (Posting_Type_Needs_Trans_Curr(rec_.str_code)) THEN
         trans_curr_needed_ := TRUE;
         EXIT;
      END IF;
   END LOOP;

   RETURN trans_curr_needed_;   
END  Event_Code_Needs_Trans_Curr;


FUNCTION Posting_Type_Needs_Trans_Curr (
  str_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   posting_type_needs_trans_curr_ BOOLEAN := FALSE;
BEGIN
   IF str_code_ IN ('M10', 'M14', 'M189', 'M142', 'M198', 'M265') THEN
      posting_type_needs_trans_curr_ := TRUE;
   END IF;

   RETURN(posting_type_needs_trans_curr_);   
END  Posting_Type_Needs_Trans_Curr;

