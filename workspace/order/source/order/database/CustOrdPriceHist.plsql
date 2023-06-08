-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdPriceHist
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210126  RavDlk  SC2020R1-12282, Removed unnecessary packing and unpacking of attrubute string in New 
--  160111  JeeJlk  Bug 125118, Modified Insert___ to assign hist_state column customer order line objstate value.
--  100519  KRPELK  Merge Rose Method Documentation.
--  090923  MaMalk  Removed method Remove.
--  ------------------------- 14.0.0 -----------------------------------------
--  060418  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060110  CsAmlk  Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050908  SaMelk  Remove SUBSTRB from code.
--  050815  MaMalk  Bug 52801, Modified a view comment in view CUST_ORD_PRICE_HIST to delete the price history
--  050815          when the order line gets deleted.
--  050527  MiKulk  Bug 51409, Modified the view comments to include M(mandatory) in CUST_ORD_PRICE_HIST.
--  050512  MiKulk  Bug 50947, Created this LU to log the Customer Order line Price Changes
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORD_PRICE_HIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Get_History_No__(newrec_.history_no, newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   IF newrec_.hist_state IS NULL THEN
      newrec_.hist_state := Customer_Order_Line_API.Get_Objstate(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Get_History_No__
--   Returns a History Number
PROCEDURE Get_History_No__ (
   history_no_         OUT VARCHAR2,
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER )
IS
   CURSOR get_history_no IS
      SELECT MAX(TO_NUMBER(history_no))
      FROM   CUST_ORD_PRICE_HIST_TAB
      WHERE  line_item_no = line_item_no_
      AND    rel_no = rel_no_
      AND    line_no = line_no_
      AND    order_no = order_no_;
BEGIN
   OPEN get_history_no;
   FETCH get_history_no INTO history_no_;
   IF (history_no_ IS NULL) THEN
      history_no_ := 1;
   ELSE
      history_no_ := TO_NUMBER(history_no_) +1;
   END IF;

   CLOSE get_history_no;
END Get_History_No__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   calc_price_per_curr_  IN NUMBER,
   calc_price_per_base_  IN NUMBER,
   price_difference_     IN NUMBER )
IS
   newrec_     CUST_ORD_PRICE_HIST_TAB%ROWTYPE;
   hist_state_ CUST_ORD_PRICE_HIST_TAB.hist_state%TYPE;
   ordrec_     Customer_Order_API.Public_Rec;
   linerec_    Customer_Order_Line_API.Public_Rec;

BEGIN
   hist_state_ := Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_);

   ordrec_ := Customer_Order_API.Get(order_no_);
   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- Standard Event Parameters
   newrec_.date_entered  := Site_API.Get_Site_Date(ordrec_.contract);
   newrec_.user_id       := Fnd_Session_API.Get_Fnd_User;

   -- Primary key for object
   newrec_.order_no     := order_no_;
   newrec_.line_no      := line_no_;
   newrec_.rel_no       := rel_no_;
   newrec_.line_item_no := line_item_no_;

   newrec_.company      := Site_API.Get_Company(ordrec_.contract);
   newrec_.contract     := ordrec_.contract;
   newrec_.customer_no  := ordrec_.customer_no;

   newrec_.catalog_no      := linerec_.catalog_no;
   newrec_.price_source    := linerec_.price_source;
   newrec_.price_source_id := NVL(linerec_.price_source_id, 0);

   newrec_.sales_price_group_id := Sales_Part_API.Get_Sales_Price_Group_Id(ordrec_.contract,linerec_.catalog_no);
   newrec_.catalog_group        := Sales_Part_API.Get_Catalog_Group(ordrec_.contract,linerec_.catalog_no);

   newrec_.buy_qty_due          := linerec_.buy_qty_due;
   newrec_.price_conv_factor    := linerec_.price_conv_factor;
   newrec_.sale_unit_price      := linerec_.sale_unit_price;
   newrec_.calc_price_per_curr  := calc_price_per_curr_;
   newrec_.base_sale_unit_price := linerec_.base_sale_unit_price;
   newrec_.calc_price_per_base  := calc_price_per_base_;
   newrec_.price_difference     := price_difference_;
   newrec_.hist_state           := hist_state_;
   New___(newrec_);

END New;



