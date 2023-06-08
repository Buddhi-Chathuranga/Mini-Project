-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderInvoiceHist
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210126  RavDlk  SC2020R1-12282, Removed unnecessary packing and unpacking of attrubute string in New
--  131128  MalLlk   Added Remove method to delete if CustOrderInvoiceHist records records exist for CO Invoice Head.
--  --------------------------- APPS 9 -----------------------------------------
--  120328  MaMalk   Modified procedure New to create the history record with the client value of the status.
--  100720  SaJjlk   Bug 92001, Increased length of column MESSAGE_TEXT in view CUST_ORDER_INVOICE_HIST.
--  100519  KRPELK   Merge Rose Method Documentation.
--  080422  RiLase   Added check in New. If invoice type is rebate credit invoice then site/contract isn't
--                   available for fetching date_entered in New. Sysdate is used instead.
--  --------- Nice Price ----------------------------------------------------
--  060817  MiKulk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_INVOICE_HIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.history_no := CUST_ORDER_INVOICE_HIST_API.Get_History_No__(newrec_.company, newrec_.invoice_id);
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('HISTORY_NO', newrec_.history_no, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Get_History_No__ (
   company_ IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   history_no_ NUMBER;
   CURSOR get_history_no IS
      SELECT max(history_no)
      FROM   cust_order_invoice_hist_tab
      WHERE  company = company_
      AND    invoice_id = invoice_id_;
BEGIN
   OPEN get_history_no;
   FETCH get_history_no INTO history_no_;
   IF history_no_ IS NULL THEN
      history_no_ := 1;
   ELSE
      history_no_ := history_no_ +1;
   END IF;
   CLOSE get_history_no;

   RETURN history_no_;
END Get_History_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   This public method is used to create a new entry in the history tab
PROCEDURE New (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   message_text_ IN VARCHAR2 )
IS
   newrec_     CUST_ORDER_INVOICE_HIST_TAB%ROWTYPE;
   inv_rec_    Customer_Order_Inv_Head_API.Public_Rec;
BEGIN
   inv_rec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);

   newrec_.company := company_;
   newrec_.invoice_id := invoice_id_;

   -- IF it is a rebate credit invoice then site/contract isn't available.
   IF (Invoice_API.Get_Invoice_Type(company_, invoice_id_) = Company_Def_Invoice_Type_API.Get_Co_Rebate_Cre_Inv_Type(company_)) THEN
      newrec_.date_entered := SYSDATE;
   ELSE
      newrec_.date_entered := Site_API.Get_Site_Date(inv_rec_.contract);
   END IF;
   newrec_.user_id := Fnd_Session_API.Get_Fnd_User;
   IF message_text_ IS NULL THEN
      newrec_.message_text := Invoice_API.Get_Inv_State(company_, invoice_id_);
   ELSE
      newrec_.message_text := message_text_;
   END IF;
   New___(newrec_);
END New;


-- Remove
--   Delete if CustOrderInvoiceHist records exist for CO Invoice Head.
--   Used for cascade delete when removing a Invoice (INVOIC module).
PROCEDURE Remove (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(2000);
   
   CURSOR get_hist_nos IS
      SELECT history_no
      FROM   cust_order_invoice_hist_tab
      WHERE  company    = company_
      AND    invoice_id = invoice_id_;
BEGIN
   FOR invoice_hist_nos_ IN get_hist_nos LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, company_, invoice_id_, invoice_hist_nos_.history_no);
      Remove__(info_, objid_, objversion_, 'DO');
   END LOOP;   
END Remove;



