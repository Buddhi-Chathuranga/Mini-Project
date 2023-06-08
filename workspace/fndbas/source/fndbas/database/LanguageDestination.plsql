-----------------------------------------------------------------------------
--
--  Logical unit: LanguageDestination
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020703  ROOD     Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030130  NIPAFI   Changed REF for attribute module in VIEW from LanguageModule
--                   to Module.
--  030212  ROOD     Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR     Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  060829  DuWiLk   Use the Fnd_Session_API.Get_Fnd_User function to get Foundation1 user
--                   in Register__ procedure (Bug#58176)
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK   Merged Rose Documentation
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Ctbl_Get_Named_Menu_Id__ (
   id_     OUT NUMBER,
   module_ IN  VARCHAR2,
   path_   IN  VARCHAR2,
   name_   IN  VARCHAR2 )
IS
   tmp_id_      NUMBER;
   CURSOR global_cur IS
      SELECT context_id
      FROM language_context
      WHERE module = module_
      AND path = module_ || '.' || 'Named Menus' || '.' || name_
      AND name = name_;
   CURSOR local_cur IS
      SELECT context_id
      FROM language_context
      WHERE module = module_
      AND path = path_ || '.'  || name_
      AND name = name_;
BEGIN
   OPEN local_cur;
   FETCH local_cur INTO tmp_id_;
   IF local_cur%FOUND THEN
      id_ := tmp_id_;
   ELSE
      OPEN global_cur;
      FETCH global_cur INTO tmp_id_;
      IF global_cur%FOUND THEN
         id_ := tmp_id_;
      ELSE
         id_ := 0;
      END IF;
      CLOSE global_cur;
   END IF;
   CLOSE local_cur;
END Ctbl_Get_Named_Menu_Id__;


-- Register__
--   Registers the export/generation of a destination.
PROCEDURE Register__ (
   name_             IN VARCHAR2,
   full_name_        IN VARCHAR2,
   module_           IN VARCHAR2,
   main_type_        IN VARCHAR2,
   customer_fitting_ IN VARCHAR2,
   export_method_    IN VARCHAR2 )
IS
   user_    VARCHAR2(30);
BEGIN
   -- Get the current Foundation1 user throug Fnd_Session_API
   user_ := Fnd_Session_API.Get_Fnd_User;
   -- Update previous registration
   UPDATE LANGUAGE_DESTINATION_TAB
      SET name             = name_,
          register_date    = SYSDATE,
          register_user    = user_,
          module           = upper(module_),
          rowversion       = SYSDATE
      WHERE upper(name) = upper(name_)
      AND main_type = main_type_;
   -- Or insert a new registration if there is no previous
   IF (sql%NOTFOUND) THEN
      INSERT INTO LANGUAGE_DESTINATION_TAB
            (name, module, register_date, register_user, main_type, export_method, rowversion)
         VALUES
            (name_, upper(module_), SYSDATE, user_, main_type_, export_method_, SYSDATE);
   END IF;
END Register__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Remove_Module_
--   Removes all registered destinations for the given module.
PROCEDURE Remove_Module_ (
   module_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM LANGUAGE_DESTINATION_TAB
      WHERE module = module_;
END Remove_Module_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Main_Type (
   module_ IN VARCHAR2,
   name_ IN VARCHAR2,
   main_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_              LANGUAGE_DESTINATION_TAB.main_type%TYPE;
   encoded_main_type_ LANGUAGE_DESTINATION_TAB.main_type%TYPE;
   CURSOR get_attr(enc_main_type_ IN VARCHAR2) IS
      SELECT main_type
      FROM LANGUAGE_DESTINATION_TAB
      WHERE module = module_
      AND   name = name_
      AND   main_type =  enc_main_type_;
BEGIN
   encoded_main_type_ := Language_Context_Main_Type_API.Encode(main_type_);
   OPEN get_attr(encoded_main_type_);
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Language_Context_Main_Type_API.Decode(temp_);
END Get_Main_Type;



