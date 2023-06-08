-----------------------------------------------------------------------------
--
--  Logical unit: ContactUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211203  Kavflk  CRM21R2-258 , Added Job title field into Create_Contact as an attribute .
--  190329  ChJalk  Bug 147636(SCZ-3813), Modified Get_Supp_Comm_Method_Value to get the person comm method only if it is available as a contact in supplier contact address.
--  190302  ApWilk  Bug 147102 (SCZ-3491), Modified Get_Cust_Comm_Method_Value() and Get_Supp_Comm_Method_Value() to fetch the correct information
--  190302          for Enabling the RMB options when using E-mail for the customer reference with Connect All Customer Addresses check box is checked.
--  181024  AsZelk  Bug 144007 (SCZ-1001), Modified Get_Cust_Comm_Method_Value to check whether the person is connected to the Customer Contact.
--  160413  reanpl  STRLOC-75, Added handling of new attributes address3, address4, address5, address6 in Copy_Customer_Address
--  150916  SudJlk  AFT-4154, Modified Get_Supp_Comm_Method_Value and Get_Cust_Comm_Method_Value to retrieve email when the contact is Supplier Primary and Customer Primary.
--  150914  SudJlk  AFT-2263, Modified Get_Supp_Contact_Name and Get_Cust_Contact_Name to retrieve the name when the contact is 
--  150914          Supplier Primary and Customer Primary.
--  150908  RoJalk  AFT-4154, Modified Get_Cust_Comm_Method_Value and Get_Supp_Comm_Method_Value to support Primary Customer and 
--  150908          Primary Supplier when address is not defined in the contact information. 
--  150904  RoJalk  AFT-2983 and AFT-2263, Modified Get_Cust_Contact_Name, Get_Supp_Contact_Name to fetch contact name when 
--  150904          contact is supplier primary/customer primary and no address is defined for the contact.
--  150706  SudJlk  ORA-869, Modified Create_Contact to pass supplier_contact when calling Person_Info_API.New__.
--  150123  MaRalk  PRSC-5384, Modified method Create_Contact in order to facilitate retrieving Initials 
--  150123          which coming from Customer_Info_Contact_API.Create_Contact.
--  140916  JanWse  PRSC-2365, Modified Create_Contact to support user defined PERSON_ID
--  140916          Added separator_ as argument to Get_Contact_Customers and Get_Contact_Suppliers
--  140526  MaRalk  PBSC-8831, Modified method Create_Contact in order to facilitate retrieving first, middle, last names 
--  140526          which coming from Customer_Info_Contact_API.Create_Contact.
--  130611  MaRalk  PBR-1764, Modified method Create_Contact in order to save First, Middle, Last names when a Person is created in Creating Contact process.
--  130321  Nipjlk  Bug 108698, Modified the Return type of methods Get_Contact_Customers and Get_Contact_Suppliers
--  110526  Chhulk  EASTONE-19647, Merged Bug 94646.
--  100824  Shsalk  Bug 92377, Modified methods Get_Contact_Customers and Get_Contact_Suppliers
--  091113  Chhulk  Bug 86663, Modified Get_Cust_Comm_Method_Value to check whether the person is connected to the Customer Contact.
--  100113  Umdolk  Refactoring in Communication methods in Enterprise.
--  080605  Kagalk  Bug 74521, Added  Get_Cust_Comm_Method_Value, Get_Supp_Comm_Method_Value
--  080522  Kagalk  Bug 70056, Added  Get_Cust_Contact_Name , Get_Supp_Contact_Name.
--  070829  AmPalk  Modified Create_Contact by adding new attribute TITLE to the Person_Info and passing attributes WWW, MESSENGER, INTERCOM and PAGER to the Add_Comm_Method.
--  070404  ToBeSe  Create
--  151222  Chiblk  STRFI-890, Rewrite sub methods to implmentation methods
--  160419  ChguLK  STRLOC-347, Added new attributes address3,address4,address5,address6.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Comm_Method___ (
   person_id_  IN VARCHAR2,
   address_id_ IN VARCHAR2,
   method_db_  IN VARCHAR2,
   value_      IN VARCHAR2 )
IS
   comm_id_ NUMBER;
BEGIN
   -- Only create method if it has a value
   IF (value_ IS NULL) THEN
      RETURN;
   END IF;
   Comm_Method_API.New(comm_id_,
                       'PERSON', 
                       person_id_, 
                       method_id_ => Comm_Method_Code_API.Decode(method_db_),
                       value_ => value_, 
                       method_default_ => 'TRUE',
                       address_default_ => 'FALSE', 
                       address_id_ => address_id_);
END Add_Comm_Method___;   


FUNCTION Get_Person_Address_Type___ RETURN VARCHAR2
IS
   tmp_   VARCHAR2(200);
BEGIN
   tmp_ := Object_Property_API.Get_Value('PartyType', 'PERSON', 'CONTACT_DEFAULT_ADDR_TYPE');
   -- Return default address if set
   IF (tmp_ IS NOT NULL) THEN
      RETURN tmp_;
   END IF;
   -- Get the valid address types
   tmp_ := Object_Property_API.Get_Value('PartyType', 'PERSON', 'VALID_ADDR');
   IF (INSTR(tmp_, 'CORRESPONDENCE') > 0) THEN
      RETURN 'CORRESPONDENCE';
   END IF;
   IF (INSTR(tmp_, 'VISIT') > 0) THEN
      RETURN 'VISIT';
   END IF;
   RETURN tmp_;
END Get_Person_Address_Type___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Contact (
   attr_ IN OUT VARCHAR2 )
IS
   new_attr_           VARCHAR2(2000);
   info_               VARCHAR2(2000);
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   customer_id_        customer_info_tab.customer_id%TYPE;
   person_id_          person_info_tab.person_id%TYPE;
   address_id_         person_info_address_tab.address_id%TYPE;
   supplier_id_        supplier_info_tab.supplier_id%TYPE;
   person_full_name_   person_info_tab.name%TYPE;
   person_first_name_  person_info_tab.first_name%TYPE;
   person_middle_name_ person_info_tab.middle_name%TYPE;
   person_last_name_   person_info_tab.last_name%TYPE;
BEGIN
   -- Create Person
   Client_SYS.Clear_Attr(new_attr_);
   --Prepare
   Person_Info_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
   -- Add attributes
   person_full_name_ := Client_SYS.Get_Item_Value('NAME', attr_);
   Client_SYS.Add_To_Attr('NAME', person_full_name_, new_attr_);
   person_id_ := Client_SYS.Get_Item_Value('PERSON_ID', attr_);
   person_first_name_ :=  Client_SYS.Get_Item_Value('FIRST_NAME', attr_);
   person_middle_name_ :=  Client_SYS.Get_Item_Value('MIDDLE_NAME', attr_);
   person_last_name_ :=  Client_SYS.Get_Item_Value('LAST_NAME', attr_);
   customer_id_ := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
   supplier_id_ := Client_SYS.Get_Item_Value('SUPPLIER_ID', attr_);
   address_id_ := Client_SYS.Get_Item_Value('ADDRESS_ID', attr_);
   IF (person_first_name_ IS NULL AND person_middle_name_ IS NULL AND person_last_name_ IS NULL) THEN
     Person_Info_API.Analyze_Name(person_first_name_, person_middle_name_, person_last_name_, person_full_name_); 
   END IF;     
   IF (person_id_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PERSON_ID', person_id_, new_attr_);
   END IF;
   Client_SYS.Add_To_Attr('FIRST_NAME', person_first_name_, new_attr_);
   Client_SYS.Add_To_Attr('MIDDLE_NAME', person_middle_name_, new_attr_);
   Client_SYS.Add_To_Attr('LAST_NAME', person_last_name_, new_attr_);
   Client_SYS.Add_To_Attr('TITLE', Client_SYS.Get_Item_Value('TITLE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('JOB_TITLE', Client_SYS.Get_Item_Value('JOB_TITLE', attr_), new_attr_);
   Client_SYS.Add_To_Attr('INITIALS', Client_SYS.Get_Item_Value('INITIALS', attr_), new_attr_);
   IF (customer_id_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('CUSTOMER_CONTACT_DB', Fnd_Boolean_API.DB_TRUE, new_attr_);
   END IF;
   IF (supplier_id_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('SUPPLIER_CONTACT_DB', Fnd_Boolean_API.DB_TRUE, new_attr_);
   END IF;
   -- Create
   Person_Info_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
   -- Get new ID
   IF (person_id_ IS NULL) THEN
      person_id_ := Client_SYS.Get_Item_Value('PERSON_ID', new_attr_);
   END IF;
   IF (customer_id_ IS NOT NULL AND address_id_ IS NOT NULL) THEN
      Copy_Customer_Address(person_id_, customer_id_, address_id_);
   END IF;
   IF (supplier_id_ IS NOT NULL AND address_id_ IS NOT NULL) THEN
      Copy_Supplier_Address(person_id_, supplier_id_, address_id_);
   END IF;
   -- Communication Methods
   Add_Comm_Method___(person_id_, address_id_, 'PHONE', Client_SYS.Get_Item_Value('PHONE', attr_));
   Add_Comm_Method___(person_id_, address_id_, 'FAX', Client_SYS.Get_Item_Value('FAX', attr_));
   Add_Comm_Method___(person_id_, address_id_, 'MOBILE', Client_SYS.Get_Item_Value('MOBILE', attr_));
   Add_Comm_Method___(person_id_, address_id_, 'E_MAIL', Client_SYS.Get_Item_Value('E_MAIL', attr_));
   Add_Comm_Method___(person_id_, address_id_, 'WWW', Client_SYS.Get_Item_Value('WWW', attr_));
   Add_Comm_Method___(person_id_, address_id_, 'MESSENGER', Client_SYS.Get_Item_Value('MESSENGER', attr_));
   Add_Comm_Method___(person_id_, address_id_, 'INTERCOM', Client_SYS.Get_Item_Value('INTERCOM', attr_));
   Add_Comm_Method___(person_id_, address_id_, 'PAGER', Client_SYS.Get_Item_Value('PAGER', attr_));
   -- Return the Person ID
   Client_SYS.Add_To_Attr('PERSON_ID', person_id_, attr_);
END Create_Contact;


PROCEDURE Copy_Customer_Address (
   person_id_    IN VARCHAR2,
   customer_id_  IN VARCHAR2,
   address_id_   IN VARCHAR2 )
IS
   address_type_   VARCHAR2(30);
BEGIN
   address_type_ := Get_Person_Address_Type___;
   Person_Info_Address_API.New_Address(person_id_,
                                       address_id_,
                                       address1_ => Customer_Info_Address_API.Get_Address1(customer_id_, address_id_),
                                       address2_ => Customer_Info_Address_API.Get_Address2(customer_id_, address_id_),
                                       address3_ => Customer_Info_Address_API.Get_Address3(customer_id_, address_id_),
                                       address4_ => Customer_Info_Address_API.Get_Address4(customer_id_, address_id_),
                                       address5_ => Customer_Info_Address_API.Get_Address5(customer_id_, address_id_),
                                       address6_ => Customer_Info_Address_API.Get_Address6(customer_id_, address_id_),
                                       zip_code_ => Customer_Info_Address_API.Get_Zip_Code(customer_id_, address_id_),
                                       city_ => Customer_Info_Address_API.Get_City(customer_id_, address_id_),
                                       state_ => Customer_Info_Address_API.Get_State(customer_id_, address_id_),
                                       country_ => Customer_Info_Address_API.Get_Country(customer_id_, address_id_),
                                       valid_from_ => Customer_Info_Address_API.Get_Valid_From(customer_id_, address_id_),
                                       valid_to_ => Customer_Info_Address_API.Get_Valid_To(customer_id_, address_id_),
                                       county_ => Customer_Info_Address_API.Get_County(customer_id_, address_id_));
END Copy_Customer_Address;


PROCEDURE Copy_Supplier_Address (
   person_id_   IN VARCHAR2,
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2 )
IS
   address_type_   VARCHAR2(30);
BEGIN
   address_type_ := Get_Person_Address_Type___;
   Person_Info_Address_API.New_Address(person_id_,
                                       address_id_,
                                       address1_ => Supplier_Info_Address_API.Get_Address1(supplier_id_, address_id_),
                                       address2_ => Supplier_Info_Address_API.Get_Address2(supplier_id_, address_id_),
                                       address3_ => Supplier_Info_Address_API.Get_Address3(supplier_id_, address_id_),
                                       address4_ => Supplier_Info_Address_API.Get_Address4(supplier_id_, address_id_),
                                       address5_ => Supplier_Info_Address_API.Get_Address5(supplier_id_, address_id_),
                                       address6_ => Supplier_Info_Address_API.Get_Address6(supplier_id_, address_id_),
                                       zip_code_ => Supplier_Info_Address_API.Get_Zip_Code(supplier_id_, address_id_),
                                       city_ => Supplier_Info_Address_API.Get_City(supplier_id_, address_id_),
                                       state_ => Supplier_Info_Address_API.Get_State(supplier_id_, address_id_),
                                       country_ => Supplier_Info_Address_API.Get_Country(supplier_id_, address_id_),
                                       valid_from_ => Supplier_Info_Address_API.Get_Valid_From(supplier_id_, address_id_),
                                       valid_to_ => Supplier_Info_Address_API.Get_Valid_To(supplier_id_, address_id_),
                                       county_ => Supplier_Info_Address_API.Get_County(supplier_id_, address_id_));
END Copy_Supplier_Address;


@UncheckedAccess
FUNCTION Get_Contact_Customers (
   person_id_ IN VARCHAR2,
   separator_ IN VARCHAR2 DEFAULT '^' ) RETURN VARCHAR2
IS
   CURSOR customers IS
      SELECT DISTINCT customer_id
      FROM   customer_info_contact_tab
      WHERE  person_id = person_id_;
   tmp_ VARCHAR2(32000);
BEGIN
   FOR rec_ IN customers LOOP
      IF (NVL(LENGTH(tmp_),0) < 4000) THEN
         tmp_ := tmp_ || rec_.customer_id || separator_;
      ELSE
         EXIT;
      END IF;
   END LOOP;
   IF (LENGTH(tmp_) > 4000) THEN
      tmp_ := SUBSTR(tmp_,0,4000);
      tmp_ := SUBSTR(tmp_,0,INSTR(tmp_,separator_,-1));
   END IF;
   RETURN SUBSTR(tmp_, 0, LENGTH(tmp_) - LENGTH(separator_));
END Get_Contact_Customers;


@UncheckedAccess
FUNCTION Get_Contact_Suppliers (
   person_id_ IN VARCHAR2,
   separator_ IN VARCHAR2 DEFAULT '^' ) RETURN VARCHAR2
IS
   CURSOR suppliers IS
      SELECT DISTINCT supplier_id
      FROM   supplier_info_contact_tab
      WHERE  person_id = person_id_;
   tmp_ VARCHAR2(32000);
BEGIN
   FOR rec_ IN suppliers LOOP
      IF (NVL(LENGTH(tmp_),0) < 4000) THEN
         tmp_ := tmp_ || rec_.supplier_id || separator_;
      ELSE
         EXIT;
      END IF;
   END LOOP;
   IF (LENGTH(tmp_) > 4000) THEN
      tmp_ := SUBSTR(tmp_,0,4000);
      tmp_ := SUBSTR(tmp_,0,INSTR(tmp_,separator_,-1));
   END IF;
   RETURN SUBSTR(tmp_, 0, LENGTH(tmp_) - LENGTH(separator_));
END Get_Contact_Suppliers;


PROCEDURE Modify_Item_Value (
   name_  IN     VARCHAR2,
   value_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
BEGIN
   -- Design remark: The Attribute order is the same as in Client_SYS.Set_Item_Value
   IF (value_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value(name_, value_, attr_);
   END IF;  
END Modify_Item_Value;


@UncheckedAccess
FUNCTION Get_Cust_Contact_Name (
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   contact_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   name_        cust_info_contact_lov_pub.name%TYPE;
   CURSOR get_name IS
      SELECT name
      FROM   cust_info_contact_lov_pub
      WHERE  customer_id = customer_id_
      AND    address_id  = address_id_
      AND    person_id   = contact_;
   CURSOR get_name_primary IS
      SELECT name
      FROM   cust_info_contact_lov_pub
      WHERE  customer_id = customer_id_
      AND    customer_primary = 'TRUE'
      AND    person_id   = contact_;
BEGIN
  OPEN get_name;
  FETCH get_name INTO name_;
  CLOSE get_name;
  IF (name_ IS NULL) THEN
      OPEN get_name_primary;
      FETCH get_name_primary INTO name_;
      CLOSE get_name_primary;
   END IF;
  RETURN  name_;
END Get_Cust_Contact_Name;


@UncheckedAccess
FUNCTION Get_Supp_Contact_Name (
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   contact_     IN VARCHAR2 ) RETURN VARCHAR2
IS  
   name_        supp_info_contact_lov_pub.name%TYPE;
   CURSOR get_name IS
      SELECT name
      FROM   supp_info_contact_lov_pub
      WHERE  supplier_id = supplier_id_
      AND    address_id  = address_id_
      AND    person_id   = contact_;
    CURSOR get_name_primary IS
      SELECT name
      FROM   supp_info_contact_lov_pub
      WHERE  supplier_id = supplier_id_
      AND    supplier_primary = 'TRUE'
      AND    person_id   = contact_;
BEGIN  
   OPEN get_name;
   FETCH get_name INTO name_;
   CLOSE get_name;
   IF (name_ IS NULL) THEN
      OPEN get_name_primary;
      FETCH get_name_primary INTO name_;
      CLOSE get_name_primary;
   END IF;
   RETURN  name_;
END Get_Supp_Contact_Name;


@UncheckedAccess
FUNCTION Get_Cust_Comm_Method_Value (    
   customer_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   contact_     IN VARCHAR2,
   comm_method_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_contact_addr IS
      SELECT contact_address
      FROM   customer_info_contact_tab
      WHERE  customer_id      = customer_id_
      AND    person_id        = contact_
      AND    (customer_address = address_id_ OR connect_all_cust_addr = 'TRUE');
   CURSOR get_contact_addr_primary IS
      SELECT contact_address
      FROM   customer_info_contact_tab
      WHERE  customer_id      = customer_id_
      AND    person_id        = contact_
      AND    customer_primary = 'TRUE';
   contact_address_     customer_info_contact_tab.contact_address%TYPE;
   value_               VARCHAR2(200);
   contact_found_       VARCHAR2(5) := 'FALSE';
BEGIN
   OPEN get_contact_addr;
   FETCH get_contact_addr INTO contact_address_;
   IF (get_contact_addr%FOUND) THEN
      contact_found_ := 'TRUE';
   END IF;
   CLOSE get_contact_addr;
   IF (contact_address_ IS NULL) THEN   
      OPEN get_contact_addr_primary;
      FETCH get_contact_addr_primary INTO contact_address_;
      IF (get_contact_addr_primary%FOUND) THEN
         contact_found_ := 'TRUE';
      END IF;
      CLOSE get_contact_addr_primary;
   END IF;
   IF (contact_found_ = 'TRUE') THEN
      value_ := Comm_Method_API.Get_Value('PERSON', contact_, comm_method_, 1, contact_address_);
   END IF;
   IF (value_ IS NULL) THEN
      value_ := Comm_Method_API.Get_Name_Value('CUSTOMER', customer_id_, comm_method_, contact_, address_id_);  
   END IF;
   RETURN value_;
END Get_Cust_Comm_Method_Value;


@UncheckedAccess
FUNCTION Get_Supp_Comm_Method_Value (    
   supplier_id_ IN VARCHAR2,
   address_id_  IN VARCHAR2,
   contact_     IN VARCHAR2,
   comm_method_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_contact_addr IS
      SELECT contact_address
      FROM   supplier_info_contact_tab
      WHERE  supplier_id      = supplier_id_
      AND    person_id        = contact_
      AND    (supplier_address = address_id_ OR connect_all_supp_addr = 'TRUE');
   CURSOR get_contact_addr_primary IS
      SELECT contact_address
      FROM   supplier_info_contact_tab
      WHERE  supplier_id      = supplier_id_
      AND    person_id        = contact_
      AND    supplier_primary = 'TRUE';
   contact_address_     supplier_info_contact_tab.contact_address%TYPE;
   value_               VARCHAR2(200);
   found_sup_contact_   VARCHAR2(5) := 'FALSE';
BEGIN
   OPEN get_contact_addr;
   FETCH get_contact_addr INTO contact_address_;
   IF (get_contact_addr%FOUND) THEN
      found_sup_contact_ := 'TRUE';
   END IF;
   CLOSE get_contact_addr;
   IF (contact_address_ IS NULL) THEN   
      OPEN get_contact_addr_primary;
      FETCH get_contact_addr_primary INTO contact_address_;
      IF (get_contact_addr_primary%FOUND) THEN
         found_sup_contact_ := 'TRUE';
      END IF;
      CLOSE get_contact_addr_primary;
   END IF;
   IF (found_sup_contact_ = 'TRUE') THEN
      value_ := Comm_Method_API.Get_Value('PERSON', contact_, comm_method_, 1, contact_address_);
   END IF;
   IF (value_ IS NULL) THEN
      value_ := Comm_Method_API.Get_Name_Value('SUPPLIER', supplier_id_, comm_method_, contact_, address_id_); 
   END IF;
   RETURN value_;
END Get_Supp_Comm_Method_Value;



