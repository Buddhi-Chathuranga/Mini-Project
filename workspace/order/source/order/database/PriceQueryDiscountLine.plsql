-----------------------------------------------------------------------------
--
--  Logical unit: PriceQueryDiscountLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210112  RavDlk  SC2020R1-12039, Removed unnecessary packing and unpacking of attrubute string in New
--  200921  MaEelk  GESPRING20-5401, Added Get_Total_Line_Disc_Rounded___ and called it inside Get_Total_Line_Discount when Price Disc Rounded and not Use Price incl Tax.
--  200921  MaEelk  Discounted Price Rounding was applied to Calculate_Discount__
--  131119  RuLiLk  Bug 113865, Modified method Calculate_Discount__. Unrounded discount amount is used for the calculation of discount percentage when using partial discounts.
--  140307  HimRlk  Merged Bug 110133-PIV, Added new method Get_Total_Line_Discount() to calculate price query line discount to be consistant with discount postings.
--  130730  RuLiLk  Bug 110133, Modified method Get_Total_Line_Discount() by removing parameter base_curr_rate_.
--  130630  RuLiLk  Bug 110133, Added new method Get_Total_Line_Discount() to calculate price query line discount to be consistant with discount postings.
--  100312  KiSalk  Corrected Get_Total_Discount.
--  090415  DaZase  Added extra handling in Calculate_Discount__ for parallel price_base calculations 
--  090415          so we will have correct price_values intead of converted ones from price_currency.
--  090216  DaZase  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Modify_Discount_Data___ (
   price_query_id_    IN NUMBER,
   discount_no_       IN NUMBER,
   calculation_basis_ IN NUMBER,
   price_currency_    IN NUMBER,
   price_base_        IN NUMBER )
IS
   oldrec_               PRICE_QUERY_DISCOUNT_LINE_TAB%ROWTYPE;
   newrec_               PRICE_QUERY_DISCOUNT_LINE_TAB%ROWTYPE;
   attr_                 VARCHAR2(2000) := NULL;
   objid_                PRICE_QUERY_DISCOUNT_LINE.objid%TYPE;
   objversion_           PRICE_QUERY_DISCOUNT_LINE.objversion%TYPE;
   indrec_               Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('CALCULATION_BASIS', calculation_basis_, attr_);
   Client_SYS.Add_To_Attr('PRICE_CURRENCY', price_currency_, attr_);
   Client_SYS.Add_To_Attr('PRICE_BASE', price_base_, attr_);

   oldrec_ := Lock_By_Keys___(price_query_id_, discount_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By Keys.
END Modify_Discount_Data___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRICE_QUERY_DISCOUNT_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_seq_no (price_query_id_ IN NUMBER) IS
      SELECT nvl(max(discount_no) + 1, 1)
      FROM PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE price_query_id = price_query_id_;

BEGIN

   OPEN get_seq_no(newrec_.price_query_id);
   FETCH get_seq_no INTO newrec_.discount_no;
   CLOSE get_seq_no;
   Client_SYS.Add_To_Attr('DISCOUNT_NO', newrec_.discount_no, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-- gelr:disc_price_rounded, begin
@UncheckedAccess
FUNCTION Get_Total_Line_Disc_Rounded___ (
   price_query_id_     IN NUMBER,
   quantity_           IN NUMBER,
   price_conv_factor_  IN NUMBER, 
   currency_rounding_  IN NUMBER ) RETURN NUMBER
IS
   discount_amount_     NUMBER := 0;
   total_line_discount_ NUMBER := 0;
   calculation_basis_   NUMBER := 0;
   acc_discount_        NUMBER := 0;
   
   -- skip PRICE_QUERY_DISCOUNT_LINE_TAB.discount values, they may be wrong when DISCPRICEROUNDED is used
   CURSOR get_line_discounts IS
      SELECT (NVL(discount_amount, 0)) discount_amount
      FROM  PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE price_query_id = price_query_id_;

   CURSOR get_calc_basis IS
      SELECT calculation_basis
      FROM PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE discount_line_no = (SELECT MIN(discount_line_no)
                                FROM PRICE_QUERY_DISCOUNT_LINE_TAB
                                WHERE price_query_id = price_query_id_ )
      AND   price_query_id = price_query_id_;

   CURSOR get_acc_discount IS
      SELECT NVL(acc_discount, 0)
         FROM PRICE_QUERY_TAB
         WHERE price_query_id = price_query_id_;
BEGIN
   FOR discount_rec_ IN get_line_discounts LOOP
      discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_);
      IF currency_rounding_ IS NOT NULL THEN
         discount_amount_     := ROUND(discount_amount_ , currency_rounding_);
      END IF;
      total_line_discount_ := total_line_discount_ + discount_amount_;
   END LOOP;
   
   -- use PRICE_QUERY_TAB.acc_discount instead of PRICE_QUERY_DISCOUNT_LINE_TAB.discount
   OPEN get_calc_basis;
   FETCH get_calc_basis INTO calculation_basis_;
   CLOSE get_calc_basis;
   
   OPEN get_acc_discount;
   FETCH get_acc_discount INTO acc_discount_;
   CLOSE get_acc_discount;
   
   IF calculation_basis_ IS NOT NULL THEN
      discount_amount_ := calculation_basis_ * NVL(acc_discount_, 0)/100 * quantity_ * price_conv_factor_;
      IF currency_rounding_ IS NOT NULL THEN
         discount_amount_ := ROUND(discount_amount_, currency_rounding_);
      END IF;
      total_line_discount_ := total_line_discount_ + discount_amount_;
   END IF;
   
   RETURN total_line_discount_;
   
END Get_Total_Line_Disc_Rounded___;
-- gelr:disc_price_rounded, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Calculate_Discount__ (
   price_query_id_ IN NUMBER ) RETURN NUMBER
IS
   currency_rounding_     NUMBER;
   currency_rate_         NUMBER;
   calculation_basis_     NUMBER;
   price_base_            NUMBER;
   price_currency_        NUMBER;
   last_price_curr_       NUMBER;
   line_discount_amount_  NUMBER;
   total_discount_amount_ NUMBER;
   total_discount_        NUMBER;
   price_qty_             NUMBER;
   calculation_basis_base_     NUMBER;
   last_price_base_       NUMBER;
   base_discount_amount_  NUMBER;

   no_sum_or_amount_          BOOLEAN := TRUE;
   total_discount_percentage_ NUMBER := 0;
   currency_rate_type_        VARCHAR2(10);   -- not used at the moment, if price query get a project connection in the future this variable needs a correct value
   customer_no_pay_           CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   price_query_rec_           Price_Query_API.Public_Rec;
   sales_part_rec_            Sales_Part_API.Public_Rec;

   CURSOR get_line IS
      SELECT  discount, discount_amount, create_partial_sum, discount_no
      FROM PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE price_query_id = price_query_id_
      ORDER BY discount_line_no;
BEGIN

   price_query_rec_ := Price_Query_API.Get(price_query_id_);
   sales_part_rec_  := Sales_Part_API.Get(price_query_rec_.contract, price_query_rec_.catalog_no);
   customer_no_pay_ := Cust_Ord_Customer_Api.Get_Customer_No_Pay(price_query_rec_.customer_no);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(price_query_rec_.contract), price_query_rec_.currency_code);
   last_price_curr_ :=  price_query_rec_.sale_unit_price;
   last_price_base_ :=  price_query_rec_.base_sale_unit_price;
   calculation_basis_ := last_price_curr_;
   calculation_basis_base_ := last_price_base_;

   price_qty_ := price_query_rec_.sales_qty * sales_part_rec_.price_conv_factor;

   total_discount_amount_ := 0;

   FOR rec_ IN get_line LOOP
      -- Calculate the price after discount in order currency
      IF (rec_.discount_amount IS NULL) THEN
         -- gelr:disc_price_rounded, rounded price_currency_ and price_base_ if condition Discunted Price Rounded and not Price incl Tax
         IF ((Company_Localization_Info_API.Get_Parameter_Value_Db(Site_API.Get_Company(Price_Query_API.Get_Contract(price_query_id_)), 'DISC_PRICE_ROUNDED') = 'TRUE') AND 
             (price_query_rec_.use_price_incl_tax = 'FALSE') AND
             (currency_rounding_ IS NOT NULL))THEN
            price_currency_ := last_price_curr_ - ROUND((calculation_basis_ * (rec_.discount / 100)), currency_rounding_);
            price_base_     := last_price_base_ - ROUND((calculation_basis_base_ * (rec_.discount / 100)), currency_rounding_);
         ELSE
            price_currency_ := last_price_curr_ - (calculation_basis_ * (rec_.discount / 100));
            price_base_     := last_price_base_ - (calculation_basis_base_ * (rec_.discount / 100));
         END IF;
      ELSE
         price_currency_ := last_price_curr_ - rec_.discount_amount;
         -- Retrive the discount amount in base currency
         Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_discount_amount_, currency_rate_,
                                                            NVL(customer_no_pay_, price_query_rec_.customer_no),
                                                            price_query_rec_.contract, price_query_rec_.currency_code,
                                                            rec_.discount_amount, currency_rate_type_);
         price_base_     := last_price_base_ - base_discount_amount_;
      END IF;

      -- When creating postings for the discount records when the invoice in posted
      -- the discount amount for each discount line will be rounded with the number of
      -- decimals specified for the order currency.
      -- This has to be considered now since it could affect the discount percentage
      -- on the order line.
      line_discount_amount_ := ((last_price_curr_ - price_currency_) * price_qty_);
      
      -- gelr:disc_price_rounded, begin
      IF (currency_rounding_ IS NOT NULL) THEN
         line_discount_amount_ := ROUND(line_discount_amount_, currency_rounding_);
      END IF;
      -- gelr:disc_price_rounded, end
      
      -- Add up the total discount amount for the ordered qty so far
      total_discount_amount_ := total_discount_amount_ + line_discount_amount_;


      -- Update the discount record
      Modify_Discount_Data___(price_query_id_, rec_.discount_no,
                              calculation_basis_, price_currency_, price_base_);

      IF (no_sum_or_amount_ = TRUE) THEN
         IF (calculation_basis_ != price_query_rec_.sale_unit_price ) OR (rec_.discount_amount IS NOT NULL) THEN
            -- A discount amout has been specified or a partial sum has been specified for
            -- a previous line.
            -- In both cases it will not be possible to store the sum of the discount percentages
            -- for the discount records as the discount on the order line as this would cause
            -- errors when posting the invoice.
            no_sum_or_amount_ := FALSE;
         END IF;
         -- Sum up the discount percentages so far
         total_discount_percentage_ := total_discount_percentage_ + rec_.discount;
      END IF;

      IF (rec_.create_partial_sum = 'PARTIAL SUM') THEN
         -- Use the price after discount as new calculation basis
         calculation_basis_ := price_currency_;
         calculation_basis_base_ := price_base_;
      END IF;

      last_price_curr_ := price_currency_;
      last_price_base_ := price_base_;

   END LOOP;

   IF (price_query_rec_.sale_unit_price = 0) THEN
      total_discount_ := 0;
  -- Modified the ELSIF condition. When there are only discount percentages in the lines, ELSIF block should get executed.
   ELSIF (no_sum_or_amount_ = TRUE) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the order line
      total_discount_ := total_discount_percentage_;
   ELSE
      total_discount_ := (total_discount_amount_ / (price_query_rec_.sale_unit_price * price_qty_)) * 100;
   END IF;

   RETURN total_discount_;

END Calculate_Discount__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   acc_discount_              OUT NUMBER,
   price_query_id_             IN NUMBER,
   discount_type_              IN VARCHAR2,
   discount_found_             IN NUMBER,
   discount_source_            IN VARCHAR2,
   create_partial_sum_         IN VARCHAR2,
   discount_line_no_           IN NUMBER,
   discount_source_id_         IN VARCHAR2,
   discount_amount_            IN NUMBER DEFAULT NULL,
   discount_part_level_        IN VARCHAR2,
   discount_part_level_id_     IN VARCHAR2,
   discount_customer_level_    IN VARCHAR2,
   discount_customer_level_id_ IN VARCHAR2 )
IS
   newrec_      PRICE_QUERY_DISCOUNT_LINE_TAB%ROWTYPE;
BEGIN
   newrec_.price_query_id := price_query_id_;
   newrec_.discount_type := discount_type_;
   newrec_.discount := discount_found_;
   newrec_.discount_source := discount_source_;
   newrec_.create_partial_sum := create_partial_sum_;
   newrec_.discount_line_no := discount_line_no_;
   newrec_.discount_source_id := discount_source_id_;
   newrec_.discount_amount := discount_amount_;
   newrec_.discount_part_level := discount_part_level_;
   newrec_.discount_part_level_id := discount_part_level_id_;
   newrec_.discount_customer_level := discount_customer_level_;
   newrec_.discount_customer_level_id := discount_customer_level_id_;
   New___(newrec_);
   acc_discount_ := Calculate_Discount__(price_query_id_);
END New;


@UncheckedAccess
FUNCTION Get_Total_Discount (
   price_query_id_ IN NUMBER ) RETURN NUMBER
IS
   discount_line_no_       NUMBER;
   calculation_basis_      NUMBER;
   last_price_currency_    NUMBER;
   total_discount_         NUMBER;
   temp_                   NUMBER;

   CURSOR get_calc_basis IS
      SELECT calculation_basis
      FROM PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE discount_line_no = (SELECT MIN(discount_line_no)
                                FROM PRICE_QUERY_DISCOUNT_LINE_TAB
                                WHERE price_query_id = price_query_id_ )
      AND   price_query_id = price_query_id_;

   CURSOR get_price_curr IS
      SELECT price_currency
      FROM PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE discount_line_no = discount_line_no_
      AND   price_query_id = price_query_id_;


BEGIN
   discount_line_no_ := Get_Last_Discount_Line_No(price_query_id_);

   OPEN get_calc_basis;
   FETCH get_calc_basis INTO calculation_basis_;
   CLOSE get_calc_basis;

   OPEN get_price_curr;
   FETCH get_price_curr INTO last_price_currency_;
   CLOSE get_price_curr;


   IF (calculation_basis_ = 0) THEN
      total_discount_ := 0;
   ELSE
      temp_ := (calculation_basis_ - last_price_currency_);
      total_discount_ := NVL((temp_ / calculation_basis_ ) * 100, 0);
   END IF;

   RETURN total_discount_;
END Get_Total_Discount;


PROCEDURE Remove_Discount_Row (
   price_query_id_ IN NUMBER,
   discount_no_    IN NUMBER )
IS
   objid_       VARCHAR2(200);
   objversion_  VARCHAR2(2000);
   remrec_      PRICE_QUERY_DISCOUNT_LINE_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, price_query_id_, discount_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Discount_Row;


@UncheckedAccess
FUNCTION Get_Last_Discount_Line_No (
   price_query_id_ IN NUMBER ) RETURN NUMBER
IS
   last_  NUMBER;

   CURSOR get_last IS
      SELECT MAX(discount_line_no)
      FROM PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE price_query_id = price_query_id_;
BEGIN
   OPEN get_last;
   FETCH get_last INTO last_;
   CLOSE get_last;

   IF (last_ IS NULL) THEN
      last_ := 0;
   END IF;
   RETURN last_;
END Get_Last_Discount_Line_No;


@UncheckedAccess
FUNCTION Check_Existing_Discount_Row (
   price_query_id_ IN NUMBER,
   discount_no_    IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(price_query_id_, discount_no_);
END Check_Existing_Discount_Row;


@UncheckedAccess
FUNCTION Check_Manual_Rows (
   price_query_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_     NUMBER;
   CURSOR get_manual IS
      SELECT 1
      FROM PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE price_query_id = price_query_id_
      AND discount_source = 'MANUAL';
BEGIN
   OPEN get_manual;
   FETCH get_manual INTO dummy_;
   IF (get_manual%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE get_manual;
   RETURN (dummy_ = 1);
END Check_Manual_Rows;


-----------------------------------------------------------------------------
-- Get_Total_Line_Discount
--    Returns calculated line discount amount.
--    When a price query has multiple discount lines, discount for each line is calculated and rounded first.
--    Then it is added to total discount amount.
--    When calculating total discount percentage; unrounded line discount is used. Then currency_rounding_ should be null.
--    If use price including tax is true and discount amount is needed without tax, tax_percentage_ should not be null.
-----------------------------------------------------------------------------
-- gelr:disc_price_rounded, added use_price_incl_tax_ as a parameter
@UncheckedAccess
FUNCTION Get_Total_Line_Discount (
   price_query_id_      IN NUMBER,
   quantity_            IN NUMBER,
   price_conv_factor_   IN NUMBER, 
   currency_rounding_   IN NUMBER DEFAULT NULL,
   tax_percentage_      IN NUMBER DEFAULT NULL,
   use_price_incl_tax_  IN VARCHAR2 DEFAULT 'TRUE') RETURN NUMBER
IS
   discount_amount_     NUMBER :=0;
   total_line_discount_ NUMBER :=0;
   
   CURSOR get_line_discounts IS
      SELECT (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM  PRICE_QUERY_DISCOUNT_LINE_TAB
      WHERE price_query_id = price_query_id_;

BEGIN
   -- gelr:disc_price_rounded, if Discunted Price Rounded and not Price incl Tax, redirected the code to Get_Total_Line_Disc_Rounded___
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(Site_API.Get_Company(Price_Query_API.Get_Contract(price_query_id_)), 'DISC_PRICE_ROUNDED') = 'TRUE') AND (use_price_incl_tax_ = 'FALSE') THEN
      RETURN Get_Total_Line_Disc_Rounded___(price_query_id_, quantity_, price_conv_factor_, currency_rounding_ ); 
   ELSE
      FOR discount_rec_ IN get_line_discounts LOOP
         discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_);
         IF currency_rounding_ IS NOT NULL THEN
            discount_amount_     := ROUND(discount_amount_ , currency_rounding_);
         END IF;
         -- NOTE: When using Price Including Tax, discount can be obtained with tax or without tax. Calculation Basis of the table is stored with tax amount. 
         --       So seperate calculation is done to take discount without tax and this only applies when Price Including Tax is used for the customer order.
         IF (tax_percentage_ IS NOT NULL) THEN
            discount_amount_  := discount_amount_ / (1 + (tax_percentage_/100));
            -- Re-round the discount amount without tax
            IF currency_rounding_ IS NOT NULL THEN
               discount_amount_     := ROUND(discount_amount_ , currency_rounding_);
            END IF;
         END IF;            
         total_line_discount_ := total_line_discount_ + discount_amount_;
      END LOOP;
      RETURN total_line_discount_;
   END IF;
END Get_Total_Line_Discount;



