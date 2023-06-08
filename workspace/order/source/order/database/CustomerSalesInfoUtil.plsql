-----------------------------------------------------------------------------
--
--  Logical unit: CustomerSalesInfoUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210708  ChBnlk  SC21R2-1775, Modified Get_Customers by adding null check for the collection customer_list_tab_.
--  210707  ChBnlk  SC21R2-1394, Modified Get_Customers() to handle exeption when no record is returning.
--  210707  NiDalk  SC21R2-1723, Modified Create_Customer to correct mandatory value issues. 
--  210628  ChBnlk  SC21R2-1413, Modified Get_Customers() to handle the exception.
--  210616  ChBnlk  SC21R2-1413, Modified Create_Customer() to handle the exception.
--  210125  DhAplk  SC2020R1-12242, Added is_json_ to Post_Outbound_Message() method call in Send_Customer.
--  210113  NiDalk  SC2020R1-11411, Removes temporary correction done for DXDEV-855
--  210108  MiKulk  SC2020R1-11275, set DefaultLanguage of the created customer  in Create_Customer.
--  201103  DhAplk  SC2020R1-11226, Changed DefaultLanguageDb, CountryDb attributes names as DefaultLanguageCode, CountryCode in Create_Customer().
--  200831  MiKulk  SC2020R1-207, SC2020R1-208 Added method to support Get_Customers and Send_Customers.
--  200722  MiKulk  SC2020R1-206 - Moved the logic from the ORDSRV component.
-----------------------------------------------------------------------------
layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
-- Get_Customer_Status
--   Use this method to add a status to the message.
--   Base the result on any business logic of choice.
@UncheckedAccess
FUNCTION Get_Customer_Status (
   customer_no_ IN VARCHAR2) RETURN VARCHAR2

IS
   temp_ VARCHAR2(5) := 'TRUE';   
BEGIN
   -- Add logic to fetch the appropriate value to be used. For example, this could be a value from a custom field or similar.
   return temp_;
END Get_Customer_Status;

-----------------------------------------------------------------------------
-- Create_Customer
--    Create a new customer using the template customer.
-----------------------------------------------------------------------------
PROCEDURE Create_Customer (
   created_customer_struct_rec_ OUT Created_Customer_Struct_Rec,
	create_customer_params_      IN Customer_Struct_Rec) 
IS
   contract_              VARCHAR2(5);
   comm_id_               NUMBER;
   new_customer_id_       VARCHAR2(20);   
   del_address_id_        VARCHAR2(50);
   doc_address_id_        VARCHAR2(50);
   error_message_         VARCHAR2(20000);
   document_address_      Customer_Address_Struct_Rec;
   delivery_address_      Customer_Address_Struct_Rec;
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      BEGIN
         IF create_customer_params_.customer_template_id IS NULL THEN
            Error_SYS.Record_General(lu_name_, 'NOCUSTOMERTEMPLATE: Customer Template ID requires a value.');
         END IF;
         
         new_customer_id_ := UPPER(create_customer_params_.customer_no);   
         -- Check if customer already exists in database
         IF Customer_Info_API.Check_Exist(new_customer_id_) = 'TRUE' THEN         
            created_customer_struct_rec_.customer_created := 'FALSE'; 
         ELSE
            contract_ := Cust_Ord_Customer_API.Get_Edi_Site(create_customer_params_.customer_template_id);
            
            IF create_customer_params_.document_address IS NOT NULL AND create_customer_params_.document_address.COUNT > 0 THEN
               document_address_ := create_customer_params_.document_address(1);
            END IF;
            
            IF create_customer_params_.delivery_address IS NOT NULL AND create_customer_params_.delivery_address.COUNT > 0 THEN
               delivery_address_ := create_customer_params_.delivery_address(1);
            END IF;
            
            Cust_Ord_Customer_API.New_Customer_From_Template( new_customer_id_,
                                                              create_customer_params_.customer_template_id,
                                                              Site_API.Get_Company(contract_),
                                                              create_customer_params_.customer_name,
                                                              create_customer_params_.association_no,
                                                              cust_ref_             => NULL,
                                                              customer_category_    => 'Customer',
                                                              default_language_     => Iso_Language_API.Decode(create_customer_params_.default_language_code),
                                                              new_country_          => NULL,
                                                              del_addr_no_          => NULL,
                                                              del_name_             => delivery_address_.address_customer_name,
                                                              del_address1_         => delivery_address_.street,
                                                              del_address2_         => delivery_address_.address2,
                                                              del_address3_         => NULL,
                                                              del_address4_         => NULL,
                                                              del_address5_         => NULL,
                                                              del_address6_         => NULL,
                                                              del_zip_code_         => delivery_address_.zip_code,
                                                              del_city_             => delivery_address_.city,
                                                              del_state_            => delivery_address_.state,
                                                              del_county_           => delivery_address_.county,
                                                              del_country_          => Iso_Country_API.Decode(delivery_address_.country_code),
                                                              del_ean_location_     => delivery_address_.cust_own_address_id,
                                                              doc_addr_no_          => NULL,
                                                              doc_name_             => document_address_.address_customer_name,
                                                              doc_address1_         => document_address_.street,
                                                              doc_address2_         => document_address_.address2,
                                                              doc_address3_         => NULL,
                                                              doc_address4_         => NULL,
                                                              doc_address5_         => NULL,
                                                              doc_address6_         => NULL,
                                                              doc_zip_code_         => document_address_.zip_code,
                                                              doc_city_             => document_address_.city,
                                                              doc_state_            => document_address_.state,
                                                              doc_county_           => document_address_.county,
                                                              doc_country_          => Iso_Country_API.Decode(document_address_.country_code),
                                                              doc_ean_location_     => document_address_.cust_own_address_id,
                                                              salesman_code_        => NULL,
                                                              ship_via_code_        => create_customer_params_.ship_via_code,
                                                              delivery_terms_       => NULL,
                                                              del_terms_location_   => NULL,
                                                              region_code_          => NULL,
                                                              district_code_        => NULL,
                                                              market_code_          => NULL,
                                                              pay_term_id_          => NULL,
                                                              acquisition_site_     => NULL,
                                                              is_internal_customer_ => 'FALSE',
                                                              cust_group_           => NULL,
                                                              currency_             => NULL);

            -- Comm Methods
            del_address_id_ := Cust_Ord_Customer_API.Get_Delivery_Address(new_customer_id_);
            doc_address_id_ := Cust_Ord_Customer_API.Get_Document_Address(new_customer_id_);
            -- Add comm methods for default delivery address
            IF del_address_id_ IS NOT NULL THEN
               IF delivery_address_.phone IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, delivery_address_.phone,'Phone', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('PHONE'), del_address_id_);
               END IF;
               IF delivery_address_.mobile_phone IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, delivery_address_.mobile_phone, 'Mobile Phone', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('MOBILE'), del_address_id_);
               END IF;
               IF delivery_address_.fax IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, delivery_address_.fax, 'Fax', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('FAX'), del_address_id_);
               END IF;
               IF delivery_address_.email IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, delivery_address_.email,'E-Mail', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('E_MAIL'), del_address_id_);
               END IF;
               IF delivery_address_.web_address IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, delivery_address_.web_address, 'Web Address', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('WWW'), del_address_id_);
               END IF;
            END IF;
            -- Add comm methods for default document address
            IF doc_address_id_ IS NOT NULL THEN
                IF document_address_.phone IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, document_address_.phone,'Phone', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('PHONE'), doc_address_id_);
               END IF;
               IF document_address_.mobile_phone IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, document_address_.mobile_phone, 'Mobile Phone', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('MOBILE'), doc_address_id_);
               END IF;
               IF document_address_.fax IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, document_address_.fax, 'Fax', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('FAX'), doc_address_id_);
               END IF;
               IF document_address_.email IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, document_address_.email,'E-Mail', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('E_MAIL'), doc_address_id_);
               END IF;
               IF document_address_.web_address IS NOT NULL THEN
                  Comm_Method_API.New(comm_id_, 'CUSTOMER', new_customer_id_, document_address_.web_address, 'Web Address', NULL, NULL, NULL, NULL, NULL, Comm_Method_Code_API.Decode('WWW'), doc_address_id_);
               END IF;
            END IF;     
            created_customer_struct_rec_.customer_created := 'TRUE'; 
            created_customer_struct_rec_.customer_no := new_customer_id_; 
            created_customer_struct_rec_.association_no := create_customer_params_.association_no;
            created_customer_struct_rec_.customer_name := create_customer_params_.customer_name;
            created_customer_struct_rec_.del_address_id := del_address_id_;
            created_customer_struct_rec_.doc_address_id := doc_address_id_; 
            created_customer_struct_rec_.default_language_code := Customer_Info_API.Get_Default_Language_Db(new_customer_id_);
         END IF;  
         
      EXCEPTION
         WHEN OTHERS THEN
            @ApproveTransactionStatement(2021-06-16,ChBnLK)
            ROLLBACK;
            error_message_ := sqlerrm;
            created_customer_struct_rec_.error_text := error_message_;
      END;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF; 
END Create_Customer;


FUNCTION  Get_Customers (
   customer_params_ IN Customer_Sales_Info_Util_API.Customer_Params_Struct_Rec) RETURN Customer_Sales_Info_Util_API.Cust_Ord_Customer_Struct_Arr
IS
   return_arr_              Cust_Ord_Customer_Struct_Arr := Cust_Ord_Customer_Struct_Arr();
   stmt_                    VARCHAR2(32000);
   TYPE Get_Cutomer_List    IS REF CURSOR;
   get_customer_list_       Get_Cutomer_List;
   TYPE customer_List_Tab   IS TABLE OF VARCHAR2(20) INDEX BY PLS_INTEGER;
   customer_list_tab_       customer_List_Tab;   
   error_text_              VARCHAR2(20000);
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      BEGIN
         stmt_ := 'SELECT customer_no FROM CUST_ORD_CUSTOMER ';

         IF (customer_params_.customer_no IS NOT NULL) THEN
            stmt_ := stmt_ || ' WHERE customer_no LIKE UPPER(:customer_no_) ';
         ELSE
            stmt_ := stmt_ || ' WHERE :customer_no_ IS NULL ';
         END IF;

         IF (customer_params_.customer_group IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND Cust_Grp LIKE UPPER(:customer_group_) ';
         ELSE
            stmt_ := stmt_ || ' AND :customer_group_ IS NULL ';
         END IF;

         IF (customer_params_.cust_grp_in_condition IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND cust_grp IN (select regexp_substr(:cust_grp_in_condition_,''[^,]+'', 1, level) from dual 
                                connect by regexp_substr(:cust_grp_in_condition_, ''[^,]+'', 1, level) is not null) ' ;

         ELSE
            stmt_ := stmt_ || ' AND :Cust_Grp_in_condition_ IS NULL AND :Cust_Grp_in_condition_ IS NULL ';

         END IF;   

         IF (customer_params_.cust_price_group_id IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND cust_price_group_id LIKE UPPER (:cust_price_group_id_) ';
         ELSE
            stmt_ := stmt_ || ' AND :cust_price_group_id_ IS NULL ';
         END IF;

         IF (customer_params_.cust_price_grp_in_condition IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND cust_price_Group_id IN (select regexp_substr(:cust_price_grp_in_condition_,''[^,]+'', 1, level) from dual 
                                connect by regexp_substr(:cust_price_grp_in_condition_, ''[^,]+'', 1, level) is not null) ' ;
         ELSE                    
            stmt_ := stmt_ || ' AND :cust_price_grp_in_condition_ IS NULL AND :cust_price_grp_in_condition_ IS NULL ' ;
         END IF;

         IF (customer_params_.changed_since_number_of_days IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND objversion > to_char(sysdate - :changed_since_number_of_days_, ''YYYYMMDDHH24MISS'' ) ';
         ELSE
            stmt_ := stmt_ || ' AND :changed_since_number_of_days_ IS NULL ';
         END IF;

         IF (customer_params_.include_expired_customers IS NULL OR UPPER(customer_params_.include_expired_customers) = 'FALSE') THEN
            stmt_ := stmt_ || ' AND (date_del > SYSDATE OR date_del IS NULL) ';    
         END IF;

         @ApproveDynamicStatement(2020-07-28,MIKULK)   
         OPEN get_customer_list_ FOR stmt_ USING customer_params_.customer_no, 
                                                 customer_params_.customer_group, 
                                                 customer_params_.cust_grp_in_condition, 
                                                 customer_params_.cust_grp_in_condition,
                                                 customer_params_.cust_price_group_id,
                                                 customer_params_.cust_price_grp_in_condition,
                                                 customer_params_.cust_price_grp_in_condition, 
                                                 customer_params_.changed_since_number_of_days;


         FETCH get_customer_list_ BULK COLLECT INTO customer_list_tab_;
         CLOSE get_customer_list_;

         IF ((customer_list_tab_ IS NOT NULL) AND (customer_list_tab_.COUNT > 0)) THEN
            FOR i IN customer_list_tab_.FIRST..customer_list_tab_.LAST LOOP
               return_arr_.EXTEND;
               return_arr_(return_arr_.LAST) := Get_Cust_Ord_Customer_Struct_Rec___(customer_list_tab_(i));

               IF  UPPER(customer_params_.include_cust_agreement) = 'FALSE' OR customer_params_.include_cust_agreement IS NULL THEN
                   return_arr_(return_arr_.LAST).agreements := Cust_Ord_Customer_Struct_Customer_Agreement_Arr();
               END IF;

               IF UPPER(customer_params_.include_cust_info_contact) = 'FALSE' OR customer_params_.include_cust_info_contact IS NULL THEN
                  return_arr_(return_arr_.LAST).Contacts := Cust_Ord_Customer_Struct_Customer_Info_Header_Contact_Arr();
                END IF;

               IF UPPER(customer_params_.include_cust_info_comm)  = 'FALSE' OR customer_params_.include_cust_info_comm IS NULL THEN
                   return_arr_(return_arr_.LAST).Comm_Methods := Cust_Ord_Customer_Struct_Comm_Method_For_Customer_Arr();            
               END IF;

               IF UPPER(customer_params_.include_price_list) = 'FALSE' OR customer_params_.include_price_list IS NULL THEN
                   return_arr_(return_arr_.LAST).Price_Lists := Cust_Ord_Customer_Struct_Customer_Pricelist_Arr();
               END IF;

               IF UPPER(customer_params_.include_addresses) = 'FALSE' OR customer_params_.include_addresses IS NULL THEN
                  return_arr_(return_arr_.LAST).Addresses := Cust_Ord_Customer_Struct_Customer_Info_Address_Arr();
               END IF;

               IF (UPPER(customer_params_.include_attributes) = 'TRUE') THEN
                  -- Use either Get_Attribute_Structure_Arr___ or generated Get_Cust_Ord_Customer_Struct_Customer_Attribute_Struct_Arr___ to fetch attribute values
                  return_arr_(return_arr_.LAST).attributes := Get_Attribute_Structure_Arr___(customer_list_tab_(i));   
               ELSE
                  return_arr_(return_arr_.LAST).attributes := Cust_Ord_Customer_Struct_Customer_Attribute_Struct_Arr();
               END IF;

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
END Get_Customers;

PROCEDURE Send_Customer (
   receiver_routing_parameter_   IN VARCHAR2,
   customer_no_                  IN VARCHAR2,
   customer_group_               IN VARCHAR2,
   cust_price_group_id_          IN VARCHAR2,
   cust_grp_in_condition_        IN VARCHAR2,
   cust_price_grp_in_condition_  IN VARCHAR2,
   include_cust_agreement_       IN VARCHAR2,
   include_cust_info_contact_    IN VARCHAR2,
   include_price_list_           IN VARCHAR2,
   include_cust_info_comm_       IN VARCHAR2,
   changed_since_no_of_days_     IN VARCHAR2,
   include_expired_customers_    IN VARCHAR2,
   include_addresses_            IN VARCHAR2,
   include_attributes_           IN VARCHAR2 )
   
IS
   customer_params_  Customer_Sales_Info_Util_API.Customer_Params_Struct_Rec;
   customer_arr_     Customer_Sales_Info_Util_API.Cust_Ord_Customer_Struct_Arr;
   json_obj_         JSON_OBJECT_T;
   json_clob_        CLOB;      
   msg_id_           NUMBER;
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      IF (customer_no_ IS NOT NULL) THEN
         customer_params_.customer_no := customer_no_;
      END IF;

      IF (customer_group_ IS NOT NULL) THEN
         customer_params_.customer_group := customer_group_;      
      ELSIF (cust_grp_in_condition_ IS NOT NULL) THEN
         customer_params_.cust_grp_in_condition := cust_grp_in_condition_;
      END IF;

      IF (cust_price_group_id_ IS NOT NULL) THEN
         customer_params_.cust_price_group_id := cust_price_group_id_;
      ELSIF (cust_price_grp_in_condition_ IS NOT NULL) THEN
         customer_params_.cust_price_grp_in_condition := cust_price_grp_in_condition_;
      END IF;

      IF include_cust_agreement_ IS NOT NULL THEN
         customer_params_.include_cust_agreement := UPPER(include_cust_agreement_);
      END IF;

      IF include_cust_info_contact_ IS NOT NULL THEN
         customer_params_.include_cust_info_contact := UPPER(include_cust_info_contact_);
      END IF;

      IF include_price_list_ IS NOT NULL THEN
         customer_params_.include_price_list := UPPER(include_price_list_);
      END IF;

      IF include_cust_info_comm_ IS NOT NULL THEN
         customer_params_.include_cust_info_comm := UPPER(include_cust_info_comm_);
      END IF;

      IF (changed_since_no_of_days_ > 0) THEN
         customer_params_.changed_since_number_of_days := changed_since_no_of_days_;
      END IF;

      IF (UPPER(include_expired_customers_) = 'TRUE') THEN
         customer_params_.include_expired_customers :=  'TRUE';
      END IF;

      IF (UPPER(include_addresses_) = 'TRUE') THEN
         customer_params_.include_addresses := 'TRUE';
      END IF;

      IF (include_attributes_ IS NOT NULL) THEN
         customer_params_.include_attributes :=  include_attributes_;
      END IF;

      customer_arr_ := Get_Customers(customer_params_);

      json_obj_ := Cust_Ord_Customer_Struct_Arr_To_Json___(customer_arr_);
      json_clob_ := json_obj_.to_clob;

      Plsqlap_Server_API.Post_Outbound_Message(json_clob_,
                                               msg_id_,                                              
                                               null, 
                                               receiver_routing_parameter_, 
                                               message_type_ => 'APPLICATION_MESSAGE',                                               
                                               message_function_ => 'SEND_CUSTOMERS',
                                               is_json_ => true);   
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;   
END Send_Customer;

-----------------------------------------------------------------------------
-- Get_Attribute_Structure_Arr___
--   Use this method to add named attribute/value pairs to the attribute section of the message.
--   Add code according to the example below to add name/value pairs to the return array.
--   This is then automatically handled and the attribute section of the message will contain a list of the added atttributes.
-----------------------------------------------------------------------------
FUNCTION Get_Attribute_Structure_Arr___ (
   customer_no_   IN VARCHAR2) RETURN Cust_Ord_Customer_Struct_Customer_Attribute_Struct_Arr
IS
   return_arr_ Cust_Ord_Customer_Struct_Customer_Attribute_Struct_Arr := Cust_Ord_Customer_Struct_Customer_Attribute_Struct_Arr();
BEGIN
   -- Add first attribute example
   return_arr_.extend;
   return_arr_(return_arr_.last).customer_no := customer_no_;
   return_arr_(return_arr_.last).attribute_name := 'EXAMPLE_NAME1';
   return_arr_(return_arr_.last).attribute_value := 'EXAMPLE_VALUE1';
   -- Add second attribute example
   return_arr_.extend;
   return_arr_(return_arr_.last).customer_no := customer_no_;
   return_arr_(return_arr_.last).attribute_name := 'EXAMPLE_NAME2';
   return_arr_(return_arr_.last).attribute_value := 'EXAMPLE_VALUE2';
   
   RETURN return_arr_;
END Get_Attribute_Structure_Arr___;


