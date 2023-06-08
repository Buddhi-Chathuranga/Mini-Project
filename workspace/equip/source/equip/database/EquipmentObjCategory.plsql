-----------------------------------------------------------------------------
--
--  Logical unit: EquipmentObjCategory
--  Component:    EQUIP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950802  SLKO  Created.
--  950823  STOL  Moved creation of view from script into package.
--                Added comments on view.
--  950831  NILA  Added EXIT at end of file and modified procedure Exist not
--                to validate NULL values.
--  951020  OYME  Recreeated using Base Table to Logical Unit Generator UH-Special
--  960917  CAJO  Generated from Rose-model using Developer's Workbench.
--  961005  TOWI  Recreated from Rose model using Developer's Workbench 1.2.2
--  961219  ADBR  Merged with new templates.
--  970401  TOWI  Adjusted to new templates in Foundation1 1.2.2c.
--  970919  CAJO  Converted to F1 2.0. Changed table name to equipment_obj_category_tab.
--  971024  STSU  Added methods Check_Exist and Create_Category_Id
--  990112  MIBO  SKY.0208 and SKY.0209 Performance issues in Maintenance 5.4.0.
--  991215  PJONSE Changed template due to performance improvement.
--  000222  STEBSE   Added EQUIP_OBJ_CATEGORY_LOV
--  -------------------------Project Eagle-----------------------------------
--  091016  LoPrlk  EAME-182: Remove unused internal variables in EQUIP.
--  110430  NEKOLK  EASTONE-17408 :Removed the Objkey from the view EQUIPMENT_SERIAL_HISTOR
--  131127  MAWILK PBSA-1807, Hooks: refactoring and splitting.
--  ---------------------------- APPS 10 -------------------------------------
--  170830 sawalk STRSA-1045, Data Validity changes, Overridden method Raise_Record_Access_Blocked___ is added.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Raise_Record_Access_Blocked___ (
    category_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Access_Blocked(lu_name_, 'ACCESSBLOCKED: Category Id :P1 is blocked for use.', category_id_);
   super(category_id_);
END Raise_Record_Access_Blocked___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Check_Exist (
   category_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(category_id_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


PROCEDURE Create_Category_Id (
   category_id_ IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
   newrec_      EQUIPMENT_OBJ_CATEGORY_TAB%ROWTYPE;
BEGIN
   newrec_.category_id := category_id_;
   newrec_.descr := description_;
   New___(newrec_);
END Create_Category_Id;



