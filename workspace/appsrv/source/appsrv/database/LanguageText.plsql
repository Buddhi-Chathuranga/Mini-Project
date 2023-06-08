-----------------------------------------------------------------------------
--
--  Logical unit: LanguageText
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131123  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  100422 AJPELK Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  031016 DHSELK Added Init Method 
--  960424  JaPa  Created.
--  960828  JaPa  Changed module to APPSRV.
--  960913  JaPa  Default parameters to functions. Changed functionality
--                for null values.
--  970401  JaPa  Decode() returns 'en'-text for PROG if PROG not found.
--                Codes 'PROG' and 'ORG' allowed
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_sep_ CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
rec_sep_   CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Encode__
--   Private function that calls from the public one.
--   Performs no validation of language code.
--   Requires database value of the code.
@UncheckedAccess
FUNCTION Encode__ (
   client_text_  IN VARCHAR2,
   db_text_      IN VARCHAR2,
   db_lang_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pos_   NUMBER;
   next_  NUMBER;
   text_  VARCHAR2(2000);
BEGIN
   IF db_lang_code_ is null THEN
      RETURN db_text_;
   END IF;
   pos_  := nvl(instr(db_text_, rec_sep_ || db_lang_code_ || field_sep_), 0);
   next_ := nvl(instr(db_text_, rec_sep_, pos_+1), 0);
   IF pos_ = 0 THEN
      text_ := rec_sep_ || ltrim(db_text_, rec_sep_);
   ELSE
      text_ := substr(db_text_, 1, pos_-1) || substr(db_text_, next_);
   END IF;
   RETURN text_ || db_lang_code_ || field_sep_ || client_text_ || rec_sep_;
END Encode__;



-- Decode__
--   Private function that calls from the public one. Language code is required,
--   but not validated.
@UncheckedAccess
FUNCTION Decode__ (
   db_text_      IN VARCHAR2,
   db_lang_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pos_   NUMBER;
   next_  NUMBER;
BEGIN
   IF db_lang_code_ is not null THEN
      pos_ := nvl(instr(db_text_, rec_sep_ || db_lang_code_ || field_sep_), 0);
   ELSE
      pos_ := 1;
   END IF;
   IF pos_ > 0 THEN
      pos_  := nvl(instr(db_text_, field_sep_, pos_+1), 0) + 1;
      next_ := nvl(instr(db_text_, rec_sep_, pos_), 0);
      RETURN substr(db_text_, pos_, next_-pos_);
   ELSE
      RETURN null;
   END IF;
END Decode__;



-- Remove__
--   Private function that removes localized text for database value of
--   language code given in DbLangCode. Returns the new value of DbText
@UncheckedAccess
FUNCTION Remove__ (
   db_text_      IN VARCHAR2,
   db_lang_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pos_   NUMBER;
   next_  NUMBER;
BEGIN
   IF db_lang_code_ is null THEN
      RETURN db_text_;
   END IF;
   pos_  := nvl(instr(db_text_, rec_sep_ || db_lang_code_ || field_sep_), 0);
   next_ := nvl(instr(db_text_, rec_sep_, pos_+1), 0);
   IF pos_ = 0 THEN
      RETURN db_text_;
   ELSE
      RETURN substr(db_text_, 1, pos_-1) || substr(db_text_, next_);
   END IF;
END Remove__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Encode
--   Returns the coded value for the attribute that will be stored
--   in the table.
--   ClientText is the description in LanguageCode. If LanguageCode is NULL
--   the actual language from server is taken instead (Language_SYS.Get_Language).
--   The LanguageCode parameter is the client value of the language.
--   DbText is the old value of the coded attribute (from database).
@UncheckedAccess
FUNCTION Encode (
   client_text_   IN VARCHAR2,
   db_text_       IN VARCHAR2,
   language_code_ IN VARCHAR2 default NULL ) RETURN VARCHAR2
IS
   lang_  VARCHAR2(10);
BEGIN
   IF language_code_ is null THEN
      lang_ := Language_SYS.Get_Language;
   ELSIF language_code_ in ('PROG','ORG') THEN
      lang_ := language_code_;      
   ELSE
      lang_ := Iso_Language_API.Encode(language_code_);
   END IF;
   RETURN Encode__(client_text_, db_text_, lang_);
END Encode;



-- Decode
--   Returns description in language for LanguageCode. If LanguageCode is NULL
--   the actual language from server is taken instead (Language_SYS.Get_Language).
--   The LanguageCode parameter is the client value for the language.
--   DbText is the stored coded value for the attribute (value of the table column).
@UncheckedAccess
FUNCTION Decode (
   db_text_       IN VARCHAR2,
   language_code_ IN VARCHAR2 default NULL ) RETURN VARCHAR2
IS
   lang_  VARCHAR2(10);
   text_  VARCHAR2(2000);
BEGIN
   IF language_code_ is null THEN
      lang_ := Language_SYS.Get_Language;
   ELSIF language_code_ in ('PROG','ORG') THEN
      lang_ := language_code_;      
   ELSE
      lang_ := Iso_Language_API.Encode(language_code_);
   END IF;
   text_ := Decode__(db_text_, lang_);
   IF text_ is null THEN
      IF lang_ = 'PROG' THEN
         text_ := Decode__(db_text_,'en');
      ELSE
         text_ := Decode__(db_text_,'PROG');
      END IF;
      IF text_ is null THEN
         text_ := Decode__(db_text_, null);
      ELSIF lang_ = 'PROG' THEN
         RETURN text_;
      END IF;
      IF text_ is null THEN
         RETURN null;
      ELSE
         RETURN '<' || text_ || '>';
      END IF;
   ELSE
      RETURN text_;
   END IF;
END Decode;



@UncheckedAccess
PROCEDURE Exist (
   text_ IN VARCHAR2 )
IS
BEGIN
   NULL;
END Exist;


-- Remove
--   Removes language depended description in DbText for language given in LanguageCode.
--   If no code is given the current client language is taken.
--   Returns the new value of DbText.
@UncheckedAccess
FUNCTION Remove (
   db_text_       IN VARCHAR2,
   language_code_ IN VARCHAR2 default NULL ) RETURN VARCHAR2
IS
   lang_  VARCHAR2(10);
BEGIN
   IF language_code_ is null THEN
      lang_ := Language_SYS.Get_Language;
   ELSIF language_code_ in ('PROG','ORG') THEN
      lang_ := language_code_;      
   ELSE
      lang_ := Iso_Language_API.Encode(language_code_);
   END IF;
   RETURN Remove__(db_text_, lang_);
END Remove;




