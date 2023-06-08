-----------------------------------------------------------------------------
--
--  Logical unit: LanguageProperty
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020703  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Get__ (
   value_      OUT VARCHAR2,
   context_id_ IN  NUMBER,
   name_       IN  VARCHAR2 )
IS
BEGIN
   value_ := Get_Value ( context_id_, name_ );
END Get__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Refresh_ (
   context_id_ IN NUMBER,
   name_       IN VARCHAR2,
   value_      IN VARCHAR2 )
IS
BEGIN
   UPDATE LANGUAGE_PROPERTY_TAB
      SET value = value_
      WHERE context_id = context_id_
      AND name = name_;
   IF (sql%NOTFOUND) THEN
      INSERT INTO LANGUAGE_PROPERTY_TAB
               (context_id, name, value, rowversion)
         VALUES
            (context_id_, name_, value_, 1);
   END IF;
END Refresh_;


PROCEDURE Remove_Context_ (
   context_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM LANGUAGE_PROPERTY_TAB
      WHERE context_id = context_id_;
END Remove_Context_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


