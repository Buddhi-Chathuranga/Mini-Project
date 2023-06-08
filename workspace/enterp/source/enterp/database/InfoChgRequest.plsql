-----------------------------------------------------------------------------
--
--  Logical unit: InfoChgRequest
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210817  NaLrlk  PR21R2-589, Removed NOCOPY from IN OUT parameters.
--  210810  NaLrlk  PR21R2-589, Modified changes for support Prospect supplier and modify contact name.
--  210808  NaLrlk  PR21R2-590, Modified change request for contact person's full name and title.
--  210806  NaLrlk  PR21R2-589, Modified changes to support prospect suppliers.
--  210803  NaLrlk  PR21R2-582, Added Preliminary_Request_Exist() to check for Preliminary requests exist.
--  210802  NaLrlk  PR21R2-399, Added request to new person for contact information.
--  210731  NaLrlk  PR21R2-399, Added request for new contact information.
--  210728  NaLrlk  PR21R2-398, Modified changes for rename the info_chg_request tables.
--  210728  NaLrlk  PR21R2-398, Added request for New address information.
--  210721  NaLrlk  PR21R2-401, Added Approve_Change_Request___(), Approve_Supp_Info_Chg_Req___(), Approve_Supp_Addr_Chg_Req___() and
--  210721          Approve_Supp_Contac_Chg_Req___() to handle update for change requests.
--  210715  NaLrlk  PR21R2-396, Modified New() to support for new attributes company and change_reference.
--  210712  NaLrlk  PR21R2-400, Added Approve() and Reject() for state changes.
--  210701  NaLrlk  PR21R2-395, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Approve_Change_Request___
--   Update the requested changes when Approve state is completed.
@IgnoreUnitTest DMLOperation
PROCEDURE Approve_Change_Request___ (
   rec_  IN OUT info_chg_request_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   IF (rec_.party_type = Party_Type_API.DB_SUPPLIER) THEN
      IF (rec_.change_area = Change_Request_Info_Area_API.DB_GENERAL) THEN
         Approve_Supp_Info_Chg_Req___(rec_);
      ELSIF (rec_.change_area = Change_Request_Info_Area_API.DB_ADDRESS) THEN
         Approve_Supp_Addr_Chg_Req___(rec_);
      ELSIF (rec_.change_area = Change_Request_Info_Area_API.DB_CONTACT) THEN
         Approve_Supp_Contac_Chg_Req___(rec_);
      END IF;
   END IF;
END Approve_Change_Request___;


@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT info_chg_request_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.request_id := Get_Request_Id___;
   newrec_.requested_by := NVL(newrec_.requested_by, Fnd_Session_API.Get_Fnd_User);
   newrec_.requested_date := NVL(newrec_.requested_date, SYSDATE);
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-- Get_Request_Id___
--   Returns next request id.
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Request_Id___ RETURN NUMBER
IS
   request_id_  NUMBER;
   CURSOR next_request_id IS
      SELECT info_chg_request_seq.NEXTVAL
      FROM   dual;
BEGIN
   OPEN  next_request_id;
   FETCH next_request_id INTO request_id_;
   CLOSE next_request_id;
   RETURN(request_id_);
END Get_Request_Id___;


-- Approve_Supp_Info_Chg_Req___
--   Modify supplier with the requested general information changes.
@IgnoreUnitTest DMLOperation
PROCEDURE Approve_Supp_Info_Chg_Req___ (
   rec_  IN info_chg_request_tab%ROWTYPE )   
IS
   supp_info_attr_      VARCHAR2(4000);
   supp_invoic_attr_    VARCHAR2(4000);
   srm_supp_info_attr_  VARCHAR2(4000);
   pay_addr_attr_       VARCHAR2(4000);
   our_id_attr_         VARCHAR2(1000);
   supp_category_db_    VARCHAR2(20);
   address_id_          VARCHAR2(50);
   way_id_              VARCHAR2(20); 
   def_phone_           VARCHAR2(200);
   def_fax_             VARCHAR2(200);
   def_email_           VARCHAR2(200);
   def_www_             VARCHAR2(200);
   def_phone_changed_   BOOLEAN := FALSE;
   def_fax_changed_     BOOLEAN := FALSE;
   def_email_changed_   BOOLEAN := FALSE;
   def_www_changed_     BOOLEAN := FALSE;
   CURSOR get_lines IS
      SELECT change_information, new_value
      FROM   info_chg_request_line_tab
      WHERE  request_id = rec_.request_id;
BEGIN
   Client_SYS.Clear_Attr(supp_info_attr_);
   Client_SYS.Clear_Attr(srm_supp_info_attr_);
   Client_SYS.Clear_Attr(supp_invoic_attr_);
   Client_SYS.Clear_Attr(pay_addr_attr_);
   Client_SYS.Clear_Attr(our_id_attr_);
   FOR linerec_ IN get_lines LOOP
      CASE linerec_.change_information
         WHEN ('NAME') THEN 
            Client_SYS.Add_To_Attr('NAME', linerec_.new_value, supp_info_attr_);
         WHEN ('ASSOCIATION_NO') THEN 
            Client_SYS.Add_To_Attr('ASSOCIATION_NO', linerec_.new_value, supp_info_attr_);
         WHEN ('DEFAULT_LANGUAGE') THEN 
            Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE_DB', linerec_.new_value, supp_info_attr_);
         WHEN ('COUNTRY') THEN 
            Client_SYS.Add_To_Attr('COUNTRY_DB', linerec_.new_value, supp_info_attr_);
         WHEN ('CORPORATE_FORM') THEN 
            Client_SYS.Add_To_Attr('CORPORATE_FORM', linerec_.new_value, supp_info_attr_);
         WHEN ('OUR_ID') THEN
            Client_SYS.Add_To_Attr('OUR_ID', linerec_.new_value, our_id_attr_);
         $IF Component_Srm_SYS.INSTALLED $THEN
         WHEN ('TURNOVER') THEN 
            Client_SYS.Add_To_Attr('TURNOVER', linerec_.new_value, srm_supp_info_attr_);
         WHEN ('TURNOVER_CURRCODE') THEN 
            Client_SYS.Add_To_Attr('CURRENCY_CODE', linerec_.new_value, srm_supp_info_attr_);
         WHEN ('GEOGRAPHY_CODE') THEN 
            Client_SYS.Add_To_Attr('GEOGRAPHY_CODE_DB', linerec_.new_value, srm_supp_info_attr_);
         $END
         WHEN ('PHONE') THEN
            def_phone_changed_ := TRUE;
            def_phone_ := linerec_.new_value;
         WHEN ('FAX') THEN
            def_fax_changed_ := TRUE;
            def_fax_ := linerec_.new_value;
         WHEN ('E_MAIL') THEN
            def_email_changed_ := TRUE;
            def_email_ := linerec_.new_value;
         WHEN ('WWW') THEN
            def_www_changed_ := TRUE;
            def_www_ := linerec_.new_value;
         $IF Component_Invoic_SYS.INSTALLED $THEN
         WHEN ('CURRENCY_CODE') THEN 
            Client_SYS.Add_To_Attr('DEF_CURRENCY', linerec_.new_value, supp_invoic_attr_);
         WHEN ('PAY_TERM_ID') THEN 
            Client_SYS.Add_To_Attr('PAY_TERM_ID', linerec_.new_value, supp_invoic_attr_);
         $END
         $IF Component_Payled_SYS.INSTALLED $THEN
         WHEN ('ACCOUNT') THEN 
            Client_SYS.Add_To_Attr('ACCOUNT', linerec_.new_value, pay_addr_attr_);
         WHEN ('BIC_CODE') THEN 
            Client_SYS.Add_To_Attr('BIC_CODE', linerec_.new_value, pay_addr_attr_);
         $END         
      END CASE;            
   END LOOP;
   IF (supp_info_attr_ IS NOT NULL) THEN
      supp_category_db_ := Supplier_Info_General_API.Get_Supplier_Category_Db(rec_.identity);
      IF (supp_category_db_ = Supplier_Info_Category_API.DB_SUPPLIER) THEN
         Supplier_Info_API.Modify_Supplier(supp_info_attr_, rec_.identity);
      ELSIF (supp_category_db_ = Supplier_Info_Category_API.DB_PROSPECT) THEN
         Supplier_Info_Prospect_API.Modify(supp_info_attr_, rec_.identity);
      END IF;
   END IF;
   IF (our_id_attr_ IS NOT NULL) THEN
      IF (Supplier_Info_Our_Id_API.Exists(rec_.identity, rec_.company)) THEN
         Supplier_Info_Our_Id_API.Modify(our_id_attr_, rec_.identity, rec_.company);
      ELSE
         Client_SYS.Add_To_Attr('SUPPLIER_ID', rec_.identity, our_id_attr_);
         Client_SYS.Add_To_Attr('COMPANY', rec_.company, our_id_attr_);
         Supplier_Info_Our_Id_API.New(our_id_attr_);
      END IF;
   END IF;
   $IF Component_Srm_SYS.INSTALLED $THEN
   IF (srm_supp_info_attr_ IS NOT NULL) THEN
      IF (Srm_Supp_Info_API.Exists(rec_.identity)) THEN
         Srm_Supp_Info_API.Modify(srm_supp_info_attr_, rec_.identity);
      ELSE
         Client_SYS.Add_To_Attr('SUPPLIER_ID', rec_.identity, srm_supp_info_attr_);
         Srm_Supp_Info_API.New(srm_supp_info_attr_, NULL);
      END IF;
   END IF;
   $END
   IF (def_phone_changed_) THEN
      Modify_Default_Comm_Method___(rec_.party_type, rec_.identity, def_phone_, 'PHONE');
   END IF;
   IF (def_fax_changed_) THEN
      Modify_Default_Comm_Method___(rec_.party_type, rec_.identity, def_fax_, 'FAX');
   END IF;
   IF (def_email_changed_) THEN
      Modify_Default_Comm_Method___(rec_.party_type, rec_.identity, def_email_, 'E_MAIL');
   END IF;
   IF (def_www_changed_) THEN
      Modify_Default_Comm_Method___(rec_.party_type, rec_.identity, def_www_, 'WWW');
   END IF;
   $IF Component_Invoic_SYS.INSTALLED $THEN
   IF (supp_invoic_attr_ IS NOT NULL) THEN
      Identity_Invoice_Info_API.Modify(rec_.company, rec_.identity, rec_.party_type, supp_invoic_attr_);
   END IF;
   $END
   $IF Component_Payled_SYS.INSTALLED $THEN
   IF (pay_addr_attr_ IS NOT NULL) THEN
      way_id_       := Payment_Way_Per_Identity_API.Get_Default_Pay_Way_Db(rec_.company, rec_.identity, rec_.party_type);
      address_id_   := Payment_Address_API.Get_Default_Address_Id_Db(rec_.company, rec_.identity, rec_.party_type, way_id_);
      Payment_Address_API.Modify(pay_addr_attr_, rec_.company, rec_.identity, rec_.party_type, way_id_, address_id_);
   END IF;
   $END
END Approve_Supp_Info_Chg_Req___;


-- Approve_Supp_Info_Chg_Req___
--   Modify supplier with the requested address information changes.
@IgnoreUnitTest DMLOperation
PROCEDURE Approve_Supp_Addr_Chg_Req___ (
   rec_  IN info_chg_request_tab%ROWTYPE )   
IS
   supp_addr_rec_            supplier_info_address_tab%ROWTYPE;
   supp_info_addr_attr_      VARCHAR2(10000);
   supp_address_attr_        VARCHAR2(4000);
   delivery_type_attr_       VARCHAR2(1000);
   invoic_type_attr_         VARCHAR2(1000);
   pay_type_attr_            VARCHAR2(1000);
   visit_type_attr_          VARCHAR2(1000);
   address_id_               VARCHAR2(50);
   CURSOR get_lines IS
      SELECT change_information, new_value
      FROM   info_chg_request_line_tab
      WHERE  request_id = rec_.request_id;
BEGIN
   address_id_ := Client_SYS.Get_Key_Reference_Value(rec_.change_reference, 'ADDRESS_ID');
   Client_SYS.Clear_Attr(supp_info_addr_attr_);
   Client_SYS.Clear_Attr(supp_address_attr_);
   Client_SYS.Clear_Attr(delivery_type_attr_);
   Client_SYS.Clear_Attr(invoic_type_attr_);
   Client_SYS.Clear_Attr(pay_type_attr_);
   Client_SYS.Clear_Attr(visit_type_attr_);
   FOR linerec_ IN get_lines LOOP
      CASE linerec_.change_information
         WHEN ('ADDRESS_ID') THEN
            supp_addr_rec_.address_id := linerec_.new_value;
         WHEN ('EAN_LOCATION') THEN
            supp_addr_rec_.ean_location := linerec_.new_value;
            Client_SYS.Add_To_Attr('EAN_LOCATION', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ADDRESS_NAME') THEN
            supp_addr_rec_.name := linerec_.new_value;   
            Client_SYS.Add_To_Attr('NAME', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ADDR_COUNTRY') THEN
            supp_addr_rec_.country := linerec_.new_value;
            Client_SYS.Add_To_Attr('COUNTRY_DB', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('VALID_FROM') THEN
            supp_addr_rec_.valid_from := Client_SYS.Attr_Value_To_Date(linerec_.new_value);
            Client_SYS.Add_To_Attr('VALID_FROM', To_Date(linerec_.new_value), supp_info_addr_attr_);
         WHEN ('VALID_TO') THEN
            supp_addr_rec_.valid_to := Client_SYS.Attr_Value_To_Date(linerec_.new_value);
            Client_SYS.Add_To_Attr('VALID_TO', To_Date(linerec_.new_value), supp_info_addr_attr_);
         WHEN ('ADDRESS1') THEN
            supp_addr_rec_.address1 := linerec_.new_value;
            Client_SYS.Add_To_Attr('ADDRESS1', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ADDRESS2') THEN
            supp_addr_rec_.address2 := linerec_.new_value;
            Client_SYS.Add_To_Attr('ADDRESS2', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ADDRESS3') THEN
            supp_addr_rec_.address3 := linerec_.new_value;
            Client_SYS.Add_To_Attr('ADDRESS3', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ADDRESS4') THEN
            supp_addr_rec_.address4 := linerec_.new_value;
            Client_SYS.Add_To_Attr('ADDRESS4', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ADDRESS5') THEN
            supp_addr_rec_.address5 := linerec_.new_value;
            Client_SYS.Add_To_Attr('ADDRESS5', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ADDRESS6') THEN
            supp_addr_rec_.address6 := linerec_.new_value;
            Client_SYS.Add_To_Attr('ADDRESS6', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('CITY') THEN
            supp_addr_rec_.city := linerec_.new_value;
            Client_SYS.Add_To_Attr('CITY', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('COUNTY') THEN
            supp_addr_rec_.county := linerec_.new_value;
            Client_SYS.Add_To_Attr('COUNTY', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('STATE') THEN
            supp_addr_rec_.state := linerec_.new_value;
            Client_SYS.Add_To_Attr('STATE', linerec_.new_value, supp_info_addr_attr_);
         WHEN ('ZIP_CODE') THEN
            supp_addr_rec_.zip_code := linerec_.new_value;
            Client_SYS.Add_To_Attr('ZIP_CODE', linerec_.new_value, supp_info_addr_attr_);
         $IF Component_Purch_SYS.INSTALLED $THEN
         WHEN ('DELIVERY_TERMS') THEN
            Client_SYS.Add_To_Attr('DELIVERY_TERMS', linerec_.new_value, supp_address_attr_);
         WHEN ('SHIP_VIA_CODE') THEN
            Client_SYS.Add_To_Attr('SHIP_VIA_CODE', linerec_.new_value, supp_address_attr_);
         WHEN ('DEL_TERMS_LOCATION') THEN
            Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', linerec_.new_value, supp_address_attr_);
         $END
         WHEN ('DEF_DELIVERY_ADDRESS') THEN
            Client_SYS.Add_To_Attr('DEF_ADDRESS', linerec_.new_value, delivery_type_attr_);
         WHEN ('DEF_INVOICE_ADDRESS') THEN
            Client_SYS.Add_To_Attr('DEF_ADDRESS', linerec_.new_value, invoic_type_attr_);
         WHEN ('DEF_PAY_ADDRESS') THEN
            Client_SYS.Add_To_Attr('DEF_ADDRESS', linerec_.new_value, pay_type_attr_);
         WHEN ('DEF_VISIT_ADDRESS') THEN
            Client_SYS.Add_To_Attr('DEF_ADDRESS', linerec_.new_value, visit_type_attr_);
      END CASE;            
   END LOOP;
   IF (supp_info_addr_attr_ IS NOT NULL) THEN
      IF (rec_.change_type = Change_Request_Info_Type_API.DB_NEW) THEN
         Supplier_Info_Address_API.New_Address(supplier_id_  => rec_.identity,
                                               address_id_   => address_id_,
                                               address1_     => supp_addr_rec_.address1,
                                               address2_     => supp_addr_rec_.address2,
                                               zip_code_     => supp_addr_rec_.zip_code,
                                               city_         => supp_addr_rec_.city,
                                               state_        => supp_addr_rec_.state,
                                               country_      => Iso_Country_API.Decode(supp_addr_rec_.country),
                                               ean_location_ => supp_addr_rec_.ean_location,
                                               valid_from_   => supp_addr_rec_.valid_from,
                                               valid_to_     => supp_addr_rec_.valid_to,
                                               county_       => supp_addr_rec_.county,
                                               name_         => supp_addr_rec_.name,
                                               address3_     => supp_addr_rec_.address3,
                                               address4_     => supp_addr_rec_.address4,
                                               address5_     => supp_addr_rec_.address5,
                                               address6_     => supp_addr_rec_.address6);
      ELSIF (rec_.change_type = Change_Request_Info_Type_API.DB_EDIT) THEN
         Supplier_Info_Address_API.Modify_Other_Address_Info(rec_.identity, address_id_, supp_info_addr_attr_);
      END IF;         
   END IF;
   $IF Component_Purch_SYS.INSTALLED $THEN
   IF (supp_address_attr_ IS NOT NULL) THEN
      Supplier_Address_API.Modify_Supplier_Addr_Info(supp_address_attr_, rec_.identity, address_id_);
   END IF;
   $END
   IF (delivery_type_attr_ IS NOT NULL) THEN
      Modify_Supp_Address_Type___(delivery_type_attr_, rec_.identity, address_id_, 'DELIVERY', rec_.change_type);
   END IF;
   IF (invoic_type_attr_ IS NOT NULL) THEN
      Modify_Supp_Address_Type___(invoic_type_attr_, rec_.identity, address_id_, 'INVOICE', rec_.change_type);
   END IF;
   IF (pay_type_attr_ IS NOT NULL) THEN
      Modify_Supp_Address_Type___(pay_type_attr_, rec_.identity, address_id_, 'PAY', rec_.change_type);
   END IF;
   IF (visit_type_attr_ IS NOT NULL) THEN
      Modify_Supp_Address_Type___(visit_type_attr_, rec_.identity, address_id_, 'VISIT', rec_.change_type);
   END IF;
END Approve_Supp_Addr_Chg_Req___;


-- Approve_Supp_Contac_Chg_Req___
--   Modify supplier with the requested contact information changes.
@IgnoreUnitTest DMLOperation
PROCEDURE Approve_Supp_Contac_Chg_Req___ (
   rec_  IN info_chg_request_tab%ROWTYPE )   
IS
   person_rec_          Person_Info_API.Public_Rec;
   supp_contact_attr_   VARCHAR2(10000);
   person_id_           VARCHAR2(20);
   guid_                VARCHAR2(50);
   def_phone_           VARCHAR2(200);
   def_mobile_          VARCHAR2(200);
   def_fax_             VARCHAR2(200);
   def_email_           VARCHAR2(200);
   def_www_             VARCHAR2(200);
   person_info_changed_ BOOLEAN := FALSE;
   def_phone_changed_   BOOLEAN := FALSE;
   def_mobile_changed_  BOOLEAN := FALSE;
   def_fax_changed_     BOOLEAN := FALSE;
   def_email_changed_   BOOLEAN := FALSE;
   def_www_changed_     BOOLEAN := FALSE;
   CURSOR get_lines IS
      SELECT change_information, new_value
      FROM   info_chg_request_line_tab
      WHERE  request_id = rec_.request_id;
BEGIN
   person_id_ := Client_SYS.Get_Key_Reference_Value(rec_.change_reference, 'PERSON_ID');
   guid_      := Client_SYS.Get_Key_Reference_Value(rec_.change_reference, 'GUID');
   IF (person_id_ IS NOT NULL) THEN
      person_rec_ := Person_Info_API.Get(person_id_);
   END IF;
   Client_SYS.Clear_Attr(supp_contact_attr_);
   FOR linerec_ IN get_lines LOOP
      CASE linerec_.change_information
         WHEN ('TITLE') THEN
            IF (person_id_ IS NOT NULL) THEN
               person_info_changed_ := TRUE;
               person_rec_.title    := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('TITLE', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_NAME') THEN
            IF (person_id_ IS NOT NULL) THEN
               person_info_changed_ := TRUE;
               person_rec_.name     := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('NAME', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_FIRST_NAME') THEN
            IF (person_id_ IS NOT NULL) THEN
               person_info_changed_   := TRUE;
               person_rec_.first_name := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('FIRST_NAME', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_MIDDLE_NAME') THEN
            IF (person_id_ IS NOT NULL) THEN
               person_info_changed_    := TRUE;
               person_rec_.middle_name := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('MIDDLE_NAME', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_LAST_NAME') THEN
            IF (person_id_ IS NOT NULL) THEN
               person_info_changed_  := TRUE;
               person_rec_.last_name := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('LAST_NAME', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('SUPPLIER_PRIMARY') THEN
            Client_SYS.Add_To_Attr('SUPPLIER_PRIMARY', linerec_.new_value, supp_contact_attr_);
         WHEN ('ADDRESS_PRIMARY') THEN
            Client_SYS.Add_To_Attr('ADDRESS_PRIMARY', linerec_.new_value, supp_contact_attr_);
         WHEN ('CONNECT_ALL_SUPP_ADDR') THEN
            Client_SYS.Add_To_Attr('CONNECT_ALL_SUPP_ADDR_DB', linerec_.new_value, supp_contact_attr_);
         WHEN ('ROLE') THEN
            Client_SYS.Add_To_Attr('ROLE', Contact_Role_API.Decode_List(linerec_.new_value), supp_contact_attr_);
         WHEN ('SUPPLIER_ADDRESS') THEN
            Client_SYS.Add_To_Attr('SUPPLIER_ADDRESS', linerec_.new_value, supp_contact_attr_);
         $IF Component_Rmcom_SYS.INSTALLED $THEN
         WHEN ('DEPARTMENT') THEN
            Client_SYS.Add_To_Attr('DEPARTMENT', Contact_Department_API.Decode(linerec_.new_value), supp_contact_attr_);
         $END
         WHEN ('CONTACT_PHONE') THEN
            IF (person_id_ IS NOT NULL) THEN
               def_phone_changed_ := TRUE;
               def_phone_ := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('PHONE', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_MOBILE') THEN
            IF (person_id_ IS NOT NULL) THEN
               def_mobile_changed_ := TRUE;
               def_mobile_ := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('MOBILE', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_EMAIL') THEN
            IF (person_id_ IS NOT NULL) THEN
               def_email_changed_ := TRUE;
               def_email_ := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('E_MAIL', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_FAX') THEN
            IF (person_id_ IS NOT NULL) THEN
               def_fax_changed_ := TRUE;
               def_fax_ := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('FAX', linerec_.new_value, supp_contact_attr_);
            END IF;
         WHEN ('CONTACT_WWW') THEN
            IF (person_id_ IS NOT NULL) THEN
               def_www_changed_ := TRUE;
               def_www_ := linerec_.new_value;
            ELSE
               Client_SYS.Add_To_Attr('WWW', linerec_.new_value, supp_contact_attr_);
            END IF;
      END CASE;            
   END LOOP;
   IF (rec_.change_type = Change_Request_Info_Type_API.DB_NEW) THEN
      IF (supp_contact_attr_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('SUPPLIER_ID', rec_.identity, supp_contact_attr_);
         Supplier_Info_Contact_API.Create_Contact(supp_contact_attr_);
      END IF;
   ELSIF (rec_.change_type = Change_Request_Info_Type_API.DB_EDIT) THEN
      IF (person_info_changed_) THEN
         Person_Info_API.Modify_Full_Name(person_id_,
                                          person_rec_.name,
                                          person_rec_.first_name,
                                          person_rec_.middle_name,
                                          person_rec_.last_name,
                                          person_rec_.title,
                                          person_rec_.job_title,
                                          person_rec_.initials);
      END IF;
      IF (supp_contact_attr_ IS NOT NULL) THEN
         Supplier_Info_Contact_API.Modify(supp_contact_attr_, rec_.identity, person_id_, guid_);
      END IF;
      IF (def_phone_changed_) THEN
         Modify_Default_Comm_Method___('PERSON', person_id_, def_phone_, 'PHONE');
      END IF;
      IF (def_mobile_changed_) THEN
         Modify_Default_Comm_Method___('PERSON', person_id_, def_mobile_, 'MOBILE');
      END IF;
      IF (def_email_changed_) THEN
         Modify_Default_Comm_Method___('PERSON', person_id_, def_email_, 'E_MAIL');
      END IF;
      IF (def_fax_changed_) THEN
         Modify_Default_Comm_Method___('PERSON', person_id_, def_fax_, 'FAX');
      END IF;
      IF (def_www_changed_) THEN
         Modify_Default_Comm_Method___('PERSON', person_id_, def_www_, 'WWW');
      END IF;
   END IF;
END Approve_Supp_Contac_Chg_Req___;


-- Modify_Default_Comm_Method___
--   Modify the default communication method for specified party.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Default_Comm_Method___ (
   party_type_  IN VARCHAR2,
   identity_    IN VARCHAR2,
   value_       IN VARCHAR2,
   method_id_   IN VARCHAR2 )
IS
   comm_id_  NUMBER;
BEGIN
   comm_id_ := Comm_Method_API.Get_Default_Comm_Id(party_type_, identity_, method_id_);
   IF (comm_id_ IS NOT NULL) THEN
      IF (value_ IS NULL) THEN
         Comm_Method_API.Remove(party_type_, identity_, comm_id_);
      ELSE
         Comm_Method_API.Modify(party_type_, identity_, comm_id_, value_, Fnd_Boolean_API.DB_TRUE);
      END IF;
   ELSE
      IF (value_ IS NOT NULL) THEN
         Comm_Method_API.New(comm_id_, 
                             party_type_, 
                             identity_, 
                             value_,
                             method_default_ => Fnd_Boolean_API.DB_TRUE,
                             method_id_      => Comm_Method_Code_API.Decode(method_id_));
      END IF;
   END IF;
END Modify_Default_Comm_Method___;


-- Modify_Supp_Address_Type___
--   Modify or Create supplier address type according to the specified change type.
@IgnoreUnitTest DMLOperation
PROCEDURE Modify_Supp_Address_Type___ (
   attr_                  IN OUT VARCHAR2,
   identity_              IN     VARCHAR2,
   address_id_            IN     VARCHAR2,
   address_type_code_db_  IN     VARCHAR2,
   change_type_db_        IN     VARCHAR2 )
IS
   def_address_  VARCHAR2(5);
BEGIN
   IF (change_type_db_ = Change_Request_Info_Type_API.DB_NEW) THEN
      def_address_ := Client_SYS.Get_Item_Value('DEF_ADDRESS', attr_);
      Supplier_Info_Address_Type_API.New(identity_, address_id_, Address_Type_Code_API.Decode(address_type_code_db_), def_address_);
   ELSIF (change_type_db_ = Change_Request_Info_Type_API.DB_EDIT) THEN
      Supplier_Info_Address_Type_API.Modify(attr_, identity_, address_id_, address_type_code_db_);
   END IF;
END Modify_Supp_Address_Type___;   

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public interface to create a record.
@IgnoreUnitTest DMLOperation
PROCEDURE New (
   request_id_        OUT NUMBER,
   party_type_        IN  VARCHAR2,
   identity_          IN  VARCHAR2,
   company_           IN  VARCHAR2,
   change_area_       IN  VARCHAR2,
   change_type_       IN  VARCHAR2,
   change_reference_  IN  VARCHAR2,
   comments_          IN  VARCHAR2 )
IS
   newrec_  info_chg_request_tab%ROWTYPE;
BEGIN
   newrec_.party_type := party_type_;
   newrec_.identity := identity_;
   newrec_.company := company_;
   newrec_.change_area := change_area_;
   newrec_.change_type := change_type_;
   newrec_.change_reference := change_reference_;
   newrec_.comments := comments_;
   New___(newrec_);
   request_id_ := newrec_.request_id;
END New;


-- Approve
--   Approve the given change request and modify approver information.
@IgnoreUnitTest DMLOperation
PROCEDURE Approve (
   info_              OUT VARCHAR2,
   request_id_        IN  NUMBER,
   approver_comments_ IN  VARCHAR2 )
IS
   rec_   info_chg_request_tab%ROWTYPE;
   attr_  VARCHAR2(2000);
BEGIN
   rec_ := Lock_By_Keys___(request_id_);
   Finite_State_Machine___(rec_, 'Approve', attr_);
   rec_.approver_comments := approver_comments_;
   rec_.approved_by := Fnd_Session_API.Get_Fnd_User;
   rec_.approved_date := SYSDATE;
   Modify___(rec_);
   info_ := Client_SYS.Get_All_Info;
END Approve;


-- Reject
--   Reject the given change request and modify approver information.
@IgnoreUnitTest DMLOperation
PROCEDURE Reject (
   info_              OUT VARCHAR2,
   request_id_        IN  NUMBER,
   approver_comments_ IN  VARCHAR2 )
IS
   rec_   info_chg_request_tab%ROWTYPE;
   attr_  VARCHAR2(2000);
BEGIN
   rec_ := Lock_By_Keys___(request_id_);
   Finite_State_Machine___(rec_, 'Reject', attr_);
   rec_.approver_comments := approver_comments_;
   rec_.approved_by := Fnd_Session_API.Get_Fnd_User;
   rec_.approved_date := SYSDATE;
   Modify___(rec_);
   info_ := Client_SYS.Get_All_Info;
END Reject;


-- Preliminary_Request_Exist
--   Checks whether any Preliminary requests exists or not.
@UncheckedAccess
FUNCTION Preliminary_Request_Exist (
   party_type_  IN  VARCHAR2,
   identity_    IN  VARCHAR2,
   company_     IN  VARCHAR2 ) RETURN VARCHAR2
IS
   prel_req_exist_  VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   dummy_           NUMBER;
   CURSOR prel_request_exist IS
      SELECT 1
      FROM   info_chg_request_tab
      WHERE  party_type = party_type_
      AND    identity   = identity_
      AND    company    = company_
      AND    rowstate   = 'Preliminary';
BEGIN
   IF (party_type_ IS NOT NULL AND identity_ IS NOT NULL AND company_ IS NOT NULL) THEN
      OPEN prel_request_exist;
      FETCH prel_request_exist INTO dummy_;
      IF (prel_request_exist%FOUND) THEN
         prel_req_exist_ := Fnd_Boolean_API.DB_TRUE;
      END IF;  
      CLOSE prel_request_exist;
   END IF;
   RETURN prel_req_exist_;
END Preliminary_Request_Exist;
