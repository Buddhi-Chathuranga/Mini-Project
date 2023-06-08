-----------------------------------------------------------------------------
--
--  Logical unit: ConfigPriceComboFactor
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211007  PAMMLK  MF21R2-4520 - Created.
--  220127  INUMLK  MF21R2-6540 - Allowed combinationation values to insert and delete in released status
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Factor_No___ (
   combination_id_ IN  VARCHAR2 ) RETURN NUMBER
IS
   factor_no_      NUMBER := 0;
BEGIN
   -- Responsible for locating first free factor in range from 1 to 15.
   -- IF none free within this range, than error.  Numbers outside of this
   -- range are also illegal, though should not exist.
   FOR i_ IN 1..15 LOOP
      -- IF factor exists, try next through fifteen.
      IF ( NOT Check_Exist___( combination_id_, i_ ) ) THEN
         factor_no_ := i_;
         EXIT;
      END IF;
   END LOOP;
   IF ( factor_no_ NOT IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15) ) THEN
      Error_SYS.Record_General(lu_name_, 'FIFTEENFAC:  Only fifteen combination factors can be defined for a combination table.');
   END IF;
   RETURN factor_no_;
END Get_Next_Factor_No___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Sequence___ (
   combination_id_ IN  VARCHAR2 ) RETURN NUMBER
IS
   next_sequence_no_ NUMBER := NULL;
BEGIN
   SELECT NVL(MAX(display_sequence), 0) + 1
   INTO   next_sequence_no_
   FROM   CONFIG_PRICE_COMBO_FACTOR_TAB
   WHERE  combination_id = combination_id_;
   
   RETURN next_sequence_no_;
END Get_Next_Sequence___;

PROCEDURE Validate_Factor_Data___ (
   test_value_ IN OUT VARCHAR2,
   combination_id_ IN VARCHAR2,
   factor_type_db_ IN  VARCHAR2,
   characteristic_id_ IN VARCHAR2)
IS
   config_data_type_db_ VARCHAR2(20);
   combo_family_id_ VARCHAR2(24);
BEGIN
   combo_family_id_ := Config_Price_Combination_API.Get_Config_Family_Id(combination_id_);
   IF ( factor_type_db_ = 'CHARVALUE' ) THEN
      -- Check required value populated
      IF ( characteristic_id_ IS NULL ) THEN
         Error_SYS.Record_General(lu_name_, 'CHARVALNUL: Characteristic Id must be specified for factors of type characteristic.');
      END IF;
      $IF Component_Cfgchr_SYS.INSTALLED $THEN
         -- Characteristic exist in combination table family?
         IF ( Config_Fam_Characteristic_API.Check_Characteristic_Exist(combo_family_id_,
                                                                       characteristic_id_ ) = 0 )  THEN
            Error_SYS.Record_General(lu_name_, 'FAMILYELEMENT: The characteristic :P1 does not exist in family :P2.', characteristic_id_, combo_family_id_);
         END IF;

         config_data_type_db_ := Config_Characteristic_API.Get_Config_Data_Type_Db( characteristic_id_);
         -- Check data type
         IF ( config_data_type_db_ = 'NUMERIC' ) THEN
            IF ( test_value_ IS NOT NULL ) THEN
               IF ( Config_Manager_API.Check_Numeric_Char_Value( test_value_ ) = 0 ) THEN
                  Error_SYS.Record_General(lu_name_, 'ILLCHARNUM: Test value for characteristic :P1 must be numeric.', characteristic_id_);
               END IF;
            END IF;
         END IF;
      $END
      
   ELSIF ( factor_type_db_ = 'CHARQTY' ) THEN
 
      IF ( characteristic_id_ IS NULL ) THEN
         Error_SYS.Record_General(lu_name_, 'CHARQTYNUL: Characteristic Id must be specified for factors of type characteristic quantity.');
      END IF;
      $IF Component_Cfgchr_SYS.INSTALLED $THEN
         -- Characteristic exist in combination table family?
         IF ( Config_Fam_Characteristic_API.Check_Characteristic_Exist(combo_family_id_,
                                                                       characteristic_id_ ) = 0 )  THEN
            Error_SYS.Record_General(lu_name_, 'FAMILYELEMENT: The characteristic :P1 does not exist in family :P2.', characteristic_id_, combo_family_id_);
         END IF;
         --
         IF ( test_value_ IS NOT NULL ) THEN
            IF ( Config_Manager_API.Check_Numeric_Char_Value( test_value_ ) = 0 ) THEN
               Error_SYS.Record_General(lu_name_, 'ILLQTYNUM: Test value for characteristic quantity of characteristic :P1 must be numeric.', characteristic_id_);
            END IF;
         END IF;
      $END
   END IF;
END Validate_Factor_Data___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Common___ (
   oldrec_ IN     config_price_combo_factor_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY config_price_combo_factor_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   config_family_id_ Config_Price_Combination_Tab.config_family_id%TYPE;
BEGIN
   
   IF newrec_.factor_type IS NOT NULL THEN
      Config_Price_Fact_Type_API.Exist_Db_Factors(newrec_.factor_type);
   END IF; 
   
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      IF indrec_.test_value THEN
         config_family_id_ := Config_Price_Combination_API.Get_Config_Family_Id(newrec_.combination_id);
         IF Config_Characteristic_API.Is_Discrete_Option(newrec_.characteristic_id) = 1 THEN
            IF (newrec_.factor_type != 'CHARQTY' AND Config_Fam_Option_Value_API.Check_Option_Value_Exist(config_family_id_,
                                                                      newrec_.characteristic_id,
                                                                      newrec_.test_value) = 0) THEN
                  Error_SYS.Record_General(lu_name_,'OPTERR: Discrete option value :P1 does not belong to the family :P2.',
                                           newrec_.test_value, config_family_id_);
            END IF;
         ELSIF Config_Characteristic_API.Is_Package_Option(newrec_.characteristic_id) = 1 THEN
            IF (newrec_.factor_type != 'CHARQTY' AND Config_Fam_Option_Value_API.Check_Option_Value_Exist(config_family_id_,
                                                                      newrec_.characteristic_id,
                                                                      newrec_.test_value) = 0) THEN
                  Error_SYS.Record_General(lu_name_,'OPTERRPKG: Package option value :P1 does not belong to the family :P2.',
                                           newrec_.test_value, config_family_id_);
            END IF;
         END IF;
      END IF;
   $END
  
   super(oldrec_, newrec_, indrec_, attr_);
   
END Check_Common___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Insert___ (
   newrec_ IN OUT config_price_combo_factor_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   factor_value_     VARCHAR2(2000);
   config_family_id_ Config_Price_Combination_Tab.config_family_id%TYPE;
BEGIN
   super(newrec_, indrec_, attr_);
   
   factor_value_ := Client_SYS.Get_Item_Value('FACTOR_VALUE', attr_);
  
   IF ( factor_value_ IS NOT NULL ) THEN
      IF (newrec_.factor_type = 'CHARVALUE' ) THEN
         newrec_.characteristic_id := factor_value_;
         $IF Component_Cfgchr_SYS.INSTALLED $THEN
            Config_Characteristic_API.Exist(newrec_.characteristic_id);
         $END
      ELSIF (newrec_.factor_type = 'CHARQTY' ) THEN
         newrec_.characteristic_id := factor_value_;
         $IF Component_Cfgchr_SYS.INSTALLED $THEN
            Config_Characteristic_API.Exist(newrec_.characteristic_id);
         $END
      ELSE
         Error_SYS.Record_General(lu_name_, 'INVALIDFAC:  Factor type :P1 is not supported.', newrec_.factor_type);
      END IF;
   END IF; 
   
   Validate_Factor_Data___ ( newrec_.test_value,
                             newrec_.combination_id,
                             newrec_.factor_type,
                             newrec_.characteristic_id);
                             
     -- check the validity of the configuration family characteristic     
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      config_family_id_ := Config_Price_Combination_API.Get_Config_Family_Id(newrec_.combination_id);
      IF newrec_.factor_type = 'CHARVALUE' OR newrec_.factor_type = 'CHARQTY' THEN
         Config_Fam_Characteristic_API.Exist(config_family_id_, newrec_.characteristic_id, TRUE);
         -- check the validity of the configuration family characteristic value.
         IF newrec_.factor_type != 'CHARQTY' AND newrec_.test_value IS NOT NULL
         AND (Config_Characteristic_API.Get_Config_Value_Type_Db(newrec_.characteristic_id) IN ('DISCRETEOPTION', 'PACKAGE'))  THEN 
              Config_Fam_Option_Value_API.Exist(config_family_id_, newrec_.characteristic_id, newrec_.test_value, TRUE);
         END IF;
      END IF; 
   $END 
END Check_Insert___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Update___ (
   oldrec_ IN     config_price_combo_factor_tab%ROWTYPE,
   newrec_ IN OUT config_price_combo_factor_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   config_family_id_    Config_Price_Combination_Tab.config_family_id%TYPE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'DISPLAY_SEQUENCE', newrec_.display_sequence);

   Validate_Factor_Data___ ( newrec_.test_value,
                             newrec_.combination_id,
                             newrec_.factor_type,
                             newrec_.characteristic_id);
                             
   $IF Component_Cfgchr_SYS.INSTALLED $THEN                         
      config_family_id_ := Config_Price_Combination_API.Get_Config_Family_Id(newrec_.combination_id);
      IF  newrec_.factor_type != 'CHARQTY' THEN
         -- check the validity of the configuration family characteristic value.
         IF newrec_.test_value IS NOT NULL 
         AND (Config_Characteristic_API.Get_Config_Value_Type_Db(newrec_.characteristic_id) IN ('DISCRETEOPTION', 'PACKAGE'))  THEN 
               Config_Fam_Option_Value_API.Exist(config_family_id_, newrec_.characteristic_id, newrec_.test_value, TRUE);
         END IF;
      END IF;
   $END
END Check_Update___;


@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CONFIG_PRICE_COMBO_FACTOR_TAB%ROWTYPE )
IS
   combination_id_      config_price_combo_factor_tab.combination_id%TYPE;
   factor_no_           config_price_combo_factor_tab.factor_no%TYPE;
BEGIN
   combination_id_ := remrec_.combination_id;
   factor_no_ := remrec_.factor_no;
   super(objid_, remrec_);
   
   IF ( Is_Last_Factor(combination_id_) = 1 ) THEN
      -- IF last factor, delete all rows
      Config_Price_Combo_Value_API.Remove_Last_Factor(combination_id_);
   ELSE
      -- Otherwise set the values for that factor to null
      Config_Price_Combo_Value_API.Remove_Factor(combination_id_, factor_no_);
   END IF;

END Delete___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CONFIG_PRICE_COMBO_FACTOR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Generate sequence if user does not specify.
   IF (newrec_.display_sequence IS NULL ) THEN
      newrec_.display_sequence := Get_Next_Sequence___ (newrec_.combination_id);
      Client_SYS.Add_To_Attr('DISPLAY_SEQUENCE', newrec_.display_sequence, attr_);
   END IF;

   -- Generate factor number.  which is used for checking count.
   newrec_.factor_no := Get_Next_Factor_No___ (newrec_.combination_id);
   Client_SYS.Add_To_Attr('FACTOR_NO', newrec_.factor_no, attr_);
   Client_SYS.Add_To_Attr('TEST_VALUE', newrec_.test_value, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Factor_Description (
   factor_type_ IN  VARCHAR2,
   factor_value_          IN  VARCHAR2 ) RETURN VARCHAR2
IS
   factor_type_db_ VARCHAR2(20);
   factor_description_       VARCHAR2(200);
   lang_code_                VARCHAR2(2) := Fnd_Session_API.Get_Language;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      factor_type_db_ := Config_Price_Fact_Type_API.Encode(factor_type_);
      -- Returns the factor description appropriate the factor type.
      IF ( factor_type_db_ IN ('CHARVALUE', 'CHARQTY') ) THEN
         factor_description_ := Config_Characteristic_API.Get_Description_For_Language(factor_value_, lang_code_);
      END IF;

      RETURN factor_description_;
   $ELSE
     RETURN NULL;
   $END 
END Get_Factor_Description;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Factor_No_By_Index (
   combination_id_ IN VARCHAR2,
   index_          IN NUMBER ) RETURN NUMBER
IS
   factor_no_ VARCHAR2(200);
   count_     NUMBER := 1;
   
   CURSOR get_factor IS
      SELECT factor_no
      FROM CONFIG_PRICE_COMBO_FACTOR
      WHERE combination_id = combination_id_
      ORDER BY display_sequence;
BEGIN
   FOR rec_ IN get_factor LOOP
      IF count_ = index_ THEN
         factor_no_ := rec_.factor_no;
         RETURN factor_no_;
      END IF;
      count_ := count_ +1;
   END LOOP;
   RETURN NULL;
END Get_Factor_No_By_Index;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Factor_Value_By_Index (
   combination_id_ IN VARCHAR2,
   index_          IN NUMBER ) RETURN VARCHAR2 
IS
   fact_val_ VARCHAR2(200);
   count_    NUMBER := 1;
   
   CURSOR get_factor_val IS
      SELECT factor_value
      FROM CONFIG_PRICE_COMBO_FACTOR
      WHERE combination_id = combination_id_
      ORDER BY display_sequence;
BEGIN
   
   FOR rec_ IN get_factor_val LOOP
      IF count_ = index_ THEN
         fact_val_ := rec_.factor_value;
         RETURN fact_val_;
      END IF;
      count_ := count_ +1;
   END LOOP;
   
   RETURN NULL;
END Get_Factor_Value_By_Index;

@UncheckedAccess
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Factor_Lov_Info (
   combination_id_ IN VARCHAR2,
   factor_no_      IN NUMBER,
   index_          IN NUMBER) RETURN VARCHAR2
IS
   lov_type_   VARCHAR2(20);
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      CURSOR get_lov_type IS
        SELECT DECODE(factor_type_db,
                      'CHARVALUE', Config_Characteristic_API.Get_Config_Value_Type_Db(Get_Factor_Value_By_Index(combination_id_, index_)),
                      'NONE') lov_type_
        FROM CONFIG_PRICE_COMBO_FACTOR
        WHERE combination_id = combination_id_
        AND factor_no = factor_no_;
   $END 
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      OPEN get_lov_type;
      FETCH get_lov_type INTO lov_type_;
      CLOSE get_lov_type;
      RETURN lov_type_;
  $ELSE
      RETURN NULL;
  $END
  
END Get_Factor_Lov_Info;

@UncheckedAccess
FUNCTION Get_Combination_Label (
   combination_id_ IN VARCHAR2,
   factor_no_      IN VARCHAR2) RETURN VARCHAR2
IS
   factor_type_db_   VARCHAR2(20);
   factor_value_               VARCHAR2(200);
   combination_label_          VARCHAR2(200);
 
   CURSOR get_action_cond_type IS
     SELECT factor_type_db,factor_value
     FROM CONFIG_PRICE_COMBO_FACTOR
     WHERE combination_id = combination_id_
     AND factor_no = factor_no_;
BEGIN
   OPEN get_action_cond_type;
   FETCH get_action_cond_type INTO factor_type_db_,factor_value_;
   CLOSE get_action_cond_type;
   IF factor_type_db_ = 'CHARQTY' THEN 
      combination_label_ := factor_value_|| ' ' || 'Qty';
   ELSE 
      combination_label_ := factor_value_;
   END IF ;
   RETURN combination_label_;
END Get_Combination_Label;

@IgnoreUnitTest NoOutParams
PROCEDURE Check_Test_Values (
   combination_id_ IN VARCHAR2 )
IS
  count_ NUMBER := 0;
  CURSOR get_factors IS
     SELECT 1
     FROM CONFIG_PRICE_COMBO_FACTOR
     WHERE combination_id = combination_id_
     GROUP BY factor_type_db, factor_value
     HAVING MIN(NVL(test_value, 'XYZ123abc')) != MAX (NVL(test_value, 'XYZ123abc'));

BEGIN
   OPEN get_factors;
   FETCH get_factors INTO count_;
   CLOSE get_factors;
   IF (count_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'TESTVALERR: Must use the same test value for all occurrences of a combination factor.  Correct this before testing the table.');
   END IF;
END Check_Test_Values;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Factor_Value (
   combination_id_ IN VARCHAR2,
   factor_no_ IN NUMBER ) RETURN STRING
IS
   factor_val_ VARCHAR2(200);
   CURSOR get_fact_val IS
      SELECT factor_value
      FROM CONFIG_PRICE_COMBO_FACTOR
      WHERE combination_id = combination_id_
      AND factor_no = factor_no_;
BEGIN
   OPEN get_fact_val;
   FETCH get_fact_val INTO factor_val_;
   IF (get_fact_val%FOUND) THEN
      CLOSE get_fact_val;
      RETURN factor_val_;
   END IF;
   CLOSE get_fact_val;
   RETURN NULL;
END Get_Factor_Value;


FUNCTION Get_Factor_Data_Type_Db (
   combination_id_ IN VARCHAR2,
   factor_no_ IN NUMBER ) RETURN STRING
IS
   factor_type_db_ VARCHAR2(20);
   factor_value_   VARCHAR2(200);
   fact_data_type_ VARCHAR2(20);
BEGIN
   factor_type_db_ := Get_Factor_Type_Db(combination_id_, factor_no_);
   factor_value_   := Get_Factor_Value(combination_id_, factor_no_);
   IF ( factor_type_db_ = 'CHARQTY' ) THEN
      fact_data_type_ := 'NUMERIC';
   ELSIF (factor_type_db_ = 'CHARVALUE' ) THEN
      $IF Component_Cfgchr_SYS.INSTALLED $THEN
         fact_data_type_ :=  Config_Characteristic_API.Get_Config_Data_Type_Db(factor_value_);
      $ELSE
        fact_data_type_ := NULL;
      $END
   ELSE
     fact_data_type_ := NULL;
   END IF;
   RETURN fact_data_type_;
END Get_Factor_Data_Type_Db;

@IgnoreUnitTest TrivialFunction
FUNCTION Is_Last_Factor (
   combination_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER;

   CURSOR getcount IS
      SELECT count(*)
      FROM   CONFIG_PRICE_COMBO_FACTOR_TAB
      WHERE  combination_id = combination_id_;
BEGIN
   OPEN getcount;
   FETCH getcount INTO count_;
   CLOSE getcount;

   IF (count_ = 1) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Last_Factor;

@IgnoreUnitTest NoOutParams
FUNCTION Factor_Exist (
   combination_id_ IN VARCHAR2,
   factor_no_ IN NUMBER ) RETURN NUMBER
IS
   dummy_ NUMBER;
BEGIN
   IF (NOT Check_Exist___(combination_id_, factor_no_)) THEN
      dummy_ := 0;
   ELSE
      dummy_ := 1;
   END IF;
   RETURN dummy_;
END Factor_Exist;