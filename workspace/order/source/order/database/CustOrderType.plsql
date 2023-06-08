-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderType
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150324  JeLise   COB-173, Added new attribute allow_partial_picking.
--  120525  JeLise   Made description private.
--  120508  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120508           in Insert___, Update___, Delete___, Insert_Lu_Data_Rec__, Get_Description, Get and in the views. 
--  100519  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  080919  KiSalk Processing on newrec_.oe_alloc_assign_flag in Update___ set to be done if the value changed.
--  080919  KiSalk Made online_processing compatible with model and added Get_Online_Processing_Db.
--  080325  RiLase Added attribute online_processing.
-- ----------------- Nice Price ----------------------
--  070220  NaLrlk Added the method Get_Pick_Inventory_Type_Db.
--  060112  IsWilk Modified the PROCEDURE Insert__ according to template 2.3.
--  050921  NaLrlk Removed unused variables.
--  041230  IsAnlk Removed consignment functionality from customer orders.
--  040224  IsWilk Removed SUBSTRB from the view and modified the SUBSTRB to SUBSTR for Unicode Changes.
-- -----------------EDGE Package Group 3 Unicode Changes----------------------
--  030926  ThGu   Changed substr to substrb, instr to instrb, length to lengthb.
--  020829  ARAM   Added LOV view CUST_ORDER_TYPE_LOV.
--  ------  ----   ----------------Take Off------------------------------------
--  020124  StDa   IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  001229  FBen   Changed oe_alloc_assign_flag to Priority Reservations and order id to order type in view.
--  ------  ----   -----------------------------------------------------------
--  000712  GBO    Merged from Chameleon
--                 Removed planned_order from public rec
--                 Removed function Get_Planned_Order
-- ------------------------------- 12.10 -------------------------------------
--  990407  JakH   New template.
--  980527  JOHW   Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  980216  JoAn   Added New method
--  980130  RaKu   Added Order_Consignment_Creation column and logic.
--  971127  RaKu   Made changes to match Design.
--  971125  TOOS   Upgrade to F1 2.0
--  970605  RaKu   Changed checks on insert/update of events.
--  970526  JoAn   Priority reservations not allowed for order started as quotation.
--  970522  JOED   Added _db columns for all IID columns in the view.
--                 Rebuild the Get_... methods using Get_Instance___.
--  970509  JoAn   Added method Get_Control_Type_Value_Desc
--  970430  JOED   Changed IID on planned_order.
--  970319  RaKu   Changed name from report_inventory_type to pick_inventory_type.
--  970312  RaKu   Changed tablename.
--  970305  RaKu   Added column report_inventory_type and all default handling.
--                 Added function Get_Report_Inventory_Type.
--  970219  PAZE   Changed rowversion (10.3 Project).
--  960212  SVLO   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('OE_ALLOC_ASSIGN_FLAG_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('PICK_INVENTORY_TYPE_DB', 'SHIPINV', attr_);
   Client_SYS.Add_To_Attr('ALLOW_PARTIAL_PICKING_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_TYPE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_event IS
      SELECT event
      FROM CUST_ORDER_EVENT;
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   FOR eventrec_ IN get_event LOOP
      Cust_Order_Type_Event_API.New(newrec_.order_id,
                                    eventrec_.event,
                                    Perform_Order_Type_Event_API.Decode('Y'),
                                    Order_Type_Event_Stop_API.Decode('Y'));
   END LOOP;

   IF newrec_.oe_alloc_assign_flag = 'Y' THEN
      -- Priority reservation
      -- Set action_taken_flag = 'Do not perform event'
      Cust_Order_Type_Event_API.Modify_Action_Taken__(newrec_.order_id, 60,
                                                      Perform_Order_Type_Event_API.Decode('N'));
   END IF;
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUST_ORDER_TYPE_TAB%ROWTYPE,
   newrec_     IN OUT CUST_ORDER_TYPE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.pick_inventory_type != 'SHIPINV') THEN
      IF (newrec_.allow_partial_picking = Fnd_Boolean_API.DB_TRUE) THEN
         newrec_.allow_partial_picking := Fnd_Boolean_API.DB_FALSE;
      END IF;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (newrec_.oe_alloc_assign_flag != oldrec_.oe_alloc_assign_flag) THEN
      IF newrec_.oe_alloc_assign_flag = 'Y' THEN
         -- Priority reservation
         -- Set action_taken_flag = 'Do not perform event'
         Cust_Order_Type_Event_API.Modify_Action_Taken__
           (newrec_.order_id, 60, Perform_Order_Type_Event_API.Decode('N'));
      ELSE
         -- Normal reservation
         -- Force stop after 'PRINT ORDER CONFIRMATION' (event 40)
         Cust_Order_Type_Event_API.Modify_Order_Stop__
           (newrec_.order_id, 40, Order_Type_Event_Stop_API.Decode('Y'));
         -- Set action_taken_flag = 'Perform event'
         Cust_Order_Type_Event_API.Modify_Action_Taken__
           (newrec_.order_id, 60, Perform_Order_Type_Event_API.Decode('Y'));
      END IF;
   END IF;
   IF newrec_.pick_inventory_type = 'SHIPINV' THEN
      -- Shipment inventory
      -- Force stop after 'PRINT PICK LIST' (event 80)
      Cust_Order_Type_Event_API.Modify_Order_Stop__
        (newrec_.order_id, 80, Order_Type_Event_Stop_API.Decode('Y'));
   END IF;
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN CUST_ORDER_TYPE_TAB%ROWTYPE)
IS
   dummy_ VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM CUST_ORDER_TYPE_TAB
      WHERE order_id = newrec_.order_id;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO CUST_ORDER_TYPE_TAB (
            order_id,
            description,
            online_processing,
            oe_alloc_assign_flag,
            pick_inventory_type,
            allow_partial_picking,
            rowversion)
         VALUES (
            newrec_.order_id,
            newrec_.description,
            newrec_.online_processing,
            newrec_.oe_alloc_assign_flag,
            newrec_.pick_inventory_type,
            newrec_.allow_partial_picking,
            newrec_.rowversion);
   ELSE
      UPDATE CUST_ORDER_TYPE_TAB
         SET description = newrec_.description
       WHERE order_id = newrec_.order_id;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                      'CustOrderType',
                                                      newrec_.order_id,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   order_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ cust_order_type_tab.description%TYPE;
BEGIN
   IF (order_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'CustOrderType', order_id_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   cust_order_type_tab
   WHERE  order_id = order_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(order_id_, 'Get_Description');
END Get_Description;

-- Get_Control_Type_Value_Desc
--   Used by accounting
--   Retreive the control type description used in accounting
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


-- New
--   Public interface used to create a new order type.
--   Public New procedure for creating a new order type. Will also create
--   new records in CustOrderTypeEvent.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   ptr_         NUMBER;
   name_        VARCHAR2(30);
   value_       VARCHAR2(2000);
   new_attr_    VARCHAR2(2000);
   newrec_      CUST_ORDER_TYPE_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Clear_Info;
   -- Retrieve the default attribute values
   Prepare_Insert___(new_attr_);

   -- Replace the default attribute values with the ones passed in the in parameter string
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);

   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;



