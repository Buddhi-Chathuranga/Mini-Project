-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentSourceUtility
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220730  HasTlk  SCDEV-12931, Modified Post_Deliver_Shipment method to Handle automatic creation of outgoing nota fiscal based on company parameter.
--  220714  Disklk  PJDEV-7479, Changed Post_Undo_Deliv_Shipment_Line and Pre_Undo_Delv_Shipment_Line to enable Undo Delivery for project deliverable connected shipments
--  220714  MaEelk  SCDEV-11672, Modified Post_Deliver_Shipment_Line to calculate Amounts and Taxes in connected Tax Document.
--  220710  RoJalk  SCDEV-12305, Added the method Enforce_Report_Pick_From_Lines.  
--  220705  ErRalk  Bug SCDEV-12243, Modified Get_Line to update the QtyToShip in the Shipment Line for No Part and Non-Inventory Part.
--  220705  Diablk  SCDEV-12148, Modified Get_Source_Delivery_Rpt_Info to support non inventory Part.
--  220701  PrRtlk  SCZ-19156, Moved Supplier Return related logic from Pre_Undo_Deliv_Shipment_Line to ShipmentRcptReturnUtil.
--  220623  PamPlk  SCDEV-9373, Modified Is_Goods_Non_Inv_Part_Type to support Shipment Order.
--  220620  Aabalk  SCDEV-9149, Modified Post_Scrap_Return_In_Ship_Inv to include Shipment_Ord_Utility_API.Post_Return_In_Ship_Inv to do post actions after returning
--  220620          a purchase receipt shipment order.
--  220603  PamPlk  SCDEV-10606, Modified Get_Line by adding sender_type_ and sender_id_ as in parameters.
--  220510  PrRtlk  SCDEV-10536, Modified Check_Tot_Qty_To_Ship to consider Purch Receipt Return source ref type.
--  220510  RoJalk  SCDEV-8967, Modified Get_Manual_Reserv_Allowed__ to disable manual reservation for PO receipt shipment order.
--  220405  RoJalk  SCDEV-8951, Added the method Get_Demand_Code_Db.
--  220405  PrRtlk  SCDEV-8742, Moved the validations in Post_Undo_Deliv_Shipment_Line to Pre_Undo_Deliv_Shipment_Line.
--  220420  KETKLK  PJDEV-4625, Modified Get_Line() to fetch del_terms_location when creating shipment through project deliverables.
--  220415  AsZelk  SC21R2-6630, Modified Post_Scrap_Return_In_Ship_Inv() to support Purch Receipt Return.
--  220413  SaLelk  SCDEV-904, Modified Get_Line by fetching values for dock_code, sub_dock_code, ref_id, location_no from shipment order line.
--  220411  PrRtlk  SCDEV-8742, Removed the Undo Available check from Pre condition and moved it to the post condition.
--  220329  RasDlk  SCDEV-8647, Added the method Any_Rental_Line_Exists which returns whether any rental lines exist for a particular shipment.
--  220318  AsZelk  SCDEV-7716, Added Check_Undo_Handling_Units___(), Get_Top_Avail_Handl_Unit___() and modified Pre_Undo_Deliv_Shipment_Line() to support for PURCH_RECEIPT_RETURN source.
--  220314  PamPlk  SCDEV-3012, Modified Get_Rental_Db() by removing the code block related to PURCH_RECEIPT_RETURN.
--  220126  Diablk  SC21R2-7305, Modified Enable_Custom_Fields_for_Rpt to avoid installation errors.
--  220119  PamPlk  SC21R2-7213, Modified Get_Address_Line in order to support for the supplier.
--  220118  ErRalk  SC21R2-7072, Modified Pre_Deliver_Shipment_Line by adding shipment_id as a paramater to include value into alt_source_ref5 when delivering non-inventory and no parts.
--  220110  RoJalk  SC21R2-2756, Modified Get_Reserv_Info_On_Delivered and included activity seq.
--  220107  RasDlk  SC21R2-3145, Added the methods Pre_Undo_Deliv_Shipment_Line and Post_Undo_Deliv_Shipment_Line to support Undo Shipment Delivery 
--  220107          for sources other than Customer Order.
--  220107  PrRtlk  SC21R2-7001, Modified Get_Sender_Addr_Info to support Get_Sender_Addr_Info method modification in ShipmenntRcptReturnUtil.
--  220106  PrRtlk  SC21R2-6723, Changed Is_Goods_Non_Inv_Part_Type method to support No Part.  
--  211209  NiDalk  SC21R2-6425, Added  Validate_Ref_Id to validated refernce id of the shipment with connecting source line reference ids.
--  211222  PrRtlk  SC21R2-6664, Modified Get_Tot_Avail_Qty_To_Connect to support non-inv/no part in Purchase Receipt Return. 
--  211221  Diablk  SC21R2-6288, Modified methods to support DB_PURCH_RECEIPT_RETURN.
--  211221  ErRalk  SC21R2-2980, Modified Get_Delivery_Transaction_Info to fetch delivery transaction for supplier return.
--  211221  PamPlk  SC21R2-2980, Modified Pre_Deliver_Shipment_Line() to support DB_PURCH_RECEIPT_RETURN.
--  211221  PrRtlk  SC21R2-6723, Modified Is_Goods_Non_Inv_Part_Type() to support purch receipt return. 
--  211221  PamPlk  SC21R2-2980, Modified Post_Deliver_Shipment_Line() to support DB_PURCH_RECEIPT_RETURN.
--  211207  PraWlk  FI21R2-7673, Modified Is_Goods_Non_Inv_Part_Type() to to consider project deliverables as well.
--  211130  AsZelk  SC21R2-6110, Modified Get_Line_Planned_Del_Date__, Get_Line_Planned_Ship_Date__, Get_Line_Planned_Due_Date__ to support PURCH_RECEIPT_RETURN.
--  211126  ErRalk  SC21R2-3009, Modified Get_Sender_Addr_Info, Get_Receiver_Addr_Info, Get_Receiver_Address_Info and Get_Addr_Line to support sender receiver address fetching for supplier return.
--  211123  PrRtlk  SC21R2-2978, Modified Pre_Deliver_Shipment method to support DB_PURCH_RECEIPT_RETURN.
--  211126  PamPlk  SC21R2-3012, Modified Remove_Picked_Line to support Purchase Receipt Return.
--  211123  RoJalk  SC21R2-5614, Modified Check_Man_Reservation_Valid and moved the shipment order related logic to Shipment_Ord_Utility_API.
--  211117  ErRalk  SC21R2-3011, Modified Fetch_Source_And_Deliv_Info and Get_Receiver_Address_Info to fetch delivery information for supplier return.
--  211117  PamPlk  SC21R2-3012, Modified Validate_Source_Ref1, Get_Label_Note and Get_Receiver_Part_No__ to support Purchase Receipt Return.
--  211112  AaZelk  SC21R2-3013, Modified Get(), Get_Line() methods to support for DB_PURCH_RECEIPT_RETURN.
--  211109  ErRalk  SC21R2-3011, Modified Get_Forward_Agent_Id, Get_Document_Address, Validate_Receiver_Id and Get_Receiver_Information,
--  211109          Is_Valid_Receiver_Address, Check_Receiver_Address_Exist and Get_Language_Code to support supplier receiver type.  
--  211109  PamPlk  SC21R2-3012, Modified Source_Exist, Get_Tot_Avail_Qty_To_Connect and Get_Connectable_Source_Qty__ to support Purchase Receipt Return.
--  211108  PamPlk  SC21R2-3012, Modified Fetch_And_Validate_Ship_Line and Get_Forward_Agent_Id to support Purchase Receipt Return.
--  211101  PamPlk  SC21R2-3012, Modified Check_Qty_To_Reserve to support Purchase Receipt Return.
--  211027  PamPlk  SC21R2-3012, Modified the methods Get_Source_Project_Id__ , Get_Source_Activity_Seq__, Get_Configuration_Id, Get_Rental_Db, Get_Condition_Code__, 
--  211027          Get_Owner_For_Part_Ownership__, Is_Uom_Group_Connected__ and Is_Shipment_Connected in order to support PURCH_RECEIPT_RETURN.
--  211022  ErRalk  SC21R2-3011, Modified Get_Receiver_Site___, Receiver_Address_Exists, Get_Address_Name, Get_Language_Code and Get_Receiver_Name to support supplier receiver type.  
--  211021  RoJalk  SC21R2-3082, Modified Get_Source_Info_At_Reserve__ and added the parameter owning_vendor_no_.
--  211018  SaLelk  SC21R2-3083, Modified Public_Line_Rec, Get_Line, Get_Shipment_Reference_Info by adding owner & owner_name.
--  211013  SaLelk  SC21R2-3083, Modified Get_Owner_For_Part_Ownership__ to get owner from Shipment_Order_Line for Shipment Order.
--  210921  AvWilk  SC21R2-688, Modified Get_Source_Activity_Seq__ to call Shipment_Order_Line_API.Get_Activity_Seq.
--  210916  RoJalk  SC21R2-688, Modified Get_Source_Info_At_Reserve__ and called Shipment_Ord_Utility_API.Get_Info_At_Reserve, changed Check_Man_Reservation_Valid to consider project aware shipment orders..
--  210915  SaLelk  SC21R2-688, Fetch the project_id from Shipment_Order_Line for Shipment Order. 
--  210914  PamPlk  SC21R2-2341, Moved the method Get_Remote_Warehouse_Addr_Info to Whse_Shipment_Receipt_Info_API.
--  210818  PamPlk  SC21R2-2286, Modified the methods Get_Remote_Warehouse_Addr_Info to fetch address details when party type is CUSTOMER for DB_GEOLOCATION.
--  210813  PamPlk  SC21R2-2286, Modified the methods Get_Remote_Warehouse_Addr_Info and Get_Address_Name in order to support for GEOLOCATION address type.
--  210711  RoJalk  SC21R2-1374, Added the parameter ship_handling_unit_id_  to the Modify_Reservation_Qty_Picked method.
--  210225  RoJalk  SC2020R1-7243, Modified Get_Available_Qty__ and added the parameter ignore_this_avail_control_id_ to Inventory_Part_In_Stock_API.Get_Inventory_Quantity call.
--  210223  RoJalk  SC2020R1-12685, Modified Check_Man_Reservation_Valid and added the check to include only the standard inventory for Shipment Order.
--  210209  RoJalk  SC2020R1-7243, Modified Shipment_Source_Utility_API.Get_Source_Info_At_Reserve__ and removed the parameters part_no and contract.
--  210209          Modified Get_Available_Qty__ and passed the warehouse_id_ to the method call Inventory_Part_In_Stock_API.Get_Inventory_Quantity.
--  210126  RoJalk  SC2020R1-7243, Modified Get_Source_Info_At_Reserve__ to fetch include_standard_, include_project_ from Planning_Item_API.Get_Project_Deliverable_Info.
--  210106  ErRalk  Bug 156211(SSCZ-12900), Added sales_part_description to Source_Info_Rpt_Rec.
--  201120  LEPESE  SC2020R1-10727, modifications in Get_Source_Part_Desc, Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist for Shipment Order.
--  201109  ErRalk  SC2020R1-11001, Added method Get_Shipment_Reference_Info to fetch shipment reference info for Pick Part By Choice.
--  201105  RasDlk  SC2020R1-10865, Modified the method Get_Delivery_Transaction_Info by calling a method in PRJDEL to return the transaction code.
--  201105  ErRalk  SC2020R1-10472, Added part_ownership to the Get_Line method.
--  201103  ErRalk  SC2020R1-10472, Added method Get_Warehouse_Info to fetch both warehouse id and availability control id.Modified Get method to add SenderId and SenderType.         
--  201018  RoJalk  SC2020R1-10349, Modified Get_Source_Supply_Country_Db, Get_Supply_Country_Db to return a default value for sources other than Customer Order or receiver is Customer.
--  201016  DiJwlk  Modified Create_Data_Capture_Lov(), Get_Column_Value_If_Unique(), Record_With_Column_Value_Exist().
--  201016          Excluded SHIPMENT_ORDER from PACK_INTO_HANDLING_UNIT_SHIP process
--  201007  RoJalk  SC2020R1-1673, Modified Get_Receiver_Part_No__, Get_Receiver_Part_Desc to fetch receiver part info from shipment line for sources other than Customer Order.
--  200924  RoJalk  SC2020R1-1673, Modified Get_Available_Qty__ to support sources other than Customer Order.
--  200923  KETKLK  PJ2020R1-3755, Modified procedure Get_Source_Info_At_Reserve__ to return the part_ownership_db_ and owning_customer_no_.
--  200923  RoJalk  SC2020R1-1673, Removed the method Get_Origin_Source_Part_Desc since logic is moved to Customer Order.
--  200916  RoJalk  SC2020R1-1673, Added the overloaded method Get_Language_Code with source ref information. Removed customer_no and originating_co_lang_code
--  200916          from public records since related logic is moved to Customer Order.
--  200916  RoJalk  SC2020R1-9192, Modified Get_Source_Info_At_Reserve__ and added the parameters part_ownership_, picking_leadtime_, atp_rowid_.
--  200923  RoJalk  SC2020R1-1673, Modified Validate_Source_Ref1 and added code to support shipment order.
--  200910  RoJalk  SC2020R1-1138, Renamed Get_Source_Proj_At_Reserve__ to  Get_Source_Info_At_Reserve__ and included the logic to fetch the values for Shipment Order.
--  200911  RoJalk  SC2020R1-1673, Modified Get_Receiver_Branch to fetch branch using Site_Discom_Info_API.Get_Branch when receiver is not Customer.
--  200910  RasDlk  SC2020R1-9649, Modified Get_Receiver_Information by setting a default value to SHIPMENT_UNCON_STRUCT_DB for all sources.
--  200903  ErRalk  SC2020R1-7302, Modified Get_Pick_By_Choice_Blocked_Db to support for both Shipment Order and Project Deliverables.
--  200820  RasDlk  SC2020R1-1926, Removed the unused methods Get_Line_Adj_Weight_Gross__ and Get_Line_Adjusted_Volume__.
--  200729  ErRalk  SC2020R1-1033, Modified Get_Pick_By_Choice_Blocked_Db to fetch pick_by_choice_blocked_ value when the SourceRefType is Shipment Order.
--  200724  RasDlk  SC2020R1-7195, Modified the method Get_Line by fetching values for planned_ship_date and planned_delivery_date for SHIPMENT_ORDER.
--  200626  AsZelk  Bug 154344(SCZ-10338), Added ship_via_code_changed_ defult parameter to Fetch_Source_And_Deliv_Info.
--  200622  RasDlk  SC2020R1-689, Modified Check_Pick_List_Exist by removing the source ref type looping.
--  200617  RoJalk  SC2020R1-445, Modified Is_Shipment_Connected to always return true for shipment order and project deliverables.
--  200616  PamPlk  SC2020R1-7179, Modified the method Get_Receiver_Auto_Des_Adv_Send when source_ref_type_is SHIPMENT_ORDER.
--  200612  RoJalk  SC2020R1-1673, Removed the unused method .Get_Inventory_Qty__. Modified Reserved_As_Picked_Allowed__ to use Reserve_Shipment_API.Use_Generic_Reservation.
--  200611  RasDlk  SC2020R1-7195, Modified Get_Line_Planned_Del_Date__, Get_Line_Planned_Ship_Date__ and Get_Line_Planned_Due_Date__ to support shipment order flow.
--  200604  RasDlk  SCSPRING20-1238, Modified Get_Receiver_Address_Info by adding sender type and sender id as parameters and changed the calling places accordingly.
--  200604          Implemented the logic related to fetching delivery attributes for receiver type SITE and REMOTE WAREHOUSE.
--  200604          Modified Fetch_Source_And_Deliv_Info by changing ship_via_code_ as an IN OUT parameter.
--  200602  RoJalk  SC2020R1-1673, Modified Get_Part_Customs_Stat_No to fetch the value from Inventory Part for Shipment Order and Project Deliverables.
--  200602          Removed the unused method Get_Inv_Qty_To_Connect. 
--  200601  PamPlk  SC2020R1-7225, Modified the methods Get_Receiver_Addr_Info in order to fetch the receiver's description if receiver's address name is NULL and when receiver type 
--  200601          is SITE or REMOTE_WAREHOUSE.
--  200525  RoJalk  SC2020R1-2201, Modified calls to Shipment_Handling_Utility_API.Get_Packing_Qty_Deviation to pass the source ref type as a parameter.
--  200522  RoJalk  SC2020R1-1673, Modified Reserved_As_Picked_Allowed__ to support shipment order.
--  200424  RoJalk  SC2020R1-1977, Modified Get_Delivery_Transaction_Info to return ignore_this_avail_control_id_.
--  200319  WaSalk  GESPRING20-533, Added After_Generate_Alt_Del_Note_No() to support Alt_Delnote_No_Chronologic localization.
--  200414  RasDlk  SCSPRING20-1954, Modified the method Check_Man_Reservation_Valid() by removing the configuration id parameters.
--  200409  PamPlk  SC2020R1-2180, Modified the methods 'Get_Receiver_Addr_Info' and 'Get_Remote_Warehouse_Addr_Info' in order to fetch the address name when receiver type is SITE or REMOTE_WAREHOUSE.
--  200403  PamPlk  SCSPRING20-177, Modified the method 'Get_Default_Media_Code' and 'Get_Receiver_Msg_Setup_Addr'in order to support Shipment Order- Sending Dispatch Advice
--  200403          and Added the method Get_Receiver_Site___.
--  200330  RoJalk  SC2020R1-2269, Modified Get_Route_Id, Get_Forward_Agent_Id, Get_Condition_Code__ to support shipment order.
--  200319  WaSalk  GESPRING20-533, Added Post_Generate_Alt_Delnote_No() to support Alt_Delnote_No_Chronologic localization.
--  200318  RasDlk  SCSPRING20-170, Modified the method Check_Man_Reservation_Valid() by adding configuration id parameters. Also checked the ownership and configuration id
--  200318          in Shipment Order flow.
--  200312  RasDlk  SCSPRING20-170, Modified Get_Manual_Reserv_Allowed__() to check whether manual reservation is allowed through shipment order.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200304  BudKlk  Bug 148995(SCZ-5793), Modified the Public_Rec to resize the variable cust_ref.
--  200304  RasDlk  SCSPRING20-1238, Modified Fetch_Source_And_Deliv_Info() to fetch the deilvery attributes and source specific attributes when the receiver type is
--  200304          SITE and REMOTE_WAREHOUSE in Shipment Order flow.
--  200203  MeAblk  SCSPRING20-312, Modified Get_Line_Rowkey() to support shipment order.
--  200129  MeAblk  SCSPRING20-313, Supported method Get_Line_Lu_Name() for shipment order.
--  200128  MeAblk  SCSPRING20-366, Supported method Get_Source_Proforma_Rpt_Info() for shipmnet order.
--  200128  MeAblk  SCSPRING20-365, Supported method Get_Source_Delivery_Rpt_Info() for shipment order.
--  200123  DipeLk  GESPRING20-1774, Added method After_Print_Shpmnt_Del_Note to support modify_date_applied functionality in shipment.
--  200120  MeAblk  SCSPRING20-1770, Modified Get_Receiver_Part_Qty() to support shipment orders.
--  191212  MeAblk  SCSPRING20-1239, Added Post_Reservation_Actions().
--  191210  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191210          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191210          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  191128  RoJalk  SCSPRING20-173, Modified Remove_Picked_Line to support Shipment Order.
--  191114  RoJalk  SCSPRING20-984, Modified Get_Delivery_Transaction_Code to support Shipment Order.
--  191107  ErRalk  SCSPRING20-959, Modified methods Get_Receiver_Information, Get_Address_Name, Get_Document_Address, Get_Address_Line,Sender_Address_Exists, Get_Supply_Country_Db, 
--  191107          Get_Remote_Warehouse_Addr_Info and Receiver_Address_Exists Get_Document_Address by replacing Warehouse_Purch_Info_API with Whse_Shipment_Receipt_Info_API.
--  191107  MeAblk  SCSPRING20-937, Modified Public_Rec and Get_Line() to fetch kore details on sender and fetch details for shipment orders.
--  191106  RoJalk  SCSPRING20-175 Modified Pre_Deliver_Shipment to support shipment order.
--  191104  MeAblk  SCSPRING20-1043, Modified Source_Exist(), to validate shipment order lines and project deliverable lines.
--  191104  RoJalk  SCSPRING20-489, Modified Check_Qty_To_Reserve to support Shipment Order.
--  191031  Meablk  SCSPRING20-196, Modified Get_Connectable_Source_Qty__() and Get_Tot_Avail_Qty_To_Connect() to support shipment order lines. 
--  191029  MeAblk  SCSPRING20-196, Modified Get_Line() and Fetch_And_Validate_Ship_Line() to support shipment order lines.
--  191023  ErFelk  Bug 149943(SCZ-6856), Added new method All_Lines_Has_Doc_Address().
--  191022  MeAblk  SCSPRING20-190, Added misc changes regarding supporting remote warehouse as the sender and receiver.
--  191015  MeAblk  SCSPRING20-538, Modified methods Get_Receiver_Information(), Validate_Receiver(), Get_Receiver_Addr_Info(), Get_Language_Code(), Get_Document_Address(), Get_Forward_Agent_Id(),
--  191015          to support the new sender type and sender id. Added new methods Get_Sender_Address_Info(), Validate_Sender_Id(), Get_Sender_Name(), Sender_Address_Exists().
--  190823  ErFelk  Bug 149543(SCZ-6407), Modified Unreported_Pick_Lists_Exist() by changing a call to Customer_Order_Reservation_API.Unreported_Pick_Lists_Exist().
--  190819  ErFelk  Bug 149269(SCZ-5459), Added new function Receiver_Part_Invert_Conv_Fact().
--  190524  KiSalk  Bug 148393(SCZ-4896), In Check_Man_Reservation_Valid, replaced two method calls Reserve_Customer_Order_API.Man_Res_Valid_Ext_Service__ and Man_Res_Valid_Ownership__ with 
--  190524          Reserve_Customer_Order_API.Check_Man_Reservation_Valid to reduce repeated access of customer_order_line_tab.
--  190514  DiKuLk  Bug 147858(SCZ-4348), Added handling_unit_id to Reservation_Rec and Modified Get_Reserv_Info_On_Delivered() accordingly.
--  190503  ErFelk  Bug 147615(SCZ-4066), Added method Get_Source_Proj_At_Reserve__().
--  190425  KiSalk  Bug 147862(SCZ-4366), Added Is_Load_List_Connected.
--  180516  SBalLK  Bug 141724, Removed defined component dependency with own component.
--  180226  RoJalk  STRSC-15257, Added the method Get_Total_Qty_On_Pick_List.
--  180223  RoJalk  STRSC-15257, Added the method Get_Total_Qty_Reserved.
--  171226  Nikplk  STRSC-15288, Modified Get_Address_Name method to retrieve receiver address name from Customer_Info_Address_API and removed Get_Receiver_Address_Name method.
--  171219  NaLrlk  STRSC-15140, Modified Post_Deliver_Shipment() to execute Handling_Unit_API.Create_Shipment_Hist_Snapshot() before post actions.
--  171219  SURBLK  STRSC-14943, Added support for Nullable Source Ref4 in Create_Data_Capture_Lov, Get_Column_Value_If_Unique, Record_With_Column_Value_Exist.
--  170812  MaRalk  STRSC-11659, Modified Get_Supply_Country_Db in order to return a value when ORDER module is not installed.
--  171122  Nikplk  STRSC-14702, Added Get_Receiver_Address_Name method.
--  171106  RoJalk  STRSC-12406, Changed the return type of Use_Report_Pick_List_Lines to be VARCHAR2.
--  171026  CKumlk  STRSC-13772, Modified Create_Data_Capture_Lov so From_Location_No data item have location_type as one of the description columns in lov.
--  171019  RoJalk  STRSC-12396, Added the method Prioritize_Res_On_Desad.
--  171004  Kagalk  CRUISE-178, Added method Get_Exc_Svc_Delnote_Print_Db.
--  171003  JeLise  STRSC-12327, Added pick_by_choice_blocked_ in Reserve_Manually and added method Get_Pick_By_Choice_Blocked_Db.
--  170726  RoJalk  STRSC-10699, Modified Get_Reserv_Info_On_Delivered and included shipment_id_ in cursor.
--  170616  TiRalk  STRSC-8884, Modified Post_Send_Dispatch_Advice.
--  170530  RoJalk  LIM-11494, Modified Pick_Report_Ship_Allowed and replaced Pick_Customer_Order_API.Is_Ship_Pick_Report_Allowed
--  170530          with Pick_Shipment_API.Use_Report_Pick_List_Lines.
--  170516  RoJalk  LIM-11281, Modified Remove_Picked_Line and added a validation to prevent the deletion of picked PD lines.
--  170515  RoJalk  STRSC-8427, Removed the method Validate_Pick_List_Status.
--  170508  MaRalk  LIM-11258, Moved Print_Pick_List_Allowed from PickShipment and kept handling for customer order only.  
--  170427  RoJalk  LIM-11359, Added the method Modify_Ship_Inventory_Loc_No.
--  170426  KHVESE  STRSC-2419, Modified method Create_Data_Capture_Lov, added structure level to HANDLING_UNIT_ID, SSCC AND ALT HANDLING_UNIT_ID descriptions.
--  170417  RoJalk  LIM-10538, Modified Get_Route_Id, Get_Forward_Agent_Id to fetch values from Planning_Shipment_API. 
--  170411  RoJalk  LIM-10538, Added methods Get_Route_Id, Get_Forward_Agent_Id.
--  170411  RoJalk  LIM-10554, Added the method Modify_Pick_Ship_Location.
--  170406  Jhalse  LIM-11096, Removed method Check_Pick_List_Use_Ship_Inv as shipment inventory is now mandatory for shipment.
--  170406          Removed references to use_ship_inventory_ for same reason as above.
--  170406          Removed method Uses_Shipment_Inventory__ as it already has been moved to HandleShipInventUtility.
--  170330  MaRalk  LIM-9052, Moved methods Print_Pick_List_Allowed, Get_Pick_Lists_For_Shipment to PickShipment utility.
--  170329  MaRalk  LIM-9646, Moved Post_Print_Pick_List__ method to PickShipment utility.
--  170328  tratlk  STRPJ-20785, Modified Post_Deliver_Shipment_Line to create project connections 
--                  for standard planned items.
--  170328  MaRalk  LIM-9646, Modified Post_Print_Pick_List__ in order to set printed flag TRUE 
--  170328          in Inventory_Pick_List_Tab for semi-centralized pick lists.
--  170322  RoJalk  LIM-9117, Code improvements to the method Reserved_As_Picked_Allowed__. 
--  170317  Jhalse  LIM-10113, Moved Get_Default_Shipment_Location and Get_Confirm_Shipment_Location to Pick_Shipment_API.
--  170316  RoJalk  LIM-9159, Modified Get_Reserv_Info_On_Delivered to fetch information using shipment_source_reservation.
--  170314  MaIklk  LIM-6946, Added Get_Tot_Avail_Qty_To_Connect() and. 
--  170308  MaIklk  LIM-10827, Changes done to Get_Source_Proforma_Rpt_Info and Get_Source_Delivery_Rpt_Info to support PD.
--  170307  Jhalse  LIM-10113, Added method Get_Confirm_Shipment_Location to support new picking functionality.
--  170302  RoJalk  LIM-11001, Replaced Shipment_Source_Utility_API.Public_Reservation_Rec with
--  170302          Reserve_Shipment_API.Public_Reservation_Rec. Modified Lock_And_Fetch_Reserve_Info to be a function.
--  170302          Moved Public_Reservation_Rec to Reserve_Shipment_API.
--  170227  tratlk  STRPJ-20085, transaction code 'PD-SHIP' to Get_Delivery_Transaction_Code. 
--                  Handled Pre_Deliver_Shipment for Project Deliverables
--  170223  MaIklk  LIM-9422, Fixed to pass shipment_line_no as parameter when calling ShipmentReservHandlUnit methods.
--  170220  MaIklk  LIM-10826, Removed Get_Reserv_Line_Rpt_Info, Get_Not_Reserv_Line_Rpt_Info and Get_Location_Group.
--  170220          Added Get_Line_Lu_Name and Get_Line_Rowkey.
--  170207  MaIklk  LIM-9357, Added Get_Receiver_Part_Conv_Factor().
--  170127  MaIklk  LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  170126  MaIklk  LIM-10463, Removed supply_country from public_rec and added NVL part in Get_Source_Supply_Country_Db().
--  170126  MaIklk  LIM-10461, Revisited functions related to receiver type and made some enhancements to them.
--  170124  MaRalk  LIM-10080, Added Get_Delivery_Transaction_Code in order to use in shipment delivery.
--  170104  MaIklk  LIM-10190, Moved Transfer_Line_Reservations() to ReserveShipment.
--  170102  MaIklk  LIM-10161, Removed Get_Total_Qty_Assigned, Get_Qty_Assigned, Get_Qty_Assigned_In_Hu and Get_Total_Qty_Assigned_In_Hu.
--  170102          Handled them in ReserveShipment instead. Using Shipment_Source_Reservation.
--  161223  MaIklk  LIM-8085, Handled component not exist for source ref type related functions.
--  161221  MaIklk  LIM-8389, Removed Get_Catch_Qty().
--  161221  MaIklk  LIM-8389, Removed Get_Reserved_Not_Pick_Listed().
--  161221  MaIklk  LIM-8802, Added more code sections to make the code more readable.
--	 161219	Jhalse  LIM-9189, Removed Get_Source_Part_No as it was redundant.
--  161205  MaIklk  LIM-9261, Removed Get_Remain_Res_To_Hu_Connect and handled it in Shipment_Reserv_Handl_unit_API.
--  161205  MaIklk  LIM-9257, Moved Get_Number_Of_Reservation, Add_Reservations_To_Handl_Unit, Add_Reservations_On_Reassign to Shipment_Reserv_Handl_Unit_API
--  161129  SWiclk  LIM-9255, Modified Create_Data_Capture_Lov(), Get_Column_Value_If_Unique() and Record_With_Column_Value_Exist() by replacing 
--  161129          Shipment_Source_Utility_API.Get_Quantity_On_Shipment() with Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment()
--  161128  MaIklk  LIM-9255, Removed ShipmentReservHandlUnit related functions and implemented to directly access the LU in SHPMNT.
--  161118  NiDalk  LIM-9293, Added catalog_type to Source_Info_Rpt_Rec.
--  161116  MaIklk  LIM-9232, Get_Qty_Assigned_In_Hu__ and Get_Total_Qty_Assigned_In_Hu__ made as public methods
--  161116  RoJalk  LIM-9684, Modified Get_Reserv_Hu_Ext_Details and joined the cursor by reserv_handling_unit_id.
--  161110  MaRalk  LIM-9129, Removed Deliver_Ship_Line_Inv and moved the content into 
--  161110          Shipment_Delivery_Utility_API.Deliver_Ship_Line_Inv___ method.
--  161102  MaRalk  LIM-9143, Modified Post_Deliver_Shipment_Line, Pre_Deliver_Shipment_Line 
--  161102          to add parameters qty_to_ship_ and qty_picked_ instead of shipment_id and shipment_line_no.
--  161026  MaRalk  LIM-9153, Removed the method Deliver_Ship_Line_Non_Inv and moved the content into 
--  161026          Shipment_Delivery_Utility_API.Deliver_Ship_Line_Non_Inv___ method.
--  161026          Added methods Pre_Deliver_Shipment_Line, Post_Deliver_Shipment_Line.
--  161014  DaZase  LIM-8934, Added method Get_Attached_Qty_Hu. 
--  161010  RoJalk  LIM-6944, Added methods Handle_Ship_Line_Qty_Change, Handle_Line_Qty_To_Ship_Change.
--  161010          Renamed Validate_Source_Line to Source_Exist.
--  160930  RoJalk  LIM-8056, Added the method Post_Send_Dispatch_Advice.
--  160926  TiRalk  Bug 130619, Modified Pick_Report_Ship_Allowed() in order to allow Report picking of pick list lines
--  160926          when there are one or multiple pick lists created with single shipments.
--  160913  RoJalk  LIM-8581, Added the method Is_Shipment_Connected.
--  160909  RoJalk  LIM-8191, Added the method Get_Default_Shipment_Location.
--  160907  RoJalk  LIM-8596, Added the method Recalc_Catch_Price_Conv_Factor.
--  160902  MaIklk  LIM-8492, Added Get_Receiver_Part_Desc().
--  160831  RoJalk  LIM-8563, Added the method Get_Source_Part_Desc_By_Source. 
--  160831  RoJalk  LIM-8284, Renamed Post_Scrap_Part_In_Ship_Inv to Post_Scrap_Return_In_Ship_Inv.
--  160830  RoJalk  LIM-8189, Added the PLSQL table type Reserv_Handl_Unit_Qty_Tab and methods Add_Handling_Units, Get_Handling_Units.
--  160829  DaZase  LIM-8334, Added methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist 
--  160829          for Pack Into Handling Unit Shipment process (was earlier in CustomerOrderReservation) and reworked them 
--  160829          for the new data source. 
--  160824  RoJalk  LIM-8400, Added the method Get_Quantity_On_Shipment.
--  160824  RoJalk  LIM-8392, Added the method Get_Receiver_Auto_Des_Adv_Send .
--  160822  RoJalk  LIM-8056, Added the methods Get_Receiver_Msg_Setup_Addr, Increase_Receiver_Msg_Seq_No.
--  160818  RoJalk  LIM-8189, Modified Modify_Reservation_Qty_Picked interface and included input_qty, input_unit_meas_, 
--  160818          input_conv_factor_, input_variable_values_,  move_to_ship_location_.
--  160816  Chfose  LIM-8006, Modified methods with calls to Shipment_Reserv_Handl_Unit_API to align the position of the 
--  160816                    reserv_handling_unit_id-parameter with other methods.
--  160815  MaIklk  LIM-8136, Used header source ref type instead of receiver type for Post_Del_Note_Invalid_Action and Post_Create_Deliv_Note.
--  160811  MaIklk  LIM-8136, Added Get_Classification_Standard__, Get_Classification_Part_No__ and Get_Classification_Unit_Meas__.
--  160810  RoJalk  LIM-8086, Added the method Get_Default_Address.
--  160804  RoJalk  LIM-8189, Added the paramater public_reservation_rec_ to the method Lock_And_Fetch_Reserve_Info.
--  160804  RoJalk  LIM-8189, Added Public_Reservation_Rec.
--  160802  MaIklk  LIM-8217, Added customs_value for public_line_rec.
--  160802  RoJalk  LIM-8180, Added the method Validate_Return_From_Ship_Inv.
--  160801  RoJalk  LIM-8189, Modified Lock_And_Fetch_Reserve_Info, added the parameter qty_shipped_ 
--                  and removed reassignment_type_. Added the method Post_Scrap_Part_In_Ship_Inv.
--  160729  MaIklk  LIM-8057, Moved creating invoice related functions to Shipment Flow.
--  160729  RoJalk  LIM-7954, Replaced Shipment_Order_Utility_API.Pre_Deliver_Shipment with
--  160729          Deliver_Customer_Order_API.Pre_Deliver_Shipment.
--  160729  RoJalk  LIM-7954, Removed the method Deliver_Shipment and moved the
--  160729          logic to Shipment_Flow_API.Deliver_Shipment___.
--  160729  RoJalk  LIM-7954, Added the methods Post_Deliver_Shipment, Deliver_Ship_Line_Non_Inv, 
--  160729          Deliver_Ship_Line_Inv. Replaced Deliver_Customer_Order_API.Deliver_Shipment__ with
--  160729          Shipment_API.Deliver_Shipment__. 
--  160728  RoJalk  LIM-8177, Added the method Modify_Reservation_Qty_Picked.
--  160726  UdGnlk  LIM-8163, Modified Deliver_Shipment() to support inventory event logic.
--  160726  RoJalk  LIM-8149, Modified Handle_Hu_Qty_Change__ to fetch shipment_line_no.
--  160715  RoJalk  LIM-7954, Added the method Pre_Deliver_Shipment.
--  160714  RoJalk  LIM-7359, Removed the method Reassign_Reservations.
--  160714  RoJalk  LIM-7359, Added the method New_Reservation.
--  160712  RoJalk  LIM-7962, Added the method Get_Ean_Location, included classification info in Public_Line_Rec.
--  160712  RoJalk  LIM-7956, Added methods Get_Uniq_Struct_Lot_Batch_No, Get_Uniq_Struct_Eng_Chg_Level,
--  160712          Get_Uniq_Struct_Waiv_Dev_Rej, Get_Uniq_Struct_Serial_No.
--  160705  RoJalk  LIM-7603, Added the method Get_Source_Supply_Country_Db.
--  160704  RoJalk  LIM-7913, Added the method Get_Reserv_Hu_Ext_Details.
--  160701  RoJalk  LIM-7359, Added the methods Update_Reserve_On_Reassign, Lock_And_Fetch_Reserve_Info,
--  160701          Remove_Reservation, Reservation_Exist, Reduce_Reserve_On_Reassign.
--  160630  TiRalk  STRSC-2702, Changed the places where it has used CreditBlocked from CustomerOrder has changed to state Blocked.
--  160628  RoJalk  LIM-7843, Added th method Get_Reserv_Handl_Unit_Details.
--  160624  MaIklk  LIM-7689, Added Enable_Custom_Fields_for_Rpt().
--  160624  RoJalk  LIM-7683, Added the method Get_Reserv_Info_On_Delivered.
--  160624  RoJalk  LIM-7683, Added Reservation_Rec and Reservation_Tab.
--  160624  RoJalk  LIM-7685, Added Reserv_Handl_Unit_Rec and Reserv_Handl_Unit_Tab. 
--  160623  SudJlk  STRSC-2698, Replaced Cust_Order_Line_Address_API.Public_Rec with Cust_Order_Line_Address_API.Co_Line_Addr_Rec and 
--  160623          Cust_Order_Line_Address_API.Get() with Cust_Order_Line_Address_API.Get_Co_Line_Addr()
--  160623  UdGnlk  LIM-7540, Modified Get() to retrieve the customer_po_no to receiver_po_no. 
--  160614  MaIklk  STRSC-2638, Added Get_Receiver_Part_Qty() and Get_Receiver_Source_Unit_Meas().
--  160608  MaIklk  LIM-7442, Added Receiver_Address_Exist, Get_Receiver_Branch, Post_Create_Deliv_Note, Valid_For_Ship_Net_Summary.
--  160606  MaRalk  LIM-7402, Removed parameters forward_agent_id_, zip_code_ , city_, state_, county_, country_code_   
--  160606          and forwarder_changed_ from Fetch_Source_And_Deliv_Info.
--  160606  RoJalk  LIM-7588, Renamed Reassign_Connected_Qty to Reassign_Reservations.
--  160606  RoJalk  LIM-6813, Aded the method Validate_Reassign_Hu.
--  160603  MaRalk  LIM-7355, Removed Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db call from 
--  160603          Get_Receiver_Information. Modified Fetch_Source_And_Deliv_Info by adjusting parameters 
--  160603          in Shipment_Order_Utility_API.Fetch_Freight_And_Deliv_Info method call.
--  160601  RoJalk  Renamed Modify_Line_Reservations to Transfer_Line_Reservations.
--  160530  RoJalk  LIM-7559, Modified Get_Supply_Country_Db, Get_Use_Price_Incl_Tax_Db to check receiver type.
--  160527  RoJalk  LIM-7559, Added the method Get_Use_Price_Incl_Tax_Db.
--  160519  RoJalk  LIM-7467, Added the parameter added_to_new_shipment_ to Post_Connect_To_Shipment.
--  160524  MaIklk  LIM-7362, Added Validate_Struc_Ownership__(), Get_Reserv_Input_Unit_Meas__(), Get_Reserv_Input_Qty__(), Get_Reserv_Input_Conv_Factor__
--  160524          Get_Reserv_Input_Var_Values__(), Handle_Hu_Qty_Change__(), Get_Qty_Assigned_In_HU__(), Get_Total_Qty_Assigned_In_HU__() and Get_Total_Qty_Assigned().
--  160520  MaIklk  LIM-7361, Added Is_Uom_Group_Connected__(), Reserved_As_Picked_Allowed__(), Report_Reserved_As_Picked__() and Check_All_License_Connected__().
--  160520  MaIklk  LIM-7361, Added Uses_Shipment_Inventory__() and Get_Owner_For_Part_Ownership__().
--  160519  RoJalk  LIM-7467, Added Post_Create_Auto_Ship and added Post_Create_Manual_Ship.
--  160517  UdGnlk  LIM-6927, Modified Get_Line() by adding receiver_uom and receiver_qty attributes to the line public rec.  
--  160516  reanpl  STRLOC-65, Added handling of new attributes address3, address4, address5, address6 
--  160516  RoJalk  LIM-7404, Added the method Get_Supply_Country_Db.
--  160512  RoJalk  LIM-6946, Added the method Get_Inv_Qty_To_Connect to return source qty available to connect to shipment.
--  160512  RoJalk  LIM-6947, Added the method Unreported_Pick_Lists_Exist.
--  160509  MaRalk  LIM-6531, Removed parameters freight_map_id_, zone_id_, price_list_no_ and use_price_incl_tax_ 
--  160509          from Fetch_Source_And_Deliv_Info.
--  160506  RoJalk  LIM-7222, Renamed Get_Quantity_On_Shipment to Get_Qty_To_Attach_On_Res.
--  160506  RoJalk  LIM-6964, Added methods Get_Reserved_Qty_Connected, Get_Quantity_On_Shipment.
--  160426  RoJalk  LIM-6625, Added the method Get_Sum_Reserve_To_Reassign.
--  160425  MaIklk  LIM-6741, Added Get_Address_Name() and Get_Address_Line().
--  160425  RoJalk  LIM-7256, Added methods Modify_Reserv_Handl_Unit, Remove_Reserv_Handl_Unit. 
--  160420  MaIklk  LIM-7205, Added Get_Available_Qty__() and Get_Inventory_Qty__().
--  160411  RoJalk  LIM-6969, Added the method New_Or_Add_To_Reserve_Hu.
--  160406  MaIklk  LIM-5279, Added Get_Prepayment_Amount__().
--  160404  MaIklk  LIM-5277, Added Get_Manual_Reserv_Allowed__(),Get_Source_Project_Id__(),Get_Source_Activity_Seq__(),Get_Line_Planned_Del_Date__(),
--  160404          Get_Line_Planned_Ship_Date__(),Get_Line_Planned_Ship_Period__(),Get_Line_Planned_Due_Date__(),Get_Connectable_Source_Qty__(),
--  160404          Get_Receiver_Part_No__(),Get_Condition_Code__(),Get_Line_Adj_Weight_Gross__(),Get_Line_Adjusted_Volume__().  
--  160401  RoJalk  LIM-6562, Adjusted the code so methods with similar purpose will be in same section.
--  160331  MaIklk  LIM-5278, Added Post_Print_Pick_List__() and passed OUT parameters to Get_Receiver_Addr_Info().
--  160331  RoJalk  LIM-6585, Removed the method et_Reserv_Qty_Left_To_Assign and replaced with 
--  160331          Shipment_Line_Handl_Unit_API.Get_Reserv_Qty_Left_To_Assign.
--  160330  MaRalk  LIM-6645, Added method Get_Rental_Db.
--  160330  RoJalk  LIM-4651, Modified Modify_Line_Reservations and renamed the parameter transfer_on_add_remove_line_ 
--  160330          to on_add_or_remove_. Removed the method Transfer_Line_Reservations.
--  160329  RoJalk  LIM-4651, Added the method Get_Qty_Assigned_For_Source.
--  160328  MaRalk  LIM-6591, Removed methods Get_Sales_Unit_Meas, Get_Conv_Factor, Get_Inverted_Conv_Factor.
--  160328          and Get_Converted_Inv_Qty, Get_Converted_Source_Qty. Removed fields sales_unit_meas, conv_factor 
--  160328          and inverted_conv_factor from Public_Line_Rec.
--  160328  RoJalk  LIM-6557, Changed the return type of Is_Goods_Non_Inv_Part_Type method to be VARCHAR2.
--  160325  MaIklk  LIM-6601, Added Get_Forward_Agent_Id().
--  160324  RoJalk  LIM-6579, Added the method Get_Reserved_Not_Pick_Listed.
--  160323  MaIklk  LIM-4668, Added Get_Not_Reserv_Line_Rpt_Info(), Get_Location_Group(), Get_Reserv_Line_Rpt_Info()
--  160323          Get_Receiver_Our_Id(), Get_Unique_Lot_Batch_No(), Get_Unique_Eng_Chg_Level(),Get_Print_Config_Code() and Get_Characteristic_Price().
--  160318  MaIklk  LIM-6564, Added Get_Part_Gtin_No() and Get_Source_Delivery_Rpt_Info().
--  160315  RoJalk  LIM-6509, Added the method Reassign_Connected_Qty. 
--  160315  RoJalk  LIM-4181, Added the method Add_Reservations_On_Reassign.
--  160314  RoJalk  LIM-4127, Added the method Get_Max_Ship_Qty_To_Reassign.
--  160314  RoJalk  LIM-6511, Added packing_instruction_id to Public_Line_Rec.
--  160311  MaIklk  LIM-4667, Added Source_Info_Rpt_Rec and Source_Info_Rpt_Tab. Also added Get_Serial_No, Get_Lot_Batch_No, 
--  160311          Get_Catch_Qty, Get_Source_Rpt_Info, Get_Print_Char_Code, New_Source_History_Line, Get_Tax_Id_Number, Get_Footer,
--  160311          Get_Part_Customs_Stat_No, Get_Part_Print_Control_Code, Get_Source_Part_Desc, Get_Source_Part_Desc_For_Lang, Get_Source_Part_Note_Id.
--  160311  RoJalk  LIM-6556, Added the method Get_Reserv_Qty_Left_To_Assign.
--  160311  MaRalk  LIM-5871, Modified Fetch_Info - method parameter source_ref4_ as VARCHAR.
--  160311  RoJalk  LIM-6556, Removed the method Get_Reserv_Hu_Attached_Qty and replaced with Get_Line_Attached_Reserv_Qty. 
--  160311  RoJalk  LIM-6556, Added the method Get_Line_Attached_Reserv_Qty. 
--  160306  RoJalk  LIM-6321, Added to_shipment_line_no_ to Reassign_Reserv_Handl_Unit.
--  160309  RoJalk  LIM-4650, Added the method Check_Update_Connected_Src_Qty.
--  160308  DipeLK  STRLOC-247,Change Validate_Address() method call to Address_validation_API.Validate_Address
--  160307  RoJalk  LIM-4630, Added the method Transfer_Line_Reservations.
--  160307  MaIklk  LIM-4670, Added Get_Configuration_Id(), Get_Conv_Factor() and Get_Inverted_Conv_Factor().
--  160307  RoJalk  LIM-4630, Added the method Post_Connect_To_Shipment.
--  160307  RoJalk  LIM-4653, Added method Validate_Pick_List_Status.
--  160304  RoJalk  LIM-4627, Added methods Fetch_And_Validate_Ship_Line, Post_Connect_Shipment_Line.
--  160301  RoJalk  LIM-6300, Renamed Qty_Reserve_Available to Check_Qty_To_Reserve.
--  160229  RoJalk  LIM-6216, Added method Validate_Source_Line.
--  160229  RoJalk  LIM-4627, Added methods Get_Number_Of_Reservations, Add_Reservations_To_Handl_Unit, Get_Sales_Unit_Meas.
--  160226  RoJalk  LIM-4637, Renamed Get_Line_Qty_To_Reserve to Qty_Reserve_Available.
--  160224  RoJalk  LIM-4656, Removed the methods Get_Open_Source_Ship_Qty___, Modify_Source_Open_Ship_Qty___ 
--  160224          Modify_Source_Ship_Connect___ and called Shipment_Order_Utility_API.Modify_Open_Shipment_Qty from Modify_Source_Open_Ship_Qty.
--  160224  RoJalk  LIM-4656, Added method Get_Open_Source_Ship_Qty___, Modify_Source_Open_Ship_Qty___ , 
--  160224          Modify_Source_Ship_Connect___ and Modify_Source_Open_Ship_Qty.
--  160223  RoJalk  LIM-4653, Called Shipment_Order_Utility_API.Post_Delete_Ship_Line from Post_Delete_Ship_Line.
--  160219  MaIklk  LIM-4134, Changed the calls inside Reserve_Shipment and Allowed operation.
--  160219  RoJalk  LIM-4657, Added the method Get_Converted_Source_Qty.
--  160218  MaIklk  LIM-4144, Added Get_Name(), Get_Document_Address() and Get_Receiver_E_Mail().
--  160218  RoJalk  LIM-4637, Added the method Get_Line_Qty_To_Reserve.
--  160217  MaIklk  LIM-4132, Added Blocked_Source_Exist() and Blocked_Sources_Exist_For_Pick().
--  160216  MaIklk  LIM-4141, Added Print_Pick_List().
--  160216  RoJalk  LIM-4628, Added method Modify_Line_Reservations.
--  160215  RoJalk  LIM-4659, Added the method Reassign_Reserv_Handl_Unit.
--  160215  RoJalk  LIM-4652, Added the method Post_Delete_Ship_Line.
--  160212  RoJalk  LIM-4182, Added the method Get_Reserv_Hu_Attached_Qty. 
--  160211  RoJalk  LIM-5934, Remove source info from Handle_Hu_Qty_Change.
--  160212  MaIklk  LIM-4146, Added Get_Source_Current_Info().
--  160211  MaIklk  LIM-4135, Changed Pick_Report_Ship_Allowed() to handle two calls to order side.
--  160210  MaIklk  LIM-6229, Added Reserve_Ship_Source_Allowed___().
--  160209  MaIklk  LIM-4147, Added Check_Pick_List_Use_Ship_Inv().
--  160209  MaIklk  LIM-4158, Added Print_Invoices().
--  160209  MaIklk  LIM-4140, Added Print_Invoice_Allowed().
--  160209  MaIklk  LIM-6229, Added picking related functions.
--  160208  MaIklk  LIM-4171, Added Check_Pick_List_Exist().
--  160205  RoJalk  LIM-4246, Added shipment_line_no_ to Handle_Hu_Qty_Change call.
--  150203  MaIklk  LIM-4139, Added Create_Ship_Invoice_Allowed() and Make_Shipment_Invoice().
--  160203  MaRalk  LIM-6114, Renamed attribute ship_addr_no as receiver_addr_id in Public_Line_Rec record type.  
--  160203          Modified methods Validate_Receiver_Address, Get_Receiver_Address_Info,  
--  160203          Fetch_Source_And_Deliv_Info and Get_Receiver_Information to reflect attribute receiver_addr_id 
--  160203          instead of ship_addr_no in shipment_tab. 
--  160202  RoJalk  LIM-4661, Added the method Shipment_Source_Utility_API.Handle_Hu_Qty_Change.
--  160201  MaIklk  LIM-6124, Added Get_Source_Part_Desc().
--  160128  MaIklk  LIM-4151, Added Plan_Pick_Shipment_Allowed().
--  160127  MaIklk  LIM-4150, Added Deliver_Shipment().
--  160127  MaIklk  LIM-4148, Added Reserve_Shipment().
--  160127  MaRalk  LIM-4165, Added Validate_Update_Closed_Shipmnt which contains logic of 
--  160127          Shipment-Check_For_Invoiced_Order_Lines and error message in Shipment-Unpack___ .
--  160122  MaIklk  LIM-6002, Added Fetch_Source_And_Deliv_Info().
--  160120  MaIklk  LIM-4166, Added Get_Default_Media_Code() and Get_Delnote_No_For_Shipment().
--  160120  MaIklk  LIM-5946, Moved Receiver validations related code to this.
--  160119  MaIklk  LIM-5751, Added Is_Goods_Non_Inv_Part_Type().
--  160108  RoJalk  LIM-5748, Removed the method Fetch_Line_Info since the usage will be replaced with Fetch_Info.
--  160107  RoJalk  LIM-5748, Added the method Get_Converted_Inv_Qty.
--  160107  RoJalk  LIM-5748, Added the method Fetch_Info.
--  160107  MaIklk  LIM-5749, Added Public_Rec, Get() and Get_Language_Code().
--  160106  RoJalk  LIM-5748, Added the method Fetch_Line_Info and Addr_Line_Rec.
--  160105  RoJalk  LIM-5748, Added Addr_Line_Rec and Get_Addr_Line.
--  160105  MaIklk  LIM-5744, Added type Public_Line_Rec and Get_Line().
--  160104  RoJalk  LIM-4092, Added the method Remove_Picked_Line.
--  151228  MaIklk  LIM-4093, Created
-----------------------------------------------------------------------------

-- !!!******** IMPORTANT*********!!!
--
-- This utility will handle source specific calls which will trigger from Shipment side.
-- Add your source specific calls in the relevant methods using conditional compilation (refer customer order calls as example).
-- All the methods have been included in different code sections like reservation, picking, delivery, Misc and Reports.
-- Make sure you will add your new methods to correct code section or initiate a new code section to include your method if needed.
--
-- !!!******** IMPORTANT*********!!!

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

string_null_ CONSTANT VARCHAR2(11)        := Database_SYS.string_null_;

TYPE Public_Rec IS RECORD
  (source_ref1                 VARCHAR2(50),
   language_code               VARCHAR2(2),        
   use_price_incl_tax          VARCHAR2(20),        
   internal_ref                VARCHAR2(30),    
   cust_ref                    VARCHAR2(100),
   print_control_code          VARCHAR2(10),
   customs_value_currency      VARCHAR2(3),
   internal_po_no              VARCHAR2(12),
   label_note                  VARCHAR2(50),
   internal_po_label_note      VARCHAR2(50),
   receiver_po_no              VARCHAR2(50),
   case_id                     NUMBER,
   sender_id                   VARCHAR2(50),
   sender_type                 VARCHAR2(20));
   
TYPE Public_Line_Rec IS RECORD
  (source_ref1                       VARCHAR2(50),
   source_ref2                       VARCHAR2(50),
   source_ref3                       VARCHAR2(50),
   source_ref4                       VARCHAR2(50),
   sender_id                         VARCHAR2(50),
   receiver_id                       VARCHAR2(50),
   sender_type                       VARCHAR2(20),
   receiver_type                     VARCHAR2(20),
   receiver_addr_id                  VARCHAR2(50),
   sender_addr_id                    VARCHAR2(50),
   receiver_part_no                  VARCHAR2(45),
   ship_via_code                     VARCHAR2(3),   
   contract                          VARCHAR2(5),      
   delivery_terms                    VARCHAR2(5),
   del_terms_location                VARCHAR2(100),
   forward_agent_id                  VARCHAR2(20),
   location_no                       VARCHAR2(35),
   dock_code                         VARCHAR2(35),
   sub_dock_code                     VARCHAR2(35),
   route_id                          VARCHAR2(12), 
   ref_id                            VARCHAR2(35),
   shipment_type                     VARCHAR2(3),
   packing_instruction_id            VARCHAR2(50), 
   addr_flag                         VARCHAR2(1),
   planned_ship_date                 DATE,   
   planned_delivery_date             DATE,
   planned_due_date                  DATE,
   wanted_delivery_date              DATE,  
   freight_map_id                    VARCHAR2(15),
   zone_id                           VARCHAR2(15),
   demand_code                       VARCHAR2(20),   
   classification_standard           VARCHAR2(25),   
   classification_part_no            VARCHAR2(25),    
   classification_unit_meas          VARCHAR2(10), 
   input_unit_meas                   VARCHAR2(30),  
   real_ship_date                    DATE,
   receiver_uom                      VARCHAR2(10),
   receiver_qty                      NUMBER,
   supply_code                       VARCHAR2(3),
   rowstate                          VARCHAR2(20),
   receiver_part_conv_factor         NUMBER,
   receiver_part_invert_conv_fact    NUMBER,
   qty_shipdiff                      NUMBER,
   input_qty                         NUMBER,
   source_qty                        NUMBER,
   source_inventory_qty              NUMBER,
   open_shipment_qty                 NUMBER,
   source_qty_shipped                NUMBER,
   source_qty_to_ship                NUMBER,
   customs_value                     NUMBER,
   note_id                           NUMBER,
   delivery_sequence                 NUMBER,
   configuration_id                  VARCHAR2(50),
   part_ownership                    VARCHAR2(20),
   owner                             VARCHAR2(20),
   owner_name                        VARCHAR2(100));
   
TYPE Public_Addr_Line_Rec IS RECORD
  (receiver_address_name             VARCHAR2(100),
   receiver_address1                 VARCHAR2(35),         
   receiver_address2                 VARCHAR2(35),        
   receiver_address3                 VARCHAR2(100),        
   receiver_address4                 VARCHAR2(100),        
   receiver_address5                 VARCHAR2(100),        
   receiver_address6                 VARCHAR2(100),        
   receiver_city                     VARCHAR2(35),        
   receiver_state                    VARCHAR2(35),        
   receiver_zip_code                 VARCHAR2(35),    
   receiver_county                   VARCHAR2(35),      
   receiver_country                  VARCHAR2(2));  

TYPE Source_Info_Rpt_Rec IS RECORD
  (source_ref1                      VARCHAR2(50),
   source_ref2                      VARCHAR2(50),
   source_ref3                      VARCHAR2(50),
   source_ref4                      VARCHAR2(50),
   receiver_part_no                 VARCHAR2(45),
   source_part_no                   VARCHAR2(25),
   source_part_description          VARCHAR2(200),
   buy_qty_due                      NUMBER,
   qty_remaining                    NUMBER,
   total_qty_delivered              NUMBER,
   source_unit_meas                 VARCHAR2(35),    
   source_state                     VARCHAR2(20),     
   receiver_part_conv_factor        NUMBER,        
   receiv_part_invert_conv_fact     NUMBER,        
   note_id                          NUMBER,    
   manual_flag                      VARCHAR2(35),      
   configured_line_price_id         NUMBER,
   ref_id                           VARCHAR2(35),
   location_no                      VARCHAR2(35),
   receiver_part_desc               VARCHAR2(2000),
   dock_code                        VARCHAR2(35),
   sub_dock_code                    VARCHAR2(35),
   manufacturing_department         VARCHAR2(2000),
   delivery_sequence                NUMBER,
   receiver_po_no                   VARCHAR2(50),  
   tax_liability_type_db            VARCHAR2(20),
   source_rowkey                    VARCHAR2(50),
   shipment_rowkey                  VARCHAR2(50),
   shipment_line_rowkey             VARCHAR2(50),
   reserv_rowkey                    VARCHAR2(50),
   loc_rowkey                       VARCHAR2(50),
   qty_delivered                    NUMBER,
   source_unit_price                NUMBER,
   conv_factor                      NUMBER,
   inverted_conv_factor             NUMBER,
   input_unit_meas                  VARCHAR2(35),  
   input_qty                        NUMBER,
   input_variable_values            VARCHAR2(2000),
   contract                         VARCHAR2(5),
   configuration_id                 VARCHAR2(50),
   demand_code                      VARCHAR2(20),
   demand_source_ref1               VARCHAR2(15),
   condition_code                   VARCHAR2(10),
   planned_delivery_date            DATE,
   planned_ship_date                DATE,
   planned_due_date                 DATE,
   inventory_part_no                VARCHAR2(25),
   classification_part_no           VARCHAR2(25),
   classification_unit_meas         VARCHAR2(10),
   connected_source_qty             NUMBER,
   qty_picked                       NUMBER,
   qty_to_ship                      NUMBER,
   qty_shipped                      NUMBER,
   qty_assigned                     NUMBER,   
   source_ref_type_db               VARCHAR2(20),
   location_group                   VARCHAR2(5),
   warehouse                        VARCHAR2(15),
   bay_no                           VARCHAR2(5),
   row_no                           VARCHAR2(5),
   tier_no                          VARCHAR2(5),
   bin_no                           VARCHAR2(5),
   lot_batch_no                     VARCHAR2(20),
   serial_no                        VARCHAR2(50),
   eng_chg_level                    VARCHAR2(6),
   waiv_dev_rej_no                  VARCHAR2(15),
   activity_seq                     NUMBER,
   handling_unit_id                 NUMBER,
   source_lu_name                   VARCHAR2(30),
   reserv_lu_name                   VARCHAR2(30),
   catalog_type                     VARCHAR2(4),
   sales_part_description          VARCHAR2(200)
   );
   
TYPE Warehouse_Info_Rec IS RECORD
  (warehouse_id            VARCHAR2(15),
   availability_control_id VARCHAR2(25)); 
   
TYPE Source_Info_Rpt_Tab IS TABLE OF Source_Info_Rpt_Rec INDEX BY PLS_INTEGER;
 
TYPE Reservation_Rec IS RECORD (
   lot_batch_no      VARCHAR2(20),
   serial_no         VARCHAR2(50),
   eng_chg_level     VARCHAR2(6),
   waiv_dev_rej_no   VARCHAR2(15),
   expiration_date   DATE,
   qty_shipped       NUMBER,
   handling_unit_id  NUMBER,
   activity_seq      NUMBER);

TYPE Reservation_Tab IS TABLE OF Reservation_Rec INDEX BY PLS_INTEGER;

TYPE Warehouse_Info_Tab IS TABLE OF Warehouse_Info_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Receiver_Site___ (
   receiver_id_         IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2) RETURN VARCHAR2
IS
   receiver_site_    VARCHAR2(20);
   warehouse_rec_    Warehouse_API.Public_Rec;   
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE)THEN 
      receiver_site_ := receiver_id_;
   ELSIF (receiver_type_db_ =  Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE)THEN  
      warehouse_rec_     := Warehouse_API.Get(receiver_id_);
      receiver_site_     := warehouse_rec_.contract;
   END IF;
   RETURN receiver_site_;
END Get_Receiver_Site___;

-- Check that all of the Handling Units on the order / shipment is available for Undo Delivery and not used somewhere else in the system.
PROCEDURE Check_Undo_Handling_Units___ (
   shipment_id_        IN NUMBER )
IS
   CURSOR get_handl_unit_shipment IS
      SELECT DISTINCT handling_unit_id
      FROM   SHIPMENT_LINE_HANDL_UNIT
      WHERE  shipment_id = shipment_id_;
      
   top_handling_unit_id_    NUMBER;
   handling_unit_tab_       Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   -- When using shipment we look at the SHIPMENT_LINE_HANDL_UNIT_TAB to get all of the Handling Units with packing.
   IF (NVL(shipment_id_, 0) != 0) THEN
      OPEN get_handl_unit_shipment;
      FETCH get_handl_unit_shipment BULK COLLECT INTO handling_unit_tab_;
      CLOSE get_handl_unit_shipment;
   END IF;
   
   IF (handling_unit_tab_.COUNT > 0) THEN
      -- In order to be able to undo reservations in handling units we need to check
      -- that the handling units are not in use somewhere else.
      FOR i IN handling_unit_tab_.FIRST .. handling_unit_tab_.LAST LOOP
         top_handling_unit_id_ := Get_Top_Avail_Handl_Unit___(handling_unit_tab_(i).handling_unit_id);
         IF (top_handling_unit_id_ IS NOT NULL) THEN
            -- We need to disconnect the top "unused" handling unit from it's parent if there is one.
            IF (Handling_Unit_API.Get_Parent_Handling_Unit_Id(top_handling_unit_id_) IS NOT NULL) THEN
               Handling_Unit_API.Modify_Parent_Handling_Unit_Id(top_handling_unit_id_, NULL);
            END IF;
         ELSE    
            Error_SYS.Record_General(lu_name_, 'HANDLUNITINUSE: The handling unit :P1 is in use. Unpack and/or remove its connections to undo the delivery.', handling_unit_tab_(i).handling_unit_id);
         END IF;
      END LOOP;
   END IF;
END Check_Undo_Handling_Units___;

FUNCTION Get_Top_Avail_Handl_Unit___ (
   handling_unit_id_    IN NUMBER ) RETURN NUMBER
IS
   current_handling_unit_id_     NUMBER;
   top_avail_handling_unit_id_   NUMBER;
BEGIN
   current_handling_unit_id_ := handling_unit_id_;
   
   -- Go through the structure of handling_unit_id_ in order to find the 
   -- topmost empty and "unused" handling unit.
   WHILE (current_handling_unit_id_ IS NOT NULL) LOOP
      IF (Handling_Unit_API.Has_Quantity_In_Stock(current_handling_unit_id_) = 'TRUE' OR
            Handling_Unit_API.Get_Shipment_Id(current_handling_unit_id_) IS NOT NULL  OR
            Handling_Unit_API.Get_Source_Ref_Type(current_handling_unit_id_) IS NOT NULL) THEN
         EXIT;
      END IF;
      
      top_avail_handling_unit_id_ := current_handling_unit_id_;
      current_handling_unit_id_ := Handling_Unit_API.Get_Parent_Handling_Unit_Id(current_handling_unit_id_);
   END LOOP;
   
   RETURN top_avail_handling_unit_id_;
END Get_Top_Avail_Handl_Unit___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


----------------------- MISC SHIPMENT PRIVATE METHODS -----------------------

@UncheckedAccess
FUNCTION Get_Source_Project_Id__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Project_Id(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END  
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         RETURN Activity_API.Get_Project_Id(Planning_Item_API.Get_Activity_Seq(source_ref1_, source_ref2_, source_ref3_));          
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Project_Id(source_ref1_, source_ref2_);          
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Project_Id(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Get_Source_Project_Id__;

@UncheckedAccess
FUNCTION Get_Source_Activity_Seq__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Activity_Seq(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END  
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         RETURN Planning_Item_API.Get_Activity_Seq(source_ref1_, source_ref2_, source_ref3_);          
      $ELSE
         NULL;
      $END 
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Activity_Seq(source_ref1_, source_ref2_);          
      $ELSE
         NULL;
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Activity_Seq(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Get_Source_Activity_Seq__;

PROCEDURE Get_Source_Info_At_Reserve__ (
   project_id_          OUT VARCHAR2,
   activity_seq_        OUT NUMBER,
   include_standard_    OUT VARCHAR2,
   include_project_     OUT VARCHAR2,
   part_ownership_db_   OUT VARCHAR2,
   owning_customer_no_  OUT VARCHAR2,
   owning_vendor_no_    OUT VARCHAR2,
   configuration_id_    OUT VARCHAR2,
   condition_code_      OUT VARCHAR2,
   picking_leadtime_    OUT NUMBER,
   atp_rowid_           OUT VARCHAR2,
   source_ref1_         IN  VARCHAR2,
   source_ref2_         IN  VARCHAR2,
   source_ref3_         IN  VARCHAR2,
   source_ref4_         IN  VARCHAR2,   
   source_ref_type_db_  IN  VARCHAR2 )
IS   
BEGIN
   project_id_          := NULL;
   activity_seq_        := NULL;
   part_ownership_db_   := NULL;
   owning_customer_no_  := NULL;
   owning_vendor_no_    := NULL;
   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Get_Info_At_Reserve(project_id_        ,
                                                      activity_seq_      ,
                                                      include_standard_  ,
                                                      include_project_   ,
                                                      part_ownership_db_ ,
                                                      owning_customer_no_,
                                                      owning_vendor_no_  ,
                                                      configuration_id_  ,
                                                      condition_code_    ,
                                                      picking_leadtime_  ,
                                                      atp_rowid_         ,
                                                      source_ref1_       ,
                                                      source_ref2_       );
      $ELSE
         NULL;
      $END  
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
          Planning_Item_API.Get_Project_Deliverable_Info(project_id_, activity_seq_, part_ownership_db_, owning_customer_no_,
                                                         include_standard_, include_project_, source_ref1_, source_ref2_, source_ref3_);        
      $ELSE
         NULL;
      $END        
   END IF;   
END Get_Source_Info_At_Reserve__;

@UncheckedAccess
FUNCTION Get_Line_Planned_Del_Date__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN DATE
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Planned_Delivery_Date(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END  
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         RETURN Planning_Shipment_API.Get_Planned_Delivery_Date(source_ref1_, source_ref2_, source_ref3_);          
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Planned_Delivery_Date(to_number(source_ref1_), to_number(source_ref2_));          
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Return_Shipment_Connection_API.Get_Planned_Delivery_Date(source_ref1_, source_ref2_, source_ref3_, to_number(source_ref4_), 
                                                                        Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_));          
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Get_Line_Planned_Del_Date__;


@UncheckedAccess
FUNCTION Get_Line_Planned_Ship_Date__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN DATE
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Planned_Ship_Date(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END  
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         RETURN Planning_Shipment_API.Get_Planned_Ship_Date(source_ref1_, source_ref2_, source_ref3_);          
      $ELSE
         NULL;
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Planned_Ship_Date(to_number(source_ref1_), to_number(source_ref2_));          
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Return_Shipment_Connection_API.Get_Planned_Ship_Date(source_ref1_, source_ref2_, source_ref3_, to_number(source_ref4_),
                                                                     Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_));          
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Get_Line_Planned_Ship_Date__;


@UncheckedAccess
FUNCTION Get_Line_Planned_Ship_Period__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Planned_Ship_Period(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END  
   END IF;
   RETURN NULL;       
END Get_Line_Planned_Ship_Period__;


@UncheckedAccess
FUNCTION Get_Line_Planned_Due_Date__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,   
   source_ref_type_db_ IN VARCHAR2) RETURN DATE
IS   
BEGIN   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Planned_Due_Date(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Planned_Due_Date(to_number(source_ref1_), to_number(source_ref2_));          
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Return_Shipment_Connection_API.Get_Planned_Due_Date(source_ref1_, source_ref2_, source_ref3_, to_number(source_ref4_),
                                                                     Logistics_Source_Ref_Type_API.Decode(source_ref_type_db_));          
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;
END Get_Line_Planned_Due_Date__;


@UncheckedAccess
FUNCTION Get_Connectable_Source_Qty__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Connectable_Sales_Qty(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Shipment_Connectable_Qty(to_number(source_ref1_), to_number(source_ref2_));          
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Return_API.Get_Ship_Connectable_Src_Qty(source_ref1_, source_ref2_, source_ref3_, NULL, to_number(source_ref4_));
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Get_Connectable_Source_Qty__;


@UncheckedAccess
FUNCTION Get_Receiver_Part_No__ (
   shipment_id_        IN NUMBER,
   shipment_line_no_   IN NUMBER, 
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS  
   receiver_part_no_   VARCHAR2(45);
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         receiver_part_no_ := Customer_Order_Line_API.Get_Customer_Part_No(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Vendor_Part_No(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      $ELSE
         NULL;
      $END
   ELSE
      receiver_part_no_ := Shipment_Line_API.Get_Source_Part_No(shipment_id_, shipment_line_no_);
   END IF;
   RETURN receiver_part_no_;       
END Get_Receiver_Part_No__;


@UncheckedAccess
FUNCTION Get_Condition_Code__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,   
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS   
BEGIN   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Condition_Code(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END  
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Condition_Code(source_ref1_, source_ref2_);
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Condition_Code(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      $ELSE
         NULL;
      $END      
   END IF;
   RETURN NULL;
END Get_Condition_Code__;


@UncheckedAccess
FUNCTION Get_Prepayment_Amount__ (
   source_ref1_        IN VARCHAR2,    
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS   
BEGIN   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_API.Get_Proposed_Prepayment_Amount(source_ref1_);
      $ELSE
         NULL;
      $END  
   END IF;
   RETURN NULL;
END Get_Prepayment_Amount__;



@UncheckedAccess
FUNCTION Get_Owner_For_Part_Ownership__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   part_ownership_db_  IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Owner_For_Part_Ownership(source_ref1_, source_ref2_, source_ref3_, source_ref4_, part_ownership_db_);          
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Owner_For_Part_Ownership(source_ref1_, source_ref2_);          
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Owner(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Get_Owner_For_Part_Ownership__;


@UncheckedAccess
FUNCTION Is_Uom_Group_Connected__ (
   contract_            IN VARCHAR2,
   inventory_part_no_   IN VARCHAR2,    
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Is_Uom_Group_Connected(contract_, inventory_part_no_);          
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Is_Uom_Group_Connected__;


@UncheckedAccess
FUNCTION Get_Classification_Standard__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Classification_Standard(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END   
   END IF;
   RETURN NULL;       
END Get_Classification_Standard__;


@UncheckedAccess
FUNCTION Get_Classification_Part_No__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Classification_Part_No(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END   
   END IF;
   RETURN NULL;       
END Get_Classification_Part_No__;


@UncheckedAccess
FUNCTION Get_Classification_Unit_Meas__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Classification_Unit_Meas(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END   
   END IF;
   RETURN NULL;       
END Get_Classification_Unit_Meas__;


PROCEDURE Validate_Struc_Ownership__ (
   info_                OUT VARCHAR2,
   source_ref1_         IN  VARCHAR2,
   inventory_part_no_   IN  VARCHAR2,
   serial_no_           IN  VARCHAR2,
   lot_batch_no_        IN  VARCHAR2,
   part_ownership_      IN  VARCHAR2,
   owner_               IN  VARCHAR2,   
   source_ref_type_db_  IN  VARCHAR2)
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Flow_API.Validate_Struc_Ownership(info_, source_ref1_, inventory_part_no_, serial_no_, lot_batch_no_, part_ownership_, owner_);          
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END  
   END IF;    
END Validate_Struc_Ownership__;


@UncheckedAccess
FUNCTION Get_Available_Qty__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   part_no_            IN VARCHAR2, 
   contract_           IN VARCHAR2 ) RETURN NUMBER
IS 
   dummy_atp_rowid_        VARCHAR2(2000);
   dummy_picking_leadtime_ NUMBER;
   include_standard_       VARCHAR2(5);
   include_project_        VARCHAR2(5);
   source_project_id_      VARCHAR2(10);
   source_activity_seq_    NUMBER;
   configuration_id_       VARCHAR2(50);
   condition_code_         VARCHAR2(10); 
   part_ownership_db_      VARCHAR2(20);   
   location_type4_db_      VARCHAR2(20);
   ownership_type2_db_     VARCHAR2(200):= NULL;
   available_qty_          NUMBER:=0;
   owning_customer_no_     VARCHAR2(20);
   owning_vendor_no_       VARCHAR2(20);
   warehouse_info_rec_     Warehouse_Info_Rec;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         available_qty_ :=  Reserve_Customer_Order_API.Get_Available_Qty(source_ref1_, source_ref2_,
                                                                         source_ref3_, source_ref4_, Fnd_Boolean_API.DB_TRUE);          
      $ELSE
         NULL;
      $END  
   ELSE
      Get_Source_Info_At_Reserve__(source_project_id_, 
                                   source_activity_seq_, 
                                   include_standard_,
                                   include_project_,
                                   part_ownership_db_,
                                   owning_customer_no_,
                                   owning_vendor_no_,
                                   configuration_id_,
                                   condition_code_,
                                   dummy_picking_leadtime_,
                                   dummy_atp_rowid_,
                                   source_ref1_, 
                                   source_ref2_, 
                                   source_ref3_, 
                                   source_ref4_,                                                             
                                   source_ref_type_db_);
      
      IF (part_ownership_db_ = 'COMPANY OWNED') THEN
         location_type4_db_  := 'SHIPMENT';
         ownership_type2_db_ := 'CONSIGNMENT';
      END IF;
      
      warehouse_info_rec_ := Get_Warehouse_Info(shipment_id_        => 0,
                                                source_ref1_        => source_ref1_, 
                                                source_ref_type_db_ => source_ref_type_db_);

      available_qty_ := Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_                     => contract_,
                                                                           part_no_                      => part_no_,
                                                                           configuration_id_             => configuration_id_,
                                                                           qty_type_                     => 'AVAILABLE',
                                                                           expiration_control_           => 'NOT EXPIRED',
                                                                           supply_control_db_            => 'NETTABLE',
                                                                           ownership_type1_db_           => part_ownership_db_,
                                                                           ownership_type2_db_           => ownership_type2_db_,
                                                                           owning_customer_no_           => NULL,
                                                                           owning_vendor_no_             => NULL,
                                                                           location_type1_db_            => 'PICKING',
                                                                           location_type2_db_            => 'F',
                                                                           location_type3_db_            => 'MANUFACTURING',
                                                                           location_type4_db_            => location_type4_db_,
                                                                           include_standard_             => include_standard_,
                                                                           include_project_              => include_project_,
                                                                           project_id_                   => source_project_id_,
                                                                           condition_code_               => condition_code_,
                                                                           warehouse_id_                 => warehouse_info_rec_.warehouse_id,
                                                                           ignore_this_avail_control_id_ => warehouse_info_rec_.availability_control_id);  
                                                                           
      available_qty_ := Inventory_Part_API.Get_Site_Converted_Qty(contract_, part_no_, available_qty_, contract_,'REMOVE');                                                                     

   END IF;
   RETURN available_qty_;       
END Get_Available_Qty__;


----------------------- RESERVATION SPECIFIC PRIVATE METHODS ----------------

-- Get_Manual_Reserv_Allowed__
--   This function will use to check whether manual reservation is allowed to do.
--   If the source doesn't have such checks then should return TRUE.
@UncheckedAccess
FUNCTION Get_Manual_Reserv_Allowed__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         DECLARE
            objstate_  VARCHAR2(20);
         BEGIN
            objstate_ := Customer_Order_Line_API.Get_ObjState(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
            IF(objstate_ NOT IN ('Delivered', 'Invoiced', 'Cancelled')) THEN
               RETURN Fnd_Boolean_API.DB_TRUE;   
            END IF;
         END;
      $ELSE
         NULL;
      $END    
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN    
      RETURN Fnd_Boolean_API.DB_TRUE;
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN    
      $IF Component_Shipod_SYS.INSTALLED $THEN
         DECLARE
            shipment_ord_line_rec_    Shipment_Order_Line_API.Public_Rec;
         BEGIN
            shipment_ord_line_rec_ := Shipment_Order_Line_API.Get(source_ref1_, source_ref2_);
            IF((shipment_ord_line_rec_.rowstate NOT IN ('Closed', 'Cancelled')) AND 
              (NVL(shipment_ord_line_rec_.demand_code, string_null_) != Order_Supply_Type_API.DB_PURCHASE_RECEIPT)) THEN
               RETURN Fnd_Boolean_API.DB_TRUE;   
            END IF;
         END;
      $ELSE
         NULL;
      $END    
   END IF;
   RETURN Fnd_Boolean_API.DB_FALSE;       
END Get_Manual_Reserv_Allowed__;


-- Get_Reserv_Input_Unit_Meas__
--   If the source uses semi centralized reservation then this procedure is not needed. 
@UncheckedAccess
FUNCTION Get_Reserv_Input_Unit_Meas__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   inventory_part_no_  IN VARCHAR2,   
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN  Customer_Order_Reservation_API.Get_Input_Unit_Meas(source_ref1_, 
                                                                    source_ref2_, 
                                                                    source_ref3_, 
                                                                    source_ref4_,
                                                                    contract_, 
                                                                    inventory_part_no_,                                                                                  
                                                                    location_no_, 
                                                                    lot_batch_no_, 
                                                                    serial_no_,
                                                                    eng_chg_level_, 
                                                                    waiv_dev_rej_no_, 
                                                                    activity_seq_, 
                                                                    handling_unit_id_,
                                                                    configuration_id_,
                                                                    pick_list_no_,
                                                                    shipment_id_);
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN NULL;
END Get_Reserv_Input_Unit_Meas__;


-- Get_Reserv_Input_Qty__
--   If the source uses semi centralized reservation then this procedure is not needed. 
@UncheckedAccess
FUNCTION Get_Reserv_Input_Qty__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   inventory_part_no_  IN VARCHAR2,   
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS  
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN  Customer_Order_Reservation_API.Get_Input_Qty(source_ref1_, 
                                                              source_ref2_, 
                                                              source_ref3_, 
                                                              source_ref4_,
                                                              contract_, 
                                                              inventory_part_no_,                                                                                  
                                                              location_no_, 
                                                              lot_batch_no_, 
                                                              serial_no_,
                                                              eng_chg_level_, 
                                                              waiv_dev_rej_no_, 
                                                              activity_seq_, 
                                                              handling_unit_id_,
                                                              configuration_id_,
                                                              pick_list_no_,
                                                              shipment_id_);
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN NULL;
END Get_Reserv_Input_Qty__;


-- Get_Reserv_Input_Conv_Factor__
--   If the source uses semi centralized reservation then this procedure is not needed.
@UncheckedAccess
FUNCTION Get_Reserv_Input_Conv_Factor__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   inventory_part_no_  IN VARCHAR2,   
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS  
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN  Customer_Order_Reservation_API.Get_Input_Conv_Factor(source_ref1_, 
                                                                      source_ref2_, 
                                                                      source_ref3_, 
                                                                      source_ref4_,
                                                                      contract_, 
                                                                      inventory_part_no_,                                                                                  
                                                                      location_no_, 
                                                                      lot_batch_no_, 
                                                                      serial_no_,
                                                                      eng_chg_level_, 
                                                                      waiv_dev_rej_no_, 
                                                                      activity_seq_, 
                                                                      handling_unit_id_,
                                                                      configuration_id_,
                                                                      pick_list_no_,
                                                                      shipment_id_);
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN NULL;
END Get_Reserv_Input_Conv_Factor__;


-- Get_Reserv_Input_Var_Values__
--   If the source uses semi centralized reservation then this procedure is not needed.
@UncheckedAccess
FUNCTION Get_Reserv_Input_Var_Values__ (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   inventory_part_no_  IN VARCHAR2,   
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN VARCHAR2,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN  Customer_Order_Reservation_API.Get_Input_Variable_Values(source_ref1_, 
                                                                          source_ref2_, 
                                                                          source_ref3_, 
                                                                          source_ref4_,
                                                                          contract_, 
                                                                          inventory_part_no_,                                                                                  
                                                                          location_no_, 
                                                                          lot_batch_no_, 
                                                                          serial_no_,
                                                                          eng_chg_level_, 
                                                                          waiv_dev_rej_no_, 
                                                                          activity_seq_, 
                                                                          handling_unit_id_,
                                                                          configuration_id_,
                                                                          pick_list_no_,
                                                                          shipment_id_);
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN NULL;
END Get_Reserv_Input_Var_Values__;


----------------------- PICKING SPECIFIC PRIVATE METHODS --------------------


@UncheckedAccess
FUNCTION Reserved_As_Picked_Allowed__ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   shipment_id_         IN NUMBER,
   incl_ship_connected_ IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS    
   reserved_as_picked_allowed_   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         reserved_as_picked_allowed_ := Pick_Customer_Order_API.Reserved_As_Picked_Allowed__(source_ref1_, source_ref2_, source_ref3_, source_ref4_, shipment_id_, incl_ship_connected_);          
      $ELSE
         NULL;
      $END  
   ELSIF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
      IF (NVL(shipment_id_, 0) != 0) THEN
         reserved_as_picked_allowed_ := Fnd_Boolean_API.DB_TRUE;      
      END IF;
   END IF;
   RETURN reserved_as_picked_allowed_;       
END Reserved_As_Picked_Allowed__;


PROCEDURE Report_Reserved_As_Picked__ (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   location_no_         IN VARCHAR2,
   shipment_id_         IN NUMBER,   
   source_ref_type_db_  IN VARCHAR2)
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Pick_Customer_Order_API.Report_Reserved_As_Picked__(source_ref1_, source_ref2_, source_ref3_, source_ref4_, location_no_, shipment_id_);          
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END  
   END IF;    
END Report_Reserved_As_Picked__;


PROCEDURE Check_All_License_Connected__ (
   display_info_        IN OUT NUMBER,
   source_ref1_         IN     VARCHAR2,
   source_ref2_         IN     VARCHAR2,
   source_ref3_         IN     VARCHAR2,
   source_ref4_         IN     VARCHAR2,      
   source_ref_type_db_  IN     VARCHAR2)
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Pick_Customer_Order_API.Check_All_License_Connected(display_info_, source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END  
   END IF;    
END Check_All_License_Connected__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


----------------------- MISC SHIMPENT PUBLIC METHODS ------------------------

-- Get
-- Handles the public Get of Source header.
-- This will be similar to when you call for an example Customer_Order_API.Get().
-- Add the neccessary Get method for relevant sources inside this and handle them in following generic way.
@UncheckedAccess
FUNCTION Get (
   source_ref1_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Public_Rec
IS      
   temp_    Public_Rec;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         DECLARE 
            order_rec_    Customer_Order_API.Public_Rec;
         BEGIN
            order_rec_                    := Customer_Order_API.Get(source_ref1_);
            temp_.source_ref1             := source_ref1_;            
            temp_.language_code           := order_rec_.language_code;
            temp_.use_price_incl_tax      := order_rec_.use_price_incl_tax;
            temp_.internal_ref            := order_rec_.internal_ref;
            temp_.cust_ref                := order_rec_.cust_ref;
            temp_.print_control_code      := order_rec_.print_control_code;
            temp_.customs_value_currency  := order_rec_.customs_value_currency; 
            temp_.internal_po_no          := order_rec_.internal_po_no;
            temp_.label_note              := order_rec_.label_note;
            temp_.internal_po_label_note  := order_rec_.internal_po_label_note;
            temp_.case_id                 := order_rec_.case_id;
            temp_.receiver_po_no          := order_rec_.customer_po_no;
         END;
      $ELSE
         NULL;
      $END  
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN 
         DECLARE 
            order_rec_    Shipment_Order_API.Public_Rec;
         BEGIN
            order_rec_                    := Shipment_Order_API.Get(source_ref1_);
            temp_.source_ref1             := source_ref1_;                    
            temp_.sender_id               := order_rec_.sender_id;
            temp_.sender_type             := order_rec_.sender_type;
         END;
      $ELSE
         NULL;
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         DECLARE 
            order_rec_    Purchase_Order_API.Public_Rec;
         BEGIN
            order_rec_           := Purchase_Order_API.Get(source_ref1_);
            temp_.language_code  := order_rec_.language_code;
            temp_.label_note     := order_rec_.label_note;
            temp_.receiver_po_no := order_rec_.order_no;
            temp_.case_id        := order_rec_.case_id;
            temp_.cust_ref       := NVL(order_rec_.contact, Supplier_Address_API.Get_Contact(order_rec_.vendor_no, order_rec_.addr_no));
         END;
      $ELSE
         NULL;
      $END
   END IF;
   RETURN temp_;       
END Get;

-- Get_Line
-- Handles the public Get method of Source Line LU.
-- This will be similar to when you call for an example Customer_Order_Line_API.Get().
-- Add the neccessary Get method for relevant sources inside this and handle them in following generic way.
@UncheckedAccess
FUNCTION Get_Line (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   sender_type_db_     IN VARCHAR2 DEFAULT NULL,
   sender_id_          IN VARCHAR2 DEFAULT NULL) RETURN Public_Line_Rec
IS      
   temp_    Public_Line_Rec;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         DECLARE 
            order_line_rec_    Customer_Order_Line_API.Public_Rec;
         BEGIN
            order_line_rec_                      := Customer_Order_Line_API.Get(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
            temp_.source_ref1                    := order_line_rec_.order_no;
            temp_.source_ref2                    := order_line_rec_.line_no;
            temp_.source_ref3                    := order_line_rec_.rel_no;
            temp_.source_ref4                    := order_line_rec_.line_item_no;
            temp_.receiver_id                    := order_line_rec_.deliver_to_customer_no;
            temp_.receiver_type                  := Sender_Receiver_Type_API.DB_CUSTOMER;
            temp_.sender_type                    := Sender_Receiver_Type_API.DB_SITE;
            temp_.sender_id                      := order_line_rec_.contract;
            temp_.sender_addr_id                 := Site_API.Get_Delivery_Address(order_line_rec_.contract);
            temp_.receiver_addr_id               := order_line_rec_.ship_addr_no;
            temp_.receiver_part_no               := order_line_rec_.customer_part_no;
            temp_.ship_via_code                  := order_line_rec_.ship_via_code;         
            temp_.contract                       := order_line_rec_.contract;
            temp_.delivery_terms                 := order_line_rec_.delivery_terms;
            temp_.del_terms_location             := order_line_rec_.del_terms_location;
            temp_.forward_agent_id               := order_line_rec_.forward_agent_id;
            temp_.shipment_type                  := order_line_rec_.shipment_type;
            temp_.packing_instruction_id         := order_line_rec_.packing_instruction_id;
            temp_.addr_flag                      := order_line_rec_.addr_flag;
            temp_.location_no                    := order_line_rec_.location_no;               
            temp_.dock_code                      := order_line_rec_.dock_code;                           
            temp_.sub_dock_code                  := order_line_rec_.sub_dock_code;                
            temp_.route_id                       := order_line_rec_.route_id;  
            temp_.ref_id                         := order_line_rec_.ref_id;             
            temp_.planned_ship_date              := order_line_rec_.planned_ship_date; 
            temp_.planned_delivery_date          := order_line_rec_.planned_delivery_date;
            temp_.planned_due_date               := order_line_rec_.planned_due_date;        
            temp_.freight_map_id                 := order_line_rec_.freight_map_id;
            temp_.zone_id                        := order_line_rec_.zone_id;
            temp_.demand_code                    := order_line_rec_.demand_code; 
            temp_.real_ship_date                 := order_line_rec_.real_ship_date;
            temp_.receiver_uom                   := order_line_rec_.customer_part_unit_meas;
            temp_.receiver_qty                   := order_line_rec_.customer_part_buy_qty;
            temp_.supply_code                    := order_line_rec_.supply_code;
            temp_.rowstate                       := order_line_rec_.rowstate;
            temp_.receiver_part_conv_factor      := order_line_rec_.customer_part_conv_factor;
            temp_.receiver_part_invert_conv_fact := order_line_rec_.cust_part_invert_conv_fact;
            temp_.qty_shipdiff                   := order_line_rec_.qty_shipdiff;
            temp_.source_qty                     := order_line_rec_.buy_qty_due;
            temp_.source_inventory_qty           := order_line_rec_.revised_qty_due;
            temp_.open_shipment_qty              := order_line_rec_.open_shipment_qty;
            temp_.source_qty_to_ship             := order_line_rec_.qty_to_ship;
            temp_.source_qty_shipped             := order_line_rec_.qty_shipped;
            temp_.classification_standard        := order_line_rec_.classification_standard;      
            temp_.classification_part_no         := order_line_rec_.classification_part_no;          
            temp_.classification_unit_meas       := order_line_rec_.classification_unit_meas;             
            temp_.wanted_delivery_date           := order_line_rec_.wanted_delivery_date;      
            temp_.input_unit_meas                := order_line_rec_.input_unit_meas;      
            temp_.input_qty                      := order_line_rec_.input_qty; 
            temp_.customs_value                  := order_line_rec_.customs_value; 
            temp_.note_id                        := order_line_rec_.note_id; 
            temp_.delivery_sequence              := order_line_rec_.delivery_sequence;
            temp_.configuration_id               := order_line_rec_.configuration_id;
         END;
      $ELSE
         NULL;
      $END   
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN          
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         DECLARE 
            planning_shipment_rec_    Delivery_Interface_Shpmnt_API.planning_shipment_rec;
         BEGIN
            planning_shipment_rec_               := Delivery_Interface_Shpmnt_API.Get_Planning_Shipment_Details(source_ref1_, source_ref2_, source_ref3_);
            temp_.source_ref1                    := planning_shipment_rec_.item_no;
            temp_.source_ref2                    := planning_shipment_rec_.item_revision;
            temp_.source_ref3                    := planning_shipment_rec_.planning_no;
            temp_.source_ref4                    := NULL;
            temp_.receiver_id                    := planning_shipment_rec_.receiver_id;
            temp_.receiver_type                  := Sender_Receiver_Type_API.DB_CUSTOMER;
            temp_.sender_type                    := Sender_Receiver_Type_API.DB_SITE;
            temp_.sender_id                      := planning_shipment_rec_.contract;
            temp_.contract                       := planning_shipment_rec_.contract;
            temp_.shipment_type                  := planning_shipment_rec_.shipment_type;                            
            temp_.source_qty                     := planning_shipment_rec_.source_qty;    
            temp_.open_shipment_qty              := planning_shipment_rec_.connected_shipment_qty;
            temp_.planned_ship_date              := planning_shipment_rec_.planned_ship_date;                
            temp_.planned_delivery_date          := planning_shipment_rec_.planned_delivery_date; 
            temp_.sender_addr_id                 := Site_API.Get_Delivery_Address(planning_shipment_rec_.contract);
            temp_.receiver_addr_id               := planning_shipment_rec_.receiver_address_id;                                                                    
            temp_.forward_agent_id               := planning_shipment_rec_.forward_agent_id;               
            temp_.ship_via_code                  := planning_shipment_rec_.ship_via_code;                
            temp_.delivery_terms                 := planning_shipment_rec_.delivery_terms;                                                        
            temp_.dock_code                      := planning_shipment_rec_.dock_code;               
            temp_.sub_dock_code                  := planning_shipment_rec_.sub_dock_code;                            
            temp_.location_no                    := planning_shipment_rec_.location_no;     
            temp_.ref_id                         := planning_shipment_rec_.reference_id;     
            temp_.route_id                       := planning_shipment_rec_.route_id;     
            temp_.addr_flag                      := 'N';
            temp_.del_terms_location             := planning_shipment_rec_.del_terms_location;
            temp_.source_qty_shipped             := Shipment_Line_API.Get_Sum_Qty_Shipped(source_ref1_, source_ref2_, source_ref3_, NULL, source_ref_type_db_);            
         END;
      $ELSE
         NULL;
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         DECLARE 
            shipment_ord_line_rec_    Shipment_Order_Line_API.Public_Rec;
            shipment_order_rec_       Shipment_Order_API.Public_Rec;
         BEGIN
            shipment_order_rec_           := Shipment_Order_API.Get(source_ref1_);
            shipment_ord_line_rec_        := Shipment_Order_Line_API.Get(source_ref1_, source_ref2_);
                            
            temp_.source_ref1                    := shipment_ord_line_rec_.shipment_order_id;
            temp_.source_ref2                    := shipment_ord_line_rec_.line_no;
            temp_.source_ref3                    := NULL;
            temp_.source_ref4                    := NULL;
            temp_.receiver_id                    := shipment_order_rec_.receiver_id;
            temp_.receiver_type                  := shipment_order_rec_.receiver_type;
            temp_.sender_type                    := shipment_order_rec_.sender_type;
            temp_.sender_id                      := shipment_order_rec_.sender_id;
            temp_.contract                       := shipment_ord_line_rec_.contract;
            temp_.shipment_type                  := shipment_order_rec_.shipment_type;                            
            temp_.source_qty                     := shipment_ord_line_rec_.qty_to_ship;  
            temp_.source_qty_shipped             := shipment_ord_line_rec_.qty_delivered;
            temp_.open_shipment_qty              := Shipment_Line_API.Get_Sum_Open_Shipment_qty(source_ref1_, source_ref2_, NULL, NULL, Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER);
            IF (shipment_ord_line_rec_.inventory_part = Fnd_Boolean_API.DB_FALSE) THEN
               temp_.source_qty_to_ship          := shipment_ord_line_rec_.qty_to_ship;
               temp_.source_inventory_qty        := shipment_ord_line_rec_.qty_to_ship;
            END IF;
            temp_.planned_ship_date              := shipment_ord_line_rec_.planned_ship_date;                
            temp_.planned_delivery_date          := shipment_ord_line_rec_.planned_delivery_date;     
            temp_.sender_addr_id                 := Shipment_Order_API.Get_Sender_Address_Id(source_ref1_);
            temp_.receiver_addr_id               := Shipment_Order_API.Get_Receiver_Address_Id(source_ref1_);     
            temp_.forward_agent_id               := shipment_order_rec_.forward_agent_id;               
            temp_.ship_via_code                  := shipment_order_rec_.ship_via_code;                
            temp_.delivery_terms                 := shipment_order_rec_.delivery_terms;  
            temp_.del_terms_location             := shipment_order_rec_.del_terms_location;
            temp_.dock_code                      := shipment_ord_line_rec_.dock_code;               
            temp_.sub_dock_code                  := shipment_ord_line_rec_.sub_dock_code;                            
            temp_.location_no                    := shipment_ord_line_rec_.location_no;     
            temp_.ref_id                         := shipment_ord_line_rec_.ref_id;     
            temp_.route_id                       := shipment_order_rec_.route_id;     
            temp_.addr_flag                      := 'N';
            temp_.rowstate                       := shipment_ord_line_rec_.rowstate;
            temp_.part_ownership                 := shipment_ord_line_rec_.part_ownership;
            temp_.owner                          := NVL(shipment_ord_line_rec_.owning_customer_no, shipment_ord_line_rec_.owning_vendor_no);
            temp_.owner_name                     := Discom_General_Util_API.Get_Owner_Name(shipment_ord_line_rec_.owning_customer_no, shipment_ord_line_rec_.owning_vendor_no);
         END;
      $ELSE
         NULL;
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         temp_ := Shipment_Rcpt_Return_Util_API.Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, sender_type_db_, sender_id_);
      $ELSE
         NULL;
      $END 
   END IF;
   
   RETURN temp_;       
END Get_Line;


@UncheckedAccess
FUNCTION Get_Addr_Line (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Public_Addr_Line_Rec
IS      
   temp_    Public_Addr_Line_Rec;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         DECLARE 
            order_addr_line_rec_    Cust_Order_Line_Address_API.Co_Line_Addr_Rec;
         BEGIN
            order_addr_line_rec_        := Cust_Order_Line_Address_API.Get_Co_Line_Addr(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
            temp_.receiver_address_name := order_addr_line_rec_.addr_1;
            temp_.receiver_address1     := order_addr_line_rec_.address1;
            temp_.receiver_address2     := order_addr_line_rec_.address2;
            temp_.receiver_address3     := order_addr_line_rec_.address3;
            temp_.receiver_address4     := order_addr_line_rec_.address4;         
            temp_.receiver_address5     := order_addr_line_rec_.address5;
            temp_.receiver_address6     := order_addr_line_rec_.address6;
            temp_.receiver_city         := order_addr_line_rec_.city;
            temp_.receiver_state        := order_addr_line_rec_.state;
            temp_.receiver_zip_code     := order_addr_line_rec_.zip_code;
            temp_.receiver_county       := order_addr_line_rec_.county;
            temp_.receiver_country      := order_addr_line_rec_.country_code;
         END;
      $ELSE
         NULL;
      $END  
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN          
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         DECLARE 
            address_rec_ Customer_Info_Address_API.Public_Rec;   
         BEGIN
            address_rec_ := Delivery_Interface_Shpmnt_API.Get_Delivery_Shipment_Address(source_ref1_, source_ref2_, source_ref3_);
            IF (address_rec_.customer_id IS NOT NULL) THEN
               temp_.receiver_address_name := NVL(address_rec_.name, Customer_Info_API.Get_Name(address_rec_.customer_id));
               temp_.receiver_address1     := address_rec_.address1;
               temp_.receiver_address2     := address_rec_.address2;
               temp_.receiver_address3     := address_rec_.address3;
               temp_.receiver_address4     := address_rec_.address4;         
               temp_.receiver_address5     := address_rec_.address5;
               temp_.receiver_address6     := address_rec_.address6;
               temp_.receiver_city         := address_rec_.city;
               temp_.receiver_state        := address_rec_.state;
               temp_.receiver_zip_code     := address_rec_.zip_code;
               temp_.receiver_county       := address_rec_.county;
               temp_.receiver_country      := address_rec_.country;                                                   
            END IF;
         END;
      $ELSE
         NULL;
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         DECLARE 
            addr_attr_ VARCHAR2(32000);   
         BEGIN
            addr_attr_ := Shipment_Order_API.Fetch_Receiver_Address_Attr(source_ref1_);
            temp_.receiver_address_name := Client_SYS.Get_Item_Value('RECEIVER_ADDRESS_NAME', addr_attr_);
            temp_.receiver_address1     := Client_SYS.Get_Item_Value('RECEIVER_ADDRESS1',     addr_attr_);
            temp_.receiver_address2     := Client_SYS.Get_Item_Value('RECEIVER_ADDRESS2',     addr_attr_);
            temp_.receiver_address3     := Client_SYS.Get_Item_Value('RECEIVER_ADDRESS3',     addr_attr_);
            temp_.receiver_address4     := Client_SYS.Get_Item_Value('RECEIVER_ADDRESS4',     addr_attr_);         
            temp_.receiver_address5     := Client_SYS.Get_Item_Value('RECEIVER_ADDRESS5',     addr_attr_);
            temp_.receiver_address6     := Client_SYS.Get_Item_Value('RECEIVER_ADDRESS6',     addr_attr_);
            temp_.receiver_city         := Client_SYS.Get_Item_Value('RECEIVER_CITY',         addr_attr_);
            temp_.receiver_state        := Client_SYS.Get_Item_Value('RECEIVER_STATE',        addr_attr_);
            temp_.receiver_zip_code     := Client_SYS.Get_Item_Value('RECEIVER_ZIP_CODE',     addr_attr_);
            temp_.receiver_county       := Client_SYS.Get_Item_Value('RECEIVER_COUNTY',       addr_attr_);
            temp_.receiver_country      := Client_SYS.Get_Item_Value('RECEIVER_COUNTRY',      addr_attr_);  
         END;
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Purch_SYS.INSTALLED AND Component_Rceipt_SYS.INSTALLED $THEN
         DECLARE 
            purchase_order_rec_  Purchase_Order_API.Public_Rec;
            receiver_id_         VARCHAR2(50);
            receiver_addr_id_    VARCHAR2(50);
         BEGIN
            purchase_order_rec_  := Purchase_Order_API.Get(source_ref1_); 
            receiver_id_         := purchase_order_rec_.vendor_no;
            receiver_addr_id_    := purchase_order_rec_.addr_no;
            Shipment_Rcpt_Return_Util_API.Get_Receiver_Addr_Info(temp_.receiver_address_name,
                                                                 temp_.receiver_address1,
                                                                 temp_.receiver_address2, 
                                                                 temp_.receiver_address3,
                                                                 temp_.receiver_address4,
                                                                 temp_.receiver_address5,
                                                                 temp_.receiver_address6,
                                                                 temp_.receiver_zip_code, 
                                                                 temp_.receiver_city,
                                                                 temp_.receiver_state,
                                                                 temp_.receiver_county, 
                                                                 temp_.receiver_country,
                                                                 receiver_id_,
                                                                 receiver_addr_id_);
         END;
      $ELSE
         NULL;
      $END
   END IF;
   RETURN temp_;       
END Get_Addr_Line;

PROCEDURE Fetch_Info (
   public_rec_         OUT Public_Rec,
   public_line_rec_    OUT Public_Line_Rec,
   addr_line_rec_      OUT Public_Addr_Line_Rec,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2 )
IS
BEGIN
   public_rec_      := Get(source_ref1_, source_ref_type_db_);
   public_line_rec_ := Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   addr_line_rec_   := Get_Addr_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_); 
END Fetch_Info;

@UncheckedAccess
FUNCTION Get_Route_Id (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   route_id_   VARCHAR2(12);
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN     
      $IF Component_Order_SYS.INSTALLED $THEN
         route_id_:= Customer_Order_Line_API.Get_Route_Id(source_ref1_, source_ref2_, source_ref3_, TO_NUMBER(source_ref4_));   
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         route_id_:= Planning_Shipment_API.Get_Route_Id(source_ref1_, source_ref2_, source_ref3_);
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         route_id_:= Shipment_Order_API.Get_Route_Id(source_ref1_);
      $ELSE
         NULL;
      $END      
   END IF;
   
   RETURN route_id_;       
END Get_Route_Id;


@UncheckedAccess
FUNCTION Get_Forward_Agent_Id (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   forward_agent_id_   VARCHAR2(20);
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN     
      $IF Component_Order_SYS.INSTALLED $THEN
         forward_agent_id_:= Customer_Order_Line_API.Get_Forward_Agent_Id(source_ref1_, source_ref2_, source_ref3_, TO_NUMBER(source_ref4_));   
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         forward_agent_id_:= Planning_Shipment_API.Get_Forward_Agent_Id(source_ref1_, source_ref2_, source_ref3_);
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         forward_agent_id_:= Shipment_Order_API.Get_Forward_Agent_Id(source_ref1_);
      $ELSE
         NULL;
      $END  
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Shipment_Rcpt_Return_Util_API.Get_Forward_Agent_Id(source_ref1_, source_ref2_, source_ref3_, NULL, source_ref_type_db_);
      $ELSE
         NULL;
      $END
   END IF;
   
   RETURN forward_agent_id_;       
END Get_Forward_Agent_Id;


@UncheckedAccess
FUNCTION Get_Exc_Svc_Delnote_Print_Db
   (contract_  IN VARCHAR2) RETURN VARCHAR2
IS   
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      RETURN Company_Order_Info_API.Get_Exc_Svc_Delnote_Print_Db(Company_Site_API.Get_Company(contract_));
   $ELSE  
      NULL;
   $END
   RETURN NULL;
END Get_Exc_Svc_Delnote_Print_Db;


@UncheckedAccess
FUNCTION Get_Label_Note (
   source_ref1_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS  
BEGIN   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
     $IF Component_Order_SYS.INSTALLED $THEN
        RETURN Customer_Order_API.Get_Label_Note(source_ref1_);
     $ELSE
        NULL;
     $END
  ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Label_Note(source_ref1_, source_ref_type_db_);
      $ELSE
        NULL;
      $END
   END IF;
   RETURN NULL;   
END Get_Label_Note;

-----------------------------------------------------------------------------
-------------------- Receiver specific functions ----------------------------
-----------------------------------------------------------------------------

-- Fetch_Source_And_Deliv_Info
-- This will fetch the deilvery attributes and also some source specific attributes.
PROCEDURE Fetch_Source_And_Deliv_Info (
   route_id_                   IN OUT VARCHAR2,
   forward_agent_              IN OUT VARCHAR2,
   shipment_type_              IN OUT VARCHAR2,
   ship_inventory_location_no_ IN OUT VARCHAR2,
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   ship_via_code_              IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   receiver_id_                IN     VARCHAR2,
   receiver_addr_id_           IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,      
   fetch_from_supply_chain_    IN     VARCHAR2,   
   receiver_type_db_           IN     VARCHAR2,
   sender_id_                  IN     VARCHAR2,
   sender_type_db_             IN     VARCHAR2,
   ship_via_code_changed_      IN     VARCHAR2 DEFAULT 'FALSE')
IS   
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Fetch_Freight_And_Deliv_Info( route_id_,
                                                                  forward_agent_,
                                                                  shipment_type_,
                                                                  ship_inventory_location_no_,                                                                  
                                                                  delivery_terms_,
                                                                  del_terms_location_,
                                                                  contract_,
                                                                  receiver_id_,
                                                                  receiver_addr_id_,
                                                                  addr_flag_db_,
                                                                  ship_via_code_,                                                                  
                                                                  fetch_from_supply_chain_,
                                                                  ship_via_code_changed_ );
      $ELSE
         NULL;      
      $END
   ELSIF(receiver_type_db_ IN (Sender_Receiver_Type_API.DB_SITE, Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE)) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Fetch_Ship_Ord_Deliv_Info(route_id_,
                                                            forward_agent_,
                                                            shipment_type_,
                                                            ship_inventory_location_no_,                                                           
                                                            delivery_terms_,
                                                            del_terms_location_,
                                                            ship_via_code_,
                                                            sender_type_db_,
                                                            sender_id_,
                                                            receiver_type_db_,
                                                            receiver_id_);
      $ELSE
         NULL;      
      $END
   ELSIF(receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Fetch_Rcpt_Return_Deliv_Info(route_id_,
                                                                    forward_agent_,
                                                                    shipment_type_,
                                                                    ship_inventory_location_no_,                                                           
                                                                    delivery_terms_,
                                                                    del_terms_location_,
                                                                    ship_via_code_,
                                                                    sender_type_db_,
                                                                    sender_id_,
                                                                    receiver_type_db_,
                                                                    receiver_id_,
                                                                    receiver_addr_id_);
      $ELSE
         NULL;      
      $END      
   END IF;
END Fetch_Source_And_Deliv_Info;


-- Get_Receiver_Information
-- This procedure will be called from the shipment when validating the receiver id
-- For different receiver types, the validations and fetching of default values should be implemented here.
PROCEDURE Get_Receiver_Information (
   attr_                OUT  VARCHAR2,
   receiver_id_         IN   VARCHAR2,
   contract_            IN   VARCHAR2,
   receiver_type_db_    IN   VARCHAR2)
IS    
   receiver_addr_id_          Shipment_Tab.receiver_addr_id%TYPE;
   bill_addr_no_              VARCHAR2(50);
   warehouse_rec_             Warehouse_API.Public_Rec;
   addr_type_                 VARCHAR2(100);
   addr_type_identity_        VARCHAR2(20);
   shipment_uncon_struct_db_  VARCHAR2(5):= 'FALSE';
BEGIN   
   IF(receiver_id_ IS NOT NULL) THEN
      Validate_Receiver_Id(receiver_id_, receiver_type_db_, contract_);
   END IF;
   Client_SYS.Add_To_Attr('LANGUAGE_CODE', Get_Language_Code(receiver_id_,receiver_type_db_), attr_);
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', Get_Forward_Agent_Id(receiver_id_, receiver_type_db_), attr_);
   bill_addr_no_ := Get_Document_Address(receiver_id_, receiver_type_db_);
   Client_SYS.Add_To_Attr('BILL_ADDR_NO', bill_addr_no_, attr_);     
   IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN          
      $IF Component_Order_SYS.INSTALLED $THEN        
         receiver_addr_id_ := Cust_Ord_Customer_API.Get_Delivery_Address(receiver_id_);    
         Client_SYS.Add_To_Attr('RECEIVER_REFERENCE', Cust_Ord_Customer_API.Fetch_Cust_Ref(receiver_id_, bill_addr_no_, 'TRUE'), attr_);  
         shipment_uncon_struct_db_ := Cust_Ord_Customer_Address_API.Get_Shipment_Uncon_Struct_Db(receiver_id_, receiver_addr_id_);           
      $ELSE
         NULL;
      $END
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      receiver_addr_id_ := Site_API.Get_Delivery_Address(receiver_id_); 
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(receiver_id_);  
      Whse_Shipment_Receipt_Info_API.Get_Warehouse_Address(addr_type_, addr_type_identity_, receiver_addr_id_, warehouse_rec_.contract, warehouse_rec_.warehouse_id);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      receiver_addr_id_ :=  Supplier_Info_Address_API.Get_Default_Address(receiver_id_, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DELIVERY)); 
   END IF;
   Client_SYS.Add_To_Attr('RECEIVER_ADDR_ID', receiver_addr_id_ , attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_UNCON_STRUCT_DB', shipment_uncon_struct_db_, attr_);       
END Get_Receiver_Information;

-- Get_Receiver_Address_Info
-- This procedure will be called from the shipment when validating the ship_addr_no
-- For different receiver types, the validations and fetching of default values should be implemented here.
PROCEDURE Get_Receiver_Address_Info (
   attr_             OUT VARCHAR2,
   ship_attr_        IN  VARCHAR2,
   receiver_id_      IN  VARCHAR2,
   receiver_addr_id_ IN  VARCHAR2,
   contract_         IN  VARCHAR2,
   receiver_type_db_ IN  VARCHAR2,
   sender_type_db_   IN  VARCHAR2,
   sender_id_        IN  VARCHAR2)
IS   
   ship_via_code_             Shipment_Tab.ship_via_code%TYPE;
   delivery_terms_            Shipment_Tab.delivery_terms%TYPE;
   del_terms_location_        Shipment_Tab.del_terms_location%TYPE;
   delivery_leadtime_         NUMBER;
   picking_leadtime_          NUMBER;
   ext_transport_calendar_id_ VARCHAR2(10);
   route_id_                  Shipment_Tab.route_id%TYPE;
   zone_id_                   VARCHAR2(15);
   freight_map_id_            VARCHAR2(15);
   forward_agent_id_          Shipment_Tab.forward_agent_id%TYPE;
   shipment_type_             Shipment_Tab.shipment_type%TYPE;
   ship_invent_loc_no_        Shipment_Tab.ship_inventory_location_no%TYPE;      
   receiver_address1_         VARCHAR2(35);         
   receiver_address2_         VARCHAR2(35);        
   receiver_address3_         VARCHAR2(100);        
   receiver_address4_         VARCHAR2(100);        
   receiver_address5_         VARCHAR2(100);        
   receiver_address6_         VARCHAR2(100);        
   receiver_city_             VARCHAR2(35);        
   receiver_state_            VARCHAR2(35);        
   receiver_zip_code_         VARCHAR2(35);    
   receiver_county_           VARCHAR2(35);      
   receiver_country_          VARCHAR2(2);
   receiver_name_             VARCHAR2(100);
   receiver_country_desc_     VARCHAR2(2000);
BEGIN     
   IF(receiver_id_ IS NOT NULL AND receiver_addr_id_ IS NOT NULL) THEN
      Shipment_API.Receiver_Address_Exist(receiver_id_, receiver_addr_id_, receiver_type_db_);
   END IF; 
   Get_Receiver_Addr_Info( receiver_address1_, 
                           receiver_address2_, 
                           receiver_address3_, 
                           receiver_address4_, 
                           receiver_address5_, 
                           receiver_address6_, 
                           receiver_zip_code_,
                           receiver_city_,
                           receiver_state_,
                           receiver_county_,
                           receiver_country_,
                           receiver_country_desc_,
                           receiver_name_,
                           receiver_id_, 
                           receiver_addr_id_,                                                                             
                           receiver_type_db_);    
   delivery_terms_      := Client_SYS.Get_Item_Value('DELIVERY_TERMS', ship_attr_);
   del_terms_location_  := Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', ship_attr_);
   shipment_type_       := Client_SYS.Get_Item_Value('SHIPMENT_TYPE', ship_attr_);
   ship_invent_loc_no_  := Client_SYS.Get_Item_Value('SHIP_INVENTORY_LOCATION_NO', ship_attr_);        
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS_NAME', receiver_name_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS1', receiver_address1_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS2', receiver_address2_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS3', receiver_address3_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS4', receiver_address4_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS5', receiver_address5_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ADDRESS6', receiver_address6_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_CITY',  receiver_city_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_STATE', receiver_state_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_ZIP_CODE', receiver_zip_code_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_COUNTY', receiver_county_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_COUNTRY', receiver_country_, attr_);
   Client_SYS.Add_To_Attr('RECEIVER_COUNTRY_DESC', receiver_country_desc_, attr_);                        
   IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN      
      $IF Component_Order_SYS.INSTALLED $THEN      
         freight_map_id_      := Client_SYS.Get_Item_Value('FREIGHT_MAP_ID', ship_attr_);
         zone_id_             := Client_SYS.Get_Item_Value('ZONE_ID', ship_attr_);
         Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(ship_via_code_, delivery_terms_, del_terms_location_, freight_map_id_, 
                                                                     zone_id_, delivery_leadtime_, ext_transport_calendar_id_, route_id_, forward_agent_id_,
                                                                     picking_leadtime_, shipment_type_, ship_invent_loc_no_, contract_,
                                                                     receiver_id_, receiver_addr_id_, 'N', NULL, NULL);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE',ship_via_code_, attr_);       
         Client_SYS.Add_To_Attr('DELIVERY_LEAD_TIME', delivery_leadtime_ , attr_);
         Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
         Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
         Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
         Client_SYS.Add_To_Attr('ZONE_ID',zone_id_, attr_);
         Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
         Client_SYS.Add_To_Attr('PICKING_LEAD_TIME', picking_leadtime_, attr_);            
         Client_SYS.Add_To_Attr('SHIPMENT_UNCON_STRUCT_DB', Cust_Ord_Customer_Address_API.Get_Shipment_Uncon_Struct_Db(receiver_id_, receiver_addr_id_ ), attr_);         
      $ELSE
         NULL;
      $END
   ELSIF(receiver_type_db_ IN (Sender_Receiver_Type_API.DB_SITE, Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE)) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Fetch_Ship_Ord_Deliv_Info(route_id_,
                                                            forward_agent_id_,
                                                            shipment_type_,
                                                            ship_invent_loc_no_,                                                           
                                                            delivery_terms_,
                                                            del_terms_location_,
                                                            ship_via_code_,
                                                            sender_type_db_,
                                                            sender_id_,
                                                            receiver_type_db_,
                                                            receiver_id_);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_); 
         Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
         Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
      $ELSE
         NULL;      
      $END
   ELSIF(receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Fetch_Rcpt_Return_Deliv_Info(route_id_,
                                                                    forward_agent_id_,
                                                                    shipment_type_,
                                                                    ship_invent_loc_no_,                                                        
                                                                    delivery_terms_,
                                                                    del_terms_location_,
                                                                    ship_via_code_,
                                                                    sender_type_db_,
                                                                    sender_id_,
                                                                    receiver_type_db_,
                                                                    receiver_id_,
                                                                    receiver_addr_id_);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_); 
         Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
         Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
      $ELSE
         NULL;      
      $END
   END IF;
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', delivery_terms_ , attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);   
   Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, attr_);
   Client_SYS.Add_To_Attr('SHIP_INVENTORY_LOCATION_NO', ship_invent_loc_no_, attr_);   
END Get_Receiver_Address_Info;


PROCEDURE Get_Sender_Address_Info (
   attr_                OUT VARCHAR2,
   sender_id_           IN  VARCHAR2,
   sender_addr_id_      IN  VARCHAR2,
   contract_            IN  VARCHAR2,
   sender_type_db_      IN  VARCHAR2,
   source_ref1_         IN  VARCHAR2 DEFAULT NULL,
   source_ref2_         IN  VARCHAR2 DEFAULT NULL,
   source_ref3_         IN  VARCHAR2 DEFAULT NULL,
   source_ref4_         IN  VARCHAR2 DEFAULT NULL,
   source_ref_type_db_  IN  VARCHAR2 DEFAULT NULL)
IS 
   sender_address1_         VARCHAR2(35);         
   sender_address2_         VARCHAR2(35);        
   sender_address3_         VARCHAR2(100);        
   sender_address4_         VARCHAR2(100);        
   sender_address5_         VARCHAR2(100);        
   sender_address6_         VARCHAR2(100);        
   sender_city_             VARCHAR2(35);        
   sender_state_            VARCHAR2(35);        
   sender_zip_code_         VARCHAR2(35);    
   sender_county_           VARCHAR2(35);      
   sender_country_          VARCHAR2(2);
   sender_name_             VARCHAR2(100);
   sender_reference_        VARCHAR2(100);
   sender_country_desc_     VARCHAR2(2000);
BEGIN
   IF(sender_id_ IS NOT NULL AND sender_addr_id_ IS NOT NULL) THEN
      Shipment_API.Sender_Address_Exist(sender_id_, sender_addr_id_, sender_type_db_);
   END IF; 
   
   Get_Sender_Addr_Info(sender_address1_, 
                        sender_address2_, 
                        sender_address3_, 
                        sender_address4_, 
                        sender_address5_, 
                        sender_address6_, 
                        sender_zip_code_,
                        sender_city_,
                        sender_state_,
                        sender_county_,
                        sender_country_,
                        sender_country_desc_,
                        sender_name_,
                        sender_reference_,
                        sender_id_, 
                        sender_addr_id_,                                                                             
                        sender_type_db_,
                        source_ref1_,
                        source_ref2_,
                        source_ref3_,
                        source_ref4_,
                        source_ref_type_db_); 
                           
   Client_SYS.Add_To_Attr('SENDER_ADDRESS_NAME', sender_name_,         attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS1',     sender_address1_,     attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS2',     sender_address2_,     attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS3',     sender_address3_,     attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS4',     sender_address4_,     attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS5',     sender_address5_,     attr_);
   Client_SYS.Add_To_Attr('SENDER_ADDRESS6',     sender_address6_,     attr_);
   Client_SYS.Add_To_Attr('SENDER_CITY',         sender_city_,         attr_);
   Client_SYS.Add_To_Attr('SENDER_STATE',        sender_state_,        attr_);
   Client_SYS.Add_To_Attr('SENDER_ZIP_CODE',     sender_zip_code_,     attr_);
   Client_SYS.Add_To_Attr('SENDER_COUNTY',       sender_county_,       attr_);
   Client_SYS.Add_To_Attr('SENDER_COUNTRY',      sender_country_,      attr_);
   Client_SYS.Add_To_Attr('SENDER_COUNTRY_DESC', sender_country_desc_, attr_); 
   Client_SYS.Add_To_Attr('SENDER_REFERENCE',    sender_reference_   , attr_); 
END Get_Sender_Address_Info;

@UncheckedAccess
FUNCTION Get_Receiver_Contact_Name (
   receiver_id_            IN VARCHAR2,
   receiver_address_id_    IN VARCHAR2,
   receiver_reference_     IN VARCHAR2,
   receiver_type_db_       IN VARCHAR2)RETURN VARCHAR2
IS         
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
       RETURN Contact_Util_API.Get_Cust_Contact_Name(receiver_id_, receiver_address_id_, receiver_reference_);
   END IF;
   RETURN NULL;       
END Get_Receiver_Contact_Name;

@UncheckedAccess
FUNCTION Get_Receiver_Note_Id (
   receiver_id_         IN VARCHAR2,  
   receiver_type_db_    IN VARCHAR2)RETURN NUMBER
IS         
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Cust_Ord_Customer_API.Get_Note_Id(receiver_id_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN NULL;       
END Get_Receiver_Note_Id;

-- Get_Default_Media_Code
-- This function will return receiver type specific default media code for given media type.
-- Use receiver_type as parameter since this will called from header level.
@UncheckedAccess
FUNCTION Get_Default_Media_Code (
   receiver_id_         IN VARCHAR2,
   message_class_       IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   receiver_site_    VARCHAR2(20);    
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN      
      RETURN Customer_Info_Msg_Setup_API.Get_Default_Media_Code(receiver_id_,message_class_);
   ELSIF (receiver_type_db_ IN (Sender_Receiver_Type_API.DB_SITE, Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE)) THEN
      receiver_site_ := Get_Receiver_Site___(receiver_id_, receiver_type_db_);
      RETURN Company_Msg_Setup_API.Get_Default_Media_Code(Site_API.Get_Company(receiver_site_), message_class_);
   END IF;
   RETURN NULL;
END Get_Default_Media_Code;

@UncheckedAccess
FUNCTION Get_Receiver_Auto_Des_Adv_Send (
   receiver_id_         IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS   
   auto_despatch_adv_send_ VARCHAR2(5);
   contract_               VARCHAR2(20); 
   warehouse_id_           VARCHAR2(15); 

BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (Cust_Ord_Customer_API.Get_Auto_Despatch_Adv_Send(receiver_id_) = 'Y') THEN
            auto_despatch_adv_send_ := Fnd_Boolean_API.DB_TRUE;
         END IF;
      $ELSE
         NULL;      
      $END
   ELSIF (receiver_type_db_ IN (Sender_Receiver_Type_API.DB_SITE, Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE)) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         contract_   := Get_Receiver_Site___(receiver_id_, receiver_type_db_);
         IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
            auto_despatch_adv_send_ := Site_Discom_Info_API.Get_Send_Auto_Dis_Adv_Db(contract_);
         ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
            warehouse_id_ := Warehouse_API.Get_Warehouse_Id_By_Global_Id(receiver_id_);
            auto_despatch_adv_send_ := Whse_Shipment_Receipt_Info_API.Get_Send_Auto_Dis_Adv_Db(contract_, warehouse_id_);
         END IF;
      $ELSE
         NULL;      
      $END
   END IF;
   RETURN NVL(auto_despatch_adv_send_, Fnd_Boolean_API.DB_FALSE);
END Get_Receiver_Auto_Des_Adv_Send;


PROCEDURE Get_Receiver_Addr_Info (
   receiver_address1_      OUT VARCHAR2, 
   receiver_address2_      OUT VARCHAR2,  
   receiver_zip_code_      OUT VARCHAR2, 
   receiver_city_          OUT VARCHAR2, 
   receiver_state_         OUT VARCHAR2, 
   receiver_county_        OUT VARCHAR2, 
   receiver_country_       OUT VARCHAR2, 
   receiver_country_desc_  OUT VARCHAR2,
   receiver_name_          OUT VARCHAR2,
   receiver_id_            IN VARCHAR2, 
   receiver_addr_id_       IN VARCHAR2,   
   receiver_type_db_       IN VARCHAR2 )  
IS  
   dummy_1_  VARCHAR2(200);
   dummy_2_  VARCHAR2(200);
   dummy_3_  VARCHAR2(200);
   dummy_4_  VARCHAR2(200);
BEGIN
   Get_Receiver_Addr_Info(receiver_address1_, receiver_address2_, dummy_1_, dummy_2_, dummy_3_, dummy_4_, receiver_zip_code_, receiver_city_, receiver_state_, receiver_county_, receiver_country_, receiver_country_desc_, receiver_name_, receiver_id_, receiver_addr_id_, receiver_type_db_);
END Get_Receiver_Addr_Info;


PROCEDURE Get_Receiver_Addr_Info (
   receiver_address1_      OUT VARCHAR2, 
   receiver_address2_      OUT VARCHAR2,  
   receiver_address3_      OUT VARCHAR2, 
   receiver_address4_      OUT VARCHAR2,  
   receiver_address5_      OUT VARCHAR2, 
   receiver_address6_      OUT VARCHAR2,  
   receiver_zip_code_      OUT VARCHAR2, 
   receiver_city_          OUT VARCHAR2, 
   receiver_state_         OUT VARCHAR2, 
   receiver_county_        OUT VARCHAR2, 
   receiver_country_       OUT VARCHAR2, 
   receiver_country_desc_  OUT VARCHAR2,
   receiver_name_          OUT VARCHAR2,
   receiver_id_            IN VARCHAR2, 
   receiver_addr_id_       IN VARCHAR2,   
   receiver_type_db_       IN VARCHAR2 )  
IS 
   dummy_1_                      VARCHAR2(200);
   dummy_2_                      VARCHAR2(200);
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN     
      DECLARE 
         receiver_addr_rec_    Customer_Info_Address_API.Public_Rec;
      BEGIN
         receiver_addr_rec_     := Customer_Info_Address_API.Get(receiver_id_, receiver_addr_id_);
         receiver_name_         := receiver_addr_rec_.name;
         receiver_address1_     := receiver_addr_rec_.address1;
         receiver_address2_     := receiver_addr_rec_.address2;         
         receiver_address3_     := receiver_addr_rec_.address3;
         receiver_address4_     := receiver_addr_rec_.address4;         
         receiver_address5_     := receiver_addr_rec_.address5;
         receiver_address6_     := receiver_addr_rec_.address6;         
         receiver_city_         := receiver_addr_rec_.city;
         receiver_state_        := receiver_addr_rec_.state;
         receiver_zip_code_     := receiver_addr_rec_.zip_code;
         receiver_county_       := receiver_addr_rec_.county;
         receiver_country_      := receiver_addr_rec_.country;
      END;
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      DECLARE
         receiver_addr_rec_    Company_Address_API.Public_Rec;
         company_              VARCHAR2(20);
      BEGIN
         company_               := Site_API.Get_Company(receiver_id_);
         receiver_addr_rec_     := Company_Address_API.Get(company_, receiver_addr_id_);
         receiver_name_         := Company_Address_Deliv_Info_API.Get_Address_Name(company_, receiver_addr_id_);
         receiver_address1_     := receiver_addr_rec_.address1;
         receiver_address2_     := receiver_addr_rec_.address2;         
         receiver_address3_     := receiver_addr_rec_.address3;
         receiver_address4_     := receiver_addr_rec_.address4;         
         receiver_address5_     := receiver_addr_rec_.address5;
         receiver_address6_     := receiver_addr_rec_.address6;         
         receiver_city_         := receiver_addr_rec_.city;
         receiver_state_        := receiver_addr_rec_.state;
         receiver_zip_code_     := receiver_addr_rec_.zip_code;
         receiver_county_       := receiver_addr_rec_.county;
         receiver_country_      := receiver_addr_rec_.country;
      END;
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      Whse_Shipment_Receipt_Info_API.Get_Remote_Warehouse_Addr_Info(receiver_name_, receiver_address1_, receiver_address2_, receiver_address3_, receiver_address4_, receiver_address5_, receiver_address6_,
                                     receiver_zip_code_, receiver_city_, receiver_state_, receiver_county_, receiver_country_, dummy_1_, dummy_2_, receiver_id_);   
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Get_Receiver_Addr_Info(receiver_name_,
                                                              receiver_address1_,
                                                              receiver_address2_, 
                                                              receiver_address3_,
                                                              receiver_address4_,
                                                              receiver_address5_,
                                                              receiver_address6_,
                                                              receiver_zip_code_, 
                                                              receiver_city_,
                                                              receiver_state_,
                                                              receiver_county_, 
                                                              receiver_country_,
                                                              receiver_id_,
                                                              receiver_addr_id_);
      $ELSE
         NULL;   
      $END 
   END IF;
   receiver_country_desc_ := Iso_Country_API.Get_Description(receiver_country_);
   IF (receiver_name_ IS NULL) THEN 
      receiver_name_ := Get_Receiver_Name(receiver_id_, receiver_type_db_);
   END IF;
END Get_Receiver_Addr_Info;


PROCEDURE Get_Sender_Addr_Info (
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
   sender_country_desc_  OUT VARCHAR2,
   sender_name_          OUT VARCHAR2,
   sender_reference_     OUT VARCHAR2,
   sender_id_            IN VARCHAR2, 
   sender_addr_id_       IN VARCHAR2,   
   sender_type_db_       IN VARCHAR2,
   source_ref1_          IN VARCHAR2 DEFAULT NULL,
   source_ref2_          IN VARCHAR2 DEFAULT NULL,
   source_ref3_          IN VARCHAR2 DEFAULT NULL,
   source_ref4_          IN VARCHAR2 DEFAULT NULL,
   source_ref_type_db_   IN VARCHAR2 DEFAULT NULL)  
IS 
   company_addr_deliv_info_rec_  Company_Address_Deliv_Info_API.Public_Rec;
   dummy_                        VARCHAR2(200);
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN AND source_ref1_ IS NOT NULL) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Get_Sender_Addr_Info(sender_address1_, sender_address2_, sender_address3_,
                                                            sender_address4_, sender_address5_, sender_address6_,
                                                            sender_zip_code_, sender_city_, sender_state_, sender_county_,
                                                            sender_country_, sender_name_, sender_reference_, sender_id_, sender_addr_id_, sender_type_db_, source_ref1_, source_ref2_, 
                                                            source_ref3_, source_ref4_, source_ref_type_db_); 
      $ELSE
         NULL;   
      $END
   ELSIF (sender_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      DECLARE
         sender_addr_rec_                 Company_Address_API.Public_Rec;        
         company_                         VARCHAR2(20);
      BEGIN
         company_                      := Site_API.Get_Company(sender_id_);
         sender_addr_rec_              := Company_Address_API.Get(company_, sender_addr_id_);
         company_addr_deliv_info_rec_  := Company_Address_Deliv_Info_API.Get(company_, sender_addr_id_);
         sender_name_                  := company_addr_deliv_info_rec_.address_name;
         sender_address1_              := sender_addr_rec_.address1;
         sender_address2_              := sender_addr_rec_.address2;         
         sender_address3_              := sender_addr_rec_.address3;
         sender_address4_              := sender_addr_rec_.address4;         
         sender_address5_              := sender_addr_rec_.address5;
         sender_address6_              := sender_addr_rec_.address6;         
         sender_city_                  := sender_addr_rec_.city;
         sender_state_                 := sender_addr_rec_.state;
         sender_zip_code_              := sender_addr_rec_.zip_code;
         sender_county_                := sender_addr_rec_.county;
         sender_country_               := sender_addr_rec_.country;
         sender_reference_             := company_addr_deliv_info_rec_.contact;
      END;
   ELSIF (sender_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
       Whse_Shipment_Receipt_Info_API.Get_Remote_Warehouse_Addr_Info(sender_name_, sender_address1_, sender_address2_, sender_address3_, sender_address4_, sender_address5_, sender_address6_,
                                      sender_zip_code_, sender_city_, sender_state_, sender_county_, sender_country_, dummy_, sender_reference_, sender_id_);     
   END IF;
   sender_country_desc_ := Iso_Country_API.Get_Description(sender_country_);
END Get_Sender_Addr_Info;


@UncheckedAccess
FUNCTION Get_Address_Line (    
   receiver_id_            IN VARCHAR2, 
   receiver_addr_id_       IN VARCHAR2,   
   line_no_                IN NUMBER,
   receiver_type_db_       IN VARCHAR2 ) RETURN VARCHAR2
IS     
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN     
      RETURN Customer_Info_Address_API.Get_Line(receiver_id_, receiver_addr_id_, line_no_);     
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      RETURN Supplier_Info_Address_API.Get_Line(receiver_id_, receiver_addr_id_, line_no_);
   END IF;   
   RETURN NULL;
END Get_Address_Line;


@UncheckedAccess
FUNCTION Get_Address_Name (    
   receiver_id_            IN VARCHAR2, 
   receiver_addr_id_       IN VARCHAR2,   
   receiver_type_db_       IN VARCHAR2 ) RETURN VARCHAR2
IS 
   addr_name_         VARCHAR2(100);
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN     
      addr_name_ := Customer_Info_Address_API.Get_Name(receiver_id_, receiver_addr_id_);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      addr_name_ := Company_Address_Deliv_Info_API.Get_Address_Name(Site_API.Get_Company(receiver_id_), receiver_addr_id_);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN  
      addr_name_ := Whse_Shipment_Receipt_Info_API.Get_Warehouse_Address_Name(receiver_id_, receiver_addr_id_);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN     
      addr_name_ := Supplier_Info_Address_API.Get_Name(receiver_id_, receiver_addr_id_);
   END IF;    
   RETURN addr_name_;
END Get_Address_Name;

-- Get_Language_Code
-- This function will return source specific language code.
-- Use receiver_type as parameter since this will called from header level.
@UncheckedAccess
FUNCTION Get_Language_Code (
   receiver_id_         IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS   
   warehouse_rec_   Warehouse_API.Public_Rec;
   language_code_   VARCHAR2(2);
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN      
      language_code_ := Customer_Info_API.Get_Default_Language_Db(receiver_id_);  
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      language_code_ :=  Site_API.Get_Default_Language_Db(receiver_id_);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(receiver_id_);
      language_code_ :=  Site_API.Get_Default_Language_Db(warehouse_rec_.contract); 
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      language_code_ := Supplier_Info_API.Get_Default_Language_Db(receiver_id_);
   END IF;
   RETURN language_code_;
END Get_Language_Code;

-- Get_Currency_Code
-- This function will return source specific currency code.
-- Use receiver_type as parameter since this will called from header level.
@UncheckedAccess
FUNCTION Get_Currency_Code (
   receiver_id_         IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Cust_Ord_Customer_API.Get_Currency_Code(receiver_id_);
      $ELSE
         NULL;      
      $END
   END IF;
   RETURN NULL;
END Get_Currency_Code;


-- Get_Document_Address
-- This function will return source specific document address.
-- Use receiver_type as parameter since this will called from header level.
@UncheckedAccess
FUNCTION Get_Document_Address (
   receiver_id_         IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS 
   warehouse_rec_         Warehouse_API.Public_Rec;
   addr_type_            VARCHAR2(100);
   addr_type_identity_   VARCHAR2(20);
   document_addr_id_      VARCHAR2(50);
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         document_addr_id_ := Cust_Ord_Customer_API.Get_Document_Address(receiver_id_);
      $ELSE
         NULL;      
      $END
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      document_addr_id_ := Site_Discom_Info_API.Get_Document_Address_Id(receiver_id_);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(receiver_id_);      
      Whse_Shipment_Receipt_Info_API.Get_Warehouse_Address(addr_type_, addr_type_identity_, document_addr_id_, warehouse_rec_.contract, warehouse_rec_.warehouse_id);                 
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      document_addr_id_ := Supplier_Info_Address_API.Get_Default_Address(receiver_id_,Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DOCUMENT));
   END IF;
   RETURN document_addr_id_;
END Get_Document_Address;


@UncheckedAccess
FUNCTION Get_Sender_Name (
   sender_id_        IN VARCHAR2,
   sender_type_db_   IN VARCHAR2 ) RETURN VARCHAR2
IS 
   sender_name_   VARCHAR2(100);
   warehouse_rec_ Warehouse_API.Public_Rec;
BEGIN
   IF(sender_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN     
      sender_name_ := Site_API.Get_Description(sender_id_); 
   ELSIF (sender_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(sender_id_);
      sender_name_ := Warehouse_API.Get_Description(warehouse_rec_.contract, warehouse_rec_.warehouse_id);
   END IF;
   RETURN sender_name_;
END Get_Sender_Name;


@UncheckedAccess
FUNCTION Get_Receiver_Name (
   receiver_id_      IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   receiver_name_   VARCHAR2(100);
   warehouse_rec_   Warehouse_API.Public_Rec;
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN     
      receiver_name_ := Customer_Info_API.Get_Name(receiver_id_);  
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      receiver_name_ := Site_API.Get_Description(receiver_id_);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(receiver_id_);
      receiver_name_ := Warehouse_API.Get_Description(warehouse_rec_.contract, warehouse_rec_.warehouse_id);
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      receiver_name_ := Supplier_Info_General_API.Get_Name(receiver_id_);
   END IF;
   RETURN receiver_name_;
END Get_Receiver_Name;

-- Get_Receiver_E_Mail
-- This function will return source specific receiver email address.
-- Use receiver_type as parameter since this will called from header level.
@UncheckedAccess
FUNCTION Get_Receiver_E_Mail (
   receiver_id_         IN VARCHAR2,
   bill_addr_no_        IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN      
      RETURN Comm_Method_Api.Get_Default_Value ('CUSTOMER', receiver_id_ , 'E_MAIL', bill_addr_no_, SYSDATE );      
   END IF;
   RETURN NULL;
END Get_Receiver_E_Mail;

@UncheckedAccess
FUNCTION Get_Receiver_Our_Id (
   receiver_id_         IN VARCHAR2,
   company_             IN VARCHAR2,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN       
      RETURN Customer_Info_Our_Id_API.Get_Our_Id(receiver_id_, company_);      
   END IF;
   RETURN NULL;
END Get_Receiver_Our_Id;

@UncheckedAccess
FUNCTION Get_Forward_Agent_Id (
   receiver_id_         IN VARCHAR2,    
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS  
   receiver_addr_id_ VARCHAR2(50);
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN    
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Cust_Ord_Customer_API.Get_Forward_Agent_Id(receiver_id_);   
      $ELSE
         NULL;
      $END
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      RETURN Site_Discom_Info_API.Get_Forward_Agent_Id(receiver_id_);  
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      receiver_addr_id_ :=  Supplier_Info_Address_API.Get_Default_Address(receiver_id_, Address_Type_Code_API.Decode(Address_Type_Code_API.DB_DELIVERY)); 
      RETURN Supp_Outbound_Addr_Info_API.Get_Forward_Agent_Id(receiver_id_, receiver_addr_id_);
   END IF;
   RETURN NULL;
END Get_Forward_Agent_Id;

-- Validate_Receiver_Id
-- This procedue will validate the receiver id corrosponding to a specifc receiver type.
-- Since no references added in model, refernce check will be manually handled using this procedure.
PROCEDURE Validate_Receiver_Id (
   receiver_id_   IN VARCHAR2,
   receiver_type_ IN VARCHAR2,
   contract_      IN VARCHAR2 )   
IS 
   exist_                 VARCHAR2(5)  := Fnd_Boolean_API.DB_TRUE;
   same_company_          BOOLEAN;
   site_company_          VARCHAR2(20);
   receiver_company_      VARCHAR2(20);
   is_remote_warehouse_   VARCHAR2(5) := 'TRUE';
   warehouse_rec_         Warehouse_API.Public_Rec;
BEGIN   
   IF (receiver_type_ IS NOT NULL AND receiver_id_ IS NOT NULL) THEN   
      site_company_      := Site_API.Get_Company(contract_);
      IF (receiver_type_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN         
         exist_ := Customer_Info_API.Check_Exist(receiver_id_); 
      ELSIF (receiver_type_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN         
         exist_ := Supplier_Info_API.Check_Exist(receiver_id_); 
      ELSIF (receiver_type_ = Sender_Receiver_Type_API.DB_SITE) THEN
         exist_ :=  Fnd_Boolean_API.DB_FALSE;
         IF (Site_API.Exists(receiver_id_)) THEN
            exist_ :=  Fnd_Boolean_API.DB_TRUE;
         END IF;
         
         IF (exist_ = Fnd_Boolean_API.DB_TRUE) THEN
            receiver_company_ := Site_API.Get_Company(receiver_id_);
            
            IF (site_company_ != receiver_company_) THEN
               same_company_ := FALSE;   
            END IF;
         END IF;
      ELSIF (receiver_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
         IF(Warehouse_API.Check_Exist(receiver_id_)) THEN
            exist_ := Fnd_Boolean_API.DB_TRUE;  
         END IF;

         IF (exist_ = Fnd_Boolean_API.DB_TRUE) THEN
            warehouse_rec_       := Warehouse_API.Get(receiver_id_);
            is_remote_warehouse_ := warehouse_rec_.remote_warehouse;

            IF (warehouse_rec_.remote_warehouse = 'TRUE') THEN
               receiver_company_ := Site_API.Get_Company(warehouse_rec_.contract);

               IF (site_company_ != receiver_company_) THEN
                  same_company_ := FALSE;   
               END IF;
            END IF;

         END IF; 
      END IF;   
   END IF;
   
   IF(exist_ = Fnd_Boolean_API.DB_FALSE) THEN
      Error_SYS.Record_General(lu_name_, 'RECEIVERNOTEXIST: Receiver ID :P1 with :P2 receiver type does not exist', receiver_id_, Sender_Receiver_Type_API.Decode(receiver_type_));
   END IF;
   
   IF (NOT same_company_) THEN
      Error_SYS.Record_General(lu_name_, 'RECEIVERNOTINSAMECOMP: Receiver ID :P1 with :P2 receiver type does not belong to the company of the shipment site', receiver_id_, Sender_Receiver_Type_API.Decode(receiver_type_));   
   END IF;
   
   IF (receiver_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      IF (is_remote_warehouse_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDWAREHOUSERECEIVER: Receiver ID :P1 with :P2 receiver type is not a remote warehouse', receiver_id_, Sender_Receiver_Type_API.Decode(receiver_type_));   
      END IF;
   END IF;
END Validate_Receiver_Id;


PROCEDURE Validate_Sender_Id (
   sender_id_     IN VARCHAR2,
   sender_type_   IN VARCHAR2,
   contract_      IN VARCHAR2 )   
IS 
   exist_                 BOOLEAN :=  TRUE;
   invalid_sender_        BOOLEAN :=  FALSE;
   site_company_          VARCHAR2(20);
   warehouse_rec_         Warehouse_API.Public_Rec;
   is_remote_warehouse_   VARCHAR2(5) := 'TRUE';
BEGIN   
   IF (sender_type_ IS NOT NULL AND sender_id_ IS NOT NULL) THEN   
      site_company_    := Site_API.Get_Company(contract_);
      
      IF (sender_type_ = Sender_Receiver_Type_API.DB_SITE) THEN   
         exist_ := FALSE;
         IF (Site_API.Exists(sender_id_)) THEN
            exist_ := TRUE;
         END IF;
        
         IF (exist_) THEN
            IF (contract_ !=  sender_id_) THEN
               invalid_sender_ := TRUE;   
            END IF;
         END IF;     
      ELSIF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
         exist_ := Warehouse_API.Check_Exist(sender_id_);
         
         IF (exist_) THEN
            warehouse_rec_ := Warehouse_API.Get(sender_id_);
            is_remote_warehouse_ := warehouse_rec_.remote_warehouse;
            
            IF (is_remote_warehouse_ = 'TRUE') THEN
               IF (contract_ != warehouse_rec_.contract) THEN
                  invalid_sender_ := TRUE;   
               END IF;
            END IF;
         END IF; 
      END IF;   
   END IF;
   
   IF(NOT exist_) THEN
      Error_SYS.Record_General(lu_name_, 'SENDERNOTEXIST: Sender ID :P1 with :P2 sender type does not exist.', sender_id_, Sender_Receiver_Type_API.Decode(sender_type_));
   END IF;
   
   IF (invalid_sender_) THEN
      Error_SYS.Record_General(lu_name_, 'SENDERNOTINSAMESITE: Sender ID :P1 with :P2 sender type does not belong to the shipment site.', sender_id_, Sender_Receiver_Type_API.Decode(sender_type_));   
   END IF;
   
   IF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      IF (is_remote_warehouse_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDWAREHOUSESENDER: Sender ID :P1 with :P2 sender type is not a remote warehouse.', sender_id_, Sender_Receiver_Type_API.Decode(sender_type_));   
      END IF;
   END IF;
END Validate_Sender_Id;

@UncheckedAccess
FUNCTION Receiver_Address_Exists (
   receiver_id_      IN VARCHAR2,
   receiver_addr_id_ IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS 
   address_exists_        VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   warehouse_rec_         Warehouse_API.Public_Rec;
   addr_type_            VARCHAR2(100);
   addr_type_identity_   VARCHAR2(20);
   remote_wh_addr_id_     VARCHAR2(50);
BEGIN   
   IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN      
      IF(Customer_Info_Address_API.Exists(receiver_id_, receiver_addr_id_)) THEN
         address_exists_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN
      IF(Company_Address_API.Exists(Site_API.Get_Company(receiver_id_), receiver_addr_id_)) THEN
         address_exists_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(receiver_id_);
      Whse_Shipment_Receipt_Info_API.Get_Warehouse_Address(addr_type_, addr_type_identity_, remote_wh_addr_id_, warehouse_rec_.contract, warehouse_rec_.warehouse_id);     
      IF (receiver_addr_id_ = remote_wh_addr_id_) THEN
         address_exists_ := Fnd_Boolean_API.DB_TRUE;
      END IF; 
   ELSIF (receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      IF(Supplier_Info_Address_API.Exists(receiver_id_, receiver_addr_id_)) THEN
         address_exists_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   END IF;      
   RETURN address_exists_;
END Receiver_Address_Exists;


@UncheckedAccess
FUNCTION Sender_Address_Exists (
   sender_id_      IN VARCHAR2,
   sender_addr_id_ IN VARCHAR2,
   sender_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
   warehouse_rec_         Warehouse_API.Public_Rec;
   addr_type_             VARCHAR2(100);
   addr_type_identity_    VARCHAR2(20);
   remote_wh_addr_id_     VARCHAR2(50);
   address_exists_        VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN   
   IF (sender_type_db_ = Sender_Receiver_Type_API.DB_SITE) THEN      
      IF(Company_Address_API.Exists(Site_API.Get_Company(sender_id_), sender_addr_id_)) THEN
          address_exists_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   ELSIF (sender_type_db_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
      warehouse_rec_ := Warehouse_API.Get(sender_id_);
      Whse_Shipment_Receipt_Info_API.Get_Warehouse_Address(addr_type_, addr_type_identity_, remote_wh_addr_id_, warehouse_rec_.contract, warehouse_rec_.warehouse_id);
      IF (sender_addr_id_ = remote_wh_addr_id_) THEN
         address_exists_ := Fnd_Boolean_API.DB_TRUE;
      END IF;
   END IF;  
   RETURN address_exists_;
END Sender_Address_Exists;


@UncheckedAccess
FUNCTION Get_Receiver_Branch (
   receiver_id_      IN VARCHAR2,
   company_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS 
   branch_   VARCHAR2(20);
BEGIN   
   IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         branch_ := Invoice_Customer_Order_API.Get_Branch(company_, contract_, receiver_id_);   
      $ELSE
         NULL;
      $END
   ELSE
      branch_ := Site_Discom_Info_API.Get_Branch(contract_);
   END IF;   
   RETURN branch_;
END Get_Receiver_Branch;


@UncheckedAccess
FUNCTION Get_Comm_Method_Default (
   receiver_id_         IN VARCHAR2, 
   addr_type_          IN VARCHAR2,
   method_id_           IN VARCHAR2,
   address_id_          IN VARCHAR2,
   date_                IN DATE,
   receiver_type_db_    IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN          
      RETURN Comm_Method_API.Get_Default_Value(addr_type_, receiver_id_,
                                               method_id_, address_id_, date_);
   END IF;
   RETURN NULL;
END Get_Comm_Method_Default;
 
-- Validate_Source_Ref1
-- This procedue will validate the source ref 1 corrosponding to a specifc receiver type.
-- Since no references added in model, refernce check will be manually handled using this procedure.
PROCEDURE Validate_Source_Ref1 (
   oldrec_              IN shipment_tab%ROWTYPE,
   newrec_              IN shipment_tab%ROWTYPE,
   source_ref_type_db_  IN VARCHAR2)
IS 
BEGIN      
   IF (newrec_.receiver_type IS NOT NULL AND newrec_.source_ref1 IS NOT NULL
      AND Validate_SYS.Is_Changed(oldrec_.source_ref1, newrec_.source_ref1)) THEN      
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Customer_Order_API.Exist(newrec_.source_ref1);     
         $ELSE
            NULL;
         $END  
      ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
         $IF Component_Shipod_SYS.INSTALLED $THEN
            Shipment_Order_API.Exist(newrec_.source_ref1);
         $ELSE
            NULL;
         $END
      ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
         $IF Component_Rceipt_SYS.INSTALLED $THEN
            Receipt_Return_API.Rceipt_Return_Exist(newrec_.source_ref1);
         $ELSE
            NULL;
         $END
      END IF;    
   END IF;
END Validate_Source_Ref1;


@UncheckedAccess
FUNCTION Get_Supply_Country_Db (
   shipment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   supply_country_db_      VARCHAR2(2);  
BEGIN
   IF (Shipment_API.Get_Receiver_Type_Db(shipment_id_) = Sender_Receiver_Type_API.DB_CUSTOMER) THEN 
      $IF Component_Order_SYS.INSTALLED $THEN
         supply_country_db_ := Shipment_Freight_API.Get_Supply_Country_Db(shipment_id_);
      $ELSE
         NULL;
      $END
   END IF; 
   
   IF (supply_country_db_ IS NULL) THEN
      supply_country_db_ := Company_Site_API.Get_Country_Db(Shipment_API.Get_Contract(shipment_id_));
   END IF;
   
   RETURN supply_country_db_;    
END Get_Supply_Country_Db;


@UncheckedAccess
FUNCTION Get_Use_Price_Incl_Tax_Db (
   shipment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  use_price_incl_tax_db_   VARCHAR2(20);  
BEGIN
   IF (Shipment_API.Get_Receiver_Type_Db(shipment_id_) = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         use_price_incl_tax_db_ := Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db(shipment_id_);
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN NVL(use_price_incl_tax_db_, Fnd_Boolean_API.DB_FALSE);
END Get_Use_Price_Incl_Tax_Db;


PROCEDURE Post_Create_Manual_Ship (
   shipment_id_      IN NUMBER,
   contract_         IN VARCHAR2,
   receiver_id_      IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2 ) 
IS
BEGIN
   IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Freight_API.Post_Create_Manual_Ship(shipment_id_, contract_, receiver_id_);
      $ELSE
         NULL;
      $END
   END IF;   
END Post_Create_Manual_Ship;   


PROCEDURE Post_Create_Auto_Ship (
   shipment_id_         IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   from_shipment_id_    IN NUMBER,
   receiver_id_         IN VARCHAR2,
   use_price_incl_tax_  IN VARCHAR2,
   ship_via_code_       IN VARCHAR2,
   contract_            IN VARCHAR2,
   forward_agent_id_    IN VARCHAR2 ) 
IS
BEGIN
   IF (Shipment_API.Get_Receiver_Type_Db(shipment_id_) = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Freight_API.Post_Create_Auto_Ship(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                    from_shipment_id_, receiver_id_, use_price_incl_tax_, ship_via_code_, contract_, forward_agent_id_);
      $ELSE
         NULL;
      $END
   END IF;   
END Post_Create_Auto_Ship; 


@UncheckedAccess
FUNCTION Get_Ean_Location(
   receiver_id_      IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2, 
   address_id_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   ean_location_   VARCHAR2(100);
BEGIN
   IF (receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      ean_location_ := Customer_Info_Address_API.Get_Ean_Location(receiver_id_, address_id_);   
   END IF;   
   RETURN ean_location_;
END Get_Ean_Location;


@UncheckedAccess
FUNCTION Get_Demand_Code_Db (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS  
   demand_code_db_   VARCHAR2(20);
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN     
      $IF Component_Order_SYS.INSTALLED $THEN
         demand_code_db_:= Customer_Order_Line_API.Get_Demand_Code_Db(source_ref1_, source_ref2_, source_ref3_, TO_NUMBER(source_ref4_));   
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         demand_code_db_:= Shipment_Order_Line_API.Get_Demand_Code_Db(source_ref1_, source_ref2_);
      $ELSE
         NULL;
      $END      
   END IF;
   RETURN demand_code_db_;
END Get_Demand_Code_Db;   


@UncheckedAccess
FUNCTION Get_Default_Address (
   receiver_id_       IN VARCHAR2,  
   receiver_type_db_  IN VARCHAR2,
   address_type_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   address_id_   VARCHAR2(50);
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN     
      address_id_ := Customer_Info_Address_API.Get_Default_Address(receiver_id_, Address_Type_Code_API.Decode(address_type_code_));      
   END IF;    
   RETURN address_id_;
END Get_Default_Address;

@UncheckedAccess
FUNCTION Get_Receiver_Msg_Setup_Addr (
   receiver_id_      IN VARCHAR2,  
   media_code_       IN VARCHAR2,
   message_class_    IN VARCHAR,
   receiver_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   receiver_address_   VARCHAR2(200);
   receiver_site_      VARCHAR2(20);
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN  
      receiver_address_ := Customer_Info_Msg_Setup_API.Get_Address(receiver_id_, media_code_, message_class_);
   ELSIF (receiver_type_db_ IN (Sender_Receiver_Type_API.DB_SITE, Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE)) THEN
      receiver_site_ := Get_Receiver_Site___(receiver_id_, receiver_type_db_);
      receiver_address_ := Company_Msg_Setup_API.Get_Address(Site_API.Get_Company(receiver_site_), media_code_, message_class_); 
   END IF;    
   RETURN receiver_address_;
END Get_Receiver_Msg_Setup_Addr;

@UncheckedAccess
FUNCTION Increase_Receiver_Msg_Seq_No (
   receiver_id_      IN VARCHAR2,  
   media_code_       IN VARCHAR2,
   message_class_    IN VARCHAR,
   receiver_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   sequence_no_      NUMBER;
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN  
      sequence_no_ := Customer_Info_Msg_Setup_API.Increase_Sequence_No(receiver_id_, media_code_, message_class_);
   END IF;    
   RETURN sequence_no_;
END Increase_Receiver_Msg_Seq_No;


-----------------------------------------------------------------------------
-------------------- Methods related to source ref type ------------------------
-----------------------------------------------------------------------------

@UncheckedAccess
FUNCTION Get_Source_Supply_Country_Db (
   source_ref1_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2  
IS
  supply_country_db_   VARCHAR2(2);  
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN 
      $IF Component_Order_SYS.INSTALLED $THEN
         supply_country_db_ := Customer_Order_API.Get_Supply_Country_Db(source_ref1_);
      $ELSE
         NULL;
      $END
   END IF;   
   supply_country_db_ := NVL(supply_country_db_, Company_Site_API.Get_Country_Db(contract_));
   RETURN supply_country_db_;
END Get_Source_Supply_Country_Db;


-- Is_Goods_Non_Inv_Part_Type
-- This function will return whether the non inventory part is GOODS type. 
@UncheckedAccess
FUNCTION Is_Goods_Non_Inv_Part_Type (
   shipment_id_         IN VARCHAR2,
   source_part_no_      IN VARCHAR2,
   inventory_part_no_   IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS   
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) OR (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES)THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (Sales_Part_API.Get_Non_Inv_Part_Type_DB(Shipment_API.Get_Contract(shipment_id_), source_part_no_) = Non_Inventory_Part_Type_API.DB_GOODS) THEN
            RETURN 'TRUE';
         END IF;
      $ELSE
         NULL;      
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) OR (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)THEN
      IF inventory_part_no_ IS NULL THEN
         RETURN 'TRUE';
      END IF;
   END IF;
   RETURN 'FALSE';
END Is_Goods_Non_Inv_Part_Type;

   
-- Validate_Update_Closed_Shipmnt
-- This procedue validates a closed shipment upon editting. 
-- Return value is getting used in the shipment client.
PROCEDURE Validate_Update_Closed_Shipmnt (
   update_allowed_ OUT VARCHAR2,
   shipment_id_ IN NUMBER,
   called_by_server_ IN VARCHAR2) 
IS 
   co_invoice_found_  BOOLEAN := FALSE;
   
   CURSOR get_line IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type
      FROM shipment_line_tab
      WHERE shipment_id = shipment_id_;

BEGIN    
   update_allowed_ := 'FALSE';     
   FOR shipment_line_rec IN get_line LOOP
      IF (shipment_line_rec.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN          
            IF (Customer_Order_Line_API.Get_Qty_Invoiced (shipment_line_rec.source_ref1, shipment_line_rec.source_ref2, shipment_line_rec.source_ref3, shipment_line_rec.source_ref4) > 0 ) THEN
               co_invoice_found_ := TRUE;
               EXIT;
            END IF;
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');      
         $END
      END IF;         
   END LOOP; 
   
   IF NOT(co_invoice_found_) THEN
      update_allowed_ := 'TRUE';
   END IF; 
   
   IF (called_by_server_ = 'TRUE' AND co_invoice_found_) THEN
      Error_SYS.Record_General(lu_name_, 'NOCHANGECLOSSHIP: A closed shipment cannot be updated when one or more shipment lines are invoiced.');
   END IF;
   
END Validate_Update_Closed_Shipmnt;


-- Get_Source_Current_Info
-- Append all source current info and return.
@UncheckedAccess
FUNCTION Get_Source_Current_Info (
   source_ref_types_ IN VARCHAR2) RETURN VARCHAR2
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
   info_                   VARCHAR2(32000);
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_types_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            info_ := info_ || Customer_Order_Line_API.Get_Current_Info;         
         $ELSE
            NULL; 
         $END
      END IF;             
   END LOOP;
   RETURN info_;
END Get_Source_Current_Info;


PROCEDURE Post_Delete_Ship_Line (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS    
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Post_Delete_Ship_Line(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;   
END Post_Delete_Ship_Line;


@UncheckedAccess
FUNCTION Blocked_Source_Exist (
   source_ref1_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS  
BEGIN   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
     $IF Component_Order_SYS.INSTALLED $THEN
        IF(Customer_Order_API.Get_Objstate(source_ref1_) = 'Blocked') THEN
           RETURN Fnd_Boolean_API.DB_TRUE;
        END IF;
     $ELSE
        NULL;
     $END   
   END IF;
   RETURN Fnd_Boolean_API.DB_FALSE;   
END Blocked_Source_Exist;


PROCEDURE Modify_Source_Open_Ship_Qty (
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   new_open_shipment_qty_ IN NUMBER )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Modify_Open_Shipment_Qty(source_ref1_, source_ref2_, source_ref3_,
                                                             source_ref4_, new_open_shipment_qty_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         Delivery_Interface_Shpmnt_API.Update_Connected_Shipment_Qty(source_ref1_, source_ref2_, source_ref3_, new_open_shipment_qty_);
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END      
   END IF;  
END Modify_Source_Open_Ship_Qty;


PROCEDURE Source_Exist (
   shipment_id_           IN NUMBER, 
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2)
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Line_API.Exist(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Order_Line_API.Exist(source_ref1_, source_ref2_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         Planning_Item_API.Exist(source_ref1_, source_ref2_, source_ref3_);
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END   
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
        Receipt_Return_API.Rceipt_Return_Line_Exist(source_ref1_, source_ref2_, source_ref3_, NULL, source_ref4_); 
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   END IF;  
END Source_Exist;


PROCEDURE Fetch_And_Validate_Ship_Line (
   new_line_tab_       OUT Shipment_Line_API.New_Line_Tab,
   shipment_id_        IN  NUMBER,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2)
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Fetch_And_Validate_Ship_Line(new_line_tab_, shipment_id_, source_ref1_, 
                                                                 source_ref2_,  source_ref3_, source_ref4_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END     
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         DECLARE 
            planning_shipment_rec_    Delivery_Interface_Shpmnt_API.planning_shipment_rec;
         BEGIN
            planning_shipment_rec_    := Delivery_Interface_Shpmnt_API.Fetch_And_Validate_Ship_Line( shipment_id_, source_ref1_, 
                                                                                                     source_ref2_,  source_ref3_);
            new_line_tab_(1).shipment_id            := shipment_id_;
            new_line_tab_(1).source_ref1            := planning_shipment_rec_.item_no;
            new_line_tab_(1).source_ref2            := planning_shipment_rec_.item_revision;
            new_line_tab_(1).source_ref3            := planning_shipment_rec_.planning_no;
            new_line_tab_(1).source_ref4            := NULL;
            new_line_tab_(1).source_ref_type        := Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES;
            new_line_tab_(1).source_part_no         := planning_shipment_rec_.part_no;
            new_line_tab_(1).source_part_desc       := planning_shipment_rec_.part_description;            
            new_line_tab_(1).inventory_part_no      := planning_shipment_rec_.part_no;            
            new_line_tab_(1).source_unit_meas       := planning_shipment_rec_.unit_of_measure;
            new_line_tab_(1).inventory_qty          := planning_shipment_rec_.source_qty;
            new_line_tab_(1).connected_source_qty   := planning_shipment_rec_.source_qty;
            new_line_tab_(1).qty_assigned           := 0;
            new_line_tab_(1).qty_shipped            := 0;
            new_line_tab_(1).qty_to_ship            := 0;
         END;
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN  
      $IF Component_Shipod_SYS.INSTALLED $THEN
          Shipment_Ord_Utility_API.Fetch_And_Validate_Ship_Line(new_line_tab_, shipment_id_, source_ref1_, source_ref2_); 
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Fetch_And_Validate_Ship_Line(new_line_tab_, shipment_id_, source_ref1_, source_ref2_, source_ref3_, to_number(source_ref4_), source_ref_type_db_);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   END IF;   
END Fetch_And_Validate_Ship_Line;


PROCEDURE Post_Connect_Shipment_Line (
   shipment_id_           IN NUMBER,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   new_line_              IN VARCHAR2,
   sales_qty_             IN NUMBER )
IS    
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Post_Connect_Shipment_Line(shipment_id_, source_ref1_, source_ref2_,
                                                               source_ref3_, source_ref4_, new_line_, sales_qty_);
                                                               
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;   
END Post_Connect_Shipment_Line;


PROCEDURE Check_Update_Connected_Src_Qty (
   source_ref1_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2 )
IS    
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Check_Update_Connected_Src_Qty(source_ref1_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;   
END Check_Update_Connected_Src_Qty;


PROCEDURE Post_Connect_To_Shipment (
   shipment_id_           IN NUMBER,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
   connected_lines_exist_ IN VARCHAR2,
   last_comp_non_inv_     IN VARCHAR2,
   added_to_new_shipment_ IN VARCHAR2 )
IS    
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Post_Connect_To_Shipment(shipment_id_, source_ref1_, source_ref2_, source_ref3_,
                                                             source_ref4_, connected_lines_exist_, last_comp_non_inv_, added_to_new_shipment_ );
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;
   Shipment_Handling_Utility_API.Connect_Hus_From_Inventory(shipment_id_);
END Post_Connect_To_Shipment;


@UncheckedAccess
FUNCTION Get_Configuration_Id (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Configuration_Id(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END  
   END IF;
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Configuration_Id(source_ref1_, source_ref2_);
      $ELSE
         NULL;
      $END
   END IF;
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Configuration_Id(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN '*';       
END Get_Configuration_Id;


PROCEDURE New_Source_History_Line (
   source_ref1_         IN VARCHAR2,
   message_text_        IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2)
IS          
BEGIN    
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_History_API.New(source_ref1_, message_text_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END   
   END IF;    
END New_Source_History_Line;


@UncheckedAccess
FUNCTION Get_Source_Part_Desc (
   contract_            IN VARCHAR2,
   source_part_no_      IN VARCHAR2,
   lang_code_           IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS      
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
     $IF Component_Order_SYS.INSTALLED $THEN
        RETURN Sales_part_API.Get_Catalog_Desc(contract_, source_part_no_, lang_code_);
     $ELSE
        NULL;
     $END
  ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
     RETURN Inventory_Part_API.Get_Description(contract_, source_part_no_);
  ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         RETURN Receipt_Info_Manager_API.Get_Src_Part_Desc(contract_, source_part_no_, source_ref_type_db_);
      $ELSE
         NULL;
      $END
  END IF;  
  RETURN NULL;
END Get_Source_Part_Desc;


@UncheckedAccess
FUNCTION Get_Source_Part_Desc (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS      
   source_part_desc_   VARCHAR2(200);
BEGIN
   IF (NVL(shipment_id_, 0) = 0) THEN
      IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
        $IF Component_Order_SYS.INSTALLED $THEN
            source_part_desc_ := Customer_Order_Line_API.Get_Catalog_Desc(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
        $ELSE
           NULL;
        $END   
     END IF;  
  ELSE
     source_part_desc_ := Shipment_Line_API.Get_Source_Part_Desc_By_Source(shipment_id_, source_ref1_, source_ref2_, 
                                                                           source_ref3_, source_ref4_, source_ref_type_db_);
  END IF;
  RETURN source_part_desc_;
END Get_Source_Part_Desc;


@UncheckedAccess
FUNCTION Get_Source_Part_Desc_For_Lang (
   contract_            IN VARCHAR2,
   source_part_no_      IN VARCHAR2,
   lang_code_           IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS      
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
     $IF Component_Order_SYS.INSTALLED $THEN
        RETURN Sales_part_API.Get_Catalog_Desc_For_Lang(contract_, source_part_no_, lang_code_);
     $ELSE
        NULL;
     $END  
    ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         RETURN Purchase_Part_Lang_Desc_API.Get_Description(contract_, source_part_no_, lang_code_);
      $ELSE
         NULL;
      $END
   END IF; 
  RETURN NULL;
END Get_Source_Part_Desc_For_Lang;


@UncheckedAccess
FUNCTION Get_Receiver_Part_Conv_Factor (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS    
   receiver_part_conv_factor_  NUMBER := 1;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         receiver_part_conv_factor_ := Customer_Order_Line_API.Get_Customer_Part_Conv_Factor(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END  
   END IF;
   RETURN NVL(receiver_part_conv_factor_, 1);       
END Get_Receiver_Part_Conv_Factor;

@UncheckedAccess
FUNCTION Receiver_Part_Invert_Conv_Fact (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS    
   receiver_part_invert_con_fact_  NUMBER := 1;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         receiver_part_invert_con_fact_ := Customer_Order_Line_API.Get_Cust_Part_Invert_Conv_Fact(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END  
   END IF;
   RETURN NVL(receiver_part_invert_con_fact_, 1);       
END Receiver_Part_Invert_Conv_Fact;

-- Get_Tot_Avail_Qty_To_Connect
-- This function will return the qty available for shipment connection.
@UncheckedAccess
FUNCTION Get_Tot_Avail_Qty_To_Connect (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   old_inventory_qty_  IN NUMBER) RETURN NUMBER
IS    
   line_rec_   Public_Line_Rec;
   avail_qty_  NUMBER := 0;
BEGIN
   line_rec_ := Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      avail_qty_ := (line_rec_.source_inventory_qty - line_rec_.source_qty_shipped - (line_rec_.open_shipment_qty - old_inventory_qty_ ) + line_rec_.qty_shipdiff);
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      avail_qty_ := (line_rec_.source_qty - (line_rec_.open_shipment_qty - old_inventory_qty_ ));
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      avail_qty_ := (line_rec_.source_qty - (Shipment_Line_API.Get_Sum_Connected_Source_Qty(TO_CHAR(source_ref1_), TO_CHAR(source_ref2_), NULL, NULL, Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) - old_inventory_qty_));   
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      IF line_rec_.source_qty > 0 AND line_rec_.source_inventory_qty = 0 THEN
         avail_qty_ := (line_rec_.source_qty - (Shipment_Line_API.Get_Sum_Connected_Inv_Qty(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_) - old_inventory_qty_));
      ELSE
         avail_qty_ := (line_rec_.source_inventory_qty - (Shipment_Line_API.Get_Sum_Connected_Inv_Qty(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_) - old_inventory_qty_));
      END IF;
   END IF; 
   RETURN avail_qty_;
END Get_Tot_Avail_Qty_To_Connect;


-- Check_Tot_Qty_To_Ship
-- This function will check and return whether qty to ship in source is equal to what left to be delivered.
-- This function is refered when connected source qty is changed for non inventory parts.
@UncheckedAccess
FUNCTION Check_Tot_Qty_To_Ship (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN BOOLEAN
IS    
   line_rec_   Public_Line_Rec;
   valid_      BOOLEAN := FALSE;
BEGIN
   line_rec_ := Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   valid_    := (line_rec_.source_inventory_qty - line_rec_.source_qty_shipped = line_rec_.source_qty_to_ship);
   RETURN valid_;
END Check_Tot_Qty_To_Ship;



@UncheckedAccess
FUNCTION Get_Rental_Db (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,   
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   rental_db_   VARCHAR2(5):='FALSE';    
BEGIN   
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         rental_db_ := Customer_Order_Line_API.Get_Rental_Db(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END
   END IF;
   RETURN rental_db_;
END Get_Rental_Db;


@UncheckedAccess
FUNCTION Get_Receiver_Part_Qty (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,  
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER
IS
BEGIN 
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN         
         RETURN NVL(Customer_Order_Line_API.Get_Customer_Part_Buy_Qty(source_ref1_, source_ref2_, source_ref3_, source_ref4_), Customer_Order_Line_API.Get_Buy_Qty_Due(source_ref1_, source_ref2_, source_ref3_, source_ref4_));        
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN  
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Qty_To_Ship(source_ref1_, source_ref2_); 
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   END IF;
   RETURN NULL;
END Get_Receiver_Part_Qty;


@UncheckedAccess
FUNCTION Get_Receiver_Source_Unit_Meas (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,  
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN 
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN         
         RETURN Customer_Order_Line_API.Get_Customer_Part_Unit_Meas(source_ref1_, source_ref2_, source_ref3_, source_ref4_);        
      $ELSE
         NULL;
      $END       
   END IF;
   RETURN NULL;
END Get_Receiver_Source_Unit_Meas;


PROCEDURE Handle_Ship_Line_Qty_Change (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   inventory_qty_      IN NUMBER )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Handle_Ship_Line_Qty_Change(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, inventory_qty_); 
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END     
   END IF;
END Handle_Ship_Line_Qty_Change;   


PROCEDURE Handle_Line_Qty_To_Ship_Change (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Handle_Line_Qty_To_Ship_Change(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_); 
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END     
   END IF;
END Handle_Line_Qty_To_Ship_Change;  


@UncheckedAccess
FUNCTION Get_Receiver_Part_Desc (
   shipment_id_        IN NUMBER,
   shipment_line_no_   IN NUMBER, 
   receiver_id_        IN VARCHAR2,
   contract_           IN VARCHAR2,
   receiver_part_no_   IN VARCHAR2,   
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
   receiver_part_desc_ VARCHAR2(200);
   ship_rec_    shipment_line_API.Public_Rec;  
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         receiver_part_desc_ := Sales_Part_Cross_Reference_API.Get_Catalog_Desc(receiver_id_, contract_, receiver_part_no_);         
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      ship_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);     
      $IF Component_Purch_SYS.INSTALLED $THEN
         RETURN Purchase_Order_Line_API.Get_Description(ship_rec_.source_ref1, ship_rec_.source_ref2, ship_rec_.source_ref3);
      $ELSE
         NULL;
      $END
   ELSE
      receiver_part_desc_ := Shipment_Line_API.Get_Source_Part_Description(shipment_id_, shipment_line_no_);
   END IF;
   RETURN receiver_part_desc_;       
END Get_Receiver_Part_Desc;


PROCEDURE Recalc_Catch_Price_Conv_Factor (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Pick_Customer_Order_API.Recalc_Catch_Price_Conv_Factor(order_no_     => source_ref1_, 
                                                                line_no_      => source_ref2_, 
                                                                rel_no_       => source_ref3_, 
                                                                line_item_no_ => source_ref4_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;                                                           
END Recalc_Catch_Price_Conv_Factor;


@UncheckedAccess
FUNCTION Is_Shipment_Connected (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS     
   shipment_connected_   VARCHAR2(5):='FALSE';
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         shipment_connected_ := Customer_Order_Line_API.Get_Shipment_Connected_Db(source_ref1_, source_ref2_, source_ref3_, source_ref4_);          
      $ELSE
         NULL;
      $END  
   ELSIF (source_ref_type_db_ IN (Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES,
                                  Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER,
                                  Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)) THEN   
      shipment_connected_ := 'TRUE';
   END IF;
   RETURN shipment_connected_;       
END Is_Shipment_Connected;

@UncheckedAccess
FUNCTION Is_Load_List_Connected (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS     
   load_list_connected_   VARCHAR2(5):='FALSE';
BEGIN   
   $IF Component_Order_SYS.INSTALLED $THEN
      IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         IF (Customer_Order_Line_API.Get_Load_Id(source_ref1_, source_ref2_, source_ref3_, source_ref4_) IS NOT NULL ) THEN
            load_list_connected_ := 'TRUE'; 
         END IF;
      END IF;
   $END  
   RETURN load_list_connected_;       
END Is_Load_List_Connected;

@UncheckedAccess
FUNCTION Get_Part_Customs_Stat_No (
   contract_            IN VARCHAR2,
   source_part_no_      IN VARCHAR2,
   inventory_part_no_   IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS   
   customs_stat_no_   VARCHAR2(15);    
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         customs_stat_no_ := Sales_part_API.Get_Customs_Stat_No(contract_, source_part_no_);
      $ELSE
         NULL;
      $END  
   ELSIF (source_ref_type_db_ IN (Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES,
                                  Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER,
                                  Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN )) THEN                        
      customs_stat_no_ := Inventory_Part_API.Get_Customs_Stat_No(contract_, inventory_part_no_);                            
   END IF;  
   RETURN customs_stat_no_;
END Get_Part_Customs_Stat_No;


@UncheckedAccess
FUNCTION Get_Part_Gtin_No (
   contract_            IN VARCHAR2,
   source_part_no_      IN VARCHAR2,
   input_unit_meas_     IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 ) RETURN VARCHAR2
IS   
BEGIN   
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Sales_Part_API.Get_Gtin_No(contract_, source_part_no_, input_unit_meas_);
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN      
      RETURN Part_Gtin_API.Get_Default_Gtin_No(source_part_no_);           
   END IF;   
   RETURN NULL;   
END Get_Part_Gtin_No;

@UncheckedAccess
FUNCTION Get_Language_Code (
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref3_          IN VARCHAR2,
   source_ref4_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
   receiver_id_          IN VARCHAR2,
   receiver_type_db_     IN VARCHAR2,
   source_language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   language_code_   VARCHAR2(2);
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         language_code_ := Shipment_Order_Utility_API.Get_Language_Code(source_ref1_, source_ref2_, source_ref3_, 
                                                                        source_ref4_, receiver_id_, source_language_code_);
      $ELSE
         NULL;
      $END
   ELSE
      language_code_ := source_language_code_;
   END IF;   
   
   IF (language_code_ IS NULL) THEN
      language_code_ := Get_Language_Code(receiver_id_, receiver_type_db_);
   END IF;
   
   RETURN language_code_;
END Get_Language_Code;

-----------------------------------------------------------------------------
-------------------- Methods related to reassignment ------------------------
-----------------------------------------------------------------------------

@UncheckedAccess
FUNCTION Get_Max_Ship_Qty_To_Reassign (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER,
   inventory_qty_      IN NUMBER ) RETURN NUMBER
IS
   max_ship_qty_to_reassign_ NUMBER:=0;
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         max_ship_qty_to_reassign_ := Customer_Order_Reservation_API.Get_Max_Ship_Qty_To_Reassign(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                                                                  shipment_id_, inventory_qty_ );
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN NVL(max_ship_qty_to_reassign_, 0);
END Get_Max_Ship_Qty_To_Reassign;


----------------------- RESERVATION SPECIFIC PUBLIC METHODS -----------------

-- Reserve_Shipment_Line_Allowed
--   Use to check whether reservation is allowed for shipment line from source perspective.
--   If the source uses semi centralized reservation then this function is not needed.
@UncheckedAccess
FUNCTION Reserve_Shipment_Line_Allowed (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2 ) RETURN NUMBER
IS     
   allowed_                NUMBER := 0;       
BEGIN    
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         allowed_ := Shipment_Order_Utility_API.Reserve_Shipment_Allowed(source_ref1_,source_ref2_,source_ref3_,source_ref4_);
         IF(allowed_ = 1) THEN
            RETURN allowed_;               
         END IF;
      $ELSE
         NULL;           
      $END
   END IF;    
   RETURN allowed_;
END Reserve_Shipment_Line_Allowed;


-- Reserve_Shipment
--   Reserve the entire shipment.
--   This will split the header source ref type and loop to reserve each sources.
--   If the source uses semi centralized reservation then this procedure is not needed.
PROCEDURE Reserve_Shipment (
   reserve_ship_tab_     IN OUT   Reserve_Shipment_API.Reserve_Shipment_Table,
   shipment_id_          IN       VARCHAR2,
   source_ref_type_db_   IN       VARCHAR2)
IS  
BEGIN  
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Reserve_Shipment(reserve_ship_tab_, shipment_id_, source_ref_type_db_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;            
END Reserve_Shipment;

-- Check_Qty_To_Reserve
--   This function will check from the source whether any qty is available for reserve.
--   If the source doesn't have such checks then should return TRUE.
@UncheckedAccess
FUNCTION Check_Qty_To_Reserve (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   qty_reserve_available_   VARCHAR2(5):= 'FALSE';
BEGIN 
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         qty_reserve_available_ := Customer_Order_Line_API.Check_Qty_To_Reserve(source_ref1_,
                                                                                source_ref2_,
                                                                                source_ref3_,
                                                                                source_ref4_);
      $ELSE
         NULL;
      $END   
   ELSIF (source_ref_type_db_ IN (Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES,
                                  Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER, 
                                  Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)) THEN
      -- sources that does not have their own logic to decide on quantity should return true.
      qty_reserve_available_ := 'TRUE';
   END IF;  
   RETURN NVL(qty_reserve_available_, 'FALSE');
END Check_Qty_To_Reserve; 


-- Reserve_Manually
--   This will be called to do manual reservation.
--   If the source uses semi centralized reservation then this procedure is not needed.
PROCEDURE Reserve_Manually (
   info_                   OUT VARCHAR2,   
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   contract_               IN  VARCHAR2,
   inventory_part_no_      IN  VARCHAR2,
   configuration_id_       IN  VARCHAR2,
   location_no_            IN  VARCHAR2,
   lot_batch_no_           IN  VARCHAR2,
   serial_no_              IN  VARCHAR2,
   eng_chg_level_          IN  VARCHAR2,
   waiv_dev_rej_no_        IN  VARCHAR2,
   activity_seq_           IN  NUMBER,
   handling_unit_id_       IN  NUMBER,
   qty_to_reserve_         IN  NUMBER,
   input_qty_              IN  NUMBER,
   input_unit_meas_        IN  VARCHAR2,
   input_conv_factor_      IN  NUMBER,
   input_variable_values_  IN  VARCHAR2,
   shipment_id_            IN  NUMBER,
   part_ownership_         IN  VARCHAR2,  
   owner_                  IN  VARCHAR2,  
   condition_code_         IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
   pick_by_choice_blocked_ IN  VARCHAR2 )
IS         
   state_ VARCHAR2(50);
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Reserve_Customer_Order_API.Reserve_Manually__(info_                   => info_, 
                                                       state_                  => state_, 
                                                       order_no_               => source_ref1_, 
                                                       line_no_                => source_ref2_, 
                                                       rel_no_                 => source_ref3_, 
                                                       line_item_no_           => source_ref4_, 
                                                       contract_               => contract_, 
                                                       part_no_                => inventory_part_no_, 
                                                       location_no_            => location_no_, 
                                                       lot_batch_no_           => lot_batch_no_, 
                                                       serial_no_              => serial_no_, 
                                                       eng_chg_level_          => eng_chg_level_, 
                                                       waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                                       activity_seq_           => activity_seq_, 
                                                       handling_unit_id_       => handling_unit_id_, 
                                                       qty_to_reserve_         => qty_to_reserve_, 
                                                       input_qty_              => input_qty_, 
                                                       input_unit_meas_        => input_unit_meas_, 
                                                       input_conv_factor_      => input_conv_factor_, 
                                                       input_variable_values_  => input_variable_values_, 
                                                       shipment_id_            => shipment_id_, 
                                                       part_ownership_         => part_ownership_, 
                                                       owner_                  => owner_, 
                                                       condition_code_         => condition_code_, 
                                                       pick_by_choice_blocked_ => pick_by_choice_blocked_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END  
   END IF;    
END Reserve_Manually;


-- Check_Man_Reservation_Valid
--   This function will use to filter out records in detail tab of manual reservation window.
--   If the source doesn't have such checks then should return TRUE.
@UncheckedAccess
FUNCTION Check_Man_Reservation_Valid (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,
   supply_code_db_            IN VARCHAR2,
   project_id_                IN VARCHAR2,
   invent_stock_proj_id_      IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   part_ownership_db_         IN VARCHAR2,
   owning_customer_no_        IN VARCHAR2,
   owning_vendor_no_          IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   source_part_ownership_db_  IN VARCHAR2,
   source_owner_              IN VARCHAR2 ) RETURN VARCHAR2
IS    
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF((((supply_code_db_ = 'IO' OR project_id_ IS NULL) AND invent_stock_proj_id_ IS NULL) OR 
               (supply_code_db_ != 'IO' AND project_id_ IS NOT NULL) AND invent_stock_proj_id_ = project_id_)
            AND Reserve_Customer_Order_API.Check_Man_Reservation_Valid(source_ref1_, source_ref2_, source_ref3_, source_ref4_, part_ownership_db_, owning_customer_no_, owning_vendor_no_, lot_batch_no_, serial_no_) = 'TRUE') THEN
            RETURN Fnd_Boolean_API.DB_TRUE;
         ELSE
             RETURN Fnd_Boolean_API.DB_FALSE;
         END IF;
      $ELSE
         NULL;
      $END     
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN      
      IF (((supply_code_db_ = 'MRP' OR project_id_ IS NULL) AND invent_stock_proj_id_ IS NULL) OR 
          (supply_code_db_ != 'MRP' AND project_id_ IS NOT NULL) AND invent_stock_proj_id_ = project_id_) THEN
         RETURN Fnd_Boolean_API.DB_TRUE;
      ELSE
         RETURN Fnd_Boolean_API.DB_FALSE;
      END IF;   
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Ord_Utility_API.Check_Man_Reservation_Valid(project_id_              ,
                                                                     invent_stock_proj_id_    ,
                                                                     part_ownership_db_       ,
                                                                     owning_customer_no_      ,
                                                                     owning_vendor_no_        ,
                                                                     source_ref_type_db_      ,
                                                                     source_part_ownership_db_,
                                                                     source_owner_            ); 
      $ELSE
         NULL;
      $END                                                        
   END IF;   
   RETURN Fnd_Boolean_API.DB_FALSE;
END Check_Man_Reservation_Valid;


-- Update_Reserve_On_Reassign
--   This will update reservation quantities when do reassign.
--   If the source uses semi centralized reservation then this procedure is not needed.  
PROCEDURE Update_Reserve_On_Reassign (
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref3_          IN VARCHAR2,
   source_ref4_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
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
   qty_assigned_         IN NUMBER, 
   qty_picked_           IN NUMBER,
   catch_qty_            IN NUMBER,
   reassignment_type_    IN VARCHAR2 )
IS  
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Update_Qty(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                   contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                                   eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                   handling_unit_id_, pick_list_no_, configuration_id_,
                                                   shipment_id_, qty_assigned_, qty_picked_, catch_qty_, reassignment_type_);    
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;    
END Update_Reserve_On_Reassign;


FUNCTION Lock_And_Fetch_Reserve_Info (    
   source_ref1_            IN  VARCHAR2,
   source_ref2_            IN  VARCHAR2,
   source_ref3_            IN  VARCHAR2,
   source_ref4_            IN  VARCHAR2,
   source_ref_type_db_     IN  VARCHAR2,
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
   shipment_id_            IN  NUMBER ) RETURN Reserve_Shipment_API.Public_Reservation_Rec
IS 
   public_reservation_rec_   Reserve_Shipment_API.Public_Reservation_Rec;   
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Lock_And_Fetch_Info(public_reservation_rec_, source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                            contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                                            eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                            handling_unit_id_, pick_list_no_, configuration_id_, shipment_id_);    
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;  
   RETURN public_reservation_rec_;
END Lock_And_Fetch_Reserve_Info;


-- New_Reservation
--   This will add new record in reservation table.
--   If the source uses semi centralized reservation then this procedure is not needed. 
PROCEDURE New_Reservation (
   source_ref1_              IN VARCHAR2,
   source_ref2_              IN VARCHAR2,
   source_ref3_              IN VARCHAR2,
   source_ref4_              IN VARCHAR2,
   source_ref_type_db_       IN VARCHAR2, 
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
   preliminary_pick_list_no_ IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   new_shipment_id_          IN NUMBER,
   qty_assigned_             IN NUMBER,
   qty_picked_               IN NUMBER,
   catch_qty_                IN NUMBER,
   qty_shipped_              IN NUMBER,
   input_qty_                IN NUMBER,
   input_unit_meas_          IN VARCHAR2,
   input_conv_factor_        IN NUMBER,
   input_variable_values_    IN VARCHAR2,
   reassignment_type_        IN VARCHAR2,
   move_to_ship_location_    IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.New(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                            contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                            eng_chg_level_, waiv_dev_rej_no_, activity_seq_, 
                                            handling_unit_id_, pick_list_no_, configuration_id_, new_shipment_id_,  
                                            qty_assigned_, qty_picked_, qty_shipped_, 
                                            input_qty_, input_unit_meas_, input_conv_factor_, input_variable_values_,
                                            preliminary_pick_list_no_, catch_qty_, reassignment_type_,
                                            move_to_ship_location_);    
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;      
END New_Reservation;

-- Remove_Reservation
--   This will remove reservation table record.
--   If the source uses semi centralized reservation then this procedure is not needed. 
PROCEDURE Remove_Reservation (
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   source_ref4_           IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2,
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
   reassignment_type_     IN VARCHAR2,
   move_to_ship_location_ IN VARCHAR2 )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Remove(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                               contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                               eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                               handling_unit_id_, pick_list_no_, configuration_id_, shipment_id_,
                                               reassignment_type_, move_to_ship_location_);    
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;    
END Remove_Reservation;


-- Reservation_Exists
--   If the source uses semi centralized reservation then this procedure is not needed. 
@UncheckedAccess
FUNCTION Reservation_Exists (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2, 
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   location_no_        IN VARCHAR2,   
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN NUMBER ) RETURN VARCHAR2
IS
   reservation_exist_   VARCHAR2(5):= 'FALSE';
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF Customer_Order_Reservation_API.Exists (source_ref1_, source_ref2_, source_ref3_, source_ref4_, contract_,
                                                   part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                   handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_) THEN
            reservation_exist_ := 'TRUE';                                       
         END IF; 
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN reservation_exist_;   
END Reservation_Exists;


-- Reservation_Exist
--   If the source uses semi centralized reservation then this procedure is not needed. 
PROCEDURE Reservation_Exist (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2, 
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   location_no_        IN VARCHAR2,   
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   pick_list_no_       IN VARCHAR2,
   shipment_id_        IN NUMBER ) 
IS    
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Exist(source_ref1_, source_ref2_, source_ref3_, source_ref4_, contract_,
                                              part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                              handling_unit_id_, configuration_id_, pick_list_no_, shipment_id_);                                                 
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;       
END Reservation_Exist;


-- Reduce_Reserve_On_Reassign
--   If the source uses semi centralized reservation then this procedure is not needed. 
PROCEDURE Reduce_Reserve_On_Reassign (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2, 
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
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Reduce_Reserve_Qty(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                           contract_, part_no_, location_no_, lot_batch_no_, serial_no_,
                                                           eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                           handling_unit_id_, configuration_id_, qty_to_reassign_, picked_qty_to_reassign_);    
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;      
END Reduce_Reserve_On_Reassign;


@UncheckedAccess
FUNCTION Get_Total_Qty_Reserved (  
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2, 
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
BEGIN
   IF(source_ref_type_db_= Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         total_qty_reserved_ := Customer_Order_Reservation_API.Get_Total_Qty_Reserved (order_no_         => source_ref1_,
                                                                                       line_no_          => source_ref2_,
                                                                                       rel_no_           => source_ref3_,
                                                                                       line_item_no_     => source_ref4_,
                                                                                       contract_         => contract_,
                                                                                       part_no_          => part_no_,
                                                                                       configuration_id_ => configuration_id_,
                                                                                       location_no_      => location_no_,
                                                                                       lot_batch_no_     => lot_batch_no_,
                                                                                       serial_no_        => serial_no_,
                                                                                       eng_chg_level_    => eng_chg_level_,
                                                                                       waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                       activity_seq_     => activity_seq_,
                                                                                       handling_unit_id_ => handling_unit_id_,
                                                                                       shipment_id_      => shipment_id_ );
      $ELSE
         NULL; 
      $END
   END IF;  
   RETURN total_qty_reserved_;
END Get_Total_Qty_Reserved;


----------------------- PICKING SPECIFIC PUBLIC METHODS ---------------------

-- TO_DO_LIME : This procedure should be revisited after making pick list generic.
@UncheckedAccess
FUNCTION Create_Pick_List_Allowed (
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER
IS
   allowed_             NUMBER := 0;
BEGIN   
   IF(source_ref_type_db_= Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         allowed_ := Create_Pick_List_API.Create_Pick_List_Allowed(shipment_id_);
         IF(allowed_ = 1) THEN
            RETURN allowed_;               
         END IF;
      $ELSE
         NULL; 
      $END
   END IF;             
   RETURN allowed_;    
END Create_Pick_List_Allowed;

-- Create_Shipment_Pick_Lists___
--   Create pick list for the shipment.
--   TO_DO_LIME : This procedure should be revisited after making pick list generic.
PROCEDURE Create_Shipment_Pick_Lists (
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2)
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;   
BEGIN   
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            DECLARE
               pick_list_no_list_      Create_Pick_List_API.Pick_List_Table;
            BEGIN
               Create_Pick_List_API.Create_Shipment_Pick_Lists__(pick_list_no_list_, shipment_id_, NULL, TRUE);
            END;
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER'); 
         $END
      END IF;             
   END LOOP;     
END Create_Shipment_Pick_Lists;


@UncheckedAccess
FUNCTION Print_Pick_List_Allowed (
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER
IS    
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;  
   allowed_                NUMBER := 0;
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);    
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            allowed_ := Pick_Customer_Order_API.Print_Pick_List_Allowed(shipment_id_);
            IF(allowed_ = 1) THEN
               RETURN allowed_;               
            END IF;
         $ELSE
            NULL; 
         $END                   
      END IF;             
   END LOOP; 
   RETURN allowed_;
END Print_Pick_List_Allowed;
          

PROCEDURE Print_Pick_List (
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2) 
IS    
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;    
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Pick_Customer_Order_API.Print_Pick_List(shipment_id_);            
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER'); 
         $END
      END IF;             
   END LOOP;     
END Print_Pick_List;


-- TO_DO_LIME : This procedure should be revisited after making pick list generic.
@UncheckedAccess
FUNCTION Pick_Report_Ship_Allowed (
   shipment_id_                     IN NUMBER,
   source_ref_type_db_              IN VARCHAR2,
   report_pick_from_source_lines_   IN VARCHAR2 DEFAULT 'FALSE') RETURN NUMBER
IS
   source_ref_type_list_     Utility_SYS.STRING_TABLE;
   num_sources_              NUMBER;  
   pick_report_ship_allowed_ NUMBER := 0;
BEGIN   
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            IF(Pick_Customer_Order_API.Pick_Report_Ship_Allowed(shipment_id_, report_pick_from_source_lines_) = 1) THEN
               pick_report_ship_allowed_ := 1;        
            END IF;
         $ELSE
            NULL; 
         $END
      END IF;             
   END LOOP; 
   RETURN pick_report_ship_allowed_; 
END Pick_Report_Ship_Allowed;

@UncheckedAccess
FUNCTION Enforce_Report_Pick_From_Lines (
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   receipt_issue_serial_track_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enforce_report_pick_from_lines_ VARCHAR2(5) := 'TRUE';
BEGIN   
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN 
      $IF Component_Shipod_SYS.INSTALLED $THEN
         enforce_report_pick_from_lines_ := Shipment_Ord_Utility_API.Enforce_Report_Pick_From_Lines(TO_NUMBER(source_ref1_),
                                                                                                    TO_NUMBER(source_ref2_),
                                                                                                    receipt_issue_serial_track_);
      $ELSE
         NULL;
      $END
   END IF;   
   RETURN enforce_report_pick_from_lines_; 
END Enforce_Report_Pick_From_Lines;

-- Report_Shipment_Pick_Lists___
--   Report picking shipment pick list.
--   TO_DO_LIME : This procedure should be revisited after making pick list generic.
PROCEDURE Report_Shipment_Pick_Lists (
   shipment_id_         IN NUMBER,
   location_no_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
               Pick_Customer_Order_API.Pick_Report_Shipment__(shipment_id_, location_no_);
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER'); 
         $END
      END IF;             
   END LOOP;   
END Report_Shipment_Pick_Lists;   

                          
-- Remove_Picked_Line
--   This removes a picked line from the shipment.
PROCEDURE Remove_Picked_Line (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 )
IS 
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Remove_Picked_Line(shipment_id_,
                                                       source_ref1_,
                                                       source_ref2_,
                                                       source_ref3_,
                                                       source_ref4_ );
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END   
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN  
      Error_SYS.Record_General(lu_name_, 'CANNTREMPICKPD: Project deliverable shipment lines which are already picked cannot be deleted from the shipment.'); 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN  
      Error_SYS.Record_General(lu_name_, 'CANNTREMPICKSO: Shipment order lines which are already picked cannot be deleted from the shipment.');
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      Error_SYS.Record_General(lu_name_, 'CANNTREMPICKRR: Purchase receipt return lines which are already picked cannot be deleted from the shipment.');
   END IF;   
END Remove_Picked_Line;


-- Check_Pick_List_Exist
--   Check pick list exist.
@UncheckedAccess
FUNCTION Check_Pick_List_Exist (
   shipment_id_        IN NUMBER,
   ship_location_      IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Pick_List_API.Check_Pick_List_Exist(shipment_id_, ship_location_);      
      $ELSE
         NULL;
      $END
   END IF;  
   RETURN NULL;  
END Check_Pick_List_Exist;  

@UncheckedAccess
FUNCTION Blocked_Sources_Exist_For_Pick(
   shipment_id_         IN NUMBER,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;   
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            RETURN Shipment_Order_Utility_API.Blocked_Orders_Exist_For_Pick(shipment_id_);             
         $ELSE
            NULL; 
         $END
      END IF;             
   END LOOP;   
   RETURN Fnd_Boolean_API.DB_FALSE;
END Blocked_Sources_Exist_For_Pick;


@UncheckedAccess
FUNCTION Unreported_Pick_Lists_Exist (
   shipment_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   unreported_pick_lists_exist_ VARCHAR2(5) := 'FALSE';
   source_ref_type_list_        Utility_SYS.STRING_TABLE;
   num_sources_                 NUMBER;
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, Shipment_API.Get_Source_Ref_Type_Db(shipment_id_));
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            -- This was done to check the picking from the reservation level instead of the pick list header level.
            unreported_pick_lists_exist_ := Customer_Order_Reservation_API.Unreported_Pick_Lists_Exist(shipment_id_); 
         $ELSE
            NULL;
         $END
      END IF; 
   END LOOP; 
   RETURN NVL(unreported_pick_lists_exist_, 'FALSE');
END Unreported_Pick_Lists_Exist;


PROCEDURE Modify_Reservation_Qty_Picked (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2,
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
   remaining_qty_assigned_ IN NUMBER,
   qty_picked_             IN NUMBER,
   catch_qty_              IN NUMBER,
   input_qty_              IN NUMBER,
   input_unit_meas_        IN VARCHAR2,
   input_conv_factor_      IN NUMBER,
   input_variable_values_  IN VARCHAR2,
   move_to_ship_location_  IN VARCHAR2,
   ship_handling_unit_id_  IN NUMBER DEFAULT NULL)
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Reservation_API.Modify_Qty_Picked(order_no_               => source_ref1_,      
                                                          line_no_                => source_ref2_,          
                                                          rel_no_                 => source_ref3_,           
                                                          line_item_no_           => source_ref4_,
                                                          contract_               => contract_, 
                                                          part_no_                => part_no_,          
                                                          location_no_            => location_no_, 
                                                          lot_batch_no_           => lot_batch_no_,
                                                          serial_no_              => serial_no_,     
                                                          eng_chg_level_          => eng_chg_level_,    
                                                          waiv_dev_rej_no_        => waiv_dev_rej_no_,  
                                                          activity_seq_           => activity_seq_,
                                                          handling_unit_id_       => handling_unit_id_,
                                                          pick_list_no_           => pick_list_no_,     
                                                          configuration_id_       => configuration_id_, 
                                                          shipment_id_            => shipment_id_, 
                                                          qty_picked_             => qty_picked_,
                                                          catch_qty_              => catch_qty_,          
                                                          input_qty_              => input_qty_,
                                                          input_unit_meas_        => input_unit_meas_,           
                                                          input_conv_factor_      => input_conv_factor_,              
                                                          input_variable_values_  => input_variable_values_,
                                                          move_to_ship_location_  => move_to_ship_location_,
                                                          remaining_qty_assigned_ => remaining_qty_assigned_,
                                                          ship_handling_unit_id_  => ship_handling_unit_id_ );
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;                                                             
END Modify_Reservation_Qty_Picked;


PROCEDURE Post_Scrap_Return_In_Ship_Inv (  
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   quantity_           IN NUMBER,
   configuration_id_   IN VARCHAR2 DEFAULT NULL,
   to_location_no_     IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_       IN VARCHAR2 DEFAULT NULL,
   serial_no_          IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_      IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_    IN VARCHAR2 DEFAULT NULL,
   activity_seq_       IN NUMBER   DEFAULT NULL,
   handling_unit_id_   IN NUMBER   DEFAULT NULL,
   catch_qty_returned_ IN NUMBER   DEFAULT NULL,
   shipment_id_        IN NUMBER   DEFAULT NULL,
   qty_reserved_       IN NUMBER   DEFAULT NULL )  
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Pick_Customer_Order_API.Post_Scrap_Return_In_Ship_Inv(source_ref1_, source_ref2_, source_ref3_, source_ref4_, quantity_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN         
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Undo_Return(source_ref1_            => source_ref1_,
                                                   source_ref2_            => source_ref2_,
                                                   source_ref3_            => source_ref3_,
                                                   source_ref4_            => source_ref4_,
                                                   source_ref_type_db_     => source_ref_type_db_,
                                                   transaction_id_         => NULL,
                                                   configuration_id_       => configuration_id_,
                                                   location_no_            => to_location_no_,
                                                   lot_batch_no_           => lot_batch_no_,
                                                   serial_no_              => serial_no_,
                                                   eng_chg_level_          => eng_chg_level_,
                                                   waiv_dev_rej_no_        => waiv_dev_rej_no_,
                                                   activity_seq_           => activity_seq_,
                                                   handling_unit_id_       => handling_unit_id_,
                                                   inv_qty_corrected_      => quantity_,
                                                   catch_qty_corrected_    => catch_qty_returned_,
                                                   shipment_id_            => shipment_id_,
                                                   qty_reserved_           => qty_reserved_);
      $ELSE
         NULL;
      $END
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Post_Return_In_Ship_Inv(source_ref1_,
                                                          source_ref2_,
                                                          quantity_,
                                                          configuration_id_,
                                                          to_location_no_,
                                                          lot_batch_no_,
                                                          serial_no_,
                                                          eng_chg_level_,
                                                          waiv_dev_rej_no_,
                                                          activity_seq_,
                                                          handling_unit_id_,
                                                          catch_qty_returned_,
                                                          shipment_id_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   END IF;    
END Post_Scrap_Return_In_Ship_Inv;

PROCEDURE Validate_Return_From_Ship_Inv (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   qty_returned_       IN NUMBER )
IS   
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Pick_Customer_Order_API.Validate_Return_From_Ship_Inv(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                               lot_batch_no_, serial_no_, qty_returned_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;     
END Validate_Return_From_Ship_Inv;


PROCEDURE Modify_Pick_Ship_Location (
   shipment_id_                IN NUMBER,
   source_ref_type_db_         IN VARCHAR2,
   ship_inventory_location_no_ IN VARCHAR2 )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Pick_List_API.Modify_Pick_Ship_Location(shipment_id_, ship_inventory_location_no_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;     
END  Modify_Pick_Ship_Location ;  

FUNCTION Get_Total_Qty_On_Pick_List (  
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
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
BEGIN
   IF(source_ref_type_db_= Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         total_qty_on_pick_list_ := Customer_Order_Reservation_API.Get_Total_Qty_On_Pick_List (order_no_         => source_ref1_,
                                                                                               line_no_          => source_ref2_,
                                                                                               rel_no_           => source_ref3_,
                                                                                               line_item_no_     => source_ref4_,
                                                                                               contract_         => contract_,
                                                                                               part_no_          => part_no_,
                                                                                               configuration_id_ => configuration_id_,
                                                                                               location_no_      => location_no_,
                                                                                               lot_batch_no_     => lot_batch_no_,
                                                                                               serial_no_        => serial_no_,
                                                                                               eng_chg_level_    => eng_chg_level_,
                                                                                               waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                                                               activity_seq_     => activity_seq_,
                                                                                               handling_unit_id_ => handling_unit_id_,
                                                                                               shipment_id_      => shipment_id_ );
      $ELSE
         NULL; 
      $END
   END IF;  
   RETURN total_qty_on_pick_list_;
END Get_Total_Qty_On_Pick_List;


----------------------- PACKING SPECIFIC PUBLIC METHODS ---------------------

-- This method is used by DataCapPackIntoHuShip
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                      IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   parent_consol_shipment_id_     IN NUMBER,
   source_ref1_                   IN VARCHAR2,
   source_ref2_                   IN VARCHAR2,
   source_ref3_                   IN VARCHAR2,
   source_ref4_                   IN VARCHAR2,
   source_ref_type_db_            IN VARCHAR2,
   pick_list_no_                  IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   configuration_id_              IN VARCHAR2,
   location_no_                   IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2,
   serial_no_                     IN VARCHAR2,
   waiv_dev_rej_no_               IN VARCHAR2,
   eng_chg_level_                 IN VARCHAR2,
   activity_seq_                  IN NUMBER,
   handling_unit_id_              IN NUMBER,  -- NOTE: This is inventory/reservation handling unit and not shipment handling unit
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2, 
   capture_session_id_            IN NUMBER,
   column_name_                   IN VARCHAR2,
   lov_type_db_                   IN VARCHAR2,
   sql_where_expression_          IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values       IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(8000);
   TYPE Lov_Value_Tab        IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_            Lov_Value_Tab;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_item_description_     VARCHAR2(200);
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
   local_shipment_id_        NUMBER;
   local_source_ref_type_db_ VARCHAR2(20);
   shp_rec_                  Shipment_API.Public_Rec;
   temp_handling_unit_id_    NUMBER;
BEGIN

   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);
      
      -- Extra column check to be sure we have no risk for sql injection into column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('SHIPMENT_SOURCE_RESERVATION', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_  || ' FROM SHIPMENT_SOURCE_RESERVATION ';
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' WHERE :shipment_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' WHERE shipment_id = :shipment_id_';
      END IF;
      IF source_ref1_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref1_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_';
      END IF;
      IF source_ref2_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref2_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_';
      END IF;
      IF source_ref3_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND source_ref3 is NULL AND :source_ref3_ IS NULL';
      ELSIF source_ref3_ = '%' THEN
         stmt_ := stmt_ || ' AND :source_ref3_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_';
      END IF;
      IF source_ref4_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND source_ref4 is NULL AND :source_ref4_ IS NULL';
      ELSIF source_ref4_ = '%' THEN
         stmt_ := stmt_ || ' AND :source_ref4_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND source_ref4 = :source_ref4_';
      END IF;
      IF source_ref_type_db_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :source_ref_type_db_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND source_ref_type_db = :source_ref_type_db_';
      END IF;
      IF pick_list_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :pick_list_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND pick_list_no = :pick_list_no_';
      END IF;
      IF part_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :part_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND part_no = :part_no_';
      END IF;
      IF configuration_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
      END IF;
      IF location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND location_no = :location_no_';
      END IF;
      IF lot_batch_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
      END IF;
      IF serial_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND serial_no = :serial_no_';
      END IF;
      IF waiv_dev_rej_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
      END IF;
      IF eng_chg_level_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
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
      stmt_ := stmt_  || ' AND   contract                                       = :contract_
                           AND   pick_list_no                                   != ''*''
                           AND   qty_picked                                     > 0
                           AND   shipment_id                                    != 0
                           AND   Shipment_API.Get_Objstate(shipment_id)            = ''Preliminary''
                           AND   Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(shipment_id) = ''TRUE''';
      
      IF (sql_where_expression_ IS NOT NULL) THEN
       stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
      
      @ApproveDynamicStatement(2017-12-19,SURBLK)
      OPEN get_lov_values_ FOR stmt_ USING shipment_id_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref_type_db_,
                                           pick_list_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           waiv_dev_rej_no_,
                                           eng_chg_level_,
                                           activity_seq_,
                                           handling_unit_id_,
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
         ELSIF (column_name_ IN ('SSCC')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_SSCC';
         ELSIF (column_name_ IN ('ALT_HANDLING_UNIT_LABEL_ID')) THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESCRIPTION_ALT';
         ELSIF (column_name_ IN ('SHIPMENT_ID')) THEN
               second_column_name_ := 'RECEIVER_NAME_SHP';
         ELSIF (column_name_ IN ('PART_NO')) THEN
               second_column_name_ := 'PART_DESCRIPTION';
         ELSIF (column_name_ IN ('SOURCE_REF1')) THEN
               second_column_name_ := 'CUSTOMER_NAME';
         ELSIF (column_name_ IN ('LOCATION_NO')) THEN
               second_column_name_ := 'LOCATION_DESC';
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
                     shp_rec_ := Shipment_API.Get(lov_value_tab_(i));
                     second_column_value_ := Get_Receiver_Name(shp_rec_.receiver_id, shp_rec_.receiver_type);
                  ELSIF (second_column_name_ = 'PART_DESCRIPTION') THEN
                     local_source_ref_type_db_ := Get_Column_Value_If_Unique(contract_                      => contract_,
                                                                             shipment_id_                   => shipment_id_,
                                                                             parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                                             source_ref1_                   => source_ref1_,
                                                                             source_ref2_                   => source_ref2_,
                                                                             source_ref3_                   => source_ref3_,
                                                                             source_ref4_                   => source_ref4_,
                                                                             source_ref_type_db_            => source_ref_type_db_,
                                                                             pick_list_no_                  => pick_list_no_,
                                                                             part_no_                       => lov_value_tab_(i),
                                                                             configuration_id_              => configuration_id_,
                                                                             location_no_                   => location_no_,
                                                                             lot_batch_no_                  => lot_batch_no_,
                                                                             serial_no_                     => serial_no_,
                                                                             waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                                                             eng_chg_level_                 => eng_chg_level_,
                                                                             activity_seq_                  => activity_seq_,
                                                                             handling_unit_id_              => handling_unit_id_,
                                                                             sscc_                          => sscc_,
                                                                             alt_handling_unit_label_id_    => alt_handling_unit_label_id_,
                                                                             column_name_                   => 'SOURCE_REF_TYPE_DB',
                                                                             sql_where_expression_          => sql_where_expression_);
                     second_column_value_ := Get_Source_Part_Desc(contract_            => contract_,
                                                                  source_part_no_      => lov_value_tab_(i),
                                                                  lang_code_           => NULL,
                                                                  source_ref_type_db_  => local_source_ref_type_db_);
                  ELSIF (second_column_name_ = 'CUSTOMER_NAME') THEN
                     local_shipment_id_ :=  Get_Column_Value_If_Unique(contract_                      => contract_,
                                                                       shipment_id_                   => shipment_id_,
                                                                       parent_consol_shipment_id_     => parent_consol_shipment_id_,
                                                                       source_ref1_                   => lov_value_tab_(i),
                                                                       source_ref2_                   => source_ref2_,
                                                                       source_ref3_                   => source_ref3_,
                                                                       source_ref4_                   => source_ref4_,
                                                                       source_ref_type_db_            => source_ref_type_db_,
                                                                       pick_list_no_                  => pick_list_no_,
                                                                       part_no_                       => part_no_,
                                                                       configuration_id_              => configuration_id_,
                                                                       location_no_                   => location_no_,
                                                                       lot_batch_no_                  => lot_batch_no_,
                                                                       serial_no_                     => serial_no_,
                                                                       waiv_dev_rej_no_               => waiv_dev_rej_no_,
                                                                       eng_chg_level_                 => eng_chg_level_,
                                                                       activity_seq_                  => activity_seq_,
                                                                       handling_unit_id_              => handling_unit_id_,
                                                                       sscc_                          => sscc_,
                                                                       alt_handling_unit_label_id_    => alt_handling_unit_label_id_,
                                                                       column_name_                   => 'SHIPMENT_ID',
                                                                       sql_where_expression_          => sql_where_expression_);
                     shp_rec_ := Shipment_API.Get(local_shipment_id_);
                     second_column_value_ := Get_Receiver_Name(shp_rec_.receiver_id, shp_rec_.receiver_type);
                  ELSIF (second_column_name_ = 'LOCATION_DESC') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                     IF (second_column_value_ IS NOT NULL) THEN
                        second_column_value_ := second_column_value_ || ' | ' || Inventory_Location_API.Get_Location_Type(contract_, lov_value_tab_(i));  
                     ELSE
                       second_column_value_ := Inventory_Location_API.Get_Location_Type(contract_, lov_value_tab_(i));
                     END IF;
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


-- This method is used by DataCapPackIntoHuShip
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_                   IN VARCHAR2,
   shipment_id_                IN NUMBER,
   parent_consol_shipment_id_  IN NUMBER,
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   pick_list_no_               IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,  -- NOTE: This is inventory/reservation handling unit and not shipment handling unit
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(8000);
   unique_column_value_           VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab; 
BEGIN
   Assert_SYS.Assert_Is_View_Column('SHIPMENT_SOURCE_RESERVATION', column_name_);
   stmt_ := 'SELECT DISTINCT ' || column_name_ || '
             FROM SHIPMENT_SOURCE_RESERVATION ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE shipment_id = :shipment_id_';
   END IF;
   IF source_ref1_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref1_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_';
   END IF;
   IF source_ref2_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref2_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_';
   END IF;
   IF source_ref3_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND source_ref3 is NULL AND :source_ref3_ IS NULL';
   ELSIF source_ref3_ = '%' THEN
      stmt_ := stmt_ || ' AND :source_ref3_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_';
   END IF;
   IF source_ref4_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND source_ref4 is NULL AND :source_ref4_ IS NULL';
   ELSIF source_ref4_ = '%' THEN
      stmt_ := stmt_ || ' AND :source_ref4_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND source_ref4 = :source_ref4_';
   END IF;
   IF source_ref_type_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref_type_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref_type_db = :source_ref_type_db_';
   END IF;
   IF pick_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :pick_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND pick_list_no = :pick_list_no_';
   END IF;
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
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
   stmt_ := stmt_  || ' AND   contract                            = :contract_
             AND   pick_list_no                                   != ''*''
             AND   qty_picked                                     > 0
             AND   shipment_id                                    != 0
             AND   Shipment_API.Get_Objstate(shipment_id)            = ''Preliminary''
             -- Do not show shipments that doesnt have any handling units
             AND   Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(shipment_id) = ''TRUE''
             -- Do not show anything that is already connected
             AND  (qty_assigned - NVL(Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(source_ref1,NVL(source_ref2,''*''),NVL(source_ref3,''*''),NVL(source_ref4,''*''),source_ref_type_db,contract,part_no,location_no,lot_batch_no,serial_no,eng_chg_level,waiv_dev_rej_no,activity_seq,handling_unit_id,configuration_id,pick_list_no,shipment_id), 0)) > 0
             -- Picked vs Packed Qty. Will also filter make sure that the order/shipment connection exists.
             AND   Shipment_Handling_Utility_API.Get_Packing_Qty_Deviation(source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type_db, shipment_id) > 0 ';


   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2017-12-19,SURBLK)
   OPEN get_column_values_ FOR stmt_ USING shipment_id_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref_type_db_,
                                           pick_list_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           waiv_dev_rej_no_,
                                           eng_chg_level_,
                                           activity_seq_,
                                           handling_unit_id_,
                                           sscc_,
                                           alt_handling_unit_label_id_,
                                           contract_;
   
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
      END IF;
   CLOSE get_column_values_;

   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCapPackIntoHuShip
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_                      IN VARCHAR2,
   shipment_id_                   IN NUMBER,
   parent_consol_shipment_id_     IN NUMBER,
   source_ref1_                   IN VARCHAR2,
   source_ref2_                   IN VARCHAR2,
   source_ref3_                   IN VARCHAR2,
   source_ref4_                   IN VARCHAR2,
   source_ref_type_db_            IN VARCHAR2,
   pick_list_no_                  IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   configuration_id_              IN VARCHAR2,
   location_no_                   IN VARCHAR2,
   lot_batch_no_                  IN VARCHAR2,
   serial_no_                     IN VARCHAR2,
   waiv_dev_rej_no_               IN VARCHAR2,
   eng_chg_level_                 IN VARCHAR2,
   activity_seq_                  IN NUMBER,
   handling_unit_id_              IN NUMBER,  -- NOTE: This is inventory/reservation handling unit and not shipment handling unit
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2, 
   column_name_                   IN VARCHAR2,
   column_value_                  IN VARCHAR2,
   column_description_            IN VARCHAR2,
   sql_where_expression_          IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(8000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN

   Assert_SYS.Assert_Is_View_Column('SHIPMENT_SOURCE_RESERVATION', column_name_);

   stmt_ := ' SELECT 1
              FROM  SHIPMENT_SOURCE_RESERVATION ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' WHERE :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' WHERE shipment_id = :shipment_id_';
   END IF;
   IF source_ref1_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref1_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref1 = :source_ref1_';
   END IF;
   IF source_ref2_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref2_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref2 = :source_ref2_';
   END IF;
   IF source_ref3_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND source_ref3 is NULL AND :source_ref3_ IS NULL';
   ELSIF source_ref3_ = '%' THEN
      stmt_ := stmt_ || ' AND :source_ref3_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND source_ref3 = :source_ref3_';
   END IF;
   IF source_ref4_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND source_ref4 is NULL AND :source_ref4_ IS NULL';
   ELSIF source_ref4_ = '%' THEN
      stmt_ := stmt_ || ' AND :source_ref4_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND source_ref4 = :source_ref4_';
   END IF;
   IF source_ref_type_db_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :source_ref_type_db_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND source_ref_type_db = :source_ref_type_db_';
   END IF;
   IF pick_list_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :pick_list_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND pick_list_no = :pick_list_no_';
   END IF;
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
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
   stmt_ := stmt_  || ' AND   contract                             = :contract_
              AND   pick_list_no                                   != ''*''
              AND   qty_picked                                     > 0
              AND   shipment_id                                    != 0
              AND   Shipment_API.Get_Objstate(shipment_id)            = ''Preliminary''
              -- Do not show shipments that doesnt have any handling units
              AND   Handling_Unit_Ship_Util_API.Shipment_Has_Hu_Connected(shipment_id) = ''TRUE''
              -- Do not show anything that is already connected
              AND  (qty_assigned - NVL(Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(source_ref1,NVL(source_ref2,''*''),NVL(source_ref3,''*''),NVL(source_ref4,''*''),source_ref_type_db,contract,part_no,location_no,lot_batch_no,serial_no,eng_chg_level,waiv_dev_rej_no,activity_seq,handling_unit_id,configuration_id,pick_list_no,shipment_id), 0)) > 0
              -- Picked vs Packed Qty. Will also filter make sure that the order/shipment connection exists.
              AND   Shipment_Handling_Utility_API.Get_Packing_Qty_Deviation(source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type_db, shipment_id) > 0 
              AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   
   IF (sql_where_expression_ IS NOT NULL) THEN
    stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   @ApproveDynamicStatement(2017-12-19,SURBLK)
   OPEN exist_control_ FOR stmt_ USING shipment_id_,
                                       source_ref1_,
                                       source_ref2_,
                                       source_ref3_,
                                       source_ref4_,
                                       source_ref_type_db_,
                                       pick_list_no_,
                                       part_no_,
                                       configuration_id_,
                                       location_no_,
                                       lot_batch_no_,
                                       serial_no_,
                                       waiv_dev_rej_no_,
                                       eng_chg_level_,
                                       activity_seq_,
                                       handling_unit_id_,
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
      Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);
   END IF;
END Record_With_Column_Value_Exist;


PROCEDURE Validate_Reassign_Hu (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   handling_unit_id_    IN NUMBER,
   source_part_no_      IN VARCHAR2 )
IS 
BEGIN      
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.Validate_Reassign_Hu(source_ref1_, source_ref2_, source_ref3_, source_ref4_,
                                                         handling_unit_id_, source_part_no_ );     
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;    
END Validate_Reassign_Hu;



----------------------- DELIVERY SPECIFIC PUBLIC METHODS --------------------

PROCEDURE Post_Del_Note_Invalid_Action (
   delnote_no_          IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2 )
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
BEGIN  
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Customer_Order_Reservation_API.Disconn_Reserve_From_Delnote(delnote_no_);
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END
      -- ELSE handle other sources
      END IF; 
   END LOOP;   
END Post_Del_Note_Invalid_Action;


PROCEDURE Post_Create_Deliv_Note(
   delnote_no_          IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2)
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
BEGIN  
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Deliver_Customer_Order_API.Connect_Ship_Deliv_Note(delnote_no_); 
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END
      -- ELSE handle other sources
      END IF; 
   END LOOP;      
END Post_Create_Deliv_Note;


@UncheckedAccess
FUNCTION Valid_Ship_Deliv_Line (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,  
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS   
   public_line_rec_  Public_Line_Rec;
BEGIN
   public_line_rec_ := Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN         
         IF(public_line_rec_.rowstate  NOT IN ('Cancelled') AND  public_line_rec_.supply_code NOT IN ('PD', 'IPD') AND public_line_rec_.source_ref4 <= 0) THEN
            RETURN Fnd_Boolean_API.DB_TRUE;
         ELSE
            RETURN Fnd_Boolean_API.DB_FALSE;
         END IF;           
      $ELSE
         NULL;
      $END       
   END IF;
   RETURN Fnd_Boolean_API.DB_TRUE;
END Valid_Ship_Deliv_Line;


@UncheckedAccess
FUNCTION Get_Reserv_Info_On_Delivered(
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2,
   source_ref3_          IN VARCHAR2,
   source_ref4_          IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2,
   shipment_id_          IN NUMBER ) RETURN Reservation_Tab
IS
   CURSOR get_reserv_info_on_delivered IS
      SELECT lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, expiration_date, qty_shipped, handling_unit_id, activity_seq
      FROM   shipment_source_reservation
      WHERE  source_ref1        = source_ref1_
      AND    source_ref2        = NVL(source_ref2_, '*')
      AND    source_ref3        = NVL(source_ref3_, '*')
      AND    source_ref4        = NVL(source_ref4_, '*')
      AND    source_ref_type_db = source_ref_type_db_
      AND    shipment_id        = shipment_id_
      AND    (qty_shipped > 0);        
   reservation_tab_   Reservation_Tab;
BEGIN
   OPEN  get_reserv_info_on_delivered;
   FETCH get_reserv_info_on_delivered BULK COLLECT INTO reservation_tab_;
   CLOSE get_reserv_info_on_delivered;
   RETURN reservation_tab_;
END Get_Reserv_Info_On_Delivered;


PROCEDURE Pre_Deliver_Shipment (
   deliver_allowed_ OUT VARCHAR2,
   shipment_id_     IN  NUMBER )
IS  
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
BEGIN  
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, Shipment_API.Get_Source_Ref_Type_Db(shipment_id_));
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Deliver_Customer_Order_API.Pre_Deliver_Shipment(deliver_allowed_, shipment_id_); 
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END
      ELSIF (source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
         $IF Component_Prjdel_SYS.INSTALLED $THEN
            deliver_allowed_ := Fnd_Boolean_API.DB_TRUE;
         $ELSE
            Error_SYS.Component_Not_Exist('PRJDEL');
         $END
      ELSIF (source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
         $IF Component_Shipod_SYS.INSTALLED $THEN
            deliver_allowed_ := Fnd_Boolean_API.DB_TRUE;
         $ELSE
            Error_SYS.Component_Not_Exist('SHIPOD');
         $END
      ELSIF (source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
         $IF Component_Rceipt_SYS.INSTALLED $THEN
            deliver_allowed_ := Fnd_Boolean_API.DB_TRUE;
         $ELSE
            Error_SYS.Component_Not_Exist('RCEIPT');
         $END 
      END IF; 
   END LOOP; 
END Pre_Deliver_Shipment;


PROCEDURE Pre_Deliver_Shipment_Line (   
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,   
   qty_to_ship_        IN NUMBER,
   qty_picked_         IN NUMBER,
   shipment_id_        IN NUMBER)
IS
   quantity_   NUMBER;
BEGIN
   -- Any source specific code to update source line attributes before shipment line quantity update.
   IF source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN THEN
      IF (qty_picked_ = 0) THEN
         quantity_   := qty_to_ship_;
      ELSE
         quantity_   := qty_picked_;
      END IF;
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Create_Purchase_Transactions(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, quantity_, shipment_id_);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   END IF;  
END Pre_Deliver_Shipment_Line;


PROCEDURE Post_Deliver_Shipment (
   delnote_no_    IN VARCHAR2,
   shipment_id_   IN NUMBER )
IS
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER;
BEGIN        
   -- Creates the Handling Unit History and disconnects the Handling Units from the shipment.
   Handling_Unit_API.Create_Shipment_Hist_Snapshot(shipment_id_);
   
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, Shipment_API.Get_Source_Ref_Type_Db(shipment_id_));
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            Deliver_Customer_Order_API.Post_Deliver_Shipment(shipment_id_, delnote_no_); 
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END        
      ELSIF (source_ref_type_list_(i_) = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
         Fiscal_Note_Discom_Util_API.Create_Outgoing_Fiscal_Note(TO_CHAR(shipment_id_), 'SHIPMENT');
      END IF; 
   END LOOP;
END Post_Deliver_Shipment;


PROCEDURE Post_Deliver_Shipment_Line (   
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,   
   shipment_id_        IN NUMBER,
   qty_to_ship_        IN NUMBER,
   qty_picked_         IN NUMBER,
   transaction_code_   IN VARCHAR2 DEFAULT NULL)
IS
   qty_delivered_   NUMBER;
   non_ded_tax_percentage_       NUMBER;   

BEGIN
   -- Any source specific code to update source line attributes after the shipment line quantity update.
   -- For example inventory transaction history record creation, booking transactions, source line ship date update
   -- etc can be addressed from here.
   IF (qty_picked_ > 0  AND qty_to_ship_ = 0) THEN
      qty_delivered_ := qty_picked_;
   ELSIF (qty_to_ship_ > 0  AND qty_picked_ = 0) THEN 
      qty_delivered_ := qty_to_ship_;
   END IF;
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         Delivery_Interface_Shpmnt_API.Post_Delivery_Shipment_Line(source_ref1_, source_ref2_, source_ref3_);
      $ELSE
         NULL;
      $END
   ELSIF source_ref_type_db_ =  Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Post_Delivery_Actions(source_ref1_, source_ref2_, qty_delivered_);
         -- Calculate amounts and Taxes in Tax Document Line
         Tax_Document_Line_API.Calculate_Amounts_And_Taxes (non_ded_tax_percentage_,
                                                            transaction_code_,
                                                            qty_delivered_,
                                                            source_ref1_,
                                                            source_ref2_,
                                                            source_ref3_,
                                                            source_ref4_,
                                                            shipment_id_,
                                                            source_ref_type_db_,
                                                            TRUE);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   ELSIF source_ref_type_db_ =  Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Post_Delivery_Actions(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_, qty_to_ship_, qty_picked_);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   END IF;
END Post_Deliver_Shipment_Line; 


PROCEDURE Post_Send_Dispatch_Advice (
   source_ref1_        IN VARCHAR2,   
   source_ref_type_db_ IN VARCHAR2,
   media_code_         IN VARCHAR2 ) 
IS     
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Transfer_API.Post_Send_Dispatch_Advice(source_ref1_, media_code_);          
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END  
   END IF;       
END Post_Send_Dispatch_Advice;


FUNCTION Prioritize_Res_On_Desadv (
   shipment_id_   IN NUMBER ) RETURN BOOLEAN
IS
   prioritize_res_on_desadv_   BOOLEAN := FALSE;
BEGIN
   IF ((Shipment_API.Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = 'TRUE')) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF (Shipment_Order_Utility_API.Ipt_Within_Same_Company(shipment_id_)) THEN
            prioritize_res_on_desadv_ := TRUE;
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   END IF;   
   RETURN prioritize_res_on_desadv_;
END Prioritize_Res_On_Desadv;


PROCEDURE Get_Delivery_Transaction_Info (  
   transaction_code_             OUT VARCHAR2,
   dest_contract_                OUT VARCHAR2,
   dest_warehouse_id_            OUT VARCHAR2,
   ignore_this_avail_control_id_ OUT VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   source_ref_type_db_           IN  VARCHAR2 ) 
IS
BEGIN   
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         transaction_code_ := Delivery_Interface_Shpmnt_API.Get_Delivery_Transaction_Info;
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END    
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Get_Delivery_Transaction_Info(transaction_code_, dest_contract_, dest_warehouse_id_, ignore_this_avail_control_id_, source_ref1_);          
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END 
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Get_Delivery_Transaction_Info(transaction_code_, dest_contract_, dest_warehouse_id_, ignore_this_avail_control_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);   
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END 
   END IF;
END Get_Delivery_Transaction_Info;


PROCEDURE Pre_Undo_Deliv_Shipment_Line (   
   undo_deliver_allowed_ OUT VARCHAR2,
   source_ref1_          IN  VARCHAR2,
   source_ref2_          IN  VARCHAR2,
   source_ref3_          IN  VARCHAR2,
   source_ref4_          IN  VARCHAR2,
   source_ref_type_db_   IN  VARCHAR2,   
   qty_delivered_        IN  NUMBER,
   shipment_id_          IN  NUMBER )
IS
BEGIN
   undo_deliver_allowed_ := Fnd_Boolean_API.DB_FALSE;
   IF source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Check_Undo_Deliver_Allowed(undo_deliver_allowed_, source_ref1_, source_ref2_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   ELSIF source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Check_Undo_Deliver_Allowed(undo_deliver_allowed_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
      Check_Undo_Handling_Units___(shipment_id_);
   ELSIF source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         Delivery_Interface_Shpmnt_API.Check_Undo_Deliver_Allowed(undo_deliver_allowed_, source_ref1_, source_ref2_);
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END
   END IF;
END Pre_Undo_Deliv_Shipment_Line;


@IgnoreUnitTest NoOutParams
PROCEDURE Post_Undo_Deliv_Shipment_Line (   
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2, 
   qty_shipped_        IN NUMBER,
   shipment_id_        IN NUMBER DEFAULT 0 )
IS   
   $IF Component_Purch_SYS.INSTALLED $THEN
   CURSOR get_purch_trans_exist IS
      SELECT 1
      FROM   purchase_transaction_hist t
      WHERE  t.transaction_code IN ('NRETWORK', 'NRETWO-INT', 'NRETCREDIT', 'CO-REWORK', 'CO-RCREDT')
      AND    t.alt_source_ref1 = source_ref1_
      AND    t.alt_source_ref2 = source_ref2_
      AND    t.alt_source_ref3 = source_ref3_
      AND    t.alt_source_ref4 = source_ref4_
      AND    t.alt_source_ref_type_db = source_ref_type_db_
      AND    t.qty_reversed = 0;
   $END
BEGIN
   IF source_ref_type_db_ =  Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Post_Delivery_Actions(source_ref1_, source_ref2_, -qty_shipped_);
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END
   ELSIF source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN THEN
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         Shipment_Rcpt_Return_Util_API.Post_Undo_Delivery_Actions(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, shipment_id_, -qty_shipped_);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END
   ELSIF source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         Delivery_Interface_Shpmnt_API.Post_Undo_Del_Shipment_Line(source_ref1_, source_ref2_, source_ref3_);
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END
   END IF;
END Post_Undo_Deliv_Shipment_Line;

----------------------- REPORT SPECIFIC PUBLIC METHODS ----------------------

@UncheckedAccess
FUNCTION Get_Source_Proforma_Rpt_Info (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Source_Info_Rpt_Rec
IS      
   temp_       Source_Info_Rpt_Rec;
   line_rec_   Public_Line_Rec;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
          Shipment_Order_Utility_API.Get_Order_Proforma_Rpt_Info(temp_, source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END 
   ELSIF(source_ref_type_db_ IN (Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES, Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER , Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)) THEN    
         line_rec_                   := Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
         temp_.source_ref1           := line_rec_.source_ref1;
         temp_.buy_qty_due           := line_rec_.source_qty; 
         temp_.configuration_id      := line_rec_.configuration_id;
         temp_.ref_id                := line_rec_.ref_id;
         temp_.location_no           := line_rec_.location_no;
         temp_.dock_code             := line_rec_.dock_code;
         temp_.sub_dock_code         := line_rec_.sub_dock_code;
         temp_.reserv_lu_name        := Inventory_Part_Reservation_API.lu_name_;
   END IF;
   RETURN temp_;       
END Get_Source_Proforma_Rpt_Info;

-- Get_Source_Delivery_Rpt_Info
-- This will fetch neccessary line level information for shipment delivery note report.
-- All the source information should insert values to temp_ and return it.
@UncheckedAccess
FUNCTION Get_Source_Delivery_Rpt_Info (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Source_Info_Rpt_Rec
IS      
   temp_       Source_Info_Rpt_Rec;
   line_rec_   Public_Line_Rec;
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
          Shipment_Order_Utility_API.Get_Order_Delivery_Rpt_Info(temp_, source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END   
   ELSIF(source_ref_type_db_ IN (Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES, Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)) THEN      
      DECLARE
         tot_qty_issued_   NUMBER;
      BEGIN
         line_rec_                   := Get_Line(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
         temp_.source_ref1           := line_rec_.source_ref1;
         temp_.buy_qty_due           := line_rec_.source_qty;
         temp_.configuration_id      := line_rec_.configuration_id;
         temp_.ref_id                := line_rec_.ref_id;
         temp_.location_no           := line_rec_.location_no;
         temp_.dock_code             := line_rec_.dock_code;
         temp_.sub_dock_code         := line_rec_.sub_dock_code;
         temp_.planned_delivery_date := line_rec_.planned_delivery_date;
         temp_.planned_ship_date     := line_rec_.planned_ship_date;
         tot_qty_issued_             :=  line_rec_.source_qty_shipped;         
         temp_.qty_remaining         := line_rec_.source_qty - tot_qty_issued_;
         temp_.total_qty_delivered   := tot_qty_issued_;
      END;
   END IF;
   RETURN temp_;          
END Get_Source_Delivery_Rpt_Info;


PROCEDURE Enable_Custom_Fields_for_Rpt (  
   report_id_           IN VARCHAR2,
   block_xpath_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   reserv_lu_           IN VARCHAR2 DEFAULT 'FALSE')
IS   
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         IF(reserv_lu_ = Fnd_Boolean_API.DB_FALSE) THEN
            Report_Lu_Definition_API.Enable_Custom_Fields_for_Lu(report_id_, 'CustomerOrderLine', block_xpath_);
         ELSE
            Report_Lu_Definition_API.Enable_Custom_Fields_for_Lu(report_id_, 'CustomerOrderReservation', block_xpath_);
         END IF;
      $ELSE
         NULL; -- No need to raise component not exist since this procedure will be directly called by reports when compiling.          
      $END 
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN      
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         IF(reserv_lu_ = Fnd_Boolean_API.DB_FALSE) THEN
            Report_Lu_Definition_API.Enable_Custom_Fields_for_Lu(report_id_, 'PlanningShipment', block_xpath_);         
         ELSE  
            Report_Lu_Definition_API.Enable_Custom_Fields_for_Lu(report_id_, 'InventoryPartReservation', block_xpath_);
         END IF;
      $ELSE
         NULL;
      $END 
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF(reserv_lu_ = Fnd_Boolean_API.DB_FALSE) THEN
            Report_Lu_Definition_API.Enable_Custom_Fields_for_Lu(report_id_, 'PurchaseOrderLine', block_xpath_);
         ELSE
            Report_Lu_Definition_API.Enable_Custom_Fields_for_Lu(report_id_, 'InventoryPartReservation', block_xpath_);
         END IF;
      $ELSE
         NULL;
      $END       
   END IF;
END Enable_Custom_Fields_for_Rpt;


@UncheckedAccess
FUNCTION Get_Print_Char_Code (
   print_control_code_  IN VARCHAR2,
   document_code_       IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS      
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
     $IF Component_Order_SYS.INSTALLED $THEN
        RETURN Cust_Ord_Print_Ctrl_Char_API.Get_Print_Char_Code(print_control_code_, document_code_);
     $ELSE
        NULL;
     $END   
   END IF;
   RETURN NULL;   
END Get_Print_Char_Code;


@UncheckedAccess
FUNCTION Get_Footer (
   company_               IN VARCHAR2,
   line_no_               IN NUMBER,  
   source_ref_type_db_    IN VARCHAR2) RETURN VARCHAR2   
IS
   footer_                 VARCHAR2(2000);
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER; 
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP
      IF(source_ref_type_list_(i_) IN (Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            footer_ := Company_Invoice_Info_API.Get_Footing_Line(company_, line_no_);
            RETURN footer_;
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;
   RETURN footer_;
END Get_Footer;


@UncheckedAccess
FUNCTION Get_Part_Print_Control_Code (
   contract_            IN VARCHAR2,
   source_part_no_      IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS      
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Sales_part_API.Get_Print_Control_Code(contract_, source_part_no_);
      $ELSE
         NULL;
      $END   
  END IF;  
  RETURN NULL;
END Get_Part_Print_Control_Code;


@UncheckedAccess
FUNCTION Get_Source_Part_Note_Id (
   contract_            IN VARCHAR2,
   source_part_no_      IN VARCHAR2,
   lang_code_           IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2)RETURN NUMBER
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN NVL(Sales_Part_Language_Desc_API.Get_Note_Id(contract_, source_part_no_, lang_code_), Sales_part_API.Get_Note_Id(contract_, source_part_no_));
      $ELSE
         NULL;
      $END   
  END IF;  
  RETURN NULL;       
END Get_Source_Part_Note_Id;


@UncheckedAccess
FUNCTION Get_Source_Line_Note_Id (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2)RETURN NUMBER
IS         
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Note_Id(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END   
  END IF;  
  RETURN NULL;       
END Get_Source_Line_Note_Id;


@UncheckedAccess
FUNCTION Get_Tax_Id_Number (
   company_               IN VARCHAR2,
   tax_liability_country_ IN VARCHAR2,
   tax_liability_date_    IN VARCHAR2,
   source_ref_type_db_    IN VARCHAR2) RETURN VARCHAR2   
IS
   tax_id_number_          VARCHAR2(50);
   source_ref_type_list_   Utility_SYS.STRING_TABLE;
   num_sources_            NUMBER; 
BEGIN
   Shipment_API.Get_Source_Ref_Type_List(source_ref_type_list_, num_sources_, source_ref_type_db_);
   FOR i_ IN 1..source_ref_type_list_.COUNT LOOP      
      IF(source_ref_type_list_(i_) IN (Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER, Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN)) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            DECLARE 
               liability_rec_      Tax_Liability_Countries_API.Public_Rec;
            BEGIN   
               liability_rec_ := Tax_Liability_Countries_API.Get_Valid_Tax_Info(company_, tax_liability_country_, tax_liability_date_);
               tax_id_number_ := liability_rec_.tax_id_number;
               RETURN tax_id_number_;
            END;
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;
   RETURN tax_id_number_;
END Get_Tax_Id_Number;


@UncheckedAccess
FUNCTION Get_Print_Config_Code (
   print_control_code_   IN VARCHAR2,
   print_char_code_      IN VARCHAR2,
   doc_code_             IN VARCHAR2,
   source_ref_type_db_   IN VARCHAR2) RETURN VARCHAR2
IS   
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN           
            RETURN Cust_Ord_Print_Ctrl_Char_API.Get_Cust_Ord_Print_Config_Db
                        (print_control_code_, print_char_code_, doc_code_);            
      $ELSE
         NULL;
      $END   
   END IF;
   RETURN NULL;    
END Get_Print_Config_Code;


@UncheckedAccess
FUNCTION Get_Characteristic_Price (
   configured_line_price_id_  IN NUMBER,
   source_part_no_            IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   spec_revision_no_          IN NUMBER,
   characteristic_id_         IN VARCHAR2,
   config_spec_value_id_      IN NUMBER,
   source_ref_type_db_        IN VARCHAR2) RETURN VARCHAR2
IS   
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN           
         RETURN Config_Char_Price_API.Get_Characteristic_Price(configured_line_price_id_, 
                                                               source_part_no_, 
                                                               configuration_id_,
                                                               spec_revision_no_, 
                                                               characteristic_id_,
                                                               config_spec_value_id_); 
               
      $ELSE
         NULL;
      $END   
   END IF;
   RETURN NULL;    
END Get_Characteristic_Price;


@UncheckedAccess
FUNCTION Get_Line_Lu_Name (    
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS     
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.lu_name_;
      $ELSE
         NULL;
      $END   
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         RETURN Planning_Shipment_API.lu_name_;
      $ELSE
         NULL;
      $END 
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.lu_name_;
      $ELSE
         NULL;
      $END 
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         RETURN Purchase_Order_Line_API.lu_name_;
      $ELSE
         NULL;
      $END 
   END IF;
   RETURN NULL;       
END Get_Line_Lu_Name;


@UncheckedAccess
FUNCTION Get_Line_Rowkey (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS          
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         RETURN Customer_Order_Line_API.Get_Objkey(source_ref1_, source_ref2_, source_ref3_, source_ref4_);
      $ELSE
         NULL;
      $END   
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         RETURN Planning_Shipment_API.Get_Objkey(source_ref1_, source_ref2_, source_ref3_);
      $ELSE
         NULL;
      $END
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         RETURN Shipment_Order_Line_API.Get_Objkey(source_ref1_, source_ref2_);
      $ELSE
         NULL;
      $END  
   ELSIF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         RETURN Purchase_Order_Line_API.Get_Objkey(source_ref1_, source_ref2_, source_ref3_);
      $ELSE
         NULL;
      $END  
   END IF;
   RETURN NULL;       
END Get_Line_Rowkey;


PROCEDURE Modify_Ship_Inventory_Loc_No (
   pick_list_no_               IN VARCHAR2,
   ship_inventory_location_no_ IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2)
IS
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Customer_Order_Pick_List_API.Modify_Ship_Inventory_Loc_No(pick_list_no_, ship_inventory_location_no_);         
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END  
   END IF;       
END  Modify_Ship_Inventory_Loc_No ;  

PROCEDURE All_Lines_Has_Doc_Address (
   shipment_id_   IN NUMBER)
IS
BEGIN
   IF ((Shipment_API.Source_Ref_Type_Exist(shipment_id_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = 'TRUE')) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Shipment_Order_Utility_API.All_Lines_Has_Doc_Address(shipment_id_);         
      $ELSE
         NULL;
      $END  
   END IF;
END All_Lines_Has_Doc_Address;    

@UncheckedAccess
FUNCTION Get_Pick_By_Choice_Blocked_Db (
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   configuration_id_   IN VARCHAR2,
   shipment_id_        IN NUMBER ) RETURN VARCHAR2
IS
   pick_by_choice_blocked_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         pick_by_choice_blocked_ := Customer_Order_Reservation_API.Get_Pick_By_Choice_Blocked_Db(order_no_         => source_ref1_, 
                                                                                                 line_no_          => source_ref2_, 
                                                                                                 rel_no_           => source_ref3_, 
                                                                                                 line_item_no_     => source_ref4_, 
                                                                                                 contract_         => contract_, 
                                                                                                 part_no_          => part_no_, 
                                                                                                 location_no_      => location_no_, 
                                                                                                 lot_batch_no_     => lot_batch_no_, 
                                                                                                 serial_no_        => serial_no_, 
                                                                                                 eng_chg_level_    => eng_chg_level_, 
                                                                                                 waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                                                                                 activity_seq_     => activity_seq_, 
                                                                                                 handling_unit_id_ => handling_unit_id_, 
                                                                                                 configuration_id_ => configuration_id_, 
                                                                                                 shipment_id_      => shipment_id_);
      $ELSE
         NULL;
      $END
   ELSIF (Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_))THEN 
      pick_by_choice_blocked_ := Inventory_Part_Reservation_API.Get_Pick_By_Choice_Blocked_Db(contract_           => contract_,
                                                                                              part_no_            => part_no_, 
                                                                                              configuration_id_   => configuration_id_,
                                                                                              location_no_        => location_no_, 
                                                                                              lot_batch_no_       => lot_batch_no_, 
                                                                                              serial_no_          => serial_no_,
                                                                                              eng_chg_level_      => eng_chg_level_, 
                                                                                              waiv_dev_rej_no_    => waiv_dev_rej_no_, 
                                                                                              activity_seq_       => activity_seq_, 
                                                                                              handling_unit_id_   => handling_unit_id_, 
                                                                                              source_ref1_        => source_ref1_, 
                                                                                              source_ref2_        => source_ref2_, 
                                                                                              source_ref3_        => source_ref3_, 
                                                                                              source_ref4_        => source_ref4_,
                                                                                              source_ref_type_db_ => source_ref_type_db_, 
                                                                                              shipment_id_        => shipment_id_);    
   END IF;   
   RETURN pick_by_choice_blocked_;
END Get_Pick_By_Choice_Blocked_Db;

@UncheckedAccess
FUNCTION Check_Receiver_Address_Exist(
   receiver_id_      IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2,
   address_id_       IN VARCHAR2,
   address_type_db_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   address_exists_ VARCHAR2(5) := 'FALSE';
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         address_exists_ := Customer_Info_Address_Type_API.Check_Exist(receiver_id_, address_id_, Address_Type_Code_API.Decode(address_type_db_));
      $ELSE
         NULL;
      $END
   ELSIF(receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      address_exists_ := Supplier_Info_Address_Type_API.Check_Exist(receiver_id_, address_id_, Address_Type_Code_API.Decode(address_type_db_));
   END IF;
   RETURN address_exists_;
END Check_Receiver_Address_Exist;

@UncheckedAccess
FUNCTION Is_Valid_Receiver_Address(
   receiver_id_      IN VARCHAR2,
   receiver_type_db_ IN VARCHAR2,
   address_id_       IN VARCHAR2,
   contract_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   valid_address_ VARCHAR2(5) := 'FALSE';
BEGIN
   IF(receiver_type_db_ = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         valid_address_ := Customer_Info_Address_API.Is_Valid(receiver_id_, address_id_, Site_API.Get_Site_Date(contract_));
      $ELSE
         NULL;
      $END
   ELSIF(receiver_type_db_ = Sender_Receiver_Type_API.DB_SUPPLIER) THEN
      valid_address_ := Supplier_Info_Address_API.Is_Valid(receiver_id_, address_id_, Site_API.Get_Site_Date(contract_));
   END IF;
   RETURN valid_address_;
END Is_Valid_Receiver_Address;


PROCEDURE Post_Reservation_Actions (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 )
IS
BEGIN
   IF(source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      $IF Component_Shipod_SYS.INSTALLED $THEN
         Shipment_Ord_Utility_API.Post_Reservation_Actions(source_ref1_, source_ref2_);         
      $ELSE
         Error_SYS.Component_Not_Exist('SHIPOD');
      $END  
   END IF;       
END Post_Reservation_Actions;
         
-- gelr:alt_delnote_no_chronologic, begin
PROCEDURE Post_Generate_Alt_Delnote_No (
   delnote_no_          IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   shipment_id_         IN NUMBER,
   alt_delnote_no_      IN VARCHAR2 )
IS
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      Shipment_Order_Utility_API.Post_Generate_Alt_Delnote_No(delnote_no_, source_ref1_, shipment_id_, alt_delnote_no_);         
   $ELSE
      NULL;
   $END  
     
END Post_Generate_Alt_Delnote_No;
-- gelr:alt_delnote_no_chronologic, end


@UncheckedAccess
FUNCTION Get_Warehouse_Info (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2 ) RETURN Warehouse_Info_Rec
IS    
   sender_type_   VARCHAR2(20);
   temp_          Warehouse_Info_Rec;
   warehouse_rec_ Warehouse_API.Public_Rec;
   line_rec_      Public_Rec;
BEGIN
   IF (shipment_id_ != 0)THEN
      sender_type_ := Shipment_API.Get_Sender_Type(shipment_id_);
      IF (sender_type_ = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
         warehouse_rec_                  := Warehouse_API.Get(Shipment_API.Get_Sender_Id(shipment_id_));
         temp_.availability_control_id   := warehouse_rec_.availability_control_id; 
         temp_.warehouse_id              := warehouse_rec_.warehouse_id;
      END IF;
   ELSIF (shipment_id_ = 0) THEN 
      line_rec_    := Get(source_ref1_, source_ref_type_db_);
      IF (line_rec_.sender_type = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
         warehouse_rec_                  := Warehouse_API.Get(line_rec_.sender_id);
         temp_.availability_control_id   := warehouse_rec_.availability_control_id; 
         temp_.warehouse_id              := warehouse_rec_.warehouse_id;
      END IF;
   END IF;
   RETURN temp_;       
END Get_Warehouse_Info;

-- This method fetch Shipment reference info for Pick Part By Choice
@UncheckedAccess
PROCEDURE Get_Shipment_Reference_Info (
   sender_id_           OUT VARCHAR2,
   sender_type_         OUT VARCHAR2,
   source_ref_status_   OUT VARCHAR2,
   condition_code_      OUT VARCHAR2,
   condition_code_desc_ OUT VARCHAR2,
   part_ownership_db_   OUT VARCHAR2,
   owner_               OUT VARCHAR2,
   owner_name_          OUT VARCHAR2,
   source_ref1_         IN  VARCHAR2,
   source_ref2_         IN  VARCHAR2,
   source_ref3_         IN  VARCHAR2,
   source_ref4_         IN  VARCHAR2,
   source_ref_type_db_  IN  VARCHAR2 )
IS 
   source_line_rec_   Public_Line_Rec;
BEGIN
   source_line_rec_ := Get_Line(source_ref1_,
                                source_ref2_,
                                source_ref3_,
                                source_ref4_,
                                source_ref_type_db_);
            
   sender_id_           :=  source_line_rec_.sender_id;
   sender_type_         :=  source_line_rec_.sender_type;
   source_ref_status_   :=  source_line_rec_.rowstate;
   condition_code_      :=  Get_Condition_Code__(source_ref1_,
                                                 source_ref2_,
                                                 source_ref3_,
                                                 source_ref4_,
                                                 source_ref_type_db_); 
   condition_code_desc_ := Condition_Code_API.Get_Description(condition_code_);
   part_ownership_db_   := source_line_rec_.part_ownership;
   owner_               := source_line_rec_.owner;
   owner_name_          := source_line_rec_.owner_name;
END Get_Shipment_Reference_Info;

-------------------------------------------------------------------------
-- Validate_Ref_Id
--   Validates reference id of the shipment with connectiong source lines.
--------------------------------------------------------------------------
@IgnoreUnitTest TrivialFunction
PROCEDURE Validate_Ref_Id(
   shipment_id_        IN     NUMBER,
   source_ref_type_    IN     VARCHAR2,
   new_ref_id_         IN     VARCHAR2,
   check_head_ref_     IN     VARCHAR2 DEFAULT 'FALSE')
IS 
BEGIN
   IF (source_ref_type_ = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER OR 
      Shipment_API.Source_Ref_Type_Exist(source_ref_type_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = Fnd_Boolean_API.DB_TRUE) THEN
      
      $IF Component_Order_SYS.INSTALLED $THEN 
         Shipment_Order_Utility_API.Validate_Ref_Id(shipment_id_, new_ref_id_, check_head_ref_);
      $ELSE
         NULL;
      $END
   END IF;
END  Validate_Ref_Id;


FUNCTION Any_Rental_Line_Exists (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   CURSOR get_line IS
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type
      FROM shipment_line_tab
      WHERE shipment_id = shipment_id_;      

   rental_db_           VARCHAR2(5):= 'FALSE';
   source_ref_type_db_  shipment_tab.source_ref_type%TYPE;
BEGIN
   source_ref_type_db_ := Shipment_API.Get_Source_Ref_Type_Db(shipment_id_);   

   IF (Shipment_API.Source_Ref_Type_Exist(source_ref_type_db_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = 'TRUE') THEN
      FOR shipment_line_rec IN get_line LOOP
         rental_db_ := Get_Rental_Db(shipment_line_rec.source_ref1, shipment_line_rec.source_ref2, shipment_line_rec.source_ref3, shipment_line_rec.source_ref4, shipment_line_rec.source_ref_type);
         IF (rental_db_ = 'TRUE')THEN
            EXIT;
         END IF;
      END LOOP;
   END IF;
   RETURN rental_db_;
END Any_Rental_Line_Exists;
