-----------------------------------------------------------------------------
--
--  Logical unit: TransportTask
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210930  JaThlk  Bug 160596 (SC21R2-2990), Added the method Get_Intra_Warehouse_Move_Qty() to get the quantity reserved for intra warehouse move.
--  210215  SBalLK  Bug 158070(SCZ-13404), Modified cursor in Inbound_Task_Exist() method to consider forward location when validate for inbound transport tasks.
--  201005  Asawlk  SC2021R1-318, order type WORK_ORDER references are replaced with order type WORK_TASK.
--  200114  SBalLK  Bug 151810(SCZ-8466), Added Execute__(), Execute_Online_Or_Deferred___() and Validate_Transport_Status___() method and removed Execute___() method with
--  200114          moving logic to new Execute__() method. Modified Execute_All() and Execute_Picked() method to execute transport task online or background accordingly.
--  191221  SBalLK  Bug 151508(SCZ-7902), Added Execute() method and modified Execute_All() method to make transport task execute in background according to the
--  191221          settings in Site, Invent, Transport task window.
--  180406  SBalLK  Bug 141183, Modified Get_No_Of_Unidentified_Serials() method by removing NVL() on quantity column which is mandatory in TRANSPORT_TASK_LINE_TAB.
--  180302  LEPESE  STRSC-16317, Modification in Get_Booked_Storage_Capacity___ by calling Handling_Unit_API.Has_Parent_Any_Level to make sure that
--  180302          a sub-level in a HU structure can be indentified as being a child to the HU specified in ignore_this_handling_unit_id_.
--  180221  JaThlk  Bug 140182, Added default parameter include_unpicked_lines_ to method Get_Qty_Outbound().
--  180209  KHVESE  STRSC-16657, Modified method New_Or_Add_To_Existing to call to Validate_Move_Reservation with parameter calling_process_ set to new_or_add_to_transport_task_.
--  180209  LEPESE  STRSC-16027, Added method Get_Inbound_Handling_Units.
--  180103  BudKlk  Bug 139555, Modified the methods Execute___(), Increase_Qty_On_Unexecuted___(), Get_Booked_Storage_Capacity___(), Inbound_Task_Exist(), Check_Unexecuted_Tasks(),      
--  180103          Get_No_Of_Unidentified_Serials(), Other_Parts_Are_Inbound(),Any_Parts_Are_Inbound(),Remove_Unexecuted_Tasks(),Reduce_Qty_On_Unexecuted_Tasks(),
--  180103          Exist_For_Order_Reference(),Get_To_Locations() to change the cursors in order to improve the performance.
--  171206  Mwerse  STRSC-11918, Modified transport_task_id_ in New to IN OUT, Added Set_Split_By_Hu_Capacity.
--  171130  ChFolk  STRSC-14730, Modified New_Trans_Task_For_Changed_Res to set NULL value for quantity_to_add_ parameter for serial parts.
--  171026  LEPESE  STRSC-13819, Removed parameter ignore_transport_task_id_ from Any_Parts_Are_Inbound. 
--  170926  Chfose  STRSC-8922, Modified Execute___ to use new method Transport_Task_Handl_Unit_API.Execute_Handling_Unit when executing a full HU.
--  170919  Chfose  STRSC-8922, Modified Execute___ to verify that the full HU is picked when executing as a handling unit (if only_status_picked_-parameter is true).
--  170822  DAYJLK  STRSC-11598, Modified New_Or_Add_To_Existing to allow insert transport task for material requisiton reservations.
--  170802  ChFolk  STRSC-11135, Modified New_Or_Add_To_Existing to allow insert transport task for project deliverables.
--  170728  JoAnSe  STRSC-9222, Implemented changes needed for moving DOP reservations with transport task. 
--  170721  MAHPLK  STRSC-10838, Added default parameter remove_empty_transport_task_ to Reduce_Qty_On_Unexecuted_Tasks to prevent the removal of empty transport task when unreserved.
--  170713  ChFolk  STRSC-10849, Added new method New_Trans_Task_For_Changed_Res which will add or create new transport task accoridng to the change of order reservation.
--  170713          Modified Modify_Order_Pick_List to use the new method New_Trans_Task_For_Changed_Res to avoid code duplication.
--  170615  JoAnSe  LIM-11515, Changed the cursors in Increase_Qty_On_Unexecuted___ and Reduce_Qty_On_Unexecuted_Tasks to support null values.   
--  170608  JoAnSe  LIM-10663, Changes in New_Ord_Add_To_Existing to allow transport task for material reserved to a shop order.
--  170531  KHVESE  LIM-10758, Modified method New_Or_Add_To_Existing by adding parameter check_storage_requirements_ 
--  170428  UdGnlk  LIM-11443, Added Modify_Order_Pick_List() inorder to update the pick list no in transport task line.
--  170425  ChJalk  Bug 134671, Modified the method Execute___ to create a record in Report Archive if all the lines have been executed.
--  170403  KhVese  LIM-10941, Added constant mixed_value_ and modified following methods to return mixed_value_ when data is mixed.
--  170403          Get_Part_No__, Get_Configuration_Id__, Get_From_Location_No__, Get_To_Location_No__, Get_From_Warehouse_Id__, Get_From_Bay_Id__, 
--  170403          Get_From_Tier_Id__, Get_From_Row_Id__, Get_From_Bin_Id__, Get_To_Warehouse_Id__, Get_To_Bay_Id__, Get_To_Tier_Id__, Get_To_Row_Id__,
--  170403          Get_From_Bin_Id__, Get_Destination__, Get_To_Location_Group__, Get_To_Location_Type__, Get_From_Location_Type__, Get_From_Location_Group__,
--  170403          Get_Order_Ref1__, Get_Order_Ref2__, Get_Order_Ref3__, Get_Order_Ref4__, Get_Order_Type__.
--  170403          Also method Get_From_Location_Type__ modified to return client value and Get_From_Location_Group__ modified to fix bug when courser return too many records.
--  170314  UdGnlk  LIM-10871, Modified Get_Qty_Outbound() and Remove_Unexecuted_Tasks() to pass the value to reserved_by_source_db_.
--  170306  UdGnlk  LIM-10871, Modified New_Or_Add_To_Existing() to condition the validations with reserved_by_source_ for move of a reservation.
--  170301  UdGnlk  LIM-10870, Modified New_Or_Add_To_Existing() to add reserved_by_source_ parameter and insert the value. 
--  170301  MaEelk  LIM-10889, Added Default inventory_event_id_ to Remove_Unexecuted_Tasks.
--  170224  UdGnlk  LIM-10873, Modified New_Or_Add_To_Existing() to do review comments.  
--  170207  UdGnlk  STRSC-5729, Modified New_Or_Add_To_Existing() to avoid move reservation site configuration validations to WO order type.
--  170202  UdGnlk  LIM-10369, Modified New_Or_Add_To_Existing() to add validations to move reservation with transport task. 
--  170111  MaEelk  LIM-10121, Added necessary changes relevant to newly added  pick_list_no and shipment_id columns in Transport_Task_Line_Tab.
--  170105  LEPESE  LIM-10028, added parameter ignore_this_handling_unit_id_ to methods Get_Booked_Carrying_Capacity,
--  170105          Get_Booked_Volume_Capacity and Get_Booked_Storage_Capacity___
--  161208  LEPESE  LIM-9483, Added mehtod Get_Booked_Storage_Capacity___ and called it from Get_Booked_Carrying_Capacity and Get_Booked_Volume_Capacity.
--  161202  LEPESE  LIM-9483, Redesigned method Get_Booked_Carrying_Capacity to handle gross weights of handling units as well as part weights.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160511  LEPESE  LIM-7363, passed putaway_event_id_ when calling Transport_Task_Line_API.New_Or_Add_To_Existing_ from New_Or_Add_To_Existing.
--  160511  DaZase  LIM-5332, Added method Get_Handling_Unit_Type_Id__.
--  160425  Erlise  LIM-7061, Modified Execute___ for Handling Units.
--  160325  NiLalk  Bug 127855,Added conditions in Check_Insert___ to restrict user from adding zero, negative and decimal values to transport_task_id.
--  151126  JeLise  LIM-4470, Removed methods Get_Task_Id_Created_For_Pallet and Is_Pallet_Storage_Booked.
--  151105  UdGnlk  LIM-3671, Removed method calls from Inventory_Part_Loc_Pallet_API, since INVENTORY_PART_LOC_PALLET_TAB will be obsolete.   
--  151103  MaEelk  LIM-4367, Removed New_Or_Add_Nopall_To_Existing, New_Or_Add_Pallet_To_Existing,  Has_Pallet_Lines
--  151029  JeLise  LIM-3941, Removed calls to Inventory_Location_API.Is_Pallet_Location in Increase_Qty_On_Unexecuted___ and Reduce_Qty_On_Unexecuted_Tasks.
--  150527  JeLise  LIM-2949, Added handling_unit_id as parameter to Increase_Qty_On_Unexecuted___.
--  150422  MaEelk  LIM-1279, Added handling_unit_id to the referececes of transport_task_line_tab.
--  150413  JeLise  Added handling_unit_id_ in calls to Inventory_Part_In_Stock_API.
--  150225  LEPESE  PRSC-4564, added condition for forward_to_location_no in methods Any_Parts_Are_Inbound, Get_Booked_Carrying_Capacity, Get_Booked_Volume_Capacity.
--  150220  LEPESE  PRSC-4564, added putaway_event_id_ as parameter to New_Or_Add_To_Existing. Passed it on to Transport_Task_Manager_API.Set_Transport_Locations. 
--  150211  LEPESE  PRSA-7337, Changed cursor conditions in method Remove_Unexecuted_Tasks to work well also when reference is not using all columns.
--  150131  MeAblk  PRSC-5906, Removed methods Check_Worker_To_Location, Check_Worker_Group_To_Location, Validate_From_Warehouse.
--  150131          Made the method Get_To_Contract__ into public. Added method Get_To_Locations. 
--  141030  RuLiLk  PRSC-2594, Reverse the correction done.
--  141029  MeAblk  Added new methods Check_Worker_To_Location, Check_Worker_Group_To_Location.
--  141014  MeAblk  Added method Validate_From_Warehouse in order to peform some validations on worker id and worker group.
--  141008  LEPESE  PRSC-3231, passing putaway_event_id_ when calling Transport_Task_Line_Nopall_API.Execute_ and
--  141008          Transport_Task_Line_Pallet_API.Execute_ from method Execute___. Added parameter ignore_transport_task_id_
--  141008          to method Any_Parts_Are_Inbound.
--  140923  RuLiLk  PRSC-2594, Reintroduced the public method Execute() in order to be compatible with MEP extension.
--  140919  LEPESE  PRSC-2518, Added method Any_Parts_Are_Inbound.
--  140528  LEPESE  PBSC-9261, added methods Modify_Order_Reservation_Qty and Increase_Qty_On_Unexecuted___.
--  140521  LEPESE  PBSC-9828, passed order_type_db_ instead of order_type when calling
--  140521          Transport_Task_Manager_API.Set_Transport_Locations in method New_Or_Add_To_Existing.
--  140415  LEPESE  BPSC-8386, removed parameter destination_ in call to Transport_Task_Manager_API.Set_Transport_Locations
--  140415          from method New_Or_Add_To_Existing.
--  140325  LEPESE  PBSC-7364, correction in New_Or_Add_To_Existing to envoke use of drop-off also for serials.
--  140224  MatKse  Modified Apply_Drop_Of_On_Lines and Revoke_Two_Step_Transport_Task to filter on forward_to_location_no when fetching lines
--  140224          to operate on, and also only consider lines in status Created.
--  140205  MATKSE  Modified Apply_Drop_Of_On_Lines and Revoke_Two_Step_Transport_Task by adding variable for info message.
--  140123  Matkse  Modified New_Or_Add_To_Existing by always fetching the warehouse keys for row_from_* since they must be used to
--                  get row_from_location_group. Else automatic consolidation will always fail if consolidation level is set to Site.          will differ.
--  131025  Rilase  Added paramter remove_reservation_ to Remove_Unexecuted_Tasks.
--  131018  Matkse  Added method Exist_For_Order_Reference.
--  130820  Matkse  Added new view ACTIVE_WAREHOUSE_TRANSPORT used for calculating inbound/outbound qty. 
--  130820          Modified Get_Qty_Inbound_For_Warehouse and Get_Qty_Outbound_For_Warehouse to use this new view.
--  130802  ChJalk  TIBE-911, Removed global variables.
--  130820          Removed obsolete methods Get_Forward_Qty_Inbound and Get_Forward_Qty_Outbound.
--  130816  Matkse  Added new methods Get_Forward_Qty_Inbound, Get_Forward_Qty_Outbound and Get_Qty_Outbound_For_Warehouse.
--  130816          Modified Get_Qty_Inbound_For_Warehouse by adding new default parameter include_forward_to_location.
--  130705  Matkse  Modified New_Or_Add_To_Existing, New_Or_Add_Nopall_To_Existing, New_Or_Add_Pallet_To_Existing
--  130705          by adding new param allow_deviating_avail_ctrl.
--  130702  Matkse  Added method Revoke_Two_Step_Transport_Task.
--  130702  Matkse  Added method Apply_Drop_Off_On_Lines.
--  130612  RiLase  Added Get_Forward_To_Location_No__(), Get_Forward_To_Warehouse_Id__(), Get_Forward_To_Bay_Id__(), Get_Forward_To_Tier_Id__(),
--  130612          Get_Forward_To_Row_Id__(), Get_Forward_To_Bin_Id__(), Get_Forward_To_Location_Grp__() and Get_Forward_To_Location_Type__().
--  130522  DaZase  Added method Get_Qty_Inbound_For_Warehouse.
--  130422  DaZase  Added method Inbound_To_Warehouse_Exist.
--  130117  RiLase  Modified methods Execute___ and Get_No_Of_Unidentified_Serials to only use one cursor instead of two.
--  130114  RiLase  Added methods Execute_Picked(), Validate_Identified_Serials___ and Execute___. Moved logic from Execute() to Execute___().
--  130114          Renamed Execute() to Execute_All(). Added status checks in Get_No_Of_Unidentified_Serials() and Execute___().
--  121221  RiLase  Added methods Has_Line_In_Status___, Has_Line_In_Status_Created, Has_Line_In_Status_Picked, Has_Line_In_Status_Executed,
--  121221          Is_Completely_Executed, Is_Completely_Executed_Str, Is_Fixed_Or_Started, Is_Fixed_Or_Started_Str and Has_Picked_Or_Executed_Line.
--  121221          Removed transport_task_status from view. Changed if-checks to check equal to executed rather than not equal to created status.
--  121221          Added check to New_Or_Add_To_Existing to prevent Transport Task lines to be added to started Transport Tasks.
--  121221          Removed obsolete methods Is_Executed,Get_Transport_Task_Status__ and Get_Transport_Task_Status_Db__.
--  121010  NaLrlk  Bug 105715, Modified view comments to synchronize with model.
--  120907  NiDalk  Bug 104534, Modified Check_Start_Warehouse_Task for correct a translation issue.
--  120815  NiDalk  Bug 104534, Added method Check_Start_Warehouse_Task.
--  120312  LEPESE  Redesign of method New_Or_Add_To_Existing to increase performance. 
--  120308  Matkse  Added method has_Pallet_Lines
--  120201  MaEelk  Modified view comments to make it synchronized with the model
--  120130  LEPESE  Added methods Get_To_Location_Group__, Get_From_Location_Type__, Get_To_Location_Type__.
--  120126  LEPESE  Added methods Get_Whse_Cons_Level_Flags___, Get_Part_Cons_Level_Flags___ and Get_Ref_Cons_Level_Flags___.
--  120126          Called these methods from New_Or_Add_To_Existing to control the dynamic consolidation of tasks.
--  120125  LEPESE  Removed method New_Or_Add_Nopall_To_Existi___ and moved all logic to New_Or_Add_To_Existing. Moved all
--  120125          logic from New_Or_Add_Pallet_To_Existing to New_Or_Add_To_Existing and consolidated with logic for nopallet.
--  120125          Added logic in New_Or_Add_To_Existing for configurable consolidation parameters. 
--  120120  LEPESE  Changed Get_Configuration_Id__ to return NULL if different part numbers on one task.
--  120120          Removed usage of Inventory_Part_Loc_Pallet_API calls in methods New_Or_Add_Pallets_To_Existing, Inbound_Task_Exist,
--  120120          Check_Unexecuted_Tasks, Get_Booked_Carrying_Capacity, Get_Booked_Volume_Capacity, and Other_Parts_Are_Inbound.
--  120120          Added PROCEDURE Set_As_Fixed.
--  120119  Matkse  Added attribute from_location_group to view TRANSPORT_TASK
--  120119  LEPESE  Removed restriction to delete printed tasks.
--  120118  LEPESE  Added Is_Fixed. Made attribute is_fixed insertable.
--  120112  LEPESE  Added methods Get_From_Warehouse_Id__, Get_From_Bay_Id__, Get_From_Tier_Id__, Get_From_Row_Id__, Get_From_Bin_Id__.
--  120112          Added methods Get_To_Warehouse_Id__,   Get_To_Bay_Id__,   Get_To_Tier_Id__,   Get_To_Row_Id__,   Get_From_Bin_Id__.
--  120112          Added columns from_warehouse_id, from_bay_id, from_tier_id, from_row_id, from_bin_id, to_warehouse_id,
--  120112          to_bay_id, to_tier_id, to_row_id, to_bind_id to view TRANSPORT_TASK.
--  120112          Added methods New and Check_Exist.
--  120111  LEPESE  Removed usage of inventory_part_loc_pallet_tab in method Reduce_Qty_On_Unexecuted_Tasks.
--  120111  JeLise  Removed view TRANSPORT_TASK_JOIN.
--  120110  LEPESE  Added User Allowed Site filter to view TRANSPORT_TASK_JOIN.
--  120106  LEPESE  Added method Lock_By_Keys_Wait. Changed where-clause on view TRANSPORT_TASK to
--  120106          filter on from_contract from line. task without lines are always displayed.
--  120106          Changed methods Get_From_Contract__ and Get_To_Contract__ to return value from first line found 
--  120106          since validation rules on line level does not allow mixed from_contract or to_contract on same task.
--  120104  LEPESE  Added method Remove(). Redesign of method Remove_Unexecuted_Tasks caused by attributes moved to transport_task_line_tab.
--  120104          Redesign of method Reduce_Qty_On_Unexecuted_Tasks caused by attributes moved to transport_task_line_tab.
--  120103  LEPESE  Redesign of methods Inbound_Task_Exist, Check_Unexecuted_Tasks, Is_Inter_Site, Get_Qty_Inbound,
--  120103          Get_Booked_Carrying_Capacity, Get_Booked_Volume_Capacity, Get_Qty_Outbound, Other_Parts_Are_Inbound,
--  120103          Other_Conditions_Are_Inbound and Other_Lots_Are_Inbound caused by attributes moved to transport_task_line_tab.
--  120102  LEPESE  Changed one version of overloaded New_Or_Add_Nopall_To_Existing into an implementation method
--  120102          New_Or_Add_Nopall_To_Existi___. Redesigned logic in New_Or_Add_Nopall_To_Existi___ and New_Or_Add_Pallet_To_Existing
--  120102          based on the fact that a lot of attributes have been moved to transport_task_line_tab.  
--  111230  LEPESE  Added methods Get_Part_No__, Get_From_Contract__, Get_To_Contract__, Get_From_Location_No__, Get_To_Location_No__,
--  111230          Get_Configuration_Id__, Get_Order_Ref1__, Get_Order_Ref2__, Get_Order_Ref3__, Get_Order_Ref4__, Get_Order_Type__,
--  111230          Get_Order_Type_Db__. Get_Destination__, Get_Destination_Db__, Get_Transport_Task_Status__, Get_Transport_Task_Status_Db__,
--  111230          Get_Next_Transport_Task_Id___.
--  111223  JeLise  Added transport_task_id and create_date in Prepare_Insert___.
--  111222  JeLise  Added method Is_Executed.
--  111221  JeLise  Removed method Check_Insert_ since all checks have been moved to Transport_Task_Line_Nopall_API.Check_Insert_
--  111221          and Transport_Task_Line_Pallet_API.Check_Insert_.
--  111215  JeLise  Moved attributes order_ref1, order_ref2, order_ref3, order_ref4, order_type, transport_task_status, destination,
--  111215          from_contract, from_location_no, to_contract, to_location_no, part_no, configuration_id to Transport_Task_Line_API.
--  111215          Added attribute fixed.
--  111104  LEPESE  In method Update___ moved calls to execute lines below update of table.
--  111028  NISMLK  SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  110908  AndDse  EASTTWO-6050, Modified New_Or_Add_To_Existing, added pallet_id as null in call to Transport_Task_API.New_Or_Add_To_Existing.
--  110902  LEPESE  Added calls to Inventory_Part_API.Exist() in Check_Insert_ and Unpack_Check_Update___.
--  110526  ShKolk  Added General_SYS for Get_Booked_Carrying_Capacity() and Get_Booked_Volume_Capacity().
--  110415  DaZase  Added columns catch_quantity, configuration_id, lot_batch_no, serial_no, waiv_dev_rej_no, eng_chg_level, activity_seq and project_id to VIEWJOIN.
--  110413  LEPESE  Added methods Check_Delete___ and Reduce_Qty_On_Unexecuted_Tasks.
--  110408  DaZase  Added Other_Lots_Are_Inbound.
--  110406  LEPESE  Added method Remove_Unexecuted_Tasks.
--  110323  LEPESE  Reimplemented method Get_Total_Qty to make it work also for pallets.
--  110309  DaZase  Changed calls to Inventory_Part_Pallet_API.Check_Exist so it uses Inventory_Part_API.Pallet_Handled instead.
--  110219  LEPESE  Added parameter part_tracking_session_id_ to methods Execute and Update___. Added logic in Update___ to validate
--  110219          the appropriate number of serials have been identified in TemporaryPartTracking. Pass new parameters
--  110219          part_tracking_session_id_ and serial_tracked_only_rec_iss_ in call to
--  110219          Transport_Task_line_Nopall_API.Execute_. Added method Get_No_Of_Unidentified_Serials.
--  110104  RaKalk  Added function Is_Inter_Site
--  110225  ChJalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  110218  DaZase  Renamed New_Or_Add_To_Existing methods to New_Or_Add_Nopall_To_Existing, Created a new New_Or_Add_To_Existing 
--  110218          as common interface to both New_Or_Add_Nopall_To_Existing/New_Or_Add_Pallet_To_Existing.
--  110214  DaZase  New override of New_Or_Add_To_Existing and changes in the old one so it can handle serial_no collections.
--  110207  DaZase  Added Other_Conditions_Are_Inbound.
--  110203  DaZase  Added Other_Parts_Are_Inbound.
--  110202  JeLise  Added Get_Qty_Outbound.
--  110126  DaZase  Added Get_Booked_Volume_Capacity.
--  110105  DaZase  Added Get_Booked_Carrying_Capacity.
--  101216  DaZase  Added Inbound_Task_Exist.
--  101208  DaZase  Removed catch unit enabled checks in Check_Insert_/Unpack_Check_Update___. 
--  101201  DaZase  Added activity_seq_ as a parameter to New_Or_Add_To_Existing.
--  101015  Asawlk  Bug 93401, Increased the length of variable attr_ to 32000 characters in New_Or_Add_Pallet_To_Existing() and
--  101015          New_Or_Add_To_Existing().
--  101008  Asawlk  Bug 93401, Added new parameter note_text_ to methods New_Or_Add_Pallet_To_Existing() and 
--  101008          New_Or_Add_To_Existing(). Modified the same methods to insert the note_text_ if new transport task is created.
--  100628  MaEelk  Modified Unpack_Check_Update___ and made calls to Transport_Task_Line_Nopall_API.Validate_Lines
--  100628          and Transport_Task_Line_Pallet_API.Validate_Lines to make validations against
--  100628          the changes do in the Transport Task
--  100601  MaEelk  Removed the call to Inv_Part_Ownership_Manager_API.Check_Move_Part from Check_Insert_ and Unpack_Check_Update___.
--  -------------------------- 14.0.0 -----------------------------------------
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  100120  DaZase  Added call to Warehouse_Bay_Bin_API.Check_Receipts_Blocked in Check_Insert_ and Unpack_Check_Update___.
--  090305  NaLrlk  Added view TRANSPORT_TASK_JOIN.
--  090217  NaLrlk  Added function Get_Total_Qty.
--  071022  MarSlk  Bug 67261, Modified the method Get_Qty_Inbound to remove parameter
--  071022          line_no_ from method calls to Get_Quantity_.    
--  -------------------------- Wings Merge End --------------------------------
--  070130  DAYJLK  Modified Unpack_Check_Update___ and Check_Insert_ by adding parameter values to calls 
--  070130          Inventory_Part_In_Stock_API.Check_Valid_Move_Combinations and Inv_Part_Ownership_Manager_API.Check_Move_Part
--  -------------------------- Wings Merge Start ------------------------------
--  060424  IsAnlk  Enlarge supplier - Changed variable definitions.
--  ----------------------------------13.4.0-----------------------------------
--  060316  OsAllk  Modified the method Get_Qty_Inbound to add line_no as in parameter to the method Get_Quantity_.
--  060213  RaKalk  Modified methods Check_Insert_ and Unpack_Check_Update___
--  060213          to block the catch unit enabled parts being used in transport tasks.
--  060213          Added new function Check_Unexecuted_Tasks
--  060124  NiDalk  Added Assert safe annotation.
--  041103  Asawlk  Bug 46794, Modified Update___ method, added a call to create refill task
--  041103          when a trasnport task is modified interms of location or site.
--  040922  SaNalk  Added a Dynamic call in Check_Insert_.
--  040810  MaEelk  Move Purch_Order_Analysis_API logic from Unpack_Check_Insert___ to Check_Insert_.
--  040803  SaNalk  Added an error message for control plans in Unpack_Check_Insert___.
--  040630  DaZaSe  Project Inventory: Added a project site check in Unpack_Check_Update___.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ------------------------------------13.3.0--------------------------------
--  030522  DAYJLK  Modified parameter list to call Inv_Part_Ownership_Manager_API.Check_Move_Part
--  030522          in methods Unpack_Check_Update___ and Check_Insert_.
--  030520  DAYJLK  Replaced call Consignment_Stock_Manager_API.Check_Move_Part with
--  030520          Inv_Part_Ownership_Manager_API.Check_Move_Part in Unpack_Check_Update___ and Check_Insert_.
--  001204  JOHW    Added validations if part is configurable.
--  000928  JOHW    Changed prompt from Configuration Id to Configuration ID.
--  000925  JOHESE  Added undefines.
--  000830  JOHW    Added configuration_id.
--  000522  LEPE    Added check for location_type PALLET in unpack_check_update___.
--  000418  NISOSE  Added General_SYS.Init_Method in Check_Insert_.
--  000301  JOHW    Added possibility to change to_contract, to_location_no.
--  000226  ROOD    Removed the possibility to print a task without checking
--                  any conditions in method Set_Printed__.
--  000222  ROOD    Removed the Client-value for executed in Prepare_Insert___.
--                  Changed error message in Check_Insert_. Corrected control 'ORDERREFNOUPD'.
--  000221  JOHW    Added parameter requested_date_finished_.
--  000219  ROOD    Added method Set_Printed__ to be used by the report.
--                  Corrected calls to General_SYS.Init_Method.
--  000218  ROOD    Moved some Client_SYS.Add_To_Attr to New__ and Modify__.
--  000217  JOHW    Added validation in unpack_check_update___.
--  000216  ROOD    Added a variable initiation in method Get_Qty_Inbound.
--  000215  ROOD    Corrected validations towards Warehousing and error in cursor
--                  in Find_Or_Add_To_Existing.
--  000210  JOHW    Added method Get_Qty_Inbound.
--  000208  ROOD    Added method Check_Insert_.
--  000206  ROOD    Added a missing parameter in an error message UPDNOCHANGE.
--  000201  ROOD    Changed validations in Unpack_Check_Update___ after tests.
--  000131  ROOD    Added from_contract and to_contract in Prepare_Insert.
--  000128  JOHW    Added public method Get_Task_Id_Created_For_Pallet
--  000124  ROOD    Changes in base methods for insert and update.
--  000117  JOHW    Added public method Get_Printed_Flag.
--  000117  JOHW    Added validations in Unpack_Check_Insert and update.
--  991230  JOHW    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_                   CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

number_null_                   CONSTANT NUMBER       := -99999999999;

db_true_                       CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

db_false_                      CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

mixed_value_                   CONSTANT VARCHAR2(3)  := '...';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Transport_Task_Id___ RETURN NUMBER
IS
   transport_task_id_ TRANSPORT_TASK_TAB.transport_task_id%TYPE;

   CURSOR get_next_transport_task_id IS
      SELECT transport_task_id.NEXTVAL
        FROM DUAL;
BEGIN
   OPEN  get_next_transport_task_id;
   FETCH get_next_transport_task_id INTO transport_task_id_;
   CLOSE get_next_transport_task_id;

   RETURN (transport_task_id_);
END Get_Next_Transport_Task_Id___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_TASK_ID', Get_Next_Transport_Task_Id___                          , attr_);
   Client_SYS.Add_To_Attr('CREATE_DATE'      , Site_API.Get_Site_Date(User_Default_API.Get_Contract()), attr_);
   Client_SYS.Add_To_Attr('FIXED'            , Fnd_Boolean_API.Decode(db_false_)                      , attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT TRANSPORT_TASK_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.transport_task_id IS NULL) THEN
      newrec_.transport_task_id := Get_Next_Transport_Task_Id___;
   END IF;   
   newrec_.create_date  := Site_API.Get_Site_Date(User_Default_API.Get_Contract());
   newrec_.printed_flag := 0;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_TASK_ID', newrec_.transport_task_id, attr_);
   Client_SYS.Add_To_Attr('CREATE_DATE', newrec_.create_date, attr_);
   Client_SYS.Add_To_Attr('PRINTED_FLAG', newrec_.printed_flag, attr_);   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


PROCEDURE Check_And_Delete___ (
   remrec_ IN TRANSPORT_TASK_TAB%ROWTYPE )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.transport_task_id);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Check_And_Delete___;


PROCEDURE Get_Whse_Cons_Level_Flags___ (
   single_warehouse_id_          OUT VARCHAR2,
   single_bay_id_                OUT VARCHAR2,
   single_tier_id_               OUT VARCHAR2,
   single_row_id_                OUT VARCHAR2,
   single_bin_id_                OUT VARCHAR2,
   warehouse_structure_level_db_ IN  VARCHAR2 )
IS
BEGIN
   single_warehouse_id_ := db_false_;
   single_bay_id_       := db_false_;
   single_tier_id_      := db_false_;
   single_row_id_       := db_false_;
   single_bin_id_       := db_false_;

   CASE warehouse_structure_level_db_
      WHEN Warehouse_Structure_Level_API.db_site THEN
         NULL;
      WHEN Warehouse_Structure_Level_API.db_warehouse THEN
         single_warehouse_id_ := db_true_;
      WHEN Warehouse_Structure_Level_API.db_bay THEN
         single_warehouse_id_ := db_true_;
         single_bay_id_       := db_true_;
      WHEN Warehouse_Structure_Level_API.db_tier THEN
         single_warehouse_id_ := db_true_;
         single_bay_id_       := db_true_;
         single_tier_id_      := db_true_;
      WHEN Warehouse_Structure_Level_API.db_row THEN
         single_warehouse_id_ := db_true_;
         single_bay_id_       := db_true_;
         single_row_id_       := db_true_;
      WHEN Warehouse_Structure_Level_API.db_bin THEN
         single_warehouse_id_ := db_true_;
         single_bay_id_       := db_true_;
         single_tier_id_      := db_true_;
         single_row_id_       := db_true_;
         single_bin_id_       := db_true_;
   END CASE;
END Get_Whse_Cons_Level_Flags___;


PROCEDURE Get_Part_Cons_Level_Flags___ (
   single_part_no_          OUT VARCHAR2,
   single_configuration_id_ OUT VARCHAR2,
   part_cons_level_db_      IN  VARCHAR2 )
IS
BEGIN
   single_part_no_          := db_false_;
   single_configuration_id_ := db_false_;

   CASE part_cons_level_db_
      WHEN Transport_Part_Cons_Level_API.db_multiple_parts THEN
         NULL;
      WHEN Transport_Part_Cons_Level_API.db_single_part THEN
         single_part_no_ := db_true_;
      WHEN Transport_Part_Cons_Level_API.db_single_configuration THEN
         single_part_no_          := db_true_;
         single_configuration_id_ := db_true_;
   END CASE;
END Get_Part_Cons_Level_Flags___;


PROCEDURE Get_Ref_Cons_Level_Flags___ (
   single_ref_type_           OUT VARCHAR2,
   single_ref1_               OUT VARCHAR2,
   single_ref2_               OUT VARCHAR2,
   single_ref3_               OUT VARCHAR2,
   single_ref4_               OUT VARCHAR2,
   single_pick_list_no_       OUT VARCHAR2,
   single_shipment_id_        OUT VARCHAR2,
   single_reserved_by_source_ OUT VARCHAR2,
   ref_cons_level_db_         IN  VARCHAR2 )
IS
BEGIN
   single_ref_type_           := db_false_;
   single_ref1_               := db_false_;
   single_ref2_               := db_false_;
   single_ref3_               := db_false_;
   single_ref4_               := db_false_;
   single_pick_list_no_       := db_false_;
   single_shipment_id_        := db_false_;
   single_reserved_by_source_ := db_false_;
   
   CASE ref_cons_level_db_
      WHEN Transport_Ref_Cons_Level_API.db_multiple_references THEN
         NULL;
      WHEN Transport_Ref_Cons_Level_API.db_single_ref1 THEN
         single_ref_type_ := db_true_;
         single_ref1_     := db_true_;
      WHEN Transport_Ref_Cons_Level_API.db_single_reference THEN
         single_ref_type_           := db_true_;
         single_ref1_               := db_true_;
         single_ref2_               := db_true_;
         single_ref3_               := db_true_;
         single_ref4_               := db_true_;
         single_pick_list_no_       := db_true_;
         single_shipment_id_        := db_true_;
         single_reserved_by_source_ := db_true_;
   END CASE;
END Get_Ref_Cons_Level_Flags___;


FUNCTION Has_Line_In_Status___(
   transport_task_id_        IN NUMBER,
   transport_task_status_db_ IN VARCHAR2   ) RETURN BOOLEAN
IS
   has_line_in_status_ BOOLEAN := FALSE;
   dummy_               NUMBER;
   CURSOR has_line_in_status IS
      SELECT 1
      FROM   transport_task_line_tab
      WHERE  transport_task_id = transport_task_id_
      AND    transport_task_status = transport_task_status_db_;
BEGIN
   OPEN has_line_in_status;
   FETCH has_line_in_status INTO dummy_;
   IF (has_line_in_status%FOUND) THEN
      has_line_in_status_ := TRUE;
   END IF;
   CLOSE has_line_in_status;
   RETURN (has_line_in_status_);
END Has_Line_In_Status___;


PROCEDURE Validate_Identified_Serials___(
   part_tracking_session_id_       IN NUMBER,
   number_of_serials_to_identify_  IN NUMBER )
IS
   number_of_identified_serials_  NUMBER;
BEGIN
   number_of_identified_serials_  := Temporary_Part_Tracking_API.Get_Number_Of_Serials(part_tracking_session_id_);

   IF (number_of_identified_serials_ != number_of_serials_to_identify_) THEN
      Error_SYS.Record_General('TransportTask','SERNONOTEQ: You need to identify :P1 serials but have identified :P2.', number_of_serials_to_identify_, number_of_identified_serials_);
   END IF;
END Validate_Identified_Serials___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT transport_task_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.fixed IS NULL THEN
      newrec_.fixed := db_false_;
   END IF;
   newrec_.split_by_hu_capacity := db_false_;
   IF (indrec_.transport_task_id AND newrec_.transport_task_id IS NOT NULL) THEN 
     IF (newrec_.transport_task_id <= 0 OR MOD(newrec_.transport_task_id, 1) != 0 OR LENGTH(TO_CHAR(newrec_.transport_task_id)) > 9) THEN
       Error_Sys.Record_General(lu_name_,
                                'TRANSTASKIDNOTNEGINT: The transport task ID should be a positive integer that does not exceed 9 digits.');
     END IF;
   END IF;
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     transport_task_tab%ROWTYPE,
   newrec_ IN OUT transport_task_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'PRINTED_FLAG', newrec_.printed_flag);
   IF (Is_Completely_Executed(newrec_.transport_task_id) AND NOT Check_Only_Printing___(newrec_, oldrec_)) THEN
      Error_SYS.Record_General('TransportTask','UPDEXEC: Transport Task :P1 can not be modified since the Transport Task is executed.', newrec_.transport_task_id);
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

PROCEDURE Increase_Qty_On_Unexecuted___ (
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   handling_unit_id_          IN NUMBER,
   additional_quantity_       IN NUMBER,
   additional_catch_quantity_ IN NUMBER,
   order_ref1_                IN VARCHAR2,
   order_ref2_                IN VARCHAR2,
   order_ref3_                IN VARCHAR2,
   order_ref4_                IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,   
   order_type_db_             IN VARCHAR2,
   reserved_by_source_db_     IN VARCHAR2 )
IS
   transport_task_id_  TRANSPORT_TASK_TAB.TRANSPORT_TASK_ID%TYPE;
   line_no_            TRANSPORT_TASK_LINE_TAB.LINE_NO%TYPE;

   CURSOR get_unexecuted_lines IS
      SELECT transport_task_id, line_no
        FROM transport_task_line_tab
       WHERE  order_ref1            = order_ref1_
         AND  order_ref2            = order_ref2_
         AND  NVL(order_ref3, string_null_)   = NVL(order_ref3_, string_null_)
         AND  NVL(order_ref4, number_null_)   = NVL(order_ref4_, number_null_)
         AND  NVL(pick_list_no, string_null_) = NVL(pick_list_no_, string_null_)
         AND  NVL(shipment_id, number_null_)  = NVL(shipment_id_, number_null_)
         AND  order_type            = order_type_db_
         AND  part_no               = part_no_
         AND  configuration_id      = configuration_id_
         AND  from_contract         = contract_
         AND  from_location_no      = location_no_
         AND  lot_batch_no          = lot_batch_no_
         AND  serial_no             = serial_no_
         AND  eng_chg_level         = eng_chg_level_
         AND  waiv_dev_rej_no       = waiv_dev_rej_no_
         AND  activity_seq          = activity_seq_
         AND  handling_unit_id      = handling_unit_id_
         AND  reserved_by_source    = reserved_by_source_db_
         AND  transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
      FOR UPDATE;
BEGIN
   OPEN get_unexecuted_lines;
   FETCH get_unexecuted_lines INTO transport_task_id_, line_no_;
   IF get_unexecuted_lines%NOTFOUND THEN
      CLOSE get_unexecuted_lines;
      Error_SYS.Record_General('TransportTask','NOUNEXECFOUND: No unexecuted transport task line can be found fo the reservation.');
   END IF;
   CLOSE get_unexecuted_lines;
   Transport_Task_Line_Api.Increase_Quantity(transport_task_id_,
                                         line_no_,
                                         additional_quantity_,
                                         additional_catch_quantity_);
END Increase_Qty_On_Unexecuted___;


FUNCTION Get_Booked_Storage_Capacity___ (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   unit_type_db_                 IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER) RETURN NUMBER
IS
   booked_storage_capacity_       NUMBER := 0;
   capacity_requirement_          NUMBER;
   location_no_tab_               Inventory_Part_In_Stock_API.Inventory_Location_Table;
   inv_part_stock_tab_            Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   handl_unit_stock_result_tab_   Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab;
   inv_part_stock_result_tab_     Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   company_                       VARCHAR2(20);
   company_rec_                   Company_Invent_Info_API.Public_Rec;

   CURSOR get_inbound_stock_quantity IS
      SELECT from_contract contract, part_no, configuration_id, from_location_no location_no, lot_batch_no,
             serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, SUM(quantity) quantity
        FROM transport_task_line_tab ttl
       WHERE ttl.to_contract            = contract_
         AND ttl.transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND EXISTS (SELECT 1 FROM inventory_location_tmp il
                  WHERE (ttl.to_location_no         = il.location_no OR
                         ttl.forward_to_location_no = il.location_no))
      GROUP BY from_contract , part_no, configuration_id, from_location_no , lot_batch_no,
             serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id;
BEGIN
   location_no_tab_ := Warehouse_Bay_Bin_API.Get_Location_Numbers(contract_,
                                                                  warehouse_id_,
                                                                  bay_id_,
                                                                  tier_id_,
                                                                  row_id_,
                                                                  bin_id_);
   Inventory_Part_In_Stock_API.Clear_Inventory_Location_Tmp;
   Inventory_Part_In_Stock_API.Fill_Inventory_Location_Tmp(location_no_tab_);

   OPEN  get_inbound_stock_quantity;
   FETCH get_inbound_stock_quantity BULK COLLECT INTO inv_part_stock_tab_;
   CLOSE get_inbound_stock_quantity;

   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(handl_unit_stock_result_tab_  => handl_unit_stock_result_tab_,
                                                  inv_part_stock_result_tab_    => inv_part_stock_result_tab_,
                                                  inv_part_stock_tab_           => inv_part_stock_tab_,
                                                  only_outermost_in_result_     => TRUE,
                                                  incl_hu_zero_in_result_       => FALSE,
                                                  incl_qty_zero_in_result_      => FALSE,
                                                  summarize_part_stock_result_  => TRUE);

   Inventory_Part_In_Stock_API.Clear_Inventory_Location_Tmp;

   IF (inv_part_stock_result_tab_.COUNT > 0) THEN
      FOR i IN inv_part_stock_result_tab_.FIRST..inv_part_stock_result_tab_.LAST LOOP

         capacity_requirement_ := CASE unit_type_db_
                                     WHEN Iso_Unit_Type_API.DB_VOLUME THEN
                                        Inventory_Part_API.Get_Storage_Volume_Requirement(inv_part_stock_result_tab_(i).contract,
                                                                                          inv_part_stock_result_tab_(i).part_no)
                                     WHEN Iso_Unit_Type_API.DB_WEIGHT THEN
                                        Inventory_Part_API.Get_Storage_Weight_Requirement(inv_part_stock_result_tab_(i).contract,
                                                                                          inv_part_stock_result_tab_(i).part_no) END;
         IF (capacity_requirement_ IS NULL) THEN
            booked_storage_capacity_ := Inventory_Putaway_Manager_API.positive_infinity_;
            EXIT;
         ELSE
            booked_storage_capacity_ := booked_storage_capacity_ + (capacity_requirement_ * inv_part_stock_result_tab_(i).quantity);
         END IF;
      END LOOP;
   END IF;

   IF (booked_storage_capacity_ < Inventory_Putaway_Manager_API.positive_infinity_) THEN
      IF (handl_unit_stock_result_tab_.COUNT > 0) THEN
         company_     := Site_API.Get_Company(contract_);
         company_rec_ := Company_Invent_Info_API.Get(company_);
         FOR i IN handl_unit_stock_result_tab_.FIRST..handl_unit_stock_result_tab_.LAST LOOP

            IF ((handl_unit_stock_result_tab_(i).handling_unit_id != ignore_this_handling_unit_id_) OR (ignore_this_handling_unit_id_ IS NULL)) THEN
               IF (Handling_Unit_API.Has_Parent_At_Any_Level(handl_unit_stock_result_tab_(i).handling_unit_id,
                                                             ignore_this_handling_unit_id_) = Fnd_Boolean_API.DB_FALSE) THEN 
               booked_storage_capacity_ := booked_storage_capacity_ +
                                           CASE unit_type_db_
                                              WHEN Iso_Unit_Type_API.DB_VOLUME THEN
                                                 Handling_Unit_API.Get_Operative_Volume(handl_unit_stock_result_tab_(i).handling_unit_id,
                                                                                        company_rec_.uom_for_volume)
                                              WHEN Iso_Unit_Type_API.DB_WEIGHT THEN
                                                 Handling_Unit_API.Get_Operative_Gross_Weight(handl_unit_stock_result_tab_(i).handling_unit_id,
                                                                                               company_rec_.uom_for_weight,
                                                                                               apply_freight_factor_ => Fnd_Boolean_Api.DB_FALSE) END;
               END IF;
            END IF;
         END LOOP;
      END IF;
   END IF;

   RETURN (booked_storage_capacity_);
END Get_Booked_Storage_Capacity___;

-----------------------------------------------------------------------------
-- Check_Only_Printing___
--   This will return TRUE if only printing the transport task is being done.
--   If any other attribute gets changed, it will return FALSE.
-----------------------------------------------------------------------------
FUNCTION Check_Only_Printing___ (
   newrec_ IN  transport_task_tab%ROWTYPE,
   oldrec_ IN  transport_task_tab%ROWTYPE ) RETURN BOOLEAN
IS
   only_printing_    BOOLEAN; 
BEGIN
   IF (NVL(oldrec_.note_text, Database_SYS.string_null_) = NVL(newrec_.note_text, Database_SYS.string_null_))
      AND (oldrec_.fixed                                 = newrec_.fixed)
      AND (oldrec_.printed_flag                         != newrec_.printed_flag) THEN
      only_printing_ := TRUE;
   ELSE
      only_printing_ := FALSE;
   END IF;
   RETURN only_printing_;
END Check_Only_Printing___;

PROCEDURE Execute_Online_Or_Deferred___ (
   transport_task_id_        IN NUMBER,
   part_tracking_session_id_ IN NUMBER,
   only_status_picked_       IN VARCHAR2,
   force_execute_online_     IN VARCHAR2 )
IS
   execute_background_ VARCHAR2(5);
   execute_online_     BOOLEAN;
   attr_               VARCHAR2(100);
   description_        VARCHAR2(100);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_TASK_ID',        transport_task_id_,        attr_);
   Client_SYS.Add_To_Attr('PART_TRACKING_SESSION_ID', part_tracking_session_id_, attr_);
   Client_SYS.Add_To_Attr('ONLY_STATUS_PICKED',       only_status_picked_,       attr_);
   
   IF ( force_execute_online_ = Fnd_BOOLEAN_API.DB_TRUE ) THEN
      execute_online_ := TRUE;
   ELSE
      execute_background_ := Site_Invent_Info_API.Get_Exec_Transp_Task_Backgr_Db(Get_From_Contract__(transport_task_id_));
      IF (execute_background_ = Fnd_Boolean_API.DB_FALSE) THEN
         execute_online_ := TRUE;
      ELSE
         execute_online_ := FALSE;
      END IF;
   END IF;
   
   IF (execute_online_) THEN
      Execute__(attr_);
   ELSE
      Validate_Transport_Status___(transport_task_id_);
      description_ := Language_SYS.Translate_Constant(lu_name_, 'EXECUTETASK: Execute transport task :P1.', NULL, transport_task_id_) ;
      Transaction_SYS.Deferred_Call('Transport_Task_API.Execute__', attr_, description_);
   END IF;
END Execute_Online_Or_Deferred___;


PROCEDURE Validate_Transport_Status___ (
   transport_task_id_ IN NUMBER )
IS
BEGIN
   IF NOT (Transport_Task_Line_API.Lines_Exist(transport_task_id_)) THEN
      Error_SYS.Record_General(lu_name_,'NOLINES: Cannot execute Transport Task :P1 without details.', transport_task_id_);
   END IF;

   IF (Is_Completely_Executed(transport_task_id_)) THEN
      Error_SYS.Record_General(lu_name_,'ALREXEC: All lines on Transport Task :P1 are already executed.', transport_task_id_);
   END IF;
END Validate_Transport_Status___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Set_Printed__
--   Set the printed_flag regardless of its prior setting.
PROCEDURE Set_Printed__ (
   transport_task_id_ IN NUMBER )
IS
   objid_      TRANSPORT_TASK.objid%TYPE;
   objversion_ TRANSPORT_TASK.objversion%TYPE;
   newrec_     TRANSPORT_TASK_TAB%ROWTYPE;
   oldrec_     TRANSPORT_TASK_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(transport_task_id_);
   IF (oldrec_.printed_flag != 1) OR (oldrec_.printed_flag IS NULL) THEN
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PRINTED_FLAG', 1, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
   END IF;
END Set_Printed__;


@UncheckedAccess
FUNCTION Get_Part_No__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   part_no_ transport_task_line_tab.part_no%TYPE;
BEGIN
   SELECT DISTINCT part_no
     INTO part_no_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN part_no_;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Part_No__;


@UncheckedAccess
FUNCTION Get_Configuration_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   configuration_id_ transport_task_line_tab.configuration_id%TYPE;
BEGIN
   SELECT DISTINCT configuration_id
     INTO configuration_id_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN configuration_id_;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Configuration_Id__;


@UncheckedAccess
FUNCTION Get_Order_Ref1__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   order_ref1_ transport_task_line_tab.order_ref1%TYPE;
BEGIN
   SELECT DISTINCT order_ref1
     INTO order_ref1_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN order_ref1_;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Order_Ref1__;


@UncheckedAccess
FUNCTION Get_Order_Ref2__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   order_ref2_ transport_task_line_tab.order_ref2%TYPE;
BEGIN
   SELECT DISTINCT order_ref2
     INTO order_ref2_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN order_ref2_;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Order_Ref2__;


@UncheckedAccess
FUNCTION Get_Order_Ref3__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   order_ref3_ transport_task_line_tab.order_ref3%TYPE;
BEGIN
   SELECT DISTINCT order_ref3
     INTO order_ref3_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN order_ref3_;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Order_Ref3__;


@UncheckedAccess
FUNCTION Get_Order_Ref4__ (
   transport_task_id_ IN NUMBER ) RETURN NUMBER  
IS
   order_ref4_ transport_task_line_tab.order_ref4%TYPE;
BEGIN
   SELECT DISTINCT order_ref4
     INTO order_ref4_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN order_ref4_;
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END Get_Order_Ref4__;


@UncheckedAccess
FUNCTION Get_Order_Type__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   order_type_ transport_task_line_tab.order_type%TYPE;
BEGIN
   SELECT DISTINCT(order_type)
   INTO   order_type_
   FROM   transport_task_line_tab
   WHERE  transport_task_id = transport_task_id_
   AND    rownum <= 2;

   RETURN Order_Type_API.Decode(order_type_);
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Order_Type__;


@UncheckedAccess
FUNCTION Get_Order_Type_Db__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   order_type_ transport_task_line_tab.order_type%TYPE;
   
   CURSOR get_order_type IS
      SELECT DISTINCT(order_type)
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_;
BEGIN
   OPEN get_order_type;
   LOOP 
      FETCH get_order_type INTO order_type_;
      IF get_order_type%ROWCOUNT > 1 THEN
         order_type_ := NULL;
         EXIT;
      END IF;
      EXIT WHEN get_order_type%NOTFOUND;
   END LOOP;
   CLOSE get_order_type;
   
   RETURN (order_type_);
END Get_Order_Type_Db__;


@UncheckedAccess
FUNCTION Get_From_Contract__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   from_contract_ transport_task_line_tab.from_contract%TYPE;
   
   CURSOR get_from_contract IS
      SELECT from_contract
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_;
BEGIN
   OPEN  get_from_contract;
   FETCH get_from_contract INTO from_contract_;
   CLOSE get_from_contract;
   
   RETURN from_contract_;
END Get_From_Contract__;


@UncheckedAccess
FUNCTION Get_From_Location_No__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   from_location_no_ transport_task_line_tab.from_location_no%TYPE;
BEGIN
   SELECT DISTINCT from_location_no
     INTO from_location_no_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN from_location_no_;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_From_Location_No__;


@UncheckedAccess
FUNCTION Get_To_Contract (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   to_contract_ transport_task_line_tab.to_contract%TYPE;
   
   CURSOR get_to_contract IS
      SELECT to_contract
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_;
BEGIN
   OPEN  get_to_contract;
   FETCH get_to_contract INTO to_contract_;
   CLOSE get_to_contract;
   
   RETURN to_contract_;
END Get_To_Contract;


@UncheckedAccess
FUNCTION Get_To_Location_No__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   to_location_no_ transport_task_line_tab.to_location_no%TYPE;
BEGIN
   SELECT DISTINCT to_location_no
     INTO to_location_no_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN to_location_no_;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_To_Location_No__;


@UncheckedAccess
FUNCTION Get_Destination__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   destination_ transport_task_line_tab.destination%TYPE;
   
BEGIN   
   SELECT DISTINCT destination
     INTO destination_
     FROM transport_task_line_tab
    WHERE transport_task_id = transport_task_id_
      AND rownum <= 2;

   RETURN Inventory_Part_Destination_API.Decode(destination_);
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      RETURN mixed_value_;
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Destination__;


@UncheckedAccess
FUNCTION Get_Destination_Db__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   destination_ transport_task_line_tab.destination%TYPE;
   
   CURSOR get_destination IS
      SELECT destination
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_;
BEGIN
   FOR rec_ IN get_destination LOOP
      IF (destination_ IS NULL) THEN
         destination_ := rec_.destination;
      ELSE
         IF (destination_ != rec_.destination) THEN
            destination_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;
   
   RETURN (destination_);
END Get_Destination_Db__;


@UncheckedAccess
FUNCTION Get_From_Warehouse_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   from_warehouse_id_ VARCHAR2(15);

   CURSOR get_from_warehouse_id IS
      SELECT DISTINCT wbb.warehouse_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.from_contract     = wbb.contract
         AND ttl.from_location_no  = wbb.location_no
         AND rownum <= 2;

   TYPE Warehouse_Id_Tab IS TABLE OF get_from_warehouse_id%ROWTYPE INDEX BY PLS_INTEGER;
   warehouse_id_tab_    Warehouse_Id_Tab;
BEGIN
   OPEN get_from_warehouse_id;
   FETCH get_from_warehouse_id BULK COLLECT INTO warehouse_id_tab_;
   CLOSE get_from_warehouse_id;

   IF (warehouse_id_tab_.COUNT = 1) THEN
      from_warehouse_id_ := warehouse_id_tab_(1).warehouse_id;
   ELSIF (warehouse_id_tab_.COUNT > 1) THEN
      from_warehouse_id_ := mixed_value_;
   END IF;

   RETURN from_warehouse_id_;
END Get_From_Warehouse_Id__;


@UncheckedAccess
FUNCTION Get_From_Bay_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   from_bay_id_ VARCHAR2(5);

   CURSOR get_from_bay_id IS
      SELECT DISTINCT wbb.bay_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.from_contract     = wbb.contract
         AND ttl.from_location_no  = wbb.location_no
         AND rownum <= 2;

   TYPE Bay_Id_Tab IS TABLE OF get_from_bay_id%ROWTYPE INDEX BY PLS_INTEGER;
   bay_id_tab_    Bay_Id_Tab;
BEGIN
   OPEN get_from_bay_id;
   FETCH get_from_bay_id BULK COLLECT INTO bay_id_tab_;
   CLOSE get_from_bay_id;

   IF (bay_id_tab_.COUNT = 1) THEN
      from_bay_id_ := bay_id_tab_(1).bay_id;
   ELSIF (bay_id_tab_.COUNT > 1) THEN
      from_bay_id_ := mixed_value_;
   END IF;

   RETURN (from_bay_id_);
END Get_From_Bay_Id__;


@UncheckedAccess
FUNCTION Get_From_Tier_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   from_tier_id_ VARCHAR2(5);

   CURSOR get_from_tier_id IS
      SELECT DISTINCT wbb.tier_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.from_contract     = wbb.contract
         AND ttl.from_location_no  = wbb.location_no
         AND rownum <= 2;

   TYPE Tier_Id_Tab IS TABLE OF get_from_tier_id%ROWTYPE INDEX BY PLS_INTEGER;
   tier_id_tab_    Tier_Id_Tab;
BEGIN
   OPEN get_from_tier_id;
   FETCH get_from_tier_id BULK COLLECT INTO tier_id_tab_;
   CLOSE get_from_tier_id;

   IF (tier_id_tab_.COUNT = 1) THEN
      from_tier_id_ := tier_id_tab_(1).tier_id;
   ELSIF (tier_id_tab_.COUNT > 1) THEN
      from_tier_id_ := mixed_value_;
   END IF;

   RETURN (from_tier_id_);
END Get_From_Tier_Id__;


@UncheckedAccess
FUNCTION Get_From_Row_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   from_row_id_ VARCHAR2(5);

   CURSOR get_from_row_id IS
      SELECT DISTINCT wbb.row_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.from_contract     = wbb.contract
         AND ttl.from_location_no  = wbb.location_no
         AND rownum <= 2;

   TYPE Row_Id_Tab IS TABLE OF get_from_row_id%ROWTYPE INDEX BY PLS_INTEGER;
   row_id_tab_    Row_Id_Tab;
BEGIN
   OPEN get_from_row_id;
   FETCH get_from_row_id BULK COLLECT INTO row_id_tab_;
   CLOSE get_from_row_id;

   IF (row_id_tab_.COUNT = 1) THEN
      from_row_id_ := row_id_tab_(1).row_id;
   ELSIF (row_id_tab_.COUNT > 1) THEN
      from_row_id_ := mixed_value_;
   END IF;

   RETURN (from_row_id_);
END Get_From_Row_Id__;


@UncheckedAccess
FUNCTION Get_From_Bin_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   from_bin_id_ VARCHAR2(5);

   CURSOR get_from_bin_id IS
      SELECT DISTINCT wbb.bin_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.from_contract     = wbb.contract
         AND ttl.from_location_no  = wbb.location_no
         AND rownum <= 2;

   TYPE Bin_Id_Tab IS TABLE OF get_from_bin_id%ROWTYPE INDEX BY PLS_INTEGER;
   bin_id_tab_    Bin_Id_Tab;
BEGIN
   OPEN get_from_bin_id;
   FETCH get_from_bin_id BULK COLLECT INTO bin_id_tab_;
   CLOSE get_from_bin_id;

   IF (bin_id_tab_.COUNT = 1) THEN
      from_bin_id_ := bin_id_tab_(1).bin_id;
   ELSIF (bin_id_tab_.COUNT > 1) THEN
      from_bin_id_ := mixed_value_;
   END IF;

   RETURN (from_bin_id_);
END Get_From_Bin_Id__;


@UncheckedAccess
FUNCTION Get_To_Warehouse_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   to_warehouse_id_ VARCHAR2(15);

   CURSOR get_to_warehouse_id IS
      SELECT DISTINCT wbb.warehouse_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.to_contract       = wbb.contract
         AND ttl.to_location_no    = wbb.location_no
         AND rownum <= 2;

   TYPE Warehouse_Id_Tab IS TABLE OF get_to_warehouse_id%ROWTYPE INDEX BY PLS_INTEGER;
   warehouse_id_tab_    Warehouse_Id_Tab;
BEGIN
   OPEN get_to_warehouse_id;
   FETCH get_to_warehouse_id BULK COLLECT INTO warehouse_id_tab_;
   CLOSE get_to_warehouse_id;

   IF (warehouse_id_tab_.COUNT = 1) THEN
      to_warehouse_id_ := warehouse_id_tab_(1).warehouse_id;
   ELSIF (warehouse_id_tab_.COUNT > 1) THEN
      to_warehouse_id_ := mixed_value_;
   END IF;

   RETURN (to_warehouse_id_);
END Get_To_Warehouse_Id__;


@UncheckedAccess
FUNCTION Get_To_Bay_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   to_bay_id_ VARCHAR2(5);

   CURSOR get_to_bay_id IS
      SELECT DISTINCT wbb.bay_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.to_contract       = wbb.contract
         AND ttl.to_location_no    = wbb.location_no
         AND rownum <= 2;

   TYPE Bay_Id_Tab IS TABLE OF get_to_bay_id%ROWTYPE INDEX BY PLS_INTEGER;
   bay_id_tab_    Bay_Id_Tab;
BEGIN
   OPEN get_to_bay_id;
   FETCH get_to_bay_id BULK COLLECT INTO bay_id_tab_;
   CLOSE get_to_bay_id;

   IF (bay_id_tab_.COUNT = 1) THEN
      to_bay_id_ := bay_id_tab_(1).bay_id;
   ELSIF (bay_id_tab_.COUNT > 1) THEN
      to_bay_id_ := mixed_value_;
   END IF;

   RETURN (to_bay_id_);
END Get_To_Bay_Id__;


@UncheckedAccess
FUNCTION Get_To_Tier_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   to_tier_id_ VARCHAR2(5);

   CURSOR get_to_tier_id IS
      SELECT DISTINCT wbb.tier_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.to_contract       = wbb.contract
         AND ttl.to_location_no    = wbb.location_no
         AND rownum <= 2;

   TYPE Tier_Id_Tab IS TABLE OF get_to_tier_id%ROWTYPE INDEX BY PLS_INTEGER;
   tier_id_tab_    Tier_Id_Tab;
BEGIN
   OPEN get_to_tier_id;
   FETCH get_to_tier_id BULK COLLECT INTO tier_id_tab_;
   CLOSE get_to_tier_id;

   IF (tier_id_tab_.COUNT = 1) THEN
      to_tier_id_ := tier_id_tab_(1).tier_id;
   ELSIF (tier_id_tab_.COUNT > 1) THEN
      to_tier_id_ := mixed_value_;
   END IF;

   RETURN (to_tier_id_);
END Get_To_Tier_Id__;


@UncheckedAccess
FUNCTION Get_To_Row_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   to_row_id_ VARCHAR2(5);

   CURSOR get_to_row_id IS
      SELECT DISTINCT wbb.row_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.to_contract       = wbb.contract
         AND ttl.to_location_no    = wbb.location_no
         AND rownum <= 2;

   TYPE Row_Id_Tab IS TABLE OF get_to_row_id%ROWTYPE INDEX BY PLS_INTEGER;
   row_id_tab_    Row_Id_Tab;
BEGIN
   OPEN get_to_row_id;
   FETCH get_to_row_id BULK COLLECT INTO row_id_tab_;
   CLOSE get_to_row_id;

   IF (row_id_tab_.COUNT = 1) THEN
      to_row_id_ := row_id_tab_(1).row_id;
   ELSIF (row_id_tab_.COUNT > 1) THEN
      to_row_id_ := mixed_value_;
   END IF;

   RETURN (to_row_id_);
END Get_To_Row_Id__;


@UncheckedAccess
FUNCTION Get_To_Bin_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   to_bin_id_ VARCHAR2(5);

   CURSOR get_to_bin_id IS
      SELECT DISTINCT wbb.bin_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.to_contract       = wbb.contract
         AND ttl.to_location_no    = wbb.location_no
         AND rownum <= 2;

   TYPE Bin_Id_Tab IS TABLE OF get_to_bin_id%ROWTYPE INDEX BY PLS_INTEGER;
   bin_id_tab_     Bin_Id_Tab;
BEGIN
   OPEN get_to_bin_id;
   FETCH get_to_bin_id BULK COLLECT INTO bin_id_tab_;
   CLOSE get_to_bin_id;

   IF (bin_id_tab_.COUNT = 1) THEN
      to_bin_id_ := bin_id_tab_(1).bin_id;
   ELSIF (bin_id_tab_.COUNT > 1) THEN
      to_bin_id_ := mixed_value_;
   END IF;

   RETURN (to_bin_id_);
END Get_To_Bin_Id__;


@UncheckedAccess
FUNCTION Get_From_Location_Group__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   from_location_group_ VARCHAR2(5);

   CURSOR get_from_location_group IS
      SELECT DISTINCT wbb.location_group
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.from_contract     = wbb.contract
         AND ttl.from_location_no  = wbb.location_no
         AND rownum <= 2;

   TYPE Location_Group_Tab IS TABLE OF get_from_location_group%ROWTYPE INDEX BY PLS_INTEGER;
   location_group_tab_     Location_Group_Tab;
BEGIN
   OPEN get_from_location_group;
   FETCH get_from_location_group BULK COLLECT INTO location_group_tab_;
   CLOSE get_from_location_group;

   IF (location_group_tab_.COUNT = 1) THEN
      from_location_group_ := location_group_tab_(1).location_group;
   ELSIF (location_group_tab_.COUNT > 1) THEN
      from_location_group_ := mixed_value_;
   END IF;

   RETURN (from_location_group_);
END Get_From_Location_Group__;


@UncheckedAccess
FUNCTION Get_To_Location_Group__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   to_location_group_ VARCHAR2(5);

   CURSOR get_to_location_group IS
      SELECT DISTINCT wbb.location_group
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.to_contract       = wbb.contract
         AND ttl.to_location_no    = wbb.location_no
         AND rownum <= 2;

   TYPE Location_Group_Tab IS TABLE OF get_to_location_group%ROWTYPE INDEX BY PLS_INTEGER;
   location_group_tab_    Location_Group_Tab;
BEGIN
   OPEN get_to_location_group;
   FETCH get_to_location_group BULK COLLECT INTO location_group_tab_;
   CLOSE get_to_location_group;

   IF (location_group_tab_.COUNT = 1) THEN
      to_location_group_ := location_group_tab_(1).location_group;
   ELSIF (location_group_tab_.COUNT > 1) THEN
      to_location_group_ := mixed_value_;
   END IF;

   RETURN (to_location_group_);
END Get_To_Location_Group__;


@UncheckedAccess
FUNCTION Get_From_Location_Type__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   from_location_type_ VARCHAR2(200);

   CURSOR get_from_location_type IS
      SELECT DISTINCT ilg.inventory_location_type
        FROM transport_task_line_tab      ttl,
             warehouse_bay_bin_tab        wbb,
             inventory_location_group_tab ilg
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.from_contract       = wbb.contract
         AND ttl.from_location_no    = wbb.location_no
         AND ilg.location_group    = wbb.location_group
         AND rownum <= 2;

   TYPE Location_Type_Tab IS TABLE OF get_from_location_type%ROWTYPE INDEX BY PLS_INTEGER;
   location_type_tab_    Location_Type_Tab;
BEGIN
   OPEN get_from_location_type;
   FETCH get_from_location_type BULK COLLECT INTO location_type_tab_;
   CLOSE get_from_location_type;

   IF (location_type_tab_.COUNT = 1) THEN
      from_location_type_ := Inventory_Location_Type_API.Decode(location_type_tab_(1).inventory_location_type);
   ELSIF (location_type_tab_.COUNT > 1) THEN
      from_location_type_ := mixed_value_;
   END IF;

   RETURN from_location_type_;
END Get_From_Location_Type__;


@UncheckedAccess
FUNCTION Get_To_Location_Type__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   to_location_type_ VARCHAR2(20);

   CURSOR get_to_location_type IS
      SELECT DISTINCT ilg.inventory_location_type
        FROM transport_task_line_tab      ttl,
             warehouse_bay_bin_tab        wbb,
             inventory_location_group_tab ilg
       WHERE ttl.transport_task_id = transport_task_id_
         AND ttl.to_contract       = wbb.contract
         AND ttl.to_location_no    = wbb.location_no
         AND ilg.location_group    = wbb.location_group
         AND rownum <= 2;

   TYPE Location_Type_Tab IS TABLE OF get_to_location_type%ROWTYPE INDEX BY PLS_INTEGER;
   location_type_tab_    Location_Type_Tab;
BEGIN
   OPEN get_to_location_type;
   FETCH get_to_location_type BULK COLLECT INTO location_type_tab_;
   CLOSE get_to_location_type;

   IF (location_type_tab_.COUNT = 1) THEN
      to_location_type_ := Inventory_Location_Type_API.Decode(location_type_tab_(1).inventory_location_type);
   ELSIF (location_type_tab_.COUNT > 1) THEN
      to_location_type_ := mixed_value_;
   END IF;

   RETURN to_location_type_;
END Get_To_Location_Type__;


@UncheckedAccess
FUNCTION Get_Forward_To_Location_No__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   forward_to_location_no_ transport_task_line_tab.forward_to_location_no%TYPE;
   
   CURSOR get_forward_to_location_no IS
      SELECT DISTINCT(forward_to_location_no)
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_
        AND rownum <= 2;

   TYPE Forward_To_Location_No_Tab IS TABLE OF get_forward_to_location_no%ROWTYPE INDEX BY PLS_INTEGER;
   forward_to_location_no_tab_    Forward_To_Location_No_Tab;
BEGIN
   OPEN get_forward_to_location_no;
   FETCH get_forward_to_location_no BULK COLLECT INTO forward_to_location_no_tab_;
   CLOSE get_forward_to_location_no;

   IF (forward_to_location_no_tab_.COUNT = 1) THEN
      forward_to_location_no_ := forward_to_location_no_tab_(1).forward_to_location_no;
   ELSIF (forward_to_location_no_tab_.COUNT > 1) THEN
      forward_to_location_no_ := mixed_value_;
   END IF;
   
   RETURN forward_to_location_no_;
END Get_Forward_To_Location_No__;


@UncheckedAccess
FUNCTION Get_Forward_To_Warehouse_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   forward_to_warehouse_id_ VARCHAR2(15);

   CURSOR get_forward_to_warehouse_id IS
      SELECT wbb.warehouse_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id       = transport_task_id_
         AND ttl.to_contract             = wbb.contract
         AND ttl.forward_to_location_no  = wbb.location_no;
BEGIN
   FOR rec_ IN get_forward_to_warehouse_id LOOP
      IF (forward_to_warehouse_id_ IS NULL) THEN
         forward_to_warehouse_id_ := rec_.warehouse_id;
      ELSE
         IF (forward_to_warehouse_id_ != rec_.warehouse_id) THEN
            forward_to_warehouse_id_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (forward_to_warehouse_id_);
END Get_Forward_To_Warehouse_Id__;


@UncheckedAccess
FUNCTION Get_Forward_To_Bay_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   forward_to_bay_id_ VARCHAR2(5);

   CURSOR get_forward_to_bay_id IS
      SELECT wbb.bay_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id        = transport_task_id_
         AND ttl.to_contract              = wbb.contract
         AND ttl.forward_to_location_no   = wbb.location_no;
BEGIN
   FOR rec_ IN get_forward_to_bay_id LOOP
      IF (forward_to_bay_id_ IS NULL) THEN
         forward_to_bay_id_ := rec_.bay_id;
      ELSE
         IF (forward_to_bay_id_ != rec_.bay_id) THEN
            forward_to_bay_id_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (forward_to_bay_id_);
END Get_Forward_To_Bay_Id__;


@UncheckedAccess
FUNCTION Get_Forward_To_Tier_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   forward_to_tier_id_ VARCHAR2(5);

   CURSOR get_forward_to_tier_id IS
      SELECT wbb.tier_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id        = transport_task_id_
         AND ttl.to_contract              = wbb.contract
         AND ttl.forward_to_location_no   = wbb.location_no;
BEGIN
   FOR rec_ IN get_forward_to_tier_id LOOP
      IF (forward_to_tier_id_ IS NULL) THEN
         forward_to_tier_id_ := rec_.tier_id;
      ELSE
         IF (forward_to_tier_id_ != rec_.tier_id) THEN
            forward_to_tier_id_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (forward_to_tier_id_);
END Get_Forward_To_Tier_Id__;


@UncheckedAccess
FUNCTION Get_Forward_To_Row_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   forward_to_row_id_ VARCHAR2(5);

   CURSOR get_forward_to_row_id IS
      SELECT wbb.row_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id        = transport_task_id_
         AND ttl.to_contract              = wbb.contract
         AND ttl.forward_to_location_no   = wbb.location_no;
BEGIN
   FOR rec_ IN get_forward_to_row_id LOOP
      IF (forward_to_row_id_ IS NULL) THEN
         forward_to_row_id_ := rec_.row_id;
      ELSE
         IF (forward_to_row_id_ != rec_.row_id) THEN
            forward_to_row_id_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (forward_to_row_id_);
END Get_Forward_To_Row_Id__;


@UncheckedAccess
FUNCTION Get_Forward_To_Bin_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   forward_to_bin_id_ VARCHAR2(5);

   CURSOR get_forward_to_bin_id IS
      SELECT wbb.bin_id
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id         = transport_task_id_
         AND ttl.to_contract               = wbb.contract
         AND ttl.forward_to_location_no    = wbb.location_no;
BEGIN
   FOR rec_ IN get_forward_to_bin_id LOOP
      IF (forward_to_bin_id_ IS NULL) THEN
         forward_to_bin_id_ := rec_.bin_id;
      ELSE
         IF (forward_to_bin_id_ != rec_.bin_id) THEN
            forward_to_bin_id_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (forward_to_bin_id_);
END Get_Forward_To_Bin_Id__;


@UncheckedAccess
FUNCTION Get_Forward_To_Location_Grp__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   forward_to_location_group_ VARCHAR2(5);

   CURSOR get_forward_to_location_group IS
      SELECT wbb.location_group
        FROM transport_task_line_tab ttl,
             warehouse_bay_bin_tab   wbb
       WHERE ttl.transport_task_id      = transport_task_id_
         AND ttl.to_contract            = wbb.contract
         AND ttl.forward_to_location_no = wbb.location_no;
BEGIN
   FOR rec_ IN get_forward_to_location_group LOOP
      IF (forward_to_location_group_ IS NULL) THEN
         forward_to_location_group_ := rec_.location_group;
      ELSE
         IF (forward_to_location_group_ != rec_.location_group) THEN
            forward_to_location_group_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (forward_to_location_group_);
END Get_Forward_To_Location_Grp__;


@UncheckedAccess
FUNCTION Get_Handling_Unit_Type_Id__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   handling_unit_type_id_        VARCHAR2(25);
   common_handling_unit_type_id_ VARCHAR2(25);
   outermost_handling_unit_id_   NUMBER;

   CURSOR get_handling_unit_type_id IS
      SELECT  transport_task_id, line_no
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_;
BEGIN
   FOR rec_ IN get_handling_unit_type_id LOOP 
      
      outermost_handling_unit_id_ := Transport_Task_Line_API.Get_Outermost_Handling_Unit_Id(rec_.transport_task_id, rec_.line_no);
      handling_unit_type_id_      := Handling_Unit_API.Get_Handling_Unit_Type_Id(outermost_handling_unit_id_);

      IF common_handling_unit_type_id_ IS NULL THEN
         common_handling_unit_type_id_ := handling_unit_type_id_;
      ELSE
         IF (handling_unit_type_id_ != common_handling_unit_type_id_ OR handling_unit_type_id_ IS NULL) THEN
            common_handling_unit_type_id_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;
   
   RETURN common_handling_unit_type_id_;
END Get_Handling_Unit_Type_Id__;


-- Execute__
--   This method executes the Transport Task.
PROCEDURE Execute__ (
   attr_ IN VARCHAR2 )
IS
   oldrec_                        TRANSPORT_TASK_TAB%ROWTYPE;
   number_of_serials_to_identify_ NUMBER;
   only_status_picked_local_      VARCHAR2(5) := db_false_;
   ptr_                           NUMBER;
   name_                          VARCHAR2(30);
   value_                         VARCHAR2(2000);
   transport_task_id_             NUMBER;
   part_tracking_session_id_      NUMBER;
   only_status_picked_            BOOLEAN;

   CURSOR get_lines IS
      SELECT line_no
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_
        AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
        AND ((transport_task_status = Transport_Task_Status_API.DB_PICKED) OR (only_status_picked_local_ = db_false_))
      FOR UPDATE;
      
   CURSOR get_handling_units IS
      SELECT handling_unit_id, transport_task_status_db
      FROM   transport_task_handling_unit
      WHERE  transport_task_id = transport_task_id_
      AND    handling_unit_id != 0
      AND    Handl_Unit_Stock_Snapshot_API.Get_Outermost_Db(transport_task_id, 
                                                            Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK, 
                                                            handling_unit_id) = Fnd_Boolean_API.DB_TRUE;
BEGIN
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('TRANSPORT_TASK_ID') THEN
         transport_task_id_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('PART_TRACKING_SESSION_ID') THEN
         part_tracking_session_id_ := Client_SYS.Attr_Value_To_Number(value_);
      WHEN ('ONLY_STATUS_PICKED') THEN
         only_status_picked_ := value_ = Fnd_Boolean_API.DB_TRUE;
      END CASE;
   END LOOP;
   
   IF (only_status_picked_) THEN
      only_status_picked_local_ := db_true_;
   END IF;

   oldrec_ := Lock_By_Keys___(transport_task_id_);
   
   Validate_Transport_Status___(transport_task_id_);
   Inventory_Event_Manager_API.Start_Session;

   FOR rec_ IN get_handling_units LOOP
      IF (only_status_picked_ AND rec_.transport_task_status_db != Transport_Task_Status_API.DB_PICKED) THEN
         -- If not everything within the handling unit is picked we shouldn't execute the picked content
         -- in a handling unit context.
         CONTINUE;
      END IF;

      Transport_Task_Handl_Unit_API.Execute_Handling_Unit(transport_task_id_  => transport_task_id_, 
                                                          handling_unit_id_   => rec_.handling_unit_id);
   END LOOP;
   
   number_of_serials_to_identify_ := Get_No_Of_Unidentified_Serials(transport_task_id_, only_status_picked_local_);
   Validate_Identified_Serials___(part_tracking_session_id_, number_of_serials_to_identify_);
   
   FOR line_rec_ IN get_lines LOOP
      Transport_Task_Line_Api.Execute_(transport_task_id_,
                                       line_rec_.line_no,
                                       part_tracking_session_id_);
   END LOOP;
   
   Print_Transport_Task(transport_task_id_);
   Inventory_Event_Manager_API.Finish_Session;
END Execute__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Execute_All
--   This method executes all lines that are not already executed on the Transport Task.
PROCEDURE Execute_All (
   transport_task_id_        IN NUMBER,
   part_tracking_session_id_ IN NUMBER DEFAULT NULL,
   force_execute_online_     IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE )
IS
BEGIN
   Execute_Online_Or_Deferred___(transport_task_id_,
                                 part_tracking_session_id_,
                                 Fnd_Boolean_API.DB_FALSE, 
                                 force_execute_online_ );
END Execute_All;

-- Execute Picked
--   This method executes all lines in status Picked on the Transport Task.
PROCEDURE Execute_Picked (
   transport_task_id_        IN NUMBER,
   part_tracking_session_id_ IN NUMBER DEFAULT NULL,
   force_execute_online_     IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE )
IS
BEGIN
   Execute_Online_Or_Deferred___(transport_task_id_,
                                 part_tracking_session_id_,
                                 Fnd_Boolean_API.DB_TRUE,
                                 force_execute_online_ );
END Execute_Picked;


PROCEDURE Find_Or_Create_New_Task (
   transport_task_id_             OUT NUMBER,
   part_no_                    IN     VARCHAR2,
   configuration_id_           IN     VARCHAR2,
   from_contract_              IN     VARCHAR2,
   from_location_no_           IN     VARCHAR2,
   to_contract_                IN     VARCHAR2,
   to_location_no_             IN     VARCHAR2,
   destination_                IN     VARCHAR2,
   order_type_                 IN     VARCHAR2,
   order_ref1_                 IN     VARCHAR2,
   order_ref2_                 IN     VARCHAR2,
   order_ref3_                 IN     VARCHAR2,
   order_ref4_                 IN     VARCHAR2,
   pick_list_no_               IN     VARCHAR2,
   shipment_id_                IN     NUMBER,   
   lot_batch_no_               IN     VARCHAR2,
   serial_no_                  IN     VARCHAR2,
   eng_chg_level_              IN     VARCHAR2,
   waiv_dev_rej_no_            IN     VARCHAR2,
   activity_seq_               IN     NUMBER,
   handling_unit_id_           IN     NUMBER,
   quantity_to_add_            IN     NUMBER,
   note_text_                  IN     VARCHAR2 DEFAULT NULL,
   reserved_by_source_db_      IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   current_transport_task_id_     NUMBER := -999999999;
   destination_db_                VARCHAR2(200);
   order_type_db_                 VARCHAR2(200);
   newrec_                        TRANSPORT_TASK_TAB%ROWTYPE;
   objid_                         TRANSPORT_TASK.objid%TYPE;
   objversion_                    TRANSPORT_TASK.objversion%TYPE;
   attr_                          VARCHAR2(2000);
   from_contract_rec_             Site_Invent_Info_API.Public_Rec;
   single_from_warehouse_id_      VARCHAR2(5);
   single_from_bay_id_            VARCHAR2(5);
   single_from_tier_id_           VARCHAR2(5);
   single_from_row_id_            VARCHAR2(5);
   single_from_bin_id_            VARCHAR2(5);
   single_to_warehouse_id_        VARCHAR2(5);
   single_to_bay_id_              VARCHAR2(5);
   single_to_tier_id_             VARCHAR2(5);
   single_to_row_id_              VARCHAR2(5);
   single_to_bin_id_              VARCHAR2(5);
   single_ref_type_               VARCHAR2(5);
   single_ref1_                   VARCHAR2(5);
   single_ref2_                   VARCHAR2(5);
   single_ref3_                   VARCHAR2(5);
   single_ref4_                   VARCHAR2(5);
   single_pick_list_no_           VARCHAR2(5);
   single_shipment_id_            VARCHAR2(5);
   single_part_no_                VARCHAR2(5);
   single_configuration_id_       VARCHAR2(5);
   single_reserved_by_source_     VARCHAR2(5);
   local_to_location_no_          VARCHAR2(35);
   forward_to_location_no_        VARCHAR2(35);
   row_single_to_warehouse_id_    VARCHAR2(5);
   curr_single_from_warehouse_id_ VARCHAR2(5);
   curr_single_from_bay_id_       VARCHAR2(5);
   curr_single_from_tier_id_      VARCHAR2(5);
   curr_single_from_row_id_       VARCHAR2(5);
   curr_single_from_bin_id_       VARCHAR2(5);
   curr_single_to_warehouse_id_   VARCHAR2(5);
   curr_single_to_bay_id_         VARCHAR2(5);
   curr_single_to_tier_id_        VARCHAR2(5);
   curr_single_to_row_id_         VARCHAR2(5);
   curr_single_to_bin_id_         VARCHAR2(5);
   row_single_from_warehouse_id_  VARCHAR2(5);
   row_single_from_bay_id_        VARCHAR2(5);
   row_single_from_tier_id_       VARCHAR2(5);
   row_single_from_row_id_        VARCHAR2(5);
   row_single_from_bin_id_        VARCHAR2(5);
   row_single_to_bay_id_          VARCHAR2(5);
   row_single_to_tier_id_         VARCHAR2(5);
   row_single_to_row_id_          VARCHAR2(5);
   row_single_to_bin_id_          VARCHAR2(5);
   from_location_group_           warehouse_bay_bin_tab.location_group%TYPE;
   from_warehouse_id_             warehouse_bay_bin_tab.warehouse_id%TYPE;
   from_bay_id_                   warehouse_bay_bin_tab.bay_id%TYPE;
   from_tier_id_                  warehouse_bay_bin_tab.tier_id%TYPE;
   from_row_id_                   warehouse_bay_bin_tab.row_id%TYPE;
   from_bin_id_                   warehouse_bay_bin_tab.bin_id%TYPE;
   to_warehouse_id_               warehouse_bay_bin_tab.warehouse_id%TYPE;
   to_bay_id_                     warehouse_bay_bin_tab.bay_id%TYPE;
   to_tier_id_                    warehouse_bay_bin_tab.tier_id%TYPE;
   to_row_id_                     warehouse_bay_bin_tab.row_id%TYPE;
   to_bin_id_                     warehouse_bay_bin_tab.bin_id%TYPE;
   row_from_location_group_       warehouse_bay_bin_tab.location_group%TYPE;
   row_from_warehouse_id_         warehouse_bay_bin_tab.warehouse_id%TYPE;
   row_from_bay_id_               warehouse_bay_bin_tab.bay_id%TYPE;
   row_from_tier_id_              warehouse_bay_bin_tab.tier_id%TYPE;
   row_from_row_id_               warehouse_bay_bin_tab.row_id%TYPE;
   row_from_bin_id_               warehouse_bay_bin_tab.bin_id%TYPE;
   row_to_warehouse_id_           warehouse_bay_bin_tab.warehouse_id%TYPE;
   row_to_bay_id_                 warehouse_bay_bin_tab.bay_id%TYPE;
   row_to_tier_id_                warehouse_bay_bin_tab.tier_id%TYPE;
   row_to_row_id_                 warehouse_bay_bin_tab.row_id%TYPE;
   row_to_bin_id_                 warehouse_bay_bin_tab.bin_id%TYPE;
   indrec_                        Indicator_Rec;
   
   CURSOR get_task_id IS
      SELECT ttl.transport_task_id,
             ttl.from_contract,
             ttl.from_location_no,
             ttl.to_contract,
             ttl.to_location_no,
             ttl.forward_to_location_no
        FROM TRANSPORT_TASK_TAB tt,
             transport_task_line_tab ttl
      WHERE tt.transport_task_id                    = ttl.transport_task_id
        AND ((ttl.part_no                           = part_no_         ) OR (single_part_no_                = db_false_))
        AND ((ttl.configuration_id                  = configuration_id_) OR (single_configuration_id_       = db_false_))
        AND ((NVL(ttl.order_ref4,           number_null_)   = NVL(order_ref4_   ,         number_null_)) OR (single_ref4_                = db_false_))
        AND ((NVL(ttl.order_ref3,           string_null_)   = NVL(order_ref3_   ,         string_null_)) OR (single_ref3_                = db_false_))
        AND ((NVL(ttl.order_ref2,           string_null_)   = NVL(order_ref2_   ,         string_null_)) OR (single_ref2_                = db_false_))
        AND ((NVL(ttl.order_ref1,           string_null_)   = NVL(order_ref1_   ,         string_null_)) OR (single_ref1_                = db_false_))
        AND ((NVL(ttl.pick_list_no,         string_null_)   = NVL(pick_list_no_ ,         string_null_)) OR (single_pick_list_no_        = db_false_))
        AND ((NVL(ttl.shipment_id,          number_null_)   = NVL(shipment_id_  ,         number_null_)) OR (single_shipment_id_         = db_false_))        
        AND ((NVL(ttl.order_type,           string_null_)   = NVL(order_type_db_,         string_null_)) OR (single_ref_type_            = db_false_))
        AND ((NVL(ttl.reserved_by_source,   string_null_)   = NVL(reserved_by_source_db_, string_null_)) OR (single_reserved_by_source_  = db_false_))
        AND tt.printed_flag                         = 0
        AND tt.fixed                                = db_false_
        AND ttl.destination                         = destination_db_
        AND ttl.to_contract                         = to_contract_
        AND ttl.from_contract                       = from_contract_
        AND ttl.transport_task_status               = Transport_Task_Status_API.DB_CREATED        
      ORDER BY ttl.transport_task_id;
BEGIN    
   local_to_location_no_ := to_location_no_;
   order_type_db_        := Order_Type_API.Encode(order_type_);
   destination_db_       := Inventory_Part_Destination_API.Encode(destination_);
   
   Transport_Task_Manager_API.Set_Transport_Locations(forward_to_location_no_ => forward_to_location_no_,
                                                      to_location_no_         => local_to_location_no_,
                                                      from_contract_          => from_contract_,
                                                      from_location_no_       => from_location_no_,
                                                      to_contract_            => to_contract_,
                                                      part_no_                => part_no_,
                                                      configuration_id_       => configuration_id_,
                                                      order_type_             => order_type_db_,
                                                      order_ref1_             => order_ref1_,   
                                                      order_ref2_             => order_ref2_,
                                                      order_ref3_             => order_ref3_,
                                                      order_ref4_             => order_ref4_,
                                                      pick_list_no_           => pick_list_no_,
                                                      shipment_id_            => shipment_id_,
                                                      lot_batch_no_           => lot_batch_no_,
                                                      serial_no_              => serial_no_,
                                                      eng_chg_level_          => eng_chg_level_,
                                                      waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                      quantity_               => quantity_to_add_,
                                                      activity_seq_           => activity_seq_,
                                                      handling_unit_id_       => handling_unit_id_,
                                                      allways_use_drop_off_   => TRUE,
                                                      reserved_by_source_db_  => reserved_by_source_db_);

   Warehouse_Bay_Bin_API.Get_Location_Strings(from_warehouse_id_,
                                              from_bay_id_,
                                              from_tier_id_,
                                              from_row_id_,
                                              from_bin_id_,
                                              from_contract_,
                                              from_location_no_);

   Warehouse_Bay_Bin_API.Get_Location_Strings(to_warehouse_id_,
                                              to_bay_id_,
                                              to_tier_id_,
                                              to_row_id_,
                                              to_bin_id_,
                                              to_contract_,
                                              local_to_location_no_);

   from_location_group_ := Warehouse_Bay_Bin_API.Get_Location_Group(from_contract_,
                                                                    from_warehouse_id_,
                                                                    from_bay_id_,
                                                                    from_tier_id_,
                                                                    from_row_id_,
                                                                    from_bin_id_);

   from_contract_rec_ := Site_Invent_Info_API.Get(from_contract_);

   Get_Whse_Cons_Level_Flags___(single_from_warehouse_id_,
                                single_from_bay_id_,
                                single_from_tier_id_,
                                single_from_row_id_,
                                single_from_bin_id_,
                                Warehouse_API.Get_Transport_From_Whse_Lvl_Db(from_contract_, from_warehouse_id_));

   Get_Whse_Cons_Level_Flags___(single_to_warehouse_id_,
                                single_to_bay_id_,
                                single_to_tier_id_,
                                single_to_row_id_,
                                single_to_bin_id_,
                                Warehouse_API.Get_Transport_To_Whse_Lvl_Db(to_contract_, to_warehouse_id_));

   Get_Part_Cons_Level_Flags___(single_part_no_,
                                single_configuration_id_,
                                from_contract_rec_.transport_part_cons_level);

   Get_Ref_Cons_Level_Flags___(single_ref_type_,
                               single_ref1_,
                               single_ref2_,
                               single_ref3_,
                               single_ref4_,
                               single_pick_list_no_,
                               single_shipment_id_,
                               single_reserved_by_source_,
                               from_contract_rec_.transport_ref_cons_level);
                                 
   FOR rec_ IN get_task_id LOOP
      Warehouse_Bay_Bin_API.Get_Location_Strings(row_from_warehouse_id_,
                                                 row_from_bay_id_,
                                                 row_from_tier_id_,
                                                 row_from_row_id_,
                                                 row_from_bin_id_,
                                                 rec_.from_contract,
                                                 rec_.from_location_no);
      
      Warehouse_Bay_Bin_API.Get_Location_Strings(row_to_warehouse_id_,
                                                 row_to_bay_id_,
                                                 row_to_tier_id_,
                                                 row_to_row_id_,
                                                 row_to_bin_id_,
                                                 rec_.to_contract,
                                                 rec_.to_location_no);
         
      Get_Whse_Cons_Level_Flags___(row_single_from_warehouse_id_,
                                   row_single_from_bay_id_,
                                   row_single_from_tier_id_,
                                   row_single_from_row_id_,
                                   row_single_from_bin_id_,
                                   Warehouse_API.Get_Transport_From_Whse_Lvl_Db(rec_.from_contract, row_from_warehouse_id_));

      Get_Whse_Cons_Level_Flags___(row_single_to_warehouse_id_,
                                   row_single_to_bay_id_,
                                   row_single_to_tier_id_,
                                   row_single_to_row_id_,
                                   row_single_to_bin_id_,
                                   Warehouse_API.Get_Transport_To_Whse_Lvl_Db(rec_.to_contract, row_to_warehouse_id_));

      -- Take the most restricted setting from either existing row or new transport request and use as current
      curr_single_from_warehouse_id_ := CASE single_from_warehouse_id_ WHEN db_true_ THEN db_true_ ELSE row_single_from_warehouse_id_ END;
      curr_single_from_bay_id_       := CASE single_from_bay_id_       WHEN db_true_ THEN db_true_ ELSE row_single_from_bay_id_       END;
      curr_single_from_row_id_       := CASE single_from_row_id_       WHEN db_true_ THEN db_true_ ELSE row_single_from_row_id_       END;
      curr_single_from_tier_id_      := CASE single_from_tier_id_      WHEN db_true_ THEN db_true_ ELSE row_single_from_tier_id_      END;
      curr_single_from_bin_id_       := CASE single_from_bin_id_       WHEN db_true_ THEN db_true_ ELSE row_single_from_bin_id_       END;
      curr_single_to_warehouse_id_   := CASE single_to_warehouse_id_   WHEN db_true_ THEN db_true_ ELSE row_single_to_warehouse_id_   END;
      curr_single_to_bay_id_         := CASE single_to_bay_id_         WHEN db_true_ THEN db_true_ ELSE row_single_to_bay_id_         END;
      curr_single_to_row_id_         := CASE single_to_row_id_         WHEN db_true_ THEN db_true_ ELSE row_single_to_row_id_         END;
      curr_single_to_tier_id_        := CASE single_to_tier_id_        WHEN db_true_ THEN db_true_ ELSE row_single_to_tier_id_        END;
      curr_single_to_bin_id_         := CASE single_to_bin_id_         WHEN db_true_ THEN db_true_ ELSE row_single_to_bin_id_         END;

      row_from_location_group_ := Warehouse_Bay_Bin_API.Get_Location_Group(rec_.from_contract,
                                                                           row_from_warehouse_id_,
                                                                           row_from_bay_id_,
                                                                           row_from_tier_id_,
                                                                           row_from_row_id_,
                                                                           row_from_bin_id_);

      IF (((row_from_warehouse_id_  = from_warehouse_id_) OR (curr_single_from_warehouse_id_ = db_false_)) AND
          ((row_from_bay_id_        = from_bay_id_      ) OR (curr_single_from_bay_id_       = db_false_)) AND
          ((row_from_tier_id_       = from_tier_id_     ) OR (curr_single_from_tier_id_      = db_false_)) AND
          ((row_from_row_id_        = from_row_id_      ) OR (curr_single_from_row_id_       = db_false_)) AND
          ((row_from_bin_id_        = from_bin_id_      ) OR (curr_single_from_bin_id_       = db_false_)) AND
          ((row_to_warehouse_id_    = to_warehouse_id_  ) OR (curr_single_to_warehouse_id_   = db_false_)) AND
          ((row_to_bay_id_          = to_bay_id_        ) OR (curr_single_to_bay_id_         = db_false_)) AND
          ((row_to_tier_id_         = to_tier_id_       ) OR (curr_single_to_tier_id_        = db_false_)) AND
          ((row_to_row_id_          = to_row_id_        ) OR (curr_single_to_row_id_         = db_false_)) AND
          ((row_to_bin_id_          = to_bin_id_        ) OR (curr_single_to_bin_id_         = db_false_)) AND
          (row_from_location_group_ = from_location_group_)) THEN

         IF (rec_.transport_task_id != current_transport_task_id_) THEN
            IF (NOT Transport_Task_Manager_API.Warehouse_Task_Is_Started_(rec_.transport_task_id)) THEN
               IF (NOT Has_Picked_Or_Executed_Line(rec_.transport_task_id)) THEN
                  transport_task_id_ := rec_.transport_task_id;
                  EXIT;
               END IF;
            END IF;
            current_transport_task_id_ := rec_.transport_task_id;
         END IF;
      END IF;
   END LOOP;

   IF (transport_task_id_ IS NULL) THEN
      -- Add new transport task
      IF (note_text_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('NOTE_TEXT', note_text_, attr_);
      END IF;

      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

      transport_task_id_ := newrec_.transport_task_id;
   END IF;
   
   Set_Split_By_Hu_Capacity(transport_task_id_, TRUE);
END Find_Or_Create_New_Task;


PROCEDURE New_Or_Add_To_Existing (
   transport_task_id_             OUT NUMBER,
   quantity_added_                OUT NUMBER,
   serials_added_                 OUT Part_Serial_Catalog_API.Serial_No_Tab,
   part_no_                    IN     VARCHAR2,
   configuration_id_           IN     VARCHAR2,
   from_contract_              IN     VARCHAR2,
   from_location_no_           IN     VARCHAR2,
   to_contract_                IN     VARCHAR2,
   to_location_no_             IN     VARCHAR2,
   destination_                IN     VARCHAR2,
   order_type_                 IN     VARCHAR2,
   order_ref1_                 IN     VARCHAR2,
   order_ref2_                 IN     VARCHAR2,
   order_ref3_                 IN     VARCHAR2,
   order_ref4_                 IN     VARCHAR2,
   pick_list_no_               IN     VARCHAR2,
   shipment_id_                IN     NUMBER,   
   lot_batch_no_               IN     VARCHAR2,
   serial_no_tab_              IN     Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_              IN     VARCHAR2,
   waiv_dev_rej_no_            IN     VARCHAR2,
   activity_seq_               IN     NUMBER,
   handling_unit_id_           IN     NUMBER,
   quantity_to_add_            IN     NUMBER,
   requested_date_finished_    IN     DATE     DEFAULT NULL,
   note_text_                  IN     VARCHAR2 DEFAULT NULL,
   allow_deviating_avail_ctrl_ IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   reserved_by_source_db_      IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   check_storage_requirements_ IN     BOOLEAN  DEFAULT FALSE)
IS
   destination_db_                VARCHAR2(200);
   order_type_db_                 VARCHAR2(200);
   local_serial_no_               transport_task_line_tab.serial_no%TYPE := '*';
   local_to_location_no_          VARCHAR2(35);
   forward_to_location_no_        VARCHAR2(35);
   move_reservation_option_db_    VARCHAR2(20);
   reserved_stock_rec_            Inv_Part_Stock_Reservation_API.Inv_Part_In_Stock_Res_Rec;
BEGIN
   local_to_location_no_ := to_location_no_;
   
   IF (serial_no_tab_.COUNT > 0) THEN
      local_serial_no_ := serial_no_tab_(serial_no_tab_.FIRST).serial_no;
   END IF;
   
   order_type_db_  := Order_Type_API.Encode(order_type_);
   destination_db_ := Inventory_Part_Destination_API.Encode(destination_);
      
   -- Validation to check Reserved Stock can be moved and lock
   IF (reserved_by_source_db_ = Fnd_Boolean_API.DB_TRUE) THEN
      move_reservation_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(from_contract_);
      reserved_stock_rec_  := Inv_Part_Stock_Reservation_API.Lock_And_Get_From_Source(contract_                    => from_contract_, 
                                                                                      part_no_                     => part_no_,
                                                                                      configuration_id_            => configuration_id_,
                                                                                      location_no_                 => from_location_no_,
                                                                                      lot_batch_no_                => lot_batch_no_,
                                                                                      serial_no_                   => local_serial_no_,
                                                                                      eng_chg_level_               => eng_chg_level_,
                                                                                      waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                                      activity_seq_                => activity_seq_,
                                                                                      handling_unit_id_            => handling_unit_id_,
                                                                                      order_ref1_                  => order_ref1_,
                                                                                      order_ref2_                  => order_ref2_,
                                                                                      order_ref3_                  => order_ref3_,
                                                                                      order_ref4_                  => order_ref4_,
                                                                                      pick_list_no_                => pick_list_no_,
                                                                                      shipment_id_                 => shipment_id_,                                                                                                                                                                                                                          
                                                                                      order_supply_demand_type_db_ => Order_Type_API.Get_Order_Suppl_Demand_Type_Db(order_type_db_));
      IF (order_type_db_ != Order_Type_API.DB_WORK_TASK) THEN                                                                                  
         Invent_Part_Quantity_Util_API.Validate_Move_Reservation(move_reservation_option_db_ => move_reservation_option_db_,
                                                                 reserved_stock_rec_         => reserved_stock_rec_,
                                                                 calling_process_            => Invent_Part_Quantity_Util_API.new_or_add_to_transport_task_ );
      END IF;
   END IF;
   
   Find_Or_Create_New_Task(transport_task_id_        => transport_task_id_,
                           part_no_                  => part_no_,
                           configuration_id_         => configuration_id_,
                           from_contract_            => from_contract_,
                           from_location_no_         => from_location_no_,
                           to_contract_              => to_contract_,
                           to_location_no_           => to_location_no_,
                           destination_              => destination_,
                           order_type_               => order_type_,
                           order_ref1_               => order_ref1_,
                           order_ref2_               => order_ref2_,
                           order_ref3_               => order_ref3_,
                           order_ref4_               => order_ref4_,
                           pick_list_no_             => pick_list_no_,
                           shipment_id_              => shipment_id_,   
                           lot_batch_no_             => lot_batch_no_,
                           serial_no_                => local_serial_no_,
                           eng_chg_level_            => eng_chg_level_,
                           waiv_dev_rej_no_          => waiv_dev_rej_no_,
                           activity_seq_             => activity_seq_,
                           handling_unit_id_         => handling_unit_id_,
                           quantity_to_add_          => quantity_to_add_,
                           note_text_                => note_text_,
                           reserved_by_source_db_    => reserved_by_source_db_);
   
   Transport_Task_Manager_API.Set_Transport_Locations(forward_to_location_no_ => forward_to_location_no_,
                                                      to_location_no_         => local_to_location_no_,
                                                      from_contract_          => from_contract_,
                                                      from_location_no_       => from_location_no_,
                                                      to_contract_            => to_contract_,
                                                      part_no_                => part_no_,
                                                      configuration_id_       => configuration_id_,
                                                      order_type_             => order_type_db_,
                                                      order_ref1_             => order_ref1_,   
                                                      order_ref2_             => order_ref2_,
                                                      order_ref3_             => order_ref3_,
                                                      order_ref4_             => order_ref4_,
                                                      pick_list_no_           => pick_list_no_,
                                                      shipment_id_            => shipment_id_,
                                                      lot_batch_no_           => lot_batch_no_,
                                                      serial_no_              => local_serial_no_,
                                                      eng_chg_level_          => eng_chg_level_,
                                                      waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                      quantity_               => quantity_to_add_,
                                                      activity_seq_           => activity_seq_,
                                                      handling_unit_id_       => handling_unit_id_,
                                                      allways_use_drop_off_   => TRUE,
                                                      reserved_by_source_db_  => reserved_by_source_db_);

   Transport_Task_Line_API.New_Or_Add_To_Existing_(quantity_added_             => quantity_added_,
                                                   serials_added_              => serials_added_,
                                                   transport_task_id_          => transport_task_id_,
                                                   part_no_                    => part_no_,
                                                   configuration_id_           => configuration_id_,
                                                   from_contract_              => from_contract_,
                                                   from_location_no_           => from_location_no_,
                                                   to_contract_                => to_contract_,
                                                   to_location_no_             => local_to_location_no_,
                                                   forward_to_location_no_     => forward_to_location_no_,
                                                   destination_db_             => destination_db_,
                                                   order_type_db_              => order_type_db_,
                                                   order_ref1_                 => order_ref1_,
                                                   order_ref2_                 => order_ref2_,
                                                   order_ref3_                 => order_ref3_,
                                                   order_ref4_                 => order_ref4_,
                                                   pick_list_no_               => pick_list_no_,
                                                   shipment_id_                => shipment_id_,                                                   
                                                   lot_batch_no_               => lot_batch_no_,
                                                   serial_no_tab_              => serial_no_tab_,
                                                   eng_chg_level_              => eng_chg_level_,
                                                   waiv_dev_rej_no_            => waiv_dev_rej_no_,
                                                   activity_seq_               => activity_seq_,
                                                   handling_unit_id_           => handling_unit_id_,
                                                   quantity_to_add_            => quantity_to_add_,
                                                   catch_quantity_to_add_      => NULL,
                                                   requested_date_finished_    => requested_date_finished_,
                                                   allow_deviating_avail_ctrl_ => allow_deviating_avail_ctrl_,
                                                   reserved_by_source_db_      => reserved_by_source_db_,
                                                   check_storage_requirements_ => check_storage_requirements_);
END New_Or_Add_To_Existing;


-- Get_Qty_Inbound
--   Returns the current inbound quantity for a part on a specific site and location.
--   That is the quantity on transport tasks intended for the specified location.
@UncheckedAccess
FUNCTION Get_Qty_Inbound (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   to_contract_      IN VARCHAR2,
   to_location_no_   IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2 DEFAULT NULL,
   serial_no_        IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_    IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_  IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   qty_inbound_ NUMBER;
BEGIN
   qty_inbound_ := Transport_Task_Line_API.Get_Qty_Inbound_(part_no_          => part_no_,
                                                                  configuration_id_ => configuration_id_,
                                                                  to_contract_      => to_contract_,
                                                                  to_location_no_   => to_location_no_,
                                                                  lot_batch_no_     => lot_batch_no_,
                                                                  serial_no_        => serial_no_,
                                                                  eng_chg_level_    => eng_chg_level_,
                                                                  waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                  activity_seq_     => NULL,
                                                                  handling_unit_id_ => NULL); 

   RETURN (qty_inbound_);
END Get_Qty_Inbound;


@UncheckedAccess
FUNCTION Inbound_Task_Exist (
   part_no_     IN VARCHAR2,
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_              NUMBER;
   inbound_task_exist_ BOOLEAN := FALSE;
   
   CURSOR exist_control IS
      SELECT 1
      FROM  transport_task_line_tab
      WHERE part_no               = part_no_
      AND  ((forward_to_location_no = location_no_) OR (to_location_no = location_no_ AND forward_to_location_no IS NULL))
      AND   to_contract           = contract_
      AND  transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      inbound_task_exist_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN inbound_task_exist_;
END Inbound_Task_Exist;


-- Check_Unexecuted_Tasks
--   Return 'TRUE' if there are any open transoirt tasks with the given part
--   in any site. Otherwise return 'FALSE'
@UncheckedAccess
FUNCTION Check_Unexecuted_Tasks (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_         NUMBER;
   return_value_ VARCHAR2(5);

   CURSOR get_tasks IS
      SELECT 1 
      FROM transport_task_line_tab
      WHERE part_no = part_no_
        AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
    OPEN get_tasks;
    FETCH get_tasks INTO temp_;
    IF get_tasks%FOUND THEN
       return_value_ := db_true_;
    ELSE
       return_value_ := db_false_;
    END IF;
    CLOSE get_tasks;

    RETURN return_value_;
END Check_Unexecuted_Tasks;


@UncheckedAccess
FUNCTION Is_Inter_Site (
   transport_task_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_         NUMBER;
   is_inter_site_ VARCHAR2(5) := db_false_;

   CURSOR inter_site_line_exists IS
      SELECT 1
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_
        AND to_contract != from_contract;
BEGIN
   OPEN  inter_site_line_exists;
   FETCH inter_site_line_exists INTO dummy_;
   IF (inter_site_line_exists%FOUND) THEN
      is_inter_site_ := db_true_;
   END IF;
   CLOSE inter_site_line_exists;

   RETURN (is_inter_site_);
END Is_Inter_Site;


@UncheckedAccess
FUNCTION Get_No_Of_Unidentified_Serials (
   transport_task_id_  IN NUMBER,
   only_status_picked_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE ) RETURN NUMBER
IS
   no_of_unidentified_serials_ NUMBER := 0;

   CURSOR get_no_of_unidentified_serials IS
      SELECT part_no, quantity, transport_task_status
        FROM transport_task_line_tab
       WHERE transport_task_id      = transport_task_id_
         AND serial_no              = '*'
         AND from_contract         != to_contract
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN   
   FOR rec_ IN get_no_of_unidentified_serials LOOP
      IF ((rec_.transport_task_status = Transport_Task_Status_API.DB_PICKED) OR
          (only_status_picked_        = Fnd_Boolean_API.DB_FALSE)) THEN
         IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(rec_.part_no)) THEN
            no_of_unidentified_serials_ := no_of_unidentified_serials_ + rec_.quantity;
         END IF;
      END IF;
   END LOOP;

   RETURN (no_of_unidentified_serials_);
END Get_No_Of_Unidentified_Serials;


FUNCTION Get_Booked_Carrying_Capacity (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   booked_carrying_capacity_ NUMBER;
BEGIN
   booked_carrying_capacity_ := Get_Booked_Storage_Capacity___(contract_                     => contract_,
                                                               warehouse_id_                 => warehouse_id_,
                                                               bay_id_                       => bay_id_,
                                                               tier_id_                      => tier_id_,
                                                               row_id_                       => row_id_,
                                                               bin_id_                       => bin_id_,
                                                               unit_type_db_                 => Iso_Unit_Type_API.DB_WEIGHT,
                                                               ignore_this_handling_unit_id_ => ignore_this_handling_unit_id_);
   RETURN (booked_carrying_capacity_);
END Get_Booked_Carrying_Capacity;


FUNCTION Get_Booked_Volume_Capacity (
   contract_                     IN VARCHAR2,
   warehouse_id_                 IN VARCHAR2,
   bay_id_                       IN VARCHAR2,
   tier_id_                      IN VARCHAR2,
   row_id_                       IN VARCHAR2,
   bin_id_                       IN VARCHAR2,
   ignore_this_handling_unit_id_ IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   booked_volume_capacity_ NUMBER;
BEGIN
   booked_volume_capacity_ := Get_Booked_Storage_Capacity___(contract_                     => contract_,
                                                             warehouse_id_                 => warehouse_id_,
                                                             bay_id_                       => bay_id_,
                                                             tier_id_                      => tier_id_,
                                                             row_id_                       => row_id_,
                                                             bin_id_                       => bin_id_,
                                                             unit_type_db_                 => Iso_Unit_Type_API.DB_VOLUME,
                                                             ignore_this_handling_unit_id_ => ignore_this_handling_unit_id_);
   RETURN (booked_volume_capacity_);
END Get_Booked_Volume_Capacity;


@UncheckedAccess
FUNCTION Get_Qty_Outbound (
   from_contract_          IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   from_location_no_       IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2 DEFAULT NULL,
   serial_no_              IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_          IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_        IN VARCHAR2 DEFAULT NULL,
   activity_seq_           IN NUMBER   DEFAULT NULL,
   handling_unit_id_       IN NUMBER   DEFAULT NULL,
   order_ref1_             IN VARCHAR2 DEFAULT NULL,
   order_ref2_             IN VARCHAR2 DEFAULT NULL,
   order_ref3_             IN VARCHAR2 DEFAULT NULL,
   order_ref4_             IN NUMBER   DEFAULT NULL,
   pick_list_no_           IN VARCHAR2 DEFAULT NULL,
   shipment_id_            IN NUMBER   DEFAULT NULL,   
   order_type_db_          IN VARCHAR2 DEFAULT NULL,
   reserved_by_source_db_  IN VARCHAR2 DEFAULT NULL,
   include_unpicked_lines_ IN BOOLEAN  DEFAULT TRUE ) RETURN NUMBER
IS
   qty_outbound_     NUMBER;
BEGIN
   qty_outbound_ := Transport_Task_Line_API.Get_Qty_Outbound_(part_no_,
                                                            configuration_id_,
                                                            from_contract_,
                                                            from_location_no_,
                                                            lot_batch_no_,
                                                            serial_no_,
                                                            eng_chg_level_,
                                                            waiv_dev_rej_no_,
                                                            NULL,
                                                            handling_unit_id_,
                                                            order_ref1_,
                                                            order_ref2_,
                                                            order_ref3_,
                                                            order_ref4_,
                                                            pick_list_no_,
                                                            shipment_id_,
                                                            order_type_db_,
                                                            reserved_by_source_db_,
                                                            include_unpicked_lines_);

   RETURN (qty_outbound_);
END Get_Qty_Outbound;


@UncheckedAccess
FUNCTION Other_Parts_Are_Inbound (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_                   NUMBER;
   other_parts_are_inbound_ BOOLEAN := FALSE;
   
   CURSOR exist_control IS
      SELECT 1
      FROM  transport_task_line_tab
      WHERE part_no              != part_no_
      AND   to_location_no        = location_no_
      AND   to_contract           = contract_
      AND   transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      other_parts_are_inbound_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN (other_parts_are_inbound_);
END Other_Parts_Are_Inbound;


@UncheckedAccess
FUNCTION Any_Parts_Are_Inbound (
   contract_    IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_                 NUMBER;
   any_parts_are_inbound_ BOOLEAN := FALSE;
   
   CURSOR exist_control IS
      SELECT 1
      FROM  transport_task_line_tab
      WHERE (to_location_no         = location_no_ OR 
             forward_to_location_no = location_no_)
       AND   to_contract            = contract_
       AND   transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      any_parts_are_inbound_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN (any_parts_are_inbound_);
END Any_Parts_Are_Inbound;


@UncheckedAccess
FUNCTION Other_Conditions_Are_Inbound (
   condition_code_ IN VARCHAR2,
   contract_       IN VARCHAR2,
   location_no_    IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Transport_Task_Line_API.Other_Conditions_Are_Inbound(condition_code_, contract_, location_no_));
END Other_Conditions_Are_Inbound;


@UncheckedAccess
FUNCTION Other_Lots_Are_Inbound (
   contract_       IN VARCHAR2,
   part_no_        IN VARCHAR2,
   lot_batch_no_   IN VARCHAR2,
   location_no_    IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Transport_Task_Line_API.Other_Lots_Are_Inbound(contract_, part_no_, lot_batch_no_, location_no_));
END Other_Lots_Are_Inbound;


PROCEDURE Remove (
   transport_task_id_ IN NUMBER )
IS
   remrec_ TRANSPORT_TASK_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(transport_task_id_);
   Check_And_Delete___(remrec_);
END Remove;


PROCEDURE Remove_Unexecuted_Tasks (
   order_ref1_            IN VARCHAR2,
   order_ref2_            IN VARCHAR2,
   order_ref3_            IN VARCHAR2,
   order_ref4_            IN VARCHAR2,   
   pick_list_no_          IN VARCHAR2,
   shipment_id_           IN NUMBER,   
   order_type_db_         IN VARCHAR2,
   reserved_by_source_db_ IN VARCHAR2)
IS
   CURSOR get_unexecuted_lines IS
      SELECT transport_task_id, line_no
        FROM transport_task_line_tab
       WHERE order_ref1             = order_ref1_
         AND (order_ref2            = order_ref2_             OR order_ref2_            IS NULL)
         AND (order_ref3            = order_ref3_             OR order_ref3_            IS NULL)
         AND (order_ref4            = order_ref4_             OR order_ref4_            IS NULL)
         AND (pick_list_no          = pick_list_no_           OR pick_list_no_          IS NULL)
         AND (shipment_id           = shipment_id_            OR shipment_id_           IS NULL)
         AND (reserved_by_source    = reserved_by_source_db_  OR reserved_by_source_db_ IS NULL)
         AND  order_type            = order_type_db_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
      ORDER BY transport_task_id, line_no;
BEGIN
   FOR line_rec_ IN get_unexecuted_lines LOOP
      Transport_Task_Line_API.Remove(line_rec_.transport_task_id,
                                     line_rec_.line_no,
                                     CASE reserved_by_source_db_ WHEN Fnd_Boolean_API.DB_TRUE  THEN FALSE
                                                                 WHEN Fnd_Boolean_API.DB_FALSE THEN TRUE END);
   END LOOP;
END Remove_Unexecuted_Tasks;


PROCEDURE Reduce_Qty_On_Unexecuted_Tasks (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   location_no_            IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN NUMBER,
   quantity_               IN NUMBER,
   catch_quantity_         IN NUMBER,
   order_ref1_             IN VARCHAR2,
   order_ref2_             IN VARCHAR2,
   order_ref3_             IN VARCHAR2,
   order_ref4_             IN VARCHAR2,
   pick_list_no_           IN VARCHAR2,
   shipment_id_            IN NUMBER,   
   order_type_db_          IN VARCHAR2,
   reserved_by_source_db_  IN VARCHAR2 )
IS
   qty_reduced_             NUMBER;
   qty_to_be_reduced_       NUMBER;
   catch_qty_reduced_       NUMBER;
   catch_qty_to_be_reduced_ NUMBER;

   CURSOR get_unexecuted_lines  IS
      SELECT transport_task_id, line_no
        FROM transport_task_line_tab
       WHERE  order_ref1            = order_ref1_
         AND  order_ref2            = order_ref2_
         AND (NVL(order_ref3, string_null_)   = NVL(order_ref3_, string_null_))
         AND (NVL(order_ref4, number_null_)   = NVL(order_ref4_, number_null_))
         AND (NVL(pick_list_no, string_null_) = NVL(pick_list_no_, string_null_))
         AND (NVL(shipment_id, number_null_)  = NVL(shipment_id_, number_null_))         
         AND  order_type            = order_type_db_
         AND  part_no               = part_no_
         AND  configuration_id      = configuration_id_
         AND  from_contract         = contract_
         AND  from_location_no      = location_no_
         AND  lot_batch_no          = lot_batch_no_
         AND  serial_no             = serial_no_
         AND  eng_chg_level         = eng_chg_level_
         AND  waiv_dev_rej_no       = waiv_dev_rej_no_
         AND  activity_seq          = activity_seq_
         AND  handling_unit_id      = handling_unit_id_
         AND  reserved_by_source    = reserved_by_source_db_
         AND  transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
      FOR UPDATE;
BEGIN
   qty_to_be_reduced_       := quantity_;
   catch_qty_to_be_reduced_ := catch_quantity_;

   FOR line_rec_ IN get_unexecuted_lines LOOP
      Transport_Task_Line_API.Reduce_Quantity(qty_reduced_,
                                             catch_qty_reduced_,
                                             line_rec_.transport_task_id,
                                             line_rec_.line_no,
                                             qty_to_be_reduced_,
                                             catch_qty_to_be_reduced_);

      qty_to_be_reduced_       := qty_to_be_reduced_       - qty_reduced_;
      catch_qty_to_be_reduced_ := catch_qty_to_be_reduced_ - catch_qty_reduced_;
      EXIT WHEN qty_to_be_reduced_ = 0;
   END LOOP;
END Reduce_Qty_On_Unexecuted_Tasks;


@UncheckedAccess
FUNCTION Is_Fixed (
   transport_task_id_ IN NUMBER ) RETURN BOOLEAN
IS
   is_fixed_ BOOLEAN := FALSE;
   rec_      TRANSPORT_TASK_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(transport_task_id_);

   IF (rec_.fixed = db_true_) THEN
      is_fixed_ := TRUE;
   END IF;

   RETURN (is_fixed_);
END Is_Fixed;


PROCEDURE Lock_By_Keys_Wait (
   transport_task_id_ IN NUMBER )
IS
   dummy_ TRANSPORT_TASK_TAB%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Keys___(transport_task_id_);
END Lock_By_Keys_Wait;


PROCEDURE New (
   transport_task_id_ IN OUT NUMBER )
IS
   newrec_     TRANSPORT_TASK_TAB%ROWTYPE;
   objid_      TRANSPORT_TASK.objid%TYPE;
   objversion_ TRANSPORT_TASK.objversion%TYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('TRANSPORT_TASK_ID', transport_task_id_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   transport_task_id_ := newrec_.transport_task_id;
END New;


@UncheckedAccess
FUNCTION Check_Exist (
   transport_task_id_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Check_Exist___(transport_task_id_));
END Check_Exist;


PROCEDURE Set_As_Fixed (
   transport_task_id_ IN NUMBER )
IS
   objid_      TRANSPORT_TASK.objid%TYPE;
   objversion_ TRANSPORT_TASK.objversion%TYPE;
   newrec_     TRANSPORT_TASK_TAB%ROWTYPE;
   oldrec_     TRANSPORT_TASK_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(transport_task_id_);

   IF (oldrec_.fixed != db_true_) THEN

      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('FIXED_DB', db_true_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- By keys.
   END IF;
END Set_As_Fixed;


-- Check_Start_Warehouse_Task
--   Implements logic to approve disapprove start of warehouse tasks
PROCEDURE Check_Start_Warehouse_Task (
   transport_task_id_ IN NUMBER )
IS
   CURSOR get_lines IS
      SELECT *
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_;
BEGIN
   FOR line_rec_ IN get_lines LOOP
      IF (Inventory_Part_In_Stock_API.Is_Frozen_For_Counting(line_rec_.from_contract, 
                                                             line_rec_.part_no, 
                                                             line_rec_.configuration_id, 
                                                             line_rec_.from_location_no, 
                                                             line_rec_.lot_batch_no, 
                                                             line_rec_.serial_no, 
                                                             line_rec_.eng_chg_level,
                                                             line_rec_.waiv_dev_rej_no, 
                                                             line_rec_.activity_seq,
                                                             line_rec_.handling_unit_id)) THEN
         Error_SYS.Record_General(lu_name_, 
                                  'FREEZESOURCESTOCK: The Warehouse Task cannot be started since the source stock record for Line :P1 on Transport Task :P2 is frozen for counting.',
                                  line_rec_.line_no, 
                                  line_rec_.transport_task_id);
      END IF;

      IF (line_rec_.destination = Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY) THEN
         IF (Inventory_Part_In_Stock_API.Is_Frozen_For_Counting(line_rec_.to_contract, 
                                                                line_rec_.part_no, 
                                                                line_rec_.configuration_id, 
                                                                line_rec_.to_location_no, 
                                                                line_rec_.lot_batch_no, 
                                                                line_rec_.serial_no, 
                                                                line_rec_.eng_chg_level,
                                                                line_rec_.waiv_dev_rej_no, 
                                                                line_rec_.activity_seq,
                                                                line_rec_.handling_unit_id)) THEN
            Error_SYS.Record_General(lu_name_, 
                                     'FREEZEDESTSTOCK: The Warehouse Task cannot be started since the destination stock record for Line :P1 on Transport Task :P2 is frozen for counting.',
                                     line_rec_.line_no, 
                                     line_rec_.transport_task_id);
         END IF;
      END IF;
   END LOOP;
END Check_Start_Warehouse_Task;


@UncheckedAccess
FUNCTION Has_Line_In_Status_Created (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   has_line_in_status_created_ VARCHAR2(5) := db_false_;
BEGIN
   IF Has_Line_In_Status___(transport_task_id_, Transport_Task_Status_API.DB_CREATED) THEN
      has_line_in_status_created_ := db_true_;
   END IF;

   RETURN (has_line_in_status_created_);
END Has_Line_In_Status_Created;


@UncheckedAccess
FUNCTION Has_Line_In_Status_Picked (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   has_line_in_status_created_ VARCHAR2(5) := db_false_;
BEGIN
   IF Has_Line_In_Status___(transport_task_id_, Transport_Task_Status_API.DB_PICKED) THEN
      has_line_in_status_created_ := db_true_;
   END IF;

   RETURN (has_line_in_status_created_);
END Has_Line_In_Status_Picked;


@UncheckedAccess
FUNCTION Has_Line_In_Status_Executed (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   has_line_in_status_created_ VARCHAR2(5) := db_false_;
BEGIN
   IF Has_Line_In_Status___(transport_task_id_, Transport_Task_Status_API.DB_EXECUTED) THEN
      has_line_in_status_created_ := db_true_;
   END IF;

   RETURN (has_line_in_status_created_);
END Has_Line_In_Status_Executed;


-- Is_Completely_Executed
--   Returns boolean TRUE if the transport task only has lines in status Executed.
@UncheckedAccess
FUNCTION Is_Completely_Executed (
   transport_task_id_ IN NUMBER ) RETURN BOOLEAN
IS
   is_completely_executed_ BOOLEAN := FALSE;
BEGIN
   IF (Has_Line_In_Status_Executed(transport_task_id_) = db_true_) THEN
      IF (Has_Line_In_Status_Picked(transport_task_id_) = db_false_) THEN
         IF (Has_Line_In_Status_Created(transport_task_id_) = db_false_) THEN
            is_completely_executed_ := TRUE;
         END IF;
      END IF;
   END IF;

   RETURN (is_completely_executed_);
END Is_Completely_Executed;


-- Is_Completely_Executed_Str
--   Returns FND_Boolean_API.DB_TRUE if the transport task only has lines in status Executed.
@UncheckedAccess
FUNCTION Is_Completely_Executed_Str (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   is_completely_executed_ VARCHAR2(5) := db_false_;
BEGIN
   IF (Is_Completely_Executed(transport_task_id_)) THEN
      is_completely_executed_ := db_true_;
   END IF;

   RETURN (is_completely_executed_);
END Is_Completely_Executed_Str;


-- Is_Fixed_Or_Started_Str
--   Returns string 'TRUE' if the transport task has lines that is picked or
--   executed, if the transport task is fixed, or if the transport task is connected to
--   a warehouse task that is started or parked.
@UncheckedAccess
FUNCTION Is_Fixed_Or_Started_Str (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   is_fixed_or_started_ VARCHAR2(5) := db_false_;
BEGIN
   IF (Is_Fixed_Or_Started(transport_task_id_)) THEN
      is_fixed_or_started_ := db_true_;
   END IF;
   RETURN is_fixed_or_started_;
END Is_Fixed_Or_Started_Str;


-- Is_Fixed_Or_Started
--   Returns boolean TRUE if the transport task has lines that is picked or
--   executed, if the transport task is fixed, or if the transport task is connected to
--   a warehouse task that is started or parked.
@UncheckedAccess
FUNCTION Is_Fixed_Or_Started (
   transport_task_id_ IN NUMBER ) RETURN BOOLEAN
IS
   is_fixed_or_started_ BOOLEAN := FALSE;
BEGIN
   IF ((Is_Fixed(transport_task_id_)) OR
       (Has_Line_In_Status_Executed(transport_task_id_) = db_true_) OR
       (Has_Line_In_Status_Picked(transport_task_id_) = db_true_) OR
       (Transport_Task_Manager_API.Warehouse_Task_Is_Started_(transport_task_id_))) THEN
          is_fixed_or_started_ := TRUE;
   END IF;
   RETURN is_fixed_or_started_;
END Is_Fixed_Or_Started;


-- Has_Picked_Or_Executed_Line
--   Returns TRUE if transport task has at least one line that is either picked or executed.
@UncheckedAccess
FUNCTION Has_Picked_Or_Executed_Line (
   transport_task_id_ IN NUMBER ) RETURN BOOLEAN
IS
   has_picked_or_executed_line_ BOOLEAN := FALSE;
BEGIN
   IF (Has_Line_In_Status_Picked(transport_task_id_) = db_true_ OR Has_Line_In_Status_Executed(transport_task_id_) = db_true_) THEN
      has_picked_or_executed_line_ := TRUE;
   END IF;
   RETURN has_picked_or_executed_line_;
END Has_Picked_Or_Executed_Line;


PROCEDURE Apply_Drop_Off_On_Lines (
   transport_task_id_ IN NUMBER )
IS
   info_ VARCHAR2(2000);
   CURSOR get_lines IS
      SELECT line_no
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_
      AND transport_task_status = Transport_Task_Status_API.DB_CREATED
      AND forward_to_location_no IS NULL;
BEGIN
   FOR line_rec_ IN get_lines LOOP
      Transport_Task_Line_API.Apply_Drop_Off_Location(info_, transport_task_id_, line_rec_.line_no);
   END LOOP;
END Apply_Drop_Off_On_Lines;


PROCEDURE Revoke_Two_Step_Transport_Task (
   transport_task_id_ IN NUMBER )
IS
   info_ VARCHAR2(2000);
   CURSOR get_lines IS
      SELECT line_no
      FROM transport_task_line_tab
      WHERE transport_task_id = transport_task_id_
      AND transport_task_status = Transport_Task_Status_API.DB_CREATED
      AND forward_to_location_no IS NOT NULL;
BEGIN
   FOR line_rec_ IN get_lines LOOP
      Transport_Task_Line_API.Revoke_Two_Step_Transport_Task(info_, transport_task_id_, line_rec_.line_no);
   END LOOP;
END Revoke_Two_Step_Transport_Task;


@UncheckedAccess
FUNCTION Exist_For_Order_Reference (
   order_type_            IN VARCHAR2,
   order_ref1_            IN VARCHAR2 DEFAULT NULL,
   order_ref2_            IN VARCHAR2 DEFAULT NULL,
   order_ref3_            IN VARCHAR2 DEFAULT NULL,
   order_ref4_            IN NUMBER   DEFAULT NULL,
   reserved_by_source_db_ IN VARCHAR2 DEFAULT NULL,
   pick_list_no_          IN VARCHAR2 DEFAULT NULL,
   shipment_id_           IN NUMBER   DEFAULT NULL ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR line_exist IS
      SELECT 1
      FROM   transport_task_line_tab
      WHERE  order_type           = order_type_
      AND    (order_ref1          = order_ref1_             OR order_ref1_            IS NULL)
      AND    (order_ref2          = order_ref2_             OR order_ref2_            IS NULL)
      AND    (order_ref3          = order_ref3_             OR order_ref3_            IS NULL)
      AND    (order_ref4          = order_ref4_             OR order_ref4_            IS NULL)
      AND    (reserved_by_source  = reserved_by_source_db_  OR reserved_by_source_db_ IS NULL)
      AND    (pick_list_no        = pick_list_no_           OR pick_list_no_          IS NULL)
      AND    (shipment_id         = shipment_id_            OR shipment_id_           IS NULL)      
      AND    transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN line_exist;
   FETCH line_exist INTO dummy_;
   IF (line_exist%NOTFOUND) THEN
      CLOSE line_exist;
      RETURN FALSE;
   END IF;
   CLOSE line_exist;
   RETURN TRUE;
END Exist_For_Order_Reference;


@UncheckedAccess
FUNCTION Inbound_To_Warehouse_Exist (
   contract_      IN VARCHAR2,
   warehouse_id_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_                      NUMBER;
   inbound_to_warehouse_exist_ BOOLEAN := FALSE;
   
   CURSOR exist_control IS
      SELECT 1
      FROM  transport_task_line_tab ttl,
            warehouse_bay_bin_tab wbb
      WHERE wbb.contract              = contract_
      AND   wbb.warehouse_id          = warehouse_id_
      AND   ttl.to_location_no        = wbb.location_no
      AND  ((ttl.forward_to_location_no = wbb.location_no) OR (ttl.to_location_no = wbb.location_no AND ttl.forward_to_location_no IS NULL))
      AND   ttl.to_contract           = wbb.contract
      AND   transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      inbound_to_warehouse_exist_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN inbound_to_warehouse_exist_;
END Inbound_To_Warehouse_Exist;


@UncheckedAccess
FUNCTION Get_Qty_Inbound_For_Warehouse (
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   contract_                    IN VARCHAR2,
   warehouse_id_                IN VARCHAR2,
   include_bouncing_quantities_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN NUMBER
IS
   qty_inbound_       NUMBER;
   site_warehouse_id_ VARCHAR2(100) := contract_||'^'||warehouse_id_;

   CURSOR get_quantity is
      SELECT NVL(SUM(quantity),0)
      FROM   active_warehouse_transport
      WHERE  part_no          = part_no_
      AND    configuration_id = configuration_id_
      AND    ((from_site_warehouse_id != site_warehouse_id_ AND to_site_warehouse_id  = site_warehouse_id_ AND (forward_to_site_warehouse_id IS NULL OR
                                                                                                                forward_to_site_warehouse_id  = site_warehouse_id_ OR
                                                                                                               (forward_to_site_warehouse_id != site_warehouse_id_ AND
                                                                                                                include_bouncing_quantities_  = 'TRUE'))) OR
             (to_site_warehouse_id != site_warehouse_id_ AND forward_to_site_warehouse_id  = site_warehouse_id_));
BEGIN
   OPEN  get_quantity;
   FETCH get_quantity INTO qty_inbound_;
   CLOSE get_quantity;

   RETURN qty_inbound_;
END Get_Qty_Inbound_For_Warehouse;


@UncheckedAccess
FUNCTION Get_Qty_Outbound_For_Warehouse (
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   contract_                    IN VARCHAR2,
   warehouse_id_                IN VARCHAR2 ) RETURN NUMBER
IS
   qty_outbound_      NUMBER;
   site_warehouse_id_ VARCHAR2(100) := contract_||'^'||warehouse_id_;

   CURSOR get_quantity is
      SELECT NVL(SUM(quantity),0)
      FROM   active_warehouse_transport
      WHERE  part_no          = part_no_
      AND    configuration_id = configuration_id_
      AND    ((from_site_warehouse_id  = site_warehouse_id_ AND (to_site_warehouse_id != site_warehouse_id_  OR forward_to_site_warehouse_id != site_warehouse_id_)) OR
             (from_site_warehouse_id != site_warehouse_id_ AND  to_site_warehouse_id  = site_warehouse_id_ AND forward_to_site_warehouse_id != site_warehouse_id_));
BEGIN
   OPEN  get_quantity;
   FETCH get_quantity INTO qty_outbound_;
   CLOSE get_quantity;

   RETURN qty_outbound_;
END Get_Qty_Outbound_For_Warehouse;


@UncheckedAccess
FUNCTION Get_Forward_To_Location_Type__ (
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2
IS
   forward_to_location_type_ VARCHAR2(20);

   CURSOR get_forward_to_location_type IS
      SELECT ilg.inventory_location_type
        FROM transport_task_line_tab      ttl,
             warehouse_bay_bin_tab        wbb,
             inventory_location_group_tab ilg
       WHERE ttl.transport_task_id        = transport_task_id_
         AND ttl.to_contract              = wbb.contract
         AND ttl.forward_to_location_no   = wbb.location_no
         AND ilg.location_group           = wbb.location_group;
BEGIN
   FOR rec_ IN get_forward_to_location_type LOOP
      IF (forward_to_location_type_ IS NULL) THEN
         forward_to_location_type_ := rec_.inventory_location_type;
      ELSE
         IF (forward_to_location_type_ != rec_.inventory_location_type) THEN
            forward_to_location_type_ := NULL;
            EXIT;
         END IF;
      END IF;
   END LOOP;

   RETURN (Inventory_Location_Type_API.Decode(forward_to_location_type_));
END Get_Forward_To_Location_Type__;

   
PROCEDURE Modify_Order_Reservation_Qty (
   from_contract_          IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   from_location_no_       IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN NUMBER,
   quantity_diff_          IN NUMBER,
   catch_quantity_diff_    IN NUMBER,
   order_ref1_             IN VARCHAR2,
   order_ref2_             IN VARCHAR2,
   order_ref3_             IN VARCHAR2,
   order_ref4_             IN NUMBER,
   pick_list_no_           IN VARCHAR2,
   shipment_id_            IN NUMBER,   
   order_type_db_          IN VARCHAR2 )
IS
   reservation_booked_for_transp_ BOOLEAN;
   exit_procedure_                EXCEPTION;
BEGIN
   reservation_booked_for_transp_ := Transport_Task_Line_API.Reservation_Booked_For_Transp(from_contract_         => from_contract_,
                                                                                           from_location_no_      => from_location_no_,
                                                                                           part_no_               => part_no_,
                                                                                           configuration_id_      => configuration_id_,
                                                                                           lot_batch_no_          => lot_batch_no_,
                                                                                           serial_no_             => serial_no_,
                                                                                           eng_chg_level_         => eng_chg_level_,
                                                                                           waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                                                                           activity_seq_          => activity_seq_,
                                                                                           handling_unit_id_      => handling_unit_id_,
                                                                                           order_ref1_            => order_ref1_,
                                                                                           order_ref2_            => order_ref2_,
                                                                                           order_ref3_            => order_ref3_,
                                                                                           order_ref4_            => order_ref4_,
                                                                                           pick_list_no_          => pick_list_no_,
                                                                                           shipment_id_           => shipment_id_,
                                                                                           order_type_db_         => order_type_db_ );
   IF NOT (reservation_booked_for_transp_) THEN 
      RAISE exit_procedure_;
   END IF;
      
   IF (quantity_diff_ > 0) THEN
      Increase_Qty_On_Unexecuted___(contract_                  => from_contract_,
                                    part_no_                   => part_no_,
                                    configuration_id_          => configuration_id_,
                                    location_no_               => from_location_no_,
                                    lot_batch_no_              => lot_batch_no_,
                                    serial_no_                 => serial_no_,
                                    eng_chg_level_             => eng_chg_level_,
                                    waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                    activity_seq_              => activity_seq_,
                                    handling_unit_id_          => handling_unit_id_,
                                    additional_quantity_       => quantity_diff_,
                                    additional_catch_quantity_ => catch_quantity_diff_,
                                    order_ref1_                => order_ref1_,
                                    order_ref2_                => order_ref2_,
                                    order_ref3_                => order_ref3_,
                                    order_ref4_                => order_ref4_,
                                    pick_list_no_              => pick_list_no_,
                                    shipment_id_               => shipment_id_,
                                    order_type_db_             => order_type_db_,
                                    reserved_by_source_db_     => Fnd_Boolean_API.DB_TRUE );
   ELSIF (quantity_diff_ < 0) THEN 
      Reduce_Qty_On_Unexecuted_Tasks(contract_               => from_contract_,
                                     part_no_                => part_no_,
                                     configuration_id_       => configuration_id_,
                                     location_no_            => from_location_no_,
                                     lot_batch_no_           => lot_batch_no_,
                                     serial_no_              => serial_no_,
                                     eng_chg_level_          => eng_chg_level_,
                                     waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                     activity_seq_           => activity_seq_,
                                     handling_unit_id_       => handling_unit_id_,
                                     quantity_               => quantity_diff_       * -1,
                                     catch_quantity_         => catch_quantity_diff_ * -1,
                                     order_ref1_             => order_ref1_,
                                     order_ref2_             => order_ref2_,
                                     order_ref3_             => order_ref3_,
                                     order_ref4_             => order_ref4_,
                                     pick_list_no_           => pick_list_no_,
                                     shipment_id_            => shipment_id_,                                     
                                     order_type_db_          => order_type_db_,
                                     reserved_by_source_db_  => Fnd_Boolean_API.DB_TRUE );
   END IF;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;      
END Modify_Order_Reservation_Qty;


@UncheckedAccess   
FUNCTION Get_To_Locations (
   transport_task_id_ IN NUMBER,
   only_non_executed_ IN BOOLEAN DEFAULT FALSE,
   only_to_inventory_ IN BOOLEAN DEFAULT FALSE ) RETURN Warehouse_Bay_Bin_API.Location_No_Tab
IS
   only_non_executed_char_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   only_to_inventory_char_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   to_location_tab_        Warehouse_Bay_Bin_API.Location_No_Tab;

   CURSOR get_to_locations IS
      SELECT DISTINCT to_location_no
      FROM transport_task_line_tab
      WHERE transport_task_id        = transport_task_id_
        AND ((transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)) OR
             (only_non_executed_char_          = Fnd_Boolean_API.DB_FALSE))
        AND ((destination            = Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY) OR
             (only_to_inventory_char_      = Fnd_Boolean_API.DB_FALSE));
BEGIN
   IF (only_non_executed_) THEN
      only_non_executed_char_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   IF (only_to_inventory_) THEN
      only_to_inventory_char_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   OPEN get_to_locations;
   FETCH get_to_locations BULK COLLECT INTO to_location_tab_;
   CLOSE get_to_locations;

   RETURN(to_location_tab_);
END Get_To_Locations;

-----------------------------------------------------------------------------
-- Print_Transport_Task
--   This will create a new record in report archive if all the lines are 
--   executed and the transport task has not been already printed.
-----------------------------------------------------------------------------
PROCEDURE Print_Transport_Task (
   transport_task_id_ IN NUMBER  ) 
IS
   printer_id_                   VARCHAR2(100);
   print_attr_                   VARCHAR2(200);
   report_attr_                  VARCHAR2(2000);
   parameter_attr_               VARCHAR2(2000);
   detailed_result_key_          NUMBER;   
   print_job_id_                 NUMBER;
   printer_id_list_              VARCHAR2(32000); 
BEGIN
   IF (Is_Completely_Executed(transport_task_id_) AND Get_Printed_Flag(transport_task_id_) = '0') THEN      
      -- Generate a new print job id
      printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 'TRANSPORT_TASK_REP');
      Client_SYS.Clear_Attr(print_attr_);
      Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, print_attr_);
      Print_Job_API.New(print_job_id_, print_attr_); 

      -- Create the report
      Client_SYS.Clear_Attr(report_attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', 'TRANSPORT_TASK_REP', report_attr_);
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('TRANSPORT_TASK_ID', transport_task_id_, parameter_attr_);
      Archive_API.New_Instance(detailed_result_key_, report_attr_, parameter_attr_);

      -- Connect the created report to a print job id
      Client_SYS.Clear_Attr(print_attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, print_attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY',   detailed_result_key_,   print_attr_);
      Client_SYS.Add_To_Attr('OPTIONS',      'COPIES(1)',   print_attr_);
      Print_Job_Contents_API.New_Instance(print_attr_);

      -- Send the print job to the printer.
      Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
      IF (printer_id_list_ IS NOT NULL) THEN
         IF (print_job_id_ IS NOT NULL) THEN
            Print_Job_API.Print(print_job_id_);
         END IF;
      END IF;
      print_job_id_ := NULL;      
   END IF;
END Print_Transport_Task;

PROCEDURE Modify_Order_Pick_List(
   contract_              VARCHAR2,
   part_no_               VARCHAR2,
   configuration_id_      VARCHAR2,
   location_no_           VARCHAR2, 
   lot_batch_no_          VARCHAR2,
   serial_no_             VARCHAR2,
   eng_chg_level_         VARCHAR2,
   waiv_dev_rej_no_       VARCHAR2,
   activity_seq_          VARCHAR2,
   handling_unit_id_      VARCHAR2,
   quantity_              NUMBER,
   catch_quantity_        NUMBER,
   order_ref1_            VARCHAR2,
   order_ref2_            VARCHAR2,
   order_ref3_            VARCHAR2,
   order_ref4_            VARCHAR2,
   pick_list_no_          VARCHAR2,
   shipment_id_           NUMBER,
   order_type_db_         VARCHAR2,   
   new_pick_list_no_      VARCHAR2 )
IS
   reservation_booked_for_transp_ BOOLEAN;
   exit_procedure_                EXCEPTION;
 
BEGIN
   Transport_Task_API.New_Trans_Task_For_Changed_Res(reservation_booked_for_transp_ => reservation_booked_for_transp_,
                                                     part_no_            => part_no_,
                                                     configuration_id_   => configuration_id_,
                                                     from_contract_      => contract_,
                                                     from_location_no_   => location_no_,   
                                                     order_type_db_      => order_type_db_,
                                                     order_ref1_         => order_ref1_,
                                                     order_ref2_         => order_ref2_,
                                                     order_ref3_         => order_ref3_,
                                                     order_ref4_         => order_ref4_,
                                                     from_pick_list_no_  => pick_list_no_,
                                                     to_pick_list_no_    => new_pick_list_no_,
                                                     from_shipment_id_   => shipment_id_,
                                                     to_shipment_id_     => shipment_id_,   
                                                     lot_batch_no_       => lot_batch_no_,
                                                     serial_no_          => serial_no_,
                                                     eng_chg_level_      => eng_chg_level_,
                                                     waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                     activity_seq_       => activity_seq_,
                                                     handling_unit_id_   => handling_unit_id_,
                                                     quantity_           => quantity_);
   IF NOT (reservation_booked_for_transp_) THEN 
      RAISE exit_procedure_;
   END IF;
   
   Reduce_Qty_On_Unexecuted_Tasks(contract_          => contract_,
                                  part_no_           => part_no_,
                                  configuration_id_  => configuration_id_,
                                  location_no_       => location_no_,
                                  lot_batch_no_      => lot_batch_no_,
                                  serial_no_         => serial_no_,
                                  eng_chg_level_     => eng_chg_level_,
                                  waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                  activity_seq_      => activity_seq_,
                                  handling_unit_id_  => handling_unit_id_,
                                  quantity_          => quantity_,
                                  catch_quantity_    => catch_quantity_,
                                  order_ref1_        => order_ref1_,
                                  order_ref2_        => order_ref2_,
                                  order_ref3_        => order_ref3_,
                                  order_ref4_        => order_ref4_,
                                  pick_list_no_      => pick_list_no_,
                                  shipment_id_       => shipment_id_,
                                  order_type_db_     => order_type_db_,
                                  reserved_by_source_db_ => Fnd_Boolean_API.DB_TRUE);

   EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Modify_Order_Pick_List;

PROCEDURE New_Trans_Task_For_Changed_Res (
   reservation_booked_for_transp_ OUT BOOLEAN,
   part_no_                       IN  VARCHAR2,
   configuration_id_              IN  VARCHAR2,
   from_contract_                 IN  VARCHAR2,
   from_location_no_              IN  VARCHAR2,   
   order_type_db_                 IN  VARCHAR2,
   order_ref1_                    IN  VARCHAR2,
   order_ref2_                    IN  VARCHAR2,
   order_ref3_                    IN  VARCHAR2,
   order_ref4_                    IN  VARCHAR2,
   from_pick_list_no_             IN  VARCHAR2,
   to_pick_list_no_               IN  VARCHAR2,
   from_shipment_id_              IN  NUMBER,
   to_shipment_id_                IN  NUMBER,   
   lot_batch_no_                  IN  VARCHAR2,
   serial_no_                     IN  VARCHAR2,
   eng_chg_level_                 IN  VARCHAR2,
   waiv_dev_rej_no_               IN  VARCHAR2,
   activity_seq_                  IN  NUMBER,
   handling_unit_id_              IN  NUMBER,
   quantity_                      IN  NUMBER )
IS
   to_contract_                   VARCHAR2(5);
   to_location_no_                VARCHAR2(35);
   to_destination_                VARCHAR2(20);
   dummy_number_                  NUMBER;
   serial_dummy_tab_              Part_Serial_Catalog_API.Serial_No_Tab;
   serial_no_tab_                 Part_Serial_Catalog_API.Serial_No_Tab;
   local_qty_                     NUMBER;
BEGIN
   Trace_SYS.Field('-------------from_contract_', from_contract_);
   Trace_SYS.Field('-------------from_location_no_', from_location_no_);
   Trace_SYS.Field('-------------part_no_', part_no_);
   Trace_SYS.Field('-------------configuration_id_', configuration_id_);
   Trace_SYS.Field('-------------lot_batch_no_', lot_batch_no_);
   Trace_SYS.Field('-------------serial_no_', serial_no_);
   Trace_SYS.Field('-------------eng_chg_level_', eng_chg_level_);
   Trace_SYS.Field('-------------waiv_dev_rej_no_', waiv_dev_rej_no_);
   Trace_SYS.Field('-------------activity_seq_', activity_seq_);
   Trace_SYS.Field('-------------handling_unit_id_', handling_unit_id_);
   Trace_SYS.Field('-------------order_ref1_', order_ref1_);
   Trace_SYS.Field('-------------order_ref2_', order_ref2_);
   Trace_SYS.Field('-------------order_ref3_', order_ref3_);
   Trace_SYS.Field('-------------order_ref4_', order_ref4_);
   Trace_SYS.Field('-------------from_pick_list_no_', from_pick_list_no_);
   Trace_SYS.Field('-------------from_shipment_id_', from_shipment_id_);
   Trace_SYS.Field('-------------order_type_db_', order_type_db_);
   reservation_booked_for_transp_ := Transport_Task_Line_API.Reservation_Booked_For_Transp(from_contract_       => from_contract_,
                                                                                           from_location_no_    => from_location_no_,
                                                                                           part_no_             => part_no_,
                                                                                           configuration_id_    => configuration_id_,
                                                                                           lot_batch_no_        => lot_batch_no_,
                                                                                           serial_no_           => serial_no_,
                                                                                           eng_chg_level_       => eng_chg_level_,
                                                                                           waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                                                                           activity_seq_        => activity_seq_,
                                                                                           handling_unit_id_    => handling_unit_id_,
                                                                                           order_ref1_          => order_ref1_,
                                                                                           order_ref2_          => order_ref2_,
                                                                                           order_ref3_          => order_ref3_,
                                                                                           order_ref4_          => order_ref4_,
                                                                                           pick_list_no_        => from_pick_list_no_,
                                                                                           shipment_id_         => from_shipment_id_,
                                                                                           order_type_db_       => order_type_db_);
   IF (reservation_booked_for_transp_) THEN
      IF (serial_no_ != '*') THEN
         serial_no_tab_(1).serial_no := serial_no_;
         local_qty_ := NULL;
      ELSE
         local_qty_ := quantity_;
      END IF;
   
      Transport_Task_Line_API.Get_Destination_Info(to_contract_       => to_contract_,
                                                   to_location_no_    => to_location_no_,
                                                   to_destination_    => to_destination_,
                                                   from_contract_     => from_contract_,
                                                   part_no_           => part_no_,
                                                   configuration_id_  => configuration_id_,
                                                   from_location_no_  => from_location_no_,
                                                   lot_batch_no_      => lot_batch_no_,
                                                   serial_no_         => serial_no_,
                                                   eng_chg_level_     => eng_chg_level_,
                                                   waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                                   activity_seq_      => activity_seq_,
                                                   handling_unit_id_  => handling_unit_id_,  
                                                   order_ref1_        => order_ref1_,
                                                   order_ref2_        => order_ref2_,
                                                   order_ref3_        => order_ref3_,
                                                   order_ref4_        => order_ref4_,
                                                   pick_list_no_      => from_pick_list_no_,
                                                   shipment_id_       => from_shipment_id_,   
                                                   order_type_db_     => order_type_db_);
   
   Trace_SYS.Field('-------------to_pick_list_no_', to_pick_list_no_);
   Trace_SYS.Field('-------------from_pick_list_no_', from_pick_list_no_);
      Transport_Task_API.New_Or_Add_To_Existing(transport_task_id_  => dummy_number_,
                                                quantity_added_     => dummy_number_,
                                                serials_added_      => serial_dummy_tab_,
                                                part_no_            => part_no_,
                                                configuration_id_   => configuration_id_,
                                                from_contract_      => from_contract_,
                                                from_location_no_   => from_location_no_,
                                                to_contract_        => to_contract_,
                                                to_location_no_     => to_location_no_,
                                                destination_        => Inventory_Part_Destination_API.Decode(to_destination_),
                                                order_type_         => Order_Type_API.Decode(order_type_db_),
                                                order_ref1_         => order_ref1_,
                                                order_ref2_         => order_ref2_,  
                                                order_ref3_         => order_ref3_,
                                                order_ref4_         => order_ref4_,
                                                pick_list_no_       => to_pick_list_no_,
                                                shipment_id_        => to_shipment_id_,
                                                lot_batch_no_       => lot_batch_no_,
                                                serial_no_tab_      => serial_no_tab_, 
                                                eng_chg_level_      => eng_chg_level_,
                                                waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                activity_seq_       => activity_seq_,
                                                handling_unit_id_   => handling_unit_id_,
                                                quantity_to_add_    => local_qty_,
                                                reserved_by_source_db_ => Fnd_Boolean_API.DB_TRUE);
   END IF;                                           
END New_Trans_Task_For_Changed_Res;   

PROCEDURE Set_Split_By_Hu_Capacity (
   transport_task_id_ IN NUMBER,
   value_             IN BOOLEAN)
IS
   rec_     TRANSPORT_TASK_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Keys___(transport_task_id_);
   IF rec_.split_by_hu_capacity != CASE value_ WHEN TRUE THEN Fnd_Boolean_API.DB_TRUE
                                              WHEN FALSE THEN Fnd_Boolean_API.DB_FALSE END THEN
      rec_.split_by_hu_capacity := CASE value_ WHEN TRUE THEN Fnd_Boolean_API.DB_TRUE
                                               WHEN FALSE THEN Fnd_Boolean_API.DB_FALSE END;
   Modify___(rec_);
   END IF;

END Set_Split_By_Hu_Capacity;


FUNCTION Get_Inbound_Handling_Units (
   contract_                 IN VARCHAR2,
   location_no_              IN VARCHAR2,
   only_outermost_in_result_ IN BOOLEAN DEFAULT TRUE, 
   incl_hu_zero_in_result_   IN BOOLEAN DEFAULT TRUE ) RETURN Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab
IS
   inv_part_stock_tab_          Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   handl_unit_stock_result_tab_ Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab;
   dummy_tab_                   Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;

   CURSOR get_inbound_stock IS
      SELECT from_contract contract, part_no, configuration_id, from_location_no location_no, lot_batch_no,
             serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, SUM(quantity) quantity
        FROM transport_task_line_tab
       WHERE to_contract     = contract_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND (to_location_no = location_no_ OR forward_to_location_no = location_no_)
   GROUP BY from_contract , part_no, configuration_id, from_location_no , lot_batch_no,
          serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id;
BEGIN
   OPEN  get_inbound_stock;
   FETCH get_inbound_stock BULK COLLECT INTO inv_part_stock_tab_;
   CLOSE get_inbound_stock;

   Handl_Unit_Snapshot_Util_API.Generate_Snapshot(handl_unit_stock_result_tab_  => handl_unit_stock_result_tab_,
                                                  inv_part_stock_result_tab_    => dummy_tab_,
                                                  inv_part_stock_tab_           => inv_part_stock_tab_,
                                                  only_outermost_in_result_     => only_outermost_in_result_,
                                                  incl_hu_zero_in_result_       => incl_hu_zero_in_result_,
                                                  summarize_part_stock_result_  => TRUE);
   RETURN (handl_unit_stock_result_tab_);
END Get_Inbound_Handling_Units;


@UncheckedAccess
FUNCTION Get_Intra_Warehouse_Move_Qty (
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   contract_           IN VARCHAR2,
   warehouse_id_       IN VARCHAR2 ) RETURN NUMBER
IS
   qty_intra_warehouse_   NUMBER;
   site_warehouse_id_     VARCHAR2(100) := contract_||'^'||warehouse_id_;

   CURSOR get_quantity is
      SELECT NVL(SUM(quantity),0)
      FROM   active_warehouse_transport
      WHERE  part_no            = part_no_
      AND    configuration_id   = configuration_id_
      AND    reserved_by_source = Fnd_Boolean_API.DB_FALSE
      AND    (from_site_warehouse_id = site_warehouse_id_ AND to_site_warehouse_id  = site_warehouse_id_);
BEGIN
   OPEN  get_quantity;
   FETCH get_quantity INTO qty_intra_warehouse_;
   CLOSE get_quantity;
   RETURN qty_intra_warehouse_;
END Get_Intra_Warehouse_Move_Qty;