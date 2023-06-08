-----------------------------------------------------------------------------
--
--  Logical unit: SalesChargeGroupDesc
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160829  SudJlk   STRSC-1782, Overriden Check_Update___ to make sure parent is not blocked for access.
--  060118  JaJalk   Added the returning clause in Insert___ according to the new F1 template.
--  991001  DaZa     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SALES_CHARGE_GROUP_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT Document_Text_API.Get_Next_Note_Id INTO newrec_.note_id FROM DUAL;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
   END Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     SALES_CHARGE_GROUP_DESC_TAB%ROWTYPE,
   newrec_ IN OUT SALES_CHARGE_GROUP_DESC_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Make sure parent is not blocked for access
   Sales_Charge_Group_API.Exist(newrec_.charge_group, true);
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


