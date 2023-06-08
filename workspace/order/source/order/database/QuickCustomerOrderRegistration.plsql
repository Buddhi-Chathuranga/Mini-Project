-----------------------------------------------------------------------------
--
--  Logical unit: QuickCustomerOrderRegistration
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE Get_Cust_Defaults_Rapid_Co_Reg (
   attr_ IN OUT VARCHAR2 )
IS
   customer_no_   VARCHAR2(20);
   contract_      VARCHAR2(5);
   currency_code_ VARCHAR2(3);
   date_string_   VARCHAR2(25);
   order_id_      VARCHAR2(3);
   site_rec_      Site_API.Public_Rec;
   customer_rec_  Cust_Ord_Customer_API.Public_Rec;
   site_date_     DATE;
   ship_addr_no_  VARCHAR2(50);
   wanted_delivery_date_ DATE;
   
BEGIN 
   customer_no_           := Client_SYS.Get_Item_Value('CUSTOMER_NO', attr_);
   contract_              := Client_SYS.Get_Item_Value('CONTRACT', attr_);   
   date_string_           := Client_SYS.Get_Item_Value('WANTED_DELIVERY_DATE', attr_);
   
   Site_API.Exist(contract_);
   Cust_Ord_Customer_API.Exist(customer_no_);   
   
   site_rec_      := Site_API.Get(contract_);
   site_date_     := Site_API.Get_Site_Date(contract_);
   customer_rec_  := Cust_Ord_Customer_API.Get(customer_no_);
   
   IF (currency_code_ IS NULL) THEN
         currency_code_ := customer_rec_.currency_code;
      END IF;
      
      IF (order_id_ IS NULL) THEN
         -- Get order_id from site/customer, site, customer
         order_id_ := Customer_Order_API.Get_Default_Order_Type(contract_, customer_no_);      
      END IF;
      
      -- IF no ship address was passed in retrive the default.
      IF (ship_addr_no_ IS NULL) THEN
         ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
         Trace_SYS.Field('Fetched new ship address', ship_addr_no_);
      END IF;
      IF (ship_addr_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_SHIP_ADDR: Customer :P1 has no delivery address with order specific attributes specified.', customer_no_);
      END IF;
      
      IF (date_string_ IS NOT NULL) THEN
         wanted_delivery_date_ := Client_SYS.Attr_Value_To_Date(date_string_);
      END IF;
      
      Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
      Client_SYS.Set_Item_Value('ORDER_ID', order_id_, attr_);
      Client_SYS.Set_Item_Value('CURRENCY_CODE', currency_code_, attr_);
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', ship_addr_no_, attr_);
      
      
END Get_Cust_Defaults_Rapid_Co_Reg;
   
   
--PROCEDURE Create_Rapid_Customer_Order (
--   <arguments>)
--IS
--BEGIN
--   
--END Create_Rapid_Customer_Order;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
