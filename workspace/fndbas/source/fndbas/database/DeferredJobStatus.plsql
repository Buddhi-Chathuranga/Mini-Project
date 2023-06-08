-----------------------------------------------------------------------------
--
--  Logical unit: DeferredJobStatus
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980116  ERFO  Created for Foundation1 release 2.1.0.
--  010904  ROOD  Added column status_type, updated template (ToDo#4038).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('STATUS_TYPE', 'WARNING', attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

