-----------------------------------------------------------------------------
--
--  Logical unit: CloseCustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210614  KiSalk  Bug 157257(SCZ-14970), Modified Close_Package_Header___ to consider delivery confirmation differences.
--  201014  ApWilk  Bug 150558 (SCZ-11847), Modified Close_Order__ and Close_Order_Line__ to check if the CO header or line contains any incomplete staged biiling lines
--  201014          before closing the CO or the CO line.
--  190930  SURBLK  Added Raise_Manually_Closed_Error___ to handle error messages and avoid code duplication.
--  180508  UdGnlk  Bug 141225, Modified Close_Simple_Line___() when supply code IPD for stage billing invoiced customer order line.   
--  170927  RaVdlk  STRSC-11152,Removed Customer_Order_API.Get_State__() and replaced with Customer_Order_API.Get_State ()
--  170927  RaVdlk  STRSC-11152, Removed Customer_Order_Line_API.Get_State__() and replaced with Customer_Order_Line_API.Get_State ()
--  170921  KiSalk  Bug 137908, Moved check for existance of rental periods from Close_Simple_Line___ to Clear_Reservations___, considering tracking.
--  170614  NiLalk  Bug 134157, Modified Close_Package___, by adding an error message to raise when the customer order line is to be closed.
--  170131  MaEelk   LIM-10488, passed inventory_ivent_id_ to Customer_Order_Reservation_API.Remove
--  151215  RoJalk  LIM-5387, Added source ref type to Shipment_Line_API.Release_Not_Reserved_Qty_Line method.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151109  MaEelk  LIM-4453, Removed pallet_id_ from Customer_Order_Reservation_API calls
--  151105  UdGnlk  LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  150526  IsSalk  KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150423  Chfose  LIM-1781, Fixed calls by including handling_unit_id from CUSTOMER_ORDER_RESERVATION_TAB.
--  150417  MaEelk  LIM-1058, Added dummy parameter handling_unit_id_ 0 to the Inventory_Part_In_Stock_API and Inventory_Part_Loc_Pallet_API.
--  140808  RoJalk  Modified Close_Order_Line___ replaced Shipment_Order_Line_API.Remove_Active_Shipments with Release_Not_Reserved_Qty_Line.
--  140604  NaLrlk  Modified Close_Simple_Line___ to consider the on rental period when cancellation.
--  130620  RoJalk  Modified Close_Order_Line___ and removed the checks for order line states since Shipment_Order_Line_API.Remove_Active_Shipments will filter  picked and delivered lines.
--  130612  IsSalk  Bug 110141, Modified Close_Package_Header___() to mark component lines of partially delivered packages for invoicing.
--  121031  RoJalk  Allow connecting a customer order line to several shipment lines- modified Clear_Reservations___ and passed  
--  121031          shipment_id to the method Customer_Order_Reservation_API.Remove
--  121008  RoJalk  Bug 105449, Modified Close_Package_Header___() not to having null for qty_shipdiff, when component parts not available in package part.
--  120708  RoJalk  Modified Close_Order_Line___ and called Shipment_Order_Line_API.Remove_Active_Shipments since one order line can have multiple shipments connected.
--  100512  Ajpelk  Merge rose method documentation
--  ------------------------------Eagle------------------------------------------
--  100317  SuThlk  Bug 89440, Extended correction for 88761 to invoiced lines.
--  100222  SuThlk  Bug 88761, Added logic in Close_Order_Line___ to disconnect shipment for the delivered lines.
--  060524  MiKulk  Changed the coding to remove LU dependancies for deployment order.
--  -----------------------------------13.4.0--------------------------------
--  050929  DaZase  Added configuration_id/activity_seq in call to Inventory_Part_Loc_Pallet_API method.
--  050920  NaLrlk  Removed unused variables.
--  050505  LaBolk  Bug 50111, Modified Close_Simple_Line___ to remove the existing check and error message for closing CO line.
--  050505          A new condition and an error message was added instead. Modified Clear_Reservations___ to remove reservation records.
--  041028  DiVelk  Modified Close_Simple_Line___.
--  041028  UdGnlk  Bug 47305, Modified Close_Simple_Line___ to handle shortages when closing manually.
--  041014  SaJjlk  Added parameter catch_quantity_ to method calls Inventory_Part_In_Stock_API.Reserve_Part.
--  041011  DaZase  Made method Clear_Reservations___ work with Project Inventory.
--  040929  DaZase  Added activity_seq to call Customer_Order_Reservation_API.Modify_Qty_Assigned.
--  040826  GeKalk  Added a new public method Close_Co_Connected_To_Do.
--  040825  DaRulk  Modified Clear_Reservations___ to include input uom parametrs.
--  040510  DaZaSe  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  -------------------------------- 13.3.0 ----------------------------------
--  030729  UdGnlk  Performed SP4 Merge.
--  030422  Kadilk  Bug 36907, Modified procedure Close_Simple_Line___ to compare qty_picked with
--                  buy_qty_due instead of desired_qty.
--  030409  GeKaLk  Done code review modifications.
--  030331  GeKaLk  Modified Close_Simple_Line___() to change the constant of the error for manually pegged lines.
--  030331  GeKaLk  Modified Close_Simple_Line___() to check for manually pegged lines.
--  021212  Asawlk  Merged bug fixes in 2002-3 SP3
--  021002  Hecese Bug 32477, Modified procedure Close_Simple_Line___ so that an overpicked line cannot be
--          closed. Also modified error message.
--  020404  Samnlk Call fix 77403 ,Modify Clear_Reservations___.
--  020402  Samnlk Call fix 77403 ,Modify Clear_Reservations___.
--  020328  Samnlk Call fix 77403 ,Modify Clear_Reservations___.
--  010601  ViPa  Bug fix 19701, Added the error msg to Close_Simple_Line___ again
--                with a change to the condition on which it is raised.
--  010601  OsAllk Bug Fix 19741,Added PROCEDURE Connected_To_Purchase_Order.
--  010525  ViPa  Bug fix 19701, Removed the error msg from Close_Simple_Line___ which pops up when qty on other orders are > 0.
--  001020  JAkH  Changed Clear_Reservations___ to handle configuration_id, to reserve in inventory_part_in_stock
--  000913  FBen  Added UNDEFINE.
--  990426  JoAn  Corrected message syntax in call to Translate_Constant.
--  990422  RaKu  Y.Cleanup.
--  990415  JakH  Y. Close_Simple_Line___ modified to use public-rec of ordrow.
--  990409  JakH  Use tables instead of views.
--  980305  JoAn  Heat Id 3469 Clear reservations instead of removing them
--                when line is closed. Remove_Reservations___ renamed to
--                Clear_Reservations___.
--  980216  JoAn  Heat Id 3002  Not possible to close an order line.
--                Removed status check in Close_Order_Line__
--  971120  RaKu  Changed to FND200 Templates.
--  971007  JoAn  Rewrote the code for closing packages and package components.
--                Renamed Mark_Components_For_Invoice___ to Close_Package_Header___.
--  970926  JoAn  Changed cursor get_components in Mark_Components_For_Invoice___
--                to avoid problems when revised_qty_due = 0 ('Cancelled' lines)
--  970919  JoAn  Bug 97-0116 Corrected bug in Mark_Components_For_Invoice___
--                components were not correctly marked for invoicing.
--  970610  JoAn  Corrected bug in cursor in Close_Package___
--  970609  JoAn  Added condition qty_shipped = 0 to cursor in Remove_Reservations___
--                Also changed Close_Simple_Line___ so that reservations are
--                removed before setting qty_shipdiff (which might set status to 'Invoiced')
--  970609  JoAn  Rewrote code for closing packages and package components.
--  970606  JoAn  Changed cursor in Close_Package___ not to close delivered lines
--  970528  JoAn  Fixed bug in Close_Simple_Line___ assignment of revised_qty_due_
--                Added call to Customer_Order_API.Set_Line_Qty_Assigned in
--                Remove_Reservations___
--  970428  RaKu  Added pallet_id in calls to customer_order_reservation.
--  970422  JoAn  Removed all references to status_code
--  970418  JoAn  Added call to Customer_Order_API.Set_Line_Qty_Shipdiff in
--                Close_Simple_Line___
--  961211  JoAn  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Clear_Reservations___
--   Clear all reservations not pick reported in CustomerOrderReservation and
--   InventoryPartLocation when closing an order line.
PROCEDURE Clear_Reservations___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   qty_assigned_        customer_order_line_tab.qty_assigned%TYPE;
   dummy_number_        NUMBER;

   CURSOR get_reservations IS
      SELECT qty_assigned,
             part_no,
             contract,
             location_no,
             lot_batch_no,
             serial_no,
             waiv_dev_rej_no,
             eng_chg_level,
             pick_list_no,
             configuration_id,
             activity_seq,
             handling_unit_id,
             shipment_id,
             input_qty,
             input_unit_meas,
             input_conv_factor,
             input_variable_values
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    qty_picked = 0
      AND    qty_shipped = 0
      AND    pick_list_no = '*';
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR res_rec_ in get_reservations LOOP
      Inventory_Part_In_Stock_API.Reserve_Part(catch_quantity_          => dummy_number_, 
                                               contract_                => res_rec_.contract, 
                                               part_no_                 => res_rec_.part_no, 
                                               configuration_id_        => res_rec_.configuration_id,
                                               location_no_             => res_rec_.location_no, 
                                               lot_batch_no_            => res_rec_.lot_batch_no,
                                               serial_no_               => res_rec_.serial_no, 
                                               eng_chg_level_           => res_rec_.eng_chg_level,
                                               waiv_dev_rej_no_         => res_rec_.waiv_dev_rej_no, 
                                               activity_seq_            => res_rec_.activity_seq, 
                                               handling_unit_id_        => res_rec_.handling_unit_id,
                                               quantity_                => -res_rec_.qty_assigned);
     
      Customer_Order_Reservation_API.Remove(order_no_           => order_no_, 
                                            line_no_            => line_no_, 
                                            rel_no_             => rel_no_, 
                                            line_item_no_       => line_item_no_,
                                            contract_           => res_rec_.contract, 
                                            part_no_            => res_rec_.part_no,
                                            location_no_        => res_rec_.location_no, 
                                            lot_batch_no_       => res_rec_.lot_batch_no,
                                            serial_no_          => res_rec_.serial_no, 
                                            eng_chg_level_      => res_rec_.eng_chg_level,
                                            waiv_dev_rej_no_    => res_rec_.waiv_dev_rej_no, 
                                            activity_seq_       => res_rec_.activity_seq,
                                            handling_unit_id_   => res_rec_.handling_unit_id,
                                            pick_list_no_       => res_rec_.pick_list_no, 
                                            configuration_id_   => res_rec_.configuration_id, 
                                            shipment_id_        => res_rec_.shipment_id);

      qty_assigned_ := Customer_Order_Line_API.Get_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_);
      Customer_Order_API.Set_Line_Qty_Assigned(order_no_, 
                                               line_no_, 
                                               rel_no_, 
                                               line_item_no_,
                                               qty_assigned_ - res_rec_.qty_assigned);

      $IF Component_Rental_SYS.INSTALLED $THEN
         IF (Customer_Order_Line_API.Get_Rental_Db(order_no_, line_no_, rel_no_, line_item_no_) = Fnd_Boolean_API.DB_TRUE) THEN
            IF (Rental_Object_Manager_API.On_Rental_Period_Qty_Exist(order_no_,
                                                                     line_no_,
                                                                     rel_no_,
                                                                     line_item_no_,   
                                                                     Rental_Type_API.DB_CUSTOMER_ORDER,
                                                                     res_rec_.lot_batch_no,
                                                                     res_rec_.serial_no,
                                                                     0)) THEN
               Error_SYS.Record_General(lu_name_, 'NOTCLEARRENTALRES: Close is not allowed when customer order lines have reservations for which rental periods exist. Please remove the rental periods by creating correction rental events.');
            END IF;
         END IF;
      $END

   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Clear_Reservations___;


-- Mark_Component_For_Invoice___
--   Called when an order is closed. Sets the component_invoice_flag
--   for all deliveries for the component in CustomerOrderDelivery
--   in order to force invoicing of the component.
PROCEDURE Mark_Component_For_Invoice___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_deliveries IS
      SELECT deliv_no
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   FOR delivery_rec_ IN get_deliveries LOOP
      -- Set the component_invoice_flag for the delivery record in order to force invoiceing.
      Customer_Order_Delivery_API.Modify_Component_Invoice_Flag
        (delivery_rec_.deliv_no, Invoice_Package_Component_API.Decode('Y'));
   END LOOP;
END Mark_Component_For_Invoice___;


-- Close_Simple_Line___
--   Close a line which may be an ordinary line (line_item_no = 0 ) or a
--   line which is part of a package (line_item_no > 0).
PROCEDURE Close_Simple_Line___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   CURSOR get_invoiced_stages IS
      SELECT 1
      FROM ORDER_LINE_STAGED_BILLING_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   rowstate     = 'Invoiced';
      
   stage_invoiced_   NUMBER;
   linerec_          Customer_Order_Line_API.public_rec;
BEGIN
   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   -- Note: If qty_on_order > 0 and supply_code is 'IO' or 'PS' then there exist a connected order for this.
   IF (linerec_.qty_on_order > 0 AND linerec_.supply_code IN ('IO','PS')) THEN
       Error_SYS.Record_General(lu_name_,'PEG_CLOSE: There are manual peggings connected to this customer order line. Remove the pegging first, then close the customer order line.');
   END IF;

   IF (Reserve_Customer_Order_API.Unpicked_Picklist_Exist__(order_no_, line_no_, rel_no_, line_item_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'RESWITHPICKLIST: Close is not allowed when the order line has reservations for which pick list has been created. Use report picking with differences instead.');
   END IF;
   
   OPEN get_invoiced_stages;
   FETCH get_invoiced_stages INTO stage_invoiced_;
   CLOSE get_invoiced_stages;   

   IF ((linerec_.rowstate = 'Released') AND (stage_invoiced_ = 1) AND (linerec_.supply_code = 'IPD')) THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWTOCLOSED: Close is not allowed for a Customer Order Line with the supply code Internal Purchase Direct, use Unpeg from Customer Order Line or Purchase Order Line instead.');
   END IF;

   IF (linerec_.part_no IS NULL) THEN
      -- Note: Not an inventory part => Set qty_to_ship to 0
      Customer_Order_Line_API.Modify_Qty_To_Ship__(order_no_, line_no_, rel_no_, line_item_no_, 0);
   ELSE
      -- Note: Remove reservations for this line if any
      Clear_Reservations___(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   IF (Customer_Order_Shortage_API.Check_Exist(order_no_, line_no_, rel_no_, line_item_no_)) THEN
      Customer_Order_Shortage_API.Remove(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   IF (linerec_.qty_short != 0) THEN
      Customer_Order_Line_API.Set_Qty_Short(order_no_, line_no_, rel_no_, line_item_no_, 0);
   END IF;

   Customer_Order_API.Set_Line_Qty_Shipdiff
     (order_no_, line_no_, rel_no_, line_item_no_,
      linerec_.qty_shipped + linerec_.qty_picked - linerec_.revised_qty_due );

   Update_License_Coverage_Qty___(order_no_, line_no_, rel_no_, line_item_no_, linerec_.revised_qty_due - linerec_.qty_shipped);   

   Customer_Order_Line_Hist_API.New
     (order_no_, line_no_, rel_no_, line_item_no_, Raise_Manually_Closed_Error___);

END Close_Simple_Line___;


-- Close_Package_Header___
--   Close a package header row.
--   The component_invoice_flag will be set for package components
--   for which separate invoice lines should be created.
PROCEDURE Close_Package_Header___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 )
IS
   pkg_revised_qty_due_ customer_order_line_tab.revised_qty_due%TYPE;
   qty_shipdiff_        customer_order_line_tab.qty_shipdiff%TYPE;
   no_of_packages_      NUMBER;
   no_of_packages_conf_ NUMBER;

   CURSOR no_of_packages(pkg_revised_qty_due_ NUMBER) IS
      SELECT NVL(MIN(TRUNC((qty_picked + qty_shipped) * pkg_revised_qty_due_ / revised_qty_due)), 0) no_of_packages,
             NVL(MIN(TRUNC((qty_picked + qty_shipped + qty_confirmeddiff) * pkg_revised_qty_due_ / revised_qty_due)), 0) no_of_packages_conf
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled';


   CURSOR get_components(pkg_revised_qty_due_ NUMBER,
                         no_of_packages_      NUMBER) IS
      SELECT line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled'
      AND    (qty_picked + qty_shipped) * pkg_revised_qty_due_  > no_of_packages_ * revised_qty_due;

BEGIN
   pkg_revised_qty_due_ := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1);

   OPEN no_of_packages(pkg_revised_qty_due_);

   FETCH no_of_packages INTO no_of_packages_, no_of_packages_conf_;
   CLOSE no_of_packages;


   FOR comp_rec_ IN get_components(pkg_revised_qty_due_, no_of_packages_conf_) LOOP
      Mark_Component_For_Invoice___(order_no_, line_no_, rel_no_, comp_rec_.line_item_no);
   END LOOP;

   -- Set qty_shipdiff on the package header
   qty_shipdiff_ := no_of_packages_ - pkg_revised_qty_due_;

   Customer_Order_API.Set_Line_Qty_Shipdiff(order_no_, line_no_, rel_no_, -1, qty_shipdiff_);

   Customer_Order_Line_Hist_API.New
     (order_no_, line_no_, rel_no_, -1, Raise_Manually_Closed_Error___);
END Close_Package_Header___;


-- Close_Package___
--   Close a package row. All package component rows will be closed.
--   Could cause the package header to be closed also
--   The component_invoice_flag will be set for package components
--   for which separate invoice lines should be created.
PROCEDURE Close_Package___ (
   order_no_ IN VARCHAR2,
   line_no_  IN VARCHAR2,
   rel_no_   IN VARCHAR2 )
IS
   CURSOR get_components IS
      SELECT line_item_no, supply_code
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no > 0
      AND    rowstate NOT IN ('Invoiced', 'Cancelled');

BEGIN

   -- Retrieve all components for this package
   FOR comp_rec_ in get_components LOOP
      IF (comp_rec_.supply_code IN ('PT', 'PD', 'IPD', 'IPT', 'SO')) THEN 
         Error_SYS.Record_General(lu_name_, 'PROCESSPEGCOMPONENTSOFPKGPART: There are pegged component lines exist for the package part structure. You have to process or cancel those line(s) before closing the order line.');
      ELSE
         Close_Simple_Line___(order_no_, line_no_, rel_no_, comp_rec_.line_item_no);
      END IF;
   END LOOP;

   -- Close the package header
   Close_Package_Header___(order_no_, line_no_, rel_no_);
END Close_Package___;


-- Close_Order_Line___
--   Close an order line.
--   Its only possible to close packages or ordinary lines, not a single
--   package component.
PROCEDURE Close_Order_Line___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   shipment_connected_     VARCHAR2(5);
BEGIN
   IF (line_item_no_ = 0) THEN
      -- Ordinary line
      Close_Simple_Line___(order_no_, line_no_, rel_no_, line_item_no_);
   ELSIF (line_item_no_ > 0) THEN
   -- Package component line
      Close_Simple_Line___(order_no_, line_no_, rel_no_, line_item_no_);
      Check_Package_Status___(order_no_, line_no_, rel_no_);
   ELSIF (line_item_no_ = -1) THEN
      -- Package header
      Close_Package___(order_no_, line_no_, rel_no_);
   END IF;

   shipment_connected_ := Customer_Order_Line_API.Get_Shipment_Connected_Db(order_no_, line_no_, rel_no_, line_item_no_);
   IF (shipment_connected_ = 'TRUE') THEN
      Shipment_Line_API.Release_Not_Reserved_Qty_Line(order_no_, line_no_, rel_no_, 
                                                      line_item_no_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);   
   END IF;

END Close_Order_Line___;


-- Check_Package_Status___
--   Check if the package header status should be modified when a package
--   component has been closed.
--   Check if the package header should be closed after closing a package
--   component line
--   If all components have status 'Delivered' the package header should also be
--   set to 'Delivered'.
PROCEDURE Check_Package_Status___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2 )
IS
   found_ NUMBER := 0;

   CURSOR undelivered IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate NOT IN ('Cancelled', 'Delivered', 'Invoiced');

BEGIN

   OPEN undelivered;
   FETCH undelivered INTO found_;
   IF (undelivered%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE undelivered;

   IF (found_ = 0) THEN
      -- All components in the package have either been delivered or cancelled
      -- The package header should be closed
      Close_Package_Header___(order_no_, line_no_, rel_no_);
   END IF;

END Check_Package_Status___;


-- Update_License_Coverage_Qty___
--   Update the Export license quantities.
PROCEDURE Update_License_Coverage_Qty___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   quantity_     IN NUMBER )
IS

BEGIN
   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF (Component_Expctr_SYS.INSTALLED) $THEN
         DECLARE
            action_ VARCHAR2(20) := 'Close';
         BEGIN
            Exp_License_Connect_Util_API.Update_Coverage_Quantities(action_, order_no_, line_no_, rel_no_, line_item_no_, quantity_);
         END;
      $ELSE
         NULL;
      $END
   END IF;
END Update_License_Coverage_Qty___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Close_Order_Line__
--   Close an order line.
--   Return the new state for the line.
PROCEDURE Close_Order_Line__ (
   head_state_   IN OUT VARCHAR2,
   line_state_   IN OUT VARCHAR2,
   order_no_     IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
BEGIN
   Order_Line_Staged_Billing_API.Check_Stages_To_Invoice__(order_no_, line_no_, rel_no_, line_item_no_);
   Close_Order_Line___(order_no_, line_no_, rel_no_, line_item_no_);
   line_state_ := Customer_Order_Line_API.Get_State(order_no_, line_no_, rel_no_, line_item_no_);
   head_state_ := Customer_Order_API.Get_State(order_no_);
END Close_Order_Line__;


-- Close_Order__
--   Close an order. This method will close all order lines.
--   If the order contains packages for which the amount of delivered
--   component rows exceeds the number of complete packages delivered then
--   the component_invoice_flag will be set for the component rows
--   in order to force invoicing of components.
PROCEDURE Close_Order__ (
   state_    OUT VARCHAR2,
   order_no_ IN  VARCHAR2 )
IS
   CURSOR select_lines IS
      SELECT line_no,
             rel_no,
             line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
      AND    order_no = order_no_
      AND    line_item_no <= 0;
BEGIN
   Order_Line_Staged_Billing_API.Check_Stages_To_Invoice__(order_no_);
   FOR nextline_ IN select_lines LOOP
      Close_Order_Line___(order_no_, nextline_.line_no, nextline_.rel_no, nextline_.line_item_no);
   END LOOP;
   state_ := Customer_Order_API.Get_State(order_no_);
END Close_Order__;


   FUNCTION Raise_Manually_Closed_Error___ RETURN VARCHAR2
   IS
   BEGIN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'MANCLOSE: The line was manually closed');
   END Raise_Manually_Closed_Error___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Connected_To_Purchase_Order
--   Checks whether a Customer Order is connected to a Purchase Order.
FUNCTION Connected_To_Purchase_Order (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS

 CURSOR purchase_order_connect IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE supply_code IN ('PD','PT','IPT','IPD')
      AND order_no = order_no_;

   connected_ NUMBER;

BEGIN
   connected_ := 0;
   OPEN purchase_order_connect;
   FETCH purchase_order_connect INTO connected_;
   IF ( purchase_order_connect%FOUND) THEN
      CLOSE purchase_order_connect;
      RETURN 1;
   ELSE
      CLOSE purchase_order_connect;
      RETURN 0;
   END IF;
END Connected_To_Purchase_Order;


-- Close_Co_Connected_To_Do
--   Close an order. Public method to call Close Order private method from
--   outside the LU if the CO is connected to a Distribution Order.
PROCEDURE Close_Co_Connected_To_Do (
   order_no_ IN VARCHAR2 )
IS
   state_    VARCHAR2(30);
BEGIN
   IF (Customer_Order_Flow_API.Close_Allowed(order_no_) = 1) THEN
      Close_Order__(state_,order_no_);
   END IF;
END Close_Co_Connected_To_Do;



