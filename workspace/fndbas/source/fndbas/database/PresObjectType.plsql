-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectType
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist_Db (
   type_db_ IN VARCHAR2 )
IS
BEGIN
   Exist(Decode(type_db_));
END Exist_Db;

@UncheckedAccess
PROCEDURE Enumerate (
   type_list_ OUT VARCHAR2 )
IS
   list_ VARCHAR2(32000);
   CURSOR get_desc IS
      SELECT description
      FROM   PRES_OBJECT_TYPE_TAB;
BEGIN
   FOR rec IN get_desc LOOP
      list_ := list_||rec.description||Client_SYS.field_separator_;
   END LOOP;
   type_list_ := list_;
END Enumerate;



@UncheckedAccess
FUNCTION Encode (
   type_description_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   type_ VARCHAR2(50);
   CURSOR get_type IS
      SELECT type
      FROM   PRES_OBJECT_TYPE_TAB
      WHERE  description = type_description_;
BEGIN
   OPEN  get_type;
   FETCH get_type INTO type_;
   CLOSE get_type;
   RETURN(type_);
END Encode;



@UncheckedAccess
FUNCTION Decode (
   type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ VARCHAR2(200);
   CURSOR get_desc IS
      SELECT description
      FROM   PRES_OBJECT_TYPE_TAB
      WHERE  type = type_;
BEGIN
   OPEN  get_desc;
   FETCH get_desc INTO description_;
   CLOSE get_desc;
   RETURN(description_);
END Decode;


