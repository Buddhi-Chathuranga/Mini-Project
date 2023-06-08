-----------------------------------------------------------------------------
--
--  Logical unit: QuickCustOrdRegUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211022  Chbnlk  SC21R2-1083, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Quick_Cust_Ord_Struct_Customer_Order_Line_New___ (
   rec_ IN OUT NOCOPY Quick_Cust_Ord_Struct_Customer_Order_Line_Rec)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
BEGIN
   Add_To_Attr_From_Rec___(rec_, attr_);
   Customer_Order_Line_API.New(info_, attr_);
   Add_To_Rec_From_Attr___(attr_, rec_);  
END Quick_Cust_Ord_Struct_Customer_Order_Line_New___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Quick_Cust_Ord_Struct_Customer_Order_Line_Copy_From_Header___(
   rec_        IN OUT NOCOPY Quick_Cust_Ord_Struct_Customer_Order_Line_Rec,
   header_rec_ IN      Quick_Cust_Ord_Struct_Rec)
IS
   
BEGIN
   rec_.order_no := header_rec_.order_no;
   rec_.contract := header_rec_.contract;
END Quick_Cust_Ord_Struct_Customer_Order_Line_Copy_From_Header___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Quick_Cust_Order (
   order_struct_ IN OUT Quick_Cust_Ord_Struct_Rec,
   info_         IN OUT VARCHAR2,
   released_order_creation_ IN BOOLEAN,
   print_order_confirmation_ IN BOOLEAN,
   email_order_confirmation_ IN BOOLEAN,
   email_address_ IN VARCHAR2)
IS

BEGIN
   Create_Quick_Cust_Ord_Struct_Rec___(order_struct_);
   @ApproveTransactionStatement(2022-01-26,chbnlk)
   COMMIT;
   IF released_order_creation_ THEN
      Customer_Order_Flow_API.Release_Order(order_struct_.order_no, 'FALSE', 'TRUE');
   END IF;
   
   IF ((email_address_ IS NOT NULL) AND (email_order_confirmation_)) THEN
      Customer_Order_Flow_API.Email_Order_Report__(order_struct_.order_no, order_struct_.cust_ref, order_struct_.contract,
                                       email_address_, order_struct_.customer_no, 'CUSTOMER_ORDER_CONF_REP');
   ELSIF (print_order_confirmation_) THEN 
      Customer_Order_Flow_API.Print_Order_Confirmation__(order_struct_.order_no);
   END IF;
 
END Create_Quick_Cust_Order;

@IgnoreUnitTest TrivialFunction
FUNCTION Check_Limit_Sales_Assortments (
   customer_no_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   IF(Customer_Assortment_Struct_API.Check_Limit_Sales_To_Assorts(customer_no_) = 'TRUE') THEN
      RETURN TRUE;   
   ELSE
      RETURN FALSE;
   END IF;
END Check_Limit_Sales_Assortments;

-------------------- LU  NEW METHODS -------------------------------------
