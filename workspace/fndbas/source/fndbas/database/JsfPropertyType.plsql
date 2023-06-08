-----------------------------------------------------------------------------
--
--  Logical unit: JsfPropertyType
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date         Sign    History
--  ----------   ------  --------------------------------------------------------
--  2019-09-10   madrse  PACZDATA-1340: Moving properties files to database side
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Enum_List IS VARRAY(20) OF VARCHAR2(100);

BOOLEAN_ENUM_LIST      CONSTANT Enum_List := Enum_List('true', 'false');
LOG_LEVEL_ENUM_LIST    CONSTANT Enum_List := Enum_List('error', 'warning', 'info', 'trace', 'debug');
HANDLER_TYPE_ENUM_LIST CONSTANT Enum_List := Enum_List('console', 'textfile', 'xmlfile');
CATEGORIES_ENUM_LIST   CONSTANT Enum_List := Enum_List('database', 'application', 'framework', 'gateway', 'callsequence', 'request', 'response', 'security', 'integration', 'batchprocessor', 'timings', 'classdebug');

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

--
-- Check if value exists on Enum_List
--
FUNCTION Exists___ (
   list_  IN Enum_List,
   value_ IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
   FOR i IN 1 .. list_.COUNT LOOP
      IF value_ = list_(i) THEN
         RETURN TRUE;
      END IF;
   END LOOP;
   RETURN FALSE;
END Exists___;


--
-- Parse comma separated string to Enum_List
--
PROCEDURE Parse_Enum_List___ (
   list_ IN OUT Enum_List,
   text_ IN     VARCHAR2)
IS
   len_  INTEGER := length(text_);
   p1_   INTEGER := 1;
   p2_   INTEGER;
   name_  VARCHAR2(4000);
BEGIN
   WHILE p1_ <= len_ LOOP
      p2_ := instr(text_, ',', p1_);
      IF p2_ = 0 THEN
         p2_ := len_ + 1;
      END IF;
      name_ := substr(text_, p1_, p2_ - p1_);
      list_.EXTEND;
      list_(list_.COUNT) := name_;
      p1_ := p2_ + 1;
   END LOOP;
END Parse_Enum_List___;


PROCEDURE Validate_Integer___ (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2)
IS
   number_ NUMBER;
BEGIN
   number_ := to_number(value_);
   IF  trunc(number_) <> number_ THEN
      Error_SYS.Appl_General(lu_name_, 'INTEGER: Property [:P1] value [:P2] must be an integer', name_, value_);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'NUMBER: Property [:P1] value [:P2] must be a number', name_, value_);
END Validate_Integer___;


PROCEDURE Validate_Limit___ (
   name_  IN VARCHAR2,
   value_ IN VARCHAR2)
IS
   last_   VARCHAR2(1)    := substr(value_, length(value_));
   numval_ VARCHAR2(4000);
   number_ NUMBER;
BEGIN
   IF lower(last_) IN ('k', 'm', 'g') THEN
      numval_ := substr(value_, 1, length(value_) - 1);
   ELSE
      numval_ := value_;
   END IF;
   number_ := to_number(numval_);
   IF trunc(number_) <> number_ THEN
      RAISE value_error;
   END IF;
   IF number_ <= 0 THEN
      RAISE value_error;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Appl_General(lu_name_, 'LIMIT: Property [:P1] value [:P2] must be a positive integer with optional suffix "k", "m", or "g"', name_, value_);
END Validate_Limit___;


PROCEDURE Validate_Enum___ (
   name_  IN VARCHAR2,
   type_  IN VARCHAR2,
   value_ IN VARCHAR2,
   list_  IN Enum_List) IS
BEGIN
   IF NOT Exists___(list_, lower(value_)) THEN
      Error_SYS.Appl_General(lu_name_, 'ENUM: Invalid value [:P1] for enumeration property [:P2] of type [:P3]', value_, name_, type_);
   END IF;
END Validate_Enum___;


PROCEDURE Validate_Enum_List___ (
   name_  IN VARCHAR2,
   type_  IN VARCHAR2,
   value_ IN VARCHAR2,
   list_  IN Enum_List)
IS
   values_ Enum_List := Enum_List();
BEGIN
   Parse_Enum_List___(values_, value_);
   FOR i IN 1 .. values_.COUNT LOOP
      IF NOT Exists___(list_, lower(trim(values_(i)))) THEN
         Error_SYS.Appl_General(lu_name_, 'ENUMLIST: Invalid item [:P1] in value for enumeration list property [:P2] of type [:P3]', values_(i), name_, type_);
      END IF;
   END LOOP;
END Validate_Enum_List___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Property_Value (
   property_name_  IN VARCHAR2,
   property_type_  IN VARCHAR2,
   property_value_ IN VARCHAR2) IS
BEGIN
   IF property_value_ IS NULL THEN
      RETURN;
   END IF;
   CASE property_type_
      WHEN DB_STRING       THEN NULL;
      WHEN DB_INTEGER      THEN Validate_Integer___(property_name_, property_value_);
      WHEN DB_LIMIT        THEN Validate_Limit___  (property_name_, property_value_);
      WHEN DB_BOOLEAN      THEN Validate_Enum___   (property_name_, DB_BOOLEAN,      property_value_, BOOLEAN_ENUM_LIST);
      WHEN DB_LOG_LEVEL    THEN Validate_Enum___   (property_name_, DB_LOG_LEVEL,    property_value_, LOG_LEVEL_ENUM_LIST);
      WHEN DB_HANDLER_TYPE THEN Validate_Enum___   (property_name_, DB_HANDLER_TYPE, property_value_, HANDLER_TYPE_ENUM_LIST);
      WHEN DB_CATEGORIES   THEN
         DECLARE
            value_ VARCHAR2(4000) := property_value_;
         BEGIN
            IF substr(value_, 1, 1) = '!' THEN
               value_ := substr(value_, 2);
            END IF;
            Validate_Enum_List___(property_name_, DB_CATEGORIES, value_, CATEGORIES_ENUM_LIST);
         END;
   END CASE;
END Validate_Property_Value;

-------------------- LU ; NEW METHODS -------------------------------------
