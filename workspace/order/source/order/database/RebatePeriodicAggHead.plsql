-----------------------------------------------------------------------------
--
--  Logical unit: RebatePeriodicAggHead
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210127  RavDlk   SC2020R1-12347, Removed unnecessary packing and unpacking of attrubute string in New and Set_Invoice_Id
--  170119  NiDalk   STRSC-3939, Removed use price including tax from rebate functionality.
--  131031  RoJalk   Modified the properties of date_created in the base view to align with the model and changed to non updatable.
--  130212  ShKolk   Added column use_price_incl_tax.
--  090813  HimRlk   Merged Bug 84103, Removed the error message INV_ID_NOT_NULL.
--  080623  AmPalk   Added Get_Total_Rebate_Cost_Amt.
--  080611  JeLise   Moved call to Get_Aggregation_No___ from New to Insert___.
--  080611  JeLise   Changed from calling Modify___ to calling Unpack_Check_Update___ and Update___ in Set_Invoice_Id.
--  080529  JeLise   Added method Set_Invoice_Id and Get methods.
--  080507  JeLise   Added check on newrec_.invoice_id when updating newrec_.do_not_invoice in Unpack_Check_Update___.
--  080502  AmPalk   Added Get_Total_Rebate_Amt.
--  080422  RiLase   Made date_created public.
--  080417  RiLase   Added method Set_Invoice_Id.
--  080415  JeLise   Added date_created.
--  080415  JeLise   Added DO_NOT_INVOICE_DB to attr_ in New.
--  080407  RiLase   Added "Do not invoice".
--  080403  JeLise   Added Get_Invoiced.
--  080327  JeLise   Removed currency_code.
--  080326  JeLise   Changed invoiced to invoice_id.
--  080228  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Aggregation_No___ RETURN NUMBER
IS
   aggregation_no_   NUMBER;
   CURSOR get_aggregation_no IS
      SELECT Rebate_Period_Agg_No_Seq.NEXTVAL
      FROM dual;
BEGIN
   OPEN get_aggregation_no;
   FETCH get_aggregation_no INTO aggregation_no_;
   CLOSE get_aggregation_no;
   RETURN aggregation_no_;
END Get_Aggregation_No___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REBATE_PERIODIC_AGG_HEAD_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.aggregation_no := Get_Aggregation_No___;
   Client_SYS.Add_To_Attr('AGGREGATION_NO', newrec_.aggregation_no, attr_);
   newrec_.date_created := trunc(sysdate);
   Client_SYS.Add_To_Attr('DATE_CREATED', newrec_.date_created, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Invoiced (
   aggregation_no_ IN NUMBER ) RETURN VARCHAR2
IS
   invoiced_   NUMBER;
   CURSOR get_invoiced IS
      SELECT invoice_id
      FROM REBATE_PERIODIC_AGG_HEAD_TAB
      WHERE aggregation_no = aggregation_no_;
BEGIN
   OPEN get_invoiced;
   FETCH get_invoiced INTO invoiced_;
   CLOSE get_invoiced;
   IF invoiced_ IS NULL THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Get_Invoiced;


PROCEDURE New (
   aggregation_no_     IN OUT NUMBER,
   company_            IN     VARCHAR2,
   customer_no_        IN     VARCHAR2,
   agreement_id_       IN     VARCHAR2,
   hierarchy_id_       IN     VARCHAR2,
   customer_level_     IN     NUMBER,
   from_date_          IN     DATE,
   to_date_            IN     DATE )
IS
   newrec_     REBATE_PERIODIC_AGG_HEAD_TAB%ROWTYPE;
BEGIN
   newrec_.company        := company_;
   newrec_.customer_no    := customer_no_;
   newrec_.agreement_id   := agreement_id_;
   newrec_.hierarchy_id   := hierarchy_id_;
   newrec_.customer_level := customer_level_;
   newrec_.from_date      := from_date_;
   newrec_.to_date        := to_date_;
   newrec_.do_not_invoice := 'FALSE';
   newrec_.date_created   := trunc(SYSDATE);
   New___(newrec_);
   aggregation_no_ := newrec_.aggregation_no;
END New;


PROCEDURE Set_Invoice_Id (
   aggregation_no_ IN NUMBER,
   invoice_id_     IN NUMBER )
IS
   newrec_         REBATE_PERIODIC_AGG_HEAD_TAB%ROWTYPE;
BEGIN
   -- Check to see if invoice_id exists
   IF (invoice_id_ IS NOT NULL) THEN
      Invoice_API.Exist(Get_Company(aggregation_no_), invoice_id_);
   END IF;   
   newrec_ := Lock_By_Keys___(aggregation_no_);
   newrec_.invoice_id := invoice_id_;
   Modify___(newrec_);
END Set_Invoice_Id;


@UncheckedAccess
FUNCTION Get_Total_Rebate_Amt (
   aggregation_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ REBATE_PERIODIC_AGG_LINE_TAB.total_rebate_amount%TYPE;
   CURSOR get_attr IS
      SELECT SUM(total_rebate_amount)
      FROM REBATE_PERIODIC_AGG_LINE_TAB
      WHERE aggregation_no = aggregation_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Total_Rebate_Amt;


-- Get_Total_Rebate_Cost_Amt
--   Returns total rebate_cost amount of lines.
@UncheckedAccess
FUNCTION Get_Total_Rebate_Cost_Amt (
   aggregation_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ REBATE_PERIODIC_AGG_LINE_TAB.total_rebate_cost_amount%TYPE;
   CURSOR get_attr IS
      SELECT SUM(total_rebate_cost_amount)
      FROM REBATE_PERIODIC_AGG_LINE_TAB
      WHERE aggregation_no = aggregation_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Total_Rebate_Cost_Amt;



