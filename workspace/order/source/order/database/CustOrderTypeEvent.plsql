-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderTypeEvent
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180426  ChBnlk Bug 140582, Added a procedure Raise_Must_Stop___ to prevent duplicating message constants. 
--  150605  JaBalk RED-361, Modified Get_Next_Event to by pass the stop of event for rental transfer.
--  100519  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  070809  MaMalk Call 147207, Replaced method call Customer_Order_API.Get_Pick_Inventory_Type_Db with
--  070809         Cust_Order_Type_API.Get_Pick_Inventory_Type_Db.
--  070221  NaLrlk Modified the methods  Unpack_Check_Insert___ and Unpack_Check_Update___
--  060112  IsWilk Modified the PROCEDURE Insert__ according to template 2.3.
--  040224  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  040114  LoPrlk Rmove public cursors, Cursor get_event was removed.
---------------------------------- 13.3.0 ------------------------------------
--  010215  JoAn  Bug Id 20036 No stop required after printout of order confirmation 
--                even if priority reservations are not used. 
--                Changed in Unpack_Check_Insert___ and Unpack_Check_Update___
--  000913  FBen  Added UNDEFINED.
--  990420  JakH  Removed use of Get_Client_Value
--  990414  JakH  Removed use of Get_Object_By_Id___ in modify routines.
--  990408  RaKu  Removed obsolete column STOP_AFTER.
--  990407  JakH  New template.
--  971125  TOOS  Upgrade to F1 2.0
--  970618  RaKu  Changed shortname from ordevent.apy to ordtyev.apy.
--  970605  RaKu  Added checks in Unpack_Check_Insert___/Update___.
--  970522  JOED  Rebuild the view.
--  970521  RaKu  Removed obsolete checks on event 50.
--  970415  JoAn  Added new function Get_Next_Event.
--  970319  RaKu  Changed all calls from Report_Inventory_Type to Pick_Inventory_Type.
--  970312  NABE  Changed mpc_oeorder_id_event_type to Order_flow_type and changed
--                Table names to Lagical Unit Names.
--  970307  RaKu  Added "report" handling in Unpack_Check_Insert___/Update___.
--  970219  JOED  Changed objversion
--  960213  SVLO  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_order_type_event_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
  
   IF (newrec_.stop_flag = 'N') AND (newrec_.event = 80) AND
      (Cust_Order_Type_API.Get_Pick_Inventory_Type_Db(newrec_.order_id) = 'SHIPINV') THEN
      Raise_Must_Stop___;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_order_type_event_tab%ROWTYPE,
   newrec_ IN OUT cust_order_type_event_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.stop_flag = 'N') AND (newrec_.event = 80) AND
      (Cust_Order_Type_API.Get_Pick_Inventory_Type_Db(newrec_.order_id) = 'SHIPINV') THEN
      Raise_Must_Stop___;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

PROCEDURE Raise_Must_Stop___ 
IS
BEGIN
   Error_SYS.Record_General(lu_name_,
      'NO_SHIPMENT_INV: The order flow must stop after the event ''PRINT PICK LIST'' when shipment inventory is used');
END Raise_Must_Stop___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Modify_Action_Taken__
--   Update the action taken flag for an instance.
PROCEDURE Modify_Action_Taken__ (
   order_id_          IN VARCHAR2,
   event_             IN NUMBER,
   action_taken_flag_ IN VARCHAR2 )
IS
   oldrec_     CUST_ORDER_TYPE_EVENT_TAB%ROWTYPE;
   newrec_     CUST_ORDER_TYPE_EVENT_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___ (order_id_, event_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ACTION_TAKEN_FLAG', action_taken_flag_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Action_Taken__;


-- Modify_Order_Stop__
--   Update the stop flag for an instance.
PROCEDURE Modify_Order_Stop__ (
   order_id_  IN VARCHAR2,
   event_     IN NUMBER,
   stop_flag_ IN VARCHAR2 )
IS
   oldrec_     CUST_ORDER_TYPE_EVENT_TAB%ROWTYPE;
   newrec_     CUST_ORDER_TYPE_EVENT_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___ (order_id_, event_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('STOP_FLAG', stop_flag_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Order_Stop__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Inserts new events when entering a new order type
PROCEDURE New (
   order_id_          IN VARCHAR2,
   event_             IN NUMBER,
   action_taken_flag_ IN VARCHAR2,
   stop_flag_         IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000) := NULL;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     CUST_ORDER_TYPE_EVENT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('ORDER_ID', order_id_, attr_);
   Client_SYS.Add_To_Attr('EVENT', event_, attr_);
   Client_SYS.Add_To_Attr('ACTION_TAKEN_FLAG', action_taken_flag_, attr_);
   Client_SYS.Add_To_Attr('STOP_FLAG', stop_flag_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Get_Next_Event
--   Return the next event to be executed in the order flow for an order of
--   the specified order type given the previous event.
--   Return NULL if a stop has been defined after the previous event if the 
--   customer order line is not created from rental transfer
@UncheckedAccess
FUNCTION Get_Next_Event (
   order_id_           IN VARCHAR2,
   event_              IN NUMBER,
   rental_transfer_db_ IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS
   dummy_      NUMBER;
   next_event_ CUST_ORDER_TYPE_EVENT_TAB.event%TYPE;

   CURSOR get_stop_flag IS
      SELECT 1
      FROM   CUST_ORDER_TYPE_EVENT_TAB
      WHERE  order_id = order_id_
      AND    event = event_
      AND    stop_flag = 'N';

   CURSOR get_next_event IS
      SELECT event
      FROM   CUST_ORDER_TYPE_EVENT_TAB
      WHERE  order_id = order_id_
      AND    event > event_
      ORDER BY event;
BEGIN
   -- Check if a stop should be made after the specified event if a line is not created from rental transfer
   IF (NVL(rental_transfer_db_, 'FALSE') = 'FALSE') THEN
      OPEN get_stop_flag;
      FETCH get_stop_flag INTO dummy_;
      IF (get_stop_flag%NOTFOUND) THEN
         CLOSE get_stop_flag;
         RETURN NULL;
      END IF;
      CLOSE get_stop_flag;
   END IF;
   -- Retrieve the next event to be executed for the specified ordertype and event
   OPEN get_next_event;
   FETCH get_next_event INTO next_event_;
   IF (get_next_event%NOTFOUND) THEN
      CLOSE get_next_event;
      RETURN NULL;
   END IF;
   CLOSE get_next_event;
   RETURN next_event_;
END Get_Next_Event;



