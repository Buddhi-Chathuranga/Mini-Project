-----------------------------------------------------------------------------
--
--  Logical unit: HuSnapshotForRefresh
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211118  DaZase  SC21R2-5917, Added override Insert___ to handle new column snapshot_generated, added keep_snapshot_reference_ as default parameter in 
--  211118          Refresh_Snapshots plus added new functionality in that method to support the new parameter and the new column so that we only Modify 
--  211118          the record instead of delete it in certain cases, this is to avoid unnecessary duplicate refreshes. 
--  180919  Asawlk   Bug 143092, Modified Remove_Old_Records___() and Refresh_Snapshots() to lock the recods before delete and also replaced the call to Remove___() with
--  180919           a call to Delete___(). Made a call to Remove_Old_Records___() inside Refresh_Snapshots(). If in future Check_Delete___() is overriden or overtaken 
--  180919           then it should be called from Refresh_Snapshots() and Remove_Old_Records___(), immediately before calling Delete___().   
--  170703  Chfose  STRSC-8920, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


PROCEDURE Remove_Old_Records___
IS
   CURSOR get_old_records IS
      SELECT *
        FROM HU_SNAPSHOT_FOR_REFRESH_TAB
       WHERE date_time_created < sysdate - 1
       FOR UPDATE;
BEGIN
   -- In case records have been left in the table because of a job having partial commits ending with an error
   -- we need to do a cleanup, just to be safe. Normally this cursor should not find any records.
   FOR remrec_ IN get_old_records LOOP
      Delete___(remrec_);
   END LOOP;
END Remove_Old_Records___;


PROCEDURE Generate_Snapshot___ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
BEGIN
   CASE source_ref_type_db_
      WHEN Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK THEN   
         Transport_Task_Handl_Unit_API.Generate_Aggr_Handl_Unit_View(transport_task_id_ => source_ref1_);
       
      WHEN Handl_Unit_Snapshot_Type_API.DB_COUNTING_REPORT THEN
         Counting_Report_Handl_Unit_API.Generate_Aggr_Handl_Unit_View(inv_list_no_ => source_ref1_);
        
      WHEN Handl_Unit_Snapshot_Type_API.DB_SHOP_ORD_PICK_LIST THEN
         $IF (Component_Shpord_SYS.INSTALLED) $THEN 
            Shop_Material_Pick_Util_API.Generate_Pick_List_Hu_Snapshot(pick_list_no_ => source_ref1_);
         $ELSE
            Error_SYS.Component_Not_Exist('SHPORD');
         $END
         
      WHEN Handl_Unit_Snapshot_Type_API.DB_PICK_LIST THEN
        $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
            Pick_Shipment_API.Generate_Handl_Unit_Snapshot(pick_list_no_ => source_ref1_);
         $ELSE
            Error_SYS.Component_Not_Exist('SHPMNT');
        $END
      
      ELSE
        Error_SYS.Record_General(lu_name_,'This snapshot type does not have any implementation in the HuSnapshotForRefresh entity.');
   END CASE;
END Generate_Snapshot___;


PROCEDURE New___(
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   inventory_event_id_  IN NUMBER DEFAULT NULL)
IS
   newrec_                      HU_SNAPSHOT_FOR_REFRESH_TAB%ROWTYPE;
   local_inventory_event_id_    NUMBER;
BEGIN
   -- Fallback to the inventory event id created for the session if none was sent into the method.
   local_inventory_event_id_ := NVL(inventory_event_id_, Inventory_Event_Manager_API.Get_Session_Id);
   
   IF (local_inventory_event_id_ IS NULL) THEN
      -- Since the insert is not done in context of a inventory event then we need to trigger the handling unit snapshot generation immediately
      Generate_Snapshot___(source_ref1_         => source_ref1_, 
                           source_ref2_         => source_ref2_, 
                           source_ref3_         => source_ref3_, 
                           source_ref4_         => source_ref4_, 
                           source_ref5_         => source_ref5_, 
                           source_ref_type_db_  => source_ref_type_db_);
                           
   ELSIF (NOT Check_Exist___(source_ref1_           => source_ref1_,
                             source_ref2_           => source_ref2_,
                             source_ref3_           => source_ref3_,
                             source_ref4_           => source_ref4_,
                             source_ref5_           => source_ref5_,
                             source_ref_type_db_    => source_ref_type_db_, 
                             inventory_event_id_    => local_inventory_event_id_)) THEN
      -- Since the insert is done in context of a inventory event then we just need to log this snapshot for later processing 
      -- in method Inventory_Event_Manager_API.Finish(). This means that the refresh is done just once per snaphot and user action.
      newrec_.source_ref1           := source_ref1_;
      newrec_.source_ref2           := source_ref2_;
      newrec_.source_ref3           := source_ref3_;
      newrec_.source_ref4           := source_ref4_;
      newrec_.source_ref5           := source_ref5_;
      newrec_.source_ref_type       := source_ref_type_db_;
      newrec_.inventory_event_id    := local_inventory_event_id_;
      newrec_.date_time_created     := sysdate;
      New___(newrec_);
   END IF;
END New___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT hu_snapshot_for_refresh_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS

BEGIN
   newrec_.snapshot_generated := Fnd_Boolean_API.DB_FALSE;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE New (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   inventory_event_id_  IN NUMBER DEFAULT NULL )
IS
BEGIN
   New___(source_ref1_         => source_ref1_,
          source_ref2_         => '*',
          source_ref3_         => '*',
          source_ref4_         => '*',
          source_ref5_         => '*',
          source_ref_type_db_  => source_ref_type_db_,
          inventory_event_id_  => inventory_event_id_);
END New;


PROCEDURE New (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref5_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   inventory_event_id_  IN NUMBER DEFAULT NULL )
IS
BEGIN
   New___(source_ref1_         => source_ref1_,
          source_ref2_         => source_ref2_,
          source_ref3_         => source_ref3_,
          source_ref4_         => source_ref4_,
          source_ref5_         => source_ref5_,
          source_ref_type_db_  => source_ref_type_db_,
          inventory_event_id_  => inventory_event_id_);
END New;


PROCEDURE Refresh_Snapshots (
   inventory_event_id_      IN NUMBER,
   keep_snapshot_reference_ IN BOOLEAN DEFAULT FALSE  )
IS
   CURSOR get_snapshots IS
     SELECT *
       FROM HU_SNAPSHOT_FOR_REFRESH_TAB
      WHERE inventory_event_id = inventory_event_id_
        FOR UPDATE;
BEGIN
   FOR rec_ IN get_snapshots LOOP
      IF (rec_.snapshot_generated = Fnd_Boolean_API.DB_FALSE) THEN
         Generate_Snapshot___(source_ref1_         => rec_.source_ref1,
                              source_ref2_         => rec_.source_ref2,
                              source_ref3_         => rec_.source_ref3,
                              source_ref4_         => rec_.source_ref4,
                              source_ref5_         => rec_.source_ref5, 
                              source_ref_type_db_  => rec_.source_ref_type);
      END IF;
      IF (keep_snapshot_reference_) THEN
         rec_.snapshot_generated := Fnd_Boolean_API.DB_TRUE;
         Modify___(rec_);
      ELSE
         Delete___(rec_);
      END IF;
   END LOOP;
   Remove_Old_Records___;
END Refresh_Snapshots;

