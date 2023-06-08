-----------------------------------------------------------------------------
--
--  Logical unit: CharacteristicPriceList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220114  UTSWLK  MF21R2-6623, Added Check_Record_Exist().
--  210609  JICESE  MF21R2-1601, Added public method Get_Allowed_Override_Percent.
--  210609  JICESE  MF21R2-1580, Added ALLOW_OVERRIDE, MAX_OVERRIDE_PERCENT column to CHARACTERISTIC_BASE_PRICE_TAB.
--  140805  ChFolk  Modified Get_Price_List_Info to add new OUT parameter  fixed_amt_incl_tax_ which is to be used when price including tax is used.
--  140421  MiKulk  Modified the Check_Insert___ to call the Validate_Break_Type___ after the Super() call.
--  140411  MaIklk  PBSC-8350, Set rowkey = NULL when copy records.
--  140115  AyAmlk  Bug 114687, Modified Copy() to have the correct currency conversion.
--  001213  JakH  Get_Price_List_Info modified to search prices correctly.
--  001207  JoEd  Changed Unpack_Check_Insert___ so that the keys are fetched
--                before they're used in Validate_Base_Part_Char___.
--  001201  JoEd  Added default value for char_qty_price_method in Prepare_Insert___.
--  000905  FBen  Removed contract from PLCONF view.
--  000901  FBen  Changed objid from rowid to rownum in PLCONF view
--  000711  TFU   merging from Chameleon
--  000706  TFU   Added procedure COPY
--  000703  GBO   Corrected cursor in Get_Price_List_Infos
--  000628  GBO   Added Validate_Base_Part_Option___, Get_Price_List_Infos
--                and Is_Valid_Price_List
--  000626  GBO   Added default values
--                Removed minus_percentage
--  000621  GBO   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Break_Type___ (
   newrec_ IN OUT CHARACTERISTIC_PRICE_LIST_TAB%ROWTYPE,
   insert_ IN     BOOLEAN DEFAULT TRUE )
IS
   dummy_            NUMBER;
   break_price_type_ VARCHAR2(20);

   CURSOR CheckMinimumValue IS
      SELECT 1
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE minimum_value = newrec_.minimum_value
        AND quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND characteristic_id = newrec_.characteristic_id
        AND spec_revision_no = newrec_.spec_revision_no
        AND part_no = newrec_.part_no
        AND price_list_no = newrec_.price_list_no
        AND catalog_no = newrec_.catalog_no;

   CURSOR CheckMaximumValue IS
      SELECT 1
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE maximum_value = newrec_.maximum_value
        AND quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND characteristic_id = newrec_.characteristic_id
        AND spec_revision_no = newrec_.spec_revision_no
        AND part_no = newrec_.part_no
        AND price_list_no = newrec_.price_list_no
        AND catalog_no = newrec_.catalog_no;

   CURSOR GetBreakLineNo IS
      SELECT MAX( break_line_no )
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND characteristic_id = newrec_.characteristic_id
        AND spec_revision_no = newrec_.spec_revision_no
        AND part_no = newrec_.part_no
        AND price_list_no = newrec_.price_list_no
        AND catalog_no = newrec_.catalog_no;
BEGIN

   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      break_price_type_ := Base_Part_Characteristic_API.Get_Price_Break_Type_Db(newrec_.part_no, newrec_.spec_revision_no, newrec_.characteristic_id);
   $END
   Trace_SYS.Field('BREAK_PRICE_TYPE', break_price_type_ );

   IF (break_price_type_ = 'NONE') THEN
      -- No minimum_value or maximum_value are authorized
      IF ( newrec_.minimum_value IS NOT NULL ) OR ( newrec_.maximum_value IS NOT NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE1: No value in minimum or maximum are allowed when break price type of characteristic :P1 for part :P2 is set to none.', p1_ => newrec_.characteristic_id, p2_ => newrec_.part_no );
      ELSE
         IF insert_ THEN
            newrec_.break_line_no := 0;
         END IF;
      END IF;
   ELSIF (break_price_type_ = 'MIN') THEN
      -- Check minimum_value
      IF ( newrec_.minimum_value IS NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE2: A minimum value is required when break price type of characteristic :P1 for part :P2 is set to minimum.', p1_ => newrec_.characteristic_id, p2_ => newrec_.part_no );
      END IF;

      -- Check maximum_value
      IF ( newrec_.maximum_value IS NOT NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE3: A maximum value is not allowed when break price type of characteristic :P1 for part :P2 is set to minimum.', p1_ => newrec_.characteristic_id, p2_ => newrec_.part_no );
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
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE4: A maximum value is required when break price type of characteristic :P1 for part :P2 is set to maximum.', p1_ => newrec_.characteristic_id, p2_ => newrec_.part_no );
      END IF;

      -- Check minimum_value
      IF ( newrec_.minimum_value IS NOT NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE5: A minimum value is not allowed when break price type of characteristic :P1 for part :P2 is set to maximum.', p1_ => newrec_.characteristic_id, p2_ => newrec_.part_no );
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


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', TRUNC(SYSDATE), attr_ );
   Client_SYS.Add_To_Attr('OFFSET_VALUE', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT_INCL_TAX', '0', attr_ );
   Client_SYS.Add_To_Attr('QUANTITY_BREAK', '0', attr_ );
   Client_SYS.Add_To_Attr('PRICE_SEARCH_DB', 'CONTINUE', attr_ );
   Client_SYS.Add_To_Attr('CHAR_QTY_PRICE_METHOD_DB', 'NO', attr_);
   Client_SYS.Add_To_Attr('ALLOW_OVERRIDE_DB', 'TRUE', attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CHARACTERISTIC_PRICE_LIST_TAB%ROWTYPE )
IS
BEGIN
   Sales_Price_List_API.Check_Editable(remrec_.price_list_no);
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CHARACTERISTIC_PRICE_LIST_TAB%ROWTYPE )
IS

   dummy_ NUMBER;

   CURSOR exist_more_lines IS
      SELECT count(*)
      FROM  CHARACTERISTIC_PRICE_LIST_TAB
      WHERE price_list_no = remrec_.price_list_no
      AND   part_no = remrec_.part_no
      AND   spec_revision_no = remrec_.spec_revision_no
      AND   characteristic_id = remrec_.characteristic_id
      AND   catalog_no = remrec_.catalog_no;

BEGIN
   OPEN exist_more_lines;
   FETCH exist_more_lines INTO dummy_;
   IF (dummy_ = 1) THEN
      CLOSE exist_more_lines;
      Option_Value_Price_List_API.Delete_Option_Values(remrec_.price_list_no,
                                                       remrec_.part_no,
                                                       remrec_.spec_revision_no,
                                                       remrec_.characteristic_id,
                                                       remrec_.catalog_no );
   ELSE
      CLOSE exist_more_lines;
   END IF;
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT characteristic_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.sales_price_type := NVL(newrec_.sales_price_type, Sales_Price_Type_API.DB_SALES_PRICES);
   newrec_.valid_from_date := Trunc(newrec_.valid_from_date);
   super(newrec_, indrec_, attr_);
   Validate_Break_Type___(newrec_);
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     characteristic_price_list_tab%ROWTYPE,
   newrec_ IN OUT characteristic_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Validate_Break_Type___( newrec_, FALSE );
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     characteristic_price_list_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY characteristic_price_list_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.allow_override = 'FALSE' THEN
      newrec_.max_override_percent := NULL;
   END IF;
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Remove__
--   Checks if it is allowed to remove characteristic price list when removing a
--   part configuration revision.
PROCEDURE Check_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2 )
IS

   CURSOR get_rec_key IS
      SELECT *
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_;
BEGIN

   FOR keyrec_ IN get_rec_key LOOP
       Check_Delete___(keyrec_);
   END LOOP;
END Check_Remove__;


-- Do_Remove__
--   Removes characteristic price list when removing a part configuration revision.
PROCEDURE Do_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2 )
IS
   remrec_     CHARACTERISTIC_PRICE_LIST_TAB%ROWTYPE;
   objid_      CHARACTERISTIC_PRICE_LIST.objid%TYPE;
   objversion_ CHARACTERISTIC_PRICE_LIST.objversion%TYPE;

   CURSOR get_rec_key IS
      SELECT *
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_;
BEGIN

   FOR keyrec_ IN get_rec_key LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, keyrec_.price_list_no, keyrec_.part_no,
                                keyrec_.spec_revision_no, keyrec_.characteristic_id,
                                keyrec_.break_line_no, keyrec_.valid_from_date, keyrec_.quantity_break,keyrec_.catalog_no);
      remrec_ := Lock_By_Keys___(keyrec_.price_list_no, keyrec_.part_no,
                                keyrec_.spec_revision_no, keyrec_.characteristic_id,
                                keyrec_.break_line_no, keyrec_.valid_from_date, keyrec_.quantity_break,keyrec_.catalog_no);
      Delete___(objid_, remrec_);
   END LOOP;
END Do_Remove__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   Copy the relevant characteristic values for a given sales price list part.
PROCEDURE Copy (
   old_price_list_no_   IN VARCHAR2,
   new_price_list_no_   IN VARCHAR2,
   valid_from_date_     IN DATE,
   to_valid_from_date_  IN DATE,
   part_no_             IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   currency_rate_       IN NUMBER)
IS
   newrec_              CHARACTERISTIC_PRICE_LIST_TAB%ROWTYPE;
   objid_               CHARACTERISTIC_PRICE_LIST.objid%TYPE;
   objversion_          CHARACTERISTIC_PRICE_LIST.objversion%TYPE;
   attr_                VARCHAR2(32000);
   valid_date_          DATE;
   new_valid_from_date_ DATE;

   -- Select all characteristics for a given price_list_no, part_no and catalog_no
   CURSOR get_all_characteristics IS
      SELECT *
      FROM   CHARACTERISTIC_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_;

   -- select distinct spec_revision_no, characteristic_id, break_line_no, quantity_break combinations for a given price_list_no, part_no and catalog_no
   CURSOR get_distinct_records IS
      SELECT DISTINCT spec_revision_no, characteristic_id, break_line_no, quantity_break
      FROM   CHARACTERISTIC_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_;

   -- Suppose we have given a valid from date as 15-06-2008 when copying and there are three records with vaid_from_dates
   -- 13-06-2008,14-06-2008 and 16-06-2008, this cursor will select 14-06-2008 as the date that we should consider when copying records
   CURSOR get_rec_with_max_valid_from(spec_revision_no_ IN NUMBER, characteristic_id_ IN VARCHAR2, break_line_no_ IN NUMBER, quantity_break_ IN NUMBER, valid_date_ IN DATE) IS
      SELECT MAX(valid_from_date)
      FROM   CHARACTERISTIC_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_
      AND    spec_revision_no = spec_revision_no_
      AND    characteristic_id = characteristic_id_
      AND    break_line_no = break_line_no_
      AND    quantity_break = quantity_break_
      AND    valid_from_date <= valid_date_;


   CURSOR get_valid_characteristics(spec_revision_no_ IN NUMBER, characteristic_id_ IN VARCHAR2, break_line_no_ IN NUMBER, quantity_break_ IN NUMBER, valid_date_ IN DATE) IS
      SELECT *
      FROM   CHARACTERISTIC_PRICE_LIST_TAB
      WHERE  price_list_no = old_price_list_no_
      AND    part_no = part_no_
      AND    catalog_no = catalog_no_
      AND    spec_revision_no = spec_revision_no_
      AND    characteristic_id = characteristic_id_
      AND    break_line_no = break_line_no_
      AND    quantity_break = quantity_break_
      AND    valid_from_date >= valid_date_;
BEGIN

   IF (valid_from_date_ IS NULL) THEN
      -- Copy all characteristics
      FOR next_ IN get_all_characteristics LOOP
         
         IF NOT Check_Exist___(new_price_list_no_, part_no_, next_.spec_revision_no, next_.characteristic_id, next_.break_line_no, next_.valid_from_date, next_.quantity_break, catalog_no_) THEN
            Client_SYS.Clear_Attr(attr_);
            newrec_               := next_;
            newrec_.price_list_no := new_price_list_no_;
            newrec_.fixed_amount  := next_.fixed_amount * NVL(currency_rate_, 1);
            newrec_.rowkey := NULL;
            IF Sales_Price_List_API.Get_Currency_Code(old_price_list_no_) != Sales_Price_List_API.Get_Currency_Code(new_price_list_no_) THEN
               newrec_.combination_id := NULL;
            END IF; 
            
            Insert___(objid_, objversion_, newrec_, attr_);

            Option_Value_Price_List_API.Copy(old_price_list_no_, new_price_list_no_, valid_from_date_, to_valid_from_date_, part_no_, next_.spec_revision_no, next_.characteristic_id, catalog_no_, currency_rate_);
         END IF;
      END LOOP;
   ELSE
      -- Copy rows that are valid for the specified valid_from_date_
      FOR distinct_rec_ IN get_distinct_records LOOP
         -- Used get_rec_with_max_valid_from in order to find the maximum valid from date of the records which satisfies the condition <= specified valid_from_date_
         OPEN get_rec_with_max_valid_from(distinct_rec_.spec_revision_no, distinct_rec_.characteristic_id, distinct_rec_.break_line_no, distinct_rec_.quantity_break, valid_from_date_);
         FETCH get_rec_with_max_valid_from INTO valid_date_;
         CLOSE get_rec_with_max_valid_from;

         -- IF no record found to satisfy the condition <= specified valid_from_date_ we take the valid_from_date_
         -- as the date that we should take for the comparison, when copying records
         valid_date_ := NVL(valid_date_, valid_from_date_);

         FOR next_ IN get_valid_characteristics(distinct_rec_.spec_revision_no, distinct_rec_.characteristic_id, distinct_rec_.break_line_no, distinct_rec_.quantity_break, valid_date_) LOOP
            -- IF a to_valid_from_date_ is given we will use that date as the valid_from_date of the new records
            -- IF not, depending on the valid_from_date of the old records and the given valid_from_date when copying, fetch the dates for the new records
            IF (to_valid_from_date_ IS NULL) THEN
               IF (valid_from_date_ > next_.valid_from_date) THEN
                  new_valid_from_date_ := valid_from_date_ ;
               ELSE
                  new_valid_from_date_ := next_.valid_from_date;
               END IF;
            ELSE
               new_valid_from_date_ := to_valid_from_date_;
            END IF;

            IF NOT Check_Exist___(new_price_list_no_, part_no_, next_.spec_revision_no, next_.characteristic_id, next_.break_line_no, new_valid_from_date_, next_.quantity_break, catalog_no_) THEN
               Client_SYS.Clear_Attr(attr_);
               newrec_                 := next_;
               newrec_.price_list_no   := new_price_list_no_;
               newrec_.valid_from_date := new_valid_from_date_;
               newrec_.fixed_amount    := next_.fixed_amount * NVL(currency_rate_, 1);
               newrec_.rowkey          := NULL;
               IF Sales_Price_List_API.Get_Currency_Code(old_price_list_no_) != Sales_Price_List_API.Get_Currency_Code(new_price_list_no_) THEN
                  newrec_.combination_id := NULL;
               END IF;  
               
               Insert___(objid_, objversion_, newrec_, attr_);

               Option_Value_Price_List_API.Copy(old_price_list_no_, new_price_list_no_, valid_from_date_, to_valid_from_date_, part_no_, next_.spec_revision_no, next_.characteristic_id, catalog_no_, currency_rate_);

               -- IF we have given a to_valid_from_date_ then we can copy only one record
               IF (to_valid_from_date_ IS NOT NULL) THEN
                  EXIT;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   END IF;
END Copy;


-- Is_Valid_Price_List
--   Check the Validity of the price list
FUNCTION Is_Valid_Price_List (
   price_list_no_     IN VARCHAR2,
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2,
   contract_          IN VARCHAR2,
   currency_code_     IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   validity_date_     IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   found_  VARCHAR2(5) := 'FALSE';
   date_   DATE;

   CURSOR exist_control IS
      SELECT 'TRUE'
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_;
BEGIN

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


-- Get_Price_List_Infos
--   Return information from Price List.
PROCEDURE Get_Price_List_Infos (
   offset_value_        OUT NUMBER,
   fixed_amount_        OUT NUMBER,
   fixed_amt_incl_tax_  OUT NUMBER,
   multiply_by_qty_     OUT VARCHAR2,
   stop_price_search_   OUT VARCHAR2,
   price_list_no_       IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   spec_revision_no_    IN  NUMBER,
   characteristic_id_   IN  VARCHAR2,
   char_value_          IN  NUMBER,
   char_qty_            IN  NUMBER,
   contract_            IN  VARCHAR2,
   price_search_method_ IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   validity_date_       IN  DATE DEFAULT NULL,
   eval_rec_            IN  Characteristic_Base_Price_API.config_price_comb_rec)
IS
   date_                 DATE;
   i_break_value_        NUMBER := NVL(char_value_, 0);
   i_quantity_break_     NUMBER := NVL(char_qty_, 1);
   found_                BOOLEAN;
   max_qty_break_        NUMBER := 0;
   combination_id_       VARCHAR2(24);
   retrieved_price_type_ VARCHAR2(20);
   config_combo_price_   NUMBER;

   CURSOR get_min_value IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method, price_search,combination_id,retrieved_price_type
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE minimum_value <= i_break_value_
      AND quantity_break <= i_quantity_break_
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method, price_search,combination_id,retrieved_price_type
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE maximum_value >= i_break_value_
      AND quantity_break <= i_quantity_break_
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method, price_search,combination_id,retrieved_price_type
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY valid_from_date DESC;

   CURSOR get_max_qty_break (date_ IN DATE)IS
      SELECT MAX(quantity_break)
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE quantity_break <= i_quantity_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_;
BEGIN
   IF (validity_date_ IS NULL) THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := validity_date_;
   END IF;

   date_ := Trunc(date_);
   Trace_SYS.Field('PRICE_SEARCH_METHOD', price_search_method_);
  
   IF (price_search_method_ ='MIN') THEN

      OPEN get_min_value;
      FETCH get_min_value INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_, stop_price_search_,combination_id_,retrieved_price_type_;
      found_ := get_min_value%FOUND;
      CLOSE get_min_value;
   ELSIF (price_search_method_ = 'MAX') THEN

      OPEN get_max_value;
      FETCH get_max_value INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_, stop_price_search_,combination_id_,retrieved_price_type_;
      found_ := get_max_value%FOUND;
      CLOSE get_max_value;
   ELSIF (price_search_method_ = 'NONE') THEN
      -- find first valid break group with largest break qty
      OPEN get_max_qty_break(date_);
      FETCH get_max_qty_break INTO max_qty_break_;
      CLOSE get_max_qty_break;

      OPEN get_none_value;
      FETCH get_none_value INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_, stop_price_search_,combination_id_,retrieved_price_type_;
      found_ := get_none_value%FOUND;
      CLOSE get_none_value;
   END IF;
  
   IF found_ THEN
      IF (combination_id_ IS NOT NULL) THEN 
         config_combo_price_ := Config_Price_Combination_API.Validate_Combination(eval_rec_,combination_id_);
         IF retrieved_price_type_ = 'AddOn' THEN 
            fixed_amount_ := fixed_amount_ + NVL(config_combo_price_, 0) ;
            offset_value_ := offset_value_;
         ELSE 
            -- Replace only if price is not null.
            fixed_amount_ := NVL(config_combo_price_, fixed_amount_) ;
            offset_value_ := 0;
         END IF;
      ELSE 
         fixed_amount_ := fixed_amount_;
         offset_value_ := offset_value_;
      END IF;
      fixed_amt_incl_tax_ := fixed_amt_incl_tax_;
      multiply_by_qty_ := multiply_by_qty_;
      stop_price_search_ := stop_price_search_;
   ELSE 
      offset_value_ := NULL;
      fixed_amount_ := NULL;
      fixed_amt_incl_tax_ := NULL;
      multiply_by_qty_ := NULL;
      stop_price_search_ := NULL;
   END IF;
END Get_Price_List_Infos;

PROCEDURE Get_Allowed_Override_Percent (
   allow_override_       OUT VARCHAR2,
   max_override_percent_ OUT NUMBER,
   price_list_no_        IN  VARCHAR2,
   part_no_              IN   VARCHAR2,
   spec_revision_no_     IN   NUMBER,
   characteristic_id_    IN   VARCHAR2,
   catalog_no_           IN   VARCHAR2,
   characteristic_value_ IN   VARCHAR2,
   quantity_             IN   NUMBER,
   date_                 IN   DATE)
IS
   found_    BOOLEAN;
   price_break_type_ VARCHAR2(20);
   char_value_       VARCHAR2(2000);
   max_qty_break_    NUMBER := 0;
   break_value_      NUMBER := 0;
   
   CURSOR get_min_value IS
      SELECT allow_override, max_override_percent
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE minimum_value <= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT allow_override, max_override_percent
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE maximum_value >= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT allow_override, max_override_percent
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY valid_from_date DESC;
      
   CURSOR get_max_qty_break (date_ IN DATE)IS
      SELECT MAX(quantity_break)
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE quantity_break <= Nvl(quantity_, 1)
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
   price_break_type_ := Base_Part_Characteristic_API.Get_Price_Break_Type_Db(part_no_, spec_revision_no_, characteristic_id_);
      IF Config_Characteristic_API.Get_Config_Data_Type_Db(characteristic_id_) = 'NUMERIC' THEN
      char_value_ := characteristic_value_;
      IF Config_Manager_API.Check_Numeric_Char_Value(char_value_) = 1 THEN
         break_value_ := To_Number(char_value_);
      END IF;
   END IF;
   $END
   
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

PROCEDURE Delete_Characteristic_Values(
   price_list_no_     IN VARCHAR2,
   part_no_           IN VARCHAR2,
   catalog_no_        IN VARCHAR2)
IS
      objid_ VARCHAR2(2000);
      objversion_ VARCHAR2(2000);
      info_ VARCHAR2(2000);

      CURSOR get_all_option_ IS
      SELECT part_no,characteristic_id,spec_revision_no,break_line_no,valid_from_date,quantity_break
      FROM   CHARACTERISTIC_PRICE_LIST_TAB
      WHERE  part_no = part_no_
      AND    price_list_no = price_list_no_
      AND    catalog_no = catalog_no_;
BEGIN
   FOR all_option IN get_all_option_ LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_,price_list_no_,all_option.part_no,all_option.spec_revision_no,all_option.characteristic_id,all_option.break_line_no,all_option.valid_from_date,all_option.quantity_break,catalog_no_);
      Remove__ (info_,objid_,objversion_,'DO');
   END LOOP;
END Delete_Characteristic_Values;


-- Copy_Revision_Price
--   Copies pricing details from one spec revision to another.
PROCEDURE Copy_Revision_Price (
  price_list_no_        IN VARCHAR2,
  part_no_              IN VARCHAR2,
  characteristic_id_    IN VARCHAR2,
  break_line_no_        IN NUMBER,
  valid_from_date_      IN DATE,
  quantity_break_       IN NUMBER,
  old_spec_revision_no_ IN NUMBER,
  new_spec_revision_no_ IN NUMBER,
  catalog_no_           IN VARCHAR2 )
IS
   newrec_       CHARACTERISTIC_PRICE_LIST_TAB%ROWTYPE;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);

   CURSOR get_oldrec IS
      SELECT *
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE price_list_no = price_list_no_
      AND   part_no = part_no_
      AND   spec_revision_no = old_spec_revision_no_
      AND   characteristic_id = characteristic_id_
      AND   break_line_no = break_line_no_
      AND   valid_from_date = valid_from_date_
      AND   quantity_break = quantity_break_
      AND   catalog_no = catalog_no_;
BEGIN

   OPEN get_oldrec;
   FETCH get_oldrec INTO newrec_;
   IF get_oldrec%FOUND THEN
      CLOSE get_oldrec;
      newrec_.spec_revision_no := new_spec_revision_no_;
      newrec_.rowkey := NULL;
      Client_SYS.Clear_Attr(attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      CLOSE get_oldrec;
   END IF;
END Copy_Revision_Price;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Price_Combination_Id (
   price_combination_id_ OUT  VARCHAR2,
   price_list_no_        IN  VARCHAR2,
   part_no_              IN   VARCHAR2,
   spec_revision_no_     IN   NUMBER,
   characteristic_id_    IN   VARCHAR2,
   catalog_no_           IN   VARCHAR2,
   characteristic_value_ IN   VARCHAR2,
   quantity_             IN   NUMBER,
   date_                 IN   DATE)
IS
   price_break_type_ VARCHAR2(20);
   char_value_       VARCHAR2(2000);
   max_qty_break_    NUMBER := 0;
   break_value_      NUMBER := 0;
   
   CURSOR get_min_value IS
      SELECT combination_id
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE minimum_value <= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT combination_id
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE maximum_value >= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT combination_id
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      ORDER BY valid_from_date DESC;
      
   CURSOR get_max_qty_break (date_ IN DATE) IS
      SELECT MAX(quantity_break)
      FROM CHARACTERISTIC_PRICE_LIST_TAB
      WHERE quantity_break <= Nvl(quantity_, 1)
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND price_list_no = price_list_no_
      AND catalog_no = catalog_no_;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
   price_break_type_ := Base_Part_Characteristic_API.Get_Price_Break_Type_Db(part_no_, spec_revision_no_, characteristic_id_);
      IF Config_Characteristic_API.Get_Config_Data_Type_Db(characteristic_id_) = 'NUMERIC' THEN
      char_value_ := characteristic_value_;
      IF Config_Manager_API.Check_Numeric_Char_Value(char_value_) = 1 THEN
         break_value_ := To_Number(char_value_);
      END IF;
   END IF;
   $END
   
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
FUNCTION Check_Record_Exist(
   price_list_no_     IN VARCHAR2,
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2) RETURN BOOLEAN 
IS
   exist_              NUMBER ;
   CURSOR char_rec_exist IS
      SELECT 1
      FROM characteristic_price_list_tab
      WHERE characteristic_id = characteristic_id_
      AND spec_revision_no    = spec_revision_no_
      AND part_no             = part_no_
      AND price_list_no       = price_list_no_;

BEGIN
   OPEN char_rec_exist;
   FETCH char_rec_exist INTO exist_;
      IF (char_rec_exist%FOUND) THEN
         CLOSE char_rec_exist; 
         RETURN TRUE;
      END IF;
   CLOSE char_rec_exist;   
   RETURN FALSE;   
END Check_Record_Exist;

