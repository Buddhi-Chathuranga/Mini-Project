-----------------------------------------------------------------------------
--
--  Logical unit: CustDeliveryInvRef
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200703  ErFelk  Bug 153702 (SCZ-10445), Modified Get_Total_Cost_Invoice_Item() by replacing delivery_rec_.qty_invoiced with inv_qty_.
--  190511  NiDalk  Bug 146673, Modified Get_Total_Cost_Invoice_Item to use delivery_rec_.qty_invoiced for calculations correctly.
--  190506  WaSalk  Bug 147754(SCZ-4542), Modified condition in Get_Total_Cost_Invoice_Item() to check whether stage billing and if so calculate total cost by delivered quantity.
--  170314  MeAblk  Bug 134044, Modified Get_Total_Cost_Invoice_Item() to correctly get the cost for consignment stock items. 
--  150611  Hecolk  KES-538, Adding ability to cancel preliminary Customer Order Invoice   
--  131223  MalLlk  Added Check_Remove method to check if records exist for CO Invoice Item.
--  120321  Darklk  Bug 99815, Added the function Get_Total_Cost_Invoice_Item.
--  100513  Ajpelk  Merge rose method documentation
--  050512  JoEd    Changed Create_Reference to use standard validations.
--                  Set deliv_no as mandatory.
--  050422  JoEd    Added Check_Exist.
--  030212  AjShlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Reference
--   Creates a reference between a delivery and a invoice item.
PROCEDURE Create_Reference (
   deliv_no_   IN NUMBER,
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER )
IS   
   newrec_      cust_delivery_inv_ref_tab%ROWTYPE;
   indrec_      Indicator_Rec;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   attr_        VARCHAR2(2000);   
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
   Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Reference;


PROCEDURE Remove_Reference (
   deliv_no_   IN NUMBER,
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER )
IS
   info_        VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
BEGIN
   IF Check_Exist___ (deliv_no_,
                      company_,
                      invoice_id_,
                      item_id_) THEN 
      Get_Id_Version_By_Keys___ (objid_,
                                 objversion_,
                                 deliv_no_,
                                 company_,
                                 invoice_id_,
                                 item_id_);   
      Remove__ (info_,
                objid_,
                objversion_,
                'DO');
   END IF;             
END Remove_Reference;


-- Check_Exist
--   Used by Update Delivery Confirmation - to know whether the delivery has
--   been invoiced.
@UncheckedAccess
FUNCTION Check_Exist (
   deliv_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   CUST_DELIVERY_INV_REF_TAB
      WHERE deliv_no = deliv_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN (dummy_ = 1);
END Check_Exist;


@UncheckedAccess
FUNCTION Get_Total_Cost_Invoice_Item  (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   item_id_       IN NUMBER,
   invoiced_qty_  IN NUMBER ) RETURN NUMBER
IS
   delivery_rec_  Customer_Order_Delivery_API.Public_Rec;
   total_cost_    NUMBER := 0;
   cost_          NUMBER;
   consignment_   VARCHAR2(20);
   stage_billing_  VARCHAR2(20);
   Order_Line_rec_ Customer_Order_Line_API.Public_Rec;
   inv_qty_       NUMBER;
   
   CURSOR get_deliv_no IS
      SELECT deliv_no
      FROM   CUST_DELIVERY_INV_REF_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
    FOR rec_ IN get_deliv_no LOOP
      delivery_rec_ := Customer_Order_Delivery_API.Get(rec_.deliv_no);
      Order_Line_rec_ := Customer_Order_Line_API.Get(delivery_rec_.order_no, delivery_rec_.line_no, delivery_rec_.rel_no, delivery_rec_.line_item_no);
      stage_billing_ := Order_Line_rec_.Staged_Billing;
      consignment_ := Order_Line_rec_.Consignment_Stock;
      
      IF (consignment_ = 'CONSIGNMENT STOCK') THEN
         cost_    := Outstanding_Sales_API.Get_Unit_Cost_For_Inv_Item(company_, invoice_id_, item_id_);
         inv_qty_ := invoiced_qty_;
      ELSE
         cost_    := delivery_rec_.cost;
         inv_qty_ := delivery_rec_.qty_invoiced * Order_Line_rec_.conv_factor / Order_Line_rec_.inverted_conv_factor;
      END IF;  
      
      IF inv_qty_ !=0 AND (inv_qty_ < delivery_rec_.qty_shipped) THEN
         total_cost_ := total_cost_ + cost_ * inv_qty_;
      ELSIF (stage_billing_ = 'STAGED BILLING' AND inv_qty_ = 0) OR (inv_qty_ >= delivery_rec_.qty_shipped)THEN 
         total_cost_ := total_cost_ + cost_ * delivery_rec_.qty_shipped;
      END IF;
    END LOOP;
    RETURN total_cost_;
END Get_Total_Cost_Invoice_Item ;


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
      FROM   cust_delivery_inv_ref_tab
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN record_exist;
   FETCH record_exist INTO count_;
   CLOSE record_exist;
   
   IF (count_ > 0) THEN
      Error_SYS.Record_Constraint('InvoiceItem', Language_SYS.Translate_Lu_Prompt_(lu_name_), to_char(count_));
   END IF;
END Check_Remove;
