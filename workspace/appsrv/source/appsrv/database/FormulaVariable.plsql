-----------------------------------------------------------------------------
--
--  Logical unit: FormulaVariable
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  040614  JaJalk Implemented the method Enumerate so that the LU can acts an IID as well.
--  040603  HeWelk Created
--  -------------------------- APPS 9 ---------------------------------------
--  131120  paskno  Hooks: refactoring and splitting.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Enumerate
--   This method returns the values of variable_id's as the client value list.
--   So it retunes the DB value instead of the client value when compared to the other IID's.
--   Hence the Encode and Decode will act other way round.
@UncheckedAccess
PROCEDURE Enumerate (
   client_values_ OUT VARCHAR2 )
IS
   desc_list_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT variable_id
      FROM FORMULA_VARIABLE_TAB
      ORDER BY variable_id;
BEGIN

   FOR rec_ IN get_value LOOP
      desc_list_ := desc_list_ || rec_.variable_id  || Client_SYS.field_separator_;
   END LOOP;
   client_values_ := desc_list_;

END Enumerate;


-- Encode
--   Retuns the value of Variable_Id as the db value of the fake IID.
@UncheckedAccess
FUNCTION Encode (
   description_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   variable_id_  FORMULA_VARIABLE_TAB.variable_id%TYPE;
   CURSOR get_db_val IS
      SELECT variable_id
      FROM FORMULA_VARIABLE_TAB
      WHERE description = description_;
BEGIN
   OPEN get_db_val;
   FETCH get_db_val INTO variable_id_;
   IF (get_db_val%NOTFOUND) THEN
      variable_id_ := NULL;
   END IF;
   CLOSE get_db_val;
   RETURN variable_id_;

END Encode;


-- Decode
--   Retuns the description as the client value of the fake IID.
@UncheckedAccess
FUNCTION Decode (
   variable_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ FORMULA_VARIABLE_TAB.description%TYPE;
   CURSOR get_client_val IS
      SELECT description
      FROM FORMULA_VARIABLE_TAB
      WHERE variable_id = variable_id_;
BEGIN
   OPEN get_client_val;
   FETCH get_client_val INTO description_;
   IF (get_client_val%NOTFOUND) THEN
      description_ := NULL;
   END IF;
   CLOSE get_client_val;
   RETURN description_;

END Decode;



