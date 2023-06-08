-----------------------------------------------------------------------------
--
--  Logical unit: StagedBillingTemplate
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210127  RavDlk, SC2020R1-12349, Removed unnecessary packing and unpacking of attrubute string from Copy_Template
--  171124  MaEelk STRSC-14333, Created Copy_Template to copy a Staged Billing Template from an existing order to a new order.
--  131028  MaMalk Reduced description length to VARCHAR2(35).
--  100513  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  061127  Cpeilk Modified error message for stage billing when prepayments exists in Unpack_Check_Insert___.
--  061025  Cpeilk Modified Unpack_Check_Insert___ to restrict stage billing when prepayments exists.
--  050324  JoEd   Added check on order header's delivery confirmation setting.
--                 Not allowed to use template if Confirm Deliveries = true.
--  030709  ChFolk Reversed the changes that have been done for Advance Payment.
--  030226  SuAmlk Code Review.
--  000124  PaLj   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT STAGED_BILLING_TEMPLATE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   attr2_      VARCHAR2(2000) := NULL;
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('STAGED_BILLING_DB', 'STAGED BILLING', attr2_);
   Customer_Order_API.Modify(info_, attr2_, newrec_.order_no);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN STAGED_BILLING_TEMPLATE_TAB%ROWTYPE )
IS
   number_of_rows_ NUMBER;
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(2000) := NULL;

   CURSOR empty IS
      SELECT count(*)
      FROM  STAGED_BILLING_TEMPLATE_TAB
      WHERE order_no = remrec_.order_no;
BEGIN
   super(objid_, remrec_);
   OPEN empty;
   FETCH empty INTO number_of_rows_;
   CLOSE empty;

   IF (number_of_rows_ = 0) THEN
      Client_SYS.Add_To_Attr('STAGED_BILLING_DB', 'NOT STAGED BILLING', attr_);
      Customer_Order_API.Modify(info_, attr_, remrec_.order_no);
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT staged_billing_template_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (Customer_Order_API.Get_Confirm_Deliveries_Db(newrec_.order_no) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'NO_NEW_STAGES: No changes may be made when the order uses Delivery Confirmation.');
   END IF;

   -- Check for prepayment exists before stage billing is entered for a Customer Order.
   IF (Customer_Order_API.Get_Proposed_Prepayment_Amount(newrec_.order_no) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_EXIST: The Required Prepayment amount exists. Cannot enter staged billing template for this customer order.');
   END IF;

   IF (newrec_.stage IS NULL) THEN
      newrec_.stage := Get_Next_stage(newrec_.order_no);   
   END IF;
   
   super(newrec_, indrec_, attr_); 
   
   Client_SYS.Add_To_Attr('STAGE', newrec_.stage, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Summed_Percent__
--   Summation of the total percentage for a particular order.
@UncheckedAccess
FUNCTION Get_Summed_Percent__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR sum_percent IS
      SELECT SUM(total_percentage) FROM STAGED_BILLING_TEMPLATE_TAB
      WHERE order_no   = order_no_;
BEGIN
   OPEN sum_percent;
   FETCH sum_percent INTO temp_;
   CLOSE sum_percent;
   RETURN temp_;
END Get_Summed_Percent__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Next_Stage
--   This is used to get the next stage no for the particular template.
@UncheckedAccess
FUNCTION Get_Next_Stage (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ STAGED_BILLING_TEMPLATE_TAB.stage%TYPE;
   CURSOR get_stage IS
      SELECT NVL(MAX(stage), 0)
      FROM STAGED_BILLING_TEMPLATE_TAB
      WHERE order_no = order_no_;
BEGIN
   OPEN get_stage;
   FETCH get_stage INTO temp_;
   CLOSE get_stage;
   temp_ := temp_ + 1;
   RETURN temp_;
END Get_Next_Stage;

PROCEDURE Copy_Template (
   from_order_no_ IN VARCHAR2,
   to_order_no_   IN VARCHAR2)
IS
   CURSOR get_template IS
   SELECT *
   FROM staged_billing_template_tab
   WHERE order_no = from_order_no_; 
   
   newrec_           STAGED_BILLING_TEMPLATE_TAB%ROWTYPE;
BEGIN
   FOR stagerec_ IN get_template LOOP
      newrec_.order_no         := to_order_no_;
      newrec_.stage            := stagerec_.stage;
      newrec_.description      := stagerec_.description;
      newrec_.total_percentage := stagerec_.total_percentage;
      New___(newrec_);
   END LOOP;   
END Copy_Template;   
