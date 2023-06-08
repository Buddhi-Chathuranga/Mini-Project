-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderEventCreation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200304  BudKlk  Bug 148995 (SCZ-5793), Modified the method Consignment_Stock_Order_Point to resize the variable size of cust_ref_.    
--  200120  SatGlk SCSPRING20-1778, Modified event Order_Released, Unutilized_Promo_Deal_Release by changing SALESMAN to SALESPERSON.
--  191231  SatGlk SCXTEND-1514, Modified event Order_Released, Unutilized_Promo_Deal_Release by changing SALESMAN to SALESPERSON.
--  160311  BudKlk Bug 127850, Modified the method Order_Released to get the value for the attribute order_id to be use in the standard event ORDER_RELEASED.
--  160218  MaIklk  LIM-4144, Moved Shipment_Processing_Error() to Shipment Flow package.
--  151110  MaIklk LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  131021  Hiralk CAHOOK-2182, Replaced Person_Info_Comm_Method_API and Customer_Info_Comm_Method_API with Comm_Method_API.
--  130509  Cpeilk Bug 108603, Added procedure Order_Delivered_Using_Shipment.
--  130508  KiSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  121001  NipKlk Bug 105468, Modified Adjusted_Po_Pegging by adding BUYER_MAIL_ADDRESS, BUYER and COORDINATOR_EMAIL, modified Adjusted_So_Pegging by adding 
--  121001         COORDINATOR_EMAIL to add them to the available events.
--  120313  MaMalk Bug 99430, Modified method Order_Line_Status_Change to add attribute INVERTED_CONV_FACTOR.
--  120118  DaZase Added new event implemented with new method Unutilized_Promo_Deal_Release.
--  111128  TiRalk Bug 99878, Modified methods Order_Delivered, Order_Released, Pick_List_Created, Customer_Order_Line_Shortage, Order_Credit_Blocked, 
--  111128         Delivery_Date_Or_Qty_Changed, Order_Processing_Error, External_Order_Stopped, Order_Line_Sourcing_Error, Create_Invoice,
--  111128         Order_Status_Change, Order_Line_Status_Change, Adjusted_Po_Pegging, Adjusted_So_Pegging and Shipment_Processing_Error
--  111128         by adding new parameter CONTRACT as it helps to figure the site which the event was triggered.
--  100520  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  100108  Umdolk Refactoring in Communication Methods in Enterprise.
--  081121  ThAylk Bug 78274, Modified method Shipment_Processing_Error to add attribites CUSTOMER_NO, CUSTOMER_NAME,
--  081121         CUSTOMER_DEF_EMAIL, CUSTOMER_DEF_FAXNO and FORWARD_AGENT_ID to the message. 
--  071114  SaJjlk Bug 68665, Added parameters old_planned_delivery_date_, old_revised_qty_due_ and part_no_
--  071114         to method Delivery_Date_Or_Qty_Changed.
--  060516  NaLrlk Enlarge Address - Changed variable definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  050511  MiKulk Bug 50947, Added the new method Cust_Ord_Line_Price_Changed.
--  050606  HaPulk Moved Event Registrations to order.ins.
--  050105  NuFilk Added method Shipment_Processing_Error.
--  041004  MaJalk Bug 44670, replaced Cust_Ord_Customer_API.Get_Default_E_Mail() with
--  041004         Cust_Ord_Customer_API.Get_Customer_E_Mail() in 9 functions.Modified procedure Create_Invoice.
--  ----------------------- 13.3.0 --------------------------------------------
--  031013  PrJalk Bug Fix 106224, Chagned incorrect General_Sys.Init_Method calls.
--  031008  PrJalk Bug Fix 106224, Chagned incorrect General_Sys.Init_Method calls.
--  030821  MaGulk Merged CR
--  030520  JoEd  Added order line keys as parameters to the ORDER_LINE_SOURCING_ERROR event.
--  ********************************* CR Merge ******************************
--  030513  GeKaLk Removed methods Unfulfilled_Pegging_Co_Po and Unfulfilled_Pegging_Co_So.
--  030409  AnJplk Modified according to code review results.
--  030328  GeKaLk Modified methods Unfulfilled_Pegging_Co_Po, Unfulfilled_Pegging_Co_So,
--                 Adjusted_Po_Peggings and Adjusted_So_Peggings to minimize function calls.
--  030327  GeKaLk Added a new method Unfulfilled_Pegging_Co_So.
--  030325  GeKaLk Added a new method Unfulfilled_Pegging_Co_Po.
--  030324  AnJplk Added new methods Adjusted_Po_Peggings and Adjusted_So_Peggings.
--  030321  AnJplk  Registered attribute PEGGINGS_EXIST.
--  030320  AnJplk  Added attribute PEGGINGS_EXIST to the event Order_Credit_Blocked.
--  010913  JoEd  Bug fix 21382. Added company in the Create_Invoice cursors
--                for better performance.
--  ----------------------- 13.0 --------------------------------------------
--  000609  DaZa  Bug fix 16476, fixed Order_Released so total_base_price get correct value.
--  000530  DaZa  Added new methods Create_Invoice Order_Status_Change and
--                Order_Line_Status_Change.
--                Added 2 parameters to Delivery_Date_Or_Qty_Changed.
--  000522  MaGu  Bug fix 39125. Renamed events in Register events.
--  000419  PaLj  Corrected Init_Method Errors
--  000320  JoEd  Added email addresses to the salesman, order coordinator
--                and email plus fax no. to the customer in most of the events.
--  ----------------------- 12.0 --------------------------------------------
--  991020  JOHW  CID 21230 - Contribution.
--  991006  SaMi  Order_Line_Sourcing_Error is added to handle order lines sourcing errors
--  990413  PaLj  Yoshimura - Performance changes
--  990322  JoAn  Changes in Order_Credit_Blocked. This message will now only
--                be created if Payment is not installed and the customer
--                in Order is credit blocked.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  990114  JoAn  Added new message attribute CR_LIMIT_CURRENCY to
--                ORDER_CREDIT_BLOCKED message.
--  990107  ErFi  Changed authorize_code_ to VARCHAR2(20)
--  980917  RaKu  Added Consignment_Stock_Order_Point.
--  980326  MNYS  Changed in prodedure Order_Delivered. Changed sales_unit_meas
--                to unit_meas in procedure Customer_Order_Line_Shortage.
--  980318  JoAn  Added trailing ^ to all event definitions. Needed in order
--                to complete the definition of the last parameter.
--  980310  MNYS  Deleted procedure Planned_Delivery_Date_Changed and added
--                procedure Delivery_Date_Or_Qty_Changed.
--  980302  MNYS  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Order_Delivered
--   Generate an event using the event server when a customer order has
--   been delivered.
PROCEDURE Order_Delivered (
   order_no_ IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_DELIVERED')) THEN
      ordrec_ := Customer_Order_API.Get(order_no_);

      msg_ := Message_SYS.Construct('ORDER_DELIVERED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);

      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_PO_NO', ordrec_.customer_po_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_REF', ordrec_.cust_ref);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR', ordrec_.authorize_code);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_NAME', Order_Coordinator_API.Get_Name(ordrec_.authorize_code));
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', ordrec_.authorize_code, 'E_MAIL'));
      Message_SYS.Add_Attribute( msg_, 'FORWARD_AGENT_ID', ordrec_.forward_agent_id);

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_DELIVERED', msg_);
   END IF;
END Order_Delivered;


-- Order_Released
--   Generete an event server event when a customer order has been released.
PROCEDURE Order_Released (
   order_no_ IN VARCHAR2 )
IS
   msg_              VARCHAR2(2000);
   fnd_user_         VARCHAR2(30);
   contribution_     NUMBER;
   ordrec_           Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_RELEASED')) THEN
      ordrec_ := Customer_Order_API.Get(order_no_);

      msg_ := Message_SYS.Construct('ORDER_RELEASED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);

      -- Other important information
      contribution_ := Customer_Order_API.Get_Total_Contribution(order_no_);

      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'TOTAL_BASE_PRICE', Customer_Order_API.Get_Total_Base_Price(order_no_));
      Message_SYS.Add_Attribute( msg_, 'CONTRIBUTION', contribution_);
      Message_SYS.Add_Attribute( msg_, 'SALESPERSON', ordrec_.salesman_code);
      Message_SYS.Add_Attribute( msg_, 'SALESPERSON_NAME', Sales_Part_Salesman_API.Get_Name(ordrec_.salesman_code));
      Message_SYS.Add_Attribute( msg_, 'SALESPERSON_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', ordrec_.salesman_code, 'E_MAIL'));
      Message_SYS.Add_Attribute( msg_, 'ORDER_ID', ordrec_.order_id);

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_RELEASED', msg_);
   END IF;
END Order_Released;


-- Pick_List_Created
--   Generete an event server event when a pick list has been created
--   for a customer order.
PROCEDURE Pick_List_Created (
   order_no_ IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'PICK_LIST_CREATED')) THEN
      ordrec_ := Customer_Order_API.Get(order_no_);

      msg_ := Message_SYS.Construct('PICK_LIST_CREATED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME',Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_PO_NO', ordrec_.customer_po_no);

      Event_SYS.Event_Execute('CustomerOrder', 'PICK_LIST_CREATED', msg_);
   END IF;
END Pick_List_Created;


-- Customer_Order_Line_Shortage
--   Generete an event server event when a shortage has occurred
--   for a customer order line.
PROCEDURE Customer_Order_Line_Shortage (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   msg_                   VARCHAR2(2000);
   fnd_user_              VARCHAR2(30);
   part_no_               VARCHAR2(25);
   qty_shortage_          NUMBER;
   planned_delivery_date_ DATE;
   ordrec_                Customer_Order_API.Public_Rec;

   CURSOR get_shortage_info IS
      SELECT part_no,
             (revised_qty_due - qty_assigned - qty_shipped + qty_shipdiff) qty_shortage,
             planned_delivery_date
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'CUSTOMER_ORDER_LINE_SHORTAGE')) THEN
      ordrec_ := Customer_Order_API.Get(order_no_);

      msg_ := Message_SYS.Construct('CUSTOMER_ORDER_LINE_SHORTAGE');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_NO', line_no_);
      Message_SYS.Add_Attribute( msg_, 'REL_NO', rel_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_ITEM_NO', line_item_no_);

      -- Other important information
      OPEN get_shortage_info;
      FETCH get_shortage_info INTO part_no_, qty_shortage_, planned_delivery_date_;
      CLOSE get_shortage_info;

      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'INV_PART_NO', part_no_);
      Message_SYS.Add_Attribute( msg_, 'INV_PART_NO_DESC', Inventory_Part_API.Get_Description(ordrec_.contract, part_no_));
      Message_SYS.Add_Attribute( msg_, 'QTY_SHORTAGE', qty_shortage_);
      Message_SYS.Add_Attribute( msg_, 'UNIT_MEAS', Inventory_Part_API.Get_Unit_Meas(ordrec_.contract, part_no_));
      Message_SYS.Add_Attribute( msg_, 'PLANNED_DELIVERY_DATE', planned_delivery_date_);

      Message_SYS.Add_Attribute( msg_, 'COORDINATOR', ordrec_.authorize_code);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_NAME', Order_Coordinator_API.Get_Name(ordrec_.authorize_code));
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', ordrec_.authorize_code, 'E_MAIL'));

      Event_SYS.Event_Execute('CustomerOrder', 'CUSTOMER_ORDER_LINE_SHORTAGE', msg_);
   END IF;
END Customer_Order_Line_Shortage;


-- Order_Credit_Blocked
--   Generete an event server event when a customer order has been credit blocked.
PROCEDURE Order_Credit_Blocked (
   order_no_ IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_CREDIT_BLOCKED')) THEN
      msg_ := Message_SYS.Construct('ORDER_CREDIT_BLOCKED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      ordrec_ := Customer_Order_API.Get(order_no_);
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'TOTAL_PRICE_CURRENCY', Customer_Order_API.Get_Total_Base_Price(order_no_));
      Message_SYS.Add_Attribute( msg_, 'PEGGINGS_EXIST', Customer_Order_API.Check_Peggings_Exist(order_no_));

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_CREDIT_BLOCKED', msg_);
   END IF;
END Order_Credit_Blocked;


-- Delivery_Date_Or_Qty_Changed
--   Generete an event server event when the planned delivery date has been
--   changed for an order line connected to a purchase/shop order.
PROCEDURE Delivery_Date_Or_Qty_Changed (
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   rel_no_                    IN VARCHAR2,
   line_item_no_              IN NUMBER,
   old_planned_delivery_date_ IN DATE,
   old_revised_qty_due_       IN NUMBER,
   new_planned_delivery_date_ IN DATE,
   new_revised_qty_due_       IN NUMBER,
   supply_code_               IN VARCHAR2,
   qty_on_order_              IN NUMBER,
   part_no_                   IN VARCHAR2 )
IS
   msg_                   VARCHAR2(2000);
   fnd_user_              VARCHAR2(30);
   po_order_no_           VARCHAR2(12);
   po_line_no_            VARCHAR2(4);
   po_rel_no_             VARCHAR2(4);
   purchase_type_         VARCHAR2(20);
   so_order_no_           VARCHAR2(12);
   so_release_no_         VARCHAR2(4);
   so_sequence_no_        VARCHAR2(4);
   ordrec_                Customer_Order_API.Public_Rec;

BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'DELIVERY_DATE_OR_QTY_CHANGED')) THEN
      ordrec_ := Customer_Order_API.Get(order_no_);

      msg_ := Message_SYS.Construct('DELIVERY_DATE_OR_QTY_CHANGED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_NO', line_no_);
      Message_SYS.Add_Attribute( msg_, 'REL_NO', rel_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_ITEM_NO', line_item_no_);

      -- Other important information
      Customer_Order_Pur_Order_API.Get_Purord_For_Custord(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                                                          order_no_, line_no_, rel_no_, line_item_no_);
      Customer_Order_Shop_Order_API.Get_Shop_Order(so_order_no_, so_release_no_, so_sequence_no_,
                                                   order_no_, line_no_, rel_no_, line_item_no_);

      Message_SYS.Add_Attribute( msg_, 'PO_ORDER_NO', po_order_no_);
      Message_SYS.Add_Attribute( msg_, 'PO_LINE_NO', po_line_no_);
      Message_SYS.Add_Attribute( msg_, 'PO_REL_NO', po_rel_no_);
      Message_SYS.Add_Attribute( msg_, 'SO_ORDER_NO', so_order_no_);
      Message_SYS.Add_Attribute( msg_, 'SO_RELEASE_NO', so_release_no_);
      Message_SYS.Add_Attribute( msg_, 'SO_SEQUENCE_NO', so_sequence_no_);
      Message_SYS.Add_Attribute( msg_, 'INV_PART_NO', part_no_);
      Message_SYS.Add_Attribute( msg_, 'INV_PART_NO_DESC', Inventory_Part_API.Get_Description(ordrec_.contract, part_no_));
      Message_SYS.Add_Attribute( msg_, 'NEW_REVISED_QTY_DUE', new_revised_qty_due_);
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'OLD_REVISED_QTY_DUE', old_revised_qty_due_);
      Message_SYS.Add_Attribute( msg_, 'NEW_PLANNED_DELIVERY_DATE', new_planned_delivery_date_);
      Message_SYS.Add_Attribute( msg_, 'OLD_PLANNED_DELIVERY_DATE', old_planned_delivery_date_);
      Message_SYS.Add_Attribute( msg_, 'SUPPLY_CODE', supply_code_);
      Message_SYS.Add_Attribute( msg_, 'QTY_ON_ORDER', qty_on_order_);
      Message_SYS.Add_Attribute( msg_, 'EXTERNAL_REF', ordrec_.external_ref);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR', ordrec_.authorize_code);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_NAME', Order_Coordinator_API.Get_Name(ordrec_.authorize_code));
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', ordrec_.authorize_code, 'E_MAIL'));

      Event_SYS.Event_Execute('CustomerOrder', 'DELIVERY_DATE_OR_QTY_CHANGED', msg_);
   END IF;
END Delivery_Date_Or_Qty_Changed;


-- Order_Processing_Error
--   Generate an event server event when an error has occured while
--   processing an order.
PROCEDURE Order_Processing_Error (
   order_no_      IN VARCHAR2,
   error_message_ IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_PROCESSING_ERROR')) THEN
      msg_ := Message_SYS.Construct('ORDER_PROCESSING_ERROR');
      ordrec_ := Customer_Order_API.Get(order_no_);
      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(Customer_Order_API.get_contract(order_no_)));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'ERROR_MESSAGE', error_message_);

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_PROCESSING_ERROR', msg_);
   END IF;
END Order_Processing_Error;


-- External_Order_Stopped
--   Generate an event server event when an error has occured when
--   trying to create a customer order from an external order received
--   through the EDI/MHS interface.
PROCEDURE External_Order_Stopped (
   message_id_    IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
BEGIN

   IF (Event_SYS.Event_Enabled('ExternalCustomerOrder', 'EXTERNAL_ORDER_STOPPED')) THEN
      msg_ := Message_SYS.Construct('EXTERNAL_ORDER_STOPPED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', nvl(Site_API.Get_Site_Date(User_Default_API.Get_Contract), SYSDATE));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      Message_SYS.Add_Attribute( msg_, 'CONTRACT', External_Customer_Order_API.Get_Contract(message_id_));

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'MESSAGE_ID', message_id_);
      Message_SYS.Add_Attribute( msg_, 'ERROR_MESSAGE', error_message_);

      Event_SYS.Event_Execute('ExternalCustomerOrder', 'EXTERNAL_ORDER_STOPPED', msg_);
   END IF;
END External_Order_Stopped;


-- Consignment_Stock_Order_Point
--   Generete an event server event when a catalog no in the consignment
--   stock is below the order point.
PROCEDURE Consignment_Stock_Order_Point (
   contract_    IN VARCHAR2,
   catalog_no_  IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   addr_no_     IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   cust_ref_ VARCHAR2(100);
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'CONSIGNMENT_STOCK_ORDER_POINT')) THEN
      msg_ := Message_SYS.Construct('CONSIGNMENT_STOCK_ORDER_POINT');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(contract_));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', contract_);
      Message_SYS.Add_Attribute( msg_, 'CATALOG_NO', catalog_no_);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', customer_no_);
      Message_SYS.Add_Attribute( msg_, 'ADDR_NO', addr_no_);

      -- Other important information
      cust_ref_ := Cust_Ord_Customer_API.Get_Cust_Ref(customer_no_);

      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(customer_no_));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(customer_no_, addr_no_));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', customer_no_, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_REF', cust_ref_);
      Message_SYS.Add_Attribute( msg_, 'CONSIGNMENT_STOCK_QTY', Customer_Consignment_Stock_API.Get_Consignment_Stock_Qty(
                                                                   contract_, catalog_no_, customer_no_, addr_no_));
      Event_SYS.Event_Execute('CustomerOrder', 'CONSIGNMENT_STOCK_ORDER_POINT', msg_);
   END IF;
END Consignment_Stock_Order_Point;


-- Order_Line_Sourcing_Error
--   Generate an event server event when an error has occured while
--   soucing an order line.
PROCEDURE Order_Line_Sourcing_Error (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_LINE_SOURCING_ERROR')) THEN
      msg_ := Message_SYS.Construct('ORDER_PROCESSING_ERROR');
      ordrec_ := Customer_Order_API.Get(order_no_);

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(order_no_)));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_NO', line_no_);
      Message_SYS.Add_Attribute( msg_, 'REL_NO', rel_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_ITEM_NO', line_item_no_);
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'ERROR_MESSAGE', error_message_);

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_LINE_SOURCING_ERROR', msg_);
   END IF;
END Order_Line_Sourcing_Error;


-- Create_Invoice
--   Generate an event server event when an Invoice have been created.
PROCEDURE Create_Invoice (
   order_no_   IN VARCHAR2,
   invoice_id_ IN NUMBER )
IS
   msg_                 VARCHAR2(2000);
   fnd_user_            VARCHAR2(30);
   ordrec_              Customer_Order_API.Public_Rec;
   invoice_no_          VARCHAR2(50);
   invoice_type_        VARCHAR2(20);
   series_id_           VARCHAR2(20);
   collect_             VARCHAR2(5);
   curr_amount_         NUMBER;
   vat_amount_          NUMBER;
   net_amount_          NUMBER;
   gross_curr_amount_   NUMBER;
   vat_curr_amount_     NUMBER;
   net_curr_amount_     NUMBER;
   company_             VARCHAR2(20);
   invoice_address_id_  CUST_ORD_CUSTOMER_ADDRESS_PUB.addr_no%TYPE;

   CURSOR get_invoice_head IS
      SELECT invoice_no,
             invoice_type,
             series_id,
             collect,
             gross_amount,
             vat_amount,
             net_amount,
             invoice_address_id
      FROM   CUSTOMER_ORDER_INV_HEAD
      WHERE  company = company_
      AND    invoice_id = invoice_id_;

   CURSOR get_order_sums IS
      SELECT sum(gross_curr_amount),
             sum(vat_curr_amount),
             sum(net_curr_amount)
      FROM   CUSTOMER_ORDER_INV_ITEM
      WHERE  order_no = order_no_
      AND    company = company_
      AND    invoice_id = invoice_id_;

BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'CREATE_INVOICE')) THEN
      msg_ := Message_SYS.Construct('CREATE_INVOICE');


      ordrec_ := Customer_Order_API.Get(order_no_);

      company_ := Site_API.Get_Company(ordrec_.contract);

      OPEN get_invoice_head;
      FETCH get_invoice_head INTO invoice_no_, invoice_type_, series_id_, collect_, curr_amount_, vat_amount_, net_amount_,invoice_address_id_;
      CLOSE get_invoice_head;

      OPEN get_order_sums;
      FETCH get_order_sums INTO gross_curr_amount_, vat_curr_amount_, net_curr_amount_;
      CLOSE get_order_sums;

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'INVOICE_ID', invoice_id_);
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'INVOICE_NO', invoice_no_);
      Message_SYS.Add_Attribute( msg_, 'SERIES_ID', series_id_);
      Message_SYS.Add_Attribute( msg_, 'INVOICE_TYPE', invoice_type_);
      Message_SYS.Add_Attribute( msg_, 'COLLECTIVE_FLAG', collect_);
      Message_SYS.Add_Attribute( msg_, 'INVOICE_GROSS_AMOUNT', curr_amount_);
      Message_SYS.Add_Attribute( msg_, 'INVOICE_VAT_AMOUNT', vat_amount_);
      Message_SYS.Add_Attribute( msg_, 'INVOICE_NET_AMOUNT', net_amount_);
      Message_SYS.Add_Attribute( msg_, 'ORDER_GROSS_AMOUNT', gross_curr_amount_);
      Message_SYS.Add_Attribute( msg_, 'ORDER_VAT_AMOUNT', vat_curr_amount_);
      Message_SYS.Add_Attribute( msg_, 'ORDER_NET_AMOUNT', net_curr_amount_);
      Message_SYS.Add_Attribute( msg_, 'EXTERNAL_REF', ordrec_.external_ref);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO_PAY', ordrec_.customer_no_pay);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO_PAY_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no_pay));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO_PAY_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no_pay,invoice_address_id_));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO_PAY_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no_pay, 'FAX'));

      Event_SYS.Event_Execute('CustomerOrder', 'CREATE_INVOICE', msg_);
   END IF;
END Create_Invoice;


-- Order_Status_Change
--   Generate an event server event when an Order have changed status.
PROCEDURE Order_Status_Change (
   order_no_  IN VARCHAR2,
   status_    IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_STATUS_CHANGE')) THEN
      msg_ := Message_SYS.Construct('ORDER_STATUS_CHANGE');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      ordrec_ := Customer_Order_API.Get(order_no_);
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'EXTERNAL_REF', ordrec_.external_ref);
      Message_SYS.Add_Attribute( msg_, 'STATUS', status_);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_STATUS_CHANGE', msg_);
   END IF;

END Order_Status_Change;


-- Order_Line_Status_Change
--   Generate an event server event when an Order Line have changed status.
PROCEDURE Order_Line_Status_Change (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   status_        IN VARCHAR2 )
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;
   ordrowrec_ Customer_Order_Line_API.Public_Rec;

BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_LINE_STATUS_CHANGE')) THEN
      msg_ := Message_SYS.Construct('ORDER_LINE_STATUS_CHANGE');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      ordrec_ := Customer_Order_API.Get(order_no_);
      ordrowrec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_NO', line_no_);
      Message_SYS.Add_Attribute( msg_, 'REL_NO', rel_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_ITEM_NO', line_item_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'EXTERNAL_REF', ordrec_.external_ref);
      Message_SYS.Add_Attribute( msg_, 'STATUS', status_);
      Message_SYS.Add_Attribute( msg_, 'QTY_SHIPPED', ordrowrec_.qty_shipped);
      Message_SYS.Add_Attribute( msg_, 'QTY_SHIPDIFF', ordrowrec_.qty_shipdiff);
      Message_SYS.Add_Attribute( msg_, 'QTY_ON_ORDER', ordrowrec_.qty_on_order);
      Message_SYS.Add_Attribute( msg_, 'QTY_INVOICED', ordrowrec_.qty_invoiced);
      Message_SYS.Add_Attribute( msg_, 'BUY_QTY_DUE', ordrowrec_.buy_qty_due);
      Message_SYS.Add_Attribute( msg_, 'CONV_FACTOR', ordrowrec_.conv_factor);
      Message_SYS.Add_Attribute( msg_, 'INVERTED_CONV_FACTOR', ordrowrec_.inverted_conv_factor);
      Message_SYS.Add_Attribute( msg_, 'REAL_SHIP_DATE', ordrowrec_.real_ship_date);
      Message_SYS.Add_Attribute( msg_, 'PLANNED_DELIVERY_DATE', ordrowrec_.planned_delivery_date);
      Message_SYS.Add_Attribute( msg_, 'WANTED_DELIVERY_DATE', ordrowrec_.wanted_delivery_date);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_LINE_STATUS_CHANGE', msg_);
   END IF;
END Order_Line_Status_Change;


-- Adjusted_Po_Pegging
--   Generate an event server event when PO pegging for an Order Line get changed.
PROCEDURE Adjusted_Po_Pegging (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   msg_                   VARCHAR2(2000);
   fnd_user_              VARCHAR2(30);
   planner_               VARCHAR2(25);
   order_rec_             CUSTOMER_ORDER_LINE_API.Public_Rec;
   po_buyer_code_         VARCHAR2(20);

BEGIN


   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ADJUSTED_PO_PEGGINGS')) THEN
      order_rec_ := Customer_Order_Line_API.Get(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);
      planner_  :=Inventory_Part_API.Get_Planner_Buyer(order_rec_.contract, order_rec_.part_no);
      msg_ := Message_SYS.Construct('ADJUSTED_PO_PEGGINGS');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(order_rec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'OE_ORDER_NO', oe_order_no_);
      Message_SYS.Add_Attribute( msg_, 'OE_LINE_NO', oe_line_no_);
      Message_SYS.Add_Attribute( msg_, 'OE_REL_NO', oe_rel_no_);
      Message_SYS.Add_Attribute( msg_, 'OE_LINE_ITEM_NO', oe_line_item_no_);
      Message_SYS.Add_Attribute( msg_, 'PO_ORDER_NO', po_order_no_);
      Message_SYS.Add_Attribute( msg_, 'PO_LINE_NO', po_line_no_);
      Message_SYS.Add_Attribute( msg_, 'PO_REL_NO', po_rel_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'PLANNER', planner_);
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', order_rec_.contract);
      Message_SYS.Add_Attribute( msg_, 'PEGGED_QTY', qty_on_order_);
      Message_SYS.Add_Attribute( msg_, 'PLANNED_SHIP_DATE',order_rec_.planned_ship_date );
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', Customer_Order_API.Get_Authorize_Code(oe_order_no_), 'E_MAIL'));
      
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         po_buyer_code_ := Purchase_Order_API.Get_Buyer_Code(po_order_no_);
      $END

      Message_SYS.Add_Attribute( msg_, 'BUYER', po_buyer_code_);
      Message_SYS.Add_Attribute( msg_, 'BUYER_MAIL_ADDRESS', Comm_Method_API.Get_Default_Value('PERSON', po_buyer_code_, 'E_MAIL'));


      Event_SYS.Event_Execute('CustomerOrder', 'ADJUSTED_PO_PEGGINGS', msg_);
   END IF;
END Adjusted_Po_Pegging;


-- Adjusted_So_Pegging
--   Generate an event server event when SO pegging for an Order Line get changed.
PROCEDURE Adjusted_So_Pegging (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_rel_no_       IN VARCHAR2,
   so_sequence_no_  IN VARCHAR2,
   qty_on_order_    IN NUMBER )
IS
   msg_                   VARCHAR2(2000);
   fnd_user_              VARCHAR2(30);
   planner_               VARCHAR2(25);
   order_rec_             CUSTOMER_ORDER_LINE_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'Adjusted_So_Pegging')) THEN
      order_rec_ := Customer_Order_Line_API.Get(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_);
      planner_  :=Inventory_Part_API.Get_Planner_Buyer(order_rec_.contract, order_rec_.part_no);
      msg_ := Message_SYS.Construct('ADJUSTED_SO_PEGGINGS');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(order_rec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'OE_ORDER_NO', oe_order_no_);
      Message_SYS.Add_Attribute( msg_, 'OE_LINE_NO', oe_line_no_);
      Message_SYS.Add_Attribute( msg_, 'OE_REL_NO', oe_rel_no_);
      Message_SYS.Add_Attribute( msg_, 'OE_LINE_ITEM_NO', oe_line_item_no_);
      Message_SYS.Add_Attribute( msg_, 'SO_ORDER_NO', so_order_no_);
      Message_SYS.Add_Attribute( msg_, 'SO_REL_NO', so_rel_no_);
      Message_SYS.Add_Attribute( msg_, 'SO_SEQUENCE_NO', so_sequence_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'PLANNER', planner_);
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', order_rec_.contract);
      Message_SYS.Add_Attribute( msg_, 'PEGGED_QTY', qty_on_order_);
      Message_SYS.Add_Attribute( msg_, 'PLANNED_SHIP_DATE',order_rec_.planned_ship_date );
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', Customer_Order_API.Get_Authorize_Code(oe_order_no_), 'E_MAIL'));

      Event_SYS.Event_Execute('CustomerOrder', 'ADJUSTED_SO_PEGGINGS', msg_);
   END IF;

END Adjusted_So_Pegging;


PROCEDURE Cust_Ord_Line_Price_Changed (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   calc_price_per_curr_ IN NUMBER,
   calc_price_per_base_ IN NUMBER,
   price_difference_    IN NUMBER )
IS
   msg_                 VARCHAR2(2000);
   fnd_user_            VARCHAR2(30);
   catalog_no_          VARCHAR2(25);

   ordrec_              Customer_Order_API.Public_Rec;
   linerec_             Customer_Order_Line_API.Public_Rec;

BEGIN
   IF (Event_SYS.Event_Enabled('CustomerOrder', 'CUST_ORD_LINE_PRICE_CHANGED')) THEN
      ordrec_ := Customer_Order_API.Get(order_no_);
      linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

      msg_ := Message_SYS.Construct('CUST_ORD_LINE_PRICE_CHANGED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

     --Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_NO', line_no_);
      Message_SYS.Add_Attribute( msg_, 'REL_NO', rel_no_);
      Message_SYS.Add_Attribute( msg_, 'LINE_ITEM_NO', line_item_no_);


      Message_SYS.Add_Attribute( msg_, 'COMPANY', Site_API.Get_Company(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'DATE_ENTERED', ordrec_.date_entered);

      Message_SYS.Add_Attribute( msg_, 'CATALOG_NO', linerec_.catalog_no);
      Message_SYS.Add_Attribute( msg_, 'PRICE_SOURCE', linerec_.price_source);
      Message_SYS.Add_Attribute( msg_, 'PRICE_SOURCE_ID', linerec_.price_source_id);
      Message_SYS.Add_Attribute( msg_, 'SALES_PRICE_GROUP_ID', Sales_Part_API.Get_Sales_Price_Group_Id(ordrec_.contract, catalog_no_));
      Message_SYS.Add_Attribute( msg_, 'CATALOG_GROUP', Sales_Part_API.Get_Catalog_Group(ordrec_.contract, catalog_no_));

      Message_SYS.Add_Attribute( msg_, 'BUY_QTY_DUE', linerec_.buy_qty_due);
      Message_SYS.Add_Attribute( msg_, 'PRICE_CONV_FACTOR', linerec_.price_conv_factor);
      Message_SYS.Add_Attribute( msg_, 'SALE_UNIT_PRICE', linerec_.sale_unit_price);
      Message_SYS.Add_Attribute( msg_, 'CALC_PRICE_PER_CURR', calc_price_per_curr_);
      Message_SYS.Add_Attribute( msg_, 'BASE_SALE_UNIT_PRICE', linerec_.base_sale_unit_price);
      Message_SYS.Add_Attribute( msg_, 'CALC_PRICE_PER_BASE', calc_price_per_base_);
      Message_SYS.Add_Attribute( msg_, 'PRICE_DIFFERENCE', price_difference_);


     Event_SYS.Event_Execute('CustomerOrder', 'CUST_ORD_LINE_PRICE_CHANGED', msg_);
   END IF;
END Cust_Ord_Line_Price_Changed;


PROCEDURE Unutilized_Promo_Deal_Release (
   order_no_            IN VARCHAR2,
   notified_in_client_  IN BOOLEAN )
IS
   msg_              VARCHAR2(2000);
   fnd_user_         VARCHAR2(30);
   ordrec_           Customer_Order_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'UNUTILIZED_PROMO_DEAL_AT_RELEASE')) THEN
      ordrec_ := Customer_Order_API.Get(order_no_);

      msg_ := Message_SYS.Construct('UNUTILIZED_PROMO_DEAL_AT_RELEASE');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'COMPANY', Site_API.Get_Company(ordrec_.contract));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      IF (notified_in_client_) THEN
         Message_SYS.Add_Attribute( msg_, 'NOTIFIED_IN_CLIENT_FLAG', 'TRUE');
      ELSE
         Message_SYS.Add_Attribute( msg_, 'NOTIFIED_IN_CLIENT_FLAG', 'FALSE');
      END IF;  
      -- Using the check method again since we already know that if we are here a unutilized deal exist and if we call this method again 
      -- a second time (with 1 parameter only) we will get TRUE (=Notify flag) if any deal of the unutilized deals have the notify flag set
      Message_SYS.Add_Attribute( msg_, 'DEAL_NOTIFY_FLAG', Sales_Promotion_Util_API.Check_Unutilized_O_Deals_Exist(order_no_)); 
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'EXTERNAL_REF', ordrec_.external_ref);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR', ordrec_.authorize_code);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_NAME', Order_Coordinator_API.Get_Name(ordrec_.authorize_code));
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', ordrec_.authorize_code, 'E_MAIL'));
      Message_SYS.Add_Attribute( msg_, 'SALESPERSON', ordrec_.salesman_code);
      Message_SYS.Add_Attribute( msg_, 'SALESPERSON_NAME', Sales_Part_Salesman_API.Get_Name(ordrec_.salesman_code));
      Message_SYS.Add_Attribute( msg_, 'SALESPERSON_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', ordrec_.salesman_code, 'E_MAIL'));

      Event_SYS.Event_Execute('CustomerOrder', 'UNUTILIZED_PROMO_DEAL_AT_RELEASE', msg_);
   END IF;
END Unutilized_Promo_Deal_Release;


PROCEDURE Order_Delivered_Using_Shipment (
   shipment_id_  IN NUMBER,
   order_no_     IN VARCHAR2)
IS
   msg_      VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   ordrec_   Customer_Order_API.Public_Rec;

BEGIN

   IF (Event_SYS.Event_Enabled('CustomerOrder', 'ORDER_DELIVERED_USING_SHIPMENT')) THEN  
      ordrec_ := Customer_Order_API.Get(order_no_);

      msg_ := Message_SYS.Construct('ORDER_DELIVERED_USING_SHIPMENT');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(ordrec_.contract)); 
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'SHIPMENT_ID', shipment_id_);
      Message_SYS.Add_Attribute( msg_, 'ORDER_NO', order_no_); 
      
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NO', ordrec_.customer_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_NAME', Cust_Ord_Customer_API.Get_Name(ordrec_.customer_no));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', ordrec_.contract);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_EMAIL', Cust_Ord_Customer_API.Get_Customer_E_Mail(ordrec_.customer_no, ordrec_.bill_addr_no));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', ordrec_.customer_no, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_PO_NO', ordrec_.customer_po_no);
      Message_SYS.Add_Attribute( msg_, 'CUSTOMER_REF', ordrec_.cust_ref);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR', ordrec_.authorize_code);
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_NAME', Order_Coordinator_API.Get_Name(ordrec_.authorize_code));
      Message_SYS.Add_Attribute( msg_, 'COORDINATOR_EMAIL', Comm_Method_API.Get_Default_Value('PERSON', ordrec_.authorize_code, 'E_MAIL'));
      Message_SYS.Add_Attribute( msg_, 'FORWARD_AGENT_ID', ordrec_.forward_agent_id);

      Event_SYS.Event_Execute('CustomerOrder', 'ORDER_DELIVERED_USING_SHIPMENT', msg_);
   END IF;
END Order_Delivered_Using_Shipment;



