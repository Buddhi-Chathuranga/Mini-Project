-----------------------------------------------------------------------------
--
--  Logical unit: CharacteristicBasePrice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210609  JICESE  MF21R2-1601, Added public method Get_Allowed_Override_Percent.
--  210609  JICESE  MF21R2-1580, Added MAX_OVERRIDE_PERCENT column to CHARACTERISTIC_BASE_PRICE_TAB.
--  210531  AmPalk  MF21R2-1580, Added ALLOW_OVERRIDE  column to CHARACTERISTIC_BASE_PRICE_TAB.
--  210111  RavDlk  SC2020R1-11995,Removed unnecessary packing and unpacking of attrubute string in Modify_Fixed_Amt_For_Tax
--  140725  ChFolk  Added new out parameter fixed_amt_incl_tax_ to the method Get_Price_Infos.
--  140722  ChFolk  Added new method Modify_Fixed_Amt_For_Tax which modifies fixed_amount based on the tax infomation.
--  140513  MAHPLK  Modified Check_Insert___ to check whether spec_revision_no is obsolete.
--  140508  JICE    Clears rowkey in Copy_Revision_Price.
--  140421  MiKulk  Modified the Check_Insert___ and Check_Update___to call the Validate_Break_Type___ after the Super() call.
--  130703  MaIklk TIBE-948, Removed inst_BasePartChar_ global constant and used conditional compilation.
--  110713  ChJalk Added user_allowed_site filter to the view CHARACTERISTIC_BASE_PRICE.
--  100512  Ajpelk Merge rose method documentation
------------------------------Eagle------------------------------------------
--  060124  NiDalk Added Assert safe annotation. 
--  060111  SuJalk Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050920  SaMelk Removed the unused variable key_ from method 'Check_Remove__'.
--  040218  IsWilk Removed SUBSTRB from the view for Unicode Changes.
--  ------------------------------------------13.3.0--------------------------   
--  040122  GeKalk Rewrote DBMS_SQL using Native dynamic SQL for UNICODE modifications.
--  021211  Asawlk Merged bug fixes in 2002-3 SP3
--  021115  ViPalk Bug 33909, Modified cursor exist_more_lines in procedure Delete___.
--  021114  MaGu   Bug 33692. Modified method Get_Price_Infos. Removed cursors get_min_max_date
--  021114         and get_max_max_date and modified cursors get_min_value and get_max_value.
--  021111  MaGu   Bug 32538. Added methods Copy_Revision_Price, Check_Remove__ and Do_Remove__.
--  021111         Added CUSTOMLIST delete on attribute characteristic_id in view comments on view CHARACTERISTIC_BASE_PRICE.
--  021106  ViPalk Bug 33909, Added a cursor and an If condition, when calling
--  021106         Option_Value_Base_Price_API.Remove, in procedure Delete___.
--  021009  MaGu   Bug 29969. Modified method Get_Price_Infos. Added cursor get_max_qty_break
--  021009         and modified cursor get_none_value. Also removed use of cursor get_none_max_date
--  021009         in price search where price_search_method_ = 'NONE'.
--  020719  RaSilk  Bug 29966, Added Option_Value_Base_Price_API.Remove() to Delete___() method.
--  020103  JICE  Added public view for Sales Configurator interface.
--  010412  JaBa  gBug Fix 20598,Added new global lu constant and used it in necessary places.
--  001213  JakH  Get_Price_Infos changed TRUNC-logic, adjusted case.
--  001122  JakH  Set default break qty to 1 when looking for price, truncated site date
--  001116  JakH  Modified price fetching logic for getting base prices.
--  001116  JakH  Modified insert to handle null qty_break before validating the break type.
--  001116  JoEd  Added variable installed_BasePartChar_.
--  000907  FBen  Assigned Quantity_Break value 0 if Null in Unpack_Check_Insert___.
--  000816  JakH  Fetched latest version from Chameleon project
--  000706  GBO   Added Validate_Break_Type___
--  000703  GBO   Added logic in Get_New_Pricing_Info
--  000629  GBO   Added Validate_Base_Part_Char___
--  000621  TFU   Creatio
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE number_type IS TABLE OF
   NUMBER INDEX BY BINARY_INTEGER;

TYPE char_200_type IS TABLE OF
   VARCHAR2(200) INDEX BY BINARY_INTEGER;
   
TYPE char_2000_type IS TABLE OF
   VARCHAR2(2000) INDEX BY BINARY_INTEGER;
   
TYPE config_price_comb_rec IS RECORD
   (num_chars_        NUMBER,
    char_id_          char_200_type,
    char_value_       char_2000_type,
    char_qty_         number_type );

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Break_Type___ (
   newrec_ IN OUT CHARACTERISTIC_BASE_PRICE_TAB%ROWTYPE,
   insert_ IN     BOOLEAN DEFAULT TRUE )
IS   
   dummy_            NUMBER;
   break_price_type_ VARCHAR2(20);

   CURSOR check_min_value IS
      SELECT 1
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE minimum_value = newrec_.minimum_value
        AND quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND characteristic_id = newrec_.characteristic_id
        AND spec_revision_no = newrec_.spec_revision_no
        AND part_no = newrec_.part_no
        AND catalog_no = newrec_.catalog_no
        AND contract = newrec_.contract;

   CURSOR check_max_value IS
      SELECT 1
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE maximum_value = newrec_.maximum_value
        AND quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND characteristic_id = newrec_.characteristic_id
        AND spec_revision_no = newrec_.spec_revision_no
        AND part_no = newrec_.part_no
        AND catalog_no = newrec_.catalog_no
        AND contract = newrec_.contract;

   CURSOR get_break_line_no IS
      SELECT MAX( break_line_no )
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE quantity_break = newrec_.quantity_break
        AND valid_from_date = newrec_.valid_from_date
        AND characteristic_id = newrec_.characteristic_id
        AND spec_revision_no = newrec_.spec_revision_no
        AND part_no = newrec_.part_no
        AND catalog_no = newrec_.catalog_no
        AND contract = newrec_.contract;
BEGIN
   
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      break_price_type_ := Base_Part_Characteristic_API.Get_Price_Break_Type_Db(newrec_.part_no, newrec_.spec_revision_no, newrec_.characteristic_id);   
   $END   

   Trace_SYS.Field('BREAK_PRICE_TYPE', break_price_type_ );

   IF (break_price_type_ = 'NONE') THEN
      -- No minimum_value or maximum_value are authorized
      IF ( newrec_.minimum_value IS NOT NULL ) OR ( newrec_.maximum_value IS NOT NULL ) THEN
         Error_SYS.Record_General( lu_name_, 'BREAKTYPE1: No value in minimum or maximum are allowed when break price type of characteristic :P1 for part :P2 is set to none.', p1_ => newrec_.characteristic_id, p2_ => newrec_.part_no );
      ELSIF insert_ THEN
         newrec_.break_line_no := 0;
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
         OPEN check_min_value;
         FETCH check_min_value INTO dummy_;
         IF check_min_value%FOUND THEN
            Error_SYS.Record_Exist(lu_name_);
         END IF;
         CLOSE check_min_value;

         -- Get new break_line_no
         OPEN get_break_line_no;
         FETCH get_break_line_no INTO newrec_.break_line_no;
         CLOSE get_break_line_no;
         IF (newrec_.break_line_no IS NULL) THEN
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

      IF insert_ THEN
         -- Test unicity
         OPEN check_max_value;
         FETCH check_max_value INTO dummy_;
         IF check_max_value%FOUND THEN
            Error_SYS.Record_Exist(lu_name_);
         END IF;
         CLOSE check_max_value;

         -- Get new break_line_no
         OPEN get_break_line_no;
         FETCH get_break_line_no INTO newrec_.break_line_no;
         CLOSE get_break_line_no;
         IF (newrec_.break_line_no IS NULL) THEN
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
   Client_SYS.Add_To_Attr('QUANTITY_BREAK', '0', attr_ );
   Client_SYS.Add_To_Attr('ALLOW_OVERRIDE_DB', 'TRUE', attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CHARACTERISTIC_BASE_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('BREAK_LINE_NO', newrec_.break_line_no, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CHARACTERISTIC_BASE_PRICE_TAB%ROWTYPE )
IS
   dummy_ NUMBER;

   CURSOR exist_more_lines IS
      SELECT count(*)
      FROM  CHARACTERISTIC_BASE_PRICE_TAB
      WHERE contract = remrec_.contract
      AND   catalog_no = remrec_.catalog_no
      AND   part_no = remrec_.part_no
      AND   spec_revision_no = remrec_.spec_revision_no
      AND   characteristic_id = remrec_.characteristic_id;
BEGIN
   OPEN exist_more_lines;
   FETCH exist_more_lines INTO dummy_;
   IF (dummy_ = 1) THEN
      CLOSE exist_more_lines;
   Option_Value_Base_Price_API.Remove( remrec_.contract,
                                       remrec_.catalog_no,
                                       remrec_.part_no,
                                       remrec_.spec_revision_no,
                                       remrec_.characteristic_id);
   ELSE
      CLOSE exist_more_lines;
   END IF;
   
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT characteristic_base_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (indrec_.catalog_no = TRUE) THEN
      Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, Sales_Type_API.DB_SALES_AND_RENTAL);
   END IF; 
   IF (indrec_.valid_from_date = TRUE) THEN
      newrec_.valid_from_date := TRUNC(newrec_.valid_from_date);    
   END IF;
   
   IF (newrec_.quantity_break IS NULL) THEN
      newrec_.quantity_break := 0;
   END IF;
   
   super(newrec_, indrec_, attr_);
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
   IF (Config_Part_Spec_Rev_API.Get_Objstate(newrec_.part_no, newrec_.spec_revision_no) = 'Obsolete') THEN
      Error_SYS.Record_General( lu_name_, 'STATUSOBSOLETE: Configuration revision status Obsolete cannot be entered');
   END IF;   
   $END
   Validate_Break_Type___(newrec_); 

EXCEPTION 
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     characteristic_base_price_tab%ROWTYPE,
   newrec_ IN OUT characteristic_base_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);  
   Validate_Break_Type___(newrec_, FALSE);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     characteristic_base_price_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY characteristic_base_price_tab%ROWTYPE,
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
--   Checks if it is allowed to remove characteristic base price
--   when removing a
--   part configuration revision.
PROCEDURE Check_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2 )
IS

   CURSOR get_rec_key IS
      SELECT *
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_;
BEGIN

   FOR keyrec_ IN get_rec_key LOOP
       Check_Delete___(keyrec_);
   END LOOP;
END Check_Remove__;


-- Do_Remove__
--   Removes characteristic base price when removing a part configuration revision.
PROCEDURE Do_Remove__ (
   part_no_           IN VARCHAR2,
   spec_revision_no_  IN NUMBER,
   characteristic_id_ IN VARCHAR2 )
IS
   remrec_     CHARACTERISTIC_BASE_PRICE_TAB%ROWTYPE;
   objid_      CHARACTERISTIC_BASE_PRICE.objid%TYPE;
   objversion_ CHARACTERISTIC_BASE_PRICE.objversion%TYPE;

   CURSOR get_rec_key IS
      SELECT *
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE part_no = part_no_
      AND   spec_revision_no = spec_revision_no_
      AND   characteristic_id = characteristic_id_;
BEGIN

   FOR keyrec_ IN get_rec_key LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, keyrec_.contract, keyrec_.catalog_no,
                                keyrec_.part_no, keyrec_.spec_revision_no, keyrec_.characteristic_id,
                                keyrec_.break_line_no, keyrec_.valid_from_date, keyrec_.quantity_break);
      remrec_ := Lock_By_Keys___(keyrec_.contract, keyrec_.catalog_no, keyrec_.part_no, keyrec_.spec_revision_no,
                                 keyrec_.characteristic_id, keyrec_.break_line_no, keyrec_.valid_from_date, keyrec_.quantity_break);
      Delete___(objid_, remrec_);
   END LOOP;
END Do_Remove__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Price_Infos
--   return  offset_value, fixed_amount and multiply_by_qty
PROCEDURE Get_Price_Infos (
   offset_value_        OUT  NUMBER,
   fixed_amount_        OUT  NUMBER,
   fixed_amt_incl_tax_  OUT NUMBER,
   multiply_by_qty_     OUT  VARCHAR2,
   contract_            IN   VARCHAR2,
   catalog_no_          IN   VARCHAR2,
   part_no_             IN   VARCHAR2,
   spec_revision_no_    IN   NUMBER,
   characteristic_id_   IN   VARCHAR2,
   break_value_         IN   NUMBER,
   quantity_break_      IN   NUMBER,
   price_search_method_ IN   VARCHAR2,
   valid_from_date_     IN   DATE DEFAULT NULL,
   eval_rec_            IN   config_price_comb_rec)
IS
   date_             DATE;
   i_break_value_    NUMBER := NVL(break_value_, 0);
   i_quantity_break_ NUMBER := NVL(quantity_break_, 1);
   found_            BOOLEAN;
   max_qty_break_    NUMBER := 0;
   combination_id_       VARCHAR2(24);
   retrieved_price_type_ VARCHAR2(20);
   config_combo_price_   NUMBER;

   CURSOR get_min_value IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method,combination_id,retrieved_price_type
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE minimum_value <= i_break_value_
      AND quantity_break <= i_quantity_break_
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method,combination_id,retrieved_price_type
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE maximum_value >= i_break_value_
      AND quantity_break <= i_quantity_break_
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method,combination_id,retrieved_price_type
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY valid_from_date DESC;

   CURSOR get_max_qty_break (date_ IN DATE)IS
      SELECT MAX(quantity_break)
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE quantity_break <= i_quantity_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_;
BEGIN
  
   IF (valid_from_date_ IS NULL) THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := valid_from_date_;
   END IF;

   date_ := Trunc(date_);
   Trace_SYS.Field('PRICE_SEARCH_METHOD', price_search_method_);

   IF (price_search_method_ = 'MIN') THEN

      OPEN get_min_value;
      FETCH get_min_value INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_,combination_id_,retrieved_price_type_;
      found_ := get_min_value%FOUND;
      CLOSE get_min_value;

   ELSIF (price_search_method_ = 'MAX') THEN

      OPEN get_max_value;
      FETCH get_max_value INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_,combination_id_,retrieved_price_type_;
      found_ := get_max_value%FOUND;
      CLOSE get_max_value;

   ELSIF (price_search_method_ = 'NONE') THEN
      -- find first valid break group with largest break qty
      OPEN get_max_qty_break(date_);
      FETCH get_max_qty_break INTO max_qty_break_;
      CLOSE get_max_qty_break;

      OPEN get_none_value;
      FETCH get_none_value INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_,combination_id_,retrieved_price_type_;
      found_ := get_none_value%FOUND;
      CLOSE get_none_value;
   END IF;
   IF found_ THEN
      IF (combination_id_ IS NOT NULL) THEN 
         config_combo_price_ := Config_Price_Combination_API.Validate_Combination(eval_rec_,combination_id_);
         IF retrieved_price_type_ = 'AddOn' THEN 
            fixed_amount_ := fixed_amount_ + NVL(config_combo_price_, 0);
            offset_value_ := offset_value_;
         ELSE 
            -- Replace only if price is not null.
            fixed_amount_ := NVL(config_combo_price_, fixed_amount_);
            offset_value_ := 0;
         END IF;
      ELSE 
         fixed_amount_ := fixed_amount_;
         offset_value_ := offset_value_;
      END IF;
      fixed_amt_incl_tax_ := fixed_amt_incl_tax_;
      multiply_by_qty_ := multiply_by_qty_;
   ELSE 
      offset_value_ := NULL;
      fixed_amount_ := NULL;
      fixed_amt_incl_tax_ := NULL;
      multiply_by_qty_ := NULL;
   END IF;
END Get_Price_Infos;


PROCEDURE Get_Allowed_Override_Percent (
   allow_override_       OUT  VARCHAR2,
   max_override_percent_ OUT  NUMBER,
   contract_             IN   VARCHAR2,
   catalog_no_           IN   VARCHAR2,
   part_no_              IN   VARCHAR2,
   spec_revision_no_     IN   NUMBER,
   characteristic_id_    IN   VARCHAR2,
   characteristic_value_ IN   VARCHAR2,
   quantity_             IN   NUMBER,
   date_                 IN   DATE)
IS
   found_            BOOLEAN;
   price_break_type_ VARCHAR2(20);
   char_value_       VARCHAR2(2000);
   max_qty_break_    NUMBER := 0;
   break_value_      NUMBER := 0;
   
   CURSOR get_min_value IS
      SELECT allow_override, max_override_percent
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE minimum_value <= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT allow_override, max_override_percent
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE maximum_value >= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT allow_override, max_override_percent
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY valid_from_date DESC;

   CURSOR get_max_qty_break (date_ IN DATE)IS
      SELECT MAX(quantity_break)
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE quantity_break <= Nvl(quantity_, 1)
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_;
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

-- Copy_Revision_Price
--   Copies pricing details from one spec revision to another.
PROCEDURE Copy_Revision_Price (
  catalog_no_           IN VARCHAR2,
  part_no_              IN VARCHAR2,
  contract_             IN VARCHAR2,
  characteristic_id_    IN VARCHAR2,
  break_line_no_        IN NUMBER,
  valid_from_date_      IN DATE,
  quantity_break_       IN NUMBER,
  old_spec_revision_no_ IN NUMBER,
  new_spec_revision_no_ IN NUMBER )
IS
   newrec_       CHARACTERISTIC_BASE_PRICE_TAB%ROWTYPE;
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   attr_         VARCHAR2(2000);

   CURSOR get_oldrec IS
      SELECT *
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE  catalog_no = catalog_no_
      AND part_no = part_no_
      AND contract = contract_
      AND spec_revision_no = old_spec_revision_no_
      AND characteristic_id = characteristic_id_
      AND break_line_no = break_line_no_
      AND valid_from_date = valid_from_date_
      AND quantity_break = quantity_break_;
BEGIN

   OPEN get_oldrec;
   FETCH get_oldrec INTO newrec_;
   IF get_oldrec%FOUND THEN
      CLOSE get_oldrec;
      newrec_.rowkey := NULL;
      newrec_.spec_revision_no := new_spec_revision_no_;
      Client_SYS.Clear_Attr(attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      CLOSE get_oldrec;
   END IF;
END Copy_Revision_Price;

PROCEDURE Modify_Fixed_Amt_For_Tax (
   catalog_no_          IN VARCHAR2,
   contract_            IN VARCHAR2,
   use_price_incl_tax_  IN VARCHAR2,
   fee_code_            IN VARCHAR2 )
IS
   company_                VARCHAR2(20);
   fee_rate_               NUMBER;
   fixed_amount_incl_tax_  NUMBER;
   fixed_amount_           NUMBER;
   newrec_                 CHARACTERISTIC_BASE_PRICE_TAB%ROWTYPE;  
   
   CURSOR get_records IS
      SELECT part_no, spec_revision_no, characteristic_id, break_line_no, valid_from_date, quantity_break, fixed_amount, fixed_amount_incl_tax
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE catalog_no = catalog_no_
      AND   contract = contract_;
BEGIN
   company_ := Site_API.Get_Company(contract_);
   fee_rate_ := Statutory_Fee_API.Get_Fee_Rate(company_, fee_code_);
   FOR rec_ IN get_records LOOP
      newrec_ := Get_Object_By_Keys___(contract_, catalog_no_, rec_.part_no, rec_.spec_revision_no, rec_.characteristic_id, rec_.break_line_no, rec_.valid_from_date, rec_.quantity_break);
      IF (use_price_incl_tax_ = 'TRUE') THEN
         fixed_amount_ := rec_.fixed_amount_incl_tax / ((NVL(fee_rate_,0)/100)+1);
         newrec_.fixed_amount := fixed_amount_;
      ELSE
         fixed_amount_incl_tax_ := rec_.fixed_amount * ((NVL(fee_rate_,0)/100)+1);
         newrec_.fixed_amount_incl_tax := fixed_amount_incl_tax_;
      END IF;
      Modify___(newrec_);   
   END LOOP;
END Modify_Fixed_Amt_For_Tax;


PROCEDURE Get_Price_Combination_Id (
   price_combination_id_ OUT  VARCHAR2,
   contract_             IN   VARCHAR2,
   catalog_no_           IN   VARCHAR2,
   part_no_              IN   VARCHAR2,
   spec_revision_no_     IN   NUMBER,
   characteristic_id_    IN   VARCHAR2,
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
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE minimum_value <= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY minimum_value DESC, quantity_break DESC, valid_from_date DESC;

   CURSOR get_max_value IS
      SELECT combination_id
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE maximum_value >= Nvl(break_value_, 0)
      AND quantity_break <= Nvl(quantity_, 1)
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY quantity_break DESC, maximum_value ASC, valid_from_date DESC;

   CURSOR get_none_value IS
      SELECT combination_id
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE quantity_break = max_qty_break_
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_
      ORDER BY valid_from_date DESC;

   CURSOR get_max_qty_break (date_ IN DATE) IS
      SELECT MAX(quantity_break)
      FROM CHARACTERISTIC_BASE_PRICE_TAB
      WHERE quantity_break <= Nvl(quantity_, 1)
      AND break_line_no = 0
      AND valid_from_date <= date_
      AND characteristic_id = characteristic_id_
      AND spec_revision_no = spec_revision_no_
      AND part_no = part_no_
      AND catalog_no = catalog_no_
      AND contract = contract_;
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