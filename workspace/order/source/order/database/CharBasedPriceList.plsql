-----------------------------------------------------------------------------
--
--  Logical unit: CharBasedPriceList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211117  PAMMLK  MF21R2-4888, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@IgnoreUnitTest TrivialFunction
FUNCTION Get_Next_Price_Line_No___ (
   price_list_no_ IN  VARCHAR2 ) RETURN NUMBER
IS
   next_price_line_no_ NUMBER := NULL;
BEGIN
   SELECT NVL(MAX(price_line_no), 0) + 1
   INTO   next_price_line_no_
   FROM   CHAR_BASED_PRICE_LIST_TAB
   WHERE  price_list_no = price_list_no_;
   
   RETURN next_price_line_no_;
END Get_Next_Price_Line_No___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Validate_Break_Type___ (
   newrec_ IN OUT CHAR_BASED_PRICE_LIST_TAB%ROWTYPE,
   insert_ IN     BOOLEAN DEFAULT TRUE )
IS
   dummy_            NUMBER;

   CURSOR CheckMinimumValue IS
      SELECT 1
      FROM CHAR_BASED_PRICE_LIST_TAB
      WHERE minimum_value = newrec_.minimum_value
        AND quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND config_family_id = newrec_.config_family_id
        AND characteristic_id = newrec_.characteristic_id
        AND price_list_no = newrec_.price_list_no
        AND price_line_no = newrec_.price_line_no;

   CURSOR CheckMaximumValue IS
      SELECT 1
      FROM CHAR_BASED_PRICE_LIST_TAB
      WHERE maximum_value = newrec_.maximum_value
        AND quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND config_family_id = newrec_.config_family_id
        AND characteristic_id = newrec_.characteristic_id
        AND price_list_no = newrec_.price_list_no
        AND price_line_no = newrec_.price_line_no;

   CURSOR GetBreakLineNo IS
      SELECT MAX( break_line_no )
      FROM CHAR_BASED_PRICE_LIST_TAB
      WHERE quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND characteristic_id = newrec_.characteristic_id
        AND config_family_id = newrec_.config_family_id
        AND characteristic_id = newrec_.characteristic_id
        AND price_list_no = newrec_.price_list_no
        AND price_line_no = newrec_.price_line_no;
BEGIN

   IF (newrec_.price_break_type = 'NONE') THEN
      -- No minimum_value or maximum_value are authorized
      IF ( newrec_.minimum_value IS NOT NULL ) OR ( newrec_.maximum_value IS NOT NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE1: No value in minimum or maximum are allowed when break price type for characteristic :P1 is set to None.',newrec_.characteristic_id);
      ELSE
         IF insert_ THEN
            newrec_.break_line_no := 0;
         END IF;
      END IF;
   ELSIF (newrec_.price_break_type  = 'MIN') THEN
      -- Check minimum_value
      IF ( newrec_.minimum_value IS NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE2: A minimum value is required when break price type for characteristic :P1 is set to Minimum.',newrec_.characteristic_id);
      END IF;

      -- Check maximum_value
      IF ( newrec_.maximum_value IS NOT NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE3: A maximum value is not allowed when break price type for characteristic :P1 is set to Minimum.',newrec_.characteristic_id);
      END IF;

      IF insert_ THEN
         -- Test unicity
         OPEN CheckMinimumValue;
         FETCH CheckMinimumValue INTO dummy_;
         IF CheckMinimumValue%FOUND THEN
            Error_SYS.Record_Exist(lu_name_);
         END IF;
         CLOSE CheckMinimumValue;

         -- Get new break_line_no
         OPEN GetBreakLineNo;
         FETCH GetBreakLineNo INTO newrec_.break_line_no;
         CLOSE GetBreakLineNo;
         IF newrec_.break_line_no IS NULL THEN
            newrec_.break_line_no := 0;
         ELSE
            newrec_.break_line_no := newrec_.break_line_no + 1;
         END IF;
      END IF;
   ELSE -- 'MAX'
      -- Check maximum_value
      IF ( newrec_.maximum_value IS NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE4: A maximum value is required when break price type for characteristic :P1 is set to Maximum.',newrec_.characteristic_id);
      END IF;

      -- Check minimum_value
      IF ( newrec_.minimum_value IS NOT NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE5: A minimum value is not allowed when break price type for characteristic :P1 is set to Maximum.',newrec_.characteristic_id);
      END IF;

      IF insert_  THEN
         -- Test unicity
         OPEN CheckMaximumValue;
         FETCH CheckMaximumValue INTO dummy_;
         IF CheckMaximumValue%FOUND THEN
            Error_SYS.Record_Exist(lu_name_);
         END IF;
         CLOSE CheckMaximumValue;

         -- Get new break_line_no
         OPEN GetBreakLineNo;
         FETCH GetBreakLineNo INTO newrec_.break_line_no;
         CLOSE GetBreakLineNo;
         IF newrec_.break_line_no IS NULL THEN
            newrec_.break_line_no := 0;
         ELSE
            newrec_.break_line_no := newrec_.break_line_no + 1;
         END IF;
      END IF;
   END IF;
END Validate_Break_Type___;

@IgnoreUnitTest TrivialFunction
FUNCTION Check_Char_Family_Exist___ (
   newrec_ IN  char_based_price_list_tab%ROWTYPE ) RETURN BOOLEAN
IS
   exist_ NUMBER ;
   
   CURSOR is_char_family_exist IS
      SELECT 1
      FROM CHAR_BASED_PRICE_LIST_TAB
      WHERE config_family_id = newrec_.config_family_id
        AND characteristic_id = newrec_.characteristic_id
        AND price_list_no = newrec_.price_list_no
        AND valid_from_date = newrec_.valid_from_date
        AND ((newrec_.price_break_type = 'MIN' AND  minimum_value = newrec_.minimum_value) OR (newrec_.price_break_type = 'MAX' AND  maximum_value = newrec_.maximum_value) OR (newrec_.price_break_type = 'NONE')) ;
BEGIN
   OPEN is_char_family_exist;
   FETCH is_char_family_exist INTO exist_;
   IF is_char_family_exist%FOUND THEN
      CLOSE is_char_family_exist;
      RETURN TRUE;
   ELSE 
      CLOSE is_char_family_exist;
      RETURN FALSE;
   END IF;
END Check_Char_Family_Exist___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', TRUNC(SYSDATE), attr_ );
   Client_SYS.Add_To_Attr('OFFSET_VALUE', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT', '0', attr_ );
   Client_SYS.Add_To_Attr('PRICE_BREAK_TYPE_DB', 'NONE', attr_ );
   Client_SYS.Add_To_Attr('QUANTITY_BREAK', '0', attr_ );
   Client_SYS.Add_To_Attr('PRICE_SEARCH_DB', 'CONTINUE', attr_ );
   Client_SYS.Add_To_Attr('CHAR_QTY_PRICE_METHOD_DB', 'NO', attr_);
   Client_SYS.Add_To_Attr('ALLOW_OVERRIDE_DB', 'TRUE', attr_ );
END Prepare_Insert___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Common___ (
   oldrec_ IN     char_based_price_list_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY char_based_price_list_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
           
   CURSOR is_price_break_min IS
     SELECT 1
      FROM CHAR_BASED_PRICE_LIST_TAB
      WHERE config_family_id = newrec_.config_family_id
        AND characteristic_id = newrec_.characteristic_id
        AND price_list_no = newrec_.price_list_no
        AND valid_from_date = newrec_.valid_from_date
        AND price_break_type = 'MIN';
        
   CURSOR is_price_break_max IS
     SELECT 1
      FROM CHAR_BASED_PRICE_LIST_TAB
      WHERE config_family_id = newrec_.config_family_id
        AND characteristic_id = newrec_.characteristic_id
        AND price_list_no = newrec_.price_list_no
        AND valid_from_date = newrec_.valid_from_date
        AND price_break_type = 'MAX';
      dummy_  NUMBER;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.allow_override = 'FALSE' THEN
      newrec_.max_override_percent := NULL;
   END IF;
   -- if atleast one record has price_break_type as Minimum it will only allow to add minimum as price break type for all other records.
   OPEN is_price_break_min;
   FETCH is_price_break_min INTO dummy_;
   IF is_price_break_min%FOUND THEN
      CLOSE is_price_break_min;
      IF (oldrec_.price_break_type = 'MAX' OR newrec_.price_break_type = 'MAX') THEN 
         Error_SYS.Record_General( lu_name_, 'VALIDMINONLY: For Characteristic :P1 Price Break Type can only be Minimum as Minimum is used.',newrec_.characteristic_id);
      END IF;
   ELSE 
      CLOSE is_price_break_min;
   END IF;
   
   -- if atleast one record has price_break_type as Maximum it will only allow to add maximum as price break type for all other records.
   OPEN is_price_break_max;
   FETCH is_price_break_max INTO dummy_;
   IF is_price_break_max%FOUND THEN
      CLOSE is_price_break_max;
      IF (oldrec_.price_break_type = 'MIN' OR newrec_.price_break_type = 'MIN')THEN 
          Error_SYS.Record_General( lu_name_, 'VALIDMAXONLY: For Characteristic :P1 Price Break Type can only be Maximum as Maximum is used.',newrec_.characteristic_id);
      END IF;
   ELSE 
      CLOSE is_price_break_max;
   END IF;

END Check_Common___;

@Override
@IgnoreUnitTest DynamicStatement
PROCEDURE Check_Insert___ (
   newrec_ IN OUT char_based_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.valid_from_date := Trunc(newrec_.valid_from_date);
   super(newrec_, indrec_, attr_);
   Validate_Break_Type___(newrec_);
   IF (Check_Char_Family_Exist___(newrec_))THEN
      Error_SYS.Record_General( lu_name_, 'CHARFAMILYEXIST: Characteristic :P1 already exist for Configuration Family :P2',newrec_.characteristic_id,newrec_.config_family_id);
   END IF;
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
END Check_Insert___;


@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Update___ (
   oldrec_ IN     char_based_price_list_tab%ROWTYPE,
   newrec_ IN OUT char_based_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Validate_Break_Type___( newrec_, FALSE );
   IF ((oldrec_.price_break_type != newrec_.price_break_type OR oldrec_.maximum_value != newrec_.maximum_value OR oldrec_.minimum_value != newrec_.minimum_value) AND Check_Char_Family_Exist___(newrec_)) THEN
      Error_SYS.Record_General( lu_name_, 'CHARFAMILYEXIST: Characteristic :P1 already exist for Configuration Family :P2',newrec_.characteristic_id,newrec_.config_family_id);
   END IF;
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
END Check_Update___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Delete___ (
   remrec_ IN CHAR_BASED_PRICE_LIST_TAB%ROWTYPE )
IS
BEGIN
   Sales_Price_List_API.Check_Editable(remrec_.price_list_no);
   super(remrec_);
END Check_Delete___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CHAR_BASED_PRICE_LIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   
   newrec_.price_line_no := Get_Next_Price_Line_No___ (newrec_.price_list_no);
   Client_SYS.Add_To_Attr('PRICE_LINE_NO', newrec_.price_line_no, attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CHAR_BASED_PRICE_LIST_TAB%ROWTYPE )
IS

   dummy_ NUMBER;

   CURSOR exist_more_lines IS
      SELECT count(*)
      FROM  CHAR_BASED_PRICE_LIST_TAB
      WHERE price_list_no = remrec_.price_list_no
      AND   config_family_id = remrec_.config_family_id
      AND   characteristic_id = remrec_.characteristic_id
      AND   price_line_no = remrec_.price_line_no;

BEGIN
   OPEN exist_more_lines;
   FETCH exist_more_lines INTO dummy_;
   IF (dummy_ = 1) THEN
      CLOSE exist_more_lines;
      Char_Based_Opt_Price_List_API.Delete_Option_Values(remrec_.price_list_no,
                                                       remrec_.config_family_id,
                                                       remrec_.characteristic_id,
                                                       remrec_.price_line_no );
   ELSE
      CLOSE exist_more_lines;
   END IF;
   super(objid_, remrec_);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_Valid_Price_List
--   Check the Validity of the price list
@IgnoreUnitTest TrivialFunction
FUNCTION Is_Valid_Price_List (
   price_list_no_     IN VARCHAR2,
   characteristic_id_ IN VARCHAR2,
   contract_          IN VARCHAR2,
   currency_code_     IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   validity_date_     IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   config_family_id_ VARCHAR2(24);
   found_            VARCHAR2(5) := 'FALSE';
   date_             DATE;

   CURSOR exist_control IS
      SELECT 'TRUE'
      FROM char_based_price_list_tab
      WHERE config_family_id = config_family_id_ 
      AND price_list_no = price_list_no_
      AND characteristic_id = characteristic_id_;
BEGIN

   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      config_family_id_ := Config_Part_Catalog_API.Get_Config_Family_Id(Sales_Part_API.Get_Part_No(contract_,catalog_no_));
   $END

   IF (validity_date_ IS NULL)  THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := validity_date_;
   END IF;
   -- Check that price list is valid
   IF (Sales_Price_List_API.Is_Valid( price_list_no_, contract_, catalog_no_, date_ )
      OR Sales_Price_List_API.Is_Valid_Assort( price_list_no_, contract_, catalog_no_, date_ )) THEN
      OPEN exist_control;
      FETCH exist_control INTO found_;
      IF exist_control%NOTFOUND THEN
         found_ := 'FALSE';
      END IF;
      CLOSE exist_control;
   END IF;
   RETURN found_;
END Is_Valid_Price_List;

@IgnoreUnitTest TrivialFunction
FUNCTION Check_Record_Exist(
   config_family_id_ IN VARCHAR2,
   characteristic_id_ IN VARCHAR2,
   price_list_no_ IN VARCHAR2) RETURN BOOLEAN
IS
   exist_ NUMBER ;
   
   CURSOR is_record_exist IS
      SELECT 1
      FROM CHAR_BASED_PRICE_LIST_TAB
      WHERE config_family_id = config_family_id_
        AND characteristic_id = characteristic_id_
        AND price_list_no = price_list_no_;
BEGIN
   OPEN is_record_exist;
   FETCH is_record_exist INTO exist_;
   IF is_record_exist%FOUND THEN
      CLOSE is_record_exist;
      RETURN TRUE;
   ELSE 
      CLOSE is_record_exist;
      RETURN FALSE;
   END IF;
END Check_Record_Exist;

-- Get_Price_List_Infos
--   Return information from Price List.
PROCEDURE Get_Price_List_Infos (
   offset_value_        OUT NUMBER,
   fixed_amount_        OUT NUMBER,
   fixed_amt_incl_tax_  OUT NUMBER,
   multiply_by_qty_     OUT VARCHAR2,
   stop_price_search_   OUT VARCHAR2,
   price_list_no_       IN  VARCHAR2,
   characteristic_id_   IN  VARCHAR2,
   char_value_          IN  NUMBER,
   char_qty_            IN  NUMBER,
   contract_            IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   validity_date_       IN  DATE DEFAULT NULL,
   eval_rec_            IN  Characteristic_Base_Price_API.config_price_comb_rec DEFAULT NULL)
IS
   date_                 DATE;
   i_break_value_        NUMBER := NVL(char_value_, 0);
   i_quantity_break_     NUMBER := NVL(char_qty_, 1);
   found_                BOOLEAN;
   max_qty_break_        NUMBER := 0;
   price_search_method_  VARCHAR2(20);
   config_family_id_     VARCHAR2(24);
   combination_id_       VARCHAR2(24);
   retrieved_price_type_ VARCHAR2(20);
   config_combo_price_   NUMBER;
   use_price_incl_tax_db_  VARCHAR2(20);
   tax_calc_base_          VARCHAR2(20);
   ifs_curr_rounding_      NUMBER := 16;

   CURSOR get_price_search_method  IS
      SELECT price_break_type
      FROM char_based_price_list_tab
      WHERE config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_;
      
   CURSOR get_min_value IS
      SELECT offset_value, fixed_amount, char_qty_price_method, price_search,combination_id,retrieved_price_type
      FROM char_based_price_list_tab
      WHERE minimum_value <= i_break_value_
      AND quantity_break <= i_quantity_break_
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT offset_value, fixed_amount, char_qty_price_method, price_search,combination_id,retrieved_price_type
      FROM char_based_price_list_tab
      WHERE maximum_value >= i_break_value_
      AND quantity_break <= i_quantity_break_
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT offset_value, fixed_amount, char_qty_price_method, price_search,combination_id,retrieved_price_type
      FROM char_based_price_list_tab
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY valid_from_date DESC;

   CURSOR get_max_qty_break (date_ IN DATE) IS
      SELECT MAX(quantity_break)
      FROM char_based_price_list_tab
      WHERE quantity_break <= i_quantity_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_;
BEGIN

   IF (validity_date_ IS NULL) THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := validity_date_;
   END IF;

   date_ := Trunc(date_);
   
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      config_family_id_ := Config_Part_Catalog_API.Get_Config_Family_Id(Sales_Part_API.Get_Part_No(contract_,catalog_no_));
   $END
   OPEN get_price_search_method;
   FETCH get_price_search_method INTO price_search_method_;
   CLOSE get_price_search_method;
   
   Trace_SYS.Field('PRICE_SEARCH_METHOD', price_search_method_);

   IF (price_search_method_ ='MIN') THEN

      OPEN get_min_value;
      FETCH get_min_value INTO offset_value_, fixed_amount_, multiply_by_qty_, stop_price_search_,combination_id_,retrieved_price_type_;
      found_ := get_min_value%FOUND;
      CLOSE get_min_value;
   ELSIF (price_search_method_ = 'MAX') THEN

      OPEN get_max_value;
      FETCH get_max_value INTO offset_value_, fixed_amount_, multiply_by_qty_, stop_price_search_,combination_id_,retrieved_price_type_;
      found_ := get_max_value%FOUND;
      CLOSE get_max_value;
   ELSIF (price_search_method_ = 'NONE') THEN
      -- find first valid break group with largest break qty
      OPEN get_max_qty_break(date_);
      FETCH get_max_qty_break INTO max_qty_break_;
      CLOSE get_max_qty_break;

      OPEN get_none_value;
      FETCH get_none_value INTO offset_value_, fixed_amount_, multiply_by_qty_, stop_price_search_,combination_id_,retrieved_price_type_;
      found_ := get_none_value%FOUND;
      CLOSE get_none_value;
   END IF;

   IF found_ THEN
      use_price_incl_tax_db_ := Sales_Price_List_API.Get_Use_Price_Incl_Tax_Db(price_list_no_);
      IF (combination_id_ IS NOT NULL) THEN 
         config_combo_price_ := Config_Price_Combination_API.Validate_Combination(eval_rec_,combination_id_);
         IF use_price_incl_tax_db_ = 'TRUE' THEN
            tax_calc_base_ := 'GROSS_BASE';
            Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(fixed_amt_incl_tax_, 
                                                              fixed_amount_, 
                                                              contract_, 
                                                              catalog_no_, 
                                                              tax_calc_base_, 
                                                              ifs_curr_rounding_);
            IF retrieved_price_type_ = 'AddOn' THEN 
                fixed_amt_incl_tax_ := fixed_amt_incl_tax_ +  NVL(config_combo_price_, 0);
            ELSE 
               -- Replace only if price is not null.
               fixed_amt_incl_tax_ :=  NVL(config_combo_price_, fixed_amt_incl_tax_) ;
               offset_value_ := 0;
            END IF; 
         ELSE 
            IF retrieved_price_type_ = 'AddOn' THEN 
               fixed_amount_ := fixed_amount_ + NVL(config_combo_price_, 0);
               offset_value_ := offset_value_;
            ELSE 
               -- Replace only if price is not null.
               fixed_amount_ := NVL(config_combo_price_, fixed_amount_) ;
               offset_value_ := 0;
            END IF; 
         END IF; 
      ELSE 
         IF use_price_incl_tax_db_ = 'TRUE' THEN
            tax_calc_base_ := 'GROSS_BASE';
            Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(fixed_amt_incl_tax_, 
                                                           fixed_amount_, 
                                                           contract_, 
                                                           catalog_no_, 
                                                           tax_calc_base_, 
                                                           ifs_curr_rounding_); 
         END IF; 
      END IF;
   ELSE 
      offset_value_ := NULL;
      fixed_amount_ := NULL;
      fixed_amt_incl_tax_ := NULL;
      multiply_by_qty_ := NULL;
      stop_price_search_ := NULL;
   END IF;
END Get_Price_List_Infos;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Price_Combination_Id (
   price_combination_id_ OUT  VARCHAR2,
   price_list_no_        IN   VARCHAR2,
   characteristic_id_    IN   VARCHAR2,
   contract_             IN   VARCHAR2,
   catalog_no_           IN   VARCHAR2,
   characteristic_value_ IN   VARCHAR2,
   quantity_             IN   NUMBER,
   date_                 IN   DATE)
IS
   price_break_type_ VARCHAR2(20);
   char_value_       VARCHAR2(2000);
   max_qty_break_    NUMBER := 0;
   break_value_      NUMBER := 0;
   config_family_id_ VARCHAR2(24);
   
   CURSOR get_price_search_method  IS
      SELECT price_break_type
      FROM char_based_price_list_tab
      WHERE config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_;
   
   CURSOR get_min_value IS
      SELECT combination_id
      FROM char_based_price_list_tab
      WHERE minimum_value <= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT combination_id
      FROM char_based_price_list_tab
      WHERE maximum_value >= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT combination_id
      FROM char_based_price_list_tab
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY valid_from_date DESC;
      
   CURSOR get_max_qty_break (date_ IN DATE) IS
      SELECT MAX(quantity_break)
      FROM char_based_price_list_tab
      WHERE quantity_break <= Nvl(quantity_, 1)
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_;
      
BEGIN
   
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      config_family_id_ := Config_Part_Catalog_API.Get_Config_Family_Id(Sales_Part_API.Get_Part_No(contract_,catalog_no_));
      IF Config_Characteristic_API.Get_Config_Data_Type_Db(characteristic_id_) = 'NUMERIC' THEN
         char_value_ := characteristic_value_;
         IF Config_Manager_API.Check_Numeric_Char_Value(char_value_) = 1 THEN
            break_value_ := To_Number(char_value_);
         END IF;
      END IF;
   $END
   OPEN get_price_search_method;
   FETCH get_price_search_method INTO price_break_type_;
   CLOSE get_price_search_method;
   
   IF (price_break_type_ = 'MIN') THEN
      OPEN get_min_value;
      FETCH get_min_value INTO price_combination_id_;
      CLOSE get_min_value;
   ELSIF (price_break_type_ = 'MAX') THEN
      OPEN get_max_value;
      FETCH get_max_value INTO price_combination_id_;
      CLOSE get_max_value;
   ELSIF (price_break_type_ = 'NONE') THEN
      -- find first valid break group with largest break qty
      OPEN get_max_qty_break(date_);
      FETCH get_max_qty_break INTO max_qty_break_;
      CLOSE get_max_qty_break;

      OPEN get_none_value;
      FETCH get_none_value INTO price_combination_id_;
      CLOSE get_none_value;
   ELSE
      price_combination_id_ := NULL;
   END IF;
END Get_Price_Combination_Id;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Allowed_Override_Percent (
   allow_override_       OUT VARCHAR2,
   max_override_percent_ OUT NUMBER,
   price_list_no_        IN  VARCHAR2,
   config_family_id_     IN  VARCHAR2,
   characteristic_id_    IN  VARCHAR2,
   characteristic_value_ IN  VARCHAR2,
   quantity_             IN  NUMBER,
   date_                 IN  DATE)
IS
   found_    BOOLEAN;
   price_break_type_ VARCHAR2(20);
   char_value_       VARCHAR2(2000);
   max_qty_break_    NUMBER := 0;
   break_value_      NUMBER := 0;

   CURSOR get_price_search_method  IS
      SELECT price_break_type
      FROM char_based_price_list_tab
      WHERE config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_;
   
   CURSOR get_min_value IS
      SELECT allow_override, max_override_percent
      FROM char_based_price_list_tab
      WHERE minimum_value <= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT allow_override, max_override_percent
      FROM char_based_price_list_tab
      WHERE maximum_value >= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT allow_override, max_override_percent
      FROM char_based_price_list_tab
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_
      ORDER BY valid_from_date DESC;
      
   CURSOR get_max_qty_break (date_ IN DATE)IS
      SELECT MAX(quantity_break)
      FROM char_based_price_list_tab
      WHERE quantity_break <= Nvl(quantity_, 1)
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND config_family_id = config_family_id_ 
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      IF Config_Characteristic_API.Get_Config_Data_Type_Db(characteristic_id_) = 'NUMERIC' THEN
         char_value_ := characteristic_value_;
         IF Config_Manager_API.Check_Numeric_Char_Value(char_value_) = 1 THEN
            break_value_ := To_Number(char_value_);
         END IF;
      END IF;
   $END
   OPEN get_price_search_method;
   FETCH get_price_search_method INTO price_break_type_;
   CLOSE get_price_search_method;
   
   IF (price_break_type_ = 'MIN') THEN
      OPEN get_min_value;
      FETCH get_min_value INTO allow_override_, max_override_percent_;
      found_ := get_min_value%FOUND;
      CLOSE get_min_value;
   ELSIF (price_break_type_ = 'MAX') THEN
      OPEN get_max_value;
      FETCH get_max_value INTO allow_override_, max_override_percent_;
      found_ := get_max_value%FOUND;
      CLOSE get_max_value;
   ELSIF (price_break_type_ = 'NONE') THEN
      -- find first valid break group with largest break qty
      OPEN get_max_qty_break(date_);
      FETCH get_max_qty_break INTO max_qty_break_;
      CLOSE get_max_qty_break;

      OPEN get_none_value;
      FETCH get_none_value INTO allow_override_, max_override_percent_;
      found_ := get_none_value%FOUND;
      CLOSE get_none_value;
   ELSE
      allow_override_ := 'TRUE';
      max_override_percent_ := NULL;
   END IF;
   
END Get_Allowed_Override_Percent;

