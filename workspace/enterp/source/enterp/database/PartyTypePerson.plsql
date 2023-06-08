-----------------------------------------------------------------------------
--
--  Logical unit: PartyTypePerson
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981026  Camk    Created.
--  000804  Camk    Bug #15677 Corrected. General_SYS.Init_Method added
--  090320  MOHRLK  Bug 79377, Changed the column comment ref of the
--  090320          "user_id" in PARTY_TYPE_PERSON view to FndUse
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Id_For_User (
   user_id_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   identity_  VARCHAR2(20);
   CURSOR get_id IS
      SELECT identity
      FROM   party_type_person
      WHERE  user_id = user_id_;
BEGIN
   OPEN get_id;
   FETCH get_id INTO identity_;
   CLOSE get_id;
   RETURN identity_;
END Get_Id_For_User;


@UncheckedAccess
FUNCTION Get_Name_For_User (
   user_id_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Name_For_User__(user_id_);
END Get_Name_For_User;


@UncheckedAccess
FUNCTION Get_User_Id (
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_User_Id__(Party_Type_API.Decode('PERSON'), identity_);
END Get_User_Id;


@UncheckedAccess
FUNCTION Check_Exist (
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Check_Exist(Party_Type_API.Decode('PERSON'), identity_);
END Check_Exist;


@UncheckedAccess
PROCEDURE Exist (
   identity_  IN VARCHAR2 )
IS
BEGIN
   Party_Type_Generic_API.Exist(Party_Type_API.Decode('PERSON'), identity_);
END Exist;


@UncheckedAccess
FUNCTION Get_Association_No (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Association_No(Party_Type_API.Decode('PERSON'), identity_);
END Get_Association_No;


@UncheckedAccess
FUNCTION Get_Country (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Country(Party_Type_API.Decode('PERSON'), identity_);
END Get_Country;


@UncheckedAccess
FUNCTION Get_Creation_Date (
   identity_  IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Creation_Date(Party_Type_API.Decode('PERSON'), identity_);
END Get_Creation_Date;


@UncheckedAccess
FUNCTION Get_Default_Address (
   identity_          IN VARCHAR2,
   address_type_code_ IN VARCHAR2,
   curr_date_         IN DATE DEFAULT SYSDATE ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Default_Address(Party_Type_API.Decode('PERSON'), identity_, address_type_code_, curr_date_);
END Get_Default_Address;


@UncheckedAccess
FUNCTION Get_Default_Language (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Default_Language(Party_Type_API.Decode('PERSON'), identity_);
END Get_Default_Language;


@UncheckedAccess
FUNCTION Get_Identity (
   party_      IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Identity(party_, Party_Type_API.Decode('PERSON'));
END Get_Identity;


@UncheckedAccess
FUNCTION Get_Name (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Name(Party_Type_API.Decode('PERSON'), identity_);
END Get_Name;


@UncheckedAccess
FUNCTION Get_Party (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Party(Party_Type_API.Decode('PERSON'), identity_);
END Get_Party;


@UncheckedAccess
FUNCTION Get_Sup_Party (
   identity_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Get_Sup_Party(Party_Type_API.Decode('PERSON'), identity_);
END Get_Sup_Party;


@UncheckedAccess
FUNCTION Is_Protected (
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Is_Protected(Party_Type_API.Decode('PERSON'), identity_);
END Is_Protected;


@UncheckedAccess
FUNCTION Is_User_Auth (
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Party_Type_Generic_API.Is_User_Auth(Party_Type_API.Decode('PERSON'), identity_);
END Is_User_Auth;


PROCEDURE Modify_Name (
   identity_   IN VARCHAR2,
   name_       IN VARCHAR2 )
IS
BEGIN
   Party_Type_Generic_API.Modify_Name(Party_Type_API.Decode('PERSON'), identity_, name_);
END Modify_Name;


PROCEDURE New (
   identity_         IN VARCHAR2,
   name_             IN VARCHAR2,
   association_no_   IN VARCHAR2 DEFAULT NULL,
   dummy_            IN VARCHAR2 DEFAULT NULL,
   country_          IN VARCHAR2 DEFAULT NULL,
   default_language_ IN VARCHAR2 DEFAULT NULL,
   protected_        IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Party_Type_Generic_API.New(Party_Type_API.Decode('PERSON'), identity_, name_, association_no_, dummy_, country_, default_language_, protected_);
END New;


PROCEDURE Remove (
   identity_   IN VARCHAR2 )
IS
BEGIN
   Party_Type_Generic_API.Remove(Party_Type_API.Decode('PERSON'), identity_);
END Remove;


PROCEDURE Set_Protected (
   identity_   IN VARCHAR2,
   protect_    IN VARCHAR2 )
IS
BEGIN
   Party_Type_Generic_API.Set_Protected(Party_Type_API.Decode('PERSON'), identity_, protect_);
END Set_Protected;



