-----------------------------------------------------------------------------
--
--  Logical unit: CustInvoiceItemDiscount
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210528  MaEelk   SC21R2-1285, Modified Calculate_Discount__ and rounded value after calculating the price after discount instead of rounding the discounted value
--  210528           when the Discounted Price Rounded is enabled
--  201005  Maeelk   GESPRING20-5893, Added Get_Original_Total_Line_Disc in order to calculate Total Invoice Item Line Discount Percentage
--  200909  MaEelk   GESPRING20-5400, added Get_Total_Line_Disc_Rounded___ redirected to it from Get_Total_Line_Discount when Discounted_Price_Rounded enabled and no Price Including Tax.
--  200909           Added Calculate_Original_Discount__ to calculate original discount value Discounted_Price_Rounded enabled and no Price Including Tax. 
--  200909           Modified Calculate_Discount__.     
--  200213  ChBnlk   Bug 148588 (SCZ-5318), Modified Copy_Discount() in order to call the Customer_Order_Inv_Item_API.Get_Rental_Transaction_Id only when there's a rental line.
--  180404  ErRalk   Bug 140947, Modified Calculate_Discount__() to fetch values for price_conv_.
--  170803  ChBnlk   Bug 137169, Modified Check_Common___() by checking 'client_change_' variable before calling the method Customer_Order_Inv_Item_API.Get_Rental_Transaction_Id()
--  170803           to avoid unnecessary code executions.
--  160516  MAHPLK   FINHR-1690, Modified Calculate_Discount__ to get the prices from Tax_Handling_Order_Util_API.Get_Prices(). 
--  141001  RoJalk   Removed the Deprecated method Copy_Discount, with 7 parameters.
--  140401  NaSalk   Modified Check_Common___ to restrict changes from the client.
--  131119  RuLiLk   Bug 113865, Modified method Calculate_Discount__. Unrounded discount amount is used for the calculation of discount percentage when using partial discounts.
--  140210  PeSulk   Modified Copy_Discount to use price information from rental transactions for rental customer order lines.
--  140307  HimRlk   Merged Bug 110133 - PIV, Added new method Get_Total_Line_Discount() to calculate customer invoice line discount to be consistent with discount postings.
--  140307  HimRlk   Merged Bug 110447 - PIV, Modified method Calculate_Line_Amounts___, when price including tax is used, unrounded gross amount is used to calculate total discount amount and net current amount.
--  140307           Modified method Create_Postings__, when creating postings, Gross curr amount is calculated by applying tax percentage on Gross curr amount with tax for price including tax. 
--  140307           Modified method Create_Discount_Postings___(). Tax percentage should not be fetched twice.
--  140225  MeAblk   Modified Calculate_Discount__ in order to correctly get the discount amount when the price including tax is used. 
--  140225  MeAblk   Modified Calculate_Discount__ in order to correctly get the discount amount when the price including tax is used.
--  140117  BudKlk   Bug 114677, Added Parameter invoiced_qty_ to the Copy_Discount() in order to increase the performance by removing a method call.
--  140117           Also added depricated method Copy_Discount().
--  131017  PeSulk   Modified Copy_Discount() and added a check to stop the recalculation for rental co lines.
--  131223  MalLlk   Added Remove method to delete if records exist for CO Invoice Item.
--  130813  RuLiLk   Bug 111805, Modified method Calculate_Discount__,to solve the issue when price including tax is specified, percentage was calculated always as if partial sum is specified. 
--  121001  JeeJlk   Modified Calculate_Discount__ to calculate discount amounts based on use price incl tax value.
--  120911  ShKolk   Added public columns price_currency_incl_tax and price_base_incl_tax. Modified Modify_Discount_Data___ and
--  120911           Calculate_Discount__ to consider added columns in calculations.
--  130730  RuLiLk   Bug 110133, Modified method Get_Total_Line_Discount() by removing parameter base_curr_rate_.
--  130630  RuLiLk   Bug 110133, Added new method Get_Total_Line_Discount() to calculate customer invoice line discount to be consistent with discount postings.
--  130521  jokbse   Bug 109770, Merge, Modified method Calculate_Discount__. Unrounded discount amount is used for the calculation of discount percentage when using partial discounts.
--  130430  RuLiLk   Bug 109527, Modified method Calculate_Discount__ by removing the condition that compares sum of calculated  line level discount amount 
--  130430           with calculated total discount amount when only discount percentages are given.
--  100513  Ajpelk   Merge rose method documentation
-- ------------------------------Eagle-------------------------------------------
--  071224  MaRalk   Bug 64486, Modified the function Calculate_Discount__ to consider currency rate type in CO when calculating price in currency.
--  070302  MaMalk   Bug 63189, Modified condition in Unpack_Check_Insert___ and Unpack_Check_Update___ 
--  070302           to stop entering negative discount amounts, when the calculation basis is 0. 
--  070130  NaWilk   Bug 62020, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to stop the user from setting
--  070130           a discount amount or a % > 0 by raising an error msg, when the calculation basis is 0.
--  060419  IsWilk   Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 -----------------------------------------
--  060110  CsAmlk   Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050926  IsAnlk   Added customer_no as parameter to Customer_Order_Pricing_API.Get_Base_Price_In_Currency call.
--  050922  SaMelk   Rermoved Unused variables.
--  040218  IsWilk   Removed the SUBSTRB from the view for Unicode Changes.
--  ----------------------Edge Package Group 3 Unicode Changes-----------------------
--  030729  GaJalk   SP4 Merge.
--  021212  Asawlk   Merged bug fixes in 2002-3 SP3
--  021211  NaWalk   Bug 34748, Modified the if condition to check 'price_qty_', Function 'Calculate_Discount__'.
--  021025  JoAnSe   Bug 33693, Changes in Calculate_Discount__ to avoid uneccessary
--                   problems with uneven discount percentages on the invoice item.
--  020918  JoAnSe   Corrected Calculate_Discount__ to handle zero price.
--  020912  JoAnSe   Bug 32740, Corrected calculation of total_discount for price = 0
--                   in Calculate_Discount__
--  020828  JoAnSe   Bug 31296, Rewrote the metod Calculate_Discount__.
--  020828           Removed parameter copy_amount_ from Copy_Discount and added call to
--  020828           Calculate_Discount__ to the same method.
--  020828           Removed the multiplication of amount with -1 in Copy_Discount_Credit.
--  020508  JeLise   Bug fix 28989, Added sale_price_ur_ := old_price_currency_ in the calculation of
--  020508           discount_amount_ with 'PARTIAL SUM' in Calculate_Discount__.
--  020328  ROALUS   Call 77512, Calculate_Discount total_discount calculation modified.
--  020328  JeLise   Bug 28523, Removed part of earlier correction in Calculate_Discount__.
--  020318  MGUO     Bug 28523, added validation on Unpack_Check_Insert___ and Unpack_Check_Update___ not allowing
--                   Discount Amount to be greater than 100%.
--  020315  JeLise   Bug fix 28286, Cleaned up code added earlier for this correction.
--  020313  MGUO     Call 79499, added validation on Unpack_Check_Insert___ and Unpack_Check_Update___ not allowing
--                   Discount to be greater than 100%.
--  020311  ROALUS   Call 77512, Calculate_Discount modified to handle decimal prices without rounding
--                   moved some code from Get_Total_Discount here along with the cursors to use the unrounded sale_price_last_
--                   to calculate total discount.
--  020305  JeLise   Bug fix 27830, Added cursor get_invoiced_qty in Get_Total_Discount. Also made major
--                   changes in Calculate_Discount__.
--  001108  MaGu  Modified methods Copy_Discount, Copy_Discount_Credit and New, added discount_source_id.
--  001107  MaGu  Added public attribute discount_source_id.
--  001101  JoEd  Added new key attribute discount_no and method Get_Discount_Type.
--  000913  FBen  Added UNDEFINE.
--  --------------------------- 12.1 ----------------------------------------
--  000522  JoEd  Added "copy_amount" parameter to Copy_Discount.
--  000419  PaLj  Corrected Init_Method Errors
--  000316  JoAn  Removed call to Calculate_Discount__ in Copy_Discount
--                and Copy_Discount_Credit.
--                Added copy of price_base, price_currency and discount_basis in
--                both methods.
--  000306  JoEd  When credit invoice, set discount_amount as negative (in
--                Copy_Discount_Credit) and use negative calculation basis
--                (in Calculate_Discount__).
--  000303  JoAn  Corrected roundings in Calculate_Discount__
--  000303  JoEd  Added discount_amount in Copy_Discount and Copy_Discount_Credit.
--  000217  JoAn  Added order by in cursor get_line and roundings in
--                amounts in Calculate_Discount__
--  000214  JoAn  Added Get_Discount_Source_Db (used from posting control)
--  000119  JoEd  Changed view to table in Copy_Discount's cursor.
--  000104  JoEd  Removed party and party type from primary key.
--  991216  JoEd  Fixed fetch of calculation_basis in Calculate_Discount__.
--  991118  JoEd  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE discount_detail_rec IS RECORD                  
   (discount_amount    NUMBER,
    discount_no        NUMBER,
    discount_type      VARCHAR2(25));
  
TYPE discount_detail_table IS TABLE OF discount_detail_rec INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Discount_Data___
--   Update the discount data for one discount record.
PROCEDURE Modify_Discount_Data___ (
   company_                 IN VARCHAR2,
   invoice_id_              IN NUMBER,
   item_id_                 IN NUMBER,
   discount_no_             IN NUMBER,
   calculation_basis_       IN NUMBER,
   price_currency_          IN NUMBER,
   price_currency_incl_tax_ IN NUMBER,
   price_base_              IN NUMBER,
   price_base_incl_tax_     IN NUMBER )
IS
   oldrec_               CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
   newrec_               CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
   attr_                 VARCHAR2(2000);
   objid_                CUST_INVOICE_ITEM_DISCOUNT.objid%TYPE;
   objversion_           CUST_INVOICE_ITEM_DISCOUNT.objversion%TYPE;
   indrec_               Indicator_Rec;
BEGIN
   Trace_SYS.Field('Calculation basis', calculation_basis_);
   Trace_SYS.Field('Price currency', price_currency_);
   Trace_SYS.Field('Price currency incl tax', price_currency_incl_tax_);
   Trace_SYS.Field('Price base', price_base_);
   Trace_SYS.Field('Price base incl tax', price_base_incl_tax_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CALCULATION_BASIS', calculation_basis_, attr_);
   Client_SYS.Add_To_Attr('PRICE_CURRENCY', price_currency_, attr_);
   Client_SYS.Add_To_Attr('PRICE_CURRENCY_INCL_TAX', price_currency_incl_tax_, attr_);
   Client_SYS.Add_To_Attr('PRICE_BASE', price_base_, attr_);
   Client_SYS.Add_To_Attr('PRICE_BASE_INCL_TAX', price_base_incl_tax_, attr_);

   oldrec_ := Lock_By_Keys___(company_, invoice_id_, item_id_, discount_no_);
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
   newrec_     IN OUT CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_discount_no IS
      SELECT nvl(max(discount_no) + 1, 1)
      FROM CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE company = newrec_.company
      AND   invoice_id = newrec_.invoice_id
      AND   item_id = newrec_.item_id;
BEGIN
   OPEN get_discount_no;
   FETCH get_discount_no INTO newrec_.discount_no;
   CLOSE get_discount_no;
   Client_SYS.Add_To_Attr('DISCOUNT_NO', newrec_.discount_no, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     cust_invoice_item_discount_tab%ROWTYPE,
   newrec_ IN OUT cust_invoice_item_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   CURSOR get_head_state IS
      SELECT objstate
      FROM CUSTOMER_ORDER_INV_HEAD
      WHERE company = newrec_.company
      AND invoice_id = newrec_.invoice_id;
   objstate_ CUSTOMER_ORDER_INV_HEAD.objstate%TYPE;
   client_change_  VARCHAR2(5);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the invoice line price.');
   END IF;
   
   OPEN get_head_state;
   FETCH get_head_state INTO objstate_;
   IF (get_head_state%NOTFOUND) THEN
      objstate_ := NULL;
   END IF;
   CLOSE get_head_state;

   IF ((newrec_.calculation_basis = 0) AND (newrec_.discount_amount != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISC: The total discount given cannot exceed the invoice line price.');
   END IF;

   IF (objstate_ NOT IN ('Preliminary')) THEN
      Error_SYS.Record_General(lu_name_,'PRINTEDINVOICE: Printed/Posted-Authorized invoices may not be changed');
   END IF;

   IF (newrec_.discount IS NULL) AND (newrec_.discount_amount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NODISCOUNT: You have to enter a Discount or a Discount Amount.');
   END IF;

   IF (newrec_.discount IS NOT NULL) AND (newrec_.discount_amount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'TWODISCOUNT: Both Discount and Discount Amount can not be used at the same time.');
   END IF;
   client_change_ := NVL(Client_SYS.Get_Item_Value('CLIENT_CHANGE', attr_), 'FALSE');
   IF (client_change_ = 'TRUE') THEN
      IF (Customer_Order_Inv_Item_API.Get_Rental_Transaction_Id(newrec_.company, newrec_.invoice_id, newrec_.item_id) IS NOT NULL) THEN 
         Validate_Rental_Period___(newrec_);
      END IF;
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_invoice_item_discount_tab%ROWTYPE,
   newrec_ IN OUT cust_invoice_item_discount_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.discount_source NOT IN ('MANUAL')) THEN
      IF (oldrec_.discount <> newrec_.discount) OR (newrec_.discount_amount IS NOT NULL) THEN
         newrec_.discount_source := 'MANUAL';
         newrec_.discount_source_id := NULL;
      END IF;
   END IF;
END Check_Update___;

PROCEDURE Validate_Rental_Period___ (
   rec_ IN     cust_invoice_item_discount_tab%ROWTYPE )
IS
   rental_period_exists_  BOOLEAN := FALSE;
   cust_inv_item_rec_     Customer_Order_Inv_Item_API.Public_Rec;
BEGIN
   cust_inv_item_rec_ := Customer_Order_Inv_Item_API.Get(rec_.company, rec_.invoice_id, rec_.item_id);
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_period_exists_ := Rental_Object_Manager_API.Rental_Period_Exists(cust_inv_item_rec_.order_no,
                                                                              cust_inv_item_rec_.line_no,
                                                                              cust_inv_item_rec_.release_no,
                                                                              cust_inv_item_rec_.line_item_no,
                                                                              Rental_Type_API.DB_CUSTOMER_ORDER);
   $ELSE
      Error_SYS.Component_Not_Exist('RENTAL');
   $END
   IF (rental_period_exists_) THEN 
      Error_SYS.Record_General(lu_name_, 'INVDISCWHENRENTPERD: It is not possible to edit the discount information for rental lines.');
   END IF;
END Validate_Rental_Period___;

@Override 
PROCEDURE Check_Delete___ (
   remrec_ IN     cust_invoice_item_discount_tab%ROWTYPE )
IS
BEGIN
   super(remrec_); 
   IF (Customer_Order_Inv_Item_API.Get_Rental_Transaction_Id(remrec_.company, remrec_.invoice_id, remrec_.item_id) IS NOT NULL) THEN 
      Validate_Rental_Period___(remrec_);
   END IF;   
END Check_Delete___; 

-- gelr:disc_price_rounded, begin
-- This method should be executed only if the Discounted Price Rounded is enabled and No Price including Tax
FUNCTION Get_Total_Line_Disc_Rounded___ (
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER,
   item_id_           IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER, 
   currency_rounding_ IN NUMBER) RETURN NUMBER
IS
   total_line_discount_ NUMBER :=0;
   discounted_price_    NUMBER :=0;
   net_before_disc_     NUMBER :=0;
   net_after_disc_      NUMBER :=0;
   inv_item_rec_        Customer_Order_Inv_Item_API.Public_Rec;

   -- rounded discount price is stored at last line of cust_invoice_item_discount_tab
   CURSOR get_discounted_price IS
      SELECT price_currency 
      FROM   cust_invoice_item_discount_tab t
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_
      ORDER BY discount_line_no DESC;
BEGIN
   inv_item_rec_ := Customer_Order_Inv_Item_API.Get(company_, invoice_id_, item_id_);
   net_before_disc_ := inv_item_rec_.sale_unit_price * quantity_ * price_conv_factor_;
   IF (currency_rounding_ IS NOT NULL) THEN
       net_before_disc_ := ROUND(net_before_disc_, currency_rounding_);
   END IF;
   
   OPEN get_discounted_price;
   FETCH get_discounted_price INTO discounted_price_;
   IF get_discounted_price%NOTFOUND THEN
      RETURN 0;
   END IF;
   CLOSE get_discounted_price;
   
   IF (currency_rounding_ IS NOT NULL) THEN
      discounted_price_ := ROUND(discounted_price_, currency_rounding_);
   END IF;
   
   net_after_disc_ := discounted_price_ * quantity_ * price_conv_factor_;
   IF (currency_rounding_ IS NOT NULL) THEN
      net_after_disc_ := ROUND(net_after_disc_, currency_rounding_);
   END IF;
   
   -- diff of rounded values
   total_line_discount_ := net_before_disc_ - net_after_disc_;
   RETURN total_line_discount_;
END Get_Total_Line_Disc_Rounded___;
-- gelr:disc_price_rounded, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Calculate_Discount__
--   Recalculates the discount for for all discount records connected to an
--   order line. Also updates the discount on the order line.
PROCEDURE Calculate_Discount__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER )
IS
   headrec_                   Customer_Order_Inv_Head_API.Public_Rec;
   currency_rounding_         NUMBER;
   sale_unit_price_           NUMBER;
   unit_price_incl_tax_       NUMBER;
   calculation_basis_         NUMBER;
   price_base_                NUMBER;
   price_base_incl_tax_       NUMBER;
   price_currency_            NUMBER;
   price_currency_incl_tax_   NUMBER;
   last_price_curr_           NUMBER;
   item_discount_amount_      NUMBER;
   total_discount_amount_     NUMBER;
   total_discount_            NUMBER;
   currency_code_             VARCHAR2(3);
   price_conv_                NUMBER;
   invoiced_qty_              NUMBER;
   price_qty_                 NUMBER;
   customer_no_               CUSTOMER_ORDER_INV_ITEM.identity%TYPE;
   attr_                      VARCHAR2(2000);
   info_                      VARCHAR2(2000);
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   use_price_incl_tax_        VARCHAR2(20);

   no_sum_or_amount_          BOOLEAN := TRUE;
   total_discount_percentage_ NUMBER := 0;
   unit_price_                NUMBER;
   tax_line_param_rec_        Tax_Handling_Order_Util_API.tax_line_param_rec;
   multiple_tax_              VARCHAR2(20);
   
   CURSOR get_line IS
      SELECT discount, discount_amount, create_partial_sum,
             discount_type, discount_no
      FROM   CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_
      ORDER BY discount_line_no;
   CURSOR get_item IS
      SELECT objid, objversion, identity, sale_unit_price, unit_price_incl_tax, invoiced_qty,price_conv
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;
      
   -- gelr:disc_price_rounded, begin
   discounted_price_rounded_        BOOLEAN := Customer_Order_Inv_Item_API.Get_Discounted_Price_Rounded(company_, invoice_id_, item_id_);

   -- gelr:disc_price_rounded, end
BEGIN

   -- Fetch invoice head values
   headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);

   -- Fetch price information from the invoice item
   OPEN get_item;
   FETCH get_item INTO objid_, objversion_, customer_no_,
                       sale_unit_price_, unit_price_incl_tax_, invoiced_qty_,price_conv_;
   CLOSE get_item;

   currency_code_ := headrec_.currency_code;
   use_price_incl_tax_ := headrec_.use_price_incl_tax;
   
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   IF (use_price_incl_tax_ = 'TRUE') THEN
      unit_price_            := unit_price_incl_tax_;
   ELSE
      unit_price_            := sale_unit_price_;
   END IF;
   last_price_curr_ := unit_price_; 
   calculation_basis_ := last_price_curr_;

   price_qty_ := invoiced_qty_ * price_conv_;

   total_discount_amount_ := 0;
 
   FOR rec_ IN get_line LOOP
      tax_line_param_rec_ := Customer_Order_Inv_Item_API.Fetch_Tax_Line_Param(company_, invoice_id_, item_id_, '*', '*');
      
      -- Calculate the price after discount in order currency
      IF (rec_.discount_amount IS NULL) THEN
         IF (tax_line_param_rec_.use_price_incl_tax = 'TRUE') THEN
            price_currency_incl_tax_ := last_price_curr_ - (calculation_basis_ * (rec_.discount / 100));
         ELSE 
            -- gelr:disc_price_rounded, rounded discounted price if Disc Price Round is enabled.
            IF (discounted_price_rounded_) THEN
               price_currency_ := ROUND((last_price_curr_ - (calculation_basis_*(rec_.discount/100))), currency_rounding_) ;
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
                                             invoice_id_, 
                                             item_id_, 
                                             '*',
                                             '*',
                                             '*',
                                             Tax_Source_API.DB_INVOICE,
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
      
      IF (use_price_incl_tax_ = 'TRUE') THEN
         item_discount_amount_ := (last_price_curr_ - price_currency_incl_tax_) * price_qty_;
      ELSE
         item_discount_amount_ := (last_price_curr_ - price_currency_) * price_qty_;
      END IF;
      
      -- Add up the total discount amount for the invoiced qty so far
      total_discount_amount_ := total_discount_amount_ + item_discount_amount_;  
      
      -- Update the discount record
      Modify_Discount_Data___(company_, invoice_id_, item_id_, rec_.discount_no, calculation_basis_, 
                              price_currency_, price_currency_incl_tax_, price_base_, price_base_incl_tax_);

      IF (no_sum_or_amount_ = TRUE) THEN
         IF (calculation_basis_ != unit_price_  ) OR (rec_.discount_amount IS NOT NULL) THEN
            -- A discount amout has been specified or a partial sum has been specified for
            -- a previous line.
            -- In both cases it will not be possible to store the sum of the discount percentages
            -- for the discount records as the discount on the invoice item as this would cause
            -- errors when posting the invoice.
            no_sum_or_amount_ := FALSE;
         END IF;
         -- Sum up the discount percentages so far
         total_discount_percentage_ := total_discount_percentage_ + rec_.discount;
      END IF;


      IF (rec_.create_partial_sum = 'PARTIAL SUM') THEN
         -- Use the price/price incl tax after discount as new calculation basis
         IF (use_price_incl_tax_ = 'TRUE') THEN
            calculation_basis_ := price_currency_incl_tax_;
         ELSE
            calculation_basis_ := price_currency_;
         END IF;
      END IF;

      IF (use_price_incl_tax_ = 'TRUE') THEN
         last_price_curr_ := price_currency_incl_tax_;
      ELSE
         last_price_curr_ := price_currency_;
      END IF;
 
   END LOOP;

   -- Calculate the total discount for the invoice item.
   -- Due the removed condition, when there is a rounding mismatch, wrong discount percentage will be displayed. 
   IF (unit_price_ = 0) OR (price_qty_ =0) THEN
      total_discount_ := 0;
   -- When there are only discount percentages in the lines, ELSIF block should get executed.
   -- gelr:disc_price_rounded, added NOT(disc_price_rounded_) to the condition
   ELSIF ((no_sum_or_amount_ = TRUE) AND NOT(discounted_price_rounded_)) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the invoice item.
      total_discount_ := total_discount_percentage_;
   ELSE
      IF (use_price_incl_tax_ = 'TRUE') THEN
         total_discount_ := (total_discount_amount_ / (unit_price_incl_tax_ * price_qty_)) * 100;
      ELSE
         total_discount_ := (total_discount_amount_ / (sale_unit_price_ * price_qty_)) * 100;
      END IF;
   END IF;

   -- Update the discount for the invoice item
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', total_discount_, attr_);
   -- gelr:disc_price_rounded, begin
   IF (discounted_price_rounded_) THEN
      Client_SYS.Add_To_Attr('ORIGINAL_DISCOUNT', Calculate_Original_Discount__(company_, invoice_id_, item_id_), attr_);
   END IF;
   -- gelr:disc_price_rounded, end   
   Customer_Order_Inv_Item_API.Modify__(info_, objid_, objversion_, attr_, 'DO');

END Calculate_Discount__;


-- gelr:disc_price_rounded, begin
-- Call this method only if the Discounted Price Rounded is enabled in customer Order header and Price including Tax is set as FALSE.
-- The same as Calculate_Discount__ but without rounding and wihout Modify_Discount_Data___
-- It gives us exactly percentage of discount as user entered (not recalculated to achive rounded amount of discount)
-- It is used only to display the exactly percentage of discount.
FUNCTION Calculate_Original_Discount__ (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   headrec_               Customer_Order_Inv_Head_API.Public_Rec;

   sale_unit_price_           NUMBER;
   calculation_basis_         NUMBER;
   price_currency_            NUMBER;
   last_price_curr_           NUMBER;
   total_discount_amount_     NUMBER;
   total_discount_            NUMBER;
   price_conv_                NUMBER;
   invoiced_qty_              NUMBER;
   price_qty_                 NUMBER;
   unround_line_disc_amount_  NUMBER;
   unround_total_disc_amount_ NUMBER;

   no_sum_or_amount_          BOOLEAN := TRUE;
   total_discount_percentage_ NUMBER := 0;
   unit_price_                NUMBER;

   CURSOR get_line IS
      SELECT discount, discount_amount, create_partial_sum,
             discount_type, discount_no
      FROM   CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_
      ORDER BY discount_line_no;

   CURSOR get_item IS
      SELECT sale_unit_price, invoiced_qty, price_conv
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;
BEGIN

   -- Fetch invoice head values
   headrec_ := Customer_Order_Inv_Head_API.Get(company_, invoice_id_);

   -- Fetch price information from the invoice item
   OPEN get_item;
   FETCH get_item INTO sale_unit_price_, invoiced_qty_, price_conv_;
   CLOSE get_item;

   unit_price_            := sale_unit_price_;

   last_price_curr_ := unit_price_; 
   calculation_basis_ := last_price_curr_;

   price_qty_ := invoiced_qty_ * price_conv_;

   total_discount_amount_ := 0;
   unround_total_disc_amount_ := 0;

   FOR rec_ IN get_line LOOP
      -- Calculate the price after discount in order currency
      IF (rec_.discount_amount IS NULL) THEN
         price_currency_ := last_price_curr_ - (calculation_basis_ * (rec_.discount / 100));
      ELSE
         price_currency_ := last_price_curr_ - rec_.discount_amount;
      END IF;

      unround_line_disc_amount_ := (last_price_curr_ - price_currency_) * price_qty_;
      unround_total_disc_amount_ := unround_total_disc_amount_ + unround_line_disc_amount_;

      IF (no_sum_or_amount_ = TRUE) THEN
         IF (calculation_basis_ != unit_price_  ) OR (rec_.discount_amount IS NOT NULL) THEN
            no_sum_or_amount_ := FALSE;
         END IF;
         -- Sum up the discount percentages so far
         total_discount_percentage_ := total_discount_percentage_ + rec_.discount;
      END IF;


      IF (rec_.create_partial_sum = 'PARTIAL SUM') THEN
         -- Use the price/price incl tax after discount as new calculation basis
         calculation_basis_ := price_currency_;
      END IF;

         last_price_curr_ := price_currency_;

   END LOOP;

  IF (unit_price_ = 0) OR (price_qty_ =0) THEN
      total_discount_ := 0;
   -- When there are only discount percentages in the lines, ELSIF block should get executed.
   ELSIF (no_sum_or_amount_ = TRUE) THEN
      -- The sum of all discounts would give the same discount amount as the calculated amount.
      -- Return the sum instead of the calculated value to avoid problems with uneven values
      -- for the calculated percentage on the invoice item.
      total_discount_ := total_discount_percentage_;
   ELSE
      total_discount_ := (unround_total_disc_amount_ / (sale_unit_price_ * price_qty_)) * 100;
   END IF;

   RETURN total_discount_;

END Calculate_Original_Discount__;
-- gelr:disc_price_rounded, end


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public method used when a discount entry i automaticly created from
--   customer order line.
PROCEDURE New (
   company_            IN VARCHAR2,
   invoice_id_         IN NUMBER,
   item_id_            IN NUMBER,
   discount_type_      IN VARCHAR2,
   discount_found_     IN NUMBER,
   discount_source_    IN VARCHAR2,
   create_partial_sum_ IN VARCHAR2,
   discount_line_no_   IN NUMBER,
   discount_source_id_ IN VARCHAR2 )
IS
   attr_        VARCHAR2(2000);
   objid_       CUST_INVOICE_ITEM_DISCOUNT.objid%TYPE;
   objversion_  CUST_INVOICE_ITEM_DISCOUNT.objversion%TYPE;
   newrec_      CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   -- don't call Prepare_Insert___ to avoid setting wrong IID values
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
   Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_TYPE', discount_type_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT', discount_found_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_DB', discount_source_, attr_);
   Client_SYS.Add_To_Attr('CREATE_PARTIAL_SUM_DB', create_partial_sum_, attr_);
   Client_SYS.Add_To_Attr('DISCOUNT_LINE_NO', discount_line_no_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   -- Calculate the discounts for the new row in Cust Invoice Item Discount.
   Calculate_Discount__(company_, invoice_id_, item_id_);
END New;


-- Get_Total_Discount
--   Returns the total discount for all discount rows on a customer
--   order line.
FUNCTION Get_Total_Discount (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   discount_line_no_    NUMBER;
   calculation_basis_   NUMBER;
   last_price_currency_ NUMBER;
   total_discount_      NUMBER;
   temp_                NUMBER;
   invoiced_qty_        NUMBER;

   CURSOR get_calc_basis IS
      SELECT calculation_basis
      FROM CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE discount_line_no = (SELECT MIN(discount_line_no)
                                FROM CUST_INVOICE_ITEM_DISCOUNT_TAB
                                WHERE company = company_
                                AND invoice_id = invoice_id_
                                AND item_id = item_id_)

      AND   company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;

   CURSOR get_price_curr IS
      SELECT price_currency
      FROM CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE discount_line_no = discount_line_no_
      AND   company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;

   CURSOR get_invoiced_qty IS
      SELECT invoiced_qty
      FROM  CUSTOMER_ORDER_INV_ITEM
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;

BEGIN
   discount_line_no_ := Get_Last_Discount_Line_No(company_, invoice_id_, item_id_);

   OPEN get_calc_basis;
   FETCH get_calc_basis INTO calculation_basis_;
   CLOSE get_calc_basis;

   OPEN get_price_curr;
   FETCH get_price_curr INTO last_price_currency_;
   CLOSE get_price_curr;

   OPEN get_invoiced_qty;
   FETCH get_invoiced_qty INTO invoiced_qty_;
   CLOSE get_invoiced_qty;

   IF (calculation_basis_ = 0) THEN
      total_discount_ := 0;
   ELSE
      temp_ := ((calculation_basis_ * invoiced_qty_) - last_price_currency_);
      total_discount_ := ((temp_ / (calculation_basis_ * invoiced_qty_)) * 100);
   END IF;

   RETURN NVL(total_discount_, 0);
END Get_Total_Discount;


-- Remove_Discount_Row
--   Removes a discount row.
PROCEDURE Remove_Discount_Row (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER,
   discount_no_ IN NUMBER )
IS
   objid_       VARCHAR2(200);
   objversion_  VARCHAR2(2000);
   remrec_      CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, company_, invoice_id_, item_id_, discount_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Discount_Row;


-- Get_Last_Discount_Line_No
--   Returns the last discount line no used.
@UncheckedAccess
FUNCTION Get_Last_Discount_Line_No (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN NUMBER
IS
   line_no_  NUMBER;

   CURSOR get_last IS
      SELECT MAX(discount_line_no)
      FROM CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_;
BEGIN
   OPEN get_last;
   FETCH get_last INTO line_no_;
   CLOSE get_last;

   IF (line_no_ IS NULL) THEN
      line_no_ := 0;
   END IF;
   RETURN line_no_;
END Get_Last_Discount_Line_No;


-- Check_Existing_Discount_Row
--   Returns true if there are any existing row.
FUNCTION Check_Existing_Discount_Row (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER,
   discount_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(company_, invoice_id_, item_id_, discount_no_);
END Check_Existing_Discount_Row;


-- Check_Manual_Rows
--   Returns true if there are any rows with disocunt sourc Manual.
@UncheckedAccess
FUNCTION Check_Manual_Rows (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER,
   item_id_    IN NUMBER ) RETURN BOOLEAN
IS
   dummy_     NUMBER;
   CURSOR get_manual IS
      SELECT 1
      FROM CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE company = company_
      AND   invoice_id = invoice_id_
      AND   item_id = item_id_
      AND   discount_source = 'MANUAL';
BEGIN
   OPEN get_manual;
   FETCH get_manual INTO dummy_;
   IF (get_manual%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE get_manual;
   RETURN (dummy_ = 1);
END Check_Manual_Rows;


-- Copy_Discount
--   Copies all discount lines from a customer order line
--   If copy_amount_ is FALSE, only discount percetage lines
--   are copied - otherwise both percentages and amounts are copied.
PROCEDURE Copy_Discount (
   company_      IN VARCHAR2,
   invoice_id_   IN NUMBER,
   item_id_      IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   invoiced_qty_ IN NUMBER )
IS
   attr_         VARCHAR2(2000);
   objid_        CUST_INVOICE_ITEM_DISCOUNT.objid%TYPE;
   objversion_   CUST_INVOICE_ITEM_DISCOUNT.objversion%TYPE;
   emptyrec_     CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
   newrec_       CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
   buy_qty_due_  NUMBER;
   rental_       VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   indrec_       Indicator_Rec;
   rental_transaction_id_    NUMBER;
   unit_price_curr_          NUMBER;
   unit_price_incl_tax_curr_ NUMBER;
   unit_price_base_          NUMBER;
   unit_price_incl_tax_base_ NUMBER;
   use_price_incl_tax_       VARCHAR2(20);
   calculation_basis_        NUMBER;
   previous_discount_        NUMBER := 0;
   CURSOR get_discount_lines IS
      SELECT discount_type, discount, discount_amount, calculation_basis,
             discount_source, discount_source_id, create_partial_sum, discount_line_no,
             price_currency, price_currency_incl_tax, price_base, price_base_incl_tax
      FROM CUST_ORDER_LINE_DISCOUNT_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   $IF Component_Rental_SYS.INSTALLED $THEN
      rental_       := Customer_Order_Line_API.Get_Rental_Db(order_no_, line_no_, rel_no_, line_item_no_); 
      IF (rental_ = Fnd_Boolean_API.DB_TRUE) THEN
         rental_transaction_id_ := Customer_Order_Inv_Item_API.Get_Rental_Transaction_Id(newrec_.company, newrec_.invoice_id, newrec_.item_id);      
         IF (rental_transaction_id_ IS NOT NULL) THEN
            unit_price_curr_ := Rental_Transaction_API.Get_Unit_Price_Curr(rental_transaction_id_);
            unit_price_incl_tax_curr_ := Rental_Transaction_API.Get_Unit_Price_Incl_Tax_Curr(rental_transaction_id_);
            unit_price_base_ := Rental_Transaction_API.Get_Unit_Price_Base(rental_transaction_id_);
            unit_price_incl_tax_base_ := Rental_Transaction_API.Get_Unit_Price_Incl_Tax_Base(rental_transaction_id_);
         END IF; 
      END IF;
   $END
   
   use_price_incl_tax_ := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_);
   FOR rec_ IN get_discount_lines LOOP
      newrec_ := emptyrec_;
      Client_SYS.Clear_Attr(attr_); -- don't call Prepare_Insert___ to avoid setting wrong IID values
      Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_TYPE', rec_.discount_type, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT', rec_.discount, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_AMOUNT', rec_.discount_amount, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_DB', rec_.discount_source, attr_);
      Client_SYS.Add_To_Attr('CREATE_PARTIAL_SUM_DB', rec_.create_partial_sum, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_LINE_NO', rec_.discount_line_no, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_ID', rec_.discount_source_id, attr_);
      IF (rental_transaction_id_ IS NULL) THEN
         Client_SYS.Add_To_Attr('CALCULATION_BASIS', rec_.calculation_basis, attr_);
         Client_SYS.Add_To_Attr('PRICE_CURRENCY', rec_.price_currency, attr_);
         Client_SYS.Add_To_Attr('PRICE_CURRENCY_INCL_TAX', rec_.price_currency_incl_tax, attr_);
         Client_SYS.Add_To_Attr('PRICE_BASE', rec_.price_base, attr_);
         Client_SYS.Add_To_Attr('PRICE_BASE_INCL_TAX',     rec_.price_base_incl_tax,     attr_);
      ELSE
         IF (use_price_incl_tax_ = Fnd_Boolean_API.DB_TRUE) THEN
            calculation_basis_ := unit_price_incl_tax_curr_ * (1 - previous_discount_/100);
         ELSE
            calculation_basis_ := unit_price_curr_ * (1 - previous_discount_/100);
         END IF;
         Client_SYS.Add_To_Attr('CALCULATION_BASIS', calculation_basis_, attr_);
         Client_SYS.Add_To_Attr('PRICE_CURRENCY', unit_price_curr_ * (1 - rec_.discount/100), attr_);
         Client_SYS.Add_To_Attr('PRICE_CURRENCY_INCL_TAX', unit_price_incl_tax_curr_ * (1 - rec_.discount/100), attr_);
         Client_SYS.Add_To_Attr('PRICE_BASE', unit_price_base_ * (1 - rec_.discount/100), attr_);
         Client_SYS.Add_To_Attr('PRICE_BASE_INCL_TAX', unit_price_incl_tax_base_* (1 - rec_.discount/100), attr_);
         IF (rec_.create_partial_sum = Create_Partial_Sum_API.DB_PARTIAL_SUM)THEN
            previous_discount_ := rec_.discount;
         ELSE
            previous_discount_ := 0;
         END IF;         
      END IF;
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;

   -- IF the amount invoiced does not equal the amount on the order line
   -- the total discount percentage for the invoice item might not be the same as
   -- the total discount on the order line due to rounding of discount amounts.
   -- In this case a recalculation might be needed
   -- Recalculation is not needed for Rental CO lines.
   buy_qty_due_  := Customer_Order_Line_API.Get_Buy_Qty_Due(order_no_, line_no_, rel_no_, line_item_no_);   

   IF ((rental_ = Fnd_Boolean_API.DB_FALSE) AND (buy_qty_due_ != invoiced_qty_)) THEN
      Calculate_Discount__(company_, invoice_id_, item_id_);
   END IF;

END Copy_Discount;

-- Copy_Discount_Credit
--   Copies all discount lines from a debet invoice id to
--   a credit invoice id when a credit invoice item is being created.
PROCEDURE Copy_Discount_Credit (
   company_        IN VARCHAR2,
   invoice_id_     IN NUMBER,
   item_id_        IN NUMBER,
   deb_invoice_id_ IN NUMBER,
   deb_item_id_    IN NUMBER )
IS
   attr_        VARCHAR2(2000);
   objid_       CUST_INVOICE_ITEM_DISCOUNT.objid%TYPE;
   objversion_  CUST_INVOICE_ITEM_DISCOUNT.objversion%TYPE;
   emptyrec_    CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
   newrec_      CUST_INVOICE_ITEM_DISCOUNT_TAB%ROWTYPE;
   indrec_      Indicator_Rec;

   CURSOR get_discount_lines IS
      SELECT discount_type, discount, discount_amount, calculation_basis,
             discount_source, discount_source_id, create_partial_sum, discount_line_no,
             price_currency, price_currency_incl_tax, price_base, price_base_incl_tax
      FROM CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE company = company_
      AND invoice_id = deb_invoice_id_
      AND item_id = deb_item_id_;
BEGIN
   FOR rec_ IN get_discount_lines LOOP
      newrec_ := emptyrec_;
      Client_SYS.Clear_Attr(attr_); -- don't call Prepare_Insert___ to avoid setting wrong IID values
      Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_TYPE', rec_.discount_type, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT', rec_.discount, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_AMOUNT', rec_.discount_amount, attr_);
      Client_SYS.Add_To_Attr('CALCULATION_BASIS', rec_.calculation_basis, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_DB', rec_.discount_source, attr_);
      Client_SYS.Add_To_Attr('CREATE_PARTIAL_SUM_DB', rec_.create_partial_sum, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_LINE_NO', rec_.discount_line_no, attr_);
      Client_SYS.Add_To_Attr('DISCOUNT_SOURCE_ID', rec_.discount_source_id, attr_);
      Client_SYS.Add_To_Attr('PRICE_CURRENCY', rec_.price_currency, attr_);
      Client_SYS.Add_To_Attr('PRICE_CURRENCY_INCL_TAX', rec_.price_currency_incl_tax, attr_);
      Client_SYS.Add_To_Attr('PRICE_BASE', rec_.price_base, attr_);
      Client_SYS.Add_To_Attr('PRICE_BASE_INCL_TAX',     rec_.price_base_incl_tax,     attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END LOOP;
END Copy_Discount_Credit;


-- Get_Total_Line_Discount
--   Returns calculated line discount amount.
--   When a customer invoice line has multiple discount lines, discount for each line is calculated and rounded first.
--   Then it is added to total discount amount.
--   When calculating total discount percentage; unrounded line discount is used. Then currency_rounding_ should be null.
--   If use price including tax is true and discount amount is needed without tax, tax_percentage_ should not be null. 
@UncheckedAccess
FUNCTION Get_Total_Line_Discount (
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER,
   item_id_           IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER, 
   currency_rounding_ IN NUMBER DEFAULT NULL,
   tax_percentage_    IN NUMBER DEFAULT NULL) RETURN NUMBER
IS
   discount_amount_     NUMBER :=0;
   total_line_discount_ NUMBER :=0;

   CURSOR get_line_discounts IS
      SELECT (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM   CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;
BEGIN
   -- gelr:disc_price_rounded, Redirected the implementation to Get_Total_Line_Disc_Rounded___ when Discounted Price Rounded and no Price including Tax.
   IF (Customer_Order_Inv_Item_API.Get_Discounted_Price_Rounded(company_, invoice_id_, item_id_) AND currency_rounding_ IS NOT NULL) THEN
      RETURN Get_Total_Line_Disc_Rounded___ (company_, invoice_id_, item_id_, quantity_, price_conv_factor_, currency_rounding_);
   ELSE  
      FOR discount_rec_ IN get_line_discounts LOOP
         discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_);
         IF currency_rounding_ IS NOT NULL THEN
            discount_amount_     := ROUND(discount_amount_ , currency_rounding_);
         END IF;
         IF (tax_percentage_ IS NOT NULL) THEN
            discount_amount_  := discount_amount_ / (1 + (tax_percentage_/100));
            -- Re-round the discount amount without tax
            IF currency_rounding_ IS NOT NULL THEN
               discount_amount_  := ROUND(discount_amount_ , currency_rounding_);
            END IF;
         END IF;
         total_line_discount_ := total_line_discount_ + discount_amount_;
      END LOOP;
      RETURN total_line_discount_;
   END IF;
END Get_Total_Line_Discount;


-- Remove
--   Delete if records exist for CO Invoice Item.
--   Used for cascade delete when removing a Invoice Item (INVOIC module).
PROCEDURE Remove (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   info_       VARCHAR2(2000);
   
   CURSOR get_discount_nos IS
      SELECT discount_no
      FROM   cust_invoice_item_discount_tab
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   FOR discount_nos_ IN get_discount_nos LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, company_, invoice_id_, item_id_, discount_nos_.discount_no);
      Remove__(info_, objid_, objversion_, 'DO');
   END LOOP;
END Remove;

-- gelr:disc_price_rounded, begin
@UncheckedAccess
FUNCTION Get_Original_Total_Line_Disc (
   company_           IN VARCHAR2,
   invoice_id_        IN NUMBER,
   item_id_           IN NUMBER,
   quantity_          IN NUMBER,
   price_conv_factor_ IN NUMBER ) RETURN NUMBER
IS
   discount_amount_     NUMBER :=0;
   total_line_discount_ NUMBER :=0;

   CURSOR get_line_discounts IS
      SELECT (calculation_basis * NVL(discount, 0)/100 + NVL(discount_amount, 0))  discount_amount
      FROM   CUST_INVOICE_ITEM_DISCOUNT_TAB
      WHERE  company = company_
      AND    invoice_id = invoice_id_
      AND    item_id = item_id_;
BEGIN
   FOR discount_rec_ IN get_line_discounts LOOP
      discount_amount_     := (discount_rec_.discount_amount * quantity_ * price_conv_factor_);
      total_line_discount_ := total_line_discount_ + discount_amount_;
   END LOOP;
   RETURN total_line_discount_;  
   
END Get_Original_Total_Line_Disc;
-- gelr:disc_price_rounded, end

