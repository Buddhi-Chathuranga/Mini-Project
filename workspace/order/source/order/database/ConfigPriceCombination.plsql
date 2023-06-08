-----------------------------------------------------------------------------
--
--  Logical unit: ConfigPriceCombination
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211007  PAMMLK  MF21R2-4520 - Created.
--  211223  INUMLK  MF21R2-6380 - Allowed parent combination to be planned, if it is in released state and connected to a child combination
--  220127  INUMLK  MF21R2-6540 - Allowed default return value to edit in released status
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE number_type IS TABLE OF
   NUMBER INDEX BY BINARY_INTEGER;

TYPE char_20_type IS TABLE OF
   VARCHAR2(20) INDEX BY BINARY_INTEGER;
 
TYPE char_2000_type IS TABLE OF
   VARCHAR2(2000) INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE combo_value_type_ IS RECORD (
   factor_no_              number_type,
   config_relational_oper_ char_20_type,
   combination_value_      char_2000_type );

TYPE factor_type_ IS RECORD (
   no_of_factors_          NUMBER,
   factor_no_              number_type,
   config_data_type_db_    char_20_type,
   combo_value_            char_2000_type );

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Update___ (
   oldrec_ IN     config_price_combination_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY config_price_combination_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF (indrec_.currency_code) THEN
      IF NOT (Is_Combo_Change_Allow(newrec_.combination_id)) THEN
         Error_SYS.Record_General(lu_name_, 'NOCHANGEALLOWED:  Changing currency code is not allowed at this status. Set status to Planned first.');
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


PROCEDURE Is_Release_Allow___ (
   rec_  IN OUT NOCOPY config_price_combination_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   all_released_  NUMBER;
   combo_value_    VARCHAR2(24);
BEGIN
   IF NOT (Config_Price_Combo_Value_API.Get_Combo_Count(rec_.combination_id) > 0 ) THEN
      Error_SYS.Record_General(lu_name_, 'NOCOMBDEF:  Must define at least one combination for this table.');
   ELSE 
      Config_Price_Combo_Value_API.Is_Connected_Combo_Released(all_released_,combo_value_,rec_.combination_id) ;
      IF all_released_ = 0 THEN 
         Check_Connect_Combo_State___(combo_value_);
      END IF;
      IF rec_.config_return_type = 'COMBINATION' AND Config_Price_Combination_API.Get_State(rec_.default_return_combo) != 'Released' THEN
         Check_Connect_Combo_State___(rec_.default_return_combo);
      END IF; 
   END IF;
   
END Is_Release_Allow___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Combo_And_String___ (
   return_and_string_ IN OUT VARCHAR2,
   factor_no_ IN NUMBER,
   config_data_type_db_ IN VARCHAR2,
   combo_values_ IN combo_value_type_ )
IS
   cidx_              NUMBER;
   local_value_      VARCHAR2(2000);
BEGIN
   -- Loop through to locate correct factor index
   FOR j_ IN 1..15  LOOP
      IF ( combo_values_.factor_no_(j_) = factor_no_ ) THEN
         cidx_ := j_;
         EXIT;
      END IF;
   END LOOP;
   -- Build 2nd half of AND string
   IF ( combo_values_.combination_value_(cidx_) IS NOT NULL ) THEN
      
      IF (Config_Price_Combination_API.Wild_Card_Exist(combo_values_.combination_value_(cidx_))) THEN
         -- If wild card exist then should use LIKE operator
         local_value_ := REPLACE(combo_values_.combination_value_(cidx_), '_', '\_');
         local_value_ := REPLACE(local_value_, '?', '_');
         IF combo_values_.config_relational_oper_(cidx_) = Config_Relational_Oper_API.DB_EQUAL_TO THEN
            -- Use backslash (\) as escape character for execution
            return_and_string_ := ' LIKE ''' || local_value_ || ''' ESCAPE ''\''';
         ELSIF combo_values_.config_relational_oper_(cidx_) = Config_Relational_Oper_API.DB_NOT_EQUAL_TO THEN
            -- Use backslash (\) as escape character for execution
            return_and_string_ := ' NOT LIKE ''' || local_value_ || ''' ESCAPE ''\''';
         ELSE
            return_and_string_ := ' 1 <> 1 ';
         END IF;
      ELSE
         IF ( config_data_type_db_ = 'ALPHA' ) THEN
            return_and_string_ := ' ' || combo_values_.config_relational_oper_(cidx_) || ' ''' || combo_values_.combination_value_(cidx_) || '''';
         ELSE
            return_and_string_ := ' ' || combo_values_.config_relational_oper_(cidx_) || ' ' || combo_values_.combination_value_(cidx_);
         END IF;
      END IF;
   ELSE
      -- Return NULL if no value specified.
      return_and_string_ := NULL;
   END IF;
END Get_Combo_And_String___;

@IgnoreUnitTest DynamicStatement
FUNCTION Check_Combo_Valid___ (
   parsed_string_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   stmt_          VARCHAR2(32000);
   select_        VARCHAR2(50) := 'SELECT 1 INTO :result FROM DUAL WHERE ';
   result_        NUMBER;
BEGIN

   IF parsed_string_ IS NULL THEN
      RETURN FALSE;
   END IF;

   stmt_ := select_ || parsed_string_ ;
   @ApproveDynamicStatement(2021-10-25,pammlk)
   EXECUTE IMMEDIATE stmt_ INTO result_;
   IF result_ = 1 THEN
      Trace_SYS.Message('Condition <'||parsed_string_||' evaluated to TRUE');
      RETURN TRUE;
   ELSE
      Trace_SYS.Message('Condition <'||parsed_string_||' evaluated to FALSE');
      RETURN FALSE;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      Trace_SYS.Message('Condition <'||parsed_string_||' evaluated to FALSE');
      RETURN FALSE;
   WHEN OTHERS THEN
      Trace_SYS.Message('Condition <'||parsed_string_||' evaluated to FALSE');   
      RETURN FALSE;
END Check_Combo_Valid___;

PROCEDURE Is_Plan_Allow___ (
   rec_  IN OUT NOCOPY config_price_combination_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   connect_to_released_combo_    NUMBER;
   combo_value_                  VARCHAR2(24);
   combo_exist_                  NUMBER;
   combo_in_price_list_          NUMBER;
   combo_in_char_base_price_     NUMBER;  
   dflt_ret_combo_value_         VARCHAR2(24);
   released_combo_value_         VARCHAR2(24);
   
   CURSOR is_combo_used_config_base_price IS
   SELECT 1
     FROM Characteristic_Base_Price_Tab 
     WHERE combination_id = rec_.combination_id;
     
   CURSOR is_combo_used_char_price_list IS
   SELECT 1
     FROM Characteristic_Price_List_Tab 
     WHERE combination_id = rec_.combination_id;
     
   CURSOR is_combo_used_char_based_price IS
   SELECT 1
     FROM Char_Based_Price_List_Tab 
     WHERE combination_id = rec_.combination_id;
     
   CURSOR get_combo_used_combo_value IS
   SELECT return_value
     FROM Config_Price_Combo_Value_Tab 
      WHERE combination_id = rec_.combination_id
      AND (return_type = 'COMBINATION' AND Config_Price_Combination_API.Get_Objstate(return_value) = 'Released');
     
   CURSOR get_combo_used_char_price_combo IS
   SELECT combination_id
     FROM Config_Price_Combination_Tab 
     WHERE default_return_combo = rec_.combination_id
     AND rowstate = 'Released';
    
BEGIN
   Config_Price_Combo_Value_API.Is_Connected_to_Released_Combo(connect_to_released_combo_,combo_value_,rec_.combination_id) ;
   IF connect_to_released_combo_ = 1 THEN 
      Error_SYS.Record_General(lu_name_, 'CONNECTTORELEASEDCOMBO: Combination :P1 is already connected to another Released combination :P2. ',rec_.combination_id,combo_value_);
   END IF;
   
   OPEN is_combo_used_config_base_price;
   FETCH is_combo_used_config_base_price INTO combo_exist_;
   CLOSE is_combo_used_config_base_price;
   
   OPEN is_combo_used_char_price_list;
   FETCH is_combo_used_char_price_list INTO combo_in_price_list_;
   CLOSE is_combo_used_char_price_list;
   
   OPEN is_combo_used_char_based_price;
   FETCH is_combo_used_char_based_price INTO combo_in_char_base_price_;
   CLOSE is_combo_used_char_based_price;
   
   OPEN get_combo_used_char_price_combo;
   FETCH get_combo_used_char_price_combo INTO dflt_ret_combo_value_;
   CLOSE get_combo_used_char_price_combo;
   
   OPEN get_combo_used_combo_value;
   FETCH get_combo_used_combo_value INTO released_combo_value_;
   CLOSE get_combo_used_combo_value;

   IF combo_exist_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'COMBOIDFOUND: Combination :P1 is connected to Sales Parts. Combination status can not be changed to Planned.',rec_.combination_id);
   ELSIF combo_in_price_list_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'COMBOINCONFIGPRICE: Combination :P1 is connected to Configuration Price List. Combination status can not be changed to Planned.',rec_.combination_id);
   ELSIF combo_in_char_base_price_ = 1 THEN 
      Error_SYS.Record_General(lu_name_, 'COMBOINSALESPRICE: Combination :P1 is connected to Sales Price List. Combination status can not be changed to Planned.',rec_.combination_id);
   ELSIF dflt_ret_combo_value_ IS NOT NULL THEN 
      Error_SYS.Record_General(lu_name_, 'COMBOINCHARSALESPRICE: Combination :P1 is connected to another Released Configuration Characteristic Sales Price Combination :P2. Combination status can not be changed to Planned.',rec_.combination_id , dflt_ret_combo_value_);   
   END IF;
END Is_Plan_Allow___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Is_Obsolete_Allow___ (
   rec_  IN OUT NOCOPY config_price_combination_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   combo_exist_               NUMBER;
   combo_in_price_list_       NUMBER;
   combo_in_char_base_price_  NUMBER;
   dflt_ret_combo_value_      VARCHAR2(24); 
   released_combo_value_         VARCHAR2(24);
   
   CURSOR is_combo_used_config_base_price IS
   SELECT 1
     FROM Characteristic_Base_Price_Tab 
     WHERE combination_id = rec_.combination_id;
     
   CURSOR is_combo_used_char_price_list IS
   SELECT 1
     FROM Characteristic_Price_List_Tab 
     WHERE combination_id = rec_.combination_id;
     
   CURSOR is_combo_used_char_based_price IS
   SELECT 1
     FROM Char_Based_Price_List_Tab 
     WHERE combination_id = rec_.combination_id;
     
   CURSOR get_combo_used_char_price_combo IS
   SELECT combination_id
     FROM Config_Price_Combination_Tab 
     WHERE default_return_combo = rec_.combination_id
     AND   rowstate = 'Released';
     
   CURSOR get_combo_used_combo_value IS
   SELECT combination_id
     FROM Config_Price_Combo_Value_Tab 
      WHERE return_value = rec_.combination_id
      AND return_type = 'COMBINATION' AND Config_Price_Combination_API.Get_Objstate(combination_id) = 'Released';  
     
BEGIN
   OPEN is_combo_used_config_base_price;
   FETCH is_combo_used_config_base_price INTO combo_exist_;
   CLOSE is_combo_used_config_base_price;
   
   OPEN is_combo_used_char_price_list;
   FETCH is_combo_used_char_price_list INTO combo_in_price_list_;
   CLOSE is_combo_used_char_price_list;
   
   OPEN is_combo_used_char_based_price;
   FETCH is_combo_used_char_based_price INTO combo_in_char_base_price_;
   CLOSE is_combo_used_char_based_price;
   
   OPEN get_combo_used_char_price_combo;
   FETCH get_combo_used_char_price_combo INTO dflt_ret_combo_value_;
   CLOSE get_combo_used_char_price_combo;
   
   OPEN get_combo_used_combo_value;
   FETCH get_combo_used_combo_value INTO released_combo_value_;
   CLOSE get_combo_used_combo_value;
   
   IF combo_exist_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTOBSOLETE: Combination :P1 is connected to Sales Parts. Combination status can not be changed to Obsolete.',rec_.combination_id);
   ELSIF combo_in_price_list_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'COMBOINPRICELIST: Combination :P1 is connected to Configuration Price List. Combination status can not be changed to Obsolete.',rec_.combination_id);
   ELSIF combo_in_char_base_price_ = 1 THEN 
      Error_SYS.Record_General(lu_name_, 'COMBOINSALESPRICELIST: Combination :P1 is connected to Sales Price List. Combination status can not be changed to Obsolete.',rec_.combination_id);
   ELSIF dflt_ret_combo_value_ IS NOT NULL THEN 
      Error_SYS.Record_General(lu_name_, 'COMBOINCHARSALESPRICECOMBO: Combination :P1 is connected to another Released Configuration Characteristic Sales Price Combination :P2. Combination status can not be changed to Obsolete.',rec_.combination_id , dflt_ret_combo_value_);   
   ELSIF released_combo_value_ IS NOT NULL THEN
       Error_SYS.Record_General(lu_name_, 'COMBOINCHARSALESPRICECOMBO: Combination :P1 is connected to another Released Configuration Characteristic Sales Price Combination :P2. Combination status can not be changed to Obsolete.',rec_.combination_id, released_combo_value_);
   END IF;
   
END Is_Obsolete_Allow___;


PROCEDURE Validate_Combination___ (
   return_value_   OUT VARCHAR2,
   return_type_    OUT VARCHAR2,
   combination_id_ IN VARCHAR2,
   eval_rec_       IN Characteristic_Base_Price_API.config_price_comb_rec)
IS
   num_                     NUMBER := 0;
   idx_                     NUMBER;
   combination_valid_       BOOLEAN;
   default_return_value_    VARCHAR2(2000);
   factor_                  factor_type_;
   combo_val_               combo_value_type_;

   parse_string_   VARCHAR2(32000); -- The 'AND' string to be evaluated for a combination row
   fidx_           NUMBER;
   and_string1_    VARCHAR2(2000);
   and_string2_    VARCHAR2(2000);
   all_char_found_ BOOLEAN;
   -- Note order clause means first combination evaluating to TRUE is
   -- the one returned.
   CURSOR get_combo_ IS
      SELECT *
      FROM CONFIG_PRICE_COMBO_VALUE_TAB
      WHERE combination_id = combination_id_
      ORDER BY sequence;

   CURSOR get_factor_ IS
      SELECT factor_no,
             characteristic_id,
             factor_type
      FROM   CONFIG_PRICE_COMBO_FACTOR_TAB
      WHERE  combination_id = combination_id_
      ORDER BY factor_no;

BEGIN
   IF (eval_rec_.num_chars_ IS  NULL ) THEN   
      return_value_ := NULL;
      return_type_  := NULL;
   ELSE 
      -- Loop through factors load into array
      FOR fac_ IN get_factor_ LOOP
         num_ := num_ + 1;
         factor_.factor_no_(num_) := fac_.factor_no;
         factor_.config_data_type_db_(num_) := Config_Price_Combo_Factor_API.Get_Factor_Data_Type_Db(combination_id_,
                                                                                                 fac_.factor_no );                                                                                        
         idx_ := 1;
         -- Reset the variable for each characteristic value.
         all_char_found_ := FALSE;
         WHILE idx_ <= eval_rec_.num_chars_ LOOP
            IF eval_rec_.char_id_(idx_) = fac_.characteristic_id THEN
               all_char_found_ := TRUE;
               IF fac_.factor_type = 'CHARVALUE' THEN
                  factor_.combo_value_(num_) := eval_rec_.char_value_(idx_);
               ELSIF fac_.factor_type = 'CHARQTY' THEN
                  factor_.combo_value_(num_) := eval_rec_.char_qty_(idx_);
               END IF;
               factor_.no_of_factors_ := num_;
               -- if fac_.characteristic found, then exist and look for the next fac_.characteristic value.
               EXIT;
            END IF; 
            idx_ := idx_ + 1;
         END LOOP;
         -- if at least one parameter required in fac_ is not included in the configuration eval_rec_, we cannot give it a value using the table.
         IF NOT all_char_found_ THEN
            EXIT;
         END IF; 
      END LOOP;        


      IF all_char_found_ THEN
         factor_.no_of_factors_ := num_;   

         -- Loop through combinations, load each record into array of factor values
         FOR combo_ IN get_combo_ LOOP
            -- Loads the values for a single combination value record into array of comparison values
            combo_val_.factor_no_(1) := 1;
            combo_val_.config_relational_oper_(1) := combo_.config_relational_oper1;
            combo_val_.combination_value_(1)     := combo_.combination_value1;
            combo_val_.factor_no_(2) := 2;
            combo_val_.config_relational_oper_(2) := combo_.config_relational_oper2;
            combo_val_.combination_value_(2)     := combo_.combination_value2;
            combo_val_.factor_no_(3) := 3;
            combo_val_.config_relational_oper_(3) := combo_.config_relational_oper3;
            combo_val_.combination_value_(3)     := combo_.combination_value3;
            combo_val_.factor_no_(4) := 4;
            combo_val_.config_relational_oper_(4) := combo_.config_relational_oper4;
            combo_val_.combination_value_(4)     := combo_.combination_value4;
            combo_val_.factor_no_(5) := 5;
            combo_val_.config_relational_oper_(5) := combo_.config_relational_oper5;
            combo_val_.combination_value_(5)     := combo_.combination_value5;
            combo_val_.factor_no_(6) := 6;
            combo_val_.config_relational_oper_(6) := combo_.config_relational_oper6;
            combo_val_.combination_value_(6)     := combo_.combination_value6;
            combo_val_.factor_no_(7) := 7;
            combo_val_.config_relational_oper_(7) := combo_.config_relational_oper7;
            combo_val_.combination_value_(7)     := combo_.combination_value7;
            combo_val_.factor_no_(8) := 8;
            combo_val_.config_relational_oper_(8) := combo_.config_relational_oper8;
            combo_val_.combination_value_(8)     := combo_.combination_value8;
            combo_val_.factor_no_(9) := 9;
            combo_val_.config_relational_oper_(9) := combo_.config_relational_oper9;
            combo_val_.combination_value_(9)     := combo_.combination_value9;
            combo_val_.factor_no_(10) := 10;
            combo_val_.config_relational_oper_(10) := combo_.config_relational_oper10;
            combo_val_.combination_value_(10)     := combo_.combination_value10;
            combo_val_.factor_no_(11) := 11;
            combo_val_.config_relational_oper_(11) := combo_.config_relational_oper11;
            combo_val_.combination_value_(11)     := combo_.combination_value11;
            combo_val_.factor_no_(12) := 12;
            combo_val_.config_relational_oper_(12) := combo_.config_relational_oper12;
            combo_val_.combination_value_(12)     := combo_.combination_value12;
            combo_val_.factor_no_(13) := 13;
            combo_val_.config_relational_oper_(13) := combo_.config_relational_oper13;
            combo_val_.combination_value_(13)     := combo_.combination_value13;
            combo_val_.factor_no_(14) := 14;
            combo_val_.config_relational_oper_(14) := combo_.config_relational_oper14;
            combo_val_.combination_value_(14)     := combo_.combination_value14;
            combo_val_.factor_no_(15) := 15;
            combo_val_.config_relational_oper_(15) := combo_.config_relational_oper15;
            combo_val_.combination_value_(15)     := combo_.combination_value15;

            -- Loop through the factors within a single combination record
            -- Build 'AND' statements by substituting factor test values into equations
            -- in form AND [FACTOR TEST VALUE] [REL OPER] [COMBINATION VALUE]
            -- Alpha factors required quotes around test and combination values.
            -- Null combination values are ignored, considered to match everything.

            parse_string_ := ' 1 = 1'; -- fixed clause for WHERE with ANDs appended
            fidx_          := 1;
            
            FOR fac_no_ IN 1..factor_.no_of_factors_ LOOP
               -- Get data type
               IF ( factor_.combo_value_(fidx_) IS NOT NULL) THEN
                  -- IF ALPHA, then put quotes around test value, else not.

                  IF ( factor_.config_data_type_db_(fidx_) = 'ALPHA' ) THEN
                     and_string1_ := ' AND ''' || factor_.combo_value_(fidx_) || '''';
                  ELSE
                     and_string1_ := ' AND '|| factor_.combo_value_(fidx_);
                  END IF;
               ELSE
                  and_string1_ := NULL;
               END IF;

               -- Retrieve associated factor rel operator and value, quoting appropriately
               -- Build AND clause
               Get_Combo_And_String___( and_string2_,
                                        factor_.factor_no_(fidx_),
                                        factor_.config_data_type_db_(fidx_),
                                        combo_val_ );

               -- Assemble parse string
               IF ( and_string1_ IS NOT NULL ) THEN
                  IF ( and_string2_ IS NOT NULL ) THEN
                     parse_string_ := parse_string_ || and_string1_ || and_string2_;
                  ELSE
                     and_string1_ := NULL;
                  END IF;
               ELSE
                  parse_string_ := NULL; -- parse_string_  will set to null when only one option value is set.
               END IF;

               fidx_ := fidx_ + 1;

            END LOOP;

            -- Check single assembled combination for TRUE/FALSE
            combination_valid_ := Check_Combo_Valid___(parse_string_);

            -- IF TRUE then RETURN these values and EXIT loop
            IF combination_valid_ THEN
               return_value_ := combo_.return_value;
               return_type_ := combo_.return_type;
               EXIT; --EXIT loop, when found the last combination matching the test values
            ELSE

               CASE Config_Price_Combination_API.Get_Config_Return_Type_Db(combination_id_) 
               WHEN  'AMOUNT' THEN
                  default_return_value_ := Config_Price_Combination_API.Get_Default_Return_Price(combination_id_);
                  return_type_ := 'AMOUNT';
               WHEN 'COMBINATION' THEN
                  default_return_value_ := Config_Price_Combination_API.Get_Default_Return_Combo(combination_id_);
                  return_type_ := 'COMBINATION';
               ELSE 
                  default_return_value_ := NULL;
                  return_type_ := 'AMOUNT';
               END CASE;


               IF ( default_return_value_ IS NOT NULL ) THEN
                  return_value_ := default_return_value_;   
               ELSE
                  return_value_ := NULL;
               END IF;
            END IF;
         END LOOP;
      ELSE
         -- all required factor values are not included in the configuration - return the default value.
         CASE Config_Price_Combination_API.Get_Config_Return_Type_Db(combination_id_) 
         WHEN  'AMOUNT' THEN
            return_value_ := Config_Price_Combination_API.Get_Default_Return_Price(combination_id_);
            return_type_ := 'AMOUNT';
         WHEN 'COMBINATION' THEN
            return_value_ := Config_Price_Combination_API.Get_Default_Return_Combo(combination_id_);
            return_type_ := 'COMBINATION';
         ELSE 
            return_value_ := NULL;
            return_type_ := 'AMOUNT';
         END CASE;

      END IF;
   END IF;   
END Validate_Combination___;

@IgnoreUnitTest NoOutParams
PROCEDURE Check_Connect_Combo_State___(
   combination_id_ IN VARCHAR2 )
IS
   objstate_      VARCHAR2(24);
BEGIN
   objstate_ := Config_Price_Combination_API.Get_State(combination_id_);
   IF objstate_= 'Obsolete' THEN
      Error_SYS.Record_General(lu_name_, 'COMBOVALNOTRELEASEDOBSOLETE: The connected price combination :P1 is in Obsolete status. Remove the connected price combination :P1.', combination_id_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'COMBOVALNOTRELEASED: The connected price combination :P1 is in Planned status. Release the connected price combination :P1 first.', combination_id_);
   END IF;  
END Check_Connect_Combo_State___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Is_Combo_Change_Allow
-- This function check if it allows to change the combination 
FUNCTION Is_Combo_Change_Allow  (
   combination_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_ CONFIG_PRICE_COMBINATION_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(combination_id_);
   IF rec_.rowstate IN ('Released','Obsolete') THEN
      RETURN FALSE;
   END IF;
   RETURN TRUE;
END Is_Combo_Change_Allow;

FUNCTION Wild_Card_Exist(
   value_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   IF (INSTR(value_, '%') = 0 AND INSTR(value_, '?') = 0) THEN
      RETURN  FALSE;
   ELSE
      RETURN  TRUE;
   END IF;
END Wild_Card_Exist;

PROCEDURE Test_Combination (
   return_value_   OUT VARCHAR2,
   return_type_    OUT VARCHAR2,
   sequence_       OUT NUMBER,
   combination_id_ IN VARCHAR2 )
IS
   num_                     NUMBER := 0;
   combination_valid_       BOOLEAN;
   default_return_value_    VARCHAR2(2000);
   at_least_one_test_value_ BOOLEAN := FALSE;
   factor_                  factor_type_;
   combo_val_               combo_value_type_;

   parse_string_   VARCHAR2(32000); -- The 'AND' string to be evaluated for a combination row
   fidx_           NUMBER;
   and_string1_    VARCHAR2(2000);
   and_string2_    VARCHAR2(2000);

   -- Note order clause means first combination evaluating to TRUE is
   -- the one returned.
   CURSOR get_combo_ IS
      SELECT *
      FROM CONFIG_PRICE_COMBO_VALUE_TAB
      WHERE combination_id = combination_id_
      ORDER BY sequence;

   CURSOR get_factor_ IS
      SELECT factor_no,
             test_value
      FROM   CONFIG_PRICE_COMBO_FACTOR_TAB
      WHERE  combination_id = combination_id_
      ORDER BY factor_no;

BEGIN
   IF ( Config_Price_Combo_Value_API.Get_Combo_Count(combination_id_) = 0 ) THEN
      Error_SYS.Record_General(lu_name_, 'NOTESTCOMB: At least one set of combination values must exist to test combination table.');
   END IF;
   -- Verify test values are all the same for duplicate occurrences of a factor.
   Config_Price_Combo_Factor_API.Check_Test_Values(combination_id_);
   -- Loop through factors load into array
   FOR fac_ IN get_factor_ LOOP
      num_ := num_ + 1;
      factor_.factor_no_(num_) := fac_.factor_no;
      factor_.config_data_type_db_(num_) := Config_Price_Combo_Factor_API.Get_Factor_Data_Type_Db(combination_id_,
                                                                                              fac_.factor_no );
      factor_.combo_value_(num_) := fac_.test_value;
      IF ( fac_.test_value IS NOT NULL) THEN
         at_least_one_test_value_ := TRUE;
      END IF;
   END LOOP;

   IF ( num_ = 0 ) THEN
      Error_SYS.Record_General(lu_name_, 'NOFACTOR: At least one factor must exist in combination table to test combination values.');
   END IF;

   IF NOT at_least_one_test_value_ THEN
      Error_SYS.Record_General(lu_name_, 'NOTESTVAL: At least one factor test value must be specified to test combination values.');
   END IF;
   factor_.no_of_factors_ := num_;

   -- Loop through combinations, load each record into array of factor values
   FOR combo_ IN get_combo_ LOOP

      -- Loads the values for a single combination value record into array of comparison values
      combo_val_.factor_no_(1) := 1;
      combo_val_.config_relational_oper_(1) := combo_.config_relational_oper1;
      combo_val_.combination_value_(1)     := combo_.combination_value1;
      combo_val_.factor_no_(2) := 2;
      combo_val_.config_relational_oper_(2) := combo_.config_relational_oper2;
      combo_val_.combination_value_(2)     := combo_.combination_value2;
      combo_val_.factor_no_(3) := 3;
      combo_val_.config_relational_oper_(3) := combo_.config_relational_oper3;
      combo_val_.combination_value_(3)     := combo_.combination_value3;
      combo_val_.factor_no_(4) := 4;
      combo_val_.config_relational_oper_(4) := combo_.config_relational_oper4;
      combo_val_.combination_value_(4)     := combo_.combination_value4;
      combo_val_.factor_no_(5) := 5;
      combo_val_.config_relational_oper_(5) := combo_.config_relational_oper5;
      combo_val_.combination_value_(5)     := combo_.combination_value5;
      combo_val_.factor_no_(6) := 6;
      combo_val_.config_relational_oper_(6) := combo_.config_relational_oper6;
      combo_val_.combination_value_(6)     := combo_.combination_value6;
      combo_val_.factor_no_(7) := 7;
      combo_val_.config_relational_oper_(7) := combo_.config_relational_oper7;
      combo_val_.combination_value_(7)     := combo_.combination_value7;
      combo_val_.factor_no_(8) := 8;
      combo_val_.config_relational_oper_(8) := combo_.config_relational_oper8;
      combo_val_.combination_value_(8)     := combo_.combination_value8;
      combo_val_.factor_no_(9) := 9;
      combo_val_.config_relational_oper_(9) := combo_.config_relational_oper9;
      combo_val_.combination_value_(9)     := combo_.combination_value9;
      combo_val_.factor_no_(10) := 10;
      combo_val_.config_relational_oper_(10) := combo_.config_relational_oper10;
      combo_val_.combination_value_(10)     := combo_.combination_value10;
      combo_val_.factor_no_(11) := 11;
      combo_val_.config_relational_oper_(11) := combo_.config_relational_oper11;
      combo_val_.combination_value_(11)     := combo_.combination_value11;
      combo_val_.factor_no_(12) := 12;
      combo_val_.config_relational_oper_(12) := combo_.config_relational_oper12;
      combo_val_.combination_value_(12)     := combo_.combination_value12;
      combo_val_.factor_no_(13) := 13;
      combo_val_.config_relational_oper_(13) := combo_.config_relational_oper13;
      combo_val_.combination_value_(13)     := combo_.combination_value13;
      combo_val_.factor_no_(14) := 14;
      combo_val_.config_relational_oper_(14) := combo_.config_relational_oper14;
      combo_val_.combination_value_(14)     := combo_.combination_value14;
      combo_val_.factor_no_(15) := 15;
      combo_val_.config_relational_oper_(15) := combo_.config_relational_oper15;
      combo_val_.combination_value_(15)     := combo_.combination_value15;

      -- Loop through the factors within a single combination record
      -- Build 'AND' statements by substituting factor test values into equations
      -- in form AND [FACTOR TEST VALUE] [REL OPER] [COMBINATION VALUE]
      -- Alpha factors required quotes around test and combination values.
      -- Null Test Values are ignored (not considered a factor)?
      -- Null combination values are ignored, considered to match everything.

      parse_string_ := ' 1 = 1'; -- fixed clause for WHERE with ANDs appended
      fidx_          := 1;

      FOR fac_no_ IN 1..factor_.no_of_factors_ LOOP
         -- Get data type
         IF ( factor_.combo_value_(fidx_) IS NOT NULL) THEN
            -- IF ALPHA, then put quotes around test value, else not.
            
            IF ( factor_.config_data_type_db_(fidx_) = 'ALPHA' ) THEN
               and_string1_ := ' AND ''' || factor_.combo_value_(fidx_) || '''';
            ELSE
               and_string1_ := ' AND '|| factor_.combo_value_(fidx_);
            END IF;
         ELSE
            and_string1_ := NULL;
         END IF;

         -- Retrieve associated factor rel operator and value, quoting appropriately
         -- Build AND clause      
         Get_Combo_And_String___( and_string2_,
                                  factor_.factor_no_(fidx_),
                                  factor_.config_data_type_db_(fidx_),
                                  combo_val_ );
                                                      
         -- Assemble parse string
         IF ( and_string1_ IS NOT NULL ) THEN
            IF ( and_string2_ IS NOT NULL ) THEN
               parse_string_ := parse_string_ || and_string1_ || and_string2_;
            ELSE
               and_string1_ := NULL;
            END IF;
         ELSE
            NULL; -- Do not add to the parse string in this case!
         END IF;
         
         fidx_ := fidx_ + 1;

      END LOOP;

      -- Check single assembled combination for TRUE/FALSE
      combination_valid_ := Check_Combo_Valid___(parse_string_);

      -- IF TRUE then RETURN these values and EXIT loop
      IF combination_valid_ THEN
         sequence_ := combo_.sequence;
         return_value_ := combo_.return_value;
         return_type_ := combo_.return_type;
         EXIT; --EXIT loop, when found the last combination matching the test values
      ELSE
         
         CASE Config_Price_Combination_API.Get_Config_Return_Type_Db(combination_id_) 
         WHEN  'AMOUNT' THEN
            default_return_value_ := Config_Price_Combination_API.Get_Default_Return_Price(combination_id_);
            return_type_ := 'AMOUNT';
         WHEN 'COMBINATION' THEN
            default_return_value_ := Config_Price_Combination_API.Get_Default_Return_Combo(combination_id_);
            return_type_ := 'COMBINATION';
         ELSE 
            default_return_value_ := NULL;
            return_type_ := 'AMOUNT';
         END CASE;
         
        
         IF ( default_return_value_ IS NOT NULL ) THEN
            return_value_ := default_return_value_;   
         ELSE
            return_value_ := NULL;
         END IF;
      END IF;
   END LOOP;
END Test_Combination;

@IgnoreUnitTest TrivialFunction
@UncheckedAccess
FUNCTION Validate_Combination (
   eval_rec_       IN Characteristic_Base_Price_API.config_price_comb_rec,
   combination_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   result_value_  VARCHAR2(32000);
   result_type_   VARCHAR2(200);
BEGIN
   Validate_Combination___(result_value_, result_type_, combination_id_, eval_rec_);
   
   IF result_type_ = 'COMBINATION' THEN
      RETURN Validate_Combination(eval_rec_, result_value_);
   ELSIF result_type_ = 'AMOUNT' THEN
      RETURN To_Number(result_value_);
   ELSE
      RETURN NULL;
   END IF;
END Validate_Combination;

