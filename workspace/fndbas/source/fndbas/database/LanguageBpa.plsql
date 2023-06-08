-----------------------------------------------------------------------------
--
--  Logical unit: Command
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211209  PAPELK  Removed PRAGMA AUTONOMOUS block from Add_Translations procedure and added a new parameter to Refresh_Language_Dictionary_ procedure (TEWF-647)
--  211101  ACHSLK  Added PRAGMA AUTONOMOUS block to Add_Translations procedure (TEWF-647)
--  200818  SUUPCA  Created for Workflows (TEWF-139)
-----------------------------------------------------------------------------
--
--  Contents:     Implementation methods for BPA translations
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------
TYPE Translation_Dec IS RECORD(   
   lang_code     VARCHAR2(10),
   lang_text     VARCHAR2(2000));

TYPE Translation_Drr IS TABLE OF Translation_Dec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Add_Translations( 
   process_id_       IN VARCHAR2,
   failure_event_id_ IN VARCHAR2,
   path_             IN VARCHAR2,
   prog_text_        IN VARCHAR2,
   translations_map_ IN Translation_Drr 
  )
IS 
   -- Context Data
   process_context_id_     language_context_tab.context_id%TYPE := 0;
   event_context_id_       language_context_tab.context_id%TYPE := 0;   
   -- Attribute Data
   attribute_id_           language_attribute_tab.attribute_id%TYPE := 0;
      
BEGIN
      
   Language_Context_API.Refresh_(process_context_id_, NULL, process_id_, 0, 'SP-BPA', 'Basic Data', 'FNDBAS', process_id_, 0, 0);
   Language_Context_API.Refresh_(event_context_id_, NULL, failure_event_id_, process_context_id_, 'SP-BPA', 'Messages', 'FNDBAS', path_, 0, 0);
   Language_Attribute_API.Refresh_(attribute_id_, event_context_id_, 'Text', prog_text_);
   
   FOR i IN translations_map_.FIRST .. translations_map_.LAST LOOP
      Language_Translation_API.Refresh_(attribute_id_, translations_map_(i).lang_code, translations_map_(i).lang_text, 'C'); 
   END LOOP;

   Language_SYS.Refresh_Language_Dictionary_(NULL, 'FNDBAS', 'FALSE', 'FALSE', 'SP-BPA', NULL, path_, 'FALSE');

END Add_Translations;


-------------------- LU  NEW METHODS -------------------------------------
