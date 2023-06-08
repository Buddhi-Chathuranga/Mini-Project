-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentOrderUtility
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220311  RasDlk  SCDEV-8051, Removed the method Any_Rental_Line_Exists and implemented it in Shipment_Source_Utility_API.
--  220308  RasDlk SCDEV-8051, Modified the method Do_Undo_Shipment_Delivery by calling the method Check_Undo_Ord_Line_Deliv to perform the required validations before undoing 
--  220308         customer order lines and also added a call to Undo_Line_Delivery to fix the package headers after the components are undone.
--  211230  RasDlk SC21R2-3145, Modified Do_Undo_Shipment_Delivery by adding delivery_exist_ and delnote_no_ as out parameters and also moving out some common logic related to Undo Shipment Delivery for all sources.
--  211209  NiDalk SC21R2-6425, Added  Validate_Ref_Id and Check_Diff_Ref_Id___ to validate reference id of shipment and connecting source order lines.
--  211026  WaSalk SC21R2-5109, Modified Post_Generate_Alt_Delnote_No() to update customer order history with alternative dilvery note numbers where many customer orders connected.
--  210929  DipeLk FI21R2-4460 Updating Customer order history for alternative delivery note number should be there only for shipment source refs  from customer order only.
--  210608  Hahalk Bug 158204(SCZ-15018), Modified Fetch_And_Validate_Ship_Line() by adding condition to raise an error message if there is an outside picklist.
--  210607  KETKLK PJ21R2-749, Replaced Project Delivery supply code 'PRD' with Project Deliverables supply code 'PJD' as Project Delivery functionality will be removed.
--  210520  RaNhlk MF21R2-529, Modified Post_Delete_Ship_Line() to add a call to remove connected irapt report items.
--  201102  RasDlk SCZ-12201, In Print_Invoice invoicing customer was used instead of shipment receiver to get the default media code.
--  201102         Removed the parameter receiver_id_ from Print_Invoice.
--  201014  RasDlk SCZ-11304, In Shipment_At_Release___, added condition to avoid shipment creation if all the component line of a package is supplied by IPD.
--  200923  RoJalk SC2020R1-1673, Modified Fetch_And_Validate_Ship_Line and used Sales_Part_API.Get_Catalog_Desc to fetch source_part_desc if CO line value is null.
--  200916  RoJalk SC2020R1-1673, Added the method Get_Language_Code.
--  200626  AsZelk Bug 154344(SCZ-10338), Added ship_via_code_changed_ defult parameter to Fetch_Freight_And_Deliv_Info.
--  200420  ErFelk Bug 153307(SCZ-9792), Modified All_Lines_Has_Doc_Address() to raise the error when customer_no_pay and bill_addr_no is null.  
--  200319  WaSalk GESPRING20-533, Added post_Generate_Alt_Del_Note_No() to support Alt_Delnote_No_Chronologic localization.
--  200304  BudKlk Bug 148995 (SCZ-5793), Modified the methods Print_Invoice to resize the variable size of your_reference_.    
--  200207  kusplk GESPRING20-1792, Modified After_Print_Shpmnt_Del_Note method to support warehouse_journal functionality
--  200123  DipeLk GESPRING20-1774, Added method After_Print_Shpmnt_Del_Note to support modify_date_applied functionality in shipment
--  191023  ErFelk Bug 149943(SCZ-6856), Added new method All_Lines_Has_Doc_Address() to check the existence of document address in connected customer orders. Added an error message NOBILLADDRESS.
--  190503  ApWilk Bug 147802(SCZ-4303), Modified Post_Connect_To_Shipment() to update shipment freight charges when new shipment lines are added automatically.
--  180822  RaVdlk SCUXXW4-9600, Added the Any_Rental_Line_Exists method to check if there is any rental line in the order
--  190424  UdGnlk Bug 147886(SCZ-4394), Modified Get_Order_Pkg_Info() to get qty_picked, qty_to_ship and connected_source_qty to the cursor get_package_part and source_info_rpt_tab_.
--  180608  DiKuLk Bug 142193, Modified Fetch_And_Validate_Ship_Line() to set qty_to_ship for non-inventory parts.
--  180426  DiKuLk Bug 140770, Modified Post_Connect_To_Shipment() to stop calculating shipment charges for already invoiced orders.
--  180220  ChJalk  STRSC-16861, Modified the method Fetch_And_Validate_Ship_Line to correct the calculation of new_qty_to_ship_. 
--  171025  KiSalk Bug 138502, Added new method Add_To_Shipment_Id_Tab___; used it in Shipment_At_Create_Pick___ and Shipment_At_Release___ not to add a shipment_id_ to shipment_id_tab_ if it is already included,
--  171025          so that methods run in loop for this shipment_id_tab_ do not call code in duplicate.
--  171019  RoJalk  STRSC-12396, Added the method Ipt_Within_Same_Company.
--  170621  KhVese  STRSC-9112, Added method Set_Delivery_Note_Invalid.
--  170515  RoJalk  STRSC-8427, Removed the method Validate_Pick_List_Status.
--  170417  ErFelk  Bug 133039, Added new function Get_Market_code().
--  170331  Jhalse  LIM-10838, Added check to prevent connecting customer order lines that are on a pick list or not picked to shipment inventory.
--  170308  MaIklk  LIM-10827, Moved the generic part to shipment from Get_Order_Delivery_Rpt_Info and fixed to return single record.
--  170220  MaIklk  LIM-10826, Removed Get_Not_Reserv_Line_Rpt_Info, Get_Location_Group and Get_Reserv_Line_Rpt_Info.
--  161222  MaIklk  LIM-8387, Added Receiver_Type as parameter when calling Add_Source_Line_To_Shipment().
--  161221  MaIklk  LIM-8389, Removed Get_Catch_Qty().
--  161221  MaIklk  LIM-8389, Removed Get_Reserved_Not_Pick_Listed, Get_Serial_No and Get_Lot_Batch_No
--  161118  NiDalk  LIM-9293, Modified Get_Not_Reserv_Line_Rpt_Info added catalog_type also to source_rpt_info_ record. 
--  161025  RoJalk  LIM-6948, Added the methods Release_Not_Reserved_Pkg_Line, Release_Not_Reserved_Pkg_Qty.
--  161010  RoJalk  LIM-6944, Added methods Handle_Ship_Line_Qty_Change, Handle_Line_Qty_To_Ship_Change.
--  161006  RuLiLk  Bug 126029, Modified method Get_Order_Pkg_Info() to get inventory part number.
--  160929  RasDlk  Bug 131492, Modified Get_Shipment_Purch_Orders() by changing the length of customer_po_list_ variable to 4000.
--  160816  DaZase  LIM-4761, Added source_lu_name/reserv_lu_name in Get_Reserv_Line_Rpt_Info and source_lu_name in Get_Not_Reserv_Line_Rpt_Info.
--  160812  MaRalk  LIM-6755, Modified the error messages EXCEED_COMP_RESERVED_QTY, NEED_FULL_DELIVERY 
--  160812          in order to support generic shipment functionality. Renamed EXCEED_COMP_RESERVED_QTY as EXCEEDCOMPRESQTY.
--  160802  MaIklk  LIM-8217, Implemented to fetch customs_value from CO when connecting line to shipment.
--  160729  RoJalk  LIM-7954, Moved the method Pre_Deliver_Shipment to Deliver_Customer_Order_API.
--  160725  RoJalk  LIM-6995, Renamed rowstate to objstate in Shipment_Pub.
--  160715  RoJalk  LIM-7954, Added method Pre_Deliver_Shipment.
--  160629  TiRalk  STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  160627  DaZase  LIM-4761, Added reserved_qty_left_to_attach to Get_Reserv_Line_Rpt_Info.
--  160617  DaZase  LIM-4761, Added qty_picked to Get_Reserv_Line_Rpt_Info.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160606  MaRalk  LIM-7402, Removed parameter forwarder_changed_ from Fetch_Freight_And_Deliv_Info.
--  160606  RoJalk  LIM-6813, Aded the method Validate_Reassign_Hu.
--  160603  MaRalk  LIM-7402, Removed parameters forward_agent_id_, zip_code_, city_ , state_, county_ and country_code_ from 
--  160603          Fetch_Freight_And_Deliv_Info. 
--  160601  MAHPLK  FINHR-2018, Removed Validate_Tax_Calc_Basis.
--  160519  RoJalk  LIM-7467, Added the parameter added_to_new_shipment_ to Post_Connect_To_Shipment.
--  160513  MeAblk  Bug 127640, Modified Do_Undo_Shipment_Delivery___() to correctly set the open_shipment_qty for incomplete package deliveries.
--  160510  MaRalk  LIM-6531, Removed parameters freight_map_id_, zone_id_, price_list_no_,  
--  160510          use_price_incl_tax_ from Fetch_Freight_And_Deliv_Info and moved freight related code to 
--  160510          Shipment_Freight_API- Fetch_Freight_Info___ method.
--  160427  RoJalk  LIM-6952, Renamed Shipment_Line_API.Get_Ordline_Qty_To_Ship to Shipment_Line_API.Get_Source_Line_Qty_To_Ship.
--  160401  RoJalk  LIM-6562, Modified Post_Connect_To_Shipment added freight related calculations.
--  160330  RoJalk  LIM-4651, Removed the method Transfer_Line_Reservations.
--  160329  RoJalk  LIM-4649, Modified Get_Max_Pkg_Comp_Reserved and included the check qty_shipped = 0.
--  160328  MaRalk  LIM-6591, Added sales_unit_meas to Fetch_And_Validate_Ship_Line-get_all_lines cursor. 
--  160328  RoJalk  LIM-6303, Modified Get_Not_Reserv_Line_Rpt_Info.
--  160324  RoJalk  LIM-6579, Added the method Get_Reserved_Not_Pick_Listed.
--  160323  MaIklk  LIM-4668, Added Get_Shipment_Purch_Orders(), Get_Not_Reserv_Line_Rpt_Info(), Get_Location_Group() and Get_Reserv_Line_Rpt_Info(). 
--  160311  MaIklk  LIM-6564, Added Send_Direct_Delivery() and Get_Order_Delivery_Rpt_Info().
--  160311  MaIklk  LIM-4667, Added Get_Order_Rpt_Info() and Get_Order_Pkg_Info().
--  160309  MaRalk  LIM-5871, Modified Get_No_Of_Packages_Reserved, Get_No_Of_Packages_Delivered 
--  160309          to reflect shipment_line_tab-sourece_ref4 data type change.
--  160309  RoJalk  LIM-4650, Added the methods Check_Update_Connected_Src_Qty, Update_Pkg_Qty_Assigned. 
--  160307  MaIklk  LIM-4664, Added Get_Customer_Po_No().
--  160307  RoJalk  LIM-4630, Added the method Transfer_Line_Reservations.
--  160307  RoJalk  LIM-4630, Added the method Post_Connect_To_Shipment.
--  160307  RoJalk  LIM-4653, Added method Validate_Pick_List_Status.
--  160304  RoJalk  LIM-4627, Added methods Fetch_And_Validate_Ship_Line, Post_Connect_Shipment_Line.
--  160301  RoJalk  LIM-6300, Removed the method Qty_Reserve_Available.
--  160229  RoJalk  LIM-4655, Added method Update_Package.
--  160226  RoJalk  LIM-4637, Renamed Get_Line_Qty_To_Reserve to Qty_Reserve_Available.
--  160226  RoJalk  LIM-4178, Added the method Start_Shipment_Flow.
--  160224  RoJalk  LIM-4656, Added the method Modify_Open_Shipment_Qty.
--  160219  MaIklk  LIM-4134, Added Reserve_Shipment_Allowed() and Reserve_Shipment().
--  160219  RoJalk  LIM-4653, Added the method Post_Delete_Ship_Line.
--  160218  RoJalk  LIM-4628, Removed the method Add_Order_Line.
--  160218  RoJalk  LIM-4631, Added the methods Get_Shipments_to_Reserve, Get_Shipment_To_Reserve moving logic from Shipment_Line_API. 
--  160218  RoJalk  LIM-4637, Added the method Get_Line_Qty_To_Reserve.
--  160217  MaIklk  LIM-4157, Added Check_Manual_Tax_Lia_Date___() and Print_Invoice().
--  160217  MaIklk  LIM-4132, Added Blocked_Orders_Exist_For_Pick().
--  160216  Rojalk  LIM-4628, Add the method Add_Order_Line to create a shipment line in manual connection.
--  160211  RoJalk  LIM-4704, Moved Get_No_Of_Packages_Picked from PickCustomerOrder.  
--  160205  RoJalk  LIM-4246, Replaced Shipment_Line_API.Get_Inventory_Qty with Shipment_Line_API.Get_Inventory_Qty_By_Source.
--  160202  MaRalk  LIM-6114, Replaced attribute ship_addr_no with receiver_addr_id 
--  160202          in Modify_Delivery_Note method.
--  160202  MaIklk  LIM-6123, Changed Shipment_Handling_Utility_API.Add_Order_Line_To_Shipment method call to Add_Source_Line_To_Shipment().
--  160128  RoJalk  LIM-5911, Added source_ref_type_db_  parameter to Get_Total_Open_Shipment_Qty.
--  160126  MaIklk  LIM-4162, Added Get_Collect_Charge() and Get_Collect_Charge_Currency().
--  160122  MaIklk  LIM-6002, Added Fetch_Freight_And_Deliv_Info().
--  160121  MaIklk  LIM-5940, Added Validate_Tax_Calc_Basis().
--  160119  MaIklk  LIM-4173, Added Discon_Partial_Del_Lines().
--  160119  MaIklk  LIM-5751, Added Get_Inv_Part_Pack_Qty_Diff().
--  160118  RoJalk  LIM-4639, Added Get_No_Of_Packages_Reserved, Get_No_Of_Packages_Delivered. 
--  160112  RoJalk  LIM-4633, Added the method Get_Number_Of_Lines_To_Pick. 
--  160111  RoJalk  LIM-5712, Rename shipment_qty to onnected_source_qty in SHIPMENT_LINE_TAB. 
--  160106  RoJalk  LIM-4648, Added the method Check_Partially_Deliv_Comp. 
--  160106  RoJalk  LIM-4095, Added source_ref_type_db_ to Shipment_Handling_Utility_API.Add_Order_Line_To_Shipment method call.
--  160106  MaIklk  LIM-5750, Moved Get_No_Of_Packages_To_Ship() from ShipmentHandlingUtility.
--  160104  RoJalk  LIM-4098, Added the method Get_Max_Pkg_Comp_Reserved. 
--  160104  RoJalk  LIM-4092, Added the method Remove_Picked_Line.
--  151230  RoJalk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Shipment_At_Release___
--   Select all 'Order Release' lines for a particular customer order
--   and connect them to an existing matching shipment or to a newly created shipment.
PROCEDURE Shipment_At_Release___ (
   shipment_id_tab_ IN OUT Shipment_API.Shipment_Id_Tab,
   order_no_        IN     VARCHAR2 )
IS
   shipment_id_            NUMBER;
   dummy_                  Shipment_API.Shipment_Id_Tab;
   skip_shipment_creation_ BOOLEAN;

   CURSOR get_new_ship_lines IS
      SELECT line_no, rel_no, line_item_no
        FROM customer_order_line_tab
       WHERE order_no            =  order_no_
         AND shipment_creation   = 'ORDER_RELEASE'
         AND line_item_no       <=  0
         AND supply_code        NOT IN ( 'ND', 'IPD' )
         AND shipment_connected != 'TRUE'
         AND rowstate           != 'Cancelled';
BEGIN
   -- Create or connect to shipment at order release
   FOR order_line_rec_ IN get_new_ship_lines LOOP
      IF (order_line_rec_.line_item_no = 0) THEN
         skip_shipment_creation_ := FALSE;
      ELSE
         -- If all the component line of the package is supplied by IPD, no need to create a shipment in demand site.
         skip_shipment_creation_ := Customer_Order_Line_API.All_Components_Supply_Ipd(order_no_, order_line_rec_.line_no, order_line_rec_.rel_no );
      END IF;
      IF (NOT skip_shipment_creation_) THEN
         Shipment_Handling_Utility_API.Add_Source_Line_To_Shipment(shipment_id_,
                                                                   order_no_, 
                                                                   order_line_rec_.line_no, 
                                                                   order_line_rec_.rel_no, 
                                                                   order_line_rec_.line_item_no, 
                                                                   Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                                                   Sender_Receiver_Type_API.DB_CUSTOMER,
                                                                   dummy_,
                                                                   'FALSE');
         Add_To_Shipment_Id_Tab___(shipment_id_tab_, shipment_id_); 
      END IF;      
   END LOOP;
END Shipment_At_Release___;   

-- Shipment_At_Create_Pick___
--   Select all 'Picklist Creation' lines for a particular customer order and connect them
--   to a matching shipment  or to a newly created shipment.
PROCEDURE Shipment_At_Create_Pick___ (
   shipment_id_tab_ IN OUT Shipment_API.Shipment_Id_Tab,
   order_no_        IN     VARCHAR2 )
IS
   shipment_id_      NUMBER;
   dummy_            Shipment_API.Shipment_Id_Tab;
   backorder_option_ VARCHAR2(40);
   add_to_shipment_  BOOLEAN;
   
   CURSOR get_new_ship_lines IS
      SELECT col.line_no, col.rel_no, col.line_item_no, col.revised_qty_due, col.qty_assigned, col.qty_shipped, col.qty_shipdiff
        FROM customer_order_line_tab col
       WHERE col.order_no            = order_no_
         AND col.shipment_creation   = 'PICK_LIST_CREATION'
         AND col.supply_code NOT IN ('PD','IPD','ND','SEO')
         AND col.rowstate           != 'Cancelled'
         AND EXISTS ( SELECT 1 
                        FROM customer_order_reservation_tab cor
                       WHERE cor.order_no     = col.order_no
                         AND cor.line_no      = col.line_no
                         AND cor.rel_no       = col.rel_no
                         AND cor.line_item_no = col.line_item_no
                         AND cor.shipment_id  = 0 
                         AND cor.pick_list_no = '*');
BEGIN
   backorder_option_ := Customer_Order_API.Get_Backorder_Option_Db(order_no_);

   -- Create or connect shipment at picklist creation
   FOR order_line_rec_ IN get_new_ship_lines LOOP
      add_to_shipment_ := TRUE;
      IF (backorder_option_ = 'INCOMPLETE LINES NOT ALLOWED') THEN
         -- Check customer order line is fully reserved
         IF (order_line_rec_.revised_qty_due <= order_line_rec_.qty_assigned + order_line_rec_.qty_shipped - order_line_rec_.qty_shipdiff) THEN
            add_to_shipment_ := TRUE;
         ELSE
            add_to_shipment_ := FALSE;
         END IF;
      END IF;
      IF (add_to_shipment_) THEN
         Shipment_Handling_Utility_API.Add_Source_Line_To_Shipment(shipment_id_,
                                                                  order_no_,
                                                                  order_line_rec_.line_no,
                                                                  order_line_rec_.rel_no,
                                                                  order_line_rec_.line_item_no,
                                                                  Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                                                  Sender_Receiver_Type_API.DB_CUSTOMER,
                                                                  dummy_,
                                                                  'FALSE');
         Add_To_Shipment_Id_Tab___(shipment_id_tab_, shipment_id_); 
      END IF;
   END LOOP;
END Shipment_At_Create_Pick___;


PROCEDURE Check_Manual_Tax_Lia_Date___ (
   invoice_id_  IN NUMBER,
   shipment_id_ IN NUMBER )
IS
   invoice_type_           CUSTOMER_ORDER_INV_HEAD.invoice_type%TYPE;
   company_                CUSTOMER_ORDER_INV_HEAD.company%TYPE;
   invoice_series_id_      CUSTOMER_ORDER_INV_HEAD.series_id%TYPE;
   has_man_tax_liab_lines_ VARCHAR2(5);
   info_                   VARCHAR2(2000);

   CURSOR get_item_rec IS
      SELECT item_id,man_tax_liability_date
      FROM   cust_invoice_pub_util_item
      WHERE  company    = company_
      AND    invoice_id = invoice_id_;
BEGIN
   company_      := Site_API.Get_Company(Shipment_API.Get_Contract(shipment_id_));
   invoice_type_ := Customer_Order_Inv_Head_API.Get_Invoice_Type(company_, invoice_id_);

   FOR item_rec_ IN get_item_rec LOOP
      IF (item_rec_.man_tax_liability_date IS NULL) THEN
         has_man_tax_liab_lines_ := Customer_Order_Inv_Item_API.Has_Manual_Tax_Liablty_Lines(company_,invoice_id_,item_rec_.item_id,invoice_type_);
         IF (has_man_tax_liab_lines_ = 'TRUE') THEN
            invoice_series_id_ := Customer_Order_Inv_Head_API.Get_Series_Id(company_,NULL, NULL, invoice_id_);
            info_              := Language_SYS.Translate_Constant(lu_name_, 'NOMANTAXLIADATE: This invoice has a tax code defined with Tax Liability Date type as Manual. But no tax liability date specified on invoice/tax lines for invoice :P1 :P2.', NULL, invoice_series_id_, invoice_id_);
            Transaction_SYS.Set_Status_Info(info_);
         END IF;
      END IF;
   END LOOP;
END Check_Manual_Tax_Lia_Date___;

-- Add_To_Shipment_Id_Tab___
--   Check if shipment_id_ is already included in shipment_id_tab_ and add if not.
PROCEDURE Add_To_Shipment_Id_Tab___ (
   shipment_id_tab_ IN OUT Shipment_API.Shipment_Id_Tab,
   shipment_id_        IN     NUMBER )
IS
   count_              NUMBER  := shipment_id_tab_.COUNT;
   is_new_shipment_id_ BOOLEAN := TRUE;
BEGIN
   -- Check if shipment_id_ is already included in shipment_id_tab_
   IF (shipment_id_tab_.COUNT > 0) THEN
      FOR i_ IN shipment_id_tab_.FIRST..shipment_id_tab_.LAST LOOP
         IF shipment_id_tab_(i_) = shipment_id_ THEN
            is_new_shipment_id_ := FALSE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   IF is_new_shipment_id_ THEN
      count_                    := count_ + 1;
      shipment_id_tab_(count_) := shipment_id_; 
   END IF;   
END Add_To_Shipment_Id_Tab___;

-- gelr: outgoing_fiscal_note, begin
-----------------------------------------------------------------------
-- Check_Diff_Ref_Id___
--   Checks if source customer order lines have a different ref_id than the given ref_id
-----------------------------------------------------------------------
FUNCTION Check_Diff_Ref_Id___ (
   shipment_id_        IN     NUMBER,
   ref_id_             IN     VARCHAR2 ) RETURN BOOLEAN 
IS
   diff_ref_id_               BOOLEAN := FALSE;
   business_transaction_id_   CUSTOMER_ORDER_TAB.business_transaction_id%TYPE;
   source_ref_type_           VARCHAR2(20) := Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER;
   
   CURSOR ship_line IS
      SELECT DISTINCT sl.source_ref1
      FROM   SHIPMENT_LINE_PUB sl
      WHERE  sl.shipment_id =  shipment_id_
      AND    sl.source_ref_type_db = source_ref_type_;
BEGIN
   FOR line_rec_ IN ship_line LOOP
      business_transaction_id_ := Customer_Order_API.Get_Business_Transaction_Id(line_rec_.source_ref1);
      
      IF NVL(business_transaction_id_, Database_SYS.string_null_) <> NVL(ref_id_, Database_SYS.string_null_) THEN  
         diff_ref_id_ := TRUE;
      END IF;
   END LOOP;

   RETURN diff_ref_id_;
END Check_Diff_Ref_Id___;
-- gelr: outgoing_fiscal_note, end
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Automatic_Shipments
--   Create or Connect shipments when releasing or creating the pick list for customer order.
PROCEDURE Create_Automatic_Shipments (
   shipment_id_tab_      OUT Shipment_API.Shipment_Id_Tab,
   order_no_             IN  VARCHAR2,
   on_picklist_creation_ IN  BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (on_picklist_creation_) THEN
      Shipment_At_Create_Pick___ (shipment_id_tab_, order_no_);
   ELSE
      Shipment_At_Release___ (shipment_id_tab_, order_no_);
   END IF;
END Create_Automatic_Shipments;

-- Remove_Picked_Line
--   This removes a picked line from the shipment.
PROCEDURE Remove_Picked_Line (
   shipment_id_  IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   attr_   VARCHAR2(32000);
   colrec_ Customer_Order_Line_API.Public_Rec;

   CURSOR get_delivery(order_id_ VARCHAR2, line_id_ VARCHAR2, rel_id_ VARCHAR2, line_item_id_ NUMBER,
                       contract_ VARCHAR2, part_no_ VARCHAR2, configuration_id_ VARCHAR2) IS
      SELECT location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, 
             activity_seq, handling_unit_id
        FROM customer_order_reservation_tab
       WHERE order_no         = order_id_
         AND line_no          = line_id_
         AND rel_no           = rel_id_
         AND line_item_no     = line_item_id_
         AND contract         = contract_
         AND part_no          = part_no_
         AND configuration_id = configuration_id_
         AND shipment_id      = shipment_id_
         AND qty_picked > 0
       GROUP BY order_no, line_no, rel_no, line_item_no, contract, part_no, configuration_id, location_no, lot_batch_no,
                serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id ;
BEGIN
   Client_SYS.Clear_Attr(attr_);

   colrec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   FOR rec_ IN get_delivery (order_no_, line_no_, rel_no_, line_item_no_, colrec_.contract,
                             colrec_.part_no, colrec_.configuration_id) LOOP
      IF (LENGTH(attr_) > 31000) THEN
         -- More lines to be processed, but work on the attr_ now with ROW_COMPLETE value 'N'
         Client_SYS.Add_To_Attr('ROW_COMPLETE',   'N', attr_);
         Client_SYS.Add_To_Attr('QTY_TO_DELIVER',  0,  attr_);
         Deliver_Customer_Order_API.Deliver_Line_Inv_Diff(order_no_     => order_no_, 
                                                          line_no_      => line_no_, 
                                                          rel_no_       => rel_no_,
                                                          line_item_no_ => line_item_no_, 
                                                          close_line_   => 0,
                                                          attr_         => attr_, 
                                                          shipment_id_  => shipment_id_, 
                                                          remove_ship_  =>'TRUE');
         Client_SYS.Clear_Attr(attr_);
      ELSIF attr_ IS NOT NULL THEN
         -- It is possible to add more to attr_. So, add qty_to_deliver for previous line of the iteration and proceed
         Client_SYS.Add_To_Attr('QTY_TO_DELIVER',  0,  attr_);
      END IF;
      Client_SYS.Add_To_Attr('LOCATION_NO',        rec_.location_no,       attr_);
      Client_SYS.Add_To_Attr('LOT_BATCH_NO',       rec_.lot_batch_no,      attr_);
      Client_SYS.Add_To_Attr('SERIAL_NO',          rec_.serial_no,         attr_);
      Client_SYS.Add_To_Attr('ENG_CHG_LEVEL',      rec_.eng_chg_level,     attr_);
      Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO',    rec_.waiv_dev_rej_no,   attr_);
      Client_SYS.Add_To_Attr('ACTIVITY_SEQ',       rec_.activity_seq,      attr_);
      Client_SYS.Add_To_Attr('HANDLING_UNIT_ID',   rec_.handling_unit_id,  attr_);
   END LOOP;
   -- Add qty_to_deliver for last line of the above iteration
   Client_SYS.Add_To_Attr('QTY_TO_DELIVER', 0, attr_);
   Deliver_Customer_Order_API.Deliver_Line_Inv_Diff(order_no_     => order_no_, 
                                                    line_no_      => line_no_,
                                                    rel_no_       => rel_no_,
                                                    line_item_no_ => line_item_no_,
                                                    close_line_   => 0, 
                                                    attr_         => attr_, 
                                                    shipment_id_  => shipment_id_,
                                                    remove_ship_  => 'TRUE');
END Remove_Picked_Line;

FUNCTION Get_Max_Pkg_Comp_Reserved (
   shipment_id_  IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2 ) RETURN NUMBER
IS
   max_pkg_comp_reserved_    NUMBER;
   
   CURSOR get_max_pkg_comp_reserved IS
      SELECT NVL(CEIL(MAX(DECODE(col.part_no, NULL, sl.qty_to_ship, sl.qty_assigned) * (col.inverted_conv_factor/col.conv_factor)/col.qty_per_assembly)), 0)
      FROM   shipment_line_pub sl, customer_order_line_tab col
      WHERE  sl.shipment_id        =  shipment_id_
      AND    sl.source_ref1        =  order_no_
      AND    sl.source_ref2        =  line_no_
      AND    sl.source_ref3        =  rel_no_
      AND    sl.source_ref_type_db =  Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    sl.qty_shipped   = 0
      AND    col.order_no     =  sl.source_ref1
      AND    col.line_no      =  sl.source_ref2
      AND    col.rel_no       =  sl.source_ref3
      AND    col.line_item_no >  0
      AND    col.line_item_no =  sl.source_ref4;
BEGIN
   OPEN   get_max_pkg_comp_reserved;
   FETCH  get_max_pkg_comp_reserved INTO max_pkg_comp_reserved_;
   CLOSE  get_max_pkg_comp_reserved;
   RETURN max_pkg_comp_reserved_;
END Get_Max_Pkg_Comp_Reserved;


-- Get_No_Of_Packages_To_Ship___
--   Return the Total No of Packages to be shipped for a given package part.
FUNCTION Get_No_Of_Packages_To_Ship (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   no_of_packages_     NUMBER := 0;
   no_of_pkg_reserved_ NUMBER := 0;
   no_of_pkg_picked_   NUMBER := 0;
BEGIN
   -- TO_DO_LIME: Move Get_No_Of_Packages_Reserved() to this utility.
   no_of_pkg_reserved_ := Get_No_Of_Packages_Reserved(order_no_, line_no_, rel_no_, shipment_id_);    
   no_of_pkg_picked_   := Get_No_Of_Packages_Picked(order_no_, line_no_, rel_no_, shipment_id_);
    
   IF (no_of_pkg_reserved_ > 0) THEN
      IF (no_of_pkg_picked_ = 0) THEN
         no_of_packages_ := no_of_pkg_reserved_;
      ELSE
         IF (no_of_pkg_reserved_ < no_of_pkg_picked_) THEN
            no_of_packages_ := no_of_pkg_reserved_;
         ELSE
            no_of_packages_ := no_of_pkg_picked_;
         END IF;
      END IF;
   ELSIF (no_of_pkg_picked_ > 0) THEN
      no_of_packages_ := no_of_pkg_picked_;
   ELSE
      no_of_packages_ := Shipment_Line_API.Get_Inventory_Qty_By_Source(shipment_id_, order_no_, line_no_,
                                                                       rel_no_, -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
   END IF;

   RETURN NVL(no_of_packages_, 0);
END Get_No_Of_Packages_To_Ship;

-- Check_Partially_Deliv_Comp
--   Checks if any of the components of the package is partially delivered.
@UncheckedAccess
FUNCTION Check_Partially_Deliv_Comp (
   shipment_id_  IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   partially_deliv_comp_exist_   VARCHAR2(5) := 'FALSE';
   dummy_                        NUMBER;

   CURSOR get_partially_deliv_comp IS
      SELECT 1
      FROM   SHIPMENT_LINE_PUB pkg, SHIPMENT_LINE_PUB comp, customer_order_line_tab col
      WHERE  pkg.shipment_id  = shipment_id_
      AND    pkg.source_ref1  = order_no_
      AND    pkg.source_ref2  = line_no_
      AND    pkg.source_ref3  = rel_no_
      AND    pkg.source_ref4  = -1
      AND    pkg.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    comp.shipment_id = pkg.shipment_id
      AND    comp.source_ref1 = pkg.source_ref1
      AND    comp.source_ref2 = pkg.source_ref2
      AND    comp.source_ref3 = pkg.source_ref3
      AND    comp.source_ref3 > 0
      AND    col.order_no     = comp.source_ref1
      AND    col.line_no      = comp.source_ref2
      AND    col.rel_no       = comp.source_ref3
      AND    col.line_item_no = comp.source_ref4
      AND    ((pkg.connected_source_qty * col.qty_per_assembly) != comp.connected_source_qty);
BEGIN
   OPEN  get_partially_deliv_comp;
   FETCH get_partially_deliv_comp INTO dummy_;
   IF (get_partially_deliv_comp%FOUND) THEN
      partially_deliv_comp_exist_ := 'TRUE';
   END IF;
   CLOSE get_partially_deliv_comp;

   RETURN partially_deliv_comp_exist_;
END Check_Partially_Deliv_Comp;

@UncheckedAccess
FUNCTION Get_No_Of_Packages_Reserved (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   no_of_packages_reserved_  NUMBER;
   
   -- Get the minimum reserved quantity relative to the package part on a component line.
   CURSOR get_min_packages_reserved IS
      SELECT NVL(MIN(TRUNC(DECODE(b.part_no, NULL, a.qty_to_ship, a.qty_assigned) * 
                     (b.inverted_conv_factor/b.conv_factor) / b.qty_per_assembly)),0)
      FROM   shipment_line_pub a, customer_order_line_tab b
      WHERE  a.source_ref1  =  order_no_
      AND    a.source_ref2  =  line_no_
      AND    a.source_ref3  =  rel_no_
      AND    a.shipment_id  =  shipment_id_
      AND    Utility_SYS.String_To_Number(a.source_ref4)  >  0
      AND    a.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    a.source_ref1  =  b.order_no
      AND    a.source_ref2  =  b.line_no
      AND    a.source_ref3  =  b.rel_no
      AND    a.source_ref4  =  b.line_item_no;

BEGIN
   OPEN  get_min_packages_reserved;
   FETCH get_min_packages_reserved INTO no_of_packages_reserved_;
   CLOSE get_min_packages_reserved;

   RETURN no_of_packages_reserved_;
END Get_No_Of_Packages_Reserved;

-- Get_No_Of_Packages_Picked
--   Return the Total No of Packages fully picked for a given package part.
@UncheckedAccess
FUNCTION Get_No_Of_Packages_Picked (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   no_of_packages_picked_   NUMBER;
 
   -- Get the minimum picked quantity relative to the package part on a component line.
   CURSOR get_min_packages_picked IS
      SELECT NVL(MIN(TRUNC(DECODE(part_no, NULL, sl.qty_to_ship, sl.qty_picked) * 
                     (col.inverted_conv_factor/col.conv_factor)/(col.qty_per_assembly))),0)
      FROM customer_order_line_tab col, shipment_line_pub sl
      WHERE sl.shipment_id = shipment_id_
      AND   sl.source_ref1 = order_no_
      AND   sl.source_ref2 = line_no_
      AND   sl.source_ref3 = rel_no_
      AND   sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND   sl.source_ref1 = col.order_no
      AND   sl.source_ref2 = col.line_no
      AND   sl.source_ref3 = col.rel_no
      AND   col.line_item_no > 0
      AND   sl.source_ref4 = col.line_item_no
      AND   col.supply_code  NOT IN ('PD', 'IPD');
BEGIN
   OPEN  get_min_packages_picked;
   FETCH get_min_packages_picked INTO no_of_packages_picked_;
   CLOSE get_min_packages_picked;

   RETURN no_of_packages_picked_;
END Get_No_Of_Packages_Picked;

@UncheckedAccess
FUNCTION Get_No_Of_Packages_Delivered (
   order_no_    IN VARCHAR2,
   line_no_     IN VARCHAR2,
   rel_no_      IN VARCHAR2,
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   no_of_packages_deliv_  NUMBER;
   
   -- Get the minimum delivered quantity relative to the package part on a component line.
   CURSOR get_min_packages_reserved IS
      SELECT NVL(MIN(TRUNC(DECODE(b.part_no, NULL, a.qty_to_ship, a.qty_shipped) * 
                     (b.inverted_conv_factor/b.conv_factor) / b.qty_per_assembly)),0)
      FROM   shipment_line_pub a, customer_order_line_tab b
      WHERE  a.source_ref1  =  order_no_
      AND    a.source_ref2  =  line_no_
      AND    a.source_ref3  =  rel_no_
      AND    a.shipment_id  =  shipment_id_
      AND    Utility_SYS.String_To_Number(a.source_ref4) >  0
      AND    a.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    a.source_ref1  =  b.order_no
      AND    a.source_ref2  =  b.line_no
      AND    a.source_ref3  =  b.rel_no
      AND    a.source_ref4  =  b.line_item_no;

BEGIN
   OPEN  get_min_packages_reserved;
   FETCH get_min_packages_reserved INTO no_of_packages_deliv_;
   CLOSE get_min_packages_reserved;

   RETURN no_of_packages_deliv_;
END Get_No_Of_Packages_Delivered;


PROCEDURE Get_Pkg_Part_Qy_Picked (  
   line_picked_qty_     OUT NUMBER,
   shipment_id_         IN NUMBER,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   qty_assigned_        IN NUMBER,
   qty_shipped_         IN NUMBER,
   qty_picked_          IN NUMBER)
IS   
   all_comp_non_inv_    BOOLEAN := FALSE;
BEGIN    
   IF (line_item_no_ = -1) THEN
      line_picked_qty_ := qty_shipped_;
      IF (line_picked_qty_ = 0) THEN
         line_picked_qty_ := qty_picked_;
      END IF;   
      IF (line_picked_qty_ = 0) THEN
         all_comp_non_inv_ := Customer_Order_line_API.Check_All_Comp_Non_Inv(order_no_, line_no_, rel_no_);
         IF (all_comp_non_inv_) THEN
            line_picked_qty_ := qty_assigned_; 
         END IF;
      END IF;   
   END IF; 
END Get_Pkg_Part_Qy_Picked;

-- Discon_Partial_Del_Lines
--   This method is used to set the Shipment_connected attribute on Customer
--   Order Line to 'FALSE' for partially delivered lines when the Shipment is
--   in 'Closed' state.
PROCEDURE Discon_Partial_Del_Lines (
   shipment_id_   IN NUMBER)
IS
   open_shipment_qty_ NUMBER;
   CURSOR  get_partial_deliveries IS
     SELECT  sl.source_ref1, sl.source_ref2, sl.source_ref3, sl.source_ref4
     FROM    SHIPMENT_LINE_PUB sl, CUSTOMER_ORDER_LINE_TAB col
     WHERE   sl.shipment_id = shipment_id_
     AND     sl.source_ref1 = col.order_no
     AND     sl.source_ref2 = col.line_no
     AND     sl.source_ref3 = col.rel_no
     AND     sl.source_ref4 = col.line_item_no
     AND     sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
     AND     col.rowstate   = 'PartiallyDelivered';
BEGIN
   FOR lines_ IN get_partial_deliveries LOOP
      open_shipment_qty_ := Shipment_API.Get_Total_Open_Shipment_Qty(lines_.source_ref1, lines_.source_ref2, lines_.source_ref3,
                                                                     lines_.source_ref4, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
      IF (open_shipment_qty_ = 0) THEN             
         Customer_Order_Line_API.Modify_Shipment_Connection(lines_.source_ref1, lines_.source_ref2, lines_.source_ref3, lines_.source_ref4, 'FALSE', open_shipment_qty_);
      END IF;      
   END LOOP;
END Discon_Partial_Del_Lines;


PROCEDURE Fetch_Freight_And_Deliv_Info (
   route_id_                   IN OUT VARCHAR2,
   forward_agent_              IN OUT VARCHAR2,
   shipment_type_              IN OUT VARCHAR2,
   ship_inventory_location_no_ IN OUT VARCHAR2,   
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,   
   fetch_from_supply_chain_    IN     VARCHAR2,
   ship_via_code_changed_      IN     VARCHAR2 DEFAULT 'FALSE' )
IS
   delivery_leadtime_         NUMBER;
   freight_map_               shipment_freight_tab.freight_map_id%TYPE;
   zone_                      shipment_freight_tab.zone_id%TYPE;   
   ext_transport_calendar_id_ VARCHAR2(10);
   picking_leadtime_          NUMBER;   
BEGIN
   IF (addr_flag_db_ = 'N') AND (fetch_from_supply_chain_ = 'TRUE') THEN
      Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes(route_id_, forward_agent_, delivery_leadtime_,
                                                             ext_transport_calendar_id_,
                                                             freight_map_,
                                                             zone_,
                                                             picking_leadtime_,
                                                             shipment_type_,
                                                             ship_inventory_location_no_,
                                                             delivery_terms_,
                                                             del_terms_location_,
                                                             contract_,
                                                             customer_no_,
                                                             ship_addr_no_, 
                                                             addr_flag_db_,
                                                             ship_via_code_,
                                                             ship_via_code_changed_ => ship_via_code_changed_ );
   END IF;
END Fetch_Freight_And_Deliv_Info;

-- Get_Collect_Charge
--   Retuns the collect charge amount for the shipment.
@UncheckedAccess
FUNCTION Get_Collect_Charge (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   sum_charge_             NUMBER := 0;
   sum_base_charge_        NUMBER := 0;
   charge_                 NUMBER := 0;
   base_charge_            NUMBER := 0;
   collect_amount_         NUMBER := 0;
   rounding_               NUMBER;
   currency_code_          VARCHAR2(3);
   previous_currency_code_ VARCHAR2(3);
   company_                VARCHAR2(50);
   different_currency_     BOOLEAN := FALSE;

   CURSOR charge_lines(shipment_no_ NUMBER) IS
      SELECT DISTINCT source_ref1
      FROM SHIPMENT_LINE_PUB
      WHERE shipment_id = shipment_no_;
BEGIN
   company_ := Site_API.Get_Company(Shipment_API.Get_Contract(shipment_id_));

   FOR rec_ IN charge_lines(shipment_id_) LOOP
      currency_code_ := Customer_Order_API.Get_Currency_Code(rec_.source_ref1);

      IF (previous_currency_code_ IS NOT NULL) AND (previous_currency_code_ != currency_code_) THEN
         different_currency_ := TRUE;
      END IF;

      Customer_Order_API.Get_Shipment_Charge_Amount(charge_, base_charge_, rec_.source_ref1, shipment_id_);
      sum_charge_             := sum_charge_ + charge_;
      sum_base_charge_        := sum_base_charge_ + base_charge_;
      previous_currency_code_ := currency_code_;
   END LOOP;

   IF different_currency_ THEN
      currency_code_  := Company_Finance_API.Get_Currency_Code(company_);
      rounding_       := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
      collect_amount_ := ROUND(sum_base_charge_, rounding_);
   ELSE
      rounding_       := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
      collect_amount_ := ROUND(sum_charge_, rounding_);
   END IF;

   RETURN collect_amount_;
END Get_Collect_Charge;


-- Get_Collect_Charge_Currency
--   Returns the collect charge currency for the shipment.
@UncheckedAccess
FUNCTION Get_Collect_Charge_Currency (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   currency_code_      VARCHAR2(3);
   init_currency_code_ VARCHAR2(3);
   source_ref1_        VARCHAR2(12);
   company_            VARCHAR2(20);  

   CURSOR charge_lines(shipment_no_ NUMBER) IS
      SELECT DISTINCT source_ref1
      FROM SHIPMENT_LINE_PUB
      WHERE shipment_id = shipment_no_;
BEGIN
   company_ := Site_API.Get_Company(Shipment_API.Get_Contract(shipment_id_));

   OPEN charge_lines(shipment_id_);
   FETCH charge_lines INTO source_ref1_;
   init_currency_code_ := Customer_Order_API.Get_Currency_Code(source_ref1_);
   currency_code_      := init_currency_code_;
   LOOP
      EXIT WHEN (charge_lines%NOTFOUND OR currency_code_!= init_currency_code_);
      FETCH charge_lines INTO source_ref1_;
      currency_code_ := Customer_Order_API.Get_Currency_Code(source_ref1_);
   END LOOP;
   IF(charge_lines%NOTFOUND) THEN
      -- All currencies are equal on connected orders to the shipment
      CLOSE charge_lines;
      RETURN init_currency_code_;
   END IF;
   -- All currencies are not equal on connected orders to the shipment
   CLOSE charge_lines;

   currency_code_ := Company_Finance_API.Get_Currency_Code(company_);

   RETURN currency_code_;
END Get_Collect_Charge_Currency;


PROCEDURE Do_Undo_Shipment_Delivery (
   undo_complete_ OUT BOOLEAN,
   delnote_no_    OUT NUMBER,
   shipment_id_   IN  NUMBER )
IS
   pkg_ord_line_rec_   Customer_Order_Line_API.Public_Rec;
   pkg_ship_revised_qty_due_ NUMBER;
   
   CURSOR get_shipment_deliv_info(shipment_id_ IN NUMBER) IS
      SELECT order_no, line_no, rel_no, line_item_no, deliv_no
        FROM CUSTOMER_ORDER_DELIVERY_TAB
       WHERE shipment_id = shipment_id_
         AND cancelled_delivery = 'FALSE'
    ORDER BY order_no, line_no, rel_no, line_item_no DESC;
    
   CURSOR get_incomp_pkg_headers(shipment_id_ NUMBER) IS
         SELECT distinct order_no, line_no, rel_no, deliv_no
         FROM   CUSTOMER_ORDER_DELIVERY_TAB a
         WHERE  a.shipment_id = shipment_id_
         AND   EXISTS (SELECT 1
                       FROM CUSTOMER_ORDER_DELIVERY_TAB b
                       WHERE b.order_no = a.order_no
                       AND   b.line_no = a.line_no
                       AND   b.rel_no  = a.rel_no
                       AND   b.line_item_no > 0
                       AND   b.cancelled_delivery = 'TRUE')                     
         AND   NOT EXISTS ( SELECT 1
                            FROM CUSTOMER_ORDER_DELIVERY_TAB c
                            WHERE c.order_no = a.order_no
                            AND   c.line_no = a.line_no
                            AND   c.rel_no  = a.rel_no
                            AND   c.line_item_no = -1);
BEGIN
   undo_complete_ := FALSE;
   delnote_no_     := Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_);
   FOR deliv_rec_ IN get_shipment_deliv_info(shipment_id_) LOOP
      IF (Undo_Cust_Ord_Delivery_API.Check_Undo_Ord_Line_Deliv(deliv_rec_.order_no, deliv_rec_.line_no, deliv_rec_.rel_no, deliv_rec_.line_item_no, deliv_rec_.deliv_no, FALSE, shipment_id_)) THEN
         Customer_Order_API.Undo_Line_Delivery(deliv_rec_.order_no, deliv_rec_.line_no, 
                                               deliv_rec_.rel_no, deliv_rec_.line_item_no, 
                                               deliv_rec_.deliv_no);
         undo_complete_ := TRUE;
      END IF;
   END LOOP;   
   FOR pkg_rec_ IN get_incomp_pkg_headers(shipment_id_) LOOP
      Customer_Order_API.Undo_Line_Delivery(pkg_rec_.order_no, pkg_rec_.line_no,  pkg_rec_.rel_no, -1, pkg_rec_.deliv_no);
      pkg_ord_line_rec_  := Customer_Order_Line_API.Get(pkg_rec_.order_no, pkg_rec_.line_no, pkg_rec_.rel_no, -1);
      pkg_ship_revised_qty_due_ := Shipment_Line_API.Get_Inventory_Qty_By_Source(shipment_id_, pkg_rec_.order_no, pkg_rec_.line_no, pkg_rec_.rel_no, -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
      Customer_Order_Line_API.Modify_Shipment_Connection(pkg_rec_.order_no, pkg_rec_.line_no, pkg_rec_.rel_no, -1, 
                                                         'TRUE', (pkg_ord_line_rec_.open_shipment_qty + pkg_ship_revised_qty_due_));      
   END LOOP;
END Do_Undo_Shipment_Delivery;


FUNCTION Blocked_Orders_Exist_For_Pick (
   shipment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_orders_for_picklist IS
      SELECT DISTINCT order_no
      FROM customer_order_reservation_tab
      WHERE pick_list_no = '*'
      AND   shipment_id  = shipment_id_;
BEGIN
   FOR rec_ IN get_orders_for_picklist LOOP
      IF (Customer_Order_API.Get_Objstate(rec_.order_no) = 'Blocked') THEN
         RETURN Fnd_Boolean_API.DB_TRUE;
      END IF;
   END LOOP;
   RETURN Fnd_Boolean_API.DB_FALSE;
END Blocked_Orders_Exist_For_Pick;


PROCEDURE Print_Invoice (
   shipment_id_         IN NUMBER,
   invoice_id_          IN NUMBER,
   company_             IN VARCHAR2)
IS
   attr_                 VARCHAR2(2000);
   identity_             VARCHAR2(20);
   your_reference_       VARCHAR2(100);
   inv_addr_id_          VARCHAR2(50);
   media_code_           VARCHAR2(30) := NULL;
   cust_email_addr_      VARCHAR2(200);   
   email_invoice_        VARCHAR2(5) := NULL;
   
   CURSOR get_inv_details(invoice_id_ IN VARCHAR2, company_ IN VARCHAR2) IS
      SELECT identity, your_reference, invoice_address_id
      FROM   customer_order_inv_head
      WHERE  invoice_id = invoice_id_
      AND    company    = company_;  
BEGIN
   
            
   Check_Manual_Tax_Lia_Date___(invoice_id_, shipment_id_);

   OPEN get_inv_details(invoice_id_, company_);
   FETCH get_inv_details INTO identity_, your_reference_, inv_addr_id_; 
   CLOSE get_inv_details;

   media_code_ := Cust_Ord_Customer_API.Get_Default_Media_Code(identity_, 'INVOIC', company_);
   
   cust_email_addr_ := Cust_Ord_Customer_Address_API.Get_Email(identity_, your_reference_, inv_addr_id_); 
   email_invoice_   := Cust_Ord_Customer_API.Get_Email_Invoice_Db(identity_);
   -- Print the invoice
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('INVOICE_ID', invoice_id_, attr_);
   -- Add media code if not null. The invoice is then sent instead of printed.
   IF (media_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, attr_);
      -- The connected objects value should be TRUE for media code E-Invoice
      -- in the automatic customer order flow. Otherwise FALSE.
      IF (media_code_ = 'E-INVOICE') THEN
         Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', 'TRUE', attr_);
      ELSE
         Client_SYS.Add_To_Attr('CONNECTED_OBJECTS', 'FALSE', attr_);
      END IF;
   END IF;
   IF (cust_email_addr_ IS NOT NULL AND email_invoice_ = 'TRUE') THEN
      Client_SYS.Add_To_Attr('EMAIL_ADDR', cust_email_addr_, attr_);
   END IF;

   Customer_Order_Inv_Head_API.Print_Invoices(attr_);
END Print_Invoice;

FUNCTION Get_Shipments_to_Reserve (
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER ) RETURN Shipment_Line_API.Shipment_Quantity_Tab
IS
   shipment_quantity_tab_ Shipment_Line_API.Shipment_Quantity_Tab;

   CURSOR get_shipment_info IS
      SELECT sl.shipment_id, 
             LEAST((sl.inventory_qty - sl.qty_assigned),
                   (col.revised_qty_due - col.qty_assigned - col.qty_shipped + col.qty_shipdiff - col.qty_on_order)) shipment_qty_to_assign
      FROM   SHIPMENT_LINE_PUB sl, CUSTOMER_ORDER_LINE_TAB col, SHIPMENT_PUB s 
      WHERE  sl.source_ref1   = order_no_
      AND    sl.source_ref2   = line_no_
      AND    sl.source_ref3   = rel_no_
      AND    sl.source_ref4   = line_item_no_
      AND    sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    sl.qty_shipped   = 0
      AND    s.shipment_id    = sl.shipment_id 
      AND    s.objstate       = 'Preliminary'
      AND    col.order_no     = sl.source_ref1
      AND    col.line_no      = sl.source_ref2
      AND    col.rel_no       = sl.source_ref3
      AND    col.line_item_no = sl.source_ref4
      AND    ((sl.inventory_qty - sl.qty_assigned) > 0)
      AND    (col.supply_code IN ('IO', 'PS', 'PI', 'PJD', 'IPT', 'PT', 'SO'))
      AND    (col.revised_qty_due - col.qty_assigned - col.qty_shipped + col.qty_shipdiff - col.qty_on_order > 0)
      ORDER BY sl.shipment_id; 
BEGIN
   OPEN  get_shipment_info;
   FETCH get_shipment_info BULK COLLECT INTO shipment_quantity_tab_;
   CLOSE get_shipment_info;
   RETURN (shipment_quantity_tab_);
END Get_Shipments_to_Reserve;


-- Get_Shipment_To_Reserve
--   This method return shipment id and qty for a given order reference in which reservation is possible.
--   Consider Inventory parts.
--   Gets the Number of Reservations/pick list lines not picked for the entire shipment
--   Gets the Number of Reservations/pick list lines not picked per connected order line
PROCEDURE Get_Shipment_To_Reserve (
   shipment_qty_to_assign_ OUT NUMBER,
   shipment_id_            OUT NUMBER,
   order_no_               IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   consume_pegging_        IN  VARCHAR2 DEFAULT 'FALSE' )
IS
   temp_shipment_id_              NUMBER;
   temp_shipment_qty_to_assign_   NUMBER;
   shipment_quantity_tab_         Shipment_Line_API.Shipment_Quantity_Tab;

   CURSOR get_shipment_pegging_info IS
      SELECT sl.shipment_id, (sl.inventory_qty - sl.qty_assigned)  shipment_qty_to_assign
      FROM   SHIPMENT_LINE_PUB sl, CUSTOMER_ORDER_LINE_TAB col, SHIPMENT_PUB s 
      WHERE  sl.source_ref1   = order_no_
      AND    sl.source_ref2   = line_no_
      AND    sl.source_ref3   = rel_no_
      AND    sl.source_ref4   = line_item_no_
      AND    sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    sl.qty_shipped   = 0
      AND    s.shipment_id    = sl.shipment_id 
      AND    s.objstate       = 'Preliminary'
      AND    col.order_no     = sl.source_ref1
      AND    col.line_no      = sl.source_ref2
      AND    col.rel_no       = sl.source_ref3
      AND    col.line_item_no = sl.source_ref4
      AND    ((sl.inventory_qty - sl.qty_assigned) > 0)
      AND    (col.revised_qty_due - col.qty_assigned - col.qty_shipped + col.qty_shipdiff > 0)
      ORDER BY sl.shipment_id; 
      
BEGIN
   IF (consume_pegging_ = 'TRUE') THEN
      OPEN  get_shipment_pegging_info;
      FETCH get_shipment_pegging_info INTO temp_shipment_id_, temp_shipment_qty_to_assign_;
      IF (get_shipment_pegging_info%NOTFOUND) THEN
         temp_shipment_id_ := 0;
      END IF;
      CLOSE get_shipment_pegging_info;
   ELSE
      shipment_quantity_tab_ := Shipment_Order_Utility_API.Get_Shipments_To_Reserve(order_no_, line_no_, rel_no_, line_item_no_);

      IF (shipment_quantity_tab_.COUNT = 0) THEN
         temp_shipment_id_ := 0;
      ELSE
         temp_shipment_id_            := shipment_quantity_tab_(shipment_quantity_tab_.FIRST).shipment_id;
         temp_shipment_qty_to_assign_ := shipment_quantity_tab_(shipment_quantity_tab_.FIRST).quantity;
      END IF;
   END IF;

   shipment_qty_to_assign_ := temp_shipment_qty_to_assign_;
   shipment_id_            := temp_shipment_id_;
END Get_Shipment_To_Reserve;  

PROCEDURE Post_Delete_Ship_Line (
   shipment_id_    IN NUMBER,
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER )
IS    
   message_text_   VARCHAR2(2000);
BEGIN
   message_text_ := Language_SYS.Translate_Constant(lu_name_, 'DISCONNECT_FROM_SHIP: This line is disconnected from Shipment :P1.', NULL, shipment_id_);                            
   Customer_Order_Line_Hist_API.New(order_no_, line_no_, rel_no_, line_item_no_, message_text_);
   Shipment_Freight_Charge_API.Post_Delete_Ship_Line(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_);  
   $IF Component_Deford_SYS.INSTALLED $THEN
      IF (Def_Contract_Order_Item_API.CO_Line_On_Defense_Contract(order_no_, line_no_, rel_no_, line_item_no_)) THEN
         Defense_Report_Util_API.Remove_Item_Report(shipment_id_,order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   $END
END Post_Delete_Ship_Line;


FUNCTION Reserve_Shipment_Allowed (
   order_no_         IN  VARCHAR2,
   line_no_          IN  VARCHAR2,
   rel_no_           IN  VARCHAR2,
   line_item_no_     IN  NUMBER) RETURN NUMBER
IS
   allowed_ NUMBER;

   CURSOR reserve_allowed IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_TAB co
      WHERE  co.order_no      = col.order_no
      AND    col.order_no     = order_no_
      AND    col.line_no      = line_no_
      AND    col.rel_no       = rel_no_
      AND    col.line_item_no = line_item_no_
      AND    col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')      
      AND    ((col.revised_qty_due - col.qty_assigned - col.qty_to_ship - col.qty_on_order - col.qty_shipped + col.qty_shipdiff > 0) 
      AND    (supply_code IN ('IO', 'PS', 'PI', 'PJD', 'NO', 'PRJ', 'PT', 'IPT', 'SO')))               
      AND    co.rowstate!= 'Blocked';
      
   CURSOR reserve_pkg_allowed IS
      SELECT 1
        FROM customer_order_line_tab col, CUSTOMER_ORDER_TAB co
       WHERE co.order_no      = col.order_no
         AND col.order_no     = order_no_
         AND col.line_no      = line_no_
         AND col.rel_no       = rel_no_    
         AND col.line_item_no > 0
         AND col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
         AND (col.revised_qty_due - col.qty_assigned - col.qty_to_ship - col.qty_on_order - col.qty_shipped + col.qty_shipdiff) > 0
         AND (supply_code IN ('IO', 'PS', 'PI', 'PJD', 'NO', 'PRJ', 'PT', 'IPT', 'SO'))
         AND co.rowstate!= 'Blocked';
BEGIN
   IF (line_item_no_ = -1) THEN
      OPEN reserve_pkg_allowed;
      FETCH reserve_pkg_allowed INTO allowed_;
      IF (reserve_pkg_allowed %NOTFOUND) THEN
         allowed_ := 0;
      END IF;
      CLOSE reserve_pkg_allowed;
   ELSE
      OPEN reserve_allowed;
      FETCH reserve_allowed INTO allowed_;
      IF (reserve_allowed %NOTFOUND) THEN
         allowed_ := 0;
      END IF;
      CLOSE reserve_allowed;
   END IF;  
   RETURN allowed_;
END Reserve_Shipment_Allowed;


PROCEDURE Reserve_Shipment(
   reserve_ship_tab_    IN OUT   Reserve_Shipment_API.Reserve_Shipment_Table,
   shipment_id_         IN       VARCHAR2,
   source_ref_type_db_  IN       VARCHAR2)
IS
   order_blocked_          BOOLEAN := FALSE;

   CURSOR get_sources IS
      SELECT   sol.source_ref1
        FROM   shipment_line_pub sol, shipment_pub s
       WHERE   s.shipment_id    = shipment_id_
         AND   s.objstate       = 'Preliminary'
         AND   sol.shipment_id  = s.shipment_id
         AND   Utility_SYS.String_To_Number(sol.source_ref4) <= 0
         AND   sol.source_ref_type_db = source_ref_type_db_
      GROUP BY sol.source_ref1;
BEGIN
   IF (reserve_ship_tab_.COUNT > 0) THEN
      FOR rec_ IN get_sources LOOP
         Customer_Order_Flow_API.Credit_Check_Order(rec_.source_ref1, 'PICK_PROPOSAL');
         IF (Customer_Order_API.Get_Objstate(rec_.source_ref1) = 'Blocked') THEN
            order_blocked_ := TRUE;
         END if;
      END LOOP;

      IF (NOT order_blocked_) THEN
         Customer_Order_Flow_API.Start_Plan_Picking__(reserve_ship_tab_, shipment_id_);
      END IF;
   END IF;
END Reserve_Shipment;

PROCEDURE Modify_Open_Shipment_Qty (
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   new_open_shipment_qty_ IN NUMBER )
IS
   prev_open_shipment_qty_   NUMBER:=0; 
   open_shipment_qty_        NUMBER:=0;
   info_                     VARCHAR2(2000);
BEGIN
   info_ := Client_SYS.Get_All_Info;
   prev_open_shipment_qty_ := Customer_Order_Line_API.Get_Open_Shipment_Qty(order_no_, line_no_, rel_no_, line_item_no_);
   open_shipment_qty_      := prev_open_shipment_qty_ + new_open_shipment_qty_;
   IF (prev_open_shipment_qty_ > 0) THEN
      IF (open_shipment_qty_ = 0) THEN
         -- reduce shipment qty and set the shipment connected in CO line for FALSE
         Customer_Order_Line_API.Modify_Shipment_Connection(order_no_, line_no_, rel_no_, line_item_no_, 'FALSE', 0);
      ELSE
         IF (open_shipment_qty_ > 0) THEN
            -- update/reduce open shipment qty
            Customer_Order_Line_API.Modify_Open_Shipment_Qty(order_no_, line_no_, rel_no_, line_item_no_, open_shipment_qty_);
         END IF;
      END IF;
   ELSE
      -- adding a new shipment line and first shipment connection for the CO line
      IF (open_shipment_qty_ > 0) THEN
         Customer_Order_Line_API.Modify_Shipment_Connection(order_no_, line_no_, rel_no_, line_item_no_, 'TRUE', open_shipment_qty_);
      END IF;
   END IF;
   IF (info_ IS NOT NULL) THEN 
      IF (SUBSTR(info_, 1, 5) = 'INFO' || Client_SYS.field_separator_) THEN 
         Client_SYS.Add_Info(lu_name_, SUBSTR(info_, 6, LENGTH(info_) - 7)); 
      END IF; 
   END IF;   
END Modify_Open_Shipment_Qty;

PROCEDURE Start_Shipment_Flow (
   order_no_           IN VARCHAR2,
   event_no_           IN NUMBER, 
   rental_transfer_db_ IN VARCHAR2)
IS   
   CURSOR get_shipment IS
      SELECT DISTINCT sl.shipment_id
        FROM customer_order_line_tab col, shipment_line_pub sl, shipment_pub s
       WHERE col.order_no          = order_no_
         AND col.order_no          = sl.source_ref1
         AND col.line_no           = sl.source_ref2
         AND col.rel_no            = sl.source_ref3
         AND col.line_item_no      = sl.source_ref4
         AND sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND s.shipment_id         = sl.shipment_id
         AND s.objstate            = 'Preliminary'                         
         AND col.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')        
         AND shipment_connected    = 'TRUE';
BEGIN
   FOR rec_ IN get_shipment LOOP
      Shipment_Flow_API.Start_Shipment_Flow(rec_.shipment_id, event_no_, rental_transfer_db_);    
   END LOOP;
END Start_Shipment_Flow;

PROCEDURE Update_Package (
   shipment_id_       IN NUMBER,
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   pkg_inventory_qty_ IN NUMBER )
IS 
   CURSOR get_ship_components IS
      SELECT source_ref4, inventory_qty, qty_assigned
      FROM   shipment_line_pub
      WHERE  source_ref1  = order_no_
      AND    source_ref2  = line_no_
      AND    source_ref3  = rel_no_
      AND    shipment_id  = shipment_id_
      AND    source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    Utility_SYS.String_To_Number(source_ref4) > 0;
     
   revised_qty_due_           NUMBER;
   connected_source_qty_      NUMBER;
   pkg_order_revised_qty_due_ NUMBER;
   available_inv_qty_         NUMBER;
   order_line_comp_rec_       Customer_Order_Line_API.Public_Rec;
BEGIN
   pkg_order_revised_qty_due_ := Customer_Order_Line_API.Get_Revised_Qty_Due(order_no_, line_no_, rel_no_, -1); 
   FOR comprec_ IN get_ship_components LOOP 
      order_line_comp_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, comprec_.source_ref4);
      revised_qty_due_     := (pkg_inventory_qty_ * order_line_comp_rec_.revised_qty_due)/pkg_order_revised_qty_due_; 
      available_inv_qty_   := order_line_comp_rec_.revised_qty_due - order_line_comp_rec_.qty_shipped - (order_line_comp_rec_.open_shipment_qty - comprec_.inventory_qty ) + order_line_comp_rec_.qty_shipdiff;
      IF (revised_qty_due_ > available_inv_qty_ ) THEN 
         revised_qty_due_  := available_inv_qty_;
      END IF;
      connected_source_qty_ := revised_qty_due_ * order_line_comp_rec_.inverted_conv_factor/order_line_comp_rec_.conv_factor; 
      IF (revised_qty_due_ <  comprec_.qty_assigned) THEN
         Error_Sys.Record_General(lu_name_, 'EXCEEDCOMPRESQTY: Connected source quantity cannot be changed to a value that reduces the component quantity to less than the reserved component quantity :P1 for component part :P2.', comprec_.qty_assigned, order_line_comp_rec_.catalog_no);
      END IF; 
      Shipment_Line_API.Modify_Connected_Qty_By_Source(shipment_id_, order_no_, line_no_, rel_no_,
                                                       comprec_.source_ref4, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                                       connected_source_qty_, revised_qty_due_);
   END LOOP;     
END Update_Package;  


PROCEDURE Fetch_And_Validate_Ship_Line (
   new_line_tab_ OUT Shipment_Line_API.New_Line_Tab,
   shipment_id_  IN  NUMBER,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER )
IS
   revised_qty_due_       NUMBER; 
   sales_qty_             NUMBER;   
   new_qty_to_ship_       NUMBER:=0;
   sum_ord_qty_to_ship_   NUMBER:=0;
   index_                 PLS_INTEGER := 1;
   dummy_                 NUMBER;
   load_id_               NUMBER;
   
   CURSOR get_all_lines IS
      SELECT line_item_no, revised_qty_due, qty_assigned, qty_shipped, open_shipment_qty, qty_shipdiff, qty_to_ship, 
             sales_unit_meas, conv_factor, inverted_conv_factor, packing_instruction_id, catalog_no, catalog_desc,
             part_no, customs_value, contract, rowstate      
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND line_no  = line_no_
         AND rel_no   = rel_no_
         AND rowstate != 'Cancelled'
         ORDER BY line_item_no;    
       
   CURSOR connectable_pkg_comp_exist IS
      SELECT 1
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no >0
         AND supply_code != 'IPD'
         AND rowstate IN ( 'Released', 'Reserved', 'Picked', 'PartiallyDelivered');
   
BEGIN
   
   IF (line_item_no_ <0) THEN
      IF( Customer_Order_Line_API.All_Components_Supply_Ipd(order_no_, line_no_, rel_no_ )) THEN
         Error_SYS.Record_General(lu_name_,'IPDPKGCONNECT: Cannot connect to the shipment when all package components have been supplied through Internal Purchase Direct supply.');
      ELSE
         OPEN connectable_pkg_comp_exist;
         FETCH connectable_pkg_comp_exist INTO dummy_;
         CLOSE connectable_pkg_comp_exist;
         IF dummy_ IS NULL THEN
            Error_SYS.Record_General(lu_name_,'IPDPKGCONNECT2: Cannot connect to the shipment when remaining package component can only be supplied through the supply site.');
         END IF;
      END IF;
   END IF;
      
   load_id_ := Cust_Order_load_List_API.Get_Load_Id(order_no_, line_no_, rel_no_, line_item_no_);
   IF (load_id_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'LOADCONNECT: Customer order line :P1, :P2, :P3 already connected to a load list.', order_no_, line_no_, rel_no_);
   END IF;

   FOR rec_ IN get_all_lines LOOP
      IF (rec_.rowstate IN ('Reserved', 'Picked', 'PartiallyDelivered')) THEN
         IF (Customer_Order_Reservation_API.Pick_List_Exist_To_Report(order_no_, line_no_, rel_no_, rec_.line_item_no, 0) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'SHIPMENTNOTCONNECT: Customer order line :P1, :P2, :P3 already has a Pick List created outside Shipment.', order_no_, line_no_, rel_no_);
         END IF;
      END IF;
      
      
      revised_qty_due_  := rec_.revised_qty_due - rec_.qty_shipped - rec_.open_shipment_qty + rec_.qty_shipdiff;
      sales_qty_        := revised_qty_due_ * rec_.inverted_conv_factor/rec_.conv_factor;
      IF ((rec_.line_item_no >= 0) AND (rec_.qty_to_ship > 0)) THEN
         IF (rec_.part_no IS NULL) THEN
            new_qty_to_ship_  := rec_.qty_to_ship;
         ELSE 
            -- transfer the qty_to_ship from co line considering qty_to_ship in existing shipment lines 
            sum_ord_qty_to_ship_ := Shipment_Line_API.Get_Source_Line_Qty_To_Ship(order_no_, line_no_, rel_no_, 
                                                                                  rec_.line_item_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
            new_qty_to_ship_     := rec_.revised_qty_due - sum_ord_qty_to_ship_ - rec_.qty_shipped;
         END IF;
      END IF;
      Trace_SYS.Message('revised_qty_due_ :'||revised_qty_due_);
      -- skip the already delivered PKG components
      IF (revised_qty_due_ > 0) THEN
         new_line_tab_(index_).shipment_id            := shipment_id_;
         new_line_tab_(index_).source_ref1            := order_no_;
         new_line_tab_(index_).source_ref2            := line_no_;
         new_line_tab_(index_).source_ref3            := rel_no_;
         new_line_tab_(index_).source_ref4            := rec_.line_item_no;
         new_line_tab_(index_).source_ref_type        := Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER;
         new_line_tab_(index_).source_part_no         := rec_.catalog_no;
         new_line_tab_(index_).source_part_desc       := NVL(rec_.catalog_desc, Sales_Part_API.Get_Catalog_Desc(rec_.contract, rec_.catalog_no));
         new_line_tab_(index_).inventory_part_no      := rec_.part_no;
         new_line_tab_(index_).source_unit_meas       := rec_.sales_unit_meas;
         new_line_tab_(index_).conv_factor            := rec_.conv_factor;
         new_line_tab_(index_).inverted_conv_factor   := rec_.inverted_conv_factor; 
         new_line_tab_(index_).inventory_qty          := revised_qty_due_;
         new_line_tab_(index_).connected_source_qty   := sales_qty_;
         new_line_tab_(index_).qty_assigned           := 0;
         new_line_tab_(index_).qty_shipped            := 0;
         new_line_tab_(index_).qty_to_ship            := new_qty_to_ship_;
         new_line_tab_(index_).packing_instruction_id := rec_.packing_instruction_id;
         new_line_tab_(index_).customs_value          := rec_.customs_value;
         new_qty_to_ship_ := 0;
         index_           := index_ + 1;         
      END IF; 
   END LOOP;
END Fetch_And_Validate_Ship_Line;

PROCEDURE Post_Connect_Shipment_Line (
   shipment_id_           IN NUMBER,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   new_line_              IN VARCHAR2,
   sales_qty_             IN NUMBER )

IS    
   message_text_         VARCHAR2(2000);
   co_line_rec_          CUSTOMER_ORDER_LINE_API.Public_Rec;
BEGIN
   co_line_rec_ := Customer_Order_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
   Validate_Ref_Id(shipment_id_, co_line_rec_.ref_id, 'TRUE');
   IF (NVL(new_line_, 'FALSE') = 'TRUE') THEN
      message_text_ := Language_SYS.Translate_Constant(lu_name_, 'ADD_TO_SHIP: Sales Qty of :P1 was added to the connected Shipment :P2.', NULL, sales_qty_, shipment_id_);
   ELSE
      message_text_ := Language_SYS.Translate_Constant(lu_name_, 'CONNECT_TO_SHIP: This line is connected to Shipment :P1.', NULL, shipment_id_);
   END IF;
   Customer_Order_Line_Hist_API.New(source_ref1_, source_ref2_, source_ref3_, source_ref4_, message_text_);
   IF (new_line_ = Fnd_Boolean_API.DB_TRUE) THEN
      $IF Component_Deford_SYS.INSTALLED $THEN
         IF (Def_Contract_Order_Item_API.CO_Line_On_Defense_Contract(source_ref1_, source_ref2_, source_ref3_, source_ref4_)) THEN
            Defense_Report_Util_API.Create_Combo_Report(shipment_id_,source_ref1_, source_ref2_, source_ref3_, source_ref4_);
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   
   
END Post_Connect_Shipment_Line;

PROCEDURE Post_Connect_To_Shipment (
   shipment_id_           IN NUMBER,
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   connected_lines_exist_ IN VARCHAR2,
   last_comp_non_inv_     IN VARCHAR2,
   added_to_new_shipment_ IN VARCHAR2 )
IS    
   objstate_   VARCHAR2(20);
   invoiced_qty_   NUMBER;
   CURSOR get_invoiced_qty IS
      SELECT invoiced_qty
      FROM   customer_order_charge_tab coc, sales_charge_type_tab sct
      WHERE  coc.order_no     = order_no_
      AND    coc.line_no      = line_no_
      AND    coc.rel_no       = rel_no_
      AND    coc.line_item_no = line_item_no_
      AND    coc.charge_type = sct.charge_type
      AND    sct.sales_chg_type_category = 'FREIGHT';
BEGIN
   IF ((NVL(last_comp_non_inv_, 'FALSE') = 'TRUE') AND (line_item_no_ = -1)) THEN        
      Update_Pkg_Qty_Assigned(shipment_id_, order_no_, line_no_, rel_no_);
   END IF;
   
   IF (added_to_new_shipment_ = 'FALSE') THEN
      Shipment_Freight_API.Update_Freight_Info(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_);
   END IF;
   
   objstate_ := Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_);
   OPEN get_invoiced_qty;
   FETCH get_invoiced_qty INTO invoiced_qty_;
   CLOSE get_invoiced_qty;
   -- Calculate Shipment Freight charges only if customer order line is not connected to another shipment.
   IF ((connected_lines_exist_ = 'FALSE') AND (objstate_ IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')) AND NVL(invoiced_qty_, 0) = 0) THEN
      Shipment_Freight_Charge_API.Calculate_Shipment_Charges(shipment_id_, order_no_, line_no_, rel_no_, line_item_no_, 1);
   END IF;   
   
END Post_Connect_To_Shipment;

PROCEDURE Check_Update_Connected_Src_Qty (
   order_no_   IN VARCHAR2 )
IS    
BEGIN
   IF (Customer_Order_API.Get_Backorder_Option_Db(order_no_) IN ('NO PARTIAL DELIVERIES ALLOWED', 'INCOMPLETE LINES NOT ALLOWED')) THEN  
      Client_SYS.Add_Info(lu_name_, 'NEED_FULL_DELIVERY: Entire source line should be delivered at the same time when the source reference type is customer order with no backorders allowed.');
   END IF;    
END Check_Update_Connected_Src_Qty;

PROCEDURE Update_Pkg_Qty_Assigned (
   shipment_id_       IN NUMBER,
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2 )
IS    
   pkg_reserved_qty_   NUMBER;
BEGIN     
   pkg_reserved_qty_ := Get_No_Of_Packages_Reserved(order_no_, line_no_, rel_no_, shipment_id_);
   Shipment_Line_API.Modify_Qty_Assigned_By_Source(shipment_id_, order_no_, line_no_, rel_no_, -1,
                                                   Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, pkg_reserved_qty_);     
END Update_Pkg_Qty_Assigned;


@UncheckedAccess
FUNCTION Get_Customer_Po_No (
   shipment_id_   IN    NUMBER) RETURN VARCHAR2
IS
   po_no_str_              VARCHAR2(32000);
   -- Customer PO No cursor
   CURSOR get_customer_po_no IS
      SELECT DISTINCT co.customer_po_no
      FROM CUSTOMER_ORDER_TAB co, SHIPMENT_LINE_PUB sl
      WHERE co.order_no = sl.source_ref1
      AND   sl.shipment_id = shipment_id_
      AND sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER;
BEGIN
   FOR po_no_rec_ IN get_customer_po_no LOOP
     -- Adding distinct PO NOs
     IF (po_no_rec_.customer_po_no IS NOT NULL) THEN     
        IF (po_no_str_ IS NULL) THEN
           po_no_str_ := po_no_rec_.customer_po_no;
        ELSE
           po_no_str_ := po_no_str_ || ', ' || po_no_rec_.customer_po_no;
        END IF;
     END IF;   
   END LOOP; 
   RETURN po_no_str_;
END Get_Customer_Po_No;         


PROCEDURE Get_Order_Proforma_Rpt_Info (
   source_rpt_info_   OUT   Shipment_Source_Utility_API.Source_Info_Rpt_Rec,
   order_no_          IN    VARCHAR2,
   line_no_           IN    VARCHAR2,
   rel_no_            IN    VARCHAR2,
   line_item_no_      IN    VARCHAR2)
IS  
   CURSOR get_order_row IS
   SELECT col.order_no, 
         col.customer_part_no,
         NVL(col.customer_part_buy_qty, col.buy_qty_due) buy_qty_due,
         col.rowstate,
         NVL(col.customer_part_unit_meas, col.sales_unit_meas) sales_unit_meas,
         col.customer_part_conv_factor,
         col.cust_part_invert_conv_fact,
         col.note_id,     
         DECODE(col.sale_unit_price, col.part_price + col.char_price,'NOT MANUAL','MANUAL') manual_flag,         
         col.configuration_id,
         col.configured_line_price_id,
         col.ref_id,
         col.location_no,
         Sales_Part_Cross_Reference_API.Get_Catalog_Desc(col.customer_no, col.contract, col.customer_part_no) customer_part_desc,
         col.dock_code,
         col.sub_dock_code,
         col.manufacturing_department,
         col.delivery_sequence,
         Customer_Order_Line_API.Get_Internal_Or_Customer_Po_No(col.order_no, col.line_no, col.rel_no, col.line_item_no) customer_po_no,         
         tax_liability_type,                 
         col.rowkey   col_objkey        
      FROM   customer_order_line_tab col 
      WHERE  col.order_no = order_no_ 
      AND    col.line_no = line_no_
      AND    col.rel_no = rel_no_
      AND    col.line_item_no = line_item_no_        
      AND    col.rowstate != 'Cancelled'
      AND    col.supply_code NOT IN ('PD', 'IPD');       
BEGIN
   OPEN get_order_row;
   FETCH get_order_row INTO source_rpt_info_.source_ref1, source_rpt_info_.receiver_part_no, source_rpt_info_.buy_qty_due, source_rpt_info_.source_state, source_rpt_info_.source_unit_meas, source_rpt_info_.receiver_part_conv_factor,
   source_rpt_info_.receiv_part_invert_conv_fact, source_rpt_info_.note_id, source_rpt_info_.manual_flag, source_rpt_info_.configuration_id, source_rpt_info_.configured_line_price_id, source_rpt_info_.ref_id, source_rpt_info_.location_no,
   source_rpt_info_.receiver_part_desc, source_rpt_info_.dock_code, source_rpt_info_.sub_dock_code, source_rpt_info_.manufacturing_department, source_rpt_info_.delivery_sequence, source_rpt_info_.receiver_po_no,
   source_rpt_info_.tax_liability_type_db, source_rpt_info_.source_rowkey;
   IF (get_order_row%FOUND) THEN
      source_rpt_info_.source_lu_name := Customer_Order_Line_API.lu_name_;
      source_rpt_info_.reserv_lu_name := Customer_Order_Reservation_API.lu_name_;
   END IF;
   CLOSE get_order_row;
END Get_Order_Proforma_Rpt_Info;


PROCEDURE Get_Order_Pkg_Info (
   source_info_rpt_tab_  OUT   Shipment_Source_Utility_API.Source_Info_Rpt_Tab,
   order_no_             IN    VARCHAR2,
   line_no_              IN    VARCHAR2,
   rel_no_               IN    VARCHAR2,
   shipment_id_          IN    VARCHAR2)
IS  
   index_  PLS_INTEGER := 1;
   CURSOR get_package_part IS
      SELECT col.line_item_no,
             col.customer_part_no,             
             DECODE(col.customer_part_buy_qty, NULL, ((DECODE(col.part_no, NULL, DECODE(sol.qty_shipped, 0, sol.qty_to_ship, sol.qty_shipped), DECODE(sol.qty_shipped, 0, sol.qty_picked, sol.qty_shipped)))/col.conv_factor*col.inverted_conv_factor),
             (((DECODE(col.part_no, NULL, NVL(sol.qty_shipped, sol.qty_to_ship), NVL(sol.qty_shipped, sol.qty_picked)))/col.conv_factor*col.inverted_conv_factor)/col.customer_part_conv_factor * NVL(col.cust_part_invert_conv_fact, 1))) qty_delivered,
             (col.qty_picked / col.conv_factor*col.inverted_conv_factor)                                                                      qty_picked, 
             (col.qty_to_ship / col.conv_factor*col.inverted_conv_factor)                                                                     qty_to_deliver,
             sol.connected_source_qty                                                                                                       connected_source_qty,
             NVL(col.customer_part_unit_meas, col.sales_unit_meas) sales_unit_meas,
             col.sale_unit_price,            
             col.note_id,
             DECODE(col.sale_unit_price, col.part_price + col.char_price, 'NOT MANUAL', 'MANUAL') manual_flag,            
             col.configured_line_price_id,            
             col.conv_factor,
             col.inverted_conv_factor,
             col.customer_part_conv_factor,
             col.cust_part_invert_conv_fact,
             col.part_no,
             col.catalog_no,
             col.catalog_desc,
             col.rowkey col_objkey           
      FROM   customer_order_line_tab col, shipment_line_pub sol
      WHERE  col.order_no       = sol.source_ref1
      AND    col.line_no        = sol.source_ref2
      AND    col.rel_no         = sol.source_ref3
      AND    col.line_item_no   = sol.source_ref4
      AND    sol.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    col.order_no       = order_no_
      AND    col.line_no        = line_no_
      AND    col.rel_no         = rel_no_
      AND    sol.shipment_id    = shipment_id_
      AND    col.rowstate      != 'Cancelled'
      AND    col.line_item_no   > 0
      ORDER BY line_item_no; 
      language_code_            VARCHAR2(4);
      contract_                 VARCHAR2(5);
BEGIN
   language_code_ := Customer_Order_API.Get_Language_Code(order_no_);
   contract_      := Shipment_API.Get_Contract(shipment_id_);
   FOR next_part_ IN get_package_part LOOP    
      source_info_rpt_tab_(index_).source_ref1                  := order_no_; 
      source_info_rpt_tab_(index_).source_ref4                  := next_part_.line_item_no;
      source_info_rpt_tab_(index_).receiver_part_no             := next_part_.customer_part_no;
      source_info_rpt_tab_(index_).qty_delivered                := next_part_.qty_delivered;
      source_info_rpt_tab_(index_).qty_picked                   := next_part_.qty_picked;
      source_info_rpt_tab_(index_).qty_to_ship                  := next_part_.qty_to_deliver;
      source_info_rpt_tab_(index_).connected_source_qty         := next_part_.connected_source_qty;
      source_info_rpt_tab_(index_).source_unit_meas             := next_part_.sales_unit_meas;
      source_info_rpt_tab_(index_).source_unit_price            := next_part_.sale_unit_price;
      source_info_rpt_tab_(index_).note_id                      := next_part_.note_id;
      source_info_rpt_tab_(index_).manual_flag                  := next_part_.manual_flag;
      source_info_rpt_tab_(index_).configured_line_price_id     := next_part_.configured_line_price_id;      
      source_info_rpt_tab_(index_).conv_factor                  := next_part_.conv_factor;
      source_info_rpt_tab_(index_).inverted_conv_factor         := next_part_.inverted_conv_factor;
      source_info_rpt_tab_(index_).receiver_part_conv_factor    := next_part_.customer_part_conv_factor;
      source_info_rpt_tab_(index_).receiv_part_invert_conv_fact := next_part_.cust_part_invert_conv_fact;
      source_info_rpt_tab_(index_).inventory_part_no            := next_part_.part_no;
      source_info_rpt_tab_(index_).source_part_no               := next_part_.catalog_no;
      source_info_rpt_tab_(index_).source_part_description      := next_part_.catalog_desc;
      source_info_rpt_tab_(index_).sales_part_description       := NVL(Sales_Part_API.Get_Catalog_Desc_For_Lang(contract_, next_part_.catalog_no, language_code_),
                                                                   Sales_Part_API.Get_Catalog_Desc(contract_, next_part_.catalog_no));
      source_info_rpt_tab_(index_).source_rowkey                := next_part_.col_objkey;              
      index_ := index_ + 1; 
   END LOOP;
END Get_Order_Pkg_Info;


PROCEDURE Send_Direct_Delivery (
   shipment_id_   IN    VARCHAR2,
   delnote_no_    IN    VARCHAR2)   
IS
   multiple_messages_   VARCHAR2(5);
   customer_no_         VARCHAR2(20);
   media_code_          VARCHAR2(30);  
   
   CURSOR get_cos_to_send_delnote IS
      SELECT DISTINCT source_ref1
      FROM   shipment_line_pub sol
      WHERE  shipment_id = shipment_id_
      AND EXISTS (SELECT 1
                  FROM   customer_order_line_tab col
                  WHERE  col.order_no     = sol.source_ref1
                  AND    col.line_no      = sol.source_ref2
                  AND    col.rel_no       = sol.source_ref3
                  AND    col.line_item_no = sol.source_ref4
                  AND    col.demand_code  = 'IPD'
                  AND    col.qty_shipped > 0);
BEGIN
   multiple_messages_ := 'FALSE';
   FOR co_rec_ IN get_cos_to_send_delnote LOOP
      customer_no_ := Customer_Order_API.Get_Customer_no(co_rec_.source_ref1);
      media_code_  := Cust_Ord_Customer_API.Get_Default_Media_Code(customer_no_, 'DIRDEL');
      IF (media_code_ IS NOT NULL) THEN
         Customer_Order_Transfer_API.Send_Direct_Delivery(delnote_no_        => delnote_no_, 
                                                          order_no_          => co_rec_.source_ref1, 
                                                          media_code_        => media_code_, 
                                                          session_id_        => NULL, 
                                                          multiple_messages_ => multiple_messages_);
         multiple_messages_ := 'TRUE';
      END IF;
   END LOOP;
END Send_Direct_Delivery;


PROCEDURE Get_Order_Delivery_Rpt_Info (
   source_rpt_info_   OUT   Shipment_Source_Utility_API.Source_Info_Rpt_Rec,
   order_no_          IN    VARCHAR2,
   line_no_           IN    VARCHAR2,
   rel_no_            IN    VARCHAR2,
   line_item_no_      IN    VARCHAR2)
IS   
   CURSOR get_order_row IS
      SELECT col.order_no,
             col.customer_part_no,         
             NVL(col.customer_part_buy_qty, col.buy_qty_due) buy_qty_due,
             col.rowstate,
             DECODE(col.customer_part_buy_qty, NULL, GREATEST(col.buy_qty_due - ((col.qty_shipped - col.qty_shipdiff)/col.conv_factor*col.inverted_conv_factor), 0),
                    GREATEST(col.customer_part_buy_qty - (((col.qty_shipped - col.qty_shipdiff)/col.conv_factor*col.inverted_conv_factor)/col.customer_part_conv_factor * NVL(col.cust_part_invert_conv_fact, 1)),0)) qty_remaining,             
             NVL(col.customer_part_unit_meas, col.sales_unit_meas) sales_unit_meas,
             DECODE(col.customer_part_buy_qty, NULL, col.qty_shipped/col.conv_factor*col.inverted_conv_factor,
                (col.qty_shipped/col.conv_factor*col.inverted_conv_factor)/col.customer_part_conv_factor * NVL(col.cust_part_invert_conv_fact, 1)) total_qty_delivered,
             col.customer_part_conv_factor,
             col.cust_part_invert_conv_fact,            
             col.input_unit_meas, 
             col.input_qty, 
             col.input_variable_values,
             col.note_id,           
             DECODE(col.sale_unit_price, col.part_price + col.char_price,'NOT MANUAL','MANUAL') manual_flag,
             col.configuration_id,
             col.configured_line_price_id,
             col.ref_id,
             col.location_no,             
             Customer_Order_Line_API.Get_Internal_Or_Customer_Po_No(col.order_no, col.line_no, col.rel_no, col.line_item_no) customer_po_no,             
             col.dock_code,
             col.sub_dock_code,
             col.manufacturing_department,
             col.delivery_sequence,
             col.demand_code                      demand_code_db,
             col.demand_order_ref1,
             col.condition_code,
             col.tax_liability_type,
             col.planned_delivery_date,
             col.planned_due_date,
             col.planned_ship_date,             
             col.classification_part_no,
             col.classification_unit_meas                        
      FROM   customer_order_line_tab col
      WHERE  col.order_no     = order_no_
      AND    col.line_no      = line_no_
      AND    col.rel_no       = rel_no_
      AND    col.line_item_no = line_item_no_  
      AND    col.rowstate     != 'Cancelled'
      AND    col.supply_code NOT IN ('PD', 'IPD')
      AND    col.line_item_no  <= 0;         
BEGIN
   OPEN get_order_row;
   FETCH get_order_row INTO source_rpt_info_.source_ref1, source_rpt_info_.receiver_part_no, source_rpt_info_.buy_qty_due, source_rpt_info_.source_state, source_rpt_info_.qty_remaining, source_rpt_info_.source_unit_meas, source_rpt_info_.total_qty_delivered,
   source_rpt_info_.receiver_part_conv_factor, source_rpt_info_.receiv_part_invert_conv_fact, source_rpt_info_.input_unit_meas, source_rpt_info_.input_qty, source_rpt_info_.input_variable_values,  source_rpt_info_.note_id, source_rpt_info_.manual_flag, 
   source_rpt_info_.configuration_id, source_rpt_info_.configured_line_price_id, source_rpt_info_.ref_id, source_rpt_info_.location_no,
   source_rpt_info_.receiver_po_no, source_rpt_info_.dock_code, source_rpt_info_.sub_dock_code, source_rpt_info_.manufacturing_department, source_rpt_info_.delivery_sequence, source_rpt_info_.demand_code,
   source_rpt_info_.demand_source_ref1, source_rpt_info_.condition_code, source_rpt_info_.tax_liability_type_db, source_rpt_info_.planned_delivery_date, source_rpt_info_.planned_due_date, source_rpt_info_.planned_ship_date,
   source_rpt_info_.classification_part_no, source_rpt_info_.classification_unit_meas;  
   CLOSE get_order_row;   
END Get_Order_Delivery_Rpt_Info;
   

@UncheckedAccess
FUNCTION Get_Shipment_Purch_Orders(
   shipment_id_   IN    VARCHAR2) RETURN VARCHAR2 
IS
   customer_po_list_       VARCHAR2(4000);
   sep_                    VARCHAR2(1);
   temp_po_no_             VARCHAR2(50);
 -- select purchase orders connected to shipment
   CURSOR get_shipment_purch_orders IS
      SELECT co.customer_po_no
      FROM   SHIPMENT_LINE_PUB sol, CUSTOMER_ORDER_TAB co, CUSTOMER_ORDER_LINE_TAB col
      WHERE  sol.shipment_id  = shipment_id_
      AND    sol.source_ref1  = co.order_no
      AND    NVL(col.demand_code, Database_SYS.string_null_) NOT IN ('IPT','IPD')
      AND    col.order_no     = sol.source_ref1
      AND    col.line_no      = sol.source_ref2
      AND    col.rel_no       = sol.source_ref3
      AND    col.line_item_no = sol.source_ref4
      GROUP BY co.customer_po_no;

   CURSOR get_shipment_purch_orders_int IS
      SELECT co.customer_po_no, sh.receiver_id, co.customer_no, co.order_no
      FROM   SHIPMENT_LINE_PUB sol, CUSTOMER_ORDER_TAB co,  SHIPMENT_PUB sh
      WHERE  sol.shipment_id = shipment_id_
      AND    sol.source_ref1 = co.order_no
      AND    sh.shipment_id  = sol.shipment_id;
BEGIN
   
   sep_ := NULL;
   FOR gspo_ IN get_shipment_purch_orders LOOP
      customer_po_list_ := customer_po_list_ || sep_ || gspo_.customer_po_no;
      sep_              := ';';
   END LOOP;

   FOR gspoi_ IN get_shipment_purch_orders_int LOOP
      IF (customer_po_list_ IS NOT NULL) THEN
         customer_po_list_ := customer_po_list_ || sep_;
      END IF;
      
      IF (gspoi_.customer_no = gspoi_.receiver_id) THEN
         temp_po_no_ := Customer_Order_API.Get_Internal_Po_No(gspoi_.order_no);
         IF ((temp_po_no_ IS NOT NULL) AND (NVL(INSTR(customer_po_list_, temp_po_no_), 0) = 0)) THEN
            customer_po_list_ := customer_po_list_ || temp_po_no_; 
         END IF;
      ELSE
         IF ((gspoi_.customer_po_no IS NOT NULL) AND (NVL(INSTR(customer_po_list_, gspoi_.customer_po_no), 0) = 0)) THEN
            customer_po_list_ := customer_po_list_ || gspoi_.customer_po_no; 
         END IF;
      END IF;
      sep_ := ';';
      customer_po_list_ := RTRIM(customer_po_list_, sep_);
   END LOOP;
   RETURN customer_po_list_;
END Get_Shipment_Purch_Orders;


PROCEDURE Validate_Reassign_Hu (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   catalog_no_       IN VARCHAR2)
IS 
BEGIN      
   IF (line_item_no_ < 0) THEN
      Error_Sys.Record_General(lu_name_, 'PKGPARTEXIST: The handling unit :P1 has package part :P2 attached and cannot be reassigned. The package part has to be disconnected from the handling unit and handled manually.', handling_unit_id_, catalog_no_);
   END IF;
END Validate_Reassign_Hu;


PROCEDURE Handle_Ship_Line_Qty_Change (
   shipment_id_   IN NUMBER,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2,
   inventory_qty_ IN NUMBER )
IS
BEGIN
   IF (source_ref4_ = -1) THEN
      Update_Package(shipment_id_, source_ref1_, source_ref2_, source_ref3_, inventory_qty_); 
   END IF;
   
   Shipment_Freight_Charge_API.Calculate_Shipment_Charges(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, 1);
                                                                
END Handle_Ship_Line_Qty_Change;   


PROCEDURE Handle_Line_Qty_To_Ship_Change (
   shipment_id_   IN NUMBER,
   source_ref1_   IN VARCHAR2,
   source_ref2_   IN VARCHAR2,
   source_ref3_   IN VARCHAR2,
   source_ref4_   IN VARCHAR2 )
IS
BEGIN
   IF (source_ref4_ > 0) THEN      
      Update_Pkg_Qty_Assigned(shipment_id_,  source_ref1_, source_ref2_, source_ref3_);  
   END IF;                                                      
END Handle_Line_Qty_To_Ship_Change;   


PROCEDURE Release_Not_Reserved_Pkg_Line (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2 )
IS
   remaining_qty_to_reserve_   NUMBER;
   max_pkg_comp_reserved_      NUMBER;
      
   CURSOR get_not_reserved_packages IS
      SELECT shipment_id, inventory_qty 
        FROM shipment_line_pub
       WHERE NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND (Utility_SYS.String_To_Number(source_ref4) = -1)
         AND qty_shipped = 0
         AND (inventory_qty > qty_assigned);
BEGIN
   FOR not_reserved_pkg_rec_ IN get_not_reserved_packages LOOP
      -- fetch the maximum component qty reserved for a given component line
      max_pkg_comp_reserved_ := Get_Max_Pkg_Comp_Reserved(not_reserved_pkg_rec_.shipment_id, source_ref1_,
                                                          source_ref2_, source_ref3_);
      IF (not_reserved_pkg_rec_.inventory_qty > NVL(max_pkg_comp_reserved_, 0)) THEN
         remaining_qty_to_reserve_ := not_reserved_pkg_rec_.inventory_qty - NVL(max_pkg_comp_reserved_, 0);
         Shipment_Line_API.Release_Not_Reserved_Qty(not_reserved_pkg_rec_.shipment_id, source_ref1_, source_ref2_, source_ref3_, 
                                                    -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, remaining_qty_to_reserve_, 'RELEASE_NOT_RESERVED'); 
      END IF;
   END LOOP;
END Release_Not_Reserved_Pkg_Line;


PROCEDURE Release_Not_Reserved_Pkg_Qty (
   shipment_id_   IN NUMBER )
IS
   remaining_qty_to_reserve_ NUMBER;
   max_pkg_comp_reserved_    NUMBER;

   CURSOR get_not_reserved_packages IS
      SELECT source_ref1, source_ref2, source_ref3, inventory_qty 
        FROM shipment_line_pub
       WHERE shipment_id = shipment_id_
         AND source_ref_type_db =  Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND Utility_SYS.String_To_Number(source_ref4) = -1 
         AND (inventory_qty > qty_assigned);
BEGIN
   FOR not_reserved_pkg_rec_ IN get_not_reserved_packages LOOP
      -- fetch the maximum component qty reserved for a given component line
      max_pkg_comp_reserved_ := Get_Max_Pkg_Comp_Reserved(shipment_id_, not_reserved_pkg_rec_.source_ref1, 
                                                          not_reserved_pkg_rec_.source_ref2, not_reserved_pkg_rec_.source_ref3);
      IF (not_reserved_pkg_rec_.inventory_qty > NVL(max_pkg_comp_reserved_, 0)) THEN
         remaining_qty_to_reserve_ := not_reserved_pkg_rec_.inventory_qty - NVL(max_pkg_comp_reserved_, 0);
         Shipment_Line_API.Release_Not_Reserved_Qty(shipment_id_, not_reserved_pkg_rec_.source_ref1, not_reserved_pkg_rec_.source_ref2, 
                                                    not_reserved_pkg_rec_.source_ref3, -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, remaining_qty_to_reserve_, 'RELEASE_NOT_RESERVED'); 
      END IF;
      
   END LOOP;
END Release_Not_Reserved_Pkg_Qty;

@UncheckedAccess
FUNCTION Get_Market_code (
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   source_ref1_       VARCHAR2(50);
   market_code_       VARCHAR2(10);
   ordering_customer_ VARCHAR2(20);
   
   CURSOR get_source_ref1 IS
      SELECT source_ref1
        FROM shipment_line_pub
       WHERE shipment_id = shipment_id_
         AND source_ref_type_db =  source_ref_type_db_;      
BEGIN
   OPEN get_source_ref1;
   FETCH get_source_ref1 INTO source_ref1_;
   CLOSE get_source_ref1;
   
   ordering_customer_ := Customer_Order_API.Get_Customer_No(source_ref1_);
   market_code_       := Cust_Ord_Customer_API.Get_Market_Code(ordering_customer_);
   
   RETURN market_code_;
END Get_Market_code;
 

PROCEDURE Set_Delivery_Note_Invalid (
   source_ref1_       IN VARCHAR2,
   shipment_location_ IN VARCHAR2) 
IS
   CURSOR get_all_delnotes IS
         SELECT DISTINCT delnote_no
           FROM customer_order_reservation_tab
          WHERE order_no    = source_ref1_
            AND location_no = shipment_location_
            AND qty_picked  > 0;
BEGIN
   FOR rec_ IN get_all_delnotes LOOP
      IF (rec_.delnote_no IS NOT NULL )THEN
         Delivery_Note_API.Set_Invalid(rec_.delnote_no);
      END IF;
   END LOOP;
END Set_Delivery_Note_Invalid;


@UncheckedAccess
FUNCTION Ipt_Within_Same_Company (
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   ipt_within_same_company_   BOOLEAN := FALSE;
   acquisition_site_          VARCHAR2(5);
   
   CURSOR get_ipt_info IS
      SELECT col.contract, col.customer_no
        FROM customer_order_line_tab col, shipment_line_pub sol
       WHERE sol.shipment_id  = shipment_id_
         AND col.order_no     = sol.source_ref1
         AND col.line_no      = sol.source_ref2
         AND col.rel_no       = sol.source_ref3
         AND col.line_item_no = sol.source_ref4
         AND sol.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND NVL(col.demand_code, Database_SYS.string_null_) = 'IPT';
       
   TYPE Ipt_Info_Tab IS TABLE OF get_ipt_info%ROWTYPE INDEX BY BINARY_INTEGER;
   ipt_info_tab_   Ipt_Info_Tab;    
BEGIN
   OPEN  get_ipt_info;
   FETCH get_ipt_info BULK COLLECT INTO ipt_info_tab_;
   CLOSE get_ipt_info;
   
   IF (ipt_info_tab_.COUNT > 0) THEN
      FOR i IN ipt_info_tab_.FIRST..ipt_info_tab_.LAST LOOP
         acquisition_site_ := Cust_Ord_Customer_API.Get_Acquisition_Site(ipt_info_tab_(i).customer_no);
         IF (NVL(Site_API.Get_Company(ipt_info_tab_(i).contract), Database_SYS.string_null_) = NVL(Site_API.Get_Company(acquisition_site_), Database_SYS.string_null_)) THEN
            ipt_within_same_company_ := TRUE;
            EXIT;
         END IF;   
      END LOOP;
   END IF;
      
   RETURN ipt_within_same_company_;
END Ipt_Within_Same_Company;


PROCEDURE All_Lines_Has_Doc_Address(
   shipment_id_  IN NUMBER )
IS
   corec_ Customer_Order_API.Public_Rec;
   
   CURSOR get_all_co_lines IS
      SELECT DISTINCT source_ref1
      FROM shipment_line_pub 
      WHERE shipment_id = shipment_id_       
      AND source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER;
BEGIN   
   FOR rec_ IN get_all_co_lines LOOP
      corec_ := Customer_Order_API.Get(rec_.source_ref1);
      IF ((corec_.customer_no_pay IS NULL) AND (corec_.bill_addr_no IS NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'NOBILLADDRESS: There is no document address defined for customer order :P1', rec_.source_ref1);
      END IF;   
   END LOOP;       
END All_Lines_Has_Doc_Address;

@UncheckedAccess
FUNCTION Get_Language_Code (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   deliver_to_customer_no_ IN VARCHAR2,
   co_language_code_       IN VARCHAR2 ) RETURN VARCHAR2
IS   
   language_code_   VARCHAR2(2);
BEGIN
   IF (deliver_to_customer_no_ != Customer_Order_API.Get_Customer_No(order_no_)) THEN
      language_code_ := Customer_Order_Line_API.Get_Originating_Co_Lang_Code(order_no_, line_no_, rel_no_, line_item_no_);
   ELSE
      language_code_ := co_language_code_;
   END IF;
   
   RETURN language_code_;
END Get_Language_Code;

-- gelr:modify_date_applied Begin
PROCEDURE After_Print_Shpmnt_Del_Note (
   contract_              IN VARCHAR2,
   shipment_id_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   delnote_no_            IN VARCHAR2,
   old_del_note_state_    IN VARCHAR2,
   del_note_state_        IN VARCHAR2)
IS
BEGIN  
   IF (del_note_state_ = 'Printed') AND (old_del_note_state_ = 'Created') THEN
      IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'MODIFY_DATE_APPLIED') = Fnd_Boolean_API.DB_TRUE) THEN
         Customer_Order_Delivery_API.Modify_Date_Applied (contract_ ,
                                                          shipment_id_ ,
                                                          source_ref_type_db_ ,
                                                          delnote_no_ );
      END IF;
      -- gelr:warehouse_journal, begin
      IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(contract_, 'WAREHOUSE_JOURNAL') = Fnd_Boolean_API.DB_TRUE) THEN
         Customer_Order_Delivery_API.Modify_Delivery_Info (contract_ ,
                                                           shipment_id_ ,
                                                           source_ref_type_db_ ,
                                                           delnote_no_ );
      END IF;
      -- gelr:warehouse_journal, end
   END IF;                                                 

END After_Print_Shpmnt_Del_Note;
-- gelr:modify_date_applied End

-- gelr:alt_delnote_no_chronologic, begin
PROCEDURE Post_Generate_Alt_Delnote_No (
  delnote_no_      VARCHAR2,
  source_ref1_     VARCHAR2,
  shipment_id_     NUMBER,
  alt_delnote_no_  VARCHAR2) 
IS
   order_no_   VARCHAR2(50);
   
   CURSOR get_order_line IS
      SELECT line_no,rel_no,line_item_no
      FROM   CUSTOMER_ORDER_DELIVERY_TAB
      WHERE  order_no = source_ref1_
      AND    delnote_no = delnote_no_
      AND    cancelled_delivery = 'FALSE';

   CURSOR get_source_ref1 IS
      SELECT source_ref1
      FROM   shipment_line_pub
      WHERE  shipment_id        = shipment_id_
      AND    source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER;
   
   message_text_alt_delnote_ VARCHAR2(255);
BEGIN  
   -- Add a new entry to Customer Order History
   message_text_alt_delnote_ := Language_SYS.Translate_Constant(lu_name_, 'ALTDELNOTEASSIGNED: Alternative delivery note number :P1 assigned to delivery note :P2.', NULL, alt_delnote_no_, delnote_no_);
   IF (source_ref1_ IS NULL) THEN
      FOR source_rec_ IN get_source_ref1 LOOP
         order_no_ := source_rec_.source_ref1;
         Customer_Order_History_API.New(order_no_, message_text_alt_delnote_);
         FOR rec_ IN get_order_line LOOP
             -- Add a new entry to Customer Order Line History
            Customer_Order_Line_Hist_API.New(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, message_text_alt_delnote_);
         END LOOP;
      END LOOP;
   ELSE 
      order_no_ := source_ref1_;
      Customer_Order_History_API.New(order_no_, message_text_alt_delnote_);
      FOR rec_ IN get_order_line LOOP
         -- Add a new entry to Customer Order Line History
         Customer_Order_Line_Hist_API.New(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, message_text_alt_delnote_);
      END LOOP;
   END IF ;
   END Post_Generate_Alt_Delnote_No;
-- gelr:alt_delnote_no_chronologic, end

-- gelr: outgoing_fiscal_note, begin
-------------------------------------------------------------------------
-- Validate_Ref_Id
--    Validates shipment ref od with given ref id
-------------------------------------------------------------------------
PROCEDURE Validate_Ref_Id(
   shipment_id_        IN     NUMBER,
   new_ref_id_         IN     VARCHAR2,
   check_head_ref_     IN     VARCHAR2 DEFAULT 'FALSE')
IS
   ship_ref_id_         SHIPMENT_TAB.ref_id%TYPE := NULL;
   company_             SITE_TAB.company%TYPE;
   diff_ref_id_         BOOLEAN := FALSE;
   shipment_rec_        SHIPMENT_API.Public_Rec;
BEGIN
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   company_ := Site_API.Get_Company(shipment_rec_.contract);
 
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'BRAZILIAN_SPECIFIC_ATTRIBUTES') = Fnd_Boolean_API.DB_TRUE) 
      AND Shipment_Consol_Rule_API.Exists_Db(shipment_rec_.shipment_type, 'REFERENCE ID') THEN
      IF check_head_ref_ = 'TRUE' THEN 
         ship_ref_id_:= shipment_rec_.ref_id;
      END IF; 

      IF (ship_ref_id_ IS NOT NULL) THEN 
         IF (ship_ref_id_ <>  NVL(new_ref_id_, Database_SYS.string_null_ )) THEN
            diff_ref_id_ := TRUE;
         END IF; 
      ELSE 
         IF Check_Diff_Ref_Id___(shipment_id_, new_ref_id_) THEN 
            diff_ref_id_ := TRUE;
         END IF; 
      END IF;
      
      IF diff_ref_id_ THEN
         Error_SYS.Record_General(lu_name_, 'DIFFREFID: Reference ID of the source line should be same to the value in shipment.');
      END IF;
   END IF;
   
END Validate_Ref_Id;
-- gelr: outgoing_fiscal_note, end