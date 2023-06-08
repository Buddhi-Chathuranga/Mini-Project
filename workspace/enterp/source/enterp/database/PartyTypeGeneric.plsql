-----------------------------------------------------------------------------
--
--  Logical unit: PartyTypeGeneric
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981014  Camk    Created
--  981016  Camk    Default domain added
--  981126  Camk    New table names. Company removed
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  090320  MOHRLK  Bug 79377, Changed the column comment ref of the
--  090320          "user_id" in PARTY_TYPE_GENERIC view to FndUser
--  090916  ShWilk  Upgraded Dexter implementations to App7.5 SP4
--  100319  ShWilk  DevLog Issue ID:156784, Modified SUPPLIER_CUSTOMER_LOV.
--  130214  MaRalk  PBR-1203, Added customer_category filter to the SUPPLIER_CUSTOMER_LOV view definition
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist___ (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   dummy_    NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
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

@UncheckedAccess
FUNCTION Get_Name_For_User__ (
   user_id_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Person_Info_API.Get_Name_For_User(user_id_);
END Get_Name_For_User__;


@UncheckedAccess
FUNCTION Get_User_Id__ (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (party_type_ = 'PERSON') THEN
      RETURN Person_Info_API.Get_User_Id(identity_);
   ELSE
      RETURN NULL;
   END IF;
END Get_User_Id__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Identity (
   party_      IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.country%TYPE;
   CURSOR get_attr IS
      SELECT identity
      FROM   party_type_generic
      WHERE  party = party_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Identity;


@UncheckedAccess
FUNCTION Get_Default_Address (
   party_type_        IN VARCHAR2,
   identity_          IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
BEGIN
   IF (party_type_ = 'COMPANY') THEN
      RETURN Company_Address_API.Get_Default_Address(identity_, address_type_code_, curr_date_);
   ELSIF (party_type_ = 'CUSTOMER') THEN
      RETURN Customer_Info_Address_API.Get_Default_Address(identity_, address_type_code_, curr_date_);
   ELSIF (party_type_ = 'SUPPLIER') THEN
      RETURN Supplier_Info_Address_API.Get_Default_Address(identity_, address_type_code_, curr_date_);
   ELSIF (party_type_ = 'MANUFACTURER') THEN
      RETURN Manufacturer_Info_Address_API.Get_Default_Address(identity_, address_type_code_, curr_date_);
   ELSIF (party_type_ = 'OWNER') THEN
      RETURN Owner_Info_Address_API.Get_Default_Address(identity_, address_type_code_, curr_date_);
   ELSIF (party_type_ = 'FORWARDER') THEN
      RETURN Forwarder_Info_Address_API.Get_Default_Address(identity_, address_type_code_, curr_date_);
   ELSIF (party_type_ = 'PERSON') THEN
      RETURN Person_Info_Address_API.Get_Default_Address(identity_, address_type_code_, curr_date_);
   ELSE
      RETURN NULL;
   END IF;
END Get_Default_Address;


@UncheckedAccess
FUNCTION Check_Exist (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(party_type_, identity_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE New (
   party_type_       IN VARCHAR2,
   identity_         IN VARCHAR2,
   name_             IN VARCHAR2,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   dummy_            IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL,
   protected_        IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   IF (party_type_ = 'PERSON') THEN
      Person_Info_API.New(identity_, name_, Iso_Country_API.Encode(country_), Iso_Language_API.Encode(default_language_));
   ELSE
      NULL;
   END IF;
END New;


@UncheckedAccess
FUNCTION Is_Protected (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  IF (party_type_ = 'PERSON') THEN
     RETURN Person_Info_API.Is_Protected(identity_);
  ELSE
     RETURN NULL;
  END IF;
END Is_Protected;


PROCEDURE Set_Protected (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   protect_    IN VARCHAR2 )
IS
BEGIN
   IF (party_type_ = 'PERSON') THEN
      Person_Info_API.Set_Protected(identity_, protect_);
   ELSE
      NULL;
   END IF;
END Set_Protected;


@UncheckedAccess
FUNCTION Is_User_Auth (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
  IF (party_type_ = 'PERSON') THEN
     RETURN Person_Info_API.Is_User_Auth(identity_);
  ELSE
     RETURN NULL;
  END IF;
END Is_User_Auth;


PROCEDURE Modify_Name (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2,
   name_       IN VARCHAR2 )
IS
BEGIN
   IF (party_type_ = 'PERSON') THEN
      Person_Info_API.Modify(identity_, name_);
   ELSE
      NULL;
   END IF;
END Modify_Name;


PROCEDURE Remove (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 )
IS
BEGIN
   IF (party_type_ = 'PERSON') THEN
      Person_Info_API.Remove(identity_);
   ELSE
      NULL;
   END IF;
END Remove;


@UncheckedAccess
PROCEDURE Exist (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2  )
IS
BEGIN
   IF (NOT Check_Exist___(party_type_, identity_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Association_No (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.association_no%TYPE;
   CURSOR get_attr IS
      SELECT association_no
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Association_No;


@UncheckedAccess
FUNCTION Get_Country (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.country%TYPE;
   CURSOR get_attr IS
      SELECT country_DB
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN SUBSTR(Iso_Country_API.Decode(temp_),1,200);
END Get_Country;


@UncheckedAccess
FUNCTION Get_Creation_Date (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN DATE
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.creation_date%TYPE;
   CURSOR get_attr IS
      SELECT creation_date
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Creation_Date;


@UncheckedAccess
FUNCTION Get_Default_Language (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.default_language%TYPE;
   CURSOR get_attr IS
      SELECT default_language_db
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN SUBSTR(Iso_Language_API.Decode(temp_),1,200);
END Get_Default_Language;


@UncheckedAccess
FUNCTION Get_Name (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.name%TYPE;
   CURSOR get_attr IS
      SELECT name
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Name;


@UncheckedAccess
FUNCTION Get_Party (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.party%TYPE;
   CURSOR get_attr IS
      SELECT party
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Party;


@UncheckedAccess
FUNCTION Get_Sup_Party (
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_     party_type_generic.sup_party%TYPE;
   CURSOR get_attr IS
      SELECT sup_party
      FROM   party_type_generic
      WHERE  identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Sup_Party;



