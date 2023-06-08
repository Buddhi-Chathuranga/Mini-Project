-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentFlow
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------ 
--  221103  AvWilk  SCDEV-17249, performance improvement,added Inventory_Event_Manager_API start and finish sessions into Pack_Acc_To_HU_Capacity.
--  220620  RasDlk  SCDEV-10342, Added the overloaded method Create_Report_Settings to create a pdf_info_ attribute string to be used to set pdf parameters when printing reports.
--  211116  PamPlk  SC21R2-5980, Modified Reserve_Shipment_Allowed___ and Reserve_Shipment__ in order to restrict automatic reservation for Purchase Receipt Return.
--  210906  Diablk  SC21R2-2530, Added DELIVER_THROUGH_CS as true in Process_All_Shipments__ , if consolidated orders and it's status is Reserve, Create_Pick_List, Print_Pick_List
--  210614  RoJalk  SC21R2-1031, Added Shipment_Auto_Packing_Util_API.Pack_Acc_Pack_Proposal to the method Process_Optional_Events, modified get_optional_events cursor
--  210614          in Process_Optional_Events to include PACK_ACC_PACK_PROPOSAL and PRINT_PACKING_LIST in the order by.
--  210531  RoJalk  SC21R2-1030, Modified Get_Allowed_Ship_Operations__, Process_All_Shipments__ and added the call Pack_Acc_Pack_Prop_Allowed__.
--  210531          Added the method Start_Pack_Acc_Pack_Proposal__. Called Shipment_Auto_Packing_Util_API.Pack_Acc_Pack_Proposal from Process_Nonmandatory_Events___.  
--  210301  BudKlk  SC2020R1-10437, Modified Get_Next_Mandatory_Events__() to change Preliminary to Undo complete.
--  210202  RasDlk  SC2020R1-11817, Modified Shipment_Processing_Error___, Shipment_Operation_Allowed__, Reserve_Shipment_Allowed__, Pick_Report_Shipment_Allowed__, 
--  210202          Get_Pick_Lists_For_Shipment__, Process_All_Shipments__ and Process_Optional_Events by reducing number of calls to increase the performance.
--  201102  RasDlk  SCZ-12201, Removed the parameter receiver_id_ from Print_Invoice___ and the relevant calling places.
--  200609  DiJwlk  Bug 153235 (SCZ-9724), Added overloaded method Start_Create_Pick_List__ with info_ parameter to send info_ messages to client.
--  200521  RoJalk  SC2020R1-7089, Modified Process_Nonmandatory_Events___ and removed the check for source ref type when sending dispatch advice.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  191107  RoJalk  SCSPRING20-486, Modified Reserve_Shipment__ to handle sender type and id.
--  171207  RoJalk  STRSC-9591, Modify Start_Shipment_Flow and called Shipment_API.Trigger_Complete_Ship_Allowed.
--  171124  RoJalk  STRSC-9103, Added teh overloaded method Start_Shipment_Flow with shipment_id_msg_ parameter.
--  170830  KhVese  STRSC-9595, Added methods Create_Data_Capture_Lov, Get_Next_Mandatory_Events__ and Shipment_Operation_Allowed__.
--  170817  ApWilk  Bug 137151, Modified the Print_Shipment_Delivery_Note__() to add the condition for avoiding the invalidated delivery notes by printing through the consolidated shipment.
--  170615  TiRalk  LIM-8588, Modified Process_Mandatory_Events__ and added method Check_Line_Config_Mismatch___ to check 
--  070615          the part line configuration mismatch before creating the picklist.
--  170608  JeLise  STRSC-8875, Replaced shipment_id_ with rec_.shipment_id in the call to Pick_Shipment_API.Pick_Event_Allowed 
--  170608          in the loop in Print_Pick_List_Allowed__.
--  170508  MaRalk  LIM-11258, Modified method Print_Pick_List_Allowed__ by replacing Pick_Shipment_API.Print_Pick_List_Allowed
--  170508          with Pick_Shipment_API.Pick_Event_Allowed
--  170504  MaRalk  LIM-11258, Modified method Process_Mandatory_Events__ by calling Pick_Shipment_API.Execute_Pick_Event
--  170504          instead of Shipment_Source_Utility_API.Print_Pick_List in order to support printing 
--  170504          Semi-Centralized Pick List report from Shipments overview. 
--  170504  MeAblk  Bug 135579, Process_All_Shipments__() to make it possible to execute the shipment flow of individual shipments in a consolidated shipment when completing it.
--  170504          This is allowed only when all the connected shipments are delivered at once.
--  170406  Jhalse  LIM-11096, Removed method Check_Pick_List_Use_Ship_Inv__ as shipment inventory is mandatory for shipment. 
--  170406          Also removed references to use_shipment_inventory_ for the same reason.
--  170330  MaRalk  LIM-9052, Modified Print_Pick_List_Allowed__ by replacing Shipment_Source_Utility_API.Print_Pick_List_Allowed
--  170330          with Pick_Shipment_API.Print_Pick_List_Allowed.
--  170330          Modified Get_Pick_Lists_For_Shipment__ by replacing Shipment_Source_Utility_API.Get_Pick_Lists_For_Shipment with
--  170303          Pick_Shipment_API.Get_Pick_Lists_For_Shipment.
--  170322  Chfose  LIM-10517, Renamed Start_Pack_Into_Handl_Unit__ to Start_Pack_Acc_HU_Capacity__ and Pack_Into_Handling_Unit to Pack_Acc_To_HU_Capacity.
--  170224  RoJalk  LIM-10811, Moved the content in Pick_Report_Ship_Allowed___ to Pick_Shipment_API.Pick_Report_Allowed.
--  170220  RoJalk  LIM-10811, Modified Process_Mandatory_Events__ and replaced Shipment_Source_Utility_API.Report_Shipment_Pick_Lists
--  170220          with Pick_Shipment_API.Execute_Pick_Event and Shipment_Source_Utility_API.Report_Shipment_Pick_Lists
--  170220          with ick_Shipment_API.Execute_Pick_Event.
--  170209  RoJalk  LIM-9118, Modified Create_Pick_List_Allowed__ and replaced Pick_Shipment_API.Create_Pick_List_Allowed
--  170209          with Pick_Shipment_API.Pick_Event_Allowed.
--  170207  RoJalk  LIM-10594, Replaced Shipment_Source_Utility_API.Create_Shipment_Pick_Lists with Pick_Shipment_API.Create_Pick_Lists
--  170207          Shipment_Source_Utility_API.Create_Pick_List_Allowed with Pick_Shipment_API.Create_Pick_List_Allowed.
--  161228  MaIklk  LIM-8390, Removed finalize shipment operation digit from Get_Allowed_Ship_Operations__.
--  161228  MaIklk  LIM-8390, Removed Start_Automatic_Shipment__ since it is not used now (already middle tier packages were obsoloted using STRSC-1217).
--  161209  Jhalse  LIM-9188, Removed optional event for connecting handling units from inventory
--  161107  RoJalk  LIM-8391, Replaced Shipment_Handling_Utility_API.Release_Not_Reserved_Qty__ with Shipment_API.Release_Not_Reserved_Qty.
--  161102  MaIklk  LIM-9230, Fixed to call Reserve_Shipment_API in reservation and Moved Pick_Shipment_Rec to Reserve_Shipment and renamed to Reserve_Shipment_Rec.
--  161027  DaZase  LIM-7326, Changed Print_Handling_Unit_Labels___ so it now prints a Handling Unit Label report. Added Print_Shp_Handl_Unit_Labels___ 
--  161027          for printing shipment handling unit labels (what Print_Handling_Unit_Labels___ used to do). Changed parameter name in Print_Shipment_Doc___.
--  161027          Added Print_Handl_Unit_Label_Doc___. Changes in Process_Optional_Events, renamed event PRINT_HANDLING_UNIT_LABELS to PRINT_HANDLING_UNIT_LABEL, 
--  161027          added event PRINT_SHIP_HANDL_UNIT_LABEL.
--  161026  MaRalk  LIM-9153, Replaced Shipment_API.Deliver_Shipment__ with Shipment_Delivery_Utility_API.Deliver_Shipment.
--  161026  RoJalk  LIM-8391, Replaced Shipment_Handling_Utility_API.All_Lines_Picked with Shipment_API.All_Lines_Picked.
--  161026  RoJalk  LIM-8391, Replaced Contains_Dangerous_Goods__ with Shipment_API.Contains_Dangerous_Goods.
--  161026  RoJalk  LIM-8391, Replaced Blocked_Sources_Exist___ with Shipment_API.Blocked_Sources_Exist.
--  161010  RoJalk  LIM-8391, Removed Process_Optional_Events___ and replaced the usage with Process_Optional_Events.
--  161007  RoJalk  LIM-8391, Code improvements so the methods with similar usage be next to each other.
--	 160930	Jhalse  LIM-8594, Added new optional event for connecting handling units from inventory to shipment.
--  160923  DilMlk  Bug 131342, Modified Print_Shipment_Delivery_Note__ to assign and pass NULL as result_ variable for the method call Customer_Order_Flow_API.Create_Print_Jobs 
--  160923          in order to create and print correct number of instances (delivery note copies) when printing delivery notes.
--  160907  MaRalk  LIM-8656, Removed methods Print_Shipment_Pick_List_, Start_Print_Consol_Pl__ and call 
--  160907          Shipment_Source_Utility_API.Print_Pick_List within Shipment_Flow_API.Process_Mandatory_Events__.
--  160824  RoJalk  LIM-8198, Modified Deliver_Shipment___ and moved the code to update actual ship date to Shipment_API.Deliver_Shipment__.
--  160810  MaRalk  LIM-6755, Modified the error messages ORDERSBLOCKED, CONFIGMISMATCH in order to support generic shipment functionality.
--  160810          Modified Process_Mandatory_Events__ to replace parameter name blocked_orders_found with blocked_sources_found_.
--  160810          Renamed ORDERSBLOCKED to SOURCESBLOCKED.
--  160729  MaIklk  LIM-8057, Moved invoicing related functions to this package and added conditional compilation.
--  160729  RoJalk  LIM-7954, Modified Deliver_Shipment___ and replaced Shipment_Source_Utility_API.Deliver_Shipment
--  160729          with Shipment_API.Deliver_Shipment__.
--  160727  RoJalk  LIM-7957, Modified Process_Nonmandatory_Events___ and removed conditional compilation  
--                  since Dispatch_Advice_Utility_API is moved to SHPMNT.
--  160725  RoJalk  LIM-8142, Replaced Shipment_Line_API.Connected_Lines_Exist with Shipment_API.Connected_Lines_Exist.
--  160613  RoJalk  LIM-7680, Replaced Customer_Order_Transfer_API.Send_Dispatch_Advice with Dispatch_Advice_Utility_API.Send_Dispatch_Advice.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160520  UdGnlk  LIM-7475, Modified Print_Shipment_Doc___() by TRANSPORT_PACKAGE_LABEL_REP to SHPMNT_HANDL_UNIT_LABEL_REP. 
--  160511  MeAblk  Bug 129130, Modified Print_Shipment_Doc___() to set the LAYOUT_NAME in order to correctly distinguish the reports to the report framework and 
--	 160511          modified Print_Handling_Unit_Labels___() to correctly consider the top level handling units when printing handling unit labels.
--  160511  RoJalk  LIM-6964, Modified Pack_Into_Handling_Unit and removed conditional compilation when calling Shipment_Line_API.Connect_To_New_Handling_Units.
--  160503  RoJalk  LIM-7310, Renamed Shipment_Connectable_Line.remaining_parcel_qty to remaining_qty_to_attach
--  160308  MaRalk  LIM-5871, Modified Reserve_Shipment_Allowed___, Reserve_Shipment__ 
--  160308          to reflect shipment_line_tab-sourece_ref4 data type change. 
--  160223  MaIklk  LIM-4136, Made Print_Shipment_Delivery_Note__ generic.
--  160219  MaIklk  LIM-4134, Renamed Pick_Plan_Shipment__() to Reserve_Shipment__() and made it generic.
--  160218  MaIklk  LIM-4144, Moved Shipment_Processing_Error() from Cust_Order_Event_Creationg_API to this package.
--  160218  MaIklk  LIM-4155, Moved Print_Ship_Consol_Pl___(), Print_Ship_Consol_Pick_List__() and Start_Print_Ship_Consol_Pl__() to Create Pick List.
--  160217  MaIklk  LIM-4157, Moved Check_Manual_Tax_Lia_Date___ to Shipment Order Utility.
--  160217  MaIklk  LIM-4132, Renamed Blocked_Orders_Exist to Blocked_Sources_Exist and made Blocked_Sources_Exist() generic.
--  160216  MaIklk  LIM-4141, Handled the pick list related content in Start_Print_Consol_Pl__() via Shipment Source Utility.
--  160212  MaIklk  LIM-4146, Added Fetch_Consl_Source_Ref_Type___() and made Customer_Order_Line_API.Get_Current_Info call source dependent.
--  160211  MaIklk  LIM-4133, Removed Process_Automatic_Shipment__() and Start_Automatic_Shipment__().
--  160211  MaIklk  LIM-4143, Removed Finalize_Shipment_Allowed__().
--  160210  MaIklk  LIM-4138, Made Print_Delivery_Note_Allowed__() generic.
--  160210  MaIklk  LIM-4131, Made Start_Shipment_Flow() generic.
--  160210  MaIklk  LIM-6229, Added Pick_Report_Ship_Allowed___().
--  160209  MaIklk  LIM-4147, Moved the call Customer_Order_Pick_List_API.Check_Pick_List_Use_Ship_Inv to Shipment Source Utility.
--  160209  MaIklk  LIM-4158, Moved the call Print_Invoices() to shipment source utility.
--  160209  MaIklk  LIM-4140, Moved Print_Invoice_Allowed__() to Shipment Source Utility.
--  160209  MaIklk  LIM-6229, Moved Pick list related code to Shipment source utility.
--  150203  MaIklk  LIM-4139, Moved Create_Ship_Invoice_Allowed__() to shipment source utility and fixed the usage.
--  160203  MaIklk  LIM-4156, Fixed to check the source when calling Customer_Order_Transfer_API.Send_Dispatch_Advice() in Process_Nonmandatory_Events___().
--  160201  MaIklk  LIM-4153, Moved the content of Get_Pick_Lists_For_Shipment___() to Pick Customer Order and made the function generic.
--  160201  MaIklk  LIM-4154, Moved the content of Print_Pick_List_Allowed___() to Customer Order Pick List and made the function generic.
--  160128  MaIklk  LIM-4152, Moved the content of Pick_Report_Ship_Allowed___() to Pick Customer Order package and made the function generic.
--  160128  MaIklk  LIM-6116, Moved the content of Create_Pick_List_Allowed___() to CreatePickList package and made the function generic.
--  160128  MaIklk  LIM-4151, Moved Plan_Pick_Shipment_Allowed___() to Shipment Order Utility and call it from Shipment Source Utility.
--  160127  MaIklk  LIM-4150, Made Deliver_Shipment___() generic by moving order specifc call to Shipment Source Utility. 
--  160127  MaIklk  LIM-4148, Moved Reserve_Shipment___() and made Create_Shipment_Pick_Lists___() and Report_Shipment_Pick_Lists___() generic.
--  160120  RoJalk  LIM-5910, included shipment_line_no to Pack_Acc_To_Packing_Instr cursor, Pack_Into_Handling_Unit.
--  160118  RoJalk  LIM-5911, Included source_ref_type in Shipment_Line_API.Remove_Shipment_Line method call.
--  151229  MaIklk  LIM-4093, Used Shipment_API.Shipment_Delivered() instead calling ShipmentHandlingUtility.
--  151217  MaIklk  LIM-5356, Handled to save actual ship date when shipment was delivered.
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151119  RoJalk  LIM-4886, Make Shipment Line Generic - Rename SALES_QTY to SHIPMENT_QTY, REVISED_QTY_DUE to INVENTORY_QTY. 
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  150922  AyAmlk  Bug 124537, Modified Print_Pick_List_Allowed__() as a pick list can be printed or not cannot be decided on automatic pick reporting.
--  150702  JaBalk  RED-496, Modified Process_Shipment___ to set the TRUE flag for online_processing_ if it is rental transfer.
--  150611  JaBalk  RED-484, Modified Process_Mandatory_Events__ to initialize the variable rental_transfer_db_ to FALSE.
--  150605  JaBalk  RED-361, Modified Start_Shipment_Flow, Process_All_Shipments__ to pass the rental_transfer value to Process_Mandatory_Events__to bypass the stop of event for rental transfer.
--  150922  AyAmlk  Bug 124537, Modified Print_Pick_List_Allowed__() as a pick list can be printed or not cannot be decided on automatic pick reporting.
--  150728  ShKolk  Bug 123092, Modified Print_Shipment_Doc___ to set COPIES option to support StreamServe reports.
--  150618  NWeelk  Bug 123054, Modified Print_Shipment_Delivery_Note__ to pass result_ to method Create_Print_Jobs instead of NULL. 
--  150522  ChJalk  Bug 122634, Added annotation @UncheckedAccess to the method Get_Next_Step.
--  150202  JeLise  PRSC-5732, Added credit check in Pick_Plan_Shipment__ and modified Blocked_Orders_Exist to handle reservation.
--  141204  MAHPLK  PRSC-409, Modified Start_Reserve_Shipment__ to return 'info'.
--  141116  KiSalk  Bug 119615, Added new parameter printed_flag_ to Get_Pick_Lists_For_Shipment__ and Get_Pick_Lists_For_Shipment___ to return printed and not pick lists separately.
--  140820  RoJalk  Bug 117755, In Get_Pick_Lists_For_Shipment___, added condition to filter out already printed pick lists to stop printing previously printed ones from shipment client.
--  140819  RoJalk  Modified Pick_Plan_Shipment__ and Plan_Pick_Shipment_Allowed___ to consider qty on order.
--  140508  MAHPLK  Added new optional event RELEASE_QTY_NOT_RESERVED to Process_Optional_Events___.
--  140325  RoJalk  Modified Pick_Plan_Shipment__ to include only the shipments in 'Preliminary' state.
--  140219  MAHPLK  Modified Print_Handling_Unit_Labels___, Print_Shipment_Doc___ to consider number of handling unit labels.
--  140210  FAndSE  Adjusted Pick_Plan_Shipment__ to handle Package Parts as well. Supply Code 'PKG' was included in the cursor.
--  140205  Rojalk  Restructured and aligned the cursor in Pick_Plan_Shipment__ and Plan_Pick_Shipment_Allowed___.
--  140203  RoJalk  Modified Pick_Plan_Shipment__ to consider only specific set of supply codes.
--  140130  MAHPLK  Modified Pick_Report_Ship_Allowed___ to use Client_SYS.text_separator_ as text separator.
--  140129  ChBnlk  Bug 113704, Modified Create_Shipment_Pick_Lists__() to add a warning message to be displayed at pick list creation if there's a 
--  140129          configuration mismatch between customer order lines in demand and supply sites. 
--  131024  MaMalk  Modified Process_Automatic_Shipment__ to modify all the cursors to remove the COL state cheking and consider SOL quantities.
--  131007  MaMalk  Modified Process_Automatic_Shipment__ to use Pick_Report_Ship_Allowed___ to check when the picking is performed in finalize shipment.
--  130830  TiRalk  Bug 109294, Modified Print_Shipment_Delivery_Note__ by calling Create_Print_Jobs and Printing_Print_Jobs of 
--  130830          Customer_Order_Flow_API to create one print job for shipment delivery note and instances for delivery note copies.
--  130708  ChJalk  TIBE-1026, Modified Process_Automatic_Shipment__ to replace Transaction_SYS.Set_Status_Info  with Transaction_SYS.Log_Status_Info.
--  130826  MaMalk  Modified Start_Shipment_Flow to take the processing of optional events out of the if condition.
--  130823  MaMalk  Moved the validation exists to prevent the individual shipment delivery when connected to a consolidated shipment from Process_Mandatory_Events__ to Deliver_Shipment___.
--  130819  MaMalk  Modified Process_Optional_Events___ to print address labels per handling unit.
--  130814  MaMalk  Added Blocked_Orders_Exist and called this method when finalizing shipment and when running the automatic shipment flow.
--  130808  MaMalk  Changed the number of parameters to Invoice_Customer_Order_API.Make_Shipment_Invoice__ to pass a dummy_attr_.
--  130808  MaMalk  Removed unused method Contains_Dangerous_Goods___.
--  130801  MeAblk  Removed parameter generate_structure_ from the method Start_Automatic_Shipment__. 
--  130730  MaMalk  Modified Get_Next_Step to consider Report Picking of Pick List Lines when returning a value from this method.
--  130730          Additionally corrected a problem in Print_Pick_List_Allowed__ to have the same logic for Consolidated Shipments as for the Normal Shipments.
--  130719  MaEelk  Removed the call to Shipment_Handling_Utility_API.Generate_Package_Structure.
--  130715  RoJalk  Added the method Get_Next_Step to be used in SHIPMENT_TO_REASSIN_LOV. 
--  130715  MaMalk  Modified Print_Shipment_Delivery_Note__ to pack the SHIPMENT_ID to the report attribute string.
--  130705  MaMalk  Modified Print_Proforma_Ivc_Allowed___ to allow the printing of pro forma invoice once the shipment gets completed.
--  130628  MAHPLK  Removed parameter update_pick_lists_ from Report_Shipment_Pick_Lists___.
--  130627  JeLise  Added check on remaining_parcel_qty cursor in both Pack_Acc_To_Packing_Instr and Pack_Into_Handling_Unit.
--  130618  JeLise  Added check on packing_instruction_id in Pack_Acc_To_Packing_Instr and on handling_unit_type_id in Pack_Into_Handling_Unit.
--  130617  RoJalk  Modified Pick_Plan_Shipment__ and included the filtering for co line qty columns to identify over picked scenario.
--  130613  JeLise  Removed calls to to methods regarding Generate Package Structure and added calls to methods regarding Pack according to Packing Instruction 
--  130613          and Pack into Handling Unit in Process_Nonmandatory_Events___ and Process_All_Shipments__. Removed method Start_Generate_Structure__
--  130613          and added methods Start_Pack_Into_Handl_Unit__ and Start_Pack_Acc_Packing_Instr__.
--  130611  JeLise  Changed methods Pack_Acc_To_Packing_Instr and Pack_Into_Handling_Unit from implementation to public methods.
--  130611  MAHPLK  Modified methods Deliver_Shipment___ and Get_Allowed_Ship_Operations__.
--  130604  MAHPLK  Modified Get_Pick_Lists_For_Shipment___. Added get_pick_list_count cursor to Pick_Report_Ship_Allowed___.
--  130604  MeAblk  Renamed method Print_Transport_Labels___ as Print_Handling_Unit_Labels___. Modified Print_Transport_Labels___ in order to retrieve data from handling units in 
--  130604          shipment handling unit structure. Modified Process_Optional_Events___ to preserve the order of optional events 'Create SSCC' and 'Print Handling Unit Labels'.
--  130604          Removed parameter package_unit_id_ from Print_Shipment_Doc___. 
--  130529  JeLise  Modified Process_Optional_Events___ to handle two new events and removed GENERATE_STRUCTURE.
--  130523  MaMalk  Modified Process_All_Shipments__ and Process_Mandatory_Events__ to prevent the shipment been delivered individually if it is connected to a consolidated shipment.
--  130522  MAHPLK  Added new public method Process_Optional_Events.
--  130522  MaMalk  Modified Process_All_Shipments__ to process all the shipments in a consolidated shipment according to the ascending or descending order of load_sequence_no.
--  130521  MaMalk  Modified Process_All_Shipments__ to remove the logic created to handle report picking of Consolidated Shipments.
--  130520  MeAblk  Modified the parameters into the method call Shipment_Handling_Utility_API.Connect_Sscc.
--  130514  MAHPLK  Added methods Print_Ship_Consol_Pl___, Start_Print_Ship_Consol_Pl__ and Print_Ship_Consol_Pick_List__.
--  130405  MAHPLK  Modified parameter list of the Create_Pick_List_API.Create_Shipment_Pick_Lists__ in Create_Shipment_Pick_Lists___.
--  130404  MaMalk  Modified Process_All_Shipments__ to consider the shipment_type of each shipment when the consolidated shipment is processed.
--  130214  RoJalk  Renamed the column fixed to be auto_connection_blocked and modified the references.
--  130212  RoJalk  Modified Process_Optional_Events___ to ahndle the optional event NORMAL_SHIPMENT_FIXED.
--  130128  MaMalk  Replaced CREATE_PICK_LIST_JOIN with CREATE_PICK_LIST_JOIN_MAIN.
--  130122  RoJalk  Added the parameter report_pick_from_co_lines_ to the method Pick_Report_Shipment_Allowed and modified Get_Allowed_Ship_Operations__
--  130122          to identfy destination form as frmPickReportDiff when used in RMB enbling logic in shipment. Modified Deliver_Shipment_Allowed___
--  130122          and called Shipment_Handling_Utility_API.All_Lines_Picked.
--  130117  MaMalk  Added method Start_Shipment_Flow to start the shipment flow through the customer order flow.
--  130104  RoJalk  Modified Deliver_Shipment_Allowed___ to refer to picked qty from shipment_order_line_tab.
--  121220  MaMalk  Modified Process_All_Shipments__ to support the background printing when the normal shipments are printed from the Shipments window.
--  121219  MaMalk  Added methods Start_Print_Consignment_Note__, Start_Print_Bill_Of_Lading__, Start_Print_Packing_List__, Start_Print_Proforma_Inv__,
--  121219          Start_Print_Address_Label__, Start_Print_Shipment_Delnote__.
--  121218  MaMalk  Modified Get_Allowed_Ship_Operations__  to consider generate structure and send dispatch advice.
--  121210  MaMalk  Added methods Get_Pick_Lists_For_Shipment___, Print_Pick_List_Allowed___ and moved the logic in Get_Pick_Lists_For_Shipment__ and Print_Pick_List_Allowed__
--  121210          to the new method to handle both types of shipments.
--  121210  MaMalk  Added methods Pick_Report_Ship_Allowed___, Print_Proforma_Ivc_Allowed___ and moved the logic in Pick_Report_Shipment_Allowed__ and Print_Proforma_Ivc_Allowed__
--  121210          to the new method to handle both types of shipments.
--  121210          Also added method Check_Pick_List_Use_Ship_Inv__.
--  121207  MaMalk  Modified method Process_All_Shipments__ to handle the Generate Structure option for Consolidated Shipments.
--  121206  MaMalk  Added methods Create_Pick_List_Allowed___, Deliver_Shipment_Allowed___ and moved the logic in methods Create_Pick_List_Allowed__, Deliver_Shipment_Allowed__
--  121206          to the new method to handle both categories of shipments.
--  121205  MaMalk  Moved some of the logic in Process_All_Shipments__ into the new method Process_Shipment___ and the logic in Plan_Pick_Shipment_Allowed__
--  121205          into the new method Plan_Pick_Shipment_Allowed___ to handle both categories of shipments.
--  121120  RoJalk  Modified Plan_Pick_Shipment_Allowed__, Pick_Report_Shipment_Allowed__ to support multiple shipment lines per Customer Order Line.
--  121031  RoJalk  Modified Process_Automatic_Shipment__ and passed shipment id to the method call Customer_Order_Reservation_API.Pick_List_Exist.
--  121031          Modified Pick_Plan_Shipment__ and passed shipment_id to the method call Customer_Order_Flow_API.Start_Plan_Picking__.
--  121024  MAHPLK  Modified cursor get_optional_events in method Process_Optional_Events___.
--  121023  MAHPLK  BI-677, Modified rowstate to 'Completed' in Deliver_Shipment_Allowed__ , Plan_Pick_Shipment_Allowed__ and Pick_Report_Shipment_Allowed__..
--  121022  MeAblk  Modified respective methods in order to make Print Shipment Delivery Note as an optional event(Task ID BI-632).
--  120921  MeAblk  Modified method Process_Nonmandatory_Events___ in order to add parameter show_shipment_id_ into the function call Shipment_Handling_Utility_API.Generate_Package_Structure. 
--  120921          This makes possible to show the shipment id in the server side error messages regarding Generate Package structure.
--  120814  MeAblk  Added Start_Generate_Structure__ and Start_Send_Dispatch_Advice__ to support the RMBs Generate Structure, Send Dispatch Advice...
--  120814          in Overview Shipments. Accordingly modified the procedure Process_Nonmandatory_Events___.
--  120813  MeAblk  Added Start_Cancel_Shipment__ to support the RMB Cancel in Overview Shipments. Accordingly modified Process_Nonmandatory_Events___ in order to
--  120813          handle the RMB Cancel in Overview Shipments. Added Get_Pick_Lists_For_Shipments to support the RMB Report Picking of Customer Order Lines in Overview Shipments. 
--  120813  MeAblk  Added Start_Cancel_Shipment__ to support the RMB Cancel in Overview Shipments. Accordingly modified Process_Nonmandatory_Events___ in order to
--  120813          handle the RMB Cancel in Overview Shipments.
--  120810  MaEelk  Renamed Process_Shipment__ as Process_Mandatory_Events__. Added a boolean parameter to Process_All_Shipments__ that would decide the
--  120810          event is mandatory or not. Added Start_Reopen_Shipment__ and Process_Nonmandatory_Events___ to support the RMB preliminary in Overview Shipments.
--  120802  RoJalk  Modified Process_Optional_Events___ and left exception handling to calling method to avoid incorrect behavior in background jobs.
--  120730  RoJalk  Modified Print_Transport_Labels___ to print the direct package units.
--  120730  RoJalk  Code improvements to the method Process_Optional_Events___.
--  120727  RoJalk  Modified Process_Shipment__ and handled optional events for Print Invoice.
--  120727  MaEelk  Added Print Invoice option to Automated Shipment Flow.
--  120725  MeAblk  Added new overloaded procedure Report_Shipment_Pick_Lists___, in order to update the shipment inventory location in the pick list and shipment
--  120725          accordingly when pick reporting shipment pick list. Accordingly modified Process_Shipment__.
--  120725  RoJalk  Modified teh method Create_Sssc___ and checked for delivered lines.
--  120725  RoJalk  Modified teh method Create_Sssc___ and checked for delivered lines.
--  120725  RoJalk  Removed commented code from Print_Consignment_Note___.
--  120724  RoJalk  Modified Generate_Structure___ to check if connected order lines exists for the shipment.
--  120724  RoJalk  Modified Process_Shipment__ and added COMMIT statements after each main event before processing optional events.
--  120724  RoJalk  Added method Print_Transport_Labels___, Generate_Structure___, modified Print_Shipment_Doc___ to handle handling_unit_id,  package_unit_id_. 
--  120723  RoJalk  Modified Process_Shipment__ and called Process_Optional_Events___ for event 90. 
--  120723  MaEelk  Added Start_Create_Ship_Invoice__ to automated shipment flow.
--  120723  RoJalk  Added the method Create_Sssc___.
--  120720  RoJalk  Added methods Print_Pro_Forma_Invoice___, Print_Packing_List___.
--  120720  RoJalk  Added methods Print_Consignment_Note___, Print_Bill_Of_Lading___, Print_Address_Label___. Modified Print_Goods_Declaration___ to use Print_Shipment_Doc___.
--  120720  RoJalk  Removed the method Print_Shipment___, added Print_Shipment_Doc___, modified Process_Shipment__ to handle optional events. 
--  120720  RoJalk  Added the method Process_Optional_Events___ to handle optional events defined for the shipment type and main events of the shipment. 
--  120717  MaEelk  Added Start_Close_Shipment__ to automated shipment flow.
--  120716  MaEelk  Added Start_Deliver_Shipment__, Start_Print_Ship_Deliv_Note__ to automate the shipment flow.
--  120716  MaEelk  Removed methods Deliver_Shipment__ and Start_Deliver_Shipment__  having the parameter shipment_id since they will not be used anymore. 
--  120713  MaEelk  Old method Start_Create_Pick_List__ having the parameter shipment_id_ was removed since it will not be used anymore.
--  120711  MaEelk  Added Process_Shipment__, Process_All_Shipments__, Start_Reserve_Shipment__, Start_Create_Pick_List__, Start_Print_Pick_List__,
--  120711          Start_Pick_Report_Shipment__, Start_Complete_Shipment__ and Start_Deliver_Shipment__ to automate the shipment flow.
--  120828  SudJlk  Bug 101743, Modified method Process_Automatic_Shipment__ to deliver undelivered components through order flow by removing shipment connection
--  120828          when discon_no_reservations is TRUE for packages where one component is picked through the shipment.
--  120423  Darklk  Bug 102161, Modified the procedure Process_Automatic_Shipment__ in order to prevent the oracle error when removing the shipment lines.
--  120229  TiRalk  Reversed the Bug 77713 since the print server is no longer available in APP8.
--  120220  SudJlk  Bug 100718, Modified Pick_Plan_Shipment__ to fetch shipment records of package parts instead of component level parts in cursor get_shipment_lines.
--  120214  IsSalk  Bug 100671, Added parameter finalize to method Plan_Pick_Shipment_Allowed__ and modified methods Process_Automatic_Shipment__ and Get_Allowed_Ship_Operations__
--  120214          to not to consider credit blocked order lines at the finalize shipment.
--  120124  IsSalk  Bug 100671, Modified method Plan_Pick_Shipment_Allowed__ to get the order lines where the order rowstate is not equal to 'CreditBlocked' and
--  120124          added function Finalize_Shipment_Allowed__ and used in Get_Allowed_Ship_Operations__ to check whether the finalize shipment can be performed.
--  110802  MaEelk  Replaced the obsolete method call Print_Server_SYS.Enumerate_Printer_Id with Logical_Printer_API.Enumerate_Printer_Id.
--  110726  SudJlk  Bug 97685, Modified Create_Shipment_Pick_Lists___ to pass NULL as location_group to Create_Pick_List_API.Create_Shipment_Pick_Lists__. 
--  110711  MaMalk  Replaced Customer_Order_Pick_List with Customer_Order_Pick_List_Tab.
--  110629  TiRalk Bug 77713, Modified procedure Print_Shipment_Delivery_Note__ to create new print job based on foundation1 parameter 
--  110629         'Print Server Pdf-archiving setup' using Print_Job_API.New_Print_Job().
--  090925  ChJalk  Bug 82611, Added Function Print_Proforma_Ivc_Allowed__ and used in Get_Allowed_Ship_Operations__ to check whether the proforma invoice can be printed.
--  090901  ChJalk  Bug 82611, Modified Get_Allowed_Ship_Operations__.
--  090826  NWeelk  Bug 85411, Changed Contains_Dangerous_Goods___ implementation method to private, changed the return type of it, to VARCHAR2 and
--  090826          removed methods Print_Consignment_Notes__, Print_Bill_Of_Lading__, Print_Shipment___ and Print_Goods_Declaration___.
--  090618  SudJlk  Bug 83945, Modified Pick_Plan_Shipment__ to change the type of pick_ship_tab_.
--  090522  NWeelk  Bug 82382, Modified Print_Shipment_Delivery_Note__ by adding alt_del_note_no to the parameter_attr_.
--  090519  DaGulk  Bug 82188, Modified method Print_Shipment_Delivery_Note__ to print 'No of Delivery Note Copies' defined for the customer.
--  090406  SudJlk  Bug 80630, Modified Pick_Plan_Shipment__ to enable shipments with large number of connected order lines to be passed to Customer_Order_Flow_API.Start_Plan_Picking__.
--  090105  SaJjlk  Bug 78884, Added parameter process_in_background_ to method Print_Shipment_Pick_List__ and modified method 
--  090105          Process_Automatic_Shipment__ to add new parameter to the method call for Print_Shipment_Pick_List__.
--  081216  SaJjlk  Bug 78884, Modified method Print_Shipment_Pick_List__ to be able to handle large number of records and added method Start_Print_Consol_Pl__.        
--  081216          Increased length of variable pick_list_no_list_ in method Get_Pick_Lists_For_Shipment__.
--  081201  SaRilk  Bug 77918, Modified variable type of pick_list_no_list_ to Create_Pick_List_API.Pick_List_Table in Create_Shipment_Pick_Lists___.
--  080707  NaLrlk  Bug 74298, Modified the method Process_Automatic_Shipment__ to add the parameter consider_reserved_qty_ to the 
--  080707          method call Reserve_Customer_Order_API.Clear_Unpicked_Shipment_Res__.
--  080701  NaLrlk  Bug 74298, Modified Process_Automatic_Shipment__ to handle the parameter discon_not_picked_ in method calls 
--  080701          and added parameter discon_not_picked_ to Reserve_Shipment___.
--  080626  NaLrlk  Bug 74298, Modified the cursor get_non_picked_lines to consider the col state PartiallyDelivered.
--  080624  NaLrlk  Bug 74298, Modified the cursor get_non_picked_lines with method Process_Automatic_Shipment__ to handle non picked pkg parts.
--  080620  NaLrlk  Bug 74298, Modified methods Start_Automatic_Shipment__ and Process_Automatic_Shipment__ to removal of lines not picked.
--  090615  KiSalk  Part_Catalog_Invent_Attrib_API.Get_Adr_Rid_Class call changed to Part_Catalog_Invent_Attrib_API.Get_Adr_Rid_Class_Id.
--  080510  SaJjlk  Bug 73646, Modified method Process_Automatic_Shipment__ to send the report to printer.
--  071231  SaJjlk  Bug 69977, Modified cursor get_released_lines in Process_Automatic_Shipment__ to facilitate removal of lines with no reservations.
--  071210  SaJjlk  Bug 66397, Modified method Process_Automatic_Shipment__ to clear unpicked reservations when the full sales
--  071210          quantity has been reserved when the finalize_on_picked_qty_ is TRUE and consider_resreved_qty_ is FALSE.
--  071210          Modified methods Get_Next_Event___ and Process_Automatic_Shipment__ to change the
--  071210          sequence of events to print delivery note after delivering the shipment. Modified method
--  071210          Deliver_Shipment_Allowed__ to exclude already delivered package component lines from the cursor get_order_lines.
--  071210          Added parameters finalize_on_picked_qty_, consider_reserved_qty_ and disconnect_released_ to method 
--  071210          Start_Automatic_Shipment__ and first two parameters to Reserve_Shipment___. Modified method Deliver_Shipment_Allowed__.
--  070801  NuVelk  Bug 65015, Modified the function Plan_Pick_Shipment_Allowed__. 
--  070314  SeNslk  LCS Merge 63347, Modified methods Create_Shipment_Pick_Lists__ and Deliver_Shipment__ to lock the shipment before processing the operation.
--  070305          Converted Lock_Shipment___ into a private method to be called from LU PickCustomerOrder.
--  070118  MaJalk  At method Reserve_Shipment___, changed Reserve_Customer_Order_API.Pick_Plan_Ship_Lines__ 
--  070118          to Reserve_Customer_Order_API.Reserve_Shipment_Lines__.
--  061125  NiDalk  Bug 61274, Removed method Any_Reserved_Lines_Exist__ and modified method Process_Automatic_Shipment__
--  061102          to correctly process the shipment when reservations already exist.
--  061125  KaDilk  Bug 61168, Modified function Plan_Pick_Shipment_Allowed__ to reserve order lines in automatic shipment process. 
--  061114  MaJalk  Removed parameter allow_backorders_ and modified method Pick_Plan_Shipment__.
--  060929  ChJalk  Modified Plan_Pick_Shipment_Allowed__.
--  060524  NuFilk  Bug 57743, Modified method Create_Pick_List_Allowed__ removed the check on pallet_id 
--  060524          in create_pick_list cursor so that its possible to create pick list for pallet handled parts too.
--  060308  IsAnlk  Added methods Print_Delivery_Note_Allowed__ and Pirnt_Shipment_Dleivery_Note__.  
--  051227  RaKalk  Modified Get_Allowed_Ship_Operations__ to add Cancel Operation
--  051103  GeKalk  Removed onhand_Analysis_Flag parameter from Pick_Plan_Shipment__ method.
--  050509  IsAnlk  Changed method call Line_Reservations_Exist__ as Unpicked_Reservations_Exist__(LCS 49003).
--  050216   IsAnlk  Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050201  NuFilk  Added new method Deliver_Shipment__ and Start_Deliver_Shipment__.
--  050131  UsRalk  Added new private method Print_Bill_Of_Lading__.
--  050131  NuFilk  Added new method Any_Reserved_Lines_Exist__. Modified method
--  050131          Process_Automatic_Shipment__ to consider the manualy reserved qty and process the shipment.
--  050128  NuFilk  Modified method Process_Automatic_Shipment__.
--  050125  NuFilk  Added new method Get_Pick_Lists_For_Shipment__, Create_Shipment_Pick_Lists__
--  050125          Start_Create_Pick_List__ and Create_Pick_List_Allowed__.
--  050121  UsRalk  Added new methods Print_Shipment___,Contains_Dangerous_Goods___ and Print_Goods_Declaration___.
--  050121  UsRalk  Added new private method Print_Consignment_Notes__.
--  050120  GeKalk  Added methods Print_Pick_List_Allowed__ and Print_Shipment_Pick_List__.
--  050120  NuFilk  Modified the cursor get_shipment_lines in method Pick_Plan_Shipment__.
--  050119  NuFilk  Added Undefine for the defined variables.
--  050111  NuFilk  Modified Process_Automatic_Shipment__.
--  050113  SaJjlk  Added methods Deliver_Shipment_Allowed__, Get_Allowed_Ship_Operations__,
--                  Pick_Plan_Shipment__, Pick_Report_Shipment_Aloowed__ and Plan_Pick_Shipment_Allowed__.
--  050111  NuFilk  Modified Start_Automatic_Shipment__ and Process_Automatic_Shipment__.
--  050105  NuFilk  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Event_Rec               IS RECORD (
   event                     Shipment_Event_Tab.event%TYPE,
   description               VARCHAR2(50));

TYPE Event_Tab               IS TABLE OF Event_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_                     CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;
db_false_                    CONSTANT VARCHAR2(5)  := Fnd_Boolean_API.db_false;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-- Reserve_Shipment_Allowed___
--   Return TRUE (1) if the Plan Picking (Reserve) operation is allowed for the
--   specified  shipment
FUNCTION Reserve_Shipment_Allowed___ (
   shipment_id_         IN    NUMBER,
   source_ref_type_db_  IN    VARCHAR2) RETURN NUMBER
IS   
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;   
   allowed_                NUMBER := 0;  
   CURSOR reserve_allowed(source_ref_  IN VARCHAR2)  IS
     SELECT sl.source_ref1,sl.source_ref2,sl.source_ref3,sl.source_ref4
     FROM   SHIPMENT_LINE_PUB sl
     WHERE  sl.shipment_id    = shipment_id_
     AND    sl.source_ref_type_db = source_ref_  
     AND    (((sl.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) >= 0)) OR
             (sl.source_ref_type_db NOT IN (Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)))
     AND    (sl.inventory_qty - sl.qty_assigned - sl.qty_to_ship - sl.qty_shipped > 0);   
BEGIN
   IF (Shipment_API.Get_Objstate(shipment_id_) != 'Preliminary') THEN
      RETURN allowed_;
   END IF;
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      FOR line_rec_ IN reserve_allowed(source_ref_type_list_(i_)) LOOP
         allowed_ := Reserve_Shipment_API.Reserve_Line_Allowed(shipment_id_, line_rec_.source_ref1,line_rec_.source_ref2,line_rec_.source_ref3,line_rec_.source_ref4, source_ref_type_list_(i_));    
         IF(allowed_ = 1) THEN
            RETURN allowed_;
         END IF;
      END LOOP;
   END LOOP;   
   RETURN allowed_;
END Reserve_Shipment_Allowed___;


FUNCTION Deliver_Shipment_Allowed___ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;
BEGIN
   IF (Shipment_API.Get_Objstate(shipment_id_) = 'Completed') THEN
      IF (Shipment_API.All_Lines_Picked(shipment_id_) = 'TRUE') THEN
         allowed_ := 1;
      END IF;
   END IF;
   RETURN allowed_;
END Deliver_Shipment_Allowed___;


-- Print_Invoice_Allowed___
--   Return TRUE (1) if the Print Invoice operation is allowed for the
--   specified  order 
FUNCTION Print_Invoice_Allowed___ (
   shipment_id_         IN    NUMBER,
   source_ref_type_db_  IN    VARCHAR2 ) RETURN NUMBER
IS   
   allowed_                NUMBER := 0;   
BEGIN
   IF(Shipment_API.Source_Ref_Type_Exist(source_ref_type_db_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN    
      $IF Component_Order_SYS.INSTALLED $THEN
         allowed_ := Customer_Order_Inv_Head_API.Allow_Print_Shipment_Invoice(shipment_id_);
         IF(allowed_ = 1) THEN
            RETURN allowed_;
         END IF;                       
      $ELSE
         NULL; 
      $END
   END IF;  
   RETURN allowed_;      
END Print_Invoice_Allowed___;


-- Create_Ship_Invoice_Allowed___
--   Checks if an invoice can be created for a shipment.
FUNCTION Create_Ship_Invoice_Allowed___ (
   shipment_id_         IN    NUMBER,
   source_ref_type_db_  IN    VARCHAR2 ) RETURN NUMBER
IS    
   allowed_                NUMBER := 0;   
BEGIN
   IF(Shipment_API.Source_Ref_Type_Exist(source_ref_type_db_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN    
      $IF Component_Order_SYS.INSTALLED $THEN
         IF Invoice_Customer_Order_API.Is_Shipment_Invoiceable(shipment_id_) THEN
            allowed_  := 1;
            RETURN allowed_;
         END IF;                   
      $ELSE
         NULL; 
      $END
   END IF;  
   RETURN allowed_;     
END Create_Ship_Invoice_Allowed___;


FUNCTION Print_Proforma_Ivc_Allowed___ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   CURSOR get_shipment IS
      SELECT 1
      FROM shipment_tab
      WHERE shipment_id = shipment_id_ 
      AND   rowstate IN ('Completed', 'Closed');
BEGIN
   OPEN get_shipment;
   FETCH get_shipment INTO allowed_;
   IF (get_shipment%NOTFOUND) THEN
      allowed_ := 0;
   END IF;
   CLOSE get_shipment;
   RETURN allowed_;
END Print_Proforma_Ivc_Allowed___;


-- Deliver_Shipment___
--   Deliver the shipment.
PROCEDURE Deliver_Shipment___ (
   shipment_id_        IN NUMBER,
   deliver_through_cs_ IN VARCHAR2 )
IS
   info_               VARCHAR2(2000);
   parent_shipment_id_ NUMBER;
   shipment_rec_       Shipment_API.Public_Rec;
BEGIN
   shipment_rec_       := Shipment_API.Get(shipment_id_);
   parent_shipment_id_ := shipment_rec_.parent_consol_shipment_id;
   
   IF (deliver_through_cs_ = 'FALSE') AND (parent_shipment_id_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DELIVERYNOTALLOWED: Shipment :P1 must be delivered via the consolidated shipment :P2.', shipment_id_, parent_shipment_id_);
   END IF;
   
   IF shipment_rec_.approve_before_delivery = 'FALSE' THEN
      Shipment_Delivery_Utility_API.Deliver_Shipment(shipment_id_);
   ELSE
      IF (Transaction_SYS.Is_Session_Deferred) THEN         
         info_ := Language_SYS.Translate_Constant(lu_name_, 'SHIPMENTAPPROVE: The shipment(s) should have been approved to be delivered.');
         Transaction_SYS.Set_Status_Info(info_);
      ELSE
         Error_SYS.Appl_General(lu_name_,'SHIPMENTAPPROVE: The shipment(s) should have been approved to be delivered.');
      END IF;
   END IF;   
   
END Deliver_Shipment___;


-- Get_Next_Event___
--   Return the next event to execute in the shipment process
FUNCTION Get_Next_Event___ (
   event_ IN VARCHAR2 ) RETURN NUMBER
IS
   next_event_ NUMBER;
BEGIN
   next_event_ := CASE event_
      WHEN 10 THEN 20
      WHEN 20 THEN 30
      WHEN 30 THEN 40
      WHEN 40 THEN 50
      WHEN 50 THEN 70
      WHEN 70 THEN 60
      WHEN 60 THEN 80
      ELSE NULL
   END;

   RETURN next_event_;
END Get_Next_Event___;


-- Print_Shipment_Doc___
--   Include the logic to send a print job to report archive given report id
--   and related report parameter list.
PROCEDURE Print_Shipment_Doc___ (
   report_id_            IN VARCHAR2,
   shipment_id_          IN NUMBER,
   handling_unit_id_     IN NUMBER,
   no_of_shipment_labels IN NUMBER  )
IS
   report_attr_     VARCHAR2(2000);
   parameter_attr_  VARCHAR2(2000);
   result_key_      NUMBER;
   printer_id_      VARCHAR2(100);
   print_job_id_    NUMBER;    
   result_key_app_  NUMBER;
   attr_            VARCHAR2(2000);
BEGIN
   -- Retrive default printer
   Client_SYS.Clear_Attr(report_attr_);
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, report_id_);
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, report_attr_);
   Print_Job_API.New(print_job_id_, report_attr_);

   IF (report_id_ != 'SHPMNT_HANDL_UNIT_LABEL_REP') THEN     
      Client_SYS.Clear_Attr(report_attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', report_id_, report_attr_);   
      Client_SYS.Clear_Attr(parameter_attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, parameter_attr_);
      IF (handling_unit_id_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, parameter_attr_);
      END IF;         
      Archive_API.New_Instance(result_key_, report_attr_, parameter_attr_);

      -- Add the report to the print job
      Client_SYS.Clear_Attr(report_attr_);
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, report_attr_);
      Client_SYS.Add_To_Attr('RESULT_KEY',   result_key_,   report_attr_);
      Client_SYS.Add_To_Attr('OPTIONS',      'COPIES(1)',   report_attr_);
      Client_SYS.Add_To_Attr('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout(report_id_), report_attr_);
      Print_Job_Contents_API.New_Instance(report_attr_);
   ELSE
      IF no_of_shipment_labels IS NOT NULL THEN
         FOR i_ IN 1 .. no_of_shipment_labels LOOP          
            Client_SYS.Clear_Attr(report_attr_);
            Client_SYS.Add_To_Attr('REPORT_ID', report_id_, report_attr_);   
            Client_SYS.Clear_Attr(parameter_attr_);
            Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, parameter_attr_);
            IF (handling_unit_id_ IS NOT NULL) THEN
               Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, parameter_attr_);
            END IF;         
            Archive_API.New_Instance(result_key_app_, report_attr_, parameter_attr_);

            -- Add the report to the print job    
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);     
            Client_SYS.Set_Item_Value('RESULT_KEY',   result_key_app_,   attr_);
            Client_SYS.Add_To_Attr('OPTIONS', 'COPIES(1)', attr_);
            Client_SYS.Add_To_Attr('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout(report_id_), attr_);
            Print_Job_Contents_API.New_Instance(attr_);
         END LOOP;
      END IF;
   END IF;
   Printing_Print_Jobs___(print_job_id_);
END Print_Shipment_Doc___;


-- Print_Handl_Unit_Label_Doc___
PROCEDURE Print_Handl_Unit_Label_Doc___ (
   handling_unit_id_           IN NUMBER,
   no_of_handling_unit_labels_ IN NUMBER  )
IS
   report_attr_     VARCHAR2(2000);
   parameter_attr_  VARCHAR2(2000);
   result_key_      NUMBER;
   printer_id_      VARCHAR2(100);
   print_job_id_    NUMBER;    
   result_key_app_  NUMBER;
   attr_            VARCHAR2(2000);
BEGIN
   -- Retrive default printer
   Client_SYS.Clear_Attr(report_attr_);
   printer_id_ := Printer_Connection_API.Get_Default_Printer(Fnd_Session_API.Get_Fnd_User, 'HANDLING_UNIT_LABEL_REP');
   Client_SYS.Add_To_Attr('PRINTER_ID', printer_id_, report_attr_);
   Print_Job_API.New(print_job_id_, report_attr_);
   IF no_of_handling_unit_labels_ IS NOT NULL THEN
      FOR i_ IN 1 .. no_of_handling_unit_labels_ LOOP          
         Client_SYS.Clear_Attr(report_attr_);
         Client_SYS.Add_To_Attr('REPORT_ID', 'HANDLING_UNIT_LABEL_REP', report_attr_);   
         Client_SYS.Clear_Attr(parameter_attr_);
         Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, parameter_attr_);
         Archive_API.New_Instance(result_key_app_, report_attr_, parameter_attr_);

         -- Add the report to the print job    
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, attr_);     
         Client_SYS.Set_Item_Value('RESULT_KEY',   result_key_app_,   attr_);
         Client_SYS.Add_To_Attr('OPTIONS', 'COPIES(1)', attr_);
         Client_SYS.Add_To_Attr('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout('HANDLING_UNIT_LABEL_REP'), attr_);
         Print_Job_Contents_API.New_Instance(attr_);
      END LOOP;
   END IF;

   Printing_Print_Jobs___(print_job_id_);
END Print_Handl_Unit_Label_Doc___;


PROCEDURE Printing_Print_Jobs___ (
   print_job_id_ IN NUMBER )
IS
   printer_id_list_ VARCHAR2(32000);
BEGIN
   -- Send the print job to the printer.
   Logical_Printer_API.Enumerate_Printer_Id(printer_id_list_);
   IF (printer_id_list_ IS NOT NULL) THEN
      IF (print_job_id_ IS NOT NULL) THEN
         Print_Job_API.Print(print_job_id_);
      END IF;
   END IF;
END Printing_Print_Jobs___;


-- Print_Consignment_Note___
--   Include the logic to execute the Print Consignment Note optional event.
PROCEDURE Print_Consignment_Note___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   Print_Shipment_Doc___('SHIPMENT_HANDLING_UTILITY_REP', shipment_id_, NULL, NULL); 
   IF (Shipment_API.Contains_Dangerous_Goods(shipment_id_) = 'TRUE') THEN
      Print_Goods_Declaration___(shipment_id_);
   END IF;   
END Print_Consignment_Note___;


-- Print_Bill_Of_Lading___
--   Include the logic to execute the Print Bill of Lading optional event.
PROCEDURE Print_Bill_Of_Lading___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   Print_Shipment_Doc___('SHIPMENT_BILL_OF_LADING_REP', shipment_id_, NULL, NULL); 
   IF (Shipment_API.Contains_Dangerous_Goods(shipment_id_) = 'TRUE') THEN
      Print_Goods_Declaration___(shipment_id_);
   END IF;   
END Print_Bill_Of_Lading___;


-- Print_Address_Label___
--   Include the logic to execute the Print Address Label optional event.
PROCEDURE Print_Address_Label___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   Print_Shipment_Doc___('ADDRESS_LABEL_REP', shipment_id_, NULL, NULL);  
END Print_Address_Label___;


-- Print_Pro_Forma_Invoice___
--   Include the logic to execute the Print Pro Forma Invoice optional event.
PROCEDURE Print_Pro_Forma_Invoice___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   Print_Shipment_Doc___('SHIPMENT_PROFORMA_INVOICE_REP', shipment_id_, NULL, NULL);  
END Print_Pro_Forma_Invoice___;


-- Print_Packing_List___
--   Include the logic to execute the Print Packing List optional event.
PROCEDURE Print_Packing_List___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   Print_Shipment_Doc___('SHIPMENT_PACKING_LIST_REP', shipment_id_, NULL, NULL);  
END Print_Packing_List___;


-- Create_Sssc___
--   Include the logic to execute the Create SSCC optional event.
PROCEDURE Create_Sssc___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   IF (Shipment_API.All_Lines_Delivered__(shipment_id_) = 0) THEN
      Handling_Unit_Ship_Util_API.Create_Ssccs_For_Shipment(shipment_id_);
   END IF;
END Create_Sssc___; 


-- Print_Goods_Declaration___
--   Prints Goods Declaration report and includes it in the given print job.
PROCEDURE Print_Goods_Declaration___ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   Print_Shipment_Doc___('GOODS_DECLARATION_REP', shipment_id_, NULL, NULL);
END Print_Goods_Declaration___;


-- Print_Handling_Unit_Labels___
--   Include the logic to execute the Print Handling Unit Label optional event.
PROCEDURE Print_Handling_Unit_Labels___ (
   shipment_id_ IN NUMBER )
IS
   CURSOR get_print_label_hus IS
      SELECT handling_unit_id, no_of_handling_unit_labels
      FROM SHPMNT_HANDL_UNIT_WITH_HISTORY 
      WHERE print_label_db = Fnd_Boolean_API.DB_TRUE
        AND shipment_id = shipment_id_;

BEGIN
   IF (Shipment_API.Connected_Lines_Exist(shipment_id_) = 0) THEN
      RETURN;
   END IF;
   
   FOR rec_ IN get_print_label_hus LOOP
      Print_Handl_Unit_Label_Doc___(rec_.handling_unit_id, rec_.no_of_handling_unit_labels);
   END LOOP; 
END Print_Handling_Unit_Labels___;


-- Print_Shp_Handl_Unit_Labels___
--   Include the logic to execute the Print Shipment Handling Unit Label optional event.
PROCEDURE Print_Shp_Handl_Unit_Labels___ (
   shipment_id_ IN NUMBER )
IS
   CURSOR get_print_label_hus IS
      SELECT handling_unit_id, no_of_shipment_labels
      FROM SHPMNT_HANDL_UNIT_WITH_HISTORY 
      WHERE print_shipment_label_db = Fnd_Boolean_API.DB_TRUE
        AND shipment_id = shipment_id_;
BEGIN
   IF (Shipment_API.Connected_Lines_Exist(shipment_id_) = 0) THEN
      RETURN;
   END IF;
   
   FOR rec_ IN get_print_label_hus LOOP
      Print_Shipment_Doc___('SHPMNT_HANDL_UNIT_LABEL_REP', shipment_id_, rec_.handling_unit_id, rec_.no_of_shipment_labels);
   END LOOP;  
END Print_Shp_Handl_Unit_Labels___;

PROCEDURE Process_Shipment___(
  mandatory_event_ IN BOOLEAN,
  shipment_type_   IN VARCHAR2,
  shiment_attr_    IN VARCHAR2,
  start_event_     IN NUMBER)
IS
  description_       VARCHAR2(200);
  online_processing_ VARCHAR2(5);
BEGIN
   IF (mandatory_event_) THEN 
      online_processing_ := Shipment_Type_API.Get_Online_Processing_Db(shipment_type_);
      -- for rental transfers set the online_processing_ to TRUE to rollback the process if any errors appear
      IF (online_processing_ = db_false_ AND Client_SYS.Get_Item_Value('RENTAL_TRANSFER_DB', shiment_attr_) = db_true_) THEN
         online_processing_ := db_true_;
      END IF;   
      IF (Transaction_SYS.Is_Session_Deferred OR online_processing_ = db_true_) THEN
         -- don't start another background job when already in a background job.
         Process_Mandatory_Events__(shiment_attr_);
      ELSE
         CASE start_event_ 
            WHEN 10 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'RESERVE_SHIPMENT: Reserve Shipment');
            WHEN 20 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'CREATE_PICKLIST: Create Pick List');
            WHEN 30 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'PRINT_PICKLIST: Print Pick List');
            WHEN 40 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'REPORT_PICKING: Report Picking');
            WHEN 50 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'COMPLETE: Complete Shipment');
            WHEN 60 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'DELIVER: Deliver the Shipment');
            WHEN 70 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'CLOSE_SHIPMENT: Close Shipment');
            WHEN 80 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'CREATE_INVOICE: Create Shipment Invoice');
            WHEN 90 THEN
               description_ := Language_SYS.Translate_Constant(lu_name_, 'PRINT_INVOICE: Print Invoice');
            ELSE
               description_ := NULL;
            END CASE;
         Transaction_SYS.Deferred_Call('SHIPMENT_FLOW_API.Process_Mandatory_Events__', shiment_attr_, description_);
      END IF;
   ELSE
      Process_Nonmandatory_Events___(shiment_attr_);
   END IF;
END Process_Shipment___;


-- Process_Nonmandatory_Events___
--   Process non mandatory events in one shipment.
--   The attribute string passed as a parameter should contain the parameters
--   needed for the processing.
PROCEDURE Process_Nonmandatory_Events___ (
   attr_ IN VARCHAR2 )
IS
   start_event_            NUMBER;
   ptr_                    NUMBER;
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(2000);
   shipment_id_            NUMBER; 
   error_message_          VARCHAR2(2000);
   delivery_note_no_       VARCHAR2(30);
   media_code_             VARCHAR2(30);
   show_shipment_id_       VARCHAR2(5);
BEGIN
   @ApproveTransactionStatement(2012-08-09,MaEelk)
   SAVEPOINT event_processed;
   
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'START_EVENT') THEN
         start_event_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SHIPMENT_ID') THEN
         shipment_id_ := value_;
      ELSIF (name_ = 'DELIVERY_NOTE_NO') THEN
         delivery_note_no_ :=  value_;
      ELSIF (name_ = 'MEDIA_CODE') THEN
         media_code_ := value_;
      ELSIF (name_ = 'SHOW_SHIPMENT_ID') THEN
         show_shipment_id_ := value_;         
      END IF;
   END LOOP;
   
   CASE start_event_ 
      WHEN 1000 THEN
         Shipment_API.Re_Open(shipment_id_);
      WHEN 1100 THEN
         Shipment_API.Cancel_Shipment__(shipment_id_);      
      WHEN 1200 THEN
         Pack_Acc_To_Packing_Instr(shipment_id_); 
      WHEN 1250 THEN
         Pack_Acc_To_HU_Capacity(shipment_id_); 
      WHEN 1260 THEN
         Shipment_Auto_Packing_Util_API.Pack_Acc_Pack_Proposal(shipment_id_);    
      WHEN 1300 THEN
         Dispatch_Advice_Utility_API.Send_Dispatch_Advice(delivery_note_no_, media_code_);             
      ELSE
         NULL;
   END CASE;        
   @ApproveTransactionStatement(2014-12-16,jelise)
   COMMIT;   
EXCEPTION
   WHEN others THEN
      error_message_ := sqlerrm;
      -- Rollback to the last savepoint
      @ApproveTransactionStatement(2012-08-09,MaEelk)
      ROLLBACK to event_processed;
      -- Raise the error
      RAISE;
END Process_Nonmandatory_Events___;


PROCEDURE Fetch_Consl_Source_Ref_Type___ (
   source_ref_types_    IN OUT   VARCHAR2,
   source_ref_type_db_  IN       VARCHAR2)
IS
   source_ref_type_list_      Utility_SYS.STRING_TABLE;
   num_sources_               NUMBER; 
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_types_ IS NULL) THEN
         source_ref_types_ := '^' ||source_ref_type_list_(i_)||'^' ;
      ELSIF( source_ref_types_ NOT LIKE '%^'||source_ref_type_list_(i_)||'^%') THEN
         source_ref_types_ := source_ref_types_ ||source_ref_type_list_(i_)||Client_SYS.text_separator_ ;
      END IF;                       
   END LOOP;   
END Fetch_Consl_Source_Ref_Type___;


-- Shipment_Processing_Error
--   Generate an event server event when an error has occured while
--   processing a shipment.
PROCEDURE Shipment_Processing_Error___ (
   shipment_id_   IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   msg_          VARCHAR2(2000);
   fnd_user_     VARCHAR2(30);
   bill_addr_no_ VARCHAR2(50);
   shipment_rec_ SHIPMENT_API.Public_Rec;
BEGIN

   IF (Event_SYS.Event_Enabled('Shipment', 'SHIPMENT_PROCESSING_ERROR')) THEN
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      msg_ := Message_SYS.Construct('SHIPMENT_PROCESSING_ERROR');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(shipment_rec_.contract));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Primary key for object
      Message_SYS.Add_Attribute( msg_, 'SHIPMENT_ID', shipment_id_);

      -- Other important information
      Message_SYS.Add_Attribute( msg_, 'ERROR_MESSAGE', error_message_);
      
      bill_addr_no_ := Shipment_Source_Utility_API.Get_Document_Address(shipment_rec_.receiver_id, shipment_rec_.receiver_type);

      Message_SYS.Add_Attribute( msg_, 'RECEIVER_ID', shipment_rec_.receiver_id);
      Message_SYS.Add_Attribute( msg_, 'RECEIVER_NAME', Shipment_Source_Utility_API.Get_Receiver_Name(shipment_rec_.receiver_id, shipment_rec_.receiver_type));
      Message_SYS.Add_Attribute( msg_, 'CONTRACT', shipment_rec_.contract);
      Message_SYS.Add_Attribute( msg_, 'RECEIVER_DEF_EMAIL', Shipment_Source_Utility_API.Get_Receiver_E_Mail(shipment_rec_.receiver_id, bill_addr_no_, shipment_rec_.receiver_type));
      Message_SYS.Add_Attribute( msg_, 'RECEIVER_DEF_FAXNO', Comm_Method_API.Get_Default_Value('CUSTOMER', shipment_rec_.receiver_id, 'FAX'));
      Message_SYS.Add_Attribute( msg_, 'FORWARD_AGENT_ID', shipment_rec_.forward_agent_id);

      Event_SYS.Event_Execute('Shipment', 'SHIPMENT_PROCESSING_ERROR', msg_);
   END IF;
END Shipment_Processing_Error___;


-- Make_Shipment_Invoice___
--   Create Shipment invoice.
FUNCTION Make_Shipment_Invoice___ (
   shipment_id_         IN    NUMBER,
   source_ref_type_db_  IN    VARCHAR2 ) RETURN NUMBER
IS      
   dummy_attr_             VARCHAR2(2000):= NULL;
   invoice_id_             NUMBER;
BEGIN
   IF(Shipment_API.Source_Ref_Type_Exist(source_ref_type_db_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN    
      $IF Component_Order_SYS.INSTALLED $THEN
         Invoice_Customer_Order_API.Make_Shipment_Invoice__(invoice_id_, dummy_attr_, shipment_id_);      
      $ELSE
         NULL; 
      $END
   END IF;            
   RETURN invoice_id_;  
END Make_Shipment_Invoice___;


PROCEDURE Print_Invoice___ (
   shipment_id_         IN NUMBER,
   invoice_id_          IN NUMBER,
   company_             IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS    
BEGIN
   IF(Shipment_API.Source_Ref_Type_Exist(source_ref_type_db_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN    
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Print_Invoice(shipment_id_, invoice_id_, company_);          
      $ELSE
         NULL; 
      $END
   END IF;                 
END Print_Invoice___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Checks if a given operation id is allowed for shipment
@UncheckedAccess
FUNCTION Shipment_Operation_Allowed__ (
   shipment_id_   IN NUMBER,
   operation_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   return_value_           BOOLEAN;
   shipment_category_db_   VARCHAR2(20);
BEGIN
   shipment_category_db_ := Shipment_API.Get_Shipment_Category_Db(shipment_id_);
   CASE operation_id_
      WHEN '0' THEN
         return_value_ := (Reserve_Shipment_Allowed__(shipment_id_, 0)  = 1); 
      WHEN '1' THEN 
            return_value_ := (Pick_Report_Shipment_Allowed__(shipment_id_) = 1) AND (shipment_category_db_ = shipment_category_API.DB_NORMAL);
      WHEN '2' THEN
         return_value_ := (Deliver_Shipment_Allowed__(shipment_id_) = 1);
      WHEN '3' THEN
         return_value_ := (Shipment_API.Complete_Shipment_Allowed__(shipment_id_) = 1);
      WHEN '4' THEN
         return_value_ := (Shipment_API.Reopen_Shipment_Allowed__(shipment_id_) = 1);
      WHEN '5' THEN
         return_value_ := (Shipment_API.Close_Shipment_Allowed__(shipment_id_) = 1);
      WHEN '6' THEN
         return_value_ := (Create_Pick_List_Allowed__(shipment_id_) = 1);
         --return_value_ := (Create_Pick_List_Allowed__(shipment_id_) = 1) AND Shipment_API.Get_State(shipment_id_) != 'Completed' ;
      WHEN '7' THEN
         return_value_ := (Print_Pick_List_Allowed__(shipment_id_) = 1);
      WHEN '8' THEN 
         return_value_ := (Shipment_API.Cancel_Shipment_Allowed__(shipment_id_) = 1);
      WHEN '9' THEN 
         return_value_ := (Print_Proforma_Ivc_Allowed__(shipment_id_) = 1);
      WHEN 'R' THEN
         return_value_ := (Pick_Report_Shipment_Allowed__(shipment_id_, 'TRUE') = 1) AND (shipment_category_db_ = shipment_category_API.DB_NORMAL);
      WHEN '15' THEN
         return_value_ := (Shipment_API.Undo_Shipment_Allowed(shipment_id_) = TRUE);   
      ELSE
         return_value_ := FALSE;
      END CASE;

      IF return_value_ THEN 
         RETURN Fnd_Boolean_API.DB_TRUE;
      ELSE 
         RETURN Fnd_Boolean_API.DB_FALSE;
      END IF;
END Shipment_Operation_Allowed__;


@UncheckedAccess
FUNCTION Get_Next_Mandatory_Events__ (
   shipment_id_ IN NUMBER ) RETURN Event_Tab
IS 
   event_tab_            Event_Tab;
   sorted_event_tab_     Event_Tab;
   shipment_rec_         Shipment_API.Public_Rec;
   shipment_category_    VARCHAR2(50);
   status_               VARCHAR2(50);
   allowed_operations_   VARCHAR2(20);
   allowed_operation_    VARCHAR2(2);
   index_                NUMBER := 0;
   
   CURSOR Events IS
      SELECT event, description 
      FROM TABLE (event_tab_) 
      ORDER BY event;
BEGIN
   allowed_operations_  := Get_Allowed_Ship_Operations__(shipment_id_);
   shipment_rec_        := Shipment_API.Get(shipment_id_);
   shipment_category_   := shipment_rec_.shipment_category;
   status_              := shipment_rec_.rowstate;

   FOR position_ IN 1..8 LOOP
      allowed_operation_ := SUBSTR(allowed_operations_, position_, 1);
      IF (position_ = 2) AND (allowed_operation_ != '1') THEN
         allowed_operation_ := SUBSTR(allowed_operations_, 13, 1);
      END IF;
      IF allowed_operation_ NOT IN ('*', '4') THEN
         CASE allowed_operation_
            WHEN '0' THEN
               event_tab_(index_).event := 10;
               event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_RESERVE);
               index_ := index_ + 1;
            WHEN ('1') THEN
               IF shipment_category_ = shipment_category_API.DB_NORMAL THEN 
                  event_tab_(index_).event := 40;
                  event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_REPORT_PICKING);
                  index_ := index_ + 1;
               END IF;
            WHEN ('R') THEN
               IF shipment_category_ = shipment_category_API.DB_NORMAL THEN 
                  event_tab_(index_).event := 40;
                  event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_REPORT_PICKING);
                  index_ := index_ + 1;
               END IF;
            WHEN '2' THEN
               event_tab_(index_).event := 60;
               event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_DELIVER);
               index_ := index_ + 1;
            WHEN '3' THEN
               event_tab_(index_).event := 50;
               event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_COMPLETE);
               index_ := index_ + 1;
            WHEN '5' THEN
               event_tab_(index_).event := 70;
               event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_CLOSE);
               index_ := index_ + 1;
               WHEN '6' THEN
               IF status_ != 'Completed' THEN 
                  event_tab_(index_).event := 20;
                  event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_CREATE_PICK_LIST);
                  index_ := index_ + 1;
               END IF;
            WHEN '7' THEN
               event_tab_(index_).event := 30;
               event_tab_(index_).description := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_PRINT_PICK_LIST);
               index_ := index_ + 1;
            ELSE
               NULL;
         END CASE;
      END IF;
   END LOOP;

   -- Get sorted events from event_tab
   IF event_tab_.Count > 0 THEN 
      OPEN  Events;
      FETCH Events BULK COLLECT INTO sorted_event_tab_;
      CLOSE Events;
   END IF;
   
   RETURN sorted_event_tab_;
END Get_Next_Mandatory_Events__;


-- Lock_Shipment__
--   Lock the specified shipment while it is beeing processed.
PROCEDURE Lock_Shipment__ (
   shipment_id_ IN NUMBER )
IS
BEGIN
   -- Lock the order while it is being processed
   Shipment_API.Lock_By_Keys__(shipment_id_);
END Lock_Shipment__;


-- Get_Allowed_Ship_Operations__
--   Returns a string used to determine which operations should be allowed
--   for the specified shipment.
@UncheckedAccess
FUNCTION Get_Allowed_Ship_Operations__ (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   operations_ VARCHAR2(20) := NULL;
BEGIN
   -- Plan picking
   IF (Reserve_Shipment_Allowed__(shipment_id_, 0)  = 1) THEN
      operations_ := operations_ || '0';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Report picking
   IF (Pick_Report_Shipment_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '1';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Deliver shipment
   IF (Deliver_Shipment_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '2';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Complete shipment
   IF (Shipment_API.Complete_Shipment_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '3';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Reopen shipment
   IF (Shipment_API.Reopen_Shipment_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '4';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Close shipment
   IF (Shipment_API.Close_Shipment_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '5';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Create Pick List
   IF (Create_Pick_List_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '6';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Print Pick List
   IF (Print_Pick_List_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '7';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Cancel Shipment
   IF (Shipment_API.Cancel_Shipment_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '8';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Print Shipment Pro Forma Invoice
   IF (Print_Proforma_Ivc_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || '9';
   ELSE
      operations_ := operations_ || '*';
   END IF;
         
   -- Pack According to Handling Unit Capacity or Pack according to Packing Instruction allowed
   IF ((Shipment_API.Pack_Acc_HU_Capacity_Allowed__(shipment_id_) = 1) OR (Shipment_API.Pack_Acc_Pack_Instr_Allowed__(shipment_id_) = 1)) THEN
      operations_ := operations_ || 'G';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Send dispatch advice
   IF (Shipment_API.Send_Disadv_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || 'S';
   ELSE
      operations_ := operations_ || '*';
   END IF;

   -- Report Picking of Customer Order Lines
   IF (Pick_Report_Shipment_Allowed__(shipment_id_, 'TRUE') = 1) THEN
      operations_ := operations_ || 'R';
   ELSE
      operations_ := operations_ || '*';
   END IF;
   
   -- Approve Shipment
   IF (Shipment_API.Approve_Shipment_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || 'P';
   ELSE
      operations_ := operations_ || '*';
   END IF;   
   
   -- Pack According to Packing Proposal allowed
   IF (Shipment_API.Pack_Acc_Pack_Prop_Allowed__(shipment_id_) = 1) THEN
      operations_ := operations_ || 'A';
   ELSE
      operations_ := operations_ || '*';
   END IF;
   
   RETURN operations_;
END Get_Allowed_Ship_Operations__;


-- Deliver_Shipment_Allowed__
--   Checks if a shipment is allowed to be delivered.
@UncheckedAccess
FUNCTION Deliver_Shipment_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;

   CURSOR get_connected_shipments IS
      SELECT shipment_id, rowstate, source_ref_type
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate IN ('Completed', 'Preliminary');
BEGIN
   IF (Shipment_API.Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      allowed_ := Deliver_Shipment_Allowed___(shipment_id_);
   ELSE     
      FOR rec_ IN get_connected_shipments LOOP
         IF (Shipment_API.Shipment_Delivered(rec_.shipment_id) = Fnd_Boolean_API.DB_FALSE) THEN                    
            IF (Deliver_Shipment_Allowed___(rec_.shipment_id) = 1) THEN
               allowed_ := 1; 
            ELSE
               allowed_ := 0;
               EXIT;
            END IF;
         END IF;
      END LOOP;
   END IF;
   RETURN allowed_;
END Deliver_Shipment_Allowed__;


-- Reserve_Shipment__
--   Starts reserving of all source lines connected to a Shipment
PROCEDURE Reserve_Shipment__ (
   shipment_id_ IN NUMBER )
IS
   contract_               VARCHAR2(5);
   row_count_              NUMBER;
   reserve_ship_tab_       Reserve_Shipment_API.Reserve_Shipment_Table;
   empty_reserve_ship_tab_ Reserve_Shipment_API.Reserve_Shipment_Table;   
   source_ref_type_db_     VARCHAR2(20) := Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER;
   old_source_ref_type_db_ VARCHAR2(20);
   shipment_rec_           Shipment_API.Public_Rec;

   CURSOR get_shipment_lines IS
      SELECT sol.source_ref1, sol.source_ref2, sol.source_ref3, sol.source_ref4, sol.inventory_part_no, sol.source_ref_type
      FROM   shipment_line_tab sol, shipment_tab s
      WHERE  s.shipment_id    = shipment_id_
      AND    sol.shipment_id  = s.shipment_id
      AND    s.rowstate       = 'Preliminary'     
      AND    (((sol.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(sol.source_ref4) <= 0)) OR
              (sol.source_ref_type NOT IN (Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)))     
      AND    ((sol.inventory_qty - sol.qty_assigned - sol.qty_to_ship - sol.qty_shipped) > 0)
      ORDER BY source_ref_type, sol.source_ref1;     
BEGIN       
   shipment_rec_  := Shipment_API.Get(shipment_id_);
   row_count_     := reserve_ship_tab_.COUNT;
   
   FOR linerec_ IN get_shipment_lines LOOP
      
      IF(reserve_ship_tab_.COUNT > 0 AND source_ref_type_db_ != linerec_.source_ref_type) THEN
         Reserve_Shipment_API.Reserve(reserve_ship_tab_, shipment_id_, source_ref_type_db_, 
                                      shipment_rec_.sender_type, shipment_rec_.sender_id);
         old_source_ref_type_db_ := source_ref_type_db_;
         reserve_ship_tab_       := empty_reserve_ship_tab_;
         row_count_              := reserve_ship_tab_.COUNT;
      END IF;
      
      IF(Reserve_Shipment_API.Reserve_Line_Allowed(shipment_id_, linerec_.source_ref1, linerec_.source_ref2, 
                                                   linerec_.source_ref3, linerec_.source_ref4, linerec_.source_ref_type) = 1) THEN        
         reserve_ship_tab_(row_count_).source_ref1       := linerec_.source_ref1;
         reserve_ship_tab_(row_count_).source_ref2       := linerec_.source_ref2;
         reserve_ship_tab_(row_count_).source_ref3       := linerec_.source_ref3;
         reserve_ship_tab_(row_count_).source_ref4       := linerec_.source_ref4;
         reserve_ship_tab_(row_count_).contract          := shipment_rec_.contract;
         reserve_ship_tab_(row_count_).inventory_part_no := linerec_.inventory_part_no;   
         row_count_                                      := row_count_ + 1;
         source_ref_type_db_                             := linerec_.source_ref_type;
      END IF;
   END LOOP;   
   
   IF(reserve_ship_tab_.COUNT > 0 AND NVL(old_source_ref_type_db_, '0') != source_ref_type_db_) THEN
      Reserve_Shipment_API.Reserve(reserve_ship_tab_, shipment_id_, source_ref_type_db_, 
                                   shipment_rec_.sender_type, shipment_rec_.sender_id);
   END IF;     
   
END Reserve_Shipment__;


-- Reserve_Shipment_Allowed__
--   Return TRUE (1) if the Plan Picking (Reserve) operation is allowed for the
--   specified  shipment
@UncheckedAccess
FUNCTION Reserve_Shipment_Allowed__ (
   shipment_id_ IN NUMBER,
   finalize_    IN NUMBER ) RETURN NUMBER
IS
   allowed_       NUMBER;
   shipment_rec_  Shipment_API.Public_Rec;
   CURSOR get_connected_shipments IS
      SELECT shipment_id, source_ref_type
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate = 'Preliminary';
BEGIN
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   IF (shipment_rec_.shipment_category = 'NORMAL') THEN
      allowed_ := Reserve_Shipment_Allowed___(shipment_id_, shipment_rec_.source_ref_type);
   ELSE
      allowed_ := 0;
      FOR rec_ IN get_connected_shipments LOOP
         IF ( Reserve_Shipment_Allowed___(rec_.shipment_id, rec_.source_ref_type) = 1) THEN
            allowed_ := 1;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN allowed_;
END Reserve_Shipment_Allowed__;


-- Create_Pick_List_Allowed__
--   Checks if a pick list can be created for a shipment.
@UncheckedAccess
FUNCTION Create_Pick_List_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_   NUMBER;
   CURSOR get_connected_shipments IS
      SELECT shipment_id, source_ref_type
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate = 'Preliminary';
BEGIN
   IF (Shipment_API.Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      allowed_ := Pick_Shipment_API.Pick_Event_Allowed(shipment_id_, 20, 'FALSE');
   ELSE
      allowed_ := 0;
      FOR rec_ IN get_connected_shipments LOOP
         IF (Pick_Shipment_API.Pick_Event_Allowed(rec_.shipment_id, 20, 'FALSE') = 1) THEN
            allowed_ := 1;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN allowed_;
END Create_Pick_List_Allowed__;

   
-- Print_Pick_List_Allowed__
--   Check if the Pick List for the shipment can be printed.
@UncheckedAccess
FUNCTION Print_Pick_List_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;   
   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate != 'Cancelled';   
BEGIN
   IF (Shipment_API.Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      allowed_ := Pick_Shipment_API.Pick_Event_Allowed(shipment_id_, 30, 'FALSE');
   ELSE    
      FOR rec_ IN get_connected_shipments LOOP
         IF (Pick_Shipment_API.Pick_Event_Allowed(rec_.shipment_id, 30, 'FALSE') = 1) THEN   
            allowed_ := 1;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN allowed_;
END Print_Pick_List_Allowed__;


-- Pick_Report_Shipment_Allowed__
--   Return TRUE (1) if the Report Picking operation is allowed for the
--   specified  shipment
@UncheckedAccess
FUNCTION Pick_Report_Shipment_Allowed__ (
   shipment_id_                     IN NUMBER,
   report_pick_from_source_lines_   IN VARCHAR2 DEFAULT 'FALSE' ) RETURN NUMBER
IS
   allowed_       NUMBER := 0;
   shipment_rec_  Shipment_API.Public_Rec;
   CURSOR get_connected_shipments IS
      SELECT shipment_id, source_ref_type
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate = 'Preliminary'; 
BEGIN
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   IF (shipment_rec_.shipment_category = 'NORMAL') THEN      
      allowed_ := Pick_Shipment_API.Pick_Report_Allowed(shipment_id_, shipment_rec_.source_ref_type, report_pick_from_source_lines_);      
   ELSE    
      FOR rec_ IN get_connected_shipments LOOP          
         allowed_ := Pick_Shipment_API.Pick_Report_Allowed(rec_.shipment_id, rec_.source_ref_type, report_pick_from_source_lines_);           
         IF (allowed_ = 1) THEN
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN allowed_;
END Pick_Report_Shipment_Allowed__;    


-- Print_Delivery_Note_Allowed__
--   Check if the delivery Note for the shipment can be printed.
-- TO_DO_LIME: Revisit this when delivery note made generic
@UncheckedAccess
FUNCTION Print_Delivery_Note_Allowed__ (
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER
IS  
   allowed_                NUMBER := 0;     
BEGIN   
   allowed_ := Delivery_Note_API.Print_Delivery_Note_Allowed(shipment_id_);
   IF(allowed_ = 1) THEN
      RETURN allowed_;               
   END IF;        
   RETURN allowed_;
END Print_Delivery_Note_Allowed__;


-- Print_Proforma_Ivc_Allowed__
--   Check if the proforma invoice for the shipment can be printed.
@UncheckedAccess
FUNCTION Print_Proforma_Ivc_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM shipment_tab
      WHERE parent_consol_shipment_id = shipment_id_
      AND   rowstate IN ('Completed','Closed'); 
BEGIN
   IF (Shipment_API.Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      IF (Print_Proforma_Ivc_Allowed___(shipment_id_) = 1) THEN
         allowed_ := 1;
      END IF;
   ELSE
      allowed_ := 0;    
      FOR rec_ IN get_connected_shipments LOOP
         IF (Print_Proforma_Ivc_Allowed___(rec_.shipment_id) = 1) THEN
            allowed_ := 1;
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN allowed_;
END Print_Proforma_Ivc_Allowed__;


-- Print_Shipment_Delivery_Note__
--   Print the Delivery Note for the shipment.
PROCEDURE Print_Shipment_Delivery_Note__ (
   shipment_id_         IN  NUMBER,
   source_ref_type_db_  IN  VARCHAR2)
IS
   delnote_no_           VARCHAR2(15);    
   print_job_id_         NUMBER;
   parameter_attr_       VARCHAR2(32000);      
   no_of_delnote_copies_ NUMBER;
   customer_no_          VARCHAR2(50);
   alt_delnote_no_       VARCHAR2(50);
   result_               NUMBER;
    
   CURSOR get_delivery_note IS
      SELECT delnote_no, alt_delnote_no
      FROM   delivery_note_tab
      WHERE  shipment_id = shipment_id_ 
      AND    rowstate != 'Invalid'; 
   
   CURSOR get_customer_no IS
      SELECT receiver_id 
      FROM   shipment_tab
      WHERE  shipment_id = shipment_id_;
BEGIN
   OPEN  get_customer_no;
   FETCH get_customer_no INTO customer_no_;
   CLOSE get_customer_no;
        
   OPEN  get_delivery_note;
   FETCH get_delivery_note INTO delnote_no_, alt_delnote_no_;
   CLOSE get_delivery_note;
   IF (delnote_no_ IS NULL) THEN
      Create_Delivery_Note_API.Create_Shipment_Deliv_Note(delnote_no_, shipment_id_);
   END IF;
   $IF Component_Order_SYS.INSTALLED $THEN
      no_of_delnote_copies_ := NVL(Cust_Ord_Customer_API.Get_No_Delnote_Copies(customer_no_), 0);  

      FOR delnote_copy_no_ IN 0..no_of_delnote_copies_ LOOP
         Client_SYS.Clear_Attr(parameter_attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID' ,    shipment_id_,     parameter_attr_);
         Client_SYS.Add_To_Attr('DELNOTE_NO' ,     delnote_no_,      parameter_attr_);
         Client_SYS.Add_To_Attr('DELNOTE_COPY_NO', delnote_copy_no_, parameter_attr_);
         Client_SYS.Add_To_Attr('ALT_DELIV_NOTE',  alt_delnote_no_,  parameter_attr_);     
         -- Create one print job for original report and attach print job instances to same print job if there are no of copies 
         result_ := NULL;
         Customer_Order_Flow_API.Create_Print_Jobs(print_job_id_, result_, 'SHIPMENT_DELIVERY_NOTE_REP', parameter_attr_);
      END LOOP;    
   $END
     
   -- Only one job will be created for a particular report. So this method will be called per print job.
   Printing_Print_Jobs___(print_job_id_);
END Print_Shipment_Delivery_Note__;


-- Get_Pick_Lists_For_Shipment__
--   Returns unpicked pick lists for a shipment.
@UncheckedAccess
FUNCTION Get_Pick_Lists_For_Shipment__ (
   shipment_id_  IN NUMBER,
   printed_flag_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pick_list_no_list_   VARCHAR2(32000) := NULL;
   shipment_rec_        Shipment_API.Public_Rec;
   CURSOR get_connected_shipments IS
      SELECT shipment_id, source_ref_type
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate = 'Preliminary';
BEGIN   
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   IF (shipment_rec_.shipment_category = 'NORMAL') THEN
      pick_list_no_list_ := Pick_Shipment_API.Get_Pick_Lists_For_Shipment(shipment_id_, printed_flag_, shipment_rec_.source_ref_type);     
   ELSE      
      FOR rec_ IN get_connected_shipments LOOP
         IF (Pick_Report_Shipment_Allowed__(rec_.shipment_id) = 1) THEN
            pick_list_no_list_ := pick_list_no_list_ || Pick_Shipment_API.Get_Pick_Lists_For_Shipment(rec_.shipment_id, printed_flag_, rec_.source_ref_type) ||Client_SYS.field_separator_;      
         END IF;
      END LOOP;
   END IF;
   RETURN pick_list_no_list_;
END Get_Pick_Lists_For_Shipment__;


-- Create_Shipment_Pick_Lists__
--   Create pick list for the shipment.
PROCEDURE Create_Shipment_Pick_Lists__ (
   shipment_id_ IN NUMBER )
IS   
BEGIN
   Lock_Shipment__(shipment_id_);
   IF (Create_Pick_List_Allowed__(shipment_id_) = 1) THEN
      -- Checks whether there is a mismatch between the configurations in the customer order
      Check_Line_Config_Mismatch___(shipment_id_);
      Shipment_Source_Utility_API.Create_Shipment_Pick_Lists(shipment_id_,Shipment_API.Get_Source_Ref_Type_Db(shipment_id_));
   END IF;   
END Create_Shipment_Pick_Lists__;

-- Check_Line_Config_Mismatch__
--  Checks whether there is a mismatch between the configurations in the customer order
PROCEDURE Check_Line_Config_Mismatch___ (
   shipment_id_ IN NUMBER )
IS
   err_text_1_  VARCHAR2(2000);
   err_text_2_  VARCHAR2(2000);
   
   CURSOR get_shipment_orders IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4 
      FROM SHIPMENT_LINE_TAB
      WHERE shipment_id = shipment_id_;
BEGIN
   FOR order_rec_ IN get_shipment_orders LOOP
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (Order_Config_Util_API.Check_Ord_Line_Config_Mismatch(order_rec_.source_ref1, order_rec_.source_ref2, order_rec_.source_ref3, order_rec_.source_ref4) = 'TRUE') THEN
            err_text_1_ := Language_SYS.Translate_Constant (lu_name_,
                                                            'CONFIGMISMATCH1: Pick list creation is not allowed since supply site configuration is different from the demand site configuration in a connected source object. Source references 1-4 are as follows: :P1, :P2, :P3',
                                                            NULL,
                                                            order_rec_.source_ref1, order_rec_.source_ref2, order_rec_.source_ref3 );
            err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                            'CONFIGMISMATCH2: , :P1',
                                                            NULL,
                                                            order_rec_.source_ref4);
            Error_SYS.Record_General(lu_name_, 'CONFIGMISMATCH: :P1 :P2', err_text_1_, err_text_2_);
         END IF;
      $ELSE
         NULL;
      $END
   END LOOP;
END Check_Line_Config_Mismatch___;

-- Process_Mandatory_Events__
--   Process mandatory events in one shipment.
--   The attribute string passed as a parameter should contain the parameters
--   needed for the processing.
PROCEDURE Process_Mandatory_Events__ (
   attr_ IN VARCHAR2 )
IS
   start_event_          NUMBER;
   next_event_           NUMBER;
   ptr_                  NUMBER;
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   shipment_id_          NUMBER; 
   shipment_type_        SHIPMENT_TYPE_TAB.shipment_type%TYPE;   
   error_message_        VARCHAR2(2000);
   info_                 VARCHAR2(2000);
   location_no_          VARCHAR2(35);
   invoice_id_           NUMBER;   
   shipment_rec_         Shipment_API.Public_Rec;
   company_              VARCHAR2(20);      
   deliver_through_cs_   VARCHAR2(5) := 'FALSE';   
   blocked_sources_exist_ BOOLEAN := FALSE;
   blocked_sources_found_ EXCEPTION;
   rental_transfer_db_   VARCHAR2(5) := db_false_;
      
BEGIN
   @ApproveTransactionStatement(2012-07-04,MaEelk)
   SAVEPOINT event_processed;
   
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'START_EVENT') THEN
         start_event_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SHIPMENT_ID') THEN
         shipment_id_ := value_;
      ELSIF (name_ = 'SHIPMENT_TYPE') THEN
         shipment_type_ := value_;
      ELSIF (name_ = 'LOCATION_NO') THEN   
         location_no_ := value_;  
      ELSIF (name_ = 'DELIVER_THROUGH_CS') THEN
         deliver_through_cs_ := value_;
      ELSIF (name_ = 'RENTAL_TRANSFER_DB') THEN
         rental_transfer_db_ := value_;      
      END IF;
   END LOOP;
   
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   company_      := Site_API.Get_Company(shipment_rec_.contract);
   
   next_event_ := start_event_;
   WHILE (next_event_ IS NOT NULL ) LOOP
      -- Lock the current shipment for processing
      -- The order needs to be relocked before each step because each step ends with a COMMIT
      Lock_Shipment__(shipment_id_);
      
      -- If the next step is to reserve the shipment
      IF (next_event_ = 10) THEN
         IF (Reserve_Shipment_Allowed__(shipment_id_, 1) = 1) THEN
            Reserve_Shipment__(shipment_id_);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Shipment_API.Blocked_Sources_Exist(blocked_sources_exist_, shipment_id_, 'RESERVE');
            IF (blocked_sources_exist_) THEN
               RAISE blocked_sources_found_;
            END IF;
            Process_Optional_Events(shipment_id_, shipment_type_, 10);
         END IF;
      -- If the next step is to create the pick list         
      ELSIF (next_event_ = 20) THEN
         IF (Create_Pick_List_Allowed__(shipment_id_) = 1) THEN
            Check_Line_Config_Mismatch___(shipment_id_);
            Pick_Shipment_API.Execute_Pick_Event(shipment_id_, 20, NULL);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Shipment_API.Blocked_Sources_Exist(blocked_sources_exist_, shipment_id_, 'CREATE_PICKLIST');
            IF (blocked_sources_exist_) THEN
               RAISE blocked_sources_found_;
            END IF;
            Process_Optional_Events(shipment_id_, shipment_type_, 20);
         END IF;
      -- If the next step is to print the pick list                  
      ELSIF (next_event_ = 30) THEN
         IF (Print_Pick_List_Allowed__(shipment_id_) = 1) THEN
            Pick_Shipment_API.Execute_Pick_Event(shipment_id_, 30, NULL);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Process_Optional_Events(shipment_id_, shipment_type_, 30);
         END IF;
      -- If the next step is report picking
      ELSIF (next_event_ = 40) THEN
         IF (Pick_Report_Shipment_Allowed__(shipment_id_) = 1) THEN            
            Pick_Shipment_API.Execute_Pick_Event(shipment_id_, 40, location_no_);                      
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Process_Optional_Events(shipment_id_, shipment_type_, 40);
         END IF;
      -- If the next step is to complete the shipment
      ELSIF (next_event_ = 50) THEN
         IF (Shipment_API.Complete_Shipment_Allowed__(shipment_id_) = 1) THEN
            Shipment_API.Complete_Shipment__(shipment_id_);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Process_Optional_Events(shipment_id_, shipment_type_, 50);
         END IF;
      -- If the next step is to deliver the shipment         
      ELSIF (next_event_ = 60) THEN
         IF (Deliver_Shipment_Allowed__(shipment_id_) = 1) THEN
            Deliver_Shipment___(shipment_id_, deliver_through_cs_);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Shipment_API.Blocked_Sources_Exist(blocked_sources_exist_, shipment_id_, 'DELIVER');
            IF (blocked_sources_exist_) THEN
               RAISE blocked_sources_found_;
            END IF;
            Process_Optional_Events(shipment_id_, shipment_type_, 60);
         END IF;
      -- If the next step is to close the shipment
      ELSIF (next_event_ = 70) THEN
         IF (Shipment_API.Close_Shipment_Allowed__(shipment_id_) = 1) THEN
            Shipment_API.Close(shipment_id_);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Process_Optional_Events(shipment_id_, shipment_type_, 70);
         END IF;
      -- If the next step is to create the invoice
      ELSIF (next_event_ = 80) THEN
         IF (Create_Ship_Invoice_Allowed___(shipment_id_, shipment_rec_.source_ref_type) = 1) THEN             
            invoice_id_ := Make_Shipment_Invoice___(shipment_id_, shipment_rec_.source_ref_type);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Process_Optional_Events(shipment_id_, shipment_type_, 80);
         END IF;         
      -- If the next step is to print the invoice
      ELSIF (next_event_ = 90) THEN
         IF ((invoice_id_ IS NOT NULL) AND (Print_Invoice_Allowed___(shipment_id_, shipment_rec_.source_ref_type) = 1)) THEN                                 
            Print_Invoice___(shipment_id_, invoice_id_, company_, shipment_rec_.source_ref_type);
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
            Process_Optional_Events(shipment_id_, shipment_type_, 90);
         END IF;
      END IF;
      -- Commit changes made so far to avoid long transactions for fast order types
      @ApproveTransactionStatement(2012-07-04,MaEelk)
      COMMIT;
      -- Set before processing next event
      @ApproveTransactionStatement(2012-07-04,MaEelk)
      SAVEPOINT event_processed;

      next_event_ := Shipment_Type_Event_Api.Get_Next_Event(shipment_type_, next_event_, rental_transfer_db_);
   END LOOP;
EXCEPTION
   WHEN blocked_sources_found_ THEN
      IF (Transaction_SYS.Is_Session_Deferred) THEN
         error_message_ :=  Language_SYS.Translate_Constant(lu_name_, 'SOURCESBLOCKED: Connected shipment source(s) in shipment :P1 are blocked.', NULL, shipment_id_);
         Transaction_SYS.Set_Status_Info(error_message_);
         Shipment_Processing_Error___(shipment_id_, error_message_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'SOURCESBLOCKED: Connected shipment source(s) in shipment :P1 are blocked.', shipment_id_);
      END IF;
   WHEN others THEN
      error_message_ := sqlerrm;
      -- Rollback to the last savepoint
      @ApproveTransactionStatement(2012-07-04,MaEelk)
      ROLLBACK to event_processed;
      IF (Transaction_SYS.Is_Session_Deferred) THEN
         -- Logg the error
         info_ := Language_SYS.Translate_Constant(lu_name_, 'SHIPMENTERROR: Shipment :P1   :P2',
                                                  NULL, shipment_id_, error_message_);
         Transaction_SYS.Set_Status_Info(info_);
         Shipment_Processing_Error___(shipment_id_, error_message_);
      ELSE
         -- Raise the error
         RAISE;
      END IF;
END Process_Mandatory_Events__;


PROCEDURE Process_All_Shipments__ (
   info_            IN OUT VARCHAR2,
   attr_            IN VARCHAR2,
   mandatory_event_ IN BOOLEAN )
IS
   start_event_               NUMBER;
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(2000);
   shiment_attr_              VARCHAR2(2000);
   shipment_type_             VARCHAR2(3);
   shipment_id_               NUMBER;   
   location_no_               VARCHAR2(35);
   allowed_operation_         BOOLEAN;     
   ascending_order_           VARCHAR2(5);
   rental_transfer_db_        VARCHAR2(5) := db_false_;
   source_ref_types_          VARCHAR2(2000);
   dummy_                     NUMBER;
   execute_shipment_flow_     BOOLEAN := FALSE;
   shipment_rec_              Shipment_API.Public_Rec;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id, shipment_type, source_ref_type, receiver_type, receiver_id
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate != 'Cancelled'
      ORDER BY DECODE(ascending_order_, 'TRUE', load_sequence_no, (load_sequence_no * -1));
      
   CURSOR check_non_deliverying_shipment IS
      SELECT 1
      FROM   shipment_tab st, shipment_type_event_tab stet
      WHERE  st.parent_consol_shipment_id = shipment_id_
      AND    st.shipment_type = stet.shipment_type
      AND    stet.event = 50
      AND    (st.rowstate != 'Preliminary' OR stet.stop_flag = 'TRUE' OR st.approve_before_delivery = 'TRUE');
BEGIN
   -- Retrieve all the shipments to be processed and process the shipments one by one
   Client_SYS.Clear_Attr(shiment_attr_);
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      -- 'END' should be the last parameter passed for each order
      IF (name_ = 'END') THEN
         shipment_rec_ := Shipment_API.Get(shipment_id_);
         IF (shipment_rec_.shipment_category = 'NORMAL') THEN
            source_ref_types_ := shipment_rec_.source_ref_type;
            IF (start_event_ = 1400) THEN
               Print_Consignment_Note___(shipment_id_);  
            ELSIF (start_event_ = 1500) THEN
               Print_Bill_Of_Lading___(shipment_id_);
            ELSIF (start_event_ = 1600) THEN
               Print_Packing_List___(shipment_id_);
            ELSIF (start_event_ = 1700) THEN
               Print_Shipment_Delivery_Note__(shipment_id_, source_ref_types_);
            ELSIF (start_event_ = 1800) THEN
               Print_Pro_Forma_Invoice___(shipment_id_);
            ELSIF (start_event_ = 1900) THEN
               Print_Address_Label___(shipment_id_); 
            ELSE
               Process_Shipment___(mandatory_event_, shipment_type_, shiment_attr_, start_event_);            
            END IF;
            Client_SYS.Clear_Attr(shiment_attr_);            
         ELSE
            IF (Shipment_API.Shipments_Connected__(shipment_id_) = 0) THEN
               IF (start_event_ = 1100) THEN
                  Shipment_API.Cancel_Shipment__(shipment_id_);
               END IF;
            ELSE
               IF (start_event_ IN (1400, 1500, 1700, 1800)) THEN
                  ascending_order_ := 'FALSE';
               ELSE
                  ascending_order_ := 'TRUE';
               END IF;
               
               OPEN  check_non_deliverying_shipment;
               FETCH check_non_deliverying_shipment INTO dummy_;
               IF (check_non_deliverying_shipment%NOTFOUND) THEN
                  execute_shipment_flow_ := TRUE;
               END IF;
               CLOSE check_non_deliverying_shipment;
               
               FOR rec_ IN get_connected_shipments LOOP
                  Client_SYS.Clear_Attr(shiment_attr_);
                  Client_SYS.Add_To_Attr('START_EVENT', start_event_, shiment_attr_); 
                  Client_SYS.Add_To_Attr('SHIPMENT_ID', rec_.shipment_id, shiment_attr_);
                  Client_SYS.Add_To_Attr('SHIPMENT_TYPE', rec_.shipment_type, shiment_attr_);
                  Client_SYS.Add_To_Attr('RENTAL_TRANSFER_DB', rental_transfer_db_, shiment_attr_);
                  allowed_operation_ := FALSE;

                  CASE start_event_
                     WHEN 10 THEN
                        allowed_operation_     := (Reserve_Shipment_Allowed__(rec_.shipment_id, 0)= 1); 
                        Client_SYS.Add_To_Attr('DELIVER_THROUGH_CS', 'TRUE', shiment_attr_);                        
                     WHEN 20 THEN
                        allowed_operation_     := (Create_Pick_List_Allowed__(rec_.shipment_id)= 1);
                        Client_SYS.Add_To_Attr('DELIVER_THROUGH_CS', 'TRUE', shiment_attr_);                        
                     WHEN 30 THEN
                        allowed_operation_     := (Print_Pick_List_Allowed__(rec_.shipment_id)= 1);
                        Client_SYS.Add_To_Attr('DELIVER_THROUGH_CS', 'TRUE', shiment_attr_);                        
                     WHEN 50 THEN
                        allowed_operation_     := (Shipment_API.Complete_Shipment_Allowed__(rec_.shipment_id)= 1);
                        IF (allowed_operation_) THEN     
                           IF (execute_shipment_flow_) THEN
                              Client_SYS.Add_To_Attr('DELIVER_THROUGH_CS', 'TRUE', shiment_attr_); 
                           END IF;        
                        END IF;
                     WHEN 60 THEN
                        allowed_operation_     := (Deliver_Shipment_Allowed__(rec_.shipment_id)= 1);
                        Client_SYS.Add_To_Attr('DELIVER_THROUGH_CS', 'TRUE', shiment_attr_); 
                     WHEN 70 THEN
                        allowed_operation_     := (Shipment_API.Close_Shipment_Allowed__(rec_.shipment_id) = 1);
                     WHEN 1000 THEN
                        allowed_operation_     := (Shipment_API.Reopen_Shipment_Allowed__(rec_.shipment_id) = 1);
                     WHEN 1100 THEN
                        allowed_operation_     := (Shipment_API.Cancel_Shipment_Allowed__(rec_.shipment_id) = 1);
                     WHEN 1200 THEN
                        allowed_operation_     := (Shipment_API.Pack_Acc_Pack_Instr_Allowed__(rec_.shipment_id) = 1);
                     WHEN 1250 THEN 
                        allowed_operation_     := (Shipment_API.Pack_Acc_HU_Capacity_Allowed__(rec_.shipment_id) = 1);
                     WHEN 1260 THEN 
                        allowed_operation_     := (Shipment_API.Pack_Acc_Pack_Prop_Allowed__(rec_.shipment_id) = 1);   
                     WHEN 1300 THEN
                        allowed_operation_     := (Shipment_API.Send_Disadv_Allowed__(rec_.shipment_id) = 1);
                        Client_SYS.Add_To_Attr('DELIVERY_NOTE_NO', Delivery_Note_API.Get_Delnote_No_For_Shipment(rec_.shipment_id), shiment_attr_);
                        Client_SYS.Add_To_Attr('MEDIA_CODE', Shipment_Source_Utility_API.Get_Default_Media_Code(rec_.receiver_id,'DESADV', rec_.receiver_type), shiment_attr_);  
                     WHEN 1400 THEN
                        Print_Consignment_Note___(rec_.shipment_id);  
                     WHEN 1500 THEN
                        Print_Bill_Of_Lading___(rec_.shipment_id);
                     WHEN 1600 THEN
                        Print_Packing_List___(rec_.shipment_id);
                     WHEN 1700 THEN
                        Print_Shipment_Delivery_Note__(rec_.shipment_id, rec_.source_ref_type);
                     WHEN 1800 THEN
                        IF (Print_Proforma_Ivc_Allowed__(rec_.shipment_id) = 1) THEN
                           Print_Pro_Forma_Invoice___(rec_.shipment_id);
                        END IF;
                     WHEN 1900 THEN
                        Print_Address_Label___(rec_.shipment_id);
                     ELSE
                        NULL;
                  END CASE;
                  IF (allowed_operation_) THEN
                     Process_Shipment___(mandatory_event_, rec_.shipment_type, shiment_attr_, start_event_);               
                  END IF;
                  Fetch_Consl_Source_Ref_Type___(source_ref_types_, rec_.source_ref_type); 
                END LOOP;            
            END IF;
         END IF;  
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, shiment_attr_);
         IF (name_ = 'START_EVENT') THEN
            start_event_ := Client_SYS.Attr_Value_To_Number(value_); 
         ELSIF (name_ = 'SHIPMENT_ID') THEN
            shipment_id_ := Client_SYS.Attr_Value_To_Number(value_);     
         ELSIF (name_ = 'SHIPMENT_TYPE') THEN
            shipment_type_ := value_;        
         ELSIF (name_ = 'LOCATION_NO') THEN
            location_no_ := value_;  
         ELSIF (name_ = 'RENTAL_TRANSFER_DB') THEN
            rental_transfer_db_ := value_;
         END IF;
      END IF;
   END LOOP;
   info_ := Shipment_Source_Utility_API.Get_Source_Current_Info(source_ref_types_); 
END Process_All_Shipments__;


-- Start_Reserve_Shipment__
--   Start reserving customer orders connected to the shipment.
PROCEDURE Start_Reserve_Shipment__ (
   info_ IN OUT VARCHAR2,
   attr_ IN     VARCHAR2 )
IS
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
   info_ := info_ || Client_SYS.Get_All_Info;   
END Start_Reserve_Shipment__;


-- Start_Create_Pick_List__
--   Start creation of pick list for the shipment.
PROCEDURE Start_Create_Pick_List__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
END Start_Create_Pick_List__;

-- Start_Create_Pick_List__
--   Start creation of pick list for the shipment.
--   Overloaded method with info_ parameter
PROCEDURE Start_Create_Pick_List__ (
   info_ IN OUT VARCHAR2,
   attr_ IN     VARCHAR2 )
IS
BEGIN
   App_Context_SYS.Set_Value('CREATE_PICK_LIST_API.EXPORT_CONTROL_INFO_', '');
   Process_All_Shipments__(info_, attr_, TRUE);
   info_ := App_Context_SYS.Get_Value('CREATE_PICK_LIST_API.EXPORT_CONTROL_INFO_');
END Start_Create_Pick_List__;

-- Start_Print_Pick_List__
--   Start printing pick list for the shipment.
PROCEDURE Start_Print_Pick_List__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
END Start_Print_Pick_List__;


-- Start_Print_Consignment_Note__
--   Start printing consignment note for the shipment.
PROCEDURE Start_Print_Consignment_Note__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Print_Consignment_Note__;


-- Start_Print_Bill_Of_Lading__
--   Start printing bill Of lading for the shipment.
PROCEDURE Start_Print_Bill_Of_Lading__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Print_Bill_Of_Lading__;


-- Start_Print_Packing_List__
--   Start printing packing list for the shipment.
PROCEDURE Start_Print_Packing_List__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Print_Packing_List__;


-- Start_Print_Address_Label__
--   Start printing address label for the shipment.
PROCEDURE Start_Print_Address_Label__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Print_Address_Label__;


-- Start_Print_Proforma_Inv__
--   Start printing proforma invoice for the shipment.
PROCEDURE Start_Print_Proforma_Inv__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Print_Proforma_Inv__;


-- Start_Print_Shipment_Delnote__
--   Start printing shipment delivery note for the shipment.
PROCEDURE Start_Print_Shipment_Delnote__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Print_Shipment_Delnote__;


-- Start_Pick_Report_Shipment__
--   Start report picking for the shipment.
PROCEDURE Start_Pick_Report_Shipment__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
END Start_Pick_Report_Shipment__;


-- Start_Complete_Shipment__
--   Start completing the shipment.
PROCEDURE Start_Complete_Shipment__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
END Start_Complete_Shipment__;


-- Start_Deliver_Shipment__
--   Start Deliver the shipment.
PROCEDURE Start_Deliver_Shipment__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
END Start_Deliver_Shipment__;


-- Start_Close_Shipment__
--   Start Closing the Shipment.
PROCEDURE Start_Close_Shipment__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
END Start_Close_Shipment__;


-- Start_Create_Ship_Invoice__
--   Start creating Shipment Invoices.
PROCEDURE Start_Create_Ship_Invoice__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, TRUE);
END Start_Create_Ship_Invoice__;


-- Start_Reopen_Shipment__
--   Start reopening the Shipment and go back to Preliminary state.
PROCEDURE Start_Reopen_Shipment__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Reopen_Shipment__;


-- Start_Cancel_Shipment__
--   Start cancelling shipment and go back to Cancel state.
PROCEDURE Start_Cancel_Shipment__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Cancel_Shipment__;


-- Start_Send_Dispatch_Advice__
--   Start send dispatch advices for a shipment set.
PROCEDURE Start_Send_Dispatch_Advice__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Send_Dispatch_Advice__; 


-- Start_Pack_Acc_HU_Capacity__
--   Start packing into lowest level handling units for a shipment set.
PROCEDURE Start_Pack_Acc_HU_Capacity__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Pack_Acc_HU_Capacity__;


-- Start_Pack_Acc_Packing_Instr__
--   Start packing according to the packing instruction added on every line for a shipment set.
PROCEDURE Start_Pack_Acc_Packing_Instr__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Pack_Acc_Packing_Instr__;


-- Start_Pack_Acc_Packing_Instr__
--   Start packing according to the packing instruction added on every line for a shipment set.
PROCEDURE Start_Pack_Acc_Pack_Proposal__ (
   attr_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   Process_All_Shipments__(info_, attr_, FALSE);
END Start_Pack_Acc_Pack_Proposal__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Start_Shipment_Flow (
   shipment_id_        IN NUMBER,
   event_no_           IN NUMBER, 
   rental_transfer_db_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.db_false)
IS   
   ship_attr_     VARCHAR2(32000);
   start_event_   VARCHAR2(10);
   rec_           Shipment_API.Public_Rec;
BEGIN
   rec_ := Shipment_API.Get(shipment_id_);    
   IF (event_no_ = 10) THEN
      Process_Optional_Events(shipment_id_, rec_.shipment_type, 10);
      @ApproveTransactionStatement(2014-08-06,mahplk)
      COMMIT;
      start_event_ := '20';     
   ELSIF (event_no_ = 20) THEN
      Process_Optional_Events(shipment_id_, rec_.shipment_type, 20);
      @ApproveTransactionStatement(2014-08-06,mahplk)
      COMMIT;
      start_event_ := '30';
   ELSIF (event_no_ = 40) THEN
      Process_Optional_Events(shipment_id_, rec_.shipment_type, 40);
      @ApproveTransactionStatement(2014-08-06,mahplk)
      COMMIT;
      start_event_ := '50';
   END IF;
   IF (Shipment_Type_Event_API.Get_Next_Event(rec_.shipment_type, event_no_, rental_transfer_db_) IS NOT NULL) THEN
      Client_SYS.Clear_Attr(ship_attr_);
      Client_SYS.Add_To_Attr('START_EVENT', start_event_, ship_attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_ID', shipment_id_, ship_attr_);
      Client_SYS.Add_To_Attr('SHIPMENT_TYPE', rec_.shipment_type, ship_attr_);
      Client_SYS.Add_To_Attr('LOCATION_NO', rec_.ship_inventory_location_no, ship_attr_);
      Client_SYS.Add_To_Attr('RENTAL_TRANSFER_DB', rental_transfer_db_, ship_attr_);
      Client_SYS.Add_To_Attr('END', '', ship_attr_);
      IF (start_event_ = 20) THEN
         Start_Create_Pick_List__(ship_attr_);
      ELSIF (start_event_ = 30) THEN
         Start_Print_Pick_List__(ship_attr_);
      ELSIF (start_event_ = 50) THEN
         IF (Shipment_API.Trigger_Complete_Ship_Allowed(shipment_id_) = 'TRUE') THEN
            Start_Complete_Shipment__(ship_attr_);
         END IF;
      END IF;
   END IF;
END Start_Shipment_Flow;

PROCEDURE Start_Shipment_Flow (
   shipment_id_msg_    IN VARCHAR2,
   event_no_           IN NUMBER, 
   rental_transfer_db_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE)
IS   
   count_       NUMBER;
   name_arr_    Message_SYS.name_table;
   value_arr_   Message_SYS.line_table;
   shipment_id_ NUMBER;
BEGIN
   Message_Sys.Get_Attributes(shipment_id_msg_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'SHIPMENT_ID') THEN
         shipment_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         IF (NVL(shipment_id_, 0) != 0) THEN
            Start_Shipment_Flow(shipment_id_        => shipment_id_, 
                                event_no_           => event_no_, 
                                rental_transfer_db_ => rental_transfer_db_);
         END IF;   
      END IF;
   END LOOP;
END Start_Shipment_Flow;


-- Process_Optional_Events
--   Process the optioanl events for a given shipment id and main event.
PROCEDURE Process_Optional_Events (
   shipment_id_   IN NUMBER,
   shipment_type_ IN VARCHAR2,
   event_         IN NUMBER )
IS
   shipment_rec_         Shipment_API.Public_Rec;
   handling_unit_exists_ BOOLEAN := FALSE;

   CURSOR get_optional_events IS
      SELECT optional_event
      FROM SHIPMENT_TYPE_OPT_EVENT_TAB 
      WHERE shipment_type = shipment_type_
      AND   event         = event_
      ORDER BY CASE 
                  WHEN optional_event = 'RELEASE_QTY_NOT_RESERVED' THEN '0'
                  WHEN optional_event = 'PACK_ACC_TO_PACKING_INSTR' THEN '1'
                  WHEN optional_event = 'PACK_ACC_TO_HU_CAPACITY' THEN '2'
                  WHEN optional_event = 'PACK_ACC_PACK_PROPOSAL' THEN '3'
                  WHEN optional_event = 'DISCONNECT_EMPTY_HUS' THEN '4'
                  WHEN optional_event = 'CREATE_SSCC' THEN '5'
                  WHEN optional_event = 'PRINT_HANDLING_UNIT_LABEL' THEN '6'
                  WHEN optional_event = 'PRINT_SHIP_HANDL_UNIT_LABEL' THEN '7'
                  WHEN optional_event = 'PRINT_PACKING_LIST' THEN '8'
                  ELSE optional_event 
               END;

   CURSOR get_top_level_hus IS
      SELECT handling_unit_id
      FROM SHPMNT_HANDL_UNIT_WITH_HISTORY 
      WHERE shipment_id = shipment_id_;
BEGIN
   @ApproveTransactionStatement(2014-12-16,jelise)
   SAVEPOINT event_processed;
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   FOR optional_event_rec_ IN get_optional_events LOOP
      IF (optional_event_rec_.optional_event = 'RELEASE_QTY_NOT_RESERVED') THEN
         Shipment_API.Release_Not_Reserved_Qty(shipment_id_);
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PACK_ACC_TO_PACKING_INSTR') THEN
         Pack_Acc_To_Packing_Instr(shipment_id_);
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT; 
      ELSIF (optional_event_rec_.optional_event = 'PACK_ACC_TO_HU_CAPACITY') THEN
         Pack_Acc_To_HU_Capacity(shipment_id_);
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT; 
      ELSIF (optional_event_rec_.optional_event = 'PACK_ACC_PACK_PROPOSAL') THEN
         Shipment_Auto_Packing_Util_API.Pack_Acc_Pack_Proposal(shipment_id_);
         @ApproveTransactionStatement(2021-06-11,rojalk)
         COMMIT;    
      ELSIF (optional_event_rec_.optional_event = 'DISCONNECT_EMPTY_HUS') THEN
         Shipment_Handling_Utility_API.Disconnect_Empty_Hu_On_Ship(shipment_id_);
         @ApproveTransactionStatement('2017-11-14,chfose');
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_PACKING_LIST') THEN
         Print_Packing_List___(shipment_id_); 
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_HANDLING_UNIT_LABEL') THEN
         Print_Handling_Unit_Labels___(shipment_id_);  
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_SHIP_HANDL_UNIT_LABEL') THEN
         Print_Shp_Handl_Unit_Labels___(shipment_id_);  
         @ApproveTransactionStatement(2016-10-27,dazase)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_ADDRESS_LABEL') THEN
         FOR rec_ IN get_top_level_hus LOOP
            Print_Shipment_Doc___('ADDRESS_LABEL_REP', shipment_id_, rec_.handling_unit_id, NULL);
            handling_unit_exists_ := TRUE;
         END LOOP; 
         IF NOT (handling_unit_exists_) THEN
            Print_Address_Label___(shipment_id_);
         END IF;
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_CONSIGNMENT_NOTE') THEN
         Print_Consignment_Note___(shipment_id_); 
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_BILL_OF_LADING') THEN
         Print_Bill_Of_Lading___(shipment_id_);
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'CREATE_SSCC') THEN
         Create_Sssc___(shipment_id_); 
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_PRO_FORMA_INVOICE') THEN
         Print_Pro_Forma_Invoice___(shipment_id_);
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT;
      ELSIF (optional_event_rec_.optional_event = 'PRINT_SHIP_DELIVERY_NOTE') THEN
         Print_Shipment_Delivery_Note__(shipment_id_, shipment_rec_.source_ref_type);
         @ApproveTransactionStatement(2014-12-16,jelise)
         COMMIT; 
      ELSIF (optional_event_rec_.optional_event = 'BLOCK_AUTO_CONNECTION') THEN         
         IF ((shipment_rec_.auto_connection_blocked = 'FALSE') AND (shipment_rec_.shipment_category = 'NORMAL')) THEN
            Shipment_API.Modify_Auto_Connect_Blocked__(shipment_id_, 'TRUE');
            @ApproveTransactionStatement(2014-12-16,jelise)
            COMMIT;
         END IF;
      END IF;  

      @ApproveTransactionStatement(2014-12-16,jelise)
      SAVEPOINT event_processed;
   END LOOP;
END Process_Optional_Events;


@UncheckedAccess
FUNCTION Get_Next_Step (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS 
   allowed_operations_   VARCHAR2(20);
   delim_                VARCHAR2(2);
   next_step_list_       VARCHAR2(1400);
   allowed_operation_    VARCHAR2(2);
   next_step_            VARCHAR2(200);
BEGIN
   allowed_operations_ := Get_Allowed_Ship_Operations__(shipment_id_);
   FOR position_ IN 1..8 LOOP
      allowed_operation_ := SUBSTR(allowed_operations_, position_, 1);
      IF (position_ = 2) AND (allowed_operation_ != '1') THEN
         allowed_operation_ := SUBSTR(allowed_operations_, 13, 1);
      END IF;
      IF allowed_operation_ NOT IN ('*', '4') THEN
         next_step_ := NULL; 
         CASE allowed_operation_
            WHEN '0' THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_RESERVE);
            WHEN ('1') THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_REPORT_PICKING);
            WHEN ('R') THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_REPORT_PICKING);
            WHEN '2' THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_DELIVER);
            WHEN '3' THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_COMPLETE);
            WHEN '5' THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_CLOSE);
            WHEN '6' THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_CREATE_PICK_LIST);
            WHEN '7' THEN
               next_step_ := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_PRINT_PICK_LIST);
            ELSE
               NULL;
         END CASE;
         next_step_list_ := next_step_list_||delim_||next_step_;
         delim_ := ', ';
      END IF;
   END LOOP;
   RETURN next_step_list_;
END Get_Next_Step;


-- Pack_Acc_To_Packing_Instr
--   Include the logic to execute the Pack According to Packing Instruction optional event.
PROCEDURE Pack_Acc_To_Packing_Instr (
   shipment_id_ IN NUMBER )
IS
   shipment_line_tab_ Shipment_Line_API.Line_Tab;
   CURSOR get_lines IS
      SELECT shipment_id, shipment_line_no, source_ref1, source_ref2,
             source_ref3, source_ref4, source_ref_type_db
      FROM   shipment_connectable_line
      WHERE  shipment_id = shipment_id_
      AND    packing_instruction_id IS NOT NULL
      AND    remaining_qty_to_attach > 0;
      
   info_    VARCHAR2(2000);
BEGIN
   OPEN get_lines;
   FETCH get_lines BULK COLLECT INTO shipment_line_tab_;
   CLOSE get_lines;
   
   IF (shipment_line_tab_.COUNT > 0) THEN 
      Shipment_Auto_Packing_Util_API.Auto_Pack_Shipment_Lines(info_, shipment_line_tab_); 
   END IF;
END Pack_Acc_To_Packing_Instr;


-- Pack_Acc_To_HU_Capacity
--   Include the logic to execute the Pack according to Handling Unit Capacity optional event.
PROCEDURE Pack_Acc_To_HU_Capacity (
   shipment_id_ IN NUMBER )
IS
   CURSOR get_lines IS
      SELECT shipment_line_no, source_ref1, source_ref2, source_ref3,
             source_ref4, handling_unit_type_id, remaining_qty_to_attach
      FROM   shipment_connectable_line
      WHERE  shipment_id = shipment_id_
      AND    handling_unit_type_id IS NOT NULL
      AND    remaining_qty_to_attach > 0;
      
   info_       VARCHAR2(2000);
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR rec_ IN get_lines LOOP 
      Shipment_Line_API.Connect_To_New_Handling_Units(info_,
                                                      shipment_id_,
                                                      rec_.shipment_line_no,
                                                      rec_.source_ref1,
                                                      rec_.source_ref2,
                                                      rec_.source_ref3,
                                                      rec_.source_ref4,
                                                      rec_.handling_unit_type_id,
                                                      rec_.remaining_qty_to_attach );
                                                 
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Pack_Acc_To_HU_Capacity;


-- Get_Pick_Lists_For_Shipments
--   Returns unpicked pick lists for a given shipment set.
@UncheckedAccess
FUNCTION Get_Pick_Lists_For_Shipments (
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pick_list_no_list_ VARCHAR2(32000);
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);
   shipment_id_       NUMBER; 
BEGIN
   pick_list_no_list_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SHIPMENT_ID') THEN
         shipment_id_       := Client_SYS.Attr_Value_To_Number(value_);
         pick_list_no_list_ := pick_list_no_list_ || Get_Pick_Lists_For_Shipment__(shipment_id_, NULL);
      END IF;
   END LOOP;
   RETURN pick_list_no_list_;
END Get_Pick_Lists_For_Shipments;


-- This method is used by DataCaptProcessShipment
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   shipment_id_        IN NUMBER,
   capture_session_id_ IN NUMBER )
IS
   event_tab_           Event_Tab;
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_  NUMBER;
   exit_lov_            BOOLEAN := FALSE;
BEGIN
   --revise needed FOR access right
   $IF Component_Wadaco_SYS.INSTALLED $THEN
   
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      IF shipment_id_ IS NOT NULL THEN 
         event_tab_ := Get_Next_Mandatory_Events__(shipment_id_);
      END IF;

      IF event_tab_.Count > 0 THEN 
         FOR i IN event_tab_.FIRST..event_tab_.LAST LOOP

            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => event_tab_(i).description,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;

      -- We add the undo complete as last data item in the list of value.
      IF (shipment_id_ IS NOT NULL AND Shipment_API.Reopen_Shipment_Allowed__(shipment_id_) = 1) OR shipment_id_ IS NULL THEN
         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_UNDO_COMPLETE),
                                          lov_item_description_  => NULL,
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
      -- Adding Undo delivery as well
      ELSIF (shipment_id_ IS NOT NULL AND Shipment_API.Undo_Shipment_Allowed(shipment_id_)) THEN
         Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                          capture_session_id_    => capture_session_id_,
                                          lov_item_value_        => Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_UNDO_DELIVERY),
                                          lov_item_description_  => NULL,
                                          lov_row_limitation_    => lov_row_limitation_,    
                                          session_rec_           => session_rec_);
      END IF;
      
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;

-- Create_Report_Settings
--   Creates pdf_info_ attribute string to be used to set pdf parameters when printing reports.
@UncheckedAccess
PROCEDURE Create_Report_Settings (
   pdf_info_            OUT VARCHAR2,
   shipment_id_         IN  NUMBER,
   contract_            IN  VARCHAR2,
   receiver_id_         IN  VARCHAR2,
   receiver_type_       IN  VARCHAR2,
   receiver_addr_id_    IN  VARCHAR2,
   report_id_           IN  VARCHAR2,
   sender_id_           IN  VARCHAR2,
   sender_type_         IN  VARCHAR2)
IS
   shipment_rec_  Shipment_API.Public_Rec;
BEGIN
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   
   Create_Report_Settings (pdf_info_, 
                           shipment_id_, 
                           contract_, 
                           receiver_id_, 
                           receiver_type_, 
                           shipment_rec_.receiver_reference, 
                           shipment_rec_.sender_reference,
                           receiver_addr_id_,
                           report_id_,
                           sender_id_,
                           sender_type_);
END Create_Report_Settings;

-- Create_Report_Settings
--   Creates pdf_info_ attribute string to be used to set pdf parameters when printing reports.
@UncheckedAccess
PROCEDURE Create_Report_Settings (
   pdf_info_            OUT VARCHAR2,
   shipment_id_         IN  NUMBER,
   contract_            IN  VARCHAR2,
   receiver_id_         IN  VARCHAR2,
   receiver_type_       IN  VARCHAR2,
   receiver_reference_  IN  VARCHAR2,
   sender_reference_    IN  VARCHAR2,
   receiver_addr_id_    IN  VARCHAR2,
   report_id_           IN  VARCHAR2,
   sender_id_           IN  VARCHAR2,
   sender_type_         IN  VARCHAR2)
IS
   company_           VARCHAR2(20);
   email_             VARCHAR2(200);
   report_name_       VARCHAR2(200);
   temp_contact_      VARCHAR2(200);
BEGIN
   IF receiver_reference_ IS NOT NULL THEN
      IF Comm_Method_API.Get_Default_Value('CUSTOMER', receiver_id_, 'E_MAIL', receiver_addr_id_, NULL, receiver_reference_) IS NULL THEN
         temp_contact_ := Contact_Util_API.Get_Cust_Contact_Name(receiver_id_, receiver_addr_id_, receiver_reference_);
      END IF;
   END IF;
   
   IF (receiver_type_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      company_ := Site_API.Get_Company(contract_);
      $IF Component_Order_SYS.INSTALLED $THEN      
         email_ := Cust_Ord_Customer_Address_API.Get_Email(receiver_id_, receiver_reference_, receiver_addr_id_);
      $END
      -- should fetch receiver according to receiver type especially for receiver type supplier in the future
   END IF;
   IF (email_ IS NULL) THEN
      email_:= Comm_Method_API.Get_Name_Value('COMPANY', company_, 'E_MAIL', receiver_reference_, receiver_addr_id_);
   END IF;
   
   pdf_info_ := Message_SYS.Construct('PDF');
   
   IF (report_id_ = 'SHIPMENT_DELIVERY_NOTE_REP') THEN
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_1', email_);      
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_2', receiver_id_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_3', contract_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_4', receiver_reference_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_5', receiver_type_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_6', sender_reference_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_7', shipment_id_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_8', NVL(temp_contact_, receiver_reference_));
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_9', sender_id_);
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_10', sender_type_);
   END IF;
   
   report_name_ := Report_Definition_API.Get_Translated_Report_Title(report_id_);   
   
   IF (report_id_ = 'SHIPMENT_DELIVERY_NOTE_REP') THEN
      Message_SYS.Add_Attribute(pdf_info_, 'PDF_FILE_NAME', report_name_ || '_' || shipment_id_);
   END IF;
   
   Message_SYS.Add_Attribute(pdf_info_, 'PDF_EVENT_PARAM_11', Fnd_Boolean_API.DB_TRUE);
   Message_SYS.Add_Attribute(pdf_info_, 'REPLY_TO_USER', Person_Info_API.Get_User_Id(User_Default_API.Get_Authorize_Code));
END Create_Report_Settings;
/*
--------------------------------------
-- Process Shipment ------------------
--------------------------------------
PROCEDURE Create_Data_Capture_Lov (
   shipment_id_        IN NUMBER,
   capture_session_id_ IN NUMBER )
IS
--   TYPE Event_Tab       IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
   event_tab_           Event_Tab;
   session_rec_         Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_  NUMBER;
   exit_lov_            BOOLEAN := FALSE;
   allowed_operations_   VARCHAR2(20);
   allowed_operation_    VARCHAR2(2);
   
   CURSOR Events IS
      SELECT event
      FROM SHIPMENT_EVENT_TAB
      ORDER BY event;
BEGIN
   --revise needed FOR access right
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      allowed_operations_ := Get_Allowed_Ship_Operations__(shipment_id_);
      FOR position_ IN 0..6 LOOP
         event_tab_(position_) := NULL;
      END LOOP;
      FOR position_ IN 1..8 LOOP
         allowed_operation_ := SUBSTR(allowed_operations_, position_, 1);
         IF (position_ = 2) AND (allowed_operation_ != '1') THEN
            allowed_operation_ := SUBSTR(allowed_operations_, 13, 1);
         END IF;
        -- index_ := 0;
         IF allowed_operation_ NOT IN ('*', '4') THEN
            event_tab_(0) := NULL;
            CASE allowed_operation_
               WHEN '0' THEN
                  event_tab_(0) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_RESERVE);
               WHEN ('1') THEN
                  event_tab_(3) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_REPORT_PICKING);
               WHEN ('R') THEN
                  event_tab_(3) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_REPORT_PICKING);
               WHEN '2' THEN
                  event_tab_(5) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_DELIVER);
               WHEN '3' THEN
                  event_tab_(4) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_COMPLETE);
               WHEN '5' THEN
                  event_tab_(6) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_CLOSE);
               WHEN '6' THEN
                  event_tab_(1) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_CREATE_PICK_LIST);
               WHEN '7' THEN
                  event_tab_(2) := Shipment_Flow_Activities_API.Decode(Shipment_Flow_Activities_API.DB_PRINT_PICK_LIST);
               ELSE
                  NULL;
            END CASE;
         END IF;
      END LOOP;

      FOR i IN event_tab_.FIRST..event_tab_.LAST LOOP
         IF event_tab_(i) IS NOT NULL THEN 
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => event_tab_(i),
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
         END IF;
         
         EXIT WHEN exit_lov_;
      END LOOP;
   $ELSE
      NULL;
   $END
END Create_Data_Capture_Lov;
*/
