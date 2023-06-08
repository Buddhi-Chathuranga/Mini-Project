-----------------------------------------------------------------------------
--
--  Logical unit: RebateFinalAggHead
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170119  NiDalk   STRSC-3939, Removed use price including tax from rebate functionality.
--  131105  RoJalk   Modified date_created to be non-updatable.
--  130213  ShKolk   Added column use_price_incl_tax.
--  090403  ChJalk   Bug 81243, Modified the method Unpack_Check_Update___ to raise the error message INV_ID_NOT_NULL.
--  080611  JeLise   Moved call to Get_Aggregation_No___ from New to Insert___.
--  080611  JeLise   Changed from calling Modify___ to calling Unpack_Check_Update___ and Update___ in Set_Invoice_Id.
--  080529  JeLise   Added methods Get_Invoice_Id and Set_Invoice_Id.
--  080502  AmPalk   Added Get_Total_Rebate_Amt.
--  080415  JeLise   Added date_created and do_not_invoice.
--  080409  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Aggregation_No___ RETURN NUMBER
IS
   aggregation_no_   NUMBER;
   CURSOR get_aggregation_no IS
      SELECT Rebate_Final_Agg_No_Seq.NEXTVAL
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
   newrec_     IN OUT REBATE_FINAL_AGG_HEAD_TAB%ROWTYPE,
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


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     rebate_final_agg_head_tab%ROWTYPE,
   newrec_ IN OUT rebate_final_agg_head_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_    VARCHAR2(30);
   value_   VARCHAR2(2000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (oldrec_.do_not_invoice != newrec_.do_not_invoice) THEN
      IF newrec_.invoice_id IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'INV_ID_NOT_NULL: The Settlement has already been Invoiced.');
      END IF;
   END IF;
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


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
      FROM REBATE_FINAL_AGG_HEAD_TAB
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
   objid_      REBATE_FINAL_AGG_HEAD.objid%TYPE;
   objversion_ REBATE_FINAL_AGG_HEAD.objversion%TYPE;
   newrec_     REBATE_FINAL_AGG_HEAD_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_no_, attr_);
   Client_SYS.Add_To_Attr('AGREEMENT_ID', agreement_id_, attr_);
   Client_SYS.Add_To_Attr('HIERARCHY_ID', hierarchy_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL', customer_level_, attr_);
   Client_SYS.Add_To_Attr('FROM_DATE', from_date_, attr_);
   Client_SYS.Add_To_Attr('TO_DATE', to_date_, attr_);
   Client_SYS.Add_To_Attr('DO_NOT_INVOICE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DATE_CREATED', trunc(SYSDATE), attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___( objid_, objversion_, newrec_, attr_ );
   aggregation_no_ := newrec_.aggregation_no;
END New;


PROCEDURE Set_Invoice_Id (
   aggregation_no_ IN NUMBER,
   invoice_id_     IN NUMBER )
IS
   oldrec_        REBATE_FINAL_AGG_HEAD_TAB%ROWTYPE;
   newrec_        REBATE_FINAL_AGG_HEAD_TAB%ROWTYPE;
   objid_         REBATE_FINAL_AGG_HEAD.objid%TYPE;
   objversion_    REBATE_FINAL_AGG_HEAD.objversion%TYPE;
   attr_          VARCHAR2(2000);
   indrec_   Indicator_Rec;
BEGIN
   -- Check to see if invoice_id exists
   IF (invoice_id_ IS NOT NULL) THEN
      Invoice_API.Exist(Get_Company(aggregation_no_), invoice_id_);
   END IF;
   
   oldrec_ := Lock_By_Keys___(aggregation_no_);
   newrec_ := oldrec_;
   Get_Id_Version_By_Keys___ (objid_, objversion_, aggregation_no_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Invoice_Id;


@UncheckedAccess
FUNCTION Get_Total_Rebate_Amt (
   aggregation_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ REBATE_FINAL_AGG_LINE_TAB.final_rebate_amount%TYPE;
   CURSOR get_attr IS
      SELECT SUM(final_rebate_amount)
      FROM REBATE_FINAL_AGG_LINE_TAB
      WHERE aggregation_no = aggregation_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Total_Rebate_Amt;



