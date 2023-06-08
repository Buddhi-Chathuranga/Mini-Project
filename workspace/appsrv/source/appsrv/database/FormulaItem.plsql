-----------------------------------------------------------------------------
--
--  Logical unit: FormulaItem
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131206  paskno  PBSA-2961, corrected in Insert_Formula_Item_Variable.
--  131129  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  100421  Ajpelk Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  051028  NuFilk Added new method Insert_Formula_Item_Variable.
--  040909  SaJjlk Modified the view definition to include a CASE statement.
--                 Due to the case statement red code will appear when file is opened in IFSDesign.
--  040903  SaJjlk Modified code to store the encoded operator values.
--  040817  JaJalk Modified the method Get_Previous_Values.
--  040816  JaJalk Modified the method Get_Previous_Values.
--  040813  DaRulk Added new column notes.
--  040810  JaJalk Modified the method Get_Previous_Values.
--  040809  JaJalk Modified the method Get_Previous_Values.
--  040809  SaJjlk Added a new parameter to Get_Previous_Values
--  040804  JaJalk modified the method Validate_Formula_Items___ to handle the numbers.
--  040715  SaJjlk Modified method Get_Item_Var_Count__.
--  040625  JaJalk Removed field test_value.
--  040621  SaJjlk Added method Get_Previous_Values
--  040615  JaJalk Added the method Get_Item_Var_Count__.
--  040614  JaJalk Implementhed the methods Validate_Formula_Items___ and Validate_Item_Sequence___.
--  040604  HeWelk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Validate_Item_Sequence___
--   Checks against the duplicate sequence numbers, since user is allowed to
--   enter any number.
PROCEDURE Validate_Item_Sequence___ (
   formula_id_            IN VARCHAR2,
   formula_item_sequence_ IN NUMBER )
IS
   dummy_   NUMBER;
   CURSOR get_squence IS
   SELECT 1
      FROM FORMULA_ITEM_TAB
      WHERE formula_item_sequence = formula_item_sequence_
      AND formula_id = formula_id_;

BEGIN
   OPEN get_squence;
   FETCH get_squence INTO dummy_;
   IF (get_squence%FOUND) THEN
      CLOSE get_squence;
      Error_SYS.Record_Exist(lu_name_, 'SEQUENCEEXIST: Sequence :P1 already exist.',formula_item_sequence_);
   END IF;
   CLOSE get_squence;
END Validate_Item_Sequence___;


-- Validate_Formula_Items___
--   Checks the user entered items according to the item type with the
--   corresponding IID's
PROCEDURE Validate_Formula_Items___ (
   item_type_ IN VARCHAR2,
   item_      IN VARCHAR2 )
IS
   dummy_     NUMBER;
   name_      VARCHAR2(30);
BEGIN
   IF (item_type_ = 'OPERATOR') THEN
      Arithmetic_Operator_API.Exist_Db(item_);
   ELSIF (item_type_ = 'FUNCTION') THEN
      Number_Function_API.Exist_Db(item_);
   ELSIF (item_type_ = 'FORMULA') THEN
      Formula_API.Exist(item_);
   ELSIF (item_type_ = 'VARIABLE') THEN
      Formula_Variable_API.Exist(item_);
   ELSE
      name_ := 'ITEM';
      dummy_ := Client_SYS.Attr_Value_To_Number(item_);
   END IF;
 EXCEPTION
   WHEN INVALID_NUMBER THEN
      Error_SYS.Item_Format(lu_name_, name_, item_);
END Validate_Formula_Items___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FORMULA_ITEM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   formula_item_id_ NUMBER;
   CURSOR get_item_id IS
      SELECT MAX(formula_item_id)
      FROM FORMULA_ITEM_TAB WHERE formula_id = newrec_.formula_id;
BEGIN
   OPEN  get_item_id;
   FETCH get_item_id INTO formula_item_id_;
   CLOSE get_item_id;
   newrec_.formula_item_id := NVL(formula_item_id_,1)+1;
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.item_type = 'VARIABLE') THEN
      Formula_Item_Variable_API.Create_Formula_Item_Variable__(newrec_.formula_id,
                                                             newrec_.formula_item_id,
                                                             newrec_.item );
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FORMULA_ITEM_TAB%ROWTYPE,
   newrec_     IN OUT FORMULA_ITEM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.item_type = 'VARIABLE') THEN
      Formula_Item_Variable_API.Create_Formula_Item_Variable__(newrec_.formula_id,
                                                               newrec_.formula_item_id,
                                                               newrec_.item );
   END IF;
   IF (Formula_API.Get_Obj_State(newrec_.formula_id) = 'Valid') THEN
      Error_SYS.Record_General(lu_name_,'NO_MOD_ALLOWED: Valid formulas can not be modified.');
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN FORMULA_ITEM_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.item_type = 'VARIABLE' AND NOT Get_Item_Var_Count__(remrec_.formula_id,remrec_.item)) THEN
      Formula_Item_Variable_API.Remove_Variable__(remrec_.formula_id, remrec_.item);
   END IF;
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT formula_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.item_type = 'OPERATOR') THEN
      newrec_.item := Arithmetic_Operator_API.Encode(newrec_.item);
   ELSIF (newrec_.item_type = 'FUNCTION') THEN
      newrec_.item := Number_Function_API.Encode(newrec_.item);
   END IF;
   Validate_Formula_Items___(newrec_.item_type, newrec_.item);
   Validate_Item_Sequence___(newrec_.formula_id,newrec_.formula_item_sequence);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     formula_item_tab%ROWTYPE,
   newrec_ IN OUT formula_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.item_type = 'OPERATOR') THEN
      newrec_.item := Arithmetic_Operator_API.Encode(newrec_.item);
   ELSIF (newrec_.item_type = 'FUNCTION') THEN
      newrec_.item := Number_Function_API.Encode(newrec_.item);
   END IF;
   Validate_Formula_Items___(newrec_.item_type, newrec_.item);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_Item_Var_Count__
--   Returns the number of records with the specific item type.
@UncheckedAccess
FUNCTION Get_Item_Var_Count__ (
   formula_id_ IN VARCHAR2,
   variable_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   count_ NUMBER;
   CURSOR type_count IS
      SELECT count(formula_item_id)
      FROM FORMULA_ITEM_TAB
      WHERE formula_id = formula_id_
      AND   item_type = 'VARIABLE'
      AND   item=variable_id_;
BEGIN
   OPEN type_count;
   FETCH type_count INTO count_;
   CLOSE type_count;
   IF count_ > 1 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Get_Item_Var_Count__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Previous_Values
--   Returns the previously entered values of formula variables as a string.
PROCEDURE Get_Previous_Values (
   attribute_string_ IN OUT VARCHAR2,
   formula_id_       IN     VARCHAR2 )
IS
   ptr_              NUMBER;
   input_value_      NUMBER;
   name_             VARCHAR2(50);
   value_            VARCHAR2(50);
   previous_value_   VARCHAR2(500);
   formula_result_   VARCHAR2(100);
   formula_uom_      VARCHAR2(30);
   formula_var_rec_  Formula_Variable_API.Public_Rec;
BEGIN
   --Returns the previously entered values of formula variables as a string.
   WHILE(Client_SYS.Get_Next_From_Attr(attribute_string_ , ptr_, name_, value_)) LOOP
      IF (formula_id_ IS NOT NULL) THEN
         formula_var_rec_ := Formula_Variable_API.Get(name_);
         IF (previous_value_ IS NULL) THEN
            previous_value_ := previous_value_ || formula_var_rec_.description || ': ' || Client_SYS.Attr_Value_To_Number(value_) || ' ' || formula_var_rec_.unit_code;
         ELSE
            previous_value_ := previous_value_ || ', ' || formula_var_rec_.description || ': ' || Client_SYS.Attr_Value_To_Number(value_) || ' ' || formula_var_rec_.unit_code;
         END IF;
      ELSE
         IF (name_ = 'INPUT_VALUE' ) THEN
            input_value_ := Client_SYS.Attr_Value_To_Number(value_);
         ELSIF (name_ = 'INPUT_UOM') THEN
            formula_uom_ := value_;
         END IF;
      END IF;
   END LOOP;
   IF (formula_id_ IS NOT NULL) THEN
      formula_result_:=Formula_API.Get_Formula_Result(formula_id_, attribute_string_);
      formula_uom_:=Formula_API.Get_Formula_Uom(formula_id_);
      Client_SYS.Clear_Attr(attribute_string_);
      attribute_string_:=previous_value_ || ' = ' || formula_result_ || ' ' || formula_uom_;
   ELSE
      attribute_string_:= Language_SYS.Translate_Constant(lu_name_, 'INPUTVALSTR: Input Quantity: :P1 :P2', NULL, input_value_, formula_uom_);
   END IF;
END Get_Previous_Values;


-- Insert_Formula_Item_Variable
--   Clones the records of the Formula item variable tab linked to a formula.
PROCEDURE Insert_Formula_Item_Variable (
   old_formula_id_ IN VARCHAR2,
   new_formula_id_ IN VARCHAR2 )
IS

   CURSOR get_lines IS
   SELECT new_formula_id_   formula_id,
          formula_item_id,
          variable_id,
          variable_value,
          value_source,
          test_value,
          sysdate,
          sys_guid          rowkey
   FROM formula_item_variable_tab t
   WHERE formula_id = old_formula_id_;

   TYPE input_lines IS TABLE OF get_lines%ROWTYPE;   
   input_lines_    input_lines;
BEGIN
   OPEN get_lines;
   FETCH get_lines BULK COLLECT INTO input_lines_ ;
   -- Note: Insert the collect into formula_item_variable table.
   IF get_lines%ROWCOUNT>0 THEN
      FORALL i IN  1..input_lines_.COUNT
        INSERT INTO formula_item_variable_tab VALUES input_lines_(i);
   END IF;
   CLOSE get_lines;   
END Insert_Formula_Item_Variable;



