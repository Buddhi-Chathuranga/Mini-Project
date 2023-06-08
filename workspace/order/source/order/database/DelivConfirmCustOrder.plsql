-----------------------------------------------------------------------------
--
--  Logical unit: DelivConfirmCustOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210614  KiSalk Bug 157257(SCZ-14970), In Confirm_Package_Components___(added parameter delnote_no_) and Confirm_Delivery, added conditions to create new delivery records with the remaining shipped quantities only when customer order lines 
--  210614         created by IPT demands. Corrected Confirm_Package_If_Complete___ to work for partial deliveries and both it and Mark_Excess_Components___ for multiple deliveries. Added Confirm_Delivery__ to confirm unchanged deliveries too.
--  210614         Stopped calling Check_Packages_To_Confirm___ from Confirm_Delivery_Note and made call Confirm_Delivery__ for package parts instead of processing components within the method.
--  210201  RoJalk Bug 157008 (SCZ-12874), Modified Modify_Delivery_Confirmed___ and reversed the correction done for Bug 149267.  
--  200311  DaZase SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  190925  WaSalk Bug 149267 (SCZ-6061), Modified Modify_Delivery_Confirmed___() adding get_shipped_qty cursor to select qty_shipped correctly without concidering confirmed date.
--  190910  UdGnlk Bug 147172(SCZ-4918), Modified Mark_Excess_Components___() to consider calculation express in sales unit of measure.
--  190726  UdGnlk Bug 147172(SCZ-3586), Added parameter last_confirmed_ to Confirm_Delivery().
--                 Modified the logic to update confirmed of package part after the components confirmed.
--  181021  BudKlk Bug 144009, Modified the method Book_Transaction___() to update the cost of Customer_Order_Delivery_TAB from the transaction cost value in order to calculate invoice sales statistics correctly
--  181021         and update the cost of outstanding sales according to the delivery cost.
--  180111  MaAuse STRSC-15714, Modified Confirm___ method to fetch cost into attr_.
--  170503  DaZase STRSC-7646, Made several changes in Create_Data_Capture_Lov/Record_With_Column_Value_Exist/Get_Column_Value_If_Unique so they work in similar way. 
--  170202  JeeJlk Bug 133829, Modified Book_Transaction___ to get total delivery confirmed qty to calculate unit cost in COL.
--  160608  MaIklk LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  150527  DaZase COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150512  IsSalk KES-422, Added new parameter source_ref5_ to Inventory_Transaction_Hist_API. Create_And_Account.
--  150422  DaZase Changed Get_Column_Value_If_Unique so it can handle null values correctly.
--  150729  BudKlk Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729         method call in ORDER BY clause to sort string and number values seperately.
--  150422  Chfose LIM-1361, Fixed modified method calls by adding new temporary parameter handling_unit_id.
--  150216  Chfose PRSC-5454, Added new parameter contract_ in Create_Data_Capture_Lov to use in filtering the LOV.
--  141127  MAHPLK PRSC-2774, Modified Get_Previous_Execution___ method to use overloaded 
--  141127         Transaction_SYS.Get_Posted_Job_Arguments which returns plsql table.
--  140814  DaZase PRSC-1611, Added extra column checks in methods Get_Column_Value_If_Unique to Record_With_Column_Value_Exist to avoid any risk of getting sql injection problems.
--  140813  RoJalk Added missing assert safe anotation for Create_Data_Capture_Lov, Get_Column_Value_If_Unique, Record_With_Column_Value_Exist.
--  140811  DaZase PRSC-1611 Renamed Check_Valid_Value to Record_With_Column_Value_Exist.
--  140619  DaZase PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  140421  SBalLK Modified Modify_Delivery_Confirmed___() method by replacing CUSTOMER_ORDER_JOIN view with CUSTOMER_ORDER and CUSTOMER_ORDER_LINE views.
--  140225  MatKse Bug 115429, Added Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Check_Valid_Value.
--  130624  UdGnlk EBALL-94, Modified Book_Transaction___() hence a parameter add to Decrease_Our_Qty_At_Customer(). 
--  130610  AwWelk EBALL-98, Modified Book_Transaction___() method according to the added parameters for Decrease_Our_Qty_At_Customer().
--  130429  Asawlk EBALL-37, Restructured method Book_Transaction___().
--  120608  SBallk Bug 102291, Modified Start_Confirm_Order method to fetch delivery note number.
--  120313  MaMalk Bug 99430, Modified the code to consider inverted_conv_factor where conv_factor has been considered.
--  110803  NWeelk Bug 97341, Modified methods Get_Previous_Execution___, Start_Confirm_Order and Confirm_Delivery_Note to stop creating 
--  110803         another background job for delivery confirmation if there is another one posted or executing for the same delivery note.
--  110718  MaMalk Added user allowed filter for view DELIV_UNCONFIRM_CUST_ORDER.
--  110628  NWeelk Bug 95161, Added function Get_Previous_Execution___ and modified method Confirm_Delivery_Note by introducing 
--  110628         a warning message to raise if the same delivery confirmation is processed through another job id at the same time.
--  110323  ChJalk EAPM-15814, Removed user allowed site filter from CO_DELIVERY_JOIN and added CO_DELIVERY_JOIN_UIV.
--  110131  Nekolk EANE-3744  added where clause to View CO_DELIVERY_JOIN,CO_DELIVERY_JOIN2.
--  101026  ChJalk Bug 93690, Modified the method Book_Transaction___ to consider the total qty_shipped when updating the cost.
--  101005  SudJlk Bug 93374, Modified views CO_DELIVERY_JOIN and CO_DELIVERY_JOIN2 to correct invalid column FLAGS in the view columns.
--  100420  MaRalk Modified reference by name method call to Inventory_Transaction_Hist_API.Create_And_Account 
--  100420         within Book_Transaction___ method.
--  091007  TiRalk Bug 83499, Added new column sale_unit_price, currency_rate to view CO_DELIVERY_JOIN.
--  090930  MaMalk Modified Confirm_Package_Components___ and  Check_Packages_To_Confirm___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  091007  TiRalk Bug 83499, Added new column sale_unit_price, currency_rate to view CO_DELIVERY_JOIN.
--  070507  NiDalk Modified Confirm_Delivery_Note to continue with order flow from delivery when delivery confirmed.
--  070221  WaJalk Bug 61985, Modified views CO_DELIVERY_JOIN and DELIV_UNCONFIRM_CUST_ORDER,
--  070221         to increase length of column customer_po_no from 15 to 50, in view comments.  
--  070108  ChBalk Added Deliver_Customer_Order_API.Modify_Order_Line_Cost.
--  060601  MiErlk Enlarge Identity - Changed view comments - Description.
--  060522  MaRalk Bug 57640, Modified the view DELIV_UNCONFIRM_CUST_ORDER. 
--  060410  IsWilk Enlarge Identity - Changed view comments of customer_no.
--  --------------------------------- 13.4.0 --------------------------------
--  060225  NiDalk Added check for invoiced order lines when updating confirmed lines.
--  060124  LEPESE Complete redesign of method Book_Transaction___ to use new Inventory interface
--  060124         Inventory_Transaction_Hist_API.Create_And_Account and to get cost details.
--  050922  NaLrlk Removed unused variables.
--  050830  JoEd   Changed so that if confirming 0 a warning message CONFIRM_ZERO is displayed.
--                 Also when updating qty_confirmeddiff a new method is called to also change the
--                 status from Delivered to Invoiced when all is fully confirmed and fully invoiced.
--  050825  JoEd   Transactions in Book_Transaction___ are not made for package parts anymore.
--  050824  JoEd   Changed package calculations in Confirm_Package_If_Complete___
--                 and Confirm_Package_Components___.
--                 Also modified the check in Check_Packages_To_Confirm___.
--                 Added more error messages to display when the confirmation isn't correct.
--  050811  AnLaSe Added blocked_for_invoicing_db to DELIVJOIN.
--  050811  KeFelk Added customer_po_no, customer_po_line_no and customer_po_rel_no 
--  050811         to DELIVJOIN and DELIVUNCONF.
--  050805  Nalrlk Added the Qty_Confirmed_ Arrived column to the CO_DELIVERY_JOIN2 view.
--  050714  KeFelk Added customer_part_no to CO_DELIVERY_JOIN and DELIV_UNCONFIRM_CUST_ORDER.
--  050711  NaLrlk Added OBJID and OBJVERSION fields to DELIV_UNCONFIRM_CUST_ORDER view.
--  050707  KeFelk Added DELIV_UNCONFIRM_CUST_ORDER view to be used in Receiving Advice.
--                 Added qty_confirmed_arrived to view CO_DELIVERY_JOIN.
--  050523  JoEd   Changed update of delivery_confirmed flag for components in
--                 Modify_Delivery_Confirmed___.
--  050520  JoEd   Added value for qty_shipped in Outstanding Sales.
--                 Added self_billing_db to DELIVJOIN and DELIVUNION.
--  050516  JoEd   Added extra check on confirmed qty for packages so that you cannot
--                 confirm more full packages than already confirmed components.
--                 Also added extra check when confirming 0.
--                 Changed calculation of confirmed diff.
--  050510  JoEd   Changed order line history creation. Modified Start_Confirm_Order.
--                 Included incorrect deliveries in Confirm_Delivery_Note.
--                 Added assign of confirmed diff - to set line status to Invoiced
--                 when all confirmed deliveries have been invoiced.
--  050504  JoEd   Added method Book_Transaction___ to book a transaction when
--                 COGS is posted at delivery confirmation.
--                 Added error message in Confirm_Delivery when trying to confirm
--                 an already confirmed delivery.
--  050428  JoEd   Changed Modify__ method to not update packages or components.
--  050422  JoEd   Added view DELIVUNION.
--  050420  JoEd   Added Modify__. Changed confirmation of packages and components.
--  050414  JoEd   Added Confirm_Delivery_Note and Confirm_Delivery.
--  050412  JoEd   Added modify of delivery confirmed flag on Customer Order Line
--                 in Confirm___.
--  050411  JoEd   Added Deliv_Confirm_Allowed and Start_Confirm_Order.
--  050406  JoEd   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Confirm___
--   Confirms a customer order delivery and creates an outstanding sales record
--   (COGS is posted at this time).
PROCEDURE Confirm___ (
   deliv_no_      IN NUMBER,
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   incorrect_db_  IN VARCHAR2,
   delay_cogs_db_ IN VARCHAR2,
   contract_      IN VARCHAR2,
   qty_confirmed_ IN NUMBER,
   update_line_   IN BOOLEAN DEFAULT TRUE )
IS
   attr_          VARCHAR2(2000);
   delivery_rec_  Customer_Order_Delivery_API.Public_Rec;
BEGIN
   IF (nvl(incorrect_db_, ' ') = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'INCORRECTLINES: The delivery :P1 for customer order line :P2 is set to Incorrect Delivery Confirmation. Use the "Update Delivery Confirmation" window to correct it.',
                               deliv_no_, order_no_ || '/' || line_no_ || '/' || rel_no_);
   END IF;

   -- sets qty_to_invoice on the delivery and set it as Confirmed
   Customer_Order_Delivery_API.Modify_Delivery_Confirmed(deliv_no_, qty_confirmed_, trunc(Site_API.Get_Site_Date(contract_)), incorrect_db_);

   -- Outstanding sales is not allowed for package components
   -- Consignment stock is not allowed to run the Delivery Confirmation "step"!
   IF (line_item_no_ <= 0) THEN
      Client_SYS.Clear_Attr(attr_);
      -- if COGS is posted at delivery confirmation (i.e. now) create a new outstanding sales record
      IF (delay_cogs_db_ = 'TRUE') THEN
         Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
         Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
         Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(contract_), attr_);
         Client_SYS.Add_To_Attr('QTY_EXPECTED', qty_confirmed_, attr_);
         -- fetch qty_shipped and cost from the delivery
         delivery_rec_ := Customer_Order_Delivery_API.Get(deliv_no_);
         Client_SYS.Add_To_Attr('QTY_SHIPPED', delivery_rec_.qty_shipped, attr_);
         Client_SYS.Add_To_Attr('COST', delivery_rec_.cost, attr_);
         Outstanding_Sales_API.New(attr_);

      -- if COGS is not posted, a record has already been created at delivery - update the existing record
      ELSE
         Client_SYS.Add_To_Attr('QTY_EXPECTED', qty_confirmed_, attr_);
         -- don't update qty_shipped here, since that value was set at delivery
         Outstanding_Sales_API.Modify(deliv_no_, attr_);
      END IF;
   END IF;

   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_,
                                    Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFL: Delivery :P1 confirmed.', p1_ => deliv_no_));

   -- order line is updated outside this method if flag is not set here
   -- this also applies to the transaction history...
   IF update_line_ THEN
      Book_Transaction___(deliv_no_, order_no_, line_no_, rel_no_, line_item_no_);

      -- check if order line can be set to confirmed
      Modify_Delivery_Confirmed___(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
END Confirm___;


-- Confirm_Package_If_Complete___
--   Performs delivery confirmation on a complete package.
--   Excluding incorrect packages and components!
--   This is called after components have been delivery confirmed.
PROCEDURE Confirm_Package_If_Complete___ (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   delnote_no_  IN NUMBER )
IS
   -- fetch number of complete packages (per component) confirmed/not confirmed
   CURSOR get_components(confirmed_ NUMBER) IS
      SELECT MIN(SUM(NVL(TRUNC(qty_to_invoice / qty_per_assembly), 0))) confirmed,
             MIN(SUM(NVL(TRUNC(qty_shipped / qty_per_assembly), 0))) unconfirmed
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no > 0
      AND   line_objstate != 'Cancelled'
      AND   confirm_deliveries_db = 'TRUE'
      AND (((confirmed_ = 1) AND date_confirmed IS NOT NULL AND incorrect_del_confirmation_db = 'FALSE') OR
           ((confirmed_ = 0) AND date_confirmed IS NULL))
      GROUP BY line_item_no;
   -- fetch the packages to confirm - or to count number of packages already confirmed
   CURSOR get_package(confirmed_ NUMBER) IS
      SELECT deliv_no, incorrect_del_confirmation_db, delay_cogs_to_deliv_conf_db,
             contract, revised_qty_due, (qty_shipped / conv_factor * inverted_conv_factor) qty_to_confirm,
             qty_to_invoice, date_confirmed
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = -1
      AND   line_objstate != 'Cancelled'
      AND   confirm_deliveries_db = 'TRUE'
      AND (((confirmed_ = 1) AND date_confirmed IS NOT NULL AND incorrect_del_confirmation_db = 'FALSE') OR
           ((confirmed_ = 0) AND date_confirmed IS NULL) AND (delnote_no_ IS NULL OR delnote_no = delnote_no_) )
      ORDER BY qty_to_confirm;

   packline_      Customer_Order_Line_API.Public_Rec;
   pkg_objstate_  VARCHAR2(20);
   dummy_         NUMBER;
   confirmed_     NUMBER := 0;
   unconfirmed_   NUMBER := 0;
   packages_      NUMBER := 0;
   qty_confirmed_ NUMBER;
   incorrect_     BOOLEAN;
BEGIN
   packline_     := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
   pkg_objstate_ := Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, -1);

   -- fetch number of component packages confirmed
   OPEN get_components(1);
   FETCH get_components INTO confirmed_, dummy_;
   IF get_components%NOTFOUND OR (confirmed_ IS NULL) THEN
      confirmed_ := 0;
   END IF;
   CLOSE get_components;
   Trace_SYS.Field('Confirmed components', confirmed_);

   -- check if there are unconfirmed components
   OPEN get_components(0);
   FETCH get_components INTO dummy_, unconfirmed_;
   IF get_components%NOTFOUND OR (unconfirmed_ IS NULL) THEN
      unconfirmed_ := 0;
   END IF;
   CLOSE get_components;
   Trace_SYS.Field('Unconfirmed components', unconfirmed_);

   incorrect_ := FALSE;
   -- count number of packages already confirmed
   FOR confrec_ IN get_package(1) LOOP
      IF (confrec_.incorrect_del_confirmation_db = 'FALSE') THEN
         packages_ := packages_ + confrec_.qty_to_invoice;
      ELSE
         incorrect_ := TRUE;
      END IF;
   END LOOP;
   Trace_SYS.Field('Confirmed packages', packages_);

   -- exit procedure if we don't have to confirm a package
   IF (packages_ = confirmed_) AND (unconfirmed_ > 0) THEN
      Trace_SYS.Message('There are still components to confirm...');
      -- RETURN;
   -- confirm remaining complete packages
   ELSIF ((packages_ < confirmed_) OR
      ((NOT incorrect_) AND (packages_ = confirmed_) AND (pkg_objstate_ IN ('Delivered', 'PartiallyDelivered')))) THEN
      -- only enter loop if there are packages left - otherwise the excess components
      -- will be marked for invoicing after returning from this method
      FOR packrec_ IN get_package(0) LOOP
         
         -- only confirm enough to cover the number of complete packages
         -- if there's a rest after this, it will be handled by Mark_Excess_Components___.
         qty_confirmed_ := confirmed_ - packages_;     
             
         Confirm___(packrec_.deliv_no, order_no_, line_no_, rel_no_, -1,
                    packrec_.incorrect_del_confirmation_db, packrec_.delay_cogs_to_deliv_conf_db,
                    packrec_.contract, qty_confirmed_);

         packages_ := packages_ + qty_confirmed_;
         Trace_SYS.Field('Confirming # packages', qty_confirmed_);

         -- check if we have more to confirm
         EXIT WHEN (packages_ = confirmed_);
      END LOOP;
      Trace_SYS.Field('Confirmed packages', packages_);
   END IF;
END Confirm_Package_If_Complete___;


-- Confirm_Package_Components___
--   Delivery confirmation of all components for a specific package header.
--   The confirmed quantity indicates number of complete packages.
PROCEDURE Confirm_Package_Components___ (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   qty_confirmed_   IN NUMBER,
   pkg_to_confirm_  IN NUMBER,
   revised_qty_due_ IN NUMBER,
   delnote_no_      IN NUMBER)
IS
   -- count number of components contained in this package
   CURSOR get_no_of_components IS
      SELECT count(*)
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0
      AND   rowstate != 'Cancelled';

   -- fetch all components for the package part - processing one component at a time
   CURSOR get_component IS
      SELECT deliv_no, order_no, line_no, rel_no, line_item_no, demand_code_db,
             incorrect_del_confirmation_db, delay_cogs_to_deliv_conf_db,
             contract, revised_qty_due, qty_to_invoice,
             (qty_shipped / conv_factor * inverted_conv_factor) qty_to_confirm, conv_factor, inverted_conv_factor
      FROM DELIV_CONFIRM_CUST_ORDER
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0
      AND   NVL(delnote_no, -1) = NVL(delnote_no_, -1)
      AND   date_confirmed IS NULL
      ORDER BY line_item_no, qty_to_confirm;

   first_            BOOLEAN := TRUE;
   total_comp_       NUMBER;
   comp_count_       NUMBER := 0;
   all_confirmed_    BOOLEAN := FALSE;
   component_qty_    NUMBER;
   total_confirmed_  NUMBER;
   total_components_ NUMBER;
   total_shipped_    NUMBER;
   component_no_     NUMBER := -1; -- temp. to enter the loop condition directly
   qty_remain_       NUMBER;
BEGIN
   OPEN get_no_of_components;
   FETCH get_no_of_components INTO total_comp_;
   CLOSE get_no_of_components;

   -- delivery of complete packages smeared on all components
   FOR rec_ IN get_component LOOP
      -- if there are more packages for this component to confirm,
      -- or if we've come to a new component -  process the component
      IF ((NOT all_confirmed_ AND (component_no_ = rec_.line_item_no)) OR
          (component_no_ != rec_.line_item_no)) THEN
         -- initialize a new component
         IF (component_no_ != rec_.line_item_no) THEN
            comp_count_ := comp_count_ + 1;

            IF NOT first_ AND NOT all_confirmed_ THEN
               Error_SYS.Record_General(lu_name_, 'NOTALLCONFIRMED: Error confirming package delivery. Only :P2 components were found! Please confirm on component level instead.', total_confirmed_);
            END IF;
            first_           := FALSE;
            component_no_    := rec_.line_item_no;
            all_confirmed_   := FALSE;
            total_confirmed_ := 0;
            total_shipped_   := 0;
         END IF;

         -- total components to confirm (sale unit)
         total_components_ := pkg_to_confirm_ * ((rec_.revised_qty_due / revised_qty_due_) / rec_.conv_factor * rec_.inverted_conv_factor);

         -- increase already confirmed qty (qty_to_invoice) - if any
         component_qty_    := (qty_confirmed_ * (rec_.revised_qty_due / revised_qty_due_) / rec_.conv_factor * rec_.inverted_conv_factor) - total_confirmed_ + rec_.qty_to_invoice;

         -- if there are not enough components on this delivery to cover a complete package
         IF (component_qty_ > rec_.qty_to_confirm) THEN
            component_qty_ := rec_.qty_to_confirm;
         END IF;

         -- total confirmed (sale unit)
         total_confirmed_ := total_confirmed_ + (component_qty_ - rec_.qty_to_invoice);

         -- total shipped (sale unit)
         total_shipped_   := total_shipped_ + rec_.qty_to_confirm;

         -- if there are enough components to cover the number of confirmed packages
         IF (total_confirmed_ = (qty_confirmed_ * (rec_.revised_qty_due / revised_qty_due_) / rec_.conv_factor) * rec_.inverted_conv_factor) THEN
            all_confirmed_ := TRUE;
         END IF;

         Trace_SYS.Message('Confirming ' || to_char(component_qty_) || ' components');

         Confirm___(rec_.deliv_no, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                    rec_.incorrect_del_confirmation_db, rec_.delay_cogs_to_deliv_conf_db,
                    rec_.contract, component_qty_, FALSE);

         -- calculate remaining components (sale unit) to confirm
         qty_remain_ := total_shipped_ - total_components_;

         Trace_SYS.Field('Remaining qty', qty_remain_);
         IF (qty_remain_ > 0 AND rec_.demand_code_db = 'IPT') THEN
            -- create a new record with the remaining shipped qty (and reduce the existing delivery's shipped qty)
            Customer_Order_Delivery_API.Reduce_And_Copy(rec_.deliv_no, (qty_remain_ * rec_.conv_factor/ rec_.inverted_conv_factor)); -- inventory unit
         END IF;

         -- to create the transaction with correct quantity - this call is made here: after the
         -- reduction of shipped qty.
         Book_Transaction___(rec_.deliv_no, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);

         -- set qty_confirmeddiff on the component line (this is not made in Confirm___ in this case)
         Modify_Delivery_Confirmed___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      END IF;
   END LOOP;

   IF (comp_count_ != total_comp_) THEN
      Error_SYS.Record_General(lu_name_, 'COMPONENTCOUNT: The delivery have already been partially confirmed on component level. Please confirm the rest of the components the same way.');
   END IF;
END Confirm_Package_Components___;


-- Modify_Delivery_Confirmed___
--   Sets the Delivery Confirmed attribute on the order line if all deliveries
--   connected to the order line (or package components) have been confirmed.
--   Also updates qty confirmed diff if a value is passed.
PROCEDURE Modify_Delivery_Confirmed___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   -- check that all deliveries have been confirmed
   -- if a package header is passed - check deliveries for the components too.
   -- if there are any records that are not confirmed or incorrect
   -- the order line will not be set as delivery confirmed.
   CURSOR get_confirmed IS
      SELECT DISTINCT 'TRUE' confirmed  -- 1st hit
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   (((line_item_no_ = 0) AND (line_item_no = 0)) OR
             ((line_item_no_ != 0) AND (line_item_no != 0)))
      AND   line_objstate IN ('Delivered')
      AND   confirm_deliveries_db = 'TRUE'
      AND   consignment_stock_db = 'NO CONSIGNMENT STOCK'
      AND   date_confirmed IS NOT NULL
   UNION ALL
      SELECT DISTINCT 'FALSE' confirmed  -- possibly 2nd hit (confirmed flag will not be set)
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   (((line_item_no_ = 0) AND (line_item_no = 0)) OR
             ((line_item_no_ != 0) AND (line_item_no != 0)))
      AND   line_objstate IN ('Delivered')
      AND   confirm_deliveries_db = 'TRUE'
      AND   consignment_stock_db = 'NO CONSIGNMENT STOCK'
      AND   (date_confirmed IS NULL OR incorrect_del_confirmation_db = 'TRUE');

   CURSOR get_confirmeddiff IS
      SELECT SUM(qty_shipped / conv_factor * inverted_conv_factor), SUM(qty_to_invoice)
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   line_objstate IN ('PartiallyDelivered', 'Delivered')
      AND   confirm_deliveries_db = 'TRUE'
      AND   consignment_stock_db = 'NO CONSIGNMENT STOCK'
      AND   date_confirmed IS NOT NULL
      GROUP BY line_item_no;

   CURSOR get_components(all_confirmed_ IN VARCHAR2) IS
      SELECT DISTINCT order_no, line_no, rel_no, line_item_no
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0
      AND   delivery_confirmed != all_confirmed_
      AND   rowstate IN ('Delivered', 'Invoiced')
      AND   consignment_stock = 'NO CONSIGNMENT STOCK';

   attr_              VARCHAR2(2000);
   line_confirmed_    VARCHAR2(5);
   all_confirmed_     VARCHAR2(5) := 'FALSE';
   qty_shipped_       NUMBER;
   qty_confirmed_     NUMBER;
BEGIN
   FOR rec_ IN get_confirmed LOOP
      all_confirmed_ := rec_.confirmed;
      EXIT WHEN (all_confirmed_ = 'FALSE'); -- just in case
   END LOOP;

   line_confirmed_ := Customer_Order_Line_API.Get_Delivery_Confirmed_Db(order_no_, line_no_, rel_no_, line_item_no_);

   IF (line_confirmed_ != all_confirmed_) THEN
      Trace_SYS.Field('Set order line Delivery Confirmed', all_confirmed_);
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('DELIVERY_CONFIRMED_DB', all_confirmed_, attr_);
      Customer_Order_Line_API.Modify(attr_, order_no_, line_no_, rel_no_, line_item_no_);

      -- if package - update confirmed flag for all components too
      -- (the flag is updated only when the package order line is fully delivered)
      IF (line_item_no_ = -1) THEN
         IF Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_) = 'TRUE' THEN
            FOR comprec_ IN get_components(all_confirmed_) LOOP
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('DELIVERY_CONFIRMED_DB', all_confirmed_, attr_);
               Customer_Order_Line_API.Modify(attr_, comprec_.order_no, comprec_.line_no, comprec_.rel_no, comprec_.line_item_no);
            END LOOP;
         END IF;
      END IF;
   END IF;

   -- Set confirmed diff - and finally change status from Delivered to Invoiced
   -- if the last confirmation has zero (0) confirmed quantity
   OPEN get_confirmeddiff;
   FETCH get_confirmeddiff INTO qty_shipped_, qty_confirmed_;
   IF get_confirmeddiff%FOUND THEN
      Customer_Order_API.Set_Line_Qty_Confirmeddiff(order_no_, line_no_, rel_no_, line_item_no_, qty_confirmed_ - qty_shipped_);
   END IF;
   CLOSE get_confirmeddiff;
END Modify_Delivery_Confirmed___;


-- Mark_Excess_Components___
--   Updates the component invoice flag to Yes on the confirmed component deliveries
--   that are not contained in complete packages...
--   Called from all three Confirm... methods - only Confirm_Delivery uses complete
--   primary key.
PROCEDURE Mark_Excess_Components___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2 DEFAULT NULL,
   rel_no_   IN VARCHAR2 DEFAULT NULL )
IS
   -- get correct confirmed packages
   CURSOR get_package IS
      SELECT order_no, line_no, rel_no, SUM(qty_to_invoice) packages_confirmed
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no LIKE nvl(line_no_, '%')
      AND   rel_no LIKE nvl(rel_no_, '%')
      AND   line_item_no = -1
      AND   line_objstate = 'Delivered'
      AND   confirm_deliveries_db = 'TRUE'
      AND   date_confirmed IS NOT NULL
      AND   incorrect_del_confirmation_db = 'FALSE'
      GROUP BY order_no, line_no, rel_no;

   -- get correct confirmed components
   CURSOR get_component(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT deliv_no, qty_to_invoice, revised_qty_due, component_invoice_flag_db, buy_qty_due, line_item_no
      FROM DELIV_CONFIRM_CUST_ORDER
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0
      AND   date_confirmed IS NOT NULL
      AND   incorrect_del_confirmation_db = 'FALSE'
      ORDER BY line_item_no;

   -- get total confirmed components
   CURSOR get_component_total(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_ number) IS
      SELECT SUM(qty_to_invoice) total_comp_qty_to_invoice
      FROM DELIV_CONFIRM_CUST_ORDER
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_
      AND   date_confirmed IS NOT NULL
      AND   incorrect_del_confirmation_db = 'FALSE';
   line_item_no_    NUMBER := 0;
   total_comp_qty_  NUMBER;
   linerec_         Customer_Order_Line_API.Public_Rec;
   no_of_packages_  NUMBER;
   invoice_flag_    VARCHAR2(1);
BEGIN
   -- if there are no package deliveries at all - the Close Order Line functionality
   -- sets the invoice flag on all components...
   FOR packrec_ IN get_package LOOP
      linerec_ := Customer_Order_Line_API.Get(packrec_.order_no, packrec_.line_no, packrec_.rel_no, -1);

      FOR comprec_ IN get_component(packrec_.order_no, packrec_.line_no, packrec_.rel_no) LOOP
         IF (line_item_no_ != comprec_.line_item_no) THEN
            line_item_no_ := comprec_.line_item_no;
            OPEN get_component_total(packrec_.order_no, packrec_.line_no, packrec_.rel_no, line_item_no_);
            FETCH get_component_total INTO total_comp_qty_;
            CLOSE get_component_total;
         END IF;
         no_of_packages_ := total_comp_qty_ / (comprec_.buy_qty_due / linerec_.buy_qty_due);
         IF (no_of_packages_ > packrec_.packages_confirmed) THEN
            -- there are extra components to invoice here
            invoice_flag_ := 'Y';
         ELSE
            -- clear invoice flag if already set...
            invoice_flag_ := 'N';
         END IF;

         IF (comprec_.component_invoice_flag_db != invoice_flag_) THEN
            Trace_SYS.Field('Modify invoice flag', invoice_flag_);
            Customer_Order_Delivery_API.Modify_Component_Invoice_Flag(comprec_.deliv_no, Invoice_Package_Component_API.Decode(invoice_flag_));
         END IF;
      END LOOP;
   END LOOP;
END Mark_Excess_Components___;


-- Book_Transaction___
--   Create special inventory transaction when COGS is posted at delivery confirmation.
--   And at the same time reduces the number of inventory parts "in transit" since they
--   are already delivery confirmed.
PROCEDURE Book_Transaction___ (
   deliv_no_     IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_line IS
      SELECT contract, part_no, catalog_no, configuration_id,
             cost, qty_shipped, catch_qty_shipped
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   line_item_no >= 0                 -- package parts are not included
      AND   deliv_no = deliv_no_
      AND   supply_code_db != 'SEO'
      AND   delay_cogs_to_deliv_conf_db = 'TRUE';
      
   CURSOR get_sum_qty IS
      SELECT sum(dcco.qty_shipped) 
      FROM DELIV_CONFIRM_CUST_ORDER dcco
      WHERE dcco.order_no = order_no_
      AND dcco.rel_no = rel_no_
      AND dcco.line_no =  line_no_
      AND dcco.line_item_no = line_item_no_ 
      AND dcco.date_confirmed IS NOT NULL;

   dummy_number_      NUMBER;
   transaction_code_  VARCHAR2(10);
   cost_detail_tab_   Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   qty_shipped_       NUMBER;
   dummy_string_      VARCHAR2(100);
   dummy_date_        DATE;
   cost_              NUMBER;
   attr_              VARCHAR2(32000);
BEGIN
   -- will find at most 1 delivery
   FOR linerec_ IN get_line LOOP
      -- Create a new inventory transaction
      IF (linerec_.part_no IS NULL) THEN
         transaction_code_  := 'OESHIPNI';

         Inventory_Transaction_Hist_API.Create_And_Account( transaction_id_     => dummy_number_,
                                                            accounting_id_      => dummy_number_,
                                                            value_              => dummy_number_,
                                                            transaction_code_   => transaction_code_,
                                                            contract_           => linerec_.contract,
                                                            part_no_            => linerec_.catalog_no,
                                                            configuration_id_   => linerec_.configuration_id,
                                                            location_no_        => NULL,
                                                            lot_batch_no_       => '*',
                                                            serial_no_          => '*',
                                                            waiv_dev_rej_no_    => '*',
                                                            eng_chg_level_      => '*',
                                                            activity_seq_       => 0,
                                                            project_id_         => NULL,
                                                            source_ref1_        => order_no_,
                                                            source_ref2_        => line_no_,
                                                            source_ref3_        => rel_no_,
                                                            source_ref4_        => line_item_no_,
                                                            source_ref5_        => deliv_no_,
                                                            reject_code_        => NULL,
                                                            cost_detail_tab_    => cost_detail_tab_,
                                                            unit_cost_          => linerec_.cost,
                                                            quantity_           => linerec_.qty_shipped,
                                                            qty_reversed_       => 0,
                                                            catch_quantity_     => NULL,
                                                            source_             => NULL,
                                                            source_ref_type_    => NULL,
                                                            owning_vendor_no_   => NULL,
                                                            condition_code_     => NULL,
                                                            location_group_     => NULL,
                                                            part_ownership_db_  => 'COMPANY OWNED',
                                                            owning_customer_no_ => NULL,
                                                            expiration_date_    => NULL);
      ELSE
         transaction_code_  := 'DELIVCONF';
         
         Inventory_Part_At_Customer_API.Decrease_Our_Qty_At_Customer(transaction_id_   => dummy_number_,
                                                                     contract_         => linerec_.contract,
                                                                     part_no_          => linerec_.part_no,
                                                                     configuration_id_ => dummy_string_,
                                                                     lot_batch_no_     => dummy_string_,
                                                                     serial_no_        => dummy_string_,
                                                                     eng_chg_level_    => dummy_string_,
                                                                     waiv_dev_rej_no_  => dummy_string_,
                                                                     activity_seq_     => dummy_number_,
                                                                     handling_unit_id_ => dummy_number_,
                                                                     customer_no_      => dummy_string_,
                                                                     addr_no_          => dummy_string_,
                                                                     expiration_date_  => dummy_date_,
                                                                     process_type_db_  => Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION,
                                                                     transaction_code_ => transaction_code_,
                                                                     project_id_       => NULL,
                                                                     source_ref1_      => order_no_,
                                                                     source_ref2_      => line_no_,
                                                                     source_ref3_      => rel_no_,
                                                                     source_ref4_      => line_item_no_,
                                                                     source_ref5_      => deliv_no_,
                                                                     quantity_         => linerec_.qty_shipped,
                                                                     catch_quantity_   => linerec_.catch_qty_shipped,
                                                                     scrap_cause_      => NULL,
                                                                     scrap_note_       => NULL); 
      END IF;
      IF (transaction_code_ = 'DELIVCONF') then
         OPEN get_sum_qty;
         FETCH  get_sum_qty INTO qty_shipped_;
         CLOSE get_sum_qty;
      ELSE 
         qty_shipped_ := Customer_Order_Line_API.Get_Qty_Shipped(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
      Deliver_Customer_Order_API.Modify_Order_Line_Cost(transaction_code_, order_no_, line_no_, rel_no_, line_item_no_, qty_shipped_);
      cost_ := Inventory_Transaction_Hist_API.Get_Cost(dummy_number_);
      Customer_Order_Delivery_API.Modify_Cost(deliv_no_, cost_);
      -- Update the Outstandinfg sales cost since the Customer_Order_Delivery_Tab cost has been changed in delivery confirmation.
      IF (line_item_no_ <= 0) THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('COST', cost_ , attr_);
         Outstanding_Sales_API.Modify(deliv_no_, attr_);   
      END IF;
   END LOOP;
END Book_Transaction___;


-- Check_Packages_To_Confirm___
--   Validates the maximum number of packages to confirm when there are partial
--   confirmation(s) already made on component level.
PROCEDURE Check_Packages_To_Confirm___ (
   deliv_no_            IN NUMBER,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   pkg_to_confirm_      IN NUMBER,
   pkg_revised_qty_due_ IN NUMBER )
IS
   -- fetch number of unconfirmed complete packages (per component) in sale unit
   CURSOR get_packages(pkg_revised_qty_due_ NUMBER) IS
      SELECT MIN(NVL(TRUNC(SUM(qty_shipped / (revised_qty_due / pkg_revised_qty_due_))), 0)) unconfirmed
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no > 0
      AND   confirm_deliveries_db = 'TRUE'
      AND   date_confirmed IS NULL
      AND   line_objstate != 'Cancelled'
      GROUP BY line_item_no;

   unconfirmed_  NUMBER;
BEGIN
   -- fetch min number of packages not yet confirmed on component level
   OPEN get_packages(pkg_revised_qty_due_);
   FETCH get_packages INTO unconfirmed_;
   CLOSE get_packages;
   unconfirmed_ := nvl(unconfirmed_, 0);

   -- check how many complete packages still left to confirm
   Trace_SYS.Message(to_char(pkg_to_confirm_) || ' > ' || to_char(unconfirmed_));

   -- error if trying to confirm too much
   IF (pkg_to_confirm_ > unconfirmed_) THEN
      Error_SYS.Record_General(lu_name_, 'PARTIALLYCONFIRMED: The package delivery :P1 has already been partially confirmed on component level. You can only confirm maximum :P2 complete packages.', deliv_no_, unconfirmed_);
   END IF;
END Check_Packages_To_Confirm___;


-- Get_Previous_Execution___
--   This function check whether another method is "Posted" or "Executing" in parallel in background jobs
--   with the same order_no and the delnote_no. If so, previous job_id is returned
FUNCTION Get_Previous_Execution___ (
   order_no_    IN VARCHAR2,
   del_note_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   msg_            VARCHAR2(32000);
   attrib_value_   VARCHAR2(32000);
   value_          VARCHAR2(2000);
   deferred_call_  VARCHAR2(200):= 'Deliv_Confirm_Cust_Order_API.Confirm_Delivery_Note';
   name_           VARCHAR2(30);
   job_id_value_   VARCHAR2(30);
   job_id_tab_     Message_SYS.Name_Table;
   attrib_tab_     Message_SYS.Line_Table;
   job_order_no_   VARCHAR2(12);
   job_delnote_no_ VARCHAR2(15);
   current_job_id_ NUMBER:=NULL;
   count_          NUMBER;
   ptr_            NUMBER;
   arg_tab_        Transaction_SYS.Arguments_Table;
BEGIN
   -- Get current job_id
   current_job_id_ := Transaction_SYS.Get_Current_Job_Id;
   -- Get current 'Posted' job arguments
   arg_tab_:= Transaction_SYS.Get_Posted_Job_Arguments(deferred_call_, NULL);   
   IF (arg_tab_.COUNT > 0) THEN
      FOR i_ IN arg_tab_.FIRST..arg_tab_.LAST LOOP
   
         job_id_value_   := arg_tab_(i_).job_id;
         attrib_value_   := arg_tab_(i_).arguments_string;

         ptr_ := NULL;
         -- Loop through the parameter list to check whether order_no and delnote_no exists
         WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
            IF (name_ = 'ORDER_NO') THEN
               job_order_no_ := value_;
            ELSIF (name_ = 'DELNOTE_NO') THEN
               job_delnote_no_ := value_;
            END IF;

            -- Check to see if another job of this type is posted
            IF ((NVL(current_job_id_, '-1') != NVL(job_id_value_, '-1')) AND (job_order_no_ = order_no_) AND (job_delnote_no_ = del_note_no_)) THEN    
               -- Return previous Execution
               RETURN job_id_value_;            
            END IF;  
            IF (job_delnote_no_ != Database_SYS.string_null_) THEN
               job_order_no_   := Database_SYS.string_null_;
               job_delnote_no_ := Database_SYS.string_null_;
            END IF;
         END LOOP;                          
      END LOOP;
   END IF;
   -- Get current 'Executing' job arguments
   Transaction_SYS.Get_Executing_Job_Arguments(msg_, deferred_call_);
   Message_SYS.Get_Attributes(msg_, count_, job_id_tab_, attrib_tab_);
   FOR i_ IN 1..count_ LOOP
      job_id_value_ := job_id_tab_(i_);
      attrib_value_ := attrib_tab_(i_);

      ptr_ := NULL;
      -- Loop through the parameter list to check whether order_no and delnote_no exists
      WHILE (Client_SYS.Get_Next_From_Attr(attrib_value_, ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_NO') THEN
            job_order_no_ := value_;
         ELSIF (name_ = 'DELNOTE_NO') THEN
            job_delnote_no_ := value_;
         END IF;
            
         -- Check to see if another job of this type is executing
         IF ((NVL(current_job_id_, '-1') != NVL(job_id_value_, '-1')) AND (job_order_no_ = order_no_) AND (job_delnote_no_ = del_note_no_)) THEN    
            -- Return previous Execution
            RETURN job_id_value_;            
         END IF; 
         IF (job_delnote_no_ != Database_SYS.string_null_) THEN
            job_order_no_   := Database_SYS.string_null_;
            job_delnote_no_ := Database_SYS.string_null_;
         END IF;
      END LOOP;                          
   END LOOP;
   -- No previous job_id found
   RETURN NULL;
END Get_Previous_Execution___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Modify__
--   Modifies both the delivery record and the oustanding sales record
--   at the same time.
--   Used by Update Delivery Confirmation clients to be able to handle
--   the possible warning message in a better way than publishing private F1
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   CURSOR get_delivery IS
      SELECT deliv_no, order_no, line_no, rel_no, line_item_no, confirm_deliveries_db,
             (qty_shipped / conv_factor * inverted_conv_factor) qty_to_confirm, incorrect_del_confirmation_db incorrect_db,
             qty_to_invoice qty_confirmed, line_objstate
      FROM CO_DELIVERY_JOIN
      WHERE objid = objid_;

   delivrec_          get_delivery%ROWTYPE;
   qty_confirmed_     NUMBER;
   incorrect_db_      VARCHAR2(2000);
   date_cogs_posted_  DATE;
   attr2_             VARCHAR2(32000);
   update_form_       BOOLEAN;
BEGIN
   -- dummy "column" saying which client the server call is made from... (CONFIRM or UPDATE)
   update_form_ := (nvl(Client_SYS.Get_Item_Value('CLIENT_FORM', attr_), ' ') != 'CONFIRM');

   Trace_SYS.Field('"Update" form', update_form_);

   OPEN get_delivery;
   FETCH get_delivery INTO delivrec_;
   CLOSE get_delivery;

   -- initial checks for update form.
   IF update_form_ THEN
      IF (delivrec_.line_item_no != 0) THEN
         Error_SYS.Record_General(lu_name_, 'MODIFYPACKAGE: Package and component deliveries may not be changed.');
      END IF;

      IF Cust_Delivery_Inv_Ref_API.Check_Exist(delivrec_.deliv_no) THEN
         Error_SYS.Record_General(lu_name_, 'DELIVIVC: The delivery :P1 has already been invoiced. Update is not allowed.', delivrec_.deliv_no);
      END IF;

      IF (delivrec_.confirm_deliveries_db = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'CONFDELIV: Delivery Confirmation is not used for delivery :P1. Update is not allowed.', delivrec_.deliv_no);
      END IF;

      IF (delivrec_.line_objstate = 'Invoiced' AND delivrec_.qty_confirmed = 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVOICEDCLOSEDLINE: Invoiced/Closed deliveries may not be modified');
      END IF;
   END IF;

   -- if any of the values are null means that the user hasn't modified it
   qty_confirmed_    := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_CONFIRMED', attr_));
   date_cogs_posted_ := trunc(Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('DATE_COGS_POSTED', attr_)));
   -- incorrect is null when updating a component
   incorrect_db_     := Client_SYS.Get_Item_Value('INCORRECT_DEL_CONFIRMATION_DB', attr_);

   Client_SYS.Clear_Attr(attr_);

   IF update_form_ THEN
      -- you can only change either qty and/or date - or incorrect flag - at once
      IF (qty_confirmed_ IS NOT NULL) OR (date_cogs_posted_ IS NOT NULL) THEN
         -- if qty and/or date is passed, uncheck incorrect checkbox
         incorrect_db_ := 'FALSE';
         Client_SYS.Add_To_Attr('INCORRECT_DEL_CONFIRMATION_DB', incorrect_db_, attr_);
      ELSIF (nvl(incorrect_db_, ' ') = 'TRUE') THEN
         -- don't update qty and date when just checking the incorrect checkbox
         qty_confirmed_ := NULL;
         date_cogs_posted_ := NULL;
      END IF;
   END IF;

   Trace_SYS.Field('QTY_CONFIRMED', qty_confirmed_);
   Trace_SYS.Field('DATE_COGS_POSTED', date_cogs_posted_);
   Trace_SYS.Field('INCORRECT_DEL_CONFIRMATION_DB', incorrect_db_);

   -- this check is made for both clients.
   IF (qty_confirmed_ IS NOT NULL) THEN
      IF (qty_confirmed_ > delivrec_.qty_to_confirm) THEN
         Error_SYS.Record_General(lu_name_, 'GREATER_SHIPPED: The confirmed quantity may not be greater than the shipped quantity.');
      ELSIF (qty_confirmed_ < 0) THEN
         Error_SYS.Record_General(lu_name_, 'LESS_ZERO: The confirmed quantity may not be less than zero.');
      END IF;
   -- mandatory check for confirm client
   ELSIF NOT update_form_ THEN
      Error_SYS.Record_General(lu_name_, 'NULLVALUE: Quantity confirmed is mandatory and requires a value.');
   END IF;

   IF (action_ = 'CHECK') THEN
      -- this check is made for both clients.
      IF (qty_confirmed_ = 0) OR (update_form_ AND qty_confirmed_ IS NULL AND delivrec_.qty_confirmed = 0) THEN
         Client_SYS.Add_Warning(lu_name_, 'CONFIRMED_ZERO: Qty confirmed is set to 0. This means that the status on CO line will be set to Invoiced/Closed if this is the last confirmation for this line. In that case it will not be possible to update this confirmation.');
      END IF;
      IF update_form_ AND (date_cogs_posted_ IS NOT NULL) THEN
         Client_SYS.Add_Warning(lu_name_, 'INVTRANSNOTUPD: The inventory transactions will not be updated with this new date. It has to be done manually.');
      END IF;
   ELSIF (action_ = 'DO') THEN
      -- Modify changed attributes on the delivery (don't update date confirmed)
      Customer_Order_Delivery_API.Modify_Delivery_Confirmed(delivrec_.deliv_no, qty_confirmed_, NULL, incorrect_db_);

      -- check delivery confirmed on the order line (to see if any confirmation is incorrect)
      Modify_Delivery_Confirmed___(delivrec_.order_no, delivrec_.line_no, delivrec_.rel_no, delivrec_.line_item_no);

      Client_SYS.Clear_Info; -- only info from outstanding sales (below) will be displayed...

      IF (delivrec_.line_item_no <= 0) THEN
         Client_SYS.Clear_Attr(attr2_);
         IF (qty_confirmed_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('QTY_EXPECTED', qty_confirmed_, attr2_);
         END IF;
         IF (date_cogs_posted_ IS NOT NULL) THEN
            Client_SYS.Add_To_Attr('DATE_COGS_POSTED', date_cogs_posted_, attr2_);
         END IF;
         -- Modify the attributes on Outstanding Sales
         IF (attr2_ IS NOT NULL) THEN
            Outstanding_Sales_API.Modify(delivrec_.deliv_no, attr2_);
         END IF;
      END IF;
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


-- Is_Excess_Component__
--   Returns true if the passed delivery contains any excess components.
--   Used inside DELIVUNION view.
@UncheckedAccess
FUNCTION Is_Excess_Component__ (
   deliv_no_     IN NUMBER,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_delivery IS
      SELECT order_no, line_no, rel_no, line_item_no, revised_qty_due,
             decode(date_confirmed, NULL, (qty_shipped / conv_factor * inverted_conv_factor), qty_to_invoice) qty_confirmed,
             line_objstate, incorrect_del_confirmation_db
      FROM CO_DELIVERY_JOIN
      WHERE deliv_no = deliv_no_;

   CURSOR get_package(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, incorrect_db_ VARCHAR2) IS
      SELECT deliv_no, revised_qty_due, decode(date_confirmed, NULL, (qty_shipped / conv_factor * inverted_conv_factor), qty_to_invoice) qty_confirmed
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = -1
      AND   line_objstate != 'Cancelled'
      AND   confirm_deliveries_db = 'TRUE'
      AND   incorrect_del_confirmation_db = incorrect_db_;

   CURSOR get_components(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2, line_item_no_ NUMBER,
                         deliv_no_ NUMBER, pkg_revised_qty_due_ NUMBER, incorrect_db_ VARCHAR2) IS
      SELECT NVL(SUM(decode(date_confirmed, NULL, (qty_shipped / conv_factor * inverted_conv_factor), qty_to_invoice) / (revised_qty_due / pkg_revised_qty_due_)), 0) qty_confirmed
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no = line_item_no_
      AND   deliv_no != deliv_no_
      AND   line_objstate != 'Cancelled'
      AND   confirm_deliveries_db = 'TRUE'
      AND   incorrect_del_confirmation_db = incorrect_db_
      GROUP BY line_item_no;

   delivrec_            get_delivery%ROWTYPE;
   package_exist_       BOOLEAN := FALSE;
   pkg_revised_qty_due_ NUMBER := 0;
   pkg_qty_             NUMBER := 0;
   comp_qty_            NUMBER := 0;
   qty_                 NUMBER;
   result_              VARCHAR2(5) := 'FALSE';
BEGIN
   -- only applicable for component lines
   IF (line_item_no_ > 0) THEN
      OPEN get_delivery;
      FETCH get_delivery INTO delivrec_;
      CLOSE get_delivery;

      FOR packrec_ IN get_package(delivrec_.order_no, delivrec_.line_no, delivrec_.rel_no,
                                  delivrec_.incorrect_del_confirmation_db) LOOP
         pkg_qty_             := pkg_qty_ + packrec_.qty_confirmed;
         pkg_revised_qty_due_ := packrec_.revised_qty_due;
         package_exist_       := TRUE;
      END LOOP;

      IF NOT package_exist_ THEN
         IF (delivrec_.line_objstate != 'Cancelled') THEN
            result_ := 'TRUE'; -- there are no package deliveries
         END IF;
      ELSE
         -- how many deliveries (except the passed) has been / will be confirmed for this component
         FOR comprec_ IN get_components(delivrec_.order_no, delivrec_.line_no, delivrec_.rel_no, line_item_no_,
                                        deliv_no_, pkg_revised_qty_due_, delivrec_.incorrect_del_confirmation_db) LOOP
            comp_qty_ := comp_qty_ + comprec_.qty_confirmed;
         END LOOP;

         -- add this delivery's quantity to see if it's a diff
         qty_ := delivrec_.qty_confirmed / (delivrec_.revised_qty_due / pkg_revised_qty_due_);
         IF ((comp_qty_ + qty_) > pkg_qty_) THEN
            result_ := 'TRUE';
         END IF;
      END IF;
   END IF;

   RETURN result_;
END Is_Excess_Component__;

-- Confirm_Delivery__
--   Performs Delivery confirmation on a specific delivery for an order line
--   that hasn't been confirmed yet.
--   Confirmed quantity is in sales unit.
PROCEDURE Confirm_Delivery__ (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   deliv_no_       IN NUMBER,
   qty_confirmed_  IN NUMBER,
   delnote_no_     IN NUMBER DEFAULT NULL,
   last_confirmed_ IN VARCHAR2 DEFAULT NULL)
IS
   -- Fetch all unconfirmed package component deliveries except the current one 
   CURSOR get_remaining_deliveries IS
      SELECT cod.deliv_no, cod.line_item_no, (cod.qty_shipped / col.conv_factor * col.inverted_conv_factor) qty_confirmed
      FROM customer_order_delivery_tab cod, customer_order_line_tab col
      WHERE col.order_no = order_no_ 
      AND   col.line_no = line_no_
      AND   col.rel_no = rel_no_
      AND   cod.order_no = col.order_no
      AND   cod.line_no = col.line_no
      AND   cod.rel_no = col.rel_no
      AND   cod.line_item_no = col.line_item_no
      AND   cod.cancelled_delivery = 'FALSE'
      AND   cod.incorrect_del_confirmation = 'FALSE'
      AND   cod.line_item_no > 0
      AND   (cod.deliv_no != deliv_no_ OR deliv_no_ IS NULL)
      AND   (cod.delnote_no = delnote_no_ OR delnote_no_ IS NULL)
      AND   cod.date_confirmed IS NULL;

   TYPE delivery_record IS RECORD (deliv_no NUMBER, line_item_no NUMBER, qty_confirmed NUMBER);
   delivery_rec_        delivery_record;
   old_delivery_rec_    delivery_record;
   temp_last_confirmed_ VARCHAR2(5);
TYPE get_remaining_deliveries_tab  IS TABLE OF get_remaining_deliveries%ROWTYPE  INDEX BY PLS_INTEGER;

   get_remaining_deliveries_tab_ get_remaining_deliveries_tab;
   temp_deliv_no_        NUMBER;
   temp_line_item_no_    NUMBER;
   temp_qty_confirmed_   NUMBER;
BEGIN

   IF (last_confirmed_ = 'TRUE') THEN
      -- Confirm all remaining unconfirmed package component deliveries not modified by the client
      OPEN get_remaining_deliveries;
      FETCH get_remaining_deliveries INTO delivery_rec_;
      LOOP
         IF (get_remaining_deliveries%FOUND) THEN
            old_delivery_rec_ := delivery_rec_;
         END IF;
         FETCH get_remaining_deliveries INTO delivery_rec_;
         EXIT WHEN get_remaining_deliveries%NOTFOUND;
         Confirm_Delivery( order_no_,
                           line_no_,
                           rel_no_,
                           old_delivery_rec_.line_item_no,
                           old_delivery_rec_.deliv_no,
                           old_delivery_rec_.qty_confirmed,
                           'FALSE',
                           'FALSE');

      END LOOP;
      IF (old_delivery_rec_.deliv_no IS NOT NULL) THEN
         IF (deliv_no_ IS NULL) THEN
            temp_last_confirmed_ := 'TRUE';
         ELSE
            temp_last_confirmed_ := 'FALSE';
         END IF;
         Confirm_Delivery( order_no_,
                           line_no_,
                           rel_no_,
                           old_delivery_rec_.line_item_no,
                           old_delivery_rec_.deliv_no,
                           old_delivery_rec_.qty_confirmed,
                           temp_last_confirmed_,
                           'FALSE');
      END IF;
      CLOSE get_remaining_deliveries;

   END IF;
   IF (deliv_no_ IS NOT NULL) THEN
      Confirm_Delivery( order_no_,
                        line_no_,
                        rel_no_,
                        line_item_no_,
                        deliv_no_,
                        qty_confirmed_,
                        last_confirmed_,
                        'TRUE');
   END IF;
END Confirm_Delivery__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Confirm_Delivery_Note
--   Performs Delivery confirmation on all deliveries not yet confirmed
--   for a delivery note.
--   If there are incorrect deliveries already confirmed then notify user.
--   Performs Delivery confirmation on all deliveries not yet confirmed
--   for a delivery note.
--   Called as background job from Start_Confirm_Order.
PROCEDURE Confirm_Delivery_Note (
   order_no_   IN VARCHAR2,
   delnote_no_ IN VARCHAR2 )
IS
   order_attr_    VARCHAR2(2000) := NULL; 
   next_event_    NUMBER;
   order_id_      customer_order.order_id%TYPE;

   CURSOR get_record IS
      SELECT deliv_no, order_no, line_no, rel_no, line_item_no,
             incorrect_del_confirmation_db, delay_cogs_to_deliv_conf_db, contract,
             revised_qty_due, (qty_shipped / conv_factor * inverted_conv_factor) qty_confirmed, line_objstate
      FROM DELIV_CONFIRM_CUST_ORDER
      WHERE order_no = order_no_
      AND   line_item_no <= 0
      AND   (date_confirmed IS NULL OR incorrect_del_confirmation_db = 'TRUE')
      AND   (delnote_no_ IS NULL OR delnote_no = delnote_no_)
      ORDER BY line_item_no, qty_confirmed;

   confirmed_  BOOLEAN := FALSE;
BEGIN
   -- confirm both packages, components and regular lines for a specific delivery note
   -- if there's no delivery note, confirm the whole order
   FOR rec_ IN get_record LOOP
      IF (rec_.line_item_no = -1) THEN
         Confirm_Delivery__(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, NULL, NULL, delnote_no_, 'TRUE');
      ELSE 
         Confirm___(rec_.deliv_no, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                    rec_.incorrect_del_confirmation_db, rec_.delay_cogs_to_deliv_conf_db,
                    rec_.contract, rec_.qty_confirmed);
      END IF;
      confirmed_ := TRUE;
   END LOOP;

   -- set invoice flag on confirmed excess components
   Mark_Excess_Components___(order_no_);

   IF confirmed_ THEN
      Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFH: Delivery Confirmed.'));
      order_id_ := customer_order_api.Get_Order_Id(order_no_);
      -- Event no 90 Delivery. If it is not stopped after Delivery it is let to continue
      next_event_ := Cust_Order_Type_Event_API.Get_Next_Event(order_id_, 90);
      IF next_event_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('START_EVENT', next_event_, order_attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', order_no_, order_attr_);
         Client_SYS.Add_To_Attr('END', '', order_attr_);
         Customer_Order_Flow_API.Start_Create_Delivery_Note(order_attr_);
      END IF;
   END IF;
END Confirm_Delivery_Note;


-- Confirm_Delivery_Note
--   Performs Delivery confirmation on all deliveries not yet confirmed
--   for a delivery note.
--   If there are incorrect deliveries already confirmed then notify user.
--   Performs Delivery confirmation on all deliveries not yet confirmed
--   for a delivery note.
--   Called as background job from Start_Confirm_Order.
PROCEDURE Confirm_Delivery_Note (
   attr_ IN VARCHAR2 )
IS
   order_no_    VARCHAR2(12);
   delnote_no_  VARCHAR2(15);
BEGIN
   order_no_   := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   delnote_no_ := Client_SYS.Get_Item_Value('DELNOTE_NO', attr_);

   Confirm_Delivery_Note(order_no_, delnote_no_);
END Confirm_Delivery_Note;


-- Confirm_Delivery
--   Performs Delivery confirmation on a specific delivery for an order line
--   that hasn't been confirmed yet.
--   Confirmed quantity is in sales unit.
PROCEDURE Confirm_Delivery (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   deliv_no_       IN NUMBER,
   qty_confirmed_  IN NUMBER,
   last_confirmed_ IN VARCHAR2 DEFAULT NULL,
   log_history_    IN VARCHAR2 DEFAULT 'TRUE')
IS
   CURSOR get_record IS
      SELECT deliv_no, order_no, line_no, rel_no, line_item_no, demand_code_db, delnote_no,
             incorrect_del_confirmation_db, delay_cogs_to_deliv_conf_db,
             contract, revised_qty_due, (qty_shipped / conv_factor * inverted_conv_factor) qty_to_confirm,
             conv_factor,inverted_conv_factor, line_objstate, date_confirmed
      FROM DELIV_CONFIRM_CUST_ORDER
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   deliv_no = deliv_no_;

   -- counts number of package deliveries left to confirm
   CURSOR get_remain_package(order_no_ VARCHAR2, line_no_ VARCHAR2, rel_no_ VARCHAR2) IS
      SELECT count(*) deliveries
      FROM CO_DELIVERY_JOIN
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = -1
      AND   date_confirmed IS NULL;

   confirmed_  BOOLEAN := FALSE;
   partial_    BOOLEAN;
   pkg_remain_ NUMBER;
   qty_remain_ NUMBER;
BEGIN
   IF (qty_confirmed_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NULLVALUE: Quantity confirmed is mandatory and requires a value.');
   ELSIF (qty_confirmed_ < 0) THEN
      Error_SYS.Record_General(lu_name_, 'LESS_ZERO: The confirmed quantity may not be less than zero.');
   END IF;

   FOR rec_ IN get_record LOOP
      IF (rec_.date_confirmed IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'ALREADY_CONFIRMED: The delivery :P1 has already been confirmed. Use the "Update Delivery Confirmation" window to change it.', deliv_no_);
      END IF;

      IF (qty_confirmed_ > rec_.qty_to_confirm) THEN
         Error_SYS.Record_General(lu_name_, 'GREATER_SHIPPED: The confirmed quantity may not be greater than the shipped quantity.');
      ELSIF (rec_.line_item_no = -1) THEN
         -- check maximum qty to confirm for the package
         Check_Packages_To_Confirm___(rec_.deliv_no, rec_.order_no, rec_.line_no, rec_.rel_no,
                                      qty_confirmed_, rec_.revised_qty_due);
      END IF;

      -- don't update order line's confirmed flag yet - we might need to confirm more deliveries below first
      Confirm___(rec_.deliv_no, order_no_, line_no_, rel_no_, rec_.line_item_no,
                 rec_.incorrect_del_confirmation_db, rec_.delay_cogs_to_deliv_conf_db,
                 rec_.contract, qty_confirmed_, FALSE);

      -- confirm all components belonging to the package
      IF (rec_.line_item_no = -1) THEN
         Confirm_Package_Components___(rec_.order_no, rec_.line_no, rec_.rel_no, qty_confirmed_,
                                       rec_.qty_to_confirm, rec_.revised_qty_due, rec_.delnote_no);

      -- confirm package (it holds the outstanding sales record) if all components -
      -- adding up to at least one complete package - have been confirmed
      ELSIF (rec_.line_item_no > 0) THEN
         IF ( rec_.demand_code_db = 'IPT') THEN
	        -- if there are more than one package delivery to confirm and there's a rest for this component
	        -- create a new delivery (copy) for the remaining qty
	        pkg_remain_ := 0;
	        partial_ := (Customer_Order_Line_API.Get_Objstate(rec_.order_no, rec_.line_no, rec_.rel_no, -1) = 'PartiallyDelivered');

	        IF NOT partial_ THEN
	           -- count how many package deliveries there are left to confirm -
	           -- if partial is true, it means the package header is still in status Partially Delivered
	           FOR remain_ IN get_remain_package(rec_.order_no, rec_.line_no, rec_.rel_no) LOOP
	              pkg_remain_ := pkg_remain_ + remain_.deliveries;
	           END LOOP;
	        END IF;

	        IF (qty_confirmed_ > 0) THEN
	           qty_remain_ := rec_.qty_to_confirm - qty_confirmed_;
	        ELSE
	           qty_remain_ := 0;
	        END IF;

	        -- if there's more than one remaining package delivery - or the package is still partially delivered -
	        -- move remaining qty to new record for future full delivery!
	        IF ((pkg_remain_ > 1) OR partial_) AND (qty_remain_ > 0) THEN
	           Customer_Order_Delivery_API.Reduce_And_Copy(rec_.deliv_no, (qty_remain_ * rec_.conv_factor/ rec_.inverted_conv_factor));
	        END IF;
         END IF;
         IF (last_confirmed_ = 'TRUE') THEN
            Confirm_Package_If_Complete___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.delnote_no);
         END IF;
      END IF;

      -- to create the transaction with correct quantity - this call is made here: after the
      -- reduction of shipped qty.
      Book_Transaction___(rec_.deliv_no, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);

      -- check if order line can be set to confirmed (this is not made in Confirm___ in this case)
      Modify_Delivery_Confirmed___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);

      confirmed_ := TRUE;
   END LOOP;

   IF (last_confirmed_ = 'TRUE') THEN
      -- set invoice flag on confirmed excess components
      Mark_Excess_Components___(order_no_, line_no_, rel_no_);
   END IF;

   IF confirmed_ AND log_history_ = 'TRUE' AND NVL(last_confirmed_, 'TRUE') = 'TRUE' THEN
      Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'DELIVCONFH: Delivery Confirmed.'));
   END IF;
END Confirm_Delivery;


-- This method is used by DataCaptDelivConfirmCo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_           IN VARCHAR2,
   order_no_           IN VARCHAR2,
   delnote_no_         IN VARCHAR2,
   shipment_id_        IN VARCHAR2,
   capture_session_id_ IN VARCHAR2,
   column_name_        IN VARCHAR2,
   lov_type_db_        IN VARCHAR2 )
IS
   TYPE Get_Lov_Values   IS REF CURSOR;
   TYPE Lov_Value_Tab    IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   get_lov_values_       Get_Lov_Values;
   lov_value_tab_        Lov_Value_Tab;
   stmt_                 VARCHAR2(4000);
   delnote_no_in_a_loop_ BOOLEAN := FALSE;
   session_rec_          Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_   NUMBER;
   exit_lov_             BOOLEAN := FALSE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN    
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_ || ' FROM  CO_DELIVERY_JOIN
                          WHERE confirm_deliveries_db          = ''TRUE''
                          AND   consignment_stock_db           = ''NO CONSIGNMENT STOCK''
                          AND   contract                       = NVL(:contract,    contract        )
                          AND   order_no                       = NVL(:order_no,    order_no        )
                          AND   ((delnote_no  = :delnote_no_) OR (delnote_no IS NULL AND :delnote_no_ IS NULL) OR (:delnote_no_ = ''%''))
                          AND   ((shipment_id  = :shipment_id_) OR (shipment_id IS NULL AND :shipment_id_ IS NULL) OR (:shipment_id_ = -1))
                          AND   (date_confirmed IS NULL OR incorrect_del_confirmation_db = ''TRUE'')
                          AND   EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site   = contract)';
      
      IF (column_name_ = 'DELNOTE_NO') THEN
         session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
         IF (Data_Capt_Conf_Data_Item_API.Is_Data_Item_In_A_Loop(session_rec_.capture_process_id, session_rec_.capture_config_id, column_name_)) THEN
            stmt_ := stmt_ || ' AND NOT EXISTS (SELECT 1 FROM DATA_CAPTURE_SESSION_LINE_PUB WHERE capture_session_id = :capture_session_id
                                                                                              AND data_item_id = ''DELNOTE_NO''
                                                                                              AND data_item_detail_id IS NULL
                                                                                              AND data_item_value = delnote_no ) '; 
            delnote_no_in_a_loop_ := TRUE;
            -- TODO: will this work for NULL delnotes?
         END IF;
      END IF;
      
      stmt_ := stmt_  || ' ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
 
      IF (delnote_no_in_a_loop_) THEN
         @ApproveDynamicStatement(2014-08-13,ROJALK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              order_no_,
                                              delnote_no_,
                                              delnote_no_,
                                              delnote_no_,
                                              shipment_id_,
                                              shipment_id_,
                                              shipment_id_,
                                              capture_session_id_;
      ELSE
         @ApproveDynamicStatement(2014-08-13,ROJALK)
         OPEN get_lov_values_ FOR stmt_ USING contract_,
                                              order_no_,
                                              delnote_no_,
                                              delnote_no_,
                                              delnote_no_,
                                              shipment_id_,
                                              shipment_id_,
                                              shipment_id_;
      END IF;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptDelivConfirmCo
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_     IN VARCHAR2,
   order_no_     IN VARCHAR2,
   delnote_no_   IN VARCHAR2,
   shipment_id_  IN VARCHAR2,
   column_name_  IN VARCHAR2,
   column_value_ IN VARCHAR2 )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(4000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('CO_DELIVERY_JOIN', column_name_);

   stmt_ := 'SELECT 1  
             FROM  CO_DELIVERY_JOIN
             WHERE confirm_deliveries_db          = ''TRUE''
             AND   consignment_stock_db           = ''NO CONSIGNMENT STOCK''
             AND   contract                       = NVL(:contract,    contract        )
             AND   order_no                       = NVL(:order_no,    order_no        )
             AND   ((delnote_no  = :delnote_no_) OR (delnote_no IS NULL AND :delnote_no_ IS NULL) OR (:delnote_no_ = ''%''))
             AND   ((shipment_id  = :shipment_id_) OR (shipment_id IS NULL AND :shipment_id_ IS NULL) OR (:shipment_id_ = -1))
             AND   (date_confirmed IS NULL OR incorrect_del_confirmation_db = ''TRUE'')
             AND   EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site   = contract) ';

   IF (column_name_ IN ('DELNOTE_NO', 'SHIPMENT_ID')) THEN
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL))';
   ELSE
      stmt_ := stmt_ || ' AND '|| column_name_ ||' = :column_value_ ';
   END IF;


   IF (column_name_ IN ('DELNOTE_NO', 'SHIPMENT_ID')) THEN
      @ApproveDynamicStatement(2014-08-13,ROJALK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          order_no_,
                                          delnote_no_,
                                          delnote_no_,
                                          delnote_no_,
                                          shipment_id_,
                                          shipment_id_,
                                          shipment_id_,
                                          column_value_,
                                          column_value_;

   ELSE
      @ApproveDynamicStatement(2014-08-13,ROJALK)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          order_no_,
                                          delnote_no_,
                                          delnote_no_,
                                          delnote_no_,
                                          shipment_id_,
                                          shipment_id_,
                                          shipment_id_,
                                          column_value_;
   END IF;
                                                    
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: The value :P1 does not exist for current delivery confirmation.', column_value_);
   END IF;
END Record_With_Column_Value_Exist;


-- Excess_Components
--   Returns whether there are more/extra components than complete packages
--   delivered for a specific package part. Including incorrect deliveries.
--   Used by confirmation client.
@UncheckedAccess
FUNCTION Excess_Components (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   rel_no_          IN VARCHAR2,
   line_item_no_    IN NUMBER,
   qty_confirmed_   IN NUMBER,
   revised_qty_due_ IN NUMBER ) RETURN VARCHAR2
IS
   result_  VARCHAR2(5) := 'FALSE';

   CURSOR get_component IS
      SELECT 'TRUE'
      FROM DELIV_CONFIRM_CUST_ORDER
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no > 0
      AND   ((((qty_shipped / conv_factor * inverted_conv_factor) / (revised_qty_due / revised_qty_due_) > qty_confirmed_)
               AND date_confirmed IS NULL) OR
            ((qty_to_invoice / (revised_qty_due / revised_qty_due_) > qty_confirmed_)
              AND date_confirmed IS NOT NULL));
BEGIN
   IF (line_item_no_ = -1) THEN
      OPEN get_component;
      FETCH get_component INTO result_;
      IF get_component%NOTFOUND THEN
         result_ := 'FALSE';
      END IF;
      CLOSE get_component;
   END IF;

   RETURN result_;
END Excess_Components;


-- This method is used by DataCaptDelivConfirmCo
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_    IN VARCHAR2,
   order_no_    IN VARCHAR2,
   delnote_no_  IN VARCHAR2,
   shipment_id_ IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(4000);
   column_value_        VARCHAR2(50);
   unique_column_value_ VARCHAR2(50);
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('CO_DELIVERY_JOIN', column_name_);

   stmt_ := 'SELECT ' || column_name_ || '
             FROM  CO_DELIVERY_JOIN
             WHERE confirm_deliveries_db          = ''TRUE''
             AND   consignment_stock_db           = ''NO CONSIGNMENT STOCK''
             AND   contract                       = NVL(:contract,    contract        )
             AND   order_no                       = NVL(:order_no,    order_no        )
             AND   ((delnote_no  = :delnote_no_) OR (delnote_no IS NULL AND :delnote_no_ IS NULL) OR (:delnote_no_ = ''%''))
             AND   ((shipment_id  = :shipment_id_) OR (shipment_id IS NULL AND :shipment_id_ IS NULL) OR (:shipment_id_ = -1))
             AND   (date_confirmed IS NULL OR incorrect_del_confirmation_db = ''TRUE'')
             AND   EXISTS (SELECT 1 FROM user_allowed_site_pub WHERE site   = contract)';
             
   @ApproveDynamicStatement(2014-08-13,ROJALK)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           order_no_,
                                           delnote_no_,
                                           delnote_no_,
                                           delnote_no_,
                                           shipment_id_,
                                           shipment_id_,
                                           shipment_id_;
   LOOP
      FETCH get_column_values_ INTO column_value_;
      EXIT WHEN get_column_values_%NOTFOUND;
      -- make sure NULL values are handled also
      IF (column_value_ IS NULL) THEN
         column_value_ := 'NULL';
      END IF;

      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := column_value_;
      ELSIF (unique_column_value_ != column_value_) THEN
         unique_column_value_ := NULL;
         EXIT;
      END IF;

   END LOOP;
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- Deliv_Confirm_Allowed
--   Returns whether or not it's allowed to perform delivery confirmation.
--   Used from CustomerOrderFlow.
@UncheckedAccess
FUNCTION Deliv_Confirm_Allowed (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   allowed_  NUMBER;

   CURSOR deliv_conf IS
      SELECT 1
      FROM   DELIV_CONFIRM_CUST_ORDER
      WHERE  order_no = order_no_
      AND    date_confirmed IS NULL;
BEGIN
   OPEN deliv_conf;
   FETCH deliv_conf INTO allowed_;
   IF (deliv_conf%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE deliv_conf;

   RETURN allowed_;
END Deliv_Confirm_Allowed;



-- Start_Confirm_Order
--   Confirms a number of customer orders or delivery notes at the same time -
--   as background jobs.
--   Called from the Delivery Confirmation client.
PROCEDURE Start_Confirm_Order (
   attr_ IN VARCHAR2 )
IS
   ptr_                   NUMBER := NULL;
   name_                  VARCHAR2(35);
   value_                 VARCHAR2(2000);
   order_no_              VARCHAR2(12) := NULL;
   delnote_no_            VARCHAR2(15) := NULL;
   delattr_               VARCHAR2(2000);
   description_           VARCHAR2(2000);
   previous_execution_id_ NUMBER;
   alt_delnote_no_        VARCHAR2(50);
BEGIN
   description_ := Language_SYS.Translate_Constant(lu_name_, 'DELCONFBACK: Delivery Confirm Customer Order');

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         order_no_ := value_;
      ELSIF (name_ = 'DELNOTE_NO') THEN
         delnote_no_ := value_;
      ELSIF (name_ = 'END') THEN
         IF (order_no_ IS NOT NULL) THEN
            Client_SYS.Clear_Attr(delattr_);
            Client_SYS.Add_To_Attr('ORDER_NO', order_no_, delattr_);
            Client_SYS.Add_To_Attr('DELNOTE_NO', delnote_no_, delattr_);
            previous_execution_id_ := Get_Previous_Execution___ (order_no_, delnote_no_);
            IF (previous_execution_id_ IS NOT NULL) THEN
               alt_delnote_no_ := Delivery_Note_API.Get_Alt_Delnote_No(delnote_no_);
               Error_SYS.Record_General(lu_name_, 'SAMEDELCONFEXIST: Delivery confirmation for the delivery note :P1 of the order :P2 is already being processed by the background job :P3', alt_delnote_no_, order_no_, TO_CHAR(previous_execution_id_));
            ELSE
               Transaction_SYS.Deferred_Call('DELIV_CONFIRM_CUST_ORDER_API.Confirm_Delivery_Note', delattr_, description_);
            END IF;
         END IF;

         order_no_   := NULL;
         delnote_no_ := NULL;
      END IF;
   END LOOP;
END Start_Confirm_Order;



