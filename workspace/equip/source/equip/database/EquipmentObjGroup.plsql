-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjGroup
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950711  JOSC    Created
--  950724  SLKO    Changes according to the new standard of the LU definition.
--  950821  NILA    Moved creation of view from script into package. Added
--                  comments of view.
--  950831  NILA    Added EXIT at end of file and modified procedure Exist not
--                  to validate NULL values.
--  951020  OYME    Recreated using Base Table to Logical Unit Generator UH-Special
--  960522  JOSC    Removed SYS4 dependencies and added call to Init_Method.
--  960918  CAJO    Generated from Rose-model using Developer's Workbench.
--  961106  ADBR    Upgraded to 1.2.2.
--  961219  ADBR    Merged with new templates.
--  970103  CAJO    Added attributes unit_code and nom_runtime.
--  970403  TOWI    Adjusted to new templates in Foundation 1.2.2c.
--  970409  TOWI    97-0012 Unit Code is now validated.
--  970731  JOSC    Added procedure Get_Control_Type_Value_Desc.
--  970815  NILA    Ref 97-0048: Added check on attribute NOM_RUNTIME not to be
--                  larger than 24 hours in procedures Unpack_Check_Insert/Update.
--  970919  CAJO    Converted to F1 2.0. Changed table name to equipment_obj_group_tab.
--  971016  ERJA    Changed ref=unit to iso_unit and unit_api to maintenance_unit_api.
--  971025  STSU    Added methods Check_Exist and Create_Obj_Group.
--  980615  CLCA    Changed prompt from 'Object Group' to 'Group ID' for group_id.
--  990113  MIBO    SKY.0208 AND SKY.0209 Removed all calls to Get_Instance___ in Get-statements.
--  981230  ANCE    Checked and updated 'Uppercase/Unformatted' (SKY.0206).
--  991221  RECASE  Changed template due to performance improvement.
--  000222  STEBSE  Added GROUP_ID_LOV.
--  010426  CHATLK  Added the General_SYS.Init_Method to PROCEDUR Get_Control_Type_Value_Desc.
--  010426  CHATLK  Changed the method name in General_SYS.Init_Method of PROCEDUR Create_Obj_Group.       
--  -------------------------Project Eagle-----------------------------------
--  090930  Hidilk  Task EAST-317 used correct reference in the column unit_code
--  091019  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  110430  NEKOLK  EASTONE-17408 :Removed the Objkey from the view EQUIPMENT_OBJ_GROUP_LO
--  131130  NEKOLK  PBSA-1819: Hooks: Refactored and split code.
--  ---------------------------- APPS 10 -------------------------------------
--  170830 sawalk STRSA-1046, Data Validity changes, Overridden method Raise_Record_Access_Blocked___ is added.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     equipment_obj_group_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY equipment_obj_group_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   
BEGIN
    super(oldrec_, newrec_, indrec_, attr_);
    IF ( newrec_.nom_runtime NOT BETWEEN 0 AND 24 ) THEN
      Error_SYS.Appl_General(lu_name_, 'RUN2LARGE: Nominal Runtime must be between 0 and 24 hours.');
   END IF;
END Check_Common___;

@Override
PROCEDURE Raise_Record_Access_Blocked___ (
    group_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Access_Blocked(lu_name_, 'ACCESSBLOCKED: Group Id :P1 is blocked for use.', group_id_);
   super(group_id_);
END Raise_Record_Access_Blocked___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Get_Description (
   description_ OUT VARCHAR2,
   group_id_    IN  VARCHAR2 )
IS
   temp_ EQUIPMENT_OBJ_GROUP_TAB.descr%TYPE;
   CURSOR get_attr IS
      SELECT descr
      FROM EQUIPMENT_OBJ_GROUP_TAB
      WHERE descr = description_
      AND group_id = group_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   description_ := temp_;
END Get_Description;


PROCEDURE Get_Control_Type_Value_Desc (
   description_        OUT VARCHAR2,
   company_            IN VARCHAR2,
   control_type_value_ IN VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(control_type_value_);
END Get_Control_Type_Value_Desc;


PROCEDURE Create_Obj_Group (
   group_id_    IN VARCHAR2,
   description_ IN VARCHAR2,
   unit_code_   IN VARCHAR2,
   nom_runtime_ IN NUMBER )
IS
   newrec_      equipment_obj_group_tab%ROWTYPE;
BEGIN
   newrec_.group_id     := group_id_;
   newrec_.descr        := description_;
   newrec_.unit_code    := unit_code_;
   newrec_.nom_runtime  := nom_runtime_;
   New___(newrec_);
END Create_Obj_Group;


@UncheckedAccess
FUNCTION Check_Exist (
   group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(group_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;



