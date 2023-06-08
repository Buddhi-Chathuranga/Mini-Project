-----------------------------------------------------------------------------
--
--  Logical unit: ConfigPriceComboValue
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211008  PAMMLK  MF21R2-4520 - Created.
--  220127  INUMLK  MF21R2-6540 - Allowed combinationation values to insert, edit and delete in released status
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Sequence___ (
   combination_id_ IN  VARCHAR2 ) RETURN NUMBER
IS
   sequence_      NUMBER := 0;

   CURSOR get_next IS
    SELECT Nvl(MAX(Sequence), 0) + 1
    FROM   CONFIG_PRICE_COMBO_VALUE_TAB
    WHERE  combination_id = combination_id_;
   --
BEGIN
   OPEN get_next;
   FETCH get_next
    INTO sequence_;
   IF get_next%NOTFOUND THEN
      sequence_ := 1;
   END IF;
   CLOSE get_next;

   RETURN sequence_;
END Get_Next_Sequence___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Combination_No___ (
   combination_id_ IN  VARCHAR2 ) RETURN NUMBER
IS
   combination_no_      NUMBER := 0;

   CURSOR get_next IS
    SELECT Nvl(MAX(combination_no), 0) + 1
    FROM   CONFIG_PRICE_COMBO_VALUE_TAB
    WHERE  combination_id = combination_id_;
   --
BEGIN
   OPEN get_next;
   FETCH get_next
    INTO combination_no_;
   IF get_next%NOTFOUND THEN
      combination_no_ := 1;
   END IF;
   CLOSE get_next;

   RETURN combination_no_;
END Get_Combination_No___;

@IgnoreUnitTest NoOutParams
PROCEDURE Verify_Combination_Value___ (
   newrec_ IN config_price_combo_value_tab%ROWTYPE)
IS
   dummy_ NUMBER;
   CURSOR get_comb_value(combination_id_        IN VARCHAR2, combination_value1_    IN VARCHAR2, combination_value2_    IN VARCHAR2, combination_value3_    IN VARCHAR2,
                         combination_value4_    IN VARCHAR2, combination_value5_    IN VARCHAR2, combination_value6_    IN VARCHAR2, combination_value7_    IN VARCHAR2,
                         combination_value8_    IN VARCHAR2, combination_value9_    IN VARCHAR2, combination_value10_    IN VARCHAR2, combination_value11_    IN VARCHAR2,
                         combination_value12_    IN VARCHAR2,combination_value13_    IN VARCHAR2,combination_value14_    IN VARCHAR2, combination_value15_    IN VARCHAR2,
                         config_relational_oper1_   IN VARCHAR2, config_relational_oper2_   IN VARCHAR2, config_relational_oper3_   IN VARCHAR2, config_relational_oper4_   IN VARCHAR2,
                         config_relational_oper5_   IN VARCHAR2, config_relational_oper6_   IN VARCHAR2, config_relational_oper7_   IN VARCHAR2, config_relational_oper8_   IN VARCHAR2,
                         config_relational_oper9_   IN VARCHAR2, config_relational_oper10_   IN VARCHAR2, config_relational_oper11_   IN VARCHAR2, config_relational_oper12_   IN VARCHAR2,
                         config_relational_oper13_   IN VARCHAR2, config_relational_oper14_   IN VARCHAR2, config_relational_oper15_   IN VARCHAR2 ,return_type_ IN VARCHAR2,sequence_   IN NUMBER )   IS 
      SELECT 1 FROM Config_Price_Combo_Value t
      WHERE T.combination_id = combination_id_
      AND nvl(t.combination_value1, '*') = nvl(combination_value1_, '*')
      AND nvl(t.combination_value2, '*') = nvl(combination_value2_, '*')
      AND nvl(t.combination_value3, '*') = nvl(combination_value3_, '*')
      AND nvl(t.combination_value4, '*') = nvl(combination_value4_, '*')
      AND nvl(t.combination_value5, '*') = nvl(combination_value5_, '*')
      AND nvl(t.combination_value6, '*') = nvl(combination_value6_, '*')
      AND nvl(t.combination_value7, '*') = nvl(combination_value7_, '*')
      AND nvl(t.combination_value8, '*') = nvl(combination_value8_, '*')
      AND nvl(t.combination_value9, '*') = nvl(combination_value9_, '*')
      AND nvl(t.combination_value10, '*') = nvl(combination_value10_, '*')
      AND nvl(t.combination_value11, '*') = nvl(combination_value11_, '*')
      AND nvl(t.combination_value12, '*') = nvl(combination_value12_, '*')
      AND nvl(t.combination_value13, '*') = nvl(combination_value13_, '*')
      AND nvl(t.combination_value14, '*') = nvl(combination_value14_, '*')
      AND nvl(t.combination_value15, '*') = nvl(combination_value15_, '*')
      AND t.config_relational_oper1_db = config_relational_oper1_
      AND t.config_relational_oper2_db = config_relational_oper2_
      AND t.config_relational_oper3_db = config_relational_oper3_
      AND t.config_relational_oper4_db = config_relational_oper4_
      AND t.config_relational_oper5_db = config_relational_oper5_
      AND t.config_relational_oper6_db = config_relational_oper6_
      AND t.config_relational_oper7_db = config_relational_oper7_
      AND t.config_relational_oper8_db = config_relational_oper8_
      AND t.config_relational_oper9_db = config_relational_oper9_
      AND t.config_relational_oper10_db = config_relational_oper10_
      AND t.config_relational_oper11_db = config_relational_oper11_
      AND t.config_relational_oper12_db = config_relational_oper12_
      AND t.config_relational_oper13_db = config_relational_oper13_
      AND t.config_relational_oper14_db = config_relational_oper14_
      AND t.config_relational_oper15_db = config_relational_oper15_
      AND t.return_type_db = return_type_
      AND t.sequence <> sequence_;  
BEGIN
   OPEN get_comb_value (newrec_.combination_id,
                        newrec_.combination_value1, newrec_.combination_value2, newrec_.combination_value3, newrec_.combination_value4, newrec_.combination_value5, newrec_.combination_value6, 
                        newrec_.combination_value7, newrec_.combination_value8, newrec_.combination_value9, newrec_.combination_value10, newrec_.combination_value11, newrec_.combination_value12, 
                        newrec_.combination_value13, newrec_.combination_value14, newrec_.combination_value15,
                        newrec_.config_relational_oper1, newrec_.config_relational_oper2, newrec_.config_relational_oper3, newrec_.config_relational_oper4, newrec_.config_relational_oper5, 
                        newrec_.config_relational_oper6, newrec_.config_relational_oper7, newrec_.config_relational_oper8, newrec_.config_relational_oper9, newrec_.config_relational_oper10, 
                        newrec_.config_relational_oper11, newrec_.config_relational_oper12, newrec_.config_relational_oper13, newrec_.config_relational_oper14, newrec_.config_relational_oper15, newrec_.return_type,newrec_.sequence);
   FETCH get_comb_value INTO dummy_;
   IF get_comb_value%FOUND THEN
      CLOSE get_comb_value;
      Error_SYS.Record_General(lu_name_, 'DUPCOMBVAL: All combination rows must be unique.');
   ELSE
      CLOSE get_comb_value;
   END IF;
END Verify_Combination_Value___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER1',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER2',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER3',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER4',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER5',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER6',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER7',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER8',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER9',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER10',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER11',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER12',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER13',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER14',Config_Relational_Oper_API.Decode('='), attr_);
   Client_SYS.Add_To_Attr('CONFIG_RELATIONAL_OPER15',Config_Relational_Oper_API.Decode('='), attr_);
END Prepare_Insert___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Insert___ (
   newrec_ IN OUT config_price_combo_value_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);

   -- Make sure only valid attributes are populated and updates record.
   Validate_Factor_Values___(newrec_, attr_);
END Check_Insert___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Update___ (
   oldrec_ IN     config_price_combo_value_tab%ROWTYPE,
   newrec_ IN OUT config_price_combo_value_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   Error_SYS.Check_Not_Null(lu_name_, 'SEQUENCE', newrec_.sequence);

   IF newrec_.return_type != oldrec_.return_type THEN    
      IF newrec_.return_type = 'COMBINATION' THEN 
         Config_Price_Combination_API.Exist(newrec_.return_value);
      END IF;
   END IF;
   -- Make sure only valid attributes are populated and  updates record.
   Validate_Factor_Values___(newrec_, attr_);
END Check_Update___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CONFIG_PRICE_COMBO_VALUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Generate combination number
   newrec_.combination_no := Get_Combination_No___(newrec_.combination_id);
   Client_SYS.Add_To_Attr('COMBINATION_NO', newrec_.combination_no, attr_);

   -- Generate sequence if user does not specify.
   IF ( newrec_.sequence IS NULL ) THEN
      newrec_.sequence := Get_Next_Sequence___ (newrec_.combination_id);
      Client_SYS.Set_Item_Value('SEQUENCE', newrec_.sequence, attr_);
   END IF;

   super(objid_, objversion_, newrec_, attr_);
    Verify_Combination_Value___(newrec_);
END Insert___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     config_price_combo_value_tab%ROWTYPE,
   newrec_     IN OUT config_price_combo_value_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Verify_Combination_Value___(newrec_);
END Update___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Validate_Factor_Values___ (
   rec_ IN OUT CONFIG_PRICE_COMBO_VALUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   has_value_ BOOLEAN := FALSE;
BEGIN 
   IF ( rec_.combination_value1 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ (rec_.combination_value1, rec_.combination_id, 1);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE1', rec_.combination_value1, attr_);
   END IF;
   --
   IF ( rec_.combination_value2 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ (rec_.combination_value2, rec_.combination_id, 2);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE2', rec_.combination_value2, attr_);
   END IF;
   --
   IF ( rec_.combination_value3 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ (rec_.combination_value3, rec_.combination_id, 3);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE3', rec_.combination_value3, attr_);
   END IF;
   --
   IF ( rec_.combination_value4 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ (rec_.combination_value4, rec_.combination_id, 4);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE4', rec_.combination_value4, attr_);
   END IF;
   --
   IF ( rec_.combination_value5 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ (rec_.combination_value5, rec_.combination_id, 5);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE5', rec_.combination_value5, attr_);
   END IF;
   --
   IF ( rec_.combination_value6 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value6, rec_.combination_id, 6);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE6', rec_.combination_value6, attr_);
   END IF;
   --
   IF ( rec_.combination_value7 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value7, rec_.combination_id, 7);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE7', rec_.combination_value7, attr_);
   END IF;
   --
   IF ( rec_.combination_value8 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value8, rec_.combination_id, 8);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE8', rec_.combination_value8, attr_);
   END IF;
   --
   IF ( rec_.combination_value9 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value9, rec_.combination_id, 9);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE9', rec_.combination_value9, attr_);
   END IF;
   --
   IF ( rec_.combination_value10 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value10, rec_.combination_id, 10);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE10', rec_.combination_value10, attr_);
   END IF;
   --
   IF ( rec_.combination_value11 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value11, rec_.combination_id, 11);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE11', rec_.combination_value11, attr_);
   END IF;
   --
   IF ( rec_.combination_value12 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value12, rec_.combination_id, 12);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE12', rec_.combination_value12, attr_);
   END IF;
   --
   IF ( rec_.combination_value13 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value13, rec_.combination_id, 13);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE13', rec_.combination_value13, attr_);
   END IF;
   --
   IF ( rec_.combination_value14 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value14, rec_.combination_id, 14);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE14', rec_.combination_value14, attr_);
   END IF;
   --
   IF ( rec_.combination_value15 IS NOT NULL ) THEN
      has_value_ := TRUE;
      Validate_Factor_Value___ ( rec_.combination_value15, rec_.combination_id, 15);
      Client_SYS.Add_To_Attr('COMBINATION_VALUE15', rec_.combination_value15, attr_);
   END IF;
   --
   -- Make sure at least one column is populated.
   IF NOT ( has_value_ ) THEN
      Error_Sys.Record_General(lu_name_, 'NOCOMBVAL: At least one of the combination values must be specified.');
   END IF;
END Validate_Factor_Values___;

PROCEDURE Validate_Factor_Value___ (
   combination_value_ IN OUT VARCHAR2,
   combination_id_    IN VARCHAR2,
   factor_num_        IN NUMBER)
IS
   factor_value_          VARCHAR2(200);
   combination_value_chk_ VARCHAR2(2000);
BEGIN
   IF ( Config_Price_Combo_Factor_API.Factor_Exist(combination_id_, factor_num_) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'FACTOR: Combination value :P1 cannot be specified unless a corresponding factor is defined.', factor_num_);
   END IF;
   IF (NOT Config_Price_Combination_API.Wild_Card_Exist(combination_value_)) THEN
      IF ( Config_Price_Combo_Factor_API.Get_Factor_Data_Type_Db(combination_id_, factor_num_) = 'NUMERIC') THEN
         $IF Component_Cfgchr_SYS.INSTALLED $THEN
            IF (Config_Manager_API.Check_Numeric_Char_Value(combination_value_chk_) = 0) THEN
               factor_value_ := Config_Price_Combo_Factor_API.Get_Factor_Value(combination_id_, factor_num_);
               Error_SYS.Record_General(lu_name_, 'DTYPE: Combination value specified for factor :P1 must be numeric.', factor_value_ );
            END IF;
         $ELSE
            NULL;
         $END
      END IF;
      IF Config_Price_Combo_Factor_API.Get_Factor_Type_Db(combination_id_, factor_num_) = 'CHARVALUE' THEN
         factor_value_ := Config_Price_Combo_Factor_API.Get_Factor_Value(combination_id_, factor_num_);
         $IF Component_Cfgchr_SYS.INSTALLED $THEN
            IF Config_Characteristic_API.Get_Config_Value_Type_Db(factor_value_) IN ('DISCRETEOPTION', 'PACKAGE') THEN
               IF (Config_Fam_Option_Value_API.Check_Option_Value_Exist(Config_Price_Combination_API.Get_Config_Family_Id(combination_id_),
                                                                        factor_value_,
                                                                        combination_value_) = 0 ) THEN
                  Error_SYS.Record_General(lu_name_, 'INVALOPT: Combination value specified for factor :P1 does not exist.', factor_value_);
               END IF;
            END IF;
         $END
      END IF;
   END IF;   
END Validate_Factor_Value___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest DynamicStatement
FUNCTION Get_Config_Relational_Operator (
   combination_id_  IN VARCHAR2,
   combination_no_  IN NUMBER,
   factor_no_       IN NUMBER ) RETURN VARCHAR2 
IS
   display_factor_no_     NUMBER;
   relational_operator_   VARCHAR2(2000);
   temp_column_           VARCHAR2(2000);
   stmt_                  VARCHAR2(32000);
BEGIN
  display_factor_no_ := Config_Price_Combo_Factor_API.Get_Factor_No_By_Index(combination_id_, factor_no_);
  IF display_factor_no_ IS NOT NULL THEN 
     temp_column_ := 'config_relational_oper'||display_factor_no_||'_db';
     stmt_ :='SELECT '|| temp_column_ ||' INTO :combination_value FROM Config_Price_Combo_Value WHERE combination_id = ''' ||combination_id_||'''  AND combination_no = '||combination_no_;

     @ApproveDynamicStatement(2021-10-01,pammlk)
     EXECUTE IMMEDIATE stmt_ INTO relational_operator_;
  END IF;
  
  RETURN relational_operator_;
END Get_Config_Relational_Operator;

@IgnoreUnitTest DynamicStatement
FUNCTION Get_Combination_Value (
   combination_id_  IN VARCHAR2,
   combination_no_  IN NUMBER,
   factor_no_       IN NUMBER ) RETURN VARCHAR2 
IS
   display_factor_no_   NUMBER;
   combination_value_   VARCHAR2(2000);
   temp_column_         VARCHAR2(2000);
   stmt_                VARCHAR2(32000);
BEGIN
  display_factor_no_ := Config_Price_Combo_Factor_API.Get_Factor_No_By_Index(combination_id_, factor_no_);
  IF display_factor_no_ IS NOT NULL THEN 
     temp_column_ := 'combination_value'||display_factor_no_;
     stmt_ :='SELECT '|| temp_column_ ||' INTO :combination_value FROM Config_Price_Combo_Value WHERE combination_id = ''' ||combination_id_||'''  AND combination_no = '||combination_no_;
  
     @ApproveDynamicStatement(2021-10-04,pammlk)
     EXECUTE IMMEDIATE stmt_ INTO combination_value_;
  END IF;
  RETURN combination_value_;
END Get_Combination_Value;

@IgnoreUnitTest NoOutParams
PROCEDURE Check_Sequence_Unique (
   combination_id_ IN VARCHAR2 )
IS
   exist_ NUMBER;

   CURSOR get_combo IS
      SELECT rowid,
             sequence
      FROM CONFIG_PRICE_COMBO_VALUE_TAB
      WHERE combination_id = combination_id_;

   CURSOR check_exist (combination_id_ IN VARCHAR2,
                         sequence_ IN NUMBER,
                         objid_ IN ROWID) IS
      SELECT 1
      FROM   CONFIG_PRICE_COMBO_VALUE_TAB
      WHERE combination_id = combination_id_
      AND   sequence = sequence_
      AND   rowid <> objid_;
BEGIN
   FOR rec_ IN get_combo LOOP
      OPEN check_exist( combination_id_,
                          rec_.sequence,
                          rec_.rowid);
      FETCH check_exist INTO exist_;
      IF (check_exist%FOUND) THEN
         CLOSE check_exist;
         Error_SYS.Record_General(lu_name_, 'DUPSEQ: Combination sequence numbers must be unique. Sequence is already in use in this combination table.');
         EXIT;
      END IF;
      CLOSE check_exist;
   END LOOP;
END Check_Sequence_Unique;

@UncheckedAccess
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Combo_Count (
   combination_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER;

   CURSOR getcount IS
      SELECT count(*)
      FROM   CONFIG_PRICE_COMBO_VALUE_TAB
      WHERE  combination_id = combination_id_;
BEGIN
   OPEN getcount;
   FETCH getcount INTO count_;
   CLOSE getcount;
   RETURN count_;
END Get_Combo_Count;

@IgnoreUnitTest TrivialFunction
PROCEDURE Remove_Last_Factor (
   combination_id_ IN VARCHAR2 )
IS
   info_  VARCHAR2(2000);
   CURSOR getrec IS
   SELECT objid, objversion
      FROM  CONFIG_PRICE_COMBO_VALUE
      WHERE combination_id = combination_id_;
BEGIN
   -- Removes all data from combination table.
   FOR rec_ IN getrec LOOP
       Remove__ (info_, rec_.objid, rec_.objversion, 'DO');
   END LOOP;
END Remove_Last_Factor;

@IgnoreUnitTest DynamicStatement
PROCEDURE Remove_Factor (
   combination_id_ IN VARCHAR2,
   factor_no_ IN NUMBER )
IS
   ignore_        INTEGER;
   cid_           INTEGER;
   stmt_          VARCHAR2(2000);

   update_        VARCHAR2(50) := 'UPDATE CONFIG_PRICE_COMBO_VALUE_TAB ';
   set_           VARCHAR2(50) := 'SET combination_value'; -- column number to be appened here;
   equal_to_      VARCHAR2(50) := ' = NULL ';
   where_         VARCHAR2(50) := 'WHERE combination_id = :combination_id';

BEGIN

   -- Build UPDATE statement using factor no to determine column to be updated
   Assert_SYS.Assert_Is_Number(to_char(factor_no_));
   stmt_ := update_ || set_ || to_char(factor_no_) || equal_to_ || where_ ;

   cid_ := dbms_sql.open_cursor;
   @ApproveDynamicStatement(2021-11-02,pammlk)
   dbms_sql.parse ( cid_, stmt_, dbms_sql.native );
   dbms_sql.bind_variable(cid_, 'combination_id', combination_id_, 24);
   ignore_ := dbms_sql.execute ( cid_ );
   dbms_sql.close_cursor ( cid_ );

   EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      RAISE;
   END Remove_Factor;

@IgnoreUnitTest TrivialFunction
PROCEDURE Is_Connected_Combo_Released (
   all_released_    OUT NUMBER,
   return_combo_id_ OUT VARCHAR2,
   combination_id_  IN VARCHAR2 )
IS
  dummy_ VARCHAR2 (2000);

   CURSOR get_conn_combos_released IS
   SELECT return_value
     FROM Config_Price_Combo_Value_tab 
      WHERE combination_id = combination_id_
      AND (return_type = 'COMBINATION' AND Config_Price_Combination_API.Get_Objstate(return_value) != 'Released');

BEGIN

   OPEN get_conn_combos_released;
   FETCH get_conn_combos_released INTO dummy_;
   IF get_conn_combos_released%NOTFOUND THEN
      CLOSE get_conn_combos_released; 
      all_released_ := 1 ;  
   ELSE 
      CLOSE get_conn_combos_released;
      all_released_ := 0 ;
      return_combo_id_ := dummy_;
   END IF;
END Is_Connected_Combo_Released;

@IgnoreUnitTest TrivialFunction
PROCEDURE Is_Connected_to_Released_Combo (
   is_connected_    OUT NUMBER,
   return_combo_id_ OUT VARCHAR2,
   combination_id_  IN VARCHAR2 )
IS
  dummy_ VARCHAR2 (2000);

   CURSOR check_connect_to_released_combo IS
   SELECT combination_id
     FROM Config_Price_Combo_Value_tab 
      WHERE return_value = combination_id_
      AND (return_type = 'COMBINATION' AND Config_Price_Combination_API.Get_Objstate(combination_id) = 'Released');

BEGIN

   OPEN check_connect_to_released_combo;
   FETCH check_connect_to_released_combo INTO dummy_;
   IF check_connect_to_released_combo%FOUND THEN
      CLOSE check_connect_to_released_combo; 
      is_connected_ := 1 ;  
      return_combo_id_ := dummy_;
   ELSE 
      CLOSE check_connect_to_released_combo;
      is_connected_ := 0 ;
   END IF;
END Is_Connected_to_Released_Combo;