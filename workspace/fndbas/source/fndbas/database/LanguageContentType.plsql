-----------------------------------------------------------------------------
--
--  Logical unit: LanguageContentType
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020703  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030131   StDa     GLOB01E. Move Company Template Translations.
--                  Added values to Enum_Main_Types_ and Enum_Main_Types_Db_.
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030908  ROOD    Corrected method Register to use all parameters (Bug#39345).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Enum_Main_Types_ RETURN VARCHAR2
IS
   client_values_ VARCHAR2(2000);
   CURSOR main_types IS
      SELECT description
      FROM LANGUAGE_CONTENT_TYPE_TAB
      ORDER BY code;
BEGIN
   FOR mt_rec IN main_types LOOP
      client_values_ := client_values_ || mt_rec.description || '^';
   END LOOP;
   RETURN client_values_ || 'Language File^Translation File^Basic Data Translation^Company Template^Company Template Translation^';
END Enum_Main_Types_;


@UncheckedAccess
FUNCTION Enum_Sub_Types_ RETURN VARCHAR2
IS
   values_       VARCHAR2(32000);
   sub_type_     VARCHAR2(100);
   occurance_of_ NUMBER := 1;
   pos_          NUMBER;
   last_pos_     NUMBER := 1;
   duplicate_    NUMBER;
   
   CURSOR cs_sub_types IS
      SELECT sub_types
      FROM LANGUAGE_CONTENT_TYPE_TAB;
BEGIN
   FOR st_rec IN cs_sub_types LOOP
      occurance_of_ := 1;
      last_pos_ := 1;
      LOOP
         pos_ := instr(st_rec.sub_types, '^', 1, occurance_of_);
         sub_type_ := substr(st_rec.sub_types, last_pos_, pos_ - last_pos_);
         IF pos_ = 0 THEN
            EXIT;
         END IF;
         duplicate_ := nvl(instr(values_, sub_type_ || '^' ),0);
         IF (duplicate_ = 0) THEN
            values_ := values_ || sub_type_ || '^';
         END IF;
         last_pos_ := pos_ + 1;
         occurance_of_ := occurance_of_ + 1;
      END LOOP;
   END LOOP;
   RETURN values_;
END Enum_Sub_Types_;


@UncheckedAccess
FUNCTION Enum_Main_Types_Db_ RETURN VARCHAR2
IS
   db_values_ VARCHAR2(2000);
   CURSOR main_types IS
      SELECT code
      FROM LANGUAGE_CONTENT_TYPE_TAB
      ORDER BY code;
BEGIN
   FOR mt_rec IN main_types LOOP
      db_values_ := db_values_ || mt_rec.code || '^';
   END LOOP;
   RETURN db_values_ || 'LF^TF^BDT^TEMPL^TEMPT^';
END Enum_Main_Types_Db_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register (
   code_               IN VARCHAR2,
   description_        IN VARCHAR2,
   source_driver_      IN VARCHAR2,
   destination_driver_ IN VARCHAR2,
   sub_types_          IN VARCHAR2 )
IS
BEGIN
   -- Validate parameters
   Language_Driver_API.Exist_Db( source_driver_ );
   Language_Driver_API.Exist_Db( destination_driver_ );
   -- Update previous registration
   UPDATE LANGUAGE_CONTENT_TYPE_TAB
      SET code                = code_,
          description         = description_,
          source_driver       = source_driver_,
          destination_driver  = destination_driver_,
          sub_types           = sub_types_,
          rowversion          = SYSDATE
      WHERE code = code_;
   -- Or insert a new registration if there is no previous
   IF (sql%NOTFOUND) THEN
      INSERT INTO LANGUAGE_CONTENT_TYPE_TAB
               (code, description, source_driver, destination_driver, sub_types, rowversion)
         VALUES
            (code_, description_, source_driver_, destination_driver_, sub_types_, SYSDATE);
   END IF;
END Register;


PROCEDURE Unregister (
   code_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM LANGUAGE_CONTENT_TYPE_TAB WHERE code = code_;
END Unregister;



