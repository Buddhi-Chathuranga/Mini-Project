-----------------------------------------------------------------------------
--
--  Logical unit: CustWarranty
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151106  HimRlk  Bug 123910, Added new method Copy_Cust_Warranty.
--  120213  HaPulk  Changed dynamic code to PARTCA (PartSerialCatalog/SerialWarrantyDates) as static
--  111215  GanNLK  In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  100429  Ajpelk  Merge rose method documentation
--  100120  MaMalk  Added global lu constants to replace the calls to Transaction_SYS.Logical_Unit_Is_Installed
--  100120          in the business logic.
--  091005  ChFolk  Removed unused global constants and variables.
--  ---------------------------- 14.0.0 -------------------------------------
--  060123  JaJalk  Added Assert safe annotation.
--  060112  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060112          and added UNDEFINE according to the new template.
--  040223  SaNalk  Removed SUBSTRB.
--  040202  GeKalk  Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  --------------------------------- 13.3.0 --------------------------------
--  020604  ChFolk  Modify the length of serial_no from 20 to 50 in dynamic calls.
--  *********************** AV 2002-3 Baseline ******************************
--  010525  JSAnse  Bug 21463, Added call to General_SYS.Init_Method for Get_Objstate.
--  001117  PaLj    Changed method Copy. Made call to Serial_Warranty_Dates_API.Copy dynamic.
--                  Added method Merge
--  001115  PaLj    Changed method Copy. Added call to Serial_Warranty_Dates_API.Copy
--  001106  PaLj    Changed method Inherit.
--  001101  JoEd    Remove method Check_Differences.
--  001031  JoEd    Added methods Check_Differences and Remove.
--  001027  PaLj    Changed method Copy_From_Sup_Warranty
--  001025  PaLj    added method Copy_From_Sup_Warranty
--  001020  PaLj    Added method Inherit
--  001018  JoEd    Added method New.
--  001017  JoEd    Added method Get_Objstate and Copy.
--  001010  PaLj    Created
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
   newrec_     IN OUT CUST_WARRANTY_TAB%ROWTYPE,
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
--   Creates a new warranty and copies all warranty types and conditions
--   from the old warranty.
PROCEDURE Copy (
   new_warranty_id_ IN OUT NUMBER,
   old_warranty_id_ IN     NUMBER,
   part_no_         IN     VARCHAR2,
   serial_no_       IN     VARCHAR2 )

IS
   attr_       VARCHAR2(2000);
   newrec_     CUST_WARRANTY_TAB%ROWTYPE;
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

   Cust_Warranty_Type_API.Copy(old_warranty_id_, new_warranty_id_);
   Cust_Warranty_Condition_API.Copy(old_warranty_id_, new_warranty_id_);
   Warranty_Lang_Desc_API.Copy(old_warranty_id_, new_warranty_id_);
   -- Call to Serial_Warranty_Dates
   IF serial_no_ IS NOT NULL AND part_no_ IS NOT NULL THEN
      Serial_Warranty_Dates_API.Copy(old_warranty_id_, new_warranty_id_, part_no_, serial_no_);      
   END IF;
END Copy;

-----------------------------------------------------------------------------
-- Copy_Cust_Warranty
--  Copy all customer warranty types and conditions from the source to the destination.
--    If the customer warranty at the destination is a Shared warranty, then creates a new warranty and copy
--    both source and destination customer warranty types and conditions to the new one.
--    If the customer warranty at the destination is a Unique one then copy source warranty types and conditions 
--    to the current warranty at the destination.
--    Both souce warranty_id and destination warranty_id must have values in order to merge the two warranties.
-----------------------------------------------------------------------------
PROCEDURE Copy_Cust_Warranty (
   new_warranty_id_          IN OUT NUMBER,
   source_warranty_id_       IN     NUMBER,
   destination_warranty_id_  IN     NUMBER,
   error_when_no_source_     IN     VARCHAR2,
   error_when_existing_copy_ IN     VARCHAR2 )
IS 
   state_      CUST_WARRANTY_TAB.rowstate%TYPE;   
BEGIN
   
   IF (Check_Exist___(source_warranty_id_)) THEN
      Exist(destination_warranty_id_);
      state_ := Get_Objstate(destination_warranty_id_);
      IF (state_ = 'Shared') THEN
         -- If the warranty is Shared then create a new one and copy all the source warranty details
         Copy(new_warranty_id_, source_warranty_id_, NULL, NULL);
         -- Copy the destination warranty details to the new warranty
         Cust_Warranty_Type_API.Copy(destination_warranty_id_, new_warranty_id_, error_when_no_source_, error_when_existing_copy_);
         Cust_Warranty_Condition_API.Copy(destination_warranty_id_, new_warranty_id_, error_when_no_source_, error_when_existing_copy_);
         Warranty_Lang_Desc_API.Copy(destination_warranty_id_, new_warranty_id_, error_when_no_source_, error_when_existing_copy_);
      ELSE
         -- If the warranty is Unique then add source warranty details to the destination
         new_warranty_id_ := destination_warranty_id_;
         -- Copy the source warranty details to the destination warranty
         Cust_Warranty_Type_API.Copy(source_warranty_id_, new_warranty_id_, error_when_no_source_, error_when_existing_copy_);
         Cust_Warranty_Condition_API.Copy(source_warranty_id_, new_warranty_id_, error_when_no_source_, error_when_existing_copy_);
         Warranty_Lang_Desc_API.Copy(source_warranty_id_, new_warranty_id_, error_when_no_source_, error_when_existing_copy_);
      END IF;      
   ELSE
      IF (error_when_no_source_ = 'TRUE') THEN        
         Error_SYS.Record_Not_Exist(lu_name_, 'CUSWARNOTEXIST: Customer warranty does not exist.');
      END IF;
   END IF;
END Copy_Cust_Warranty;

-- New
--   Creates a new warranty record. Since no other attributes than
--   warranty id is needed (and it's also created from a sequence),
--   the new warranty id is returned.
PROCEDURE New (
   warranty_id_ OUT NUMBER )
IS
   attr_       VARCHAR2(2000);
   newrec_     CUST_WARRANTY_TAB%ROWTYPE;
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
   rec_     CUST_WARRANTY_TAB%ROWTYPE;
   attr_    VARCHAR2(2000);
BEGIN
   IF warranty_id_ IS NOT NULL THEN
      Client_SYS.Clear_Attr(attr_);
      rec_ := Lock_By_Keys___(warranty_id_);
      IF (rec_.rowstate = 'Unique') THEN
         Finite_State_Machine___(rec_, 'Inherit', attr_);
      END IF;
   END IF;
END Inherit;


PROCEDURE Copy_From_Sup_Warranty (
   cust_warranty_id_ IN OUT NUMBER,
   sup_warranty_id_  IN     NUMBER )
IS
   attr_       VARCHAR2(2000);
   newrec_     CUST_WARRANTY_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   old_cust_warranty_id_ NUMBER;
   cust_warranty_state_ VARCHAR2(20);
   indrec_              Indicator_Rec;
BEGIN
   IF cust_warranty_id_ IS NULL THEN
      -- No old customer warranty exist
      Prepare_Insert___(attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      cust_warranty_id_ := newrec_.warranty_id;
      Trace_SYS.Field('NEW CUST_WARRANTY_ID', cust_warranty_id_);
      Cust_Warranty_Type_API.Copy_From_Sup_Warranty(sup_warranty_id_, cust_warranty_id_);
      Cust_Warranty_Condition_API.Copy_From_Sup_Warranty(sup_warranty_id_, cust_warranty_id_);
   ELSE
      -- There is already a cust_warranty_id
      Trace_SYS.Field('Old Cust WARRANTY_ID', cust_warranty_id_);
      -- Check state of warranty_id
      cust_warranty_state_ := Get_Objstate(cust_warranty_id_);
      IF (cust_warranty_state_ = 'Shared') THEN
         -- copy cust_warranty_id to old_cust_warranty_id
         old_cust_warranty_id_ := cust_warranty_id_;
         -- Create new warranty_id
         Prepare_Insert___(attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
         -- Get the new cust_warranty_id, the old may not be changed
         cust_warranty_id_ := newrec_.warranty_id;
         Trace_SYS.Field('new WARRANTY_ID', cust_warranty_id_);
         -- Copy from old types to new types
         Cust_Warranty_Type_API.Copy(old_cust_warranty_id_, cust_warranty_id_);
         -- Copy from sup types to new cust types
         Cust_Warranty_Type_API.Copy_From_Sup_Warranty(sup_warranty_id_, cust_warranty_id_);
         -- Copy from old conditions to new conditions
         Cust_Warranty_Condition_API.Copy(old_cust_warranty_id_, cust_warranty_id_);
         -- Copy from sup conditions to new conditions
         Cust_Warranty_Condition_API.Copy_From_Sup_Warranty(sup_warranty_id_, cust_warranty_id_);
      ELSE
         -- IF state unique just add the warranty types and conditions from sup to the existing cust
         Cust_Warranty_Type_API.Copy_From_Sup_Warranty(sup_warranty_id_, cust_warranty_id_);
         Cust_Warranty_Condition_API.Copy_From_Sup_Warranty(sup_warranty_id_, cust_warranty_id_);
      END IF;
   END IF;
END Copy_From_Sup_Warranty;


-- Remove
--   Removes a warranty including all its details.
PROCEDURE Remove (
   warranty_id_ IN NUMBER )
IS
   remrec_     CUST_WARRANTY_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, warranty_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Merge
--   This procedure will merge the warrantys. If the types are equal, the type from
--   the cust warranty on PartSerialCatalog will be deleted and the type from COL
--   will replace it. IF the cust warranty on PartSerialCatalog is inherited
--   a new warranty_id must be created
PROCEDURE Merge (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   cust_warranty_id_ IN NUMBER,
   serial_cust_warranty_id_ IN NUMBER )

IS
   new_cust_warranty_id_ NUMBER;   
BEGIN
   IF (Cust_Warranty_API.Get_Objstate(serial_cust_warranty_id_) = 'Shared') THEN
         -- IF shared a new id must be created
         Cust_Warranty_API.NEW(new_cust_warranty_id_);
         -- Copy all types from serial_cust_warranty_id_ to new_cust_warranty_id_
         Cust_Warranty_API.Copy(new_cust_warranty_id_, serial_cust_warranty_id_, part_no_, serial_no_);
         -- Merge: Add the types from warranty_id to the new_cust_warranty_id_
         Cust_Warranty_Type_API.Merge(cust_warranty_id_, new_cust_warranty_id_);
         -- Set the new warranty_id to the tracked part
         Part_Serial_Catalog_API.Set_Cust_Warranty(part_no_, serial_no_, new_cust_warranty_id_);         
   ELSE
         -- Merge: Add the types from warranty_id to the serial_cust_warranty_id_
         Cust_Warranty_Type_API.Merge(cust_warranty_id_, serial_cust_warranty_id_);
   END IF;
END Merge;


