-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjType
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950529  NILA  Created.
--  950724  SLKO  Changes according to the new standard of the LU definition.
--  950822  TOWI  Moving in the body for the view after viewgen and padding
--                objversion to 255 charachters.
--                Moving in viewcomments after running script viewcomm.
--  950825  TOWI  Adding function Get_Description
--  950831  NILA  Added EXIT at end of file and modified procedure Exist not
--                to validate NULL values.
--  951020  OYME  Recreated using Base Table to Logical Unit Generator UH-Special
--  960520  JOSC  Added INIT procedure.
--  960522  JOSC  Removed SYS4 dependencies and added call to Init_Method.
--  960920  ADBR  Created from Rose model using Developer's Workbench.
--  961106  ADBR  Upgraded to 1.2.2.
--  961219  ADBR  Merged with new templates.
--  970114  CAJO  Added check in Unpack_Check_Insert and Unpack_Check_Update
--                so that In Object Type cannot be the same as Object Type.
--  970402  CAJO  Adjusted to new templates in Foundation1 1.2.2C.
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_obj_type_tab.
--  971025  STSU  Added methods Check_Exist and Create_Obj_Type.
--  980120  ADBR  Added attribute Icon_File_Name.
--  991005  OSRY  Changed mch_type and in_mch_type from 5 to 20 characters.
--  991227  ANCE  Changed template due to performance improvement.
--  000221  STEBSE   Added Mch_Type_LOV.  
--  -------------------------Project Eagle-----------------------------------
--  091019  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  110430  NEKOLK  EASTONE-17408 :Removed the Objkey from the view EQUIPMENT_OBJ_TYPE_LOV 
-----------------------------------------------------------------------------
--  130118  LoPrlk  Task: NINESA-253, Added the attribute item_class_id to the LU.
--  130916  MAWILK  BLACK-566, Replaced Component_Pcm_SYS
--  131130  NEKOLK PBSA-1820: Hooks: refactored and split code
--  ---------------------------- APPS 10 -------------------------------------
--  170829  japelk  Data Validity changes, Overridden method Raise_Record_Access_Blocked___ is added.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_obj_type_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY equipment_obj_type_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
  super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.in_mch_type IS NOT NULL) THEN
      IF newrec_.mch_type = newrec_.in_mch_type THEN
         Error_SYS.Appl_General(lu_name_, 'EQOBJTYPE: In Object Type cannot be the same as Object Type.');
      END IF;
   END IF;
 
END Check_Common___;


@Override
PROCEDURE Raise_Record_Access_Blocked___ (
    mch_type_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Access_Blocked(lu_name_, 'ACCESSBLOCKED: Object Type :P1 is blocked for use.', mch_type_);
   super(mch_type_);
END Raise_Record_Access_Blocked___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   mch_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(mch_type_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE Create_Obj_Type (
   mch_type_    IN VARCHAR2,
   description_ IN VARCHAR2,
   in_mch_type_ IN VARCHAR2 )
IS
   newrec_      EQUIPMENT_OBJ_TYPE_TAB%ROWTYPE;
BEGIN
   newrec_.mch_type    := mch_type_;
   newrec_.descr       := description_;
   newrec_.in_mch_type := in_mch_type_;
   New___(newrec_);
END Create_Obj_Type;

FUNCTION Has_Technical_Spec_No(
   mch_type_ IN VARCHAR2) RETURN VARCHAR2 
IS
   key_ref_mch_type_ VARCHAR2(2000);
BEGIN
   key_ref_mch_type_ :=  CLIENT_SYS.Get_Key_Reference('EquipmentObjType','MCH_TYPE',mch_type_);  
   IF TECHNICAL_OBJECT_REFERENCE_API.Get_Technical_Spec_No (lu_name_, key_ref_mch_type_ ) = '-1' THEN
      RETURN ('FALSE');
   ELSE
      RETURN ('TRUE');
   END IF;      
END Has_Technical_Spec_No;

