-----------------------------------------------------------------------------
--
--  Logical unit: FormulaItemVariable
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180524  HuBaUK SAUXXW4-7279, Added new function Get_Null_Test_Value_Count
--  040712  SaJjlk Added more checks to Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040701  JaJalk Modified the method Unpack_Check_Update___.
--  040625  JaJalk Added the field test_value.
--  040615  JaJalk Added the methods Create_Formula_Item_Variable__ and Remove_Variable__.
--  040604  HeWelk Created.
--  091218  Kanslk Reverse-Engineering, modified view by adding reference to formula_item_id. 
--  ----------------------------Eagle------------------------------------------
--  100421  Ajpelk Merge rose method documentatio
--  -------------------------- APPS 9 ---------------------------------------
--  131120  paskno  Hooks: refactoring and splitting.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FORMULA_ITEM_VARIABLE_TAB%ROWTYPE,
   newrec_     IN OUT FORMULA_ITEM_VARIABLE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (Formula_API.Get_Obj_State(newrec_.formula_id) = 'Valid') THEN
      Error_SYS.Record_General(lu_name_,'NO_MOD_ALLOWED: Valid formulas can not be modified.');
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT formula_item_variable_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.value_source = 'FIXED') THEN
      newrec_.test_value:=newrec_.variable_value;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     formula_item_variable_tab%ROWTYPE,
   newrec_ IN OUT formula_item_variable_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.value_source = 'USER' AND newrec_.variable_value IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_,'NO_VALUE_ALLOWED: Value can not be specified for the value type User.');
   ELSIF (newrec_.value_source != 'USER' AND newrec_.variable_value IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'VALUE_MANDATE: The field Value must have a value for default and fixed value types.');
   ELSIF (indrec_.test_value = TRUE AND indrec_.variable_value = FALSE) THEN  
      IF (oldrec_.value_source = 'FIXED' ) THEN
          IF (newrec_.test_value!=oldrec_.test_value) THEN
             Error_SYS.Record_General(lu_name_,'NOCHANGETOFIX: Test value  cannot be changed for the value type Fixed.');
          END IF; 
      END IF;
   ELSIF (indrec_.test_value = TRUE AND indrec_.variable_value = TRUE) THEN  
      IF (oldrec_.value_source = 'FIXED' ) THEN
          IF (newrec_.test_value!=newrec_.variable_value) THEN
             Error_SYS.Record_General(lu_name_,'NOCHANGETOFIX: Test value  cannot be changed for the value type Fixed.');
          END IF;
      END IF;
   ELSIF (newrec_.value_source = 'FIXED' AND newrec_.variable_value IS NOT NULL) THEN
      newrec_.test_value:=newrec_.variable_value;
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Formula_Item_Variable__
--   Inserts a new record when a variable type is selected from the formula item.
--   It will not insert duplicate types as well
PROCEDURE Create_Formula_Item_Variable__ (
   formula_id_      IN VARCHAR2,
   formula_item_id_ IN NUMBER,
   variable_id_     IN VARCHAR2 )
IS
   attr_            VARCHAR2(32000);
   indrec_          Indicator_Rec;
   newrec_          FORMULA_ITEM_VARIABLE_TAB%ROWTYPE;
   objid_           FORMULA_ITEM_VARIABLE.objid%TYPE;
   objversion_      FORMULA_ITEM_VARIABLE.objversion%TYPE;
   dummy_           NUMBER;
   CURSOR get_var_rec IS
      SELECT 1 FROM
             FORMULA_ITEM_VARIABLE_TAB
      WHERE formula_id = formula_id_
      AND   variable_id = variable_id_;
BEGIN
   OPEN get_var_rec;
   FETCH get_var_rec INTO dummy_;
   IF (get_var_rec%FOUND) THEN
      CLOSE get_var_rec;
   ELSE
      CLOSE get_var_rec;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('FORMULA_ID', formula_id_, attr_);
      Client_SYS.Add_To_Attr('FORMULA_ITEM_ID', formula_item_id_, attr_);
      Client_SYS.Add_To_Attr('VARIABLE_ID', variable_id_, attr_);
      Client_SYS.Add_To_Attr('VALUE_SOURCE', Formula_Var_Value_Source_API.Decode('USER'), attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Create_Formula_Item_Variable__;


-- Remove_Variable__
--   Removes records if the formula item has only one exist as the master for
--   the corresponding item type since insert from the formula item restricts
--   the duplicate types.
PROCEDURE Remove_Variable__ (
   formula_id_  IN VARCHAR2,
   variable_id_ IN VARCHAR2 )
IS
   CURSOR get_version IS
      SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      FROM   FORMULA_ITEM_VARIABLE_TAB
      WHERE  formula_id = formula_id_
      AND    variable_id = variable_id_;
   remrec_   FORMULA_ITEM_VARIABLE_TAB%ROWTYPE;
   objid_         FORMULA_ITEM_VARIABLE.objid%TYPE;
   objversion_    FORMULA_ITEM_VARIABLE.objversion%TYPE;
BEGIN
   OPEN get_version;
   FETCH get_version INTO objid_, objversion_;
   CLOSE get_version;
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Variable__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Test_Value
--   Retuns the test value of a given variable type.
@UncheckedAccess
FUNCTION Get_Test_Value (
   formula_id_  IN VARCHAR2,
   variable_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ FORMULA_ITEM_VARIABLE_TAB.test_value%TYPE;
   CURSOR get_attr IS
      SELECT test_value
      FROM FORMULA_ITEM_VARIABLE_TAB
      WHERE formula_id = formula_id_
      AND   variable_id = variable_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;

END Get_Test_Value;


-- Get_Null_Test_Value_Count
--   Returns the count for a formula where test_value is null.
@UncheckedAccess
FUNCTION Get_Null_Test_Value_Count (
   formula_id_  IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_records_ NUMBER;
   CURSOR get_count IS
      SELECT count(*)
      FROM FORMULA_ITEM_VARIABLE_TAB
      WHERE formula_id = formula_id_
      AND   test_value IS NULL;
BEGIN
   OPEN get_count;
   FETCH get_count INTO no_of_records_;
   CLOSE get_count;
   RETURN no_of_records_;
END Get_Null_Test_Value_Count ;
