-----------------------------------------------------------------------------
--
--  Logical unit: PegCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  161026  KiSalk Bug 132312, Modified 131977 correction not to give error on multiple peggings.
--  161014  Nilalk STRSC-4482, Modified Create_Po_Pegging__() to make sure the available quantity to peg does not get a negative value.
--  160524  LaThlk Bug 129161, Modified the Create_Po_Pegging__() by introducing an error message in order to avoid cancelled or closed
--  160524         purchase order lines being pegged into customer order lines.
--  141101  NWeelk Bug 119472, Added method Scrap_Return_Po_Peggings to be called from Purchase Order when a purchase order 
--  141101         pegged to a customer order line has been scraped or returned.
--  130708  ChJalk TIBE-1010, Removed global variables inst_PurchaseOrderLinePart_ and inst_shop_ord_.
--  130610  PraWlk Bug 110506, Moved views CUST_ORDER_PUR_ORDER_PEG and CUST_ORDER_SHOP_ORDER_PEG from this utility LU to  
--  130610         CustomerOrderPurOrder and CustomerOrderShopOrder LUs respectively to support custom fields in client.
--  130124  JoAnSe PCM-2056, Called Shop_Ord_API.Modify_Manual_Pegging from Modify_Co_So_Lines___
--  110809  NWeelk Bug 98371, Modified methods Create_Po_Pegging__ and Create_So_Pegging__ by checking the 
--  110809         customer order line objstate before creating the connection.
--  110127  NeKolk EANE-3744  added where clause to the View CUST_ORDER_PUR_ORDER_PEG,CUST_ORDER_SHOP_ORDER_PEG .
--  100518  KRPELK Merge Rose Method Documentation.
--  -------------------------------- Eagle ----------------------------------
--  081127  ThAylk Bug 77298, Modified procedures Modify_Po_Peg_Qty__ and Modify_So_Peg_Qty__.
--  081024  ChJalk Bug 77109, Modified the view CUST_ORDER_SHOP_ORDER_PEG to add condition cs.qty_on_order > 0.
--  070823  ChBalk Modified column names oe_state and oe_state_db to state and objstate 
--  070823         in CUST_ORDER_PUR_ORDER_PEG and CUST_ORDER_SHOP_ORDER_PEG. 
--  070221  MaMalk Bug 63007, Modified Adjust_Pegging to stop modifying qty_on_order when its already zero.
--  061125  ErSrlk Bug 59946, Modified the methods Create_Po_Pegging__ , Create_So_Pegging__ to validate the PO/SO demand code is 'IO'.
--  060412  RoJalk Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ---------------------------------------------
--  060124  JaJalk Added Assert safe annotation.
--  050922  NaLrlk Removed unused variables.
--  050823  RaSilk Added Customer order line status fields to views CUST_ORDER_PUR_ORDER_PEG and CUST_ORDER_SHOP_ORDER_PEG.
--  040224  IsWilk Removed SUBSTRB from the view for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  050628  SaLalk Added a condition on qty_on_order to WHERE clause in the CUST_ORDER_PUR_ORDER_PEG view.
--  030603  GeKalk Added new method Scrap_So_Peggings.
--  030409  AnJplk Modified according to code review results.
--  030403  PrTilk Made the procedures Modify_Po_Peg_Qty,Modify_So_Peg_Qty, Create_Po_Pegging,Create_SO_Pegging
--  030403         private and Modify_Co_Po_Lines, Modify_Co_So_Lines implementation.
--  030331  AnJplk Modified procedure Adjust_Pegging.
--  030331  PrTilk Added the purpose of the file.
--  030331  SudWlk Removed obsolete parameters from method call to Customer_Order_Pur_Order_API.New in method,
--  030331         Create_Po_Pegging.
--  030328  GeKaLk Renamed methods  Modify_Po_Qty_On_Order and Modify_So_Qty_On_Order
--                 as CreatePoPegging and CreateSOPegging .
--  030327  GeKaLk Modified method Modify_Co_So_Lines.
--  030327  AnJplk Modified procedure Adjust_Pegging.
--  030326  GeKaLk Modified method Modify_Co_So_Lines,Modify_Co_Po_Lines to add CO line history record.
--  030326  SudWLk Modified method Modify_So_Qty_On_Order, where the order line history is created.
--  030324  AnJplk Added new Procedure Adjust_Pegging.
--  030324  GeKaLk Modified method Modify_Co_So_Lines.
--  030321  SudWLk Modified method Modify_Po_Qty_On_Order, where the order line history is created.
--  030320  GeKaLk Modified method Modify_So_Qty_On_Order.
--  030320  PrTilk Added new methods Modify_Co_Po_Lines, Modify_Co_So_Lines, Modify_So_Qty_On_Order
--  030320  GeKaLk Added a new public method Modify_Po_Qty_On_Order.
--  030319  AnJplk Added new view CUST_ORDER_SHOP_ORDER_PEG.
--  030319  ViPalk Added new view CUST_ORDER_PUR_ORDER_PEG.
--  030319  PrTilk Created. Added Methods Modify_Po_Peg_Qty,Modify_So_Peg_Qt
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Co_Po_Lines___
--   Modifies the related customer order and the purchase order lines when
--   qty on order is changed.
--   i.e. Modify the qty_on_order column of customer_order_line_tab and
--   purchase_order_line_tab when changing the pegged qty of mannual pegging.
PROCEDURE Modify_Co_Po_Lines___ (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   peg_qty_             NUMBER;
   msg_                 VARCHAR2(200);
BEGIN
   
   --Note: Fetch the existing pegged quantity of the customer order line
   peg_qty_ := Customer_Order_Line_API.Get_Qty_On_Order(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);

   -- Note:update the customer order line with new qty_on_order value.
   Customer_Order_line_API.Modify_Qty_On_Order(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                                               (peg_qty_ + qty_on_order_));

   -- Note:Create customer order line history record
   msg_ := Language_SYS.Translate_Constant(lu_name_, 'MANPEGHIST: Pegged quantity changed from :P1 to :P2', NULL, to_char(peg_qty_), to_char(peg_qty_ + qty_on_order_));
   Customer_Order_Line_Hist_API.NEW(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, msg_);

   -- Note: update the purchase order line with new qty_on_order value.
   $IF Component_Purch_SYS.INSTALLED $THEN
      Purchase_Order_Line_Part_API.Modify_Qty_On_Order(po_order_no_, po_line_no_, po_rel_no_, (Purchase_Order_Line_Part_API.Get_Qty_On_Order(po_order_no_, po_line_no_, po_rel_no_) + qty_on_order_));       
   $END
END Modify_Co_Po_Lines___;


-- Modify_Co_So_Lines___
--   Modifies the related customer order and the shop order lines when qty on
--   order is changed. i.e. Modify the qty_on_order column of customer_order_line_tab
--   and shop_ord_tab when changing the pegged qty of mannual pegging.
PROCEDURE Modify_Co_So_Lines___ (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_line_no_      IN VARCHAR2,
   so_rel_no_       IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   peg_qty_             NUMBER;
   msg_                 VARCHAR2(200);
BEGIN
   -- Note: Fetch the peviously pegged quantity of the customer order line
   peg_qty_ := Customer_Order_Line_API.Get_Qty_On_Order(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);
   -- Note: update the customer order line with new qty_on_order value.
   Customer_Order_line_API.Modify_Qty_On_Order(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,(peg_qty_ + qty_on_order_));
   -- Note: Create customer order line history record
   msg_ := Language_SYS.Translate_Constant(lu_name_, 'MANPEGHIST: Pegged quantity changed from :P1 to :P2', NULL, to_char(peg_qty_), to_char(peg_qty_ + qty_on_order_));
   Customer_Order_Line_Hist_API.New(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, msg_);
   -- Update the shop order line with new qty_on_order value.
   $IF Component_Shpord_SYS.INSTALLED $THEN     
      Shop_Ord_API.Modify_Manual_Pegging(so_order_no_, so_line_no_, so_rel_no_, qty_on_order_, Order_Type_API.DB_CUSTOMER_ORDER, oe_order_no_, NULL, NULL);
   $ELSE
      NULL;
   $END
END Modify_Co_So_Lines___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Modify_Po_Peg_Qty__
--   Modify the qty_on_order column of customer_order_pur_order_tab, customer_order_line_tab
--   and purchase_order_line_tab when changing the pegged qty of mannual pegging.
PROCEDURE Modify_Po_Peg_Qty__ (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   attr_                VARCHAR2(2000);
   new_qty_on_order_    NUMBER;
   qty_diff_            NUMBER;
   corec_               Customer_Order_Line_API.Public_Rec;
BEGIN
   IF (qty_on_order_ IS NULL) THEN
      new_qty_on_order_ := 0;
   ELSE
      new_qty_on_order_ := qty_on_order_;
   END IF;
   -- Note: Calculate the diffference of qty_on_order.
   qty_diff_ := NVL(qty_on_order_,0) - NVL(Customer_Order_Pur_Order_API.Get_Qty_On_Order(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, po_order_no_, po_line_no_, po_rel_no_),0);
   corec_ := Customer_Order_Line_API.Get(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);
   IF ((new_qty_on_order_ = 0) AND (corec_.supply_code = 'IO') AND (Customer_Order_Line_API.Get_Objstate(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_) = 'Released')) THEN
      --If the new value for qty_on_order is zero, supply code is Inventory Order and CO is in Planned state, the record should be removed.
      Customer_Order_Pur_Order_API.Remove_Line(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, 
                                               po_order_no_, po_line_no_, po_rel_no_);
   ELSE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', new_qty_on_order_, attr_);
      Customer_Order_Pur_Order_API.Modify(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                                           po_order_no_, po_line_no_, po_rel_no_,attr_);
   END IF;
   Modify_Co_Po_Lines___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, po_order_no_,
                      po_line_no_, po_rel_no_, qty_diff_);
END Modify_Po_Peg_Qty__;


-- Modify_So_Peg_Qty__
--   Modify the qty_on_order column of customer_order_shop_order_tab,
--   customer_order_line_tab and shop_ord_tab when changing the pegged
--   qty of mannual pegging.
PROCEDURE Modify_So_Peg_Qty__ (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_line_no_      IN VARCHAR2,
   so_rel_no_       IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   attr_                VARCHAR2(2000);
   new_qty_on_order_    NUMBER;
   qty_diff_            NUMBER;
   corec_               Customer_Order_Line_API.Public_Rec;
BEGIN
   IF (qty_on_order_ IS NULL) THEN
      new_qty_on_order_ := 0;
   ELSE
      new_qty_on_order_ := qty_on_order_;
   END IF;

   -- Note: Calculate the diffference of qty_on_order.
   qty_diff_ := NVL(qty_on_order_, 0) - NVL(Customer_Order_Shop_Order_API.Get_Qty_On_Order(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, so_order_no_, so_line_no_, so_rel_no_), 0);
   corec_ := Customer_Order_Line_API.Get(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);
   IF ((new_qty_on_order_ = 0) AND (corec_.supply_code = 'IO') AND (Customer_Order_Line_API.Get_Objstate(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_) = 'Released')) THEN
      --If the new value for qty_on_order is zero, supply code is Inventory Order and CO is in Planned state, the record should be removed.
      Customer_Order_Shop_Order_API.Remove(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, so_order_no_, so_line_no_, so_rel_no_);
   ELSIF ((new_qty_on_order_ = 0) AND (corec_.supply_code = 'SO')) THEN
      Error_SYS.Record_General(lu_name_, 'PEGSOQTYNOTZERO: Pegged quantity may not be 0 for a customer order line with supply code ":P1", instead use the Unpeg function.', Order_Supply_Type_API.Decode(corec_.supply_code));
   ELSE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', new_qty_on_order_, attr_);
      Customer_Order_Shop_Order_API.Modify(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, so_order_no_, so_line_no_, so_rel_no_, attr_);
   END IF;
   Modify_Co_So_Lines___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, so_order_no_, so_line_no_, so_rel_no_, qty_diff_);
END Modify_So_Peg_Qty__;


-- Create_Po_Pegging__
--   Create/Modify the record in the connection tab and modifies the Qty On Order
--   of PO Line when a purchase order is pegged.
PROCEDURE Create_Po_Pegging__ (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   qty_diff_             NUMBER;
   order_rec_            CUSTOMER_ORDER_LINE_API.Public_Rec;
   peggable_qty_         NUMBER;
   demand_code_db_       CUSTOMER_ORDER_LINE_TAB.demand_code%TYPE;
   available_qty_to_peg_ NUMBER;
BEGIN
   order_rec_ := Customer_Order_Line_API.Get(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);
   peggable_qty_ := (order_rec_.revised_qty_due - ( order_rec_.qty_assigned + order_rec_.qty_shipped ));

   -- Note: Calculate the diffference of qty_on_order.
   qty_diff_ := NVL(qty_on_order_,0) - NVL(Customer_Order_Pur_Order_API.Get_Qty_On_Order(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, po_order_no_, po_line_no_, po_rel_no_),0);

   IF((qty_diff_ + order_rec_.qty_on_order)  > peggable_qty_ ) THEN
      Error_SYS.Record_General(lu_name_, 'QTYONORD: Total Quantity Pegged may not be greater than :P1.',P1_ => peggable_qty_);
   END IF;
      
   $IF Component_Purch_SYS.INSTALLED $THEN   
      demand_code_db_ := Purchase_Order_Line_Part_API.Get_Demand_Code_Db(po_order_no_ , po_line_no_, po_rel_no_);
      IF (order_rec_.demand_code != 'RCO' AND demand_code_db_ != 'IO') OR (order_rec_.demand_code = 'RCO' AND demand_code_db_ NOT IN ('IO', 'RPO')) THEN
         Error_Sys.Record_Modified(lu_name_);
      END IF;
      IF(Purchase_Order_Line_Part_API.Get_Objstate(po_order_no_, po_line_no_, po_rel_no_) IN ('Cancelled', 'Closed')) THEN
         Error_Sys.Record_General(lu_name_, 'CACLPOCO: Cancelled or closed purchase orders cannot be pegged into customer orders.');
      END IF;
   $END
   
   IF (Customer_Order_Pur_Order_API.Check_Exist(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, po_order_no_, po_line_no_, po_rel_no_) = 'TRUE') THEN
      -- Note: If record exist then modify the record.
      Modify_Po_Peg_Qty__(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,po_order_no_, po_line_no_, po_rel_no_, qty_on_order_);
   ELSE
      -- Note: If no record exist then create the connection.
      IF (qty_on_order_ > 0) AND (Customer_Order_Line_API.Get_Objstate(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_) != 'Cancelled') THEN
         Customer_Order_Pur_Order_API.New(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,po_order_no_, po_line_no_, po_rel_no_,Purchase_Type_API.Decode('O'),qty_on_order_ ,NULL);
         Modify_Co_Po_Lines___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,po_order_no_, po_line_no_, po_rel_no_,qty_diff_);
      END IF;
   END IF;
   
   $IF Component_Purch_SYS.INSTALLED $THEN 
      available_qty_to_peg_ := Purchase_Order_Line_Part_API.Get_Due_In_Stores (po_order_no_, po_line_no_, po_rel_no_) 
                               - Purchase_Order_Line_Part_API.Get_Qty_On_Order (po_order_no_, po_line_no_, po_rel_no_);
      IF ( available_qty_to_peg_ < 0 ) THEN
         -- if available_qty_to_peg_ is a negative value, that means the PO line has been pegged in excess.
         -- Maximum possible quantity to peg is current pegging (qty_on_order_) added with negative difference(available_qty_to_peg_) 
         Error_SYS.Record_General(lu_name_, 'QTYONORD: Total Quantity Pegged may not be greater than :P1.',P1_ => available_qty_to_peg_ + qty_on_order_);
      END IF;
   $END
END Create_Po_Pegging__;


-- Create_So_Pegging__
--   Create/Modify the record in the connection tab and modifies the Qty On
--   Order of PO Line when a purchase order is pegged.
PROCEDURE Create_So_Pegging__ (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_line_no_      IN VARCHAR2,
   so_rel_no_       IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   qty_diff_            NUMBER;
   order_rec_           CUSTOMER_ORDER_LINE_API.Public_Rec;
   peggable_qty_        NUMBER;
   demand_code_db_      CUSTOMER_ORDER_LINE_TAB.demand_code%TYPE;
BEGIN
   order_rec_ := Customer_Order_Line_API.Get(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);
   peggable_qty_ := (order_rec_.revised_qty_due - ( order_rec_.qty_assigned + order_rec_.qty_shipped ));

   -- Note: Calculate the diffference of qty_on_order.
   qty_diff_ := NVL(qty_on_order_,0) - NVL(Customer_Order_Shop_Order_API.Get_Qty_On_Order(oe_order_no_, oe_line_no_,
                                          oe_rel_no_, oe_line_item_no_, so_order_no_, so_line_no_, so_rel_no_),0);

   IF((qty_diff_ + order_rec_.qty_on_order)  > peggable_qty_ ) THEN
      Error_SYS.Record_General(lu_name_, 'QTYONORD: Total Quantity Pegged may not be greater than :P1.',P1_ => peggable_qty_);
   END IF;

   $IF Component_Shpord_SYS.INSTALLED $THEN
      demand_code_db_ := Order_Supply_Type_API.Encode(Shop_Ord_API.Get_Demand_Code(so_order_no_, so_line_no_, so_rel_no_));                
   $END

   IF (Customer_Order_Shop_Order_API.Check_Exist(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, so_order_no_, so_line_no_, so_rel_no_) = 'TRUE') THEN
      -- Note: If record exist then modify the record.
      Modify_So_Peg_Qty__(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,so_order_no_, so_line_no_, so_rel_no_, qty_on_order_);
   ELSE
      -- Note: If no record exist then create the connection.
      IF (qty_on_order_ > 0 AND (Customer_Order_Line_API.Get_Objstate(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_) != 'Cancelled')) THEN
         Customer_Order_Shop_Order_API.New(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,so_order_no_, so_line_no_, so_rel_no_,qty_on_order_);
         Modify_Co_So_Lines___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,so_order_no_, so_line_no_, so_rel_no_,qty_diff_);
      END IF;
   END IF;
END Create_So_Pegging__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Adjust_Pegging
--   Adjust the pegging for a given CO Line by the amount QtyAdjust.
PROCEDURE Adjust_Pegging (
   pur_peggs_    IN NUMBER,
   shp_peggs_    IN NUMBER,
   qty_adjust_   IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS

   qty_to_adjust_ NUMBER;

   CURSOR get_peg_polines IS
      SELECT po_order_no, po_line_no, po_rel_no, qty_on_order
      FROM CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE oe_order_no= order_no_
      AND oe_line_no=line_no_
      AND oe_rel_no=rel_no_
      AND oe_line_item_no=line_item_no_ ;


   CURSOR get_peg_shporders IS
      SELECT so_order_no, so_release_no, so_sequence_no, qty_on_order
      FROM CUSTOMER_ORDER_SHOP_ORDER_TAB t
      WHERE oe_order_no= order_no_
      AND oe_line_no=line_no_
      AND oe_rel_no=rel_no_
      AND oe_line_item_no=line_item_no_ ;


BEGIN
   qty_to_adjust_:=qty_adjust_;
   
   -- Note: Check PO peggings exists
   IF  (pur_peggs_ !=0) THEN
      FOR po_peg_ IN get_peg_polines LOOP
         IF (po_peg_.qty_on_order != 0) THEN
            IF qty_to_adjust_>po_peg_.qty_on_order THEN
               Modify_Po_Peg_Qty__(order_no_,
                                line_no_,
                                rel_no_,
                                line_item_no_,
                                po_peg_.po_order_no,
                                po_peg_.po_line_no,
                                po_peg_.po_rel_no,
                                0);

               Cust_Order_Event_Creation_Api.Adjusted_Po_Pegging(order_no_,
                                                                 line_no_,
                                                                 rel_no_,
                                                                 line_item_no_,
                                                                 po_peg_.po_order_no,
                                                                 po_peg_.po_line_no,
                                                                 po_peg_.po_rel_no,
                                                                 0);
               qty_to_adjust_ := qty_to_adjust_ -  po_peg_.qty_on_order;

            ELSE

               Modify_Po_Peg_Qty__(order_no_,
                                 line_no_,
                                 rel_no_,
                                 line_item_no_,
                                 po_peg_.po_order_no,
                                 po_peg_.po_line_no,
                                 po_peg_.po_rel_no,
                                 po_peg_.qty_on_order - qty_to_adjust_);

           
              Cust_Order_Event_Creation_Api.Adjusted_Po_Pegging(order_no_,
                                                                 line_no_,
                                                                 rel_no_,
                                                                 line_item_no_,
                                                                 po_peg_.po_order_no,
                                                                 po_peg_.po_line_no,
                                                                 po_peg_.po_rel_no,
                                                                 po_peg_.qty_on_order - qty_to_adjust_);
               qty_to_adjust_:=0;
               EXIT;

            END IF;
         END IF;   
      END LOOP;
   END IF;

    -- Note: Check SO peggings exists
   IF (shp_peggs_ !=0)AND (qty_to_adjust_>0) THEN
      FOR so_peg_ IN get_peg_shporders LOOP
         IF (so_peg_.qty_on_order != 0) THEN 
            IF qty_to_adjust_>so_peg_.qty_on_order THEN

               Modify_So_Peg_Qty__(order_no_,
                                 line_no_,
                                 rel_no_,
                                 line_item_no_,
                                 so_peg_.so_order_no,
                                 so_peg_.so_release_no,
                                 so_peg_.so_sequence_no,
                                 0);
        
               Cust_Order_Event_Creation_Api.Adjusted_So_Pegging(order_no_,
                                                                 line_no_,
                                                                 rel_no_,
                                                                 line_item_no_,
                                                                 so_peg_.so_order_no,
                                                                 so_peg_.so_release_no,
                                                                 so_peg_.so_sequence_no,
                                                                 0);
               qty_to_adjust_ := qty_to_adjust_ -  so_peg_.qty_on_order;

            ELSE
               Modify_So_Peg_Qty__(order_no_,
                                line_no_,
                                rel_no_,
                                line_item_no_,
                                so_peg_.so_order_no,
                                so_peg_.so_release_no,
                                so_peg_.so_sequence_no,
                                so_peg_.qty_on_order - qty_to_adjust_);
        
              Cust_Order_Event_Creation_Api.Adjusted_So_Pegging(order_no_,
                                                                 line_no_,
                                                                 rel_no_,
                                                                 line_item_no_,
                                                                 so_peg_.so_order_no,
                                                                 so_peg_.so_release_no,
                                                                 so_peg_.so_sequence_no,
                                                                 so_peg_.qty_on_order - qty_to_adjust_);
               qty_to_adjust_:=0;
               EXIT;

            END IF;
         END IF;   
      END LOOP;
   END IF;
END Adjust_Pegging;


-- Scrap_So_Peggings
--   To be called from Shop Order when a shop order pegged for a customer
--   order line has been scraped. This method will reduce peggings in
--   corresponding Customer Order lines.
PROCEDURE Scrap_So_Peggings (
   co_reduced_qty_   OUT NUMBER,
   order_no_         IN VARCHAR2,
   release_no_       IN VARCHAR2,
   sequence_no_      IN VARCHAR2,
   scrap_qty_        IN NUMBER )
IS
   CURSOR demand_rec IS
          SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, cos.qty_on_order
          FROM customer_order_line_tab col,customer_order_shop_order_tab cos
          WHERE col.order_no = cos.oe_order_no
          AND col.line_no = cos.oe_line_no
          AND col.rel_no = cos.oe_rel_no
          AND col.line_item_no = cos.oe_line_item_no
          AND cos.so_order_no = order_no_
          AND cos.so_release_no = release_no_
          AND cos.so_sequence_no =  sequence_no_
          ORDER BY col.planned_delivery_date;
 
   line_rec_         Customer_Order_Line_API.Public_Rec;
   qty_on_order_     NUMBER;
   con_qty_on_order_ NUMBER;
   rem_qty_          NUMBER;
   temp_qty_         NUMBER;
   attr_             VARCHAR2(32000);
BEGIN
 
   co_reduced_qty_ := 0;
   FOR rec_ IN demand_rec LOOP
      line_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      rem_qty_ := scrap_qty_ - co_reduced_qty_;
      IF co_reduced_qty_ <= scrap_qty_ THEN
         temp_qty_ := least(rec_.qty_on_order, (scrap_qty_-co_reduced_qty_));
         qty_on_order_ := line_rec_.qty_on_order - temp_qty_;         
 
         co_reduced_qty_ := co_reduced_qty_ + temp_qty_;
         con_qty_on_order_ := rec_.qty_on_order - temp_qty_;         
 
         Customer_Order_Line_API.Modify_Qty_On_Order(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, qty_on_order_);
         
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('QTY_ON_ORDER',con_qty_on_order_, attr_);
         Customer_Order_Shop_Order_API.Modify(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                              order_no_, release_no_, sequence_no_, attr_);
      END IF;
   END LOOP;
 
END Scrap_So_Peggings;

-----------------------------------------------------------------------------------
-- Scrap_Return_Po_Peggings
--    To be called from Purchase Order when a purchase order pegged to a customer
--    order line has been scraped or returned. This method will reduce peggings in
--    the corresponding Customer Order lines.
-----------------------------------------------------------------------------------
PROCEDURE Scrap_Return_Po_Peggings (
   info_            OUT VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   qty_to_reduce_    IN NUMBER )
IS
   CURSOR demand_rec IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, col.qty_on_order col_qty_on_order, cop.qty_on_order cop_qty_on_order
      FROM customer_order_line_tab col,customer_order_pur_order_tab cop
      WHERE col.order_no = cop.oe_order_no
      AND   col.line_no = cop.oe_line_no
      AND   col.rel_no = cop.oe_rel_no
      AND   col.line_item_no = cop.oe_line_item_no
      AND   cop.po_order_no = order_no_
      AND   cop.po_line_no = line_no_
      AND   cop.po_rel_no = release_no_;
          
   qty_on_order_     NUMBER;   
   con_qty_on_order_ NUMBER;
   attr_             VARCHAR2(32000);
BEGIN
   FOR rec_ IN demand_rec LOOP
      info_ := Client_SYS.Get_All_Info;      
      qty_on_order_ := rec_.col_qty_on_order - qty_to_reduce_;         
      Customer_Order_Line_API.Modify_Qty_On_Order(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, qty_on_order_);
      Client_SYS.Clear_Attr(attr_);
      con_qty_on_order_ := rec_.cop_qty_on_order - qty_to_reduce_;
      Client_SYS.Add_To_Attr('QTY_ON_ORDER', con_qty_on_order_, attr_);
      Customer_Order_Pur_Order_API.Modify(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                                          order_no_, line_no_, release_no_, attr_);
   END LOOP; 
END Scrap_Return_Po_Peggings;


