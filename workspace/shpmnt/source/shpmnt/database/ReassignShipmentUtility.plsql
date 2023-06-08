-----------------------------------------------------------------------------
--
--  Logical unit: ReassignShipmentUtility
--  Component:    SHPMNT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220727  RoJalk  SCDEV-11644, Added the method Validate_Rel_Reservations___.
--  220509  RoJalk  SCDEV-9142, Modified Reassign_Reservations__ and added an error to prevent release reservations for purchase receipt - shipment order.
--  220321  RoJalk  Bug 162855(SCDEV-8594), Modified Reassign_Pkg_Comp_Line___ to allow reassignment of reserved quantity when order line is partially reserved.
--  220105  PamPlk  SC21R2-7038, Modified Release_Reservations___ in order to restrict Release Reservation for Purchase Receipt Return.
--  210325  ThKrlk  Bug 157855(SCZ-14013), Modified Reassign_Reservations__() by converting qty of Inventory UoM to Sales UoM before send to Shipment_Line_Handl_Unit_API.Reduce_Quantity().
--  210325          And modified Reassign_Connected_Qty__() by adding new condition to bypass Shipment_Line_Handl_Unit_API.Remove_Or_Modify() when it reassign full quantity.
--  201018  RoJalk  SC2020R1-10349, Modified Validate_Reassign_To_Ship and added a NVL check for supply country comparison.
--  201002  RoJalk  SC2020R1-1987, Modified Release_Reservations___  so Inventory_Part_Reservation_API.Reassign_Shipment_Line call will include ignore_this_avail_control_id_ .
--  200407  Aabalk  Bug 153107(SCZ-9691), Modified Reassign_Handling_Unit() by passing the manual net weight to the Shipment_Line_Handl_Unit_API.New() method 
--  200407          to prevent losing the manual net weight data when reassigning a Handling Unit.
--  191126  Aabalk  SCSPRING20-1053, Added validation to Validate_Reassign_Reserve to disable releasing shipment order picked lines.
--  191121  Aabalk  SCSPRING20-280, Added new validation check for matching sender and receiver ID and types between 
--                  source and destination shipments in Validate_Reassign_To_Ship method.
--                  Modified error message INVALIDDELIVINFO and created new error message INVALIDSENRECINFO for sender and receiver related errors.
--  191115  MeAblk  SCSPRING20-937, Added new parameter values for method call Shipment_Handling_Utility_API.Create_Shipment__().
--  190930  DaZase  SCSPRING20-167, Added Add_Shipm_Status_Prel_Info___ and Raise_General_Error___ to solve MessageDefinitionValidation issues.
--  190925  WaSalk  Bug 147889 (SCZ-5545), Modifid Reassign_Handling_Unit() to set App_Context_SYS value SHIPMENT_LINE_REASSIGNING_ to not to loose manual gross weight values when reassigning Handling units.
--  180228  RoJalk  STRSC-15133, Replaced Shipment_Line_API.Check_Reset_Printed_Flags__ with Shipment_API.Check_Reset_Printed_Flags.
--  180228  RoJalk  STRSC-15133, Added the method Reset_Printed_On_Reassign_Line___.
--  171212  KiSalk  STRSC-4491, (Bug 132102 also fixed) Modified Reassign_Reservations__ to call Shipment_Line_Handl_Unit_API.Reduce_Quantity
--  171212          if the reservation is connected to a handling unit.
--  171016  DiKuLk  Bug 138039, Modified one of the constant in Reassign_Connected_Qty__() from QTYTOREASSIGNZERO to NOTREVERSEDREASSIGN in order to avoid overriding in language translations.
--  170810  MeAblk  Bug 137187, Added new parameter line_connected_qty_ into the method Get_Qty_To_Ship_Reassign___() and reimplemented it to give priority to the source when reassiging shipment qty.  
--  170526  RoJalk  LIM-11476, Modified Validate_Reassign_To_Ship and checked for customs_value_currency, source_ref_type and price incl tax.
--  170524  RoJalk  LIM-11476, Modified Validate_Reassign_To_Ship and included NVL checks for ship_via_code and delivery_terms.
--  170516  RoJalk  LIM-11281, Modified Validate_Reassign_Reserve and added parameters new_shipment_id_,  source_ref_type_db_.
--  170328  RoJalk  LIM-10058, Modified Release_Reservations___ and replaced Shipment_Source_Utility_API.Lock_And_Fetch_Reserve_Info
--  170328          call with Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info. Included Inventory_Part_Reservation_API.Reassign_Shipment_Line
--  170328          to support sources using semi-centralize reservations.
--  170302  RoJalk  LIM-11001, Replaced Shipment_Source_Utility_API.Public_Reservation_Rec with
--  170302          Reserve_Shipment_API.Public_Reservation_Rec.
--  170223  MaIklk  LIM-9422, Fixed to pass shipment_line_no as parameter when calling ShipmentReservHandlUnit methods.
--  170127  MaIklk  LIM-9825, Handled NVL for source ref columns when calling ShipmentReservHandlUnit methods.
--  170111  MaRalk  LIM-6755, Modified error message NOTENOUGHRESERVEDREL in Reassign_Handling_Unit method
--  170111          in order to support generic shipment functionality. Renamed NOTENOUGHRESERVEDREL as NOTENOUGHRESVEDLINE.
--  170109  Chfose  LIM-8650, Added call to in Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify_Reservation in Reassign_Connected_Reserve_Qty
--  170109          to unpack in inventory when not reassigning a Handling Unit.
--  161215  MaIklk  LIM-9932, Moved Move_Shipment_Reservation() to Reserve_Shipment_API.
--  161128  LePeSe  LIM-9193, Added call to Handling_Unit_API.Modify_Parent_Handling_Unit_Id in Reassign_Hu_Structure___ to make sure that
--  161128          the structure is disconnected from any parent handling unit ID that it might have, before modifying the shipment ID.
--  161128  MaIklk  LIM-9255, Fixed to directly access ShipmentReservHandlUnit since it is moved to SHPMNT.
--  161116  MaIklk  LIM-9429, Implemented to use ReserveShipment function to handle move shipment reservations.
--  161028  RoJalk  Moved the content of Shipment_Handling_Utility_API.Get_Qty_To_Ship_Reassign to 
--  161028          Reassign_Shipment_Utility_API.Get_Qty_To_Ship_Reassign___
--  160917  RoJalk  LIM-9301, Modified Move_Shipment_Reservation and passed 'FALSE' to move_to_ship_location_ parameter.
--  160902  MaRalk  LIM-8578, Replaced generic code with Shipment_Freight_API.Get_Supply_Country_Db.
--  160812  MaRalk  LIM-6755, Modified the error message SUPPCOUNTRYMISMATCH, SHIPBLOCKED, INVALIDDESTSHIP
--  160812          in order to support generic shipment functionality.
--  160812          Renamed INVALIDDESTSHIP to INVALIDDELIVINFO. 
--  160802  MaIklk  LIM-8217, Passed customs_value when reassign the line.
--  160801  RoJalk  LIM-8189, Modified Shipment_Source_Utility_API.Lock_And_Fetch_Reserve_Info,
--  160801          added the parameter qty_shipped_ and removed reassignment_type_.
--  160726  MaRalk  LIM-6531, Modified Validate_Reassign_To_Ship to delete duplicating error message INVALIDDESTSHIP.
--  160714  RoJalk  LIM-7359, Changed the scope of Release_Reservations to be implemenation, renamed and changed the 
--  160714          scope of Validate_Reassign_Reservation to be Validate_Reassign_Reserve___.
--  160714  RoJalk  LIM-7359, Added the methods Move_Shipment_Reservation, Reassign_Connected_Reserve_Qty and Release_Reservations.
--  160630  RoJalk  LIM-7604, Renamed line_item_no, part_no to source_ref4, inventory_part_no in reassign_ship_component_tmp
--  160607  RoJalk  LIM-6975, Replaced the usage of Shipment_API.Get_State with Shipment_API.Get_Objstate.
--  160607  RoJalk  LIM-7359, Added the method Validate_Reassign_Reservation.
--  160606  RoJalk  LIM-6794, Replaced the usage of Shipment_Line_API.Reassign_Pkg_Comp__ with 
--  160606          Reassign_Shipment_Utility_API.Reassign_Pkg_Comp_Line__ in Reassign_Shipment_Pkg_Line___.
--  160606  RoJalk  LIM-7588, Renamed Reassign_Connected_Qty__ to Reassign_Reservations__.
--  160606  RoJalk  LIM-6813, Modified Reassign_Handling_Unit and called Shipment_Source_Utility_API.Validate_Reassign_Hu.
--  160603  RoJalk  LIM-6813, Renamed Reassign_Handling_Unit to Reassign_Hu_Structure. Moved Reassign_Handling_Unit
--  160603          from Shipment_Line_Handl_Unit_API. Renamed Create_Reassign_Shipment___ to  Create_Shipment___.
--  160601  RoJalk  LIM-7358, Changed the scope of Reassign_Shipment__ to be implementation.
--  160531  RoJalk  LIM-7358, Changed the scope of Reassign_Pkg_Comp__ to be implementation.
--  160530  RoJalk  LIM-7358, Changed the scope of Fill_Temporary_Table__ to be implementation.
--  160518  reanpl  STRLOC-65, Added handling of new attributes address3, address4, address5, address6 
--  160518  RoJalk  LIM-7358, Added methods Reassign_Connected_Qty__, Reassign_Pkg_Comp__.
--  160509  MaRalk  LIM-6531, Modified methods Create_Reassign_Shipment___, Validate_Reassign_To_Ship__
--  160509          to reflect moving freight related columns from Shipment_Tab to order-Shipment_Freight_Tab.
--  160428  RoJalk  LIM-6811, Replaced Shipment_Handling_Utility_API.Reassign_Connected_Qty__
--  160428          with Reassign_Shipment_Utility_API.Reassign_Connected_Qty__.
--  160428  RoJalk  LIM-6811, Replaced Shipment_Handling_Utility_API.Reassign_Pkg_Comp_Qty__ 
--  160428          with eassign_Shipment_Utility_API.Reassign_Pkg_Comp_Qty__.
--  160427  RoJalk  LIM-6811, Added methods Reassign_Handling_Unit, Reassign_Handling_Unit,Validate_Reassign_Shipment__, 
--  160427          Reassign_Handling_Unit___, Reassign_Shipment__, Create_Reassign_Shipment___,
--  160427          Validate_Reassign_To_Ship, Validate_Reassign_To_Ship__, Reassign_Pkg_Comp__.
--  160411  RoJalk  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_         CONSTANT VARCHAR2(15) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_Shipm_Status_Prel_Info___ (
   shipment_id_  IN NUMBER )
IS
BEGIN
   Client_SYS.Add_Info(lu_name_, 'SHIPCHEDTOPRELIM: The status of shipment ID :P1 is changed to Preliminary.', shipment_id_);
END Add_Shipm_Status_Prel_Info___;   

PROCEDURE Raise_General_Error___ (
   err_text_1_ IN VARCHAR2,
   err_text_2_ IN VARCHAR2 )
IS
BEGIN   
   Error_SYS.Record_General(lu_name_, 'GENERALERROR1: :P1 :P2', err_text_1_, err_text_2_);
END Raise_General_Error___;   


-- Reassign_Hu_Structure___
--   Create a new shipment if CREATE_NEW_SHIPMENT option is selected.
--   Reassign the handling unit and underling HU structure.
PROCEDURE Reassign_Hu_Structure___ (
   to_shipment_id_       IN OUT NUMBER,
   from_shipment_id_     IN     NUMBER,
   handling_unit_id_     IN     NUMBER,
   release_reservations_ IN     VARCHAR2,
   destination_          IN     VARCHAR2 )
IS
   new_shipment_id_            NUMBER;
   source_shipment_rec_        Shipment_API.Public_Rec;
   do_release_reservations_    BOOLEAN:= FALSE;
   prev_source_shipment_state_ VARCHAR2(20);
   prev_dest_shipment_state_   VARCHAR2(20);
   curr_source_shipment_state_ VARCHAR2(20);
   curr_dest_shipment_state_   VARCHAR2(20);
BEGIN
   source_shipment_rec_        := Shipment_API.Get(from_shipment_id_);
   Validate_Reassign_Shipment__(from_shipment_id_, Shipment_API.Get_Objstate(from_shipment_id_), source_shipment_rec_.shipment_category);
   prev_source_shipment_state_ := Shipment_API.Get_Objstate(from_shipment_id_);

   IF (destination_ = 'CREATE_NEW_SHIPMENT') THEN
      Create_Shipment___(new_shipment_id_,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         from_shipment_id_,
                         source_shipment_rec_ );
   ELSE  
      prev_dest_shipment_state_   := Shipment_API.Get_Objstate(to_shipment_id_);
      new_shipment_id_            := to_shipment_id_;
      Validate_Reassign_To_Ship(new_shipment_id_, from_shipment_id_);
   END IF;
   
   IF (release_reservations_ = 'TRUE') THEN   
      do_release_reservations_ := TRUE;
   END IF;

   to_shipment_id_ := new_shipment_id_;
   Handling_Unit_API.Modify_Parent_Handling_Unit_Id(handling_unit_id_, parent_handling_unit_id_ => NULL);
   Handling_Unit_API.Modify_Shipment_Id(handling_unit_id_, to_shipment_id_, do_release_reservations_);

   -- included the info handling in Shipment_Order_Line_API.Update___ to avoid the risk of clearing the info_
   curr_source_shipment_state_ := Shipment_API.Get_Objstate(from_shipment_id_);      
   IF (prev_source_shipment_state_ != curr_source_shipment_state_) THEN
      Add_Shipm_Status_Prel_Info___(from_shipment_id_);
   END IF;

   IF (destination_ = 'ADD_TO_EXIST_SHIPMENT') THEN
      curr_dest_shipment_state_   := Shipment_API.Get_Objstate(to_shipment_id_);
      IF (prev_dest_shipment_state_ != curr_dest_shipment_state_) THEN
         Add_Shipm_Status_Prel_Info___(to_shipment_id_);
      END IF;
   END IF;
END Reassign_Hu_Structure___;


PROCEDURE Create_Shipment___ (
   new_shipment_id_     OUT NUMBER,
   source_ref1_         IN  VARCHAR2,
   source_ref2_         IN  VARCHAR2,
   source_ref3_         IN  VARCHAR2,
   source_ref4_         IN  VARCHAR2,
   source_ref_type_db_  IN  VARCHAR2,
   source_shipment_id_  IN  NUMBER,
   source_shipment_rec_ IN  Shipment_API.Public_Rec )
IS 
   use_price_incl_tax_db_ VARCHAR2(20); 
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      use_price_incl_tax_db_ := Shipment_Freight_API.Get_Use_Price_Incl_Tax_Db(source_shipment_id_);
   $END
   Shipment_Handling_Utility_API.Create_Shipment__(new_shipment_id_,
                                                   source_ref1_,
                                                   source_ref2_,
                                                   source_ref3_,
                                                   source_ref4_,
                                                   source_ref_type_db_,
                                                   source_shipment_rec_.receiver_id,
                                                   source_shipment_rec_.receiver_type,
                                                   source_shipment_rec_.sender_id,
                                                   source_shipment_rec_.sender_type,
                                                   source_shipment_rec_.sender_addr_id,
                                                   source_shipment_rec_.receiver_addr_id,
                                                   source_shipment_rec_.ship_via_code,
                                                   source_shipment_rec_.contract,
                                                   source_shipment_rec_.delivery_terms,
                                                   source_shipment_rec_.del_terms_location,
                                                   source_shipment_rec_.forward_agent_id,
                                                   use_price_incl_tax_db_,
                                                   source_shipment_rec_.shipment_type,
                                                   source_shipment_id_ );
END Create_Shipment___;


PROCEDURE Reassign_Line___ (
   destination_shipment_id_     IN OUT NUMBER,
   source_shipment_id_          IN     NUMBER,
   source_shipment_line_no_     IN     NUMBER,
   source_ref1_                 IN     VARCHAR2,
   source_ref2_                 IN     VARCHAR2,
   source_ref3_                 IN     VARCHAR2,
   source_ref4_                 IN     VARCHAR2,
   source_ref_type_db_          IN     VARCHAR2,
   destination_                 IN     VARCHAR2,
   revised_qty_due_to_reassign_ IN     NUMBER,
   qty_to_ship_to_reassign_     IN     NUMBER )
IS
   new_shipment_id_            NUMBER;
   source_shipment_rec_        Shipment_API.Public_Rec; 
   source_shipment_line_rec_   Shipment_Line_API.Public_Rec; 
   new_shipment_line_no_       NUMBER;
BEGIN
   source_shipment_rec_ := Shipment_API.Get(source_shipment_id_);
   Validate_Reassign_Shipment__(source_shipment_id_, Shipment_API.Get_Objstate(source_shipment_id_), source_shipment_rec_.shipment_category);

   new_shipment_id_ := destination_shipment_id_;
   IF (destination_ = 'CREATE_NEW_SHIPMENT') THEN
      Create_Shipment___(new_shipment_id_,
                         source_ref1_,
                         source_ref2_,
                         source_ref3_,
                         source_ref4_,
                         source_ref_type_db_,
                         source_shipment_id_,
                         source_shipment_rec_ );
   ELSE
      Validate_Reassign_To_Ship(new_shipment_id_, source_shipment_id_);
   END IF;
   source_shipment_line_rec_ :=  Shipment_Line_API.Get(source_shipment_id_, source_shipment_line_no_);
   Shipment_Line_API.Reassign_Line__(new_shipment_line_no_, 
                                     source_shipment_id_,
                                     new_shipment_id_, 
                                     source_ref1_,
                                     source_ref2_,
                                     source_ref3_,
                                     source_ref4_,
                                     source_ref_type_db_,
                                     source_shipment_line_rec_.source_part_no,
                                     source_shipment_line_rec_.source_part_description,
                                     source_shipment_line_rec_.inventory_part_no, 
                                     source_shipment_line_rec_.source_unit_meas,
                                     source_shipment_line_rec_.conv_factor,
                                     source_shipment_line_rec_.inverted_conv_factor,
                                     revised_qty_due_to_reassign_,
                                     qty_to_ship_to_reassign_,
                                     'CONNECTED_QUANTITY',
                                     source_shipment_line_rec_.customs_value);    
   destination_shipment_id_ := new_shipment_id_;  
END Reassign_Line___;

-- Reassign_Shipment_Pkg_Line___
--   Reassign each component line for a PKG and transfer the reservations.
@DynamicComponentDependency ORDER
PROCEDURE Reassign_Shipment_Pkg_Line___ (
   qty_picked_in_ship_inventory_ OUT VARCHAR2,
   order_no_                     IN  VARCHAR2,
   line_no_                      IN  VARCHAR2,
   rel_no_                       IN  VARCHAR2,
   source_shipment_id_           IN  NUMBER,
   destination_shipment_id_      IN  NUMBER,
   do_release_reservations_      IN  BOOLEAN,
   pkg_not_reserved_to_reassign_ IN  NUMBER,
   pkg_reserved_qty_to_reassign_ IN  NUMBER )
IS
   line_item_no_to_reassign_ NUMBER;
   non_inventory_part_       BOOLEAN:=FALSE;
   order_line_rec_           Customer_Order_Line_API.Public_Rec;
   qty_to_reassign_          NUMBER;
   ship_line_rec_            Shipment_Line_API.Public_Rec;   
   source_shipment_line_no_  SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
   shipment_line_no_pkg_     SHIPMENT_LINE_TAB.SHIPMENT_LINE_NO%TYPE;
   
   CURSOR get_reservations IS
      SELECT source_ref4, contract,
             inventory_part_no, location_no, lot_batch_no, serial_no, eng_chg_level, 
             waiv_dev_rej_no, activity_seq, handling_unit_id, pick_list_no, 
             configuration_id, not_reserved_qty, reserved_qty, catch_qty
        FROM reassign_ship_component_tmp
       WHERE reserved_qty > 0
         AND inventory_part_no IS NOT NULL;

   CURSOR get_shipment_lines IS
      SELECT SUM(reserved_qty) reserved_to_reassign, SUM(not_reserved_qty) not_reserved_to_reassign, source_ref4
        FROM reassign_ship_component_tmp
       GROUP BY source_ref4;

   CURSOR get_shipment_line_to_reassign IS
      SELECT DISTINCT sl.source_ref4
        FROM shipment_line_tab sl
       WHERE NVL(sl.source_ref1, string_null_) = NVL(order_no_, string_null_)
         AND NVL(sl.source_ref2, string_null_) = NVL(line_no_,  string_null_)
         AND NVL(sl.source_ref3, string_null_) = NVL(rel_no_,   string_null_)
         AND Utility_SYS.String_To_Number(sl.source_ref4) > 0
         AND sl.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER
         AND NOT EXISTS (SELECT 1
                           FROM reassign_ship_component_tmp rsc
                          WHERE rsc.source_ref4 = sl.source_ref4 );
BEGIN
   OPEN get_shipment_line_to_reassign;
   FETCH get_shipment_line_to_reassign INTO line_item_no_to_reassign_;
   CLOSE get_shipment_line_to_reassign;
   
   -- validate if qty to reassign is defined for all components before starting the reassignment process
   IF (line_item_no_to_reassign_ IS NOT NULL) THEN
      order_line_rec_  := Customer_Order_Line_API.Get(order_no_ , line_no_, rel_no_, line_item_no_to_reassign_);
      ship_line_rec_   := Shipment_Line_API.Get_By_Source(source_shipment_id_, order_no_ , line_no_, rel_no_, line_item_no_to_reassign_, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);      
      qty_to_reassign_ := (NVL(pkg_not_reserved_to_reassign_, 0) + NVL(pkg_reserved_qty_to_reassign_, 0)) * (order_line_rec_.qty_per_assembly * ship_line_rec_.conv_factor / ship_line_rec_.inverted_conv_factor);
      Error_SYS.Record_General(lu_name_, 'QTYREASSINNULL: A total quantity to reassign of :P1 must be defined for component part :P2 with line item no :P3.', qty_to_reassign_, order_line_rec_.catalog_no, line_item_no_to_reassign_);
   END IF;

   FOR shipment_line_rec_ IN get_shipment_lines LOOP
      order_line_rec_ := Customer_Order_Line_API.Get(order_no_ , line_no_, rel_no_, shipment_line_rec_.source_ref4);
      ship_line_rec_ := Shipment_Line_API.Get_By_Source(source_shipment_id_, order_no_ , line_no_, rel_no_, shipment_line_rec_.source_ref4, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);      
      IF (order_line_rec_.part_no IS NULL) THEN
         non_inventory_part_ := TRUE;
      ELSE
         non_inventory_part_ := FALSE;
      END IF;
                                       
      source_shipment_line_no_ := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(source_shipment_id_, order_no_, line_no_, rel_no_,
                                                                                 shipment_line_rec_.source_ref4, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);
      Shipment_Line_API.Lock__(source_shipment_id_, source_shipment_line_no_);
      shipment_line_no_pkg_    := Shipment_Line_API.Fetch_Ship_Line_No_By_Source(source_shipment_id_, order_no_, line_no_, rel_no_,
                                                                                 -1, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);                                      
                                            
      Reassign_Pkg_Comp_Line___(source_shipment_id_             ,
                                source_shipment_line_no_        ,
                                shipment_line_no_pkg_           ,
                                destination_shipment_id_        ,
                                order_no_                       ,
                                line_no_                        ,
                                rel_no_                         ,
                                shipment_line_rec_.source_ref4  ,
                                (order_line_rec_.qty_per_assembly * ship_line_rec_.conv_factor / ship_line_rec_.inverted_conv_factor),
                                pkg_not_reserved_to_reassign_   ,
                                pkg_reserved_qty_to_reassign_   ,
                                shipment_line_rec_.not_reserved_to_reassign,
                                shipment_line_rec_.reserved_to_reassign,
                                non_inventory_part_             ,
                                do_release_reservations_        );
                                                                                             

   END LOOP;

   FOR reservations_rec_ IN get_reservations LOOP
      -- transfer reservations
      Reassign_Connected_Reserve_Qty(qty_picked_in_ship_inventory_ => qty_picked_in_ship_inventory_,
                                     source_ref1_                  => order_no_,
                                     source_ref2_                  => line_no_,
                                     source_ref3_                  => rel_no_,
                                     source_ref4_                  => reservations_rec_.source_ref4,
                                     source_ref_type_db_           => 'CUSTOMER_ORDER',
                                     contract_                     => reservations_rec_.contract,
                                     part_no_                      => reservations_rec_.inventory_part_no,
                                     location_no_                  => reservations_rec_.location_no,
                                     lot_batch_no_                 => reservations_rec_.lot_batch_no,
                                     serial_no_                    => reservations_rec_.serial_no,
                                     eng_chg_level_                => reservations_rec_.eng_chg_level,
                                     waiv_dev_rej_no_              => reservations_rec_.waiv_dev_rej_no,
                                     activity_seq_                 => reservations_rec_.activity_seq,
                                     handling_unit_id_             => reservations_rec_.handling_unit_id,
                                     pick_list_no_                 => reservations_rec_.pick_list_no,
                                     configuration_id_             => reservations_rec_.configuration_id,
                                     shipment_id_                  => source_shipment_id_,
                                     new_shipment_id_              => destination_shipment_id_,
                                     release_reservations_         => do_release_reservations_,
                                     qty_to_reassign_              => reservations_rec_.reserved_qty,
                                     catch_qty_to_reassign_        => reservations_rec_.catch_qty,
                                     reassignment_type_            => 'CONNECTED_QUANTITY');
   END LOOP;
END Reassign_Shipment_Pkg_Line___;

@DynamicComponentDependency ORDER
PROCEDURE Reassign_Pkg_Comp_Line___ (
   source_shipment_id_             IN NUMBER,
   source_shipment_line_no_        IN NUMBER,
   shipment_line_no_pkg_           IN NUMBER,
   destination_shipment_id_        IN NUMBER,
   order_no_                       IN VARCHAR2,
   line_no_                        IN VARCHAR2,
   rel_no_                         IN VARCHAR2,
   line_item_no_                   IN NUMBER,
   qty_per_assembly_               IN NUMBER,
   pkg_not_reserved_to_reassign_   IN NUMBER,
   pkg_reserved_qty_to_reassign_   IN NUMBER,
   not_reserved_to_reassign_       IN NUMBER,
   reserved_to_reassign_           IN NUMBER,
   non_inventory_part_             IN BOOLEAN,
   do_release_reservations_        IN BOOLEAN )
IS 
   shipment_line_rec_              Shipment_Line_API.Public_Rec;
   not_reserved_comp_qty_          NUMBER;
   reserved_comp_qty_              NUMBER;
   total_comp_qty_to_reassign_     NUMBER:=0;
   total_pkg_qty_to_reassign_      NUMBER:=0;
   qty_to_ship_                    NUMBER:=0;
   remaining_reserved_comp_qty_    NUMBER:=0;
   shipment_pkg_line_rec_          Shipment_Line_API.Public_Rec;
   remaining_reserved_pkg_qty_     NUMBER:=0;
   reserved_qty_for_not_reserved_  NUMBER:=0;
   not_reserv_comp_qty_required_   NUMBER:=0;
   total_not_reserv_to_reassign_   NUMBER:=0;
   remaining_not_reserv_pkg_qty_   NUMBER:=0;
   remaining_not_reserv_comp_qty_  NUMBER:=0;
   total_comp_qty_                 NUMBER:=0;
   revised_qty_due_reassigned_     NUMBER:=0;
   qty_to_ship_in_source_          NUMBER:=0;
   err_text_1_                     VARCHAR2(2000);
   err_text_2_                     VARCHAR2(2000);
   destination_shipment_line_no_   NUMBER;
BEGIN
   shipment_line_rec_     := Shipment_Line_API.Get(source_shipment_id_, source_shipment_line_no_);
   shipment_pkg_line_rec_ := Shipment_Line_API.Get(source_shipment_id_, shipment_line_no_pkg_);
   
   total_comp_qty_to_reassign_ := not_reserved_to_reassign_ + reserved_to_reassign_;
   total_pkg_qty_to_reassign_  := NVL(pkg_not_reserved_to_reassign_, 0) + NVL(pkg_reserved_qty_to_reassign_, 0);
   not_reserved_comp_qty_      := pkg_not_reserved_to_reassign_ * qty_per_assembly_;
   reserved_comp_qty_          := pkg_reserved_qty_to_reassign_ * qty_per_assembly_;
   total_comp_qty_             := total_pkg_qty_to_reassign_ * qty_per_assembly_;

   IF (reserved_to_reassign_ > 0) THEN
      -- calculate the reserved qty to be allocated to not reserved qty to reassign
      IF (not_reserved_to_reassign_ = not_reserved_comp_qty_) THEN
         reserved_qty_for_not_reserved_ := 0;
      ELSE
         not_reserv_comp_qty_required_  := not_reserved_comp_qty_ - not_reserved_to_reassign_;
         reserved_qty_for_not_reserved_ := LEAST(not_reserv_comp_qty_required_, reserved_to_reassign_);
      END IF;
   END IF;
   
   err_text_1_ := Language_SYS.Translate_Constant (lu_name_,
                                                   'INCORREASSIGNQTY: Based on the quantity per assembly for component part :P1 with line item no :P2, the quantity to reassign must be adjusted with ',
                                                   NULL,
                                                   shipment_line_rec_.source_part_no, line_item_no_);
                                                   
   IF (pkg_not_reserved_to_reassign_ > 0) THEN
      total_not_reserv_to_reassign_  := not_reserved_to_reassign_ + reserved_qty_for_not_reserved_;
      remaining_not_reserv_pkg_qty_  := (shipment_pkg_line_rec_.inventory_qty - shipment_pkg_line_rec_.qty_assigned) - pkg_not_reserved_to_reassign_;
      remaining_not_reserv_comp_qty_ := (shipment_line_rec_.inventory_qty - shipment_line_rec_.qty_assigned - shipment_line_rec_.qty_to_ship) - total_not_reserv_to_reassign_;
      IF ((not_reserved_comp_qty_ < total_not_reserv_to_reassign_) OR ((remaining_not_reserv_pkg_qty_* qty_per_assembly_) < remaining_not_reserv_comp_qty_)) THEN
         err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                         'INCORRECTNOTRES: :P1 in order to be able to reassign :P2 not reserved packages.',
                                                         NULL,
                                                         (not_reserved_comp_qty_ - total_not_reserv_to_reassign_), pkg_not_reserved_to_reassign_);
         Raise_General_Error___(err_text_1_, err_text_2_);
      END IF;
   END IF;

   IF (reserved_to_reassign_ > 0) THEN
      IF non_inventory_part_ THEN
         remaining_reserved_comp_qty_ := shipment_line_rec_.qty_to_ship - reserved_to_reassign_;
      ELSE
         remaining_reserved_comp_qty_ := shipment_line_rec_.qty_assigned - reserved_to_reassign_;
      END IF;
      remaining_reserved_pkg_qty_  := shipment_pkg_line_rec_.qty_assigned - pkg_reserved_qty_to_reassign_;
      IF ((pkg_reserved_qty_to_reassign_ > 0 AND reserved_comp_qty_ < (reserved_to_reassign_ - reserved_qty_for_not_reserved_))
         OR (shipment_pkg_line_rec_.qty_assigned > 0 AND (remaining_reserved_pkg_qty_* qty_per_assembly_) > remaining_reserved_comp_qty_)) THEN 
         err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                         'INCORRECTRES: :P1 in order to be able to reassign :P2 reserved packages.',
                                                         NULL,
                                                         (reserved_comp_qty_ - (reserved_to_reassign_ - reserved_qty_for_not_reserved_)), pkg_reserved_qty_to_reassign_);
         Raise_General_Error___(err_text_1_, err_text_2_);
      END IF;
   END IF;

   IF (total_comp_qty_ != total_comp_qty_to_reassign_) THEN
      err_text_2_ := Language_SYS.Translate_Constant (lu_name_,
                                                      'INCORTOTRES: :P1 in order to be able to reassign :P2 packages.',
                                                      NULL,
                                                      (total_comp_qty_ - total_comp_qty_to_reassign_), total_pkg_qty_to_reassign_);
      Raise_General_Error___(err_text_1_, err_text_2_);
   END IF;

   IF non_inventory_part_ THEN
      qty_to_ship_ := reserved_to_reassign_;
      IF do_release_reservations_ THEN
         qty_to_ship_in_source_ := 0;
      ELSE
         qty_to_ship_in_source_ := reserved_to_reassign_;
      END IF;
   END IF;
   
   -- create a new line in destination shipment
   IF  (destination_shipment_id_ != 0) THEN
      Shipment_Line_API.Reassign_Line__(destination_shipment_line_no_                  ,
                                        source_shipment_id_                            ,
                                        destination_shipment_id_                       ,
                                        order_no_                                      ,
                                        line_no_                                       ,
                                        rel_no_                                        ,
                                        line_item_no_                                  ,
                                        Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER,
                                        shipment_line_rec_.source_part_no              ,
                                        shipment_line_rec_.source_part_description     ,
                                        shipment_line_rec_.inventory_part_no           ,
                                        shipment_line_rec_.source_unit_meas            ,
                                        shipment_line_rec_.conv_factor                 , 
                                        shipment_line_rec_.inverted_conv_factor        ,
                                        total_comp_qty_to_reassign_                    ,
                                        qty_to_ship_in_source_                         ,
                                        'CONNECTED_QUANTITY'                           ,
                                        shipment_line_rec_.customs_value               );
   END IF;
   
   -- update the source shipment line, reduce not_reserved_to_reassign_ and qty_to_ship_ from revised_qty_due and qty_to_ship.
   IF ((not_reserved_to_reassign_ > 0) OR (qty_to_ship_ > 0)) THEN 
      IF (qty_to_ship_ > 0) THEN
         revised_qty_due_reassigned_ := not_reserved_to_reassign_ + qty_to_ship_;
      ELSE
         revised_qty_due_reassigned_ := not_reserved_to_reassign_;
      END IF;
      Shipment_Line_API.Update_Source_On_Reassign__(source_shipment_id_, source_shipment_line_no_, 
                                                    revised_qty_due_reassigned_, qty_to_ship_, 'CONNECTED_QUANTITY' );
   END IF;
   
END Reassign_Pkg_Comp_Line___;


PROCEDURE Fill_Temporary_Table___ (
   source_ref4_              IN VARCHAR2,
   contract_                 IN VARCHAR2,
   inventory_part_no_        IN VARCHAR2,
   location_no_              IN VARCHAR2,
   lot_batch_no_             IN VARCHAR2,
   serial_no_                IN VARCHAR2,
   eng_chg_level_            IN VARCHAR2,
   waiv_dev_rej_no_          IN VARCHAR2,
   activity_seq_             IN NUMBER,
   handling_unit_id_         IN NUMBER,
   pick_list_no_             IN VARCHAR2,
   configuration_id_         IN VARCHAR2,
   not_reserved_to_reassign_ IN NUMBER,
   reserved_to_reassign_     IN NUMBER,
   catch_qty_                IN NUMBER )
IS
BEGIN
   INSERT 
      INTO reassign_ship_component_tmp (
         source_ref4,
         contract,
         inventory_part_no,
         location_no,
         lot_batch_no,
         serial_no,
         eng_chg_level,
         waiv_dev_rej_no,
         activity_seq,
         handling_unit_id,
         pick_list_no,
         configuration_id,
         not_reserved_qty,
         reserved_qty,
         catch_qty)
      VALUES (
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
         pick_list_no_,
         configuration_id_,
         NVL(not_reserved_to_reassign_, 0),
         NVL(reserved_to_reassign_,     0),
         catch_qty_);
END Fill_Temporary_Table___;


PROCEDURE Release_Reservations___ (
   qty_picked_in_ship_inventory_ OUT VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   source_ref_type_db_           IN  VARCHAR2, 
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,
   location_no_                  IN  VARCHAR2,
   lot_batch_no_                 IN  VARCHAR2,
   serial_no_                    IN  VARCHAR2,
   eng_chg_level_                IN  VARCHAR2,
   waiv_dev_rej_no_              IN  VARCHAR2,
   activity_seq_                 IN  NUMBER,
   handling_unit_id_             IN  NUMBER,
   pick_list_no_                 IN  VARCHAR2,
   configuration_id_             IN  VARCHAR2,
   shipment_id_                  IN  NUMBER,
   new_shipment_id_              IN  NUMBER,
   qty_to_reassign_              IN  NUMBER,
   catch_qty_to_reassign_        IN  NUMBER,
   reassignment_type_            IN  VARCHAR2 )
IS
   remaining_qty_assigned_       NUMBER := 0;
   remaining_qty_picked_         NUMBER := 0;
   picked_qty_to_transfer_       NUMBER := 0;
   location_type_db_             VARCHAR2(20);
   remaining_catch_qty_          NUMBER := 0;
   qty_assigned_                 NUMBER := 0;
   qty_picked_                   NUMBER := 0;
   catch_qty_                    NUMBER := 0;
   public_reservation_rec_       Reserve_Shipment_API.Public_Reservation_Rec; 
   ignore_this_avail_control_id_ VARCHAR2(25);
   warehouse_info_               Shipment_Source_Utility_API.Warehouse_Info_Rec;
BEGIN
   Validate_Rel_Reservations___(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_);
   
   qty_picked_in_ship_inventory_ := 'FALSE';
   location_type_db_             := Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_);
   IF (location_type_db_ = 'SHIPMENT') THEN
      qty_picked_in_ship_inventory_ := 'TRUE';
   END IF;

   IF (qty_picked_in_ship_inventory_ = 'TRUE') THEN
      -- if shipment inventory is used reservation moved to destination record but not released.
      Reserve_Shipment_API.Move_Shipment_Reservation(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                     contract_, part_no_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_,
                                                     waiv_dev_rej_no_, activity_seq_, handling_unit_id_, pick_list_no_, configuration_id_,                               
                                                     shipment_id_, new_shipment_id_, qty_to_reassign_, catch_qty_to_reassign_, reassignment_type_ );      
   ELSE                                                                                  
      public_reservation_rec_ := Reserve_Shipment_API.Lock_And_Fetch_Reserve_Info(source_ref1_        => source_ref1_,
                                                                                  source_ref2_        => source_ref2_,
                                                                                  source_ref3_        => source_ref3_,
                                                                                  source_ref4_        => source_ref4_,
                                                                                  source_ref_type_db_ => source_ref_type_db_,
                                                                                  contract_           => contract_, 
                                                                                  part_no_            => part_no_,
                                                                                  location_no_        => location_no_, 
                                                                                  lot_batch_no_       => lot_batch_no_, 
                                                                                  serial_no_          => serial_no_,
                                                                                  eng_chg_level_      => eng_chg_level_, 
                                                                                  waiv_dev_rej_no_    => waiv_dev_rej_no_, 
                                                                                  activity_seq_       => activity_seq_,
                                                                                  handling_unit_id_   => handling_unit_id_, 
                                                                                  pick_list_no_       => pick_list_no_, 
                                                                                  configuration_id_   => configuration_id_, 
                                                                                  shipment_id_        => shipment_id_ ); 
                                                                                   
      qty_assigned_ := public_reservation_rec_.qty_assigned;
      qty_picked_   := public_reservation_rec_.qty_picked;
      catch_qty_    := public_reservation_rec_.catch_qty;
      
      Validate_Reassign_Reserve(qty_to_reassign_           => qty_to_reassign_, 
                                catch_qty_to_reassign_     => catch_qty_to_reassign_,
                                reassignment_type_         => reassignment_type_,
                                qty_assigned_              => qty_assigned_,
                                pick_list_no_              => pick_list_no_, 
                                qty_picked_                => qty_picked_, 
                                catch_qty_                 => catch_qty_, 
                                new_shipment_id_           => new_shipment_id_, 
                                source_ref_type_db_        => source_ref_type_db_);
      
      remaining_qty_assigned_    := qty_assigned_ - qty_to_reassign_;         
      IF (catch_qty_to_reassign_ > 0) THEN
         remaining_catch_qty_    := catch_qty_ - catch_qty_to_reassign_;   
      END IF;
      IF (qty_picked_ > 0) THEN
         picked_qty_to_transfer_ := -(qty_to_reassign_);  
         remaining_qty_picked_   := qty_picked_ - picked_qty_to_transfer_;
      ELSE
         picked_qty_to_transfer_ := 0;
      END IF;
      
      IF(Reserve_Shipment_API.Use_Generic_Reservation(source_ref_type_db_)) THEN
         
         IF (source_ref_type_db_ = Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER) THEN
            $IF Component_Shipod_SYS.INSTALLED $THEN
               warehouse_info_               := Shipment_Source_Utility_API.Get_Warehouse_Info(shipment_id_, source_ref1_, source_ref_type_db_);
               ignore_this_avail_control_id_ := warehouse_info_.availability_control_id;
            $ELSE   
               Error_SYS.Component_Not_Exist('SHIPOD');
            $END
         END IF;
         
         Inventory_Part_Reservation_API.Reassign_Shipment_Line(contract_                     => contract_,
                                                               part_no_                      => part_no_,
                                                               configuration_id_             => configuration_id_, 
                                                               location_no_                  => location_no_,
                                                               lot_batch_no_                 => lot_batch_no_, 
                                                               serial_no_                    => serial_no_,
                                                               eng_chg_level_                => eng_chg_level_, 
                                                               waiv_dev_rej_no_              => waiv_dev_rej_no_, 
                                                               activity_seq_                 => activity_seq_, 
                                                               handling_unit_id_             => handling_unit_id_,                                                        
                                                               new_shipment_id_              => new_shipment_id_,
                                                               release_reservations_         => TRUE,
                                                               qty_reserved_                 => -(qty_to_reassign_),
                                                               qty_picked_                   => -(picked_qty_to_transfer_),
                                                               catch_qty_picked_             => -(NVL(catch_qty_to_reassign_, 0)),
                                                               source_ref_type_db_           => source_ref_type_db_,
                                                               source_ref1_                  => source_ref1_, 
                                                               source_ref2_                  => NVL(source_ref2_,'*'),
                                                               source_ref3_                  => NVL(source_ref3_,'*'),
                                                               source_ref4_                  => NVL(source_ref4_,'*'),                                                      
                                                               pick_list_no_                 => Reserve_Shipment_API.Convert_Pick_List_No_To_Num(pick_list_no_),
                                                               old_shipment_id_              => shipment_id_,
                                                               ignore_this_avail_control_id_ => ignore_this_avail_control_id_,
                                                               string_parameter1_            => reassignment_type_,
                                                               string_parameter2_            => Fnd_Boolean_API.DB_FALSE);
      ELSE   
         IF (remaining_qty_assigned_ = 0) THEN
            -- remove the source reservation if remaining qty is zero
            Shipment_Source_Utility_API.Remove_Reservation(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                           contract_, part_no_, location_no_, lot_batch_no_,
                                                           serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                                           pick_list_no_, configuration_id_, shipment_id_, reassignment_type_, 'FALSE');
         ELSE
            -- Update source 
            Shipment_Source_Utility_API.Update_Reserve_On_Reassign(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_,
                                                                   contract_, part_no_, location_no_, lot_batch_no_,
                                                                   serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_,
                                                                   pick_list_no_, configuration_id_, shipment_id_,
                                                                   remaining_qty_assigned_, remaining_qty_picked_,
                                                                   remaining_catch_qty_, reassignment_type_ ); 
         END IF;

         Shipment_Source_Utility_API.Reduce_Reserve_On_Reassign(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_, 
                                                                contract_, part_no_, location_no_, lot_batch_no_,
                                                                serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_,
                                                                handling_unit_id_, configuration_id_, qty_to_reassign_, picked_qty_to_transfer_ );
                                                             
      END IF;
     
      
   END IF;
END Release_Reservations___;


FUNCTION Get_Qty_To_Ship_Reassign___ (
   qty_to_reassign_    IN NUMBER,
   qty_to_ship_        IN NUMBER,
   line_connected_qty_ IN NUMBER ) RETURN NUMBER
IS
   qty_to_ship_reassign_ NUMBER := 0;
BEGIN
   IF ((line_connected_qty_ - qty_to_ship_) >= qty_to_reassign_) THEN
      qty_to_ship_reassign_ := 0;
   ELSE
      qty_to_ship_reassign_ := qty_to_reassign_ - (line_connected_qty_ - qty_to_ship_); 
   END IF;
   
   RETURN qty_to_ship_reassign_;
END Get_Qty_To_Ship_Reassign___;


PROCEDURE Reset_Printed_On_Reassign_Line___ (
   destination_shipment_id_ IN NUMBER,
   source_shipment_id_      IN NUMBER )
IS
BEGIN
   -- Check the destination_shipment_id_ to see if the shipment line is released back to Customer Order
   IF (NVL(destination_shipment_id_, 0) != 0) THEN
      Shipment_API.Check_Reset_Printed_Flags(shipment_id_                => destination_shipment_id_, 
                                             unset_pkg_list_print_       => TRUE, 
                                             unset_consignment_print_    => TRUE,
                                             unset_del_note_print_       => TRUE, 
                                             unset_pro_forma_print_      => TRUE,
                                             unset_bill_of_lading_print_ => TRUE,
                                             unset_address_label_print_  => FALSE );
   END IF;         
   
   Shipment_API.Check_Reset_Printed_Flags(shipment_id_                => source_shipment_id_,
                                          unset_pkg_list_print_       => TRUE, 
                                          unset_consignment_print_    => TRUE, 
                                          unset_del_note_print_       => TRUE, 
                                          unset_pro_forma_print_      => TRUE,
                                          unset_bill_of_lading_print_ => TRUE,
                                          unset_address_label_print_  => FALSE );
   
                                        
END Reset_Printed_On_Reassign_Line___;

PROCEDURE Validate_Rel_Reservations___ (
   source_ref1_        IN  VARCHAR2,
   source_ref2_        IN  VARCHAR2,
   source_ref3_        IN  VARCHAR2,
   source_ref4_        IN  VARCHAR2,
   source_ref_type_db_ IN  VARCHAR2 )
IS
BEGIN
   IF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PURCH_RECEIPT_RETURN) THEN 
      Error_SYS.Record_General(lu_name_, 'RELRESRECRET: Releasing of reservation is restricted for shipment lines created for Purchase Receipt Return.');
   ELSIF (source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER) THEN 
      IF (Shipment_Source_Utility_API.Get_Demand_Code_Db(source_ref1_, source_ref2_, source_ref3_, source_ref4_, source_ref_type_db_) = Order_Supply_Type_API.DB_PURCHASE_RECEIPT) THEN
         Error_SYS.Record_General(lu_name_, 'RELRESPURRECSO: Releasing of reservation is restricted for shipment lines connected to Purchase Receipt.');
      END IF;   
   END IF;
END Validate_Rel_Reservations___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Validate_Reassign_Shipment__ (
   shipment_id_         IN NUMBER,
   rowstate_            IN VARCHAR2,
   shipment_category_   IN VARCHAR2 )
IS  
BEGIN
   IF (shipment_category_ != 'NORMAL') THEN
      Error_Sys.Record_General(lu_name_, 'DESTSHIPCATE: The shipment :P1 must be of category normal.', shipment_id_);
   END IF;
   
   IF ((rowstate_ NOT IN('Preliminary', 'Completed')) OR (Shipment_API.Shipment_Delivered(shipment_id_) = 'TRUE'))  THEN
      Error_Sys.Record_General(lu_name_, 'SOURCESHIPMENTST: Shipment quantity can only be reassigned to a preliminary shipment or a completed shipment not delivered.');
   END IF;
END Validate_Reassign_Shipment__;


PROCEDURE Clear_Temporary_Table__
IS
BEGIN
   DELETE FROM reassign_ship_component_tmp;
END Clear_Temporary_Table__;

-- Reassign_Reservations__
--   Called to reassign reservation lines.
PROCEDURE Reassign_Reservations__ (
   info_                         OUT VARCHAR2,
   qty_picked_in_ship_inventory_ OUT VARCHAR2,
   shipment_id_                  IN  NUMBER,
   shipment_line_no_             IN  NUMBER,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   source_ref_type_db_           IN  VARCHAR2, 
   new_shipment_id_              IN  NUMBER,
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,   
   message_                      IN  VARCHAR2,
   release_reservations_         IN  VARCHAR2 )
IS
   name_arr_                Message_SYS.name_table;
   value_arr_               Message_SYS.line_table;
   count_                   NUMBER;
   location_no_             VARCHAR2(35);
   lot_batch_no_            VARCHAR2(20);
   serial_no_               VARCHAR2(50);
   eng_chg_level_           VARCHAR2(6);
   waiv_dev_rej_no_         VARCHAR2(15);
   activity_seq_            NUMBER;
   handling_unit_id_        NUMBER;
   ship_handling_unit_id_   NUMBER;
   shipment_reserv_qty_     NUMBER;
   pick_list_no_            VARCHAR2(15);
   configuration_id_        VARCHAR2(50);
   catch_qty_to_reassign_   NUMBER := 0;
   qty_to_reassign_         NUMBER := 0;
   do_release_reservations_ BOOLEAN := FALSE;
   sales_qty_to_reassign_   NUMBER;
   shipment_line_rec_       Shipment_Line_API.Public_Rec;
   
   CURSOR get_handling_unit IS
      SELECT handling_unit_id, quantity
      FROM shipment_reserv_handl_unit_tab
      WHERE source_ref1      = source_ref1_
        AND source_ref2      = source_ref2_
        AND source_ref3      = source_ref3_
        AND source_ref4      = source_ref4_
        AND contract         = contract_
        AND part_no          = part_no_
        AND location_no      = location_no_
        AND lot_batch_no     = lot_batch_no_
        AND serial_no        = serial_no_
        AND eng_chg_level    = eng_chg_level_
        AND waiv_dev_rej_no  = waiv_dev_rej_no_
        AND activity_seq     = activity_seq_
        AND reserv_handling_unit_id = handling_unit_id_
        AND configuration_id = configuration_id_
        AND pick_list_no     = pick_list_no_ 
        AND shipment_id      = shipment_id_
        AND shipment_line_no = shipment_line_no_;
BEGIN
   qty_picked_in_ship_inventory_ := 'FALSE';

   IF (release_reservations_ = 'TRUE') THEN   
      do_release_reservations_ := TRUE;
   END IF;
   
   shipment_line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_);

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR i_ IN 1..count_ LOOP
      IF (name_arr_(i_) = 'LOCATION_NO') THEN
         location_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'SERIAL_NO') THEN
         serial_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'ACTIVITY_SEQ') THEN
         activity_seq_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'PICK_LIST_NO') THEN
         pick_list_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'CATCH_QTY_TO_REASSIGN') THEN
         catch_qty_to_reassign_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'QTY_TO_REASSIGN') THEN
         qty_to_reassign_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
         
         OPEN get_handling_unit;
         FETCH get_handling_unit INTO ship_handling_unit_id_, shipment_reserv_qty_;
         IF get_handling_unit%FOUND THEN
            FETCH get_handling_unit INTO ship_handling_unit_id_, shipment_reserv_qty_;
            IF get_handling_unit%NOTFOUND THEN
               sales_qty_to_reassign_  := (LEAST(qty_to_reassign_, shipment_reserv_qty_) * shipment_line_rec_.inverted_conv_factor / shipment_line_rec_.conv_factor);
               -- If the reservation is connected to a unique handling unit, reduce quantity that is to be removed due to reassign, from the quantity of shipment_line_handl_unit_tab
               Shipment_Line_Handl_Unit_API.Reduce_Quantity(shipment_id_, shipment_line_no_, ship_handling_unit_id_, sales_qty_to_reassign_, 'FALSE');
            END IF;
         END IF;
         CLOSE get_handling_unit;
         
         -- call the source specific reassignment method
         Reassign_Connected_Reserve_Qty(qty_picked_in_ship_inventory_ => qty_picked_in_ship_inventory_,
                                        source_ref1_                  => source_ref1_,
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
                                        handling_unit_id_             => handling_unit_id_,
                                        pick_list_no_                 => pick_list_no_,
                                        configuration_id_             => configuration_id_,
                                        shipment_id_                  => shipment_id_,
                                        new_shipment_id_              => new_shipment_id_,  
                                        release_reservations_         => do_release_reservations_,
                                        qty_to_reassign_              => qty_to_reassign_,
                                        catch_qty_to_reassign_        => catch_qty_to_reassign_,
                                        reassignment_type_            => 'CONNECTED_QUANTITY');

      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(i_));
      END IF;
   END LOOP;

   info_ := Client_SYS.Get_All_Info;
END Reassign_Reservations__;


PROCEDURE Reassign_Pkg_Comp_Qty__ (
   info_                         OUT VARCHAR2,
   qty_picked_in_ship_inventory_ OUT VARCHAR2,
   shipment_id_                  IN  NUMBER,
   shipment_line_no_             IN  NUMBER,
   order_no_                     IN  VARCHAR2,
   line_no_                      IN  VARCHAR2,
   rel_no_                       IN  VARCHAR2,
   contract_                     IN  VARCHAR2, 
   new_shipment_id_              IN  NUMBER,
   pkg_qty_to_reassign_          IN  NUMBER,
   pkg_reserved_qty_to_reassign_ IN  NUMBER,
   pkg_revised_qty_reassigned_   IN  NUMBER,
   message_                      IN  VARCHAR2,
   release_reservations_         IN  VARCHAR2,
   do_complete_                  IN  VARCHAR2 )
IS
   name_arr_                   Message_SYS.name_table;
   value_arr_                  Message_SYS.line_table;
   count_                      NUMBER;
   location_no_                VARCHAR2(35);
   lot_batch_no_               VARCHAR2(20);
   serial_no_                  VARCHAR2(50);
   eng_chg_level_              VARCHAR2(6);
   waiv_dev_rej_no_            VARCHAR2(15);
   activity_seq_               NUMBER;
   handling_unit_id_           NUMBER;
   pick_list_no_               VARCHAR2(15);
   configuration_id_           VARCHAR2(50);
   inventory_part_no_          VARCHAR2(25);
   source_ref4_                shipment_line_tab.source_ref4%TYPE;
   catch_qty_to_reassign_      NUMBER := 0;
   qty_to_reassign_            NUMBER := 0;
   do_release_reservations_    BOOLEAN := FALSE;
   reservation_                VARCHAR2(5) := 'FALSE';
   qty_to_ship_reassigned_     NUMBER := 0;  
BEGIN
   qty_picked_in_ship_inventory_ := 'FALSE';
   IF (release_reservations_ = 'TRUE') THEN   
      do_release_reservations_ := TRUE;
   END IF;

   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR i_ IN 1..count_ LOOP
      IF (name_arr_(i_) = 'SOURCE_REF4') THEN
         source_ref4_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'QTY_TO_REASSIGN') THEN
         qty_to_reassign_  := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'RESERVATION') THEN
         reservation_ := value_arr_(i_);

         IF (reservation_ = 'FALSE') THEN
            Fill_Temporary_Table___( source_ref4_               => source_ref4_,
                                     contract_                  => NULL,
                                     inventory_part_no_         => NULL,
                                     location_no_               => NULL,
                                     lot_batch_no_              => NULL,
                                     serial_no_                 => NULL,
                                     eng_chg_level_             => NULL,
                                     waiv_dev_rej_no_           => NULL,
                                     activity_seq_              => NULL,
                                     handling_unit_id_          => NULL,
                                     pick_list_no_              => NULL,
                                     configuration_id_          => NULL,
                                     not_reserved_to_reassign_  => qty_to_reassign_,
                                     reserved_to_reassign_      => NULL,
                                     catch_qty_                 => NULL); 
            GOTO next_row; 
         END IF;
      ELSIF (name_arr_(i_) = 'INVENTORY_PART_NO') THEN
         inventory_part_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'LOCATION_NO') THEN
         location_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'LOT_BATCH_NO') THEN
         lot_batch_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'SERIAL_NO') THEN
         serial_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'ENG_CHG_LEVEL') THEN
         eng_chg_level_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'WAIV_DEV_REJ_NO') THEN
         waiv_dev_rej_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'ACTIVITY_SEQ') THEN
         activity_seq_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'HANDLING_UNIT_ID') THEN
         handling_unit_id_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));
      ELSIF (name_arr_(i_) = 'PICK_LIST_NO') THEN
         pick_list_no_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'CONFIGURATION_ID') THEN
         configuration_id_ := value_arr_(i_);
      ELSIF (name_arr_(i_) = 'CATCH_QTY_TO_REASSIGN') THEN
         catch_qty_to_reassign_ := Client_SYS.Attr_Value_To_Number(value_arr_(i_));

         Fill_Temporary_Table___( source_ref4_               => source_ref4_,
                                  contract_                  => contract_,
                                  inventory_part_no_         => inventory_part_no_,
                                  location_no_               => location_no_,
                                  lot_batch_no_              => lot_batch_no_,
                                  serial_no_                 => serial_no_,
                                  eng_chg_level_             => eng_chg_level_,
                                  waiv_dev_rej_no_           => waiv_dev_rej_no_,
                                  activity_seq_              => activity_seq_,
                                  handling_unit_id_          => handling_unit_id_,
                                  pick_list_no_              => pick_list_no_,
                                  configuration_id_          => configuration_id_,
                                  not_reserved_to_reassign_  => NULL,
                                  reserved_to_reassign_      => qty_to_reassign_,
                                  catch_qty_                 => catch_qty_to_reassign_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'INCORRECT_MESSAGE: Item :P1 can not be used in this method.', name_arr_(i_));
      END IF;
      <<next_row>>
      NULL;
   END LOOP;

   IF (do_complete_ = 'TRUE') THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         Reassign_Shipment_Pkg_Line___(qty_picked_in_ship_inventory_,
                                       order_no_,
                                       line_no_,
                                       rel_no_,
                                       shipment_id_,
                                       new_shipment_id_,
                                       do_release_reservations_,
                                       pkg_qty_to_reassign_,
                                       pkg_reserved_qty_to_reassign_);
      $END 
      Shipment_Line_API.Complete_Pkg_Reassignment__(shipment_id_,
                                                    shipment_line_no_,
                                                    new_shipment_id_,
                                                    order_no_,
                                                    line_no_,
                                                    rel_no_,
                                                    -1,
                                                    pkg_revised_qty_reassigned_,
                                                    qty_to_ship_reassigned_,
                                                    'CONNECTED_QUANTITY');
   END IF;

   info_ := Client_SYS.Get_All_Info;
END Reassign_Pkg_Comp_Qty__;

-- Reassign_Connected_Qty__
--   Reassign a Shipment Line where line item no = 0 or -1
PROCEDURE Reassign_Connected_Qty__ (
   info_                     OUT    VARCHAR2,
   new_shipment_id_          IN OUT NUMBER,
   shipment_id_              IN     NUMBER,
   shipment_line_no_         IN     NUMBER,
   not_reserved_to_reassign_ IN     NUMBER,
   reserved_to_reassign_     IN     NUMBER,
   qty_to_reassign_          IN     NUMBER,
   destination_              IN     VARCHAR2,
   source_shipment_state_    IN     VARCHAR2 )
IS
   hu_info_                   VARCHAR2(2000); 
   new_quantity_at_source_    NUMBER:=0;
   qty_to_ship_               NUMBER:=0;
   shipment_line_rec_         Shipment_Line_API.Public_Rec; 
   qty_modification_source_   VARCHAR2(20):= 'CONNECTED_QUANTITY';
   customer_order_pkg_line_   BOOLEAN:=FALSE;
BEGIN
   Shipment_Line_API.Lock__(shipment_id_, shipment_line_no_);
   
   shipment_line_rec_ := Shipment_Line_API.Get(shipment_id_, shipment_line_no_); 
   IF ((shipment_line_rec_.source_ref_type = Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) AND
       (Utility_SYS.String_To_Number(shipment_line_rec_.source_ref4) = -1)) THEN
      customer_order_pkg_line_ := TRUE;
   END IF;
   
   IF ((destination_ = 'ADD_TO_EXIST_SHIPMENT') AND (Shipment_API.Get_Auto_Connection_Blocked_Db(new_shipment_id_) = 'TRUE')) THEN
      Client_SYS.Add_Warning(lu_name_, 'SHIPBLOCKED: The shipment is blocked for automatic connection of more source lines. Do you still want to connect more lines manually?');
   END IF;
   
   IF (NVL(qty_to_reassign_, 0) <= 0) THEN
      Error_Sys.Record_General(lu_name_, 'QTYTOREASSIGNZERO: Quantity to Reassign must be greater than 0.');
   END IF;

   IF (NVL(not_reserved_to_reassign_, 0) < 0) THEN
      Error_Sys.Record_General(lu_name_, 'NOTREVERSEDREASSIGN: Not Reserved to Reassign cannot be negative.');
   END IF;
   
   Validate_Reassign_Shipment__(shipment_id_, source_shipment_state_, Shipment_API.Get_Shipment_Category_Db(shipment_id_));
   
   IF (not_reserved_to_reassign_ > (shipment_line_rec_.inventory_qty - shipment_line_rec_.qty_assigned)) THEN
      Error_Sys.Record_General(lu_name_, 'NOTRESNOTAVAIL: The Not Reserved to Reassign quantity may not be greater than the quantity available.');
   END IF;

   IF (reserved_to_reassign_ > shipment_line_rec_.qty_assigned) THEN
      Error_Sys.Record_General(lu_name_, 'RESNOTAVAIL: The reserved quantity to reassign may not be greater than the quantity available.');
   END IF;
   
   new_quantity_at_source_ := shipment_line_rec_.inventory_qty - qty_to_reassign_;       
   IF (ROUND(new_quantity_at_source_, 20) != 0) THEN
      Shipment_Line_Handl_Unit_API.Remove_Or_Modify(info_             => hu_info_,
                                                 shipment_id_      => shipment_id_,
                                                 shipment_line_no_ => shipment_line_no_,                         
                                                 new_quantity_     => new_quantity_at_source_,
                                                 only_check_       => TRUE );
   END IF;
   
   info_ := hu_info_ || Client_SYS.Get_All_Info;
   
   IF (shipment_line_rec_.qty_to_ship > 0) THEN
      qty_to_ship_ := Get_Qty_To_Ship_Reassign___(qty_to_reassign_, shipment_line_rec_.qty_to_ship, shipment_line_rec_.connected_source_qty);
   END IF;
   
   -- Create new shipment or add the line to existing destination shipment
   IF (destination_ IN ('CREATE_NEW_SHIPMENT', 'ADD_TO_EXIST_SHIPMENT')) THEN
      Reassign_Line___(new_shipment_id_,
                       shipment_id_,
                       shipment_line_no_,
                       shipment_line_rec_.source_ref1,
                       shipment_line_rec_.source_ref2,
                       shipment_line_rec_.source_ref3,
                       shipment_line_rec_.source_ref4,
                       shipment_line_rec_.source_ref_type,
                       destination_,
                       qty_to_reassign_,
                       qty_to_ship_ );
   END IF;
   
   -- reduce the not reserved qty reassigned from source shipment
   IF ((not_reserved_to_reassign_ > 0) AND (NOT(customer_order_pkg_line_))) THEN
      Shipment_Line_API.Update_Source_On_Reassign__(shipment_id_, shipment_line_no_, not_reserved_to_reassign_, 
                                                    qty_to_ship_, qty_modification_source_ );
   END IF;
   
   Reset_Printed_On_Reassign_Line___(new_shipment_id_, shipment_id_);
   
   info_ := info_ || Client_SYS.Get_All_Info;

   -- if called for PKG part clear the temp table used to reassign component lines
   IF (customer_order_pkg_line_) THEN
      Clear_Temporary_Table__;
   END IF;

END Reassign_Connected_Qty__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Validate_Reassign_To_Ship (
   destination_shipment_id_ IN NUMBER,
   source_shipment_id_      IN NUMBER )
IS
   source_ship_rec_       Shipment_API.Public_Rec;
   destination_ship_rec_  Shipment_API.Public_Rec;
   shipment_found_        NUMBER;
   same_country_          VARCHAR2(5):= Fnd_Boolean_API.DB_FALSE;  
   
   CURSOR get_valid_dest_shipment IS
      SELECT 1
      FROM   shipment_tab source, shipment_tab dest
      WHERE  source.shipment_id            = source_shipment_id_
      AND    dest.shipment_id              = destination_shipment_id_ 
      AND    source.shipment_type          = dest.shipment_type
      AND    NVL(source.receiver_address_name,  Database_SYS.string_null_) =  NVL(dest.receiver_address_name,  Database_SYS.string_null_)
      AND    NVL(source.receiver_address1,      Database_SYS.string_null_) =  NVL(dest.receiver_address1,      Database_SYS.string_null_)  
      AND    NVL(source.receiver_address2,      Database_SYS.string_null_) =  NVL(dest.receiver_address2,      Database_SYS.string_null_)  
      AND    NVL(source.receiver_address3,      Database_SYS.string_null_) =  NVL(dest.receiver_address3,      Database_SYS.string_null_)  
      AND    NVL(source.receiver_address4,      Database_SYS.string_null_) =  NVL(dest.receiver_address4,      Database_SYS.string_null_)  
      AND    NVL(source.receiver_address5,      Database_SYS.string_null_) =  NVL(dest.receiver_address5,      Database_SYS.string_null_)  
      AND    NVL(source.receiver_address6,      Database_SYS.string_null_) =  NVL(dest.receiver_address6,      Database_SYS.string_null_)  
      AND    NVL(source.receiver_city ,         Database_SYS.string_null_) =  NVL(dest.receiver_city ,         Database_SYS.string_null_)  
      AND    NVL(source.receiver_state,         Database_SYS.string_null_) =  NVL(dest.receiver_state,         Database_SYS.string_null_)  
      AND    NVL(source.receiver_zip_code,      Database_SYS.string_null_) =  NVL(dest.receiver_zip_code,      Database_SYS.string_null_)  
      AND    NVL(source.receiver_county,        Database_SYS.string_null_) =  NVL(dest.receiver_county,        Database_SYS.string_null_)  
      AND    NVL(source.receiver_country,       Database_SYS.string_null_) =  NVL(dest.receiver_country,       Database_SYS.string_null_)
      AND    NVL(source.ship_via_code,          Database_SYS.string_null_) =  NVL(dest.ship_via_code,          Database_SYS.string_null_) 
      AND    NVL(source.delivery_terms,         Database_SYS.string_null_) =  NVL(dest.delivery_terms,         Database_SYS.string_null_)
      AND    NVL(source.customs_value_currency, Database_SYS.string_null_) =  NVL(dest.customs_value_currency, Database_SYS.string_null_) 
      AND    ((NVL(source.source_ref_type,      Database_SYS.string_null_) =  NVL(dest.source_ref_type,        Database_SYS.string_null_))
              OR (dest.source_ref_type IS NULL))  
      AND    source.contract    = dest.contract
      AND    ((source.addr_flag = 'Y' AND source.addr_flag = dest.addr_flag) OR
              (source.addr_flag = 'N' AND source.addr_flag = dest.addr_flag AND source.receiver_addr_id = dest.receiver_addr_id)); 
BEGIN      
   IF (destination_shipment_id_ IS NULL) THEN
      Error_Sys.Record_General(lu_name_, 'DESTSHIPIDNULL: When reassigning to other shipment a shipment ID must be specified.');
   END IF;
   
   Shipment_API.Exist(destination_shipment_id_);

   source_ship_rec_      := Shipment_API.Get(source_shipment_id_);
   destination_ship_rec_ := Shipment_API.Get(destination_shipment_id_);   
  
   IF (NVL(Shipment_Source_Utility_API.Get_Supply_Country_Db(source_shipment_id_), Database_SYS.string_null_) = NVL(Shipment_Source_Utility_API.Get_Supply_Country_Db(destination_shipment_id_), Database_SYS.string_null_)) THEN
      same_country_ := Fnd_Boolean_API.DB_TRUE;
   END IF;   
   Validate_Reassign_Shipment__(destination_shipment_id_, destination_ship_rec_.rowstate, destination_ship_rec_.shipment_category);
      
   IF (destination_shipment_id_ = source_shipment_id_)  THEN
      Error_Sys.Record_General(lu_name_, 'SOURCEDESTSAME: You cannot reassign a quantity from one shipment to the same shipment.');
   END IF;
   
   OPEN get_valid_dest_shipment;   
   FETCH get_valid_dest_shipment INTO shipment_found_; 
   IF (source_ship_rec_.sender_type != destination_ship_rec_.sender_type OR source_ship_rec_.sender_id != destination_ship_rec_.sender_id OR
      source_ship_rec_.receiver_type != destination_ship_rec_.receiver_type OR source_ship_rec_.receiver_id != destination_ship_rec_.receiver_id) THEN
      CLOSE get_valid_dest_shipment;
      Error_SYS.Record_General(lu_name_, 'INVALIDSENRECINFO: Either sender type, sender ID, receiver type or receiver ID does not match between the two shipments.');
   END IF;
   IF ((get_valid_dest_shipment%FOUND AND (same_country_ = Fnd_Boolean_API.DB_FALSE)) OR (get_valid_dest_shipment%NOTFOUND))  THEN
      CLOSE get_valid_dest_shipment;
      Error_Sys.Record_General(lu_name_, 'INVALIDDELIVINFO: Either delivery address, ship-via code, delivery terms, shipment type, source ref type or customs value currency does not match between the two shipments.');   
   END IF;      
   CLOSE get_valid_dest_shipment;
   
   IF (Shipment_Source_Utility_API.Get_Use_Price_Incl_Tax_Db(source_shipment_id_) != Shipment_Source_Utility_API.Get_Use_Price_Incl_Tax_Db(destination_shipment_id_)) THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDPRINCLTAX: Price including tax information does not match between the two shipments.');
   END IF;   
   
END Validate_Reassign_To_Ship;


PROCEDURE Reassign_Hu_Structure (
   info_                 OUT    VARCHAR2,
   to_shipment_id_       IN OUT NUMBER,
   from_shipment_id_     IN     NUMBER,
   handling_unit_id_     IN     NUMBER,
   release_reservations_ IN     VARCHAR2,
   destination_          IN     VARCHAR2 )
IS
BEGIN
   Reassign_Hu_Structure___(to_shipment_id_, from_shipment_id_, handling_unit_id_, release_reservations_, destination_);
   info_ := Client_SYS.Get_All_Info;
END Reassign_Hu_Structure;


PROCEDURE Reassign_Hu_Structure (
   to_shipment_id_       IN OUT NUMBER,
   from_shipment_id_     IN     NUMBER,
   handling_unit_id_     IN     NUMBER,
   release_reservations_ IN     VARCHAR2,
   destination_          IN     VARCHAR2 )
IS
BEGIN
   Reassign_Hu_Structure___(to_shipment_id_, from_shipment_id_, handling_unit_id_, release_reservations_, destination_);
END Reassign_Hu_Structure;


PROCEDURE Reassign_Handling_Unit (
   from_shipment_id_     IN NUMBER,
   to_shipment_id_       IN NUMBER,
   handling_unit_id_     IN NUMBER,
   release_reservations_ IN BOOLEAN )
IS
   sum_qty_reserved_             NUMBER := 0;  
   qty_to_reserve_on_handl_unit_ NUMBER := 0;
   err_text_1_                   VARCHAR2(2000);
   err_text_2_                   VARCHAR2(2000);
   qty_reassigned_               NUMBER := 0;
   qty_picked_                   NUMBER := 0;
   from_shipment_line_rec_       Shipment_Line_API.Public_Rec;
   inv_qty_on_handling_unit_     NUMBER := 0;
   inv_qty_to_use_               NUMBER := 0;
   qty_to_attach_                NUMBER := 0;
   reservations_attached_        VARCHAR2(5) := 'FALSE';
   qty_to_ship_reassign_         NUMBER := 0;
   to_shipment_line_no_          NUMBER;
   contract_                     VARCHAR2(5); 
   
   CURSOR get_connected_lines IS
      SELECT sl.shipment_line_no, sl.source_ref1, sl.source_ref2, sl.source_ref3, sl.source_ref4, 
             sl.source_ref_type, sl.inventory_part_no, sl.source_part_no, sl.source_part_description, 
             sl.source_unit_meas, sl.conv_factor, sl.inverted_conv_factor, slhu.quantity, slhu.manual_net_weight,
             sl.customs_value
      FROM   SHIPMENT_LINE_HANDL_UNIT_TAB slhu, SHIPMENT_LINE_TAB sl
      WHERE  slhu.handling_unit_id = handling_unit_id_
      AND    slhu.shipment_id      = from_shipment_id_
      AND    slhu.shipment_id      = sl.shipment_id
      AND    slhu.shipment_line_no = sl.shipment_line_no;
BEGIN
   App_Context_SYS.Set_Value('SHIPMENT_LINE_REASSIGNING_','TRUE');
   contract_ := Shipment_API.Get_Contract(to_shipment_id_);
   FOR connected_rec_ IN get_connected_lines LOOP
      
      Shipment_Source_Utility_API.Validate_Reassign_Hu(connected_rec_.source_ref1,
                                                       connected_rec_.source_ref2,
                                                       connected_rec_.source_ref3,
                                                       connected_rec_.source_ref4,
                                                       connected_rec_.source_ref_type,
                                                       handling_unit_id_,
                                                       connected_rec_.source_part_no);
 
      IF (NVL(Company_Site_API.Get_Country_Db(contract_), Database_SYS.string_null_) != NVL(Shipment_Source_Utility_API.Get_Source_Supply_Country_Db(connected_rec_.source_ref1, contract_, connected_rec_.source_ref_type), Database_SYS.string_null_)) THEN
         Error_SYS.Record_General(lu_name_, 'SUPPCOUNTRYMISMATCH: Supply country of the shipment source does not match with the site country. '||
                                            'Shipment is not created for this source.');
      END IF;      
      
      from_shipment_line_rec_       := Shipment_Line_API.Get(from_shipment_id_, connected_rec_.shipment_line_no);
          
      sum_qty_reserved_             := Shipment_Reserv_Handl_Unit_API.Get_Line_Attached_Qty(connected_rec_.source_ref1,
                                                                                            NVL(connected_rec_.source_ref2,'*'),
                                                                                            NVL(connected_rec_.source_ref3,'*'),
                                                                                            NVL(connected_rec_.source_ref4,'*'),                                                                                                 
                                                                                            from_shipment_id_,
                                                                                            connected_rec_.shipment_line_no,
                                                                                            handling_unit_id_);
                                                                                              
      inv_qty_on_handling_unit_     := Shipment_Handling_Utility_API.Get_Converted_Inv_Qty(from_shipment_id_, 
                                                                                           connected_rec_.shipment_line_no,
                                                                                           connected_rec_.quantity,
                                                                                           connected_rec_.conv_factor,
                                                                                           connected_rec_.inverted_conv_factor);
      
      inv_qty_to_use_               := inv_qty_on_handling_unit_;
      qty_to_reserve_on_handl_unit_ := inv_qty_on_handling_unit_ - sum_qty_reserved_;
      qty_to_attach_                := (from_shipment_line_rec_.qty_assigned - sum_qty_reserved_) - (from_shipment_line_rec_.inventory_qty - inv_qty_on_handling_unit_);

      IF (qty_to_attach_ > 0) THEN
         Shipment_Reserv_Handl_Unit_API.Add_Reservations_On_Reassign(reservations_attached_,
                                                                     connected_rec_.source_ref1,
                                                                     NVL(connected_rec_.source_ref2,'*'),
                                                                     NVL(connected_rec_.source_ref3,'*'),
                                                                     NVL(connected_rec_.source_ref4,'*'),
                                                                     connected_rec_.source_ref_type,
                                                                     from_shipment_id_,
                                                                     connected_rec_.shipment_line_no,
                                                                     handling_unit_id_,
                                                                     qty_to_attach_);
         IF (reservations_attached_ = 'FALSE') THEN
            err_text_1_ := Language_SYS.Translate_Constant(lu_name_,
                                                           'NOTENOUGHRESERVEDQTY: At least an additional reserved quantity of :P1 must be attached to the handling unit :P2 for part :P3',
                                                           NULL,
                                                           qty_to_attach_,
                                                           handling_unit_id_,
                                                           connected_rec_.inventory_part_no);
            err_text_2_ := Language_SYS.Translate_Constant(lu_name_,
                                                           'NOTENOUGHRESVEDLINE: on shipment line :P1.',
                                                           NULL,
                                                           connected_rec_.shipment_line_no);
            Raise_General_Error___(err_text_1_, err_text_2_); 
         END IF;
      END IF;

      Shipment_Line_Handl_Unit_API.Lock__(from_shipment_id_, connected_rec_.shipment_line_no, handling_unit_id_ );

      IF (from_shipment_line_rec_.qty_to_ship > 0) THEN
         qty_to_ship_reassign_ := Get_Qty_To_Ship_Reassign___(connected_rec_.quantity, from_shipment_line_rec_.qty_to_ship, from_shipment_line_rec_.connected_source_qty);
      END IF;
      
      -- reasssign to the destination shipment with total qty to reassign (reserved and not reserved)
      Shipment_Line_API.Reassign_Line__(to_shipment_line_no_, 
                                        from_shipment_id_,
                                        to_shipment_id_, 
                                        connected_rec_.source_ref1,
                                        connected_rec_.source_ref2,
                                        connected_rec_.source_ref3,
                                        connected_rec_.source_ref4, 
                                        connected_rec_.source_ref_type,
                                        connected_rec_.source_part_no,
                                        connected_rec_.source_part_description,
                                        connected_rec_.inventory_part_no,
                                        connected_rec_.source_unit_meas,
                                        connected_rec_.conv_factor,
                                        connected_rec_.inverted_conv_factor,                                       
                                        inv_qty_to_use_,
                                        qty_to_ship_reassign_,
                                        'HANDLING_UNIT',
                                        connected_rec_.customs_value);
      -- Create new HU and attach connected qty
      Shipment_Line_Handl_Unit_API.New(to_shipment_id_, 
                                       to_shipment_line_no_,
                                       handling_unit_id_, 
                                       connected_rec_.quantity,
                                       TRUE,
                                       FALSE,
                                       connected_rec_.manual_net_weight);

      -- transfer reservations 
      IF (connected_rec_.inventory_part_no IS NOT NULL) THEN
         Shipment_Reserv_Handl_Unit_API.Reassign_Handl_Unit(qty_reassigned_,
                                                            qty_picked_,
                                                            connected_rec_.source_ref1,
                                                            NVL(connected_rec_.source_ref2,'*'),
                                                            NVL(connected_rec_.source_ref3,'*'),
                                                            NVL(connected_rec_.source_ref4,'*'),                                                                  
                                                            handling_unit_id_,
                                                            from_shipment_id_,
                                                            connected_rec_.shipment_line_no,
                                                            to_shipment_id_, 
                                                            to_shipment_line_no_,
                                                            release_reservations_ );
      END IF;

      -- Remove the source HU
      IF (Shipment_Line_Handl_Unit_API.Exists (from_shipment_id_, connected_rec_.shipment_line_no, handling_unit_id_)) THEN
         Shipment_Line_Handl_Unit_API.Remove(from_shipment_id_,
                                             connected_rec_.shipment_line_no,
                                             handling_unit_id_,
                                             TRUE);
      END IF;

      IF ((inv_qty_to_use_ - qty_reassigned_) > 0) THEN
         -- reduce the not reserved qty from source shipment line 
         Shipment_Line_API.Update_Source_On_Reassign__(from_shipment_id_, 
                                                       connected_rec_.shipment_line_no,                                        
                                                       (inv_qty_to_use_ - qty_reassigned_),
                                                       qty_to_ship_reassign_,
                                                       'HANDLING_UNIT' );
      END IF;
   END LOOP;
   
   Reset_Printed_On_Reassign_Line___(to_shipment_id_, from_shipment_id_);
   
END Reassign_Handling_Unit;


PROCEDURE Reassign_Connected_Reserve_Qty (
   qty_picked_in_ship_inventory_ OUT VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   source_ref_type_db_           IN  VARCHAR2, 
   contract_                     IN  VARCHAR2,
   part_no_                      IN  VARCHAR2,
   location_no_                  IN  VARCHAR2,
   lot_batch_no_                 IN  VARCHAR2,
   serial_no_                    IN  VARCHAR2,
   eng_chg_level_                IN  VARCHAR2,
   waiv_dev_rej_no_              IN  VARCHAR2,
   activity_seq_                 IN  NUMBER,
   handling_unit_id_             IN  NUMBER,
   pick_list_no_                 IN  VARCHAR2,
   configuration_id_             IN  VARCHAR2,
   shipment_id_                  IN  NUMBER,
   new_shipment_id_              IN  NUMBER,  
   release_reservations_         IN  BOOLEAN,
   qty_to_reassign_              IN  NUMBER,
   catch_qty_to_reassign_        IN  NUMBER,  
   reassignment_type_            IN  VARCHAR2 )
IS  
   ship_invent_line_       VARCHAR2(5) := 'FALSE';
   local_handling_unit_id_ NUMBER := handling_unit_id_;
   info_                   VARCHAR2(2000);
BEGIN
   qty_picked_in_ship_inventory_ := 'FALSE';

   -- If what we're reassigning is in Shipment Inventory and in a HU we
   -- unpack it by removing the ShipmentReservHandlUnit-record(s) so that the HU itself stays on the original shipment
   -- and the content is moved out of the HU (handling_unit_id = 0) onto the new shipment.
   IF (handling_unit_id_ != 0 AND reassignment_type_ != 'HANDLING_UNIT' AND 
      Inventory_Location_API.Get_Location_Type_Db(contract_, location_no_) = Inventory_Location_Type_API.DB_SHIPMENT) THEN
 
      Shipment_Reserv_Handl_Unit_API.Remove_Or_Modify_Reservation(info_                      => info_,
                                                                  source_ref1_               => source_ref1_, 
                                                                  source_ref2_               => NVL(source_ref2_,'*'), 
                                                                  source_ref3_               => NVL(source_ref3_,'*'), 
                                                                  source_ref4_               => NVL(source_ref4_,'*'), 
                                                                  source_ref_type_db_        => source_ref_type_db_,
                                                                  contract_                  => contract_, 
                                                                  part_no_                   => part_no_, 
                                                                  location_no_               => location_no_, 
                                                                  lot_batch_no_              => lot_batch_no_, 
                                                                  serial_no_                 => serial_no_, 
                                                                  eng_chg_level_             => eng_chg_level_, 
                                                                  waiv_dev_rej_no_           => waiv_dev_rej_no_, 
                                                                  activity_seq_              => activity_seq_, 
                                                                  reserv_handling_unit_id_   => local_handling_unit_id_, 
                                                                  configuration_id_          => configuration_id_, 
                                                                  pick_list_no_              => pick_list_no_, 
                                                                  shipment_id_               => shipment_id_, 
                                                                  quantity_to_remove_        => qty_to_reassign_);

      local_handling_unit_id_ := 0;
   END IF;

   IF (release_reservations_ ) THEN
      Release_Reservations___(ship_invent_line_,
                              source_ref1_,                 
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
                              local_handling_unit_id_,
                              pick_list_no_,
                              configuration_id_,
                              shipment_id_,
                              new_shipment_id_,
                              qty_to_reassign_,
                              catch_qty_to_reassign_,
                              reassignment_type_ ); 
      IF (ship_invent_line_ = 'TRUE') THEN
         qty_picked_in_ship_inventory_ := 'TRUE';
      END IF;
   ELSE
      Reserve_Shipment_API.Move_Shipment_Reservation(source_ref1_,                 
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
                                                     local_handling_unit_id_,
                                                     pick_list_no_,
                                                     configuration_id_,
                                                     shipment_id_,
                                                     new_shipment_id_,
                                                     qty_to_reassign_,
                                                     catch_qty_to_reassign_,
                                                     reassignment_type_ );
   END IF;
END Reassign_Connected_Reserve_Qty;


-- Validate_Reassign_Reservation
--   This method includes the validations applicable when reassigning a reservation line.
PROCEDURE Validate_Reassign_Reserve (
   qty_to_reassign_           IN NUMBER,
   catch_qty_to_reassign_     IN NUMBER,
   reassignment_type_         IN VARCHAR2,
   qty_assigned_              IN NUMBER,
   pick_list_no_              IN VARCHAR2,
   qty_picked_                IN NUMBER,
   catch_qty_                 IN NUMBER,
   new_shipment_id_           IN NUMBER,
   source_ref_type_db_        IN VARCHAR2 )
IS  
BEGIN
   IF (((NVL(reassignment_type_, Database_SYS.string_null_) = 'CONNECTED_QUANTITY') AND (qty_assigned_ < qty_to_reassign_))
      OR ((NVL(reassignment_type_, Database_SYS.string_null_) = 'HANDLING_UNIT') AND (qty_assigned_ = 0))) THEN
      Error_SYS.Record_General(lu_name_, 'QTYRESNOTAVAIL: Reserved qty is not available for reassign.');
   END IF;
   
   IF ((NVL(reassignment_type_, Database_SYS.string_null_) = 'CONNECTED_QUANTITY') AND (pick_list_no_ != '*' AND qty_assigned_ > qty_picked_)) THEN
      Error_Sys.Record_General(lu_name_, 'PICKLISTEXITS: Pick list must be reported in order to be able to reassign the reservation.');
   END IF;

   IF ((NVL(catch_qty_, 0) > 0) AND (NVL(catch_qty_to_reassign_, 0) = 0)) THEN
      Error_SYS.Record_General(lu_name_, 'CATCHQTYZERO: The catch quantity to reassign must be specified.');
   END IF;

   IF ((NVL(catch_qty_to_reassign_, 0)) >  (NVL(catch_qty_, 0))) THEN
      Error_SYS.Record_General(lu_name_, 'CATCHQTGREATTHENPICK: You cannot reassign more catch quantity than the catch quantity pick reported.');
   END IF;
   
   IF ((new_shipment_id_ = 0) AND (qty_picked_ > 0)) THEN
      IF ((source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_PROJECT_DELIVERABLES)) THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTDELPICKPD: Project deliverable shipment lines which are already picked cannot be released from the shipment.');
      END IF;
      IF ((source_ref_type_db_ = Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER)) THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTDELPICKSO: Shipment order lines which are already picked cannot be released from the shipment.');
      END IF;
   END IF;
   
END Validate_Reassign_Reserve;
