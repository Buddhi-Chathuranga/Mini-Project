-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuoteLineDiscount
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220321  MaEelk  SCDEV-8593, Reversed the correction SCZ-15489 and added condition (unit_price_ = 0) back in Modified Calculate_Discount__()
--  210712  ThKrlk  Bug 159876(SCZ-15489), Modified Calculate_Discount__() by removing the logic which made discount percentage 0 when unit price is 0
--  210528  MaEelk  SC21R2-1285, Modified Calculate_Discount__ and rounded value after calculating the price after discount instead of rounding the discounted value
--  210528          when the Discounted Price Rounded is enabled
--  201005  Maeelk  GESPRING20-5893, Added Get_Original_Total_Line_Disc in order to calculate Sales Quotation Line Discount Percentage
--  200917  Maeelk  GESPRING20-5399, Careated Get_Total_Line_Disc_Rounded___ and called it inside Get_Total_Line_Discount when using Discounted Price Rounded parameter enabled.
--  200917          Modified Calculate_Discount__ and handled logic for Discounted Price Rounded parameter enabled. Added Calculate_Original_Discount__
--  200703  NiDalk  SCXTEND-4438, Modified Calc_Discount_Upd_Oq_Line__ and New to add new parameter update_tax_ to set if necessary to update taxes.
--  180904  SBalLK  Bug 143638, Added Copy_Quotation_Line_Discount() method to copy discount line when copy order quotation.
--  170428  Hairlk  APPUXX-11418, Added public wrapper function for Calculate_Discount__
--  170213  Hairlk  APPUXX-9279, Modified Delete___, added condition to check and skip sending Line_Changed event to shopping cart created quotations.
--  150528  NaLrlk  RED-335, Modified Calculate_Discount__(), Get_Total_Line_Discount() to support for rentals.
--  141119  KoDelk  Bug 119800, Added new function Get_Total_Line_Discount__()
--  141107  ChJalk  PRSC-3412, Modified the method Replace_Discount to add default NULL parameter copy_status_.
--  141029  Chfose  Added check for discount change in Check_Common___ so that the error is only thrown in a scenario where the discount is modified.
--  140808  PraWlk  PRSC-2145, Modified Check_Common___() to add the new state 'CO Created' in error OQNODISCOUNT.

--  140714  MeAblk  Added new methods Modify_Discount, Remove_All_Discount_Rows,  Get_Discount_Line_Count, Add_Remove_Update_Line. Modified methods New, Calc_Discount_Upd_Oq_Line__
--  140714          in order to handle adding discount lines from order quotation.
--  140626  UdGnlk  PRSC-1535, Added Replace_Discount() to replace the discount records with the latest.--  131119  RuLiLk  Bug 113865, Modified method Calculate_Discount__. Unrounded discount amount is used for the calculation of discount percentage when using partial discounts.
--  140307  HimRlk  Merged Bug 110133-PIV, Added new method Get_Total_Line_Discount() to calculate sales quotation line discount to be consistant with discount postings.
--  130730  RuLiLk  Bug 110133, Modified method Get_Total_Line_Discount() by removing parameter base_curr_rate_.  
--  130630  RuLiLk  Bug 110133, Added new method Get_Total_Line_Discount() to calculate sales quotation line discount to be consistant with discount postings.
--  130521  jokbse  Bug 109770, Merge, Modified method Calculate_Discount__. Unrounded discount amount is used for the calculation of discount percentage when using partial discounts.
--  130430  RuLiLk  Bug 109527, Modified method Calculate_Discount__ by removing the condition that compares sum of calculated  line level discount amount 
--  130430          with calculated total discount amount when only discount percentages are given.
--  120724  HimRlk  Added price_currency_incl_tax and price_base_incl_tax. Modified Calculate_Discount__() 
--  120724          to consider use_price_incl_tax when calculating discounts.
--  110803  NWeelk  Bug 95555, Modified method Unpack_Check_Update___ by checking whether the discount_amount has changed before setting the discount_source to MANUAL.    
--  100520  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091127  ChJalk  Bug 86871, Removed General_SYS.Init_Method from the function Discount_Exist.
--  081124  ThAylk  Bug 74643, Modified method Transfer_To_Order to add a call to Cust_Order_Line_Discount_API.Calc_Discount_Upd_Co_Line__. 
--  090401 DaZase   Added new columns part_level, part_level_id, customer_level and customer_level_id.
--  080302 kIsalk   Added parameter discount_amount_ to method New.
--  ------------------------- Nice Price Start ------------------------------
--  070302  MaMalk  Bug 63189, Modified condition in Unpack_Check_Insert___ and Unpack_Check_Update___, 
--  070302          to stop entering negative discount amounts, when the calculation basis is 0.
--  070130  NaWilk  Bug 62020, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to stop the user from setting
--  070130          a discount amount or a % > 0 by raising an error msg, when the calculation basis is 0.
--  ------------------------------------13.4.0--------------------------------
--  050927  IsAnlk  Added customer_no as parameter to Customer_Order_Pricing_API.Get_Base_Price_In_Currency call.
--  050921  NaLrlk  Removed unused variables.
--  040224  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  ------------------------------------13.3.0--------------------------------
--  021213  Asawlk   Merged bug fixes in 2002-3 SP3
--  021024  JoAnSe  Bug 33693, Changes in Calculate_Discount__ to avoid uneccessary 
--                  problems with uneven discount percentages on the quotation line.
--  020918  JoAnSe  Corrected Calculate_Discount__ to handle zero price.
--  020912  JoAnSe  Bug 32740, Corrected calculation of total_discount for price = 0
--                  in Calculate_Discount__
--  020903  JoAnSe  Bug 31296, Rewrote the metod Calculate_Discount__ from scratch. 
--  011008  CaSt    Bug 24842. Modified Calculate_Discount__, price_conv_factor is regarded.
--  010528  JSAnse  Bug fix 21463, added call to General_SYS.Init_Method in procedure Discount_Exist.
--  001219  MaGu    Modified method Transfer_To_Order. Added discount_amount in call to Cust_Order_Line_Discount_API.New.
--  001121  MaGu    Modified cursor get_calc_basis in method Get_Total_Discount to get correct discount_line_no.
--  001107  MaGu    Added public attribute discount_source_id. Modified call to Cust_Order_Line_Discount_API.New.
--                  Modified method New.
--  001101  MaGu    Changed key in order_quote_line_discount_tab. Added new key discount_no_
--                  and made old key discount_type_ to public attribute.
--  000913  FBen    Added UNDEFINED.
--  001719  TFU     Merging from Chameleon
--  000718  LIN     Added procedure Calc_Discount_Upd_Oq_Line__ and changed
--                  existing procedure Calculate_Discount__ into a function
--                  which only returns the total discount( reason: loops on OQ line)
--  000619  GBO     Added logic for LineChanged
--                  Added Discount_Exist
--  000607  LUDI    Update QuoteLineHistory by insert, delete and modify
--  000511  GBO     Added TransferToOrder
--  000510  GBO     Added Cascade delete
--  000504  LIN     Created.
--  ---------------------------- 13.0.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Discount_Data___
--   Update the discount data for one discount record.
PROCEDURE Modify_Discount_Data___ (
   quotation_no_              IN VARCHAR2,
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
   oldrec_               ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE;
   newrec_               ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE;
   attr_                 VARCHAR2(2000) := NULL;
   objid_                ORDER_QUOTE_LINE_DISCOUNT.objid%TYPE;
   objversion_           ORDER_QUOTE_LINE_DISCOUNT.objversion%TYPE;   
   indrec_               Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CALCULATION_BASIS', calculation_basis_, attr_);
   Client_SYS.Add_To_Attr('PRICE_CURRENCY', price_currency_, attr_);
   Client_SYS.Add_To_Attr('PRICE_BASE', price_base_, attr_);
   Client_SYS.Add_To_Attr('PRICE_CURRENCY_INCL_TAX', price_currency_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('PRICE_BASE_INCL_TAX', price_base_incl_tax_, attr_);

   oldrec_ := Lock_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_, discount_no_);
   newrec_ := oldrec_;
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_, discount_no_);     
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
   newrec_     IN OUT ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   rev_no_     NUMBER;
   
   CURSOR get_seq_no (quotation_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2, line_item_no_ IN NUMBER) IS
      SELECT nvl(max(discount_no) + 1, 1)
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN get_seq_no(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   FETCH get_seq_no INTO newrec_.discount_no;
   CLOSE get_seq_no;
   Client_SYS.Add_To_Attr('DISCOUNT_NO', newrec_.discount_no, attr_);
   super(objid_, objversion_, newrec_, attr_);
   -- OrderQuotationLine is modified
   Order_Quotation_Line_API.Line_Changed( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no );

   -- History
   rev_no_ := Order_Quotation_API.Get_Revision_No(newrec_.quotation_no);
   Order_Quote_Line_Hist_API.New( newrec_.quotation_no, newrec_.line_no,newrec_.rel_no,
   newrec_.line_item_no, '', '', '', 'DISCOUNT_LINE', newrec_.discount_no, rev_no_, 'New');
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE,
   newrec_     IN OUT ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   rev_no_     NUMBER;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- OrderQuotationLine is modified
   Order_Quotation_Line_API.Line_Changed( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no );

   -- History
   rev_no_ := Order_Quotation_API.Get_Revision_No(oldrec_.quotation_no);
   IF ( NVL(oldrec_.price_currency, 0) != NVL(newrec_.price_currency, 0) ) THEN
      Order_Quote_Line_Hist_API.New( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no,
      newrec_.line_item_no, 'SALE_UNIT_PRICE', oldrec_.price_currency, newrec_.price_currency,'DISCOUNT_LINE',
      newrec_.discount_no, rev_no_, 'Modified' );
   END IF;
   IF ( NVL(oldrec_.price_base, 0) != NVL(newrec_.price_base, 0) ) THEN
      Order_Quote_Line_Hist_API.New( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no,
      newrec_.line_item_no, 'BASE_SALE_UNIT_PRICE', oldrec_.price_base, newrec_.price_base,'DISCOUNT_LINE',
      newrec_.discount_no, rev_no_, 'Modified' );
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE )
IS
   rev_no_      NUMBER;
   b2b_order_   ORDER_QUOTATION_TAB.B2B_ORDER%TYPE;
BEGIN
   super(objid_, remrec_);
   
   b2b_order_ := Order_Quotation_API.Get_B2b_Order_Db(remrec_.quotation_no);
   
   --If it is created from shopping cart(b2b order=true) then skip sending Line_Changed event since the quotation line is already in CO created state
   IF(b2b_order_ = Fnd_Boolean_API.DB_FALSE) THEN
      -- OrderQuotationLine is modified
      Order_Quotation_Line_API.Line_Changed( remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no );
   END IF;
   
   -- History
   rev_no_ := Order_Quotation_API.Get_Revision_No(remrec_.quotation_no);
   Order_Quote_Line_Hist_API.New( remrec_.quotation_no, remrec_.line_no,remrec_.rel_no,
   remrec_.line_item_no, '', '', '', 'DISCOUNT_LINE', remrec_.discount_no, rev_no_, 'Deleted');
END Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     order_quote_line_discount_tab%ROWTYPE,
   newrec_ IN OUT order_quote_line_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   objstate_ VARCHAR2(20); 
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   objstate_ := Order_Quotation_Line_API.Get_Objstate(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   IF ((newrec_.calculation_basis = 0) AND (newrec_.discount_amount != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the quotation line price.');
   END IF;
   IF (objstate_ IN ('Won', 'Lost', 'Cancelled', 'CO Created') AND newrec_.discount != oldrec_.discount) THEN
      Error_SYS.Record_General(lu_name_, 'OQNODISCOUNT: No more Discount Types may be added to a quotation line when the line is CO Created Won/Lost or Cancelled.');
   END IF;
   IF (newrec_.discount IS NULL) AND (newrec_.discount_amount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'OQUPGNODISCOUNT: You have to enter a Discount or a Discount Amount.');
   END IF;
   IF (newrec_.discount IS NOT NULL) AND (newrec_.discount_amount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'OQUPGTWODISCOUNT: Both Discount and Discount Amount can not be used at the same time.');
   END IF;  
END Check_Common___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_quote_line_discount_tab%ROWTYPE,
   newrec_ IN OUT order_quote_line_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   

   IF (newrec_.discount_source NOT IN ('MANUAL')) THEN
      IF (NVL(oldrec_.discount, -9999) <> NVL(newrec_.discount, -9999)) OR (NVL(oldrec_.discount_amount, -9999) <> NVL(newrec_.discount_amount, -9999)) THEN
         newrec_.discount_source := 'MANUAL';
         newrec_.discount_source_id := NULL;
      END IF;
   END IF;
END Check_Update___;

-- gelr:disc_price_rounded, begin
FUNCTION Get_Total_Line_Disc_Rounded___ (
   quotation_no_      IN VARCHAR2,
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
   line_rec_            Order_Quotation_Line_API.Public_Rec;
   rounding_            NUMBER;
   
   -- rounded discount price is stored at last line of cust_invoice_item_discount_tab
   CURSOR get_discounted_price IS
      SELECT price_currency 
      FROM   order_quote_line_discount_tab t
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      ORDER BY discount_line_no DESC;
BEGIN
   line_rec_  := Order_Quotation_Line_API.Get(quotation_no_, line_no_, rel_no_, line_item_no_);
   
   rounding_ := NVL(currency_rounding_, Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(line_rec_.contract),
                                                                                Order_Quotation_API.Get_Currency_Code(quotation_no_)));

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

-- Calc_Discount_Upd_Oq_Line__
--   Calculate the discount and update the order quotation line
PROCEDURE Calc_Discount_Upd_Oq_Line__ (
   quotation_no_   IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   update_oq_line_ IN BOOLEAN DEFAULT TRUE,
   update_tax_     IN VARCHAR2 DEFAULT 'TRUE')
IS
   total_discount_      NUMBER;
BEGIN

   total_discount_ := Calculate_Discount__(quotation_no_, line_no_, rel_no_, line_item_no_);
   IF (update_oq_line_) THEN
      Order_Quotation_Line_API.Modify_Discount__(quotation_no_, line_no_, rel_no_, line_item_no_, total_discount_, update_tax_);
   END IF;
END Calc_Discount_Upd_Oq_Line__;


-- Calculate_Discount__
--   Recalculates the discount for for all discount records connected to an
--   order quotation line. Also updates the discount on the order quotation line.
FUNCTION Calculate_Discount__ (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_               Order_Quotation_Line_API.Public_Rec;
   quote_rec_              Order_Quotation_API.Public_Rec;
   total_discount_amount_  NUMBER;
   total_discount_         NUMBER;
   unit_price_             NUMBER;
BEGIN   
   quote_rec_ := Order_Quotation_API.Get(quotation_no_);
   line_rec_  := Order_Quotation_Line_API.Get(quotation_no_, line_no_, rel_no_, line_item_no_);
   
   -- if value of use_price_incl_tax is TRUE in order quotation header, discount will be calculated based on 
   -- price including tax value of the quotation line.
   IF (quote_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_FALSE) THEN
      unit_price_            := line_rec_.sale_unit_price;
   ELSE
      unit_price_            := line_rec_.unit_price_incl_tax;
   END IF;
   
   Calculate_Discount__ (total_disc_pct_         => total_discount_,
                         total_disc_amt_         => total_discount_amount_,
                         quotation_no_           => quotation_no_,
                         line_no_                => line_no_,
                         rel_no_                 => rel_no_,
                         line_item_no_           => line_item_no_,
                         unit_price_             => unit_price_,
                         quantity_               => line_rec_.buy_qty_due ,
                         price_conv_fact_        => line_rec_.price_conv_factor,
                         server_invoke_          => 'TRUE');

   RETURN total_discount_;
END Calculate_Discount__;


-- Calculate_Discount__
--    Method takes details from the quotation line and recalculates discounts for all discount records connected to an quotation line.
--    This method is called from both server and client. Discount values are updated only when called from Sever.
--    The client call is done, when a value affecting calculation basis is modified but still haven't commited the change to the server.
--    tax_percentage_ is sent from client, to calculate discount amounts without tax when price including tax is specified.
PROCEDURE Calculate_Discount__ (
   total_disc_pct_         OUT NUMBER,
   total_disc_amt_         OUT NUMBER,
   quotation_no_           IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   unit_price_             IN  NUMBER,
   quantity_               IN  NUMBER,
   price_conv_fact_        IN  NUMBER,
   server_invoke_          IN  VARCHAR2 DEFAULT 'FALSE')
IS
   quote_rec_                 Order_Quotation_API.Public_Rec;
   tax_line_param_rec_        Tax_Handling_Order_Util_API.tax_line_param_rec;
   currency_rounding_         NUMBER;   
   calculation_basis_         NUMBER;
   line_discount_amount_      NUMBER;
   total_discount_amount_     NUMBER;
   total_discount_            NUMBER;   
   currency_code_             VARCHAR2(3);
   price_qty_                 NUMBER;
   unround_line_disc_amount_  NUMBER;
   unround_total_disc_amount_ NUMBER;
   no_sum_or_amount_          BOOLEAN := TRUE;
   total_discount_percentage_ NUMBER := 0;   
   last_price_curr_           NUMBER;
   rental_chargeable_days_    NUMBER;
   price_base_                NUMBER;
   price_base_incl_tax_       NUMBER;
   price_currency_            NUMBER;
   price_currency_incl_tax_   NUMBER;
   company_                   VARCHAR2(20);
   multiple_tax_              VARCHAR2(20);
   -- gelr:disc_price_rounded, begin
   discounted_price_rounded_  BOOLEAN := Order_Quotation_API.Get_Discounted_Price_Rounded(quotation_no_);
   -- gelr:disc_price_rounded, end
   
   CURSOR get_line IS
      SELECT  discount, discount_amount, create_partial_sum, discount_no
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      ORDER BY discount_line_no;
BEGIN

   quote_rec_ := Order_Quotation_API.Get(quotation_no_);
   currency_code_ := quote_rec_.currency_code;
   company_       := Site_API.Get_Company(quote_rec_.contract);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   
   last_price_curr_ := unit_price_;
   calculation_basis_ := last_price_curr_;
   price_qty_ := quantity_ * price_conv_fact_;   
   total_discount_amount_ := 0;
   unround_total_disc_amount_ := 0;
   
   rental_chargeable_days_ := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);

   FOR rec_ IN get_line LOOP
      tax_line_param_rec_ := Order_Quotation_Line_API.Fetch_Tax_Line_Param(Site_API.Get_Company(quote_rec_.contract), quotation_no_, line_no_, rel_no_, line_item_no_);
      
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
                                             quotation_no_, 
                                             line_no_, 
                                             rel_no_, 
                                             line_item_no_,
                                             '*',
                                             Tax_Source_API.DB_ORDER_QUOTATION_LINE,
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
         Modify_Discount_Data___(quotation_no_, line_no_, rel_no_, line_item_no_, rec_.discount_no,
                                 calculation_basis_, price_currency_, price_currency_incl_tax_, price_base_, price_base_incl_tax_);
      END IF;
                              
      IF (no_sum_or_amount_ = TRUE) THEN
         -- Modified condition code. calculation_basis_ should be compared with unit_price_ inseated of applicable_price_currency_.
         -- Otherwise discount percentage calculation will always work as if partial sum is checked.
         IF (calculation_basis_ != unit_price_ ) OR (rec_.discount_amount IS NOT NULL) THEN
            -- A discount amout has been specified or a partial sum has been specified for 
            -- a previous line. 
            -- In both cases it will not be possible to store the sum of the discount percentages
            -- for the discount records as the discount on the quotation line as this would cause
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

   -- Due the removed condition, when there is a rounding mismatch, wrong discount percentage will be displayed. 
   IF (unit_price_ = 0) THEN
      total_discount_ := 0;   
   -- Modified the ELSIF condition. When there are only discount percentages in the lines, ELSIF block should get executed.
   -- gelr:disc_price_rounded, Modified the condition and added NOT discounted_price_rounded_
   ELSIF ((no_sum_or_amount_ = TRUE) AND NOT(discounted_price_rounded_)) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the quotation line
      total_discount_ := total_discount_percentage_;
   ELSE
      -- gelr:disc_price_rounded, Added a condtion to make sure that value of price_qty_ will not be zero.
      IF (price_qty_ != 0) THEN
         -- gelr:disc_price_rounded, rental_chargeable_days_ is set as 1 if it is null
         total_discount_ := (unround_total_disc_amount_ / (unit_price_ * price_qty_ * NVL(rental_chargeable_days_, 1))) * 100;
      ELSE
         total_discount_ := 0;
      END IF;         
   END IF;
   total_disc_pct_  := total_discount_;
   total_disc_amt_  := total_discount_amount_;   
END Calculate_Discount__;

@UncheckedAccess
FUNCTION Get_Total_Line_Discount__ (
   quotation_no_      IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER ) RETURN NUMBER
IS
   quote_rec_           Order_Quotation_API.Public_Rec;
   currency_rounding_   NUMBER;
BEGIN
   quote_rec_ := Order_Quotation_API.Get(quotation_no_);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(quote_rec_.company, quote_rec_.currency_code);
   RETURN Get_Total_Line_Discount(quotation_no_, line_no_, rel_no_, line_item_no_, quantity_, price_conv_factor_, currency_rounding_);
END Get_Total_Line_Discount__;

-- gelr:disc_price_rounded, begin
FUNCTION Calculate_Original_Discount__ (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   line_rec_              Order_Quotation_Line_API.Public_Rec;
   quote_rec_             Order_Quotation_API.Public_Rec;

   total_discount_amount_  NUMBER;
   total_discount_         NUMBER;
   unit_price_             NUMBER;
   rental_chargeable_days_ NUMBER;
   
BEGIN   

   quote_rec_ := Order_Quotation_API.Get(quotation_no_);
   line_rec_  := Order_Quotation_Line_API.Get(quotation_no_, line_no_, rel_no_, line_item_no_);
   
   -- if value of use_price_incl_tax is TRUE in order quotation header, discount will be calculated based on 
   -- price including tax value of the quotation line.
   IF quote_rec_.use_price_incl_tax = 'FALSE' THEN
      unit_price_            := line_rec_.sale_unit_price;
   ELSE
      unit_price_            := line_rec_.unit_price_incl_tax;
   END IF;
   
   IF (line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Rental_SYS.INSTALLED $THEN
         rental_chargeable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(quotation_no_,
                                                                             line_no_,
                                                                             rel_no_,
                                                                             line_item_no_,
                                                                             Rental_Type_API.DB_ORDER_QUOTATION);
      $ELSE
         NULL;
      $END
   END IF;
   Calculate_Original_Discount__ (total_disc_pct_  => total_discount_,
                         total_disc_amt_  => total_discount_amount_,
                         quotation_no_    => quotation_no_,
                         line_no_         => line_no_,
                         rel_no_          => rel_no_,
                         line_item_no_    => line_item_no_,
                         unit_price_      => unit_price_,
                         quantity_        => line_rec_.buy_qty_due ,
                         price_conv_fact_ => line_rec_.price_conv_factor,
                         rental_chargeable_days_ => NVL(rental_chargeable_days_, 1));

   RETURN total_discount_;
END Calculate_Original_Discount__;

-- The same as Calculate_Discount__ but without rounding and wihout Modify_Discount_Data___
-- It gives us exactly percentage of discount as user entered (not recalculated to achive rounded amount of discount)
-- It is used only to display the exactly percentage of discount.
PROCEDURE Calculate_Original_Discount__ (
   total_disc_pct_         OUT NUMBER,
   total_disc_amt_         OUT NUMBER,
   quotation_no_           IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   unit_price_             IN  NUMBER,
   quantity_               IN  NUMBER,
   price_conv_fact_        IN  NUMBER,
   rental_chargeable_days_ IN  NUMBER DEFAULT 1)
IS
   calculation_basis_          NUMBER;
   total_discount_             NUMBER;
   price_qty_                  NUMBER;
   no_sum_or_amount_           BOOLEAN := TRUE;
   total_discount_percentage_  NUMBER := 0;
   unround_line_disc_amount_   NUMBER;
   unround_total_disc_amount_  NUMBER;
   applicable_price_currency_  NUMBER;
   last_applicable_price_curr_ NUMBER;

   CURSOR get_line IS
      SELECT  discount, discount_amount, create_partial_sum, discount_no
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE quotation_no = quotation_no_
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
         IF (calculation_basis_ != unit_price_ ) OR (rec_.discount_amount IS NOT NULL) THEN
            -- A discount amout has been specified or a partial sum has been specified for 
            -- a previous line. 
            -- In both cases it will not be possible to store the sum of the discount percentages
            -- for the discount records as the discount on the quotation line as this would cause
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
   -- Modified the ELSIF condition. When there are only discount percentages in the lines, ELSIF block should get executed.
   ELSIF (no_sum_or_amount_ = TRUE) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the quotation line
      total_discount_ := total_discount_percentage_;
   ELSE
      total_discount_ := (unround_total_disc_amount_ / (unit_price_ * price_qty_)) * 100;         
   END IF;
      
   total_disc_pct_  := total_discount_;
   total_disc_amt_  := unround_total_disc_amount_;
   
END Calculate_Original_Discount__;
-- gelr:disc_price_rounded, end
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public method used when a discount entry i automaticly created from
--   order quotation line.
PROCEDURE New (
   quotation_no_       IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   discount_type_      IN VARCHAR2,
   discount_found_     IN NUMBER,
   discount_source_    IN VARCHAR2,
   create_partial_sum_ IN VARCHAR2,
   discount_line_no_   IN NUMBER,
   discount_source_id_ IN VARCHAR2,
   discount_amount_    IN NUMBER,
   part_level_         IN VARCHAR2,
   part_level_id_      IN VARCHAR2,
   customer_level_     IN VARCHAR2,
   customer_level_id_  IN VARCHAR2,
   update_oq_line_     IN BOOLEAN DEFAULT TRUE,
   update_tax_         IN VARCHAR2 DEFAULT 'TRUE')
IS
   attr_        VARCHAR2(2000) := NULL;
   objid_       ORDER_QUOTE_LINE_DISCOUNT.objid%TYPE;
   objversion_  ORDER_QUOTE_LINE_DISCOUNT.objversion%TYPE;
   newrec_      ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   -- don't call Prepare_Insert___ to avoid setting wrong IID values
   Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_);
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
   -- Calculate the discounts for the new row in Order Quotation Line Discount.
   --Calculate_Discount__(quotation_no_, line_no_, rel_no_, line_item_no_);
   Calc_Discount_Upd_Oq_Line__(quotation_no_, line_no_, rel_no_, line_item_no_, update_oq_line_, update_tax_);

END New;


PROCEDURE Modify_Discount (
   quotation_no_       IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   discount_no_        IN NUMBER, 
   discount_           IN NUMBER )
IS
   attr_              VARCHAR2(32000);
   oldrec_            ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE;
   newrec_            ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE;
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   indrec_            Indicator_Rec;
   discount_amount_   NUMBER := NULL;
BEGIN
   oldrec_ := Lock_By_Keys___(quotation_no_, line_no_, rel_no_, line_item_no_, discount_no_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_AMOUNT', discount_amount_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);      
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Discount;   

-- Get_Total_Discount
--   Returns the total discount for all discount rows on an order quotation line.
@UncheckedAccess
FUNCTION Get_Total_Discount (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   discount_line_no_       NUMBER;
   calculation_basis_      NUMBER;
   last_price_currency_    NUMBER;
   total_discount_         NUMBER;
   temp_                   NUMBER;

   CURSOR get_calc_basis IS
      SELECT calculation_basis
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE discount_line_no = (SELECT MIN(discount_line_no)
                                FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
                                WHERE quotation_no = quotation_no_
                                AND   line_no = line_no_
                                AND   rel_no = rel_no_
                                AND   line_item_no = line_item_no_)
      AND   quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

   CURSOR get_price_curr IS
      SELECT price_currency
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE discount_line_no = discount_line_no_
      AND   quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   discount_line_no_ := Get_Last_Discount_Line_No(quotation_no_, line_no_, rel_no_, line_item_no_);

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
      total_discount_ := ((temp_ / calculation_basis_) * 100);
   END IF;

   RETURN total_discount_;
END Get_Total_Discount;


-- Remove_Discount_Row
--   Removes a discount row.
PROCEDURE Remove_Discount_Row (
   quotation_no_    IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   discount_no_     IN NUMBER )
IS
   objid_       VARCHAR2(200);
   objversion_  VARCHAR2(2000);
   remrec_      ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, quotation_no_, line_no_, rel_no_, line_item_no_, discount_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Discount_Row;


PROCEDURE Remove_All_Discount_Rows (
   quotation_no_    IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER )
IS
   CURSOR get_lines IS
      SELECT *
      FROM   ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_; 
BEGIN
   FOR rec_ IN get_lines LOOP
      Remove_Discount_Row(quotation_no_, line_no_, rel_no_, line_item_no_, rec_.discount_no);     
   END LOOP;   
END Remove_All_Discount_Rows;   


-- Get_Last_Discount_Line_No
--   Returns the last discount line no used.
@UncheckedAccess
FUNCTION Get_Last_Discount_Line_No (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
  last_  NUMBER;

   CURSOR get_last IS
      SELECT MAX(discount_line_no)
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE quotation_no = quotation_no_
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
--   Returns true if there are any existing rows.
@UncheckedAccess
FUNCTION Check_Existing_Discount_Row (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   discount_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(quotation_no_, line_no_, rel_no_, line_item_no_, discount_no_);
END Check_Existing_Discount_Row;


-- Check_Manual_Rows
--   Returns true if there are any rows with discount source manual.
@UncheckedAccess
FUNCTION Check_Manual_Rows (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_     NUMBER;
   CURSOR get_manual IS
      SELECT 1
      FROM ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE quotation_no = quotation_no_
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


-- Transfer_To_Order
--   Transfer quotation line discount to customer order
PROCEDURE Transfer_To_Order (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER,
   discount_no_ IN NUMBER,
   con_order_no_ IN VARCHAR2,
   con_line_no_ IN VARCHAR2,
   con_rel_no_ IN VARCHAR2,
   con_line_item_no_ IN NUMBER )
IS
   rec_  ORDER_QUOTE_LINE_DISCOUNT_TAB%ROWTYPE;
BEGIN

   rec_ := Get_Object_By_Keys___( quotation_no_, line_no_, rel_no_, line_item_no_, discount_no_ );

   Cust_Order_Line_Discount_API.New( con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_,
      rec_.discount_type, rec_.discount, rec_.discount_source, rec_.create_partial_sum, rec_.discount_line_no,
      rec_.discount_source_id, rec_.discount_amount, rec_.part_level, rec_.part_level_id, rec_.customer_level, rec_.customer_level_id);
   Cust_Order_Line_Discount_API.Calc_Discount_Upd_Co_Line__(con_order_no_, con_line_no_, con_rel_no_, con_line_item_no_);
END Transfer_To_Order;


-- Discount_Exist
--   Return TRUE if any discount line exists.
@UncheckedAccess
FUNCTION Discount_Exist (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR discount_exist IS
      SELECT 1
      FROM   ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE line_item_no = line_item_no_
        AND rel_no = rel_no_
        AND line_no = line_no_
        AND quotation_no = quotation_no_;
BEGIN
   OPEN discount_exist;
   FETCH discount_exist INTO dummy_;
   IF (discount_exist%FOUND) THEN
      CLOSE discount_exist;
      RETURN 'TRUE';
   END IF;
   CLOSE discount_exist;
   RETURN 'FALSE';
END Discount_Exist;


FUNCTION Get_Discount_Line_Count (
   quotation_no_ IN VARCHAR2,
   line_no_ IN VARCHAR2,
   rel_no_ IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   no_of_discounts_ NUMBER;
   CURSOR get_discount_count IS
      SELECT COUNT(discount_no)
      FROM   ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE line_item_no = line_item_no_
        AND rel_no = rel_no_
        AND line_no = line_no_
        AND quotation_no = quotation_no_;
BEGIN
   OPEN   get_discount_count;
   FETCH  get_discount_count INTO no_of_discounts_;
   CLOSE  get_discount_count;
   RETURN no_of_discounts_;
END Get_Discount_Line_Count;      

-- Get_Total_Line_Discount
--    Returns calculated line discount amount.
--    When a sales quotation has multiple discount lines, discount for each line is calculated and rounded first.
--    Then it is added to total discount amount.
@UncheckedAccess
FUNCTION Get_Total_Line_Discount (
   quotation_no_       IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   quantity_           IN NUMBER,
   price_conv_factor_  IN NUMBER, 
   currency_rounding_  IN NUMBER DEFAULT NULL,
   tax_percentage_     IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   discount_amount_         NUMBER :=0;
   total_line_discount_     NUMBER :=0;
   rental_chargeable_days_  NUMBER;
   
   CURSOR get_line_discounts IS
      SELECT (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM  ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
      -- gelr:disc_price_rounded, Redirected the implementation to Get_Total_Line_Disc_Rounded___ when Discounted Price Rounded and no Price including Tax.
   IF (Order_Quotation_API.Get_Discounted_Price_Rounded(quotation_no_)) THEN
      RETURN Get_Total_Line_Disc_Rounded___(quotation_no_, line_no_, rel_no_, line_item_no_, quantity_, price_conv_factor_, currency_rounding_);
   ELSE   
      rental_chargeable_days_   := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(quotation_no_, line_no_, rel_no_, line_item_no_);

      FOR discount_rec_ IN get_line_discounts LOOP
         discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_ * rental_chargeable_days_);
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


PROCEDURE Replace_Discount (
   quotation_no_       IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   discount_           IN NUMBER,
   copy_status_        IN VARCHAR2 DEFAULT NULL)
IS
   discount_type_         VARCHAR2(25);
   attr_                  VARCHAR2(2000) := NULL;
   objid_                 order_quote_line_discount.objid%TYPE;
   objversion_            order_quote_line_discount.objversion%TYPE;
   newrec_                order_quote_line_discount_tab%ROWTYPE;
   indrec_                Indicator_Rec;
   contract_              Order_Quotation_Line_Tab.contract%TYPE;
   
   CURSOR get_all_discount_records IS
         SELECT discount_no
         FROM   order_quote_line_discount_tab
         WHERE  quotation_no = quotation_no_
         AND    line_no      = line_no_
         AND    rel_no       = rel_no_
         AND    line_item_no = line_item_no_;
BEGIN
   FOR next_discount_ IN get_all_discount_records LOOP
       Remove_Discount_Row(quotation_no_,
                           line_no_,
                           rel_no_,
                           line_item_no_,
                           next_discount_.discount_no);   
   END LOOP;
   
   IF (discount_ != 0) THEN
      contract_ := Order_Quotation_Line_API.Get_Contract(quotation_no_, line_no_, rel_no_, line_item_no_);
      IF ( NVL(copy_status_, 'FALSE') = 'TRUE') THEN
         discount_type_ := Site_Discom_Info_API.Get_Discount_Type(contract_); 
      ELSE 
         discount_type_ := 'G';
      END IF;
      Client_SYS.Add_To_Attr('QUOTATION_NO', quotation_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
      Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT', discount_, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_LINE_NO', 1, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_DB', 'MANUAL', attr_);
      Client_SYS.Add_To_Attr('CREATE_PARTIAL_SUM_DB', 'NOT PARTIAL SUM', attr_);
      Unpack___(newrec_, indrec_, attr_); 
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;   
END Replace_Discount;

PROCEDURE Add_Remove_Update_Line (
   quotation_no_        IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   discount_            IN NUMBER,
   discount_line_count_ IN NUMBER,
   contract_            IN VARCHAR2 )
IS
   discount_no_   NUMBER;
   discount_type_ VARCHAR2(25);
   
   CURSOR get_discount_no IS
      SELECT discount_no
      FROM   order_quote_line_discount_tab
      WHERE  quotation_no = quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;   
BEGIN
   IF (discount_ = 0) THEN
      Remove_All_Discount_Rows(quotation_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      IF (discount_line_count_ = 0) THEN
         discount_type_ := Site_Discom_Info_API.Get_Discount_Type(contract_);
         New(quotation_no_, line_no_, rel_no_, line_item_no_, discount_type_, discount_, Discount_Source_API.DB_MANUAL, Create_Partial_Sum_API.DB_NOT_PARTIAL_SUM, 1, NULL, NULL,  NULL, NULL, NULL, NULL, FALSE);
      ELSE
         OPEN get_discount_no;
         FETCH get_discount_no INTO discount_no_;
         CLOSE get_discount_no;
         Modify_Discount(quotation_no_, line_no_, rel_no_, line_item_no_, discount_no_, discount_);
      END IF;  
   END IF;    
END Add_Remove_Update_Line;

--Public wrapper function for Calculate_Discount__
FUNCTION Calculate_Discount (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
	RETURN Calculate_Discount__(quotation_no_, line_no_, rel_no_, line_item_no_);
END Calculate_Discount;


-- Copy_Quotation_Line_Discount
--    This method will copy the discount connected to original quotation line to new line.
PROCEDURE Copy_Quotation_Line_Discount(
   from_quotation_no_   IN VARCHAR2,
   quotation_no_        IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   CURSOR get_discount_info IS
      SELECT *
      FROM   order_quote_line_discount_tab
      WHERE  quotation_no = from_quotation_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   FOR rec_ IN get_discount_info LOOP
      New ( quotation_no_,
            line_no_,
            rel_no_ ,
            line_item_no_,
            rec_.discount_type,
            rec_.discount,
            rec_.discount_source,
            rec_.create_partial_sum,
            rec_.discount_line_no,
            rec_.discount_source_id,
            rec_.discount_amount,
            rec_.part_level,
            rec_.part_level_id,
            rec_.customer_level,
            rec_.customer_level_id,
            update_oq_line_ => TRUE);
   END LOOP;
END Copy_Quotation_Line_Discount;

-- gelr:disc_price_rounded, begin
@UncheckedAccess
FUNCTION Get_Original_Total_Line_Disc (
   quotation_no_       IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   quantity_           IN NUMBER,
   price_conv_factor_  IN NUMBER ) RETURN NUMBER
IS
   discount_amount_     NUMBER :=0;
   total_line_discount_ NUMBER :=0;
   rental_chargeable_days_  NUMBER;
   
   CURSOR get_line_discounts IS
      SELECT (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM  ORDER_QUOTE_LINE_DISCOUNT_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;

BEGIN   
   rental_chargeable_days_ := Order_Quotation_Line_API.Get_Rental_Chargeable_Days(quotation_no_,
                                                                                 line_no_,
                                                                                 rel_no_,
                                                                                 line_item_no_);
   FOR discount_rec_ IN get_line_discounts LOOP
      discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_ * rental_chargeable_days_);
      total_line_discount_ := total_line_discount_ + discount_amount_;
   END LOOP;
   RETURN total_line_discount_;
END Get_Original_Total_Line_Disc;
-- gelr:disc_price_rounded, end

