-----------------------------------------------------------------------------
--
--  Logical unit: ReceiveRecAdviceMsg
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201105  DhAplk  SC2020R1-11266, Handled the exceptions in Receive_Recv_Advice_Inet_Trans, Process_Aftr_Recv_Rec_Advice__.
--  201019  ChBnlk  SC2020R1-10738, Added Dictionary_SYS.Component_Is_Active('ITS').
--  200520  DhAplk  SC2020R1-813, Receive_Recv_Advice_Inet_Trans, Added Get_Next_Message_Line___, Process_Aftr_Recv_Rec_Advice__ and reimplemented 
--  200520          Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_New___, Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_Copy_From_Header___
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_New___ (
   rec_ IN OUT NOCOPY Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_Rec)
IS
BEGIN
   rec_.message_line := Get_Next_Message_Line___(rec_.message_id);
   super(rec_);
END Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_New___;

@Override 
PROCEDURE Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_Copy_From_Header___(
   rec_        IN OUT NOCOPY Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_Rec,
   header_rec_ IN      Ext_Receiving_Advice_Struct_Rec)
IS
BEGIN
   rec_.message_id := header_rec_.message_id;
END Ext_Receiving_Advice_Struct_Ext_Receiving_Advice_Line_Copy_From_Header___;

FUNCTION Get_Next_Message_Line___ (
   message_id_ IN NUMBER ) RETURN NUMBER
IS
   message_line_ NUMBER;
   temp_ NUMBER;

   CURSOR get_max_line_id(message_id_ NUMBER) IS
   SELECT max(message_line)
   FROM ext_receiving_advice_line_tab
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

PROCEDURE Process_Aftr_Recv_Rec_Advice__(
   message_id_             IN NUMBER,
   cust_no_                IN VARCHAR2,
   internal_customer_site_ IN VARCHAR2)
IS
   customer_no_         EXT_RECEIVING_ADVICE_TAB.customer_no%TYPE;
   coc_rec_             Cust_Ord_Customer_API.Public_Rec;
BEGIN  
   -- Check whether the automatic matching is enable for the customer.
   IF (internal_customer_site_ IS NULL ) THEN
      customer_no_ := cust_no_;
   ELSE
      customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(internal_customer_site_);
   END IF;
   coc_rec_  := Cust_Ord_Customer_API.Get(customer_no_);
   IF coc_rec_.rec_adv_auto_matching = 'TRUE' THEN            
      Fnd_Session_API.Impersonate_Fnd_User(coc_rec_.rec_adv_auto_approval_user);
      Ext_Receiving_Advice_API.Set_To_Matching_In_Progress(message_id_);      
      Fnd_Session_API.Reset_Fnd_User();
   END IF;
END Process_Aftr_Recv_Rec_Advice__;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Receive_Recv_Advice_Inet_Trans   
--    This method is used to support ITS messages in incoming Receiving Advice and called from SalesMessageService.svc/ReceiveReceivingAdvice.
--    The parameter structure type Ext_Receiving_Advice_Struct_Rec is modelled in ReceiveRecAdviceMsg.fragment
--    Any additional logic changes should be evaluate with the connectivity support Customer_Order_Transfer_API.Receive_Receiving_Advice method.
PROCEDURE Receive_Recv_Advice_Inet_Trans(
   receiving_advice_struct_ IN Ext_Receiving_Advice_Struct_Rec)
IS
   new_receiving_advice_struct_ Ext_Receiving_Advice_Struct_Rec;
   accept_message_              BOOLEAN := FALSE;
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ITS') THEN
      new_receiving_advice_struct_ := receiving_advice_struct_;
      new_receiving_advice_struct_.message_id := Connectivity_SYS.Get_Next_In_Message_Id();
      Create_Ext_Receiving_Advice_Struct_Rec___(new_receiving_advice_struct_);
   
      @ApproveTransactionStatement(2020-08-10,DhAplk)
      COMMIT;  
      -- Application message is processed correctly.
      accept_message_ := TRUE;
      Process_Aftr_Recv_Rec_Advice__(new_receiving_advice_struct_.message_id, new_receiving_advice_struct_.customer_no, new_receiving_advice_struct_.internal_customer_site);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
   END IF;
EXCEPTION
   WHEN others THEN     
   -- Rollback to the last savepoint
   @ApproveTransactionStatement(2020-08-10,DhAplk)
   ROLLBACK;
   Fnd_Session_API.Reset_Fnd_User();
   IF NOT accept_message_ THEN
      -- If get an error before message is processed correctly, it will appear on Application Message.
      RAISE;
   END IF;
END Receive_Recv_Advice_Inet_Trans;

-------------------- LU  NEW METHODS -------------------------------------
