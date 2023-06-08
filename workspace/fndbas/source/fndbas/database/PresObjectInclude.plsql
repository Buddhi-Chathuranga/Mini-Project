-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectInclude
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Clear_Module (
   module_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM pres_object_include_sec_tab 
      WHERE po_id IN  (
         SELECT po_id 
         FROM pres_object_include_tab 
         WHERE module = module_);
   DELETE FROM pres_object_include_tab
      WHERE module = module_;
END Clear_Module;
