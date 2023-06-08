-----------------------------------------------------------------------------
--
--  Logical unit: Party
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981013  Camk    Created
--  981126  Camk    New table names. Domain_id is hardcode (DEFAULT)
--  981204  Camk    Client value added to the view.
--  990830  Camk    Substr_b instead of substr.
--  060726  CsAmlk  Persian Calendar Modifications.
--  070919  Thpelk  Merged LCS Bug 67417, Changed method Get_Default_Addres
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist___ (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   party
      WHERE  domain_id = domain_id_
      AND    party = party_;
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
FUNCTION Get_Sup_Party (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   assoc_no_ VARCHAR2(50);
   temp_     party.party%TYPE;
   CURSOR get_attr IS
      SELECT party
      FROM   party
      WHERE  domain_id = domain_id_
      AND    association_no = assoc_no_;
BEGIN
   assoc_no_ := Get_Association_No(domain_id_, party_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Sup_Party;


@UncheckedAccess
PROCEDURE Exist (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(domain_id_, party_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Association_No (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ party.association_no%TYPE;
   CURSOR get_attr IS
      SELECT association_no
      FROM   party
      WHERE  domain_id = domain_id_
      AND    party = party_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Association_No;


@UncheckedAccess
FUNCTION Get_Country (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ party.country%TYPE;
   CURSOR get_attr IS
      SELECT country
      FROM   party
      WHERE  domain_id = domain_id_
      AND    party = party_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Country;


@UncheckedAccess
FUNCTION Get_Creation_Date (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 ) RETURN DATE
IS
   temp_ party.creation_date%TYPE;
   CURSOR get_attr IS
      SELECT creation_date
      FROM   party
      WHERE  domain_id = domain_id_
      AND    party = party_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Creation_Date;


@UncheckedAccess
FUNCTION Get_Default_Language (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ party.default_language%TYPE;
   CURSOR get_attr IS
      SELECT default_language
      FROM   PARTY
      WHERE  domain_id = domain_id_
      AND    party = party_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Default_Language;


@UncheckedAccess
FUNCTION Get_Name (
   domain_id_ IN VARCHAR2,
   party_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ party.name%TYPE;
   CURSOR get_attr IS
      SELECT name
      FROM   party
      WHERE  domain_id = domain_id_
      AND    party = party_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Name;



