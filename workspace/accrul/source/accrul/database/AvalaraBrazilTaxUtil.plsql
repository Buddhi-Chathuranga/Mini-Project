-----------------------------------------------------------------------------
--
--  Logical unit: AvalaraBrazilTaxUtil
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210318  Utbalk  gelr:br_external_tax_integration, Added to support Global Extension Functionalities
--  210318  Utbalk  GEFALL20-3324, Added a method to invoke Tax Calculation REST endpoint.
--  210621  Utbalk  FI21R2-2484, Added Fetch_Access_Token___ and changed Invoke_Tax_Calc_Service___. 
--  210725  PraWlk  FI21R2-3250, Added business operation to Fetch_And_Calculate_Tax(), Invoke_Tax_Calc_Service___() and  
--  210725          Assign_Tax_Amount_Percentage___(). 
--  210810  PraWlk  FI21R2-3692, Modified Assign_Tax_Amount_Percentage___() to exclude mapping of avalara tax types 
--  210810          aproxtrib, aproxtribCity, aproxtribState and aproxtribFed with ifs tax type categories.
--  220610  MaEelk  SCDEV-6571, Modified Fetch_Locations___ to support Entity Information coming from Tax Document Line.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest TrivialFunction
PROCEDURE Invoke_Tax_Calc_Service___ (
   ext_tax_param_br_out_arr_  OUT External_Tax_System_Util_API.Ext_Tax_Param_Br_Out_Arr,
   complementary_info_        OUT VARCHAR2,
   business_operation_arr_    OUT External_Tax_System_Util_API.Business_Operation_Rec_Arr,
   json_payload_              IN  CLOB,
   company_                   IN  VARCHAR2 )
IS
   access_token_  CLOB;
   response_jo_   JSON_OBJECT_T;
   error_message_ VARCHAR2(2000);
   paylod_        CLOB := json_payload_;
BEGIN
   access_token_ := Fetch_Access_Token___;  
   IF (access_token_ IS NOT NULL) THEN
      -- call the endpoint synchronously
      Plsql_Rest_Sender_API.Call_Rest_Endpoint_Json_Sync(rest_service_        => 'AVALARA_BR_TAX_CALC_SERVICE',
                                                         json_                => paylod_,
                                                         http_method_         => 'POST',
                                                         http_req_headers_    => 'authorization:Bearer ' || access_token_,
                                                         sender_              => 'IFS_BR',
                                                         message_type_        => 'CONNECT',
                                                         accepted_res_codes_  => '200,400,401');
      response_jo_ := JSON_OBJECT_T.parse(paylod_);
      IF (response_jo_.get_Object('error') IS NOT NULL) THEN
         error_message_ := response_jo_.get_Object('error').get_String('message');
         Error_SYS.Record_General(lu_name_, 'AVATAXBREXTERNALERROR: Tax calculation service failed - :P1', error_message_);
      ELSE
         Assign_Tax_Amount_Percentage___(ext_tax_param_br_out_arr_, business_operation_arr_, response_jo_, company_);
         Assign_Complimentary_Information___(complementary_info_, response_jo_);
      END IF;
   END IF;
END Invoke_Tax_Calc_Service___;


FUNCTION Fetch_Access_Token___ RETURN CLOB
IS
   json_payload_        CLOB;
   response_jo_         JSON_OBJECT_T;
   access_token_        CLOB;
   error_message_       VARCHAR2(2000);
   ext_tax_param_rec_   Ext_Tax_System_Parameters_API.Public_Rec;
BEGIN
   ext_tax_param_rec_ := Ext_Tax_System_Parameters_API.Get(1);
   json_payload_ := '{
                      "grant_type": "client_credentials",
                      "client_secret": "' || ext_tax_param_rec_.client_secret_avalara_br || '", 
                      "client_id": "' || ext_tax_param_rec_.client_id_avalara_br || '",
                      "disableTokenRefresh": true
                     }';
   -- call the endpoint synchronously
   Plsql_Rest_Sender_API.Call_Rest_Endpoint_Json_Sync(rest_service_        => 'AVALARA_BR_AUTH_SERVICE',
                                                      json_                => json_payload_,
                                                      http_method_         => 'POST',
                                                      sender_              => 'IFS_BR',
                                                      message_type_        => 'CONNECT');
   response_jo_ := JSON_OBJECT_T.parse(json_payload_);
   access_token_ := response_jo_.get_String('access_token');
   IF (access_token_ IS NOT NULL) THEN     
      IF (access_token_ = Empty_Clob()) THEN
         Error_SYS.Record_General(lu_name_, 'AVATAXBREMPTYTOKEN: Received an empty token from the Avalara Authorization Server');
      END IF;
   ELSE
      error_message_ := response_jo_.get_String('error');
      IF (error_message_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'AVATAXBRAUTHERROR: Error Messege from the Avalara Authorization Server - :P1', error_message_);
      END IF;
   END IF;
   RETURN access_token_;     
END Fetch_Access_Token___;


@IgnoreUnitTest TrivialFunction
FUNCTION Fetch_Header___ (
   ext_tax_param_in_rec_ IN External_Tax_System_Util_API.Ext_Tax_Param_In_Rec ) RETURN Header_Base_Rec
IS
   company_address_id_          VARCHAR2(50);
   header_rec_                  Header_Base_Rec;
BEGIN
   company_address_id_  := Company_Address_API.Get_Default_Address(ext_tax_param_in_rec_.company, Address_Type_Code_API.Decode('INVOICE'));
   header_rec_.e_doc_creator_type        := 'self';
   header_rec_.amount_calc_type          := 'net';
   $IF Component_Invoic_SYS.INSTALLED $THEN
      header_rec_.company_location       := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, company_address_id_, Iso_Country_API.Decode('BR'), 'CNPJ');
   $END
   header_rec_.invoice_number            := ext_tax_param_in_rec_.avalara_brazil_specific.invoice_number;
   header_rec_.invoice_serial            := ext_tax_param_in_rec_.avalara_brazil_specific.invoice_serial;
   header_rec_.document_code             := ext_tax_param_in_rec_.avalara_brazil_specific.document_code;
   header_rec_.locations                 := Fetch_Locations___(ext_tax_param_in_rec_, company_address_id_, ext_tax_param_in_rec_.avalara_brazil_specific.ship_addr_no);
   header_rec_.invoices_refs             := Fetch_Invoice_Refs___(ext_tax_param_in_rec_);
   header_rec_.message_type              := 'goods';
   RETURN header_rec_;
END Fetch_Header___;


@IgnoreUnitTest TrivialFunction
FUNCTION Fetch_Locations___ (
   ext_tax_param_in_rec_ IN External_Tax_System_Util_API.Ext_Tax_Param_In_Rec,
   company_address_id_   IN VARCHAR2,
   customer_address_id_  IN VARCHAR2 ) RETURN Location_Rec
IS
   location_rec_               Location_Rec;
   location_entity_rec_        Avalara_Brazil_Tax_Util_API.Entity_Full_Data_For_Goods_Rec;
   location_establishment_rec_ Avalara_Brazil_Tax_Util_API.Entity_Full_Data_For_Goods_Rec;
   taxes_settings_rec_         Avalara_Brazil_Tax_Util_API.Taxes_Settings_For_Goods_Rec;
   address_info_rec_           Avalara_Brazil_Tax_Util_API.Address_Info_Rec;
   activity_sector_rec_        Avalara_Brazil_Tax_Util_API.Activity_Sector_Rec;
   cust_doc_addr_              Customer_Info_Address_API.Public_Rec;
BEGIN
   IF (ext_tax_param_in_rec_.source_type = 'TAX_DOCUMENT_LINE') THEN
      -- Entity (Site/Remote Warehouse)
      location_establishment_rec_.name := ext_tax_param_in_rec_.company;
      $IF Component_Invoic_SYS.INSTALLED $THEN
         location_entity_rec_.federal_tax_id := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, customer_address_id_, Iso_Country_API.Decode('BR'), 'CNPJ');
         location_entity_rec_.state_tax_id   := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, customer_address_id_, Iso_Country_API.Decode('BR'), 'STATE_REG');
         location_entity_rec_.suframa        := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, customer_address_id_, Iso_Country_API.Decode('BR'), 'SUFRAMA');
      $END
      location_entity_rec_.tax_regime := Business_Classification_API.Get_External_Tax_System_Ref(ext_tax_param_in_rec_.comp_del_country, Company_API.Get_Business_Classification(ext_tax_param_in_rec_.company));
      -- Entity > TaxesSettings
      IF (location_entity_rec_.state_tax_id IS NOT NULL) THEN
         taxes_settings_rec_.icms_tax_payer := 'true';
      ELSE
         taxes_settings_rec_.icms_tax_payer := 'false';
      END IF;
      location_entity_rec_.taxes_settings := taxes_settings_rec_;
      -- Entity > Address
      address_info_rec_ := NULL;
      address_info_rec_.street            := Company_Address_API.Get_Street(ext_tax_param_in_rec_.company, customer_address_id_);
      address_info_rec_.zipcode           := ext_tax_param_in_rec_.cust_del_zip_code;
      address_info_rec_.city_code         := City_Code_API.Get_Numeric_City_Code(ext_tax_param_in_rec_.cust_del_country, ext_tax_param_in_rec_.cust_del_state, ext_tax_param_in_rec_.cust_del_county, ext_tax_param_in_rec_.cust_del_city);
      address_info_rec_.city_name         := ext_tax_param_in_rec_.cust_del_city;
      address_info_rec_.state             := ext_tax_param_in_rec_.cust_del_state;
      address_info_rec_.country_code      := Alternate_Country_Code_API.Get_Alt_Country_Id(ext_tax_param_in_rec_.cust_del_country, 'BACEN');
      address_info_rec_.country           := Iso_Country_API.Get_Country_Code3(Iso_Country_API.Get_Country_Id(ext_tax_param_in_rec_.cust_del_country));
      location_entity_rec_.address   := address_info_rec_;
      -- Entity > ActivitySector
      activity_sector_rec_.type := 'cnae';
      $IF Component_Invoic_SYS.INSTALLED $THEN
         activity_sector_rec_.code := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, customer_address_id_, Iso_Country_API.Decode('BR'), 'CNAE');
      $END
      location_entity_rec_.activity_sector := activity_sector_rec_;
      location_rec_.entity := location_entity_rec_;
   ELSE   
      -- Entity (Customer information)
      location_entity_rec_.name           := ext_tax_param_in_rec_.identity;
      $IF Component_Invoic_SYS.INSTALLED $THEN
         location_entity_rec_.federal_tax_id := Customer_Addr_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.identity, customer_address_id_, ext_tax_param_in_rec_.company, 'BR', 'BR', 'CNPJ');
         location_entity_rec_.state_tax_id   := Customer_Addr_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.identity, customer_address_id_, ext_tax_param_in_rec_.company, 'BR', 'BR', 'STATE_REG');
         location_entity_rec_.suframa        := Customer_Addr_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.identity, customer_address_id_, ext_tax_param_in_rec_.company, 'BR', 'BR', 'SUFRAMA');
      $END
      location_entity_rec_.tax_regime        := Business_Classification_API.Get_External_Tax_System_Ref(ext_tax_param_in_rec_.cust_del_country, Customer_Info_API.Get_Business_Classification(ext_tax_param_in_rec_.identity));
      -- Entity > TaxesSettings
      $IF Component_Invoic_SYS.INSTALLED $THEN
         taxes_settings_rec_.icms_tax_payer := LOWER(Customer_Tax_Info_API.Get_Icms_Tax_Payer_Db(ext_tax_param_in_rec_.identity, customer_address_id_, ext_tax_param_in_rec_.company));
      $END
      location_entity_rec_.taxes_settings := taxes_settings_rec_;
      -- Entity > Address
      cust_doc_addr_ := Customer_Info_Address_API.Get(ext_tax_param_in_rec_.identity, ext_tax_param_in_rec_.avalara_brazil_specific.doc_addr_no);
      address_info_rec_.street       := cust_doc_addr_.address1;
      address_info_rec_.zipcode      := cust_doc_addr_.zip_code;
      address_info_rec_.city_code    := City_Code_API.Get_Numeric_City_Code(cust_doc_addr_.country, cust_doc_addr_.state, cust_doc_addr_.county, cust_doc_addr_.city);
      address_info_rec_.city_name    := cust_doc_addr_.city;
      address_info_rec_.state        := cust_doc_addr_.state;
      address_info_rec_.country_code := Alternate_Country_Code_API.Get_Alt_Country_Id(cust_doc_addr_.country, 'BACEN');
      address_info_rec_.country      := Iso_Country_API.Get_Country_Code3(Iso_Country_API.Get_Country_Id(cust_doc_addr_.country));
      location_entity_rec_.address   := address_info_rec_;
      -- Entity > ActivitySector
      activity_sector_rec_.type := 'cnae';
      $IF Component_Invoic_SYS.INSTALLED $THEN
         activity_sector_rec_.code := Customer_Addr_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.identity, customer_address_id_, ext_tax_param_in_rec_.company, 'BR', 'BR', 'CNAE');
      $END
      location_entity_rec_.activity_sector := activity_sector_rec_;
      location_rec_.entity := location_entity_rec_;
   END IF;
   -- Establishment (Company information)
   location_establishment_rec_.name := ext_tax_param_in_rec_.company;
   $IF Component_Invoic_SYS.INSTALLED $THEN
      location_establishment_rec_.federal_tax_id := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, company_address_id_, Iso_Country_API.Decode('BR'), 'CNPJ');
      location_establishment_rec_.state_tax_id   := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, company_address_id_, Iso_Country_API.Decode('BR'), 'STATE_REG');
      location_establishment_rec_.suframa        := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, company_address_id_, Iso_Country_API.Decode('BR'), 'SUFRAMA');
   $END
   location_establishment_rec_.tax_regime        := Business_Classification_API.Get_External_Tax_System_Ref(ext_tax_param_in_rec_.comp_del_country, Company_API.Get_Business_Classification(ext_tax_param_in_rec_.company));
   -- Establishment > TaxesSettings
   IF (location_establishment_rec_.state_tax_id IS NOT NULL) THEN
      taxes_settings_rec_.icms_tax_payer := 'true';
   ELSE
      taxes_settings_rec_.icms_tax_payer := 'false';
   END IF;
   location_establishment_rec_.taxes_settings := taxes_settings_rec_;
   -- Establishment > Address
   address_info_rec_ := NULL;
   address_info_rec_.street            := Company_Address_API.Get_Street(ext_tax_param_in_rec_.company, company_address_id_);
   address_info_rec_.zipcode           := ext_tax_param_in_rec_.comp_del_zip_code;
   address_info_rec_.city_code         := City_Code_API.Get_Numeric_City_Code(ext_tax_param_in_rec_.comp_del_country, ext_tax_param_in_rec_.comp_del_state, ext_tax_param_in_rec_.comp_del_county, ext_tax_param_in_rec_.comp_del_city);
   address_info_rec_.city_name         := ext_tax_param_in_rec_.comp_del_city;
   address_info_rec_.state             := ext_tax_param_in_rec_.comp_del_state;
   address_info_rec_.country_code      := Alternate_Country_Code_API.Get_Alt_Country_Id(ext_tax_param_in_rec_.comp_del_country, 'BACEN');
   address_info_rec_.country           := Iso_Country_API.Get_Country_Code3(Iso_Country_API.Get_Country_Id(ext_tax_param_in_rec_.comp_del_country));
   location_establishment_rec_.address := address_info_rec_;
   -- Establishment > ActivitySector
   activity_sector_rec_.type := 'cnae';
   $IF Component_Invoic_SYS.INSTALLED $THEN
      activity_sector_rec_.code := Company_Address_Tax_Number_API.Get_Tax_Id_Number(ext_tax_param_in_rec_.company, company_address_id_, Iso_Country_API.Decode('BR'), 'CNAE');
   $END
   location_establishment_rec_.activity_sector := activity_sector_rec_;
   location_rec_.establishment := location_establishment_rec_;
   RETURN location_rec_;
END Fetch_Locations___;


@IgnoreUnitTest TrivialFunction
FUNCTION Fetch_Invoice_Refs___ (
   ext_tax_param_in_rec_ IN External_Tax_System_Util_API.Ext_Tax_Param_In_Rec ) RETURN N_Ref_Arr
IS
   n_ref_arr_       N_Ref_Arr := N_Ref_Arr();
   n_ref_rec_       N_Ref_Rec;
BEGIN
   n_ref_rec_.document_code := '';
   n_ref_arr_.extend;
   n_ref_arr_(n_ref_arr_.last) := n_ref_rec_;
   RETURN n_ref_arr_;
END Fetch_Invoice_Refs___;


@IgnoreUnitTest TrivialFunction
FUNCTION Fetch_Lines___ (
   ext_tax_param_in_arr_ IN External_Tax_System_Util_API.Ext_Tax_Param_In_Arr ) RETURN Line_Base_For_Goods_Arr
IS
   rec_count_              NUMBER;
   ext_tax_param_in_rec_   External_Tax_System_Util_API.Ext_Tax_Param_In_Rec;
   lines_arr_              Line_Base_For_Goods_Arr := Line_Base_For_Goods_Arr();
   line_rec_               Line_Base_For_Goods_Rec;
   item_descriptor_rec_    Item_Descriptor_For_Goods_Rec;
BEGIN
   rec_count_ := ext_tax_param_in_arr_.count;
   FOR i_ IN 1 .. rec_count_ LOOP
      line_rec_            := NULL;
      item_descriptor_rec_ := NULL;
      ext_tax_param_in_rec_ := ext_tax_param_in_arr_(i_);
      line_rec_.line_code           := i_;
      -- LineBaseForGoods
      line_rec_.item_code            := ext_tax_param_in_rec_.avalara_brazil_specific.catalog_no;
      line_rec_.number_of_items      := ext_tax_param_in_rec_.quantity;
      line_rec_.line_unit_price      := ext_tax_param_in_rec_.avalara_brazil_specific.sale_unit_price;
      line_rec_.line_amount          := ext_tax_param_in_rec_.avalara_brazil_specific.sale_unit_price * ext_tax_param_in_rec_.quantity;
      line_rec_.line_taxed_discount  := ext_tax_param_in_rec_.avalara_brazil_specific.line_taxed_discount;
      line_rec_.use_type             := ext_tax_param_in_rec_.avalara_brazil_specific.external_use_type;
      line_rec_.operation_type       := ext_tax_param_in_rec_.avalara_brazil_specific.business_transaction_id;
      line_rec_.order_number         := ext_tax_param_in_rec_.avalara_brazil_specific.order_no;
      line_rec_.order_item_number    := ext_tax_param_in_rec_.avalara_brazil_specific.line_no;
      -- LineBaseForGoods > ItemDescriptorForGoods
      item_descriptor_rec_.tax_code         := ext_tax_param_in_rec_.avalara_brazil_specific.avalara_tax_code;
      item_descriptor_rec_.hs_code          := SUBSTR(ext_tax_param_in_rec_.avalara_brazil_specific.statistical_code,1,8);
      item_descriptor_rec_.ex               := SUBSTR(ext_tax_param_in_rec_.avalara_brazil_specific.statistical_code,9,3);
      item_descriptor_rec_.cest             := ext_tax_param_in_rec_.avalara_brazil_specific.cest_code;
      item_descriptor_rec_.unit             := ext_tax_param_in_rec_.avalara_brazil_specific.sales_unit_meas;
      item_descriptor_rec_.source           := ext_tax_param_in_rec_.avalara_brazil_specific.acquisition_origin;
      item_descriptor_rec_.product_type     := ext_tax_param_in_rec_.avalara_brazil_specific.product_type_classif;
      line_rec_.item_descriptor             := item_descriptor_rec_;
      lines_arr_.extend;
      lines_arr_(lines_arr_.last) := line_rec_;
   END LOOP;
   RETURN lines_arr_;
END Fetch_Lines___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Assign_Tax_Amount_Percentage___ (
   ext_tax_param_br_out_arr_  OUT External_Tax_System_Util_API.Ext_Tax_Param_Br_Out_Arr,
   business_operation_arr_    OUT External_Tax_System_Util_API.Business_Operation_Rec_Arr,
   response_jo_               IN  JSON_OBJECT_T,
   company_                   IN  VARCHAR2 )    
IS
   line_json_obj_             json_object_t;
   tax_json_obj_              json_object_t; 
   warning_json_obj_          json_object_t;
   line_json_arr_             json_array_t;
   tax_json_arr_              json_array_t;    
   warning_json_arr_          json_array_t;
   avalara_br_tax_code_       VARCHAR2(30);
   order_info_                VARCHAR2(100);   
   tax_info_                  VARCHAR2(100);
   ext_tax_param_out_rec_arr_ External_Tax_System_Util_API.Ext_Tax_Param_Br_Out_Rec_Arr;
   tax_type_category_         Statutory_Fee.Tax_Type_Category_Db%TYPE;
   index_                     NUMBER := 0;
BEGIN
   line_json_arr_ := response_jo_.get_array('lines');
   FOR i IN 0 .. line_json_arr_.get_size - 1 LOOP    
      line_json_obj_ := TREAT(line_json_arr_.get(i) AS json_object_t); 
      tax_json_arr_ := line_json_obj_.get_array('taxDetails');
      index_ := 0;
      FOR j IN 0 .. tax_json_arr_.get_size - 1 LOOP  
         tax_json_obj_ := TREAT(tax_json_arr_.get(j) AS json_object_t);
         tax_type_category_ := UPPER(tax_json_obj_.get_string('taxType'));
         IF (tax_type_category_ = 'ICMSST') THEN
            tax_type_category_ := Tax_Type_Category_API.DB_ICMS_ST;
         END IF;
         IF (Tax_Type_Category_API.Exists_Br_Tax_Type_Ctgry_Db(tax_type_category_)) THEN
            avalara_br_tax_code_ := External_Tax_Codes_Mapping_API.Get_Tax_Code(company_, Tax_Type_Category_API.Decode(tax_type_category_));        
            IF (avalara_br_tax_code_ IS NOT NULL) THEN
               -- Set up the tax infor table                
               ext_tax_param_out_rec_arr_(index_).tax_code := avalara_br_tax_code_;
               ext_tax_param_out_rec_arr_(index_).tax_base_curr_amount := tax_json_obj_.get_string('subtotalTaxable');
               ext_tax_param_out_rec_arr_(index_).tax_percentage := tax_json_obj_.get_string('rate');
               ext_tax_param_out_rec_arr_(index_).tax_amount := tax_json_obj_.get_string('tax');
               ext_tax_param_out_rec_arr_(index_).cst_code := tax_json_obj_.get_string('cst');
               ext_tax_param_out_rec_arr_(index_).legal_tax_class := tax_json_obj_.get_string('legalTaxClass');
               ext_tax_param_out_rec_arr_(index_).citation := tax_json_obj_.get_string('citation');
               index_ := index_ + 1; 
            ELSE
               tax_info_ := 'Tax Percentage 0% for Tax Type Category ' || tax_type_category_;
               order_info_ := 'Order No: ' ||line_json_obj_.get_string('orderNumber')|| ', Order Item No: ' || line_json_obj_.get_string('orderItemNumber') ;
               Error_SYS.Record_General(lu_name_, 'NOTAXCODE: Tax Code mapping does not exist for :P1 in Avalara Tax Code Mapping page in Company :P2. Tax details from Avalara cannot be updated to :P3.', tax_info_, company_, order_info_);
            END IF; 
         END IF;
      END LOOP; 
      ext_tax_param_br_out_arr_(i+1) := ext_tax_param_out_rec_arr_;      
      ext_tax_param_out_rec_arr_.DELETE;
      business_operation_arr_(i+1).business_operation := line_json_obj_.get_String('cfop');  
      IF (line_json_obj_.get_array('warnings') IS NOT NULL) THEN
         warning_json_arr_ := line_json_obj_.get_array('warnings');         
         warning_json_obj_ := TREAT(warning_json_arr_.get(0) AS json_object_t);
         business_operation_arr_(i+1).warning_summary := warning_json_obj_.get_String('citation')||CHR(13)||CHR(10)||warning_json_obj_.get_String('description');
      END IF;
   END LOOP; 
END Assign_Tax_Amount_Percentage___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Assign_Complimentary_Information___ (
   complementary_info_  OUT VARCHAR2,
   response_jo_         IN  JSON_OBJECT_T)
IS
   header_json_obj_     json_object_t;
BEGIN  
   header_json_obj_ := response_jo_.get_Object('header');
   IF (header_json_obj_.get_Object('additionalInfo') IS NOT NULL) THEN
      complementary_info_ := header_json_obj_.get_Object('additionalInfo').get_String('complementaryInfo');
   END IF;
END Assign_Complimentary_Information___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@IgnoreUnitTest TrivialFunction
PROCEDURE Fetch_And_Calculate_Tax (
   ext_tax_param_br_out_arr_ OUT External_Tax_System_Util_API.Ext_Tax_Param_Br_Out_Arr,
   complementary_info_       OUT VARCHAR2,
   business_operation_arr_   OUT External_Tax_System_Util_API.Business_Operation_Rec_Arr,
   ext_tax_param_in_rec_     IN  External_Tax_System_Util_API.Ext_Tax_Param_In_Rec )
IS
   ext_tax_param_in_arr_      External_Tax_System_Util_API.Ext_Tax_Param_In_Arr;
   payload_rec_               Request_Rec;
   payload_json_              Json_Object_T;
   payload_clob_              CLOB;
BEGIN
   ext_tax_param_in_arr_(1) := ext_tax_param_in_rec_;
   payload_rec_.header  := Fetch_Header___(ext_tax_param_in_rec_);
   payload_rec_.lines   := Fetch_Lines___(ext_tax_param_in_arr_);
   payload_json_ := Request_Rec_To_Json___(payload_rec_, FALSE);
   payload_clob_ := payload_json_.to_clob();
   Invoke_Tax_Calc_Service___(ext_tax_param_br_out_arr_, complementary_info_, business_operation_arr_, payload_clob_, ext_tax_param_in_rec_.company);
END Fetch_And_Calculate_Tax;


@IgnoreUnitTest TrivialFunction
PROCEDURE Fetch_And_Calculate_Tax (
   ext_tax_param_br_out_arr_ OUT External_Tax_System_Util_API.Ext_Tax_Param_Br_Out_Arr,
   complementary_info_       OUT VARCHAR2,
   business_operation_arr_   OUT External_Tax_System_Util_API.Business_Operation_Rec_Arr,
   ext_tax_param_in_arr_     IN  External_Tax_System_Util_API.Ext_Tax_Param_In_Arr )
IS
   payload_rec_               Request_Rec;
   payload_json_              Json_Object_T;
   payload_clob_              CLOB;
BEGIN
   payload_rec_.header  := Fetch_Header___(ext_tax_param_in_arr_(1));
   payload_rec_.lines   := Fetch_Lines___(ext_tax_param_in_arr_);
   payload_json_ := Request_Rec_To_Json___(payload_rec_, FALSE);
   payload_clob_ := payload_json_.to_clob();
   Invoke_Tax_Calc_Service___(ext_tax_param_br_out_arr_, complementary_info_, business_operation_arr_, payload_clob_, ext_tax_param_in_arr_(1).company);
END Fetch_And_Calculate_Tax;

-------------------- LU  NEW METHODS -------------------------------------
