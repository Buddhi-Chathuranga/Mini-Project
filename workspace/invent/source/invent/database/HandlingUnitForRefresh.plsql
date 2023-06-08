-----------------------------------------------------------------------------
--
--  Logical unit: HandlingUnitForRefresh
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170703  Chfose  STRSC-8920, Added support for ShopOrderPickList as source in Refresh_Handl_Unit_Snapshots__.
--  170505  LEPESE  STRSC-6689, Replaced calls to Remove___ with calls to Delete___ in order to skip
--  170505          the restricted delete check for increased performance.
--  160720  Chfose  LIM-7517, Added support for Pick List as source in Refresh_Handl_Unit_Snapshots__
--  160629  Jhalse  LIM-7520, Added method calls for Add_Reports_To_Hu_Refresh_List and Refresh_Handl_Unit_Snapshots.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160519  LEPESE  LIM-7363, fetching root_handling_unit_id_ in method New.
--  160518  LEPESE  LIM-7363, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Remove_Old_Records___ 
IS
   CURSOR get_old_records IS
      SELECT *
        FROM handling_unit_for_refresh_tab
       WHERE date_time_created < sysdate - 1
       FOR UPDATE;
BEGIN
   -- In case records have been left in the table because of a job having partial commits ending with an error
   -- we need to do a cleanup, just to be safe. Normally this cursor should not find any records.
   FOR remrec_ IN get_old_records LOOP
      Delete___(remrec_);
   END LOOP;
END Remove_Old_Records___;


FUNCTION Inventory_Event_Id_Exist___ (
   inventory_event_id_  IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   
   CURSOR inventory_event_id_exist IS
      SELECT 1
        FROM HANDLING_UNIT_FOR_REFRESH_TAB
       WHERE inventory_event_id = inventory_event_id_;
BEGIN
   OPEN inventory_event_id_exist;
   FETCH inventory_event_id_exist INTO dummy_;
   IF (inventory_event_id_exist%NOTFOUND) THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;
END Inventory_Event_Id_Exist___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Refresh_Handl_Unit_Snapshots__ (
   attr_ IN VARCHAR2 )
IS
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   inventory_event_id_     NUMBER;
   stock_keys_and_qty_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   root_handling_unit_id_  handling_unit_for_refresh_tab.handling_unit_id%TYPE;

   CURSOR get_handling_units IS
      SELECT *
      FROM handling_unit_for_refresh_tab
      WHERE inventory_event_id = inventory_event_id_
      FOR UPDATE;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INVENTORY_EVENT_ID') THEN
         inventory_event_id_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   
   FOR rec_ IN get_handling_units LOOP
      root_handling_unit_id_  := Handling_Unit_API.Get_Root_Handling_Unit_Id(rec_.handling_unit_id);
      stock_keys_and_qty_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(root_handling_unit_id_);

      -- Here we should also add calls for other snapshot source types like CO reservation, pick list, shipment
      Transport_Task_Line_API.Add_Tasks_To_Hu_Refresh_List(stock_keys_and_qty_tab_, inventory_event_id_);
      Counting_Report_Line_API.Add_Reports_To_Hu_Refresh_List(stock_keys_and_qty_tab_, inventory_event_id_);
      $IF Component_Shpmnt_SYS.INSTALLED $THEN
         Pick_Shipment_API.Add_Pick_Lists_To_Hu_Refr_List(stock_keys_and_qty_tab_, inventory_event_id_);      
      $END
      $IF Component_Shpord_SYS.INSTALLED $THEN
        Shop_Material_Pick_Util_API.Add_Pick_Lists_To_Hu_Refr_List(stock_keys_and_qty_tab_, inventory_event_id_);
      $END
      
      Delete___(rec_);
   END LOOP;
   
   Remove_Old_Records___;
   Hu_Snapshot_For_Refresh_API.Refresh_Snapshots(inventory_event_id_);
END Refresh_Handl_Unit_Snapshots__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   handling_unit_id_   IN NUMBER )
IS
   newrec_                      handling_unit_for_refresh_tab%ROWTYPE;
   root_handling_unit_id_       handling_unit_for_refresh_tab.handling_unit_id%TYPE;
   local_inventory_event_id_    NUMBER;
BEGIN
   Inventory_Event_Manager_API.Start_Session(local_inventory_event_id_);
   local_inventory_event_id_ := Inventory_Event_Manager_API.Get_Session_Id;
   root_handling_unit_id_    := Handling_Unit_API.Get_Root_Handling_Unit_Id(handling_unit_id_);

   IF NOT (Check_Exist___(local_inventory_event_id_, root_handling_unit_id_)) THEN 
      newrec_.inventory_event_id    := local_inventory_event_id_;
      newrec_.handling_unit_id      := root_handling_unit_id_;
      newrec_.date_time_created     := sysdate;
      New___(newrec_);
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
END New;


PROCEDURE Refresh_Handl_Unit_Snapshots (
   inventory_event_id_ IN NUMBER )
IS
   attr_                        VARCHAR2(2000);
   batch_desc_                  VARCHAR2(500);
BEGIN
   -- Only create the background job if there are any handling units to refresh.
   IF (Inventory_Event_Id_Exist___(inventory_event_id_)) THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('INVENTORY_EVENT_ID', inventory_event_id_, attr_);

      batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'REFHUSNAP: Refresh Handling Unit Snapshots for Inventory Event ID :P1 ', p1_ => inventory_event_id_);
      Transaction_SYS.Deferred_Call('Handling_Unit_For_Refresh_API.Refresh_Handl_Unit_Snapshots__', attr_, batch_desc_);
   END IF;
END Refresh_Handl_Unit_Snapshots;

