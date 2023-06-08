-----------------------------------------------------------------------------
--
--  Logical unit: PartyTypeAddress
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  090428  Chhulk  Create
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
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   party_type_address
      WHERE  party_type = party_type_
      AND    identity = identity_
      AND    address_id = address_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN TRUE;
   END IF;
   CLOSE exist_control;
   RETURN FALSE;
END Check_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

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


