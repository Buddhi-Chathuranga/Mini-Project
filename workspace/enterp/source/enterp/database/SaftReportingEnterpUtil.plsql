-----------------------------------------------------------------------------
--
--  Logical unit: SaftReportingEnterpUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180110  Chwtlk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

saft_exchange_type_rounding_         CONSTANT NUMBER        := 8;
saft_monetary_type_rounding_         CONSTANT NUMBER        := 2;
saft_quantity_type_rounding_         CONSTANT NUMBER        := 6;
saft_date_format_                    CONSTANT VARCHAR2(10)  := 'yyyy-mm-dd';

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Insert company header details to the Ext_File_Trans_Tab.
PROCEDURE Add_Header_Company (
   row_no_       IN OUT NUMBER,
   load_file_id_ IN     NUMBER,
   company_      IN     VARCHAR2,
   country_      IN     VARCHAR2,
   report_type_  IN     VARCHAR2 )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_   ext_file_trans_tab%ROWTYPE;
   $END
   CURSOR saft_company IS
      SELECT company        company,
             name           name,
             association_no association_no
      FROM   company_tab
      WHERE  company = company_;  
   rec_saft_company_address_ saft_company%ROWTYPE;
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      OPEN saft_company;
      FETCH saft_company INTO rec_saft_company_address_;
      CLOSE saft_company;
      row_no_                   := row_no_ + 1;
      newrec_.load_file_id      := load_file_id_;
      newrec_.row_no            := row_no_;
      newrec_.record_type_id    := '1.1';
      newrec_.c1                := rec_saft_company_address_.company;
      newrec_.c2                := rec_saft_company_address_.name;
      newrec_.c3                := rec_saft_company_address_.association_no;
      newrec_.row_state         := '1';
      newrec_.rowversion        := SYSDATE;
      Ext_File_Trans_API.Insert_Record(newrec_);
   $ELSE
      NULL;
   $END
END Add_Header_Company;


-- Insert address details of a company details to the Ext_File_Trans_Tab.
PROCEDURE Add_Company_Addresses (
   row_no_       IN OUT NUMBER,
   load_file_id_ IN     NUMBER,
   company_      IN     VARCHAR2,
   country_      IN     VARCHAR2,
   report_type_  IN     VARCHAR2 )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_     ext_file_trans_tab%ROWTYPE;
      emptyrec_   ext_file_trans_tab%ROWTYPE;
   $END
   CURSOR saft_company_address IS
      SELECT company       company,
             address_id    address_id,
             address1      street_name,
             city          city,
             zip_code      postal_code,
             state         region,
             country       country                                                                                                                           
      FROM   company_address_tab
      WHERE  company = company_;
BEGIN      
   $IF Component_Accrul_SYS.INSTALLED $THEN
      FOR saft_company_address_rec_ IN saft_company_address LOOP
         newrec_                   := emptyrec_;
         row_no_                   := row_no_ + 1;
         newrec_.load_file_id      := load_file_id_;
         newrec_.row_no            := row_no_;
         newrec_.record_type_id    := '1.1.1';
         newrec_.c1                := saft_company_address_rec_.company;
         newrec_.c2                := saft_company_address_rec_.address_id;
         newrec_.c3                := saft_company_address_rec_.street_name;
         newrec_.c7                := saft_company_address_rec_.city;
         newrec_.c8                := saft_company_address_rec_.postal_code;
         newrec_.c9                := saft_company_address_rec_.region;
         newrec_.c10               := saft_company_address_rec_.country;
         newrec_.row_state         := '1';
         newrec_.rowversion        := SYSDATE;
         Ext_File_Trans_API.Insert_Record(newrec_);             
      END LOOP;
   $ELSE
      NULL;
   $END  
 END Add_Company_Addresses;


-- Insert address details of a customer to the Ext_File_Trans_Tab.
PROCEDURE Add_Customer_Addresses (
   row_no_        IN OUT NUMBER, 
   load_file_id_  IN     NUMBER,
   customer_id_   IN     VARCHAR2 )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_     ext_file_trans_tab%ROWTYPE;
      emptyrec_   ext_file_trans_tab%ROWTYPE;
   $END
   CURSOR saft_customer_address IS 
      SELECT customer_id                      customer_id,
             address1                         street_name,                  
             city                             city,                      
             zip_code                         postal_code,                
             state                            region,                
             country                          country,               
             address_id                       address_id
      FROM   customer_info_address_tab
      WHERE  customer_id = customer_id_;
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      FOR saft_customer_address_rec_ IN saft_customer_address LOOP    
         newrec_                   := emptyrec_;
         row_no_                   := row_no_ + 1;
         newrec_.load_file_id      := load_file_id_;
         newrec_.row_no            := row_no_;
         newrec_.record_type_id    := '2.3.1.1';
         newrec_.c2                := customer_id_;
         newrec_.c3                := saft_customer_address_rec_.street_name;
         newrec_.c6                := saft_customer_address_rec_.city;
         newrec_.c7                := saft_customer_address_rec_.postal_code;
         newrec_.c8                := saft_customer_address_rec_.region;
         newrec_.c10               := saft_customer_address_rec_.country;
         newrec_.c12               := saft_customer_address_rec_.address_id;   
         newrec_.row_state         := '1';
         newrec_.rowversion        := SYSDATE;
         Ext_File_Trans_API.Insert_Record(newrec_);      
      END LOOP;
   $ELSE
      NULL;
   $END
END Add_Customer_Addresses;


-- Insert customer contact person details to the Ext_File_Trans_Tab.
PROCEDURE Add_Customer_Contact (
   row_no_        IN OUT NUMBER, 
   load_file_id_  IN     NUMBER,
   customer_id_   IN     VARCHAR2 )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_     ext_file_trans_tab%ROWTYPE;
      emptyrec_   ext_file_trans_tab%ROWTYPE;
   $END
   CURSOR saft_customer_address IS 
      SELECT cic.customer_id     customer_id,
             cic.person_id       person_id,
             pi.name             person_name,
             cic.contact_address contact_address,
             pi.title            title,
             pi.first_name       first_name,
             pi.initials         initials,
             pi.prefix           last_name_prefix,
             pi.last_name        last_name,
             pi.birth_name       birth_name
      FROM   customer_info_contact_tab cic,  
             person_info_tab pi
      WHERE  cic.person_id = pi.person_id
      AND    customer_id   = customer_id_;
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      FOR saft_customer_address_rec_ IN saft_customer_address LOOP      
         newrec_                   := emptyrec_;
         row_no_                   := row_no_ + 1;
         newrec_.load_file_id      := load_file_id_;
         newrec_.row_no            := row_no_;
         newrec_.record_type_id    := '2.3.1.2';
         newrec_.c3                := saft_customer_address_rec_.person_id;
         newrec_.c4                := saft_customer_address_rec_.person_name;
         newrec_.c5                := saft_customer_address_rec_.contact_address;
         newrec_.c6                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'PHONE', newrec_.c5);
         newrec_.c7                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'FAX', newrec_.c5);
         newrec_.c8                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'E_MAIL', newrec_.c5);
         newrec_.c9                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'WWW', newrec_.c5);
         newrec_.c10               := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'MOBILE', newrec_.c5);
         newrec_.c11               := saft_customer_address_rec_.title;
         newrec_.c12               := saft_customer_address_rec_.first_name;
         newrec_.c13               := saft_customer_address_rec_.initials;
         newrec_.c14               := saft_customer_address_rec_.last_name_prefix;
         newrec_.c15               := saft_customer_address_rec_.last_name;
         newrec_.c16               := saft_customer_address_rec_.birth_name; 
         newrec_.row_state         := '1';
         newrec_.rowversion        := SYSDATE;
         Ext_File_Trans_API.Insert_Record(newrec_);
      END LOOP;
   $ELSE
      NULL;
   $END
END Add_Customer_Contact;


-- Insert supplier address details to the Ext_File_Trans_Tab.
PROCEDURE Add_Supplier_Addresses (
   row_no_        IN OUT NUMBER, 
   load_file_id_  IN     NUMBER,
   supplier_id_   IN     VARCHAR2 )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_     ext_file_trans_tab%ROWTYPE;
      emptyrec_   ext_file_trans_tab%ROWTYPE;
   $END
   CURSOR saft_supplier_address IS 
      SELECT supplier_id            supplier_id,
             address1               street_name,                
             city                   city,                      
             zip_code               postal_code,                
             state                  region,                      
             country                country,               
             address_id             address_id
      FROM   supplier_info_address_tab
      WHERE  supplier_id = supplier_id_;
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      FOR saft_supplier_address_rec_ IN saft_supplier_address LOOP
         newrec_                   := emptyrec_;
         row_no_                   := row_no_ + 1;
         newrec_.load_file_id      := load_file_id_;
         newrec_.row_no            := row_no_;
         newrec_.record_type_id    := '2.4.1.1';
         newrec_.c2                := supplier_id_;
         newrec_.c3                := saft_supplier_address_rec_.address_id;
         newrec_.c4                := saft_supplier_address_rec_.street_name;
         newrec_.c7                := saft_supplier_address_rec_.city;
         newrec_.c8                := saft_supplier_address_rec_.postal_code;
         newrec_.c9                := saft_supplier_address_rec_.region;
         newrec_.c11               := saft_supplier_address_rec_.country; 
         newrec_.row_state         := '1';
         newrec_.rowversion        := SYSDATE;
         Ext_File_Trans_API.Insert_Record(newrec_);      
      END LOOP;
   $ELSE
      NULL;
   $END
END Add_Supplier_Addresses;


-- Insert supplier contact person details to the Ext_File_Trans_Tab.
PROCEDURE Add_Supplier_Contact (
   row_no_        IN OUT NUMBER, 
   load_file_id_  IN     NUMBER,
   supplier_id_   IN     VARCHAR2 )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_     ext_file_trans_tab%ROWTYPE;
      emptyrec_   ext_file_trans_tab%ROWTYPE;
   $END
   CURSOR saft_supplier_address IS 
      SELECT cic.supplier_id     supplier_id,
             cic.person_id       person_id,
             pi.name             person_name,
             cic.contact_address contact_address,
             pi.title            title,
             pi.first_name       first_name,
             pi.initials         initials,
             pi.prefix           last_name_prefix,
             pi.last_name        last_name,
             pi.birth_name       birth_name
      FROM   supplier_info_contact_tab cic,  
             person_info_tab pi
      WHERE  cic.person_id = pi.person_id
      AND    supplier_id   = supplier_id_;
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      FOR saft_supplier_address_rec_ IN saft_supplier_address LOOP
         newrec_                   := emptyrec_;
         row_no_                   := row_no_ + 1;
         newrec_.load_file_id      := load_file_id_;
         newrec_.row_no            := row_no_;
         newrec_.record_type_id    := '2.4.1.2';
         newrec_.c3                := saft_supplier_address_rec_.person_id;
         newrec_.c4                := saft_supplier_address_rec_.person_name;
         newrec_.c5                := saft_supplier_address_rec_.contact_address;
         newrec_.c6                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'PHONE', newrec_.c5);
         newrec_.c7                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'FAX', newrec_.c5);
         newrec_.c8                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'E_MAIL', newrec_.c5);
         newrec_.c9                := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'WWW', newrec_.c5);
         newrec_.c10               := Comm_Method_API.Get_Default_Value('PERSON', newrec_.c3, 'MOBILE', newrec_.c5);
         newrec_.c11               := saft_supplier_address_rec_.title;
         newrec_.c12               := saft_supplier_address_rec_.first_name;
         newrec_.c13               := saft_supplier_address_rec_.initials;
         newrec_.c14               := saft_supplier_address_rec_.last_name_prefix;
         newrec_.c15               := saft_supplier_address_rec_.last_name;
         newrec_.c16               := saft_supplier_address_rec_.birth_name; 
         newrec_.row_state         := '1';
         newrec_.rowversion        := SYSDATE;
         Ext_File_Trans_API.Insert_Record(newrec_);
      END LOOP;   
   $ELSE
      NULL;
   $END
END Add_Supplier_Contact;


-- Insert Customer details which is associated with a Customer invoice to the Ext_File_Trans_Tab.
PROCEDURE Add_Sales_Inv_Cust_Details (
   row_no_        IN OUT NUMBER,
   load_file_id_  IN     NUMBER,
   identity_      IN     VARCHAR2,
   inv_add_id_    IN     VARCHAR2,
   del_add_id_    IN     VARCHAR2, 
   delivery_date_ IN     DATE )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_   ext_file_trans_tab%ROWTYPE;
   $END
   invoice_address_rec_       Customer_Info_Address_API.Public_Rec;
   delivery_address_rec_      Customer_Info_Address_API.Public_Rec;
BEGIN   
   $IF Component_Accrul_SYS.INSTALLED $THEN
      row_no_                   := row_no_ + 1;
      newrec_.load_file_id      := load_file_id_;
      newrec_.row_no            := row_no_;
      newrec_.row_state         := '1';
      newrec_.record_type_id    := '4.1.1.1';
      newrec_.rowversion        := SYSDATE;
      invoice_address_rec_      := Customer_Info_Address_API.Get(identity_, inv_add_id_);
      delivery_address_rec_     := Customer_Info_Address_API.Get(identity_, del_add_id_);
      newrec_.c3                := identity_;
      newrec_.c4                := Customer_Info_API.Get_Name(identity_);
      newrec_.c5                := inv_add_id_;
      newrec_.c6                := invoice_address_rec_.address1;
      newrec_.c10               := invoice_address_rec_.city;
      newrec_.c11               := invoice_address_rec_.zip_code;
      newrec_.c12               := invoice_address_rec_.state;
      newrec_.c13               := invoice_address_rec_.country;
      newrec_.c15               := del_add_id_;
      newrec_.c16               := TO_CHAR(delivery_date_, saft_date_format_);
      newrec_.c20               := delivery_address_rec_.address1;
      newrec_.c24               := delivery_address_rec_.city;
      newrec_.c25               := delivery_address_rec_.zip_code;
      newrec_.c26               := delivery_address_rec_.state;
      newrec_.c27               := delivery_address_rec_.country;
      Ext_File_Trans_API.Insert_Record(newrec_);
   $ELSE
      NULL;
   $END 
END Add_Sales_Inv_Cust_Details;


-- Insert Supplier details which is associated with a Supplier invoice to the Ext_File_Trans_Tab.
PROCEDURE Add_Purch_Inv_Supp_Details (
   row_no_        IN OUT NUMBER,
   load_file_id_  IN     NUMBER,
   identity_      IN     VARCHAR2,
   inv_add_id_    IN     VARCHAR2,
   del_add_id_    IN     VARCHAR2, 
   delivery_date_ IN     DATE )
IS
   $IF Component_Accrul_SYS.INSTALLED $THEN
      newrec_                 ext_file_trans_tab%ROWTYPE;
   $END
   invoice_address_rec_       Supplier_Info_Address_API.Public_Rec;
   delivery_address_rec_      Supplier_Info_Address_API.Public_Rec;
BEGIN
   $IF Component_Accrul_SYS.INSTALLED $THEN
      row_no_                   := row_no_ + 1;
      newrec_.load_file_id      := load_file_id_;
      newrec_.row_no            := row_no_;
      newrec_.row_state         := '1';
      newrec_.record_type_id    := '4.2.1.2';
      newrec_.rowversion        := SYSDATE;
      invoice_address_rec_      := Supplier_Info_Address_API.Get(identity_, inv_add_id_);
      delivery_address_rec_     := Supplier_Info_Address_API.Get(identity_, del_add_id_);
      newrec_.c3                := identity_;
      newrec_.c4                := Supplier_Info_API.Get_Name(identity_);
      newrec_.c5                := inv_add_id_;
      newrec_.c6                := invoice_address_rec_.address1;
      newrec_.c10               := invoice_address_rec_.city;
      newrec_.c11               := invoice_address_rec_.zip_code;
      newrec_.c12               := invoice_address_rec_.state;
      newrec_.c13               := invoice_address_rec_.country;
      newrec_.c19               := del_add_id_;
      newrec_.c18               := TO_CHAR(delivery_date_, saft_date_format_);
      newrec_.c20               := delivery_address_rec_.address1;
      newrec_.c24               := delivery_address_rec_.city;
      newrec_.c25               := delivery_address_rec_.zip_code;
      newrec_.c26               := delivery_address_rec_.state;
      newrec_.c27               := delivery_address_rec_.country;
      Ext_File_Trans_API.Insert_Record(newrec_);    
   $ELSE
      NULL;
   $END
END Add_Purch_Inv_Supp_Details;
   