-----------------------------------------------------------------------------
--
--  Logical unit: Selection
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

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SELECTION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.selection_id := sys_guid;
   Client_SYS.Add_To_Attr('SELECTION_ID', newrec_.selection_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


