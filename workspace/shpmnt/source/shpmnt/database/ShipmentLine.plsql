-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentLine
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign   History
--  ------  ------ ---------------------------------------------------------
--  221103  AvWilk  SCDEV-17249, performance improvement,added Inventory_Event_Manager_API start and finish sessions into Connect_To_New_Handling_Units.
--  220706  AsZelk SCDEV-12319, Rephrase the SHIPMENTNOTREMOVE Error Message when canceling the shipment order line.
--  211215  RoJalk Bug 161942(SC21R2-7238), Modified Check_Update___ and removed the method call Shipment_Source_Utility_API.Validate_Update_Closed_Shipmnt 
--  211215         and related warning to allow modification of customs value even if the customer order line is invoiced. 
--  220118  Aabalk SC21R2-7235, Modified get_ship_info cursor in Get_Preliminary_Ship_Info by removing NVL on source_ref1 to improve performance.
--  220113  Diablk SC21R2-7062, Modified Check_Insert___.
--  211112  AsZelk SC21R2-3013, Added Get_Sum_Connected_Inv_Qty() function.
--  210716  ThKrlk SC21R2-1889, Modified Update_From_Source_Line() to calculate and update new_shipment_invent_qty_ only when passed inventory_qty_ is not NULL.
--  210623  ErRalk SC21R2-1651, Handled NVL for inventory_qty_ in Update_From_Source_Line.
--  210311  ChBnlk Bug 158364(SCZ-14195), Modified Check_Active_Shipment_Exist() to expand the cursor get_active_shipment without considering
--  210311         the NVL checks to improve the performance.
--  210325  ThKrlk Bug 157855(SCZ-14013), Modified Check_Update___() by adding new condition to skip unnecessary calculations on inventory_qty.
--  210325         And modified Update_From_Source_Line() to calculate new inventory quantity and update both new_shipment_source_qty_ and new_shipment_invent_qty_.
--  210218  RoJalk SC2020R1-11621, Modified Modify_On_Delivery to call Modify___ instead of Modify_Line___ method.
--  210217  RoJalk SC2020R1-11621, Modified Modify_Connected_Source_Qty___ to call Modify___ instead of Unpack methods.
--  210202  RasDlk SC2020R1-11817, Modified Reset_Printed_Flags___, and Connect_To_Shipment by reducing number of calls to increase the performance.
--  210126  RoJalk SC2020R1-11621, Modified New, Modify_Shipment_Stop__ to call New___, Modify___ instead of Unpack methods.
--  201008  ShVese SC2020R1-649, Added Nvl checks for source_ref2 and 3 in Fetch_Shipment_Id_By_Source.
--  201006  Aabalk SC2020R1-9946, Modified Get_Net_And_Adjusted_Volume___ in order to prevent a null value being returned for the volume.
--  200923  RoJalk SC2020R1-1673, Modified New_Line___ and removed the method call Get_Origin_Source_Part_Desc since logic is moved to Customer Order.
--  200820  ErRalk SC2020R1-1975, Added check in Check_Update___() to validate Connected_Source_Qty values for serial parts.
--  200703  SBalLK Bug 154469(SCZ-10454), Modified Connect_To_New_Handling_Units() method to generate SSCC codes for the handling units where Generate SSCC enabled.
--  200612  RasDlk SC2020R1-1926, ModifiedGet_Net_Weight and Get_Net_Volume by changing the parameter name to shipment_line_no_.
--  200529  AsZelk SC2020R1-1299, Added Get_Sum_Open_Shipment_qty method.
--  200417  ChFolk Bug 153255(SCZ-9758), Modified Connect_To_New_Handling_Units when mix_of_blocked exception is triggered.
--  200408  ChFolk Bug 153114(SCZ-8841), Modified Handle_Conn_Source_Qty_Chg___ by adding new parameters qty_modification_source_ and prev_inv_qty_ to the method call Shipment_Line_Handl_Unit_API.Remove_Or_Modify.
--  200325  DhAplk Bug 152713(SCZ-9267) Removed Shipment_API.Refresh_Values_On_Shipment() from Delete___ method.
--  200317  ChBnlk Bug 152898(SCZ-9183), Modified Reset_Printed_Flags___() to stop unsetting delivery note check and proforma invoice check
--  200317         when the shipment is already delivered.         
--  200211  ErFelk Bug 149159(SCZ-5814), Added a new function Fetch_Shipment_Id_By_Source().
--  200123  ChFolk Bug 152049(SCZ-8536), Modified Connect_To_New_Handling_Units to get the remaining qty from server instead of sending it from client to avoid using truncated value from client.
--  200120  MeAblk SCSPRING20-1770, Added method Get_Sum_Qty_Shipped().
--  191029  MeAblk SCSPRING20-196, Added Get_Sum_Connected_Source_Qty(). Generalized the delivery attributes validation in Connect_To_Shipment() for all source types.
--  190927  DaZase SCSPRING20-169, Added Raise_No_Hu_Capacity_Error___ and Raise_General_Error___ to solve MessageDefinitionValidation issues.
--  190524  ChBnlk Bug 145224(SCZ-1972), Modified Unreserve_Non_Inventory() in order to set the qty_to_ship in to 0 when the date is changed.
--  190104  AsZelk Bug 146137 (SCZ-2530), Modified Get_Sum_Reserved_Line() to fix performance issue when create consolidated pick lists.
--  181128  ChBnlk Bug 145590(SCZ-2016), Modified cursor shipment_lines_exist in Connect_To_Shipment() by removing the NVL check of sorce_ref1_ to improve performance.
--  181114  NiDalk Bug 144783, Added Get_Net_And_Adjusted_Volume___, Get_Net_Volume and Get_Net_Weight.
--  180911  KiSalk Bug 144201(SCZ-1029), Modified the cursor get_sum_qty_assigned in Get_Sum_Reserved_Line to always check against source_ref1 to improve performance.
--  180710  DiKuLk Bug 142190, Modified Check_Update___() to deliver only the connected qty for non-inventory parts.
--  180228  Nikplk STRSC-17339, Added Shipment_Reserv_Handl_Unit_API.Handling_Unit_Exist check into Pre_Delete_Actions___ method.
--  180228  RoJalk  STRSC-15133, Replaced Shipment_Line_API.Check_Reset_Printed_Flags__ with Shipment_API.Check_Reset_Printed_Flags.
--  180228  RoJalk STRSC-15133, Removed Check_Reset_Printed_Flags__ calls from Complete_Pkg_Reassignment__, 
--  180228         Reassign_Line__ and moved to methods in Reassign_Shipment_Utility_API.
--  180228  RoJalk STRSC-15133, Changed the scope of Check_Reset_Printed_Flags___ to be priveate.
--  180214  RoJalk STRSC-16574, Code improvements to the method Reset_Printed_Flags___. 
--  171108  RoJalk STRSC-13891, Added the method Check_Reset_Printed_Flags___.
--  171108  RoJalk STRSC-13891, Code improvements to the method Reset_Printed_Flags___.
--  170828  RoJalk STRSC-13808, Added the method Reset_Printed_Flags___.    
--  170828  RoJalk STRSC-11267, Modified Shipment_API.Reset_Printed_Flags__ method calls to include unset_address_label_print_  parameter.    
--  170823  RoJalk STRSC-11268, Modified the parameters to the Shipment_API.Reset_Printed_Flags__  call to reset
--  170823         delivery note printed flag in shipment during addition of lines and reassignment.
--  170522  NiDalk Bug 135715, Modified Check_Update___ to avoid error message quantity cannot be less than reserved quantity when picking. Also removed correction 134235.
--  170522  Jhalse LIM-11468, Modified Connect_To_Shipment to validate picked source line reservations were picked to shipment inventory.
--  170516  RoJalk LIM-11281, Modified Pre_Delete_Actions___ and replaced Pick_Shipment_API.Remove_Picked_Line
--  170516         with Shipment_Source_Utility_API.Remove_Picked_Line.
--  170515  RoJalk STRSC-8427, Modified Check_Delete___ and replaced Shipment_Source_Utility_API.Validate_Pick_List_Status
--                 with Pick_Shipment_API.Validate_Pick_List_Status.
--  170421  RoJalk LIM-11281, Modified Pre_Delete_Actions___ and replaced Shipment_Source_Utility_API.Remove_Picked_Line
--  170421         with Pick_Shipment_API.Remove_Picked_Line.
--  170314  MaIklk LIM-6946, Handled to raise message for PD when changing connected source qty. 
--  170310  MaIklk LIM-11026, Handled to consider only inventory qty change for PD when updating open shipment qty.
--  170208  KiSalk Bug 134235, Modified Check_Update___ and Update_On_Reserve not to raise error in overpicked scenario 
--  170208         if qty_modification_source_ is 'OVER_PICKED', because it is then  fully picking one from the set of splitted reservations. 
--  170127  MaIklk LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods and added Get_Converted_Source_Ref.
--  170124  MaRalk LIM-10490, Modified Check_Insert___ in order to provide default values for conv_factor and inverted_conv_factor.  
--  170111  MaRalk LIM-6755, Modified error messages SHIPVIACONNECT, DELTERMCONNECT, SHIPMENTTYPECONNECT in Connect_To_Shipment  
--  170111         in order to support generic shipment functionality.
--  170105  MaIklk LIM-8281, Removed Get_Lines_To_Pick_Shipment__(), since referenced client column is removed.
--  170104  MaIklk LIM-10190, Changed the Shipment_Source_Utility_API.Transfer_Line_Reservations() calls to Reserve_Shipment_API.Transfer_Line_Reservations().
--  170102  MaIklk LIM-8281, Removed existing Get_Lines_To_Pick_Shipment and renamed Get_Lines_To_Pick_Ordline to Get_Lines_To_Pick_Shipment and did modifications to make it generic.
--  161116  MaIklk LIM-9232, Used Reserve_Shipment_API methods for reservation related calls.
--  161102  MaRalk LIM-9129, Modified Modify_On_Delivery to change parameter names solrec_, solrec_pkg_rec_ as shipment_line_rec_ and shipment_line_pkg_rec_.
--  161026  RoJalk LIM-8391, Renamed Remove_Shipment_Line to Remove_By_Source___.
--  161010  RoJalk LIM-6944, Renamed Remove_From_Shipment___ to Pre_Delete_Actions___ .  Added methods 
--  161010         Handle_Conn_Source_Qty_Chg___, Modify_Source_Open_Ship_Qty___.
--  161003  SWeelk Bug 131145, Modified Check_Update__() by calculating inventory_qty unconditionally. Modified Check_Insert___() by recalculating inventory_qty if it is not equals to 0.
--  161003         Recalculated inventory_qty value is checked for its decimal length and if it exceeds 38 it's truncated to 38 which is safest maximum length of Oracle number decimal length. 
--  160831  RoJalk LIM-8563, Added the method Get_Source_Part_Desc_By_Source. 
--  160810  MaRalk LIM-6755, Modified the error messages SHIPLINEREMOVE, EXCEED_AVAILABLE_QTY, SHIPMENTCANCELLEDNEW,
--  160810         SHIPMENT_LINE_DELIVERED in order to support generic shipment functionality. Renamed SHIPMENT_LINE_DELIVERED as SHPMNTLINEDELIVERED.
--  160810         Modified some parameter names in Update_From_Source_Line method.
--  160802  MaIklk LIM-8217, Implemented to pass customs_value from CO when creating shipment.
--  160725  RoJalk LIM-8142, Replaced Shipment_Line_API.Connected_Lines_Exist with Shipment_API.Connected_Lines_Exist.
--  160725  RoJalk LIM-8141, Removed the method Check_Exist_Source and replaced the usages with Source_Exist. Added Source_Ref1_Exist.  
--  160607  RoJalk LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160606  RoJalk LIM-6794, Removed the method Reassign_Pkg_Comp__ and moved the logic to Reassign_Shipment_Utility_API.Reassign_Shipment_Pkg_Line___.
--  160603  RoJalk LIM-6794, Added the method Lock__.
--  160519  RoJalk LIM-7467, Added the parameter added_to_new_shipment_ to Connect_To_Shipment.
--  160520  RoJalk LIM-7478, Renamed Fetch_Shipment_Line_No___ to Fetch_Ship_Line_No_By_Source. 
--  160518  RoJalk LIM-7358, Modified Reassign_Connected_Qty__, Reassign_Pkg_Comp__ and redirected to Reassign_Shipment_Utility_API.
--  160516  RoJalk LIM-5280, Modified Reassign_Connected_Qty__ and removed  source_refs as parameters and fetched within the method. 
--  160511  RoJalk LIM-6964, Modified  Connect_To_New_Handling_Units and removed get_reserved_qty_connected since could not find a
--  160511         functioanl usage. Modified Update___ and adjusted the code related to PKG parts.
--  160506  RoJalk LIM-6964, Modified Connect_To_New_Handling_Units and called the generic method  
--  160506         Shipment_Source_Utility_API.Get_Reserved_Qty_Connected.
--  160503  RoJalk LIM-7310, Removed source info from Shipment_Line_Handl_Unit_API.Remove_Or_Modify method. 
--  160428  RoJalk LIM-6952, Removed Is_Charge_Allowed and replaced the usage with Check_Exist_Source.
--  160427  RoJalk LIM-6811, Move code related to reassignment to ReassignShipmentUtility.
--  160427  RoJalk LIM-6952, Removed unused method Get_Deliverable_Qty, Non_Inv_Comp_Exist_To_Deliver.  
--  160427  RoJalk LIM-6952, Renamed Shipment_Line_API.Get_Ordline_Qty_To_Ship to Shipment_Line_API.Get_Source_Line_Qty_To_Ship.
--  160427  RoJalk LIM-7267, Changed the parameter order of Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing.
--  160422  MaRalk LIM-7229, Modified Check_Update___ by calling  
--  160422         Shipment_Handling_Utility_API.Get_Converted_Inv_Qty instead of direct calculation.
--  160422         Modified Check_Update___, Update_Source_On_Reassign___, Connect_To_New_Handling_Units, Update_On_Reserve  
--  160422         by calling Shipment_Handling_Utility_API.Get_Converted_Source_Qty instead of direct calculation.
--  160412  RoJalk LIM-6631, Added NVL handling for source ref comparisons since it can be null.
--  160408  RoJalk LIM-6811, Renamed Add_Order_Line___ to New_Line___ , removed source info parameter from Update_Source_On_Reassign__.  
--  160401  RoJalk LIM-6562, Modified Connect_To_Shipment to moved the freight related code to Shipment_Order_Utility_API.Post_Connect_To_Shipment.
--  160331  RoJalk LIM-6804, Renamed Update_From_Order_Line to Update_From_Source_Line. 
--  160330  RoJalk LIM-6632, Modified Reassign_Line__ and renamed order ref to source ref.  
--  160330  RoJalk LIM-4651, Replaced the usage of Customer_Order_Reservation_API.Get_Total_Qty_Assigned with
--  160330         Shipment_Source_Utility_API.Get_Qty_Assigned_For_Source and Customer_Order_Reservation_API.Modify_Line_Reservations
--  160330         with Shipment_Source_Utility_API.Modify_Line_Reservations.
--  160329  RoJalk LIM-4649, Modified Release_Not_Reserved_Qty_Line and called Shipment_Order_Utility_API.Get_Max_Pkg_Comp_Reserved.
--  160328  MaRalk LIM-6591, Added source_unit_meas_, conv_factor, inverted_conv_factor to shipment_line_tab. 
--  160328         Added corresponding fields/as parameters to New_Line_Rec and Add_Order_Line___, Reassign_Line__ methods.
--  160328         Modified Get_Handling_Unit_Type_Id___ by removing parameters source_ref1_ ,source_ref2_, source_ref3_,  
--  160328         source_ref4_, source_ref_type_db_ and by adding source_unit_meas_. Modified Check_Update___,  
--  160328         Connect_To_New_Handling_Units, Update_Source_On_Reassign___, Update_On_Reserve by removing the use of 
--  160328         Shipment_Source_Utility_API-Get_Line, Get_Sales_Unit_Meas, Get_Converted_Inv_Qty, Get_Converted_Source_Qty 
--  160328         and instead used shipment line values.    
--  160315  RoJalk LIM-5719, Removed  Customer_Order_Line_API calls from Reassign_Pkg_Comp__. 
--  160314  RoJalk LIM-6511, Modified Reassign_Line__ and passed source part info to Add_Order_Line___.
--  160308  MaRalk LIM-5871, Modified Remove_From_Shipment___, Update___, Reassign_Connected_Qty__, Modify_On_Delivery, 
--  160308         Connect_To_Shipment, Get_Lines_To_Pick_Ordline to reflect shipment_line_tab-sourece_ref4 data type change.
--  160309  RoJalk LIM-4114, Added the PLSQL type and table Source_Ref1_Rec, Source_Ref1_Tab.
--  160309  Rojalk LIM-4651, Modified Update___ and called Shipment_Order_Utility_API.Update_Pkg_Qty_Assigned.
--  160309  Rojalk LIM-4650, Modified Check_Update___ and called Shipment_Source_Utility_API.Check_Update_Connected_Src_Qty. 
--  160306  RoJalk LIM-6321, Added shipment_line_no_ to Add_Order_Line___ and modified calling places.
--  160307  RoJalk LIM-4630, Added the method Modify_Qty_Assigned_By_Source, modified Connect_To_Shipment and called
--  160307         Shipment_Source_Utility_API.Fetch_And_Validate_Ship_Line, Add_Order_Line___, 
--  160307         Shipment_Source_Utility_API.Post_Connect_To_Shipment to make it generic. Called Shipment_Source_Utility_API.
--  160307         Validate_Pick_List_Status from Check_Delete___.
--  160304  MaIklk LIM-4630, Added source_ref_type_db as parameter.
--  160301  RoJalk LIM-4630, Added the PLSQL data type New_Line_Rec.
--  160301  RoJalk LIM-6300, Renamed Shipment_Source_Utility_API.Qty_Reserve_Available to Check_Qty_To_Reserve.
--  160301  RoJalk LIM-6216, Modified Check_Insert___ and called Shipment_Source_Utility_API.Validate_Source_Line.
--  160301  RoJalk LIM-4650, Modified Connect_To_New_Handling_Units and called methods in Shipment_Source_Utility_API to make it generic.
--  160301  RoJalk LIM-4650, Modified Check_Update___ and called methods in Shipment_Source_Utility_API to make it generic.
--  160229  RoJalk LIM-4655, Replaced Update_Package___ with Shipment_Order_Utility_API.Update_Package. Added Modify_Connected_Qty_By_Source.
--  160225	MeAblk Bug 127055, Added new parameter undo_delivery_ into method Update_On_Reserve() and modified Update___() in order to not to reopen a not closed shipment when any undo deliver done.
--  160226  UdGnlk LIM-6224, Replaced Packing_Instruction_Node_API.Get_Handling_Unit_Type_Id() with Packing_Instruction_API.Get_Leaf_Nodes().
--  160226  RoJalk LIM-4637, Added the method Get_Qty_To_Reserve.
--  160225  MaRalk LIM-4102, Removed the method Get_Deliverable_Quantities and replaced its usage within Customer_Order_API.Make_Service_Deliverable__
--  160225         by referring shipment line quantity values and order line quantities directly.
--  160224  RoJalk LIM-4630, Modified Connect_To_Shipment and used Shipment_Source_Utility_API.Get to fetch generic info.
--  160224  RoJalk LIM-4657, Modified Get_Handling_Unit_Type_Id___ and called Shipment_Source_Utility_API.Get_Line to make it generic.
--  160224  RoJalk LIM-4656, Removed the method Modify_Open_Shipment_Qty___ and replaced the usage with Shipment_Source_Utility_API.Modify_Source_Open_Ship_Qty. 
--  160218  RoJalk LIM-4628, Renamed Add_Line to Add_Order_Line___.
--  160218  RoJalk LIM-4631,Moved Get_Shipments_to_Reserve, Get_Shipment_To_Reserve to Shipment_Order_Utility_API. 
--  160218  RoJalk LIM-4637, Replaced Shipment_Line_API.Get_Qty_To_Reserve with method Shipment_Source_Utility_API.Get_Line_Qty_To_Reserve.
--  160216  RoJalk LIM-4628, Modified the scope of Get_Ordline_Qty_To_Ship___ to be public. Renamed Add_Order_Line___ to Add_Line and 
--  160216         changed the scope of to be public. Removed unused parameters from Modify_Line___, Update_Package___. Modified
--  160216         Remove_From_Shipment___ to be genric, changed the parameter list to include shipment_line_rec_.
--  160215  RoJalk LIM-4652, Modified Delete___ and called Shipment_Source_Utility_API.Post_Delete_Ship_Line.
--  160211  RoJalk LIM-5934, Remove source info from Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing method call.
--  160205  RoJalk LIM-4246, Modified code to support new key combination of shipment id and shipment line no.
--  150201  RoJalk LIM-5911, Added Source_Ref_Type to Shipment_Line_API.Get_Qty_To_Reserve call.
--  160201  MaIklk LIM-6124, Handled to fetch sale part description if source part desciption is empty in Add_Order_Line___().
--  160128  RoJalk LIM-5911, Added get methods  Get_Qty_Assigned_By_Source, Get_Qty_Picked_By_Source, Get_Qty_To_Ship_By_Source
--  160128         Get_Qty_Shipped_By_Source, Get_Conn_Source_Qty_By_Source, Get_By_Source based on source info as keys.  
--  160126  RoJalk LIM-5911, Added the method Check_Exist_Source___, added the parameter shipment_line_no_ to methods Remove_From_Shipment___
--  160126         Add_Order_Line___, Modify_Line___. Added source_ref_type_db_ to Add_Sales_Qty___, Modify_Connected_Source_Qty___.
--  160126         Renamed  Modify_Sales_Qty to Modify_Connected_Source_Qty___. 
--  160120  RoJalk LIM-5910, Added shipment_line_no to Line_Rec, added shipment_line_no_ parameter to Connect_To_New_Handling_Units.
--  160118  RoJalk LIM-4638, Moved Get_No_Of_Packages_Reserved and Get_No_Of_Packages_Delivered to Shipment_Order_Utility_API
--  160118  RoJalk LIM-5900, Move Shipment_Line_API.Reset_Printed_Flags___/Update_Shipment___ from Shipment_Line_API to Shipment_API.
--  160115  LEPESE LIM-3742, added method Get_Shipments_to_Reserve and moved logic from Get_Shipment_to_Reserve into this new one.
--  160112  RoJalk LIM-4633, Modified Get_Lines_To_Pick_Shipment and replaced Customer_Order_Reservation_API.Get_Number_Of_Lines_To_Pick
--  160112         with Shipment_Order_Utility_API.Get_Number_Of_Lines_To_Pick.
--  160111  MaIklk LIM-4231, Handled to save SOURCE_PART_NO, SOURCE_PART_DESCRIPTION and INVENTORY_PART_NO in Add_Order_Line().
--  160111  RoJalk LIM-5816, Added source_ref_type_db_  to Remove_From_Shipment___, Modify_Open_Shipment_Qty___, Get_Handling_Unit_Type_Id___, 
--  160111         Unreserve_Non_Inventory and Modify_Qty_To_Ship. Renamed to Order_Exist_In_Shipment to Source_Exist. 
--  160106  MaRalk LIM-5646, Modified Check_Insert___ to fetch the line no. Removed 'ORDER BY part_no DESC' from 
--  160106         Add_Order_Line - get_all_lines cursor and modified the method.
--  160106         Added method Get_Next_Shipment_Line_No___ to fetch next line no that should have for the new shipment line.
--  160107  MaIklk LIM-5749, Added source_ref_type parameter to Shipment_Handling_Utility_API.Reassign_Shipment__() call.
--  160106  MaIklk LIM-5750, Added source_ref_type to Line_Rec type.
--  160106  RoJalk LIM-4632, Added Source_Ref_Type to the method Shipment_Line_API.Reserve_Non_Inventory. Remove Check_Partially_Deliv_Comp. 
--  160104  RoJalk LIM-4092, Replaced Shipment_Handling_Utility_API.Remove_Picked_Line with Shipment_Source_Utility_API.Remove_Picked_Line.
--  160104  MaIklk LIM-5720, Moved Shipment_Connected_Lines_Exist() from ShipmentHandlingUtility.
--  151229  MaIklk LIM-5721, Fixed to call Shipment_Freight_Charge_API.Remove_Shipment_Charges().
--  151215  MaIKlk LIM-5406, Handled to update the header source ref type when inserting or deleting lines.
--  151215  RoJalk Added source_ref_type_db_ to Get_Ordline_Qty_To_Ship___, Add_Order_Line, Modify_Qty_Picked, 
--  151215         Check_Active_Shipment_Exist, Remove_Active_Shipments, Release_Not_Reserved_Qty_Line. Removed the obsolete method Get_Base_Qty.
--  151202  RoJalk LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202         SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151109  RoJalk LIM-4888, Added SOURCE_REF_TYPE to SHIPMENT_LINE_TAB. 
--  151119  RoJalk LIM-4886, Make Shipment Line Generic - Rename SALES_QTY to SHIPMENT_QTY, REVISED_QTY_DUE to INVENTORY_QTY.
--  151116  JeLise LIM-4457, Changed from handling_unit_id to reserv_handling_unit_id in cursor get_reserved_qty_connected in Connect_To_New_Handling_Units.
--  151113  MaEelk LIM-4453, Removed PALLET_ID from the logic
--  150917  RoJalk Modified get_shipment_info cursor in Get_Shipment_To_Reserve and included PT, IPT, SO to support  Create Customer Order Resevations.  
--  150911  RoJalk AFT-1676, Modified Get_Shipment_To_Reserve and added the cursor get_shipment_pegging_info to handle pegged qty when receiving pegged orders. .  
--  150624  MAHPLK KES-516, Added new method Modify_On_Undo_Delivery.
--  150619  MAHPLK KES-516, Added new method Get_No_Of_Packages_Delivered() to get the number of delivered packahes.
--  150612  MAHPLK KES-665, Added new parameter qty_shipped_ to Update_On_Reserve().
--  150107  RoJalk PRSC-437, Modified Update___ to update the picked qty when a PKG customer order line is added to the shipment from the client. 
--  141114  RoJalk PRSC-393, Modified Release_Not_Reserved_Qty_Line and added code o exclude the shipment lines. 
--  140826  RoJalk Modified Release_Not_Reserved_Qty_Line and passed 'RELEASE_NOT_RESERVED' parameter to the Release_Not_Reserved_Qty__ method calls to skip the EXCEED_AVAILABLE_QTY validation.
--  140825  RoJalk Modified Update_On_Reserve and increased the revised qty to be equal to overpicked qty.
--  140818  RoJalk Modified Reassign_Connected_Qty__ and moved the validation to check for Pick List Exist To Report to Customer_Order_Reservation_API.Validate_Reassign___.
--  140808  RoJalk Added the method Release_Not_Reserved_Qty_Line to remove not reserved qty from shipment lines connected to the order line. 
--  140507  RoJalk Modified Update___ and checked for 'ADD_ORDER_LINE' before calling Customer_Order_Reservation_API.Modify_Line_Reservations to avoid the
--  140507         execution when customer order line is connected to shipment via Connect to Shipment.
--  140507  RoJalk Modified Update_From_Order_Line and corrected the text of SHIPLINEUPDATE.
--  140429  RoJalk Modified Get_Lines_To_Pick_Shipment, Get_Lines_To_Pick_Ordline to call Customer_Order_Reservation_API.Get_Number_Of_Lines_To_Pick.
--  140424  RoJalk Modified Get_Lines_To_Pick_Ordline and to return correct value for package component parts. 
--  140331  MeAblk Added new method Get_Deliverable_Quantities. 
--  140325  RoJalk Modified Get_Shipment_To_Reserve, Get_Qty_To_Reserve to consider only shipments in Preliminary state
--  140324  MeAblk Added new method Update_From_Order_Line.
--  140321  MeAblk Added new method Get_Preliminary_Ship_Info.
--  140318  FAndSE Bug correction 107802 is adjusted, the connectable_pkg_comp_exist cursor does include the Picked state since we can connect picked lines via T&L extension.
--  140224  RoJalk Modified Reassign_Pkg_Comp__ and improved error message text.
--  140221  RoJalk Modified Remove_From_Shipment___ and replaced Shipment_Handling_Utility_API.Remove_Reserved_Line with Customer_Order_Reservation_API.Modify_Line_Reservations. 
--  140220  RoJalk Modified Remove_From_Shipment___ and used the method Unreported_Pick_Lists_Exist.
--  140219  FAndSE Changed Remove_From_Shipment___, did not manage to hanlde when some of the reservations where picked and some just reserved, both Remove_Reserved_Line and Remove_Picked_Line can now be excuted.
--  140219  FAndSE Added validation of if pick list lines to report exists in Remove_From_Shipment___. Moved from ShipmentHandlingUtility.Remove_Reserved_Line to cover partly picked lines.
--  140219  RoJalk Modified Remove_From_Shipment___ and skiped the Shipment_Handling_Utility_API.Remove_Picked_Line method call for PKG part lines.
--  140213  PraWlk Modified view VIEW_SHIP_CAT_LOV to set the poss_qty_to_return correctly when a shipment is connected to the RMA header.
--  140211  RoJalk Removed the method Get_Shipment_To_Unreserve since logic was incorporated to RESERVE_CUSTOMER_ORDER_API.Unregister_Arrival___.  
--  140205  FAndSE BI-3439: Update_Package___ is changed since there was an error when the package was changed and the components updated, in addition I have done some clean up and simplification of the code.
--  140205  FAndSE BI-3415: Modified CURSOR get_min_packages_reserved to handle deviating Sales and Inventory UoM, modified CURSOR chk_more_components_to_deliver, added "_" to rel_no to compare with the variable.
--  130930  RoJalk Modified Reassign_Pkg_Comp__ and modified code to correctly calculate remaining_reserved_comp_qty_.
--  140124  MeAblk Added new methods Modify_Sales_Qty and Get_Sales_Qty.
--  130116  RoJalk Modified Check_Update___ and unpacked a value for qty_modification_source_. 
--  131029  RoJalk Modified the view comments of qty_to_ship to be mandatory. 
--  131014  MAHPLK Added rental_db to ORDER_LINE_SHIP_JOIN view.
--  130904  JeLise Added calls to Part_Handling_Unit_API.Check_Combination and Part_Handling_Unit_API.Check_Handling_Unit_Type
--  130904         in Unpack_Check_Update___.
--  130904  MaEelk Moved the view SHIPMENT_CONNECTABLE_LINE to this file from ShipmentHandlingUtility.apy
--  130904  RoJalk Added the method Get_Ordline_Qty_To_Ship___ and used in Add_Order_Line to calculate qty to ship.
--  130902  RoJalk Added the method Check_Partially_Deliv_Comp.
--  130902  ChFolk Added new view SHIPPED_CATALOG_NOS_LOV which is used for catalog no in RMA line.
--  130829  RoJalk Added the method Release_Not_Reserved_Qty__. Modified Get_Qty_To_Reserve to consider non-inventory parts.
--  130827  MaMalk Added parent_consol_shipment_id to SHIPMENT_ORDER_LINE_OVW.
--  130826  JeLise Added new error message NOHUCAPCOMB in Unpack_Check_Update___.
--  130826  RoJalk Modified the scope of Add_Sales_Qty to be implementation. Modified Add_Order_Line___ and passed qty_to_ship to Add_Sales_Qty___ method call. 
--  130826  RoJalk Modified Add_Order_Line and passed ADD_ORDER_LINE as qty_modification_source_ to identify the situation where order line is added to the shipment.
--  130823  RoJalk Changed the scope of revised_qty_due, qty_assigned, qty_shipped, qty_to_ship to be public.
--  130822  RoJalk Modified Reassign_Pkg_Comp__ and added the paramater do_release_reservations_.
--  130822  RoJalk Modified Update___ and checked for qty_modification_source_ before calling Customer_Order_Reservation_API.Modify_Line_Reservations.
--  130822  MaEelk When the sales_qty is changed make a call to Shipment_Freight_Charge_API.Calculate_Shipment_Charges from Update___ 
--  130822  MAHPLK Modified Modify_Qty_Picked to set the QTY_PICKED to the incoming pick quantity (qty_picked_ parameter).
--  130822  RoJalk Renamed derived attr reassignment_type_ to qty_modification_source_.
--  130821  RoJalk Added the parameter non_inventory_part_ to the method Reassign_Pkg_Comp__.
--  130820  RoJalk Modified Reassign_Connected_Qty__ and used Shipment_Handling_Utility_API.Get_Qty_To_Ship_Reassign to calculate qty_to_ship to reassign.
--  130820  JeLise Added handling_unit_id in cursor get_reserved_qty_connected in Connect_To_New_Handling_Units.
--  130816  MaMalk Modified Update_On_Reserve to consider another reassignment type to support the transferring of reservations from shipment to customer order.
--  130816  RoJalk Modified the parameters of the method Reassign_Pkg_Comp__. Modified logic and added validations to check qty in PKG level.
--  130814  RoJalk Removed Disconnect_From_Shipment___ and moved the logic into Remove_From_Shipment___.
--  130813  RoJalk Modified Reassign_Pkg_Comp__ to handle qty_to_ship. Modified Reassign_Connected_Qty__, Reassign_Pkg_Comp__ and used Lock_By_Id___ instead of Lock_By_Keys___.
--  130813  RoJalk Modified Modify_Line___ and replaced Lock_By_Id___ with Lock_By_Keys___.
--  130813  RoJalk Added rowkey to the view REASSIGN_SHIP_CONNECTED_QTY.
--  130812  RoJalk Added the parameter qty_for_not_reserved_ to the method Reassign_Pkg_Comp__.
--  130807  RoJalk Modified the code to calculate revised_qty_due_, sales_qty_ in Update_Package___,
--  130806  RoJalk Modified Modify_On_Delivery and added code to update the open shipment quantity of package parts.
--  130801  RoJalk Included the validations and added the reassign_reserved_qty_ parameter to Reassign_Pkg_Comp__ to identify if it is a transfer of reservation line or not reserved qty.
--  130731  RoJalk Removed the method Reassign_Reserved_Pkg_Comp__. moved the validations in Complete_Pkg_Reassignment__ to be raised earlier in the flow.
--  130731  MaEelk Removed Generate package Structure related messages from Unpack_Check_Update___ and Connect_To_Shipment.
--  130725  MaEelk Removed obsolete codes related to package structure
--  130725  MaMalk Modified Connect_To_Shipment to add a validation if an order line is connected with a different shipment type than the shipment.
--  130725         Also replaced separate get methods to improve performance.
--  130725  RoJalk Modified Complete_Pkg_Reassignment__ and included Reset_Printed_Flags___ method calls.
--  130725  RoJalk Added the method Complete_Pkg_Reassignment__. Modified the method Reassign_Reserved_Pkg_Comp__ and added the qty_picked_in_ship_inventory_ parameter.
--  130723  MaMalk Moved SHIPMENT_ORDER_LINE_OVW to ShipmentOrderLine.apy from ShipmentHandlingUtility.apy since the rowkey is taken from shipment_order_line_tab. 
--  130724  RoJalk Modified Reassign_Pkg_Comp__ and included the validations.
--  130719  MaMalk Modified Unpack_Check_Update___ to calculate the revised_qty_due when the sales quantity is updated from shipment lines.
--  130719  RoJalk Modified Update___ and restricted the calling of Update_Package___ during reassignment to stop the double updates on PKG parts.
--  130719  RoJalk Added the parameter reassignment_type_ to the method Update_Package___.  
--  130719  RoJalk Modified Reassign_Pkg_Comp__ and added the destination_shipment_id_ != 0 to identify 'Release from Shipment' option.
--  130718  RoJalk Modified Reassign_Connected_Qty__ and added a validation to check for pick listed quantity.
--  130718  RoJalk Moved the view REASSIGN_SHIP_CONNECTED_QTY to SHIPMENT_HANDLING_UTILITY_API.
--  130717  RoJalk Modified Get_No_Of_Packages_Reserved and used qty_per_assembly in cursor to consider delivered components.
--  130716  RoJalk Modified the REASSIGN_SHIP_CONNECTED_QTY view and removed the method Customer_Order_Reservation_API.Get_Sum_Reserve_To_Reassign
--  130716         and incorporated the logic in to reassignment client form.
--  130712  RoJalk Modifications to the REASSIGN_SHIP_CONNECTED_QTY to support the reassignment of PKG parts.
--  130711  RoJalk Added the methods Reassign_Reserved_Pkg_Comp__, Reassign_Pkg_Comp__ to support reassignment of PKG component lines.
--  130710  RoJalk Modified Add_Order_Line included the check revised_qty_due_ > 0 before calling Add_Order_Line___.
--  130705  MaMalk Added another parameter to Reset_Printed_Flags___ and modified several methods to handle the resetting of pro_forma_printed flag
--  130705         if the pro forma invoice has already been printed.
--  130628  RoJalk Modified Get_Sum_Reserved_Line and removed the condition shipment_id != 0.
--  130627  RoJalk Added the view REASSIGN_CONNECTED_COMP_QTY to be use in reassignment of package component parts.
--  130626  JeLise Added exception handling in Connect_To_New_Handling_Units.
--  130626  MaMalk Modified Delete___ to refresh the values of the shipment header when the order lines are disconnected.
--  130626  RoJalk Modified REASSIGN_SHIP_CONNECTED_QTY and removed the condition line_item_no = 0 so the view can be reused. 
--  130621  RoJalk Modified Delete_Component_Lines___ and included the shipment id in order to not remove components on an other shipment.
--  130620  RoJalk Modified Remove_Active_Shipments and checked if shipmnet line is picked or delivered.
--  130620  RoJalk Code improvements to the method Update_Source_On_Reassign___. Renamed Modify_Qty_On_Reserve to Update_On_Reserve.
--  130620  RoJalk Removed unused parameters from the method Modify_Qty_On_Reserve.
--  130619  RoJalk Modified Update_Shipment___ to check the reassignment type before raising the info messages.
--  130614  RoJalk Modified Get_Qty_To_Reserve, ORDER_LINE_SHIP_JOIN to consider the CO line qty and consider overpicked scenario.   
--  130612  RoJalk Modified the calling places of Customer_Order_Reservation_API.Modify_Line_Reservations and included the parameter transfer_on_add_remove_line.
--  120611  RoJalk Further corrections to the method Reassign_Connected_Qty__ to support non-inventory parts.
--  130610  RoJalk Code improvements to the method Update_Source_On_Reassign___, modified REASSIGN_SHIP_CONNECTED_QTY to support non-inventory parts.
--  130607  RoJalk Added the method Get_Sum_Reserve_To_Reassign. Modified Update_Source_On_Reassign___, Reassign_Connected_Qty__ to support non inventory parts. 
--  130607  RoJalk Modified REASSIGN_SHIP_CONNECTED_QTY and removed unused columns. 
--  130607  RoJalk Modified Update_Source_On_Reassign__ and removed the qty_assigned_, qty_picked_ parameters because both reassignment of HU and
--  130607         connected quantity will upadte the shipment line when qty_assigned, qty_picked > 0 from Customer_Order_Reservation_API.Update___.
--  130604  RoJalk Added the validation SHIPBLOCKED to the beginning of the method Reassign_Connected_Qty__ to be raised in the start of the flow.
--  130522  RoJalk Modified Add_Order_Line___ and simplified the algorithm to calculate qty to ship.
--  130521  RoJalk Passed the correct values for reassignment_type_ when calling Check_Delete___  and Delete___.
--  130520  RoJalk Removed unused variables from Reassign_Order_Line__ method.
--  130520  RoJalk Modified Reassign_Connected_Qty__ to validate reserved_to_reassign_ against what is available.
--  130520  RoJalk Added the parameter reserved_to_reassign_ to the method Reassign_Connected_Qty__.   
--  130520  RoJalk Modified Reassign_Connected_Qty__ and moved common validations for destinatio shipment id for Reassign Connected Quantitty and 
--  130520         Reassign Handling Unit to the method Shipment_Handling_Utility_API.Reassign_Shipment__. 
--  130516  JeLise Added a second version of method Connect_To_New_Handling_Units, since it can be called both from server and client and the out
--  130516         paremeter is only used in the server.
--  130516  RoJalk Added teh method Update_Source_On_Reassign__. Added the parameters qty_assigned_, qty_picked_ Update_Source_On_Reassign___ to the method.
--  130513  RoJalk Modified Reassign_Connected_Qty__ and removed the address related parameters from Shipment_Handling_Utility_API.Reassign_Shipment__.
--  130513  RoJalk Renamed derived attribute, related variables and method parameters from reassign_ship_connected_qty to reassignment_type and used
--  130513         it to identify between Reassign Connected Quantity and Reassign handling Units flows.
--  130513  RoJalk Added the method Update_Source_On_Reassign___ and called from Reassign_Connected_Qty_._
--  130513  RoJalk Renamed the method  New_Line___ to Add_Order_Line___ and called from Add_Order_Line and Reassign_Order_Line__.
--  130508  RoJalk Modified Reassign_Connected_Qty__ and called Shipment_Line_Handl_Unit_API.Remove_Or_Modify.
--  130507  MeAblk Added new method  Non_Inv_Comp_Exist_To_Deliver.
--  130403  RoJalk Modified Reassign_Connected_Qty__ and added a warning to handle auto connection blocked shipments.
--  130503  RoJalk Modified Reassign_Connected_Qty__ and included validations check shipment category.
--  130403  RoJalk Modified REASSIGN_SHIP_CONNECTED_QTY to exclude CONSOLIDATED shipments. 
--  130503  RoJalk Modified error messages and replaced Sales quantity with Connected sales quantity.
--  130503  RoJalk Removed the project_id and condition_code from the REASSIGN_SHIP_CONNECTED_QTY view.
--  130503  RoJalk Modified error text in Reassign_Connected_Qty__ for some of the validations.
--  130430  RoJalk Added planned_delivery_date, promised_delivery_date to the method REASSIGN_SHIP_CONNECTED_QTY.
--  130424  RoJalk Added the address related columns to the view REASSIGN_SHIP_CONNECTED_QTY.
--  130423  RoJalk Modified the view REASSIGN_SHIP_CONNECTED_QTY to exclude the PKG and component lines.
--  130423  JeLise Added check on if handling_unit_type_id or packing_instruction_id has changed in Unpack_Check_Update___.
--  130423  RoJalk Removed the code to transfer pkg components from the method Reassign_Order_Line__.
--  130422  JeLise Added method Get_Handling_Unit_Type_Id___ to get the correct handling_unit_type_id in Insert___.
--  130411  RoJalk Added the method Update_Shipment___ to centralize logic to update shipment. Added the variable info_ to the method Reassign_Connected_Qty__. 
--  130416  JeLise Added method Connect_To_New_Handling_Units.
--  130410  MeAblk Added new attribute packing_instruction_id and modified method Add_Order_Line in order to add the packing_instruction_id when connecting order lines into the shipment.
--  130410  RoJalk Added the method New_Line___  and called from Reassign_Order_Line__.
--  130410  RoJalk Added the parameters source_revised_qty_due_,  source_sales_qty_ to the method Reassign_Order_Line__. Modify REASSIGN_SHIP_CONNECTED_QTY
--  130410         to include the package parts. Modified Insert___,  Update___ and Delete___ to handle state change from Completed to Preliminary. Modified Check_Delete___
--  130410         to skip the SHIPMENTNOTREMOVE validation for reassignment flow. Modified Reassign_Order_Line__ to insert component parts. 
--  130409  RoJalk Modified the view REASSIGN_SHIP_CONNECTED_QTY and added the conditions to filter delivered shipments.
--  130405  RoJalk Modified Unpack_Check_Update___ and moved the error message LESSTHANRESERVE inside sales_qty comparison. 
--  130405  RoJalk Added the parameter source_shipment_id_  to the method Modify_Qty_On_Reserve and called Modify_Qty_On_Reserve to update source shipment.
--  130403  RoJalk Change the scope of Add_Sales_Qty___ to be public.
--  130401  RoJalk Modified Reassign_Connected_Qty__ and removed the parameter new_shipment_id_.
--  130401  RoJalk Modified Reassign_Connected_Qty__ and added the validation to check if source and destination shipments have the same address, ship via parameters etc.
--  130401  RoJalk Modified Unpack_Check_Update___and added a validation so that Qty reserved cannot be reduced from the shipment order line. 
--  130401  RoJalk Modified the method Reassign_Connected_Qty__ and passed the parameter source_shipment_state_ and included the validations. 
--  130328  JeLise Added attribute handling_unit_type_id and methods Get_Handling_Unit_Type_Id and Is_Instance_Exist.
--  130328  RoJalk Modified Unpack_Check_Update___, Add_Sales_Qty___ and used REASSIGN_SHIP_CONNECTED_QTY to identify Reassign Connected Quantity flow. 
--  130328  RoJalk Renamed the parameter reserved_to_reassign_ to qty_to_reassign_ in the method Reassign_Connected_Qty__. Removed the method  Validate___. 
--  130325  RoJalk Modified Reassign_Connected_Qty__ and assigned a value for destination_shipment_id_. 
--  130325  MaEelk Made a  call to remove the Manual Gross Weight from Shipment when a shipment line is removed, added or modified in the Shipment
--  130322  RoJalk Added the method Reassign_Order_Line__, Added destination_shipment_id_ to the method Reassign_Connected_Qty__. 
--  130318  RoJalk Added the parameter reassign_ship_connected_qty_ to the Remove_From_Shipment___ Delete___ Modify_Qty_On_Reserve to identify the situation where
--  130318         record is removed via Reassign Shipment Connected Quantity. Added the derived attribute reassign_ship_connected_qty_. Added the method Reassign_Connected_Qty__.  
--  130314  RoJalk Modified the view REASSIGN_SHIP_CONNECTED_QTY and used the method Customer_Order_Reservation_API.Get_Max_Ship_Qty_To_Reassign to calculate max_to_reassign.
--  130314  RoJalk Modified the view REASSIGN_SHIP_CONNECTED_QTY to exclude the delivered shipment lines. 
--  130313  RoJalk Added contract to the view REASSIGN_SHIP_CONNECTED_QTY.
--  130312  RoJalk Added not_reserved_qty, max_to_reassign to the view REASSIGN_SHIP_CONNECTED_QTY.
--  130311  RoJalk Added the view REASSIGN_SHIP_CONNECTED_QTY to be used in Reassign Shipment Connected qty window.
--  130304  JeLise Removed check on (newrec_.revised_qty_due < newrec_.qty_assigned) in Unpack_Check_Undate___.
--  130226  JeLise Added more in parameters and a call to Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify in Modify_Qty_On_Reserve.
--  130222  JeLise Changed sales_qty from private to public.
--  130220  RoJalk Removed the method Modify_Qty_Assigned since the usage is replaced by Modify_Qty_On_Reserve.
--  130220  RoJalk Added the method Modify_Qty_On_Reserve.  
--  130212  RoJalk Modified Connect_To_Shipment and moved the info message to handle fixed shipment to the client.
--  130212  RoJalk Modified Connect_To_Shipment and added info to be raised when lines are added for a fixed shipment.
--  130208  RoJalk Added the parameter line_item_no_ to the method  Get_Lines_To_Pick_Ordline.
--  130129  RoJalk Renamed revised_qty_due_ to be new_open_shipment_qty_ in Disconnect_From_Shipment___, Remove_From_Shipment___ methods. 
--  130128  RoJalk Modified Get_Shipment_To_Reserve and added the parameter consume_pegging_. Added the method Modify_Open_Shipment_Qty___and restructured the code. 
--  130128         Modified Get_Shipment_To_Reserve, Reserve_Non_Inventory  and included filtering with CO line columns.
--  130124  MaMalk Removed obsolete method Get_Active_Shipment_Id.
--  130118  RoJalk Modified Remove_From_Shipment___ and called Shipment_Handling_Utility_API.Remove_Picked_Line/Remove_Reserved_Line baseed on SOL qty's instead of CO line states.
--  130116  RoJalk Modified Modify_On_Delivery to update qty picked column. 
--  130104  RoJalk Added the column qty_picked and Modify_Qty_Picked method, modified Get_Base_Qty to use qty_picked from so line.
--  121231  MeAblk Modified view ORDER_LINE_SHIP_JOIN by correctly calculating the order connected qty_assigned and qty_to_reserve view itself.
--  121228  MeAblk Modified Add_Order_Line by doing some code refinement changes.
--  121221  MeAblk Modified Unpack_Check_Update___ by adding an info message when updating the sales quantity of a shipment line when the package structure is already generated.
--  121221  MeAblk Modified the method Add_Order_Line in order to correctly update the qty_assigned of the package part line when all the components are non-inventory.
--  121220  MeAblk Added parameter shipment_id_ into the method Get_Revised_Qty_Due.
--  121219  MeAblk Modified view ORDER_LINE_SHIP_JOIN in order to get the shipment reserved qty correctly. Removed the attribute customer_name. 
--  121219  RoJalk Modified Update___ to set the values for qty_assigned, qty_to_ship for the package lines if not in the delivery flow.
--  121219  RoJalk Removed Add_Qty_Assigned, renamed  Modify_Qty_Shipped  as Modify_On_Delivery and added code to handle both inventory and non inventory parts.
--  121219  MeAblk Modified Update___ in order to handle the package line qty_assigned update when updating the component lines. Removed package line updates inside Modify_Qty_Assigned and Modify_Qty_To_Ship. Removed the component lines update inside
--  121219  MeAblk method Modify_Qty_Shipped. Implemented new method Get_Qty_Assigned.  
--  121218  MeAblk Implemented new methods Get_No_Of_Packages_Reserved, Get_Revised_Qty_Due. Modified Update___ in calling the Update_Package___ method. Modified Update_Package___. Removed method Update_Line___. 
--  121218  RoJalk Modified Add_Sales_Qty___ and corrected the sales qty calculations considering UOM.
--  121213  RoJalk Modified Update___  and used revised_qty_due instead of sales_qty when calling Customer_Order_Reservation_API.Modify_Line_Reservations. 
--  121212  RoJalk Added the method Validate___ to include common validations of Insert and Update.
--  121211  MeAblk Removed method Get_Revised_Qty_Due___. Modified methods Update___, Update_Package___ in order to correctly update the open shipment qty for the package component lines.    
--  121210  RoJalk Renamed Unconsume_Non_Inv_Peggings to Unreserve_Non_Inventory,added the method Reserve_Non_Inventory.
--  121207  RoJalk Added the method Unconsume_Non_Inv_Peggings, modified Get_Shipment_To_Unreserve to check if unpicked lines exists.
--  121206  RoJalk Modified Get_Shipment_To_Unreserve to return a NULL value if shipment is not found and included a order by. 
--  121205  MeAblk Added new method Get_Revised_Qty_Due___ and modified Update_Package___ methods in order to correctly update the revised_due_qty of the component parts when connecting partially delivered lines and changing the shipment connected qty.
--  121205  MeAblk Removed the error message raised which comes when updating the shipment connected qty for the fully reserved non-inventory part line. Instead, make qty_to_ship updated when changing the shipment connected qty.     
--  121130  RoJalk Removed the method Get_Base_Qty with the order line reference.
--  121130  RoJalk Modified Get_Base_Qty to support non-inventory parts.
--  121128  RoJalk Modified Update___ and changed the conditions when calling Customer_Order_Reservation_API.Modify_Line_Reservations.
--  121128  RoJalk Modified Update___ and called Customer_Order_Reservation_API.Modify_Line_Reservations to handle reservations when shipment sales qty is modified. 
--  121128  RoJalk Added the method Get_Shipment_To_Unreserve.
--  121122  MeAblk Modified method Modify_Qty_Shipped in order to update the QTY_SHIPPED for package component lines when making deliveries. 
--  121121  RoJalk Added the overloaded method Get_Base_Qty with shipment id as the parameter.
--  121120  MeAblk Added new field qty_to_ship methods Modify_Qty_To_Ship, Get_Qty_To_Reserve, Get_Qty_To_Ship, Update_Package___, Update_Line___. Modified methods Add_Order_Line, Add_Qty_Assigned, Modify_Qty_Assigned, Update___, Unpack_Check_Update___
--  121120         in order to handle the shipment connected quantities when connecting package part lines into a shipment and reserving.
--  121115  RoJalk Removed the method Modify_Qty_Assigned_Shipped and added Modify_Qty_Shipped.
--  121115  RoJalk Removed the parameters exit_reservation_, shipment_id_ from Get_Shipment_To_Reserve method. 
--  121114  RoJalk Added the method Check_Active_Shipment_Exist.
--  121108  RoJalk Added method Remove_Active_Shipments.
--  121105  MeAblk Added new view ORDER_LINE_SHIP_JOIN_UIV in order to use for the Manual Reservation for Customer Order Line. 
--  121102  RoJalk Allow connecting a customer order line to several shipment lines - modified Get_Lines_To_Pick_Shipment to consider shipment id. 
--  121102         Added methods Get_Sum_Reserved_Line, Get_Shipment_To_Reserve, Modify_Qty_Assigned, Modify_Qty_Assigned_Shipped, Add_Qty_Assigned, Modify_Line___. 
--  121102         Called Customer_Order_Reservation_API.Modify_Line_Reservations from Add_Order_Line to transfer reservations from CO line to shipment.
--  121102  MaEelk Added Add_Sales_Qty___ and changed Add_Order_Line to add a quantity to a shipment order line if it already exists.
--  121102  MaEelk Added sales_qty, revised_qty_due, qty_assigned and qty_shipped to the LU. Modified  Added Get_Total_Open_Shipment_Qty  and Add_Order_Line in order to work the shipment connections properly. 
--  121102  MaMalk Added validations to the sales quantity by updating Unpack_Check_Update___. Also changed Modify__ to get the info correctly.
--  121102         Made changes to Get_Lines_To_Pick_Ordline and Get_Lines_To_Pick_Shipment to filter the reservation table with the shipment_id.
--  121023  MAHPLK BI-677, Modified shipment state comparison to 'Cancelled' in Unpack_Check_Insert___. 
--  120727  ChFolk Added function Order_Exist_In_Shipment to check whether given order_no exists in the given shipment.
--  130404   SBalLK Bug 107802, Modified Connect_To_Shipment() method to raise error message when connecting a package where all component supply though IPD.
--  120409  MaRalk Modified method Connect_To_Shipment to avoid adding shipment freight charges again when connecting a 
--  120409         partially delivered CO line to a shipment if that CO line had been connected to a shipment already.
--  120319  DaZase Changes in method Delete___ so it will check orderline status before calling Customer_Order_Charge_Util_API.New_Cust_Order_Charge_Line, plus changed the freight_only flag in that call to TRUE instead, no use creating packsize charges since they dont change here.
--  120207  DaZase Added method Get_Ordline_Reserved_Qty for use in the client instead of using the similar method directly from Customer_Order_Line_API to handle exceptions depending on shipment status.
--  120111  DaZase Renamed Get_Lines_Qty_To_Pick to Get_Lines_To_Pick_Shipment and changed its logic. Added new method Get_Lines_To_Pick_Ordline.
--  111121  DaZase Added method Get_Lines_Qty_To_Pick.
--  110909  MaMalk Moved Recalculate_Freight_Charges to Shipment_Freight_Charge_API.
--  110905  MaMalk Passed extra parameter to Customer_Order_Charge_Util_API.New_Cust_Order_Charge_Line.
--  110510  Darklk Bug 96637, Modified the error message SHIPMENTCONNECTED accordingly. 
--  110428  Darklk Bug 96637, Modified the procedure Connect_To_Shipment to avoid connect a already shipment connected CO line.
--  110303  MaMalk Update methods Delete___  to remove freight charges when no order lines are connected.
--  100920  NWeelk Bug 93023, Modified method Remove_From_Shipment___ by adding a parameter to method calls Shipment_Handling_Utility_API.Remove_Picked_Line.
--  100513  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091216  NaLrlk Modified the function Recalculate_Freight_Charges.
--  091028  ShKolk Added new procedure Recalculate_Freight_Charges().
--  091009  ShKolk Moved calculation of freight charges to Delete___.
--  081128  ChJalk Bug 78496, Modified the method Connect_To_Shipment to raise an error when trying to connect a shipment line to a shipment which is not in Preliminary state.
--  081125  ChJalk Bug 78496, Modified the method Check_Delete___ to raise an error when trying to delete a shipment which is not in Preliminary state.
--  080829  DaZase Bug 76530, Added a check for rowstate != 'Cancelled' in method Add_Order_Line to avoid cancelled 
--  080829         component lines to be added to shipment, which would cause a stop in the deliver process. 
--  090422  ShKolk Modified Disconnect_From_Shipment___() to create CO charges.
--  090301  ShKolk Moved Add_Shipment_Charges() to Shipment_Freight_Charge_API.
--  090226  ShKolk Added Add_Shipment_Charges().
--  071016  MaMalk Bug 67533, Modified method Remove_From_Shipment___ and removed conditions for executing method call Disconnect_From_Shipment___. 
--  070212  MaMalk Bug 63104, Modified Disconnect_From_Shipment___ to stop disconnecting all component parts of the package part 
--  070212         when disconnect one component part.
--  070207  SaJjlk Removed unused method Get_Shipment_Id.
--  070131  SaJjlk Removed error used to check Single Occurance addresses in method Connect_To_Shipment.
--  060713  YaJalk Bug 59255, Modified cursor exist_control in FUNCTION Is_Charge_Allowed.
--  060327  NuFilk Modified the If condition for warning message in method Remove_From_Shipment___.
--  060224  NiDalk Added validation to check for different ship via code and delevery terms from the shipment
--                 when customer order line is connected to the shipment.
--  060222  NiDalk Added validation to check for single occurence address when customer order line is connected to the shipment.
--  051227  RaKalk Added validation to check whether the shipment is canceled
--  051214  IsAnlk Added error message in Connect_To_Shipment.
--  050920  MaEelk Removed unused variables from the code
--  050629  MaEelk Added correct method name to General_Sys.Init call in Remove_Shipment_Line.
--  050519  SaJjlk Added method Remove_Shipment_Line.
--  050321  SaJjlk Added information messages for removing a shipment connected CO line in picked state.
--  050217   IsAnlk Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050121  UsRalk Modified function Get_Base_Qty.
--  050117  UsRalk Corrected the cursor at Disconnect_From_Shipment___.
--  050117  SaJjlk Modified CASE statement in methods Remove_From_Shipment___ and Get_Base_Qty.
--  050112  NuFilk Modified view UNCLOSED_SHIPMENTS.
--  050112  SaJjlk Changed public methods Disconnect_From_Shipment and Remove_From_Structure to Implementation methods.
--                 Added methods Remove_From_Shipment___ and Reset_Printed_Flags___.
--  050112  JaBalk Small modification done related to order line history.
--  050112  JaBalk Added history to customer order lien when shipment is connected or disconnected
--  050112         and added shipment id parameter to a Disconnect_From_Shipment method.
--  050110  NuFilk Added view UNCLOSED_SHIPMENTS.
--  050107  GeKalk Added a new method Get_Active_Shipment_Id..
--  050106  UsRalk Added a where condition to the base view to remove component part lines.
--  050106  UsRalk Added new method Delete_Component_Lines___ .
--  050104  UsRalk Modified Connect_To_Shipment to handle package parts.
--  040225  JoEd   Added function Connected_Lines_Exist for use in Shipment client form.
--  021106  PrInLk Modify deletion of Partially Delivered lines.
--  021018  GekaLk Moved shipment_order_line_ovw view to ShipmentHandlingUtility LU.
--  021023  PrInLk Moved methods Connect_To_Shipment,Disconnect_From_Shipment into this LU from CustomerOrderLine LU.
--                 Moved methods Get_Reserved_Remain_Qty,Remove_Picked_Line,Remove_Reserved_Line to ShipmentHandlingUtility LU.
--  021021  PrInLk Modified the method Get_Base_Qty for Partially Delivered order lines.
--  021018  GekaLk Added shipment_order_line_ovw view to use in the Shipment Order Line Overview.
--  020607  MaGu   Modified method Is_Connected_To_Structure___. Chaged select statements so that
--                 no select from views in other LU:s are made, instead select from tables is added.
--                 Removed methods Get_Remain_Parcel_Qty. Moved these methods to utility LU
--                 Shipment_Handling_Utility.
--  020527  DaMase Code review a number of changes to improve the readability.
--  020503  Prinlk Modify the method Get_Shipment_Id. Included a cursor to manipulate data.
--  020502  MaGu   Added call to General_SYS.Init_Method in method Get_Remain_Parcel_Qty.
--  020429  Prinlk Added a public method Remove_Picked_Line to remove lines in status picked connected to
--                 the shipment.
--  020321  Prinlk Added method Get_Reserved_Remain_Qty to obtain reserved quantity on each reserved
--                 location.
--  020319  Prinlk Modified the method Is_Connected_To_Structure___ in order to delete packages directly
--                 kept on shipment itself.
--  020312  Prinlk Added overloaded public method Get_Remain_Parcel_Qty which argument list
--                 not included with shipment_id. Added public method Get_Shipment_Id to obtain
--                 the shipment id connected to an order line.
--  020311  ZiMolk Modified Remove__ to add a warnning when the consignment is already printed.
--  020310  ZiMolk Modified method add_order_lines(), remove__() to add a call to Shipment_API.Set_Print_Flags.
--  020307  Prinlk Added the public method Remove_Reserved_Line which removes a Reserved
--                 line. Which reverse the status to Release.
--  020306  Prinlk Modify the method Delete___ to alert the user when removing lines where shipments
--                 delivery note had been printed already.
--  020305  Prinlk Added public method Is_Charge_Allowed to check if the charge could be
--                 possible to add to an order line against a shipment.
--  020304  Prinlk Added SHIPMENT_ORDER_LINE_LOV to support 'Collect Charge' functionality
--  020228  ZiMolk Modified method add_order_lines(), remove__() to add a call to Shipment_API.Set_Print_Flags.
--  020221  Prinlk Added public method Remove_From_Structure which will remove an order
--                 line information from the structure when order line is deleted from
--                 the connected order line.
--  020219  Prinlk Added public method Get_Base_Qty to return the qty based on line
--                 status.
--  020218  Prinlk Added public method Get_Remain_Parcel_Qty.
--  020206  Prinlk Added the implementation method Is_Connected_To_Structure
--                 to check any connection to a structure from a connected line.
--                 Included that method into Delete__ method.
--  020123  Prinlk Corresponding order line disconnected from shipment when
--                 removing shipment order line. Modified Delete___ method.
--  020122  Prinlk Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Line_Rec IS RECORD (
   shipment_id       SHIPMENT_LINE_TAB.shipment_id%TYPE,
   shipment_line_no  SHIPMENT_LINE_TAB.shipment_line_no%TYPE,
   source_ref1       SHIPMENT_LINE_TAB.source_ref1%TYPE,
   source_ref2       SHIPMENT_LINE_TAB.source_ref2%TYPE,
   source_ref3       SHIPMENT_LINE_TAB.source_ref3%TYPE,
   source_ref4       SHIPMENT_LINE_TAB.source_ref4%TYPE,
   source_ref_type   SHIPMENT_LINE_TAB.source_ref_type%TYPE);

TYPE Line_Tab IS TABLE OF Line_Rec INDEX BY PLS_INTEGER;

TYPE Shipment_Quantity_Rec IS RECORD (
   shipment_id SHIPMENT_LINE_TAB.shipment_id%TYPE,
   quantity    SHIPMENT_LINE_TAB.qty_assigned%TYPE);

TYPE Shipment_Quantity_Tab IS TABLE OF Shipment_Quantity_Rec INDEX BY PLS_INTEGER;

TYPE Shipment_Line_Id_Rec IS RECORD (
   shipment_id       SHIPMENT_LINE_TAB.shipment_id%TYPE,
   shipment_line_no  SHIPMENT_LINE_TAB.shipment_line_no%TYPE);

TYPE Shipment_Line_Id_Tab IS TABLE OF Shipment_Line_Id_Rec INDEX BY PLS_INTEGER;

TYPE New_Line_Rec IS RECORD (
   shipment_id            SHIPMENT_LINE_TAB.shipment_id%TYPE,
   source_ref1            SHIPMENT_LINE_TAB.source_ref1%TYPE,
   source_ref2            SHIPMENT_LINE_TAB.source_ref2%TYPE,
   source_ref3            SHIPMENT_LINE_TAB.source_ref3%TYPE,
   source_ref4            SHIPMENT_LINE_TAB.source_ref4%TYPE,
   source_ref_type        SHIPMENT_LINE_TAB.source_ref_type%TYPE,
   source_part_no         SHIPMENT_LINE_TAB.source_part_no%TYPE,
   source_part_desc       SHIPMENT_LINE_TAB.source_part_description%TYPE,
   inventory_part_no      SHIPMENT_LINE_TAB.inventory_part_no%TYPE, 
   source_unit_meas       SHIPMENT_LINE_TAB.source_unit_meas%TYPE, 
   conv_factor            SHIPMENT_LINE_TAB.conv_factor%TYPE,         
   inverted_conv_factor   SHIPMENT_LINE_TAB.inverted_conv_factor%TYPE, 
   inventory_qty          SHIPMENT_LINE_TAB.inventory_qty%TYPE,
   connected_source_qty   SHIPMENT_LINE_TAB.connected_source_qty%TYPE,
   qty_assigned           SHIPMENT_LINE_TAB.qty_assigned%TYPE,
   qty_shipped            SHIPMENT_LINE_TAB.qty_shipped%TYPE, 
   qty_to_ship            SHIPMENT_LINE_TAB.qty_to_ship%TYPE,  
   packing_instruction_id SHIPMENT_LINE_TAB.packing_instruction_id%TYPE,
   customs_value          SHIPMENT_LINE_TAB.customs_value%TYPE);

TYPE New_Line_Tab IS TABLE OF New_Line_Rec INDEX BY PLS_INTEGER;

TYPE Source_Ref1_Rec IS RECORD (
   source_ref1   SHIPMENT_LINE_TAB.source_ref1%TYPE );
   
TYPE Source_Ref1_Tab IS TABLE OF Source_Ref1_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_No_Hu_Capacity_Error___
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOHUCAPACITY: No handling unit capacity defined for this combination of part number, unit of measure and handling unit type.');
END Raise_No_Hu_Capacity_Error___;   

PROCEDURE Raise_General_Error___ (
   err_text_1_ IN VARCHAR2,
   err_text_2_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'GENERALERROR1: :P1 :P2', err_text_1_, err_text_2_);
END Raise_General_Error___;   

PROCEDURE New_Line___ (
   shipment_line_no_        OUT NUMBER,
   shipment_id_             IN  NUMBER,
   source_ref1_             IN  VARCHAR2,
   source_ref2_             IN  VARCHAR2,
   source_ref3_             IN  VARCHAR2,
   source_ref4_             IN  VARCHAR2,
   source_ref_type_db_      IN  VARCHAR2,
   source_part_no_          IN  VARCHAR2,
   source_part_desc_        IN  VARCHAR2,
   inventory_part_no_       IN  VARCHAR2,   
   source_unit_meas_        IN  VARCHAR2,
   conv_factor_             IN  NUMBER,         
   inverted_conv_factor_    IN  NUMBER,       
   revised_qty_due_         IN  NUMBER,
   sales_qty_               IN  NUMBER,
   qty_assigned_            IN  NUMBER,
   qty_shipped_             IN  NUMBER, 
   qty_to_ship_             IN  NUMBER,  
   packing_instruction_id_  IN  VARCHAR2,
   customs_value_           IN  NUMBER,
   qty_modification_source_ IN  VARCHAR2,
   on_reassignment_         IN  BOOLEAN )
IS
   objid_                VARCHAR2(2000);
   objversion_           VARCHAR2(2000);   
   newrec_               SHIPMENT_LINE_TAB%ROWTYPE;
   attr_                 VARCHAR2(4000);
   indrec_               Indicator_Rec;
   new_line_             VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
   source_qty_assigned_  NUMBER:=0;
BEGIN
   IF Source_Exist(shipment_id_, source_ref_type_db_, source_ref1_, source_ref2_, source_ref3_, source_ref4_) THEN
      Add_Sales_Qty___(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                       revised_qty_due_, sales_qty_, qty_to_ship_, qty_modification_source_);
   ELSE      
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID',             shipment_id_,                     attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF1',             source_ref1_,                     attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF2',             source_ref2_,                     attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF3',             source_ref3_,                     attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF4',             source_ref4_,                     attr_);
      Client_SYS.Add_To_Attr('SOURCE_REF_TYPE_DB',      source_ref_type_db_,              attr_);
      Client_SYS.Add_To_Attr('SOURCE_PART_NO',          source_part_no_,                  attr_);
      Client_SYS.Add_To_Attr('SOURCE_PART_DESCRIPTION', source_part_desc_,                attr_);
      Client_SYS.Add_To_Attr('INVENTORY_PART_NO',       inventory_part_no_,               attr_);      
      Client_SYS.Add_To_Attr('SOURCE_UNIT_MEAS',        source_unit_meas_,                attr_);
      Client_SYS.Add_To_Attr('CONV_FACTOR',             NVL(conv_factor_,1),              attr_);
      Client_SYS.Add_To_Attr('INVERTED_CONV_FACTOR',    NVL(inverted_conv_factor_,1) ,    attr_);   
      Client_SYS.Add_To_Attr('INVENTORY_QTY',           revised_qty_due_,                 attr_);
      Client_SYS.Add_To_Attr('CONNECTED_SOURCE_QTY',    sales_qty_,                       attr_);
      Client_SYS.Add_To_Attr('QTY_ASSIGNED',            qty_assigned_,                    attr_);
      Client_SYS.Add_To_Attr('QTY_SHIPPED',             qty_shipped_,                     attr_);
      Client_SYS.Add_To_Attr('QTY_TO_SHIP',             NVL(qty_to_ship_, 0),             attr_);
      Client_SYS.Add_To_Attr('PACKING_INSTRUCTION_ID',  packing_instruction_id_,          attr_);
      Client_SYS.Add_To_Attr('CUSTOMS_VALUE',           customs_value_,                   attr_);
      Client_SYS.Add_To_Attr('QTY_MODIFICATION_SOURCE', qty_modification_source_,         attr_);

      Unpack___(newrec_, indrec_, attr_); 
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);     
      new_line_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   shipment_line_no_ := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   IF (NOT on_reassignment_) THEN
      source_qty_assigned_ := Reserve_Shipment_API.Get_Total_Qty_Reserved(source_ref1_, source_ref2_, 
                                                                          source_ref3_, source_ref4_, source_ref_type_db_, 0);      
      IF (source_qty_assigned_ > 0) THEN                                                                                
         -- transfer reservations from source line to shipment line
         Reserve_Shipment_API.Transfer_Line_Reservations(source_ref1_                 => source_ref1_,
                                                         source_ref2_                 => source_ref2_,
                                                         source_ref3_                 => source_ref3_,
                                                         source_ref4_                 => source_ref4_,
                                                         source_ref_type_db_          => source_ref_type_db_, 
                                                         from_shipment_id_            => 0,
                                                         to_shipment_id_              => shipment_id_, 
                                                         qty_to_transfer_             => 0,
                                                         transfer_on_add_remove_line_ => TRUE); 
      END IF;                                                     
   END IF;
   
   Shipment_Source_Utility_API.Post_Connect_Shipment_Line(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                          source_ref_type_db_, new_line_, sales_qty_);
END New_Line___;


-- Delete_Component_Lines___
--   This procedure deletes the component lines(if any) when a shipmnet line is being deleted.
PROCEDURE Delete_Component_Lines___ (
   remrec_ IN SHIPMENT_LINE_TAB%ROWTYPE )
IS
   linerec_       SHIPMENT_LINE_TAB%ROWTYPE;
   CURSOR get_all_components IS
      SELECT rowid
      FROM   SHIPMENT_LINE_TAB
      WHERE  NVL(source_ref1, string_null_) = NVL(remrec_.source_ref1, string_null_) 
      AND    NVL(source_ref2, string_null_) = NVL(remrec_.source_ref2, string_null_) 
      AND    NVL(source_ref3, string_null_) = NVL(remrec_.source_ref3, string_null_) 
      AND    shipment_id                    = remrec_.shipment_id
      AND    source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
      AND    Utility_SYS.String_To_Number(source_ref4) > 0;
BEGIN
   IF ((remrec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)
       AND (Utility_SYS.String_To_Number(remrec_.source_ref4) = -1)) THEN
      FOR rec_ IN get_all_components LOOP
         linerec_ := Get_Object_By_Id___(rec_.rowid);
         Delete___(rec_.rowid, linerec_, NULL);
      END LOOP;
   END IF;
END Delete_Component_Lines___;


-- Remove_From_Shipment___
--   Removes a record from shipment.
PROCEDURE Pre_Delete_Actions___ (
   shipment_line_rec_       IN SHIPMENT_LINE_TAB%ROWTYPE,
   qty_modification_source_ IN VARCHAR2 )
IS
   new_open_shipment_qty_ NUMBER;
BEGIN
   -- When removing package parts all the components should also be removed.
   Delete_Component_Lines___(shipment_line_rec_);
   
   IF(shipment_line_rec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      new_open_shipment_qty_ := GREATEST(shipment_line_rec_.inventory_qty, shipment_line_rec_.qty_assigned);
   ELSE
      new_open_shipment_qty_ := shipment_line_rec_.inventory_qty; -- For sources like PD, only consider about inventory qty
   END IF;
   Shipment_Source_Utility_API.Modify_Source_Open_Ship_Qty(shipment_line_rec_.source_ref1, shipment_line_rec_.source_ref2,
                                                           shipment_line_rec_.source_ref3, shipment_line_rec_.source_ref4,
                                                           shipment_line_rec_.source_ref_type , -(new_open_shipment_qty_));
                               
   IF (qty_modification_source_ IS NULL) THEN
      -- Removing 'Reserved' or 'Picked' line must enable that line to be connected to a another shipment
      IF ((shipment_line_rec_.qty_picked> 0) AND ((shipment_line_rec_.source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) OR
                                                  ((shipment_line_rec_.source_ref_type  = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(shipment_line_rec_.source_ref4) >= 0)))) THEN
         IF (Shipment_Reserv_Handl_Unit_API.Handling_Unit_Exist(shipment_line_rec_.shipment_id,
                                                                shipment_line_rec_.shipment_line_no) = Fnd_Boolean_API.DB_TRUE) THEN
            Error_SYS.Record_General(lu_name_, 'HNDLUNTEXISTS: The shipment line :P1 cannot be deleted since there are picked reservations attached to a handling unit in shipment inventory.', shipment_line_rec_.shipment_line_no);                                                
         END IF;
         Shipment_Source_Utility_API.Remove_Picked_Line(shipment_line_rec_.shipment_id,
                                                        shipment_line_rec_.source_ref1,
                                                        shipment_line_rec_.source_ref2,
                                                        shipment_line_rec_.source_ref3,
                                                        shipment_line_rec_.source_ref4,
                                                        shipment_line_rec_.source_ref_type );
         
         IF (Shipment_API.Get_Ship_Inventory_Location_No(shipment_line_rec_.shipment_id) IS NULL) THEN
            Client_SYS.Add_Info(lu_name_,'COLINETOREL: Removal of this shipment line will clear all picked reservations.');
         ELSE
            Client_SYS.Add_Info(lu_name_,'AVAILMSG: A remaining picked qty of part :P1 on source line :P2 exists in Shipment Inventory.', shipment_line_rec_ .source_part_no, shipment_line_rec_.source_ref2);
         END IF;
      END IF;
      
      IF (shipment_line_rec_.qty_assigned > shipment_line_rec_.qty_picked) THEN         
         -- transfer reservations to the source line
         Reserve_Shipment_API.Transfer_Line_Reservations(source_ref1_                 => shipment_line_rec_.source_ref1,
                                                         source_ref2_                 => shipment_line_rec_.source_ref2,
                                                         source_ref3_                 => shipment_line_rec_.source_ref3,
                                                         source_ref4_                 => shipment_line_rec_.source_ref4, 
                                                         source_ref_type_db_          => shipment_line_rec_.source_ref_type,
                                                         from_shipment_id_            => shipment_line_rec_.shipment_id,
                                                         to_shipment_id_              => 0, 
                                                         qty_to_transfer_             => 0, 
                                                         transfer_on_add_remove_line_ => TRUE);
      END IF;
   END IF;

END Pre_Delete_Actions___;


PROCEDURE Modify_Line___ (
   attr_             IN OUT VARCHAR2,
   shipment_id_      IN NUMBER,
   shipment_line_no_ IN NUMBER )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   oldrec_           SHIPMENT_LINE_TAB%ROWTYPE;
   newrec_           SHIPMENT_LINE_TAB%ROWTYPE;
   indrec_           Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, shipment_line_no_);
   oldrec_ := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Line___;


FUNCTION Get_Handling_Unit_Type_Id___ (
   source_part_no_         IN VARCHAR2,
   source_unit_meas_       IN VARCHAR2,
   packing_instruction_id_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   handling_unit_type_id_         SHIPMENT_LINE_TAB.handling_unit_type_id%TYPE;
   part_handling_unit_type_tab_   Handling_Unit_Type_API.Unit_Type_Tab;
   packinstr_handl_unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;      
BEGIN 
   part_handling_unit_type_tab_ := Part_Handling_Unit_API.Get_Handl_Unit_Type_Id(source_part_no_, source_unit_meas_);
   IF (packing_instruction_id_ IS NULL) THEN 
      IF (part_handling_unit_type_tab_.COUNT > 0) THEN 
         handling_unit_type_id_ := part_handling_unit_type_tab_(1).handling_unit_type_id;
      END IF;
   ELSE
      packinstr_handl_unit_type_tab_ := Packing_Instruction_API.Get_Leaf_Nodes(packing_instruction_id_);
         
      IF (packinstr_handl_unit_type_tab_.COUNT > 0) THEN
         FOR i IN packinstr_handl_unit_type_tab_.FIRST..packinstr_handl_unit_type_tab_.LAST LOOP
            IF (part_handling_unit_type_tab_.COUNT > 0) THEN 
               FOR j IN part_handling_unit_type_tab_.FIRST..part_handling_unit_type_tab_.LAST LOOP
                  IF (packinstr_handl_unit_type_tab_(i).handling_unit_type_id = part_handling_unit_type_tab_(j).handling_unit_type_id) THEN 
                     handling_unit_type_id_ := packinstr_handl_unit_type_tab_(i).handling_unit_type_id;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
            EXIT WHEN handling_unit_type_id_ IS NOT NULL;
         END LOOP;
      END IF;
   END IF;
   
   RETURN handling_unit_type_id_;
END Get_Handling_Unit_Type_Id___;


PROCEDURE Update_Source_On_Reassign___ (
   shipment_line_rec_          IN SHIPMENT_LINE_TAB%ROWTYPE, 
   revised_qty_due_reassigned_ IN NUMBER,
   qty_to_ship_reassigned_     IN NUMBER,
   qty_modification_source_    IN VARCHAR2 )
IS  
   new_inventory_qty_      NUMBER:=0;
   connected_source_qty_   NUMBER:=0;
   objid_                  SHIPMENT_LINE.objid%TYPE;
   objversion_             SHIPMENT_LINE.objversion%TYPE;
   attr_                   VARCHAR2(4000);
   new_qty_to_ship_        NUMBER:=0;
BEGIN
   new_inventory_qty_    := shipment_line_rec_.inventory_qty - revised_qty_due_reassigned_;
   connected_source_qty_ := Shipment_Handling_Utility_API.Get_Converted_Source_Qty(shipment_line_rec_.shipment_id, 
                                                                                   shipment_line_rec_.shipment_line_no,
                                                                                   new_inventory_qty_,
                                                                                   shipment_line_rec_.conv_factor,
                                                                                   shipment_line_rec_.inverted_conv_factor);
   
   -- shipment_line_rec_ must be the locked instance of the record passed in to this method.
   IF (new_inventory_qty_ = 0) THEN
      Check_Delete___(shipment_line_rec_, qty_modification_source_);
      Get_Id_Version_By_Keys___(objid_, objversion_, shipment_line_rec_.shipment_id, shipment_line_rec_.shipment_line_no);
      Delete___(objid_, shipment_line_rec_, qty_modification_source_);
   ELSE
      Client_SYS.Clear_Attr(attr_);
      IF (qty_to_ship_reassigned_ > 0) THEN
         new_qty_to_ship_ := shipment_line_rec_.qty_to_ship - qty_to_ship_reassigned_;
         Client_SYS.Add_To_Attr('QTY_TO_SHIP',          new_qty_to_ship_,         attr_);
      END IF;
      Client_SYS.Add_To_Attr('INVENTORY_QTY',           new_inventory_qty_,       attr_);
      Client_SYS.Add_To_Attr('CONNECTED_SOURCE_QTY',    connected_source_qty_,    attr_);
      Client_SYS.Add_To_Attr('QTY_MODIFICATION_SOURCE', qty_modification_source_, attr_);
      Modify_Line___(attr_, shipment_line_rec_.shipment_id, shipment_line_rec_.shipment_line_no);
   END IF;

END Update_Source_On_Reassign___;


-- Add_Sales_Qty___
--   Add the sales_qty and revisedd_qty_due to the existing line
PROCEDURE Add_Sales_Qty___ (
   shipment_id_             IN NUMBER,
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2,
   source_ref_type_db_      IN VARCHAR2,
   revised_qty_due_         IN NUMBER,
   sales_qty_               IN NUMBER,
   qty_to_ship_             IN NUMBER,
   qty_modification_source_ IN VARCHAR2 )
IS
   oldrec_             SHIPMENT_LINE_TAB%ROWTYPE;
   attr_               VARCHAR2(2000);
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_ := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   oldrec_ := Lock_By_Keys___(shipment_id_, shipment_line_no_);   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('INVENTORY_QTY',           oldrec_.inventory_qty + revised_qty_due_,   attr_);
   Client_SYS.Add_To_Attr('CONNECTED_SOURCE_QTY',    oldrec_.connected_source_qty + sales_qty_,  attr_);
   Client_SYS.Add_To_Attr('QTY_TO_SHIP',             oldrec_.qty_to_ship + qty_to_ship_,         attr_);
   Client_SYS.Add_To_Attr('QTY_MODIFICATION_SOURCE', qty_modification_source_,                   attr_);  
   Modify_Line___(attr_, shipment_id_, shipment_line_no_);
END Add_Sales_Qty___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SHIPMENT_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   qty_modification_source_ VARCHAR2(20);
BEGIN
   qty_modification_source_ := Client_SYS.Get_Item_Value('QTY_MODIFICATION_SOURCE', attr_);
   IF (newrec_.handling_unit_type_id IS NULL) THEN 
      newrec_.handling_unit_type_id := Get_Handling_Unit_Type_Id___(newrec_.source_part_no,
                                                                    newrec_.source_unit_meas,
                                                                    newrec_.packing_instruction_id);
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
   Shipment_Source_Utility_API.Modify_Source_Open_Ship_Qty(newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3,
                                                           newrec_.source_ref4, newrec_.source_ref_type, newrec_.inventory_qty );
  
   Shipment_API.Update_Shipment__(newrec_.shipment_id, TRUE, TRUE, qty_modification_source_,
                                  newrec_.source_ref_type, Fnd_Boolean_API.DB_FALSE);

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SHIPMENT_LINE_TAB%ROWTYPE,
   newrec_     IN OUT SHIPMENT_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   no_of_reserved_pkgs_         NUMBER;
   qty_modification_source_     VARCHAR2(20);
   remove_manual_gross_weight_  BOOLEAN:=FALSE;
   reopen_shipment_             BOOLEAN:=FALSE;
   current_info_                VARCHAR2(32000);
   no_of_picked_pkgs_           NUMBER:=0;
   no_of_delivered_pkgs_        NUMBER:=0;
   shipment_line_no_pkg_        NUMBER;
   undo_delivery_               VARCHAR2(5);
BEGIN
   current_info_            := Client_SYS.Get_All_Info;
   qty_modification_source_ := Client_SYS.Get_Item_Value('QTY_MODIFICATION_SOURCE', attr_);
   
   IF (((Utility_SYS.String_To_Number(newrec_.source_ref4))> 0) AND (newrec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)) THEN
      shipment_line_no_pkg_ := Fetch_Ship_Line_No_By_Source(newrec_.shipment_id, newrec_.source_ref1, newrec_.source_ref2, 
                                                            newrec_.source_ref3, -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER );
   END IF;   

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (NVL(qty_modification_source_, Database_Sys.string_null_) NOT IN ('CONNECTED_QUANTITY', 'HANDLING_UNIT', 'RELEASE_NOT_RESERVED', 'ADD_ORDER_LINE')) THEN
      -- transfer reservations from customer order line to the specific shipment(if any)
      -- skip the scenario where inventory_qty is incraesed after a overpicking.
      IF ((newrec_.inventory_qty > oldrec_.inventory_qty) AND (NOT(newrec_.qty_picked > oldrec_.inventory_qty))) THEN
         Move_Reserved_From_Source___(oldrec_, newrec_);
      END IF;   
   END IF;
   
   -- Modify the open shipment qty of the Customer Order Line
   IF ((newrec_.inventory_qty != oldrec_.inventory_qty) OR (newrec_.qty_assigned != oldrec_.qty_assigned) 
        OR (newrec_.qty_shipped != oldrec_.qty_shipped))THEN
      Modify_Source_Open_Ship_Qty___(newrec_, oldrec_);
   END IF;
   
   -- update the qty_assigned, qty_to_ship if not a delivery, in the delivery process qty reserved qty's will be updated from delivery methods 
   IF ((newrec_.qty_assigned != oldrec_.qty_assigned AND newrec_.qty_shipped = 0 ) 
      AND (Utility_SYS.String_To_Number(newrec_.source_ref4) > 0 AND newrec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         no_of_reserved_pkgs_ := Shipment_Order_Utility_API.Get_No_Of_Packages_Reserved(newrec_.source_ref1, newrec_.source_ref2, 
                                                                                        newrec_.source_ref3, newrec_.shipment_id);  
      $END                                                                               
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('QTY_ASSIGNED', no_of_reserved_pkgs_, attr_);
      -- qty_modification_source_ is NULL when adding a picked customer order line from the shipment client. 
      -- In picking flows first qty_picked is set and then the qty_assigned is set, so it will not execute the below code block for picked qty. 
      IF ((newrec_.qty_picked != oldrec_.qty_picked) AND 
         ((qty_modification_source_ IS NULL) OR (NVL(qty_modification_source_, Database_Sys.string_null_) = 'CONNECTED_QUANTITY'))) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            no_of_picked_pkgs_ := Shipment_Order_Utility_API.Get_No_Of_Packages_Picked(newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3, newrec_.shipment_id);
         $END
         Client_SYS.Add_To_Attr('QTY_PICKED', no_of_picked_pkgs_, attr_);
      END IF; 
      $IF Component_Order_SYS.INSTALLED $THEN
         no_of_delivered_pkgs_ := Shipment_Order_Utility_API.Get_No_Of_Packages_Delivered(newrec_.source_ref1, newrec_.source_ref2, 
                                                                                          newrec_.source_ref3, newrec_.shipment_id);
      $END                                                                                 
      Client_SYS.Add_To_Attr('QTY_SHIPPED', no_of_delivered_pkgs_, attr_);
      Modify_Line___(attr_, newrec_.shipment_id, shipment_line_no_pkg_);      
   END IF;   
   
   IF (newrec_.qty_to_ship != oldrec_.qty_to_ship AND newrec_.qty_shipped = 0) THEN
      Shipment_Source_Utility_API.Handle_Line_Qty_To_Ship_Change(newrec_.shipment_id, newrec_.source_ref1, newrec_.source_ref2,
                                                                 newrec_.source_ref3, newrec_.source_ref4, newrec_.source_ref_type );
   END IF;   
  
   IF ((newrec_.connected_source_qty != oldrec_.connected_source_qty) OR (newrec_.inventory_qty != oldrec_.inventory_qty)) THEN
      Handle_Conn_Source_Qty_Chg___(newrec_, oldrec_, qty_modification_source_);
      remove_manual_gross_weight_ := TRUE;
   END IF;
  
   undo_delivery_ := NVL(Client_SYS.Get_Item_Value('UNDO_DELIVERY', attr_), 'FALSE');
   
   IF ((undo_delivery_ = 'FALSE') AND ((newrec_.qty_assigned != oldrec_.qty_assigned) OR (newrec_.connected_source_qty != oldrec_.connected_source_qty)) AND 
       (newrec_.qty_shipped = oldrec_.qty_shipped AND newrec_.qty_to_ship = oldrec_.qty_to_ship)) THEN
      reopen_shipment_ := TRUE;
   END IF;

   IF (remove_manual_gross_weight_ OR reopen_shipment_) THEN
      Shipment_API.Update_Shipment__(newrec_.shipment_id, remove_manual_gross_weight_, reopen_shipment_, 
                                     qty_modification_source_, NULL, Fnd_Boolean_API.DB_FALSE);
   END IF;
   
   Reset_Printed_Flags___(oldrec_, newrec_);
   
   Client_Sys.Merge_Info(current_info_);
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_                  IN SHIPMENT_LINE_TAB%ROWTYPE,
   qty_modification_source_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   IF (qty_modification_source_ IS NULL) THEN
      IF (Shipment_API.Get_Objstate(remrec_.shipment_id) != 'Preliminary') THEN
         Error_SYS.Record_General(lu_name_,'SHIPMENTNOTREMOVE: Shipment order lines can only be canceled on when the connected shipment is in Preliminary state.');
      END IF;
      -- Note: Reservation for the customer order line would exist even if the connection is removed
      --       If the pick list is created for the reserved line then it should not be possible to remove the line.
      Pick_Shipment_API.Validate_Pick_List_Status(remrec_.shipment_id, remrec_.source_ref1, remrec_.source_ref2,
                                                  remrec_.source_ref3, remrec_.source_ref4, remrec_.source_ref_type);
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_                   IN VARCHAR2,
   remrec_                  IN SHIPMENT_LINE_TAB%ROWTYPE,
   qty_modification_source_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN 
   Pre_Delete_Actions___(remrec_, qty_modification_source_);
   IF (qty_modification_source_ IS NULL) THEN
      Shipment_API.Check_Reset_Printed_Flags(shipment_id_                => remrec_.shipment_id,
                                             unset_pkg_list_print_       => TRUE,
                                             unset_consignment_print_    => TRUE, 
                                             unset_del_note_print_       => TRUE, 
                                             unset_pro_forma_print_      => FALSE,
                                             unset_bill_of_lading_print_ => TRUE,
                                             unset_address_label_print_  => FALSE );
   END IF;

   super(objid_, remrec_); 
  
   Shipment_Source_Utility_API.Post_Delete_Ship_Line(remrec_.shipment_id, remrec_.source_ref1,remrec_.source_ref2,
                                                     remrec_.source_ref3, remrec_.source_ref4, remrec_.source_ref_type);
   Shipment_API.Update_Shipment__(remrec_.shipment_id, TRUE, TRUE, qty_modification_source_, 
                                  remrec_.source_ref_type, Fnd_Boolean_API.DB_TRUE);                              
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(4000);
   calc_inventory_qty_     NUMBER;
BEGIN
   IF (indrec_.shipment_line_no = FALSE ) THEN
      newrec_.shipment_line_no := Get_Next_Shipment_Line_No___(newrec_.shipment_id);   
   END IF;
   
   IF (indrec_.connected_source_qty = FALSE) THEN
      newrec_.connected_source_qty := 0;
   END IF;
   
   IF (indrec_.inventory_qty = FALSE) THEN
      calc_inventory_qty_ := Shipment_Handling_Utility_API.Get_Converted_Inv_Qty(newrec_.shipment_id,
                                                                                 newrec_.shipment_line_no,
                                                                                 newrec_.connected_source_qty,
                                                                                 newrec_.conv_factor,
                                                                                 newrec_.inverted_conv_factor);
      -- calculated value for calc_revise_qty_due_ could exceed 38 decimal points sometimes. Therefor it is
      -- rounded for 38 because maximum guaranteed precision for Oracle numbers is 38.
      IF ((length(calc_inventory_qty_)-INSTR(calc_inventory_qty_,'.')) > 38) THEN
         calc_inventory_qty_ := ROUND(calc_inventory_qty_, 38);
      END IF;
      newrec_.inventory_qty := calc_inventory_qty_;
   END IF;
   
   IF (indrec_.qty_assigned = FALSE) THEN
      newrec_.qty_assigned := 0;   
   END IF;
   
   IF (indrec_.qty_shipped = FALSE) THEN
      newrec_.qty_shipped := 0;   
   END IF;
   
   IF (indrec_.qty_picked = FALSE) THEN
      newrec_.qty_picked := 0;
   END IF;
   
   IF (indrec_.conv_factor = FALSE) THEN
      newrec_.conv_factor := 1;   
   END IF;
   
   IF (indrec_.inverted_conv_factor = FALSE) THEN
      newrec_.inverted_conv_factor := 1;   
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   Shipment_Source_Utility_API.Source_Exist(newrec_.shipment_id, newrec_.source_ref1, newrec_.source_ref2,
                                            newrec_.source_ref3, newrec_.source_ref4, newrec_.source_ref_type);
                                            
   IF (Source_Exist(newrec_.shipment_id, newrec_.source_ref_type, newrec_.source_ref1, newrec_.source_ref2,
                    newrec_.source_ref3, newrec_.source_ref4)) THEN
      Error_SYS.Record_Exist(lu_name_);                             
   END IF;
   
   IF (newrec_.connected_source_qty <= 0) THEN
      Error_Sys.Record_General(lu_name_, 'QTY_LESS_THAN_ZERO: Quantity must be greater than zero.');
   END IF;
   
   IF (Shipment_API.Get_Objstate(newrec_.shipment_id) = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_,'SHIPMENTCANCELLEDNEW: Source lines cannot be added to canceled shipments.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     shipment_line_tab%ROWTYPE,
   newrec_ IN OUT shipment_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                          VARCHAR2(30);
   value_                         VARCHAR2(4000);   
   available_inv_qty_             NUMBER;
   available_source_qty_          NUMBER;
   $IF Component_Order_SYS.INSTALLED $THEN
      order_line_rec_                Customer_Order_Line_API.Public_Rec;
   $END
   qty_modification_source_       VARCHAR2(20);
   packinstr_handl_unit_type_tab_ Handling_Unit_Type_API.Unit_Type_Tab;
   handling_unit_type_id_found_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   calc_inventory_qty_            NUMBER;
   shipment_line_rec_             Shipment_Source_Utility_API.Public_Line_Rec;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.connected_source_qty <= 0) THEN
      Error_Sys.Record_General(lu_name_, 'QTY_LESS_THAN_ZERO: Quantity must be greater than zero.');
   END IF;  
   IF indrec_.connected_source_qty = TRUE THEN
      IF ((newrec_.connected_source_qty <> FLOOR(newrec_.connected_source_qty)) AND (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(newrec_.source_part_no) = Fnd_Boolean_API.DB_TRUE)) THEN
         Error_SYS.Appl_General(lu_name_, 'DECIMALNOTALLOW: The quantity should be an integer for serial tracked parts.');
      END IF;
   END IF;
        
   qty_modification_source_ := Client_SYS.Get_Item_Value('QTY_MODIFICATION_SOURCE', attr_);   
       
   IF (newrec_.connected_source_qty != oldrec_.connected_source_qty) THEN
      IF (newrec_.inventory_qty = oldrec_.inventory_qty) THEN
         calc_inventory_qty_ := Shipment_Handling_Utility_API.Get_Converted_Inv_Qty(newrec_.shipment_id,
                                                                                 newrec_.shipment_line_no,
                                                                                 newrec_.connected_source_qty,
                                                                                 newrec_.conv_factor,
                                                                                 newrec_.inverted_conv_factor);
         -- calculated value for calc_revise_qty_due_ could exceed 38 decimal points sometimes. Therefor it is
         -- rounded for 38 because maximum guaranteed precision for Oracle numbers is 38.
         IF ((length(calc_inventory_qty_)-INSTR(calc_inventory_qty_,'.')) > 38) THEN
            calc_inventory_qty_ := ROUND(calc_inventory_qty_, 38);
         END IF;

         newrec_.inventory_qty := calc_inventory_qty_;
      END IF;

      IF ((NVL(qty_modification_source_, Database_Sys.string_null_) NOT IN ('CONNECTED_QUANTITY', 'HANDLING_UNIT', 'RELEASE_NOT_RESERVED')) AND (newrec_.inventory_qty < oldrec_.qty_assigned)  AND newrec_.qty_picked = oldrec_.qty_picked ) THEN
         Error_Sys.Record_General(lu_name_, 'LESSTHANRESERVE: The quantity cannot be less than the reserved quantity. The quantity can be changed by releasing the reservation or reassigning the connected quantity.');
      END IF;
      IF (newrec_.qty_shipped > 0) THEN
         Error_Sys.Record_General(lu_name_, 'SHPMNTLINEDELIVERED: Connected source quantity cannot be changed since the specified shipment line has been delivered.');
      ELSE
         available_inv_qty_ := Shipment_Source_Utility_API.Get_Tot_Avail_Qty_To_Connect(newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3, newrec_.source_ref4, newrec_.source_ref_type, oldrec_.inventory_qty);         
         -- when overpicked, revised qty will be increased to picked qty.
         IF ((NVL(qty_modification_source_, Database_Sys.string_null_) NOT IN ('CONNECTED_QUANTITY', 'HANDLING_UNIT', 'RELEASE_NOT_RESERVED')) 
            AND (newrec_.inventory_qty > available_inv_qty_) AND (NOT(newrec_.qty_picked > oldrec_.inventory_qty))) THEN
            available_source_qty_ :=  Shipment_Handling_Utility_API.Get_Converted_Source_Qty(newrec_.shipment_id,
                                                                                            newrec_.shipment_line_no,
                                                                                            available_inv_qty_,
                                                                                            newrec_.conv_factor,
                                                                                            newrec_.inverted_conv_factor);
            Error_Sys.Record_General(lu_name_, 'EXCEED_AVAILABLE_QTY: Connected source quantity cannot be changed to a value greater than :P1, which is the quantity available for shipment connection.', available_source_qty_);

         END IF;       
         shipment_line_rec_ := Shipment_Source_Utility_API.Get_Line(newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3, newrec_.source_ref4, newrec_.source_ref_type);
         IF ((newrec_.inventory_part_no IS NULL) AND (Shipment_Source_Utility_API.Check_Tot_Qty_To_Ship(newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3, newrec_.source_ref4, newrec_.source_ref_type) OR (shipment_line_rec_.supply_code IN ('PT','IPT') AND (newrec_.qty_to_ship > newrec_.inventory_qty)))) THEN
            Client_Sys.Add_Info(lu_name_, 'QTY_DEL_UPDATE: Quantity Non Inventory to Deliver has been updated.');
            newrec_.qty_to_ship := newrec_.inventory_qty;
         END IF;         
      END IF;   
      Shipment_Source_Utility_API.Check_Update_Connected_Src_Qty(newrec_.source_ref1, newrec_.source_ref_type);     
   END IF;         

   IF ((NVL(newrec_.handling_unit_type_id, Database_Sys.string_null_)  != NVL(oldrec_.handling_unit_type_id, Database_Sys.string_null_)) OR
       (NVL(newrec_.packing_instruction_id, Database_Sys.string_null_) != NVL(oldrec_.packing_instruction_id, Database_Sys.string_null_))) THEN
       
      IF (newrec_.packing_instruction_id IS NOT NULL) THEN
         Part_Handling_Unit_API.Check_Combination(newrec_.source_part_no,
                                                  newrec_.source_unit_meas,
                                                  newrec_.packing_instruction_id);
         
         packinstr_handl_unit_type_tab_ := Packing_Instruction_API.Get_Leaf_Nodes(newrec_.packing_instruction_id);
         IF (packinstr_handl_unit_type_tab_.COUNT > 0) THEN
            FOR i IN packinstr_handl_unit_type_tab_.FIRST..packinstr_handl_unit_type_tab_.LAST LOOP
               IF (packinstr_handl_unit_type_tab_(i).handling_unit_type_id = newrec_.handling_unit_type_id) THEN 
                  handling_unit_type_id_found_ := Fnd_Boolean_API.DB_TRUE;
                  EXIT;
               END IF;
            END LOOP;
         END IF;

         IF (handling_unit_type_id_found_ = Fnd_Boolean_API.DB_FALSE) THEN 
            IF ((NVL(newrec_.handling_unit_type_id, Database_Sys.string_null_) != NVL(oldrec_.handling_unit_type_id, Database_Sys.string_null_)) AND
                (NVL(newrec_.packing_instruction_id, Database_Sys.string_null_) = NVL(oldrec_.packing_instruction_id, Database_Sys.string_null_))) THEN
               newrec_.packing_instruction_id := NULL;
            ELSIF (NVL(newrec_.packing_instruction_id, Database_Sys.string_null_) != NVL(oldrec_.packing_instruction_id, Database_Sys.string_null_)) THEN
               newrec_.handling_unit_type_id := Get_Handling_Unit_Type_Id___(newrec_.source_part_no,
                                                                             newrec_.source_unit_meas,
                                                                             newrec_.packing_instruction_id);
               IF (newrec_.handling_unit_type_id IS NULL) THEN
                  Raise_No_Hu_Capacity_Error___;
               END IF;
            END IF;
         END IF;
      END IF;
      IF (newrec_.handling_unit_type_id IS NOT NULL) THEN 
         Part_Handling_Unit_API.Check_Handling_Unit_Type(newrec_.source_part_no,
                                                         newrec_.source_unit_meas,
                                                         newrec_.handling_unit_type_id);
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-- Get_Next_Shipment_Line_No___
--   This method returns the next line no that should have for the new shipment line.
FUNCTION Get_Next_Shipment_Line_No___( 
   shipment_id_ IN NUMBER ) RETURN VARCHAR2 
IS 
   shipment_line_no_ NUMBER := 0;
   
   CURSOR get_next_shipment_line_no is
      SELECT MAX(shipment_line_no)
      FROM   shipment_line_tab
      WHERE  shipment_id = shipment_id_;       
BEGIN
   OPEN get_next_shipment_line_no;
   FETCH get_next_shipment_line_no INTO shipment_line_no_;
   CLOSE get_next_shipment_line_no; 
   IF (shipment_line_no_ IS NULL) THEN
      shipment_line_no_ := 1;
   ELSE
      shipment_line_no_ := (shipment_line_no_ + 1);
   END IF;         
   RETURN shipment_line_no_;
END Get_Next_Shipment_Line_No___;


PROCEDURE Move_Reserved_From_Source___ (
   oldrec_   IN shipment_line_tab%ROWTYPE,
   newrec_   IN shipment_line_tab%ROWTYPE  )
IS
   qty_assigned_source_    NUMBER:=0;
   qty_diff_to_transfer_   NUMBER:=0;
BEGIN
   qty_assigned_source_ := Reserve_Shipment_API.Get_Total_Qty_Reserved(newrec_.source_ref1, newrec_.source_ref2, 
                                                                       newrec_.source_ref3, newrec_.source_ref4,
                                                                       newrec_.source_ref_type, 0);
   IF (qty_assigned_source_ > 0) THEN 
      qty_diff_to_transfer_    := newrec_.inventory_qty - oldrec_.inventory_qty;
      IF (qty_diff_to_transfer_ > qty_assigned_source_) THEN
         qty_diff_to_transfer_ := qty_assigned_source_; 
      END IF; 
      Reserve_Shipment_API.Transfer_Line_Reservations(source_ref1_                 => newrec_.source_ref1,
                                                      source_ref2_                 => newrec_.source_ref2,
                                                      source_ref3_                 => newrec_.source_ref3, 
                                                      source_ref4_                 => newrec_.source_ref4, 
                                                      source_ref_type_db_          => newrec_.source_ref_type,
                                                      from_shipment_id_            => 0, 
                                                      to_shipment_id_              => newrec_.shipment_id, 
                                                      qty_to_transfer_             => qty_diff_to_transfer_,
                                                      transfer_on_add_remove_line_ => FALSE );
   END IF;
         
END Move_Reserved_From_Source___;   


PROCEDURE Reset_Printed_Flags___ (
   oldrec_   IN shipment_line_tab%ROWTYPE,
   newrec_   IN shipment_line_tab%ROWTYPE  )
IS
   unset_pkg_list_print_       BOOLEAN:=FALSE;
   unset_consignment_print_    BOOLEAN:=FALSE;
   unset_del_note_print_       BOOLEAN:=FALSE;
   unset_pro_forma_print_      BOOLEAN:=FALSE;
   unset_bill_of_lading_print_ BOOLEAN:=FALSE;
   unset_address_label_print_  BOOLEAN:=FALSE;
   inventory_part_             BOOLEAN:=FALSE;
   shipment_rec_               Shipment_API.Public_Rec;
BEGIN
   shipment_rec_ := Shipment_API.Get(newrec_.shipment_id);
   
   IF (Shipment_API.Any_Printed_Flag_Set__(newrec_.shipment_id) = 'FALSE') THEN
      RETURN;
   END IF;
   
   IF (newrec_.inventory_part_no IS NOT NULL) THEN
      inventory_part_ := TRUE;            
   END IF;   
   
   IF (Validate_SYS.Is_Changed(oldrec_.customs_value, newrec_.customs_value))   THEN
      unset_pro_forma_print_  := TRUE;
   END IF;
   
   IF ((Validate_SYS.Is_Changed(oldrec_.connected_source_qty, newrec_.connected_source_qty)) OR
       ((Validate_SYS.Is_Changed(ABS(newrec_.qty_assigned - oldrec_.qty_assigned), ABS(newrec_.qty_shipped - oldrec_.qty_shipped))) AND (inventory_part_))OR
       ((Validate_SYS.Is_Changed(ABS(newrec_.qty_picked - oldrec_.qty_picked), ABS(newrec_.qty_shipped - oldrec_.qty_shipped))) AND (inventory_part_))OR
       ((Validate_SYS.Is_Changed(ABS(newrec_.qty_to_ship - oldrec_.qty_to_ship), ABS(newrec_.qty_shipped - oldrec_.qty_shipped))) AND (NOT inventory_part_))OR
       (Validate_SYS.Is_Changed(oldrec_.source_part_description, newrec_.source_part_description))) THEN
      unset_pkg_list_print_  := TRUE;
   END IF; 
   
   IF ((Validate_SYS.Is_Changed(oldrec_.connected_source_qty, newrec_.connected_source_qty)) OR
       ((shipment_rec_.rowstate = 'Preliminary') AND (Validate_SYS.Is_Changed(oldrec_.qty_picked,  newrec_.qty_picked)))  OR
       (Validate_SYS.Is_Changed(oldrec_.qty_to_ship, newrec_.qty_to_ship)) OR
       ((shipment_rec_.rowstate = 'Preliminary') AND (Validate_SYS.Is_Changed(oldrec_.qty_shipped, newrec_.qty_shipped))) OR
       (Validate_SYS.Is_Changed(oldrec_.source_part_description, newrec_.source_part_description))) THEN
      unset_del_note_print_ := TRUE; 
   END IF;    
   
   IF (unset_pro_forma_print_ OR unset_del_note_print_ OR unset_pkg_list_print_) THEN
      Shipment_API.Reset_Printed_Flags__(newrec_.shipment_id         ,
                                         unset_pkg_list_print_       ,
                                         unset_consignment_print_    ,
                                         unset_del_note_print_       ,
                                         unset_pro_forma_print_      ,
                                         unset_bill_of_lading_print_ ,
                                         unset_address_label_print_  );      
   END IF;                                   
END Reset_Printed_Flags___;   


PROCEDURE Handle_Conn_Source_Qty_Chg___ (
   newrec_                  IN SHIPMENT_LINE_TAB%ROWTYPE,
   oldrec_                  IN SHIPMENT_LINE_TAB%ROWTYPE,
   qty_modification_source_ IN VARCHAR2)
IS
   info_   VARCHAR2(1000);
BEGIN
   -- When RELEASE_NOT_RESERVED, pkg components will be updated based on PKG header value.
   IF ((qty_modification_source_ IS NULL) OR (qty_modification_source_ = 'RELEASE_NOT_RESERVED')) THEN
      Shipment_Source_Utility_API.Handle_Ship_Line_Qty_Change(newrec_.shipment_id, newrec_.source_ref1, newrec_.source_ref2,
                                                              newrec_.source_ref3, newrec_.source_ref4, newrec_.source_ref_type, newrec_.inventory_qty);
   END IF;
   
   IF ((NVL(qty_modification_source_,  Database_Sys.string_null_) != 'HANDLING_UNIT') AND (newrec_.connected_source_qty < oldrec_.connected_source_qty)) THEN 
      Shipment_Line_Handl_Unit_API.Remove_Or_Modify(info_             => info_,
                                                    shipment_id_      => newrec_.shipment_id,
                                                    shipment_line_no_ => newrec_.shipment_line_no, 
                                                    new_quantity_     => newrec_.connected_source_qty,
                                                    only_check_       => FALSE,
                                                    qty_modification_source_ => qty_modification_source_,
                                                    prev_inv_qty_     => oldrec_.inventory_qty );
   END IF;
   
END Handle_Conn_Source_Qty_Chg___;   


PROCEDURE Modify_Source_Open_Ship_Qty___ (
   newrec_   IN SHIPMENT_LINE_TAB%ROWTYPE,
   oldrec_   IN SHIPMENT_LINE_TAB%ROWTYPE )
IS
   open_shipment_qty_   NUMBER := 0;    
BEGIN
   IF(newrec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN  
      IF ((newrec_.inventory_qty != oldrec_.inventory_qty) OR ((newrec_.qty_assigned != oldrec_.qty_assigned) AND (newrec_.qty_assigned > 0))) THEN
         open_shipment_qty_ := GREATEST(newrec_.inventory_qty, newrec_.qty_assigned) - GREATEST(oldrec_.inventory_qty, oldrec_.qty_assigned) ;            
      END IF;    
      IF (newrec_.qty_shipped != oldrec_.qty_shipped) AND (newrec_.qty_shipped != 0) THEN
         -- Used oldrec_.qty_assigned to handle over picked scenario and newrec_.qty_assigned is already updated
         IF NOT(newrec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER 
                AND Utility_SYS.String_To_Number(newrec_.source_ref4) = -1) THEN
            open_shipment_qty_ := -(GREATEST(newrec_.inventory_qty, oldrec_.qty_assigned));            
         END IF;
      END IF;        
   ELSE
      IF (newrec_.inventory_qty != oldrec_.inventory_qty) THEN
         open_shipment_qty_ := newrec_.inventory_qty - oldrec_.inventory_qty; -- For sources like PD, only consider about inventory qty          
      END IF;       
   END IF;
   
   IF(open_shipment_qty_ != 0) THEN
      Shipment_Source_Utility_API.Modify_Source_Open_Ship_Qty(newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3,
                                                              newrec_.source_ref4, newrec_.source_ref_type, open_shipment_qty_ );
   END IF;
END Modify_Source_Open_Ship_Qty___; 

PROCEDURE Get_Net_And_Adjusted_Volume___ (
   net_volume_           OUT NUMBER,
   adj_net_volume_       OUT NUMBER,
   shipment_id_          IN  NUMBER,
   shipment_line_no_     IN  NUMBER,
   uom_for_volume_       IN  VARCHAR2)
IS
   line_rec_                 Shipment_Line_API.Public_Rec;
   part_catalog_rec_         Part_Catalog_API.Public_Rec;
   conversion_factor_        NUMBER;
   unit_conv_volume_         NUMBER;
BEGIN
   line_rec_          := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
   part_catalog_rec_  := Part_Catalog_API.Get(line_rec_.source_part_no);
   
   IF (part_catalog_rec_.volume_net IS NULL) THEN
      part_catalog_rec_  := Part_Catalog_API.Get(line_rec_.inventory_part_no);
   END IF;
   
   conversion_factor_ := Technical_Unit_Conv_API.Get_Valid_Conv_Factor(line_rec_.source_unit_meas, part_catalog_rec_.unit_code);
   IF (part_catalog_rec_.volume_net IS NOT NULL) THEN                                               
      unit_conv_volume_        := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => part_catalog_rec_.volume_net,
                                                                           from_unit_code_   => part_catalog_rec_.uom_for_volume_net,
                                                                           to_unit_code_     => uom_for_volume_);  
   ELSE
      unit_conv_volume_ := 0;
   END IF;
   
   net_volume_     := NVL(line_rec_.connected_source_qty * unit_conv_volume_ * conversion_factor_, 0); 
   adj_net_volume_ := NVL(net_volume_ * part_catalog_rec_.freight_factor, 0);
END Get_Net_And_Adjusted_Volume___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Update_Source_On_Reassign__ (
   shipment_id_                IN NUMBER,
   shipment_line_no_           IN NUMBER,
   revised_qty_due_reassigned_ IN NUMBER,
   qty_to_ship_reassigned_     IN NUMBER,
   qty_modification_source_    IN VARCHAR2 )
IS 
   shipment_line_rec_  SHIPMENT_LINE_TAB%ROWTYPE;
BEGIN
   shipment_line_rec_ := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   Update_Source_On_Reassign___(shipment_line_rec_, revised_qty_due_reassigned_, qty_to_ship_reassigned_, qty_modification_source_ );
END Update_Source_On_Reassign__;


PROCEDURE Complete_Pkg_Reassignment__ (
   source_shipment_id_         IN NUMBER,
   source_shipment_line_no_    IN NUMBER,
   destination_shipment_id_    IN NUMBER,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   rel_no_                     IN VARCHAR2,
   line_item_no_               IN NUMBER,
   revised_qty_due_reassigned_ IN NUMBER,
   qty_to_ship_reassigned_     IN NUMBER,
   qty_modification_source_    IN VARCHAR2 )
IS 
   source_shipment_line_rec_   SHIPMENT_LINE_TAB%ROWTYPE;
BEGIN
   source_shipment_line_rec_ := Lock_By_Keys___(source_shipment_id_, source_shipment_line_no_);
   -- Update the source PKG line
   Update_Source_On_Reassign___(source_shipment_line_rec_, revised_qty_due_reassigned_, qty_to_ship_reassigned_, qty_modification_source_);
   
END Complete_Pkg_Reassignment__;


PROCEDURE Reassign_Line__ (
   destination_shipment_line_no_ OUT NUMBER,
   source_shipment_id_           IN  NUMBER,
   destination_shipment_id_      IN  NUMBER,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   source_ref_type_db_           IN  VARCHAR2,
   source_part_no_               IN  VARCHAR2, 
   source_part_description_      IN  VARCHAR2,     
   inventory_part_no_            IN  VARCHAR2, 
   source_unit_meas_             IN  VARCHAR2,
   conv_factor_                  IN  NUMBER,         
   inverted_conv_factor_         IN  NUMBER, 
   revised_qty_due_              IN  NUMBER,
   qty_to_ship_                  IN  NUMBER,
   qty_modification_source_      IN  VARCHAR2,
   customs_value_                IN  NUMBER)
IS      
   sales_qty_         NUMBER;
   public_line_rec_   Shipment_Source_Utility_API.Public_Line_Rec;
BEGIN
   public_line_rec_ := Shipment_Source_Utility_API.Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_); 
   sales_qty_       := revised_qty_due_ * inverted_conv_factor_/conv_factor_;   
   New_Line___(destination_shipment_line_no_,
               destination_shipment_id_,
               source_ref1_,
               source_ref2_,
               source_ref3_,
               source_ref4_,
               source_ref_type_db_,
               source_part_no_,
               source_part_description_,
               inventory_part_no_,
               source_unit_meas_ ,
               conv_factor_,         
               inverted_conv_factor_, 
               revised_qty_due_,
               sales_qty_,
               0,
               0, 
               qty_to_ship_,
               public_line_rec_.packing_instruction_id,
               customs_value_,
               qty_modification_source_,
               TRUE );

END Reassign_Line__;


@UncheckedAccess
PROCEDURE Lock__ (
   shipment_id_        IN NUMBER,
   shipment_line_no_   IN NUMBER )
IS
   dummy_        SHIPMENT_LINE_TAB%ROWTYPE;
   objid_        SHIPMENT_LINE.objid%TYPE;
   objversion_   SHIPMENT_LINE.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, shipment_line_no_);
   dummy_ := Lock_By_Id___(objid_, objversion_);
END Lock__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Is_Instance_Exist (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_            NUMBER;
   result_          VARCHAR2(5);
   invalid_instance EXCEPTION;
   PRAGMA exception_init(invalid_instance, -01410);

   CURSOR instance_ IS
      SELECT 1
      FROM SHIPMENT_LINE
      WHERE objid      = objid_
      AND   objversion = objversion_;
BEGIN
   OPEN instance_;
   FETCH instance_ INTO temp_;
   IF instance_%FOUND THEN
      result_ := 'TRUE';
   ELSE
      result_ := 'FALSE';
   END IF;
   CLOSE instance_;
   
   RETURN result_;
EXCEPTION
   WHEN invalid_instance THEN
      CLOSE instance_;
      RETURN 'FALSE';
END Is_Instance_Exist;


PROCEDURE Connect_To_New_Handling_Units (
   info_                     OUT VARCHAR2,
   handling_unit_id_tab_     OUT Handling_Unit_API.Handling_Unit_Id_Tab,
   shipment_id_               IN NUMBER,
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,
   handling_unit_type_id_     IN VARCHAR2,
   quantity_to_connect_       IN NUMBER,
   packing_instruction_id_    IN VARCHAR2,
   shipment_line_no_          IN NUMBER,
   parent_handling_unit_id_   IN NUMBER DEFAULT NULL)
IS
   max_quantity_capacity_    NUMBER;
   qty_left_to_connect_      NUMBER;
   handling_unit_id_         NUMBER;
   quantity_to_be_added_     NUMBER;
   no_of_reservation_lines_  NUMBER;
   rows_                     PLS_INTEGER := 1;
   remain_res_to_hu_connect_ NUMBER;
   shipment_line_rec_        SHIPMENT_LINE_TAB%ROWTYPE;
   remain_res_in_sales_uom_    NUMBER;
   inv_qty_to_be_added_        NUMBER := 0;  
   handling_unit_rec_        Handling_Unit_API.Public_Rec;
BEGIN
   shipment_line_rec_     := Get_Object_By_Keys___(shipment_id_, shipment_line_no_);
   max_quantity_capacity_ := Part_Handling_Unit_API.Get_Max_Quantity_Capacity(shipment_line_rec_.source_part_no,
                                                                              handling_unit_type_id_,
                                                                              shipment_line_rec_.source_unit_meas);
   IF (max_quantity_capacity_ > 0) THEN
      qty_left_to_connect_ := quantity_to_connect_;
      
      Inventory_Event_Manager_API.Start_Session; 
      LOOP
         IF (max_quantity_capacity_ <= qty_left_to_connect_) THEN
            quantity_to_be_added_ := max_quantity_capacity_;
         ELSE
            quantity_to_be_added_ := qty_left_to_connect_;
         END IF;
         
         -- Creating the handling unit using the packing instruction
         Handling_Unit_API.New_With_Pack_Instr_Settings(handling_unit_id_        => handling_unit_id_,
                                                        handling_unit_type_id_   => handling_unit_type_id_,
                                                        packing_instruction_id_  => packing_instruction_id_,
                                                        parent_handling_unit_id_ => parent_handling_unit_id_,
                                                        shipment_id_             => shipment_id_);
         
         @ApproveTransactionStatement(2013-06-12,jelise)
         SAVEPOINT before_attaching_to_handl_unit;
         -- attach the quantity to the handling unit
         Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(shipment_id_,
                                                             shipment_line_no_,
                                                             handling_unit_id_,
                                                             quantity_to_be_added_ );
                                                             
         no_of_reservation_lines_ := Shipment_Reserv_Handl_Unit_API.Get_Number_Of_Lines(shipment_id_,
                                                                                        source_ref1_,
                                                                                        NVL(source_ref2_,'*'),
                                                                                        NVL(source_ref3_,'*'),
                                                                                        NVL(source_ref4_,'*'),
                                                                                        shipment_line_rec_.source_ref_type);
                                                                                            
         -- Example usage of the exception block
         
         -- max_quantity_capacity_ is set to 10, quantity_to_be_added_ is also set to 10
         -- A handling unit is created in Handling_Unit_API.New_With_Pack_Instr_Settings.
         -- The shipment line is connected to the handling unit, created above, with qty 10. 
         -- No_of_reservation_lines_ is in the above example set to 2, where 5 pcs have lot/batch no A and 5 pcs have B.
         -- When trying to add the second reservation record there will be an error since the packing instruction
         -- is set up to not allow mix of lot batch numbers, so we will end up in the exception handling.
         -- Handling unit connection qty and resrevered handling unit qty connection will be rolled back.
         -- remain_res_to_hu_connect_ is set to 5(fetch first record of the remaining reservations).
         -- quantity_to_be_added_ will then be set to 5.
         -- The shipment line will be connected to the handling unit, created above, with qty 5 
         -- The reservations of 5 for lot batch A will now be added to the handling unit. 
         -- Now one of the reserved lines have been connected, the second will be connected to a new 
         -- handling unit that will be created when we go back to the beginning of the loop.
         
         IF (no_of_reservation_lines_ > 0) THEN 
            DECLARE
               mix_of_blocked EXCEPTION;
               PRAGMA         EXCEPTION_INIT(mix_of_blocked, -20110);
            BEGIN
               -- attach the reservations to the handling unit   
               Shipment_Reserv_Handl_Unit_API.Add_Reservations_To_Handl_Unit(info_                 => info_,
                                                                             source_ref1_          => source_ref1_,
                                                                             source_ref2_          => NVL(source_ref2_,'*'),
                                                                             source_ref3_          => NVL(source_ref3_,'*'),
                                                                             source_ref4_          => NVL(source_ref4_,'*'),
                                                                             source_ref_type_db_   => shipment_line_rec_.source_ref_type,
                                                                             shipment_id_          => shipment_id_,
                                                                             shipment_line_no_     => shipment_line_no_,
                                                                             handling_unit_id_     => handling_unit_id_,
                                                                             quantity_to_be_added_ => 0);
            EXCEPTION
               WHEN mix_of_blocked THEN
                  @ApproveTransactionStatement(2013-06-12,jelise)
                  ROLLBACK TO before_attaching_to_handl_unit;
                  
                  -- fetch remaining qty on reservation lines to attach to the handling unit
                  remain_res_to_hu_connect_ := Shipment_Reserv_Handl_Unit_API.Get_Remain_Res_To_Hu_Connect(shipment_id_,
                                                                                                           source_ref1_,
                                                                                                           NVL(source_ref2_,'*'),
                                                                                                           NVL(source_ref3_,'*'),
                                                                                                           NVL(source_ref4_,'*'),
                                                                                                           shipment_line_rec_.source_ref_type);
                  
                  remain_res_in_sales_uom_ := Shipment_Handling_Utility_API.Get_Converted_Source_Qty(shipment_id_,
                                                                                                        shipment_line_rec_.shipment_line_no,
                                                                                                        remain_res_to_hu_connect_,
                                                                                                        shipment_line_rec_.conv_factor,
                                                                                                        shipment_line_rec_.inverted_conv_factor);
                  
                  quantity_to_be_added_ := LEAST(remain_res_in_sales_uom_, max_quantity_capacity_);
                  Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(shipment_id_,
                                                                      shipment_line_no_,
                                                                      handling_unit_id_,
                                                                      quantity_to_be_added_ );
                  -- Only set the value for inv_qty_to_be_added_ other than 0 when we want only to add one reservation
                  -- line to the handling unit when exception is occured
                  IF (quantity_to_be_added_ = remain_res_in_sales_uom_) THEN
                     inv_qty_to_be_added_ := remain_res_to_hu_connect_;
                  ELSE
                     inv_qty_to_be_added_ := 0;
                  END IF;   
                  Shipment_Reserv_Handl_Unit_API.Add_Reservations_To_Handl_Unit(info_                 => info_,
                                                                                source_ref1_          => source_ref1_,
                                                                                source_ref2_          => NVL(source_ref2_,'*'),
                                                                                source_ref3_          => NVL(source_ref3_,'*'),
                                                                                source_ref4_          => NVL(source_ref4_,'*'),  
                                                                                source_ref_type_db_   => shipment_line_rec_.source_ref_type,
                                                                                shipment_id_          => shipment_id_,
                                                                                shipment_line_no_     => shipment_line_no_,
                                                                                handling_unit_id_     => handling_unit_id_,
                                                                                quantity_to_be_added_ => inv_qty_to_be_added_,
                                                                                mix_block_excep_handling_ => TRUE);
            END;
         END IF;
         qty_left_to_connect_                          := (qty_left_to_connect_ - quantity_to_be_added_);
         handling_unit_id_tab_(rows_).handling_unit_id := handling_unit_id_;
         handling_unit_rec_ := Handling_Unit_API.Get(handling_unit_id_);
         IF (handling_unit_rec_.generate_sscc_no = Fnd_Boolean_API.DB_TRUE AND handling_unit_rec_.sscc IS NULL ) THEN
            Handling_Unit_API.Create_Sscc(handling_unit_id_);
         END IF;
         rows_ := rows_ + 1;
         EXIT WHEN qty_left_to_connect_ = 0;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   ELSE
      Raise_No_Hu_Capacity_Error___;
   END IF;
END Connect_To_New_Handling_Units;


PROCEDURE Connect_To_New_Handling_Units (
   info_                     OUT VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,
   handling_unit_type_id_     IN VARCHAR2,
   quantity_to_connect_       IN NUMBER,
   parent_handling_unit_id_   IN NUMBER DEFAULT NULL)
IS
   handling_unit_id_tab_ Handling_Unit_API.Handling_Unit_Id_Tab;
   qty_to_connect_       NUMBER;
BEGIN
   IF (quantity_to_connect_ IS NULL) THEN
      qty_to_connect_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_id_,
                                                                                   source_ref1_,
                                                                                   source_ref2_,
                                                                                   source_ref3_,
                                                                                   source_ref4_,
                                                                                   Shipment_Line_API.Get_Source_Ref_Type_Db(shipment_id_, shipment_line_no_));
   ELSE
      qty_to_connect_ := quantity_to_connect_;
   END IF;
   Connect_To_New_Handling_Units(info_                      => info_,
                                 handling_unit_id_tab_      => handling_unit_id_tab_,
                                 shipment_id_               => shipment_id_,
                                 source_ref1_               => source_ref1_,
                                 source_ref2_               => source_ref2_,
                                 source_ref3_               => source_ref3_,
                                 source_ref4_               => source_ref4_,
                                 handling_unit_type_id_     => handling_unit_type_id_,
                                 quantity_to_connect_       => qty_to_connect_,
                                 packing_instruction_id_    => NULL,
                                 shipment_line_no_          => shipment_line_no_,
                                 parent_handling_unit_id_   => parent_handling_unit_id_);                                     
END Connect_To_New_Handling_Units;


PROCEDURE Modify_Qty_Picked (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2, 
   source_ref_type_db_ IN VARCHAR2,
   qty_picked_         IN NUMBER )
IS
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
   newrec_             SHIPMENT_LINE_TAB%ROWTYPE;
BEGIN
   shipment_line_no_  := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   newrec_            := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_.qty_picked := qty_picked_;
   Modify___(newrec_);
END Modify_Qty_Picked;


PROCEDURE Update_On_Reserve (
   shipment_id_             IN NUMBER,
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2, 
   source_ref_type_db_      IN VARCHAR2, 
   qty_assigned_            IN NUMBER,
   qty_picked_              IN NUMBER,
   qty_modification_source_ IN VARCHAR2,
   qty_shipped_             IN NUMBER,
   undo_delivery_           IN VARCHAR2 DEFAULT NULL )
IS
   attr_                   VARCHAR2(8000);
   new_qty_assigned_       NUMBER:=0;
   new_inventory_qty_      NUMBER:=0;
   new_qty_picked_         NUMBER:=0;
   new_shipment_qty_       NUMBER:=0;
   objversion_             SHIPMENT_LINE.objversion%TYPE;
   objid_                  SHIPMENT_LINE.objid%TYPE;
   rec_                    SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_removed_  BOOLEAN:=FALSE;
   update_revised_qty_due_ BOOLEAN:=FALSE;
   shipment_line_no_       SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_ := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   IF (NVL(qty_assigned_, 0) != 0) OR (NVL(qty_picked_, 0) != 0) THEN
      rec_              := Lock_By_Keys___(shipment_id_, shipment_line_no_);        
      new_qty_assigned_ := rec_.qty_assigned + qty_assigned_; 
      new_qty_picked_   := rec_.qty_picked + NVL(qty_picked_, 0); 
     
      Client_SYS.Clear_Attr(attr_);
      IF (qty_modification_source_ IS NULL ) THEN
         IF ((new_qty_picked_ > rec_.inventory_qty) AND ((source_ref4_ = 0 AND source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) OR (source_ref_type_db_ != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))) THEN
            -- Overpicked scenario, increase the inventory_qty accordingly
            new_inventory_qty_      := new_qty_picked_;
            update_revised_qty_due_ := TRUE;  
         END IF;   
      ELSIF ((qty_modification_source_ IN ('CONNECTED_QUANTITY', 'HANDLING_UNIT')) AND (shipment_id_ != 0) AND (new_qty_assigned_ < rec_.qty_assigned)) THEN
         new_inventory_qty_ := rec_.inventory_qty + qty_assigned_;
         IF (new_inventory_qty_ = 0) THEN 
            -- total qty reassigned, remove the source record
            Check_Delete___(rec_, qty_modification_source_);
            Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, shipment_line_no_);
            Delete___(objid_, rec_, qty_modification_source_);
            shipment_line_removed_  := TRUE;
         ELSE
            update_revised_qty_due_ := TRUE;
         END IF;
      END IF;
      IF (NOT shipment_line_removed_)  THEN
         IF update_revised_qty_due_ THEN
            new_shipment_qty_ := Shipment_Handling_Utility_API.Get_Converted_Source_Qty(shipment_id_, 
                                                                                        shipment_line_no_,
                                                                                        new_inventory_qty_,
                                                                                        rec_.conv_factor,
                                                                                        rec_.inverted_conv_factor);
            
            Client_SYS.Add_To_Attr('INVENTORY_QTY',        new_inventory_qty_,       attr_);
            Client_SYS.Add_To_Attr('CONNECTED_SOURCE_QTY', new_shipment_qty_,        attr_);
         END IF;   
         Client_SYS.Add_To_Attr('QTY_ASSIGNED',            new_qty_assigned_,        attr_);
         Client_SYS.Add_To_Attr('QTY_PICKED',              new_qty_picked_,          attr_);
         Client_SYS.Add_To_Attr('QTY_MODIFICATION_SOURCE', qty_modification_source_, attr_);
         IF qty_shipped_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
         END IF;
         IF (undo_delivery_ IS NOT NULL) THEN
             Client_SYS.Add_To_Attr('UNDO_DELIVERY', undo_delivery_, attr_);
         END IF;   
         Modify_Line___(attr_, shipment_id_, shipment_line_no_);
      END IF;
   END IF;    
   
END Update_On_Reserve;


PROCEDURE Modify_On_Delivery (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS
   oldrec_                   SHIPMENT_LINE_TAB%ROWTYPE; 
   newrec_                   SHIPMENT_LINE_TAB%ROWTYPE; 
   shipment_line_pkg_rec_    SHIPMENT_LINE_TAB%ROWTYPE;
   dummy_                    NUMBER;
   all_components_delivered_ BOOLEAN:=FALSE;
   pkg_open_shipment_qty_    NUMBER;
   comp_open_shipment_qty_   NUMBER;
   shipment_line_no_         SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
   shipment_line_no_pkg_     SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;

   CURSOR chk_more_components_to_deliver IS
      SELECT 1
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_) 
         AND source_ref_type_db_            = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND Utility_SYS.String_To_Number(source_ref4) > 0
         AND qty_shipped = 0
         AND (qty_picked > 0 OR qty_to_ship > 0);

   CURSOR get_componets_not_delivered IS   
      SELECT *
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id  = shipment_id_
         AND NVL(source_ref1, string_null_)  = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_)  = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_)  = NVL(source_ref3_, string_null_)
         AND source_ref_type_db_             = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND Utility_SYS.String_To_Number(source_ref4) > 0
         AND qty_shipped  = 0
         AND (qty_picked  = 0 AND qty_to_ship = 0);
BEGIN
   shipment_line_no_ := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   oldrec_           := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_           := oldrec_;
   
   IF (oldrec_.qty_to_ship > 0) THEN
      newrec_.qty_shipped := oldrec_.qty_to_ship;
      newrec_.qty_to_ship := 0;
      Modify___(newrec_);
   ELSIF (oldrec_.qty_assigned > 0) THEN
      newrec_.qty_shipped  := oldrec_.qty_assigned;
      newrec_.qty_assigned := 0;
      newrec_.qty_picked   := 0;
      Modify___(newrec_);
      IF ((oldrec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND
          (Utility_SYS.String_To_Number(source_ref4_) > 0)) THEN
         newrec_.qty_picked   := 0;
         Modify___(newrec_);
      END IF;
   END IF; 

   IF ((oldrec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND
       (Utility_SYS.String_To_Number(source_ref4_) > 0)) THEN   
      OPEN  chk_more_components_to_deliver;
      FETCH chk_more_components_to_deliver INTO dummy_;
      IF (chk_more_components_to_deliver%NOTFOUND) THEN
         all_components_delivered_ := TRUE;
      END IF;
      CLOSE chk_more_components_to_deliver;
      
      IF (all_components_delivered_) THEN
         shipment_line_no_pkg_  := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, -1, source_ref_type_db_);
         shipment_line_pkg_rec_ := Get_Object_By_Keys___(shipment_id_, shipment_line_no_pkg_);
         
         pkg_open_shipment_qty_ := -(GREATEST(shipment_line_pkg_rec_.inventory_qty, shipment_line_pkg_rec_.qty_assigned));
         Shipment_Source_Utility_API.Modify_Source_Open_Ship_Qty(source_ref1_, source_ref2_, source_ref3_,
                                                                 -1, source_ref_type_db_, pkg_open_shipment_qty_);      
         FOR component_rec_ IN get_componets_not_delivered LOOP 
            comp_open_shipment_qty_ := -(GREATEST(component_rec_.inventory_qty, component_rec_.qty_assigned));
            Shipment_Source_Utility_API.Modify_Source_Open_Ship_Qty(component_rec_.source_ref1, component_rec_.source_ref2,
                                                                    component_rec_.source_ref3, component_rec_.source_ref4, source_ref_type_db_, comp_open_shipment_qty_);
         END LOOP;
      END IF;
   END IF;
   
END Modify_On_Delivery;


-- Connect_To_Shipment
--   Connects the source order line to a shipment.
PROCEDURE Connect_To_Shipment (
   shipment_id_           IN NUMBER,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   added_to_new_shipment_ IN VARCHAR2 DEFAULT 'FALSE')
IS   
   dummy_                 NUMBER;
   connected_lines_exist_ VARCHAR2(5) := 'FALSE';
   shipment_rec_          Shipment_API.Public_Rec;
   source_line_rec_       Shipment_Source_Utility_API.Public_Line_Rec;
   new_line_tab_          Shipment_Line_API.New_Line_Tab;
   last_comp_non_inv_     VARCHAR2(5):='FALSE';
   shipment_line_no_      NUMBER;
   err_text_1_            VARCHAR2(2000);
   err_text_2_            VARCHAR2(2000);
   
   CURSOR shipment_lines_exist IS 
      SELECT 1
        FROM SHIPMENT_LINE_TAB
       WHERE source_ref1 = source_ref1_
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   shipment_rec_    := Shipment_API.Get(shipment_id_);
   IF (shipment_rec_.rowstate != 'Preliminary') THEN
      Error_SYS.Record_General(lu_name_,'SHIPMENTNOTCONNECT: Lines can be connected only to preliminary shipments.');
   END IF;
   
   source_line_rec_ := Shipment_Source_Utility_API.Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
                                                               
   IF (source_line_rec_.ship_via_code != shipment_rec_.ship_via_code) THEN
      err_text_1_ := Language_SYS.Translate_Constant (lu_name_,
                                                      'CONNECT1: Source line :P1, :P2, :P3,',
                                                      NULL,
                                                      source_ref1_, source_ref2_, source_ref3_ );
                                                      
      err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                      'SHIPVIACONNECT2: :P1 has different ship via code than that of the shipment.',
                                                      NULL,
                                                      source_ref4_);
      Raise_General_Error___(err_text_1_, err_text_2_);      
      
  END IF;

   IF (source_line_rec_.delivery_terms != shipment_rec_.delivery_terms) THEN
      err_text_1_ := Language_SYS.Translate_Constant (lu_name_,
                                                      'CONNECT1: Source line :P1, :P2, :P3,',
                                                      NULL,
                                                      source_ref1_, source_ref2_, source_ref3_ );
                                                      
      err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                      'DELTERMCONNECT2: :P1 has different delivery terms than that of the shipment.',
                                                      NULL,
                                                      source_ref4_);
      Raise_General_Error___(err_text_1_, err_text_2_);      
   END IF;  

   IF (source_line_rec_.shipment_type != shipment_rec_.shipment_type) THEN
      err_text_1_ := Language_SYS.Translate_Constant (lu_name_,
                                                      'CONNECT1: Source line :P1, :P2, :P3,',
                                                      NULL,
                                                      source_ref1_, source_ref2_, source_ref3_ );
                                                      
      err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                      'SHIPMENTTYPECONNECT2: :P1 has different shipment type than that of the shipment.',
                                                      NULL,
                                                      source_ref4_);
      Raise_General_Error___(err_text_1_, err_text_2_); 
     
   END IF;
   
   -- check whether shipment lines exist for the given source line
   OPEN shipment_lines_exist;
   FETCH shipment_lines_exist INTO dummy_;
   IF (shipment_lines_exist%FOUND) THEN
      connected_lines_exist_ := 'TRUE';
   END IF;   
   CLOSE shipment_lines_exist;
   
   Pick_Shipment_API.Check_Res_Picked_To_Ship_Loc(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   
   -- validate and fetch the source line information needed to create new shipment line.
   Shipment_Source_Utility_API.Fetch_And_Validate_Ship_Line(new_line_tab_, shipment_id_, source_ref1_, source_ref2_,
                                                            source_ref3_, source_ref4_, source_ref_type_db_);
   
   IF (new_line_tab_.COUNT > 0) THEN
      FOR i IN new_line_tab_.FIRST..new_line_tab_.LAST LOOP
         New_Line___(shipment_line_no_,
                     shipment_id_,
                     new_line_tab_(i).source_ref1,
                     new_line_tab_(i).source_ref2,
                     new_line_tab_(i).source_ref3,
                     new_line_tab_(i).source_ref4,
                     new_line_tab_(i).source_ref_type,
                     new_line_tab_(i).source_part_no,
                     new_line_tab_(i).source_part_desc,
                     new_line_tab_(i).inventory_part_no,
                     new_line_tab_(i).source_unit_meas,
                     new_line_tab_(i).conv_factor,
                     new_line_tab_(i).inverted_conv_factor,                           
                     new_line_tab_(i).inventory_qty,
                     new_line_tab_(i).connected_source_qty,
                     new_line_tab_(i).qty_assigned,
                     new_line_tab_(i).qty_shipped,
                     new_line_tab_(i).qty_to_ship,
                     new_line_tab_(i).packing_instruction_id,
                     new_line_tab_(i).customs_value,
                     qty_modification_source_ => 'ADD_ORDER_LINE',
                     on_reassignment_         =>  FALSE );  
         IF ((source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND Utility_SYS.String_To_Number(new_line_tab_(i).source_ref4) > 0) 
              AND (new_line_tab_(i).inventory_part_no IS NULL)) THEN
            last_comp_non_inv_ := 'TRUE';             
         ELSE
            last_comp_non_inv_ := 'FALSE';            
         END IF;                           
      END LOOP;
   END IF;
   
   Shipment_Source_Utility_API.Post_Connect_To_Shipment(shipment_id_, source_ref1_, source_ref2_, source_ref3_,
                                                        source_ref4_, source_ref_type_db_, connected_lines_exist_, 
                                                        last_comp_non_inv_, added_to_new_shipment_);
   
   Shipment_API.Check_Reset_Printed_Flags(shipment_id_                => shipment_id_, 
                                          unset_pkg_list_print_       => TRUE, 
                                          unset_consignment_print_    => TRUE, 
                                          unset_del_note_print_       => TRUE, 
                                          unset_pro_forma_print_      => FALSE,
                                          unset_bill_of_lading_print_ => TRUE,
                                          unset_address_label_print_  => FALSE );
   
END Connect_To_Shipment;


@UncheckedAccess
FUNCTION Check_Active_Shipment_Exist (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   active_shipment_exist_ VARCHAR2(5) := 'FALSE';
   temp_                  NUMBER;

   CURSOR get_active_shipment IS
      SELECT 1
      FROM   SHIPMENT_LINE_TAB sl, SHIPMENT_TAB s
      WHERE  (sl.source_ref1 = source_ref1_ ) 
      AND    ((sl.source_ref2 = source_ref2_ ) OR (source_ref2_ IS NULL))
      AND    ((sl.source_ref3 = source_ref3_ ) OR (source_ref3_ IS NULL))
      AND    ((sl.source_ref4 = source_ref4_ ) OR (source_ref4_ IS NULL))
      AND    sl.source_ref_type = source_ref_type_db_
      AND    sl.shipment_id     = s.shipment_id
      AND    s.rowstate         != 'Closed';
BEGIN
   OPEN  get_active_shipment;
   FETCH get_active_shipment INTO temp_;
   IF (get_active_shipment%FOUND) THEN
      active_shipment_exist_ := 'TRUE';
   END IF;
   CLOSE get_active_shipment;
   RETURN active_shipment_exist_;
END Check_Active_Shipment_Exist;


-- Remove_By_Source___
--   This method disconnects a shipment connected line and removes the record.
PROCEDURE Remove_By_Source___ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER )
IS
   objid_              VARCHAR2(100);
   objversion_         VARCHAR2(100);
   remrec_             SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_ := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, shipment_line_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_, NULL);
   Delete___(objid_, remrec_, NULL);
END Remove_By_Source___;


PROCEDURE Remove_Active_Shipments (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS
   CURSOR get_active_shipments IS
      SELECT sl.shipment_id
      FROM   SHIPMENT_LINE_TAB sl, SHIPMENT_TAB s 
      WHERE  NVL(sl.source_ref1, string_null_) = NVL(source_ref1_, string_null_)
      AND    NVL(sl.source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(sl.source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(sl.source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    sl.source_ref_type = source_ref_type_db_
      AND    sl.shipment_id     = s.shipment_id
      AND    NOT(sl.qty_picked > 0 OR sl.qty_shipped > 0 ) 
      AND    s.rowstate != 'Closed';
BEGIN
   FOR get_active_shipment_rec IN get_active_shipments LOOP
      Remove_By_Source___(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, get_active_shipment_rec.shipment_id);
   END LOOP;
END Remove_Active_Shipments;


PROCEDURE Reserve_Non_Inventory (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   total_qty_to_ship_  IN NUMBER )
IS
   split_qty_to_ship_ NUMBER := 0;
   qty_to_ship_       NUMBER := 0;

    CURSOR get_shipment_info IS
      SELECT shipment_id, qty_to_ship, (inventory_qty - qty_to_ship) new_qty_to_ship
        FROM SHIPMENT_LINE_TAB
       WHERE ((inventory_qty - qty_to_ship - qty_shipped) > 0)
         AND qty_shipped = 0
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_     
      ORDER BY shipment_id; 
BEGIN
   split_qty_to_ship_ := total_qty_to_ship_;
   FOR rec_ IN get_shipment_info LOOP
      IF (split_qty_to_ship_ <= rec_.new_qty_to_ship) THEN
         qty_to_ship_ :=  split_qty_to_ship_;
      ELSE
         qty_to_ship_ :=  rec_.new_qty_to_ship;
      END IF;
      split_qty_to_ship_ := split_qty_to_ship_ - qty_to_ship_;
      Modify_Qty_To_Ship(rec_.shipment_id, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, (rec_.qty_to_ship + qty_to_ship_));
      EXIT WHEN (split_qty_to_ship_ = 0);
   END LOOP;

END Reserve_Non_Inventory; 


PROCEDURE Unreserve_Non_Inventory (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   qty_unreceived_     IN NUMBER,
   date_modified_  IN BOOLEAN DEFAULT FALSE)
IS
   split_qty_unreceived_ NUMBER := 0;  
   qty_to_unreceive_     NUMBER := 0;

   CURSOR get_shipment IS
      SELECT shipment_id, qty_to_ship
      FROM   SHIPMENT_LINE_TAB
      WHERE  NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_
      AND    qty_to_ship > 0
      ORDER BY shipment_id DESC; 
BEGIN
   split_qty_unreceived_ := qty_unreceived_;
   FOR rec_ IN get_shipment LOOP
      IF (date_modified_) THEN
         Modify_Qty_To_Ship(rec_.shipment_id, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, 0); 
      ELSE
         IF (split_qty_unreceived_ <= rec_.qty_to_ship) THEN
            qty_to_unreceive_ :=  split_qty_unreceived_;
         ELSE
            qty_to_unreceive_ :=  rec_.qty_to_ship;
         END IF;
         split_qty_unreceived_ := split_qty_unreceived_ - qty_to_unreceive_;
         Modify_Qty_To_Ship(rec_.shipment_id, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, (rec_.qty_to_ship - qty_to_unreceive_));
         EXIT WHEN (split_qty_unreceived_ = 0);
      END IF;
   END LOOP;
END Unreserve_Non_Inventory; 


PROCEDURE Modify_Connected_Source_Qty___ (
   shipment_id_         IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   sales_qty_           IN NUMBER )
IS
   newrec_             SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_            := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   newrec_                      := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_.connected_source_qty := sales_qty_;
   Modify___(newrec_);
END Modify_Connected_Source_Qty___;


PROCEDURE Get_Preliminary_Ship_Info (
   ship_count_         OUT NUMBER,
   shipment_id_        OUT NUMBER,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2)
IS
   CURSOR get_ship_info IS
      SELECT COUNT(shipment_id), MAX(shipment_id)
      FROM   SHIPMENT_LINE_TAB 
      WHERE  source_ref1 = source_ref1_
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_
      AND    shipment_id IN (SELECT shipment_id
                               FROM SHIPMENT_TAB
                              WHERE rowstate = 'Preliminary'
                                AND auto_connection_blocked = 'FALSE');

BEGIN
   OPEN  get_ship_info;
   FETCH get_ship_info INTO ship_count_, shipment_id_;
   CLOSE get_ship_info;
END Get_Preliminary_Ship_Info;


-- This method updates shipment order line accordingly when the customer order line is updated 
--only when the order line is connected to one shipment line.
PROCEDURE Update_From_Source_Line (
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   buy_qty_due_           IN NUMBER,
   qty_shipped_           IN NUMBER,
   open_shipment_qty_     IN NUMBER,
   inverted_conv_factor_  IN NUMBER,
   conv_factor_           IN NUMBER,
   connected_shipment_id_ IN NUMBER,
   source_unit_meas_      IN VARCHAR2,
   inventory_qty_         IN NUMBER DEFAULT NULL)
IS
   hu_info_text_            VARCHAR2(2000);
   new_shipment_source_qty_ NUMBER;
   no_of_handling_units_    NUMBER;
   ship_hu_connected_qty_   NUMBER;
   local_open_shipment_qty_ NUMBER;
   shipment_line_rec_       Public_Rec;
   new_shipment_invent_qty_ NUMBER;
BEGIN
    hu_info_text_            := NULL; 
    shipment_line_rec_       := Get_By_Source(connected_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
    local_open_shipment_qty_ := NVL(open_shipment_qty_, Get_Sum_Open_Shipment_qty(source_ref1_, source_ref2_,source_ref3_, source_ref4_, source_ref_type_db_)); 
    new_shipment_source_qty_ := shipment_line_rec_.Connected_Source_Qty + buy_qty_due_ - ((qty_shipped_ + local_open_shipment_qty_) * (inverted_conv_factor_/conv_factor_));
    
    IF (new_shipment_source_qty_ = 0) THEN
       Remove_By_Source___(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, connected_shipment_id_);
       Client_SYS.Add_Info(lu_name_, 'SHIPLINEREMOVE: The source line is removed from shipment :P1.', connected_shipment_id_);
    ELSE
       no_of_handling_units_ := Shipment_Line_Handl_Unit_API.Get_No_Of_Handling_Units(connected_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
       IF (no_of_handling_units_ > 1) THEN
          ship_hu_connected_qty_ := Shipment_Line_Handl_Unit_API.Get_Shipment_Line_Quantity(connected_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_); 
          IF (new_shipment_source_qty_ < ship_hu_connected_qty_) THEN
             hu_info_text_ := Language_SYS.Translate_Constant(lu_name_, 'SHIPLINEHUINFO: The connected source qty (:P1) for this shipment line is less than what is currently attached to different handling units (:P2). The attached shipment handling unit lines will be removed and will need to be reattached.',
                                                                NULL, (new_shipment_source_qty_|| ' '|| source_unit_meas_), (ship_hu_connected_qty_||' '||source_unit_meas_));
          END IF;
       END IF;
       IF (inventory_qty_ IS NULL) THEN
          Modify_Connected_Source_Qty___(connected_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, new_shipment_source_qty_);
       ELSE
          new_shipment_invent_qty_ := shipment_line_rec_.Inventory_Qty + inventory_qty_ - (qty_shipped_ + local_open_shipment_qty_);
          Modify_Connected_Qty_By_Source(connected_shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, new_shipment_source_qty_, new_shipment_invent_qty_);
       END IF;
       
       Client_SYS.Add_Info(lu_name_, 'SHIPLINEUPDATE: Connected source quantity on shipment :P1 is updated accordingly. :P2', connected_shipment_id_, hu_info_text_);
    END IF;
    
END Update_From_Source_Line;

   
@UncheckedAccess
FUNCTION Get_Sum_Reserved_Line (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   sum_qty_assigned_   NUMBER:=0;
   
   CURSOR get_sum_qty_assigned IS
      SELECT SUM(qty_assigned)
      FROM   SHIPMENT_LINE_TAB
      WHERE  source_ref1 = source_ref1_
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_; 

   CURSOR get_sum_qty_assigned_co IS
      SELECT SUM(qty_assigned)
      FROM   SHIPMENT_LINE_TAB
      WHERE  source_ref1 = source_ref1_
      AND    source_ref2 = source_ref2_
      AND    source_ref3 = source_ref3_
      AND    source_ref4 = source_ref4_
      AND    source_ref_type = source_ref_type_db_; 
BEGIN
   IF ((source_ref1_ IS NOT NULL) AND (source_ref2_ IS NOT NULL) AND (source_ref3_ IS NOT NULL) AND (source_ref4_ IS NOT NULL)) THEN
      OPEN  get_sum_qty_assigned_co;
      FETCH get_sum_qty_assigned_co INTO sum_qty_assigned_;
      CLOSE get_sum_qty_assigned_co;
   ELSE 
      OPEN  get_sum_qty_assigned;
      FETCH get_sum_qty_assigned INTO sum_qty_assigned_;
      CLOSE get_sum_qty_assigned;
   END IF;
   RETURN NVL(sum_qty_assigned_, 0);
END Get_Sum_Reserved_Line;


@UncheckedAccess
FUNCTION Get_Sum_Qty_Shipped (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   sum_qty_shipped_   NUMBER := 0;
   
   CURSOR get_sum_qty_shipped IS
      SELECT SUM(qty_shipped)
      FROM   shipment_line_tab
      WHERE  source_ref1 = source_ref1_
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_; 
BEGIN
   OPEN  get_sum_qty_shipped;
   FETCH get_sum_qty_shipped INTO sum_qty_shipped_;
   CLOSE get_sum_qty_shipped;
  
   RETURN NVL(sum_qty_shipped_, 0);
END Get_Sum_Qty_Shipped;

@UncheckedAccess
FUNCTION Get_Sum_Open_Shipment_qty (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   sum_qty_shipped_   NUMBER := 0;
   
   CURSOR get_sum_qty_shipped IS
      SELECT SUM(connected_source_qty) - SUM(qty_shipped)
      FROM   shipment_line_tab
      WHERE  source_ref1 = source_ref1_
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_; 
BEGIN
   OPEN  get_sum_qty_shipped;
   FETCH get_sum_qty_shipped INTO sum_qty_shipped_;
   CLOSE get_sum_qty_shipped;
  
   RETURN NVL(sum_qty_shipped_, 0);
END Get_Sum_Open_Shipment_qty;

-- Source_Exist
--   This method teruns TRUE if the given source info exists in the given shipment id otherwise returns FALSE.
@UncheckedAccess
FUNCTION Source_Exist (
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_   NUMBER;

   CURSOR check_source_exist IS
      SELECT 1
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id     = shipment_id_
         AND source_ref_type = source_ref_type_db_
         AND NVL(source_ref1, string_null_)  = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_)  = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_)  = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_)  = NVL(source_ref4_, string_null_);
BEGIN
   OPEN  check_source_exist;
   FETCH check_source_exist INTO dummy_;
   CLOSE check_source_exist;

   RETURN (NVL(dummy_, 0) = 1);
END Source_Exist;


@UncheckedAccess
FUNCTION Source_Ref1_Exist (
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2,
   source_ref1_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_               NUMBER;
   source_ref1_exist_   VARCHAR2(5):='FALSE';
   
   CURSOR check_source_ref1_exist IS
      SELECT 1
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id     = shipment_id_
         AND source_ref_type = source_ref_type_db_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_);
BEGIN
   OPEN  check_source_ref1_exist;
   FETCH check_source_ref1_exist INTO dummy_;
   IF (check_source_ref1_exist%FOUND) THEN
      source_ref1_exist_ := 'TRUE';
   END IF;
   CLOSE check_source_ref1_exist;
   RETURN source_ref1_exist_;
END Source_Ref1_Exist;


PROCEDURE Modify_Qty_To_Ship (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   qty_to_ship_        IN NUMBER )
IS
   newrec_             SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_ := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   newrec_             := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_.qty_to_ship := qty_to_ship_;
   Modify___(newrec_);
END Modify_Qty_To_Ship;  


-- Modify_On_Undo_Delivery
--    This will modify the qty_shipped, and qty_to_ship of line with non inventory part.   
PROCEDURE Modify_On_Undo_Delivery (
   shipment_id_          IN NUMBER,
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref3_          IN VARCHAR2,
   source_ref4_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
   qty_shipped_          IN NUMBER,
   qty_to_ship_          IN NUMBER)
IS
   newrec_             SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_   := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, 
                                                       source_ref4_, source_ref_type_db_);
   newrec_             := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_.qty_shipped := qty_shipped_;
   newrec_.qty_to_ship := qty_to_ship_;
   Modify___(newrec_);
END Modify_On_Undo_Delivery;  

   
PROCEDURE Release_Not_Reserved_Qty_Line (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS   
   CURSOR get_shipment_lines IS
      SELECT shipment_id, (inventory_qty - qty_assigned - qty_to_ship) remaining_qty_to_reserve
        FROM shipment_line_tab
       WHERE NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_) 
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_
         AND qty_shipped     = 0
         AND ((inventory_qty - qty_assigned - qty_to_ship) > 0); 

BEGIN
   IF (((source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4_) = 0))
         OR (source_ref_type_db_ != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)) THEN
      FOR shipment_line_rec_ IN get_shipment_lines LOOP
         Release_Not_Reserved_Qty(shipment_line_rec_.shipment_id, source_ref1_, source_ref2_, 
                                  source_ref3_, source_ref4_, source_ref_type_db_, shipment_line_rec_.remaining_qty_to_reserve, 'RELEASE_NOT_RESERVED');           
      END LOOP; 
   ELSE
      IF ((source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4_) = -1)) THEN 
         $IF Component_Order_SYS.INSTALLED $THEN
            Shipment_Order_Utility_API.Release_Not_Reserved_Pkg_Line(source_ref1_, source_ref2_, source_ref3_);
         $ELSE
            NULL; 
         $END                                                                               
      END IF;    
   END IF;
END Release_Not_Reserved_Qty_Line;


-- Shipment_Connected_Lines_Exist
--   This method checks whether there exist any connected shipments
--   for a given Source or a Source Line.
@UncheckedAccess
FUNCTION Shipment_Connected_Lines_Exist (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   source_ref2_         IN VARCHAR2 DEFAULT NULL,
   source_ref3_         IN VARCHAR2 DEFAULT NULL,
   source_ref4_         IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   exist_ NUMBER;

   CURSOR shipment_lines IS
      SELECT 1
        FROM shipment_line_tab 
       WHERE source_ref1       = source_ref1_
         AND source_ref_type   = source_ref_type_db_
         AND (source_ref2_ IS NULL OR source_ref2 = source_ref2_)
         AND (source_ref3_ IS NULL  OR source_ref3 = source_ref3_)
         AND (source_ref4_ IS NULL OR source_ref4 = source_ref4_);
BEGIN
   OPEN shipment_lines;
   FETCH shipment_lines INTO exist_;
   IF (shipment_lines%NOTFOUND) THEN
      exist_ := 0;
   END IF;
   CLOSE shipment_lines;
   RETURN exist_;
END Shipment_Connected_Lines_Exist;


FUNCTION Get_Source_Line_Qty_To_Ship (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   sum_qty_to_ship_   NUMBER:=0;
   
   CURSOR get_sum_qty_to_ship IS
      SELECT SUM(qty_to_ship)
      FROM   SHIPMENT_LINE_TAB
      WHERE  NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_; 
BEGIN
   OPEN  get_sum_qty_to_ship;
   FETCH get_sum_qty_to_ship INTO sum_qty_to_ship_;
   CLOSE get_sum_qty_to_ship;

   RETURN NVL(sum_qty_to_ship_, 0);
END Get_Source_Line_Qty_To_Ship;


@UncheckedAccess
FUNCTION Get_Qty_To_Reserve (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_to_reserve_  NUMBER:=0;
   
   CURSOR get_qty_to_reserve IS
      SELECT NVL((sol.inventory_qty - sol.qty_assigned - sol.qty_to_ship - sol.qty_shipped), 0) qty_to_reserve  
      FROM   SHIPMENT_LINE_TAB sol, SHIPMENT_TAB s
      WHERE  sol.shipment_id  = shipment_id_
      AND    NVL(sol.source_ref1, string_null_)  = NVL(source_ref1_, string_null_)
      AND    NVL(sol.source_ref2, string_null_)  = NVL(source_ref2_, string_null_)
      AND    NVL(sol.source_ref3, string_null_)  = NVL(source_ref3_, string_null_)
      AND    NVL(sol.source_ref4, string_null_)  = NVL(source_ref4_, string_null_) 
      AND    sol.source_ref_type = source_ref_type_db_
      AND    s.shipment_id       = sol.shipment_id
      AND    s.rowstate          = 'Preliminary';  
BEGIN
   OPEN   get_qty_to_reserve;
   FETCH  get_qty_to_reserve INTO qty_to_reserve_; 
   CLOSE  get_qty_to_reserve;
   IF (qty_to_reserve_ > 0) THEN
      IF (Shipment_Source_Utility_API.Check_Qty_To_Reserve(shipment_id_, source_ref1_, source_ref2_, 
                                                           source_ref3_, source_ref4_, source_ref_type_db_) = 'FALSE') THEN 
         qty_to_reserve_ := 0;
      END IF;   
   END IF;   
   RETURN qty_to_reserve_;
END Get_Qty_To_Reserve;  


@UncheckedAccess
FUNCTION Fetch_Ship_Line_No_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   shipment_line_no_   NUMBER;
   
   CURSOR get_shipment_line_no IS
      SELECT shipment_line_no
      FROM   SHIPMENT_LINE_TAB
      WHERE  shipment_id = shipment_id_
      AND    NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_; 
BEGIN
   OPEN  get_shipment_line_no;
   FETCH get_shipment_line_no INTO shipment_line_no_;
   CLOSE get_shipment_line_no;

   RETURN shipment_line_no_;
END Fetch_Ship_Line_No_By_Source;

@UncheckedAccess
FUNCTION Fetch_Shipment_Id_By_Source (   
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   shipment_id_   NUMBER;
   
   CURSOR get_shipment_id IS
      SELECT shipment_id
      FROM   SHIPMENT_LINE_TAB
      WHERE  source_ref1 = source_ref1_
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_; 
BEGIN
   OPEN  get_shipment_id;
   FETCH get_shipment_id INTO shipment_id_;
   CLOSE get_shipment_id;

   RETURN shipment_id_;
END Fetch_Shipment_Id_By_Source;

@UncheckedAccess
FUNCTION Get_Source_Part_No_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_part_no_   shipment_line_tab.source_part_no%TYPE;
 
   CURSOR get_source_part_no_ref IS
      SELECT source_part_no
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN   get_source_part_no_ref;
   FETCH  get_source_part_no_ref INTO source_part_no_;
   CLOSE  get_source_part_no_ref;
   RETURN source_part_no_;
END Get_Source_Part_No_By_Source;

@UncheckedAccess
FUNCTION Get_Source_Part_Desc_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_part_desc_   shipment_line_tab.source_part_description%TYPE;
 
   CURSOR get_source_part_desc IS
      SELECT source_part_description
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN   get_source_part_desc;
   FETCH  get_source_part_desc INTO source_part_desc_;
   CLOSE  get_source_part_desc;
   RETURN source_part_desc_;
END Get_Source_Part_Desc_By_Source;


@UncheckedAccess
FUNCTION Get_Qty_Assigned_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_assigned_ shipment_line_tab.qty_assigned%TYPE;
 
   CURSOR get_qty_assigned IS
      SELECT qty_assigned
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN get_qty_assigned;
   FETCH get_qty_assigned INTO qty_assigned_;
   CLOSE get_qty_assigned;
   RETURN qty_assigned_;
END Get_Qty_Assigned_By_Source;


@UncheckedAccess
FUNCTION Get_Inventory_Qty_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   inventory_qty_ shipment_line_tab.inventory_qty%TYPE;
 
   CURSOR get_inventory_qty IS
      SELECT inventory_qty
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN get_inventory_qty;
   FETCH get_inventory_qty INTO inventory_qty_;
   CLOSE get_inventory_qty;
   RETURN inventory_qty_;
END Get_Inventory_Qty_By_Source;


@UncheckedAccess
FUNCTION Get_Qty_Picked_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_picked_ shipment_line_tab.qty_picked%TYPE;
 
   CURSOR get_qty_picked IS
      SELECT qty_picked
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN get_qty_picked;
   FETCH get_qty_picked INTO qty_picked_;
   CLOSE get_qty_picked;
   RETURN qty_picked_;
END Get_Qty_Picked_By_Source;


@UncheckedAccess
FUNCTION Get_Qty_To_Ship_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_to_ship_ shipment_line_tab.qty_to_ship%TYPE;
 
   CURSOR get_qty_to_ship IS
      SELECT qty_to_ship
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN get_qty_to_ship;
   FETCH get_qty_to_ship INTO qty_to_ship_;
   CLOSE get_qty_to_ship;
   RETURN qty_to_ship_;
END Get_Qty_To_Ship_By_Source;


@UncheckedAccess
FUNCTION Get_Qty_Shipped_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_shipped_ shipment_line_tab.qty_shipped%TYPE;
 
   CURSOR get_qty_shipped IS
      SELECT qty_shipped
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN get_qty_shipped;
   FETCH get_qty_shipped INTO qty_shipped_;
   CLOSE get_qty_shipped;
   RETURN qty_shipped_;
END Get_Qty_Shipped_By_Source;


@UncheckedAccess
FUNCTION Get_Conn_Source_Qty_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   connected_source_qty_ shipment_line_tab.connected_source_qty%TYPE;
 
   CURSOR get_connected_source_qty IS
      SELECT connected_source_qty
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   OPEN get_connected_source_qty;
   FETCH get_connected_source_qty INTO connected_source_qty_;
   CLOSE get_connected_source_qty;
   RETURN connected_source_qty_;
END Get_Conn_Source_Qty_By_Source;


@UncheckedAccess
FUNCTION Get_By_Source (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_               Public_Rec;
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_ := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_,
                                                     source_ref3_, source_ref4_, source_ref_type_db_);
   temp_ := Get(shipment_id_, shipment_line_no_);                                               
   RETURN temp_;                                               
END Get_By_Source;


PROCEDURE Modify_Connected_Qty_By_Source (
   shipment_id_          IN NUMBER,
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref3_          IN VARCHAR2,
   source_ref4_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
   connected_source_qty_ IN NUMBER,
   inventory_qty_        IN NUMBER )
IS
   newrec_             SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_            := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_,
                                                                source_ref4_, source_ref_type_db_);
   newrec_                      := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_.connected_source_qty := connected_source_qty_;
   newrec_.inventory_qty        := inventory_qty_;
   Modify___(newrec_);
END Modify_Connected_Qty_By_Source;  


PROCEDURE Modify_Qty_Assigned_By_Source (
   shipment_id_          IN NUMBER,
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref3_          IN VARCHAR2,
   source_ref4_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
   qty_assigned_         IN NUMBER )
IS
   newrec_             SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_no_   SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   shipment_line_no_    := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   newrec_              := Lock_By_Keys___(shipment_id_, shipment_line_no_);
   newrec_.qty_assigned := qty_assigned_;
   Modify___(newrec_);
END Modify_Qty_Assigned_By_Source;  


PROCEDURE Remove_Shipment_Lines (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS
   CURSOR get_shipments IS
      SELECT shipment_id
        FROM SHIPMENT_LINE_TAB 
       WHERE NVL(source_ref1, string_null_) = NVL(source_ref1_, string_null_)
         AND NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
         AND NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
         AND NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
         AND source_ref_type = source_ref_type_db_;
BEGIN
   FOR rec_ IN get_shipments LOOP
      Remove_By_Source___(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, rec_.shipment_id);
      Client_SYS.Add_Info(lu_name_, 'SHIPLINEREMOVE: The source line is removed from shipment :P1.', rec_.shipment_id);
   END LOOP;  
END Remove_Shipment_Lines;

PROCEDURE Release_Not_Reserved_Qty (
   shipment_id_               IN NUMBER,
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   remaining_qty_to_reserve_  IN NUMBER,
   qty_modification_source_   IN VARCHAR2 )
IS
   shipment_line_rec_   SHIPMENT_LINE_TAB%ROWTYPE;
   shipment_line_no_    SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
BEGIN
   IF (remaining_qty_to_reserve_ > 0) THEN
      shipment_line_no_  := Fetch_Ship_Line_No_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      shipment_line_rec_ := Lock_By_Keys___(shipment_id_, shipment_line_no_);
      Update_Source_On_Reassign___ (shipment_line_rec_          => shipment_line_rec_,
                                    revised_qty_due_reassigned_ => remaining_qty_to_reserve_,
                                    qty_to_ship_reassigned_     => 0,
                                    qty_modification_source_    => qty_modification_source_ );
   END IF;   
END Release_Not_Reserved_Qty;


-- This function will convert "*" to NULL. 
-- Used from ShipmentReservHandlUnit. 
@UncheckedAccess
FUNCTION Get_Converted_Source_Ref (
   source_ref_          IN VARCHAR2,
   shipment_id_         IN NUMBER,
   shipment_line_no_    IN NUMBER,
   source_ref_position_ IN NUMBER DEFAULT 2) RETURN VARCHAR2
IS      
  source_ref_type_db_   shipment_line_tab.source_ref_type%TYPE;
BEGIN
  source_ref_type_db_ := Shipment_Line_API.Get_Source_Ref_Type_Db(shipment_id_, shipment_line_no_);
  RETURN Get_Converted_Source_Ref(source_ref_, source_ref_type_db_, source_ref_position_);
END Get_Converted_Source_Ref;


-- This function will convert "*" to NULL. 
-- Used from shipment reservation views.
-- Add code here when different source ref positions in combination with different source ref types requires different results
@UncheckedAccess
FUNCTION Get_Converted_Source_Ref (
   source_ref_          IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   source_ref_position_ IN NUMBER DEFAULT 2) RETURN VARCHAR2
IS   
  converted_source_ref_ shipment_line_tab.source_ref2%TYPE := source_ref_;   
BEGIN    
   IF(Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
      converted_source_ref_ := Inventory_Part_Reservation_API.Get_Converted_Source_Ref(source_ref_, source_ref_position_);
   ELSIF(source_ref_type_db_ NOT IN (Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)) THEN
      IF (source_ref_position_ > 1) THEN
         converted_source_ref_ := CASE source_ref_ WHEN '*' THEN NULL ELSE source_ref_ END;
      END IF;
   END IF;
   RETURN (converted_source_ref_);   
END Get_Converted_Source_Ref;

-- Get_Net_Weight
--   Returns the net weight for a given shipment line
@UncheckedAccess
FUNCTION Get_Net_Weight (
   shipment_id_          IN NUMBER,
   shipment_line_no_     IN NUMBER,
   apply_freight_factor_ IN VARCHAR2 ) RETURN NUMBER
IS
   net_weight_      NUMBER;
   adj_net_weight_  NUMBER;
   uom_for_weight_  Company_Invent_Info_Tab.uom_for_weight%TYPE;
   company_         Company_Tab.Company%TYPE;
   contract_        Shipment_Tab.contract%TYPE; 
BEGIN
   contract_               := Shipment_API.Get_Contract(shipment_id_);
   company_                := Site_API.Get_Company(contract_);
   uom_for_weight_         := Company_Invent_Info_API.Get_Uom_For_Weight(company_);
   Shipment_API.Get_Net_And_Adjusted_Weight__(net_weight_, adj_net_weight_, shipment_id_, uom_for_weight_, shipment_line_no_);
   
   IF (apply_freight_factor_ = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN adj_net_weight_;
   ELSE
      RETURN net_weight_;
   END IF;
END Get_Net_Weight;

-- Get_Net_Volume
--   Returns the net volume for a given shipment line
@UncheckedAccess
FUNCTION Get_Net_Volume (
   shipment_id_          IN NUMBER,
   shipment_line_no_     IN NUMBER,
   apply_freight_factor_ IN VARCHAR2 ) RETURN NUMBER
IS
   net_volume_      NUMBER;
   adj_net_volume_  NUMBER;
   uom_for_volume_  Company_Invent_Info_Tab.uom_for_volume%TYPE;
   contract_        Shipment_Tab.contract%TYPE; 
   company_         Company_Tab.Company%TYPE;
BEGIN
   contract_               := Shipment_API.Get_Contract(shipment_id_);
   company_                := Site_API.Get_Company(contract_);
   uom_for_volume_         := Company_Invent_Info_API.Get_Uom_For_Volume(company_);
   Get_Net_And_Adjusted_Volume___(net_volume_, adj_net_volume_, shipment_id_, shipment_line_no_, uom_for_volume_);
   
   IF (apply_freight_factor_ = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN adj_net_volume_;
   ELSE
      RETURN net_volume_;
   END IF;
END Get_Net_Volume;


@UncheckedAccess
FUNCTION Get_Sum_Connected_Source_Qty (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   sum_qty_connected_   NUMBER:=0;
   
   CURSOR get_sum_qty_connected IS
      SELECT SUM(connected_source_qty)
      FROM   shipment_line_tab
      WHERE  source_ref1 = source_ref1_
      AND    NVL(source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    source_ref_type = source_ref_type_db_; 
BEGIN
 
   OPEN  get_sum_qty_connected;
   FETCH get_sum_qty_connected INTO sum_qty_connected_;
   CLOSE get_sum_qty_connected;
   
   RETURN NVL(sum_qty_connected_, 0);
END Get_Sum_Connected_Source_Qty;

@UncheckedAccess
FUNCTION Get_Sum_Connected_Inv_Qty (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   sum_inventory_qty_   NUMBER:=0;
   
   CURSOR get_sum_inv_qty IS
      SELECT SUM(inventory_qty)
      FROM   shipment_line_tab
      WHERE  source_ref1 = source_ref1_
      AND    source_ref2_ IS NULL OR source_ref2 = source_ref2_
      AND    source_ref3_ IS NULL OR source_ref3 = source_ref3_
      AND    source_ref4_ IS NULL OR source_ref4 = source_ref4_
      AND    source_ref_type = source_ref_type_db_; 
BEGIN 
   OPEN  get_sum_inv_qty;
   FETCH get_sum_inv_qty INTO sum_inventory_qty_;
   CLOSE get_sum_inv_qty;
   
   RETURN NVL(sum_inventory_qty_, 0);
END Get_Sum_Connected_Inv_Qty;

