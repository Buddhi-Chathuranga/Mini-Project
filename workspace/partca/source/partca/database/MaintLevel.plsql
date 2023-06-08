-----------------------------------------------------------------------------
--
--  Logical unit: MaintLevel
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130729  MaIklk  TIBE-1039, Removed DocTextInst_ global constant and used conditional compilation instead.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060123  JaJalk  Added Assert safe annotation.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  040507  KESMUS Made call to Document_Text_API.Get_Next_Note_Id dynamic.
--  040211  KESMUS EM01 - Moved LU to PARTCA.
--  030311  JICE   Attribute Maint_Description made public.
--  030305  JICE   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MAINT_LEVEL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS   
BEGIN
   $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      newrec_.note_id := Document_Text_API.Get_Next_Note_Id; 
   $END
   Client_SYS.Set_Item_Value('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


