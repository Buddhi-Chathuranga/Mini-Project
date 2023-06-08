-----------------------------------------------------------------------------
--
--  Logical unit: LanguageSource
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960825  DAJO    Fixed bug #683
--  961106  DAJO    Added translation of report column status texts
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030225  STDA    GLOB01E. Move Company Template Translations.
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  060829  DuWiLk  Use the Fnd_Session_API.Get_Fnd_User function to get Foundation1 user
--                  in Register__ procedure (Bug#58176)
--  060928  STDA    Translation Simplification (BUG#58618).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Register__
--   Registers the build/load of a source.
PROCEDURE Register__ (
   name_             IN VARCHAR2,
   full_name_        IN VARCHAR2,
   module_           IN VARCHAR2,
   main_type_        IN VARCHAR2,
   customer_fitting_ IN VARCHAR2,
   import_method_    IN VARCHAR2,
   file_date_        IN DATE DEFAULT SYSDATE )
IS
   user_    VARCHAR2(30);
BEGIN
   --Get the current Foundation1 user throug Fnd_Session_API
   user_ := Fnd_Session_API.Get_Fnd_User;
   -- Update previous registration
   UPDATE LANGUAGE_SOURCE_TAB
      SET name             = name_,
          register_date    = SYSDATE,
          register_user    = user_,
          file_date        = file_date_,
          rowversion       = SYSDATE
      WHERE module = upper(module_)
      AND upper(name) = upper(name_)
      AND main_type = main_type_;
   --
   -- Or insert a new registration if there is no previous
   IF (sql%NOTFOUND) THEN
      INSERT INTO LANGUAGE_SOURCE_TAB
               (name, module, register_date, register_user, main_type, import_method, file_date, rowversion)
         VALUES
            (name_, upper(module_), SYSDATE, user_, main_type_, import_method_, file_date_, SYSDATE);
   END IF;
END Register__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Remove_Module_
--   Removes all registered sources for the given module.
PROCEDURE Remove_Module_ (
   module_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM LANGUAGE_SOURCE_TAB
      WHERE module = module_;
END Remove_Module_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Main_Type (
   module_ IN VARCHAR2,
   name_ IN VARCHAR2,
   main_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_              LANGUAGE_SOURCE_TAB.main_type%TYPE;
   encoded_main_type_ LANGUAGE_SOURCE_TAB.main_type%TYPE;
   CURSOR get_attr(enc_main_type_ IN VARCHAR2) IS
      SELECT main_type
      FROM LANGUAGE_SOURCE_TAB
      WHERE module = module_
      AND   name = name_
      AND   main_type = enc_main_type_;
BEGIN
   encoded_main_type_ := Language_Context_Main_Type_API.Encode(main_type_);
   OPEN get_attr(encoded_main_type_);
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Language_Context_Main_Type_API.Decode(temp_);
END Get_Main_Type;



