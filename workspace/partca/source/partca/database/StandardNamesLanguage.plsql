-----------------------------------------------------------------------------
--
--  Logical unit: StandardNamesLanguage
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  091203  MoNilk   Modified REF in column comment on language_code to IsoLanguage in STANDARD_NAMES_LANGUAGE.
--  060727  ThGulk   Added &OBJID instead of rowif in Procedure Insert___
--  060601  MiErlk   Enlarge Identity - Changed view comments Description.
--  ------------------------- 12.4.0 ---------------------------------------------
--  060110  NaWalk   Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  031222  ISANLK   Merged lines in the Close Cursor.
--  -----------------------------12.3.0-------------------------
--  000925  JOHESE   Added undefines.
--  990414  FRDI     Upgraded to performance optimized template.
--  971124  TOOS     Upgrade to F1 2.0
--  970527  AnLi     Created
--  970527  JoRo     Modified Get_Std_Name to return std_name from stdandard_names.
--                   If no language exist, default language is fetched.
--  970616  NiHe     Changed format on std_name to uppercase
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Std_Name (
   language_code_ IN VARCHAR2,
   std_name_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ STANDARD_NAMES_LANGUAGE_TAB.std_name%TYPE;
   CURSOR get_attr IS
      SELECT std_name
      FROM STANDARD_NAMES_LANGUAGE_TAB
      WHERE language_code = nvl(language_code_,language_sys.get_language)
      AND   std_name_id = std_name_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ IS NULL) THEN
      temp_ := standard_names_api.Get_Std_Name( std_name_id_ );
   END IF;
   RETURN temp_;
END Get_Std_Name;



