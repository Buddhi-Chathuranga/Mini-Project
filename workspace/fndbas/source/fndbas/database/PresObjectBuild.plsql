-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectBuild
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE table_rec IS pres_object_build_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Or_Replace (
   rec_  IN OUT table_rec )
IS
BEGIN
   IF Check_Exist___(rec_.po_id) THEN
      Modify___(rec_);
   ELSE
      New___(rec_);
   END IF;
END Create_Or_Replace;

