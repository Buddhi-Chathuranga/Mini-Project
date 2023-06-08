-----------------------------------------------------------------------------
--
--  Logical unit: ApplicationLanguage
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970506  JaPa    Created
--  040301  ThAblk  Removed substr from views.
--  051004  BaMalk  Changed description in Application_Language view to handle translations.
--  --------------------------Eagle------------------------------------------
--  100421  Ajpelk  Merge rose method documentation
--  ------------------------- PEREGRINE -------------------------------------
--  110223  ArWiLK Added new public method Check_Exist.
--  ---------------------------- APPS 9 -------------------------------------
--  131129  jagrno  Hooks: Refactored and split code. This LU is referenced from multiple
--                  other LU's, and can thus not be changed into a Utility LU even though 
--                  that would be best. All base methods have been re-introduced, but all
--                  editing is prevented through error messages. All attributes are made 
--                  not insertable and not updateable
--  131205  jagrno  Made the entity read-only.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Overtaken because we need to re-direct method call to Iso_Language_API.Exist
@Overtake Base
@UncheckedAccess
PROCEDURE Exist (
   language_code_ IN VARCHAR2 )
IS
BEGIN
   Iso_Language_API.Exist(language_code_);
END Exist;


-- Get_Description
--   Gets language description in a specified language.
--   If LanguageCode is NULL the actual language from server is taken
@UncheckedAccess
FUNCTION Get_Description (
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Iso_Language_API.Get_Description(language_code_);
END Get_Description;


@UncheckedAccess
FUNCTION Check_Exist (
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   retval_ VARCHAR2(5) := 'FALSE';
BEGIN
   IF (Iso_Language_API.Check_Used_In_Appl(language_code_)) THEN
      retval_ := 'TRUE';
   END IF;
   RETURN(retval_);
END Check_Exist;
