-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentTypeEvent
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210126  RoJalk   SC2020R1-11621, Modify_Qty_Picked, Modify_Qty_To_Ship, Modify_On_Undo_Delivery, Modify_Connected_Qty_By_Source, 
--  210126           Modify_Qty_Assigned_By_Source to call New___, Modify___ instead of Unpack methods.
--  170317  Jhalse   LIM-10113, Removed Check_Insert__ as we now allow automatic pick flow.
--  160729  MaIklk   LIM-8057, Made Insert_Lu_Data_Rec as public since this will be accessed from Order.
--  151014  MaRalk   LIM-3836, Moved to the shpmnt module from order module in order to support
--  151014           generic shipment functionality.
--  150611  JaBalk   RED-484, Modified Get_Next_Event to handle NVL of variable rental_transfer_db_.
--  150605  JaBalk   RED-361, Modified Get_Next_Event to by pass the stop of event for rental transfer.
--  131112  RoJalk   Hooks implementation - Refactor file.
--  130813  MeAblk   Added new method Insert_Lu_Data_Rec__ to insert basic data of default shipment types. 
--  120817  MeAblk   Modified the error message NO_SHIPMENT_INV.
--  120702  MeAblk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     shipment_type_event_tab%ROWTYPE,
   newrec_ IN OUT shipment_type_event_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Modify_Shipment_Stop__
--   Update the stop flag for an instance.
PROCEDURE Modify_Shipment_Stop__ (
   shipment_type_ IN VARCHAR2,
   event_         IN NUMBER,
   stop_flag_     IN VARCHAR2 )
IS
   newrec_     SHIPMENT_TYPE_EVENT_TAB%ROWTYPE;
BEGIN
   newrec_           := Lock_By_Keys___ (shipment_type_, event_);
   newrec_.stop_flag := Fnd_Boolean_API.Encode(stop_flag_);
   Modify___(newrec_);
END Modify_Shipment_Stop__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Inserts new events when entering a new  type
PROCEDURE New (
   shipment_type_ IN VARCHAR2,
   event_         IN NUMBER,
   stop_flag_     IN VARCHAR2 )
IS
   newrec_     SHIPMENT_TYPE_EVENT_TAB%ROWTYPE;
BEGIN
   newrec_.shipment_type := shipment_type_;
   newrec_.event         := event_;
   newrec_.stop_flag     := Fnd_Boolean_API.Encode(stop_flag_);
   New___(newrec_);
END New;


-- Get_Next_Event
--   Return the next event to be executed in the order flow for a shipment of
--   the specified shipment type given the previous event.
--   Return NULL if a stop has been defined after the previous event if the 
--   customer order line is not created from rental transfer
@UncheckedAccess
FUNCTION Get_Next_Event (
   shipment_type_      IN VARCHAR2,
   event_              IN NUMBER,
   rental_transfer_db_ IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS
   dummy_      NUMBER;
   next_event_ SHIPMENT_TYPE_EVENT_TAB.event%TYPE;

   CURSOR get_stop_flag IS
      SELECT 1
      FROM   SHIPMENT_TYPE_EVENT_TAB
      WHERE  shipment_type = shipment_type_
      AND    event = event_
      AND    stop_flag = 'FALSE';

   CURSOR get_next_event IS
      SELECT event
      FROM   SHIPMENT_TYPE_EVENT_TAB
      WHERE  shipment_type = shipment_type_
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
   -- Retrieve the next event to be executed for the specified shipment type and event
   OPEN get_next_event;
   FETCH get_next_event INTO next_event_;
   IF (get_next_event%NOTFOUND) THEN
      CLOSE get_next_event;
      RETURN NULL;
   END IF;
   CLOSE get_next_event;
   RETURN next_event_;
END Get_Next_Event;

PROCEDURE Insert_Lu_Data_Rec (
   newrec_        IN SHIPMENT_TYPE_EVENT_TAB%ROWTYPE)
IS
   dummy_ NUMBER;
   CURSOR Exist IS
      SELECT 1 
      FROM SHIPMENT_TYPE_EVENT_TAB
      WHERE shipment_type = newrec_.shipment_type
      AND   event         = newrec_.event;
BEGIN

   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO SHIPMENT_TYPE_EVENT_TAB (
            shipment_type,
            event,
            stop_flag,
            rowversion)
         VALUES (
            newrec_.shipment_type,
            newrec_.event,
            newrec_.stop_flag,
            newrec_.rowversion);      
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec;    
