-----------------------------------------------------------------------------
--
--  Logical unit: SiteStorageCapability
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  111121  JeLise  Added method Get_Capabilities.
--  100812  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Capabilities (
   contract_ IN VARCHAR2 ) RETURN Storage_Capability_API.Capability_Tab
IS
   capability_tab_ Storage_Capability_API.Capability_Tab;

   CURSOR get_capabilities IS
      SELECT storage_capability_id
      FROM SITE_STORAGE_CAPABILITY_TAB
      WHERE contract = contract_;
BEGIN
   OPEN get_capabilities;
   FETCH get_capabilities BULK COLLECT INTO capability_tab_;
   CLOSE get_capabilities;

   RETURN (capability_tab_);
END Get_Capabilities;



