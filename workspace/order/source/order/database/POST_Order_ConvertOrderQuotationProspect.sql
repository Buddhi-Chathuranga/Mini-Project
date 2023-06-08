--------------------------------------------------------------------------
--  File:     POST_Order_ConvertOrderQuotationProspect.sql
--
--  Module:   ORDER
--
--  Purpose:  It is possible to register/create prospects in the system similar to customers,
--            after introducing the customer category enumuration field (Customer, Prospect and End Customer) in Customer Info entity.
--            In Order Quotation, prospects have been handled using the customer name and quotation customer type.
--
--            The purpose of this post script is to create prospect type customers which were defined in order quotations as customer name.
--            After the upgrade, customer name would be not used in Order Quotation and customer category field would be used to display whether
--            the Order Quotation is belonging to a Customer or Prospect.

--
--  Date    Sign     History
--  ------  -----    --------------------------------------------------------------------------------------------
--  170621  KiSalk  Bug 136492, Modified to add columns INVALID_DEL_ADDR_UPG and INVALID_DOC_ADDR_UPG to QUOTE_PROSPECT_CUSTOMER_1410 and set them as TRUE 
--  170621          if the address creation throws an error due to city, state or county validations setup in enterp_address_country_tab.
--  161103  SBalLK  Bug 132450, Modified to insert document address country code to the doc_address1 when document address line 1 having NULL values in sales quotation.
--  160324  NiDalk  Bug 127893, Modified to update order_quotation_tab and order_quotation_line_tab using direct updates.
--  160309  NiNilk  Bug 126441, Modified to update all order_quotation_tab records where quotation_customer_type is set as 'PROSPECT'
--  141218  MaIklk  PRSC-4725, Fixed to check propsect name against only the prospects and added statuses to where clause.
--  141205  MaIklk  PRSC-4558, Fixed to initialize the delivery and document addr to NULL in the loop.
--  140922  MaIklk   EAP-280 : Created.
--  -------------------------------------------------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_ConvertOrderQuotationProspect.sql','Timestamp_1');
PROMPT Starting POST_Order_ConvertOrderQuotationProspect.sql

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_ConvertOrderQuotationProspect.sql','Timestamp_2');
PROMPT Update customer id AND delivery address columns in Order_Quotation_Tab after converting prospects in quotations to prospect type customers.

DECLARE
   customer_id_               CUSTOMER_INFO_TAB.Customer_Id%TYPE;
   country_code_              CUSTOMER_INFO_TAB.country%TYPE;
   document_address_          CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE;
   delivery_address_          CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE;
   TYPE Quote_Tab             IS TABLE OF ORDER_QUOTATION_TAB.quotation_no%TYPE INDEX BY PLS_INTEGER;
   TYPE Customer_Name_Tab     IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
   TYPE Quote_Lang_Tab        IS TABLE OF ORDER_QUOTATION_TAB.language_code%TYPE INDEX BY PLS_INTEGER;
   TYPE Quote_Country_Tab     IS TABLE OF ORDER_QUOTATION_TAB.country_code%TYPE INDEX BY PLS_INTEGER;
   quote_tab_                 Quote_Tab;
   customer_name_tab_         Customer_Name_Tab;
   quote_lang_tab_            Quote_Lang_Tab;
   quote_country_tab_         Quote_Country_Tab;
   stmt_                      VARCHAR2(32000);

   TYPE RecordType            IS REF CURSOR;
   get_quote_rec_             RecordType;
   get_quote_prospect_rec_    RecordType;
   table_name_                VARCHAR(30);
   del_country_code_          VARCHAR2(2);
   del_address1_              VARCHAR2(35);
   del_address2_              VARCHAR2(35);
   del_zip_code_              VARCHAR2(35);
   del_city_                  VARCHAR2(35);
   del_county_                VARCHAR2(35);
   del_state_                 VARCHAR2(35);
   doc_country_code_          VARCHAR2(2);
   del_name_                  VARCHAR2(35);
   doc_name_                  VARCHAR2(35);
   doc_address1_              VARCHAR2(35);
   doc_address2_              VARCHAR2(35);
   doc_zip_code_              VARCHAR2(35);
   doc_city_                  VARCHAR2(35);
   doc_county_                VARCHAR2(35);
   doc_state_                 VARCHAR2(35);
   attr_                      VARCHAR2(2000);
   info_                      VARCHAR2(2000);
   def_delivery_addr_         VARCHAR2(5);
   def_document_addr_         VARCHAR2(5);
   columns_                   Database_SYS.ColumnTabType;
   address_creation_error_    BOOLEAN := FALSE;

   FUNCTION Get_Next_Customer_Id RETURN VARCHAR2
   IS
      next_value_ PARTY_IDENTITY_SERIES_TAB.next_value%TYPE;
   BEGIN
      next_value_ := Customer_Info_API.Get_Next_Identity;
      -- If identity series is not defined for customer
      -- then auto increment a number (starting with 1) to use for customer id,
      -- while checking the existence of customer id.
      IF (next_value_ IS NULL) THEN
         next_value_ := 1;
         WHILE (Customer_Info_API.Check_Exist(next_value_) = Fnd_Boolean_API.DB_TRUE)
         LOOP
            next_value_ := next_value_ + 1;
         END LOOP;
         Party_Identity_Series_API.Insert_Next_Value(next_value_+1, Party_Type_API.DB_CUSTOMER);
      END IF;

      RETURN next_value_;
   END Get_Next_Customer_Id;


   FUNCTION Check_Prospect_Exist(
      customer_name_ IN VARCHAR2,
      language_code_ IN VARCHAR2,
      country_code_  IN VARCHAR2) RETURN VARCHAR2
   IS
      customer_      CUSTOMER_INFO_TAB.Customer_Id%TYPE;
      CURSOR check_customer IS
         SELECT customer_id
         FROM customer_info_tab
         WHERE name = customer_name_
         AND default_language = language_code_
         AND country = country_code_
         AND party_type = 'CUSTOMER'
         AND customer_category = 'PROSPECT';
   BEGIN
      OPEN check_customer;
      FETCH check_customer INTO customer_;
      CLOSE check_customer;

      RETURN customer_;
   END Check_Prospect_Exist;

   PROCEDURE Create_New_Address (
      quotation_no_      IN VARCHAR2,
      customer_id_       IN VARCHAR2,
      address_id_        IN VARCHAR2,
      address1_          IN VARCHAR2,
      address2_          IN VARCHAR2,
      zip_code_          IN VARCHAR2,
      city_              IN VARCHAR2,
      state_             IN VARCHAR2,
      country_code_      IN VARCHAR2,
      county_            IN VARCHAR2,
      name_              IN VARCHAR2,
      addr_type_code_db_ IN VARCHAR2,
      default_addr_      IN VARCHAR2 )
   IS
      sqlstmt_    VARCHAR2(2000);
   BEGIN 
      Customer_Info_Address_API.New_Address(customer_id_, address_id_, address1_, address2_, zip_code_, city_, state_, Iso_Country_API.Decode(country_code_), NULL, NULL, NULL, county_, name_);                   
      Customer_Info_Address_Type_API.New(customer_id_, address_id_, Address_Type_Code_API.Decode(addr_type_code_db_), default_addr_);
      address_creation_error_ := FALSE;
   EXCEPTION
      WHEN OTHERS THEN
         IF addr_type_code_db_ = Address_Type_Code_API.DB_DELIVERY THEN
            sqlstmt_ := 'UPDATE '|| table_name_||' 
                            SET INVALID_DEL_ADDR_UPG = ''TRUE''
                          WHERE quotation_no = :quotation_no_';
         ELSE
            sqlstmt_ := 'UPDATE '|| table_name_||' 
                            SET INVALID_DOC_ADDR_UPG = ''TRUE''
                          WHERE quotation_no = :quotation_no_';
         END IF;
         EXECUTE IMMEDIATE sqlstmt_
         USING IN  quotation_no_;
         address_creation_error_ := TRUE;
   END Create_New_Address;

BEGIN
   -- If this script has ran once then the package QUOTE_PROSPECT_CUSTOMER_API is dropped and QUOTE_PROSPECT_CUSTOMER_TAB is renamed.
   -- The column customer_name and quotation_customer_type in order_quotation_tab are might be dropped.
   -- Skip the quotation where it lines state are in Lost or won, since you can't change the customer id on those statuses.
   stmt_ :=  'SELECT quotation_no, customer_name, language_code, country_code
              FROM order_quotation_tab oq
              WHERE quotation_customer_type = ''PROSPECT''
              AND customer_name IS NOT NULL
              AND customer_no IS NULL';

   IF Database_SYS.Column_Exist('ORDER_QUOTATION_TAB', 'CUSTOMER_NAME') THEN
      IF Database_SYS.Table_Exist('QUOTE_PROSPECT_CUSTOMER_TAB') THEN
         table_name_ := 'QUOTE_PROSPECT_CUSTOMER_TAB';
      ELSIF Database_SYS.Table_Exist('QUOTE_PROSPECT_CUSTOMER_1410') THEN
         table_name_ := 'QUOTE_PROSPECT_CUSTOMER_1410';
      END IF;

      Database_SYS.Reset_Column_Table(columns_);
      Database_SYS.Set_Table_Column(columns_, 'INVALID_DEL_ADDR_UPG', 'VARCHAR2(5)', 'Y', '''FALSE''', keep_default_ => 'N');
      Database_SYS.Set_Table_Column(columns_, 'INVALID_DOC_ADDR_UPG', 'VARCHAR2(5)', 'Y', '''FALSE''', keep_default_ => 'N');
      Database_SYS.Alter_Table(table_name_, columns_, TRUE);

      OPEN get_quote_rec_ FOR stmt_;
      FETCH get_quote_rec_ BULK COLLECT INTO quote_tab_,
                                             customer_name_tab_,
                                             quote_lang_tab_,
                                             quote_country_tab_;
      CLOSE get_quote_rec_;


      IF (quote_tab_.COUNT >0) THEN

         IF (table_name_ IS NOT NULL) THEN
            FOR i_ IN quote_tab_.FIRST..quote_tab_.LAST LOOP
               country_code_ := NULL;
               stmt_ := 'DECLARE
                            CURSOR get_prospect_country (quotation_no_ IN VARCHAR2) IS
                            SELECT del_country_code
                            FROM ' || table_name_ || ' ' || '
                            WHERE quotation_no = quotation_no_;
                         BEGIN
                            -- Fetch the prospect country from delivery address.
                            OPEN get_prospect_country(:quotation_no_);
                            FETCH get_prospect_country INTO :country_code_;
                            CLOSE get_prospect_country;
                         END;';

               EXECUTE IMMEDIATE stmt_
                  USING IN  quote_tab_(i_),
                        OUT country_code_;
               -- If there are no addresses specified fetch country from the supply country (ex: site country)
               IF (country_code_ IS NULL) THEN
                  country_code_ := quote_country_tab_(i_);
               END IF;

               -- Check prospect name exist
               customer_id_ := Check_Prospect_Exist( customer_name_tab_(i_), quote_lang_tab_(i_), country_code_);
               delivery_address_  := NULL;
               document_address_  := NULL;
               def_delivery_addr_ := 'TRUE';
               def_document_addr_ := 'TRUE';

               IF customer_id_ IS NULL THEN
                  customer_id_ := Get_Next_Customer_Id;
                  -- Add prospect customer
                  Customer_Info_API.New(customer_id_, customer_name_tab_(i_), Customer_Category_API.DB_PROSPECT, NULL, Iso_Country_API.Decode(country_code_), Iso_Language_API.Decode(quote_lang_tab_(i_)));
               ELSE
                  -- If customer exists then check whether default addresses are existing.
                  IF(Customer_Info_Address_Type_API.Get_Default_Address_Id(customer_id_, Address_Type_Code_API.DB_DELIVERY) IS NOT NULL) THEN
                     def_delivery_addr_ := 'FALSE';
                  END IF;
                  IF(Customer_Info_Address_Type_API.Get_Default_Address_Id(customer_id_, Address_Type_Code_API.DB_DOCUMENT) IS NOT NULL) THEN
                     def_document_addr_ := 'FALSE';
                  END IF;
               END IF;
               -- Add address information
               stmt_ := 'SELECT del_country_code, del_address1, del_address2, del_zip_code, del_city, del_county, del_state,
                         doc_country_code, del_name, doc_name, doc_address1, doc_address2, doc_zip_code, doc_city, doc_county, doc_state
                         FROM ' || table_name_ || ' ' || '
                         WHERE quotation_no = :quotation_no_';

               OPEN get_quote_prospect_rec_ FOR stmt_ USING quote_tab_(i_);
               FETCH get_quote_prospect_rec_ INTO del_country_code_,del_address1_, del_address2_, del_zip_code_, del_city_, del_county_, del_state_,
                                                  doc_country_code_, del_name_, doc_name_, doc_address1_, doc_address2_, doc_zip_code_, doc_city_, doc_county_, doc_state_;
               IF (get_quote_prospect_rec_%FOUND) THEN
                  CLOSE get_quote_prospect_rec_;
                  IF del_country_code_ IS NOT NULL THEN
                     delivery_address_ := Customer_Info_Address_API.Get_Next_Address_Id(customer_id_, NULL);
                     Create_New_Address(quote_tab_(i_), customer_id_, delivery_address_, del_address1_, del_address2_,
                                         del_zip_code_, del_city_, del_state_, del_country_code_, del_county_, del_name_, Address_Type_Code_API.DB_DELIVERY, def_delivery_addr_);
                     IF doc_country_code_ IS NOT NULL THEN
                        IF NVL(del_name_, '0')            <> NVL(doc_name_, '0')
                           OR NVL(del_country_code_, '0') <> NVL(doc_country_code_, '0')
                           OR NVL(del_address1_, '0')     <> NVL(doc_address1_, '0')
                           OR NVL(del_address2_, '0')     <> NVL(doc_address2_, '0')
                           OR NVL(del_zip_code_, '0')     <> NVL(doc_zip_code_, '0')
                           OR NVL(del_city_, '0')         <> NVL(doc_city_, '0')
                           OR NVL(del_county_, '0')       <> NVL(doc_county_, '0')
                           OR NVL(del_state_, '0')        <> NVL(doc_state_, '0') THEN
                              doc_address1_ := NVL(doc_address1_, doc_country_code_);

                           document_address_ := Customer_Info_Address_API.Get_Next_Address_Id(customer_id_, NULL);
                           Create_New_Address(quote_tab_(i_), customer_id_, document_address_, doc_address1_, doc_address2_, 
                                              doc_zip_code_, doc_city_, doc_state_, doc_country_code_, doc_county_, doc_name_, Address_Type_Code_API.DB_DOCUMENT, def_document_addr_);
                         ELSE
                           IF NOT address_creation_error_ THEN
                              document_address_ := delivery_address_;
                              Customer_Info_Address_Type_API.New(customer_id_, document_address_, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DOCUMENT), def_document_addr_);
                           END IF;
                        END IF;
                     END IF;
                  END IF; 
               ELSE
                  CLOSE get_quote_prospect_rec_;
               END IF;

               -- update the order quotation tab
               UPDATE order_quotation_tab oq
                  SET customer_no = customer_id_,
                      ship_addr_no = delivery_address_,
                      bill_addr_no = document_address_
                  WHERE quotation_no =  quote_tab_(i_);

               -- update the order quotation line tab
               UPDATE order_quotation_line_tab ql
                  SET customer_no = customer_id_,
                      ship_addr_no = delivery_address_
               WHERE quotation_no =  quote_tab_(i_);
            END LOOP;
         END IF;
      END IF;
   END IF;
END;
/

COMMIT;

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_ConvertOrderQuotationProspect.sql','Timestamp_3');
PROMPT Set columns customer_name and quotation_customer_type nullable in order_quotation_tab.

DECLARE
   column_     Database_SYS.ColRec;
BEGIN
   -- Customer name is already null. no need to set to null.

   -- Set Quotation_customer_type column to null
   column_ := Database_SYS.Set_Column_Values('QUOTATION_CUSTOMER_TYPE', 'VARCHAR2(20)', 'Y');
   Database_SYS.Alter_Table_Column('ORDER_QUOTATION_TAB', 'M', column_, TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_ConvertOrderQuotationProspect.sql','Timestamp_4');
PROMPT Drop QUOTATION_CUSTOMER_TYPE_API.

BEGIN
   Database_SYS.Remove_Package('QUOTATION_CUSTOMER_TYPE_API', TRUE);
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_ConvertOrderQuotationProspect.sql','Timestamp_5');
PROMPT Drop objects related QUOTE_PROSPECT_CUSTOMER.

BEGIN
   Database_SYS.Remove_Package('QUOTE_PROSPECT_CUSTOMER_API', TRUE);
   Database_SYS.Remove_View('QUOTE_PROSPECT_CUSTOMER', TRUE);
   --Rename table
   Database_SYS.Rename_Table('QUOTE_PROSPECT_CUSTOMER_TAB', 'QUOTE_PROSPECT_CUSTOMER_1410');
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ORDER','POST_Order_ConvertOrderQuotationProspect.sql','Done');
PROMPT Finished with POST_Order_ConvertOrderQuotationProspect.sql
