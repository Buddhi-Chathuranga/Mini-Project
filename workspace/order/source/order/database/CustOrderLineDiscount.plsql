----------------------------------------------------------------------------
--
--  Logical unit: CustOrderLineDiscount
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220321  MaEelk   SCDEV-8593, Reversed the correction SCZ-15489 and added condition (unit_price_ = 0) back in Modified Calculate_Discount__()
--  210712  ThKrlk   Bug 159876(SCZ-15489), Modified Calculate_Discount__() by removing the logic which made discount percentage 0 when unit price is 0
--  210528  MaEelk   SC21R2-1285, Modified Calculate_Discount__ and rounded value after calculating the price after discount instead of rounding the discounted value
--  210528           when the Discounted Price Rounded is enabled
--  201005  Maeelk   GESPRING20-5893, Added Get_Original_Total_Line_Disc in order to calculate Total Customer Order Line Discount Percentage
--  200826  MaEelk   GESPRING20-5398, Modified Calculate_Discount__, Get_Total_Line_Discount, 
--  200826           Added Calculate_Original_Discount__ and Get_Total_Line_Disc_Rounded___. 
--  200703  NiDalk   SCXTEND-4438, Modified Calc_Discount_Upd_Co_Line__ to add parameter update_tax_.
--  190930  DaZase   SCSPRING20-138, Added Raise_No_Discount_Error___ and Raise_Both_Discount_Error___ to solve MessageDefinitionValidation issues.
--  190724  KiSalk   Bug 149239(SCZ-5775), In Recalculate_Tax_Lines___, used tax_code of CO line when creating tax_line_param_rec_ 
--  190724           because it is required in comparison for single tax line recalculation.
--  190517  KiSalk   Bug 140365, Modified Get_Total_Line_Discount adding parameter rent_chargeable_days_ not to refetch in order to improve performance.
--  180712  BudKlk   Bug 142170, Modified the method Calculate_Discount__() to avoid 'division by zero' error.
--  141119  KoDelk   Bug 119800, Added new function Get_Total_Line_Discount__()
--  140711  MaEelk   Added a call to Calc_Discount_Upd_Co_Line__ from Add_Remove_Update_Line in the case of adding a new discount line.
--  140709  MaEelk   Added Get_Discount_Line_Count to fetch the no. of discount lines connected to a customer order line.
--  140709           Added Add_Remove_Update_Line to add or remove or modify a discount line according to the changes done for the discount column in Customer Order Line.
--  140709           Added Modify_Discount to modify the Dicount and also to assign a null value to the Discount_Amount 
--  131119  RuLiLk   Bug 113865, Modified method Calculate_Discount__. Unrounded discount amount is used for the calculation of discount percentage when using partial discounts.
--  140217  NaSalk   Added Check_Common___ method to add validation related to rental events. 
--  140214  NaSalk   Modified Get_Total_Line_Discount to include rental chargeable days.
--  140307  HimRlk   Merged Bug 110133-PIV, Added new method Get_Total_Line_Discount() to calculate customer order line discount to be consistant with discount postings.
--  130730  RuLiLk   Bug 110133, Modified method Get_Total_Line_Discount() by removing parameter base_curr_rate_.
--  130630  RuLiLk   Bug 110133, Added new method Get_Total_Line_Discount() to calculate customer order line discount to be consistant with discount postings.
--  130521  jokbse   Bug 109770, Merge, Modified method Calculate_Discount__. Unrounded discount amount is used for the calculation of discount percentage when using partial discounts.
--  130430  RuLiLk   Bug 109527, Modified method Calculate_Discount__ by removing the condition that compares sum of calculated  line level discount amount 
--  130430           with calculated total discount amount when only discount percentages are given.
--  120813  HimRlk   Added new column price_currency_incl_tax and price_base_incl_tax. Modified Calculate_Discount__() 
--  120813           to consider use_price_incl_tax when calculating discounts.
--  110803  NWeelk   Bug 95555, Modified method Unpack_Check_Update___ by checking whether the discount_amount has changed before setting the discount_source to MANUAL.    
--  110514  AmPalk   Bug 95151, Removed net_amount_ from call Cust_Order_Line_Tax_Lines_API.Recalculate_Tax_Lines.
--  100520  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090527  SuJalk   Bug 83173, Changed the error constant to NOADDDISCOUNT to make it unique within the LU in method Unpack_Check_Insert___.
--  081124  ThAylk   Bug 74643, Modified method New to move the call to Calc_Discount_Upd_Co_Line__ into Customer_Order_Pricing_API.Modify_Default_Discount_Rec.
--  090324  DaZase   Added new columns part_level, part_level_id, customer_level and customer_level_id.
--  071224  MaRalk   Bug 64486, Modified function Calculate_Discount__ to consider currency rate type in CO when calculate price in currency.
--  070302  MaMalk   Bug 63189, Modified condition in Unpack_Check_Insert___ and Unpack_Check_Update___ 
--  070302           to stop entering negative discount amounts, when price of the CO line is 0. 
--  070130  NaWilk   Bug 62020, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to stop the user from setting
--  070130           a discount amount or a % > 0 by raising an error msg, when the calculation basis is 0.
--  ---------------------------- 13.4.0 ----------------------------------------
--  060110  CsAmlk   Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050926  IsAnlk   Added customer_no as parameter to Customer_Order_Pricing_API.Get_Base_Price_In_Currency call.
--  050922  SaMelk   Removed unused variables.
--  050417  JOHESE   Added method Get_Discount_Source_Db
--  040219  IsWilk   Removed the SUBSTRB from the view for Unicode Changes.
--  -----------------EDGE Package Group 3 Unicode Changes-----------------------
--  030903  SaNalk   Modified PROCEDURE Calc_Discount_Upd_Co_Line__ to recalculate Tax Lines.
--  030821  MaGulk   Merged CR
--  030616  NuFilk   Removed method Create_New_Discount_Lines.
--  030609  NuFilk   Added method Create_New_Discount_Lines.
--  *********************************** CR Merge *****************************
--  021212  Asawlk   Merged bug fixes in 2002-3 SP3
--  021024  JoAnSe   Bug 33693, Changes in Calculate_Discount__ to avoid uneccessary
--                   problems with uneven discount percentages on the order line.
--  020918  JoAnSe   Corrected Calculate_Discount__ to handle zero price.
--  020912  JoAnSe   Bug 32740, Corrected calculation of total_discount for price = 0
--                   in Calculate_Discount__
--  020828  JoAnSe   Bug 31296, Rewrote the metod Calculate_Discount__ from scratch.
--  020318  JeLise   Bug 28472, Added linerec_.price_conv_factor in calculation of discount_amount
--                   in Calculate_Discount__.
--  010927  CaSt     Bug 23974. Added check if temp_ = 0 in Calculate_Discount__.
--  010830  CaSt     Bug 23974. Modified Calculate_Discount__, price_conv_factor is regarded.
--  010613  Cara     Bug fix 21492, Inserted roundings, insert buy_qty_due in calculation of
--                   the sales_price in Calculate_Discount__ and Get_Total_Discount.
--  010219  LeIsse   Bug fix 18966, Removed roundings in Calculate_Discount__.
--  001218  MaGu     Added parmameter discount_amount to method New.
--  001121  MaGu     Modified cursor get_calc_basis in method Get_Total_Discount to get correct discount_line_no.
--  001107  MaGu     Modified method New. Added parameter discount_source_id.
--  001106  MaGu     Added public attribute discount_source_id.
--  001031  MaGu     Changed key in cust_order_line_discount_tab. Added new key discount_no_
--                   and made old key discount_type_ to public attribute.
--  000913  FBen     Added UNDEFINE.
--  000719  TFU      Merging from Chameleon
--  000717  DEHA     Added procedure Calc_Discount_Upd_Co_Line__ and changed
--                   exiting procedure Calculate_Discount__ into a function
--                   which only returns the total discount; takes over the old
--                   job of Calculate_Discount__ ( reason: loops on CO line)
--  --------------   ---------------- 12.10 ------------------------------------
--  000605  JoAn     Bug Id 16362 Changed check for line status in Unpack_Check_Insert___
--                   and Unpack_Check_Update___ in order to allow changes in discounts
--                   for order lines in state 'Delivered'.
--  000303  JoAn     Corrected roundings in Calculate_Discount__
--  000216  JoAn     Added roundings in Calculate_Discount__
--  991118  JoEd     Beautified code.
--  991020  JOHW     Corrected Get_Total_Discount.
--  991002  JOHW     Added functionality for Multiple Discounts.
--  990927  JOHW     Added new public function Get_Total_Discount.
--  990924  JOHW     Added procedures Calculate_Discount and Modify_Discount_Data.
--  990921  JOHW     Added procedure New.
--  990916  JOHW     Added Discount_Line_No.
--  990914  JOHW     Added create_partial_sum in prepare_insert.
--  990830  JOHW     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_No_Discount_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DISCOUNTMISSING: You have to enter a Discount or a Discount Amount.');
END Raise_No_Discount_Error___;   

PROCEDURE Raise_Both_Discount_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'TWODISCOUNT: Both Discount and Discount Amount can not be used at the same time.');
END Raise_Both_Discount_Error___;

-- Modify_Discount_Data___
--   Update the discount data for one discount record.
PROCEDURE Modify_Discount_Data___ (
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   rel_no_                    IN VARCHAR2,
   line_item_no_              IN NUMBER,
   discount_no_               IN NUMBER,
   calculation_basis_         IN NUMBER,
   price_currency_            IN NUMBER,
   price_currency_incl_tax_   IN NUMBER,
   price_base_                IN NUMBER,
   price_base_incl_tax_       IN NUMBER  )
IS
   oldrec_               CUST_ORDER_LINE_DISCOUNT_TAB%ROWTYPE;
   newrec_               CUST_ORDER_LINE_DISCOUNT_TAB%ROWTYPE;
   attr_                 VARCHAR2(2000) := NULL;
   objid_                CUST_ORDER_LINE_DISCOUNT.objid%TYPE;
   objversion_           CUST_ORDER_LINE_DISCOUNT.objversion%TYPE;
   indrec_               Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CALCULATION_BASIS', calculation_basis_, attr_);
   Client_SYS.Add_To_Attr('PRICE_CURRENCY', price_currency_, attr_);
   Client_SYS.Add_To_Attr('PRICE_BASE', price_base_, attr_);
   Client_SYS.Add_To_Attr('PRICE_CURRENCY_INCL_TAX', price_currency_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('PRICE_BASE_INCL_TAX', price_base_incl_tax_, attr_);

   oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, discount_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By Keys.
END Modify_Discount_Data___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CREATE_PARTIAL_SUM_DB', 'NOT PARTIAL SUM', attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_SOURCE', Discount_Source_API.Decode('MANUAL'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_LINE_DISCOUNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_seq_no (order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2, line_item_no_ IN NUMBER) IS
      SELECT nvl(max(discount_no) + 1, 1)
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

BEGIN
   OPEN get_seq_no(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   FETCH get_seq_no INTO newrec_.discount_no;
   CLOSE get_seq_no;
   Client_SYS.Add_To_Attr('DISCOUNT_NO', newrec_.discount_no, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_order_line_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(4000);
   objstate_ VARCHAR2(20);
BEGIN  
   super(newrec_, indrec_, attr_);

   objstate_ := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);

   IF ((newrec_.calculation_basis = 0) AND (newrec_.discount_amount != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the order line price.');
   END IF;

   IF (objstate_ IN ('Invoiced', 'Cancelled')) THEN
      Error_SYS.Record_General(lu_name_, 'NOADDDISCOUNT: No order line discounts may be added to an order line when the order line is Invoiced/Closed or Cancelled.');
   END IF;

   IF (newrec_.discount IS NULL) AND (newrec_.discount_amount IS NULL) THEN
      Raise_No_Discount_Error___;
   END IF;

   IF (newrec_.discount IS NOT NULL) AND (newrec_.discount_amount IS NOT NULL) THEN
      Raise_Both_Discount_Error___;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_order_line_discount_tab%ROWTYPE,
   newrec_ IN OUT cust_order_line_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_     VARCHAR2(30);
   value_    VARCHAR2(4000);
   objstate_ VARCHAR2(20);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   objstate_ := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);

   IF ((newrec_.calculation_basis = 0) AND (newrec_.discount_amount != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the order line price.');
   END IF;

   IF (objstate_ IN ('Invoiced', 'Cancelled')) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNT: Order line discounts may not be changed when the order line is Invoiced/Closed or Cancelled.');
   END IF;

   IF (newrec_.discount IS NULL) AND (newrec_.discount_amount IS NULL) THEN
      Raise_No_Discount_Error___;
   END IF;

   IF (newrec_.discount IS NOT NULL) AND (newrec_.discount_amount IS NOT NULL) THEN
      Raise_Both_Discount_Error___;
   END IF;

   IF (newrec_.discount_source NOT IN ('MANUAL')) THEN
      IF (NVL(oldrec_.discount, -9999) <> NVL(newrec_.discount, -9999)) OR (NVL(oldrec_.discount_amount, -9999) <> NVL(newrec_.discount_amount, -9999)) THEN
         newrec_.discount_source := 'MANUAL';
         newrec_.discount_source_id := NULL;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     cust_order_line_discount_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY cust_order_line_discount_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_); 
   IF (Customer_Order_Line_API.Get_Rental_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = Fnd_Boolean_API.DB_TRUE) THEN
      Validate_Rental_Period___(newrec_);
   END IF;   
END Check_Common___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN cust_order_line_discount_tab%ROWTYPE )
IS
BEGIN
   super(remrec_); 
   IF (Customer_Order_Line_API.Get_Rental_Db(remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no) = Fnd_Boolean_API.DB_TRUE) THEN
      Validate_Rental_Period___(remrec_);
   END IF;   
END Check_Delete___;


PROCEDURE Validate_Rental_Period___ (
   rec_ IN     cust_order_line_discount_tab%ROWTYPE )
IS 
   rental_period_exists_  BOOLEAN := FALSE;
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_period_exists_ := Rental_Object_Manager_API.Rental_Period_Exists(rec_.order_no,
                                                                              rec_.line_no,
                                                                              rec_.rel_no,
                                                                              rec_.line_item_no,
                                                                              Rental_Type_API.DB_CUSTOMER_ORDER);
   $ELSE
      Error_SYS.Component_Not_Exist('RENTAL');
   $END
   IF (rental_period_exists_) THEN 
      Error_SYS.Record_General(lu_name_, 'DISCWHENRENTPERIOD: It is not possible to edit the discount information as rental events exist.');
   END IF;
END Validate_Rental_Period___;
   

PROCEDURE Recalculate_Tax_Lines___ (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   company_             IN VARCHAR2,
   contract_            IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   ship_addr_no_        IN VARCHAR2,   
   use_price_incl_tax_  IN VARCHAR2,
   currency_code_       IN VARCHAR2,   
   conv_factor_         IN NUMBER,
   attr_                IN VARCHAR2)
IS  
   source_key_rec_      Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_  Tax_Handling_Order_Util_API.tax_line_param_rec;
   order_line_rec_      Customer_Order_Line_API.Public_Rec;
   supply_country_db_   VARCHAR2(2);
BEGIN
  source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                                     order_no_, 
                                                                     line_no_, 
                                                                     rel_no_, 
                                                                     line_item_no_, 
                                                                     '*',
                                                                     attr_);
                                                                     
   order_line_rec_     := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);                                                                  
   supply_country_db_  := Customer_Order_API.Get_Supply_Country_Db(order_no_);
   -- Passed order_line_rec_.tax_code for tax_code_ as it is required in comparison for single tax line recalculation
   tax_line_param_rec_ := Tax_Handling_Order_Util_API.Create_Tax_Line_Param_Rec (company_                   => company_,
                                                                                 contract_                  => contract_,
                                                                                 customer_no_               => customer_no_,
                                                                                 ship_addr_no_              => ship_addr_no_,
                                                                                 planned_ship_date_         => order_line_rec_.planned_ship_date,
                                                                                 supply_country_db_         => supply_country_db_,
                                                                                 delivery_type_             => order_line_rec_.delivery_type,
                                                                                 object_id_                 => order_line_rec_.catalog_no,
                                                                                 use_price_incl_tax_        => use_price_incl_tax_,
                                                                                 currency_code_             => currency_code_,
                                                                                 currency_rate_             => order_line_rec_.currency_rate,                                                                                       
                                                                                 conv_factor_               => conv_factor_,
                                                                                 from_defaults_             => FALSE,
                                                                                 tax_code_                  => order_line_rec_.tax_code,
                                                                                 tax_calc_structure_id_     => NULL,
                                                                                 tax_class_id_              => NULL,
                                                                                 tax_liability_             => order_line_rec_.tax_liability,
                                                                                 tax_liability_type_db_     => order_line_rec_.tax_liability_type,
                                                                                 delivery_country_db_       => order_line_rec_.country_code,
                                                                                 add_tax_lines_             => TRUE,
                                                                                 net_curr_amount_           => NULL,
                                                                                 gross_curr_amount_         => NULL,
                                                                                 ifs_curr_rounding_         => NULL,
                                                                                 free_of_charge_tax_basis_  => order_line_rec_.free_of_charge_tax_basis,
                                                                                 attr_                      => attr_);

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;

-- gelr:disc_price_rounded, begin
-- This method should be executed only if the Discounted Price Rounded is enabled and No Price including Tax
FUNCTION Get_Total_Line_Disc_Rounded___ (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER, 
   currency_rounding_ IN NUMBER) RETURN NUMBER
IS
   total_line_discount_ NUMBER :=0;
   discounted_price_    NUMBER :=0;
   net_before_disc_     NUMBER :=0;
   net_after_disc_      NUMBER :=0;
   line_rec_            Customer_Order_Line_API.Public_Rec;
   rounding_            NUMBER;
   -- rounded discount price is stored at last line of cust_invoice_item_discount_tab
   CURSOR get_discounted_price IS
      SELECT price_currency 
      FROM   cust_order_line_discount_tab t
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      ORDER BY discount_line_no DESC;
BEGIN   
   line_rec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   rounding_ := NVL(currency_rounding_, Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(line_rec_.contract),
                                                                                Customer_Order_API.Get_currency_Code(order_no_)));
   
   net_before_disc_ := ROUND(line_rec_.sale_unit_price * quantity_ * price_conv_factor_, rounding_);
   
   OPEN get_discounted_price;
   FETCH get_discounted_price INTO discounted_price_;
   IF get_discounted_price%NOTFOUND THEN
      RETURN 0;
   END IF;
   CLOSE get_discounted_price;
   discounted_price_ := ROUND(discounted_price_, rounding_); 
   net_after_disc_ := ROUND(discounted_price_ * quantity_ * price_conv_factor_, rounding_);
   
   -- diff of rounded values
   total_line_discount_ := net_before_disc_ - net_after_disc_;
   RETURN total_line_discount_;
END Get_Total_Line_Disc_Rounded___;
-- gelr:disc_price_rounded, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calculate_Discount__
--   Recalculates the discount for for all discount records connected to an
--   order line. Also updates the discount on the order line.
FUNCTION Calculate_Discount__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_                   Customer_Order_Line_API.Public_Rec;
   total_discount_amount_ NUMBER;
   total_discount_        NUMBER;

   unit_price_            NUMBER;

   rental_chargable_days_ NUMBER;

BEGIN
   line_rec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- if value of use_price_incl_tax is TRUE in customer order header, discount will be calculated based on 
   -- price including tax value of the order line.
   IF Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'FALSE'  THEN
 
      unit_price_            := line_rec_.sale_unit_price;

   ELSE

      unit_price_            := line_rec_.unit_price_incl_tax;

   END IF;

   IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         rental_chargable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(order_no_,
                                                                             line_no_,
                                                                             rel_no_,
                                                                             line_item_no_,
                                                                             Rental_Type_API.DB_CUSTOMER_ORDER);
      $ELSE
         NULL;
      $END
   END IF;
   
   -- Whole calculation logic of the method is moved to the new Calculate_Discount__ method introduced by the bug.
   Calculate_Discount__ (total_disc_pct_  => total_discount_,
                         total_disc_amt_  => total_discount_amount_,
                         order_no_        => order_no_,
                         line_no_         => line_no_,
                         rel_no_          => rel_no_,
                         line_item_no_    => line_item_no_,
                         unit_price_      => unit_price_,
                         quantity_        => line_rec_.buy_qty_due ,
                         price_conv_fact_ => line_rec_.price_conv_factor,
                         server_invoke_   => 'TRUE',
                         rental_chargeable_days_ => NVL(rental_chargable_days_, 1));

   RETURN total_discount_;

END Calculate_Discount__;

-- Calculate_Discount__
--    Method takes details from the order line and recalculates discounts for all discount records connected to an order line.
--    This method is called from both server and client. Discount values are updated only when called from Sever.
--    The client call is done, when a value affecting calculation basis is modified but still haven't commited the change to the server.
--    tax_percentage_ is sent from client, to calculate discount amounts without tax when price including tax is specified.
PROCEDURE Calculate_Discount__ (
   total_disc_pct_  OUT NUMBER,
   total_disc_amt_  OUT NUMBER,
   order_no_        IN  VARCHAR2,
   line_no_         IN  VARCHAR2,
   rel_no_          IN  VARCHAR2,
   line_item_no_    IN  NUMBER,
   unit_price_      IN  NUMBER,
   quantity_        IN  NUMBER,
   price_conv_fact_ IN  NUMBER,
   server_invoke_   IN  VARCHAR2 DEFAULT 'FALSE',   
   rental_chargeable_days_ IN NUMBER DEFAULT 1)
IS
   order_rec_                  Customer_Order_API.Public_Rec;

   currency_rounding_          NUMBER;
   calculation_basis_          NUMBER;
   line_discount_amount_       NUMBER;
   total_discount_amount_      NUMBER;
   total_discount_             NUMBER;
   currency_code_              VARCHAR2(3);
   price_qty_                  NUMBER;
   unround_line_disc_amount_   NUMBER;
   unround_total_disc_amount_  NUMBER;
   
   no_sum_or_amount_           BOOLEAN := TRUE;
   total_discount_percentage_  NUMBER := 0;   
   last_price_curr_ NUMBER;
   tax_line_param_rec_         Tax_Handling_Order_Util_API.tax_line_param_rec;
   price_base_                NUMBER;
   price_base_incl_tax_       NUMBER;
   price_currency_            NUMBER;
   price_currency_incl_tax_   NUMBER;
   company_                   VARCHAR2(20);
   multiple_tax_              VARCHAR2(20);
   -- gelr:disc_price_rounded, begin
   discounted_price_rounded_  BOOLEAN := Customer_Order_API.Get_Discounted_Price_Rounded(order_no_);
   -- gelr:disc_price_rounded, end
   
   CURSOR get_line IS
      SELECT  discount, discount_amount, create_partial_sum, discount_no
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      ORDER BY discount_line_no;
BEGIN

   order_rec_ := Customer_Order_API.Get(order_no_);
   currency_code_ := order_rec_.currency_code;
   company_       := Site_API.Get_Company(order_rec_.contract);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   
   last_price_curr_ := unit_price_;
   calculation_basis_ := last_price_curr_;
   price_qty_ := quantity_ * price_conv_fact_;
   total_discount_amount_ := 0;
   unround_total_disc_amount_ := 0;

   FOR rec_ IN get_line LOOP
      tax_line_param_rec_ := Customer_Order_Line_API.Fetch_Tax_Line_Param(company_, order_no_, line_no_, rel_no_, line_item_no_);
      -- Calculate the price after discount in order currency
      IF (rec_.discount_amount IS NULL) THEN
         IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
            price_currency_incl_tax_ := last_price_curr_ - (calculation_basis_ * (rec_.discount / 100));
         ELSE 
            -- gelr:disc_price_rounded, rounded discounted price if Disc Price Round is enabled.
            IF (discounted_price_rounded_) THEN
               --  To calculate discount percentage on the order line use rounded dicounted price.
               price_currency_ := ROUND((last_price_curr_ - (calculation_basis_ * (rec_.discount / 100))), currency_rounding_);
            ELSE            
               price_currency_ := last_price_curr_ - (calculation_basis_ * (rec_.discount / 100));
            END IF;
         END IF;
      ELSE
         IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
            price_currency_incl_tax_ := last_price_curr_ - rec_.discount_amount;
         ELSE
            price_currency_ := last_price_curr_ - rec_.discount_amount;
         END IF;
      END IF;
      
      Tax_Handling_Order_Util_API.Get_Prices(price_base_,
                                             price_base_incl_tax_,
                                             price_currency_,
                                             price_currency_incl_tax_,
                                             multiple_tax_,
											            tax_line_param_rec_.tax_code,
                                             tax_line_param_rec_.tax_calc_structure_id,
                                             tax_line_param_rec_.tax_class_id,
                                             order_no_, 
                                             line_no_, 
                                             rel_no_, 
                                             line_item_no_,
                                             '*',
                                             Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                             tax_line_param_rec_.contract,
                                             tax_line_param_rec_.customer_no,
                                             tax_line_param_rec_.ship_addr_no,
                                             tax_line_param_rec_.planned_ship_date,
                                             tax_line_param_rec_.supply_country_db,
                                             tax_line_param_rec_.delivery_type,
                                             tax_line_param_rec_.object_id,
                                             tax_line_param_rec_.use_price_incl_tax,
                                             tax_line_param_rec_.currency_code,
                                             tax_line_param_rec_.currency_rate,
                                             'FALSE',                                             
                                             tax_line_param_rec_.tax_liability,
                                             tax_line_param_rec_.tax_liability_type_db,
                                             delivery_country_db_ => NULL,
                                             ifs_curr_rounding_ => 16,
                                             tax_from_diff_source_ => 'FALSE',
                                             attr_ => NULL);

      IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
         unround_line_disc_amount_ := (last_price_curr_ - price_currency_incl_tax_) * price_qty_ * NVL(rental_chargeable_days_, 1);
      ELSE
         unround_line_disc_amount_ := (last_price_curr_ - price_currency_) * price_qty_ * NVL(rental_chargeable_days_, 1);
      END IF;
      line_discount_amount_ := ROUND(unround_line_disc_amount_, currency_rounding_);

      -- Add up the total discount amount for the ordered qty so far
      total_discount_amount_ := total_discount_amount_ + line_discount_amount_;
      unround_total_disc_amount_ := unround_total_disc_amount_ + unround_line_disc_amount_;
      
      IF (server_invoke_ = 'TRUE') THEN
         -- Update the discount record
         Modify_Discount_Data___(order_no_, line_no_, rel_no_, line_item_no_, rec_.discount_no,
                                 calculation_basis_, price_currency_, price_currency_incl_tax_, price_base_, price_base_incl_tax_);
      END IF;

      IF (no_sum_or_amount_ = TRUE) THEN
         -- Modified condition code. calculation_basis_ should be compared with unit_price_ inseated of applicable_price_currency_.
         -- Otherwise discount percentage calculation will always work as if partial sum is checked.
         IF (calculation_basis_ != unit_price_  ) OR (rec_.discount_amount IS NOT NULL) THEN
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
         -- Use the price/price incl tax after discount as new calculation basis
         IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
            calculation_basis_ := price_currency_incl_tax_;
         ELSE
            calculation_basis_ := price_currency_;
         END IF;
      END IF; 
      
      IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
         last_price_curr_ := price_currency_incl_tax_;
      ELSE
         last_price_curr_ := price_currency_;
      END IF;

   END LOOP;

   IF (unit_price_ = 0) THEN
      total_discount_ := 0;
   ELSIF ((no_sum_or_amount_ = TRUE) AND NOT(discounted_price_rounded_)) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the order line
      total_discount_ := total_discount_percentage_;
   ELSE
      IF (price_qty_ != 0) THEN 
         total_discount_ := (unround_total_disc_amount_ / (unit_price_ * price_qty_ * rental_chargeable_days_)) * 100;
      ELSE
         total_discount_ := 0;
      END IF;
   END IF;
   
   total_disc_pct_  := total_discount_;
   total_disc_amt_  := total_discount_amount_;

END Calculate_Discount__;


-- Calc_Discount_Upd_Co_Line__
--   Recalculates the discount for for all discount records connected to
--   an order line Also updates the discount on the order line.
PROCEDURE Calc_Discount_Upd_Co_Line__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   update_tax_   IN VARCHAR2 DEFAULT 'TRUE')
IS
   total_discount_      NUMBER;
   order_rec_           Customer_Order_API.Public_Rec;
   line_rec_            Customer_Order_Line_API.Public_Rec;
   company_             VARCHAR2(20);
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);
   company_ := Site_API.Get_Company(order_rec_.contract);
   
   total_discount_ := Calculate_Discount__(order_no_, line_no_, rel_no_, line_item_no_);
   Customer_Order_Line_API.Modify_Discount__(order_no_, line_no_, rel_no_, line_item_no_, total_discount_, update_tax_);
   
   line_rec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   
   IF (update_tax_ = 'TRUE') THEN 
      Recalculate_Tax_Lines___(order_no_,
                               line_no_,
                               rel_no_,
                               line_item_no_,
                               company_,
                               order_rec_.contract,
                               order_rec_.customer_no,
                               order_rec_.ship_addr_no,
                               order_rec_.use_price_incl_tax,
                               order_rec_.currency_code,                                  
                               line_rec_.price_conv_factor,
                               NULL); 
   END IF;
END Calc_Discount_Upd_Co_Line__;


@UncheckedAccess
FUNCTION Get_Total_Line_Discount__ (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER ) RETURN NUMBER
IS
   order_rec_           Customer_Order_API.Public_Rec;
   currency_rounding_   NUMBER;
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(order_rec_.contract), order_rec_.currency_code);
   RETURN Get_Total_Line_Discount(order_no_, line_no_, rel_no_, line_item_no_, quantity_, price_conv_factor_, currency_rounding_);
END Get_Total_Line_Discount__;

-- gelr:disc_price_rounded, begin
@UncheckedAccess
FUNCTION Calculate_Original_Discount__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_                Customer_Order_Line_API.Public_Rec;
   total_discount_amount_   NUMBER;
   total_discount_          NUMBER;
   unit_price_              NUMBER;
   rental_chargeable_days_  NUMBER;

BEGIN
   line_rec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- if value of use_price_incl_tax is TRUE in customer order header, discount will be calculated based on 
   -- price including tax value of the order line.
   IF Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'FALSE'  THEN
      unit_price_            := line_rec_.sale_unit_price;
   ELSE
      unit_price_            := line_rec_.unit_price_incl_tax;
   END IF;

   IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         rental_chargeable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(order_no_,
                                                                             line_no_,
                                                                             rel_no_,
                                                                             line_item_no_,
                                                                             Rental_Type_API.DB_CUSTOMER_ORDER);
      $ELSE
         NULL;
      $END
   END IF;
   
   Calculate_Original_Discount__ (total_discount_,
                         total_discount_amount_,
                         order_no_,
                         line_no_,
                         rel_no_,
                         line_item_no_,
                         unit_price_,
                         line_rec_.buy_qty_due ,
                         line_rec_.price_conv_factor,
                         NVL(rental_chargeable_days_, 1));

   RETURN total_discount_;
END Calculate_Original_Discount__;


-- The same as Calculate_Discount__ but without rounding and wihout Modify_Discount_Data___
-- It gives us exactly percentage of discount as user entered (not recalculated to achive rounded amount of discount)
-- It is used only to display the exactly percentage of discount.
PROCEDURE Calculate_Original_Discount__ (
   total_disc_pct_         OUT NUMBER,
   total_disc_amt_         OUT NUMBER,
   order_no_               IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   unit_price_             IN  NUMBER,
   quantity_               IN  NUMBER,
   price_conv_fact_        IN  NUMBER,
   rental_chargeable_days_ IN  NUMBER DEFAULT 1)
IS
   calculation_basis_          NUMBER;
   total_discount_             NUMBER;
   price_qty_                  NUMBER;
   unround_line_disc_amount_   NUMBER;
   unround_total_disc_amount_  NUMBER;
   no_sum_or_amount_           BOOLEAN := TRUE;
   total_discount_percentage_  NUMBER := 0;   
   applicable_price_currency_  NUMBER;
   last_applicable_price_curr_ NUMBER;

   CURSOR get_line IS
      SELECT  discount, discount_amount, create_partial_sum, discount_no
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      ORDER BY discount_line_no;
          
BEGIN
   last_applicable_price_curr_ := unit_price_;
   
   calculation_basis_ := last_applicable_price_curr_;

   price_qty_ := quantity_ * price_conv_fact_;

   unround_total_disc_amount_ := 0;

   FOR rec_ IN get_line LOOP
      -- Calculate the price after discount in order currency
      IF (rec_.discount_amount IS NULL) THEN
         applicable_price_currency_ := last_applicable_price_curr_ - (calculation_basis_ * (rec_.discount / 100));
      ELSE
         applicable_price_currency_ := last_applicable_price_curr_ - rec_.discount_amount;
      END IF;

      unround_line_disc_amount_ := (last_applicable_price_curr_ - applicable_price_currency_) * price_qty_ * rental_chargeable_days_;
      -- Add up the unrounded discount amount for the ordered qty so far
      unround_total_disc_amount_ := unround_total_disc_amount_ + unround_line_disc_amount_;

      IF (no_sum_or_amount_ = TRUE) THEN
         -- Modified condition code. calculation_basis_ should be compared with unit_price_ inseated of applicable_price_currency_.
         -- Otherwise discount percentage calculation will always work as if partial sum is checked.
         IF (calculation_basis_ != unit_price_  ) OR (rec_.discount_amount IS NOT NULL) THEN
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
         calculation_basis_ := applicable_price_currency_;
      END IF;

      last_applicable_price_curr_ := applicable_price_currency_;

   END LOOP;

   IF (unit_price_ = 0) THEN
      total_discount_ := 0;
   ELSIF (no_sum_or_amount_ = TRUE) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the order line
      total_discount_ := total_discount_percentage_;      
   ELSE
      total_discount_ := (unround_total_disc_amount_ / (unit_price_ * price_qty_ * rental_chargeable_days_)) * 100;
   END IF;
   
   total_disc_pct_  := total_discount_;
   total_disc_amt_  := unround_total_disc_amount_;

END Calculate_Original_Discount__;
-- gelr:disc_price_rounded, end

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public method used when a discount entry i automaticly created from
--   customer order line.
PROCEDURE New (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   discount_type_      IN VARCHAR2,
   discount_found_     IN NUMBER,
   discount_source_    IN VARCHAR2,
   create_partial_sum_ IN VARCHAR2,
   discount_line_no_   IN NUMBER,
   discount_source_id_ IN VARCHAR2,
   discount_amount_    IN NUMBER DEFAULT NULL,
   part_level_         IN VARCHAR2,
   part_level_id_      IN VARCHAR2,
   customer_level_     IN VARCHAR2,
   customer_level_id_  IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000) := NULL;
   objid_       CUST_ORDER_LINE_DISCOUNT.objid%TYPE;
   objversion_  CUST_ORDER_LINE_DISCOUNT.objversion%TYPE;
   newrec_      CUST_ORDER_LINE_DISCOUNT_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   -- don't call Prepare_Insert___ to avoid setting wrong IID values
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_found_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_DB', discount_source_, attr_);
   Client_SYS.Add_To_Attr('CREATE_PARTIAL_SUM_DB', create_partial_sum_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_LINE_NO', discount_line_no_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_ID', discount_source_id_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_AMOUNT', discount_amount_, attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_DB', part_level_, attr_);
   Client_SYS.Add_To_Attr('PART_LEVEL_ID', part_level_id_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB', customer_level_, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID', customer_level_id_, attr_);
   Unpack___(newrec_, indrec_, attr_); 
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Get_Total_Discount
--   Returns the total discount for all discount rows on a customer order line.
@UncheckedAccess
FUNCTION Get_Total_Discount (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   discount_line_no_       NUMBER;
   calculation_basis_      NUMBER;
   last_price_currency_    NUMBER;
   total_discount_         NUMBER;
   temp_                   NUMBER;
   buy_qty_due_            NUMBER;

   CURSOR get_calc_basis IS
      SELECT calculation_basis
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE discount_line_no = (SELECT MIN(discount_line_no)
                                FROM CUST_ORDER_LINE_DISCOUNT_TAB
                                WHERE order_no = order_no_
                                AND   line_no = line_no_
                                AND   rel_no = rel_no_
                                AND   line_item_no = line_item_no_)
      AND   order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

   CURSOR get_price_curr IS
      SELECT price_currency
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE discount_line_no = discount_line_no_
      AND   order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

    --cara
   CURSOR get_buy_qty_due IS
      SELECT buy_qty_due
      FROM Customer_Order_Line_Tab
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

BEGIN
   discount_line_no_ := Get_Last_Discount_Line_No(order_no_, line_no_, rel_no_, line_item_no_);

   OPEN get_calc_basis;
   FETCH get_calc_basis INTO calculation_basis_;
   CLOSE get_calc_basis;

   OPEN get_price_curr;
   FETCH get_price_curr INTO last_price_currency_;
   CLOSE get_price_curr;

   --cara
   OPEN get_buy_qty_due;
   FETCH get_buy_qty_due INTO buy_qty_due_;
   CLOSE get_buy_qty_due;

   IF (calculation_basis_ = 0) THEN
      total_discount_ := 0;
   ELSE
      temp_ := ((calculation_basis_ * buy_qty_due_) - last_price_currency_);
      total_discount_ := ((temp_ / (calculation_basis_ * buy_qty_due_)) * 100);
   END IF;

   RETURN total_discount_;
END Get_Total_Discount;


-- Remove_Discount_Row
--   Removes a discount row.
PROCEDURE Remove_Discount_Row (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   discount_no_     IN NUMBER )
IS
   objid_       VARCHAR2(200);
   objversion_  VARCHAR2(2000);
   remrec_      CUST_ORDER_LINE_DISCOUNT_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_, discount_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Discount_Row;

-- Remove_All_Discount_Rows
--   Removes all Discount Rows connected to a customer order line

PROCEDURE Remove_All_Discount_Rows (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER )
IS
   discount_no_  NUMBER;
   
   CURSOR get_discnt_no IS
      SELECT discount_no
      FROM   CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_; 
BEGIN
   OPEN get_discnt_no;
   FETCH get_discnt_no INTO discount_no_;
   
   LOOP
      EXIT WHEN get_discnt_no%NOTFOUND;
      Remove_Discount_Row(order_no_, line_no_, rel_no_, line_item_no_, discount_no_);
      FETCH get_discnt_no INTO discount_no_;      
   END LOOP;
   CLOSE  get_discnt_no;
END Remove_All_Discount_Rows;    

-- Modify_Discount
--   This modify the Dicount and assign a null value to the Discount_Amount
PROCEDURE Modify_Discount (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   discount_no_        IN NUMBER, 
   discount_           IN NUMBER )
IS
   attr_              VARCHAR2(32000);
   oldrec_            CUST_ORDER_LINE_DISCOUNT_TAB%ROWTYPE;
   newrec_            CUST_ORDER_LINE_DISCOUNT_TAB%ROWTYPE;
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   indrec_            Indicator_Rec;
   discount_amount_   NUMBER;
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, discount_no_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_AMOUNT', discount_amount_ , attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);      
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); 
END Modify_Discount;

-- Get_Last_Discount_Line_No
--   Returns the last discount line no used.
@UncheckedAccess
FUNCTION Get_Last_Discount_Line_No (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   last_  NUMBER;

   CURSOR get_last IS
      SELECT MAX(discount_line_no)
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE order_no = order_no_
      AND  line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   OPEN get_last;
   FETCH get_last INTO last_;
   CLOSE get_last;

   IF (last_ IS NULL) THEN
      last_ := 0;
   END IF;
   RETURN last_;
END Get_Last_Discount_Line_No;


-- Check_Existing_Discount_Row
--   Returns true if there are any existing row.
@UncheckedAccess
FUNCTION Check_Existing_Discount_Row (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   discount_no_  IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(order_no_, line_no_, rel_no_, line_item_no_, discount_no_);
END Check_Existing_Discount_Row;


-- Check_Manual_Rows
--   Returns true if there are any rows with disocunt source Manual.
@UncheckedAccess
FUNCTION Check_Manual_Rows (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_     NUMBER;
   CURSOR get_manual IS
      SELECT 1
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
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

-- Added parameter rent_chargeable_days_ not to refetch in order to improve performance
-- Get_Total_Line_Discount
--   Returns calculated line discount amount.
--   When a customer order has multiple discount lines, discount for each line is calculated and rounded first.
--   Then it is added to total discount amount.
--   When calculating total discount percentage; unrounded line discount is used. Then currency_rounding_ should be null.
--   rental_chargeable_days_ is 1 for non rental order lines and for rental order lines it is a non-zero value.
--   If use price including tax is true and discount amount is needed without tax, tax_percentage_ should not be null.
@UncheckedAccess
FUNCTION Get_Total_Line_Discount (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER, 
   currency_rounding_ IN NUMBER DEFAULT NULL,
   tax_percentage_    IN NUMBER DEFAULT NULL,
   rent_chargeable_days_ IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   discount_amount_         NUMBER :=0;
   total_line_discount_     NUMBER :=0;
   rental_chargeable_days_  NUMBER;
   CURSOR get_line_discounts IS
      SELECT ( calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM   CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;

BEGIN
   -- gelr:disc_price_rounded, Redirected the implementation to Get_Total_Line_Disc_Rounded___ when Discounted Price Rounded and no Price including Tax.
   IF (Customer_Order_API.Get_Discounted_Price_Rounded(order_no_)) THEN
      RETURN Get_Total_Line_Disc_Rounded___(order_no_, line_no_, rel_no_, line_item_no_, quantity_, price_conv_factor_, currency_rounding_);
   ELSE   
      IF rent_chargeable_days_ IS NULL THEN
         rental_chargeable_days_ := Customer_Order_Line_API.Get_Rental_Chargeable_Days(order_no_, line_no_, rel_no_, line_item_no_);
      ELSE
         rental_chargeable_days_ := rent_chargeable_days_;
      END IF;

      FOR discount_rec_ IN get_line_discounts LOOP
         discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_ * rental_chargeable_days_);
         IF currency_rounding_ IS NOT NULL THEN
            discount_amount_     := ROUND(discount_amount_ , currency_rounding_);
         END IF;
         -- NOTE: When using Price Including Tax, discount can be obtained with tax or without tax. Calculation Basis of the table is stored with tax amount. 
         --       So seperate calculation is done to take discount without tax and this only applies when Price Including Tax is used for the customer order.
         IF (tax_percentage_ IS NOT NULL) THEN
            discount_amount_  := discount_amount_ / (1 + (tax_percentage_/100));
            -- Re-round discount without tax.
            IF currency_rounding_ IS NOT NULL THEN
               discount_amount_     := ROUND(discount_amount_ , currency_rounding_);
            END IF;
         END IF;
         total_line_discount_ := total_line_discount_ + discount_amount_;
      END LOOP;
      RETURN total_line_discount_;
   END IF;
END Get_Total_Line_Discount;

FUNCTION Get_Discount_Line_Count (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER ) RETURN NUMBER
IS
   line_count_   NUMBER;
   
   CURSOR get_line_count IS
      SELECT COUNT(discount_no)
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   OPEN   get_line_count;
   FETCH  get_line_count INTO line_count_;
   CLOSE  get_line_count;
   RETURN NVL(line_count_,0);  
END Get_Discount_Line_Count;    

PROCEDURE Add_Remove_Update_Line (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   discount_            IN NUMBER,
   contract_            IN VARCHAR2 )
IS
   discount_no_         NUMBER;
   discount_type_       VARCHAR2(25);
   discount_line_count_ NUMBER;
   CURSOR get_discount_no IS
      SELECT discount_no
      FROM  cust_order_line_discount_tab
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
      
BEGIN
   IF (discount_ = 0) THEN
      Remove_All_Discount_Rows(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      discount_line_count_ := Get_Discount_Line_Count( order_no_, line_no_, rel_no_, line_item_no_);   
      IF (discount_line_count_ = 0) THEN
         discount_type_ := Site_Discom_Info_API.Get_Discount_Type(contract_);
         New(order_no_, line_no_, rel_no_, line_item_no_, discount_type_, discount_, Discount_Source_API.DB_MANUAL, Create_Partial_Sum_API.DB_NOT_PARTIAL_SUM, 1, NULL, NULL,  NULL, NULL, NULL, NULL);
         Calc_Discount_Upd_Co_Line__(order_no_, line_no_, rel_no_, line_item_no_);
      ELSIF (discount_line_count_ = 1) THEN 
         OPEN get_discount_no;
         FETCH get_discount_no INTO discount_no_;
         CLOSE get_discount_no;

         Modify_Discount(order_no_, line_no_, rel_no_, line_item_no_, discount_no_, discount_);
      END IF;  
   END IF;    
END Add_Remove_Update_Line;

-- gelr:disc_price_rounded, begin
-- This method is called only when Discounted Price Rounded is enables and No Use Price incl Tax
@UncheckedAccess
FUNCTION Get_Original_Total_Line_Disc (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER ) RETURN NUMBER
IS
   discount_amount_         NUMBER :=0;
   total_line_discount_     NUMBER :=0;
   rental_chargeable_days_  NUMBER;
   CURSOR get_line_discounts IS
      SELECT ( calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM   CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;

BEGIN
   rental_chargeable_days_ := Customer_Order_Line_API.Get_Rental_Chargeable_Days(order_no_, line_no_, rel_no_, line_item_no_);
   
   FOR discount_rec_ IN get_line_discounts LOOP
      discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_ * rental_chargeable_days_);
      total_line_discount_ := total_line_discount_ + discount_amount_;
   END LOOP;
   RETURN total_line_discount_;

END Get_Original_Total_Line_Disc;
-- gelr:disc_price_rounded, end

