-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartCapability
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210125  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  111102  MaEelk   Added UIV INVENTORY_PART_OPER_CAP_UIV.
--  110720  MaEelk   Added used allowed site filter to INV_PART_OP_CAP_OVERVIEW
--  110708  MaEelk   Added user allowed site filter to INVENTORY_PART_CAPABILITY.
--  110608  MaEelk   Removed the ambiguity problem of source in INVENTORY_PART_OPERATIVE_CAP
--  110523  MaEelk   Removed the cascade option from INVENTORY_PART_CAPABILITY.storage_capability_id.
--  101022  JeLise   Added Copy.
--  100928  DaZase   Added INV_PART_OP_CAP_OVERVIEW.
--  100819  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('REMOVED', Fnd_Boolean_API.Decode('FALSE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_capability_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT indrec_.removed THEN 
      newrec_.removed := 'FALSE';
   END IF;   
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Removed_Line__ (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   storage_capability_id_ IN VARCHAR2 )
IS
   newrec_        inventory_part_capability_tab%ROWTYPE;
BEGIN

   IF (Check_Exist___(contract_, part_no_, storage_capability_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'CAPLINEEXIST: You cannot remove this capability because it already exists on this level, please remove the capability on this level first');
   END IF;

   newrec_.contract              := contract_;
   newrec_.part_no               := part_no_;
   newrec_.storage_capability_id := storage_capability_id_;
   newrec_.removed               := Fnd_Boolean_API.DB_TRUE;
   New___(newrec_);
END Create_Removed_Line__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Copy (
   new_contract_ IN VARCHAR2,
   new_part_no_  IN VARCHAR2,
   old_contract_ IN VARCHAR2,
   old_part_no_  IN VARCHAR2 )
IS
   CURSOR    get_capability_lines IS
      SELECT *
        FROM inventory_part_capability_tab
       WHERE contract = old_contract_
         AND part_no = old_part_no_;
BEGIN

   FOR capability_rec_ IN get_capability_lines LOOP
      capability_rec_.contract := new_contract_;
      capability_rec_.part_no  := new_part_no_;
      New___(capability_rec_);
   END LOOP;
END Copy;


@UncheckedAccess
FUNCTION Get_Operative_Capabilities (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN Storage_Capability_API.Capability_Tab
IS
   capability_tab_ Storage_Capability_API.Capability_Tab;

   CURSOR get_capabilities IS
      SELECT storage_capability_id
      FROM inventory_part_operative_cap
      WHERE contract = contract_
      AND   part_no  = part_no_;
BEGIN
   OPEN get_capabilities;
   FETCH get_capabilities BULK COLLECT INTO capability_tab_;
   CLOSE get_capabilities;
   
   RETURN (capability_tab_);
END Get_Operative_Capabilities;



