-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartReservation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211230  RasDlk  SC21R2-3145, Added the method Unissue_Shipment_Line and modified Post_Update_Actions___ to support Undo Shipment Delivery for sources other than Customer Order.
--  211221  ErRalk  SC21R2-2980, Modified Modified Issue_Part___ to include alt source reference values for the deliver process in supplier return.
--  211207  PamPlk  SC21R2-2979, Modified Report_Picking___  and Validate_Quantity___ in order to restrict Partial Picking, Zero Picking for Purchase Receipt Return.
--  211027  PrRtlk  SC21R2-5265, Added DB_PURCH_RECEIPT_RETURN to Get_Unpicked_Pick_Listed_Qty and Get_Order_Suppl_Demand_Type_Db methods
--  211005  RasDlk  SC21R2-642, Modified Issue_Part___ by passing the shipment_id_ as source_ref5_ to store it on transactions in Inventory Transaction history 
--  211005          related to Shipment for all sources.
--  210712  RoJalk  SC21R2-1374, Added ship_handling_unit_id to the method Keys_And_Qty_Rec, Fill_Keys_And_Qty___, added the parameter 
--  210712          number_parameter1_ to Update_Record___, Modify_Qty_Reserved___.Added number_parameter1_ to method and passed it to Reserve_And_Report_As_Picked,
--  210712          Modify_Qty_Reserved___.Added ship_handling_unit_id_ and passed it to Handle_Ship_Invent_Utility_API.Move_To_Shipment_Location. 
--  210712          Modified Pick_Inv_Part_Reservations to fetch ship_handling_unit_id from the message_. 
--  210203  RoJalk  SC2020R1-10729, Modified Post_Pick_Report_Shipment___ and added the parameter trigger_shipment_flow_.
--  210203  ErRalk  SC2020R1-12417, Modified the wrong dependency check added in Report_Picking___ method.
--  201105  ErRalk  SC2020R1-11001, Added method Pick_HU_Reservations to support Pick Handling Unit By Choice for Shipment Order and Project Deliverables.
--  201029  ErRalk  SC2020R1-10472, Modified Find_And_Reserve_Part method by including pick_list_no_ as a default parameter.
--  201002  RoJalk  SC2020R1-1987, Modified Issue_Part___ and passed the parameter ignore_this_avail_control_id_ to Reserve_Part___ 
--  201002          method call. Added the parameter ignore_this_avail_control_id_ to Reassign_Shipment_Line. Modified Report_Picking___  
--  201002          to pass the ignore_this_avail_control_id_ parameter to Reserve_Part___.
--  200911  RoJalk  SC2020R1-9192, Modified Pick_Shipment_API.Post_Pick_Report_Shipment method call and replaced the source_ref_type_db_ parameter with use_generic_reservation_.
--  200903  ErRalk  SC2020R1-7302, Added methods Pick_Reservation, Pick_Reservation___ and modified Pick_Inv_Part_Reservations to support Centralized reservation.
--  200729  ErRalk  SC2020R1-1033, added method Modify_Pick_By_Choice_Blocked___ and modified Reserve_Part, Insert___, Modify_Shipment_Id by adding 
--  200729          pick_by_choice_blocked and added Get_Pick_By_Choice_Blocked_Db to add block for pick by choice to Generic Reservation.
--  200608  RoJalk  SC2020R1-7202, Added the parameter validate_hu_struct_position_ to the method Issue_Part___.
--  200311  RoJalk  SC2020R1-1977, Added the parameter ignore_this_avail_control_id_ to Issue_Shipment_Line and Issue_Part___.
--  200311  RoJalk  SCSPRING20-1930, Modified Reserve_Or_Unreserve_On_Swap to support Shipment Order. 
--  191212  MeAblk  SCSPRING20-1239, Modified methods Insert_Record___(), Post_Update_Actions___(), Post_Delete_Actions___() by moving shipment id validation
--  191212          into shipment side in order to handle non-shipment conncted source specific reservation.
--  191104  RoJalk  SCSPRING20-173, Modified Handle_Ship_Invent_Utility_API.Move_To_Shipment_Location method call in Report_Picking___
--  191104          and used Reserve_Shipment_API.Get_Logistic_Source_Type_Db to convert source ref type. 
--  191029  Aabalk  SCSPRING20-63, Modified Get_Order_Suppl_Demand_Type_Db and Get_Demand_Res_Source_Type_Db to support new SHIPMENT_ORDER enumeration value.
--  180226  RoJalk  STRSC-15257, Added the method Get_Total_Qty_On_Pick_List.
--  180112  LEPESE  STRSC-15739, Applied Get_Converted_Source_Ref in parameter list when calling Inv_Part_Stock_Reservation_API.Move_New_With_Transport_Task.
--  180112  RoJalk  STRSC-15676, Modified Report_Picking___ to support zero picking.
--  171107  DAYJLK  STRSC-12459, Modified Modify_Shipment_Id by restructuring the contents to insert record with new shipment id before 
--  171107          removing the reservation record with the old shipment id to make both reservation records available for the recreation
--  171107          of the transport task lines for the change in shipment id. Modified Set_Qty_Reserved_As_Picked to prevent picking of  
--  171107          reservations which are assigned to Transport Task Lines.
--  171103  LEPESE  STRSC-14098, Added call to Inv_Part_Stock_Reservation_API.Move_New_With_Transport_Task from Find_And_Reserve_Part.
--  171018   RoJalk  STRSC-9581, Removed the obsolete method All_Lines_Picked. Changed the return type of
--  171018           Inventory_Pick_List_API.Is_Fully_Reported to be VARCHAR2.
--  171011   DAYJLK  STRSC-12459, Added Post_Update_Actions___ and Post_Delete_Actions___ which is invoked in Update___ and Delete___ 
--  171011           respectively to sync changes in Transport Task connected reservations.
--  171011   RoJalk  STRSC-9564, Modified Set_Pick_List_No and added the parameter location_group_. 
--  170802   ChFolk  STRSC-11135, Added new method Lock_Res_And_Fetch_Info which is used when creating transport task for project deliverables.
--  170727   DAYJLK  STRSC-11042, Added method Reserve_Or_Unreserve_On_Swap.
--  170601   RoJalk  LIM-11496, Modified Insert___ to set the value for fully_picked.
--  170523   RoJalk  Modified Pick_Inv_Part_Reservations, Set_Qty_Reserved_As_Picked to fetch from
--  170523           Inventory_Pick_List_Tab when user input is null.
--  170510   RoJalk  STRSC-8047, Modified Set_Pick_List_No and added code to update the pick list no in 
--  170510           shipment_reserv_handl_unit_tab. Modified Insert_Record___ and added teh parameter on_pick_list_creation_
--  170510           to skip some of the post actions when creating pick list.
--  170506   MaIklk  STRSC-7889, Added Convert_Pick_List_No___ to convert 0 to * for pick list no when calling Reserve_Shipment_API.
--  170505   RoJalk  LIM-11324, Modified Pick_Inv_Part_Reservations to fetch shipment id from  Inventory_Pick_List_Tab.
--  170504   MaIklk  STRSC-7825, Handled to convert InvPartResSourceType value in to OrderType in Get_Order_Type_Db___().
--  170503   Chfose  LIM-11458, Restructured Pick_Aggregated_Reservations__ to support picking HUs within the same structure.
--  170503           Also modified Set_Qty_Reserved_As_Picked to keep the HUs together when having full HUs reserved.
--  170502   RoJalk  LIM-11324, Added the parameter keep_remaining_reservation_ to Set_Qty_Picked___.
--  170502   RoJalk  LIM-11324, Modified Post_Pick_Report_Shipment___ and added inventory_event_id_.
--  170427   RoJalk  LIM-11324, Changed the scope of Set_Qty_Reserved_As_Picked___ to be public  
--  170427   MaIklk  LIM-11356, Fixed to update qty picked first and then reserved qty in scrap_part().
--  170427           and to be on pick list level. 
--  170425   RoJalk  LIM-11324, Modified method interfaces to include inventory_event_id_ where needed. 
--  170411   RoJalk  LIM-10554, Modified Pick_Inv_Part_Reservations and called
--  170411           Inventory_Pick_List_API.Post_Pick_Report_Shipment.
--  170411   RoJalk  LIM-11324, Added the method Pick_Aggregated_Reservations__.
--  170407   RoJalk  LIM-11311, Changed the scope of Report_Picking to be implementation.
--  170304   RoJalk  LIM-11358, Modified Report_Picking method and added validate_hu_struct_position_, add_hu_to_shipment_.
--  170330   MaRalk  LIM-9052, Added method Shipment_Pick_List_Line_Exists.
--  170329   RoJalk  LIM-11309, Included ship_inventory_location_no_ in Set_Qty_Reserved_As_Picked___, Set_Qty_Picked___
--  170329           Report_Picking, Set_Shipment_Qty_Res_As_Picked, Set_Picklist_Qty_Res_As_Picked, Pick_Inv_Part_Reservations.
--  170328   RoJalk  LIM-11080, Modified Report_Picking and added Handle_Ship_Invent_Utility_API.Move_To_Shipment_Location
--  170328           method call to move the stock record to shipment inventory location.
--  170328   RoJalk  LIM-9182, Added the method Reassign_Shipment_Line.
--  170328   RoJalk  LIM-10698, Modified Pick_Inv_Part_Reservations and assigned a value to pick_list_fully_reported_
--  170328           to be used in info messages raised in connected clients.
--  170322   RoJalk  LIM-11080, Modified Set_Qty_Picked to call Modify_Qty_Picked___ instead of Update_Record___.
--  170322           Renamed Set_Qty_Picked to Report_Picking.         
--  170322   RoJalk  LIM-10699, Modified Report_Reserved_As_Picked method and added the parameter ship_inventory_location_no_.
--  170320   MaIklk  LIM-11231, Added Get_Total_Qty_Picked() and changed Get_Total_Qty_Reserved() and Get_Total_Qty_Issued() to support with or without shipment id.
--  170316   Chfose  LIM-11156, Added server-based refresh of PickLists in Insert___, Update___ & Delete___
--  170316           and added inventory_event_id_ as a parameter where needed throughout the entity.
--  170314   RoJalk  LIM-10701, Added the method Pick_Inv_Part_Reservations. Changed the scope of
--  170314           Fill_Keys_And_Qty, Set_Qty_Picked methods to be implementation.
--  170224   RoJalk  LIM-10897, Modified Reserve_And_Report_As_Picked so the updation of qty 
--  170224           will take two paths depending on if there is an increase or decrease of quantity.
--  170308   MaIklk  LIM-10827, Added Get_Total_Qty_Issued().
--  170307   RoJalk  LIM-10702, Added Keys_And_Qty_Rec, Keys_And_Qty_Tab and Fill_Keys_And_Qty.
--  170307           Added Set_Qty_Picked taking keys_and_qty_tab_ as the parameter.
--  170301   RoJalk  LIM-10999, Added the method Lock_By_Keys_And_Get.
--  170224   RoJalk  LIM-10897, Renamed Reserve_Picked_Part to Reserve_And_Report_As_Picked.
--  170224   RoJalk  LIM-10897, Added methods Modify_Qty_Picked___ and Reserve_Picked_Part.
--  170222   RoJalk  LIM-9881, Modified Insert___ and Update___ to assign a value to fully_picked.
--  170220   RoJalk  LIM-10811, Changed the scope of Set_Qty_Reserved_As_Picked to be implementation and
--  170220           called from new methods Set_Shipment_Qty_Res_As_Picked, Set_Picklist_Qty_Res_As_Picked.
--  170209   RoJalk  LIM-9118, Added the methods Set_Qty_Reserved_As_Picked, Report_Reserved_As_Picked.
--  170209           Modified Set_Pick_List_No method to include source reference parameters.
--  170207   RoJalk  LIM-10594, Added the method Create_Pick_List_Allowed.
--  170124   MaIklk  LIM-9819, Handled the "*" to NULL conversion  for source ref columns when calling InventoryPartInStock and shipment. 
--  170113   MaRalk  LIM-10080, Removed method Issue_Part and added method Issue_Shipment_Line.
--  170113           Modified method Update_Record___ to call shipment post delivery actions.
--  161228   MaRalk  LIM-10081, Modified Validate_Quantity___ by passing oldrec_ and newrec_ parameters 
--  161228           instead of quantity values. Added/modified catch qty related validations.
--  161222   MaRalk  LIM-9763, Modified Issue_Part___ to handle catch quantity related fields.  
--  161222           Modified Modify_Qty_Reserved___ to restrict deleting issued line when qty_reserved is zero.
--  161219   MaRalk  LIM-9764, Added pick_list_no to the methods Reserve_Part___, Modify_Qty_Reserved___
--  161219           and corrected the usages.
--  161208   MaRalk  LIM-9759, Used Update_Record___ instead of Modify___ inside Issue___. 
--  161208           Modified Update_Record___ to avoid calling Reserve_Shipment_API.Post_Update_Reserv_Actions
--  161208           when an issue occure. Added parameters string_parameter1_, 2 to Issue___ method.
--  161207   MaRalk  LIM-9759, Renamed method Issue_Full_Reservation___ as Issue_Part___ and added
--  161207           additional parameters quantity_, catch_quantity_ and remove_remaining_reservation_.
--  161207           Added parameter qty_issued_ to the method Validate_Quantity___.
--  161202   MaIklk  LIM-9932, Added Get_Unpicked_Pick_Listed_Qty().
--  161125   RoJalk  LIM-9738, Added method Get_Demand_Res_Source_Type_Db to fetch mapping 
--  161125           inv_part_res_source_type for a given order_supply_demand_type.
--  161124   RoJalk  LIM-9847, Added the method All_Lines_Picked.
--  161124   RoJalk  LIM-9038, Code improvements to the method Identify_Serials.
--  161123   MaRalk  LIM-9759, Added method Issue_Full_Reservation___ which can be used to issue one reservation record.
--  161122   RoJalk  LIM-9029, Modified Validate_Quantity___ to check if qty_picked is greater than qty_reserved.
--  161122   RoJalk  LIM-9040, Added the method Identify_Serials and called from Set_Qty_Picked. 
--  161122   MaIklk  LIM-9818, Added a implementation method for Reserve_Part and fix some other issues.
--  161117   MaIklk  LIM-9230, Implemented two-step sequential reservation solution related to projects.
--  161116   MaIklk  LIM-9232, Added methods for manual reservation (Reserve_Part) and scrap part (Scrap_Part).
--  161111   RoJalk  LIM-9008, Modified Set_Pick_List_No to use BULK COLLECT. 
--  161110   MaRalk  LIM-9129, Added method Issue_Parts in order to support Semi Centralized Shipment Delivery.
--  161110   RoJalk  LIM-9029, Added the method Set_Qty_Picked.
--  161109   MaIklk  LIM-9230, Added Delete_Record___().
--  161103   MaIklk  LIM-9230, Added Modify_Shipment_Id().
--  161102   MaIklk  LIM-9230, Implemented Find_And_Reserve_Part() functionality and removed some unneccessary functions, 
--  161026   RoJalk  LIM-9012, Added the method Set_Pick_List_No.
--  161021   MaIklk  LIM-9170, Implemented to trigger shipment post actions.
--  161017   MaIklk  LIM-9220, Added Get_Order_Suppl_Demand_Type_Db() to convert inventory part reservation source type to Order supply demand type.
--  161013   MaIklk  LIM-9218, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Keys_And_Qty_Rec IS RECORD (
   contract                 inventory_part_reservation_tab.contract%TYPE,
   part_no                  inventory_part_reservation_tab.part_no%TYPE,
   configuration_id         inventory_part_reservation_tab.configuration_id%TYPE,
   location_no              inventory_part_reservation_tab.location_no%TYPE,
   lot_batch_no             inventory_part_reservation_tab.lot_batch_no%TYPE,
   serial_no                inventory_part_reservation_tab.serial_no%TYPE,
   eng_chg_level            inventory_part_reservation_tab.eng_chg_level%TYPE,
   waiv_dev_rej_no          inventory_part_reservation_tab.waiv_dev_rej_no%TYPE,
   activity_seq             inventory_part_reservation_tab.activity_seq%TYPE,
   handling_unit_id         inventory_part_reservation_tab.handling_unit_id%TYPE,
   source_ref1              inventory_part_reservation_tab.source_ref1%TYPE,
   source_ref2              inventory_part_reservation_tab.source_ref2%TYPE,
   source_ref3              inventory_part_reservation_tab.source_ref3%TYPE,
   source_ref4              inventory_part_reservation_tab.source_ref4%TYPE,
   source_ref_type_db       inventory_part_reservation_tab.source_ref_type%TYPE,
   part_tracking_session_id NUMBER,
   pick_list_no             inventory_part_reservation_tab.pick_list_no%TYPE,
   shipment_id              inventory_part_reservation_tab.shipment_id%TYPE,
   qty_picked               inventory_part_reservation_tab.qty_picked%TYPE,
   catch_qty_picked         inventory_part_reservation_tab.catch_qty_picked%TYPE,
   ship_handling_unit_id    NUMBER );

TYPE Keys_And_Qty_Tab IS TABLE OF Keys_And_Qty_Rec INDEX BY PLS_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     inventory_part_reservation_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN      
   super(oldrec_, newrec_, indrec_, attr_);  
   
   Validate_Quantity___(oldrec_, newrec_);
   
   IF (Inventory_Part_In_Stock_API.Get_Freeze_Flag_Db(newrec_.contract, 
                                                      newrec_.part_no, 
                                                      newrec_.configuration_id, 
                                                      newrec_.location_no,
                                                      newrec_.lot_batch_no, 
                                                      newrec_.serial_no, 
                                                      newrec_.eng_chg_level, 
                                                      newrec_.waiv_dev_rej_no, 
                                                      newrec_.activity_seq, 
                                                      newrec_.handling_unit_id) = 'Y' AND newrec_.qty_picked > oldrec_.qty_picked) THEN
      Error_SYS.Record_General(lu_name_, 'FROZENPART: Inventory part :P1 on site :P2 is blocked for inventory transactions because of counting.', newrec_.part_no, newrec_.contract);
   END IF;
   
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.fully_picked := Fnd_Boolean_API.DB_FALSE;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_                          OUT    VARCHAR2,
   objversion_                     OUT    VARCHAR2,
   newrec_                         IN OUT inventory_part_reservation_tab%ROWTYPE,
   attr_                           IN OUT VARCHAR2)
IS   
BEGIN
   newrec_.last_activity_date := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.source_ref2        := NVL(newrec_.source_ref2, '*');
   newrec_.source_ref3        := NVL(newrec_.source_ref3, '*');
   newrec_.source_ref4        := NVL(newrec_.source_ref4, '*');  
   newrec_.pick_by_choice_blocked := NVL(newrec_.pick_by_choice_blocked , Fnd_Boolean_API.DB_FALSE);

   IF (newrec_.pick_by_choice_blocked = Fnd_Boolean_API.DB_FALSE) THEN 
      -- Given the stock keys it will return the setting for block parameter on the other pick list line reservation if any. 
      -- So that in autoamtic reservation, it will copy the setting for 'blocked for PBC' on reservation from other pick list line(s) if there is any. 
     newrec_.pick_by_choice_blocked := Get_Pick_By_Choice_Blocked_Db(newrec_.contract, 
                                                                     newrec_.part_no, 
                                                                     newrec_.configuration_id, 
                                                                     newrec_.location_no, 
                                                                     newrec_.lot_batch_no, 
                                                                     newrec_.serial_no, 
                                                                     newrec_.eng_chg_level, 
                                                                     newrec_.waiv_dev_rej_no, 
                                                                     newrec_.activity_seq, 
                                                                     newrec_.handling_unit_id, 
                                                                     newrec_.source_ref1, 
                                                                     newrec_.source_ref2, 
                                                                     newrec_.source_ref3, 
                                                                     newrec_.source_ref4, 
                                                                     newrec_.source_ref_type, 
                                                                     newrec_.shipment_id);
                                                                
   
   END IF;

   IF (newrec_.qty_picked = newrec_.qty_reserved ) THEN
      newrec_.fully_picked := Fnd_Boolean_API.DB_TRUE;
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);     
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     inventory_part_reservation_tab%ROWTYPE,
   newrec_     IN OUT inventory_part_reservation_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.qty_picked > oldrec_.qty_picked) AND (newrec_.qty_picked = newrec_.qty_reserved ) THEN
      newrec_.fully_picked := Fnd_Boolean_API.DB_TRUE;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


-- Update_Record___
--   Modify attributes in the InventoryPartReservation LU
PROCEDURE Update_Record___ (
   newrec_              IN OUT inventory_part_reservation_tab%ROWTYPE,
   oldrec_              IN     inventory_part_reservation_tab%ROWTYPE,
   string_parameter1_   IN     VARCHAR2 DEFAULT NULL,
   string_parameter2_   IN     VARCHAR2 DEFAULT NULL,
   number_parameter1_   IN     NUMBER   DEFAULT NULL)
IS 
BEGIN
   Modify___(newrec_);    
   -- Handle Post actions in Shipment Reservation and Shipment Delivery
   Post_Update_Actions___(oldrec_, 
                          newrec_, 
                          string_parameter1_, 
                          string_parameter2_,
                          number_parameter1_);
END Update_Record___;


-- Insert_Record___
--   Insert new record to InventoryPartReservation LU
PROCEDURE Insert_Record___ (
   newrec_                IN OUT inventory_part_reservation_tab%ROWTYPE,
   on_pick_list_creation_ IN     BOOLEAN DEFAULT FALSE,
   string_parameter1_     IN     VARCHAR2 DEFAULT NULL,
   string_parameter2_     IN     VARCHAR2 DEFAULT NULL )
IS 
BEGIN
   New___(newrec_);   
  
    -- Handle Post actions   
   IF (NOT on_pick_list_creation_) THEN
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN 
         Reserve_Shipment_API.Post_New_Reservation_Actions(newrec_.source_ref1,
                                                           Get_Converted_Source_Ref(newrec_.source_ref2,2),
                                                           Get_Converted_Source_Ref(newrec_.source_ref3,3),
                                                           Get_Converted_Source_Ref(newrec_.source_ref4,4),
                                                           newrec_.source_ref_type,
                                                           newrec_.shipment_id,
                                                           newrec_.qty_reserved,
                                                           newrec_.qty_picked,
                                                           string_parameter1_,
                                                           string_parameter2_);
      $ELSE
         NULL;
      $END
   END IF;
    
   IF (newrec_.pick_list_no != 0) THEN
      Hu_Snapshot_For_Refresh_API.New(source_ref1_          => newrec_.pick_list_no,
                                      source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
   END IF;
END Insert_Record___;


PROCEDURE Delete_Record___ (
   remrec_             IN OUT inventory_part_reservation_tab%ROWTYPE,
   string_parameter1_  IN     VARCHAR2 DEFAULT NULL,
   string_parameter2_  IN     VARCHAR2 DEFAULT NULL )
IS   
BEGIN
   Remove___(remrec_);
   -- Handle Post actions
   Post_Delete_Actions___(remrec_,
                          string_parameter1_, 
                          string_parameter2_);
END Delete_Record___;


PROCEDURE Modify_Qty_Reserved___(
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,   
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   pick_list_no_        IN NUMBER,
   shipment_id_         IN NUMBER,
   qty_reserved_        IN NUMBER,
   string_parameter1_   IN VARCHAR2,
   string_parameter2_   IN VARCHAR2,
   number_parameter1_   IN NUMBER DEFAULT NULL)
IS  
   newrec_     inventory_part_reservation_tab%ROWTYPE;
   oldrec_     inventory_part_reservation_tab%ROWTYPE; 
BEGIN
   IF (Check_Exist___(contract_           => contract_, 
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
                      pick_list_no_       => pick_list_no_, 
                      shipment_id_        => shipment_id_)) THEN   
      oldrec_ := Lock_By_Keys___(contract_           => contract_, 
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
                                 pick_list_no_       => pick_list_no_, 
                                 shipment_id_        => shipment_id_);
      newrec_ := oldrec_;
      newrec_.qty_reserved := oldrec_.qty_reserved + qty_reserved_;  
      IF(newrec_.qty_reserved = 0 AND newrec_.qty_picked = 0 AND newrec_.qty_issued = 0) THEN 
         Delete_Record___(remrec_               => oldrec_,
                          string_parameter1_    => string_parameter1_, 
                          string_parameter2_    => string_parameter2_);
      ELSE
         Update_Record___(newrec_               => newrec_, 
                          oldrec_               => oldrec_, 
                          string_parameter1_    => string_parameter1_, 
                          string_parameter2_    => string_parameter2_,
                          number_parameter1_    => number_parameter1_); 
      END IF;     
   ELSE
      newrec_.contract          := contract_;
      newrec_.part_no           := part_no_;
      newrec_.configuration_id  := configuration_id_;
      newrec_.location_no       := location_no_;
      newrec_.lot_batch_no      := lot_batch_no_;
      newrec_.serial_no         := serial_no_;
      newrec_.eng_chg_level     := eng_chg_level_;
      newrec_.waiv_dev_rej_no   := waiv_dev_rej_no_;
      newrec_.activity_seq      := activity_seq_;
      newrec_.handling_unit_id  := handling_unit_id_;
      newrec_.source_ref1       := source_ref1_;
      newrec_.source_ref2       := source_ref2_;
      newrec_.source_ref3       := source_ref3_;
      newrec_.source_ref4       := source_ref4_;
      newrec_.source_ref_type   := source_ref_type_db_;
      newrec_.pick_list_no      := pick_list_no_;
      newrec_.shipment_id       := shipment_id_;
      newrec_.qty_reserved      := qty_reserved_;
      newrec_.qty_picked        := 0;
      newrec_.qty_issued        := 0;
      newrec_.catch_qty_picked  := NULL;
      Insert_Record___(newrec_               => newrec_,
                       string_parameter1_    => string_parameter1_,
                       string_parameter2_    => string_parameter2_);
   END IF;
END Modify_Qty_Reserved___;


PROCEDURE Modify_Qty_Picked___(
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,   
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2,
   pick_list_no_        IN NUMBER,
   shipment_id_         IN NUMBER,
   qty_picked_          IN NUMBER,  
   catch_qty_picked_    IN NUMBER,
   string_parameter1_   IN VARCHAR2,
   string_parameter2_   IN VARCHAR2)
IS  
   newrec_              inventory_part_reservation_tab%ROWTYPE;
   oldrec_              inventory_part_reservation_tab%ROWTYPE; 
BEGIN                                               
   IF (Check_Exist___(contract_           => contract_, 
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
                      pick_list_no_       => pick_list_no_, 
                      shipment_id_        => shipment_id_)) THEN   
                      
      oldrec_ := Lock_By_Keys___(contract_           => contract_, 
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
                                 pick_list_no_       => pick_list_no_, 
                                 shipment_id_        => shipment_id_);
      newrec_                  := oldrec_; 
      newrec_.qty_picked       := oldrec_.qty_picked + qty_picked_; 
      newrec_.catch_qty_picked := NVL(oldrec_.catch_qty_picked, 0) + catch_qty_picked_;
      
      IF(newrec_.qty_reserved = 0 AND newrec_.qty_picked = 0 AND newrec_.qty_issued = 0) THEN 
         Delete_Record___(remrec_               => oldrec_,
                          string_parameter1_    => string_parameter1_, 
                          string_parameter2_    => string_parameter2_);
      ELSE
         Update_Record___(newrec_               => newrec_, 
                          oldrec_               => oldrec_,
                          string_parameter1_    => string_parameter1_, 
                          string_parameter2_    => string_parameter2_); 
      END IF; 
   ELSE
      newrec_.contract          := contract_;
      newrec_.part_no           := part_no_;
      newrec_.configuration_id  := configuration_id_;
      newrec_.location_no       := location_no_;
      newrec_.lot_batch_no      := lot_batch_no_;
      newrec_.serial_no         := serial_no_;
      newrec_.eng_chg_level     := eng_chg_level_;
      newrec_.waiv_dev_rej_no   := waiv_dev_rej_no_;
      newrec_.activity_seq      := activity_seq_;
      newrec_.handling_unit_id  := handling_unit_id_;
      newrec_.source_ref1       := source_ref1_;
      newrec_.source_ref2       := source_ref2_;
      newrec_.source_ref3       := source_ref3_;
      newrec_.source_ref4       := source_ref4_;
      newrec_.source_ref_type   := source_ref_type_db_;
      newrec_.pick_list_no      := pick_list_no_;
      newrec_.shipment_id       := shipment_id_;
      newrec_.qty_reserved      := qty_picked_;
      newrec_.qty_picked        := qty_picked_;
      newrec_.qty_issued        := 0;
      newrec_.catch_qty_picked  := catch_qty_picked_;
      Insert_Record___(newrec_               => newrec_,
                       string_parameter1_    => string_parameter1_,
                       string_parameter2_    => string_parameter2_);
   END IF;
END Modify_Qty_Picked___;


PROCEDURE Validate_Quantity___ ( 
   oldrec_ IN inventory_part_reservation_tab%ROWTYPE,
   newrec_ IN inventory_part_reservation_tab%ROWTYPE)
IS    
BEGIN
   IF (newrec_.qty_reserved < 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTYRESERVEDNEGATIVE: The quantity reserved cannot be a negative value.');
   END IF;
   
   IF (newrec_.qty_picked < 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTYPICKEDNEGATIVE: The quantity picked cannot be a negative value.');
   END IF;  
   
   IF (newrec_.qty_issued < 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTYISSUEDNEGATIVE: The quantity issued cannot be a negative value.');
   END IF;   
   
   IF (newrec_.qty_picked > newrec_.qty_reserved) THEN
      Error_SYS.Record_General(lu_name_, 'QTYPICKGRTTHENRES: The quantity picked is not allowed to exceed quantity reserved.');
   END IF;  
   
   IF (NVL(newrec_.catch_qty_picked,0) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'CATCHQTYPICKEDNEGATIVE: The catch quantity picked cannot be a negative value.');
   END IF;
   
   IF (NVL(newrec_.catch_qty_issued,0) < 0) THEN
      Error_SYS.Record_General(lu_name_, 'CATCHQTYISSUEDNEGATIVE: The catch quantity issued cannot be a negative value.');
   END IF;
   
   IF ((Validate_SYS.Is_Changed(oldrec_.catch_qty_issued, newrec_.catch_qty_issued)) AND
       (newrec_.catch_qty_issued IS NULL)) THEN
      IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(newrec_.part_no) = Fnd_Boolean_API.DB_TRUE)THEN 
         Error_SYS.Record_General(lu_name_, 'CATCHQTYISSUEDNULL: The catch quantity issued must have a value for catch quantity enabled part.');    
      END IF;   
   END IF; 
   
   IF (newrec_.source_ref_type = Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      IF (newrec_.qty_picked > 0 AND newrec_.qty_picked < newrec_.qty_reserved AND newrec_.fully_picked = Fnd_Boolean_API.DB_FALSE) THEN
         Error_SYS.Record_General(lu_name_, 'PARTIALPICKINGFORPRR: Partial picking is not allowed for purchase receipt return lines');
      END IF;
   END IF; 
   
END Validate_Quantity___;


-- Issue_Part____
--   Base method which can be used to support any kind of issue scenario.
PROCEDURE Issue_Part___ (      
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   location_no_                  IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,   
   pick_list_no_                 IN NUMBER, 
   shipment_id_                  IN NUMBER, 
   quantity_                     IN NUMBER,
   catch_quantity_               IN NUMBER,
   remove_remaining_reservation_ IN BOOLEAN,
   transaction_code_             IN VARCHAR2,
   dest_contract_                IN VARCHAR2,
   dest_warehouse_id_            IN VARCHAR2,
   ignore_this_avail_control_id_ IN VARCHAR2,
   validate_hu_struct_position_  IN BOOLEAN,
   string_parameter1_            IN VARCHAR2,
   string_parameter2_            IN VARCHAR2)      
IS   
   oldrec_                 inventory_part_reservation_tab%ROWTYPE; 
   newrec_                 inventory_part_reservation_tab%ROWTYPE;    
   transaction_id_         NUMBER;
   catch_qty_to_issue_     NUMBER := catch_quantity_;
   catch_qty_enabled_      BOOLEAN := FALSE;
   reject_code_            VARCHAR2(8);   
   source_reference4_      VARCHAR2(50);
   source_reference5_      VARCHAR2(50);
   source_reference_type_  VARCHAR2(50);
   $IF Component_Rceipt_SYS.INSTALLED $THEN
      receipt_return_rec_  Receipt_Return_API.Return_Line_Rec;
   $END
BEGIN
   IF (Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_) = Fnd_Boolean_API.DB_TRUE ) THEN  
      catch_qty_enabled_ := TRUE;
   END IF;                  
   
   IF NOT (NVL(quantity_, 0) > 0 ) THEN
      Error_SYS.Record_General(lu_name_, 'QTYTOISSUEMUSTBEGRTTHANZERO: The quantity to issue must be greater than zero.');   
   END IF; 
   
   IF (catch_qty_enabled_) THEN  
      IF NOT (catch_quantity_ > 0 ) THEN 
         Error_SYS.Record_General(lu_name_, 'CATCHQTYTOISSUEMUSTBEGRTTHANZERO: The catch quantity to issue must be greater than zero.');   
      END IF;
   END IF;
   
   oldrec_ := Lock_By_Keys___(contract_, 
                              part_no_, 
                              configuration_id_, 
                              location_no_, 
                              lot_batch_no_, 
                              serial_no_, 
                              eng_chg_level_, 
                              waiv_dev_rej_no_, 
                              activity_seq_, 
                              handling_unit_id_, 
                              source_ref1_, 
                              source_ref2_, 
                              source_ref3_, 
                              source_ref4_, 
                              source_ref_type_db_, 
                              pick_list_no_, 
                              shipment_id_);   
   
   IF (quantity_ > oldrec_.qty_picked) THEN
      Error_SYS.Record_General(lu_name_, 'QTYTOISSUEGRETHANPICKED: Cannot issue more than picked.');         
   END IF;    
   
   newrec_  := oldrec_;    
   
   -- When the whole picked qty is issued and user has not defined a catch qty to issue,
   -- we are issuing catch qty picked already.
   IF (catch_qty_enabled_ AND (quantity_ = oldrec_.qty_picked) AND (oldrec_.catch_qty_picked IS NOT NULL) AND (catch_quantity_ IS NULL)) THEN
      catch_qty_to_issue_ := oldrec_.catch_qty_picked;          
   END IF;

   IF (source_ref_type_db_ = Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN) THEN       
      $IF Component_Rceipt_SYS.INSTALLED $THEN
         receipt_return_rec_  := Receipt_Return_API.Get_Record_By_Source_Refs(source_ref1_ => source_ref1_,
                                                                              source_ref2_ => source_ref2_,
                                                                              source_ref3_ => source_ref3_,
                                                                              source_ref4_ => NULL,
                                                                              shipment_conn_line_no_  => to_number(source_ref4_));
         source_reference4_      := receipt_return_rec_.receipt_no; 
         source_reference5_      := NULL;
         reject_code_            := receipt_return_rec_.return_reason;
         source_reference_type_  := Order_Type_API.Decode(Order_Type_API.DB_PURCHASE_ORDER);
      $ELSE
         Error_SYS.Component_Not_Exist('RCEIPT');
      $END 
   ELSE 
      source_reference4_     := source_ref4_;
      source_reference5_     := CASE shipment_id_ WHEN 0 THEN NULL ELSE shipment_id_ END;
      source_reference_type_ := Order_Type_API.Decode(Get_Order_Type_Db___(source_ref_type_db_));
   END IF;
   
   -- Issue from the stock
   Inventory_Part_In_Stock_API.Issue_Part(transaction_id_               => transaction_id_, 
                                          catch_quantity_               => catch_qty_to_issue_, 
                                          contract_                     => contract_,
                                          part_no_                      => part_no_,
                                          configuration_id_             => configuration_id_,
                                          location_no_                  => location_no_,
                                          lot_batch_no_                 => lot_batch_no_,
                                          serial_no_                    => serial_no_,
                                          eng_chg_level_                => eng_chg_level_,
                                          waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                          activity_seq_                 => activity_seq_,
                                          handling_unit_id_             => handling_unit_id_,
                                          transaction_                  => transaction_code_, 
                                          quantity_                     => quantity_,
                                          quantity_reserved_            => quantity_,
                                          source_ref1_                  => source_ref1_,
                                          source_ref2_                  => Get_Converted_Source_Ref(source_ref2_,2),
                                          source_ref3_                  => Get_Converted_Source_Ref(source_ref3_,3),
                                          source_ref4_                  => Get_Converted_Source_Ref(source_reference4_,4),
                                          source_ref5_                  => source_reference5_,
                                          source_                       => NULL,
                                          source_ref_type_              => source_reference_type_,
                                          dest_contract_                => dest_contract_,
                                          ignore_this_avail_control_id_ => ignore_this_avail_control_id_,
                                          validate_hu_struct_position_  => validate_hu_struct_position_,
                                          destination_warehouse_id_     => dest_warehouse_id_,
                                          reject_code_                  => reject_code_); 
                                          
   Inventory_Transaction_Hist_API.Set_Alt_Source_Ref(transaction_id_,
                                                     source_ref1_,
                                                     source_ref2_,
                                                     source_ref3_,
                                                     source_ref4_,
                                                     shipment_id_,
                                                     source_ref_type_db_);
                                       
                                          
   -- Inventory Part Reservation record update
   newrec_.qty_reserved := oldrec_.qty_reserved - quantity_;
   newrec_.qty_picked   := CASE remove_remaining_reservation_ 
                              WHEN TRUE THEN 0 
                              ELSE (oldrec_.qty_picked - quantity_) 
                           END;
   newrec_.qty_issued   := oldrec_.qty_issued + quantity_; 
   
   IF (catch_qty_enabled_) THEN
      IF (newrec_.qty_picked = 0) THEN
         newrec_.catch_qty_picked := 0;
      ELSE
         IF (catch_qty_to_issue_ < oldrec_.catch_qty_picked ) THEN         
            newrec_.catch_qty_picked := oldrec_.catch_qty_picked - catch_qty_to_issue_;
         ELSE -- catch_qty_to_issue_ >=  oldrec_.catch_qty_picked  
            -- Remaining picked catch qty is unknown when corresponding Inventory UoM quantity is != 0
            newrec_.catch_qty_picked := NULL;
         END IF;
      END IF;    
      newrec_.catch_qty_issued := NVL(oldrec_.catch_qty_issued, 0) + catch_qty_to_issue_;
   ELSE
      newrec_.catch_qty_picked := NULL;
      newrec_.catch_qty_issued := NULL; 
   END IF;  
      
   newrec_.expiration_date  := Inventory_Part_In_Stock_API.Get_Expiration_Date(contract_, 
                                                                               part_no_,
                                                                               configuration_id_,
                                                                               location_no_,
                                                                               lot_batch_no_,
                                                                               serial_no_,
                                                                               eng_chg_level_,
                                                                               waiv_dev_rej_no_,
                                                                               activity_seq_, 
                                                                               handling_unit_id_); 

   Update_Record___(newrec_               => newrec_, 
                    oldrec_               => oldrec_,
                    string_parameter1_    => string_parameter1_, 
                    string_parameter2_    => string_parameter2_);
                                          
   -- Unreserve remaining parts.      
   IF (remove_remaining_reservation_ AND (newrec_.qty_reserved > 0)) THEN
      Reserve_Part___(contract_                     => contract_, 
                      part_no_                      => part_no_, 
                      configuration_id_             => configuration_id_, 
                      location_no_                  => location_no_, 
                      lot_batch_no_                 => lot_batch_no_, 
                      serial_no_                    => serial_no_, 
                      eng_chg_level_                => eng_chg_level_, 
                      waiv_dev_rej_no_              => waiv_dev_rej_no_, 
                      activity_seq_                 => activity_seq_, 
                      handling_unit_id_             => handling_unit_id_,
                      quantity_                     => (newrec_.qty_reserved * -1),
                      source_ref_type_db_           => source_ref_type_db_,
                      source_ref1_                  => source_ref1_, 
                      source_ref2_                  => source_ref2_, 
                      source_ref3_                  => source_ref3_, 
                      source_ref4_                  => source_ref4_, 
                      pick_list_no_                 => pick_list_no_,
                      shipment_id_                  => shipment_id_,
                      ignore_this_avail_control_id_ => ignore_this_avail_control_id_);                                                  
   END IF;   
   
END Issue_Part___;   

 
PROCEDURE Reserve_Part___ (   
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,
   configuration_id_             IN  VARCHAR2,
   location_no_                  IN  VARCHAR2,
   lot_batch_no_                 IN  VARCHAR2,
   serial_no_                    IN  VARCHAR2,
   eng_chg_level_                IN  VARCHAR2,
   waiv_dev_rej_no_              IN  VARCHAR2,
   activity_seq_                 IN  NUMBER,
   handling_unit_id_             IN  NUMBER,
   quantity_                     IN  NUMBER,  
   source_ref_type_db_           IN  VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   pick_list_no_                 IN  NUMBER,
   shipment_id_                  IN  NUMBER,
   ignore_this_avail_control_id_ IN  VARCHAR2 DEFAULT NULL,
   string_parameter1_            IN  VARCHAR2 DEFAULT NULL,
   string_parameter2_            IN  VARCHAR2 DEFAULT NULL)
IS
  catch_qty_picked_   NUMBER;
BEGIN
   IF(quantity_ != 0) THEN
      Inventory_Part_In_Stock_API.Reserve_Part(catch_qty_picked_, 
                                               contract_, 
                                               part_no_, 
                                               configuration_id_,
                                               location_no_,
                                               lot_batch_no_,
                                               serial_no_,
                                               eng_chg_level_,
                                               waiv_dev_rej_no_,
                                               activity_seq_,
                                               handling_unit_id_,                                           
                                               quantity_,
                                               TRUE,
                                               ignore_this_avail_control_id_,
                                               source_ref_type_db_);  
      Modify_Qty_Reserved___(contract_             => contract_, 
                             part_no_              => part_no_, 
                             configuration_id_     => configuration_id_,
                             location_no_          => location_no_,
                             lot_batch_no_         => lot_batch_no_,
                             serial_no_            => serial_no_,
                             eng_chg_level_        => eng_chg_level_,
                             waiv_dev_rej_no_      => waiv_dev_rej_no_,
                             activity_seq_         => activity_seq_,
                             handling_unit_id_     => handling_unit_id_,                                 
                             source_ref1_          => source_ref1_,
                             source_ref2_          => source_ref2_,
                             source_ref3_          => source_ref3_,
                             source_ref4_          => source_ref4_,
                             source_ref_type_db_   => source_ref_type_db_,
                             pick_list_no_         => pick_list_no_,
                             shipment_id_          => shipment_id_,
                             qty_reserved_         => quantity_,
                             string_parameter1_    => string_parameter1_,
                             string_parameter2_    => string_parameter2_);
   END IF;
END Reserve_Part___;


FUNCTION Get_Order_Type_Db___ (
   inv_part_res_source_type_db_ IN  VARCHAR2) RETURN VARCHAR2
IS   
   order_type_db_ VARCHAR2(50);
BEGIN   
   order_type_db_ := CASE inv_part_res_source_type_db_
                        WHEN Inv_Part_Res_Source_Type_API.DB_PROJECT_DELIVERABLES THEN 
                             Order_Type_API.DB_PROJECT_DELIVERABLES
                        WHEN Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER THEN 
                             Order_Type_API.DB_SHIPMENT_ORDER         
                     END;
   RETURN (order_type_db_);
END Get_Order_Type_Db___;


PROCEDURE Fill_Keys_And_Qty___ (
   keys_and_qty_tab_ IN OUT Keys_And_Qty_Tab,
   keys_and_qty_rec_ IN     Keys_And_Qty_Rec )
IS
   index_                NUMBER;   
BEGIN
   index_ := keys_and_qty_tab_.COUNT;
   index_ := index_+ 1;   

   keys_and_qty_tab_(index_).contract                 := keys_and_qty_rec_.contract;
   keys_and_qty_tab_(index_).part_no                  := keys_and_qty_rec_.part_no;
   keys_and_qty_tab_(index_).configuration_id         := keys_and_qty_rec_.configuration_id;
   keys_and_qty_tab_(index_).location_no              := keys_and_qty_rec_.location_no;
   keys_and_qty_tab_(index_).lot_batch_no             := keys_and_qty_rec_.lot_batch_no;
   keys_and_qty_tab_(index_).serial_no                := keys_and_qty_rec_.serial_no;
   keys_and_qty_tab_(index_).eng_chg_level            := keys_and_qty_rec_.eng_chg_level;
   keys_and_qty_tab_(index_).waiv_dev_rej_no          := keys_and_qty_rec_.waiv_dev_rej_no;
   keys_and_qty_tab_(index_).activity_seq             := keys_and_qty_rec_.activity_seq;
   keys_and_qty_tab_(index_).handling_unit_id         := keys_and_qty_rec_.handling_unit_id;
   keys_and_qty_tab_(index_).source_ref1              := keys_and_qty_rec_.source_ref1;
   keys_and_qty_tab_(index_).source_ref2              := keys_and_qty_rec_.source_ref2;
   keys_and_qty_tab_(index_).source_ref3              := keys_and_qty_rec_.source_ref3;
   keys_and_qty_tab_(index_).source_ref4              := keys_and_qty_rec_.source_ref4;
   keys_and_qty_tab_(index_).source_ref_type_db       := keys_and_qty_rec_.source_ref_type_db;
   keys_and_qty_tab_(index_).part_tracking_session_id := keys_and_qty_rec_.part_tracking_session_id;
   keys_and_qty_tab_(index_).pick_list_no             := keys_and_qty_rec_.pick_list_no;
   keys_and_qty_tab_(index_).shipment_id              := keys_and_qty_rec_.shipment_id;
   keys_and_qty_tab_(index_).qty_picked               := keys_and_qty_rec_.qty_picked;
   keys_and_qty_tab_(index_).catch_qty_picked         := keys_and_qty_rec_.catch_qty_picked;
   keys_and_qty_tab_(index_).ship_handling_unit_id    := keys_and_qty_rec_.ship_handling_unit_id;
END Fill_Keys_And_Qty___;


PROCEDURE Set_Qty_Picked___ (
   keys_and_qty_tab_            IN Keys_And_Qty_Tab,
   ship_inventory_location_no_  IN VARCHAR2,
   validate_hu_struct_position_ IN BOOLEAN,
   add_hu_to_shipment_          IN BOOLEAN,
   keep_remaining_reservation_  IN BOOLEAN )
IS
BEGIN
   IF (keys_and_qty_tab_.COUNT > 0 ) THEN
      FOR i IN keys_and_qty_tab_.FIRST..keys_and_qty_tab_.LAST LOOP
         Report_Picking___(contract_                    => keys_and_qty_tab_(i).contract,
                           part_no_                     => keys_and_qty_tab_(i).part_no,
                           configuration_id_            => keys_and_qty_tab_(i).configuration_id,
                           location_no_                 => keys_and_qty_tab_(i).location_no,
                           lot_batch_no_                => keys_and_qty_tab_(i).lot_batch_no,
                           serial_no_                   => keys_and_qty_tab_(i).serial_no,
                           eng_chg_level_               => keys_and_qty_tab_(i).eng_chg_level,
                           waiv_dev_rej_no_             => keys_and_qty_tab_(i).waiv_dev_rej_no,
                           activity_seq_                => keys_and_qty_tab_(i).activity_seq,
                           handling_unit_id_            => keys_and_qty_tab_(i).handling_unit_id,  
                           qty_picked_                  => keys_and_qty_tab_(i).qty_picked,
                           part_tracking_session_id_    => keys_and_qty_tab_(i).part_tracking_session_id,
                           catch_qty_picked_            => keys_and_qty_tab_(i).catch_qty_picked,
                           source_ref_type_db_          => keys_and_qty_tab_(i).source_ref_type_db,
                           source_ref1_                 => keys_and_qty_tab_(i).source_ref1,
                           source_ref2_                 => keys_and_qty_tab_(i).source_ref2,
                           source_ref3_                 => keys_and_qty_tab_(i).source_ref3,
                           source_ref4_                 => keys_and_qty_tab_(i).source_ref4,  
                           pick_list_no_                => keys_and_qty_tab_(i).pick_list_no,
                           shipment_id_                 => keys_and_qty_tab_(i).shipment_id,
                           ship_inventory_location_no_  => ship_inventory_location_no_,
                           keep_remaining_reservation_  => keep_remaining_reservation_,
                           validate_hu_struct_position_ => validate_hu_struct_position_,
                           add_hu_to_shipment_          => add_hu_to_shipment_,
                           ship_handling_unit_id_       => keys_and_qty_tab_(i).ship_handling_unit_id );
      END LOOP; 
   END IF;
END Set_Qty_Picked___;  


PROCEDURE Report_Picking___ (
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,  
   qty_picked_                  IN NUMBER,
   part_tracking_session_id_    IN NUMBER,
   catch_qty_picked_            IN NUMBER,
   source_ref_type_db_          IN VARCHAR2,
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2 DEFAULT '*',
   source_ref3_                 IN VARCHAR2 DEFAULT '*',
   source_ref4_                 IN VARCHAR2 DEFAULT '*',  
   pick_list_no_                IN NUMBER   DEFAULT 0,
   shipment_id_                 IN NUMBER   DEFAULT 0, 
   ship_inventory_location_no_  IN VARCHAR2 DEFAULT NULL,
   keep_remaining_reservation_  IN BOOLEAN  DEFAULT FALSE,
   validate_hu_struct_position_ IN BOOLEAN  DEFAULT TRUE,
   add_hu_to_shipment_          IN BOOLEAN  DEFAULT TRUE,
   string_parameter1_           IN VARCHAR2 DEFAULT NULL,
   string_parameter2_           IN VARCHAR2 DEFAULT NULL,
   ship_handling_unit_id_       IN NUMBER   DEFAULT NULL )
IS
   oldrec_                       inventory_part_reservation_tab%ROWTYPE;
   qty_to_reserve_               NUMBER:=0;
   number_of_serials_            NUMBER:=0;
   serial_catch_tab_             Inventory_Part_In_Stock_API.Serial_Catch_Table;
   info_                         VARCHAR2(2000);
   ignore_this_avail_control_id_ VARCHAR2(25);
   $IF Component_Shpmnt_SYS.INSTALLED $THEN
   warehouse_info_               Shipment_Source_Utility_API.Warehouse_Info_Rec;
   $END
BEGIN
   IF (part_tracking_session_id_ IS NULL) THEN
      IF ((serial_no_ = '*') AND (Part_Catalog_API.Serial_Tracked_Only_Rece_Issue(part_no_)) AND (qty_picked_ != 0)) THEN
         Error_SYS.Record_General(lu_name_, 'SERIALIDREQ: Requires a serial identification to proceed with Report Picking.');
      END IF;
   ELSE   
      number_of_serials_ := Temporary_Part_Tracking_API.Get_Number_Of_Serials(part_tracking_session_id_);
      IF (number_of_serials_ != qty_picked_) THEN
         Error_SYS.Record_General(lu_name_, 'PICKSERCOUNTDIF: The quantity to be picked is :P1 but the number of identified serials is :P2', qty_picked_, number_of_serials_);
      END IF;
   END IF;
   
   IF ((shipment_id_ != 0) AND (qty_picked_ != 0) AND (ship_inventory_location_no_ IS NULL)) THEN 
      Error_SYS.Record_General(lu_name_, 'SHIPINVLOCNULL: The shipment location must be entered when shipment inventory is used.');
   END IF;

   oldrec_ := Lock_By_Keys___(contract_, 
                              part_no_, 
                              configuration_id_, 
                              location_no_, 
                              lot_batch_no_, 
                              serial_no_, 
                              eng_chg_level_, 
                              waiv_dev_rej_no_, 
                              activity_seq_, 
                              handling_unit_id_, 
                              source_ref1_, 
                              source_ref2_, 
                              source_ref3_, 
                              source_ref4_, 
                              source_ref_type_db_, 
                              pick_list_no_, 
                              shipment_id_);
                              
   
   IF (((oldrec_.qty_reserved - oldrec_.qty_picked) = 0) AND (qty_picked_ != 0)) THEN
      Error_SYS.Record_General(lu_name_, 'RESALREADYPICKED: The reservation line has already been pick reported for this pick list.');
   END IF;                        
   
   IF (source_ref_type_db_ = Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN) THEN
      IF (qty_picked_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'ZEROPICKINGFORPRR: Unreserve is not allowed for :P1', Inv_Part_Res_Source_Type_API.Decode(source_ref_type_db_));
      END IF;    
   END IF ;
   
   qty_to_reserve_ := qty_picked_ - oldrec_.qty_reserved;
   
   -- Remove the remaining reservation when doing zero picking and partial picking with Keep Remaining Reservation at Partial Picking unchecked.
   IF ((qty_picked_ = 0) OR ((qty_to_reserve_ < 0) AND (NOT keep_remaining_reservation_))) THEN
      
      IF (source_ref_type_db_ = Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER) THEN
         $IF Component_Shpmnt_SYS.INSTALLED $THEN
            warehouse_info_               := Shipment_Source_Utility_API.Get_Warehouse_Info(shipment_id_, source_ref1_, source_ref_type_db_);
            ignore_this_avail_control_id_ := warehouse_info_.availability_control_id;
         $ELSE   
            Error_SYS.Component_Not_Exist('SHPMNT');
         $END
      END IF;
      
      Reserve_Part___(contract_                     => contract_, 
                      part_no_                      => part_no_, 
                      configuration_id_             => configuration_id_, 
                      location_no_                  => location_no_, 
                      lot_batch_no_                 => lot_batch_no_, 
                      serial_no_                    => serial_no_, 
                      eng_chg_level_                => eng_chg_level_, 
                      waiv_dev_rej_no_              => waiv_dev_rej_no_, 
                      activity_seq_                 => activity_seq_, 
                      handling_unit_id_             => handling_unit_id_,
                      quantity_                     => qty_to_reserve_,
                      source_ref_type_db_           => source_ref_type_db_,
                      source_ref1_                  => source_ref1_, 
                      source_ref2_                  => source_ref2_, 
                      source_ref3_                  => source_ref3_, 
                      source_ref4_                  => source_ref4_,
                      pick_list_no_                 => pick_list_no_,
                      shipment_id_                  => shipment_id_,
                      ignore_this_avail_control_id_ => ignore_this_avail_control_id_);
   END IF;   
      
   IF (qty_picked_ != 0) THEN
      IF (part_tracking_session_id_ IS NULL) THEN  
         IF (shipment_id_ != 0) THEN
            serial_catch_tab_(1).serial_no := serial_no_;
         END IF;
         Modify_Qty_Picked___(contract_            ,
                              part_no_             ,
                              configuration_id_    ,
                              location_no_         ,
                              lot_batch_no_        ,
                              serial_no_           ,
                              eng_chg_level_       ,
                              waiv_dev_rej_no_     ,
                              activity_seq_        ,
                              handling_unit_id_    ,   
                              source_ref1_         ,
                              source_ref2_         ,
                              source_ref3_         ,
                              source_ref4_         ,
                              source_ref_type_db_  ,
                              pick_list_no_        ,
                              shipment_id_         ,
                              qty_picked_          ,  
                              catch_qty_picked_    ,
                              string_parameter1_   ,
                              string_parameter2_   );
      ELSE
         IF (shipment_id_ != 0) THEN
            serial_catch_tab_ := Temporary_Part_Tracking_API.Get_Serials(part_tracking_session_id_);
         END IF;
         Identify_Serials(contract_                   => contract_,
                          part_no_                    => part_no_,
                          configuration_id_           => configuration_id_,
                          location_no_                => location_no_,
                          lot_batch_no_               => lot_batch_no_,
                          eng_chg_level_              => eng_chg_level_,
                          waiv_dev_rej_no_            => waiv_dev_rej_no_,
                          activity_seq_               => activity_seq_,
                          handling_unit_id_           => handling_unit_id_,
                          part_tracking_session_id_   => part_tracking_session_id_,
                          source_ref_type_db_         => source_ref_type_db_,
                          source_ref1_                => source_ref1_,
                          source_ref2_                => source_ref2_,
                          source_ref3_                => source_ref3_,
                          source_ref4_                => source_ref4_,
                          pick_list_no_               => pick_list_no_,
                          shipment_id_                => shipment_id_,
                          on_pick_reporting_          => Fnd_Boolean_API.DB_TRUE);
      END IF;
      
      IF (shipment_id_ != 0) THEN
         FOR i IN serial_catch_tab_.FIRST .. serial_catch_tab_.LAST LOOP
            $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
               Handle_Ship_Invent_Utility_API.Move_To_Shipment_Location(info_                         => info_,               
                                                                        order_no_                     => source_ref1_,          
                                                                        line_no_                      => Get_Converted_Source_Ref(source_ref2_, 2),               
                                                                        rel_no_                       => Get_Converted_Source_Ref(source_ref3_, 3),
                                                                        line_item_no_                 => Get_Converted_Source_Ref(source_ref4_, 4),   
                                                                        source_ref_type_db_           => Reserve_Shipment_API.Get_Logistic_Source_Type_Db(source_ref_type_db_),
                                                                        contract_                     => contract_,              
                                                                        part_no_                      => part_no_,
                                                                        location_no_                  => location_no_,        
                                                                        lot_batch_no_                 => lot_batch_no_,          
                                                                        serial_no_                    => serial_catch_tab_(i).serial_no,
                                                                        eng_chg_level_                => eng_chg_level_,      
                                                                        waiv_dev_rej_no_              => waiv_dev_rej_no_,
                                                                        pick_list_no_                 => pick_list_no_,       
                                                                        configuration_id_             => configuration_id_,      
                                                                        activity_seq_                 => activity_seq_, 
                                                                        handling_unit_id_             => handling_unit_id_,
                                                                        shipment_location_            => ship_inventory_location_no_,   
                                                                        input_qty_                    => NULL,             
                                                                        input_unit_meas_              => NULL,       
                                                                        input_conv_factor_            => NULL,  
                                                                        input_variable_values_        => NULL, 
                                                                        shipment_id_                  => shipment_id_, 
                                                                        validate_hu_struct_position_  => validate_hu_struct_position_,
                                                                        add_hu_to_shipment_           => add_hu_to_shipment_,
                                                                        ship_handling_unit_id_        => ship_handling_unit_id_ );
            $ELSE
                NULL;
            $END                                             
         END LOOP;   
      END IF;
   END IF;
   
END Report_Picking___;


PROCEDURE Post_Pick_Report_Shipment___ (
   shipment_id_                IN NUMBER,
   pick_list_no_               IN NUMBER,
   ship_inventory_location_no_ IN VARCHAR2,
   trigger_shipment_flow_      IN BOOLEAN )
IS
BEGIN
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
      Pick_Shipment_API.Post_Pick_Report_Shipment(shipment_id_                => shipment_id_,
                                                  pick_list_no_               => pick_list_no_,
                                                  use_generic_reservation_    => 'TRUE',
                                                  ship_inventory_location_no_ => ship_inventory_location_no_,
                                                  trigger_shipment_flow_      => trigger_shipment_flow_);
   $ELSE
      Error_SYS.Component_Not_Exist('SHPMNT');
   $END
END Post_Pick_Report_Shipment___;

PROCEDURE Post_Update_Actions___ (
   oldrec_                  IN inventory_part_reservation_tab%ROWTYPE,
   newrec_                  IN inventory_part_reservation_tab%ROWTYPE,
   string_parameter1_       IN VARCHAR2,
   string_parameter2_       IN VARCHAR2,
   number_parameter1_       IN NUMBER DEFAULT NULL)
IS
   qty_reserved_          NUMBER := 0;
   qty_picked_            NUMBER := 0;
   qty_reserved_changed_  BOOLEAN := FALSE;
   qty_picked_changed_    BOOLEAN := FALSE;
   qty_issued_changed_    BOOLEAN := FALSE;
BEGIN
   IF Validate_SYS.Is_Changed(oldrec_.qty_reserved, newrec_.qty_reserved) THEN
      qty_reserved_ := newrec_.qty_reserved - oldrec_.qty_reserved; 
      qty_reserved_changed_ := TRUE;
   END IF;
   
   IF Validate_SYS.Is_Changed(oldrec_.qty_picked, newrec_.qty_picked) THEN
      qty_picked_   := newrec_.qty_picked - oldrec_.qty_picked;
      qty_picked_changed_ := TRUE;
   END IF;

   IF Validate_SYS.Is_Changed(oldrec_.qty_issued, newrec_.qty_issued) THEN
      qty_issued_changed_ := TRUE;
   END IF;    
 
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN 
      IF ((qty_reserved_changed_ OR qty_picked_changed_)
           AND ((oldrec_.qty_issued = newrec_.qty_issued) OR (qty_issued_changed_ AND string_parameter1_ = 'UNDO_DELIVERY'))) THEN
         Reserve_Shipment_API.Post_Update_Reserv_Actions(newrec_.source_ref1,
                                                         Get_Converted_Source_Ref(newrec_.source_ref2,2),
                                                         Get_Converted_Source_Ref(newrec_.source_ref3,3),
                                                         Get_Converted_Source_Ref(newrec_.source_ref4,4),
                                                         newrec_.source_ref_type,                                                                
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
                                                         Convert_Pick_List_No___(newrec_.pick_list_no),  --Need to convert 0 to "*" when calling shipment.                                                            
                                                         newrec_.shipment_id,                                                             
                                                         newrec_.qty_reserved,
                                                         oldrec_.qty_reserved,
                                                         newrec_.qty_picked,
                                                         oldrec_.qty_picked,
                                                         newrec_.qty_issued,
                                                         string_parameter1_,
                                                         string_parameter2_,
                                                         number_parameter1_);
      END IF; 

      IF ((qty_issued_changed_) AND (string_parameter1_ = 'UPDATE_SHIPMENTLINE')) THEN
         Shipment_Delivery_Utility_API.Post_Update_Delivery_Actions(newrec_.shipment_id, 
                                                                    newrec_.source_ref1, 
                                                                    Get_Converted_Source_Ref(newrec_.source_ref2,2), 
                                                                    Get_Converted_Source_Ref(newrec_.source_ref3,3), 
                                                                    Get_Converted_Source_Ref(newrec_.source_ref4,4), 
                                                                    newrec_.source_ref_type);   
      END IF;
   $END
   
   IF (newrec_.pick_list_no != 0 AND qty_reserved_changed_) THEN
      Hu_Snapshot_For_Refresh_API.New(source_ref1_          => newrec_.pick_list_no,
                                      source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
   END IF;

   

   IF (qty_reserved_changed_) THEN
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
                                                      quantity_diff_          => qty_reserved_,
                                                      catch_quantity_diff_    => NULL,
                                                      order_ref1_             => newrec_.source_ref1,
                                                      order_ref2_             => Get_Converted_Source_Ref(newrec_.source_ref2,2),
                                                      order_ref3_             => Get_Converted_Source_Ref(newrec_.source_ref3,3),
                                                      order_ref4_             => Get_Converted_Source_Ref(newrec_.source_ref4,4),
                                                      pick_list_no_           => Convert_Pick_List_No___(newrec_.pick_list_no),
                                                      shipment_id_            => newrec_.shipment_id,
                                                      order_type_db_          => newrec_.source_ref_type );
   END IF;      
END Post_Update_Actions___;


PROCEDURE Post_Delete_Actions___ (
   remrec_                  IN inventory_part_reservation_tab%ROWTYPE,
   string_parameter1_       IN VARCHAR2,
   string_parameter2_       IN VARCHAR2)
IS
BEGIN   
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN     
      Reserve_Shipment_API.Post_Unreservation_Actions(remrec_.source_ref1,
                                                      Get_Converted_Source_Ref(remrec_.source_ref2,2),
                                                      Get_Converted_Source_Ref(remrec_.source_ref3,3),
                                                      Get_Converted_Source_Ref(remrec_.source_ref4,4),
                                                      remrec_.source_ref_type,
                                                      remrec_.contract,
                                                      remrec_.part_no,
                                                      remrec_.configuration_id,
                                                      remrec_.location_no,
                                                      remrec_.lot_batch_no,
                                                      remrec_.serial_no,
                                                      remrec_.eng_chg_level,
                                                      remrec_.waiv_dev_rej_no,
                                                      remrec_.activity_seq,
                                                      remrec_.handling_unit_id,
                                                      Convert_Pick_List_No___(remrec_.pick_list_no),  --Need to convert 0 to "*" when calling shipment.
                                                      remrec_.shipment_id,
                                                      remrec_.qty_reserved,
                                                      remrec_.qty_picked,
                                                      string_parameter1_,
                                                      string_parameter2_);
  $END
 
   IF (remrec_.pick_list_no != 0) THEN
      Hu_Snapshot_For_Refresh_API.New(source_ref1_          => remrec_.pick_list_no,
                                      source_ref_type_db_   => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST);
   END IF;   

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
                                                   quantity_diff_          => -(remrec_.qty_reserved),
                                                   catch_quantity_diff_    => NULL,
                                                   order_ref1_             => remrec_.source_ref1,
                                                   order_ref2_             => Get_Converted_Source_Ref(remrec_.source_ref2,2),
                                                   order_ref3_             => Get_Converted_Source_Ref(remrec_.source_ref3,3),
                                                   order_ref4_             => Get_Converted_Source_Ref(remrec_.source_ref4,4),
                                                   pick_list_no_           => Convert_Pick_List_No___(remrec_.pick_list_no),
                                                   shipment_id_            => remrec_.shipment_id,
                                                   order_type_db_          => remrec_.source_ref_type);
END Post_Delete_Actions___;


PROCEDURE Modify_Pick_By_Choice_Block___(
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
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   pick_list_no_              IN NUMBER,
   shipment_id_               IN NUMBER,
   pick_by_choice_blocked_db_ IN VARCHAR2)
IS  
   newrec_    inventory_part_reservation_tab%ROWTYPE;
   oldrec_    inventory_part_reservation_tab%ROWTYPE;
BEGIN
   IF (Check_Exist___(contract_           => contract_, 
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
                      pick_list_no_       => pick_list_no_, 
                      shipment_id_        => shipment_id_)) THEN
      oldrec_ := Lock_By_Keys___(contract_           => contract_, 
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
                                 pick_list_no_       => pick_list_no_, 
                                 shipment_id_        => shipment_id_);
      newrec_ := oldrec_;                      
      IF (newrec_.pick_by_choice_blocked != pick_by_choice_blocked_db_) THEN 
         newrec_.pick_by_choice_blocked :=  pick_by_choice_blocked_db_;  
         Update_Record___(newrec_  => newrec_, 
                          oldrec_  => oldrec_);       
      END IF;    
   END IF;
END Modify_Pick_By_Choice_Block___;


PROCEDURE Pick_Reservation___ (
   keys_and_qty_tab_             IN Keys_And_Qty_Tab,
   pick_list_no_                 IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   report_from_pick_list_header_ IN VARCHAR2,
   ship_inventory_location_no_   IN VARCHAR2 DEFAULT NULL,
   validate_hu_struct_position_  IN BOOLEAN  DEFAULT TRUE,
   add_hu_to_shipment_           IN BOOLEAN  DEFAULT TRUE )
IS 

   keep_remaining_reservation_  BOOLEAN:= FALSE;
   local_ship_inv_loc_no_       VARCHAR2(35);
BEGIN
   
   IF (NVL(shipment_id_, 0) != 0) THEN
      local_ship_inv_loc_no_ := NVL(ship_inventory_location_no_, Inventory_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_));
   END IF;
   
   Inventory_Event_Manager_API.Start_Session;
   IF (keys_and_qty_tab_.COUNT > 0 ) THEN
      $IF (Component_Shpmnt_SYS.INSTALLED) $THEN 
         IF (((Pick_Shipment_API.Keep_Remaining_Reservation(shipment_id_)) = 'TRUE')
             AND (NVL(report_from_pick_list_header_, 'FALSE') = 'FALSE')) THEN
            keep_remaining_reservation_ := TRUE;
         END IF;   
      $ELSE
         Error_SYS.Component_Not_Exist('SHPMNT');
      $END
      Set_Qty_Picked___(keys_and_qty_tab_, local_ship_inv_loc_no_, validate_hu_struct_position_, 
                        add_hu_to_shipment_, keep_remaining_reservation_);
   END IF;   
   
   IF (NVL(shipment_id_, 0) != 0) THEN
      Post_Pick_Report_Shipment___(shipment_id_                => shipment_id_, 
                                   pick_list_no_               => pick_list_no_,
                                   ship_inventory_location_no_ => local_ship_inv_loc_no_, 
                                   trigger_shipment_flow_      => TRUE);
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
END Pick_Reservation___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Pick_Aggregated_Reservations__ (
   message_            IN  CLOB,
   pick_list_no_       IN  NUMBER,
   ship_location_no_   IN  VARCHAR2,
   unreserve_          IN  VARCHAR2 DEFAULT 'FALSE' ) RETURN CLOB
IS
   aggregated_line_msg_       CLOB;
   clob_out_data_             CLOB;
   count_                     NUMBER;
   name_arr_                  Message_SYS.name_table;
   value_arr_                 Message_SYS.line_table;
   
   CURSOR get_pick_list_lines_hu(handling_unit_id_ NUMBER) IS 
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type, 
             (qty_reserved - qty_picked) qty_to_pick,
             contract, part_no, configuration_id, lot_batch_no, serial_no, eng_chg_level, location_no,
             waiv_dev_rej_no, activity_seq, handling_unit_id  
        FROM inventory_part_reservation_tab ipr
       WHERE pick_list_no = pick_list_no_
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM HANDLING_UNIT_PUB hu
                                 CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_)
         AND (qty_reserved - qty_picked) > 0;
      
   CURSOR get_pick_list_lines_loc(location_no_ VARCHAR2) IS 
      SELECT source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type,   
             (qty_reserved - qty_picked) qty_to_pick,
             contract, part_no, configuration_id, lot_batch_no, serial_no, eng_chg_level, location_no,
             waiv_dev_rej_no, activity_seq, handling_unit_id  
        FROM inventory_part_reservation_tab ipr
       WHERE pick_list_no = pick_list_no_
         AND location_no  = location_no_
         AND EXISTS (SELECT *
                       FROM inv_part_stock_snapshot_pub ipss
                      WHERE ipss.source_ref1        = ipr.pick_list_no
                        AND ipss.handling_unit_id   = ipr.handling_unit_id
                        AND ipss.location_no        = ipr.location_no
                        AND ipss.source_ref_type_db = Handl_Unit_Snapshot_Type_API.DB_PICK_LIST)
         AND (qty_reserved - qty_picked) > 0;
                    
   TYPE Pick_List_Lines_Tab IS TABLE OF get_pick_list_lines_hu%ROWTYPE INDEX BY PLS_INTEGER;
   TYPE Locations_Tab IS TABLE OF VARCHAR2(35) INDEX BY PLS_INTEGER;
   
   pick_list_lines_tab_         Pick_List_Lines_Tab;
   locations_to_pick_tab_       Locations_Tab;
   handling_units_to_pick_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   aggregated_line_msg_      := Message_SYS.Construct_Clob_Message('AGGREGATED_LINE');
   Inventory_Event_Manager_API.Start_Session;
   
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'LOCATION_NO') THEN   
         locations_to_pick_tab_(locations_to_pick_tab_.COUNT + 1) := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         handling_units_to_pick_tab_(handling_units_to_pick_tab_.COUNT + 1).handling_unit_id := value_arr_(n_);
      END IF;
   END LOOP;
   
   IF (locations_to_pick_tab_.COUNT > 0 AND handling_units_to_pick_tab_.COUNT > 0) THEN
      Error_SYS.Record_General(lu_name_, 'Picking both Handling Units and Locations is not supported.');
   END IF;
   
   IF (handling_units_to_pick_tab_.COUNT > 0) THEN
      -- We filter out any lower level Handling Unit that has any of it's parent already in the collection. By doing this
      -- we avoid picking the same reservations twice.
      handling_units_to_pick_tab_ := Handling_Unit_API.Get_Outermost_Units_Only(handling_units_to_pick_tab_);
      
      FOR i IN handling_units_to_pick_tab_.FIRST .. handling_units_to_pick_tab_.LAST LOOP
         -- To be able to move a Handling Unit to Shipment Inventory we need to disconnect it from it's parent.
         IF (ship_location_no_ IS NOT NULL) THEN
            Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_          => handling_units_to_pick_tab_(i).handling_unit_id, 
                                                             parent_handling_unit_id_   => NULL);
         END IF;
         
         OPEN get_pick_list_lines_hu(handling_units_to_pick_tab_(i).handling_unit_id);
         FETCH get_pick_list_lines_hu BULK COLLECT INTO pick_list_lines_tab_;
         CLOSE get_pick_list_lines_hu;
         
         IF (pick_list_lines_tab_.COUNT > 0) THEN
            FOR j IN pick_list_lines_tab_.FIRST .. pick_list_lines_tab_.LAST LOOP
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'CONTRACT',           pick_list_lines_tab_(j).contract);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'PART_NO',            pick_list_lines_tab_(j).part_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'CONFIGURATION_ID',   pick_list_lines_tab_(j).configuration_id);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'LOCATION_NO',        pick_list_lines_tab_(j).location_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'LOT_BATCH_NO',       pick_list_lines_tab_(j).lot_batch_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SERIAL_NO',          pick_list_lines_tab_(j).serial_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'ENG_CHG_LEVEL',      pick_list_lines_tab_(j).eng_chg_level);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'WAIV_DEV_REJ_NO',    pick_list_lines_tab_(j).waiv_dev_rej_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'ACTIVITY_SEQ',       pick_list_lines_tab_(j).activity_seq);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'HANDLING_UNIT_ID',   pick_list_lines_tab_(j).handling_unit_id);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF1',        pick_list_lines_tab_(j).source_ref1);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF2',        pick_list_lines_tab_(j).source_ref2);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF3',        pick_list_lines_tab_(j).source_ref3);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF4',        pick_list_lines_tab_(j).source_ref4);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF_TYPE_DB', pick_list_lines_tab_(j).source_ref_type);
               
               IF (unreserve_ = 'TRUE') THEN
                  Message_SYS.Add_Attribute(aggregated_line_msg_, 'QTY_PICKED', 0);
               ELSE
                  Message_SYS.Add_Attribute(aggregated_line_msg_, 'QTY_PICKED', pick_list_lines_tab_(j).qty_to_pick);
               END IF;
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'PACK_COMPLETE', 'TRUE');

               IF (handling_units_to_pick_tab_.LAST = i AND pick_list_lines_tab_.LAST = j) THEN 
                  -- Only call Pick_Inv_Part_Reservations when passing the last handling unit 
                  clob_out_data_ := Pick_Inv_Part_Reservations(message_                      => aggregated_line_msg_,
                                                               pick_list_no_                 => pick_list_no_,
                                                               report_from_pick_list_header_ => 'FALSE',
                                                               ship_inventory_location_no_   => ship_location_no_,
                                                               validate_hu_struct_position_  => FALSE,
                                                               add_hu_to_shipment_           => FALSE);
               END IF;
            END LOOP;
         END IF ;
      END LOOP;
   END IF;
   
   IF (locations_to_pick_tab_.COUNT > 0) THEN
      FOR i IN locations_to_pick_tab_.FIRST .. locations_to_pick_tab_.LAST LOOP
         OPEN get_pick_list_lines_loc(locations_to_pick_tab_(i));
         FETCH get_pick_list_lines_loc BULK COLLECT INTO pick_list_lines_tab_;
         CLOSE get_pick_list_lines_loc;

         IF (pick_list_lines_tab_.COUNT > 0) THEN
            FOR j IN pick_list_lines_tab_.FIRST .. pick_list_lines_tab_.LAST LOOP
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'CONTRACT',           pick_list_lines_tab_(j).contract);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'PART_NO',            pick_list_lines_tab_(j).part_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'CONFIGURATION_ID',   pick_list_lines_tab_(j).configuration_id);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'LOCATION_NO',        pick_list_lines_tab_(j).location_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'LOT_BATCH_NO',       pick_list_lines_tab_(j).lot_batch_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SERIAL_NO',          pick_list_lines_tab_(j).serial_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'ENG_CHG_LEVEL',      pick_list_lines_tab_(j).eng_chg_level);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'WAIV_DEV_REJ_NO',    pick_list_lines_tab_(j).waiv_dev_rej_no);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'ACTIVITY_SEQ',       pick_list_lines_tab_(j).activity_seq);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'HANDLING_UNIT_ID',   pick_list_lines_tab_(j).handling_unit_id);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF1',        pick_list_lines_tab_(j).source_ref1);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF2',        pick_list_lines_tab_(j).source_ref2);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF3',        pick_list_lines_tab_(j).source_ref3);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF4',        pick_list_lines_tab_(j).source_ref4);
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'SOURCE_REF_TYPE_DB', pick_list_lines_tab_(j).source_ref_type);
               
               IF (unreserve_ = 'TRUE') THEN
                  Message_SYS.Add_Attribute(aggregated_line_msg_, 'QTY_PICKED', 0);
               ELSE
                  Message_SYS.Add_Attribute(aggregated_line_msg_, 'QTY_PICKED', pick_list_lines_tab_(j).qty_to_pick);
               END IF;
               Message_SYS.Add_Attribute(aggregated_line_msg_, 'PACK_COMPLETE', 'TRUE');

               IF (pick_list_lines_tab_.LAST = j) THEN 
                  -- Only call Pick_Inv_Part_Reservations when passing the last pick list line in the selection 
                  clob_out_data_ := Pick_Inv_Part_Reservations(aggregated_line_msg_, pick_list_no_, 'FALSE', ship_location_no_);
               END IF;
            END LOOP;
         END IF;
      END LOOP;
   END IF;
                                     
   Inventory_Event_Manager_API.Finish_Session;  
   RETURN clob_out_data_;
END Pick_Aggregated_Reservations__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Find_And_Reserve_Part
-- This method is used to do automatic reservation. 
PROCEDURE Find_And_Reserve_Part (
   quantity_reserved_            OUT NUMBER,
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,
   configuration_id_             IN  VARCHAR2,
   quantity_to_reserve_          IN  NUMBER,
   source_ref_type_db_           IN  VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2 DEFAULT '*',
   source_ref3_                  IN  VARCHAR2 DEFAULT '*',
   source_ref4_                  IN  VARCHAR2 DEFAULT '*',
   shipment_id_                  IN  NUMBER   DEFAULT 0,    
   location_type_db_             IN  VARCHAR2 DEFAULT Inventory_Location_Type_API.DB_PICKING,
   part_ownership_db_            IN  VARCHAR2 DEFAULT Part_Ownership_API.DB_COMPANY_OWNED,
   owning_vendor_no_             IN  VARCHAR2 DEFAULT NULL,
   owning_customer_no_           IN  VARCHAR2 DEFAULT NULL,
   location_no_                  IN  VARCHAR2 DEFAULT NULL,
   lot_batch_no_                 IN  VARCHAR2 DEFAULT NULL,
   serial_no_                    IN  VARCHAR2 DEFAULT NULL,
   eng_chg_level_                IN  VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_              IN  VARCHAR2 DEFAULT NULL,
   activity_seq_                 IN  NUMBER   DEFAULT NULL,
   handling_unit_id_             IN  NUMBER   DEFAULT NULL,
   project_id_                   IN  VARCHAR2 DEFAULT NULL,
   condition_code_               IN  VARCHAR2 DEFAULT NULL,
   only_one_lot_allowed_         IN  BOOLEAN  DEFAULT FALSE,
   many_records_allowed_         IN  BOOLEAN  DEFAULT TRUE,
   expiration_control_date_      IN  DATE     DEFAULT NULL,
   warehouse_id_                 IN  VARCHAR2 DEFAULT NULL,
   ignore_this_avail_control_id_ IN  VARCHAR2 DEFAULT NULL,
   include_temp_table_locs_      IN  BOOLEAN  DEFAULT TRUE,
   string_parameter1_            IN  VARCHAR2 DEFAULT NULL,
   string_parameter2_            IN  VARCHAR2 DEFAULT NULL,
   pick_list_no_                 IN  NUMBER   DEFAULT 0)
IS
   keys_and_qty_tab_    Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;     
   local_activity_seq_  NUMBER       := activity_seq_;
   local_project_id_    VARCHAR2(10) := project_id_;
BEGIN
   quantity_reserved_ := 0;
   LOOP
      Inventory_Part_In_Stock_API.Find_And_Reserve_Part(keys_and_qty_tab_             => keys_and_qty_tab_             ,
                                                        location_no_                  => location_no_                  ,
                                                        lot_batch_no_                 => lot_batch_no_                 ,
                                                        serial_no_                    => serial_no_                    ,
                                                        eng_chg_level_                => eng_chg_level_                ,
                                                        waiv_dev_rej_no_              => waiv_dev_rej_no_              ,
                                                        configuration_id_             => configuration_id_             ,
                                                        activity_seq_                 => local_activity_seq_           ,
                                                        handling_unit_id_             => handling_unit_id_             ,
                                                        contract_                     => contract_                     ,
                                                        part_no_                      => part_no_                      ,
                                                        location_type_db_             => location_type_db_             ,
                                                        qty_to_reserve_               => (quantity_to_reserve_ - quantity_reserved_),
                                                        project_id_                   => local_project_id_             ,
                                                        condition_code_               => condition_code_               ,
                                                        part_ownership_db_            => part_ownership_db_            ,
                                                        owning_vendor_no_             => owning_vendor_no_             ,
                                                        owning_customer_no_           => owning_customer_no_           ,
                                                        only_one_lot_allowed_         => only_one_lot_allowed_         ,
                                                        many_records_allowed_         => many_records_allowed_         ,
                                                        expiration_control_date_      => expiration_control_date_      ,
                                                        warehouse_id_                 => warehouse_id_                 ,
                                                        ignore_this_avail_control_id_ => ignore_this_avail_control_id_ ,
                                                        include_temp_table_locs_      => include_temp_table_locs_      );
      IF (keys_and_qty_tab_.COUNT > 0) THEN
         FOR i IN keys_and_qty_tab_.FIRST..keys_and_qty_tab_.LAST LOOP
            quantity_reserved_ := quantity_reserved_ + keys_and_qty_tab_(i).quantity;

            Modify_Qty_Reserved___(contract_             => keys_and_qty_tab_(i).contract, 
                                   part_no_              => keys_and_qty_tab_(i).part_no,
                                   configuration_id_     => keys_and_qty_tab_(i).configuration_id,
                                   location_no_          => keys_and_qty_tab_(i).location_no,
                                   lot_batch_no_         => keys_and_qty_tab_(i).lot_batch_no,
                                   serial_no_            => keys_and_qty_tab_(i).serial_no,
                                   eng_chg_level_        => keys_and_qty_tab_(i).eng_chg_level,
                                   waiv_dev_rej_no_      => keys_and_qty_tab_(i).waiv_dev_rej_no,
                                   activity_seq_         => keys_and_qty_tab_(i).activity_seq,
                                   handling_unit_id_     => keys_and_qty_tab_(i).handling_unit_id,
                                   source_ref1_          => source_ref1_,
                                   source_ref2_          => source_ref2_,
                                   source_ref3_          => source_ref3_,
                                   source_ref4_          => source_ref4_,
                                   source_ref_type_db_   => source_ref_type_db_,  
                                   pick_list_no_         => pick_list_no_,
                                   shipment_id_          => shipment_id_,
                                   qty_reserved_         => keys_and_qty_tab_(i).quantity,
                                   string_parameter1_    => string_parameter1_,
                                   string_parameter2_    => string_parameter2_);

            IF (keys_and_qty_tab_(i).to_location_no IS NOT NULL) THEN
               Inv_Part_Stock_Reservation_API.Move_New_With_Transport_Task(stock_keys_and_qty_rec_      => keys_and_qty_tab_(i),
                                                                           order_supply_demand_type_db_ => Get_Order_Suppl_Demand_Type_Db(source_ref_type_db_),
                                                                           order_no_                    => source_ref1_,
                                                                           line_no_                     => Get_Converted_Source_Ref(source_ref2_,2),
                                                                           release_no_                  => Get_Converted_Source_Ref(source_ref3_,3),
                                                                           line_item_no_                => Get_Converted_Source_Ref(source_ref4_,4),
                                                                           pick_list_no_                => pick_list_no_,
                                                                           shipment_id_                 => shipment_id_);
            END IF;
         END LOOP;
      END IF;
      EXIT WHEN (quantity_reserved_ = quantity_to_reserve_);
      EXIT WHEN (NVL(local_activity_seq_, 0) = 0);
      $IF Component_Proj_SYS.INSTALLED $THEN         
         local_project_id_ := NVL(local_project_id_, Activity_API.Get_Project_Id(local_activity_seq_));
         IF (Project_API.Get_Material_Allocation_Db(local_project_id_) = 'WITHIN_PROJECT') THEN
            local_activity_seq_ := NULL;
         ELSE
            EXIT;
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('PROJ');
      $END
   END LOOP;
END Find_And_Reserve_Part;


-- Reserve_Part
-- This method is used to do manual reservation. 
PROCEDURE Reserve_Part (   
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,
   configuration_id_             IN  VARCHAR2,
   location_no_                  IN  VARCHAR2,
   lot_batch_no_                 IN  VARCHAR2,
   serial_no_                    IN  VARCHAR2,
   eng_chg_level_                IN  VARCHAR2,
   waiv_dev_rej_no_              IN  VARCHAR2,
   activity_seq_                 IN  NUMBER,
   handling_unit_id_             IN  NUMBER,
   quantity_                     IN  NUMBER,  
   source_ref_type_db_           IN  VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2 DEFAULT '*',
   source_ref3_                  IN  VARCHAR2 DEFAULT '*',
   source_ref4_                  IN  VARCHAR2 DEFAULT '*',
   shipment_id_                  IN  NUMBER   DEFAULT 0,        
   ignore_this_avail_control_id_ IN  VARCHAR2 DEFAULT NULL,
   string_parameter1_            IN  VARCHAR2 DEFAULT NULL,
   string_parameter2_            IN  VARCHAR2 DEFAULT NULL,
   pick_by_choice_blocked_db_    IN  VARCHAR2 DEFAULT NULL)
IS   
BEGIN
   Reserve_Part___(contract_                       => contract_, 
                   part_no_                        => part_no_, 
                   configuration_id_               => configuration_id_,
                   location_no_                    => location_no_,
                   lot_batch_no_                   => lot_batch_no_,
                   serial_no_                      => serial_no_,
                   eng_chg_level_                  => eng_chg_level_,
                   waiv_dev_rej_no_                => waiv_dev_rej_no_,
                   activity_seq_                   => activity_seq_,
                   handling_unit_id_               => handling_unit_id_,
                   quantity_                       => quantity_,
                   source_ref_type_db_             => source_ref_type_db_,
                   source_ref1_                    => source_ref1_,
                   source_ref2_                    => source_ref2_,
                   source_ref3_                    => source_ref3_,
                   source_ref4_                    => source_ref4_,
                   pick_list_no_                   => 0,
                   shipment_id_                    => shipment_id_,
                   ignore_this_avail_control_id_   => ignore_this_avail_control_id_,
                   string_parameter1_              => string_parameter1_,
                   string_parameter2_              => string_parameter2_);
                                  
   IF (pick_by_choice_blocked_db_ IS NOT NULL ) THEN 
      Modify_Pick_By_Choice_Block___(contract_                  => contract_, 
                                     part_no_                   => part_no_, 
                                     configuration_id_          => configuration_id_,
                                     location_no_               => location_no_,
                                     lot_batch_no_              => lot_batch_no_,
                                     serial_no_                 => serial_no_,
                                     eng_chg_level_             => eng_chg_level_,
                                     waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                     activity_seq_              => activity_seq_,
                                     handling_unit_id_          => handling_unit_id_,                                 
                                     source_ref1_               => source_ref1_,
                                     source_ref2_               => source_ref2_,
                                     source_ref3_               => source_ref3_,
                                     source_ref4_               => source_ref4_,
                                     source_ref_type_db_        => source_ref_type_db_,
                                     pick_list_no_              => 0,
                                     shipment_id_               => shipment_id_,
                                     pick_by_choice_blocked_db_ => pick_by_choice_blocked_db_);
   END IF;                   
END Reserve_Part;


PROCEDURE Reserve_And_Report_As_Picked (   
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2,
   location_no_          IN VARCHAR2,
   lot_batch_no_         IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   eng_chg_level_        IN VARCHAR2,
   waiv_dev_rej_no_      IN VARCHAR2,
   activity_seq_         IN NUMBER,
   handling_unit_id_     IN NUMBER,
   pick_list_no_         IN NUMBER,
   qty_picked_           IN NUMBER,  
   catch_qty_picked_     IN NUMBER,
   source_ref_type_db_   IN VARCHAR2,
   source_ref1_          IN VARCHAR2,
   source_ref2_          IN VARCHAR2 DEFAULT '*',
   source_ref3_          IN VARCHAR2 DEFAULT '*',
   source_ref4_          IN VARCHAR2 DEFAULT '*',
   shipment_id_          IN NUMBER   DEFAULT 0,
   string_parameter1_    IN VARCHAR2 DEFAULT NULL,
   string_parameter2_    IN VARCHAR2 DEFAULT NULL,
   reserve_in_inventory_ IN BOOLEAN  DEFAULT TRUE,
   number_parameter1_    IN NUMBER   DEFAULT NULL )
IS 
   catch_qty_picked_out_   NUMBER;
BEGIN
   IF (reserve_in_inventory_) THEN
      Inventory_Part_In_Stock_API.Reserve_Part(catch_qty_picked_out_, 
                                               contract_, 
                                               part_no_, 
                                               configuration_id_,
                                               location_no_,
                                               lot_batch_no_,
                                               serial_no_,
                                               eng_chg_level_,
                                               waiv_dev_rej_no_,
                                               activity_seq_,
                                               handling_unit_id_,                                           
                                               qty_picked_); 
   END IF; 
   
   IF (qty_picked_ > 0) THEN
      Modify_Qty_Reserved___(contract_             => contract_, 
                             part_no_              => part_no_, 
                             configuration_id_     => configuration_id_,
                             location_no_          => location_no_,
                             lot_batch_no_         => lot_batch_no_,
                             serial_no_            => serial_no_,
                             eng_chg_level_        => eng_chg_level_,
                             waiv_dev_rej_no_      => waiv_dev_rej_no_,
                             activity_seq_         => activity_seq_,
                             handling_unit_id_     => handling_unit_id_,                                 
                             source_ref1_          => source_ref1_,
                             source_ref2_          => source_ref2_,
                             source_ref3_          => source_ref3_,
                             source_ref4_          => source_ref4_,
                             source_ref_type_db_   => source_ref_type_db_,
                             pick_list_no_         => pick_list_no_,
                             shipment_id_          => shipment_id_,
                             qty_reserved_         => qty_picked_,
                             string_parameter1_    => string_parameter1_,
                             string_parameter2_    => string_parameter2_,
                             number_parameter1_    => number_parameter1_);
                          
      Modify_Qty_Picked___(contract_            ,
                           part_no_             ,
                           configuration_id_    ,
                           location_no_         ,
                           lot_batch_no_        ,
                           serial_no_           ,
                           eng_chg_level_       ,
                           waiv_dev_rej_no_     ,
                           activity_seq_        ,
                           handling_unit_id_    ,   
                           source_ref1_         ,
                           source_ref2_         ,
                           source_ref3_         ,
                           source_ref4_         ,
                           source_ref_type_db_  ,
                           pick_list_no_        ,
                           shipment_id_         ,
                           qty_picked_          ,  
                           catch_qty_picked_    ,
                           string_parameter1_   ,
                           string_parameter2_   );  
   ELSE  
      
      Modify_Qty_Picked___(contract_            ,
                           part_no_             ,
                           configuration_id_    ,
                           location_no_         ,
                           lot_batch_no_        ,
                           serial_no_           ,
                           eng_chg_level_       ,
                           waiv_dev_rej_no_     ,
                           activity_seq_        ,
                           handling_unit_id_    ,   
                           source_ref1_         ,
                           source_ref2_         ,
                           source_ref3_         ,
                           source_ref4_         ,
                           source_ref_type_db_  ,
                           pick_list_no_        ,
                           shipment_id_         ,
                           qty_picked_          ,  
                           catch_qty_picked_    ,
                           string_parameter1_   ,
                           string_parameter2_   ); 
                              
      Modify_Qty_Reserved___(contract_             => contract_, 
                             part_no_              => part_no_, 
                             configuration_id_     => configuration_id_,
                             location_no_          => location_no_,
                             lot_batch_no_         => lot_batch_no_,
                             serial_no_            => serial_no_,
                             eng_chg_level_        => eng_chg_level_,
                             waiv_dev_rej_no_      => waiv_dev_rej_no_,
                             activity_seq_         => activity_seq_,
                             handling_unit_id_     => handling_unit_id_,
                             source_ref1_          => source_ref1_,
                             source_ref2_          => source_ref2_,
                             source_ref3_          => source_ref3_,
                             source_ref4_          => source_ref4_,
                             source_ref_type_db_   => source_ref_type_db_,
                             pick_list_no_         => pick_list_no_,
                             shipment_id_          => shipment_id_,
                             qty_reserved_         => qty_picked_,
                             string_parameter1_    => string_parameter1_,
                             string_parameter2_    => string_parameter2_,
                             number_parameter1_    => number_parameter1_ );
   END IF;                        
END Reserve_And_Report_As_Picked;


-- Scrap_Part
-- This method will handle scrap part functionality.
PROCEDURE Scrap_Part (    
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   location_no_                  IN     VARCHAR2,
   lot_batch_no_                 IN     VARCHAR2,
   serial_no_                    IN     VARCHAR2,
   eng_chg_level_                IN     VARCHAR2,
   waiv_dev_rej_no_              IN     VARCHAR2,
   activity_seq_                 IN     NUMBER,
   handling_unit_id_             IN     NUMBER,
   quantity_                     IN     NUMBER,
   catch_quantity_               IN     NUMBER,
   scrap_cause_                  IN     VARCHAR2,
   scrap_note_                   IN     VARCHAR2,
   source_ref_type_db_           IN     VARCHAR2,
   source_ref1_                  IN     VARCHAR2,
   source_ref2_                  IN     VARCHAR2 DEFAULT '*',
   source_ref3_                  IN     VARCHAR2 DEFAULT '*',
   source_ref4_                  IN     VARCHAR2 DEFAULT '*',
   pick_list_no_                 IN     NUMBER   DEFAULT 0,
   shipment_id_                  IN     NUMBER   DEFAULT 0,    
   part_tracking_session_id_     IN     NUMBER   DEFAULT NULL,
   discon_zero_stock_handl_unit_ IN     BOOLEAN  DEFAULT TRUE,
   print_serviceability_tag_db_  IN     VARCHAR2 DEFAULT Gen_Yes_No_API.DB_NO,
   string_parameter1_            IN     VARCHAR2 DEFAULT NULL,
   string_parameter2_            IN     VARCHAR2 DEFAULT NULL)
IS
   catch_qty_picked_   NUMBER := NULL;
   oldrec_             inventory_part_reservation_tab%ROWTYPE;
   order_type_         VARCHAR2(30);
BEGIN
   Exist_Db(contract_, 
            part_no_, 
            configuration_id_, 
            location_no_, 
            lot_batch_no_, 
            serial_no_, 
            eng_chg_level_, 
            waiv_dev_rej_no_, 
            activity_seq_, 
            handling_unit_id_, 
            source_ref1_, 
            source_ref2_, 
            source_ref3_, 
            source_ref4_, 
            source_ref_type_db_, 
            pick_list_no_, 
            shipment_id_);  
   oldrec_ := Lock_By_Keys___(contract_, 
                             part_no_, 
                             configuration_id_, 
                             location_no_, 
                             lot_batch_no_, 
                             serial_no_, 
                             eng_chg_level_, 
                             waiv_dev_rej_no_, 
                             activity_seq_, 
                             handling_unit_id_, 
                             source_ref1_, 
                             source_ref2_, 
                             source_ref3_, 
                             source_ref4_, 
                             source_ref_type_db_, 
                             pick_list_no_, 
                             shipment_id_);
   --Raise an error message when quantity to scrap is greater than the quantity reserved.
   IF (quantity_ > oldrec_.qty_reserved) THEN
      Error_SYS.Record_General(lu_name_, 'QTYSCRAPGTQTYRESERVE: Quantity to scrap is greater than the reserved quantity');
   END IF;
   
   
   Inventory_Part_In_Stock_API.Reserve_Part(catch_qty_picked_, 
                                            contract_, 
                                            part_no_, 
                                            configuration_id_,
                                            location_no_,
                                            lot_batch_no_,
                                            serial_no_,
                                            eng_chg_level_,
                                            waiv_dev_rej_no_,
                                            activity_seq_,
                                            handling_unit_id_,                                           
                                            -(quantity_));   
                                                   
   catch_qty_picked_  := catch_quantity_;
   order_type_        := Get_Order_Type_Db___(source_ref_type_db_);
   -- Scrap part
   Inventory_Part_In_Stock_API.Scrap_Part(catch_quantity_               => catch_qty_picked_, 
                                          contract_                     => contract_,
                                          part_no_                      => part_no_,
                                          configuration_id_             => configuration_id_, 
                                          location_no_                  => location_no_,
                                          lot_batch_no_                 => lot_batch_no_, 
                                          serial_no_                    => serial_no_,
                                          eng_chg_level_                => eng_chg_level_, 
                                          waiv_dev_rej_no_              => waiv_dev_rej_no_, 
                                          activity_seq_                 => activity_seq_, 
                                          handling_unit_id_             => handling_unit_id_,
                                          quantity_                     => quantity_, 
                                          scrap_cause_                  => scrap_cause_, 
                                          scrap_note_                   => scrap_note_,
                                          order_no_                     => source_ref1_,
                                          release_no_                   => Get_Converted_Source_Ref(source_ref2_,2),
                                          sequence_no_                  => Get_Converted_Source_Ref(source_ref3_,3),
                                          line_item_no_                 => Get_Converted_Source_Ref(source_ref4_,4),
                                          order_type_                   => Order_Type_API.Decode(order_type_),
                                          part_tracking_session_id_     => part_tracking_session_id_,
                                          discon_zero_stock_handl_unit_ => discon_zero_stock_handl_unit_,
                                          print_serviceability_tag_db_  => print_serviceability_tag_db_);
                                          
   -- First need to reduce qty picked, otherwise validation error will be raised stating qty_picked > qty_reserved
   Modify_Qty_Picked___(contract_             => contract_, 
                        part_no_              => part_no_, 
                        configuration_id_     => configuration_id_,
                        location_no_          => location_no_,
                        lot_batch_no_         => lot_batch_no_,
                        serial_no_            => serial_no_,
                        eng_chg_level_        => eng_chg_level_,
                        waiv_dev_rej_no_      => waiv_dev_rej_no_,
                        activity_seq_         => activity_seq_,
                        handling_unit_id_     => handling_unit_id_,
                        source_ref1_          => source_ref1_,
                        source_ref2_          => source_ref2_,
                        source_ref3_          => source_ref3_,
                        source_ref4_          => source_ref4_,
                        source_ref_type_db_   => source_ref_type_db_,
                        pick_list_no_         => pick_list_no_,
                        shipment_id_          => shipment_id_,
                        qty_picked_           => -(quantity_),  
                        catch_qty_picked_     => -(catch_quantity_),
                        string_parameter1_    => string_parameter1_,
                        string_parameter2_    => string_parameter2_);
                              
   Modify_Qty_Reserved___(contract_             => contract_, 
                          part_no_              => part_no_, 
                          configuration_id_     => configuration_id_,
                          location_no_          => location_no_,
                          lot_batch_no_         => lot_batch_no_,
                          serial_no_            => serial_no_,
                          eng_chg_level_        => eng_chg_level_,
                          waiv_dev_rej_no_      => waiv_dev_rej_no_,
                          activity_seq_         => activity_seq_,
                          handling_unit_id_     => handling_unit_id_,
                          source_ref1_          => source_ref1_,
                          source_ref2_          => source_ref2_,
                          source_ref3_          => source_ref3_,
                          source_ref4_          => source_ref4_,
                          source_ref_type_db_   => source_ref_type_db_,
                          pick_list_no_         => pick_list_no_,
                          shipment_id_          => shipment_id_,
                          qty_reserved_         => -(quantity_),
                          string_parameter1_    => string_parameter1_,
                          string_parameter2_    => string_parameter2_);        
END Scrap_Part;


-- Modify_Shipment_Id
-- This method is used to update shipment id with quantities in assignment, reassignment or unassignment
PROCEDURE Modify_Shipment_Id (
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,    
   new_shipment_id_     IN NUMBER,
   qty_reserved_        IN NUMBER,  
   qty_picked_          IN NUMBER,  
   catch_qty_picked_    IN NUMBER,
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2 DEFAULT '*',
   source_ref3_         IN VARCHAR2 DEFAULT '*',
   source_ref4_         IN VARCHAR2 DEFAULT '*',  
   pick_list_no_        IN NUMBER   DEFAULT 0,
   old_shipment_id_     IN NUMBER   DEFAULT 0,
   string_parameter1_   IN VARCHAR2 DEFAULT NULL,
   string_parameter2_   IN VARCHAR2 DEFAULT NULL)
IS
   newrec_     inventory_part_reservation_tab%ROWTYPE;
   oldrec_     inventory_part_reservation_tab%ROWTYPE;
   rec_        inventory_part_reservation_tab%ROWTYPE;
   reservation_booked_for_transp_      BOOLEAN:=FALSE;
BEGIN 
   -- Existing records having old shipment Id
   oldrec_ := Lock_By_Keys___(contract_, 
                              part_no_, 
                              configuration_id_, 
                              location_no_, 
                              lot_batch_no_, 
                              serial_no_, 
                              eng_chg_level_, 
                              waiv_dev_rej_no_, 
                              activity_seq_, 
                              handling_unit_id_, 
                              source_ref1_, 
                              source_ref2_, 
                              source_ref3_, 
                              source_ref4_, 
                              source_ref_type_db_, 
                              pick_list_no_, 
                              old_shipment_id_);
   
   IF (Check_Exist___(contract_, 
                      part_no_, 
                      configuration_id_, 
                      location_no_, 
                      lot_batch_no_, 
                      serial_no_, 
                      eng_chg_level_, 
                      waiv_dev_rej_no_, 
                      activity_seq_, 
                      handling_unit_id_, 
                      source_ref1_, 
                      source_ref2_, 
                      source_ref3_, 
                      source_ref4_, 
                      source_ref_type_db_, 
                      pick_list_no_, 
                      new_shipment_id_)) THEN
      -- Existing record found for new shipment, therefore update the reservation record with quantities  
      rec_ := Lock_By_Keys___(contract_, 
                                 part_no_, 
                                 configuration_id_, 
                                 location_no_, 
                                 lot_batch_no_, 
                                 serial_no_, 
                                 eng_chg_level_, 
                                 waiv_dev_rej_no_, 
                                 activity_seq_, 
                                 handling_unit_id_, 
                                 source_ref1_, 
                                 source_ref2_, 
                                 source_ref3_, 
                                 source_ref4_, 
                                 source_ref_type_db_, 
                                 pick_list_no_, 
                                 new_shipment_id_);
      newrec_ := rec_;       
      newrec_.qty_reserved       := newrec_.qty_reserved + qty_reserved_;
      newrec_.qty_picked         := newrec_.qty_picked +  qty_picked_;
      newrec_.catch_qty_picked   := NVL(newrec_.catch_qty_picked, 0) + catch_qty_picked_;
      Update_Record___(newrec_               => newrec_, 
                       oldrec_               => rec_,
                       string_parameter1_    => string_parameter1_, 
                       string_parameter2_    => string_parameter2_);        
   ELSE
      -- No existing record found for new shipment id, therefore create new reservation record
      newrec_.contract          := contract_;
      newrec_.part_no           := part_no_;
      newrec_.configuration_id  := configuration_id_;
      newrec_.location_no       := location_no_;
      newrec_.lot_batch_no      := lot_batch_no_;
      newrec_.serial_no         := serial_no_;
      newrec_.eng_chg_level     := eng_chg_level_;
      newrec_.waiv_dev_rej_no   := waiv_dev_rej_no_;
      newrec_.activity_seq      := activity_seq_;
      newrec_.handling_unit_id  := handling_unit_id_;
      newrec_.source_ref1       := source_ref1_;
      newrec_.source_ref2       := source_ref2_;
      newrec_.source_ref3       := source_ref3_;
      newrec_.source_ref4       := source_ref4_;
      newrec_.source_ref_type   := source_ref_type_db_;
      newrec_.pick_list_no      := pick_list_no_;
      newrec_.shipment_id       := new_shipment_id_;
      newrec_.qty_reserved      := qty_reserved_;
      newrec_.qty_picked        := qty_picked_;
      newrec_.fully_picked      := CASE newrec_.qty_picked WHEN 0 THEN Fnd_Boolean_API.DB_FALSE ELSE Fnd_Boolean_API.DB_TRUE END;
      newrec_.qty_issued        := 0;
      newrec_.catch_qty_picked  := catch_qty_picked_;
      newrec_.pick_by_choice_blocked :=  oldrec_.pick_by_choice_blocked;                                                                                
      Insert_Record___(newrec_              => newrec_,
                       string_parameter1_   => string_parameter1_,
                       string_parameter2_   => string_parameter2_);                         
   END IF;
   
   -- Manipulate Old shipment ID
   Exist_Db(contract_, 
            part_no_, 
            configuration_id_, 
            location_no_, 
            lot_batch_no_, 
            serial_no_, 
            eng_chg_level_, 
            waiv_dev_rej_no_, 
            activity_seq_, 
            handling_unit_id_, 
            source_ref1_, 
            source_ref2_, 
            source_ref3_, 
            source_ref4_, 
            source_ref_type_db_, 
            pick_list_no_, 
            old_shipment_id_);
   IF((oldrec_.qty_reserved - qty_reserved_) = 0) THEN           
      Transport_Task_API.New_Trans_Task_For_Changed_Res(reservation_booked_for_transp_ => reservation_booked_for_transp_,
                                                        part_no_            => oldrec_.part_no,
                                                        configuration_id_   => oldrec_.configuration_id,
                                                        from_contract_      => oldrec_.contract,
                                                        from_location_no_   => oldrec_.location_no,   
                                                        order_type_db_      => oldrec_.source_ref_type,
                                                        order_ref1_         => oldrec_.source_ref1,
                                                        order_ref2_         => Get_Converted_Source_Ref(oldrec_.source_ref2,2),
                                                        order_ref3_         => Get_Converted_Source_Ref(oldrec_.source_ref3,3),
                                                        order_ref4_         => Get_Converted_Source_Ref(oldrec_.source_ref4,4),
                                                        from_pick_list_no_  => Convert_Pick_List_No___(oldrec_.pick_list_no),
                                                        to_pick_list_no_    => Convert_Pick_List_No___(oldrec_.pick_list_no),
                                                        from_shipment_id_   => old_shipment_id_,
                                                        to_shipment_id_     => new_shipment_id_,   
                                                        lot_batch_no_       => oldrec_.lot_batch_no,
                                                        serial_no_          => oldrec_.serial_no,
                                                        eng_chg_level_      => oldrec_.eng_chg_level,
                                                        waiv_dev_rej_no_    => oldrec_.waiv_dev_rej_no,
                                                        activity_seq_       => oldrec_.activity_seq,
                                                        handling_unit_id_   => oldrec_.handling_unit_id,
                                                        quantity_           => oldrec_.qty_reserved); 
      
      -- Delete old shipment reservation, since all reserved qty will be transfered to new shipment 
      Delete_Record___(remrec_               => oldrec_,
                       string_parameter1_    => string_parameter1_, 
                       string_parameter2_    => string_parameter2_);                                                                        
   ELSE     
      -- Update old shipment quantities by reducing the quantities which will be transfered to new shipment.        
      newrec_ := oldrec_;       
      newrec_.qty_reserved       := newrec_.qty_reserved - qty_reserved_;
      newrec_.qty_picked         := newrec_.qty_picked - qty_picked_;
      newrec_.catch_qty_picked   := newrec_.catch_qty_picked - catch_qty_picked_;     
      Update_Record___(newrec_               => newrec_, 
                       oldrec_               => oldrec_,
                       string_parameter1_    => string_parameter1_, 
                       string_parameter2_    => string_parameter2_);      
      
   END IF;   
END Modify_Shipment_Id;


PROCEDURE Reassign_Shipment_Line (
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   location_no_                  IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   handling_unit_id_             IN NUMBER,    
   new_shipment_id_              IN NUMBER,
   release_reservations_         IN BOOLEAN,
   qty_reserved_                 IN NUMBER,  
   qty_picked_                   IN NUMBER,  
   catch_qty_picked_             IN NUMBER,
   source_ref_type_db_           IN VARCHAR2,
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2 DEFAULT '*',
   source_ref3_                  IN VARCHAR2 DEFAULT '*',
   source_ref4_                  IN VARCHAR2 DEFAULT '*',  
   pick_list_no_                 IN NUMBER   DEFAULT 0,
   old_shipment_id_              IN NUMBER   DEFAULT 0,
   ignore_this_avail_control_id_ IN VARCHAR2 DEFAULT NULL,
   string_parameter1_            IN VARCHAR2 DEFAULT NULL,
   string_parameter2_            IN VARCHAR2 DEFAULT NULL)
IS     
BEGIN  
   IF (release_reservations_) THEN
      IF ((ABS(qty_picked_)) > 0) THEN
         Reserve_And_Report_As_Picked (contract_           => contract_          ,
                                       part_no_            => part_no_           ,
                                       configuration_id_   => configuration_id_  ,
                                       location_no_        => location_no_       ,
                                       lot_batch_no_       => lot_batch_no_      ,
                                       serial_no_          => serial_no_         ,
                                       eng_chg_level_      => eng_chg_level_     ,
                                       waiv_dev_rej_no_    => waiv_dev_rej_no_    ,
                                       activity_seq_       => activity_seq_      ,
                                       handling_unit_id_   => handling_unit_id_  ,
                                       pick_list_no_       => pick_list_no_      ,
                                       qty_picked_         => qty_picked_        ,  
                                       catch_qty_picked_   => catch_qty_picked_  ,
                                       source_ref_type_db_ => source_ref_type_db_,
                                       source_ref1_        => source_ref1_       ,
                                       source_ref2_        => source_ref2_       ,
                                       source_ref3_        => source_ref3_       ,
                                       source_ref4_        => source_ref4_       ,
                                       shipment_id_        => old_shipment_id_   ,
                                       string_parameter1_  => string_parameter1_ ,
                                       string_parameter2_  => string_parameter2_ );
      ELSE
         Reserve_Part___ ( contract_                     => contract_,
                           part_no_                      => part_no_,
                           configuration_id_             => configuration_id_,
                           location_no_                  => location_no_,
                           lot_batch_no_                 => lot_batch_no_,
                           serial_no_                    => serial_no_,
                           eng_chg_level_                => eng_chg_level_,
                           waiv_dev_rej_no_              => waiv_dev_rej_no_,
                           activity_seq_                 => activity_seq_,
                           handling_unit_id_             => handling_unit_id_,
                           quantity_                     => qty_reserved_,  
                           source_ref_type_db_           => source_ref_type_db_,
                           source_ref1_                  => source_ref1_,
                           source_ref2_                  => source_ref2_,
                           source_ref3_                  => source_ref3_,
                           source_ref4_                  => source_ref4_,
                           pick_list_no_                 => pick_list_no_,
                           shipment_id_                  => old_shipment_id_,
                           ignore_this_avail_control_id_ => ignore_this_avail_control_id_,
                           string_parameter1_            => string_parameter1_,
                           string_parameter2_            => string_parameter2_ );
      END IF;   
   ELSE
      Modify_Shipment_Id(contract_            => contract_,
                         part_no_             => part_no_,
                         configuration_id_    => configuration_id_, 
                         location_no_         => location_no_,
                         lot_batch_no_        => lot_batch_no_, 
                         serial_no_           => serial_no_,
                         eng_chg_level_       => eng_chg_level_, 
                         waiv_dev_rej_no_     => waiv_dev_rej_no_, 
                         activity_seq_        => activity_seq_, 
                         handling_unit_id_    => handling_unit_id_,                                                        
                         new_shipment_id_     => new_shipment_id_,
                         qty_reserved_        => qty_reserved_,
                         qty_picked_          => qty_picked_,
                         catch_qty_picked_    => catch_qty_picked_,
                         source_ref_type_db_  => source_ref_type_db_,
                         source_ref1_         => source_ref1_, 
                         source_ref2_         => source_ref2_, 
                         source_ref3_         => source_ref3_,
                         source_ref4_         => source_ref4_,                                                       
                         pick_list_no_        => pick_list_no_,
                         old_shipment_id_     => old_shipment_id_,
                         string_parameter1_   => string_parameter1_,
                         string_parameter2_   => string_parameter2_);
   END IF;   
END Reassign_Shipment_Line;


PROCEDURE Set_Pick_List_No (
   pick_list_no_       IN NUMBER,
   shipment_id_        IN NUMBER   DEFAULT 0,
   source_ref1_        IN VARCHAR2 DEFAULT NULL,
   source_ref2_        IN VARCHAR2 DEFAULT NULL,
   source_ref3_        IN VARCHAR2 DEFAULT NULL,
   source_ref4_        IN VARCHAR2 DEFAULT NULL,
   source_ref_type_db_ IN VARCHAR2 DEFAULT NULL,
   location_group_     IN VARCHAR2 DEFAULT NULL )
IS
   oldrec_              inventory_part_reservation_tab%ROWTYPE;
   newrec_              inventory_part_reservation_tab%ROWTYPE;
   
   CURSOR get_inv_part_res_rec IS
      SELECT *
       FROM  inventory_part_reservation_tab
      WHERE  shipment_id  = shipment_id_
        AND  pick_list_no    = 0
        AND  (source_ref1     = source_ref1_        OR source_ref1_        IS NULL)
        AND  (source_ref2     = source_ref2_        OR source_ref2_        IS NULL)
        AND  (source_ref3     = source_ref3_        OR source_ref3_        IS NULL)
        AND  (source_ref4     = source_ref4_        OR source_ref4_        IS NULL)
        AND  (source_ref_type = source_ref_type_db_ OR source_ref_type_db_ IS NULL)
        AND  ((Inventory_Location_API.Get_Location_Group(contract, location_no)= location_group_) OR (location_group_ IS NULL))
        FOR  UPDATE; 
        
   TYPE Inv_Part_Res_Tab IS TABLE OF inventory_part_reservation_tab%ROWTYPE INDEX BY PLS_INTEGER;
   inv_part_res_tab_   Inv_Part_Res_Tab;     
BEGIN   
   OPEN get_inv_part_res_rec;
   FETCH get_inv_part_res_rec BULK COLLECT INTO inv_part_res_tab_;
   CLOSE get_inv_part_res_rec;
   
   IF (inv_part_res_tab_.COUNT > 0) THEN 
      Inventory_Event_Manager_API.Start_Session;
      FOR i_ IN inv_part_res_tab_.FIRST .. inv_part_res_tab_.LAST LOOP
         oldrec_              := inv_part_res_tab_(i_);
         newrec_              := oldrec_; 
         newrec_.pick_list_no := pick_list_no_;
         Insert_Record___(newrec_                => newrec_,
                          on_pick_list_creation_ => TRUE ); 
         Remove___(oldrec_);   
         
         IF ((oldrec_.pick_list_no = 0 AND pick_list_no_  != 0) AND oldrec_.qty_picked = 0) THEN
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
                                                      quantity_          => oldrec_.qty_reserved,
                                                      catch_quantity_    => NULL,
                                                      order_ref1_        => oldrec_.source_ref1,
                                                      order_ref2_        => Get_Converted_Source_Ref(oldrec_.source_ref2,2),
                                                      order_ref3_        => Get_Converted_Source_Ref(oldrec_.source_ref3,3),
                                                      order_ref4_        => Get_Converted_Source_Ref(oldrec_.source_ref4,4),
                                                      pick_list_no_      => Convert_Pick_List_No___(oldrec_.pick_list_no),
                                                      shipment_id_       => oldrec_.shipment_id,
                                                      order_type_db_     => oldrec_.source_ref_type,                                                         
                                                      new_pick_list_no_  => pick_list_no_ );                                                  

         END IF;         
         
         IF (shipment_id_ != 0) THEN 
            $IF (Component_Shpmnt_SYS.INSTALLED) $THEN 
               Pick_Shipment_API.Modify_Reserv_Hu_Pick_List_No(source_ref1_                 => newrec_.source_ref1,
                                                               source_ref2_                 => newrec_.source_ref2,
                                                               source_ref3_                 => newrec_.source_ref3,
                                                               source_ref4_                 => newrec_.source_ref4,          
                                                               source_ref_type_db_          => NULL,
                                                               contract_                    => newrec_.contract,
                                                               part_no_                     => newrec_.part_no,
                                                               location_no_                 => newrec_.location_no,
                                                               lot_batch_no_                => newrec_.lot_batch_no,
                                                               serial_no_                   => newrec_.serial_no,
                                                               eng_chg_level_               => newrec_.eng_chg_level,
                                                               waiv_dev_rej_no_             => newrec_.waiv_dev_rej_no,
                                                               activity_seq_                => newrec_.activity_seq,
                                                               reserv_handling_unit_id_     => newrec_.handling_unit_id,
                                                               configuration_id_            => newrec_.configuration_id,
                                                               pick_list_no_                => Convert_Pick_List_No___(oldrec_.pick_list_no),
                                                               shipment_id_                 => shipment_id_,
                                                               new_pick_list_no_            => pick_list_no_,
                                                               inv_part_res_source_type_db_ => newrec_.source_ref_type );
                                                      
            $ELSE
               Error_SYS.Component_Not_Exist('SHPMNT');
            $END                                                   
         END IF;
 
      END LOOP;   
      Inventory_Event_Manager_API.Finish_Session;
   END IF; 
   
END Set_Pick_List_No;


PROCEDURE Identify_Serials (
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   location_no_              IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   eng_chg_level_            IN VARCHAR2,
   waiv_dev_rej_no_          IN VARCHAR2,
   activity_seq_             IN NUMBER,
   handling_unit_id_         IN NUMBER,
   part_tracking_session_id_ IN NUMBER,
   source_ref_type_db_       IN VARCHAR2,
   source_ref1_              IN VARCHAR2,
   source_ref2_              IN VARCHAR2 DEFAULT '*',
   source_ref3_              IN VARCHAR2 DEFAULT '*',
   source_ref4_              IN VARCHAR2 DEFAULT '*',  
   pick_list_no_             IN NUMBER   DEFAULT 0,
   shipment_id_              IN NUMBER   DEFAULT 0,   
   on_pick_reporting_        IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE,
   string_parameter1_        IN VARCHAR2 DEFAULT NULL,
   string_parameter2_        IN VARCHAR2 DEFAULT NULL )
IS
   oldrec_                   inventory_part_reservation_tab%ROWTYPE; 
   newrec_                   inventory_part_reservation_tab%ROWTYPE;
   serial_catch_tab_         Inventory_Part_In_Stock_API.Serial_Catch_Table;
BEGIN
   Temporary_Part_Tracking_API.Get_Serials_And_Remove_Session(serial_catch_tab_, part_tracking_session_id_);
   
   IF (serial_catch_tab_.COUNT = 0) THEN
      Error_SYS.Record_General(lu_name_, 'SERIALNOTIDE: No serials have been identified.');
   END IF;
   
   Inventory_Event_Manager_API.Start_Session;
   Inventory_Part_In_Stock_API.Split_Into_Serials(contract_             => contract_,
                                                  part_no_              => part_no_,
                                                  configuration_id_     => configuration_id_,
                                                  location_no_          => location_no_,
                                                  lot_batch_no_         => lot_batch_no_,
                                                  eng_chg_level_        => eng_chg_level_,
                                                  waiv_dev_rej_no_      => waiv_dev_rej_no_,
                                                  activity_seq_         => activity_seq_,
                                                  handling_unit_id_     => handling_unit_id_,
                                                  serial_catch_tab_     => serial_catch_tab_,
                                                  reservation_          => TRUE);
                                                  
   oldrec_ := Lock_By_Keys___(contract_, 
                              part_no_, 
                              configuration_id_, 
                              location_no_, 
                              lot_batch_no_, 
                              '*', 
                              eng_chg_level_, 
                              waiv_dev_rej_no_, 
                              activity_seq_, 
                              handling_unit_id_, 
                              source_ref1_, 
                              source_ref2_, 
                              source_ref3_, 
                              source_ref4_, 
                              source_ref_type_db_, 
                              pick_list_no_, 
                              shipment_id_ );       
                              
   FOR i_ IN serial_catch_tab_.FIRST .. serial_catch_tab_.LAST LOOP
      -- create new records with identified serials
      IF (on_pick_reporting_ = Fnd_Boolean_API.DB_TRUE) THEN
         Modify_Qty_Picked___(contract_           => contract_                      ,
                              part_no_            => part_no_                       ,
                              configuration_id_   => configuration_id_              ,
                              location_no_        => location_no_                   ,
                              lot_batch_no_       => lot_batch_no_                  ,
                              serial_no_          => serial_catch_tab_(i_).serial_no,
                              eng_chg_level_      => eng_chg_level_                 ,
                              waiv_dev_rej_no_    => waiv_dev_rej_no_               ,
                              activity_seq_       => activity_seq_                  ,
                              handling_unit_id_   => handling_unit_id_              ,   
                              source_ref1_        => source_ref1_                   ,
                              source_ref2_        => source_ref2_                   ,
                              source_ref3_        => source_ref3_                   ,
                              source_ref4_        => source_ref4_                   ,
                              source_ref_type_db_ => source_ref_type_db_            ,
                              pick_list_no_       => pick_list_no_                  ,
                              shipment_id_        => shipment_id_                   ,
                              qty_picked_         => 1                              ,  
                              catch_qty_picked_   => serial_catch_tab_(i_).catch_qty,
                              string_parameter1_  => string_parameter1_             ,
                              string_parameter2_  => string_parameter2_ );  
      ELSE
         newrec_              := oldrec_;
         newrec_.serial_no    := serial_catch_tab_(i_).serial_no;
         newrec_.qty_reserved := 1;
         
         Insert_Record___(newrec_             => newrec_);
      END IF;     
   END LOOP;   
   
   IF (oldrec_.qty_reserved > serial_catch_tab_.count) THEN
      -- adjust the quantity of record where serial no is *
      newrec_              := oldrec_;
      newrec_.qty_reserved := (oldrec_.qty_reserved - serial_catch_tab_.count);
      Update_Record___(newrec_             => newrec_,
                       oldrec_             => oldrec_);    
   ELSE
      Delete_Record___(remrec_             => oldrec_);
   END IF;
   Inventory_Event_Manager_API.Finish_Session;
END Identify_Serials;


@UncheckedAccess
FUNCTION Get_Total_Qty_Reserved (
   source_ref_type_db_    IN     VARCHAR2,
   source_ref1_           IN     VARCHAR2,
   source_ref2_           IN     VARCHAR2 DEFAULT '*',
   source_ref3_           IN     VARCHAR2 DEFAULT '*',
   source_ref4_           IN     VARCHAR2 DEFAULT '*',   
   shipment_id_           IN     NUMBER   DEFAULT 0) RETURN NUMBER
IS
   total_qty_reserved_ NUMBER := 0;
   
   CURSOR get_total_qty_reserved IS
      SELECT NVL(SUM(qty_reserved), 0)
      FROM   inventory_part_reservation_tab 
      WHERE  source_ref1      = source_ref1_
      AND    source_ref2      = source_ref2_
      AND    source_ref3      = source_ref3_
      AND    source_ref4      = source_ref4_
      AND    source_ref_type  = source_ref_type_db_
      AND    (shipment_id     = shipment_id_ OR shipment_id_ IS NULL);
BEGIN
   OPEN  get_total_qty_reserved;
   FETCH get_total_qty_reserved INTO total_qty_reserved_;
   CLOSE get_total_qty_reserved;   
   
   RETURN total_qty_reserved_;   
END Get_Total_Qty_Reserved;  


@UncheckedAccess
FUNCTION Get_Total_Qty_Reserved (   
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2 DEFAULT '*',
   source_ref3_         IN VARCHAR2 DEFAULT '*',
   source_ref4_         IN VARCHAR2 DEFAULT '*',   
   shipment_id_         IN NUMBER   DEFAULT 0) RETURN NUMBER
IS
   total_qty_reserved_ NUMBER := 0;
   
   CURSOR get_total_qty_reserved IS
      SELECT NVL(SUM(qty_reserved), 0)
      FROM   inventory_part_reservation_tab 
      WHERE  source_ref1      = source_ref1_
      AND    source_ref2      = source_ref2_
      AND    source_ref3      = source_ref3_
      AND    source_ref4      = source_ref4_
      AND    source_ref_type  = source_ref_type_db_
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
FUNCTION Get_Qty_Reserved_In_Hu(
   handling_unit_id_      IN     NUMBER,
   source_ref_type_db_    IN     VARCHAR2,
   source_ref1_           IN     VARCHAR2,
   source_ref2_           IN     VARCHAR2 DEFAULT '*',
   source_ref3_           IN     VARCHAR2 DEFAULT '*',
   source_ref4_           IN     VARCHAR2 DEFAULT '*',  
   pick_list_no_          IN     NUMBER   DEFAULT 0,
   shipment_id_           IN     NUMBER   DEFAULT 0) RETURN NUMBER
IS
   qty_reserved_ NUMBER := 0;
   
   CURSOR get_qty_reserved IS
      SELECT SUM(qty_reserved)
      FROM   inventory_part_reservation_tab
      WHERE  source_ref1      = source_ref1_
      AND    source_ref2      = source_ref2_
      AND    source_ref3      = source_ref3_
      AND    source_ref4      = source_ref4_
      AND    source_ref_type  = source_ref_type_db_
      AND    handling_unit_id IN (SELECT handling_unit_id
                                  FROM handling_unit_tab
                                  CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id
                                  START WITH       handling_unit_id = handling_unit_id_)
      AND   (pick_list_no = pick_list_no_ OR pick_list_no_ IS NULL)
      AND    shipment_id      = shipment_id_;
BEGIN
   OPEN get_qty_reserved;
   FETCH get_qty_reserved INTO qty_reserved_;
   CLOSE get_qty_reserved;
   
   RETURN qty_reserved_;
END Get_Qty_Reserved_In_Hu;


@UncheckedAccess
FUNCTION Get_Unpicked_Pick_Listed_Qty (
   source_ref_type_db_  IN VARCHAR2,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2 DEFAULT '*',
   source_ref3_         IN VARCHAR2 DEFAULT '*',
   source_ref4_         IN VARCHAR2 DEFAULT '*',   
   shipment_id_         IN NUMBER   DEFAULT 0) RETURN NUMBER
IS    
   pick_listed_qty_        NUMBER := 0;
   CURSOR get_pick_listed_qty IS
     SELECT NVL(SUM(qty_reserved - qty_picked), 0)
     FROM   inventory_part_reservation_tab 
     WHERE  shipment_id = shipment_id_
     AND    source_ref1 = source_ref1_ 
     AND    source_ref2 = source_ref2_
     AND    source_ref3 = source_ref3_
     AND    source_ref4 = source_ref4_
     AND    source_ref_type = source_ref_type_db_
     AND    pick_list_no != 0; 
BEGIN    
   OPEN  get_pick_listed_qty;
   FETCH get_pick_listed_qty INTO pick_listed_qty_;
   CLOSE get_pick_listed_qty;   
   RETURN pick_listed_qty_;
END Get_Unpicked_Pick_Listed_Qty;


@UncheckedAccess
FUNCTION Get_Order_Suppl_Demand_Type_Db (
   inv_part_res_source_type_db_ IN  VARCHAR2) RETURN VARCHAR2
IS
   order_supply_demand_type_db_ VARCHAR2(20);
BEGIN
   order_supply_demand_type_db_ := CASE inv_part_res_source_type_db_
                                      WHEN Inv_Part_Res_Source_Type_API.DB_PROJECT_DELIVERABLES THEN 
                                           Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES
                                      WHEN Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER THEN
                                           Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER    
                                      WHEN Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN THEN
                                           Order_Supply_Demand_Type_API.DB_PURCH_RECEIPT_RETURN 
                                   END;
   RETURN (order_supply_demand_type_db_);
END Get_Order_Suppl_Demand_Type_Db;                                
                               

@UncheckedAccess
FUNCTION Get_Demand_Res_Source_Type_Db (
   order_supply_demand_type_db_ IN  VARCHAR2) RETURN VARCHAR2
IS
   inv_part_res_source_type_db_ VARCHAR2(20);
BEGIN
   inv_part_res_source_type_db_ := CASE order_supply_demand_type_db_
                                       WHEN Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES THEN 
                                            Inv_Part_Res_Source_Type_API.DB_PROJECT_DELIVERABLES
                                       WHEN Inv_Part_Res_Source_Type_API.DB_SHIPMENT_ORDER THEN
                                            Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER
                                       WHEN Order_Supply_Demand_Type_API.DB_PURCH_RECEIPT_RETURN THEN
                                            Inv_Part_Res_Source_Type_API.DB_PURCH_RECEIPT_RETURN 
                                    END;
   RETURN (inv_part_res_source_type_db_);
END Get_Demand_Res_Source_Type_Db;   


@UncheckedAccess
FUNCTION Shipment_Pick_List_Line_Exists (    
   shipment_id_      IN NUMBER,
   pick_list_no_     IN NUMBER,
   fully_picked_db_  IN VARCHAR2 DEFAULT NULL) RETURN BOOLEAN   
IS
   exists_  BOOLEAN := FALSE;
   temp_    NUMBER;

   CURSOR exist_control IS
      SELECT 1 
      FROM   inventory_part_reservation_tab
      WHERE  shipment_id   = shipment_id_ 
      AND    pick_list_no  = pick_list_no_      
      AND    (fully_picked = fully_picked_db_ OR fully_picked_db_ IS NULL);
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF(exist_control%FOUND) THEN      
      exists_ := TRUE;
   END IF;
   CLOSE exist_control;
   RETURN (exists_);
END Shipment_Pick_List_Line_Exists;
   

PROCEDURE Issue_Shipment_Line(   
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,
   shipment_id_                  IN NUMBER,
   transaction_code_             IN VARCHAR2,
   dest_contract_                IN VARCHAR2,
   dest_warehouse_id_            IN VARCHAR2,
   ignore_this_avail_control_id_ IN VARCHAR2 DEFAULT NULL )
IS  
  CURSOR get_inv_part_reservations IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no, serial_no, eng_chg_level,  
             waiv_dev_rej_no, activity_seq, handling_unit_id, pick_list_no, qty_picked, catch_qty_picked 
      FROM   inventory_part_reservation_tab
      WHERE  source_ref1 = source_ref1_
      AND    source_ref2 = source_ref2_
      AND    source_ref3 = source_ref3_
      AND    source_ref4 = source_ref4_
      AND    source_ref_type = source_ref_type_db_      
      AND    shipment_id = shipment_id_ 
      AND    qty_picked > 0; 
      
   TYPE Inv_Part_Reservations_Tab IS TABLE OF get_inv_part_reservations%ROWTYPE INDEX BY PLS_INTEGER;
   inv_part_reservations_tab_     Inv_Part_Reservations_Tab;
   last_                          NUMBER := 0;
   string_parameter1_             VARCHAR2(50) := NULL;    
BEGIN 
   OPEN  get_inv_part_reservations;
   FETCH get_inv_part_reservations BULK COLLECT INTO inv_part_reservations_tab_;
   CLOSE get_inv_part_reservations; 
  
   IF (inv_part_reservations_tab_.COUNT > 0) THEN
      last_ := inv_part_reservations_tab_.LAST;  
      
      FOR i IN inv_part_reservations_tab_.FIRST..inv_part_reservations_tab_.LAST LOOP   
         IF (i = last_) THEN
            string_parameter1_ := 'UPDATE_SHIPMENTLINE';
         END IF;    
         -- No partial deliveries of Handling Unit content when using shipment, deliver all or nothing.
         -- sending the validate_hu_struct_position_ as FALSE.
         Issue_Part___(contract_                     => inv_part_reservations_tab_(i).contract,
                       part_no_                      => inv_part_reservations_tab_(i).part_no,
                       configuration_id_             => inv_part_reservations_tab_(i).configuration_id,
                       location_no_                  => inv_part_reservations_tab_(i).location_no,
                       lot_batch_no_                 => inv_part_reservations_tab_(i).lot_batch_no,
                       serial_no_                    => inv_part_reservations_tab_(i).serial_no,
                       eng_chg_level_                => inv_part_reservations_tab_(i).eng_chg_level,
                       waiv_dev_rej_no_              => inv_part_reservations_tab_(i).waiv_dev_rej_no,
                       activity_seq_                 => inv_part_reservations_tab_(i).activity_seq,
                       handling_unit_id_             => inv_part_reservations_tab_(i).handling_unit_id,
                       source_ref1_                  => source_ref1_,
                       source_ref2_                  => source_ref2_,
                       source_ref3_                  => source_ref3_,
                       source_ref4_                  => source_ref4_,
                       source_ref_type_db_           => source_ref_type_db_,    
                       pick_list_no_                 => inv_part_reservations_tab_(i).pick_list_no, 
                       shipment_id_                  => shipment_id_, 
                       quantity_                     => inv_part_reservations_tab_(i).qty_picked,
                       catch_quantity_               => inv_part_reservations_tab_(i).catch_qty_picked,
                       remove_remaining_reservation_ => TRUE,
                       transaction_code_             => transaction_code_,
                       dest_contract_                => dest_contract_,
                       dest_warehouse_id_            => dest_warehouse_id_,
                       ignore_this_avail_control_id_ => ignore_this_avail_control_id_,
                       validate_hu_struct_position_  => FALSE,
                       string_parameter1_            => string_parameter1_,
                       string_parameter2_            => NULL);
      END LOOP;  
   END IF;
END Issue_Shipment_Line;    


PROCEDURE Report_Reserved_As_Picked (
   source_ref1_                IN VARCHAR2,
   source_ref2_                IN VARCHAR2,
   source_ref3_                IN VARCHAR2,
   source_ref4_                IN VARCHAR2,
   source_ref_type_db_         IN VARCHAR2,
   shipment_id_                IN NUMBER,
   contract_                   IN VARCHAR2,
   ship_inventory_location_no_ IN VARCHAR2 DEFAULT NULL )
IS
   pick_list_no_       NUMBER;
BEGIN   
   Inventory_Pick_List_API.New(pick_list_no_, shipment_id_, contract_, ship_inventory_location_no_);
   Set_Pick_List_No(pick_list_no_, shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   Set_Qty_Reserved_As_Picked(pick_list_no_, ship_inventory_location_no_);
END Report_Reserved_As_Picked;  


-- This function will convert "*" to NULL. 
-- Add code here when different source ref positions in combination with different source ref types requires different results
@UncheckedAccess
FUNCTION Get_Converted_Source_Ref (
   source_ref_          IN VARCHAR2,
   source_ref_position_ IN NUMBER DEFAULT 2) RETURN VARCHAR2
IS   
  converted_source_ref_ inventory_part_reservation_tab.source_ref2%TYPE := source_ref_;
BEGIN
   IF (source_ref_position_ > 1) THEN
      converted_source_ref_ := CASE source_ref_ WHEN '*' THEN NULL ELSE source_ref_ END;
   END IF;
   RETURN (converted_source_ref_);   
END Get_Converted_Source_Ref;


-- This function will convert 0 to "*" for pick list no.  
@UncheckedAccess
FUNCTION Convert_Pick_List_No___ (
   pick_list_no_ IN NUMBER) RETURN VARCHAR2
IS   
  converted_pick_list_no_ VARCHAR2(15) := pick_list_no_;
BEGIN
   IF(pick_list_no_ = 0) THEN
      converted_pick_list_no_ := '*';   
   END IF;               
   RETURN converted_pick_list_no_;
END Convert_Pick_List_No___;


@UncheckedAccess
FUNCTION Create_Pick_List_Allowed (
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   create_pick_list_allowed_ BOOLEAN := FALSE;
   dummy_                    NUMBER;

   CURSOR check_create_pick_list_allowed IS
      SELECT 1
        FROM inventory_part_reservation_tab
       WHERE shipment_id   = shipment_id_
         AND pick_list_no  = 0;
BEGIN
   OPEN check_create_pick_list_allowed;
   FETCH check_create_pick_list_allowed INTO dummy_;
   IF (check_create_pick_list_allowed%FOUND) THEN
      create_pick_list_allowed_ := TRUE;
   END IF;
   CLOSE check_create_pick_list_allowed;
   RETURN create_pick_list_allowed_;
END Create_Pick_List_Allowed;


PROCEDURE Set_Picklist_Qty_Res_As_Picked (
   pick_list_no_               IN NUMBER,
   ship_inventory_location_no_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Set_Qty_Reserved_As_Picked(pick_list_no_, ship_inventory_location_no_);
END Set_Picklist_Qty_Res_As_Picked;


@UncheckedAccess
FUNCTION Lock_By_Keys_And_Get( 
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   pick_list_no_       IN NUMBER,
   shipment_id_        IN NUMBER ) RETURN Public_Rec                      
IS
   rec_   inventory_part_reservation_tab%ROWTYPE;
BEGIN
    rec_ := Lock_By_Keys___(contract_, 
                            part_no_, 
                            configuration_id_, 
                            location_no_, 
                            lot_batch_no_, 
                            serial_no_, 
                            eng_chg_level_, 
                            waiv_dev_rej_no_, 
                            activity_seq_, 
                            handling_unit_id_, 
                            source_ref1_, 
                            source_ref2_, 
                            source_ref3_, 
                            source_ref4_, 
                            source_ref_type_db_, 
                            pick_list_no_, 
                            shipment_id_);
                           
   RETURN Get(contract_,
              part_no_, 
              configuration_id_, 
              location_no_, 
              lot_batch_no_, 
              serial_no_, 
              eng_chg_level_, 
              waiv_dev_rej_no_, 
              activity_seq_, 
              handling_unit_id_, 
              source_ref1_, 
              source_ref2_, 
              source_ref3_, 
              source_ref4_, 
              source_ref_type_db_, 
              pick_list_no_, 
              shipment_id_);                
                           
END Lock_By_Keys_And_Get;


@UncheckedAccess
FUNCTION Get_Total_Qty_Issued (
   source_ref_type_db_    IN     VARCHAR2,
   source_ref1_           IN     VARCHAR2,
   source_ref2_           IN     VARCHAR2 DEFAULT '*',
   source_ref3_           IN     VARCHAR2 DEFAULT '*',
   source_ref4_           IN     VARCHAR2 DEFAULT '*',
   shipment_id_           IN     NUMBER   DEFAULT 0) RETURN NUMBER
IS
   total_qty_issued_ NUMBER := 0;
   
   CURSOR get_total_qty_issued IS
      SELECT NVL(SUM(qty_issued), 0)
      FROM   inventory_part_reservation_tab 
      WHERE  source_ref1      = source_ref1_
      AND    source_ref2      = source_ref2_
      AND    source_ref3      = source_ref3_
      AND    source_ref4      = source_ref4_
      AND    source_ref_type  = source_ref_type_db_
      AND    (shipment_id     = shipment_id_ OR shipment_id_ IS NULL);
BEGIN
   OPEN  get_total_qty_issued;
   FETCH get_total_qty_issued INTO total_qty_issued_;
   CLOSE get_total_qty_issued;   
   
   RETURN total_qty_issued_;   
END Get_Total_Qty_Issued;  


@UncheckedAccess
FUNCTION Get_Total_Qty_Picked (
   source_ref_type_db_    IN     VARCHAR2,
   source_ref1_           IN     VARCHAR2,
   source_ref2_           IN     VARCHAR2 DEFAULT '*',
   source_ref3_           IN     VARCHAR2 DEFAULT '*',
   source_ref4_           IN     VARCHAR2 DEFAULT '*',
   shipment_id_           IN     NUMBER   DEFAULT 0) RETURN NUMBER
IS
   total_qty_picked_ NUMBER := 0;
   
   CURSOR get_total_qty_picked IS
      SELECT NVL(SUM(qty_picked), 0)
      FROM   inventory_part_reservation_tab 
      WHERE  source_ref1      = source_ref1_
      AND    source_ref2      = source_ref2_
      AND    source_ref3      = source_ref3_
      AND    source_ref4      = source_ref4_
      AND    source_ref_type  = source_ref_type_db_
      AND    (shipment_id     = shipment_id_ OR shipment_id_ IS NULL);
BEGIN
   OPEN  get_total_qty_picked;
   FETCH get_total_qty_picked INTO total_qty_picked_;
   CLOSE get_total_qty_picked;   
   
   RETURN total_qty_picked_;   
END Get_Total_Qty_Picked; 

PROCEDURE Pick_Reservation (
   contract_                     IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   location_no_                 IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   activity_seq_                IN NUMBER,
   handling_unit_id_            IN NUMBER,
   source_ref1_                 IN VARCHAR2,
   source_ref2_                 IN VARCHAR2,
   source_ref3_                 IN VARCHAR2,
   source_ref4_                 IN NUMBER,
   source_ref_type_db_          IN VARCHAR2,
   qty_to_pick_                 IN NUMBER,
   catch_qty_to_pick_           IN NUMBER,
   ship_inventory_location_no_  IN VARCHAR2,
   pick_list_no_                IN VARCHAR2)
IS 
   keys_and_qty_rec_           Keys_And_Qty_Rec;
   keys_and_qty_tab_           Keys_And_Qty_Tab;
   shipment_id_                NUMBER;
BEGIN
   shipment_id_ := Inventory_Pick_List_API.Get_Shipment_Id(pick_list_no_);
   keys_and_qty_tab_.DELETE;

   keys_and_qty_rec_.contract            := contract_;
   keys_and_qty_rec_.part_no             := part_no_; 
   keys_and_qty_rec_.configuration_id    := configuration_id_;
   keys_and_qty_rec_.location_no         := location_no_;
   keys_and_qty_rec_.lot_batch_no        := lot_batch_no_;
   keys_and_qty_rec_.lot_batch_no        := lot_batch_no_;
   keys_and_qty_rec_.serial_no           := serial_no_;
   keys_and_qty_rec_.eng_chg_level       := eng_chg_level_;
   keys_and_qty_rec_.waiv_dev_rej_no     := waiv_dev_rej_no_;
   keys_and_qty_rec_.activity_seq        := activity_seq_;  
   keys_and_qty_rec_.handling_unit_id    := handling_unit_id_;
   keys_and_qty_rec_.source_ref1         := source_ref1_;
   keys_and_qty_rec_.source_ref2         := source_ref2_;
   keys_and_qty_rec_.source_ref3         := NVL(source_ref3_,'*');
   keys_and_qty_rec_.source_ref4         := NVL(to_char(source_ref4_),'*');
   keys_and_qty_rec_.source_ref_type_db  := source_ref_type_db_;
   keys_and_qty_rec_.qty_picked          := qty_to_pick_;
   keys_and_qty_rec_.catch_qty_picked    := catch_qty_to_pick_;
   keys_and_qty_rec_.pick_list_no        := pick_list_no_;
   keys_and_qty_rec_.shipment_id         := shipment_id_;

   Fill_Keys_And_Qty___(keys_and_qty_tab_, keys_and_qty_rec_);  
   keys_and_qty_rec_ := NULL;

   Pick_Reservation___(keys_and_qty_tab_, pick_list_no_, shipment_id_, 'FALSE', ship_inventory_location_no_);
 
END Pick_Reservation;


FUNCTION Pick_Inv_Part_Reservations (
   message_                      IN CLOB,
   pick_list_no_                 IN VARCHAR2,
   report_from_pick_list_header_ IN VARCHAR2,
   ship_inventory_location_no_   IN VARCHAR2 DEFAULT NULL,
   validate_hu_struct_position_  IN BOOLEAN  DEFAULT TRUE,
   add_hu_to_shipment_           IN BOOLEAN  DEFAULT TRUE ) RETURN CLOB
IS
   count_                      NUMBER;
   name_arr_                   Message_SYS.name_table;
   value_arr_                  Message_SYS.line_table;
   keys_and_qty_rec_           Keys_And_Qty_Rec;
   keys_and_qty_tab_           Keys_And_Qty_Tab;
   info_                       CLOB;
   clob_out_data_              CLOB;
   pick_list_fully_reported_   CLOB:= 'FALSE';
   shipment_id_                NUMBER;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   keys_and_qty_tab_.DELETE; 

   shipment_id_ := Inventory_Pick_List_API.Get_Shipment_Id(pick_list_no_);
   
   FOR n_ IN 1..count_ LOOP 
      IF (name_arr_(n_) = 'CONTRACT') THEN
         keys_and_qty_rec_.contract     := value_arr_(n_);
         keys_and_qty_rec_.pick_list_no := pick_list_no_; 
         keys_and_qty_rec_.shipment_id  := shipment_id_;
      ELSIF (name_arr_(n_) = 'PART_NO') THEN
         keys_and_qty_rec_.part_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'CONFIGURATION_ID') THEN
         keys_and_qty_rec_.configuration_id := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOCATION_NO') THEN
         keys_and_qty_rec_.location_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'LOT_BATCH_NO') THEN
         keys_and_qty_rec_.lot_batch_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SERIAL_NO') THEN
         keys_and_qty_rec_.serial_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ENG_CHG_LEVEL') THEN
         keys_and_qty_rec_.eng_chg_level := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'WAIV_DEV_REJ_NO') THEN
         keys_and_qty_rec_.waiv_dev_rej_no := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'ACTIVITY_SEQ') THEN
         keys_and_qty_rec_.activity_seq := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         keys_and_qty_rec_.handling_unit_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SOURCE_REF1') THEN
         keys_and_qty_rec_.source_ref1 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF2') THEN
         keys_and_qty_rec_.source_ref2 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF3') THEN
         keys_and_qty_rec_.source_ref3 := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'SOURCE_REF4') THEN
         keys_and_qty_rec_.source_ref4 := value_arr_(n_);   
      ELSIF (name_arr_(n_) = 'SOURCE_REF_TYPE_DB') THEN
         keys_and_qty_rec_.source_ref_type_db := value_arr_(n_); 
      ELSIF (name_arr_(n_) = 'PART_TRACKING_SESSION_ID') THEN
         keys_and_qty_rec_.part_tracking_session_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));        
      ELSIF (name_arr_(n_) = 'QTY_PICKED') THEN
         keys_and_qty_rec_.qty_picked := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'CATCH_QTY_PICKED') THEN
         keys_and_qty_rec_.catch_qty_picked := Client_SYS.Attr_Value_To_Number(value_arr_(n_)); 
      ELSIF (name_arr_(n_) = 'SHIP_HANDLING_UNIT_ID') THEN
         keys_and_qty_rec_.ship_handling_unit_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));     
      ELSIF (name_arr_(n_) = 'PACK_COMPLETE') THEN
         Fill_Keys_And_Qty___(keys_and_qty_tab_, keys_and_qty_rec_);  
         keys_and_qty_rec_ := NULL;
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(n_));
      END IF;
   END LOOP;
   
   Pick_Reservation___(keys_and_qty_tab_, pick_list_no_, shipment_id_, report_from_pick_list_header_, ship_inventory_location_no_);
   
   info_ := Client_SYS.Get_All_Info;
   
   IF (Inventory_Pick_List_API.Is_Fully_Reported(pick_list_no_)= 'TRUE') THEN
      pick_list_fully_reported_ := 'TRUE';   
   END IF;   
   
   clob_out_data_ := Message_SYS.Construct('OUTPUT_DATA');
   IF (info_ IS NOT NULL) THEN 
      Message_SYS.Add_Clob_Attribute(clob_out_data_, 'INFO', info_);
   END IF;   
   Message_SYS.Add_Clob_Attribute(clob_out_data_, 'PICK_LIST_FULLY_REPORTED', pick_list_fully_reported_); 
   
   RETURN clob_out_data_;   
END Pick_Inv_Part_Reservations;


PROCEDURE Set_Qty_Reserved_As_Picked (
   pick_list_no_               IN NUMBER,
   ship_inventory_location_no_ IN VARCHAR2,
   trigger_shipment_flow_      IN BOOLEAN DEFAULT TRUE)
IS
   shipment_id_           NUMBER;
   local_ship_inv_loc_no_ VARCHAR2(35); 
   
   CURSOR get_unpicked_reservations IS
      SELECT *
        FROM inventory_part_reservation_tab
       WHERE pick_list_no = pick_list_no_
         AND qty_reserved > qty_picked;
      
   TYPE Unpicked_Reservations_Tab IS TABLE OF get_unpicked_reservations%ROWTYPE INDEX BY PLS_INTEGER;
   unpicked_reservations_tab_   Unpicked_Reservations_Tab;
   picking_hu_                  BOOLEAN;
   
BEGIN
   shipment_id_ := Inventory_Pick_List_API.Get_Shipment_Id(pick_list_no_);
   
   OPEN  get_unpicked_reservations;
   FETCH get_unpicked_reservations BULK COLLECT INTO unpicked_reservations_tab_;
   CLOSE get_unpicked_reservations; 
   
   
   IF (unpicked_reservations_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      IF (NVL(shipment_id_, 0) != 0) THEN
         local_ship_inv_loc_no_ := NVL(ship_inventory_location_no_, Inventory_Pick_List_API.Get_Ship_Inventory_Location_No(pick_list_no_));
      END IF;
      FOR unpicked_reservation_rec_ IN get_unpicked_reservations LOOP
         IF (unpicked_reservation_rec_.qty_reserved > 0) THEN       
            IF Transport_Task_Line_API.Reservation_Booked_For_Transp(from_contract_         => unpicked_reservation_rec_.contract,
                                                                     from_location_no_      => unpicked_reservation_rec_.location_no,
                                                                     part_no_               => unpicked_reservation_rec_.part_no,
                                                                     configuration_id_      => unpicked_reservation_rec_.configuration_id,
                                                                     lot_batch_no_          => unpicked_reservation_rec_.lot_batch_no,
                                                                     serial_no_             => unpicked_reservation_rec_.serial_no,
                                                                     eng_chg_level_         => unpicked_reservation_rec_.eng_chg_level,
                                                                     waiv_dev_rej_no_       => unpicked_reservation_rec_.waiv_dev_rej_no,
                                                                     activity_seq_          => unpicked_reservation_rec_.activity_seq,
                                                                     handling_unit_id_      => unpicked_reservation_rec_.handling_unit_id,
                                                                     order_ref1_            => unpicked_reservation_rec_.source_ref1,
                                                                     order_ref2_            => Get_Converted_Source_Ref(unpicked_reservation_rec_.source_ref2,2),
                                                                     order_ref3_            => Get_Converted_Source_Ref(unpicked_reservation_rec_.source_ref3,3),
                                                                     order_ref4_            => Get_Converted_Source_Ref(unpicked_reservation_rec_.source_ref4,4),
                                                                     pick_list_no_          => Convert_Pick_List_No___(unpicked_reservation_rec_.pick_list_no),
                                                                     shipment_id_           => unpicked_reservation_rec_.shipment_id,
                                                                     order_type_db_         => unpicked_reservation_rec_.source_ref_type) THEN                     
               Error_SYS.Record_General(lu_name_, 'NOTPROCEEDRPICK: Cannot proceed with report picking when there exist reservations connected to transport tasks');
            END IF;
         END IF;         
         
         IF (unpicked_reservation_rec_.handling_unit_id != 0) THEN
            -- If we get a Handling Unit back from this call it means that the full Handling Unit is on the Pick List and will be picked.
            picking_hu_ := Handl_Unit_Stock_Snapshot_API.Get_Outerm_Hu_And_Disc_Parent(source_ref1_         => pick_list_no_, 
                                                                                       source_ref_type_db_  => Handl_Unit_Snapshot_Type_API.DB_PICK_LIST, 
                                                                                       handling_unit_id_    => unpicked_reservation_rec_.handling_unit_id) IS NOT NULL;
         ELSE
            picking_hu_ := FALSE;
         END IF;
           
         Report_Picking___(contract_                    => unpicked_reservation_rec_.contract,
                           part_no_                     => unpicked_reservation_rec_.part_no,
                           configuration_id_            => unpicked_reservation_rec_.configuration_id,
                           location_no_                 => unpicked_reservation_rec_.location_no,
                           lot_batch_no_                => unpicked_reservation_rec_.lot_batch_no,
                           serial_no_                   => unpicked_reservation_rec_.serial_no,
                           eng_chg_level_               => unpicked_reservation_rec_.eng_chg_level,
                           waiv_dev_rej_no_             => unpicked_reservation_rec_.waiv_dev_rej_no,
                           activity_seq_                => unpicked_reservation_rec_.activity_seq,
                           handling_unit_id_            => unpicked_reservation_rec_.handling_unit_id,
                           qty_picked_                  => unpicked_reservation_rec_.qty_reserved,
                           part_tracking_session_id_    => NULL,
                           catch_qty_picked_            => NULL,
                           source_ref_type_db_          => unpicked_reservation_rec_.source_ref_type,
                           source_ref1_                 => unpicked_reservation_rec_.source_ref1,
                           source_ref2_                 => unpicked_reservation_rec_.source_ref2,
                           source_ref3_                 => unpicked_reservation_rec_.source_ref3,
                           source_ref4_                 => unpicked_reservation_rec_.source_ref4,
                           pick_list_no_                => unpicked_reservation_rec_.pick_list_no,
                           shipment_id_                 => unpicked_reservation_rec_.shipment_id,
                           ship_inventory_location_no_  => local_ship_inv_loc_no_,
                           validate_hu_struct_position_ => NOT picking_hu_,
                           add_hu_to_shipment_          => FALSE); -- We will add as high level HU as possible with the call to Shipment_Handling_Utility_API.Connect_HUs_From_Inventory.
      END LOOP;
      IF (NVL(shipment_id_, 0) != 0) THEN
         Post_Pick_Report_Shipment___(shipment_id_, pick_list_no_, local_ship_inv_loc_no_, trigger_shipment_flow_);
      END IF;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   
END Set_Qty_Reserved_As_Picked;

-- Reserve_Or_Unreserve_On_Swap
-- This method is used in the move reserved stock functionality. 
PROCEDURE Reserve_Or_Unreserve_On_Swap (   
   qty_reserved_                 OUT NUMBER,   
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,
   configuration_id_             IN  VARCHAR2,
   location_no_                  IN  VARCHAR2,
   lot_batch_no_                 IN  VARCHAR2,
   serial_no_                    IN  VARCHAR2,
   eng_chg_level_                IN  VARCHAR2,
   waiv_dev_rej_no_              IN  VARCHAR2,
   activity_seq_                 IN  NUMBER,
   handling_unit_id_             IN  NUMBER,
   quantity_                     IN  NUMBER,  
   source_ref_type_db_           IN  VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   pick_list_no_                 IN  NUMBER,
   shipment_id_                  IN  NUMBER,        
   ignore_this_avail_control_id_ IN  VARCHAR2 DEFAULT NULL,
   string_parameter1_            IN  VARCHAR2 DEFAULT NULL,
   string_parameter2_            IN  VARCHAR2 DEFAULT NULL)
IS   
BEGIN
   IF (source_ref_type_db_ IN  (Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES, Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER)) THEN
      Reserve_Part___(contract_                       => contract_, 
                      part_no_                        => part_no_, 
                      configuration_id_               => configuration_id_,
                      location_no_                    => location_no_,
                      lot_batch_no_                   => lot_batch_no_,
                      serial_no_                      => serial_no_,
                      eng_chg_level_                  => eng_chg_level_,
                      waiv_dev_rej_no_                => waiv_dev_rej_no_,
                      activity_seq_                   => activity_seq_,
                      handling_unit_id_               => handling_unit_id_,
                      quantity_                       => quantity_,
                      source_ref_type_db_             => source_ref_type_db_,
                      source_ref1_                    => source_ref1_,
                      source_ref2_                    => NVL(source_ref2_, '*'),
                      source_ref3_                    => NVL(source_ref3_, '*'),
                      source_ref4_                    => NVL(source_ref4_, '*'),
                      pick_list_no_                   => NVL(pick_list_no_, 0),
                      shipment_id_                    => NVL(shipment_id_, 0),
                      ignore_this_avail_control_id_   => ignore_this_avail_control_id_,
                      string_parameter1_              => string_parameter1_,
                      string_parameter2_              => string_parameter2_);
      qty_reserved_ := quantity_;
   END IF;
END Reserve_Or_Unreserve_On_Swap;

PROCEDURE Lock_Res_And_Fetch_Info (
   qty_reserved_         OUT NUMBER,
   contract_             IN  VARCHAR2,
   part_no_              IN  VARCHAR2,
   configuration_id_     IN  VARCHAR2,
   location_no_          IN  VARCHAR2,
   lot_batch_no_         IN  VARCHAR2,
   serial_no_            IN  VARCHAR2,
   eng_chg_level_        IN  VARCHAR2,
   waiv_dev_rej_no_      IN  VARCHAR2,
   activity_seq_         IN  NUMBER,
   handling_unit_id_     IN  NUMBER,
   source_ref_type_db_   IN  VARCHAR2,
   source_ref1_          IN  VARCHAR2,
   source_ref2_          IN  VARCHAR2,
   source_ref3_          IN  VARCHAR2,
   source_ref4_          IN  VARCHAR2,
   pick_list_no_         IN  NUMBER,
   shipment_id_          IN  NUMBER )
IS  
   rec_   inventory_part_reservation_tab%ROWTYPE;
BEGIN
   rec_ := Lock_By_Keys___(contract_, 
                           part_no_, 
                           configuration_id_, 
                           location_no_, 
                           lot_batch_no_, 
                           serial_no_, 
                           eng_chg_level_, 
                           waiv_dev_rej_no_, 
                           activity_seq_, 
                           handling_unit_id_, 
                           source_ref1_, 
                           source_ref2_, 
                           source_ref3_, 
                           source_ref4_, 
                           source_ref_type_db_, 
                           pick_list_no_, 
                           shipment_id_);
         
   qty_reserved_ := rec_.qty_reserved;
 
END Lock_Res_And_Fetch_Info;

@UncheckedAccess
FUNCTION Get_Total_Qty_On_Pick_List (  
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2 DEFAULT '*',
   source_ref3_        IN VARCHAR2 DEFAULT '*',
   source_ref4_        IN VARCHAR2 DEFAULT '*',
   shipment_id_        IN NUMBER   DEFAULT  0  ) RETURN NUMBER
IS
   total_qty_on_pick_list_ NUMBER := 0;
   
   CURSOR get_total_qty_on_pick_list IS
      SELECT NVL(SUM(qty_reserved),0)
      FROM   inventory_part_reservation_tab 
      WHERE  source_ref1      = source_ref1_
      AND    source_ref2      = source_ref2_
      AND    source_ref3      = source_ref3_
      AND    source_ref4      = source_ref4_
      AND    source_ref_type  = source_ref_type_db_
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
      AND    pick_list_no     != 0
      AND    qty_reserved     > 0;
BEGIN
   OPEN get_total_qty_on_pick_list;
   FETCH get_total_qty_on_pick_list INTO total_qty_on_pick_list_;
   CLOSE get_total_qty_on_pick_list;
   RETURN total_qty_on_pick_list_;
END Get_Total_Qty_On_Pick_List;


FUNCTION Get_Pick_By_Choice_Blocked_Db (
   contract_           IN VARCHAR2,
   part_no_            IN VARCHAR2,
   configuration_id_   IN VARCHAR2,
   location_no_        IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   eng_chg_level_      IN VARCHAR2,
   waiv_dev_rej_no_    IN VARCHAR2,
   activity_seq_       IN NUMBER,
   handling_unit_id_   IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2,
   shipment_id_        IN NUMBER) RETURN inventory_part_reservation_tab.pick_by_choice_blocked%TYPE
IS
   pick_by_choice_blocked_ inventory_part_reservation_tab.pick_by_choice_blocked%TYPE;

   CURSOR get_pick_by_choice_blocked IS 
         SELECT pick_by_choice_blocked
         FROM  inventory_part_reservation_tab
         WHERE contract          = contract_
         AND   part_no           = part_no_
         AND   configuration_id  = configuration_id_
         AND   location_no       = location_no_
         AND   lot_batch_no      = lot_batch_no_
         AND   serial_no         = serial_no_
         AND   eng_chg_level     = eng_chg_level_
         AND   waiv_dev_rej_no   = waiv_dev_rej_no_
         AND   activity_seq      = activity_seq_
         AND   handling_unit_id  = handling_unit_id_
         AND   source_ref1       = source_ref1_
         AND   source_ref2       = source_ref2_
         AND   source_ref3       = NVL(source_ref3_,'*')
         AND   source_ref4       = NVL(source_ref4_,'*')
         AND   source_ref_type   = source_ref_type_db_
         AND   shipment_id       = NVL(shipment_id_,0)
         AND   qty_reserved - qty_picked > 0;
         
BEGIN
   OPEN  get_pick_by_choice_blocked;
   FETCH get_pick_by_choice_blocked INTO pick_by_choice_blocked_;
   CLOSE get_pick_by_choice_blocked;
   RETURN NVL(pick_by_choice_blocked_, Fnd_Boolean_API.DB_FALSE);
END Get_Pick_By_Choice_Blocked_Db;

-- Pick report a Handling unit reservation
PROCEDURE Pick_HU_Reservations (
   pick_list_no_          IN VARCHAR2,
   handling_unit_id_      IN NUMBER,
   ship_location_no_      IN VARCHAR2)
IS
   pick_clob_       CLOB;
   out_clob_        CLOB;
BEGIN 
   pick_clob_ := Message_SYS.Construct('');      
   Message_SYS.Add_Attribute(pick_clob_, 'HANDLING_UNIT_ID', handling_unit_id_);

   out_clob_ := Pick_Aggregated_Reservations__(message_               => pick_clob_,                                         
                                               pick_list_no_          => pick_list_no_,
                                               ship_location_no_      => ship_location_no_);
     
END Pick_HU_Reservations;

PROCEDURE Unissue_Shipment_Line (
   undo_available_     OUT BOOLEAN,
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2,
   shipment_id_        IN  NUMBER)
IS     
   CURSOR get_inv_transaction_info (order_type_ IN VARCHAR2) IS
      SELECT transaction_id, transaction_code, quantity, catch_quantity, source
      FROM   INVENTORY_TRANSACTION_HIST_PUB 
      WHERE  source_ref1 = source_ref1_
      AND    source_ref2 = source_ref2_
      AND    NVL(source_ref3,0) =  NVL(source_ref3_,0)
      AND    NVL(source_ref4,0) =  NVL(source_ref4_,0)
      AND    source_ref5 = shipment_id_
      AND    source_ref_type = order_type_
      AND    transaction_code IN ('SHIPODWHS-', 'SHIPODSIT-', 'PD-SHIP')
      AND    direction = '-'
      AND    qty_reversed = 0;   
   
   CURSOR get_reservation_info IS
      SELECT contract, part_no, configuration_id, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no, activity_seq, 
             handling_unit_id, pick_list_no, qty_reserved, qty_picked, qty_issued, catch_qty_issued, catch_qty_picked
      FROM   inventory_part_reservation_tab
      WHERE  source_ref1 = source_ref1_
      AND    source_ref2 = source_ref2_
      AND    NVL(source_ref3,'*') =  NVL(source_ref3_,'*')
      AND    NVL(source_ref4,'*') =  NVL(source_ref4_,'*')
      AND    shipment_id = shipment_id_
      AND    source_ref_type = source_ref_type_db_
      AND    qty_issued > 0;
   
   newrec_              inventory_part_reservation_tab%ROWTYPE;
   oldrec_              inventory_part_reservation_tab%ROWTYPE;
   qty_issued_          NUMBER;
   qty_picked_          NUMBER;
   qty_reserved_        NUMBER;
   catch_qty_picked_    NUMBER;
   catch_qty_issued_    NUMBER;
   dummy_number_        NUMBER;   
   new_transaction_id_  NUMBER;
   order_type_          VARCHAR2(20);
   transaction_code_    VARCHAR2(10);
BEGIN   
   undo_available_   := FALSE;
   order_type_       := Get_Order_Type_Db___(source_ref_type_db_);
   
   FOR inv_tran_rec_ IN get_inv_transaction_info(order_type_) LOOP
      CASE (inv_tran_rec_.transaction_code)
         WHEN ('SHIPODWHS-') THEN
            transaction_code_ := 'UND-SHPODW';
         WHEN ('SHIPODSIT-') THEN
            transaction_code_ := 'UND-SHPODS';
         WHEN ('PD-SHIP') THEN
            transaction_code_ := 'PD-UNSHIP';
         ELSE
            NULL;
      END CASE;            
      
      Inventory_Part_In_Stock_API.Unissue_Part(new_transaction_id_,
                                               transaction_code_,
                                               'INVREVAL+',
                                               'INVREVAL-',
                                               inv_tran_rec_.quantity,
                                               inv_tran_rec_.catch_quantity,
                                               inv_tran_rec_.transaction_id,
                                               inv_tran_rec_.source,
                                               FALSE);
      undo_available_ := TRUE;
   END LOOP;
   
   IF undo_available_ THEN         
      Inventory_Event_Manager_API.Start_Session;
      
      FOR rec_ IN get_reservation_info LOOP
         qty_issued_    := 0;
         qty_reserved_  := rec_.qty_reserved + rec_.qty_issued;
         qty_picked_    := rec_.qty_picked + rec_.qty_issued;
         
         IF rec_.catch_qty_picked IS NOT NULL THEN
            catch_qty_picked_ := rec_.catch_qty_issued;
         END IF;
         IF rec_.catch_qty_issued IS NOT NULL THEN
            catch_qty_issued_ := 0;
         END IF;
         
         oldrec_ := Lock_By_Keys___(rec_.contract, 
                                    rec_.part_no, 
                                    rec_.configuration_id, 
                                    rec_.location_no, 
                                    rec_.lot_batch_no, 
                                    rec_.serial_no, 
                                    rec_.eng_chg_level, 
                                    rec_.waiv_dev_rej_no, 
                                    rec_.activity_seq, 
                                    rec_.handling_unit_id, 
                                    source_ref1_, 
                                    source_ref2_, 
                                    NVL(source_ref3_,'*'),
                                    NVL(source_ref4_,'*'),
                                    source_ref_type_db_, 
                                    rec_.pick_list_no, 
                                    shipment_id_);
         
         newrec_                    := oldrec_;
         newrec_.qty_reserved       := qty_reserved_;  
         newrec_.qty_picked         := qty_picked_;  
         newrec_.qty_issued         := qty_issued_;
         newrec_.catch_qty_picked   := catch_qty_picked_;
         newrec_.catch_qty_issued   := catch_qty_issued_;
         
         Update_Record___(newrec_ => newrec_, 
                          oldrec_ => oldrec_,
                          string_parameter1_ => 'UNDO_DELIVERY');
         
         Inventory_Part_In_Stock_API.Reserve_Part(dummy_number_, rec_.contract, rec_.part_no, rec_.configuration_id, 
                                                  rec_.location_no, rec_.lot_batch_no, rec_.serial_no, 
                                                  rec_.eng_chg_level, rec_.waiv_dev_rej_no, rec_.activity_seq, 
                                                  rec_.handling_unit_id, rec_.qty_issued);
         
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Unissue_Shipment_Line;

-------------------- LU  NEW METHODS -------------------------------------


