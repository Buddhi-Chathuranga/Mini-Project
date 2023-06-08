-----------------------------------------------------------------------------
--
--  Logical unit: TaxIdNumValidationUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211207  Alwolk FI21R2-7690, Modified Update_Validated_Date() for gelr:cash_box_receipt_enhancement. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest TrivialFunction
PROCEDURE Start_Xml___ (
   xml_stream_ IN OUT NOCOPY CLOB )
IS
BEGIN
   IF (DBMS_LOB.istemporary(xml_stream_)=1) THEN
      DBMS_LOB.freetemporary(xml_stream_);
   END IF;
   DBMS_LOB.createtemporary(xml_stream_, TRUE);
   Xml_Text_Writer_API.Init_Write_Buffer;
END Start_Xml___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Finish_Xml___ (
   xml_stream_ IN OUT NOCOPY CLOB )
IS
BEGIN
   DBMS_LOB.freetemporary(xml_stream_);
END Finish_Xml___;


@IgnoreUnitTest TrivialFunction
FUNCTION Create_And_Invoke_Request___ (
   tax_id_type_   IN VARCHAR2,
   tax_id_number_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   request_data_      CLOB;
   url_params_        PLSQLAP_DOCUMENT_API.Document;
   params_            Plsqlap_Document_API.Document;
   response_          Plsqlap_Document_API.Document;
   url_params_clob_   CLOB;
   params_clob_       CLOB;
   country_code_      VARCHAR2(2);
BEGIN  
   country_code_ := Tax_Id_Type_API.Get_Country_Code(tax_id_type_);
   Start_Xml___(request_data_);   
   Xml_Record_Writer_SYS.Start_Element(request_data_, 'TaxIdNumberValidationRequest');
   Xml_Record_Writer_SYS.Add_Element(request_data_, 'CountryCode',country_code_);
   Xml_Record_Writer_SYS.Add_Element(request_data_, 'TaxIdNumber',tax_id_number_);
   Xml_Record_Writer_SYS.End_Element(request_data_,'TaxIdNumberValidationRequest');
   Xml_Text_Writer_API.Write_End_Document(request_data_);
   params_ := Plsqlap_Document_API.New_Document('PARAMETERS');
   url_params_ := Plsqlap_Document_API.New_Document('URL_PARAMS');
   Plsqlap_Document_API.Add_Attribute(url_params_, 'PARAM1', country_code_);
   Plsqlap_Document_API.Add_Attribute(url_params_, 'PARAM2', tax_id_number_);
   Plsqlap_Document_API.To_Ifs_Xml(url_params_clob_, url_params_);
   Plsqlap_Document_API.Add_Attribute(params_,'URL_PARAMS',url_params_clob_);
   Plsqlap_Document_API.To_Ifs_Xml(params_clob_, params_);
   Plsqlap_Server_API.Invoke_Outbound_Message(xml_              => request_data_, 
                                              sender_           => 'IFS',
                                              receiver_         => tax_id_type_,
                                              message_type_     => 'APPLICATION_MESSAGE',                                            
                                              message_function_ => 'VALIDATE_TAX_ID_NO_BY_TAX_TYPE',
                                              parameters_       => params_clob_ );                                                    
   Plsqlap_Document_API.From_Xml(response_,request_data_);
   Finish_Xml___(request_data_);
   RETURN Plsqlap_Document_API.Get_Value(response_,'RESPONSE');
   EXCEPTION
      WHEN OTHERS THEN
        RETURN 'FALSE'; 
END Create_And_Invoke_Request___;


FUNCTION Is_Alphanumeric___ (
	tax_id_to_validate_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN NOT REGEXP_LIKE (tax_id_to_validate_, '[^a-zA-Z0-9]');
END Is_Alphanumeric___;


FUNCTION Is_Country_Code_Available___ (
	tax_id_to_validate_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   first_two_chars_ VARCHAR2(2);
BEGIN
   first_two_chars_ := SUBSTR(tax_id_to_validate_, 1, 2);
   RETURN NOT REGEXP_LIKE (first_two_chars_, '[^A-Z]');
END Is_Country_Code_Available___;


FUNCTION Is_Country_Code_Eu_Member___ (
	tax_id_to_validate_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   first_two_chars_  VARCHAR2(2);
   is_eu_member_     VARCHAR2(1);
BEGIN
   first_two_chars_ := SUBSTR(tax_id_to_validate_, 1, 2);  
   is_eu_member_    := Iso_Country_API.Get_Eu_Member_Db(first_two_chars_);
   RETURN NVL(is_eu_member_, 'N') = 'Y' OR first_two_chars_ = 'EL';
END Is_Country_Code_Eu_Member___;

@IgnoreUnitTest TrivialFunction
FUNCTION Remove_Prefix_From_Tax_Id_No___ (
   tax_id_number_ IN VARCHAR2,
   tax_id_type_   IN VARCHAR2) RETURN VARCHAR2
IS 
  country_code_           VARCHAR2(2); 
  tax_id_without_prefix_  VARCHAR2(50);
  prefix_                 VARCHAR2(2);
BEGIN
   country_code_ := Tax_Id_Type_API.Get_Country_Code(tax_id_type_);
   IF (country_code_ = 'GB') THEN
      prefix_     := SUBSTR(tax_id_number_, 1, 2);
      IF (prefix_ = country_code_) THEN
         tax_id_without_prefix_ := SUBSTR(tax_id_number_, 3);
      ELSE
         tax_id_without_prefix_ := tax_id_number_;
      END IF;
   ELSE 
      tax_id_without_prefix_ := tax_id_number_;
   END IF;
   RETURN tax_id_without_prefix_;
END Remove_Prefix_From_Tax_Id_No___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Validate_Tax_Id_Number (
   tax_id_number_ IN VARCHAR2,
   country_code_  IN VARCHAR2,
   tax_id_type_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   validity_   VARCHAR2(50);
BEGIN
   IF (tax_id_number_ IS NOT NULL) THEN 
      IF (NOT Is_Alphanumeric___(tax_id_number_)) THEN
         validity_ := 'INVALID_CHARACTERS';
      ELSE         
         IF (NOT Is_Country_Code_Available___(tax_id_number_)) THEN
            validity_ := 'NO_COUNTRY_CODE';
            IF (country_code_ = 'IT') THEN
               Validate_Tax_Id_Number_It(validity_, tax_id_number_);
            ELSE 
               IF (tax_id_type_ IS NOT NULL) THEN
                  validity_ := Validate_Tax_Id_No_By_Tax_Type(tax_id_type_, tax_id_number_);
               ELSE                     
                  validity_ := 'NO_TAX_ID_TYPE';
               END IF;
            END IF;
         ELSE
            IF (NOT Is_Country_Code_Eu_Member___(tax_id_number_)) THEN
               validity_ := 'NOT_EU_COUNTRY_CODE';
               IF (tax_id_type_ IS NOT NULL) THEN
                  validity_ := Validate_Tax_Id_No_By_Tax_Type(tax_id_type_, tax_id_number_);
               ELSE                     
                  validity_ := 'NO_TAX_ID_TYPE';
               END IF;   
            ELSE
               validity_ := 'USE_CHECK_VAT_SERVICE';
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN validity_;
END Validate_Tax_Id_Number;


PROCEDURE Validate_Tax_Id_Number_It (
   validity_      OUT VARCHAR2,
   tax_id_number_ IN  VARCHAR2 )
IS
   c_       NUMBER;
   s_       NUMBER := 0;
   r_       NUMBER;
   j_       NUMBER;
   temp_    NUMBER;
BEGIN
   validity_ := 'VALID';
   IF (LENGTH(RTRIM(tax_id_number_)) = 11) THEN
      FOR i_ IN  1..11 LOOP
         temp_ := ASCII(SUBSTR(tax_id_number_, i_, 1));
         IF NOT ((temp_ >= 48) AND (temp_ <= 57)) THEN
            validity_ := 'IT_INVALID_1';
         END IF;
      END LOOP;
      IF (validity_ = 'VALID') THEN
         j_ := 1;
         FOR  i_ IN  1..5 LOOP
            s_ := s_ + TO_NUMBER(SUBSTR(tax_id_number_, j_, 1));
            j_ := j_ + 2;
         END LOOP;
         j_ := 2;
         FOR i_ IN  1..5 LOOP
            c_:= 2 * TO_NUMBER(SUBSTR(tax_id_number_, j_, 1));
            IF (c_ > 9) THEN
               c_ := c_ - 9;
            END IF;
            s_ := s_ + c_;
            j_ := j_ + 2;
         END LOOP;
         r_ := s_ - (10 * TRUNC(s_ / 10));
         IF (r_ = 0) THEN
            c_ := 0;
         ELSE
            c_ := 10 - r_;
         END IF;
         IF (c_ != TO_NUMBER(SUBSTR(tax_id_number_, 11, 1))) THEN
            validity_ := 'IT_INVALID_2';
         END IF;
      END IF;
   ELSIF (tax_id_number_ IS NOT NULL) THEN
      validity_ := 'IT_INVALID_3';
   END IF;
END Validate_Tax_Id_Number_It;


-- This procedure is introduced for Aurena client
PROCEDURE Get_Tax_Id_Number_Messages (
   msg_tax_id_nums_with_invalid_characters_   IN OUT VARCHAR2,
   msg_tax_id_nums_with_no_country_code_      IN OUT VARCHAR2,
   msg_tax_id_nums_with_not_eu_country_code_  IN OUT VARCHAR2,
   msg_invalid_tax_id_numbers_                IN OUT VARCHAR2,
   msg_tax_id_numbers_it_invalid_1_           IN OUT VARCHAR2,
   msg_tax_id_numbers_it_invalid_2_           IN OUT VARCHAR2,
   msg_tax_id_numbers_it_invalid_3_           IN OUT VARCHAR2,
   msg_tax_id_types_invalid_                  IN OUT VARCHAR2,
   msg_no_tax_id_types_                       IN OUT VARCHAR2,
   msg_network_error_                         IN OUT VARCHAR2 )
IS
BEGIN
   IF (msg_tax_id_nums_with_invalid_characters_ IS NOT NULL) THEN
      msg_tax_id_nums_with_invalid_characters_  := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNOINVALIDCHAR: Tax ID Number(s) :P1 has non alphanumeric characters. Use only alphanumeric characters in order to validate the Tax ID Number.',
                                                                                   NULL,
                                                                                   msg_tax_id_nums_with_invalid_characters_);      
   END IF;
   IF (msg_tax_id_nums_with_no_country_code_ IS NOT NULL) THEN      
      msg_tax_id_nums_with_no_country_code_     := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNONOCOUNTRYCODE: Tax ID Number validation can be performed only for EU countries. If you want to continue the validation, prefix the country code to Tax ID Number(s) :P1',
                                                                                   NULL,
                                                                                   msg_tax_id_nums_with_no_country_code_);
   END IF;
   IF (msg_tax_id_nums_with_not_eu_country_code_ IS NOT NULL) THEN
      msg_tax_id_nums_with_not_eu_country_code_ := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNONONEUCOUNTRYCODE: Tax ID Number validation can be performed only for EU countries. Therefore Tax ID Number(s) :P1 cannot be validated',
                                                                                   NULL,
                                                                                   msg_tax_id_nums_with_not_eu_country_code_);
   END IF;
   IF (msg_invalid_tax_id_numbers_ IS NOT NULL) THEN
      msg_invalid_tax_id_numbers_               := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNOINVALID: Tax ID Number(s) :P1 is not valid.',
                                                                                   NULL,
                                                                                   msg_invalid_tax_id_numbers_);
   END IF;
   IF (msg_tax_id_numbers_it_invalid_1_ IS NOT NULL) THEN
      msg_tax_id_numbers_it_invalid_1_          := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNOITINVALID1: Tax ID Number(s) :P1 can only contain digits.',
                                                                                   NULL,
                                                                                   msg_tax_id_numbers_it_invalid_1_);
   END IF;
   IF (msg_tax_id_numbers_it_invalid_2_ IS NOT NULL) THEN
      msg_tax_id_numbers_it_invalid_2_          := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNOINVALID: Tax ID Number(s) :P1 is not valid.',
                                                                                   NULL,
                                                                                   msg_tax_id_numbers_it_invalid_2_);
   END IF;
   IF (msg_tax_id_numbers_it_invalid_3_ IS NOT NULL) THEN
      msg_tax_id_numbers_it_invalid_3_          := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNOITINVALID3: Tax ID Number(s) :P1 is of incorrect length and must be 11 digits long.',
                                                                                   NULL,
                                                                                   msg_tax_id_numbers_it_invalid_3_);
   END IF;                         
   IF (msg_tax_id_types_invalid_ IS NOT NULL) THEN
       msg_tax_id_types_invalid_                := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'INVALIDTAXIDTYPE: The Tax ID Type :P1 is not defined to validate the Tax ID Number. If you want to continue the validation, select Validate Tax ID Number in Tax ID Type page.',
                                                                                   NULL,
                                                                                   msg_tax_id_types_invalid_);
   END IF;
   IF (msg_no_tax_id_types_ IS NOT NULL) THEN
      msg_no_tax_id_types_                      := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'NOTAXIDTYPE: Tax ID Number validation for EU countries can be performed only if the country code is prefixed to the Tax ID Number and for countries other than EU countries only if the Tax ID Type is entered. If you want to continue the validation, prefix the country code or enter the Tax ID Type.',
                                                                                   NULL);
   END IF;
   IF (msg_network_error_ IS NOT NULL) THEN
      msg_network_error_                        := Language_SYS.Translate_Constant(lu_name_,
                                                                                   'TAXIDNONETWORKERR: Tax ID Number(s) cannot be validated due to network problem.',
                                                                                   NULL);
   END IF;
END Get_Tax_Id_Number_Messages;


PROCEDURE Update_Validated_Date (
   selection_        IN VARCHAR2,
   projection_name_  IN VARCHAR2 )
IS
   company_             VARCHAR2(200);
   tax_id_              NUMBER;
   dummy_               VARCHAR2(2000);
   supplier_id_         VARCHAR2(20);
   address_id_          VARCHAR2(50);
   customer_id_         VARCHAR2(20);
   supply_country_db_   VARCHAR2(5);
   delivery_country_db_ VARCHAR2(5);
   supply_company_      VARCHAR2(20);
   country_code_        VARCHAR2(20);
   valid_from_          DATE;
   party_type_db_       VARCHAR2(100);
   order_no_            VARCHAR2(12);
   line_no_             VARCHAR2(4);
   rel_no_              VARCHAR2(4);
   line_item_no_        NUMBER;
   message_id_          NUMBER;
   -- gelr:cash_box_receipt_enhancement, begin.
   lump_sum_trans_id_   NUMBER;
   mixed_payment_id_    NUMBER;
   -- gelr:cash_box_receipt_enhancement, end.
BEGIN
   IF (projection_name_ IN ('ViewTaxProposalItemHandling', 'TaxTransactionsHandling')) THEN
      company_ := Client_SYS.Get_Key_Reference_Value(selection_, 'COMPANY');
      tax_id_  := Client_SYS.Get_Key_Reference_Value(selection_, 'TAX_ID');
      $IF Component_Taxled_SYS.INSTALLED $THEN
         Tax_Ledger_Item_API.Update_Validated_Date(dummy_, company_, tax_id_);
      $END
   END IF;
   IF (projection_name_ = 'SupplierHandling') THEN
      company_     := Client_SYS.Get_Key_Reference_Value(selection_, 'COMPANY');
      supplier_id_ := Client_SYS.Get_Key_Reference_Value(selection_, 'SUPPLIER_ID');
      address_id_  := Client_SYS.Get_Key_Reference_Value(selection_, 'ADDRESS_ID');
      $IF Component_Invoic_SYS.INSTALLED $THEN
         Supplier_Document_Tax_Info_API.Update_Validated_Date(supplier_id_, address_id_, company_);
      $END
   END IF;
   IF (projection_name_ = 'CustomerHandling') THEN
      company_             := Client_SYS.Get_Key_Reference_Value(selection_, 'COMPANY');
      customer_id_         := Client_SYS.Get_Key_Reference_Value(selection_, 'CUSTOMER_ID');
      address_id_          := Client_SYS.Get_Key_Reference_Value(selection_, 'ADDRESS_ID');
      supply_country_db_   := Client_SYS.Get_Key_Reference_Value(selection_, 'SUPPLY_COUNTRY_DB');
      delivery_country_db_ := Client_SYS.Get_Key_Reference_Value(selection_, 'DELIVERY_COUNTRY_DB'); 
      $IF Component_Invoic_SYS.INSTALLED $THEN
         Customer_Document_Tax_Info_API.Update_Validated_Date(company_, customer_id_, address_id_, supply_country_db_, delivery_country_db_);
      $END
   END IF;
   IF (projection_name_ = 'CustomerAddressDeliveryTaxIpdTaxInformationHandling') THEN
      company_           := Client_SYS.Get_Key_Reference_Value(selection_, 'COMPANY');
      customer_id_       := Client_SYS.Get_Key_Reference_Value(selection_, 'CUSTOMER_ID');
      address_id_        := Client_SYS.Get_Key_Reference_Value(selection_, 'ADDRESS_ID');
      supply_company_    := Client_SYS.Get_Key_Reference_Value(selection_, 'SUPPLY_COMPANY'); 
      supply_country_db_ := Client_SYS.Get_Key_Reference_Value(selection_, 'SUPPLY_COUNTRY_DB');
      $IF Component_Invoic_SYS.INSTALLED $THEN
         Customer_Ipd_Tax_Info_Addr_API.Update_Validated_Date(company_, customer_id_, address_id_, supply_company_, supply_country_db_);
      $END
   END IF;
   IF (projection_name_ = 'CustomerInvoiceIpdTaxInformationHandling') THEN
      company_             := Client_SYS.Get_Key_Reference_Value(selection_, 'COMPANY');
      customer_id_         := Client_SYS.Get_Key_Reference_Value(selection_, 'CUSTOMER_ID');
      party_type_db_       := Client_SYS.Get_Key_Reference_Value(selection_, 'PARTY_TYPE_DB');
      supply_company_      := Client_SYS.Get_Key_Reference_Value(selection_, 'SUPPLY_COMPANY');
      supply_country_db_   := Client_SYS.Get_Key_Reference_Value(selection_, 'SUPPLY_COUNTRY_DB');
      delivery_country_db_ := Client_SYS.Get_Key_Reference_Value(selection_, 'DELIVERY_COUNTRY');
      $IF Component_Invoic_SYS.INSTALLED $THEN
         Customer_Ipd_Tax_Info_Inv_API.Update_Validated_Date(company_, customer_id_, party_type_db_, supply_company_, supply_country_db_, delivery_country_db_);
      $END
   END IF;
   IF (projection_name_ = 'CompanyHandling') THEN
      company_      := Client_SYS.Get_Key_Reference_Value(selection_, 'COMPANY');
      country_code_ := Client_SYS.Get_Key_Reference_Value(selection_, 'COUNTRY_CODE');
      valid_from_   := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Key_Reference_Value(selection_, 'VALID_FROM'));
      $IF Component_Invoic_SYS.INSTALLED $THEN
         Tax_Liability_Countries_API.Update_Validated_Date(company_, country_code_, valid_from_);
      $END
   END IF;
   IF (projection_name_ IN ('CustomerOrderHandling', 'CustomerOrderLinesHandling', 'CustomerOrdersHandling')) THEN
      order_no_     := Client_SYS.Get_Key_Reference_Value(selection_, 'ORDER_NO');
      line_no_      := Client_SYS.Get_Key_Reference_Value(selection_, 'LINE_NO');
      rel_no_       := Client_SYS.Get_Key_Reference_Value(selection_, 'REL_NO');
      line_item_no_ := Client_SYS.Get_Key_Reference_Value(selection_, 'LINE_ITEM_NO');     
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (line_no_ IS NOT NULL) THEN
            Customer_Order_Line_API.Modify_Tax_Id_Validated_Date(order_no_, line_no_, rel_no_, line_item_no_);
         ELSE
            Customer_Order_API.Modify_Tax_Id_Validated_Date(order_no_);
         END IF;
      $END
   END IF;
   IF (projection_name_ IN ('IncomingCustomerOrderHandling', 'IncomingCustomerOrdersHandling')) THEN
      message_id_ := Client_SYS.Get_Key_Reference_Value(selection_, 'MESSAGE_ID');     
      $IF Component_Order_SYS.INSTALLED $THEN
         External_Customer_Order_API.Update_Tax_Id_Validated_Date(message_id_);
      $END
   END IF;
   IF (projection_name_ IN ('IncomingChangeRequestForCustomerOrderHandling', 'IncomingChangeRequestsForCustomerOrdersHandling')) THEN
      message_id_ := Client_SYS.Get_Key_Reference_Value(selection_, 'MESSAGE_ID');     
      $IF Component_Order_SYS.INSTALLED $THEN
         Ext_Cust_Order_Change_API.Update_Tax_Id_Validated_Date(message_id_);
      $END
   END IF;
   -- gelr:cash_box_receipt_enhancement, begin.
   IF (projection_name_ IN ('CashBoxHandling')) THEN
      company_           := Client_SYS.Get_Key_Reference_Value(selection_, 'COMPANY');
      mixed_payment_id_  := Client_SYS.Get_Key_Reference_Value(selection_, 'MIXED_PAYMENT_ID');
      lump_sum_trans_id_ := Client_SYS.Get_Key_Reference_Value(selection_, 'LUMP_SUM_TRANS_ID');
      $IF Component_Payled_SYS.INSTALLED $THEN
         Cash_Box_Lump_Sum_API.Update_Validated_Date(company_,mixed_payment_id_,lump_sum_trans_id_);
      $END
   END IF;
   -- gelr:cash_box_receipt_enhancement, end.
END Update_Validated_Date;


@UncheckedAccess
@IgnoreUnitTest DMLOperation
FUNCTION Validate_Tax_Id_No_By_Tax_Type (
   tax_id_type_   IN VARCHAR2,
   tax_id_number_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   response_               VARCHAR2(20);
   tax_id_without_prefix_  VARCHAR2(50);
BEGIN
   IF (Tax_Id_Type_API.Get_Validate_Tax_Id_Number_Db(tax_id_type_) = 'TRUE') THEN      
      -- Remove GB prefix before validating the tax id number. 
      tax_id_without_prefix_ := Remove_Prefix_From_Tax_Id_No___(tax_id_number_, tax_id_type_);
      response_              := Create_And_Invoke_Request___(tax_id_type_, tax_id_without_prefix_);
      IF (response_ = 'TRUE') THEN
         response_ := 'VALID';
      ELSE
         response_ := 'INVALID';
      END IF;   
   ELSE          
      response_ := 'NO_VALID_TAX_ID_TYPE';
   END IF;
   RETURN response_;
END Validate_Tax_Id_No_By_Tax_Type;
