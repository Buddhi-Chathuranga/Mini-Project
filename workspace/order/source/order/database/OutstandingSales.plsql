-----------------------------------------------------------------------------
--
--  Logical unit: OutstandingSales
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191203  KiSalk  Bug 151224(SCZ-8038), Added mandatory attribute COST to attribute string to create new record in Modify_Self_Billing.
--  180426  ChBnlk  Bug 140582, Added a new procedure Raise_Future_Date_Error___ to prevent duplicating message constants.
--  170314  MeAblk  Bug 134044, Added Get_Unit_Cost_For_Inv_Item() and modified Check_Insert___() to avoid setting qty_shipped as 0. 
--  140811  NiDalk  Bug 118201, Modified Modify_Sales_Posted to update date_sales_posted even when set date_sales_posted is not null. Also added parameter company_. 
--  140811          Also modified Unpack_Check_Update___ to remove check Error_SYS.Check_Update_If_Null from date_sales_posted update.
--  131223  MalLlk  Added Check_Remove method to check if records exist for CO Invoice Item.
--  130603  RuLiLk  Bug 110133, Modified method Get_Expected_Invoice_Value() by changing Calculation logic of line discount amount to be consistent with discount postings.
--  120829  SeJalk  Bug 103399, Added a new parameter to the Modify_Sales_Posted in order to set the sales posted date by the invoice date.
--  120313  MoIflk  Bug 99430, Modified view OUTSTANDING_SALES_JOIN and method Modify_Self_Billing to include inverted_conv_factor logic.
--  120124  ChJalk  Modified the view comments of DATE_SALES_POSTED.
--  110127  NeKolk  EANE-3744  added where clause to the View OUTSTANDING_DELIVERY,OUTSTANDING_SALES_JOIN.
--  100520  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091007  TiRalk  Bug 83499, Modified method Get_Expected_Invoice_Value to correct the rounding off error in 'Delivery Confirmed Amount'.
--  070423  WaJalk  Bug 64506, In method Modify_Sales_Posted NVL from column invoice_id was removed to use the index.
--  060601  MiErlk  Enlarge Identity - Changed view comments - Description.
--  060524  PrPrlk  Bug 54753, In view OUTSTANDING_SALES_JOIN, fetched series_id and invoice_no using method calls. 
--  060523  ChJalk  Added the public method Get_Max_Delivery_Confirm_Date.
--  060418  RoJalk  Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 -----------------------------------------------
--  060223  IsWilk  Modified the FUNCTION Get_Expected_Invoice_Value to add the
--  060223          check for avoiding ORA Error "Divisor is Equal to zero".
--  051007  KanGlk  Added the Method Modify_Invoice_Reference.
--  050921  NaLrlk  Removed unused variables.
--  050817  SaJjlk  Added part_no to VIEWDELIV.
--  050815  AnLaSe  Added blocked_for_invoicing_db in VIEWJOIN.
--  050601  JoEd    Changed Get_Expected_Invoice_Value to fetch correct price from invoice.
--  050520  JoEd    Added attribute qty_shipped. Added series_id, invoice_no,
--                  consignment_stock_db and self_billing_db to VIEWJOIN.
--  050519  JoEd    Added Modify_Self_Billing.
--  050425  JoEd    Added VIEWDELIV. Added update check on date_cogs_posted.
--  050413  JoEd    Changed so that Modify doesn't raise an error if no records found for update.
--                  Set update flag on date_sales_posted to "update allowed if null".
--                  Added Get_Expected_Invoice_Value. Changed Get_Total_Confirm_Amount.
--                  Changed view VIEWJOIN.
--  050408  DaZase  Added method Get_Qty_Expected.
--  050406  JoEd    Added default value for date_cogs_posted.
--                  Added new method Modify_Sales_Posted.
--  050401  DaZase  Added company to Get method.
--  050330  JoEd    Added functions Get_Total_Qty_Confirmed and Get_Total_Confirm_Amount.
--  050322  JoEd    Added column CONTRACT.
--  050316  JoEd    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT OUTSTANDING_SALES_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_next_id IS
      SELECT outstanding_sales_seq.nextval
      FROM dual;
BEGIN
   -- fetch key value from sequence
   OPEN get_next_id;
   FETCH get_next_id INTO newrec_.outstanding_sales_id;
   CLOSE get_next_id;
   Client_SYS.Add_To_Attr('OUTSTANDING_SALES_ID', newrec_.outstanding_sales_id, attr_);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT outstanding_sales_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   sitedate_ DATE;
BEGIN
   sitedate_ := trunc(Site_API.Get_Site_Date(newrec_.contract));
   IF (NOT indrec_.date_cogs_posted) THEN
      newrec_.date_cogs_posted := sitedate_;
   END IF;
   IF (NOT indrec_.qty_shipped) THEN
      newrec_.qty_shipped := 0;
   END IF;
   
   super(newrec_, indrec_, attr_);
   IF (newrec_.date_cogs_posted IS NOT NULL) THEN
      IF (trunc(newrec_.date_cogs_posted) > sitedate_) THEN
         Raise_Future_Date_Error___;
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DATE_COGS_POSTED', newrec_.date_cogs_posted, attr_);
   Client_SYS.Add_To_Attr('DATE_SALES_POSTED', newrec_.date_sales_posted, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     outstanding_sales_tab%ROWTYPE,
   newrec_ IN OUT outstanding_sales_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.date_cogs_posted IS NOT NULL) THEN
      IF (trunc(newrec_.date_cogs_posted) > trunc(Site_API.Get_Site_Date(newrec_.contract))) THEN
         Raise_Future_Date_Error___;
      END IF;
   END IF;
   Client_SYS.Add_To_Attr('DATE_COGS_POSTED', newrec_.date_cogs_posted, attr_);
   Client_SYS.Add_To_Attr('DATE_SALES_POSTED', newrec_.date_sales_posted, attr_);
END Check_Update___;

PROCEDURE Raise_Future_Date_Error___
IS
BEGIN
   Error_SYS.Item_General(lu_name_, 'DATE_COGS_POSTED', 'FUTURE_DATE: [:NAME] may not be greater than today''s date.');
END Raise_Future_Date_Error___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new record.
PROCEDURE New (
   attr_ IN OUT VARCHAR2 )
IS
   newrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Modify
--   Updates one record using the deliv number to locate it.
PROCEDURE Modify (
   deliv_no_ IN NUMBER,
   attr_     IN VARCHAR2 )
IS
   mod_attr_   VARCHAR2(32000);
   newrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   oldrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;

   CURSOR get_attr IS
      SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM OUTSTANDING_SALES_TAB
      WHERE deliv_no = deliv_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO objid_, objversion_;
   IF (get_attr%FOUND) THEN
      CLOSE get_attr;
      mod_attr_ := attr_;
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, mod_attr_);
      Check_Update___(oldrec_, newrec_, indrec_, mod_attr_);
      Update___(objid_, oldrec_, newrec_, mod_attr_, objversion_);
   ELSE
      CLOSE get_attr;
      Trace_SYS.Field('Outstanding sales not created for delivery', deliv_no_);
   END IF;
END Modify;


-- Modify_Confirmed
--   Updates all records connected to a delivery. Consignment stock can have
--   more than one record per delivery.
--   Used when updating invoice keys.
PROCEDURE Modify_Confirmed (
   deliv_no_ IN NUMBER,
   attr_     IN VARCHAR2 )
IS
   mod_attr_   VARCHAR2(32000);
   newrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   oldrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;

   CURSOR get_record IS
      SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM OUTSTANDING_SALES_TAB
      WHERE deliv_no = deliv_no_
      AND invoice_id IS NULL;
BEGIN
   FOR rec_ IN get_record LOOP
      mod_attr_ := attr_;
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, mod_attr_);
      Check_Update___(oldrec_, newrec_, indrec_, mod_attr_);
      Update___(rec_.objid, oldrec_, newrec_, mod_attr_, objversion_);
   END LOOP;
END Modify_Confirmed;


-- Modify_Invoice_Reference
--   Updates the record connected to the given outstanding_sales_id.
PROCEDURE Modify_Invoice_Reference (
   outstanding_sales_id_ IN NUMBER,
   invoice_id_           IN NUMBER,
   item_id_              IN NUMBER)
IS
   newrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   oldrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;

   CURSOR get_record IS
      SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM  outstanding_sales_tab
      WHERE outstanding_sales_id = outstanding_sales_id_;

BEGIN
   FOR rec_ IN get_record LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(rec_.objid, oldrec_, newrec_, attr_, objversion_);
   END LOOP;
END Modify_Invoice_Reference;


-- Modify_Self_Billing
--   Updates the record connected to a self billing delivery.
--   If the self billing doesn't "close" the delivery the remaining expected
--   quantity should be places in a new record, so that the next self billing
--   invoice can update those invoice keys correctly.
--   If there's an invoiced quantity less than expected quantity - the expected
--   quantity is updated with that.
--   Used when updating self billing invoice keys.
PROCEDURE Modify_Self_Billing (
   deliv_no_       IN NUMBER,
   invoice_id_     IN NUMBER,
   item_id_        IN NUMBER,
   qty_to_invoice_ IN NUMBER,
   qty_to_match_   IN NUMBER )
IS
   CURSOR get_record IS
      SELECT objid, objversion, contract, company,
             qty_expected, qty_shipped, date_cogs_posted, conv_factor, inverted_conv_factor
      FROM OUTSTANDING_SALES_JOIN
      WHERE deliv_no = deliv_no_
      AND invoice_id IS NULL;

   rec_        get_record%ROWTYPE;
   attr_       VARCHAR2(32000);
   newrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   oldrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   qty_remain_ NUMBER;
   indrec_     Indicator_Rec;
BEGIN
   OPEN get_record;
   FETCH get_record INTO rec_;
   IF get_record%FOUND THEN
      CLOSE get_record;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
      Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
      qty_remain_ := rec_.qty_expected - qty_to_invoice_;
      -- if self billing invoice is for a qty larger than remaining expected qty,
      -- the expected qty should remain the same.
      IF (qty_remain_ > 0) THEN
         Client_SYS.Add_To_Attr('QTY_EXPECTED', qty_to_invoice_, attr_);
         Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_to_invoice_ * rec_.conv_factor / rec_.inverted_conv_factor, attr_);
      END IF;
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(rec_.objid, oldrec_, newrec_, attr_, objversion_);

      Trace_SYS.Field('qty_to_match', qty_to_match_);
      Trace_SYS.Field('remaining qty', qty_remain_);
      -- if the self billing is not final, a new outstanding sales record has
      -- to be created with the remaining qty. No invoice reference!
      -- qty_to_match = 0 when there is nothing left to match/invoice
      IF (qty_to_match_ > 0) AND (qty_remain_ > 0) THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
         Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
         Client_SYS.Add_To_Attr('COMPANY', rec_.company, attr_);
         Client_SYS.Add_To_Attr('DATE_COGS_POSTED', rec_.date_cogs_posted, attr_);
         Client_SYS.Add_To_Attr('QTY_EXPECTED', qty_remain_, attr_);
         Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_remain_ * rec_.conv_factor / rec_.inverted_conv_factor, attr_);
         Client_SYS.Add_To_Attr('COST', oldrec_.cost, attr_);
         newrec_ := NULL;
         indrec_ := NULL;
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
         Trace_SYS.Field('New outstanding sales record', newrec_.outstanding_sales_id);
      ELSE
         Trace_SYS.Message('NO NEW outstanding sales record needed');
      END IF;
   ELSE
      Trace_SYS.Field('No outstanding sales record found for deliv_no', deliv_no_);
      CLOSE get_record;
   END IF;
END Modify_Self_Billing;


-- Modify_Sales_Posted
--   Updates all outstanding sales records for a specific invoice
--   that hasn't been printed yet (date sales posted is set when printing)
PROCEDURE Modify_Sales_Posted (
   company_       IN VARCHAR2,
   invoice_id_    IN NUMBER,
   invoice_date_  IN DATE)
IS
   attr_       VARCHAR2(32000);
   newrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   oldrec_     OUTSTANDING_SALES_TAB%ROWTYPE;
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;

   CURSOR get_record IS
      SELECT rowid objid, to_char(rowversion,'YYYYMMDDHH24MISS') objversion
      FROM OUTSTANDING_SALES_TAB
      WHERE invoice_id = invoice_id_
      AND company = company_
      AND deliv_no > 0;
BEGIN
   IF invoice_date_ IS NOT NULL THEN
      FOR rec_ IN get_record LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('DATE_SALES_POSTED', invoice_date_, attr_);
         oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(rec_.objid, oldrec_, newrec_, attr_, objversion_);
      END LOOP;
   END IF;
END Modify_Sales_Posted;


-- Get_Total_Qty_Confirmed
--   Returns the quantity of the ordered parts that has been Delivery Confirmed.
@UncheckedAccess
FUNCTION Get_Total_Qty_Confirmed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_total IS
      SELECT SUM(nvl(qty_expected, 0))
      FROM OUTSTANDING_SALES_JOIN
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND date_confirmed IS NOT NULL;

   qty_  NUMBER;
BEGIN
   OPEN get_total;
   FETCH get_total INTO qty_;
   CLOSE get_total;
   RETURN nvl(qty_, 0);
END Get_Total_Qty_Confirmed;


-- Get_Total_Confirm_Amount
--   Returns the confirmed qty for confirmed deliveries * part price (in base curr).
--   I.e. the total confirmed amount for the order line.
@UncheckedAccess
FUNCTION Get_Total_Confirm_Amount (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_attr IS
      SELECT outstanding_sales_id
      FROM OUTSTANDING_SALES_JOIN
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND date_confirmed IS NOT NULL;

   amount_         NUMBER := 0;
   invoice_value_  NUMBER;
BEGIN
   FOR rec_ IN get_attr LOOP
      invoice_value_ := Get_Expected_Invoice_Value(rec_.outstanding_sales_id);
      amount_ := amount_ + nvl(invoice_value_, 0);
   END LOOP;
   RETURN amount_;
END Get_Total_Confirm_Amount;


-- Get_Qty_Expected
--   Returns the expected qty to invoice for a delivery / outstanding sales record.
--   If delivery is connected to consignment stock - this will return
--   expected quantity for all outstanding sales for that delivery.
@UncheckedAccess
FUNCTION Get_Qty_Expected (
   deliv_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ OUTSTANDING_SALES_TAB.qty_expected%TYPE;
   CURSOR get_attr IS
      SELECT SUM(qty_expected)
      FROM OUTSTANDING_SALES_TAB
      WHERE deliv_no = deliv_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Qty_Expected;


-- Get_Expected_Invoice_Value
--   Returns the part price in base currency multiplied with expected quantity
--   to invoice.
--   If an invoice is created the returned value is the Net Dom Amount from
--   the connected invoice item.
@UncheckedAccess
FUNCTION Get_Expected_Invoice_Value (
   outstanding_sales_id_ IN NUMBER ) RETURN NUMBER
IS 
   part_price_   NUMBER;
   price_conv_factor_      NUMBER;
   sale_unit_price_        NUMBER;
   currency_code_          VARCHAR2(3);
   total_gross_amount_     NUMBER;
   discount_               NUMBER;
   order_discount_         NUMBER;
   additional_discount_    NUMBER;
   line_discount_amount_   NUMBER;
   add_disc_amt_           NUMBER;
   order_discount_amount_  NUMBER;
   net_curr_amount_        NUMBER;
   order_no_               VARCHAR2(12);
   line_no_                VARCHAR2(4);
   rel_no_                 VARCHAR2(4);
   line_item_no_           NUMBER;
   delivery_confirmed_amt_ NUMBER;
   currency_rate_          NUMBER;
   currency_rounding_      NUMBER;
   rounding_               NUMBER;  

   CURSOR get_attr IS
      SELECT deliv_no, company, invoice_id, item_id, qty_expected, qty_invoiced
      FROM OUTSTANDING_SALES_JOIN
      WHERE outstanding_sales_id = outstanding_sales_id_;

   rec_  get_attr%ROWTYPE;

   CURSOR get_delivery_line(deliv_no_ IN NUMBER) IS
      SELECT price_conv_factor, sale_unit_price, discount, order_discount,
             additional_discount, order_no, line_no, rel_no, line_item_no,
             currency_rate
      FROM   CO_DELIVERY_JOIN
      WHERE  deliv_no = deliv_no_   
      AND    ROWNUM = 1; -- relation "1 -> many" only for consignment  
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO rec_;
   CLOSE get_attr;
   rounding_ := Currency_Code_API.Get_Currency_Rounding(rec_.company, Company_Finance_API.Get_Currency_Code(rec_.company));
   
   IF (rec_.invoice_id IS NOT NULL) THEN
      part_price_ := Customer_Order_Inv_Item_API.Get_Net_Dom_Amount(rec_.company, rec_.invoice_id, rec_.item_id); -- total price in price unit
      IF (rec_.qty_invoiced != 0) THEN
         part_price_ := part_price_ / rec_.qty_invoiced; -- part price in price unit
      END IF;
      delivery_confirmed_amt_ := ROUND(NVL(part_price_ * rec_.qty_expected, 0), rounding_);
   ELSE     
      OPEN  get_delivery_line(rec_.deliv_no);
      FETCH get_delivery_line INTO price_conv_factor_, sale_unit_price_, discount_, order_discount_, additional_discount_, order_no_, line_no_, rel_no_, line_item_no_, currency_rate_;
      CLOSE get_delivery_line;  
     
      currency_code_          := Customer_Order_API.Get_Currency_Code(order_no_);
      currency_rounding_      := Currency_Code_API.Get_Currency_Rounding(rec_.company, currency_code_); 
   
      total_gross_amount_     := rec_.qty_expected * price_conv_factor_ * sale_unit_price_;
      -- NOTE: When using price including tax, discount calculation is not modified as this pakage was not handled in price including tax is specified.
      IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE') THEN
         line_discount_amount_   := ROUND(total_gross_amount_ * (discount_ / 100), currency_rounding_);
      ELSE
         line_discount_amount_   := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, line_no_, rel_no_, line_item_no_,
                                                                                    rec_.qty_expected, price_conv_factor_,  currency_rounding_);
      END IF;
      
      add_disc_amt_           := ROUND(((total_gross_amount_ - line_discount_amount_) * additional_discount_/100 ), currency_rounding_);
      order_discount_amount_  := ROUND((total_gross_amount_ - line_discount_amount_) * (order_discount_ / 100), currency_rounding_);
      total_gross_amount_     := ROUND(total_gross_amount_, currency_rounding_);
      net_curr_amount_        := total_gross_amount_ - line_discount_amount_ - order_discount_amount_ - add_disc_amt_;
      delivery_confirmed_amt_ := ROUND((net_curr_amount_ * currency_rate_), rounding_);    
   END IF;
   RETURN delivery_confirmed_amt_;

END Get_Expected_Invoice_Value;


-- Get_Max_Delivery_Confirm_Date
--   Returns the value of latest_delivery_date of an invoice.
@UncheckedAccess
FUNCTION Get_Max_Delivery_Confirm_Date (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN DATE
IS
   latest_del_date_    DATE;

   CURSOR get_latest_del_date IS
      SELECT MAX(date_cogs_posted)
        FROM outstanding_sales_tab
       WHERE invoice_id = invoice_id_
         AND company = company_ ;

BEGIN
   OPEN get_latest_del_date;
   FETCH get_latest_del_date INTO latest_del_date_;
   CLOSE get_latest_del_date;

   RETURN latest_del_date_;
END Get_Max_Delivery_Confirm_Date;


-- Get_Min_Outstanding_Sales_Id
--   Returns the value of the first outstanding_sales_id of an invoice.
@UncheckedAccess
FUNCTION Get_Min_Outstanding_Sales_Id (
   company_    IN VARCHAR2,
   invoice_id_ IN NUMBER ) RETURN NUMBER
IS
   outstanding_sales_id_    NUMBER;

   CURSOR get_sales_id IS
      SELECT MIN(outstanding_sales_id)
        FROM OUTSTANDING_SALES_TAB
       WHERE invoice_id = invoice_id_
         AND company = company_ ;

BEGIN
   OPEN get_sales_id;
   FETCH get_sales_id INTO outstanding_sales_id_;
   CLOSE get_sales_id;

   RETURN outstanding_sales_id_;
END Get_Min_Outstanding_Sales_Id;


-- Check_Remove
--   Checks if records exist for CO Invoice Item. If found, print an error message.
--   Used for restricted delete check when removing a Invoice Item (INVOIC module).
PROCEDURE Check_Remove (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER )
IS
   count_ NUMBER := 0;
   
   CURSOR record_exist IS
      SELECT count(*)
      FROM   outstanding_sales_tab
      WHERE  company    = company_
      AND    invoice_id = invoice_id_
      AND    item_id    = item_id_;
BEGIN
   OPEN record_exist;
   FETCH record_exist INTO count_;
   CLOSE record_exist;
   
   IF (count_ > 0) THEN
      Error_SYS.Record_Constraint('InvoiceItem', Language_SYS.Translate_Lu_Prompt_(lu_name_), to_char(count_));
   END IF;
END Check_Remove;


@UncheckedAccess
FUNCTION Get_Unit_Cost_For_Inv_Item (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER,
   item_id_     IN NUMBER ) RETURN NUMBER
IS
   total_qty_ NUMBER := 0;
   total_cost_ NUMBER := 0;
   
   CURSOR get_deliveries IS
      SELECT qty_shipped, cost
        FROM OUTSTANDING_SALES_TAB
       WHERE company    = company_
       AND   invoice_id = invoice_id_
       AND   item_id    = item_id_; 
BEGIN
   FOR deliv_rec_ IN get_deliveries LOOP
     total_cost_ := total_cost_ +  deliv_rec_.cost*deliv_rec_.qty_shipped;
     total_qty_  := total_qty_ + deliv_rec_.qty_shipped;
   END LOOP;   

   IF (total_qty_ = 0) THEN
      RETURN 0;
   ELSE      
      RETURN (total_cost_/total_qty_);
   END IF;
END Get_Unit_Cost_For_Inv_Item;
