-----------------------------------------------------------------------------
--
--  Logical unit: PartyId
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981009  Camk    Created.
--  981015  Camk    Public method New() removed
--  990416  Camk    New templat
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE New_Party___ (
   party_ IN OUT VARCHAR2 )
IS
BEGIN
   party_ := 1;
   INSERT 
      INTO party_id_tab (
         domain_id,
         next_party,
         rowversion)
      VALUES (
         'DEFAULT',
         party_,
         1);
END New_Party___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Next_Party (
   domain_id_ IN     VARCHAR2,
   party_     IN OUT VARCHAR2 )
IS
   -- Domain_id is not used
   dummy_ party_id_tab%ROWTYPE;
   CURSOR get_attr IS
      SELECT next_party
      FROM   party_id_tab;
BEGIN
   dummy_ := Lock_By_Keys___(domain_id_);
   OPEN get_attr;
   FETCH get_attr INTO party_;
   IF (get_attr%NOTFOUND) THEN
     New_Party___(party_);
     CLOSE get_attr;
   ELSE
     party_ := party_ + 1;
     UPDATE party_id_tab
     SET    next_party = party_,
            rowversion = rowversion+1
     WHERE  domain_id = domain_id_;
     CLOSE get_attr;
   END IF;
END Get_Next_Party;



