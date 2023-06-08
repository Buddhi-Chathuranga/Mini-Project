-----------------------------------------------------------------------------
--
--  Logical unit: RemoteWhseRefillEvent
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  140320  LEPESE  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT remote_whse_refill_event_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.date_time_started := Site_API.Get_Site_Date(newrec_.contract);
   super(objid_, objversion_, newrec_, attr_);
   --Add post-processing code here
END Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     remote_whse_refill_event_tab%ROWTYPE,
   newrec_ IN OUT remote_whse_refill_event_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (Warehouse_API.Is_Remote(newrec_.contract, newrec_.warehouse_id) = Fnd_Boolean_API.DB_FALSE) THEN
      Error_SYS.Record_General(lu_name_, 'WHSENOTREMOTE: Warehouse :P1 on Site :P2 is not indicated as being a remote warehouse.', newrec_.warehouse_id, newrec_.contract);
   END IF;
END Check_Common___;

PROCEDURE Remove_Old_Site_Records___ (
   contract_ IN VARCHAR2 )
IS
   yesterday_ DATE;
   
   CURSOR get_old_site_records IS
      SELECT *
      FROM remote_whse_refill_event_tab
      WHERE contract = contract_
        AND date_time_started < yesterday_;
BEGIN
   -- In case records have been left in the table because of the refill job ending with an error (it has server commits)
   -- we need to do a cleanup, just to be safe. Normally this cursor should not find any records.
   yesterday_ := Site_API.Get_Site_Date(contract_) - 1;
   FOR remrec_ IN get_old_site_records LOOP
      Remove___(remrec_);
   END LOOP;
END Remove_Old_Site_Records___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   warehouse_id_       IN VARCHAR2,
   inventory_event_id_ IN NUMBER )
IS
   newrec_ remote_whse_refill_event_tab%ROWTYPE;
BEGIN
   IF NOT (Check_Exist___(contract_, part_no_, warehouse_id_, inventory_event_id_)) THEN
      newrec_.contract           := contract_;
      newrec_.part_no            := part_no_;
      newrec_.warehouse_id       := warehouse_id_;
      newrec_.inventory_event_id := inventory_event_id_;
      New___(newrec_);
   END IF;   
END New;

PROCEDURE Remove_Part_Event (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   inventory_event_id_ IN NUMBER )
IS
   CURSOR get_warehouse_records IS
      SELECT *
      FROM remote_whse_refill_event_tab
      WHERE contract           = contract_
        AND part_no            = part_no_
        AND inventory_event_id = inventory_event_id_;        
BEGIN
   FOR remrec_ IN get_warehouse_records LOOP
      Remove___(remrec_);
   END LOOP;
   Remove_Old_Site_Records___(contract_);
END Remove_Part_Event;

PROCEDURE Remove_Part_Warehouse (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 )
IS
   CURSOR get_event_records IS
      SELECT *
      FROM remote_whse_refill_event_tab
      WHERE contract         = contract_
        AND part_no          = part_no_
        AND warehouse_id     = warehouse_id_;
BEGIN
   FOR remrec_ IN get_event_records LOOP
      Remove___(remrec_);
   END LOOP;
   Remove_Old_Site_Records___(contract_);
END Remove_Part_Warehouse;

FUNCTION Refill_Is_In_Progress (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_                 NUMBER;
   refill_is_in_progress_ BOOLEAN := FALSE;
   CURSOR exist_control IS
      SELECT 1
      FROM remote_whse_refill_event_tab
      WHERE contract     = contract_
        AND part_no      = part_no_
        AND warehouse_id = warehouse_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      refill_is_in_progress_ := TRUE;
   END IF;
   CLOSE exist_control;
   RETURN(refill_is_in_progress_);
   END Refill_Is_In_Progress;