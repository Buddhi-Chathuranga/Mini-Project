-----------------------------------------------------------------------------
--
--  Logical unit: Formula
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180524  HuBaUK  SAUXXW4-7279, Added new function Get_Test_Formula_Result
--  140901  NIFRSE  PRSA-2183, Some small conditional compilation changes.
--                  APPS 9
--  131120  paskno  Hooks: refactoring and splitting.
--  131206  paskno  PBSA-2961, corrected in Insert_Formula_Items___.
--  100421  Ajpelk Merge rose method documentation
--                  Eagle
--  060922  DuWilk Add reference information on formula_uom column in view comments 
--  060721  UtGulk Modified Get_Formula_Result() and Get_Subst_Formula_String() to make code assert safe (Bug 58228). 
--  051028  NuFilk Added new methods Insert_Formula_Items___ and Insert_New_Record__.
--  041011  IsAnlk Changed error message in Check_Formula_State___.
--  041004  DHSELK Removal of Unused variables Using Oracle Hints --(x) to be removed , and Beautified code.
--  041004  DHSELK Added Missing General_SYS.Init() Method to Get_Formula_Result() for Security.
--                 and Removed the 4'th parameter from the General_SYS.Init() for public methods.
--  040903  SaJjlk Modified the code to get the operator values directly from formula items.
--  040804  DaRulk Rounded formular_value to 5 decimals in mrthod Test_Formula.
--  040727  SaJjlk Modifications to method Get_Formula_Result
--  040709  SaJjlk Added view VIEW_VALID
--  040708  SaJjlk Added method Get_Formula_With_Uom
--  040708  SaJjlk Added method Test_Formula_Validity___
--  040707  SaJjlk Added another parameter to Test_Formula
--  040701  JaJalk Made the FORMULA_UOM and DESCRIPTION public.
--  040701  DHSELK Added Missing General_SYS.Init_Method() for Security.
--  040625  JaJalk Added the method Get_Obj_State.
--  040622  JaJalk Added the fields FORMULA_UOM and UOM_DESCRIPTION.
--  040618  SaJjlk Added method Get_Formula_result
--  040615  SaJjLk Implemented Check_Formula_State___
--  040611  JaJalk Implemented the Enumerate method so that the LU can act as an IID as well.
--  040610  SaJjlk Added method Get_Subst_Formula_String
--  040609  Sajjlk Added methods Get_Formula and Test_Formula
--  040604  HeWelk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Insert_Formula_Items___
--   Clones Formula Item lines, Inserts to Formula Item Tab directly
--   by passing validation logic for Formula items.
PROCEDURE Insert_Formula_Items___ (
   old_formula_id_ IN VARCHAR2,
   new_formula_id_ IN VARCHAR2 )
IS

   CURSOR get_lines IS
   SELECT new_formula_id_       formula_id,
          formula_item_id,
          formula_item_sequence,
          item,
          item_type,
          sysdate,
          notes
          formula_item,
          sys_guid              rowkey
     FROM formula_item_tab  t
    WHERE formula_id = old_formula_id_;
   
   TYPE input_lines IS TABLE OF get_lines%ROWTYPE;   
   input_lines_    input_lines;   
BEGIN
   OPEN get_lines;
   FETCH get_lines BULK COLLECT INTO input_lines_ ;
   IF get_lines%ROWCOUNT>0 THEN
     -- Note: This inserts the bulk records from formula item tab to the new formula. 
      FORALL i IN  1..input_lines_.COUNT
        INSERT INTO formula_item_tab VALUES input_lines_(i);
      
      -- Note: Insert the Formula Variables 
      Formula_Item_API.Insert_Formula_Item_Variable(old_formula_id_, new_formula_id_);
   END IF;
   CLOSE get_lines;   
END Insert_Formula_Items___;


PROCEDURE Test_Formula_Validity___ (
   rec_  IN OUT FORMULA_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   result_ VARCHAR2(2000);
   valid_ VARCHAR2(50);
BEGIN

-- This check whether the formula entered is error-free before changing the state to "Valid"

   Formula_API.Test_Formula(result_,valid_,rec_.formula_id);
   IF valid_='FALSE' THEN
      Error_SYS.Record_General(lu_name_, 'ERRONEOUSFORMULA: Formula cannot be validated.There is an error in the entered formula.');
   END IF;

END Test_Formula_Validity___;


PROCEDURE Check_Formula_State___ (
   rec_  IN OUT FORMULA_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   formula_used_ VARCHAR2(100):='FALSE';
BEGIN
-- Raises an error if the formula has been used by any of the Input UoM Groups
-- IF so the state cannot be changed to 'Invalid'
   
   $IF Component_Partca_SYS.INSTALLED $THEN
      formula_used_ := Input_Unit_Meas_API.Is_Formula_Used(rec_.formula_id);
   $END

   IF formula_used_='TRUE' THEN
      Error_SYS.Record_General(lu_name_, 'FORMULAUSED: Formula cannot be invalidated, as the Formula is used in an existing Input UoM Group.');
   END IF;
END Check_Formula_State___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FORMULA_TAB%ROWTYPE,
   newrec_     IN OUT FORMULA_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN

   IF (Get_Obj_State(newrec_.formula_id) = 'Valid') THEN
      Error_SYS.Record_General(lu_name_,'NO_MOD_ALLOWED: Valid formulas can not be modified.');
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_New_Record__
--   To Copy all the details of Formula into another formula record.
PROCEDURE Insert_New_Record__ (
   old_formula_id_ IN OUT VARCHAR2,
   new_formula_id_ IN OUT VARCHAR2,
   description_    IN     VARCHAR2 )
IS
   objid_            VARCHAR2(100);
   objversion_       VARCHAR2(100);
   attr_             VARCHAR2(2000);
   uom_              VARCHAR2(30);
   uom_description_  VARCHAR2(200);
   newrec_           FORMULA_TAB%ROWTYPE;
   indrec_           Indicator_Rec;
BEGIN
   
   uom_ := Get_Formula_Uom(old_formula_id_);
   uom_description_ := Get_Uom_Description(old_formula_id_);
   
   Client_SYS.Add_To_Attr('FORMULA_ID',       new_formula_id_,   attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION',      description_,      attr_);
   Client_SYS.Add_To_Attr('FORMULA_UOM',      uom_,              attr_);
   Client_SYS.Add_To_Attr('UOM_DESCRIPTION',  uom_description_,  attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___ (objid_, objversion_, newrec_, attr_);
   -- Note: Insert the Formula Items copying from old forumla items.
   Insert_Formula_Items___(old_formula_id_, new_formula_id_);

END Insert_New_Record__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Formula
--   Returns a string of Formula Items concatenated together.
--   e.g. HEIGHT*WIDTH
@UncheckedAccess
FUNCTION Get_Formula (
   formula_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_formula_items IS
      SELECT item, item_type
      FROM formula_item_tab
      WHERE formula_id=formula_id_
      ORDER BY formula_item_sequence;

   formula_items_ VARCHAR2(2000);
   formula_ VARCHAR2(2000);
   previous_item_type_ VARCHAR2(50);
   previous_operator_ VARCHAR2(20);
   result_ VARCHAR2(2000);
   valid_ VARCHAR2(50);
BEGIN
   FOR items_ IN get_formula_items LOOP
        IF (items_.item_type=previous_item_type_) THEN
            IF (items_.item_type='OPERATOR') THEN
               IF NOT (items_.item='(' OR items_.item=')') THEN
                  formula_items_:=formula_items_ ||' ';
               END IF;
            ELSE
               formula_items_:=formula_items_ ||' ';
            END IF;
      END IF;

      IF (items_.item_type='VARIABLE') AND (Formula_Item_Variable_API.Get_Test_Value(formula_id_,items_.item) IS NULL) THEN
         RETURN NULL;
      END IF;

      IF (items_.item_type='OPERATOR')THEN
            IF (items_.item ='(' OR items_.item =')') THEN
               IF (items_.item=previous_operator_) OR (previous_operator_ =')') OR (previous_item_type_='VARIABLE')OR (previous_item_type_='VALUE')THEN
                  formula_items_:=formula_items_ ||items_.item;
               ELSE
                  IF (formula_items_ IS NULL) THEN
                     formula_items_:=formula_items_ ||items_.item;
                  ELSE
                     formula_items_:=formula_items_ ||' '||items_.item;
                  END IF;
               END IF;
            ELSE
               IF (previous_operator_=')') THEN
                    formula_items_:=formula_items_ ||items_.item;
               ELSE
                   formula_items_:=formula_items_ ||' '||items_.item;
               END IF;

            END IF;

      ELSIF (items_.item_type='VARIABLE') THEN
         IF (previous_item_type_='VALUE') THEN
             formula_items_:=formula_items_ ||'  '||items_.item;
         ELSIF (previous_item_type_='OPERATOR' AND previous_operator_!='(' ) THEN
             formula_items_:=formula_items_ ||' '||items_.item;
         ELSE
             formula_items_:=formula_items_ ||items_.item;
         END IF;
      ELSIF (items_.item_type='VALUE') THEN
         IF (previous_item_type_='VARIABLE')OR ((previous_item_type_='OPERATOR') AND (previous_operator_!='(')) THEN
                 formula_items_:=formula_items_ ||' '||items_.item;
         ELSE
                 formula_items_:=formula_items_ ||items_.item;
         END IF;
      ELSIF (items_.item_type='FUNCTION') THEN
         IF (previous_item_type_='OPERATOR') AND ((previous_operator_!='(') OR (previous_operator_!=')')) THEN
            formula_items_:=formula_items_ ||' '|| items_.item;
         END IF;
      ELSE
         formula_items_:=formula_items_ || items_.item;
      END IF;
      previous_item_type_:=items_.item_type;
      IF (previous_item_type_='OPERATOR') THEN
            previous_operator_:=items_.item;
      END IF;
   END LOOP;

   IF formula_items_ IS NULL THEN
      formula_:=formula_items_;
   ELSE
      Formula_API.Test_Formula(result_,valid_,formula_id_);
      IF valid_='FALSE' THEN
         formula_:='There is an error in the entered formula';
      ELSE
         formula_:= formula_items_;
      END IF;
   END IF;
   RETURN formula_;
END Get_Formula;


-- Test_Formula
--   Returns the value substituted formula as a string if the formula is correct.
--   Else it will raise an error
--   e.g. = 6
@UncheckedAccess
PROCEDURE Test_Formula (
   result_ OUT VARCHAR2,
   valid_ OUT VARCHAR2,
   formula_id_ IN VARCHAR2 )
IS
   select_        VARCHAR2(10) := 'SELECT ';
   into_          VARCHAR2(13) := ' INTO :result';
   fromwhere_     VARCHAR2(10) := ' FROM DUAL';

   test_formula_  VARCHAR2(2000);
   stmt_          VARCHAR2(2000);
   formula_value_ VARCHAR2(1000);
   formula_with_uom_ VARCHAR2(2000);
   formula_uom_ VARCHAR2(20);
BEGIN
   test_formula_ := Get_Subst_Formula_String(formula_id_);
   IF test_formula_ IS NULL THEN
      result_:=test_formula_ ;
      valid_:='FALSE';
   ELSE
      stmt_ := select_ || test_formula_ || into_ || fromwhere_;
      @ApproveDynamicStatement(2006-07-21,utgulk)
      EXECUTE IMMEDIATE stmt_ INTO formula_value_ ;

      formula_with_uom_ :=Formula_API.Get_Formula_With_Uom(formula_id_);
      formula_uom_:=Formula_API.Get_Formula_Uom(formula_id_);

      result_:= formula_with_uom_|| ' = '||to_char(Round(to_number((formula_value_)),5))||' '||formula_uom_;
      valid_:='TRUE';
   END IF;
EXCEPTION
      WHEN others THEN
           result_:='Error in the formula';
           valid_:='FALSE';
END Test_Formula;


-- Get_Subst_Formula_String
--   Returns the value stubstitued formula string
--   e.g. 2*3
FUNCTION Get_Subst_Formula_String (
   formula_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_formula_items IS
   SELECT item,formula_item_id,item_type
   FROM formula_item_tab
   WHERE formula_id=formula_id_
   ORDER BY formula_item_sequence;

   formula_items_ VARCHAR2(2000);
   formula_string_ VARCHAR2(2000);
   previous_item_type_ VARCHAR2(50);
   test_value_ NUMBER;

BEGIN
   FOR items_ IN get_formula_items LOOP
      IF (items_.item_type=previous_item_type_) THEN
                formula_items_:=formula_items_ ||'  ';
      END IF;

      IF (items_.item_type='VARIABLE') THEN
            test_value_ := Formula_Item_Variable_API.Get_Test_Value(formula_id_,items_.item);
            IF test_value_ IS NULL THEN
               RETURN NULL;
            ELSE
               Assert_SYS.Assert_Is_Number(test_value_);
            END IF;
            IF (previous_item_type_='VALUE') THEN
                 formula_items_:=formula_items_ ||'  '||test_value_;
            ELSE
                 formula_items_:=formula_items_ ||test_value_;
            END IF;
      ELSIF (items_.item_type='VALUE') THEN
            IF items_.item IS NOT NULL THEN
               Assert_SYS.Assert_Is_Number(items_.item);
            END IF;
            IF (previous_item_type_='VARIABLE') THEN
                 formula_items_:=formula_items_ ||'   '||items_.item;
            ELSE
                 formula_items_:=formula_items_ ||items_.item;
            END IF;
      ELSE
            --assert safe validation
            IF items_.item_type='FUNCTION' THEN
               Number_Function_API.Exist_Db(items_.item);
            ELSIF  items_.item_type='OPERATOR' THEN
               Arithmetic_Operator_API.Exist_Db(items_.item);
            ELSE
               Error_SYS.Record_General(lu_name_, 'INVALIDITEMTYPE: Invalid item type :P1 in formula.', items_.item_type);
            END IF;
            formula_items_:=formula_items_||items_.item;
      END IF;


      previous_item_type_:=items_.item_type;
   END LOOP;
   formula_string_:=formula_items_;
   RETURN formula_string_;

END Get_Subst_Formula_String;


-- Enumerate
--   This method is used to make the LU a fake IID for retrieving valus as a list.
--   Returns the value of valid formula_id's as the client value list.
@UncheckedAccess
PROCEDURE Enumerate (
   client_values_ OUT VARCHAR2 )
IS
   desc_list_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT formula_id
      FROM FORMULA_TAB WHERE rowstate = 'Valid'
      ORDER BY formula_id;
BEGIN
   FOR rec_ IN get_value LOOP
      desc_list_ := desc_list_ || rec_.formula_id  || Client_SYS.field_separator_;
   END LOOP;
   client_values_ := desc_list_;
END Enumerate;


-- Encode
--   Retuns the value of FormulaId as the db value of the fake IID.
@UncheckedAccess
FUNCTION Encode (
   description_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formula_id_  FORMULA_TAB.formula_id%TYPE;
   CURSOR get_db_val IS
      SELECT formula_id
      FROM FORMULA_TAB
      WHERE description = description_;
BEGIN
   OPEN get_db_val;
   FETCH get_db_val INTO formula_id_;
   IF (get_db_val%NOTFOUND) THEN
      formula_id_ := NULL;
   END IF;
   CLOSE get_db_val;
   RETURN formula_id_;
END Encode;


-- Decode
--   Retuns the description as the client value of the fake IID
@UncheckedAccess
FUNCTION Decode (
   formula_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ FORMULA_TAB.description%TYPE;
   CURSOR get_client_val IS
      SELECT description
      FROM FORMULA_TAB
      WHERE formula_id = formula_id_;
BEGIN
   OPEN get_client_val;
   FETCH get_client_val INTO description_;
   IF (get_client_val%NOTFOUND) THEN
      description_ := NULL;
   END IF;
   CLOSE get_client_val;
   RETURN description_;
END Decode;


-- Get_Formula_Result
--   Returns the result of a formula using the values entered by a user at run time
FUNCTION Get_Formula_Result (
   formula_id_ IN VARCHAR2,
   attribute_string_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_formula_items IS
   SELECT formula_item_id,item, item_type
   FROM formula_item_tab
   WHERE formula_id=formula_id_
   ORDER BY formula_item_sequence;

   select_        VARCHAR2(10) := 'SELECT ';
   into_          VARCHAR2(13) := ' INTO :result';
   fromwhere_     VARCHAR2(10) := ' FROM DUAL';

   formula_items_ VARCHAR2(2000);
   value_ VARCHAR2(50);
   stmt_    VARCHAR2(2000);
   formula_result_ VARCHAR2(200);

BEGIN
-- Returns the result of a formula after substituting variable values sent by the user.
   FOR items_ IN get_formula_items LOOP
      IF (items_.item_type='VARIABLE') THEN
         value_:=Client_SYS.Get_Item_Value(items_.item,attribute_string_);
         IF (value_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'NOVALUEFORMULA: Missing variable values in formula.');
         ELSE
            Assert_SYS.Assert_Is_Number(value_);
            formula_items_:=formula_items_ || value_;
         END IF;
      ELSE
         --assert safe validation
         IF items_.item_type='VALUE' THEN
            Assert_SYS.Assert_Is_Number(items_.item);
         ELSIF items_.item_type='FUNCTION' THEN
            Number_Function_API.Exist_Db(items_.item);
         ELSIF  items_.item_type='OPERATOR' THEN
            Arithmetic_Operator_API.Exist_Db(items_.item);
         ELSE
            Error_SYS.Record_General(lu_name_, 'INVALIDITEMTYPE: Invalid item type :P1 in formula.', items_.item_type);
         END IF;

         formula_items_:=formula_items_||items_.item;
      END IF;
   END LOOP;

   stmt_ := select_ || formula_items_ || into_ || fromwhere_;
   @ApproveDynamicStatement(2006-07-21,utgulk)
   EXECUTE IMMEDIATE stmt_ INTO formula_result_ ;
   RETURN formula_result_ ;
END Get_Formula_Result;


-- Get_Obj_State
--   Retuns the state.
@UncheckedAccess
FUNCTION Get_Obj_State (
   formula_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_      FORMULA_TAB.rowstate%TYPE;
   CURSOR get_state IS
      SELECT rowstate
      FROM  FORMULA_TAB
      WHERE formula_id = formula_id_;
BEGIN
   OPEN  get_state;
   FETCH get_state INTO state_;
   CLOSE get_state;
   RETURN state_;
END Get_Obj_State;


-- Get_Formula_With_Uom
--   This returns the value substituted formula with the respective
--   Units of Measures for each variable.
@UncheckedAccess
FUNCTION Get_Formula_With_Uom (
   formula_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_formula_items IS
   SELECT item,formula_item_id,item_type
   FROM formula_item_tab
   WHERE formula_id=formula_id_
   ORDER BY formula_item_sequence;

   formula_items_ VARCHAR2(2000);
   formula_string_ VARCHAR2(2000);
   previous_item_type_ VARCHAR2(50);
   unit_code_ VARCHAR2(20);
   previous_operator_ VARCHAR2(20);
BEGIN
-- This returns the value substituted formula as a string with
-- corresponding units of measure for each variable

   FOR items_ IN get_formula_items LOOP
      IF (items_.item_type=previous_item_type_) THEN
            IF (items_.item_type='OPERATOR') THEN
               IF NOT (items_.item='(' OR items_.item=')') THEN
                  formula_items_:=formula_items_ ||' ';
               END IF;
            ELSE
               formula_items_:=formula_items_ ||' ';
            END IF;
      END IF;

      IF (items_.item_type='VARIABLE') THEN
            unit_code_:=Formula_Variable_API.Get_Unit_Code(items_.item);
            IF (previous_item_type_='VALUE') THEN
                 formula_items_:=formula_items_ ||'  '||Formula_Item_Variable_API.Get_Test_Value(formula_id_,items_.item)||' '||unit_code_;
            ELSIF Formula_Item_Variable_API.Get_Test_Value(formula_id_,items_.item) IS NULL THEN
                  RETURN NULL;
            ELSIF (previous_item_type_='OPERATOR' AND previous_operator_!='(' ) THEN
                formula_items_:=formula_items_ ||' '||Formula_Item_Variable_API.Get_Test_Value(formula_id_,items_.item)||' '||unit_code_;
            ELSE
                 formula_items_:=formula_items_ ||Formula_Item_Variable_API.Get_Test_Value(formula_id_,items_.item)||' '||unit_code_;
            END IF;
      ELSIF (items_.item_type='VALUE') THEN
            IF (previous_item_type_='VARIABLE') OR ((previous_item_type_='OPERATOR') AND (previous_operator_!='(')) THEN
                 formula_items_:=formula_items_ ||' '||items_.item;
            ELSE
                 formula_items_:=formula_items_ ||items_.item;
            END IF;
      ELSIF (items_.item_type='OPERATOR')THEN
            IF (items_.item ='(' OR items_.item =')') THEN
               IF (items_.item = previous_operator_) OR (previous_item_type_='VARIABLE')OR (previous_item_type_='VALUE')THEN
                  formula_items_:=formula_items_ ||items_.item;
               ELSE
                  IF (formula_items_ IS NULL) THEN
                     formula_items_:=formula_items_ ||items_.item;
                  ELSE
                      formula_items_:=formula_items_ ||' '||items_.item;
                  END IF;
               END IF;
            ELSE
               IF (previous_operator_=')') THEN
                  formula_items_:=formula_items_ ||items_.item;
               ELSE
                  formula_items_:=formula_items_ ||' '||items_.item;
               END IF;
            END IF;
      ELSIF (items_.item_type='FUNCTION') THEN
         IF (previous_item_type_='OPERATOR') AND ((previous_operator_!='(') OR (previous_operator_!=')')) THEN
            formula_items_:=formula_items_ ||' '|| items_.item;
         END IF;
      ELSE
             formula_items_:=formula_items_||items_.item;
      END IF;


      previous_item_type_:=items_.item_type;
      IF (previous_item_type_='OPERATOR') THEN
            previous_operator_:=items_.item;
      END IF;
   END LOOP;
   formula_string_:=formula_items_;
   RETURN formula_string_;
END Get_Formula_With_Uom;


-- Get_Test_Formula_Result
--   This returns the result_ parameter of Test_Formula
@UncheckedAccess
FUNCTION Get_Test_Formula_Result (
   formula_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_ VARCHAR2(2000);
   valid_ VARCHAR2(50);
BEGIN
   Test_Formula(result_, valid_, formula_id_);
   RETURN result_;
END Get_Test_Formula_Result;


BEGIN
   FORMULA_API.Language_Refreshed;
END;
