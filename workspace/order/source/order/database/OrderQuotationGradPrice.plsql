-----------------------------------------------------------------------------
--
--  Logical unit: OrderQuotationGradPrice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  2018-06-26  SeJalk  SCUXXW4-8502, Added methods Get_Calc_Sales_Price_Incl_Tax, Get_Calc_Sales_Price, and Calculate_Prices.
--  170420  KiSalk  Bug 135429, Added method Copy_All_Lines.
--  150707  Vwloza  RED-620, Added Price_Qty_Duration_Exist().
--  150702  Vwloza  RED-602, Added min_duration validation to Check_Insert___().
--  150626  Vwloza  RED-477, Updated cursor in Calculate_Price() to consider min_duration, updated Check_Insert___().
--  120723  ShKolk  Added sales_price_incl_tax, base_unit_price_incl_tax, unit_price_incl_tax
--  120323          and calc_unit_price_incl_tax columns to store prices including tax.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  011018  JOHESE  Bug fix 25488, Corrected some double byte errors
--  010528  JSAnse  Bug fix 21463, added call to  General_SYS.Init_Method in procedure New, Modify_Offset,
--                  Remove, Check_Exist, Calculate_Price and Price_Qty_Exist.
--  001124  MaGu    Added public method Price_Qty_Exist. Removed call to
--                  Customer_Order_Pricing.Get_Quote_Line_Price_Info from method Calculate_Price.
--  001110  MaGu    Modified procedure Calculate_Price. Added parameter price_source_id to
--                  call to Customer_Order_Pricing_API.Get_Quote_Line_Price_Info.
--  000712  LUDI    Merged from Chameleon
--  --------------  -----------------------------------------------------------
--  ooo7o4  LIN     added fields in calculate_price for get_quote_line_price_info
--  000607  LUDI    Update LineHistory by insert, delete and modify
--  000602  LIN     Added function calculate_price
--  000526  LIN     New fields added
--  000510  GBO     Added Cascade delete
--  000509  LIN     Added function grad_price_exist
--  000426  LIN     Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   q_rec_         Order_Quotation_api.public_rec;
   company_       VARCHAR2(20);
   currency_code_ VARCHAR2(3);
   rounding_      NUMBER;
   quotation_no_  ORDER_QUOTATION_GRAD_PRICE_TAB.quotation_no%TYPE;
BEGIN
   quotation_no_  := Client_SYS.Get_Item_Value('QUOTATION_NO', attr_);
   q_rec_         := Order_Quotation_api.get(quotation_no_);
   super(attr_);
   company_       := q_rec_.company;
   currency_code_ := q_rec_.currency_code;
   rounding_     := NVL(Currency_Code_API.Get_Currency_Rounding(company_,currency_code_), 8);
   Client_SYS.Add_To_Attr('ROUNDING', rounding_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ORDER_QUOTATION_GRAD_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   rev_no_     NUMBER;
   CURSOR get_price_line_no IS
      SELECT NVL(max(price_line_no) + 1, 1)
      FROM ORDER_QUOTATION_GRAD_PRICE_TAB
      WHERE quotation_no = newrec_.quotation_no
      AND   line_no      = newrec_.line_no
      AND   rel_no       = newrec_.rel_no
      AND   line_item_no = newrec_.line_item_no;
BEGIN
   OPEN  get_price_line_no;
   FETCH get_price_line_no INTO newrec_.price_line_no;
   CLOSE get_price_line_no;
   Client_SYS.Add_To_Attr('PRICE_LINE_NO', newrec_.price_line_no, attr_);
   super(objid_, objversion_, newrec_, attr_);
 -- OrderQuotationLine is modified
   Order_Quotation_Line_API.Line_Changed( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no );

   -- history
   rev_no_ := Order_Quotation_API.Get_Revision_No(newrec_.quotation_no);
   Order_Quote_Line_Hist_API.New( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
   '', '', '', 'PRICE_BREAK_OF_LINE', newrec_.price_line_no, rev_no_, 'New');
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ORDER_QUOTATION_GRAD_PRICE_TAB%ROWTYPE,
   newrec_     IN OUT ORDER_QUOTATION_GRAD_PRICE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   rev_no_     NUMBER;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- OrderQuotationLine is modified
   Order_Quotation_Line_API.Line_Changed( newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no );

   -- history
   rev_no_ := Order_Quotation_API.Get_Revision_No(newrec_.quotation_no);
   IF ( NVL(oldrec_.min_quantity, 0) != NVL(newrec_.min_quantity, 0) ) THEN
      Order_Quote_Line_Hist_API.New( newrec_.quotation_no, newrec_.line_no,newrec_.rel_no, newrec_.line_item_no,
      'MIN_QUANTITY', oldrec_.min_quantity, newrec_.min_quantity,'PRICE_BREAK_OF_LINE', newrec_.price_line_no,
      rev_no_, 'Modified' );
   END IF;
   IF ( NVL(oldrec_.sales_price, 0) != NVL(newrec_.sales_price, 0) ) THEN
      Order_Quote_Line_Hist_API.New( newrec_.quotation_no, newrec_.line_no,newrec_.rel_no, newrec_.line_item_no,
      'SALES_PRICE', oldrec_.sales_price, newrec_.sales_price,'PRICE_BREAK_OF_LINE', newrec_.price_line_no,
      rev_no_, 'Modified' );
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN ORDER_QUOTATION_GRAD_PRICE_TAB%ROWTYPE )
IS
   rev_no_ NUMBER;
BEGIN
   super(objid_, remrec_);
   -- OrderQuotationLine is modified
   Order_Quotation_Line_API.Line_Changed( remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no );

   -- history
   rev_no_ := Order_Quotation_API.Get_Revision_No(remrec_.quotation_no);
   Order_Quote_Line_Hist_API.New( remrec_.quotation_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no,
   '', '', '', 'PRICE_BREAK_OF_LINE', remrec_.price_line_no, rev_no_, 'Deleted');
END Delete___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     order_quotation_grad_price_tab%ROWTYPE,
   newrec_ IN OUT order_quotation_grad_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   
   IF (newrec_.sales_price <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'GPSALESPRICELEZ: Sales price must be greater than zero!');
   END IF;
END Check_Common___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_quotation_grad_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   found_ NUMBER := 0;
   
   CURSOR check_unique_qty_duration IS
      SELECT 1
      FROM order_quotation_grad_price_tab
      WHERE quotation_no = newrec_.quotation_no
      AND line_no = newrec_.line_no
      AND rel_no = newrec_.rel_no
      AND line_item_no = newrec_.line_item_no
      AND min_quantity = newrec_.min_quantity
      AND (min_duration IS NULL OR min_duration = newrec_.min_duration);
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF (Order_Quotation_Line_API.Get_Rental_Db(newrec_.quotation_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = Fnd_Boolean_API.DB_TRUE) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'MIN_DURATION', newrec_.min_duration);
   ELSE
      IF newrec_.min_duration IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'MINDURNULLNONRENTAL: Min Duration cannot have a value for non-rental lines.');
      END IF;
   END IF;
   
   -- Enforce uniqueness of min_quantity and min_duration per quotation line.
   OPEN check_unique_qty_duration;
   FETCH check_unique_qty_duration INTO found_;
   IF (check_unique_qty_duration%FOUND) THEN
      CLOSE check_unique_qty_duration;
      Error_SYS.Record_General(lu_name_, 'ORQUQTYDUREXISTS: The Order Quotation Price Break object already exists.');
   END IF;
   CLOSE check_unique_qty_duration;   
   
   IF (newrec_.min_quantity < 0) THEN
      Error_SYS.Record_General(lu_name_, 'GP_MIN_QTY_LESS_ZERO: Minimum quantity must be greater than zero!');
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new record.
PROCEDURE New (
   quotation_no_      IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   price_line_no_     IN NUMBER,
   sales_price_       IN NUMBER,
   percentage_offset_ IN NUMBER,
   amount_offset_     IN NUMBER,
   rounding_          IN NUMBER )
IS
BEGIN
   NULL;
END New;


-- Modify_Offset
--   Modifies percentage offset and amount offset
PROCEDURE Modify_Offset (
   quotation_no_      IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   price_line_no_     IN NUMBER,
   percentage_offset_ IN NUMBER,
   amount_offset_     IN NUMBER )
IS
BEGIN
   NULL;
END Modify_Offset;

FUNCTION Get_Calc_Sales_Price_Incl_Tax(  
   sales_price_                   IN NUMBER,
   set_sales_price_               IN VARCHAR2,
   quotation_no_                  IN VARCHAR2,                                         
   line_no_                       IN VARCHAR2, 
   rel_no_                        IN VARCHAR2, 
   line_item_no_                  IN VARCHAR2, 
   contract_                      IN VARCHAR2,  
   sales_price_incl_tax_          IN NUMBER,
   calc_sale_unit_price_          IN NUMBER,
   amount_offset_                 IN NUMBER,
   percentage_offset_             IN NUMBER,
   calc_sale_unit_price_incl_tax_ IN NUMBER,
   rounding_                      IN NUMBER) RETURN NUMBER
IS
   calc_sales_price_incl_tax_ NUMBER;
   calculated_sales_price_ NUMBER;
   sales_price_temp_    NUMBER;
   set_sales_price_temp_ VARCHAR2(5);
   sales_price_incl_tax_temp_ NUMBER;
BEGIN

   sales_price_temp_     :=sales_price_;
   set_sales_price_temp_ := set_sales_price_;
   sales_price_incl_tax_temp_ := sales_price_incl_tax_;
   
   Calculate_Prices(
            calc_sales_price_incl_tax_,
            sales_price_incl_tax_temp_,
            calculated_sales_price_,  
            sales_price_temp_,
            set_sales_price_temp_,
            quotation_no_,                                         
            line_no_, 
            rel_no_, 
            line_item_no_, 
            contract_,            
            calc_sale_unit_price_,
            NVL(amount_offset_,0),
            NVL(percentage_offset_,0),
            calc_sale_unit_price_incl_tax_,
            rounding_);
   RETURN  calc_sales_price_incl_tax_;        
END Get_Calc_Sales_Price_Incl_Tax;

FUNCTION Get_Calc_Sales_Price( 
   sales_price_                   IN NUMBER,
   set_sales_price_               IN VARCHAR2,
   quotation_no_                  IN VARCHAR2,                                         
   line_no_                       IN VARCHAR2, 
   rel_no_                        IN VARCHAR2, 
   line_item_no_                  IN VARCHAR2, 
   contract_                      IN VARCHAR2,  
   sales_price_incl_tax_          IN NUMBER,
   calc_sale_unit_price_          IN NUMBER,
   amount_offset_                 IN NUMBER,
   percentage_offset_             IN NUMBER,
   calc_sale_unit_price_incl_tax_ IN NUMBER,
   rounding_                      IN NUMBER) RETURN NUMBER
IS
   calc_sales_price_incl_tax_ NUMBER;
   calculated_sales_price_ NUMBER;
   sales_price_temp_    NUMBER;
   set_sales_price_temp_ VARCHAR2(5);
   sales_price_incl_tax_temp_ NUMBER;
   
BEGIN

   sales_price_temp_     := sales_price_;
   set_sales_price_temp_ := set_sales_price_;
   sales_price_incl_tax_temp_ := sales_price_incl_tax_;
   
   Calculate_Prices(
            calc_sales_price_incl_tax_,
            sales_price_incl_tax_temp_,
            calculated_sales_price_,  
            sales_price_temp_,
            set_sales_price_temp_,
            quotation_no_,                                         
            line_no_, 
            rel_no_, 
            line_item_no_, 
            contract_,  
            calc_sale_unit_price_,
            NVL(amount_offset_,0),
            NVL(percentage_offset_,0),
            calc_sale_unit_price_incl_tax_,
            rounding_);
    RETURN calculated_sales_price_;        
END Get_Calc_Sales_Price;


PROCEDURE Calculate_Prices(
   calc_sales_price_incl_tax_         OUT NUMBER,
   sales_price_incl_tax_              OUT NUMBER,
   calculated_sales_price_            IN OUT NUMBER,  
   sales_price_                       IN OUT NUMBER,
   set_sales_price_                   IN OUT VARCHAR2,
   quotation_no_                      IN VARCHAR2,                                         
   line_no_                           IN VARCHAR2, 
   rel_no_                            IN VARCHAR2, 
   line_item_no_                      IN VARCHAR2, 
   contract_                          IN VARCHAR2,    
   calc_sale_unit_price_num_          IN NUMBER,
   amount_offset_num_                 IN NUMBER,
   percentage_offset_num_             IN NUMBER,
   calc_sale_unit_price_incl_tax_num_ IN NUMBER,
   rounding_num_                      IN NUMBER)
IS
  sales_price_num_ NUMBER := 0;
  round_ NUMBER := 0;
  sales_price_str_ VARCHAR2(100) := '';
  calc_price_str_ VARCHAR2(100) := '';
  calc_price_num_ NUMBER := 0;
  sales_price_str_incl_tax_ VARCHAR2(100) := '';
  calc_price_str_incl_tax_ VARCHAR2(100) := '';
  calc_price_num_incl_tax_ NUMBER := 0;
  sales_price_num_incl_tax_ NUMBER := 0;
  net_price_base_ NUMBER;
  gross_price_base_ NUMBER;
  
  calc_sale_unit_price_     NUMBER;
  amount_offset_  NUMBER;
  percentage_offset_ NUMBER;
  calc_sale_unit_price_incl_tax_ NUMBER;
  rounding_   NUMBER;
  

BEGIN
  calc_sale_unit_price_     := NVL(calc_sale_unit_price_num_,0);
  amount_offset_ := NVL(amount_offset_num_,0);
  percentage_offset_ := NVL(percentage_offset_num_, 0);
  calc_sale_unit_price_incl_tax_ := NVL(calc_sale_unit_price_incl_tax_num_,0);
  rounding_   := NVL(rounding_num_,0);
  sales_price_ := NVL(sales_price_,0);
  calculated_sales_price_ := NVL(calculated_sales_price_,0);
  IF ( calculated_sales_price_ != sales_price_ ) THEN         
      sales_price_num_ := sales_price_;
      set_sales_price_ := 'FALSE';      
  ELSE         
      sales_price_num_ := calc_sale_unit_price_ + amount_offset_ + (calc_sale_unit_price_ * percentage_offset_ / 100);
      sales_price_num_incl_tax_ := calc_sale_unit_price_incl_tax_ + amount_offset_ + (calc_sale_unit_price_incl_tax_ * percentage_offset_ / 100);
     -- Error_SYS.Record_General(calc_sale_unit_price_ || ' ddgs111111dd ', amount_offset_ );
  END IF;
  IF rounding_ < 0 AND rounding_ IS NOT NULL THEN
	round_ := ROUND(-rounding_,0);
	sales_price_num_ := sales_price_num_ * POWER(10, -round_);
	sales_price_num_ := ROUND(sales_price_num_,0) * POWER(10, round_);
	sales_price_str_ := ROUND(sales_price_num_, 0);
	calc_price_num_ := calc_sale_unit_price_ + amount_offset_ + (calc_sale_unit_price_ * percentage_offset_ / 100);
	calc_price_num_ := calc_price_num_ * POWER(10, -round_);
	calc_price_num_ := ROUND(calc_price_num_, 0) * POWER(10, round_);
	calc_price_str_ := ROUND(calc_price_num_, 0);
	sales_price_num_incl_tax_ := sales_price_num_incl_tax_ * POWER(10, -round_);
	sales_price_num_incl_tax_ := ROUND(sales_price_num_incl_tax_, 0) * POWER(10, round_);
	sales_price_str_incl_tax_ := ROUND(sales_price_num_incl_tax_, 0);
	calc_price_num_incl_tax_ := calc_sale_unit_price_incl_tax_ + amount_offset_ + (calc_sale_unit_price_incl_tax_ * percentage_offset_ / 100);
	calc_price_num_incl_tax_ := calc_price_num_incl_tax_ * POWER(10, -round_);
	calc_price_num_incl_tax_ := ROUND(calc_price_num_incl_tax_, 0) * POWER(10, round_);
	calc_price_str_incl_tax_ := ROUND(calc_price_num_incl_tax_, 0);
          
  ELSE
   
    IF MOD(sales_price_num_, 1) = 0 THEN
       sales_price_str_ := ROUND(sales_price_num_, 0);
    ELSE 
       sales_price_str_ := ROUND(sales_price_num_,(NVL(rounding_, 20)));
    END IF;
    calc_price_str_ := ROUND((calc_sale_unit_price_ + amount_offset_ + (calc_sale_unit_price_ * percentage_offset_ / 100)),(NVL(rounding_, 20)));
    IF MOD(sales_price_num_incl_tax_, 1) = 0THEN
       sales_price_str_incl_tax_ := ROUND(sales_price_num_incl_tax_, 0);
    ELSE 
       sales_price_str_incl_tax_ := ROUND(sales_price_num_incl_tax_,(NVL(rounding_, 20)));
    END IF;
    calc_price_str_incl_tax_ := ROUND((calc_sale_unit_price_incl_tax_ + amount_offset_ + (calc_sale_unit_price_incl_tax_ * percentage_offset_ / 100)),(NVL(rounding_, 20)));
   END IF;

    calculated_sales_price_ := calc_price_str_;
    calc_sales_price_incl_tax_ := calc_price_str_incl_tax_;
    
    IF (set_sales_price_ = 'TRUE') THEN
        sales_price_ := sales_price_str_;
        sales_price_incl_tax_ := sales_price_str_incl_tax_;

        Tax_Handling_Order_Util_API.Get_Prices(net_price_base_, 
                                            gross_price_base_,
                                            sales_price_,
                                            sales_price_incl_tax_,
                                            Site_API.Get_Company(contract_), 
                                            'ORDER_QUOTATION_LINE',
                                            quotation_no_,                                         
                                            line_no_,
                                            rel_no_,
                                            line_item_no_,
                                            '*',
                                            ifs_curr_rounding_ => 16);     
    END IF;

END Calculate_Prices;



-- Remove
--   Removes specified record.
PROCEDURE Remove (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   price_line_no_ IN NUMBER )
IS
BEGIN
   NULL;
END Remove;


-- Check_Exist
--   Returns TRUE if the specified return exists
FUNCTION Check_Exist (
   quotation_no_  IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   price_line_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN NULL;
END Check_Exist;


-- Grad_Price_Exist
--   Returns TRUE if any grad price exists for a quotation line.
@UncheckedAccess
FUNCTION Grad_Price_Exist (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR price_exist IS
      SELECT 1
      FROM   ORDER_QUOTATION_GRAD_PRICE_TAB
      WHERE quotation_no = quotation_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN price_exist;
   FETCH price_exist INTO dummy_;
   IF (price_exist%FOUND) THEN
      CLOSE price_exist;
      RETURN 'TRUE';
   END IF;
   CLOSE price_exist;
   RETURN 'FALSE';
END Grad_Price_Exist;


-- Calculate_Price
--   Returns the sales price depending on the quantity.
PROCEDURE Calculate_Price (
   sales_price_            OUT NUMBER,
   sales_price_incl_tax_   OUT NUMBER,
   quotation_no_           IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   buy_qty_due_            IN  NUMBER,
   rental_chargeable_days_ IN  NUMBER DEFAULT NULL)
IS
   CURSOR find_price IS
      SELECT sales_price, 
             sales_price_incl_tax 
      FROM (SELECT MAX(min_quantity) max_quantity,
                   min_duration,
                   sales_price,
                   sales_price_incl_tax
            FROM ORDER_QUOTATION_GRAD_PRICE_TAB t
            WHERE quotation_no = quotation_no_
            AND line_no = line_no_
            AND rel_no = rel_no_
            AND line_item_no = line_item_no_
            AND min_quantity <= buy_qty_due_
            AND (min_duration <= rental_chargeable_days_ OR min_duration IS NULL)
            GROUP BY min_duration, sales_price, sales_price_incl_tax
            ORDER BY max_quantity desc, min_duration desc)
      WHERE ROWNUM = 1;
BEGIN
   OPEN find_price;
   FETCH find_price INTO sales_price_, sales_price_incl_tax_;
   IF (find_price%NOTFOUND) THEN
      sales_price_          := 0;
      sales_price_incl_tax_ := 0;
   END IF;
   CLOSE find_price;
END Calculate_Price;


-- Price_Qty_Exist
--   Returns 'TRUE' if the quantity on the quotation line is within the
--   limits of the price breaks.
FUNCTION Price_Qty_Exist (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   buy_qty_due_  IN NUMBER ) RETURN VARCHAR2
IS
   temp_  NUMBER;

   CURSOR price_qty_exist IS
       SELECT 1
       FROM  ORDER_QUOTATION_GRAD_PRICE_TAB
       WHERE quotation_no = quotation_no_
       AND   line_no = line_no_
       AND   rel_no = rel_no_
       AND   line_item_no = line_item_no_
       AND   min_quantity <= buy_qty_due_;
BEGIN
   OPEN price_qty_exist;
   FETCH price_qty_exist INTO temp_;
   IF (price_qty_exist%NOTFOUND) THEN
      CLOSE price_qty_exist;
      RETURN 'FALSE';
   END IF;
   CLOSE price_qty_exist;
   RETURN 'TRUE';
END Price_Qty_Exist;

-- Price_Qty_Duration_Exist
--   Returns 'TRUE' if the quantity and duration on the quotation line is within the
--   limits of the price breaks.
FUNCTION Price_Qty_Duration_Exist (
   quotation_no_ IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   buy_qty_due_  IN NUMBER,
   duration_     IN NUMBER ) RETURN VARCHAR2
IS
   temp_  NUMBER;
   CURSOR price_qty_duration_exist IS
       SELECT 1
       FROM  ORDER_QUOTATION_GRAD_PRICE_TAB
       WHERE quotation_no = quotation_no_
       AND   line_no = line_no_
       AND   rel_no = rel_no_
       AND   line_item_no = line_item_no_
       AND   min_quantity <= buy_qty_due_
       and   min_duration <= duration_;
BEGIN
   OPEN price_qty_duration_exist;
   FETCH price_qty_duration_exist INTO temp_;
   IF (price_qty_duration_exist%NOTFOUND) THEN
      CLOSE price_qty_duration_exist;
      RETURN 'FALSE';
   END IF;
   CLOSE price_qty_duration_exist;
   RETURN 'TRUE';
END Price_Qty_Duration_Exist;

-- Copy_All_Lines
--   Copies all the price break lines from one quotation line with from_ attributes to another with to_ attributes.
PROCEDURE Copy_All_Lines (
   from_quotation_no_ IN VARCHAR2,
   from_line_no_      IN VARCHAR2,
   from_rel_no_       IN VARCHAR2,
   from_line_item_no_ IN NUMBER,
   to_quotation_no_   IN VARCHAR2,   
   to_line_no_        IN VARCHAR2,
   to_rel_no_         IN VARCHAR2,
   to_line_item_no_   IN NUMBER) 
IS  
   TYPE price_break_tab IS TABLE OF ORDER_QUOTATION_GRAD_PRICE_TAB%ROWTYPE INDEX BY PLS_INTEGER;
   price_break_tab_    price_break_tab;
   attr_                VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   newrec_              ORDER_QUOTATION_GRAD_PRICE_TAB%ROWTYPE;
      
   CURSOR get_rec IS
      SELECT *
      FROM ORDER_QUOTATION_GRAD_PRICE_TAB 
      WHERE quotation_no = from_quotation_no_
        AND line_no = from_line_no_
        AND rel_no = from_rel_no_
        AND line_item_no = from_line_item_no_;
       
BEGIN   
   Order_Quotation_API.Exist(to_quotation_no_);
   OPEN get_rec;
   LOOP  
      FETCH get_rec BULK COLLECT INTO price_break_tab_ LIMIT 1000;
      IF (price_break_tab_.COUNT > 0) THEN             
         FOR j IN price_break_tab_.FIRST..price_break_tab_.LAST LOOP
            -- Reset variables
            Client_SYS.Clear_Attr(attr_);            
            -- Assign copy record
            newrec_              := price_break_tab_(j);           
            newrec_.quotation_no := to_quotation_no_;               
            newrec_.line_no      := to_line_no_;               
            newrec_.rel_no       := to_rel_no_;               
            newrec_.line_item_no := to_line_item_no_;               
            newrec_.rowkey       := NULL ;           
            Insert___(objid_, objversion_, newrec_, attr_); 
            
            --Copy custom field values
            newrec_ := Get_Object_By_Id___(objid_);
            Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, price_break_tab_(j).rowkey, newrec_.rowkey);
         END LOOP;
      END IF;            
      EXIT WHEN get_rec%NOTFOUND;

   END LOOP;
   CLOSE get_rec;       
      
END Copy_All_Lines;