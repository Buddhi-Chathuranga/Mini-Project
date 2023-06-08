-----------------------------------------------------------------------------
--
--  Logical unit: PackInstrNodeAccessory
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-- 180614   SWiclk   SCUXXW4-12210, Added Accessory_Exist_Db() and modified Accessory_Exist() to call Accessory_Exist_Db().
-- 130223   MeAblk   Added new method Add_Accesories_To_Handl_Unit.
-- 130211   MeAblk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Quantity___  (
   quantity_                   IN NUMBER,
   handling_unit_accessory_id_ IN VARCHAR2   )
IS
   unit_code_ VARCHAR2(30);
   unit_type_ VARCHAR2(10);
BEGIN
   IF (quantity_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'ACCESSORYQTYFORMAT: Quantity must be greater than zero.');     
   ELSIF (quantity_ != ROUND(quantity_)) THEN
      unit_code_ := Handling_Unit_Accessory_API.Get_Unit_Code(handling_unit_accessory_id_);
      unit_type_ := Iso_Unit_API.Get_Unit_Type(unit_code_); 
      IF (unit_type_ = Iso_Unit_Type_API.Decode(Iso_Unit_Type_API.DB_DISCRETE)) THEN
         Error_SYS.Record_General(lu_name_, 'ACCESSORYDISCREETQTYFORMAT: Quantity must be a positive integer when the UoM is discrete.');      
      END IF;         
   END IF;      
END  Check_Quantity___;  


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pack_instr_node_accessory_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Check_Quantity___(newrec_.quantity, newrec_.handling_unit_accessory_id);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     pack_instr_node_accessory_tab%ROWTYPE,
   newrec_ IN OUT pack_instr_node_accessory_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.quantity != oldrec_.quantity) THEN
      Check_Quantity___(newrec_.quantity, newrec_.handling_unit_accessory_id);
   END IF;   
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Accessory_Exist (
   packing_instruction_id_ IN VARCHAR2,
   node_id_ IN NUMBER ) RETURN VARCHAR2
IS     
BEGIN   
   RETURN  Fnd_Boolean_API.Decode(Accessory_Exist_Db(packing_instruction_id_, node_id_));    
END  Accessory_Exist;

@UncheckedAccess
FUNCTION Accessory_Exist_Db (
   packing_instruction_id_ IN VARCHAR2,
   node_id_ IN NUMBER ) RETURN VARCHAR2
IS
   accessory_exist_ VARCHAR2(25) := Fnd_Boolean_API.DB_FALSE;
   dummy_ NUMBER;
   CURSOR check_accessory IS
      SELECT 1
      FROM PACK_INSTR_NODE_ACCESSORY_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   node_id = node_id_;
BEGIN
   OPEN check_accessory;
   FETCH check_accessory INTO dummy_;
   IF (check_accessory%FOUND) THEN
      accessory_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;  
   CLOSE check_accessory;
   RETURN  accessory_exist_;    
END  Accessory_Exist_Db;

PROCEDURE Add_Accesories_To_Handl_Unit (
   packing_instruction_id_ IN  VARCHAR2,
   node_id_                IN  NUMBER,
   handling_unit_id_       IN  NUMBER )
IS
CURSOR get_accessories IS
      SELECT  handling_unit_accessory_id, quantity
      FROM  PACK_INSTR_NODE_ACCESSORY_TAB
      WHERE packing_instruction_id = packing_instruction_id_
      AND   node_id                =  node_id_;
BEGIN
   FOR rec_ IN get_accessories LOOP
      Accessory_On_Handling_Unit_API.New(handling_unit_id_, rec_.handling_unit_accessory_id, rec_.quantity);
   END LOOP;
END Add_Accesories_To_Handl_Unit;



