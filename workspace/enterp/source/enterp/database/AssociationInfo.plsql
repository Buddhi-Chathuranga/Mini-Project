-----------------------------------------------------------------------------
--
--  Logical unit: AssociationInfo
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981204  Camk    Created
--  990311  Camk    Allow to give the same association number to
--                  business partners of same type.
--  990830  Camk    Substr_b instead of substr.
--  990915  BmEk    Modified Check_Association_No
--  001221  BmEk    Bug #18823. Added idenity in view Association_Info. Added 
--                  Check_Ass_No_Company to make check of association no work 
--                  togehter with the Replication concept. Removed unnecessary 
--                  cursor (get_substring) from Association_No_Exist and 
--                  Check_Association_No. Also removed remarked code
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Association_No_Exist (
   association_no_    IN VARCHAR2,
   business_partner_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   party_type_  VARCHAR2(20);
   values_      VARCHAR2(1000);
   substring_   VARCHAR2(10);
   CURSOR get_type IS
      SELECT party_type
      FROM   association_info
      WHERE  association_no = association_no_;
BEGIN
   OPEN get_type;
   FETCH get_type INTO party_type_;
   IF (get_type%NOTFOUND) THEN
      CLOSE get_type;
      RETURN 'FALSE';
   END IF;
   CLOSE get_type;
   IF (party_type_ = 'CUSTOMS') THEN
      substring_ := 'CUSTOMS';
   ELSE
      substring_ := SUBSTR(party_type_, 0, 4);
   END IF;
   values_ := Object_Property_API.Get_Value('PartyType', business_partner_, 'GROUPS');
   IF (INSTR(values_, substring_) <> 0) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Association_No_Exist;


PROCEDURE Check_Association_No (
   association_no_    IN VARCHAR2,
   business_partner_  IN VARCHAR2 )
IS
   party_type_  VARCHAR2(20);
   values_      VARCHAR2(1000);
   substring_   VARCHAR2(10);
   CURSOR get_type IS
      SELECT party_type
      FROM   association_info
      WHERE  association_no = association_no_;
BEGIN
   OPEN get_type;
   FETCH get_type INTO party_type_;
   IF (get_type%NOTFOUND) THEN
      CLOSE get_type;
   ELSE
      CLOSE get_type;
      IF (party_type_ = 'CUSTOMS') THEN
         substring_ := 'CUSTOMS';
      ELSE
         substring_ := SUBSTR(party_type_, 0, 4);
      END IF;
      values_ := Object_Property_API.Get_Value('PartyType', business_partner_, 'GROUPS');
      IF ((INSTR(values_, substring_) IS NULL ) OR (INSTR(values_, substring_) = 0 )) THEN
         Error_SYS.Record_Exist(lu_name_, 'ALREADYEXIST: Association No already exist');
      END IF;
   END IF;
END Check_Association_No;


--This is to be used by Aurena
PROCEDURE Warn_Association_No (
   association_no_    IN VARCHAR2,
   party_type_id_     IN VARCHAR2,
   business_partner_  IN VARCHAR2 )
IS
   party_type_  VARCHAR2(20);
   values_      VARCHAR2(1000);
   substring_   VARCHAR2(10);
   CURSOR get_type IS
      SELECT party_type
      FROM   association_info
      WHERE  association_no = association_no_;
BEGIN
   OPEN get_type;
   FETCH get_type INTO party_type_;
   IF (get_type%NOTFOUND) THEN
      CLOSE get_type;
      RETURN;
   END IF;
   CLOSE get_type;
   IF (party_type_ = 'CUSTOMS') THEN
      substring_ := 'CUSTOMS';
   ELSE
      substring_ := SUBSTR(party_type_, 0, 4);
   END IF;
   values_ := Object_Property_API.Get_Value('PartyType', business_partner_, 'GROUPS');
   IF (INSTR(values_, substring_) <> 0) THEN
      Client_SYS.Add_Warning(lu_name_, 'WARNINGASSNO: Another business partner with the association number :P1 is already registered. Do you want to use the same Association No for :P2?', association_no_, party_type_id_);
   END IF;
END Warn_Association_No;


PROCEDURE Check_Ass_No_Company (
   association_no_        IN VARCHAR2,
   business_partner_      IN VARCHAR2,
   business_partner_id_   IN VARCHAR2 )
IS
   identity_    VARCHAR2(200);
   party_type_  VARCHAR2(20);
   values_      VARCHAR2(1000);
   substring_   VARCHAR2(10);
   CURSOR get_type IS
      SELECT party_type, identity
      FROM   association_info
      WHERE  association_no = association_no_;
BEGIN
   OPEN get_type;
   FETCH get_type INTO party_type_, identity_;
   IF (get_type%NOTFOUND) THEN
      CLOSE get_type;
   ELSE
      CLOSE get_type;     
      IF (party_type_ = 'CUSTOMS') THEN
         substring_ := 'CUSTOMS';
      ELSE
         substring_ := SUBSTR(party_type_, 0, 4);
      END IF;
      values_ := Object_Property_API.Get_Value('PartyType', business_partner_, 'GROUPS');
      IF ((INSTR(values_, substring_) IS NULL ) OR (INSTR(values_, substring_) = 0 )) THEN
         -- If it is myself what is found, no error message is given. This to make the Replication
         -- concept work.
         IF NOT ((business_partner_id_ = identity_) AND (business_partner_ = party_type_)) THEN
            Error_SYS.Record_Exist(lu_name_, 'ALREADYEXIST: Association No already exist');
         END IF;
      END IF;
   END IF;
END Check_Ass_No_Company;


