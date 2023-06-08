-----------------------------------------------------------------------------
--
--  Logical unit: CustPartAcqValueHist
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210118  MaEelk SC2020R1-12154, Modified New_Cust_Part_Acq_Value_Hist__. Replced the parameter attr_ with 
--  210118         acquisition_value_, currency_code_, cust_part_acq_value_source_db_ and note_text_. Repaced the calls to 
--  210118         Unpack___, Check_Insert___ and Insert___ with New___
--  100519  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060410  IsWilk Enlarge Identity - Changed view comments of customer_no.
------------------------------------- 13.4.0 ---------------------------------
--  060110  CsAmlk Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  040219  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
------------------------------------- 13.3.0 ---------------------------------
--  030430  SaNalk Changed private method Get_Next_History_No__ to Implementation method.
--  030424  SaNalk Changed the place for History_No check in PROCEDURE Unpack_Check_Insert___.
--  030423  SaNalk Modified the description comments of new methods.
--  030422  SaNalk Added Procedures New_Cust_Part_Acq_Value_Hist__ & Get_Next_History_No__.
--                 Added Identity, Date_Changed and History_No in Procedure Unpack_Check_Insert___
--  030421  SaNalk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_History_No___
--   This is used to get the next history no for a given part having a particular
--   customer no and a lot batch no and a particular serial no.
FUNCTION Get_Next_History_No___ (
   customer_no_ IN VARCHAR2,
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   hist_no_   NUMBER;

   CURSOR get_hist_no IS
      SELECT MAX(history_no)
      FROM CUST_PART_ACQ_VALUE_HIST_TAB
      WHERE customer_no = customer_no_
      AND part_no = part_no_
      AND serial_no = serial_no_
      AND lot_batch_no = lot_batch_no_;
BEGIN
   OPEN get_hist_no;
   FETCH get_hist_no INTO hist_no_;
   hist_no_ := nvl(hist_no_,0) + 1;
   CLOSE get_hist_no;
   RETURN hist_no_;

END Get_Next_History_No___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_PART_ACQ_VALUE_HIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.history_no IS NULL) THEN
      newrec_.history_no := Get_Next_History_No___(newrec_.customer_no,newrec_.part_no,newrec_.serial_no,newrec_.lot_batch_no);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'HISTORY_NO', newrec_.history_no);
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_part_acq_value_hist_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.identity := Fnd_Session_API.Get_Fnd_User;
   newrec_.date_changed := SYSDATE;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- New_Cust_Part_Acq_Value_Hist__
--   This is used to enter a new history record to the Customer Part Acquisition
--   Value History.
PROCEDURE New_Cust_Part_Acq_Value_Hist__ (
   customer_no_                   IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   serial_no_                     IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2,
   acquisition_value_             IN NUMBER,
   currency_code_                 IN VARCHAR2,
   cust_part_acq_value_source_db_ IN VARCHAR2,
   note_text_                     IN VARCHAR2 )
IS
   newrec_     CUST_PART_ACQ_VALUE_HIST_TAB%ROWTYPE;
BEGIN
   
   newrec_.customer_no := customer_no_;
   newrec_.part_no := part_no_;
   newrec_.serial_no := serial_no_;
   newrec_.lot_batch_no := lot_batch_no_;
   newrec_.acquisition_value := acquisition_value_;
   newrec_.currency_code := currency_code_;
   newrec_.cust_part_acq_value_source := cust_part_acq_value_source_db_;
   newrec_.note_text := note_text_;
   New___(newrec_);
END New_Cust_Part_Acq_Value_Hist__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


