------------------------------------------------------------------------------
--
--  Logical unit: ShipmentLineHandlUnit
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  220810  PamPlk   SCDEV-13135, Modified Mixed_Part_Numbers_Connected to support for no parts.
--  220711  PamPlk   SCDEV-12451, Modified Check_Unique_Part_Connected to support for no parts.
--  210816  RoJalk   SC21R2-787, Modified Check_Delete___ and changed the validation to check for delivered shipments instead of Completed and Closed.  
--  210325  ThKrlk   Bug 157855(SCZ-14013), Modified Reduce_Quantity() by adding new condition to avoild fraction difference.
--  210202  RasDlk   SC2020R1-11817, Modified Remove_Or_Modify by reducing number of calls to increase the performance.
--  200728  Aabalk   SCXTEND-4364, Added function Get_Operative_Net_Weight to return net weight of the handling unit connected shipment line. Modified Update___ so that shipment flags
--  200728           are reset and shipment freight charges recalculated when manual net weight is modified.
--  200708  Aabalk   Bug 154227 (SCZ-10285), Modified Get_Connected_Part_Weight() method to take into consideration the weight from the configuration specification if available.
--  200513  ChFolk   Bug 153521(SCZ-9877), Added new default parameter attach_full_qty_ to New_Or_Add_To_Existing and based on that the server value for remaining qty is taken inorder to avoid
--  200513           small fractional differences when different UoMs and conversion factors with decimal values are used between Sales and Inventory UoMs.
--  200504  ChFolk   Bug 153678(SCZ-9946), Modified Get_Connected_Part_Volume to get the value for conversion_factor from shipment line when base UoM are not equal.
--  200413  Aabalk   Bug 153107(SCZ-9691), Modified New_Or_Add_To_Existing(), Modify___ and New() methods by adding the manual net weight as a parameter. Modifed Check_Update___ to clear the
--  200413           manual net weight when the quantity is changed.
--  200407  ChFolk   Bug 153114(SCZ-8841), Modified Modify___  and Check_Quantity___ by adding new parameter release_not_reserved_ and modifed the existing usages with FALSE value.
--  200407           Modified method Remove_Or_Modify by adding new parameters qty_modification_source_ and prev_inv_qty_ which are used to update the quantity when multiple handling units are connected
--  200407           when Releasing not Reserved quantity.
--  200317  DhAplk   Bug 152541 (SCZ-8879), Modified Check_Quantity___(), Check_Insert___(), Check_Update___(), Modify___(), New() and New_Or_Add_To_Existing() methods to avoid quantity comparison process in Check_Quantity___()
--  200317		      within Report Picking scenario by passing a parameter through method stack. Modified Remove_Or_Modify() and Reduce_Quantity() also.
--  200316  Aabalk   Bug 152790(SCZ-8697), Overrode Check_Common___ to allow only positive values for manual net weight. Modified Get_Connected_Part_Weight() to use manual net weight when specified.
--  200311  DhAplk   Bug 152533 (SCZ-9094), Modified Remove_Unattached_Qty() to pass the ship_reserv_qty in sales UoM.
--  200108  RuLiLk   Bug Bug 151700, SCZ-8251, Modified method Get_Connected_Part_Weight to correct net weight calculations.
--  190925  WaSalk   Bug 147889 (SCZ-5545), Modifid Delete___() to use App_Context_SYS value SHIPMENT_LINE_REASSIGNING_ to not to loose manual gross weight values when reassigning Handling units.
--  180813  SBalLK   Bug 149413 (SCZ-6113), Modified New_Or_Add_To_Existing() method to not reset manually entered weight, volume and not to validate mix handling unit of the already defined handling units in the inventory.
--  180307  RaVdlk  STRSC-17471, Removed installation errors from sql plus tool
--  171229  KiSalk   STRSC-4491, Rephrased warning message in Remove_Or_Modify to imply that this reassign is likely to remove attached shipment lines rather than saying this will definitely remove them.
--  171215  MaRalk   STRSC-14055, Overide Check_Delete___ in order to restrict deleting the shipment line handling unit once shipment is closed.
--  171212  KiSalk   STRSC-4491, (Bug 132102 also fixed) Added modify_reserv_ parameter to Reduce_Quantity and Modify___. Modified Update___ to conditionally call  
--  171212           Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify depending on the value of MODIFY_RESERVE passed through attr_.
--  171204  RoJalk   STRSC-13892, Modified Insert___, Update___ and Delete___ to reset bill of lading flag when HU qty is changed.
--  171124  MaAuse   STRSC-14357, Modified New_Or_Add_To_Existing by removing parameter error_at_max_hu_capacity_.
--  171120  MaAuse   STRSC-14470, Modified New_Or_Add_To_Existing by adding parameter error_at_max_hu_capacity_.
--  171110  SucPlk   STRSC-13894, Converted back the public method Modify to an implementation method.
--  171108  SucPlk   STRSC-13894, Converted the implementation method Modify___ to a public method in order to support UNPACK_PART_FROM_HU_SHIP wadaco process.
--  171027  RoJalk   STRSC-13805, Modified Insert___ , Update___ and Delete___ called Shipment_API.Reset_Printed_Flags__.
--  170609  Jhalse   LIM-11487, Removed method Remove_Manual_Volume___ as it already did the same validations as a current method in Handling_Unit_API
--  170508  Chfose   STRSC-5503, Changed the function Get_Connected_Part_Weight to a procedure. Modified the method Get_Connected_Part_Volume.
--  170503  RoJalk   Bug 130169, Added Get_Shipment_Qty_For_Inv_Parts(). 
--  170223  MaIklk   LIM-9422, Fixed to pass shipment_line_no as parameter when calling ShipmentReservHandlUnit methods.
--  170202  Chfose   LIM-10117, Modified handling unit information to be fetched through SHPMNT_HANDL_UNIT_WITH_HISTORY to properly include HandlingUnitHistory when applicable.
--  170202           Also added shipment_id to methods that took only handling unit id.
--  170127  MaIklk   LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  170111  MaRalk   LIM-6755, Modified error message QTYTOLARGE in Check_Quantity___ method
--  170111           in order to include shipment line no instead of source references.
--  170106  DilMlk   Bug 132613, Modified function Get_Connected_Part_Weight(), to fetch correct net weight of inventory part no to shipment handling unit,
--  161228           when sales part no is different from associated inventory part no.
--  161220  Jhalse   LIM-10062, Modified remove handling unit to handle cases were the whole HU structure should be removed.
--  161214  Chfose   LIM-3663, Added new method Remove_Unattached_Qty for removing records/qty without any connected ShipmentReservHandlUnit-records.
--  161206  MeAblk   Bug 132985, Modified Reduce_Quantity() to correctly reduce the handling unit attched qty when cancelling the attaching process.
--  161128  MaIklk   LIM-9255, Fixed to directly access ShipmentReservHandlUnit since it is moved to SHPMNT.
--  161017  DaZase   LIM-8969, Added method Check_Quantity as public interface to Check_Quantity___ so it can be used from wadaco process.
--  160623  JeeJlk   Bug 129483, Modified Remove_Or_Modify not to modify the quantity if it is not a quantity deduction.
--  160603  RoJalk   LIM-6813, Changed the scope of New___, Remove___ to be public. Moved Reassign_Handling_Unit to ReassignShipmentUtility.
--  160602  RoJalk   LIM-6813, Added methods Lock__,  Remove. 
--  160503  RoJalk   LIM-7310, Renamed Shipment_Handling_Utility_API.Get_Remain_Parcel_Qty to Get_Remaining_Qty_To_Attach.
--  160503           Removed source info from Remove_Or_Modify method. 
--  160427  RoJalk   LIM-7267, Changed the parameter order of Shipment_Line_Handl_Unit_API.New_Or_Add_To_Existing.
--  160422  MaRalk   LIM-7229, Modified Get_Inventory_Quantity by removing order_no, line_no_, rel_no, line_item_no 
--  160422           parameters and by calling Shipment_Handling_Utility_API.Get_Converted_Inv_Qty inside the logic.
--  160422           Modified Reassign_Handling_Unit, Get_Shipment_Line_Inv_Qty by calling 
--  160422           Shipment_Handling_Utility_API.Get_Converted_Inv_Qty instead of direct calculation.
--  160416  RoJalk   LIM-6950, Modified Reduce_Quantity and changed shipment_line_no_ to be NOT NULL. 
--  160412  RoJalk   LIM-6631, Added NVL handling for source ref comparisons since it can be null.
--  160331  RoJalk   LIM-6585, Added the method Get_Reserv_Qty_Left_To_Assign.
--  160328  MaRalk   LIM-6591, Modified Reassign_Handling_Unit - get_connected_lines cursor 
--  160328           by fetching shipment line source_unit_meas, conv_factor, inverted_conv_factor values.
--  160328           Modified Get_Connected_Part_Weight, Get_Connected_Part_Volume, Check_Quantity___,  
--  160328           Get_Inventory_Quantity, Reassign_Handling_Unit, Get_Shipment_Line_Inv_Qty by removing the use of 
--  160328           Shipment_Source_Utility_API-Get_Line, Get_Sales_Unit_Meas, Get_Converted_Inv_Qty and 
--  160328           instead used shipment line values.
--  160308  MaRalk   LIM-5871, Modified source_ref4_ as a string parameter in the method call Get_Shipment_Line_Inv_Qty
--  160314  RoJalk   LIM-6511, Modified Reassign_Handling_Unit and passed source part info to Shipment_Line_API.Reassign_Line__(.
--  160311  RoJalk   LIM-6556, Removed the method Get_Reserv_Hu_Attached_Qty and replaced with Get_Line_Attached_Reserv_Qty.
--  160306  RoJalk   LIM-6321, Modified Reassign_Handling_Unit and passed to_shipment_line_no_ to New___,
--  160306           Shipment_Source_Utility_API.Reassign_Reserv_Handl_Unit. 
--  160229  RoJalk   LIM-4627, Replaced Get_Sales_Unit_Meas___ with Shipment_Source_Utility_API.Get_Sales_Unit_Meas.
--  160224  RoJalk   LIM-4184, Modified Get_Connected_Part_Weight, Get_Connected_Part_Volume to fetch info using 
--  160224           Shipment_Source_Utility_API.Get_Line to make methods generic,
--  160216  RoJalk   LIM-4659, Modified Reassign_Handling_Unit and replaced Shipment_Reserv_Handl_Unit_API.Reassign_Handl_Unit
--  160216           with Shipment_Source_Utility_API.Reassign_Reserv_Handl_Unit. 
--  160215  RoJalk   LIM-4659, Modified Reassign_Handling_Unit to fetch the part info from SHIPMENT_LINE_TAB. 
--  160215           Called Shipment_Source_Utility_API.Get_Reserv_Hu_Attached_Qty to make the method generic. 
--  160211  RoJalk   LIM-5934, Remove source info, modified Check_Quantity___, Check_Update___, Update___,
--  160211           New___, Check_Insert___, Modify__, New_Or_Add_To_Existing,  Remove_Or_Modify,  Remove_Or_Modify
--  160211           Reassign_Handling_Unit, Reduce_Quantity, Mixed_Part_Numbers_Connected, Get_Connected_Part_Weight,
--  160211           Get_Connected_Part_Volume,  Check_Unique_Part_Connected, Check_One_Ship_Line_Connected.
--  160205  RoJalk   LIM-4246, Modified code to support new key combination of shipment id, handling unit id and shipment line no.
--  160202  RoJalk   LIM-4661, Added the method call Shipment_Source_Utility_API.Handle_Hu_Qty_Change to Update___, Modify__.
--  160102  RoJalk   LIM-4186, Added method Get_Sales_Unit_Meas___ and called from Check_Quantity___, Remove_Or_Modify.
--  160102           Modified Check_Unique_Part_Connected, Mixed_Part_Numbers_Connected to fetch part info from SHIPMENT_LINE_TAB.
--  160102           Called Shipment_Source_Utility_API.Get_Converted_Inv_Qty from Get_Inventory_Quantity to make it generic.
--  160128  RoJalk   LIM-5911, Added shipment_line_no_ parameter to Modify___, Remove___.
--  160128  RoJalk   LIM-5387, Added shipment_line_no to Customer_Order_Reservation_API.Add_Reservations_On_Reassign call. 
--  160126  RoJalk   LIM-5911, Added shipment_line_no_ to the method Check_Quantity___.
--  160122  MaIklk   LIM-5751, Added Get_Shipment_Line_Inv_Qty().
--  160121  RoJalk   LIM-5989, Included shipment_line_no in Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify method call.
--  160120  RoJalk   LIM-5910, Added shipment_line_no_ to Shipment_Line_Handl_Unit_API.Remove_Or_Modify, Reduce_Quantity.
--  160120  RoJalk   LIM-5910, Added shipment_line_no_to Remove_Or_Modify.
--  160120  RoJalk   LIM-5911, Added shipment_line_no_ to New___, New_Or_Add_To_Existing. 
--  160106  MaIklk   LIM-5750, Passed source_ref_type paramter for the Shipment_Handling_Utility_API.Get_Remain_Parcel_Qty().
--  151202  RoJalk   LIM-5178, Rename ORDER_NO, LINE_NO, REL_NO, LINE_ITEM_NO to SOURCE_REF1,
--  151202           SOURCE_REF2, SOURCE_REF3, SOURCE_REF4 in ShipmentLine and ShipmentLineHandlUnit. 
--  151119  RoJalk   LIM-4886, Make Shipment Line Generic - Rename SALES_QTY to SHIPMENT_QTY, REVISED_QTY_DUE to INVENTORY_QTY.
--  151110  RoJalk   LIM-4610, Rename ShipmentOrderLine LU to ShipmentLine.
--  150112  RoJalk   EAP-407, Modified Insert___,Delete___ and passed on_reassign_ to identify the reassign HU functionality and skip the removel of Manual Gross Weight, Manual Volume.
--  140820  RoJalk   Overrien Check_Update___ to include the Check_Quantity___ call which was a bug after refactoring.
--  140815  RoJalk   Modified Modify__ and added code to fetch the value for newrec_.
--  140506  RoJalk   Modified Reassign_Handling_Unit and included a validation to check for shipment and order supply countries.
--  140410  MaEelk   Modified Get_Connected_Part_Weight to make conversions between sales part uom and inventory part uom correctly.
--  140321  MeAblk   Added new method Get_No_Of_Handling_Units.
--  130830  RoJalk   Modified Reassign_Handling_Unit and used public get method to fetch shipment line information.
--  130828  JeLise   Added new method Reduce_Quantity.
--  130820  RoJalk   Modified Reassign_Handling_Unit and used Shipment_Handling_Utility_API.Get_Qty_To_Ship_Reassign to fetch qty_to_ship reassign qty.
--  130819  JeLise   Changed the error message NOTENOUGHRESERVED in Reassign_Handling_Unit.
--  130816  MaEelk   Modified Get_Connected_Part_Weight and Get_Connected_Part_Volume to consider the sales part's UOM and part catalog's UOM as well during the calculation.
--  130813  MeAblk   Modified view HANDLING_UNIT_SHIPMENT_UIV. 
--  130805  MaEelk   Removed the parameter comparing_part_no_ from Mixed_Part_Numbers_Connected. 
--  130805           Called Check_Allow_Mix___ just after tthe insert statement instead of calling it from Unpack_Check_Insert___.
--  130723  MaMalk   Removed unused parameter old_quantity_ from Remove_Or_Modify.
--  130716  MeAblk   Added new UIV HANDLING_UNIT_SHIPMENT_UIV.
--  130620  JeLise   Added method Get_Inventory_Quantity and call to it from SHIPMENT_LINE_HANDL_UNIT_RES and changed to calling 
--  130620           Customer_Order_Reservation_API.Get_Qty_Left_To_Assign to get the reserved_qty_left_to_attach.
--  130619  MeAblk   Added new methods Check_Hu_Con_One_Ship_Line, Get_Sub_Struct_Connected_Qty. 
--  130619  MaEelk   Removed the parameter mix_of_blocked_attrib_changed from the call to Handling_Unit_API.Check_Allow_Mix.
--  130618  JeLise   Added reserved_qty_left_to_attach to view SHIPMENT_LINE_HANDL_UNIT_RES.
--  130618  JeLise   Added another check on only_check_ in Remove_Or_Modify.
--  130618  RoJalk   Renamed the method Get_Qty_On_Handling_Unit to Get_Line_Attached_Qty.
--  130611  RoJalk   Modified Reassign_Handling_Unit and called Shipment_Order_Line_API.Update_Source_On_Reassign__ only if not reserved qty is reassigned.
--  130610  MeAblk   Renamed method One_Ship_Line_Connected into Check_Unique_Part_Connected. Added new method Check_One_Ship_Line_Connected. 
--  130607  MaEelk   Added a new parameter comparing_part_no_ to Mixed_Part_Numbers_Connected. This would support the method to validate
--                   over tthe part number if it is given. Added Check_Allow_Mix___ to make a validation over blocking part numbers when connection a lipment order line to an HU.
--  130607  RoJalk   Modified Reassign_Handling_Unit and changed the parameters to the method Shipment_Order_Line_API.Update_Source_On_Reassign__.
--  130605  RoJalk   Modified Reassign_Handling_Unit and changed the parameter release_reservations_ to be BOOLEAN.
--  130531  RoJalk   Code improvements to the methods.
--  130528  MeAblk   Removed method Check_Handl_Unit_Ship_Line_Con.
--  130528  RoJalk   Modified Reassign_Handling_Unit and included code to automatically attach reservations. 
--  130526  MeAblk   Added methods One_Ship_Line_Connected, Get_Handl_Unit_Connected_Qty, Check_Handl_Unit_Ship_Line_Con.
--  130524  JeLise   Change from calling Handling_Unit_Exist to calling Handling_Unit_API.Check_Exist in Delete___.
--  130523  MaEelk   Added Remove_Manual_Volume___ and did changes to remove manual volume only when the HU has additive volume and if it has accessories having additive volume.
--  130522  RoJalk   Modified Reassign_Handling_Unit to support non inventory parts.
--  130521  RoJalk   Modified Reassign_Handling_Unit and restructured the validations.
--  130520  RoJalk   Modified Reassign_Handling_Unit and corrected the error text for PKGPARTEXIST message.
--  130517  RoJalk   Modified Reassign_Handling_Unit and included a validation to check package parts.
--  130517  RoJalk   Modified Reassign_Handling_Unit and corrected UOM conversion errors.
--  130516  RoJalk   Modified Reassign_Handling_Unit and called Shipment_Order_Line_API.Update_Source_On_Reassign__ to update the destination shipment.
--  130515  RoJalk   Modified Reassign_Handling_Unit and changed the order of method calls so the shipment_line_handl_unit_tab recoord will be created first.
--  130515  RoJalk   Removed Modify_Shipment_Id___ from Reassign_Handling_Unit and replaced with New___ and Remove___
--  130515  RoJalk   Modified  Reassign_Handling_Unit and included qty related validations.
--  130513  RoJalk   Modified Reassign_Handling_Unit and removed source_revised_qty_due_,  source_sales_qty_  parameters from Shipment_Order_Line_API.Reassign_Order_Line__ method call.
--  130513  RoJalk   Modified Reassign_Handling_Unit and corrected the number of parameters to Shipment_Order_Line_API.Reassign_Order_Line__.
--  130511  RoJalk   Added the methods Reassign_Handling_Unit, Modify_Shipment_Id___. 
--  130507  MaEelk   Made a call to Handling_Unit_API.Remove_Manual_Volume from Insert___, Update___ and Delete___ methods.
--  130503  RoJalk   Modified error text REMOVELINES in Remove_Or_Modify and replaced sales qty with connected sales qty. 
--  130423  MeAblk   Added new view SHIPMENT_LINE_HANDL_UNIT_UIV.
--  130419  MaEelk   Added Get_Connected_Part_Volume to calculate the volume of all parts connected to a specific handling unit.
--  130418  JeLise   Added method Shipment_Exist.
--  130417  JeLise   Added methods Handling_Unit_Exist and Remove_Handling_Unit.
--  130410  MaEelk   Removed the calls to Shipment_API.Remove_Manual_Gross_Weight from Insert___, Update___ and Delete___ methods 
--  130410           so that it won't remove the manual gross weight from the shipment. 
--  130325  MaEelk   Made a call to remove the Manual Gross Weight from Handling Unit and Shipment when a shipment line is removed, added or modified in Shipment Line Handling Unit.
--  130311  MaEelk   Added boolean parameter apply_freight_factor_ to Get_Connected_Part_Weight. 
--  130311  MaEelk   This would decide if the freight factor should be considered to the weight calculation or not.
--  130219  MaEelk   Added Get_Connected_Part_Weight to calculate the net weight of all parts connected to a specigic handling unit.
--  130214  MaEelk   Added Mixed_Part_Numbers_Connected to check if a handling unit structure consists of a mixture of different part numbers.
--  121213  JeLise   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Quantity___ (
   shipment_id_           IN NUMBER,
   shipment_line_no_      IN NUMBER,   
   new_quantity_          IN NUMBER,
   old_quantity_          IN NUMBER,  
   report_picking_        IN BOOLEAN,
   release_not_reserved_  IN BOOLEAN )
IS
   remaining_parcel_qty_ NUMBER;   
   shipment_line_rec_    Shipment_Line_API.Public_Rec;
BEGIN
   IF (new_quantity_ <= 0) THEN  
      Error_SYS.Record_General(lu_name_, 'QUANTITY: Qty to Attach must be greater than zero.');
   END IF;
   IF (NOT report_picking_ AND NOT release_not_reserved_) THEN
   shipment_line_rec_    := Shipment_Line_API.Get(shipment_id_, shipment_line_no_); 
   remaining_parcel_qty_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_id_, 
                                                                                      shipment_line_rec_.source_ref1, 
                                                                                      shipment_line_rec_.source_ref2, 
                                                                                      shipment_line_rec_.source_ref3, 
                                                                                      shipment_line_rec_.source_ref4,
                                                                                      shipment_line_rec_.source_ref_type);
   
   IF ((new_quantity_ - old_quantity_) > remaining_parcel_qty_) THEN
      Error_SYS.Record_General(lu_name_, 'QTYTOLARGE: There is only a remaining qty of :P1 :P2 to attach for shipment line :P3.', remaining_parcel_qty_,  
                               shipment_line_rec_.source_unit_meas, shipment_line_no_);
   END IF;
   END IF;
END Check_Quantity___;

PROCEDURE Check_Allow_Mix___ (
   handling_unit_id_ IN NUMBER )
IS
BEGIN
   Handling_Unit_API.Check_Allow_Mix(handling_unit_id_);
END Check_Allow_Mix___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     shipment_line_handl_unit_tab%ROWTYPE,
   newrec_ IN OUT shipment_line_handl_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (Validate_SYS.Is_Changed(newrec_.manual_net_weight, oldrec_.manual_net_weight)) THEN
      IF (NVL(newrec_.manual_net_weight, 0) < 0) THEN
         Error_SYS.Record_General(lu_name_, 'NEGATIVENETWEIGHT: Manual net weight cannot be negative.');   
      END IF;
   END IF;
END Check_Common___;


@Override
PROCEDURE Insert___ (
   objid_       OUT    VARCHAR2,
   objversion_  OUT    VARCHAR2,
   newrec_      IN OUT SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE,
   attr_        IN OUT VARCHAR2,
   on_reassign_ IN     BOOLEAN DEFAULT FALSE)
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   
   IF (NOT on_reassign_) THEN
      Check_Allow_Mix___(newrec_.handling_unit_id);  
      Handling_Unit_API.Remove_Manual_Gross_Weight(newrec_.handling_unit_id);
      Handling_Unit_API.Remove_Manual_Volume(newrec_.handling_unit_id);
   END IF;
   
   Shipment_API.Reset_Printed_Flags__(shipment_id_                 => newrec_.shipment_id,
                                      unset_pkg_list_print_        => TRUE,
                                      unset_consignment_print_     => FALSE,
                                      unset_del_note_print_        => FALSE,
                                      unset_pro_forma_print_       => FALSE,
                                      unset_bill_of_lading_print_  => TRUE,
                                      unset_address_label_print_   => FALSE );
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE,
   newrec_ IN OUT SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   report_picking_ BOOLEAN := FALSE;
   release_not_reserved_ BOOLEAN := FALSE;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF(Client_SYS.Get_Item_Value('REPORT_PICKING', attr_) = 'TRUE') THEN
      report_picking_ := TRUE;
   END IF;
   IF (Client_SYS.Get_Item_Value('RELEASE_NOT_RESERVED', attr_) = 'TRUE') THEN
      release_not_reserved_ := TRUE;
   END IF;
   Check_Quantity___(newrec_.shipment_id, 
                     newrec_.shipment_line_no, 
                     newrec_.quantity,
                     oldrec_.quantity,
                     report_picking_,
                     release_not_reserved_);

   IF (oldrec_.quantity != newrec_.quantity AND NOT indrec_.manual_net_weight) THEN
      newrec_.manual_net_weight := NULL;
   END IF;
END Check_Update___;   


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE,
   newrec_     IN OUT SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   shipment_line_rec_      Shipment_Line_API.Public_Rec;
   root_handling_unit_id_  NUMBER;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   IF (newrec_.quantity !=  oldrec_.quantity) THEN   
      Handling_Unit_API.Remove_Manual_Gross_Weight(newrec_.handling_unit_id);
      Handling_Unit_API.Remove_Manual_Volume(newrec_.handling_unit_id);
      IF (newrec_.quantity < oldrec_.quantity AND NVL(Client_SYS.Get_Item_Value('MODIFY_RESERVE', attr_), 'TRUE') = 'TRUE') THEN            
         shipment_line_rec_    := Shipment_Line_API.Get(newrec_.shipment_id, newrec_.shipment_line_no);    
         Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify(shipment_line_rec_.source_ref1,
                                                         NVL(shipment_line_rec_.source_ref2,'*'),
                                                         NVL(shipment_line_rec_.source_ref3,'*'),
                                                         NVL(shipment_line_rec_.source_ref4,'*'),
                                                         newrec_.shipment_id,
                                                         newrec_.shipment_line_no,
                                                         newrec_.handling_unit_id,
                                                         newrec_.quantity,  
                                                         oldrec_.quantity,                                                        
                                                         FALSE );
      END IF;
      
      Shipment_API.Reset_Printed_Flags__(shipment_id_                 => newrec_.shipment_id,
                                         unset_pkg_list_print_        => TRUE,
                                         unset_consignment_print_     => FALSE,
                                         unset_del_note_print_        => FALSE,
                                         unset_pro_forma_print_       => FALSE,
                                         unset_bill_of_lading_print_  => TRUE,
                                         unset_address_label_print_   => FALSE );
   END IF;
   
   IF (NVL(newrec_.manual_net_weight, 0) != NVL(oldrec_.manual_net_weight, 0)) THEN
      IF (Shipment_API.All_Lines_Delivered__(newrec_.shipment_id) != 1) THEN
         root_handling_unit_id_ := Handling_Unit_API.Get_Root_Handling_Unit_Id(newrec_.handling_unit_id);
         IF (Handling_Unit_API.Get_Manual_Gross_Weight(root_handling_unit_id_) IS NULL) THEN
            $IF (Component_Order_SYS.INSTALLED) $THEN
               Shipment_Freight_Charge_API.Calculate_Shipment_Charges(newrec_.shipment_id, NULL, NULL, NULL, NULL, 1);
            $ELSE
               Error_SYS.Component_Not_Exist('ORDER');
            $END
         END IF;
      END IF;
      
      Shipment_API.Reset_Printed_Flags__(shipment_id_                 => newrec_.shipment_id,
                                         unset_pkg_list_print_        => TRUE,
                                         unset_consignment_print_     => TRUE,
                                         unset_del_note_print_        => TRUE,
                                         unset_pro_forma_print_       => TRUE,
                                         unset_bill_of_lading_print_  => TRUE,
                                         unset_address_label_print_   => FALSE );
   END IF;
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_       IN VARCHAR2,
   remrec_      IN SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE,
   on_reassign_ IN BOOLEAN DEFAULT FALSE)
IS
   reassign_   VARCHAR2(5);
BEGIN
   super(objid_, remrec_);
   reassign_ := App_Context_SYS.Find_Value('SHIPMENT_LINE_REASSIGNING_');
   App_Context_SYS.Set_Value('SHIPMENT_LINE_REASSIGNING_','');
   IF (NOT on_reassign_) AND (reassign_ != 'TRUE')THEN
      IF (Handling_Unit_API.Exists(remrec_.handling_unit_id)) THEN 
         Handling_Unit_API.Remove_Manual_Gross_Weight(remrec_.handling_unit_id);      
         Handling_Unit_API.Remove_Manual_Volume(remrec_.handling_unit_id);
      END IF;
   END IF;
   
   Shipment_API.Reset_Printed_Flags__(shipment_id_                 => remrec_.shipment_id,
                                      unset_pkg_list_print_        => TRUE,
                                      unset_consignment_print_     => FALSE,
                                      unset_del_note_print_        => FALSE,
                                      unset_pro_forma_print_       => FALSE,
                                      unset_bill_of_lading_print_  => TRUE,
                                      unset_address_label_print_   => FALSE );
                                      
END Delete___;


PROCEDURE New (
   shipment_id_         IN NUMBER,
   shipment_line_no_    IN NUMBER,
   handling_unit_id_    IN NUMBER,
   quantity_            IN NUMBER,
   on_reassign_         IN BOOLEAN,
   report_picking_      IN BOOLEAN DEFAULT FALSE,
   manual_net_weight_   IN NUMBER DEFAULT NULL)
IS
   newrec_     SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   objid_      SHIPMENT_LINE_HANDL_UNIT.objid%TYPE;
   objversion_ SHIPMENT_LINE_HANDL_UNIT.objversion%TYPE;
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_ID',       shipment_id_,       attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_LINE_NO',  shipment_line_no_,  attr_);
   Client_SYS.Add_To_Attr('HANDLING_UNIT_ID',  handling_unit_id_,  attr_);
   Client_SYS.Add_To_Attr('QUANTITY',          quantity_,          attr_);
   Client_SYS.Add_To_Attr('MANUAL_NET_WEIGHT', manual_net_weight_, attr_);
   IF report_picking_ THEN
      Client_SYS.Add_To_Attr('REPORT_PICKING', 'TRUE', attr_);
   END IF;
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_, on_reassign_);
END New;


PROCEDURE Modify___ (
   shipment_id_          IN NUMBER,
   shipment_line_no_     IN NUMBER,
   handling_unit_id_     IN NUMBER,
   quantity_             IN NUMBER,
   modify_reserv_        IN BOOLEAN,   
   report_picking_       IN BOOLEAN,  
   release_not_reserved_ IN BOOLEAN,
   manual_net_weight_    IN NUMBER DEFAULT NULL)
   
IS
   oldrec_                 SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   newrec_                 SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   objid_                  SHIPMENT_LINE_HANDL_UNIT.objid%TYPE;
   objversion_             SHIPMENT_LINE_HANDL_UNIT.objversion%TYPE;
   attr_                   VARCHAR2(2000);
   indrec_                 Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(shipment_id_, shipment_line_no_, handling_unit_id_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QUANTITY', quantity_, attr_);
   IF NOT modify_reserv_ THEN
      Client_SYS.Add_To_Attr('MODIFY_RESERVE', 'FALSE', attr_);
   END IF;
   IF report_picking_ THEN
      Client_SYS.Add_To_Attr('REPORT_PICKING', 'TRUE', attr_);
   END IF;
   IF (release_not_reserved_) THEN
      Client_SYS.Add_To_Attr('RELEASE_NOT_RESERVED', 'TRUE', attr_);
   END IF;   
   Client_SYS.Add_To_Attr('MANUAL_NET_WEIGHT', manual_net_weight_, attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


PROCEDURE Remove (
   shipment_id_      IN NUMBER,
   shipment_line_no_ IN NUMBER,
   handling_unit_id_ IN NUMBER,
   on_reassign_      IN BOOLEAN )
IS
   objid_         SHIPMENT_LINE_HANDL_UNIT.objid%TYPE;
   objversion_    SHIPMENT_LINE_HANDL_UNIT.objversion%TYPE;
   remrec_        SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(shipment_id_,
                              shipment_line_no_,
                              handling_unit_id_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             remrec_.shipment_id,
                             remrec_.shipment_line_no,
                             remrec_.handling_unit_id);
   Delete___(objid_, remrec_, on_reassign_);
END Remove;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT shipment_line_handl_unit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   report_picking_ BOOLEAN := FALSE;
BEGIN
   super(newrec_, indrec_, attr_);
   IF(Client_SYS.Get_Item_Value('REPORT_PICKING', attr_) = 'TRUE') THEN
      report_picking_ := TRUE;
   END IF;
   Check_Quantity___(newrec_.shipment_id, 
                     newrec_.shipment_line_no, 
                     newrec_.quantity,
                     0,
                     report_picking_,
                     FALSE);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN shipment_line_handl_unit_tab%ROWTYPE )
IS   
BEGIN
   IF (Shipment_API.Shipment_Delivered(remrec_.shipment_id) = 'TRUE') THEN   
      Error_SYS.Record_General(lu_name_, 'DELSHHUNOTALLWWHENSHPMNTDEL: Shipment line handling units cannot be deleted when the shipment is Delivered.');
   END IF;
   super(remrec_);
   
END Check_Delete___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_               SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   oldinfo_              VARCHAR2(4000);
   new_quantity_         NUMBER;
   shipment_line_rec_    Shipment_Line_API.Public_Rec;
BEGIN
   new_quantity_        := Client_SYS.Get_Item_Value_To_Number('QUANTITY', attr_, lu_name_);
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'CHECK') THEN
      oldrec_       := Get_Object_By_Id___(objid_);
      oldinfo_      := info_;
      Check_Quantity___(shipment_id_          => oldrec_.shipment_id, 
                        shipment_line_no_     => oldrec_.shipment_line_no, 
                        new_quantity_         => new_quantity_,
                        old_quantity_         => oldrec_.quantity,
                        report_picking_       => FALSE,
                        release_not_reserved_ => FALSE);
      
      IF (new_quantity_ < oldrec_.quantity) THEN                          
         shipment_line_rec_    := Shipment_Line_API.Get(oldrec_.shipment_id, oldrec_.shipment_line_no);    
         Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify(shipment_line_rec_.source_ref1,
                                                         shipment_line_rec_.source_ref2,
                                                         shipment_line_rec_.source_ref3,
                                                         shipment_line_rec_.source_ref4,
                                                         oldrec_.shipment_id,
                                                         oldrec_.shipment_line_no,
                                                         oldrec_.handling_unit_id,
                                                         new_quantity_,  
                                                         oldrec_.quantity,                                                         
                                                         TRUE );
         info_ := Client_SYS.Append_Info(oldinfo_);
      END IF;
   END IF;
END Modify__;

@UncheckedAccess
PROCEDURE Lock__ (
   shipment_id_        IN NUMBER,
   shipment_line_no_   IN NUMBER,
   handling_unit_id_   IN NUMBER )
IS
   dummy_        SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   objid_        SHIPMENT_LINE_HANDL_UNIT.objid%TYPE;
   objversion_   SHIPMENT_LINE_HANDL_UNIT.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, shipment_id_, shipment_line_no_, handling_unit_id_);
   dummy_ := Lock_By_Id___(objid_, objversion_);
END Lock__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE New_Or_Add_To_Existing (
   shipment_id_              IN NUMBER,
   shipment_line_no_         IN NUMBER,
   handling_unit_id_         IN NUMBER,
   quantity_to_be_added_     IN NUMBER,
   assign_existing_hu_    IN BOOLEAN DEFAULT NULL,
   report_picking_        IN BOOLEAN DEFAULT FALSE,
   manual_net_weight_     IN NUMBER DEFAULT NULL,
   attach_full_qty_       IN VARCHAR2 DEFAULT 'FALSE')
IS
   oldrec_ SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   new_qty_to_add_   NUMBER;
   line_rec_         Shipment_Line_API.Public_Rec;
BEGIN
   
   IF (Check_Exist___(shipment_id_, 
                      shipment_line_no_, 
                      handling_unit_id_)) THEN
      oldrec_ := Lock_By_Keys___(shipment_id_,
                                 shipment_line_no_,
                                 handling_unit_id_);
      Modify___(shipment_id_, 
                shipment_line_no_,
                handling_unit_id_, 
                (oldrec_.quantity + quantity_to_be_added_),
                NVL(assign_existing_hu_, TRUE),
                report_picking_,
                FALSE,
                manual_net_weight_);
   ELSE
      IF (attach_full_qty_ = 'TRUE') THEN
         line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
         new_qty_to_add_ := Shipment_Handling_Utility_API.Get_Remaining_Qty_To_Attach(shipment_id_,
                                                                                      line_rec_.source_ref1,
                                                                                      line_rec_.source_ref2,
                                                                                      line_rec_.source_ref3,
                                                                                      line_rec_.source_ref4,
                                                                                      line_rec_.source_ref_type);

      ELSE
         new_qty_to_add_ := quantity_to_be_added_;
      END IF;
      New(shipment_id_, 
          shipment_line_no_, 
          handling_unit_id_, 
          new_qty_to_add_,
          NVL(assign_existing_hu_, FALSE),
          report_picking_,
          manual_net_weight_);
   END IF;
   
END New_Or_Add_To_Existing;


@UncheckedAccess
FUNCTION Get_Shipment_Line_Quantity (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS
   temp_ SHIPMENT_LINE_HANDL_UNIT_TAB.quantity%TYPE;
   
   CURSOR get_attr IS
      SELECT NVL(SUM(slhu.quantity), 0)
      FROM SHIPMENT_LINE_HANDL_UNIT_TAB slhu, SHIPMENT_LINE_TAB sl
      WHERE sl.shipment_id      = shipment_id_
       AND  NVL(sl.source_ref1, string_null_) = NVL(source_ref1_, string_null_)
       AND  NVL(sl.source_ref2, string_null_) = NVL(source_ref2_, string_null_)
       AND  NVL(sl.source_ref3, string_null_) = NVL(source_ref3_, string_null_)
       AND  NVL(sl.source_ref4, string_null_) = NVL(source_ref4_, string_null_)
       AND  sl.source_ref_type  = source_ref_type_db_
       AND  sl.shipment_id      = slhu.shipment_id
       AND  sl.shipment_line_no = slhu.shipment_line_no;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Shipment_Line_Quantity;


-- Get_Inventory_Quantity
--   This method fetches the quantity and converts it into inventory uom.
@UncheckedAccess
FUNCTION Get_Inventory_Quantity (
   shipment_id_      IN NUMBER,
   shipment_line_no_ IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   quantity_          SHIPMENT_LINE_HANDL_UNIT_TAB.quantity%TYPE;      
BEGIN
   quantity_ := Get_Quantity(shipment_id_,
                             shipment_line_no_,
                             handling_unit_id_);
   quantity_ := Shipment_Handling_Utility_Api.Get_Converted_Inv_Qty(shipment_id_, 
                                                                    shipment_line_no_, 
                                                                    quantity_, 
                                                                    NULL,
                                                                    NULL);
   
   RETURN quantity_;
END Get_Inventory_Quantity;

PROCEDURE Remove_Or_Modify (
   info_                    OUT VARCHAR2,
   shipment_id_             IN  NUMBER,
   shipment_line_no_        IN  NUMBER,
   new_quantity_            IN  NUMBER,
   only_check_              IN  BOOLEAN DEFAULT FALSE,
   qty_modification_source_ IN  VARCHAR2 DEFAULT NULL,
   prev_inv_qty_            IN  NUMBER DEFAULT NULL )
IS
   number_of_handling_unit_ NUMBER;
   handling_unit_id_        NUMBER;
   shipment_line_qty_       NUMBER;
   uom_                     VARCHAR2(10);
   shipment_line_rec_       Shipment_Line_API.Public_Rec;
   quantity_                NUMBER;
   remove_all_hu_connections_  BOOLEAN := TRUE;
   total_attached_qty_         NUMBER;
   conn_source_qty_to_attach_  NUMBER;
   attached_inventory_qty_     NUMBER;
   CURSOR get_number_of_handling_unit IS
      SELECT count(*)
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB
       WHERE shipment_id      = shipment_id_
         AND shipment_line_no = shipment_line_no_;
   
   CURSOR get_handling_unit_id IS
      SELECT handling_unit_id, quantity
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB
       WHERE shipment_id      = shipment_id_
         AND shipment_line_no = shipment_line_no_;
BEGIN
   shipment_line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
    
   OPEN get_number_of_handling_unit;
   FETCH get_number_of_handling_unit INTO number_of_handling_unit_;
   CLOSE get_number_of_handling_unit;

   IF ((number_of_handling_unit_ = 1) AND (NOT only_check_))THEN
      -- Update sales_qty
      OPEN get_handling_unit_id;
      FETCH get_handling_unit_id INTO handling_unit_id_, quantity_;
      CLOSE get_handling_unit_id;
      IF (new_quantity_ < quantity_) THEN
         Modify___(shipment_id_          => shipment_id_,
                   shipment_line_no_     => shipment_line_no_,
                   handling_unit_id_     => handling_unit_id_,
                   quantity_             => new_quantity_,
                   modify_reserv_        => TRUE,
                   report_picking_       => FALSE,
                   release_not_reserved_ => FALSE);
      END IF; 
   ELSIF (number_of_handling_unit_ > 1) THEN
      shipment_line_qty_ := Get_Shipment_Line_Quantity(shipment_id_,
                                                       shipment_line_rec_.source_ref1,
                                                       shipment_line_rec_.source_ref2,
                                                       shipment_line_rec_.source_ref3,
                                                       shipment_line_rec_.source_ref4,
                                                       shipment_line_rec_.source_ref_type);
      IF (new_quantity_ < shipment_line_qty_) THEN
         -- remove attached lines to handling unit
         IF (only_check_) THEN 
            uom_ := shipment_line_rec_.source_unit_meas;
            Client_SYS.Clear_Info;
            Client_SYS.Add_Warning(lu_name_, 'LINESMAYREMOVED: The connected source qty (:P1 :P2) for this shipment line is less than what is currently attached to different handling units (:P3 :P2). As a result of this, the attached shipment handling unit lines might be removed and will need to be attached again.',
                                   new_quantity_, uom_, shipment_line_qty_);
            info_ := Client_SYS.Get_All_Info;
         ELSE
            total_attached_qty_ := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(shipment_line_rec_.source_ref1,
                                                                                        shipment_line_rec_.source_ref2,
                                                                                        shipment_line_rec_.source_ref3,
                                                                                        shipment_line_rec_.source_ref4,
                                                                                        shipment_id_,
                                                                                        shipment_line_no_,
                                                                                        NULL);
            IF ((qty_modification_source_ = 'RELEASE_NOT_RESERVED') AND (shipment_line_rec_.qty_assigned = total_attached_qty_)) THEN
               remove_all_hu_connections_ := FALSE;
               IF (prev_inv_qty_ > total_attached_qty_) THEN
                  FOR rec_ IN get_handling_unit_id LOOP
                     attached_inventory_qty_ := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(shipment_line_rec_.source_ref1,
                                                                                                     shipment_line_rec_.source_ref2,
                                                                                                     shipment_line_rec_.source_ref3,
                                                                                                     shipment_line_rec_.source_ref4,
                                                                                                     shipment_id_,
                                                                                                     shipment_line_no_,
                                                                                                     rec_.handling_unit_id);
                     
                     
                     IF (attached_inventory_qty_ = 0) THEN
                        Remove(shipment_id_,
                               shipment_line_no_,
                               rec_.handling_unit_id,
                               FALSE);
                     ELSE
                        conn_source_qty_to_attach_ := Shipment_Handling_Utility_API.Get_Converted_Source_Qty(shipment_id_           => shipment_id_, 
                                                                                                             shipment_line_no_      => shipment_line_no_,
                                                                                                             inventory_qty_         => attached_inventory_qty_,
                                                                                                             conv_factor_           => shipment_line_rec_.conv_factor,
                                                                                                             inverted_conv_factor_  => shipment_line_rec_.inverted_conv_factor);
                        Modify___(shipment_id_          => shipment_id_,
                                  shipment_line_no_     => shipment_line_no_,
                                  handling_unit_id_     => rec_.handling_unit_id,
                                  quantity_             => conn_source_qty_to_attach_,
                                  modify_reserv_        => TRUE,
                                  report_picking_       => FALSE,
                                  release_not_reserved_ => TRUE);
                     END IF;             
                  END LOOP;
               END IF;
            END IF;
            IF (remove_all_hu_connections_) THEN
               FOR rec_ IN get_handling_unit_id LOOP 
                  Remove(shipment_id_,
                         shipment_line_no_,
                         rec_.handling_unit_id,
                         FALSE);
               END LOOP;
            END IF;
         END IF;
      END IF;
   END IF;
END Remove_Or_Modify;


@UncheckedAccess
FUNCTION Handling_Unit_Exist (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN VARCHAR2  
IS
   temp_                NUMBER;
   handling_unit_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   
   CURSOR check_exist IS
      SELECT 1
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_
         AND handling_unit_id = handling_unit_id_;
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
FUNCTION Shipment_Exist (
   shipment_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_           NUMBER;
   shipment_exist_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR check_exist IS
      SELECT 1
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF(check_exist%FOUND) THEN
      shipment_exist_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE check_exist;
   RETURN shipment_exist_;
END Shipment_Exist;


PROCEDURE Remove_Handling_Unit (
   shipment_id_            IN NUMBER,
   handling_unit_id_       IN NUMBER,
   remove_from_structure_  IN BOOLEAN DEFAULT FALSE)
IS
   objid_      SHIPMENT_LINE_HANDL_UNIT.objid%TYPE;
   objversion_ SHIPMENT_LINE_HANDL_UNIT.objversion%TYPE;
   remrec_     SHIPMENT_LINE_HANDL_UNIT_TAB%ROWTYPE;
   
   CURSOR get_data IS
      SELECT shipment_line_no
      FROM SHIPMENT_LINE_HANDL_UNIT_TAB
      WHERE shipment_id = shipment_id_
        AND handling_unit_id = handling_unit_id_;
      
   CURSOR get_children IS
      SELECT handling_unit_id
        FROM HANDLING_UNIT
       WHERE shipment_id = shipment_id_
         AND parent_handling_unit_id = handling_unit_id_; 
BEGIN
   FOR rec_ IN get_data LOOP
      remrec_ := Lock_By_Keys___(shipment_id_,
                                 rec_.shipment_line_no,
                                 handling_unit_id_);

      Check_Delete___(remrec_);
      Get_Id_Version_By_Keys___(objid_, 
                                objversion_, 
                                shipment_id_,
                                remrec_.shipment_line_no,
                                remrec_.handling_unit_id);
      Delete___(objid_, remrec_);
   END LOOP;
   
   IF (remove_from_structure_) THEN
      FOR childrec_ IN get_children LOOP
         Remove_Handling_Unit(shipment_id_,
                              childrec_.handling_unit_id,
                              remove_from_structure_);
      END LOOP;
   END IF;
END Remove_Handling_Unit;


PROCEDURE Reduce_Quantity (
   shipment_id_        IN NUMBER,
   shipment_line_no_   IN NUMBER,
   handling_unit_id_   IN NUMBER,
   qty_to_reduce_with_ IN NUMBER,
   modify_reserv_      IN VARCHAR2 DEFAULT 'TRUE' )
IS
   quantity_     SHIPMENT_LINE_HANDL_UNIT_TAB.quantity%TYPE;
   new_quantity_ SHIPMENT_LINE_HANDL_UNIT_TAB.quantity%TYPE;
BEGIN
   quantity_ := Get_Quantity(shipment_id_,
                             shipment_line_no_,
                             handling_unit_id_);
   
   IF ((quantity_ = qty_to_reduce_with_) OR (ROUND(qty_to_reduce_with_, 20) = 0))  THEN
      Remove( shipment_id_,  shipment_line_no_, handling_unit_id_, FALSE);
   ELSE
      new_quantity_ := (quantity_ - qty_to_reduce_with_);
      Modify___(shipment_id_          => shipment_id_,
                shipment_line_no_     => shipment_line_no_,
                handling_unit_id_     => handling_unit_id_,
                quantity_             => new_quantity_,
                modify_reserv_        => (modify_reserv_= 'TRUE'),
                report_picking_       => FALSE,
                release_not_reserved_ => FALSE );
      
   END IF;
END Reduce_Quantity;


@UncheckedAccess
FUNCTION Mixed_Part_Numbers_Connected (
   handling_unit_id_tab_ IN Handling_Unit_API.Handling_Unit_Id_Tab ) RETURN BOOLEAN
IS
   mixed_part_numbers_connected_  BOOLEAN := FALSE;
   shipment_line_tab_             Shipment_Line_API.Shipment_Line_Id_Tab;
   part_count_                    NUMBER;
   no_part_count_                 NUMBER;
   
   CURSOR get_shipment_lines IS
      SELECT shipment_id, shipment_line_no
        FROM shipment_line_handl_unit_tab
       WHERE handling_unit_id IN (SELECT handling_unit_id FROM TABLE (handling_unit_id_tab_));

   CURSOR get_part_count IS
      SELECT COUNT(DISTINCT source_part_no)
        FROM SHIPMENT_LINE_TAB
       WHERE (shipment_id, shipment_line_no) IN (SELECT shipment_id, shipment_line_no FROM TABLE (shipment_line_tab_));
       
   CURSOR no_part_count IS
      SELECT COUNT(DISTINCT source_part_description)
      FROM SHIPMENT_LINE_TAB
      WHERE (shipment_id, shipment_line_no) IN (SELECT shipment_id, shipment_line_no FROM TABLE (shipment_line_tab_))
      AND   source_part_no IS NULL;

BEGIN
   IF (handling_unit_id_tab_.COUNT > 0) THEN
      OPEN  get_shipment_lines;
      FETCH get_shipment_lines BULK COLLECT INTO shipment_line_tab_;
      CLOSE get_shipment_lines;
      
      IF (shipment_line_tab_.COUNT > 0) THEN
         OPEN  get_part_count;
         FETCH get_part_count INTO part_count_;
         CLOSE get_part_count;
         
         IF (part_count_ > 1) THEN
            mixed_part_numbers_connected_ := TRUE;
         ELSE
            OPEN  no_part_count;
            FETCH no_part_count INTO no_part_count_;
            CLOSE no_part_count;
            
            IF (no_part_count_ > 1 OR (part_count_ = 1 AND no_part_count_ = 1)) THEN
               mixed_part_numbers_connected_ := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;
   
   RETURN mixed_part_numbers_connected_;   
END Mixed_Part_Numbers_Connected;

@UncheckedAccess
FUNCTION Get_Operative_Net_Weight (
   shipment_id_      IN NUMBER,
   shipment_line_no_ IN NUMBER,
   handling_unit_id_ IN NUMBER,
   uom_for_weight_   IN VARCHAR2) RETURN NUMBER
IS
   CURSOR get_shipment_line IS
      SELECT sl.source_ref1, sl.source_ref2, sl.source_ref3, sl.source_ref4, sl.source_ref_type, 
             sl.source_part_no, sl.source_unit_meas, sl.conv_factor, sl.inverted_conv_factor, 
             slhu.manual_net_weight, slhu.quantity
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB slhu, SHIPMENT_LINE_TAB sl
       WHERE sl.shipment_id        = slhu.shipment_id
         AND sl.shipment_line_no   = slhu.shipment_line_no
         AND slhu.shipment_id      = shipment_id_
         AND slhu.handling_unit_id = handling_unit_id_
         AND slhu.shipment_line_no = shipment_line_no_;
         
   line_rec_                  get_shipment_line%ROWTYPE;
   part_catalog_rec_          Part_Catalog_API.Public_Rec;
   contract_                  VARCHAR2(5);  
   temp_weight_net_           NUMBER := 0;
   configuration_id_          VARCHAR2(50);
BEGIN                                                                       
   OPEN get_shipment_line;
   FETCH get_shipment_line INTO line_rec_;
   CLOSE get_shipment_line;
   IF line_rec_.manual_net_weight IS NOT NULL THEN
      temp_weight_net_ := line_rec_.manual_net_weight;
   ELSE
      
      contract_ := Shipment_API.Get_Contract(shipment_id_);
      configuration_id_ := Shipment_Source_Utility_API.Get_Configuration_Id(line_rec_.source_ref1, 
                                                                            line_rec_.source_ref2, 
                                                                            line_rec_.source_ref3, 
                                                                            line_rec_.source_ref4, 
                                                                            line_rec_.source_ref_type);
      
      part_catalog_rec_ := Part_Catalog_API.Get(line_rec_.source_part_no);
      temp_weight_net_ := line_rec_.quantity * Part_Weight_Volume_Util_API.Get_Config_Weight_Net(contract_, 
                                                                                                 part_catalog_rec_.part_no, 
                                                                                                 configuration_id_, 
                                                                                                 line_rec_.source_part_no, 
                                                                                                 line_rec_.source_unit_meas, 
                                                                                                 line_rec_.conv_factor, 
                                                                                                 line_rec_.inverted_conv_factor, 
                                                                                                 uom_for_weight_);
   END IF;
   RETURN NVL(temp_weight_net_, 0);
END Get_Operative_Net_Weight;


@UncheckedAccess
PROCEDURE Get_Connected_Part_Weight (
   net_weight_        OUT NUMBER,
   adj_net_weight_    OUT NUMBER,
   shipment_id_       IN NUMBER,
   handling_unit_id_  IN NUMBER,
   uom_for_weight_    IN VARCHAR2)
IS
   CURSOR get_shipment_lines IS
      SELECT sl.source_ref1, sl.source_ref2, sl.source_ref3, sl.source_ref4, sl.source_ref_type, 
             sl.source_part_no, sl.source_unit_meas, sl.conv_factor, sl.inverted_conv_factor, 
             slhu.manual_net_weight, slhu.quantity, slhu.shipment_id, sl.inventory_part_no
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB slhu, SHIPMENT_LINE_TAB sl
       WHERE sl.shipment_id        = slhu.shipment_id
         AND sl.shipment_line_no   = slhu.shipment_line_no
         AND slhu.shipment_id      = shipment_id_
         AND slhu.handling_unit_id = handling_unit_id_;
   
   part_catalog_rec_          Part_Catalog_API.Public_Rec;
   contract_                  VARCHAR2(5);
   conversion_factor_         NUMBER;
   weight_                    NUMBER;
   adj_weight_                NUMBER;
   unit_conv_weight_          NUMBER := 0;  
   temp_weight_net_           NUMBER := 0;
   temp_sales_unit_meas_      VARCHAR2(10);
   temp_unit_code_            VARCHAR2(30);
   temp_uom_for_weight_net_   VARCHAR2(30);
   configuration_id_             VARCHAR2(50);
   rec_net_weight_               NUMBER;
   rec_weight_unit_code_         VARCHAR2(30);
   config_weight_exists_         BOOLEAN := FALSE;
BEGIN
   net_weight_      := 0;
   adj_net_weight_  := 0;
   
   contract_ := Shipment_API.Get_Contract(shipment_id_);
   
   FOR line_rec_ IN  get_shipment_lines LOOP  
      part_catalog_rec_ := Part_Catalog_API.Get(line_rec_.source_part_no);
      configuration_id_ := Shipment_Source_Utility_API.Get_Configuration_Id(line_rec_.source_ref1, 
                                                                            line_rec_.source_ref2, 
                                                                            line_rec_.source_ref3, 
                                                                            line_rec_.source_ref4, 
                                                                            line_rec_.source_ref_type);
      config_weight_exists_ := FALSE;
      
      -- If the source_unit_meas and unit_code is the same as the previous iteration in the FOR-loop we don't need
      -- to fetch the conversion factor again.
      IF ((NVL(temp_sales_unit_meas_, Database_SYS.string_null_) != line_rec_.source_unit_meas) OR 
          (NVL(temp_unit_code_, Database_SYS.string_null_)       != part_catalog_rec_.unit_code)) THEN
         conversion_factor_    := Technical_Unit_Conv_API.Get_Valid_Conv_Factor(unit_       => line_rec_.source_unit_meas, 
                                                                                alt_unit_   => part_catalog_rec_.unit_code);
         temp_sales_unit_meas_ := line_rec_.source_unit_meas;
         temp_unit_code_       := part_catalog_rec_.Unit_Code;
      END IF;
      conversion_factor_ := NVL(conversion_factor_, line_rec_.conv_factor / line_rec_.inverted_conv_factor); 
      unit_conv_weight_ := 0;
      IF (line_rec_.manual_net_weight IS NULL) THEN
         IF (configuration_id_ != '*') THEN
            $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
               DECLARE
                  configuration_spec_rec_   Configuration_Spec_API.Public_Rec;
               BEGIN
                  configuration_spec_rec_ := Configuration_Spec_API.Get(line_rec_.source_part_no, configuration_id_);
                  IF (configuration_spec_rec_.net_weight IS NOT NULL) THEN
                     rec_net_weight_        := configuration_spec_rec_.net_weight;
                     rec_weight_unit_code_  := configuration_spec_rec_.weight_unit_code;
                     config_weight_exists_ :=  TRUE;
                  END IF;
               END;
            $ELSE
               NULL;
            $END
         END IF;
         IF (NOT config_weight_exists_) THEN
            rec_net_weight_         := part_catalog_rec_.weight_net;
            rec_weight_unit_code_   := part_catalog_rec_.uom_for_weight_net;
         END IF;
      -- If the part catalog net weight and uom for net weight is the same as the previous iteration in the FOR-loop we don't
      -- need to fetch the unit converted weight again.
         IF ((temp_weight_net_ != rec_net_weight_) OR 
            (NVL(temp_uom_for_weight_net_, Database_SYS.string_null_) != rec_weight_unit_code_)) THEN
            unit_conv_weight_        := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_    => rec_net_weight_, 
                                                                                 from_unit_code_   => rec_weight_unit_code_, 
                                                                              to_unit_code_     => uom_for_weight_);
            temp_weight_net_         := rec_net_weight_;
            temp_uom_for_weight_net_ := rec_weight_unit_code_;
      END IF;
      weight_       := line_rec_.quantity * unit_conv_weight_ * conversion_factor_;
      ELSE
         weight_       := line_rec_.manual_net_weight;
      END IF;
      adj_weight_   := weight_ * part_catalog_rec_.freight_factor;

      -- Fetch weight and adjusted weight from Inventory Part when unable to get it from Sales Part.
      IF (weight_ = 0 AND line_rec_.manual_net_weight IS NULL) THEN
         weight_     := line_rec_.quantity * NVL(Inventory_Part_API.Get_Weight_Net(contract_, line_rec_.inventory_part_no), 0) * 
                           (line_rec_.conv_factor / line_rec_.inverted_conv_factor);
         adj_weight_ := weight_ * Part_Catalog_API.Get_Freight_Factor(line_rec_.inventory_part_no);
      END IF;

      net_weight_     := net_weight_ + weight_;
      adj_net_weight_ := adj_net_weight_ + adj_weight_;
   END LOOP;
END Get_Connected_Part_Weight;


@UncheckedAccess
FUNCTION Get_Connected_Part_Volume (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER,
   uom_for_volume_   IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_shipment_lines IS
      SELECT sl.source_ref1, sl.source_ref2, sl.source_ref3, sl.source_ref4,
             sl.source_ref_type, sl.source_part_no, sl.source_unit_meas, slhu.quantity,
             sl.conv_factor, sl.inverted_conv_factor
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB slhu, SHIPMENT_LINE_TAB sl
       WHERE slhu.shipment_id      = shipment_id_
         AND slhu.handling_unit_id = handling_unit_id_
         AND sl.shipment_id        = slhu.shipment_id
         AND sl.shipment_line_no   = slhu.shipment_line_no;
   
   part_catalog_rec_        Part_Catalog_API.Public_Rec;     
   connected_part_volume_   NUMBER := 0;
   conversion_factor_       NUMBER := 0;
   unit_conv_volume_        NUMBER := 0;
   temp_volume_net_         NUMBER := 0;
   temp_source_unit_meas_   VARCHAR2(10);
   temp_unit_code_          VARCHAR2(30);
   temp_uom_for_volume_net_ VARCHAR2(30);
BEGIN
   FOR line_rec_ IN  get_shipment_lines LOOP  
      part_catalog_rec_ := Part_Catalog_API.Get(line_rec_.source_part_no);
      IF (part_catalog_rec_.volume_net IS NOT NULL) THEN
         -- If the source_unit_meas and unit_code is the same as the previous iteration in the FOR-loop we don't need
         -- to fetch the conversion factor again.
         IF ((NVL(temp_source_unit_meas_, Database_SYS.string_null_)   != line_rec_.source_unit_meas) OR
             (NVL(temp_unit_code_, Database_SYS.string_null_)          != part_catalog_rec_.unit_code)) THEN
            conversion_factor_     := Technical_Unit_Conv_API.Get_Valid_Conv_Factor(unit_      => line_rec_.source_unit_meas, 
                                                                                    alt_unit_  => part_catalog_rec_.unit_code);
            temp_source_unit_meas_ := line_rec_.source_unit_meas;
            temp_unit_code_        := part_catalog_rec_.unit_code;
         END IF;
         conversion_factor_ := NVL(conversion_factor_, line_rec_.conv_factor / line_rec_.inverted_conv_factor);
         -- If the part catalog net volume and uom for net volume is the same as the previous iteration in the FOR-loop we don't
         -- need to fetch the unit converted weight again.
         IF ((temp_volume_net_ != part_catalog_rec_.volume_net) OR 
             (NVL(temp_uom_for_volume_net_, Database_SYS.string_null_) != part_catalog_rec_.uom_for_volume_net)) THEN
            unit_conv_volume_      := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_     => part_catalog_rec_.volume_net,
                                                                               from_unit_code_    => part_catalog_rec_.uom_for_volume_net,
                                                                               to_unit_code_      => uom_for_volume_);
            temp_volume_net_       := part_catalog_rec_.volume_net;
            temp_unit_code_        := part_catalog_rec_.uom_for_volume_net;
         END IF;

         connected_part_volume_ := connected_part_volume_ + line_rec_.quantity * unit_conv_volume_ * conversion_factor_;
      END IF;
   END LOOP;
   
   RETURN connected_part_volume_;   
END Get_Connected_Part_Volume;


@UncheckedAccess
FUNCTION Check_Unique_Part_Connected (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER) RETURN BOOLEAN
IS
   source_part_no_            VARCHAR2(25);
   dummy_source_part_no_      VARCHAR2(25);
   one_ship_line_connected_   BOOLEAN := TRUE;
   source_part_desc_          VARCHAR2(200);
   dummy_source_part_desc_    VARCHAR2(200);
   shipment_line_rec_         Shipment_Line_API.Public_Rec;
   
   CURSOR get_handl_unit_con_ord_line(handling_unit_id_ NUMBER) IS
      SELECT shipment_line_no
      FROM   SHIPMENT_LINE_HANDL_UNIT_TAB
      WHERE  handling_unit_id = handling_unit_id_;
   
    CURSOR get_ship_con_handl_units IS
      SELECT handling_unit_id
      FROM   handling_unit_pub 
      WHERE  handling_unit_id IN (
                                  SELECT handling_unit_id
                                  FROM   shipment_line_handl_unit_tab
                                  WHERE  shipment_id = shipment_id_
                                 )
      CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
      START WITH       handling_unit_id =  handling_unit_id_;
BEGIN
   dummy_source_part_no_ := NULL;
   FOR rec_ IN get_ship_con_handl_units LOOP
      FOR linerec_ IN get_handl_unit_con_ord_line(rec_.handling_unit_id) LOOP
         shipment_line_rec_ := Shipment_Line_API.Get(shipment_id_, linerec_.shipment_line_no);
         source_part_no_    := shipment_line_rec_.source_part_no;
         source_part_desc_  := shipment_line_rec_.source_part_description;
         IF (dummy_source_part_no_ IS NOT NULL) THEN
            IF (source_part_no_ IS NOT NULL AND source_part_no_ != dummy_source_part_no_) THEN
               one_ship_line_connected_ := FALSE;
               EXIT;
            ELSIF (source_part_no_ IS NULL) THEN
               one_ship_line_connected_ := FALSE;
               EXIT;
            END IF;
         ELSIF (dummy_source_part_no_ IS NULL AND dummy_source_part_desc_ IS NOT NULL) THEN
            IF (source_part_no_ IS NULL AND source_part_desc_ != dummy_source_part_desc_) THEN               
               one_ship_line_connected_ := FALSE;
               EXIT; 
            ELSIF (source_part_no_ IS NOT NULL) THEN
               one_ship_line_connected_ := FALSE;
               EXIT;
            END IF;
         END IF;  
         dummy_source_part_no_   := source_part_no_;
         dummy_source_part_desc_ := source_part_desc_;
      END LOOP;   
   END LOOP;   
   RETURN one_ship_line_connected_;   
END Check_Unique_Part_Connected; 


@UncheckedAccess
FUNCTION Check_One_Ship_Line_Connected (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   shipment_line_count_        NUMBER;
   unique_ship_line_connected_ BOOLEAN := FALSE;
   
   CURSOR get_hu_ship_lines IS
      SELECT COUNT(DISTINCT shipment_line_no)
        FROM shipment_line_handl_unit_tab
       WHERE shipment_id = shipment_id_
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM handling_unit_pub 
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                   START WITH     handling_unit_id = handling_unit_id_);  
BEGIN
   OPEN get_hu_ship_lines;
   FETCH get_hu_ship_lines INTO  shipment_line_count_;
   CLOSE get_hu_ship_lines;
   IF (shipment_line_count_ = 1) THEN
      unique_ship_line_connected_ := TRUE;   
   END IF;  
   RETURN unique_ship_line_connected_;    
END Check_One_Ship_Line_Connected; 


@UncheckedAccess
FUNCTION Get_Sub_Struct_Connected_Qty (
   shipment_id_      IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   quantity_ NUMBER;
   CURSOR get_quantity IS
      SELECT NVL(SUM(quantity), 0)
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB
       WHERE shipment_id = shipment_id_
         AND handling_unit_id IN (SELECT handling_unit_id
                                    FROM handling_unit_pub 
                                 CONNECT BY PRIOR handling_unit_id = parent_handling_unit_id   
                                   START WITH     handling_unit_id = handling_unit_id_);
BEGIN 
   OPEN get_quantity;
   FETCH get_quantity INTO quantity_;
   CLOSE get_quantity;
   RETURN quantity_;   
END Get_Sub_Struct_Connected_Qty;    


@UncheckedAccess
FUNCTION Get_No_Of_Handling_Units (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS
   no_of_handling_units_ NUMBER;
   CURSOR get_number_of_handling_unit IS
      SELECT count(*)
      FROM SHIPMENT_LINE_HANDL_UNIT_TAB slhu, SHIPMENT_LINE_TAB sl
      WHERE sl.shipment_id = shipment_id_
      AND   NVL(sl.source_ref1, string_null_) = NVL(source_ref1_, string_null_)
      AND   NVL(sl.source_ref2, string_null_) = NVL(source_ref2_, string_null_)
      AND   NVL(sl.source_ref3, string_null_) = NVL(source_ref3_, string_null_)
      AND   NVL(sl.source_ref4, string_null_) = NVL(source_ref4_, string_null_)
      AND   sl.source_ref_type  = source_ref_type_db_
      AND   sl.shipment_id      = slhu.shipment_id
      AND   sl.shipment_line_no = slhu.shipment_line_no;
      
BEGIN
    OPEN   get_number_of_handling_unit;
    FETCH  get_number_of_handling_unit INTO no_of_handling_units_;
    CLOSE  get_number_of_handling_unit;
    RETURN no_of_handling_units_;
END Get_No_Of_Handling_Units;

FUNCTION Get_Shipment_Line_Inv_Qty (
   shipment_id_        IN NUMBER,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN VARCHAR2,
   source_ref_type_db_ IN VARCHAR2) RETURN NUMBER
IS      
   sales_qty_         NUMBER;  
   shipment_line_rec_ Shipment_Line_API.Public_Rec;  
BEGIN
   shipment_line_rec_ := Shipment_Line_API.Get_By_Source(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_); 
   sales_qty_         := Get_Shipment_Line_Quantity(shipment_id_, source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_); 
   
   RETURN Shipment_Handling_Utility_API.Get_Converted_Inv_Qty(shipment_id_,
                                                              shipment_line_rec_.shipment_line_no,
                                                              sales_qty_,
                                                              shipment_line_rec_.conv_factor,
                                                              shipment_line_rec_.inverted_conv_factor);
END Get_Shipment_Line_Inv_Qty;

@UncheckedAccess
FUNCTION Get_Reserv_Qty_Left_To_Assign (
   shipment_id_        IN NUMBER,
   shipment_line_no_   IN NUMBER,
   handling_unit_id_   IN NUMBER ) RETURN NUMBER
IS
   reserved_qty_attached_      NUMBER;
   reserved_qty_attached_hu_   NUMBER;
   qty_attached_               NUMBER;
   inv_qty_attached_           NUMBER;
   reserv_qty_left_to_assign_  NUMBER;
   shipment_line_rec_          Shipment_Line_API.Public_Rec;
   qty_assigned_               NUMBER:=0;
BEGIN
   shipment_line_rec_         := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
   IF ((shipment_line_rec_.source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) OR 
       (shipment_line_rec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER AND shipment_line_rec_.source_ref4 = 0)) THEN
      qty_assigned_ := shipment_line_rec_.qty_assigned;
   END IF;
   
   reserved_qty_attached_     := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(shipment_line_rec_.source_ref1,
                                                                                      NVL(shipment_line_rec_.source_ref2,'*'),
                                                                                      NVL(shipment_line_rec_.source_ref3,'*'),
                                                                                      NVL(shipment_line_rec_.source_ref4,'*'),
                                                                                      shipment_id_, 
                                                                                      shipment_line_no_,
                                                                                      NULL);
                                                                                        
   reserved_qty_attached_hu_  := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(shipment_line_rec_.source_ref1,
                                                                                      NVL(shipment_line_rec_.source_ref2,'*'),
                                                                                      NVL(shipment_line_rec_.source_ref3,'*'),
                                                                                      NVL(shipment_line_rec_.source_ref4,'*'),                                                                                     
                                                                                      shipment_id_, 
                                                                                      shipment_line_no_,
                                                                                      handling_unit_id_);
                                                                                 
   qty_attached_              := Get_Quantity(shipment_id_, shipment_line_no_, handling_unit_id_);
   inv_qty_attached_          := (qty_attached_ * shipment_line_rec_.conv_factor/shipment_line_rec_.inverted_conv_factor);
   
   -- Checking LEAST because we have to check the total reserved quantity and how much of it is already HU connected. The reminder may not be able
   -- to cover all the HU attached qty without reservations attached.
   IF (reserved_qty_attached_ IS NOT NULL) THEN 
      reserv_qty_left_to_assign_ := LEAST((NVL(qty_assigned_, 0) - NVL(reserved_qty_attached_, 0)), (inv_qty_attached_ - reserved_qty_attached_hu_));
   END IF;
  
   RETURN NVL(reserv_qty_left_to_assign_, 0);   
END Get_Reserv_Qty_Left_To_Assign;


PROCEDURE Check_Quantity (
   shipment_id_         IN NUMBER,
   shipment_line_no_    IN NUMBER,   
   new_quantity_        IN NUMBER,
   old_quantity_        IN NUMBER )
IS
BEGIN
   Check_Quantity___(shipment_id_          => shipment_id_,
                     shipment_line_no_     => shipment_line_no_,
                     new_quantity_         => new_quantity_,
                     old_quantity_         => old_quantity_,
                     report_picking_       => FALSE,
                     release_not_reserved_ => FALSE);
END Check_Quantity;


PROCEDURE Remove_Unattached_Qty (
   shipment_id_         IN NUMBER,
   shipment_line_no_    IN NUMBER)
IS
   conv_ship_reserv_qty NUMBER;
   CURSOR get_unattached_qty IS
      SELECT handling_unit_id, NVL((SELECT SUM(quantity)
                                      FROM SHIPMENT_RESERV_HANDL_UNIT_TAB sr
                                     WHERE sr.shipment_id      = sl.shipment_id
                                       AND sr.shipment_line_no = sl.shipment_line_no
                                       AND sr.handling_unit_id = sl.handling_unit_id), 0) ship_reserv_qty 
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB sl
       WHERE shipment_id       = shipment_id_
         AND shipment_line_no  = shipment_line_no_;
BEGIN
   FOR rec_ IN get_unattached_qty LOOP
      IF (rec_.ship_reserv_qty = 0) THEN
         Remove(shipment_id_, shipment_line_no_, rec_.handling_unit_id, FALSE);
      ELSE
         conv_ship_reserv_qty := Shipment_Handling_Utility_API.Get_Converted_Source_Qty(shipment_id_, 
                                                                                        shipment_line_no_,
                                                                                        rec_.ship_reserv_qty,
                                                                                        NULL,
                                                                                        NULL);
         Modify___(shipment_id_          => shipment_id_,
                   shipment_line_no_     => shipment_line_no_,
                   handling_unit_id_     => rec_.handling_unit_id,
                   quantity_             => conv_ship_reserv_qty,
                   modify_reserv_        => TRUE,
                   report_picking_       => FALSE,
                   release_not_reserved_ => FALSE );
         
      END IF;
   END LOOP;
END Remove_Unattached_Qty;


@UncheckedAccess
FUNCTION Get_Shipment_Qty_For_Inv_Parts (
   shipment_id_  IN NUMBER) RETURN NUMBER
IS
   inv_quantity_ NUMBER;
   
   CURSOR get_shipment_quantity IS
      SELECT NVL(SUM(slh.quantity * sl.conv_factor/sl.inverted_conv_factor),0)
        FROM SHIPMENT_LINE_HANDL_UNIT_TAB slh, SHIPMENT_LINE_TAB sl  
       WHERE slh.shipment_id     = shipment_id_ 
         AND sl.shipment_id      = slh.shipment_id
         AND sl.shipment_line_no = slh.shipment_line_no
         AND (((sl.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND (Utility_SYS.String_To_Number(sl.source_ref4) = 0))
              OR (sl.source_ref_type != Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER))
         AND sl.inventory_part_no IS NOT NULL;
BEGIN
   OPEN get_shipment_quantity;
   FETCH get_shipment_quantity INTO inv_quantity_;
   CLOSE get_shipment_quantity;
   RETURN inv_quantity_;
END Get_Shipment_Qty_For_Inv_Parts;


@UncheckedAccess
FUNCTION Get_Qty_Left_To_Assign (
   shipment_id_        IN NUMBER,
   shipment_line_no_   IN NUMBER,
   handling_unit_id_   IN NUMBER ) RETURN NUMBER
IS
   reserved_qty_attached_hu_   NUMBER;
   qty_attached_               NUMBER;
   inv_qty_attached_           NUMBER;
   reserv_qty_left_to_assign_  NUMBER;
   shipment_line_rec_          Shipment_Line_API.Public_Rec;
BEGIN
   shipment_line_rec_         := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);
                                                                                        
   reserved_qty_attached_hu_  := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(shipment_line_rec_.source_ref1,
                                                                                      NVL(shipment_line_rec_.source_ref2,'*'),
                                                                                      NVL(shipment_line_rec_.source_ref3,'*'),
                                                                                      NVL(shipment_line_rec_.source_ref4,'*'),                                                                                     
                                                                                      shipment_id_, 
                                                                                      shipment_line_no_,
                                                                                      handling_unit_id_);
                                                                                      
   qty_attached_              := Get_Quantity(shipment_id_, shipment_line_no_, handling_unit_id_);
   inv_qty_attached_          := (qty_attached_ * shipment_line_rec_.conv_factor/shipment_line_rec_.inverted_conv_factor);
   
   reserv_qty_left_to_assign_ := inv_qty_attached_ - reserved_qty_attached_hu_;
   RETURN NVL(reserv_qty_left_to_assign_, 0);   
END Get_Qty_Left_To_Assign;
