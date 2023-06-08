-----------------------------------------------------------------------------
--
--  Logical unit: FndProjLookupUsage
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

PROCEDURE Create_Or_Replace(
   projection_name_   IN VARCHAR2,
   entity_name_       IN VARCHAR2,
   lookup_attribute_  IN VARCHAR2,
   used_lu_         IN VARCHAR2 )
IS
   rec_ fnd_proj_lookup_usage_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entity_name := entity_name_;
   rec_.lookup_attribute := lookup_attribute_;
   rec_.used_lu := used_lu_;
   
   IF (Check_Exist___(rec_.projection_name, rec_.entity_name, rec_.lookup_attribute)) THEN
      Remove___(rec_,FALSE);
   END IF;
   New___(rec_);
   
END Create_Or_Replace;