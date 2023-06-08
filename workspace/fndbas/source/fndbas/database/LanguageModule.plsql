-----------------------------------------------------------------------------
--
--  Logical unit: LanguageModule
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  001229  ERFO    Fixed performance problem in view definition (Bug #18852).
--  020703  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD    Changed hardcoded FNDSER to FNDBAS (ToDo#4149).
--  040702  ROOD    Removed obsolete call for libraries, modified call for Lu's (F1PR413).
--  070828  LALI    Modified view LANGUAGE_MODULE just slightly
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation.
--  130621  UsRa  Modified [Enum_Module_Units__] to support SYS packages for FNDCOB (Bug#110806)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Remove__
--   Client-support interface to remove LU instances.
--   action_ = 'CHECK'
--   Check whether a specific LU-instance may be removed or not.
--   The procedure fetches the complete record by calling procedure
--   Get_Object_By_Id___. Then the check is made by calling procedure
--   The Remove function removes all context, attributes, properties and
--   translations for the module.
PROCEDURE Remove__ (
   module_ IN VARCHAR2 )
IS
BEGIN
   Language_Context_API.Remove_Module_( module_ );
   Language_Sys.Remove_Module_( module_ );
   Language_Source_API.Remove_Module_( module_ );
   Language_Destination_API.Remove_Module_( module_ );
END Remove__;


-- Make_Obsolete__
--   The MakeObsolete function marks all contexts, attributes, properties and
--   translations in the module as obsolete. This function is typically called
--   before a complete rebuild of the language database.
PROCEDURE Make_Obsolete__ (
   module_      IN VARCHAR2,
   layer_       IN VARCHAR2,
   main_type_   IN VARCHAR2,
   sub_type_    IN VARCHAR2)
IS
   CURSOR children IS
      SELECT context_id, layer
      FROM LANGUAGE_CONTEXT
      WHERE module = module_
      AND layer = layer_
      and main_type_db like main_type_
      and sub_type like sub_type_;

   CURSOR clean IS
      SELECT context_id, layer
      FROM LANGUAGE_CONTEXT
      WHERE module = module_
      AND layer = layer_
      and main_type_db = main_type_
      and parent = 0
      and obsolete_db = 'N'
      and sub_type not in ('Logical Unit', 'Basic Data', 'Company Template', 'Search Domain');
      
BEGIN
   Trace_SYS.Message('Making module ' || module_ || ' obsolete');
   --
   -- Check that module exist
   Module_API.Exist( module_ );
   --
   -- Recursively make all children obsolete
   FOR child IN children LOOP
      Language_Context_API.Make_Obsolete_Lng_( child.context_id, child.layer );
   END LOOP;

   IF main_type_ = 'LU' THEN
      FOR cleaned IN clean LOOP
         Language_Context_API.Make_Obsolete_Lng_( cleaned.context_id, cleaned.layer );
      END LOOP;   
   END IF;

END Make_Obsolete__;

-- Make_Usage_Obsolete__
--   The MakeUsageObsolete function marks all attributes with usage = 'FALSE'.
--   This function is typically called before loading the usage lng file for the module.
PROCEDURE Make_Usage_Obsolete__ (
   module_      IN VARCHAR2,
   layer_       IN VARCHAR2,
   main_type_   IN VARCHAR2,
   sub_type_    IN VARCHAR2)
IS
   CURSOR contexts IS
      SELECT context_id
      FROM LANGUAGE_CONTEXT
      WHERE module = module_
      AND parent = 0
      AND layer = layer_
      AND main_type_db = main_type_
      AND sub_type like sub_type_;
      
BEGIN
   Trace_SYS.Message('Making module ' || module_ || ' usages set to FALSE');
   --
   -- Check that module exist
   Module_API.Exist( module_ );
   --
   -- Recursively make all children obsolete
   FOR context IN contexts LOOP
      Language_Context_API.Make_Usage_Obsolete_( context.context_id, layer_ );
   END LOOP;

END Make_Usage_Obsolete__;
   
PROCEDURE Make_Module_Obsolete__ (
   module_      IN VARCHAR2,
   layer_       IN VARCHAR2)
IS
   CURSOR children IS
      SELECT context_id, layer
      FROM LANGUAGE_CONTEXT
      WHERE module = module_
      AND layer = layer_;
      
BEGIN
   Trace_SYS.Message('Making module ' || module_ || ' obsolete');
   --
   -- Check that module exist
   Module_API.Exist( module_ );
   --
   -- Recursively make all children obsolete
   FOR child IN children LOOP
      --Language_Context_API.Make_Obsolete_( child.context_id, child.layer );
      Language_Context_API.Make_Obsolete_Lng_( child.context_id, child.layer );
   END LOOP;

END Make_Module_Obsolete__;

/*PROCEDURE Enum_Module_Units__ (
   module_          IN  VARCHAR2,
   system_services_ OUT VARCHAR2,
   logical_units_   OUT VARCHAR2,
   libraries_       OUT VARCHAR2 )
IS
BEGIN
   IF (module_ IN ('FNDBAS', 'FNDCOB')) THEN
      Dictionary_SYS.Enum_Module_System_Services_( system_services_, module_ );
   END IF;
   Dictionary_SYS.Enum_Module_Logical_Units_( logical_units_, module_ );
END Enum_Module_Units__;*/

PROCEDURE Enum_Module_Units__ (
   module_          IN  VARCHAR2,
   system_services_ OUT VARCHAR2,
   logical_units_   OUT VARCHAR2,
   libraries_       OUT VARCHAR2 )
IS
BEGIN
   IF (module_ IN ('FNDBAS', 'FNDCOB')) THEN
      Dictionary_SYS.Enum_Reports_Module_Sys_Serv_( system_services_, module_ );
   END IF;
   Dictionary_SYS.Enum_Reports_Module_Lu_( logical_units_, module_ );
END Enum_Module_Units__;


-- Remove_Language__
--   The Remove function removes all translations in a specified language
--   from the module.
PROCEDURE Remove_Language__ (
   module_    IN VARCHAR2,
   layer_     IN VARCHAR2,
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   Language_Context_API.Remove_Module_Language_( module_, layer_, lang_code_ );
END Remove_Language__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Name (
   module_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ LANGUAGE_MODULE.name%TYPE;
   CURSOR get_attr IS
      SELECT name
      FROM LANGUAGE_MODULE
      WHERE module = module_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Name;


@UncheckedAccess
FUNCTION Get_Description (
   module_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ LANGUAGE_MODULE.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM LANGUAGE_MODULE
      WHERE module = module_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Description;


@UncheckedAccess
PROCEDURE Enumerate (
   list_   OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR enumerate IS
      SELECT module
      FROM   language_module;
BEGIN
   FOR module IN enumerate LOOP
      temp_ := temp_ || module.module || Client_SYS.field_separator_;
   END LOOP;
   list_ := temp_;
END Enumerate;



