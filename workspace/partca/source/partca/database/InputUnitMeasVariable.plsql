-----------------------------------------------------------------------------
--
--  Logical unit: InputUnitMeasVariable
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201218  SBalLK  Issue SC2020R1-11830, removed Create_Uom_Item__() and added Create_Uom_Item() method by removing packing,
--  201218          unpacking functionality to optimize the performance.
--  100423  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  050125  SaJjlk Removed unused method Test_Formula.
--  040722  JaJalk Modified the method Unpack_Check_Update___.
--  040709  SaJjlk Changed properties of Unit_Code to perform Cascade delete
--  040705  JaJalk Corrected some unit test bugs.
--  040618  JaJalk Added the method Create_Uom_Item__.
--  040607  DaRulk Minor Changes.
--  040607  DaRulk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     input_unit_meas_variable_tab%ROWTYPE,
   newrec_ IN OUT input_unit_meas_variable_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.value_source = 'USER' AND newrec_.variable_value IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_,'NO_VALUE_ALLOWED: Value cannot be specified for the value type User.');
   END IF;

END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Uom_Item
--   Calls from InputUnitMeas to inserts variable records if the formula
--   contains any variable.
PROCEDURE Create_Uom_Item(
   input_unit_meas_group_id_ IN VARCHAR2,
   unit_code_                IN VARCHAR2,
   formula_id_               IN VARCHAR2,
   formula_item_id_          IN NUMBER,
   variable_id_              IN VARCHAR2,
   variable_value_           IN NUMBER,
   value_source_db_          IN VARCHAR2 )
IS
   newrec_          INPUT_UNIT_MEAS_VARIABLE_TAB%ROWTYPE;
BEGIN
   newrec_.input_unit_meas_group_id := input_unit_meas_group_id_;
   newrec_.unit_code                := unit_code_;
   newrec_.formula_id               := formula_id_;
   newrec_.formula_item_id          := formula_item_id_;
   newrec_.variable_id              := variable_id_;
   newrec_.variable_value           := variable_value_;
   newrec_.value_source             := value_source_db_;
   New___(newrec_);
END Create_Uom_Item;

-- Remove
--   Deletes the variable item if the formula changed.
PROCEDURE Remove (
   input_unit_meas_group_id_ IN VARCHAR2,
   unit_code_                IN VARCHAR2,
   formula_id_               IN VARCHAR2 )
IS
   remrec_     INPUT_UNIT_MEAS_VARIABLE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR rem_rec IS
      SELECT *
      FROM INPUT_UNIT_MEAS_VARIABLE_TAB
      WHERE input_unit_meas_group_id = input_unit_meas_group_id_
      AND   unit_code = unit_code_
      AND   formula_id = formula_id_;
BEGIN

   OPEN rem_rec;
   FETCH rem_rec INTO remrec_;
   CLOSE rem_rec;

   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             remrec_.input_unit_meas_group_id,
                             remrec_.unit_code,
                             remrec_.formula_id,
                             remrec_.formula_item_id,
                             remrec_.variable_id );
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;



