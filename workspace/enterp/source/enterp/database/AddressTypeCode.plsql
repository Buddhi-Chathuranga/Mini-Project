-----------------------------------------------------------------------------
--
--  Logical unit: AddressTypeCode
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180524  thjilk  FIUXXW2-123 Added method Get_Address_Types_For_Party_Type
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Enumerate_Type (
   client_values_ OUT VARCHAR2,
   db_party_type_ IN  VARCHAR2 )
IS
   addr_types_          VARCHAR2(200);
   from_                NUMBER;
   to_                  NUMBER;
   db_type_             VARCHAR2(20);
   client_types_        VARCHAR2(2000);
BEGIN
   addr_types_ := Object_Property_API.Get_Value('PartyType', db_party_type_, 'VALID_ADDR');
   IF (addr_types_ IS NULL) THEN
      enumerate(client_values_);
   ELSE
      client_types_ := addr_types_;
      from_ := 1;
      to_ := NVL(INSTR(addr_types_||',', ','), 0);
      WHILE to_ > 0 LOOP
         db_type_ := SUBSTR(addr_types_||',', from_, to_-from_);
         client_types_ := REPLACE(client_types_, db_type_, Address_Type_Code_API.Decode(db_type_) );
         from_ := to_ + 1;
         to_ := NVL(INSTR(addr_types_||',', ',', from_), 0);
      END LOOP;
      client_values_ := REPLACE(client_types_, ',', Client_SYS.field_separator_);
   END IF;
END Enumerate_Type;


-- This method is to be used by Aurena
@UncheckedAccess
FUNCTION Get_Addr_Typs_For_Party_Type (
   party_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_values_ VARCHAR2(2000);
   db_list_   VARCHAR2(2000);
   exists_    BOOLEAN;
BEGIN
   db_values_ := Object_Property_API.Get_Value('PartyType', party_type_, 'VALID_ADDR');
   SELECT REPLACE(db_values_, ',', Client_SYS.text_separator_) INTO db_list_ FROM dual;
   db_list_   := CONCAT(db_list_, '^');
   exists_    := Address_Type_Code_API.Exists_List_Db(db_list_);
   IF (exists_) THEN
      RETURN db_values_;
   ELSE
      RETURN Get_Valid_Addr_Types(db_values_);
   END IF;
END Get_Addr_Typs_For_Party_Type;


FUNCTION Get_Valid_Addr_Types (
   db_list_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   valid_list_    VARCHAR2(2000);
   from_          NUMBER;
   to_            NUMBER;
   db_type_       VARCHAR2(20);
   exists_        BOOLEAN;
BEGIN
   from_ := 1;
   to_   := NVL(INSTR(db_list_||',', ','), 0);
   WHILE to_ > 0 LOOP
      db_type_ := SUBSTR(db_list_||',', from_, to_-from_);
      exists_  := Address_Type_Code_API.Exists_Db(db_type_);
      IF (exists_) THEN
         IF (valid_list_ IS NULL) THEN
            valid_list_ := CONCAT(db_type_, ',');
         ELSE
            valid_list_ := CONCAT(valid_list_, CONCAT(db_type_, ','));
         END IF;
      END IF;
      from_ := to_ + 1;
      to_   := NVL(INSTR(db_list_||',', ',', from_), 0);
   END LOOP;	
	RETURN RTRIM(valid_list_, ',');
END Get_Valid_Addr_Types;

   