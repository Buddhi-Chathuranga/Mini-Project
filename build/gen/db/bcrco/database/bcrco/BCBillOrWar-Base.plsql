-----------------------------------------------------------------------------
--
--  Logical unit: BCBillOrWar
--  Component:    BCRCO
--
--  Template:     3.0
--  Built by:     IFS Developer Studio (unit-test)
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding model is saved.
-----------------------------------------------------------------------------

layer Base;

-------------------- PUBLIC DECLARATIONS ------------------------------------

DB_BILLABLE                    CONSTANT VARCHAR2(8) := 'BILLABLE';
DB_WARRANTY                    CONSTANT VARCHAR2(8) := 'WARRANTY';

-------------------- BASE METHODS -------------------------------------------

-- Exist
--   Checks if given client value exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   client_value_ IN VARCHAR2 )
IS
BEGIN
   Domain_SYS.Exist_(lu_name_, Domain_SYS.Get_Translated_Values(lu_name_), client_value_);
END Exist;


-- Exist_List
--   Checks if all items in given list of client values exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist_List (
   client_list_ IN VARCHAR2 )
IS
BEGIN
   Domain_SYS.Exist_List_(lu_name_, Domain_SYS.Get_Translated_Values(lu_name_), client_list_);
END Exist_List;


-- Exist_Db
--   Checks if given database value exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist_Db (
   db_value_ IN VARCHAR2 )
IS
BEGIN
   Domain_SYS.Exist_(lu_name_, Get_Db_Values___, db_value_);
END Exist_Db;


-- Exist_List_Db
--   Checks if all items in given list of database values exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist_List_Db (
   db_list_ IN VARCHAR2 )
IS
BEGIN
   Domain_SYS.Exist_List_Db_(lu_name_, Get_Db_Values___, db_list_);
END Exist_List_Db;


-- Exists
--   Checks if given client value exists and returns TRUE or FALSE.
@UncheckedAccess
FUNCTION Exists (
   client_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Domain_SYS.Exist_(lu_name_, Domain_SYS.Get_Translated_Values(lu_name_), client_value_);
END Exists;


-- Exists_List
--   Checks if all items in given list of client values exists and returns TRUE or FALSE.
@UncheckedAccess
FUNCTION Exists_List (
   client_list_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Domain_SYS.Exist_List_(lu_name_, Domain_SYS.Get_Translated_Values(lu_name_), client_list_);
END Exists_List;


-- Exists_Db
--   Checks if given database value exists and returns TRUE or FALSE.
@UncheckedAccess
FUNCTION Exists_Db (
   db_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Domain_SYS.Exist_(lu_name_, Get_Db_Values___, db_value_);
END Exists_Db;


-- Exists_List_Db
--   Checks if all items in given list of database values exists and returns TRUE or FALSE.
@UncheckedAccess
FUNCTION Exists_List_Db (
   db_list_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Domain_SYS.Exist_List_Db_(lu_name_, Get_Db_Values___, db_list_);
END Exists_List_Db;


-- Enumerate
--   Returns a list of all client values.
@UncheckedAccess
PROCEDURE Enumerate (
   client_values_ OUT VARCHAR2)
IS
BEGIN
   client_values_ := Domain_SYS.Enumerate_(Domain_SYS.Get_Translated_Values(lu_name_));
END Enumerate;


-- Enumerate_Db
--   Returns a list of all database values.
@UncheckedAccess
PROCEDURE Enumerate_Db (
   db_values_ OUT VARCHAR2)
IS
BEGIN
   db_values_ := Domain_SYS.Enumerate_(Get_Db_Values___);
END Enumerate_Db;

-- Enumerate_Client_And_Db
--   Returns a list of all client and database values.
@Final
@UncheckedAccess
PROCEDURE Enumerate_Client_And_Db (
   client_values_ OUT VARCHAR2,
   db_values_     OUT VARCHAR2)
IS
BEGIN
   Enumerate(client_values_);
   Enumerate_Db(db_values_);
END Enumerate_Client_And_Db;

-- Encode
--   Converts a client value to the corresponding database value.
@UncheckedAccess
FUNCTION Encode (
   client_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Domain_SYS.Encode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, client_value_);
END Encode;


-- Encode_List
--   Converts a list of client values to corresponding list of database values.
@UncheckedAccess
FUNCTION Encode_List (
   client_list_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Domain_SYS.Encode_List_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, client_list_);
END Encode_List;


-- Decode
--   Converts a database value to the corresponding client value.
@UncheckedAccess
FUNCTION Decode (
   db_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Domain_SYS.Decode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, db_value_);
END Decode;


-- Decode_List
--   Converts a list of database values to a corresponding list of client values.
@UncheckedAccess
FUNCTION Decode_List (
   db_list_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Domain_SYS.Decode_List_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, db_list_);
END Decode_List;


-- Get_Client_Value
--   Returns the client value based on its index in the full list.
@UncheckedAccess
FUNCTION Get_Client_Value (
   index_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Domain_SYS.Get_Client_Value_(Domain_SYS.Get_Translated_Values(lu_name_), index_));
END Get_Client_Value;


-- Get_Db_Value
--   Returns the database value based on its index in the full list.
@UncheckedAccess
FUNCTION Get_Db_Value (
   index_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Domain_SYS.Get_Db_Value_(Get_Db_Values___, index_));
END Get_Db_Value;


-- Get_Db_Values___
--   Returns the list of DB (stored in database) values.
@UncheckedAccess
FUNCTION Get_Db_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('BILLABLE^WARRANTY^');
END Get_Db_Values___;




-- Get_Client_Values___
--   Returns the list of client (in PROG language) values.
@UncheckedAccess
FUNCTION Get_Client_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Billable^Warranty^');
END Get_Client_Values___;


-- Get_Identifiers___
--   Returns the list of identifiers.
@UncheckedAccess
FUNCTION Get_Identifiers___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Billable^Warranty^');
END Get_Identifiers___;


-- Identifier_To_Db_Value
--   Converts a identifier to the corresponding database value.
@UncheckedAccess
FUNCTION Identifier_To_Db_Value (
   identifier_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Domain_SYS.Decode_(Get_Db_Values___, Get_Identifiers___, identifier_);
END Identifier_To_Db_Value;

-- Db_Value_To_Identifier
--   Converts a database value to the corresponding identifier.
@UncheckedAccess
FUNCTION Db_Value_To_Identifier (
   db_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Domain_SYS.Decode_(Get_Identifiers___, Get_Db_Values___, db_value_);
END Db_Value_To_Identifier;

-------------------- FOUNDATION1 METHODS ------------------------------------

-- Language_Refreshed
--   Framework method that updates translations to a new language.
@UncheckedAccess
PROCEDURE Language_Refreshed
IS
BEGIN
   Domain_SYS.Language_Refreshed(lu_name_, Get_Client_Values___, Get_Db_Values___, 'IID');
END Language_Refreshed;


-- Init
--   Framework method that initializes this package.
@UncheckedAccess
PROCEDURE Init
IS
BEGIN
   Domain_SYS.Load_IID(lu_name_, Get_Client_Values___, Get_Db_Values___);
END Init;
