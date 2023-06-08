-----------------------------------------------------------------------------
--
--  Logical unit: PartyTypeIdentityAccess
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981013  Camk    Created
--  981109  Camk    Public methods get_country and get_default_language added
--  981126  Camk    New table names. Domain_id is hardcode (DEFAULT')
--  981203  Camk    View Party_Type_Identity_Access adde
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist___ (
   domain_id_  IN VARCHAR2,
   identity_   IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   party_type_identity_access_bas
      WHERE  domain_id = domain_id_
      AND    identity = identity_
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

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   domain_id_  IN VARCHAR2,
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(domain_id_, identity_, party_type_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Name (
   domain_id_  IN VARCHAR2,
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_ party_type_identity_access_bas.name%TYPE;
   CURSOR get_attr IS
      SELECT name
      FROM   party_type_identity_access_bas
      WHERE  domain_id = domain_id_
      AND    identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Name;


@UncheckedAccess
FUNCTION Get_Party (
   domain_id_  IN VARCHAR2,
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_ party_type_identity_access_bas.party%TYPE;
   CURSOR get_attr IS
      SELECT party
      FROM   party_type_identity_access_bas
      WHERE  domain_id = domain_id_
      AND    identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Party;


@UncheckedAccess
FUNCTION Get_Country (
   domain_id_  IN VARCHAR2,
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_ party_type_identity_access_bas.country%TYPE;
   CURSOR get_attr IS
      SELECT country_DB
      FROM   party_type_identity_access_bas
      WHERE  domain_id = domain_id_
      AND    identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN SUBSTR(Iso_Country_API.Decode(temp_),1,200);
END Get_Country;


@UncheckedAccess
FUNCTION Get_Default_Language (
   domain_id_  IN VARCHAR2,
   party_type_ IN VARCHAR2,
   identity_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_ party_type_identity_access_bas.default_language%TYPE;
   CURSOR get_attr IS
      SELECT default_language_db
      FROM   party_type_identity_access_bas
      WHERE  domain_id = domain_id_
      AND    identity = identity_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN SUBSTR(Iso_Language_API.Decode(temp_),1,200);
END Get_Default_Language;



