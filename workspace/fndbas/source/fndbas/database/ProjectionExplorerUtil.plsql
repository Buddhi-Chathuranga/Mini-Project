-----------------------------------------------------------------------------
--
--  Logical unit: ProjectionExplorerUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210304  JanWse  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-- TRANSLATIONS.PROJECTION declarations - start
TYPE attribute_record IS RECORD (
   attribute_path VARCHAR2(1000),
   is_enumeration VARCHAR2(20)
);

TYPE attribute_enum_record IS RECORD (
   attribute_path       VARCHAR2(1000),
   db_value             VARCHAR2(1000),
   client_value         VARCHAR2(1000)
);

TYPE enumeration_record IS RECORD (
   db_value       VARCHAR2(1000),
   client_value   VARCHAR2(1000)
);

TYPE translation_record IS RECORD (
   translation  VARCHAR2(1000)
);

TYPE attribute_table IS TABLE OF attribute_record;
TYPE attribute_enum_table IS TABLE OF attribute_enum_record;
TYPE enumeration_table IS TABLE OF enumeration_record;
TYPE translation_table IS TABLE OF translation_record;
-- TRANSLATIONS.PROJECTION declarations - end

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------


-------------------- TRANSLATIONS.PROJECTION IMPLEMENTATION METHODS ----------

FUNCTION Get_Attribute_Translation___ (
   attribute_path_         IN VARCHAR2,
   lang_code_              IN VARCHAR2,
   use_default_language_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF use_default_language_ = Fnd_Boolean_API.DB_TRUE THEN
      FOR rec IN
      (
         SELECT nvl(t.text, a.prog_text) text
         FROM   language_attribute a,
                language_context c,
                language_translation t
         WHERE  a.context_id = c.context_id
           AND  a.attribute_id = t.attribute_id(+)
           AND  c.path = attribute_path_
           AND  lang_code_ = t.lang_code(+)   
      )
      LOOP
         RETURN rec.text;
      END LOOP;
   ELSE
      FOR rec IN
      (
         SELECT t.text
         FROM   language_attribute a,
                language_context c,
                language_translation t
         WHERE  a.context_id = c.context_id
           AND  a.attribute_id = t.attribute_id(+)
           AND  c.path = attribute_path_
           AND  lang_code_ = t.lang_code(+)   
      )
      LOOP
         RETURN rec.text;
      END LOOP;
   END IF;
   RETURN NULL;
END Get_Attribute_Translation___;

FUNCTION Get_Enumeration_Type___ (
   attribute_path_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_name_       VARCHAR2(1000) := regexp_substr(attribute_path_, '[^.]+'); -- Take text before first dot (.)
   view_name_     VARCHAR2(1000) := UPPER(Utility_SYS.Pascal_To_Underscore(lu_name_));
   column_name_   VARCHAR2(1000) := regexp_substr(attribute_path_, '[^.]+$'); -- Take text after last dot (.)
   
BEGIN
   FOR rec IN 
   (
      SELECT * 
      FROM   dictionary_sys_view_column_tab 
      WHERE  lu_name = lu_name_ 
        AND  view_name = view_name_ 
        AND  column_name = column_name_ 
        AND  (column_reference IS NOT NULL OR enumeration IS NOT NULL OR lookup IS NOT NULL)
   ) 
   LOOP
      IF rec.column_reference IS NOT NULL THEN
         IF instr(rec.column_reference, '(') = 0 THEN
            RETURN 'reference=' || rec.column_reference;
         END IF;
      ELSIF rec.enumeration IS NOT NULL THEN
         RETURN 'enumeration=' || rec.enumeration;
      ELSIF rec.lookup IS NOT NULL THEN
         RETURN 'lookup=' || rec.lookup;
      END IF;
      RETURN NULL;
   END LOOP;

   RETURN NULL;
END Get_Enumeration_Type___;

FUNCTION Get_Enum_Translation___ (
   attribute_path_   IN VARCHAR2,
   lang_code_        IN VARCHAR2 ) RETURN enumeration_table
IS
   enumeration_type_    VARCHAR2(1000) := Get_Enumeration_Type___(attribute_path_);
   enumeration_         VARCHAR2(1000) := Wash___(regexp_substr(enumeration_type_, '[^=]+$')); -- Take text after last equal (=) and wash it from all except name
   enumeration_table_   enumeration_table := enumeration_table();
   
   PROCEDURE Get_Enumeration_Translation
   IS
      db_values_     VARCHAR2(32000) := Domain_SYS.Get_Db_Values(enumeration_);
      client_values_ VARCHAR2(32000) := Domain_SYS.Get_Translated_Values(enumeration_, lang_code_);
      num_           NUMBER := 0;
   BEGIN
      FOR rec IN (SELECT regexp_substr(db_values_ ,'[^^]+', 1, LEVEL) AS db_value FROM dual CONNECT BY regexp_substr(db_values_, '[^^]+', 1, LEVEL) IS NOT NULL) LOOP
         num_ := num_ + 1;
         enumeration_table_.extend;
         enumeration_table_(num_).db_value := rec.db_value;
         enumeration_table_(num_).client_value := regexp_substr(client_values_ ,'[^^]+', 1, num_);
      END LOOP;
   END Get_Enumeration_Translation;

   PROCEDURE Get_Lookup_Translation
   IS
      lu_name_ VARCHAR2(1000) := enumeration_;
      path_    VARCHAR2(1000) := lu_name_ || '_%.%';
      num_     NUMBER := 0;
   BEGIN
      FOR rec IN (SELECT * FROM language_sys_tab WHERE type = 'Basic Data' AND PATH LIKE path_ AND lang_code = lang_code_) LOOP
         num_ := num_ + 1;
         enumeration_table_.extend;
         enumeration_table_(num_).db_value := regexp_substr(rec.path, '[^.]+$'); -- Take text after last dot (.)
         enumeration_table_(num_).client_value := rec.text;
      END LOOP;
   END Get_Lookup_Translation;

BEGIN
   IF nvl(instr(enumeration_type_, 'enumeration'), 0) = 1 THEN
      Get_Enumeration_Translation;
   ELSIF nvl(instr(enumeration_type_, 'lookup'), 0) = 1 THEN
      Get_Lookup_Translation;
   ELSIF nvl(instr(enumeration_type_, 'reference'), 0) = 1 THEN
      Get_Lookup_Translation;
   END IF;
   RETURN enumeration_table_;
END Get_Enum_Translation___;

FUNCTION Is_Lu_Translatable___ (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   FOR rec IN (SELECT * FROM language_sys_imp_tab WHERE lu = lu_name_) LOOP
      RETURN rec.use_translation;
   END LOOP;
   RETURN Fnd_Boolean_API.DB_FALSE;
END Is_Lu_Translatable___;

FUNCTION Wash___ (
   reference_in_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   reference_  VARCHAR2(1000) := replace(reference_in_, 'reference=', NULL);
BEGIN
   reference_ := regexp_replace(reference_, '\((.*?)\)', NULL); -- Remove everything between ( and ) including ( and )
   RETURN regexp_substr(reference_, '[^/]+'); -- Take text before first slash (/)
END Wash___;

-------------------- TRANSLATIONS.PROJECTION PRIVATE METHODS -----------------

FUNCTION Is_Enumeration__ (
   attribute_path_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   enumeration_type_ VARCHAR2(1000) := Get_Enumeration_Type___(attribute_path_);
   enumeration_      VARCHAR2(1000) := Wash___(enumeration_type_);
BEGIN
   IF nvl(instr(enumeration_type_, 'enumeration'), 0) = 1 THEN
      RETURN Fnd_Boolean_API.DB_TRUE;
   ELSIF nvl(instr(enumeration_type_, 'lookup'), 0) = 1 THEN
      IF Is_Lu_Translatable___(enumeration_) = Fnd_Boolean_API.DB_TRUE THEN
         RETURN Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF nvl(instr(enumeration_type_, 'reference'), 0) = 1 THEN
      IF Is_Lu_Translatable___(enumeration_) = Fnd_Boolean_API.DB_TRUE THEN
         RETURN Fnd_Boolean_API.DB_TRUE;
      END IF;
   END IF;
   RETURN Fnd_Boolean_API.DB_FALSE;
END Is_Enumeration__;

-------------------- TRANSLATIONS.PROJECTION PUBLIC METHODS ------------------

FUNCTION Get_Enum_Translation (
   attribute_path_   IN VARCHAR2,
   lang_code_        IN VARCHAR2  DEFAULT 'PROG' ) RETURN enumeration_table PIPELINED
IS
   enumeration_table_   enumeration_table := Get_Enum_Translation___(attribute_path_, lang_code_);
BEGIN
   FOR rec IN (SELECT * FROM TABLE(enumeration_table_)) LOOP
      PIPE ROW (rec);
   END LOOP;
END Get_Enum_Translation;

FUNCTION Get_Attribute_Path (
   projection_name_  IN VARCHAR2,
   module_in_        IN VARCHAR2 DEFAULT NULL ) RETURN attribute_table PIPELINED
IS
   module_  language_context.module%TYPE := NVL(module_in_, '%');
BEGIN
   FOR rec IN
   (
      SELECT c.lu_name || '.' || UPPER(Utility_SYS.Pascal_To_Underscore(c.lu_name)) || '.' || c.column_name AS attribute_path, 
             Is_Enumeration__(c.lu_name || '.' || UPPER(Utility_SYS.Pascal_To_Underscore(c.lu_name)) || '.' || c.column_name) AS is_enumeration
      FROM   fnd_projection_tab p, fnd_proj_entity_tab e, dictionary_sys_tab l, dictionary_sys_view_column_tab c
      WHERE  p.projection_name = e.projection_name
        AND  e.entity_name = c.lu_name
        AND  c.lu_name = l.lu_name
        AND  c.view_name = UPPER(Utility_SYS.Pascal_To_Underscore(c.lu_name))
        AND  p.projection_name = projection_name_
        AND  l.module LIKE module_
        AND  c.column_name NOT IN ('OBJID','OBJKEY','OBJVERSION','OBJEVENTS','OBJSTATE')
   ) 
   LOOP
      PIPE ROW (rec);
   END LOOP;
END Get_Attribute_Path;

FUNCTION Get_Attribute_Enum_Path (
   projection_name_  IN VARCHAR2,
   module_in_        IN VARCHAR2 DEFAULT NULL,
   lang_code_        IN VARCHAR2 DEFAULT 'PROG' ) RETURN attribute_enum_table PIPELINED
IS
   module_     language_context.module%TYPE := NVL(module_in_, '%');
   enum_rec_   attribute_enum_record;
BEGIN
   FOR rec IN (SELECT * FROM TABLE(Get_Attribute_Path(projection_name_, module_))) LOOP
      IF rec.is_enumeration = Fnd_Boolean_API.DB_TRUE THEN
         FOR enum IN (SELECT * FROM TABLE(Get_Enum_Translation(rec.attribute_path, lang_code_))) LOOP
            enum_rec_.attribute_path  := rec.attribute_path;
            enum_rec_.db_value  := enum.db_value;
            enum_rec_.client_value  := enum.client_value;
            PIPE ROW (enum_rec_);
         END LOOP;
      END IF;
   END LOOP;
END Get_Attribute_Enum_Path;

FUNCTION Get_Attribute_Translation (
   attribute_path_         IN VARCHAR2,
   lang_code_              IN VARCHAR2 DEFAULT 'PROG',
   use_default_language_   IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE ) RETURN translation_table PIPELINED
IS
   translation_record_  translation_record; 
BEGIN
   translation_record_.translation := Get_Attribute_Translation___(attribute_path_, lang_code_, use_default_language_);
   PIPE ROW(translation_record_);
END Get_Attribute_Translation;
