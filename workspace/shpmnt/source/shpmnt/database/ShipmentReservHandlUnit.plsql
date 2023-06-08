-----------------------------------------------------------------------------
--
--  Logical unit: ShipmentReservHandlUnit
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  221103  AvWilk  SCDEV-17249, performance improvement, added Inventory_Event_Manager_API start and finish sessions into Add_Reservations_To_Handl_Unit and 
--  221103          removed session methods from Repack_Into_HU_On_Shipment___.
--  220710  RoJalk  SCDEV-12440, Modified Repack_Into_HU_On_Shipment___, Unpack_From_HU_On_Shipment___ and feteched a value to  source_ref_demand_code_ to be passed to method calls.    
--  220122  RoJalk  SC21R2-2756, Modified Get_Reserv_Hu_Ext_Details to consider activity_seq for SHIPMENT ORDER. Addded activity_seq to Reserv_Handl_Unit_Ext_Rec.
--  211110  Aabalk  SC21R2-5899, Added methods Get_Hus_Per_Reservation to fetch shipment handling units for a reservation and Attach_Reservations_To_Ship_Hu 
--  211027          to reattach reservations to their relevants shipment handling units.
--  210719  RoJalk  SC21R2-1374, Modifications to Remove_Or_Modify method to support report picking of shipment hu. 
--  210711  RoJalk  SC21R2-1374, Modified Get_Handling_Units, Remove_Or_Modify, Get_Valid_Qty_To_Be_Packed consider 
--  210711          shipment handling unit id when pick reporting from shipemnt handling unit.
--  210325  ThKrlk  Bug 157855(SCZ-14013), Modified Check_Quantity___() by adding new condition to bypass the error block if it is reassign flow.
--  210217  RoJalk  SC2020R1-11621, Modified New___ to call generated New___ method instead of Unpack methods.
--  210208  RasDlk  SC2020R1-11817, Modified Repack_Into_HU_On_Shipment___, New_Or_Add_To_Existing, Remove_Or_Modify, Reassign_Handl_Unit 
--  210208          and Add_Reservations_To_Handl_Unit by reducing number of calls to increase the performance.
--  210205  RoJalk  SC2020R1-12433, Reversed the correction done in Modify_Pick_List_No for SC2020R1-11621.
--  210126  RoJalk  SC2020R1-11621, Modified Modify_Pick_List_No to call Modify___ instead of Unpack methods.
--  201130  AsZelk  Bug 156819(SCZ-12852), Modified cursor get_ship_inv_qty of Get_Line_Ship_Inv_Qty adding handling_unit_id and pick_list_no checks instead of
--  201130          location group (Inventory_Location_API.Get_Location_Type_Db) to improve performance.
--  201120  LEPESE  SC2020R1-10786, modifications in Create_Data_Capture_Lov, Get_Column_Value_If_Unique, Record_With_Column_Value_Exist for Shipment Order.
--  200710  KiSalk  Bug  151041(SCZ-7954), Added check for shipment_id in shipment_reserv_handl_unit_tab cursors of Get_Sub_Struct_Eng_Chg_Level, Get_Sub_Struct_Lot_Batch_No,
--  191121          Get_Sub_Struct_Serial_No, Get_Sub_Struct_Waiv_Dev_Rej_No to improve performance.
--  200515  ChFolk  Bug 153521(SCZ-9877), Modified Add_Reservations_To_Handl_Unit to calculate quantity_to_add_ using directly from inventory quantities when remaining_qty_to_attach_ is zero.
--  200428  ChFolk  Bug 153255(SCZ-9758), Modified Check_Quantity___ to avoid validation when shipment line is fully reserved with respect to Inventory UoM.
--  200417  ChFolk  Bug 153255(SCZ-9758), Modified Add_Reservations_To_Handl_Unit by adding parameter mix_block_excep_handling_
--  200417          to support attaching the reservation to shipment handling unit when mix_of_blocked exception is thrown.
--  200413  Aabalk  Bug 153107(SCZ-9691), Modified Change_Handling_Unit_id() by including the manual net weight to Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing() method and 
--  200413          added condition to run handling unit change only if the source and destination handling units are different.
--  200407          to prevent losing the manual net weight when moving shipment reservations between handling units.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200219  ChFolk  Bug 152505(SCZ-8953), Modified Check_Quantity___ to use sales quantities in value comparison to avoid back and forth conversion when used inventory quantities.
--  191209  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191209          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191209          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  180516  SBalLK  Bug 141724, Removed defined component dependency with own component.
--  180307  RaVdlk  STRSC-17471, Removed installation errors from sql plus tool
--  180228  Nikplk   STRSC-17339, Added overloaded method, Handling_Unit_Exist with shipment_id and shipment_line_no parameters.
--  171213  KiSalk   STRSC-4491, Modified Remove_Or_Modify to call either if shipment_line_handl_unit_qty_ or handling_unit_reserved_qty_ is greater than new_quantity_.
--  170424  SucPlk   STRSC-12366, Modified Create_Data_Capture_Lov, Get_Column_Value_If_Unique and Record_With_Column_Value_Exist to improve the code quality.  
--  171130  RoJalk   STRSC-14025, Added the method Raise_Line_Removed_Warning___.
--  171130  SucPlk   STRSC-14798, Modified Get_Column_Value_If_Unique and Record_With_Column_Value_Exist to avoid unnecassary error message 
--  171130           raised when unpacking handling units with SSCC or ALT_HANDLING_UNIT_LABEL_ID. 
--  171128  SucPlk   STRSC-14798, Modified Create_Data_Capture_Lov to display shipment ids in lov; which are having values 
--  171128           for SSCC or ALT_HANDLING_UNIT_LABEL_ID in the connected HU.
--  171114  Mwerse   STRSC-13912, Added methods Reduce_Quantity and Change_Handling_Unit_Id to be able to move shipment reservations between handling units.
--  171027  RoJalk   STRSC-13804, Modified Insert___ , Update___ and Delete___ called Shipment_API.Reset_Printed_Flags__.
--  171026  SucPlk   STRSC-12328, Added method Record_With_Column_Value_Exist to support UNPACK_PART_FROM_HU_SHIP wadaco process.
--  171025  SucPlk   STRSC-12328, Added methods Create_Data_Capture_Lov and Get_Column_Value_If_Unique to support UNPACK_PART_FROM_HU_SHIP wadaco process.
--  170911  Mwerse   STRSC-11836, Conformed Mixed_Cond_Codes_Connected and Mixed_lot_Batches_Connected to corresponding Handling Unit methods
--  170601  Jhalse   STRSC-8096, Added new method Distribute_Reservations__ which lets the system attach reservations automatically based on in parameter.
--  170523  KHVESE   STRSC-8590, Added new method Has_Qty_Attached_To_Shipment which currently only used in WADACO process.
--  161013  RoJalk   Bug 132092, Modified Get_Remain_Res_To_Hu_Connect method to calculate remaining reservation quantity in order to create handling unit.
--  170507  RoJalk   LIM-11457, Modified Get_Reserv_Hu_Ext_Details to include shipment id.
--  170505  RoJalk   STRSC-7931, Modified Unpack_From_HU_On_Shipment___ and called Reserve_Shipment_API.Reservation_Exists
--  170505           and Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info.
--  170504  RoJalk   STRSC-7812, Used Shipment_Line_API.Get_Converted_Source_Ref to convert source refs before calling
--  170504           Inventory_Part_In_Stock_API.Change_Handling_Unit_Id.
--  170503  RoJalk   Bug 130169, Added Get_Quantity_On_Shipment(). 
--  170426  MaIklk   LIM-10986, Fixed to convert source ref column value (if "*") to NULL when calling shipment line API.
--  170403  Chfose   LIM-10395, Added information message for when unable to attach reservation in Add_Reservations_To_Handl_Unit.
--  170330  Chfose   LIM-10832, Replaced Reserve___ & Unreserve___ with method Reserve_Shipment_API.Reserve_As_Picked.
--  170309  Chfose   LIM-10728, Added new method Get_Catch_Qty_On_Shipment.
--  170302  RoJalk   LIM-11001, Replaced Shipment_Source_Utility_API.Public_Reservation_Rec with
--  170302           Reserve_Shipment_API.Public_Reservation_Rec.
--  170223  MaIklk   LIM-9422, Handled to included shipment_line in cursor where clauses to make sure it returns unique records.
--  170202  Chfose   LIM-10117, Modified handling unit information to be fetched through SHPMNT_HANDL_UNIT_WITH_HISTORY to properly include HandlingUnitHistory when applicable.
--  170202  Chfose   Also added shipment_id to methods that took only handling unit id.
--  170124  MaIklk   LIM-9820, Handled the conversion of "*" and NULL for Shipment_Source_Reservation
--  170109  Chfose   LIM-8650, Added new method Remove_Or_Modify_Reservation and new parameter FALSE for Delete___ in Reassign_Handl_Unit
--  170109           to avoid unpacking in shipment inventory.
--  161222  Chfose   LIM-3663, Broke apart Change_Handling_Unit_Id___ into Repack_Into_HU_On_Shipment___ & Unpack_From_HU_On_Shipment___
--  161222           and gathered code regarding reserving and unreserving in new methods Reserve___ & Unreserve___.
--  161220  Jhalse   LIM-10062, Added method Remove_Without_Unpack() to subdue unpacking when move handling units in shipment inventory.
--  161219  Chfose   LIM-10070, Added the source_ref-columns in call to Inventory_Part_In_Stock_API.Change_Handling_Unit_Id.
--  161215  Chfose   LIM-3663, Added new method Change_Handling_Unit_Id___ for syncing the Shipment HU structure and packing in inventory and on the reservations.
--  161215           Also added new method Get_Valid_Qty_To_Be_Packed for fetching the quantity that is able to be packed.
--  161205  MaIklk   LIM-9261, Moved Get_Remain_Res_To_Hu_Connect from customer_order_reservation_API to Shipment_Reserv_Handl_unit_API.
--  161205  MaIklk   LIM-9257, Moved Get_Number_Of_Lines, Add_Reservations_To_Handl_Unit, Add_Reservations_On_Reassign 
--  161205           from Customer_Order_Reservation_API to Shipment_Reserv_Handl_Unit_API
--  161128  Jhalse   LIM-9188, Moved conditional in Remove_Or_Modify as it allowed to set false quantities when handling a single handling unit.
--  161123  MaIklk   LIM-9244, Moved this entity from Order to shpmnt and accroding to column changes made this entity generic.
--  160830  RoJalk   LIM-8189, Modified return data type of Get_Handling_Units, Add_Handling_Units to be
--  160830           Shipment_Source_Utility_API.Reserv_Handl_Unit_Qty_Tab.
--  160816  Chfose   LIM-8006, Added reserv_handling_unit_id to multiple methods and changed the order of parameters in various methods  
--  160816           to properly align with the keys of a customer order reservation.
--  160726  RoJalk   LIM-8149, Included shipment_line_no_ in Remove_Or_Modify interface.
--  160726  RoJalk   LIM-8148, Added shipment_line_no_ to Modify_Pick_List_No method.
--  160726  RoJalk   LIM-8147, Added shipment_line_no_ to Get_Handling_Units method.
--  160714  RoJalk   LIM-7359, Replaced the usage of Customer_Order_Reservation_API.Reassign_Connected_Qty with
--  160714           Reassign_Shipment_Utility_API.Reassign_Connected_Reserve_Qty.
--  160712  RoJalk   LIM-7956, Removed the methods Get_Sub_Struct_Lot_Batch_No, Get_Sub_Struct_Eng_Chg_Level,
--  160712           Get_Sub_Struct_Waiv_Dev_Rej_No, Get_Sub_Struct_Serial_No since usage was replaced with methods in Shipment_Source_Utility_API. 
--  160601  RoJalk   LIM-7482, Modified Add_Handling_Units, New_Or_Add_To_Existing and changed the shipment_line_no_ to be not null.
--  160526  RoJalk   STRSC-2528, Added teh parameter reserv_handling_unit_id_ to Modify_Pick_List_No.
--  160520  RoJalk   LIM-7478, Added shipment_line_no_ to Add_Handling_Units . 
--  160426  RoJalk   LIM-6631, Modified Check_Insert___ and include NVL handling in comparisons using source ref.
--  160422  RoJalk   LIM-7256, Added public interfaces Remove, Modify. Modified Remove_Handling_Unit and called Remove___.
--  160422           Modified New___ and changed the shipment line no to be NOT NULL parameter.
--  160306  RoJalk   LIM-6321, Modified Reassign_Handl_Unit and added to_shipment_line_no_ as a parameter.
--  160304  RoJalk   LIM-6216, Modified Check_Insert___ and added a validation to check if reservation is from same source as HU.
--  160217  JeLise   LIM-6223, Added reserv_handling_unit_id_ as new parameter in Get_Quantity_On_Shipment.
--  160205  RoJalk   LIM-4246, Modified code to support new key column shipment line no.
--  160128  RoJalk   LIM-5911, Replaced Shipment_Line_API.Get_Qty_Assigned with Shipment_Line_API.Get_Qty_Assigned_By_Source.
--  160122  RoJalk   LIM-5449, Added shipment_line_no_ to Check_Quantity___  method.
--  160121  RoJalk   LIM-5989, Modified Modify_Pick_List_No, Remove_Or_Modify to handle shipment line no.
--  160120  RoJalk   LIM-5911, Added shipment_line_no_ to New___, New_Or_Add_To_Existing.
--  151113  JeLise   LIM-4457, Removed pallet_id and added reserv_handling_unit_id.
--  151113  MaEelk   LIM-4453, Removed pallet_id from Customer_Order_Reservation_API calls.
--  151110  RoJalk   LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  150505  JeLise   LIM-1893, Added handling_unit_id_ in LU calls where applicable.
--  150415  RILASE   COB-27, Added Validate_Catch_Qty to break out validation for re-use in WADACO.
--  130903  RoJalk   Modified Remove_Or_Modify interfaces and passed NULL for catch qty to reassign instead of 0.
--  130829  JeLise   Added new methods Get_Handling_Units and Add_Handling_Units.
--  130820  JeLise   Added check on handling_unit_reserved_qty_ in Remove_Or_Modify.
--  130815  JeLise   Changed the error message CATCHQTYINCORRECT in Check_Quantity___, to be more clear.
--  130814  JeLise   Added call to Shipment_Order_Line_API.Get_Qty_Assigned in Reassign_Handl_Unit and added more checks, to make sure to reassign the correct catch qty.
--  130813  JeLise   Added check on if catch unit is enabled in Check_Quantity___.
--  130806  MaEelk   Changed the parameter list of Mixed_Lot_Batches_Connected and Mixed_Cond_Codes_Connected. Removed additional codes
--  130806           Made the call to Handling_Unit_API.Check_Allow_Mix from Insert___ instead of calling it from Unpack_Check_Insert___
--  130802  RoJalk   Added the attribute catch_qty_to_reassign. Modified Reassign_Handl_Unit and added code to assign a value for catch_qty_to_reassign. 
--  130716  MeAblk   Added new view  SHIPMENT_RESERV_HANDL_UNIT_UIV  for the usage of client Reserved Shipment Lines Attached to Handling Units.
--  130624  MeAblk   Added new methods Get_Sub_Struct_Lot_Batch_No, Get_Sub_Struct_Eng_Chg_Level,  Get_Sub_Struct_Waiv_Dev_Rej_No, Get_Sub_Struct_Serial_No.
--  130620  JeLise   Changed the fetch of qty_on_shipment_ in the second Remove_Or_Modify method. In the first Remove_Or_Modify method 
--  130620           a convertion of shipment_line_handl_unit_qty_ into inventory UoM was added.
--  130619  MaEelk   Removed the parameter mix_of_blocked_attrib_changed from the call to Handling_Unit_API.Check_Allow_Mix.
--  130618  RoJalk   Renamed the method Get_Qty_On_Handling_Unit to Get_Line_Attached_Qty.
--  130618  RoJalk   Modified Reassign_Handl_Unit and changed the condition to NOT release_reservations when creating the HU.
--  130617  MeAblk   Added new method Get_Qty_On_Sub_Structure.
--  130613  RoJalk   Modified Reassign_Handl_Unit and added a info message to indicate if qty is remaining in shipment inventory.
--  130612  MaEelk   Modified Mixed_Cond_Codes_Connected to return the value correctly  when there are no values given to the parameters part_no and condition_code also.
--  130612  MaEelk   Modified Mixed_Lot_Batches_Connected to use tthe method when there are no values given to the parameters part_no and Lot_batch_no also.
--  130610  MeAblk   Added new methods Get_Unique_Serial_No, Get_Unique_Waiv_Dev_Rej_No. 
--  130607  MaEelk   Added methods Mixed_Lot_Batches_Connected and Mixed_Cond_Codes_Connected. This would check if multiple lot batches or condition codes 
--                   exists for a given part respectively. Made a call to Handling_Unit_API.Check_Allow_Mix from Unpack_Check_Insert___
--  130605  RoJalk   Modified Reassign_Handling_Unit and changed the parameter release_reservations_ to be BOOLEAN.
--  130531  RoJalk   Code improvements to the method Reassign_Handl_Unit.
--  130531  RoJalk   Added validations to the method Reassign_Handl_Unit.
--  130522  JeLise   Added call to Shipment_Line_Handl_Unit_API.Get_Quantity in Remove_Or_Modify.
--  130517  JeLise   Added NOCHECK to the reference on CustomerOrderReservation. Added new methods Handling_Unit_Exist and Remove_Handling_Unit.
--  130517  RoJalk   Modified Reassign_Handl_Unit and called New___ only if release_reservations_ = 'FALSE'.
--  130516  RoJalk   Added the parameters qty_picked_, qty_reassigned_ to the method Reassign_Handl_Unit.  
--  130515  RoJalk   Removed the method Modify_Shipment_Id___ and called New___, Remove___ from Reassign_Handl_Unit.
--  130515  RoJalk   Modified  Reassign_Handling_Unit and moved qty related validations to Shipment_Handling_Utility_API.Reassign_Handling_Unit.
--  130513  RoJalk   Modified Reassign_Handl_Unit and added a parameter to Customer_Order_Reservation_API.Reassign_Connected_Qty
--  130513           to indicate reassignment_type_.
--  130511  RoJalk   Added the methods Reassign_Handl_Unit and Modify_Shipment_Id___.
--  130206  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Reserv_Handl_Unit_Rec IS RECORD (
   handling_unit_id        SHIPMENT_RESERV_HANDL_UNIT_TAB.handling_unit_id%TYPE,
   quantity                SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE,
   catch_qty_to_reassign   SHIPMENT_RESERV_HANDL_UNIT_TAB.catch_qty_to_reassign%TYPE);

TYPE Reserv_Handl_Unit_Tab IS TABLE OF Reserv_Handl_Unit_Rec INDEX BY PLS_INTEGER;


TYPE Reserv_Handl_Unit_Qty_Rec IS RECORD (
   handling_unit_id        NUMBER,
   quantity                NUMBER,
   catch_qty_to_reassign   NUMBER );

TYPE Reserv_Handl_Unit_Qty_Tab IS TABLE OF Reserv_Handl_Unit_Qty_Rec INDEX BY PLS_INTEGER;


TYPE Reserv_Handl_Unit_Ext_Rec IS RECORD (
   shipment_line_no        NUMBER,
   source_ref1             VARCHAR2(50),
   source_ref2             VARCHAR2(50),
   source_ref3             VARCHAR2(50),
   source_ref4             VARCHAR2(50),
   source_ref_type         VARCHAR2(20),
   lot_batch_no            VARCHAR2(20),
   serial_no               VARCHAR2(50),
   eng_chg_level           VARCHAR2(6),
   waiv_dev_rej_no         VARCHAR2(15),
   reserv_handling_unit_id NUMBER,
   expiration_date         DATE, 
   activity_seq            NUMBER,
   total_inventory_qty     NUMBER );

TYPE Reserv_Handl_Unit_Ext_Tab IS TABLE OF Reserv_Handl_Unit_Ext_Rec INDEX BY PLS_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Quantity___ (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_          IN NUMBER,
   new_quantity_              IN NUMBER,
   old_quantity_              IN NUMBER,
   new_catch_qty_to_reassign_ IN NUMBER,
   old_catch_qty_to_reassign_ IN NUMBER )
IS
   total_quantity_               NUMBER;
   shipment_line_handl_unit_qty_ NUMBER;
   quantity_to_be_added_         NUMBER;    
   inv_handl_unit_qty_           NUMBER;
   total_catch_qty_to_reassign_  NUMBER;   
   catch_quantity_to_be_added_   NUMBER;
   picked_catch_quantity_        NUMBER;
   shipment_line_rec_            Shipment_Line_API.Public_Rec;
   qty_reserved_                 NUMBER;
   qty_picked_                   NUMBER;
   catch_qty_                    NUMBER;
   total_sales_qty_              NUMBER;
   total_reserved_qty_           NUMBER;
   
   CURSOR get_total_quantity IS
      SELECT NVL(SUM(quantity), 0)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1               = source_ref1_
      AND   source_ref2               = source_ref2_
      AND   source_ref3               = source_ref3_
      AND   source_ref4               = source_ref4_      
      AND   shipment_id               = shipment_id_
      AND   shipment_line_no          = shipment_line_no_
      AND   handling_unit_id          = handling_unit_id_;

   CURSOR get_tot_catch_qty_to_reassign IS
      SELECT NVL(SUM(catch_qty_to_reassign), 0)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1                = source_ref1_
      AND   source_ref2                = source_ref2_
      AND   source_ref3                = source_ref3_
      AND   source_ref4                = source_ref4_       
      AND   contract                   = contract_
      AND   part_no                    = part_no_
      AND   location_no                = location_no_
      AND   lot_batch_no               = lot_batch_no_
      AND   serial_no                  = serial_no_
      AND   eng_chg_level              = eng_chg_level_
      AND   waiv_dev_rej_no            = waiv_dev_rej_no_
      AND   activity_seq               = activity_seq_
      AND   reserv_handling_unit_id    = reserv_handling_unit_id_
      AND   configuration_id           = configuration_id_
      AND   pick_list_no               = pick_list_no_
      AND   shipment_id                = shipment_id_
      AND   shipment_line_no           = shipment_line_no_;
BEGIN
   IF (new_quantity_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'QUANTITY: Qty to Attach must be greater than zero.');
   END IF;
   
   OPEN get_total_quantity;
   FETCH get_total_quantity INTO total_quantity_;
   CLOSE get_total_quantity;
   
   shipment_line_handl_unit_qty_ := Shipment_Line_Handl_Unit_API.Get_Quantity(shipment_id_, 
                                                                              shipment_line_no_, 
                                                                              handling_unit_id_);
   quantity_to_be_added_         := (new_quantity_ - old_quantity_);
   shipment_line_rec_            := Shipment_Line_API.Get(shipment_id_, shipment_line_no_); 
   total_sales_qty_              := (quantity_to_be_added_ + total_quantity_) * shipment_line_rec_.inverted_conv_factor / shipment_line_rec_.conv_factor;
   inv_handl_unit_qty_           := (shipment_line_handl_unit_qty_ * shipment_line_rec_.conv_factor/shipment_line_rec_.inverted_conv_factor);
   
   total_reserved_qty_ := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(shipment_line_rec_.source_ref1,
                                                                               shipment_line_rec_.source_ref2,
                                                                               shipment_line_rec_.source_ref3,
                                                                               shipment_line_rec_.source_ref4,
                                                                               shipment_id_,
                                                                               shipment_line_no_,
                                                                               NULL);
   IF ((total_reserved_qty_ + quantity_to_be_added_ != shipment_line_rec_.qty_assigned) AND (total_sales_qty_ > shipment_line_handl_unit_qty_) AND (quantity_to_be_added_ > 0)) THEN   
      Error_SYS.Record_General(lu_name_, 'QTYTOLARGE: The quantity attached (:P1) cannot exceed the quantity to attach for this reservation line (:P2).', 
                                          (quantity_to_be_added_ + total_quantity_), inv_handl_unit_qty_);
   END IF;

   IF (old_catch_qty_to_reassign_ != new_catch_qty_to_reassign_) THEN
      IF ((Part_Catalog_API.Get_Catch_Unit_Enabled_Db(part_no_) = Fnd_Boolean_API.DB_FALSE) AND (new_catch_qty_to_reassign_ > 0)) THEN
         Error_SYS.Record_General(lu_name_, 'CATCHQTYNOTALLOWED: Only allowed to enter catch quantity for a part that is catch quantity handled.');
      END IF;
   
      Reserve_Shipment_API.Get_Quantity(qty_reserved_          => qty_reserved_,
                                        qty_picked_            => qty_picked_,
                                        catch_qty_picked_      => catch_qty_,
                                        source_ref1_           => source_ref1_,
                                        source_ref2_           => source_ref2_,
                                        source_ref3_           => source_ref3_,
                                        source_ref4_           => source_ref4_,
                                        source_ref_type_db_    => shipment_line_rec_.source_ref_type,
                                        contract_              => contract_,
                                        part_no_               => part_no_,
                                        location_no_           => location_no_,
                                        lot_batch_no_          => lot_batch_no_,
                                        serial_no_             => serial_no_,
                                        eng_chg_level_         => eng_chg_level_,
                                        waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                        activity_seq_          => activity_seq_,
                                        handling_unit_id_      => reserv_handling_unit_id_,
                                        configuration_id_      => configuration_id_,
                                        pick_list_no_          => pick_list_no_,                                                                    
                                        shipment_id_           => shipment_id_);
      IF (NVL(new_catch_qty_to_reassign_, 0) < 0) THEN
         Error_SYS.Record_General(lu_name_, 'CATCHQTYZERO: Catch qty to Attach must be greater than zero.');
      END IF;

      OPEN get_tot_catch_qty_to_reassign;
      FETCH get_tot_catch_qty_to_reassign INTO total_catch_qty_to_reassign_;
      CLOSE get_tot_catch_qty_to_reassign;
   
      catch_quantity_to_be_added_ := (new_catch_qty_to_reassign_ - NVL(old_catch_qty_to_reassign_, 0));
      picked_catch_quantity_      := (catch_qty_ - total_catch_qty_to_reassign_);
      Validate_Catch_Qty(catch_quantity_to_be_added_, total_catch_qty_to_reassign_, catch_qty_, old_catch_qty_to_reassign_, picked_catch_quantity_);
   END IF;
END Check_Quantity___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   Handling_Unit_API.Check_Allow_Mix(newrec_.handling_unit_id);
   
   Shipment_API.Reset_Printed_Flags__(shipment_id_                 => newrec_.shipment_id,
                                      unset_pkg_list_print_        => TRUE,
                                      unset_consignment_print_     => FALSE,
                                      unset_del_note_print_        => FALSE,
                                      unset_pro_forma_print_       => FALSE,
                                      unset_bill_of_lading_print_  => FALSE,
                                      unset_address_label_print_   => FALSE );
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_               IN     VARCHAR2,
   oldrec_              IN     shipment_reserv_handl_unit_tab%ROWTYPE,
   newrec_              IN OUT shipment_reserv_handl_unit_tab%ROWTYPE,
   attr_                IN OUT VARCHAR2,
   objversion_          IN OUT VARCHAR2,
   by_keys_             IN BOOLEAN DEFAULT FALSE,
   unpack_in_ship_inv_  IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (newrec_.quantity < oldrec_.quantity AND unpack_in_ship_inv_) THEN
      Unpack_From_HU_On_Shipment___(oldrec_  => oldrec_, newrec_  => newrec_);
   END IF;
   
   IF (newrec_.quantity != oldrec_.quantity ) THEN
      Shipment_API.Reset_Printed_Flags__(shipment_id_                 => newrec_.shipment_id,
                                         unset_pkg_list_print_        => TRUE,
                                         unset_consignment_print_     => FALSE,
                                         unset_del_note_print_        => FALSE,
                                         unset_pro_forma_print_       => FALSE,
                                         unset_bill_of_lading_print_  => FALSE,
                                         unset_address_label_print_   => FALSE );
   END IF; 
   
END Update___;


@Override
PROCEDURE Delete___ (
   objid_               IN VARCHAR2,
   remrec_              IN shipment_reserv_handl_unit_tab%ROWTYPE,
   unpack_in_ship_inv_  IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(objid_, remrec_);
   
   IF (unpack_in_ship_inv_) THEN
      Unpack_From_HU_On_Shipment___(remrec_);
   END IF;
   
   Shipment_API.Reset_Printed_Flags__(shipment_id_                 => remrec_.shipment_id,
                                      unset_pkg_list_print_        => TRUE,
                                      unset_consignment_print_     => FALSE,
                                      unset_del_note_print_        => FALSE,
                                      unset_pro_forma_print_       => FALSE,
                                      unset_bill_of_lading_print_  => FALSE,
                                      unset_address_label_print_   => FALSE );
END Delete___;


PROCEDURE New___ (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,    
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		  IN NUMBER,
   quantity_                  IN NUMBER,
   catch_qty_to_reassign_     IN NUMBER )
IS
   newrec_     SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
BEGIN
   newrec_.source_ref1             := source_ref1_;
   newrec_.source_ref2             := source_ref2_;
   newrec_.source_ref3             := source_ref3_;
   newrec_.source_ref4             := source_ref4_;
   newrec_.contract                := contract_;
   newrec_.part_no                 := part_no_;
   newrec_.location_no             := location_no_;
   newrec_.lot_batch_no            := lot_batch_no_;
   newrec_.serial_no               := serial_no_;
   newrec_.eng_chg_level           := eng_chg_level_;
   newrec_.waiv_dev_rej_no         := waiv_dev_rej_no_;
   newrec_.activity_seq            := activity_seq_;
   newrec_.reserv_handling_unit_id := reserv_handling_unit_id_;
   newrec_.configuration_id        := configuration_id_;
   newrec_.pick_list_no            := pick_list_no_;
   newrec_.shipment_id             := shipment_id_;
   newrec_.shipment_line_no        := shipment_line_no_;
   newrec_.handling_unit_id        := handling_unit_id_;
   newrec_.quantity                := quantity_;
   newrec_.catch_qty_to_reassign   := catch_qty_to_reassign_;

   New___(newrec_);
END New___;


PROCEDURE Modify___ (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		  IN NUMBER,
   quantity_                  IN NUMBER,
   catch_qty_to_reassign_     IN NUMBER )
IS
   newrec_     SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(source_ref1_,
                              source_ref2_,
                              source_ref3_,
                              source_ref4_,                               
                              contract_,
                              part_no_,
                              location_no_,
                              lot_batch_no_,
                              serial_no_,
                              eng_chg_level_,
                              waiv_dev_rej_no_,
                              activity_seq_,
                              reserv_handling_unit_id_,
                              configuration_id_,
                              pick_list_no_,
                              shipment_id_,
                              shipment_line_no_,
                              handling_unit_id_);
                              
   newrec_.quantity := quantity_;
   IF catch_qty_to_reassign_ IS NOT NULL THEN
      newrec_.catch_qty_to_reassign := catch_qty_to_reassign_;
   END IF;
   Modify___(newrec_); 
END Modify___;


PROCEDURE Remove___ (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		  IN NUMBER )
IS
   remrec_     SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(source_ref1_,
                              source_ref2_,
                              source_ref3_,
                              source_ref4_,                             
                              contract_,
                              part_no_,
                              location_no_,
                              lot_batch_no_,
                              serial_no_,
                              eng_chg_level_,
                              waiv_dev_rej_no_,
                              activity_seq_,
                              reserv_handling_unit_id_,
                              configuration_id_,
                              pick_list_no_,
                              shipment_id_,
                              shipment_line_no_,
                              handling_unit_id_);
   Remove___(remrec_);                           
END Remove___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_reserv_handl_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                VARCHAR2(30);
   value_               VARCHAR2(4000);
   shipment_line_rec_   Shipment_Line_API.Public_Rec;
BEGIN
   super(newrec_, indrec_, attr_);
   
   shipment_line_rec_ := Shipment_Line_API.Get(newrec_.shipment_id, newrec_.shipment_line_no);
   IF (NOT((shipment_line_rec_.shipment_line_no = newrec_.shipment_line_no)
            AND (NVL(shipment_line_rec_.source_ref1, '*') = newrec_.source_ref1)
            AND (NVL(shipment_line_rec_.source_ref2, '*') = newrec_.source_ref2) 
            AND (NVL(shipment_line_rec_.source_ref3, '*') = newrec_.source_ref3) 
            AND (NVL(shipment_line_rec_.source_ref4, '*') = newrec_.source_ref4))) THEN
      Error_SYS.Record_General(lu_name_, 'DIFORDREFINHU: Source references of the connected handling unit and the reservation are not the same.');
   END IF;
   
   Check_Quantity___(source_ref1_               => newrec_.source_ref1, 
                     source_ref2_               => newrec_.source_ref2, 
                     source_ref3_               => newrec_.source_ref3, 
                     source_ref4_               => newrec_.source_ref4,                      
                     contract_                  => newrec_.contract,
                     part_no_                   => newrec_.part_no,
                     location_no_               => newrec_.location_no,
                     lot_batch_no_              => newrec_.lot_batch_no,
                     serial_no_                 => newrec_.serial_no,
                     eng_chg_level_             => newrec_.eng_chg_level,
                     waiv_dev_rej_no_           => newrec_.waiv_dev_rej_no,
                     activity_seq_              => newrec_.activity_seq,
                     reserv_handling_unit_id_   => newrec_.reserv_handling_unit_id, 
                     configuration_id_          => newrec_.configuration_id,
                     pick_list_no_              => newrec_.pick_list_no,
                     shipment_id_               => newrec_.shipment_id, 
                     shipment_line_no_          => newrec_.shipment_line_no,
                     handling_unit_id_          => newrec_.handling_unit_id, 
                     new_quantity_              => newrec_.quantity, 
                     old_quantity_              => 0,
                     new_catch_qty_to_reassign_ => NVL(newrec_.catch_qty_to_reassign, 0),
                     old_catch_qty_to_reassign_ => 0);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     shipment_reserv_handl_unit_tab%ROWTYPE,
   newrec_ IN OUT shipment_reserv_handl_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   Check_Quantity___(source_ref1_               => newrec_.source_ref1, 
                     source_ref2_               => newrec_.source_ref2, 
                     source_ref3_               => newrec_.source_ref3, 
                     source_ref4_               => newrec_.source_ref4,                       
                     contract_                  => newrec_.contract,
                     part_no_                   => newrec_.part_no,
                     location_no_               => newrec_.location_no,
                     lot_batch_no_              => newrec_.lot_batch_no,
                     serial_no_                 => newrec_.serial_no,
                     eng_chg_level_             => newrec_.eng_chg_level,
                     waiv_dev_rej_no_           => newrec_.waiv_dev_rej_no,
                     activity_seq_              => newrec_.activity_seq,
                     reserv_handling_unit_id_   => newrec_.reserv_handling_unit_id, 
                     configuration_id_          => newrec_.configuration_id,
                     pick_list_no_              => newrec_.pick_list_no,
                     shipment_id_               => newrec_.shipment_id, 
                     shipment_line_no_          => newrec_.shipment_line_no,
                     handling_unit_id_          => newrec_.handling_unit_id, 
                     new_quantity_              => newrec_.quantity, 
                     old_quantity_              => oldrec_.quantity,
                     new_catch_qty_to_reassign_ => NVL(newrec_.catch_qty_to_reassign, 0),
                     old_catch_qty_to_reassign_ => NVL(oldrec_.catch_qty_to_reassign, 0));
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     shipment_reserv_handl_unit_tab%ROWTYPE,
   newrec_ IN OUT shipment_reserv_handl_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN      
   super(oldrec_, newrec_, indrec_, attr_);  
   Validate_Reservation_Exist___(oldrec_, newrec_, indrec_);
END Check_Common___;


PROCEDURE Validate_Reservation_Exist___ (
   oldrec_ IN     shipment_reserv_handl_unit_tab%ROWTYPE,
   newrec_ IN OUT shipment_reserv_handl_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec)
IS
   source_ref_type_db_  VARCHAR2(20);
BEGIN
   source_ref_type_db_ := Shipment_Line_API.Get_Source_Ref_Type_Db(newrec_.shipment_id, newrec_.shipment_line_no);
   IF (newrec_.source_ref1 IS NOT NULL AND newrec_.source_ref2 IS NOT NULL AND newrec_.source_ref3 IS NOT NULL AND newrec_.source_ref4 IS NOT NULL AND newrec_.contract IS NOT NULL AND newrec_.part_no IS NOT NULL AND newrec_.location_no IS NOT NULL AND newrec_.lot_batch_no IS NOT NULL AND newrec_.serial_no IS NOT NULL AND newrec_.eng_chg_level IS NOT NULL AND newrec_.waiv_dev_rej_no IS NOT NULL AND newrec_.activity_seq IS NOT NULL AND newrec_.reserv_handling_unit_id IS NOT NULL AND newrec_.configuration_id IS NOT NULL AND newrec_.pick_list_no IS NOT NULL AND newrec_.shipment_id IS NOT NULL)
      AND (indrec_.source_ref1 OR indrec_.source_ref2 OR indrec_.source_ref3 OR indrec_.source_ref4 OR indrec_.contract OR indrec_.part_no OR indrec_.location_no OR indrec_.lot_batch_no OR indrec_.serial_no OR indrec_.eng_chg_level OR indrec_.waiv_dev_rej_no OR indrec_.activity_seq OR indrec_.reserv_handling_unit_id OR indrec_.configuration_id OR indrec_.pick_list_no OR indrec_.shipment_id)
      AND (Validate_SYS.Is_Changed(oldrec_.source_ref1, newrec_.source_ref1)
        OR Validate_SYS.Is_Changed(oldrec_.source_ref2, newrec_.source_ref2)
        OR Validate_SYS.Is_Changed(oldrec_.source_ref3, newrec_.source_ref3)
        OR Validate_SYS.Is_Changed(oldrec_.source_ref4, newrec_.source_ref4)
        OR Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract)
        OR Validate_SYS.Is_Changed(oldrec_.part_no, newrec_.part_no)
        OR Validate_SYS.Is_Changed(oldrec_.location_no, newrec_.location_no)
        OR Validate_SYS.Is_Changed(oldrec_.lot_batch_no, newrec_.lot_batch_no)
        OR Validate_SYS.Is_Changed(oldrec_.serial_no, newrec_.serial_no)
        OR Validate_SYS.Is_Changed(oldrec_.eng_chg_level, newrec_.eng_chg_level)
        OR Validate_SYS.Is_Changed(oldrec_.waiv_dev_rej_no, newrec_.waiv_dev_rej_no)
        OR Validate_SYS.Is_Changed(oldrec_.activity_seq, newrec_.activity_seq)
        OR Validate_SYS.Is_Changed(oldrec_.reserv_handling_unit_id, newrec_.reserv_handling_unit_id)   
        OR Validate_SYS.Is_Changed(oldrec_.configuration_id, newrec_.configuration_id)
        OR Validate_SYS.Is_Changed(oldrec_.pick_list_no, newrec_.pick_list_no)
        OR Validate_SYS.Is_Changed(oldrec_.shipment_id, newrec_.shipment_id)) THEN
      Reserve_Shipment_API.Reservation_Exist(newrec_.contract, newrec_.part_no, newrec_.configuration_id, newrec_.location_no, newrec_.lot_batch_no, newrec_.serial_no, newrec_.eng_chg_level, newrec_.waiv_dev_rej_no, newrec_.activity_seq, newrec_.reserv_handling_unit_id, newrec_.source_ref1, newrec_.source_ref2, newrec_.source_ref3, newrec_.source_ref4, source_ref_type_db_, newrec_.pick_list_no, newrec_.shipment_id);
   END IF;
END Validate_Reservation_Exist___;


PROCEDURE Repack_Into_HU_On_Shipment___(
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,  
   source_ref_type_db_        IN VARCHAR2,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   from_handling_unit_id_     IN NUMBER,
   to_handling_unit_id_       IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   qty_to_repack_             IN NUMBER,
   catch_qty_to_repack_       IN NUMBER,
   move_to_ship_location_     IN VARCHAR2 DEFAULT 'FALSE')
IS
   inv_trans_source_ref_type_db_ VARCHAR2(50);
   handling_unit_rec_            Handling_Unit_API.Public_Rec;
   source_ref_demand_code_       VARCHAR2(20);
BEGIN
   handling_unit_rec_ := Handling_Unit_API.Get(to_handling_unit_id_);
   IF (NVL(handling_unit_rec_.contract, contract_) != contract_ OR
       NVL(handling_unit_rec_.location_no, location_no_) != location_no_) THEN
      Error_SYS.Record_General(lu_name_, 'PACKDIFFLOC: Parts can not be packed into a Handling Unit on another location.');
   END IF; 
   
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
      source_ref_demand_code_ := Shipment_Source_Utility_API.Get_Demand_Code_Db(source_ref1_        => source_ref1_, 
                                                                                source_ref2_        => source_ref2_, 
                                                                                source_ref3_        => source_ref3_, 
                                                                                source_ref4_        => source_ref4_, 
                                                                                source_ref_type_db_ => source_ref_type_db_ );
   END IF;             

   
   -- As an optimization to change the reservations as few times as possible when picking to shipment inventory (move_to_ship_location = 'TRUE'), 
   -- we unreserve everything at once when picking (in Shipment_Handling_Utility_API.Move_To_Shipment_Location) and don't need to unreserve here.
   IF (move_to_ship_location_ = 'FALSE') THEN
      Reserve_Shipment_API.Reserve_As_Picked(source_ref1_            => source_ref1_, 
                                             source_ref2_            => source_ref2_, 
                                             source_ref3_            => source_ref3_, 
                                             source_ref4_            => source_ref4_, 
                                             source_ref_type_db_     => source_ref_type_db_, 
                                             contract_               => contract_, 
                                             part_no_                => part_no_, 
                                             location_no_            => location_no_, 
                                             lot_batch_no_           => lot_batch_no_, 
                                             serial_no_              => serial_no_, 
                                             eng_chg_level_          => eng_chg_level_, 
                                             waiv_dev_rej_no_        => waiv_dev_rej_no_, 
                                             activity_seq_           => activity_seq_, 
                                             handling_unit_id_       => from_handling_unit_id_, 
                                             configuration_id_       => configuration_id_, 
                                             pick_list_no_           => pick_list_no_, 
                                             shipment_id_            => shipment_id_, 
                                             qty_to_reserve_         => -qty_to_repack_, 
                                             catch_qty_to_reserve_   => -catch_qty_to_repack_,
                                             move_to_ship_location_  => move_to_ship_location_,
                                             source_ref_demand_code_ => source_ref_demand_code_);
   END IF;

   inv_trans_source_ref_type_db_ := Handle_Ship_Invent_Utility_API.Get_Inv_Trans_Src_Ref_Type_Db(source_ref_type_db_);
   Inventory_Part_In_Stock_API.Change_Handling_Unit_Id(contract_                       => contract_, 
                                                       part_no_                        => part_no_, 
                                                       configuration_id_               => configuration_id_, 
                                                       location_no_                    => location_no_, 
                                                       lot_batch_no_                   => lot_batch_no_, 
                                                       serial_no_                      => serial_no_, 
                                                       eng_chg_level_                  => eng_chg_level_, 
                                                       waiv_dev_rej_no_                => waiv_dev_rej_no_, 
                                                       activity_seq_                   => activity_seq_, 
                                                       old_handling_unit_id_           => from_handling_unit_id_,
                                                       new_handling_unit_id_           => to_handling_unit_id_,
                                                       quantity_                       => qty_to_repack_, 
                                                       catch_quantity_                 => catch_qty_to_repack_,
                                                       source_ref1_                    => source_ref1_, 
                                                       source_ref2_                    => Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_   ),
                                                       source_ref3_                    => Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3),
                                                       source_ref4_                    => Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4),
                                                       inv_trans_source_ref_type_db_   => inv_trans_source_ref_type_db_,
                                                       discon_zero_stock_handl_unit_   => FALSE,
                                                       source_ref_demand_code_         => source_ref_demand_code_);

   
   Reserve_Shipment_API.Reserve_As_Picked(source_ref1_             => source_ref1_, 
                                          source_ref2_             => source_ref2_, 
                                          source_ref3_             => source_ref3_, 
                                          source_ref4_             => source_ref4_, 
                                          source_ref_type_db_      => source_ref_type_db_, 
                                          contract_                => contract_, 
                                          part_no_                 => part_no_, 
                                          location_no_             => location_no_, 
                                          lot_batch_no_            => lot_batch_no_, 
                                          serial_no_               => serial_no_, 
                                          eng_chg_level_           => eng_chg_level_, 
                                          waiv_dev_rej_no_         => waiv_dev_rej_no_, 
                                          activity_seq_            => activity_seq_, 
                                          handling_unit_id_        => to_handling_unit_id_, 
                                          configuration_id_        => configuration_id_, 
                                          pick_list_no_            => pick_list_no_, 
                                          shipment_id_             => shipment_id_, 
                                          qty_to_reserve_          => qty_to_repack_, 
                                          catch_qty_to_reserve_    => catch_qty_to_repack_, 
                                          move_to_ship_location_   => move_to_ship_location_,
                                          source_ref_demand_code_  => source_ref_demand_code_);
                                          
END Repack_Into_HU_On_Shipment___;


PROCEDURE Unpack_From_HU_On_Shipment___(
   oldrec_                    SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE,
   newrec_                    SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE DEFAULT NULL )
IS
   public_reservation_rec_       Reserve_Shipment_API.Public_Reservation_Rec;
   reservation_already_modified_ BOOLEAN;
   is_in_shipment_inventory_     BOOLEAN;
   has_same_handling_unit_ids_   BOOLEAN;
   inv_trans_source_ref_type_db_ VARCHAR2(50);
   quantity_to_unpack_           NUMBER;
   catch_quantity_to_unpack_     NUMBER;
   source_ref_type_db_           VARCHAR2(30);
   source_ref_demand_code_       VARCHAR2(20);
BEGIN
   is_in_shipment_inventory_     := Inventory_Location_API.Get_Location_Type_Db(oldrec_.contract, oldrec_.location_no) = Inventory_Location_Type_API.DB_SHIPMENT;
   has_same_handling_unit_ids_   := oldrec_.reserv_handling_unit_id != 0 AND oldrec_.reserv_handling_unit_id = oldrec_.handling_unit_id;
   
   IF (is_in_shipment_inventory_ AND has_same_handling_unit_ids_) THEN
      quantity_to_unpack_        := oldrec_.quantity - NVL(newrec_.quantity, 0);
      catch_quantity_to_unpack_  := oldrec_.catch_qty_to_reassign - NVL(newrec_.catch_qty_to_reassign, 0);
      source_ref_type_db_        := Shipment_Line_API.Get_Source_Ref_Type_Db(oldrec_.shipment_id, oldrec_.shipment_line_no);
      IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN
         source_ref_demand_code_ := Shipment_Source_Utility_API.Get_Demand_Code_Db(source_ref1_        => oldrec_.source_ref1, 
                                                                                   source_ref2_        => oldrec_.source_ref2, 
                                                                                   source_ref3_        => oldrec_.source_ref3, 
                                                                                   source_ref4_        => oldrec_.source_ref4, 
                                                                                   source_ref_type_db_ => source_ref_type_db_ );
      END IF;             
      
      IF (Reserve_Shipment_API.Reservation_Exists(source_ref1_            => oldrec_.source_ref1, 
                                                  source_ref2_            => oldrec_.source_ref2, 
                                                  source_ref3_            => oldrec_.source_ref3, 
                                                  source_ref4_            => oldrec_.source_ref4, 
                                                  source_ref_type_db_     => source_ref_type_db_, 
                                                  contract_               => oldrec_.contract, 
                                                  part_no_                => oldrec_.part_no, 
                                                  location_no_            => oldrec_.location_no, 
                                                  lot_batch_no_           => oldrec_.lot_batch_no, 
                                                  serial_no_              => oldrec_.serial_no, 
                                                  eng_chg_level_          => oldrec_.eng_chg_level, 
                                                  waiv_dev_rej_no_        => oldrec_.waiv_dev_rej_no, 
                                                  activity_seq_           => oldrec_.activity_seq, 
                                                  handling_unit_id_       => oldrec_.handling_unit_id, 
                                                  configuration_id_       => oldrec_.configuration_id, 
                                                  pick_list_no_           => oldrec_.pick_list_no, 
                                                  shipment_id_            => oldrec_.shipment_id) = 'TRUE') THEN
                                                         
         public_reservation_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_            => oldrec_.source_ref1, 
                                                                                     source_ref2_            => oldrec_.source_ref2, 
                                                                                     source_ref3_            => oldrec_.source_ref3, 
                                                                                     source_ref4_            => oldrec_.source_ref4, 
                                                                                     source_ref_type_db_     => source_ref_type_db_,        
                                                                                     contract_               => oldrec_.contract, 
                                                                                     part_no_                => oldrec_.part_no, 
                                                                                     location_no_            => oldrec_.location_no, 
                                                                                     lot_batch_no_           => oldrec_.lot_batch_no,      
                                                                                     serial_no_              => oldrec_.serial_no, 
                                                                                     eng_chg_level_          => oldrec_.eng_chg_level, 
                                                                                     waiv_dev_rej_no_        => oldrec_.waiv_dev_rej_no, 
                                                                                     activity_seq_           => oldrec_.activity_seq, 
                                                                                     handling_unit_id_       => oldrec_.handling_unit_id,        
                                                                                     pick_list_no_           => oldrec_.pick_list_no, 
                                                                                     configuration_id_       => oldrec_.configuration_id, 
                                                                                     shipment_id_            => oldrec_.shipment_id);
      END IF;


      Inventory_Event_Manager_API.Start_Session;
      
      -- If the reservation already has been reduced before the ShipmentReservHandlUnit-record we don't need to
      -- modify the reservation.

      reservation_already_modified_ := NVL(public_reservation_rec_.qty_assigned, 0) < NVL(oldrec_.quantity, 0);
      
      IF (NOT reservation_already_modified_) THEN
         Reserve_Shipment_API.Reserve_As_Picked(source_ref1_            => oldrec_.source_ref1, 
                                                source_ref2_            => oldrec_.source_ref2, 
                                                source_ref3_            => oldrec_.source_ref3, 
                                                source_ref4_            => oldrec_.source_ref4, 
                                                source_ref_type_db_     => source_ref_type_db_, 
                                                contract_               => oldrec_.contract, 
                                                part_no_                => oldrec_.part_no, 
                                                location_no_            => oldrec_.location_no, 
                                                lot_batch_no_           => oldrec_.lot_batch_no, 
                                                serial_no_              => oldrec_.serial_no, 
                                                eng_chg_level_          => oldrec_.eng_chg_level, 
                                                waiv_dev_rej_no_        => oldrec_.waiv_dev_rej_no, 
                                                activity_seq_           => oldrec_.activity_seq, 
                                                handling_unit_id_       => oldrec_.handling_unit_id, 
                                                configuration_id_       => oldrec_.configuration_id, 
                                                pick_list_no_           => oldrec_.pick_list_no, 
                                                shipment_id_            => oldrec_.shipment_id, 
                                                qty_to_reserve_         => -quantity_to_unpack_, 
                                                catch_qty_to_reserve_   => -catch_quantity_to_unpack_,
                                                source_ref_demand_code_ => source_ref_demand_code_);
      END IF;

      inv_trans_source_ref_type_db_ := Handle_Ship_Invent_Utility_API.Get_Inv_Trans_Src_Ref_Type_Db(source_ref_type_db_);
      Inventory_Part_In_Stock_API.Change_Handling_Unit_Id(contract_                       => oldrec_.contract, 
                                                          part_no_                        => oldrec_.part_no, 
                                                          configuration_id_               => oldrec_.configuration_id, 
                                                          location_no_                    => oldrec_.location_no, 
                                                          lot_batch_no_                   => oldrec_.lot_batch_no, 
                                                          serial_no_                      => oldrec_.serial_no, 
                                                          eng_chg_level_                  => oldrec_.eng_chg_level, 
                                                          waiv_dev_rej_no_                => oldrec_.waiv_dev_rej_no, 
                                                          activity_seq_                   => oldrec_.activity_seq, 
                                                          old_handling_unit_id_           => oldrec_.handling_unit_id,
                                                          new_handling_unit_id_           => 0,
                                                          quantity_                       => quantity_to_unpack_, 
                                                          catch_quantity_                 => catch_quantity_to_unpack_,
                                                          source_ref1_                    => oldrec_.source_ref1, 
                                                          source_ref2_                    => Shipment_Line_API.Get_Converted_Source_Ref(oldrec_.source_ref2, source_ref_type_db_  ),
                                                          source_ref3_                    => Shipment_Line_API.Get_Converted_Source_Ref(oldrec_.source_ref3, source_ref_type_db_, 3),
                                                          source_ref4_                    => Shipment_Line_API.Get_Converted_Source_Ref(oldrec_.source_ref4, source_ref_type_db_, 4),
                                                          inv_trans_source_ref_type_db_   => inv_trans_source_ref_type_db_,
                                                          discon_zero_stock_handl_unit_   => FALSE,
                                                          source_ref_demand_code_         => source_ref_demand_code_);

      IF (NOT reservation_already_modified_) THEN
         Reserve_Shipment_API.Reserve_As_Picked(source_ref1_             => oldrec_.source_ref1, 
                                                source_ref2_             => oldrec_.source_ref2, 
                                                source_ref3_             => oldrec_.source_ref3, 
                                                source_ref4_             => oldrec_.source_ref4, 
                                                source_ref_type_db_      => source_ref_type_db_, 
                                                contract_                => oldrec_.contract, 
                                                part_no_                 => oldrec_.part_no, 
                                                location_no_             => oldrec_.location_no, 
                                                lot_batch_no_            => oldrec_.lot_batch_no, 
                                                serial_no_               => oldrec_.serial_no, 
                                                eng_chg_level_           => oldrec_.eng_chg_level, 
                                                waiv_dev_rej_no_         => oldrec_.waiv_dev_rej_no, 
                                                activity_seq_            => oldrec_.activity_seq, 
                                                handling_unit_id_        => 0, 
                                                configuration_id_        => oldrec_.configuration_id, 
                                                pick_list_no_            => oldrec_.pick_list_no, 
                                                shipment_id_             => oldrec_.shipment_id, 
                                                qty_to_reserve_          => quantity_to_unpack_, 
                                                catch_qty_to_reserve_    => catch_quantity_to_unpack_,
                                                source_ref_demand_code_  => source_ref_demand_code_);
      END IF;
      
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Unpack_From_HU_On_Shipment___;


PROCEDURE Raise_Line_Removed_Warning___ (
   new_quantity_    IN NUMBER,
   qty_on_shipment_ IN NUMBER,
   uom_             IN VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_Warning(lu_name_, 'REMOVELINES: The qty reserved (:P1 :P2) for this shipment line is less than what is currently attached to different handling units (:P3 :P2). The reserved shipment lines attached to handling units will be removed and will need to be reattached.', 
                          new_quantity_, uom_, qty_on_shipment_);
END Raise_Line_Removed_Warning___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- This method is a custom delete method used by the ShipmentLineHandlUnit-reference and collects all ShipmentReservHandlUnit removals within one InventoryEventId
-- preventing multiple generations of snapshots.
PROCEDURE Do_Remove__ (
   shipment_id_         IN NUMBER,
   shipment_line_no_    IN NUMBER,
   handling_unit_id_    IN NUMBER )
IS
   CURSOR get_rec IS
      SELECT *
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE shipment_id      = shipment_id_
         AND shipment_line_no = shipment_line_no_
         AND handling_unit_id = handling_unit_id_;
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR remrec_ IN get_rec LOOP
      Delete___(NULL, remrec_);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END;

-- This method will attach reservations to handling units that belong to a specific shipment line on a shipment.
-- It will try to consume reservations belonging to the shipment line and match the attached shipment line quantity on the handling unit
-- passed in the CLOB parameter.
PROCEDURE Distribute_Reservations__(
  message_ IN CLOB)
IS
   i_                          NUMBER;
   hu_ptr_                     NUMBER;
   res_ptr_                    NUMBER;
   qty_to_attach_              NUMBER;
   shipment_id_                NUMBER;
   shipment_line_no_           NUMBER;
   count_                      NUMBER;
   name_arr_                   Message_SYS.name_table_clob;
   value_arr_                  Message_SYS.line_table_clob;
   row_                        PLS_INTEGER := 0;
   ship_line_rec_              Shipment_Line_API.Public_Rec;

   TYPE Ship_HU_To_Attach_Tab IS TABLE OF Shipment_Line_Handl_Unit_API.Public_Rec
                                 INDEX BY PLS_INTEGER;
   ship_hu_to_attach_tab_ Ship_HU_To_Attach_Tab;
   
   TYPE Shipment_Lines_No_Tab IS TABLE OF NUMBER
                                 INDEX BY PLS_INTEGER;
                      
   distinct_shipment_lines_ Shipment_Lines_No_Tab;      
   
   CURSOR get_reservations(source_ref1_        VARCHAR2,
                           source_ref2_        VARCHAR2,
                           source_ref3_        VARCHAR2,
                           source_ref4_        VARCHAR2,
                           source_ref_type_db_ VARCHAR2,
                           shipment_id_        NUMBER) IS
      SELECT source_ref1,
             source_ref2, 
             source_ref3,
             source_ref4, 
             contract, 
             part_no, 
             location_no, 
             lot_batch_no, 
             serial_no, 
             eng_chg_level, 
             waiv_dev_rej_no, 
             activity_seq, 
             handling_unit_id, 
             configuration_id, 
             pick_list_no, 
             shipment_id, 
             (qty_assigned - NVL(Shipment_Reserv_Handl_Unit_API.Get_Quantity_On_Shipment(SOURCE_REF1, NVL(SOURCE_REF2,'*'), NVL(SOURCE_REF3,'*'), NVL(SOURCE_REF4,'*'), SOURCE_REF_TYPE_DB, CONTRACT, PART_NO, LOCATION_NO,LOT_BATCH_NO, SERIAL_NO, ENG_CHG_LEVEL, WAIV_DEV_REJ_NO, ACTIVITY_SEQ, HANDLING_UNIT_ID, CONFIGURATION_ID, PICK_LIST_NO, SHIPMENT_ID), 0)) qty_to_attach
      FROM   Shipment_Source_Reservation
      WHERE  NVL(source_ref1,'*') = NVL(source_ref1_ ,'*')
      AND    NVL(source_ref2,'*') = NVL(source_ref2_ ,'*') 
      AND    NVL(source_ref3,'*') = NVL(source_ref3_ ,'*') 
      AND    NVL(source_ref4,'*') = NVL(source_ref4_ ,'*') 
      AND    source_ref_type_db   = source_ref_type_db_ 
      AND    shipment_id          = shipment_id_;

      TYPE Reservation_Tab  IS TABLE OF get_reservations%ROWTYPE 
                            INDEX BY PLS_INTEGER;
      reservation_tab_  Reservation_Tab;
BEGIN
   Message_SYS.Get_Clob_Attributes(message_, count_, name_arr_, value_arr_); 
   -- Get the selected unattached reservations from the CLOB
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'HANDLING_UNIT_ID') THEN
         row_ := row_ + 1;
         ship_hu_to_attach_tab_(row_).handling_unit_id := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'QUANTITY') THEN
         ship_hu_to_attach_tab_(row_).quantity := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
      ELSIF (name_arr_(n_) = 'SHIPMENT_ID') THEN
         shipment_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         ship_hu_to_attach_tab_(row_).shipment_id := shipment_id_;
      ELSIF (name_arr_(n_) = 'SHIPMENT_LINE_NO') THEN
         shipment_line_no_ := Client_SYS.Attr_Value_To_Number(value_arr_(n_));
         ship_hu_to_attach_tab_(row_).shipment_line_no := shipment_line_no_;

         IF NOT distinct_shipment_lines_.EXISTS(shipment_line_no_) THEN
            distinct_shipment_lines_(shipment_line_no_) := shipment_line_no_;
         END IF;
      END IF;
   END LOOP;

   -- Get first element of array
   i_ := distinct_shipment_lines_.FIRST;  
   WHILE i_ IS NOT NULL LOOP
      -- Set iterators to start index
      hu_ptr_  := 1;
      res_ptr_ := 1;

      ship_line_rec_ := Shipment_Line_API.Get(shipment_id_, distinct_shipment_lines_(i_));
      -- Get the reservations for each shipment line
      OPEN get_reservations(ship_line_rec_.source_ref1,
                            ship_line_rec_.source_ref2,
                            ship_line_rec_.source_ref3, 
                            ship_line_rec_.source_ref4, 
                            ship_line_rec_.source_ref_type, 
                            ship_line_rec_.shipment_id);
      FETCH get_reservations BULK COLLECT INTO reservation_tab_;
      CLOSE get_reservations;

      -- Check if there is any reservations to consume for this shipment line.
      IF reservation_tab_.COUNT > 0 THEN
         -- Loop through the handling units

         -- Catch enabled parts need to be manually attached
         IF Part_Catalog_API.Get_Catch_Unit_Enabled_Db(reservation_tab_(res_ptr_).part_no) = Fnd_Boolean_API.DB_TRUE THEN
            Error_SYS.Appl_General(lu_name_, 'CATCHUNITDISTR: Part :P1 is catch unit enabled and needs to be manually attached.', reservation_tab_(res_ptr_).part_no);
         END IF;

         WHILE ship_hu_to_attach_tab_.COUNT >= hu_ptr_ LOOP
            -- Check if the handling unit has any quantity left to attach for this line, and for the current shipment line
            IF ship_hu_to_attach_tab_(hu_ptr_).quantity > 0 AND ship_hu_to_attach_tab_(hu_ptr_).shipment_id = ship_line_rec_.shipment_id AND
               ship_hu_to_attach_tab_(hu_ptr_).shipment_line_no = ship_line_rec_.shipment_line_no THEN
               -- Attach the full quantity for the handling or what is left of the reservation
               qty_to_attach_ := LEAST(reservation_tab_(res_ptr_).qty_to_attach, ship_hu_to_attach_tab_(hu_ptr_).quantity);

               -- If nothing is to attach, the reservation is already consumed.
               IF qty_to_attach_ > 0 THEN

                  New_Or_Add_To_Existing(reservation_tab_(res_ptr_).source_ref1, 
                                         reservation_tab_(res_ptr_).source_ref2, 
                                         reservation_tab_(res_ptr_).source_ref3, 
                                         reservation_tab_(res_ptr_).source_ref4, 
                                         reservation_tab_(res_ptr_).contract, 
                                         reservation_tab_(res_ptr_).part_no, 
                                         reservation_tab_(res_ptr_).location_no, 
                                         reservation_tab_(res_ptr_).lot_batch_no, 
                                         reservation_tab_(res_ptr_).serial_no, 
                                         reservation_tab_(res_ptr_).eng_chg_level, 
                                         reservation_tab_(res_ptr_).waiv_dev_rej_no, 
                                         reservation_tab_(res_ptr_).activity_seq, 
                                         reservation_tab_(res_ptr_).handling_unit_id, 
                                         reservation_tab_(res_ptr_).configuration_id, 
                                         reservation_tab_(res_ptr_).pick_list_no, 
                                         ship_hu_to_attach_tab_(hu_ptr_).shipment_id, 
                                         ship_hu_to_attach_tab_(hu_ptr_).shipment_line_no, 
                                         ship_hu_to_attach_tab_(hu_ptr_).handling_unit_id, 
                                         qty_to_attach_, 
                                         NULL);

                  reservation_tab_(res_ptr_).qty_to_attach := reservation_tab_(res_ptr_).qty_to_attach - qty_to_attach_;
                  ship_hu_to_attach_tab_(hu_ptr_).quantity := ship_hu_to_attach_tab_(hu_ptr_).quantity - qty_to_attach_;
               END IF;
               -- Either the reservation got consumed, or was already consumed. Move the res_ptr_ to next index
               IF reservation_tab_(res_ptr_).qty_to_attach <= 0 THEN
                  res_ptr_ := res_ptr_ + 1;
                  EXIT WHEN res_ptr_ > reservation_tab_.COUNT;
               END IF;
            ELSE
               -- There was nothing to attach/could not attach anything. Get next handling unit
               hu_ptr_ := hu_ptr_ + 1;
            END IF;
         END LOOP;
      END IF;
      -- Get next element of array
      i_ := distinct_shipment_lines_.NEXT(i_);  
   END LOOP;
END Distribute_Reservations__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Handling_Units (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,    
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		   IN NUMBER ) RETURN Reserv_Handl_Unit_Qty_Tab  
IS
   reserv_handl_unit_tab_     Reserv_Handl_Unit_Qty_Tab;
   
   CURSOR get_attr IS
      SELECT handling_unit_id, quantity, catch_qty_to_reassign
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1                = source_ref1_
      AND   source_ref2                = source_ref2_
      AND   source_ref3                = source_ref3_
      AND   source_ref4                = source_ref4_       
      AND   contract                   = contract_
      AND   part_no                    = part_no_
      AND   location_no                = location_no_
      AND   lot_batch_no               = lot_batch_no_
      AND   serial_no                  = serial_no_
      AND   eng_chg_level              = eng_chg_level_
      AND   waiv_dev_rej_no            = waiv_dev_rej_no_
      AND   activity_seq               = activity_seq_
      AND   reserv_handling_unit_id    = reserv_handling_unit_id_
      AND   configuration_id           = configuration_id_
      AND   pick_list_no               = pick_list_no_
      AND   shipment_id                = shipment_id_
      AND   shipment_line_no           = shipment_line_no_
      AND   (handling_unit_id = handling_unit_id_ OR handling_unit_id_ IS NULL);
BEGIN
   OPEN get_attr;
   FETCH get_attr BULK COLLECT INTO reserv_handl_unit_tab_;
   CLOSE get_attr;
   RETURN reserv_handl_unit_tab_;
END Get_Handling_Units;


FUNCTION Get_Hus_Per_Reservation (
   order_no_                        VARCHAR2,
   line_no_                         VARCHAR2,
   release_no_                      VARCHAR2,
   line_item_no_                    VARCHAR2,
   order_supply_demand_type_db_     VARCHAR2,
   part_no_                         VARCHAR2,
   contract_                        VARCHAR2,
   configuration_id_                VARCHAR2,
   location_no_                     VARCHAR2,
   lot_batch_no_                    VARCHAR2,
   serial_no_                       VARCHAR2,
   eng_chg_level_                   VARCHAR2,
   waiv_dev_rej_no_                 VARCHAR2,                  
   activity_seq_                    NUMBER,
   handling_unit_id_                NUMBER,
   shipment_id_                     NUMBER,
   pick_list_no_                    VARCHAR2) RETURN Invent_Part_Quantity_Util_API.Ship_Reserv_Handl_Unit_Tab
IS
   index_                           NUMBER;
   shipment_line_no_                NUMBER;
   ship_handl_units_per_res_tab_    Shipment_Reserv_Handl_Unit_API.Reserv_Handl_Unit_Qty_Tab;
   shipment_reserv_handl_unit_tab_  Invent_Part_Quantity_Util_API.Ship_Reserv_Handl_Unit_Tab;
BEGIN 
   IF shipment_id_ = 0 THEN
      RETURN shipment_reserv_handl_unit_tab_;
   END IF;
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                       order_no_, 
                                                                       line_no_, 
                                                                       release_no_, 
                                                                       line_item_no_, 
                                                                       Reserve_Shipment_API.Get_Logistics_Source_Type_Db(order_supply_demand_type_db_));
   
   ship_handl_units_per_res_tab_ := Get_Handling_Units(order_no_, 
                                                       NVL(line_no_, '*'), 
                                                       NVL(release_no_, '*'), 
                                                       NVL(line_item_no_, '*'), 
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
                                                       pick_list_no_, 
                                                       shipment_id_, 
                                                       shipment_line_no_,
                                                       NULL);
   
   IF ship_handl_units_per_res_tab_.COUNT > 0 THEN
      FOR j IN ship_handl_units_per_res_tab_.FIRST..ship_handl_units_per_res_tab_.LAST LOOP
         index_ := NVL(shipment_reserv_handl_unit_tab_.LAST, 0) + 1;
         shipment_reserv_handl_unit_tab_(index_).source_ref1             := order_no_;
         shipment_reserv_handl_unit_tab_(index_).source_ref2             := line_no_;
         shipment_reserv_handl_unit_tab_(index_).source_ref3             := release_no_;
         shipment_reserv_handl_unit_tab_(index_).source_ref4             := line_item_no_;
         shipment_reserv_handl_unit_tab_(index_).contract                := contract_;
         shipment_reserv_handl_unit_tab_(index_).part_no                 := part_no_;
         shipment_reserv_handl_unit_tab_(index_).location_no             := location_no_;
         shipment_reserv_handl_unit_tab_(index_).lot_batch_no            := lot_batch_no_;
         shipment_reserv_handl_unit_tab_(index_).serial_no               := serial_no_;
         shipment_reserv_handl_unit_tab_(index_).eng_chg_level           := eng_chg_level_;
         shipment_reserv_handl_unit_tab_(index_).waiv_dev_rej_no         := waiv_dev_rej_no_;
         shipment_reserv_handl_unit_tab_(index_).activity_seq            := activity_seq_;
         shipment_reserv_handl_unit_tab_(index_).reserv_handling_unit_id := handling_unit_id_;
         shipment_reserv_handl_unit_tab_(index_).configuration_id        := configuration_id_;
         shipment_reserv_handl_unit_tab_(index_).pick_list_no            := pick_list_no_;
         shipment_reserv_handl_unit_tab_(index_).shipment_id             := shipment_id_;
         shipment_reserv_handl_unit_tab_(index_).shipment_line_no        := shipment_line_no_;
         shipment_reserv_handl_unit_tab_(index_).handling_unit_id        := ship_handl_units_per_res_tab_(j).handling_unit_id;
         shipment_reserv_handl_unit_tab_(index_).quantity                := ship_handl_units_per_res_tab_(j).quantity;
         shipment_reserv_handl_unit_tab_(index_).catch_qty_to_reassign   := ship_handl_units_per_res_tab_(j).catch_qty_to_reassign;
      END LOOP;
   END IF;
   RETURN shipment_reserv_handl_unit_tab_;
END Get_Hus_Per_Reservation;

 
PROCEDURE Attach_Reservations_To_Ship_Hu (
   shipment_reserv_handl_unit_tab_     IN OUT Invent_Part_Quantity_Util_API.Ship_Reserv_Handl_Unit_Tab,
   to_location_no_                     IN VARCHAR2,
   unattached_from_handling_unit_      IN VARCHAR2)
IS
BEGIN
   IF (shipment_reserv_handl_unit_tab_.COUNT > 0 ) THEN
      FOR i IN shipment_reserv_handl_unit_tab_.FIRST..shipment_reserv_handl_unit_tab_.LAST LOOP
         IF (unattached_from_handling_unit_ = 'TRUE') THEN
            shipment_reserv_handl_unit_tab_(i).reserv_handling_unit_id := 0;
            -- This check is useful when moving reserved stock attached to a HU in combination with serial tracking only at receipt and issue and when unpacking 
            -- the serial meaning that handling unit ID goes to zero and serial resets to *. 
            IF (shipment_reserv_handl_unit_tab_(i).serial_no != '*') AND 
               (Inventory_Part_In_Stock_API.Check_Individual_Exist(shipment_reserv_handl_unit_tab_(i).part_no, shipment_reserv_handl_unit_tab_(i).serial_no) = 0) THEN 
               shipment_reserv_handl_unit_tab_(i).serial_no := '*';
            END IF ;   
         END IF;
         
         Shipment_Reserv_Handl_Unit_API.New_Or_Add_To_Existing(shipment_reserv_handl_unit_tab_(i).source_ref1, 
                                                               NVL(shipment_reserv_handl_unit_tab_(i).source_ref2, '*'), 
                                                               NVL(shipment_reserv_handl_unit_tab_(i).source_ref3, '*'), 
                                                               NVL(shipment_reserv_handl_unit_tab_(i).source_ref4, '*'), 
                                                               shipment_reserv_handl_unit_tab_(i).contract, 
                                                               shipment_reserv_handl_unit_tab_(i).part_no, 
                                                               to_location_no_, 
                                                               shipment_reserv_handl_unit_tab_(i).lot_batch_no, 
                                                               shipment_reserv_handl_unit_tab_(i).serial_no, 
                                                               shipment_reserv_handl_unit_tab_(i).eng_chg_level, 
                                                               shipment_reserv_handl_unit_tab_(i).waiv_dev_rej_no, 
                                                               shipment_reserv_handl_unit_tab_(i).activity_seq, 
                                                               shipment_reserv_handl_unit_tab_(i).reserv_handling_unit_id, 
                                                               shipment_reserv_handl_unit_tab_(i).configuration_id, 
                                                               shipment_reserv_handl_unit_tab_(i).pick_list_no, 
                                                               shipment_reserv_handl_unit_tab_(i).shipment_id, 
                                                               shipment_reserv_handl_unit_tab_(i).shipment_line_no, 
                                                               shipment_reserv_handl_unit_tab_(i).handling_unit_id, 
                                                               shipment_reserv_handl_unit_tab_(i).quantity, 
                                                               shipment_reserv_handl_unit_tab_(i).catch_qty_to_reassign);
      END LOOP;
   END IF;
END Attach_Reservations_To_Ship_Hu;

-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Add_Handling_Units (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_tab_         IN Reserv_Handl_Unit_Qty_Tab,
   move_to_ship_location_     IN VARCHAR2 DEFAULT 'FALSE')
IS
BEGIN
   Inventory_Event_Manager_API.Start_Session;
   FOR i IN handling_unit_tab_.FIRST..handling_unit_tab_.LAST LOOP
      New_Or_Add_To_Existing(source_ref1_                => source_ref1_, 
                             source_ref2_                => source_ref2_, 
                             source_ref3_                => source_ref3_, 
                             source_ref4_                => source_ref4_,                              
                             contract_                   => contract_,
                             part_no_                    => part_no_,
                             location_no_                => location_no_,
                             lot_batch_no_               => lot_batch_no_,
                             serial_no_                  => serial_no_,
                             eng_chg_level_              => eng_chg_level_,
                             waiv_dev_rej_no_            => waiv_dev_rej_no_,
                             activity_seq_               => activity_seq_,
                             reserv_handling_unit_id_    => reserv_handling_unit_id_,
                             configuration_id_           => configuration_id_,
                             pick_list_no_               => pick_list_no_,
                             shipment_id_                => shipment_id_,
                             shipment_line_no_           => shipment_line_no_,
                             handling_unit_id_           => handling_unit_tab_(i).handling_unit_id,
                             quantity_to_be_added_       => handling_unit_tab_(i).quantity,
                             catch_qty_to_reassign_      => handling_unit_tab_(i).catch_qty_to_reassign,
                             move_to_ship_location_      => move_to_ship_location_);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Add_Handling_Units;

-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE New_Or_Add_To_Existing (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_          IN NUMBER,
   quantity_to_be_added_      IN NUMBER,
   catch_qty_to_reassign_     IN NUMBER,
   move_to_ship_location_     IN VARCHAR2 DEFAULT 'FALSE' )
IS
   oldrec_                          SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
   local_reserv_handling_unit_id_   NUMBER := reserv_handling_unit_id_;
   source_ref_type_db_              VARCHAR2(30);
   inventory_location_type_         VARCHAR2(20);
   handling_unit_rec_               Handling_Unit_API.Public_Rec;
BEGIN
   inventory_location_type_ := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
   -- If we're in a shipment inventory location and trying to add a record with different handling_unit_ids (inventory and shipment) we need
   -- to repack it into the Handling Unit on the shipment.
   IF (inventory_location_type_ = Inventory_Location_Type_API.DB_SHIPMENT AND
       local_reserv_handling_unit_id_ != handling_unit_id_) THEN
       
       handling_unit_rec_ := Handling_Unit_API.Get(handling_unit_id_);
      -- If the Handling Unit on the Shipment is on another location than the reservation you are trying to pack we won't
      -- go through with the packing.
      IF (contract_     = NVL(handling_unit_rec_.contract, contract_) AND
          location_no_  = NVL(handling_unit_rec_.location_no, location_no_)) THEN
         source_ref_type_db_       := Shipment_Line_API.Get_Source_Ref_Type_Db(shipment_id_, shipment_line_no_);
         
         Repack_Into_HU_On_Shipment___(source_ref1_                  => source_ref1_, 
                                       source_ref2_                  => source_ref2_, 
                                       source_ref3_                  => source_ref3_, 
                                       source_ref4_                  => source_ref4_,
                                       source_ref_type_db_           => source_ref_type_db_,
                                       contract_                     => contract_, 
                                       part_no_                      => part_no_, 
                                       location_no_                  => location_no_, 
                                       lot_batch_no_                 => lot_batch_no_, 
                                       serial_no_                    => serial_no_, 
                                       eng_chg_level_                => eng_chg_level_, 
                                       waiv_dev_rej_no_              => waiv_dev_rej_no_, 
                                       activity_seq_                 => activity_seq_, 
                                       from_handling_unit_id_        => local_reserv_handling_unit_id_, 
                                       to_handling_unit_id_          => handling_unit_id_,
                                       configuration_id_             => configuration_id_, 
                                       pick_list_no_                 => pick_list_no_, 
                                       shipment_id_                  => shipment_id_,
                                       qty_to_repack_                => quantity_to_be_added_, 
                                       catch_qty_to_repack_          => catch_qty_to_reassign_,
                                       move_to_ship_location_        => move_to_ship_location_); 
         
         -- After repacking we know that the handling_unit_ids are the same and we create a new record with reserv_handling_unit_id being
         -- the same as handling_unit_id.
         local_reserv_handling_unit_id_ := handling_unit_id_;
      END IF;
   END IF;
   
   -- If we are in Shipment Inventory the Handling Unit ids (reserv_handling_unit_id and handling_unit_id) now needs to be the same. If not we wont create a new record.
   IF (inventory_location_type_ != Inventory_Location_Type_API.DB_SHIPMENT OR
      (inventory_location_type_ = Inventory_Location_Type_API.DB_SHIPMENT AND local_reserv_handling_unit_id_ = handling_unit_id_)) THEN
      IF (Check_Exist___(source_ref1_,
                         source_ref2_,
                         source_ref3_,
                         source_ref4_,                     
                         contract_,
                         part_no_,
                         location_no_,
                         lot_batch_no_,
                         serial_no_,
                         eng_chg_level_,
                         waiv_dev_rej_no_,
                         activity_seq_,
                         local_reserv_handling_unit_id_,
                         configuration_id_,
                         pick_list_no_,
                         shipment_id_,
                         shipment_line_no_,
                         handling_unit_id_)) THEN
         oldrec_ := Lock_By_Keys___(source_ref1_,
                                    source_ref2_,
                                    source_ref3_,
                                    source_ref4_,                                 
                                    contract_,
                                    part_no_,
                                    location_no_,
                                    lot_batch_no_,
                                    serial_no_,
                                    eng_chg_level_,
                                    waiv_dev_rej_no_,
                                    activity_seq_,
                                    local_reserv_handling_unit_id_,
                                    configuration_id_,
                                    pick_list_no_,
                                    shipment_id_,
                                    shipment_line_no_,
                                    handling_unit_id_);
         Modify___(source_ref1_,
                   source_ref2_,
                   source_ref3_,
                   source_ref4_,                 
                   contract_,
                   part_no_,
                   location_no_,
                   lot_batch_no_,
                   serial_no_,
                   eng_chg_level_,
                   waiv_dev_rej_no_,
                   activity_seq_,
                   local_reserv_handling_unit_id_,
                   configuration_id_,
                   pick_list_no_,
                   shipment_id_,
                   shipment_line_no_,
                   handling_unit_id_,
                   (quantity_to_be_added_ + oldrec_.quantity),
                   (catch_qty_to_reassign_ + oldrec_.catch_qty_to_reassign));
      ELSE
         New___(source_ref1_,
                source_ref2_,
                source_ref3_,
                source_ref4_,             
                contract_,
                part_no_,
                location_no_,
                lot_batch_no_,
                serial_no_,
                eng_chg_level_,
                waiv_dev_rej_no_,
                activity_seq_,
                local_reserv_handling_unit_id_,
                configuration_id_,
                pick_list_no_,
                shipment_id_,
                shipment_line_no_,
                handling_unit_id_,
                quantity_to_be_added_,
                catch_qty_to_reassign_ );
      END IF;
   END IF;
END New_Or_Add_To_Existing;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Modify_Pick_List_No (
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2,  
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   reserv_handling_unit_id_ IN NUMBER,
   configuration_id_        IN VARCHAR2,
   pick_list_no_            IN VARCHAR2,
   shipment_id_             IN NUMBER,
   shipment_line_no_        IN NUMBER,
   new_pick_list_no_        IN VARCHAR2 )
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   oldrec_     SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
   newrec_     SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
   
   CURSOR get_handling_unit_id IS
      SELECT shipment_line_no, handling_unit_id
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE source_ref1             = source_ref1_
         AND source_ref2             = source_ref2_
         AND source_ref3             = source_ref3_
         AND source_ref4             = source_ref4_         
         AND contract                = contract_
         AND part_no                 = part_no_
         AND location_no             = location_no_
         AND lot_batch_no            = lot_batch_no_
         AND serial_no               = serial_no_
         AND eng_chg_level           = eng_chg_level_
         AND waiv_dev_rej_no         = waiv_dev_rej_no_
         AND activity_seq            = activity_seq_
         AND reserv_handling_unit_id = reserv_handling_unit_id_
         AND configuration_id        = configuration_id_
         AND pick_list_no            = pick_list_no_
         AND shipment_id             = shipment_id_
         AND shipment_line_no        = shipment_line_no_;
BEGIN
   FOR rec_ IN get_handling_unit_id LOOP 
      Get_Id_Version_By_Keys___(objid_, 
                                objversion_, 
                                source_ref1_,
                                source_ref2_,
                                source_ref3_,
                                source_ref4_,                                
                                contract_, 
                                part_no_, 
                                location_no_, 
                                lot_batch_no_, 
                                serial_no_,
                                eng_chg_level_, 
                                waiv_dev_rej_no_, 
                                activity_seq_, 
                                reserv_handling_unit_id_,
                                configuration_id_, 
                                pick_list_no_, 
                                shipment_id_, 
                                shipment_line_no_,
                                rec_.handling_unit_id);
                                
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('PICK_LIST_NO', new_pick_list_no_, attr_);
      Unpack___(newrec_, indrec_, attr_); 
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END LOOP;
END Modify_Pick_List_No;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Quantity_On_Shipment (
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2, 
   source_ref_type_db_      IN VARCHAR2,  -- logistic source ref type will be sent in order to fetch the shipment line no
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   reserv_handling_unit_id_ IN NUMBER,
   configuration_id_        IN VARCHAR2,
   pick_list_no_            IN VARCHAR2,
   shipment_id_             IN NUMBER) RETURN NUMBER
IS
   temp_ SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE;
   shipment_line_no_        NUMBER;
   CURSOR get_attr IS
      SELECT SUM(quantity)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1             = source_ref1_
      AND   source_ref2             = source_ref2_
      AND   source_ref3             = source_ref3_
      AND   source_ref4             = source_ref4_       
      AND   contract                = contract_
      AND   part_no                 = part_no_
      AND   location_no             = location_no_
      AND   lot_batch_no            = lot_batch_no_
      AND   serial_no               = serial_no_
      AND   eng_chg_level           = eng_chg_level_
      AND   waiv_dev_rej_no         = waiv_dev_rej_no_
      AND   activity_seq            = activity_seq_
      AND   reserv_handling_unit_id = reserv_handling_unit_id_
      AND   configuration_id        = configuration_id_
      AND   pick_list_no            = pick_list_no_
      AND   shipment_id             = shipment_id_
      AND   shipment_line_no        = shipment_line_no_;
BEGIN
   -- since source_ref2, source_ref3, source_ref4 can contain "*", we need to convert back to NULL when calling shipment line.
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                       source_ref1_, 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4), source_ref_type_db_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Quantity_On_Shipment;

-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Catch_Qty_On_Shipment (
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2, 
   source_ref_type_db_      IN VARCHAR2,  -- logistic source ref type will be sent in order to fetch the shipment line no
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   reserv_handling_unit_id_ IN NUMBER,
   configuration_id_        IN VARCHAR2,
   pick_list_no_            IN VARCHAR2,
   shipment_id_             IN NUMBER) RETURN NUMBER
IS
   temp_ SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE;
   shipment_line_no_        NUMBER;
   CURSOR get_attr IS
      SELECT SUM(catch_qty_to_reassign)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1             = source_ref1_
      AND   source_ref2             = source_ref2_
      AND   source_ref3             = source_ref3_
      AND   source_ref4             = source_ref4_       
      AND   contract                = contract_
      AND   part_no                 = part_no_
      AND   location_no             = location_no_
      AND   lot_batch_no            = lot_batch_no_
      AND   serial_no               = serial_no_
      AND   eng_chg_level           = eng_chg_level_
      AND   waiv_dev_rej_no         = waiv_dev_rej_no_
      AND   activity_seq            = activity_seq_
      AND   reserv_handling_unit_id = reserv_handling_unit_id_
      AND   configuration_id        = configuration_id_
      AND   pick_list_no            = pick_list_no_
      AND   shipment_id             = shipment_id_
      AND   shipment_line_no        = shipment_line_no_;
BEGIN
   -- since source_ref2, source_ref3, source_ref4 can contain "*", we need to convert back to NULL when calling shipment line.
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                       source_ref1_, 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4), source_ref_type_db_);
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Catch_Qty_On_Shipment;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Line_Attached_Qty (
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2,    
   shipment_id_             IN NUMBER,
   shipment_line_no_        IN NUMBER,
   handling_unit_id_     	 IN NUMBER ) RETURN NUMBER
IS
   temp_ SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE;
   
   CURSOR get_attr IS
      SELECT NVL(SUM(quantity), 0)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1        = source_ref1_
      AND   source_ref2        = source_ref2_
      AND   source_ref3        = source_ref3_
      AND   source_ref4        = source_ref4_       
      AND   shipment_id        = shipment_id_
      AND   shipment_line_no   = shipment_line_no_
      AND  (handling_unit_id = handling_unit_id_ OR handling_unit_id_ IS NULL );
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Line_Attached_Qty;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Line_Ship_Inv_Qty (
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   shipment_id_         IN NUMBER,
   shipment_line_no_    IN NUMBER,
   handling_unit_id_    IN NUMBER ) RETURN NUMBER
IS
   quantity_   SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE;
   
   CURSOR get_ship_inv_qty IS
      SELECT NVL(SUM(quantity), 0)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1        = source_ref1_
      AND   source_ref2        = source_ref2_
      AND   source_ref3        = source_ref3_
      AND   source_ref4        = source_ref4_       
      AND   shipment_id        = shipment_id_
      AND   shipment_line_no   = shipment_line_no_
      AND   handling_unit_id   = reserv_handling_unit_id
      AND   pick_list_no       != '*'
      AND  (handling_unit_id = handling_unit_id_ OR handling_unit_id_ IS NULL );
BEGIN
   OPEN get_ship_inv_qty;
   FETCH get_ship_inv_qty INTO quantity_;
   CLOSE get_ship_inv_qty;
   RETURN quantity_;
END Get_Line_Ship_Inv_Qty;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Remove_Or_Modify_Reservation (
   info_                     OUT VARCHAR2,
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,
   source_ref_type_db_        IN VARCHAR2,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   quantity_to_remove_        IN NUMBER )
IS
   old_quantity_     NUMBER;
   shipment_line_no_ NUMBER;
BEGIN
   -- Since source_ref2, source_ref3, source_ref4 can contain "*", we need to convert back to NULL when calling shipment line.
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                       source_ref1_, 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4), source_ref_type_db_);

   old_quantity_ := Get_Attached_Qty_Hu(shipment_id_, 
                                        shipment_line_no_,
                                        source_ref1_, 
                                        source_ref2_, 
                                        source_ref3_, 
                                        source_ref4_, 
                                        contract_, 
                                        part_no_, 
                                        location_no_, 
                                        lot_batch_no_, 
                                        serial_no_, 
                                        eng_chg_level_, 
                                        waiv_dev_rej_no_, 
                                        activity_seq_, 
                                        reserv_handling_unit_id_, 
                                        configuration_id_);

    Remove_Or_Modify(info_                      => info_, 
                     source_ref1_               => source_ref1_, 
                     source_ref2_               => source_ref2_, 
                     source_ref3_               => source_ref3_, 
                     source_ref4_               => source_ref4_, 
                     contract_                  => contract_, 
                     part_no_                   => part_no_, 
                     location_no_               => location_no_, 
                     lot_batch_no_              => lot_batch_no_, 
                     serial_no_                 => serial_no_, 
                     eng_chg_level_             => eng_chg_level_, 
                     waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                     activity_seq_              => activity_seq_, 
                     reserv_handling_unit_id_   => reserv_handling_unit_id_, 
                     configuration_id_          => configuration_id_, 
                     pick_list_no_              => pick_list_no_, 
                     shipment_id_               => shipment_id_, 
                     shipment_line_no_          => shipment_line_no_, 
                     new_quantity_              => old_quantity_ - quantity_to_remove_, 
                     old_quantity_              => old_quantity_);
END Remove_Or_Modify_Reservation;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
-- When called from report picking of shipment handling unit - move to shipment inventory, handling_unit_id_ will have a value.
PROCEDURE Remove_Or_Modify (
   info_                      OUT VARCHAR2,
   source_ref1_               IN  VARCHAR2,
   source_ref2_               IN  VARCHAR2,
   source_ref3_               IN  VARCHAR2,
   source_ref4_               IN  VARCHAR2,    
   contract_                  IN  VARCHAR2,
   part_no_                   IN  VARCHAR2,
   location_no_               IN  VARCHAR2,
   lot_batch_no_              IN  VARCHAR2,
   serial_no_                 IN  VARCHAR2,
   eng_chg_level_             IN  VARCHAR2,
   waiv_dev_rej_no_           IN  VARCHAR2,
   activity_seq_              IN  NUMBER,
   reserv_handling_unit_id_   IN  NUMBER,
   configuration_id_          IN  VARCHAR2,
   pick_list_no_              IN  VARCHAR2,
   shipment_id_               IN  NUMBER,
   shipment_line_no_          IN  NUMBER,
   new_quantity_              IN  NUMBER,
   old_quantity_              IN  NUMBER,
   only_check_                IN  BOOLEAN DEFAULT FALSE,
   handling_unit_id_          IN  NUMBER  DEFAULT NULL )
IS
   number_of_lines_              NUMBER;
   local_handling_unit_id_       NUMBER;
   shipment_line_handl_unit_qty_ NUMBER;
   shipment_line_rec_            Shipment_Line_API.Public_Rec;
   handling_unit_reserved_qty_   NUMBER;
   qty_on_shipment_              NUMBER;
   uom_                          VARCHAR2(10);
   
   CURSOR get_number_of_lines IS
      SELECT count(*)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1                = source_ref1_
      AND   source_ref2                = source_ref2_
      AND   source_ref3                = source_ref3_
      AND   source_ref4                = source_ref4_     
      AND   contract                   = contract_
      AND   part_no                    = part_no_
      AND   location_no                = location_no_
      AND   lot_batch_no               = lot_batch_no_
      AND   serial_no                  = serial_no_
      AND   eng_chg_level              = eng_chg_level_
      AND   waiv_dev_rej_no            = waiv_dev_rej_no_
      AND   activity_seq               = activity_seq_
      AND   reserv_handling_unit_id    = reserv_handling_unit_id_
      AND   configuration_id           = configuration_id_
      AND   pick_list_no               = pick_list_no_
      AND   shipment_id                = shipment_id_
      AND   shipment_line_no           = shipment_line_no_;
   
   CURSOR get_handling_unit_id IS
      SELECT handling_unit_id, quantity
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE source_ref1               = source_ref1_
         AND source_ref2               = source_ref2_
         AND source_ref3               = source_ref3_
         AND source_ref4               = source_ref4_         
         AND contract                  = contract_
         AND part_no                   = part_no_
         AND location_no               = location_no_
         AND lot_batch_no              = lot_batch_no_
         AND serial_no                 = serial_no_
         AND eng_chg_level             = eng_chg_level_
         AND waiv_dev_rej_no           = waiv_dev_rej_no_
         AND activity_seq              = activity_seq_
         AND reserv_handling_unit_id   = reserv_handling_unit_id_
         AND configuration_id          = configuration_id_
         AND pick_list_no              = pick_list_no_
         AND shipment_id               = shipment_id_
         AND shipment_line_no          = shipment_line_no_;
BEGIN
   OPEN get_number_of_lines;
   FETCH get_number_of_lines INTO number_of_lines_;
   CLOSE get_number_of_lines;
      
   shipment_line_rec_   := Shipment_Line_API.Get(shipment_id_,shipment_line_no_);  
   
   IF (number_of_lines_ = 1) THEN
      OPEN get_handling_unit_id;
      FETCH get_handling_unit_id INTO local_handling_unit_id_, handling_unit_reserved_qty_;
      CLOSE get_handling_unit_id;
      
      -- when report picking from shipment hnadling unit level handling_unit_id_ is not null, we could have one reservation record when no
      -- reservation made in HU in inventory, but part of the resrevation is connected to shipment HU with reserv_handling_unit_id_ = 0. 
      -- This record needs to be removed from picking location since new record is created for new reserv_handling_unit_id_.
      IF (NOT only_check_) THEN 
         IF (((handling_unit_id_ IS NULL) AND (((old_quantity_ - new_quantity_) <= 0) OR (new_quantity_ IS NULL) OR (new_quantity_ = 0)))
              OR ((handling_unit_id_ IS NOT NULL) AND (handling_unit_id_ = local_handling_unit_id_) AND (reserv_handling_unit_id_ = 0)))  THEN
            -- Remove line
            Remove___(source_ref1_,
                      source_ref2_,
                      source_ref3_,
                      source_ref4_,                      
                      contract_,
                      part_no_,
                      location_no_,
                      lot_batch_no_,
                      serial_no_,
                      eng_chg_level_,
                      waiv_dev_rej_no_,
                      activity_seq_,
                      reserv_handling_unit_id_,
                      configuration_id_,
                      pick_list_no_,
                      shipment_id_,
                      shipment_line_no_,
                      local_handling_unit_id_);
         ELSE
            shipment_line_handl_unit_qty_ := Shipment_Line_Handl_Unit_API.Get_Quantity(shipment_id_, 
                                                                                       shipment_line_no_, 
                                                                                       local_handling_unit_id_);                                                                                
            shipment_line_handl_unit_qty_ := (shipment_line_handl_unit_qty_ * shipment_line_rec_.conv_factor/shipment_line_rec_.inverted_conv_factor);
            
            IF ((shipment_line_handl_unit_qty_ > new_quantity_) OR (handling_unit_reserved_qty_ > new_quantity_)) THEN 
               -- Decrese qty_attached
               Modify___(source_ref1_                 => source_ref1_, 
                         source_ref2_                 => source_ref2_, 
                         source_ref3_                 => source_ref3_, 
                         source_ref4_                 => source_ref4_,                           
                         contract_                    => contract_,
                         part_no_                     => part_no_,
                         location_no_                 => location_no_,
                         lot_batch_no_                => lot_batch_no_,
                         serial_no_                   => serial_no_,
                         eng_chg_level_               => eng_chg_level_,
                         waiv_dev_rej_no_             => waiv_dev_rej_no_,
                         activity_seq_                => activity_seq_,
                         reserv_handling_unit_id_     => reserv_handling_unit_id_,
                         configuration_id_            => configuration_id_,
                         pick_list_no_                => pick_list_no_,
                         shipment_id_                 => shipment_id_,
                         shipment_line_no_            => shipment_line_no_,
                         handling_unit_id_   		   => local_handling_unit_id_,
                         quantity_                    => new_quantity_,
                         catch_qty_to_reassign_       => NULL);
            END IF;
         END IF;
      END IF;
   ELSIF (number_of_lines_ > 1) THEN
      qty_on_shipment_ := Get_Quantity_On_Shipment(source_ref1_,
                                                   source_ref2_,
                                                   source_ref3_,
                                                   source_ref4_, 
                                                   shipment_line_rec_.source_ref_type,
                                                   contract_, 
                                                   part_no_,
                                                   location_no_,
                                                   lot_batch_no_,
                                                   serial_no_,
                                                   eng_chg_level_,
                                                   waiv_dev_rej_no_,
                                                   activity_seq_,
                                                   reserv_handling_unit_id_,
                                                   configuration_id_,
                                                   pick_list_no_,
                                                   shipment_id_);
      
      IF (new_quantity_ < qty_on_shipment_) THEN
         -- Remove all lines
         IF (only_check_) THEN 
            uom_ := shipment_line_rec_.source_unit_meas;                                                           
            Client_SYS.Clear_Info;
            Raise_Line_Removed_Warning___(new_quantity_, qty_on_shipment_, uom_);
            info_ := Client_SYS.Get_All_Info;
         ELSE 
            -- if pick report from shipment handling unit level(handling_unit_id_ IS NOT NULL), and if multiple reservation records 
            -- remove only the records for report picked shipment handling unit ids.
            FOR rec_ IN get_handling_unit_id LOOP 
               IF ((handling_unit_id_ IS NULL) OR
                   ((handling_unit_id_ IS NOT NULL) AND (handling_unit_id_ = rec_.handling_unit_id))) THEN
                  Remove___(source_ref1_,
                            source_ref2_,
                            source_ref3_,
                            source_ref4_,                          
                            contract_,
                            part_no_,
                            location_no_,
                            lot_batch_no_,
                            serial_no_,
                            eng_chg_level_,
                            waiv_dev_rej_no_,
                            activity_seq_,
                            reserv_handling_unit_id_,
                            configuration_id_,
                            pick_list_no_,
                            shipment_id_,
                            shipment_line_no_,
                            rec_.handling_unit_id);
                END IF;         
            END LOOP;
         END IF;
      END IF;
   END IF;
END Remove_Or_Modify;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Remove_Or_Modify (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		   IN NUMBER,
   new_quantity_              IN NUMBER,
   old_quantity_              IN NUMBER,
   only_check_                IN BOOLEAN DEFAULT FALSE )
IS
   number_of_lines_         NUMBER;
   contract_                SHIPMENT_RESERV_HANDL_UNIT_TAB.contract%TYPE;
   part_no_                 SHIPMENT_RESERV_HANDL_UNIT_TAB.part_no%TYPE;
   location_no_             SHIPMENT_RESERV_HANDL_UNIT_TAB.location_no%TYPE;
   lot_batch_no_            SHIPMENT_RESERV_HANDL_UNIT_TAB.lot_batch_no%TYPE;
   serial_no_               SHIPMENT_RESERV_HANDL_UNIT_TAB.serial_no%TYPE;
   eng_chg_level_           SHIPMENT_RESERV_HANDL_UNIT_TAB.eng_chg_level%TYPE;
   waiv_dev_rej_no_         SHIPMENT_RESERV_HANDL_UNIT_TAB.waiv_dev_rej_no%TYPE;
   activity_seq_            SHIPMENT_RESERV_HANDL_UNIT_TAB.activity_seq%TYPE;
   configuration_id_        SHIPMENT_RESERV_HANDL_UNIT_TAB.configuration_id%TYPE;
   pick_list_no_            SHIPMENT_RESERV_HANDL_UNIT_TAB.pick_list_no%TYPE;
   quantity_                SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE;
   reserv_handling_unit_id_ SHIPMENT_RESERV_HANDL_UNIT_TAB.reserv_handling_unit_id%TYPE;
   qty_in_hu_               NUMBER;
   uom_                     VARCHAR2(10);    
   
   CURSOR get_number_of_lines IS
      SELECT count(*)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1       = source_ref1_
      AND   source_ref2       = source_ref2_
      AND   source_ref3       = source_ref3_
      AND   source_ref4       = source_ref4_      
      AND   shipment_id       = shipment_id_
      AND   shipment_line_no  = shipment_line_no_
      AND   handling_unit_id  = handling_unit_id_;
   
   CURSOR get_attr IS
      SELECT contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level, 
             waiv_dev_rej_no, activity_seq, configuration_id, pick_list_no, quantity, reserv_handling_unit_id
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1       = source_ref1_
      AND   source_ref2       = source_ref2_
      AND   source_ref3       = source_ref3_
      AND   source_ref4       = source_ref4_      
      AND   shipment_id       = shipment_id_
      AND   shipment_line_no  = shipment_line_no_
      AND   handling_unit_id  = handling_unit_id_;
   
   CURSOR get_quantity_in_hu IS
      SELECT SUM(quantity)
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1         = source_ref1_
      AND   source_ref2         = source_ref2_
      AND   source_ref3         = source_ref3_
      AND   source_ref4         = source_ref4_       
      AND   shipment_id         = shipment_id_
      AND   shipment_line_no    = shipment_line_no_
      AND   handling_unit_id    = handling_unit_id_;
BEGIN
   OPEN get_number_of_lines;
   FETCH get_number_of_lines INTO number_of_lines_;
   CLOSE get_number_of_lines;
   
   OPEN get_quantity_in_hu;
   FETCH get_quantity_in_hu INTO qty_in_hu_;
   CLOSE get_quantity_in_hu;
   
   IF (new_quantity_ < qty_in_hu_) THEN
      IF (number_of_lines_ = 1) THEN
         OPEN get_attr;
         FETCH get_attr INTO contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, 
                             waiv_dev_rej_no_, activity_seq_, configuration_id_, pick_list_no_, quantity_, reserv_handling_unit_id_;
         CLOSE get_attr;

         IF (NOT only_check_) THEN 
            IF ((old_quantity_ - new_quantity_) <= 0) THEN
               -- Remove line
               Remove___(source_ref1_,
                         source_ref2_,
                         source_ref3_,
                         source_ref4_,                      
                         contract_,
                         part_no_,
                         location_no_,
                         lot_batch_no_,
                         serial_no_,
                         eng_chg_level_,
                         waiv_dev_rej_no_,
                         activity_seq_,
                         reserv_handling_unit_id_,
                         configuration_id_,
                         pick_list_no_,
                         shipment_id_,
                         shipment_line_no_,
                         handling_unit_id_);
            ELSE
               -- Decrese qty_attached
               Modify___(source_ref1_                 => source_ref1_,
                         source_ref2_                 => source_ref2_,
                         source_ref3_                 => source_ref3_,
                         source_ref4_                 => source_ref4_,                      
                         contract_                    => contract_,
                         part_no_                     => part_no_,
                         location_no_                 => location_no_,
                         lot_batch_no_                => lot_batch_no_,
                         serial_no_                   => serial_no_,
                         eng_chg_level_               => eng_chg_level_,
                         waiv_dev_rej_no_             => waiv_dev_rej_no_,
                         activity_seq_                => activity_seq_,
                         reserv_handling_unit_id_     => reserv_handling_unit_id_,
                         configuration_id_            => configuration_id_,
                         pick_list_no_                => pick_list_no_,
                         shipment_id_                 => shipment_id_,
                         shipment_line_no_            => shipment_line_no_,
                         handling_unit_id_   		   => handling_unit_id_,
                         quantity_                    => new_quantity_,
                         catch_qty_to_reassign_       => NULL);
            END IF;
         END IF;
      ELSIF (number_of_lines_ > 1) THEN
         IF (only_check_) THEN 
            uom_ := Shipment_Line_API.Get_Source_Unit_Meas(shipment_id_,shipment_line_no_);            
            Client_SYS.Clear_Info;
            Raise_Line_Removed_Warning___(new_quantity_, qty_in_hu_, uom_);
         ELSE 
            FOR rec_ IN get_attr LOOP 
               -- Remove all lines
               Remove___(source_ref1_,
                         source_ref2_,
                         source_ref3_,
                         source_ref4_,                         
                         rec_.contract,
                         rec_.part_no,
                         rec_.location_no,
                         rec_.lot_batch_no,
                         rec_.serial_no,
                         rec_.eng_chg_level,
                         rec_.waiv_dev_rej_no,
                         rec_.activity_seq,
                         rec_.reserv_handling_unit_id,
                         rec_.configuration_id,
                         rec_.pick_list_no,
                         shipment_id_,
                         shipment_line_no_,
                         handling_unit_id_);
            END LOOP;
         END IF;
      END IF;
   END IF;
END Remove_Or_Modify;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Reassign_Handl_Unit (
   qty_reassigned_            OUT NUMBER,
   qty_picked_                OUT NUMBER,
   source_ref1_               IN  VARCHAR2,
   source_ref2_               IN  VARCHAR2,
   source_ref3_               IN  VARCHAR2,
   source_ref4_               IN  VARCHAR2,    
   handling_unit_id_ 		  IN  NUMBER,
   from_shipment_id_          IN  NUMBER,
   from_shipment_line_no_     IN  NUMBER,
   to_shipment_id_            IN  NUMBER,
   to_shipment_line_no_       IN  NUMBER,
   release_reservations_      IN  BOOLEAN )
IS
   qty_picked_in_ship_inventory_ VARCHAR2(5) := 'FALSE';
   objid_                        SHIPMENT_RESERV_HANDL_UNIT.objid%TYPE;
   objversion_                   SHIPMENT_RESERV_HANDL_UNIT.objversion%TYPE;
   rec_                          SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;    
   catch_qty_to_reassign_        NUMBER := 0;
   sol_reserved_line_count_      NUMBER := 0;
   sol_qty_assigned_             NUMBER := 0;
   qty_reserved_                 NUMBER;
   qty_reserv_picked_            NUMBER;
   catch_qty_                    NUMBER;
   source_ref_type_db_           VARCHAR2(20);
   shipment_line_rec_            Shipment_Line_API.Public_Rec;

   CURSOR get_connected_lines IS
      SELECT shipment_line_no, contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             activity_seq, configuration_id, pick_list_no, quantity, catch_qty_to_reassign, reserv_handling_unit_id 
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
         WHERE source_ref1              = source_ref1_
         AND   source_ref2              = source_ref2_
         AND   source_ref3              = source_ref3_
         AND   source_ref4              = source_ref4_         
         AND   shipment_id              = from_shipment_id_
         AND   shipment_line_no         = from_shipment_line_no_
         AND   handling_unit_id         = handling_unit_id_;

   CURSOR get_sol_reserved_line_count(source_ref1_                VARCHAR2, 
                                      source_ref2_                VARCHAR2, 
                                      source_ref3_                VARCHAR2, 
                                      source_ref4_                VARCHAR2,                                       
                                      contract_                   VARCHAR2, 
                                      part_no_                    VARCHAR2, 
                                      location_no_                VARCHAR2, 
                                      lot_batch_no_               VARCHAR2, 
                                      serial_no_                  VARCHAR2,
                                      eng_chg_level_              VARCHAR2, 
                                      waiv_dev_rej_no_            VARCHAR2, 
                                      activity_seq_               NUMBER, 
                                      reserv_handling_unit_id_    NUMBER,
                                      configuration_id_           VARCHAR2,
                                      pick_list_no_               VARCHAR2) IS
      SELECT COUNT(*) 
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE  source_ref1               = source_ref1_
         AND source_ref2               = source_ref2_
         AND source_ref3               = source_ref3_
         AND source_ref4               = source_ref4_         
         AND contract                  = contract_
         AND part_no                   = part_no_
         AND location_no               = location_no_         
         AND lot_batch_no              = lot_batch_no_
         AND serial_no                 = serial_no_
         AND eng_chg_level             = eng_chg_level_
         AND waiv_dev_rej_no           = waiv_dev_rej_no_
         AND activity_seq              = activity_seq_
         AND reserv_handling_unit_id   = reserv_handling_unit_id_
         AND configuration_id          = configuration_id_
         AND pick_list_no              = pick_list_no_
         AND shipment_id               = from_shipment_id_
         AND shipment_line_no          = from_shipment_line_no_;
BEGIN
   qty_reassigned_     := 0;
   qty_picked_         := 0;
   shipment_line_rec_  := Shipment_Line_API.Get(from_shipment_id_, from_shipment_line_no_);
   source_ref_type_db_ := shipment_line_rec_.source_ref_type;
   FOR connected_rec_ IN get_connected_lines LOOP 
      Reserve_Shipment_API.Get_Quantity(qty_reserved_       => qty_reserved_, 
                                        qty_picked_         => qty_reserv_picked_,
                                        catch_qty_picked_   => catch_qty_,
                                        source_ref1_        => source_ref1_,
                                        source_ref2_        => source_ref2_,
                                        source_ref3_        => source_ref3_,
                                        source_ref4_        => source_ref4_,   
                                        source_ref_type_db_ => source_ref_type_db_,
                                        contract_           => connected_rec_.contract,
                                        part_no_            => connected_rec_.part_no,
                                        location_no_        => connected_rec_.location_no,
                                        lot_batch_no_       => connected_rec_.lot_batch_no,
                                        serial_no_          => connected_rec_.serial_no,
                                        eng_chg_level_      => connected_rec_.eng_chg_level,
                                        waiv_dev_rej_no_    => connected_rec_.waiv_dev_rej_no,
                                        activity_seq_       => connected_rec_.activity_seq,
                                        handling_unit_id_   => connected_rec_.reserv_handling_unit_id,
                                        configuration_id_   => connected_rec_.configuration_id,
                                        pick_list_no_       => connected_rec_.pick_list_no,                                                                    
                                        shipment_id_        => from_shipment_id_);
      IF (catch_qty_ > 0) THEN  
         sol_qty_assigned_ := shipment_line_rec_.qty_assigned;
                                                                          
         OPEN get_sol_reserved_line_count(source_ref1_,
                                          source_ref2_,
                                          source_ref3_,
                                          source_ref4_,                                          
                                          connected_rec_.contract,
                                          connected_rec_.part_no,
                                          connected_rec_.location_no,
                                          connected_rec_.lot_batch_no,
                                          connected_rec_.serial_no,
                                          connected_rec_.eng_chg_level,
                                          connected_rec_.waiv_dev_rej_no,
                                          connected_rec_.activity_seq,
                                          connected_rec_.reserv_handling_unit_id,
                                          connected_rec_.configuration_id,
                                          connected_rec_.pick_list_no);
         FETCH get_sol_reserved_line_count INTO sol_reserved_line_count_;
            
         IF (connected_rec_.catch_qty_to_reassign > 0) THEN
            IF ((catch_qty_ != connected_rec_.catch_qty_to_reassign) AND (sol_reserved_line_count_ = 1)) THEN 
               Error_SYS.Record_General(lu_name_, 'CATCHQTYLEFT: An additional Attached Catch Qty of :P1 must be added when reassigning part :P2.', (catch_qty_ - connected_rec_.catch_qty_to_reassign), connected_rec_.part_no);
            ELSE    
               catch_qty_to_reassign_ := connected_rec_.catch_qty_to_reassign;
            END IF;
         ELSE
            IF ((NVL(sol_reserved_line_count_, 0) = 1) AND (connected_rec_.quantity = sol_qty_assigned_))THEN
               catch_qty_to_reassign_ := catch_qty_;
            ELSE 
               Error_SYS.Record_General(lu_name_, 'CATCHQTYREASSIGNZERO: Catch Qty to Reassign must be specified for handling unit :P1 and part :P2.', handling_unit_id_, connected_rec_.part_no);
            END IF;
         END IF;
         CLOSE get_sol_reserved_line_count;
      END IF;
      
      IF (connected_rec_.pick_list_no != '*' AND qty_reserv_picked_ = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTPICKREPORTED: The handling unit must not consist of any attached reservations that are pick listed but not pick reported yet.' );
      END IF;

      -- Lock the source handling unit
      Get_Id_Version_By_Keys___(objid_,
                                objversion_,
                                source_ref1_,
                                source_ref2_,
                                source_ref3_,
                                source_ref4_,                                 
                                connected_rec_.contract,
                                connected_rec_.part_no,
                                connected_rec_.location_no,
                                connected_rec_.lot_batch_no,
                                connected_rec_.serial_no,
                                connected_rec_.eng_chg_level,
                                connected_rec_.waiv_dev_rej_no,
                                connected_rec_.activity_seq,
                                connected_rec_.reserv_handling_unit_id,
                                connected_rec_.configuration_id,
                                connected_rec_.pick_list_no,
                                from_shipment_id_,
                                connected_rec_.shipment_line_no,
                                handling_unit_id_);
      rec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(rec_);
      Delete___(objid_, rec_, unpack_in_ship_inv_ => FALSE);
      
      -- transfer reservations to the destination shipment
      Reassign_Shipment_Utility_API.Reassign_Connected_Reserve_Qty(qty_picked_in_ship_inventory_ => qty_picked_in_ship_inventory_,
                                                                   source_ref1_                  => source_ref1_,
                                                                   source_ref2_                  => source_ref2_,
                                                                   source_ref3_                  => source_ref3_,
                                                                   source_ref4_                  => source_ref4_,
                                                                   source_ref_type_db_           => source_ref_type_db_,
                                                                   contract_                     => connected_rec_.contract,
                                                                   part_no_                      => connected_rec_.part_no,
                                                                   location_no_                  => connected_rec_.location_no,
                                                                   lot_batch_no_                 => connected_rec_.lot_batch_no,
                                                                   serial_no_                    => connected_rec_.serial_no,
                                                                   eng_chg_level_                => connected_rec_.eng_chg_level,
                                                                   waiv_dev_rej_no_              => connected_rec_.waiv_dev_rej_no,
                                                                   activity_seq_                 => connected_rec_.activity_seq,
                                                                   handling_unit_id_             => connected_rec_.reserv_handling_unit_id,
                                                                   pick_list_no_                 => connected_rec_.pick_list_no,                                                                    
                                                                   configuration_id_             => connected_rec_.configuration_id,
                                                                   shipment_id_                  => from_shipment_id_,
                                                                   new_shipment_id_              => to_shipment_id_,  
                                                                   release_reservations_         => release_reservations_,
                                                                   qty_to_reassign_              => rec_.quantity,
                                                                   catch_qty_to_reassign_        => catch_qty_to_reassign_,
                                                                   reassignment_type_            => 'HANDLING_UNIT');

      -- if reservations are not released during reassignment create a new handling unit and attach the reserved qty
      IF (NOT release_reservations_ OR qty_picked_in_ship_inventory_ = 'TRUE') THEN 
         New___(source_ref1_                 => source_ref1_,
                source_ref2_                 => source_ref2_,
                source_ref3_                 => source_ref3_,
                source_ref4_                 => source_ref4_,                 
                contract_                    => connected_rec_.contract,
                part_no_                     => connected_rec_.part_no,
                location_no_                 => connected_rec_.location_no,
                lot_batch_no_                => connected_rec_.lot_batch_no,
                serial_no_                   => connected_rec_.serial_no,
                eng_chg_level_               => connected_rec_.eng_chg_level,
                waiv_dev_rej_no_             => connected_rec_.waiv_dev_rej_no,
                activity_seq_                => connected_rec_.activity_seq,
                reserv_handling_unit_id_     => connected_rec_.reserv_handling_unit_id,
                configuration_id_            => connected_rec_.configuration_id,
                pick_list_no_                => connected_rec_.pick_list_no,
                shipment_id_                 => to_shipment_id_,
                shipment_line_no_            => to_shipment_line_no_, 
                handling_unit_id_   		   => handling_unit_id_,
                quantity_                    => rec_.quantity, 
                catch_qty_to_reassign_       => catch_qty_to_reassign_);
      END IF;
      
      IF (qty_picked_in_ship_inventory_ = 'TRUE') THEN
         Client_SYS.Add_Info(lu_name_, 'QTYINSHIPINV: The reserved and picked quantity in the shipment inventory will not be released.');
         qty_picked_in_ship_inventory_ := 'FALSE';
      END IF;

      qty_reassigned_ := qty_reassigned_ + rec_.quantity;
      IF (connected_rec_.pick_list_no != '*') THEN
         qty_picked_ := qty_picked_ + qty_reassigned_;
      END IF;
   END LOOP;
END Reassign_Handl_Unit;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Handling_Unit_Exist (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,    
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER ) RETURN VARCHAR2  
IS
   temp_                NUMBER;
   handling_unit_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR check_exist IS
      SELECT 1
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1                = source_ref1_
      AND   source_ref2                = source_ref2_
      AND   source_ref3                = source_ref3_
      AND   source_ref4                = source_ref4_      
      AND   contract                   = contract_
      AND   part_no                    = part_no_
      AND   location_no                = location_no_
      AND   lot_batch_no               = lot_batch_no_
      AND   serial_no                  = serial_no_
      AND   eng_chg_level              = eng_chg_level_
      AND   waiv_dev_rej_no            = waiv_dev_rej_no_
      AND   activity_seq               = activity_seq_
      AND   reserv_handling_unit_id    = reserv_handling_unit_id_
      AND   configuration_id           = configuration_id_
      AND   pick_list_no               = pick_list_no_
      AND   shipment_id                = shipment_id_
      AND   shipment_line_no           = shipment_line_no_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF(check_exist%FOUND) THEN
      handling_unit_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exist;
   RETURN handling_unit_exist_;
END Handling_Unit_Exist;


@UncheckedAccess
FUNCTION Handling_Unit_Exist (
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER ) RETURN VARCHAR2  
IS
   temp_                NUMBER;
   handling_unit_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR check_exist IS
      SELECT 1
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE shipment_id                = shipment_id_
      AND   shipment_line_no           = shipment_line_no_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF(check_exist%FOUND) THEN
      handling_unit_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exist;
   RETURN handling_unit_exist_;
END Handling_Unit_Exist;

-- The method checks if there is any stock record in reserved handling unit structure that is pre-attached to the shipment handling unit(s)
@UncheckedAccess
FUNCTION Has_Qty_Attached_To_Shipment (
   reserv_handling_unit_id_   IN NUMBER,
   shipment_id_               IN NUMBER ) RETURN VARCHAR2  
IS
   temp_                NUMBER;
   handling_unit_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR check_exist IS
      SELECT 1
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE reserv_handling_unit_id IN ( SELECT hu.handling_unit_id
                                           FROM handling_unit_pub hu
                               CONNECT BY PRIOR hu.handling_unit_id = hu.parent_handling_unit_id
                                     START WITH hu.handling_unit_id = reserv_handling_unit_id_)
      AND   shipment_id    = shipment_id_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF(check_exist%FOUND) THEN
      handling_unit_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exist;
   RETURN handling_unit_exist_;
END Has_Qty_Attached_To_Shipment;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Remove_Handling_Unit (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER )
IS
   CURSOR get_data IS
      SELECT shipment_line_no, handling_unit_id
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE source_ref1               = source_ref1_
         AND source_ref2               = source_ref2_
         AND source_ref3               = source_ref3_
         AND source_ref4               = source_ref4_         
         AND contract                  = contract_
         AND part_no                   = part_no_
         AND location_no               = location_no_
         AND lot_batch_no              = lot_batch_no_
         AND serial_no                 = serial_no_
         AND eng_chg_level             = eng_chg_level_
         AND waiv_dev_rej_no           = waiv_dev_rej_no_
         AND activity_seq              = activity_seq_
         AND reserv_handling_unit_id   = reserv_handling_unit_id_
         AND configuration_id          = configuration_id_
         AND pick_list_no              = pick_list_no_
         AND shipment_id               = shipment_id_
         AND shipment_line_no          = shipment_line_no_;
BEGIN
   FOR rec_ IN get_data LOOP 
      Remove___(source_ref1_,
                source_ref2_,
                source_ref3_,
                source_ref4_,                 
                contract_,
                part_no_,
                location_no_,
                lot_batch_no_,
                serial_no_,
                eng_chg_level_,
                waiv_dev_rej_no_,
                activity_seq_,
                reserv_handling_unit_id_,
                configuration_id_,
                pick_list_no_,
                shipment_id_,
                rec_.shipment_line_no,
                rec_.handling_unit_id);
   END LOOP;
END Remove_Handling_Unit;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Modify (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		  IN NUMBER,
   quantity_                  IN NUMBER,
   catch_qty_to_reassign_     IN NUMBER )
IS
BEGIN
   Modify___(source_ref1_,
             source_ref2_,
             source_ref3_,
             source_ref4_,             
             contract_,
             part_no_,
             location_no_,
             lot_batch_no_,
             serial_no_,
             eng_chg_level_,
             waiv_dev_rej_no_,
             activity_seq_,
             reserv_handling_unit_id_,
             configuration_id_,
             pick_list_no_,
             shipment_id_,
             shipment_line_no_,
             handling_unit_id_,
             quantity_, 
             catch_qty_to_reassign_ );                         
END Modify;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Remove (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,    
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		  IN NUMBER )
IS
BEGIN
   Remove___(source_ref1_,
             source_ref2_,
             source_ref3_,
             source_ref4_,              
             contract_,
             part_no_,
             location_no_,
             lot_batch_no_,
             serial_no_,
             eng_chg_level_,
             waiv_dev_rej_no_,
             activity_seq_,
             reserv_handling_unit_id_,
             configuration_id_,
             pick_list_no_,
             shipment_id_,
             shipment_line_no_,
             handling_unit_id_);
END Remove;

PROCEDURE Reduce_Quantity (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,    
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   handling_unit_id_ 		   IN NUMBER,
   quantity_to_reduce_        IN NUMBER,
   catch_quantity_to_reduce_  IN NUMBER)
IS
   quantity_            SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE;
   catch_quantity_      SHIPMENT_RESERV_HANDL_UNIT_TAB.catch_qty_to_reassign%TYPE;
BEGIN
   quantity_ := Get_Quantity( source_ref1_,
                              source_ref2_,
                              source_ref3_,
                              source_ref4_,    
                              contract_,
                              part_no_,
                              location_no_,
                              lot_batch_no_,
                              serial_no_,
                              eng_chg_level_,
                              waiv_dev_rej_no_,
                              activity_seq_,
                              reserv_handling_unit_id_,
                              configuration_id_,
                              pick_list_no_,
                              shipment_id_,
                              shipment_line_no_,
                              handling_unit_id_);
   catch_quantity_ := Get_Catch_Qty_To_Reassign (  source_ref1_,
                                                   source_ref2_,
                                                   source_ref3_,
                                                   source_ref4_,    
                                                   contract_,
                                                   part_no_,
                                                   location_no_,
                                                   lot_batch_no_,
                                                   serial_no_,
                                                   eng_chg_level_,
                                                   waiv_dev_rej_no_,
                                                   activity_seq_,
                                                   reserv_handling_unit_id_,
                                                   configuration_id_,
                                                   pick_list_no_,
                                                   shipment_id_,
                                                   shipment_line_no_,
                                                   handling_unit_id_);
   
   IF (quantity_ = quantity_to_reduce_) THEN
      Remove(  source_ref1_,
               source_ref2_,
               source_ref3_,
               source_ref4_,    
               contract_,
               part_no_,
               location_no_,
               lot_batch_no_,
               serial_no_,
               eng_chg_level_,
               waiv_dev_rej_no_,
               activity_seq_,
               reserv_handling_unit_id_,
               configuration_id_,
               pick_list_no_,
               shipment_id_,
               shipment_line_no_,
               handling_unit_id_);
   ELSE
      Modify(  source_ref1_,
               source_ref2_,
               source_ref3_,
               source_ref4_,    
               contract_,
               part_no_,
               location_no_,
               lot_batch_no_,
               serial_no_,
               eng_chg_level_,
               waiv_dev_rej_no_,
               activity_seq_,
               reserv_handling_unit_id_,
               configuration_id_,
               pick_list_no_,
               shipment_id_,
               shipment_line_no_,
               handling_unit_id_,
               quantity_ - quantity_to_reduce_,
               catch_quantity_ - catch_quantity_to_reduce_);
   END IF;
END Reduce_Quantity;

PROCEDURE Change_Handling_Unit_id (
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,    
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   from_handling_unit_id_ 		IN NUMBER,
   to_handling_unit_id_        IN NUMBER,
   quantity_to_move_           IN NUMBER,
   catch_quantity_to_move_     IN NUMBER)
IS
   local_reserv_handling_unit_id_ NUMBER := reserv_handling_unit_id_;
   manual_net_weight_             NUMBER;
   shipment_line_handl_unit_rec_  Shipment_Line_Handl_Unit_API.Public_Rec;
BEGIN
   IF (from_handling_unit_id_ = to_handling_unit_id_) THEN
      RETURN;
   END IF;
   
   shipment_line_handl_unit_rec_ := Shipment_Line_Handl_Unit_API.Get(shipment_id_, shipment_line_no_, from_handling_unit_id_);
   -- If the whole quantity in the source HU is being moved abd the destination HU does not have any quantity from the same shipment line no, then pass the manual net weight.
   IF (shipment_line_handl_unit_rec_.quantity = quantity_to_move_ AND NOT Shipment_Line_Handl_Unit_API.Exists(shipment_id_, shipment_line_no_, to_handling_unit_id_)) THEN
      manual_net_weight_ := shipment_line_handl_unit_rec_.manual_net_weight;
   END IF;
   Reduce_Quantity(
      source_ref1_               => source_ref1_,
      source_ref2_               => source_ref2_,
      source_ref3_               => source_ref3_,
      source_ref4_               => source_ref4_,
      contract_                  => contract_,
      part_no_                   => part_no_,
      location_no_               => location_no_,
      lot_batch_no_              => lot_batch_no_,
      serial_no_                 => serial_no_,
      eng_chg_level_             => eng_chg_level_,
      waiv_dev_rej_no_           => waiv_dev_rej_no_,
      activity_seq_              => activity_seq_,
      reserv_handling_unit_id_   => reserv_handling_unit_id_,
      configuration_id_          => configuration_id_,
      pick_list_no_              => pick_list_no_,
      shipment_id_               => shipment_id_,
      shipment_line_no_          => shipment_line_no_,
      handling_unit_id_          => from_handling_unit_id_,
      quantity_to_reduce_        => quantity_to_move_,
      catch_quantity_to_reduce_  => catch_quantity_to_move_);

   Shipment_Line_Handl_Unit_API.Reduce_Quantity(
      shipment_id_         => shipment_id_, 
      shipment_line_no_    => shipment_line_no_, 
      handling_unit_id_    => from_handling_unit_id_, 
      qty_to_reduce_with_  => quantity_to_move_);

   Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing(
      shipment_id_         => shipment_id_, 
      shipment_line_no_    => shipment_line_no_, 
      handling_unit_id_    => to_handling_unit_id_, 
      quantity_to_be_added_  => quantity_to_move_,
      manual_net_weight_   => manual_net_weight_);

   IF (Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_) = Inventory_Location_Type_API.DB_SHIPMENT) THEN
      local_reserv_handling_unit_id_ := 0;
   END IF;

   New_Or_Add_To_Existing(
      source_ref1_               => source_ref1_,
      source_ref2_               => source_ref2_,
      source_ref3_               => source_ref3_,
      source_ref4_               => source_ref4_,
      contract_                  => contract_,
      part_no_                   => part_no_,
      location_no_               => location_no_,
      lot_batch_no_              => lot_batch_no_,
      serial_no_                 => serial_no_,
      eng_chg_level_             => eng_chg_level_,
      waiv_dev_rej_no_           => waiv_dev_rej_no_,
      activity_seq_              => activity_seq_,
      reserv_handling_unit_id_   => local_reserv_handling_unit_id_,
      configuration_id_          => configuration_id_,
      pick_list_no_              => pick_list_no_,
      shipment_id_               => shipment_id_,
      shipment_line_no_          => shipment_line_no_,
      handling_unit_id_          => to_handling_unit_id_,
      quantity_to_be_added_      => quantity_to_move_,
      catch_qty_to_reassign_     => catch_quantity_to_move_);
END Change_Handling_Unit_id;

@UncheckedAccess
FUNCTION Get_Unique_Eng_Chg_Level (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_eng_chg_levels IS
      SELECT DISTINCT eng_chg_level
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_
         AND handling_unit_id = handling_unit_id_;
   
   TYPE Eng_Chg_Level_Tab IS TABLE OF get_eng_chg_levels%ROWTYPE INDEX BY PLS_INTEGER;
   eng_chg_level_tab_ Eng_Chg_Level_Tab;
   
   result_ VARCHAR2(6) := NULL;  
BEGIN
   OPEN get_eng_chg_levels;
   FETCH get_eng_chg_levels BULK COLLECT INTO eng_chg_level_tab_;
   CLOSE get_eng_chg_levels;
      
   IF (eng_chg_level_tab_.COUNT = 1) THEN
      result_ := eng_chg_level_tab_(1).eng_chg_level;
   END IF;
      
   RETURN result_;
END Get_Unique_Eng_Chg_Level ;   


@UncheckedAccess
FUNCTION Get_Unique_Lot_Batch_No (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR get_lot_batch_nos IS
      SELECT DISTINCT lot_batch_no
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_
         AND handling_unit_id = handling_unit_id_;
   TYPE Lot_Batch_No_Tab IS TABLE OF get_lot_batch_nos%ROWTYPE INDEX BY PLS_INTEGER;
   lot_batch_no_tab_ Lot_Batch_No_Tab;      
         
   result_ VARCHAR2(20) := NULL;
BEGIN
   OPEN get_lot_batch_nos;
   FETCH get_lot_batch_nos BULK COLLECT INTO lot_batch_no_tab_;
   CLOSE get_lot_batch_nos;

   IF (lot_batch_no_tab_.COUNT = 1) THEN
      result_ := lot_batch_no_tab_(1).lot_batch_no;
   END IF;

   RETURN result_;
END Get_Unique_Lot_Batch_No ;    


@UncheckedAccess
FUNCTION Mixed_Lot_Batches_Connected (
   shipment_id_          IN NUMBER,
   handling_unit_id_tab_ IN Handling_Unit_API.Handling_Unit_Id_Tab ) RETURN BOOLEAN
IS
   CURSOR get_connected_lot_batch_no IS
      SELECT DISTINCT part_no, lot_batch_no
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_
         AND handling_unit_id IN (SELECT handling_unit_id FROM TABLE (handling_unit_id_tab_))
       ORDER BY part_no;
      
   mixed_lot_batches_connected_ BOOLEAN := FALSE;
   TYPE Connected_Lot_Batch_Tab IS TABLE OF get_connected_lot_batch_no%ROWTYPE INDEX BY PLS_INTEGER;
   lot_batch_tab_               Connected_Lot_Batch_Tab;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN

      OPEN get_connected_lot_batch_no;
      FETCH get_connected_lot_batch_no BULK COLLECT INTO lot_batch_tab_;
      CLOSE get_connected_lot_batch_no;

      IF (lot_batch_tab_.COUNT > 0) THEN
         FOR j_ IN lot_batch_tab_.FIRST..lot_batch_tab_.LAST LOOP
            IF (j_ < lot_batch_tab_.COUNT) THEN 
               IF (lot_batch_tab_(j_).part_no = lot_batch_tab_(j_+1).part_no) THEN
                  mixed_lot_batches_connected_ := TRUE;
                  EXIT;
               END IF;
            END IF;
         END LOOP;            
      END IF;    
      
   END IF;
   RETURN mixed_lot_batches_connected_;
END Mixed_Lot_Batches_Connected ;


@UncheckedAccess
FUNCTION Mixed_Cond_Codes_Connected (
   shipment_id_          IN NUMBER,
   handling_unit_id_tab_ IN Handling_Unit_API.Handling_Unit_Id_Tab ) RETURN BOOLEAN
IS
   CURSOR get_connected_cond_code IS
      SELECT DISTINCT part_no, Condition_Code_Manager_API.Get_Condition_Code(part_no, serial_no, lot_batch_no) condition_code
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_
         AND handling_unit_id  IN (SELECT handling_unit_id FROM TABLE (handling_unit_id_tab_))
       ORDER BY part_no;
   
   mixed_cond_codes_connected_        BOOLEAN := FALSE;
   
   TYPE Connected_Condition_Code_Tab IS TABLE OF get_connected_cond_code%ROWTYPE INDEX BY PLS_INTEGER;
   condition_code_tab_                Connected_Condition_Code_Tab;
BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      OPEN get_connected_cond_code;
      FETCH get_connected_cond_code BULK COLLECT INTO condition_code_tab_;
      CLOSE get_connected_cond_code;

      IF (condition_code_tab_.COUNT > 0) THEN 
         FOR j_ IN condition_code_tab_.FIRST..condition_code_tab_.LAST LOOP
            IF (j_ < condition_code_tab_.COUNT) THEN 
               IF (condition_code_tab_(j_).part_no = condition_code_tab_(j_+1).part_no) THEN
                  mixed_cond_codes_connected_ := TRUE;
                  EXIT;
               END IF;
            END IF;
         END LOOP;                        
       END IF;     
   END IF;
   RETURN mixed_cond_codes_connected_;
END Mixed_Cond_Codes_Connected;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Qty_On_Sub_Structure (
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,  
   shipment_id_                  IN NUMBER,
   handling_unit_id_    		 IN NUMBER ) RETURN NUMBER
IS
   total_qty_ NUMBER;
   CURSOR get_qty_on_sub_struct IS 
      SELECT NVL(SUM(quantity), 0)
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE source_ref1      = source_ref1_
         AND source_ref2      = source_ref2_ 
         AND source_ref3      = source_ref3_
         AND source_ref4      = source_ref4_         
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM shpmnt_handl_unit_with_history
                                   WHERE shipment_id = shipment_id_
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                   START WITH     handling_unit_id = handling_unit_id_);      
BEGIN
   OPEN get_qty_on_sub_struct;
   FETCH get_qty_on_sub_struct INTO total_qty_;
   CLOSE get_qty_on_sub_struct;
   RETURN total_qty_; 
END Get_Qty_On_Sub_Structure;   


PROCEDURE Validate_Catch_Qty(
   catch_quantity_to_be_added_  IN NUMBER,
   total_catch_qty_to_reassign_ IN NUMBER,
   customer_order_catch_qty_    IN NUMBER,
   old_catch_qty_to_reassign_   IN NUMBER,
   picked_catch_quantity_       IN NUMBER)
IS
BEGIN
   IF (catch_quantity_to_be_added_ + total_catch_qty_to_reassign_ > customer_order_catch_qty_) THEN
      Error_SYS.Record_General(lu_name_, 'CATCHQTYINCORRECT: Attached Catch Qty cannot be greater than :P1 since only a picked catch qty of :P2 is remaining', 
                                          (NVL(old_catch_qty_to_reassign_, 0) + picked_catch_quantity_), picked_catch_quantity_);
   END IF;
END Validate_Catch_Qty;


@UncheckedAccess
FUNCTION Get_Reserv_Hu_Ext_Details(
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN Reserv_Handl_Unit_Ext_Tab
IS
   reserv_handl_unit_ext_tab_   Reserv_Handl_Unit_Ext_Tab;   
   
   CURSOR get_reserv_handl_unit_details IS
      SELECT srhu.shipment_line_no, srhu.source_ref1, srhu.source_ref2, srhu.source_ref3, srhu.source_ref4, ssr.source_ref_type_db,  
             srhu.lot_batch_no, srhu.serial_no, srhu.eng_chg_level, srhu.waiv_dev_rej_no, srhu.reserv_handling_unit_id, ssr.expiration_date, 
             DECODE(ssr.source_ref_type_db, Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER, srhu.activity_seq, 0) activity_seq, SUM(srhu.quantity) total_qty 
      FROM   shipment_reserv_handl_unit_tab srhu, shipment_source_reservation ssr
      WHERE  srhu.shipment_id                = shipment_id_ 
      AND    srhu.shipment_id                = ssr.shipment_id
      AND    srhu.source_ref1                = ssr.source_ref1
      AND    srhu.source_ref2                = ssr.source_ref2
      AND    srhu.source_ref3                = ssr.source_ref3
      AND    srhu.source_ref4                = ssr.source_ref4
      AND    Shipment_Line_API.Get_Source_Ref_Type_Db(srhu.shipment_id, srhu.shipment_line_no)   = ssr.source_ref_type_db
      AND    srhu.contract                   = ssr.contract
      AND    srhu.configuration_id           = ssr.configuration_id
      AND    srhu.eng_chg_level              = ssr.eng_chg_level
      AND    srhu.lot_batch_no               = ssr.lot_batch_no
      AND    srhu.waiv_dev_rej_no            = ssr.waiv_dev_rej_no
      AND    srhu.part_no                    = ssr.part_no
      AND    srhu.pick_list_no               = ssr.pick_list_no
      AND    srhu.serial_no                  = ssr.serial_no
      AND    srhu.location_no                = ssr.location_no
      AND    srhu.reserv_handling_unit_id    = ssr.handling_unit_id 
      AND    srhu.handling_unit_id           = handling_unit_id_
      AND    ((ssr.source_ref_type_db != Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) OR (ssr.source_ref_type_db = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER AND srhu.activity_seq = ssr.activity_seq))
      GROUP BY srhu.shipment_line_no, srhu.source_ref1, srhu.source_ref2, srhu.source_ref3, srhu.source_ref4, ssr.source_ref_type_db,  
                  srhu.lot_batch_no, srhu.serial_no, srhu.eng_chg_level, srhu.waiv_dev_rej_no, srhu.reserv_handling_unit_id, ssr.expiration_date,
                  DECODE(ssr.source_ref_type_db, Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER, srhu.activity_seq, 0);
BEGIN
   OPEN  get_reserv_handl_unit_details;
   FETCH get_reserv_handl_unit_details BULK COLLECT INTO reserv_handl_unit_ext_tab_;
   CLOSE get_reserv_handl_unit_details;
   RETURN reserv_handl_unit_ext_tab_;
END Get_Reserv_Hu_Ext_Details;


@UncheckedAccess
FUNCTION Get_Uniq_Struct_Lot_Batch_No (
   handling_unit_id_ IN NUMBER,
   shipment_id_      IN NUMBER ) RETURN VARCHAR2
IS
   unique_lot_batch_no_   VARCHAR2(20):= NULL; 
   CURSOR get_unique_lot_batch_no IS
      SELECT DISTINCT lot_batch_no
        FROM shipment_reserv_handl_unit_tab
       WHERE shipment_id = shipment_id_
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM shpmnt_handl_unit_with_history
                                   WHERE shipment_id = shipment_id_
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                   START WITH handling_unit_id = handling_unit_id_);                                  
 BEGIN    
   OPEN get_unique_lot_batch_no;
   LOOP
      FETCH get_unique_lot_batch_no INTO unique_lot_batch_no_;
      EXIT WHEN (get_unique_lot_batch_no%NOTFOUND);
      IF (get_unique_lot_batch_no%ROWCOUNT > 1) THEN
         unique_lot_batch_no_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_unique_lot_batch_no;    
   RETURN unique_lot_batch_no_;
END Get_Uniq_Struct_Lot_Batch_No;


@UncheckedAccess
FUNCTION Get_Uniq_Struct_Eng_Chg_Level (
   handling_unit_id_ IN NUMBER,
   shipment_id_      IN NUMBER ) RETURN VARCHAR2
IS
   unique_eng_chg_level_   VARCHAR2(6):= NULL;      
   CURSOR get_unique_eng_chg_level IS
      SELECT DISTINCT eng_chg_level
        FROM shipment_reserv_handl_unit_tab
       WHERE shipment_id = shipment_id_
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM shpmnt_handl_unit_with_history
                                   WHERE shipment_id = shipment_id_
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                   START WITH handling_unit_id = handling_unit_id_);                                
BEGIN   
   OPEN get_unique_eng_chg_level;
   LOOP
      FETCH get_unique_eng_chg_level INTO unique_eng_chg_level_;
      EXIT WHEN (get_unique_eng_chg_level%NOTFOUND);
      IF (get_unique_eng_chg_level%ROWCOUNT > 1) THEN
         unique_eng_chg_level_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_unique_eng_chg_level;    
   RETURN unique_eng_chg_level_;
END Get_Uniq_Struct_Eng_Chg_Level;    


@UncheckedAccess
FUNCTION Get_Uniq_Struct_Waiv_Dev_Rej (
   handling_unit_id_ IN NUMBER,
   shipment_id_      IN NUMBER ) RETURN VARCHAR2
IS
   unique_waiv_dev_rej_no_   VARCHAR2(15):= NULL;    
   CURSOR get_unique_waiv_dev_rej_no IS
      SELECT DISTINCT waiv_dev_rej_no
       FROM  shipment_reserv_handl_unit_tab
      WHERE  shipment_id = shipment_id_
        AND  handling_unit_id IN (SELECT handling_unit_id
                                    FROM shpmnt_handl_unit_with_history 
                                   WHERE shipment_id = shipment_id_
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                   START WITH handling_unit_id = handling_unit_id_); 
                                  
BEGIN  
   OPEN get_unique_waiv_dev_rej_no;
   LOOP
      FETCH get_unique_waiv_dev_rej_no INTO unique_waiv_dev_rej_no_;
      EXIT WHEN (get_unique_waiv_dev_rej_no%NOTFOUND);
      IF (get_unique_waiv_dev_rej_no%ROWCOUNT > 1) THEN
         unique_waiv_dev_rej_no_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_unique_waiv_dev_rej_no;  
   RETURN unique_waiv_dev_rej_no_;  
END Get_Uniq_Struct_Waiv_Dev_Rej;    


@UncheckedAccess
FUNCTION Get_Uniq_Struct_Serial_No (
   handling_unit_id_ IN NUMBER,
   shipment_id_      IN NUMBER ) RETURN VARCHAR2
IS
   unique_serial_no_   VARCHAR2(50):= NULL;  
   CURSOR get_unique_serial_no IS
      SELECT DISTINCT serial_no
        FROM shipment_reserv_handl_unit_tab
       WHERE shipment_id = shipment_id_
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM shpmnt_handl_unit_with_history 
                                   WHERE shipment_id = shipment_id_
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                   START WITH handling_unit_id = handling_unit_id_);                                
BEGIN   
   OPEN get_unique_serial_no;
   LOOP
      FETCH get_unique_serial_no INTO unique_serial_no_;
      EXIT WHEN (get_unique_serial_no%NOTFOUND);
      IF (get_unique_serial_no%ROWCOUNT > 1) THEN
         unique_serial_no_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_unique_serial_no;    
   RETURN unique_serial_no_;  
END Get_Uniq_Struct_Serial_No; 


-- Used from ShipmentPackingList.rdf
-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Attached_Qty_Hu (
   shipment_id_             IN NUMBER,
   shipment_line_no_        IN NUMBER,
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2,    
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   reserv_handling_unit_id_ IN NUMBER,
   configuration_id_        IN VARCHAR2 ) RETURN VARCHAR2
IS     
   CURSOR get_attached_qty_hu IS
      SELECT SUM(quantity)  
        FROM shipment_reserv_handl_unit_tab
       WHERE shipment_id              = shipment_id_
         AND shipment_line_no         = shipment_line_no_
         AND source_ref1              = source_ref1_
         AND source_ref2              = source_ref2_
         AND source_ref3              = source_ref3_
         AND source_ref4              = source_ref4_             
         AND contract                 = contract_
         AND part_no                  = part_no_
         AND location_no              = location_no_
         AND lot_batch_no             = lot_batch_no_
         AND serial_no                = serial_no_
         AND eng_chg_level            = eng_chg_level_
         AND waiv_dev_rej_no          = waiv_dev_rej_no_
         AND activity_seq             = activity_seq_
         AND reserv_handling_unit_id  = reserv_handling_unit_id_
         AND configuration_id         = configuration_id_;    
   attached_qty_ NUMBER;
BEGIN    
   OPEN  get_attached_qty_hu;
   FETCH get_attached_qty_hu INTO attached_qty_;
   CLOSE get_attached_qty_hu;      
   RETURN attached_qty_;
      
END Get_Attached_Qty_Hu;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Qty_To_Attach_On_Res (
   source_ref1_             IN VARCHAR2,
   source_ref2_             IN VARCHAR2,
   source_ref3_             IN VARCHAR2,
   source_ref4_             IN VARCHAR2,    
   source_ref_type_db_      IN VARCHAR2,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   location_no_             IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   activity_seq_            IN NUMBER,
   reserv_handling_unit_id_ IN NUMBER,
   configuration_id_        IN VARCHAR2,
   pick_list_no_            IN VARCHAR2,
   shipment_id_             IN NUMBER) RETURN NUMBER
IS
   quantity_on_reserv_hu_   NUMBER:=0;
   qty_assigned_            NUMBER:=0;
BEGIN
   qty_assigned_ := NVL(Reserve_Shipment_API.Get_Qty_Reserved(source_ref1_ ,
                                                              source_ref2_ ,
                                                              source_ref3_ ,
                                                              source_ref4_ ,
                                                              contract_,
                                                              part_no_,
                                                              location_no_,
                                                              lot_batch_no_,
                                                              serial_no_,
                                                              eng_chg_level_,
                                                              waiv_dev_rej_no_,
                                                              activity_seq_,
                                                              reserv_handling_unit_id_,
                                                              configuration_id_,
                                                              pick_list_no_,
                                                              shipment_id_,
                                                              source_ref_type_db_), 0); 
                                     
   quantity_on_reserv_hu_ := NVL(Get_Quantity_On_Shipment(source_ref1_,
                                                          source_ref2_,
                                                          source_ref3_,
                                                          source_ref4_,
                                                          source_ref_type_db_,
                                                          contract_,
                                                          part_no_,
                                                          location_no_,
                                                          lot_batch_no_,
                                                          serial_no_,
                                                          eng_chg_level_,
                                                          waiv_dev_rej_no_,
                                                          activity_seq_,
                                                          reserv_handling_unit_id_,
                                                          configuration_id_,
                                                          pick_list_no_,
                                                          shipment_id_), 0); 
      
   RETURN NVL((qty_assigned_ - quantity_on_reserv_hu_), 0);
END Get_Qty_To_Attach_On_Res;

-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Add_Reservations_To_Handl_Unit (
   info_                      OUT VARCHAR2,
   source_ref1_               IN  VARCHAR2,
   source_ref2_               IN  VARCHAR2,
   source_ref3_               IN  VARCHAR2,
   source_ref4_               IN  VARCHAR2,   
   source_ref_type_db_        IN  VARCHAR2,
   shipment_id_               IN  NUMBER,
   shipment_line_no_          IN  NUMBER,
   handling_unit_id_ 		   IN  NUMBER,
   quantity_to_be_added_      IN  NUMBER,
   mix_block_excep_handling_  IN  BOOLEAN DEFAULT FALSE )
IS
   quantity_to_add_              NUMBER;
   shipment_line_handl_unit_qty_ NUMBER;
   shipment_res_handl_unit_qty_  NUMBER;
   shipment_line_rec_            Shipment_Line_API.Public_Rec;
   inv_handl_unit_qty_           NUMBER;
   remaining_qty_to_attach_      NUMBER;
   handling_unit_rec_            Handling_Unit_API.Public_Rec;
   
   CURSOR get_attr IS
      SELECT contract, part_no, location_no, lot_batch_no, serial_no, eng_chg_level, 
             waiv_dev_rej_no, activity_seq, configuration_id, pick_list_no, qty_assigned, handling_unit_id
         FROM  shipment_source_reservation  ssr
      WHERE source_ref1        = source_ref1_
      AND   source_ref2        = source_ref2_
      AND   source_ref3        = source_ref3_
      AND   source_ref4        = source_ref4_
      AND   source_ref_type_db = source_ref_type_db_
      AND   shipment_id        = shipment_id_
      AND   qty_assigned - (SELECT NVL(SUM(quantity), 0)
                            FROM shipment_reserv_handl_unit_tab s
                            WHERE s.source_ref1                = ssr.source_ref1
                            AND   s.source_ref2                = ssr.source_ref2
                            AND   s.source_ref3                = ssr.source_ref3
                            AND   s.source_ref4                = ssr.source_ref4                             
                            AND   s.contract                   = ssr.contract
                            AND   s.part_no                    = ssr.part_no
                            AND   s.location_no                = ssr.location_no
                            AND   s.lot_batch_no               = ssr.lot_batch_no
                            AND   s.serial_no                  = ssr.serial_no
                            AND   s.eng_chg_level              = ssr.eng_chg_level
                            AND   s.waiv_dev_rej_no            = ssr.waiv_dev_rej_no
                            AND   s.activity_seq               = ssr.activity_seq
                            AND   s.reserv_handling_unit_id    = ssr.handling_unit_id
                            AND   s.configuration_id           = ssr.configuration_id
                            AND   s.pick_list_no               = ssr.pick_list_no 
                            AND   s.shipment_id                = ssr.shipment_id
                            AND   s.shipment_line_no           = shipment_line_no_) > 0;
   
BEGIN
   shipment_line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
   
   Inventory_Event_Manager_API.Start_Session;
   FOR rec_ IN get_attr LOOP
      quantity_to_add_ := rec_.qty_assigned - NVL(Get_Quantity_On_Shipment(source_ref1_             => source_ref1_,
                                                                              source_ref2_             => source_ref2_,
                                                                              source_ref3_             => source_ref3_,
                                                                              source_ref4_             => source_ref4_, 
                                                                              source_ref_type_db_      => source_ref_type_db_,
                                                                              contract_                => rec_.contract, 
                                                                              part_no_                 => rec_.part_no, 
                                                                              location_no_             => rec_.location_no,
                                                                              lot_batch_no_            => rec_.lot_batch_no, 
                                                                              serial_no_               => rec_.serial_no, 
                                                                              eng_chg_level_           => rec_.eng_chg_level, 
                                                                              waiv_dev_rej_no_         => rec_.waiv_dev_rej_no, 
                                                                              activity_seq_            => rec_.activity_seq, 
                                                                              reserv_handling_unit_id_ => rec_.handling_unit_id,
                                                                              configuration_id_        => rec_.configuration_id, 
                                                                              pick_list_no_            => rec_.pick_list_no, 
                                                                              shipment_id_             => shipment_id_), 0);
      IF (quantity_to_be_added_ = 0) THEN
         remaining_qty_to_attach_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_id_,
                                                                                               source_ref1_,
                                                                                               source_ref2_,
                                                                                               source_ref3_,
                                                                                               source_ref4_,
                                                                                               source_ref_type_db_);
         IF (remaining_qty_to_attach_ != 0) THEN
            shipment_line_handl_unit_qty_ := Shipment_Line_Handl_Unit_API.Get_Quantity(shipment_id_, 
                                                                                       shipment_line_no_, 
                                                                                       handling_unit_id_);

            inv_handl_unit_qty_           := (shipment_line_handl_unit_qty_ * shipment_line_rec_.conv_factor / shipment_line_rec_.inverted_conv_factor);
            shipment_res_handl_unit_qty_  := Get_Line_Attached_Qty(source_ref1_                 => source_ref1_,
                                                                   source_ref2_                 => source_ref2_,
                                                                   source_ref3_                 => source_ref3_,
                                                                   source_ref4_                 => source_ref4_,                                                                    
                                                                   shipment_id_                 => shipment_id_, 
                                                                   shipment_line_no_            => shipment_line_no_,
                                                                   handling_unit_id_            => handling_unit_id_);
         END IF;
         IF (quantity_to_add_ > (inv_handl_unit_qty_ - shipment_res_handl_unit_qty_)) THEN
            quantity_to_add_ := (inv_handl_unit_qty_ - shipment_res_handl_unit_qty_);
         END IF;
      ELSE
         -- when mix_of_blocked exception is thrown, we restrict the handling unit only to connect one reservation per shipment handling unit.
         -- that is why we do the below qty check only if mix_block_excep_handling_ is TRUE.
         IF (mix_block_excep_handling_) THEN
            IF (quantity_to_add_ != quantity_to_be_added_) THEN
               quantity_to_add_ := 0;
            END IF;
         ELSE
            quantity_to_add_ := quantity_to_be_added_;
         END IF;
      END IF;

      IF (quantity_to_add_ > 0) THEN 
         -- If we're attaching something in Shipment Inventory which has another location than the Handling Unit
         -- we won't be able to pack it and need to inform the user that only the ShipmentLineHandlUnit-record qty
         -- is attached.
         
         handling_unit_rec_ := Handling_Unit_API.Get(handling_unit_id_);
         IF (Inventory_Location_API.Get_Location_Type_Db(rec_.contract, rec_.location_no) = Inventory_Location_Type_API.DB_SHIPMENT AND
            (NVL(handling_unit_rec_.contract, rec_.contract) != rec_.contract OR NVL(handling_unit_rec_.location_no, rec_.location_no) != rec_.location_no)) THEN
            Client_SYS.Clear_Info;
            Client_SYS.Add_Info(lu_name_, 'NOTATTACHRES: One or more picked reservations could not be attached due to it being on another location then the Handling Unit.');
            info_ := info_ || Client_SYS.Get_All_Info;
         END IF;
         IF ((quantity_to_be_added_ = 0) OR (quantity_to_be_added_ != 0 AND quantity_to_add_ = quantity_to_be_added_)) THEN
            New_Or_Add_To_Existing(source_ref1_                => source_ref1_,
                                   source_ref2_                => source_ref2_,
                                   source_ref3_                => source_ref3_,
                                   source_ref4_                => source_ref4_,                                    
                                   contract_                   => rec_.contract, 
                                   part_no_                    => rec_.part_no, 
                                   location_no_                => rec_.location_no,
                                   lot_batch_no_               => rec_.lot_batch_no, 
                                   serial_no_                  => rec_.serial_no, 
                                   eng_chg_level_              => rec_.eng_chg_level, 
                                   waiv_dev_rej_no_            => rec_.waiv_dev_rej_no, 
                                   activity_seq_               => rec_.activity_seq, 
                                   reserv_handling_unit_id_    => rec_.handling_unit_id,
                                   configuration_id_           => rec_.configuration_id, 
                                   pick_list_no_               => rec_.pick_list_no, 
                                   shipment_id_                => shipment_id_, 
                                   shipment_line_no_           => shipment_line_no_,
                                   handling_unit_id_  		   => handling_unit_id_,
                                   quantity_to_be_added_       => quantity_to_add_,
                                   catch_qty_to_reassign_      => NULL );
            IF (mix_block_excep_handling_) THEN
               EXIT;
            END IF;
         END IF;                          
      END IF;
   END LOOP;       
   Inventory_Event_Manager_API.Finish_Session;
   
END Add_Reservations_To_Handl_Unit;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Add_Reservations_On_Reassign (
   reservations_attached_     OUT VARCHAR2,
   source_ref1_               IN  VARCHAR2,
   source_ref2_               IN  VARCHAR2,
   source_ref3_               IN  VARCHAR2,
   source_ref4_               IN  VARCHAR2,
   source_ref_type_db_        IN  VARCHAR2,
   from_shipment_id_          IN  NUMBER,
   from_shipment_line_no_     IN  NUMBER,
   handling_unit_id_ 		  IN  NUMBER,
   quantity_to_be_added_      IN  NUMBER )
IS
   reserved_line_count_    NUMBER;
   available_qty_assigned_ NUMBER := 0;
   quantity_to_be_used_    NUMBER := 0;
   qty_available_          NUMBER := 0;
   handling_unit_quantity_ NUMBER := 0;   
   info_                   VARCHAR2(2000);
   
   CURSOR get_available_qty_assigned IS
      SELECT SUM(qty_assigned) 
      FROM  shipment_source_reservation
      WHERE source_ref1          = source_ref1_
      AND   source_ref2          = source_ref2_
      AND   source_ref3          = source_ref3_
      AND   source_ref4          = source_ref4_
      AND   source_ref_type_db   = source_ref_type_db_
      AND   shipment_id          = from_shipment_id_
      AND   (pick_list_no = '*' OR pick_list_no != '*' AND qty_picked > 0) ; 
BEGIN
   reservations_attached_ := 'FALSE';
   OPEN  get_available_qty_assigned;
   FETCH get_available_qty_assigned INTO available_qty_assigned_;
   CLOSE get_available_qty_assigned;
   
   qty_available_ := available_qty_assigned_ - Get_Line_Attached_Qty(source_ref1_,
                                                                     source_ref2_,
                                                                     source_ref3_,
                                                                     source_ref4_,                                                                      
                                                                     from_shipment_id_, 
                                                                     from_shipment_line_no_,
                                                                     NULL);
   IF (NVL(qty_available_, 0) > 0) THEN
      IF (qty_available_ = quantity_to_be_added_) THEN
         quantity_to_be_used_   := 0;
         reservations_attached_ := 'TRUE';   
      ELSE
         reserved_line_count_    := Get_Number_Of_Lines(from_shipment_id_, 
                                                        source_ref1_,
                                                        source_ref2_,
                                                        source_ref3_,
                                                        source_ref4_,
                                                        source_ref_type_db_); 
                                                        
         handling_unit_quantity_ := Shipment_Line_Handl_Unit_API.Get_Quantity(from_shipment_id_, 
                                                                              from_shipment_line_no_, 
                                                                              handling_unit_id_);
         IF ((reserved_line_count_ = 1) AND (qty_available_ >= quantity_to_be_added_) AND (quantity_to_be_added_ = handling_unit_quantity_)) THEN         
            quantity_to_be_used_   := quantity_to_be_added_;
            reservations_attached_ := 'TRUE';       
         END IF;
      END IF;
      
      IF (reservations_attached_ = 'TRUE') THEN   
         Add_Reservations_To_Handl_Unit(info_,
                                        source_ref1_,
                                        source_ref2_,
                                        source_ref3_,
                                        source_ref4_,  
                                        source_ref_type_db_,
                                        from_shipment_id_, 
                                        from_shipment_line_no_,
                                        handling_unit_id_,
                                        quantity_to_be_used_);
      END IF;
   END IF;
END Add_Reservations_On_Reassign;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Number_Of_Lines (
   shipment_id_         IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER 
IS
   count_            NUMBER;
   shipment_line_no_ NUMBER;
   CURSOR get_reservation IS
      SELECT count(*)
      FROM shipment_source_reservation ssr
      WHERE source_ref1          = source_ref1_
      AND   source_ref2          = source_ref2_
      AND   source_ref3          = source_ref3_
      AND   source_ref4          = source_ref4_
      AND   source_ref_type_db   = source_ref_type_db_
      AND   shipment_id          = shipment_id_
      AND   qty_assigned - (SELECT NVL(SUM(quantity), 0)
                            FROM shipment_reserv_handl_unit_tab s
                            WHERE s.source_ref1             = ssr.source_ref1
                            AND   s.source_ref2             = ssr.source_ref2
                            AND   s.source_ref3             = ssr.source_ref3
                            AND   s.source_ref4             = ssr.source_ref4                            
                            AND   s.contract                = ssr.contract
                            AND   s.part_no                 = ssr.part_no
                            AND   s.location_no             = ssr.location_no
                            AND   s.lot_batch_no            = ssr.lot_batch_no
                            AND   s.serial_no               = ssr.serial_no
                            AND   s.eng_chg_level           = ssr.eng_chg_level
                            AND   s.waiv_dev_rej_no         = ssr.waiv_dev_rej_no
                            AND   s.activity_seq            = ssr.activity_seq
                            AND   s.reserv_handling_unit_id = ssr.handling_unit_id
                            AND   s.configuration_id        = ssr.configuration_id
                            AND   s.pick_list_no            = ssr.pick_list_no 
                            AND   s.shipment_id             = ssr.shipment_id
                            AND   s.shipment_line_no        = shipment_line_no_) > 0;
BEGIN
   -- since source_ref2, source_ref3, source_ref4 can contain "*", we need to convert back to NULL when calling shipment line.
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                       source_ref1_, 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4), source_ref_type_db_);
   OPEN get_reservation;
   FETCH get_reservation INTO count_;
   CLOSE get_reservation;
   RETURN count_;
END Get_Number_Of_Lines;


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
@UncheckedAccess
FUNCTION Get_Remain_Res_To_Hu_Connect (
   shipment_id_         IN NUMBER,
   source_ref1_         IN VARCHAR2,
   source_ref2_         IN VARCHAR2,
   source_ref3_         IN VARCHAR2,
   source_ref4_         IN VARCHAR2,
   source_ref_type_db_  IN VARCHAR2) RETURN NUMBER
IS
   remain_res_to_hu_connect_   NUMBER:=0;
   shipment_line_no_           NUMBER;
   quantity_connected_         NUMBER;
   
   CURSOR get_reservation_info IS
      SELECT qty_assigned,
             contract,
             part_no,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             activity_seq,
             handling_unit_id,
             configuration_id,
             pick_list_no
      FROM shipment_source_reservation ssr
      WHERE source_ref1         = source_ref1_
      AND source_ref2         = source_ref2_
      AND source_ref3         = source_ref3_
      AND source_ref4         = source_ref4_
      AND source_ref_type_db  = source_ref_type_db_
      AND shipment_id  = shipment_id_
      AND qty_assigned - (SELECT NVL(SUM(quantity), 0)
                          FROM shipment_reserv_handl_unit_tab s
                          WHERE s.source_ref1             = ssr.source_ref1
                          AND s.source_ref2             = ssr.source_ref2
                          AND s.source_ref3             = ssr.source_ref3
                          AND s.source_ref4             = ssr.source_ref4
                          AND s.contract                = ssr.contract
                          AND s.part_no                 = ssr.part_no
                          AND s.location_no             = ssr.location_no
                          AND s.lot_batch_no            = ssr.lot_batch_no
                          AND s.serial_no               = ssr.serial_no
                          AND s.eng_chg_level           = ssr.eng_chg_level
                          AND s.waiv_dev_rej_no         = ssr.waiv_dev_rej_no
                          AND s.activity_seq            = ssr.activity_seq
                          AND s.configuration_id        = ssr.configuration_id
                          AND s.reserv_handling_unit_id = ssr.handling_unit_id
                          AND s.pick_list_no            = ssr.pick_list_no 
                          AND s.shipment_id             = ssr.shipment_id
                          AND s.shipment_line_no        = shipment_line_no_) > 0;
                                
   reservation_rec_ get_reservation_info%ROWTYPE;  
BEGIN
   -- Since source_ref2, source_ref3, source_ref4 can contain "*", we need to convert back to NULL when calling shipment line.
   shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(shipment_id_, 
                                                                       source_ref1_, 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref2_, source_ref_type_db_, 2), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref3_, source_ref_type_db_, 3), 
                                                                       Shipment_Line_API.Get_Converted_Source_Ref(source_ref4_, source_ref_type_db_, 4), source_ref_type_db_);
   OPEN get_reservation_info;
   FETCH get_reservation_info INTO reservation_rec_;
   IF (get_reservation_info%FOUND) THEN
      quantity_connected_:= Get_Quantity_On_Shipment(source_ref1_,
                                                     source_ref2_, 
                                                     source_ref3_,
                                                     source_ref4_,
                                                     source_ref_type_db_,
                                                     reservation_rec_.contract,
                                                     reservation_rec_.part_no,
                                                     reservation_rec_.location_no,
                                                     reservation_rec_.lot_batch_no,
                                                     reservation_rec_.serial_no,
                                                     reservation_rec_.eng_chg_level,
                                                     reservation_rec_.waiv_dev_rej_no,
                                                     reservation_rec_.activity_seq,
                                                     reservation_rec_.handling_unit_id,
                                                     reservation_rec_.configuration_id,
                                                     reservation_rec_.pick_list_no,
                                                     shipment_id_);
      remain_res_to_hu_connect_ := (reservation_rec_.qty_assigned - NVL(quantity_connected_, 0));                                                                              
   END IF;
   CLOSE get_reservation_info;
   RETURN remain_res_to_hu_connect_;
END Get_Remain_Res_To_Hu_Connect; 


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
-- This method is used in Handle_Ship_Invent_Utility_API.Move_To_Shipment_Location and returns the quantity that will 
-- be able to be packed if we are to move the reservation to the 'to_location_no'.
@UncheckedAccess
PROCEDURE Get_Valid_Qty_To_Be_Packed (
   qty_to_pack_               OUT NUMBER,
   catch_qty_to_pack_         OUT NUMBER,
   source_ref1_               IN VARCHAR2,       
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   to_location_no_            IN VARCHAR2,
   handling_unit_id_ 		   IN NUMBER )
IS
   CURSOR get_valid_qty IS
      SELECT NVL(SUM(quantity), 0) quantity, SUM(catch_qty_to_reassign) catch_quantity
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE source_ref1               = source_ref1_
         AND source_ref2               = source_ref2_
         AND source_ref3               = source_ref3_
         AND source_ref4               = source_ref4_
         AND contract                  = contract_
         AND part_no                   = part_no_
         AND location_no               = location_no_
         AND lot_batch_no              = lot_batch_no_
         AND serial_no                 = serial_no_
         AND eng_chg_level             = eng_chg_level_
         AND waiv_dev_rej_no           = waiv_dev_rej_no_
         AND activity_seq              = activity_seq_
         AND reserv_handling_unit_id   = reserv_handling_unit_id_
         AND configuration_id          = configuration_id_
         AND pick_list_no              = pick_list_no_
         AND shipment_id               = shipment_id_
         AND shipment_line_no          = shipment_line_no_
         AND NVL(Handling_Unit_API.Get_Location_No(handling_unit_id), to_location_no_) = to_location_no_
         -- If the handling_unit_id and reserv_handling_unit_id are the same we don't need to do any repacking.
         AND handling_unit_id         != reserv_handling_unit_id
         AND (handling_unit_id = handling_unit_id_ OR handling_unit_id_ IS NULL);
BEGIN
   OPEN get_valid_qty;
   FETCH get_valid_qty INTO qty_to_pack_, catch_qty_to_pack_;
   CLOSE get_valid_qty;
END Get_Valid_Qty_To_Be_Packed;

PROCEDURE Remove_Without_Unpack (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER )
IS
      CURSOR get_records IS
         SELECT *
           FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
          WHERE shipment_id = shipment_id_
            AND handling_unit_id IN (SELECT handling_unit_id
                                       FROM handling_unit_pub 
                                    CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                      START WITH       handling_unit_id = handling_unit_id_);            
BEGIN
   FOR rec_ IN get_records LOOP
      Remove_Without_Unpack(rec_.source_ref1, 
                            rec_.source_ref2, 
                            rec_.source_ref3, 
                            rec_.source_ref4, 
                            rec_.contract, 
                            rec_.part_no, 
                            rec_.location_no, 
                            rec_.lot_batch_no, 
                            rec_.serial_no, 
                            rec_.eng_chg_level, 
                            rec_.waiv_dev_rej_no, 
                            rec_.activity_seq, 
                            rec_.reserv_handling_unit_id, 
                            rec_.configuration_id, 
                            rec_.pick_list_no, 
                            rec_.shipment_id, 
                            rec_.shipment_line_no, 
                            rec_.quantity);
   END LOOP;      
END Remove_Without_Unpack; 


-- Make sure to send the parameters for source ref columns as NVL(source_ref2,'*') when you calling this method from shipment side.
PROCEDURE Remove_Without_Unpack(
   source_ref1_               IN VARCHAR2,
   source_ref2_               IN VARCHAR2,
   source_ref3_               IN VARCHAR2,
   source_ref4_               IN VARCHAR2,   
   contract_                  IN VARCHAR2,
   part_no_                   IN VARCHAR2,
   location_no_               IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   eng_chg_level_             IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   activity_seq_              IN NUMBER,
   reserv_handling_unit_id_   IN NUMBER,
   configuration_id_          IN VARCHAR2,
   pick_list_no_              IN VARCHAR2,
   shipment_id_               IN NUMBER,
   shipment_line_no_          IN NUMBER,
   quantity_                  IN NUMBER)
IS
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   oldrec_     SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
   newrec_     SHIPMENT_RESERV_HANDL_UNIT_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
   
   CURSOR get_records IS
      SELECT *
      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
      WHERE source_ref1                = source_ref1_
      AND   source_ref2                = source_ref2_
      AND   source_ref3                = source_ref3_
      AND   source_ref4                = source_ref4_       
      AND   contract                   = contract_
      AND   part_no                    = part_no_
      AND   location_no                = location_no_
      AND   lot_batch_no               = lot_batch_no_
      AND   serial_no                  = serial_no_
      AND   eng_chg_level              = eng_chg_level_
      AND   waiv_dev_rej_no            = waiv_dev_rej_no_
      AND   activity_seq               = activity_seq_
      AND   reserv_handling_unit_id    = reserv_handling_unit_id_
      AND   configuration_id           = configuration_id_
      AND   pick_list_no               = pick_list_no_
      AND   shipment_id                = shipment_id_
      AND   shipment_line_no           = shipment_line_no_;
BEGIN
   FOR rec_ IN get_records LOOP
      IF (quantity_ < rec_.quantity) THEN
         Get_Id_Version_By_Keys___(objid_, 
                                   objversion_, 
                                   source_ref1_,
                                   source_ref2_,
                                   source_ref3_,
                                   source_ref4_,                                
                                   contract_, 
                                   part_no_, 
                                   location_no_, 
                                   lot_batch_no_, 
                                   serial_no_,
                                   eng_chg_level_, 
                                   waiv_dev_rej_no_, 
                                   activity_seq_, 
                                   reserv_handling_unit_id_,
                                   configuration_id_, 
                                   pick_list_no_, 
                                   shipment_id_, 
                                   shipment_line_no_,
                                   rec_.handling_unit_id);

         oldrec_ := Lock_By_Id___(objid_, objversion_);
         newrec_ := oldrec_;
         newrec_.quantity := oldrec_.quantity - quantity_;
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_              => objid_, 
                   oldrec_             => oldrec_, 
                   newrec_             => newrec_, 
                   attr_               => attr_, 
                   objversion_         => objversion_, 
                   unpack_in_ship_inv_ => FALSE);
      ELSE
         Check_Delete___(rec_);
         Delete___(objid_              => NULL, 
                   remrec_             => rec_, 
                   unpack_in_ship_inv_ => FALSE);
      END IF;
   END LOOP;  
END Remove_Without_Unpack;


@UncheckedAccess
FUNCTION Get_Quantity_On_Shipment (
   shipment_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ SHIPMENT_RESERV_HANDL_UNIT_TAB.quantity%TYPE;
   
   CURSOR get_shipment_quantity IS
      SELECT NVL(SUM(quantity),0)
        FROM SHIPMENT_RESERV_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_;
BEGIN
   OPEN get_shipment_quantity;
   FETCH get_shipment_quantity INTO temp_;
   CLOSE get_shipment_quantity;
   RETURN temp_;
END Get_Quantity_On_Shipment;

----------------------- PACKING SPECIFIC PUBLIC METHODS ---------------------

-- This method is used by DataCaptUnpackHuShip
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
   handling_unit_id_              IN NUMBER,  
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2, 
   capture_session_id_            IN NUMBER,
   column_name_                   IN VARCHAR2,
   lov_type_db_                   IN VARCHAR2,
   sql_where_expression_          IN VARCHAR2 DEFAULT NULL )  -- TODO: sql_where_expression_ could be removed since its not used from calling process
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
      Assert_SYS.Assert_Is_View_Column('UNPACK_PART_HU_SHIP_PROCESS', column_name_);

      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK
         stmt_ := 'SELECT ' || column_name_;
      ELSE
         stmt_ := 'SELECT DISTINCT ' || column_name_;
      END IF;

      stmt_ := stmt_  || ' FROM UNPACK_PART_HU_SHIP_PROCESS
                           WHERE ship_inv_qty > 0 ';
      IF shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
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
      IF parent_consol_shipment_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
      ELSIF parent_consol_shipment_id_ = -1 THEN
         stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
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
      stmt_ := stmt_ || ' AND contract = :contract_ '; 
      
      IF (sql_where_expression_ IS NOT NULL) THEN
       stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
   
      @ApproveDynamicStatement(2017-10-25,SUCPLK)
      OPEN get_lov_values_ FOR stmt_ USING shipment_id_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref_type_db_,
                                           parent_consol_shipment_id_,
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
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(shp_rec_.receiver_id, shp_rec_.receiver_type);
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
                                                                             sql_where_expression_          => NULL);
                     second_column_value_ := Shipment_Source_Utility_API.Get_Source_Part_Desc(contract_            => contract_,
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
                                                                       sql_where_expression_          => NULL);
                     shp_rec_ := Shipment_API.Get(local_shipment_id_);
                     second_column_value_ := Shipment_Source_Utility_API.Get_Receiver_Name(shp_rec_.receiver_id, shp_rec_.receiver_type);
                  ELSIF (second_column_name_ = 'LOCATION_DESC') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
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


-- This method is used by DataCaptUnpackHuShip
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
   handling_unit_id_           IN NUMBER,  
   sscc_                       IN VARCHAR2,
   alt_handling_unit_label_id_ IN VARCHAR2, 
   column_name_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2    -- TODO: sql_where_expression_ could be removed since its not used from calling process
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(8000);
   unique_column_value_           VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_              Column_Value_Tab; 
BEGIN
   Assert_SYS.Assert_Is_View_Column('UNPACK_PART_HU_SHIP_PROCESS', column_name_);
   stmt_ := 'SELECT DISTINCT ' || column_name_ || '
             FROM UNPACK_PART_HU_SHIP_PROCESS
             WHERE ship_inv_qty > 0 ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
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
   IF parent_consol_shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
   ELSIF parent_consol_shipment_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
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
   stmt_ := stmt_ || ' AND contract = :contract_ '; 

             
   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;


   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2017-10-25,SUCPLK)
   OPEN get_column_values_ FOR stmt_ USING shipment_id_,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_,
                                           source_ref_type_db_,
                                           parent_consol_shipment_id_,
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


-- This method is used by DataCaptUnpackHuShip
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
   handling_unit_id_              IN NUMBER, 
   sscc_                          IN VARCHAR2,
   alt_handling_unit_label_id_    IN VARCHAR2, 
   column_name_                   IN VARCHAR2,
   column_value_                  IN VARCHAR2,
   column_description_            IN VARCHAR2,
   sql_where_expression_          IN VARCHAR2 DEFAULT NULL )  -- TODO: sql_where_expression_ could be removed since its not used from calling process
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(8000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN

   Assert_SYS.Assert_Is_View_Column('UNPACK_PART_HU_SHIP_PROCESS', column_name_);

   stmt_ := ' SELECT 1
              FROM  UNPACK_PART_HU_SHIP_PROCESS
              WHERE ship_inv_qty > 0 ';
   IF shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :shipment_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND shipment_id = :shipment_id_';
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
   IF parent_consol_shipment_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND parent_consol_shipment_id is NULL AND :parent_consol_shipment_id_ IS NULL';
   ELSIF parent_consol_shipment_id_ = -1 THEN
      stmt_ := stmt_ || ' AND :parent_consol_shipment_id_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND parent_consol_shipment_id = :parent_consol_shipment_id_';
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
   stmt_ := stmt_ || ' AND contract = :contract_ '; 

   
   stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';

   IF (sql_where_expression_ IS NOT NULL) THEN
    stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;

   @ApproveDynamicStatement(2017-10-26,SUCPLK)
   OPEN exist_control_ FOR stmt_ USING shipment_id_,
                                       source_ref1_,
                                       source_ref2_,
                                       source_ref3_,
                                       source_ref4_,
                                       source_ref_type_db_,
                                       parent_consol_shipment_id_,
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
