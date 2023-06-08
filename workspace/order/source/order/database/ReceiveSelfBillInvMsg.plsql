-----------------------------------------------------------------------------
--
--  Logical unit: ReceiveSelfBillInvMsg
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210715  DhAplk  SC21R2-225, Removed COMMIT in Ext_Inc_Sbi_Head_Struct_New___.
--  201125  DhAplk  SC2020R1-11520, Added commit to Ext_Inc_Sbi_Head_Struct_New___ to make compatible with prevoius APP10 code.
--  201019  ChBnlk  SC2020R1-10738, Replace conditional compilation check for ITS with method Dictionary_SYS.Component_Is_Active('ITS').
--  180920  ChBnlk  SC2020R1-9656, Added component check ITS to execute INET_TRANS message passing related codes only when 
--  180920          ITS is istalled.
--  200623  DhAplk  Created by adding Receive_Self_Billing_Invoice, Approve_Self_Billing_Invoice, Get_Next_Message_Line___ methods and reimplemented Ext_Inc_Sbi_Head_Struct_New___, 
--  200623          Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_Copy_From_Header___, Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_New___ methods.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Ext_Inc_Sbi_Head_Struct_New___ (
   rec_ IN OUT Ext_Inc_Sbi_Head_Struct_Rec)
IS
BEGIN
   rec_.message_id := Connectivity_SYS.Get_Next_In_Message_Id();
   rec_.create_date := SYSDATE;
   
   Super(rec_); 
END Ext_Inc_Sbi_Head_Struct_New___;

@Override
PROCEDURE Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_Copy_From_Header___(
   rec_        IN OUT  Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_Rec,
   header_rec_ IN      Ext_Inc_Sbi_Head_Struct_Rec)
IS
BEGIN
   rec_.message_id := header_rec_.message_id;  
END Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_Copy_From_Header___;

@Override
PROCEDURE Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_New___ (
   rec_ IN OUT Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_Rec)
IS
BEGIN
   rec_.message_line := Get_Next_Message_Line___(rec_.message_id);
   rec_.price_conv_factor := NVL(rec_.price_conv_factor, 1);
   rec_.message_line_type := 'INVOICEITEM';
   
   Super(rec_);
END Ext_Inc_Sbi_Head_Struct_Ext_Inc_Sbi_Item_New___;

FUNCTION Get_Next_Message_Line___ (
     message_id_ IN NUMBER ) RETURN NUMBER
IS
   message_line_ NUMBER;
   temp_ NUMBER;

   CURSOR get_max_line_id(message_id_ NUMBER) IS
   SELECT max(message_line)
   FROM ext_inc_sbi_item_tab
   WHERE message_id = message_id_;
BEGIN
   OPEN get_max_line_id(message_id_); 
   FETCH get_max_line_id INTO temp_;
   IF (get_max_line_id%NOTFOUND OR temp_ IS NULL) THEN
      message_line_ := 1;
   ELSE
      message_line_ := temp_ + 1;
   END IF;
   CLOSE get_max_line_id;
   RETURN message_line_;
END Get_Next_Message_Line___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Receive_Self_Billing_Invoice
--    This method is used to support ITS message in receiving Self-billing Invoice and called from SalesMessageService.svc/ReceiveSelfBillingInvoice.
--    The parameter structure type Ext_Inc_Sbi_Head_Struct_Rec is modelled in ReceiveSelfBillInvMsg.fragment
--    Any additional logic changes should be evaluate with the connectivity support Customer_Order_Transfer_API.Receive_Self_Billing_Invoice method.
PROCEDURE Receive_Self_Billing_Invoice(
   sbi_struct_ IN Ext_Inc_Sbi_Head_Struct_Rec)
IS
   new_sbi_struct_ Ext_Inc_Sbi_Head_Struct_Rec;
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ITS') THEN
      new_sbi_struct_ := sbi_struct_;
      Create_Ext_Inc_Sbi_Head_Struct_Rec___(new_sbi_struct_);
  
      @ApproveTransactionStatement(2020-06-22,DhAplk)
      COMMIT;
      Approve_Self_Billing_Invoice(sbi_struct_.customer_no, sbi_struct_.message_id);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
   END IF;
END Receive_Self_Billing_Invoice;

PROCEDURE Approve_Self_Billing_Invoice(
   customer_no_ IN EXT_INC_SBI_HEAD_TAB.customer_no%TYPE,
   message_id_  IN NUMBER)
IS
   cust_ord_cust_rec_   Cust_Ord_Customer_API.Public_Rec;
BEGIN
  cust_ord_cust_rec_ := Cust_Ord_Customer_API.Get(customer_no_);
   IF (cust_ord_cust_rec_.match_type != 'NOAUTO') THEN           
      Fnd_Session_API.Impersonate_Fnd_User(cust_ord_cust_rec_.sbi_auto_approval_user);
      Order_Self_Billing_Manager_API.Automatic_Sbi_Process(message_id_);
      Fnd_Session_API.Reset_Fnd_User();
   END IF;
EXCEPTION 
   WHEN others THEN
      Fnd_Session_API.Reset_Fnd_User();
END Approve_Self_Billing_Invoice;

-------------------- LU  NEW METHODS -------------------------------------
