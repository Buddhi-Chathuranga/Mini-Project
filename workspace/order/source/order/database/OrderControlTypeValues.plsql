-----------------------------------------------------------------------------
--
--  Logical unit: OrderControlTypeValues
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201015  RoJalk  Bug 148960(SCZ-11815), Modified Get_Ctrl_Type_Value_Order() to consider C13 and C14 when creating postings. 
--  200723  MalLlk  GESPRING20-4618, Modified Get_Ctrl_Type_Value_Order() to get the value for free_of_charge from CO line and add to control_type_value_tab_.
--  180712  Kisalk  SCZ-379 (LCS Bug 142520), Modified Get_Ctrl_Type_Value_Order to use Invoicing Customer of the Customer order (if exists) to get Customer Stat Group.
--  170515  ErFelk  STRSC-8439, Passed cust_ord_inv_head_rec_.shipment_id as a parameter to method call Shipment_Order_Utility_API.Get_Market_Code().
--  170417  ErFelk  Bug 133039, Modified Get_Ctrl_Type_Value_Order() to take the correct market code. 
--  170101  AmPalk  STRMF-6864, Created. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-- Get_Reb_Agg_Post_Rec___ 
--    reb_aggr_line_posting_tmp stores grouped and summed total rebate cost and total rebate amount as per the posting control type 
--    This method retrieves an entire row from the table. 

FUNCTION Get_Reb_Agg_Post_Rec___ (
   reb_aggr_posting_id_ IN NUMBER ) RETURN reb_aggr_line_posting_tmp%ROWTYPE
IS
   temp_    reb_aggr_line_posting_tmp%ROWTYPE;
   CURSOR get_attr IS 
      SELECT * 
      FROM reb_aggr_line_posting_tmp
      WHERE reb_aggr_posting_id = reb_aggr_posting_id_;
BEGIN
   IF reb_aggr_posting_id_ IS NOT NULL THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
      RETURN temp_;  
   END IF; 
END Get_Reb_Agg_Post_Rec___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Get_Ctrl_Type_Value_Rebagg
--    reb_aggr_line_posting_tmp stores grouped and summed total rebate cost and total rebate amount as per the posting control type 
--    This method gets the control type values related to a record in above table.
PROCEDURE Get_Ctrl_Type_Value_Reb_Agg (
   control_type_value_tab_ IN OUT Mpccom_Accounting_API.Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   reb_aggr_line_posting_     reb_aggr_line_posting_tmp%ROWTYPE;
BEGIN
   IF (control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL) THEN
      reb_aggr_line_posting_      := Get_Reb_Agg_Post_Rec___(control_type_key_rec_.reb_aggr_posting_id_);
      control_type_value_tab_(5)  := reb_aggr_line_posting_.C5;  -- customer_order.contract
      control_type_value_tab_(7)  := reb_aggr_line_posting_.C7;  -- invent part prime_commodity
      control_type_value_tab_(8)  := reb_aggr_line_posting_.C8;  -- invent part second_commodity
      control_type_value_tab_(13) := reb_aggr_line_posting_.C13; -- cust_ord_customer.cust_grp
      control_type_value_tab_(15) := reb_aggr_line_posting_.C15; -- sales part catalog group
      control_type_value_tab_(16) := reb_aggr_line_posting_.C16; -- customer_order.order_id
      control_type_value_tab_(18) := reb_aggr_line_posting_.C18; -- cust_order_line_address.country_code
      control_type_value_tab_(19) := reb_aggr_line_posting_.C19; -- cust_ord_customer_rec.market_code
      control_type_value_tab_(20) := reb_aggr_line_posting_.C20; -- co_line_rec.region_code
      control_type_value_tab_(21) := reb_aggr_line_posting_.C21; -- co_line_rec.district_code
      control_type_value_tab_(22) := reb_aggr_line_posting_.C22; -- customer_order_inv_head.pay_term_id
      control_type_value_tab_(26) := reb_aggr_line_posting_.C26; -- customer_order.currency_code
      control_type_value_tab_(27) := reb_aggr_line_posting_.C27; -- customer_order.salesman_code
      control_type_value_tab_(29) := reb_aggr_line_posting_.C29; -- Order_Coordinator.Authorize_Group
      control_type_value_tab_(32) := reb_aggr_line_posting_.C32; -- invent part accounting_group
      control_type_value_tab_(49) := reb_aggr_line_posting_.C49; -- invent part part_product_family
      control_type_value_tab_(50) := reb_aggr_line_posting_.C50; -- invent part part_product_code
      control_type_value_tab_(85) := reb_aggr_line_posting_.C85; -- customer_info.country_db
      control_type_value_tab_(88) := reb_aggr_line_posting_.C88; -- identity_invoice_info.group_id
      control_type_value_tab_(96) := reb_aggr_line_posting_.C96; -- sales_part_rebate_group
      control_type_value_tab_(97) := reb_aggr_line_posting_.C97; -- rebate_type
   END IF;
END Get_Ctrl_Type_Value_Reb_Agg;

-- Get_Ctrl_Type_Value_Order
--   Gets control type value from order.
--   For rebate aggregation line postings, the values will be fetched from the reb_aggr_line_posting_tmp.
PROCEDURE Get_Ctrl_Type_Value_Order (
   control_type_value_tab_ IN OUT Mpccom_Accounting_API.Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   customer_order_rec_              Customer_Order_API.Public_rec;
   customer_order_line_rec_         Customer_order_Line_API.Public_rec;
   order_cust_ord_customer_rec_     Cust_Ord_Customer_API.Public_rec;
   invoice_cust_ord_customer_rec_   Cust_Ord_Customer_API.Public_rec;
   ordering_cust_no_                Customer_Info_Public.customer_id%TYPE;  
   invoicing_cust_no_               Customer_Info_Public.customer_id%TYPE;
   shipment_rec_                    Shipment_API.Public_rec;
   cust_ord_customer_address_rec_   Cust_Ord_Customer_Address_API.Public_rec;
   cust_ord_inv_head_rec_           Customer_Order_Inv_Head_API.Public_rec;
   pay_term_id_                     VARCHAR2(20);
   salesman_code_                   VARCHAR2(20);
   authorize_code_                  VARCHAR2(20);
   region_code_                     VARCHAR2(10);
   district_code_                   VARCHAR2(10);
   market_code_                     VARCHAR2(10);
   delivery_terms_                  VARCHAR2(5);
   ship_via_code_                   VARCHAR2(3);
   order_id_                        VARCHAR2(3);
   currency_code_                   VARCHAR2(3);
   sales_contract_no_               VARCHAR2(15);
   free_of_charge_                  VARCHAR2(5);
BEGIN
   
   IF (control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL) THEN
      
      Get_Ctrl_Type_Value_Reb_Agg(control_type_value_tab_, control_type_key_rec_);
                                                         
   END IF;
   
   IF ((control_type_key_rec_.reb_aggr_posting_id_ IS NULL) OR (
         (control_type_value_tab_(13) IS NULL) 
          AND (control_type_value_tab_(14) IS NULL)
          AND (control_type_value_tab_(16) IS NULL)
          AND (control_type_value_tab_(19) IS NULL)
          AND (control_type_value_tab_(20) IS NULL)
          AND (control_type_value_tab_(21) IS NULL)
          AND (control_type_value_tab_(22) IS NULL)
          AND (control_type_value_tab_(23) IS NULL)
          AND (control_type_value_tab_(24) IS NULL)
          AND (control_type_value_tab_(26) IS NULL)
          AND (control_type_value_tab_(27) IS NULL)
          AND (control_type_value_tab_(28) IS NULL)
          AND (control_type_value_tab_(92) IS NULL)
          AND (control_type_value_tab_(116) IS NULL))) THEN
      
      customer_order_rec_ := Customer_Order_API.Get(control_type_key_rec_.oe_order_no_);

      IF (control_type_key_rec_.oe_line_no_ IS NOT NULL) THEN
         customer_order_line_rec_ := Customer_Order_Line_API.Get(control_type_key_rec_.oe_order_no_
                                                                  , control_type_key_rec_.oe_line_no_
                                                                  , control_type_key_rec_.oe_rel_no_
                                                                  , control_type_key_rec_.oe_line_item_no_);
         region_code_    := customer_order_line_rec_.region_code;
         district_code_  := customer_order_line_rec_.district_code;
         delivery_terms_ := customer_order_line_rec_.delivery_terms;
         ship_via_code_  := customer_order_line_rec_.ship_via_code;
         free_of_charge_ := customer_order_line_rec_.free_of_charge;
      END IF;

      region_code_    := NVL(region_code_, customer_order_rec_.region_code);
      district_code_  := NVL(district_code_, customer_order_rec_.district_code);
      delivery_terms_ := NVL(delivery_terms_, customer_order_rec_.delivery_terms);
      ship_via_code_  := NVL(ship_via_code_, customer_order_rec_.ship_via_code);

      order_id_       := customer_order_rec_.order_id;
      market_code_    := customer_order_rec_.market_code;

      IF (control_type_key_rec_.oe_invoice_id_ IS NOT NULL) THEN
         cust_ord_inv_head_rec_ := Customer_Order_Inv_Head_API.Get(control_type_key_rec_.company_
                                                                     , control_type_key_rec_.oe_invoice_id_);
         pay_term_id_ := cust_ord_inv_head_rec_.pay_term_id;

         -- Fetch shipment related information
         IF cust_ord_inv_head_rec_.shipment_id IS NOT NULL AND control_type_key_rec_.oe_order_no_ IS NULL THEN
            shipment_rec_ := Shipment_API.Get(cust_ord_inv_head_rec_.shipment_id);
            delivery_terms_ := shipment_rec_.delivery_terms;
            ship_via_code_  := shipment_rec_.ship_via_code;

            IF shipment_rec_.addr_flag = 'N' THEN
               cust_ord_customer_address_rec_ := Cust_Ord_Customer_Address_API.Get(shipment_rec_.receiver_id, shipment_rec_.receiver_addr_id);
               region_code_    := cust_ord_customer_address_rec_.region_code;
               district_code_  := cust_ord_customer_address_rec_.district_code;
            END IF;
            
            market_code_    := Shipment_Order_Utility_API.Get_Market_Code(cust_ord_inv_head_rec_.shipment_id, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
            
          END IF;
      ELSE
         pay_term_id_ := customer_order_rec_.pay_term_id;
      END IF;

      market_code_       := market_code_; 
      region_code_       := region_code_;
      district_code_     := district_code_;
      pay_term_id_       := pay_term_id_;
      currency_code_     := customer_order_rec_.currency_code;
      salesman_code_     := customer_order_rec_.salesman_code;
      authorize_code_    := customer_order_rec_.authorize_code;
      sales_contract_no_ := customer_order_rec_.sales_contract_no;
      
      ordering_cust_no_  := NVL(customer_order_rec_.customer_no, cust_ord_inv_head_rec_.delivery_identity);
      invoicing_cust_no_ := NVL(customer_order_rec_.customer_no_pay, Customer_Order_Inv_Head_API.Get_Identity(control_type_key_rec_.company_, control_type_key_rec_.oe_invoice_id_));         

      IF (ordering_cust_no_ = invoicing_cust_no_) THEN
         order_cust_ord_customer_rec_  := Cust_Ord_Customer_API.Get(ordering_cust_no_);
         invoice_cust_ord_customer_rec_:= order_cust_ord_customer_rec_;
      ELSE
         order_cust_ord_customer_rec_   := Cust_Ord_Customer_API.Get(ordering_cust_no_);
         invoice_cust_ord_customer_rec_ := Cust_Ord_Customer_API.Get(invoicing_cust_no_);
      END IF;
      
      control_type_value_tab_(13) := order_cust_ord_customer_rec_.cust_grp;
      control_type_value_tab_(14) := invoice_cust_ord_customer_rec_.cust_grp;
      control_type_value_tab_(16) := order_id_;
      control_type_value_tab_(19) := market_code_;
      control_type_value_tab_(20) := region_code_;
      control_type_value_tab_(21) := district_code_;
      control_type_value_tab_(22) := pay_term_id_;
      control_type_value_tab_(23) := delivery_terms_;
      control_type_value_tab_(24) := ship_via_code_;
      control_type_value_tab_(26) := currency_code_;
      control_type_value_tab_(27) := salesman_code_;
      control_type_value_tab_(28) := authorize_code_;
      control_type_value_tab_(92) := sales_contract_no_;
      control_type_value_tab_(116) := free_of_charge_;
   -- authorize
      control_type_value_tab_(29) := Order_Coordinator_API.Get_Authorize_Group(control_type_value_tab_(28));
                                                         
   END IF;
  
END Get_Ctrl_Type_Value_Order;


-- Get_Ctrl_Type_Value_Salespart
--   Gets control type value from Sales Part.
--   For rebate aggregation line postings, the values will be fetched from the reb_aggr_line_posting_tmp.
PROCEDURE Get_Ctrl_Type_Value_Salespart (
   control_type_value_tab_ IN OUT Mpccom_Accounting_API.Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   catalog_no_              VARCHAR2(25) := control_type_key_rec_.catalog_no_;
BEGIN
   IF (control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL) THEN
      
      Get_Ctrl_Type_Value_Reb_Agg(control_type_value_tab_, control_type_key_rec_);
                                                         
   END IF;
   
   IF ((control_type_key_rec_.reb_aggr_posting_id_ IS NULL) OR 
         ((control_type_value_tab_(15) IS NULL) AND (control_type_value_tab_(17) IS NULL))) THEN
           
      IF (catalog_no_ IS NULL ) THEN
         catalog_no_ := Customer_Order_Line_API.Get_Catalog_No(control_type_key_rec_.oe_order_no_,
                                                               control_type_key_rec_.oe_line_no_,
                                                               control_type_key_rec_.oe_rel_no_,
                                                               control_type_key_rec_.oe_line_item_no_);
      END IF;                                                                  
      control_type_value_tab_(15) := Sales_Part_API.Get_Catalog_Group(control_type_key_rec_.contract_, catalog_no_);
      control_type_value_tab_(17) := Customer_Order_Line_API.Get_Price_List_No(control_type_key_rec_.oe_order_no_,
                                                                               control_type_key_rec_.oe_line_no_,
                                                                               control_type_key_rec_.oe_rel_no_,
                                                                               control_type_key_rec_.oe_line_item_no_);
         
   END IF;
END Get_Ctrl_Type_Value_Salespart;


-- Get_Ctrl_Type_Value_Coaddress
--   Gets control type value from order / order line address.
--   For rebate aggregation line postings, the values will be fetched from the reb_aggr_line_posting_tmp.
PROCEDURE Get_Ctrl_Type_Value_Coaddress (
   control_type_value_tab_ IN OUT Mpccom_Accounting_API.Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   country_code_            VARCHAR2(2);
BEGIN
   IF control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL THEN
      Get_Ctrl_Type_Value_Reb_Agg(control_type_value_tab_, control_type_key_rec_);
   END IF; 
   
   IF ((control_type_key_rec_.reb_aggr_posting_id_ IS NULL) OR (control_type_value_tab_(18) IS NULL)) THEN 
      IF (control_type_key_rec_.oe_line_no_ IS NULL) THEN
         country_code_  := Customer_Order_Address_API.Get_Country_Code(control_type_key_rec_.oe_order_no_);                              
      ELSE
         country_code_  := Cust_Order_Line_Address_API.Get_Country_Code(control_type_key_rec_.oe_order_no_, control_type_key_rec_.oe_line_no_, control_type_key_rec_.oe_rel_no_, control_type_key_rec_.oe_line_item_no_);                               
      END IF;
      control_type_value_tab_(18) := country_code_;
   END IF;                                                                  
   
END Get_Ctrl_Type_Value_Coaddress;


-- Get_Ctrl_Type_Value_Country
--   Gets control type value from customer info.
--   For rebate aggregation line postings, the values will be fetched from the reb_aggr_line_posting_tmp.
PROCEDURE Get_Ctrl_Type_Value_Country (
   control_type_value_tab_ IN OUT Mpccom_Accounting_API.Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   customer_no_             customer_info_public.customer_id%TYPE;
   country_code_            VARCHAR2(2);
BEGIN
   
   IF control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL THEN
      Get_Ctrl_Type_Value_Reb_Agg(control_type_value_tab_, control_type_key_rec_);         
   END IF;
   IF ((control_type_key_rec_.reb_aggr_posting_id_ IS NULL) OR (control_type_value_tab_(85) IS NULL)) THEN 
      IF (control_type_key_rec_.oe_invoice_id_ IS NOT NULL) THEN
         customer_no_ := Customer_Order_Inv_Head_API.Get_Identity(control_type_key_rec_.company_, control_type_key_rec_.oe_invoice_id_);
      ELSE
         customer_no_ := NVL(Customer_Order_API.Get_Customer_No_Pay(control_type_key_rec_.oe_order_no_), Customer_Order_API.Get_Customer_No(control_type_key_rec_.oe_order_no_));
      END IF;
      country_code_ := Customer_Info_api.Get_Country_Db(customer_no_);
      control_type_value_tab_(85) := country_code_;
   END IF;                                                                  
   
END Get_Ctrl_Type_Value_Country;

-- Get_Ctrl_Type_Value_Customergrp
--   Gets control type value from invoice info.
--   For rebate aggregation line postings, the values will be fetched from the reb_aggr_line_posting_tmp.
PROCEDURE Get_Ctrl_Type_Value_Custgrp (
   control_type_value_tab_ IN OUT Mpccom_Accounting_API.Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   customer_no_               customer_info_public.customer_id%TYPE;
   customer_group_            VARCHAR2(20);
BEGIN
   IF control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL THEN
      Get_Ctrl_Type_Value_Reb_Agg(control_type_value_tab_, control_type_key_rec_); 
   END IF;
   IF ((control_type_key_rec_.reb_aggr_posting_id_ IS NULL) OR (control_type_value_tab_(88) IS NULL)) THEN  
      IF (control_type_key_rec_.oe_invoice_id_ IS NOT NULL) THEN
         customer_no_ := Customer_Order_Inv_Head_API.Get_Identity(control_type_key_rec_.company_, control_type_key_rec_.oe_invoice_id_);
      ELSE
         customer_no_ := nvl(Customer_Order_API.Get_Customer_No_Pay(control_type_key_rec_.oe_order_no_), Customer_Order_API.Get_Customer_No(control_type_key_rec_.oe_order_no_));
      END IF;
      customer_group_ := Identity_Invoice_Info_API.Get_Group_Id(control_type_key_rec_.company_, customer_no_, Party_Type_API.Decode('CUSTOMER'));
      control_type_value_tab_(88) := customer_group_;
   END IF;                                                                  
   
END Get_Ctrl_Type_Value_Custgrp;

-- Get_Ctrl_Type_Value_Rebgrp
--   Gets control type value from rebate info.
--   For rebate aggregation line postings, the values will be fetched from the reb_aggr_line_posting_tmp.
PROCEDURE Get_Ctrl_Type_Value_Rebgrp (
   control_type_value_tab_ IN OUT Mpccom_Accounting_API.Control_Type_Value,
   control_type_key_rec_   IN     Mpccom_Accounting_API.Control_Type_Key)
IS
   transaction_rec_  Rebate_Transaction_API.Public_rec;
   invitem_rec_      Customer_Order_Inv_Item_API.Public_rec;
BEGIN
   IF control_type_key_rec_.transaction_id_ IS NOT NULL THEN
      transaction_rec_ := Rebate_Transaction_API.Get(control_type_key_rec_.transaction_id_);
      control_type_value_tab_(96) := transaction_rec_.sales_part_rebate_group;
      control_type_value_tab_(97) := transaction_rec_.rebate_type;
   ELSE
      IF control_type_key_rec_.reb_aggr_posting_id_ IS NOT NULL THEN
         Get_Ctrl_Type_Value_Reb_Agg(control_type_value_tab_, control_type_key_rec_);  
      END IF;
      IF ( (control_type_key_rec_.reb_aggr_posting_id_ IS NULL) OR 
            ((control_type_value_tab_(96) IS NULL AND control_type_value_tab_(97) IS NULL))) THEN 
         invitem_rec_ := Customer_Order_Inv_Item_API.Get(control_type_key_rec_.company_, control_type_key_rec_.oe_invoice_id_, control_type_key_rec_.oe_invoice_item_id_);
         control_type_value_tab_(96) := invitem_rec_.sales_part_rebate_group;
         control_type_value_tab_(97) := invitem_rec_.catalog_no;
      END IF;
   END IF;
END Get_Ctrl_Type_Value_Rebgrp;


-- gelr:gross_revenue_accounting, begin
-- Get_Str_Code_Ctrl_Type_Values
--    Gets control type value for provided posting type and parameters.
FUNCTION Get_Str_Code_Ctrl_Type_Values (
   company_         IN VARCHAR2,
   str_code_        IN VARCHAR2,
   invoice_id_      IN NUMBER,
   invoice_item_id_ IN NUMBER,
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   accounting_date_ IN DATE) RETURN VARCHAR2
IS
   control_type_key_rec_       Mpccom_Accounting_API.Control_Type_Key;
   control_type_value_table_   Posting_Ctrl_Public_API.control_type_value_table;
   ctrl_types_                 VARCHAR2(32000);
   j_                          VARCHAR2(10);
   
BEGIN
   control_type_key_rec_.company_            := company_;
   control_type_key_rec_.oe_invoice_id_      := invoice_id_;
   control_type_key_rec_.oe_invoice_item_id_ := invoice_item_id_;
   control_type_key_rec_.contract_           := contract_;
   control_type_key_rec_.part_no_            := part_no_;
   control_type_key_rec_.oe_order_no_        := order_no_;
   control_type_key_rec_.oe_line_no_         := line_no_;
   control_type_key_rec_.oe_rel_no_          := rel_no_;
   control_type_key_rec_.oe_line_item_no_    := line_item_no_;

   Mpccom_Accounting_API.Get_Control_Type_Values(control_type_value_table_,
                                                 control_type_key_rec_,
                                                 company_,
                                                 str_code_,
                                                 accounting_date_);

   Client_SYS.Clear_Attr(ctrl_types_);
   j_ := control_type_value_table_.FIRST;
   WHILE j_ IS NOT NULL LOOP
      IF (control_type_value_table_(j_) IS NOT NULL) THEN
         Client_SYS.Add_To_Attr(j_, control_type_value_table_(j_), ctrl_types_);
      END IF;

      j_ := control_type_value_table_.NEXT(j_);
   END LOOP;
   
   RETURN ctrl_types_;
END Get_Str_Code_Ctrl_Type_Values;
-- gelr:gross_revenue_accounting, end


-------------------- LU  NEW METHODS -------------------------------------
