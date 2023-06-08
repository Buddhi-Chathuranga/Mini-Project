-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  ---------------------------------------------------------
--  2021-07-07  ChBnlk  SC21R2-1394, Modified Get_Customer_Order_Overview() to handle exeption when no record is returning.
--  2021-06-28  ChBnlk  SC21R2-1394, Removed error handling in Get_Customer_Order() in order to avoid some unnecessary errors.
--  2021-06-28  ChBnlk  SC21R2-1394, Modified Get_Customer_Order_Overview() and Get_Customer_Order() in order to handle error messages properly.
--  2021-06-22  NiDalk  SC21R2-257, Modified Customer_Order_Structure_Cust_Order_Line_Copy_From_Header___ to validate customer_part_no.
--  2021-06-17  MiKulk  SC21R2-224, Modified the GetCustomerOrders to use the Structure OrderHeaderStructure.
--  2021-06-16  DhAplk  SC21R2-1528, Modify Customer_Order_Structure_New___ to call Customer_Order_API.New().
--  2021-06-16  NiDalk  SC21R2-1546, Modified Create_Customer_Order to add rollback to the exception to avoid partial commit of cutomer order creation.
--  2021-06-15  NiDalk  SC21R2-1543, Added null checks for collections.
--  2021-06-08  NiDalk  SC21R2-222, Modified Customer_Order_Structure_Cust_Order_Line_Copy_From_Header___ to assign header shipment_type to line.
--  2021-03-04  NiDalk  SC2020R1-12800, Modified Create_Customer_Order to set value for ErrorMessage.
--  2021-02-22  NiDalk  SC2020R1-12520, Removed Charge lines from Get_Customer_Order_Overview. Also enabled max_records parameters.
--  2020-10-15  NiDalk  SC2020R1-10592, Moved the logic related to CustomerOrderService.CreateCustomerOrder to CustomerOrderUtil
--  2020-10-15          and to use framework generated code.
--  2020-09-22  NiDalk  SC2020R1-9657, Added ORDSRV installed check.
--  2020-09-14  NiDalk  SC2020R1-9815, Modified Get_Customer_Order to remove some unnecessary code.
--  2020-05-12  Erlise  SC2020R1-57, Created to support integration projection CustomerOrderService.
-----------------------------------------------------------------------------

layer Core;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_Line_Response_Arr___ (
   order_rec_  IN    Customer_Order_Structure_Rec) RETURN Order_Line_Response_Structure_Arr
IS
   line_response_arr_   Order_Line_Response_Structure_Arr := Order_Line_Response_Structure_Arr();
   charge_info_         VARCHAR2(20000);
BEGIN
   IF (order_rec_.lines IS NOT NULL AND order_rec_.lines.count > 0) THEN
      FOR i IN order_rec_.lines.first .. order_rec_.lines.last LOOP
         line_response_arr_.extend;
         line_response_arr_(i).line_no := order_rec_.lines(i).line_no;
         line_response_arr_(i).rel_no := order_rec_.lines(i).rel_no;
         line_response_arr_(i).line_item_no := order_rec_.lines(i).line_item_no;
         line_response_arr_(i).sales_part_no := order_rec_.lines(i).catalog_no;
         line_response_arr_(i).sales_qty := order_rec_.lines(i).buy_qty_due;
         line_response_arr_(i).desired_qty := Customer_Order_Line_API.Get_Desired_Qty(order_rec_.lines(i).order_no,
                                                                                      order_rec_.lines(i).line_no,
                                                                                      order_rec_.lines(i).rel_no,
                                                                                      order_rec_.lines(i).line_item_no);
         line_response_arr_(i).planned_delivery_date_time := Customer_Order_Line_API.Get_Planned_Delivery_Date(order_rec_.lines(i).order_no,
                                                                                      order_rec_.lines(i).line_no,
                                                                                      order_rec_.lines(i).rel_no,
                                                                                      order_rec_.lines(i).line_item_no);
         
         IF (order_rec_.lines(i).line_charges IS NOT NULL AND order_rec_.lines(i).line_charges.count > 0) THEN
            FOR j IN order_rec_.lines(i).line_charges.first .. order_rec_.lines(i).line_charges.last LOOP
               charge_info_ := charge_info_ || order_rec_.lines(j).line_charges(i). info;
            END LOOP;
         END IF;
         line_response_arr_(i).info := order_rec_.lines(i).info || charge_info_;
      END LOOP;
   END IF;
   
   RETURN line_response_arr_;
END Get_Line_Response_Arr___;

@Override
PROCEDURE Add_To_Attr_From_Rec___ (
   rec_  IN     Customer_Order_Structure_Rec,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(rec_, attr_);
   -- Identifies a customer order created through this API.
   Client_Sys.Add_To_Attr('SOURCE_ORDER', 'WS', attr_);
END Add_To_Attr_From_Rec___;

@Override
PROCEDURE Customer_Order_Structure_New___ (
   rec_  IN OUT NOCOPY Customer_Order_Structure_Rec)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
BEGIN
   Add_To_Attr_From_Rec___(rec_, attr_);
   Customer_Order_API.New(info_, attr_);
   Add_To_Rec_From_Attr___(attr_, rec_);
   -- Add info
   rec_.info := Remove_Separators(info_);
END Customer_Order_Structure_New___;

@Override
PROCEDURE Customer_Order_Structure_Header_Address_Copy_From_Header___(
   rec_        IN OUT NOCOPY Customer_Order_Structure_Header_Address_Rec,
   header_rec_ IN      Customer_Order_Structure_Rec)
IS
BEGIN
   -- Add single occurrence address if present
   IF UPPER(header_rec_.addr_flag) = 'Y' THEN
      rec_.order_no := header_rec_.order_no;
   ELSE
      rec_.order_no := NULL;
   END IF;
END Customer_Order_Structure_Header_Address_Copy_From_Header___;

@Override
PROCEDURE Create_Customer_Order_Structure_Header_Address_Rec___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Header_Address_Rec)
IS
BEGIN
   IF rec_.order_no IS NOT NULL THEN
      super(rec_);
   END IF;
END Create_Customer_Order_Structure_Header_Address_Rec___;

@Override
PROCEDURE Customer_Order_Structure_Order_Charge_Copy_From_Header___(
   rec_        IN OUT NOCOPY Customer_Order_Structure_Order_Charge_Rec,
   header_rec_ IN      Customer_Order_Structure_Rec)
IS
   sctrec_      Sales_Charge_Type_API.Public_Rec;
BEGIN
   rec_.order_no := header_rec_.order_no;
   sctrec_ := Sales_Charge_Type_Api.Get(header_rec_.contract, rec_.charge_type);
   
   IF rec_.charge_cost IS NULL THEN
      rec_.charge_cost := sctrec_.charge_cost;
   END IF;
   
   IF rec_.charge_cost_percent IS NULL THEN 
      rec_.charge_cost_percent := rec_.charge_cost_percent;
   END IF;
END Customer_Order_Structure_Order_Charge_Copy_From_Header___;

@Override
PROCEDURE Customer_Order_Structure_Order_Charge_New___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Order_Charge_Rec)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
BEGIN
   Add_To_Attr_From_Rec___(rec_, attr_);
   Customer_Order_Charge_Api.New(info_, attr_);
   Add_To_Rec_From_Attr___(attr_, rec_);
   -- Add info
   rec_.info := Remove_Separators(info_);
END Customer_Order_Structure_Order_Charge_New___;

@Override
PROCEDURE Customer_Order_Structure_Cust_Order_Line_Copy_From_Header___(
   rec_        IN OUT NOCOPY Customer_Order_Structure_Cust_Order_Line_Rec,
   header_rec_ IN      Customer_Order_Structure_Rec)
IS
   catalog_no_       customer_order_line_tab.catalog_no%TYPE;
BEGIN
   IF rec_.customer_part_no IS NOT NULL THEN 
      catalog_no_ := Sales_Part_Cross_Reference_API.Get_Catalog_No(header_rec_.customer_no, header_rec_.contract, rec_.customer_part_no);
      
      IF catalog_no_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'CUSTOMERPARTNOERROR: Customer''s part number :P1 does not exist in sales part cross reference for customer :P2 and site :P3.' , rec_.customer_part_no, header_rec_.customer_no, header_rec_.contract);
      ELSE
         rec_.catalog_no := catalog_no_;
      END IF; 
   END IF;
   
   rec_.order_no := header_rec_.order_no;
   rec_.shipment_type := NVL(rec_.shipment_type, header_rec_.shipment_type);
END Customer_Order_Structure_Cust_Order_Line_Copy_From_Header___;

@Override
PROCEDURE Customer_Order_Structure_Cust_Order_Line_New___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Cust_Order_Line_Rec)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   company_    VARCHAR2(100);
BEGIN
   Add_To_Attr_From_Rec___(rec_, attr_);
   Customer_Order_Line_API.New(info_, attr_);
   Add_To_Rec_From_Attr___(attr_, rec_);
   -- Add info
   rec_.info := Remove_Separators(info_);
   
   -- Fetch the company to which the site is connected.
   company_ := Site_API.Get_Company(Customer_Order_API.Get_Contract(rec_.order_no));
   -- Remove all tax lines automatically added by the customer order base logic
   IF rec_.tax_lines IS NOT NULL THEN
      IF rec_.tax_lines.count > 0 THEN 
         Source_Tax_Item_Order_API.Remove_Tax_Items(company_,
                                                    Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                    rec_.order_no, 
                                                    rec_.line_no, 
                                                    rec_.rel_no, 
                                                    rec_.line_item_no, 
                                                    '*');
      END IF;                                           
   END IF;                                           
END Customer_Order_Structure_Cust_Order_Line_New___;

@Override
PROCEDURE Customer_Order_Structure_Line_Order_Charge_Copy_From_Header___(
   rec_        IN OUT NOCOPY Customer_Order_Structure_Line_Order_Charge_Rec,
   header_rec_ IN      Customer_Order_Structure_Cust_Order_Line_Rec)
IS
   sctrec_      Sales_Charge_Type_API.Public_Rec;
BEGIN
   rec_.order_no := header_rec_.order_no;
   rec_.line_no := header_rec_.line_no;
   rec_.rel_no := header_rec_.rel_no;
   rec_.line_item_no := header_rec_.line_item_no;   
   sctrec_ := Sales_Charge_Type_Api.Get(Customer_Order_API.Get_Contract(rec_.order_no), rec_.charge_type);
   
   IF rec_.charge_cost IS NULL THEN
      rec_.charge_cost := sctrec_.charge_cost;
   END IF;
   
   IF rec_.charge_cost_percent IS NULL THEN 
      rec_.charge_cost_percent := rec_.charge_cost_percent;
   END IF;
END Customer_Order_Structure_Line_Order_Charge_Copy_From_Header___;

@Override
PROCEDURE Customer_Order_Structure_Line_Order_Charge_New___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Line_Order_Charge_Rec)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
BEGIN
   Add_To_Attr_From_Rec___(rec_, attr_);
   Customer_Order_Charge_Api.New(info_, attr_);
   Add_To_Rec_From_Attr___(attr_, rec_);
   -- Add info
   rec_.info := Remove_Separators(info_);
END Customer_Order_Structure_Line_Order_Charge_New___;

@Override
PROCEDURE Customer_Order_Structure_Cust_Ord_Line_Discount_Copy_From_Header___(
   rec_        IN OUT NOCOPY Customer_Order_Structure_Cust_Ord_Line_Discount_Rec,
   header_rec_ IN            Customer_Order_Structure_Cust_Order_Line_Rec)
IS
BEGIN
   rec_.order_no := header_rec_.order_no;
   rec_.line_no := header_rec_.line_no;
   rec_.rel_no := header_rec_.rel_no;
   rec_.line_item_no := header_rec_.line_item_no;  
END Customer_Order_Structure_Cust_Ord_Line_Discount_Copy_From_Header___;

@Override
PROCEDURE Add_To_Attr_From_Rec___ (
   rec_  IN     Customer_Order_Structure_Cust_Ord_Line_Discount_Rec,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   discount_line_no_       NUMBER;
BEGIN
   super(rec_, attr_);
   discount_line_no_ := Cust_Order_Line_Discount_API.Get_Last_Discount_Line_No(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no) + 1;
   Client_SYS.Add_To_Attr('DISCOUNT_LINE_NO', discount_line_no_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_DB', 'MANUAL', attr_);
   
   IF (rec_.create_partial_sum IS NULL) THEN
      Client_SYS.Add_To_Attr('CREATE_PARTIAL_SUM_DB', 'NOT PARTIAL SUM', attr_);
   END IF;
END Add_To_Attr_From_Rec___;

@Override
PROCEDURE Create_Customer_Order_Structure_Cust_Ord_Line_Discount_Rec___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Cust_Ord_Line_Discount_Rec)
IS
BEGIN
   super(rec_);
   Cust_Order_Line_Discount_Api.Calc_Discount_Upd_Co_Line__(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
END Create_Customer_Order_Structure_Cust_Ord_Line_Discount_Rec___;

@Override
PROCEDURE Customer_Order_Structure_Line_Address_Copy_From_Header___(
   rec_        IN OUT NOCOPY Customer_Order_Structure_Line_Address_Rec,
   header_rec_ IN      Customer_Order_Structure_Cust_Order_Line_Rec)
IS
BEGIN
   -- Add single occurrence address if present
   IF UPPER(header_rec_.addr_flag) = 'Y' THEN
      rec_.order_no := header_rec_.order_no;
      rec_.line_no := header_rec_.line_no;
      rec_.rel_no := header_rec_.rel_no;
      rec_.line_item_no := header_rec_.line_item_no;
   ELSE
      rec_.order_no := NULL;
   END IF;
END Customer_Order_Structure_Line_Address_Copy_From_Header___;

@Override
PROCEDURE Create_Customer_Order_Structure_Line_Address_Rec___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Line_Address_Rec)
IS
BEGIN
   IF rec_.order_no IS NOT NULL THEN
      super(rec_);
   END IF;
END Create_Customer_Order_Structure_Line_Address_Rec___;

@Override
PROCEDURE Customer_Order_Structure_Source_Tax_Item_Ord_Copy_From_Header___(
   rec_        IN OUT NOCOPY Customer_Order_Structure_Source_Tax_Item_Ord_Rec,
   header_rec_ IN      Customer_Order_Structure_Cust_Order_Line_Rec)
IS
BEGIN
   rec_.source_ref1 := header_rec_.order_no;
   rec_.source_ref2 := header_rec_.line_no;
   rec_.source_ref3 := header_rec_.rel_no;
   rec_.source_ref4 := header_rec_.line_item_no;
   rec_.source_ref5 := '*';
END Customer_Order_Structure_Source_Tax_Item_Ord_Copy_From_Header___;

@Override
PROCEDURE Customer_Order_Structure_Source_Tax_Item_Ord_New___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Source_Tax_Item_Ord_Rec)
IS
   company_                      VARCHAR2(100);
   tax_base_curr_amount_         NUMBER;
   tax_base_dom_amount_          NUMBER;
   source_key_rec_               Tax_Handling_Util_API.source_key_rec;
   tax_info_table_               Tax_Handling_Util_API.tax_information_table;
   attr_                         VARCHAR2(2000);
   ord_line_rec_                 Customer_Order_Line_API.Public_Rec;
   calc_tax_percentage_          NUMBER;
   calc_tax_curr_amount_         NUMBER;
   calc_tax_dom_amount_          NUMBER;
   calc_total_tax_curr_amount_   NUMBER;
   dummy_number_                 NUMBER;
   conversion_factor_            NUMBER;
   currency_code_                VARCHAR2(3);
BEGIN
   ord_line_rec_ := Customer_Order_Line_API.Get(rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, rec_.source_ref4);
   currency_code_ := Customer_Order_API.Get_Currency_Code(rec_.source_ref1);
   company_  := Site_API.Get_Company(Customer_Order_API.Get_Contract(rec_.source_ref1));                 
   tax_base_curr_amount_ := Customer_Order_Line_API.Get_Sale_Price_Total(rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, rec_.source_ref4);
   tax_base_dom_amount_  := Customer_Order_Line_API.Get_Base_Sale_Price_Total(rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, rec_.source_ref4);
      
   -- Check which value that is supplied, percent or amount
   IF (rec_.tax_percentage IS NOT NULL) THEN
      calc_tax_percentage_ := rec_.tax_percentage;
      Tax_Handling_Util_API.Calc_Tax_Curr_Amount(total_tax_curr_amount_    => calc_total_tax_curr_amount_,
                                                 tax_curr_amount_          => calc_tax_curr_amount_,
                                                 non_ded_tax_curr_amount_  => dummy_number_,
                                                 attr_                     => attr_,
                                                 company_                  => ord_line_rec_.company,
                                                 identity_                 => ord_line_rec_.customer_no,
                                                 party_type_db_            => 'CUSTOMER',
                                                 currency_                 => currency_code_,
                                                 delivery_address_id_      => ord_line_rec_.ship_addr_no,
                                                 tax_code_                 => rec_.tax_code,
                                                 tax_type_db_              => 'TAX',
                                                 tax_calc_base_amount_     => tax_base_curr_amount_,
                                                 tax_calc_base_percent_    => 100, 
                                                 use_tax_calc_base_amount_ => tax_base_curr_amount_,
                                                 tax_percentage_           => calc_tax_percentage_,
                                                 in_deductible_factor_     => 1);
   ELSIF (tax_base_curr_amount_ != 0 AND rec_.tax_amount IS NOT NULL) THEN
      calc_tax_percentage_ := rec_.tax_amount * 100/tax_base_curr_amount_;
   END IF;

   Tax_Handling_Util_API.Calc_Tax_Dom_Amount(total_tax_dom_amount_      => dummy_number_,
                                             tax_dom_amount_            => calc_tax_dom_amount_,
                                             non_ded_tax_dom_amount_    => dummy_number_,
                                             tax_base_dom_amount_       => tax_base_dom_amount_,
                                             attr_                      => attr_,
                                             company_                   => ord_line_rec_.company,
                                             currency_                  => Customer_Order_API.Get_Currency_Code(rec_.source_ref1),
                                             use_specific_rate_         => 'FALSE',
                                             tax_code_                  => rec_.tax_code,
                                             total_tax_curr_amount_     => calc_total_tax_curr_amount_,
                                             tax_curr_amount_           => NVL(rec_.tax_amount, calc_tax_curr_amount_),
                                             tax_base_curr_amount_      => tax_base_curr_amount_,
                                             tax_percentage_            => calc_tax_percentage_,
                                             in_deductible_factor_      => 1,
                                             curr_rate_                 => ord_line_rec_.currency_rate,
                                             conv_factor_               => conversion_factor_);

   source_key_rec_ := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_ => Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                                  source_ref1_     => rec_.source_ref1,
                                                                  source_ref2_     => rec_.source_ref2,
                                                                  source_ref3_     => rec_.source_ref3,
                                                                  source_ref4_     => rec_.source_ref4,
                                                                  source_ref5_     => '*',
                                                                  attr_            => attr_);

   -- Set up the tax infor table
   tax_info_table_(1).tax_code := rec_.tax_code;
   tax_info_table_(1).tax_percentage := calc_tax_percentage_;
   tax_info_table_(1).tax_curr_amount := NVL(rec_.tax_amount, calc_tax_curr_amount_);
   tax_info_table_(1).tax_dom_amount := calc_tax_dom_amount_;
   tax_info_table_(1).tax_calc_structure_id := ord_line_rec_.tax_calc_structure_id;
   tax_info_table_(1).tax_base_curr_amount := tax_base_curr_amount_;
   tax_info_table_(1).tax_base_dom_amount := tax_base_dom_amount_;

   Source_Tax_Item_Order_API.Create_Tax_Items(tax_info_table_ => tax_info_table_,
                                              source_key_rec_ => source_key_rec_,
                                              company_        => company_);

   Tax_Handling_Order_Util_API.Modify_Source_Tax_Info(company_         => company_,
                                                      source_ref_type_ => Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                      source_ref1_     => rec_.source_ref1,
                                                      source_ref2_     => rec_.source_ref2,
                                                      source_ref3_     => rec_.source_ref3,
                                                      source_ref4_     => rec_.source_ref4,
                                                      source_ref5_     => '*');
   
END Customer_Order_Structure_Source_Tax_Item_Ord_New___;

@Override
PROCEDURE Create_Customer_Order_Structure_Rec___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Rec)
IS
BEGIN
   
   super(rec_);
   
   IF (rec_.attributes IS NOT NULL AND rec_.attributes.count > 0) THEN
      FOR i IN rec_.attributes.first .. rec_.attributes.last LOOP
         rec_.attributes(i).order_no := rec_.order_no;
      END LOOP;
      
      Add_Order_Attributes___(rec_.attributes);
   END IF;
END Create_Customer_Order_Structure_Rec___;

@Override
PROCEDURE Create_Customer_Order_Structure_Cust_Order_Line_Rec___ (
   rec_ IN OUT NOCOPY Customer_Order_Structure_Cust_Order_Line_Rec)
IS
BEGIN
   super(rec_);
   
   -- Add additional attributes
   IF (rec_.line_attributes IS NOT NULL AND rec_.line_attributes.count > 0) THEN
      FOR i IN rec_.line_attributes.first .. rec_.line_attributes.last LOOP
         rec_.line_attributes(i).order_no := rec_.order_no;
         rec_.line_attributes(i).line_no := rec_.line_no;
         rec_.line_attributes(i).rel_no := rec_.rel_no;
         rec_.line_attributes(i).line_item_no := rec_.line_item_no;
      END LOOP;
      
      Add_Line_Attributes___(rec_.line_attributes);
   END IF;
END;

-- Add_Line_Attribute
--   Use this method to handle optional order header attributes.
--   It is called once for every attribute if there is an array.
PROCEDURE Add_Order_Attributes___ (
   attribute_arr_    IN Customer_Order_Structure_Header_Attribute_Arr)
IS
   name_       VARCHAR2(100);
   value_      VARCHAR2(4000);
   attr_       VARCHAR2(4000);
   info_       VARCHAR2(4000);
BEGIN
   FOR i IN attribute_arr_.first .. attribute_arr_.last LOOP
      name_ := attribute_arr_(i).name;
      value_ := attribute_arr_(i).value;
      -- Test code
      IF (name_ = 'TEST_NAME') THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('NOTE_TEXT', value_, attr_);
         Customer_Order_API.Modify(info_, attr_, attribute_arr_(i).order_no);
      END IF;
   END LOOP;
END Add_Order_Attributes___;

-- Add_Line_Attribute
--   Use this method to handle optional order line attributes.
--   It is called once for every attribute if there is an array.
PROCEDURE Add_Line_Attributes___ (
   attribute_arr_    IN Customer_Order_Structure_Line_Attribute_Arr )
IS
BEGIN
   NULL;
END Add_Line_Attributes___;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Customer_Order_Overview (
   request_ IN Customer_Order_Overview_Query_Structure_Rec ) RETURN Order_Header_Structure_Arr
IS
   TYPE Get_Order_List  IS REF CURSOR;
   get_order_list_      Get_Order_List;
   TYPE Order_List_Tab  IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   order_list_tab_      Order_List_Tab;
   return_arr_          Order_Header_Structure_Arr := Order_Header_Structure_Arr();
   stmt_                VARCHAR2(32000);
   error_text_          VARCHAR2(20000);
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      BEGIN
         stmt_ := 'SELECT order_no FROM CUSTOMER_ORDER ';

         IF (request_.customer_no IS NOT NULL) THEN
            stmt_ := stmt_ || ' WHERE customer_no = :customer_no ';
         ELSE
            stmt_ := stmt_ || ' WHERE :customer_no IS NULL ';
         END IF;

         IF (request_.customer_no_pay IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND customer_no_pay = :customer_no_pay ';
         ELSE
            stmt_ := stmt_ || ' AND :customer_no_pay IS NULL ';
         END IF;

         IF (request_.site IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND contract = :site ';
         ELSE
            stmt_ := stmt_ || ' AND :site IS NULL ';
         END IF;

         IF (request_.order_no IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND order_no LIKE :order_no ';
         ELSE
            stmt_ := stmt_ || ' AND :order_no IS NULL ';
         END IF;

         IF (request_.customer_po_no IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND customer_po_no LIKE :customer_po_no ';
         ELSE
            stmt_ := stmt_ || ' AND :customer_po_no IS NULL ';
         END IF;

         IF (request_.customer_ref IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND UPPER(cust_ref) LIKE UPPER(:customer_ref) ';
         ELSE
            stmt_ := stmt_ || ' AND :cust_ref IS NULL ';
         END IF;

         IF (request_.external_ref IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND external_ref LIKE :external_ref ';
         ELSE
            stmt_ := stmt_ || ' AND :external_ref IS NULL ';
         END IF;

         IF request_.max_records IS NOT NULL THEN
            stmt_ := ' SELECT * FROM ( ' || stmt_ || ' ) WHERE ROWNUM <= :max_records';
         ELSE
            stmt_ := ' SELECT * FROM ( ' || stmt_ || ' ) WHERE :max_records IS NULL';
         END IF;

         @ApproveDynamicStatement(2020-05-11,ERLISE)
         OPEN  get_order_list_ FOR stmt_ USING request_.customer_no, 
                                               request_.customer_no_pay, 
                                               request_.site, 
                                               request_.order_no, 
                                               request_.customer_po_no, 
                                               request_.customer_ref, 
                                               request_.external_ref,
                                               request_.max_records;

         FETCH get_order_list_ BULK COLLECT INTO order_list_tab_;
         CLOSE get_order_list_;

         IF order_list_tab_.COUNT > 0 THEN
            FOR i IN order_list_tab_.FIRST..order_list_tab_.LAST LOOP
               return_arr_.EXTEND;
               return_arr_(return_arr_.LAST) := Get_Order_Header_Structure_Rec___(order_list_tab_(i));
            END LOOP;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            IF return_arr_.COUNT = 0 THEN
               return_arr_.EXTEND;
            END IF;
            error_text_ := sqlerrm;
            return_arr_(return_arr_.LAST).error_text := error_text_;
      END;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
   
   RETURN return_arr_;
END Get_Customer_Order_Overview;


FUNCTION Get_Customer_Order (
   request_ IN Customer_Order_Query_Structure_Rec ) RETURN Order_Structure_Rec
IS
   order_rec_     Order_Structure_Rec; 
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      order_rec_ := Get_Order_Structure_Rec___(request_.order_no);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
   
   RETURN order_rec_;
END Get_Customer_Order;

FUNCTION Create_Customer_Order (
   order_request_ IN Customer_Order_Structure_Rec) RETURN Order_Response_Structure_Rec
IS
   response_rec_        Order_Response_Structure_Rec;
   order_rec_           Customer_Order_Structure_Rec;
   charge_info_         VARCHAR2(20000);
   error_message_       VARCHAR2(20000);
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      BEGIN
         order_rec_ := order_request_;
         Create_Customer_Order_Structure_Rec___(order_rec_);

         IF (order_rec_.charges IS NOT NULL AND order_rec_.charges.count > 0) THEN
            FOR i IN order_rec_.charges.first .. order_rec_.charges.last LOOP
               charge_info_ := charge_info_ || order_rec_.charges(i). info;
            END LOOP;
         END IF;
         -- Add order header data to the response structure
         response_rec_.order_no := order_rec_.order_no;
         response_rec_.site := Customer_Order_API.Get_Contract(order_rec_.order_no);
         response_rec_.info := order_rec_.info || charge_info_;
         response_rec_.order_created := true;
         response_rec_.lines := Get_Line_Response_Arr___(order_rec_);
      EXCEPTION
         WHEN OTHERS THEN
            @ApproveTransactionStatement(2021-06-16,NiDalk)
            rollback;
            error_message_ := sqlerrm;
            response_rec_.error_message := error_message_;
      END;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
   
   RETURN response_rec_;
END Create_Customer_Order;

FUNCTION Remove_Separators (
   info_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_ VARCHAR2(4000);
BEGIN
   result_ := info_;
   -- Replace the field separators with a semicolon.
   result_ := REPLACE(result_, Client_SYS.field_separator_, ': ');
   -- Replace the record separators with a space.
   result_ := REPLACE(result_, Client_SYS.record_separator_, ' ');
   RETURN result_;
END Remove_Separators;
