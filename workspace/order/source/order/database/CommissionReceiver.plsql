-----------------------------------------------------------------------------
--
--  Logical unit: CommissionReceiver
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191024  HarWlk  SCXTEND-963, Salesman renamed to Salesperson
--  171010  RaVdlk  Removed Get_Objstate function, since it is generated from the foundation 
--  160629  IzShlk  STRSC-1968, Added Get_Objstate methods.
--  160629  IzShlk  STRSC-1968, Overriden Insert and Update methods.
--  160629  IzShlk  STRSC-1968, Occurences of obsolete column Com_Receiver_Status is changed to new column rowstate.
--  130703  MaIklk  Removed inst_Supplier_ global constant and used conditional compilation instead.
--  100623  MoNilk  Removed reference CommissionAgree from agreement_id in the view COMMISSION_RECEIVER.
--  100512  Ajpelk  Merge rose method documentation
--  091229  KiSalk  Changed backorder option values to new IID values in Calculation_Period_API.
--  100615  JeLise   Changed MONTHLY back to MONTH in Prepare_Insert___.
--  091229  KiSalk   Changed backorder option values to new IID values in Calculation_Period_API.
--  091109  MaRalk  Added reference CommissionAgree to agreement_id in the view COMMISSION_RECEIVER.
--  080229  JeLise   Changed from MONTHLY, 3-MONTHLY, HALFYEARLY and YEARLY to MONTH, QUARTER, HALF_YEAR and YEAR in
--  080229           Get_Period_Date_From and Get_Period_Date_Until.
--  *************************** Nice Price *********************
--  070519  WaJalk  Made the column 'commission_receiver' uppercase.
--  060417  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060124  NiDalk  Added Assert safe annotation.
--  060112  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050921  SaMelk  Removed unused variables.
--  040218  IsWilk  Removed SUBSTRB from the view for Unicode Changes.
-- ---------------------------------------13.3.0------------------------------
--  040122  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  040121  GeKalk  Removed the length parameter from bind_variable method for UNICODE modifications.
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in procedure Check_Exist.
--  010413  JaBa    Bug Fix 20598,Added new global lu constant inst_Supplier_.
--  000913  JoEd    Changed validate of vendor_no in Unpack_Check_....
--  000710  JakH    Merging from Chameleon
--  000524  DEHA    Added check for active commission receivers: they must
--                  have an agreement.
--  000523  DEHA    Added public method change_currency.
--  000518  DEHA    Changed attribute of field currency to be updatable.
--  000517  ReSt    Added double salesman, supplier, customer check in Unpack_Check_Update___
--  000509  DEHA    Added exists check for agreement.
--  000502  BjSa    Changed of date_from is fetched in Get_Period_Date_Until
--  000427  DEHA    Removed the public method new.
--  000418  BRO     Added new method get_period_date_from and get_period_date_until
--  000417  ReSt    Added new method get_current_period_date_from and get_current_period_date_until.
--  000412  DEHA    Added new method Check_Exist.
--  000411  BjSa    Added New method
--  000411  ThIs    Added FUNCTION Get_Com_Receiver_For_Salesman
--  000410  DEHA    Recreated based on the model changes from 10/04/2000.
--  000406  BRO     Created
--  000406  DEHA    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CALCULATION_PERIOD', Calculation_Period_API.Decode('MONTH'), attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     commission_receiver_tab%ROWTYPE,
   newrec_ IN OUT commission_receiver_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;



@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT commission_receiver_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_ NUMBER;

  CURSOR check_salesman IS
     SELECT 1
     FROM COMMISSION_RECEIVER_TAB
     WHERE salesman_code = newrec_.salesman_code;

  CURSOR check_customer IS
     SELECT 1
     FROM COMMISSION_RECEIVER_TAB
     WHERE customer_no = newrec_.customer_no;

  CURSOR check_vendor IS
     SELECT 1
     FROM COMMISSION_RECEIVER_TAB
     WHERE vendor_no = newrec_.vendor_no;
BEGIN
   super(newrec_, indrec_, attr_);

   IF (newrec_.salesman_code IS NOT NULL) THEN
      OPEN check_salesman;
      FETCH check_salesman INTO dummy_;
      IF check_salesman%FOUND THEN
          CLOSE check_salesman;
          Error_SYS.Record_General(lu_name_, 'ONLY_ONE_SALESMAN: Salesperson :P1 is already defined as a commission receiver', newrec_.salesman_code);
      END IF;
      CLOSE check_salesman;

      IF (newrec_.vendor_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
      IF (newrec_.customer_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
   END IF;
   IF (newrec_.customer_no IS NOT NULL) THEN
      OPEN check_customer;
      FETCH check_customer INTO dummy_;
      IF check_customer%FOUND THEN
          CLOSE check_customer;
          Error_SYS.Record_General(lu_name_, 'ONLY_ONE_CUSTOMER: Customer :P1 is already defined as a commission receiver', newrec_.customer_no);
      END IF;
      CLOSE check_customer;

      IF (newrec_.salesman_code IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
      IF (newrec_.vendor_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
   END IF;
   IF (newrec_.vendor_no IS NOT NULL) THEN
      OPEN check_vendor;
      FETCH check_vendor INTO dummy_;
      IF check_vendor%FOUND THEN
          CLOSE check_vendor;
          Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VENDOR: Supplier :P1 is already defined as a commission receiver', newrec_.vendor_no);
      END IF;
      CLOSE check_vendor;

      IF (newrec_.salesman_code IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
      IF (newrec_.customer_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
   END IF;

   -- check exist of agreement
   IF (newrec_.agreement_id IS NOT NULL) THEN
      Commission_Agree_API.Check_Agreement_Exists(newrec_.agreement_id);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     commission_receiver_tab%ROWTYPE,
   newrec_ IN OUT commission_receiver_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_ NUMBER;

   CURSOR check_salesman IS
     SELECT 1
     FROM COMMISSION_RECEIVER_TAB
     WHERE salesman_code = newrec_.salesman_code
     AND commission_receiver != newrec_.commission_receiver;

   CURSOR check_customer IS
     SELECT 1
     FROM COMMISSION_RECEIVER_TAB
     WHERE customer_no = newrec_.customer_no
     AND commission_receiver != newrec_.commission_receiver;

   CURSOR check_vendor IS
     SELECT 1
     FROM COMMISSION_RECEIVER_TAB
     WHERE vendor_no = newrec_.vendor_no
     AND commission_receiver != newrec_.commission_receiver;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.salesman_code IS NOT NULL) THEN
      OPEN check_salesman;
      FETCH check_salesman INTO dummy_;
      IF check_salesman%FOUND THEN
          CLOSE check_salesman;
          Error_SYS.Record_General(lu_name_, 'ONLY_ONE_SALESMAN: Salesperson :P1 is already defined as a commission receiver', newrec_.salesman_code);
      END IF;
      CLOSE check_salesman;

      IF (newrec_.vendor_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
      IF (newrec_.customer_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
   END IF;
   IF (newrec_.customer_no IS NOT NULL) THEN
      OPEN check_customer;
      FETCH check_customer INTO dummy_;
      IF check_customer%FOUND THEN
          CLOSE check_customer;
          Error_SYS.Record_General(lu_name_, 'ONLY_ONE_CUSTOMER: Customer :P1 is already defined as a commission receiver', newrec_.customer_no);
      END IF;
      CLOSE check_customer;

      IF (newrec_.salesman_code IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
      IF (newrec_.vendor_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
   END IF;
   IF (newrec_.vendor_no IS NOT NULL) THEN
      OPEN check_vendor;
      FETCH check_vendor INTO dummy_;
      IF check_vendor%FOUND THEN
          CLOSE check_vendor;
          Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VENDOR: Supplier :P1 is already defined as a commission receiver', newrec_.vendor_no);
      END IF;
      CLOSE check_vendor;

      IF (newrec_.salesman_code IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
      IF (newrec_.customer_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ONLY_ONE_VALUE: Only one of the values salesperson, customer or supplier can be inserted');
      END IF;
   END IF;

   -- check exist of agreement
   IF (newrec_.agreement_id IS NOT NULL) THEN
      Commission_Agree_API.Check_Agreement_Exists(newrec_.agreement_id);
   END IF;

END Check_Update___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT commission_receiver_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, objversion_, newrec_, attr_);
   -- active commission receiver's should have an agreement
   IF (newrec_.rowstate = 'Active') THEN
      IF (newrec_.agreement_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'WITHOUT_AGREE: An active commission receiver must have an agreement.');
      END IF;
   END IF;
   --Add post-processing code here
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     commission_receiver_tab%ROWTYPE,
   newrec_     IN OUT commission_receiver_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   --Add post-processing code here
   
   -- active commission receiver's should have an agreement
   IF (newrec_.rowstate = 'Active') THEN
      IF (newrec_.agreement_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'WITHOUT_AGREE: An active commission receiver must have an agreement.');
      END IF;
   END IF;
END Update___;




   
   
   ---- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Public Method for checking if commisson receiver exists.
FUNCTION Check_Exist (
   commission_receiver_ IN VARCHAR2) RETURN BOOLEAN
IS
   found_  NUMBER;

   CURSOR get_attr IS
      SELECT 1
      FROM COMMISSION_RECEIVER_TAB
      WHERE commission_receiver = commission_receiver_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO found_;
   IF (get_attr%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_attr;
   RETURN (found_ = 1);
END Check_Exist;


-- Get_Com_Receiver_For_Salesman
--   Public Method for getting a commission receiver from a corresponding salesman;
--   if a commission receiver exists, when it will be returned.
@UncheckedAccess
FUNCTION Get_Com_Receiver_For_Salesman (
   salesman_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ COMMISSION_RECEIVER_TAB.commission_receiver%TYPE;
   CURSOR get_attr IS
      SELECT commission_receiver
      FROM COMMISSION_RECEIVER_TAB
      WHERE salesman_code = salesman_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Com_Receiver_For_Salesman;


@UncheckedAccess
FUNCTION Get_Current_Period_Date_From(
   commission_receiver_ IN VARCHAR2) RETURN DATE
IS
BEGIN
   RETURN Get_Period_Date_From(commission_receiver_, SYSDATE);
END Get_Current_Period_Date_From;


@UncheckedAccess
FUNCTION Get_Current_Period_Date_Until(
   commission_receiver_ IN VARCHAR2) RETURN DATE
IS
BEGIN
   RETURN Get_Period_Date_Until(commission_receiver_, SYSDATE);
END Get_Current_Period_Date_Until;


@UncheckedAccess
FUNCTION Get_Period_Date_From(
   commission_receiver_ IN VARCHAR2,
   date_                IN DATE) RETURN DATE
IS
   quarter_     NUMBER;
   date_from_   DATE;
   calc_period_ COMMISSION_RECEIVER_TAB.calculation_period%TYPE;
BEGIN
   calc_period_ := Calculation_Period_API.Encode(Commission_Receiver_API.Get_Calculation_Period(commission_receiver_));
   IF (calc_period_ = 'MONTH') THEN
      date_from_ := to_date('01' || to_char(date_, 'MMYYYY'), 'DDMMYYYY');
   ELSIF (calc_period_ = 'QUARTER') THEN
      Quarter_ := to_number(to_char(date_, 'Q'));
      IF (quarter_ = 1) THEN
         date_from_ := to_date('0101' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      ELSIF (quarter_ = 2) THEN
         date_from_ := to_date('0104' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      ELSIF (quarter_ = 3) THEN
         date_from_ := to_date('0107' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      ELSIF (quarter_ = 4) THEN
         date_from_ := to_date('0110' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      END IF;
   ELSIF (calc_period_ = 'HALF_YEAR') THEN
      quarter_ := to_number(to_char(date_, 'Q'));
      IF ((quarter_ = 1) OR (quarter_ = 2)) THEN
         date_from_ := to_date('0101' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      ELSIF ((quarter_ = 3) OR (quarter_ = 4)) THEN
         date_from_ := to_date('0107' || to_char(date_, 'YYYY'), 'DDMMYYYY');
      END IF;
   ELSIF (calc_period_ = 'YEAR') THEN
      date_from_ := to_date('0101' || to_char(date_, 'YYYY'), 'DDMMYYYY');
   END IF;
   RETURN date_from_;
END Get_Period_Date_From;


@UncheckedAccess
FUNCTION Get_Period_Date_Until(
   commission_receiver_ IN VARCHAR2,
   date_                IN DATE) RETURN DATE
IS
   date_from_   DATE;
   date_until_  DATE;
   calc_period_ COMMISSION_RECEIVER_TAB.calculation_period%TYPE;
BEGIN
   calc_period_ := Calculation_Period_API.Encode(Commission_Receiver_API.Get_Calculation_Period(commission_receiver_));
   date_from_ := Get_Period_Date_From(commission_receiver_, date_);
   IF (calc_period_ = 'MONTH') THEN
      date_until_ := add_months(date_from_, 1) - 1;
   ELSIF (calc_period_ = 'QUARTER') THEN
      date_until_ := add_months(date_from_, 3) - 1;
   ELSIF (calc_period_ = 'HALF_YEAR') THEN
      date_until_ := add_months(date_from_, 6) - 1;
   ELSIF (calc_period_ = 'YEAR') THEN
      date_until_ := add_months(date_from_, 12) - 1;
   END IF;
   RETURN date_until_;
END Get_Period_Date_Until;


-- Change_Currency
--   Public method which updates the currency for  a given
--   commission receiver.
PROCEDURE Change_Currency (
   commission_receiver_ IN VARCHAR2,
   currency_code_       IN VARCHAR2 )
IS
   oldrec_           COMMISSION_RECEIVER_TAB%ROWTYPE;
   newrec_           COMMISSION_RECEIVER_TAB%ROWTYPE;
   objversion_       VARCHAR2(2000);
   attr_             VARCHAR2(2000);
BEGIN
   --check if currency code is valid and save the new currency code
   Iso_Currency_API.Exist(currency_code_);
   Client_SYS.Clear_Attr(attr_);
   oldrec_ := Lock_By_Keys___(commission_receiver_);
   newrec_ := oldrec_;
   newrec_.currency_code := currency_code_;
   Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
END Change_Currency;

