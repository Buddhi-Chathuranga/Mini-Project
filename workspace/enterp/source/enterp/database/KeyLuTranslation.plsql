-----------------------------------------------------------------------------
--
--  Logical unit: KeyLuTranslation
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

PROCEDURE Refresh_Translation_Imp___(
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (language_code_ IS NULL) THEN
      -- Delete the language row if no translations exist for the language.
      DELETE FROM key_lu_translation_imp_tab a
         WHERE key_name = key_name_
         AND key_value = key_value_
         AND NOT EXISTS (SELECT language_code
                         FROM key_lu_translation_tab b
                         WHERE a.key_name = b.key_name
                         AND a.key_value = b.key_value
                         AND a.language_code = b.language_code);
      -- Insert all languages for the key_name and key_value with regards to if translations for the language exist
      INSERT 
         INTO key_lu_translation_imp_tab(
            key_name,
            key_value,
            language_code)
         SELECT
            key_name,
            key_value,
            language_code
         FROM key_lu_translation_tab a
         WHERE key_name = key_name_
         AND key_value = key_value_
         AND NOT EXISTS (SELECT 1
                         FROM key_lu_translation_imp_tab b
                         WHERE a.key_name = b.key_name
                         AND a.key_value = b.key_value
                         AND a.language_code = b.language_code)
         GROUP BY key_name, key_value, language_code;
   ELSE
      -- Delete the language row if no translations exist for the language.
      DELETE FROM key_lu_translation_imp_tab a
         WHERE key_name = key_name_
         AND key_value = key_value_
         AND language_code = language_code_
         AND NOT EXISTS (SELECT language_code
                         FROM key_lu_translation_tab b
                         WHERE a.key_name = b.key_name
                         AND a.key_value = b.key_value
                         AND a.language_code = b.language_code);
      -- Insert all languages for the key_name and key_value with regards to if translations for the language exist
      INSERT 
         INTO key_lu_translation_imp_tab(
            key_name,
            key_value,
            language_code)
         SELECT
            key_name,
            key_value,
            language_code
         FROM key_lu_translation_tab a
         WHERE key_name = key_name_
         AND key_value = key_value_
         AND language_code = language_code_
         AND NOT EXISTS (SELECT 1
                         FROM key_lu_translation_imp_tab b
                         WHERE a.key_name = b.key_name
                         AND a.key_value = b.key_value
                         AND a.language_code = b.language_code)
         GROUP BY key_name, key_value, language_code;
   END IF;
END Refresh_Translation_Imp___;


PROCEDURE Insert_Translation_Lng___(
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   language_code_ IN VARCHAR2)
IS
   dummy_      PLS_INTEGER;
   CURSOR exist_in_trans_tab IS
      SELECT 1
      FROM   key_lu_translation_tab
      WHERE  key_name = key_name_
      AND    key_value = key_value_
      AND    language_code = language_code_;
BEGIN
   IF (key_name_ IS NULL) OR (key_value_ IS NULL) OR (language_code_ IS NULL) THEN
      NULL;
   ELSE
      -- Prog should not be stored anymore (starting from Apps 10)
      IF (language_code_ = 'PROG') THEN
         NULL;
      ELSE
         OPEN exist_in_trans_tab;
         FETCH exist_in_trans_tab INTO dummy_;
         IF (exist_in_trans_tab%FOUND) THEN
            BEGIN
               INSERT 
                  INTO key_lu_translation_imp_tab(
                     key_name,
                     key_value,
                     language_code)
                  VALUES(
                     key_name_,
                     key_value_,
                     language_code_);
            -- ignore if already exist
            EXCEPTION
               WHEN dup_val_on_index THEN
                  NULL;
            END;
         END IF;
         CLOSE exist_in_trans_tab;
      END IF;
   END IF;
END Insert_Translation_Lng___;


PROCEDURE Remove_Translation_Lng___(
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   language_code_ IN VARCHAR2)
IS
BEGIN
   -- Delete the language row if no translations exist for the language.
   DELETE FROM key_lu_translation_imp_tab a
      WHERE key_name = key_name_
      AND key_value = key_value_
      AND language_code = language_code_
      AND NOT EXISTS (SELECT language_code
                      FROM key_lu_translation_tab b
                      WHERE a.key_name = b.key_name
                      AND a.key_value = b.key_value
                      AND a.language_code = b.language_code);
END Remove_Translation_Lng___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED', 'FALSE', attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_Installation_Text__ (
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
BEGIN
   IF (attribute_key_ IS NULL) THEN
      UPDATE key_lu_translation_tab
         SET current_translation = installation_translation,
             system_defined = 'TRUE'
         WHERE key_name = key_name_
         AND key_value  = key_value_
         AND module     = module_
         AND lu         = lu_         
         AND NVL(current_translation, CHR(0)) != NVL(installation_translation, CHR(0))
         AND installation_translation IS NOT NULL;
   ELSE
      UPDATE key_lu_translation_tab
         SET current_translation = installation_translation,
             system_defined = 'TRUE'
         WHERE key_name    = key_name_
         AND key_value     = key_value_
         AND module        = module_
         AND lu            = lu_
         AND attribute_key = attribute_key_
         AND language_code = language_code_
         AND NVL(current_translation, CHR(0)) != NVL(installation_translation, CHR(0))
         AND installation_translation IS NOT NULL;
   END IF;
END Copy_Installation_Text__;


@UncheckedAccess
FUNCTION Get_Prog_Current_Translation__ (
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Key_Lu_Attribute_API.Get_Attribute_Text__(key_name_, key_value_, module_, lu_, attribute_key_);
END Get_Prog_Current_Translation__;


PROCEDURE Refresh_Translation_Imp__(
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Refresh_Translation_Imp___(key_name_, key_value_, language_code_);
END Refresh_Translation_Imp__;


PROCEDURE Insert_Translation_Lng__(
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
BEGIN
   Insert_Translation_Lng___(key_name_, key_value_, language_code_);
END Insert_Translation_Lng__;


PROCEDURE Remove_Translation_Lng__(
   key_name_      IN VARCHAR2,
   key_value_     IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
BEGIN
   Remove_Translation_Lng___(key_name_, key_value_, language_code_);
END Remove_Translation_Lng__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


