-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderDelivery
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211109  Asawlk  SC21R2-5452, Added method Get_Sender_Receiv_Tax_Info(). 
--  200512  MalLlk  GESPRING20-4424, Modified New() to add parameter shipment_id_ and save it when delivery note number is null.
--  200323  WaSalk  GESPRING20-3910, Added Get_Qty_Ship_Deliv_Undo() to get correct quantity  when alt_delnote_no_chronologic applicable.
--  200212  NiEdlk  Bug 152123 (SCZ-8776), Added Modify_Qty_Shipped to modify the qty_shipped, qty_to_invoice attributes and 
--                  to update the relevant outstanding sales records with correct quantities.
--  200207  WaSalk  GESPRING20-1930, Modified Modify_Date_Applied() to get the date_applied_ value from Company_Invent_Info_API.Get_Auto_Update_Date_Applie_Db().
--  200207  kusplk  GESPRING20-1792, Added Modify_Delivery_Info method to update additional information in Inventory Transaction History.
--  190121  KiSalk  Bug 146057(SCZ-2526), Made cost_ passed in correct parameter order to call New in Reduce_And_Copy.
--  170125  MeAblk  STRSC-5269, Added method Get_First_Delivery_Date() to get the date of first undone delivery.
--  161228  MeAblk  Bug 133277, Modified Get_Actual_Shipment_Date() to avoid considering cancelled deliveries.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160215  MeAblk  Bug 127162, Modified methods Get_Pkg_Comp_Total_Inv_Cost(), Get_Pkg_Comp_Total_Cost(), Get_Pkg_Delivery_Cost() to correctly calculate the 
--  160215          delivery cost correctly when having undone delivery lines.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151028  MeAblk  Bug 125402, Added methods Get_Pkg_Comp_Total_Inv_Cost(), Get_Pkg_Comp_Total_Cost() and Get_Pkg_Delivery_Cost() to be 
--  151028          used when creating invoiced sales statistics.
--  150818  HimRlk  Bug 122790, Modified Get_Qty_Delivered() by changing parameters and where clause to query by deliv_no.
--  150722  PrYaLK  Bug 123113, Added new public method Get_Actual_Shipment_Date().
--  150716  HimRlk  Bug 122790, Added new public method Get_Qty_Delivered.
--  150528  IsSalk  KES-510, Added Set_Cancelled_Delivery().
--  150526  IsSalk  KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150526          Added new column CANCELLED_DELIVERY and modified New()and Prepare_Insert___() to pass default values.
--  131202  NaLrlk  Modified New() to start rental automatically for both inventory and non-inventory parts.
--  121219  RoJalk  Modified Insert___ and called Shipment_Order_Line_API.Modify_On_Delivery instead of Modify_Qty_Shipped. 
--  121218  RoJalk  Modified Update___ and removed the method call Shipment_Order_Line_API.Modify_Qty_Shipped.
--  121115  RoJalk  Modified Insert___, Update___ and called Shipment_Order_Line_API.Modify_Qty_Shipped.
--  121109  RoJalk  Modified New and replaced Shipment_Order_Line_API.Get_Active_Shipment_Id with Customer_Order_Deliv_Note_API.Get_Shipment_Id
--  121109          since multiple shipments are connected to the order line. 
--  120103  Darklk  Bug 99815, Added the column cost and the procedure Modify_Cost.
--  130402  Vwloza  Renamed Get_Start_Rent_Option_Db call to Get_Start_Rental_Option_Db.
--  130218  Vwloza  Renamed auto_start_rental_option refs to start_rental_option.
--  130124  THTHLK  Modified New to Auto Start Rental.
--  120125  ChJalk  Modified the view comments to correct the flags of DATE_CONFIRMED and DELNOTE_NO.
--  110303  MalLlk  Modified the where clause to removed the user allowed site filter from CUSTOMER_ORDER_DELIVERY_NOTES.
--  110131  Nekolk  EANE-3744  added where clause to View CUSTOMER_ORDER_DELIVERY.
--  100517  Ajpelk  Merge rose method documentation
-- ----------------------------Eagle-------------------------------------------
--  100512  NWeelk  Bug 90590, Added not null checks for SHIP_ADDR_NO in methods Unpack_Check_Insert___ and in Unpack_Check_Update___. 
--  100426  NWeelk  Bug 90016, Added column airway_bill_no and added parameter airway_bill_no_ to method New.
--  100422  NWeelk  Bug 90111, Added column ship_addr_no and added parameter ship_addr_no_ to method New.
--  080108  SaJjlk  Bug 69557, Added column delivery_note_ref and added parameter delivery_note_ref_ to method New.
--  050922  NaLrlk  Removed unused variables.
--  050906  AnLaSe  Removed check for date_confirmed in Unpack_Check_Update___.
--  050901  AnLaSe  Removed check for Get_Date_Confirmed in method Modify_Delivery_Confirmed to enable setting 
--                  date_confirmed on multiple consignment stock consumptions.
--  050826  JaBalk  Added Get_Incorrect_Del_Confirmation, Get_Incorrect_Del_Conf_Db.
--  050826  JaBalk  Added Get_Shipment_Delivered_Date.
--  050819  AnLaSe  Added check for consignment in Unpack_Check_Insert___.
--  050727  KeFelk  Added method Set_Qty_Confirmed_Arrived.
--  050705  KeFelk  Added public attribute Qty_Confirmed_Arrived and method Modify_Qty_Confirmed_Arrived.
--  050427  JoEd    Changed Reduce_And_Copy to handle catch quantity.
--  050419  JoEd    Added method Reduce_And_Copy.
--                  Added "default" value for date confirmed if not using delivery confirmation.
--  050406  JoEd    Added method Modify_Delivery_Confirmed.
--  050401  DaZase  Added incorrect_del_confirmation.
--  050318  JoEd    Added public attribute DATE_CONFIRMED. Added method Get_Latest_Date_Confirmed.
--  050107  GeKalk  Added Shipment_ID parameter to Customer_Order_Delivery_tab
--  050107          and modified New() to add values of shipment_id to the table.
--  041210  SaJjlk  Added customer_qty to view CREATE_SELF_BILLING and moved view to OrderSelfBillingManager.apy.
--  041119  IsAnlk  Modified Insert___ and Update___ to set catch_qty_shipped null for normal parts.
--  041026  IsAnlk  Added catch_qty_shipped.
--  040624  KeFelk  Added NVL to confirmed_sbi_qty in the Unpack_Check_Update.
--  040330  ChJalk  Bug 43762, Modified the view VIEW_NOTE.
--  040219  IsWilk  Removed the SUBSTRB from the view for Unicode Changes.
--  --------------- Edge Package Group 3 Unicode Changes-----------------------
--  030121  GeKaLk  Modified CREATE_SELF_BILLING view.
--  021115  GeKaLk  Include Shipment Id to the CREATE_SELF_BILLING view.
--  021107  GeKaLk  Rearrange the where statement of the CREATE_SELF_BILLING creation.
--  021011  GeKaLk  Added a check for shipment_connected and shipment state to the where
--                  statement of the CREATE_SELF_BILLING creation.
--  021004  GeKaLk  Call Id 88988, Add cust_fee_code and order by to the CREATE_SELF_BILLING.
--  020930  GeKaLk  Changed the WHERE statement of view CREATE_SELF_BILLING to avoid
--                  showing lines with qty_to_match <=0
--  020507  GeKaLk  Changed a View CREATE_SELF_BILLING.
--  020402  GeKaLk  Added a new View CREATE_SELF_BILLING.
--  020402  GeKaLk  Added new Functions Modify_Confirmed_Sbi_Qty and Get_Confirmed_Sbi_Qty.
--  ********************* VSHSB Merge *****************************
--  031008  PrJalk  Bug Fix 106224, Added Missing General_Sys.Init_Method calls.
--  021212  Asawlk  Merged bug fixes in 2002-3 SP3
--  020917  AjShlk  Bug 32760, Added the FUNCTION Get_Delivered_Date.
--  000912  JoEd  Added Get_Next_Deliv_No. Added deliv_no to New.
--                Made it possible to set a value on deliv_no.
--  --------------------------- 12.1 ----------------------------------------
--  000124  JoEd  Removed objid and objversion from VIEW_NOTE.
--                Only used in client file delnocre.apt - joined with
--                CUSTOMER_ORDER view in that client tablewindow.
--  --------------------------- 12.0 ----------------------------------------
--  991007  JoEd  Call Id 21210: Corrected double-byte problems.
--  --------------------------- 11.1 ----------------------------------------
--  990430  JoAn  Made attribute qty_shipped public, added Get_Qty_Shipped
--  990414  PaLj  Yoshimura - New Template
--  981207  JoEd  Changed comment on qty_shipped.
--  980918  RaKu  Removed Modify_Invoice_No, Modify_Invoice_Line_No.
--                Removed invoice_no and invoice_line_no from LU.
--  980910  RaKu  Added parameters in procedure New.
--  980908  RaKu  Added QTY_TO_INVOICE and QTY_INVOICED.
--                Added functions Get_Qty_To_Invoice and Get_Qty_Invoiced.
--                Added procedures Modify_Qty_To_Invoice, Modify_Qty_Invoiced
--                and Modify_Attribute___.
--  971120  RaKu  Changed to FND200 Templates.
--  971022  RaKu  Added view CUSTOMER_ORDER_DELIVERY_NOTES for performance reason.
--  960402  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Attribute___
--   Generic method for update of attributes.
PROCEDURE Modify_Attribute___ (
   deliv_no_ IN NUMBER,
   attr_     IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_DELIVERY_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_DELIVERY_TAB%ROWTYPE;
   newattr_    VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(deliv_no_);
   newrec_ := oldrec_;
   newattr_ := attr_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Update___(oldrec_, newrec_, indrec_, newattr_);
   Update___(objid_, oldrec_, newrec_, newattr_, objversion_, TRUE);
END Modify_Attribute___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_DELIVERY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
  partca_rec_    PART_CATALOG_API.Public_Rec;
  part_no_       CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;

BEGIN
   IF (newrec_.deliv_no IS NULL) THEN
      -- Retrieve a new delivery_no
      newrec_.deliv_no := Get_Next_Deliv_No;
      Client_SYS.Add_To_Attr('DELIV_NO', newrec_.deliv_no, attr_);
   END IF;

   IF newrec_.catch_qty_shipped IS NOT NULL THEN
      part_no_ := Customer_Order_Line_API.Get_Part_No(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      partca_rec_ := Part_Catalog_API.Get(part_no_);
      IF (partca_rec_.catch_unit_enabled = 'FALSE') THEN
          newrec_.catch_qty_shipped := NULL;
      END IF;
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   IF (newrec_.shipment_id != 0) THEN
      Shipment_Line_API.Modify_On_Delivery(newrec_.shipment_id, newrec_.order_no, newrec_.line_no,
                                           newrec_.rel_no, newrec_.line_item_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ORDER_DELIVERY_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ORDER_DELIVERY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   partca_rec_    PART_CATALOG_API.Public_Rec;
   part_no_       CUSTOMER_ORDER_LINE_TAB.part_no%TYPE;

BEGIN
   IF newrec_.catch_qty_shipped IS NOT NULL THEN
      part_no_ := Customer_Order_Line_API.Get_Part_No(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
      partca_rec_ := Part_Catalog_API.Get(part_no_);
      IF (partca_rec_.catch_unit_enabled = 'FALSE') THEN
          newrec_.catch_qty_shipped := NULL;
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_delivery_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN   
   newrec_.confirmed_sbi_qty := NVL(newrec_.confirmed_sbi_qty, 0);
   newrec_.incorrect_del_confirmation := NVL(newrec_.incorrect_del_confirmation, 'FALSE');

   super(newrec_, indrec_, attr_);
   
   -- if not using delivery confirmation, set delivery to confirmed right away (i.e. automatic confirmation)
   -- date confirmed for consignment stock will be set at consume of consignment stock.
   IF (newrec_.date_confirmed IS NULL) AND (Customer_Order_API.Get_Confirm_Deliveries_Db(newrec_.order_no) = 'FALSE') AND
      (Customer_Order_Line_API.Get_Consignment_Stock_Db(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no) = 'NO CONSIGNMENT STOCK') THEN
      newrec_.date_confirmed := trunc(newrec_.date_delivered);
      Client_SYS.Add_To_Attr('DATE_CONFIRMED', newrec_.date_confirmed, attr_);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_delivery_tab%ROWTYPE,
   newrec_ IN OUT customer_order_delivery_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.confirmed_sbi_qty := NVL(newrec_.confirmed_sbi_qty, 0);
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CANCELLED_DELIVERY_DB', 'FALSE', attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Total_Cost (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER  ) RETURN NUMBER
IS
   temp_ CUSTOMER_ORDER_DELIVERY_TAB.cost%TYPE;
   CURSOR get_total_cost IS
      SELECT SUM(cost * qty_shipped)
      FROM CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no = line_item_no_
      AND   cancelled_delivery = 'FALSE';
BEGIN
   OPEN get_total_cost;
   FETCH get_total_cost INTO temp_;
   CLOSE get_total_cost;
   RETURN temp_;
END Get_Total_Cost;


@UncheckedAccess
FUNCTION Get_Pkg_Comp_Total_Inv_Cost(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   invoiced_qty_ IN NUMBER ) RETURN NUMBER
IS
   delivery_rec_       Customer_Order_Delivery_API.Public_Rec;
   line_rec_           Customer_Order_Line_API.Public_Rec;
   total_cost_         NUMBER := 0;
   pkg_shipped_qty_    NUMBER;
   qty_in_packages_    NUMBER;
   comp_delivered_qty_ NUMBER := 0;
   
   CURSOR get_deliv_no IS
      SELECT deliv_no
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no = line_item_no_
      AND   cancelled_delivery = 'FALSE'
      ORDER BY deliv_no;
   
   CURSOR get_pkg_shipped_qty IS
      SELECT NVL(SUM(qty_shipped), 0)
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no = -1
      AND   cancelled_delivery = 'FALSE';   
BEGIN
   OPEN  get_pkg_shipped_qty;
   FETCH get_pkg_shipped_qty INTO  pkg_shipped_qty_;
   CLOSE get_pkg_shipped_qty;
  
   line_rec_        := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);   
   -- Total component qty required for the already shipped full packages.
   qty_in_packages_ := (line_rec_.qty_per_assembly*line_rec_.conv_factor / line_rec_.inverted_conv_factor)*pkg_shipped_qty_;

   FOR rec_ IN get_deliv_no LOOP
      delivery_rec_ := Customer_Order_Delivery_API.Get(rec_.deliv_no);
      
      -- Check whether the accumilated partial component deliveries fulfill the fully shipped packages.
      IF (qty_in_packages_ > comp_delivered_qty_) THEN
         IF (qty_in_packages_ >=  delivery_rec_.qty_shipped) THEN
            -- Allocate the shipped qty for the full package deliveries. 
           comp_delivered_qty_ :=  comp_delivered_qty_ + delivery_rec_.qty_shipped;
         ELSE
            -- If delivered more than required qty for the packages , then allocate the cost for partially delivred qty.
           IF (invoiced_qty_ < (delivery_rec_.qty_shipped - qty_in_packages_)) THEN
              total_cost_ := total_cost_ + delivery_rec_.cost * invoiced_qty_;
           ELSE
              total_cost_ := total_cost_ + delivery_rec_.cost * (delivery_rec_.qty_shipped - qty_in_packages_);
           END IF;     
        END IF;    
      ELSE
         -- ALlocate cost for the partially component delivery.
         IF (invoiced_qty_ < delivery_rec_.qty_shipped) THEN
            total_cost_ := total_cost_ + delivery_rec_.cost * invoiced_qty_;
         ELSE
            total_cost_ := total_cost_ + delivery_rec_.cost * delivery_rec_.qty_shipped;
         END IF;
      END IF;   
   END LOOP;
   RETURN total_cost_;
END Get_Pkg_Comp_Total_Inv_Cost;   


@UncheckedAccess
FUNCTION Get_Pkg_Comp_Total_Cost(
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2 ) RETURN NUMBER
IS
   cost_ NUMBER;
   CURSOR get_pkg_comp_cost IS
      SELECT NVL(SUM(COST*qty_shipped), 0)
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no > 0
      AND   cancelled_delivery = 'FALSE';
BEGIN
   OPEN  get_pkg_comp_cost;
   FETCH get_pkg_comp_cost INTO cost_;
   CLOSE get_pkg_comp_cost;
   RETURN cost_;
END Get_Pkg_Comp_Total_Cost;   


-- This method calculates the delivery cost for a given no of full packages to be delivered when any component line is delivered.
-- This is called inside Deliver_Customer_Order_API.Deliver_Package_If_Complete___.
@UncheckedAccess
FUNCTION Get_Pkg_Delivery_Cost (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   qty_shipped_  IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_all_comp_deliveries IS
      SELECT DISTINCT line_item_no
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no > 0
      AND   cancelled_delivery = 'FALSE';
   
   CURSOR get_comp_deliveries(line_item_no_ NUMBER) IS
      SELECT *
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no = line_item_no_
      AND   cancelled_delivery = 'FALSE'
      ORDER BY deliv_no;
   
   CURSOR check_any_pkg_delivered IS
      SELECT 1
      FROM  CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   line_item_no = -1
      AND   cancelled_delivery = 'FALSE';
   
   line_rec_            Customer_Order_Line_API.Public_Rec;
   qty_in_packages_     NUMBER;
   pkg_cost_            NUMBER := 0;
   delivered_comp_qty_  NUMBER;
   delivered_pkg_exist_ NUMBER;
   cost_ NUMBER;
BEGIN
   OPEN  check_any_pkg_delivered;
   FETCH check_any_pkg_delivered INTO delivered_pkg_exist_;
   CLOSE check_any_pkg_delivered;
   
   IF (delivered_pkg_exist_ = 1) THEN
      cost_ := (Customer_Order_Delivery_API.Get_Pkg_Comp_Total_Cost(order_no_, line_no_, rel_no_) - Customer_Order_Delivery_API.Get_Total_Cost(order_no_, line_no_, rel_no_, -1))/ qty_shipped_;   
   ELSE
      FOR rec_ IN get_all_comp_deliveries LOOP
         line_rec_        :=  Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, rec_.line_item_no); 
         qty_in_packages_ :=  (line_rec_.qty_per_assembly*line_rec_.conv_factor / line_rec_.inverted_conv_factor)*qty_shipped_;
         delivered_comp_qty_ := 0;
         FOR comp_rec_ IN get_comp_deliveries(rec_.line_item_no) LOOP
           delivered_comp_qty_ := delivered_comp_qty_ + comp_rec_.qty_shipped;
            IF (qty_in_packages_ >= delivered_comp_qty_) THEN
               pkg_cost_ := pkg_cost_ + comp_rec_.cost*comp_rec_.qty_shipped;
            ELSE
               pkg_cost_ := pkg_cost_ + comp_rec_.cost*(qty_in_packages_ - ( delivered_comp_qty_ -  comp_rec_.qty_shipped));     
               EXIT;            
            END IF;
         END LOOP;   
      END LOOP;
      cost_ := pkg_cost_/qty_shipped_;
   END IF;
   RETURN cost_;
END Get_Pkg_Delivery_Cost;    


-- Modify_Component_Invoice_Flag
--   Update the component_invoice_flag attribute.
--   Update the component_invoice_flag attribute.
PROCEDURE Modify_Component_Invoice_Flag (
   deliv_no_               IN NUMBER,
   component_invoice_flag_ IN VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COMPONENT_INVOICE_FLAG', component_invoice_flag_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Modify_Component_Invoice_Flag;


-- Modify_Delnote_No
--   Update the delnote_no attribute.
PROCEDURE Modify_Delnote_No (
   deliv_no_   IN NUMBER,
   delnote_no_ IN VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DELNOTE_NO', delnote_no_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Modify_Delnote_No;


-- Modify_Qty_To_Invoice
--   Update the qty_to_invoice attribute.
PROCEDURE Modify_Qty_To_Invoice (
   deliv_no_       IN NUMBER,
   qty_to_invoice_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_TO_INVOICE', qty_to_invoice_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Modify_Qty_To_Invoice;


-- Modify_Qty_Invoiced
--   Update the QtyInvoiced attribute when invoicing a delivery
PROCEDURE Modify_Qty_Invoiced (
   deliv_no_     IN NUMBER,
   qty_invoiced_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_INVOICED', qty_invoiced_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Modify_Qty_Invoiced;


-- Modify_Qty_Shipped
--   Update the QtyShipped, QtyToInvoice attributes and the respective outstanding record.
PROCEDURE Modify_Qty_Shipped (
   deliv_no_     IN NUMBER,
   qty_shipped_  IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('QTY_TO_INVOICE', qty_shipped_, attr_);   
   Modify_Attribute___(deliv_no_, attr_);   
END Modify_Qty_Shipped;


-- New
--   Create a new CustomerOrderDelivery instance.
PROCEDURE New (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   component_invoice_flag_ IN VARCHAR2,
   load_id_                IN NUMBER,
   delnote_no_             IN VARCHAR2,
   delivery_note_ref_      IN VARCHAR2,
   qty_shipped_            IN NUMBER,
   catch_qty_shipped_      IN NUMBER,
   qty_to_invoice_         IN NUMBER,
   qty_invoiced_           IN NUMBER,
   date_delivered_         IN DATE,
   ship_addr_no_           IN VARCHAR2,
   airway_bill_no_         IN VARCHAR2,
   cost_                   IN NUMBER,
   deliv_no_               IN NUMBER DEFAULT NULL,
   shipment_id_            IN NUMBER DEFAULT NULL)
IS
   attr_               VARCHAR2(2000);
   newrec_             CUSTOMER_ORDER_DELIVERY_TAB%ROWTYPE;
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   shipment_id_to_add_ NUMBER;
   col_rec_            Customer_Order_Line_API.Public_Rec;
   indrec_             Indicator_Rec;
   
   $IF (Component_Rental_SYS.INSTALLED) $THEN
      CURSOR get_all_reservations IS
         SELECT serial_no, lot_batch_no, SUM(qty_shipped) qty_shipped
         FROM   customer_order_reservation_tab
         WHERE  order_no     = order_no_
         AND    line_no      = line_no_
         AND    rel_no       = rel_no_
         AND    line_item_no = line_item_no_
         GROUP BY serial_no, lot_batch_no;
   $END
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (deliv_no_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
   END IF;
   -- gelr:no_delivery_note_for_services, begin
   IF (delnote_no_ IS NULL AND shipment_id_ IS NOT NULL) THEN
      shipment_id_to_add_ := shipment_id_;
   ELSE
   -- gelr:no_delivery_note_for_services, end
      -- Add shipment_id connected to the delivery note
      shipment_id_to_add_ := Delivery_Note_API.Get_Shipment_Id(delnote_no_);
   END IF;
   IF (shipment_id_to_add_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_to_add_, attr_);      
   END IF;
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('COMPONENT_INVOICE_FLAG', component_invoice_flag_, attr_);
   Client_SYS.Add_To_Attr('LOAD_ID', load_id_, attr_);
   Client_SYS.Add_To_Attr('DELNOTE_NO', delnote_no_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_NOTE_REF', delivery_note_ref_, attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY_SHIPPED', catch_qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('DATE_DELIVERED', date_delivered_, attr_);
   Client_SYS.Add_To_Attr('QTY_TO_INVOICE', qty_to_invoice_, attr_);
   Client_SYS.Add_To_Attr('QTY_INVOICED', qty_invoiced_, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', ship_addr_no_, attr_);
   Client_SYS.Add_To_Attr('AIRWAY_BILL_NO', airway_bill_no_, attr_);
   Client_SYS.Add_To_Attr('COST', cost_, attr_);
   Client_SYS.Add_To_Attr('CANCELLED_DELIVERY_DB', 'FALSE', attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);   
   Insert___(objid_, objversion_, newrec_, attr_);

   col_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   IF (col_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
      $IF (Component_Rental_SYS.INSTALLED) $THEN
         IF (col_rec_.catalog_type = 'NON') THEN
            -- Non inventory Lines.
            Rental_Object_Manager_API.Start_Automatic_Co_Rental(order_no_, 
                                                                line_no_, 
                                                                rel_no_, 
                                                                line_item_no_, 
                                                                Rental_Type_API.DB_CUSTOMER_ORDER,
                                                                date_delivered_,
                                                                '*',
                                                                '*', 
                                                                qty_shipped_);

         ELSE
            -- Inventory Lines.
            FOR res_ IN get_all_reservations LOOP
               Rental_Object_Manager_API.Start_Automatic_Co_Rental(order_no_, 
                                                                   line_no_, 
                                                                   rel_no_, 
                                                                   line_item_no_, 
                                                                   Rental_Type_API.DB_CUSTOMER_ORDER,
                                                                   date_delivered_,
                                                                   res_.serial_no,
                                                                   res_.lot_batch_no, 
                                                                   (res_.qty_shipped *(col_rec_.inverted_conv_factor/col_rec_.conv_factor)));

            END LOOP;
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('RENTAL');
      $END
   END IF;
END New;


-- Get_Next_Deliv_No
--   Fetches the next deliv_no value from a sequence.
@UncheckedAccess
FUNCTION Get_Next_Deliv_No RETURN NUMBER
IS
   temp_  CUSTOMER_ORDER_DELIVERY_TAB.deliv_no%TYPE;
   CURSOR get_deliv_no IS
      SELECT mpc_deliv_no.NEXTVAL
      FROM dual;
BEGIN
   OPEN get_deliv_no;
   FETCH get_deliv_no INTO temp_;
   CLOSE get_deliv_no;
   RETURN temp_;
END Get_Next_Deliv_No;


-- Get_Delivered_Date
--   Return the Delivered Date of a order line for a delivery note.
@UncheckedAccess
FUNCTION Get_Delivered_Date (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   delnote_no_   IN VARCHAR2 ) RETURN DATE
IS
   attr_   CUSTOMER_ORDER_DELIVERY_TAB.date_delivered%TYPE;
   CURSOR get_delivered_date IS
      SELECT date_delivered
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    delnote_no = delnote_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN get_delivered_date;
   FETCH get_delivered_date INTO attr_;
   CLOSE get_delivered_date;
   RETURN attr_;
END Get_Delivered_Date;


-- Modify_Confirmed_Sbi_Qty
--   Modify the Confirmed_sbi_qty for the deliv_no_.
PROCEDURE Modify_Confirmed_Sbi_Qty (
   deliv_no_          IN NUMBER,
   confirmed_sbi_qty_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONFIRMED_SBI_QTY', confirmed_sbi_qty_ , attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Modify_Confirmed_Sbi_Qty;


-- Get_Latest_Date_Confirmed
--   Returns the date when the latest delivery confirmation was made
--   for a specific order line
@UncheckedAccess
FUNCTION Get_Latest_Date_Confirmed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN DATE
IS
   attr_  CUSTOMER_ORDER_DELIVERY_TAB.date_confirmed%TYPE;
   CURSOR get_latest IS
      SELECT MAX(date_confirmed)
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN get_latest;
   FETCH get_latest INTO attr_;
   CLOSE get_latest;
   RETURN attr_;
END Get_Latest_Date_Confirmed;


-- Modify_Delivery_Confirmed
--   Updates the delivery record when it is being confirmed.
--   Or after it has been confirmed and set to incorrect.
PROCEDURE Modify_Delivery_Confirmed (
   deliv_no_       IN NUMBER,
   qty_to_invoice_ IN NUMBER,
   date_confirmed_ IN DATE,
   incorrect_db_   IN VARCHAR2 )
IS
   attr_  VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);

   IF (qty_to_invoice_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('QTY_TO_INVOICE', qty_to_invoice_, attr_);
   END IF;

   -- update date confirmed if not already set
   IF (date_confirmed_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DATE_CONFIRMED', date_confirmed_, attr_);
   END IF;

   IF (incorrect_db_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('INCORRECT_DEL_CONFIRMATION_DB', incorrect_db_, attr_);
   END IF;

   -- only modify if any attribute is set
   IF (attr_ IS NOT NULL) THEN
      Modify_Attribute___(deliv_no_, attr_);
   END IF;
END Modify_Delivery_Confirmed;


-- Reduce_And_Copy
--   Decreases qty_shipped on the current delivery with the remaining shipped
--   qty (parameter). Then creates a copy of the delivery with the remaining
--   shipped qty.
--   Used by DelivConfirmCustOrder.
PROCEDURE Reduce_And_Copy (
   deliv_no_    IN NUMBER,
   qty_shipped_ IN NUMBER )
IS
   newrec_            CUSTOMER_ORDER_DELIVERY_TAB%ROWTYPE;
   attr_              VARCHAR2(2000);
   catch_conv_factor_ NUMBER := NULL;
   catch_qty_         NUMBER := NULL;
BEGIN
   newrec_ := Get_Object_By_Keys___(deliv_no_);

   -- reduce the current delivery's qty shipped
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', newrec_.qty_shipped - qty_shipped_, attr_);

   IF (newrec_.catch_qty_shipped IS NOT NULL) THEN
      -- calculate a "conv factor"
      catch_conv_factor_ := newrec_.catch_qty_shipped / newrec_.qty_shipped;
      catch_qty_ := (newrec_.qty_shipped - qty_shipped_) * catch_conv_factor_;
      -- change to a new catch qty
      Client_SYS.Add_To_Attr('CATCH_QTY_SHIPPED', catch_qty_, attr_);
   END IF;

   Trace_SYS.Field('Old Deliv - QTY_SHIPPED', newrec_.qty_shipped - qty_shipped_);
   Trace_SYS.Field('Old Deliv - CATCH_QTY_SHIPPED', catch_qty_);

   Modify_Attribute___(deliv_no_, attr_);

   -- remaining catch qty
   catch_qty_ := qty_shipped_ * catch_conv_factor_;

   Trace_SYS.Field('Remaining - QTY_SHIPPED', qty_shipped_);
   Trace_SYS.Field('Remaining - CATCH_QTY_SHIPPED', catch_qty_);

   -- Made cost_ pased in correct parameter order that added with 99815 in wrong order
   -- makes a copy of the record - but with a new qty shipped, remaining catch qty and nothing to invoice.
   -- we don't have to do anything with inventory - since everything is shipped and ready...
   New(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no,
       Invoice_Package_Component_API.Decode('N'), newrec_.load_id, newrec_.delnote_no, NULL,
       qty_shipped_, catch_qty_, 0, 0, newrec_.date_delivered, newrec_.ship_addr_no, NULL, newrec_.cost);
END Reduce_And_Copy;


-- Modify_Qty_Confirmed_Arrived
--   Modify the QtyConfirmedArrived attribute by adding the given value to the
PROCEDURE Modify_Qty_Confirmed_Arrived (
   deliv_no_              IN NUMBER,
   qty_confirmed_arrived_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
   qty_conf_arrived_for_update_ NUMBER;
BEGIN

   qty_conf_arrived_for_update_ := Get_Qty_Confirmed_Arrived(deliv_no_) + qty_confirmed_arrived_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_CONFIRMED_ARRIVED', qty_conf_arrived_for_update_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Modify_Qty_Confirmed_Arrived;


-- Set_Qty_Confirmed_Arrived
--   Set the QtyConfirmedArrived attribute with given value.
PROCEDURE Set_Qty_Confirmed_Arrived (
   deliv_no_              IN NUMBER,
   qty_confirmed_arrived_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_CONFIRMED_ARRIVED', qty_confirmed_arrived_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Set_Qty_Confirmed_Arrived;


-- Modify_Cost
--   Update the cost attribute
PROCEDURE Modify_Cost (
   deliv_no_   IN NUMBER,
   cost_       IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COST', cost_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Modify_Cost;


-- Get_Shipment_Delivered_Date
--   Get the delivered date for shipment delivery.
@Deprecated
FUNCTION Get_Shipment_Delivered_Date (
   delnote_no_ IN VARCHAR2 ) RETURN DATE
IS
   delivered_date_ CUSTOMER_ORDER_DELIVERY_TAB.date_delivered%TYPE;
   CURSOR get_delivered_date IS
      SELECT date_delivered
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  delnote_no = delnote_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN get_delivered_date;
   FETCH get_delivered_date INTO delivered_date_;
   CLOSE get_delivered_date;

   RETURN delivered_date_;
END Get_Shipment_Delivered_Date;


-- Get_Incorrect_Del_Conf_Db
--   Get the value of IncorrectDelConfirmation field.
@UncheckedAccess
FUNCTION Get_Incorrect_Del_Conf_Db (
   deliv_no_ IN NUMBER ) RETURN VARCHAR2
IS
   incorrect_del_confirmation_ CUSTOMER_ORDER_DELIVERY_TAB.incorrect_del_confirmation%TYPE;
   CURSOR get_attr IS
      SELECT incorrect_del_confirmation
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  deliv_no = deliv_no_
      AND    cancelled_delivery = 'FALSE';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO incorrect_del_confirmation_;
   CLOSE get_attr;
   RETURN incorrect_del_confirmation_;
END Get_Incorrect_Del_Conf_Db;

-- Set_Cancelled_Delivery
--   Set the CancelledDelivery attribute with given value.
PROCEDURE Set_Cancelled_Delivery (
   deliv_no_              IN NUMBER,
   cancelled_delivery_db_ IN VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CANCELLED_DELIVERY_DB', cancelled_delivery_db_, attr_);
   Modify_Attribute___(deliv_no_, attr_);
END Set_Cancelled_Delivery;
-- Get_Qty_Delivered
--    This method returns the delivered qty of a particular delivery,
--    for a self-billing enabled customer
@UncheckedAccess
FUNCTION Get_Qty_Delivered (
   deliv_no_   IN NUMBER ) RETURN NUMBER   
IS
   temp_ CUSTOMER_ORDER_DELIVERY_TAB.qty_shipped%TYPE;
   CURSOR get_qty_delivered IS
      SELECT cod.qty_shipped/col.conv_factor*col.inverted_conv_factor   qty_delivered
      FROM   customer_order_line_tab col, customer_order_delivery_tab cod
      WHERE  col.order_no     = cod.order_no
         AND col.line_no      = cod.line_no
         AND col.rel_no       = cod.rel_no
         AND col.line_item_no = cod.line_item_no
         AND col.rowstate IN ('PartiallyDelivered', 'Delivered')
         AND col.self_billing = 'SELF BILLING'
         AND col.line_item_no <= 0
         AND cod.deliv_no = deliv_no_;
BEGIN
   OPEN  get_qty_delivered;
   FETCH get_qty_delivered INTO temp_;
   CLOSE get_qty_delivered;
   RETURN temp_;
END Get_Qty_Delivered;
-- Get_Actual_Shipment_Date
--    This method will be used to fetch the actual ship date for a specified delivery
@UncheckedAccess
FUNCTION Get_Actual_Shipment_Date (
   shipment_id_ IN NUMBER ) RETURN DATE
IS
   delivered_date_ CUSTOMER_ORDER_DELIVERY_TAB.date_delivered%TYPE;
   CURSOR get_actual_delivered_date IS
      SELECT date_delivered
      FROM CUSTOMER_ORDER_DELIVERY_TAB
      WHERE shipment_id = shipment_id_
      AND   cancelled_delivery = 'FALSE';

BEGIN
   OPEN get_actual_delivered_date;
   FETCH get_actual_delivered_date INTO delivered_date_;
   CLOSE get_actual_delivered_date;
   
   RETURN delivered_date_;
END Get_Actual_Shipment_Date;


FUNCTION Get_First_Delivery_Date(
   order_no_     VARCHAR2,
   line_no_      VARCHAR2,
   rel_no_       VARCHAR2,
   line_item_no_ NUMBER ) RETURN DATE
IS
   first_delivered_date_ CUSTOMER_ORDER_DELIVERY_TAB.date_delivered%TYPE;
   
   CURSOR get_first_delivery_date IS
      SELECT date_delivered
      FROM CUSTOMER_ORDER_DELIVERY_TAB
      WHERE order_no = order_no_
      AND   line_no  = line_no_
      AND   rel_no   = rel_no_
      AND   cancelled_delivery = 'FALSE'
      ORDER BY deliv_no;
BEGIN
   OPEN get_first_delivery_date;
   FETCH get_first_delivery_date INTO first_delivered_date_;
   CLOSE get_first_delivery_date;
   RETURN first_delivered_date_;
END Get_First_Delivery_Date;   
   

-- gelr:modify_date_applied Begin
PROCEDURE Modify_Date_Applied (
   contract_              IN VARCHAR2,
   source_referance_id_   IN VARCHAR2,
   source_referance_type_ IN VARCHAR2,
   delnote_no_            IN VARCHAR2 )
IS
   delnote_rec_        Delivery_Note_API.Public_Rec;
   date_applied_rule_  VARCHAR2(80);
   date_applied_       DATE;
   site_date_          DATE;
   line_no_            VARCHAR2(4);
   rel_no_             VARCHAR2(4);
   line_item_no_       NUMBER;
   order_no_           VARCHAR2(20);
   dummy_info_         VARCHAR2(2000);
   deliv_no_           NUMBER;
   
   CURSOR get_delivery_lines IS
      SELECT cod.line_no,
             cod.rel_no,
             cod.line_item_no,
             cod.order_no,
             cod.deliv_no
      FROM   customer_order_delivery_tab cod, customer_order_line_tab col, sales_part_tab sp
      WHERE  sp.non_inv_part_type = 'GOODS'
      AND    sp.contract   = col.contract
      AND    sp.catalog_no = col.catalog_no
      AND    col.supply_code NOT IN ('PD','IPD')
      AND    col.order_no  = cod.order_no
      AND    col.line_no   = cod.line_no
      AND    col.rel_no    = cod.rel_no
      AND    col.line_item_no            = cod.line_item_no
      AND    ((cod.order_no              = source_referance_id_ AND source_referance_type_ = 'CUSTOMER_ORDER')
            OR(TO_CHAR(cod.shipment_id)  = source_referance_id_ AND source_referance_type_ = 'CUSTOMER_ORDER'))
      AND    cod.delnote_no              = delnote_no_;
BEGIN  
   
   delnote_rec_       := Delivery_Note_API.Get(delnote_no_);
   date_applied_rule_ := Company_Invent_Info_API.Get_Auto_Update_Date_Applie_Db(Site_API.Get_Company(contract_));
   site_date_         := Site_API.Get_Site_Date(contract_);
   IF (date_applied_rule_ = 'PRINT_DATE') THEN
      date_applied_   := NVL(delnote_rec_.del_note_print_date, site_date_);
   ELSIF (date_applied_rule_ = 'TRANSPORT_DATE') THEN
      date_applied_   := NVL(delnote_rec_.transport_date, site_date_);
   ELSE
      date_applied_   := site_date_;
   END IF; 
   FOR get_rec_ IN get_delivery_lines LOOP
      order_no_     := get_rec_.order_no;
      line_no_      := get_rec_.line_no;
      rel_no_       := get_rec_.rel_no;
      line_item_no_ := get_rec_.line_item_no;
      deliv_no_     := get_rec_.deliv_no;
      Inventory_Transaction_Hist_API.Modify_Date_Applied (dummy_info_ ,
                                                          contract_ ,
                                                          order_no_ ,
                                                          line_no_ ,
                                                          rel_no_,
                                                          line_item_no_,
                                                          deliv_no_ ,
                                                          Order_Type_API.DB_CUSTOMER_ORDER,
                                                          date_applied_);
   END LOOP;

END Modify_Date_Applied;
-- gelr:modify_date_applied End

-- gelr:warehouse_journal, begin
PROCEDURE Modify_Delivery_Info (
   contract_              IN VARCHAR2,
   source_referance_id_   IN VARCHAR2,
   source_referance_type_ IN VARCHAR2,
   delnote_no_            IN VARCHAR2 )
IS
   order_no_       VARCHAR2(20);
   line_no_        VARCHAR2(4);
   rel_no_         VARCHAR2(4);
   line_item_no_   NUMBER;

   delnote_rec_    Delivery_Note_API.Public_Rec;
   deliv_no_       NUMBER;
   
   CURSOR get_delivery_lines IS
      SELECT cod.line_no,
             cod.rel_no,
             cod.line_item_no,
             cod.order_no,
             cod.deliv_no
      FROM   customer_order_delivery_tab cod, customer_order_line_tab col, sales_part_tab sp
      WHERE  sp.non_inv_part_type = 'GOODS'
      AND    sp.contract   = col.contract
      AND    sp.catalog_no = col.catalog_no
      AND    col.supply_code NOT IN ('PD','IPD')
      AND    col.order_no  = cod.order_no
      AND    col.line_no   = cod.line_no
      AND    col.rel_no    = cod.rel_no
      AND    col.line_item_no = cod.line_item_no
      AND    ((cod.order_no      = source_referance_id_ AND source_referance_type_ = 'CUSTOMER_ORDER')
              OR(TO_CHAR(cod.shipment_id)  = source_referance_id_ AND source_referance_type_ = 'CUSTOMER_ORDER'))
      AND    cod.delnote_no = delnote_no_;
      
BEGIN
   FOR get_rec_ IN get_delivery_lines LOOP
      order_no_  := get_rec_.order_no;
      line_no_  := get_rec_.line_no;
      rel_no_  := get_rec_.rel_no;
      line_item_no_ := get_rec_.line_item_no;
      
      delnote_rec_ := Delivery_Note_API.Get(delnote_no_);
      deliv_no_ := get_rec_.deliv_no;
      
      Inventory_Transaction_Hist_API.Modify_Delivery_Info(contract_,
                                                          order_no_,
                                                          line_no_,
                                                          rel_no_,
                                                          line_item_no_,
                                                          deliv_no_,
                                                          Order_Type_API.DB_CUSTOMER_ORDER,
                                                          delnote_rec_.alt_delnote_no,
                                                          delnote_rec_.delivery_reason_id,
                                                          delnote_rec_.create_date);
   END LOOP;
END Modify_Delivery_Info;
-- gelr:warehouse_journal, End

-- gelr:alt_delnote_no_chronologic, begin
FUNCTION Get_Qty_Ship_Deliv_Undo (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   delnote_no_   IN VARCHAR2 ) RETURN NUMBER
IS
   sum_                NUMBER;
   cancelled_delivery_ VARCHAR2(10);
   
   CURSOR get_sum_qty_shipped IS
      SELECT SUM(qty_shipped)
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    delnote_no = delnote_no_
      AND    cancelled_delivery = 'FALSE';
   
   CURSOR get_cancelled_delivery IS
      SELECT cancelled_delivery
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    delnote_no = delnote_no_;
   
   CURSOR get_sum_qty_shipped_undo IS
      SELECT SUM(qty_shipped)
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    delnote_no = delnote_no_
      AND    cancelled_delivery = 'TRUE';
BEGIN
      OPEN get_cancelled_delivery;
      FETCH get_cancelled_delivery INTO cancelled_delivery_;
      CLOSE get_cancelled_delivery;
   
      IF cancelled_delivery_ = 'FALSE' THEN
         OPEN get_sum_qty_shipped;
         FETCH get_sum_qty_shipped INTO sum_;
         IF (get_sum_qty_shipped%NOTFOUND) THEN
            sum_ := 0;
         END IF;
         CLOSE get_sum_qty_shipped;    
      ELSE
         OPEN get_sum_qty_shipped_undo;
         FETCH get_sum_qty_shipped_undo INTO sum_;
         IF (get_sum_qty_shipped_undo%NOTFOUND) THEN
            sum_ := 0;
         END IF;
         CLOSE get_sum_qty_shipped_undo;    
      END IF;   
   RETURN NVL(sum_, 0);
END Get_Qty_Ship_Deliv_Undo;
-- gelr:alt_delnote_no_chronologic, end

------------------------------------------------------------------------------------------
-- Get_Sender_Receiv_Tax_Info
--    This methods returns sender/receiver contract and country code for inter-site orders
------------------------------------------------------------------------------------------
@UncheckedAccess 
PROCEDURE Get_Sender_Receiv_Tax_Info(
   sender_contract_              OUT VARCHAR2,
   sender_country_code_          OUT VARCHAR2,
   receiver_contract_            OUT VARCHAR2,
   receiver_country_code_        OUT VARCHAR2,
   order_no_                     IN  VARCHAR2,
   line_no_                      IN  VARCHAR2,     
   rel_no_                       IN  VARCHAR2,
   line_item_no_                 IN  NUMBER,   
   deliv_no_                     IN  NUMBER )
IS   
   shipment_id_                  NUMBER;   
   customer_order_rec_           Customer_Order_API.Public_Rec;   
   
BEGIN   
   IF (Customer_Order_Line_API.Get_Demand_Code_Db(order_no_, line_no_, rel_no_, line_item_no_) IN (Order_Supply_Type_API.DB_INT_PURCH_TRANS, 
                                                                                                   Order_Supply_Type_API.DB_DISTRIBUTION_ORDER)) THEN
      IF (deliv_no_ IS NOT NULL) THEN
         shipment_id_ := Get_Shipment_id(deliv_no_);
      END IF;   
      IF (shipment_id_ IS NOT NULL ) THEN 
         Tax_Handling_Invent_Util_API.Find_Shipment_Src_and_Dest(sender_contract_,
                                                                 sender_country_code_,
                                                                 receiver_contract_,
                                                                 receiver_country_code_,
                                                                 shipment_id_);     
      ELSE         
         receiver_country_code_ := Customer_Order_Line_API.Get_Country_Code(order_no_,
                                                                            line_no_,
                                                                            rel_no_,
                                                                            line_item_no_);
         customer_order_rec_  := Customer_Order_API.Get(order_no_);
         receiver_contract_   := Cust_Ord_Customer_API.Get_Acquisition_Site(customer_order_rec_.customer_no);
         sender_contract_     := customer_order_rec_.contract;                     
         sender_country_code_ := customer_order_rec_.supply_country;
      END IF;
   END IF;   
END Get_Sender_Receiv_Tax_Info;    
