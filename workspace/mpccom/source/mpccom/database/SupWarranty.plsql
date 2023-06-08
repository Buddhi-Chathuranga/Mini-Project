-----------------------------------------------------------------------------
--
--  Logical unit: SupWarranty
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120213  HaPulk  Changed dynamic code to PARTCA (SerialWarrantyDates) as static
--  111215  GanNLK  In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  100430  Ajpelk  Merge rose method documentation
--  100120  MaMalk  Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120          in the business logic.
--  091006  ChFolk  Removed un used global constants and variables.
--  -------------------------------- 14.0.0 ---------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  040225  SaNalk  Removed SUBSTRB.
--  -----------------------Version 13.3.0-------------------------- ---------
--  040202  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  020604  ChFolk  Modified the serial_no length from 20 to 50 in the procedure, Copy.
--  **************** AV 2002-3 Baseline *************************************
--  010525  JSAnse  Bug 21463, Added call to General_SYS.Init_Method to Get_Objstate.
--  001117  PaLj    Changed method Copy. Made call to Serial_Warranty_Dates_API.Copy dynamic.
--  001115  PaLj    Changed method Copy. Added call to Serial_Warranty_Dates_API.Copy
--  001031  JoEd    Added method Remove.
--  001023  PaLj    Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SUP_WARRANTY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT warranty_id.nextval
   INTO newrec_.warranty_id
   FROM dual;
   Client_SYS.Add_To_Attr('WARRANTY_ID', newrec_.warranty_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Creates a new warranty and copies warranty types and conditions from
--   the old one.
PROCEDURE Copy (
   new_warranty_id_ IN OUT NUMBER,
   old_warranty_id_ IN     NUMBER,
   part_no_         IN     VARCHAR2,
   serial_no_       IN     VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   newrec_     SUP_WARRANTY_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;   
BEGIN
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   new_warranty_id_ := newrec_.warranty_id;
   Trace_SYS.Field('NEW WARRANTY_ID', new_warranty_id_);

   Sup_Warranty_Type_API.Copy(old_warranty_id_, new_warranty_id_);
   Sup_Warranty_Condition_API.Copy(old_warranty_id_, new_warranty_id_);
   IF serial_no_ IS NOT NULL AND part_no_ IS NOT NULL THEN
      -- Call to Serial_Warranty_Dates
      Serial_Warranty_Dates_API.Copy(old_warranty_id_, new_warranty_id_, part_no_, serial_no_);      
   END IF;
END Copy;


-- New
--   Creates a new warranty record and returns the new warranty id.
PROCEDURE New (
   warranty_id_ OUT NUMBER )
IS
   attr_       VARCHAR2(2000);
   newrec_     SUP_WARRANTY_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   warranty_id_ := newrec_.warranty_id;
END New;


-- Inherit
--   Sets the state to shared
PROCEDURE Inherit (
   warranty_id_ IN NUMBER )
IS
   rec_     SUP_WARRANTY_TAB%ROWTYPE;
   attr_    VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Lock_By_Keys___(warranty_id_);
   IF (rec_.rowstate = 'Unique') THEN
      Finite_State_Machine___(rec_, 'Inherit', attr_);
   END IF;
END Inherit;


-- Remove
--   Deletes a given warranty.
PROCEDURE Remove (
   warranty_id_ IN NUMBER )
IS
   remrec_     SUP_WARRANTY_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, warranty_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


