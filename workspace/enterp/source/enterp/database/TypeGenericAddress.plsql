-----------------------------------------------------------------------------
--
--  Logical unit: TypeGenericAddress
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981016  Camk    Created.
--  981126  Camk    New table names. Company removed
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  040628  Jeguse  Bug 45629, Added functions Get_Address_Form, Get_Address_Rec, Get_All_Address_Lines and Get_Address_Line 
--  060726  CsAmlk  Persian Calendar Modifications.
--  100402  kanslk  EANE-592, modified view 'TYPE_GENERIC_ADDRESS'
--  110809  Umdolk  FIDEAGLE-352, Merged Bug 94883, Modified Get_Address_Form(), Get_Address_Rec() and Get_All_Address_Lines()
--  151103  THPELK  STRFI-307 - Removed Reset_Valid_From,Reset_Valid_From,Is_Valid,Is_Type,Is_Type_Default,Modify,New,Split_Address___(),Reset_Valid_To(),Remove().
--  160427  Chgulk  STRLOC-56, Changed to code to handle newly introduced address fields.
--  180509  Nirylk Bug 141210, Merged App9 correction. Added new method Validate_Parameter().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist___ (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   type_generic_address
      WHERE  party_type_db = db_value_
      AND    identity = identity_
      AND    address_id = address_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist___;
          
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Line (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   address_id_ IN VARCHAR2,
   line_no_    IN NUMBER DEFAULT 1 ) RETURN VARCHAR2
IS
BEGIN
   IF (party_type_ = 'COMPANY') THEN
      RETURN Company_Address_API.Get_Line(identity_, address_id_, line_no_);
   ELSIF (party_type_ = 'CUSTOMER') THEN
      RETURN Customer_Info_Address_API.Get_Line(identity_, address_id_, line_no_);
   ELSIF (party_type_ = 'SUPPLIER') THEN
      RETURN Supplier_Info_Address_API.Get_Line(identity_, address_id_, line_no_);
   ELSIF (party_type_ = 'MANUFACTURER') THEN
      RETURN Manufacturer_Info_Address_API.Get_Line(identity_, address_id_, line_no_);
   ELSIF (party_type_ = 'OWNER') THEN
      RETURN Owner_Info_Address_API.Get_Line(identity_, address_id_, line_no_);
   ELSIF (party_type_ = 'FORWARDER') THEN
      RETURN Forwarder_Info_Address_API.Get_Line(identity_, address_id_, line_no_);
   ELSIF (party_type_ = 'PERSON') THEN
      RETURN Person_Info_Address_API.Get_Line(identity_, address_id_, line_no_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Line;


@UncheckedAccess
PROCEDURE Exist (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(party_type_, identity_, address_id_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Address (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     type_generic_address.address%TYPE;
   CURSOR get_attr IS
      SELECT address
      FROM   type_generic_address
      WHERE  party_type_db = db_value_
      AND    identity = identity_
      AND    address_id = address_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Address;


FUNCTION Get_Address_Form (
   party_type_     IN VARCHAR2,
   identity_       IN VARCHAR2,
   address_id_     IN VARCHAR2,
   fetch_name_     IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_   IN VARCHAR2 DEFAULT 'TRUE',
   separator_      IN VARCHAR2 DEFAULT NULL,
   order_language_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   party_type_db_   VARCHAR2(20);
BEGIN
   IF (party_type_ IN ('COMPANY','CUSTOMER','SUPPLIER','PERSON','MANUFACTURER','OWNER','FORWARDER','CUSTOMS')) THEN
      party_type_db_ := party_type_;
   ELSE
      party_type_db_ := Party_Type_API.Encode(party_type_);
   END IF;
   IF (party_type_db_ = 'COMPANY') THEN
      RETURN Company_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_);
   ELSIF (party_type_db_ = 'CUSTOMER') THEN
      RETURN Customer_Info_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_, order_language_);
   ELSIF (party_type_db_ = 'SUPPLIER') THEN
      RETURN Supplier_Info_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_);
   ELSIF (party_type_db_ = 'PERSON') THEN
      RETURN Person_Info_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_);
   ELSIF (party_type_db_ = 'MANUFACTURER') THEN
      RETURN Manufacturer_Info_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_);
   ELSIF (party_type_db_ = 'OWNER') THEN
      RETURN Owner_Info_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_);
   ELSIF (party_type_db_ = 'FORWARDER') THEN
      RETURN Forwarder_Info_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_);
   ELSIF (party_type_db_ = 'CUSTOMS') THEN
      RETURN Customs_Info_Address_API.Get_Address_Form(identity_, address_id_, fetch_name_, remove_empty_, separator_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Address_Form;


FUNCTION Get_Address_Rec (
   party_type_     IN VARCHAR2,
   identity_       IN VARCHAR2,
   address_id_     IN VARCHAR2,
   fetch_name_     IN VARCHAR2 DEFAULT 'FALSE',
   remove_empty_   IN VARCHAR2 DEFAULT 'TRUE',
   order_language_ IN VARCHAR2 DEFAULT NULL) RETURN Address_Presentation_API.Address_Rec_Type
IS
   address_rec_     Address_Presentation_API.Address_Rec_Type;
   address_         VARCHAR2(2000);
BEGIN
   address_     := Get_Address_Form(party_type_, 
                                    identity_, 
                                    address_id_, 
                                    fetch_name_, 
                                    remove_empty_, 
                                    order_language_ => order_language_);
   address_rec_ := Address_Presentation_API.Format_To_Line(address_);
   RETURN address_rec_;
END Get_Address_Rec;


PROCEDURE Get_All_Address_Lines (
   party_type_     IN VARCHAR2,
   address_l_      IN OUT VARCHAR2,
   address_2_      IN OUT VARCHAR2,
   address_3_      IN OUT VARCHAR2,
   address_4_      IN OUT VARCHAR2,
   address_5_      IN OUT VARCHAR2,
   address_6_      IN OUT VARCHAR2,
   address_7_      IN OUT VARCHAR2,
   address_8_      IN OUT VARCHAR2,
   address_9_      IN OUT VARCHAR2,
   address_10_     IN OUT VARCHAR2,
   identity_       IN     VARCHAR2,
   address_id_     IN     VARCHAR2,
   fetch_name_     IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_   IN     VARCHAR2 DEFAULT 'TRUE',
   order_language_ IN     VARCHAR2 DEFAULT NULL)
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(party_type_, identity_, address_id_, fetch_name_, remove_empty_, order_language_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
   address_7_   := address_rec_.address7;
   address_8_   := address_rec_.address8;
   address_9_   := address_rec_.address9;
   address_10_  := address_rec_.address10;
END Get_All_Address_Lines;


PROCEDURE Get_All_Address_Lines (
   party_type_     IN     VARCHAR2,
   address_l_      IN OUT VARCHAR2,
   address_2_      IN OUT VARCHAR2,
   address_3_      IN OUT VARCHAR2,
   address_4_      IN OUT VARCHAR2,
   address_5_      IN OUT VARCHAR2,
   address_6_      IN OUT VARCHAR2,
   identity_       IN     VARCHAR2,
   address_id_     IN     VARCHAR2,
   fetch_name_     IN     VARCHAR2 DEFAULT 'FALSE',
   remove_empty_   IN     VARCHAR2 DEFAULT 'TRUE',
   order_language_ IN     VARCHAR2 DEFAULT NULL )
IS
   address_rec_        Address_Presentation_API.Address_Rec_Type;
BEGIN
   address_rec_ := Get_Address_Rec(party_type_, identity_, address_id_, fetch_name_, remove_empty_, order_language_);
   address_l_   := address_rec_.address1;
   address_2_   := address_rec_.address2;
   address_3_   := address_rec_.address3;
   address_4_   := address_rec_.address4;
   address_5_   := address_rec_.address5;
   address_6_   := address_rec_.address6;
END Get_All_Address_Lines;


PROCEDURE Validate_Parameter (
      object_lu_      IN VARCHAR2,
      object_key_     IN VARCHAR2,
      property_name_  IN VARCHAR2,
      property_value_ IN VARCHAR2 )
IS
BEGIN
   IF (object_lu_ = 'PartyType') THEN
      IF (object_key_ = '*') THEN
         IF (property_name_ = 'UNIQUE_OWN_ADDR')THEN
            IF (NVL(property_value_, ' ') NOT IN ('TRUE', 'FALSE')) THEN
               Error_SYS.Record_General(lu_name_, 'NOTVALIDEVENT: Valid values for property (:P1) are (:P2).', object_lu_||','||object_key_||','||property_name_, 'TRUE/FALSE');
            END IF;
         END IF;
      END IF;
   END IF; 
END Validate_Parameter;

