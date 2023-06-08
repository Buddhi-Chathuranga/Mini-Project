-----------------------------------------------------------------------------
--
--  Logical unit: CleanupCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211229  Kabnlk  CRM21R2-720, Added parameter 'FALSE' for 3rd party filter in Business_Object_Contact_API.Remove
--  201218  KiSalk   Bug 156769(SCZ-12916), Removed representatives and contacts in Clear_Header_Records___.
--  201014  ThKrlk   SCZ-11688, Modified Clear_Line_Records___() to check whether all the components are cancelled or closed before it removes accounting id from the order line.
--  200731  KiSalk   Bug 155034(SCZ-10932), Modified Clear_Charge_Records___ calling Source_Tax_Item_Order_API.Cleanup_Tax_Items so that records are deleted
--  200731           without validations and moved calling it before deleting CUSTOMER_ORDER_TAB records in Clear_Header_Records___.
--  160608  MaIklk   LIM-7442, Deleting of delivery note records will be handled using a function call.
--  111101  Darklk   Bug 99278, Modified the procedures Clear_Header_Records___ and Clear_Line_Records___ to remove the pre-accounting record
--  111101           associate with the CO and with the CO lines.
--  100903  AmPalk   Bug 92805, Modified Cleanup_Routine_Impl__ to set flags TRUE to proceed, only if the passed in client value is TRUE.
--  100512  Ajpelk   Merge rose method documentation
--  ------------------------------Eagle--------------------------------------------
--  080624  DaZase   Bug 72596, renamed method from Cleanup_Routine__ to Cleanup_Routine_Impl__, added new Cleanup_Routine__ method.
--  071119  RaKalk   Bug 68189, Changed the correction to not to delete the order/order line if there are open commissions.
--  071119           Defined exception abort_deletion_. Modified Clear_Lines_With_Status___, Clear_Headers_With_Status___,
--  071119           Clear_Line_Records___ and Cleanup_Routine__ methods.
--  071101  RaKalk   Bug 68189, Added CUSTOMER_ORDER_ADDRESS_TAB, STAGED_BILLING_TEMPLATE_TAB, CUSTOMER_ORDER_SHORTAGE_TAB,
--  071101           CUST_ORDER_LINE_DISCOUNT_TAB, ORDER_LINE_COMMISSION_TAB, CUST_ORDER_LINE_TAX_LINES_TAB, CUST_ORDER_LINE_ADDRESS_TAB,
--  071101           CUST_ORDER_LINE_SOURCE_SET_TAB, CO_SUPPLY_SITE_RESERVATION_TAB, CUSTOMER_ORDER_MILESTONE_TAB, SOURCED_CUST_ORDER_LINE_TAB,
--  071101           SOURCED_CO_SUPPLY_SITE_RES_TAB, CUST_ORD_CHARGE_TAX_LINES_TAB tables to the cleanup script.
--  071101           Added procedures Clear_Charge_Lines___, Clear_Header_Records___, Clear_Line_Records___
--  071101           Modified procedures Clear_Lines_With_Status___ and Clear_Headers_With_Status___. 
--  070913  NaLrlk   Modified the cursor select_affected_orders in the method Cleanup_Routine__.
--  070424  AmPalK   Made changes to remove relevant records in CUSTOMER_ORDER_DELIV_NOTE_TAB when cleaning the customer orders.
--  060522  PrPrlK   Bug 54753, Modified the cursors in methods Clear_Headers_With_Status___ and Clear_Lines_With_Status___.
--  ---------------------13.4.0------------------------------------------------
--  060209  IsAnlk   Modified Cleanup_Routine__ to exclude Distribution Orders.
--  060131  JaBalk   Added NVL to select the Cancelled orders in Clear_Headers_With_Status___, Clear_Lines_With_Status___.
--  051025  Sujalk   Modifoed the reference of the select_affected_orders cusror.
--  050929  Sujalk   Changed the reference of the select_affected_orders cursor to user_allowed_site_pub
--  050920  SaMelk   Removed the unused variable invoice_exists_ from the method 'Clear_Headers_With_Status___'.
--  050513  ChJalk   Bug 51194, Modified Methods Clear_Lines_With_Status___ and Clear_Headers_With_Status___ to remove document texts.
--  050509  MiKulk   Bug 50947, Modified the method Clear_Line_History___, to clear the data from the CUST_ORD_PRICE_HIST_TAB.
--  050429  JoEd     Added cleanup of CUST_DELIVERY_INV_REF_TAB and OUTSTANDING_SALES_TAB.
--  050415  JaBalk   Modified Cleanup_Routine__ to calculate before_date_ if number_of_days_ is not null.
--  050323  IsWilk   Modified the PROCEDURE Validate_Params.
--  050322  IsWilk   Modified the PROCEDURE Validate_Params.
--  050314  IsWilk   Added PROCEDURE Validate_Params and modified PROCEDURE Cleanup_Routine__.
--  050215  JICE     Bug 49626, added parameter for cancel_reason when cleaning up orders and order lines.
--  040908  IsWilk   Removed the PROCEDURE Batch_Cleanup_Routine__.
--  040409  JaJalk   Removed the method Schedule_Cleanup_Routine__ since it is no longer used with the new scheduling functionality.
--  ------------------------------------ 13.3.0 -----------------------------
--  030912  MiKulk   Bug 37284, Modified the methods Clear_Headers_With_Status___, and Clear_Lines_With_Status___
--  030912           so that it will clear the headers and lines where invoices doesn't exist, but the status is Invoiced.
--  030804  ChFolk   Performed SP4 Merge. (SP4Only)
--  021226  AnJplk   Bug 34993, Modified cursor definitions in Clear_Lines_With_Status___ and
--                   Clear_Headers_With_Status___ . Bug 34953 is also included.
--  011009  JeLise   Bug fix 25073, Added removal of CUSTOMER_ORDER_CHARGE_TAB in
--                   Clear_Headers_With_Status___ and Clear_Lines_With_Status___.
--  011004  JeLise   Bug fix 23332, Added cursor invoice_status1 in Clear_Headers_With_Status___
--                   and Clear_Lines_With_Status___.
--  011002  JeLise   Bug fix 23332, Added cursor invoice_status in Clear_Lines_With_Status___ too.
--  010829  JeLise   Bug fix 23332, Added cursor invoice_status in Clear_Headers_With_Status___.
--  000616  DaZa     Bug fix 16523, made changes in Clear_Header_History___ and Clear_Line_History___
--                   so only orders/orderrows with status Invoiced or Cancelled are removed. Also
--                   made change in Clear_Headers_With_Status___ so we make a delete on order head
--                   history directly instead of calling Clear_Header_History___.
--  000222  PaLj     Added removal of ORDER_LINE_STAGED_BILLING_TAB in Clear_Lines_With_Status___
--  000117  JoEd     Bug fix 13131. Added method Clear_Headers_With_Status___
--                   to remove CO headers and all their lines.
--  ---------------------- 12.0 ---------------------------------------------
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990531  RaKu     CID 19093. Variable new_message_ was to short in Schedule_Cleanup_Routine__.
--  990208  RaKu     Added User_Allowed_Site-check in Cleanup_Routine__.
--  990129  RaKu     Added contract in the select criteria in Cleanup_Routine__.
--  990122  RaKu     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

abort_deletion_   EXCEPTION;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Clear_Header_History___
--   Removes header history for specified order.
PROCEDURE Clear_Header_History___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   DELETE
   FROM  CUSTOMER_ORDER_HISTORY_TAB
   WHERE order_no = order_no_
   AND exists (SELECT 1
               FROM   CUSTOMER_ORDER_TAB
               WHERE  order_no = order_no_
               AND    rowstate IN ('Cancelled', 'Invoiced'));

   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;
END Clear_Header_History___;


-- Clear_Line_History___
--   Removes order line history for specified order.
PROCEDURE Clear_Line_History___ (
   order_no_ IN VARCHAR2 )
IS
   CURSOR obsolete_history_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  rowstate IN ('Cancelled', 'Invoiced')
      AND    order_no = order_no_;
BEGIN
   FOR rec_ IN obsolete_history_lines LOOP
      DELETE
      FROM  CUSTOMER_ORDER_LINE_HIST_TAB
      WHERE order_no = order_no_
      AND   line_no = rec_.line_no
      AND   rel_no = rec_.rel_no
      AND   line_item_no = rec_.line_item_no;

      DELETE
      FROM  cust_ord_price_hist_tab
      WHERE order_no = order_no_
      AND   line_no = rec_.line_no
      AND   rel_no = rec_.rel_no
      AND   line_item_no = rec_.line_item_no;
   END LOOP;

   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;
END Clear_Line_History___;


-- Clear_Reservations___
--   Removes order line reservations for specified order.
PROCEDURE Clear_Reservations___ (
   order_no_ IN VARCHAR2 )
IS
   CURSOR obsolete_reservations IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  rowstate IN ('Cancelled', 'Invoiced')
      AND    order_no = order_no_;
BEGIN
   FOR rec_ IN obsolete_reservations LOOP
      DELETE
      FROM  CUSTOMER_ORDER_RESERVATION_TAB
      WHERE order_no = order_no_
      AND   line_no = rec_.line_no
      AND   rel_no = rec_.rel_no
      AND   line_item_no = rec_.line_item_no;
   END LOOP;

   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;
END Clear_Reservations___;


-- Clear_Deliveries___
--   Removes order line deliveies for specified order.
PROCEDURE Clear_Deliveries___ (
   order_no_ IN VARCHAR2 )
IS
   CURSOR obsolete_deliveries IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  rowstate IN ('Cancelled', 'Invoiced')
      AND    order_no = order_no_;
BEGIN
   FOR rec_ IN obsolete_deliveries LOOP

      -- cross reference delivery <-> invoice
      DELETE
      FROM CUST_DELIVERY_INV_REF_TAB
      WHERE deliv_no IN (SELECT deliv_no
                         FROM CUSTOMER_ORDER_DELIVERY_TAB
                         WHERE order_no = order_no_
                         AND line_no = rec_.line_no
                         AND rel_no = rec_.line_no
                         AND line_item_no = rec_.line_item_no);

      DELETE
      FROM OUTSTANDING_SALES_TAB
      WHERE deliv_no IN (SELECT deliv_no
                         FROM CUSTOMER_ORDER_DELIVERY_TAB
                         WHERE order_no = order_no_
                         AND line_no = rec_.line_no
                         AND rel_no = rec_.line_no
                         AND line_item_no = rec_.line_item_no);

      DELETE
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no = rec_.line_no
      AND   rel_no = rec_.rel_no
      AND   line_item_no = rec_.line_item_no;

   END LOOP;

   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;
END Clear_Deliveries___;


-- Clear_Lines_With_Status___
--   Removes order lines with specified status and order number.
--   Order Line history, reservations and deliveries are also removed.
PROCEDURE Clear_Lines_With_Status___ (
   order_no_ IN VARCHAR2,
   objstate_ IN VARCHAR2,
   reason_   IN VARCHAR2 )
IS
   temp_   NUMBER;
   invoice_exists_ BOOLEAN;
   invoice_status_ BOOLEAN;

   CURSOR select_lines_with_status IS
      SELECT line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  ((reason_ IS NULL AND cancel_reason IS NULL) OR (reason_ IS NOT NULL AND NVL(cancel_reason,'%') LIKE reason_))
      AND    rowstate = objstate_
      AND    order_no = order_no_;

   CURSOR invoice_status1(rec_order_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_inv_item i, customer_order_inv_head ih
      WHERE  i.invoice_id = ih.invoice_id
      AND    i.company = ih.company
      AND    i.order_no = rec_order_no_
      AND    ih.objstate IN ('Printed','Preliminary');

   CURSOR invoice_status(rec_order_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_inv_item i, customer_order_inv_head ih
      WHERE  i.invoice_id = ih.invoice_id
      AND    i.company = ih.company
      AND    order_no = rec_order_no_
      AND    ih.objstate IN ('PostedAuth','PartlyPaidPosted','PaidPosted');

   CURSOR invoice_exists(rec_order_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_inv_item
      WHERE  order_no = rec_order_no_;

BEGIN
   FOR rec_ IN select_lines_with_status LOOP
      BEGIN
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         SAVEPOINT start_cleanup_order_line_;

         IF (objstate_ = 'Invoiced') THEN
   
            OPEN invoice_exists(order_no_);
            FETCH invoice_exists INTO temp_;
            invoice_exists_ := invoice_exists%FOUND;
            CLOSE invoice_exists;
   
            IF (invoice_exists_) THEN
   
               OPEN invoice_status1(order_no_);
               FETCH invoice_status1 INTO temp_;
               invoice_status_ := invoice_status1%FOUND;
               CLOSE invoice_status1;
   
               IF (NOT invoice_status_) THEN
   
                  OPEN invoice_status(order_no_);
                  FETCH invoice_status INTO temp_;
                  invoice_status_ := invoice_status%FOUND;
                  CLOSE invoice_status;
   
                  IF (invoice_status_) THEN
                     -- cross reference delivery <-> invoice
                     DELETE
                     FROM CUST_DELIVERY_INV_REF_TAB
                     WHERE deliv_no IN (SELECT deliv_no
                                        FROM CUSTOMER_ORDER_DELIVERY_TAB
                                        WHERE order_no = order_no_
                                        AND line_no = rec_.line_no
                                        AND rel_no = rec_.rel_no
                                        AND line_item_no = rec_.line_item_no);
                     
                     Clear_Line_Records___(order_no_,
                                           rec_.line_no,
                                           rec_.rel_no,
                                           rec_.line_item_no);
                     
                  END IF;
               END IF;
            ELSE -- invoice_exists%NOTFOUND
               -- Cleanup the customer order lines which are Invoiced, but no invoices exists.
               Clear_Line_Records___(order_no_,
                                     rec_.line_no,
                                     rec_.rel_no,
                                     rec_.line_item_no);
               
   
            END IF;
         ELSE -- Cancelled
            -- cross reference delivery <-> invoice
            DELETE
            FROM CUST_DELIVERY_INV_REF_TAB
            WHERE deliv_no IN (SELECT deliv_no
                               FROM CUSTOMER_ORDER_DELIVERY_TAB
                               WHERE order_no = order_no_
                               AND line_no = rec_.line_no
                               AND rel_no = rec_.rel_no
                               AND line_item_no = rec_.line_item_no);

            Clear_Line_Records___(order_no_,
                                  rec_.line_no,
                                  rec_.rel_no,
                                  rec_.line_item_no);
   
         END IF;

      EXCEPTION
         WHEN abort_deletion_ THEN
            @ApproveTransactionStatement(2012-01-24,GanNLK)
            ROLLBACK TO SAVEPOINT start_cleanup_order_line_;
      END;
   END LOOP;
   
END Clear_Lines_With_Status___;


-- Clear_Headers_With_Status___
--   Removes order headers with specified status and order number.
--   Order history, Order Lines, Order line history, reservations and
--   deliveries are also removed.
PROCEDURE Clear_Headers_With_Status___ (
   order_no_ IN VARCHAR2,
   objstate_ IN VARCHAR2,
   reason_   IN VARCHAR2 )
IS
   temp_             NUMBER;
   invoice_status_   BOOLEAN;
   invoice_exists_   BOOLEAN;

   CURSOR select_headers_with_status IS
      SELECT order_no
      FROM   customer_order_tab
      WHERE  ((reason_ IS NULL AND cancel_reason IS NULL) OR (reason_ IS NOT NULL AND NVL(cancel_reason,'%') LIKE reason_))
      AND    rowstate = objstate_
      AND    order_no = order_no_;

   CURSOR invoice_status1(rec_order_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_inv_item i, customer_order_inv_head ih
      WHERE  i.invoice_id = ih.invoice_id
      AND    i.company = ih.company
      AND    i.order_no = rec_order_no_
      AND    ih.objstate IN ('Printed','Preliminary');

   CURSOR invoice_status(rec_order_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_inv_item i, customer_order_inv_head ih
      WHERE  i.invoice_id = ih.invoice_id
      AND    i.company = ih.company
      AND    order_no = rec_order_no_
      AND    ih.objstate IN ('PostedAuth','PartlyPaidPosted','PaidPosted');

   CURSOR invoice_exists(rec_order_no_ IN VARCHAR2) IS
      SELECT 1
      FROM   customer_order_inv_item
      WHERE  order_no = rec_order_no_;

BEGIN
   @ApproveTransactionStatement(2012-01-24,GanNLK)
   SAVEPOINT start_cleanup_order_;

   FOR rec_ IN select_headers_with_status LOOP
      IF (objstate_ = 'Invoiced') THEN
         OPEN invoice_exists(rec_.order_no);
         FETCH invoice_exists INTO temp_;
         invoice_exists_ := invoice_exists%FOUND;
         CLOSE invoice_exists;

         IF (invoice_exists_) THEN
            
            OPEN invoice_status1(rec_.order_no);
            FETCH invoice_status1 INTO temp_;
            invoice_status_ := invoice_status1%FOUND;
            CLOSE invoice_status1;

            IF (NOT invoice_status_) THEN

               OPEN invoice_status(rec_.order_no);
               FETCH invoice_status INTO temp_;
               invoice_status_ := invoice_status%FOUND;
               CLOSE invoice_status;

               IF (invoice_status_) THEN
                  Clear_Lines_With_Status___(rec_.order_no, 'Invoiced', NULL);

                  -- If objstate_ is 'Invoiced' some of the rows might be 'Cancelled'
                  -- and they also have to be removed.
                  Clear_Lines_With_Status___(rec_.order_no, 'Cancelled', reason_);
                  Clear_Header_Records___(rec_.order_no);

               END IF;
            END IF;
         ELSE -- invoice_exists%NOTFOUND

            -- cleanup the headers for the invoiced customer orders without invoices being created.
            Clear_Lines_With_Status___(rec_.order_no, 'Invoiced', NULL);

            -- If objstate_ is 'Invoiced' some of the rows might be 'Cancelled'
            -- and they also have to be removed.
            Clear_Lines_With_Status___(rec_.order_no, 'Cancelled', reason_);
            Clear_Header_Records___(rec_.order_no);
         END IF;

      ELSE -- Cancelled

         Clear_Lines_With_Status___(rec_.order_no, 'Cancelled', reason_);
         Clear_Header_Records___(rec_.order_no);
      END IF;
   END LOOP;

   @ApproveTransactionStatement(2012-01-24,GanNLK)
   COMMIT;

EXCEPTION
   WHEN abort_deletion_ THEN
      @ApproveTransactionStatement(2012-01-24,GanNLK)
      ROLLBACK TO SAVEPOINT start_cleanup_order_;
END Clear_Headers_With_Status___;


-- Clear_Charge_Records___
--   Removed the charge lines connected to the given order or order line
--   Charge Tax Lines will also be deleted
PROCEDURE Clear_Charge_Records___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2 DEFAULT NULL,
   rel_no_       IN VARCHAR2 DEFAULT NULL,
   line_item_no_ IN NUMBER DEFAULT NULL )
IS

   CURSOR get_charge_lines IS
   SELECT company, order_no, sequence_no
     FROM CUSTOMER_ORDER_CHARGE_TAB
    WHERE order_no      = order_no_
      AND (line_no      = line_no_      OR line_no_      IS NULL)
      AND (rel_no       = rel_no_       OR rel_no_       IS NULL)
      AND (line_item_no = line_item_no_ OR line_item_no_ IS NULL);

BEGIN
   FOR rec_ IN get_charge_lines LOOP
      Source_Tax_Item_Order_API.Cleanup_Tax_Items(rec_.company, Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                                  rec_.order_no, NVL(TO_CHAR(rec_.sequence_no),'*'), '*', '*', '*');
      
      DELETE
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no    = rec_.order_no
      AND   sequence_no = rec_.sequence_no;

   END LOOP;
END Clear_Charge_Records___;


-- Clear_Header_Records___
--   Removes order headers with specified order number.
--   Order histry, order address and staged billing template
--   records are also removed.
PROCEDURE Clear_Header_Records___ (
   order_no_ IN VARCHAR2 )
IS
   note_id_ NUMBER;

   temp_             NUMBER;

   CURSOR order_lines_exist IS
      SELECT 1
        FROM CUSTOMER_ORDER_LINE_TAB
       WHERE order_no = order_no_;
BEGIN

   OPEN order_lines_exist;
   FETCH order_lines_exist INTO temp_;
   IF (order_lines_exist%FOUND) THEN
      CLOSE order_lines_exist;
      RAISE abort_deletion_;
   END IF;
   CLOSE order_lines_exist;

   note_id_ := Customer_Order_API.Get_Note_Id(order_no_);
   IF (note_id_ IS NOT NULL) THEN
      Document_Text_API.Remove_Note(note_id_);
   END IF;

   DELETE
   FROM  CUSTOMER_ORDER_HISTORY_TAB
   WHERE order_no = order_no_;

   DELETE
   FROM  CUSTOMER_ORDER_ADDRESS_TAB
   WHERE order_no = order_no_;

   DELETE 
   FROM STAGED_BILLING_TEMPLATE_TAB
   WHERE order_no = order_no_;

   -- Remove pre-accounting record associate with CO
   Pre_Accounting_API.Remove_Accounting_Id(Customer_Order_API.Get_Pre_Accounting_Id(order_no_));

   Clear_Charge_Records___(order_no_);

   $IF Component_Rmcom_SYS.INSTALLED $THEN
      -- Remove representatives and contacts.
      Bus_Obj_Representative_API.Remove(order_no_, Business_Object_Type_API.DB_CUSTOMER_ORDER);
      Business_Object_Contact_API.Remove(order_no_, Business_Object_Type_API.DB_CUSTOMER_ORDER,Fnd_Boolean_API.DB_FALSE);
   $END
      
   DELETE
   FROM  CUSTOMER_ORDER_TAB
   WHERE order_no = order_no_;


   Delivery_Note_API.Remove_Order_Deliv_Note(order_no_);
  
END Clear_Header_Records___;


-- Clear_Line_Records___
--   Removes records related to the given order line.
--   Order Line history, reservations and deliveries are also removed.
PROCEDURE Clear_Line_Records___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   note_id_ NUMBER;
   company_ VARCHAR2(20);

   temp_             NUMBER;
   dummy_            NUMBER;

   CURSOR open_commissions_exist IS
      SELECT 1
        FROM ORDER_LINE_COMMISSION_TAB
       WHERE rowstate    NOT IN ('Closed','Cancelled')
         AND order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_;
         
   CURSOR get_component_lines IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB         
      WHERE order_no      = order_no_
      AND line_no         = line_no_
      AND rel_no          = rel_no_
      AND line_item_no    > 0
      AND rowstate NOT IN ('Closed','Cancelled');
BEGIN
   
   company_ := Site_API.Get_Company(Customer_Order_Line_API.Get_Contract(order_no_, line_no_, rel_no_, line_item_no_));
   
   OPEN open_commissions_exist;
   FETCH open_commissions_exist INTO temp_;
   IF (open_commissions_exist%FOUND) THEN
      CLOSE open_commissions_exist;
      RAISE abort_deletion_;
   END IF;

   CLOSE open_commissions_exist;

   note_id_ := Customer_Order_Line_API.Get_Note_Id(order_no_, line_no_, rel_no_, line_item_no_);
   IF (note_id_ IS NOT NULL) THEN
      Document_Text_API.Remove_Note(note_id_);
   END IF;

   DELETE
   FROM OUTSTANDING_SALES_TAB
   WHERE deliv_no IN (SELECT deliv_no
                      FROM CUSTOMER_ORDER_DELIVERY_TAB
                      WHERE order_no   = order_no_
                      AND line_no      = line_no_
                      AND rel_no       = rel_no_
                      AND line_item_no = line_item_no_);

   DELETE
   FROM  CUSTOMER_ORDER_DELIVERY_TAB
   WHERE order_no       = order_no_
   AND   line_no        = line_no_
   AND   rel_no         = rel_no_
   AND   line_item_no   = line_item_no_;

   DELETE
   FROM  CUSTOMER_ORDER_RESERVATION_TAB
   WHERE order_no       = order_no_
   AND   line_no        = line_no_
   AND   rel_no         = rel_no_
   AND   line_item_no   = line_item_no_;

   DELETE
   FROM  CUSTOMER_ORDER_LINE_HIST_TAB
   WHERE order_no       = order_no_
   AND   line_no        = line_no_
   AND   rel_no         = rel_no_
   AND   line_item_no   = line_item_no_;

   OPEN  get_component_lines;
   FETCH get_component_lines INTO dummy_;
   IF (get_component_lines%NOTFOUND) THEN
      -- Remove pre-accounting record associate with CO line
      Pre_Accounting_API.Remove_Accounting_Id(Customer_Order_Line_API.Get_Pre_Accounting_Id(order_no_,
                                                                                            line_no_,
                                                                                            rel_no_,
                                                                                            line_item_no_));
   END IF;
   CLOSE get_component_lines;
   
   DELETE
   FROM  CUSTOMER_ORDER_LINE_TAB
   WHERE order_no       = order_no_
   AND   line_no        = line_no_
   AND   rel_no         = rel_no_
   AND   line_item_no   = line_item_no_;

   DELETE
   FROM  ORDER_LINE_STAGED_BILLING_TAB
   WHERE order_no       = order_no_
   AND   line_no        = line_no_
   AND   rel_no         = rel_no_
   AND   line_item_no   = line_item_no_;

   Clear_Charge_Records___(order_no_,
                           line_no_,
                           rel_no_,
                           line_item_no_);

   DELETE
   FROM  cust_ord_price_hist_tab
   WHERE order_no       = order_no_
   AND   line_no        = line_no_
   AND   rel_no         = rel_no_
   AND   line_item_no   = line_item_no_;

   DELETE
   FROM  CUST_ORDER_LINE_DISCOUNT_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   DELETE
   FROM  ORDER_LINE_COMMISSION_TAB
   WHERE rowstate    IN ('Closed','Cancelled')
   AND   order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   Source_Tax_Item_Order_API.Remove_Tax_Items(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, order_no_, 
                                              line_no_, rel_no_ , TO_CHAR(line_item_no_), '*');
   
   DELETE
   FROM  CUST_ORDER_LINE_ADDRESS_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   DELETE
   FROM  CUSTOMER_ORDER_MILESTONE_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   DELETE
   FROM  CUSTOMER_ORDER_SHORTAGE_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   DELETE
   FROM  CUST_ORDER_LINE_SOURCE_SET_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   DELETE
   FROM  CO_SUPPLY_SITE_RESERVATION_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   DELETE
   FROM  SOURCED_CUST_ORDER_LINE_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

   DELETE
   FROM  SOURCED_CO_SUPPLY_SITE_RES_TAB
   WHERE order_no     = order_no_
   AND   line_no      = line_no_
   AND   rel_no       = rel_no_
   AND   line_item_no = line_item_no_;

END Clear_Line_Records___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Cleanup_Routine__
--   This method internally calls to the Cleanup_Routine_Impl__ in order
--   to proceed with the Cleanup of Customer Order process.
PROCEDURE Cleanup_Routine__ (
   message_ IN VARCHAR2 )
IS
   description_        VARCHAR2(200);
BEGIN
   IF (Transaction_Sys.Is_Session_Deferred()) THEN
      -- if we are already inside a background job don't create a new one, which will happened if this was a scheduled job
      Cleanup_Routine_Impl__(message_);
   ELSE
      description_ := Language_SYS.Translate_Constant(lu_name_, 'CLEANUP_CO: Cleanup of Customer Order');
      Transaction_SYS.Deferred_Call('CLEANUP_CUSTOMER_ORDER_API.Cleanup_Routine_Impl__', message_, description_);
   END IF;
END Cleanup_Routine__;


-- Cleanup_Routine_Impl__
--   Removes records (using "raw" delete) from several tables specified in
--   the message-variable.
PROCEDURE Cleanup_Routine_Impl__ (
   message_ IN VARCHAR2 )
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;

   clear_header_history_    BOOLEAN := FALSE;
   clear_cancelled_headers_ BOOLEAN := FALSE;
   clear_invoiced_headers_  BOOLEAN := FALSE;
   clear_line_history_      BOOLEAN := FALSE;
   clear_cancelled_lines_   BOOLEAN := FALSE;
   clear_invoiced_lines_    BOOLEAN := FALSE;
   clear_reservations_      BOOLEAN := FALSE;
   clear_deliveries_        BOOLEAN := FALSE;
   reason_                  VARCHAR2(10);
   contract_                VARCHAR2(5);
   number_of_days_          NUMBER;
   before_date_             DATE;


   CURSOR select_affected_orders IS
      SELECT DISTINCT(cot.order_no)
        FROM customer_order_tab cot
       WHERE cot.date_entered < before_date_
         AND EXISTS (SELECT 1
                       FROM user_allowed_site_pub
                      WHERE cot.contract = site)
         AND (NOT EXISTS (SELECT 1
                            FROM customer_order_line_tab colt
                           WHERE colt.order_no = cot.order_no
                             AND colt.demand_code = 'DO'))
         AND cot.contract LIKE contract_;
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CLEAR_HEADER_HISTORY') THEN
         IF value_arr_(n_) = '1' THEN
            clear_header_history_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'CLEAR_CANCELLED_HEADERS') THEN
         IF value_arr_(n_) = '1' THEN
            clear_cancelled_headers_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'CLEAR_INVOICED_HEADERS') THEN
         IF value_arr_(n_) = '1' THEN
            clear_invoiced_headers_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'CLEAR_LINE_HISTORY') THEN
         IF value_arr_(n_) = '1' THEN
            clear_line_history_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'CLEAR_CANCELLED_LINES') THEN
         IF value_arr_(n_) = '1' THEN
            clear_cancelled_lines_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'CLEAR_INVOICED_LINES') THEN
         IF value_arr_(n_) = '1' THEN
            clear_invoiced_lines_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'CLEAR_RESERVATIONS') THEN
         IF value_arr_(n_) = '1' THEN
            clear_reservations_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'CLEAR_DELIVERIES') THEN
         IF value_arr_(n_) = '1' THEN
            clear_deliveries_ := TRUE;
         END IF;
      ELSIF (name_arr_(n_) = 'SITE') THEN
         contract_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'CANCEL_REASON') THEN
         reason_ :=  value_arr_(n_);
      ELSIF (name_arr_(n_) = 'NUMBER_OF_DAYS') THEN
         number_of_days_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'BEFORE_DATE') THEN
         before_date_ := Client_SYS.Attr_Value_To_Date(value_arr_(n_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.');
      END IF;
   END LOOP;


   IF (number_of_days_ IS NOT NULL) THEN
      before_date_ := SYSDATE - number_of_days_;
   END IF;

   FOR rec_ IN select_affected_orders LOOP

      IF clear_header_history_ THEN
         Clear_Header_History___(rec_.order_no);
      END IF;

      IF clear_cancelled_headers_ THEN
         Clear_Headers_With_Status___(rec_.order_no, 'Cancelled', reason_);
      END IF;

      IF clear_invoiced_headers_ THEN
         Clear_Headers_With_Status___(rec_.order_no, 'Invoiced', NULL);
      END IF;

      IF clear_line_history_ THEN
         Clear_Line_History___(rec_.order_no);
      END IF;

      IF clear_deliveries_ THEN
         Clear_Deliveries___(rec_.order_no);
      END IF;

      IF clear_reservations_ THEN
         Clear_Reservations___(rec_.order_no);
      END IF;

      IF clear_cancelled_lines_ THEN
         Clear_Lines_With_Status___(rec_.order_no, 'Cancelled', reason_);
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         COMMIT;
      END IF;

      IF clear_invoiced_lines_ THEN
         Clear_Lines_With_Status___(rec_.order_no, 'Invoiced', NULL);
         @ApproveTransactionStatement(2012-01-24,GanNLK)
         COMMIT;
      END IF;
   END LOOP;
END Cleanup_Routine_Impl__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Validate_Params
--   Validates the parameters when running the Schedule for Cleanup Customer
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_                   NUMBER;
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   contract_                VARCHAR2(5);
   reason_                  VARCHAR2(10);
BEGIN

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SITE') THEN
         contract_ := NVL(value_arr_(n_), '%');
      ELSIF (name_arr_(n_) = 'CANCEL_REASON') THEN
         reason_ := value_arr_(n_);
      END IF;
   END LOOP;

   IF (contract_ != '%') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   IF (Nvl(reason_, '%') != '%') THEN
      Order_Cancel_Reason_API.Exist(reason_, true);
   END IF;

END Validate_Params;



