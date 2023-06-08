-----------------------------------------------------------------------------
--
--  Logical unit: OutMessageLine
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  971117  JHMA    Created.
--  980309  ERFO    Decreased number of supported columns to 45/15/5.
--  980325  JHMA    Security check removed on methods called from Connectivity_SYS.
--  981006  ERFO    Removed limitations on number of items (Bug #2215).
--  991119  ERFO    Solved cleanup problem by adding a CASCADE (Bug #3086).
--  000808  ROOD    Upgraded to Yoshimura template (Bug#15811).
--                  Removed last parameter 'TRUE' from all General_SYS.Init_Method.
--                  Removed unused states 'Normal' and 'StartState'.
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  100108  HAYA    Updated to new server template
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   newrec_ IN OUT NOCOPY out_message_line_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


