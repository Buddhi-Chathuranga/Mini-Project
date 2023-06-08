-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderReservation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211206  RoJalk  SC21R2-2756, Modified Get_Reserv_Info_On_Delivered and included activity seq.
--  210711  RoJalk  SC21R2-1374, Added the parameter ship_handling_unit_id_ to the methods Post_Update_Actions___ , Modify_Qty_Picked,
--  210711          Pick_On_Location___, Pick_Reservations__ to support report picking on shipment handling unit level.
--  201209  DaZase  Bug 156990 (SCZ-12596), Added overloaded Get_Pick_By_Choice_Blocked_Db() that was copied from similar method in InvPartStockReservation 
--  201209          but we replaced view inv_part_stock_reservation in the cursor with Customer_Order_Res.
--  201108  RasDlk  SCZ-11837, Added new function Is_Pick_List_Connected().
--  200709  AsZelk  Bug 154251(SCZ-10013), Added Get_Qty_Shipped() method.
--  191023  SBalLK  Bug 150436 (SCZ-6914), Added Get_Homogeneous_Location_Group() method.
--  190823  ErFelk  Bug 149543(SCZ-6407), Created an overloaded method Unreported_Pick_Lists_Exist().
--  190514  DiKuLk  Bug 147858(SCZ-4348), Modified Get_Reserv_Info_On_Delivered() to add handling_unit_id to the cursor selection.
--  181216  ErRalk  SCUXXW4-9495, Modified Check_Insert___ and Check_Update___ methods to validate negative inputs in qty_to_deliver and catch_qty_to_deliver.
--  180226  RoJalk  STRSC-15257, Added the method Get_Total_Qty_On_Pick_List.
--  180223  KHVESE  STRSC-15956, Modified method Modify_Qty_Picked.
--  180223  RoJalk  STRSC-15257, Added the method Get_Total_Qty_Reserved.
--  180221  KHVESE  STRSC-17267, Modified method Change_Handling_Unit_Id.
--  180209  JeLise  STRSC-16913, Modified Modify_Qty_Assigned by adding pick_by_choice_blocked_db.
--  180129  JeLise  STRSC-16022, Modified the cursor in Get_Pick_By_Choice_Blocked_Db by adding qty_assigned - qty_picked > 0.
--  180119  KHVESE  STRSC-8813, Modified method Split_Reservation_Into_Serials.
--  171230  KhVese  STRSC-12028, Modified the whole logic in method Change_Handling_Unit_Id.
--  171129  ChFolk  STRSC-14444, Modified Modify_On_Transport_Task to check the availability of reservation before updating.
--  171127  ChFolk  STRSC-14753, Modified Check_Insert___ to set default value for on_transport_task.
--  171120  ChFolk  STRSC-14444, Added new attribute on_transport_task which is a flag to indicate when the reservation is on an un executed transport task.
--  171120          Added new method Modify_On_Transport_Task which gives the pubic interface to update the flag. Removed transport_task_executed_ parameter in
--  171120          Post_Update_Actions___, Post_Delete_Actions___, Update___, Delete___, Modify_Attribute___.
--  171003  JeLise  STRSC-12327, Added pick_by_choice_blocked in New, Split_Reservation_Into_Serials and Get_Object_By_Id.
--  170713  ChFolk  STRSC-10849, Modified Move_To_Shipment to use single method New_Trans_Task_For_Changed_Res instead of set of methods from Transport_Task_API.
--  170712  ChFolk  STRSC-10849, Modified Move_To_Shipment to create new transport task when moved to a new shipment. 
--  170612  TiRalk  STRSC-5756, Modified Modify_On_Delivery__ and Modify_On_Undo_Delivery__ to update the qty_to_deliver and catch_qty_to_deliver.
--  170522  NiDalk  Bug 135715, Removed corrections 134235 and removed 134911 in Post_Update_Actions___.
--  170517  UdGnlk  LIM-10867, Modified Check_Update___() to validate reservations against transport task. 
--  170510  RoJalk  STRSC-8047, Modified Modify_Pick_List_No and replaced Shipment_Reserv_Handl_Unit_API.Modify_Pick_List_No
--  170510          with Pick_Shipment_API.Modify_Reserv_Hu_Pick_List_No.
--  170502  UdGnlk  LIM-10867, Modified Check_Update___() and Post_Update_Actions___() to validate reservations against transport task.
--  170324  Chfose  LIM-11152, Moved Add_Pick_Lists_To_Hu_Refr_List to PickShipment(SHPMNT).
--  170323  KiSalk  Bug 134911, Added condition check if picked more than revised_qty_due of CO line to set reassignment_type_ as 'OVER_PICKED' in Post_Update_Actions___.
--  170323          Also corrected parameter order of Get_Qty_Assigned calls.
--  170317  MaEelk  LIM-11106, Replaced the call to Transport_Task_API.Remove_Unexecuted_Tasks from Post_Delete_Actions___ with 
--  170317          Transport_Task_API.Modify_Order_Reservation_Qty so both removal and update would work in the same manner.
--  170306  MaEelk  LIM-10889, Added boolean parameter transport_task_executed_ to Remove and Delete___ and Post_Delete_Actions___ so that it makes the call to 
--  170306          Transport_Task_API.Remove_Unexecuted_Tasks from Post_Delete_Actions___ only if the transport task is not executed.
--  170302  RoJalk  LIM-11001, Replaced Shipment_Source_Utility_API.Public_Reservation_Rec with
--  170302          Reserve_Shipment_API.Public_Reservation_Rec.
--  170301  MaEelk  LIM-10889, Ramoved the call to Transport_Task_Line_API.Remove from Remove Method and made a call to Transport_Task_API.Remove_Unexecuted_Tasks
--  170301          from Post_Delete_Actions.
--  170217  MaEelk  LIM-10489, passe the DEFAULT FALSE parameter transport_task_executed_ to Modify_Qty_Assigned and Modify_Attribute___
--  170217          so it would decide to modify the transport task line or not, in Post_Update_Actions___.
--  170208  KiSalk Bug 134235, In Post_Update_Actions___ sent qty_modification_source_ as 'OVER_PICKED' to Shipment_Order_Line_API.Update_On_Reserve 
--  170208         when the whole reservation is being picked. 
--  170201  Jhalse  LIM-10150, Added new method Change_Handling_Unit_Id to move quantities between reservations on Handling Units
--  170127  KhVese  LIM-9880, Added public method Get_Object_By_Id.
--  170126  MaEelk  LIM-10488, Called Transport_Task_Line_API.Remove from Remove so it will remove the existing Transport Task Line once the customer order reservation is removed.
--  170102  MaIklk  LIM-10161, Removed Get_Total_Qty_Assigned, Get_Qty_Assigned_In_Hu and Get_Total_Qty_Assigned_In_Hu.
--  170102          Handled them in ReserveShipment instead. Using Shipment_Source_Reservation.
--  161205  MaIklk  LIM-9261, Moved Get_Remain_Res_To_Hu_Connect from customer_order_reservation_API to Shipment_Reserv_Handl_unit_API.
--  161205  MaIklk  LIM-9257, Moved Get_Number_Of_Lines, Add_Reservations_To_Handl_Unit, Add_Reservations_On_Reassign and Get_Sum_Reserve_To_Reassign to Shipment_Reserv_Handl_Unit_API
--          MaIklk  and Reserve_Shipment_API.
--  161128  MaIklk  LIM-9262, Moved Get_Qty_To_Attach_On_Res to ShipmentReservHandlUnit.and done neccessary changes to renaming of columns in ShipmentReservHandlUnit.
--  160923  DaZase  LIM-8337, Moved methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist for .
--  160923          Move Parts Between Shipment Locations and Return Parts from Shipment Locations processes to HandleShipInventUtility in SHPMNT.                                           
--  160826  DaZase  LIM-8334, Moved methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist 
--  160826          for Pack Into Handling Unit Shipment process to ShipmentSourceUtility in SHPMNT.
--  160816  Chfose  LIM-8006, Modified order of parameters in calls to Shipment_Reserv_Handl_Unit_API and 
--  160816          filtered cursor in Add_Reservations_To_Handl_Unit by reserv_handling_unit_id to get correct quantity.
--  160804  RoJalk  LIM-8189, Added the paramater public_reservation_rec_ to the method Lock_And_Fetch_Info.
--  160801  RoJalk  LIM-8189, Modified Lock_And_Fetch_Info, added the parameter qty_shipped_ and removed reassignment_type_.
--  160726  MaEelk  LIM-6499, Added Keys_And_Qty_Tab to fetch quantity values with Reservation Keys.
--  160726  RoJalk  LIM-8148, Added shipment_line_no_ to Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify method.
--  160726  RoJalk  LIM-8148, Added shipment_line_no_ to Shipment_Reserv_Handl_Unit_API.Modify_Pick_List_No method.
--  160725  RoJalk  LIM-8102, Moved the method Transfer_Line_Reservations to Shipment_Source_Utility_API.
--  160720  Chfose  LIM-7517, Added inventory_event_id and server-based refresh of 'HU Pick-List snapshots' throughout the file.
--                  and added new method Add_Pick_Lists_To_Hu_Refr_List.
--  160714  RoJalk  LIM-7359, Replaced the usage of Customer_Order_Reservation_API.Reassign_Connected_Qty with
--  160714          Reassign_Shipment_Utility_API.Reassign_Connected_Reserve_Qty.
--  160714  RoJalk  LIM-7359, Moved the methods Release_Reservations___ and Move_Shipment_Reservation___ to
--  160714          Reassign_Shipment_Utility_API to support generic usage.
--  160714  RoJalk  LIM-7359, Modified Move_Shipment_Reservation___ to make it generic.
--  160713  RoJalk  LIM-7359, Modified Release_Reservations___ to make it generic.
--  160708  SWiclk  Bug 130209, Modified Get_Qty_Left_To_Pick() by removing the SUM of qty_assigned and qty_picked in order to support 
--  160708          auto_pick of unique_line_id when serials are identified where the part is not inventory tracked.
--  160704  RoJalk  LIM-7359, Modified Release_Reservations___ to make the reassign code generic.
--  160701  RoJalk  LIM-7359, Added the methods Reduce_Reserve_Qty, Lock_And_Fetch_Info. Renamed Update_On_Reassign___ to
--  160701          Update_Qty.  Modified to include parameters rather than a record type. 
--  160624  RoJalk  LIM-7683, Added the method Get_Reserv_Info_On_Delivered.
--  160610  MaIklk  LIM-7442, Added Disconn_Reserve_From_Delnote.  
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160607  RoJalk  LIM-7359, Removed Validate_Reassign___ and replaced the usage with Reassign_Shipment_Utility_API.Validate_Reassign_Reservation.
--  160606  RoJalk  LIM-7359, Moved the logic in Reassign_Connected_Qty__ to Reassign_Shipment_Utility_API.Reassign_Connected_Qty__.
--  160601  RoJalk  LIM-6945, Code improvements to the method Modify_Line_Reservations.
--  160601          Renamed Get_Reserved_Qty_Connected to Get_Remain_Res_To_Hu_Connect.
--  160601          Renamed Modify_Line_Reservations to Transfer_Line_Reservations.
--  160526  RoJalk  STRSC-2528, Added the parameter handling_unit_id_ to Shipment_Reserv_Handl_Unit_API.Modify_Pick_List_No.
--  160518  RoJalk  LIM-6945, Code improvements to the method Modify_Line_Reservations. 
--  160225	MeAblk  Bug 127055, Modified methods Update___ and Modify_On_Undo_Delivery__ to handle the newly added parameter UNDO_DELIVERY.
--  160509  Chfose  LIM-7342, Correctly fetched qty_assigned from the whole underlying structure for a HU in Get_Total_Qty_Assigned_In_HU & Get_Qty_Assigned_In_HU.
--  160506  RoJalk  LIM-7222, Added the method Get_Qty_To_Attach_On_Res.
--  160504  RoJalk  LIM-7296, Added Post_Update_Actions___, Post_Delete_Actions___, added Get_Reserved_Qty_Connected.
--  160503  Chfose  LIM-6890, Added new methods Get_Total_Qty_Assigned & Get_Total_Qty_Assigned_In_HU for getting the total qty across all pick lists.
--  160408  JeLise  LIM-6869, Added method Get_Qty_Picked.
--  160331  RoJalk  LIM-6585, Removed the method Get_Qty_Left_To_Assign and replaced with Shipment_Line_Handl_Unit_API.Get_Reserv_Qty_Left_To_Assign.
--  160315  Chfose  LIM-6165, Added method Get_Qty_Assigned_In_HU.
--  160308  RoJalk  LIM-6321, Renamed shipment_line_no_to rom_shipment_line_no_ in Add_Reservations_On_Reassign method.
--  160217  JeLise  LIM-6223, Added handling_unit_id in calls to Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment.
--  160208  MaEelk  LIM-6179, Added parameter handling_unit_id_ to Modify_On_Undo_Delivery__.
--  160205  RoJalk  LIM-4246, Included shipment_line_no_ in Shipment_Line_Handl_Unit_API.Get_Quantity call.
--  160202  RoJalk  LIM-5911, Modified Add_Reservations_To_Handl_Unit to include shipment_line_no_ in 
--  160202          Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing method call.
--  160128  RoJalk  LIM-5911, Added shipment_line_no_  parameter to Get_Qty_Left_To_Assign.
--  160126  RoJalk  LIM-5911, Add shipment_line_no_ to Add_Reservations_On_Reassign.
--  160126  RoJalk  LIM-5911, Add shipment_line_no_ to Add_Reservations_To_Handl_Unit.
--  160106  RoJalk  LIM-4648, Replaced Shipment_Line_API.Check_Partially_Deliv_Comp with Shipment_Order_Utility_API.Check_Partially_Deliv_Comp. 
--  151125  JeLise  LIM-4470, Removed method Modify_Pallet_Reservations.
--  151117  JeLise  LIM-4457, Corrected calls to Shipment_Reserv_Handl_Unit_API.
--  151113  MaEelk  LIM-4453, Removed PALLET_ID from the logic
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151105  UdGnlk  LIM-3746, Removed Inventory_Part_Loc_Pallet_API method calls since INVENTORY_PART_LOC_PALLET_TAB will be obsolete. 
--  151103  JeLise  LIM-4392, Removed check on pallet_id in Modify_Prelim_Pick_List_No.
--  150908  Wahelk  AFT-4157, Modified Create_Data_Capture_Lov to add conditional compilation constant for PROJ
--  150706  RiLase  COB-25, Added methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist for Move Parts Between Shipment Locations.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150519  IsSalk  KES-520, Added Modify_On_Undo_Delivery__().
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150511  RoJalk  ORA-445, Removed app owner prefix from Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment method call.
--  150421  RiLase  COL-27, Added method Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist.
--  150325  JeLise  COL-173, Added in parameter remaining_qty_assigned_ to Modify_Qty_Picked.
--  150203  JeLise  PRSC-5841, Added method Get_Qty_Left_To_Pick to be used from Data_Capt_Pick_Cust_Order_API.
--  150421  MaEelk LIM-147, Added handling_unit_id to the LU. 
--  150203  JeLise PRSC-5841, Added method Get_Qty_Left_To_Pick to be used from Data_Capt_Pick_Cust_Order_API.
--  150102  RoJalk PRSC-4685, Modified Insert___ and Update___ to assign a value for move_to_ship_location_  if NULL.
--  141118  RoJalk PRSC-388, Modified Insert___, Update___ and Delete___ to handle move_to_ship_location_ to skip the update 
--  141118         of shipment lines when transfer between shipment inventory locations.Added the parameter move_to_ship_location_
--  141118         to the methods Modify_Qty_Picked, Remove and New.
--  141020  JeLise Added method Get_Number_Of_Lines_To_Pick with only pick_list_no as in parameter.
--  140818  RoJalk Modified Validate_Reassign___ and included a validation to check for pick listed reservations.
--  140506  RoJalk Modified Modify_Line_Reservations and added code to handle catch qty. 
--  140429  RoJalk Added the method Get_Number_Of_Lines_To_Pick. 
--  140220  RoJalk Added the method Unreported_Pick_Lists_Exist.
--  140218  RoJalk Modified Reassign_Connected_Qty and removed the validation to restrict decimals for serial tracked parts.
--  130627  ChJalk EBALL-127, Modified method Split_Reservation_Into_Serials to modify the CRO exchange reservation record according to the identified serial.
--  130906  MAHPLK Added shipment_id_ parameter to Clear_Pick_List_No method.
--  130904  RoJalk Modified Unpack_Check_Update___ and removed the code related to updating of shipment id. Modified Reassign_Connected_Qty and added a validation for serial parts.
--  130903  RoJalk Modified Get_Max_Ship_Qty_To_Reassign to check for partially delivered package components.
--  130830  RoJalk Moved Reassign_Connected_Pallets__,Reassign_Connected_Qty__ from Customer_Order_Reservation_API to Shipment_Handling_Utility_API and updated the usage.
--  130830  RoJalk Code cleanup and remove unused variables.
--  130823  RoJalk Modified New and added the parameter reassignment_type_.Modified Unpack_Check_Insert___ and handled reassignment_type_.Removed Transfer_Reservations_To_Order.
--  130822  RoJalk Modified Transfer_Reservations_To_Order and changed TO_CUST_ORDER value to SHIPMENT when calling Remove.
--  130820  JeLise Rewritten method Get_Qty_Left_To_Assign.
--  130819  JeLise Added call to Shipment_Line_Handl_Unit_API.Get_Quantity in Add_Reservations_On_Reassign.
--  130816  RoJalk Moved the method Clear_Temporary_Table___ to SHIPMENT_HANDLING_UTILITY_API.
--  130816  MaMalk Added Transfer_Reservations_To_Order to transfer the reservations from shipment to customer order.
--  130814  JeLise Changed from sending 0 to NULL for catch_qty_to_reassign_ in call to Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing 
--  130814         in Add_Reservations_To_Handl_Unit.
--  130813  RoJalk Moved the methods Fill_Temporary_Table__, Reassign_Reserved_Pkg_Comp__ to SHIPMENT_HANDLING_UTILITY_API.
--  130812  RoJalk Removed order_no_, line_no_, rel_no_ from Fill_Temporary_Table__ and added to Reassign_Reserved_Pkg_Comp__.
--  130805  RoJalk Added the method Pick_List_Exist_To_Report to check if line(s) exits for pick list created but not pick reported. 
--  130805  RoJalk Modified Add_Reservations_To_Handl_Unit and passed 0 to catch_qty_to_reassign_ in Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing method call.
--  130801  RoJalk Modified Reassign_Reserved_Pkg_Comp__ and replaced Shipment_Order_Line_API.Reassign_Order_Line__ with Shipment_Order_Line_API.Reassign_Pkg_Comp__
--  130731  RoJalk Added the methods Fill_Temporary_Table__, Reassign_Reserved_Pkg_Comp__, Clear_Temporary_Table___.
--  130712  RoJalk Modified Get_Max_Ship_Qty_To_Reassign to support reassignment of PKG parts.
--  130628  RoJalk Added the method Get_Number_Of_Reservations.
--  130620  JeLise Added method Get_Qty_Left_To_Assign.
--  130620  RoJalk Removed unused parameters from the method Modify_Qty_On_Reserve.Renamed Modify_Qty_On_Reserve to Update_On_Reserve.
--  130618  RoJalk Renamed the method Get_Qty_On_Handling_Unit to Get_Line_Attached_Qty.
--  130612  RoJalk Modified Modify_Line_Reservations and redirected to Move_Shipment_Reservation___ method. Added the parameter transfer_on_add_remove_line_ 
--  130612         to identify if shipment order line is added or deleted.
--  130611  RoJalk Added the method Get_Sum_Reserve_To_Reassign.
--  130607  RoJalk Removed the method Get_Sum_Reserve_To_Reassign.
--  130607  RoJalk Added the method Reassign_Rec___ and called in a complete co reservation reassignment instead of calling Modify_Shipmnet_Id___ which update a
--  130607         key column. Modified Update___ to update the shipment line values accordingly. 
--  130606  RoJalk Added the common method Validate_Reassign___ with common validations for reassignment functionality.   
--  130606  RoJalk Rearranged the method order according to the private and implementation scope.  
--  130606  RoJalk Modified Release_Reservations___ and called the method Update_On_Reassign__._  
--  130606  RoJalk Added the method Update_On_Reassign___ and called from Move_Shipment_Reservation___.
--  130605  RoJalk Modified Release_Reservations___ and  Move_Shipment_Reservation___ to update catch_qty_deliver.
--  130605  RoJalk Modified Reassign_Connected_Qty, Modify_Pallet_Reservations and changed the parameter release_reservations_ to be boolean.
--  130605         Modified Move_Shipment_Reservation___, Modify_Pallet_Reservations, Release_Reservations___, Reassign_Connected_Qty__, Reassign_Connected_Qty  
--  130605         and Reassign_Connected_Pallets__ to support cath qty columns.
--  130531  RoJalk Code improvements from the method Add_Reservations_On_Reassign. 
--  130528  RoJalk Added the method Get_Sum_Reserve_To_Reassign to be used in Reassign Shipment Connected Qty flow.
--  130528  RoJalk Modified TRANSFERABLE_SHIPMENT_RES and changed the calculation for qty_assigned.
--  130528  RoJalk Modified Update___ and skipped the code to update shipment qty's when reassignment of Handling Units.
--  130528  RoJalk Added the method Add_Reservations_To_Handl_Unit.
--  130521  JeLise Added call to Shipment_Reserv_Handl_Unit_API.Handling_Unit_Exist and Shipment_Reserv_Handl_Unit_API.Remove_Handling_Unit in Delete___.
--  130520  RoJalk Removed the method Modify_Line_Reservations__ and redirected the usage to Move_Shipment_Reservation___.
--  130520  RoJalk Code improvements to the method Release_Reservations___.
--  130513  RoJalk Added the parameter reassignment_type_ to the methods Modify_Line_Reservations__, Reassign_Connected_Qty and Modify_Pallet_Reservations,
--  130513         Release_Reservations___ and Move_Shipment_Reservation___. 
--  130510  RoJalk Modified the scope of Modify_Pallet_Reservations to be public and added the method Reassign_Connected_Qty to be used in reassignment of HU. 
--  130424  MaMalk Modified Modify_Prelim_Pick_List_No to combine 2 shipment creation methods exist for pick list creation to 1.
--  130422  RoJalk Added the parameter qty_picked_in_ship_inventory_ to the methods Reassign_Connected_Qty__, Reassign_Connected_Pallets__, Release_Reservations___ 
--  130422         to identify the situation where picked qty is remaining for a shipment inventory location when reservation is released.
--  130419  RoJalk Added the method Move_Shipment_Reservation___ and called from Modify_Line_Reservations__, Release_Reservations___.
--  130418  RoJalk Renamed keep_reservations_ to release_reservations_ in Reassign_Connected_Qty__, Reassign_Connected_Pallets__ methods. 
--  130417  RoJalk Modified Reassign_Connected_Pallets__, Reassign_Connected_Qty__ to handle info messages.
--  130410  RoJalk Modified Release_Reservations___ to handle pallet parts.
--  130409  RoJalk Modified Release_Reservations___, Modify_Pallet_Reservations___ added code to update inventory_part_in_stock_tab after reservations are released.
--  130405  RoJalk Modified Update___ to update the source shipment line when shipment id is modified in the reservation records as a result of qty reassignment.
--  130404  RoJalk Added the methods Reassign_Connected_Pallets__, Modify_Pallet_Reservations___. 
--  130403  RoJalk Added the parameter keep_reservations_ to the method Reassign_Connected_Qty__. Added the method  Release_Reservations___. 
--  130322  RoJalk Added the method Reassign_Connected_Qty__. 
--  130320  JeLise Added call to Shipment_Reserv_Handl_Unit_API.Get_Qty_On_Handling_Unit in Add_Reservations_To_Handl_Unit.
--  130318  RoJalk Modified Modify_Line_Reservations__ and added the parameter reassign_ship_connected_qty_ to the Remove, Modify_Shipmnet_Id___, Delete___ 
--  130318         to identify the situation where record is removed via Reassign Shipment Connected Quantity. Added the derived attribute reassign_ship_connected_qty_.  
--  130314  RoJalk Added the method Get_Max_Ship_Qty_To_Reassign to calculate transferable shipment qty per line.
--  130313  RoJalk Modified Update___ and changed the conditions when calling Shipment_Order_Line_API.Modify_Qty_On_Reserve to consider transferring partial reservations from shipment.
--  130313  RoJalk Modified the scope of Modify_Line_Reservations___ to be private. 
--  130312  JeLise Corrected the order of parameters in call to Check_Exist___ in Exist.
--  130308  RoJalk Added ownership related columns to the TRANSFERABLE_SHIPMENT_RES view.
--  130307  RoJalk Added the view TRANSFERABLE_SHIPMENT_RES and Modify_Line_Reservations___ to be used in transfering reservation records between shipment and customer order.
--  130227  JeLise Added method Add_Reservations_To_Handl_Unit.
--  130226  JeLise Added more parameters in call to Shipment_Order_Line_API.Modify_Qty_On_Reserve.
--  130220  JeLise Added call to Shipment_Reserv_Handl_Unit_API.Modify_Pick_List_No in Modify_Pick_List_No.
--  130220  RoJalk Modified Update___ and replaced Shipment_Order_Line_API.Modify_Qty_Assigned/Modify_Qty_Picked with Modify_Qty_On_Reserve. 
--  130220  RoJalk Replaced Shipment_Order_Line_API.Modify_Qty_Assigned with Shipment_Order_Line_API.Modify_Qty_On_Reserve in Delete___ and Insert___.
--  130212  JeLise Added method Get_Number_Of_Lines.
--  130116  RoJalk Code improvements to the method Modify_Line_Reservations. 
--  130116  RoJalk Modified Update___ to avoid the method calls to update shipment order line qty's in delivery since it is handled separate method.  
--  130111  RoJalk Modified Update___ to transfer qty picked when only the shipment id of the reservation is modified.
--  130109  RoJalk Removed Get_Total_Qty_Assigned___  and modified get sum of qty assigned for order line reference.
--  130108  NaLrlk Added Get_Sum_Qty_Assign_And_Shipped to get the total qty_assigned and qty_shipped for serial/lot track reservations.
--  130107  RoJalk Removed the method Get_Total_Qty_Picked and replaced the logic to refer to qty_picked in shipment order line.
--  130104  RoJalk Modified Update___ to handle the qty_picked column in shipment order line.
--  121219  RoJalk Removed the method Get_Total_Qty_Delivered.
--  121219  RoJalk Replaced the usage of Shipment_Order_Line_API.Add_Qty_Assigned with Shipment_Order_Line_API.Modify_Qty_Assigned.
--  121211  RoJalk Modified the order of parameters in the method Split_Reservation_Into_Serials. Added shipment_id to the view CUSTOMER_ORDER_RES.
--  121129  RoJalk Modified Modify_Line_Reservations and removed the handling of picked qty.
--  121128  RoJalk Modified the method Modify_Line_Reservations to handle the reservations when sales qty is modified in shipment order line. 
--  121121  RoJalk Modified Get_Total_Qty_Picked and added NVL for the return value.  
--  121120  MeAblk Added new method Get_Total_Qty_Assigned  and modified method Get_Total_Qty_Assigned___ in order to handle non-inv component parts correctly.
--  121116  RoJalk Added the parameter transfer_reservations_  to the method Modify_On_Delivery__ and called Modify_Line_Reservations to be executed when picked shipment line is deleted.
--  121115  RoJalk Changed the scope of Get_Total_Qty_Delivered___ to be public. Removed the method Get_Total_Qty___. Modified Update__ and called
--  121115         Get_Total_Qty_Assigned___ instead of Get_Total_Qty___ and Shipment_Order_Line_API.Modify_Qty_Assigned instead of Modify_Qty_Assigned_Shipped. 
--  121107  RoJalk Modified Modify_Line_Reservations and called Customer_Order_Reservation_API.Remove.
--  121102  RoJalk Added the method Get_Total_Qty___, Modify_Shipmnet_Id___  and added code in Insert___, Delete___, Update___ to shipment line qty columns.  
--  120914  MeAblk Added new method Get_Total_Qty_Picked in order to get the summation of all the picked quantities for a given shipment order line.
--  120914         Added Get_Total_Qty_Assigned___,  Get_Total_Qty_Delivered___.  
--  120904  MeAblk Added shipment id and accordingly modified the respective methods.
--  120113  Darklk Bug 100716, Modified the procedure by adding the catch_qty_ parameter.
--  111101  NISMLK SMA-289, Increased eng_chg_level length to STRING(6) in column comments.
--  101124  RaKalk Added pick_list_no to CUSTOMER_ORDER_RES view
--  101116  SHVESE Added new method Split_Reservation_Into_Serials.
--  110131  Nekolk EANE-3744  added where clause to View CUSTOMER_ORDER_RESERVATION.
--  100520  KRPELK Merge Rose Method Documentation.
--  090925  MaMalk Removed unused view SCRAP_CUSTOMER_ORDER_RETURN.
--  ------------------------- 14.0.0 -----------------------------------------
--  091202  DaGulk Bug 85166, Set value for catch_qty_to_deliver within Insert___.
--  091202         Removed parameter catch_qty_ from method New. Added method Catch_Qty_To_Reserve___
--  091202         to calculate catch quantity to be reserved. Called method from Insert___ and Update___ and New.
--  090804  NWeelk Bug 84811, Added column catch_qty_shipped, modified method Modify_On_Delivery__ to handle 
--  090804         parameter catch_qty_shipped and added method Get_Catch_Qty_Shipped.
--  091007  KiSalk Added preliminary_pick_list_no_ to new and Get.
--  081231  MaMalk Bug 70877, Added methods Modify_Qty_To_Deliver and Modify_Catch_Qty_To_Deliver.  
--  081230  ChJalk Bug 70877, Added columns qty_to_deliver and catch_qty_to_deliver. Modified methods New and 
--  081230         Modify_Qty_Picked to handle new columns qty_to_deliver and catch_qty_to_deliver.
--  081209  SuJalk Bug 79018, Added a check in Unpack_Check_Update___ to raise an error message if the quantity assigned is negative when updating a CO reservation.
--  080623  SaJjlk Bug 72602, Added column EXPIRATION_DATE and added parameter expiration_date_ to method Modify_On_Delivery__.
--  090304  KiSalk Added method Manual_Pick_Lines_Exist.
--  090128  KiSalk Added Attribute preliminary_pick_list_no and methods Get_Preliminary_Pick_List_No and Modify_Prelim_Pick_List_No.
--  070312  NiDalk Added method Get_Delnote_No and added Delnote_No to Get.
--  070301  AmPalk Added attribute Delnote_No and method Modify_Delnote_No to the LU.
--  070214  MaJalk Added method Clear_Pick_List_No.
--  060220  NuFilk Added 'NOCHECK' option which previously existed to column Activity_Seq in view.
--  060118  SaJjlk Added the returning clause to method Insert___.
--  050929  IsWilk Modified the view CUSTOMER_ORDER_RES.
--  050927  IsWilk Added the view CUSTOMER_ORDER_RES.
--  050525  SaJjlk Added catch quantity negative validation to Unpack_Check_Update___.
--  050323  GeKalk Moved method Is_Pick_List_Created to ReserveCustomerOrder LU.
--  050318  SaJjlk Added Input UoM validations to methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  050214  GeKalk Added new method Is_Pick_List_Created.
--  041119  GeKalk Removed method Get_Catch_Qty_Shipped.
--  041110  IsAnlk Added catch_qty parameter Modify_On_Delivery__ procedure.
--  041108  IsAnlk Added parameters to Modify_Qty_Picked and removed Modify_Catch_Qty.Modified Modify_On_Delivery__.
--  041104  IsAnlk Removed catch_qty parameter from Modify_On_Delivery__ procedures.
--  041102  GeKalk Added new methods Get_Catch_Qty_Picked and Get_Catch_Qty_Shipped.
--  041022  GeKalk Added a new method Modify_Catch_Qty.
--  041020  IsAnlk Added catch_qty parameter to New and Modify_On_Delivery__ procedures.
--  041020  IsAnlk Added catch_qty.
--  040930  DaZase Added activity_seq as a new key.
--  040825  DaRulk Removed DEFAULT NULL input uom parameters. Instead assign the values inside the code.
--  040812  DaRulk Modified Modify_On_Delivery__ to include input uom parameters.
--  040719  DaRulk Added parameters input_qty_, input_unit_meas_ ,input_conv_factor_, input_variable_values_
--                 to Modify_Qty_Assigned() and New()
--  040511  DaZase Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                 the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  -------------------------------- 13.3.0 ----------------------------------
--  031017  SaNalk Removed the PROCEDURE Check_Reserved_Serial_Part.
--  030918  KaDilk Bug 38174,Added PROCEDURE Check_Reserved_Serial_Part.
--  030905  WaJalk Changed error message in Modify_Qty_Picked.
--  030520  ChIwlk Changed procedure Modify_Qty_Picked to stop pick reporting more than
--  030520         the reserved quantity when supply code is MRO.
--  020731  SAABLK Corrected Call ID 87001 by modifying the Insert Method.
--  020712  MAEELK Removed public attribute Condition_Code from the LU.
--  020627  MAEELK Changed comments on CONDITION_CODE in CUSTOMER_ORDER_RESERVATION.
--  020613  MAEELK Added new public attribute Condition_Code to the LU.
--  020522  SUAMLK Changed VIEW COMMENTS in the views CUSTOMER_ORDER_RESERVATION and
--                 SCRAP_CUSTOMER_ORDER_RETURN.
--  ******************************** AD 2002-3 Baseline ************************************
--  001020  JakH  Changed the key of this lu to use InventoryPartInStock instead of InventoryPartLocation,
--                this added the key Configuration_Id to all methods.
--  001005  JoEd  Bug fix 17459. Added method Pick_List_Exist.
--  000928  JoEd  Removed Exist call from 'DELIV_NO' in the Unpack_... loops.
--  000912  JoEd  Added method Modify_On_Delivery__ and added column deliv_no.
--  ---------------------- 12.1 ---------------------------------------------
--  991007  JoEd  Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  ---------------------- 11.1 ---------------------------------------------
--  990420  JoAn  Changed Modify_Pick_List_No.
--  990416  JakH  Minor fixes.
--  990412  PaLJ  YOSHIMURA - New Template
--  990406  JakH  Y.CID 10582 Removed use of Gen_Def_Key_value. use '*' where possible.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  981207  JoEd  Changed qty_... column comments.
--  980401  RaKu  Added view SCRAP_CUSTOMER_ORDER_RETURN.
--  971124  RaKu  Changed to FND200 Templates.
--  971006  LEPE  Added NOCHECK option for REF=InventoryPartLocation.
--  970521  RaKu  Moved function Exist_Reserved to Reserve_Customer_Order.
--  970509  RaKu  Made changes in Unpack_Check_Update__ with pallet_id.
--  970429  RaKu  Changed check on pallet_id.
--  970428  RaKu  Added pallet_id in table and all handling of it.
--  970424  JoEd  BUG 97-0032 Added function Exist_Reserved.
--  970422  RaKu  Removed status_code from table and all handling of it.
--  970319  RaKu  Added column qty_picked and all handling of it.
--                Added function Get_Qty_Picked, procedure Modify_Qty_Picked.
--                Added qty_picked in procedure New.
--  970312  RaKu  Changed table name.
--  970219  EVWE  Changed to rowversion (Project 10.3)
--  970130  PEOD  Minor corrections in New
--  951106  STOL  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;
number_null_ CONSTANT NUMBER       := -99999999999999;

TYPE Keys_Rec IS RECORD (
   order_no         customer_order_reservation_tab.order_no%TYPE,
   line_no          customer_order_reservation_tab.line_no%TYPE,
   rel_no           customer_order_reservation_tab.rel_no%TYPE,
   line_item_no     customer_order_reservation_tab.line_item_no%TYPE,
   contract         customer_order_reservation_tab.contract%TYPE,
   part_no          customer_order_reservation_tab.part_no%TYPE,
   location_no      customer_order_reservation_tab.location_no%TYPE,
   lot_batch_no     customer_order_reservation_tab.lot_batch_no%TYPE,
   serial_no        customer_order_reservation_tab.serial_no%TYPE,
   eng_chg_level    customer_order_reservation_tab.eng_chg_level%TYPE,
   waiv_dev_rej_no  customer_order_reservation_tab.waiv_dev_rej_no%TYPE,
   activity_seq     customer_order_reservation_tab.activity_seq%TYPE,
   handling_unit_id customer_order_reservation_tab.handling_unit_id%TYPE,
   configuration_id customer_order_reservation_tab.configuration_id%TYPE,
   pick_list_no     customer_order_reservation_tab.pick_list_no%TYPE,
   shipment_id      customer_order_reservation_tab.shipment_id%TYPE);

TYPE Keys_Tab IS TABLE OF Keys_Rec
INDEX BY PLS_INTEGER;

TYPE Keys_And_Qty_Rec IS RECORD (
   order_no         customer_order_reservation_tab.order_no%TYPE,
   line_no          customer_order_reservation_tab.line_no%TYPE,
   rel_no           customer_order_reservation_tab.rel_no%TYPE,
   line_item_no     customer_order_reservation_tab.line_item_no%TYPE,
   contract         customer_order_reservation_tab.contract%TYPE,
   part_no          customer_order_reservation_tab.part_no%TYPE,
   location_no      customer_order_reservation_tab.location_no%TYPE,
   lot_batch_no     customer_order_reservation_tab.lot_batch_no%TYPE,
   serial_no        customer_order_reservation_tab.serial_no%TYPE,
   eng_chg_level    customer_order_reservation_tab.eng_chg_level%TYPE,
   waiv_dev_rej_no  customer_order_reservation_tab.waiv_dev_rej_no%TYPE,
   activity_seq     customer_order_reservation_tab.activity_seq%TYPE,
   handling_unit_id customer_order_reservation_tab.handling_unit_id%TYPE,
   configuration_id customer_order_reservation_tab.configuration_id%TYPE,
   pick_list_no     customer_order_reservation_tab.pick_list_no%TYPE,
   shipment_id      customer_order_reservation_tab.shipment_id%TYPE,
   Quantity         customer_order_reservation_tab.qty_assigned%TYPE);

TYPE Keys_And_Qty_Tab IS TABLE OF Keys_And_Qty_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_      CONSTANT VARCHAR2(4) := Fnd_Boolean_API.DB_TRUE;
db_false_     CONSTANT VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Attribute___
--   Modify attributes in the CustomerOrderReservation LU
PROCEDURE Modify_Attribute___ (
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   rel_no_                  IN VARCHAR2,
   line_item_no_            IN NUMBER,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   handling_unit_id_        IN NUMBER,
   pick_list_no_            IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   shipment_id_             IN NUMBER,
   attr_                    IN VARCHAR2 ) 
IS
   newrec_     CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   oldrec_     CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   temp_attr_  VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_,
                              contract_, part_no_, location_no_, lot_batch_no_,
                              serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, 
                              handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_ );
   newrec_ := oldrec_;
   temp_attr_ := attr_;
   Unpack___(newrec_, indrec_, temp_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, temp_attr_);   
   Update___(objid_, oldrec_, newrec_, temp_attr_, objversion_, TRUE);
END Modify_Attribute___;


-- Catch_Qty_To_Reserve___
--   This procedure will return catch_qty_ as an out parameter.
PROCEDURE Catch_Qty_To_Reserve___ (
   catch_qty_        IN OUT NUMBER,
   contract_         IN     VARCHAR2,
   part_no_          IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2,
   location_no_      IN     VARCHAR2,
   lot_batch_no_     IN     VARCHAR2,
   serial_no_        IN     VARCHAR2,
   eng_chg_level_    IN     VARCHAR2,
   waiv_dev_rej_no_  IN     VARCHAR2,
   activity_seq_     IN     NUMBER,
   handling_unit_id_ IN     NUMBER,
   qty_assigned_     IN     NUMBER )
IS
   inv_rec_    Inventory_Part_In_Stock_API.Public_Rec; 
   partca_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   partca_rec_ := Part_Catalog_API.Get(part_no_);

   IF (partca_rec_.catch_unit_enabled = 'TRUE') THEN
      IF catch_qty_ IS NULL THEN
         inv_rec_ := Inventory_Part_In_Stock_API.Get(contract_,
                                                     part_no_,
                                                     configuration_id_,
                                                     location_no_,
                                                     lot_batch_no_,
                                                     serial_no_,
                                                     eng_chg_level_,
                                                     waiv_dev_rej_no_,
                                                     activity_seq_,
                                                     handling_unit_id_);

         IF (qty_assigned_ = inv_rec_.qty_onhand) THEN
            catch_qty_ := inv_rec_.catch_qty_onhand;
         END IF;
      END IF;
   ELSE
      IF catch_qty_ IS NOT NULL THEN
         catch_qty_ := NULL;
      END IF;
   END IF;
END Catch_Qty_To_Reserve___;


PROCEDURE Post_Update_Actions___ (
   oldrec_                  IN CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE,
   newrec_                  IN CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE,
   reassignment_type_       IN VARCHAR2, 
   move_to_ship_location_   IN VARCHAR2,
   undo_delivery_           IN VARCHAR2,
   ship_handling_unit_id_   IN NUMBER )
  
IS
   qty_assigned_          NUMBER := 0;
   qty_picked_            NUMBER := 0;
   info_                  VARCHAR2(1000);
   shipment_line_no_      NUMBER; 
   qty_assigned_changed_  BOOLEAN := FALSE;
   qty_picked_changed_    BOOLEAN := FALSE;
   pick_list_no_changed_  BOOLEAN := FALSE;
   new_reassignment_type_ VARCHAR2(20) := reassignment_type_;
BEGIN
   IF Validate_SYS.Is_Changed(oldrec_.qty_assigned, newrec_.qty_assigned) THEN
      qty_assigned_ := newrec_.qty_assigned - oldrec_.qty_assigned; 
      qty_assigned_changed_ := TRUE;
   END IF;
   
   IF Validate_SYS.Is_Changed(oldrec_.qty_picked, newrec_.qty_picked) THEN
      qty_picked_   := newrec_.qty_picked - oldrec_.qty_picked;
      qty_picked_changed_ := TRUE;
   END IF;
   
   IF Validate_SYS.Is_Changed(oldrec_.pick_list_no, newrec_.pick_list_no) THEN        
      pick_list_no_changed_ := TRUE;
   END IF;
  
   IF (((newrec_.shipment_id != 0) AND (qty_assigned_changed_ OR qty_picked_changed_)) AND (newrec_.deliv_no IS NULL)) THEN
      -- partial transfer/modification due to reservation in the CO reservation record
      
      IF (move_to_ship_location_ = 'FALSE') THEN
         -- update qty columns in shipment line
         Shipment_Line_API.Update_On_Reserve(newrec_.shipment_id,  
                                             newrec_.order_no, 
                                             newrec_.line_no, 
                                             newrec_.rel_no, 
                                             newrec_.line_item_no, 
                                             Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                             qty_assigned_, 
                                             qty_picked_,
                                             qty_modification_source_ => new_reassignment_type_,
                                             qty_shipped_ => newrec_.qty_shipped,
                                             undo_delivery_ => undo_delivery_);
      END IF;
      
      IF ((NVL(new_reassignment_type_,  Database_Sys.string_null_) != 'HANDLING_UNIT') AND (qty_assigned_ < 0)) THEN
         shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(newrec_.shipment_id, newrec_.order_no, newrec_.line_no, newrec_.rel_no, 
                                                                             newrec_.line_item_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER );
         Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify(info_ => info_,
                                                         source_ref1_             => newrec_.order_no, 
                                                         source_ref2_             => newrec_.line_no, 
                                                         source_ref3_             => newrec_.rel_no, 
                                                         source_ref4_             => newrec_.line_item_no, 
                                                         contract_                => newrec_.contract, 
                                                         part_no_                 => newrec_.part_no, 
                                                         location_no_             => newrec_.location_no,
                                                         lot_batch_no_            => newrec_.lot_batch_no, 
                                                         serial_no_               => newrec_.serial_no, 
                                                         eng_chg_level_           => newrec_.eng_chg_level, 
                                                         waiv_dev_rej_no_         => newrec_.waiv_dev_rej_no, 
                                                         activity_seq_            => newrec_.activity_seq, 
                                                         reserv_handling_unit_id_ => newrec_.handling_unit_id,
                                                         configuration_id_        => newrec_.configuration_id,
                                                         pick_list_no_            => newrec_.pick_list_no, 
                                                         shipment_id_             => newrec_.shipment_id,
                                                         shipment_line_no_        => shipment_line_no_,
                                                         new_quantity_            => newrec_.qty_assigned,
                                                         old_quantity_            => oldrec_.qty_assigned,
                                                         only_check_              => FALSE,
                                                         handling_unit_id_        => ship_handling_unit_id_);                                                
      END IF;
   END IF;

   -- If a reservation on a pick list have had its quantity changed or a reservation was added to/removed from a pick list we need to refresh the snapshot.
   IF ((newrec_.pick_list_no != '*' AND oldrec_.qty_assigned != newrec_.qty_assigned) OR 
         newrec_.pick_list_no != oldrec_.pick_list_no) THEN
      Hu_Snapshot_For_Refresh_API.New(source_ref1_          => newrec_.pick_list_no,
                                      source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
   END IF;
   
   IF (newrec_.on_transport_task = db_true_) THEN
      IF (qty_assigned_changed_) THEN
         Transport_Task_API.Modify_Order_Reservation_Qty(from_contract_          => newrec_.contract,
                                                         part_no_                => newrec_.part_no,
                                                         configuration_id_       => newrec_.configuration_id,
                                                         from_location_no_       => newrec_.location_no,
                                                         lot_batch_no_           => newrec_.lot_batch_no,
                                                         serial_no_              => newrec_.serial_no,
                                                         eng_chg_level_          => newrec_.eng_chg_level,
                                                         waiv_dev_rej_no_        => newrec_.waiv_dev_rej_no,
                                                         activity_seq_           => newrec_.activity_seq,
                                                         handling_unit_id_       => newrec_.handling_unit_id,
                                                         quantity_diff_          => qty_assigned_,
                                                         catch_quantity_diff_    => NULL,
                                                         order_ref1_             => newrec_.order_no,
                                                         order_ref2_             => newrec_.line_no,
                                                         order_ref3_             => newrec_.rel_no,
                                                         order_ref4_             => newrec_.line_item_no,
                                                         pick_list_no_           => newrec_.pick_list_no,
                                                         shipment_id_            => newrec_.shipment_id,
                                                         order_type_db_          => Order_Type_API.DB_CUSTOMER_ORDER );
      END IF;
      
      IF (pick_list_no_changed_) THEN              
         IF ((oldrec_.pick_list_no = '*' AND newrec_.pick_list_no  != '*') AND newrec_.qty_picked = 0) THEN
            Transport_Task_API.Modify_Order_Pick_List(contract_          => oldrec_.contract,
                                                      part_no_           => oldrec_.part_no,
                                                      configuration_id_  => oldrec_.configuration_id,
                                                      location_no_       => oldrec_.location_no,
                                                      lot_batch_no_      => oldrec_.lot_batch_no,
                                                      serial_no_         => oldrec_.serial_no,
                                                      eng_chg_level_     => oldrec_.eng_chg_level,
                                                      waiv_dev_rej_no_   => oldrec_.waiv_dev_rej_no,
                                                      activity_seq_      => oldrec_.activity_seq,
                                                      handling_unit_id_  => oldrec_.handling_unit_id,
                                                      quantity_          => oldrec_.qty_assigned,
                                                      catch_quantity_    => oldrec_.catch_qty,
                                                      order_ref1_        => oldrec_.order_no,
                                                      order_ref2_        => oldrec_.line_no,
                                                      order_ref3_        => oldrec_.rel_no,
                                                      order_ref4_        => oldrec_.line_item_no,
                                                      pick_list_no_      => oldrec_.pick_list_no,
                                                      shipment_id_       => oldrec_.shipment_id,
                                                      order_type_db_     => Order_Type_API.DB_CUSTOMER_ORDER,                                                         
                                                      new_pick_list_no_  => newrec_.pick_list_no );                                                  
            
         END IF;         
      END IF;
   END IF;   
END Post_Update_Actions___;


PROCEDURE Post_Delete_Actions___ (
   remrec_                  IN CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE,
   reassignment_type_       IN VARCHAR2, 
   move_to_ship_location_   IN VARCHAR2 )
IS
   reserved_handling_unit_exist_ VARCHAR2(5);
   shipment_line_no_             NUMBER; 
BEGIN
   IF (remrec_.shipment_id != 0) THEN
      IF (move_to_ship_location_ = 'FALSE') THEN
         Shipment_Line_API.Update_On_Reserve(remrec_.shipment_id, 
                                             remrec_.order_no, 
                                             remrec_.line_no, 
                                             remrec_.rel_no, 
                                             remrec_.line_item_no, 
                                             Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                             -(remrec_.qty_assigned), 
                                             -(remrec_.qty_picked),
                                             qty_modification_source_ => reassignment_type_,
                                             qty_shipped_ => NULL);
      END IF;
      
      shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(remrec_.shipment_id,
                                                                          remrec_.order_no,
                                                                          remrec_.line_no, 
                                                                          remrec_.rel_no, 
                                                                          remrec_.line_item_no,
                                                                          Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER );
                                                                                          
      reserved_handling_unit_exist_ := Shipment_Reserv_Handl_Unit_API.Handling_Unit_Exist(remrec_.order_no,
                                                                                          remrec_.line_no, 
                                                                                          remrec_.rel_no, 
                                                                                          remrec_.line_item_no, 
                                                                                          remrec_.contract, 
                                                                                          remrec_.part_no, 
                                                                                          remrec_.location_no,
                                                                                          remrec_.lot_batch_no, 
                                                                                          remrec_.serial_no, 
                                                                                          remrec_.eng_chg_level, 
                                                                                          remrec_.waiv_dev_rej_no, 
                                                                                          remrec_.activity_seq, 
                                                                                          remrec_.handling_unit_id,
                                                                                          remrec_.configuration_id,
                                                                                          remrec_.pick_list_no, 
                                                                                          remrec_.shipment_id,
                                                                                          shipment_line_no_ );
      IF (reserved_handling_unit_exist_ = db_true_) THEN
         Shipment_Reserv_Handl_Unit_API.Remove_Handling_Unit(remrec_.order_no,
                                                             remrec_.line_no, 
                                                             remrec_.rel_no, 
                                                             remrec_.line_item_no, 
                                                             remrec_.contract, 
                                                             remrec_.part_no, 
                                                             remrec_.location_no,
                                                             remrec_.lot_batch_no, 
                                                             remrec_.serial_no, 
                                                             remrec_.eng_chg_level, 
                                                             remrec_.waiv_dev_rej_no, 
                                                             remrec_.activity_seq, 
                                                             remrec_.handling_unit_id,
                                                             remrec_.configuration_id,
                                                             remrec_.pick_list_no, 
                                                             remrec_.shipment_id,
                                                             shipment_line_no_ );
      END IF;
   END IF;
   
   IF (remrec_.pick_list_no != '*') THEN
      Hu_Snapshot_For_Refresh_API.New(source_ref1_          => remrec_.pick_list_no,
                                      source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
   END IF;
   
   IF (remrec_.on_Transport_task = db_true_) THEN
      Transport_Task_API.Modify_Order_Reservation_Qty(from_contract_          => remrec_.contract,
                                                      part_no_                => remrec_.part_no,
                                                      configuration_id_       => remrec_.configuration_id,
                                                      from_location_no_       => remrec_.location_no,
                                                      lot_batch_no_           => remrec_.lot_batch_no,
                                                      serial_no_              => remrec_.serial_no,
                                                      eng_chg_level_          => remrec_.eng_chg_level,
                                                      waiv_dev_rej_no_        => remrec_.waiv_dev_rej_no,
                                                      activity_seq_           => remrec_.activity_seq,
                                                      handling_unit_id_       => remrec_.handling_unit_id,
                                                      quantity_diff_          => -(remrec_.qty_assigned),
                                                      catch_quantity_diff_    => -(remrec_.catch_qty),
                                                      order_ref1_             => remrec_.order_no,
                                                      order_ref2_             => remrec_.line_no,
                                                      order_ref3_             => remrec_.rel_no,
                                                      order_ref4_             => remrec_.line_item_no,
                                                      pick_list_no_           => remrec_.pick_list_no,
                                                      shipment_id_            => remrec_.shipment_id,
                                                      order_type_db_          => Order_Type_API.DB_CUSTOMER_ORDER);
   END IF;
END Post_Delete_Actions___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', User_Default_API.Get_Contract, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   reassignment_type_     VARCHAR2(20);
   move_to_ship_location_ VARCHAR2(5);
BEGIN
   newrec_.last_activity_date := Site_API.Get_Site_Date(newrec_.contract);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', newrec_.last_activity_date, attr_);
   newrec_.source         := Fnd_Session_API.Get_Fnd_User;
   reassignment_type_     := Client_SYS.Get_Item_Value('REASSIGNMENT_TYPE', attr_);
   move_to_ship_location_ := NVL(Client_SYS.Get_Item_Value('MOVE_TO_SHIP_LOCATION', attr_), 'FALSE');

   -- In case pick_by_choice_blocked is set as FALSE by default (e.g. by automatic reservation), check to see if there are already existing 
   -- reservations to get the same pick_by_choice_blocked on all of them
   IF (newrec_.pick_by_choice_blocked = Fnd_Boolean_API.DB_FALSE) THEN 
      -- Given the stock keys it will return the setting for block parameter on the other pick list line reservation if any. 
      -- So that in autoamtic reservation, it will copy the setting for 'blocked for PBC' on reservation from other pick list line(s) if there is any. 
      newrec_.pick_by_choice_blocked := Get_Pick_By_Choice_Blocked_Db(newrec_.order_no, 
                                                                      newrec_.line_no, 
                                                                      newrec_.rel_no, 
                                                                      newrec_.line_item_no, 
                                                                      newrec_.contract, 
                                                                      newrec_.part_no, 
                                                                      newrec_.location_no, 
                                                                      newrec_.lot_batch_no, 
                                                                      newrec_.serial_no, 
                                                                      newrec_.eng_chg_level, 
                                                                      newrec_.waiv_dev_rej_no, 
                                                                      newrec_.activity_seq, 
                                                                      newrec_.handling_unit_id, 
                                                                      newrec_.configuration_id, 
                                                                      newrec_.shipment_id);
   END IF;
   
   Catch_Qty_To_Reserve___(newrec_.catch_qty,
                           newrec_.contract,
                           newrec_.part_no,
                           newrec_.configuration_id,
                           newrec_.location_no,
                           newrec_.lot_batch_no,
                           newrec_.serial_no,
                           newrec_.eng_chg_level,
                           newrec_.waiv_dev_rej_no,
                           newrec_.activity_seq,
                           newrec_.handling_unit_id,
                           newrec_.qty_assigned);

   newrec_.catch_qty_to_deliver := newrec_.catch_qty;

   super(objid_, objversion_, newrec_, attr_);
   
   IF ((newrec_.shipment_id != 0) AND (move_to_ship_location_ = 'FALSE')) THEN
      Shipment_Line_API.Update_On_Reserve(newrec_.shipment_id, 
                                          newrec_.order_no, 
                                          newrec_.line_no, 
                                          newrec_.rel_no, 
                                          newrec_.line_item_no, 
                                          Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                          newrec_.qty_assigned, 
                                          newrec_.qty_picked,
                                          qty_modification_source_ => reassignment_type_,
                                          qty_shipped_ => newrec_.qty_shipped);
   END IF;    
   
   IF (newrec_.pick_list_no != '*') THEN
      Hu_Snapshot_For_Refresh_API.New(source_ref1_          => newrec_.pick_list_no,
                                      source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_                   IN     VARCHAR2,
   oldrec_                  IN     CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE,
   newrec_                  IN OUT CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE,
   attr_                    IN OUT VARCHAR2,
   objversion_              IN OUT VARCHAR2,
   by_keys_                 IN     BOOLEAN DEFAULT FALSE )
  
IS
   reassignment_type_     VARCHAR2(20);
   move_to_ship_location_ VARCHAR2(5);
   undo_delivery_         VARCHAR2(5);
   ship_handling_unit_id_ NUMBER;
BEGIN
   newrec_.last_activity_date := Site_API.Get_Site_Date(newrec_.contract);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', newrec_.last_activity_date, attr_);
   newrec_.source             := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('SOURCE', newrec_.source, attr_);
   reassignment_type_         := Client_SYS.Get_Item_Value('REASSIGNMENT_TYPE', attr_);
   move_to_ship_location_     := NVL(Client_SYS.Get_Item_Value('MOVE_TO_SHIP_LOCATION', attr_), 'FALSE');
   undo_delivery_             := NVL(Client_SYS.Get_Item_Value('UNDO_DELIVERY', attr_), 'FALSE');
   ship_handling_unit_id_     := Client_SYS.Get_Item_Value('SHIP_HANDLING_UNIT_ID', attr_);

   Catch_Qty_To_Reserve___(newrec_.catch_qty,
                           newrec_.contract,
                           newrec_.part_no,
                           newrec_.configuration_id,
                           newrec_.location_no,
                           newrec_.lot_batch_no,
                           newrec_.serial_no,
                           newrec_.eng_chg_level,
                           newrec_.waiv_dev_rej_no,
                           newrec_.activity_seq,
                           newrec_.handling_unit_id,
                           newrec_.qty_assigned);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   Post_Update_Actions___(oldrec_, 
                          newrec_, 
                          reassignment_type_, 
                          move_to_ship_location_, 
                          undo_delivery_,
                          ship_handling_unit_id_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_                   IN VARCHAR2,
   remrec_                  IN CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE,
   reassignment_type_       IN VARCHAR2 DEFAULT 'FALSE',
   move_to_ship_location_   IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   super(objid_, remrec_);
   Post_Delete_Actions___(remrec_, reassignment_type_, move_to_ship_location_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   reassignment_type_   VARCHAR2(20);
BEGIN   
   newrec_.configuration_id       := NVL(newrec_.configuration_id, '*');  
   newrec_.activity_seq           := NVL(newrec_.activity_seq, 0); 
   newrec_.handling_unit_id       := NVL(newrec_.handling_unit_id, 0);
   newrec_.on_transport_task      := NVL(newrec_.on_transport_task , db_false_);
   newrec_.pick_by_choice_blocked := NVL(newrec_.pick_by_choice_blocked , db_false_);
   reassignment_type_             := Client_SYS.Get_Item_Value('REASSIGNMENT_TYPE', attr_);
   IF (newrec_.input_unit_meas IS NOT NULL) AND (newrec_.input_qty IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INPUTQTYNEEDED: Input quantity must be entered when Input UoM has a value');
   END IF;
   
   IF (newrec_.qty_to_deliver is NULL or newrec_.qty_to_deliver <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKQTYTODEL: The quantity to deliver must be either zero or greater than zero.');
   END IF;
   
   IF ((newrec_.catch_qty_to_deliver IS NULL OR newrec_.catch_qty_to_deliver <0) AND newrec_.catch_qty IS NOT NULL ) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKCATCHQTY: You cannot deliver more than the quantity picked.');
   END IF;
   
   super(newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'CONFIGURATION_ID', newrec_.configuration_id);
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   IF (reassignment_type_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REASSIGNMENT_TYPE', reassignment_type_, attr_);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_reservation_tab%ROWTYPE,
   newrec_ IN OUT customer_order_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   reassignment_type_ VARCHAR2(20);
BEGIN
-- NOTE!!!!!!
-- The column PICK_LIST_NO is a key and therefore updates should not be permitted.
-- However, for now update will be allowed for backward compability reasons.
-- Original code: Error_SYS.Item_Update(lu_name_, 'PICK_LIST_NO');
   reassignment_type_ := Client_SYS.Get_Item_Value('REASSIGNMENT_TYPE', attr_);
   IF (newrec_.catch_qty < 0) THEN
      newrec_.catch_qty := NULL;
   END IF;

   IF (newrec_.input_unit_meas IS NOT NULL) AND (newrec_.input_qty IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INPUTQTYNEEDED: Input quantity must be entered when Input UoM has a value');
   END IF;

   -- qty_assigned cannot be negative for a customer order reservation.
   IF (newrec_.qty_assigned < 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTYASSINGEDNEGATIVE: The quantity reserved may not be negative');
   END IF;
   
   IF (newrec_.qty_to_deliver is NULL or newrec_.qty_to_deliver <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKQTYTODEL: The quantity to deliver must be either zero or greater than zero.');
   END IF;
   
   IF ((newrec_.catch_qty_to_deliver IS NULL OR newrec_.catch_qty_to_deliver <0) AND newrec_.catch_qty IS NOT NULL ) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKCATCHQTY: You cannot deliver more than the quantity picked.');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);

   IF (reassignment_type_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REASSIGNMENT_TYPE', reassignment_type_, attr_);
   END IF;
   IF (indrec_.qty_picked AND newrec_.pick_list_no  != '*' AND newrec_.qty_picked > 0) THEN
      IF (newrec_.on_transport_task = db_true_) THEN                           
         Error_SYS.Record_General(lu_name_, 'NOTPROCEEDTOREPORTPICK: Cannot proceed with report picking when there exist reservations connected to transport tasks' );        
      END IF;
   END IF;     
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Modify_On_Delivery__
--   Modifies some attributes when delivery is made.
PROCEDURE Modify_On_Delivery__ (
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   location_no_           IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   shipment_id_           IN NUMBER,
   expiration_date_       IN DATE,
   qty_shipped_           IN NUMBER,
   qty_assigned_          IN NUMBER,
   qty_picked_            IN NUMBER,
   catch_qty_             IN NUMBER,
   deliv_no_              IN NUMBER,
   input_qty_             IN NUMBER,
   input_unit_meas_       IN VARCHAR2,
   input_conv_factor_     IN NUMBER,
   input_variable_values_ IN VARCHAR2,
   catch_qty_shipped_     IN NUMBER,
   transfer_reservations_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
BEGIN
   IF (NVL(transfer_reservations_, 'FALSE') = 'TRUE') THEN
      -- transfer reservations to customer order line
      Reserve_Shipment_API.Transfer_Line_Reservations(source_ref1_                 => order_no_,
                                                      source_ref2_                 => line_no_,
                                                      source_ref3_                 => rel_no_, 
                                                      source_ref4_                 => line_item_no_, 
                                                      source_ref_type_db_          => Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                                      from_shipment_id_            => shipment_id_, 
                                                      to_shipment_id_              => 0, 
                                                      qty_to_transfer_             => 0,
                                                      transfer_on_add_remove_line_ => TRUE);
   ELSE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
      Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
      Client_SYS.Add_To_Attr('QTY_PICKED', qty_picked_, attr_);
      Client_SYS.Add_To_Attr('CATCH_QTY', catch_qty_, attr_);
      Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
      Client_SYS.Add_To_Attr('INPUT_QTY', input_qty_, attr_);
      Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_, attr_);
      Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_, attr_);
      Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, attr_);
      Client_SYS.Add_To_Attr('EXPIRATION_DATE', expiration_date_, attr_);
      Client_SYS.Add_To_Attr('CATCH_QTY_SHIPPED', catch_qty_shipped_, attr_);
      Client_SYS.Add_To_Attr('QTY_TO_DELIVER', qty_picked_, attr_);
      Client_SYS.Add_To_Attr('CATCH_QTY_TO_DELIVER', catch_qty_, attr_);
      Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                          contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                          eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                          pick_list_no_, configuration_id_, shipment_id_, attr_);
   END IF;
END Modify_On_Delivery__;


PROCEDURE Modify_On_Undo_Delivery__(
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   rel_no_                IN VARCHAR2,
   line_item_no_          IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   location_no_           IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN NUMBER,
   handling_unit_id_      IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   shipment_id_           IN NUMBER,
   qty_shipped_           IN NUMBER,
   qty_assigned_          IN NUMBER,
   qty_picked_            IN NUMBER,
   catch_qty_shipped_     IN NUMBER,
   catch_qty_             IN NUMBER,
   deliv_no_              IN NUMBER )
IS
   attr_       VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
   Client_SYS.Add_To_Attr('QTY_PICKED', qty_picked_, attr_);
   Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY', catch_qty_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY_SHIPPED', catch_qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('UNDO_DELIVERY', 'TRUE', attr_);
   Client_SYS.Add_To_Attr('QTY_TO_DELIVER', qty_picked_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY_TO_DELIVER', catch_qty_, attr_);
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_, shipment_id_, attr_);
END Modify_On_Undo_Delivery__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Oe_Exist
--   Return 1 if any records exist (used by other modules)
@UncheckedAccess
FUNCTION Oe_Exist (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   pick_list_no_     IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   shipment_id_      IN NUMBER   ) RETURN NUMBER
IS
BEGIN
   IF Check_Exist___(order_no_, line_no_, rel_no_, line_item_no_,
                     contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                     eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                     configuration_id_, pick_list_no_, shipment_id_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Oe_Exist;


-- New
--   Inserts a new reservation
PROCEDURE New (
   order_no_                 IN VARCHAR2,
   line_no_                  IN VARCHAR2,
   rel_no_                   IN VARCHAR2,
   line_item_no_             IN NUMBER,
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   location_no_              IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   eng_chg_level_            IN VARCHAR2,
   waiv_dev_rej_no_          IN VARCHAR2,
   activity_seq_             IN NUMBER,
   handling_unit_id_         IN NUMBER,
   pick_list_no_             IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   shipment_id_              IN NUMBER,
   qty_assigned_             IN NUMBER,
   qty_picked_               IN NUMBER,
   qty_shipped_              IN NUMBER,
   input_qty_                IN NUMBER,
   input_unit_meas_          IN VARCHAR2,
   input_conv_factor_        IN NUMBER,
   input_variable_values_    IN VARCHAR2,
   preliminary_pick_list_no_ IN VARCHAR2,
   catch_qty_                IN NUMBER,
   reassignment_type_        IN VARCHAR2 DEFAULT NULL,
   move_to_ship_location_    IN VARCHAR2 DEFAULT 'FALSE',
   pick_by_choice_blocked_   IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   on_transport_task_        IN VARCHAR2 DEFAULT 'FALSE')
IS
   attr_        VARCHAR2(2000);
   newrec_      CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;   
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
   Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, attr_);
   Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
   Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', eng_chg_level_, attr_);
   Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', waiv_dev_rej_no_, attr_);
   Client_SYS.Add_To_Attr('ACTIVITY_SEQ', activity_seq_, attr_);
   Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, attr_);   
   Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
   Client_SYS.Add_To_Attr('QTY_PICKED', qty_picked_, attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('QTY_TO_DELIVER', qty_picked_, attr_);
   Client_SYS.Add_To_Attr('INPUT_QTY', input_qty_, attr_);
   Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_, attr_);
   Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_, attr_);
   Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, attr_);
   Client_SYS.Add_To_Attr('PRELIMINARY_PICK_LIST_NO', preliminary_pick_list_no_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY', catch_qty_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY_TO_DELIVER', catch_qty_, attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, attr_);
   IF (reassignment_type_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REASSIGNMENT_TYPE', reassignment_type_, attr_);
   END IF;
   Client_SYS.Add_To_Attr('MOVE_TO_SHIP_LOCATION', move_to_ship_location_, attr_);
   Client_SYS.Add_To_Attr('PICK_BY_CHOICE_BLOCKED_DB', pick_by_choice_blocked_, attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Remove
--   Removes a reservation
PROCEDURE Remove (
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   rel_no_                  IN VARCHAR2,
   line_item_no_            IN NUMBER,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   handling_unit_id_        IN NUMBER,
   pick_list_no_            IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   shipment_id_             IN NUMBER,
   reassignment_type_       IN VARCHAR2 DEFAULT NULL,
   move_to_ship_location_   IN VARCHAR2 DEFAULT 'FALSE')
IS
   remrec_     CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_,
                              contract_, part_no_, location_no_, lot_batch_no_,
                              serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                              configuration_id_, pick_list_no_, shipment_id_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_,
                             contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                             eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                             configuration_id_, pick_list_no_, shipment_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_, reassignment_type_, move_to_ship_location_);
   
END Remove;


-- Modify_Pick_List_No
--   Updates pick list no from '*' to the value passed in.
PROCEDURE Modify_Pick_List_No (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   shipment_id_         IN NUMBER,
   new_pick_list_no_    IN VARCHAR2 )
IS
   oldrec_             CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   newrec_             CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   attr_               VARCHAR2(2000);
   indrec_             Indicator_Rec;
BEGIN
   -- This method updates one of the key attributes therefore the
   -- Modify_Attribute___ method which updates by keys cannot be used.
   IF (pick_list_no_ != '*') THEN
      Error_SYS.Record_General(lu_name_, 'PICKLISTCREATED: Picklist already created');
   END IF;
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_,
                             contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                             eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                             configuration_id_, pick_list_no_, shipment_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PICK_LIST_NO', new_pick_list_no_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_); 
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   
   IF (shipment_id_ != 0) THEN 
      Pick_Shipment_API.Modify_Reserv_Hu_Pick_List_No(source_ref1_                 => order_no_,
                                                      source_ref2_                 => line_no_,
                                                      source_ref3_                 => rel_no_,
                                                      source_ref4_                 => line_item_no_,
                                                      source_ref_type_db_          => Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                                      contract_                    => contract_,
                                                      part_no_                     => part_no_,
                                                      location_no_                 => location_no_,
                                                      lot_batch_no_                => lot_batch_no_,
                                                      serial_no_                   => serial_no_,
                                                      eng_chg_level_               => eng_chg_level_,
                                                      waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                      activity_seq_                => activity_seq_,
                                                      reserv_handling_unit_id_     => handling_unit_id_,
                                                      configuration_id_            => configuration_id_,
                                                      pick_list_no_                => pick_list_no_,
                                                      shipment_id_                 => shipment_id_,
                                                      new_pick_list_no_            => new_pick_list_no_,
                                                      inv_part_res_source_type_db_ => NULL );
   END IF;
END Modify_Pick_List_No;


-- Modify_Qty_Assigned
--   Updates qty assigned
PROCEDURE Modify_Qty_Assigned (
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   rel_no_                    IN VARCHAR2,
   line_item_no_              IN NUMBER,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   handling_unit_id_          IN NUMBER,
   pick_list_no_              IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   shipment_id_               IN NUMBER, 
   qty_assigned_              IN NUMBER,
   input_qty_                 IN NUMBER,
   input_unit_meas_           IN VARCHAR2,
   input_conv_factor_         IN NUMBER,
   input_variable_values_     IN VARCHAR2,
   pick_by_choice_blocked_db_ IN VARCHAR2 DEFAULT NULL )
IS
   attr_      VARCHAR2(2000);
   catch_qty_ NUMBER := NULL;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
   Client_SYS.Add_To_Attr('INPUT_QTY', input_qty_, attr_);
   Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_, attr_);
   Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_, attr_);
   Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', input_variable_values_, attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY', catch_qty_, attr_);    
   IF (pick_by_choice_blocked_db_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PICK_BY_CHOICE_BLOCKED_DB', pick_by_choice_blocked_db_, attr_);    
   END IF;
   
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_,  shipment_id_, attr_);
END Modify_Qty_Assigned;


-- Modify_Qty_Shipped
--   Updates qty shipped
PROCEDURE Modify_Qty_Shipped (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   shipment_id_         IN NUMBER,
   qty_shipped_         IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_, shipment_id_,  attr_);
END Modify_Qty_Shipped;


-- Modify_On_Transport_Task
--   Updates On_Transport_Task
PROCEDURE Modify_On_Transport_Task (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   location_no_          IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   eng_chg_level_        IN VARCHAR2,
   waiv_dev_rej_no_      IN VARCHAR2,
   activity_seq_         IN NUMBER,
   handling_unit_id_     IN NUMBER,
   pick_list_no_         IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   shipment_id_          IN NUMBER,
   on_transport_task_db_ IN VARCHAR2 )
IS
   attr_     VARCHAR2(2000);  
BEGIN
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ON_TRANSPORT_TASK_DB', on_transport_task_db_, attr_);
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_, shipment_id_,  attr_);
 
END Modify_On_Transport_Task;

-- Pick_List_Exist
--   This will return TRUE (1) if a Customer Order Line has a Pick List No
--   and the reserved quantity of that line is greater than zero.
@UncheckedAccess
FUNCTION Pick_List_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   shipment_id_  IN NUMBER DEFAULT NULL ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR exist_comp_pick_list IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_
      AND    (shipment_id = shipment_id_ OR shipment_id_ IS NULL )
      AND    qty_assigned > 0
      AND    pick_list_no != '*';

   CURSOR exist_pick_list IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    (shipment_id = shipment_id_ OR shipment_id_ IS NULL )
      AND    qty_assigned > 0
      AND    pick_list_no != '*';
BEGIN
   IF (line_item_no_ > 0) THEN
      -- Handle components parts of a package part
      OPEN exist_comp_pick_list;
      FETCH exist_comp_pick_list INTO found_;
      IF (exist_comp_pick_list%NOTFOUND) THEN
         found_ := 0;
      END IF;
      CLOSE exist_comp_pick_list;
      RETURN found_;
   ELSE
      -- Handle sales parts and package parts
      OPEN exist_pick_list;
      FETCH exist_pick_list INTO found_;
      IF (exist_pick_list%NOTFOUND) THEN
         found_ := 0;
      END IF;
      CLOSE exist_pick_list;
      RETURN found_;
   END IF;
END Pick_List_Exist;


@UncheckedAccess
FUNCTION Pick_List_Exist_To_Report (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   shipment_id_    IN NUMBER ) RETURN VARCHAR2
IS
   dummy_                      NUMBER;
   pick_list_exist_to_report_  VARCHAR2(5):='FALSE';

   CURSOR get_lines_to_pick_report IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    ((line_item_no_ = 0 AND line_item_no = line_item_no_) OR (line_item_no_ = -1 AND line_item_no > 0))
      AND    shipment_id = shipment_id_
      AND    qty_assigned > qty_picked
      AND    pick_list_no != '*';
BEGIN
   OPEN  get_lines_to_pick_report;
   FETCH get_lines_to_pick_report INTO dummy_;
   IF (get_lines_to_pick_report%FOUND) THEN
      pick_list_exist_to_report_ := 'TRUE';
   END IF;
   CLOSE get_lines_to_pick_report;
   RETURN pick_list_exist_to_report_;
END Pick_List_Exist_To_Report;


-- Get_Catch_Qty_Picked
--   Returns the total picked quantity in catch unit of measure for a specific order line.
@UncheckedAccess
FUNCTION Get_Catch_Qty_Picked (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   catch_qty_ NUMBER := 0;
   CURSOR get_catch_qty IS
      SELECT SUM(catch_qty)
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_
      AND    qty_picked   > 0
      AND    qty_shipped  = 0;
BEGIN
   OPEN  get_catch_qty;
   FETCH get_catch_qty INTO catch_qty_;
   CLOSE get_catch_qty;
   RETURN NVL(catch_qty_,0);
END Get_Catch_Qty_Picked;


-- Modify_Qty_Picked
--   Modify the qty_picked, qty_assigned, catch_qty and input uom attributes
PROCEDURE Modify_Qty_Picked (
   order_no_               IN VARCHAR2,
   line_no_                IN VARCHAR2,
   rel_no_                 IN VARCHAR2,
   line_item_no_           IN NUMBER,
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   location_no_            IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN NUMBER,
   handling_unit_id_       IN NUMBER,
   pick_list_no_           IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   shipment_id_            IN NUMBER,
   qty_picked_             IN NUMBER,
   catch_qty_              IN NUMBER,
   input_qty_              IN NUMBER,
   input_unit_meas_        IN VARCHAR2,
   input_conv_factor_      IN NUMBER,
   input_variable_values_  IN VARCHAR2,
   move_to_ship_location_  IN VARCHAR2 DEFAULT 'FALSE',
   remaining_qty_assigned_ IN NUMBER   DEFAULT  NULL,
   ship_handling_unit_id_  IN NUMBER   DEFAULT  NULL)
IS
   attr_                   VARCHAR2(2000);
   supply_code_            VARCHAR2(3);
   qty_assigned_           NUMBER;
   local_input_qty_        NUMBER;
   local_input_var_values_ VARCHAR2(2000);
BEGIN
   supply_code_  := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Supply_Code(order_no_, line_no_, rel_no_, line_item_no_));
   qty_assigned_ := Get_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, 
                                     waiv_dev_rej_no_, activity_seq_, handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_);
   IF ((supply_code_ = 'MRO') AND (qty_picked_ > qty_assigned_)) THEN
      Error_SYS.Record_General(lu_name_, 'MROPICKTHANRESERVE: Can not pick report more than the reserved quantity with Supply Code MRO');
   END IF;

   Client_SYS.Clear_Attr(attr_);
   IF (remaining_qty_assigned_ IS NOT NULL) THEN 
      qty_assigned_ := remaining_qty_assigned_;
   ELSE 
      qty_assigned_ := qty_picked_;
   END IF; 
   Client_SYS.Add_To_Attr('QTY_ASSIGNED',          qty_assigned_,          attr_);
   Client_SYS.Add_To_Attr('QTY_PICKED',            qty_picked_,            attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY',             catch_qty_,             attr_);
   Client_SYS.Add_To_Attr('QTY_TO_DELIVER',        qty_picked_,            attr_);
   Client_SYS.Add_To_Attr('CATCH_QTY_TO_DELIVER',  catch_qty_,             attr_);
   Client_SYS.Add_To_Attr('MOVE_TO_SHIP_LOCATION', move_to_ship_location_, attr_);
   Client_SYS.Add_To_Attr('SHIP_HANDLING_UNIT_ID', ship_handling_unit_id_, attr_);

   IF input_conv_factor_ IS NOT NULL THEN
      local_input_qty_        := (qty_assigned_ / input_conv_factor_); 
      local_input_var_values_ := Input_Unit_Meas_API.Get_Input_Value_String(local_input_qty_, input_unit_meas_);
      Client_SYS.Add_To_Attr('INPUT_QTY', local_input_qty_, attr_);
      Client_SYS.Add_To_Attr('INPUT_UNIT_MEAS', input_unit_meas_, attr_);
      Client_SYS.Add_To_Attr('INPUT_CONV_FACTOR', input_conv_factor_, attr_);
      Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', local_input_var_values_, attr_);
   END IF;

   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_, shipment_id_, attr_);
END Modify_Qty_Picked;


PROCEDURE Clear_Pick_List_No (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   shipment_id_         IN NUMBER,
   excess_qty_assigned_ IN NUMBER )
IS
   oldrec_                     CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   newrec_                     CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   objid_                      VARCHAR2(2000);
   objversion_                 VARCHAR2(2000);
   attr_                       VARCHAR2(2000);
   customer_order_reservation_ Customer_Order_Reservation_API.Public_Rec;
   qty_assigned_               NUMBER;
   indrec_                     Indicator_Rec;
BEGIN

   IF Oe_Exist(order_no_,
               line_no_,
               rel_no_,
               line_item_no_,
               contract_,
               part_no_,
               location_no_,
               lot_batch_no_,
               serial_no_,
               eng_chg_level_,
               waiv_dev_rej_no_,
               activity_seq_,
               handling_unit_id_,
               '*',
               configuration_id_,
               shipment_id_ ) = 1 THEN
      qty_assigned_ := Get_Qty_Assigned(order_no_,
                                       line_no_,
                                       rel_no_,
                                       line_item_no_,
                                       contract_,
                                       part_no_,
                                       location_no_,
                                       lot_batch_no_,
                                       serial_no_,
                                       eng_chg_level_,
                                       waiv_dev_rej_no_,
                                       activity_seq_,
                                       handling_unit_id_, 
                                       configuration_id_,
                                       '*',
                                       shipment_id_ );

      Modify_Qty_Assigned(order_no_               => order_no_,
                          line_no_                => line_no_,
                          rel_no_                 => rel_no_,
                          line_item_no_           => line_item_no_,
                          contract_               => contract_,
                          part_no_                => part_no_,
                          location_no_            => location_no_,
                          lot_batch_no_           => lot_batch_no_,
                          serial_no_              => serial_no_,
                          eng_chg_level_          => eng_chg_level_,
                          waiv_dev_rej_no_        => waiv_dev_rej_no_,
                          activity_seq_           => activity_seq_,
                          handling_unit_id_       => handling_unit_id_,
                          pick_list_no_           => '*',
                          configuration_id_       => configuration_id_,
                          shipment_id_            => shipment_id_,
                          qty_assigned_           => excess_qty_assigned_ + qty_assigned_,
                          input_qty_              => NULL,
                          input_unit_meas_        => NULL,
                          input_conv_factor_      => NULL,
                          input_variable_values_  => NULL);

      Remove(order_no_,
             line_no_,
             rel_no_,
             line_item_no_,
             contract_,
             part_no_,
             location_no_,
             lot_batch_no_,
             serial_no_,
             eng_chg_level_,
             waiv_dev_rej_no_,
             activity_seq_,
             handling_unit_id_,
             pick_list_no_,
             configuration_id_,
             shipment_id_);      
   ELSE
      customer_order_reservation_ := Get(order_no_, line_no_, rel_no_, line_item_no_,
                                         contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                         eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                         pick_list_no_, configuration_id_, shipment_id_);

      IF (customer_order_reservation_.qty_picked > 0 OR customer_order_reservation_.qty_shipped > 0) THEN
         Error_SYS.Record_General(lu_name_, 'PICKLISTNOTMODIFY: Picklist cannot be modified.');
      END IF;

      Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_,
                                contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                configuration_id_, pick_list_no_, shipment_id_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_NO', '*', attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END Clear_Pick_List_No;


-- Modify_Delnote_No
--   This method can be used to modify the delnote_no.
PROCEDURE Modify_Delnote_No (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   shipment_id_         IN NUMBER,
   delnote_no_          IN VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DELNOTE_NO', delnote_no_, attr_);
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, 
                       serial_no_, eng_chg_level_, waiv_dev_rej_no_, 
                       activity_seq_, handling_unit_id_, pick_list_no_, 
                       configuration_id_, shipment_id_, attr_);
END Modify_Delnote_No;


PROCEDURE Modify_Prelim_Pick_List_No (
   order_no_                 IN VARCHAR2,
   line_no_                  IN VARCHAR2,
   rel_no_                   IN VARCHAR2,
   line_item_no_             IN NUMBER,
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   location_no_              IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   eng_chg_level_            IN VARCHAR2,
   waiv_dev_rej_no_          IN VARCHAR2,
   activity_seq_             IN NUMBER,
   handling_unit_id_         IN NUMBER,
   pick_list_no_             IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   shipment_id_              IN NUMBER,
   preliminary_pick_list_no_ IN NUMBER )
IS
   attr_              VARCHAR2(2000);
   worker_id_         VARCHAR2(20);
   task_type_         VARCHAR2(32);
   shipment_creation_ Customer_Order_Line.shipment_creation%TYPE;
BEGIN

   IF (preliminary_pick_list_no_ IS NOT NULL) THEN
      worker_id_ := Manual_Consol_Pick_List_API.Get_Worker_Id(preliminary_pick_list_no_);
      IF worker_id_ IS NOT NULL THEN
         task_type_ := 'CUSTOMER ORDER PICK LIST';
         IF NOT Warehouse_Worker_Task_Type_API.Is_Active_Worker(contract_, worker_id_, task_type_) THEN
            Error_SYS.Record_General(lu_name_,'NOCOPLTYPE: The Worker :P1 is not allowed to perform '':P2'' Type Tasks, see Warehouse Worker Task Type.', worker_id_, Warehouse_Task_Type_API.Decode(task_type_));
         END IF;
      END IF;
      shipment_creation_ := Customer_Order_Line_Api.Get_Shipment_Creation(order_no_, line_no_, rel_no_, line_item_no_);
      IF (Shipment_Creation_API.Encode(shipment_creation_) = 'PICK_LIST_CREATION') THEN
         Error_SYS.Record_General(lu_name_, 'SHIPLINE_ERR: Customer order lines with shipment creation method '':P1'' cannot be connected to a manual consolidated pick list.', shipment_creation_);
      END IF;
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PRELIMINARY_PICK_LIST_NO', preliminary_pick_list_no_, attr_);
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_, shipment_id_,  attr_);
END Modify_Prelim_Pick_List_No;


@UncheckedAccess
FUNCTION Manual_Pick_Lines_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB res, manual_consol_pick_list_tab mcpl
      WHERE  res.pick_list_no = '*'
      AND    res.preliminary_pick_list_no = mcpl.preliminary_pick_list_no
      AND    res.order_no     = order_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(1);
   END IF;
   CLOSE exist_control;
   RETURN(0);
END Manual_Pick_Lines_Exist;


PROCEDURE Modify_Qty_To_Deliver (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   shipment_id_         IN NUMBER,
   qty_to_deliver_      IN NUMBER )
IS
   attr_ VARCHAR2(2000) := NULL;      
BEGIN
   Client_SYS.Add_To_Attr('QTY_TO_DELIVER', qty_to_deliver_, attr_);   
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_,  shipment_id_, attr_);
END Modify_Qty_To_Deliver;


PROCEDURE Modify_Catch_Qty_To_Deliver (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER,
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   location_no_          IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   eng_chg_level_        IN VARCHAR2,
   waiv_dev_rej_no_      IN VARCHAR2,
   activity_seq_         IN NUMBER,
   handling_unit_id_     IN NUMBER,
   pick_list_no_         IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   shipment_id_          IN NUMBER,
   catch_qty_to_deliver_ IN NUMBER )
IS
   attr_ VARCHAR2(2000) := NULL;   
BEGIN
   Client_SYS.Add_To_Attr('CATCH_QTY_TO_DELIVER', catch_qty_to_deliver_, attr_);   
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                       pick_list_no_, configuration_id_,  shipment_id_, attr_);
END Modify_Catch_Qty_To_Deliver;


PROCEDURE Split_Reservation_Into_Serials (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   shipment_id_         IN NUMBER, 
   serial_catch_tab_    IN Inventory_Part_In_Stock_API.Serial_Catch_Table )
IS
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
   remrec_                    CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   newrec_                    CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   count_serials_             NUMBER;
   order_rec_                 Customer_Order_Line_API.Public_Rec;
   indrec_                    Indicator_Rec;
   input_qty_                 NUMBER;
BEGIN
   -- First Lock the '*' serial reservation record
   remrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_,
                              contract_, part_no_, location_no_, lot_batch_no_,
                              '*', eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, 
                              configuration_id_, pick_list_no_, shipment_id_);

   Inventory_Event_Manager_API.Start_Session;
   count_serials_ := serial_catch_tab_.COUNT;
   -- Then add the reservation for each serial
   IF (count_serials_ > 0) THEN
      FOR i IN serial_catch_tab_.FIRST..serial_catch_tab_.LAST LOOP
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
         Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
         Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
         Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
         Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
         Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
         Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, attr_);
         Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, attr_);
         Client_SYS.Add_To_Attr('SERIAL_NO', serial_catch_tab_(i).serial_no, attr_);
         Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', eng_chg_level_, attr_);
         Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', waiv_dev_rej_no_, attr_);
         Client_SYS.Add_To_Attr('ACTIVITY_SEQ', activity_seq_, attr_);
         Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, attr_);
         Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, attr_);
         Client_SYS.Add_To_Attr('QTY_ASSIGNED', 1, attr_);
         Client_SYS.Add_To_Attr('QTY_PICKED', 0, attr_);
         Client_SYS.Add_To_Attr('QTY_SHIPPED', 0, attr_);
         Client_SYS.Add_To_Attr('QTY_TO_DELIVER', 0, attr_);
         Client_SYS.Add_To_Attr('CATCH_QTY', serial_catch_tab_(i).catch_qty, attr_);
         Client_SYS.Add_To_Attr('PICK_BY_CHOICE_BLOCKED_DB', remrec_.pick_by_choice_blocked, attr_);
         -- input UoM parameters are not considered from the removed record since they should be manually entered when report picking
         -- preliminary pick list no is picked up from the serial '*' record
         Client_SYS.Add_To_Attr('PRELIMINARY_PICK_LIST_NO', remrec_.preliminary_pick_list_no, attr_);
         Reset_Indicator_Rec___(indrec_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);

         $IF (Component_Cromfg_SYS.INSTALLED) $THEN
            order_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
            IF (order_rec_.demand_code = 'CRE' AND order_rec_.supply_code = 'CRO') THEN
               Cro_Exchange_Reservation_API.Update_Cro_Exchange_Details(order_rec_.demand_order_ref1,
                                                                        order_rec_.demand_order_ref2,
                                                                        contract_, 
                                                                        part_no_, 
                                                                        configuration_id_,
                                                                        location_no_,
                                                                        lot_batch_no_,
                                                                        serial_catch_tab_(i).serial_no,
                                                                        eng_chg_level_,
                                                                        waiv_dev_rej_no_,
                                                                        activity_seq_,
                                                                        handling_unit_id_,
                                                                        1);
            END IF; 
         $END
      END LOOP;
   END IF;
   IF (remrec_.qty_assigned = count_serials_) THEN
      -- remove the '*' serial reservation if the entire reserved qty has been split
      Remove(order_no_,line_no_, rel_no_, line_item_no_, contract_, part_no_, location_no_,
             lot_batch_no_, '*', eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
             pick_list_no_, configuration_id_, shipment_id_);

   ELSE
      -- update the '*' serial reservation with the qty that is split
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_ASSIGNED', (remrec_.qty_assigned - count_serials_), attr_);   
      IF (remrec_.input_conv_factor IS NOT NULL) THEN 
         --recalculate input qty for remaining reservation
         input_qty_ := (remrec_.qty_assigned - count_serials_) / remrec_.input_conv_factor;
         Client_SYS.Add_To_Attr('INPUT_QTY', input_qty_, attr_);
         Client_SYS.Add_To_Attr('INPUT_VARIABLE_VALUES', Input_Unit_Meas_API.Get_Input_Value_String(input_qty_, remrec_.input_unit_meas), attr_);
      END IF;
      
      Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                          contract_, part_no_, location_no_, lot_batch_no_, '*',
                          eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                          pick_list_no_, configuration_id_,  shipment_id_, attr_);
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
END Split_Reservation_Into_Serials;


@UncheckedAccess
FUNCTION Get_Max_Ship_Qty_To_Reassign (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   shipment_id_         IN NUMBER,
   sol_revised_qty_due_ IN NUMBER ) RETURN NUMBER
IS
   max_qty_to_reassign_    NUMBER := 0;
   sol_revised_qty_due_in_ NUMBER := 0; 
   dummy_                  NUMBER;
   pick_listed_qty_        NUMBER := 0;

   CURSOR get_pick_listed_qty IS
     SELECT NVL(SUM(qty_assigned - qty_picked), 0)
     FROM   CUSTOMER_ORDER_RESERVATION_TAB 
     WHERE  shipment_id = shipment_id_
     AND    order_no = order_no_ 
     AND    line_no = line_no_ 
     AND    rel_no = rel_no_
     AND    line_item_no = line_item_no_
     AND    pick_list_no != '*'; 

   CURSOR check_pick_listed IS
     SELECT 1
     FROM   CUSTOMER_ORDER_RESERVATION_TAB 
     WHERE  order_no = order_no_ 
     AND    line_no = line_no_ 
     AND    rel_no = rel_no_
     AND    line_item_no > 0 
     AND    shipment_id = shipment_id_
     AND    (pick_list_no != '*' AND qty_assigned > qty_picked); 
BEGIN
   sol_revised_qty_due_in_ := sol_revised_qty_due_;
   IF line_item_no_ = 0 THEN
      OPEN  get_pick_listed_qty;
      FETCH get_pick_listed_qty INTO pick_listed_qty_;
      CLOSE get_pick_listed_qty;
      max_qty_to_reassign_ := sol_revised_qty_due_in_- pick_listed_qty_;
   ELSIF (line_item_no_ = -1) THEN
      -- qty to reassign is 0 for PKG if any component is pick listed and not pick reported
      OPEN check_pick_listed;
      FETCH check_pick_listed INTO dummy_;
      IF (check_pick_listed%FOUND) THEN
         max_qty_to_reassign_ := 0;
      ELSE
         -- check if package is delivered incompletely  
         IF (Shipment_Order_Utility_API.Check_Partially_Deliv_Comp(shipment_id_, order_no_, line_no_, rel_no_) = 'TRUE') THEN
            max_qty_to_reassign_ := 0;
         ELSE
            max_qty_to_reassign_ := sol_revised_qty_due_in_;
         END IF;
      END IF;
      CLOSE check_pick_listed;
   END IF;
   
   RETURN max_qty_to_reassign_;

END Get_Max_Ship_Qty_To_Reassign;


-- Get_Sum_Qty_Assign_And_Shipped
--   Returns total sum of qty_assigned and qty_shipped
--   for a given tracked part reservation lines.
@UncheckedAccess
FUNCTION Get_Sum_Qty_Assign_And_Shipped (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   lot_batch_no_ IN VARCHAR2,
   serial_no_    IN VARCHAR2) RETURN NUMBER
IS
   sum_qty_assigned_ NUMBER;
   sum_qty_shipped_  NUMBER;
   CURSOR get_sum_qty_avail IS
      SELECT SUM(qty_assigned), SUM(qty_shipped)
      FROM  customer_order_reservation_tab
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   lot_batch_no = lot_batch_no_
      AND   serial_no    = serial_no_;
BEGIN
   OPEN   get_sum_qty_avail;
   FETCH  get_sum_qty_avail INTO sum_qty_assigned_, sum_qty_shipped_;
   CLOSE  get_sum_qty_avail;
   RETURN NVL((sum_qty_assigned_+sum_qty_shipped_), 0);
END Get_Sum_Qty_Assign_And_Shipped;


@UncheckedAccess
FUNCTION Get_Number_Of_Reservations (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   shipment_id_  IN NUMBER ) RETURN NUMBER 
IS
   count_ NUMBER;

   CURSOR get_reservation IS
      SELECT count(*)
      FROM  CUSTOMER_ORDER_RESERVATION_TAB 
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   shipment_id  = shipment_id_
      AND   qty_assigned > 0;
BEGIN
   OPEN get_reservation;
   FETCH get_reservation INTO count_;
   CLOSE get_reservation;
   RETURN NVL(count_, 0);
END Get_Number_Of_Reservations;

FUNCTION Get_Number_Of_Lines_To_Pick (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   shipment_id_  IN NUMBER ) RETURN NUMBER 
IS
   count_ NUMBER;

   CURSOR get_lines_to_pick IS
      SELECT count(*)
      FROM  CUSTOMER_ORDER_RESERVATION_TAB 
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   shipment_id  = shipment_id_
      AND   qty_assigned > qty_picked;
BEGIN
   OPEN get_lines_to_pick;
   FETCH get_lines_to_pick INTO count_;
   CLOSE get_lines_to_pick;
   RETURN NVL(count_, 0);
END Get_Number_Of_Lines_To_Pick;


@UncheckedAccess
FUNCTION Unreported_Pick_Lists_Exist (
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,                                    
   shipment_id_    IN NUMBER ) RETURN VARCHAR2
IS
   dummy_                         NUMBER;
   unreported_pick_lists_exist_   VARCHAR2(5) := 'FALSE';

   CURSOR chk_unreported_pick_list_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  order_no     =  order_no_
      AND    line_no      =  line_no_
      AND    rel_no       =  rel_no_
      AND    line_item_no =  line_item_no_
      AND    shipment_id  =  shipment_id_
      AND    pick_list_no != '*'
      AND    (qty_assigned > qty_picked);
BEGIN
   OPEN  chk_unreported_pick_list_exist;
   FETCH chk_unreported_pick_list_exist INTO dummy_;
   IF (chk_unreported_pick_list_exist%FOUND) THEN
      unreported_pick_lists_exist_ := 'TRUE';
   END IF;
   CLOSE chk_unreported_pick_list_exist;
   RETURN unreported_pick_lists_exist_;
END Unreported_Pick_Lists_Exist;

@UncheckedAccess
FUNCTION Unreported_Pick_Lists_Exist (                                       
   shipment_id_    IN NUMBER ) RETURN VARCHAR2
IS
   dummy_                         NUMBER;
   unreported_pick_lists_exist_   VARCHAR2(5) := 'FALSE';

   CURSOR chk_unreported_pick_list_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_RESERVATION_TAB
      WHERE  shipment_id  =  shipment_id_
      AND    pick_list_no != '*'
      AND    (qty_assigned > qty_picked);
BEGIN
   OPEN  chk_unreported_pick_list_exist;
   FETCH chk_unreported_pick_list_exist INTO dummy_;
   IF (chk_unreported_pick_list_exist%FOUND) THEN
      unreported_pick_lists_exist_ := 'TRUE';
   END IF;
   CLOSE chk_unreported_pick_list_exist;
   RETURN unreported_pick_lists_exist_;
END Unreported_Pick_Lists_Exist;


@UncheckedAccess
FUNCTION Get_Number_Of_Lines_To_Pick (
   pick_list_no_ IN VARCHAR2 ) RETURN NUMBER 
IS
   count_ NUMBER;

   CURSOR get_lines_to_pick IS
      SELECT count(*)
      FROM  CUSTOMER_ORDER_RESERVATION_TAB 
      WHERE pick_list_no = pick_list_no_
      AND   qty_assigned > qty_picked;
BEGIN
   OPEN get_lines_to_pick;
   FETCH get_lines_to_pick INTO count_;
   CLOSE get_lines_to_pick;
   RETURN NVL(count_, 0);
END Get_Number_Of_Lines_To_Pick;


@UncheckedAccess
FUNCTION Get_Qty_Left_To_Pick (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   configuration_id_ IN VARCHAR2,
   pick_list_no_     IN VARCHAR2,
   shipment_id_      IN VARCHAR2 ) RETURN NUMBER 
IS
   tot_qty_assigned_ NUMBER;
   tot_qty_picked_   NUMBER;

   CURSOR get_quantities IS
      SELECT qty_assigned, qty_picked
      FROM  CUSTOMER_ORDER_RESERVATION_TAB 
      WHERE order_no         = order_no_
      AND   line_no          = line_no_
      AND   rel_no           = rel_no_
      AND   line_item_no     = line_item_no_
      AND   contract         = contract_
      AND   part_no          = part_no_
      AND   location_no      = location_no_
      AND   lot_batch_no     = lot_batch_no_
      AND   eng_chg_level    = eng_chg_level_
      AND   waiv_dev_rej_no  = waiv_dev_rej_no_
      AND   activity_seq     = activity_seq_
      AND   handling_unit_id = handling_unit_id_
      AND   configuration_id = configuration_id_
      AND   pick_list_no     = pick_list_no_
      AND   shipment_id      = shipment_id_;
BEGIN
   OPEN get_quantities;
   FETCH get_quantities INTO tot_qty_assigned_, tot_qty_picked_;
   CLOSE get_quantities;
   RETURN tot_qty_assigned_- tot_qty_picked_;
END Get_Qty_Left_To_Pick;


@UncheckedAccess
FUNCTION Get_Qty_Picked_HU (
   handling_unit_id_ IN NUMBER,
   pick_list_no_     IN VARCHAR2 ) RETURN NUMBER 
IS
   CURSOR get_qty_picked IS 
      SELECT SUM(qty_picked) qty_picked
      FROM CUSTOMER_ORDER_RESERVATION_TAB t
      WHERE pick_list_no = pick_list_no_
        AND handling_unit_id IN (SELECT hu.handling_unit_id
                                   FROM handling_unit_tab hu
                                CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                  START WITH     hu.handling_unit_id = handling_unit_id_)
      GROUP BY part_no;

   TYPE Qty_Picked_Tab IS TABLE OF get_qty_picked%ROWTYPE;
   qty_picked_tab_   Qty_Picked_Tab;
   qty_picked_       NUMBER;
BEGIN
   OPEN get_qty_picked;
   FETCH get_qty_picked BULK COLLECT INTO qty_picked_tab_;
   CLOSE get_qty_picked;
   
   IF (qty_picked_tab_.COUNT = 1) THEN
      qty_picked_ := qty_picked_tab_(1).qty_picked;
   END IF;
   
   RETURN qty_picked_;
END Get_Qty_Picked_HU;


-- Disconn_Reserve_From_Delnote
--   Modify delivery note no as NULL for connected reaservation lines and
--   add history records for customer order header and lines.
PROCEDURE Disconn_Reserve_From_Delnote (
   delnote_no_ IN VARCHAR2 )
IS
  order_no_         delivery_note_tab.order_no%TYPE;
  old_line_no_      VARCHAR2(4);
  old_rel_no_       VARCHAR2(4);
  old_line_item_no_ NUMBER;
  status_text_      VARCHAR2(255);
  alt_delnote_no_   VARCHAR2(50);
  
  shipment_id_      NUMBER;
  
  use_pre_ship_del_note_  VARCHAR2(20) := 'FALSE';
  
  CURSOR reservation_lines IS 
     SELECT order_no,        
            line_no,        
            rel_no,        
            line_item_no,   
            contract, 
            part_no,         
            location_no,    
            lot_batch_no,  
            serial_no,      
            eng_chg_level, 
            waiv_dev_rej_no, 
            activity_seq,   
            pick_list_no,   
            configuration_id, 
            shipment_id,
            handling_unit_id
       FROM customer_order_reservation_tab
      WHERE delnote_no = delnote_no_;

   CURSOR shipment_connected_order_no IS 
     SELECT DISTINCT order_no 
       FROM customer_order_reservation_tab
      WHERE shipment_id = shipment_id_;
BEGIN
   order_no_ := Delivery_Note_API.Get_Order_No(delnote_no_);
   use_pre_ship_del_note_ := Customer_Order_API.Get_Use_Pre_Ship_Del_Note_Db(order_no_);
   shipment_id_ := Delivery_Note_API.Get_Shipment_Id(delnote_no_);
   alt_delnote_no_ := Delivery_Note_API.Get_Alt_Delnote_No(delnote_no_);
   IF use_pre_ship_del_note_ = 'TRUE' THEN
      status_text_ := Language_SYS.Translate_Constant(lu_name_, 'PRESHIPDELNOTEINVAL: Pre-Ship Delivery Note :P1 has been invalidated', NULL, alt_delnote_no_);
   ELSE
      status_text_ := Language_SYS.Translate_Constant(lu_name_, 'DELNOTEINVALIDATE: Delivery Note :P1 has been invalidated', NULL, alt_delnote_no_);
   END IF;
   FOR reservation_lines_ IN reservation_lines LOOP
      Modify_Delnote_No(order_no_         => reservation_lines_.order_no,     
                        line_no_          => reservation_lines_.line_no,  
                        rel_no_           => reservation_lines_.rel_no,
                        line_item_no_     => reservation_lines_.line_item_no, 
                        contract_         => reservation_lines_.contract,
                        part_no_          => reservation_lines_.part_no,
                        location_no_      => reservation_lines_.location_no,  
                        lot_batch_no_     => reservation_lines_.lot_batch_no,
                        serial_no_        => reservation_lines_.serial_no,
                        eng_chg_level_    => reservation_lines_.eng_chg_level,
                        waiv_dev_rej_no_  => reservation_lines_.waiv_dev_rej_no,
                        activity_seq_     => reservation_lines_.activity_seq,
                        handling_unit_id_ => reservation_lines_.handling_unit_id,
                        pick_list_no_     => reservation_lines_.pick_list_no,
                        configuration_id_ => reservation_lines_.configuration_id,
                        shipment_id_      => reservation_lines_.shipment_id,
                        delnote_no_       => NULL);
                        
    IF (NVL(old_line_no_,' ') != reservation_lines_.line_no OR NVL(old_rel_no_, ' ') != reservation_lines_.rel_no OR old_line_item_no_ != reservation_lines_.line_item_no) THEN
         Customer_Order_Line_Hist_API.New(reservation_lines_.order_no, reservation_lines_.line_no, reservation_lines_.rel_no,
                                          reservation_lines_.line_item_no, status_text_);
      END IF;
   
      old_line_no_      := reservation_lines_.line_no;
      old_rel_no_       := reservation_lines_.rel_no;
      old_line_item_no_ := reservation_lines_.line_item_no;
   END LOOP;
   IF (order_no_ IS NOT NULL) AND (shipment_id_ IS NULL) THEN
      Customer_Order_History_API.New(order_no_, status_text_);
   END IF;
   IF (shipment_id_ IS NOT NULL) AND (order_no_ IS NULL) THEN
      FOR rec_ IN shipment_connected_order_no LOOP
         Customer_Order_History_API.New(rec_.order_no, status_text_);
      END LOOP;
   END IF;
END Disconn_Reserve_From_Delnote;

FUNCTION Get_Reserv_Info_On_Delivered(
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   rel_no_         IN VARCHAR2,
   line_item_no_   IN NUMBER,
   shipment_id_    IN NUMBER,
   delnote_no_     IN VARCHAR2 ) RETURN Shipment_Source_Utility_API.Reservation_Tab
IS
   reservation_tab_   Shipment_Source_Utility_API.Reservation_Tab;
   CURSOR get_reserv_info_on_delivered IS
      SELECT lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, expiration_date, qty_shipped, handling_unit_id, activity_seq
        FROM customer_order_reservation_tab
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_
         AND deliv_no IN (SELECT deliv_no
                            FROM customer_order_delivery_tab
                           WHERE delnote_no   = delnote_no_
                             AND order_no     = order_no_
                             AND line_no      = line_no_
                             AND rel_no       = rel_no_
                             AND line_item_no = line_item_no_
                             AND shipment_id  = shipment_id_
                             AND cancelled_delivery = 'FALSE');
BEGIN
   OPEN  get_reserv_info_on_delivered;
   FETCH get_reserv_info_on_delivered BULK COLLECT INTO reservation_tab_;
   CLOSE get_reserv_info_on_delivered;
   RETURN reservation_tab_;
END Get_Reserv_Info_On_Delivered;

PROCEDURE Update_Qty (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   pick_list_no_        IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   shipment_id_         IN NUMBER,
   qty_assigned_        IN NUMBER, 
   qty_picked_          IN NUMBER,
   catch_qty_           IN NUMBER,
   reassignment_type_   IN VARCHAR2 )
IS
   attr_ VARCHAR2(6000);
BEGIN
   IF ((qty_assigned_ > 0) OR  (qty_picked_> 0) OR (catch_qty_ > 0)) THEN
      Client_SYS.Clear_Attr(attr_);
      IF (qty_assigned_ > 0) THEN
         Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
      END IF;
      IF (qty_picked_ > 0) THEN
         Client_SYS.Add_To_Attr('QTY_PICKED',     qty_picked_, attr_);
         Client_SYS.Add_To_Attr('QTY_TO_DELIVER', qty_picked_, attr_);
      END IF;
      IF (catch_qty_ > 0) THEN
         Client_SYS.Add_To_Attr('CATCH_QTY',            catch_qty_, attr_);
         Client_SYS.Add_To_Attr('CATCH_QTY_TO_DELIVER', catch_qty_, attr_);
      END IF;
      IF (reassignment_type_ IS NOT NULL) THEN   
         Client_SYS.Add_To_Attr('REASSIGNMENT_TYPE', reassignment_type_, attr_);
      END IF;
      Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                          contract_,  part_no_, location_no_, lot_batch_no_,
                          serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                          pick_list_no_, configuration_id_, shipment_id_, attr_);
   END IF;
END Update_Qty;

PROCEDURE Lock_And_Fetch_Info (
   public_reservation_rec_ OUT Reserve_Shipment_API.Public_Reservation_Rec,        
   order_no_               IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   waiv_dev_rej_no_        IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   handling_unit_id_       IN  NUMBER,
   pick_list_no_           IN  VARCHAR2,
   configuration_id_       IN  VARCHAR2,
   shipment_id_            IN  NUMBER )
IS  
   from_shipment_res_rec_  CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
BEGIN
   from_shipment_res_rec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_,
                                             contract_,  part_no_, location_no_, lot_batch_no_, 
                                             serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, 
                                             configuration_id_, pick_list_no_, shipment_id_ );
                                             
  public_reservation_rec_.qty_assigned             := from_shipment_res_rec_.qty_assigned; 
  public_reservation_rec_.qty_picked               := from_shipment_res_rec_.qty_picked;     
  public_reservation_rec_.catch_qty                := from_shipment_res_rec_.catch_qty;  
  public_reservation_rec_.qty_shipped              := from_shipment_res_rec_.qty_shipped; 
  public_reservation_rec_.input_qty                := from_shipment_res_rec_.input_qty; 
  public_reservation_rec_.preliminary_pick_list_no := from_shipment_res_rec_.preliminary_pick_list_no;     
  public_reservation_rec_.input_conv_factor        := from_shipment_res_rec_.input_conv_factor;  
  public_reservation_rec_.input_unit_meas          := from_shipment_res_rec_.input_unit_meas;
  public_reservation_rec_.input_variable_values    := from_shipment_res_rec_.input_variable_values;  
  public_reservation_rec_.delnote_no               := from_shipment_res_rec_.delnote_no;
 
END Lock_And_Fetch_Info;

PROCEDURE Reduce_Reserve_Qty (
   order_no_               IN  VARCHAR2,
   line_no_                IN  VARCHAR2,
   rel_no_                 IN  VARCHAR2,
   line_item_no_           IN  NUMBER,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   waiv_dev_rej_no_        IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   handling_unit_id_       IN  NUMBER,
   configuration_id_       IN  VARCHAR2,
   qty_to_reassign_        IN  NUMBER,
   picked_qty_to_reassign_ IN  NUMBER )
IS
   order_line_rec_   Customer_Order_Line_API.Public_Rec;
   co_reserved_qty_  NUMBER := 0;
   co_picked_qty_    NUMBER := 0;
   dummy_number_     NUMBER;
BEGIN
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   IF (picked_qty_to_reassign_ > 0) THEN
      co_picked_qty_ := order_line_rec_.qty_picked - picked_qty_to_reassign_;  
      Customer_Order_API.Set_Line_Qty_Picked(order_no_, line_no_, rel_no_, line_item_no_, co_picked_qty_);
   END IF;
   co_reserved_qty_ := order_line_rec_.qty_assigned - qty_to_reassign_;
   Customer_Order_API.Set_Line_Qty_Assigned(order_no_, line_no_, rel_no_, line_item_no_, co_reserved_qty_);      
   Inventory_Part_In_Stock_API.Reserve_Part(dummy_number_, contract_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                                            serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, -(qty_to_reassign_));
END Reduce_Reserve_Qty;

-- Move_To_Shipment
--   Transfer a complete reservation record from one shipment to another.
PROCEDURE Move_To_Shipment (
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   configuration_id_    IN VARCHAR2,
   pick_list_no_        IN VARCHAR2,
   shipment_id_         IN NUMBER,
   to_shipment_id_      IN NUMBER,
   reassignment_type_   IN VARCHAR2 )
IS 
   objid_                         CUSTOMER_ORDER_RESERVATION.objid%TYPE;
   objversion_                    CUSTOMER_ORDER_RESERVATION.objversion%TYPE;
   cust_order_reservation_rec_    CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   reservation_booked_for_transp_ BOOLEAN; 
BEGIN
   cust_order_reservation_rec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_,
                                                  contract_,  part_no_, location_no_, lot_batch_no_, 
                                                  serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                                  configuration_id_, pick_list_no_, shipment_id_);
   New(cust_order_reservation_rec_.order_no,
       cust_order_reservation_rec_.line_no,
       cust_order_reservation_rec_.rel_no,
       cust_order_reservation_rec_.line_item_no,
       cust_order_reservation_rec_.contract,
       cust_order_reservation_rec_.part_no,
       cust_order_reservation_rec_.location_no,
       cust_order_reservation_rec_.lot_batch_no,
       cust_order_reservation_rec_.serial_no,
       cust_order_reservation_rec_.eng_chg_level,
       cust_order_reservation_rec_.waiv_dev_rej_no,
       cust_order_reservation_rec_.activity_seq,
       cust_order_reservation_rec_.handling_unit_id,
       cust_order_reservation_rec_.pick_list_no,
       cust_order_reservation_rec_.configuration_id,
       to_shipment_id_,
       cust_order_reservation_rec_.qty_assigned,
       cust_order_reservation_rec_.qty_picked,
       cust_order_reservation_rec_.qty_shipped,
       cust_order_reservation_rec_.input_qty,
       cust_order_reservation_rec_.input_unit_meas,
       cust_order_reservation_rec_.input_conv_factor,
       cust_order_reservation_rec_.input_variable_values,
       cust_order_reservation_rec_.preliminary_pick_list_no,
       cust_order_reservation_rec_.catch_qty,
       reassignment_type_,
       pick_by_choice_blocked_ => cust_order_reservation_rec_.pick_by_choice_blocked);
       
   Transport_Task_API.New_Trans_Task_For_Changed_Res(reservation_booked_for_transp_ => reservation_booked_for_transp_,
                                                     part_no_            => cust_order_reservation_rec_.part_no,
                                                     configuration_id_   => cust_order_reservation_rec_.configuration_id,
                                                     from_contract_      => cust_order_reservation_rec_.contract,
                                                     from_location_no_   => cust_order_reservation_rec_.location_no,   
                                                     order_type_db_      => Order_Type_API.DB_CUSTOMER_ORDER,
                                                     order_ref1_         => cust_order_reservation_rec_.order_no,
                                                     order_ref2_         => cust_order_reservation_rec_.line_no,
                                                     order_ref3_         => cust_order_reservation_rec_.rel_no,
                                                     order_ref4_         => cust_order_reservation_rec_.line_item_no,
                                                     from_pick_list_no_  => cust_order_reservation_rec_.pick_list_no,
                                                     to_pick_list_no_    => cust_order_reservation_rec_.pick_list_no,
                                                     from_shipment_id_   => cust_order_reservation_rec_.shipment_id,
                                                     to_shipment_id_     => to_shipment_id_,   
                                                     lot_batch_no_       => cust_order_reservation_rec_.lot_batch_no,
                                                     serial_no_          => cust_order_reservation_rec_.serial_no,
                                                     eng_chg_level_      => cust_order_reservation_rec_.eng_chg_level,
                                                     waiv_dev_rej_no_    => cust_order_reservation_rec_.waiv_dev_rej_no,
                                                     activity_seq_       => cust_order_reservation_rec_.activity_seq,
                                                     handling_unit_id_   => cust_order_reservation_rec_.handling_unit_id,
                                                     quantity_           => cust_order_reservation_rec_.qty_assigned);  
                                                                                           
   Get_Id_Version_By_Keys___(objid_, objversion_, cust_order_reservation_rec_.order_no, cust_order_reservation_rec_.line_no, cust_order_reservation_rec_.rel_no, cust_order_reservation_rec_.line_item_no,
                             cust_order_reservation_rec_.contract, cust_order_reservation_rec_.part_no, cust_order_reservation_rec_.location_no, cust_order_reservation_rec_.lot_batch_no, cust_order_reservation_rec_.serial_no,
                             cust_order_reservation_rec_.eng_chg_level, cust_order_reservation_rec_.waiv_dev_rej_no, cust_order_reservation_rec_.activity_seq, cust_order_reservation_rec_.handling_unit_id,
                             cust_order_reservation_rec_.configuration_id, cust_order_reservation_rec_.pick_list_no, cust_order_reservation_rec_.shipment_id);

   Check_Delete___(cust_order_reservation_rec_);
   Delete___(objid_, cust_order_reservation_rec_, reassignment_type_);
   
END Move_To_Shipment;


-- Change_Handling_Unit_Id
-- Change the handling unit id on a set quantity from one reservation to another.
PROCEDURE Change_Handling_Unit_Id (  
   availability_control_id_   OUT VARCHAR2,
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   rel_no_                    IN VARCHAR2,
   line_item_no_              IN NUMBER,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   handling_unit_id_          IN NUMBER,
   to_handling_unit_id_       IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   qty_assigned_              IN NUMBER,
   qty_picked_                IN NUMBER,
   catch_qty_                 IN NUMBER,
   qty_to_move_               IN NUMBER,
   catch_qty_to_move_         IN NUMBER,
   release_remaining_qty_     IN BOOLEAN DEFAULT FALSE,
   reservation_operation_id_  IN  NUMBER   DEFAULT NULL)
IS
   inv_part_in_stock_rec_     Inventory_Part_In_Stock_API.Public_Rec;
   existing_rec_              CUSTOMER_ORDER_RESERVATION_TAB%ROWTYPE;
   input_qty_                 NUMBER;
   input_unit_meas_           VARCHAR2(30);
   input_conv_factor_         NUMBER;
   input_variable_values_     VARCHAR2(2000);
   quantity_reserved_         NUMBER;
   quantity_to_unreserve_     NUMBER;
   hu_new_qty_assigned_       NUMBER;
   hu_new_qty_picked_         NUMBER;
   hu_new_catch_qty_          NUMBER;
   to_hu_new_qty_picked_      NUMBER := qty_to_move_;
   to_hu_new_qty_assigned_    NUMBER := qty_to_move_;
   to_hu_new_catch_qty_       NUMBER := catch_qty_to_move_;
   attr_                      VARCHAR2(2000);
BEGIN
   -- Calculate new qtys on to-handling unit
   IF(Customer_Order_Reservation_API.Exists(order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, 
                                            waiv_dev_rej_no_, activity_seq_, to_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_)) THEN
                                            
      existing_rec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_, contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_,
                                       waiv_dev_rej_no_, activity_seq_, to_handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_ );
      to_hu_new_qty_assigned_     := nvl(existing_rec_.qty_assigned, 0) + qty_to_move_;
      to_hu_new_qty_picked_       := nvl(existing_rec_.qty_picked, 0) + qty_to_move_;
      to_hu_new_catch_qty_        := nvl(existing_rec_.catch_qty, 0) + catch_qty_to_move_;
      
   END IF;
   
   inv_part_in_stock_rec_ := Inventory_Part_In_Stock_API.Lock_By_Keys(contract_,
                                                                      part_no_,
                                                                      configuration_id_,
                                                                      location_no_,
                                                                      lot_batch_no_,
                                                                      serial_no_,
                                                                      eng_chg_level_,
                                                                      waiv_dev_rej_no_,
                                                                      activity_seq_,
                                                                      handling_unit_id_);

   availability_control_id_ := inv_part_in_stock_rec_.Availability_Control_Id;

   quantity_to_unreserve_ := -qty_to_move_;
   IF release_remaining_qty_ THEN 
      quantity_to_unreserve_ := -qty_assigned_;
   END IF;

   -- Need to unreserve before changing Handling Unit ID.
   Reserve_Customer_Order_API.Make_CO_Reservation(reserved_qty_             => quantity_reserved_,
                                                  input_qty_                => input_qty_, 
                                                  input_unit_meas_          => input_unit_meas_, 
                                                  input_conv_factor_        => input_conv_factor_, 
                                                  input_variable_values_    => input_variable_values_, 
                                                  order_no_                 => order_no_, 
                                                  line_no_                  => line_no_,
                                                  rel_no_                   => rel_no_, 
                                                  line_item_no_             => line_item_no_, 
                                                  contract_                 => contract_, 
                                                  part_no_                  => part_no_, 
                                                  location_no_              => location_no_, 
                                                  lot_batch_no_             => lot_batch_no_, 
                                                  serial_no_                => serial_no_, 
                                                  eng_chg_level_            => eng_chg_level_, 
                                                  waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                                  activity_seq_             => activity_seq_,
                                                  handling_unit_id_         => handling_unit_id_,
                                                  configuration_id_         => configuration_id_,
                                                  pick_list_no_             => pick_list_no_,
                                                  shipment_id_              => shipment_id_,
                                                  qty_to_reserve_           => quantity_to_unreserve_,
                                                  reserve_manually_         => TRUE,
                                                  reservation_operation_id_ => reservation_operation_id_);
   -- Make_CO_Reservation uses manual reservation method to unreserve and normaly if it is not possible to unreserve whole qty the error should have been 
   -- raised in manual reservation method. We added this error message only for safty and to be able to stop process if for any reason the error was not
   -- handled in manual reservation. 
   IF quantity_reserved_ != quantity_to_unreserve_ THEN 
      Error_SYS.Record_General(lu_name_, 'CHANGEPARENT: Unable to unattach part(s) from handling unit :P1.', handling_unit_id_);
   END IF;
                                                  
   Inventory_Part_In_Stock_API.Change_Handling_Unit_Id(contract_                       => contract_,
                                                       part_no_                        => part_no_,
                                                       configuration_id_               => configuration_id_,  
                                                       location_no_                    => location_no_,
                                                       lot_batch_no_                   => lot_batch_no_,
                                                       serial_no_                      => serial_no_,
                                                       eng_chg_level_                  => eng_chg_level_,
                                                       waiv_dev_rej_no_                => waiv_dev_rej_no_,
                                                       activity_seq_                   => activity_seq_,
                                                       old_handling_unit_id_           => handling_unit_id_,
                                                       new_handling_unit_id_           => to_handling_unit_id_, 
                                                       quantity_                       => qty_to_move_, 
                                                       catch_quantity_                 => catch_qty_to_move_, 
                                                       source_ref1_                    => order_no_, 
                                                       source_ref2_                    => line_no_, 
                                                       source_ref3_                    => rel_no_, 
                                                       source_ref4_                    => line_item_no_, 
                                                       inv_trans_source_ref_type_db_   => Order_Type_API.DB_CUSTOMER_ORDER);

   Reserve_Customer_Order_API.Make_CO_Reservation(reserved_qty_             => quantity_reserved_,
                                                  input_qty_                => input_qty_, 
                                                  input_unit_meas_          => input_unit_meas_, 
                                                  input_conv_factor_        => input_conv_factor_, 
                                                  input_variable_values_    => input_variable_values_, 
                                                  order_no_                 => order_no_, 
                                                  line_no_                  => line_no_,
                                                  rel_no_                   => rel_no_, 
                                                  line_item_no_             => line_item_no_, 
                                                  contract_                 => contract_, 
                                                  part_no_                  => part_no_, 
                                                  location_no_              => location_no_, 
                                                  lot_batch_no_             => lot_batch_no_, 
                                                  serial_no_                => serial_no_, 
                                                  eng_chg_level_            => eng_chg_level_, 
                                                  waiv_dev_rej_no_          => waiv_dev_rej_no_, 
                                                  activity_seq_             => activity_seq_,
                                                  handling_unit_id_         => to_handling_unit_id_,
                                                  configuration_id_         => configuration_id_,
                                                  pick_list_no_             => pick_list_no_,
                                                  shipment_id_              => shipment_id_,
                                                  qty_to_reserve_           => qty_to_move_,
                                                  reserve_manually_         => TRUE,
                                                  reservation_operation_id_ => reservation_operation_id_);

   -- We should update quantity picked for the reservation that Their parent has been changed
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', to_hu_new_qty_assigned_, attr_);
   Client_SYS.Add_To_Attr('QTY_PICKED', to_hu_new_qty_picked_, attr_);
   IF catch_qty_to_move_ IS NOT NULL THEN 
      Client_SYS.Add_To_Attr('CATCH_QTY', to_hu_new_catch_qty_, attr_);
   END IF;
      
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                       eng_chg_level_, waiv_dev_rej_no_, activity_seq_, to_handling_unit_id_,
                       pick_list_no_, configuration_id_, shipment_id_,  attr_);

   -- Update remaining reservation on original handling unit
   IF (NOT release_remaining_qty_) THEN
      hu_new_qty_assigned_ := qty_assigned_ - qty_to_move_;
      hu_new_qty_picked_   := qty_picked_ - qty_to_move_;
      hu_new_catch_qty_    := GREATEST(0, (catch_qty_ - catch_qty_to_move_));

      -- If the old reservations quantities are not zero and the flag was set to false, we need to update the remaining reservation on 
      -- the original handling unit.
      IF(hu_new_qty_assigned_ != 0 OR hu_new_qty_picked_ != 0) THEN

         IF hu_new_catch_qty_ = 0 AND NOT release_remaining_qty_ THEN 
            Error_SYS.Record_General(lu_name_, 'CATCHZERO: Remaining catch quantity picked on handling unit :P1 cannot be zero.', handling_unit_id_);
         END IF;
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('QTY_ASSIGNED', hu_new_qty_assigned_, attr_);
         Client_SYS.Add_To_Attr('QTY_PICKED', hu_new_qty_picked_, attr_);
         IF catch_qty_to_move_ IS NOT NULL THEN 
            Client_SYS.Add_To_Attr('CATCH_QTY', hu_new_catch_qty_, attr_);
         END IF;

         Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                             contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                             eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                             pick_list_no_, configuration_id_, shipment_id_,  attr_);
      END IF;                                                  
   END IF;                                       
END Change_Handling_Unit_Id;


FUNCTION Get_Object_By_Id (
   objid_ IN VARCHAR2 ) RETURN Customer_Order_Reservation_API.Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (objid_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT order_no, line_no, rel_no, line_item_no, contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level, 
          waiv_dev_rej_no, activity_seq, handling_unit_id, configuration_id, pick_list_no, shipment_id,
          rowid, rowversion, rowkey,
          qty_assigned, qty_picked, qty_shipped, input_qty, input_unit_meas, input_conv_factor, input_variable_values, 
          catch_qty, delnote_no, preliminary_pick_list_no, catch_qty_to_deliver, catch_qty_shipped, pick_by_choice_blocked, on_transport_task
      INTO  temp_
      FROM  customer_order_reservation_tab
      WHERE rowid = objid_;
      RETURN temp_;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
END Get_Object_By_Id;
   

FUNCTION Get_Pick_By_Choice_Blocked_Db (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   configuration_id_ IN VARCHAR2,
   shipment_id_      IN NUMBER ) RETURN customer_order_reservation_tab.pick_by_choice_blocked%TYPE
IS
   pick_by_choice_blocked_ customer_order_reservation_tab.pick_by_choice_blocked%TYPE;

   CURSOR get_pick_by_choice_blocked IS 
      SELECT pick_by_choice_blocked
      FROM customer_order_reservation_tab
      WHERE order_no                  = order_no_
      AND   line_no                   = line_no_
      AND   rel_no                    = rel_no_
      AND   line_item_no              = line_item_no_
      AND   contract                  = contract_
      AND   part_no                   = part_no_
      AND   location_no               = location_no_
      AND   lot_batch_no              = lot_batch_no_
      AND   serial_no                 = serial_no_
      AND   eng_chg_level             = eng_chg_level_
      AND   waiv_dev_rej_no           = waiv_dev_rej_no_
      AND   activity_seq              = activity_seq_
      AND   handling_unit_id          = handling_unit_id_
      AND   configuration_id          = configuration_id_
      AND   shipment_id               = shipment_id_
      AND   qty_assigned - qty_picked > 0;
BEGIN
   OPEN get_pick_by_choice_blocked;
   FETCH get_pick_by_choice_blocked INTO pick_by_choice_blocked_;
   CLOSE get_pick_by_choice_blocked;
   RETURN NVL(pick_by_choice_blocked_, Fnd_Boolean_API.DB_FALSE);
END Get_Pick_By_Choice_Blocked_Db;


@UncheckedAccess
FUNCTION Get_Total_Qty_Reserved (  
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   shipment_id_        IN VARCHAR2 ) RETURN NUMBER
IS
   total_qty_reserved_ NUMBER := 0;
   
   CURSOR get_total_qty_reserved IS
      SELECT SUM(qty_assigned)
      FROM   customer_order_reservation_tab 
      WHERE  order_no         = order_no_
      AND    line_no          = line_no_
      AND    rel_no           = rel_no_
      AND    line_item_no     = line_item_no_
      AND    contract         = contract_
      AND    part_no          = part_no_
      AND    configuration_id = configuration_id_
      AND    location_no      = location_no_
      AND    lot_batch_no     = lot_batch_no_
      AND    serial_no        = serial_no_
      AND    eng_chg_level    = eng_chg_level_
      AND    waiv_dev_rej_no  = waiv_dev_rej_no_
      AND    activity_seq     = activity_seq_
      AND    handling_unit_id = handling_unit_id_
      AND    shipment_id      = shipment_id_;
   
BEGIN
   OPEN get_total_qty_reserved;
   FETCH get_total_qty_reserved INTO total_qty_reserved_;
   CLOSE get_total_qty_reserved;
   RETURN total_qty_reserved_;
END Get_Total_Qty_Reserved;


@UncheckedAccess
FUNCTION Get_Total_Qty_On_Pick_List (  
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   rel_no_             IN VARCHAR2,
   line_item_no_       IN NUMBER,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   shipment_id_        IN VARCHAR2 ) RETURN NUMBER
IS
   total_qty_on_pick_list_ NUMBER := 0;
   
   CURSOR get_total_qty_on_pick_list IS
      SELECT NVL(SUM(qty_assigned),0)
      FROM   customer_order_reservation_tab 
      WHERE  order_no         = order_no_
      AND    line_no          = line_no_
      AND    rel_no           = rel_no_
      AND    line_item_no     = line_item_no_
      AND    contract         = contract_
      AND    part_no          = part_no_
      AND    configuration_id = configuration_id_
      AND    location_no      = location_no_
      AND    lot_batch_no     = lot_batch_no_
      AND    serial_no        = serial_no_
      AND    eng_chg_level    = eng_chg_level_
      AND    waiv_dev_rej_no  = waiv_dev_rej_no_
      AND    activity_seq     = activity_seq_
      AND    handling_unit_id = handling_unit_id_
      AND    shipment_id      = shipment_id_
      AND    pick_list_no     != '*'
      AND    qty_assigned     > 0;
BEGIN
   OPEN get_total_qty_on_pick_list;
   FETCH get_total_qty_on_pick_list INTO total_qty_on_pick_list_;
   CLOSE get_total_qty_on_pick_list;
   RETURN total_qty_on_pick_list_;
END Get_Total_Qty_On_Pick_List;

@UncheckedAccess
FUNCTION Get_Homogeneous_Location_Group(
   pick_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   location_group_ inventory_location_pub.location_group%type;
   
   CURSOR get_location_groups IS
      SELECT distinct il.location_group location_group
      FROM customer_order_reservation_tab cor,
           inventory_location_pub il
      WHERE cor.contract     = il.contract
        AND cor.location_no  = il.location_no
        AND cor.pick_list_no = pick_list_no_
      FETCH FIRST 2 ROWS ONLY;
      
   TYPE Location_Group_Tab_Type IS TABLE OF get_location_groups%rowtype
     INDEX BY pls_integer;
   location_group_tab_ Location_Group_Tab_Type;  
BEGIN
   OPEN  get_location_groups;
   FETCH get_location_groups BULK COLLECT INTO location_group_tab_;
   IF (location_group_tab_.COUNT = 1) THEN
      location_group_ := location_group_tab_(location_group_tab_.first).location_group;
   END IF;
   CLOSE get_location_groups;
   RETURN location_group_;
END Get_Homogeneous_Location_Group;

FUNCTION Get_Qty_Shipped (
   deliv_no_ IN NUMBER ) RETURN NUMBER
IS
   qty_shipped_   NUMBER;
   CURSOR get_shipped_qty IS
      SELECT SUM(qty_shipped)
      FROM   customer_order_reservation_tab 
      WHERE  deliv_no = deliv_no_;
BEGIN
   OPEN get_shipped_qty;
   FETCH get_shipped_qty INTO qty_shipped_;
   CLOSE get_shipped_qty;
   RETURN qty_shipped_;
END Get_Qty_Shipped;

@UncheckedAccess
FUNCTION Is_Pick_List_Connected (
   pick_list_no_ IN VARCHAR2) RETURN NUMBER
IS
   connected_  NUMBER := 1;
   CURSOR pick_list_connected IS
   SELECT 1 
   FROM Customer_Order_Reservation_TAB
   WHERE pick_list_no = pick_list_no_;
BEGIN
   OPEN pick_list_connected;
   FETCH pick_list_connected INTO connected_;
   IF (pick_list_connected%NOTFOUND) THEN
      connected_ := 0;
   END IF;
   CLOSE pick_list_connected;
   RETURN connected_;
END Is_Pick_List_Connected;

@UncheckedAccess
FUNCTION Get_Pick_By_Choice_Blocked_Db (
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2  
IS
   handling_unit_id_tab_   Handling_Unit_API.Handling_Unit_Id_Tab;
   CURSOR get_pick_by_choice_blocked(hu_id_ NUMBER) IS
      SELECT pick_by_choice_blocked_db
      FROM Customer_Order_Res
      WHERE handling_unit_id = hu_id_
      AND   qty_reserved - qty_picked > 0;

   result_                     VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   handling_unit_id_tab_ := Handling_Unit_API.Get_Node_And_Descendants(handling_unit_id_); 
   IF handling_unit_id_tab_.Count > 0 THEN
      FOR i IN handling_unit_id_tab_.FIRST..handling_unit_id_tab_.LAST LOOP
         OPEN get_pick_by_choice_blocked(handling_unit_id_tab_(i).handling_unit_id);
         FETCH get_pick_by_choice_blocked  INTO result_;
         CLOSE get_pick_by_choice_blocked;
         IF result_ = Fnd_Boolean_API.DB_TRUE  THEN
            EXIT;
         END IF;      
      END LOOP;
   END IF;
   RETURN(result_);

END Get_Pick_By_Choice_Blocked_Db;

   
