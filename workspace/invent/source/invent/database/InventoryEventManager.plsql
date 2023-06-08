-----------------------------------------------------------------------------
--
--  Logical unit: InventoryEventManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211118  DaZase  SC21R2-5917, Added keep_snapshot_reference_ as a TRUE parameter in call to Hu_Snapshot_For_Refresh_API.Refresh_Snapshots in Finish___.
--  170703  Chfose  STRSC-8920, Added methods Create_Session, Get_Session_Id & Finish_Session for handling the inventory_event_id internally.
--  160720  Chfose  LIM-7517, Added method call for Pick_List_For_Hu_Refresh_API.Refresh_Handl_Unit_Snapshots.
--  160629  Jhalse  LIM-7520, Added method call for Count_Repo_For_Hu_Refresh_API.Refresh_Handl_Unit_Snapshots.
--  160520  LEPESE  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

inventory_event_session_id_       CONSTANT VARCHAR2(35) := 'INVENTORY_EVENT_SESSION_ID';
inventory_event_session_refcount_ CONSTANT VARCHAR2(35) := 'INVENTORY_EVENT_SESSION_REFCOUNT';

number_null_                      CONSTANT NUMBER := NULL;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


PROCEDURE Finish___ (
   inventory_event_id_ IN NUMBER )
IS
BEGIN
   Putaway_To_Empty_Event_API.Remove_Putaway_Event(inventory_event_id_);
   
   -- This will trigger the refresh of snapshots where we have captured changes on individual source objects and need to refresh those specific sourcec objects.
   -- This will be run online since the refresh needs to be immediate.
   Hu_Snapshot_For_Refresh_API.Refresh_Snapshots(inventory_event_id_, keep_snapshot_reference_ => TRUE);
   
   -- This will trigger the refresh of snapshots where we have captured general changes of qty_onhand for any handling unit. This will be run in a background job
   -- since it could disturbe the performance of the online processes and there is no need to have the result immediately.
   Handling_Unit_For_Refresh_API.Refresh_Handl_Unit_Snapshots(inventory_event_id_);      
END Finish___;


PROCEDURE Start_Session___ (
   inventory_event_id_ IN NUMBER )
IS
   reference_count_             NUMBER;
   session_inventory_event_id_  NUMBER;
BEGIN   
   -- Only create a new session inventory event id if there isn't already one.
   IF (inventory_event_id_ IS NULL) THEN
      session_inventory_event_id_ := Get_Next_Inventory_Event_Id;
      App_Context_SYS.Set_Value(inventory_event_session_id_, session_inventory_event_id_);
      App_Context_SYS.Set_Value(inventory_event_session_refcount_, 1);
      Trace_SYS.Message('Inventory_Event_Manager: Session Started - ' || session_inventory_event_id_);
   ELSE
      reference_count_ := App_Context_SYS.Find_Value(inventory_event_session_refcount_, 0);
      reference_count_ := reference_count_ + 1;
      App_Context_SYS.Set_Value(inventory_event_session_refcount_, reference_count_);
   END IF;
END Start_Session___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Next_Inventory_Event_Id RETURN NUMBER
IS
   next_inventory_event_id_ NUMBER;
   
   CURSOR get_next_inventory_event_id IS
      SELECT INVENTORY_EVENT_ID_SEQ.nextval
      FROM dual;
BEGIN
   OPEN get_next_inventory_event_id;
   FETCH get_next_inventory_event_id INTO next_inventory_event_id_;
   CLOSE get_next_inventory_event_id;

   RETURN (next_inventory_event_id_);
END Get_Next_Inventory_Event_Id;


PROCEDURE Finish (
   inventory_event_id_ IN NUMBER )
IS
BEGIN
   Finish___(inventory_event_id_);     
END Finish;


-- An inventory event session keeps track of the inventory event id internally to 
-- avoid having to send the inventory event id through the business logic. 
-- A session is started by calling Start_Session and ended with Finish_Session. 
-- NOTE: If there has been multiple calls to Start_Session without calling Finish_Session the session
-- will not end until Finish_Session has been called as many times as Start_Session.
PROCEDURE Start_Session (
   inventory_event_id_  IN NUMBER DEFAULT NULL )
IS
   session_inventory_event_id_  NUMBER;
BEGIN
   session_inventory_event_id_ := App_Context_SYS.Find_Value(inventory_event_session_id_, NULL);
   Start_Session___(NVL(session_inventory_event_id_, inventory_event_id_));
END Start_Session;


FUNCTION Get_Session_Id RETURN NUMBER
IS
BEGIN
   RETURN App_Context_SYS.Find_Value(inventory_event_session_id_, NULL);
END Get_Session_Id;


PROCEDURE Set_Session_Id (
   inventory_event_id_ IN NUMBER )
IS
BEGIN
   App_Context_SYS.Set_Value(inventory_event_session_id_, NVL(inventory_event_id_, Get_Next_Inventory_Event_Id));
   App_Context_SYS.Set_Value(inventory_event_session_refcount_, 1);
END Set_Session_Id;


PROCEDURE Clear_Session
IS
BEGIN
   App_Context_SYS.Set_Value(inventory_event_session_id_, number_null_);
   App_Context_SYS.Set_Value(inventory_event_session_refcount_, 0);
END Clear_Session;


PROCEDURE Finish_Session
IS
   session_inventory_event_id_  NUMBER;
   reference_count_             NUMBER;
BEGIN
   session_inventory_event_id_ := App_Context_SYS.Find_Value(inventory_event_session_id_, NULL);
   
   IF (session_inventory_event_id_ IS NOT NULL) THEN
      reference_count_ := App_Context_SYS.Find_Value(inventory_event_session_refcount_, 0);
      reference_count_ := reference_count_ - 1;
      App_Context_SYS.Set_Value(inventory_event_session_refcount_, reference_count_);
      
      -- Only finish the session inventory event id when called from the last reference (reference_count = 0).
      IF (reference_count_ <= 0) THEN
         App_Context_SYS.Set_Value(inventory_event_session_id_, number_null_);
         Trace_SYS.Message('Inventory_Event_Manager: Session Ended - ' || session_inventory_event_id_);
         Finish___(session_inventory_event_id_);
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'No inventory event session is active. Inventory_Event_Manager_API.Start_Session must be called before Finish_Session.');
   END IF;
END Finish_Session;

