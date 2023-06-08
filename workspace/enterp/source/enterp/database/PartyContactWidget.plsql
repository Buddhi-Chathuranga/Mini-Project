-----------------------------------------------------------------------------
--
--  Logical unit: PartyContactWidget
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-- 06-7-20  sawelk Introduce PartyContactWidgetSDK and PartyContactWidget utility
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE User_Info_Rec IS RECORD
  (user_id                    VARCHAR2(200),
   directory_id               VARCHAR2(200),
   name                       VARCHAR2(250),
   smtp_email                 VARCHAR2(250),
   mobile_phone               VARCHAR2(200),
   email                      VARCHAR2(250),
   person_id                  VARCHAR2(200),
   picture                    BLOB,
   page                       VARCHAR2(250),
   picture_etag               VARCHAR2(200),
   work_phone                 VARCHAR2(200),
   mobile_no                  VARCHAR2(200),
   preferred_language         VARCHAR2(200),
   fallback_language          VARCHAR2(200)
 );
 
 TYPE Public_Person_Info_Rec IS RECORD
  (
   name                       VARCHAR2(250),   
   email                      VARCHAR2(250),   
   picture                    BLOB,   
   picture_etag               VARCHAR2(200),
   work_phone                 VARCHAR2(200),
   mobile_no                  VARCHAR2(200)   
 );
 
 TYPE Public_Info_Rec IS RECORD
  (
   name                       VARCHAR2(250),   
   email                      VARCHAR2(250),      
   picture_etag               VARCHAR2(200),
   work_phone                 VARCHAR2(200),
   mobile_no                  VARCHAR2(200)   
 );
 
 TYPE Fnd_User_Info_Rec IS RECORD
  (
   user_id                    VARCHAR2(200),
   directory_id               VARCHAR2(200),
   name                       VARCHAR2(250),   
   email                      VARCHAR2(250),
   mobile_no                  VARCHAR2(200),
   picture_etag               VARCHAR2(200)      
 );

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_User_Name_(
   user_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS

BEGIN
   RETURN Fnd_User_API.Get_Description(user_id_);
END Get_User_Name_;

FUNCTION Get_User_Picture_(
   user_id_ IN VARCHAR2 ) RETURN BLOB
IS
   picture_id_ NUMBER := Get_Picture_Id___(user_id_);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   display_text_     VARCHAR2(2000);
   file_name_        VARCHAR2(2000);
   file_path_        VARCHAR2(2000);
   external_storage_ VARCHAR2(2000);
   application_data_ VARCHAR2(2000);
   lob_objid_        VARCHAR2(2000);
   length_           NUMBER;
   picture_ BLOB;
BEGIN
   IF picture_id_ IS NOT NULL THEN
      Binary_Object_API.Get_Object_Info(objid_, objversion_, display_text_, file_name_, file_path_, external_storage_, application_data_, length_, lob_objid_, picture_id_);

      SELECT data INTO picture_
      FROM BINARY_OBJECT_DATA_BLOCK_TAB
      WHERE ROWID = lob_objid_;
      RETURN picture_;
   ELSE
      RETURN NULL;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_User_Picture_;

FUNCTION Get_User_Picture_Stream_(
   user_id_ IN VARCHAR2 ) RETURN BLOB
IS

BEGIN
   RETURN Get_User_Picture_(user_id_);
END Get_User_Picture_Stream_;


FUNCTION Get_Person_Picture_(
   person_id_ IN VARCHAR2 ) RETURN BLOB
IS
   picture_id_ NUMBER;
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   display_text_     VARCHAR2(2000);
   file_name_        VARCHAR2(2000);
   file_path_        VARCHAR2(2000);
   external_storage_ VARCHAR2(2000);
   application_data_ VARCHAR2(2000);
   lob_objid_        VARCHAR2(2000);
   length_           NUMBER;
   picture_ BLOB;
BEGIN   
   picture_id_ := Person_Info_API.Get_Picture_Id(person_id_);

   IF picture_id_ IS NOT NULL THEN
      Binary_Object_API.Get_Object_Info(objid_, objversion_, display_text_, file_name_, file_path_, external_storage_, application_data_, length_, lob_objid_, picture_id_);

      SELECT data INTO picture_
      FROM BINARY_OBJECT_DATA_BLOCK_TAB
      WHERE ROWID = lob_objid_;
      RETURN picture_;
   ELSE
      RETURN NULL;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Person_Picture_;


FUNCTION Get_Person_Picture_Stream_(
   person_id_ IN VARCHAR2 ) RETURN BLOB
IS

BEGIN
   RETURN Get_Person_Picture_(person_id_);
END Get_Person_Picture_Stream_;


FUNCTION Get_Person_Name___(
   person_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN   
   RETURN Person_Info_API.Get_Name(person_id_);   
END Get_Person_Name___;

FUNCTION Get_Person_Information_(
   person_id_ IN VARCHAR2 ) RETURN Public_Person_Info_Rec
IS
   rec_ Public_Person_Info_Rec;
BEGIN
   rec_.name := Get_Person_Name___(person_id_);
   rec_.picture := NULL;
   rec_.email := Get_Person_Email___(person_id_);
   rec_.work_phone := Get_Person_Phone_No___(person_id_);
   rec_.mobile_no := Get_Person_Mobile_No___(person_id_);
   rec_.picture_etag := Get_Person_Pic_Etag___(person_id_);   
   RETURN rec_;
END Get_Person_Information_;


FUNCTION Get_User_Pic_Etag___(
   user_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   picture_id_ NUMBER := Get_Picture_Id___(user_id_);
BEGIN
   RETURN Get_Picture_Etag___(picture_id_);
END Get_User_Pic_Etag___;

FUNCTION Get_Picture_Etag___(
   picture_id_ IN NUMBER) RETURN VARCHAR2
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   display_text_     VARCHAR2(2000);
   file_name_        VARCHAR2(2000);
   file_path_        VARCHAR2(2000);
   external_storage_ VARCHAR2(2000);
   application_data_ VARCHAR2(2000);
   lob_objid_        VARCHAR2(2000);
   length_           NUMBER;
BEGIN
   IF picture_id_ IS NOT NULL THEN
      Binary_Object_API.Get_Object_Info(objid_, objversion_, display_text_, file_name_, file_path_, external_storage_, application_data_, length_, lob_objid_, picture_id_);
      RETURN objid_|| objversion_;
   ELSE
      RETURN NULL;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Picture_Etag___;

FUNCTION Get_Person_Email___ (
   person_id_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN   
   RETURN Comm_Method_API.Get_Default_Value(Party_Type_API.DB_PERSON, person_id_, Comm_Method_Code_API.DB_E_MAIL);   
END Get_Person_Email___;

FUNCTION Get_Person_Phone_No___ (
   person_id_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN   
   RETURN Comm_Method_API.Get_Default_Value(Party_Type_API.DB_PERSON, person_id_, Comm_Method_Code_API.DB_PHONE);   
END Get_Person_Phone_No___;

FUNCTION Get_Person_Mobile_No___ (
   person_id_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN   
   RETURN Comm_Method_API.Get_Default_Value(Party_Type_API.DB_PERSON, person_id_, Comm_Method_Code_API.DB_MOBILE);   
END Get_Person_Mobile_No___;


FUNCTION Get_Fnd_User_Information_(
   user_id_ IN VARCHAR2 ) RETURN Fnd_User_Info_Rec
IS
   rec_ Fnd_User_Info_Rec;
   fnd_user_rec_ Fnd_User_API.Public_Rec;
BEGIN
   fnd_user_rec_ := Fnd_User_API.Get(user_id_);
   rec_.user_id := fnd_user_rec_.identity;
   rec_.directory_id := fnd_user_rec_.web_user;
   rec_.name := fnd_user_rec_.description;
   rec_.email := fnd_user_api.get_property(user_id_, 'SMTP_MAIL_ADDRESS');
   rec_.mobile_no := fnd_user_api.get_property(user_id_, 'MOBILE_PHONE');
   rec_.picture_etag := Get_User_Pic_Etag___(user_id_);
   RETURN rec_;
END Get_Fnd_User_Information_;


FUNCTION Get_Picture_Id___ (
   fnd_user_ IN VARCHAR2 )RETURN VARCHAR2
IS
   picture_id_ NUMBER;
BEGIN   
   SELECT PICTURE_ID INTO picture_id_
   FROM PERSON_INFO_ALL
   WHERE user_id = fnd_user_;
   RETURN picture_id_;   
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Picture_Id___;

FUNCTION Get_Person_Pic_Etag___(
   person_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   picture_id_ NUMBER;
BEGIN   
   picture_id_ := Person_Info_API.Get_Picture_Id(person_id_);
   RETURN Get_Picture_Etag___(picture_id_);
END Get_Person_Pic_Etag___;


FUNCTION Get_Supplier_Information_ (
   supplier_id_ IN VARCHAR2 ) RETURN Public_Info_Rec
IS
   details_ 	       Public_Info_Rec;
   address_type_code_  VARCHAR2(30) := NULL;   
   supplier_info_rec_  Supplier_Info_API.Public_Rec;   
BEGIN   
   supplier_info_rec_    := Supplier_Info_API.Get(supplier_id_);
   address_type_code_    := Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DOCUMENT);
   details_.name         := supplier_info_rec_.name;
   details_.email        := Comm_Method_API.Get_Default_Value_Add_Type(Party_Type_API.DB_SUPPLIER, supplier_id_, Comm_Method_Code_API.DB_E_MAIL, address_type_code_);
   details_.work_phone   := Comm_Method_API.Get_Default_Value_Add_Type(Party_Type_API.DB_SUPPLIER, supplier_id_, Comm_Method_Code_API.DB_PHONE, address_type_code_);
   details_.mobile_no    := Comm_Method_API.Get_Default_Value_Add_Type(Party_Type_API.DB_SUPPLIER, supplier_id_, Comm_Method_Code_API.DB_MOBILE, address_type_code_);
   details_.picture_etag := Get_Image_Etag___(supplier_info_rec_.picture_id, 1);   
   RETURN details_;
END Get_Supplier_Information_;

FUNCTION Get_Customer_Information_ (
   customer_id_ IN VARCHAR2) RETURN Public_Info_Rec
IS
   details_           Public_Info_Rec;
   address_type_code_ VARCHAR2(30) := NULL;   
   customer_info_rec_ Customer_Info_API.Public_Rec;   
BEGIN	
   customer_info_rec_    := Customer_Info_API.Get(customer_id_);
   address_type_code_    := Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DELIVERY);
   details_.name         := customer_info_rec_.name;
   details_.email        := Comm_Method_API.Get_Default_Value_Add_Type(Party_Type_API.DB_CUSTOMER, customer_id_, Comm_Method_Code_API.DB_E_MAIL, address_type_code_);
   details_.work_phone   := Comm_Method_API.Get_Default_Value_Add_Type(Party_Type_API.DB_CUSTOMER, customer_id_, Comm_Method_Code_API.DB_PHONE, address_type_code_);
   details_.mobile_no    := Comm_Method_API.Get_Default_Value_Add_Type(Party_Type_API.DB_CUSTOMER, customer_id_, Comm_Method_Code_API.DB_MOBILE, address_type_code_);
   details_.picture_etag := Get_Image_Etag___(customer_info_rec_.picture_id, 1);
   RETURN details_;

END Get_Customer_Information_;


FUNCTION Get_Image_Etag___ (
   blob_id_ IN  VARCHAR2,
   seq_     IN  NUMBER ) RETURN VARCHAR2
IS 
   data_rec_ Binary_Object_Data_Block_API.Public_Rec;
BEGIN
   data_rec_ := Binary_Object_Data_Block_API.Get(blob_id_, seq_);
   RETURN data_rec_."rowid" || to_char(data_rec_.rowversion,'YYYYMMDDHH24MISS');
END;


FUNCTION Get_Customer_Image_ (
   customer_id_ IN VARCHAR2 ) RETURN BLOB
IS
BEGIN
   RETURN Binary_Object_Data_Block_API.Get_Data(Customer_Info_API.Get_Picture_Id(customer_id_), 1);
END Get_Customer_Image_;

FUNCTION Get_Supplier_Image_ (
   supplier_id_ IN VARCHAR2 ) RETURN BLOB
IS
BEGIN
   RETURN Binary_Object_Data_Block_API.Get_Data(Supplier_Info_API.Get_Picture_Id(supplier_id_), 1);
END Get_Supplier_Image_;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


