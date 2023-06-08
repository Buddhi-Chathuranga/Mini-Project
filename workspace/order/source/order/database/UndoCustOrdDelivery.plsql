-----------------------------------------------------------------------------
--
--  Logical unit: UndoCustOrdDelivery
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220311  RasDlk  SCDEV-8051, Modified Undo_Cust_Ord_Delivery___ by replacing Shipment_Order_Utility_API by Shipment_Source_Utility_API for the method Any_Rental_Line_Exists.
--  220308  RasDlk  SCDEV-8051, Added the method Check_Undo_Ord_Line_Deliv. Modified the method Undo_Cust_Ord_Delivery___ by moving the method call Check_Undo_Ord_Deliv___ down
--  220308          as it will be handled separately in the shipment flow.
--  210726  ErFelk  SC2020R1-13109, Modified Check_Undo_Ord_Line_Deliv___() by adding PRJ to a condition so that UNDOMULTIDELIV error is not triggered. 
--  201013  ErFelk  Bug 155215(SCZ-11111), Modified Check_Undo_Ord_Line_Deliv___() by adding NO to a condition so that UNDOMULTIDELIV error is not triggered.
--  200727  ErFelk  Bug 154982(SCZ-10924), Modified Check_Undo_Ord_Line_Deliv___() by adding PKG to a condition so that UNDOMULTIDELIV error is not triggered. 
--  200727  ErFelk  Bug 154257(SCZ-10319), Modified Undo_Cust_Ord_Line_Delivery to pass the package delv_no, and modified Undo_Cust_Ord_Line_Delivery__ to support packages with supply code IPD and PD.  
--  200709  AsZelk  Bug 154251(SCZ-10013), Modified Check_Undo_Ord_Line_Deliv___ to raise an error when undo multiple delivered orders and 
--  200709          modified Unissue_Delivered_Parts___ to fix qty_picked_, qty_assigned_ calculation issue.
--  200514  AjShlk  Bug 153923(SCZ-10076), Modified Check_Undo_Ord_Line_Deliv___() to enable package part undo delivery when there are cancelled RMA entries exists.
--  200320  ErFelk  Bug 152474(SCZ-9068), Modified Check_Undo_Ord_Line_Deliv___() by removing a condition so that error message INTCUSTORDEXIST is not triggered when the demand code is DO.
--  200123  NiEdlk  Bug 152123(SCZ-8776), Modified Undo_Cust_Ord_Line_Delivery__() and Undo_Cust_Ord_Delivery() to correctly cancel the package header line when undoing its components. 
--  190112  UdGnlk  Bug 145716(SCZ-2343), Modified Check_Undo_Ord_Line_Deliv___() by checking the date of confirmation other that the COL delivery confirm.
--  180822  RaVdlk  SCUXXW4-9600, Moved the content in Undo_Cust_Ord_Delivery to Undo_Cust_Ord_Delivery___ implementation method.
--                  Added an overloading method for Undo_Cust_Ord_Delivery with the new parameter for rental.
--  180212  TiRalk  STRSC-16780, Modified Unissue_Delivered_Parts___ by changing call Inventory_Part_In_Stock_API.Unissue_Part by sending validate_hu_struct_position_
--  180212          FALSE only there is shipment connected as it is no need to validate HU structure when undo delivery. For customer order flow this will be a limitation
--  180212          for non single unit structures where it can be opened for a path to exist the HU in transit and inventory in the process in technical perspective.
--  171120  DiKuLk  Bug 138662, Removed error message 'INTRASTATEXIST' from Check_Undo_Ord_Line_Deliv___() to enable undo customer order delivery for intrastat collected orders.
--  171115  TiRalk  STRSC-13753, Modified Unissue_Delivered_Parts___ by adding transaction PODIRINTEM, INTPODIRIM to undo delivery for multi tier IPD, PD.
--  171106  DiKuLk  Bug 138595, Modified Check_Undo_Ord_Line_Deliv___() by adding error message EXCHANGEDITEM to raise an error when undo an exchanged part.
--  171101  TiRalk  STRSC-13136, Modified Unissue_Delivered_Parts___ by enabling undo delivery for IPD.
--  171025  TiRalk  STRSC-13146, Modified Unissue_Delivered_Parts___ by adding transaction UNPODIR-NI to undo delivery external CO non inventory parts for IPD.
--  171024  TiRalk  STRSC-12992, Modified Unissue_Delivered_Parts___ by adding transaction UNINTSHPNI to undo delivery ICO non inventory parts for IPT.
--  171024  TiRalk  STRSC-13735, Modified Unissue_Delivered_Parts___ by adding transactions UNSHIPDIR and COUNSHPDIR to undo the internal customer order IPD flow.     
--  171023  TiRalk  STRSC-13136, Modified Undo_Cust_Ord_Delivery and Undo_Cust_Ord_Line_Delivery by including IPD supply code to cancel the receipt when undo
--  171023          the external customer order IPD flow. Added transaction INTPODIRSH.
--  171003  ErFelk  Bug 137591, Modified Check_Undo_Ord_Line_Deliv___() by adding a condition to raise error messages RMALINERETEXIST, RMALINESRETEXIST, RMALINEEXIST and RMALINESEXIST. This will allow to
--  171003          undo deliveries without raising the error message when there are no entries in the Cust_Delivery_Inv_Ref_tab. If there is an entry INVOICEDLINE error message is raised. 
--  171003          For package component parts these errors should be raised.
--  171002  TiRalk  STRSC-12292, Modified Check_Undo_Ord_Line_Deliv___ removing validation to facilitate the undo delivery the internal customer orders 
--  171002          same company when the supply code is IPT.
--  170908  TiRalk  STRSC-11967, Modified Check_Undo_Ord_Line_Deliv___ to validate the PO state when undo the internal CO in same company where the demand_code is IPT.
--  170901  TiRalk  STRSC-11798, Modified Check_Undo_Ord_Line_Deliv___ by removing validation to facilitate the undo delivery the external customer orders 
--  170901          when the supply code is IPT.
--  170814  IzShlk  STRSC-11190, Removed validation for blocking Undo CO delivery for rental Orders.
--  170721  TiRalk  STRSC-10759, Modified Undo_Cust_Ord_Delivery and Undo_Cust_Ord_Line_Delivery to reverse the purchasing actions related to PODIRSH.
--  170721  TiRalk  STRSC-10756, Modified Check_Undo_Ord_Line_Deliv___, Modify_Qty_On_Undo_Delivery___ and Unissue_Delivered_Parts___ 
--  170721          by adding new reversal transaction of Purchase direct flow.
--  170509  Chfose  LIM-11446, Added Check_Undo_Handling_Units___ to gather validations for hinderingUndo Delivery
--  170509          when not all of the needed Handling Units are available/empty.
--  170419  ErFelk  Bug 134966, Modified error message in constant RMALINESRETEXIST which is in Check_Undo_Ord_Line_Deliv___(). 
--  170221  Chfose  LIM-10450, Added validations for being able to undo into handling units in Check_Undo_Ord_Line_Deliv___
--  170221          also added new method Get_Top_Avail_Handl_Unit___ to find the topmost empty & unused handling unit in a structure.
--  170209  MaIklk  LIM-9879, Implemented to raise an error when undo, if the order is created using internal customer.
--  170125  MeAblk  STRSC-5269, Modified Modify_Qty_On_Undo_Delivery___() to correctly set the first actual ship date of a CO line when a delivery of it is undone.
--  160915  ErFelk  Bug 131239, Modified Unissue_Delivered_Parts___() to correctly update the assigned and picked quantities with the shipped quantity not with delivered quantity.
--  160809  ChJalk  Bug 130786, Modified Modify_Qty_On_Undo_Delivery___ to correctly update the shipped qty of the package part header when performing undo_delivery.
--  160720  Chfose  LIM-7517, Added inventory_event_id to Unissue_Delivered_Parts___ to combine multiple calls to Customer_Order_Reservation_API within a single inventory_event_id.
--  160613  MeAblk  Bug 129792, Modified Unissue_Delivered_Parts___() to make it possible to undo deliveries done on a non-inventory part delay confirmation of goods part lines where 
--  160613          there are no any inventiry transactions made when deliverying.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160513  MeAblk  Bug 127640, Modified Modify_Qty_On_Undo_Delivery___() to correctly set the open_shipment_qty for package components.
--  160301	MeAblk  Bug 127585, Modified Undo_Cust_Ord_Line_Delivery__(), Undo_Cust_Ord_Delivery() and Undo_Cust_Ord_Line_Delivery() to correctly cancel the the package header line when undoing its components.
--  160211  RoJalk  LIM-4733, Modified Undo_Cust_Ord_Delivery_Join and used shipment_line_pub.
--  160208  MaEelk  LIM-6179, Passed handling_unit_id to Customer_Order_Reservation_API.Modify_On_Undo_Delivery__
--  160129  MeAblk  Bug 125400, Modified Undo_Cust_Ord_Delivery in order to correctly undo the package header delivery when there exist only component deliveries.
--  160129          Modified Modify_Qty_On_Undo_Delivery___ in order to reset any negative qty_shipdiff value in the customer_order_line_tab when doing an undo. 
--  151216  ErFelk  Bug 126186, Modified Check_Undo_Ord_Line_Deliv___() by removing PM from a condition as it is not been used in Customer Order. 
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151109  MaEelk  LIM-4453, Removed pallet_id from Customer_Order_Reservation_API method calls.
--  151106  UdGnlk  LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete.
--  150905  MaIklk  AFT-3952, Allowed undo delivery for supply code "Purch Order Trans" and "Int Purch Trans" if demand code is null.
--  150812  MAHPLK  KES-1081, Modified Unissue_Delivered_Parts___() to undo deliveries with CO-DELV-IN and CO-DELV-OU transactions.
--  150812  IsSalk  KES-1076, Modified Unissue_Delivered_Parts___() to undo deliveries with DELCONF-OU and DELCONF-IN transactions.
--  150804  IsSalk  KES-1159, Modified Check_Undo_Ord_Line_Deliv___() to handle cancel delivery when invoiced partial deliveries exist.
--  150730  IsSalk  KES-1157, Removed Undo_Line_Delivery___(). Modified Undo_Cust_Ord_Line_Delivery__(), Check_Undo_Ord_Line_Deliv___(),
--  150730          Check_Undo_Ord_Deliv___() and Undo_Cust_Ord_Line_Delivery() to disallow undo delivery of CO lines with connected RMA lines.
--  150727  IsSalk  KES-1130, Modified Check_Undo_Delivery_Allowed___() to disallow undo CO delivery for subcontracting.
--  150727  IsSalk  KES-1123, Modified Check_Undo_Delivery_Allowed___() to disallow undo delivery of CO line delivery connected to intrastat.
--  150721  IsSalk  KES-925, Modified Check_Undo_Ord_Line_Deliv___() to disallow undo delivery of CO lines created by work orders.
--  150721  IsSalk  KES-908, Modified Check_Undo_Ord_Line_Deliv___() to disallow undo delivery with created SM Objects.
--  150716  IsSalk  KES-908, Modified Check_Undo_Ord_Line_Deliv___() to disallow undo delivery for multisite delivery.
--  150716  IsSalk  KES-912, Modified Check_Undo_Ord_Line_Deliv___() to disallow undo delivery of CO lines created by distribution order.
--  150715  MAHPLK  KES-1074, Added deliv_no_ parameter and modified Check_Undo_Ord_Line_Deliv___()@AllowTableOrViewAccess 
--  150715          Modified Unissue_Delivered_Parts___() to consider 'DELCONF-OU' transaction code.
--  150714  MAHPLK  KES-1072, Modified Modify_Qty_On_Undo_Delivery___() to update the export license covering quantity.
--  150709  IsSalk  KES-911, Modified Check_Undo_Ord_Line_Deliv___() to disallow undo delivery of rental order lines.
--  150702  IsSalk  KES-876, Added Check_Undo_Ord_Deliv___() and renamed Check_Undo_Delivery_Allowed___() to Check_Undo_Ord_Line_Deliv___().
--  150629  IsSalk  KES-870, Modified Modify_Qty_On_Undo_Delivery___() to avoid creating CO line history record when reassigning the quantities.
--  150624  IsSalk  KES-656, Modified Check_Undo_Delivery_Allowed___() to disallow undo delivery of CO lines connected to intrastat.
--  150624  MAHPLK  KES-516, Modified Modify_Qty_On_Undo_Delivery___ to correctly update the quantities when non-inventory part exist as package component.
--  150622  IsSalk  KES-656, Added Update_Qty_In_Scheduling___ to update quantity in schedule when undoing a CO line delivery.
--  150622  IsSalk  KES-656, Modified Check_Undo_Delivery_Allowed___() to disallow undo delivery of CO lines connected to load lists.
--  150616  IsSalk  KES-665, Added methods Undo_Delivery() and Undo_Delivery___().
--  150612  MAHPLK  KES-665, Modified Undo_Cust_Ord_Delivery() to undo the delivery per shipment and delivery note.
--  150608  IsSalk  KES-517, Modified Unissue_Delivered_Parts___ to remove warranty dates of serial parts if exists.
--  150528  MAHPLK  KES-511, Modified Unissue_Delivered_Parts___(). Added methods Modify_Qty_On_Undo_Delivery___(), 
--  150528          Undo_Cust_Ord_Delivery(),Undo_Cust_Ord_Line_Delivery() 
--  150519  IsSalk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Check_Undo_Ord_Deliv___(
   order_no_    IN VARCHAR2,
   shipment_id_ IN NUMBER,
   delnote_no_  IN VARCHAR2) RETURN BOOLEAN
IS
   undo_allowed_   BOOLEAN := FALSE;

   CURSOR get_delivery_info IS
     SELECT order_no, line_no, rel_no, line_item_no, deliv_no
     FROM   CUSTOMER_ORDER_DELIVERY_TAB
     WHERE  (order_no = order_no_ OR order_no_ IS NULL)
     AND    NVL(shipment_id, 0) = NVL(shipment_id_, 0)
     AND    NVL(delnote_no, Database_SYS.string_null_) = NVL(delnote_no_, Database_SYS.string_null_)
     AND    cancelled_delivery = 'FALSE'
     ORDER BY order_no, line_no, rel_no, line_item_no DESC;
BEGIN
   FOR rec_ IN get_delivery_info LOOP
      undo_allowed_ := Check_Undo_Ord_Line_Deliv___(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.deliv_no, FALSE, shipment_id_);
      IF (NOT undo_allowed_) THEN
         EXIT;
      END IF;
   END LOOP;
   
   RETURN undo_allowed_;
END Check_Undo_Ord_Deliv___;
   
FUNCTION Check_Undo_Ord_Line_Deliv___(
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   deliv_no_           IN NUMBER,
   from_undo_co_line_  IN BOOLEAN,
   shipment_id_        IN NUMBER DEFAULT NULL) RETURN BOOLEAN
IS
   undo_allowed_           BOOLEAN := TRUE;
   linerec_                Customer_Order_Line_API.Public_Rec;
   found_                  NUMBER := 0;
   qty_shipped_            NUMBER;
   tot_qty_shipped_        NUMBER;
   ordrec_                 Customer_Order_API.Public_Rec;
   no_invoiced_lines_      VARCHAR2(5);
   
   CURSOR invoice_line_exist IS
      SELECT 1
      FROM   CUST_DELIVERY_INV_REF_TAB cd, CUSTOMER_ORDER_DELIVERY_TAB cod
      WHERE  cod.deliv_no = deliv_no_
      AND    cd.deliv_no  = cod.deliv_no
      AND    cod.order_no = order_no_
      AND    cod.line_no  = line_no_
      AND    cod.rel_no   = rel_no_
      AND    cod.line_item_no = line_item_no_
      AND    cod.cancelled_delivery = 'FALSE';

   CURSOR get_serial_no IS
      SELECT serial_no
      FROM   INVENTORY_TRANSACTION_HIST_PUB 
      WHERE  source_ref1 = order_no_
      AND    source_ref2 = line_no_
      AND    source_ref3 = rel_no_
      AND    source_ref4 = line_item_no_
      AND    source_ref5 = deliv_no_;

   CURSOR sbi_item_exist IS
      SELECT 1
      FROM   SELF_BILLING_ITEM_TAB sbi
      WHERE  sbi.order_no = order_no_
      AND    sbi.line_no  = line_no_
      AND    sbi.rel_no   = rel_no_
      AND    sbi.line_item_no = line_item_no_
      AND    sbi.rowstate = 'Matched';
BEGIN
   
   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   ordrec_  := Customer_Order_API.Get(order_no_);
   
   IF (linerec_.supply_code = 'SEO') THEN
      Error_SYS.Record_General(lu_name_, 'UNDODELNOTALLOWED: Cannot undo delivery for customer order lines with supply code :P1.',
                                                                                  Order_Supply_Type_API.Decode(linerec_.supply_code));
   END IF;
   
   IF shipment_id_ IS NULL THEN
      IF linerec_.supply_code NOT IN ('PD', 'IPD', 'PKG', 'NO', 'PRJ') THEN
         qty_shipped_      := Customer_Order_Delivery_API.Get_Qty_Shipped(deliv_no_);
         tot_qty_shipped_  := Customer_Order_Reservation_API.Get_Qty_Shipped(deliv_no_);

         IF tot_qty_shipped_ IS NULL OR tot_qty_shipped_ > qty_shipped_ THEN
            Error_SYS.Record_General(lu_name_, 'UNDOMULTIDELIV: Customer order delivery has not been undone since there are a multiple deliveries and matching the reservation to the delivery is not possible when using shipment inventory.');
         END IF;
      END IF;
   END IF;
   
   IF (linerec_.self_billing = 'SELF BILLING') THEN
      OPEN sbi_item_exist;
      FETCH sbi_item_exist INTO found_;
      IF (sbi_item_exist%FOUND) THEN
         CLOSE sbi_item_exist;
         IF (from_undo_co_line_) THEN
            Error_SYS.Record_General(lu_name_, 'SBILINEEXIST: This line is matched to a customer self-billing invoice. Un-match and remove the line to undo the delivery.');
         ELSE
            Error_SYS.Record_General(lu_name_, 'SBIEXIST: There are lines matched to customer self-billing invoices. Un-match and remove all lines to undo the delivery.');
         END IF;
      END IF;
      CLOSE sbi_item_exist;
   END IF;
   
   IF (linerec_.demand_code IN ('IPT_RO')) THEN
      Error_SYS.Record_General(lu_name_, 'INTCUSTORDEXIST: Cannot undo delivery for internal customer orders.');
   END IF;    
   
   IF (linerec_.consignment_stock = 'CONSIGNMENT STOCK') THEN
      IF (Inventory_Transaction_Hist_API.Check_Order_Transaction(order_no_, line_no_, rel_no_, 
                                     line_item_no_, deliv_no_, 'CO-CONSUME') = Fnd_Boolean_API.DB_TRUE ) THEN
         IF (from_undo_co_line_) THEN
            Error_SYS.Record_General(lu_name_, 'LINECONSSTCONSUMED: Cannot undo delivery of customer order lines where the customer has consumed consignment stock.');
         ELSE
            Error_SYS.Record_General(lu_name_, 'CONSSTCONSUMED: Cannot undo delivery of customer order where the customer has consumed consignment stock.');
         END IF;
      END IF;
   END IF;
   
   IF (ordrec_.confirm_deliveries = 'TRUE' AND Customer_Order_Delivery_API.Get_Date_Confirmed(deliv_no_) IS NOT NULL) THEN 
      IF (from_undo_co_line_) THEN
         Error_SYS.Record_General(lu_name_, 'LINEDELIVCONFIRMED: Cannot undo delivery for a customer order line that is delivery confirmed.');
      ELSE
         Error_SYS.Record_General(lu_name_, 'DELIVCONFIRMED: Cannot undo delivery for a customer order that is delivery confirmed.');
      END IF;
   END IF;
   
   IF (linerec_.demand_code = 'PO') THEN
      IF (linerec_.charged_item = 'ITEM NOT CHARGED') THEN
         Error_SYS.Record_General(lu_name_, 'NOTCHGITEM: Cannot undo customer order delivery for component customer orders where the item is not charged.');
      END IF;  
      IF (linerec_.exchange_item = 'EXCHANGED ITEM') THEN
         Error_SYS.Record_General(lu_name_, 'EXCHANGEDITEM: Cannot undo customer order delivery for exchange components.');
      END IF;
   END IF;
   IF (linerec_.demand_code IN ('PO', 'IPT', 'IPD')) THEN
      Validate_Conn_Purch_Line___(order_no_, line_no_, rel_no_, line_item_no_, linerec_.demand_code);
   END IF;
   $IF (Component_Equip_SYS.INSTALLED) $THEN
      IF (linerec_.create_sm_object_option = 'CREATESMOBJECT') THEN
         FOR rec_ IN get_serial_no LOOP
            IF (Equipment_Serial_API.Check_Serial_Exist(linerec_.part_no, rec_.serial_no) = 'TRUE') THEN
               Error_SYS.Record_General(lu_name_, 'SMOBJECT: Cannot undo customer order delivery with connected SM Object.');
            END IF;
         END LOOP;
      ELSIF ((linerec_.sup_sm_contract IS NOT NULL) AND (linerec_.sup_sm_object IS NOT NULL)) THEN
          Error_SYS.Record_General(lu_name_, 'SMOBJECT: Cannot undo customer order delivery with connected SM Object.');
      END IF;
   $END
   
   IF (linerec_.demand_code = 'WO') THEN
      Error_SYS.Record_General(lu_name_, 'WOEXIST: Cannot undo delivery for customer order lines created from work orders.');
   END IF;
   
   OPEN invoice_line_exist;
   FETCH invoice_line_exist INTO found_;
   IF (invoice_line_exist%FOUND) THEN
      CLOSE invoice_line_exist;
      Error_SYS.Record_General(lu_name_, 'INVOICEDLINE: Cannot undo delivery as there are lines with invoices created.');
   END IF;
   CLOSE invoice_line_exist;
   
   IF linerec_.load_id IS NOT NULL THEN
      Error_SYS.Record_General(lu_name_, 'LOADLISTEXIST: Cannot undo delivery made from load list.');
   END IF;
   
   IF (Return_Material_Line_API.Check_Active_Rma_For_Ord_Line(order_no_, line_no_, rel_no_, line_item_no_) = 'TRUE') THEN
      
      no_invoiced_lines_:= Return_Material_Line_API.Check_Not_Invoiced_Rma_Lines(order_no_, line_no_, rel_no_);
      
      IF ((NOT line_item_no_ = 0) OR (no_invoiced_lines_ = 'TRUE')) THEN
         IF (linerec_.qty_returned > 0) THEN
            IF (from_undo_co_line_) THEN
               Error_SYS.Record_General(lu_name_, 'RMALINERETEXIST: Cannot undo customer order delivery since there are returns for the specified customer order line.');
            ELSE
               Error_SYS.Record_General(lu_name_, 'RMALINESRETEXIST: Cannot undo customer order delivery since there are returns for customer order lines.');
            END IF;
         ELSE
            IF (from_undo_co_line_) THEN
               Error_SYS.Record_General(lu_name_, 'RMALINEEXIST: This customer order line is connected to a Return Material Line. Remove the connection to undo the delivery.');
            ELSE
               Error_SYS.Record_General(lu_name_, 'RMALINESEXIST: There are customer order line connections to Return Material Lines. Remove the connection to undo the delivery.');
            END IF;
         END IF;
      END IF;
   END IF;
   
   Check_Undo_Handling_Units___(order_no_, line_no_, rel_no_, line_item_no_, shipment_id_);
   
   RETURN undo_allowed_;
END Check_Undo_Ord_Line_Deliv___;


-- Check that all of the Handling Units on the order / shipment is available for Undo Delivery and not used somewhere else in the system.
PROCEDURE Check_Undo_Handling_Units___ (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   shipment_id_        IN NUMBER )
IS
   CURSOR get_handl_unit_reservations IS
      SELECT DISTINCT handling_unit_id
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no         = order_no_
      AND    line_no          = line_no_
      AND    rel_no           = rel_no_
      AND    line_item_no     = line_item_no_
      AND    deliv_no IS NOT NULL
      AND    handling_unit_id != 0;
      
   CURSOR get_handl_unit_shipment IS
      SELECT DISTINCT handling_unit_id
      FROM   SHIPMENT_LINE_HANDL_UNIT
      WHERE  shipment_id = shipment_id_;
      
   top_handling_unit_id_    NUMBER;
   handling_unit_tab_       Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   -- When using shipment we look at the SHIPMENT_LINE_HANDL_UNIT_TAB to get all of the Handling Units with packing,
   -- but when not using shipment it is enough to look at the reservations.
   IF (NVL(shipment_id_, 0) != 0) THEN
      OPEN get_handl_unit_shipment;
      FETCH get_handl_unit_shipment BULK COLLECT INTO handling_unit_tab_;
      CLOSE get_handl_unit_shipment;
   ELSE
      OPEN get_handl_unit_reservations;
      FETCH get_handl_unit_reservations BULK COLLECT INTO handling_unit_tab_;
      CLOSE get_handl_unit_reservations;
   END IF;
   
   IF (handling_unit_tab_.COUNT > 0) THEN
      -- In order to be able to undo reservations in handling units we need to check
      -- that the handling units are not in use somewhere else.
      FOR i IN handling_unit_tab_.FIRST .. handling_unit_tab_.LAST LOOP
         top_handling_unit_id_ := Get_Top_Avail_Handl_Unit___(handling_unit_tab_(i).handling_unit_id);
         IF (top_handling_unit_id_ IS NOT NULL) THEN
            -- We need to disconnect the top "unused" handling unit from it's parent if there is one.
            IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(top_handling_unit_id_) IS NOT NULL) THEN
               Handling_Unit_API.Modify_Parent_Handling_Unit_Id(top_handling_unit_id_, NULL);
            END IF;
         ELSE    
            Error_SYS.Record_General(lu_name_, 'HANDLUNITINUSE: The handling unit :P1 is in use. Unpack and/or remove its connections to undo the delivery.', handling_unit_tab_(i).handling_unit_id);
         END IF;
      END LOOP;
   END IF;
END Check_Undo_Handling_Units___;


FUNCTION Get_Top_Avail_Handl_Unit___ (
   handling_unit_id_    IN NUMBER ) RETURN NUMBER
IS
   current_handling_unit_id_     NUMBER;
   top_avail_handling_unit_id_   NUMBER;
BEGIN
   current_handling_unit_id_ := handling_unit_id_;
   
   -- Go through the structure of handling_unit_id_ in order to find the 
   -- topmost empty and "unused" handling unit.
   WHILE (current_handling_unit_id_ IS NOT NULL) LOOP
      IF (Handling_Unit_API.Has_Quantity_In_Stock(current_handling_unit_id_) = 'TRUE' OR
            Handling_Unit_API.Get_Shipment_Id(current_handling_unit_id_) IS NOT NULL  OR
            Handling_Unit_API.Get_Source_Ref_Type(current_handling_unit_id_) IS NOT NULL) THEN
         EXIT;
      END IF;
      
      top_avail_handling_unit_id_ := current_handling_unit_id_;
      current_handling_unit_id_ := Handling_Unit_API.Get_Parent_Handling_Unit_Id(current_handling_unit_id_);
   END LOOP;
   
   RETURN top_avail_handling_unit_id_;
END Get_Top_Avail_Handl_Unit___;


-- (Reverse of New_Inv_Line_Delivery___).
PROCEDURE Modify_Qty_On_Undo_Delivery___(
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   deliv_no_         IN NUMBER)
IS
   deliv_rec_              Customer_Order_Delivery_API.Public_Rec;
   ord_line_rec_           Customer_Order_Line_API.Public_Rec;
   pkg_ship_revised_qty_due_ NUMBER;
   open_shipment_qty_      NUMBER;
   qty_shipped_            NUMBER;
   qty_picked_             NUMBER;
   qty_assigned_           NUMBER;
   catalog_type_           VARCHAR2(4);

   CURSOR get_package_qty IS
      SELECT NVL(MIN(TRUNC(qty_shipped * (inverted_conv_factor/conv_factor)/qty_per_assembly)),0) qty_shipped
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled'
      AND    new_comp_after_delivery = 'FALSE';

BEGIN
   deliv_rec_     := Customer_Order_Delivery_API.Get(deliv_no_);
   ord_line_rec_  := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   catalog_type_  := Sales_Part_API.Get_Catalog_Type_Db(ord_line_rec_.contract, ord_line_rec_.catalog_no);
   
   IF (line_item_no_ != -1) THEN
      qty_shipped_   := ord_line_rec_.qty_shipped - deliv_rec_.qty_shipped;      
                  
      IF catalog_type_ = 'NON' THEN        
         Customer_Order_Line_API.Modify_Qty_To_Ship__(order_no_, line_no_, rel_no_, line_item_no_, deliv_rec_.qty_shipped);
      ELSE
         -- For PD flow when undo the delivery there is no reserved or picked quantity as there is nothing impact on the inventory stock.
         IF ord_line_rec_.supply_code NOT IN ('PD', 'IPD') THEN
            qty_picked_   := ord_line_rec_.qty_picked + deliv_rec_.qty_shipped;
            qty_assigned_ := ord_line_rec_.qty_assigned + deliv_rec_.qty_shipped;
            Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, qty_assigned_, 'FALSE');
            Customer_Order_API.Set_Line_Qty_Picked(order_no_, line_no_, rel_no_, line_item_no_, qty_picked_, 'FALSE');
         END IF;
      END IF;
      Customer_Order_API.Set_Line_Qty_Shipped(order_no_, line_no_, rel_no_, line_item_no_, qty_shipped_, 'TRUE');
      Customer_Order_Line_API.Modify_Real_Ship_Date(order_no_, line_no_, rel_no_, line_item_no_, NULL);
      Customer_Order_Line_API.Set_First_Actual_Ship_Date(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      OPEN get_package_qty;
      FETCH get_package_qty INTO qty_shipped_;
      CLOSE get_package_qty;  

      Customer_Order_API.Set_Line_Qty_Shipped(order_no_, line_no_, rel_no_, -1, qty_shipped_, 'TRUE');      
      Customer_Order_Line_API.Modify_Real_Ship_Date(order_no_, line_no_, rel_no_, -1, NULL); 
      Customer_Order_Line_API.Set_First_Actual_Ship_Date(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;  
   
   IF (ord_line_rec_.qty_shipdiff < 0) THEN
      Customer_Order_Line_API.Set_Qty_Shipdiff(order_no_, line_no_, rel_no_, line_item_no_, 0);
   END IF;
   
   IF deliv_rec_.shipment_id IS NOT NULL THEN
      IF (ord_line_rec_.open_shipment_qty = 0 AND line_item_no_ > 0) THEN
         pkg_ship_revised_qty_due_ := Shipment_Line_API.Get_Inventory_Qty_By_Source(deliv_rec_.shipment_id, order_no_, line_no_, rel_no_, -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
         open_shipment_qty_ := (ord_line_rec_.qty_per_assembly*ord_line_rec_.conv_factor / ord_line_rec_.inverted_conv_factor)*pkg_ship_revised_qty_due_;
      ELSE
         open_shipment_qty_ := ord_line_rec_.open_shipment_qty + deliv_rec_.qty_shipped;
      END IF; 

      Customer_Order_Line_API.Modify_Shipment_Connection(order_no_, line_no_, rel_no_, line_item_no_, 
                                                         'TRUE', open_shipment_qty_);
      IF catalog_type_ = 'NON' THEN
         Shipment_Line_API.Modify_On_Undo_Delivery(deliv_rec_.shipment_id, order_no_, line_no_, rel_no_, line_item_no_, 
                                                   Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, 0, deliv_rec_.qty_shipped);
      END IF;
   END IF;
   
   IF (Customer_Order_API.Get_Scheduling_Connection_Db(order_no_) = 'SCHEDULE') THEN
      Update_Qty_In_Scheduling___(order_no_, ord_line_rec_.contract, ord_line_rec_.customer_no, ord_line_rec_.ship_addr_no,
                                  ord_line_rec_.customer_part_no, deliv_rec_.qty_shipped);
   END IF;

   IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
      $IF Component_Expctr_SYS.INSTALLED $THEN         
         Exp_License_Connect_Util_API.Update_Coverage_Quantities('UndoDelivery', order_no_, line_no_, rel_no_, line_item_no_, deliv_rec_.qty_shipped);           
      $ELSE
         NULL;
      $END
   END IF;
END Modify_Qty_On_Undo_Delivery___;

   
PROCEDURE Unissue_Delivered_Parts___(
   unissue_complete_    OUT VARCHAR2,
   order_no_            IN  VARCHAR2,
   line_no_             IN  VARCHAR2,
   rel_no_              IN  VARCHAR2,
   line_item_no_        IN  NUMBER,   
   deliv_no_            IN  NUMBER)
IS
   CURSOR get_inv_transaction_info IS
      SELECT transaction_id, transaction_code, quantity, catch_quantity, source, part_no, serial_no
      FROM   INVENTORY_TRANSACTION_HIST_PUB 
      WHERE  source_ref1    = order_no_
      AND    source_ref2    = line_no_
      AND    source_ref3    = rel_no_
      AND    source_ref4    = line_item_no_
      AND    source_ref5    = deliv_no_
      AND    transaction_code IN ('OESHIP', 'OESHIPNI', 'DELCONF-OU', 'DELCONF-IN', 'CO-OESHIP', 'CO-DELV-IN', 'CO-DELV-OU', 'PODIRSH', 'PODIRSH-NI',
                                  'PODIRINTEM', 'INTPODIRIM', 'INTPODIRSH', 'SHIPDIR', 'CO-SHIPDIR', 'SHIPTRAN', 'CO-SHIPTRN', 'INTSHIP-NI')
      AND NOT EXISTS (SELECT 1 
                     FROM   CUSTOMER_ORDER_DELIVERY_TAB
                     WHERE  deliv_no = deliv_no_
                     AND    cancelled_delivery = 'TRUE');
   CURSOR get_reservation_info IS
      SELECT contract, part_no, location_no, lot_batch_no, pick_list_no, 
             serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id,
             configuration_id, shipment_id, qty_shipped, qty_to_deliver, 
             catch_qty, catch_qty_shipped, qty_picked, qty_assigned
      FROM   CUSTOMER_ORDER_RESERVATION_TAB 
      WHERE order_no          = order_no_
      AND   line_no           = line_no_
      AND   rel_no            = rel_no_
      AND   line_item_no      = line_item_no_      
      AND   deliv_no          = deliv_no_
      AND NOT EXISTS (SELECT 1 
                     FROM   CUSTOMER_ORDER_DELIVERY_TAB
                     WHERE  deliv_no = deliv_no_
                     AND    cancelled_delivery = 'TRUE');

   qty_shipped_               NUMBER;
   qty_assigned_              NUMBER;
   qty_picked_                NUMBER;
   catch_qty_shipped_         NUMBER;
   catch_qty_                 NUMBER;
   dummy_number_              NUMBER;
   new_transaction_id_        NUMBER;
   transaction_code_          VARCHAR2(10);
   transaction_exist_         BOOLEAN := FALSE;   
   ord_rec_                   Customer_Order_API.Public_Rec;
   ord_line_rec_              Customer_Order_Line_API.Public_Rec;  
   non_inv_delay_cogs_exist_  BOOLEAN := FALSE;
   shipment_id_               NUMBER;
BEGIN
   
   unissue_complete_ := 'FALSE';
   FOR inv_tran_rec_ IN get_inv_transaction_info LOOP
      
      CASE (inv_tran_rec_.transaction_code)
         WHEN ('OESHIP') THEN
            transaction_code_ := 'OEUNSHIP';
         WHEN ('DELCONF-OU') THEN
            transaction_code_ := 'UNDELCONOU';
         WHEN ('DELCONF-IN') THEN
            transaction_code_ := 'UNDELCONIN';
         WHEN ('CO-DELV-IN') THEN
            transaction_code_ := 'UNCODELVIN';
         WHEN ('CO-DELV-OU') THEN
            transaction_code_ := 'UNCODELVOU';
         WHEN ('OESHIPNI') THEN
            transaction_code_ := 'OEUNSHIPNI';
         WHEN ('CO-OESHIP') THEN
            transaction_code_ := 'COOEUNSHIP';
         WHEN ('PODIRSH') THEN
            transaction_code_ := 'POUNDIRSH';
         WHEN ('PODIRSH-NI') THEN
            transaction_code_ := 'UNPODIR-NI';
         WHEN ('INTPODIRIM') THEN
            transaction_code_ := 'UNINPODRIM';
         WHEN ('PODIRINTEM') THEN
            transaction_code_ := 'UNPODRINEM';
         WHEN ('INTPODIRSH') THEN
            transaction_code_ := 'UNINTPODIR';         
         WHEN ('SHIPDIR') THEN
            transaction_code_ := 'UNSHIPDIR';
         WHEN ('CO-SHIPDIR') THEN
            transaction_code_ := 'COUNSHPDIR';
         WHEN ('SHIPTRAN') THEN
            transaction_code_ := 'UNSHIPTRAN';
         WHEN ('CO-SHIPTRN') THEN
            transaction_code_ := 'COUNSHPTRN';
         WHEN ('INTSHIP-NI') THEN
            transaction_code_ := 'UNINTSHPNI';
         ELSE
            NULL;
         END CASE;            
      
      shipment_id_ := Customer_Order_Delivery_API.Get_Shipment_Id(deliv_no_);
      IF (shipment_id_ != 0) THEN
         Inventory_Part_In_Stock_API.Unissue_Part(new_transaction_id_,
                                                  transaction_code_,
                                                  'INVREVAL+',
                                                  'INVREVAL-',
                                                  inv_tran_rec_.quantity,
                                                  inv_tran_rec_.catch_quantity,
                                                  inv_tran_rec_.transaction_id,
                                                  inv_tran_rec_.source,
                                                  FALSE);      
      ELSE
         Inventory_Part_In_Stock_API.Unissue_Part(new_transaction_id_,
                                                  transaction_code_,
                                                  'INVREVAL+',
                                                  'INVREVAL-',
                                                  inv_tran_rec_.quantity,
                                                  inv_tran_rec_.catch_quantity,
                                                  inv_tran_rec_.transaction_id,
                                                  inv_tran_rec_.source);
      END IF;                                            
      transaction_exist_ := TRUE;
      
      IF (inv_tran_rec_.serial_no != '*') THEN         
         Part_Serial_Catalog_API.Remove_Warranty_Dates(inv_tran_rec_.part_no, inv_tran_rec_.serial_no);         
      END IF;
   END LOOP;
   
   IF (line_item_no_ >= 0) THEN
      IF NOT transaction_exist_ THEN
         ord_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
         ord_rec_      := Customer_Order_API.Get(order_no_);
         IF (ord_line_rec_.supply_code = 'NO' AND ord_rec_.delay_cogs_to_deliv_conf = 'TRUE') THEN
            non_inv_delay_cogs_exist_ := TRUE;   
         ELSE 
            -- Undo not supported for the deliveries made before APP9 UPDATE1.
            Error_SYS.Record_General(lu_name_, 'DELIVNOTUNDONE: Customer order delivery has not been undone.');
         END IF;
      END IF;
   END IF;
   
   Inventory_Event_Manager_API.Start_Session;
   IF transaction_exist_ OR non_inv_delay_cogs_exist_ THEN
      FOR rec_ IN get_reservation_info LOOP
         qty_shipped_   := 0;
         qty_assigned_  := rec_.qty_assigned + rec_.qty_shipped;
         qty_picked_    := rec_.qty_picked + rec_.qty_shipped;
         
         IF rec_.catch_qty IS NOT NULL THEN
            catch_qty_ := rec_.catch_qty_shipped;
         END IF;
         IF rec_.catch_qty_shipped IS NOT NULL THEN
            catch_qty_shipped_ := 0;
         END IF;

         Customer_Order_Reservation_API.Modify_On_Undo_Delivery__(order_no_            => order_no_, 
                                                                  line_no_             => line_no_, 
                                                                  rel_no_              => rel_no_, 
                                                                  line_item_no_        => line_item_no_, 
                                                                  contract_            => rec_.contract, 
                                                                  part_no_             => rec_.part_no, 
                                                                  location_no_         => rec_.location_no, 
                                                                  lot_batch_no_        => rec_.lot_batch_no, 
                                                                  serial_no_           => rec_.serial_no, 
                                                                  eng_chg_level_       => rec_.eng_chg_level, 
                                                                  waiv_dev_rej_no_     => rec_.waiv_dev_rej_no, 
                                                                  activity_seq_        => rec_.activity_seq, 
                                                                  handling_unit_id_    => rec_.handling_unit_id, 
                                                                  pick_List_no_        => rec_.pick_list_no,
                                                                  configuration_id_    => rec_.configuration_id, 
                                                                  shipment_id_         => rec_.shipment_id, 
                                                                  qty_shipped_         => qty_shipped_, 
                                                                  qty_assigned_        => qty_assigned_, 
                                                                  qty_picked_          => qty_picked_, 
                                                                  catch_qty_shipped_   => catch_qty_shipped_, 
                                                                  catch_qty_           => catch_qty_, 
                                                                  deliv_no_            => TO_NUMBER(NULL));
         
         Inventory_Part_In_Stock_API.Reserve_Part(dummy_number_, rec_.contract, rec_.part_no, rec_.configuration_id, 
                                                  rec_.location_no, rec_.lot_batch_no, rec_.serial_no, 
                                                  rec_.eng_chg_level, rec_.waiv_dev_rej_no, rec_.activity_seq, 
                                                  rec_.handling_unit_id, rec_.qty_shipped);
         
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
      
      unissue_complete_ := 'TRUE';      
   END IF;
END Unissue_Delivered_Parts___;

FUNCTION Delivered_Comp_Line_Exists___(
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER := 0;
   
   CURSOR delivered_comp_line_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN delivered_comp_line_exist;
   FETCH delivered_comp_line_exist INTO dummy_;
   CLOSE delivered_comp_line_exist;

   IF dummy_ = 1 THEN
      RETURN TRUE;
   ELSE      
      RETURN FALSE;
   END IF;
END Delivered_Comp_Line_Exists___;


PROCEDURE Update_Qty_In_Scheduling___ (
   order_no_         IN VARCHAR2,
   contract_         IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   ship_addr_no_     IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   qty_shipped_      IN NUMBER )
IS
   cum_shipped_qty_      NUMBER := 0;
   agreement_id_         VARCHAR2(17);
BEGIN
   $IF (Component_Cussch_SYS.INSTALLED) $THEN
      agreement_id_ := Cust_Sched_Agreement_API.Get_Current_Agreement (customer_no_, customer_part_no_, ship_addr_no_);
      cum_shipped_qty_ := Cust_Sched_Agreement_Part_API.Get_Cum_Shipped_Qty(customer_no_, ship_addr_no_, agreement_id_, customer_part_no_);

      Cust_Sched_Cum_Manager_API.Update_Cum_Qty(order_no_, customer_no_, ship_addr_no_, contract_, customer_part_no_, -1 * (LEAST(qty_shipped_, cum_shipped_qty_)));
   $ELSE
      NULL;
   $END 
END Update_Qty_In_Scheduling___;


PROCEDURE Validate_Conn_Purch_Line___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   demand_code_  IN VARCHAR2)
IS     
   demand_order_ref1_ customer_order_line_tab.demand_order_ref1%TYPE;
   demand_order_ref2_ customer_order_line_tab.demand_order_ref2%TYPE;
   demand_order_ref3_ customer_order_line_tab.demand_order_ref3%TYPE;
   demand_order_ref4_ customer_order_line_tab.demand_order_ref4%TYPE;
   purch_comp_exist_  NUMBER;
   state_             VARCHAR2(40);
   validate_demand_   VARCHAR2(5) := 'TRUE';
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF demand_code_ = 'PO' THEN
         purch_comp_exist_ := Pur_Ord_Charged_Comp_API.Is_Comp_Line_Exists_For_Col(order_no_, line_no_, rel_no_, line_item_no_);
         IF (purch_comp_exist_ != 1) THEN
            validate_demand_ := 'FALSE';
         END IF;
      END IF;
      
      IF (validate_demand_ = 'TRUE')  THEN
         Customer_Order_Line_API.Get_Demand_Order_Info(demand_order_ref1_, 
                                                       demand_order_ref2_,
                                                       demand_order_ref3_ ,
                                                       demand_order_ref4_,
                                                       order_no_,
                                                       line_no_,
                                                       rel_no_,
                                                       line_item_no_);
         state_ := Purchase_Order_Line_API.Get_Objstate(demand_order_ref1_, demand_order_ref2_, demand_order_ref3_);
         IF (state_ IN ('Arrived', 'Closed', 'Received')) THEN
            Error_SYS.Record_General(lu_name_, 'CONPOARRIVED: Cannot undo the delivery since the connected purchase order line :P1 is in :P2 status.',demand_order_ref1_ || ' /' || demand_order_ref2_ || ' /' ||demand_order_ref3_, Purchase_Order_Line_API.Get_State(demand_order_ref1_, demand_order_ref2_, demand_order_ref3_));
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
END Validate_Conn_Purch_Line___;

PROCEDURE Undo_Cust_Ord_Delivery___ (
   rental_      OUT VARCHAR2,
   order_no_    IN VARCHAR2,
   shipment_id_ IN NUMBER,
   delnote_no_  IN VARCHAR2)
IS
   delivery_exist_  BOOLEAN := FALSE;
   supply_code_     CUSTOMER_ORDER_LINE_TAB.supply_code%TYPE;
   pkg_qty_shipped_ NUMBER; 
   
   CURSOR get_delivery_info IS
     SELECT order_no, line_no, rel_no, line_item_no, deliv_no
     FROM   CUSTOMER_ORDER_DELIVERY_TAB
     WHERE  (order_no = order_no_ OR order_no_ IS NULL)
     AND    NVL(shipment_id, 0) = NVL(shipment_id_, 0)
     AND    NVL(delnote_no, Database_SYS.string_null_) = NVL(delnote_no_, Database_SYS.string_null_)
     AND    cancelled_delivery = 'FALSE'
     ORDER BY order_no, line_no, rel_no, line_item_no DESC;
     
   CURSOR get_incomp_pkg_headers(order_no_ VARCHAR2) IS
      SELECT order_no, line_no, rel_no, deliv_no
      FROM   CUSTOMER_ORDER_DELIVERY_TAB a
      WHERE  a.order_no = order_no_
      AND    NVL(a.shipment_id, 0) = NVL(shipment_id_, 0)
      AND    NVL(a.delnote_no, Database_SYS.string_null_) = NVL(delnote_no_, Database_SYS.string_null_)
      AND    NOT EXISTS ( SELECT 1
                          FROM CUSTOMER_ORDER_DELIVERY_TAB b
                          WHERE b.order_no = a.order_no
                          AND   b.line_no = a.line_no
                          AND   b.rel_no  = a.rel_no
                          AND   b.line_item_no = -1);
                          
   CURSOR get_delivered_pkg IS
      SELECT order_no, line_no, rel_no, deliv_no
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   cancelled_delivery = 'FALSE'
      AND   line_item_no = -1;

   CURSOR get_pkg_shipped IS
      SELECT SUM(qty_shipped)
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   cancelled_delivery = 'FALSE'
      AND   line_item_no = -1
      GROUP BY order_no, line_no, rel_no;
BEGIN
   rental_ := 'FALSE';   
   IF shipment_id_ IS NOT NULL THEN
      rental_ := Shipment_Source_Utility_API.Any_Rental_Line_Exists(shipment_id_);
      Shipment_API.Undo_Shipment_Delivery(shipment_id_);
   END IF;
   
   IF (Check_Undo_Ord_Deliv___(order_no_, shipment_id_, delnote_no_) AND shipment_id_ IS NULL) THEN
      FOR rec_ IN get_delivery_info LOOP
         supply_code_ := Customer_Order_Line_API.Get_Supply_Code_Db(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         rental_          := Customer_Order_Line_API.Get_Rental_Db(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         
         IF (rental_ = 'TRUE') THEN
            rental_ := 'TRUE';
         END IF;   
         -- Need to cancel the receipt which is created in PODIRSH flow. This block will execute when Undo delivery from header
         IF (supply_code_ IN ('PD', 'IPD')) THEN
            $IF Component_Purch_SYS.INSTALLED $THEN
               Purchase_Order_Line_Part_API.Undo_Direct_Delivery(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.deliv_no);
            $ELSE
               NULL;
            $END
         END IF;
         Customer_Order_API.Undo_Line_Delivery(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.deliv_no);
         delivery_exist_ := TRUE;
      END LOOP;
      IF (delivery_exist_ AND delnote_no_ IS NOT NULL  AND 
          Delivery_Note_API.Get_Objstate(delnote_no_) != 'Invalid') THEN
         Delivery_Note_API.Set_Invalid(delnote_no_);
      END IF;
      
      FOR pkg_rec_ IN get_incomp_pkg_headers(order_no_) LOOP
         Customer_Order_API.Undo_Line_Delivery(pkg_rec_.order_no, pkg_rec_.line_no,  pkg_rec_.rel_no, -1, pkg_rec_.deliv_no);        
      END LOOP;
   END IF;

   FOR rec_ IN get_delivered_pkg LOOP
      OPEN get_pkg_shipped;
      FETCH get_pkg_shipped INTO pkg_qty_shipped_;
      CLOSE get_pkg_shipped;
      IF pkg_qty_shipped_ > Customer_Order_Line_API.Get_Packages_Shipped(rec_.order_no, rec_.line_no,  rec_.rel_no) THEN 
         Customer_Order_API.Undo_Line_Delivery(rec_.order_no, rec_.line_no,  rec_.rel_no, -1, rec_.deliv_no);    
      END IF;
   END LOOP;
END Undo_Cust_Ord_Delivery___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Cancel Delivery of inventory lines on a delivery.
PROCEDURE Undo_Cust_Ord_Line_Delivery__ (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   deliv_no_       IN NUMBER )
IS
   unissue_complete_ VARCHAR2(5) := 'FALSE';
   pkg_deliv_no_     NUMBER;   
   qty_shipped_      NUMBER;
   pkg_qty_shipped_  NUMBER;
   attr_             VARCHAR2(2000);
   pkg_delnote_no_   VARCHAR2(15);
   
   CURSOR get_pkg_header_deliv_no IS
      SELECT deliv_no
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no      = order_no_
      AND    line_no       = line_no_
      AND    rel_no        = rel_no_
      AND    line_item_no  = -1
      AND    deliv_no      >= deliv_no_
      AND    qty_invoiced  = 0 
	   AND    cancelled_delivery = 'FALSE'
      ORDER BY deliv_no;
   CURSOR get_pkg_qty IS   
      SELECT NVL(MIN(TRUNC(qty_shipped * (inverted_conv_factor/conv_factor)/qty_per_assembly)),0) qty_shipped
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no  = line_no_
      AND    rel_no   = rel_no_
      AND    line_item_no > 0
      AND    rowstate != 'Cancelled'
      AND    new_comp_after_delivery = 'FALSE';
   
   CURSOR get_pkg_delnote_no IS
      SELECT delnote_no
      FROM CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no      = order_no_
      AND    line_no       = line_no_
      AND    rel_no        = rel_no_
      AND    line_item_no  = -1
      AND    deliv_no      = deliv_no_
      AND    cancelled_delivery = 'FALSE';
      
   CURSOR get_pkg_deliv_nos IS
      SELECT deliv_no
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no      = order_no_
      AND    line_no       = line_no_
      AND    rel_no        = rel_no_
      AND    line_item_no  = -1      
      AND    qty_invoiced  = 0 
	   AND    cancelled_delivery = 'FALSE'
      ORDER BY deliv_no;
      
BEGIN   
   IF (line_item_no_ >= 0)THEN
      Unissue_Delivered_Parts___(unissue_complete_, order_no_, line_no_, rel_no_, line_item_no_, deliv_no_);
   END IF;
   IF (unissue_complete_ = 'TRUE') OR (line_item_no_ = -1)THEN
      IF (line_item_no_ != -1)THEN
         Customer_Order_Delivery_API.Set_Cancelled_Delivery(deliv_no_, 'TRUE');
      ELSE
         -- PACKAGE
         OPEN get_pkg_qty;
         FETCH get_pkg_qty INTO qty_shipped_;
         CLOSE get_pkg_qty;
         
         OPEN get_pkg_delnote_no;
         FETCH get_pkg_delnote_no INTO pkg_delnote_no_;
         CLOSE get_pkg_delnote_no;
         
         IF (pkg_delnote_no_ IS NULL) THEN
            -- Packages with components which are having supply code IPD and PD or delivery note is not created.            
            IF (qty_shipped_ = 0) THEN
               -- All components are unissued, no full packages.
               FOR rec_ IN get_pkg_deliv_nos LOOP 
                  IF (rec_.deliv_no IS NOT NULL) THEN
                     -- Flag needs to be set in all packages. 
                     Customer_Order_Delivery_API.Set_Cancelled_Delivery(rec_.deliv_no, 'TRUE');
                  END IF;  
               END LOOP;
            ELSE
               IF (deliv_no_ IS NOT NULL) THEN
                  Customer_Order_Delivery_API.Set_Cancelled_Delivery(deliv_no_, 'TRUE');
               END IF;
            END IF;
         ELSE            
            IF (deliv_no_ IS NOT NULL) THEN
               pkg_qty_shipped_ := Customer_Order_Delivery_API.Get_Qty_Shipped(deliv_no_);
            END IF;

            IF qty_shipped_ = 0 THEN 
               FOR rec_ IN get_pkg_header_deliv_no LOOP 
                  IF (rec_.deliv_no IS NOT NULL) THEN
                     Customer_Order_Delivery_API.Set_Cancelled_Delivery(rec_.deliv_no, 'TRUE');
                  END IF;  
               END LOOP;
            ELSIF  qty_shipped_ < pkg_qty_shipped_ THEN
               IF (deliv_no_ IS NOT NULL) THEN
                  Customer_Order_Delivery_API.Modify_Qty_Shipped(deliv_no_,  pkg_qty_shipped_ - qty_shipped_);
                  Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
                  Client_SYS.Add_To_Attr('QTY_EXPECTED', qty_shipped_, attr_);
                  Outstanding_Sales_API.Modify(deliv_no_, attr_);
               END IF; 
            ELSE          
               OPEN  get_pkg_header_deliv_no;
               FETCH get_pkg_header_deliv_no INTO pkg_deliv_no_;
               CLOSE get_pkg_header_deliv_no;

               IF (pkg_deliv_no_ IS NOT NULL) THEN
                  Customer_Order_Delivery_API.Set_Cancelled_Delivery(pkg_deliv_no_, 'TRUE');
               END IF;
            END IF;
         END IF;
      END IF;
      
      IF (line_item_no_ = -1) THEN
         Modify_Qty_On_Undo_Delivery___(order_no_, line_no_, rel_no_, line_item_no_, pkg_deliv_no_); 
      ELSE
         Modify_Qty_On_Undo_Delivery___(order_no_, line_no_, rel_no_, line_item_no_, deliv_no_); 
      END IF;
   END IF;
END Undo_Cust_Ord_Line_Delivery__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Cancel Delivery
PROCEDURE Undo_Cust_Ord_Delivery (
   order_no_    IN VARCHAR2,
   shipment_id_ IN NUMBER,
   delnote_no_  IN VARCHAR2)
IS
   dummy_ VARCHAR2 (20);
BEGIN
   Undo_Cust_Ord_Delivery___(dummy_,order_no_,shipment_id_,delnote_no_);
END Undo_Cust_Ord_Delivery;
   
PROCEDURE Undo_Cust_Ord_Line_Delivery (
   attr_ IN VARCHAR2)
IS
   name_          VARCHAR2(30);
   value_         VARCHAR2(2000);
   ptr_           NUMBER := NULL;
   deliv_no_      NUMBER;   
   order_no_      VARCHAR2(12);
   line_no_       VARCHAR2(4);
   rel_no_        VARCHAR2(4);
   line_item_no_  NUMBER;
   supply_code_   CUSTOMER_ORDER_LINE_TAB.supply_code%TYPE;
   pkg_deliv_no_  NUMBER;

   CURSOR get_delivery_info IS
      SELECT cod.order_no, cod.line_no, cod.rel_no, cod.line_item_no, col.supply_code 
      FROM   customer_order_delivery_tab cod, customer_order_line_tab col
      WHERE  cod.order_no = col.order_no
      AND    cod.line_no  = col.line_no
      AND    cod.rel_no   = col.rel_no
      AND    cod.line_item_no = col.line_item_no
      AND    deliv_no = deliv_no_
      AND    cancelled_delivery = 'FALSE';
   CURSOR get_pkg_header_deliv_no IS
      SELECT deliv_no
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no      = order_no_
      AND    line_no       = line_no_
      AND    rel_no        = rel_no_
      AND    line_item_no  = -1
      AND    deliv_no      >= deliv_no_
      AND    qty_invoiced  = 0 
	   AND    cancelled_delivery = 'FALSE'
      ORDER BY deliv_no;   
BEGIN
   -- Retrieve all records to be delivered from the attribute string.
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'DELIV_NO') THEN
         deliv_no_   := Client_SYS.Attr_Value_To_Number(value_);
         
         OPEN get_delivery_info;
         FETCH get_delivery_info INTO order_no_, line_no_, rel_no_, line_item_no_, supply_code_;
         CLOSE get_delivery_info;
         
         IF line_item_no_ >= 0 THEN
            IF (Check_Undo_Ord_Line_Deliv___(order_no_, line_no_, rel_no_, line_item_no_, deliv_no_, TRUE)) THEN
               -- Need to cancel the receipt which is created in PODIRSH flow. This block will execute when Undo delivery from line level
               IF (supply_code_ IN ('PD', 'IPD')) THEN
                  $IF Component_Purch_SYS.INSTALLED $THEN
                     Purchase_Order_Line_Part_API.Undo_Direct_Delivery(order_no_, line_no_, rel_no_, line_item_no_, deliv_no_);
                  $ELSE
                     NULL;
                  $END
               END IF;
               Customer_Order_API.Undo_Line_Delivery(order_no_, line_no_, rel_no_, line_item_no_, deliv_no_);
               IF (line_item_no_ > 0)  THEN
                  OPEN get_pkg_header_deliv_no;
                  FETCH get_pkg_header_deliv_no INTO pkg_deliv_no_;
                  CLOSE get_pkg_header_deliv_no;
                  Customer_Order_API.Undo_Line_Delivery(order_no_, line_no_, rel_no_, -1, pkg_deliv_no_);                       
               END IF;
            ELSE
               EXIT;
            END IF;
         END IF;         
      END IF;      
   END LOOP;      
END Undo_Cust_Ord_Line_Delivery;

-- Cancel Delivery
PROCEDURE Undo_Cust_Ord_Delivery (
   rental_      OUT VARCHAR2,
   order_no_    IN VARCHAR2,
   shipment_id_ IN NUMBER,
   delnote_no_  IN VARCHAR2)
IS
BEGIN
   Undo_Cust_Ord_Delivery___(rental_,order_no_,shipment_id_,delnote_no_);

END Undo_Cust_Ord_Delivery;

FUNCTION Check_Undo_Ord_Line_Deliv(
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   deliv_no_           IN NUMBER,
   from_undo_co_line_  IN BOOLEAN,
   shipment_id_        IN NUMBER DEFAULT NULL) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Undo_Ord_Line_Deliv___(order_no_, line_no_, rel_no_, line_item_no_, deliv_no_, from_undo_co_line_, shipment_id_);
END Check_Undo_Ord_Line_Deliv;
