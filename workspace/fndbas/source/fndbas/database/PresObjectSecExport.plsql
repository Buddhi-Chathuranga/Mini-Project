-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectSecExport
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100316  UsRaLK  Created.
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
BEGIN
   -- Currently hard coded to one week, since this cleanup is not
   -- a something that need to run regularly.
   DELETE FROM pres_object_sec_export_tab
      WHERE created_date < ( sysdate - 7 );
END Cleanup__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
