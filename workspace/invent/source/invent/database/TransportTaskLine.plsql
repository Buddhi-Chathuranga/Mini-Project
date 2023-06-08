-----------------------------------------------------------------------------
--
--  Logical unit: TransportTaskLine
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210705  Moinlk  Bug 159673 (SCZ-14915), Modified Create_Data_Capture_Lov(), Get_Column_Value_If_Unique() and Record_With_Column_Value_Exist(), added order_type_db_,
--  210705          to filter transport tasks from Order type and also to support LOV functionality.
--  210323  DaZase  Bug 158553 (SCZ-14065), Added Modify_Destination.
--  210304  SBalLK  Bug 158113 (SCZ-13878), Modified New_Or_Add_To_Existing_() method to discard garbage values assigned to newrec_ from previous iteration, before initiate next iteration.
--  210225  JaThlk  Bug 157807 (SCZ-13495), Modified Handle_Line_Executed___(), to add Work Task in the condition before resetting source references.
--  210218  GrGalk  SC2020R1-12441, Changed the part_no_ parameter type from NUMBER to VARCHAR2 in  Raise_Location_Frozen_Error___() method.
--  210210  Asawlk  SC2020R1-12298, Modified methods Check_Insert___() and Check_Update___() by using public get() methods in order to reduce the no of databse reads.
--  210208  JaThlk  Bug 157807 (SCZ-13495), Modified Handle_Line_Executed___(), to reset the fields order_ref1_, order_ref2_, order_ref3_, order_ref4_ and order_type_ if order type is work order.
--  210122  LEPESE  SC2020R1-11991, Get rid of string manipulations by replacing Client_SYS.Add_To_Attr. Created method Check_And_Insert___.
--  201125  RoJalk  SC2020R1-11300, Modified Get_Destination_Info to consider possible null values for order_ref2_, order_ref3_ in get_transport_task_info cursor. 
--  201005  Asawlk  SC2021R1-318, order type / order supply demand type, WORK_ORDER references are replaced with corresponding type WORK_TASK.
--  200601  DiJwlk  Bug 153897 (SCZ-9963), Added Raise_Location_Remove_Error___(), Check_Remove_From_Location__(), Check_Remove_To_Location__() and 
--  200601          Check_Remove_Forword_To_Loc__() to check pending transport task lines when deleting an Inventory Location
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  200319  ErRalk  SCSPRING20-1287, Modified Handle_Line_Executed___ to support Move With Transport Task command for Shipment Order.
--  200311  RoJalk  SCSPRING20-1930, Modified  Check_Insert_, Handle_Line_Executed___ to support Shipment Order.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200210  BudKlk  Bug 152314 (SCZ-8757), Modified Other_Owners_Are_Inbound() to improve the perofmance by reducing the method call Inventory_Part_In_Stock_API.Get() and added all the conditions to the cursor.
--  200102  UdGnlk  Bug 150959 (SCZ-7515), Modified Handle_Line_Executed___() and Check_Insert_() to add Order_Type_API.DB_PROJ_MISC_DEMAND to the condition.
--  191224  UdGnlk  Bug 150959 (SCZ-7515), Modified Get_Transport_Task_Id() to corrected numeric value error.
--  191210  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191210          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191210          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance. 
--  191023  SBalLK  Bug 150436 (SCZ-6914), Modified Handle_Line_Executed___() method by adding Customer Order type to the move reservation object types condition
--  191023          to execute generic move reservation logic.
--  191002  SURBLK  Added Raise_Location_Type_Error___ and Raise_Location_Frozen_Error___ to handle error messages and avoid code duplication.
--  190827  AsZelk  Bug 149643 (SCZ-6081), Modified Get_Transport_Task_Id() to fetch Transport_Id for Distribution Order record in Inventory Part In Stock Reservations.
--  190611  ChFolk  SCUXXW4-20645, Added outermost_sscc and outermost_alt_hu_label_id to trans_task_line_details_rec and modified Get_Trans_Task_Line_Details accordingly.
--  190405  ChFolk  SCUXXW4-16439, Added record type trans_task_line_details_rec and method Get_Trans_Task_Line_Details which is used by Aurena client.
--  190129  ChBnlk  Bug 146164 (SCZ-2948), Added a new default parameter 'called_from_client_' to the method Modify_Quantity() and set the 'CLIENT_ACTION' in the attr_ according to it.
--  180302  LEPESE  STRSC-17418, Added condition for reserved_by_source = TRUE in Handle_Line_Executed___ to make sure that TT lines which
--  180302          have a Shop Order reference because of a putaway in SO Receipt is not handled as moving of reserved stock. 
--  180227  ChFolk  STRSC-16576, Added new method Raise_Res_Is_On_Trans_Task to generalise the error message which is to be used from outside.
--  180221  JaThlk  Bug 140182, Added parameter include_unpicked_lines_ to method Get_Qty_Outbound_(). Modified the method Get_Qty_Outbound_(), to consider the transport tasks which are in 'Created' status, only if it performs storage optimization.
--  180220  LEPESE  STRSC-16279, Added call to Inventory_Part_In_Stock_API.Get_Destinat_Expiration_Date in Handle_Line_Executed___.
--  180123  LEPESE  STRSC-16026, Added parameter check_duplicate_reservations_ to method Check_Update___. Set it to TRUE when calling from New_Or_Add_To_Existing_.
--  180112  BudKlk  Bug 139555, Modified the method Get_Qty_Inbound_(), Get_Qty_Outbound_(), Get_Task_Id_List(), Other_Owners_Are_Inbound(), Get_First_Location_No(), Get_Column_Value_If_Unique(),
--  180112          Get_Number_Of_Lines(),Other_Conditions_Are_Inbound(), Other_Lots_Are_Inbound(), Get_Sum_Quantities(), Deviating_Destination_Exist(),Get_Transport_Task_Id(), 
--  180112          Get_Unique_Destination_Site(),Add_Tasks_To_Hu_Refresh_List(),Get_Destination_Info() to change the cursors to improve the performance.
--  180109  ChFolk  STRSC-15654, Modified Get_No_Of_Unidentified_Serials to include undefined serial no = * to the condition.
--  180103  ChFolk  STRSC-14535, Renamed method Get_Pending_Task_Id_For_Reserv as Get_Transport_Task_Id.
--  180102  ChFolk  STRSC-14444, Renamed method Modify_On_Task_In_Ord_Res___ as Modify_Cust_Ord_Reservation___.
--  171208  LEPESE  STRSC-12389, Removed condition on Fixed header attribute from methods Find_And_Remove and Can_Be_Used_For_Reservation_Db.
--  171130  ChFolk  STRSC-14535, Added new method Get_Pending_Task_Id_For_Reserv to be used by the client to get the transport task id connected to the reservation.
--  171129  ChFolk  STRSC-14444, Added new method Modify_On_Task_In_Ord_Res___ to place the code to modify on_transport_task attribute in
--  171129          customer_order_reservation. It is called from Insert___ and Delete___.
--  171124  LEPESE  STRSC-14755, Added check against warehouse_task_tab in method Find_And_Remove. Added Can_Be_Used_For_Reservation_Db.
--  171122  Chfolk  STRSC-14444, Modified Insert___ and Delete___ to update on_transport_task in customer_order_reservation_tab.
--  171124  LEPESE  STRSC-14755, Added check against warehouse_task_tab in method Find_And_Remove.
--  171120  DaZase  STRSC-8865, Added inv_barcode_validation_ parameter and handling of it in Record_With_Column_Value_Exist.
--  171017  ChFolk  STRSC-12120, Moved method Un_Executed_Trans_Task_Exist to Handling_Unit_API as it is related to handling unit structure.
--  171012  ChFolk  STRSC-12120, Added new method Un_Executed_Trans_Task_Exist which checks whether any un executed transport task exists for the given stock parameters. 
--  171012  LEPESE  STRSC-12433, Added methods Get_Sum_Removed_Tt_Line_Qty___ and Handle_Stock_Reservat_Result.
--  171012  MWERSE  STRSC-12392, Added check for Order type KANBAN_CARD in Check_Insert_.
--  171003  LEPESE  STRSC-12389, Added method Destination_Is_Remote_Whse___.
--  170928  ChFolk  STRSC-11815, Modified Handle_Line_Executed___ to remove parameter inventory_event_id_ from method call Receive_Order_API.Execute_Transport_Task_Line.
--  170927  LEPESE  STRSC-12390, Added method Recreate_Unconsumed_Lines.
--  170929  Chfose  STRSC-8922, Added new default parameter forward_to_transport_task_id_ in Check_And_Update___, Update___, Handle_Line_Executed___, Execute_ &
--  170929          Execute to be able to set a specific transport task id when having a forward_to_location (used to preseve HU when having common forward_to_location).
--  170926  LEPESE  STRSC-12389, Added method Find_And_Remove and also public declaration Public_Rec_Tab.
--  170828  DAYJLK  STRSC-11598, Modified Delete___ and Check_Update_Move_Reserved___ to support Material Requisitions.
--  170822  DAYJLK  STRSC-11598, Modified Check_Insert_ to allow insert new line for Material Requisitions and Handle_Line_Executed___ to support Material Requisitions.
--  170803  ChFolk  STRSC-11136, Modified insert___, Delete___ and Check_Update_Move_Reserved___ to support project deliverables.
--  170802  Chfolk  STRSC-11135, Modified Handle_Line_Executed___ to support project deliverables.
--  170802  ChFolk  STRSC-11135, Modified Check_Insert_ to allow insert new line for project deliverables.
--  170728  JoAnSe  STRSC-9222, Implemented changes needed for moving DOP reservations with transport task. 
--  170712  ChFolk  STRSC-10849, Added new method Get_Destination_Info which is used when connecting the new shipment infomation to the transport task.
--  170614  Chfose  STRSC-8192, Removed methods Lines_With_No_Fwd_To_Loc_Exist & Lines_With_Fwd_To_Loc_Exist and modified Insert___, Update___ & Delete___ to no
--  170614          longer need a handling unit to generate a snapshot.
--  170608  JoAnSe  LIM-11514, Changes in Handle_Line_Executed___ to handle execution of transport task for material reserved to a shop order.
--  170608  JoAnSe  LIM-10663, Changes in Insert___to allow transport task for material reserved to a shop order.
--  170605  KHVESE  LIM-10758, Modified method Update___ to verify storage req if forward to location or qty on forward to location is changed. 
--  170531  KHVESE  LIM-10758, Modified method's interface of Check_And_Update___, New_Or_Add_To_Existing_ and Modify_Stock_Rec_Destination with new parameter 
--  170531          check_storage_requirements_ and method's body respectively. Also modified method Update___ to verify storage req if contract or location is changed. 
--  170531          Modified method Check_Insert___ to retrieve check_storage_requirements_ from attr string with new parameter check_storage_requirements_. 
--  170517  MaAuse  STRSC-8366, Added method Lines_FwdToLoc_Created_Exist.
--  170509  UdGnlk  LIM-11443, Removed method Order_Line_Reservation_Exist() instead can use Reservation_Booked_For_Transp();
--  170508  DaZase  STRSC-7996, Added transport_task_status_db as first sorting criteria so created lines are handled before picked ones in Create_Data_Capture_Lov.
--  170428  JeLise  LIM-11448, Modified get_qty_outbound_2 in Get_Qty_Outbound_, so that both cursors checks that 
--  170428          transport_task_status != Transport_Task_Status_API.db_executed.
--  170425  ChJalk  Bug 134671, Modified the method Execute to create a record in Report Archive if all the lines have been executed. 
--  170330  LEPESE  LIM-9464, Added method Get_Unique_Destination_Site.
--  170328  DaZase  LIM-9901, Added Handl_Unit_Exist_On_Trans_Task().
--  170314  MaEelk  LIM-11106, Added Replace_Reduced_Hu_Reservat___. When moving the entire handling unit having reservations using a transport Task, 
--  170314          if someone unreserves parts from this handling unit, a transport task line will be created for the unreserved in the same stock location.
--  170314          Called Replace_Reduced_Hu_Reservat___ when the Transport task Line Quantity is reduced or removed through the method Reduce_Quantity.
--  170308  UdGnlk  LIM-10871, Validate move by reservations using reserved_by_source_ column accordingly and to pass the value to
--  170308          reserved_by_source_db_ in Get_Qty_Outbound_().
--  170308  DaZase  LIM-9901, Added default param use_dotdotdot_as_mixed_ on overloaded Get_Column_Value_If_Unique() and made some performance 
--  170308          changes there also. Also added filtering of not executed lines on both cursors in this method.
--  170308  DaZase  LIM-9901, Added no_unique_value_found_ to Get_Column_Value_If_Unique and added similar handling of that parameter that we 
--  170308          have in InventoryPartInStock, added Get_Sum_Column_Value, needed for new feedback summarize methods created in HandlingUnit. 
--  170306  UdGnlk  LIM-10871, Modified Check_Insert_(), Delete___(), Check_Update_Move_Reserved___() and
--  170306          Check_Update_Move_Reserved___() to condition the validations with reserved_by_source_ for move of a reservation.
--  170301  UdGnlk  LIM-10870, Modified Get_Existing_Line_No___(), Check_Insert_(), New_Or_Add_To_Existing_() 
--  170301          to add reserved_by_source_ parameter and insert the value. 
--  170301  Erlise  LIM-7315, Added methods Lines_With_Fwd_To_Loc_Exist and Lines_With_No_Fwd_To_Loc_Exist.
--  170301  MaEelk  LIM-10889, Removed the method Remove added from LIM-10488 since its usage is not needed anymore.
--  170224  UdGnlk  LIM-10873, Modified Check_Insert_() to do review comments.  
--  170214  UdGnlk  LIM-10370, Modified Delete___(), Check_Insert_() and Check_Update_Move_Reserved___()
--  170214          to improve on move reservation with Transport Task for CUSTOMER ORDER.   
--  170208  MaEelk  LIM-10489, Modified Handle_Line_Executed___ to handle execution of Transport Lines connected to CO Reservations. 
--  170202  UdGnlk  LIM-10370, Modified Insert___() allowing the path to open CUSTOMER ORDER to move reservation. 
--  170202          Modified Update___ and Delete___ to allow CUSTOMER ORDER to move reservation. 
--  170130  Erlise  LIM-7315, Changed overloaded method Get_Column_Value_If_Unique.
--  170131  MaEelk  LIM-10488, Passed inventory_event_id_ to the method Remove having order references and part in stock info as parameters.
--  170126  MaEelk  LIM-10488, Added override method Remove having order references and part in stock info as parameters.
--  170119  LEPESE  LIM-8584, Added parameter validate_hu_struct_position_ in call to Receive_Order_API.Execute_Transport_Task_Line. 
--  170117  UdGnlk  LIM-10371, Modified Check_Insert_() validations by adding CUSTOMER ORDER order type. 
--  170111  MaEelk  LIM-10139, Added necessary changes relevant to newly added  pick_list_no and shipment_id columns in Transport_Task_Line_Tab.
--  170106  NiDalk  LIM-7014, Modified Pick to add an error message when a catch quantity not set for a catch enabled part.
--  160603  NaLrlk  STRSC-2580, Modified Handle_Line_Executed___() to pass the unattached_from_handling_unit_ parameter when execute transport task from receipt.
--  160523  LEPESE  LIM-7363, Replaced putaway_event_id_ with inventory_event_id_, remove_putaway_event_ with finish_inventory_event_, 
--  160523          Inventory_Putaway_Manager_API.Get_Next_Putaway_Event_Id with Inventory_Event_Manager_API.Get_Next_Inventory_Event_id and
--  160523          Putaway_To_Empty_Event_API.Remove_Putaway_Event with Inventory_Event_Manager_API.Finish.
--  160518  LEPESE  LIM-7363, Added method Add_Tasks_To_Hu_Refresh_List.
--  160512  LEPESE  LIM-7363, added parameter putaway_event_id_ to methods Check_And_Delete___, Apply_Drop_Off_Location___, Revoke_Two_Step_Trans_Task___, Move___, 
--  160512          Unpick_, Move, Unpick, Apply_Drop_Off_Location, Revoke_Two_Step_Transport_Task, Remove and Modify_Stock_Rec_Destination.
--  160512          Passing putaway_event_id_ when calling Transport_Task_API.New_Or_Add_To_Existing() from Handle_Line_Executed___.
--  160511  LEPESE  LIM-7363, added code in Insert___, Update___ and Delete___ to call either Transp_Task_For_Hu_Refresh_API.New or 
--  160511          Transport_Task_Handl_Unit_API.Generate_Aggr_Handl_Unit_View depending on if the DML operation is done in context of a 
--  160511          putaway_event_id_. Added putaway_event_id_ as parameter to many methods, in order to pass them on to Insert___, Update___, Delete___.
--  160428  LEPESE  LIM-4581, changes in Handle_Line_Executed___ to create new TT Line for forward_to_location with Handling Unit ID zero if first move unpacked the items.
--  160426  LEPESE  LIM-4581, changes in Handle_Line_Executed___ to call new overloaded version of Inventory_Part_In_Stock_API.Move_Part.
--  160411  DaZase  LIM-5066, Added overloaded Get_Transport_Task_Id.
--  160408  NaLrlk  LIM-6846, Modified Handle_Line_Executed___() to aloow execute transport task for generic receipt.
--  160329  Erlise  LIM-6039, Added parameter validate_hu_struct_position_ to methods Execute, Execute_, Check_And_Update___, Update___ and Handle_Line_Executed___.
--  160329          Changed call to Inventory_Part_In_Stock_API.Move_Part.
--  160223  DaZase  LIM-3655, Added new methods Get_Latest_Hu_Create_Date, Get_Column_Value_If_Unique(overloaded), Modify_Stock_Rec_Destination, 
--  160223          Remove, Get_Sum_Quantities and Deviating_Destination_Exist.
--  151203  NipKlk  Bug 126075, Increased the length of the local variable source_ to 200 in the method Handle_Line_Executed___().
--  151123  Chfose  LIM-5033, Removed pallet_list-parameter in call to Inventory_Part_In_Stock_API.Move_Part.
--  151103  DaZase  LIM-4287, Used new view Transport_Task_Line_Not_Exec instead of table in Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist.
--  151103  MaEelk  LIM-4367, Removed pallet specific code from the logic and moved TransportTaskLineNopall methods in to this LU.
--  151029  JeLise  LIM-3941, Removed calls to Inventory_Location_API.Location_Type_Db_Is_Pallet in Check_Insert_.
--  151020  JeLise  LIM-3893, Removed pallet related location types in Check_Insert_.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately and increased the size of the stmt_ variable to 4000.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150414  Chfose  LIM-98, Added new column handling_unit_id to logic and methods.
--  150220  LEPESE  PRSC-4564, added putaway_event_id_ as parameter to method Check_Insert_. Passed it on to Inventory_Putaway_Manager_API.Check_Storage_Requirements.
--  150128  LEPESE  PRSC-5587, added parameter remove_empty_task_db_ when calling method Remove__ in the line objects from Remove__.
--  141123  MeAblk  PRSC-3972, Modified  Check_Insert_ in order to create the transport task lines when a production schedule is used.
--  141103  ChJalk  PRSC-2216, Added missing assert safe anotation for exist_control_ ,get_column_values_ and get_lov_values_.
--  141022  JeLise  Added method Get_Number_Of_Lines to be used in Warehouse Task.
--  141010  JeLise  Added method Get_First_Location_No to be used in Warehouse Task.
--  141008  LEPESE  PRSC-3231, added NULL for paramters putaway_event_id_ when calling Transport_Task_Line_Nopall_API.Execute_ and
--  141008          Transport_Task_Line_Pallet_API.Execute_ from method Execute.
--  140916  DaZase  PRSC-2781, Changes in methods Record_With_Column_Value_Exist, Create_Data_Capture_Lov and Get_Column_Value_If_Unique to 
--  140916          reflect that destination and transport_task_status now are handled like enumerations and will have db-value saved on session line table
--  140814  DaZase  PRSC-1611, Added extra column checks in methods Get_Column_Value_If_Unique, Create_Data_Capture_Lov Record_With_Column_Value_Exist to avoid any risk of getting sql injection problems.
--  140811  DaZase  PRSC-1611, Renamed Check_Valid_Value to Record_With_Column_Value_Exist.
--  140619  DaZase  PRSC-1207, Changed Create_Data_Capture_Lov so it now only uses ORDER BY ASC.
--  140521  Erlise  PBSC-9213, Renamed Line_Exist_Ref_Based to Order_Line_Reservation_Exist and added inventory part in stock record keys as parameters.
--  140520  LEPESE  PBSC-9078, correction in Check_Insert_ to allow lines with Shop Order reference.
--  140514  MatKse  PBSC-8344, Added method Modify_Catch_Quantity, modified method Modify_Quantity to not allow pallet lines to be changed..
--  140313  MatKse  Modified Line_Exist_Ref_Based to filter out executed transport task lines.
--  140206  Matkse  Added method Line_Exist_Ref_Based.
--  140205  MATKSE  Modified Apply_Drop_Off_Location and Revoke_Two_Step_Transport_Task by introducing variable for handling info message.
--  131022  RILASE  Added method Reservation_Booked_For_Transp and a where statement to remove material reserved
--  131022          on a work order that is booked for transport from the transport task reservation view. Added
--  131022          handling for moving reserved work order material inCheck_Insert_.
--  131022  RILASE  Added method Reservation_Booked_For_Transp.
--  131018  DaZase  Bug 113185, removed distinct from the cursor in method Get_Column_Value_If_Unique and renamed some variables and changed an ELSE statement to ELSIF. Several performance changes in method Create_Data_Capture_Lov.
--  131008  Matkse  Modified Check_Insert_ by checking if PAC ID on the source record equals the default PAC ID on the source location then
--                  the quantity moved would need to get the default PAC ID of the destination location applied once the transport task line gets executed.
--  130917  RILASE  Added methods Validate_Part_Avail_Ctrl_Info() and Check_Duplicate_Location_Use(), and Client_SYS.Clear_Info to Execute().
--  130828  RILASE  Added checking_forward_transport_ to Check_Insert_ and consolidated error messages
--  130828          for multiple use of same location on a line.
--  130802  ChJalk  TIBE-912, Removed the global variables.
--  130705  Matkse  Added attribute ALLOW_DEVIATING_AVAIL_CTRL. 
--  130705          Modified Check_Insert_ param list to include allow_deviating_avail_ctrl.
--  130703  Matkse  Added method Revoke_Two_Step_Transport_Task.
--  130702  Matkse  Added method Apply_Drop_Off_Location.
--  130626  DaZase  Added check_availability_control_ to method Check_Insert_ and a new info message DIFFAVAILINFO in that method also. 
--  130617  RiLase  Removed obsolete view TRANSPORT_TASK_LINE_PUB
--  130611  RiLase  Added ForwardToLocationNo.
--  130131  RiLase  Added Modify_To_Location_No.
--  130121  RiLase  Added Get_From_Contract, Get_From_Location_No, Get_To_Contract, Get_To_Location_No, Get_Part_No,
--  130121          Get_Create_Date, Get, Get_Transport_Task_Status, Get_Transport_Task_Status_Db and Modify_Quantity.
--  130117  RiLase  Removed check if line is executed in Execute, Pick and Unpick.
--  130114  RiLase  Added Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Check_Valid_Value.
--  121221  RiLase  Added methods Get_No_Of_Unidentified_Serials, Execute, Pick and Unpick.
--  120504  LEPESE  Added function Other_Owners_Are_Inbound.
--  120426  ChFolk  Added new function Get_Task_Id_List.
--  120410  Matkse  Modified quantity validation in Check_Insert_ to allow quantity as long as it is not zero or below
--  120316  MaMalk  Modified Remove__ to forward actions to the correct LU, based on rowtype. Also corrected
--  120316          Modify__ to pass the info_ out correctly.
--  120125  Matkse  Modified Modify___ to forward actions to the correct LU, based on rowtype
--  120120  LEPESE  Added parameters set_from_task_as_fixed_db_ and set_to_task_as_fixed_db_ to method Move.
--  120119  JeLise  Added 'User Allowed Site' check on view TRANSPORT_TASK_LINE.
--  120118  LEPESE  Added method Move.
--  120111  JeLise  Added attributes eng_chg_level, waiv_dev_rej_no, activity_seq and project_id to view TRANSPORT_TASK_LINE.
--  120111  LEPESE  Added method Check_Insert_ which has been moved from TransportTaskLineNopall.apy.
--  120111          Removed join with inventory_part_loc_pallet_tab in view TRANSPORT_TASK_LINE_RES.
--  120105  Matkse  Added attributes fixed_db and from_location_group to view TRANSPORT_TASK_LINE. 
--  111229  LEPESE  Removed joins with TRANSPORT_TAST_TAB in view TRANSPORT_TASK_LINE_RES.
--  111215  JeLise  Added attributes order_ref1, order_ref2, order_ref3, order_ref4, order_type, transport_task_status, destination,
--  111215          from_contract, from_location_no, to_contract, to_location_no, part_no, configuration_id and create_date.
--  110407  LEPESE  Added /NOCHECK to the TransportTask reference in base view.
--  101207  DaZase Added catch_quantity to view.
--  100505  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  090217  NaLrlk Modified the view TRANSPORT_TASK_LINE.
--  071022  MarSlk Bug 67261, Modified the view TRANSPORT_TASK_LINE_RES, by handling pallet
--  071022         and nopallet situations separately. 
--  060316  OsAllk Modified the function call Transport_Task_Line_Nopall_API.Get_Quantity_.
--  060316  IsWilk Modified the view TRANSPORT_TASK_LINE_RES by adding the NVL to      
--  060316         lot_batch_no, serial_no, waiv_dev_rej_no, eng_chg_level, activity_seq.
--  051117  IsWilk Modified the where clause and qty_reserved column in the view
--  051117         TRANSPORT_TASK_LINE_RES to fetch pallet handling transport task.   
--  050929  IsWilk Modified the view TRANSPORT_TASK_LINE_RES.
--  050927  IsWilk Added the view TRANSPORT_TASK_LINE_RES.
--  000925  JOHESE  Added undefines.
--  000216  ROOD  Modified view comments for transport_task_id.
--  000119  JOHW  Added method Count_Lines.
--  000118  ROOD  Continued development.
--  000104  JOHW  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Public_Rec_Tab IS TABLE OF Public_Rec INDEX BY PLS_INTEGER;

TYPE trans_task_line_details_rec   IS RECORD (
   unit_meas                   VARCHAR2(10),
   catch_unit_meas             VARCHAR2(30),
   catch_qty_required          NUMBER,
   available_to_reserve        VARCHAR2(5),
   no_of_unidentified_serials  NUMBER,
   warehouse_task_started      VARCHAR2(5),
   outermost_hu_id             NUMBER,
   outermost_hu_type_id        VARCHAR2(25),
   outermost_hu_type_desc      VARCHAR2(200),
   outermost_sscc              VARCHAR2(18),
   outermost_alt_hu_label_id   VARCHAR2(25));
TYPE trans_task_line_details_arr IS TABLE OF trans_task_line_details_rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_             CONSTANT VARCHAR2(11) := Database_SYS.string_null_;
number_null_             CONSTANT NUMBER       := -99999999999999;
db_true_                 CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;
db_false_                CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_And_Insert___ (
   newrec_                     IN OUT transport_task_line_tab%ROWTYPE,                               
   check_storage_requirements_ IN     BOOLEAN DEFAULT FALSE,
   requested_date_finished_    IN     DATE    DEFAULT NULL )
IS
   objid_      transport_task_line.objid%TYPE;
   objversion_ transport_task_line.objversion%TYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_                     => newrec_,
                   indrec_                     => indrec_,
                   attr_                       => attr_,
                   check_storage_requirements_ => check_storage_requirements_);
   Insert___(objid_                   => objid_,
             objversion_              => objversion_,
             newrec_                  => newrec_,
             attr_                    => attr_,
             requested_date_finished_ => requested_date_finished_);
END Check_And_Insert___;

PROCEDURE Check_And_Update___ (
   newrec_                       IN OUT transport_task_line_tab%ROWTYPE,                    
   oldrec_                       IN     transport_task_line_tab%ROWTYPE,
   part_tracking_session_id_     IN     NUMBER   DEFAULT NULL,
   validate_hu_struct_position_  IN     BOOLEAN  DEFAULT TRUE,
   check_storage_requirements_   IN     BOOLEAN  DEFAULT FALSE,
   forward_to_transport_task_id_ IN     NUMBER   DEFAULT NULL,
   check_duplicate_reservations_ IN     BOOLEAN  DEFAULT FALSE,
   no_drop_off_location_         IN     BOOLEAN  DEFAULT FALSE,
   attr_                         IN     VARCHAR2 DEFAULT NULL )
IS
   local_attr_ VARCHAR2(2000);
   objid_      transport_task_line.objid%TYPE;
   objversion_ transport_task_line.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   indrec_     := Get_Indicator_Rec___(oldrec_, newrec_);
   local_attr_ := attr_;

   Check_Update___(oldrec_                       => oldrec_,
                   newrec_                       => newrec_,
                   indrec_                       => indrec_,
                   attr_                         => local_attr_,
                   check_duplicate_reservations_ => check_duplicate_reservations_);

   Update___(objid_                        => objid_,
             oldrec_                       => oldrec_,
             newrec_                       => newrec_,
             attr_                         => local_attr_,
             objversion_                   => objversion_,
             by_keys_                      => TRUE,
             check_storage_requirements_   => check_storage_requirements_,
             part_tracking_session_id_     => part_tracking_session_id_,
             validate_hu_struct_position_  => validate_hu_struct_position_,
             forward_to_transport_task_id_ => forward_to_transport_task_id_,
             no_drop_off_location_         => no_drop_off_location_);
END Check_And_Update___;
  
PROCEDURE Check_And_Delete___ (
   remrec_               IN TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   remove_reservation_   IN BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.transport_task_id, remrec_.line_no);
   Check_Delete___(remrec_);
   Delete___(objid_              => objid_,
             remrec_             => remrec_,
             remove_reservation_ => remove_reservation_);
END Check_And_Delete___;

PROCEDURE Update_Assigned___ (
   quantity_added_          OUT NUMBER,
   line_rec_                IN  TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   quantity_to_add_         IN  NUMBER,
   catch_quantity_to_add_   IN  NUMBER,
   requested_date_finished_ IN  DATE )
IS
   record_       transport_task_line_TAB%ROWTYPE;
   old_quantity_ transport_task_line_tab.quantity%TYPE;

   -- Using view instead of table due to inheritage...
   CURSOR find_existing_row IS
      SELECT *
        FROM transport_task_line_tab
       WHERE transport_task_id               = line_rec_.transport_task_id
         AND from_contract                   = line_rec_.from_contract
         AND from_location_no                = line_rec_.from_location_no
         AND part_no                         = line_rec_.part_no
         AND configuration_id                = line_rec_.configuration_id
         AND lot_batch_no                    = line_rec_.lot_batch_no
         AND serial_no                       = line_rec_.serial_no
         AND eng_chg_level                   = line_rec_.eng_chg_level
         AND waiv_dev_rej_no                 = line_rec_.waiv_dev_rej_no
         AND activity_seq                    = line_rec_.activity_seq
         AND handling_unit_id                = line_rec_.handling_unit_id
         AND to_contract                     = line_rec_.to_contract
         AND to_location_no                  = line_rec_.to_location_no
         AND destination                     = line_rec_.destination
         AND NVL(order_ref4, number_null_)   = NVL(line_rec_.order_ref4, number_null_)
         AND NVL(order_ref3, string_null_)   = NVL(line_rec_.order_ref3, string_null_)
         AND NVL(order_ref2, string_null_)   = NVL(line_rec_.order_ref2, string_null_)
         AND NVL(order_ref1, string_null_)   = NVL(line_rec_.order_ref1, string_null_)
         AND NVL(pick_List_no, string_null_) = NVL(line_rec_.pick_List_no, string_null_)
         AND NVL(shipment_id, number_null_)  = NVL(line_rec_.shipment_id, number_null_)
         AND NVL(order_type, string_null_)   = NVL(line_rec_.order_type, string_null_)
         AND reserved_by_source              = line_rec_.reserved_by_source 
      FOR UPDATE;
BEGIN
   OPEN find_existing_row;
   FETCH find_existing_row INTO record_;
   IF find_existing_row%FOUND THEN
      -- Increase the quantity on the already existing line.
      old_quantity_          := record_.quantity;
      record_.quantity       := quantity_to_add_       + record_.quantity;
      record_.catch_quantity := catch_quantity_to_add_ + record_.catch_quantity;

      Modify___(record_);

      quantity_added_ := record_.quantity - old_quantity_;
   ELSE
      -- Add a new line to the transport task
      record_.transport_task_id  := line_rec_.transport_task_id ;
      record_.part_no            := line_rec_.part_no           ;
      record_.configuration_id   := line_rec_.configuration_id  ;
      record_.from_contract      := line_rec_.from_contract     ;
      record_.from_location_no   := line_rec_.from_location_no  ;
      record_.to_contract        := line_rec_.to_contract       ;
      record_.to_location_no     := line_rec_.to_location_no    ;
      record_.destination        := line_rec_.destination       ;
      record_.order_type         := line_rec_.order_type        ;
      record_.order_ref1         := line_rec_.order_ref1        ;
      record_.order_ref2         := line_rec_.order_ref2        ;
      record_.order_ref3         := line_rec_.order_ref3        ;
      record_.order_ref4         := line_rec_.order_ref4        ;
      record_.pick_list_no       := line_rec_.pick_list_no      ;      
      record_.shipment_id        := line_rec_.shipment_id       ;
      record_.lot_batch_no       := line_rec_.lot_batch_no      ;
      record_.serial_no          := line_rec_.serial_no         ;
      record_.eng_chg_level      := line_rec_.eng_chg_level     ;
      record_.waiv_dev_rej_no    := line_rec_.waiv_dev_rej_no   ;
      record_.activity_seq       := line_rec_.activity_seq      ;
      record_.handling_unit_id   := line_rec_.handling_unit_id  ;
      record_.quantity           := quantity_to_add_            ;
      record_.catch_quantity     := catch_quantity_to_add_      ;
      record_.reserved_by_source := line_rec_.reserved_by_source;
      
      Check_And_Insert___(newrec_                  => record_,
                          requested_date_finished_ => requested_date_finished_);

      quantity_added_ := record_.quantity;
   END IF;
   CLOSE find_existing_row;
END Update_Assigned___;

PROCEDURE Check_Project_Site___ (
   project_id_    IN VARCHAR2,
   from_contract_ IN VARCHAR2,
   to_contract_   IN VARCHAR2)
IS
   site_check_ NUMBER;   
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      IF (project_id_ IS NOT NULL AND from_contract_ != to_contract_) THEN
         site_check_ := Project_Site_API.Project_Site_Exist(project_id_, to_contract_);   
         
         IF site_check_ = 0 THEN
            Error_SYS.Record_General(lu_name_,'NOTPRJSITE: Site :P1 is not a valid project site for project :P2.', to_contract_, project_id_);
         END IF;
         
      END IF;          
   $ELSE
      NULL;    
   $END
END Check_Project_Site___;

PROCEDURE Check_Receipt_Issue_Tracked___ (
   transport_task_id_ IN NUMBER,
   from_contract_     IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   part_no_           IN VARCHAR2,
   serial_no_         IN VARCHAR2 )
IS
   CURSOR get_other_parts IS
      SELECT DISTINCT part_no
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE transport_task_id = transport_task_id_
         AND serial_no         = '*'
         AND from_contract    != to_contract
         AND part_no          != part_no_
         AND quantity         != 0;
BEGIN
   IF ((from_contract_ != to_contract_) AND (serial_no_ = '*')) THEN
      IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_)) THEN
         FOR rec_ IN get_other_parts LOOP
            IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(rec_.part_no)) THEN
               Error_SYS.Record_General(lu_name_,'MULTRECISS: Mixing different Receipt and Issue Serial Tracked Parts on the same Transport Task is not allowed when moving between different Sites.');
            END IF;
         END LOOP;
      END IF;
   END IF;
END Check_Receipt_Issue_Tracked___;

PROCEDURE Check_Sites_And_Loc_Group___ (
   transport_task_id_     IN NUMBER,
   line_from_contract_    IN VARCHAR2,
   line_from_location_no_ IN VARCHAR2,
   line_to_contract_      IN VARCHAR2 )
IS
   task_from_contract_       TRANSPORT_TASK_LINE_TAB.from_contract%TYPE;
   task_to_contract_         TRANSPORT_TASK_LINE_TAB.to_contract%TYPE;
   task_from_location_group_ VARCHAR2(5);
   line_from_location_group_ VARCHAR2(5);
BEGIN
   task_from_contract_       := Transport_Task_API.Get_From_Contract__      (transport_task_id_);
   task_to_contract_         := Transport_Task_API.Get_To_Contract          (transport_task_id_);
   task_from_location_group_ := Transport_Task_API.Get_From_Location_Group__(transport_task_id_);
   line_from_location_group_ := Inventory_Location_API.Get_Location_Group   (line_from_contract_, line_from_location_no_);

   IF (line_from_contract_ != NVL(task_from_contract_, line_from_contract_)) THEN
      Error_SYS.Record_General(lu_name_,'FROMSITE: Transport Task :P1 only allows lines transporting from Site :P2', transport_task_id_, task_from_contract_);
   END IF;

   IF (line_to_contract_ != NVL(task_to_contract_, line_to_contract_)) THEN
      Error_SYS.Record_General(lu_name_,'TOSITE: Transport Task :P1 only allows lines transporting to Site :P2', transport_task_id_, task_to_contract_);
   END IF;

   IF (line_from_location_group_ != NVL(task_from_location_group_, line_from_location_group_)) THEN
      Error_SYS.Record_General(lu_name_,'FROMLOCGROUP: Transport Task :P1 only allows lines transporting from Location Group :P2', transport_task_id_, task_from_location_group_);
   END IF;
END Check_Sites_And_Loc_Group___;

PROCEDURE Handle_Line_Executed___ (
   line_rec_                     IN TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   part_tracking_session_id_     IN NUMBER,
   validate_hu_struct_position_  IN BOOLEAN DEFAULT TRUE,
   forward_to_transport_task_id_ IN NUMBER  DEFAULT NULL )
IS
   expiration_date_               DATE;
   source_                        VARCHAR2(200);
   catch_quantity_                NUMBER := NULL;
   local_part_track_session_id_   NUMBER;
   local_forw_to_trans_task_id_   NUMBER;
   quantity_added_                NUMBER;
   quantity_to_add_               NUMBER;
   dummy_serials_added_           Part_Serial_Catalog_API.Serial_No_Tab;
   serial_no_tab_                 Part_Serial_Catalog_API.Serial_No_Tab;
   local_destination_db_          TRANSPORT_TASK_LINE_TAB.destination%TYPE;
   unattached_from_handling_unit_ VARCHAR2(5);
   handling_unit_id_              transport_task_line_tab.handling_unit_id%TYPE;   
   pick_list_printed_db_          VARCHAR2(5);
   order_ref1_                    VARCHAR2(50) := NULL;
   order_ref2_                    VARCHAR2(50) := NULL;
   order_ref3_                    VARCHAR2(50) := NULL;
   order_ref4_                    NUMBER       := NULL;
   order_type_                    VARCHAR2(200):= NULL;
BEGIN                               
   IF (Transport_Task_API.Is_Completely_Executed(line_rec_.transport_task_id)) THEN
      Warehouse_Task_API.Find_And_Report_Task_Source(line_rec_.from_contract,
                                                     Warehouse_Task_Type_API.Decode('TRANSPORT TASK'),
                                                     line_rec_.transport_task_id,
                                                     NULL,
                                                     NULL,
                                                     NULL);
   END IF;

   IF (line_rec_.order_type IN (Order_Type_API.DB_PURCHASE_ORDER,Order_Type_API.DB_SHIPMENT_ORDER) AND line_rec_.reserved_by_source = Fnd_Boolean_API.DB_FALSE) THEN
      $IF (Component_Rceipt_SYS.INSTALLED) $THEN
         -- LIM-NOTREADY need to get an OUT parameter 'unattached_from_handling unit_' in return from this call to RCEIPT component.
         Receive_Order_API.Execute_Transport_Task_Line(unattached_from_handling_unit_ => unattached_from_handling_unit_,
                                                       transport_task_id_             => line_rec_.transport_task_id,
                                                       task_line_no_                  => line_rec_.line_no,                                                    
                                                       validate_hu_struct_position_   => validate_hu_struct_position_);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   ELSE
      catch_quantity_ := line_rec_.catch_quantity;
      source_         := Language_SYS.Translate_Constant(lu_name_, 'TRANSPORTTASK: Transport Task :P1', NULL, to_char(line_rec_.transport_task_id));

      IF line_rec_.quantity > 0 THEN
         IF (part_tracking_session_id_ IS NULL) THEN
            IF ((line_rec_.serial_no = '*') AND
                (line_rec_.to_contract != line_rec_.from_contract)) THEN
               IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(line_rec_.part_no)) THEN
                  Error_SYS.Record_General(lu_name_, 'INTERSITENOSERIAL: Line :P1 of Transport Task :P2 cannot be executed unless the serials are identified.',line_rec_.line_no, line_rec_.transport_task_id);
               END IF;
            END IF;
         ELSE
            IF (line_rec_.to_contract = line_rec_.from_contract) THEN
               Error_SYS.Record_General(lu_name_, 'INTRASITESERIAL: Line :P1 of Transport Task :P2 can be executed without identifying any serials.',line_rec_.line_no, line_rec_.transport_task_id);
            END IF;
   
            IF (line_rec_.serial_no = '*') THEN
               local_part_track_session_id_ := Temporary_Part_Tracking_API.Get_Splitted_Session(part_tracking_session_id_,
                                                                                                line_rec_.quantity);
            END IF;
         END IF;
         
         IF (line_rec_.forward_to_location_no IS NULL) THEN
            local_destination_db_ := line_rec_.destination;
         ELSE
            -- If forward_to_location has a value then we cannot support 'Move To Transit' as a destination because
            -- we want to immediately create a second transport task and this cannot be done for Qty In Transit.
            local_destination_db_ := Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY;
         END IF;

         IF ((line_rec_.order_type IN (Order_Type_API.DB_SHOP_ORDER, 
                                       Order_Type_API.DB_DOP_DEMAND,
                                       Order_Type_API.DB_DOP_NETTED_DEMAND,
                                       Order_Type_API.DB_PROJECT_DELIVERABLES,
                                       Order_Type_API.DB_MATERIAL_REQUISITION,
                                       Order_Type_API.DB_CUSTOMER_ORDER,
                                       Order_Type_API.DB_PROJ_MISC_DEMAND,
                                       Order_Type_API.DB_SHIPMENT_ORDER)) AND 
             (line_rec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE)) THEN
            -- Move stock reserved to a shop order material line or DOP order
            IF (line_rec_.order_type = Order_Type_API.DB_SHOP_ORDER) THEN
               $IF Component_Shpord_SYS.INSTALLED $THEN
                  IF (line_rec_.pick_list_no IS NOT NULL) THEN
                     pick_list_printed_db_ := Shop_Material_Pick_List_API.Get_Pick_List_Printed_DB(line_rec_.pick_list_no);
                  ELSE
                     pick_list_printed_db_ := Fnd_Boolean_API.DB_FALSE;
                  END IF;
               $ELSE
                  Error_SYS.Component_Not_Exist('SHPORD');               
               $END
            END IF;

            Inv_Part_Stock_Reservation_API.Move_Reservation(part_no_                       => line_rec_.part_no,
                                                            configuration_id_              => line_rec_.configuration_id,
                                                            contract_                      => line_rec_.to_contract,
                                                            from_location_no_              => line_rec_.from_location_no,
                                                            to_location_no_                => line_rec_.to_location_no,
                                                            order_supply_demand_type_db_   => Order_Type_API.Get_Order_Suppl_Demand_Type_Db(line_rec_.order_type),
                                                            order_no_                      => line_rec_.order_ref1,
                                                            line_no_                       => line_rec_.order_ref2,
                                                            release_no_                    => line_rec_.order_ref3,
                                                            line_item_no_                  => line_rec_.order_ref4,
                                                            lot_batch_no_                  => line_rec_.lot_batch_no,
                                                            serial_no_                     => line_rec_.serial_no,
                                                            eng_chg_level_                 => line_rec_.eng_chg_level,
                                                            waiv_dev_rej_no_               => line_rec_.waiv_dev_rej_no,
                                                            activity_seq_                  => line_rec_.activity_seq,
                                                            handling_unit_id_              => line_rec_.handling_unit_id,
                                                            quantity_to_move_              => line_rec_.quantity,
                                                            pick_list_no_                  => line_rec_.pick_list_no,
                                                            qty_picked_                    => 0,
                                                            pick_list_printed_db_          => pick_list_printed_db_,
                                                            shipment_id_                   => line_rec_.shipment_id,
                                                            move_comment_                  => source_,
                                                            validate_hu_struct_position_   => validate_hu_struct_position_,
                                                            executing_transport_task_line_ => TRUE);

            IF (line_rec_.order_type IN (Order_Type_API.DB_DOP_DEMAND, Order_Type_API.DB_DOP_NETTED_DEMAND)) THEN
               -- If a transport task for a DOP reservation was executed the material might need to be handed over to the DOP demand
               $IF Component_Dop_SYS.INSTALLED $THEN
                  Dop_Supply_Gen_API.Transport_Task_Executed(line_rec_.transport_task_id, line_rec_.line_no);
               $ELSE
                  Error_SYS.Component_Not_Exist('DOP');               
               $END
               
            END IF;
         ELSE
            expiration_date_ := Inventory_Part_In_Stock_API.Get_Destinat_Expiration_Date(from_contract_    => line_rec_.from_contract,
                                                                                         to_contract_      => line_rec_.to_contract,
                                                                                         part_no_          => line_rec_.part_no,
                                                                                         configuration_id_ => line_rec_.configuration_id,
                                                                                         from_location_no_ => line_rec_.from_location_no,
                                                                                         to_location_no_   => line_rec_.to_location_no,
                                                                                         lot_batch_no_     => line_rec_.lot_batch_no,
                                                                                         serial_no_        => line_rec_.serial_no,
                                                                                         eng_chg_level_    => line_rec_.eng_chg_level,
                                                                                         waiv_dev_rej_no_  => line_rec_.waiv_dev_rej_no,
                                                                                         activity_seq_     => line_rec_.activity_seq,
                                                                                         handling_unit_id_ => line_rec_.handling_unit_id);
                                                                                         
            IF (line_rec_.order_type NOT IN (Order_Type_API.DB_WORK_ORDER, Order_Type_API.DB_WORK_TASK)) THEN                                                                           
               order_ref1_ := line_rec_.order_ref1;
               order_ref2_ := line_rec_.order_ref2;
               order_ref3_ := line_rec_.order_ref3;
               order_ref4_ := line_rec_.order_ref4;  
               order_type_ := Order_Type_API.Decode(line_rec_.order_type);   
            END IF; 
            
            Inventory_Part_In_Stock_API.Move_Part(unattached_from_handling_unit_ => unattached_from_handling_unit_, 
                                                  catch_quantity_                => catch_quantity_,
                                                  contract_                      => line_rec_.from_contract,
                                                  part_no_                       => line_rec_.part_no,
                                                  configuration_id_              => line_rec_.configuration_id,
                                                  location_no_                   => line_rec_.from_location_no,
                                                  lot_batch_no_                  => line_rec_.lot_batch_no,
                                                  serial_no_                     => line_rec_.serial_no,
                                                  eng_chg_level_                 => line_rec_.eng_chg_level,
                                                  waiv_dev_rej_no_               => line_rec_.waiv_dev_rej_no,
                                                  activity_seq_                  => line_rec_.activity_seq,
                                                  handling_unit_id_              => line_rec_.handling_unit_id,
                                                  expiration_date_               => expiration_date_,
                                                  to_contract_                   => line_rec_.to_contract,
                                                  to_location_no_                => line_rec_.to_location_no,
                                                  to_destination_                => Inventory_Part_Destination_API.Decode(local_destination_db_),
                                                  quantity_                      => line_rec_.quantity,
                                                  quantity_reserved_             => line_rec_.quantity,
                                                  move_comment_                  => source_,
                                                  order_no_                      => order_ref1_,
                                                  release_no_                    => order_ref2_,
                                                  sequence_no_                   => order_ref3_,
                                                  line_item_no_                  => order_ref4_,
                                                  order_type_                    => order_type_,
                                                  consume_consignment_stock_     => 'N',
                                                  part_tracking_session_id_      => local_part_track_session_id_,
                                                  transport_task_id_             => line_rec_.transport_task_id,
                                                  validate_hu_struct_position_   => validate_hu_struct_position_);
         END IF;

         $IF Component_Wo_SYS.INSTALLED $THEN 
            -- Callback to Maint Material Allocation to handle reservations, if reserved material has been moved.
            IF (line_rec_.order_type = Order_Type_API.DB_WORK_TASK) THEN
               Maint_Material_Allocation_API.Transport_Task_Executed(line_rec_.transport_task_id, line_rec_.line_no);
            END IF;
         $END
         
       END IF;
   END IF;

   IF line_rec_.quantity > 0 THEN
      -- When a stock record connected to a handling unit had to be disconnected from the handling unit on the destination then 
      -- we need to consider the destination with handling_unit_id = 0.
       
      handling_unit_id_ := CASE unattached_from_handling_unit_ WHEN Fnd_Boolean_API.DB_TRUE THEN 0 ELSE line_rec_.handling_unit_id END;
      
      -- NOTE: If there is a forward to location, a new transport task line shall be created or a line added to existing transport task.
      --       From location will be line_rec_.to_location and to location will be line_rec_.forward_to_location.
      IF (line_rec_.forward_to_location_no IS NOT NULL) THEN
         --  NOTE: Since to location and forward to location always are on the same site (to_contract_), no serial part tracking is needed for receipt
         --        and issue tracked parts.
         IF (line_rec_.serial_no != '*') THEN
            serial_no_tab_(1).serial_no := line_rec_.serial_no;
            quantity_to_add_ := NULL;
         ELSE
            quantity_to_add_ := line_rec_.quantity;
         END IF;

         local_forw_to_trans_task_id_ := forward_to_transport_task_id_;
         Transport_Task_Manager_API.New_Or_Add_To_Existing(transport_task_id_          => local_forw_to_trans_task_id_,
                                                           quantity_added_             => quantity_added_,
                                                           serials_added_              => dummy_serials_added_,
                                                           part_no_                    => line_rec_.part_no,
                                                           configuration_id_           => line_rec_.configuration_id,
                                                           from_contract_              => line_rec_.to_contract,
                                                           from_location_no_           => line_rec_.to_location_no,
                                                           to_contract_                => line_rec_.to_contract,
                                                           to_location_no_             => line_rec_.forward_to_location_no,
                                                           destination_                => Inventory_Part_Destination_API.Decode(line_rec_.destination),
                                                           order_type_                 => Order_Type_API.Decode(line_rec_.order_type),
                                                           order_ref1_                 => line_rec_.order_ref1,
                                                           order_ref2_                 => line_rec_.order_ref2,
                                                           order_ref3_                 => line_rec_.order_ref3,
                                                           order_ref4_                 => line_rec_.order_ref4,
                                                           pick_list_no_               => line_rec_.pick_list_no,
                                                           shipment_id_                => line_rec_.shipment_id,
                                                           lot_batch_no_               => line_rec_.lot_batch_no,
                                                           serial_no_tab_              => serial_no_tab_,
                                                           eng_chg_level_              => line_rec_.eng_chg_level,
                                                           waiv_dev_rej_no_            => line_rec_.waiv_dev_rej_no,
                                                           activity_seq_               => line_rec_.activity_seq,
                                                           handling_unit_id_           => handling_unit_id_,
                                                           quantity_to_add_            => quantity_to_add_,
                                                           allow_deviating_avail_ctrl_ => Fnd_Boolean_API.DB_TRUE,
                                                           reserved_by_source_db_      => line_rec_.reserved_by_source);
      END IF;
   END IF;
END Handle_Line_Executed___;

FUNCTION Get_Existing_Line_No___ (
   transport_task_id_      IN NUMBER,
   exclude_line_no_        IN NUMBER,
   from_contract_          IN VARCHAR2,
   from_location_no_       IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN VARCHAR2,
   handling_unit_id_       IN NUMBER,
   to_contract_            IN VARCHAR2,
   to_location_no_         IN VARCHAR2,
   forward_to_location_no_ IN VARCHAR2,
   destination_db_         IN VARCHAR2,
   order_ref1_             IN VARCHAR2,
   order_ref2_             IN VARCHAR2,
   order_ref3_             IN VARCHAR2,
   order_ref4_             IN VARCHAR2,
   pick_list_no_           IN VARCHAR2,
   shipment_id_            IN NUMBER,      
   order_type_db_          IN VARCHAR2,
   reserved_by_source_db_  IN VARCHAR2 ) RETURN NUMBER
IS
   existing_line_no_        TRANSPORT_TASK_LINE_TAB.line_no%TYPE;
      
   CURSOR get_existing_line_no IS
      SELECT line_no
        FROM TRANSPORT_TASK_LINE_TAB
        WHERE transport_task_id                        = transport_task_id_
         AND line_no                                  != NVL(exclude_line_no_, number_null_)
         AND from_contract                             = from_contract_
         AND from_location_no                          = from_location_no_
         AND part_no                                   = part_no_
         AND configuration_id                          = configuration_id_
         AND lot_batch_no                              = lot_batch_no_
         AND serial_no                                 = serial_no_
         AND eng_chg_level                             = eng_chg_level_
         AND waiv_dev_rej_no                           = waiv_dev_rej_no_
         AND activity_seq                              = activity_seq_
         AND handling_unit_id                          = handling_unit_id_
         AND to_contract                               = to_contract_
         AND to_location_no                            = to_location_no_
         AND NVL(forward_to_location_no, string_null_) = NVL(forward_to_location_no_, string_null_)
         AND destination                               = destination_db_
         AND transport_task_status                     = Transport_Task_Status_API.db_created
         AND NVL(order_ref1, string_null_)             = NVL(order_ref1_,   string_null_)
         AND NVL(order_ref2, string_null_)             = NVL(order_ref2_,   string_null_)
         AND NVL(order_ref3, string_null_)             = NVL(order_ref3_,   string_null_)
         AND NVL(order_ref4, number_null_)             = NVL(order_ref4_,   number_null_)
         AND NVL(pick_list_no, string_null_)           = NVL(pick_list_no_, string_null_)
         AND NVL(shipment_id, number_null_)            = NVL(shipment_id_,  number_null_)         
         AND NVL(order_type, string_null_)             = NVL(order_type_db_,string_null_)
         AND reserved_by_source                        = reserved_by_source_db_;
BEGIN
   OPEN get_existing_line_no;
   FETCH get_existing_line_no INTO existing_line_no_;
   CLOSE get_existing_line_no;

   RETURN(existing_line_no_);
END Get_Existing_Line_No___;

PROCEDURE Validate_Existing_Line_No___ (
   transport_task_id_      IN NUMBER,
   exclude_line_no_        IN NUMBER,
   from_contract_          IN VARCHAR2,
   from_location_no_       IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   eng_chg_level_          IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   activity_seq_           IN VARCHAR2,
   handling_unit_id_       IN NUMBER,
   to_contract_            IN VARCHAR2,
   to_location_no_         IN VARCHAR2,
   forward_to_location_no_ IN VARCHAR2,
   destination_db_         IN VARCHAR2,
   order_ref1_             IN VARCHAR2,
   order_ref2_             IN VARCHAR2,
   order_ref3_             IN VARCHAR2,
   order_ref4_             IN VARCHAR2,
   pick_list_no_           IN VARCHAR2,
   shipment_id_            IN NUMBER,      
   order_type_db_          IN VARCHAR2,
   reserved_by_source_db_  IN VARCHAR2 )
IS
   existing_line_no_ TRANSPORT_TASK_LINE_TAB.line_no%TYPE;
BEGIN
   existing_line_no_ := Get_Existing_Line_No___(transport_task_id_,
                                                exclude_line_no_,
                                                from_contract_,
                                                from_location_no_,
                                                part_no_,
                                                configuration_id_,
                                                lot_batch_no_,
                                                serial_no_,
                                                eng_chg_level_,
                                                waiv_dev_rej_no_,
                                                activity_seq_,
                                                handling_unit_id_,
                                                to_contract_,
                                                to_location_no_,
                                                forward_to_location_no_,
                                                destination_db_,
                                                order_ref1_,
                                                order_ref2_,
                                                order_ref3_,
                                                order_ref4_,
                                                pick_list_no_,
                                                shipment_id_,
                                                order_type_db_,
                                                reserved_by_source_db_);
   IF (existing_line_no_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DUPLICATELINE: There is already Line No :P1 with the exact same information. Change the quantity on that line instead.', existing_line_no_);
   END IF;
END Validate_Existing_Line_No___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   default_contract_ VARCHAR2(5);
BEGIN
   super(attr_);
   default_contract_ := User_Default_API.Get_Contract;
   Client_SYS.Add_To_Attr('FROM_CONTRACT', default_contract_, attr_);
   Client_SYS.Add_To_Attr('TO_CONTRACT', default_contract_, attr_);
   Client_SYS.Add_To_Attr('DESTINATION', Inventory_Part_Destination_API.Decode('N'), attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', '*', attr_);
   Client_SYS.Add_To_Attr('ALLOW_DEVIATING_AVAIL_CTRL_DB', Fnd_Boolean_API.DB_TRUE, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_                      OUT VARCHAR2,
   objversion_                 OUT VARCHAR2,
   newrec_                  IN OUT TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   attr_                    IN OUT VARCHAR2,
   requested_date_finished_ IN     DATE DEFAULT NULL )
IS
   quantity_reserved_       NUMBER := 0;
   number_of_lines_         NUMBER;
   location_group_          VARCHAR2(5);
   warehouse_task_id_       NUMBER;
   msg_                     VARCHAR2(200);
   task_type_               VARCHAR2(200);
   temp_                    NUMBER;

   CURSOR get_new_line_no(transport_task_id_ NUMBER) IS
      SELECT NVL(MAX(line_no), 0) + 1
      FROM TRANSPORT_TASK_LINE_TAB
      WHERE transport_task_id = transport_task_id_;
BEGIN
   newrec_.create_date           := Site_API.Get_Site_Date(newrec_.from_contract);
   newrec_.transport_task_status := Transport_Task_Status_API.db_created;
   temp_                         := newrec_.quantity;

   IF (newrec_.forward_to_location_no IS NULL) THEN
      Transport_Task_Manager_API.Set_Transport_Locations(forward_to_location_no_ => newrec_.forward_to_location_no,
                                                         to_location_no_         => newrec_.to_location_no,
                                                         from_contract_          => newrec_.from_contract,
                                                         from_location_no_       => newrec_.from_location_no,
                                                         to_contract_            => newrec_.to_contract,
                                                         part_no_                => newrec_.part_no,
                                                         configuration_id_       => newrec_.configuration_id,
                                                         order_type_             => newrec_.order_type,
                                                         order_ref1_             => newrec_.order_ref1,
                                                         order_ref2_             => newrec_.order_ref2,
                                                         order_ref3_             => newrec_.order_ref3,
                                                         order_ref4_             => newrec_.order_ref4,
                                                         pick_list_no_           => newrec_.pick_list_no,
                                                         shipment_id_            => newrec_.shipment_id,
                                                         lot_batch_no_           => newrec_.lot_batch_no,
                                                         serial_no_              => newrec_.serial_no,
                                                         eng_chg_level_          => newrec_.eng_chg_level,
                                                         waiv_dev_rej_no_        => newrec_.waiv_dev_rej_no,
                                                         activity_seq_           => newrec_.activity_seq,
                                                         handling_unit_id_       => newrec_.handling_unit_id,
                                                         quantity_               => newrec_.quantity,
                                                         reserved_by_source_db_  => newrec_.reserved_by_source);
   END IF;

   IF (newrec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE) THEN
      -- Check if quantity is already reserved by the order reference. In that case do not reserve
      -- against the transport task line.
      quantity_reserved_ := Inv_Part_Stock_Reservation_API.Get_Qty_Reserved(order_no_                    => newrec_.order_ref1,                
                                                                            line_no_                     => newrec_.order_ref2,                 
                                                                            release_no_                  => newrec_.order_ref3,              
                                                                            line_item_no_                => newrec_.order_ref4,     
                                                                            pick_list_no_                => newrec_.pick_list_no,
                                                                            shipment_id_                 => newrec_.shipment_id,                                                                            
                                                                            order_supply_demand_type_db_ => Order_Type_API.Get_Order_Suppl_Demand_Type_Db(newrec_.order_type),
                                                                            contract_                    => newrec_.from_contract,                
                                                                            part_no_                     => newrec_.part_no,
                                                                            configuration_id_            => newrec_.configuration_id,        
                                                                            location_no_                 => newrec_.from_location_no,
                                                                            lot_batch_no_                => newrec_.lot_batch_no,            
                                                                            serial_no_                   => newrec_.serial_no,               
                                                                            eng_chg_level_               => newrec_.eng_chg_level,         
                                                                            waiv_dev_rej_no_             => newrec_.waiv_dev_rej_no,           
                                                                            activity_seq_                => newrec_.activity_seq,
                                                                            handling_unit_id_            => newrec_.handling_unit_id);
   END IF;
   IF (quantity_reserved_ = 0) THEN
      -- Try to reserve the quantity. Succesfully reserved quantity is in quantity_reserved.
      Inventory_Part_In_Stock_API.Reserve_For_Transport(quantity_reserved_ => quantity_reserved_,
                                                        contract_          => newrec_.from_contract,
                                                        part_no_           => newrec_.part_no,
                                                        configuration_id_  => newrec_.configuration_id,
                                                        location_no_       => newrec_.from_location_no,
                                                        lot_batch_no_      => newrec_.lot_batch_no,
                                                        serial_no_         => newrec_.serial_no,
                                                        eng_chg_level_     => newrec_.eng_chg_level,
                                                        waiv_dev_rej_no_   => newrec_.waiv_dev_rej_no,
                                                        activity_seq_      => newrec_.activity_seq,
                                                        handling_unit_id_  => newrec_.handling_unit_id,
                                                        quantity_          => newrec_.quantity);
   END IF;
                                                     
   IF quantity_reserved_ = 0 THEN
      -- Aborting and messaging to the client...
      Client_SYS.Add_Info(lu_name_, 'NOQUANTITYINSERT: No quantity was possible to reserve so the line was not inserted.');
      -- Important to always have correct value on newrec_.quantity.
      newrec_.quantity := quantity_reserved_;
   ELSE
      -- Important to always have correct value on newrec_.quantity.
      newrec_.quantity := quantity_reserved_;

      OPEN get_new_line_no(newrec_.transport_task_id);
      FETCH get_new_line_no INTO newrec_.line_no;
      CLOSE get_new_line_no;
      
      super(objid_, objversion_, newrec_, attr_);
      
      number_of_lines_ := Count_Lines(newrec_.transport_task_id);
      location_group_  := Inventory_Location_API.Get_Location_Group(newrec_.from_contract, newrec_.from_location_no);
      task_type_       := Warehouse_Task_Type_API.Decode('TRANSPORT TASK');

      IF (number_of_lines_ = 1) THEN
         msg_ := Language_SYS.Translate_Constant(lu_name_, 'TASK_INFO: Transport Task Id: :P1 *', NULL, newrec_.transport_task_id);

         Warehouse_Task_API.New(warehouse_task_id_,
                                task_type_,
                                NULL,
                                newrec_.transport_task_id,
                                NULL,
                                NULL,
                                NULL,
                                number_of_lines_,
                                location_group_,
                                newrec_.from_contract,
                                requested_date_finished_,
                                msg_,
                                NULL);
      ELSE
         Warehouse_Task_API.Modify_Number_Of_Lines_Source(newrec_.from_contract,
                                                          task_type_,
                                                          newrec_.transport_task_id,
                                                          NULL,
                                                          NULL,
                                                          NULL,
                                                          number_of_lines_);
      END IF;
      
      -- Messaging to the client...
      IF quantity_reserved_ < temp_ THEN
         Client_SYS.Add_Info(lu_name_, 'SOMEQUANTITYINSERT: There was not enough quantity to reserve. Only :P1 out of desired :P2 was reserved.', quantity_reserved_, temp_);
      END IF;

      Client_SYS.Add_To_Attr('LINE_NO', newrec_.line_no, attr_ );
      Client_SYS.Set_Item_Value('PROJECT_ID', newrec_.project_id, attr_ );      
   END IF;
   -- Communicating info that is decided in the server, back to the client after inserting a record.
   Client_SYS.Add_To_Attr('CREATE_DATE', newrec_.create_date, attr_);
   Client_SYS.Add_To_Attr('TRANSPORT_TASK_STATUS', Transport_Task_Status_API.Decode(newrec_.transport_task_status), attr_);
   
   Add_Destination_Info___(newrec_);

   Hu_Snapshot_For_Refresh_API.New(source_ref1_         => newrec_.transport_task_id,
                                   source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK);
   
   IF (newrec_.order_type = Order_Type_API.DB_CUSTOMER_ORDER) THEN
      Modify_Cust_Ord_Reservation___(newrec_, Fnd_Boolean_API.DB_TRUE);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_                        IN     VARCHAR2,
   oldrec_                       IN     TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   newrec_                       IN OUT TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   attr_                         IN OUT VARCHAR2,
   objversion_                   IN OUT VARCHAR2,
   by_keys_                      IN     BOOLEAN DEFAULT FALSE,
   check_storage_requirements_   IN     BOOLEAN DEFAULT FALSE,
   part_tracking_session_id_     IN     NUMBER  DEFAULT NULL,
   no_drop_off_location_         IN     BOOLEAN DEFAULT FALSE,
   validate_hu_struct_position_  IN     BOOLEAN DEFAULT TRUE,
   forward_to_transport_task_id_ IN     NUMBER  DEFAULT NULL )
IS
   quantity_to_reserve_          NUMBER;
   quantity_reserved_            NUMBER;
   check_store_requirement_temp_ BOOLEAN;
   client_action_                VARCHAR2(5); 
BEGIN 
   check_store_requirement_temp_ := check_storage_requirements_;
   client_action_                := Client_SYS.Get_Item_Value('CLIENT_ACTION', attr_);
   IF (client_action_ = 'DO') THEN      
      check_store_requirement_temp_ := TRUE;
   END IF;

   IF (newrec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE) THEN
      quantity_to_reserve_ := 0;
   ELSE
      quantity_to_reserve_ := newrec_.quantity - oldrec_.quantity;
   END IF;
   
    -- Look for drop off location if to site or to location has changed and no forward to location has been entered.
   IF ((newrec_.to_contract != oldrec_.to_contract OR newrec_.to_location_no != oldrec_.to_location_no) AND NOT no_drop_off_location_ AND newrec_.forward_to_location_no IS NULL) THEN
      Transport_Task_Manager_API.Set_Transport_Locations(forward_to_location_no_ => newrec_.forward_to_location_no,
                                                         to_location_no_         => newrec_.to_location_no,
                                                         from_contract_          => newrec_.from_contract,
                                                         from_location_no_       => newrec_.from_location_no,
                                                         to_contract_            => newrec_.to_contract,
                                                         part_no_                => newrec_.part_no,
                                                         configuration_id_       => newrec_.configuration_id,
                                                         order_type_             => newrec_.order_type,
                                                         order_ref1_             => newrec_.order_ref1,
                                                         order_ref2_             => newrec_.order_ref2,
                                                         order_ref3_             => newrec_.order_ref3,
                                                         order_ref4_             => newrec_.order_ref4,
                                                         pick_list_no_           => newrec_.pick_list_no,
                                                         shipment_id_            => newrec_.shipment_id,                                                         
                                                         lot_batch_no_           => newrec_.lot_batch_no,
                                                         serial_no_              => newrec_.serial_no,
                                                         eng_chg_level_          => newrec_.eng_chg_level,
                                                         waiv_dev_rej_no_        => newrec_.waiv_dev_rej_no,
                                                         activity_seq_           => newrec_.activity_seq,
                                                         handling_unit_id_       => newrec_.handling_unit_id,
                                                         quantity_               => newrec_.quantity,
                                                         reserved_by_source_db_  => newrec_.reserved_by_source);
   END IF;   
                                                           
   IF (quantity_to_reserve_ != 0) THEN
      -- Try to reserve the quantity. Succesfully reserved quantity is in quantity_reserved.
      Inventory_Part_In_Stock_API.Reserve_For_Transport(quantity_reserved_ => quantity_reserved_,
                                                        contract_          => newrec_.from_contract,
                                                        part_no_           => newrec_.part_no,
                                                        configuration_id_  => newrec_.configuration_id,
                                                        location_no_       => newrec_.from_location_no,
                                                        lot_batch_no_      => newrec_.lot_batch_no,
                                                        serial_no_         => newrec_.serial_no,
                                                        eng_chg_level_     => newrec_.eng_chg_level,
                                                        waiv_dev_rej_no_   => newrec_.waiv_dev_rej_no,
                                                        activity_seq_      => newrec_.activity_seq,
                                                        handling_unit_id_  => newrec_.handling_unit_id,
                                                        quantity_          => quantity_to_reserve_);
   
      IF quantity_reserved_ > quantity_to_reserve_ THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDQTYUPDATE: Inconsistent quantity when reserving part :P1 on contract :P2. Contact system support.', newrec_.part_no, newrec_.from_contract);
      END IF;
   
      IF quantity_reserved_ = 0 THEN
         Client_SYS.Add_Info(lu_name_, 'NOQUANTITYUPDATE: No additional quantity was possible to reserve. The line :P1 was not modified.', newrec_.line_no);
      ELSE
         IF quantity_reserved_ < quantity_to_reserve_ THEN
            Client_SYS.Add_Info(lu_name_, 'SOMEQUANTITYUPDATE: There was not enough additional quantity to reserve. Only :P1 out of desired :P2 was reserved.', quantity_reserved_, quantity_to_reserve_);
         END IF;
      END IF;

      newrec_.quantity := oldrec_.quantity + quantity_reserved_;
   END IF;

   IF (check_store_requirement_temp_) THEN
      IF (newrec_.quantity > oldrec_.quantity OR 
          newrec_.to_contract != oldrec_.to_contract OR newrec_.to_location_no != oldrec_.to_location_no OR 
         (newrec_.forward_to_location_no IS NOT NULL AND Validate_SYS.Is_Different(newrec_.forward_to_location_no, oldrec_.forward_to_location_no))) THEN
         -- Need to temporarily set the quantity to zero before calling Check_Storage_Requirements because
         -- otherwise the old quantity will still occupy capacity at the destination location during the check.
         IF by_keys_ THEN
            UPDATE transport_task_line_tab
            SET quantity = 0
            WHERE transport_task_id = newrec_.transport_task_id
            AND   line_no           = newrec_.line_no;
         ELSE
            UPDATE transport_task_line_tab
            SET quantity = 0
            WHERE rowid = objid_;
         END IF;
         Inventory_Putaway_Manager_API.Check_Storage_Requirements(to_contract_      => newrec_.to_contract,
                                                                  part_no_          => newrec_.part_no,
                                                                  configuration_id_ => newrec_.configuration_id,
                                                                  to_location_no_   => newrec_.to_location_no,
                                                                  lot_batch_no_     => newrec_.lot_batch_no,
                                                                  serial_no_        => newrec_.serial_no,
                                                                  eng_chg_level_    => newrec_.eng_chg_level,
                                                                  waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                                                  activity_seq_     => newrec_.activity_seq,
                                                                  handling_unit_id_ => newrec_.handling_unit_id,
                                                                  quantity_         => newrec_.quantity);
         
         IF (newrec_.forward_to_location_no IS NOT NULL AND 
            (Validate_SYS.Is_Different(newrec_.forward_to_location_no, oldrec_.forward_to_location_no) OR newrec_.quantity > oldrec_.quantity)) THEN
            Inventory_Putaway_Manager_API.Check_Storage_Requirements(to_contract_      => newrec_.to_contract,
                                                                     part_no_          => newrec_.part_no,
                                                                     configuration_id_ => newrec_.configuration_id,
                                                                     to_location_no_   => newrec_.forward_to_location_no,
                                                                     lot_batch_no_     => newrec_.lot_batch_no,
                                                                     serial_no_        => newrec_.serial_no,
                                                                     eng_chg_level_    => newrec_.eng_chg_level,
                                                                     waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                                                     activity_seq_     => newrec_.activity_seq,
                                                                     handling_unit_id_ => newrec_.handling_unit_id,
                                                                     quantity_         => newrec_.quantity);
         END IF;
      END IF;
   END IF;   
      
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (oldrec_.to_location_no != newrec_.to_location_no) OR (oldrec_.to_contract != newrec_.to_contract) THEN
      Inventory_Refill_Manager_API.Refill_This_Location(oldrec_.to_contract,
                                                        oldrec_.part_no,
                                                        oldrec_.to_location_no);
   END IF;

   IF (newrec_.transport_task_status != oldrec_.transport_task_status) THEN
      IF (newrec_.transport_task_status = Transport_Task_Status_API.db_executed) THEN
         Handle_Line_Executed___(line_rec_                      => newrec_, 
                                 part_tracking_session_id_      => part_tracking_session_id_,
                                 validate_hu_struct_position_   => validate_hu_struct_position_, 
                                 forward_to_transport_task_id_  => forward_to_transport_task_id_);
      END IF;
   END IF;

   IF ((NVL(oldrec_.forward_to_location_no, Database_SYS.string_null_) != 
        NVL(newrec_.forward_to_location_no, Database_SYS.string_null_)) OR 
       (oldrec_.destination != newrec_.destination)) THEN
       Add_Destination_Info___(newrec_);
   END IF;

   Hu_Snapshot_For_Refresh_API.New(source_ref1_         => newrec_.transport_task_id,
                                   source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN TRANSPORT_TASK_LINE_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   IF (remrec_.transport_task_status != Transport_Task_Status_API.DB_CREATED) THEN
      Error_SYS.Record_General(lu_name_, 'TASKEXECUTEDDELETE: Only lines in status :P1 can be deleted.', Transport_Task_Status_API.Decode(Transport_Task_Status_API.DB_CREATED));
   END IF;
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_              IN VARCHAR2,
   remrec_             IN TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   remove_reservation_ IN BOOLEAN DEFAULT TRUE )
IS
   quantity_reserved_ NUMBER := 0;
   number_of_lines_   NUMBER;
   task_type_         VARCHAR2(200);
BEGIN
   IF remrec_.quantity != 0 THEN
      IF (remrec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE) THEN
         -- Check if quantity is already reserved by the order reference. In that case don't unreserve
         -- against the transport task line.
         quantity_reserved_ := Inv_Part_Stock_Reservation_API.Get_Qty_Reserved(order_no_                    => remrec_.order_ref1,                
                                                                               line_no_                     => remrec_.order_ref2,                 
                                                                               release_no_                  => remrec_.order_ref3,              
                                                                               line_item_no_                => remrec_.order_ref4, 
                                                                               pick_list_no_                => remrec_.pick_list_no,
                                                                               shipment_id_                 => remrec_.shipment_id,                                                                               
                                                                               order_supply_demand_type_db_ => Order_Type_API.Get_Order_Suppl_Demand_Type_Db(remrec_.order_type),
                                                                               contract_                    => remrec_.from_contract,
                                                                               part_no_                     => remrec_.part_no,
                                                                               configuration_id_            => remrec_.configuration_id,
                                                                               location_no_                 => remrec_.from_location_no,
                                                                               lot_batch_no_                => remrec_.lot_batch_no,
                                                                               serial_no_                   => remrec_.serial_no,
                                                                               eng_chg_level_               => remrec_.eng_chg_level,
                                                                               waiv_dev_rej_no_             => remrec_.waiv_dev_rej_no,
                                                                               activity_seq_                => remrec_.activity_seq,
                                                                               handling_unit_id_            => remrec_.handling_unit_id);
      END IF;
      
      IF (quantity_reserved_ = 0 AND remove_reservation_) THEN
         -- Try to unreserve the quantity. Succesfully unreserved quantity is in quantity_reserved.
         Inventory_Part_In_Stock_API.Reserve_For_Transport(quantity_reserved_ => quantity_reserved_,
                                                           contract_          => remrec_.from_contract,
                                                           part_no_           => remrec_.part_no,
                                                           configuration_id_  => remrec_.configuration_id,
                                                           location_no_       => remrec_.from_location_no,
                                                           lot_batch_no_      => remrec_.lot_batch_no,
                                                           serial_no_         => remrec_.serial_no,
                                                           eng_chg_level_     => remrec_.eng_chg_level,
                                                           waiv_dev_rej_no_   => remrec_.waiv_dev_rej_no,
                                                           activity_seq_      => remrec_.activity_seq,
                                                           handling_unit_id_  => remrec_.handling_unit_id,
                                                           quantity_          => -remrec_.quantity);
         IF quantity_reserved_ != -remrec_.quantity THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDQTYDELETE: Inconsistent quantity when unreserving part :P1 on contract :P2. Contact system support.', remrec_.part_no, remrec_.from_contract);
         END IF;
      END IF;
   END IF;

   super(objid_, remrec_);
   
   number_of_lines_ := Count_Lines(remrec_.transport_task_id);
   task_type_       := Warehouse_Task_Type_API.Decode('TRANSPORT TASK');

   IF (number_of_lines_ = 0) THEN
      Warehouse_Task_API.Find_And_Cancel_Task_Source(remrec_.from_contract,
                                                     task_type_,
                                                     remrec_.transport_task_id,
                                                     NULL,
                                                     NULL,
                                                     NULL);
   ELSE
      Warehouse_Task_API.Modify_Number_Of_Lines_Source(remrec_.from_contract,
                                                       task_type_,
                                                       remrec_.transport_task_id,
                                                       NULL,
                                                       NULL,
                                                       NULL,
                                                       number_of_lines_);
      IF (Transport_Task_API.Is_Completely_Executed(remrec_.transport_task_id)) THEN
         -- Only executed lines remains on the Transport Task
         Warehouse_Task_API.Find_And_Report_Task_Source(remrec_.from_contract,
                                                        task_type_,
                                                        remrec_.transport_task_id,
                                                        NULL,
                                                        NULL,
                                                        NULL);
      END IF;
   END IF;

   Hu_Snapshot_For_Refresh_API.New(source_ref1_         => remrec_.transport_task_id,
                                   source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK);
   
   IF (remrec_.order_type = Order_Type_API.DB_CUSTOMER_ORDER AND remove_reservation_) THEN
      Modify_Cust_Ord_Reservation___(remrec_, Fnd_Boolean_API.DB_FALSE);
   END IF;
END Delete___;

@Override
PROCEDURE Check_Insert___ (
   newrec_                     IN OUT transport_task_line_tab%ROWTYPE,
   indrec_                     IN OUT Indicator_Rec,
   attr_                       IN OUT VARCHAR2,
   check_storage_requirements_ IN     BOOLEAN DEFAULT FALSE )
IS
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(4000);
   existing_line_no_             TRANSPORT_TASK_LINE_TAB.line_no%TYPE;   
   check_and_insert_             BOOLEAN := FALSE;
   client_action_                VARCHAR2(5); 
   from_availability_control_id_ VARCHAR2(25);   
   to_availability_control_id_   VARCHAR2(25);   
   to_location_qty_onhand_       NUMBER;   
   allow_deviating_avail_ctrl_   BOOLEAN;   
   local_destination_db_         TRANSPORT_TASK_LINE_TAB.destination%TYPE;
   local_check_storage_reqrmnts_ BOOLEAN;
   to_stock_record_              Inventory_Part_In_Stock_API.Public_Rec;
BEGIN
   IF NOT indrec_.allow_deviating_avail_ctrl THEN 
      newrec_.allow_deviating_avail_ctrl := Fnd_Boolean_API.DB_TRUE;
   END IF;

   IF (newrec_.activity_seq != 0) THEN
      $IF Component_Proj_SYS.INSTALLED $THEN
         Activity_API.Exist(newrec_.activity_seq);           
      $ELSE
         Error_SYS.Record_General(lu_name_, 'NOACTIVITY: Activity Seq cannot have value since Module Project is not installed');    
      $END
   END IF; 
   
   IF NOT indrec_.reserved_by_source THEN 
      newrec_.reserved_by_source := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   client_action_                := Client_SYS.Get_Item_Value('CLIENT_ACTION', attr_);
   local_check_storage_reqrmnts_ := check_storage_requirements_;
   IF client_action_ IS NOT NULL THEN
      IF client_action_ = 'CHECK' THEN
         local_check_storage_reqrmnts_ := TRUE;  
         check_and_insert_  := FALSE; 
      ELSIF client_action_ = 'DO' THEN
         local_check_storage_reqrmnts_ := TRUE;  
         check_and_insert_ := TRUE; 
      END IF;
   END IF;
   
   IF Transport_Task_Manager_API.Warehouse_Task_Is_Started_(newrec_.transport_task_id) THEN
      Error_SYS.Record_General(lu_name_, 'WTASKSTARTEDINSERT: Lines cannot be added to Transport Task :P1 since the Warehouse Task connected to it is started or parked.', newrec_.transport_task_id);
   END IF;
  
  -- Override allow_deviating_avail_ctrl if it is set to false on site level.
   IF (Site_Invent_Info_API.Get_Allow_Deviating_Avail_C_Db(newrec_.to_contract) = Fnd_Boolean_API.DB_FALSE) THEN 
      newrec_.allow_deviating_avail_ctrl := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   -- Assign correct Project ID and check if parts are allowed on this site
   $IF Component_Proj_SYS.INSTALLED $THEN
      IF (newrec_.activity_seq != 0) THEN 
         newrec_.project_id := Activity_API.Get_Project_Id(newrec_.activity_seq);    
      END IF;   
   $END

   Check_Project_Site___(newrec_.project_id,
                         newrec_.from_contract,
                         newrec_.to_contract);
                            
   allow_deviating_avail_ctrl_   := CASE newrec_.allow_deviating_avail_ctrl WHEN Fnd_Boolean_API.DB_TRUE THEN TRUE WHEN Fnd_Boolean_API.DB_FALSE THEN FALSE END;
   from_availability_control_id_ := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_          => newrec_.from_contract,
                                                                                            part_no_           => newrec_.part_no,
                                                                                            configuration_id_  => newrec_.configuration_id,
                                                                                            location_no_       => newrec_.from_location_no,
                                                                                            lot_batch_no_      => newrec_.lot_batch_no,
                                                                                            serial_no_         => newrec_.serial_no,
                                                                                            eng_chg_level_     => newrec_.eng_chg_level,
                                                                                            waiv_dev_rej_no_   => newrec_.waiv_dev_rej_no,
                                                                                            activity_seq_      => newrec_.activity_seq,
                                                                                            handling_unit_id_  => newrec_.handling_unit_id);
   IF (newrec_.forward_to_location_no IS NULL) THEN
      local_destination_db_ := newrec_.destination;
   ELSE
      -- If forward_to_location has a value then we will always use 'Move to inventory' as a destination because
      -- we want to immediately create a second transport task and this cannot be done for Qty In Transit.
      -- The actual destination will be forwarded to the next transport task line that will be created when this one
      -- gets executed.
      local_destination_db_ := Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY;
   END IF;
   
   Check_Insert_(from_contract_              => newrec_.from_contract,
                 from_location_no_           => newrec_.from_location_no,
                 part_no_                    => newrec_.part_no,
                 configuration_id_           => newrec_.configuration_id,
                 to_contract_                => newrec_.to_contract,
                 to_location_no_             => newrec_.to_location_no,
                 destination_                => local_destination_db_,
                 order_type_                 => newrec_.order_type,
                 order_ref1_                 => newrec_.order_ref1,
                 order_ref2_                 => newrec_.order_ref2,
                 order_ref3_                 => newrec_.order_ref3,
                 order_ref4_                 => newrec_.order_ref4,
                 pick_list_no_               => newrec_.pick_list_no,
                 shipment_id_                => newrec_.shipment_id,
                 lot_batch_no_               => newrec_.lot_batch_no,
                 serial_no_                  => newrec_.serial_no,
                 eng_chg_level_              => newrec_.eng_chg_level,
                 waiv_dev_rej_no_            => newrec_.waiv_dev_rej_no,
                 activity_seq_               => newrec_.activity_seq,
                 handling_unit_id_           => newrec_.handling_unit_id,
                 quantity_                   => newrec_.quantity,
                 allow_deviating_avail_ctrl_ => allow_deviating_avail_ctrl_,
                 check_storage_requirements_ => local_check_storage_reqrmnts_,
                 reserved_by_source_db_      => newrec_.reserved_by_source );
   
   IF (newrec_.forward_to_location_no IS NOT NULL) THEN
      -- NOTE: Extra check to make sure that to and forward to location is not the same.
      Check_Duplicate_Location_Use(from_contract_    => newrec_.to_contract,
                                   from_location_no_ => newrec_.to_location_no,
                                   to_contract_      => newrec_.to_contract,
                                   to_location_no_   => newrec_.forward_to_location_no);

      Check_Insert_(from_contract_              => newrec_.from_contract,
                    from_location_no_           => newrec_.from_location_no,
                    part_no_                    => newrec_.part_no,
                    configuration_id_           => newrec_.configuration_id,
                    to_contract_                => newrec_.to_contract,
                    to_location_no_             => newrec_.forward_to_location_no,
                    destination_                => newrec_.destination,
                    order_type_                 => newrec_.order_type,
                    order_ref1_                 => newrec_.order_ref1,
                    order_ref2_                 => newrec_.order_ref2,
                    order_ref3_                 => newrec_.order_ref3,
                    order_ref4_                 => newrec_.order_ref4,
                    pick_list_no_               => newrec_.pick_list_no,
                    shipment_id_                => newrec_.shipment_id,
                    lot_batch_no_               => newrec_.lot_batch_no,
                    serial_no_                  => newrec_.serial_no,
                    eng_chg_level_              => newrec_.eng_chg_level,
                    waiv_dev_rej_no_            => newrec_.waiv_dev_rej_no,
                    quantity_                   => newrec_.quantity,
                    activity_seq_               => newrec_.activity_seq,
                    handling_unit_id_           => newrec_.handling_unit_id,
                    allow_deviating_avail_ctrl_ => allow_deviating_avail_ctrl_,
                    check_storage_requirements_ => local_check_storage_reqrmnts_,
                    checking_forward_transport_ => TRUE,
                    reserved_by_source_db_      => newrec_.reserved_by_source);
      -- If a forward to location exist, use forward to location as to location when validating part availability control change
      to_availability_control_id_   := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_          => newrec_.to_contract, 
                                                                                               part_no_           => newrec_.part_no, 
                                                                                               configuration_id_  => newrec_.configuration_id, 
                                                                                               location_no_       => newrec_.forward_to_location_no, 
                                                                                               lot_batch_no_      => newrec_.lot_batch_no, 
                                                                                               serial_no_         => newrec_.serial_no, 
                                                                                               eng_chg_level_     => newrec_.eng_chg_level, 
                                                                                               waiv_dev_rej_no_   => newrec_.waiv_dev_rej_no, 
                                                                                               activity_seq_      => newrec_.activity_seq,
                                                                                               handling_unit_id_  => newrec_.handling_unit_id);
      to_location_qty_onhand_       := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_           => newrec_.to_contract, 
                                                                                  part_no_            => newrec_.part_no, 
                                                                                  configuration_id_   => newrec_.configuration_id, 
                                                                                  location_no_        => newrec_.to_location_no, 
                                                                                  lot_batch_no_       => newrec_.lot_batch_no, 
                                                                                  serial_no_          => newrec_.serial_no, 
                                                                                  eng_chg_level_      => newrec_.eng_chg_level, 
                                                                                  waiv_dev_rej_no_    => newrec_.waiv_dev_rej_no, 
                                                                                  activity_seq_       => newrec_.activity_seq,
                                                                                  handling_unit_id_   => newrec_.handling_unit_id);
      Validate_Part_Avail_Ctrl_Info(from_availability_control_id_, to_availability_control_id_, to_location_qty_onhand_, allow_deviating_avail_ctrl_);
   ELSE
      to_stock_record_  := Inventory_Part_In_Stock_API.Get(contract_           => newrec_.to_contract, 
                                                           part_no_            => newrec_.part_no, 
                                                           configuration_id_   => newrec_.configuration_id, 
                                                           location_no_        => newrec_.to_location_no, 
                                                           lot_batch_no_       => newrec_.lot_batch_no, 
                                                           serial_no_          => newrec_.serial_no, 
                                                           eng_chg_level_      => newrec_.eng_chg_level, 
                                                           waiv_dev_rej_no_    => newrec_.waiv_dev_rej_no, 
                                                           activity_seq_       => newrec_.activity_seq,
                                                           handling_unit_id_   => newrec_.handling_unit_id);
                                                           
      to_availability_control_id_ := to_stock_record_.availability_control_id;
      to_location_qty_onhand_     := to_stock_record_.qty_onhand;
                                                                                        
      Validate_Part_Avail_Ctrl_Info(from_availability_control_id_, to_availability_control_id_, to_location_qty_onhand_, allow_deviating_avail_ctrl_);
   END IF;
   
   IF (check_and_insert_) THEN
      -- We need to lock the Transport Task while checking for consistency between lines regarding from_contract,
      -- from locaton_group and to_contract. This is in order to prevent other sessions from simultaneously adding
      -- other lines while we are doing the check. We only lock if the check is followed by an actual insert since
      -- that mean that we have problem transaction handling that will release the lock in case there is an error.

      Transport_Task_API.Lock_By_Keys_Wait(newrec_.transport_task_id);
   END IF;

   Check_Receipt_Issue_Tracked___(newrec_.transport_task_id,
                                  newrec_.from_contract,
                                  newrec_.to_contract,
                                  newrec_.part_no,
                                  newrec_.serial_no);

   Check_Sites_And_Loc_Group___(newrec_.transport_task_id,
                                newrec_.from_contract,
                                newrec_.from_location_no,
                                newrec_.to_contract);

   existing_line_no_ := Get_Existing_Line_No___(transport_task_id_      => newrec_.transport_task_id,
                                                exclude_line_no_        => NULL,
                                                from_contract_          => newrec_.from_contract,
                                                from_location_no_       => newrec_.from_location_no,
                                                part_no_                => newrec_.part_no,
                                                configuration_id_       => newrec_.configuration_id,
                                                lot_batch_no_           => newrec_.lot_batch_no,
                                                serial_no_              => newrec_.serial_no,
                                                eng_chg_level_          => newrec_.eng_chg_level,
                                                waiv_dev_rej_no_        => newrec_.waiv_dev_rej_no,
                                                activity_seq_           => newrec_.activity_seq,
                                                handling_unit_id_       => newrec_.handling_unit_id,
                                                to_contract_            => newrec_.to_contract,
                                                to_location_no_         => newrec_.to_location_no,
                                                forward_to_location_no_ => newrec_.forward_to_location_no,
                                                destination_db_         => newrec_.destination,
                                                order_ref1_             => newrec_.order_ref1,
                                                order_ref2_             => newrec_.order_ref2,
                                                order_ref3_             => newrec_.order_ref3,
                                                order_ref4_             => newrec_.order_ref4,
                                                pick_list_no_           => newrec_.pick_list_no,
                                                shipment_id_            => newrec_.shipment_id,
                                                order_type_db_          => newrec_.order_type,
                                                reserved_by_source_db_  => newrec_.reserved_by_source);
                                                
   IF (existing_line_no_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DUPLICATELINE: There is already Line No :P1 with the exact same information. Change the quantity on that line instead.', existing_line_no_);
   END IF;
   
   Validate_Existing_Line_No___(newrec_.transport_task_id,
                                newrec_.line_no,
                                newrec_.from_contract,
                                newrec_.from_location_no,
                                newrec_.part_no,
                                newrec_.configuration_id,
                                newrec_.lot_batch_no,
                                newrec_.serial_no,
                                newrec_.eng_chg_level,
                                newrec_.waiv_dev_rej_no,
                                newrec_.activity_seq,
                                newrec_.handling_unit_id,
                                newrec_.to_contract,
                                newrec_.to_location_no,
                                newrec_.forward_to_location_no,
                                newrec_.destination,
                                newrec_.order_ref1,
                                newrec_.order_ref2,
                                newrec_.order_ref3,
                                newrec_.order_ref4,
                                newrec_.pick_list_no,
                                newrec_.shipment_id,
                                newrec_.order_type,
                                newrec_.reserved_by_source);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_                       IN     transport_task_line_tab%ROWTYPE,
   newrec_                       IN OUT transport_task_line_tab%ROWTYPE,
   indrec_                       IN OUT Indicator_Rec,
   attr_                         IN OUT VARCHAR2,
   check_duplicate_reservations_ IN     BOOLEAN DEFAULT FALSE )
IS
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(4000);  
   updated_by_client_            BOOLEAN := FALSE;
   check_and_update_             BOOLEAN := TRUE;
   client_action_                VARCHAR2(5);  
   from_availability_control_id_ VARCHAR2(25);
   to_availability_control_id_   VARCHAR2(25);
   to_location_qty_onhand_       NUMBER;
   allow_deviating_avail_ctrl_   BOOLEAN;
   locations_changed_            BOOLEAN;
   local_destination_db_         TRANSPORT_TASK_LINE_TAB.destination%TYPE;   
   from_stock_record_            Inventory_Part_In_Stock_API.Public_Rec;
   to_stock_record_              Inventory_Part_In_Stock_API.Public_Rec;
   
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);
    
   client_action_ := Client_SYS.Get_Item_Value('CLIENT_ACTION', attr_);
   IF client_action_ IS NOT NULL THEN
      IF client_action_ = 'CHECK'   THEN 
         updated_by_client_ := TRUE;  
         check_and_update_  := FALSE;
      ELSIF client_action_ = 'DO'  THEN
         updated_by_client_ := TRUE;  
         check_and_update_  := TRUE;
      END IF;    
   END IF;
      
   Check_Update_Move_Reserved___(newrec_, oldrec_);

   IF (oldrec_.transport_task_status = Transport_Task_Status_API.db_executed) THEN
      Error_SYS.Record_General(lu_name_, 'TASKEXECUTEDUPDATE: Line :P1 on the Transport Task :P2 cannot be modified since the Transport Task Line is executed.', newrec_.line_no, newrec_.transport_task_id);
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.transport_task_status, newrec_.transport_task_status)) THEN
      -- No other attributes can be updated while changing the status of the transport task line
      IF (Validate_SYS.Is_Changed(oldrec_.destination,      newrec_.destination)    OR 
          Validate_SYS.Is_Changed(oldrec_.to_contract,      newrec_.to_contract)    OR 
          Validate_SYS.Is_Changed(oldrec_.to_location_no,   newrec_.to_location_no) OR 
          Validate_SYS.Is_Changed(oldrec_.quantity,         newrec_.quantity)       OR 
          Validate_SYS.Is_Changed(oldrec_.catch_quantity,   newrec_.catch_quantity)) THEN
         Error_SYS.Record_General(lu_name_, 'ONLYSTATUSUPD: No other attributes can be updated while changing the status of Line :P1 of Transport Task :P2', newrec_.line_no, newrec_.transport_task_id);
      END IF;
   END IF;
   
   IF (Validate_SYS.Is_Changed(oldrec_.destination, newrec_.destination)) THEN
      IF (Transport_Task_API.Get_Printed_Flag(newrec_.transport_task_id) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'DESTUPDATEWHENPRINT: Destination is not allowed to be changed when the Transport Task :P1 is printed.', newrec_.transport_task_id);
      END IF;
   END IF;
         
   -- Override allow_deviating_avail_ctrl if it is set to false on site level.
   IF (Site_Invent_Info_API.Get_Allow_Deviating_Avail_C_Db(newrec_.to_contract) = Fnd_Boolean_API.DB_FALSE) THEN 
      newrec_.allow_deviating_avail_ctrl := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   IF (newrec_.quantity > oldrec_.quantity) THEN
      IF (updated_by_client_) THEN
         -- Qty can be updated from the client for lines that are in status Created
         IF (newrec_.transport_task_status != Transport_Task_Status_API.DB_CREATED) THEN
            Error_SYS.Record_General(lu_name_, 'INCRQTYNOTCREATED: The quantity on Transport Task Line :P1 cannot be increased since it is not in status :P2.', newrec_.line_no, Transport_Task_Status_API.Decode(Transport_Task_Status_API.DB_CREATED));
         END IF;
      ELSE
         -- Qty cannot be updated from server (i.e. putaway) when the transport task has lines that are picked and/or executed.
         IF (Transport_Task_API.Has_Picked_Or_Executed_Line(newrec_.transport_task_id)) THEN
            Error_SYS.Record_General(lu_name_, 'INCRQTYSTARTEDTT: The quantity on Transport Task :P1 cannot be increased since it has at least one line in status :P2 or :P3.', newrec_.transport_task_id, Transport_Task_Status_API.Decode(Transport_Task_Status_API.DB_PICKED), Transport_Task_Status_API.Decode(Transport_Task_Status_API.DB_EXECUTED));
         END IF;
      END IF;
      IF Transport_Task_Manager_API.Warehouse_Task_Is_Started_(oldrec_.transport_task_id) THEN
         Error_SYS.Record_General(lu_name_, 'WTASKSTARTEDUPDATE: The quantity can not be increased on line :P1 on the Transport Task :P2 since the Warehouse Task connected to it is started or parked.', newrec_.line_no, newrec_.transport_task_id);
      END IF;
   END IF;
   
   IF updated_by_client_ THEN
      IF ((newrec_.order_ref1 IS NOT NULL) AND (newrec_.quantity > oldrec_.quantity)) THEN
          Error_SYS.Record_General(lu_name_,'ORDERREFQTY: Quantity can not be increased because the Transport Task is connected to :P1 :P2.', Order_Type_API.Decode(newrec_.order_type), newrec_.order_ref1||' '||newrec_.order_ref2||' '||newrec_.order_ref3||' '||newrec_.order_ref4);
      END IF;
   END IF;
   
   from_stock_record_ := Inventory_Part_In_Stock_API.Get(contract_         => newrec_.from_contract, 
                                                         part_no_          => newrec_.part_no,
                                                         configuration_id_ => newrec_.configuration_id, 
                                                         location_no_      => newrec_.from_location_no,
                                                         lot_batch_no_     => newrec_.lot_batch_no, 
                                                         serial_no_        => newrec_.serial_no,
                                                         eng_chg_level_    => newrec_.eng_chg_level, 
                                                         waiv_dev_rej_no_  => newrec_.waiv_dev_rej_no,
                                                         activity_seq_     => newrec_.activity_seq,
                                                         handling_unit_id_ => newrec_.handling_unit_id);
   
   IF (newrec_.quantity = from_stock_record_.qty_onhand) THEN
      newrec_.catch_quantity := NULL;
   END IF;
      
   IF (Validate_SYS.Is_Different(oldrec_.to_contract, newrec_.to_contract)) THEN
      Check_Project_Site___(newrec_.project_id,
                            newrec_.from_contract,
                            newrec_.to_contract);

      IF (check_and_update_) THEN
         -- We need to lock the Transport Task while checking for consistency between lines regarding from_contract,
         -- from locaton_group and to_contract. This is in order to prevent other sessions from simultaneously adding
         -- other lines while we are doing the check. We only lock if the check is followed by an actual update since
         -- that mean that we have problem transaction handling that will release the lock in case there is an error.
         Transport_Task_API.Lock_By_Keys_Wait(newrec_.transport_task_id);
      END IF;

      Check_Receipt_Issue_Tracked___(newrec_.transport_task_id,
                                     newrec_.from_contract,
                                     newrec_.to_contract,
                                     newrec_.part_no,
                                     newrec_.serial_no);

      IF (Count_Lines(newrec_.transport_task_id) > 1) THEN
         -- IF this is not the only line on the task then we need to be sure to preserve the rule
         -- that says that one task must onlu contain records having the same from_contract,
         -- to_contract and from_location_no.
         Check_Sites_And_Loc_Group___(newrec_.transport_task_id,
                                      newrec_.from_contract,
                                      newrec_.from_location_no,
                                      newrec_.to_contract);
      END IF;
   END IF;

   locations_changed_ := ((newrec_.to_contract    != oldrec_.to_contract   ) OR
                          (newrec_.to_location_no != oldrec_.to_location_no) OR
                          (NVL(newrec_.forward_to_location_no, string_null_) != NVL(oldrec_.forward_to_location_no, string_null_)));
   IF ((locations_changed_                        ) OR
       (newrec_.quantity    != oldrec_.quantity   ) OR
       (newrec_.destination != oldrec_.destination)) THEN
      -- Check that the updated line doesn't end up exactly as an existing line.
      Validate_Existing_Line_No___(transport_task_id_      => newrec_.transport_task_id,
                                   exclude_line_no_        => newrec_.line_no,
                                   from_contract_          => newrec_.from_contract,
                                   from_location_no_       => newrec_.from_location_no,
                                   part_no_                => newrec_.part_no,
                                   configuration_id_       => newrec_.configuration_id,
                                   lot_batch_no_           => newrec_.lot_batch_no,
                                   serial_no_              => newrec_.serial_no,
                                   eng_chg_level_          => newrec_.eng_chg_level,
                                   waiv_dev_rej_no_        => newrec_.waiv_dev_rej_no,
                                   activity_seq_           => newrec_.activity_seq,
                                   handling_unit_id_       => newrec_.handling_unit_id,
                                   to_contract_            => newrec_.to_contract,
                                   to_location_no_         => newrec_.to_location_no,
                                   forward_to_location_no_ => newrec_.forward_to_location_no,
                                   destination_db_         => newrec_.destination,
                                   order_ref1_             => newrec_.order_ref1,
                                   order_ref2_             => newrec_.order_ref2,
                                   order_ref3_             => newrec_.order_ref3,
                                   order_ref4_             => newrec_.order_ref4,
                                   pick_list_no_           => newrec_.pick_list_no,
                                   shipment_id_            => newrec_.shipment_id,
                                   order_type_db_          => newrec_.order_type,
                                   reserved_by_source_db_  => newrec_.reserved_by_source);
      allow_deviating_avail_ctrl_   := CASE newrec_.allow_deviating_avail_ctrl WHEN Fnd_Boolean_API.DB_TRUE THEN TRUE WHEN Fnd_Boolean_API.DB_FALSE THEN FALSE END;
      from_availability_control_id_ := from_stock_record_.availability_control_id;
      IF (newrec_.forward_to_location_no IS NULL) THEN
         local_destination_db_ := newrec_.destination;
      ELSE
         -- If forward_to_location has a value then we will always use 'Move to inventory' as a destination because
         -- we want to immediately create a second transport task and this cannot be done for Qty In Transit.
         -- The actual destination will be forwarded to the next transport task line that will be created when this one
         -- gets executed.
         local_destination_db_ := Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY;
      END IF;

      Check_Insert_(from_contract_                 => newrec_.from_contract,
                    from_location_no_              => newrec_.from_location_no,
                    part_no_                       => newrec_.part_no,
                    configuration_id_              => newrec_.configuration_id,
                    to_contract_                   => newrec_.to_contract,
                    to_location_no_                => newrec_.to_location_no,
                    destination_                   => local_destination_db_,
                    order_type_                    => newrec_.order_type,
                    order_ref1_                    => newrec_.order_ref1,
                    order_ref2_                    => newrec_.order_ref2,
                    order_ref3_                    => newrec_.order_ref3,
                    order_ref4_                    => newrec_.order_ref4,
                    pick_list_no_                  => newrec_.pick_list_no,
                    shipment_id_                   => newrec_.shipment_id,                   
                    lot_batch_no_                  => newrec_.lot_batch_no,
                    serial_no_                     => newrec_.serial_no,
                    eng_chg_level_                 => newrec_.eng_chg_level,
                    waiv_dev_rej_no_               => newrec_.waiv_dev_rej_no,
                    activity_seq_                  => newrec_.activity_seq,
                    handling_unit_id_              => newrec_.handling_unit_id,
                    quantity_                      => newrec_.quantity,
                    allow_deviating_avail_ctrl_    => allow_deviating_avail_ctrl_ ,
                    check_storage_requirements_    => FALSE,
                    checking_forward_transport_    => FALSE,
                    check_duplicate_reservations_  => check_duplicate_reservations_,
                    reserved_by_source_db_         => newrec_.reserved_by_source);
                                            
      IF (newrec_.forward_to_location_no IS NOT NULL) THEN
         -- NOTE: Extra check to make sure that to and forward to location is not the same.
         Check_Duplicate_Location_Use(from_contract_    => newrec_.to_contract,
                                      from_location_no_ => newrec_.to_location_no,
                                      to_contract_      => newrec_.to_contract,
                                      to_location_no_   => newrec_.forward_to_location_no);
         
         Check_Insert_(from_contract_                 => newrec_.from_contract,
                       from_location_no_              => newrec_.from_location_no,
                       part_no_                       => newrec_.part_no,
                       configuration_id_              => newrec_.configuration_id,
                       to_contract_                   => newrec_.to_contract,
                       to_location_no_                => newrec_.forward_to_location_no,
                       destination_                   => newrec_.destination,
                       order_type_                    => newrec_.order_type,
                       order_ref1_                    => newrec_.order_ref1,
                       order_ref2_                    => newrec_.order_ref2,
                       order_ref3_                    => newrec_.order_ref3,
                       order_ref4_                    => newrec_.order_ref4,
                       pick_list_no_                  => newrec_.pick_list_no,
                       shipment_id_                   => newrec_.shipment_id,                       
                       lot_batch_no_                  => newrec_.lot_batch_no,
                       serial_no_                     => newrec_.serial_no,
                       eng_chg_level_                 => newrec_.eng_chg_level,
                       waiv_dev_rej_no_               => newrec_.waiv_dev_rej_no,
                       activity_seq_                  => newrec_.activity_seq,
                       handling_unit_id_              => newrec_.handling_unit_id,
                       quantity_                      => newrec_.quantity,
                       allow_deviating_avail_ctrl_    => allow_deviating_avail_ctrl_ ,
                       check_storage_requirements_    => FALSE,
                       checking_forward_transport_    => TRUE,
                       check_duplicate_reservations_  => check_duplicate_reservations_,
                       reserved_by_source_db_         => newrec_.reserved_by_source);
         IF (locations_changed_) THEN
            -- If a forward to location exist, use forward to location as to location when validating part availability control change
            to_availability_control_id_   := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_          => newrec_.to_contract, 
                                                                                                     part_no_           => newrec_.part_no, 
                                                                                                     configuration_id_  => newrec_.configuration_id, 
                                                                                                     location_no_       => newrec_.forward_to_location_no, 
                                                                                                     lot_batch_no_      => newrec_.lot_batch_no, 
                                                                                                     serial_no_         => newrec_.serial_no, 
                                                                                                     eng_chg_level_     => newrec_.eng_chg_level, 
                                                                                                     waiv_dev_rej_no_   => newrec_.waiv_dev_rej_no, 
                                                                                                     activity_seq_      => newrec_.activity_seq,
                                                                                                     handling_unit_id_  => newrec_.handling_unit_id);
            to_location_qty_onhand_       := Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_           => newrec_.to_contract, 
                                                                                        part_no_            => newrec_.part_no, 
                                                                                        configuration_id_   => newrec_.configuration_id, 
                                                                                        location_no_        => newrec_.to_location_no, 
                                                                                        lot_batch_no_       => newrec_.lot_batch_no, 
                                                                                        serial_no_          => newrec_.serial_no, 
                                                                                        eng_chg_level_      => newrec_.eng_chg_level, 
                                                                                        waiv_dev_rej_no_    => newrec_.waiv_dev_rej_no, 
                                                                                        activity_seq_       => newrec_.activity_seq,
                                                                                        handling_unit_id_   => newrec_.handling_unit_id);
            Validate_Part_Avail_Ctrl_Info(from_availability_control_id_, to_availability_control_id_, to_location_qty_onhand_, allow_deviating_avail_ctrl_);
         END IF;
      ELSE
         IF (locations_changed_) THEN
            to_stock_record_ := Inventory_Part_In_Stock_API.Get(contract_           => newrec_.to_contract, 
                                                                part_no_            => newrec_.part_no, 
                                                                configuration_id_   => newrec_.configuration_id, 
                                                                location_no_        => newrec_.to_location_no, 
                                                                lot_batch_no_       => newrec_.lot_batch_no, 
                                                                serial_no_          => newrec_.serial_no, 
                                                                eng_chg_level_      => newrec_.eng_chg_level, 
                                                                waiv_dev_rej_no_    => newrec_.waiv_dev_rej_no, 
                                                                activity_seq_       => newrec_.activity_seq,
                                                                handling_unit_id_   => newrec_.handling_unit_id);
            to_availability_control_id_   := to_stock_record_.availability_control_id; 
            to_location_qty_onhand_       := to_stock_record_.qty_onhand;
            Validate_Part_Avail_Ctrl_Info(from_availability_control_id_, to_availability_control_id_, to_location_qty_onhand_, allow_deviating_avail_ctrl_);
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

PROCEDURE Check_Update_Move_Reserved___ (
   newrec_ IN TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   oldrec_ IN TRANSPORT_TASK_LINE_TAB%ROWTYPE)
IS
   qty_reserved_ NUMBER := 0;
BEGIN
   IF (oldrec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE) THEN
      qty_reserved_ := Inv_Part_Stock_Reservation_API.Get_Qty_Reserved(order_no_                    => oldrec_.order_ref1,
                                                                       line_no_                     => oldrec_.order_ref2,
                                                                       release_no_                  => oldrec_.order_ref3,
                                                                       line_item_no_                => oldrec_.order_ref4,
                                                                       pick_list_no_                => oldrec_.pick_list_no,
                                                                       shipment_id_                 => oldrec_.shipment_id,                                                                                                                                                   
                                                                       order_supply_demand_type_db_ => Order_Type_API.Get_Order_Suppl_Demand_Type_Db(oldrec_.order_type),
                                                                       contract_                    => oldrec_.from_contract, 
                                                                       part_no_                     => oldrec_.part_no,
                                                                       configuration_id_            => oldrec_.configuration_id,
                                                                       location_no_                 => oldrec_.from_location_no,
                                                                       lot_batch_no_                => oldrec_.lot_batch_no,
                                                                       serial_no_                   => oldrec_.serial_no,
                                                                       eng_chg_level_               => oldrec_.eng_chg_level,
                                                                       waiv_dev_rej_no_             => oldrec_.waiv_dev_rej_no,
                                                                       activity_seq_                => oldrec_.activity_seq,
                                                                       handling_unit_id_            => oldrec_.handling_unit_id);
   END IF;
                                                                                                                         
   IF (qty_reserved_ > 0) THEN
      -- If a reservation exist, the following attributes isn't updateable.
      IF (oldrec_.from_contract      != newrec_.from_contract    OR
          oldrec_.from_location_no   != newrec_.from_location_no OR
          oldrec_.part_no            != newrec_.part_no          OR
          oldrec_.configuration_id   != newrec_.configuration_id OR
          oldrec_.lot_batch_no       != newrec_.lot_batch_no     OR
          oldrec_.serial_no          != newrec_.serial_no        OR 
          oldrec_.eng_chg_level      != newrec_.eng_chg_level    OR
          oldrec_.waiv_dev_rej_no    != newrec_.waiv_dev_rej_no  OR
          oldrec_.activity_seq       != newrec_.activity_seq     OR
          oldrec_.handling_unit_id   != newrec_.handling_unit_id OR
          oldrec_.destination        != newrec_.destination      OR
          oldrec_.order_ref1         != newrec_.order_ref1       OR
          oldrec_.order_ref2         != newrec_.order_ref2       OR
          oldrec_.order_ref3         != newrec_.order_ref3       OR
          oldrec_.order_ref4         != newrec_.order_ref4       OR
          oldrec_.pick_list_no       != newrec_.pick_list_no     OR
          oldrec_.shipment_id        != newrec_.shipment_id      OR
          oldrec_.reserved_by_source != newrec_.reserved_by_source ) THEN
         Error_SYS.Record_General(lu_name_, 'RESERVEDUPDATENOTALLOWED: When moving reserved material, it is only allowed to update the to and forward to location.');
      END IF;
   END IF;
END Check_Update_Move_Reserved___;

PROCEDURE Add_Destination_Info___ (
   newrec_ IN TRANSPORT_TASK_LINE_TAB%ROWTYPE )
IS
BEGIN
   IF ((newrec_.forward_to_location_no IS NOT NULL) AND (newrec_.destination = Inventory_Part_Destination_API.DB_MOVE_TO_TRANSIT)) THEN
      Client_Sys.Add_Info(lu_name_, 'FORWARDTOTRANSIT: Destination '':P1'' on line :P2 will only be applied for Location No :P3.', Inventory_Part_Destination_API.Decode(newrec_.destination), newrec_.line_no, newrec_.forward_to_location_no);
   END IF;
END Add_Destination_Info___;

PROCEDURE Apply_Drop_Off_Location___ (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER )
IS
   current_line_oldrec_  transport_task_line_tab%ROWTYPE;
   current_line_newrec_  transport_task_line_tab%ROWTYPE;
   matching_line_oldrec_ transport_task_line_tab%ROWTYPE;
   matching_line_newrec_ transport_task_line_tab%ROWTYPE;
   oldrec_               transport_task_line_tab%ROWTYPE;
   newrec_               transport_task_line_tab%ROWTYPE;
   attr_                 VARCHAR2 (2000);
   matching_line_no_     NUMBER;   
BEGIN
   current_line_oldrec_ := Lock_By_Keys___(transport_task_id_, line_no_);
   current_line_newrec_ := current_line_oldrec_;
   
   Transport_Task_Manager_API.Set_Transport_Locations(forward_to_location_no_ => current_line_newrec_.forward_to_location_no,
                                                      to_location_no_         => current_line_newrec_.to_location_no,
                                                      from_contract_          => current_line_newrec_.from_contract,
                                                      from_location_no_       => current_line_newrec_.from_location_no,
                                                      to_contract_            => current_line_newrec_.to_contract,
                                                      part_no_                => current_line_newrec_.part_no,
                                                      configuration_id_       => current_line_newrec_.configuration_id,
                                                      order_type_             => current_line_newrec_.order_type,
                                                      order_ref1_             => current_line_newrec_.order_ref1,
                                                      order_ref2_             => current_line_newrec_.order_ref2,
                                                      order_ref3_             => current_line_newrec_.order_ref3,
                                                      order_ref4_             => current_line_newrec_.order_ref4,
                                                      pick_list_no_           => current_line_newrec_.pick_list_no,
                                                      shipment_id_            => current_line_newrec_.shipment_id,
                                                      lot_batch_no_           => current_line_newrec_.lot_batch_no,
                                                      serial_no_              => current_line_newrec_.serial_no,
                                                      eng_chg_level_          => current_line_newrec_.eng_chg_level,
                                                      waiv_dev_rej_no_        => current_line_newrec_.waiv_dev_rej_no,
                                                      activity_seq_           => current_line_newrec_.activity_seq,
                                                      handling_unit_id_       => current_line_newrec_.handling_unit_id,
                                                      quantity_               => current_line_newrec_.quantity,
                                                      allways_use_drop_off_   => TRUE,
                                                      reserved_by_source_db_  => current_line_newrec_.reserved_by_source);
   IF (NVL(current_line_newrec_.forward_to_location_no, string_null_) != NVL(current_line_oldrec_.forward_to_location_no, string_null_)) THEN
      -- Before applying Forward-to location, try matching our current line with already existing one
      matching_line_no_ := Get_Existing_Line_No___(transport_task_id_      => current_line_newrec_.transport_task_id,
                                                   exclude_line_no_        => NULL,
                                                   from_contract_          => current_line_newrec_.from_contract,
                                                   from_location_no_       => current_line_newrec_.from_location_no,
                                                   part_no_                => current_line_newrec_.part_no,
                                                   configuration_id_       => current_line_newrec_.configuration_id,
                                                   lot_batch_no_           => current_line_newrec_.lot_batch_no,
                                                   serial_no_              => current_line_newrec_.serial_no,
                                                   eng_chg_level_          => current_line_newrec_.eng_chg_level,
                                                   waiv_dev_rej_no_        => current_line_newrec_.waiv_dev_rej_no,
                                                   activity_seq_           => current_line_newrec_.activity_seq,
                                                   handling_unit_id_       => current_line_newrec_.handling_unit_id,
                                                   to_contract_            => current_line_newrec_.to_contract,
                                                   to_location_no_         => current_line_newrec_.to_location_no,
                                                   forward_to_location_no_ => current_line_newrec_.forward_to_location_no,
                                                   destination_db_         => current_line_newrec_.destination,
                                                   order_ref1_             => current_line_newrec_.order_ref1,
                                                   order_ref2_             => current_line_newrec_.order_ref2,
                                                   order_ref3_             => current_line_newrec_.order_ref3,
                                                   order_ref4_             => current_line_newrec_.order_ref4,
                                                   pick_list_no_           => current_line_newrec_.pick_list_no,
                                                   shipment_id_            => current_line_newrec_.shipment_id,
                                                   order_type_db_          => current_line_newrec_.order_type,
                                                   reserved_by_source_db_  => current_line_newrec_.reserved_by_source);
      IF (matching_line_no_ IS NOT NULL) THEN
         -- A matching line found, move quantity from our current line to the matching line and remove current line
         matching_line_oldrec_          := Lock_By_Keys___(transport_task_id_, matching_line_no_);
         matching_line_newrec_          := matching_line_oldrec_;
         matching_line_newrec_.quantity := matching_line_oldrec_.quantity + current_line_newrec_.quantity;
         Client_Sys.Add_Info(lu_name_, 'TRANSPORTASKLINECONSOLIDATED: Line No :P1 is a duplicate of Line No :P2. Adding quantity to Line No :P2.', current_line_oldrec_.line_no, matching_line_oldrec_.line_no);
         Check_And_Delete___(remrec_ => current_line_oldrec_);
         oldrec_ := matching_line_oldrec_;
         newrec_ := matching_line_newrec_;
      ELSE
         -- No matching line could be found, it is ok to apply Forward-to location
         Client_SYS.Add_To_Attr('CLIENT_ACTION', 'DO', attr_);
         oldrec_ := current_line_oldrec_;
         newrec_ := current_line_newrec_;
      END IF;
      Check_And_Update___(newrec_               => newrec_,
                          oldrec_               => oldrec_,
                          no_drop_off_location_ => TRUE,
                          attr_                 => attr_);
   ELSE
      Client_Sys.Add_Info(lu_name_, 'DROPOFFNOTFOUND: No valid Drop-Off Location found.');
   END IF;
END Apply_Drop_Off_Location___;

PROCEDURE Revoke_Two_Step_Trans_Task___ (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER )
IS
   current_line_oldrec_  transport_task_line_tab%ROWTYPE;
   current_line_newrec_  transport_task_line_tab%ROWTYPE;
   matching_line_oldrec_ transport_task_line_tab%ROWTYPE;
   matching_line_newrec_ transport_task_line_tab%ROWTYPE;
   oldrec_               transport_task_line_tab%ROWTYPE;
   newrec_               transport_task_line_tab%ROWTYPE;
   matching_line_no_     NUMBER;   
BEGIN
   current_line_oldrec_ := Lock_By_Keys___(transport_task_id_, line_no_);
   current_line_newrec_ := current_line_oldrec_;
                                       
   IF (current_line_newrec_.forward_to_location_no IS NOT NULL) THEN
      -- See if we are getting a duplicate line if revoking Forward-to location, in that case remove duplicate and
      -- add quantity to already existing line
      matching_line_no_ := Get_Existing_Line_No___ (transport_task_id_      => current_line_newrec_.transport_task_id,
                                                    exclude_line_no_        => NULL,
                                                    from_contract_          => current_line_newrec_.from_contract,
                                                    from_location_no_       => current_line_newrec_.from_location_no,
                                                    part_no_                => current_line_newrec_.part_no,
                                                    configuration_id_       => current_line_newrec_.configuration_id,
                                                    lot_batch_no_           => current_line_newrec_.lot_batch_no,
                                                    serial_no_              => current_line_newrec_.serial_no,
                                                    eng_chg_level_          => current_line_newrec_.eng_chg_level,
                                                    waiv_dev_rej_no_        => current_line_newrec_.waiv_dev_rej_no,
                                                    activity_seq_           => current_line_newrec_.activity_seq,
                                                    handling_unit_id_       => current_line_newrec_.handling_unit_id,
                                                    to_contract_            => current_line_newrec_.to_contract,
                                                    to_location_no_         => current_line_newrec_.forward_to_location_no,
                                                    forward_to_location_no_ => '',
                                                    destination_db_         => current_line_newrec_.destination,
                                                    order_ref1_             => current_line_newrec_.order_ref1,
                                                    order_ref2_             => current_line_newrec_.order_ref2,
                                                    order_ref3_             => current_line_newrec_.order_ref3,
                                                    order_ref4_             => current_line_newrec_.order_ref4,
                                                    pick_list_no_           => current_line_newrec_.pick_list_no,
                                                    shipment_id_            => current_line_newrec_.shipment_id,
                                                    order_type_db_          => current_line_newrec_.order_type,
                                                    reserved_by_source_db_  => current_line_newrec_.reserved_by_source);
      IF (matching_line_no_ IS NOT NULL) THEN
         -- A matching line found, move quantity from our current line to the matching line and remove current line
         matching_line_oldrec_          := Lock_By_Keys___(transport_task_id_, matching_line_no_);
         matching_line_newrec_          := matching_line_oldrec_;
         matching_line_newrec_.quantity := matching_line_oldrec_.quantity + current_line_newrec_.quantity;
         Client_Sys.Add_Info(lu_name_, 'TRANSPORTASKLINECONSOLIDATED: Line No :P1 is a duplicate of Line No :P2. Adding quantity to Line No :P2.', current_line_oldrec_.line_no, matching_line_oldrec_.line_no);
         Check_And_Delete___(remrec_ => current_line_oldrec_);
         oldrec_ := matching_line_oldrec_;
         newrec_ := matching_line_newrec_; 
      ELSE
         -- No matching line could be found, it is ok to revoke Forward-to location
         current_line_newrec_.to_location_no         := current_line_oldrec_.forward_to_location_no;
         current_line_newrec_.forward_to_location_no := '';
         oldrec_ := current_line_oldrec_;
         newrec_ := current_line_newrec_;
      END IF;

      Check_And_Update___(newrec_ => newrec_, oldrec_ => oldrec_, no_drop_off_location_ => TRUE);
   END IF;
END Revoke_Two_Step_Trans_Task___;

PROCEDURE Move___ (
   from_transport_task_id_     IN NUMBER,
   line_no_                    IN NUMBER,
   to_transport_task_id_       IN NUMBER,
   allow_move_from_fixed_task_ IN BOOLEAN,
   allow_move_to_fixed_task_   IN BOOLEAN,
   set_from_task_as_fixed_     IN BOOLEAN,
   set_to_task_as_fixed_       IN BOOLEAN )
IS
   quantity_to_add_              NUMBER;
   catch_quantity_to_add_        NUMBER;
   quantity_added_               NUMBER;
   serials_to_add_               Part_Serial_Catalog_API.Serial_No_Tab;
   serials_added_                Part_Serial_Catalog_API.Serial_No_Tab;
   move_error_                   EXCEPTION;
   requested_date_finished_      DATE;
   warehouse_task_id_            NUMBER;
   warehouse_task_type_          VARCHAR2(2000);
   rec_                          TRANSPORT_TASK_LINE_TAB%ROWTYPE;
   local_to_transport_task_id_   NUMBER := to_transport_task_id_;
BEGIN
   rec_ := Lock_By_Keys___(from_transport_task_id_, line_no_);

   IF NOT (allow_move_from_fixed_task_) THEN
      IF (Transport_Task_API.Is_Fixed_Or_Started(from_transport_task_id_)) THEN
         Error_SYS.Record_General(lu_name_, 'FROMTASKFIXEDSTARTED: Lines cannot be moved from Transport Task :P1 since the Transport Task is Fixed or connected to a started Warehouse Task or has Picked or Executed lines.', from_transport_task_id_);
      END IF;
   END IF;
   
   IF (Transport_Task_API.Check_Exist(local_to_transport_task_id_)) THEN
      IF NOT (allow_move_to_fixed_task_) THEN
         IF (Transport_Task_API.Is_Fixed(local_to_transport_task_id_)) THEN
            Error_SYS.Record_General(lu_name_, 'TOTASKFIXED: Lines cannot be moved to Transport Task :P2 since the Transport Task is fixed.', from_transport_task_id_);
         END IF;
      END IF;
   ELSE
      Transport_Task_API.New(local_to_transport_task_id_);
   END IF;

   IF (rec_.serial_no = '*') THEN
      quantity_to_add_       := rec_.quantity;
      catch_quantity_to_add_ := rec_.catch_quantity;
   ELSE
      serials_to_add_(1).serial_no := rec_.serial_no;
      quantity_to_add_             := NULL;
      catch_quantity_to_add_       := NULL;
   END IF;

   warehouse_task_type_:= Warehouse_Task_Type_API.Decode(Warehouse_Task_Type_API.DB_TRANSPORT_TASK);
   warehouse_task_id_  := Warehouse_Task_API.Get_Task_Id_From_Source(rec_.from_contract,
                                                                     warehouse_task_type_,
                                                                     from_transport_task_id_,
                                                                     NULL,
                                                                     NULL,
                                                                     NULL);
   IF (warehouse_task_id_ IS NOT NULL) THEN
      requested_date_finished_ := Warehouse_Task_API.Get_Requested_Date_Finished(warehouse_task_id_);
   END IF;

   Remove(transport_task_id_  => from_transport_task_id_,
          line_no_            => line_no_); 

   New_Or_Add_To_Existing_(quantity_added_               => quantity_added_,
                           serials_added_                => serials_added_,
                           transport_task_id_            => local_to_transport_task_id_,
                           part_no_                      => rec_.part_no,
                           configuration_id_             => rec_.configuration_id,
                           from_contract_                => rec_.from_contract,
                           from_location_no_             => rec_.from_location_no,
                           to_contract_                  => rec_.to_contract,
                           to_location_no_               => rec_.to_location_no,
                           forward_to_location_no_       => rec_.forward_to_location_no,
                           destination_db_               => rec_.destination,
                           order_type_db_                => rec_.order_type,
                           order_ref1_                   => rec_.order_ref1,
                           order_ref2_                   => rec_.order_ref2,
                           order_ref3_                   => rec_.order_ref3,
                           order_ref4_                   => rec_.order_ref4,
                           pick_list_no_                 => rec_.pick_list_no,
                           shipment_id_                  => rec_.shipment_id,
                           lot_batch_no_                 => rec_.lot_batch_no,
                           serial_no_tab_                => serials_to_add_,
                           eng_chg_level_                => rec_.eng_chg_level,
                           waiv_dev_rej_no_              => rec_.waiv_dev_rej_no,
                           activity_seq_                 => rec_.activity_seq,
                           handling_unit_id_             => rec_.handling_unit_id,
                           quantity_to_add_              => quantity_to_add_,
                           catch_quantity_to_add_        => catch_quantity_to_add_,
                           requested_date_finished_      => requested_date_finished_,
                           allow_deviating_avail_ctrl_   => rec_.allow_deviating_avail_ctrl,
                           reserved_by_source_db_        => rec_.reserved_by_source );

   IF (rec_.serial_no = '*') THEN
      IF (quantity_added_ != quantity_to_add_) THEN
         RAISE move_error_;
      END IF;
   ELSE
      IF (serials_added_.COUNT = 1) THEN
         IF (serials_added_(1).serial_no != serials_to_add_(1).serial_no) THEN
            RAISE move_error_;
         END IF;
      ELSE
         RAISE move_error_;
      END IF;
   END IF;

   IF (set_from_task_as_fixed_) THEN
      -- from task might have been deleted as a result of deleting the from line.
      -- So we have to check if it still exists before attempting an update.
      IF (Transport_Task_API.Check_Exist(from_transport_task_id_)) THEN
         Transport_Task_API.Set_As_Fixed(from_transport_task_id_);
      END IF;
   END IF;

   IF (set_to_task_as_fixed_) THEN
      Transport_Task_API.Set_As_Fixed(local_to_transport_task_id_);
   END IF;
EXCEPTION
   WHEN move_error_ THEN
      Error_SYS.Record_General(lu_name_, 'MOVEQTY: Line :P1 of Transport Task :P2 cannot be moved to Transport Task :P3.', line_no_, from_transport_task_id_, to_transport_task_id_);
END Move___;

-------------------------------------------------------------------------------------------------------------------------------------
--  Replace_Reduced_Hu_Reservat___
--  When moving a handling unit having stock reservations using a transport Task, even if there is a need to unreserve parts from this handling unit,
--  it should still be possible to move the entire Handling Unit to the proposed location. In order to make this work, reduced quantity from the HU Reservation 
--  needs be added back to the Transport Task as unreserved stock. It will be added to the same stock location where it was earlier.
-------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE Replace_Reduced_Hu_Reservat___ (
   line_rec_             IN TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   quantity_             IN NUMBER,
   catch_quantity_       IN NUMBER )
IS
   quantity_to_add_         NUMBER;
   catch_quantity_to_add_   NUMBER;
   quantity_added_          NUMBER;
   serials_to_add_          Part_Serial_Catalog_API.Serial_No_Tab;
   serials_added_           Part_Serial_Catalog_API.Serial_No_Tab;
   
BEGIN 
   IF ((line_rec_.handling_unit_id != 0) AND 
      (line_rec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE)) THEN
      
      IF (line_rec_.serial_no = '*') THEN
         quantity_to_add_       := quantity_;
         catch_quantity_to_add_ := catch_quantity_;
      ELSE
         serials_to_add_(1).serial_no := line_rec_.serial_no;
         quantity_to_add_             := NULL;
         catch_quantity_to_add_       := NULL;
      END IF;

      New_Or_Add_To_Existing_ (quantity_added_             => quantity_added_,
                               serials_added_              => serials_added_,
                               transport_task_id_          => line_rec_.transport_task_id,
                               part_no_                    => line_rec_.part_no,
                               configuration_id_           => line_rec_.configuration_id,
                               from_contract_              => line_rec_.from_contract,
                               from_location_no_           => line_rec_.from_location_no,
                               to_contract_                => line_rec_.to_contract,
                               to_location_no_             => line_rec_.to_location_no,
                               forward_to_location_no_     => line_rec_.forward_to_location_no,
                               destination_db_             => line_rec_.destination,
                               order_type_db_              => NULL,
                               order_ref1_                 => NULL,
                               order_ref2_                 => NULL,
                               order_ref3_                 => NULL,
                               order_ref4_                 => NULL,
                               pick_list_no_               => NULL,
                               shipment_id_                => NULL,      
                               lot_batch_no_               => line_rec_.lot_batch_no,
                               serial_no_tab_              => serials_to_add_,
                               eng_chg_level_              => line_rec_.eng_chg_level,
                               waiv_dev_rej_no_            => line_rec_.waiv_dev_rej_no,
                               activity_seq_               => line_rec_.activity_seq,
                               handling_unit_id_           => line_rec_.handling_unit_id,
                               quantity_to_add_            => quantity_to_add_,
                               catch_quantity_to_add_      => catch_quantity_to_add_,
                               requested_date_finished_    => NULL,
                               allow_deviating_avail_ctrl_ => line_rec_.allow_deviating_avail_ctrl);
   END IF;   
END Replace_Reduced_Hu_Reservat___;


FUNCTION Destination_Is_Remote_Whse___ (
   to_contract_            IN VARCHAR2,
   to_location_no_         IN VARCHAR2,
   forward_to_location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   destination_is_remote_whse_ BOOLEAN := FALSE;
   warehouse_id_               VARCHAR2(15);
BEGIN
   -- Only investigating the final destination, so investigating forward_to_location_no if it has a value, otherwise to_location_no_.
   warehouse_id_               := Inventory_Location_API.Get_Warehouse(to_contract_, NVL(forward_to_location_no_,to_location_no_));
   destination_is_remote_whse_ := Warehouse_API.Get_Remote_Warehouse_Db(to_contract_, warehouse_id_) = Fnd_Boolean_API.DB_TRUE;

   RETURN(destination_is_remote_whse_);
END Destination_Is_Remote_Whse___;


FUNCTION Get_Sum_Removed_Tt_Line_Qty___ (
   stock_reservation_rec_ IN Inventory_Part_In_Stock_API.Keys_And_Qty_Rec,
   removed_rec_tab_       IN Public_Rec_Tab ) RETURN NUMBER 
IS
   sum_removed_tt_line_qty_ NUMBER := 0;
BEGIN
   FOR i IN removed_rec_tab_.FIRST..removed_rec_tab_.LAST LOOP
      IF ((removed_rec_tab_(i).from_contract    = stock_reservation_rec_.contract        ) AND
          (removed_rec_tab_(i).from_location_no = stock_reservation_rec_.location_no     ) AND
          (removed_rec_tab_(i).part_no          = stock_reservation_rec_.part_no         ) AND
          (removed_rec_tab_(i).configuration_id = stock_reservation_rec_.configuration_id) AND
          (removed_rec_tab_(i).lot_batch_no     = stock_reservation_rec_.lot_batch_no    ) AND
          (removed_rec_tab_(i).serial_no        = stock_reservation_rec_.serial_no       ) AND
          (removed_rec_tab_(i).eng_chg_level    = stock_reservation_rec_.eng_chg_level   ) AND
          (removed_rec_tab_(i).waiv_dev_rej_no  = stock_reservation_rec_.waiv_dev_rej_no ) AND
          (removed_rec_tab_(i).activity_seq     = stock_reservation_rec_.activity_seq    ) AND
          (removed_rec_tab_(i).handling_unit_id = stock_reservation_rec_.handling_unit_id)) THEN 
         sum_removed_tt_line_qty_ := sum_removed_tt_line_qty_ + removed_rec_tab_(i).quantity;
      END IF;
   END LOOP;      
   
   RETURN(sum_removed_tt_line_qty_);
END Get_Sum_Removed_Tt_Line_Qty___;

PROCEDURE Modify_Cust_Ord_Reservation___ (
   rec_                   IN TRANSPORT_TASK_LINE_TAB%ROWTYPE,
   on_transport_task_db_  IN VARCHAR2 )
IS
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      Customer_Order_Reservation_API.Modify_On_Transport_Task(order_no_             => rec_.order_ref1,
                                                              line_no_              => rec_.order_ref2,
                                                              rel_no_               => rec_.order_ref3,
                                                              line_item_no_         => rec_.order_ref4,
                                                              contract_             => rec_.from_contract, 
                                                              part_no_              => rec_.part_no,
                                                              location_no_          => rec_.from_location_no,
                                                              lot_batch_no_         => rec_.lot_batch_no,
                                                              serial_no_            => rec_.serial_no,
                                                              eng_chg_level_        => rec_.eng_chg_level,
                                                              waiv_dev_rej_no_      => rec_.waiv_dev_rej_no,
                                                              activity_seq_         => rec_.activity_seq,
                                                              handling_unit_id_     => rec_.handling_unit_id,
                                                              pick_list_no_         => rec_.pick_list_no,
                                                              configuration_id_     => rec_.configuration_id,
                                                              shipment_id_          => rec_.shipment_id,
                                                              on_transport_task_db_ => on_transport_task_db_);                                                              
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END  
   
END Modify_Cust_Ord_Reservation___;

PROCEDURE Raise_Location_Remove_Error___(
   contract_          IN VARCHAR2,
   location_no_       IN VARCHAR2,
   transport_task_id_ IN NUMBER )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'LOCNOTREMOVED: The inventory location :P1 of site :P2 is used in a not yet executed transport task line in transport task :P3, and cannot be deleted.', location_no_, contract_, transport_task_id_);
END Raise_Location_Remove_Error___;

PROCEDURE Raise_Location_Type_Error___ (
   location_type_db_ IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General('TransportTaskLine','INSNOFROMLOC: Locations of type :P1 can not be used on transport tasks.', Inventory_Location_Type_API.Decode(location_type_db_));
END Raise_Location_Type_Error___;


PROCEDURE Raise_Location_Frozen_Error___ (
   part_no_        IN VARCHAR2,
   to_contract_    IN VARCHAR2,
   to_location_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'TOFROZENINSERT: The Part :P1 on Site :P2 Location number :P3 is frozen for counting.', part_no_, to_contract_, to_location_no_);
END Raise_Location_Frozen_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('CLIENT_ACTION', action_, attr_); 
   super(info_, objid_, objversion_, attr_, action_);
   attr_ := Client_SYS.Remove_Attr('CLIENT_ACTION', attr_);   
END New__;

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('CLIENT_ACTION', action_, attr_); 
   super(info_, objid_, objversion_, attr_, action_);
   attr_ := Client_SYS.Remove_Attr('CLIENT_ACTION', attr_);
END Modify__;

@Override
PROCEDURE Remove__ (
   info_                 OUT    VARCHAR2,
   objid_                IN     VARCHAR2,
   objversion_           IN     VARCHAR2,
   action_               IN     VARCHAR2,
   remove_empty_task_db_ IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   remrec_ TRANSPORT_TASK_LINE_TAB%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Id___(objid_);  
   super(info_, objid_, objversion_, action_);
   IF (action_ = 'DO') AND (Fnd_Boolean_API.Evaluate_Db(remove_empty_task_db_)) THEN
      IF NOT (Lines_Exist(remrec_.transport_task_id)) THEN
         Transport_Task_API.Remove(remrec_.transport_task_id);
      END IF;
   END IF;
END Remove__;

PROCEDURE Check_Remove_From_Location__(
   from_contract_    IN VARCHAR2,
   from_location_no_ IN VARCHAR2)
IS
   transport_task_id_ transport_task_line_tab.transport_task_id%TYPE;
   
   CURSOR get_not_executed_task IS
      SELECT transport_task_id
      FROM transport_task_line_tab
      WHERE from_contract           = from_contract_
      AND   from_location_no        = from_location_no_ 
      AND   transport_task_status  != Transport_Task_Status_API.DB_EXECUTED;
BEGIN
   OPEN get_not_executed_task;
   FETCH get_not_executed_task INTO transport_task_id_;
   CLOSE get_not_executed_task;
   
   IF (transport_task_id_ IS NOT NULL) THEN
      Raise_Location_Remove_Error___(from_contract_, from_location_no_, transport_task_id_);
   END IF;
END Check_Remove_From_Location__;

PROCEDURE Check_Remove_To_Location__(
   to_contract_    IN VARCHAR2,
   to_location_no_ IN VARCHAR2)
IS
   transport_task_id_ transport_task_line_tab.transport_task_id%TYPE;
   
   CURSOR get_not_executed_task IS
      SELECT transport_task_id
      FROM transport_task_line_tab
      WHERE to_contract             = to_contract_
      AND   to_location_no          = to_location_no_ 
      AND   transport_task_status  != Transport_Task_Status_API.DB_EXECUTED;
BEGIN
   OPEN get_not_executed_task;
   FETCH get_not_executed_task INTO transport_task_id_;
   CLOSE get_not_executed_task;
   
   IF (transport_task_id_ IS NOT NULL) THEN
      Raise_Location_Remove_Error___(to_contract_, to_location_no_, transport_task_id_);
   END IF;
END Check_Remove_To_Location__;

PROCEDURE Check_Remove_Forword_To_Loc__(
   to_contract_            IN VARCHAR2,
   forward_to_location_no_ IN VARCHAR2)
IS
   transport_task_id_ transport_task_line_tab.transport_task_id%TYPE;
   
   CURSOR get_not_executed_task IS
      SELECT transport_task_id
      FROM transport_task_line_tab
      WHERE to_contract_            = to_contract
      AND   forward_to_location_no  = forward_to_location_no_
      AND   transport_task_status  != Transport_Task_Status_API.DB_EXECUTED;
BEGIN
   OPEN get_not_executed_task;
   FETCH get_not_executed_task INTO transport_task_id_;
   CLOSE get_not_executed_task;
   
   IF (transport_task_id_ IS NOT NULL) THEN
      Raise_Location_Remove_Error___(to_contract_, forward_to_location_no_, transport_task_id_);
   END IF;
END Check_Remove_Forword_To_Loc__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
-- Execute_
--   This method executes transport task lines.
PROCEDURE Execute_ (
   transport_task_id_            IN NUMBER,
   line_no_                      IN NUMBER,
   part_tracking_session_id_     IN NUMBER,
   validate_hu_struct_position_  IN BOOLEAN DEFAULT TRUE,
   forward_to_transport_task_id_ IN NUMBER  DEFAULT NULL )
IS
   oldrec_ transport_task_line_tab%ROWTYPE;
   newrec_ transport_task_line_tab%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(transport_task_id_, line_no_);
   newrec_ := oldrec_;
   newrec_.transport_task_status := Transport_Task_Status_API.DB_EXECUTED;
   Check_And_Update___(newrec_                       => newrec_, 
                       oldrec_                       => oldrec_, 
                       part_tracking_session_id_     => part_tracking_session_id_,
                       validate_hu_struct_position_  => validate_hu_struct_position_,
                       forward_to_transport_task_id_ => forward_to_transport_task_id_);
   Client_SYS.Clear_Info;
END Execute_;

PROCEDURE Pick_ (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER )
IS
   record_ transport_task_line_tab%ROWTYPE;
BEGIN
   record_ := Lock_By_Keys___(transport_task_id_, line_no_);
   record_.transport_task_status := Transport_Task_Status_API.DB_PICKED;
   Modify___(record_);
END Pick_;

PROCEDURE Unpick_ (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER)
IS
   record_ transport_task_line_tab%ROWTYPE;
BEGIN
   record_ := Lock_By_Keys___(transport_task_id_, line_no_);
   record_.transport_task_status := Transport_Task_Status_API.DB_CREATED;
   Modify___(record_);
END Unpick_;

-- New_Or_Add_To_Existing_
--   This method handles new requests for transportation on a transport task.
--   If necessary, it creates a new line on the task, else it adds the
--   transportation need to an existing line. The OUT parameter QuantityAdded
--   represents the quantity that has succesfully been added to the transport task.
PROCEDURE New_Or_Add_To_Existing_ (
   quantity_added_             OUT NUMBER,
   serials_added_              OUT Part_Serial_Catalog_API.Serial_No_Tab,
   transport_task_id_          IN  NUMBER,
   part_no_                    IN  VARCHAR2,
   configuration_id_           IN  VARCHAR2,
   from_contract_              IN  VARCHAR2,
   from_location_no_           IN  VARCHAR2,
   to_contract_                IN  VARCHAR2,
   to_location_no_             IN  VARCHAR2,
   forward_to_location_no_     IN  VARCHAR2,
   destination_db_             IN  VARCHAR2,
   order_type_db_              IN  VARCHAR2,
   order_ref1_                 IN  VARCHAR2,
   order_ref2_                 IN  VARCHAR2,
   order_ref3_                 IN  VARCHAR2,
   order_ref4_                 IN  VARCHAR2,
   pick_list_no_               IN  VARCHAR2,
   shipment_id_                IN  NUMBER,      
   lot_batch_no_               IN  VARCHAR2,
   serial_no_tab_              IN  Part_Serial_Catalog_API.Serial_No_Tab,
   eng_chg_level_              IN  VARCHAR2,
   waiv_dev_rej_no_            IN  VARCHAR2,
   activity_seq_               IN  NUMBER,
   handling_unit_id_           IN  NUMBER,
   quantity_to_add_            IN  NUMBER,
   catch_quantity_to_add_      IN  NUMBER,
   requested_date_finished_    IN  DATE,
   allow_deviating_avail_ctrl_ IN  VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   reserved_by_source_db_      IN  VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   check_storage_requirements_ IN  BOOLEAN  DEFAULT FALSE)
IS
   existing_line_no_            transport_task_line_tab.line_no%TYPE;
   oldrec_                      transport_task_line_tab%ROWTYPE;
   newrec_                      transport_task_line_tab%ROWTYPE;
   default_newrec_              transport_task_line_tab%ROWTYPE;
   local_serial_no_tab_         Part_Serial_Catalog_API.Serial_No_Tab;
   default_record_created_      BOOLEAN := FALSE;
   local_quantity_to_add_       NUMBER;
   local_catch_quantity_to_add_ NUMBER;
   rows_                        PLS_INTEGER := 1;
BEGIN
   IF (serial_no_tab_.COUNT = 0) THEN
      local_serial_no_tab_(1).serial_no := '*';
      local_quantity_to_add_            := quantity_to_add_;
      local_catch_quantity_to_add_      := catch_quantity_to_add_;
   ELSE
      IF (quantity_to_add_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'SERIALQTY: Quantity should not be defined for serials.');
      END IF;

      IF (catch_quantity_to_add_ IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'SERIALCATCHQTY: Catch Quantity should not be defined for serials.');
      END IF;

      local_serial_no_tab_   := serial_no_tab_;
      local_quantity_to_add_ := 1;
   END IF;
   
   quantity_added_ := 0;

   FOR i IN local_serial_no_tab_.FIRST..local_serial_no_tab_.LAST LOOP

      existing_line_no_ := Get_Existing_Line_No___(transport_task_id_      => transport_task_id_,
                                                   exclude_line_no_        => NULL,
                                                   from_contract_          => from_contract_,
                                                   from_location_no_       => from_location_no_,
                                                   part_no_                => part_no_,
                                                   configuration_id_       => configuration_id_,
                                                   lot_batch_no_           => lot_batch_no_,
                                                   serial_no_              => local_serial_no_tab_(i).serial_no,
                                                   eng_chg_level_          => eng_chg_level_,
                                                   waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                   activity_seq_           => activity_seq_,
                                                   handling_unit_id_       => handling_unit_id_,
                                                   to_contract_            => to_contract_,
                                                   to_location_no_         => to_location_no_,
                                                   forward_to_location_no_ => forward_to_location_no_,
                                                   destination_db_         => destination_db_,
                                                   order_ref1_             => order_ref1_,
                                                   order_ref2_             => order_ref2_,
                                                   order_ref3_             => order_ref3_,
                                                   order_ref4_             => order_ref4_,
                                                   pick_list_no_           => pick_list_no_,
                                                   shipment_id_            => shipment_id_,
                                                   order_type_db_          => order_type_db_,
                                                   reserved_by_source_db_  => reserved_by_source_db_ );
      IF (existing_line_no_ IS NULL) THEN
         -- Add a new line to the transport task
         IF (NOT default_record_created_) THEN
            default_newrec_.transport_task_id          := transport_task_id_;
            default_newrec_.from_contract              := from_contract_;
            default_newrec_.from_location_no           := from_location_no_;
            default_newrec_.part_no                    := part_no_;
            default_newrec_.configuration_id           := configuration_id_;
            default_newrec_.lot_batch_no               := lot_batch_no_;
            default_newrec_.eng_chg_level              := eng_chg_level_;
            default_newrec_.waiv_dev_rej_no            := waiv_dev_rej_no_;
            default_newrec_.activity_seq               := activity_seq_;
            default_newrec_.handling_unit_id           := handling_unit_id_;
            default_newrec_.quantity                   := local_quantity_to_add_;
            default_newrec_.catch_quantity             := local_catch_quantity_to_add_;
            default_newrec_.to_contract                := to_contract_;
            default_newrec_.to_location_no             := to_location_no_;
            default_newrec_.forward_to_location_no     := forward_to_location_no_;
            default_newrec_.destination                := destination_db_;
            default_newrec_.order_ref1                 := order_ref1_;
            default_newrec_.order_ref2                 := order_ref2_;
            default_newrec_.order_ref3                 := order_ref3_;
            default_newrec_.order_ref4                 := order_ref4_;
            default_newrec_.pick_list_no               := pick_list_no_;
            default_newrec_.shipment_id                := shipment_id_;         
            default_newrec_.order_type                 := order_type_db_;         
            default_newrec_.allow_deviating_avail_ctrl := allow_deviating_avail_ctrl_;
            default_newrec_.reserved_by_source         := reserved_by_source_db_;
            
            default_record_created_ := TRUE;
         END IF;

         newrec_           := default_newrec_;
         newrec_.serial_no := local_serial_no_tab_(i).serial_no;

         Check_And_Insert___(newrec_                     => newrec_,
                             check_storage_requirements_ => check_storage_requirements_,
                             requested_date_finished_    => requested_date_finished_);
   
         quantity_added_ := quantity_added_ + newrec_.quantity;
      ELSE
         -- Increase the quantity on the already existing line.
         oldrec_                := Lock_By_Keys___(transport_task_id_, existing_line_no_);
         newrec_                := oldrec_;
         newrec_.quantity       := local_quantity_to_add_       + oldrec_.quantity;
         newrec_.catch_quantity := local_catch_quantity_to_add_ + oldrec_.catch_quantity;

         Check_And_Update___(newrec_                       => newrec_,
                             oldrec_                       => oldrec_,
                             check_duplicate_reservations_ => TRUE,
                             check_storage_requirements_   => check_storage_requirements_);
   
         quantity_added_ := quantity_added_ + (newrec_.quantity - oldrec_.quantity);
      END IF;

      IF ((local_serial_no_tab_(i).serial_no != '*') AND (newrec_.quantity = 1)) THEN
         serials_added_(rows_) := local_serial_no_tab_(i);
         rows_ := rows_ + 1;
      END IF;
   END LOOP;
END New_Or_Add_To_Existing_;

-- Get_Qty_Inbound_
--   Returns the quantity on a specified Transport Task. Optionally other
--   parameters could be entered as well to narrow the search criteria.
@UncheckedAccess
FUNCTION Get_Qty_Inbound_ (
   part_no_           IN VARCHAR2,
   configuration_id_  IN VARCHAR2,
   to_contract_       IN VARCHAR2,
   to_location_no_    IN VARCHAR2,
   lot_batch_no_      IN VARCHAR2,
   serial_no_         IN VARCHAR2,
   eng_chg_level_     IN VARCHAR2,
   waiv_dev_rej_no_   IN VARCHAR2,
   activity_seq_      IN NUMBER,
   handling_unit_id_  IN NUMBER ) RETURN NUMBER
IS
   qty_inbound_ NUMBER;

   CURSOR get_qty_inbound_1 IS
      SELECT NVL(sum(quantity),0)
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE  part_no               = part_no_
         AND  configuration_id      = configuration_id_
         AND  to_contract           = to_contract_
         AND  to_location_no        = to_location_no_
         AND  transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND (eng_chg_level         = eng_chg_level_     OR eng_chg_level_    IS NULL)
         AND (serial_no             = serial_no_         OR serial_no_        IS NULL)
         AND (lot_batch_no          = lot_batch_no_      OR lot_batch_no_     IS NULL)
         AND (waiv_dev_rej_no       = waiv_dev_rej_no_   OR waiv_dev_rej_no_  IS NULL)
         AND (activity_seq          = activity_seq_      OR activity_seq_     IS NULL)
         AND (handling_unit_id      = handling_unit_id_  OR handling_unit_id_ IS NULL);

   CURSOR get_qty_inbound_2 IS
      SELECT NVL(sum(quantity),0)
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE  part_no               = part_no_
         AND  configuration_id      = configuration_id_
         AND  to_contract           = to_contract_
         AND  to_location_no        = to_location_no_
         AND  transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND  eng_chg_level         = eng_chg_level_
         AND  serial_no             = serial_no_
         AND  lot_batch_no          = lot_batch_no_
         AND  waiv_dev_rej_no       = waiv_dev_rej_no_
         AND (activity_seq          = activity_seq_      OR activity_seq_     IS NULL)
         AND (handling_unit_id      = handling_unit_id_  OR handling_unit_id_ IS NULL);
BEGIN
   IF ((lot_batch_no_     IS NULL) OR 
       (serial_no_        IS NULL) OR 
       (eng_chg_level_    IS NULL) OR 
       (waiv_dev_rej_no_  IS NULL)) THEN
      -- slower but more flexible
      OPEN  get_qty_inbound_1;
      FETCH get_qty_inbound_1 INTO qty_inbound_;
      CLOSE get_qty_inbound_1;
   ELSE
      -- For maximum performance
      OPEN  get_qty_inbound_2;
      FETCH get_qty_inbound_2 INTO qty_inbound_;
      CLOSE get_qty_inbound_2;
   END IF;

   RETURN qty_inbound_;
END Get_Qty_Inbound_;

-- Get_Qty_Outbound_
--   Returns the quantity on a specified Transport Task. Optionally other
--   parameters could be entered as well to narrow the search criteria.
@UncheckedAccess
FUNCTION Get_Qty_Outbound_ (
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   from_contract_           IN VARCHAR2,
   from_location_no_        IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   handling_unit_id_        IN NUMBER,
   order_ref1_              IN VARCHAR2,
   order_ref2_              IN VARCHAR2,
   order_ref3_              IN VARCHAR2,
   order_ref4_              IN NUMBER,
   pick_list_no_            IN VARCHAR2,
   shipment_id_             IN NUMBER,
   order_type_db_           IN VARCHAR2,
   reserved_by_source_db_   IN VARCHAR2,
   include_unpicked_lines_  IN BOOLEAN  ) RETURN NUMBER
IS
   qty_outbound_                 NUMBER;
   include_unpicked_lines_local_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR get_qty_outbound_1 IS
      SELECT NVL(sum(quantity),0)
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE  part_no                = part_no_
         AND  configuration_id       = configuration_id_
         AND  from_contract          = from_contract_
         AND  from_location_no       = from_location_no_
         AND ((transport_task_status = Transport_Task_Status_API.DB_PICKED) OR 
              (transport_task_status = Transport_Task_Status_API.DB_CREATED AND include_unpicked_lines_local_ = Fnd_Boolean_API.DB_TRUE))
         AND (eng_chg_level          = eng_chg_level_         OR eng_chg_level_         IS NULL)
         AND (serial_no              = serial_no_             OR serial_no_             IS NULL)
         AND (lot_batch_no           = lot_batch_no_          OR lot_batch_no_          IS NULL)
         AND (waiv_dev_rej_no        = waiv_dev_rej_no_       OR waiv_dev_rej_no_       IS NULL)
         AND (activity_seq           = activity_seq_          OR activity_seq_          IS NULL)
         AND (handling_unit_id       = handling_unit_id_      OR handling_unit_id_      IS NULL)
         AND (order_ref1             = order_ref1_            OR order_ref1_            IS NULL)
         AND (order_ref2             = order_ref2_            OR order_ref2_            IS NULL)
         AND (order_ref3             = order_ref3_            OR order_ref3_            IS NULL)
         AND (order_ref4             = order_ref4_            OR order_ref4_            IS NULL)
         AND (pick_list_no           = pick_list_no_          OR pick_list_no_          IS NULL)
         AND (shipment_id            = shipment_id_           OR shipment_id_           IS NULL)
         AND (order_type             = order_type_db_         OR order_type_db_         IS NULL)
         AND (reserved_by_source     = reserved_by_source_db_ OR reserved_by_source_db_ IS NULL);

   CURSOR get_qty_outbound_2 IS
      SELECT NVL(sum(quantity),0)
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE  part_no                = part_no_
         AND  configuration_id       = configuration_id_
         AND  from_contract          = from_contract_
         AND  from_location_no       = from_location_no_
         AND ((transport_task_status = Transport_Task_Status_API.DB_PICKED) OR 
              (transport_task_status = Transport_Task_Status_API.DB_CREATED AND include_unpicked_lines_local_ = Fnd_Boolean_API.DB_TRUE))
         AND  eng_chg_level          = eng_chg_level_
         AND  serial_no              = serial_no_
         AND  lot_batch_no           = lot_batch_no_
         AND  waiv_dev_rej_no        = waiv_dev_rej_no_
         AND (activity_seq           = activity_seq_          OR activity_seq_          IS NULL)
         AND (handling_unit_id       = handling_unit_id_      OR handling_unit_id_      IS NULL)
         AND (order_ref1             = order_ref1_            OR order_ref1_            IS NULL)
         AND (order_ref2             = order_ref2_            OR order_ref2_            IS NULL)
         AND (order_ref3             = order_ref3_            OR order_ref3_            IS NULL)
         AND (order_ref4             = order_ref4_            OR order_ref4_            IS NULL)
         AND (pick_list_no           = pick_list_no_          OR pick_list_no_          IS NULL)
         AND (shipment_id            = shipment_id_           OR shipment_id_           IS NULL)         
         AND (order_type             = order_type_db_         OR order_type_db_         IS NULL)
         AND (reserved_by_source     = reserved_by_source_db_ OR reserved_by_source_db_ IS NULL);
BEGIN
   
   IF (include_unpicked_lines_) THEN
      include_unpicked_lines_local_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   IF ((lot_batch_no_     IS NULL) OR 
       (serial_no_        IS NULL) OR 
       (eng_chg_level_    IS NULL) OR 
       (waiv_dev_rej_no_  IS NULL)) THEN
      -- slower but more flexible
      OPEN  get_qty_outbound_1;
      FETCH get_qty_outbound_1 INTO qty_outbound_;
      CLOSE get_qty_outbound_1;
   ELSE
      -- For maximum performance
      OPEN  get_qty_outbound_2;
      FETCH get_qty_outbound_2 INTO qty_outbound_;
      CLOSE get_qty_outbound_2;
   END IF;

   RETURN qty_outbound_;
END Get_Qty_Outbound_;

-- Check_Insert_
--   The validations that needs to be performed before an insert. These
--   validations are placed in this method so that they can be available and
--   called upon from other LU's connected to this LU preceding a call to
--   actually insert a record.
PROCEDURE Check_Insert_ (
   from_contract_                IN VARCHAR2,
   from_location_no_             IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   to_contract_                  IN VARCHAR2,
   to_location_no_               IN VARCHAR2,
   destination_                  IN VARCHAR2,
   order_type_                   IN VARCHAR2,
   order_ref1_                   IN VARCHAR2,
   order_ref2_                   IN VARCHAR2,
   order_ref3_                   IN VARCHAR2,
   order_ref4_                   IN VARCHAR2,
   pick_list_no_                 IN VARCHAR2,
   shipment_id_                  IN NUMBER,         
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER, 
   quantity_                     IN NUMBER,  
   allow_deviating_avail_ctrl_   IN BOOLEAN,   
   check_storage_requirements_   IN BOOLEAN,
   checking_forward_transport_   IN BOOLEAN  DEFAULT FALSE,
   check_duplicate_reservations_ IN BOOLEAN  DEFAULT TRUE,
   reserved_by_source_db_        IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE)
IS
   from_location_type_db_         VARCHAR2(50);
   to_location_type_db_           VARCHAR2(50);
   mand_analysis_confirmed_       VARCHAR2(5);
   mand_purch_analysis_           VARCHAR2(15);
   vendor_no_                     Supplier_Info_Public.supplier_id%TYPE;
   to_part_loc_                   Inventory_Part_In_Stock_API.Public_Rec;
   from_part_loc_                 Inventory_Part_In_Stock_API.Public_Rec;
   part_catalog_rec_              Part_Catalog_API.Public_Rec;
   from_default_avail_control_id_ VARCHAR2(25);
   tmp_pick_list_no_              VARCHAR2(15);
   qty_reserved_                  NUMBER := 0;
   reservation_booked_for_trans_  BOOLEAN;
BEGIN
   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, from_contract_);
   part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
   
   IF (order_type_ IS NOT NULL) THEN
      IF (order_type_ NOT IN (Order_Type_API.DB_WORK_TASK,  Order_Type_API.DB_PURCHASE_ORDER, Order_Type_API.DB_SHOP_ORDER, Order_Type_API.DB_PRODUCTION_SCHEDULE, Order_Type_API.DB_CUSTOMER_ORDER,
                              Order_Type_API.DB_DOP_DEMAND,  Order_Type_API.DB_DOP_NETTED_DEMAND, Order_Type_API.DB_PROJECT_DELIVERABLES, Order_Type_API.DB_MATERIAL_REQUISITION, 
                              Order_Type_API.DB_KANBAN_CARD, Order_Type_API.DB_SHIPMENT_ORDER, Order_Type_API.DB_PROJ_MISC_DEMAND)) THEN
         Error_SYS.Record_General('TransportTaskLine', 'MOVESTOCKNOTALLOWED: Moving stock that has an order reference on the transport task line is not allowed for :P1.', order_type_);
      END IF;
      
      -- NOTE: order_supply_demand_type_db_ has to be translated between Order Type and Order Supply Demand Type.
      -- To check if its a move by reservation
      IF (reserved_by_source_db_ = Fnd_Boolean_API.DB_TRUE) THEN
         qty_reserved_ := Inv_Part_Stock_Reservation_API.Get_Qty_Reserved(order_no_                    => order_ref1_,
                                                                          line_no_                     => order_ref2_,
                                                                          release_no_                  => order_ref3_,
                                                                          line_item_no_                => order_ref4_,
                                                                          pick_list_no_                => pick_list_no_,
                                                                          shipment_id_                 => shipment_id_,                                                                                                                                                                                                                          
                                                                          order_supply_demand_type_db_ => Order_Type_API.Get_Order_Suppl_Demand_Type_Db(order_type_),
                                                                          contract_                    => from_contract_, 
                                                                          part_no_                     => part_no_,
                                                                          configuration_id_            => configuration_id_,
                                                                          location_no_                 => from_location_no_,
                                                                          lot_batch_no_                => lot_batch_no_,
                                                                          serial_no_                   => serial_no_,
                                                                          eng_chg_level_               => eng_chg_level_,
                                                                          waiv_dev_rej_no_             => waiv_dev_rej_no_,
                                                                          activity_seq_                => activity_seq_,
                                                                          handling_unit_id_            => handling_unit_id_);
      END IF;
      
      IF (qty_reserved_ > 0) THEN
         -- Check that the same reservation isn't registered on another transport task.
         IF (check_duplicate_reservations_ AND (reserved_by_source_db_ = Fnd_Boolean_API.DB_TRUE)) THEN
            reservation_booked_for_trans_ := Reservation_Booked_For_Transp(from_contract_,
                                                                           from_location_no_,
                                                                           part_no_,
                                                                           configuration_id_,
                                                                           lot_batch_no_,
                                                                           serial_no_,
                                                                           eng_chg_level_,
                                                                           waiv_dev_rej_no_,
                                                                           activity_seq_,
                                                                           handling_unit_id_,
                                                                           order_ref1_,
                                                                           order_ref2_,
                                                                           order_ref3_,
                                                                           order_ref4_,
                                                                           pick_list_no_,
                                                                           shipment_id_,
                                                                           order_type_ );
            IF (reservation_booked_for_trans_) THEN
               Raise_Res_Is_On_Trans_Task;
            END IF;
         END IF;

      ELSIF (qty_reserved_ <= 0 AND (reserved_by_source_db_ = Fnd_Boolean_API.DB_TRUE)) THEN
         Error_SYS.Record_General('TransportTaskLine', 'REFNEEDSRESQTY: When a transport task line has a :P1 reference, the material has to be reserved.', Order_Type_API.Decode(order_type_));
      END IF;

      IF (reserved_by_source_db_ = Fnd_Boolean_API.DB_TRUE ) THEN
         -- Check that the reserved qty for the order ref is the same as the qty on the transport task line.
         IF (qty_reserved_ != quantity_) THEN
            Error_SYS.Record_General('TransportTaskLine', 'QTYMOVINGRESEVRED: When moving reserved stock the quantity on the transport task line must equal the reserved quantity on the reservation, which is :P1.', qty_reserved_);
         END IF;
      END IF;
      
      IF (order_type_ = Order_Type_API.DB_WORK_TASK) THEN
         tmp_pick_list_no_ := Inv_Part_Stock_Reservation_API.Get_Pick_List_No(order_no_             => order_ref1_,
                                                                          line_no_                  => order_ref2_,
                                                                          release_no_               => order_ref3_,
                                                                          line_item_no_             => order_ref4_,
                                                                          order_supply_demand_type_ => Order_Supply_Demand_Type_API.Decode(Order_Supply_Demand_Type_API.DB_WORK_TASK),
                                                                          contract_                 => from_contract_,
                                                                          part_no_                  => part_no_,
                                                                          configuration_id_         => configuration_id_,
                                                                          location_no_              => from_location_no_,
                                                                          lot_batch_no_             => lot_batch_no_,
                                                                          serial_no_                => serial_no_,
                                                                          eng_chg_level_            => eng_chg_level_,
                                                                          waiv_dev_rej_no_          => waiv_dev_rej_no_,
                                                                          activity_seq_             => activity_seq_,
                                                                          handling_unit_id_         => handling_unit_id_);
         IF (NVL(tmp_pick_list_no_, 0) != 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOMOVEWHENPICKLISTEXIST: Moving a reservation is not allowed when a pick list exist for the reservation reference.');
         END IF;
      END IF;
   END IF;
   
   IF (configuration_id_ = '*' AND part_catalog_rec_.configurable = Part_Configuration_API.DB_CONFIGURED) THEN
      Error_SYS.Record_General('TransportTaskLine', 'NOCONFIGURATIONINS: You have to choose a Configuration ID because the part is configurable.');
   END IF;

   IF (from_contract_ != to_contract_) THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, to_contract_);
      Inventory_Part_API.Exist(to_contract_, part_no_);
      Inventory_Part_Config_API.Exist(to_contract_, part_no_, configuration_id_);
   END IF;

   from_location_type_db_ := Inventory_Location_API.Get_Location_Type_db(from_contract_, from_location_no_);
   to_location_type_db_   := Inventory_Location_API.Get_Location_Type_db(to_contract_, to_location_no_);

   IF ((from_contract_ = to_contract_) AND (from_location_no_ = to_location_no_)) THEN
      Error_SYS.Record_General('TransportTaskLine','INSMOVETOSAME: You can not move to location :P1 from location :P1. Select a different location.', from_location_no_);
   END IF;

   IF (from_location_type_db_ = 'SHIPMENT') THEN
      Raise_Location_Type_Error___(from_location_type_db_);
   END IF;

   IF (to_location_type_db_ = 'SHIPMENT') THEN
      Raise_Location_Type_Error___(to_location_type_db_);
   END IF;

   Inventory_Part_In_Stock_API.Check_Valid_Move_Combinations(from_contract_,
                                                             from_location_type_db_,
                                                             to_contract_,
                                                             to_location_type_db_,
                                                             destination_,
                                                             order_ref1_,
                                                             order_type_,
                                                             part_no_,
                                                             part_no_);
   $IF Component_Purch_SYS.INSTALLED $THEN   
      vendor_no_ := Purchase_Order_API.Get_Vendor_No(order_ref1_);                 
   $END
   
   $IF Component_Quaman_SYS.INSTALLED $THEN
      IF (order_type_ = 'PUR ORDER') THEN         
         mand_analysis_confirmed_ := Purch_Order_Analysis_API.Is_Mand_Analysis_Confirmed(order_ref1_, order_ref2_, order_ref3_, order_ref4_ );
         mand_purch_analysis_     := Qman_Control_Plan_Purch_API.Is_Mandatory_Purch_Analysis(from_contract_, part_no_, vendor_no_);                   
        
         IF (mand_analysis_confirmed_ = 'FALSE') AND (mand_purch_analysis_ = 'MANDATORY') THEN
            Error_SYS.Record_General(lu_name_, 'MOVENOTALLOWED1: A completed analysis has to exist for Part :P1 before the move can be done', part_no_);
         END IF;
      END IF;
   $END
      
   IF NOT (quantity_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'ZERONEGATIVEQTY: The quantity on a Transport Task Line must be greater than zero.');
   END IF;

   IF serial_no_ != '*' AND quantity_ != '1' THEN
      Error_SYS.Record_General(lu_name_, 'SERIALNOQTYINSERT: The quantity can only be 1 not :P1 on Transport Task Lines when serial numbers are used.', quantity_);
   END IF;

   from_part_loc_ := Inventory_Part_In_Stock_API.Get(contract_          => from_contract_,
                                                     part_no_           => part_no_,
                                                     configuration_id_  => configuration_id_,
                                                     location_no_       => from_location_no_,
                                                     lot_batch_no_      => lot_batch_no_,
                                                     serial_no_         => serial_no_,
                                                     eng_chg_level_     => eng_chg_level_,
                                                     waiv_dev_rej_no_   => waiv_dev_rej_no_,
                                                     activity_seq_      => activity_seq_,
                                                     handling_unit_id_  => handling_unit_id_);

   to_part_loc_ := Inventory_Part_In_Stock_API.Get(contract_         => to_contract_,
                                                   part_no_          => part_no_,
                                                   configuration_id_ => configuration_id_,
                                                   location_no_      => to_location_no_,
                                                   lot_batch_no_     => lot_batch_no_,
                                                   serial_no_        => serial_no_,
                                                   eng_chg_level_    => eng_chg_level_,
                                                   waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                   activity_seq_     => activity_seq_,
                                                   handling_unit_id_ => handling_unit_id_);

   -- To check if the from_part_loc record exists.
   IF (from_part_loc_.qty_onhand IS NULL AND NOT checking_forward_transport_) THEN   
      Error_SYS.Record_General(lu_name_, 'PARTLOCNOTEXIST: This record does not exist for Part :P1 on Site :P2 Location number :P3.', part_no_, from_contract_, from_location_no_);
   END IF;

   IF from_part_loc_.freeze_flag = 'Y' THEN
      Raise_Location_Frozen_Error___(part_no_, from_contract_, from_location_no_);
   END IF;

   IF (Part_Availability_Control_API.Check_Part_Movement_Control(from_part_loc_.availability_control_id) = 'NOT ALLOWED') THEN
      Error_SYS.Record_General(lu_name_, 'PACMOVECONTROL: The source stock record has Part Availability Control ID :P1 which means that the quantity cannot be moved', from_part_loc_.availability_control_id);
   END IF;

   -- Check if the part ownership is allowed to be mixed on the location level.
   IF (to_part_loc_.qty_onhand IS NULL) OR (to_part_loc_.qty_onhand = 0 AND to_part_loc_.qty_in_transit = 0) THEN
      Inventory_Part_In_Stock_API.Check_Allow_Ownership_Mix(to_contract_,
                                                            part_no_,
                                                            to_location_no_,
                                                            from_part_loc_.part_ownership,
                                                            from_part_loc_.owning_customer_no,
                                                            from_part_loc_.owning_vendor_no);
   END IF;

   -- Check if the part ownership is allowed to be moved
   Inventory_Part_In_Stock_API.Check_Ownership_Move_Part(from_part_loc_.part_ownership,
                                                         from_part_loc_.owning_vendor_no,
                                                         from_part_loc_.owning_customer_no,
                                                         part_no_,
                                                         from_location_no_,
                                                         from_part_loc_.location_type,
                                                         to_part_loc_.part_ownership,
                                                         to_part_loc_.owning_vendor_no,
                                                         to_part_loc_.owning_customer_no,
                                                         part_no_,
                                                         to_location_no_,
                                                         'N',
                                                         FALSE);

   -- IF and only if the to_part_loc record exist, extended validation should take place.
   IF to_part_loc_.qty_onhand IS NOT NULL THEN
      IF (to_part_loc_.qty_onhand != 0 OR to_part_loc_.qty_in_transit !=0) THEN
         from_default_avail_control_id_ := Warehouse_Bay_Bin_API.Get_Availability_Control_Id(from_contract_,
                                                                                             from_part_loc_.warehouse,
                                                                                             from_part_loc_.bay_no,
                                                                                             from_part_loc_.tier_no,
                                                                                             from_part_loc_.row_no,
                                                                                             from_part_loc_.bin_no);
         IF (NVL(from_part_loc_.availability_control_id, string_null_) = 
             NVL(from_default_avail_control_id_        , string_null_)) THEN
            -- If the PAC ID on the source record equals the default PAC ID on the source location then
            -- The quantity moved would need to get the default PAC ID of the destination location applied
            -- once the transport task line gets executed. So we need to do the validation accordingly,
            -- shifting the PAC ID on the from_part_loc_ from the source location default to the destination
            -- location default before performing the validations below to allow the move if the to_part_loc_
            -- record has what is the default PAC ID on that location.
            from_part_loc_.availability_control_id := Warehouse_Bay_Bin_API.Get_Availability_Control_Id(to_contract_,
                                                                                                        to_part_loc_.warehouse,
                                                                                                        to_part_loc_.bay_no,
                                                                                                        to_part_loc_.tier_no,
                                                                                                        to_part_loc_.row_no,
                                                                                                        to_part_loc_.bin_no);
         END IF;

         IF (from_part_loc_.availability_control_id != to_part_loc_.availability_control_id) OR
             ((from_part_loc_.availability_control_id IS NOT NULL) AND (to_part_loc_.availability_control_id IS NULL)) OR
             ((to_part_loc_.availability_control_id IS NOT NULL) AND (from_part_loc_.availability_control_id IS NULL)) THEN
            IF NOT (allow_deviating_avail_ctrl_) THEN
               IF (checking_forward_transport_) THEN
                  Error_SYS.Record_General(lu_name_, 'FDIFFAVAILINSERT: The Availability Control ID differs between to location number :P1 and forward to location number :P2.', from_location_no_, to_location_no_);
               ELSE
                  Error_SYS.Record_General(lu_name_, 'DIFFAVAILINSERT: The Availability Control ID differs between from location number :P1 and to location number :P2.', from_location_no_, to_location_no_);
               END IF;
            END IF;
         END IF;
      END IF;
      IF to_part_loc_.freeze_flag = 'Y' THEN
         Raise_Location_Frozen_Error___(part_no_, to_contract_, to_location_no_);
      END IF;
   -- If the part_loc record does not exist, validation will have to be performed that it can be created.
   ELSE
      -- Check Lot/Batch tracking and Serial number tracking for the part.
      IF (part_catalog_rec_.lot_tracking_code IN ('LOT TRACKING', 'ORDER BASED')) THEN
         IF (lot_batch_no_ = '*' AND to_location_type_db_ NOT IN ('ARRIVAL', 'QA')) THEN
            IF (checking_forward_transport_) THEN
               Error_SYS.Record_General('TransportTaskLine', 'FLOTBATNEEDEDINSERT: You can not move the part :P1 to forward to location :P2 since this part does not have a lot/batch number.', part_no_, to_location_no_);
            ELSE
               Error_SYS.Record_General('TransportTaskLine', 'LOTBATNEEDEDINSERT: You can not move the part :P1 to location :P2 since this part does not have a lot/batch number.', part_no_, to_location_no_);
            END IF;
         END IF;
      ELSIF (part_catalog_rec_.lot_tracking_code = 'NOT LOT TRACKING') THEN
         IF (lot_batch_no_ != '*') THEN
            IF (checking_forward_transport_) THEN
               Error_SYS.Record_General('TransportTaskLine', 'FLOTBATNOTALLOWINSERT: You can not move the part :P1 to forward to location :P2 since this part has a lot/batch number.', part_no_, to_location_no_);
            ELSE
               Error_SYS.Record_General('TransportTaskLine', 'LOTBATNOTALLOWINSERT: You can not move the part :P1 to location :P2 since this part has a lot/batch number.', part_no_, to_location_no_);
            END IF;
         END IF;
      END IF;

      IF (part_catalog_rec_.serial_tracking_code = 'SERIAL TRACKING') THEN
         IF (serial_no_ = '*' AND to_location_type_db_ NOT IN ('ARRIVAL', 'QA')) THEN
            IF (checking_forward_transport_) THEN
               Error_SYS.Record_General('TransportTaskLine', 'FSERIALNEEDEDINSERT: You can not move the part :P1 to forward to location :P2 since this part does not have a serial number.', part_no_, to_location_no_);
            ELSE
               Error_SYS.Record_General('TransportTaskLine', 'SERIALNEEDEDINSERT: You can not move the part :P1 to location :P2 since this part does not have a serial number.', part_no_, to_location_no_);
            END IF;
         END IF;
      ELSIF (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_false) THEN
         IF (serial_no_ != '*') THEN
            IF (checking_forward_transport_) THEN
               Error_SYS.Record_General('TransportTaskLine', 'FSERIALNOTALLOWINSERT: You can not move the part :P1 to forward to location :P2 since this part has a serial number.', part_no_, to_location_no_);
            ELSE
               Error_SYS.Record_General('TransportTaskLine', 'SERIALNOTALLOWINSERT: You can not move the part :P1 to location :P2 since this part has a serial number.', part_no_, to_location_no_);
            END IF;
         END IF;
      END IF;
   END IF;

   Warehouse_Bay_Bin_API.Check_Receipts_Blocked(to_contract_, to_location_no_);

   IF (check_storage_requirements_) THEN
      Inventory_Putaway_Manager_API.Check_Storage_Requirements(to_contract_        => to_contract_,
                                                               part_no_            => part_no_,
                                                               configuration_id_   => configuration_id_,
                                                               to_location_no_     => to_location_no_,
                                                               lot_batch_no_       => lot_batch_no_,
                                                               serial_no_          => serial_no_,
                                                               eng_chg_level_      => eng_chg_level_,
                                                               waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                               activity_seq_       => activity_seq_,
                                                               handling_unit_id_   => handling_unit_id_,
                                                               quantity_           => quantity_);
   END IF;
END Check_Insert_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Lines_Exist
--   This method counts the number of lines on a transport task, if there
--   are any it will return FALSE.
@UncheckedAccess
FUNCTION Lines_Exist (
   transport_task_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_  NUMBER;
   return_ BOOLEAN;

   CURSOR find_rows IS
      SELECT 1
      FROM TRANSPORT_TASK_LINE_TAB
      WHERE transport_task_id = transport_task_id_;
BEGIN
   OPEN find_rows;
   FETCH find_rows INTO dummy_;
   return_ := find_rows%FOUND;
   CLOSE find_rows;
   RETURN return_;
END Lines_Exist;

-- Count_Lines

--   This method returns the number of lines connected to a transport task.
@UncheckedAccess
FUNCTION Count_Lines (
   transport_task_id_ IN NUMBER ) RETURN NUMBER
IS
   result_ NUMBER;

   CURSOR count_lines IS
      SELECT count(*)
      FROM TRANSPORT_TASK_LINE_TAB
      WHERE transport_task_id = transport_task_id_;
BEGIN
   OPEN count_lines;
   FETCH count_lines INTO result_;
   CLOSE count_lines;
   RETURN result_;
END Count_Lines;


PROCEDURE Move (
   from_transport_task_id_        IN NUMBER,
   line_no_                       IN NUMBER,
   to_transport_task_id_          IN NUMBER,
   allow_move_from_fixed_task_db_ IN VARCHAR2,
   allow_move_to_fixed_task_db_   IN VARCHAR2,
   set_from_task_as_fixed_db_     IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false,
   set_to_task_as_fixed_db_       IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false )
IS
   rec_ TRANSPORT_TASK_LINE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(from_transport_task_id_, line_no_);

   Move___(from_transport_task_id_,
           line_no_,
           to_transport_task_id_,
           (allow_move_from_fixed_task_db_ = Fnd_Boolean_API.db_true),
           (allow_move_to_fixed_task_db_   = Fnd_Boolean_API.db_true),
           (set_from_task_as_fixed_db_     = Fnd_Boolean_API.db_true),
           (set_to_task_as_fixed_db_       = Fnd_Boolean_API.db_true));
END Move;


-- Get_Task_Id_List
--   This method returns the list of transport task ids currently handling
@UncheckedAccess
FUNCTION Get_Task_Id_List (
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN NUMBER,
   order_type_db_    IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_reg_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN VARCHAR2
IS
   task_id_list_ VARCHAR2(2000);

   CURSOR get_transport_task_id IS
      SELECT DISTINCT transport_task_id
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE (order_ref1            = order_ref1_    OR order_ref1_    IS NULL)
         AND (order_ref2            = order_ref2_    OR order_ref2_    IS NULL)
         AND (order_ref3            = order_ref3_    OR order_ref3_    IS NULL)
         AND (order_ref4            = order_ref4_    OR order_ref4_    IS NULL)
         AND (order_type            = order_type_db_ OR order_type_db_ IS NULL)
         AND  from_contract         = contract_
         AND  part_no               = part_no_
         AND  configuration_id      = configuration_id_
         AND  from_location_no      = location_no_
         AND  lot_batch_no          = lot_batch_no_
         AND  serial_no             = serial_no_
         AND  eng_chg_level         = eng_chg_level_
         AND  waiv_dev_rej_no       = waiv_dev_reg_no_
         AND  activity_seq          = activity_seq_
         AND  handling_unit_id      = handling_unit_id_
         AND  transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   FOR rec_ IN get_transport_task_id LOOP
      IF (task_id_list_ IS NOT NULL) THEN
         task_id_list_ := task_id_list_||', ';
      END IF;
      task_id_list_ := task_id_list_||rec_.transport_task_id;
   END LOOP;
  RETURN task_id_list_;
END Get_Task_Id_List;


@UncheckedAccess
FUNCTION Other_Owners_Are_Inbound (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   location_no_        IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2,
   owning_customer_no_ IN VARCHAR2,
   owning_vendor_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   other_owners_are_inbound_ BOOLEAN := FALSE;
   db_consignment_           CONSTANT VARCHAR2(50) := Part_Ownership_API.DB_CONSIGNMENT;
   db_supplier_loaned_       CONSTANT VARCHAR2(50) := Part_Ownership_API.DB_SUPPLIER_LOANED;
   db_supplier_owned_        CONSTANT VARCHAR2(50) := Part_Ownership_API.DB_SUPPLIER_OWNED;
   db_customer_owned_        CONSTANT VARCHAR2(50) := Part_Ownership_API.DB_CUSTOMER_OWNED;
   db_created_               CONSTANT VARCHAR2(50) := Transport_Task_Status_API.DB_CREATED;
   db_picked_                CONSTANT VARCHAR2(50) := Transport_Task_Status_API.DB_PICKED;
   dummy_                    NUMBER;

   CURSOR get_lines IS
      SELECT 1
         FROM  inventory_part_in_stock_tab inv, TRANSPORT_TASK_LINE_TAB tt
         WHERE inv.contract = tt.from_contract
         AND   inv.part_no = tt.part_no
         AND   inv.configuration_id = tt.configuration_id
         AND   inv.location_no = tt.from_location_no
         AND   inv.lot_batch_no = tt.lot_batch_no
         AND   inv.serial_no = tt.serial_no
         AND   inv.eng_chg_level = tt.eng_chg_level
         AND   inv.waiv_dev_rej_no = tt.waiv_dev_rej_no
         AND   inv.activity_seq = tt.activity_seq
         AND   inv.handling_unit_id = tt.handling_unit_id 
         AND   tt.to_location_no        = location_no_
         AND   tt.to_contract           = contract_
         AND   tt.part_no               = part_no_
         AND   tt.transport_task_status IN (db_created_, db_picked_)
         AND   (NVL(inv.part_ownership, string_null_) != NVL(part_ownership_db_, string_null_) 
               OR
               (part_ownership_db_ IN (db_consignment_, db_supplier_loaned_, db_supplier_owned_) AND inv.owning_vendor_no != NVL(owning_vendor_no_, string_null_)) 
               OR
               (part_ownership_db_ = db_customer_owned_ AND inv.owning_customer_no != NVL(owning_customer_no_, string_null_)));
BEGIN
   OPEN get_lines;
      FETCH get_lines INTO dummy_;
      IF get_lines%FOUND THEN
         other_owners_are_inbound_ := TRUE;
      END IF;
      CLOSE get_lines;

   RETURN (other_owners_are_inbound_);
END Other_Owners_Are_Inbound;


-- Execute
--   This method executes the Transport Task.
PROCEDURE Execute (
   transport_task_id_            IN     NUMBER,
   line_no_                      IN     NUMBER,
   part_tracking_session_id_     IN     NUMBER DEFAULT NULL,
   validate_hu_struct_position_  IN     VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE,
   forward_to_transport_task_id_ IN     NUMBER DEFAULT NULL)
IS
   oldrec_                        TRANSPORT_TASK_LINE_TAB%ROWTYPE;
   number_of_identified_serials_  NUMBER;
   number_of_serials_to_identify_ NUMBER;
BEGIN
   oldrec_ := Lock_By_Keys___(transport_task_id_, line_no_);

   number_of_identified_serials_  := Temporary_Part_Tracking_API.Get_Number_Of_Serials(part_tracking_session_id_);
   number_of_serials_to_identify_ := Get_No_Of_Unidentified_Serials(transport_task_id_, line_no_);

   IF (number_of_identified_serials_ != number_of_serials_to_identify_) THEN
      Error_SYS.Record_General('TransportTaskLine','SERNONOTEQ: You need to identify :P1 serials but have identified :P2 for line :P3.', number_of_serials_to_identify_, number_of_identified_serials_, line_no_);
   END IF;
   
   Execute_(transport_task_id_              => transport_task_id_,
            line_no_                        => line_no_,
            part_tracking_session_id_       => part_tracking_session_id_,
            validate_hu_struct_position_    => Fnd_Boolean_API.Evaluate_Db(validate_hu_struct_position_),
            forward_to_transport_task_id_   => forward_to_transport_task_id_);
   Transport_Task_API.Print_Transport_Task(transport_task_id_);
   Client_SYS.Clear_Info;
END Execute;


-- Pick
--   This method picks the Transport Task.
PROCEDURE Pick (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER )
IS
   oldrec_ TRANSPORT_TASK_LINE_TAB%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(transport_task_id_, line_no_);

   IF (oldrec_.transport_task_status = Transport_Task_Status_API.DB_PICKED) THEN
      Error_SYS.Record_General('TransportTaskLine','LINEALRPICKED: Line :P1 on Transport Task :P2 is already picked.', line_no_, transport_task_id_);
   END IF;
   
   IF (NVL(oldrec_.catch_quantity, 0) = 0 AND Catch_Quantity_Required(transport_task_id_, line_no_) = 1) THEN 
      Error_SYS.Record_General('TransportTaskLine', 'CATCHQTYPLSENTER: Part :P1 uses Catch Unit :P2 and Catch Quantity must be entered.',
                            oldrec_.part_no, Inventory_Part_API.Get_Catch_Unit_Meas(oldrec_.from_contract, oldrec_.part_no));
   END IF;
   
   Pick_(transport_task_id_, line_no_);
END Pick;


-- Unpick
--   This method picks the Transport Task.
PROCEDURE Unpick (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER )
IS
   oldrec_ TRANSPORT_TASK_LINE_TAB%ROWTYPE;
BEGIN
   oldrec_ := Lock_By_Keys___(transport_task_id_, line_no_);

   IF (oldrec_.transport_task_status = Transport_Task_Status_API.DB_CREATED) THEN
      Error_SYS.Record_General('TransportTaskLine','LINEALRPICKEDNOTUNPICK: Line :P1 on Transport Task :P2 is not picked and cannot be unpicked.', line_no_, transport_task_id_);
   END IF;
   
   Unpick_(transport_task_id_, line_no_);
END Unpick;


@UncheckedAccess
FUNCTION Get_No_Of_Unidentified_Serials (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER ) RETURN NUMBER
IS
   no_of_unidentified_serials_ NUMBER := 0;
   rec_                        TRANSPORT_TASK_LINE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(transport_task_id_, line_no_);
   IF (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(rec_.part_no) AND rec_.serial_no = '*' AND rec_.from_contract != rec_.to_contract) THEN
      no_of_unidentified_serials_ := rec_.quantity;
   END IF;

   RETURN (no_of_unidentified_serials_);
END Get_No_Of_Unidentified_Serials;


-- Check_Action_Allowed
--    Checks that a given action is valid for the current transport task status.
PROCEDURE Check_Action_Allowed (
   transport_task_id_        IN NUMBER,
   line_no_                  IN NUMBER,
   transport_task_action_db_ IN VARCHAR2 )
IS
   transport_task_status_db_ TRANSPORT_TASK_LINE.transport_task_status_db%TYPE;
BEGIN
   transport_task_status_db_ := Get_Transport_Task_Status_Db(transport_task_id_, line_no_);
   IF ((transport_task_action_db_ = Transport_Task_Action_API.DB_PICK AND transport_task_status_db_ != (Transport_Task_Status_API.DB_CREATED)) OR
        transport_task_action_db_ = Transport_Task_Action_API.DB_UNPICK AND transport_task_status_db_ != (Transport_Task_Status_API.DB_PICKED) OR
        transport_task_action_db_ = Transport_Task_Action_API.DB_EXECUTE AND transport_task_status_db_ NOT IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)) THEN
      Error_SYS.Record_General(lu_name_, 'ACTIONNOTALLOWED: Action :P1 is not allowed for a line in status :P2.', Transport_Task_Action_API.Decode(transport_task_action_db_), Get_Transport_Task_Status(transport_task_id_, line_no_));
   END IF;
END Check_Action_Allowed;


-- Modify_Quantity
--    Modifies the quantity of an instance of Transport Task Line.
PROCEDURE Modify_Quantity (
   transport_task_id_   IN NUMBER,
   line_no_             IN NUMBER,
   quantity_            IN NUMBER,
   called_from_client_  IN BOOLEAN DEFAULT FALSE)
IS
   oldrec_     transport_task_line_tab%ROWTYPE;
   newrec_     transport_task_line_tab%ROWTYPE;
   attr_       VARCHAR2 (2000);
BEGIN
   oldrec_          := Lock_By_Keys___(transport_task_id_, line_no_);
   newrec_          := oldrec_;   
   newrec_.quantity := quantity_;

   IF (called_from_client_) THEN
      Client_SYS.Add_To_Attr('CLIENT_ACTION', 'DO', attr_);      
   END IF;

   Check_And_Update___(newrec_ => newrec_, oldrec_ => oldrec_, attr_ => attr_);

END Modify_Quantity;


-- Modify_To_Location_No
--    Modifies the to location no of an instance of Transport Task Line.
PROCEDURE Modify_To_Location_No (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER,
   to_location_no_    IN VARCHAR2 )
IS
   record_ transport_task_line_tab%ROWTYPE;
BEGIN
   record_                := Lock_By_Keys___(transport_task_id_, line_no_);
   record_.to_location_no := to_location_no_;
   Modify___(record_);
END Modify_To_Location_No;


-- Modify_Destination
--    Modifies the destination of an instance of Transport Task Line.
PROCEDURE Modify_Destination (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER,
   destination_db_    IN VARCHAR2 )
IS
   record_ transport_task_line_tab%ROWTYPE;
BEGIN
   record_             := Lock_By_Keys___(transport_task_id_, line_no_);
   record_.destination := destination_db_;
   Modify___(record_);
END Modify_Destination;


-- Modify_Catch_Quantity
-- Modifies the catch quantity of an instance of Transport Task Line.
PROCEDURE Modify_Catch_Quantity (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER,
   catch_quantity_    IN NUMBER )
IS
   record_ transport_task_line_tab%ROWTYPE;
BEGIN
   record_                := Lock_By_Keys___(transport_task_id_, line_no_);
   record_.catch_quantity := catch_quantity_;
   Modify___(record_);
END Modify_Catch_Quantity;

   
FUNCTION Reservation_Booked_For_Transp (
   from_contract_         IN VARCHAR2,
   from_location_no_      IN VARCHAR2,
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   eng_chg_level_         IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   activity_seq_          IN VARCHAR2,
   handling_unit_id_      IN NUMBER,
   order_ref1_            IN VARCHAR2,
   order_ref2_            IN VARCHAR2,
   order_ref3_            IN VARCHAR2,
   order_ref4_            IN NUMBER,
   pick_list_no_          IN VARCHAR2,
   shipment_id_           IN NUMBER,
   order_type_db_         IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;

   CURSOR get_existing_line_no IS
      SELECT 1
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE from_contract                    = from_contract_
         AND from_location_no                 = from_location_no_
         AND part_no                          = part_no_
         AND configuration_id                 = configuration_id_
         AND lot_batch_no                     = lot_batch_no_
         AND serial_no                        = serial_no_
         AND eng_chg_level                    = eng_chg_level_
         AND waiv_dev_rej_no                  = waiv_dev_rej_no_
         AND activity_seq                     = activity_seq_
         AND handling_unit_id                 = handling_unit_id_
         AND reserved_by_source               = Fnd_Boolean_API.DB_TRUE  
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND NVL(order_ref1, string_null_)    = NVL(order_ref1_,    string_null_)
         AND NVL(order_ref2, string_null_)    = NVL(order_ref2_,    string_null_)
         AND NVL(order_ref3, string_null_)    = NVL(order_ref3_,    string_null_)
         AND NVL(order_ref4, number_null_)    = NVL(order_ref4_,    number_null_)
         AND NVL(pick_list_no, string_null_)  = NVL(pick_list_no_,  string_null_)
         AND NVL(shipment_id, number_null_)   = NVL(shipment_id_,   number_null_)
         AND NVL(order_type, string_null_)    = NVL(order_type_db_, string_null_);
BEGIN
   OPEN get_existing_line_no;
   FETCH get_existing_line_no INTO dummy_;
   IF (get_existing_line_no%FOUND) THEN
      CLOSE get_existing_line_no;
      RETURN(TRUE);
   END IF;
   CLOSE get_existing_line_no;
   RETURN(FALSE);
END Reservation_Booked_For_Transp;

   
PROCEDURE Apply_Drop_Off_Location (
   info_               OUT VARCHAR2,
   transport_task_id_  IN  NUMBER,
   line_no_            IN  NUMBER )
IS
BEGIN
   Apply_Drop_Off_Location___(transport_task_id_, line_no_);
   info_ := Client_Sys.Get_All_Info();
END Apply_Drop_Off_Location;

   
   
PROCEDURE Revoke_Two_Step_Transport_Task (
   info_               OUT VARCHAR2,
   transport_task_id_  IN  NUMBER,
   line_no_            IN  NUMBER )
IS
BEGIN
   Revoke_Two_Step_Trans_Task___(transport_task_id_, line_no_);

   info_ := Client_Sys.Get_All_Info();
END Revoke_Two_Step_Transport_Task;

   
PROCEDURE Validate_Part_Avail_Ctrl_Info (
   from_availability_control_id_ IN VARCHAR2,
   to_availability_control_id_   IN VARCHAR2,
   to_location_qty_onhand_       IN NUMBER,
   allow_deviating_avail_ctrl_   IN BOOLEAN)
IS
BEGIN
   IF to_location_qty_onhand_ IS NOT NULL THEN
      IF (NVL(from_availability_control_id_, string_null_) != NVL(to_availability_control_id_, string_null_)) OR
         ((from_availability_control_id_ IS NOT NULL) AND (to_availability_control_id_ IS NULL)) OR
         ((to_availability_control_id_ IS NOT NULL) AND (from_availability_control_id_ IS NULL)) THEN
         IF (allow_deviating_avail_ctrl_) THEN
            Client_SYS.Add_Info(lu_name_,'DIFFAVAILINFO: Moving the parts between these locations will change the Part Availability Control ID from :P1 to :P2.', NVL(from_availability_control_id_, 'NULL'), NVL(to_availability_control_id_, 'NULL'));
         END IF;
      END IF;
   END IF;
END Validate_Part_Avail_Ctrl_Info;

   
PROCEDURE Check_Duplicate_Location_Use (
   from_contract_    IN VARCHAR2,
   from_location_no_ IN VARCHAR2,
   to_contract_      IN VARCHAR2,
   to_location_no_   IN VARCHAR2)
IS
BEGIN
   IF (from_contract_ = to_contract_ AND from_location_no_ = to_location_no_) THEN
      Error_SYS.Record_General('TransportTaskLine','INSSAMELOCATION: The same location has been used more than once on a line.');
   END IF;
END Check_Duplicate_Location_Use;

   
-- This method is used by DataCaptTranspTaskPart
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,   -- session contract
   transport_task_id_          IN NUMBER,
   line_no_                    IN NUMBER,
   transport_task_status_db_   IN VARCHAR2,
   order_type_db_              IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   to_location_no_             IN VARCHAR2,
   destination_db_             IN VARCHAR2,  -- TODO: not used, could be removed or use it in the cursor like Get_Column_Value_If_Unique does?
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   configuration_id_           IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   lov_id_                     IN NUMBER DEFAULT 1 )
IS
   -- The reason why this method have session contract as parameter while the other methods don't have it, is that we want the LOV to 
   -- only show data filtered on session contract, but it will still be possible to entered/scan manually other values so thats why 
   -- Get_Column_Value_If_Unique/Record_With_Column_Value_Exist don't have session contract as a filter/parameter. This will also mean 
   -- this LOV will not work properly for any items if user chooses another from contract than session contract, so then user 
   -- should not use LOV for any other item.
   TYPE Get_Lov_Values      IS REF CURSOR;
   get_lov_values_          Get_Lov_Values;
   stmt_                    VARCHAR2(4000);
   TYPE Lov_Value_Tab       IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_           Lov_Value_Tab;
   second_column_name_      VARCHAR2(200);
   second_column_value_     VARCHAR2(200);
   lov_item_description_    VARCHAR2(200);
   lov_value_               VARCHAR2(2000);
   session_rec_             Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_      NUMBER;
   exit_lov_                BOOLEAN := FALSE;
   temp_handling_unit_id_   NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);


      IF lov_id_ = 1 THEN  -- using TRANSPORT_TASK_LINE_NOT_EXEC as data source

         -- extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('TRANSPORT_TASK_LINE_NOT_EXEC', column_name_);
   
         IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
            -- Don't use DISTINCT select for AUTO PICK
            stmt_ := 'SELECT ' || column_name_;
         ELSE
            stmt_ := 'SELECT DISTINCT ' || column_name_;
         END IF;
         stmt_ := stmt_  || ' FROM transport_task_line_not_exec ';
         IF transport_task_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
         END IF;
         IF line_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :line_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND line_no = :line_no_';
         END IF;
         IF transport_task_status_db_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :transport_task_status_db_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND transport_task_status_db = :transport_task_status_db_';
         END IF;
         -- Handling the situations here where end user is deliberately searching for null order types and where the user still hasn't scanned the order type
         IF order_type_db_ IS NULL THEN
            stmt_ := stmt_ || ' AND order_type_db IS NULL AND :order_type_db_ IS NULL';
         ELSIF order_type_db_ = '%' THEN
            stmt_ := stmt_ || ' AND :order_type_db_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND order_type_db = :order_type_db_';
         END IF;
         IF part_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :part_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND part_no = :part_no_';
         END IF;
         IF from_contract_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND from_contract = :from_contract_';
         END IF;
         IF from_location_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
         END IF;
         IF to_contract_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :to_contract_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND to_contract = :to_contract_';
         END IF;
         IF to_location_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :to_location_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND to_location_no = :to_location_no_';
         END IF;
         IF serial_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND serial_no = :serial_no_';
         END IF;
         IF lot_batch_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
         END IF;
         IF eng_chg_level_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
         END IF;
         IF waiv_dev_rej_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
         END IF;
         IF activity_seq_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
         END IF;
         IF handling_unit_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
         END IF;
         IF alt_handling_unit_label_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
         ELSIF alt_handling_unit_label_id_ = '%' THEN
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
         END IF;
         IF configuration_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
         END IF;
         stmt_ := stmt_ || ' AND from_contract = :contract_
                             ORDER BY Utility_SYS.String_To_Number(' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
          
        -- NOTE: This process dont have fake consumation since it would be difficult to handle since it would depend on what action was performed, like PICK/UNPICK 
        --       should not be consumated for example. We have auto_pick possibility but that is more if this process is called from the Start Transport Task process
        --       rather than when it standalone process.

        @ApproveDynamicStatement(2014-11-03,CHJALK)
        OPEN get_lov_values_ FOR stmt_ USING transport_task_id_,
                                             line_no_,
                                             transport_task_status_db_,
                                             order_type_db_,
                                             part_no_,
                                             from_contract_,
                                             from_location_no_,
                                             to_contract_,
                                             to_location_no_,
                                             serial_no_,
                                             lot_batch_no_,
                                             eng_chg_level_,
                                             waiv_dev_rej_no_,
                                             activity_seq_,
                                             handling_unit_id_,
                                             alt_handling_unit_label_id_,
                                             configuration_id_,
                                             contract_;

      -- If this process is used together with the START_TRANSPORT_TASK process we need to break (the line_no) sorting and add 
      -- location/handling unit sorting similar to the aggregated tab. This so we can group the lines connected to a specific location 
      -- and handling unit id together. 
      ELSIF lov_id_ = 2 THEN  -- using TRANSP_TASK_PART_PROCESS as a data source and different sorting
         
         -- extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('TRANSP_TASK_PART_PROCESS', column_name_);
   
         stmt_ := 'SELECT ' || column_name_;
         stmt_ := stmt_  || ' FROM TRANSP_TASK_PART_PROCESS ';
         IF transport_task_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
         END IF;
         IF line_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :line_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND line_no = :line_no_';
         END IF;
         IF transport_task_status_db_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :transport_task_status_db_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND transport_task_status_db = :transport_task_status_db_';
         END IF;
         IF order_type_db_ IS NULL THEN
            stmt_ := stmt_ || ' AND order_type_db IS NULL AND :order_type_db_ IS NULL';
         ELSIF order_type_db_ = '%' THEN
            stmt_ := stmt_ || ' AND :order_type_db_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND order_type_db = :order_type_db_';
         END IF;
         IF part_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :part_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND part_no = :part_no_';
         END IF;
         IF from_contract_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND from_contract = :from_contract_';
         END IF;
         IF from_location_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
         END IF;
         IF to_contract_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :to_contract_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND to_contract = :to_contract_';
         END IF;
         IF to_location_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :to_location_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND to_location_no = :to_location_no_';
         END IF;
         IF serial_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND serial_no = :serial_no_';
         END IF;
         IF lot_batch_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
         END IF;
         IF eng_chg_level_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
         END IF;
         IF waiv_dev_rej_no_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
         END IF;
         IF activity_seq_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
         END IF;
         IF handling_unit_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
         END IF;
         IF alt_handling_unit_label_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
         ELSIF alt_handling_unit_label_id_ = '%' THEN
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
         END IF;
         IF configuration_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
         END IF;
         stmt_ := stmt_ || ' AND from_contract = :contract_ ';


         -- NOTE: that for this LOV we dont sort on the column that is fetched compared to similar LOVs for WADACO processes 
         -- since this needs be location/handling_unit sorted. 
         -- The decode in top_parent_handling_unit_id handling and the NVL on structure_level is so broken handling units 
         -- (hu id != 0 and outmost hu = NULL) will come after non handling units and before complete handlings units per location.
         stmt_ := stmt_  || ' ORDER BY transport_task_status_db,
                                       from_location_no,
                                       NVL(top_parent_handling_unit_id, DECODE(outermost_handling_unit_id,NULL,0,handling_unit_id)),
                                       NVL(structure_level,0),
                                       handling_unit_id,
                                       line_no ';
          
        @ApproveDynamicStatement(2017-03-04,DAZASE)
        OPEN get_lov_values_ FOR stmt_ USING transport_task_id_,
                                             line_no_,
                                             transport_task_status_db_,
                                             order_type_db_,
                                             part_no_,
                                             from_contract_,
                                             from_location_no_,
                                             to_contract_,
                                             to_location_no_,
                                             serial_no_,
                                             lot_batch_no_,
                                             eng_chg_level_,
                                             waiv_dev_rej_no_,
                                             activity_seq_,
                                             handling_unit_id_,
                                             alt_handling_unit_label_id_,
                                             configuration_id_,
                                             contract_;
      END IF;

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('LINE_NO') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            WHEN ('PART_NO') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            WHEN ('FROM_CONTRACT') THEN
               second_column_name_ := 'CONTRACT_DESCRIPTION';
            WHEN ('FROM_LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('TO_CONTRACT') THEN
               second_column_name_ := 'CONTRACT_DESCRIPTION';
            WHEN ('TO_LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('ACTIVITY_SEQ') THEN
               second_column_name_ := 'ACTIVITY_SEQ_DESCRIPTION';
            WHEN ('HANDLING_UNIT_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('SSCC') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            ELSE
               NULL;
         END CASE;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'PART_DESCRIPTION') THEN
                     IF (column_name_ = 'PART_NO') THEN
                        second_column_value_ := Inventory_Part_API.Get_Description(contract_, lov_value_tab_(i));
                     ELSE
                        second_column_value_ := Inventory_Part_API.Get_Description(contract_, part_no_);
                     END IF;
                  ELSIF (second_column_name_ = 'CONTRACT_DESCRIPTION') THEN
                     second_column_value_ := Site_API.Get_Description(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'LOCATION_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ IN ('ACTIVITY_SEQ_DESCRIPTION') AND lov_value_tab_(i) != '0') THEN
                     $IF Component_Proj_SYS.INSTALLED $THEN
                        second_column_value_ := Activity_API.Get_Project_Id(lov_value_tab_(i));
                     $ELSE
                        second_column_value_ := NULL;
                     $END
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESC') THEN
                     IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                        temp_handling_unit_id_ := lov_value_tab_(i);
                     ELSIF (column_name_ = 'SSCC') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                     ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                     END IF;
                     second_column_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                     lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;

            IF (column_name_ = 'TRANSPORT_TASK_STATUS_DB') THEN
               lov_value_ := Transport_Task_Status_API.Decode(lov_value_tab_(i));
            ELSIF (column_name_ = 'ORDER_TYPE_DB') THEN
               lov_value_ := Order_Type_API.Decode(lov_value_tab_(i));
            ELSE
               lov_value_ := lov_value_tab_(i);
            END IF;
           
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_,
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptTranspTaskPart and HandlingUnit
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_      OUT BOOLEAN,
   transport_task_id_          IN NUMBER,
   line_no_                    IN NUMBER,
   transport_task_status_db_   IN VARCHAR2,
   order_type_db_              IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   destination_db_             IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   configuration_id_           IN VARCHAR2,
   column_name_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_      Get_Column_Value;
   stmt_                   VARCHAR2(2000);
   unique_column_value_    VARCHAR2(50);
   too_many_values_found_  BOOLEAN := FALSE;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab; 
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('TRANSPORT_TASK_LINE_NOT_EXEC', column_name_);
   stmt_ := 'SELECT DISTINCT ' || column_name_ || '
             FROM  transport_task_line_not_exec ';
   IF transport_task_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
   END IF;
   IF line_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :line_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND line_no = :line_no_';
   END IF;
   IF transport_task_status_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :transport_task_status_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND transport_task_status_db = :transport_task_status_db_';
   END IF;
   IF order_type_db_ IS NULL THEN
      stmt_ := stmt_ || ' AND order_type_db IS NULL AND :order_type_db_ IS NULL';
   ELSIF order_type_db_ = '%' THEN
      stmt_ := stmt_ || ' AND :order_type_db_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND order_type_db = :order_type_db_';
   END IF;
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF from_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_contract = :from_contract_';
   END IF;
   IF from_location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
   END IF;
   IF to_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :to_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND to_contract = :to_contract_';
   END IF;
   IF destination_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :destination_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND destination_db = :destination_db_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;
   stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' DESC';
   
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2014-11-03,CHJALK)
   OPEN get_column_values_ FOR stmt_ USING transport_task_id_,
                                           line_no_,
                                           transport_task_status_db_,
                                           order_type_db_,
                                           part_no_,
                                           from_contract_,
                                           from_location_no_,
                                           to_contract_,
                                           destination_db_,
                                           serial_no_,
                                           lot_batch_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_,
                                           configuration_id_;
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(To_Char(column_value_tab_(1)), 'NULL');
   ELSIF (column_value_tab_.COUNT = 2) THEN  
      too_many_values_found_ := TRUE; -- more then one unique value found
   END IF;
   CLOSE get_column_values_;

   -- If no values was found at all then set no_unique_value_found_ out-param to TRUE else set it to FALSE. 
   -- This to be able to see the why this method returned NULL so we can know if it was because no values 
   -- was found at all or if it was because to many values was found. This can be used in process utilities which
   -- fetch unique values from several data sources for a specific data item, so that utility can check if 
   -- there was a combined unique value from the data sources or not.
   IF (unique_column_value_ IS NULL AND NOT too_many_values_found_) THEN 
      no_unique_value_found_ := TRUE;    -- no records found
   ELSE
      no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
   END IF;

   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptTranspTaskPart
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   transport_task_id_          IN NUMBER,
   line_no_                    IN NUMBER,
   transport_task_status_db_   IN VARCHAR2,
   order_type_db_              IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   configuration_id_           IN VARCHAR2,
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   data_item_description_      IN VARCHAR2,
   column_value_nullable_      IN BOOLEAN DEFAULT FALSE,
   inv_barcode_validation_     IN BOOLEAN DEFAULT FALSE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_ Check_Exist;
   stmt_          VARCHAR2(2000);
   dummy_         NUMBER;
   exist_         BOOLEAN := FALSE;
BEGIN
   IF (NOT inv_barcode_validation_) THEN 
      -- extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('TRANSPORT_TASK_LINE_NOT_EXEC', column_name_);
   END IF;
   stmt_ := 'SELECT 1  
             FROM transport_task_line_not_exec  ';
   IF transport_task_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :transport_task_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE transport_task_id = :transport_task_id_';
   END IF;
   IF line_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :line_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND line_no = :line_no_';
   END IF;
   IF transport_task_status_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :transport_task_status_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND transport_task_status_db = :transport_task_status_db_';
   END IF;
   IF order_type_db_ IS NULL THEN
      stmt_ := stmt_ || ' AND order_type_db IS NULL AND :order_type_db_ IS NULL';
   ELSIF order_type_db_ = '%' THEN
      stmt_ := stmt_ || ' AND :order_type_db_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND order_type_db = :order_type_db_';
   END IF;
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF from_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_contract = :from_contract_';
   END IF;
   IF from_location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :from_location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND from_location_no = :from_location_no_';
   END IF;
   IF to_contract_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :to_contract_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND to_contract = :to_contract_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;

             
   IF (NOT inv_barcode_validation_) THEN
      IF (column_value_nullable_) THEN
         stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
      ELSE -- NOT column_value_nullable_
        stmt_ := stmt_ || ' AND ' || column_name_ ||'  = :column_value_ ';
      END IF;
   END IF;

   IF (inv_barcode_validation_) THEN
      -- No column value exist check, only check the rest of the keys
      @ApproveDynamicStatement(2017-11-20,DAZASE)
      OPEN exist_control_ FOR stmt_ USING transport_task_id_,
                                          line_no_,
                                          transport_task_status_db_,
                                          order_type_db_,
                                          part_no_,
                                          from_contract_,
                                          from_location_no_,
                                          to_contract_,
                                          serial_no_,
                                          lot_batch_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          configuration_id_;

   ELSIF (column_value_nullable_) THEN
      -- Column value check on a nullable column
      @ApproveDynamicStatement(2015-11-02,DAZASE)
      OPEN exist_control_ FOR stmt_ USING transport_task_id_,
                                          line_no_,
                                          transport_task_status_db_,
                                          order_type_db_,
                                          part_no_,
                                          from_contract_,
                                          from_location_no_,
                                          to_contract_,
                                          serial_no_,
                                          lot_batch_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          configuration_id_,
                                          column_value_,
                                          column_value_;
   ELSE
      -- Column value check without any nullable handling
      @ApproveDynamicStatement(2015-11-02,DAZASE)
      OPEN exist_control_ FOR stmt_ USING transport_task_id_,
                                          line_no_,
                                          transport_task_status_db_,
                                          order_type_db_,
                                          part_no_,
                                          from_contract_,
                                          from_location_no_,
                                          to_contract_,
                                          serial_no_,
                                          lot_batch_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          configuration_id_,
                                          column_value_;
   END IF;
                                                    
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (inv_barcode_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'BARCODENOTEXIST: The Barcode record does not match current Report Picking Line.');
      ELSE
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', data_item_description_, column_value_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;


-- Get_First_Location_No
--    Fetches the from_location_no for the first line of the transport task
@UncheckedAccess
FUNCTION Get_First_Location_No ( 
   transport_task_id_ IN NUMBER ) RETURN VARCHAR2  
IS
   min_line_no_ NUMBER;
   location_no_ VARCHAR2(35);
   
   CURSOR get_min_line_no IS
      SELECT min(line_no)
      FROM transport_task_line_tab
      WHERE transport_task_id      = transport_task_id_
      AND   transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN get_min_line_no;
   FETCH get_min_line_no INTO min_line_no_;
   CLOSE get_min_line_no;
   location_no_ := Get_From_Location_No(transport_task_id_, min_line_no_);

   RETURN location_no_;
END Get_First_Location_No;


@UncheckedAccess
FUNCTION Get_Number_Of_Lines (
   transport_task_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER;

   CURSOR get_lines_left IS
      SELECT count(*)
      FROM  transport_task_line_tab 
      WHERE transport_task_id      = transport_task_id_
      AND   transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN get_lines_left;
   FETCH get_lines_left INTO count_;
   CLOSE get_lines_left;
   RETURN NVL(count_, 0);
END Get_Number_Of_Lines;

@UncheckedAccess
FUNCTION Catch_Quantity_Required (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER ) RETURN NUMBER
IS
   return_value_ NUMBER := 0;
   rec_          Public_Rec;
BEGIN
   rec_ := Get(transport_task_id_, line_no_);
   IF (rec_.transport_task_status != Transport_Task_Status_API.DB_EXECUTED) THEN
      -- if part is catch unit enabled, and not the whole inventory quantity will be moved or catch quantity on from location is NULL,
      -- a new catch quantity is needed in the client
      IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(rec_.part_no) = Fnd_Boolean_API.db_true AND 
         ((rec_.quantity != Inventory_Part_In_Stock_API.Get_Qty_Onhand(contract_         => rec_.from_contract, 
                                                                       part_no_          => rec_.part_no,
                                                                       configuration_id_ => rec_.configuration_id, 
                                                                       location_no_      => rec_.from_location_no,
                                                                       lot_batch_no_     => rec_.lot_batch_no, 
                                                                       serial_no_        => rec_.serial_no,
                                                                       eng_chg_level_    => rec_.eng_chg_level, 
                                                                       waiv_dev_rej_no_  => rec_.waiv_dev_rej_no,
                                                                       activity_seq_     => rec_.activity_seq,
                                                                       handling_unit_id_ => rec_.handling_unit_id)) OR
          (NVL(Inventory_Part_In_Stock_API.Get_Catch_Qty_Onhand(contract_           => rec_.from_contract, 
                                                                part_no_            => rec_.part_no,
                                                                configuration_id_   => rec_.configuration_id, 
                                                                location_no_        => rec_.from_location_no,
                                                                lot_batch_no_       => rec_.lot_batch_no, 
                                                                serial_no_          => rec_.serial_no,
                                                                eng_chg_level_      => rec_.eng_chg_level, 
                                                                waiv_dev_rej_no_    => rec_.waiv_dev_rej_no,
                                                                activity_seq_       => rec_.activity_seq,
                                                                handling_unit_id_   => rec_.handling_unit_id), number_null_) = number_null_))) THEN
         return_value_ := 1;
      END IF;
   END IF;
   RETURN return_value_;
END Catch_Quantity_Required;

@UncheckedAccess
FUNCTION Get_Catch_Unit_Meas (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER ) RETURN VARCHAR2
IS
   return_value_ VARCHAR2(30) := NULL;
   task_rec_     Public_Rec;
BEGIN
   task_rec_ := Get(transport_task_id_, line_no_);

   IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(task_rec_.part_no) = Fnd_Boolean_API.db_true) THEN
      return_value_ := Inventory_Part_API.Get_Catch_Unit_Meas(task_rec_.from_contract, task_rec_.part_no);
   END IF;

   RETURN return_value_;
END Get_Catch_Unit_Meas;

@UncheckedAccess
FUNCTION Get_Unit_Meas (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER) RETURN VARCHAR2
IS
   return_value_ VARCHAR2(30) := NULL;
   task_rec_     Public_Rec;
BEGIN
   task_rec_     := Get(transport_task_id_, line_no_);
   return_value_ := Inventory_Part_API.Get_Unit_Meas(task_rec_.from_contract, task_rec_.part_no);
   
   RETURN return_value_;
END Get_Unit_Meas;

PROCEDURE Split_Into_Serials (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER,
   serial_catch_tab_  IN Inventory_Part_In_Stock_API.Serial_Catch_Table)
IS
   no_of_serials_      NUMBER;
   oldrec_             TRANSPORT_TASK_LINE_TAB%ROWTYPE;
   newrec_             TRANSPORT_TASK_LINE_TAB%ROWTYPE;
   quantity_added_     NUMBER;
   exit_procedure_     EXCEPTION;
BEGIN
   no_of_serials_ := serial_catch_tab_.COUNT;
   IF (no_of_serials_ = 0) THEN
      RAISE exit_procedure_;
   END IF;

   oldrec_ := Lock_By_Keys___(transport_task_id_, line_no_);
   newrec_ := oldrec_;

   IF (oldrec_.from_contract = oldrec_.to_contract) THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWSAMESITE: When using At Receipt and Issue serial tracking alone, you cannot identify specific serial numbers for transport tasks within the same site.'); 
   END IF;

   IF (oldrec_.serial_no != '*') THEN
      Error_SYS.Record_General(lu_name_, 'SPLITSERIALRES: Line :P1 of Transport Task :P2 is already connected to a serial with number :P3.', line_no_, transport_task_id_, oldrec_.serial_no);
   END IF;
   -- Update qty for '*' serials
   Inventory_Event_Manager_API.Start_Session;
   newrec_.quantity := (oldrec_.quantity - no_of_serials_);
   Modify___(newrec_);
   
   Inventory_Part_In_Stock_API.Split_Into_Serials(contract_             => oldrec_.from_contract,
                                                  part_no_              => oldrec_.part_no,
                                                  configuration_id_     => oldrec_.configuration_id,
                                                  location_no_          => oldrec_.from_location_no,
                                                  lot_batch_no_         => oldrec_.lot_batch_no,
                                                  eng_chg_level_        => oldrec_.eng_chg_level,
                                                  waiv_dev_rej_no_      => oldrec_.waiv_dev_rej_no,
                                                  activity_seq_         => oldrec_.activity_seq,
                                                  handling_unit_id_     => oldrec_.handling_unit_id,
                                                  serial_catch_tab_     => serial_catch_tab_,
                                                  reservation_          => FALSE);

   FOR i IN serial_catch_tab_.FIRST..serial_catch_tab_.LAST LOOP
      oldrec_.serial_no := serial_catch_tab_(i).serial_no;
      Update_Assigned___ (quantity_added_,
                          oldrec_,
                          1,
                          serial_catch_tab_(i).catch_qty,
                          NULL);

      IF (quantity_added_ != 1) THEN
         Error_SYS.Record_General(lu_name_, 'NOSERIALRESERVE: Serial :P1 could not be reserved in Inventory.', oldrec_.part_no||' - '||serial_catch_tab_(i).serial_no);       
      END IF;
   END LOOP;

   IF (newrec_.quantity = 0) THEN
      Remove___(newrec_); 
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Split_Into_Serials;

@UncheckedAccess
FUNCTION Other_Conditions_Are_Inbound (
   condition_code_ IN VARCHAR2,
   contract_       IN VARCHAR2,
   location_no_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   other_conditions_are_inbound_ BOOLEAN := FALSE;

   CURSOR get_lines IS
      SELECT DISTINCT part_no, serial_no, lot_batch_no
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE to_location_no        = location_no_
         AND to_contract           = contract_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   FOR rec_ IN get_lines LOOP
      IF (NVL(condition_code_, Database_SYS.string_null_) != NVL(Condition_Code_Manager_API.Get_Condition_Code(rec_.part_no,
                                                                                                               rec_.serial_no,
                                                                                                               rec_.lot_batch_no),
                                                                                                               Database_SYS.string_null_)) THEN
         other_conditions_are_inbound_ := TRUE;
         EXIT;
      END IF;
   END LOOP;

   RETURN (other_conditions_are_inbound_);
END Other_Conditions_Are_Inbound;

@UncheckedAccess
FUNCTION Other_Lots_Are_Inbound (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   location_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   other_lots_are_inbound_ BOOLEAN := FALSE;
   dummy_                  NUMBER;

   CURSOR other_lots_are_inbound IS
      SELECT 1
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE lot_batch_no         != lot_batch_no_
         AND to_location_no        = location_no_
         AND to_contract           = contract_
         AND part_no               = part_no_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN other_lots_are_inbound;
   FETCH other_lots_are_inbound INTO dummy_;
   IF (other_lots_are_inbound%FOUND) THEN
      other_lots_are_inbound_ := TRUE;
   END IF;
   CLOSE other_lots_are_inbound;

   RETURN (other_lots_are_inbound_);
END Other_Lots_Are_Inbound;

PROCEDURE Reduce_Quantity (
   qty_reduced_             OUT NUMBER,
   catch_qty_reduced_       OUT NUMBER,
   transport_task_id_       IN  NUMBER,
   line_no_                 IN  NUMBER,
   qty_to_be_reduced_       IN  NUMBER,
   catch_qty_to_be_reduced_ IN  NUMBER )
IS
   new_line_qty_       NUMBER;
   new_line_catch_qty_ NUMBER;
   oldrec_             TRANSPORT_TASK_LINE_TAB%ROWTYPE;
   newrec_             TRANSPORT_TASK_LINE_TAB%ROWTYPE;
   remove_reservation_ BOOLEAN := TRUE;
   hu_snapshot_exists_ BOOLEAN := FALSE;
   remove_empty_task_  BOOLEAN := TRUE;
BEGIN
   oldrec_          := Lock_By_Keys___(transport_task_id_, line_no_);
   newrec_          := oldrec_;
   qty_reduced_     := LEAST(oldrec_.quantity, qty_to_be_reduced_);
   new_line_qty_    := oldrec_.quantity - qty_reduced_;
   newrec_.quantity := new_line_qty_;

   IF ((oldrec_.catch_quantity   IS NOT NULL) AND
       (catch_qty_to_be_reduced_ IS NOT NULL)) THEN

      catch_qty_reduced_     := LEAST(oldrec_.catch_quantity, catch_qty_to_be_reduced_);
      new_line_catch_qty_    := oldrec_.catch_quantity - catch_qty_reduced_;
      newrec_.catch_quantity := new_line_catch_qty_;
   END IF;
   
   IF (oldrec_.handling_unit_id != 0) THEN
      hu_snapshot_exists_ := Handl_Unit_Stock_Snapshot_API.Handling_Unit_Exist(source_ref1_         => oldrec_.transport_task_id,
                                                                               source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK,
                                                                               handling_unit_id_    => oldrec_.handling_unit_id);
   END IF;
   
   IF (new_line_qty_ = 0) THEN
      IF (oldrec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE) THEN
         remove_reservation_ := FALSE;         
         IF (hu_snapshot_exists_) THEN
            remove_empty_task_ := FALSE;
         END IF;
      END IF;
      Remove(oldrec_.transport_task_id, 
             oldrec_.line_no, 
             remove_reservation_,
             remove_empty_task_ => remove_empty_task_);
   ELSE
      Check_And_Update___(newrec_                       => newrec_,
                          oldrec_                       => oldrec_,
                          validate_hu_struct_position_  => FALSE);
   END IF;
   
   IF ((oldrec_.reserved_by_source = Fnd_Boolean_API.DB_TRUE) AND 
      hu_snapshot_exists_) THEN
      Replace_Reduced_Hu_Reservat___(oldrec_,
                                    CASE new_line_qty_ WHEN 0 THEN oldrec_.quantity ELSE qty_reduced_ END,
                                    CASE new_line_qty_ WHEN 0 THEN oldrec_.catch_quantity ELSE catch_qty_reduced_ END);       
   END IF;
      
END Reduce_Quantity;

PROCEDURE Increase_Quantity (
   transport_task_id_         IN NUMBER,
   line_no_                   IN NUMBER,
   qty_to_be_increased_       IN NUMBER,
   catch_qty_to_be_increased_ IN NUMBER )
IS
   oldrec_ transport_task_line_tab%ROWTYPE;
   newrec_ transport_task_line_tab%ROWTYPE;
BEGIN
   oldrec_          := Lock_By_Keys___(transport_task_id_, line_no_);
   newrec_          := oldrec_;
   newrec_.quantity := oldrec_.quantity + qty_to_be_increased_;

   IF ((oldrec_.catch_quantity     IS NOT NULL) AND
       (catch_qty_to_be_increased_ IS NOT NULL)) THEN
      newrec_.catch_quantity := oldrec_.catch_quantity + catch_qty_to_be_increased_;
   END IF;

   Check_And_Update___(newrec_                       => newrec_,
                       oldrec_                       => oldrec_,
                       validate_hu_struct_position_  => FALSE);
END Increase_Quantity;

PROCEDURE Remove (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER,
   remove_reservation_ IN BOOLEAN DEFAULT TRUE,
   remove_empty_task_  IN BOOLEAN DEFAULT TRUE )
IS
   remrec_ TRANSPORT_TASK_LINE_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(transport_task_id_, line_no_);
   Check_And_Delete___(remrec_             => remrec_,
                       remove_reservation_ => remove_reservation_);

   IF NOT Lines_Exist(remrec_.transport_task_id) AND (remove_empty_task_) THEN
      Transport_Task_API.Remove(remrec_.transport_task_id);
   END IF;
END Remove;

-- Fetches the latest create_date from a handling unit structure
@UncheckedAccess
FUNCTION Get_Latest_Hu_Create_Date(
   transport_task_id_  IN NUMBER,
   handling_unit_id_   IN NUMBER ) RETURN DATE
IS
   stock_keys_tab_  Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   create_date_     DATE;

   CURSOR get_create_date(from_contract_ VARCHAR2,
                          part_no_ VARCHAR2,
                          configuration_id_ VARCHAR2,
                          from_location_no_ VARCHAR2,
                          lot_batch_no_ VARCHAR2,
                          serial_no_ VARCHAR2,
                          eng_chg_level_ VARCHAR2,
                          waiv_dev_rej_no_ VARCHAR2,
                          activity_seq_ NUMBER,
                          handling_unit_id_ NUMBER) IS
      SELECT create_date
        FROM transport_task_line_tab
       WHERE transport_task_id  = transport_task_id_
         AND from_contract      = from_contract_
         AND part_no            = part_no_
         AND configuration_id   = configuration_id_
         AND from_location_no   = from_location_no_
         AND lot_batch_no       = lot_batch_no_
         AND serial_no          = serial_no_
         AND eng_chg_level      = eng_chg_level_
         AND waiv_dev_rej_no    = waiv_dev_rej_no_
         AND activity_seq       = activity_seq_
         AND handling_unit_id   = handling_unit_id_;

BEGIN

   stock_keys_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);

   IF (stock_keys_tab_.COUNT > 0) THEN
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         FOR rec_ IN get_create_date(stock_keys_tab_(i).contract,
                                     stock_keys_tab_(i).part_no,
                                     stock_keys_tab_(i).configuration_id,
                                     stock_keys_tab_(i).location_no,
                                     stock_keys_tab_(i).lot_batch_no,
                                     stock_keys_tab_(i).serial_no,
                                     stock_keys_tab_(i).eng_chg_level,
                                     stock_keys_tab_(i).waiv_dev_rej_no,
                                     stock_keys_tab_(i).activity_seq,
                                     stock_keys_tab_(i).handling_unit_id) LOOP
            IF (create_date_ IS NULL OR rec_.create_date > create_date_) THEN
               create_date_ := rec_.create_date;
            END IF;
         END LOOP;
      END LOOP;
   END IF;

   RETURN create_date_;
END Get_Latest_Hu_Create_Date;
    

-- For use from Transport_Task_Handling_Unit, Transp_Task_Handl_Unit_Process and Start_Transport_Task_Process views to fetch unique or aggregated values
@UncheckedAccess
FUNCTION Get_Column_Value_If_Unique (
   transport_task_id_      IN NUMBER,
   handling_unit_id_       IN NUMBER,
   from_location_no_       IN VARCHAR2,
   column_name_            IN VARCHAR2,
   use_dotdotdot_as_mixed_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_      Get_Column_Value;
   stmt_                   VARCHAR2(4000);
   unique_column_value_    VARCHAR2(200);
   TYPE Column_Value_Tab   IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   column_value_tab_       Column_Value_Tab;
   mixed_value_            VARCHAR2(3)  := '...';
   
BEGIN
   Assert_SYS.Assert_Is_Table_Column('TRANSPORT_TASK_LINE_TAB', column_name_);
   
   IF (handling_unit_id_ = 0) THEN
      -- Single transport task lines aggregated on from_location
      stmt_ := 'SELECT DISTINCT ' || column_name_ || '
                FROM TRANSPORT_TASK_LINE_TAB
                WHERE transport_task_id = :transport_task_id_
                AND   from_location_no    = :from_location_no_
                AND   transport_task_status IN (''CREATED'' , ''PICKED'')
                AND   Transport_Task_Line_API.Get_Outermost_Handling_Unit_Id(transport_task_id, line_no) IS NULL';

      @ApproveDynamicStatement(2017-01-27,ERLISE)
      OPEN get_column_values_ FOR stmt_ USING transport_task_id_,
                                              from_location_no_;
      FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      CLOSE get_column_values_;
      
      IF (column_value_tab_.count = 1) THEN
         unique_column_value_ := column_value_tab_(1);
      ELSIF (column_value_tab_.count > 1 AND Fnd_Boolean_API.Evaluate_Db(use_dotdotdot_as_mixed_)) THEN 
         unique_column_value_ := mixed_value_;
      ELSE
         unique_column_value_ := NULL;
      END IF;

   ELSE
      -- Transport task line aggregated on handling unit id
      stmt_ := ' SELECT DISTINCT ' || column_name_ || '
                 FROM TRANSPORT_TASK_LINE_TAB ttl
                 WHERE transport_task_id  = :transport_task_id_
                 AND   transport_task_status IN (''CREATED'' , ''PICKED'')
                 AND   ttl.handling_unit_id IN (SELECT hu.handling_unit_id
                                                  FROM handling_unit_tab hu
                                               CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                                 START WITH     hu.handling_unit_id = :handling_unit_id_) ';
      @ApproveDynamicStatement(2017-03-08,DAZASE)
      OPEN get_column_values_ FOR stmt_ USING transport_task_id_, 
                                              handling_unit_id_;
      FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      CLOSE get_column_values_;
      
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := column_value_tab_(1);
      ELSIF (column_value_tab_.COUNT > 1 AND Fnd_Boolean_API.Evaluate_Db(use_dotdotdot_as_mixed_)) THEN
         unique_column_value_ := mixed_value_;
      ELSE
         unique_column_value_ := NULL;
      END IF;

   END IF;
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


@UncheckedAccess
FUNCTION Get_Sum_Column_Value (
   transport_task_id_          IN NUMBER,
   line_no_                    IN NUMBER,
   transport_task_status_db_   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   from_contract_              IN VARCHAR2,
   from_location_no_           IN VARCHAR2,
   to_contract_                IN VARCHAR2,
   destination_db_             IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   configuration_id_           IN VARCHAR2,
   column_name_                IN VARCHAR2 ) RETURN NUMBER
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(4000);
   column_value_                  NUMBER;
BEGIN
      
   IF column_name_ IN ('QUANTITY', 'CATCH_QUANTITY') THEN
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_Table_Column('TRANSPORT_TASK_LINE_NOT_EXEC', column_name_);

      stmt_ := ' SELECT SUM(' || column_name_ || ')
                 FROM  TRANSPORT_TASK_LINE_NOT_EXEC
                 WHERE transport_task_id        = NVL(:transport_task_id_,     transport_task_id    )
                 AND   line_no                  = NVL(:line_no_,               line_no              )
                 AND   transport_task_status_db = NVL(:transport_task_status_db_, transport_task_status_db)
                 AND   part_no                  = NVL(:part_no_,               part_no              )
                 AND   from_contract            = NVL(:from_contract_,         from_contract        )
                 AND   from_location_no         = NVL(:location_no_,           from_location_no     )
                 AND   to_contract              = NVL(:to_contract_,           to_contract          )
                 AND   destination_db           = NVL(:destination_db_,        destination_db       )
                 AND   serial_no                = NVL(:serial_no_,             serial_no            )
                 AND   lot_batch_no             = NVL(:lot_batch_no_,          lot_batch_no         )
                 AND   eng_chg_level            = NVL(:eng_chg_level_,         eng_chg_level        )
                 AND   waiv_dev_rej_no          = NVL(:waiv_dev_rej_no_,       waiv_dev_rej_no      )
                 AND   activity_seq             = NVL(:activity_seq_,          activity_seq         )
                 AND   handling_unit_id         = NVL(:handling_unit_id_,      handling_unit_id     )
                 AND   configuration_id         = NVL(:configuration_id_,      configuration_id     ) ';


      @ApproveDynamicStatement(2017-03-07,DAZASE)
      OPEN get_column_values_ FOR stmt_ USING transport_task_id_,
                                              line_no_,
                                              transport_task_status_db_,
                                              part_no_,
                                              from_contract_,
                                              from_location_no_,
                                              to_contract_,
                                              destination_db_,
                                              serial_no_,
                                              lot_batch_no_,
                                              eng_chg_level_,
                                              waiv_dev_rej_no_,
                                              activity_seq_,
                                              handling_unit_id_,
                                              configuration_id_;
      LOOP
         FETCH get_column_values_ INTO column_value_;
         EXIT WHEN get_column_values_%NOTFOUND;
         
      END LOOP;
      CLOSE get_column_values_;
   END IF;

   RETURN column_value_;
END Get_Sum_Column_Value;


PROCEDURE Modify_Stock_Rec_Destination (
   transport_task_id_            IN NUMBER,
   from_contract_                IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   from_location_no_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,
   to_contract_                  IN VARCHAR2,
   to_location_no_               IN VARCHAR2,
   forward_to_location_no_       IN VARCHAR2,
   destination_db_               IN VARCHAR2,
   check_storage_requirements_   IN BOOLEAN  DEFAULT FALSE)
IS
   newrec_ transport_task_line_tab%ROWTYPE;

   CURSOR get_transport_task_lines IS
      SELECT *
        FROM transport_task_line_tab
       WHERE transport_task_id  = transport_task_id_
         AND from_contract      = from_contract_
         AND part_no            = part_no_
         AND configuration_id   = configuration_id_
         AND from_location_no   = from_location_no_
         AND lot_batch_no       = lot_batch_no_
         AND serial_no          = serial_no_
         AND eng_chg_level      = eng_chg_level_
         AND waiv_dev_rej_no    = waiv_dev_rej_no_
         AND activity_seq       = activity_seq_
         AND handling_unit_id   = handling_unit_id_
      FOR UPDATE NOWAIT;

BEGIN

   FOR oldrec_ IN get_transport_task_lines LOOP
      newrec_ := oldrec_;
      -- Setting the modified attributes
      IF to_contract_ IS NOT NULL THEN
         newrec_.to_contract := to_contract_;
      END IF;
      IF to_location_no_ IS NOT NULL THEN
         newrec_.to_location_no := to_location_no_;
      END IF;
      IF forward_to_location_no_ = string_null_ THEN
         newrec_.forward_to_location_no := to_char(NULL);
      ELSIF forward_to_location_no_ IS NOT NULL THEN
         newrec_.forward_to_location_no := forward_to_location_no_;
      END IF;
      IF destination_db_ IS NOT NULL THEN
         newrec_.destination := destination_db_;
      END IF;
      Check_And_Update___(newrec_                      => newrec_,
                          oldrec_                      => oldrec_,
                          validate_hu_struct_position_ => FALSE,
                          check_storage_requirements_  => check_storage_requirements_);
   END LOOP;

END Modify_Stock_Rec_Destination;


PROCEDURE Remove (
   transport_task_id_      IN NUMBER,
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
   remove_empty_task_      IN BOOLEAN DEFAULT FALSE )
IS
   CURSOR get_transport_task_lines IS
      SELECT transport_task_id, line_no
        FROM transport_task_line_tab
       WHERE transport_task_id  = transport_task_id_
         AND from_contract      = from_contract_
         AND part_no            = part_no_
         AND configuration_id   = configuration_id_
         AND from_location_no   = from_location_no_
         AND lot_batch_no       = lot_batch_no_
         AND serial_no          = serial_no_
         AND eng_chg_level      = eng_chg_level_
         AND waiv_dev_rej_no    = waiv_dev_rej_no_
         AND activity_seq       = activity_seq_
         AND handling_unit_id   = handling_unit_id_
      FOR UPDATE;
BEGIN
   FOR remrec_ IN get_transport_task_lines LOOP
      Remove(transport_task_id_  => remrec_.transport_task_id,
             line_no_            => remrec_.line_no,
             remove_empty_task_  => remove_empty_task_);
   END LOOP;
END Remove;


PROCEDURE Get_Sum_Quantities (
   sum_quantity_       OUT NUMBER,
   sum_catch_quantity_ OUT NUMBER,
   transport_task_id_  IN  NUMBER,
   from_contract_      IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   configuration_id_   IN  VARCHAR2,
   from_location_no_   IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_          IN  VARCHAR2,
   eng_chg_level_      IN  VARCHAR2,
   waiv_dev_rej_no_    IN  VARCHAR2,
   activity_seq_       IN  NUMBER,
   handling_unit_id_   IN  NUMBER )
IS
   CURSOR get_sum_quantities IS
      SELECT NVL(sum(quantity),0), NVL(sum(catch_quantity),0)
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE transport_task_id     = transport_task_id_ 
         AND part_no               = part_no_
         AND configuration_id      = configuration_id_
         AND from_contract         = from_contract_
         AND from_location_no      = from_location_no_
         AND eng_chg_level         = eng_chg_level_
         AND serial_no             = serial_no_
         AND lot_batch_no          = lot_batch_no_
         AND waiv_dev_rej_no       = waiv_dev_rej_no_
         AND activity_seq          = activity_seq_
         AND handling_unit_id      = handling_unit_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   OPEN  get_sum_quantities;
   FETCH get_sum_quantities INTO sum_quantity_, sum_catch_quantity_;
   CLOSE get_sum_quantities;
END Get_Sum_Quantities;


FUNCTION Deviating_Destination_Exist (
   transport_task_id_      IN NUMBER,
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
   to_contract_            IN VARCHAR2,
   to_location_no_         IN VARCHAR2,
   forward_to_location_no_ IN VARCHAR2,
   destination_db_         IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_        NUMBER;
   deviating_    BOOLEAN := FALSE;
   CURSOR check_destination IS
      SELECT 1
        FROM transport_task_line_tab
       WHERE transport_task_id  = transport_task_id_
         AND from_contract      = from_contract_
         AND part_no            = part_no_
         AND configuration_id   = configuration_id_
         AND from_location_no   = from_location_no_
         AND lot_batch_no       = lot_batch_no_
         AND serial_no          = serial_no_
         AND eng_chg_level      = eng_chg_level_
         AND waiv_dev_rej_no    = waiv_dev_rej_no_
         AND activity_seq       = activity_seq_
         AND handling_unit_id   = handling_unit_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND (to_contract != to_contract_ OR
              to_location_no != to_location_no_ OR
              NVL(forward_to_location_no,string_null_) != NVL(forward_to_location_no_,string_null_) OR
              destination != destination_db_);
BEGIN
   OPEN check_destination;
   FETCH check_destination INTO dummy_;
   IF check_destination%FOUND THEN
      deviating_ := TRUE; 
   END IF;
   CLOSE check_destination;
   RETURN deviating_;
END Deviating_Destination_Exist;


-- Returns a unique transport task id, if it can be fetched from inventory part in stock collection 
-- that belongs to a certain handling unit structure. Called from HandlingUnit.
FUNCTION Get_Transport_Task_Id (
   stock_keys_tab_   IN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab ) RETURN NUMBER
IS
   temp_transport_task_id_  NUMBER;
   transport_task_id_       NUMBER;

   CURSOR get_transport_task_id(from_contract_    VARCHAR2,
                                part_no_          VARCHAR2,
                                configuration_id_ VARCHAR2,
                                from_location_no_ VARCHAR2,
                                lot_batch_no_     VARCHAR2,
                                serial_no_        VARCHAR2,
                                eng_chg_level_    VARCHAR2,
                                waiv_dev_rej_no_  VARCHAR2,
                                activity_seq_     NUMBER,
                                handling_unit_id_ NUMBER,
                                quantity_         NUMBER) IS
      SELECT transport_task_id
        FROM transport_task_line_tab
       WHERE from_contract      = from_contract_
         AND part_no            = part_no_
         AND configuration_id   = configuration_id_
         AND from_location_no   = from_location_no_
         AND lot_batch_no       = lot_batch_no_
         AND serial_no          = serial_no_
         AND eng_chg_level      = eng_chg_level_
         AND waiv_dev_rej_no    = waiv_dev_rej_no_
         AND activity_seq       = activity_seq_
         AND handling_unit_id   = handling_unit_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         GROUP BY transport_task_id
         HAVING SUM(quantity) = quantity_;

BEGIN

   IF (stock_keys_tab_.COUNT > 0) THEN
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         OPEN get_transport_task_id(stock_keys_tab_(i).contract,
                                            stock_keys_tab_(i).part_no,
                                            stock_keys_tab_(i).configuration_id,
                                            stock_keys_tab_(i).location_no,
                                            stock_keys_tab_(i).lot_batch_no,
                                            stock_keys_tab_(i).serial_no,
                                            stock_keys_tab_(i).eng_chg_level,
                                            stock_keys_tab_(i).waiv_dev_rej_no,
                                            stock_keys_tab_(i).activity_seq,
                                            stock_keys_tab_(i).handling_unit_id,
                                            stock_keys_tab_(i).quantity);
         FETCH get_transport_task_id INTO temp_transport_task_id_;

         IF (get_transport_task_id%found) THEN
            IF (transport_task_id_ IS NULL) THEN
               transport_task_id_ := temp_transport_task_id_;
            ELSIF (transport_task_id_ != temp_transport_task_id_) then
               transport_task_id_ := NULL;
               CLOSE get_transport_task_id;
               EXIT;
            END IF;
         ELSE
            transport_task_id_ := NULL;
            CLOSE get_transport_task_id;
            EXIT;
         END IF;
         CLOSE get_transport_task_id;
      END LOOP;
   END IF;
   RETURN transport_task_id_;
END Get_Transport_Task_Id;

 
-- Returns a unique destination site, if it can be fetched from inventory part in stock collection 
-- that belongs to a certain handling unit structure. Called from HandlingUnit.
FUNCTION Get_Unique_Destination_Site (
   stock_keys_tab_   IN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab ) RETURN VARCHAR2
IS
   temp_to_contract_ transport_task_line_tab.to_contract%TYPE;
   to_contract_      transport_task_line_tab.to_contract%TYPE;

   CURSOR get_to_contract(from_contract_    VARCHAR2,
                          part_no_          VARCHAR2,
                          configuration_id_ VARCHAR2,
                          from_location_no_ VARCHAR2,
                          lot_batch_no_     VARCHAR2,
                          serial_no_        VARCHAR2,
                          eng_chg_level_    VARCHAR2,
                          waiv_dev_rej_no_  VARCHAR2,
                          activity_seq_     NUMBER,
                          handling_unit_id_ NUMBER,
                          quantity_         NUMBER) IS
      SELECT to_contract
        FROM transport_task_line_tab
       WHERE from_contract      = from_contract_
         AND part_no            = part_no_
         AND configuration_id   = configuration_id_
         AND from_location_no   = from_location_no_
         AND lot_batch_no       = lot_batch_no_
         AND serial_no          = serial_no_
         AND eng_chg_level      = eng_chg_level_
         AND waiv_dev_rej_no    = waiv_dev_rej_no_
         AND activity_seq       = activity_seq_
         AND handling_unit_id   = handling_unit_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         GROUP BY to_contract
         HAVING SUM(quantity) = quantity_;

BEGIN

   IF (stock_keys_tab_.COUNT > 0) THEN
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         OPEN get_to_contract(stock_keys_tab_(i).contract,
                              stock_keys_tab_(i).part_no,
                              stock_keys_tab_(i).configuration_id,
                              stock_keys_tab_(i).location_no,
                              stock_keys_tab_(i).lot_batch_no,
                              stock_keys_tab_(i).serial_no,
                              stock_keys_tab_(i).eng_chg_level,
                              stock_keys_tab_(i).waiv_dev_rej_no,
                              stock_keys_tab_(i).activity_seq,
                              stock_keys_tab_(i).handling_unit_id,
                              stock_keys_tab_(i).quantity);
         FETCH get_to_contract INTO temp_to_contract_;

         IF (get_to_contract%FOUND) THEN
            IF (to_contract_ IS NULL) THEN
               to_contract_ := temp_to_contract_;
            ELSIF (to_contract_ != temp_to_contract_) then
               to_contract_ := NULL;
               CLOSE get_to_contract;
               EXIT;
            END IF;
         ELSE
            to_contract_ := NULL;
            CLOSE get_to_contract;
            EXIT;
         END IF;
         CLOSE get_to_contract;
      END LOOP;
   END IF;
   RETURN to_contract_;
END Get_Unique_Destination_Site;

 
-- This method is dependant on that a handling unit stock snapshot have been made recently for this transport task, 
-- if not it will show old data or NULL if no snapshot exist at all.
@UncheckedAccess
FUNCTION Get_Outermost_Handling_Unit_Id (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER ) RETURN NUMBER
IS 
   rec_ TRANSPORT_TASK_LINE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(transport_task_id_, line_no_);
   IF (rec_.handling_unit_id = 0) THEN
      RETURN NULL;
   ELSE
      RETURN Handl_Unit_Stock_Snapshot_API.Get_Outermost_Hu_Id(source_ref1_         => transport_task_id_,
                                                               source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK,
                                                               handling_unit_id_    => rec_.handling_unit_id); 
   END IF;
END Get_Outermost_Handling_Unit_Id;


PROCEDURE Add_Tasks_To_Hu_Refresh_List (
   stock_keys_tab_     IN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab,
   inventory_event_id_ IN NUMBER )
IS
   CURSOR get_transport_tasks(from_contract_    VARCHAR2,
                              part_no_          VARCHAR2,
                              configuration_id_ VARCHAR2,
                              from_location_no_ VARCHAR2,
                              lot_batch_no_     VARCHAR2,
                              serial_no_        VARCHAR2,
                              eng_chg_level_    VARCHAR2,
                              waiv_dev_rej_no_  VARCHAR2,
                              activity_seq_     NUMBER,
                              handling_unit_id_ NUMBER) IS
      SELECT DISTINCT transport_task_id
        FROM transport_task_line_tab
       WHERE from_contract          = from_contract_
         AND part_no                = part_no_
         AND configuration_id       = configuration_id_
         AND from_location_no       = from_location_no_
         AND lot_batch_no           = lot_batch_no_
         AND serial_no              = serial_no_
         AND eng_chg_level          = eng_chg_level_
         AND waiv_dev_rej_no        = waiv_dev_rej_no_
         AND activity_seq           = activity_seq_
         AND handling_unit_id       = handling_unit_id_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED);
BEGIN
   IF (stock_keys_tab_.COUNT > 0) THEN
      FOR i IN stock_keys_tab_.FIRST..stock_keys_tab_.LAST LOOP
         FOR rec_ IN get_transport_tasks (stock_keys_tab_(i).contract,
                                          stock_keys_tab_(i).part_no,
                                          stock_keys_tab_(i).configuration_id,
                                          stock_keys_tab_(i).location_no,
                                          stock_keys_tab_(i).lot_batch_no,
                                          stock_keys_tab_(i).serial_no,
                                          stock_keys_tab_(i).eng_chg_level,
                                          stock_keys_tab_(i).waiv_dev_rej_no,
                                          stock_keys_tab_(i).activity_seq,
                                          stock_keys_tab_(i).handling_unit_id) LOOP
            Hu_Snapshot_For_Refresh_API.New(source_ref1_        => rec_.transport_task_id,
                                            source_ref_type_db_ => Handl_Unit_Snapshot_Type_API.DB_TRANSPORT_TASK,
                                            inventory_event_id_ => inventory_event_id_);
         END LOOP;
      END LOOP;      
   END IF;
END Add_Tasks_To_Hu_Refresh_List;


FUNCTION Lines_FwdToLoc_Created_Exist (
   transport_task_id_ IN NUMBER ) RETURN NUMBER
IS
   exists_ NUMBER;
   
   CURSOR check_lines_exist IS
      SELECT 1
        FROM transport_task_line_tab t
        WHERE transport_task_id = transport_task_id_         
         AND forward_to_location_no IS NOT NULL
         AND transport_task_status = Transport_Task_Status_API.DB_CREATED;

BEGIN
   OPEN  check_lines_exist;
   FETCH check_lines_exist INTO exists_;
   CLOSE check_lines_exist;
   
   RETURN nvl(exists_, 0);
END Lines_FwdToLoc_Created_Exist;

@UncheckedAccess
FUNCTION Handl_Unit_Exist_On_Trans_Task (
   transport_task_id_ IN NUMBER,
   handling_unit_id_  IN NUMBER ) RETURN BOOLEAN
IS
   hu_exist_  BOOLEAN := FALSE;
   dummy_     NUMBER;
   CURSOR check_if_hu_exist_ IS
      SELECT 1 
      FROM  transport_task_line_tab 
      WHERE transport_task_id = transport_task_id_
      AND   handling_unit_id = handling_unit_id_;
BEGIN
   OPEN check_if_hu_exist_;
   FETCH check_if_hu_exist_ INTO dummy_;
   IF (check_if_hu_exist_%FOUND) THEN
      hu_exist_ := TRUE;
   END IF;
   CLOSE check_if_hu_exist_;
   RETURN hu_exist_;
END Handl_Unit_Exist_On_Trans_Task;

PROCEDURE Get_Destination_Info (
   to_contract_            OUT VARCHAR2,
   to_location_no_         OUT VARCHAR2,
   to_destination_         OUT VARCHAR2,
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
   order_ref1_             IN VARCHAR2,
   order_ref2_             IN VARCHAR2,
   order_ref3_             IN VARCHAR2,
   order_ref4_             IN NUMBER,
   pick_list_no_           IN VARCHAR2,
   shipment_id_            IN NUMBER,   
   order_type_db_          IN VARCHAR2 )
IS
   CURSOR get_transport_task_info IS
      SELECT to_contract, to_location_no, destination
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE  order_ref1            = order_ref1_
         AND (order_ref2            = order_ref2_   OR order_ref2_   IS NULL)
         AND (order_ref3            = order_ref3_   OR order_ref3_   IS NULL)
         AND (order_ref4            = order_ref4_   OR order_ref4_   IS NULL)
         AND (pick_list_no          = pick_list_no_ OR pick_list_no_ IS NULL)
         AND (shipment_id           = shipment_id_  OR shipment_id_  IS NULL)         
         AND  order_type            = order_type_db_
         AND  from_contract         = from_contract_
         AND  part_no               = part_no_
         AND  configuration_id      = configuration_id_
         AND  from_location_no      = from_location_no_
         AND  lot_batch_no          = lot_batch_no_
         AND  serial_no             = serial_no_
         AND  eng_chg_level         = eng_chg_level_
         AND  waiv_dev_rej_no       = waiv_dev_rej_no_
         AND  activity_seq          = activity_seq_
         AND  handling_unit_id      = handling_unit_id_
         AND  transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND  reserved_by_source     = Fnd_Boolean_API.DB_TRUE;
BEGIN
   OPEN  get_transport_task_info;
   FETCH get_transport_task_info INTO to_contract_, to_location_no_, to_destination_;
   CLOSE get_transport_task_info;
   
END Get_Destination_Info;


PROCEDURE Find_And_Remove (
   removed_rec_tab_               OUT Public_Rec_Tab,
   from_location_no_              IN  VARCHAR2,
   lot_batch_no_                  IN  VARCHAR2,
   serial_no_                     IN  VARCHAR2,
   eng_chg_level_                 IN  VARCHAR2,
   waiv_dev_rej_no_               IN  VARCHAR2,
   configuration_id_              IN  VARCHAR2,
   activity_seq_                  IN  NUMBER,
   handling_unit_id_              IN  NUMBER,
   from_contract_                 IN  VARCHAR2,
   part_no_                       IN  VARCHAR2,
   from_location_type_db_         IN  VARCHAR2,
   auto_reservation_db_           IN  VARCHAR2,
   order_issue_db_                IN  VARCHAR2,
   project_id_                    IN  VARCHAR2,
   condition_code_                IN  VARCHAR2,
   part_ownership_db_             IN  VARCHAR2,
   owning_vendor_no_              IN  VARCHAR2,
   owning_customer_no_            IN  VARCHAR2,
   expiration_control_date_       IN  DATE,
   include_temp_table_locs_       IN  BOOLEAN,
   warehouse_id_                  IN  VARCHAR2,
   ignore_this_avail_control_id_  IN  VARCHAR2 )   
IS
   location_tmp_exists_           NUMBER;
   include_tmp_locations_         VARCHAR2(5) := db_false_;
   exclude_tmp_locations_         VARCHAR2(5) := db_false_;
   today_                         DATE := TRUNC(Site_API.Get_Site_Date(from_contract_));
   last_calendar_date_            DATE := Database_Sys.last_calendar_date_;
   public_rec_                    Public_Rec;
   index_                         PLS_INTEGER := 0;

   CURSOR get_location_tmp IS
      SELECT 1
      FROM inventory_location_tmp;

   CURSOR get_line_keys IS
      SELECT transport_task_id, line_no
      FROM transport_task_line_tab ttl
      WHERE ttl.transport_task_status      = Transport_Task_Status_API.DB_CREATED
        AND ttl.from_contract              = ttl.to_contract
        AND ttl.destination                = Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY
        AND ttl.allow_deviating_avail_ctrl = Fnd_Boolean_API.DB_FALSE
        AND ttl.reserved_by_source         = Fnd_Boolean_API.DB_FALSE
        AND ttl.order_type                 IS NULL 
        AND ttl.order_ref1                 IS NULL
        AND NOT EXISTS (SELECT 1
                         FROM warehouse_task_tab wt
                        WHERE wt.contract       = ttl.from_contract
                          AND wt.task_type      = Warehouse_Task_Type_API.DB_TRANSPORT_TASK
                          AND wt.source_ref1    = TO_CHAR(ttl.transport_task_id)
                          AND wt.rowstate      IN ('Started', 'Parked'))
        AND EXISTS (SELECT 1 
                      FROM inventory_part_in_stock_total ipis
                     WHERE ttl.from_contract    = ipis.contract
                       AND ttl.part_no          = ipis.part_no
                       AND ttl.configuration_id = ipis.configuration_id
                       AND ttl.from_location_no = ipis.location_no
                       AND ttl.lot_batch_no     = ipis.lot_batch_no
                       AND ttl.serial_no        = ipis.serial_no
                       AND ttl.eng_chg_level    = ipis.eng_chg_level
                       AND ttl.waiv_dev_rej_no  = ipis.waiv_dev_rej_no
                       AND ttl.activity_seq     = ipis.activity_seq
                       AND ttl.handling_unit_id = ipis.handling_unit_id
                       AND (((ipis.part_reservation_control_db     = auto_reservation_db_ OR auto_reservation_db_ IS NULL)
                             AND (ipis.part_order_issue_control_db = order_issue_db_      OR order_issue_db_      IS NULL))
                             OR (ipis.availability_control_id      = ignore_this_avail_control_id_))         
                       AND (ipis.condition_code = condition_code_ OR condition_code_ IS NULL)
                       AND ((ipis.part_ownership_db  = Part_Ownership_API.DB_COMPANY_OWNED        AND part_ownership_db_ = Part_Ownership_API.DB_COMPANY_OWNED)
                        OR  (ipis.part_ownership_db  = Part_Ownership_API.DB_COMPANY_OWNED        AND part_ownership_db_ = 'COMPANY OWNED NOT CONSIGNMENT')
                        OR  (ipis.part_ownership_db  = Part_Ownership_API.DB_CONSIGNMENT          AND part_ownership_db_ = Part_Ownership_API.DB_COMPANY_OWNED)
                        OR  (ipis.part_ownership_db  = Part_Ownership_API.DB_CONSIGNMENT          AND part_ownership_db_ = Part_Ownership_API.DB_CONSIGNMENT     AND
                             ipis.owning_vendor_no   = NVL(owning_vendor_no_,string_null_))
                        OR  (ipis.part_ownership_db  = Part_Ownership_API.DB_SUPPLIER_LOANED      AND part_ownership_db_ = Part_Ownership_API.DB_SUPPLIER_LOANED AND
                             ipis.owning_vendor_no   = NVL(owning_vendor_no_,string_null_))
                        OR  (ipis.part_ownership_db  = Part_Ownership_API.DB_CUSTOMER_OWNED       AND part_ownership_db_ = Part_Ownership_API.DB_CUSTOMER_OWNED  AND
                             ipis.owning_customer_no = NVL(owning_customer_no_,string_null_))
                        OR  (ipis.part_ownership_db  = Part_Ownership_API.DB_SUPPLIER_RENTED      AND part_ownership_db_ = Part_Ownership_API.DB_SUPPLIER_RENTED AND
                             (owning_vendor_no_ IS NULL OR ipis.owning_vendor_no = owning_vendor_no_))
                        OR  (ipis.part_ownership_db  = Part_Ownership_API.DB_COMPANY_RENTAL_ASSET AND part_ownership_db_ = Part_Ownership_API.DB_COMPANY_RENTAL_ASSET))
                       AND NVL(ipis.expiration_date, last_calendar_date_) > NVL(expiration_control_date_, today_)
                       AND ipis.location_type_db IN (Inventory_Location_Type_API.DB_PICKING,
                                                Inventory_Location_Type_API.DB_FLOOR_STOCK,
                                                Inventory_Location_Type_API.DB_PRODUCTION_LINE)
                       AND (ipis.location_type_db = from_location_type_db_ OR from_location_type_db_ IS NULL)
                       AND (ipis.eng_chg_level    = eng_chg_level_         OR eng_chg_level_         IS NULL)
                       AND (ipis.serial_no        = serial_no_             OR serial_no_             IS NULL)
                       AND (ipis.lot_batch_no     = lot_batch_no_          OR lot_batch_no_          IS NULL)
                       AND ((ipis.location_no     IN (SELECT tmp2.location_no FROM inventory_location_tmp tmp2)) OR (include_tmp_locations_ = db_false_))
                       AND ((ipis.location_no NOT IN (SELECT tmp2.location_no FROM inventory_location_tmp tmp2)) OR (exclude_tmp_locations_ = db_false_))
                       AND (ipis.location_no      = from_location_no_      OR from_location_no_      IS NULL)
                       AND (ipis.warehouse        = warehouse_id_          OR warehouse_id_          IS NULL)
                       AND (ipis.waiv_dev_rej_no  = waiv_dev_rej_no_       OR waiv_dev_rej_no_       IS NULL)
                       AND (ipis.configuration_id = configuration_id_      OR configuration_id_      IS NULL)
                       AND (ipis.activity_seq     = activity_seq_          OR activity_seq_          IS NULL)
                       AND (ipis.handling_unit_id = handling_unit_id_      OR handling_unit_id_      IS NULL)
                       AND (NVL(ipis.project_id, string_null_) = NVL(project_id_, string_null_) OR activity_seq_ IS NOT NULL)
                       AND ipis.part_no           = part_no_
                       AND ipis.contract          = from_contract_)
      ORDER BY ttl.quantity DESC
      FOR UPDATE;
      
   TYPE Line_Key_Tab IS TABLE OF get_line_keys%ROWTYPE INDEX BY PLS_INTEGER;
   line_key_tab_ Line_Key_Tab;
BEGIN      
   OPEN get_location_tmp;
   FETCH get_location_tmp INTO location_tmp_exists_;
      IF get_location_tmp%FOUND THEN
         IF (include_temp_table_locs_) THEN
            include_tmp_locations_ := db_true_;
         ELSE
            exclude_tmp_locations_ := db_true_;
         END IF;
      END IF;
   CLOSE get_location_tmp;
   
   OPEN  get_line_keys;
   FETCH get_line_keys BULK COLLECT INTO line_key_tab_;
   CLOSE get_line_keys;

   IF (line_key_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;   
      FOR i IN line_key_tab_.FIRST..line_key_tab_.LAST LOOP
         public_rec_ := Get(line_key_tab_(i).transport_task_id, line_key_tab_(i).line_no);
         IF NOT (Destination_Is_Remote_Whse___(public_rec_.to_contract, public_rec_.to_location_no, public_rec_.forward_to_location_no)) THEN
            index_                   := index_ + 1;
            removed_rec_tab_(index_) := public_rec_;

            Remove(transport_task_id_  => line_key_tab_(i).transport_task_id,
                   line_no_            => line_key_tab_(i).line_no,
                   remove_reservation_ => TRUE,
                   remove_empty_task_  => FALSE);
         END IF;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Find_And_Remove;


PROCEDURE Handle_Stock_Reservat_Result (
   stock_reservation_tab_ IN OUT Inventory_Part_In_Stock_API.Keys_And_Qty_Tab,
   removed_rec_tab_       IN     Public_Rec_Tab )
IS
   dummy_number_                 NUMBER;
   dummy_tab_                    Part_Serial_Catalog_API.Serial_No_Tab;
   serial_no_tab_                Part_Serial_Catalog_API.Serial_No_Tab;
   quantity_to_add_              NUMBER;
   catch_quantity_to_add_        NUMBER;
   move_reservation_option_db_   VARCHAR2(20);
   local_removed_rec_tab_        Public_Rec_Tab;
   sum_removed_tt_line_qty_      NUMBER;
   qty_consumed_from_tt_lines_   NUMBER;
   qty_to_remove_from_this_line_ NUMBER;
   qty_avail_before_this_res_    NUMBER;
   current_qty_available_        NUMBER;
   current_stock_rec_            Inventory_Part_In_Stock_API.Public_Rec;
BEGIN
   local_removed_rec_tab_ := removed_rec_tab_; 
   IF (local_removed_rec_tab_.COUNT > 0) THEN
      IF (stock_reservation_tab_.COUNT > 0) THEN
         FOR i IN stock_reservation_tab_.FIRST..stock_reservation_tab_.LAST LOOP
            -- Fetch the total quantity moved away from this stock record by the removed transport task lines
            sum_removed_tt_line_qty_ := Get_Sum_Removed_Tt_Line_Qty___(stock_reservation_tab_(i), local_removed_rec_tab_);

            IF (sum_removed_tt_line_qty_ > 0) THEN
               -- Fetch the current stock availability situation, including this and other reservations
               current_stock_rec_ := Inventory_Part_In_Stock_API.Get(stock_reservation_tab_(i).contract,
                                                                     stock_reservation_tab_(i).part_no,
                                                                     stock_reservation_tab_(i).configuration_id,
                                                                     stock_reservation_tab_(i).location_no,
                                                                     stock_reservation_tab_(i).lot_batch_no,
                                                                     stock_reservation_tab_(i).serial_no,
                                                                     stock_reservation_tab_(i).eng_chg_level,
                                                                     stock_reservation_tab_(i).waiv_dev_rej_no,
                                                                     stock_reservation_tab_(i).activity_seq,
                                                                     stock_reservation_tab_(i).handling_unit_id);

               current_qty_available_      := current_stock_rec_.qty_onhand - current_stock_rec_.qty_reserved;
               qty_avail_before_this_res_  := current_qty_available_ + stock_reservation_tab_(i).quantity - sum_removed_tt_line_qty_;
               -- The quantity that was consumed from TT Lines is the difference between what was 
               qty_consumed_from_tt_lines_ := GREATEST(stock_reservation_tab_(i).quantity - qty_avail_before_this_res_, 0);

               IF (qty_consumed_from_tt_lines_ > 0) THEN
                  FOR j IN local_removed_rec_tab_.FIRST..local_removed_rec_tab_.LAST LOOP
                     IF ((stock_reservation_tab_(i).contract         = local_removed_rec_tab_(j).from_contract   ) AND 
                         (stock_reservation_tab_(i).part_no          = local_removed_rec_tab_(j).part_no         ) AND 
                         (stock_reservation_tab_(i).configuration_id = local_removed_rec_tab_(j).configuration_id) AND 
                         (stock_reservation_tab_(i).location_no      = local_removed_rec_tab_(j).from_location_no) AND 
                         (stock_reservation_tab_(i).lot_batch_no     = local_removed_rec_tab_(j).lot_batch_no    ) AND 
                         (stock_reservation_tab_(i).serial_no        = local_removed_rec_tab_(j).serial_no       ) AND 
                         (stock_reservation_tab_(i).eng_chg_level    = local_removed_rec_tab_(j).eng_chg_level   ) AND 
                         (stock_reservation_tab_(i).waiv_dev_rej_no  = local_removed_rec_tab_(j).waiv_dev_rej_no ) AND 
                         (stock_reservation_tab_(i).activity_seq     = local_removed_rec_tab_(j).activity_seq    ) AND 
                         (stock_reservation_tab_(i).handling_unit_id = local_removed_rec_tab_(j).handling_unit_id)) THEN

                        IF ((local_removed_rec_tab_(j).quantity >= stock_reservation_tab_(i).quantity) AND 
                            (qty_consumed_from_tt_lines_        >= stock_reservation_tab_(i).quantity)) THEN 
                           IF (move_reservation_option_db_ IS NULL) THEN
                              move_reservation_option_db_ := Site_Invent_Info_API.Get_Move_Reservation_Option_Db(stock_reservation_tab_(i).contract);
                           END IF;
                           IF (move_reservation_option_db_ != Reservat_Adjustment_Option_API.DB_NOT_ALLOWED) THEN
                              -- Move of reserved stock is allowed, so add destination and transport task ID to the reservation record.
                              stock_reservation_tab_(i).transport_task_id := local_removed_rec_tab_(j).transport_task_id;
                              stock_reservation_tab_(i).to_location_no    := NVL(local_removed_rec_tab_(j).forward_to_location_no,
                                                                                 local_removed_rec_tab_(j).to_location_no);
                           END IF;
                        END IF;
                        -- Calculate the quantity with which we reduce this particular transport task line.
                        qty_to_remove_from_this_line_      := LEAST(qty_consumed_from_tt_lines_, local_removed_rec_tab_(j).quantity);
                        local_removed_rec_tab_(j).quantity := local_removed_rec_tab_(j).quantity - qty_to_remove_from_this_line_;
                        qty_consumed_from_tt_lines_        := qty_consumed_from_tt_lines_        - qty_to_remove_from_this_line_;

                        IF (qty_to_remove_from_this_line_ > 0) THEN
                           local_removed_rec_tab_(j).catch_quantity := NULL;
                        END IF;
                     END IF;
                        EXIT WHEN qty_consumed_from_tt_lines_ = 0;
                  END LOOP;
               END IF;
            END IF;
         END LOOP;
      END IF;

      FOR i IN local_removed_rec_tab_.FIRST..local_removed_rec_tab_.LAST LOOP
         IF (local_removed_rec_tab_(i).quantity > 0) THEN
            IF (local_removed_rec_tab_(i).serial_no = '*') THEN
               quantity_to_add_       := local_removed_rec_tab_(i).quantity;
               catch_quantity_to_add_ := local_removed_rec_tab_(i).catch_quantity;
               serial_no_tab_.DELETE;
            ELSE
               serial_no_tab_(1).serial_no := local_removed_rec_tab_(i).serial_no;
               quantity_to_add_            := NULL;
               catch_quantity_to_add_      := NULL;
            END IF;
            New_Or_Add_To_Existing_(quantity_added_             => dummy_number_,
                                    serials_added_              => dummy_tab_,
                                    transport_task_id_          => local_removed_rec_tab_(i).transport_task_id,
                                    part_no_                    => local_removed_rec_tab_(i).part_no,
                                    configuration_id_           => local_removed_rec_tab_(i).configuration_id,
                                    from_contract_              => local_removed_rec_tab_(i).from_contract,
                                    from_location_no_           => local_removed_rec_tab_(i).from_location_no,
                                    to_contract_                => local_removed_rec_tab_(i).to_contract,
                                    to_location_no_             => local_removed_rec_tab_(i).to_location_no,
                                    forward_to_location_no_     => local_removed_rec_tab_(i).forward_to_location_no,
                                    destination_db_             => local_removed_rec_tab_(i).destination,
                                    order_type_db_              => local_removed_rec_tab_(i).order_type,
                                    order_ref1_                 => local_removed_rec_tab_(i).order_ref1,
                                    order_ref2_                 => local_removed_rec_tab_(i).order_ref2,
                                    order_ref3_                 => local_removed_rec_tab_(i).order_ref3,
                                    order_ref4_                 => local_removed_rec_tab_(i).order_ref4,
                                    pick_list_no_               => local_removed_rec_tab_(i).pick_list_no,
                                    shipment_id_                => local_removed_rec_tab_(i).shipment_id,
                                    lot_batch_no_               => local_removed_rec_tab_(i).lot_batch_no,
                                    serial_no_tab_              => serial_no_tab_,
                                    eng_chg_level_              => local_removed_rec_tab_(i).eng_chg_level,
                                    waiv_dev_rej_no_            => local_removed_rec_tab_(i).waiv_dev_rej_no,
                                    activity_seq_               => local_removed_rec_tab_(i).activity_seq,
                                    handling_unit_id_           => local_removed_rec_tab_(i).handling_unit_id,
                                    quantity_to_add_            => quantity_to_add_,
                                    catch_quantity_to_add_      => catch_quantity_to_add_,
                                    requested_date_finished_    => NULL,
                                    allow_deviating_avail_ctrl_ => local_removed_rec_tab_(i).allow_deviating_avail_ctrl,
                                    reserved_by_source_db_      => local_removed_rec_tab_(i).reserved_by_source);
         END IF;
      END LOOP;
   END IF;
END Handle_Stock_Reservat_Result;


@UncheckedAccess
FUNCTION Can_Be_Used_For_Reservation_Db (
   transport_task_id_ IN NUMBER,
   line_no_           IN NUMBER ) RETURN VARCHAR2
IS
   can_be_used_for_reservat_db_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   stock_rec_                   Inventory_Part_In_Stock_API.Public_Rec;
   rec_                         transport_task_line_tab%ROWTYPE;
   last_calendar_date_          DATE := Database_Sys.last_calendar_date_;
BEGIN
   rec_ := Get_Object_By_Keys___(transport_task_id_, line_no_);

   IF ((rec_.transport_task_status      = Transport_Task_Status_API.DB_CREATED               ) AND
       (rec_.from_contract              = rec_.to_contract                                   ) AND
       (rec_.destination                = Inventory_Part_Destination_API.DB_MOVE_TO_INVENTORY) AND
       (rec_.allow_deviating_avail_ctrl = Fnd_Boolean_API.DB_FALSE                           ) AND
       (rec_.reserved_by_source         = Fnd_Boolean_API.DB_FALSE                           ) AND
       (rec_.order_type                IS NULL                                               ) AND
       (rec_.order_ref1                IS NULL                                               )) THEN
      IF NOT (Warehouse_Task_API.Source_Task_Started_Or_Parked(rec_.from_contract, 
                                                               Warehouse_Task_Type_API.Decode(Warehouse_Task_Type_API.DB_TRANSPORT_TASK),
                                                               rec_.transport_task_id,
                                                               NULL,
                                                               NULL,
                                                               NULL)) THEN
         stock_rec_ := Inventory_Part_In_Stock_API.Get(contract_         => rec_.from_contract,        
                                                       part_no_          => rec_.part_no,         
                                                       configuration_id_ => rec_.configuration_id,
                                                       location_no_      => rec_.from_location_no,     
                                                       lot_batch_no_     => rec_.lot_batch_no,    
                                                       serial_no_        => rec_.serial_no,       
                                                       eng_chg_level_    => rec_.eng_chg_level,   
                                                       waiv_dev_rej_no_  => rec_.waiv_dev_rej_no, 
                                                       activity_seq_     => rec_.activity_seq,    
                                                       handling_unit_id_ => rec_.handling_unit_id);
         IF stock_rec_.location_type IN (Inventory_Location_Type_API.DB_PICKING,
                                         Inventory_Location_Type_API.DB_FLOOR_STOCK,
                                         Inventory_Location_Type_API.DB_PRODUCTION_LINE) THEN
            IF (NVL(stock_rec_.expiration_date, last_calendar_date_) > TRUNC(Site_API.Get_Site_Date(stock_rec_.contract))) THEN
               IF (Part_Availability_Control_API.Check_Reservation_Control(stock_rec_.availability_control_id) =
                   Part_Reservation_Control_API.DB_AUTO_RESERVATION) THEN
                  can_be_used_for_reservat_db_ := Fnd_Boolean_API.DB_TRUE;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN(can_be_used_for_reservat_db_);
END Can_Be_Used_For_Reservation_Db;

@UncheckedAccess
FUNCTION Get_Transport_Task_Id (
   from_contract_                IN VARCHAR2,
   from_location_no_             IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,
   order_ref1_                   IN VARCHAR2,
   order_ref2_                   IN VARCHAR2,
   order_ref3_                   IN VARCHAR2,
   order_ref4_                   IN NUMBER,
   pick_list_no_                 IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   order_supply_demand_type_db_  IN VARCHAR2 ) RETURN NUMBER
IS
   transport_task_id_     NUMBER;
   local_ord_sup_demand_type_db_   VARCHAR2(20);
   order_type_db_                  VARCHAR2(20);
   local_source_ref1_              transport_task_line_tab.order_ref1%TYPE;
   local_source_ref2_              transport_task_line_tab.order_ref2%TYPE;
   local_source_ref3_              transport_task_line_tab.order_ref3%TYPE;
   local_source_ref4_              transport_task_line_tab.order_ref4%TYPE;
   CURSOR get_transport_task_id IS
      SELECT transport_task_id
        FROM TRANSPORT_TASK_LINE_TAB
       WHERE from_contract                    = from_contract_
         AND from_location_no                 = from_location_no_
         AND part_no                          = part_no_
         AND configuration_id                 = configuration_id_
         AND lot_batch_no                     = lot_batch_no_
         AND serial_no                        = serial_no_
         AND eng_chg_level                    = eng_chg_level_
         AND waiv_dev_rej_no                  = waiv_dev_rej_no_
         AND activity_seq                     = activity_seq_
         AND handling_unit_id                 = handling_unit_id_
         AND reserved_by_source               = Fnd_Boolean_API.DB_TRUE
         AND order_type                       = order_type_db_
         AND transport_task_status IN (Transport_Task_Status_API.DB_CREATED, Transport_Task_Status_API.DB_PICKED)
         AND order_ref1                       = local_source_ref1_
         AND NVL(order_ref2, string_null_)    = NVL(local_source_ref2_,    string_null_)
         AND NVL(order_ref3, string_null_)    = NVL(local_source_ref3_,    string_null_)
         AND NVL(order_ref4, number_null_)    = NVL(local_source_ref4_,    number_null_)
         AND NVL(pick_list_no, string_null_)  = NVL(pick_list_no_,  string_null_)
         AND NVL(shipment_id, number_null_)   = NVL(shipment_id_,   number_null_);
BEGIN
   IF order_supply_demand_type_db_ = Order_Supply_Demand_Type_API.DB_DISTRIBUTION_ORDER THEN
      local_ord_sup_demand_type_db_ := Order_Supply_Demand_Type_API.DB_CUST_ORDER;
      $IF Component_Disord_SYS.INSTALLED $THEN
         Distribution_Order_API.Get_Customer_Order_Info(order_no_     => local_source_ref1_,
                                                        line_no_      => local_source_ref2_,
                                                        rel_no_       => local_source_ref3_,
                                                        line_item_no_ => local_source_ref4_,
                                                        do_order_no_  => order_ref1_);
      $ELSE
         Error_SYS.Component_Not_Exist('DISORD');
      $END
   ELSE
      local_source_ref1_            := order_ref1_;
      local_source_ref2_            := order_ref2_;
      local_source_ref3_            := order_ref3_;
      local_source_ref4_            := order_ref4_;
      local_ord_sup_demand_type_db_ := order_supply_demand_type_db_;
   END IF;
   order_type_db_ := Order_Supply_Demand_Type_API.Get_Order_Type_Db(local_ord_sup_demand_type_db_);
   OPEN get_transport_task_id;
   FETCH get_transport_task_id INTO transport_task_id_;
   CLOSE get_transport_task_id;
   
   RETURN transport_task_id_;
END Get_Transport_Task_Id;

PROCEDURE Raise_Res_Is_On_Trans_Task
IS
BEGIN
   Error_SYS.Record_General('TransportTaskLine', 'RESBOOKEDFORTRANSPORT: The reservation is already booked for transport.');
END Raise_Res_Is_On_Trans_Task;

FUNCTION Get_Trans_Task_Line_Details (
   transport_task_id_  IN NUMBER,
   line_no_            IN NUMBER ) RETURN trans_task_line_details_arr PIPELINED
IS
   rec_     trans_task_line_details_rec;
BEGIN
   rec_.unit_meas                  := Transport_Task_Line_API.Get_Unit_Meas(transport_task_id_, line_no_);
   rec_.catch_unit_meas            := Transport_Task_Line_API.Get_Catch_Unit_Meas(transport_task_id_, line_no_);
   rec_.catch_qty_required         := Transport_Task_Line_API.Catch_Quantity_Required(transport_task_id_, line_no_);
   rec_.available_to_reserve       := Transport_Task_Line_API.Can_Be_Used_For_Reservation_Db(transport_task_id_, line_no_);
   rec_.no_of_unidentified_serials := Transport_Task_Line_API.Get_No_Of_Unidentified_Serials(transport_task_id_, line_no_);
   rec_.warehouse_task_started     := Transport_Task_Manager_API.Warehouse_Task_Is_Started_Db(transport_task_id_); 
   rec_.outermost_hu_id            := Transport_Task_Line_API.Get_Outermost_Handling_Unit_Id(transport_task_id_, line_no_);
   rec_.outermost_hu_type_id       := Handling_Unit_API.Get_Handling_Unit_Type_Id(rec_.outermost_hu_id);
   rec_.outermost_hu_type_desc     := Handling_Unit_Type_API.Get_Description(rec_.outermost_hu_type_id);
   rec_.outermost_sscc             := Handling_Unit_API.Get_Sscc(rec_.outermost_hu_id);
   rec_.outermost_alt_hu_label_id  := Handling_Unit_API.Get_Alt_Handling_Unit_Label_Id(rec_.outermost_hu_id);
   PIPE ROW (rec_);
END Get_Trans_Task_Line_Details;
