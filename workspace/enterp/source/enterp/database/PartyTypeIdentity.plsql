-----------------------------------------------------------------------------
--
--  Logical unit: PartyTypeIdentity
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981013  Camk    Created
--  981126  Camk    New table names. Domain_id is hardcode (DEFAULT')
--  981204  Camk    The method Get_Assoc_identity is modified.
--  090320  MOHRLK  Bug 79377, Changed the column comment ref of the
--  090320          "user_id" in PARTY_TYPE_IDENTITY view to FndUse
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Exist___ (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   party_type_identity
      WHERE  domain_id = domain_id_
      AND    party = party_
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
   party_      IN VARCHAR2,
   party_type_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(domain_id_, party_, party_type_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;


@UncheckedAccess
FUNCTION Get_Identity (
   domain_id_  IN VARCHAR2,
   party_      IN VARCHAR2,
   party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_value_ VARCHAR2(20) := Party_Type_API.Encode(party_type_);
   temp_ party_type_identity.identity%TYPE;
   CURSOR get_attr IS
      SELECT identity
      FROM   party_type_identity
      WHERE  domain_id = domain_id_
      AND    party = party_
      AND    party_type_db = db_value_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Identity;




