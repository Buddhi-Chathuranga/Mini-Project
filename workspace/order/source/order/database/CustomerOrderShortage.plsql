-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderShortage
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210630  JOWISE   MF21R2-2040, Truncate time indication for Planned Due Date field when comparing with a date field
--  210303  ThKrlk   Bug 158111 (SCZ-13853), Modified Remove_All() to get a new parameter planned_due_date_ and changed the cursor to filter by planned_due_date.
--  120319  KiSalk   Bug 101795, Moved contract filtering to the cursor in Remove_All and avoided row_deleted exception in Remove.
--  100519  KRPELK   Merge Rose Method Documentation.
--  090925  MaMalk   Removed unused view CUSTOMER_ORDER_SHORTAGE_JOIN.
--  ------------------------- 14.0.0 -----------------------------------------
--  080101  ThAylk   Bug 70233, Modified view comment of authorize_code in view CUSTOMER_ORDER_SHORTAGE_JOIN. 
--  070110  NaLrlk   Modified the shortage message PLANPICK01.
--  061220  NaLrlk   Modified the messages PLANPICK04,06,07,08 and added PLANPICK11 in Get_Message_Description.
--  061023  RaKalk   Modified Get_Message_Description method to change the messahe descriptions
--  060412  RoJalk   Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ------------------------------------------------
--  060112  MiKulk   Modified the PROCEDURE Insert___ according to the new template.
--  040920  MaEelk   Removed the unused cursor in Get_Message_Description
--  041130  ChBalk   Bug 47915, Added CADCADE option to the base view reference from CustomerOrderLine.
--  041130           Added missing CLOSE cursor statement in Get_Object_By_Id___. 
--  031008  PrJalk   Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  020816  ShFeLk   Bug 29920, Added the function Get_Buy_Qty_Due. 
--  000919  CaRa     Added view Customer_Order_Shortage_Join
--  990416  JakH     Y. use of public-rec from customer_order_line in New.
--  990409  RaKu     New templates.
--  990301  JoAn     Added parameter contract to Remove_All
--  990119  PaLj     changed sysdate to Site_API.Get_Site_Date(contract)
--  981207  JoEd     Changed qty_... column comments.
--  980304  MNYS     Added a call to Cust_Order_Event_Creation_API.Customer_Order_Line_Shortage
--                   in procedure New.
--  971124  RaKu     Changed to FND200 Templates.
--  971016  RaKu     Removed obsolete function Check_Exist__.
--  970523  PAZE     New function Check_Exist__.
--  970312  RaKu     Changed tablename.
--  970218  JoEd     Objversion has been changed.
--  960422  RaKu     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_SHORTAGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Set create date
   newrec_.create_date := Site_API.Get_Site_Date(Customer_Order_API.Get_Contract(newrec_.order_no));
   Client_SYS.Add_To_Attr('CREATE_DATE', newrec_.create_date, attr_);

   super(objid_, objversion_, newrec_, attr_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Create a new CustomerOrderShortage record from another LU.
PROCEDURE New (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   message_code_ IN VARCHAR2 )
IS
   remrec_                CUSTOMER_ORDER_SHORTAGE_TAB%ROWTYPE;
   newrec_                CUSTOMER_ORDER_SHORTAGE_TAB%ROWTYPE;
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   attr_                  VARCHAR2(2000);
   indrec_                Indicator_Rec;
   linerec_               Customer_Order_Line_API.public_rec;
BEGIN

   -- Remove previous record if any
   IF (Check_Exist___(order_no_, line_no_, rel_no_, line_item_no_)) THEN

      remrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_);
      Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
   -- Retrieve information from CustomerOrderLine
   linerec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('BUY_QTY_DUE', linerec_.buy_qty_due, attr_);
   Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', linerec_.planned_delivery_date, attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', linerec_.qty_assigned, attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', linerec_.qty_shipped, attr_);
   Client_SYS.Add_To_Attr('MESSAGE_CODE', message_code_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   Cust_Order_Event_Creation_API.Customer_Order_Line_Shortage(order_no_, line_no_, rel_no_, line_item_no_);
END New;


-- Remove
--   Remove a LU instance.
PROCEDURE Remove (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   remrec_     CUSTOMER_ORDER_SHORTAGE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
EXCEPTION
   WHEN others THEN
      -- No error is raised if a record does not exist, to eliminate errors when simultaneously called by 
      -- Remove_All in several processes such as scheduled "Create Customer Order Reservations" tasks.
      IF Check_Exist___(order_no_, line_no_, rel_no_, line_item_no_) THEN
         RAISE;
      END IF;
END Remove;


-- Check_Exist
--   Check if a specified LU instance exists.
--   Return TRUE if the instance exists, FALSE otherwise.
@UncheckedAccess
FUNCTION Check_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(order_no_, line_no_, rel_no_, line_item_no_);
END Check_Exist;


-- Remove_All
--   Remove all CustomerOrderShortage records for the specified site.
PROCEDURE Remove_All (
   contract_         IN VARCHAR2,
   planned_due_date_ IN DATE)
IS
   CURSOR get_records IS
      SELECT cos.order_no, cos.line_no, cos.rel_no, cos.line_item_no
      FROM   customer_order_shortage_tab cos, customer_order_line_tab col
      WHERE  cos.order_no         = col.order_no
        AND  cos.line_no          = col.line_no
        AND  cos.rel_no           = col.rel_no 
        AND  cos.line_item_no     = col.line_item_no
        AND  col.contract         = contract_
        AND  trunc(col.planned_due_date) <= trunc(planned_due_date_)
        AND  col.rowstate NOT IN ('Invoiced', 'Cancelled');
BEGIN
   FOR rec_ IN get_records LOOP
      Remove(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   END LOOP;
END Remove_All;


-- Get_Message_Description
--   Retrieve the (hardcoded) message description for the specified record.
@UncheckedAccess
FUNCTION Get_Message_Description (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS

   lurec_ CUSTOMER_ORDER_SHORTAGE_TAB%ROWTYPE;

BEGIN
   lurec_ := Get_Object_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_);

   IF lurec_.message_code = 'PLANPICK01' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK01: The line could not be completely reserved. Partial deliveries of order line is not allowed');
   ELSIF lurec_.message_code = 'PLANPICK02' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK02: One or more lines of the order could not be reserved. No backorders allowed');
   ELSIF lurec_.message_code = 'PLANPICK03' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK03: The line has been partially reserved');
   ELSIF lurec_.message_code = 'PLANPICK04' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK04: The line could not be completely reserved. Partial deliveries not allowed for order lines');
   ELSIF lurec_.message_code = 'PLANPICK05' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK05: The line could not be reserved. The part is not available');
   ELSIF lurec_.message_code = 'PLANPICK06' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK06: All package components could not be reserved, partial deliveries not allowed for order. Use package structure to view the shortages for components');
   ELSIF lurec_.message_code = 'PLANPICK07' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK07: The line has been partially reserved, only complete package parts have been reserved. Use package structure to view the shortages for components');
   ELSIF lurec_.message_code = 'PLANPICK08' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK08: All package components could not be reserved, partial deliveries not allowed for incomplete packages. Use package structure to view the shortages for components');
   ELSIF lurec_.message_code = 'PLANPICK09' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK09: All package components could not be reserved');
   ELSIF lurec_.message_code = 'PLANPICK10' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK10: This component has not been reserved due stock-out for another component');
   ELSIF lurec_.message_code = 'PLANPICK11' THEN
      RETURN Language_SYS.Translate_Constant(lu_name_,
'PLANPICK11: All package components could not be reserved .Use package structure to view the shortages for components');
   END IF;
   RETURN (NULL);
END Get_Message_Description;


-- Get_Buy_Qty_Due
--   Returns the total shortage quantity for a specified order no and line no.
FUNCTION Get_Buy_Qty_Due (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2) RETURN NUMBER
IS
   buy_qty_      NUMBER := 0;
   CURSOR get_qty IS
      SELECT buy_qty_due
      FROM   CUSTOMER_ORDER_SHORTAGE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_;
BEGIN
   FOR line_rec_ IN get_qty LOOP
      IF (line_rec_.buy_qty_due > 0) THEN
         buy_qty_ := buy_qty_ + line_rec_.buy_qty_due;
      END IF;
   END LOOP;   
   RETURN buy_qty_;
END Get_Buy_Qty_Due;



