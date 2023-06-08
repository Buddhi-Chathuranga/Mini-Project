------------------------------------------------------------------------------
--
--  Logical unit: Shipment
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History 
--  ------  ------  ---------------------------------------------------------
--  220816  Sulnlk  SCDEV-13104, Added Tax Document Id OUT Parameter to Create_Outgoing_Tax_Document Procedure and Create_Tax_Document___
--  220716  MaEelk  SCDEV-12898, Added Inventory_Part_Lines_Exist to check if the Shipment has an Inventory Part Line.
--  220724  MaEelk  SCDEV-12851, Modified the cursor in Get_Tax_Documnt_Line_Info___ to filter out non inventory parts
--  220719  BWITLK  SC2020R1-11173, Added receiver_id_, receiver_type_db_ to methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist.
--  220718  SaLelk  SCDEV-12469, Added the method Check_Mixed_Source_Ref1_Exist and modified Modify_Receiver_Info to pass the address line info as parameters for support generic shipment functionality.
--  220714  Disklk  PJDEV-7479, Modified Do_Undo_Shipment_Delivery___ to enable Undo Delivery for shipments connected to project deliverables.
--  220713  MaEelk  SCDEV-11672, Added Create_Outgoing_Tax_Document and removed Do_Close___.
--  220714  BWITLK  SC2020R1-11164, Added sender_type_db_,  to methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist.
--  220610  MaEelk  SCDEV-6571, Added  Get_Sender_Address to fetch sender address information of the shipiment.
--  220603  PamPlk  SCDEV-10606, Modified Check_Insert___ to allow shipment creation when the sender is remotewarehouse and receiver is supplier.
--  220517  SaLelk  SCDEV-7911, Created Modify_Receiver_Info method and modified Update___ method by updating Delivery_Note_Tab if Receiver ID has been changed.
--  220506  SaLelk  SCDEV-7796, Modified Check_Insert___ by removing the validation for Sender and Receiver cannot be the same.
--  220318  AsZelk  SCDEV-7716, Modified Do_Undo_Shipment_Delivery___() to support for for PURCH_RECEIPT_RETURN source.
--  220125  RasDlk  SC21R2-3145, Added Get_Sender_Rece_Contract_Whse to fetch warehouse information required for the Undo Shipment Delivery process.
--  220118  MaEelk  SC21R2-5576, Added IgnoreUnitTest annotation to Get_Tax_Documnt_Header_Info___, Get_Tax_Documnt_Line_Info___
--  220118          Create_Tax_Document___ and Do_Close___
--  220110  RasDlk  SC21R2-3145, Added Undo_Shipment_Allowed and modified Do_Undo_Shipment_Delivery___ to support Undo Shipment Delivery for sources other than Customer Order.
--  220104  NiDalk  SC21R2-6425, Added Validate_Ref_Id to validate Ref Id of Shipment when updating when brazilian localization is used. 
--  211220  Diablk  SC21R2-6865, Modified Release_Not_Reserved_Qty to disable if source id purchase Receipt Return.
--  211214  ApWilk  SC21R2-6311, Modified method Get_Tax_Documnt_Line_Info___ for passing the value for source_part_no, qty_shipped and source_ref_type when creating the outbound tax document line.
--  211208  MaEelk  SC21R2-6474 Renamed Do_Create_Tax_Document___ as Do_Close___. Moved the condion Allow_Create_Tax_Document___ to Do_Close___
--                  Added Get_Tax_Documnt_Line_Info___ to fetch Shipment Line Info that need to be passed to create the Tax Document Line
--                  Made a call to create the Tax Document Line inside Create_Tax_Document___
--  211125  MaEelk  SC21R2-5573, Added Do_Create_Tax_Document___, Allow_Create_Tax_Document___ and Get_Tax_Documnt_Header_Info___ 
--                  to create a tax document when closing a shipment originated from Shipment Order.  
--  211101  ErRalk  SC21R2-3011, Modified Fetch_Freight_Payer_Info to support supplier receiver type.
--  211022  ErRalk  SC21R2-3011, Modified Check_Insert___ to restrict user from creating shipment when the sender is remotewarehouse and receiver is supplier.
--  211022  Diablk  SC21R2-5268, Modified Validate_Ship_Reservation___ to fix static code analysis error.
--  210913  Diablk  SC21R2-2619, Modified the Complete_Shipment__ to make sure Shipment Line reservations is attached to the Handling Unit structure if Receiver has DESADV messaged enabled, added Validate_Ship_Reservation___ to cater purpose.
--  210713  ErRalk  Bug 159682(SCZ-15538), Modified the Get_Op_Gross_Weight___  and Get_Net_And_Adjusted_Weight___ to fetch the correct values for the Net weight and operative gross weight 
--  210713          in the Shipment,General tab when the net weight value for part catalog is null.
--  210617  Aabalk  SC21R2-1019, Modified Check_Insert___ and Check_Update___ to include fetching of packing proposal ID when the shipment type is modified.
--  210531  RoJalk  SC21R2-1030, Added the method Pack_Acc_Pack_Prop_Allowed__ .
--  210223  Aabalk  SC2020R1-12430, Merged in SCZ-13372, Modified the method Update___() to pass the correct Receiver address information to display in the shipment delivery note analysis window.
--  210223  BudKlk  Bug 157543(SCZ-13440), Modified the methods Check_Insert___ and Check_Update___ to make ship_inventory_location_no null if it fetches a receipt blocked location and raise an error when user enter a receipt blocked location mannually.
--  210202  RasDlk  SC2020R1-11817, Modified Validate_Capacities, Validate_Capacities___, Update___ and Check_Insert___ by reducing number of calls to increase the performance.
--  210202  RasDlk  SC2020R1-11817, Modified Create_Data_Capture_Lov by reducing number of calls to increase the performance.
--  210126  RoJalk  SC2020R1-11621, Modified Modify_Parent_Shipment_Id__, Modify_Auto_Connect_Blocked__, Modify_Ship_Inv_Location_No, 
--  210126          Remove_Manual_Gross_Weight, Remove_Manual_Volume, Approve_Shipment to call Modify___ instead of Unpack methods.
--  210104  BudKlk  Bug 157295(SCZ-13118), Modified Create_Data_Capture_Lov() to remove the condition which makes second_column_value_ NULL in order to make sure that the values retrieved previously will not changed.
--  201130  Aabalk  SCZ-12688, Modified Get_Op_Gross_Weight___ and Get_Operational_Volume___ methods to include shipment line weights and volumes when shipment_uncon_struct
--  201130          is true and no handling unit structure is defined.
--  200914  Aabalk  SC2020R1-7390, Modified fetching of freight payer ID in Shipment_API.Fetch_Freight_Payer_Info for Freight Payer type RECEIVER when the 
--  200914          Shipment Receiver Type is Site or Remote Warehouse.
--  200914  RasDlk  SC2020R1-9650, Modified Check_Insert___ by moving the code block which prevents the user from entering the receiver as customer when the sender is a remote warehouse.
--  200910  RasDlk  SC2020R1-9649, Modified Prepare_Insert___ by setting default values to SHIPMENT_UNCON_STRUCT_DB and AUTO_CONNECTION_BLOCKED_DB boolean attributes.
--  200728  Aabalk  SCXTEND-4364, Modified Reset_Printed_On_Hu_Info_Chg to reset bill of lading printed check when manual weights are changed.
--  200708  Aabalk  Bug 154227 (SCZ-10285), Modified Get_Net_And_Adjusted_Weight___ and Get_Op_Gross_Weight___ method to take into consideration the weight from the configuration specification if available.
--  200625  ErRalk  SC2020R1-7452, Fixed to ignore the ship_via_code default value in Check_Insert___().
--  200622  RasDlk  SC2020R1-689, Modified Check_Update___ by calling the new method Pick_Shipment_API.Check_Unpicked_Pick_List_Exist
--  200622          to check whether the entered location is a shipment location.
--  200604  RasDlk  SCSPRING20-1238, Modified the places where Shipment_Source_Utility_API.Fetch_Source_And_Deliv_Info is used by changing the parameters accordingly.
--  200604          Removed the unused method Get_Receiver_Address_Info__.
--  200601  Aabalk  SCSPRING20-1687, Modified Check_Common___ to allow setting of a suitable default shipment inventory location based on the sender type. Moved code to check 
--  200601          if entered location is a shipment location, from Check_Insert___ and Check_Update___ to Check_Common___.
--  200525  RoJalk  SC2020R1-2201, Modified calls to Shipment_Handling_Utility_API.Get_Packing_Qty_Deviation to pass the source ref type as a parameter.
--  200520  RasDlk  SCSPRING20-689, Modified Check_Insert___ by adding a condition to fetch the default shipment inventory location specified in the site
--  200520          only when the sender type is site.
--  200316  Aabalk  Bug 152790(SCZ-8697), Added method Fetch_Manual_Net_Weight_Info___ to fetch sum of manual net weights and quantities for a particular 
--  200316          shipment line. Modified Get_Net_And_Adjusted_Weight___ to include manual net weights in shipment net weight calculation.
--  200311  DaZase  SCXTEND-3803, Small change in all Create_Data_Capture_Lov to change 1 param in calls to Data_Capture_Session_Lov_API.New.
--  200304  RasDlk  SCSPRING20-1238, Modified Check_Insert___() and Check_Update___() by passing sender_id and sender_type to Shipment_Source_Utility_API.Fetch_Source_And_Deliv_Info method.
--  200217  MeAblk  SCSPRING20-1979, Removed method Check_Shipper__() since the sender address if reference is removed. 
--  200211  Dihelk  GESPRING20-1790, Euro_Pallet implementation.
--  191213  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191213          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191213          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  191210  MeAblk  SCSPRING20-180, Modified Prepare_Insert___() to correctly set the value for shipment_category_db.
--  191113  Aabalk  SCSPRING20-251, Modified error message CONNECTEDLINES in Cancel_Shipment__ to support generic shipment functionality.
--  191023  ErFelk  Bug 149943(SCZ-6856), Added new method All_Lines_Has_Doc_Address___() which is been used in Finite_State_Machine___ at the time of Closing a Shipment.
--  191022  MeAblk  SCSPRING20-190, Added some further validations into the Check_Insert___() for sender and receiver. Increased the length of the referring variables of receiver id.
--  191022          Added sender address validation in the Check_Update___().
--  191015  MeAblk  SCSPRING20-538, Modified methods Prepare_Insert___() and Check_Insert___() to support new sender type and id. Added new methods Validate_Sender_Address___() and Sender_Address_Exist().
--  190312  ApWilk  Bug 152479 (SCZ-9054), Modified Check_Update___() to retrieve the correct delivery information when changing the ship via code in the shipment header.
--  190204  UdGnlk  Bug 146502, Modified Check_Insert___() column shipment_uncon_struct to assign default value FALSE when it is NULL. 
--  181114  NiDalk  Bug 144783, Added Get_Net_And_Adjusted_Weight__, Modified Get_Net_And_Adjusted_Weight___ to return line weight.
--  181017  KiSalk Bug 144750(SCZ-1465), Modified the methods Get_Net_And_Adjusted_Weight___, Get_Op_Gross_Weight___ and Get_Operational_Volume___ not to use value from previous iteration in the loop when weight/volume have null values. 
--  170420  BudKlk  Bug 140653, Modified the methods Get_Net_And_Adjusted_Weight___() , Get_Op_Gross_Weight___() and Get_Operational_Volume___() by adding a condition to check whether the current and 
--  170420          previous source_part_no are the same in order to get the correct values for net_weight_,operational_gross_weight_ and operational_volume_.
--  180307  RaVdlk  STRSC-17471, Removed installation errors from sql plus tool
--  180228  RoJalk  STRSC-15133, Added the method Check_Reset_Printed_Flags.
--  180215  Nikplk  STRSC-2600, Added a automatic_creation_ check before User_Allowed_Site_API.Exist validation in Check_Insert___ method.
--  180209  MaRalk  STRSC-16055, Modified Get_Receiver_Address_Info__ by adding client value for shipment freight payer 
--  180209          to the attr other than the db value in order to use for the receiver_addr_id validation inside shipment form.
--  180201  CKumlk  STRSC-15889, Modified Create_Data_Capture_Lov to make second_column_value_ null when temp_handling_unit_id_ is null for ALT_HANDLING_UNIT_LABEL_ID.
--  180111  MaRalk  STRSC-15546, Modified Refresh_Parent__ in order to allow calling NULL event when the rowstate is Closed.
--  171207  RoJalk  STRSC-9591, Added the function Trigger_Complete_Ship_Allowed.
--  171129  RoJalk  STRSC-9591, Modified Complete_Shipment__ and called Pick_Shipment_API.Get_Res_Not_Pick_Listed_Line.
--  171127  RoJalk  STRSC-13891, Code improvements to the method Reset_Printed_Flags__. 
--  171123  RoJalk  STRSC-14706, Code improvements to the method Reset_Printed_Flags___.
--  171122  RoJalk  STRSC-14706, Added the method Reset_Printed_On_Hu_Info_Chg.
--  171108  RoJalk  STRSC-13891, Added the method Any_Printed_Flag_Set__.
--  171029  RoJalk  STRSC-13811, Modified Reset_Printed_Flags___ to capture the change of dock_code, sub_dock_code, ref_id, location_no for resetting of pro forma invoice checkbox.
--  171025  RoJalk  STRSC-13775, Modified Reset_Printed_Flags___ to handle address change of Delivery Note,Handle Packing List,Pro Forma Invoice.
--  171018  MaRalk  STRSC-11324, Added method Check_Exist_By_Fwdr_Info_Ourid in order to restrict delete 'Our ID at Forwarder' records.
--  171012  KHVESE  STRSC-12752, Removed parameter SOURCE_REF_TYPE from methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist.
--  171004  MaRalk  STRSC-11324, Added method Check_Exist_By_Freight_Payer in order to restrict delete 'Receivers Freight Payer IDs at Forwarder' records.
--  171002  RoJalk  STRSC-11274, Modified Reset_Printed_Flags___ and included checks for receiver address info.
--  170926  KHVESE  STRSC-12224, Modified methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist with pro_no and also added descriptions for shipment id from config detail id in Create_Data_Capture_Lov.
--  170926  MAHPLK  STRSC-11377, Removed Methods Get_Objstate and Get_State.
--  170904  MaRalk  STRSC-11317, Renamed column SHIPMENT_PAYER as SHIPMENT_FREIGHT_PAYER in SHIPMENT_TAB.
--  170901  RoJalk  STRSC-11274, Added the method Reset_Printed_Flags___.
--  170830  KhVese  STRSC-9595, Added methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist for WADACO process PROCESS_SHIPMENT
--  170828  RoJalk  STRSC-11267, Modified Prepare_Insert___,  Check_Insert___, Unpack___, Reset_Printed_Flags__ to handle ADDRESS_LABEL_PRINTED column.    
--  170825  MaRalk  STRSC-11314, Modified Prepare_Insert___ by removing the default freight payer value - 'Not Specified'.
--  170825          Modified Check_Insert___ by adding the extra check for consolidated shipments when assigining the default freight payer value - 'Not Specified'. 
--  170823  RoJalk  STRSC-11613, Modified Reset_Printed_Flags__  to reset bill_of_lading_printed.
--  170804  MaRalk  STRSC-10762, Added Fetch_Freight_Payer_Info. Modified Get_Receiver_Address_Info__ by calling Fetch_Freight_Payer_Info.
--  170616  TiRalk  STRSC-8884, Modified Post_Send_Dispatch_Advice to get distinct order no from shipment_line_tab.
--  170516  SBalLK  Bug 133860, Modified Unpack___() method to allow update FORWARD_AGENT_ID, ADDR_FLAG, ADDR_FLAG_DB, LANGUAGE_CODE, DELIVERY_TERMS, DEL_TERMS_LOCATION, SHIP_VIA_CODE,
--  160516          NOTE_TEXT, SENDER_REFERENCE, QTY_EUR_PALLETS and PLACE_OF_DEPARTURE update even though shipment in closed state and invoice created.
--  170508  Chfose  STRSC-5503, Changed the Get_Net_Weight___ function to the procedure Get_Net_And_Adjusted_Weight___.
--  170508          Moved the logic which was within Get_Net_Weight into the new procedure Get_All_Net_Weight___.
--  170508          Modified the methods Get_Operational_Volume___ and Get_Op_Gross_Weight___.
--  170506  MaRalk  STRSC-7532, Added method Check_Common___ to restrict saving negative values for manual gross weight and manual volume.
--  170503  RoJalk  Bug 132014, Created a method Get_Reciept_Issue_Serial_Part() to check if there exist single line in the shipment which is inventory not tracked serial parts. 
--  170426  KHVESE  STRSC-2419, Modified methods Create_Data_Capture_Lov, added structure level to HANDLING_UNIT_ID, SSCC AND ALT HANDLING_UNIT_ID descriptions.
--  170327  MaIklk  LIM-11259, Fixed to ignore the delivery terms default value in Check_Insert___(). 
--  170322  Chfose  LIM-10517, Renamed Pack_Into_Handl_Unit_Allowed__ to Pack_Acc_HU_Capacity_Allowed__
--  170322  RoJalk  LIM-11253, Modified Complete_Shipment__ and replaced Shipment_Source_Utility_API.Unreported_Pick_Lists_Exist
--  170322          with Pick_Shipment_API.Unreported_Pick_Lists_Exist.
--  170307  Jhalse  LIM-10113, Removed Check_Required_Ship_Inv_Loc because Shipment Inventory is now mandatory for Shipment. 
--  170221  Chfose  LIM-10450, Added Handl_Unit_History_Exists___ & Remove_Handl_Unit_History___ in statemachine in onEntry for Completed state.
--  170221  MaIklk  LIM-10892, Fixed to raise the error if mnadatory field value is missing for normal shipment before framework generated validations.
--  170208  MaIklk  STRSC-4218, Fixed to check planned ship date is changed before raising the error message if ship date < site date in Check_Update___.
--  170206  MaIklk  LIM-10390, Used local variable for set NULL number in Remove_Manual_Gross_Weight and Remove_Manual_Volume.
--  170131  MaIklk  LIM-9825, Handled NVL for source ref columns for shipment_line and Shipment_source_reservation related cursors.
--  170126  MaIklk  LIM-10524, Added mandatory check for Receiver address ID.
--  170126  MaIklk  LIM-10461, Moved Receiver_Address_Exist and Validate_Receiver_Address to this package from Shipment_Source_Utility_API.
--  170111  MeAblk  Bug 133585, Modified methods Get_Net_Weight___(), Get_Op_Gross_Weight___(), Get_Operational_Volume___() in order to corerctly show the weight and volume of the shipment
--  170111          when the sales part is connected to a different inventory part.
--  170109  MaRalk  LIM-6755, Modified Complete_Shipment__ to change error message texts NOTRESQTY and RESNOTPICKLIST to refer shipment line no.
--  170102  MaIklk  LIM-8281, Removed Get_Lines_To_Pick_Shipment(), since no usages found (previously the value was used to display in shipment header).
--  161221  MaIklk  LIM-8389, Fixed to use cursor by accessing shipment_source_reservation to fetch reserved not pick listed lines instead of calling function.
--  161214  ShPrlk  Bug 129608 corrections were reverted. 
--  161118  MaEelk  LIM-9193, Added method Create_Handl_Unit_History___ to trigger when the shipment is going to the closed state.
--  161107  DaZase  LIM-7326, Added lov_id_/cursor_id_ parameter to Get_Column_Value_If_Unique, Create_Data_Capture_Lov, Record_With_Column_Value_Exist.
--  161107  RoJalk  LIM-8391, Moved Release_Not_Reserved_Qty__,  Shipment_Structure_Exist from Shipment_Handling_Utility_API to Shipment_API.
--  161028  RoJalk  LIM-9424, Moved Get_Tot_Packing_Qty_Deviation from Shipment_Handling_Utility_API to Shipment_API.
--  161026  MaRalk  LIM-9153, Moved Deliver_Shipment__, Handle_Dates_On_Delivery___ methods to ShipmentDeliveryUtility. 
--  161026  RoJalk  LIM-8391, Moved All_Lines_Reserved, All_Lines_Picked, Unconnected_Structure_Allowed from ShipmentHandlingUtility.
--  161026  RoJalk  LIM-8391, Replaced Contains_Dangerous_Goods__ with Shipment_API.Contains_Dangerous_Goods.
--  161026  RoJalk  LIM-8391, Replaced Blocked_Sources_Exist___ with Shipment_API.Blocked_Sources_Exist.
--- 161011  DaZase  LIM-8960, Added method Not_Pick_Reported_Line_Exist.
--  161004  ShPrlk  Bug 129608, Modified Check_Insert___() to avoid user allowed site validation when creating an automatic shipment.
--  160930  RoJalk  LIM-8056, Added the method Post_Send_Dispatch_Advice.
--  160920  DaZase  LIM-4604, Added a new Create_Data_Capture_Lov created especially for TO_SHIPMENT_ID for Reassign process.  
--  160824  RoJalk  LIM-8198, Removed Set_Planned_Ship_Date, added Handle_Dates_On_Delivery___, changed the scope of 
--  160824          Modify_Actual_Ship_Date to be implementation.
--  160823  MaIklk  LIM-8426, Handle to popup message when changing customs value currency when lines are connected.
--  160810  MaRalk  LIM-6755, Modified the error messages BLOCKEDORCOMPLETED, CHANGENOTREFLECTED1, NOTRESQTY and RESNOTPICKLIST 
--  160810          in order to support generic shipment functionality. Renamed NOTRESQTYORD, NOTRESQTYREL, RESNOTPICKLISTORD, 
--  160810          RESNOTPICKLISTREL to NOTRESQTYSRCREF1, NOTRESQTYSRCREF2, RESNOTPICKLISTSR1, RESNOTPICKLISTSRCREF2 respectively.
--  160804  MaIklk  LIM-7970, Used Get_Objstate instead of Get_State in Update_Shipment__(). Replaced some other usage as well.
--  160729  RoJalk  LIM-7954, Added the method Deliver_Shipment__.
--  160725  RoJalk  LIM-8142, Renamed Any_Connected_Lines__ to Connected_Lines_Exist.
--  160725          Replaced Shipment_Line_API.Connected_Lines_Exist with Shipment_API.Connected_Lines_Exist.
--  160713  RoJalk  LIM-8090, Replaced Shipment_API.Get_Actual_Ship_Date with Shipment_API.Get_Consol_Actual_Ship_Date.
--  160712  MaRalk  STRSC-2848, Added annotation @UncheckedAccess to Shipment_Delivered method.
--  160712  MaRalk  LIM-8069, Added method source_ref_type_exist which takes two string parameters and used inside Update___
--  160712          as a condition for the method call Shipment_Freight_API.Remove_Freight_Info.
--  160608  MaIklk  LIM-7442, Fixed the usages of renaming Customer_Order_Deliv_Note to Delivery_Note.
--  160607  MaRalk  LIM-7399, Modified Update___ in order to call Shipment_Freight_API.Modify when ship via code changes.
--  160607          (Moved client logic to server).
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160607  RoJalk  LIM-6975, Added the method Get_Objstate.
--  160606  MaRalk  LIM-7402, Modified Check_Insert___ and Check_Update___ to modify method parameters for 
--  160606          Shipment_Source_Utility_API.Fetch_Source_And_Deliv_Info method call.
--  160603  MeAblk  Bug 129619, Modified Unpack___ to correctly make it possible to modify pro_no in closed shipments.
--  160519  RoJalk  LIM-7467, Modified Insert___ and added Shipment_Source_Utility_API.Post_Create_Manual_Ship.
--  160518  ThEdlk  Bug 129043, Modified Check_Update___() by using planned_ship_date from newrec_ instead of retrieving from attr_. 
--  160518  MaRalk  LIM-7406, Modified Update___ to remove freight related information when 'Customer Order' source Ref type is not there. 
--  160516  reanpl  STRLOC-65, Added handling of new attributes address3, address4, address5, address6 
--  160516  ThEdlk  Bug 129043, Modified Check_Update___() by using ship_inventory_location_no from newrec_ instead of retrieving from attr_ for the assignment of ship_location_. 
--  160512  RoJalk  LIM-6947, Modified Complete_Shipment__ and called Shipment_Source_Utility_API.Unreported_Pick_Lists_Exist.
--  160509  MaRalk  LIM-6531, Moved Shipment_Tab - fix_deliv_freight, apply_fix_deliv_freight, currency_code, 
--  160509          freight_map_id, zone_id, price_list_no, freight_chg_invoiced, supply_country and use_price_incl_tax 
--  160509          columns to a new table Shipment_Freight_Tab in order module. Modified Prepare_Insert___, Insert___, 
--  160509          Check_Insert___, Update___, Check_Update___ and Unpack___.
--  160503  RoJalk  LIM-7310, Renamed Shipment_Handling_Utility_API.Get_Remain_Parcel_Qty to Get_Remaining_Qty_To_Attach.
--  160427  RoJalk  LIM-6811, Move code related to reassignment to ReassignShipmentUtility.
--  160412  RoJalk  LIM-6631, Added NVL handling for source ref comparisons since it can be null.
--  160411  MaIklk  LIM-6957, Renamed Ship_Date to Planned_Ship_Date and added planned_delivery_date in Shipment_tab.
--  160405  MaRalk  LIM-6543, Modified methods Prepare_Insert___ and Check_Shipper__ to reflect the change of the column name 
--  160405          sender_id as sender_addr_id in Shipment_Tab.
--  160328  MaRalk  LIM-6591, Modified Get_Operational_Volume___, Get_Net_Weight___, Get_Op_Gross_Weight___ by removing the use of 
--  160328          Shipment_Source_Utility_API.Get_Line and instead used shipment line values.
--  160324  RoJalk  LIM-6579, Modified Complete_Shipment__ and moved the logic to fetch reserved and not pick listed source info
--  160324          to the method Shipment_Source_Utility_API.Get_Reserved_Not_Pick_Listed.
--  160308  MaRalk  LIM-5871, Modified Complete_Shipment__ - get_not_reserved to reflect shipment_line_tab-sourece_ref4 data type change. 
--  160309  RoJalk  LIM-4114, Added the method Get_Distinct_Source_Ref1.
--  160308  RoJalk  LIM-6264, Modified Complete_Shipment__ and referred to inventory_part_no in get_not_reserved cursor.
--  160208  MaIklk  LIM-4172, Consolidated the calls to freight charge in Update() and made Update() generic.
--  160208  RoJalk  LIM-4174, Modified Do_Undo_Shipment_Delivery___ and called @AllowTableOrViewAccess TABLE_NAME
--  160208          Modified cursors in Complete_Shipment__ to remove calls to join with customer_order_line_tab. 
--  160203  MaRalk  LIM-6114, Modified methods Update___, Check_Insert___, Check_Update___, Validate_Reassign_To_Ship__, 
--  160203          Get_Receiver_Address_Info__, Refresh_Values_On_Shipment, Get_Column_Value_If_Unique, Create_Data_Capture_Lov, 
--  160203          Record_With_Column_Value_Exist and Check_Exist_By_Address to reflect the change of the column name ship_addr_no 
--  160203          as receiver_addr_id in Shipment_Tab, Handling_Unit_Shpment_Pub.
--  160128  RoJalk  LIM-5911, Added source_ref_type_db_  parameter to Get_Total_Open_Shipment_Qty.
--  160127  MaRalk  LIM-4165, Removed method Check_For_Invoiced_Order_Lines and moved the logic into a new method 
--  160127          Validate_Update_Closed_Shipmnt in ShipmentSourceUtility LU. Modified Unpack___ method accordingly.
--  160126  MaIklk  LIM-4162, Moved Get_Collect_Charge() and Get_Collect_Charge_Currency() to Shipment Order Utility.
--  160125  MaIklk  LIM-4171, Added a conditional compilation in Check_Update___() to make it generic. 
--  160122  MaIklk  LIM-6002, Moved Fetch_Freight_And_Deliv_Info to Shipment Order Utility and called it from Shipment Source Utility.
--  160122  MaRalk  LIM-4161, Moved Rma_Connection_Allowed logic to Return_Materal_API.Validate_Shipment_Id___ method.
--  160122  MaIklk  LIM-4169, Removed order line reference in Any_Picked_Lines___ annd Any_Unpicked_Reservations__ cursors to make them genric.
--  160121  MaIklk  LIM-4159, Made Get_Consol_Ship_Delnote_Nos() generic.
--  160121  MaIklk  LIM-5940, Moved Validate_Tax_Calc_Basis___() to Shipment Order Utility.
--  160120  MaIklk  LIM-4166, Made Send_Disadv_Allowed__() and Delivery_Note_Exist__() generic.
--  160120  MaIklk  LIM-5946, Moved Receiver validations related code to Shipment source utility.
--  160120  MaIklk  LIM-4175, Modified Get_Operational_Volume___(), Get_Net_Weight___() and Get_Op_Gross_Weight___() to make generic.
--  160119  MaIklk  LIM-4173, Moved the content of Discon_Partial_Del_Lines___() to Shipment Order utility. 
--  160119  MaIklk  LIM-5939, Added conditonal compilation to make Create_Shipment_Del_Note___() generic.
--  160118  RoJalk LIM-5900, Move Shipment_Line_API.Reset_Printed_Flags___/Update_Shipment___ from Shipment_Line_API to Shipment_API.
--  160112  RoJalk  LIM-4633, Added the method Source_Ref_Type_Exist. 
--  160111  RoJalk  LIM-5712, Rename shipment_qty to onnected_source_qty in SHIPMENT_LINE_TAB. 
--  160106  MaIklk  LIM-5750, Passed source_ref_type paramter for the Shipment_Handling_Utility_API.Get_Remain_Parcel_Qty().
--  151231  HimRlk  Bug 126175, Modified Check_Insert___ to ignore the default forwarder_agent_id. When adding a new shipment, forwader_agent_id does not have to be fetched
--  151231          from the default values.
--  151229  MaIklk  LIM-4093, Used Shipment_Delivered___() instead calling All_Line_Delivered in ShipmentHandlingUtility and Added Get_Source_Ref_Type_List().
--  151217  MaIklk  LIM-5356, Added Modify_Actual_Ship_Date() and handled to remove value when undo delivery.
--  151215  MaIKlk  LIM-5406, Added Source ref type column and Handled to update the source ref type when inserting or deleting lines (Modify_Source_Ref_Type()).
--  151210  MaIklk  LIM-4060, Handled references manually for receiver_id, ship_addr_no and source_ref1.
--  151210          Further moved the client validations to server logic in order to make generic.
--  151202  RoJalk  LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202          SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151123  MaIklk  LIM-5007, Added logic for new column Receiver_Type.
--  151119  RoJalk  LIM-4886, Make Shipment Line Generic - Rename SALES_QTY to SHIPMENT_QTY, REVISED_QTY_DUE to INVENTORY_QTY.
--  151112  AyAmlk Bug 125674, Modified Check_Insert___() in order to set shipment location to automatically created Shipment for a single occurrence address.
--  151110  MaIklk  LIM-4059, Renamed deilver_to_customer_no to receiver_id and renamed address fields to sender_xxx and receiver_xxx of shipment table.
--  151110  RoJalk  LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  151027  Erlise  LIM-3779, Rename ALT_TRANSPORT_LABEL_ID data item to ALT_HANDLING_UNIT_LABEL_ID.
--  151026  DaZase  LIM-4297, Renamed method call Get_Handling_Unit_From_Atl_Id to Get_Handling_Unit_From_Alt_Id.
--  150619  MAHPLK  KES-665, Added new methods Any_Delivered_Shipments___() and Undo_Shipment_Allowed___() and modified Do_Undo_Shipment_Delivery___()
--  150612  MAHPLK  KES-665, Added new methods Undo_Shipment_Delivery() and Do_Undo_Shipment_Delivery___().
--  150526  IsSalk  KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150527  DaZase COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase COB-437, Removed 100 record description limitation in methods Create_Data_Capture_Lov, 
--  150520         this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150417  FAndSE COB-352, Remove confusing warning message raised when changing shipment type: "The connected order lines will not be automatically updated".
--  150305  RILASE COB-21, Added Get_Column_Value_If_Unique, Record_With_Column_Value_Exist, Create_Data_Capture_Lov and public interface Validate_Reassign_To_Ship.
--  150810  HimRlk Bug 123492, Modified Check_Insert___ to ignore the default route_id. When adding a new shipment, route_id does not have to be fetched
--  150810         from the default values. 
--  150312  MeAblk Bug 121511, Modified Unpack___ in order to make it possible to print the pro forma invoice after the shipment is closed.
--  150204  JeLise  PRSC-5800, Added call to User_Allowed_Site_API.Exist in Check_Insert___.
--  141214  MaEelk PRSC-2391, Modified Get_Operational_Volme___ and Get_Op_Gross_Weight___ to exclude component part lines connected to the shipment. 
--  141213  MeAblk Added new method Check_Required_Ship_Inv_Loc.
--  141128  SBalLK PRSC-3709, Modified Check_Insert___(), Check_Update___() and Fetch_Freight_And_Deliv_Info() methods to fetch delivery terms and delivery terms location from supply chain matrix.
--  141103  RoJalk Modified Reopen_Shipment_Allowed__ and changed shipment_id_ to  ship_rec_.shipment_id.
--  140521  MaEelk Modified Get_Operational_Volume___ to consider unattached lines allowed or not when calculating the operational volume. 
--  140521         Remaining quantity of unattached lines were considered according to the value of  shipment_uncon_struct.
--  140521         Modified Get_Op_Gross_Weight___ to fetch conversion factors correctly when calcualating the Operational Gross Weight.
--  140520  RoJalk Modified Check_Insert___ and assigned newrec_.forward_agent_id to forwarder_ instead of fetching from attr. 
--  140513  MaEelk Modified Get_Op_Gross_Weight___ to conside unattached lines allowed or not when calculating the operational gross weight.
--  140507  RoJalk Modified the error text of NOTRESQTYORD in Complete_Shipment__. 
--  140410  MaEelk Modified Get_Net_Weight___ to make conversions between sales part uom and inventory part uom correctly.
--  140318  AyAmlk Bug 115778, Modified Check_Insert___() and Check_Update___() so that the Site country is assigned to the supply country.
--  140225  HimRlk Modified Add_Empty_Handl_Unit_Structure to send shipment_id when creating handling unit structure.
--  140221  RoJalk Modified Complete_Shipment__ to consider conversion factors for PKG parts.
--  140205  HimRlk Modified Get_Net_Weight___ to ignore component parts when calculating weights.
--  131024  MaMalk Modified Unpack_Check_Insert___ to remove unwanted validate Validate_Capacities___.
--  140116  RoJalk Modified New to use the correct attribute string. 
--  131031  RoJalk Modified the base view to align it with model and the database.
--  130904  MaMalk Added Validate_Capacities to call from the client when connecting shipments to a consolidated shipment.
--  130903  MaMalk Made ship_date public.
--  130901  RoJalk Modified Complete_Shipment__ and replaced ROUND with CEIL in get_max_pkg_comp_reserved cursor.
--  130830  RoJalk Removed unused varibales from Refresh_Values_On_CS___.
--  130829  MaMalk Modified CONSOLIDATED_SHIPMENT_LOV to exclude delivered consolidated shipments.
--  130829         Added more validations in Validate_Shipments___ when connecting or disconnecting a shipment from a CS.
--  130828  RoJalk Modified Complete_Shipment__ and included error messages to check for remaining to reserve and pick qty. 
--  130826  RoJalk Modified Complete_Shipment__ and raised an error when reserved but not pick listed lines exits. 
--  130826  MaMalk Modified the where condition of view CONSOLIDATED_SHIPMENT_LOV to include completed consolidated shipments.
--  130826         Also added No_Shipments_Connected___ and modified Validate_Shipments___ and Finite_State_Machine___.
--  130822  MaEelk Made a call to Shipment_Freight_Charge_API.Calculate_Shipment_Charges to calculate shipment charges when a change is done to the manual_gross_weight or manual_volume
--  130816  MaMalk Modified Complete_Shipment__ to transfer the shipment reservations back to customer order if no pick lists have been created before completing the shipment.
--  130816  MaEelk Modified Get_Net_Weight___ and Get_Op_Gross_Weight___ to consider the sales part's UOM and part catalog's UOM as well during the calculation.
--  130806  MaMalk Modified Refresh_Values_On_Shipment to pass the correct load_sequence_no when a route is changed in the shipment header.
--  130805  MeAblk Removed attribute shipment_measure_edit, multi_lot_batch_per_pallet and related get method.
--  130725  MaEelk Modified No_Lines_In_Shipment___, Cancel_Shipment_Allowed___ and Cancel_Shipment__. Removed the calls to Shipment_Handling_Unit_API and added Handling_Unit_API.Connected_To_Shipment_Exist.
--  130717  MaMalk Added the lov view CONSOLIDATED_SHIPMENT_LOV to show some selected attributes in the consolidated shipment.
--  130717         Added Validate_Shipments___  and modified Modify_Parent_Shipment_Id__, Unpack_Check_Update___ and Update___ to enable
--  130717         the support for updating the parent shipment id in the shipment header.
--  130715  RoJalk Added the column next_step to the view SHIPMENT_TO_REASSIN_LOV.
--  130705  MaMalk Added Pro_Forma_Printed to the LU to indicate whether a pro forma invoice is printed.
--  130628  MaMalk Modified Unpack_Check_Update___ to seperate the message given when certain information on the shipment header is changed.
--  130628  MAHPLK Modify Unpack_Check_Update___ to check whether shipment location in the shipment is change from anything else than NULL if there exist pick list not pick reported yet.
--  130627  MaMalk Modified Refresh_Values_On_CS___ to pass the transport unit type, weight and volume capacities when the consolidated shipment ship via gets changed.
--  130625  MaMalk Added method Refresh_Values_On_Shipment to refresh the the shipment header values based on the values of the
--  130625         connected CO Linesand converted Any_Connected_Lines___ method into a private method to call it from the client.
--  130620  RoJalk Added the route information to the SHIPMENT_TO_REASSIN_LOV view.
--  130619  MaMalk Renamed and added parameters to method Fetch_Freight_Info.
--  130613  JeLise Removed method Generate_Structure_Allowed__ and added methods Pack_Into_Handl_Unit_Allowed__ and Pack_Acc_Pack_Instr_Allowed__.
--  130612  MaMalk Modified Set_Connect_Shipments_Fixed___, renamed this method to Set_Values_On_Shipments___ and also added Refresh_Values_On_CS___ 
--  130612         to update values on the consolidated shipment and connected shipments. Added derived attribute server_data_change. 
--  130611  MAHPLK Added new methods Approve_Shipment_Allowed__, Approve_Shipment and new attributes 'Approve before Delivery' , 'Approved by'.
--  130611  MAHPLK Added new methods Any_Unapproved_Shipments___, Approve_Shipment_Allowed__, Approve_Shipment, Modify_Approve_Before_Delivery
--  130611         and new attributes 'Approve before Delivery' , 'Approved by'.
--  130604  MaMalk Added methods Get_Converted_Weight_Capacity and Get_Converted_Volume_Capacity to convert weight and
--  130604         volume capacity to default Company UoM. Also added validations for the weight and volume capacity of the consolidated shipment.
--  130604  RoJalk Removed the validation SHIPBLOCKED from the method Validate_Reassign_Shipment__. 
--  130603  MaMalk Added TransportUnitType, WeightCapacity and VolumeCapacity attributes to use in Consolidated Shipments.
--  130531  RoJalk Modified Validate_Reassign_To_Ship__ and used Database_SYS.string_null in comparison.
--  130528  MaMalk Added Get_Actual_Ship_Date method to get the latest ship_date for the entire Consolidated Shipment.
--  130522  RoJalk Modified Validate_Reassign_To_Ship__ and included a validation to check if destination shipment id is not specified.
--  130522  MaMalk Modified Remove_Manual_Gross_Weight and Remove_Manual_Volume to remove the manual weight and volume if a shipment is connected to a parent consolidated shipment.
--  130520  RoJalk Added the method Validate_Reassign_Shipment__.
--  130520  RoJalk Renamed Validate_Reassign_Shipment__ to Validate_Reassign_To_Ship__.
--  130520  RoJalk Added the method Validate_Reassign_Shipment__.
--  130515  MaMalk Added implementation methods Get_Operational_Volume___, Get_Net_Weight___ and Get_Op_Gross_Weight___ and changed all the public methods existed for
--  130515         calculating weight and volume to consider Consolidated Shipments.
--  130507  MaEelk Added method Remove_Manual_Volume and this would clear the manual_voume of a shipment
--  130501  RoJalk Rearranged the column order of SHIPMENT_TO_REASSIN_LOV.
--  130430  RoJalk Modified SHIPMENT_TO_REASSIN_LOV to filter delivered shipments.
--  130426  RoJalk Modified the view comments of SHIPMENT_TO_REASSIN_LOV.
--  130424  RoJalk Added the SHIPMENT_TO_REASSIN_LOV view to be used in Reassign Shipment Connected Quantity form, added the method Shipment_Delivered___.
--  130423  MaEelk Added Get_Operational_Volume. If there is an manual volume it would be taken as the return value.
--  130423         Otherwise, it would be calculated as the sum of volume for all the top nodes of the shipment
--  130422  RoJalk Renamed No_Delivered_Lines___ to  Not_Delivered___ , modified Reopen_Shipment_Allowed__ to check if shipment is delivered using ship date.   
--  130418  MaMalk Added ORDER_NO, ROUTE_ID, REF_ID, DOCK_CODE, SUB_DOCK_CODE, LOCATION_NO, PLANNED_SHIP_PERIOD and LOAD_SEQUENCE_NO to the Shipment_Tab.
--  130410  MaEelk Added public attribute MANUAL_VOLUME to the Logical Unit.
--  130404  MaMalk Made shipment_type not mandatory and made it mandatory in the logic for normal shipments.
--  130401  RoJalk Removed the method Check_Valid_Dest_Shipment.
--  130322  Maeelk Added Remove_Manual_Gross_Weight to remove the manual gross weight of a shipment in shipment_tab.
--  130320  MaEelk Added Get_Operational_Gross_Weight to calculate either Operational Weight or Adjusted Operational according to the 
--  130320         last parameter apply_freight_factor_ given in the parameter list.
--  130318  RoJalk Added the method Check_Valid_Dest_Shipment to be used in Reassign Shipment Connected Quantity.
--  130315  MaEelk Added public attrribute gross_weight to the LU.
--  130313  MaEelk Added Get_Shipment_Tare_Weight that would  call Handdling_Unit_API.Get_Shipment_tare_Weight 
--  130313         to calculate the tare weight of the top handling unit nodes connected to the system.
--  130313  MaEelk Added Get_Net_Weight to calculate the net weight of the customer order lines conected to the shipment.
--  130313  MaEelk This would support calculating the net weight both with including the freight factor and not including the freight factor. 
--  130308  MeAblk Added new method Add_Empty_Handl_Unit_Structure which adds empty handling unit structure into a Shipment.
--  130301  RoJalk Modified Set_Connect_Shipments_Fixed___ to handle recursive updates for multilevel shipment structures. 
--  130220  RoJalk Modified Set_Connect_Shipments_Fixed___ to handle recursive updates for multi level consolidated shipments.
--  130214  RoJalk Renamed the column fixed to be auto_connection_blocked and modified the references.
--  130212  RoJalk Modified Modify_Parent_Shipment_Id__ and moved the info message to handle fixed shipment to the client.
--  130212  RoJalk Added the methods Get_Fixed_Db, Modify_Fixed__. Modified the method Modify_Parent_Shipment_Id__ to raise an info if the consolidated shipment is fixed.  
--  130211  RoJalk Added the DB column FIXED to indicate if new lines are allowed or not for the normal shipment/consolidated shipment. Added the method Set_Connect_Shipments_Fixed___.
--  130101  MeAblk Modified the main view and Unpack_Check_Update___ in order to make it possible to update the shipment type. Also added the info message when updating the shipment type.   
--  121228  MeAblk Modified method Discon_Partial_Del_Lines___ by removing the update to open shipment qty as it is already done when delivering the shipment.
--  121218  MaMalk Added method Get_Consol_Ship_Delnote_Nos.
--  121211  JeLise Added call to Handling_Unit_API.Connected_To_Shipment_Exist in Cancel_Shipment_Allowed___.
--  121207  MaMalk Added methods Generate_Structure_Allowed__, Delivery_Note_Exist__ and Send_Disadv_Allowed__ to use it from the client for enabling RMBs.
--  121204  MaMalk Moved the logic in Close_Shipment_Allowed__ to the newly added method Close_Shipment_Allowed___.
--  121204  MaMalk Moved the logic in Complete_Shipment_Allowed__ to the newly added method Complete_Shipment_Allowed___.
--  121126  MaMalk Added method Get_Lines_To_Pick_Shipment and modified methods Cancel_Shipment__ and Cancel_Shipment_Allowed__ to handle Consolidated Shipments.
--  121126         Also introduced method Cancel_Shipment_Allowed___.
--  121123  MaMalk Added required state changes to handle the Consolidated Shipment.
--  121122  MaMalk Added 2 new attributes Shipment_Category and Parent_Consol_Shipment_Id to support the consolidation of shipments.
--  121122         Made Currency_Code and Deliver_To_Customer_No nullable. Excluded certain execution paths for Consolidated Shipments.
--  121031  MaEelk Added Get_Total_Open_Shipment_Qty to calculate the total of quantities connected to shipments.
--  121031  MaMalk Replaced Deliver_Customer_Order_API.Get_Shipped_Qty_On_Shipment with Shipment_Order_Line_Tab.Qty_Shipped.
--  121031  MaEelk Mpdified Discon_Partial_Del_Lines___ to update the value of open shipment qty in customer order line when disconnectin a shipment from the customer ordder line. 
--  121023  MAHPLK BI-677, Modified rowstate 'Complete' to 'Completed' and 'Canceled' to 'Cancelled'.
--  121023  MAHPLK BI-676, Modified Complete_Shipment_Allowed__ to check whether shipment connented line(s) exist. 
--  120912  MeAblk Modified methods Prepare_Insert___, Unpack_Check_Insert___ in order to avoid getting the shipment inventory location no directly
--  120912         from the site and instead get it from the supply chain matrix.  
--  120911  MeAblk Added ship_inventory_location_no_ as a parameter to the method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120828  MeAblk Modified methods Prepare_Insert___, Unpack_Check_Insert___ in order to avoid setting default shipment type.
--  120827  MaMalk Added shipment type as a parameter to Fetch_Freight_Info. 
--  120824  MaMalk Added shipment_type as a parameter to method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120821  ChFolk Added new method Get_Addr_Flag_Db which returns db value of addr_flag.
--  120820  SURBLK Added Validate_Tax_Calc_Basis___.
--  120820  SURBLK Added a new column use_price_incl_tax.
--  120810  MaEelk Added Re_Open to re-open a specific shipment
--  120731  MeAblk Removed methods Check_Pick_List_Exist,Check_Pick_List_Use_Ship_Inv and moved them into Customer_Order_Pick_List_API.  
--  120725  MeAblk Added methods Check_Pick_List_Exist, Modify_Ship_Inv_Location_No, Check_Pick_List_Use_Ship_Inv.
--  120724  ChFolk Added new function Rma_Connection_Allowed which checks the possiblity to connect the shipment to RMA.
--  120719  ChFolk Added new LOV view SHIPMENT_RMA_LOV to be used from RMA.
--  120717  RoJalk Modified the scope of shipment_type to be public.
--  120710  RoJalk Modified Unpack_Check_Update___ and added the code for shipment type. 
--  120709  RoJalk Added the field shipment_type.
--  120702  MaMalk Changed the number of parameters in method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  130912  ErFelk Bug 111147, Added return statement to the end of method Get_Supply_Country_Db().
--  130903  MalLlk Bug 111853, Modified Prepare_Insert___ to add Shipper id and address information to the attr_.
--  130226  SALIDE EDEL-2020, changed the use of company_name2 to name
--  120412  AyAmlk Bug 100608, Increased the column length of delivery_terms to 5 in view SHIPMENT.
--  120208  AwWelk Modified the Fetch_Freight_Info() by correcting the parameter passing order of Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details().
--  120126  ChJalk Added ENUMERATION to the column supply_country in the base view.
--  111216  Darklk Bug 100352, Removed the function Get_Connected_Shipments.
--  111215  MaMalk Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111103  NaLrlk Added new field created_date.
--  110909  MaMalk Replaced Shipment_Order_Line_API.Recalculate_Freight_Charges with Shipment_Freight_Charge_API.Recalculate_Freight_Charges
--  110909         since this method was moved to  Shipment_Freight_Charge_API.
--  110818  AmPalk Bug 93557, In Unpack_Check_Update___ and Unpack_Check_Insert___ validated country, state, county and city.
--  110601  ShKolk Added error message CANNOTUPDFIXDELFRE to Unpack_Check_Insert___ and Unpack_Check_Update___.
--  110131  Nekolk EANE-3744  added where clause to View SHIPMENT.
--  110301  MaMalk Added attribute Supply_Country.
--  110203  AndDse BP-3776, Modifications for external transport calendar, call to Fetch_Freight_Info, Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  100812  Chfolk Added new procedure Fetch_Freight_Info which returns freight information based on the other parameters.
--  100812         Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to fetch freight information.
--  100604   MaMalk Replaced ApplicationCountry with IsoCountry to correctly represent the relationship in overviews.
--  100523  JuMalk Bug 91366, Modified Unpack_Check_Update___ to enable airway_bill_no updatable for invoiced shipments.
--  100513  KRPELK Merge Rose Method Documentation.
--  100420  MaMalk Bug 90091, Modified Create_Shipment_Del_Note___ and Update___ to increase the lengths of variables delivery_note_no_ and delnote_no_ to VARCHAR2(15).    
--  100115  UTSWLK Bug 88280, Modified ship_date with the site date of the shipment contract in Set_Ship_Date method.
--  091229  MaRalk Modified the state machine according to the new developer studio template - 2.5.
--  091104  MaRalk Modified SHIPMENT - company column view comments. 
--  090930  MaMalk Removed constant state_separator_. Removed unused code in Complete__ and Finite_State_Init___.
--  ------------------------- 14.0.0 -----------------------------------------------
--  091027  MaRalk Added dummy column company to the view SHIPMENT and rollback the modifcation done to the view comment shipper_id.
--  100426  JeLise Renamed zone_definition_id to freight_map_id.
--  091126  ChJalk Bug 86871, Removed General_SYS.Init_Method from the function Get_Collect_Charge_Currency.
--  091120  ChJalk Bug 86871, Removed General_SYS.Init_Method from the function Get_Collect_Charge.
--  091127  KiSalk Modified Update___() to recalculate freight charges if delivery terms is changed.
--  091028  ShKolk Modified Update___() to recalculate freight charges if ship via or forward agent is changed.
--  090828  MaJalk Added method Get_Freight_Chg_Invoiced_Db.
--  090812  MaJalk Added attribute freight_chg_invoiced and method Modify().
--  090731  ShKolk Modified view comment for Fixed Delivery Freight to Fixed Delivery Freight Amt.
--  090422  DaGulk Bug 80511, Modified Prepare_Insert___ added SHIP_INVENTORY_LOCATION_NO. 
--  080130  NaLrlk Bug 70005, Added public column del_terms_location. 
--  071210  SaJjlk Bug 66397, Added method Any_Picked_Lines__ and Any_Unpicked_Reservations__.  
--  071201  SaJjlk Bug 68088, Modified cursor get_partial_deliveries in method Discon_Partial_Del_Lines___. 
--  090710  ShKolk Modified Update___() to re-calculate freight charges when currency is changed.
--  090423  ShKolk Added ship_date to Get().
--  090406  MaHplk Modified full_truck_price, apply_full_truck_price columns to fix_deliv_freight, apply_fix_deliv_freight.
--  090325  ShKolk Added new columns full_truck_price, apply_full_truck_price, currency_code, zone_definition_id, zone_id, price_list_no.
--  080130  NaLrlk Bug 70005, Added public column del_terms_location.
--  071210  SaJjlk Bug 66397, Added method Any_Picked_Lines__ and Any_Unpicked_Reservations__.
--  071201  SaJjlk Bug 68088, Modified cursor get_partial_deliveries in method Discon_Partial_Del_Lines___.
--  070712  NuVelk Bug 66459, Modified method Unpack_Check_Update___ to raise a warning when a single occurrence address is changed.
--  070514  WaJalk Bug 64292, Added new column qty_eur_pallets.
--  070417  NiDalk Bug 64079, Modified method Discon_Partial_Del_Lines___ and changed the method used to update CO Lines.
--  070207  SaJjlk Removed warning messages in the loop of method Unpack_Check_Update___ to outside.
--  070131  SaJjlk Added new fields CUSTOMER_ADDRESS_NAME, CUSTOMER_ADDRESS1, CUSTOMER_ADDRESS2,
--  070131         CUSTOMER_CITY, CUSTOMER_STATE, CUSTOMER_ZIP_CODE, CUSTOMER_COUNTY, CUSTOMER_COUNTRY
--  070131         and ADDR_FLAG. Changed error message raised when changing delivery information to a warning message.
--  070131         Added method Discon_Partial_Del_Lines___ to disconnect Partially delivered lines from Closed shipments.
--  070131  RaNhlk Added new columns multi_lot_batch_per_pallet,shipment_uncon_struct,shipment_measure_edit.
--  070131         Modified methods Unpack_Check_Upadate__, complete__,Get_Multi_Lot_Batch_Per_Pal_Db.
--  070131         Added a implementation method Check_Shipment_Qty_Diff___.
--  070123  SuSalk Removed Ship_via_desc from the code.
--  070118  SuSalk Changed Mpccom_Ship_Via_API.Get_Description method calls.
--  061114  MiErlk Bug 61679, Changed the size of the variable company_ in function Get_Collect_Charge_Currency.
--  060926  ChBalk Increased the length of the column shipper_name to 100.
--  060817  IsWilk Modifued the length of the addr_1_ in PROCEDURE Update___.
--  060728  ChJalk Replaced Mpccom_Ship_Via_Desc with Mpccom_Ship_Via.
--  060728  KaDilk Make ship via desc and delivery term desc language independant.
--  060602  YaJalk Bug 58461, Modified functions Unpack_Check_Insert___, Unpack_Check_Update___
--  060602         to check whether entered location is a shipment location.
--  060517  MiErlk   Enlarge Identity - Changed view comment
--  060418  NaLrlk Enlarge Identity - Changed view comments of deliver_to_customer_no.
--  ------------------------- 13.4.0 -----------------------------------------------
--  060320  IsAnlk Modified Unpack_Check_Update___ to enable printing when shipment is closed.
--  060316   RaKalk Added function Get_Multi_Lot_Batch_Per_Pal_Db
--  060304  JaBalk Raised the error message NOCHANGECLOSSHIP if shipment is closed.
--  060228  NiDalk Added the method All_Lines_Delivered__.
--  060225  JaJalk Added the method Get_Connected_Shipments to fetch all the connected shipments to particular CO.
--  060224  GeKalk Modified client_state_list_ to correct spell errors.
--  051227  RaKalk Added method Cancel_Shipment_Allowed__ and Cancel_Shipment__
--  051223  RaKalk Added state Canceled.
--  051223         and added the error message to block the modifications of canceled shipments
--  051223  SuJalk Added the function Check_For_Invoiced_Order_Lines.
--  050920  MaEelk Removed unused variables
--  050714  SaJjlk Added method Complete_Shipment__.
--  050218  NuFilk Added new not nullable column BILL_OF_LADING_PRINTED.
--  050203  UsRalk Removed SHIPMENT_LOCATION_DB from Prepare_Insert___.
--  050201  UsRalk Renamed ShipInventoryLoc to ShipInventoryLocationNo and removed ShipmentInventory.
--  050127  IsAnlk Added nullable columns SHIPMENT_INVENTORY,SHIP_INVENTORY_LOC to SHIPMENT_TAB.
--  050117  UsRalk Renamed CustomerNo attribute to DeliverToCustomerNo.
--  050105  NuFilk Added Procedure Close, Complete and Lock_By_Keys__.
--  050103  JaBalk Added Procedure:New.
--  040329  JoEd   Added default values in Prepare_Insert___.
--  040308  JoEd   Changed comments for Shipper_ID.
--  040226  IsWilk Removed the SUBSTRB for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  040121  JoEd   Added method Check_Shipper__ due to upgrade of SiteDeliveryAddress (now CompanyAddress).
--  021104  PrInLk Made minor modifications to ship_date handling.
--  021024  PrInLk Moved a part of the implementation All_Line_Delivered___,All_Lines_Picked___ into
--                 Shipment_Handling_Utility_Api.
--  021021  PrInLk Added the method Set_Ship_Date.
--  021016  GeKaLk Modified Get_State() to get the rowstate from the shipment table.
--  021011  GeKaLk Added Get_State() to get the state of the shipment.
--  020801  JoAnSe Added initialization of note_id in Insert___
--  020607  MaGu   Removed methods Get_No_Of_Packages and Get_No_Of_Pallets. Moved these methods
--                 to utility LU Shipment_Handling_Utility.
--  020513  MaGu   Modified method Complete__. Added creation of delivery note and removed automatic
--                 sending of dispatch advice.
--  020508  PrInLk Modified the method Complete__ to have a control for quantities in package structure
--                 and shipment order line picked quantities.
--  020507  MaGu   Modified method No_Delivered_Lines___.
--  020506  PrInLk Modify the method Complete__. Send the Dispatch Advice automatically if that
--                 setup has been used by the customer.
--  020502  MaGu   Added call to General_SYS.Init_Method in method Set_Print_Flags.
--  020430  PrInLk Added public methods Get_No_Of_Packages and Get_No_Of_Pallets.
--  020426  MaGu   Modified method All_Lines_Picked___ to enable handling of Partially Delivered lines.
--  020424  MaGu   Modified methods Complete_Shipment_Allowed__, Reopen_Shipment_Allowed__ and
--                 Close_Shipment_Allowed__.
--  020423  MaGu   Added methods Complete_Shipment_Allowed__, Reopen_Shipment_Allowed__ and
--                 Close_Shipment_Allowed__.
--  020422  MaGu   Modified methods All_Lines_Delivered___, All_Lines_Picked___
--                 and No_Delivered_Lines___.
--  020418  MaGu   Added fetch of default contract to method Prepare_Insert___.
--  020417  MaGu   Added new states to statemachine.
--  020417  ZiMo   Modified Update___ to fetch addr1 correctly.
--  020317  ZiMo   Added ship_date.
--  020313  MaGu   Added update of Delivery note in method Update___. Added check in
--                 method Unpack_Check_Update___ so that you cannot change ship_addr_no if there
--                 are any lines connected to the shipment.
--  020306  ZiMo   Modified Set_Print_Flags to not clear the info mesassages.
--  020305  PrInLk Added public methods Get_Collect_Charge and Get_Collect_Charge_Currency
--                 to support defining charges to shipment.
--  020228  ZiMo   Added method Set_Print_Flags().
--  020206  PrInLk Added implementation method Any_Connected_Lines to check whether
--                 there are any connected lines to the shipment. If there are connected
--                 lines no changes allowed to delivery information.
--  020109  PrInLk Added public attributes Consignment Note No,
--                 Destination,Place of Departure,Consignee reference,
--                 Sender Reference,Pro No,Airway Bill No,Remit COD to.
--  020103  MaGu   Replaced variable &viewtab with shipment_tab.
--  011227  PrInLk Added public attribute Shipper_Name
--  011203  MaGu   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Shipment_Id_Tab IS TABLE OF NUMBER INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;
string_null_ CONSTANT VARCHAR2(11)        := Database_SYS.string_null_;
number_null_ CONSTANT NUMBER              := -9999999999;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Shipment_Qty_Diff___ (
   rec_  IN OUT SHIPMENT_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
  allow_unconnected_structure_ BOOLEAN;
BEGIN
   allow_unconnected_structure_ := Unconnected_Struct_Allowed___(rec_.shipment_id);
   IF NOT(allow_unconnected_structure_) THEN
      Shipment_Handling_Utility_API.Any_Shipment_Qty_Deviation(rec_.shipment_id);
   END IF;
END Check_Shipment_Qty_Diff___;


PROCEDURE Create_Shipment_Del_Note___ (
   rec_  IN OUT SHIPMENT_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   delivery_note_no_ VARCHAR2(15);
BEGIN
   IF (Normal_Shipment___(rec_)) THEN      
      Create_Delivery_Note_API.Create_Shipment_Deliv_Note(delivery_note_no_, rec_.shipment_id);     
   END IF;
END Create_Shipment_Del_Note___;


-- Discon_Partial_Del_Lines___
--   This method is used to set the Shipment_connected attribute on Customer
--   Order Line to 'FALSE' for partially delivered lines when the Shipment is
--   in 'Closed' state.
PROCEDURE Discon_Partial_Del_Lines___ (
   rec_  IN OUT SHIPMENT_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS   
BEGIN
   IF (Normal_Shipment___(rec_)) THEN
      IF(Source_Ref_Type_Exist(rec_.shipment_id, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Shipment_Order_Utility_API.Discon_Partial_Del_Lines(rec_.shipment_id);
         $ELSE
            NULL;
         $END
      END IF;
   END IF;
END Discon_Partial_Del_Lines___;

PROCEDURE All_Lines_Has_Doc_Address___ (
   rec_  IN OUT SHIPMENT_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS   
BEGIN   
   Shipment_Source_Utility_API.All_Lines_Has_Doc_Address(rec_.shipment_id);   
END All_Lines_Has_Doc_Address___;

PROCEDURE Refresh_Parent___ (
   rec_  IN OUT SHIPMENT_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Refresh_Parent__(rec_.parent_consol_shipment_id);
END Refresh_Parent___;


FUNCTION All_Lines_Delivered___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Shipment_Delivered___(rec_.shipment_id) = Fnd_Boolean_API.DB_TRUE);
END All_Lines_Delivered___;


FUNCTION All_Lines_Picked___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   all_lines_picked_ VARCHAR2(5);
BEGIN
   all_lines_picked_ := All_Lines_Picked(rec_.shipment_id);
   RETURN (all_lines_picked_ = 'TRUE');
END All_Lines_Picked___;


FUNCTION All_Shipments_Cancelled___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER := 0;   
   
   CURSOR get_shipments IS
      SELECT 1
      FROM   SHIPMENT_TAB
      WHERE  ROWSTATE != 'Cancelled'
      AND    parent_consol_shipment_id = rec_.shipment_id;  
   
BEGIN
   IF (shipments_connected__(rec_.shipment_id) = 1) THEN
      OPEN get_shipments;
      FETCH get_shipments INTO found_;  
      CLOSE get_shipments;
   ELSE
      found_ := 1;
   END IF;
   RETURN (found_ = 0);  
END All_Shipments_Cancelled___;


FUNCTION All_Shipments_Closed___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER := 0;   
   
   CURSOR get_shipments IS
      SELECT 1
      FROM   SHIPMENT_TAB
      WHERE  ROWSTATE NOT IN ('Cancelled','Closed')
      AND    parent_consol_shipment_id = rec_.shipment_id;   
BEGIN
   IF (shipments_connected__(rec_.shipment_id) = 1) THEN
      OPEN get_shipments;
      FETCH get_shipments INTO found_;  
      CLOSE get_shipments;
      IF (found_ = 0) THEN
         IF (All_Shipments_Cancelled___(rec_)) THEN
            found_ := 1;
         END IF; 
      END IF;   
   ELSE
      found_ := 1;
   END IF;
   RETURN (found_ = 0);
END All_Shipments_Closed___;


FUNCTION Completed_Shipments_Exist___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER := 0;
   
   CURSOR get_shipments IS
      SELECT 1
      FROM   SHIPMENT_TAB
      WHERE  ROWSTATE = 'Completed'
      AND    parent_consol_shipment_id = rec_.shipment_id; 
BEGIN
  IF NOT (Preliminary_Shipments_Exist___(rec_)) THEN     
     OPEN get_shipments;
     FETCH get_shipments INTO found_;   
     CLOSE get_shipments;            
   END IF;
   RETURN (found_ = 1);
END Completed_Shipments_Exist___;


FUNCTION Consolidated_Shipment___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (rec_.shipment_category = 'CONSOLIDATED');
END Consolidated_Shipment___;


FUNCTION No_Lines_In_Shipment___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN ((Normal_Shipment___(rec_)) AND
          (Connected_Lines_Exist(rec_.shipment_id) = 0) AND
          (Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(rec_.shipment_id) = Fnd_Boolean_API.DB_FALSE)) OR
          ((Consolidated_Shipment___(rec_)) AND (Shipments_Connected__(rec_.shipment_id)= 0));
END No_Lines_In_Shipment___;


FUNCTION No_Shipments_Connected___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Shipments_Connected__(rec_.shipment_id)= 0);
END No_Shipments_Connected___;


FUNCTION Normal_Shipment___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (rec_.shipment_category = 'NORMAL');
END Normal_Shipment___;


FUNCTION Not_Delivered___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Shipment_Delivered___(rec_.shipment_id) = 'FALSE');
END Not_Delivered___;


FUNCTION Parent_Exists___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (rec_.parent_consol_shipment_id IS NOT NULL);
END Parent_Exists___;


FUNCTION Handl_Unit_History_Exists___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Handling_Unit_History_API.Shipment_Id_Exists(rec_.shipment_id));
END Handl_Unit_History_Exists___;


FUNCTION Preliminary_Shipments_Exist___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER := 0;
   
   CURSOR get_shipments IS
      SELECT 1
      FROM   SHIPMENT_TAB
      WHERE  ROWSTATE = 'Preliminary'
      AND    parent_consol_shipment_id = rec_.shipment_id; 
BEGIN  
   OPEN get_shipments;
   FETCH get_shipments INTO found_;   
   CLOSE get_shipments;
   RETURN (found_ = 1); 
END Preliminary_Shipments_Exist___;


PROCEDURE Do_Undo_Shipment_Delivery___ (
   rec_  IN OUT NOCOPY shipment_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR get_shipments(shipment_id_ IN NUMBER) IS
      SELECT shipment_id, actual_ship_date
        FROM SHIPMENT_TAB
       WHERE rowstate != 'Cancelled'
         AND parent_consol_shipment_id = shipment_id_;
BEGIN
   IF rec_.shipment_category = 'CONSOLIDATED' THEN
      FOR ship_rec_ IN get_shipments(rec_.shipment_id) LOOP
         Do_Undo_Shipment_Delivery___(ship_rec_.shipment_id, ship_rec_.actual_ship_date);
      END LOOP;         
   ELSE
      Do_Undo_Shipment_Delivery___(rec_.shipment_id, rec_.actual_ship_date);
   END IF;
END Do_Undo_Shipment_Delivery___;


PROCEDURE Do_Undo_Shipment_Delivery___ (
   shipment_id_      IN NUMBER,
   actual_ship_date_ IN DATE )
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
   undo_complete_          BOOLEAN := FALSE;
   delnote_no_             NUMBER;   
BEGIN   
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, Get_Source_Ref_Type_Db(shipment_id_));
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Shipment_Order_Utility_API.Do_Undo_Shipment_Delivery(undo_complete_, delnote_no_, shipment_id_);
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');          
         $END
      ELSIF (source_ref_type_list_(i_) IN (Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN, Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES )) THEN
         Shipment_Delivery_Utility_API.Do_Undo_Shipment_Delivery(undo_complete_, delnote_no_, shipment_id_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'UNDODELNOTSUPP: Currently, Undo Delivery is not supported for :P1.', Logistics_Source_Ref_Type_API.Decode(source_ref_type_list_(i_)));
      END IF;
   END LOOP;
   
   IF (undo_complete_) THEN
      -- Set actual ship date to null
      IF (actual_ship_date_ IS NOT NULL AND Shipment_Delivered___(shipment_id_) = Fnd_Boolean_API.DB_FALSE) THEN            
         Modify_Actual_Ship_Date___(shipment_id_, NULL);
      END IF;
      -- Set delivery note print flag to false
      IF (Delivery_Note_API.Get_Objstate(delnote_no_) != 'Invalid') THEN
         Delivery_Note_API.Set_Invalid(delnote_no_);
         Shipment_API.Set_Print_Flags(shipment_id_, 'DEL_NOTE_PRINTED_DB' , 'N');
      END IF;
   END IF;
END Do_Undo_Shipment_Delivery___;


-- Removes the Handling Unit history of the shipment and reconnects
-- the Handling Units with ShipmentReservHandlUnit-records to the shipment again.
PROCEDURE Remove_Handl_Unit_History___ (
   rec_  IN OUT NOCOPY SHIPMENT_TAB%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   CURSOR get_root_handling_units IS
      SELECT DISTINCT Handling_Unit_API.Get_Root_Handling_Unit_Id(handling_unit_id) handling_unit_id
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB
       WHERE shipment_id = rec_.shipment_id;
BEGIN
   FOR root_hu_rec_ IN get_root_handling_units LOOP
      IF (NVL(Handling_Unit_API.Get_Shipment_Id(root_hu_rec_.handling_unit_id), 0) != rec_.shipment_id) THEN
         Handling_Unit_API.Modify_Shipment_Id(root_hu_rec_.handling_unit_id, rec_.shipment_id);
      END IF;
   END LOOP;
   
   -- Remove the old handling unit history.
   Handling_Unit_History_API.Remove_By_Shipment_Id(rec_.shipment_id);
END Remove_Handl_Unit_History___;

   
FUNCTION Undo_Shipment_Allowed___ (
   rec_  IN     shipment_tab%ROWTYPE ) RETURN BOOLEAN
IS
   
BEGIN
   RETURN (NOT Not_Delivered___(rec_)) OR (Consolidated_Shipment___(rec_) AND Any_Delivered_Shipments___(rec_.shipment_id));
END Undo_Shipment_Allowed___;


FUNCTION Cancel_Shipment_Allowed___ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF (Get_Objstate(shipment_id_) IN ('Preliminary','Completed'))  AND
      (Connected_Lines_Exist(shipment_id_) = 0) AND
      (Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(shipment_id_) = Fnd_Boolean_API.DB_FALSE) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Cancel_Shipment_Allowed___;


FUNCTION Complete_Shipment_Allowed___ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   rec_     SHIPMENT_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(shipment_id_);
   IF (rec_.rowstate = 'Preliminary')  AND (Connected_Lines_Exist(shipment_id_) = 1) THEN
      IF (All_Lines_Picked___(rec_)) THEN
         allowed_ := 1;
      ELSE
         allowed_ := 0;
      END IF;
   END IF;

   RETURN allowed_;
END Complete_Shipment_Allowed___;


FUNCTION Close_Shipment_Allowed___ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   rec_     SHIPMENT_TAB%ROWTYPE;   
BEGIN
   rec_ := Get_Object_By_Keys___(shipment_id_);
   IF (rec_.rowstate = 'Completed') THEN
      IF (All_Lines_Delivered___(rec_)) THEN
         allowed_ := 1;
      ELSE
         allowed_ := 0;
      END IF;
   END IF;

  RETURN allowed_;
END Close_Shipment_Allowed___;


FUNCTION Shipment_Delivered___ (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_              NUMBER;
   shipment_delivered_ VARCHAR2(5):= 'FALSE';

   CURSOR get_delivered_lines IS  
      SELECT 1
      FROM   SHIPMENT_LINE_TAB
      WHERE  shipment_id = shipment_id_ 
      AND    qty_shipped > 0;
BEGIN  
   OPEN get_delivered_lines;
   FETCH get_delivered_lines INTO dummy_;
   IF (get_delivered_lines%FOUND) THEN
      shipment_delivered_ := 'TRUE';
   END IF;
   CLOSE get_delivered_lines;

   RETURN shipment_delivered_;
END Shipment_Delivered___;


-- Unconnected_Structure_Allowed___
--   This method checks whether Unconnected Structure is allowed
--   for a given Shipment Number.
FUNCTION Unconnected_Struct_Allowed___ (
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   allow_uncon_struct_    VARCHAR2(5);
   order_connect_         BOOLEAN := FALSE;
   ship_handl_unit_exist_ VARCHAR2(5) := 'FALSE';
   
   CURSOR get_handling_units IS
      SELECT handling_unit_id
        FROM shpmnt_handl_unit_with_history
       WHERE shipment_id = shipment_id_;    
BEGIN
   allow_uncon_struct_ := Get_Shipment_Uncon_Struct_Db(shipment_id_);
   FOR handl_unit_rec_ IN get_handling_units LOOP
      ship_handl_unit_exist_ := Shipment_Line_Handl_Unit_API.Handling_Unit_Exist(shipment_id_, handl_unit_rec_.handling_unit_id);
      IF (ship_handl_unit_exist_ = 'FALSE') THEN
         order_connect_ := FALSE;
      ELSE
         order_connect_ := TRUE;
         EXIT;
      END IF;
   END LOOP;
   RETURN ((allow_uncon_struct_ = 'TRUE') AND NOT(order_connect_));
END Unconnected_Struct_Allowed___;


FUNCTION Get_Operational_Volume___ (
   shipment_id_    IN NUMBER,
   uom_for_volume_ IN VARCHAR2 ) RETURN NUMBER
IS
   lu_rec_                   SHIPMENT_TAB%ROWTYPE;
   operational_volume_       SHIPMENT_TAB.manual_volume%TYPE := 0;
   remain_parcel_qty_volume_ SHIPMENT_TAB.manual_volume%TYPE := 0; 
   part_catalog_rec_         Part_Catalog_API.Public_Rec;
   conversion_factor_        NUMBER;   
   unit_conv_volume_         NUMBER;
   remain_parcel_qty_        NUMBER;    
   temp_volume_net_          NUMBER;      
   temp_source_unit_meas_    VARCHAR2(10);
   temp_unit_code_           VARCHAR2(30);
   temp_uom_for_volume_net_  VARCHAR2(30);
   temp_source_part_no_      VARCHAR2(25); 
   
   CURSOR get_shipment_lines IS  
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, inventory_part_no, 
             source_part_no, source_unit_meas, conv_factor, inverted_conv_factor
      FROM   SHIPMENT_LINE_TAB
      WHERE  shipment_id = shipment_id_ 
      AND    ((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND Utility_SYS.String_To_Number(source_ref4) <= 0)
             OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER));
BEGIN
   lu_rec_ := Get_Object_By_Keys___(shipment_id_);
   
   IF (lu_rec_.manual_volume IS NOT NULL) THEN
      operational_volume_ := lu_rec_.manual_volume;
   ELSE
      IF (lu_rec_.shipment_uncon_struct = Fnd_Boolean_API.DB_FALSE OR
         (lu_rec_.shipment_uncon_struct = Fnd_Boolean_API.DB_TRUE AND Shipment_Structure_Exist(shipment_id_) = 'FALSE')) THEN
         FOR line_rec_ IN get_shipment_lines LOOP 
            remain_parcel_qty_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_id_        => shipment_id_, 
                                                                                            source_ref1_        => line_rec_.source_ref1, 
                                                                                            source_ref2_        => line_rec_.source_ref2, 
                                                                                            source_ref3_        => line_rec_.source_ref3, 
                                                                                            source_ref4_        => line_rec_.source_ref4, 
                                                                                            source_ref_type_db_ => line_rec_.source_ref_type);
            IF (remain_parcel_qty_ > 0) THEN
               part_catalog_rec_  := Part_Catalog_API.Get(line_rec_.source_part_no);
               IF (part_catalog_rec_.volume_net IS NULL) THEN
                  part_catalog_rec_  := Part_Catalog_API.Get(line_rec_.inventory_part_no);
               END IF;   
               
               -- If the source_unit_meas and unit_code is the same as the previous iteration in the FOR-loop we don't need
               -- to fetch the conversion factor again.
               IF ((NVL(temp_source_unit_meas_, Database_SYS.string_null_) != line_rec_.source_unit_meas) OR 
                   (NVL(temp_unit_code_, Database_SYS.string_null_)        != part_catalog_rec_.unit_code) OR
                   (NVL(temp_source_part_no_,Database_SYS.string_null_)    != line_rec_.source_part_no)) THEN
                   conversion_factor_       := Technical_Unit_Conv_API.Get_Valid_Conv_Factor(unit_        => line_rec_.source_unit_meas, 
                                                                                             alt_unit_    => part_catalog_rec_.unit_code);
                   temp_source_unit_meas_   := line_rec_.source_unit_meas;
                   temp_unit_code_          := part_catalog_rec_.unit_code;
                   temp_source_part_no_     := line_rec_.source_part_no;
               END IF;
               conversion_factor_ := NVL(conversion_factor_, line_rec_.conv_factor / line_rec_.inverted_conv_factor);

               IF (part_catalog_rec_.volume_net IS NOT NULL) THEN 
                  -- If the part catalog net volume and uom for net volume is the same as the previous iteration in the FOR-loop we don't
                  -- need to fetch the unit converted volume again.
                  IF ((NVL(temp_volume_net_, 0) != part_catalog_rec_.volume_net) OR 
                      (NVL(temp_uom_for_volume_net_, Database_SYS.string_null_) != part_catalog_rec_.uom_for_volume_net)) THEN
                      unit_conv_volume_        := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => part_catalog_rec_.volume_net,
                                                                                           from_unit_code_   => part_catalog_rec_.uom_for_volume_net,
                                                                                           to_unit_code_     => uom_for_volume_);
                      temp_volume_net_         := part_catalog_rec_.volume_net;
                      temp_uom_for_volume_net_ := part_catalog_rec_.uom_for_volume_net;
                  END IF;
               ELSE
                  unit_conv_volume_ := 0;
                  temp_volume_net_         := part_catalog_rec_.volume_net;
                  temp_uom_for_volume_net_ := part_catalog_rec_.uom_for_volume_net;
               END IF;

               remain_parcel_qty_volume_ := remain_parcel_qty_volume_ + (remain_parcel_qty_ * unit_conv_volume_ * conversion_factor_);        
            END IF;
         END LOOP;
      END IF;
      operational_volume_ := remain_parcel_qty_volume_ + Handling_Unit_Ship_Util_API.Get_Ship_Operat_Volume(shipment_id_, uom_for_volume_);
   END IF;
   
   RETURN operational_volume_;
END Get_Operational_Volume___;

PROCEDURE Get_Net_And_Adjusted_Weight___ (
   net_weight_           OUT NUMBER,
   adj_net_weight_       OUT NUMBER,
   shipment_id_          IN  NUMBER,
   uom_for_weight_       IN  VARCHAR2,
   shipment_line_no_     IN  NUMBER  )
IS   
   part_catalog_rec_            Part_Catalog_API.Public_Rec;
   conversion_factor_           NUMBER;
   weight_                      NUMBER;
   adj_weight_                  NUMBER;
   unit_conv_weight_            NUMBER;
   contract_                    VARCHAR2(5);
   temp_weight_net_             NUMBER := 0;
   temp_source_unit_meas_       VARCHAR2(10);
   temp_unit_code_              VARCHAR2(30);   
   temp_uom_for_weight_net_     VARCHAR2(30);
   temp_source_part_no_         VARCHAR2(25); 
   non_manual_net_weight_qty_   NUMBER;
   sum_manual_net_weight_qty_   NUMBER;
   sum_manual_net_weight_       NUMBER;
   configuration_id_             VARCHAR2(50);
   rec_net_weight_               NUMBER;
   rec_weight_unit_code_         VARCHAR2(30);
   config_weight_exists_         BOOLEAN := FALSE;
   
   CURSOR get_shipment_lines IS  
      SELECT shipment_line_no, source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, source_part_no, 
             source_unit_meas, conv_factor, inverted_conv_factor, connected_source_qty, inventory_part_no 
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id = shipment_id_
         AND shipment_line_no = NVL(shipment_line_no_, shipment_line_no)
         AND ((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND Utility_SYS.String_To_Number(source_ref4) <= 0)
             OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER));
BEGIN
   contract_ := Shipment_API.Get_Contract(shipment_id_);
   
   FOR line_rec_ IN get_shipment_lines LOOP       
      part_catalog_rec_ := Part_Catalog_API.Get(line_rec_.source_part_no);
      configuration_id_ := Shipment_Source_Utility_API.Get_Configuration_Id(line_rec_.source_ref1, 
                                                                            line_rec_.source_ref2, 
                                                                            line_rec_.source_ref3, 
                                                                            line_rec_.source_ref4, 
                                                                            line_rec_.source_ref_type);
      config_weight_exists_ := FALSE;

      -- If the source_unit_meas and unit_code is the same as the previous iteration in the FOR-loop we don't need
      -- to fetch the conversion factor again.
      IF ((NVL(temp_source_unit_meas_, Database_SYS.string_null_)   != line_rec_.source_unit_meas) OR 
          (NVL(temp_unit_code_, Database_SYS.string_null_)          != part_catalog_rec_.unit_code) OR 
          (NVL(temp_source_part_no_,Database_SYS.string_null_)      != line_rec_.source_part_no)) THEN
         conversion_factor_     := Technical_Unit_Conv_API.Get_Valid_Conv_Factor(unit_      => line_rec_.source_unit_meas, 
                                                                                 alt_unit_  => part_catalog_rec_.unit_code);
         temp_source_unit_meas_ := line_rec_.source_unit_meas;
         temp_unit_code_        := part_catalog_rec_.unit_code;
         temp_source_part_no_   := line_rec_.source_part_no;
      END IF;
      conversion_factor_ := NVL(conversion_factor_, line_rec_.conv_factor / line_rec_.inverted_conv_factor); 
      
      Fetch_Manual_Net_Weight_Info___(sum_manual_net_weight_qty_, sum_manual_net_weight_, shipment_id_, line_rec_.shipment_line_no);
      non_manual_net_weight_qty_ := line_rec_.connected_source_qty - NVL(sum_manual_net_weight_qty_, 0);
      IF (configuration_id_ != '*') THEN
         $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
            DECLARE
               configuration_spec_rec_   Configuration_Spec_API.Public_Rec;
            BEGIN
               configuration_spec_rec_ := Configuration_Spec_API.Get(line_rec_.source_part_no, configuration_id_);
               IF (configuration_spec_rec_.net_weight IS NOT NULL) THEN
                  rec_net_weight_        := configuration_spec_rec_.net_weight;
                  rec_weight_unit_code_  := configuration_spec_rec_.weight_unit_code;
                  config_weight_exists_  := TRUE;
               ELSE 
                  rec_net_weight_        := 0;
                  rec_weight_unit_code_  := NULL;
               END IF;
            END;
         $ELSE
            NULL;
         $END
      END IF;
      IF (NOT config_weight_exists_) THEN
         IF (part_catalog_rec_.weight_net IS NOT NULL) THEN
            rec_net_weight_           := part_catalog_rec_.weight_net;
            rec_weight_unit_code_     := part_catalog_rec_.uom_for_weight_net;
         ELSE 
            rec_net_weight_           := 0;
            rec_weight_unit_code_     := NULL;
         END IF;
      END IF;
      
      -- If the part catalog net weight and uom for net weight is the same as the previous iteration in the FOR-loop we don't
      -- need to fetch the unit converted weight again.
      IF ((temp_weight_net_ != rec_net_weight_) OR 
          (NVL(temp_uom_for_weight_net_, Database_SYS.string_null_) != rec_weight_unit_code_)) THEN
         unit_conv_weight_          := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_  => rec_net_weight_,
                                                                                from_unit_code_ => rec_weight_unit_code_,
                                                                                to_unit_code_   => uom_for_weight_);
         temp_weight_net_           := rec_net_weight_;
         temp_uom_for_weight_net_   := rec_weight_unit_code_;
      END IF;
      
      -- and moved adj_weight_ calculation to a common location
      weight_       := NVL((non_manual_net_weight_qty_ * unit_conv_weight_ * conversion_factor_) + NVL(sum_manual_net_weight_, 0), sum_manual_net_weight_);
      
      adj_weight_   := weight_ * part_catalog_rec_.freight_factor;
      
      -- Fetch weight and adjusted weight from Inventory Part when unable to get it from Sales Part.
      IF (weight_ IS NULL) THEN
         weight_       := (NVL(non_manual_net_weight_qty_, 0) * Inventory_Part_API.Get_Weight_Net(contract_, line_rec_.inventory_part_no) * 
                          (line_rec_.conv_factor / line_rec_.inverted_conv_factor)) + NVL(sum_manual_net_weight_, 0);
                             
         adj_weight_   := weight_ * Part_Catalog_API.Get_Freight_Factor(line_rec_.inventory_part_no);
      END IF;

      net_weight_     := NVL(net_weight_, 0) + NVL(weight_, 0);   
      adj_net_weight_ := NVL(adj_net_weight_, 0) + NVL(adj_weight_, 0);
      sum_manual_net_weight_ := 0;
   END LOOP;
END Get_Net_And_Adjusted_Weight___;


-- Fetches the sum of the quantities with manual net weights set, and 
-- the sum of the manual net weights for a particular shipment line.
PROCEDURE Fetch_Manual_Net_Weight_Info___ (
   sum_manual_quantity_    OUT NUMBER,
   sum_manual_net_weight_  OUT NUMBER,
   shipment_id_            IN NUMBER,
   shipment_line_no_       IN NUMBER)
IS
   CURSOR get_info IS
      SELECT SUM(quantity), SUM(manual_net_weight) 
      FROM shipment_line_handl_unit_tab 
      WHERE shipment_id = shipment_id_ 
      AND shipment_line_no = shipment_line_no_ 
      AND manual_net_weight IS NOT NULL 
      GROUP BY shipment_id, shipment_line_no;
BEGIN
   OPEN get_info;
   FETCH get_info INTO sum_manual_quantity_, sum_manual_net_weight_;
   CLOSE get_info;   
END Fetch_Manual_Net_Weight_Info___;


FUNCTION Get_Op_Gross_Weight___ (
   shipment_id_          IN NUMBER,
   uom_for_weight_       IN VARCHAR2,
   apply_freight_factor_ IN VARCHAR2 ) RETURN NUMBER
IS
   lu_rec_                       SHIPMENT_TAB%ROWTYPE;
   freight_factor_               NUMBER := 1;  
   part_catalog_rec_             Part_Catalog_API.Public_Rec;
   remain_parcel_qty_weight_     SHIPMENT_TAB.manual_gross_weight%TYPE := 0;
   operational_gross_weight_     SHIPMENT_TAB.manual_gross_weight%TYPE := 0;
   apply_freight_factor_boolean_ BOOLEAN := FALSE;     
   conversion_factor_            NUMBER;
   unit_conv_weight_             NUMBER := 0;
   net_weight_                   NUMBER;
   adj_net_weight_               NUMBER;
   remain_parcel_qty_            NUMBER;
   temp_weight_net_              NUMBER := 0;
   temp_source_unit_meas_        VARCHAR2(10);
   temp_unit_code_               VARCHAR2(30);
   temp_uom_for_weight_net_      VARCHAR2(30);
   temp_source_part_no_          VARCHAR2(25); 
   configuration_id_             VARCHAR2(50);
   rec_net_weight_               NUMBER := 0;
   rec_weight_unit_code_         VARCHAR2(30);
   config_weight_exists_         BOOLEAN := FALSE;
   
   CURSOR get_shipment_lines IS  
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, source_part_no, 
             source_unit_meas, conv_factor, inverted_conv_factor, inventory_part_no
      FROM   SHIPMENT_LINE_TAB
      WHERE  shipment_id = shipment_id_ 
      AND    ((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND Utility_SYS.String_To_Number(source_ref4) <= 0)
             OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER));
      
BEGIN
   lu_rec_ := Get_Object_By_Keys___(shipment_id_);
   apply_freight_factor_boolean_ := (apply_freight_factor_ = Fnd_Boolean_Api.DB_TRUE);
   
   IF (lu_rec_.manual_gross_weight IS NULL) THEN
      IF (lu_rec_.shipment_uncon_struct = Fnd_Boolean_API.DB_FALSE OR 
         (lu_rec_.shipment_uncon_struct = Fnd_Boolean_API.DB_TRUE AND Shipment_Structure_Exist(shipment_id_) = 'FALSE')) THEN
         FOR line_rec_ IN get_shipment_lines LOOP             
            remain_parcel_qty_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_id_        => shipment_id_, 
                                                                                            source_ref1_        => line_rec_.source_ref1, 
                                                                                            source_ref2_        => line_rec_.source_ref2, 
                                                                                            source_ref3_        => line_rec_.source_ref3, 
                                                                                            source_ref4_        => line_rec_.source_ref4, 
                                                                                            source_ref_type_db_ => line_rec_.source_ref_type);
            IF (remain_parcel_qty_ > 0) THEN
               part_catalog_rec_  := Part_Catalog_API.Get(line_rec_.source_part_no);
               configuration_id_ := Shipment_Source_Utility_API.Get_Configuration_Id(line_rec_.source_ref1, 
                                                                                     line_rec_.source_ref2, 
                                                                                     line_rec_.source_ref3, 
                                                                                     line_rec_.source_ref4, 
                                                                                     line_rec_.source_ref_type);
               config_weight_exists_ := FALSE;
               
               IF ((NVL(temp_source_unit_meas_, Database_SYS.string_null_)  != line_rec_.source_unit_meas) OR 
                   (NVL(temp_unit_code_, Database_SYS.string_null_)         != part_catalog_rec_.unit_code) OR 
                   (NVL(temp_source_part_no_,Database_SYS.string_null_)     != line_rec_.source_part_no)) THEN
                  conversion_factor_        := Technical_Unit_Conv_API.Get_Valid_Conv_Factor(unit_      => line_rec_.source_unit_meas, 
                                                                                             alt_unit_  => part_catalog_rec_.unit_code);
                  temp_source_unit_meas_    := line_rec_.source_unit_meas;
                  temp_unit_code_           := part_catalog_rec_.unit_code;
                  temp_source_part_no_   := line_rec_.source_part_no;
               END IF;
               conversion_factor_ := NVL(conversion_factor_, line_rec_.conv_factor / line_rec_.inverted_conv_factor);
               
               IF (configuration_id_ != '*') THEN
                  $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
                     DECLARE
                        configuration_spec_rec_   Configuration_Spec_API.Public_Rec;
                     BEGIN
                        configuration_spec_rec_ := Configuration_Spec_API.Get(line_rec_.source_part_no, configuration_id_);
                        IF (configuration_spec_rec_.net_weight IS NOT NULL) THEN
                           rec_net_weight_        := configuration_spec_rec_.net_weight;
                           rec_weight_unit_code_  := configuration_spec_rec_.weight_unit_code;
                           config_weight_exists_  := TRUE;
                        END IF;
                     END;
                  $ELSE
                     NULL;
                  $END
               END IF;
               IF (NOT config_weight_exists_) THEN
                  IF (part_catalog_rec_.weight_net IS NOT NULL) THEN
                     rec_net_weight_          := part_catalog_rec_.weight_net;
                     rec_weight_unit_code_    := part_catalog_rec_.uom_for_weight_net;
                  ELSE
                     part_catalog_rec_  := Part_Catalog_API.Get(line_rec_.inventory_part_no);                     
                     rec_net_weight_          := part_catalog_rec_.weight_net;
                     rec_weight_unit_code_    := part_catalog_rec_.uom_for_weight_net;
                     conversion_factor_       := (line_rec_.conv_factor / line_rec_.inverted_conv_factor);                         
                  END IF;
               END IF;
               
               IF (apply_freight_factor_boolean_) THEN
                  freight_factor_          := part_catalog_rec_.freight_factor;
               END IF;
               IF (NVL(rec_net_weight_,0) != 0) THEN 
                  -- If the part catalog net weight and uom for net weight is the same as the previous iteration in the FOR-loop we don't
                  -- need to fetch the unit converted weight again.               
                  IF (temp_weight_net_ != rec_net_weight_ OR 
                     (NVL(temp_uom_for_weight_net_, Database_SYS.string_null_) != rec_weight_unit_code_)) THEN
                     unit_conv_weight_        := NVL(Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => rec_net_weight_, 
                                                                                              from_unit_code_   => rec_weight_unit_code_, 
                                                                                              to_unit_code_     => uom_for_weight_), 0);
                     temp_weight_net_         := rec_net_weight_;
                     temp_uom_for_weight_net_ := rec_weight_unit_code_;
                  END IF;
                  -- Needs to convert the weight into given Unit of Measure
                  remain_parcel_qty_weight_ := remain_parcel_qty_weight_ + remain_parcel_qty_ * unit_conv_weight_ * conversion_factor_ * freight_factor_;
               END IF;
            END IF;
         END LOOP;
      END IF;
      operational_gross_weight_ := remain_parcel_qty_weight_ + Handling_Unit_Ship_Util_API.Get_Ship_Operat_Gross_Weight(shipment_id_, uom_for_weight_, apply_freight_factor_);
   ELSE
      operational_gross_weight_ := lu_rec_.manual_gross_weight;
      IF (apply_freight_factor_boolean_) THEN
         Get_All_Net_Weight___(net_weight_, adj_net_weight_, shipment_id_, uom_for_weight_);
         operational_gross_weight_ := operational_gross_weight_ + (adj_net_weight_ - net_weight_);
      END IF;
   END IF;

   RETURN operational_gross_weight_;
END Get_Op_Gross_Weight___;


PROCEDURE Get_All_Net_Weight___ (
   net_weight_      OUT NUMBER,
   adj_net_weight_  OUT NUMBER,
   shipment_id_     IN  NUMBER,
   uom_for_weight_  IN  VARCHAR2 )
IS
   temp_net_weight_     NUMBER;
   temp_adj_net_weight_ NUMBER;
   
   CURSOR get_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  rowstate != 'Cancelled'
      AND    parent_consol_shipment_id = shipment_id_;
BEGIN
   IF (Get_Shipment_Category_Db(shipment_id_) = 'CONSOLIDATED') THEN
      FOR rec_ IN get_shipments LOOP
         Get_Net_And_Adjusted_Weight___(net_weight_       => temp_net_weight_, 
                                        adj_net_weight_   => temp_adj_net_weight_, 
                                        shipment_id_      => rec_.shipment_id, 
                                        uom_for_weight_   => uom_for_weight_,
                                        shipment_line_no_ => NULL);
                                        
         net_weight_     := NVL(net_weight_, 0) + temp_net_weight_;
         adj_net_weight_ := NVL(adj_net_weight_, 0) + temp_adj_net_weight_;
      END LOOP;  
   ELSE
      Get_Net_And_Adjusted_Weight___(net_weight_        => temp_net_weight_,
                                     adj_net_weight_    => temp_adj_net_weight_,
                                     shipment_id_       => shipment_id_,
                                     uom_for_weight_    => uom_for_weight_,
                                     shipment_line_no_  => NULL);
                                     
      net_weight_     := temp_net_weight_;
      adj_net_weight_ := temp_adj_net_weight_;
   END IF;
END Get_All_Net_Weight___;


PROCEDURE Validate_Capacities___ (
   rec_ IN SHIPMENT_TAB%ROWTYPE)
IS
   company_ site_tab.company%TYPE;
   com_dis_rec_   Company_Invent_Info_API.Public_Rec;
BEGIN
   company_       := Site_API.Get_Company(rec_.contract);
   com_dis_rec_   := Company_Invent_Info_API.Get(company_);
   IF (rec_.weight_capacity < Get_Operational_Gross_Weight(rec_.shipment_id, com_dis_rec_.uom_for_weight, 'FALSE')) THEN      
      Client_SYS.Add_Info(lu_name_, 'EXCEEDWEIGHTCAPACITY: Total operational gross weight of the connected shipments exceeds the weight capacity of the consolidated shipment :P1.', rec_.shipment_id);      
   END IF;
   IF (rec_.volume_capacity < Get_Operational_Volume(rec_.shipment_id, com_dis_rec_.uom_for_volume)) THEN
      Client_SYS.Add_Info(lu_name_, 'EXCEEDVOLUMECAPACITY: Total operational volume of the connected shipments exceeds the volume capacity of the consolidated shipment :P1.', rec_.shipment_id);
   END IF;
END Validate_Capacities___;


PROCEDURE Validate_Shipments___ (
   old_rec_ IN SHIPMENT_TAB%ROWTYPE,
   new_rec_ IN SHIPMENT_TAB%ROWTYPE)
IS
   state_           SHIPMENT_TAB.rowstate%TYPE;
   consol_ship_rec_ Public_Rec;
BEGIN
   IF (Shipment_Delivered___(new_rec_.shipment_id) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'SHIPMENTALREADYDELIVERED: The shipment :P1 cannot be connected or disconnected from a consolidated shipment when the shipment is delivered.', new_rec_.shipment_id);
   END IF;
   IF (Get_Consol_Actual_Ship_Date(NVL(old_rec_.parent_consol_shipment_id, new_rec_.parent_consol_shipment_id)) IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'CONSHIPDELIVERED: The shipment :P1 cannot be connected or disconnected from a consolidated shipment when the consolidated shipment is delivered.', new_rec_.shipment_id);
   END IF;
   IF (new_rec_.rowstate  = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'NOCHANGEINPARENTCONSHIPID: The shipment :P1 cannot be connected or disconnected from a consolidated shipment when the shipment is cancelled.', new_rec_.shipment_id);
   END IF;
   state_ := Get_Objstate(new_rec_.parent_consol_shipment_id);
   IF (new_rec_.parent_consol_shipment_id IS NOT NULL) THEN
      consol_ship_rec_ := Get(new_rec_.parent_consol_shipment_id);
      IF (state_ NOT IN ('Preliminary', 'Completed')) OR (consol_ship_rec_.shipment_category != 'CONSOLIDATED') THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDCONSOLSHIP: The shipment :P1 has to  be connected to a consolidated shipment in status :P2 or :P3.', new_rec_.shipment_id, Finite_State_Decode__('Preliminary'), Finite_State_Decode__('Completed'));
      END IF;
      IF (consol_ship_rec_.contract != new_rec_.contract) THEN
         Error_SYS.Record_General(lu_name_, 'SITEMISMATCH: The shipment :P1 cannot be connected to a consolidated shipment with a different site.', new_rec_.shipment_id);
      END IF;
   END IF;
   IF (state_ = 'Completed' OR Get_Auto_Connection_Blocked_Db(new_rec_.parent_consol_shipment_id) = 'TRUE') THEN
      Client_SYS.Add_Warning(lu_name_,'BLOCKEDORCOMPLETED: The consolidated shipment :P1 is completed or all the shipments connected to the consolidated shipment are blocked for automatic connection of more source lines. Do you still want to continue?', new_rec_.parent_consol_shipment_id);
   END IF;
END Validate_Shipments___;


FUNCTION Any_Unapproved_Shipments___ (
   consolidated_shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;
   dummy_   NUMBER;   
   
   CURSOR get_shipments IS
      SELECT 1
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = consolidated_shipment_id_      
      AND    approve_before_delivery = 'TRUE' 
      AND    rowstate IN ('Completed', 'Preliminary')
      AND    rownum = 1;
BEGIN
   OPEN get_shipments;
   FETCH get_shipments INTO dummy_;
   IF (get_shipments%FOUND) THEN
      allowed_ := 1;
   END IF;
   CLOSE get_shipments;
   RETURN allowed_;
END Any_Unapproved_Shipments___;


FUNCTION Any_Delivered_Shipments___ (
   consolidated_shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   exists_  BOOLEAN := FALSE;
   dummy_   NUMBER;   
   
   CURSOR get_shipments IS
      SELECT 1
      FROM   shipment_tab sh
      WHERE  sh.parent_consol_shipment_id = consolidated_shipment_id_      
      AND    sh.rowstate IN ('Completed', 'Closed')
      AND    rownum = 1
      AND EXISTS (SELECT 1
                  FROM   SHIPMENT_LINE_TAB shl
                  WHERE  shl.shipment_id = sh.shipment_id
                  AND    shl.qty_shipped > 0);
BEGIN
   OPEN get_shipments;
   FETCH get_shipments INTO dummy_;
   IF (get_shipments%FOUND) THEN
      exists_ := TRUE;
   END IF;
   CLOSE get_shipments;
   RETURN exists_;
END Any_Delivered_Shipments___;


-- Set_Values_On_Shipments___
--   Updates the values of route, ship via, forwarder, ship date, shipment type,
--   shipment location and auto connection blocked on Shipment(s) of the
--   NORMAL category if it is modified in corresponding parent CONSOLIDATED shipment.
PROCEDURE Set_Values_On_Shipments___ (
   new_cs_rec_ IN SHIPMENT_TAB%ROWTYPE,
   old_cs_rec_ IN SHIPMENT_TAB%ROWTYPE)
IS
   CURSOR  get_connected_shipments IS
      SELECT  rowid objid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) objversion
      FROM    SHIPMENT_TAB
      WHERE   parent_consol_shipment_id =  new_cs_rec_.shipment_id
      AND     rowstate != 'Cancelled';

   attr_   VARCHAR2(32000);
   oldrec_ SHIPMENT_TAB%ROWTYPE;
   newrec_ SHIPMENT_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   FOR rec_ IN get_connected_shipments LOOP
      Client_SYS.Clear_Attr(attr_);
      oldrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      newrec_ := oldrec_;
      IF (NVL(new_cs_rec_.route_id, Database_SYS.string_null_) != NVL(old_cs_rec_.route_id, Database_SYS.string_null_)) AND
         (NVL(new_cs_rec_.route_id, Database_SYS.string_null_) != NVL(oldrec_.route_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('ROUTE_ID', new_cs_rec_.route_id, attr_);
      END IF;

      IF (NVL(new_cs_rec_.forward_agent_id, Database_SYS.string_null_) != NVL(old_cs_rec_.forward_agent_id, Database_SYS.string_null_)) AND
         (NVL(new_cs_rec_.forward_agent_id, Database_SYS.string_null_) != NVL(oldrec_.forward_agent_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', new_cs_rec_.forward_agent_id, attr_);
      END IF;

      IF (NVL(new_cs_rec_.ship_via_code, Database_SYS.string_null_) != NVL(old_cs_rec_.ship_via_code, Database_SYS.string_null_)) AND
         (NVL(new_cs_rec_.ship_via_code, Database_SYS.string_null_) != NVL(oldrec_.ship_via_code, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('SHIP_VIA_CODE', new_cs_rec_.ship_via_code, attr_);
      END IF;
      
      IF (NVL(new_cs_rec_.shipment_type, Database_SYS.string_null_) != NVL(old_cs_rec_.shipment_type, Database_SYS.string_null_)) AND
         (new_cs_rec_.shipment_type != oldrec_.shipment_type) THEN
         Client_SYS.Set_Item_Value('SHIPMENT_TYPE', new_cs_rec_.shipment_type, attr_);
      END IF;

      IF (NVL(new_cs_rec_.ship_inventory_location_no, Database_SYS.string_null_) != NVL(old_cs_rec_.ship_inventory_location_no, Database_SYS.string_null_)) AND
         (NVL(new_cs_rec_.ship_inventory_location_no, Database_SYS.string_null_) != NVL(oldrec_.ship_inventory_location_no, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('SHIP_INVENTORY_LOCATION_NO', new_cs_rec_.ship_inventory_location_no, attr_);
      END IF;

      IF (NVL(new_cs_rec_.planned_ship_date, Database_SYS.first_calendar_date_) != NVL(old_cs_rec_.planned_ship_date, Database_SYS.first_calendar_date_)) AND
         (NVL(new_cs_rec_.planned_ship_date, Database_SYS.first_calendar_date_) != NVL(oldrec_.planned_ship_date, Database_SYS.first_calendar_date_)) THEN
         Client_SYS.Set_Item_Value('PLANNED_SHIP_DATE', new_cs_rec_.planned_ship_date, attr_);
      END IF;

      IF (new_cs_rec_.auto_connection_blocked != old_cs_rec_.auto_connection_blocked) AND
         (new_cs_rec_.auto_connection_blocked != oldrec_.auto_connection_blocked) THEN
         Client_SYS.Set_Item_Value('AUTO_CONNECTION_BLOCKED_DB', new_cs_rec_.auto_connection_blocked, attr_);
      END IF;

      IF (attr_ IS NOT NULL) THEN
         Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);
         Unpack___(newrec_, indrec_, attr_); 
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(rec_.objid, oldrec_, newrec_, attr_, rec_.objversion, TRUE);
      END IF;
   END LOOP;
END Set_Values_On_Shipments___;


-- Refresh_Values_On_CS___
--   Considers the values of route, ship via, forwarder, ship date, shipment type,
--   shipment location and auto connection blocked of all the connected shipments in a
--   consolidated shipment and refresh the parent consolidated shipment accordngly.
PROCEDURE Refresh_Values_On_CS___(
   consol_shipment_id_ IN NUMBER)
IS
   CURSOR get_connected_shipments IS
      SELECT  route_id, forward_agent_id, ship_via_code, shipment_type, ship_inventory_location_no, auto_connection_blocked, planned_ship_date
      FROM    SHIPMENT_TAB
      WHERE   parent_consol_shipment_id =  consol_shipment_id_
      AND     rowstate != 'Cancelled';

   attr_                       VARCHAR2(32000);  
   route_id_                   SHIPMENT_TAB.route_id%TYPE;
   forward_agent_id_           SHIPMENT_TAB.forward_agent_id%TYPE;
   ship_via_code_              SHIPMENT_TAB.ship_via_code%TYPE;
   shipment_type_              SHIPMENT_TAB.shipment_type%TYPE;
   planned_ship_date_          SHIPMENT_TAB.planned_ship_date%TYPE;
   ship_inventory_location_no_ SHIPMENT_TAB.ship_inventory_location_no%TYPE;
   auto_connection_blocked_    SHIPMENT_TAB.auto_connection_blocked%TYPE;   
   first_record_               BOOLEAN := FALSE;
   objid_                      VARCHAR2(2000);
   objversion_                 VARCHAR2(2000);
   oldrec_                     SHIPMENT_TAB%ROWTYPE;
   newrec_                     SHIPMENT_TAB%ROWTYPE;
   transport_unit_type_        VARCHAR2(25);
   com_dis_rec_                Company_Invent_Info_API.Public_Rec;
   indrec_                     Indicator_Rec;
BEGIN
   FOR connected_shipment_rec_ IN get_connected_shipments LOOP  
      IF NOT (first_record_) THEN
         first_record_               := TRUE;
         route_id_                   := connected_shipment_rec_.route_id;
         forward_agent_id_           := connected_shipment_rec_.forward_agent_id;
         ship_via_code_              := connected_shipment_rec_.ship_via_code;
         shipment_type_              := connected_shipment_rec_.shipment_type;
         ship_inventory_location_no_ := connected_shipment_rec_.ship_inventory_location_no;
         auto_connection_blocked_    := connected_shipment_rec_.auto_connection_blocked;
         planned_ship_date_          := connected_shipment_rec_.planned_ship_date;
      ELSE
         IF (NVL(route_id_, Database_SYS.string_null_) != NVL(connected_shipment_rec_.route_id, Database_SYS.string_null_)) THEN
            route_id_ := NULL; 
         END IF;

         IF (NVL(forward_agent_id_, Database_SYS.string_null_) != NVL(connected_shipment_rec_.forward_agent_id, Database_SYS.string_null_)) THEN
            forward_agent_id_ := NULL;
         END IF;

         IF (NVL(ship_via_code_, Database_SYS.string_null_) != NVL(connected_shipment_rec_.ship_via_code, Database_SYS.string_null_)) THEN
            ship_via_code_ := NULL;
         END IF;

         IF (shipment_type_ != connected_shipment_rec_.shipment_type) THEN
            shipment_type_ := NULL;
         END IF;

         IF (NVL(ship_inventory_location_no_, Database_SYS.string_null_) != NVL(connected_shipment_rec_.ship_inventory_location_no, Database_SYS.string_null_)) THEN
            ship_inventory_location_no_ := NULL;
         END IF;

         IF (auto_connection_blocked_ != connected_shipment_rec_.auto_connection_blocked) THEN
            auto_connection_blocked_ := 'FALSE';
         END IF;

         IF (NVL(planned_ship_date_, Database_SYS.first_calendar_date_) != NVL(connected_shipment_rec_.planned_ship_date, Database_SYS.first_calendar_date_)) THEN
            planned_ship_date_ := NULL;
         END IF;
      END IF;
   END LOOP;
   
   IF (first_record_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, consol_shipment_id_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      Client_SYS.Clear_Attr(attr_);
      IF (NVL(route_id_, Database_SYS.string_null_) != NVL(oldrec_.route_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('ROUTE_ID', route_id_, attr_); 
      END IF;

      IF (NVL(forward_agent_id_, Database_SYS.string_null_) != NVL(oldrec_.forward_agent_id, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', forward_agent_id_, attr_);
      END IF;

      IF (NVL(ship_via_code_, Database_SYS.string_null_) != NVL(oldrec_.ship_via_code, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('SHIP_VIA_CODE', ship_via_code_, attr_);
         transport_unit_type_ := Mpccom_Ship_Via_API.Get_Transport_Unit_Type(ship_via_code_);
         Client_SYS.Set_Item_Value('TRANSPORT_UNIT_TYPE', transport_unit_type_, attr_);
         com_dis_rec_         := Company_Invent_Info_API.Get(Site_API.Get_Company(oldrec_.contract));
         Client_SYS.Set_Item_Value('WEIGHT_CAPACITY', Get_Converted_Weight_Capacity(transport_unit_type_, com_dis_rec_.uom_for_weight), attr_);
         Client_SYS.Set_Item_Value('VOLUME_CAPACITY', Get_Converted_Volume_Capacity(transport_unit_type_, com_dis_rec_.uom_for_volume), attr_);
      END IF;

      IF (NVL(shipment_type_, Database_SYS.string_null_) != NVL(oldrec_.shipment_type, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('SHIPMENT_TYPE', shipment_type_, attr_);
      END IF;

      IF (NVL(ship_inventory_location_no_, Database_SYS.string_null_) != NVL(oldrec_.ship_inventory_location_no, Database_SYS.string_null_)) THEN
         Client_SYS.Set_Item_Value('SHIP_INVENTORY_LOCATION_NO', ship_inventory_location_no_, attr_);
      END IF;

      IF (auto_connection_blocked_ != oldrec_.auto_connection_blocked) THEN
          Client_SYS.Set_Item_Value('AUTO_CONNECTION_BLOCKED_DB', auto_connection_blocked_, attr_);
      END IF;

      IF (NVL(planned_ship_date_, Database_SYS.first_calendar_date_) != NVL(oldrec_.planned_ship_date, Database_SYS.first_calendar_date_)) THEN
         Client_SYS.Set_Item_Value('PLANNED_SHIP_DATE', planned_ship_date_, attr_);
      END IF;
      
      IF (attr_ IS NOT NULL) THEN
         newrec_ := oldrec_; 
         Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', 1, attr_);
         Unpack___(newrec_, indrec_, attr_); 
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   END IF;
END Refresh_Values_On_CS___;


-- Modify_Actual_Ship_Date
--   This method save the actual ship date when shipment ewas delivered.
PROCEDURE Modify_Actual_Ship_Date___ (
   shipment_id_     IN NUMBER,
   date_delivered_  IN DATE  ) 
IS  
   oldrec_        SHIPMENT_TAB%ROWTYPE;
   newrec_        SHIPMENT_TAB%ROWTYPE;       
BEGIN        
   oldrec_ := Get_Object_By_Keys___(shipment_id_);   
   newrec_ := oldrec_;   
   newrec_.actual_ship_date := date_delivered_;
   Modify___(newrec_);          
END Modify_Actual_Ship_Date___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_               SHIPMENT_TAB.contract%TYPE := User_Default_API.Get_Contract;   
   siterec_                Site_API.Public_Rec;
   addrrec_                Company_Address_API.Public_Rec; 
   delinforec_             Company_Address_Deliv_Info_API.Public_Rec;
   shipment_category_db_   shipment_tab.shipment_category%TYPE;
BEGIN
   shipment_category_db_ := Client_SYS.Get_Item_Value('SHIPMENT_CATEGORY_DB', attr_);
   super(attr_);
   
   IF(nvl(shipment_category_db_,'0') != Shipment_Category_API.DB_CONSOLIDATED) THEN
      Client_SYS.Add_To_Attr('RECEIVER_TYPE',    Sender_Receiver_Type_API.Decode(Sender_Receiver_Type_API.DB_CUSTOMER), attr_);
      Client_SYS.Add_To_Attr('RECEIVER_TYPE_DB', Sender_Receiver_Type_API.DB_CUSTOMER,                                  attr_); 
   END IF;
   
   Client_SYS.Add_To_Attr('SENDER_TYPE',              Sender_Receiver_Type_API.Decode(Sender_Receiver_Type_API.DB_SITE),     attr_);
   Client_SYS.Add_To_Attr('SENDER_TYPE_DB',           Sender_Receiver_Type_API.DB_SITE,                                      attr_);
   Client_SYS.Add_To_Attr('SENDER_ID',                contract_,                                                             attr_); 
   Client_SYS.Add_To_Attr('CONSIGNMENT_PRINTED_DB',   'N',                                                                   attr_);
   Client_SYS.Add_To_Attr('DEL_NOTE_PRINTED_DB',      'N',                                                                   attr_);
   Client_SYS.Add_To_Attr('PACKAGE_LIST_PRINTED_DB',  'N',                                                                   attr_);
   Client_SYS.Add_To_Attr('PRO_FORMA_PRINTED_DB',     'N',                                                                   attr_);   
   Client_SYS.Add_To_Attr('ADDRESS_LABEL_PRINTED_DB', Fnd_Boolean_API.DB_FALSE,                                              attr_);
   
   IF (shipment_category_db_ IS NULL) THEN
      shipment_category_db_ := Shipment_Category_API.DB_NORMAL;         
   END IF;
   Client_SYS.Add_To_Attr('SHIPMENT_CATEGORY_DB',     shipment_category_db_,                                                 attr_);
   
   IF (contract_ IS NOT NULL) THEN      
      siterec_    := Site_API.Get(contract_);
      addrrec_    := Company_Address_API.Get(siterec_.company, siterec_.delivery_address);
      delinforec_ := Company_Address_Deliv_Info_API.Get(siterec_.company, siterec_.delivery_address);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('SENDER_ADDR_ID',   siterec_.delivery_address, attr_);
      Client_SYS.Add_To_Attr('SENDER_NAME',      delinforec_.address_name,  attr_);
      Client_SYS.Add_To_Attr('SENDER_ADDRESS1',  addrrec_.address1,         attr_);
      Client_SYS.Add_To_Attr('SENDER_ADDRESS2',  addrrec_.address2,         attr_);
      Client_SYS.Add_To_Attr('SENDER_ADDRESS3',  addrrec_.address3,         attr_);
      Client_SYS.Add_To_Attr('SENDER_ADDRESS4',  addrrec_.address4,         attr_);
      Client_SYS.Add_To_Attr('SENDER_ADDRESS5',  addrrec_.address5,         attr_);
      Client_SYS.Add_To_Attr('SENDER_ADDRESS6',  addrrec_.address6,         attr_);
      Client_SYS.Add_To_Attr('SENDER_CITY',      addrrec_.city,             attr_);
      Client_SYS.Add_To_Attr('SENDER_ZIP_CODE',  addrrec_.zip_code,         attr_);
      Client_SYS.Add_To_Attr('SENDER_STATE',     addrrec_.state,            attr_);
      Client_SYS.Add_To_Attr('SENDER_COUNTY',    addrrec_.county,           attr_);
      Client_SYS.Add_To_Attr('SENDER_COUNTRY',   addrrec_.country,          attr_);
      Client_SYS.Add_To_Attr('SENDER_REFERENCE', delinforec_.contact,       attr_);
      Client_SYS.Add_To_Attr('ADDR_FLAG_DB',     Gen_Yes_No_API.DB_NO,      attr_);
  END IF;

   Client_SYS.Add_To_Attr('APPROVE_BEFORE_DELIVERY_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_UNCON_STRUCT_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('AUTO_CONNECTION_BLOCKED_DB', 'FALSE', attr_);   
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SHIPMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS   
   automatic_creation_    VARCHAR2(5);
   
   CURSOR get_next_seq IS
      SELECT shipment_seq.nextval
        FROM DUAL;
BEGIN
   automatic_creation_ := NVL(Client_SYS.Get_Item_Value('AUTOMATIC_CREATION', attr_), 'FALSE');
   
   -- Fetch next shipment_id from sequence.
   OPEN  get_next_seq ;
   FETCH get_next_seq INTO newrec_.shipment_id;
   CLOSE get_next_seq;
   Client_SYS.Add_To_Attr('SHIPMENT_ID', newrec_.shipment_id, attr_);
   
   -- Replaces the consignment_note_id with shipment_id when
   -- no values are specified for the consignment_note_id initially
   IF (newrec_.consignment_note_id IS NULL) AND (newrec_.shipment_category = 'NORMAL') THEN
      newrec_.consignment_note_id := newrec_.shipment_id;
      Client_SYS.Add_To_Attr('CONSIGNMENT_NOTE_ID', newrec_.consignment_note_id, attr_);
   END IF;

   newrec_.created_date        := TRUNC(newrec_.created_date);
   newrec_.note_id             := Document_Text_API.Get_Next_Note_Id;
   newrec_.planned_ship_period := Work_Time_Calendar_API.Get_Period(Site_API.Get_Dist_Calendar_Id(newrec_.contract), newrec_.planned_ship_date);   
   Client_SYS.Add_To_Attr('NOTE_ID',             newrec_.note_id,             attr_);
   Client_SYS.Add_To_Attr('CREATED_DATE',        newrec_.created_date,        attr_);
   Client_SYS.Add_To_Attr('PLANNED_SHIP_PERIOD', newrec_.planned_ship_period, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
   
   IF (automatic_creation_ = 'FALSE') THEN
      Shipment_Source_Utility_API.Post_Create_Manual_Ship(newrec_.shipment_id, newrec_.contract,
                                                          newrec_.receiver_id, newrec_.receiver_type);
   END IF; 
  
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SHIPMENT_TAB%ROWTYPE,
   newrec_     IN OUT SHIPMENT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS     
   delnote_no_                      VARCHAR2(15);
   delnote_attr_                    VARCHAR2(2000);   
   delnote_info_                    VARCHAR2(2000);
   update_delnote_                  BOOLEAN;   
   consol_shipment_id_              NUMBER;  
   recal_freight_charges_           VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;   
   calculate_shipment_charges_      VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
   ship_via_changed_                VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;
   shipment_freight_attr_           VARCHAR2(2000);   
   info_                            VARCHAR2(2000);
   delnote_state_                   VARCHAR2(15);
BEGIN   
   newrec_.planned_ship_period := Work_Time_Calendar_API.Get_Period(Site_API.Get_Dist_Calendar_Id(newrec_.contract), newrec_.planned_ship_date);     
   Client_SYS.Add_To_Attr('PLANNED_SHIP_PERIOD', newrec_.planned_ship_period, attr_);
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);  
         
   delnote_no_ := Delivery_Note_API.Get_Delnote_No_For_Shipment(oldrec_.shipment_id);
   IF (newrec_.shipment_category = 'NORMAL') THEN
      -- Check if delivery note should be updated.      
      IF (delnote_no_ IS NOT NULL) THEN
         Client_SYS.Clear_Attr(delnote_attr_);
         update_delnote_ := FALSE;

         -- Update address in Delivery_Note_Tab if Consignee address has been changed.
         IF (NVL(newrec_.receiver_addr_id, ' ') != NVL(oldrec_.receiver_addr_id, ' ')
            OR NVL(newrec_.addr_flag, ' ') != NVL(oldrec_.addr_flag, ' ') 
            OR (newrec_.addr_flag = 'Y' AND
               (NVL(oldrec_.receiver_address_name, ' ') != NVL(newrec_.receiver_address_name, ' '))OR
               (NVL(oldrec_.receiver_address1,     ' ') != NVL(newrec_.receiver_address1,     ' '))OR
               (NVL(oldrec_.receiver_address2,     ' ') != NVL(newrec_.receiver_address2,     ' '))OR
               (NVL(oldrec_.receiver_address3,     ' ') != NVL(newrec_.receiver_address3,     ' '))OR
               (NVL(oldrec_.receiver_address4,     ' ') != NVL(newrec_.receiver_address4,     ' '))OR
               (NVL(oldrec_.receiver_address5,     ' ') != NVL(newrec_.receiver_address5,     ' '))OR
               (NVL(oldrec_.receiver_address6,     ' ') != NVL(newrec_.receiver_address6,     ' '))OR
               (NVL(oldrec_.receiver_zip_code,     ' ') != NVL(newrec_.receiver_zip_code,     ' '))OR
               (NVL(oldrec_.receiver_city,         ' ') != NVL(newrec_.receiver_city,         ' '))OR
               (NVL(oldrec_.receiver_state,        ' ') != NVL(newrec_.receiver_state,        ' '))OR
               (NVL(oldrec_.receiver_county,       ' ') != NVL(newrec_.receiver_county,       ' '))OR
               (NVL(oldrec_.receiver_country,      ' ') != NVL(newrec_.receiver_country,      ' ')))) THEN            
            
            Client_SYS.Add_To_Attr('RECEIVER_ADDR_ID', newrec_.receiver_addr_id, delnote_attr_);
            IF newrec_.addr_flag = 'Y' THEN
               Client_SYS.Add_To_Attr('RECEIVER_ADDR_NAME', newrec_.receiver_address_name, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_ADDRESS1', newrec_.receiver_address1, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_ADDRESS2', newrec_.receiver_address2, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_ADDRESS3', newrec_.receiver_address3, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_ADDRESS4', newrec_.receiver_address4, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_ADDRESS5', newrec_.receiver_address5, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_ADDRESS6', newrec_.receiver_address6, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_ZIP_CODE', newrec_.receiver_zip_code, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_CITY', newrec_.receiver_city, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_COUNTY', newrec_.receiver_county, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_STATE', newrec_.receiver_state, delnote_attr_);
               Client_SYS.Add_To_Attr('RECEIVER_COUNTRY', newrec_.receiver_country, delnote_attr_);
            END IF;   
            Client_Sys.Add_To_Attr('SINGLE_OCC_ADDR_FLAG_DB', newrec_.addr_flag, delnote_attr_);
            
            update_delnote_ := TRUE;
         END IF;

         -- Update Delivery_Note_Tab if forward agent has been changed.
         IF (NVL(newrec_.forward_agent_id, ' ') != NVL(oldrec_.forward_agent_id, ' ')) THEN
            Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', newrec_.forward_agent_id, delnote_attr_);
            update_delnote_ := TRUE;
         END IF;

         -- Update Delivery_Note_Tab if ship via code has been changed.
         IF (NVL(newrec_.ship_via_code, ' ') != NVL(oldrec_.ship_via_code, ' ')) THEN
            Client_SYS.Add_To_Attr('SHIP_VIA_CODE', newrec_.ship_via_code, delnote_attr_);
            update_delnote_ := TRUE;            
         END IF;

         -- Update Delivery_Note_Tab if delivery terms has been changed.
         IF (NVL(newrec_.delivery_terms, ' ') != NVL(oldrec_.delivery_terms, ' ')) THEN
            Client_SYS.Add_To_Attr('DELIVERY_TERMS', newrec_.delivery_terms, delnote_attr_);
            update_delnote_ := TRUE;
         END IF;
         
         -- Update Delivery_Note_Tab if Receiver ID has been changed.
         IF (NVL(newrec_.receiver_id, ' ') != NVL(oldrec_.receiver_id, ' ')) THEN
            Client_SYS.Add_To_Attr('RECEIVER_ID', newrec_.receiver_id, delnote_attr_);
            update_delnote_ := TRUE;            
         END IF;
      
         IF update_delnote_ THEN                       
            Delivery_Note_API.Modify(delnote_info_, delnote_attr_, delnote_no_);                                    
         END IF;
      END IF;
      IF (newrec_.parent_consol_shipment_id IS NOT NULL) OR 
         (oldrec_.parent_consol_shipment_id IS NOT NULL AND newrec_.parent_consol_shipment_id IS NULL) THEN
         consol_shipment_id_ := NVL(newrec_.parent_consol_shipment_id, oldrec_.parent_consol_shipment_id);
         IF Any_Unapproved_Shipments___(consol_shipment_id_) = 1 THEN
            Modify_Approve_Before_Delivery (consol_shipment_id_, 'TRUE');
         ELSE
            Modify_Approve_Before_Delivery (consol_shipment_id_, 'FALSE');
         END IF;
      END IF;
   END IF;
     
   IF ((newrec_.auto_connection_blocked != oldrec_.auto_connection_blocked) OR (NVL(newrec_.planned_ship_date, Database_SYS.first_calendar_date_) != NVL(oldrec_.planned_ship_date, Database_SYS.first_calendar_date_)) OR
      (NVL(newrec_.route_id, Database_SYS.string_null_) != NVL(oldrec_.route_id, Database_SYS.string_null_)) OR (NVL(newrec_.ship_via_code, Database_SYS.string_null_) != NVL(oldrec_.ship_via_code, Database_SYS.string_null_)) OR
      (NVL(newrec_.shipment_type, Database_SYS.string_null_) != NVL(oldrec_.shipment_type, Database_SYS.string_null_)) OR (NVL(newrec_.forward_agent_id, Database_SYS.string_null_) != NVL(oldrec_.forward_agent_id, Database_SYS.string_null_)) OR 
      (NVL(newrec_.ship_inventory_location_no, Database_SYS.string_null_) != NVL(oldrec_.ship_inventory_location_no, Database_SYS.string_null_)) OR ((NVL(newrec_.parent_consol_shipment_id, -9999) != NVL(oldrec_.parent_consol_shipment_id, -9999)))) AND 
      (Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_) IS NULL) THEN
      IF (newrec_.shipment_category = 'CONSOLIDATED') THEN
         Set_Values_On_Shipments___(newrec_, oldrec_);
      ELSIF (NVL(newrec_.parent_consol_shipment_id, oldrec_.parent_consol_shipment_id) IS NOT NULL) THEN
         IF (NVL(newrec_.parent_consol_shipment_id, -9999) != NVL(oldrec_.parent_consol_shipment_id, -9999)) THEN
            IF (oldrec_.parent_consol_shipment_id IS NOT NULL) THEN
               Refresh_Values_On_CS___(oldrec_.parent_consol_shipment_id);
               Refresh_Parent__(oldrec_.parent_consol_shipment_id);
               Remove_Manual_Gross_Weight(oldrec_.parent_consol_shipment_id);
               Remove_Manual_Volume(oldrec_.parent_consol_shipment_id);
            END IF;
            IF (newrec_.parent_consol_shipment_id IS NOT NULL) THEN
               Refresh_Values_On_CS___(newrec_.parent_consol_shipment_id);  
               Refresh_Parent__(newrec_.parent_consol_shipment_id);
               Remove_Manual_Gross_Weight(newrec_.parent_consol_shipment_id);
               Remove_Manual_Volume(newrec_.parent_consol_shipment_id);
            END IF;
         ELSE
            Refresh_Values_On_CS___(NVL(newrec_.parent_consol_shipment_id, oldrec_.parent_consol_shipment_id));
         END IF;
      END IF; 
   END IF;  
   
   -- When Source Ref Type 'Customer Order' is removed, Shipment_Freight_Tab freight information will be cleared and supply_country and use_price_incl_tax values will be preserved. 
   IF ((Source_Ref_Type_Exist(oldrec_.source_ref_type, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) 
        AND (Source_Ref_Type_Exist(newrec_.source_ref_type, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_FALSE)) THEN
      $IF Component_Order_SYS.INSTALLED $THEN 
         Shipment_Freight_API.Remove_Freight_Info(newrec_.shipment_id);
      $ELSE
         NULL;
      $END
   END IF;
   
   IF (NVL(newrec_.ship_via_code, ' ') != NVL(oldrec_.ship_via_code, ' ')) THEN      
      ship_via_changed_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   IF ((NVL(newrec_.ship_via_code, ' ') != NVL(oldrec_.ship_via_code, '') 
       OR NVL(newrec_.forward_agent_id, ' ') != NVL(oldrec_.forward_agent_id, ' ') 
       OR NVL(newrec_.delivery_terms, ' ') != NVL(oldrec_.delivery_terms, ' ')
       OR NVL(newrec_.addr_flag, ' ') != NVL(oldrec_.addr_flag, ' ')
       OR (newrec_.addr_flag = 'Y' AND
          (NVL(oldrec_.receiver_zip_code,     ' ') != NVL(newrec_.receiver_zip_code,     ' ')) OR
          (NVL(oldrec_.receiver_city,         ' ') != NVL(newrec_.receiver_city,         ' ')) OR
          (NVL(oldrec_.receiver_state,        ' ') != NVL(newrec_.receiver_state,        ' ')) OR
          (NVL(oldrec_.receiver_county,       ' ') != NVL(newrec_.receiver_county,       ' ')) OR
          (NVL(oldrec_.receiver_country,      ' ') != NVL(newrec_.receiver_country,      ' '))))) AND (newrec_.shipment_category = 'NORMAL') THEN
          recal_freight_charges_ := Fnd_Boolean_API.DB_TRUE;        
   END IF;    
   IF (NVL(oldrec_.manual_gross_weight, number_null_) != NVL(newrec_.manual_gross_weight, number_null_)) OR
      (NVL(oldrec_.manual_volume, number_null_) != NVL(newrec_.manual_volume, number_null_)) THEN
      calculate_shipment_charges_ := Fnd_Boolean_API.DB_TRUE;          
   END IF;
   
   IF(Source_Ref_Type_Exist(newrec_.source_ref_type, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE AND
      (recal_freight_charges_      = Fnd_Boolean_API.DB_TRUE OR
       calculate_shipment_charges_ = Fnd_Boolean_API.DB_TRUE OR
       ship_via_changed_           = Fnd_Boolean_API.DB_TRUE)) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Client_SYS.Clear_Attr(shipment_freight_attr_);    
         Client_SYS.Add_To_Attr('RECAL_FREIGHT_CHARGES',      recal_freight_charges_,      shipment_freight_attr_); 
         Client_SYS.Add_To_Attr('CALCULATE_SHIPMENT_CHARGES', calculate_shipment_charges_, shipment_freight_attr_);       
         IF (ship_via_changed_ = Fnd_Boolean_API.DB_TRUE) THEN
            Client_SYS.Add_To_Attr('SHIP_VIA_CHANGED',        ship_via_changed_,           shipment_freight_attr_);     
         END IF;
         Shipment_Freight_API.Modify(info_, shipment_freight_attr_, oldrec_.shipment_id); 
      $ELSE
         NULL;
      $END
   END IF;
   
   Reset_Printed_Flags___(oldrec_, newrec_);
   
   -- gelr:warehouse_journal, begin
   IF (Company_Localization_Info_API.Get_Parameter_Val_From_Site_Db(Shipment_API.Get_Contract(oldrec_.shipment_id),'WAREHOUSE_JOURNAL') = Fnd_Boolean_API.DB_TRUE) THEN
      delnote_state_ := Delivery_Note_API.Get_Objstate(delnote_no_);
      -- Update Delivery_Note_Tab if eur pallets qty has been changed.
      IF ((newrec_.qty_eur_pallets != oldrec_.qty_eur_pallets) AND (delnote_state_ NOT IN ('Printed'))) THEN
         Client_SYS.Add_To_Attr('QTY_EUR_PALLETS', newrec_.qty_eur_pallets, delnote_attr_);
         Delivery_Note_API.Modify(delnote_info_, delnote_attr_, delnote_no_);
      END IF;
   END IF;
   -- gelr:warehouse_journal, end   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     shipment_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY shipment_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )  
IS
   loc_type_                   VARCHAR2(20);
BEGIN
   IF (newrec_.shipment_category = 'NORMAL' AND indrec_.receiver_id AND Validate_SYS.Is_Changed(oldrec_.receiver_id, newrec_.receiver_id)) THEN
         Shipment_Source_Utility_API.Validate_Receiver_Id(newrec_.receiver_id, newrec_.receiver_type, newrec_.contract);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_); 
   IF (newrec_.manual_gross_weight < 0) THEN
      Error_Sys.Record_General(lu_name_, 'NEGATIVEMANUALGROSSWEIGHT: Negative values are not allowed for Manual Gross Weight.');
   END IF; 
   IF (newrec_.manual_volume < 0) THEN
      Error_Sys.Record_General(lu_name_, 'NEGATIVEMANUALVOLUME: Negative values are not allowed for Manual Volume.');
   END IF;
   --   Added an IF condition to check whether entered location is a shipment location.
   IF (newrec_.ship_inventory_location_no IS NOT NULL) THEN
      loc_type_ := Inventory_Location_API.Get_Location_Type_Db(newrec_.contract, newrec_.ship_inventory_location_no);
      IF (loc_type_ != 'SHIPMENT') THEN
         Error_SYS.Record_General(lu_name_, 'INVALID_LOC: Location :P1 is not a Shipment location and therefore cannot be used in the Shipment.', newrec_.ship_inventory_location_no);
      END IF;
      Handle_Ship_Invent_Utility_API.Validate_Sender_Location(newrec_.contract, 
                                                              newrec_.ship_inventory_location_no, 
                                                              newrec_.sender_type, 
                                                              newrec_.sender_id);
   END IF;
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                       VARCHAR2(30);
   value_                      VARCHAR2(4000);
   shipment_type_              VARCHAR2(3); 
   ship_inventory_location_no_ VARCHAR2(35); 
   route_id_                   SHIPMENT_TAB.route_id%TYPE;
   forwarder_                  SHIPMENT_TAB.forward_agent_id%TYPE;   
   delivery_terms_             VARCHAR2(5);
   del_terms_location_         VARCHAR2(100);
   site_rec_                   Site_Discom_Info_API.Public_Rec;
   dummy_rec_                  shipment_tab%ROWTYPE;
   automatic_creation_         VARCHAR2(5);
   ship_via_code_              VARCHAR2(3);
   site_date_                  DATE;
   packing_proposal_id_        VARCHAR2(50);
BEGIN
   automatic_creation_ := NVL(Client_SYS.Get_Item_Value('AUTOMATIC_CREATION', attr_), 'FALSE');
   site_date_          := Site_API.Get_Site_Date(newrec_.contract);
   -- Add default values for mandatory fields.
   IF (indrec_.consignment_printed = FALSE) THEN
      newrec_.consignment_printed := 'N';
   END IF;
   IF (indrec_.del_note_printed = FALSE) THEN
      newrec_.del_note_printed := 'N';
   END IF;  
   IF (indrec_.address_label_printed = FALSE) THEN
      newrec_.address_label_printed := Fnd_Boolean_API.DB_FALSE;
   END IF;
   IF (indrec_.package_list_printed = FALSE) THEN
      newrec_.package_list_printed := 'N';
   END IF;
   IF (indrec_.bill_of_lading_printed = FALSE) THEN
      newrec_.bill_of_lading_printed := 'N';
   END IF;
   IF (indrec_.pro_forma_printed = FALSE) THEN
      newrec_.pro_forma_printed := 'N';   
   END IF;
   IF (indrec_.addr_flag = FALSE) THEN
      newrec_.addr_flag := 'N';
   END IF;   
   IF (indrec_.shipment_category = FALSE) THEN
      newrec_.shipment_category := 'NORMAL'; 
   END IF;
   IF (indrec_.shipment_uncon_struct = FALSE OR newrec_.shipment_uncon_struct IS NULL) THEN
      newrec_.shipment_uncon_struct := 'FALSE'; 
   END IF;
   IF (indrec_.auto_connection_blocked = FALSE) THEN
      newrec_.auto_connection_blocked := 'FALSE';
   END IF;
   IF (indrec_.approve_before_delivery = FALSE) THEN
      newrec_.approve_before_delivery := 'FALSE';
   END IF;
   site_rec_ := Site_Discom_Info_API.Get(newrec_.contract);
   IF (indrec_.shipment_type = TRUE) THEN
      shipment_type_ := newrec_.shipment_type;
   ELSE
      newrec_.shipment_type := site_rec_.shipment_type;   
   END IF;   
   IF (indrec_.delivery_terms = TRUE) THEN
      delivery_terms_     := newrec_.delivery_terms;
      del_terms_location_ := newrec_.del_terms_location;
   END IF;
   IF (indrec_.ship_inventory_location_no = TRUE) THEN
      ship_inventory_location_no_ := newrec_.ship_inventory_location_no;         
   END IF;   
   IF (indrec_.created_date = FALSE) THEN
      newrec_.created_date := site_date_;
   END IF;
   IF ((indrec_.shipment_freight_payer = FALSE) AND (newrec_.shipment_category = 'CONSOLIDATED')) THEN
      newrec_.shipment_freight_payer := 'NOT_SPECIFIED';
   END IF;
   IF (automatic_creation_ = 'FALSE') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract); 
   END IF;
   IF (indrec_.ship_via_code = TRUE) THEN
      ship_via_code_    := newrec_.ship_via_code;
   END IF;
   IF (indrec_.packing_proposal_id = TRUE) THEN
      packing_proposal_id_ := newrec_.packing_proposal_id;
   END IF;
   
   IF (newrec_.sender_type = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE AND newrec_.receiver_type = Sender_Receiver_Type_API.DB_CUSTOMER) THEN    
      Error_SYS.Record_General(lu_name_, 'INVALIDRECEIVER: Receiver type cannot be :P1 when the sender type is :P2.', 
                           Sender_Receiver_Type_API.Decode(newrec_.receiver_type), Sender_Receiver_Type_API.Decode(newrec_.sender_type));
   END IF;
   
   IF (newrec_.shipment_category = 'NORMAL') THEN
      Error_SYS.Check_Not_Null(lu_name_, 'SHIPMENT_TYPE', newrec_.shipment_type);
      Error_SYS.Check_Not_Null(lu_name_, 'RECEIVER_TYPE', newrec_.receiver_type);
      Error_SYS.Check_Not_Null(lu_name_, 'RECEIVER_ID', newrec_.receiver_id);
      
      IF (newrec_.receiver_addr_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RECEIVERADDRNOTEXISTS: Receiver address not found for the receiver :P1 of receiver type :P2.', newrec_.receiver_id, Sender_Receiver_Type_API.Decode(newrec_.receiver_type));
      END IF;
      Error_SYS.Check_Not_Null(lu_name_, 'SHIPMENT_FREIGHT_PAYER', newrec_.shipment_freight_payer);  
   END IF;     
   
   super(newrec_, indrec_, attr_);   
   
   Shipment_Source_Utility_API.Validate_Sender_Id(newrec_.sender_id, newrec_.sender_type, newrec_.contract);
   Validate_Sender_Address___(dummy_rec_, newrec_);
   IF (newrec_.shipment_category = 'NORMAL') THEN
      Validate_Receiver_Address___(dummy_rec_, newrec_);
   END IF;   
   
   Shipment_Source_Utility_API.Validate_Source_Ref1(dummy_rec_, newrec_, Client_SYS.Get_Item_Value('ORIGINATING_SOURCE_REF_TYPE', attr_));  

   IF (newrec_.planned_ship_date IS NOT NULL) THEN
      IF (newrec_.planned_ship_date < site_date_) THEN
         Client_SYS.Add_Info(lu_name_, 'INVSHIPDATE: Planned ship date is earlier than the site date.');
      END IF;
   END IF;  
   
   IF (newrec_.shipment_category = 'NORMAL') THEN
      Shipment_Source_Utility_API.Fetch_Source_And_Deliv_Info( route_id_,
                                                               forwarder_,
                                                               newrec_.shipment_type,
                                                               newrec_.ship_inventory_location_no,                                                               
                                                               delivery_terms_,
                                                               del_terms_location_,
                                                               ship_via_code_,
                                                               newrec_.contract,
                                                               newrec_.receiver_id,
                                                               newrec_.receiver_addr_id,
                                                               newrec_.addr_flag,                                                               
                                                               'TRUE',                                                                
                                                               newrec_.receiver_type,
                                                               newrec_.sender_id,
                                                               newrec_.sender_type);     
      
      newrec_.ship_inventory_location_no := NVL(ship_inventory_location_no_, newrec_.ship_inventory_location_no);
      IF (newrec_.sender_type = Sender_Receiver_Type_API.DB_SITE) THEN
         newrec_.ship_inventory_location_no := NVL(newrec_.ship_inventory_location_no, site_rec_.ship_inventory_location_no);
      END IF;
      IF (Warehouse_Bay_Bin_API.Receipts_Blocked(newrec_.contract, newrec_.ship_inventory_location_no)) THEN 
            newrec_.ship_inventory_location_no := NULL;
      END IF;
      newrec_.shipment_type              := NVL(shipment_type_, newrec_.shipment_type);
      newrec_.shipment_type              := NVL(newrec_.shipment_type, site_rec_.shipment_type);
      newrec_.packing_proposal_id        := NVL(packing_proposal_id_, Shipment_Type_API.Get_Packing_Proposal_Id(newrec_.shipment_type));
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     shipment_tab%ROWTYPE,
   newrec_ IN OUT shipment_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(4000);
   shipment_type_           SHIPMENT_TAB.shipment_type%TYPE;
   ship_location_           SHIPMENT_TAB.ship_inventory_location_no%TYPE;
   route_id_                SHIPMENT_TAB.route_id%TYPE;
   forward_agent_           SHIPMENT_TAB.forward_agent_id%TYPE;
   ship_location_changed_   VARCHAR2(5) := 'FALSE';
   route_changed_           VARCHAR2(5) := 'FALSE';
   forwarder_changed_       VARCHAR2(5) := 'FALSE';
   server_data_change_      NUMBER := 0;
   fetch_from_supply_chain_ VARCHAR2(5) := 'FALSE';
   delivery_terms_          VARCHAR2(5) := newrec_.delivery_terms;
   del_terms_location_      VARCHAR2(100) := newrec_.del_terms_location;
   check_pick_list_         VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   shipment_type_rec_       Shipment_Type_API.Public_Rec;
BEGIN
   IF (indrec_.shipment_type = TRUE) THEN
      shipment_type_ := newrec_.shipment_type;   
   END IF;
   IF (indrec_.ship_inventory_location_no = TRUE) THEN
      ship_location_changed_ := 'TRUE';
      ship_location_         := newrec_.ship_inventory_location_no;
   END IF;
   IF (indrec_.route_id = TRUE) THEN
      route_changed_ := 'TRUE';
      route_id_      := newrec_.route_id;
   END IF;
   IF (indrec_.forward_agent_id = TRUE) THEN
      forwarder_changed_ := 'TRUE';
   END IF;
   
   IF (Client_Sys.Item_Exist('SERVER_DATA_CHANGE', attr_)) THEN
      server_data_change_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SERVER_DATA_CHANGE', attr_));
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.shipment_category = 'NORMAL') THEN
      Error_SYS.Check_Not_Null(lu_name_, 'SHIPMENT_TYPE', newrec_.shipment_type);
      IF (NVL(newrec_.parent_consol_shipment_id, -9999) != NVL(oldrec_.parent_consol_shipment_id, -9999)) THEN
         Validate_Shipments___(oldrec_, newrec_);
      END IF;
   ELSE
      Validate_Capacities___(newrec_);
   END IF;
   
   Validate_Sender_Address___(oldrec_, newrec_);
   Validate_Receiver_Address___(oldrec_, newrec_);   
   
   IF (newrec_.rowstate = 'Cancelled') THEN
      Error_SYS.Record_General(lu_name_, 'CANCELEDNOUPD: Shipments in Cancelled status cannot be modified');
   END IF;
   
   IF (newrec_.shipment_category = 'NORMAL') THEN      
      IF newrec_.approve_before_delivery = 'TRUE' THEN
         newrec_.approved_by := NULL;
      END IF;
      Client_SYS.Add_To_Attr('APPROVED_BY', newrec_.approved_by, attr_);
      IF (oldrec_.shipment_type != newrec_.shipment_type) THEN
         shipment_type_rec_ := Shipment_Type_API.Get(newrec_.shipment_type);
         IF (indrec_.packing_proposal_id = FALSE) THEN
            newrec_.packing_proposal_id  := shipment_type_rec_.packing_proposal_id;
         END IF;
         newrec_.approve_before_delivery := shipment_type_rec_.approve_before_delivery;
         Client_SYS.Add_To_Attr('APPROVE_BEFORE_DELIVERY_DB', newrec_.approve_before_delivery, attr_);
      END IF;
   END IF;      
   IF (Validate_SYS.Is_Changed(oldrec_.planned_ship_date, newrec_.planned_ship_date) AND newrec_.planned_ship_date IS NOT NULL) THEN
      IF (newrec_.planned_ship_date < Site_API.Get_Site_Date(newrec_.contract)) THEN
         Client_SYS.Add_Info(lu_name_, 'INVSHIPDATE: Planned ship date is earlier than the site date.');
      END IF;
   END IF;
   
   IF (NVL(newrec_.delivery_terms,Database_Sys.string_null_) != NVL(oldrec_.delivery_terms,Database_Sys.string_null_)) THEN
      $IF Component_Order_SYS.INSTALLED $THEN   
         Shipment_Freight_API.Val_Apply_Fix_Deliv_Freight(oldrec_.shipment_id, newrec_.delivery_terms);
      $ELSE
         NULL;
      $END 
   END IF; 
  
   IF (NVL(newrec_.ref_id,Database_Sys.string_null_) != NVL(oldrec_.ref_id,Database_Sys.string_null_)) THEN
      Shipment_Source_Utility_API.Validate_Ref_Id(newrec_.shipment_id, newrec_.source_ref_type, newrec_.ref_id);
   END IF;
   
   IF ((server_data_change_ = 0) AND (newrec_.shipment_category = 'NORMAL') AND (Connected_Lines_Exist(newrec_.shipment_id) = 1)) THEN
      IF (NVL(oldrec_.ship_via_code,  ' ')  != NVL(newrec_.ship_via_code,  ' ')) OR
         (NVL(oldrec_.delivery_terms, ' ')  != NVL(newrec_.delivery_terms, ' ')) OR
         (NVL(oldrec_.del_terms_location, ' ')  != NVL(newrec_.del_terms_location, ' ')) OR
         (NVL(oldrec_.receiver_addr_id,   ' ')  != NVL(newrec_.receiver_addr_id,   ' ')) OR
         (NVL(oldrec_.route_id,   ' ')  != NVL(newrec_.route_id,   ' ')) OR
         (NVL(oldrec_.customs_value_currency,   ' ')  != NVL(newrec_.customs_value_currency,   ' ')) OR
         ((oldrec_.addr_flag != newrec_.addr_flag) AND newrec_.addr_flag = 'N' ) OR
         (newrec_.addr_flag = 'Y' AND
          ((NVL(oldrec_.receiver_address_name, ' ') != NVL(newrec_.receiver_address_name, ' ')) OR
           (NVL(oldrec_.receiver_address1,     ' ') != NVL(newrec_.receiver_address1,     ' ')) OR
           (NVL(oldrec_.receiver_address2,     ' ') != NVL(newrec_.receiver_address2,     ' ')) OR
           (NVL(oldrec_.receiver_address3,     ' ') != NVL(newrec_.receiver_address3,     ' ')) OR
           (NVL(oldrec_.receiver_address4,     ' ') != NVL(newrec_.receiver_address4,     ' ')) OR
           (NVL(oldrec_.receiver_address5,     ' ') != NVL(newrec_.receiver_address5,     ' ')) OR
           (NVL(oldrec_.receiver_address6,     ' ') != NVL(newrec_.receiver_address6,     ' ')) OR
           (NVL(oldrec_.receiver_zip_code,     ' ') != NVL(newrec_.receiver_zip_code,     ' ')) OR
           (NVL(oldrec_.receiver_city,         ' ') != NVL(newrec_.receiver_city,         ' ')) OR
           (NVL(oldrec_.receiver_state,        ' ') != NVL(newrec_.receiver_state,        ' ')) OR
           (NVL(oldrec_.receiver_county,       ' ') != NVL(newrec_.receiver_county,       ' ')) OR
           (NVL(oldrec_.receiver_country,      ' ') != NVL(newrec_.receiver_country,      ' '))))  THEN

         Client_SYS.Add_Warning(lu_name_,'CHANGENOTREFLECTED1: The connected source lines will not be automatically updated. Changes will not be reflected in already printed shipping documents.');
      END IF;
   END IF;

   --  Added an IF condition to check whether entered location is a shipment location.
   IF (newrec_.ship_inventory_location_no IS NOT NULL) THEN
      Warehouse_Bay_Bin_API.Check_Receipts_Blocked(newrec_.contract, newrec_.ship_inventory_location_no);
      
      -- TO_DO_LIME: Revisit this if centrized picking is implemented.
      check_pick_list_ := Pick_Shipment_API.Check_Unpicked_Pick_List_Exist(newrec_.shipment_id, ship_location_, newrec_.source_ref_type);                 
          
      IF (ship_location_changed_ = 'TRUE')  AND (check_pick_list_ = 'TRUE') 
          AND (oldrec_.ship_inventory_location_no IS NOT NULL) THEN
            Error_SYS.Record_General(lu_name_,'SHIPLOCCANNOTUPD: You are not allowed to amend shipment location when pick lists are created');
      END IF;
   END IF;
   IF ((newrec_.rowstate = 'Completed') OR (newrec_.rowstate = 'Closed')) THEN
      IF (oldrec_.shipment_uncon_struct != newrec_.shipment_uncon_struct) THEN
         Error_SYS.Record_General(lu_name_, 'CLOSECOMPLETEDNOUPD: Shipments in Completed or Closed status cannot be modified');
      END IF;
   END IF;

   IF ((NVL(newrec_.ship_via_code, ' ') != NVL(oldrec_.ship_via_code, '')
      OR NVL(newrec_.forward_agent_id, ' ') != NVL(oldrec_.forward_agent_id, ' ')
      OR NVL(newrec_.receiver_addr_id, ' ') != NVL(oldrec_.receiver_addr_id, ' ')
      OR NVL(newrec_.addr_flag, ' ') != NVL(oldrec_.addr_flag, ' ')
      OR (newrec_.addr_flag = 'Y' AND
      (NVL(oldrec_.receiver_zip_code,     ' ') != NVL(newrec_.receiver_zip_code,     ' ')) OR
      (NVL(oldrec_.receiver_city,         ' ') != NVL(newrec_.receiver_city,         ' ')) OR
      (NVL(oldrec_.receiver_state,        ' ') != NVL(newrec_.receiver_state,        ' ')) OR
      (NVL(oldrec_.receiver_county,       ' ') != NVL(newrec_.receiver_county,       ' ')) OR
      (NVL(oldrec_.receiver_country,      ' ') != NVL(newrec_.receiver_country,      ' '))))) AND (newrec_.shipment_category = 'NORMAL') AND (server_data_change_ = 1) THEN

      IF (NVL(newrec_.ship_via_code, ' ') != NVL(oldrec_.ship_via_code, '') OR 
         NVL(newrec_.receiver_addr_id, ' ') != NVL(oldrec_.receiver_addr_id, ' ') OR 
         NVL(newrec_.addr_flag, ' ') != NVL(oldrec_.addr_flag, ' ')) THEN
         fetch_from_supply_chain_ := 'TRUE';
      END IF;
      
      forward_agent_ := newrec_.forward_agent_id;
      Shipment_Source_Utility_API.Fetch_Source_And_Deliv_Info( newrec_.route_id,
                                                               newrec_.forward_agent_id,
                                                               newrec_.shipment_type,
                                                               newrec_.ship_inventory_location_no,                                                               
                                                               newrec_.delivery_terms,
                                                               newrec_.del_terms_location,
                                                               newrec_.ship_via_code,
                                                               newrec_.contract,
                                                               newrec_.receiver_id,
                                                               newrec_.receiver_addr_id,
                                                               newrec_.addr_flag,                                                                                                                              
                                                               fetch_from_supply_chain_,                                                                                                                             
                                                               newrec_.receiver_type,
                                                               newrec_.sender_id,
                                                               newrec_.sender_type); 
      IF (forwarder_changed_ = 'TRUE') THEN
         newrec_.forward_agent_id := forward_agent_;
      END IF;
      IF (shipment_type_ IS NOT NULL) THEN
         newrec_.shipment_type := shipment_type_;
      END IF;
      IF( indrec_.delivery_terms = FALSE ) THEN
         newrec_.delivery_terms := delivery_terms_;
         newrec_.del_terms_location := del_terms_location_;
      ELSIF (indrec_.del_terms_location = TRUE ) THEN
         newrec_.del_terms_location := del_terms_location_;
      END IF;
      IF (ship_location_changed_ = 'TRUE') THEN
         newrec_.ship_inventory_location_no := ship_location_;
      END IF;
      IF (route_changed_ = 'TRUE') THEN
         newrec_.route_id :=  route_id_;
      END IF;
   ELSE
      IF (server_data_change_ = 1) THEN
         Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE', server_data_change_, attr_);
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Unpack___ (
   newrec_ IN OUT NOCOPY shipment_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
  ptr_             NUMBER;
  name_            VARCHAR2(30);
  value_           VARCHAR2(32000);
  invoice_found_   VARCHAR2(5); 
BEGIN
   IF (newrec_.rowstate = 'Closed') THEN
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF name_ NOT IN ('CONSIGNMENT_PRINTED', 'CONSIGNMENT_PRINTED_DB', 'DEL_NOTE_PRINTED', 'DEL_NOTE_PRINTED_DB', 'PACKAGE_LIST_PRINTED', 'ADDRESS_LABEL_PRINTED', 'ADDRESS_LABEL_PRINTED_DB',
                          'PACKAGE_LIST_PRINTED_DB', 'BILL_OF_LADING_PRINTED', 'BILL_OF_LADING_PRINTED_DB', 'AIRWAY_BILL_NO', 'PRO_NO', 'PRO_FORMA_PRINTED_DB', 'PRO_FORMA_PRINTED',
                          'FORWARD_AGENT_ID', 'ADDR_FLAG', 'ADDR_FLAG_DB', 'LANGUAGE_CODE', 'DELIVERY_TERMS', 'DEL_TERMS_LOCATION', 'SHIP_VIA_CODE', 'NOTE_TEXT', 'SENDER_REFERENCE',
                          'QTY_EUR_PALLETS', 'PLACE_OF_DEPARTURE') THEN
            Shipment_Source_Utility_API.Validate_Update_Closed_Shipmnt(invoice_found_, newrec_.shipment_id, 'TRUE'); 
         END IF;
      END LOOP;
   END IF;
   super(newrec_, indrec_, attr_); 
END Unpack___; 


-- Validate_Receiver_Address___
-- This procedue will validate the receiver address corrosponding to a specifc receiver type and recevier id.
-- Since no references added in model, refernce check will be manually handled using this procedure.
PROCEDURE Validate_Receiver_Address___ (
   oldrec_ IN shipment_tab%ROWTYPE,
   newrec_ IN shipment_tab%ROWTYPE)
IS 
BEGIN   
   IF (newrec_.receiver_type IS NOT NULL AND newrec_.receiver_id IS NOT NULL AND newrec_.receiver_addr_id IS NOT NULL
      AND (Validate_SYS.Is_Changed(oldrec_.receiver_id, newrec_.receiver_id)
        OR Validate_SYS.Is_Changed(oldrec_.receiver_addr_id, newrec_.receiver_addr_id))) THEN      
       Receiver_Address_Exist(newrec_.receiver_id, newrec_.receiver_addr_id, newrec_.receiver_type);        
   END IF;
   Address_Setup_API.Validate_Address(newrec_.sender_country, newrec_.sender_state, newrec_.sender_county, newrec_.sender_city);   
   Address_Setup_API.Validate_Address(newrec_.receiver_country, newrec_.receiver_state, newrec_.receiver_county, newrec_.receiver_city);
END Validate_Receiver_Address___;


PROCEDURE Validate_Sender_Address___ (
   oldrec_ IN shipment_tab%ROWTYPE,
   newrec_ IN shipment_tab%ROWTYPE)
IS 
BEGIN   
   IF (newrec_.sender_type IS NOT NULL AND newrec_.sender_id IS NOT NULL AND newrec_.sender_addr_id IS NOT NULL
      AND (Validate_SYS.Is_Changed(oldrec_.sender_id, newrec_.sender_id)
        OR Validate_SYS.Is_Changed(oldrec_.sender_addr_id, newrec_.sender_addr_id))) THEN      
      Sender_Address_Exist(newrec_.sender_id, newrec_.sender_addr_id, newrec_.sender_type);        
   END IF;
   Address_Setup_API.Validate_Address(newrec_.sender_country, newrec_.sender_state, newrec_.sender_county, newrec_.sender_city);   
   Address_Setup_API.Validate_Address(newrec_.receiver_country, newrec_.receiver_state, newrec_.receiver_county, newrec_.receiver_city);
END Validate_Sender_Address___;


PROCEDURE Reset_Printed_Flags___ (
  oldrec_   IN shipment_tab%ROWTYPE,
  newrec_   IN shipment_tab%ROWTYPE )
IS
   unset_pkg_list_print_       BOOLEAN:=FALSE;
   unset_consignment_print_    BOOLEAN:=FALSE;
   unset_del_note_print_       BOOLEAN:=FALSE;
   unset_pro_forma_print_      BOOLEAN:=FALSE;
   unset_bill_of_lading_print_ BOOLEAN:=FALSE;
   unset_address_label_print_  BOOLEAN:=FALSE;
   lu_rec_                     SHIPMENT_TAB%ROWTYPE;
BEGIN
   IF (Any_Printed_Flag_Set__(newrec_.shipment_id) = 'FALSE') THEN
      RETURN;
   END IF;
   
   lu_rec_ := Get_Object_By_Keys___(newrec_.shipment_id);
   
   -- Address Label 
   IF (lu_rec_.address_label_printed = Fnd_Boolean_API.DB_TRUE) THEN
      IF ((Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.shipment_freight_payer, newrec_.shipment_freight_payer)) OR 
          (Validate_SYS.Is_Changed(oldrec_.shipment_freight_payer_id, newrec_.shipment_freight_payer_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.freight_payer_note, newrec_.freight_payer_note)) OR
          (Validate_SYS.Is_Changed(oldrec_.place_of_destination, newrec_.place_of_destination)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address_name, newrec_.receiver_address_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address1, newrec_.receiver_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address2, newrec_.receiver_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address3, newrec_.receiver_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address4, newrec_.receiver_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address5, newrec_.receiver_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address6, newrec_.receiver_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_zip_code, newrec_.receiver_zip_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_city, newrec_.receiver_city)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_state, newrec_.receiver_state)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_county, newrec_.receiver_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_country, newrec_.receiver_country)) OR
          (Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_addr_id, newrec_.sender_addr_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_name, newrec_.sender_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address1, newrec_.sender_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address2, newrec_.sender_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address3, newrec_.sender_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address4, newrec_.sender_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address5, newrec_.sender_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address6, newrec_.sender_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_county, newrec_.sender_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_zip_code, newrec_.sender_zip_code)) OR   
          (Validate_SYS.Is_Changed(oldrec_.sender_state, newrec_.sender_state))   OR
          (Validate_SYS.Is_Changed(oldrec_.sender_city, newrec_.sender_city)) OR 
          (Validate_SYS.Is_Changed(oldrec_.sender_country, newrec_.sender_country)) OR 
          (Validate_SYS.Is_Changed(oldrec_.place_of_departure, newrec_.place_of_departure)) OR  
          (Validate_SYS.Is_Changed(oldrec_.sender_reference, newrec_.sender_reference)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_reference, newrec_.receiver_reference))) THEN

         unset_address_label_print_  := TRUE;

      END IF; 
   END IF; 
   
   -- Bill of Lading
   IF (lu_rec_.bill_of_lading_printed = Gen_Yes_No_API.DB_YES) THEN
      IF ((Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.shipment_freight_payer, newrec_.shipment_freight_payer)) OR 
          (Validate_SYS.Is_Changed(oldrec_.shipment_freight_payer_id, newrec_.shipment_freight_payer_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.freight_payer_note, newrec_.freight_payer_note)) OR
          (Validate_SYS.Is_Changed(oldrec_.place_of_destination, newrec_.place_of_destination)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address_name, newrec_.receiver_address_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address1, newrec_.receiver_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address2, newrec_.receiver_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address3, newrec_.receiver_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address4, newrec_.receiver_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address5, newrec_.receiver_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address6, newrec_.receiver_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_zip_code, newrec_.receiver_zip_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_city, newrec_.receiver_city)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_state, newrec_.receiver_state)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_county, newrec_.receiver_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_country, newrec_.receiver_country)) OR
          (Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_addr_id, newrec_.sender_addr_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_name, newrec_.sender_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address1, newrec_.sender_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address2, newrec_.sender_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address3, newrec_.sender_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address4, newrec_.sender_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address5, newrec_.sender_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address6, newrec_.sender_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_county, newrec_.sender_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_country, newrec_.sender_country)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_zip_code, newrec_.sender_zip_code)) OR   
          (Validate_SYS.Is_Changed(oldrec_.sender_state, newrec_.sender_state))   OR
          (Validate_SYS.Is_Changed(oldrec_.sender_city, newrec_.sender_city)) OR
          (Validate_SYS.Is_Changed(oldrec_.consignment_note_id, newrec_.consignment_note_id)) OR 
          (Validate_SYS.Is_Changed(oldrec_.pro_no, newrec_.pro_no)) OR
          (Validate_SYS.Is_Changed(oldrec_.airway_bill_no, newrec_.airway_bill_no)) OR 
          (Validate_SYS.Is_Changed(oldrec_.manual_gross_weight, newrec_.manual_gross_weight)) OR   
          (Validate_SYS.Is_Changed(oldrec_.remit_cod_to, newrec_.remit_cod_to)) OR
          (Validate_SYS.Is_Changed(oldrec_.manual_gross_weight, newrec_.manual_gross_weight)) OR
          (Validate_SYS.Is_Changed(oldrec_.delivery_terms, newrec_.delivery_terms)) OR
          (Validate_SYS.Is_Changed(oldrec_.del_terms_location, newrec_.del_terms_location)) OR   
          (Validate_SYS.Is_Changed(oldrec_.receiver_reference, newrec_.receiver_reference))) THEN

         unset_bill_of_lading_print_ := TRUE;

      END IF; 
   END IF;
   
   -- Consignment Note
   IF (lu_rec_.consignment_printed = Gen_Yes_No_API.DB_YES) THEN
      IF ((Validate_SYS.Is_Changed(oldrec_.receiver_address_name, newrec_.receiver_address_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address1, newrec_.receiver_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address2, newrec_.receiver_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address3, newrec_.receiver_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address4, newrec_.receiver_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address5, newrec_.receiver_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address6, newrec_.receiver_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_zip_code, newrec_.receiver_zip_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_city, newrec_.receiver_city)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_state, newrec_.receiver_state)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_county, newrec_.receiver_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_country, newrec_.receiver_country)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_addr_id, newrec_.sender_addr_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_name, newrec_.sender_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address1, newrec_.sender_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address2, newrec_.sender_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address3, newrec_.sender_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address4, newrec_.sender_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address5, newrec_.sender_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address6, newrec_.sender_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_county, newrec_.sender_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_country, newrec_.sender_country)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_zip_code, newrec_.sender_zip_code)) OR   
          (Validate_SYS.Is_Changed(oldrec_.sender_state, newrec_.sender_state))   OR
          (Validate_SYS.Is_Changed(oldrec_.sender_city, newrec_.sender_city)) OR
          (Validate_SYS.Is_Changed(oldrec_.place_of_departure, newrec_.place_of_departure)) OR   
          (Validate_SYS.Is_Changed(oldrec_.shipment_freight_payer, newrec_.shipment_freight_payer)) OR 
          (Validate_SYS.Is_Changed(oldrec_.shipment_freight_payer_id, newrec_.shipment_freight_payer_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.freight_payer_note, newrec_.freight_payer_note)) OR
          (Validate_SYS.Is_Changed(oldrec_.qty_eur_pallets, newrec_.qty_eur_pallets)) OR 
          (Validate_SYS.Is_Changed(oldrec_.manual_gross_weight, newrec_.manual_gross_weight)) OR  
          (Validate_SYS.Is_Changed(oldrec_.manual_volume, newrec_.manual_volume)) OR
          (Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_reference, newrec_.receiver_reference)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_reference, newrec_.sender_reference)) OR
          (Validate_SYS.Is_Changed(oldrec_.consignment_note_id, newrec_.consignment_note_id)) OR 
          (Validate_SYS.Is_Changed(oldrec_.pro_no, newrec_.pro_no)) OR
          (Validate_SYS.Is_Changed(oldrec_.airway_bill_no, newrec_.airway_bill_no)) OR  
          (Validate_SYS.Is_Changed(oldrec_.place_of_destination, newrec_.place_of_destination)) OR
          (Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag))) THEN

         unset_consignment_print_    := TRUE;

      END IF; 
   END IF;
   
   -- Pro forma invoice
   IF (lu_rec_.pro_forma_printed = Gen_Yes_No_API.DB_YES) THEN
      IF ((Validate_SYS.Is_Changed(oldrec_.place_of_destination, newrec_.place_of_destination)) OR
         (Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_address_name, newrec_.receiver_address_name)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_address1, newrec_.receiver_address1)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_address2, newrec_.receiver_address2)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_address3, newrec_.receiver_address3)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_address4, newrec_.receiver_address4)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_address5, newrec_.receiver_address5)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_address6, newrec_.receiver_address6)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_zip_code, newrec_.receiver_zip_code)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_city, newrec_.receiver_city)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_state, newrec_.receiver_state)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_county, newrec_.receiver_county)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_country, newrec_.receiver_country)) OR
         (Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag)) OR
         (Validate_SYS.Is_Changed(oldrec_.sender_reference, newrec_.sender_reference)) OR
         (Validate_SYS.Is_Changed(oldrec_.customs_value_currency, newrec_.customs_value_currency)) OR
         (Validate_SYS.Is_Changed(oldrec_.dock_code, newrec_.dock_code)) OR
         (Validate_SYS.Is_Changed(oldrec_.sub_dock_code, newrec_.sub_dock_code)) OR
         (Validate_SYS.Is_Changed(oldrec_.ref_id, newrec_.ref_id)) OR
         (Validate_SYS.Is_Changed(oldrec_.ship_via_code, newrec_.ship_via_code)) OR 
         (Validate_SYS.Is_Changed(oldrec_.location_no, newrec_.location_no)) OR 
         (Validate_SYS.Is_Changed(oldrec_.delivery_terms, newrec_.delivery_terms)) OR
         (Validate_SYS.Is_Changed(oldrec_.del_terms_location, newrec_.del_terms_location)) OR 
         (Validate_SYS.Is_Changed(oldrec_.manual_gross_weight, newrec_.manual_gross_weight)) OR   
         (Validate_SYS.Is_Changed(TRUNC(oldrec_.planned_delivery_date), TRUNC(newrec_.planned_delivery_date))) OR
         (Validate_SYS.Is_Changed(oldrec_.manual_volume, newrec_.manual_volume)) OR
         (Validate_SYS.Is_Changed(oldrec_.receiver_reference, newrec_.receiver_reference))) THEN

         unset_pro_forma_print_      := TRUE;

      END IF; 
   END IF;
   
   -- Delivery Note
   IF (lu_rec_.del_note_printed = Gen_Yes_No_API.DB_YES) THEN
      IF ((Validate_SYS.Is_Changed(oldrec_.sender_addr_id, newrec_.sender_addr_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_name, newrec_.sender_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.place_of_destination, newrec_.place_of_destination)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address1, newrec_.sender_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address2, newrec_.sender_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address3, newrec_.sender_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address4, newrec_.sender_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address5, newrec_.sender_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_address6, newrec_.sender_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_county, newrec_.sender_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_zip_code, newrec_.sender_zip_code)) OR   
          (Validate_SYS.Is_Changed(oldrec_.sender_state, newrec_.sender_state))   OR
          (Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_reference, newrec_.receiver_reference)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address_name, newrec_.receiver_address_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address1, newrec_.receiver_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address2, newrec_.receiver_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address3, newrec_.receiver_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address4, newrec_.receiver_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address5, newrec_.receiver_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address6, newrec_.receiver_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_zip_code, newrec_.receiver_zip_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_city, newrec_.receiver_city)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_state, newrec_.receiver_state)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_county, newrec_.receiver_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_country, newrec_.receiver_country)) OR
          (Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag)) OR   
          (Validate_SYS.Is_Changed(oldrec_.sender_reference, newrec_.sender_reference)) OR
          (Validate_SYS.Is_Changed(oldrec_.dock_code, newrec_.dock_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.sub_dock_code, newrec_.sub_dock_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.ref_id, newrec_.ref_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.ship_via_code, newrec_.ship_via_code)) OR 
          (Validate_SYS.Is_Changed(oldrec_.location_no, newrec_.location_no)) OR 
          (Validate_SYS.Is_Changed(oldrec_.delivery_terms, newrec_.delivery_terms)) OR
          (Validate_SYS.Is_Changed(oldrec_.del_terms_location, newrec_.del_terms_location)) OR
          (Validate_SYS.Is_Changed(TRUNC(oldrec_.planned_delivery_date), TRUNC(newrec_.planned_delivery_date))) OR
          (Validate_SYS.Is_Changed(oldrec_.manual_volume, newrec_.manual_volume)) OR
          (Validate_SYS.Is_Changed(oldrec_.manual_gross_weight, newrec_.manual_gross_weight)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_city, newrec_.sender_city))) THEN

         unset_del_note_print_       := TRUE;

      END IF; 
   END IF;

   -- Packing List
   IF (lu_rec_.package_list_printed = Gen_Yes_No_API.DB_YES) THEN
      IF ((Validate_SYS.Is_Changed(oldrec_.receiver_address_name, newrec_.receiver_address_name)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address1, newrec_.receiver_address1)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address2, newrec_.receiver_address2)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address3, newrec_.receiver_address3)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address4, newrec_.receiver_address4)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address5, newrec_.receiver_address5)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_address6, newrec_.receiver_address6)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_zip_code, newrec_.receiver_zip_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_city, newrec_.receiver_city)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_state, newrec_.receiver_state)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_county, newrec_.receiver_county)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_country, newrec_.receiver_country)) OR
          (Validate_SYS.Is_Changed(oldrec_.forward_agent_id, newrec_.forward_agent_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.receiver_reference, newrec_.receiver_reference)) OR
          (Validate_SYS.Is_Changed(oldrec_.place_of_departure, newrec_.place_of_departure)) OR
          (Validate_SYS.Is_Changed(oldrec_.sender_reference, newrec_.sender_reference)) OR
          (Validate_SYS.Is_Changed(oldrec_.consignment_note_id, newrec_.consignment_note_id)) OR 
          (Validate_SYS.Is_Changed(oldrec_.pro_no, newrec_.pro_no)) OR
          (Validate_SYS.Is_Changed(oldrec_.airway_bill_no, newrec_.airway_bill_no)) OR 
          (Validate_SYS.Is_Changed(oldrec_.parent_consol_shipment_id, newrec_.parent_consol_shipment_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.shipment_type, newrec_.shipment_type)) OR
          (Validate_SYS.Is_Changed(oldrec_.dock_code, newrec_.dock_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.sub_dock_code, newrec_.sub_dock_code)) OR
          (Validate_SYS.Is_Changed(oldrec_.ref_id, newrec_.ref_id)) OR
          (Validate_SYS.Is_Changed(oldrec_.ship_via_code, newrec_.ship_via_code)) OR 
          (Validate_SYS.Is_Changed(oldrec_.location_no, newrec_.location_no)) OR 
          (Validate_SYS.Is_Changed(oldrec_.delivery_terms, newrec_.delivery_terms)) OR
          (Validate_SYS.Is_Changed(oldrec_.del_terms_location, newrec_.del_terms_location)) OR   
          (Validate_SYS.Is_Changed(oldrec_.addr_flag, newrec_.addr_flag))) THEN

         unset_pkg_list_print_       := TRUE;

      END IF; 
   END IF; 

   IF (unset_address_label_print_ OR unset_bill_of_lading_print_ OR unset_consignment_print_ OR 
       unset_del_note_print_      OR unset_pkg_list_print_       OR unset_pro_forma_print_)  THEN
      Reset_Printed_Flags__(newrec_.shipment_id         ,
                            unset_pkg_list_print_       ,
                            unset_consignment_print_    ,
                            unset_del_note_print_       ,
                            unset_pro_forma_print_      ,
                            unset_bill_of_lading_print_ ,
                            unset_address_label_print_  );
   END IF;                      
   
END Reset_Printed_Flags___;


PROCEDURE Validate_Ship_Reservation___ (
   shipment_id_ IN VARCHAR2 )
IS
   line_qty_attached_         NUMBER;
   ship_rec_                  Shipment_API.Public_Rec;
   ship_line_rec_             Shipment_Line_API.Public_Rec;
   
   CURSOR get_line_qty_assigned IS 
      SELECT qty_assigned , shipment_line_no
        FROM SHIPMENT_LINE_TAB
       WHERE (((source_ref_type  = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) <= 0)) OR
              (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))
         AND shipment_id  = shipment_id_;   
BEGIN   
   -- check Receiver of the Shipment has the DESADV messaged enabled
   ship_rec_ := Get(shipment_id_);
   IF (Shipment_Source_Utility_API.Get_Default_Media_Code(ship_rec_.receiver_id,'DESADV',ship_rec_.receiver_type)IS NOT NULL) THEN 
      -- Get the shipment line by line qty reserved
      FOR line_qty_assigned_rec_ IN get_line_qty_assigned LOOP 
         -- get shipment line how many quantity attached 
         IF line_qty_assigned_rec_.qty_assigned > 0  THEN                
            -- find each line how may qty attached
            ship_line_rec_ := Shipment_Line_API.Get(shipment_id_, line_qty_assigned_rec_.shipment_line_no);
            line_qty_attached_ := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(ship_line_rec_.source_ref1, ship_line_rec_.source_ref2, ship_line_rec_.source_ref3, ship_line_rec_.source_ref4, shipment_id_, line_qty_assigned_rec_.shipment_line_no, null);
            IF line_qty_assigned_rec_.qty_assigned != line_qty_attached_ AND line_qty_attached_ > 0 THEN
               Error_SYS.Record_General(lu_name_, 'UNMATCHATTAQTY:  The reservations on Shipment :P1 Line No :P2 have not been fully attached to the handling unit structure. Either all reservations must be attached or no reservations at all, before completing the shipment. This is to ensure that the contents of the dispatch advice will be correct.', shipment_id_, line_qty_assigned_rec_.shipment_line_no);
            END IF;   
         END IF;
      END LOOP;
   END IF;   
   
END Validate_Ship_Reservation___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Tax_Documnt_Header_Info___ (
   rec_  IN  shipment_tab%ROWTYPE ) RETURN Tax_Document_API.Tax_Document_Header_Rec
IS
   tax_document_header_rec_ Tax_Document_API.Tax_Document_Header_Rec; 
BEGIN
   tax_document_header_rec_.contract                  := rec_.contract;
   tax_document_header_rec_.source_ref_type           := Tax_Doc_Source_Ref_Type_API.DB_SHIPMENT;
   tax_document_header_rec_.source_ref1               := rec_.shipment_id;
   tax_document_header_rec_.sender_type               := rec_.sender_type;
   tax_document_header_rec_.sender_id                 := rec_.sender_id;
   tax_document_header_rec_.sender_addr_id            := rec_.sender_addr_id;
   tax_document_header_rec_.receiver_type             := rec_.receiver_type;
   tax_document_header_rec_.receiver_id               := rec_.receiver_id;
   tax_document_header_rec_.receiver_addr_id          := rec_.receiver_addr_id;
   tax_document_header_rec_.receiver_address_name     := rec_.receiver_address_name;
   tax_document_header_rec_.receiver_address1         := rec_.receiver_address1;
   tax_document_header_rec_.receiver_address2         := rec_.receiver_address2;
   tax_document_header_rec_.receiver_address3         := rec_.receiver_address3;
   tax_document_header_rec_.receiver_address4         := rec_.receiver_address4;
   tax_document_header_rec_.receiver_address5         := rec_.receiver_address5;
   tax_document_header_rec_.receiver_address6         := rec_.receiver_address6;
   tax_document_header_rec_.receiver_zip_code         := rec_.receiver_zip_code;
   tax_document_header_rec_.receiver_city             := rec_.receiver_city;
   tax_document_header_rec_.receiver_state            := rec_.receiver_state;
   tax_document_header_rec_.receiver_county           := rec_.receiver_county;
   tax_document_header_rec_.receiver_country          := rec_.receiver_country;
   tax_document_header_rec_.addr_flag                 := rec_.addr_flag;    
   tax_document_header_rec_.document_addr_id          := Shipment_Source_Utility_API.Get_Document_Address(rec_.receiver_id, rec_.receiver_type);
   tax_document_header_rec_.original_source_ref_type  := rec_.source_ref_type;
   RETURN tax_document_header_rec_;
END Get_Tax_Documnt_Header_Info___;

@IgnoreUnitTest TrivialFunction
FUNCTION Get_Tax_Documnt_Line_Info___ (
   shipment_id_  IN  shipment_tab.shipment_id%TYPE ) RETURN Tax_Document_Line_API.Tax_Doc_Line_Tab
IS
   tax_document_Line_tab  Tax_Document_Line_API.Tax_Doc_Line_Tab;
   i_                     INTEGER := 0;
   CURSOR get_line_info IS
      SELECT shipment_line_no, inventory_part_no, source_ref1, source_ref2, source_ref3, source_ref4, qty_shipped, source_ref_type
      FROM   shipment_line_tab
      WHERE  shipment_id = shipment_id_
      AND    inventory_part_no IS NOT NULL;
BEGIN
   FOR rec_ IN get_line_info LOOP
      i_ := i_ + 1;
      tax_document_Line_tab(i_).source_ref2                 := rec_.shipment_line_no;
      tax_document_Line_tab(i_).part_no                     := rec_.inventory_part_no;
      tax_document_Line_tab(i_).original_source_ref1        := rec_.source_ref1;
      tax_document_Line_tab(i_).original_source_ref2        := rec_.source_ref2;
      tax_document_Line_tab(i_).original_source_ref3        := rec_.source_ref3;
      tax_document_Line_tab(i_).original_source_ref4        := rec_.source_ref4;   
      tax_document_Line_tab(i_).qty_shipped                 := rec_.qty_shipped;
      tax_document_Line_tab(i_).original_source_ref_type    := rec_.source_ref_type;
   END LOOP;
   RETURN tax_document_Line_tab;
END Get_Tax_Documnt_Line_Info___;

@IgnoreUnitTest TrivialFunction
PROCEDURE Create_Tax_Document___ (
   tax_document_no_ OUT NUMBER,
   rec_             IN OUT NOCOPY shipment_tab%ROWTYPE)
IS
   tax_document_header_rec_ Tax_Document_API.Tax_Document_Header_Rec; 
   tax_document_line_tab_   Tax_Document_Line_API.Tax_Doc_Line_Tab;
   company_                 VARCHAR2(20);
BEGIN
   tax_document_header_rec_ := Get_Tax_Documnt_Header_Info___(rec_); 
   Tax_document_API.Create_Outbound_Tax_Doc_Header(company_,
                                                   tax_document_no_,
                                                   tax_document_header_rec_);
   IF ((company_ IS NOT NULL) AND (tax_document_no_ IS NOT NULL))  THEN                                              
      tax_document_line_tab_   := Get_Tax_Documnt_Line_Info___(rec_.shipment_id);
      Tax_Document_Line_API.Create_Outbound_Tax_Doc_Line(company_,
                                                     tax_document_no_,
                                                     rec_.shipment_id,
                                                     tax_document_line_tab_);
   END IF;
END Create_Tax_Document___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Reset_Printed_Flags___
--   Resets the print flags after checking conditions.
PROCEDURE Reset_Printed_Flags__ (
   shipment_id_                IN NUMBER,
   unset_pkg_list_print_       IN BOOLEAN,
   unset_consignment_print_    IN BOOLEAN,
   unset_del_note_print_       IN BOOLEAN,
   unset_pro_forma_print_      IN BOOLEAN,
   unset_bill_of_lading_print_ IN BOOLEAN,
   unset_address_label_print_  IN BOOLEAN )
IS
   newrec_     SHIPMENT_TAB%ROWTYPE;
BEGIN
   IF NOT(unset_pkg_list_print_ OR unset_consignment_print_ OR unset_del_note_print_ OR
          unset_pro_forma_print_ OR unset_bill_of_lading_print_ OR unset_address_label_print_) THEN
      RETURN;
   END IF;
   
   -- return if the shipment does not have any printed flags set.
   IF (Any_Printed_Flag_Set__(shipment_id_) = 'FALSE') THEN
      RETURN;
   END IF;
   
   newrec_  := Lock_By_Keys___(shipment_id_);

   IF unset_pkg_list_print_ THEN
      IF (newrec_.package_list_printed = 'Y') THEN
         newrec_.package_list_printed := Gen_Yes_No_API.DB_NO;
      END IF;
   END IF;

   IF unset_consignment_print_ THEN
      IF (newrec_.consignment_printed = 'Y') THEN
         Client_SYS.Add_Info(lu_name_, 'REPRINTCONS: The consignment note  of shipment :P1 may have to be reprinted again.', shipment_id_);
         newrec_.consignment_printed := Gen_Yes_No_API.DB_NO;
      END IF;
   END IF;

   IF unset_del_note_print_ THEN
      IF (newrec_.del_note_printed = 'Y') THEN
         Client_SYS.Add_Info(lu_name_, 'REPRINTDELN: The delivery note of shipment :P1 may have to be reprinted again.', shipment_id_);
         newrec_.del_note_printed := Gen_Yes_No_API.DB_NO;
      END IF;
   END IF;
   
   IF unset_pro_forma_print_ THEN
      IF (newrec_.pro_forma_printed = 'Y') THEN
         Client_SYS.Add_Info(lu_name_, 'REPRINTPROFORMA: The pro forma invoice of shipment :P1 may have to be reprinted again.', shipment_id_);
         newrec_.pro_forma_printed := Gen_Yes_No_API.DB_NO;
      END IF;
   END IF;

   IF unset_bill_of_lading_print_ THEN
      IF (newrec_.bill_of_lading_printed = 'Y') THEN
         Client_SYS.Add_Info(lu_name_, 'REPRINTBILLOFLADING: The bill of lading of shipment :P1 may have to be reprinted again.', shipment_id_);
         newrec_.bill_of_lading_printed := Gen_Yes_No_API.DB_NO;
      END IF;
   END IF;
   
   IF unset_address_label_print_ THEN
      IF (newrec_.address_label_printed = Fnd_Boolean_API.DB_TRUE) THEN
         Client_SYS.Add_Info(lu_name_, 'REPRINTADDRESS: The address label of shipment :P1 may have to be reprinted again.', shipment_id_);
         newrec_.address_label_printed := Fnd_Boolean_API.DB_FALSE;
      END IF;
   END IF;
   
   Modify___(newrec_);
   
END Reset_Printed_Flags__;


PROCEDURE Update_Shipment__ (
   shipment_id_                IN NUMBER,
   remove_manual_gross_weight_ IN BOOLEAN,
   reopen_shipment_            IN BOOLEAN,
   qty_modification_source_    IN VARCHAR2,
   source_ref_type_            IN VARCHAR2,
   delete_                     IN VARCHAR2)
IS    
BEGIN
   IF remove_manual_gross_weight_ THEN
      Remove_Manual_Gross_Weight(shipment_id_);
   END IF;

   IF reopen_shipment_ THEN
      IF (Get_ObjState(shipment_id_) = 'Completed') THEN
         IF (Reopen_Shipment_Allowed__(shipment_id_) = 1) THEN
            Re_Open(shipment_id_);
            IF (NVL(qty_modification_source_,  Database_Sys.string_null_) != 'HANDLING_UNIT') THEN 
               -- when qty_modification_source_ = HANDLING_UNIT this message is raised from Reassign_Shipment_Utility_API.Reassign_Handling_Unit
               Client_SYS.Add_Info(lu_name_, 'SHIPCHEDTOPRELIM: The status of shipment ID :P1 is changed to Preliminary.', shipment_id_);
            END IF;
         ELSE
            Error_Sys.Record_General(lu_name_, 'CHGTOPRELIMNOTALLOWED: The status of shipment ID :P1 cannot be changed to Preliminary.', shipment_id_);
         END IF;
      END IF;
   END IF;
   Modify_Source_Ref_Type(shipment_id_, source_ref_type_, delete_);   
END Update_Shipment__;   


-- Complete_Shipment_Allowed__
--   Returns TRUE (1) if the Complete operation is allowed for the specified shipment.
FUNCTION Complete_Shipment_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate = 'Preliminary';
BEGIN
   IF (Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      allowed_ := Complete_Shipment_Allowed___(shipment_id_);
   ELSE
      allowed_ := 0;
      FOR rec_ IN get_connected_shipments LOOP
         IF (Complete_Shipment_Allowed___(rec_.shipment_id) = 1) THEN
            allowed_ := 1;
         ELSE
            allowed_ := 0;
            EXIT;            
         END IF;        
      END LOOP;      
   END IF;
   RETURN allowed_;   
END Complete_Shipment_Allowed__;


-- Reopen_Shipment_Allowed__
--   Returns TRUE (1) if the ReOpen operation is allowed for the specified shipment.
FUNCTION Reopen_Shipment_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   rec_     SHIPMENT_TAB%ROWTYPE;

   CURSOR get_connected_shipments IS
      SELECT *
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate = 'Completed';
BEGIN
   rec_ := Get_Object_By_Keys___(shipment_id_);
   IF (rec_.rowstate = 'Completed') THEN  
      IF (rec_.shipment_category = 'NORMAL') THEN
         IF (Shipment_Delivered___(shipment_id_) = 'FALSE') THEN
            allowed_ := 1;
         ELSE
            allowed_ := 0;
         END IF;
      ELSE
         allowed_ := 0;
         FOR ship_rec_ IN get_connected_shipments LOOP
            IF (Shipment_Delivered___(ship_rec_.shipment_id) = 'FALSE') THEN
               allowed_ := 1;
            ELSE
               allowed_ := 0;
               EXIT;
            END IF;
         END LOOP;      
      END IF;
   END IF;
   RETURN allowed_;   
END Reopen_Shipment_Allowed__;


-- Close_Shipment_Allowed__
--   Returns TRUE (1) if the Close operation is allowed for the specified shipment.
FUNCTION Close_Shipment_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate NOT IN ('Closed', 'Cancelled');
BEGIN
   IF (Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      allowed_ := Close_Shipment_Allowed___(shipment_id_);
   ELSE
      allowed_ := 0;
      FOR rec_ IN get_connected_shipments LOOP
         IF (Close_Shipment_Allowed___(rec_.shipment_id) = 1) THEN
            allowed_ := 1;
         ELSE
            allowed_ := 0;
            EXIT;
         END IF;        
      END LOOP;      
   END IF;
   RETURN allowed_;   
END Close_Shipment_Allowed__;


-- Send_Disadv_Allowed__
--   Returns TRUE (1) if the send dispatch advice option is allowed for the specified shipment.
@UncheckedAccess
FUNCTION Send_Disadv_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_      NUMBER := 0;
   ship_rec_     Public_Rec;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id, receiver_id, receiver_type
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate IN ('Completed', 'Closed');
BEGIN   
   ship_rec_ := Get(shipment_id_);
   IF (ship_rec_.shipment_category = 'NORMAL') THEN
      IF (ship_rec_.rowstate IN ('Completed', 'Closed')) AND
         (All_Lines_Delivered__(shipment_id_)=1) AND (Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_) IS NOT NULL) AND
         (Shipment_Source_Utility_API.Get_Default_Media_Code(ship_rec_.receiver_id,'DESADV', ship_rec_.receiver_type) IS NOT NULL)  THEN
         allowed_ := 1;
      END IF;
   ELSE      
      FOR rec_ IN get_connected_shipments LOOP
         IF (All_Lines_Delivered__(rec_.shipment_id)=1) AND (Delivery_Note_API.Get_Delnote_No_For_Shipment(rec_.shipment_id) IS NOT NULL) AND
            (Shipment_Source_Utility_API.Get_Default_Media_Code(rec_.receiver_id,'DESADV', rec_.receiver_type) IS NOT NULL)  THEN
            allowed_ := 1;
            EXIT;         
         END IF;        
      END LOOP;      
   END IF;
   RETURN allowed_;   
END Send_Disadv_Allowed__;


-- Pack_Acc_HU_Capacity_Allowed__
--   Returns TRUE (1) if the Pack according to Handling Unit Capacity option is allowed for the specified shipment.
@UncheckedAccess
FUNCTION Pack_Acc_HU_Capacity_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM SHIPMENT_TAB
      WHERE parent_consol_shipment_id = shipment_id_
      AND   rowstate = 'Preliminary';
BEGIN   
   IF (Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      IF (Get_Objstate(shipment_id_) = 'Preliminary') THEN
         allowed_ := Connected_Lines_Exist(shipment_id_);
      END IF;
   ELSE      
      FOR rec_ IN get_connected_shipments LOOP
         IF (Connected_Lines_Exist(rec_.shipment_id) = 1) THEN
            allowed_ := 1;
            EXIT;         
         END IF;        
      END LOOP;      
   END IF;
   RETURN allowed_;   
END Pack_Acc_HU_Capacity_Allowed__;


-- Pack_Acc_Pack_Instr_Allowed__
--   Returns TRUE (1) if the Pack according to Packing Instruction option is allowed for the specified shipment.
@UncheckedAccess
FUNCTION Pack_Acc_Pack_Instr_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER := 0;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM SHIPMENT_TAB
      WHERE parent_consol_shipment_id = shipment_id_
      AND   rowstate = 'Preliminary';
BEGIN   
   IF (Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      IF (Get_Objstate(shipment_id_) = 'Preliminary') THEN
         allowed_ := Connected_Lines_Exist(shipment_id_);
      END IF;
   ELSE      
      FOR rec_ IN get_connected_shipments LOOP
         IF (Connected_Lines_Exist(rec_.shipment_id) = 1) THEN
            allowed_ := 1;
            EXIT;         
         END IF;        
      END LOOP;      
   END IF;
   RETURN allowed_;   
END Pack_Acc_Pack_Instr_Allowed__;


@UncheckedAccess
FUNCTION Pack_Acc_Pack_Prop_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_        NUMBER := 0;
   shipment_rec_   SHIPMENT_TAB%ROWTYPE;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id
        FROM SHIPMENT_TAB
       WHERE parent_consol_shipment_id = shipment_id_
         AND rowstate = 'Preliminary'
         AND packing_proposal_id IS NOT NULL;   
BEGIN   
   shipment_rec_ := Get_Object_By_Keys___(shipment_id_);
   IF (shipment_rec_.shipment_category = 'NORMAL') THEN
      IF ((shipment_rec_.rowstate = 'Preliminary') AND (shipment_rec_.packing_proposal_id IS NOT NULL)) THEN
         IF (Any_Unpicked_Reservations__(shipment_rec_.shipment_id) = 'TRUE') THEN
            allowed_ := 1;
         END IF;
      END IF;
   ELSE      
      FOR rec_ IN get_connected_shipments LOOP
         IF (Any_Unpicked_Reservations__(rec_.shipment_id) = 'TRUE') THEN
            allowed_ := 1;
            EXIT;         
         END IF;        
      END LOOP;      
   END IF;
   RETURN allowed_;     
END Pack_Acc_Pack_Prop_Allowed__;


-- Delivery_Note_Exist__
--   Returns TRUE (1) if delivery note exists for the shipment.
@UncheckedAccess
FUNCTION Delivery_Note_Exist__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   exist_        NUMBER := 0;
   ship_rec_     Public_Rec;
   
   CURSOR get_connected_shipments IS
      SELECT shipment_id, receiver_type
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate != 'Cancelled';
BEGIN   
   ship_rec_ := Get(shipment_id_);
   IF (ship_rec_.shipment_category = 'NORMAL') THEN
      IF (Delivery_Note_API.Get_Delnote_No_For_Shipment(shipment_id_) IS NOT NULL) THEN
         exist_ := 1;      
      END IF;      
   ELSE      
      FOR rec_ IN get_connected_shipments LOOP
         IF (Delivery_Note_API.Get_Delnote_No_For_Shipment(rec_.shipment_id) IS NOT NULL) THEN
            exist_ := 1;
            EXIT;         
         END IF;        
      END LOOP;      
   END IF;
   RETURN exist_;   
END Delivery_Note_Exist__;


-- Lock_By_Keys__
--   Lock the Shipment record.
PROCEDURE Lock_By_Keys__ (
   shipment_id_ IN NUMBER )
IS
   rec_ SHIPMENT_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Keys___(shipment_id_);
END Lock_By_Keys__;


-- Complete_Shipment__
--   This method is used by the client to complete a shipment.
PROCEDURE Complete_Shipment__ (
   shipment_id_ IN VARCHAR2 )
IS
   attr_                     VARCHAR2(2000);
   info_                     VARCHAR2(2000);
   objid_                    VARCHAR2(2000);
   objversion_               VARCHAR2(2000); 
   shipment_line_no_         SHIPMENT_LINE_TAB.shipment_line_no%TYPE;
   qty_not_reserved_         NUMBER;
   max_pkg_comp_reserved_    NUMBER;
   not_reserved_qty_found_   BOOLEAN:=FALSE;   
   
   CURSOR get_not_reserved IS
      SELECT DECODE(inventory_part_no, NULL, (inventory_qty - qty_to_ship), (inventory_qty - qty_assigned)) qty_not_reserved,
             shipment_line_no
        FROM SHIPMENT_LINE_TAB
       WHERE (((source_ref_type  = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) = 0)) OR
              (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))
         AND shipment_id  = shipment_id_
         AND ((inventory_part_no IS NOT NULL AND (inventory_qty > qty_assigned)) OR
              (inventory_part_no IS NULL     AND (inventory_qty > qty_to_ship)));

   CURSOR get_not_reserved_packages IS
      SELECT source_ref1, source_ref2, source_ref3, inventory_qty 
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id = shipment_id_
         AND (source_ref_type  = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER)
         AND (Utility_SYS.String_To_Number(source_ref4) = -1) 
         AND (inventory_qty > qty_assigned);

BEGIN
   OPEN  get_not_reserved;
   FETCH get_not_reserved INTO qty_not_reserved_, shipment_line_no_;
   CLOSE get_not_reserved;
   IF (NVL(qty_not_reserved_, 0) > 0 ) THEN
      -- for Inventory Part with line_item_no = 0, Connected Sales Qty (revised qty due) > Reserved Qty on any Shipment Line
      -- for Non-Inventory Part with line_item_no = 0, onnected Sales Qty > Non-Inventory Quantity to be Delivered
      not_reserved_qty_found_ := TRUE;
   ELSE
      IF(Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN
         FOR not_reserved_pkg_rec_ IN get_not_reserved_packages LOOP
            $IF Component_Order_SYS.INSTALLED $THEN 
               max_pkg_comp_reserved_ := Shipment_Order_Utility_API.Get_Max_Pkg_Comp_Reserved(shipment_id_, not_reserved_pkg_rec_.source_ref1, 
                                                                                              not_reserved_pkg_rec_.source_ref2, not_reserved_pkg_rec_.source_ref3);
               IF (not_reserved_pkg_rec_.inventory_qty > NVL(max_pkg_comp_reserved_, 0)) THEN
                  -- for Package Part, Connected Sales Qty (revised qty due) of Package > Find component with most complete packages
                  not_reserved_qty_found_ := TRUE;
                  qty_not_reserved_       := not_reserved_pkg_rec_.inventory_qty - NVL(max_pkg_comp_reserved_, 0);                  
                  EXIT;
               END IF;                                                     
            $ELSE
               NULL; 
            $END                                                      
         END LOOP;
      END IF;	  
      Validate_Ship_Reservation___(shipment_id_);         
   END IF;
   
   IF (Pick_Shipment_API.Unreported_Pick_Lists_Exist(shipment_id_) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'UNREPORTPICKLIST: You cannot complete shipment :P1, there are still pick list lines to be report.', shipment_id_);
   END IF;
   
   IF not_reserved_qty_found_ THEN      
      Error_SYS.Record_General(lu_name_, 
                               'NOTRESQTY: You cannot complete shipment :P1, there still exists a connected quantity of :P2 to be released or reserved on shipment line :P3.',
                               shipment_id_, qty_not_reserved_, shipment_line_no_);                                                      
      
   END IF;
   
   shipment_line_no_ := Pick_Shipment_API.Get_Res_Not_Pick_Listed_Line(shipment_id_); 
   IF (shipment_line_no_ IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 
                               'RESNOTPICKLIST: You cannot complete shipment :P1, as there are reserved quantities that have not been pick-listed on shipment line :P2.', 
                               shipment_id_, shipment_line_no_);        
   END IF;
   
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   Complete__(info_, objid_, objversion_, attr_, 'DO');
END Complete_Shipment__;


@UncheckedAccess
FUNCTION Cancel_Shipment_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate != 'Cancelled';

   allowed_ NUMBER := 0;
BEGIN
   IF (Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      allowed_:= Cancel_Shipment_Allowed___(shipment_id_);
   ELSE
      FOR rec_ IN get_connected_shipments LOOP
         IF (Cancel_Shipment_Allowed___(rec_.shipment_id) = 0) THEN
            allowed_ := 0;
            EXIT;
         ELSE
            allowed_ := 1;
         END IF;
      END LOOP;
      IF (Shipments_Connected__(shipment_id_) = 0) AND (Get_Objstate(shipment_id_) != 'Cancelled') THEN
         allowed_ := 1;
      END IF; 
   END IF;
   RETURN allowed_;
END Cancel_Shipment_Allowed__;


PROCEDURE Cancel_Shipment__ (
   shipment_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate != 'Cancelled';
BEGIN
   IF (Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      IF (Connected_Lines_Exist(shipment_id_) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'CONNECTEDLINES: Cannot cancel a shipment having shipment lines.');
      END IF;

      IF (Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(shipment_id_) = Fnd_Boolean_API.DB_TRUE) THEN
         Error_SYS.Record_General(lu_name_, 'CONNECTEDHUNITS: Cannot cancel the shipment due to connected handling units.');
      END IF;
      Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
      Cancel__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      FOR rec_ IN get_connected_shipments LOOP
         Get_Id_Version_By_Keys___(objid_, objversion_, rec_.shipment_id);
         Cancel__(info_, objid_, objversion_, attr_, 'DO');          
      END LOOP;
      IF (Shipments_Connected__(shipment_id_) = 0) THEN
	     Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
	     Cancel__(info_, objid_, objversion_, attr_, 'DO');
	  END IF;
   END IF;
END Cancel_Shipment__;


-- All_Lines_Delivered__
--   Returns 1 if all lines connected to the shipment are delivered otherwise 0.
@UncheckedAccess
FUNCTION All_Lines_Delivered__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_ NUMBER;
   rec_     SHIPMENT_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(shipment_id_);

   IF (All_Lines_Delivered___(rec_)) THEN
      allowed_ := 1;
   ELSE
      allowed_ := 0;
   END IF;

   RETURN allowed_;
END All_Lines_Delivered__;


-- Any_Picked_Lines__
--   This method returns TRUE if there exist any picked quantities on the
--   Shipment connected lines.
@UncheckedAccess
FUNCTION Any_Picked_Lines__ (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   exist_  VARCHAR2(5) := 'FALSE';
   picked_ NUMBER;

   CURSOR get_picked_lines IS
    SELECT 1
    FROM  SHIPMENT_LINE_TAB 
    WHERE shipment_id = shipment_id_  
    AND   qty_picked > 0;
BEGIN
   OPEN get_picked_lines;
   FETCH get_picked_lines INTO picked_;
   IF (get_picked_lines%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE get_picked_lines;
   RETURN exist_;
END Any_Picked_Lines__;


-- Any_Unpicked_Reservations__
--   This method returns TRUE if there exist any reserved quantities in excess
--   or equal to picked quantities on the Shipment connected lines.
@UncheckedAccess
FUNCTION Any_Unpicked_Reservations__ (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   exist_    VARCHAR2(5) := 'FALSE';
   reserved_ NUMBER;

   CURSOR get_reserved_lines IS
      SELECT 1
      FROM  SHIPMENT_LINE_TAB
      WHERE shipment_id = shipment_id_    
      AND   qty_assigned > qty_picked;
BEGIN
   OPEN get_reserved_lines;
   FETCH get_reserved_lines INTO reserved_;
   IF (get_reserved_lines%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE get_reserved_lines;
   RETURN exist_;
END Any_Unpicked_Reservations__;


PROCEDURE Refresh_Parent__ (
   shipment_id_ IN NUMBER )
IS
   rec_  SHIPMENT_TAB%ROWTYPE;
   attr_ VARCHAR2(32000);  
BEGIN
   rec_ := Get_Object_By_Keys___(shipment_id_);   
   IF (rec_.rowstate != 'Cancelled') THEN   
      rec_ := Lock_By_Keys___(shipment_id_);     
      Finite_State_Machine___(rec_, NULL, attr_);
   END IF;
END Refresh_Parent__;


@UncheckedAccess
FUNCTION Shipments_Connected__(
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   found_ NUMBER := 0;

   CURSOR get_connected_shipments IS
      SELECT 1
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_;
BEGIN
   OPEN get_connected_shipments;
   FETCH get_connected_shipments INTO found_;
   CLOSE get_connected_shipments;
   RETURN found_; 
END Shipments_Connected__;


PROCEDURE Modify_Parent_Shipment_Id__ (
   shipment_id_              IN NUMBER,
   consolidated_shipment_id_ IN NUMBER)
IS  
   newrec_     SHIPMENT_TAB%ROWTYPE;
BEGIN
   newrec_                           := Lock_By_Keys___(shipment_id_);
   newrec_.parent_consol_shipment_id := consolidated_shipment_id_;   
   Modify___(newrec_);
END Modify_Parent_Shipment_Id__;


PROCEDURE Modify_Auto_Connect_Blocked__ (
   shipment_id_                IN NUMBER,
   auto_connection_blocked_db_ IN VARCHAR2 )
IS  
   newrec_     SHIPMENT_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   newrec_                         := Lock_By_Id___(objid_, objversion_);
   newrec_.auto_connection_blocked := auto_connection_blocked_db_;
   Modify___(newrec_, FALSE);
END Modify_Auto_Connect_Blocked__;


-- Approve_Shipment_Allowed__
--   Checks if a shipment is allowed to be approved.
@UncheckedAccess
FUNCTION Approve_Shipment_Allowed__ (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   allowed_   NUMBER := 0;
   dummy_     NUMBER;    
   
   CURSOR get_shipments IS
      SELECT 1
        FROM shipment_tab
       WHERE shipment_id = shipment_id_
         AND shipment_category = 'NORMAL'
         AND approve_before_delivery = 'TRUE' 
         AND rowstate IN ('Completed', 'Preliminary');
BEGIN   
   IF (Shipment_Delivered___(shipment_id_) = Fnd_Boolean_API.DB_FALSE) THEN   
      OPEN get_shipments;
      FETCH get_shipments INTO dummy_;
      IF (get_shipments%FOUND) THEN
         allowed_ := 1;
      END IF;
      CLOSE get_shipments;
   END IF;
   RETURN allowed_;
END Approve_Shipment_Allowed__;
 
-- Get_Net_And_Adjusted_Weight__
--   Returns the weight and adjusted wheight of the shipment or shipment line.
PROCEDURE Get_Net_And_Adjusted_Weight__(
   net_weight_           OUT NUMBER,
   adj_net_weight_       OUT NUMBER,
   shipment_id_          IN  NUMBER,
   uom_for_weight_       IN  VARCHAR2,
   shipment_line_no_     IN  NUMBER  )
IS
BEGIN
   Get_Net_And_Adjusted_Weight___(net_weight_, adj_net_weight_, shipment_id_, uom_for_weight_, shipment_line_no_);
END Get_Net_And_Adjusted_Weight__;

-- Any_Connected_Lines__
--   Checks if any shipment lines have been connected to the shipment.
@UncheckedAccess
FUNCTION Connected_Lines_Exist (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_                    NUMBER;
   connected_lines_exist_   NUMBER := 0;
   
   CURSOR connected_lines_exist IS
      SELECT 1
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id = shipment_id_;
BEGIN
   OPEN connected_lines_exist;
   FETCH connected_lines_exist INTO temp_;
   IF(connected_lines_exist%FOUND) THEN
      connected_lines_exist_ := 1; 
   END IF;
   CLOSE connected_lines_exist;
   RETURN connected_lines_exist_;
END Connected_Lines_Exist;


-- Get_Receiver_Information__
-- This procedure will be called from the client when validating the receiver id
-- For different receiver types, the validations and fetching of default values should be implemented here.
PROCEDURE Get_Receiver_Information__ (
   attr_          OUT   VARCHAR2,
   ship_attr_     IN    VARCHAR2 )
IS
   receiver_id_      Shipment_Tab.receiver_id%TYPE;   
   contract_         Shipment_Tab.contract%TYPE;
   receiver_type_db_ VARCHAR2(200);   
BEGIN
   Client_SYS.Clear_Attr(attr_);  
   receiver_id_      := Client_SYS.Get_Item_Value('RECEIVER_ID', ship_attr_);
   contract_         := Client_SYS.Get_Item_Value('CONTRACT', ship_attr_);
   receiver_type_db_ := Client_SYS.Get_Item_Value('RECEIVER_TYPE_DB', ship_attr_);
   Shipment_Source_Utility_API.Get_Receiver_Information(attr_, receiver_id_, contract_, receiver_type_db_);   
END Get_Receiver_Information__;


@UncheckedAccess
FUNCTION Any_Printed_Flag_Set__ (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   printed_flag_set_  VARCHAR2(5) := 'FALSE';
   dummy_             NUMBER; 
   
   CURSOR get_printed_flag_set IS
      SELECT 1
        FROM SHIPMENT_TAB
       WHERE shipment_id = shipment_id_
         AND (address_label_printed     = Fnd_Boolean_API.DB_TRUE
              OR pro_forma_printed      = Gen_Yes_No_API.DB_YES
              OR del_note_printed       = Gen_Yes_No_API.DB_YES
              OR bill_of_lading_printed = Gen_Yes_No_API.DB_YES
              OR consignment_printed    = Gen_Yes_No_API.DB_YES
              OR package_list_printed   = Gen_Yes_No_API.DB_YES);
BEGIN
   OPEN get_printed_flag_set;
   FETCH get_printed_flag_set INTO dummy_;
   IF (get_printed_flag_set%FOUND) THEN
      printed_flag_set_ := 'TRUE';
   END IF;
   CLOSE get_printed_flag_set;
   RETURN printed_flag_set_;
END Any_Printed_Flag_Set__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Modify_Ship_Inv_Location_No
--   This method modifies the shipment inventory location of a considered shipment from a given shipment inventory location.
PROCEDURE Modify_Ship_Inv_Location_No (
   shipment_id_ IN NUMBER,
   location_no_ IN VARCHAR2 ) 
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     SHIPMENT_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   newrec_                            := Lock_By_Id___(objid_, objversion_);
   newrec_.ship_inventory_location_no := location_no_;
   Modify___(newrec_, FALSE);
END Modify_Ship_Inv_Location_No; 


-- Modify_Approve_Before_Delivery
--   This method modifies the 'Approve before Delivery' of a considered shipment.
PROCEDURE Modify_Approve_Before_Delivery (
   shipment_id_             IN NUMBER,
   approve_before_delivery_ IN VARCHAR2 ) 
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   oldrec_     SHIPMENT_TAB%ROWTYPE;
   newrec_     SHIPMENT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   Client_Sys.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('APPROVE_BEFORE_DELIVERY_DB', approve_before_delivery_, attr_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_Approve_Before_Delivery;


PROCEDURE Re_Open (
   shipment_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_connected_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate = 'Completed';
BEGIN
   IF (Get_Shipment_Category_Db(shipment_id_) = 'NORMAL') THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
      Re_Open__(info_, objid_, objversion_, attr_, 'DO'); 
   ELSE
      FOR rec_ IN get_connected_shipments LOOP
         IF (Reopen_Shipment_Allowed__(rec_.shipment_id) = 1) THEN
            Get_Id_Version_By_Keys___(objid_, objversion_, rec_.shipment_id);
            Re_Open__(info_, objid_, objversion_, attr_, 'DO');
         END IF; 
      END LOOP;
   END IF;
END Re_Open;


@UncheckedAccess
FUNCTION Get_Total_Open_Shipment_Qty (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   open_shipment_qty_ NUMBER;
   CURSOR get_open_shipment_qty IS
      SELECT SUM(GREATEST(inventory_qty, qty_assigned))
      FROM   shipment_line_tab sol, SHIPMENT_TAB s
      WHERE  sol.shipment_id = s.shipment_id
      AND    s.rowstate != 'Closed'
      AND    NVL(sol.source_ref1, string_null_) = NVL(source_ref1_, string_null_)
      AND    NVL(sol.source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND    NVL(sol.source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND    NVL(sol.source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND    sol.source_ref_type = source_ref_type_db_
      AND    sol.qty_shipped = 0;
BEGIN
   OPEN get_open_shipment_qty;
   FETCH get_open_shipment_qty INTO open_shipment_qty_;
   CLOSE get_open_shipment_qty;
   RETURN NVL(open_shipment_qty_, 0);
END Get_Total_Open_Shipment_Qty;


PROCEDURE Add_Empty_Handl_Unit_Structure (
   shipment_id_            IN NUMBER,
   packing_instruction_id_ IN VARCHAR2,
   number_of_structures_   IN NUMBER )
IS
    handling_unit_id_ NUMBER;
BEGIN
   IF (NOT (number_of_structures_ > 0) OR number_of_structures_ != ROUND(number_of_structures_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOOFPACKINSTRS: No of Packing Instructions must be a positive integer.');
   END IF;
   
   FOR counter_ IN 1..number_of_structures_ LOOP
      Packing_Instruction_API.Create_Handling_Unit_Structure(handling_unit_id_, packing_instruction_id_, shipment_id_);
   END LOOP;   
END Add_Empty_Handl_Unit_Structure;


-- Get_Net_Weight
--   Returns the net weight for a given normal or consolidated shipment
@UncheckedAccess
FUNCTION Get_Net_Weight (
   shipment_id_          IN NUMBER,
   uom_for_weight_       IN VARCHAR2,
   apply_freight_factor_ IN VARCHAR2 ) RETURN NUMBER
IS
   net_weight_      NUMBER;
   adj_net_weight_  NUMBER;
BEGIN
   Get_All_Net_Weight___(net_weight_, adj_net_weight_, shipment_id_, uom_for_weight_);
   
   IF (apply_freight_factor_ = Fnd_Boolean_API.DB_TRUE) THEN
      RETURN adj_net_weight_;
   ELSE
      RETURN net_weight_;
   END IF;
END Get_Net_Weight;

-- Get_Shipment_Tare_Weight
--   Returns the tare weight for a given normal or consolidated shipment
@UncheckedAccess
FUNCTION Get_Shipment_Tare_Weight (
   shipment_id_    IN NUMBER,
   uom_for_weight_ IN VARCHAR2 ) RETURN NUMBER
IS
   tare_weight_ NUMBER := 0;
   
   CURSOR get_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  rowstate != 'Cancelled'
      AND    parent_consol_shipment_id = shipment_id_;
BEGIN
   IF (Get_Shipment_Category_Db(shipment_id_) = 'CONSOLIDATED') THEN
      FOR rec_ IN get_shipments LOOP
         tare_weight_ := tare_weight_ + Handling_Unit_Ship_Util_API.Get_Shipment_Tare_Weight(rec_.shipment_id, uom_for_weight_);
      END LOOP;  
   ELSE
      tare_weight_ := Handling_Unit_Ship_Util_API.Get_Shipment_Tare_Weight(shipment_id_, uom_for_weight_);
   END IF;
   
   RETURN tare_weight_;
END Get_Shipment_Tare_Weight;


-- Get_Operational_Gross_Weight
--   Returns the operational gross weight for a given normal or consolidated shipment
@UncheckedAccess
FUNCTION Get_Operational_Gross_Weight (
   shipment_id_          IN NUMBER,
   uom_for_weight_       IN VARCHAR2,
   apply_freight_factor_ IN VARCHAR2 ) RETURN NUMBER
IS
   lu_rec_                   SHIPMENT_TAB%ROWTYPE;
   operational_gross_weight_ SHIPMENT_TAB.manual_gross_weight%TYPE := 0; 
   
    CURSOR get_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  rowstate != 'Cancelled'
      AND    parent_consol_shipment_id = shipment_id_;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(shipment_id_);
   IF (lu_rec_.shipment_category = 'CONSOLIDATED') THEN
      IF (lu_rec_.manual_gross_weight IS NOT NULL) THEN
         operational_gross_weight_ := lu_rec_.manual_gross_weight;
      ELSE
         FOR rec_ IN get_shipments LOOP
            operational_gross_weight_ := operational_gross_weight_ +  Get_Op_Gross_Weight___(rec_.shipment_id, uom_for_weight_, apply_freight_factor_);
         END LOOP;
      END IF;
   ELSE
      operational_gross_weight_ :=  Get_Op_Gross_Weight___(shipment_id_, uom_for_weight_, apply_freight_factor_);
   END IF;
   
   RETURN operational_gross_weight_;
END Get_Operational_Gross_Weight;


PROCEDURE Remove_Manual_Gross_Weight (
   shipment_id_ IN NUMBER )
IS
   oldrec_        SHIPMENT_TAB%ROWTYPE;
   newrec_        SHIPMENT_TAB%ROWTYPE;
   empty_number_  NUMBER;
BEGIN
   oldrec_ := Lock_By_Keys___(shipment_id_);
   IF (oldrec_.manual_gross_weight IS NOT NULL) THEN
      newrec_                     := oldrec_;
      newrec_.manual_gross_weight := empty_number_;      
      Modify___(newrec_);
   END IF;
   IF (oldrec_.parent_consol_shipment_id IS NOT NULL) THEN
      Remove_Manual_Gross_Weight(oldrec_.parent_consol_shipment_id);
   END IF;
END Remove_Manual_Gross_Weight;


-- Get_Operational_Volume
--   Returns the operational volume for a given normal or consolidated shipment
@UncheckedAccess
FUNCTION Get_Operational_Volume (
   shipment_id_    IN NUMBER,
   uom_for_volume_ IN VARCHAR2 ) RETURN NUMBER
IS
   lu_rec_             SHIPMENT_TAB%ROWTYPE;
   operational_volume_ SHIPMENT_TAB.manual_volume%TYPE := 0;

    CURSOR get_shipments IS
      SELECT shipment_id
      FROM   SHIPMENT_TAB
      WHERE  rowstate != 'Cancelled'
      AND    parent_consol_shipment_id = shipment_id_;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(shipment_id_);
   IF (lu_rec_.shipment_category = 'CONSOLIDATED') THEN
      IF (lu_rec_.manual_volume IS NOT NULL) THEN
         operational_volume_ := lu_rec_.manual_volume;
      ELSE 
         FOR rec_ IN get_shipments LOOP
            operational_volume_ := operational_volume_ +  Get_Operational_Volume___(rec_.shipment_id, uom_for_volume_);
         END LOOP;     
      END IF;
   ELSE
      operational_volume_ := Get_Operational_Volume___(shipment_id_, uom_for_volume_);
   END IF;
   
   RETURN operational_volume_;
END Get_Operational_Volume;


PROCEDURE Remove_Manual_Volume (
   shipment_id_ IN NUMBER )
IS
   oldrec_        SHIPMENT_TAB%ROWTYPE;
   newrec_        SHIPMENT_TAB%ROWTYPE;
   empty_number_  NUMBER;
BEGIN
   oldrec_ := Lock_By_Keys___(shipment_id_);
   IF (oldrec_.manual_volume IS NOT NULL) THEN
      newrec_               := oldrec_; 
      newrec_.manual_volume := empty_number_;
      Modify___(newrec_);
   END IF;
   IF (oldrec_.parent_consol_shipment_id IS NOT NULL) THEN
      Remove_Manual_Volume(oldrec_.parent_consol_shipment_id);
   END IF;
END Remove_Manual_Volume;


-- Get_Consol_Actual_Ship_Date
--   Returns the latest ship date from all the shipments connected to a consolidated shipment
@UncheckedAccess
FUNCTION Get_Consol_Actual_Ship_Date (
   shipment_id_ IN NUMBER ) RETURN DATE 
IS 
   actual_ship_date_    DATE;
   all_delivered_       BOOLEAN := TRUE;
   shipments_connected_ BOOLEAN := FALSE;
   
   CURSOR get_shipments IS
      SELECT shipment_id, source_ref_type
      FROM   shipment_tab
      WHERE  parent_consol_shipment_id = shipment_id_
      AND    rowstate != 'Cancelled';

   CURSOR get_max_delivery_date IS
      SELECT MAX(actual_ship_date)
      FROM   shipment_tab
      WHERE parent_consol_shipment_id = shipment_id_;
BEGIN  
   FOR rec_ IN get_shipments LOOP
      shipments_connected_ := TRUE;
      IF (Shipment_Delivered___(rec_.shipment_id) = Fnd_Boolean_API.DB_FALSE) THEN
         all_delivered_ := FALSE;
         EXIT;
      END IF;
   END LOOP;
   IF (shipments_connected_) AND (all_delivered_) THEN
      OPEN get_max_delivery_date;
      FETCH get_max_delivery_date INTO actual_ship_date_;
      CLOSE get_max_delivery_date;
   END IF;
   RETURN actual_ship_date_;
END Get_Consol_Actual_Ship_Date;


@UncheckedAccess
FUNCTION Get_Converted_Weight_Capacity (
   transport_unit_type_ IN VARCHAR2,
   uom_for_weight_      IN VARCHAR2) RETURN NUMBER
IS
   rec_ Transport_Unit_Type_API.Public_Rec;
BEGIN
   rec_ := Transport_Unit_Type_API.Get(transport_unit_type_);
   RETURN Iso_Unit_API.Get_Unit_Converted_Quantity(rec_.weight_capacity, rec_.uom_for_weight, uom_for_weight_);
END Get_Converted_Weight_Capacity;


@UncheckedAccess
FUNCTION Get_Converted_Volume_Capacity (
   transport_unit_type_ IN VARCHAR2,
   uom_for_volume_      IN VARCHAR2) RETURN NUMBER
IS
   rec_ Transport_Unit_Type_API.Public_Rec;
BEGIN
   rec_ := Transport_Unit_Type_API.Get(transport_unit_type_);
   RETURN Iso_Unit_API.Get_Unit_Converted_Quantity(rec_.volume_capacity, rec_.uom_for_volume, uom_for_volume_);
END Get_Converted_Volume_Capacity;


PROCEDURE Approve_Shipment (
   shipment_id_ IN NUMBER )
IS
   
   newrec_       SHIPMENT_TAB%ROWTYPE;
   session_user_ VARCHAR2(20);
   approver_     VARCHAR2(20);
BEGIN
   session_user_ := Fnd_Session_API.Get_Fnd_User;
   approver_     := Person_Info_API.Get_Id_For_User(session_user_);
   IF (approver_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOPERRECORD: Logon user :P1 is not connected to an application person id.', session_user_);
   END IF;
   newrec_                         := Lock_By_Keys___(shipment_id_);
   newrec_.approve_before_delivery := Fnd_Boolean_API.DB_FALSE;
   newrec_.approved_by             := approver_;
   Modify___(newrec_);
END Approve_Shipment;


PROCEDURE Get_Consol_Ship_Delnote_Nos (
    delnote_nos_ OUT VARCHAR2,
    shipment_id_ IN  NUMBER )
IS
   delnote_no_ VARCHAR2(15);

   CURSOR get_connected_shipments IS
      SELECT shipment_id, receiver_type
      FROM   SHIPMENT_TAB
      WHERE  parent_consol_shipment_id =  shipment_id_
      AND    rowstate != 'Cancelled';
BEGIN
   FOR rec_ IN get_connected_shipments LOOP
      delnote_no_ := Delivery_Note_API.Get_Delnote_No_For_Shipment(rec_.shipment_id);
      IF (delnote_no_ IS NOT NULL) THEN
         IF (LENGTH(delnote_nos_ || delnote_no_ ||Client_SYS.field_separator_) < 30000) THEN
            delnote_nos_ := delnote_nos_ || delnote_no_ ||Client_SYS.field_separator_;           
         ELSE
            Error_SYS.Record_General(lu_name_, 'LENGTHEXCEED: Many shipments are connected to consolidated shipment(s). Delivery note analysis cannot be supported.');
         END IF;
      END IF;
   END LOOP;
END Get_Consol_Ship_Delnote_Nos;


PROCEDURE Refresh_Values_On_Shipment(
   shipment_id_ IN NUMBER)
IS
   CURSOR get_connected_lines IS
      SELECT  source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type
        FROM  shipment_line_tab
        WHERE shipment_id = shipment_id_;

   first_record_      BOOLEAN := FALSE;
   source_ref1_       SHIPMENT_TAB.source_ref1%TYPE;
   planned_ship_date_ SHIPMENT_TAB.planned_ship_date%TYPE;
   planned_del_date_  SHIPMENT_TAB.planned_delivery_date%TYPE;
   forwarder_         SHIPMENT_TAB.forward_agent_id%TYPE;
   route_id_          SHIPMENT_TAB.route_id%TYPE;
   reference_         SHIPMENT_TAB.ref_id%TYPE;
   dock_              SHIPMENT_TAB.dock_code%TYPE;
   sub_dock_          SHIPMENT_TAB.sub_dock_code%TYPE;
   location_          SHIPMENT_TAB.location_no%TYPE;
   attr_              VARCHAR2(32000); 
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   oldrec_            SHIPMENT_TAB%ROWTYPE;
   newrec_            SHIPMENT_TAB%ROWTYPE;  
   indrec_            Indicator_Rec;
   public_line_rec_   Shipment_Source_Utility_API.Public_Line_Rec;
BEGIN
   FOR rec_ IN get_connected_lines LOOP  
      public_line_rec_ := Shipment_Source_Utility_API.Get_Line(rec_.source_ref1, rec_.source_ref2,
                                                               rec_.source_ref3, rec_.source_ref4, rec_.source_ref_type);
      IF NOT (first_record_) THEN
         first_record_        := TRUE;
         route_id_            := public_line_rec_.route_id;
         forwarder_           := public_line_rec_.forward_agent_id;
         planned_ship_date_   := public_line_rec_.planned_ship_date;
         planned_del_date_    := public_line_rec_.planned_delivery_date;
         source_ref1_         := public_line_rec_.source_ref1;
         dock_                := public_line_rec_.dock_code;
         sub_dock_            := public_line_rec_.sub_dock_code;
         reference_           := public_line_rec_.ref_id;
         location_            := public_line_rec_.location_no;
      ELSE
         IF (NVL(route_id_, Database_SYS.string_null_) != NVL(public_line_rec_.route_id, Database_SYS.string_null_)) THEN
            route_id_ := NULL; 
         END IF;

         IF (NVL(forwarder_, Database_SYS.string_null_) != NVL(public_line_rec_.forward_agent_id, Database_SYS.string_null_)) THEN
            forwarder_ := NULL;
         END IF;

         IF (planned_ship_date_ != public_line_rec_.planned_ship_date) THEN
            planned_ship_date_ := NULL;
         END IF;
         
         IF (planned_del_date_ != public_line_rec_.planned_delivery_date) THEN
            planned_del_date_ := NULL;
         END IF;
         
         IF (source_ref1_ != public_line_rec_.source_ref1) THEN
            source_ref1_ := NULL; 
         END IF;

         IF (NVL(dock_, Database_SYS.string_null_) != NVL(public_line_rec_.dock_code, Database_SYS.string_null_)) THEN
            dock_ := NULL;
         END IF;

         IF (NVL(sub_dock_, Database_SYS.string_null_) != NVL(public_line_rec_.sub_dock_code, Database_SYS.string_null_)) THEN
            sub_dock_ := NULL;
         END IF;  

         IF (NVL(location_, Database_SYS.string_null_) != NVL(public_line_rec_.location_no, Database_SYS.string_null_)) THEN
            location_ := NULL;
         END IF;

         IF (NVL(reference_, Database_SYS.string_null_) != NVL(public_line_rec_.ref_id, Database_SYS.string_null_)) THEN
            reference_ := NULL;
         END IF;
      END IF;
   END LOOP;
   
   IF (first_record_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      Client_SYS.Clear_Attr(attr_);
      IF (oldrec_.route_id IS NULL) AND (route_id_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('ROUTE_ID', route_id_, attr_);
         $IF Component_Order_SYS.INSTALLED $THEN
            Client_SYS.Set_Item_Value('LOAD_SEQUENCE_NO', Load_Plan_Line_API.Get_Load_Seq_No( route_id_,  oldrec_.ship_via_code, oldrec_.contract, oldrec_.receiver_id, oldrec_.Receiver_Addr_Id), attr_);
         $END
      END IF;
      IF (oldrec_.forward_agent_id IS NULL) AND (forwarder_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', forwarder_, attr_);
      END IF;
      IF (oldrec_.planned_ship_date IS NULL) AND (planned_ship_date_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('PLANNED_SHIP_DATE', planned_ship_date_, attr_);
      END IF;
      IF (oldrec_.planned_delivery_date IS NULL) AND (planned_del_date_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('PLANNED_DELIVERY_DATE', planned_del_date_, attr_);
      END IF;
      IF (oldrec_.source_ref1 IS NULL) AND (source_ref1_ IS NOT NULL) THEN 
         Client_SYS.Set_Item_Value('SOURCE_REF1', source_ref1_, attr_);
      END IF;
      IF (oldrec_.location_no IS NULL) AND (location_ IS NOT NULL) THEN 
         Client_SYS.Set_Item_Value('LOCATION_NO', location_, attr_);
      END IF;
      IF (oldrec_.sub_dock_code IS NULL) AND (sub_dock_ IS NOT NULL) THEN 
         Client_SYS.Set_Item_Value('SUB_DOCK_CODE', sub_dock_, attr_);
      END IF;
      IF (oldrec_.dock_code IS NULL) AND (dock_ IS NOT NULL) THEN 
         Client_SYS.Set_Item_Value('DOCK_CODE', dock_, attr_);
      END IF;
      IF (oldrec_.ref_id IS NULL) AND (reference_ IS NOT NULL) THEN 
         Client_SYS.Set_Item_Value('REF_ID', reference_, attr_);
      END IF;

      IF (attr_ IS NOT NULL) THEN
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_); 
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   END IF;
END Refresh_Values_On_Shipment;


-- Set_Print_Flags
--   Method to set and unset the print flags (delnote, consignement, pack list, etc.)
PROCEDURE Set_Print_Flags (
   shipment_id_     IN NUMBER,
   print_flag_type_ IN VARCHAR2,
   print_flag_db_   IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   oldrec_     SHIPMENT_TAB%ROWTYPE;
   newrec_     SHIPMENT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   Client_Sys.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr(UPPER(print_flag_type_), print_flag_db_, attr_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Print_Flags;


-- New
--   Create new shipment
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   objid_      SHIPMENT.objid%TYPE;
   objversion_ SHIPMENT.objversion%TYPE;
   newrec_     SHIPMENT_TAB%ROWTYPE;
   new_attr_   VARCHAR2(32000);
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   -- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);

   --Replace the default attribute values with the ones passed in the inparameterstring.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, new_attr_); 
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Close
--   Close the Shipment.
PROCEDURE Close (
   shipment_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   Close__(info_, objid_, objversion_, attr_, 'DO');
END Close;


-- Complete
--   Complete the Shipment.
PROCEDURE Complete (
   shipment_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   Complete__(info_, objid_, objversion_, attr_, 'DO');
END Complete;


-- Modify
--   Public interface for modifying a shipment.
PROCEDURE Modify (
   attr_         IN OUT VARCHAR2,
   shipment_id_  IN     VARCHAR2 )
IS
   objid_       SHIPMENT.objid%TYPE;
   objversion_  SHIPMENT.objversion%TYPE;
   oldrec_      SHIPMENT_TAB%ROWTYPE;
   newrec_      SHIPMENT_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, shipment_id_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify;


PROCEDURE Validate_Capacities (
   info_               OUT VARCHAR2,
   consol_shipment_id_ IN  NUMBER)
IS
   rec_     SHIPMENT_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(consol_shipment_id_);
   Client_SYS.Clear_Info;
   Validate_Capacities___(rec_);
   info_ := Client_SYS.Get_All_Info;
 END Validate_Capacities;  
   
PROCEDURE Undo_Shipment_Delivery (
   shipment_id_    IN NUMBER)
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);   
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_);
   Undo_Shipment_Delivery__(info_, objid_, objversion_, attr_, 'DO');   
END Undo_Shipment_Delivery;


-- This method is used by DataCaptCreateHndlUnit
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_         OUT BOOLEAN,
   contract_                      IN  VARCHAR2,
   shipment_id_                   IN  NUMBER,
   handling_unit_id_              IN  NUMBER,
   receiver_id_                   IN  VARCHAR2,
   shipment_type_                 IN  VARCHAR2,
   receiver_addr_id_              IN  VARCHAR2,
   forward_agent_id_              IN  VARCHAR2,
   parent_consol_shipment_id_     IN  NUMBER,
   ship_via_code_                 IN  VARCHAR2,
   sscc_                          IN  VARCHAR2,
   alt_handling_unit_label_id_    IN  VARCHAR2,
   column_name_                   IN  VARCHAR2,
   sql_where_expression_          IN  VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(2000);
   unique_column_value_           VARCHAR2(50);
   too_many_values_found_         BOOLEAN := FALSE;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab; 
BEGIN
   Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB', column_name_);
   
   stmt_ := 'SELECT DISTINCT ' || column_name_ || '
            FROM HANDLING_UNIT_SHIPMENT_PUB
            WHERE shipment_category_db = ''NORMAL''
            AND   state = ''Preliminary'' '; 
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND handling_unit_id is NULL AND :handling_unit_id_ IS NULL';
   ELSIF handling_unit_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :handling_unit_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF receiver_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :receiver_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
   END IF;
   IF shipment_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_type_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_type = :shipment_type_';
   END IF;
   IF receiver_addr_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :receiver_addr_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND receiver_addr_id = :receiver_addr_id_';
   END IF;
   IF forward_agent_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
   ELSIF forward_agent_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
   END IF;
   IF parent_consol_shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
   ELSIF parent_consol_shipment_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
   END IF;
   IF ship_via_code_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND ship_via_code is NULL AND :ship_via_code_ IS NULL';
   ELSIF ship_via_code_ = '%' THEN
      stmt_ := stmt_ || ' AND :ship_via_code_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND ship_via_code = :ship_via_code_';
   END IF;
   IF sscc_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
   ELSIF sscc_ = '%' THEN
      stmt_ := stmt_ || ' AND :sscc_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :sscc_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   stmt_ := stmt_ || ' AND contract = :contract_';
   
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2015-03-13,RILASE)
   OPEN get_column_values_ FOR stmt_ USING shipment_id_,
                                           handling_unit_id_,
                                           receiver_id_,
                                           shipment_type_,
                                           receiver_addr_id_,
                                           forward_agent_id_,
                                           parent_consol_shipment_id_,
                                           ship_via_code_,
                                           sscc_,                                           
                                           alt_handling_unit_label_id_,
                                           contract_;   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
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
      no_unique_value_found_ := TRUE;
   ELSE
      no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
   END IF;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptCreateHndlUnit
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   shipment_id_                IN NUMBER,
   handling_unit_id_           IN NUMBER,
   receiver_id_                IN VARCHAR2,
   shipment_type_              IN VARCHAR2,
   receiver_addr_id_           IN VARCHAR2,
   forward_agent_id_           IN VARCHAR2,
   parent_consol_shipment_id_  IN NUMBER,
   ship_via_code_              IN VARCHAR2,
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_        Get_Lov_Values;
   stmt_                  VARCHAR2(4000);
   TYPE Lov_Value_Tab     IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_         Lov_Value_Tab;
   second_column_name_    VARCHAR2(200);
   second_column_value_   VARCHAR2(200);
   lov_item_description_  VARCHAR2(200);
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_    NUMBER;
   exit_lov_              BOOLEAN := FALSE;
   dummy_boolean_         BOOLEAN;
   temp_receiver_id_      VARCHAR2(50);
   temp_receiver_type_db_ VARCHAR2(20);
   temp_handling_unit_id_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_  || ' FROM HANDLING_UNIT_SHIPMENT_PUB
                           WHERE shipment_category_db = ''NORMAL''
                           AND   state = ''Preliminary'' ';
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
      END IF;
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND handling_unit_id is NULL AND :handling_unit_id_ IS NULL';
      ELSIF handling_unit_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :handling_unit_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF receiver_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :receiver_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
      END IF;
      IF shipment_type_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :shipment_type_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND shipment_type = :shipment_type_';
      END IF;
      IF receiver_addr_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :receiver_addr_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND receiver_addr_id = :receiver_addr_id_';
      END IF;
      IF forward_agent_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
      ELSIF forward_agent_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
      END IF;
      IF parent_consol_shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
      ELSIF parent_consol_shipment_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
      END IF;
      IF ship_via_code_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND ship_via_code is NULL AND :ship_via_code_ IS NULL';
      ELSIF ship_via_code_ = '%' THEN
         stmt_ := stmt_ || ' AND :ship_via_code_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND ship_via_code = :ship_via_code_';
      END IF;
      IF sscc_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
      ELSIF sscc_ = '%' THEN
         stmt_ := stmt_ || ' AND :sscc_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :sscc_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;
      stmt_ := stmt_ || ' AND contract = :contract_ ';

                           
      IF (sql_where_expression_ IS NOT NULL) THEN
       stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
   
      @ApproveDynamicStatement(2015-03-13,RILASE)
      OPEN get_lov_values_ FOR stmt_ USING shipment_id_,
                                           handling_unit_id_,
                                           receiver_id_,
                                           shipment_type_,
                                           receiver_addr_id_,
                                           forward_agent_id_,
                                           parent_consol_shipment_id_,
                                           ship_via_code_,
                                           sscc_,
                                           alt_handling_unit_label_id_,
                                           contract_;
         
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         IF (column_name_ IN ('HANDLING_UNIT_ID')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION';
         ELSIF (column_name_ IN ('SHIPMENT_ID')) THEN
               second_column_name_ := 'RECEIVER_NAME_SHP';
         ELSIF (column_name_ IN ('RECEIVER_ID')) THEN
               second_column_name_ := 'RECEIVER_NAME';
         ELSIF (column_name_ IN ('FORWARD_AGENT_ID')) THEN
               second_column_name_ := 'FORWARD_AGENT_DESC';
         ELSIF (column_name_ IN ('SHIP_VIA_CODE')) THEN
               second_column_name_ := 'SHIP_VIA_CODE_DESC';
         ELSIF (column_name_ IN ('SHIPMENT_TYPE')) THEN
               second_column_name_ := 'SHIPMENT_TYPE_DESC';
         ELSIF (column_name_ IN ('SSCC')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC';
         ELSIF (column_name_ IN ('ALT_HANDLING_UNIT_LABEL_ID')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT';
         END IF;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (second_column_name_ = 'RECEIVER_NAME_SHP') THEN
                     temp_receiver_id_ := Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_boolean_,
                                                                     contract_                   => contract_,
                                                                     shipment_id_                => lov_value_tab_(i),
                                                                     handling_unit_id_           => handling_unit_id_,
                                                                     receiver_id_                => receiver_id_,
                                                                     shipment_type_              => shipment_type_,
                                                                     receiver_addr_id_           => receiver_addr_id_,
                                                                     forward_agent_id_           => forward_agent_id_,
                                                                     parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                     ship_via_code_              => ship_via_code_,
                                                                     sscc_                       => sscc_,
                                                                     alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                     column_name_                => 'RECEIVER_ID',
                                                                     sql_where_expression_       => sql_where_expression_); 
                     temp_receiver_type_db_ := Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_boolean_,
                                                                          contract_                   => contract_,
                                                                          shipment_id_                => lov_value_tab_(i),
                                                                          handling_unit_id_           => handling_unit_id_,
                                                                          receiver_id_                => receiver_id_,
                                                                          shipment_type_              => shipment_type_,
                                                                          receiver_addr_id_           => receiver_addr_id_,
                                                                          forward_agent_id_           => forward_agent_id_,
                                                                          parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                          ship_via_code_              => ship_via_code_,
                                                                          sscc_                       => sscc_,
                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                          column_name_                => 'RECEIVER_TYPE_DB',
                                                                          sql_where_expression_       => sql_where_expression_);
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(temp_receiver_id_, temp_receiver_type_db_);
                  ELSIF (second_column_name_ = 'RECEIVER_NAME') THEN
                     temp_receiver_type_db_ := Get_Column_Value_If_Unique (no_unique_value_found_      => dummy_boolean_,
                                                                           contract_                   => contract_,
                                                                           shipment_id_                => shipment_id_,
                                                                           handling_unit_id_           => handling_unit_id_,
                                                                           receiver_id_                => lov_value_tab_(i),
                                                                           shipment_type_              => shipment_type_,
                                                                           receiver_addr_id_           => receiver_addr_id_,
                                                                           forward_agent_id_           => forward_agent_id_,
                                                                           parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                           ship_via_code_              => ship_via_code_,
                                                                           sscc_                       => sscc_,
                                                                           alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                           column_name_                => 'RECEIVER_TYPE_DB',
                                                                           sql_where_expression_       => sql_where_expression_);
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(lov_value_tab_(i), temp_receiver_type_db_);
                  ELSIF (second_column_name_ = 'FORWARD_AGENT_DESC') THEN
                     second_column_value_ := Forwarder_Info_API.Get_Name(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'SHIP_VIA_CODE_DESC') THEN
                     second_column_value_ := Mpccom_Ship_Via_API.Get_Description(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'SHIPMENT_TYPE_DESC') THEN
                     second_column_value_ := Shipment_Type_API.Get_Description(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  END IF;
                  
                  IF (second_column_name_ IN ('HANDLING_UNIT_TYPE_DESCRIPTION', 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC', 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT') AND 
                      temp_handling_unit_id_ IS NOT NULL) THEN 
                     second_column_value_ := Handling_Unit_API.Get_Structure_Level(temp_handling_unit_id_) || ' | ' || 
                                             Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
                  END IF; 
                  
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                    lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;
            
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
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


-- This method is used by DataCaptCreateHndlUnit 
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   record_exists_              OUT BOOLEAN,
   contract_                   IN  VARCHAR2,
   shipment_id_                IN  NUMBER,
   handling_unit_id_           IN  NUMBER,
   receiver_id_                IN  VARCHAR2,
   shipment_type_              IN  VARCHAR2,
   receiver_addr_id_           IN  VARCHAR2,
   forward_agent_id_           IN  VARCHAR2,
   parent_consol_shipment_id_  IN  NUMBER,
   ship_via_code_              IN  VARCHAR2,
   sscc_                       IN  VARCHAR2,
   alt_handling_unit_label_id_ IN  VARCHAR2,
   column_name_                IN  VARCHAR2,
   column_value_               IN  VARCHAR2,
   column_description_         IN  VARCHAR2,
   sql_where_expression_       IN  VARCHAR2 DEFAULT NULL,
   raise_error_                IN  BOOLEAN  DEFAULT TRUE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
   Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB', column_name_);

   stmt_ := ' SELECT 1
              FROM  HANDLING_UNIT_SHIPMENT_PUB
              WHERE shipment_category_db = ''NORMAL''
              AND   state = ''Preliminary'' ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND handling_unit_id is NULL AND :handling_unit_id_ IS NULL';
   ELSIF handling_unit_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :handling_unit_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF receiver_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :receiver_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
   END IF;
   IF shipment_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_type_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_type = :shipment_type_';
   END IF;
   IF receiver_addr_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :receiver_addr_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND receiver_addr_id = :receiver_addr_id_';
   END IF;
   IF forward_agent_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
   ELSIF forward_agent_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
   END IF;
   IF parent_consol_shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
   ELSIF parent_consol_shipment_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
   END IF;
   IF ship_via_code_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND ship_via_code is NULL AND :ship_via_code_ IS NULL';
   ELSIF ship_via_code_ = '%' THEN
      stmt_ := stmt_ || ' AND :ship_via_code_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND ship_via_code = :ship_via_code_';
   END IF;
   IF sscc_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
   ELSIF sscc_ = '%' THEN
      stmt_ := stmt_ || ' AND :sscc_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sscc = :sscc_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;
   stmt_ := stmt_ || ' AND contract = :contract_ ';
   
   IF (sql_where_expression_ IS NOT NULL) THEN
    stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;
   
   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL))';
   @ApproveDynamicStatement(2015-03-13,RILASE)
   OPEN exist_control_ FOR stmt_ USING shipment_id_,
                                       handling_unit_id_,
                                       receiver_id_,
                                       shipment_type_,
                                       receiver_addr_id_,                                          
                                       forward_agent_id_,
                                       parent_consol_shipment_id_,
                                       ship_via_code_,
                                       sscc_,
                                       alt_handling_unit_label_id_,
                                       contract_,
                                       column_value_,
                                       column_value_;  
      
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF raise_error_ THEN
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
      ELSE
         record_exists_ := FALSE;
      END IF;
   ELSE
      record_exists_ := TRUE;
   END IF;
END Record_With_Column_Value_Exist;


-- This method is used by DataCaptChangeParentHu, DataCaptDeleteHndlUnit, DataCaptModifyHndlUnit,
-- DataCapPackIntoHuShip and DataCaptReassHuShip
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_      OUT BOOLEAN,
   contract_                   IN  VARCHAR2,
   shipment_id_                IN  NUMBER,
   handling_unit_id_           IN  NUMBER,
   parent_consol_shipment_id_  IN  NUMBER,
   sscc_                       IN  VARCHAR2,
   receiver_id_                IN  VARCHAR2 DEFAULT NULL,
   receiver_type_db_           IN  VARCHAR2 DEFAULT NULL,
   alt_handling_unit_label_id_ IN  VARCHAR2,
   column_name_                IN  VARCHAR2,
   sql_where_expression_       IN  VARCHAR2 DEFAULT NULL,
   cursor_id_                  IN  NUMBER   DEFAULT 1 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                       VARCHAR2(2000);
   unique_column_value_        VARCHAR2(50);
   too_many_values_found_      BOOLEAN := FALSE;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_           Column_Value_Tab; 
BEGIN

   IF (cursor_id_ = 1) THEN
      Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB', column_name_);

      stmt_ := 'SELECT DISTINCT ' || column_name_ || '
               FROM HANDLING_UNIT_SHIPMENT_PUB
                WHERE shipment_category_db = ''NORMAL'' ';
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND shipment_id is NULL AND :shipment_id_ IS NULL';
      ELSIF shipment_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :shipment_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
      END IF;
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND handling_unit_id is NULL AND :handling_unit_id_ IS NULL';
      ELSIF handling_unit_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :handling_unit_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF parent_consol_shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
      ELSIF parent_consol_shipment_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
      END IF;
      IF sscc_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
      ELSIF sscc_ = '%' THEN
         stmt_ := stmt_ || ' AND :sscc_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :sscc_';
      END IF;
      IF receiver_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND receiver_id is NULL AND :receiver_id_ IS NULL';
      ELSIF receiver_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :receiver_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
      END IF;
      IF receiver_type_db_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND receiver_type_db is NULL AND :receiver_type_db_ IS NULL';
      ELSIF receiver_type_db_ = '%' THEN
         stmt_ := stmt_ || ' AND :receiver_type_db_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND receiver_type_db = :receiver_type_db_';
      END IF;  
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;
      stmt_ := stmt_ || ' AND contract = :contract_ ';

   
      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;
      stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   
      @ApproveDynamicStatement(2015-03-13,RILASE)
      OPEN get_column_values_ FOR stmt_ USING shipment_id_,
                                              handling_unit_id_,
                                              parent_consol_shipment_id_,
                                              sscc_,
                                              receiver_id_,
                                              receiver_type_db_,
                                              alt_handling_unit_label_id_,
                                              contract_;
   ELSE -- cursor_id_ = 2
      Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB2', column_name_);      

      stmt_ := 'SELECT DISTINCT ' || column_name_ || '
                FROM  HANDLING_UNIT_SHIPMENT_PUB2 
                WHERE shipment_category_db = ''NORMAL'' ';
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
      END IF;
      IF sscc_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
      ELSIF sscc_ = '%' THEN
         stmt_ := stmt_ || ' AND :sscc_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :sscc_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;
         
      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;        
      stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';
         
      @ApproveDynamicStatement(2016-09-13,SWICLK)
      OPEN get_column_values_ FOR stmt_ USING handling_unit_id_,
      shipment_id_,                                              
                                              sscc_,
                                              alt_handling_unit_label_id_;
      
   END IF;
   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
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
      no_unique_value_found_ := TRUE;
   ELSE
      no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
   END IF;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptChangeParentHu, DataCaptDeleteHndlUnit, DataCaptModifyHndlUnit,
   -- DataCapPackIntoHuShip and DataCaptReassHuShip
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   shipment_id_                IN NUMBER,
   handling_unit_id_           IN NUMBER,
   parent_consol_shipment_id_  IN NUMBER,
   sscc_                       IN VARCHAR2,
   receiver_id_                IN VARCHAR2 DEFAULT NULL,
   receiver_type_db_           IN VARCHAR2 DEFAULT NULL,
   alt_handling_unit_label_id_ IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL,
   lov_id_                     IN NUMBER   DEFAULT 1 )  
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_        Get_Lov_Values;
   stmt_                  VARCHAR2(4000);
   TYPE Lov_Value_Tab     IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_         Lov_Value_Tab;
   second_column_name_    VARCHAR2(200);
   second_column_value_   VARCHAR2(200);
   lov_item_description_  VARCHAR2(200);
   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_    NUMBER;
   exit_lov_              BOOLEAN := FALSE;
   dummy_boolean_         BOOLEAN;
   temp_receiver_id_      VARCHAR2(50);
   temp_receiver_type_db_ VARCHAR2(20);
   temp_handling_unit_id_ NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);      

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;
      
      IF (lov_id_ = 1) THEN
         -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB', column_name_);

         stmt_ := stmt_  || ' FROM HANDLING_UNIT_SHIPMENT_PUB
                              WHERE shipment_category_db = ''NORMAL'' ';
         IF shipment_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND shipment_id is NULL AND :shipment_id_ IS NULL';
         ELSIF shipment_id_ = -1 THEN
            stmt_ := stmt_ || ' AND :shipment_id_ = -1';
         ELSE
            stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
         END IF;
         IF handling_unit_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND handling_unit_id is NULL AND :handling_unit_id_ IS NULL';
         ELSIF handling_unit_id_ = -1 THEN
            stmt_ := stmt_ || ' AND :handling_unit_id_ = -1';
         ELSE
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
         END IF;
         IF parent_consol_shipment_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
         ELSIF parent_consol_shipment_id_ = -1 THEN
            stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
         ELSE
            stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
         END IF;
         IF sscc_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
         ELSIF sscc_ = '%' THEN
            stmt_ := stmt_ || ' AND :sscc_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND sscc = :sscc_';
         END IF;
         IF receiver_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND receiver_id is NULL AND :receiver_id_ IS NULL';
         ELSIF receiver_id_ = '%' THEN
            stmt_ := stmt_ || ' AND :receiver_id_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
         END IF;
         IF receiver_type_db_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND receiver_type_db is NULL AND :receiver_type_db_ IS NULL';
         ELSIF receiver_type_db_ = '%' THEN
            stmt_ := stmt_ || ' AND :receiver_type_db_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND receiver_type_db = :receiver_type_db_';
         END IF;  
         IF alt_handling_unit_label_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
         ELSIF alt_handling_unit_label_id_ = '%' THEN
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
         END IF;
         stmt_ := stmt_ || ' AND contract = :contract_';
                           
         IF (sql_where_expression_ IS NOT NULL) THEN
            stmt_ := stmt_ || sql_where_expression_;
         END IF;

         stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
   
         @ApproveDynamicStatement(2015-03-13,RILASE)
         OPEN get_lov_values_ FOR stmt_ USING shipment_id_,
                                              handling_unit_id_,
                                              parent_consol_shipment_id_,
                                              sscc_,
                                              receiver_id_,
                                              receiver_type_db_,
                                              alt_handling_unit_label_id_,
                                              contract_;

      ELSE -- lov_id_ = 2
         -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
         Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB2', column_name_);
         
         stmt_ := stmt_  || ' FROM  HANDLING_UNIT_SHIPMENT_PUB2 
                              WHERE shipment_category_db = ''NORMAL'' '; 
         IF handling_unit_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
         END IF;
         IF shipment_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
         ELSE
            stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
         END IF;
         IF sscc_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
         ELSIF sscc_ = '%' THEN
            stmt_ := stmt_ || ' AND :sscc_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND sscc = :sscc_';
         END IF;
         IF alt_handling_unit_label_id_ IS NULL THEN                       
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
         ELSIF alt_handling_unit_label_id_ = '%' THEN
            stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
         ELSE
            stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
         END IF;
         
         IF (sql_where_expression_ IS NOT NULL) THEN
            stmt_ := stmt_ || sql_where_expression_;
         END IF;
         stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';   
         
         @ApproveDynamicStatement(2016-09-13,SWICLK)
         OPEN get_lov_values_ FOR stmt_ USING handling_unit_id_,
                                              shipment_id_,                                              
                                              sscc_,
                                              alt_handling_unit_label_id_;
      END IF;
   
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         IF (column_name_ IN ('HANDLING_UNIT_ID')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION';
         ELSIF (column_name_ IN ('SSCC')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC';
         ELSIF (column_name_ IN ('ALT_HANDLING_UNIT_LABEL_ID')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT';
         ELSIF (column_name_ IN ('SHIPMENT_ID')) THEN
               second_column_name_ := 'RECEIVER_NAME_SHP';
         END IF;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION') THEN
                     temp_handling_unit_id_ := lov_value_tab_(i);
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT') THEN
                     temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'RECEIVER_NAME_SHP') THEN
                     temp_receiver_id_ := Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_boolean_,
                                                                     contract_                   => contract_,
                                                                     shipment_id_                => lov_value_tab_(i),
                                                                     handling_unit_id_           => handling_unit_id_,
                                                                     parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                     sscc_                       => sscc_,
                                                                     receiver_id_                => receiver_id_,
                                                                     receiver_type_db_           => receiver_type_db_,
                                                                     alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                     column_name_                => 'RECEIVER_ID',
                                                                     sql_where_expression_       => sql_where_expression_);
                     temp_receiver_type_db_ := Get_Column_Value_If_Unique(no_unique_value_found_      => dummy_boolean_,
                                                                          contract_                   => contract_,
                                                                          shipment_id_                => lov_value_tab_(i),
                                                                          handling_unit_id_           => handling_unit_id_,
                                                                          parent_consol_shipment_id_  => parent_consol_shipment_id_,
                                                                          sscc_                       => sscc_,
                                                                          receiver_id_                => receiver_id_,
                                                                          receiver_type_db_           => receiver_type_db_,
                                                                          alt_handling_unit_label_id_ => alt_handling_unit_label_id_,
                                                                          column_name_                => 'RECEIVER_TYPE_DB',
                                                                          sql_where_expression_       => sql_where_expression_);
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(temp_receiver_id_, temp_receiver_type_db_);
                  END IF;
                  
                  IF (second_column_name_ IN ('HANDLING_UNIT_TYPE_DESCRIPTION', 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC', 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT') AND 
                      temp_handling_unit_id_ IS NOT NULL) THEN 
                     second_column_value_ := Handling_Unit_API.Get_Structure_Level(temp_handling_unit_id_) || ' | ' || 
                                             Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));                                  
                  END IF; 
                  
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                    lov_item_description_ := NULL;
                  END IF;
               END IF;
            END IF;
            
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
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


-- This method is used by DataCaptChangeParentHu, DataCaptDeleteHndlUnit, DataCaptModifyHndlUnit,
-- DataCapPackIntoHuShip and DataCaptReassHuShip
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   record_exists_                 OUT BOOLEAN,
   contract_                      IN  VARCHAR2,
   shipment_id_                   IN  NUMBER,
   handling_unit_id_              IN  NUMBER,
   parent_consol_shipment_id_     IN  NUMBER,
   sscc_                          IN  VARCHAR2,
   receiver_id_                   IN  VARCHAR2 DEFAULT NULL,
   receiver_type_db_              IN  VARCHAR2 DEFAULT NULL,
   alt_handling_unit_label_id_    IN  VARCHAR2,
   column_name_                   IN  VARCHAR2,
   column_value_                  IN  VARCHAR2,
   column_description_            IN  VARCHAR2,
   sql_where_expression_          IN  VARCHAR2 DEFAULT NULL,
   raise_error_                   IN  BOOLEAN  DEFAULT TRUE,
   cursor_id_                     IN  NUMBER   DEFAULT 1 )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(2000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   IF (cursor_id_ = 1) THEN
      -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
      Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB', column_name_);

      stmt_ := stmt_  || ' SELECT 1
                 FROM  HANDLING_UNIT_SHIPMENT_PUB
                           WHERE shipment_category_db = ''NORMAL'' ';
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND shipment_id is NULL AND :shipment_id_ IS NULL';
      ELSIF shipment_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :shipment_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
      END IF;
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND handling_unit_id is NULL AND :handling_unit_id_ IS NULL';
      ELSIF handling_unit_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :handling_unit_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF parent_consol_shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
      ELSIF parent_consol_shipment_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
      END IF;
      IF sscc_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
      ELSIF sscc_ = '%' THEN
         stmt_ := stmt_ || ' AND :sscc_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :sscc_';
      END IF;
      IF receiver_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND receiver_id is NULL AND :receiver_id_ IS NULL';
      ELSIF receiver_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :receiver_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
      END IF;
      IF receiver_type_db_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND receiver_type_db is NULL AND :receiver_type_db_ IS NULL';
      ELSIF receiver_type_db_ = '%' THEN
         stmt_ := stmt_ || ' AND :receiver_type_db_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND receiver_type_db = :receiver_type_db_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;
      stmt_ := stmt_ || ' AND contract = :contract_ ';

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;   
   
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
      @ApproveDynamicStatement(2015-03-13,RILASE)
      OPEN exist_control_ FOR stmt_ USING shipment_id_,
                                          handling_unit_id_,                                          
                                          parent_consol_shipment_id_,
                                          sscc_,
                                          receiver_id_,
                                          receiver_type_db_,
                                          alt_handling_unit_label_id_,
                                          contract_,
                                          column_value_,
                                          column_value_;   
   ELSE  -- cursor_id_ = 2
      -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
      Assert_SYS.Assert_Is_View_Column('HANDLING_UNIT_SHIPMENT_PUB2', column_name_);
      
      stmt_ := stmt_  || ' SELECT 1
              FROM  HANDLING_UNIT_SHIPMENT_PUB2 
                           WHERE shipment_category_db = ''NORMAL'' '; 
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
      END IF;
      IF sscc_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sscc is NULL AND :sscc_ IS NULL';
      ELSIF sscc_ = '%' THEN
         stmt_ := stmt_ || ' AND :sscc_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sscc = :sscc_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
              
      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || sql_where_expression_;
      END IF;
      @ApproveDynamicStatement(2016-09-13,SWICLK)
      OPEN exist_control_ FOR stmt_ USING handling_unit_id_,
                                          shipment_id_,                                          
                                          sscc_,
                                          alt_handling_unit_label_id_,
                                          column_value_, -- parent_consol_shipment_id_
                                          column_value_; -- parent_consol_shipment_id_
   END IF;
   
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF raise_error_ THEN
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
      ELSE
         record_exists_ := FALSE;
      END IF;
   ELSE
      record_exists_ := TRUE;
   END IF;

END Record_With_Column_Value_Exist;


-- This method is used by DataCaptProcessShipment
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_               IN VARCHAR2,
   shipment_id_            IN NUMBER,
   parent_consol_ship_id_  IN NUMBER,
   shipment_category_      IN VARCHAR2,
   shipment_type_          IN VARCHAR2,
   sender_type_            IN VARCHAR2,
   receiver_type_          IN VARCHAR2,
   receiver_id_            IN VARCHAR2,
   receiver_addr_id_       IN VARCHAR2,  
   pro_no_                 IN VARCHAR2,
   forward_agent_id_       IN VARCHAR2,
   route_id_               IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,  
   consignment_note_id_    IN VARCHAR2,  
   status_                 IN VARCHAR2,  
   from_date_              IN DATE,
   to_date_                IN DATE,
   capture_session_id_     IN NUMBER,
   column_name_            IN VARCHAR2,
   lov_type_db_            IN VARCHAR2,
   sql_where_expression_   IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values     IS REF CURSOR;
   get_lov_values_         Get_Lov_Values;
   stmt_                   VARCHAR2(4000);
   TYPE Lov_Value_Tab      IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_          Lov_Value_Tab;
   lov_item_description_   VARCHAR2(200);
   session_rec_            Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_     NUMBER;
   exit_lov_               BOOLEAN := FALSE;
   shipment_rec_           Shipment_API.Public_Rec;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
    
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('SHIPMENT_TAB', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_  || ' FROM SHIPMENT_TAB
                           WHERE rowstate NOT IN (''Closed'', ''Cancelled'') ';
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
      END IF;
      IF shipment_category_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :shipment_category_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND shipment_category = :shipment_category_';
      END IF;
      IF status_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :status_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND rowstate = :status_';
      END IF;
      stmt_ := stmt_ || ' AND contract = :contract_';
      IF shipment_type_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND shipment_type is NULL AND :shipment_type_ IS NULL';
      ELSIF shipment_type_ = '%' THEN
         stmt_ := stmt_ || ' AND :shipment_type_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND shipment_type = :shipment_type_';
      END IF;
      IF sender_type_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND sender_type is NULL AND :sender_type_ IS NULL';
      ELSIF sender_type_ = '%' THEN
         stmt_ := stmt_ || ' AND :sender_type_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND sender_type = :sender_type_';
      END IF;
      IF receiver_type_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND receiver_type is NULL AND :receiver_type_ IS NULL';
      ELSIF receiver_type_ = '%' THEN
         stmt_ := stmt_ || ' AND :receiver_type_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND receiver_type = :receiver_type_';
      END IF;
      IF receiver_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND receiver_id is NULL AND :receiver_id_ IS NULL';
      ELSIF receiver_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :receiver_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
      END IF;
      IF receiver_addr_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND receiver_addr_id is NULL AND :receiver_addr_id_ IS NULL';
      ELSIF receiver_addr_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :receiver_addr_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND receiver_addr_id = :receiver_addr_id_';
      END IF;
      IF pro_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND pro_no is NULL AND :pro_no_ IS NULL';
      ELSIF pro_no_ = '%' THEN
         stmt_ := stmt_ || ' AND :pro_no_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND pro_no = :pro_no_';
      END IF;
      IF forward_agent_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
      ELSIF forward_agent_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
      END IF;
      IF route_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND route_id is NULL AND :route_id_ IS NULL';
      ELSIF route_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :route_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND route_id = :route_id_';
      END IF;
      IF ship_via_code_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND ship_via_code is NULL AND :ship_via_code_ IS NULL';
      ELSIF ship_via_code_ = '%' THEN
         stmt_ := stmt_ || ' AND :ship_via_code_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND ship_via_code = :ship_via_code_';
      END IF;
      IF consignment_note_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND consignment_note_id is NULL AND :consignment_note_id_ IS NULL';
      ELSIF consignment_note_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :consignment_note_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND consignment_note_id = :consignment_note_id_';
      END IF;
      IF parent_consol_ship_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_ship_id_ IS NULL';
      ELSIF parent_consol_ship_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :parent_consol_ship_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_ship_id_';
      END IF;
      stmt_ := stmt_ || ' AND (trunc(planned_ship_date)  >= NVL(:from_date_, SYSDATE - 99999) OR planned_ship_date IS NULL)
                           AND   (trunc(planned_ship_date)  <= (NVL(:to_date_, SYSDATE + 99999)+1) OR planned_ship_date IS NULL) ';

      IF (sql_where_expression_ IS NOT NULL) THEN
       stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
   
      @ApproveDynamicStatement(2017-07-12,KHVESE)
      OPEN get_lov_values_ FOR stmt_ USING shipment_id_,
                                           shipment_category_,
                                           status_,
                                           contract_,
                                           shipment_type_,
                                           sender_type_,
                                           receiver_type_,
                                           receiver_id_,
                                           receiver_addr_id_,
                                           pro_no_,
                                           forward_agent_id_,
                                           route_id_,
                                           ship_via_code_,
                                           consignment_note_id_,                                           
                                           parent_consol_ship_id_,
                                           from_date_,
                                           to_date_;
         
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;
      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (column_name_ = 'SHIPMENT_ID') THEN
                  shipment_rec_ := Shipment_API.Get(lov_value_tab_(i));
                  lov_item_description_ := NVL(NULLIF(receiver_id_,'%'),shipment_rec_.receiver_id);
                  IF lov_item_description_ IS NOT NULL AND 
                     (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_RECEIVER_NAME'))) THEN
                        lov_item_description_ := lov_item_description_ || ' | ' ||  Shipment_Source_Utility_API.Get_Receiver_Name(NVL(NULLIF(receiver_id_,'%'),shipment_rec_.receiver_id),
                                                                                                                                  NVL(NULLIF(receiver_type_,'%'),shipment_rec_.receiver_type));
                  END IF;
                  IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_RECEIVER_ADDRESS_NAME'))) THEN
                     IF lov_item_description_ IS NOT NULL THEN 
                        lov_item_description_ := lov_item_description_ || ' | ';
                     END IF;
                     lov_item_description_ := lov_item_description_ || shipment_rec_.receiver_address_name;
                  END IF;
               ELSIF (column_name_ = 'FORWARD_AGENT_ID') THEN
                  lov_item_description_ :=  Forwarder_Info_API.Get_Name(lov_value_tab_(i));
               ELSIF (column_name_ = 'ROUTE_ID') THEN
                  lov_item_description_ :=  Delivery_Route_API.Get_Description(lov_value_tab_(i));
               ELSIF (column_name_ = 'SHIP_VIA_CODE') THEN
                  lov_item_description_ := Mpccom_Ship_Via_API.Get_Description(lov_value_tab_(i));
               ELSIF (column_name_ = 'SHIPMENT_TYPE') THEN
                  lov_item_description_ := Shipment_Type_API.Get_Description(lov_value_tab_(i));
               ELSIF (column_name_ = 'RECEIVER_ID') THEN
                  lov_item_description_ := Shipment_Source_Utility_API.Get_Receiver_Name(lov_value_tab_(i),NVL(receiver_type_,Shipment_API.Get_Receiver_Type_Db(shipment_id_)));
               END IF;
            END IF;
            
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
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


-- This method is used by DataCaptProcessShipment
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   no_unique_value_found_  OUT BOOLEAN,
   contract_               IN VARCHAR2,
   shipment_id_            IN NUMBER,
   parent_consol_ship_id_  IN NUMBER,
   shipment_category_      IN VARCHAR2,
   shipment_type_          IN VARCHAR2,
   sender_type_            IN VARCHAR2,
   receiver_type_          IN VARCHAR2,
   receiver_id_            IN VARCHAR2,
   receiver_addr_id_       IN VARCHAR2,  
   pro_no_                 IN VARCHAR2,
   forward_agent_id_       IN VARCHAR2,
   route_id_               IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,  
   consignment_note_id_    IN VARCHAR2,  
   status_                 IN VARCHAR2,  
   from_date_              IN DATE,
   to_date_                IN DATE,
   column_name_            IN  VARCHAR2,
   sql_where_expression_   IN  VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value       IS REF CURSOR;
   get_column_values_          Get_Column_Value;
   stmt_                       VARCHAR2(4000);
   unique_column_value_        VARCHAR2(50);
   too_many_values_found_      BOOLEAN := FALSE;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_           Column_Value_Tab; 
BEGIN

   Assert_SYS.Assert_Is_View_Column('SHIPMENT_TAB', column_name_);
   
   stmt_ := ' SELECT DISTINCT ' || column_name_ || '
              FROM   SHIPMENT_TAB
              WHERE rowstate NOT IN (''Closed'', ''Cancelled'') ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
   END IF;
   IF shipment_category_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_category_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_category = :shipment_category_';
   END IF;
   IF status_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :status_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND rowstate = :status_';
   END IF;
   stmt_ := stmt_ || ' AND contract = :contract_';
   IF shipment_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND shipment_type is NULL AND :shipment_type_ IS NULL';
   ELSIF shipment_type_ = '%' THEN
      stmt_ := stmt_ || ' AND :shipment_type_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND shipment_type = :shipment_type_';
   END IF;
   IF sender_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sender_type is NULL AND :sender_type_ IS NULL';
   ELSIF sender_type_ = '%' THEN
      stmt_ := stmt_ || ' AND :sender_type_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sender_type = :sender_type_';
   END IF;
   IF receiver_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND receiver_type is NULL AND :receiver_type_ IS NULL';
   ELSIF receiver_type_ = '%' THEN
      stmt_ := stmt_ || ' AND :receiver_type_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND receiver_type = :receiver_type_';
   END IF;
   IF receiver_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND receiver_id is NULL AND :receiver_id_ IS NULL';
   ELSIF receiver_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :receiver_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
   END IF;
   IF receiver_addr_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND receiver_addr_id is NULL AND :receiver_addr_id_ IS NULL';
   ELSIF receiver_addr_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :receiver_addr_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND receiver_addr_id = :receiver_addr_id_';
   END IF;
   IF pro_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND pro_no is NULL AND :pro_no_ IS NULL';
   ELSIF pro_no_ = '%' THEN
      stmt_ := stmt_ || ' AND :pro_no_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND pro_no = :pro_no_';
   END IF;
   IF forward_agent_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
   ELSIF forward_agent_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
   END IF;
   IF route_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND route_id is NULL AND :route_id_ IS NULL';
   ELSIF route_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :route_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND route_id = :route_id_';
   END IF;
   IF ship_via_code_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND ship_via_code is NULL AND :ship_via_code_ IS NULL';
   ELSIF ship_via_code_ = '%' THEN
      stmt_ := stmt_ || ' AND :ship_via_code_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND ship_via_code = :ship_via_code_';
   END IF;
   IF consignment_note_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND consignment_note_id is NULL AND :consignment_note_id_ IS NULL';
   ELSIF consignment_note_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :consignment_note_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND consignment_note_id = :consignment_note_id_';
   END IF;
   IF parent_consol_ship_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_ship_id_ IS NULL';
   ELSIF parent_consol_ship_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :parent_consol_ship_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_ship_id_';
   END IF;
   stmt_ := stmt_ || ' AND (trunc(planned_ship_date)  >= NVL(:from_date_, SYSDATE - 99999) OR planned_ship_date IS NULL)
               AND   (trunc(planned_ship_date)  <= (NVL(:to_date_, SYSDATE + 99999)+1) OR planned_ship_date IS NULL) ';

   IF (sql_where_expression_ IS NOT NULL) THEN
    stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;
   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2017-07-12,KHVESE)
   OPEN get_column_values_ FOR stmt_ USING   shipment_id_,
                                             shipment_category_,
                                             status_,
                                             contract_,
                                             shipment_type_,
                                             sender_type_,
                                             receiver_type_,
                                             receiver_id_,
                                             receiver_addr_id_,
                                             pro_no_,
                                             forward_agent_id_,                                           
                                             route_id_,
                                             ship_via_code_,                                           
                                             consignment_note_id_,
                                             parent_consol_ship_id_,
                                             from_date_,
                                             to_date_;
   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
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
      no_unique_value_found_ := TRUE;
   ELSE
      no_unique_value_found_ := FALSE; -- either a unique value was found or too many values was found
   END IF;

   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptProcessShipment 
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   record_exists_          OUT BOOLEAN,
   contract_               IN VARCHAR2,
   shipment_id_            IN NUMBER,
   parent_consol_ship_id_  IN NUMBER,
   shipment_category_      IN VARCHAR2,
   shipment_type_          IN VARCHAR2,
   sender_type_            IN VARCHAR2,
   receiver_type_          IN VARCHAR2,
   receiver_id_            IN VARCHAR2,
   receiver_addr_id_       IN VARCHAR2,  
   pro_no_                 IN VARCHAR2,
   forward_agent_id_       IN VARCHAR2,
   route_id_               IN VARCHAR2,
   ship_via_code_          IN VARCHAR2,  
   consignment_note_id_    IN VARCHAR2,  
   status_                 IN VARCHAR2,  
   from_date_              IN DATE,
   to_date_                IN DATE,
   column_name_            IN  VARCHAR2,
   column_value_           IN  VARCHAR2,
   column_description_     IN VARCHAR2,
   sql_where_expression_   IN  VARCHAR2 DEFAULT NULL,
   raise_error_            IN  BOOLEAN  DEFAULT TRUE,
   cursor_id_              IN  NUMBER   DEFAULT 1 )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(4000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN
   -- the conditon null only applies when validating from/to date
   IF column_name_ IS NOT NULL OR column_name_ != '' THEN 
      Assert_SYS.Assert_Is_View_Column('SHIPMENT_TAB', column_name_);
   END IF;
   
   stmt_ := ' SELECT 1
              FROM   SHIPMENT_TAB
              WHERE rowstate NOT IN (''Closed'', ''Cancelled'') ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
   END IF;
   IF shipment_category_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_category_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_category = :shipment_category_';
   END IF;
   IF status_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :status_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND rowstate = :status_';
   END IF;
   stmt_ := stmt_ || ' AND contract = :contract_';
   IF shipment_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND shipment_type is NULL AND :shipment_type_ IS NULL';
   ELSIF shipment_type_ = '%' THEN
      stmt_ := stmt_ || ' AND :shipment_type_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND shipment_type = :shipment_type_';
   END IF;
   IF sender_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND sender_type is NULL AND :sender_type_ IS NULL';
   ELSIF sender_type_ = '%' THEN
      stmt_ := stmt_ || ' AND :sender_type_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND sender_type = :sender_type_';
   END IF;
   IF receiver_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND receiver_type is NULL AND :receiver_type_ IS NULL';
   ELSIF receiver_type_ = '%' THEN
      stmt_ := stmt_ || ' AND :receiver_type_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND receiver_type = :receiver_type_';
   END IF;
   IF receiver_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND receiver_id is NULL AND :receiver_id_ IS NULL';
   ELSIF receiver_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :receiver_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND receiver_id = :receiver_id_';
   END IF;
   IF receiver_addr_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND receiver_addr_id is NULL AND :receiver_addr_id_ IS NULL';
   ELSIF receiver_addr_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :receiver_addr_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND receiver_addr_id = :receiver_addr_id_';
   END IF;
   IF pro_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND pro_no is NULL AND :pro_no_ IS NULL';
   ELSIF pro_no_ = '%' THEN
      stmt_ := stmt_ || ' AND :pro_no_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND pro_no = :pro_no_';
   END IF;
   IF forward_agent_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
   ELSIF forward_agent_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
   END IF;
   IF route_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND route_id is NULL AND :route_id_ IS NULL';
   ELSIF route_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :route_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND route_id = :route_id_';
   END IF;
   IF ship_via_code_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND ship_via_code is NULL AND :ship_via_code_ IS NULL';
   ELSIF ship_via_code_ = '%' THEN
      stmt_ := stmt_ || ' AND :ship_via_code_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND ship_via_code = :ship_via_code_';
   END IF;
   IF consignment_note_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND consignment_note_id is NULL AND :consignment_note_id_ IS NULL';
   ELSIF consignment_note_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :consignment_note_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND consignment_note_id = :consignment_note_id_';
   END IF;
   IF parent_consol_ship_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_ship_id_ IS NULL';
   ELSIF parent_consol_ship_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :parent_consol_ship_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_ship_id_';
   END IF;
   stmt_ := stmt_ || ' AND (trunc(planned_ship_date)  >= NVL(:from_date_, SYSDATE - 99999) OR planned_ship_date IS NULL)
               AND   (trunc(planned_ship_date)  <= (NVL(:to_date_, SYSDATE + 99999)+1) OR planned_ship_date IS NULL) ';


   IF (sql_where_expression_ IS NOT NULL) THEN
    stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;
   
   -- the conditon null only applies when validating from/to date
   IF column_name_ IS NOT NULL OR column_name_ != '' THEN 
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
   END IF;
   
   @ApproveDynamicStatement(2017-07-12,KHVESE)
   OPEN exist_control_ FOR stmt_ USING shipment_id_,
                                       shipment_category_,
                                       status_,
                                       contract_,
                                       shipment_type_,
                                       sender_type_,
                                       receiver_type_,
                                       receiver_id_,
                                       receiver_addr_id_,
                                       pro_no_,
                                       forward_agent_id_,
                                       route_id_,
                                       ship_via_code_,
                                       consignment_note_id_,
                                       parent_consol_ship_id_,
                                       from_date_,
                                       to_date_,
                                       column_value_,
                                       column_value_;
   
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF raise_error_ THEN
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
      ELSE
         record_exists_ := FALSE;
      END IF;
   ELSE
      record_exists_ := TRUE;
   END IF;

END Record_With_Column_Value_Exist;

-------------------------------------------------------------------
-- TO_SHIPMENT_ID LOV for Reassign Handling Unit in Shipment     --
-- This will match IEE LOV more closely, cursor code copied from -- 
-- Reassign_Shipment_Utility_API.Validate_Reassign_To_Ship and   -- 
-- some where statements from IEE LOV.                           --
-------------------------------------------------------------------
-- This method is used by DataCaptReassHuShip 
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   from_shipment_id_           IN NUMBER,
   capture_session_id_         IN NUMBER)
IS
   -- Without from_shipment_id_ as a filter, only using contract_ for filter
   CURSOR get_list_of_values_1 IS
      SELECT shipment_id
      FROM   SHIPMENT_TO_REASSIN_LOV
      WHERE  contract = contract_;

   -- With from_shipment_id_ as a filter to fetch valid destination shipments
   CURSOR get_list_of_values_2 IS
      SELECT dest.shipment_id
      FROM   SHIPMENT_TO_REASSIN_LOV source, SHIPMENT_TO_REASSIN_LOV dest
      WHERE  source.shipment_id            = from_shipment_id_
      AND    source.shipment_type          = dest.shipment_type
      AND    source.receiver_id            = dest.receiver_id
      AND    NVL(source.receiver_address_name, Database_SYS.string_null_) =  NVL(dest.receiver_address_name, Database_SYS.string_null_)
      AND    NVL(source.receiver_address1,     Database_SYS.string_null_) =  NVL(dest.receiver_address1,     Database_SYS.string_null_)  
      AND    NVL(source.receiver_address2,     Database_SYS.string_null_) =  NVL(dest.receiver_address2,     Database_SYS.string_null_)  
      AND    NVL(source.receiver_address3,     Database_SYS.string_null_) =  NVL(dest.receiver_address3,     Database_SYS.string_null_)  
      AND    NVL(source.receiver_address4,     Database_SYS.string_null_) =  NVL(dest.receiver_address4,     Database_SYS.string_null_)  
      AND    NVL(source.receiver_address5,     Database_SYS.string_null_) =  NVL(dest.receiver_address5,     Database_SYS.string_null_)  
      AND    NVL(source.receiver_address6,     Database_SYS.string_null_) =  NVL(dest.receiver_address6,     Database_SYS.string_null_)  
      AND    NVL(source.receiver_city ,        Database_SYS.string_null_) =  NVL(dest.receiver_city ,        Database_SYS.string_null_)  
      AND    NVL(source.receiver_state,        Database_SYS.string_null_) =  NVL(dest.receiver_state,        Database_SYS.string_null_)  
      AND    NVL(source.receiver_zip_code,     Database_SYS.string_null_) =  NVL(dest.receiver_zip_code,     Database_SYS.string_null_)  
      AND    NVL(source.receiver_county,       Database_SYS.string_null_) =  NVL(dest.receiver_county,       Database_SYS.string_null_)  
      AND    NVL(source.receiver_country,      Database_SYS.string_null_) =  NVL(dest.receiver_country,      Database_SYS.string_null_)
      AND    source.ship_via_code          = dest.ship_via_code
      AND    source.contract               = dest.contract
      AND    source.delivery_terms         = dest.delivery_terms
      AND    ((source.addr_flag_db = 'Y' AND source.addr_flag_db = dest.addr_flag_db) OR
              (source.addr_flag_db = 'N' AND source.addr_flag_db = dest.addr_flag_db AND source.receiver_addr_id = dest.receiver_addr_id))
      -- IEE LOV extra statements
      AND    source.shipment_id           != dest.shipment_id
      AND    NVL(source.supply_country_db, Database_SYS.string_null_) = NVL(dest.supply_country_db, Database_SYS.string_null_)       
      AND    NVL(source.use_price_incl_tax_db, 'FALSE') = NVL(dest.use_price_incl_tax_db, 'FALSE');

   session_rec_           Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_    NUMBER;
   exit_lov_              BOOLEAN := FALSE;

BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF from_shipment_id_ IS NULL THEN
         FOR lov_rec_ IN get_list_of_values_1 LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.shipment_id,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;

         END LOOP;
      ELSE
         FOR lov_rec_ IN get_list_of_values_2 LOOP
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_rec_.shipment_id,
                                             lov_item_description_  => NULL,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;

         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END

END Create_Data_Capture_Lov;


@UncheckedAccess
FUNCTION Shipment_Delivered (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN  
   RETURN Shipment_Delivered___(shipment_id_);
END Shipment_Delivered;


-- Check_Exist_By_Receiver
-- This procedure will be called from source customer object's Check_Delete
-- Need to wrtie the error messages according to the receiver types.
PROCEDURE Check_Exist_By_Receiver (
   receiver_type_       IN VARCHAR2,
   receiver_id_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
   count_           NUMBER;
   lu_prompt_       VARCHAR2(2000);     
   CURSOR record_exist IS
      SELECT count(shipment_id)
        FROM shipment_tab
       WHERE receiver_type = receiver_type_
         AND receiver_id = receiver_id_
         AND source_ref_type LIKE '%^' || source_ref_type_db_ || '^%';
BEGIN
  OPEN record_exist;
  FETCH record_exist INTO count_;
  IF (record_exist%NOTFOUND) THEN
     count_ := 0;
  END IF;
  CLOSE record_exist;
  IF(count_ > 0 ) THEN
      lu_prompt_ := Language_SYS.Translate_Lu_Prompt_(lu_name_);    
      IF(receiver_type_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
         Error_Sys.Record_General(lu_name_, 'SHIP_CONSTRAINT_CUSTOMER: The Customer :P1 is used by :P2 row(s) in another object (:P3).', receiver_id_, count_, lu_prompt_);
      END IF;
  END IF;
END Check_Exist_By_Receiver;


-- Check_Exist_By_Address
-- This procedure will be called from source address object's Check_Delete
-- Need to wrtie the error messages according to the receiver types.
PROCEDURE Check_Exist_By_Address (
   receiver_type_       IN VARCHAR2,
   receiver_id_         IN VARCHAR2,
   receiver_addr_id_    IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2)
IS
   count_           NUMBER;
   lu_prompt_       VARCHAR2(2000);
   CURSOR record_exist IS
      SELECT count(shipment_id)
        FROM shipment_tab
       WHERE receiver_type  = receiver_type_
         AND receiver_id      = receiver_id_
         AND receiver_addr_id = receiver_addr_id_
         AND source_ref_type LIKE '%^' || source_ref_type_db_ || '^%';
BEGIN
   OPEN record_exist;
   FETCH record_exist INTO count_;
   IF (record_exist%NOTFOUND) THEN
      count_ := 0;
   END IF;
   CLOSE record_exist;
   IF(count_ > 0 ) THEN
      lu_prompt_ := Language_SYS.Translate_Lu_Prompt_(lu_name_);
      IF(receiver_type_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
         Error_Sys.Record_General(lu_name_, 'SHIP_CONSTRAINT_CUST_ADDR: The Customer Address :P1 is used by :P2 row(s) in another object (:P3).', receiver_addr_id_, count_, lu_prompt_);
      END IF;
   END IF; 
END Check_Exist_By_Address;


-- Check_Exist_By_Source_Ref1
-- This procedure will be called from source object's Check_Delete
-- The error message generated here will be generic for all source objects.
PROCEDURE Check_Exist_By_Source_Ref1 (
   source_lu_name_      IN VARCHAR2,
   receiver_type_       IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2)
IS
   count_            NUMBER;
   lu_prompt_        VARCHAR2(2000);
   source_lu_prompt_ VARCHAR2(2000);
   p1_               VARCHAR2(2000);   
   CURSOR record_exist IS
      SELECT count(shipment_id)
        FROM shipment_tab
       WHERE receiver_type = receiver_type_
         AND source_ref1 = source_ref1_
         AND source_ref_type LIKE '%^' || source_ref_type_db_ || '^%';       
BEGIN
   OPEN record_exist;
   FETCH record_exist INTO count_;
   IF (record_exist%NOTFOUND) THEN
      count_ := 0;
   END IF;
   CLOSE record_exist;
   IF(count_ > 0 ) THEN
      lu_prompt_        := Language_SYS.Translate_Lu_Prompt_(lu_name_);
      source_lu_prompt_ := Language_SYS.Translate_Lu_Prompt_(source_lu_name_); 
      p1_               := source_lu_prompt_ || ' ' || source_ref1_;       
      Error_Sys.Record_General(lu_name_, 'SHIP_CONSTRAINT_SOURCE_REF1: The :P1 is used by :P2 row(s) in another object (:P3).', p1_, count_, lu_prompt_);      
   END IF;          
END Check_Exist_By_Source_Ref1;


-- Check_Exist_By_Freight_Payer
-- This procedure will be called from Receiver_Frght_Payer_Fwdr_API - Check_Delete___
PROCEDURE Check_Exist_By_Freight_Payer (
   receiver_type_              IN VARCHAR2,
   receiver_id_                IN VARCHAR2,
   receiver_addr_id_           IN VARCHAR2,
   forward_agent_id_           IN VARCHAR2,
   shipment_freight_payer_db_  IN VARCHAR2,
   shipment_freight_payer_id_  IN VARCHAR2)   
IS
   count_           NUMBER;
   lu_prompt_       VARCHAR2(2000);
   CURSOR record_exist IS
      SELECT count(shipment_id)
        FROM shipment_tab
       WHERE receiver_type  = receiver_type_
         AND receiver_id    = receiver_id_
         AND receiver_addr_id = receiver_addr_id_
         AND forward_agent_id = forward_agent_id_
         AND shipment_freight_payer = shipment_freight_payer_db_;
BEGIN
   OPEN record_exist;
   FETCH record_exist INTO count_;
   IF (record_exist%NOTFOUND) THEN
      count_ := 0;
   END IF;
   CLOSE record_exist;
   IF(count_ > 0 ) THEN
      lu_prompt_ := Language_SYS.Translate_Lu_Prompt_(lu_name_);      
      IF (shipment_freight_payer_db_ = Shipment_Payer_API.DB_RECEIVER) THEN
         Error_Sys.Record_General(lu_name_, 'SHIPCONSTRAINTFREIGHTPAYER: The Freight Payer ID :P1 is used by :P2 row(s) in another object (:P3).', shipment_freight_payer_id_, count_, lu_prompt_);
      END IF;         
   END IF; 
END Check_Exist_By_Freight_Payer;


-- Check_Exist_By_Fwdr_Info_Ourid
-- This procedure will be called from Forwarder_Info_Our_Id_API - Check_Delete___
PROCEDURE Check_Exist_By_Fwdr_Info_Ourid ( 
   company_                IN VARCHAR2,   
   forward_agent_id_       IN VARCHAR2,   
   our_id_                 IN VARCHAR2)
IS   
   count_           NUMBER;
   lu_prompt_       VARCHAR2(2000);
   
   CURSOR record_exist IS
      SELECT count(shipment_id)
        FROM shipment_tab 
       WHERE forward_agent_id = forward_agent_id_
         AND Site_API.Get_Company(contract) = company_
         AND shipment_freight_payer = Shipment_Payer_API.DB_SENDER; 
BEGIN    
   OPEN record_exist;
   FETCH record_exist INTO count_;
   IF (record_exist%NOTFOUND) THEN
      count_ := 0;
   END IF;
   CLOSE record_exist;
   
   IF(count_ > 0 ) THEN
      lu_prompt_ := Language_SYS.Translate_Lu_Prompt_(lu_name_); 
      Error_Sys.Record_General(lu_name_, 'SHIPCONSTRAINTFWDROURID: The Our ID :P1 is used by :P2 row(s) in another object (:P3).', our_id_, count_, lu_prompt_);
   END IF; 
END Check_Exist_By_Fwdr_Info_Ourid;


-- Modify_Source_Ref_Type
--   This method modifies the shipment source ref type according to the connected line source.
PROCEDURE Modify_Source_Ref_Type (
   shipment_id_     IN NUMBER,
   source_ref_type_ IN VARCHAR2,
   delete_          IN VARCHAR2 ) 
IS
   oldrec_        SHIPMENT_TAB%ROWTYPE;
   newrec_        SHIPMENT_TAB%ROWTYPE;   
   delimiter_     CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;
   count_         NUMBER; 
   
   CURSOR exist_lines IS  
      SELECT count(shipment_id)
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_ 
         AND source_ref_type = source_ref_type_;
BEGIN    
   IF(source_ref_type_ IS NOT NULL) THEN
      oldrec_ := Get_Object_By_Keys___(shipment_id_);   
      newrec_ := oldrec_;   
      IF(delete_ = Fnd_Boolean_API.DB_FALSE) THEN
         IF (newrec_.source_ref_type IS NULL) THEN
            newrec_.source_ref_type := delimiter_ || source_ref_type_ || delimiter_;
            Modify___(newrec_); 
         ELSE
            IF( newrec_.source_ref_type NOT LIKE '%^'||source_ref_type_||'^%') THEN
               newrec_.source_ref_type := newrec_.source_ref_type || source_ref_type_ || delimiter_;     
               Modify___(newrec_);
            END IF;         
         END IF;   
      ELSE
         -- Handle remove item
         OPEN exist_lines;
         FETCH exist_lines INTO count_;
         CLOSE exist_lines;
         IF(count_ = 0) THEN
            IF( newrec_.source_ref_type LIKE '%^'||source_ref_type_||'^%') THEN
               newrec_.source_ref_type := Replace(newrec_.source_ref_type, delimiter_ || source_ref_type_ || delimiter_, delimiter_);               
               IF(newrec_.source_ref_type = delimiter_) THEN
                  newrec_.source_ref_type := NULL;
               END IF;                              
               Modify___(newrec_);
            END IF;  
         END IF;
      END IF;
   END IF;
END Modify_Source_Ref_Type; 


-- Get_Source_Ref_Type_List
-- This method will return a value array by splitting the source ref type
PROCEDURE Get_Source_Ref_Type_List (
   source_ref_type_list_   OUT Utility_SYS.STRING_TABLE,
   num_types_              OUT NUMBER,
   source_ref_type_        IN  VARCHAR2 )
IS     
BEGIN
  Utility_SYS.Tokenize(source_ref_type_, Client_SYS.text_separator_, source_ref_type_list_, num_types_);        
END Get_Source_Ref_Type_List;


FUNCTION Source_Ref_Type_Exist (
   shipment_id_           IN NUMBER,
   source_ref_type_db_in_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_ref_type_db_ shipment_tab.source_ref_type%TYPE;
BEGIN
   source_ref_type_db_ := Get_Source_Ref_Type_Db(shipment_id_);
   IF( source_ref_type_db_ LIKE '%^'||source_ref_type_db_in_||'^%') THEN
      RETURN 'TRUE';
   END IF;   
   RETURN 'FALSE';   
END Source_Ref_Type_Exist;


FUNCTION Source_Ref_Type_Exist (
   source_ref_type_db_list_  IN VARCHAR2,
   source_ref_type_db_in_    IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN   
   IF( source_ref_type_db_list_ LIKE '%^'||source_ref_type_db_in_||'^%') THEN
      RETURN 'TRUE';
   END IF;   
   RETURN 'FALSE';   
END Source_Ref_Type_Exist;


FUNCTION Get_Distinct_Source_Ref1 (
   shipment_id_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Shipment_Line_API.Source_Ref1_Tab
IS
   distinct_source_ref1_tab_ Shipment_Line_API.Source_Ref1_Tab;  
   
   CURSOR get_distinct_source_ref1 IS
      SELECT DISTINCT(source_ref1)
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id     = shipment_id_
         AND source_ref_type = source_ref_type_db_; 
BEGIN
   OPEN  get_distinct_source_ref1;
   FETCH get_distinct_source_ref1 BULK COLLECT INTO distinct_source_ref1_tab_;
   CLOSE get_distinct_source_ref1;
RETURN distinct_source_ref1_tab_;
END Get_Distinct_Source_Ref1;


PROCEDURE Post_Send_Dispatch_Advice (
   shipment_id_   IN NUMBER,
   media_code_    IN VARCHAR2 ) 
IS    
   CURSOR get_shipment_lines IS
      SELECT DISTINCT source_ref1, source_ref_type      
      FROM   shipment_line_tab
      WHERE  shipment_id = shipment_id_;
BEGIN
   FOR shipment_line_rec IN get_shipment_lines LOOP
      -- Post actions to be performed in shipment line level after sending dispatch advice.            
      Shipment_Source_Utility_API.Post_Send_Dispatch_Advice(shipment_line_rec.source_ref1, shipment_line_rec.source_ref_type, media_code_);         
   END LOOP;   
END Post_Send_Dispatch_Advice;


-- Not_Pick_Reported_Line_Exist
--   Checks if any shipment line exist that have not been completly pick reported yet.
@UncheckedAccess
FUNCTION Not_Pick_Reported_Line_Exist (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_                         NUMBER;
   not_pick_reported_line_exist_ NUMBER := 0;
   
   CURSOR not_pick_reported_line_exist IS
      SELECT 1
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id = shipment_id_
         AND inventory_part_no IS NOT NULL  -- Don't include non-inventory parts
         AND qty_assigned > qty_picked;
BEGIN
   IF (shipment_id_ IS NOT NULL AND shipment_id_ != 0) THEN
      OPEN not_pick_reported_line_exist;
      FETCH not_pick_reported_line_exist INTO temp_;
      IF(not_pick_reported_line_exist%FOUND) THEN
         not_pick_reported_line_exist_ := 1; 
      END IF;
      CLOSE not_pick_reported_line_exist;
   END IF;
   RETURN not_pick_reported_line_exist_;
END Not_Pick_Reported_Line_Exist;


-- Blocked_Sources_Exist
--   Checks whether blocked sources exist after certain steps in the shipment flow
PROCEDURE Blocked_Sources_Exist (
   blocked_sources_exist_ OUT BOOLEAN,
   shipment_id_           IN  NUMBER,
   operation_             IN  VARCHAR2)
IS
   CURSOR get_sources_for_delivery IS
      SELECT DISTINCT source_ref1, source_ref_type
        FROM shipment_line_tab
       WHERE shipment_id  = shipment_id_
         AND (((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) >= 0))
             OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))           
         AND (qty_picked > 0 OR qty_to_ship > 0);
         
   CURSOR get_sources_for_reservation IS
      SELECT DISTINCT source_ref1, source_ref_type
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_;
BEGIN
   blocked_sources_exist_ := FALSE;
   IF (operation_ = 'DELIVER') THEN
      FOR rec_ IN get_sources_for_delivery LOOP
         IF (Shipment_Source_Utility_API.Blocked_Source_Exist(rec_.source_ref1, rec_.source_ref_type) = Fnd_Boolean_API.DB_TRUE) THEN
            blocked_sources_exist_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   ELSIF (operation_ = 'CREATE_PICKLIST') THEN
      IF(Shipment_Source_Utility_API.Blocked_Sources_Exist_For_Pick(shipment_id_, Get_Source_Ref_Type_Db(shipment_id_)) = Fnd_Boolean_API.DB_TRUE) THEN
          blocked_sources_exist_ := TRUE;
      END IF;     
   ELSIF (operation_ = 'RESERVE') THEN
      FOR rec_ IN get_sources_for_reservation LOOP
         IF (Shipment_Source_Utility_API.Blocked_Source_Exist(rec_.source_ref1, rec_.source_ref_type) = Fnd_Boolean_API.DB_TRUE) THEN
            blocked_sources_exist_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
   END IF;
END Blocked_Sources_Exist;


-- Contains_Dangerous_Goods
--   Return TRUE if the given shipment contains hazardous goods.
@UncheckedAccess
FUNCTION Contains_Dangerous_Goods (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_           NUMBER;
   dangerous_goods_ VARCHAR2(5) := 'TRUE';
   CURSOR find_dangerous_goods IS
      SELECT 1
      FROM   shipment_line_tab
      WHERE  shipment_id = shipment_id_
      AND    Part_Catalog_Invent_Attrib_API.Get_Adr_Rid_Class_Id(source_part_no) IS NOT NULL;
BEGIN
   OPEN  find_dangerous_goods;
   FETCH find_dangerous_goods INTO dummy_;
   IF (find_dangerous_goods%NOTFOUND) THEN
      dangerous_goods_ := 'FALSE';
   END IF;
   CLOSE find_dangerous_goods;
   RETURN dangerous_goods_;
END Contains_Dangerous_Goods;


-- All_Lines_Picked
--   Checks all lines picked in the shipment.
@UncheckedAccess
FUNCTION All_Lines_Picked (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_   NUMBER;
   result_ VARCHAR2(5) := 'TRUE';

   CURSOR unpicked_lines IS
      SELECT 1
        FROM shipment_line_tab 
       WHERE shipment_id = shipment_id_        
         AND ((source_ref_type = 'CUSTOMER_ORDER' AND Utility_SYS.String_To_Number(source_ref4) = 0)
             OR source_ref_type != 'CUSTOMER_ORDER')                      
         AND (qty_picked = 0 AND qty_to_ship = 0);

   CURSOR unpicked_pkg_lines IS
      SELECT 1
        FROM shipment_line_tab sl1
       WHERE sl1.shipment_id  = shipment_id_
         AND source_ref_type  = 'CUSTOMER_ORDER'
         AND Utility_SYS.String_To_Number(sl1.source_ref4) = -1
         AND (sl1.qty_picked  = 0 AND sl1.qty_to_ship = 0)
         AND NOT EXISTS ( SELECT 1 FROM shipment_line_tab sl2 
                           WHERE sl2.shipment_id  = sl1.shipment_id
                             AND NVL(sl2.source_ref1, string_null_) = NVL(sl1.source_ref1, string_null_)
                             AND NVL(sl2.source_ref2, string_null_) = NVL(sl1.source_ref2, string_null_)
                             AND NVL(sl2.source_ref3, string_null_) = NVL(sl1.source_ref3, string_null_)
                             AND Utility_SYS.String_To_Number(sl2.source_ref4) > 0
                             AND (sl2.qty_picked != 0 OR sl2.qty_to_ship != 0));         
BEGIN
   OPEN  unpicked_lines;
   FETCH unpicked_lines INTO temp_;
   IF (unpicked_lines%FOUND) THEN
      result_ := 'FALSE';
   ELSE
      OPEN unpicked_pkg_lines;
      FETCH unpicked_pkg_lines INTO temp_;
      IF (unpicked_pkg_lines%FOUND) THEN
         result_ := 'FALSE';
      END IF;
      CLOSE unpicked_pkg_lines;
   END IF;
   CLOSE unpicked_lines;
   RETURN result_;
END All_Lines_Picked;


@UncheckedAccess
FUNCTION All_Lines_Reserved (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   all_lines_reserved_ VARCHAR2(5) := 'TRUE';
   dummy_              NUMBER;
   
   -- TO_DO_LIME: Manual source should be skipped.
   CURSOR get_unreserved_lines IS
      SELECT 1
        FROM shipment_line_tab
       WHERE shipment_id = shipment_id_
         AND ((inventory_qty - qty_assigned - qty_to_ship) > 0);         
BEGIN
   OPEN  get_unreserved_lines;
   FETCH get_unreserved_lines INTO dummy_;
   IF (get_unreserved_lines%FOUND) THEN
      all_lines_reserved_ := 'FALSE';
   END IF;
   CLOSE get_unreserved_lines;
   RETURN all_lines_reserved_;
END All_Lines_Reserved;


@UncheckedAccess
FUNCTION Get_Tot_Packing_Qty_Deviation(
   shipment_id_ IN NUMBER) RETURN NUMBER
IS
   CURSOR total_packing_qty_deviation IS
      SELECT SUM(Shipment_Handling_Utility_API.Get_Packing_Qty_Deviation(source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, shipment_id))
      FROM   shipment_line_tab
      WHERE (((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) <= 0))
             OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))          
      AND    shipment_id = shipment_id_;

   total_packing_qty_deviation_ NUMBER;
BEGIN
   OPEN total_packing_qty_deviation;
   FETCH total_packing_qty_deviation INTO total_packing_qty_deviation_;
   CLOSE total_packing_qty_deviation;
   RETURN total_packing_qty_deviation_;
END Get_Tot_Packing_Qty_Deviation;


-- Release_Not_Reserved_Qty
--   Release the not reserved qty in shipment lines back to the customer order.
PROCEDURE Release_Not_Reserved_Qty (
   shipment_id_ IN NUMBER )
IS
   CURSOR get_shipment_lines IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, (inventory_qty - qty_assigned - qty_to_ship) remaining_qty_to_reserve
        FROM shipment_line_tab
       WHERE shipment_id  = shipment_id_
         AND ((source_ref_type =  Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND TO_NUMBER(source_ref4) = 0)
              OR (source_ref_type NOT IN (Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)))
         AND ((inventory_qty - qty_assigned - qty_to_ship) > 0);

BEGIN
   FOR shipment_line_rec_ IN get_shipment_lines LOOP
      Shipment_Line_API.Release_Not_Reserved_Qty(shipment_id_, shipment_line_rec_.source_ref1, shipment_line_rec_.source_ref2, 
                                                 shipment_line_rec_.source_ref3, shipment_line_rec_.source_ref4, shipment_line_rec_.source_ref_type,
                                                 shipment_line_rec_.remaining_qty_to_reserve, 'RELEASE_NOT_RESERVED');           
   END LOOP; 

   IF(Shipment_API.Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN   
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Release_Not_Reserved_Pkg_Qty(shipment_id_);
      $ELSE
         NULL; 
      $END         
   END IF;      
END Release_Not_Reserved_Qty;


-- Shipment_Structure_Exist
--   Returns 'TRUE' if the package structure exist for the given shipment.
--   Otherwise 'FALSE'.
@UncheckedAccess
FUNCTION Shipment_Structure_Exist (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(shipment_id_);
END Shipment_Structure_Exist;


PROCEDURE Receiver_Address_Exist (
   receiver_id_      IN VARCHAR2,
   receiver_addr_id_ IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2)
IS 
BEGIN   
   IF(Shipment_Source_Utility_API.Receiver_Address_Exists(receiver_id_, receiver_addr_id_, receiver_type_db_) = Fnd_Boolean_API.DB_FALSE) THEN   
      Error_SYS.Record_General(lu_name_, 'RECEIVERADDRNOTEXIST: Receiver address ID :P1 does not exist', receiver_addr_id_, receiver_type_db_);
   END IF;
END Receiver_Address_Exist;


PROCEDURE Sender_Address_Exist (
   sender_id_      IN VARCHAR2,
   sender_addr_id_ IN VARCHAR2,
   sender_type_db_ IN VARCHAR2)
IS 
BEGIN   
   IF(Shipment_Source_Utility_API.Sender_Address_Exists(sender_id_, sender_addr_id_, sender_type_db_) = Fnd_Boolean_API.DB_FALSE) THEN   
      Error_SYS.Record_General(lu_name_, 'SENDERADDRNOTEXIST: Sender address ID :P1 does not exist', sender_addr_id_, sender_type_db_);
   END IF;
END Sender_Address_Exist;


FUNCTION Any_Reciept_Issue_Serial_Part(
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   serial_tracked_only_rec_issue_ BOOLEAN := FALSE;
   
   CURSOR get_inventory_part_no IS
      SELECT inventory_part_no
        FROM SHIPMENT_LINE_TAB
       WHERE shipment_id = shipment_id_         
         AND (((source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(source_ref4) >= 0))
               OR (source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))
         AND inventory_part_no IS NOT NULL;
BEGIN 
   FOR inventory_part_rec_ IN get_inventory_part_no LOOP        
      serial_tracked_only_rec_issue_ := Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(inventory_part_rec_.inventory_part_no); 
      IF (serial_tracked_only_rec_issue_) THEN 
         EXIT;
      END IF;
   END LOOP;
   RETURN serial_tracked_only_rec_issue_;
END Any_Reciept_Issue_Serial_Part;


-- Fetch_Freight_Payer_Info
-- This will fetch freight payer information depending on the parameters delivery term, 
-- shipment payer, forwarder id, receiver type, receiver id and receiver address.
-- If freight_payer_db_value is sent, depending on that freight_payer_id_ is returned.
-- If freight_payer_db_value is not sent, both freight_payer_db_ and freight_payer_id_ are returned.
PROCEDURE Fetch_Freight_Payer_Info(
   freight_payer_id_           OUT    VARCHAR2, 
   freight_payer_db_           IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   delivery_terms_             IN     VARCHAR2,   
   forward_agent_id_           IN     VARCHAR2,
   receiver_type_db_           IN     VARCHAR2,
   receiver_id_                IN     VARCHAR2,
   receiver_addr_id_           IN     VARCHAR2)
IS
   receiver_contract_          VARCHAR2(5);
BEGIN 
   -- When freight payer is not sent as an IN parameter, default value could be fetched from delivery terms
   -- and this value will be sending as OUT parameter. 
   IF (freight_payer_db_ IS NULL) THEN
      freight_payer_db_ := Order_Delivery_Term_API.Get_Def_Shipm_Freight_Payer_Db(delivery_terms_);
   END IF;     
   IF (freight_payer_db_ = Shipment_Payer_API.DB_RECEIVER) THEN 
      IF (receiver_type_db_ IN (Sender_Receiver_Type_API.DB_CUSTOMER,Sender_Receiver_Type_API.DB_SUPPLIER)) THEN
         freight_payer_id_ := Receiver_Frght_Payer_Fwdr_API.Get_Freight_Payer_Id(forward_agent_id_, Sender_Receiver_Type_API.Decode(receiver_type_db_), receiver_id_, receiver_addr_id_);
      ELSIF (receiver_type_db_ IN (Sender_Receiver_Type_API.DB_SITE, Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE)) THEN
         -- If receiver type is site or remote warehouse, fetch the receiver site from the receiver id.
         IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
            receiver_contract_ := Warehouse_API.Get(receiver_id_).contract;
         ELSE
            receiver_contract_ := receiver_id_;
         END IF;
         freight_payer_id_ := Forwarder_Info_Our_Id_API.Get_Our_Id(forward_agent_id_, Site_API.Get_Company(receiver_contract_));
      END IF;
   ELSIF (freight_payer_db_ = Shipment_Payer_API.DB_SENDER) THEN
      freight_payer_id_ := Forwarder_Info_Our_Id_API.Get_Our_Id(forward_agent_id_, Site_API.Get_Company(contract_));   
   END IF;    
   -- If freight payer is still not defined even in delivery terms, 'Not Specified' will be returning as freight_payer_db 
   freight_payer_db_ := NVL(freight_payer_db_, Shipment_Payer_API.DB_NOT_SPECIFIED);
END Fetch_Freight_Payer_Info;


PROCEDURE Reset_Printed_On_Hu_Info_Chg (
  shipment_id_                     IN NUMBER, 
  sscc_is_changed_                 IN BOOLEAN,
  alt_hu_unit_label_id_is_changed_ IN BOOLEAN,
  manual_gross_weight_is_changed_  IN BOOLEAN,
  manual_volume_is_changed_        IN BOOLEAN )
IS
   unset_pkg_list_print_         BOOLEAN:=FALSE;
   unset_consignment_print_      BOOLEAN:=FALSE;
   unset_del_note_print_         BOOLEAN:=FALSE;
   unset_pro_forma_print_        BOOLEAN:=FALSE;
   unset_bill_of_lading_print_   BOOLEAN:=FALSE;
   lu_rec_                       SHIPMENT_TAB%ROWTYPE;   
BEGIN
   IF (Any_Printed_Flag_Set__(shipment_id_) = 'FALSE') THEN
      RETURN;
   END IF;
   
   lu_rec_ := Get_Object_By_Keys___(shipment_id_);
   
   IF (lu_rec_.package_list_printed = Gen_Yes_No_API.DB_YES) THEN
      IF (sscc_is_changed_ OR alt_hu_unit_label_id_is_changed_ OR manual_gross_weight_is_changed_ OR manual_volume_is_changed_) THEN
         unset_pkg_list_print_ := TRUE;
      END IF;
   END IF;

   IF (lu_rec_.bill_of_lading_printed = Gen_Yes_No_API.DB_YES) THEN
      IF (manual_volume_is_changed_ OR manual_gross_weight_is_changed_) THEN
         unset_bill_of_lading_print_ := TRUE;
      END IF;
   END IF;
   
   IF (lu_rec_.consignment_printed = Gen_Yes_No_API.DB_YES) THEN
      IF (manual_volume_is_changed_ OR manual_gross_weight_is_changed_) THEN
         unset_consignment_print_ := TRUE;
      END IF;
   END IF;
   
   IF (lu_rec_.del_note_printed = Gen_Yes_No_API.DB_YES) THEN
      IF (manual_volume_is_changed_ OR manual_gross_weight_is_changed_) THEN
         unset_del_note_print_ := TRUE;
      END IF;
   END IF;
   
   IF (lu_rec_.pro_forma_printed = Gen_Yes_No_API.DB_YES) THEN
      IF (manual_volume_is_changed_ OR manual_gross_weight_is_changed_) THEN
         unset_pro_forma_print_ := TRUE;
      END IF;
   END IF;
   
   IF (unset_bill_of_lading_print_ OR unset_consignment_print_ OR 
       unset_del_note_print_       OR unset_pkg_list_print_    OR unset_pro_forma_print_)  THEN
          
      Reset_Printed_Flags__(shipment_id_                => shipment_id_,
                            unset_pkg_list_print_       => unset_pkg_list_print_,
                            unset_consignment_print_    => unset_consignment_print_,
                            unset_del_note_print_       => unset_del_note_print_,
                            unset_pro_forma_print_      => unset_pro_forma_print_,
                            unset_bill_of_lading_print_ => unset_bill_of_lading_print_,
                            unset_address_label_print_  => FALSE );
                         
   END IF;
   
END Reset_Printed_On_Hu_Info_Chg;


@UncheckedAccess
FUNCTION Trigger_Complete_Ship_Allowed (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   trigger_complete_ship_allowed_ VARCHAR2(5) := 'FALSE';
   shipment_line_no_              SHIPMENT_LINE_TAB.shipment_line_no%TYPE;
BEGIN
   IF (Complete_Shipment_Allowed___(shipment_id_) = 1) THEN
      IF (Pick_Shipment_API.Unreported_Pick_Lists_Exist(shipment_id_) = 'FALSE') THEN
         shipment_line_no_ := Pick_Shipment_API.Get_Res_Not_Pick_Listed_Line(shipment_id_); 
         IF (shipment_line_no_ IS NULL) THEN
            trigger_complete_ship_allowed_ := 'TRUE';
         END IF;
      END IF;
   END IF;

   RETURN trigger_complete_ship_allowed_;
END Trigger_Complete_Ship_Allowed;


PROCEDURE Check_Reset_Printed_Flags (
   shipment_id_                IN NUMBER,
   unset_pkg_list_print_       IN BOOLEAN,
   unset_consignment_print_    IN BOOLEAN,
   unset_del_note_print_       IN BOOLEAN,
   unset_pro_forma_print_      IN BOOLEAN,
   unset_bill_of_lading_print_ IN BOOLEAN,
   unset_address_label_print_  IN BOOLEAN )
IS
BEGIN
   IF (Any_Printed_Flag_Set__(shipment_id_) = 'TRUE') THEN
     Reset_Printed_Flags__(shipment_id_                ,
                           unset_pkg_list_print_       ,
                           unset_consignment_print_    ,
                           unset_del_note_print_       ,
                           unset_pro_forma_print_      ,
                           unset_bill_of_lading_print_ ,
                           unset_address_label_print_  );  
   END IF;                                   
END Check_Reset_Printed_Flags;


@IgnoreUnitTest TrivialFunction
@UncheckedAccess
FUNCTION Undo_Shipment_Allowed (
   shipment_id_   IN NUMBER ) RETURN BOOLEAN
IS
   rec_  shipment_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(shipment_id_);
   RETURN Undo_Shipment_Allowed___(rec_);
END Undo_Shipment_Allowed;


PROCEDURE Get_Sender_Rece_Contract_Whse(
   dest_contract_           OUT VARCHAR2,
   dest_warehouse_id_       OUT VARCHAR2,
   delivering_warehouse_id_ OUT VARCHAR2,
   shipment_id_             IN  NUMBER)
IS
   shipment_rec_     Shipment_API.Public_Rec;
BEGIN
   shipment_rec_ := Shipment_API.Get(shipment_id_);
   
   IF (shipment_rec_.sender_type = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      delivering_warehouse_id_ := Warehouse_API.Get_Warehouse_Id_By_Global_Id(shipment_rec_.sender_id);
   ELSE
      delivering_warehouse_id_ := '*';
   END IF;
   
   IF (shipment_rec_.receiver_type = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      Warehouse_API.Get_Keys_By_Global_Id(dest_contract_, dest_warehouse_id_, shipment_rec_.receiver_id);
   ELSE
      dest_contract_       := shipment_rec_.receiver_id;
      dest_warehouse_id_   := '*';            
   END IF;   
END Get_Sender_Rece_Contract_Whse;

PROCEDURE Modify_Receiver_Info (
   source_ref1_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   receiver_type_db_      IN VARCHAR2,
   receiver_id_           IN VARCHAR2,
   receiver_addr_id_      IN VARCHAR2,
   receiver_address_name_ IN VARCHAR2,
   receiver_address1_     IN VARCHAR2,
   receiver_address2_     IN VARCHAR2,
   receiver_address3_     IN VARCHAR2,
   receiver_address4_     IN VARCHAR2,
   receiver_address5_     IN VARCHAR2,
   receiver_address6_     IN VARCHAR2,
   receiver_city_         IN VARCHAR2,
   receiver_state_        IN VARCHAR2,
   receiver_zip_code_     IN VARCHAR2,
   receiver_county_       IN VARCHAR2,
   receiver_country_      IN VARCHAR2)
IS
   TYPE Shipment_Id_Tab  IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
   shipment_id_tab_      Shipment_Id_Tab;
   rec_                  shipment_tab%ROWTYPE;
   
   CURSOR get_active_shipments IS
      SELECT DISTINCT shipment_id
      FROM   shipment_line_tab
      WHERE  source_ref1 = source_ref1_
      AND    source_ref_type = source_ref_type_db_
      AND    qty_shipped = 0;
BEGIN   
   OPEN get_active_shipments;
   FETCH get_active_shipments BULK COLLECT INTO shipment_id_tab_;
   CLOSE get_active_shipments;
   
   FOR i IN 1..shipment_id_tab_.COUNT LOOP
      IF (Check_Mixed_Source_Ref1_Exist(shipment_id_tab_(i), source_ref1_, source_ref_type_db_)) THEN
         Error_SYS.Record_General(lu_name_, 'SOURCELINESEXIST: Receiver cannot be updated since Shipment :P1 contains lines from other sources.', shipment_id_tab_(i));
      END IF;
      
      rec_ := Get_Object_By_Keys___(shipment_id_tab_(i));
      IF rec_.rowstate IN ('Preliminary', 'Completed') THEN 
         rec_.receiver_type         := receiver_type_db_;
         rec_.receiver_id           := receiver_id_;
         rec_.receiver_addr_id      := receiver_addr_id_;
         rec_.receiver_address_name := receiver_address_name_;
         rec_.receiver_address1     := receiver_address1_;
         rec_.receiver_address2     := receiver_address2_;
         rec_.receiver_address3     := receiver_address3_;
         rec_.receiver_address4     := receiver_address4_;
         rec_.receiver_address5     := receiver_address5_;
         rec_.receiver_address6     := receiver_address6_;
         rec_.receiver_city         := receiver_city_;
         rec_.receiver_state        := receiver_state_;
         rec_.receiver_zip_code     := receiver_zip_code_;
         rec_.receiver_county       := receiver_county_;
         rec_.receiver_country      := receiver_country_;
         Modify___(rec_);
      END IF;
   END LOOP;
END Modify_Receiver_Info;

@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Sender_Address (
   sender_addr_id_       OUT VARCHAR2,
   sender_name_          OUT VARCHAR2,
   sender_address1_      OUT VARCHAR2,
   sender_address2_      OUT VARCHAR2,
   sender_address3_      OUT VARCHAR2,
   sender_address4_      OUT VARCHAR2,
   sender_address5_      OUT VARCHAR2,
   sender_address6_      OUT VARCHAR2,
   sender_zip_code_      OUT VARCHAR2,
   sender_city_          OUT VARCHAR2,
   sender_state_         OUT VARCHAR2,
   sender_county_        OUT VARCHAR2,
   sender_country_       OUT VARCHAR2,
   shipment_id_          IN  NUMBER)
IS
   CURSOR get_sender_address_ IS
   SELECT  sender_addr_id,
           sender_name,
           sender_address1,
           sender_address2,
           sender_address3,
           sender_address4,
           sender_address5,
           sender_address6,
           sender_zip_code,
           sender_city,
           sender_state,
           sender_county,
           sender_country
   FROM shipment_tab
   WHERE shipment_id = shipment_id_;
BEGIN
   OPEN  get_sender_address_;
   FETCH get_sender_address_ INTO sender_addr_id_,
           sender_name_,
           sender_address1_,
           sender_address2_,
           sender_address3_,
           sender_address4_,
           sender_address5_,
           sender_address6_,
           sender_zip_code_,
           sender_city_,
           sender_state_,
           sender_county_,
           sender_country_;
   CLOSE get_sender_address_;
END Get_Sender_Address;

PROCEDURE Create_Outgoing_Tax_Document (
   tax_document_no_ OUT NUMBER,  
   shipment_id_     IN  NUMBER )
IS
   rec_ shipment_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(shipment_id_);
   IF (rec_.source_ref_type IN ('^SHIPMENT_ORDER^')) THEN
      Create_Tax_Document___(tax_document_no_, rec_);
   END IF;
END Create_Outgoing_Tax_Document;

@UncheckedAccess
FUNCTION Check_Mixed_Source_Ref1_Exist (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN BOOLEAN
IS
   CURSOR record_exist IS
      SELECT 1
      FROM   shipment_line_tab
      WHERE  shipment_id = shipment_id_
      AND    (source_ref1 != source_ref1_
      OR     source_ref_type != source_ref_type_db_);
   
   exist_   BOOLEAN := FALSE;
   dummy_   NUMBER;
BEGIN
   OPEN  record_exist;
   FETCH record_exist INTO dummy_;
   IF (record_exist%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE record_exist;
   RETURN exist_;   
END Check_Mixed_Source_Ref1_Exist;

@UncheckedAccess
FUNCTION Inventory_Part_Lines_Exist (
   shipment_id_    IN NUMBER ) RETURN VARCHAR2  
IS
   CURSOR record_exist IS
      SELECT 1 
      FROM   shipment_line_tab
      WHERE  shipment_id = shipment_id_
      AND    inventory_part_no IS NOT NULL;
   
   dummy_   NUMBER; 
   exist_   VARCHAR2(5) := 'FALSE';
BEGIN
      OPEN record_exist;
      FETCH record_exist INTO dummy_;
      IF record_exist%FOUND THEN
         exist_ := 'TRUE';
      END IF;
      CLOSE record_exist;
      RETURN exist_;    
END Inventory_Part_Lines_Exist;

