-----------------------------------------------------------------------------
--
--  Logical unit: PutawayToEmptyEvent
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160518  LEPESE  LIM-7363, added call to Handling_Unit_For_Refresh_API.Refresh_Handl_Unit_Snapshots from Remove_Putaway_Event.
--  160511  LEPESE  LIM-7363, added call to Transp_Task_For_Hu_Refresh_API.Refresh_Handl_Unit_Snapshots from Remove_Putaway_Event.
--  140919  LEPESE  PRSC-2518, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT putaway_to_empty_event_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.date_time_started := Site_API.Get_Site_Date(newrec_.contract);
   super(objid_, objversion_, newrec_, attr_);
   --Add post-processing code here
END Insert___;

   
PROCEDURE Remove_Old_Site_Records___ (
   contract_ IN VARCHAR2 )
IS
   yesterday_ DATE;
   
   CURSOR get_old_site_records IS
      SELECT *
        FROM putaway_to_empty_event_tab
       WHERE contract = contract_
         AND date_time_started < yesterday_;
BEGIN
   -- In case records have been left in the table because of the putaway job ending with an error
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
   warehouse_id_       IN VARCHAR2,
   bay_id_             IN VARCHAR2,
   tier_id_            IN VARCHAR2,
   row_id_             IN VARCHAR2,
   bin_id_             IN VARCHAR2,
   inventory_event_id_ IN NUMBER )
IS
   newrec_ putaway_to_empty_event_tab%ROWTYPE;
BEGIN
   newrec_.contract           := contract_;
   newrec_.warehouse_id       := warehouse_id_;
   newrec_.bay_id             := bay_id_;
   newrec_.tier_id            := tier_id_;
   newrec_.row_id             := row_id_;
   newrec_.bin_id             := bin_id_;
   newrec_.inventory_event_id := inventory_event_id_;
   New___(newrec_);
END New;

   
PROCEDURE Remove_Putaway_Event (
   inventory_event_id_ IN NUMBER )
IS
   contract_ putaway_to_empty_event_tab.contract%TYPE;
   
   CURSOR get_event_records IS
      SELECT *
      FROM putaway_to_empty_event_tab
      WHERE inventory_event_id = inventory_event_id_;        
BEGIN
   FOR remrec_ IN get_event_records LOOP
      IF (contract_ IS NULL) THEN
         contract_ := remrec_.contract;
      END IF;      
      Remove___(remrec_);
   END LOOP;
   Remove_Old_Site_Records___(contract_);
END Remove_Putaway_Event;
