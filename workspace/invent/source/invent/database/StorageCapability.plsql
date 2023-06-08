-----------------------------------------------------------------------------
--
--  Logical unit: StorageCapability
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120904  JeLise   Moved from Partca to Invent.
--  100824  DaZase   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Capability_Rec IS RECORD (
    storage_capability_id STORAGE_CAPABILITY_TAB.storage_capability_id%TYPE);

TYPE Capability_Tab IS TABLE OF Capability_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


