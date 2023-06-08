-----------------------------------------------------------------------------
--
--  Logical unit: SiteText
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  951121  PARO  Base Table to Logical Unit Generator 1.0A
--  951128  MANY  Added Get_Contents().
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  020703  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Get_Contents(
   site_list_ OUT VARCHAR2)
IS
   field_separator_  VARCHAR2(1) := Client_SYS.field_separator_;
   record_separator_ VARCHAR2(1) := Client_SYS.record_separator_;
   CURSOR site_texts IS
      SELECT variable_name, text
      FROM   SITE_TEXT_TAB;
   texts_ VARCHAR2(32000);
BEGIN
   FOR current_text_ IN site_texts LOOP
      texts_ := texts_ || current_text_.variable_name || field_separator_ ||
                          current_text_.text || record_separator_;
   END LOOP;
   site_list_ := texts_;
END Get_Contents;



