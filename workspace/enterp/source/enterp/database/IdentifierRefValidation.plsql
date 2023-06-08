-----------------------------------------------------------------------------
--
--  Logical unit: IdentifierRefValidation
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Asciistr_Exist___ (
   identifier_ref_validation_ IN VARCHAR2,
   asciistr_value_            IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   identifier_ref_character_tab
      WHERE  identifier_ref_validation = identifier_ref_validation_
      AND    asciistr_value            = asciistr_value_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Asciistr_Exist___;
         
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Katakana (
   identifier_reference_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   name_            VARCHAR2(100);
   asciistr_value_  VARCHAR2(10);
BEGIN
   name_ := identifier_reference_;
   FOR chr_ IN 1 .. LENGTH(name_) LOOP
      asciistr_value_ := ASCIISTR(SUBSTR(name_, chr_, 1));
      IF NOT (Asciistr_Exist___ ('KATAKANA', asciistr_value_)) THEN
         RETURN 'FALSE';
      END IF;
   END LOOP;
   RETURN 'TRUE';
END Check_Katakana;


@UncheckedAccess
PROCEDURE Check_Identifier_Reference (
   identifier_reference_      IN VARCHAR2,
   identifier_ref_validation_ IN VARCHAR2 )
IS
   check_ok_                     VARCHAR2(5) := 'TRUE';
BEGIN
   IF (identifier_ref_validation_ = 'KATAKANA') THEN
      check_ok_ := Check_Katakana(identifier_reference_);
   END IF;
   IF (check_ok_ = 'FALSE') THEN
      Error_SYS.Appl_General(lu_name_, 'IDREFNOTVALID: Identifier Reference is not valid');
   END IF;
END Check_Identifier_Reference;


@UncheckedAccess
FUNCTION Check_Identifier_Ref (
   identifier_reference_      IN VARCHAR2,
   identifier_ref_validation_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   check_ok_    VARCHAR2(5) := 'TRUE';
BEGIN

   IF (identifier_ref_validation_ = 'KATAKANA') THEN
      check_ok_ := Check_Katakana(identifier_reference_);
   END IF;
   IF (check_ok_ = 'FALSE') THEN
      RETURN 'FALSE';
   ELSE
      RETURN 'TRUE';
   END IF;
END Check_Identifier_Ref;


