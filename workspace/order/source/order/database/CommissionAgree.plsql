-----------------------------------------------------------------------------
--
--  Logical unit: CommissionAgree
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130703  MaIklk TIBE-951, Removed last_calendar_date_ global constant and declaration is moved to relevant procedures.
--  110909  JeLise Made a smaller change in the error message OPENED_DATE_UNTIL in Copy_Agreement.
--  100512  Ajpelk Merge rose method documentation
--  090129  SaJjlk Bug 79846, Removed the length declaration for NUMBER type variable check_agree_in_receiver_ in method Check_Delete___. 
--  060807  MaMalk Replaced some of the instances of TO_DATE function with global constant last_calendar_date_.
------------------------------------------------13.4.0-----------------------
--  060112  SuJalk Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  041122  MaGuse  Bug 46197, modified commission_calc_base to not updateable.
--  041122          Added checks to prevent different calculation basis on same agreement_id,
--  041122          added method Validate_Calc_Basis___, modified method Unpack_Check_Insert___ and
--  041122          added method Get_Comm_Calc_Base_Db
--  040218  IsWilk Removed SUBSTRB from the view for Unicode Changes.
------------------------------------------------13.3.0-----------------------
--  010104  JoAn  CID 54474 Truncated dates before comparision in Get_Agree_Version
--  000710  JakH  Merged from Chameleon
--  000524  DEHA  Changed fields calculation_base and currency_code to be
--                updatable.
--  000524  BRO   Modified copy_agreement in order to get the new created revision_no
--  000523  BRO   Added test on valid dates: from should be smaller than until date
--  000523  DEHA  Added check during deleting an agreement (it's forbidden
--                if a commission receiver is associated).
--  000517  BRO   Added method copy_agreement
--  000509  DEHA  Added fields note_id, note_text;
--                added method check_agreement_exists.
--  000420  BRO   Added default values for agreement date and calc base
--  000413  BRO   Added COMMISSION_AGREE_LOV
--  000412  BRO   Implemented GetAgreeVersion
--  000412  DEHA  Added public method GetAgreeVersion.
--  000410  DEHA  Changed field name agreement_version to revision_no.
--  000410  BRO   Added Get_Next_Agreement_Version___ and Validate_Date_Range___
--  000405  BRO   Created
--  000405  DEHA  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_Revision_No___
--   Implementation method to get the next revision no for the
--   same agreement id.
FUNCTION Get_Next_Revision_No___ (
   agreement_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   last_version_ NUMBER;

   CURSOR get_last_version IS
      SELECT NVL(MAX(revision_no), 0)
      FROM   COMMISSION_AGREE_TAB
      WHERE  agreement_id = agreement_id_;
BEGIN
   OPEN get_last_version;
   FETCH get_last_version INTO last_version_;
   CLOSE get_last_version;
   RETURN last_version_ + 1;
END Get_Next_Revision_No___;


-- Validate_Date_Range___
--   Implementation method for validating the date interval for a
--   new inserted/ changed agreement (version).
PROCEDURE Validate_Date_Range___ (
   agreement_id_        IN VARCHAR2,
   revision_no_         IN NUMBER,
   date_from_           IN DATE,
   date_until_          IN DATE )
IS
   dummy_              NUMBER;
   max_date_           DATE;   

   CURSOR test1(date_ DATE) IS
      SELECT 1
      FROM   COMMISSION_AGREE_TAB
      WHERE  agreement_id = agreement_id_
        AND  revision_no <> revision_no_
        AND  valid_from <= date_
        AND  NVL(valid_until, max_date_) >= date_;

   CURSOR test2(date_from_ DATE, date_until_ DATE) IS
      SELECT 1
      FROM   COMMISSION_AGREE_TAB
      WHERE  agreement_id = agreement_id_
        AND  revision_no <> revision_no_
        AND  valid_from < date_until_
        AND  valid_from > date_from_;

   overlapping_range    EXCEPTION;
   from_until_mismatch  EXCEPTION;
BEGIN
   max_date_ := Database_Sys.last_calendar_date_;

   -- test if the valid dates are in the right order
   IF (date_from_ > date_until_) THEN
      RAISE from_until_mismatch;
   END IF;

   -- test if the date_from_ is in an existing interval
   OPEN test1(date_from_);
   FETCH test1 INTO dummy_;
   IF test1%FOUND THEN
      CLOSE test1;
      RAISE overlapping_range;
   END IF;
   CLOSE test1;

   -- test if the date_until_ is in an existing interval
   OPEN test1(NVL(date_until_, max_date_));
   FETCH test1 INTO dummy_;
   IF test1%FOUND THEN
      CLOSE test1;
      RAISE overlapping_range;
   END IF;
   CLOSE test1;

   -- test if an existing interval (reduceable now to a single date) is in the new interval
   OPEN test2(date_from_, NVL(date_until_, max_date_));
   FETCH test2 INTO dummy_;
   IF test2%FOUND THEN
      CLOSE test2;
      RAISE overlapping_range;
   END IF;
   CLOSE test2;

EXCEPTION
   WHEN overlapping_range THEN
      Error_SYS.Record_General(lu_name_, 'OVERLAPPING_RANGE: Overlapping date interval');
   WHEN from_until_mismatch THEN
      Error_SYS.Record_General(lu_name_, 'FROM_UNTIL_MISMATCH: Valid Until should be greater than Valid From');
END Validate_Date_Range___;


-- Validate_Calc_Base___
--   Implementation method for validating the commission calculation base for a
--   new or updated revision.
--   All revisions with the same Agreement ID must have the same
--   commission calculation base
PROCEDURE Validate_Calc_Base___ (
   agreement_id_         IN VARCHAR2,
   revision_no_          IN NUMBER,
   commission_calc_base_ IN VARCHAR2 )
IS
   temp_ NUMBER;

   CURSOR get_calc_base IS
      SELECT 1
      FROM   COMMISSION_AGREE_TAB
      WHERE  agreement_id = agreement_id_
      AND    revision_no != revision_no_
      AND    commission_calc_base != commission_calc_base_;
BEGIN
   OPEN get_calc_base;
   FETCH get_calc_base INTO temp_;
   IF get_calc_base%FOUND THEN
      CLOSE get_calc_base;
      Error_SYS.Record_General(lu_name_, 'INVALID_CALC_BASE: All revisions for one Agreement ID must have the same Calculation Base.');
   END IF;
   CLOSE get_calc_base;
END Validate_Calc_Base___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_DATE', TRUNC(SYSDATE), attr_);
   Client_SYS.Add_To_Attr('COMMISSION_CALC_BASE', Commission_Calc_Base_API.Decode('ORDER'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN COMMISSION_AGREE_TAB%ROWTYPE )
IS
   CURSOR check_receiver(cur_agree_id_ VARCHAR2) IS
      SELECT 1
        FROM COMMISSION_RECEIVER_TAB
       WHERE agreement_id = cur_agree_id_;

   CURSOR check_multi_revision(cur_agree_id_ VARCHAR2) IS
      SELECT count(*)
        FROM COMMISSION_AGREE_TAB
       WHERE agreement_id = cur_agree_id_;

   check_agree_in_receiver_   NUMBER;
   revision_count_            NUMBER;
BEGIN
   -- otherwise delete is only allowed when no commission reciver is associated
   -- and when there are more than one revision for the agreement
   OPEN check_receiver(remrec_.agreement_id);
   FETCH check_receiver INTO check_agree_in_receiver_;
   IF check_receiver%FOUND THEN
      OPEN check_multi_revision(remrec_.agreement_id);
      FETCH check_multi_revision INTO revision_count_;
      CLOSE check_multi_revision;
      IF (NVL(revision_count_, 0) = 1) THEN
         CLOSE check_receiver;
         Error_SYS.Record_General(lu_name_, 'RECEIVER_USED: Agreement is associated to a commission receiver and therefore cannot be deleted.');
      END IF;
   END IF;
   CLOSE check_receiver;
   -- normal checks
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     commission_agree_tab%ROWTYPE,
   newrec_ IN OUT commission_agree_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Date_Range___(newrec_.agreement_id, newrec_.revision_no, newrec_.valid_from, newrec_.valid_until);
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT commission_agree_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   newrec_.revision_no := Get_Next_Revision_No___(newrec_.agreement_id);
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Add_To_Attr('REVISION_NO', newrec_.revision_no, attr_);   
   Validate_Calc_Base___(newrec_.agreement_id, newrec_.revision_no, newrec_.commission_calc_base);

END Check_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Agree_Version
--   Public Method to get the valid agreement version (revision no)
--   according to a agreement id and a date.
@UncheckedAccess
FUNCTION Get_Agree_Version (
   agreement_id_    IN VARCHAR2,
   order_line_date_ IN DATE ) RETURN NUMBER
IS
   revision_no_        NUMBER;
   max_date_           DATE;   

   CURSOR get_attr IS
      SELECT revision_no
      FROM COMMISSION_AGREE_TAB
      WHERE agreement_id = agreement_id_
      AND   valid_from <= TRUNC(order_line_date_)
      AND   TRUNC(order_line_date_) <= NVL(valid_until, max_date_);
BEGIN
   max_date_ := Database_Sys.last_calendar_date_;
   OPEN get_attr;
   FETCH get_attr INTO revision_no_;
   CLOSE get_attr;
   RETURN revision_no_;
END Get_Agree_Version;


-- Check_Agreement_Exists
--   Public method for validating an agreement.
--   It checks if an agreement id exists regardless of the revision no.
PROCEDURE Check_Agreement_Exists (
   agreement_id_ IN VARCHAR2 )
IS
  dummy_ NUMBER;
  CURSOR exist_control IS
      SELECT 1
      FROM   COMMISSION_AGREE_TAB
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'AGREEEXISTS: Agreement does not exists.');
   END IF;
   CLOSE exist_control;
END Check_Agreement_Exists;


-- Copy_Agreement
--   Public mehtod for copying an agreement with all corresponding agreement lines.
PROCEDURE Copy_Agreement (
   agreement_id_ IN     VARCHAR2,
   revision_no_  IN OUT NUMBER )
IS
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   attr_                   VARCHAR2(2000);

   ag_rec_                 COMMISSION_AGREE_TAB%ROWTYPE;
   fetched_agreement_id_   COMMISSION_AGREE_TAB.AGREEMENT_ID%TYPE;
   fetched_revision_no_    COMMISSION_AGREE_TAB.REVISION_NO%TYPE;
   last_valid_until_       DATE;
   max_valid_from_         DATE;

   CURSOR get_agree IS
      SELECT *
      FROM COMMISSION_AGREE_TAB
      WHERE agreement_id = agreement_id_
      AND   revision_no = revision_no_;

   CURSOR get_max_valid_from IS
      SELECT MAX(valid_from)
      FROM COMMISSION_AGREE_TAB
      WHERE agreement_id = agreement_id_;

   CURSOR get_last_valid_from(max_valid_from_ DATE) IS
      SELECT agreement_id, revision_no
      FROM COMMISSION_AGREE_TAB
      WHERE agreement_id = agreement_id_
      AND   valid_from = max_valid_from_;

   CURSOR get_agree_lines IS
      SELECT *
      FROM COMMISSION_AGREE_LINE_TAB
      WHERE agreement_id = agreement_id_
      AND   revision_no = revision_no_;

   CURSOR get_com_ranges(line_no_ NUMBER) IS
      SELECT *
      FROM COMMISSION_RANGE_TAB
      WHERE agreement_id = agreement_id_
      AND   revision_no = revision_no_
      AND   line_no = line_no_;

BEGIN
   -- create a new agreement
   OPEN get_agree;
   FETCH get_agree INTO ag_rec_;
   IF (get_agree%NOTFOUND) THEN
      CLOSE get_agree;
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
   CLOSE get_agree;

   OPEN get_max_valid_from;
   FETCH get_max_valid_from INTO max_valid_from_;
   IF (get_max_valid_from%NOTFOUND OR max_valid_from_ IS NULL) THEN
      CLOSE get_max_valid_from;
      Error_SYS.Record_General(lu_name_ , 'GET_AGREE: Agreement is missing.' );
   END IF;
   CLOSE get_max_valid_from;

   OPEN get_last_valid_from(max_valid_from_);
   FETCH get_last_valid_from INTO fetched_agreement_id_, fetched_revision_no_;
   last_valid_until_ := COMMISSION_AGREE_API.Get_Valid_Until(fetched_agreement_id_, fetched_revision_no_);
   IF (get_last_valid_from%NOTFOUND OR last_valid_until_ IS NULL) THEN
      CLOSE get_last_valid_from;
      Error_SYS.Record_General(Lu_Name_ , 'OPENED_DATE_UNTIL: Revision no :P1 for this agreement has no valid to date.', fetched_revision_no_ );
   END IF;
   CLOSE get_last_valid_from;

   ag_rec_.revision_no := COMMISSION_AGREE_API.Get_Next_Revision_No___(agreement_id_);
   ag_rec_.valid_from := last_valid_until_ + 1;
   ag_rec_.valid_until := NULL;

   Insert___(objid_, objversion_, ag_rec_, attr_);

   -- create agreement lines
   FOR al_rec_ IN get_agree_lines LOOP
      al_rec_.revision_no := ag_rec_.revision_no;
      Commission_Agree_Line_API.New(al_rec_);
      -- create the agreement ranges
      FOR ar_rec_ IN get_com_ranges(al_rec_.line_no) LOOP
         ar_rec_.revision_no := ag_rec_.revision_no;
         Commission_Range_API.New(ar_rec_);
      END LOOP;
   END LOOP;

   revision_no_ := ag_rec_.revision_no;

END Copy_Agreement;


-- Get_Comm_Calc_Base_Db
--   Method for fetching the commission calculation base for a specific Agreement ID.
@UncheckedAccess
FUNCTION Get_Comm_Calc_Base_Db (
   agreement_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ COMMISSION_AGREE_TAB.commission_calc_base%TYPE;

   CURSOR get_attr IS
      SELECT DISTINCT commission_calc_base
      FROM COMMISSION_AGREE_TAB
      WHERE agreement_id = agreement_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Comm_Calc_Base_Db;



