-----------------------------------------------------------------------------
--
--  Logical unit: CustPrepaymConsumption
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131223  MalLlk   Added Check_Remove method to check if records exist for CO Invoice Item.
--  100519  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  061122  ChBalk   Added new methods Get_Total_Consumed_Amount and Modify.
--  061121  Cpeilk   DIPL606A, Removed method Consumption_Exist.
--  061120  Cpeilk   DIPL606A, Added methods Remove and Consumption_Exist.
--  061116  Cpeilk   DIPL606A, Added method New.
--  061026  Cpeilk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Used to create a new record in the cust prepayment consumption table.
PROCEDURE New (
   attr_    IN VARCHAR2 )
IS
   newrec_     CUST_PREPAYM_CONSUMPTION_TAB%ROWTYPE;
   objid_      ROWID;
   objversion_ VARCHAR2(2000);
   new_attr_   VARCHAR2(32000);
   indrec_     Indicator_Rec;
BEGIN
   new_attr_ := attr_;   
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
END New;


-- Remove
--   Used to delete a record in the cust prepayment consumption table.
PROCEDURE Remove (
   company_                 IN VARCHAR2,
   prepayment_invoice_id_   IN NUMBER,
   prepayment_invoice_item_ IN NUMBER,
   invoice_id_              IN NUMBER,
   item_id_                 IN NUMBER )
IS
   remrec_     CUST_PREPAYM_CONSUMPTION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(company_, prepayment_invoice_id_, prepayment_invoice_item_, invoice_id_, item_id_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, company_, prepayment_invoice_id_, prepayment_invoice_item_, invoice_id_, item_id_);
   Delete___(objid_, remrec_);
END Remove;


-- Get_Total_Consumed_Amount
--   Get the sum of all the consumed amount for a particular prepayment invoice item.
@UncheckedAccess
FUNCTION Get_Total_Consumed_Amount (
   company_                   IN VARCHAR2,
   prepayment_invoice_id_     IN NUMBER,
   prepayment_invoice_item_   IN NUMBER ) RETURN NUMBER
IS
   total_consumed_      NUMBER;

   CURSOR get_sum_consumed IS
      SELECT NVL(SUM(cpc.consumed_amount), 0)
        FROM cust_prepaym_consumption cpc
       WHERE cpc.company = company_
         AND cpc.prepayment_invoice_id = prepayment_invoice_id_
         AND cpc.prepayment_invoice_item = prepayment_invoice_item_;
BEGIN
   OPEN get_sum_consumed;
   FETCH get_sum_consumed INTO total_consumed_;
   CLOSE get_sum_consumed;
   RETURN total_consumed_;
END Get_Total_Consumed_Amount;


-- Modify
--   Used to update a record in the cust prepayment consumption table.
PROCEDURE Modify (
   company_                   IN VARCHAR2,
   prepayment_invoice_id_     IN NUMBER,
   prepayment_invoice_item_   IN NUMBER,
   invoice_id_                IN NUMBER,
   item_id_                   IN NUMBER,
   attr_                      IN OUT VARCHAR2 )
IS
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   oldrec_                 CUST_PREPAYM_CONSUMPTION_TAB%ROWTYPE;
   newrec_                 CUST_PREPAYM_CONSUMPTION_TAB%ROWTYPE;
   indrec_                 Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, company_, prepayment_invoice_id_, prepayment_invoice_item_, invoice_id_, item_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);   
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify;


-- Check_Remove
--   Checks if records exist for CO Invoice Item. If found, print an error message.
--   Used for restricted delete check when removing a Invoice Item (INVOIC module).
PROCEDURE Check_Remove (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER )
IS
   count_ NUMBER := 0;
   
   CURSOR record_exist IS
      SELECT count(*)
      FROM   cust_prepaym_consumption_tab
      WHERE  company    = company_
      AND    ( (invoice_id             = invoice_id_ AND item_id                 = item_id_)
             OR (prepayment_invoice_id = invoice_id_ AND prepayment_invoice_item = item_id_) );
BEGIN
   OPEN record_exist;
   FETCH record_exist INTO count_;
   CLOSE record_exist;
   
   IF (count_ > 0) THEN
      Error_SYS.Record_Constraint('InvoiceItem', Language_SYS.Translate_Lu_Prompt_(lu_name_), to_char(count_));
   END IF;
END Check_Remove;
